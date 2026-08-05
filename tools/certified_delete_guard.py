#!/usr/bin/env python3
"""certified_delete_guard — certified work cannot be removed, by an edit or a shell.

Measured 2026-08-04: `Deleted` runs 2.05x the healthy-era rate, peaking during
the pivot — the era in which Codex deleted work it had itself built. Deletion
is one of the four media the obstruction uses, and it is the only one that is
not recoverable by simply doing the work again, because the work was already
done.

The rule:

    Nothing may remove a declaration that carries a certificate.

"Carries a certificate" means the declaration is named in the author's master
`\\lean{}` tags, in the blueprint certificate table, or in the provenance
manifest. Those are the three places the author records what has been checked.
A name in any of them is work he has ratified, and nothing gets to quietly drop
it.

TWO SURFACES, because Write/Edit was never the only way to lose a file. The
editor tools were guarded first and the shell was not, which left the medium
the record actually names — deletion — wide open behind a guarded front door.
`rm`, `git rm`, `git checkout --`, `git reset --hard`, `git clean`, `sed -i`,
a truncating `>` redirect, and `tee` without `-a` all reach the same files.

This does NOT block deletion. It blocks SILENT deletion: the refusal names the
declaration and the record it appears in, so removing it becomes a deliberate
act the author can see.

Wire as a PreToolUse hook on Write|Edit|MultiEdit|Bash. Exit 2 refuses.
Set PROVENANCE_DELETE_GUARD=off to override for a deliberate removal.
"""

import json
import os
import pathlib
import re
import sys

DECL = re.compile(
    r"^\s*(?:@\[[^\]]*\]\s*)*(?:private\s+|protected\s+|noncomputable\s+)*"
    r"(?:theorem|lemma|def|instance|abbrev|structure|class)\s+"
    r"([A-Za-z_][A-Za-z0-9_.']*)", re.M)

# Commands that remove a file outright.
REMOVES = re.compile(
    r"(?:^|[;&|]\s*|\s)(?:rm|unlink|shred|git\s+rm)(?:\s|$)", re.I)
# Commands that rewrite a file in place, losing whatever was there.
REWRITES = re.compile(
    r"(?:^|[;&|]\s*|\s)(?:mv|truncate|sed\s+-i|perl\s+-i\S*|"
    r"git\s+checkout|git\s+restore)(?:\s|$)", re.I)
# `> file` but not `>> file`, and not a file descriptor like 2>&1.
TRUNCATING_REDIRECT = re.compile(r"(?<![>\d])>(?![>&])\s*([^\s;&|<>]+)")
TEE_OVERWRITE = re.compile(r"\|\s*tee\s+(?!-a\b|--append\b)([^\s;&|]+)")
# Commands with no explicit path that can still take out the whole tree.
SWEEPING = re.compile(
    r"git\s+reset\s+[^;&|]*--hard"
    r"|git\s+clean\s+-\S*f"
    r"|git\s+(?:checkout|restore)\s+(?:--\s+)?\.(?:\s|$)"
    r"|rm\s+-\S*[rR]\S*\s", re.I)

TOKEN = re.compile(r"\"[^\"]*\"|'[^']*'|[^\s;&|<>()]+")


def config(project: pathlib.Path) -> dict:
    cfg = project / ".provenance-project.json"
    try:
        return json.loads(cfg.read_text()) if cfg.exists() else {}
    except (OSError, json.JSONDecodeError):
        return {}


def certified_names(project: pathlib.Path):
    """Every declaration the author has recorded as checked, and where."""
    out = {}
    conf = config(project)

    master = project / (conf.get("master") or "")
    if master.exists():
        txt = master.read_text(errors="ignore")
        for m in re.finditer(r"\\lean\{([^}]*)\}", txt, re.S):
            for n in m.group(1).split(","):
                n = n.strip().split(".")[-1]
                if n:
                    out.setdefault(n, "the master's \\lean{} tag")

    bp = project / (conf.get("blueprint") or "")
    if bp.exists():
        for n in re.findall(r"`([A-Za-z][A-Za-z0-9_.']{5,})`",
                            bp.read_text(errors="ignore")):
            out.setdefault(n.split(".")[-1], "the certificate table")

    bdir = project / "blueprint"
    if bdir.exists():
        for j in bdir.glob("*.json"):
            for n in re.findall(r'"([A-Za-z][A-Za-z0-9_.\']{5,})"',
                                j.read_text(errors="ignore")):
                out.setdefault(n.split(".")[-1], "the provenance manifest")
    return out


