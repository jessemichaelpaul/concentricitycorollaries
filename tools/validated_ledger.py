#!/usr/bin/env python3
"""Generate a readable ledger from the author's master and live Lean checks.

The table contains only rendered author text and deterministic text produced
from structured plug results.  It has no cell in which an assistant can add an
assessment or qualification.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import pathlib
import re
import shutil
import subprocess
import sys
import tempfile
import threading


ROOT = pathlib.Path(__file__).resolve().parent.parent
CFG = json.loads((ROOT / ".provenance-project.json").read_text())
MASTER = ROOT / CFG["master"]
PROJECT = CFG["name"]
SOURCE_DIR = ROOT / CFG["source_dir"]
OUT = ROOT / "Ledger.md"
PDF_OUT = ROOT / "output" / "pdf" / "ProvenanceLedger.pdf"
TEX_OUT = ROOT / "output" / "pdf" / "ProvenanceLedger.tex"
PDF_TMP = ROOT / "tmp" / "pdfs"
CLAIMS_OUT = ROOT / ".provenance" / "claims.json"
ENVS = r"(theorem|lemma|definition|proposition|corollary)"
LAST_REPORT: dict[str, object] = {}
MODULE_CACHE: dict[str, tuple[str | None, str, str | None]] = {}
SOURCE_LINES: dict[pathlib.Path, list[str]] | None = None
BUILD_CACHE: dict[str, dict[str, object] | None] = {}
BUILD_LOCK = threading.Lock()
AUDIT_TIMEOUT = int(CFG.get("audit_timeout_seconds", 900))

_lock = pathlib.Path.home() / ".provenance-active"
if _lock.exists() and pathlib.Path(_lock.read_text().strip()).resolve() != ROOT.resolve():
    print(f"REFUSED: the active project is not {PROJECT}.")
    raise SystemExit(3)


def render_latex(t: str) -> str:
    """Render common prose markup while preserving math for Markdown viewers."""
    t = re.sub(r"\\authorobject\{[^}]*\}\{[^}]*\}", "", t)
    t = re.sub(r"\\lean\{[^}]*\}|\\uses\{[^}]*\}|\\leanok", "", t)
    t = re.sub(r"\\emph\{([^}]*)\}", r"*\1*", t)
    t = re.sub(r"\\textbf\{([^}]*)\}", r"**\1**", t)
    t = re.sub(r"\\texttt\{([^}]*)\}", r"`\1`", t)
    t = re.sub(r"\\textup\{([^}]*)\}", r"\1", t)
    t = re.sub(r"\\label\{[^}]*\}", "", t)
    return re.sub(r"\s+", " ", t).strip()


def statement_latex(t: str) -> str:
    """Keep the author's typesetting while removing provenance-only commands."""
    t = re.sub(r"\\authorobject\{[^}]*\}\{[^}]*\}", "", t)
    t = re.sub(r"\\lean\{[^}]*\}|\\uses\{[^}]*\}|\\leanok", "", t)
    return t.strip()


