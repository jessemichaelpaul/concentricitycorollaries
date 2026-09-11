#!/usr/bin/env bash
# Release verification for Concentricity. This is intentionally strict:
# ordinary authoring may contain an honest open step, but a release may not.

set -euo pipefail

source_only=false
if [ "${1:-}" = "--source-only" ]; then
    source_only=true
elif [ "$#" -ne 0 ]; then
    echo "usage: $0 [--source-only]" >&2
    exit 2
fi

project_root=$(cd "$(dirname "$0")" && pwd)
cd "$project_root"

verify_tmp=$(mktemp -d "${TMPDIR:-/tmp}/concentricity-verify.XXXXXX")
build_log="$verify_tmp/build.txt"
probe_file="$verify_tmp/Verify.lean"
probe_output="$verify_tmp/axioms.txt"
cleanup() {
    rm -f "$build_log" "$probe_file" "$probe_output"
    rmdir "$verify_tmp" 2>/dev/null || true
}
trap cleanup EXIT

if [ "$source_only" = false ]; then
    echo "[1/4] Building the public library and every Lean module"
    if ! lake build Concentricity > "$build_log" 2>&1; then
        tail -n 200 "$build_log" >&2
        exit 1
    fi
    if ! find Concentricity -maxdepth 1 -type f -name '*.lean' -print \
            | sed 's|/|.|g; s|\.lean$||' \
            | sort \
            | xargs lake build >> "$build_log" 2>&1; then
        tail -n 200 "$build_log" >&2
        exit 1
    fi
    echo "  all Lean modules built"
else
    echo "[1/4] Build skipped for source-only diagnostics"
fi

echo "[2/4] Checking source for executable escape hatches and project axioms"
python3 - "$project_root" <<'PY'
from __future__ import annotations

import pathlib
import re
import sys


root = pathlib.Path(sys.argv[1])
paths = [root / "Concentricity.lean", *sorted((root / "Concentricity").glob("*.lean"))]


def code_only(text: str) -> str:
    """Blank Lean comments and strings while preserving lines and columns."""
    out: list[str] = []
    i = 0
    block_depth = 0
    in_line_comment = False
    in_string = False
    escaped = False
    while i < len(text):
        char = text[i]
        pair = text[i:i + 2]
        if in_line_comment:
            if char == "\n":
                in_line_comment = False
                out.append(char)
            else:
                out.append(" ")
            i += 1
            continue
        if block_depth:
            if pair == "/-":
                block_depth += 1
                out.extend("  ")
                i += 2
            elif pair == "-/":
                block_depth -= 1
                out.extend("  ")
                i += 2
            else:
                out.append("\n" if char == "\n" else " ")
                i += 1
            continue
        if in_string:
            out.append("\n" if char == "\n" else " ")
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            i += 1
            continue
        if pair == "--":
            in_line_comment = True
            out.extend("  ")
            i += 2
        elif pair == "/-":
            block_depth = 1
            out.extend("  ")
            i += 2
        elif char == '"':
            in_string = True
            out.append(" ")
            i += 1
        else:
            out.append(char)
            i += 1
    return "".join(out)


violations: list[str] = []
escape = re.compile(r"\b(?:sorry|admit|native_decide)\b")
declared_axiom = re.compile(
    r"(?m)^[ \t]*(?:@\[[^\]\n]*\][ \t]*)*"
    r"(?:(?:private|protected|local|scoped|noncomputable|unsafe)[ \t]+)*"
    r"axioms?[ \t]+"
)
for path in paths:
    text = code_only(path.read_text(encoding="utf-8"))
    for match in escape.finditer(text):
        line = text.count("\n", 0, match.start()) + 1
        violations.append(f"{path.relative_to(root)}:{line}: executable {match.group(0)}")
    for match in declared_axiom.finditer(text):
        line = text.count("\n", 0, match.start()) + 1
        violations.append(f"{path.relative_to(root)}:{line}: project-declared axiom")

if violations:
    print("Release verification failed:", file=sys.stderr)
    for item in violations:
        print(f"  {item}", file=sys.stderr)
    raise SystemExit(1)

print("  no executable escape hatches or project-declared axioms")
PY

if [ "$source_only" = true ]; then
    echo "Source-only checks passed"
    exit 0
fi

echo "[3/4] Asking Lean for the two release axiom surfaces"
cat > "$probe_file" <<'EOF'
import Concentricity.Theorem
import Concentricity.Corollaries

#check @ASection.concentricity
#print axioms ASection.concentricity
#check @zeta_riemannHypothesis
#print axioms zeta_riemannHypothesis
EOF

lake env lean "$probe_file" 2>&1 | tee "$probe_output"

python3 - "$probe_output" <<'PY'
from __future__ import annotations

import pathlib
import re
import sys


text = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
targets = ("ASection.concentricity", "zeta_riemannHypothesis")
expected = {"propext", "Classical.choice", "Quot.sound"}

for target in targets:
    pattern = re.compile(
        rf"'{re.escape(target)}' depends on axioms: \[([^\]]*)\]"
    )
    match = pattern.search(text)
    if not match:
        print(f"Release verification failed: no literal axiom result for {target}", file=sys.stderr)
        raise SystemExit(1)
    axioms = [item.strip() for item in match.group(1).split(",") if item.strip()]
    if len(axioms) != len(expected) or set(axioms) != expected:
        print(
            f"Release verification failed: {target} uses {axioms}; "
            f"expected {sorted(expected)}",
            file=sys.stderr,
        )
        raise SystemExit(1)
    print(f"  {target}: {', '.join(axioms)}")
PY

echo "[4/4] Release Lean checks passed"
