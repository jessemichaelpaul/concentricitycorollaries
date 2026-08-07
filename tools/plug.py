#!/usr/bin/env python3
"""Check the formal relation between one master object and one Lean declaration.

The check is deliberately type-sensitive:

* a definition/structure/inductive declaration must BE the author's object;
* a theorem/axiom must mention the author's exact object in its elaborated type.

Object names in the paper may be short.  Lean resolves them against the live
environment and refuses ambiguous suffixes; the paper is never forced to carry
project namespace boilerplate.  The result can be emitted as structured JSON so
the ledger renders machine data rather than reparsing prose.
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
ROOT_MODULE = (os.environ.get("PROVENANCE_IMPORT_MODULE") or
               CFG.get("root_module") or CFG["source_dir"])
AUDIT_TIMEOUT = int(CFG.get("audit_timeout_seconds", 900))
ALLOWED_AXIOMS = set(CFG.get(
    "allowed_axioms", ["propext", "Classical.choice", "Quot.sound"]
))
LEAN_NAME = re.compile(r"^[A-Za-z_][A-Za-z0-9_'.]*(?:\.[A-Za-z_][A-Za-z0-9_']*)*$")


def name_candidates(decl: str, obj: str) -> list[str]:
    """Preferred canonical spellings before the kernel performs a suffix search."""
    if "." in obj:
        return [obj]
    parent = decl.rsplit(".", 1)[0] if "." in decl else ""
    values = [f"{parent}.{obj}" if parent else obj,
              f"{ROOT_MODULE}.{obj}", obj]
    return list(dict.fromkeys(values))


def lean_probe(decl: str, obj: str) -> tuple[subprocess.CompletedProcess[str], str]:
    candidates = name_candidates(decl, obj)
    preferred = ", ".join(f"`{name}" for name in candidates)
    object_text = json.dumps(obj)

    src = f"""import {ROOT_MODULE}
open Lean

