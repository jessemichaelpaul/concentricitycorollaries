#!/usr/bin/env python3
"""Push only the exact commit certified by the Provenance release gate."""
from __future__ import annotations

import argparse
import json
import pathlib
import subprocess
import sys


ROOT = pathlib.Path(__file__).resolve().parent.parent
CFG = json.loads((ROOT / ".provenance-project.json").read_text())


def run(command: list[str], timeout: int = 3600) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        command, cwd=ROOT, capture_output=True, text=True,
        encoding="utf-8", errors="replace", timeout=timeout,
    )


def main() -> int:
    argparse.ArgumentParser().parse_args()

    remote_name = CFG.get("release_remote")
    expected_url = CFG.get("release_remote_url")
    branch = CFG.get("release_branch")
    if not all(isinstance(item, str) and item for item in (remote_name, expected_url, branch)):
        print(
            "PUSH_BLOCKED: the author-controlled manifest must name release_remote, "
            "release_remote_url, and release_branch",
            file=sys.stderr,
        )
        return 1
    remote_name = str(remote_name)
    expected_url = str(expected_url)
    branch = str(branch)

    gate = run([sys.executable, str(ROOT / "tools/release_gate.py"), "--json"])
    try:
        receipt = json.loads(gate.stdout)
    except json.JSONDecodeError:
        print("PUSH_BLOCKED: release gate produced no machine-readable receipt", file=sys.stderr)
        return 1
    if gate.returncode != 0 or receipt.get("status") != "RELEASE_READY":
        print(json.dumps(receipt, indent=2, ensure_ascii=False, sort_keys=True), file=sys.stderr)
        return 1

    current = run(["git", "branch", "--show-current"])
    if current.returncode != 0 or current.stdout.strip() != branch:
        print("PUSH_BLOCKED: HEAD is not on the author-configured release branch", file=sys.stderr)
        return 1
    remote_url = run(["git", "remote", "get-url", remote_name])
    if remote_url.returncode != 0 or remote_url.stdout.strip() != expected_url:
        print("PUSH_BLOCKED: Git remote URL differs from the author-controlled release URL", file=sys.stderr)
        return 1
    certified = str(receipt["commit"])
    before = run(["git", "rev-parse", "HEAD"])
    if before.returncode != 0 or before.stdout.strip() != certified:
        print("PUSH_BLOCKED: HEAD changed after release certification", file=sys.stderr)
        return 1

    pushed = run(["git", "push", remote_name, f"HEAD:refs/heads/{branch}"])
    if pushed.returncode != 0:
        print("PUSH_REJECTED: " + (pushed.stdout + pushed.stderr).strip(), file=sys.stderr)
        return 1
    remote = run(["git", "ls-remote", remote_name, f"refs/heads/{branch}"])
    fields = remote.stdout.strip().split()
    if remote.returncode != 0 or len(fields) < 2 or fields[0] != certified:
        print("PUSH_UNVERIFIED: remote branch does not resolve to the certified commit", file=sys.stderr)
        return 1

    print(json.dumps({
        "schema": 1,
        "status": "PUSH_VERIFIED",
        "remote": remote_name,
        "remote_url": expected_url,
        "branch": branch,
        "commit": certified,
        "release": receipt,
    }, indent=2, ensure_ascii=False, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
