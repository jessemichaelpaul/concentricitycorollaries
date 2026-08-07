#!/usr/bin/env python3
"""Codex hook: confine mutations to the one author-entered provenance project.

Reads remain available.  Writes, patches, and permission escalation are denied
when this repository is not the active project.  When it is active, the Codex
workspace sandbox is the primary filesystem boundary and this hook prevents a
model from asking to step around that boundary.
"""
from __future__ import annotations

import json
import pathlib
import re
import subprocess
import sys


SCRIPT = pathlib.Path(__file__).resolve()
PROJECT = (SCRIPT.parents[2]
           if SCRIPT.parent.name == "hooks" and SCRIPT.parent.parent.name == ".codex"
           else SCRIPT.parent)
MANIFEST = PROJECT / ".provenance-project.json"
AGENT_POLICY = PROJECT / "AGENTS.md"
try:
    CFG = json.loads(MANIFEST.read_text())
except (OSError, json.JSONDecodeError):
    CFG = {}
AUTHOR_BINDINGS = (PROJECT / str(CFG.get(
    "author_binding_registry", ".provenance/author_bindings.json"
))).resolve()
MASTER = (PROJECT / str(CFG["master"])).resolve() if CFG.get("master") else None
PHASE = str(CFG.get("phase", "formalization"))
LOCK = pathlib.Path.home() / ".provenance-active"
# Two corrections.  Stderr redirection (2>&1, 2>/dev/null) mutates nothing and
# no longer counts as a mutation -- it was refusing ordinary reads, which is
# how a guard teaches a model to route around it.  And the common interpreter
# write routes are named rather than passing silently.  A shape blocklist is
# never complete; the authoritative confinement is write_scope_guard.sh plus
# the workspace sandbox, and this is the second line, not the first.
MUTATING_SHELL = re.compile(
    r"(?:^|[;&|\s])(?:rm|mv|cp|install|mkdir|touch|truncate|tee|dd|patch|"
    r"git\s+(?:add|apply|commit|push|reset|checkout|clean|restore)|"
    r"sed\s+-i|perl\s+-i)(?:\s|$)"
    r"|>{1,2}\s*(?!&)(?!/dev/null\b)[^\s;&|]"
    r"|(?:python3?|perl|ruby|node|osascript)\s+-(?:c|e)\b"
    r"|(?:python3?|perl|ruby|node)\s+-\s*<<"
    r"|\.write(?:_text|_bytes)?\s*\("
    r"|shutil\.(?:copy|move|rmtree)|os\.(?:remove|rename|replace|makedirs)"
)
PATCH_TARGET = re.compile(r"^\*\*\* (?:Add|Update|Delete) File: (.+)$", re.MULTILINE)


def receipt_production_source() -> str:
    """The production file, read from the project's own receipt evidence.

    The provenance manifest is author-locked and predates this rule, so a
    project that already declares its production source in its receipt manifest
    should not need the author to restate it before the commit gate works.
    """
    config = CFG.get("receipt_import")
    if not isinstance(config, dict):
        return ""
    for key in ("manifest", "evidence"):
        name = config.get(key)
        if not isinstance(name, str) or not name:
            continue
        path = PROJECT / name
        if not path.exists():
            continue
        try:
            data = json.loads(path.read_text())
        except (OSError, json.JSONDecodeError):
            continue
        value = data.get("production_source") if isinstance(data, dict) else None
        if isinstance(value, str) and value:
            return value
    return ""


def emit(value: dict[str, object]) -> None:
    print(json.dumps(value, separators=(",", ":")))


def deny(event: str, reason: str) -> None:
    if event == "PermissionRequest":
        emit({
            "hookSpecificOutput": {
                "hookEventName": event,
                "decision": {"behavior": "deny", "message": reason},
            }
        })
    else:
        emit({
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "deny",
                "permissionDecisionReason": reason,
            }
        })
    raise SystemExit(0)


def inside_project(raw: str, cwd: pathlib.Path) -> bool:
    path = pathlib.Path(raw).expanduser()
    if not path.is_absolute():
        path = cwd / path
    try:
        path.resolve().relative_to(PROJECT.resolve())
        return True
    except ValueError:
        return False


def resolve_target(raw: str, cwd: pathlib.Path) -> pathlib.Path:
    path = pathlib.Path(raw).expanduser()
    return (path if path.is_absolute() else cwd / path).resolve()


