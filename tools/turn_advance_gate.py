#!/usr/bin/env python3
"""turn_advance_gate — a turn ends with contact, or it does not end.

Measured 2026-08-04 over 41 sessions and 3,567 turns carrying text:

    75%  produced NO advance at all
         -- no kernel contact, no source written, no commit.

That is the largest single failure in the project and it has NO LEXICAL FORM,
which is why four gates that blocked phrases were displaced within hours while
this one was never built. Omission cannot be reworded around.

The rule, and it needs no diagnosis of anything:

    A turn that produced text, while a marker is open, must contain at least
    one of: a kernel invocation, a write to a source file, or a commit.

Nothing here reads what was said. It reads what was done.

Wire as a `Stop` hook. Exit 2 refuses the turn and returns the reason.
Set PROVENANCE_TURN_GATE=off for a session of genuine discussion -- and note
that "we were only talking" is what those 75% looked like from the inside.
"""

import json
import os
import pathlib
import re
import subprocess
import sys

KERNEL = re.compile(r"(lake\s+(build|env)|#print\s+axioms|#guard_msgs|#check\b)")
SOURCE_WRITE = re.compile(r"\.(lean|hs|rs|py)\b")
COMMIT = re.compile(r"\bcommit\b")
WRITE_TOOLS = {"Write", "Edit", "MultiEdit", "NotebookEdit"}


def last_turn(transcript: pathlib.Path):
    rows = []
    for line in transcript.open(errors="ignore"):
        try:
            rows.append(json.loads(line))
        except Exception:
            continue
    start = 0
    for i, d in enumerate(rows):
        if d.get("type") != "user":
            continue
        c = d.get("message", {}).get("content")
        s = c if isinstance(c, str) else "".join(
            x.get("text", "") for x in (c or [])
            if isinstance(x, dict) and x.get("type") == "text")
        if s.strip() and not s.strip().startswith("<") and "tool_use_error" not in s:
            start = i
    return rows[start:]


def markers_open(project: pathlib.Path) -> bool:
    try:
        out = subprocess.run(["git", "grep", "-c", "-w", "sorry", "--", "*.lean"],
                             cwd=project, capture_output=True, text=True,
                             timeout=120).stdout
        return bool(out.strip())
    except Exception:
        return True


def main() -> int:
    if os.environ.get("PROVENANCE_TURN_GATE", "").lower() == "off":
        return 0
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0
    tpath = payload.get("transcript_path")
    project = pathlib.Path(payload.get("cwd") or ".").resolve()
    if not tpath or not pathlib.Path(tpath).exists():
        return 0
    if not markers_open(project):
        return 0

    text = contact = False
    for d in last_turn(pathlib.Path(tpath)):
        if d.get("type") != "assistant":
            continue
        for x in (d.get("message", {}).get("content") or []):
            if not isinstance(x, dict):
                continue
            if x.get("type") == "text" and x.get("text", "").strip():
                text = True
            elif x.get("type") == "tool_use":
                blob = json.dumps(x.get("input") or {})
                if KERNEL.search(blob) or COMMIT.search(blob):
                    contact = True
                if x.get("name") in WRITE_TOOLS and SOURCE_WRITE.search(blob):
                    contact = True
    if text and not contact:
        print(
            "TURN REFUSED — this turn produced text and did not touch the "
            "kernel, write a source file, or commit, while a marker is open.\n"
            "\n"
            "Measured over 41 sessions: 75% of turns did exactly this. It is "
            "the largest failure mode in this project and it has no lexical "
            "form, so no gate that reads words can catch it.\n"
            "\n"
            "Do one of: elaborate a term and read what the kernel prints; "
            "write to a source file; commit what is already proved.\n"
            "\n"
            "If this turn was genuinely discussion, say so and set "
            "PROVENANCE_TURN_GATE=off for the session.",
            file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
