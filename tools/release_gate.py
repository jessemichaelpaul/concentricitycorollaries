#!/usr/bin/env python3
"""Certify one author-configured publication state before it can be pushed.

The release target list and expected axiom surfaces live in the locked project
manifest.  This gate reruns binding probes, production builds, literal axiom
queries, and the ledger-currentness check.  It certifies only a clean Git HEAD.
"""
from __future__ import annotations

import argparse
import json
import pathlib
import re
import subprocess
import sys


ROOT = pathlib.Path(__file__).resolve().parent.parent
CFG = json.loads((ROOT / ".provenance-project.json").read_text())
TIMEOUT = int(CFG.get("audit_timeout_seconds", 900))
AXIOM_LINE = re.compile(r"'.+' depends on axioms: \[([^]]*)\]")
NO_AXIOM_LINE = re.compile(r"'.+' does not depend on any axioms")


def run(command: list[str], timeout: int | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        command, cwd=ROOT, capture_output=True, text=True,
        encoding="utf-8", errors="replace", timeout=timeout or TIMEOUT,
    )


def fail(code: str, message: str, **details: object) -> dict[str, object]:
    return {"schema": 1, "status": code, "message": message, **details}


def literal_axioms(line: str) -> list[str] | None:
    match = AXIOM_LINE.fullmatch(line.strip())
    if match:
        return [item.strip() for item in match.group(1).split(",") if item.strip()]
    if NO_AXIOM_LINE.fullmatch(line.strip()):
        return []
    return None


def parse_config() -> tuple[list[list[str]], list[dict[str, object]]] | dict[str, object]:
    if CFG.get("kind") == "machinery":
        return fail("RELEASE_WRONG_PROJECT", "the machinery repository is not a mathematical release")
    commands = CFG.get("release_build_commands")
    targets = CFG.get("release_targets")
    if not isinstance(commands, list) or not commands or not all(
        isinstance(command, list) and command and all(isinstance(arg, str) and arg for arg in command)
        for command in commands
    ):
        return fail(
            "RELEASE_CONFIG_REQUIRED",
            "the author-controlled manifest must name nonempty release_build_commands",
        )
    if not all(
        command[0] == "lake" and len(command) >= 2 and command[1] in {"build", "env"}
        and (command[1] != "env" or (len(command) >= 3 and command[2] == "lean"))
        for command in commands
    ):
        return fail(
            "RELEASE_CONFIG_REQUIRED",
            "release_build_commands must be direct Lake build or Lake Lean commands",
        )
    if not isinstance(targets, list) or not targets:
        return fail(
            "RELEASE_CONFIG_REQUIRED",
            "the author-controlled manifest must name release_targets",
        )
    checked: list[dict[str, object]] = []
    for target in targets:
        if not isinstance(target, dict):
            return fail("RELEASE_CONFIG_REQUIRED", "each release target must be an object")
        declaration = target.get("declaration")
        module = target.get("module")
        expected = target.get("expected_axioms")
        if not isinstance(declaration, str) or not declaration:
            return fail("RELEASE_CONFIG_REQUIRED", "each release target needs a declaration")
        if not isinstance(module, str) or not module:
            return fail("RELEASE_CONFIG_REQUIRED", f"{declaration} needs an import module")
        if not isinstance(expected, list) or not all(isinstance(item, str) for item in expected):
            return fail("RELEASE_CONFIG_REQUIRED", f"{declaration} needs expected_axioms")
        checked.append(dict(target))
    return commands, checked


