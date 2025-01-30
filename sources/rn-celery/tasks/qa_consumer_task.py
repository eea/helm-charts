import hashlib
import json
import math
import os
import time
from typing import Any, Dict, Optional, Tuple  # Python 3.7 compatible imports

import redis
import requests
from event_consumer.conf import settings
from redis.exceptions import RedisError
from requests.exceptions import RequestException


class Config:
    """Config class."""

    RETRY_INTERVAL = int(os.environ.get("RETRY_INTERVAL", 120))
    CACHE_LOCK_EXPIRE = RETRY_INTERVAL / 2
    MAX_RETRIES = int(os.environ.get("MAX_RETRIES", 1000))
    TIMEOUT = int(os.environ.get("TIMEOUT", 30))
    QUEUE = os.environ.get("QUEUE", "converters")
    RESULTS_QUEUE = "{}_results_queue".format(
        QUEUE
    )  # Python 3.7 compatible string format
    DEAD_LETTER_QUEUE = "{}_dead_letter_queue".format(QUEUE)
    TASK_QUEUE = "{}-tasks".format(QUEUE)
    REDIS_HOST = os.environ.get(
        "CELERY_BACKEND_URL", "redis://celery-redis"
    ).split("redis://")[-1]
    REDIS_PORT = 6379
    FWD_ENDPOINT = os.environ.get("FWD_ENDPOINT", "forwardState")

    CREDENTIALS = {}  # type: Dict[str, Dict[str, str]]
    DEPLOYMENT_MAPPING = {
        "CDR": {"DEV": "cdrdev", "TEST": "cdrtest", "SANDBOX": "cdrsandbox"},
        "BDR": {"DEV": "bdr-dev", "TEST": "bdr-test", "PROD": "bdr"},
        "MDR": {"TEST": "mdr-test", "PROD": "mdr"},
    }


# Update settings
app.conf.task_default_queue = Config.TASK_QUEUE
settings.MAX_RETRIES = Config.MAX_RETRIES
settings.BACKOFF_FUNC = lambda x: Config.RETRY_INTERVAL
redis_client = redis.Redis(host=Config.REDIS_HOST, port=Config.REDIS_PORT)


class HTTPNotOKError(Exception):
    """Custom exception for non-200 HTTP responses."""


def load_credentials():
    # type: () -> None
    """Load credentials from environment variables."""
    for prefix, env_mappings in Config.DEPLOYMENT_MAPPING.items():
        for env_key, deployment_name in env_mappings.items():
            user = os.environ.get("{}_{}_USER".format(prefix, env_key), "")
            password = os.environ.get("{}_{}_PASS".format(prefix, env_key), "")

            if user or password:
                Config.CREDENTIALS[deployment_name] = {
                    "USER": user,
                    "PASS": password,
                }


def get_auth(env):
    # type: (str) -> Tuple[str, str]
    """Get authentication credentials for given environment."""
    deployment = env.split("://")[-1].split(".")[0]
    dep_creds = Config.CREDENTIALS.get(deployment, {})
    return (dep_creds.get("USER", ""), dep_creds.get("PASS", ""))


def acquire_lock_with_timeout(
    conn, lock_name, acquire_timeout=3, lock_timeout=2
):
    # type: (redis.Redis, str, int, int) -> Optional[str]
    """Acquire a Redis lock."""
    identifier = "locked"
    lockname = "lock:{}".format(lock_name)
    lock_timeout = int(math.ceil(lock_timeout))

    end = time.time() + acquire_timeout
    while time.time() < end:
        if conn.set(lockname, identifier, ex=lock_timeout, nx=True):
            return identifier
        time.sleep(0.001)

    return False


@app.task(
    autoretry_for=(Exception,),
    max_retries=settings.MAX_RETRIES,
    default_retry_delay=Config.RETRY_INTERVAL,
)
def release_lock(lock_name, identifier):
    # type: (str, str) -> bool
    """Release a Redis lock."""
    unlock_script = """
    if redis.call("get",KEYS[1]) == ARGV[1] then
        return redis.call("del",KEYS[1])
    else
        return 0
    end
    """
    lockname = "lock:{}".format(lock_name)
    unlock = redis_client.register_script(unlock_script)
    return bool(unlock(keys=[lockname], args=[identifier]))


@app.task(
    autoretry_for=(RequestException, RedisError, HTTPNotOKError),
    max_retries=settings.MAX_RETRIES,
    default_retry_delay=Config.RETRY_INTERVAL,
)
def process_qa_result(env, payload):
    # type: (str, Dict[str, Any]) -> None
    """Process QA result with retries handled by celery-message-consumer."""
    job_id = hashlib.md5(json.dumps(payload).encode("utf-8")).hexdigest()
    lock_id = "{}-lock".format(job_id)

    acquired = acquire_lock_with_timeout(
        redis_client, lock_id, acquire_timeout=1
    )
    if not acquired:
        print("Locked")
        return

    try:
        url = "{}/{}".format(env, Config.FWD_ENDPOINT).replace(
            "http://", "https://"
        )
        auth = get_auth(url)

        response = requests.post(
            url,
            headers={
                "Accept": "application/json",
                "Content-type": "application/json",
            },
            data=json.dumps(payload),
            auth=auth,
            timeout=Config.TIMEOUT,
        )

        print(
            "POST to: {} with payload: {} got a {} response".format(
                url, payload, response.status_code
            )
        )

        if response.ok:
            try:
                info = response.json()
                print("ForwardState response: {}".format(info))
            except ValueError:
                print("Response: {}".format(response.content))
        elif response.status_code == 404:
            print(
                "Received: {}. Abandoning envelope: {}".format(
                    response.status_code, url
                )
            )
        else:
            raise HTTPNotOKError(
                "Request failed with status {}".format(response.status_code)
            )

    finally:
        release_lock.signature(
            (lock_id, acquired),
            countdown=2,
            retry=True,
        ).apply_async()


def get_envelope_url(payload):
    # type: (Dict[str, Any]) -> Optional[str]
    """Extract envelope URL from payload."""
    resource = payload.get("documentURL")
    envelope = payload.get("envelopeUrl")

    if not (resource or envelope):
        return None

    if resource:
        if "source_url=" in resource:
            resource = resource.split("source_url=")[-1]
        return "://".join(
            [
                resource.split("://")[0],
                "/".join(resource.split("://")[-1].split("/")[:-1]),
            ]
        )
    return envelope


@message_handler(Config.RESULTS_QUEUE)
def handle_qa_results(payload):
    # type: (Dict[str, Any]) -> None
    """Handle QA results."""
    url = get_envelope_url(payload)
    if url:
        process_qa_result.signature(
            (url, payload),
            countdown=3,
            retry=True,
        ).apply_async()


@message_handler(Config.DEAD_LETTER_QUEUE)
def handle_qa_dead_letter(payload):
    # type: (Dict[str, Any]) -> None
    """Handle failed and abandoned QA requests."""
    url = get_envelope_url(payload)
    if url:
        if not payload.get("errorMessage"):
            payload["errorMessage"] = (
                "QA service marked the QA process as failed"
            )
        process_qa_result.signature(
            (url, payload),
            countdown=3,
            retry=True,
        ).apply_async()


# Initialize credentials on module load
load_credentials()
