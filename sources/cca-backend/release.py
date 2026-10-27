#!/usr/bin/env python3
"""Non-interactive release for the cca-backend chart.

Scripted equivalent of the repo's three-step manual release:

    release.sh -> increase_version_helm.sh -> update_docs.sh

Same effects, same commit shape, same changelog shape - but every input comes
from a flag or an environment variable, so it can be driven from a terminal, a
Makefile or CI without a TTY.

Run it from anywhere; paths are resolved from this file's location.

    ./release.py -m "bump converter to v1.0.8" --bump PATCH          # dry run
    ./release.py -m "bump converter to v1.0.8" --bump PATCH --publish

Dry run is the default. Nothing is written, committed or pushed without
--publish.

Environment variables understood (same names the shell scripts use):
    HELM_VERSION_TYPE        PATCH | MINOR | MAJOR
    HELM_UPGRADE_MESSAGE     changelog line + release commit message
    HELM_COMMIT_MESSAGE      message for the chart-only commit
    HELM_ADD_COMMIT_LINK_README   "yes" (default) | "no"
"""

from __future__ import annotations

import argparse
import os
import re
import shutil
import subprocess
import sys
from datetime import date
from pathlib import Path

CHART_DIR = Path(__file__).resolve().parent
REPO_ROOT = CHART_DIR.parent.parent
CHART_NAME = CHART_DIR.name
REL_CHART = CHART_DIR.relative_to(REPO_ROOT)

MONTHS = "January February March April May June July August September October November December".split()

# Cheap local guard so a token never rides along into a public chart package.
# CI has betterleaks; this is only the seatbelt.
SECRET_PATTERNS = [
    (r"(?i)^\+\s*[A-Z_]*(TOKEN|SECRET|PASSWORD|PASSWD|DSN|APIKEY|API_KEY)[A-Z_]*\s*[:=]\s*['\"]?[^\s'\"]{8,}", "credential-looking assignment"),
    (r"\bAKIA[0-9A-Z]{16}\b", "AWS access key id"),
    (r"-----BEGIN [A-Z ]*PRIVATE KEY-----", "private key"),
    (r"(?i)^\+.*://[^:/\s]+:([^@/\s]{6,})@", "URL with embedded password"),
]


class ReleaseError(Exception):
    pass


def run(args, cwd=REPO_ROOT, capture=True, check=True, env=None):
    """Run a command, echoing it, and return stdout."""
    print(f"  $ {' '.join(args)}")
    proc = subprocess.run(
        args, cwd=str(cwd), capture_output=capture, text=True, env=env
    )
    if check and proc.returncode != 0:
        out = (proc.stdout or "") + (proc.stderr or "")
        raise ReleaseError(f"command failed ({proc.returncode}): {' '.join(args)}\n{out.strip()}")
    return proc.stdout or ""


def git(*args, **kw):
    return run(["git", *args], **kw)


def read_version() -> str:
    text = (CHART_DIR / "Chart.yaml").read_text()
    m = re.search(r"^version:\s*(\S+)\s*$", text, re.M)
    if not m:
        raise ReleaseError("no `version:` line in Chart.yaml")
    return m.group(1)


def bump_version(current: str, kind: str) -> str:
    parts = current.split(".")
    if len(parts) != 3:
        raise ReleaseError(f"unexpected version {current!r}, expected X.Y.Z")
    major, minor, patch = (int(p) for p in parts)
    if kind == "MAJOR":
        return f"{major + 1}.0.0"
    if kind == "MINOR":
        return f"{major}.{minor + 1}.0"
    return f"{major}.{minor}.{patch + 1}"


def chart_changes() -> tuple[list[str], list[str]]:
    """(tracked changes, untracked files) inside the chart directory."""
    raw = git("status", "--porcelain", "--", str(REL_CHART))
    tracked, untracked = [], []
    for line in raw.splitlines():
        if not line.strip():
            continue
        status, path = line[:2], line[3:]
        (untracked if status == "??" else tracked).append(path)
    return tracked, untracked


def outside_changes() -> list[str]:
    raw = git("status", "--porcelain")
    out = []
    for line in raw.splitlines():
        if not line.strip():
            continue
        path = line[3:]
        if not path.startswith(str(REL_CHART) + "/") and not path.startswith("docs/"):
            out.append(line)
    return out


