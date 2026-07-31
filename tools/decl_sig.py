#!/usr/bin/env python3
"""Print the SIGNATURE of a Lean declaration: from its keyword line up to the
start of the proof (:= / by / where). That signature is the STATEMENT — what the
theorem is about — as distinct from the proof term."""
import re, sys, pathlib
name = sys.argv[1]; base = name.split(".")[-1]
KW = r"(?:noncomputable\s+)?(?:private\s+|protected\s+)?(?:theorem|lemma|def|instance|abbrev|structure)"
pat = re.compile(rf"^{KW}\s+(?:[A-Za-z_][A-Za-z0-9_']*\.)*{re.escape(base)}\b")
root = pathlib.Path(__file__).resolve().parent.parent
for f in sorted(root.glob("Concentricity/*.lean")):
    lines = f.read_text(errors="ignore").split("\n")
    for i, l in enumerate(lines):
        if pat.match(l):
            out = []
            for j in range(i, min(i + 60, len(lines))):
                out.append(lines[j])
                if j > i and re.search(r":=|\bby\s*$|\bwhere\s*$", lines[j]):
                    break
            print("\n".join(out)); sys.exit(0)
sys.exit(1)
