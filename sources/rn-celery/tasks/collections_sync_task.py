import hashlib
import math
import os
import time
from typing import Dict, List, Optional, Tuple

import redis
import requests
from event_consumer.conf import settings
from redis.exceptions import LockError, RedisError
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
    REDIS_PORT = int(os.environ.get("REDIS_PORT", 6379))
    COL_SYNC_DEPL = os.environ.get(
        "COL_SYNC_DEPL",
        "http://localhost:8000",
    ).split(",")

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
def trigger_col_sync(data):
    # type: (Tuple[str, str]) -> None
    """Trigger collection synchronization."""
    url, col = data
    col_url_hexdigest = hashlib.md5(
        "{}{}".format(url, col).encode("utf-8")
    ).hexdigest()
    lock_id = "{}-lock".format(col_url_hexdigest)

    acquired = acquire_lock_with_timeout(
        redis_client, lock_id, acquire_timeout=1
    )
    if not acquired:
        print("Locked")
        return

    try:
        auth = get_auth(url)
        headers = {"Accept": "application/json"}
        sync_data = {"collection": col}

        response = requests.post(
            url,
            headers=headers,
            data=sync_data,
            auth=auth,
            timeout=Config.TIMEOUT,
        )

        if response.ok:
            info = response.json()
            print("Sync collection response: {}".format(info))
        else:
            print(
                "Unable to trigger collection sync on: {} for: {} "
                "with auth: {} and due to {}".format(
                    url, col, auth, response.status_code
                )
            )
            raise HTTPNotOKError(
                "Request on {} for {} sync, got a {} HTTP status code. "
                "Re-scheduling".format(url, col, response.status_code)
            )

    except LockError:
        print("Locked! Already syncing: {}".format(col))

    finally:
        release_lock.signature(
            (lock_id, acquired),
            countdown=2,
            retry=True,
        ).apply_async()


@message_handler(Config.QUEUE)
def collections_sync(message):
    # type: (str) -> None
    """Handle collection sync messages."""
    col_data = []  # type: List[Tuple[str, str]]

    for depl in Config.COL_SYNC_DEPL:
        url = "{}/ReportekEngine/sync_collection".format(depl)
        col_data.append((url, message))

    for data in col_data:
        print("Should trigger collection sync for: {}".format(data))
        trigger_col_sync.signature(
            (data,),
            countdown=2,
            retry=True,
        ).apply_async()


# Initialize credentials on module load
load_credentials()