def removed_decls(old: str, new: str):
    before = {n.split(".")[-1] for n in DECL.findall(old or "")}
    after = {n.split(".")[-1] for n in DECL.findall(new or "")}
    return before - after


def decls_in(paths) -> set:
    found = set()
    for p in paths:
        try:
            found |= {n.split(".")[-1]
                      for n in DECL.findall(p.read_text(errors="ignore"))}
        except OSError:
            continue
    return found


def lean_targets(command: str, project: pathlib.Path):
    """Existing .lean files this command line could reach."""
    candidates = [t.strip("\"'") for t in TOKEN.findall(command)]
    candidates += TRUNCATING_REDIRECT.findall(command)
    candidates += TEE_OVERWRITE.findall(command)
    hits = []
    for raw in candidates:
        raw = raw.strip("\"'")
        if not raw or raw.startswith("-"):
            continue
        try:
            p = pathlib.Path(raw)
            p = p if p.is_absolute() else project / raw
            if p.is_file() and p.suffix == ".lean":
                hits.append(p)
            elif p.is_dir():
                hits.extend(sorted(p.rglob("*.lean")))
        except OSError:
            continue
    return hits


def all_lean(project: pathlib.Path):
    src = project / str(config(project).get("source_dir") or project.name)
    return sorted(src.rglob("*.lean")) if src.is_dir() else []


def refuse(hits, how: str) -> int:
    print(f"{how} — this removes declaration(s) the author has recorded "
          "as checked:\n", file=sys.stderr)
    for n, where in hits[:12]:
        print(f"    {n}\n        recorded in {where}", file=sys.stderr)
    if len(hits) > 12:
        print(f"    … and {len(hits) - 12} more", file=sys.stderr)
    print(
        "\nDeletion runs 2.05x the healthy-era rate in this project and it is "
        "the one medium whose damage is not undone by redoing the work, "
        "because the work was already done.\n"
        "\nThis is not a ban. It is a refusal to do it SILENTLY. If the "
        "removal is intended, say so to the author and set "
        "PROVENANCE_DELETE_GUARD=off for that command.",
        file=sys.stderr)
    return 2


def main() -> int:
    if os.environ.get("PROVENANCE_DELETE_GUARD", "").lower() == "off":
        return 0
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0
    tool = payload.get("tool_name", "")
    inp = payload.get("tool_input") or {}
    project = pathlib.Path(payload.get("cwd") or ".").resolve()

    # ---- the shell surface ------------------------------------------------
    if tool == "Bash":
        command = str(inp.get("command") or "")
        if not command:
            return 0
        sweeping = bool(SWEEPING.search(command))
        touches = bool(REMOVES.search(command) or REWRITES.search(command)
                       or TRUNCATING_REDIRECT.search(command)
                       or TEE_OVERWRITE.search(command))
        if not (sweeping or touches):
            return 0
        targets = lean_targets(command, project)
        if sweeping and not targets:
            # No path named, but the command reaches the whole working tree.
            targets = all_lean(project)
        if not targets:
            return 0
        certified = certified_names(project)
        hits = sorted((n, certified[n]) for n in decls_in(targets)
                      if n in certified)
        if not hits:
            return 0
        return refuse(hits, "COMMAND REFUSED")

    # ---- the editor surface ------------------------------------------------
    if tool not in {"Write", "Edit", "MultiEdit"}:
        return 0
    path = str(inp.get("file_path") or "")
    if not path.endswith(".lean"):
        return 0

    edits = inp.get("edits") or [inp]
    gone = set()
    for e in edits:
        old = e.get("old_string")
        new = e.get("new_string")
        if old is None and "content" in e:
            # a Write replaces the whole file: compare against what is on disk
            p = pathlib.Path(path)
            old = p.read_text(errors="ignore") if p.exists() else ""
            new = e.get("content") or ""
        gone |= removed_decls(old or "", new or "")

    if not gone:
        return 0
    certified = certified_names(project)
    hits = sorted((n, certified[n]) for n in gone if n in certified)
    if not hits:
        return 0
    return refuse(hits, "EDIT REFUSED")


if __name__ == "__main__":
    sys.exit(main())