def environments() -> list[dict[str, object]]:
    text = MASTER.read_text()
    rows: list[dict[str, object]] = []
    for match in re.finditer(
        # A theorem title can contain nested citation brackets.  Titles are
        # single-line in the master, so consume through the last bracket on
        # that line instead of stopping at the first citation bracket.
        rf"\\begin\{{{ENVS}\}}(\[[^\n]*\])?\\label\{{([^}}]+)\}}", text
    ):
        kind = match.group(1)
        title = (match.group(2) or "")[1:-1]
        label = match.group(3)
        end = text.find(f"\\end{{{kind}}}", match.end())
        body = text[match.end(): end if end >= 0 else match.end() + 4000]
        decls = [d.strip() for group in re.findall(r"\\lean\{([^}]*)\}", body)
                 for d in group.split(",") if d.strip()]
        # Semantic anchors must be deliberate provenance marks, never an
        # incidental code-font word in the readable paper.  The two-argument
        # form pairs a declaration with the author's exact Lean object while
        # remaining invisible in the rendered master.
        anchors = re.findall(r"\\authorobject\{([^}]+)\}\{([^}]+)\}", body)
        objects = [re.sub(r"\\[-_]|\\", "", value).strip()
                   for _, value in anchors]
        objects = [o for o in objects
                   if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_'.]*", o)]
        rows.append({
            "kind": kind,
            "title": title,
            "label": label,
            "declarations": list(dict.fromkeys(decls)),
            "objects": list(dict.fromkeys(objects)),
            "anchor_pairs": [(decl.strip(), obj.strip()) for decl, obj in anchors],
            "statement": render_latex(body),
            "statement_latex": statement_latex(body),
        })
    return rows


def check_pairs(declarations: list[str], objects: list[str]) -> list[tuple[str, str]]:
    """Equal lists pair in order; otherwise the first marked object is primary."""
    if len(declarations) > 1 and len(declarations) == len(objects):
        return list(zip(declarations, objects))
    if objects:
        return [(decl, objects[0]) for decl in declarations]
    return []


def declaration_target(decl: str) -> tuple[str | None, str, str | None]:
    """Resolve one exact declaration to a project module or configured library shelf.

    Only project sources are indexed.  A declaration absent from those sources
    is classified as an external library reference and queried through the one
    configured import module.  The validator never searches Mathlib for a
    related theorem.
    """
    if decl in MODULE_CACHE:
        return MODULE_CACHE[decl]
    external_configured = CFG.get("external_declaration_modules", {})
    if isinstance(external_configured, dict) and decl in external_configured:
        value = (str(external_configured[decl]), "external", None)
        MODULE_CACHE[decl] = value
        return value
    configured = CFG.get("declaration_modules", {})
    if isinstance(configured, dict) and decl in configured:
        value = (str(configured[decl]), "project", None)
        MODULE_CACHE[decl] = value
        return value
    base = re.escape(decl.rsplit(".", 1)[-1])
    declaration = re.compile(
        rf"^\s*(?:@\[[^\]]*\]\s*)*"
        rf"(?:(?:noncomputable|private|protected)\s+)*(?:def|abbrev|opaque|"
        rf"theorem|lemma|structure|class|inductive|instance)\s+(?:_root_\.)?"
        rf"(?:[A-Za-z0-9_'.]+\.)?{base}(?=\s|:|:=|where|$)"
    )
    field = re.compile(rf"^\s+{base}\s*:")
    global SOURCE_LINES
    if SOURCE_LINES is None:
        SOURCE_LINES = {
            path: path.read_text(errors="ignore").splitlines()
            for path in sorted(SOURCE_DIR.rglob("*.lean"))
        }
    candidates: list[pathlib.Path] = []
    field_candidates: list[pathlib.Path] = []
    for path, lines in SOURCE_LINES.items():
        if any(declaration.search(line) for line in lines):
            candidates.append(path)
        elif any(field.search(line) for line in lines):
            field_candidates.append(path)
    paths = list(dict.fromkeys(candidates or field_candidates))
    if len(paths) == 1:
        relative = paths[0].relative_to(ROOT).with_suffix("")
        value = (".".join(relative.parts), "project", None)
    elif len(paths) > 1:
        rendered = ", ".join(str(path.relative_to(ROOT)) for path in paths)
        value = (None, "project", "declaration source is ambiguous: " + rendered)
    else:
        external = (CFG.get("external_import_module") or
                    CFG.get("library_probe_module") or CFG.get("root_module") or
                    CFG["source_dir"])
        value = (str(external), "external", None)
    MODULE_CACHE[decl] = value
    return value


def module_failure_for_origin(failure: dict[str, object] | None,
                              origin: str) -> dict[str, object] | None:
    if failure is None:
        return None
    value = dict(failure) | {"origin": origin}
    if value.get("code") == "IMPORT_MODULE_UNAVAILABLE":
        value["code"] = ("PRODUCTION_MODULE_OPEN" if origin == "project"
                         else "EXTERNAL_IMPORT_UNAVAILABLE")
    return value


def ensure_module(module: str, origin: str) -> dict[str, object] | None:
    """Freshen exactly one import module; never let another module erase it."""
    with BUILD_LOCK:
        if module in BUILD_CACHE:
            return module_failure_for_origin(BUILD_CACHE[module], origin)
        try:
            run = subprocess.run(
                ["lake", "build", module], cwd=ROOT, capture_output=True,
                text=True, encoding="utf-8", errors="replace",
                timeout=AUDIT_TIMEOUT,
            )
        except subprocess.TimeoutExpired:
            failure = {
                "code": "AUDIT_TOOL_TIMEOUT", "kernel": "not_checked",
                "semantic_relation": "not_checked", "module": module,
                "origin": origin,
                "message": (f"the exact module build exceeded the operational "
                            f"{AUDIT_TIMEOUT}-second bound; this has no mathematical meaning"),
            }
            BUILD_CACHE[module] = failure
            return module_failure_for_origin(failure, origin)
        if run.returncode != 0:
            detail = next(
                (line.strip() for line in (run.stdout + run.stderr).splitlines()
                 if "error:" in line),
                "the exact import module did not build",
            )
            failure = {
                "code": "IMPORT_MODULE_UNAVAILABLE", "kernel": "not_checked",
                "semantic_relation": "not_checked", "module": module,
                "origin": origin, "message": detail,
            }
            BUILD_CACHE[module] = failure
            return module_failure_for_origin(failure, origin)
        BUILD_CACHE[module] = None
        return None


def prepare_modules(targets: list[tuple[str, str]]) -> None:
    """Freshen modules together, recursively isolating only failing subsets."""
    by_module: dict[str, str] = {}
    for module, origin in targets:
        if module not in BUILD_CACHE:
            by_module[module] = ("project" if origin == "project"
                                 else by_module.get(module, origin))
    pending = list(by_module.items())

    def prepare(group: list[tuple[str, str]]) -> None:
        if not group:
            return
        modules = [module for module, _ in group]
        try:
            run = subprocess.run(
                ["lake", "--rehash", "--no-build", "build", *modules],
                cwd=ROOT, capture_output=True,
                text=True, encoding="utf-8", errors="replace",
                timeout=AUDIT_TIMEOUT,
            )
        except subprocess.TimeoutExpired:
            run = None
        if run is not None and run.returncode == 0:
            for module, _ in group:
                BUILD_CACHE[module] = None
            return
        if len(group) > 1:
            middle = len(group) // 2
            prepare(group[:middle])
            prepare(group[middle:])
            return
        module, origin = group[0]
        if run is None:
            BUILD_CACHE[module] = {
                "code": "AUDIT_TOOL_TIMEOUT", "kernel": "not_checked",
                "semantic_relation": "not_checked", "module": module,
                "origin": origin,
                "message": (f"the exact module build exceeded the operational "
                            f"{AUDIT_TIMEOUT}-second bound; this has no mathematical meaning"),
            }
            return
        try:
            built = subprocess.run(
                ["lake", "build", module], cwd=ROOT, capture_output=True,
                text=True, encoding="utf-8", errors="replace",
                timeout=AUDIT_TIMEOUT,
            )
        except subprocess.TimeoutExpired:
            built = None
        if built is not None and built.returncode == 0:
            BUILD_CACHE[module] = None
            return
        if built is None:
            BUILD_CACHE[module] = {
                "code": "AUDIT_TOOL_TIMEOUT", "kernel": "not_checked",
                "semantic_relation": "not_checked", "module": module,
                "origin": origin,
                "message": (f"the exact stale module build exceeded the operational "
                            f"{AUDIT_TIMEOUT}-second bound; this has no mathematical meaning"),
            }
            return
        detail = next(
            (line.strip() for line in (built.stdout + built.stderr).splitlines()
             if "error:" in line), "the exact import module did not build")
        BUILD_CACHE[module] = {
            "code": "IMPORT_MODULE_UNAVAILABLE",
            "kernel": "not_checked", "semantic_relation": "not_checked",
            "module": module, "origin": origin, "message": detail,
        }

    prepare(pending)


def classified_axiom_result(decl: str, module: str, origin: str,
                            axioms: list[str], literal: str) -> dict[str, object]:
    unapproved = sorted(set(axioms) - set(CFG.get("allowed_axioms", [])))
    if "sorryAx" in axioms:
        code = ("EXTERNAL_INFERENCE_OPEN" if origin == "external"
                else "INFERENCE_OPEN_UNANCHORED")
    elif unapproved:
        code = "UNAPPROVED_AXIOMS"
    else:
        code = ("EXTERNAL_AXIOM_CERTIFIED" if origin == "external"
                else "AXIOM_CERTIFIED_UNANCHORED")
    return {
        "code": code, "declaration": decl, "author_object": "—",
        "semantic_relation": "not_checked", "origin": origin,
        "kernel": "certified" if not unapproved else "uncertified",
        "axioms": axioms, "axiom_print": literal,
        "unapproved_axioms": unapproved, "module": module,
    }


def run_axiom_module_batch(module: str, origin: str,
                           declarations: list[str]) -> dict[str, dict[str, object]]:
    """Run one exact axiom probe for every requested name in one exact module."""
    failure = ensure_module(module, origin)
    if failure:
        return {decl: {"declaration": decl, "author_object": "—"} | failure
                for decl in declarations}
    source = f"import {module}\n" + "".join(
        f"#print axioms {decl}\n" for decl in declarations)
    with tempfile.NamedTemporaryFile("w", suffix=".lean", delete=False) as handle:
        handle.write(source)
        probe = handle.name
    try:
        try:
            run = subprocess.run(
                ["lake", "env", "lean", probe], cwd=ROOT, capture_output=True,
                text=True, encoding="utf-8", errors="replace",
                timeout=AUDIT_TIMEOUT,
            )
        except subprocess.TimeoutExpired:
            return {decl: {
                "code": "AUDIT_TOOL_TIMEOUT", "declaration": decl,
                "author_object": "—", "semantic_relation": "not_checked",
                "kernel": "not_checked", "module": module, "origin": origin,
                "message": (f"the exact module axiom query exceeded the operational "
                            f"{AUDIT_TIMEOUT}-second bound; this has no mathematical meaning"),
            } for decl in declarations}
    finally:
        os.unlink(probe)

    output = run.stdout + run.stderr
    printed: dict[str, tuple[list[str], str]] = {}
    pattern = re.compile(
        r"^'(.+)' (depends on axioms: \[([^\]]*)\]|does not depend on any axioms)$",
        re.MULTILINE,
    )
    for match in pattern.finditer(output):
        axioms = ([item.strip() for item in (match.group(3) or "").split(",")
                   if item.strip()] if "depends on axioms" in match.group(2) else [])
        printed[match.group(1)] = (axioms, match.group(0))
    line_errors: dict[int, str] = {}
    for line in output.splitlines():
        found = re.search(rf"{re.escape(probe)}:(\d+):\d+: error: (.*)", line)
        if found:
            line_errors[int(found.group(1))] = found.group(2)

    results: dict[str, dict[str, object]] = {}
    for index, decl in enumerate(declarations, 2):
        value = printed.get(decl)
        if value is None:
            suffix = decl.rsplit(".", 1)[-1]
            matches = [entry for name, entry in printed.items()
                       if name == suffix or name.endswith("." + suffix)]
            value = matches[0] if len(matches) == 1 else None
        if value is not None:
            results[decl] = classified_axiom_result(
                decl, module, origin, value[0], value[1])
            continue
        code = ("EXTERNAL_DECLARATION_NOT_IMPORTED" if origin == "external"
                else "DECLARATION_AUDIT_OPEN")
        results[decl] = {
            "code": code, "declaration": decl, "author_object": "—",
            "semantic_relation": "not_checked", "kernel": "not_checked",
            "origin": origin, "module": module,
            "message": line_errors.get(index, "Lean produced no literal axiom line"),
        }
    return results


def run_axiom_verified_shelf(
    groups: dict[tuple[str, str], list[str]],
) -> dict[str, dict[str, object]]:
    """Probe all independently fresh modules together, splitting on import failure."""
    items = list(groups.items())
    if not items:
        return {}

    def probe(subset: list[tuple[tuple[str, str], list[str]]]
              ) -> dict[str, dict[str, object]]:
        ready: list[tuple[tuple[str, str], list[str]]] = []
        results: dict[str, dict[str, object]] = {}
        for (module, origin), declarations in subset:
            failure = ensure_module(module, origin)
            if failure:
                for decl in declarations:
                    results[decl] = {"declaration": decl, "author_object": "—"} | failure
            else:
                ready.append(((module, origin), declarations))
        if not ready:
            return results
        modules = list(dict.fromkeys(module for (module, _), _ in ready))
        requests = [(decl, module, origin)
                    for (module, origin), declarations in ready
                    for decl in declarations]
        source = "".join(f"import {module}\n" for module in modules)
        source += "".join(f"#print axioms {decl}\n" for decl, _, _ in requests)
        with tempfile.NamedTemporaryFile("w", suffix=".lean", delete=False) as handle:
            handle.write(source)
            path = handle.name
        try:
            try:
                run = subprocess.run(
                    ["lake", "env", "lean", path], cwd=ROOT, capture_output=True,
                    text=True, encoding="utf-8", errors="replace",
                    timeout=AUDIT_TIMEOUT,
                )
            except subprocess.TimeoutExpired:
                run = None
        finally:
            os.unlink(path)
        if run is None:
            if len(ready) > 1:
                middle = len(ready) // 2
                return results | probe(ready[:middle]) | probe(ready[middle:])
            (module, origin), declarations = ready[0]
            return results | {decl: {
                "code": "AUDIT_TOOL_TIMEOUT", "declaration": decl,
                "author_object": "—", "semantic_relation": "not_checked",
                "kernel": "not_checked", "module": module, "origin": origin,
                "message": (f"the verified-shelf axiom query exceeded the operational "
                            f"{AUDIT_TIMEOUT}-second bound; this has no mathematical meaning"),
            } for decl in declarations}

        output = run.stdout + run.stderr
        printed: dict[str, tuple[list[str], str]] = {}
        pattern = re.compile(
            r"^'(.+)' (depends on axioms: \[([^\]]*)\]|does not depend on any axioms)$",
            re.MULTILINE,
        )
        for match in pattern.finditer(output):
            axioms = ([item.strip() for item in (match.group(3) or "").split(",")
                       if item.strip()] if "depends on axioms" in match.group(2) else [])
            printed[match.group(1)] = (axioms, match.group(0))
        # An import error occurs before any axiom command.  Split shelves so
        # its module is isolated and the other literal prints remain available.
        if not printed and run.returncode != 0 and len(ready) > 1:
            middle = len(ready) // 2
            return results | probe(ready[:middle]) | probe(ready[middle:])
        line_errors: dict[int, str] = {}
        for line in output.splitlines():
            found = re.search(rf"{re.escape(path)}:(\d+):\d+: error: (.*)", line)
            if found:
                line_errors[int(found.group(1))] = found.group(2)
        first_command_line = len(modules) + 1
        for offset, (decl, module, origin) in enumerate(requests):
            value = printed.get(decl)
            if value is None:
                suffix = decl.rsplit(".", 1)[-1]
                matches = [entry for name, entry in printed.items()
                           if name == suffix or name.endswith("." + suffix)]
                value = matches[0] if len(matches) == 1 else None
            if value is not None:
                results[decl] = classified_axiom_result(
                    decl, module, origin, value[0], value[1])
                continue
            results[decl] = {
                "code": ("EXTERNAL_DECLARATION_NOT_IMPORTED"
                         if origin == "external" else "DECLARATION_AUDIT_OPEN"),
                "declaration": decl, "author_object": "—",
                "semantic_relation": "not_checked", "kernel": "not_checked",
                "origin": origin, "module": module,
                "message": line_errors.get(first_command_line + offset,
                                           "Lean produced no literal axiom line"),
            }
        return results

    return probe(items)


def run_plug(decl: str, obj: str) -> dict[str, object]:
    module, origin, resolution_error = declaration_target(decl)
    if resolution_error or module is None:
        return {
            "code": "DECLARATION_MODULE_UNRESOLVED", "declaration": decl,
            "author_object": obj, "semantic_relation": "not_checked",
            "kernel": "not_checked", "origin": origin,
            "message": resolution_error or "no exact import module was resolved",
        }
    if origin == "external":
        return run_axiom_only(decl)
    failure = ensure_module(module, origin)
    if failure:
        return {"declaration": decl, "author_object": obj} | failure
    env = dict(os.environ)
    env["PROVENANCE_IMPORT_MODULE"] = module
    try:
        run = subprocess.run(
            ["python3", "tools/plug.py", "--json", "--no-build", decl, obj],
            cwd=ROOT, capture_output=True, text=True, env=env,
            encoding="utf-8", errors="replace", timeout=AUDIT_TIMEOUT,
        )
    except subprocess.TimeoutExpired:
        return {
            "code": "AUDIT_TOOL_TIMEOUT", "declaration": decl,
            "author_object": obj, "semantic_relation": "not_checked",
            "kernel": "not_checked", "module": module, "origin": origin,
            "message": (f"the exact certification query exceeded the operational "
                        f"{AUDIT_TIMEOUT}-second bound; this has no mathematical meaning"),
        }
    for line in reversed(run.stdout.splitlines()):
        try:
            value = json.loads(line)
        except json.JSONDecodeError:
            continue
        if isinstance(value, dict):
            return value
    detail = (run.stderr or run.stdout or "plug produced no output").strip()
    return {
        "code": "CHECK_FAILED", "declaration": decl, "author_object": obj,
        "kernel": "rejected", "semantic_relation": "not_checked",
        "message": detail,
    }


def run_axiom_only(decl: str) -> dict[str, object]:
    """Ask Lean for declaration existence and axioms without inventing an object."""
    module, origin, resolution_error = declaration_target(decl)
    if resolution_error or module is None:
        return {
            "code": "DECLARATION_MODULE_UNRESOLVED", "declaration": decl,
            "author_object": "—", "semantic_relation": "not_checked",
            "kernel": "not_checked", "origin": origin,
            "message": resolution_error or "no exact import module was resolved",
        }
    return run_axiom_module_batch(module, origin, [decl])[decl]


def useful_constants(result: dict[str, object]) -> list[str]:
    values = [str(x) for x in result.get("direct_type_constants", [])]
    project_values = [x for x in values if x.startswith(CFG["source_dir"] + ".")]
    return (project_values or values)[:8]


def object_relation(result: dict[str, object]) -> str:
    """Render the semantic link as its own axis, independent of proof status."""
    relation = str(result.get("semantic_relation", "not_checked"))
    obj = f"`{result.get('author_object', '—')}`"
    if relation == "identity":
        return f"**identity** — the declaration is {obj}"
    if relation == "occurrence":
        return f"**exact occurrence** — {obj} is in the elaborated theorem type"
    if relation in {"not_instantiated", "different_definition"}:
        return f"**not instantiated** — the checked declaration is generic or about a different object than {obj}"
    if relation == "unresolved":
        return f"**unresolved** — {obj} has no unique live Lean identity yet"
    return "**not checked**"


def axiom_surface(result: dict[str, object]) -> str:
    """Show every axiom reported by Lean, even when another axis fails."""
    if "axioms" not in result:
        return "**not available** — Lean did not reach an axiom query"
    axioms = [str(value) for value in result.get("axioms", [])]
    literal = str(result.get("axiom_print", "")).strip()
    suffix = f"<br>Lean: `{literal}`" if literal else ""
    if not axioms:
        return "**∅** — Lean reports no axioms" + suffix
    rendered = ", ".join(f"`{value}`" for value in axioms)
    if "sorryAx" in axioms:
        return f"**open:** {rendered}" + suffix
    unapproved = set(str(value) for value in result.get("unapproved_axioms", []))
    if unapproved:
        return f"**not approved:** {rendered}" + suffix
    return f"**approved:** {rendered}" + suffix


def imported_receipts() -> dict[str, object]:
    path = ROOT / "tools" / "receipt_import.py"
    if not path.exists():
        return {"status": "NOT_CONFIGURED", "by_label": {}, "clauses": {}}
    spec = importlib.util.spec_from_file_location("project_receipt_import", path)
    if spec is None or spec.loader is None:
        return {"status": "RECEIPT_IMPORT_FAILED", "by_label": {}, "clauses": {}}
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    reuse = os.environ.get("PROVENANCE_REUSE_CURRENT_RECEIPTS") == "1"
    return module.load_receipts(run_fresh=not reuse)


def seed_receipt_open_modules(receipts: dict[str, object]) -> None:
    """Use current exact open-seat receipts instead of rebuilding known-open modules."""
    if receipts.get("status") != "RECEIPTS_CURRENT":
        return
    open_modules: dict[str, str] = {}
    buckets = receipts.get("by_label", {})
    if isinstance(buckets, dict):
        for bucket in buckets.values():
            if not isinstance(bucket, dict):
                continue
            for row in bucket.get("open", []):
                source = ROOT / str(row.get("source", ""))
                try:
                    module = ".".join(source.relative_to(ROOT).with_suffix("").parts)
                except ValueError:
                    continue
                diagnostic = str(row.get("kernel_message") or
                                 row.get("diagnostic") or "exact open seat")
                open_modules[module] = diagnostic
    changed = True
    project_sources = list(SOURCE_DIR.rglob("*.lean"))
    root_source = ROOT / f"{CFG.get('root_module', CFG['source_dir'])}.lean"
    if root_source.exists():
        project_sources.append(root_source)
    while changed:
        changed = False
        for source in project_sources:
            module = ".".join(source.relative_to(ROOT).with_suffix("").parts)
            if module in open_modules:
                continue
            imports = re.findall(r"^import\s+([A-Za-z_][A-Za-z0-9_'.]*)",
                                 source.read_text(errors="ignore"), re.MULTILINE)
            dependency = next((name for name in imports if name in open_modules), None)
            if dependency:
                open_modules[module] = f"dependency chain reaches {dependency}"
                changed = True
    for module, diagnostic in open_modules.items():
        BUILD_CACHE[module] = {
            "code": "IMPORT_MODULE_UNAVAILABLE", "kernel": "not_checked",
            "semantic_relation": "not_checked", "module": module,
            "message": ("current exact receipt records an open production seat: " +
                        diagnostic), "receipt_certified_open": True,
        }


def verdict(result: dict[str, object]) -> str:
    code = str(result.get("code", "CHECK_FAILED"))
    decl = f"`{result.get('declaration', '—')}`"
    obj = f"`{result.get('author_object', '—')}`"
    relation = result.get("semantic_relation")
    kind = result.get("declaration_kind")

    if code == "AXIOM_CERTIFIED_UNANCHORED":
        return (f"✓ **Lean accepts {decl} with the approved axiom surface.** "
                "Its authored-object anchor has not yet been ratified.")
    if code == "EXTERNAL_AXIOM_CERTIFIED":
        return (f"✓ **External library dependency {decl} has a kernel-reported, "
                "approved axiom surface.** No authored-object anchor is required.")
    if code == "INFERENCE_OPEN_UNANCHORED":
        return (f"○ **Lean accepts {decl}, but its axiom print contains `sorryAx`.** "
                "Its authored-object anchor is also unratified.")
    if code == "EXTERNAL_INFERENCE_OPEN":
        return (f"○ **External library dependency {decl} has `sorryAx` in its "
                "literal axiom surface.**")
    if code == "EXTERNAL_DECLARATION_NOT_IMPORTED":
        return (f"— **{decl} is classified as an external library reference, but the "
                "configured library shelf does not import that exact name.** No theorem "
                "search or mathematical conclusion was made.")
    if code == "EXTERNAL_IMPORT_UNAVAILABLE":
        return (f"— **The configured external-library import module for {decl} is not "
                "available.** This is an audit configuration state.")
    if code == "PRODUCTION_MODULE_OPEN":
        return (f"○ **The exact production module containing {decl} does not currently "
                "build.** Earlier modules and dedicated receipts remain independent.")
    if code == "AUDIT_TOOL_TIMEOUT":
        return (f"— **The audit process for {decl} exceeded its operational time bound.** "
                "This is not evidence about the declaration or mathematics.")
    if code == "DECLARATION_MODULE_UNRESOLVED":
        return (f"— **The exact project module for {decl} was not uniquely resolved.** "
                "Add a declaration_modules entry; no mathematical conclusion was made.")
    if code == "DECLARATION_AUDIT_OPEN":
        return (f"— **Lean could not import the production module for {decl}.** "
                f"`{result.get('message', 'declaration audit unavailable')}`")

    if code == "TRIPLE_CERTIFIABLE":
        if relation == "identity":
            return f"✓ **Kernel and object checks are complete for {decl} as your object {obj}.** Awaiting author ratification."
        return f"✓ **Kernel and object checks are complete for {decl} about your object {obj}.** Awaiting author ratification."
    if code == "INFERENCE_OPEN":
        noun = "definition" if relation == "identity" else "theorem"
        return f"○ **This {noun} is at your object {obj}, but it is unfinished in Lean** (`sorryAx`)."
    if code == "GENERIC_INSTANTIATION":
        about = useful_constants(result)
        suffix = (" Its elaborated type directly names " +
                  ", ".join(f"`{x}`" for x in about) + ".") if about else ""
        return (f"⚠ **Lean has proved {decl}, but this declaration is not instantiated "
                f"at your object {obj}.** This is a binding/instantiation state, not an "
                f"open inference.{suffix}")
    if code == "GENERIC_AND_OPEN":
        return (f"○ ⚠ **{decl} is unfinished in Lean and is not yet instantiated "
                f"at your object {obj}.**")
    if code == "DECLARATION_NOT_FOUND":
        return (f"— **Your master names {decl}, but no live Lean declaration with that "
                "name exists.** Declaration is open; no inference conclusion is drawn.")
    if code == "OBJECT_NOT_FOUND":
        return (f"— **The object mark {obj} has not yet been resolved to a live Lean "
                "object.** This is a naming/packaging state, not a mathematical rejection.")
    if code == "OBJECT_AMBIGUOUS":
        candidates = ", ".join(f"`{x}`" for x in result.get("candidates", []))
        return f"— **The tool found more than one object named {obj}.** Candidates: {candidates}."
    if code == "UNAPPROVED_AXIOMS":
        axioms = ", ".join(f"`{x}`" for x in result.get("unapproved_axioms", []))
        return f"✗ **Lean accepted {decl}, but its axiom surface is not approved.** {axioms}"
    if code == "INVALID_NAME":
        return f"— **The master mark for {decl} or {obj} is not a valid Lean name.**"
    detail = str(result.get("message", "Lean produced no certification result"))
    return f"✗ **Lean rejected the certification check for {decl}.** `{detail}`"


def receipt_summary_md(label: str, bundle: dict[str, object]) -> str:
    status = str(bundle.get("status", "RECEIPT_IMPORT_FAILED"))
    if status == "NOT_CONFIGURED":
        return "— no project-specific inference/binding exporter configured"
    if status != "RECEIPTS_CURRENT":
        return f"✗ **{status}** — {bundle.get('message', 'receipt import failed')}"
    buckets = bundle.get("by_label", {})
    bucket = buckets.get(label) if isinstance(buckets, dict) else None
    if not isinstance(bucket, dict):
        return "— no supporting local receipt registered for this master clause"
    clauses = bundle.get("clauses", {})
    clause = clauses.get(label, {}) if isinstance(clauses, dict) else {}
    lines = [f"**{clause.get('status', 'RECEIPTS_CURRENT')}**"]
    for row in bucket.get("inference", []):
        lines.append(
            f"Inference `{row.get('receipt', '—')}`: **{row.get('status', '—')}**; "
            f"Lean: `{row.get('axiom_print', 'axiom print unavailable')}`"
        )
    ready = [str(row.get("id", row.get("lean_local", "binding")))
             for row in bucket.get("bindings", []) if row.get("status") == "BINDING_READY"]
    unresolved = [str(row.get("id", row.get("lean_local", "binding")))
                  for row in bucket.get("bindings", []) if row.get("status") != "BINDING_READY"]
    if ready:
        lines.append("Authored bindings ready: " + ", ".join(f"`{x}`" for x in ready))
    if unresolved:
        lines.append("Authored bindings unresolved: " + ", ".join(f"`{x}`" for x in unresolved))
    for row in bucket.get("open", []):
        lines.append(f"Production seat `{row.get('declaration', '—')}`: **{row.get('status', '—')}**")
    for row in bucket.get("rejections", []):
        lines.append(
            f"Exact construction rejected: **{row.get('status', '—')}**; "
            f"Lean: `{row.get('kernel_message', 'literal message unavailable')}`"
        )
    return "<br>".join(lines)


def digest(paths: list[pathlib.Path]) -> str:
    value = hashlib.sha256()
    for path in sorted(paths):
        value.update(str(path.resolve().relative_to(ROOT.resolve())).encode())
        value.update(b"\0")
        value.update(path.read_bytes())
        value.update(b"\0")
    return value.hexdigest()


def link(path: pathlib.Path, label: str) -> str | None:
    if not path.exists():
        return None
    return f"[{label}]({path.relative_to(ROOT).as_posix()})"


def generate() -> str:
    global LAST_REPORT
    rows = environments()
    receipts = imported_receipts()
    seed_receipt_open_modules(receipts)
    master_hash = digest([MASTER])
    lean_files = list(SOURCE_DIR.rglob("*.lean"))
    source_hash = digest(lean_files) if lean_files else "no Lean sources found"
    links = [x for x in [
        "[Rendered provenance ledger](output/pdf/ProvenanceLedger.pdf)",
        link(MASTER.with_suffix(".pdf"), "Rendered master"),
        link(ROOT / str(CFG.get("blueprint", "__no_blueprint__")), "Blueprint"),
    ] if x]

    lines = [
        f"# Ledger — {PROJECT}", "",
        "This ledger is generated from the author’s master and fresh Lean checks.",
        "Its prose is rendered from the master; its verdicts are produced from",
        "the live compiled environment. There is no assistant-assessment column.", "",
    ]
    if links:
        lines += [" · ".join(links), ""]
    lines += [
        f"- Master revision: `{master_hash}`",
        f"- Lean-source revision: `{source_hash}`", "",
        "When a statement marks several objects, the first is its primary object.",
        "When it names equally many declarations and objects, they pair in order.", "",
        "The last three columns are independent. A closed inference cannot conceal a",
        "generic binding, and an exact binding cannot conceal `sorryAx` or another axiom.", "",
        "| # | author statement | author object | Lean declaration | object relation | literal axiom surface | supporting inference / bindings | exact state |",
        "|---|---|---|---|---|---|---|---|",
    ]

    # Run every distinct kernel query once.  A statement with
    # no ratified semantic anchor still receives a fresh declaration/axiom
    # audit; absence of an object mark must never hide the axiom surface.
    jobs: dict[tuple[str, str, str], tuple[str, str | None]] = {}
    for row in rows:
        anchors = dict(row.get("anchor_pairs", []))
        for decl in row["declarations"]:
            obj = anchors.get(decl)
            key = ("plug" if obj else "axiom", decl, obj or "")
            jobs[key] = (decl, obj)
    checked: dict[tuple[str, str, str], dict[str, object]] = {}
    plug_jobs: dict[tuple[str, str, str], tuple[str, str]] = {}
    axiom_groups: dict[tuple[str, str], list[str]] = {}
    module_targets: list[tuple[str, str]] = []
    for _key, (decl, obj) in jobs.items():
        module, origin, resolution_error = declaration_target(decl)
        result_key = (("plug", decl, obj) if obj and origin == "project"
                      else ("axiom", decl, ""))
        if resolution_error or module is None:
            checked[result_key] = {
                "code": "DECLARATION_MODULE_UNRESOLVED", "declaration": decl,
                "author_object": obj or "—", "semantic_relation": "not_checked",
                "kernel": "not_checked", "origin": origin,
                "message": resolution_error or "no exact import module was resolved",
            }
            continue
        module_targets.append((module, origin))
        if obj and origin == "project":
            plug_jobs[result_key] = (decl, obj)
        else:
            group = axiom_groups.setdefault((module, origin), [])
            if decl not in group:
                group.append(decl)

    prepare_modules(module_targets)
    # Every import below has already passed its independent rehashed freshness
    # check.  One verified shelf avoids 146 heavyweight Lean startups; the
    # helper recursively splits if an unexpected import failure occurs.
    for key, (decl, obj) in plug_jobs.items():
        checked[key] = run_plug(decl, obj)
    for decl, result in run_axiom_verified_shelf(axiom_groups).items():
        checked[("axiom", decl, "")] = result

    tally: dict[str, int] = {}
    report_rows: list[dict[str, object]] = []
    for index, row in enumerate(rows, 1):
        declarations = list(row["declarations"])
        objects = list(row["objects"])
        dcell = ", ".join(f"`{x}`" for x in declarations) or "—"
        ocell = ", ".join(f"`{x}`" for x in objects) or "—"
        results: list[dict[str, object]] = []
        if not declarations:
            rendered = "— **No Lean declaration is marked yet.** This does not mean the result is unproved."
            relation = "**not declared**"
            surface = "**not checked**"
            tally["UNTAGGED"] = tally.get("UNTAGGED", 0) + 1
        else:
            anchors = dict(row.get("anchor_pairs", []))
            results = []
            for decl in declarations:
                obj = anchors.get(decl)
                origin = declaration_target(decl)[1]
                key = (("plug", decl, obj) if obj and origin == "project"
                       else ("axiom", decl, ""))
                results.append(checked[key])
            for result in results:
                code = str(result.get("code", "CHECK_FAILED"))
                tally[code] = tally.get(code, 0) + 1
            rendered = "<br>".join(verdict(result) for result in results)
            relation = "<br>".join(object_relation(result) for result in results)
            surface = "<br>".join(axiom_surface(result) for result in results)
        statement = str(row["statement"]).replace("|", "\\|")
        support = receipt_summary_md(str(row["label"]), receipts)
        report_rows.append(dict(row) | {"index": index, "results": results})
        lines.append(
            f"| {index} | {statement} | {ocell} | {dcell} | "
            f"{relation} | {surface} | {support} | {rendered} |"
        )

    labels = {
        "TRIPLE_CERTIFIABLE": "kernel-and-object certified, awaiting author ratification",
        "INFERENCE_OPEN": "matched to the object, proof unfinished",
        "GENERIC_INSTANTIATION": "inference-certified, object instantiation open",
        "GENERIC_AND_OPEN": "proof and object instantiation both open",
        "UNTAGGED": "no Lean declaration marked",
        "NO_OBJECT_MARKED": "no author object marked",
        "DECLARATION_NOT_FOUND": "marked declaration not found",
        "OBJECT_NOT_FOUND": "marked object not resolved",
        "OBJECT_AMBIGUOUS": "object name ambiguous",
        "UNAPPROVED_AXIOMS": "unapproved axiom surface",
        "CHECK_FAILED": "kernel certification check rejected",
        "AXIOM_CERTIFIED_UNANCHORED": "approved axiom surface; authored-object anchor unratified",
        "INFERENCE_OPEN_UNANCHORED": "sorryAx present; authored-object anchor unratified",
        "DECLARATION_AUDIT_OPEN": "production module or declaration not importable",
        "EXTERNAL_AXIOM_CERTIFIED": "external library dependency with approved axiom surface",
        "EXTERNAL_INFERENCE_OPEN": "external library dependency whose axiom surface contains sorryAx",
        "EXTERNAL_DECLARATION_NOT_IMPORTED": "external exact name absent from the configured library shelf",
        "EXTERNAL_IMPORT_UNAVAILABLE": "configured external-library shelf unavailable",
        "PRODUCTION_MODULE_OPEN": "exact production module open",
        "AUDIT_TOOL_TIMEOUT": "audit tooling exceeded its operational bound; no mathematical status",
        "DECLARATION_MODULE_UNRESOLVED": "exact declaration module unresolved",
    }
    lines += ["", "## Tally", ""]
    for code, count in sorted(tally.items(), key=lambda item: (-item[1], item[0])):
        lines.append(f"- **{count}** {labels.get(code, code)}")
    lines.append("")
    LAST_REPORT = {
        "rows": report_rows,
        "receipts": receipts,
        "master_hash": master_hash,
        "source_hash": source_hash,
    }
    return "\n".join(lines)


def tex_escape(value: object) -> str:
    text = str(value)
    replacements = {
        "\\": r"\textbackslash{}", "{": r"\{", "}": r"\}",
        "_": r"\_", "%": r"\%", "#": r"\#", "&": r"\&",
        "$": r"\$", "~": r"\textasciitilde{}", "^": r"\textasciicircum{}",
    }
    return "".join(replacements.get(char, char) for char in text)


def tex_url(value: object) -> str:
    """Content for LaTeX's URL command; current machine fields never contain braces."""
    return str(value).replace("{", "(").replace("}", ")")


def state_plain(result: dict[str, object]) -> str:
    labels = {
        "AXIOM_CERTIFIED_UNANCHORED": "Lean declaration accepted; approved axiom surface; authored-object anchor unratified",
        "INFERENCE_OPEN_UNANCHORED": "Lean declaration accepted with sorryAx; authored-object anchor unratified",
        "DECLARATION_AUDIT_OPEN": "Production module or declaration is not presently importable",
        "EXTERNAL_AXIOM_CERTIFIED": "External library dependency; approved kernel-reported axiom surface; no authored-object anchor required",
        "EXTERNAL_INFERENCE_OPEN": "External library dependency; literal axiom surface contains sorryAx",
        "EXTERNAL_DECLARATION_NOT_IMPORTED": "External exact name is absent from the configured library shelf; no search performed",
        "EXTERNAL_IMPORT_UNAVAILABLE": "Configured external-library import module unavailable",
        "PRODUCTION_MODULE_OPEN": "Exact production module does not currently build; independent receipts remain visible",
        "AUDIT_TOOL_TIMEOUT": "Audit tooling exceeded its operational bound; no mathematical status",
        "DECLARATION_MODULE_UNRESOLVED": "Exact project declaration module unresolved",
        "TRIPLE_CERTIFIABLE": "Kernel and exact-object checks complete; author ratification remains",
        "INFERENCE_OPEN": "Exact authored object; Lean proof open through sorryAx",
        "GENERIC_INSTANTIATION": "Inference closed, but not instantiated at the authored object",
        "GENERIC_AND_OPEN": "Proof and authored-object instantiation both open",
        "DECLARATION_NOT_FOUND": "Authored declaration not present in the live environment",
        "OBJECT_NOT_FOUND": "Authored object name not resolved",
        "OBJECT_AMBIGUOUS": "Authored object name is ambiguous",
        "UNAPPROVED_AXIOMS": "Lean accepted the declaration with an unapproved axiom surface",
        "CHECK_FAILED": "Exact certification check rejected",
    }
    return labels.get(str(result.get("code", "CHECK_FAILED")), str(result.get("code", "CHECK_FAILED")))


def relation_plain(result: dict[str, object]) -> str:
    relation = str(result.get("semantic_relation", "not_checked"))
    return {
        "identity": "Declaration identity: this declaration is the authored object",
        "occurrence": "Exact occurrence: the authored object occurs in the elaborated theorem type",
        "not_instantiated": "Not instantiated: the declaration is generic or names different objects",
        "different_definition": "Different definition from the authored object",
        "unresolved": "Authored object identity unresolved",
        "not_checked": "Object relation not checked",
    }.get(relation, relation)


def receipt_tex(label: str, receipts: dict[str, object]) -> list[str]:
    status = str(receipts.get("status", "RECEIPT_IMPORT_FAILED"))
    if status == "NOT_CONFIGURED":
        return [r"\textbf{Supporting inference and bindings.} No project-specific exporter is configured."]
    if status != "RECEIPTS_CURRENT":
        return [r"\textbf{Receipt import.} \textcolor{KgtRed}{" + tex_escape(status) + ": " +
                tex_escape(receipts.get("message", "receipt import failed")) + "}"]
    buckets = receipts.get("by_label", {})
    bucket = buckets.get(label) if isinstance(buckets, dict) else None
    if not isinstance(bucket, dict):
        return [r"\textbf{Supporting inference and bindings.} No local receipt is registered for this clause."]
    clauses = receipts.get("clauses", {})
    clause = clauses.get(label, {}) if isinstance(clauses, dict) else {}
    lines = [r"\textbf{Receipt classification.} " + tex_escape(clause.get("status", "RECEIPTS_CURRENT"))]
    for row in bucket.get("inference", []):
        lines += [
            r"\par\smallskip\textbf{Certified inference.} \url{" + tex_url(row.get("receipt", "-")) + "}",
            r"\par\textbf{Status.} " + tex_escape(row.get("status", "-")),
            r"\par\textbf{Literal Lean axiom print.}",
            r"\begin{Verbatim}[breaklines=true,breakanywhere=true,fontsize=\small]",
            str(row.get("axiom_print", "unavailable")),
            r"\end{Verbatim}",
        ]
    for row in bucket.get("bindings", []):
        lines.append(
            r"\par\textbf{Authored binding.} \url{" +
            tex_url(row.get("id", row.get("lean_local", "binding"))) + "}: " +
            tex_escape(row.get("status", "-"))
        )
    for row in bucket.get("open", []):
        lines.append(
            r"\par\textbf{Production seat.} \url{" +
            tex_url(row.get("declaration", "-")) + "}: " + tex_escape(row.get("status", "-"))
        )
    for row in bucket.get("rejections", []):
        lines += [
            r"\par\textbf{Exact construction rejection.} " + tex_escape(row.get("status", "-")),
            r"\begin{Verbatim}[breaklines=true,breakanywhere=true,fontsize=\small]",
            str(row.get("kernel_message", "literal message unavailable")),
            r"\end{Verbatim}",
        ]
    return lines


def master_aux_records() -> list[str]:
    """Import only label and bibliography records from the rendered master."""
    aux = ROOT / "output" / "pdf" / MASTER.with_suffix(".aux").name
    if not aux.exists():
        return []
    return [line for line in aux.read_text(errors="replace").splitlines()
            if line.startswith(r"\newlabel{") or line.startswith(r"\bibcite{")]


def ledger_tex() -> str:
    report = LAST_REPORT
    source = MASTER.read_text()
    if r"\documentclass" in source and r"\begin{document}" in source:
        preamble = source.split(r"\begin{document}", 1)[0]
    else:
        preamble = r"\documentclass[11pt]{article}"
    setup = r"""
\makeatletter
\@ifpackageloaded{xcolor}{}{\usepackage{xcolor}}
\@ifpackageloaded{geometry}{}{\usepackage[margin=0.72in]{geometry}}
\@ifpackageloaded{tcolorbox}{}{\usepackage[most]{tcolorbox}}
\@ifpackageloaded{tabularx}{}{\usepackage{tabularx}}
\@ifpackageloaded{url}{}{\usepackage{url}}
\@ifpackageloaded{seqsplit}{}{\usepackage{seqsplit}}
\@ifpackageloaded{fvextra}{}{\usepackage{fvextra}}
\makeatother
\definecolor{KgtBlue}{RGB}{25,74,120}
\definecolor{KgtPale}{RGB}{242,247,251}
\definecolor{KgtGreen}{RGB}{30,112,74}
\definecolor{KgtRed}{RGB}{150,38,38}
\setlength{\parindent}{0pt}
\setlength{\parskip}{4pt}
\tcbset{provenancecard/.style={enhanced,breakable,colback=KgtPale,colframe=KgtBlue,
  boxrule=0.7pt,arc=2mm,left=3mm,right=3mm,top=2mm,bottom=2mm,
  fonttitle=\bfseries,coltitle=white,colbacktitle=KgtBlue}}
"""
    lines = [preamble, setup, r"\makeatletter", *master_aux_records(),
             r"\makeatother", r"\begin{document}",
             r"{\LARGE\bfseries Provenance Ledger}\par",
             r"\vspace{2mm}{\large " + tex_escape(PROJECT) + r"}\par\medskip",
             "This document is generated from the author's master and fresh Lean checks. "
             "Each statement is typeset from the master. Every axiom line below is Lean's literal output.",
             r"\par\medskip\textbf{Master revision.} {\ttfamily\small\seqsplit{" + tex_escape(report.get("master_hash", "-")) + "}}",
             r"\par\textbf{Lean-source revision.} {\ttfamily\small\seqsplit{" + tex_escape(report.get("source_hash", "-")) + "}}",
             r"\bigskip"]
    receipts = report.get("receipts", {})
    for row in report.get("rows", []):
        heading = f"{row.get('index')}. {str(row.get('kind', 'statement')).title()}"
        if row.get("title"):
            heading += f" - {row['title']}"
        lines += [r"\begin{tcolorbox}[provenancecard,title={" + tex_escape(heading) +
                  "},title after break={" + tex_escape(heading + " (continued)") + "}]",
                  r"\textbf{Author's statement}\par", str(row.get("statement_latex", "")),
                  r"\tcblower"]
        results = row.get("results", [])
        if not results:
            lines.append(r"\textcolor{KgtRed}{No exact declaration/object check is available for this clause.}")
        for number, result in enumerate(results, 1):
            if number > 1:
                lines.append(r"\medskip\hrule\medskip")
            lines += [
                r"\textbf{Lean declaration.} \url{" + tex_url(result.get("declaration", "-")) + "}",
                r"\par\textbf{Author's object.} \url{" + tex_url(result.get("author_object", "-")) + "}",
                r"\par\textbf{Object relation.} " + tex_escape(relation_plain(result)),
                r"\par\textbf{Exact state.} " + tex_escape(state_plain(result)),
            ]
            literal = str(result.get("axiom_print", "")).strip()
            if literal:
                lines += [
                    r"\par\smallskip\textbf{Lean command and literal axiom print.}",
                    r"\begin{Verbatim}[breaklines=true,breakanywhere=true,fontsize=\small]",
                    "#print axioms " + str(result.get("declaration", "-")),
                    literal,
                    r"\end{Verbatim}",
                ]
            else:
                lines.append(r"\par\textbf{Literal Lean axiom print.} Not available because the axiom query was not reached.")
        lines += [r"\medskip\hrule\medskip"] + receipt_tex(str(row.get("label", "")), receipts) + [r"\end{tcolorbox}", r"\medskip"]
    lines += [r"\end{document}", ""]
    return "\n".join(lines)


def write_pdf(tex: str) -> None:
    PDF_OUT.parent.mkdir(parents=True, exist_ok=True)
    PDF_TMP.mkdir(parents=True, exist_ok=True)
    TEX_OUT.write_text(tex)
    run = subprocess.run(
        ["latexmk", "-pdf", "-interaction=nonstopmode", "-halt-on-error",
         f"-outdir={PDF_TMP}", str(TEX_OUT)],
        cwd=ROOT, capture_output=True, text=True, encoding="utf-8", errors="replace",
    )
    built = PDF_TMP / PDF_OUT.name
    if run.returncode != 0 or not built.exists():
        detail = "\n".join((run.stdout + "\n" + run.stderr).splitlines()[-35:])
        raise RuntimeError("provenance ledger PDF did not compile:\n" + detail)
    shutil.copyfile(built, PDF_OUT)
    shutil.rmtree(PDF_TMP)


def claim_status(result: dict[str, object]) -> str:
    return {
        "TRIPLE_CERTIFIABLE": "KERNEL_OBJECT_CERTIFIED",
        "INFERENCE_OPEN": "EXACT_OBJECT_PROOF_OPEN",
        "GENERIC_INSTANTIATION": "GENERIC_INFERENCE_CERTIFIED",
        "GENERIC_AND_OPEN": "GENERIC_AND_PROOF_OPEN",
        "DECLARATION_NOT_FOUND": "DECLARATION_OPEN",
        "OBJECT_NOT_FOUND": "OBJECT_UNRESOLVED",
        "OBJECT_AMBIGUOUS": "OBJECT_AMBIGUOUS",
        "UNAPPROVED_AXIOMS": "UNAPPROVED_AXIOMS",
        "CHECK_FAILED": "CERTIFICATION_CHECK_REJECTED",
        "EXTERNAL_AXIOM_CERTIFIED": "EXTERNAL_AXIOM_CERTIFIED",
        "EXTERNAL_INFERENCE_OPEN": "EXTERNAL_INFERENCE_OPEN",
        "EXTERNAL_DECLARATION_NOT_IMPORTED": "EXTERNAL_DECLARATION_NOT_IMPORTED",
        "EXTERNAL_IMPORT_UNAVAILABLE": "EXTERNAL_IMPORT_UNAVAILABLE",
        "PRODUCTION_MODULE_OPEN": "PRODUCTION_MODULE_OPEN",
        "AUDIT_TOOL_TIMEOUT": "AUDIT_TOOL_TIMEOUT",
        "DECLARATION_MODULE_UNRESOLVED": "DECLARATION_MODULE_UNRESOLVED",
    }.get(str(result.get("code", "CHECK_FAILED")), str(result.get("code", "CHECK_FAILED")))


def claims_document() -> dict[str, object]:
    report = LAST_REPORT
    claims: list[dict[str, object]] = []

    def add(label: str, status: str, details: dict[str, object]) -> None:
        payload = {
            "master_hash": report.get("master_hash"),
            "source_hash": report.get("source_hash"),
            "label": label,
            "status": status,
            "details": details,
        }
        digest_value = hashlib.sha256(
            json.dumps(payload, sort_keys=True, ensure_ascii=False).encode()
        ).hexdigest()[:16]
        claims.append(payload | {"token": f"KGT[{label}|{status}|{digest_value}]"})

    for row in report.get("rows", []):
        label = str(row.get("label", ""))
        for result in row.get("results", []):
            add(label, claim_status(result), {
                "declaration": result.get("declaration"),
                "author_object": result.get("author_object"),
                "semantic_relation": result.get("semantic_relation"),
                "axioms": result.get("axioms"),
                "axiom_print": result.get("axiom_print"),
            })
    receipts = report.get("receipts", {})
    if receipts.get("status") == "RECEIPTS_CURRENT":
        clauses = receipts.get("clauses", {})
        buckets = receipts.get("by_label", {})
        for label, clause in clauses.items():
            bucket = buckets.get(label, {})
            add(str(label), str(clause.get("status")), {
                "inference_count": clause.get("inference_count"),
                "certified_inference_count": clause.get("certified_inference_count"),
                "binding_count": clause.get("binding_count"),
                "unresolved_binding_count": clause.get("unresolved_binding_count"),
                "rejections": bucket.get("rejections", []),
            })
    return {
        "schema": 1,
        "project": PROJECT,
        "master_hash": report.get("master_hash"),
        "source_hash": report.get("source_hash"),
        "ledger_pdf_hash": hashlib.sha256(PDF_OUT.read_bytes()).hexdigest()
        if PDF_OUT.exists() else None,
        "claims": claims,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--no-pdf", action="store_true", help="skip PDF compilation (tests only)")
    args = parser.parse_args()
    text = generate()
    tex = ledger_tex()
    if args.check:
        claims_text = json.dumps(
            claims_document(), indent=2, ensure_ascii=False, sort_keys=True,
        ) + "\n"
        current = (OUT.exists() and OUT.read_text() == text and
                   TEX_OUT.exists() and TEX_OUT.read_text() == tex and
                   CLAIMS_OUT.exists() and CLAIMS_OUT.read_text() == claims_text and
                   (args.no_pdf or PDF_OUT.exists()))
        if not current:
            print("STALE: rendered ledger artifacts do not match the current master and Lean sources")
            return 1
        print(f"CURRENT: {OUT.name} and {PDF_OUT.relative_to(ROOT)}")
        return 0
    if args.write:
        if not args.no_pdf:
            write_pdf(tex)
        else:
            TEX_OUT.parent.mkdir(parents=True, exist_ok=True)
            TEX_OUT.write_text(tex)
        claims_text = json.dumps(
            claims_document(), indent=2, ensure_ascii=False, sort_keys=True,
        ) + "\n"
        CLAIMS_OUT.parent.mkdir(parents=True, exist_ok=True)
        CLAIMS_OUT.write_text(claims_text)
        OUT.write_text(text)
        print(f"wrote {OUT.name} and {PDF_OUT.relative_to(ROOT)}")
    else:
        print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