open Lean in
run_cmd do
  let env <- Lean.getEnv
  match env.find? `{decl} with
  | none =>
      Lean.logInfo "PLUG_DECL_NOT_FOUND"
  | some di =>
      let kind : String := match di with
        | .thmInfo _    => "theorem"
        | .axiomInfo _  => "axiom"
        | .defnInfo _   => "definition"
        | .opaqueInfo _ => "opaque"
        | .quotInfo _   => "quotient"
        | .inductInfo _ => "inductive"
        | .ctorInfo _   => "constructor"
        | .recInfo _    => "recursor"
      Lean.logInfo ("PLUG_DECL_KIND " ++ kind)
      let preferred : List Name := [{preferred}]
      let preferred := preferred.eraseDups.filter fun n => (env.find? n).isSome
      let objectText := {object_text}
      let suffixMatches := env.constants.toList.foldl (init := []) fun acc entry =>
        let n := entry.1
        let rendered := toString n
        if rendered == objectText || rendered.endsWith ("." ++ objectText) then
          n :: acc
        else
          acc
      let resolved := match preferred with
        | [n] => Except.ok n
        | [] => match suffixMatches.eraseDups with
          | [n] => Except.ok n
          | [] => Except.error "PLUG_OBJECT_NOT_FOUND"
          | ns => Except.error
              ("PLUG_OBJECT_AMBIGUOUS " ++
                String.intercalate "," (ns.map toString))
        | ns => Except.error
            ("PLUG_OBJECT_AMBIGUOUS " ++
              String.intercalate "," (ns.map toString))
      match resolved with
      | .error msg => Lean.logInfo msg
      | .ok objectName =>
          Lean.logInfo ("PLUG_OBJECT_RESOLVED " ++ toString objectName)
          let direct := di.type.getUsedConstants.toList
          Lean.logInfo
            ("PLUG_DIRECT_CONSTANTS " ++
              String.intercalate "," (direct.map toString))
          if kind == "theorem" || kind == "axiom" then
            if direct.contains objectName then
              Lean.logInfo "PLUG_RELATION occurrence"
            else
              Lean.logInfo "PLUG_RELATION not_instantiated"
          else if di.name == objectName then
            Lean.logInfo "PLUG_RELATION identity"
          else
            Lean.logInfo "PLUG_RELATION different_definition"

#print axioms {decl}
"""
    probe = tempfile.NamedTemporaryFile("w", suffix=".lean", delete=False)
    probe.write(src)
    probe.close()
    try:
        run = subprocess.run(
            ["lake", "env", "lean", probe.name], cwd=ROOT,
            capture_output=True, text=True, encoding="utf-8", errors="replace",
            timeout=AUDIT_TIMEOUT,
        )
    finally:
        os.unlink(probe.name)
    return run, src


def marker(out: str, key: str) -> str | None:
    for line in out.splitlines():
        if key in line:
            return line.split(key, 1)[1].strip()
    return None


def axiom_surface(out: str) -> list[str] | None:
    match = re.search(r"depends on axioms: \[([^\]]*)\]", out)
    if match:
        return [a.strip() for a in match.group(1).split(",") if a.strip()]
    if "does not depend on any axioms" in out:
        return []
    return None


def literal_axiom_print(out: str) -> str | None:
    """Return Lean's literal #print axioms line, without reconstructing it."""
    return next(
        (line.strip() for line in out.splitlines()
         if "depends on axioms:" in line or "does not depend on any axioms" in line),
        None,
    )


def first_error(out: str) -> str:
    return next((line.strip() for line in out.splitlines() if "error:" in line),
                "Lean produced no certification result")


def check(decl: str, obj: str, *, build: bool = True) -> dict[str, object]:
    base: dict[str, object] = {
        "schema": 1,
        "declaration": decl,
        "author_object": obj,
    }
    if not LEAN_NAME.fullmatch(decl) or not LEAN_NAME.fullmatch(obj):
        return base | {
            "code": "INVALID_NAME", "kernel": "not_checked",
            "semantic_relation": "not_checked",
            "message": "The declaration or object mark is not a valid Lean name.",
        }

    if build:
        try:
            built = subprocess.run(
                ["lake", "build", ROOT_MODULE], cwd=ROOT, capture_output=True,
                text=True, encoding="utf-8", errors="replace",
                timeout=AUDIT_TIMEOUT,
            )
        except subprocess.TimeoutExpired:
            return base | {
                "code": "AUDIT_TOOL_TIMEOUT", "kernel": "not_checked",
                "semantic_relation": "not_checked", "module": ROOT_MODULE,
                "message": (f"the exact module build exceeded the operational "
                            f"{AUDIT_TIMEOUT}-second bound; this has no mathematical meaning"),
            }
        if built.returncode != 0:
            detail = next((line.strip() for line in (built.stdout + built.stderr).splitlines()
                           if "error:" in line), "the exact import module did not build")
            return base | {
                "code": "IMPORT_MODULE_UNAVAILABLE", "kernel": "not_checked",
                "semantic_relation": "not_checked", "module": ROOT_MODULE,
                "message": detail,
            }

    try:
        run, _ = lean_probe(decl, obj)
    except subprocess.TimeoutExpired:
        return base | {
            "code": "AUDIT_TOOL_TIMEOUT", "kernel": "not_checked",
            "semantic_relation": "not_checked", "module": ROOT_MODULE,
            "message": (f"the exact certification query exceeded the operational "
                        f"{AUDIT_TIMEOUT}-second bound; this has no mathematical meaning"),
        }
    out = run.stdout + run.stderr
    if "PLUG_DECL_NOT_FOUND" in out:
        return base | {
            "code": "DECLARATION_NOT_FOUND", "kernel": "not_checked",
            "semantic_relation": "not_checked",
            "message": f"No live Lean declaration named `{decl}` was found.",
        }

    kind = marker(out, "PLUG_DECL_KIND")
    if not kind:
        return base | {
            "code": "CHECK_FAILED", "kernel": "rejected",
            "semantic_relation": "not_checked",
            "message": first_error(out),
        }

    axioms = axiom_surface(out)
    axiom_print = literal_axiom_print(out)
    if axioms is None or axiom_print is None:
        return base | {
            "code": "CHECK_FAILED", "kernel": "rejected",
            "declaration_kind": kind,
            "semantic_relation": "not_checked",
            "message": first_error(out),
        }
    unapproved = sorted(set(axioms) - ALLOWED_AXIOMS)
    surface = {
        "axioms": axioms, "axiom_print": axiom_print,
        "unapproved_axioms": unapproved, "module": ROOT_MODULE,
    }

    ambiguous = marker(out, "PLUG_OBJECT_AMBIGUOUS")
    if ambiguous is not None:
        return base | surface | {
            "code": "OBJECT_AMBIGUOUS", "kernel": "checked",
            "declaration_kind": kind,
            "semantic_relation": "unresolved",
            "candidates": [x for x in ambiguous.split(",") if x],
            "message": f"The short object mark `{obj}` resolves to more than one live object.",
        }
    if "PLUG_OBJECT_NOT_FOUND" in out:
        return base | surface | {
            "code": "OBJECT_NOT_FOUND", "kernel": "checked",
            "declaration_kind": kind,
            "semantic_relation": "unresolved",
            "message": f"No live Lean object matching `{obj}` was found.",
        }

    resolved = marker(out, "PLUG_OBJECT_RESOLVED")
    relation = marker(out, "PLUG_RELATION")
    direct_text = marker(out, "PLUG_DIRECT_CONSTANTS") or ""
    direct = [x for x in direct_text.split(",") if x]
    if resolved is None or relation is None or axioms is None or axiom_print is None:
        return base | {
            "code": "CHECK_FAILED", "kernel": "rejected",
            "declaration_kind": kind,
            "semantic_relation": relation or "not_checked",
            "message": first_error(out),
        }

    common = base | surface | {
        "declaration_kind": kind,
        "resolved_object": resolved,
        "semantic_relation": relation,
        "direct_type_constants": direct,
    }
    if "sorryAx" in axioms:
        kernel = "open"
    elif not set(axioms).issubset(ALLOWED_AXIOMS):
        return common | {
            "code": "UNAPPROVED_AXIOMS", "kernel": "uncertified",
            "message": "Lean accepted the declaration, but its axiom surface is not approved.",
        }
    else:
        kernel = "certified"

    matched = relation in {"identity", "occurrence"}
    if matched and kernel == "certified":
        code = "TRIPLE_CERTIFIABLE"
        message = "The declaration is inference-certified at the object marked in the master."
    elif matched:
        code = "INFERENCE_OPEN"
        message = "The declaration is at the marked object, but its proof depends on sorryAx."
    elif kernel == "certified":
        code = "GENERIC_INSTANTIATION"
        message = "The inference is certified, but not instantiated at the object marked in the master."
    else:
        code = "GENERIC_AND_OPEN"
        message = "The declaration is unfinished and is not instantiated at the marked object."
    return common | {"code": code, "kernel": kernel, "message": message}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("declaration")
    parser.add_argument("author_object")
    parser.add_argument("--json", action="store_true")
    parser.add_argument("--module")
    parser.add_argument("--no-build", action="store_true")
    args = parser.parse_args()
    if args.module:
        global ROOT_MODULE
        ROOT_MODULE = args.module
    result = check(args.declaration, args.author_object, build=not args.no_build)
    if args.json:
        print(json.dumps(result, sort_keys=True))
    else:
        print(f"{result['code']}  {result['message']}")
    # The semantic plug succeeds only when the declaration is actually at the
    # author-marked object.  The ledger still consumes JSON from nonzero cases,
    # but hooks and CI cannot mistake a generic theorem for an instantiation.
    return 0 if result["code"] in {
        "TRIPLE_CERTIFIABLE", "INFERENCE_OPEN",
    } else 1


if __name__ == "__main__":
    raise SystemExit(main())
