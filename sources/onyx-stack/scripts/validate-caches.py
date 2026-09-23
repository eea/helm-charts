#!/usr/bin/env python3
"""Validate the HF / tiktoken / NLTK cache wiring of the onyx-stack workloads.

Two modes:

  render  Check the output of `helm template` (no cluster needed). Run before
          a deploy / in CI.
            scripts/validate-caches.py render -f my-values.yaml [--set k=v]

  live    Check the Deployments/StatefulSets of a release as they exist in the
          cluster (catches manual patches), then exec into one running pod per
          workload and check what the process really sees: the directories exist,
          are writable volumes, hold the baked-in data, and that huggingface_hub /
          tiktoken / nltk resolve to them.
            KUBECONFIG=... scripts/validate-caches.py live -n gptlab2

Exit code is 1 when any FAIL is reported.
"""
import argparse
import json
import os
import subprocess
import sys

CACHE_VARS = ["HF_HOME", "TIKTOKEN_CACHE_DIR", "NLTK_DATA", "XDG_CACHE_HOME"]
# cache volume name -> env var that must point at its mountPath
CACHE_VOLUMES = {"hf-cache": "HF_HOME", "tiktoken-cache": "TIKTOKEN_CACHE_DIR", "nltk-cache": "NLTK_DATA"}
INIT_NAME = "hf-cache-init"

results = []


def short(name):
    """onyx-onyx-stack-api-server:api-server -> api-server"""
    name = name.split("/", 1)[-1].replace("onyx-onyx-stack-", "").replace("onyx-", "")
    wl, _, c = name.partition(":")
    return wl if not c or c.startswith(wl) or wl.startswith(c) or wl.endswith(c) else name


def report(level, workload, check, detail):
    results.append(level)
    print(f"  [{level:4}] {short(workload):38} {check:19} {detail}")


def run(cmd, stdin=None, check=True):
    p = subprocess.run(cmd, input=stdin, capture_output=True, text=True)
    if check and p.returncode != 0:
        sys.exit(f"command failed: {' '.join(cmd)}\n{p.stderr}")
    return p


# --------------------------------------------------------------------------- spec checks

def pod_spec(obj):
    if obj["kind"] == "CronJob":
        return obj["spec"]["jobTemplate"]["spec"]["template"]["spec"]
    return obj["spec"]["template"]["spec"]


def resolve_env(container, configmaps):
    env = {}
    for src in container.get("envFrom") or []:
        cm = (src.get("configMapRef") or {}).get("name")
        env.update(configmaps.get(cm, {}))
    for e in container.get("env") or []:
        if "value" in e:
            env[e["name"]] = e["value"]
        elif "valueFrom" in e:
            env[e["name"]] = "<from secret/field>"
        else:
            env[e["name"]] = ""
    return env


def check_specs(objects, configmaps):
    """Static checks on pod specs. Returns {workload: [container names with caches]}."""
    paths_seen = {}  # var -> {path: [workloads]}
    targets = {}
    for obj in objects:
        wl = f"{obj['kind'].lower()}/{obj['metadata']['name']}"
        spec = pod_spec(obj)
        vols = {v["name"] for v in spec.get("volumes") or []}
        inits = {c["name"]: c for c in spec.get("initContainers") or []}
        for c in spec.get("containers") or []:
            env = resolve_env(c, configmaps)
            mounts = {m["mountPath"].rstrip("/") or "/": m["name"] for m in c.get("volumeMounts") or []}
            by_vol = {name: path for path, name in mounts.items()}
            ro_root = (c.get("securityContext") or {}).get("readOnlyRootFilesystem", False)
            name = f"{wl}:{c['name']}"
            uses_cache = any(env.get(v) for v in CACHE_VARS) or any(v in by_vol for v in CACHE_VOLUMES)
            if not uses_cache:
                continue
            targets.setdefault(obj["metadata"]["name"], []).append(c["name"])

            # every cache env var must live on a volume, otherwise writes hit the image root
            for var in CACHE_VARS:
                path = (env.get(var) or "").rstrip("/")
                if not path:
                    continue
                paths_seen.setdefault(var, {}).setdefault(path, []).append(obj["metadata"]["name"])
                covered = [mp for mp in mounts if path == mp or path.startswith(mp + "/")]
                if covered:
                    report("PASS", name, var, f"{path} on volume '{mounts[max(covered, key=len)]}'")
                else:
                    report("FAIL" if ro_root else "WARN", name, var,
                           f"{path} is not on any volume (readOnlyRootFilesystem={ro_root})")

            # every cache volume must be what its env var points at, or the libs ignore it
            for vol, var in CACHE_VOLUMES.items():
                if vol not in by_vol:
                    continue
                mp = by_vol[vol]
                if (env.get(var) or "").rstrip("/") != mp:
                    report("FAIL", name, vol, f"mounted at {mp} but {var}={env.get(var) or '<unset>'}")

            # cache volumes should be seeded by the init container
            cache_vols = {v for v in CACHE_VOLUMES if v in by_vol}
            if cache_vols:
                init = inits.get(INIT_NAME)
                seeded = {m["name"] for m in (init or {}).get("volumeMounts") or []}
                missing = cache_vols - seeded
                if missing:
                    report("FAIL", name, "seed", f"{sorted(missing)} not seeded by {INIT_NAME}")
                if init and init.get("image") != c.get("image"):
                    report("WARN", name, "seed", f"{INIT_NAME} image {init.get('image')} != container image")
            for v in cache_vols - vols:
                report("FAIL", name, "volume", f"'{v}' mounted but not declared in pod volumes")

    # all services should agree on the location of each cache
    for var, paths in paths_seen.items():
        if len(paths) > 1:
            detail = "; ".join(f"{p} ({len(w)} workloads: {', '.join(sorted(w)[:3])}{'…' if len(w) > 3 else ''})"
                               for p, w in paths.items())
            report("WARN", "(all workloads)", var, f"paths differ: {detail}")
    return targets


