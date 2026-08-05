#!/bin/sh
# Switch the provenance phase between formalization and authoring.
#
#   scripts/phase.sh                 show the current phase
#   scripts/phase.sh authoring       unlock the master for a prose pass
#   scripts/phase.sh formalization   re-lock it
#
# The master is read-only while the phase is `formalization`; the claim gate
# self-disables while it is `authoring`.  Only the author runs this.
set -e
cd "$(dirname "$0")/.."

case "${1:-show}" in
  show|authoring|formalization) ;;
  *)
    echo "usage: scripts/phase.sh [show|authoring|formalization]" >&2
    exit 1
    ;;
esac

python3 - "${1:-show}" <<'PYTHON'
import json
import pathlib
import sys

want = sys.argv[1]
path = pathlib.Path(".provenance-project.json")
data = json.loads(path.read_text())
current = data.get("phase", "formalization")

if want == "show":
    print("phase is", current)
    raise SystemExit(0)

if current == want:
    print("phase is already", current)
    raise SystemExit(0)

data["phase"] = want
path.write_text(json.dumps(data, indent=2) + "\n")
print("phase", current, "->", want)
if want == "authoring":
    print("the master is now writable; the claim gate is off until you switch back")
else:
    print("the master is locked again; the claim gate is back on")
PYTHON
