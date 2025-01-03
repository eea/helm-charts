import os
from typing import Dict, List, Optional, Tuple

import requests
from event_consumer.conf import settings


class Config:
    """Config class."""

    RETRY_INTERVAL = int(os.environ.get("RETRY_INTERVAL", 120))
    MAX_RETRIES = int(os.environ.get("MAX_RETRIES", 1000))
    TIMEOUT = int(os.environ.get("TIMEOUT", 30))
    QUEUE = os.environ.get("QUEUE", "cr_queue")
    TASK_QUEUE = "{}-tasks".format(QUEUE)


# Update settings
app.conf.task_default_queue = Config.TASK_QUEUE
settings.MAX_RETRIES = Config.MAX_RETRIES
settings.BACKOFF_FUNC = lambda x: Config.RETRY_INTERVAL


class URLError(Exception):
    """Custom exception for URL-related errors."""


def build_url(service, uri, create=False):
    # type: (str, str, bool) -> str
    """Helper function to construct URLs.

    Args:
        service: Base service URL
        uri: URI to append
        create: Whether to add create flag

    Returns:
        Constructed URL string
    """
    params = ["uri={}".format(uri)]
    if create:
        params.append("create=True")

    query_string = "&".join(params)
    return "{}?{}".format(service, query_string)


@app.task(
    autoretry_for=(Exception,),
    max_retries=settings.MAX_RETRIES,
    default_retry_delay=Config.RETRY_INTERVAL,
)
def do_cr_ping(url):
    # type: (str) -> str
    """Execute ping request with proper error handling.

    Args:
        url: URL to ping

    Returns:
        Response content as string

    Raises:
        URLError: If request fails or returns unexpected response
    """
    try:
        print(
            "Try: {}/{} | Requesting URL: {}".format(
                do_cr_ping.request.retries, do_cr_ping.max_retries, url
            )
        )

        response = requests.get(url, timeout=Config.TIMEOUT)
        response.raise_for_status()
        content = response.text

        # Handle case where URL is not in catalog
        if (
            "URL not in catalogue of sources" in content
            and "create" not in url
        ):
            url = build_url(
                service=url.split("?")[0],
                uri=url.split("uri=")[1].split("&")[0],
                create=True,
            )

            response = requests.get(url, timeout=Config.TIMEOUT)
            response.raise_for_status()
            content = response.text

        print(
            "Try: {}/{} | Ping {} with result: {}".format(
                do_cr_ping.request.retries,
                do_cr_ping.max_retries,
                url,
                content,
            )
        )
        return content

    except requests.exceptions.RequestException as e:
        print("Request failed: {}".format(e))
        raise URLError("Failed to ping URL: {}".format(url))
    except Exception as e:
        print("Unexpected error: {}".format(e))
        raise


@message_handler(Config.QUEUE)
def ping(message):
    # type: (str) -> None
    """Handle ping messages.

    Message format: "action|service|uri"
    Where action can be 'create' or something else

    Args:
        message: Formatted message string
    """
    try:
        action, service, uri = message.split("|")
    except ValueError as e:
        print("Invalid message format: {}".format(message))
        print("Expected format: 'action|service|uri'")
        raise

    url = build_url(service, uri, create=(action == "create"))

    print("Should trigger ping for: {}".format(url))
    do_cr_ping.signature((url,), countdown=0, retry=True).apply_async()
