#!/bin/sh
# Show or widen the declared read surface for the active seat.
#
#   scripts/surface.sh                    show the seat and its current surface
#   scripts/surface.sh add PATH [PATH...] add paths to the surface
#   scripts/surface.sh remove PATH        take a path back out
#   scripts/surface.sh restore            undo the last change
#
# The surface is found by content, not by key name: it is the list in
# .provenance-project.json that contains Octonionic_RH_master.tex.  Every
# change writes .provenance-project.json.bak first, so `restore` always works.
# Only the author runs this.
set -e
cd "$(dirname "$0")/.."

python3 - "$@" <<'PYTHON'
import json
import pathlib
import shutil
import sys

MANIFEST = pathlib.Path(".provenance-project.json")
BACKUP = pathlib.Path(".provenance-project.json.bak")
ANCHOR = "Octonionic_RH_master.tex"

args = sys.argv[1:]
cmd = args[0] if args else "show"
operands = args[1:]

if cmd == "restore":
    if not BACKUP.exists():
        print("no backup to restore from")
        raise SystemExit(1)
    shutil.copy(BACKUP, MANIFEST)
    print("restored .provenance-project.json from backup")
    raise SystemExit(0)

data = json.loads(MANIFEST.read_text())


def find_surface(node, trail=()):
    """Yield (json-path, list) for every list of strings holding the anchor."""
    if isinstance(node, list):
        if any(isinstance(x, str) and ANCHOR in x for x in node):
            yield trail, node
        for i, item in enumerate(node):
            yield from find_surface(item, trail + (i,))
    elif isinstance(node, dict):
        for key, item in node.items():
            yield from find_surface(item, trail + (key,))


found = list(find_surface(data))

if not found:
    print("could not locate a read surface containing", ANCHOR)
    print("manifest top-level keys:", ", ".join(sorted(data.keys())))
    raise SystemExit(1)

if len(found) > 1:
    print("found more than one candidate surface; refusing to guess:")
    for trail, _ in found:
        print("  ", " -> ".join(str(t) for t in trail))
    raise SystemExit(1)

trail, surface = found[0]
where = " -> ".join(str(t) for t in trail)

if cmd == "show":
    seat = data.get("seat") or data.get("active_seat") or "(seat key not found)"
    print("seat:   ", seat)
    print("surface:", where)
    print("phase:  ", data.get("phase", "(none)"))
    print()
    for entry in surface:
        print("   ", entry)
    raise SystemExit(0)

if cmd not in ("add", "remove"):
    print("usage: scripts/surface.sh [show|add PATH...|remove PATH|restore]")
    raise SystemExit(1)

if not operands:
    print("no paths given")
    raise SystemExit(1)

before = list(surface)

if cmd == "add":
    for p in operands:
        if p in surface:
            print("already present:", p)
        else:
            surface.append(p)
            print("added:", p)
else:
    for p in operands:
        if p in surface:
            surface.remove(p)
            print("removed:", p)
        else:
            print("not present:", p)

if surface == before:
    print("no change")
    raise SystemExit(0)

shutil.copy(MANIFEST, BACKUP)
MANIFEST.write_text(json.dumps(data, indent=2) + "\n")
print()
print("wrote .provenance-project.json (backup at .provenance-project.json.bak)")
print("surface is now:")
for entry in surface:
    print("   ", entry)
PYTHON
