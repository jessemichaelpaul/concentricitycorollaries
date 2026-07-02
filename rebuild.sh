#!/bin/zsh
# Rebuild the blueprint website from Octonionic_RH_master.tex.
#
#   ./rebuild.sh        (works from any directory)
#
# Steps: (1) re-extract blueprint/src/{masterdefs,content}.tex from the master
# (read-only; the master is never modified), (2) run the plasTeX web build.
# Output: blueprint/web/index.html  --  serve it with: leanblueprint serve
set -e
cd "$(dirname "$0")"
export PATH="$HOME/.local/micromamba/envs/blueprint/bin:$PATH"

python3 scripts/extract_blueprint_content.py

# leanblueprint web swallows plastex failures (always exits 0), so prove the
# build really happened: remove the old index and require a fresh non-empty one.
rm -f blueprint/web/index.html
leanblueprint web
if [ ! -s blueprint/web/index.html ]; then
  echo "ERROR: build did not produce blueprint/web/index.html" >&2
  exit 1
fi
echo "OK: site rebuilt in blueprint/web/  --  now run: leanblueprint serve"
