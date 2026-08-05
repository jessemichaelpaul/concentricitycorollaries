#!/usr/bin/env python3
"""save_ledger — where the work went, and what has not been saved.

The record names four media the obstruction uses, and OMISSION is the one with
no lexical form: five green declarations sat uncommitted for two days, eight of
ten names appeared in neither record, and nothing objected, because nothing was
watching. A gate that reads what was written cannot see what was never saved.

Two jobs, and they are the same job from opposite ends:

  REMEMBER   every write to a source file is appended to .provenance/saves.jsonl
             with its path, its declarations, and the time. "Where did that go"
             stops being a question answered by memory.

  REQUIRE    a declaration that exists in the working tree but not in HEAD is
             UNSAVED. Past a grace period it is the two-day failure in progress,
             and the turn is refused with the exact command that saves it.

Modes
  (no args)     PostToolUse hook: record one row per source write
  --stop        Stop hook: refuse if work has been unsaved past the grace period
  --report      where recent work landed, and everything currently unsaved
  --unsaved     just the unsaved declarations; exit 2 if any

PROVENANCE_SAVE_GRACE   seconds before unsaved work refuses a turn (default 1800)
PROVENANCE_SAVE_LEDGER=off   disable entirely
"""

import json
import os
import pathlib
import re
import subprocess
import sys
import time

DECL = re.compile(
    r"^\s*(?:@\[[^\]]*\]\s*)*(?:private\s+|protected\s+|noncomputable\s+)*"
    r"(?:theorem|lemma|def|instance|abbrev|structure|class)\s+"
    r"([A-Za-z_][A-Za-z0-9_.']*)", re.M)
SOURCE = (".lean", ".hs", ".py", ".rs")
GRACE = int(os.environ.get("PROVENANCE_SAVE_GRACE") or 1800)


def git(project: pathlib.Path, *args: str) -> str:
    try:
        r = subprocess.run(["git", *args], cwd=project, capture_output=True,
                           text=True, errors="replace", timeout=120)
        return r.stdout if r.returncode == 0 else ""
    except Exception:
        return ""


def decls(text: str) -> set:
    return {n.split(".")[-1] for n in DECL.findall(text or "")}


def ledger_path(project: pathlib.Path) -> pathlib.Path:
    d = project / ".provenance"
    d.mkdir(parents=True, exist_ok=True)
    return d / "saves.jsonl"


def rows(project: pathlib.Path) -> list:
    p = ledger_path(project)
    if not p.exists():
        return []
    out = []
    for line in p.read_text(errors="ignore").splitlines():
        try:
            out.append(json.loads(line))
        except Exception:
            continue
    return out


def unsaved(project: pathlib.Path) -> dict:
    """Declarations in the working tree that are not in HEAD, by file.

    Only modified and untracked files are opened, so this stays cheap enough to
    run on every turn.
    """
    out = {}
    changed = [f for f in git(project, "diff", "HEAD", "--name-only", "--",
                              "*.lean").splitlines() if f.strip()]
    untracked = [f for f in git(project, "ls-files", "--others",
                                "--exclude-standard", "--",
                                "*.lean").splitlines() if f.strip()]
    for rel in changed:
        p = project / rel
        if not p.is_file():
            continue                      # deleted in the working tree
        added = decls(p.read_text(errors="ignore")) - decls(
            git(project, "show", f"HEAD:{rel}"))
        if added:
            out[rel] = sorted(added)
    for rel in untracked:
        p = project / rel
        if p.is_file():
            added = decls(p.read_text(errors="ignore"))
            if added:
                out[rel] = sorted(added)
    return out


def first_seen(project: pathlib.Path, pending: dict) -> dict:
    """Earliest known time per still-unsaved declaration.

    The ledger only knows about writes it watched. A declaration written before
    this tool existed has no row at all, and a grace period computed from the
    ledger alone would never call it stale -- which is exactly backwards, since
    the oldest unsaved work is the work most at risk. The two-day case would
    have had no row. So the file's own mtime is the fallback: it is not the
    moment the declaration was written, but it is a real upper bound on how
    long the file has gone untouched, and it is never absent.
    """
    when = {}
    for row in rows(project):
        ts = row.get("t")
        if not isinstance(ts, (int, float)):
            continue
        for name in row.get("decls") or []:
            if name not in when or ts < when[name]:
                when[name] = ts
    for rel, names in pending.items():
        try:
            mtime = (project / rel).stat().st_mtime
        except OSError:
            continue
        for name in names:
            when.setdefault(name, mtime)
    return {n: when[n] for names in pending.values() for n in names
            if n in when}


