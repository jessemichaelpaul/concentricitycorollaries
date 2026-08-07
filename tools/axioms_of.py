#!/usr/bin/env python3
"""Print the live, literal axiom surface of one exact Lean declaration.

The helper imports one explicit module and runs ``#print axioms``.  It never
searches Mathlib for related declarations.  A timeout or import failure is an
audit-tool state, not a statement about the mathematics.
"""
from __future__ import annotations

import argparse
import json
import os
import pathlib
import re
import subprocess
import tempfile


ROOT = pathlib.Path(__file__).resolve().parent.parent
CFG = json.loads((ROOT / ".provenance-project.json").read_text())
DEFAULT_MODULE = (os.environ.get("PROVENANCE_IMPORT_MODULE") or
                  CFG.get("root_module") or CFG["source_dir"])
TIMEOUT = int(CFG.get("audit_timeout_seconds", 900))
LEAN_NAME = re.compile(r"^[A-Za-z_][A-Za-z0-9_'.]*(?:\.[A-Za-z_][A-Za-z0-9_']*)*$")


def result(name: str, module: str, build: bool) -> dict[str, object]:
    base: dict[str, object] = {"schema": 1, "declaration": name, "module": module}
    if not LEAN_NAME.fullmatch(name) or not LEAN_NAME.fullmatch(module):
        return base | {"code": "INVALID_NAME", "message": "invalid Lean declaration or module name"}
    if build:
        try:
            built = subprocess.run(
                ["lake", "build", module], cwd=ROOT, capture_output=True,
                text=True, encoding="utf-8", errors="replace", timeout=TIMEOUT,
            )
        except subprocess.TimeoutExpired:
            return base | {
                "code": "AUDIT_TOOL_TIMEOUT",
                "message": (f"exact module build exceeded the operational {TIMEOUT}-second "
                            "bound; this has no mathematical meaning"),
            }
        if built.returncode != 0:
            detail = next((line.strip() for line in (built.stdout + built.stderr).splitlines()
                           if "error:" in line), "exact import module did not build")
            return base | {"code": "IMPORT_MODULE_UNAVAILABLE", "message": detail}

    with tempfile.NamedTemporaryFile("w", suffix=".lean", delete=False) as probe:
        probe.write(f"import {module}\n#print axioms {name}\n")
        path = probe.name
    try:
        try:
            run = subprocess.run(
                ["lake", "env", "lean", path], cwd=ROOT, capture_output=True,
                text=True, encoding="utf-8", errors="replace", timeout=TIMEOUT,
            )
        except subprocess.TimeoutExpired:
            return base | {
                "code": "AUDIT_TOOL_TIMEOUT",
                "message": (f"exact axiom query exceeded the operational {TIMEOUT}-second "
                            "bound; this has no mathematical meaning"),
            }
    finally:
        os.unlink(path)

    output = run.stdout + run.stderr
    literal = next((line.strip() for line in output.splitlines()
                    if "depends on axioms:" in line or
                    "does not depend on any axioms" in line), None)
    match = re.search(r"depends on axioms: \[([^\]]*)\]", output)
    if match:
        axioms = [item.strip() for item in match.group(1).split(",") if item.strip()]
    elif "does not depend on any axioms" in output:
        axioms = []
    else:
        detail = next((line.strip() for line in output.splitlines() if "error:" in line),
                      "Lean produced no literal axiom line")
        return base | {"code": "AXIOM_QUERY_UNAVAILABLE", "message": detail}
    return base | {"code": "AXIOM_PRINTED", "axioms": axioms, "axiom_print": literal}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("declaration")
    parser.add_argument("--module", default=DEFAULT_MODULE)
    parser.add_argument("--no-build", action="store_true")
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()
    value = result(args.declaration, args.module, not args.no_build)
    if args.json:
        print(json.dumps(value, sort_keys=True))
    elif value["code"] == "AXIOM_PRINTED":
        print("AXIOM_PRINT " + str(value["axiom_print"]))
        print("AXIOMS " + ", ".join(str(item) for item in value["axioms"]))
    else:
        print(f"UNKNOWN {value.get('message', value['code'])}")
    return 0 if value["code"] == "AXIOM_PRINTED" else 1


if __name__ == "__main__":
    raise SystemExit(main())
