#!/usr/bin/env python3
"""Enforce the author's declared READ surface for the active seat.

Every project lock in this machinery governs writes.  On 2026-08-02 an
assistant left the correct register four times in one session while an
advisory register reminder fired 43 times and blocked nothing -- the failure
was entirely in reads, where no gate existed.  Section 6 of KernelGroundTruth.md
already said why: advisories are read and rationalised past.  This denies the
read instead of describing it.

The surface is AUTHOR-CONTROLLED.  It lives in the locked project manifest
under `register_surfaces`, with `active_register_surface` naming the one in
force, so a model cannot widen its own reading.  Projects that declare no
surface are unaffected.
"""
from __future__ import annotations

import fnmatch
import json
import pathlib
import re
import sys


SCRIPT = pathlib.Path(__file__).resolve()
PROJECT = (SCRIPT.parents[2]
           if SCRIPT.parent.name == "hooks" and SCRIPT.parent.parent.name == ".codex"
           else SCRIPT.parent)
try:
    CFG = json.loads((PROJECT / ".provenance-project.json").read_text())
except (OSError, json.JSONDecodeError):
    CFG = {}
LOCK = pathlib.Path.home() / ".provenance-active"
PATH_TOKEN = re.compile(r"[A-Za-z0-9_.@/-]*[A-Za-z0-9_-]+\.[A-Za-z0-9]+")


def emit(value):
    print(json.dumps(value, separators=(",", ":")))


def deny(reason):
    emit({"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": reason,
    }})
    raise SystemExit(0)


def binding_register():
    """The active binding row's own author-ratified register, if one is named.

    A whole-seat surface is still a place to search.  When the manifest names an
    `active_binding`, the surface narrows to exactly the modules the author says
    that row's object lives in -- so the work is to fill one field from inside
    two or three files, not to look for it.
    """
    binding_id = CFG.get("active_binding")
    config = CFG.get("receipt_import")
    name = (config or {}).get("evidence") if isinstance(config, dict) else None
    if not isinstance(binding_id, str) or not binding_id:
        return None, None
    if not isinstance(name, str) or not name:
        return None, None
    path = PROJECT / name
    if not path.exists():
        return None, None
    try:
        data = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError):
        return None, None
    for row in (data.get("bindings") or []):
        if not isinstance(row, dict) or str(row.get("id")) != binding_id:
            continue
        modules = row.get("register_modules")
        if not isinstance(modules, list) or not all(isinstance(x, str) for x in modules):
            return None, None
        # The row's own seat, the master, and the ledger are always readable:
        # a typist needs the statement it is filling and the file it lands in.
        extra = [str(row.get("probe_source") or "")]
        if CFG.get("master"):
            extra.append(str(CFG["master"]))
        if CFG.get("blueprint"):
            extra.append(str(CFG["blueprint"]))
        if isinstance(config, dict) and config.get("evidence"):
            extra.append(str(config["evidence"]))
        return binding_id, [m for m in modules + extra if m]
    return None, None


def surface():
    """The author's allow-list currently in force, or None.

    A named `active_binding` narrows to that row's register; otherwise the
    seat-wide `register_surfaces` entry applies.
    """
    name, allow = binding_register()
    if allow:
        return "binding " + str(name), allow
    surfaces = CFG.get("register_surfaces")
    active = CFG.get("active_register_surface")
    if not isinstance(surfaces, dict) or not isinstance(active, str) or not active:
        return None, None
    entry = surfaces.get(active)
    if not isinstance(entry, dict):
        return None, None
    allow = entry.get("allow")
    if not isinstance(allow, list) or not all(isinstance(x, str) for x in allow):
        return None, None
    return active, allow


def in_project(raw, cwd):
    path = pathlib.Path(raw).expanduser()
    if not path.is_absolute():
        path = cwd / path
    try:
        relative = path.resolve().relative_to(PROJECT.resolve())
    except ValueError:
        return None
    # A bare fragment of some FOREIGN absolute path -- "Truth/new_project.sh",
    # chopped at the space in "Kernel Ground Truth" -- resolves "inside" this
    # project while naming nothing real here.  Gate only what actually exists.
    if not path.exists():
        return None
    return relative


# The machinery's own tools are always reachable.  A gate whose printed remedy
# ("run tools/claim_gate.py --list") is refused by a sibling gate is not a
# boundary, it is a deadlock -- which is exactly what happened on 2026-08-02.
ALWAYS_ALLOW = ("tools/*",)


def permitted(relative, allow):
    text = str(relative)
    return any(fnmatch.fnmatch(text, rule) or text == rule or
               fnmatch.fnmatch(text, rule.rstrip("/") + "/*")
               for rule in tuple(allow) + ALWAYS_ALLOW)


def main():
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, TypeError):
        return 0

    if LOCK.exists() and pathlib.Path(LOCK.read_text().strip() or ".").resolve() \
            != PROJECT.resolve():
        return 0                       # this project is not the entered one

    name, allow = surface()
    if allow is None:
        return 0                       # no surface declared: unaffected

    tool = str(payload.get("tool_name", ""))
    raw_input = payload.get("tool_input") or {}
    if not isinstance(raw_input, dict):
        return 0
    cwd = pathlib.Path(str(payload.get("cwd") or PROJECT)).resolve()

    candidates = []
    if tool in {"Read", "NotebookRead"}:
        candidates = [str(raw_input.get("file_path", ""))]
    elif tool in {"Grep", "Glob"}:
        candidates = [str(raw_input.get("path", ""))]
    elif tool == "Bash":
        command = str(raw_input.get("command", ""))
        # Scan only the pipeline segments that ARE a search, and only their own
        # arguments.  Scanning the whole command made `… | head` read as a
        # search of every path anywhere in it, so running a tool and paging its
        # output was refused -- including the remedy this gate's sibling prints.
        candidates = []
        for segment in re.split(r"[|;&]+", command):
            if re.match(r"\s*(?:grep|rg|cat|head|tail|sed|awk|less|wc)(?:\s|$)", segment):
                candidates.extend(PATH_TOKEN.findall(segment))
        if not candidates:
            return 0

    refused = []
    for candidate in candidates:
        if not candidate:
            continue
        relative = in_project(candidate, cwd)
        if relative is None:
            continue                   # outside this project: not our business
        if not permitted(relative, allow):
            refused.append(str(relative))
    if refused:
        deny(
            "Register gate: " + ", ".join(sorted(set(refused))[:4]) +
            " is outside the author's declared read surface for seat '" + name +
            "'. The objects for this seat are inside the surface; a name that is "
            "not there is not the object. Allowed: " + ", ".join(allow) +
            ". Only the author changes this, in the locked manifest."
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