# --------------------------------------------------------------------------- in-pod probe

PROBE = r'''
ro_root=no; (touch /.cache-probe 2>/dev/null && rm -f /.cache-probe) || ro_root=yes
echo "INFO|user|uid=$(id -u) HOME=${HOME:-<unset>} readOnlyRoot=$ro_root"
is_mount() { awk -v p="$1" '$2==p{f=1} END{exit !f}' /proc/mounts; }
check_dir() {
  var=$1; path=$2; want_content=$3
  [ -z "$path" ] && return
  if [ ! -d "$path" ]; then echo "FAIL|$var|$path does not exist"; return; fi
  w=no; (touch "$path/.cache-probe" 2>/dev/null && rm -f "$path/.cache-probe") && w=yes
  m=no; is_mount "$path" && m=yes
  n=$(ls -A "$path" 2>/dev/null | wc -l | tr -d ' ')
  lvl=PASS
  [ "$w" = no ] && lvl=FAIL
  [ "$lvl" = PASS ] && [ "$n" = 0 ] && [ "$want_content" = yes ] && lvl=WARN
  echo "$lvl|$var|$path writable=$w mount=$m entries=$n"
}
check_dir HF_HOME "$HF_HOME" yes
check_dir TIKTOKEN_CACHE_DIR "$TIKTOKEN_CACHE_DIR" yes
check_dir NLTK_DATA "$NLTK_DATA" no
check_dir XDG_CACHE_HOME "$XDG_CACHE_HOME" no
hc=$(printf '%s' "${XDG_CACHE_HOME:-${HOME:-/}/.cache}" | sed 's#//*#/#g')
if [ -d "$hc" ] && (touch "$hc/.cache-probe" 2>/dev/null && rm -f "$hc/.cache-probe"); then
  echo "PASS|~/.cache|$hc writable"
else
  echo "WARN|~/.cache|$hc not writable (anything writing ~/.cache will fail)"
fi
PY=$(command -v python3 || command -v python)
[ -z "$PY" ] && { echo "INFO|python|not available, library checks skipped"; exit 0; }
cd /app 2>/dev/null
"$PY" - <<'EOF'
import hashlib, os
def out(l, c, d): print(f"{l}|{c}|{d}")
try:
    from huggingface_hub import constants as hc
    hub, home = hc.HF_HUB_CACHE, os.environ.get("HF_HOME")
    ok = not home or hub.startswith(home)
    out("PASS" if ok else "FAIL", "hf resolves", f"HF_HUB_CACHE={hub} offline={hc.HF_HUB_OFFLINE}")
    if os.path.isdir(hub):
        models = sorted(d[8:].replace("--", "/") for d in os.listdir(hub) if d.startswith("models--"))
        out("INFO" if models else "WARN", "hf models", ", ".join(models) or "none cached")
        for m in models:
            snaps = os.path.join(hub, "models--" + m.replace("/", "--"), "snapshots")
            if not os.path.isdir(snaps) or not os.listdir(snaps):
                out("WARN", "hf models", f"{m}: no snapshots")
except ImportError:
    pass
try:
    import tiktoken  # noqa: F401
    d = os.environ.get("TIKTOKEN_CACHE_DIR") or os.environ.get("DATA_GYM_CACHE_DIR")
    if not d:
        out("WARN", "tiktoken resolves", "TIKTOKEN_CACHE_DIR unset -> downloads to /tmp/data-gym-cache at runtime")
    else:
        base = "https://openaipublic.blob.core.windows.net/encodings/"
        have = [e for e in ("cl100k_base", "o200k_base")
                if os.path.exists(os.path.join(d, hashlib.sha1((base + e + ".tiktoken").encode()).hexdigest()))]
        out("PASS" if have else "WARN", "tiktoken resolves", f"{d} encodings={','.join(have) or 'none cached'}")
except ImportError:
    pass
try:
    import nltk
    first, want = nltk.data.path[0], os.environ.get("NLTK_DATA")
    out("PASS" if not want or first == want else "FAIL", "nltk resolves", f"search path starts at {first}")
    found = []
    for r in ("corpora/stopwords", "tokenizers/punkt_tab", "tokenizers/punkt"):
        try:
            nltk.data.find(r); found.append(r)
        except LookupError:
            pass
    out("INFO" if found else "WARN", "nltk data", ", ".join(found) or "no stopwords/punkt found")
except ImportError:
    if os.environ.get("NLTK_DATA"):
        out("WARN", "nltk resolves", "NLTK_DATA set but nltk package not installed")
EOF
'''


