#!/usr/bin/env python3
"""Find a verbatim instruction in user-role records for this project only."""
from __future__ import annotations

import glob
import json
import os
import pathlib
import sys


if len(sys.argv) < 2 or not sys.argv[1].strip():
    raise SystemExit(1)
NEEDLE = sys.argv[1].strip()
ROOT = pathlib.Path(__file__).resolve().parent.parent


def author_texts(record: dict) -> list[str]:
    texts: list[str] = []
    message = record.get("message") or {}
    if message.get("role") == "user":
        content = message.get("content")
        if isinstance(content, list):
            texts.append(" ".join(x.get("text", "") for x in content if isinstance(x, dict)))
        elif isinstance(content, str):
            texts.append(content)
    if record.get("type") == "response_item":
        payload = record.get("payload") or {}
        if payload.get("type") == "message" and payload.get("role") == "user":
            content = payload.get("content")
            if isinstance(content, list):
                texts.append(" ".join(
                    x.get("text", "") for x in content
                    if isinstance(x, dict) and x.get("type") in {"input_text", "text"}
                ))
    return texts


def codex_session_is_local(path: str) -> bool:
    """Accept a Codex transcript only when its recorded cwd is this project."""
    try:
        with open(path, errors="ignore") as handle:
            for _ in range(40):
                line = handle.readline()
                if not line:
                    break
                record = json.loads(line)
                if record.get("type") == "session_meta":
                    cwd = (record.get("payload") or {}).get("cwd")
                    return bool(cwd) and pathlib.Path(cwd).resolve() == ROOT.resolve()
    except (OSError, ValueError, json.JSONDecodeError):
        pass
    return False


claude = os.path.expanduser("~/.claude/projects/-Users-jessepaul-Desktop-concentricity/*.jsonl")
codex = os.path.expanduser("~/.codex/sessions/**/*.jsonl")
paths = list(glob.glob(claude))
paths += [path for path in glob.glob(codex, recursive=True) if codex_session_is_local(path)]

for path in paths:
    try:
        handle = open(path, errors="ignore")
    except OSError:
        continue
    with handle:
        for line in handle:
            try:
                record = json.loads(line)
            except Exception:
                continue
            if any(NEEDLE in text for text in author_texts(record)):
                print("FOUND")
                raise SystemExit(0)
raise SystemExit(1)
