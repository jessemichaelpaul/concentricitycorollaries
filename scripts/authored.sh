#!/bin/sh
# "Is this Jesse's construction?" — asked mechanically.
#
#   scripts/authored.sh              summary counts
#   scripts/authored.sh unclaimed    live declarations the master never names
#   scripts/authored.sh dangling     \lean{} names with no live declaration
#   scripts/authored.sh check NAME   verdict for one declaration
#
# It does NOT judge mathematics.  It asks one question the master can answer:
# does the author's own text claim this declaration, via a \lean{} tag?
#
# A declaration the master never names is not yet part of the authored
# argument.  It may be scaffolding, a transcription artifact, or someone's
# paraphrase of a step the author states differently — which is exactly the
# failure recorded on 2026-08-05, where northProducersConnectedAmbient carried
# an existential over two STATE-indexed stabilizer parts while the author's
# r_1, r_2 are the residual factors of two RUNS of one construction.  That
# statement was never his, so it could not be closed.
#
# Unclaimed is a flag, not a verdict: private helpers and Mathlib-shaped
# plumbing are legitimately unnamed.  The point is to look before proving.
set -e
cd "$(dirname "$0")/.."

python3 - "${1:-summary}" "${2:-}" <<'PYTHON'
import pathlib
import re
import sys

cmd = sys.argv[1]
arg = sys.argv[2] if len(sys.argv) > 2 else ""

master = pathlib.Path("Octonionic_RH_master.tex").read_text()

# Every name the author claims, from \lean{...} tags (which may list several,
# comma separated, and may wrap across lines).
claimed = set()
for block in re.findall(r"\\lean\{([^}]*)\}", master, re.S):
    for name in block.split(","):
        name = name.strip().replace("\n", "")
        if name:
            claimed.add(name)

# Every live top-level declaration, excluding quarantined _Gate/_ audit files.
DECL = re.compile(
    r"^(?:@\[[^\]]*\]\s*)?"
    r"(?:private\s+|protected\s+|noncomputable\s+)*"
    r"(?:theorem|lemma|def|abbrev|instance)\s+"
    r"([A-Za-z_][A-Za-z0-9_.']*)"
)

live = {}
for path in sorted(pathlib.Path("Concentricity").glob("*.lean")):
    if path.name.startswith("_"):
        continue
    namespace = ""
    for line in path.read_text().splitlines():
        ns = re.match(r"^namespace\s+([A-Za-z_][A-Za-z0-9_.']*)", line)
        if ns:
            namespace = ns.group(1)
            continue
        if re.match(r"^end\b", line):
            namespace = ""
            continue
        m = DECL.match(line)
        if m:
            short = m.group(1)
            full = f"{namespace}.{short}" if namespace and "." not in short else short
            live[full] = (path.name, short)

claimed_tails = {n.split(".")[-1] for n in claimed}

def status(full, short):
    """TAGGED  — the master names it in a \\lean{} tag.
       NAMED   — it appears in the master's prose but in no tag.
       ABSENT  — it appears nowhere in the master.

    ABSENT does NOT mean the step is not the author's.  The master states its
    argument in prose; a declaration can be the typist's name for a step the
    author writes without naming.  ABSENT means only: nobody has tied this
    declaration to a place in his text, so it has not been checked against it.
    """
    if (full in claimed or short in claimed
            or full.split(".")[-1] in claimed_tails
            or short.split(".")[-1] in claimed_tails):
        return "TAGGED"
    tail = full.split(".")[-1]
    if tail in master or short in master:
        return "NAMED"
    return "ABSENT"

def is_claimed(full, short):
    return status(full, short) != "ABSENT"

if cmd == "check":
    if not arg:
        print("usage: scripts/authored.sh check NAME")
        raise SystemExit(1)
    hits = [(f, v) for f, v in live.items()
            if arg in (f, v[1], f.split(".")[-1], v[1].split(".")[-1])]
    if not hits:
        print(f"{arg}: no live declaration by that name")
        raise SystemExit(1)
    note = {
        "TAGGED": "the master names it in a \\lean tag",
        "NAMED":  "named in the master's prose, but in no \\lean tag",
        "ABSENT": "appears nowhere in the master — not checked against his text",
    }
    for full, (fname, short) in hits:
        st = status(full, short)
        print(f"{st:8}  {full}  ({fname}) — {note[st]}")
    raise SystemExit(0)

unclaimed = {f: v for f, v in live.items() if not is_claimed(f, v[1])}
dangling = sorted(n for n in claimed
                  if n not in live and n.split(".")[-1] not in {v[1] for v in live.values()})

if cmd == "unclaimed":
    by_file = {}
    for full, (fname, _) in sorted(unclaimed.items()):
        by_file.setdefault(fname, []).append(full)
    for fname in sorted(by_file):
        print(f"\n{fname}")
        for full in by_file[fname]:
            print(f"    {full}")
    raise SystemExit(0)

if cmd == "dangling":
    for n in dangling:
        print(n)
    raise SystemExit(0)

print(f"names claimed by the master (\\lean tags): {len(claimed)}")
print(f"live top-level declarations:              {len(live)}")
print(f"  claimed:                                {len(live) - len(unclaimed)}")
print(f"  UNCLAIMED (master never names them):    {len(unclaimed)}")
print(f"dangling \\lean names (no live decl):      {len(dangling)}")
print()
print("scripts/authored.sh unclaimed   to list them")
print("scripts/authored.sh dangling    to list stale tags")
print("scripts/authored.sh check NAME  for one verdict")
PYTHON
