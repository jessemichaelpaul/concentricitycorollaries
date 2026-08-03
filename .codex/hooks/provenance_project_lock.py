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
import sys


SCRIPT = pathlib.Path(__file__).resolve()
PROJECT = (SCRIPT.parents[2]
           if SCRIPT.parent.name == "hooks" and SCRIPT.parent.parent.name == ".codex"
           else SCRIPT.parent)
MANIFEST = PROJECT / ".provenance-project.json"
try:
    CFG = json.loads(MANIFEST.read_text())
except (OSError, json.JSONDecodeError):
    CFG = {}
MASTER = (PROJECT / str(CFG["master"])).resolve() if CFG.get("master") else None
PHASE = str(CFG.get("phase", "formalization"))
LOCK = pathlib.Path.home() / ".provenance-active"
MUTATING_SHELL = re.compile(
    r"(?:^|[;&|\s])(?:rm|mv|cp|install|mkdir|touch|truncate|tee|patch|"
    r"git\s+(?:add|apply|commit|push|reset|checkout|clean|restore)|"
    r"sed\s+-i|perl\s+-i)(?:\s|$)|(?:^|[^>])>{1,2}(?:[^>]|$)"
)
PATCH_TARGET = re.compile(r"^\*\*\* (?:Add|Update|Delete) File: (.+)$", re.MULTILINE)


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
        if not is_active:
            deny(event, f"Provenance lock: {PROJECT} is not the author-entered active project.")
        raw = str(tool_input.get("file_path", "")) if isinstance(tool_input, dict) else ""
        if not raw or not inside_project(raw, cwd):
            deny(event, "Provenance lock: direct edit target is absent or outside the active project.")
        reason = locked_author_target(raw, cwd)
        if reason:
            deny(event, "Provenance lock: " + reason + ".")
        return 0

    if tool == "Bash" and MUTATING_SHELL.search(command):
        if not is_active:
            deny(event, f"Provenance lock: mutation refused because the active project is {active or '(none)' }.")
        try:
            cwd.relative_to(PROJECT.resolve())
        except ValueError:
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
        if PHASE != "authoring" and MASTER is not None and (
            str(MASTER) in command or str(MASTER.relative_to(PROJECT)) in command
        ):
            deny(event, "Provenance lock: the ratified master is read-only during formalization.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
