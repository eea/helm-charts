import http.server
import json
import os
import re
import threading
import time
import urllib.parse
import urllib.request

DISCODATA_URL = os.environ.get("DISCODATA_URL", "https://discodata.eea.europa.eu/sql")
REFRESH_INTERVAL = int(os.environ.get("REFRESH_INTERVAL_SECONDS", str(6 * 60 * 60)))
FETCH_TIMEOUT = int(os.environ.get("FETCH_TIMEOUT_SECONDS", "60"))
STARTUP_WAIT_SECONDS = int(os.environ.get("STARTUP_WAIT_SECONDS", "60"))

# FILTERS is a JSON list of {"name", "pattern", "query"}:
#   pattern - regex on the request path; group 1 is the object id
#   query   - discodata SQL returning the allowed ids in a column named "id"
FILTERS = [
    {"name": f["name"], "pattern": re.compile(f["pattern"]), "query": f["query"]}
    for f in json.loads(os.environ["FILTERS"])
]

# name -> set of ids. A missing entry means "not loaded yet / discodata
# unreachable" - fail open (allow all) for that object type rather than block
# every request when the source API is down.
allowed_ids = {}
allowed_ids_lock = threading.Lock()


def fetch_allowed_ids(query):
    url = DISCODATA_URL + "?" + urllib.parse.urlencode(
        {"query": query, "p": 1, "nrOfHits": 500000, "mail": "null", "schema": "null"}
    )
    with urllib.request.urlopen(url, timeout=FETCH_TIMEOUT) as resp:
        result = json.load(resp)
    return {
        str(item["id"])
        for item in result["results"]
        if item.get("id") is not None
    }


def refresh_loop(name, query):
    delay = 5
    while True:
        try:
            ids = fetch_allowed_ids(query)
            with allowed_ids_lock:
                allowed_ids[name] = ids
            print(f"gatekeeper: loaded {len(ids)} {name} ids", flush=True)
            delay = 5
            time.sleep(REFRESH_INTERVAL)
        except Exception as exc:
            print(f"gatekeeper: {name} fetch failed: {exc}", flush=True)
            time.sleep(delay)
            delay = min(delay * 2, REFRESH_INTERVAL)


def is_allowed(path):
    for f in FILTERS:
        match = f["pattern"].match(path)
        if match:
            with allowed_ids_lock:
                ids = allowed_ids.get(f["name"])
            return ids is None or urllib.parse.unquote(match.group(1)) in ids
    return True


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
        # ingress-nginx's auth-url subrequest sends the full original URL in
        # X-Original-URL (scheme://host/path), not a bare path in
        # X-Original-URI - handle both since urlsplit().path works for either.
        original = self.headers.get("X-Original-URL") or self.headers.get("X-Original-URI", "")
        original_path = urllib.parse.urlsplit(original).path
        self.send_response(200 if is_allowed(original_path) else 403)
        self.end_headers()

    def log_message(self, format, *args):
        pass


if __name__ == "__main__":
    port = int(os.environ.get("PORT", "8080"))

    for f in FILTERS:
        threading.Thread(target=refresh_loop, args=(f["name"], f["query"]), daemon=True).start()

    # Give the first fetches a head start so the gatekeeper can start enforcing
    # the allow-lists right away, without blocking startup indefinitely if
    # discodata is unreachable (refresh_loop keeps retrying in the background).
    deadline = time.time() + STARTUP_WAIT_SECONDS
    while len(allowed_ids) < len(FILTERS) and time.time() < deadline:
        time.sleep(1)

    http.server.ThreadingHTTPServer(("0.0.0.0", port), Handler).serve_forever()
