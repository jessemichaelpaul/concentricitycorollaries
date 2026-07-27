#!/usr/bin/env bash
# verify.sh — INDEPENDENT kernel check. Run this yourself; it trusts no prose.
# It asks Lean directly whether the claims hold. Usage:  bash verify.sh
set -uo pipefail
cd "$(dirname "$0")"
export PATH="$HOME/.elan/bin:$PATH"

echo "============================================================"
echo " 1. lake build ALL modules — the kernel is the arbiter (want: 'Build completed successfully')"
echo "    (builds every module, not just the root closure — leaf files like"
echo "     IntegrateTheorem are outside it and would otherwise hide breakage)"
echo "============================================================"
ls Concentricity/*.lean | sed 's|Concentricity/|Concentricity.|; s|\.lean||' | xargs lake build 2>&1 | tail -4

echo
echo "============================================================"
echo " 2. sorries / escape hatches in the SOURCE (want: only ASection.concentricity)"
echo "============================================================"
grep -rnE '\bsorry\b|\badmit\b|native_decide' Concentricity/*.lean \
  | grep -vE '`sorry`|UNFORMALIZED|R8|marks|docstring|--' || echo "  (none found in code)"

echo
echo "============================================================"
echo " 3. DECLARED axioms in the project (R9 target: zero)"
echo "============================================================"
grep -rnE '^axiom ' Concentricity/*.lean || echo "  (none — no project axioms declared)"

echo
echo "============================================================"
echo " 4. Lean prints the theorem's STATEMENT and its AXIOMS itself"
echo "    sorryAx here => there is a real gap somewhere in the proof tree."
echo "============================================================"
cat > Concentricity/_Verify.lean <<'EOF'
import Concentricity.ConcentricityReadout
#check @ASection.concentricity
#print axioms ASection.concentricity
EOF
lake build Concentricity._Verify 2>&1 \
  | grep -iE 'ASection.concentricity :|depends on axioms' || echo "  (build failed — see 'lake build Concentricity._Verify')"
rm -f Concentricity/_Verify.lean

echo
echo "Done. You verified this against the kernel, not against anything I told you."