def check_for_secrets() -> list[str]:
    diff = git("diff", "--", str(REL_CHART))
    hits = []
    for line in diff.splitlines():
        for pattern, label in SECRET_PATTERNS:
            if re.search(pattern, line):
                hits.append(f"{label}: {line.strip()[:120]}")
    return hits


def commit_link(sha: str) -> str:
    url = git("config", "--get", "remote.origin.url").strip()
    url = re.sub(r"^.*github\.com[:/]", "https://github.com/", url)
    url = re.sub(r"\.git$", "", url)
    author = git("log", "-1", "--pretty=format:%an").strip()
    return f"[{author} - [`{sha[:9]}`]({url}/commit/{sha})]"


def today() -> str:
    d = date.today()
    return f"{d.day} {MONTHS[d.month - 1]} {d.year}"


def rewrite_refs(text: str) -> str:
    return re.sub(
        r"[Rr][Ee][Ff][Ss]\s*#(\d+)",
        r"Refs [#\1](https://taskman.eionet.europa.eu/issues/\1)",
        text,
    )


def update_readme(new_version: str, message: str, link: str) -> None:
    path = CHART_DIR / "README.md"
    text = path.read_text()

    m = re.search(r"^(#+ Releases[^\n]*)$", text, re.M)
    if not m:
        text = text.rstrip("\n") + "\n\n## Releases\n"
        m = re.search(r"^(#+ Releases[^\n]*)$", text, re.M)

    head_end = m.end()
    head, tail = text[:head_end], text[head_end:]

    # the shell version migrates a legacy <dl>/<dt>/<dd> changelog to markdown
    if tail.count("<dl>") == 1:
        tail = re.sub(r"[ \t]*</?dl>.*", "", tail)
        tail = re.sub(r"[ \t]*<dt>(.*?)</dt>", r"### \1", tail)
        tail = re.sub(r"[ \t]*<dd>(.*?)</dd>", r"- \1", tail)

    entry = f"### Version {new_version} - {today()}\n- {rewrite_refs(message)} {link}".rstrip()
    body = f"{entry}\n\n{tail.lstrip(chr(10))}".rstrip() + "\n"
    path.write_text(f"{head}\n\n{body}")


def package_chart(new_version: str, dry: bool) -> str:
    docs = REPO_ROOT / "docs"
    temp = docs / "temp"
    tgz = f"{CHART_NAME}-{new_version}.tgz"

    if dry:
        print(f"  (dry run) helm package {REL_CHART} -d docs/temp")
        print(f"  (dry run) helm repo index --merge docs/index.yaml docs/temp")
        print(f"  (dry run) would add docs/{tgz} and updated docs/index.yaml")
        return tgz

    if temp.exists():
        shutil.rmtree(temp)
    temp.mkdir(parents=True)

    run(["helm", "package", str(CHART_DIR), "-d", str(temp)])
    run(["helm", "repo", "index", "--merge", str(docs / "index.yaml"), str(temp)])

    for item in temp.iterdir():
        shutil.move(str(item), str(docs / item.name))
    temp.rmdir()
    return tgz