def probe_live(ns, kubectl, workloads, targets):
    for obj in workloads:
        name = obj["metadata"]["name"]
        if name not in targets:
            continue
        sel = ",".join(f"{k}={v}" for k, v in obj["spec"]["selector"]["matchLabels"].items())
        pods = json.loads(run(kubectl + ["get", "pods", "-n", ns, "-l", sel, "-o", "json"]).stdout)["items"]
        ready = [p for p in pods if p["status"].get("phase") == "Running"
                 and all(cs.get("ready") for cs in p["status"].get("containerStatuses", []))]
        if not ready:
            report("INFO", name, "probe", "no ready pod (scaled to 0?), skipped")
            continue
        pod = ready[0]["metadata"]["name"]
        for cname in targets[name]:
            wl = f"{name}:{cname}"
            p = run(kubectl + ["exec", "-i", "-n", ns, pod, "-c", cname, "--", "sh", "-s"], stdin=PROBE, check=False)
            if p.returncode != 0 and not p.stdout:
                report("FAIL", wl, "probe", f"exec failed: {p.stderr.strip()[:150]}")
                continue
            for line in p.stdout.splitlines():
                parts = line.split("|", 2)
                if len(parts) == 3:
                    report(parts[0], wl, parts[1], parts[2])
        # did the init container actually find data to seed?
        spec_inits = [c["name"] for c in pod_spec(obj).get("initContainers") or []]
        if INIT_NAME in spec_inits:
            logs = run(kubectl + ["logs", "-n", ns, pod, "-c", INIT_NAME], check=False).stdout
            for line in logs.splitlines():
                if "skipping" in line:
                    report("WARN", f"{name}:{INIT_NAME}", "seed", line.strip())


# --------------------------------------------------------------------------- modes

def load_rendered(args):
    import yaml
    chart = args.chart or os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    cmd = ["helm", "template", args.release, chart, "-n", args.namespace]
    for f in args.values or []:
        cmd += ["-f", f]
    for s in args.set or []:
        cmd += ["--set", s]
    docs = [d for d in yaml.safe_load_all(run(cmd).stdout) if d]
    cms = {d["metadata"]["name"]: {k: str(v) for k, v in (d.get("data") or {}).items()}
           for d in docs if d["kind"] == "ConfigMap"}
    wls = [d for d in docs if d["kind"] in ("Deployment", "StatefulSet", "CronJob")]
    return wls, cms


def load_live(args, kubectl):
    items = json.loads(run(kubectl + ["get", "deploy,sts,cronjob", "-n", args.namespace, "-o", "json"]).stdout)["items"]
    wls = [o for o in items
           if (o["metadata"].get("annotations") or {}).get("meta.helm.sh/release-name") == args.release]
    cm_items = json.loads(run(kubectl + ["get", "cm", "-n", args.namespace, "-o", "json"]).stdout)["items"]
    cms = {c["metadata"]["name"]: c.get("data") or {} for c in cm_items}
    return wls, cms


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("mode", choices=["render", "live"])
    ap.add_argument("-n", "--namespace", default="default")
    ap.add_argument("--release", default="onyx")
    ap.add_argument("--context", help="kubectl context (live mode)")
    ap.add_argument("--chart", help="chart dir (render mode, default: this chart)")
    ap.add_argument("-f", "--values", action="append", help="values file (render mode, repeatable)")
    ap.add_argument("--set", action="append", help="helm --set (render mode, repeatable)")
    ap.add_argument("--no-probe", action="store_true", help="live mode: only check the pod specs")
    args = ap.parse_args()

    kubectl = ["kubectl"] + (["--context", args.context] if args.context else [])
    if args.mode == "render":
        print(f"== spec checks: helm template ({args.release}, ns={args.namespace})")
        wls, cms = load_rendered(args)
        check_specs(wls, cms)
    else:
        print(f"== spec checks: live workloads of release '{args.release}' in {args.namespace}")
        wls, cms = load_live(args, kubectl)
        targets = check_specs(wls, cms)
        if not args.no_probe:
            print("\n== in-pod checks")
            probe_live(args.namespace, kubectl, wls, targets)

    fails, warns = results.count("FAIL"), results.count("WARN")
    print(f"\n{fails} FAIL, {warns} WARN, {results.count('PASS')} PASS")
    sys.exit(1 if fails else 0)


if __name__ == "__main__":
    main()
