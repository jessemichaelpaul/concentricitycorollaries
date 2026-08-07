#!/usr/bin/env bash
# new_project.sh — instantiate a locked provenance validator for one project.
#
# The paths are BAKED IN at creation and then fixed. This is deliberate: a
# runtime --project flag is something the assistant could set wrong, whereas a
# compiled-in path cannot be pointed anywhere else. Each project gets its own
# binary, its own spent-permission ledger, and its own master. Nothing is shared
# and nothing crosses.
#
#   ./new_project.sh "Conway FWT" ~/Desktop/conway-fwt ConwayFWT_master.tex Conway
#                     ^mirror      ^repo               ^master              ^lean src dir
set -euo pipefail

if [ $# -ne 4 ]; then
  echo "usage: $0 <ProjectName> <repo-path> <master-filename> <lean-source-dir>" >&2
  exit 2
fi

NAME="$1"; REPO="$(cd "$2" 2>/dev/null && pwd || echo "$2")"
MASTER="$3"; SRCDIR="$4"
HERE="$(cd "$(dirname "$0")" && pwd)"
MIRROR="$HOME/Desktop/$NAME"

# Claude Code keys its transcript directory on the repo path with / -> -
TRANSCRIPT="$(printf '%s' "$REPO" | sed 's|/|-|g')"

echo "project      : $NAME"
echo "repo         : $REPO"
echo "master       : $MASTER"
echo "lean sources : $SRCDIR/*.lean"
echo "transcripts  : $TRANSCRIPT"
echo "mirror       : $MIRROR"
echo

mkdir -p "$MIRROR" "$REPO/tools"

bake () {  # bake <template> <destination>
  sed -e "s|@@SOURCE_GLOB@@|$SRCDIR/*.lean|g" \
      -e "s|@@MASTER@@|$MASTER|g" \
      -e "s|@@TRANSCRIPT_DIR@@|$TRANSCRIPT|g" \
      "$1" > "$2"
}

bake "$HERE/Provenance.hs.template"  "$MIRROR/Provenance.hs"
bake "$HERE/axioms_of.py.template"   "$REPO/tools/axioms_of.py"
bake "$HERE/decl_sig.py.template"    "$REPO/tools/decl_sig.py"
bake "$HERE/user_says.py.template"   "$REPO/tools/user_says.py"
chmod +x "$REPO/tools/"*.py

if grep -q '@@' "$MIRROR/Provenance.hs" "$REPO/tools/"*.py 2>/dev/null; then
  echo "ERROR: unsubstituted placeholders remain — refusing to build." >&2
  grep -n '@@' "$MIRROR/Provenance.hs" "$REPO/tools/"*.py >&2 || true
  exit 1
fi

echo "compiling locked validator …"
( cd "$MIRROR" && ghc -O2 -v0 Provenance.hs -o provenance 2>&1 | grep -v '^ld: warning' || true )
[ -x "$MIRROR/provenance" ] || { echo "ERROR: build produced no binary" >&2; exit 1; }

cat > "$MIRROR/ProjectManifest.md" <<EOF
# $NAME — locked provenance instance

This validator is compiled with these paths **baked in**. It cannot report on any
other project, and its permissions cannot be spent on any other master.

| | |
|---|---|
| repository | \`$REPO\` |
| master | \`$MASTER\` |
| Lean sources | \`$SRCDIR/*.lean\` |
| transcript directory | \`$TRANSCRIPT\` |
| spent-permission ledger | \`$REPO/.provenance-spent\` |

Run:

\`\`\`bash
"$MIRROR/provenance" <claims-file> "$REPO"
\`\`\`

Regenerate from the template only by re-running \`new_project.sh\`; do not edit the
baked paths by hand, or the lock means nothing.
EOF

echo
echo "done."
echo "  binary   : $MIRROR/provenance"
echo "  manifest : $MIRROR/ProjectManifest.md"
echo "  helpers  : $REPO/tools/{axioms_of,decl_sig,user_says}.py"
