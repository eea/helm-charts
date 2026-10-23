import http.server
import json
import os
import re
import threading
import time
import urllib.request

SPECIES_PATH_RE = re.compile(r"^/species/(\d+)(?:/|$)")

DISCODATA_URL = os.environ.get(
    "DISCODATA_URL",
    "https://discodata.eea.europa.eu/sql?query="
    "select%20id_eunis%20from%20EUNIS.latest.species_information&"
    "p=1&nrOfHits=500000&mail=null&schema=null",
)
REFRESH_INTERVAL = int(os.environ.get("REFRESH_INTERVAL_SECONDS", str(6 * 60 * 60)))
FETCH_TIMEOUT = int(os.environ.get("FETCH_TIMEOUT_SECONDS", "30"))
STARTUP_WAIT_SECONDS = int(os.environ.get("STARTUP_WAIT_SECONDS", "60"))

# None means "not loaded yet / discodata unreachable" - fail open (allow all)
# rather than block every /species/ request when the source API is down.
allowed_ids = None
allowed_ids_lock = threading.Lock()


def fetch_allowed_ids():
    with urllib.request.urlopen(DISCODATA_URL, timeout=FETCH_TIMEOUT) as resp:
        result = json.load(resp)
    return {
        str(item["id_eunis"])
        for item in result["results"]
        if item.get("id_eunis") is not None
    }


def refresh_loop():
    global allowed_ids
    delay = 5
    while True:
        try:
            ids = fetch_allowed_ids()
            with allowed_ids_lock:
                allowed_ids = ids
            print(f"species-gatekeeper: loaded {len(ids)} species ids", flush=True)
            delay = 5
            time.sleep(REFRESH_INTERVAL)
        except Exception as exc:
            print(f"species-gatekeeper: fetch failed: {exc}", flush=True)
            time.sleep(delay)
            delay = min(delay * 2, REFRESH_INTERVAL)


class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.check()

    def do_HEAD(self):
        self.check()

    def check(self):
        if self.path == "/healthz":
            self.send_response(200)
            self.end_headers()
            return
        original_uri = self.headers.get("X-Original-URI", "")
        match = SPECIES_PATH_RE.match(original_uri)
        with allowed_ids_lock:
            ids = allowed_ids
        if match and ids is not None and match.group(1) not in ids:
            self.send_response(403)
        else:
            self.send_response(200)
        self.end_headers()

    def log_message(self, format, *args):
        pass


if __name__ == "__main__":
    port = int(os.environ.get("PORT", "8080"))

    threading.Thread(target=refresh_loop, daemon=True).start()

    # Give the first fetch a head start so the gatekeeper can start enforcing
    # the allow-list right away, without blocking startup indefinitely if
    # discodata is unreachable (refresh_loop keeps retrying in the background).
    deadline = time.time() + STARTUP_WAIT_SECONDS
    while allowed_ids is None and time.time() < deadline:
        time.sleep(1)

    http.server.HTTPServer(("0.0.0.0", port), Handler).serve_forever()