def certify() -> dict[str, object]:
    configured = parse_config()
    if isinstance(configured, dict):
        return configured
    commands, targets = configured

    receipt_tool = ROOT / "tools/receipt_import.py"
    if CFG.get("receipt_import") is not None:
        try:
            receipts = run([sys.executable, str(receipt_tool), "--require-ready"], 3600)
        except subprocess.TimeoutExpired:
            return fail(
                "RELEASE_BINDING_TIMEOUT",
                "fresh authored-binding probes exceeded the operational bound; this has no mathematical meaning",
            )
        if receipts.returncode != 0:
            return fail(
                "RELEASE_BINDINGS_OPEN",
                "authored bindings are not all accepted at their exact production seats",
                evidence=(receipts.stdout + receipts.stderr).strip(),
            )

    build_evidence: list[dict[str, object]] = []
    for command in commands:
        try:
            built = run(command)
        except subprocess.TimeoutExpired:
            return fail(
                "RELEASE_BUILD_TIMEOUT",
                "a configured production build exceeded the operational bound; this has no mathematical meaning",
                command=command,
            )
        build_evidence.append({"command": command, "returncode": built.returncode})
        if built.returncode != 0:
            return fail(
                "RELEASE_BUILD_REJECTED",
                "Lean rejected a configured production build",
                command=command,
                kernel_output=(built.stdout + built.stderr).strip(),
            )

    axiom_evidence: list[dict[str, object]] = []
    for target in targets:
        declaration = str(target["declaration"])
        module = str(target["module"])
        query = run([
            sys.executable, str(ROOT / "tools/axioms_of.py"), declaration,
            "--module", module, "--no-build", "--json",
        ])
        try:
            value = json.loads(query.stdout)
        except json.JSONDecodeError:
            return fail(
                "RELEASE_AXIOM_QUERY_REJECTED",
                f"{declaration} produced no machine-readable literal axiom result",
                output=(query.stdout + query.stderr).strip(),
            )
        literal = str(value.get("axiom_print", "")).strip()
        live_axioms = value.get("axioms")
        expected_axioms = list(target["expected_axioms"])
        sound = (
            query.returncode == 0
            and value.get("code") == "AXIOM_PRINTED"
            and isinstance(live_axioms, list)
            and literal_axioms(literal) == live_axioms
            and set(live_axioms) == set(expected_axioms)
            and len(live_axioms) == len(expected_axioms)
            and "sorryAx" not in live_axioms
        )
        if not sound:
            return fail(
                "RELEASE_AXIOM_SURFACE_REJECTED",
                f"{declaration} does not have its author-configured literal axiom surface",
                expected_axioms=expected_axioms,
                result=value,
            )
        axiom_evidence.append({
            "declaration": declaration,
            "module": module,
            "axioms": live_axioms,
            "axiom_print": literal,
        })

    ledger_tool = ROOT / "tools/validated_ledger.py"
    checked_ledger = run([sys.executable, str(ledger_tool), "--check"], 3600)
    if checked_ledger.returncode != 0:
        return fail(
            "RELEASE_LEDGER_STALE",
            "the readable ledger does not match the certified master and Lean sources",
            evidence=(checked_ledger.stdout + checked_ledger.stderr).strip(),
        )

    clean = run(["git", "status", "--porcelain=v1", "--untracked-files=all"])
    if clean.returncode != 0 or clean.stdout.strip():
        return fail(
            "RELEASE_WORKTREE_NOT_COMMITTED",
            "release evidence applies to files that are not all contained in one clean Git commit",
            git_status=clean.stdout.strip(),
        )
    head = run(["git", "rev-parse", "HEAD"])
    if head.returncode != 0:
        return fail("RELEASE_GIT_REJECTED", "Git could not identify the certified commit")

    return {
        "schema": 1,
        "status": "RELEASE_READY",
        "project": CFG.get("name"),
        "commit": head.stdout.strip(),
        "builds": build_evidence,
        "targets": axiom_evidence,
        "ledger": checked_ledger.stdout.strip(),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()
    result = certify()
    if args.json:
        print(json.dumps(result, indent=2, ensure_ascii=False, sort_keys=True))
    elif result.get("status") == "RELEASE_READY":
        print(f"RELEASE_READY {result['commit']}")
        for target in result["targets"]:
            print(target["axiom_print"])
    else:
        print(f"{result.get('status')}: {result.get('message')}", file=sys.stderr)
    return 0 if result.get("status") == "RELEASE_READY" else 1


if __name__ == "__main__":
    raise SystemExit(main())