def locked_author_target(raw: str, cwd: pathlib.Path) -> str | None:
    target = resolve_target(raw, cwd)
    if target == MANIFEST.resolve():
        return "the provenance manifest and phase are author-controlled"
    if target == AGENT_POLICY.resolve():
        return "the installed Provenance protocol is machinery-controlled"
    if target == AUTHOR_BINDINGS:
        return "the ratified authored-binding registry is author-controlled"
    if PHASE != "authoring" and MASTER is not None and target == MASTER:
        return "the ratified master is read-only during formalization"
    return None


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, TypeError):
        deny("PreToolUse", "Provenance project lock received malformed hook input.")

    event = str(payload.get("hook_event_name", "PreToolUse"))
    tool = str(payload.get("tool_name", ""))
    tool_input = payload.get("tool_input") or {}
    command = str(tool_input.get("command", "")) if isinstance(tool_input, dict) else ""
    cwd = pathlib.Path(str(payload.get("cwd") or PROJECT)).resolve()
    active = LOCK.read_text().strip() if LOCK.exists() else ""
    active_path = pathlib.Path(active).resolve() if active else None
    is_active = active_path == PROJECT.resolve()

    # An approval is precisely a request to cross the configured sandbox.  A
    # model may not grant itself that wider scope while provenance is active.
    if event == "PermissionRequest":
        deny(event, f"Provenance lock: permission escalation is disabled while {PROJECT} is instantiated.")

    if tool == "apply_patch":
        if not is_active:
            deny(event, f"Provenance lock: {PROJECT} is not the author-entered active project.")
        targets = PATCH_TARGET.findall(command)
        if not targets:
            deny(event, "Provenance lock: a patch with no resolvable file target is refused.")
        outside = [target for target in targets if not inside_project(target, cwd)]
        if outside:
            deny(event, "Provenance lock: patch target is outside the active project: " + ", ".join(outside))
        locked = [reason for target in targets
                  if (reason := locked_author_target(target, cwd)) is not None]
        if locked:
            deny(event, "Provenance lock: " + locked[0] + ".")
        return 0

    if tool in {"Write", "Edit", "NotebookEdit"}:
        raw = str(tool_input.get("file_path", "")) if isinstance(tool_input, dict) else ""
        if not raw:
            deny(event, "Provenance lock: direct edit target is absent.")
        # Jurisdiction is this project's own tree.  Outside it, the global write
        # scope guard and the target project's own lock decide.  Vetoing every
        # other repository made the ENTERED project unwritable, which inverted
        # the whole point of entering one.
        if not inside_project(raw, cwd):
            return 0
        if not is_active:
            deny(event, f"Provenance lock: {PROJECT} is not the author-entered active project.")
        reason = locked_author_target(raw, cwd)
        if reason:
            deny(event, "Provenance lock: " + reason + ".")
        return 0

    if tool == "Bash" and MUTATING_SHELL.search(command):
        # RULE 1.  A commit touching the production source must carry a term that
        # reached the kernel.  On 2026-08-02 four commits landed in the
        # production file, all compiling, none moving a binding -- and every gate
        # was silent, because a commit that closes a row and a commit that
        # restates a settled lemma are indistinguishable to anything that reads
        # words.  This reads the attempt log instead.
        if re.search(r"(?:^|[;&|\s])git\s+commit(?:\s|$)", command):
            production = CFG.get("production_source") or receipt_production_source()
            if isinstance(production, str) and production:
                attempts = PROJECT / ".provenance" / "attempts.jsonl"
                staged = subprocess.run(
                    ["git", "diff", "--cached", "--name-only"],
                    cwd=PROJECT, capture_output=True, text=True,
                )
                touches = production in staged.stdout.split()
                if touches:
                    head = subprocess.run(
                        ["git", "log", "-1", "--format=%ct"],
                        cwd=PROJECT, capture_output=True, text=True,
                    )
                    try:
                        since = float(head.stdout.strip() or 0)
                    except ValueError:
                        since = 0.0
                    fresh = attempts.exists() and attempts.stat().st_mtime > since
                    if not fresh:
                        deny(
                            event,
                            "Provenance lock: this commit changes " + production +
                            " but no term has reached the kernel since the last "
                            "commit -- .provenance/attempts.jsonl carries no newer "
                            "line.  The production source is reached through a "
                            "binding probe, never beside one.  Work adjacent to a "
                            "seat compiles just as well as work in it; that is why "
                            "this reads the attempt log and not the diff.",
                        )
        if re.search(r"(?:^|[;&|\s])git\s+push(?:\s|$)", command):
            deny(
                event,
                "Provenance lock: raw git push is disabled; use "
                "python3 tools/verified_push.py so the exact certified commit is checked remotely.",
            )
        try:
            cwd.relative_to(PROJECT.resolve())
            cwd_here = True
        except ValueError:
            cwd_here = False
        if not is_active:
            # Same jurisdiction rule: refuse only what reaches this tree.
            if cwd_here or str(PROJECT.resolve()) in command:
                deny(event, f"Provenance lock: mutation refused because the active project is {active or '(none)' }.")
            return 0
        if not cwd_here:
            deny(event, f"Provenance lock: mutating command has out-of-project working directory {cwd}.")

        # Explicit references to another instantiated project are refused here;
        # relative escapes remain blocked by the workspace-write sandbox.
        desktop = pathlib.Path.home() / "Desktop"
        for manifest in desktop.glob("*/.provenance-project.json"):
            other = manifest.parent.resolve()
            if other != PROJECT.resolve() and str(other) in command:
                deny(event, f"Provenance lock: command names another provenance project: {other}.")
        if str(MANIFEST.resolve()) in command or str(MANIFEST.relative_to(PROJECT)) in command:
            deny(event, "Provenance lock: the provenance manifest and phase are author-controlled.")
        if str(AGENT_POLICY.resolve()) in command or str(AGENT_POLICY.relative_to(PROJECT)) in command:
            deny(event, "Provenance lock: the installed Provenance protocol is machinery-controlled.")
        if str(AUTHOR_BINDINGS) in command or str(AUTHOR_BINDINGS.relative_to(PROJECT)) in command:
            deny(event, "Provenance lock: the ratified authored-binding registry is author-controlled.")
        if PHASE != "authoring" and MASTER is not None and (
            str(MASTER) in command or str(MASTER.relative_to(PROJECT)) in command
        ):
            deny(event, "Provenance lock: the ratified master is read-only during formalization.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