def main() -> int:
    p = argparse.ArgumentParser(
        description=f"Release the {CHART_NAME} Helm chart without a TTY.",
    )
    p.add_argument("-m", "--message", default=os.environ.get("HELM_UPGRADE_MESSAGE"),
                   help="changelog line and release commit message")
    p.add_argument("--bump", choices=["PATCH", "MINOR", "MAJOR"],
                   default=os.environ.get("HELM_VERSION_TYPE", "PATCH").upper())
    p.add_argument("--set-version", help="explicit new version instead of --bump")
    p.add_argument("--commit-message", default=os.environ.get("HELM_COMMIT_MESSAGE"),
                   help="message for the chart-only commit (defaults to --message)")
    p.add_argument("--no-commit-link", action="store_true",
                   help="do not append the [author - sha] link to the changelog entry")
    p.add_argument("--publish", action="store_true",
                   help="actually do it; without this the run is a dry run")
    p.add_argument("--no-push", action="store_true", help="commit locally but do not push")
    p.add_argument("--no-pull", action="store_true", help="skip git pull --ff-only")
    p.add_argument("--skip-deps", action="store_true", help="skip helm dependency update")
    p.add_argument("--skip-secret-check", action="store_true")
    p.add_argument("--allow-untouched", action="store_true",
                   help="proceed even if the chart has no changes (re-release)")
    args = p.parse_args()

    dry = not args.publish
    mode = "DRY RUN" if dry else "PUBLISH"
    print(f"== release {CHART_NAME} [{mode}] ==")

    if not (CHART_DIR / "Chart.yaml").is_file():
        raise ReleaseError(f"no Chart.yaml in {CHART_DIR}")
    if shutil.which("helm") is None:
        raise ReleaseError("helm not on PATH")

    current = read_version()
    new_version = args.set_version or bump_version(current, args.bump)

    tracked, untracked = chart_changes()
    if not tracked and not untracked and not args.allow_untouched:
        raise ReleaseError(
            f"no changes under {REL_CHART} - nothing to release "
            "(use --allow-untouched to re-release the same content)"
        )

    print(f"chart:    {REL_CHART}")
    print(f"version:  {current} -> {new_version}  ({args.bump})")
    print(f"changes:  {len(tracked)} tracked, {len(untracked)} untracked")
    for f in tracked:
        print(f"          M {f}")
    for f in untracked:
        print(f"          ? {f}")

    if untracked:
        print("\n  NOTE: untracked files under the chart directory get committed")
        print("        AND packaged into the .tgz. Check them before publishing.")

    outside = outside_changes()
    if outside:
        print(f"\n  NOTE: {len(outside)} change(s) elsewhere in the repo stay untouched "
              "(only this chart and docs/ are committed):")
        for line in outside[:10]:
            print(f"          {line}")

    if not args.message:
        raise ReleaseError("--message (or HELM_UPGRADE_MESSAGE) is required")
    if not re.match(r"^\d+(\.\d+){2}$", new_version):
        raise ReleaseError(f"invalid version {new_version!r}")

    if not args.skip_secret_check:
        hits = check_for_secrets()
        if hits:
            print("\n  possible secrets in the staged diff:")
            for h in hits:
                print(f"    ! {h}")
            raise ReleaseError("aborted; use --skip-secret-check if these are false positives")

    commit_message = args.commit_message or args.message

    if dry:
        print("\n  would run:")
        if not args.no_pull:
            print("    git pull --ff-only")
        print("    helm lint <chart>")
        if not args.skip_deps:
            print("    helm dependency update <chart>")
        print(f"    git commit -m {commit_message!r}          # chart changes only")
        print(f"    Chart.yaml version -> {new_version}")
        print(f"    README.md: new '### Version {new_version} - {today()}' entry")
        package_chart(new_version, dry=True)
        print(f"    git commit -m {f'{commit_message} in {CHART_NAME}:{new_version}'!r}")
        if not args.no_push:
            print("    git push")
        print("\n  dry run complete - re-run with --publish")
        return 0

    if not args.no_pull:
        git("pull", "--ff-only")

    run(["helm", "lint", str(CHART_DIR)])

    chart_text = (CHART_DIR / "Chart.yaml").read_text()
    if not args.skip_deps and re.search(r"^\s*repository:", chart_text, re.M):
        run(["helm", "dependency", "update", str(CHART_DIR)])

    if tracked or untracked:
        git("add", "--", str(REL_CHART))
        git("commit", "-m", commit_message)
        sha = git("rev-parse", "HEAD").strip()
    else:
        sha = git("rev-parse", "HEAD").strip()

    link = "" if args.no_commit_link else commit_link(sha)
    print(f"  chart commit: {sha[:9]}")

    current_text = (CHART_DIR / "Chart.yaml").read_text()
    (CHART_DIR / "Chart.yaml").write_text(
        re.sub(r"^version:.*$", f"version: {new_version}", current_text, count=1, flags=re.M)
    )
    update_readme(new_version, args.message, link)

    tgz = package_chart(new_version, dry=False)

    release_message = f"{commit_message} in {CHART_NAME}:{new_version}"
    git("add", "--", str(REL_CHART), "docs/")
    git("commit", "-m", release_message)
    rel_sha = git("rev-parse", "HEAD").strip()
    print(f"  release commit: {rel_sha[:9]}")
    print(f"  package: docs/{tgz}")

    if not args.no_push:
        git("push")

    print(f"\n== released {CHART_NAME} {current} -> {new_version} ==")
    print(f"next: helm upgrade -n cca cca-backend --version {new_version} ...")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except ReleaseError as exc:
        print(f"\nerror: {exc}", file=sys.stderr)
        sys.exit(1)
