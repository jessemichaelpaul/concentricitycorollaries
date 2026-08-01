#!/usr/bin/env python3
"""Print the LIVE axiom surface of a Lean declaration, by elaborating it now.

Never guesses. Prints exactly one of:
    AXIOMS <comma-separated list>     the kernel said so, just now
    UNKNOWN <reason>                  could not be determined — NOT to be read as clean

The distinction matters: reading an axiom line out of a stored evidence file is
reading yesterday's answer. This asks today's."""
import re, sys, pathlib, subprocess, tempfile, os

name = sys.argv[1]; base = name.split(".")[-1]
ROOT = pathlib.Path(__file__).resolve().parent.parent
KW = r"(?:noncomputable\s+)?(?:private\s+|protected\s+)?(?:theorem|lemma|def|instance|abbrev|structure)"
pat = re.compile(rf"^{KW}\s+(?:[A-Za-z_][A-Za-z0-9_']*\.)*{re.escape(base)}\b")

src = None
for f in sorted(ROOT.glob("Concentricity/*.lean")):
    for l in f.read_text(errors="ignore").split("\n"):
        if pat.match(l):
            src = f; break
    if src: break
if src is None:
    print(f"UNKNOWN no declaration named {name} in the live sources"); sys.exit(1)

module = "Concentricity." + src.stem
probe = tempfile.NamedTemporaryFile("w", suffix=".lean", delete=False)
probe.write(f"import {module}\n#print axioms {name}\n"); probe.close()
try:
    r = subprocess.run(["lake", "env", "lean", probe.name], cwd=ROOT,
                       capture_output=True, text=True, timeout=900)
finally:
    os.unlink(probe.name)

m = re.search(r"depends on axioms: \[([^\]]*)\]", r.stdout + r.stderr)
if m:
    print("AXIOMS " + m.group(1)); sys.exit(0)
if "does not depend on any axioms" in (r.stdout + r.stderr):
    print("AXIOMS "); sys.exit(0)
first = next((l for l in (r.stdout + r.stderr).split("\n") if "error" in l), "no axiom line")
print(f"UNKNOWN {first.strip()[:160]}"); sys.exit(1)