def record(project: pathlib.Path, path: str, tool: str) -> int:
    p = pathlib.Path(path)
    if p.suffix not in SOURCE:
        return 0
    try:
        text = p.read_text(errors="ignore") if p.is_file() else ""
    except OSError:
        return 0
    rel = str(p.resolve()).replace(str(project) + "/", "")
    row = {
        "t": int(time.time()),
        "iso": time.strftime("%Y-%m-%dT%H:%M:%S"),
        "file": rel,
        "tool": tool,
        "decls": sorted(decls(text)),
        "committed": not git(project, "status", "--porcelain", "--", rel).strip(),
    }
    with ledger_path(project).open("a", encoding="utf-8") as fh:
        fh.write(json.dumps(row) + "\n")
    return 0


def report(project: pathlib.Path) -> int:
    hist = rows(project)
    print(f"# save ledger — {project.name}")
    print(f"  writes recorded : {len(hist)}")
    if hist:
        print("\n## where recent work landed")
        seen = []
        for row in reversed(hist):
            f = row.get("file")
            if f and f not in seen:
                seen.append(f)
                print(f"  {row.get('iso','?'):<21}{f}  "
                      f"({len(row.get('decls') or [])} declaration(s))")
            if len(seen) >= 12:
                break
    pending = unsaved(project)
    total = sum(len(v) for v in pending.values())
    print(f"\n## UNSAVED — in the working tree, not in HEAD   ({total})")
    if not pending:
        print("  nothing. every declaration in the tree is in HEAD.")
        return 0
    when = first_seen(project, pending)
    now = time.time()
    for rel, names in sorted(pending.items()):
        print(f"  {rel}")
        for n in names:
            age = when.get(n)
            note = ""
            if age:
                mins = int((now - age) // 60)
                note = f"   (unsaved {mins} min)" if mins else "   (just written)"
            print(f"      {n}{note}")
    print("\n  git add -A && git commit -m 'save work in progress'")
    return 2


def stop_hook(project: pathlib.Path) -> int:
    pending = unsaved(project)
    if not pending:
        return 0
    when = first_seen(project, pending)
    now = time.time()
    stale = {n: now - t for n, t in when.items() if now - t > GRACE}
    if not stale:
        return 0
    print("TURN REFUSED — proved work has been sitting unsaved.\n", file=sys.stderr)
    for rel, names in sorted(pending.items()):
        hit = [n for n in names if n in stale]
        if hit:
            print(f"    {rel}", file=sys.stderr)
            for n in hit:
                print(f"        {n}   unsaved {int(stale[n] // 60)} min",
                      file=sys.stderr)
    print(
        "\nThis is the two-day failure in progress: on 2026-08-04 five green "
        "declarations sat uncommitted and nothing was watching. Deletion is the "
        "one medium whose damage redoing the work does not undo.\n"
        "\n    git add -A && git commit -m '<what this closes>'\n"
        "\nIf the work is genuinely not ready, say so and set "
        "PROVENANCE_SAVE_LEDGER=off for the session.",
        file=sys.stderr)
    return 2


def main() -> int:
    if os.environ.get("PROVENANCE_SAVE_LEDGER", "").lower() == "off":
        return 0
    args = sys.argv[1:]
    here = pathlib.Path(".").resolve()

    if args and args[0] in ("--report", "--unsaved"):
        project = here
        if args[0] == "--unsaved":
            pending = unsaved(project)
            for rel, names in sorted(pending.items()):
                for n in names:
                    print(f"{rel}\t{n}")
            return 2 if pending else 0
        return report(project)

    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0
    project = pathlib.Path(payload.get("cwd") or ".").resolve()
    if args and args[0] == "--stop":
        return stop_hook(project)
    inp = payload.get("tool_input") or {}
    path = str(inp.get("file_path") or "")
    if not path:
        return 0
    return record(project, path, payload.get("tool_name", ""))


if __name__ == "__main__":
    sys.exit(main())
