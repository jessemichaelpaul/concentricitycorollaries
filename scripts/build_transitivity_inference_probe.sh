#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
theorem_source="$repo_root/Concentricity/Theorem.lean"
audit_source="$repo_root/Concentricity/_GateNorthCResidueTransitivityAudit.lean"
probe_source="${TMPDIR:-/tmp}/concentricity-transitivity-inference-probe.lean"

marker_count="$(grep -c '^/-- \*\*THE RESULT\*\*' "$theorem_source")"
if [[ "$marker_count" -ne 1 ]]; then
  echo "Expected exactly one transitivity boundary marker; found $marker_count." >&2
  exit 2
fi

# The production helpers end immediately before the open transitivity theorem.
# Compile that exact current-source prefix together with the focused receipts.
# This deliberately does not import Concentricity.Theorem: an unfinished
# production module has no fresh olean, and an old olean must never count as
# current evidence.
awk '
  FNR == NR {
    if ($0 ~ /^\/-- \*\*THE RESULT\*\*/) stopped = 1
    if (!stopped) print
    next
  }
  FNR > 1 { print }
' "$theorem_source" "$audit_source" > "$probe_source"

cd "$repo_root"
lake env lean "$probe_source"
