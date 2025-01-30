import hashlib
import math
import os
import time
from typing import Dict, Optional, Tuple

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
    TASK_QUEUE = "{}-tasks".format(QUEUE)
    REDIS_HOST = os.environ.get(
        "CELERY_BACKEND_URL", "redis://celery-redis"
    ).split("redis://")[-1]
    REDIS_PORT = 6379
    FWD_ENDPOINT = os.environ.get("FWD_ENDPOINT", "forwardState")

    CREDENTIALS = {}  # type: Dict[str, Dict[str, str]]
    DEPLOYMENT_MAPPING = {
        "CDR": {
            "DEV": "cdrdev",
            "TEST": "cdrtest",
            "SANDBOX": "cdrsandbox",
            "PROD": "cdr",
        },
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
    """Acquire a Redis lock with timeout."""
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
def process_envelope(env):
    # type: (str) -> None
    """Process envelope with proper error handling."""
    env_url_hexdigest = hashlib.md5(env.encode("utf-8")).hexdigest()
    lock_id = "{}-lock".format(env_url_hexdigest)

    acquired = acquire_lock_with_timeout(
        redis_client, lock_id, acquire_timeout=1
    )
    if not acquired:
        print("Locked! Already processing: {}".format(env))
        return

    try:
        auth = get_auth(env)
        trigger_url = "{}/{}".format(env, Config.FWD_ENDPOINT)

        response = requests.get(trigger_url, auth=auth, timeout=Config.TIMEOUT)

        if response.ok:
            info = response.json()
            print("ForwardState response: {}".format(info))

            forwarded = info.get("forwarded")
            triggered = info.get("triggered")
            triggerable = info.get("triggerable")

            if forwarded:
                print(
                    "Successfully forwarded {} for {}".format(forwarded, env)
                )
            if triggered:
                print(
                    "Successfully triggered {} for {}".format(triggered, env)
                )
            if not triggerable:
                print("No more triggerable app for {}".format(env))

        elif response.status_code == 404:
            print(
                "Received: {}. Abandoning envelope: {}".format(
                    response.status_code, env
                )
            )
        else:
            raise HTTPNotOKError(
                "Envelope forwarding failed for: {} with http status code: {}. "
                "Re-scheduling".format(env, response.status_code)
            )

    finally:
        release_lock.signature(
            (lock_id, acquired),
            countdown=2,
            retry=True,
        ).apply_async()


@message_handler(Config.QUEUE)
def handle_env_forwarding(message):
    # type: (str) -> None
    """Handle envelope forwarding messages."""
    try:
        env, countdown = message.split("|")
        print("Should process: {} in {}s".format(env, countdown))
    except ValueError:
        env = message
        countdown = Config.RETRY_INTERVAL
        print("No countdown specified for message: {}".format(message))
        print("Using default countdown: {}s".format(countdown))

    process_envelope.signature(
        (env,),
        countdown=int(countdown),
        retry=True,
    ).apply_async()


# Initialize credentials on module load
load_credentials()
