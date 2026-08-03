#!/usr/bin/env python3
"""Run and normalize a project's exact inference/binding receipt export.

Projects remain free to build receipts in the way their mathematics requires.
This adapter is the fixed boundary: it reruns the configured producer and
refuses stale, unlabeled, or internally inconsistent evidence.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import pathlib
import subprocess
import tempfile
import time
import re


ROOT = pathlib.Path(__file__).resolve().parent.parent
CFG = json.loads((ROOT / ".provenance-project.json").read_text())
ALLOWED = list(CFG.get("allowed_axioms", [
    "propext", "Classical.choice", "Quot.sound",
]))

# Lean exits 0 on a file containing `sorry` -- it is a warning, not an error.
# Exit-code-green is therefore weaker than sorry-free, and BINDING_READY is the
# one layer that used to rest on it.
SORRY_IN_PROBE = re.compile(r"declaration uses ['\"`]?sorry|sorryAx")


def sha256(path: pathlib.Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def tree_digest(paths: list[pathlib.Path]) -> str:
    """Fingerprint names and contents exactly as the ledger does."""
    value = hashlib.sha256()
    for path in sorted(paths):
        value.update(str(path.resolve().relative_to(ROOT.resolve())).encode())
        value.update(b"\0")
        value.update(path.read_bytes())
        value.update(b"\0")
    return value.hexdigest()


def binding_identity(
    expression: str, expected_type: str, master_hash: str, source_hash: str,
    seat_identity: str = "",
) -> str:
    """Identity of an authored binding at one exact project revision."""
    value = hashlib.sha256()
    for part in (expression, expected_type, master_hash, source_hash, seat_identity):
        value.update(part.encode())
        value.update(b"\0")
    return value.hexdigest()


def author_binding_identity(row: dict[str, object]) -> str:
    """Identity of the author's semantics before Lean spelling is recovered."""
    fields = ("id", "master", "paper_object", "expected_type")
    try:
        parts = [str(row[field]) for field in fields]
    except KeyError:
        return ""
    parts.extend(str(item) for item in row.get("required_master_declarations", []))
    parts.append(str(row.get("target_declaration", "")))
    return hashlib.sha256("\0".join(parts).encode()).hexdigest()


def author_registry(master_hash: str) -> tuple[dict[str, dict[str, object]], str | None]:
    """Load the ratified binding identities that the receipt producer cannot edit."""
    name = CFG.get("author_binding_registry", ".provenance/author_bindings.json")
    if not isinstance(name, str) or not name:
        return {}, "the author binding registry path is not configured"
    try:
        path = safe_path(name)
    except ValueError as error:
        return {}, str(error)
    if not path.exists():
        return {}, "the ratified author binding registry is missing"
    try:
        data = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as error:
        return {}, f"the ratified author binding registry is malformed: {error}"
    if not isinstance(data, dict) or data.get("schema") != 1:
        return {}, "the ratified author binding registry must use schema 1"
    if data.get("master") != CFG.get("master") or data.get("master_sha256") != master_hash:
        return {}, "the ratified author binding registry does not match the current master"
    rows = data.get("bindings")
    if not isinstance(rows, list):
        return {}, "the ratified author binding registry has no bindings list"
    by_id: dict[str, dict[str, object]] = {}
    for raw in rows:
        if not isinstance(raw, dict):
            return {}, "the ratified author binding registry contains a non-object row"
        binding_id = str(raw.get("id", "")).strip()
        if not binding_id or binding_id in by_id:
            return {}, "the ratified author binding registry has a duplicate or empty id"
        by_id[binding_id] = dict(raw)
    return by_id, None


RATIFIED_FIELDS = (
    "id", "master", "paper_object", "expected_type",
    "required_master_declarations", "target_declaration", "lean_local",
    "probe_source", "probe_anchor", "probe_template",
)


def matches_ratified_binding(row: dict[str, object], ratified: dict[str, object]) -> bool:
    return all(row.get(field) == ratified.get(field) for field in RATIFIED_FIELDS)


def run_binding_probe(row: dict[str, object]) -> tuple[bool, str, str]:
    """Inject one binding at its own production seat and ask Lean directly."""
    required = ("probe_source", "probe_anchor", "probe_template")
    if not all(isinstance(row.get(key), str) and str(row[key]) for key in required):
        return False, "", "binding lacks a seat-specific probe source, anchor, or template"
    template = str(row["probe_template"])
    if "{expected_type}" not in template or "{exact_expression}" not in template:
        return False, "", "probe template must consume expected_type and exact_expression"
    try:
        source_path = safe_path(str(row["probe_source"]))
    except ValueError as error:
        return False, "", str(error)
    if not source_path.exists():
        return False, "", f"binding probe source does not exist: {row['probe_source']}"
    source = source_path.read_text()
    anchor = str(row["probe_anchor"])
    if source.count(anchor) != 1:
        return False, "", f"binding probe anchor count was {source.count(anchor)}, expected 1"
    expression = str(row.get("exact_expression", "")).strip()
    expected_type = str(row.get("expected_type", "")).strip()
    local = str(row.get("lean_local", "kgtBinding"))
    declaration = (template
        .replace("{lean_local}", local)
        .replace("{expected_type}", expected_type)
        .replace("{exact_expression}", expression))
    anchor_at = source.index(anchor)
    line_at = source.rfind("\n", 0, anchor_at) + 1
    indent = re.match(r"[ \t]*", source[line_at:anchor_at]).group(0)
    injected = "\n".join(indent + line if line else line for line in declaration.splitlines())
    probe_source = source.replace(anchor, injected + "\n" + anchor, 1)
    with tempfile.NamedTemporaryFile(
        mode="w", suffix=".lean", prefix="kgt-binding-", delete=False,
        encoding="utf-8",
    ) as handle:
        handle.write(probe_source)
        probe_path = pathlib.Path(handle.name)
    command = ["lake", "env", "lean", str(probe_path)]
    rendered_command = " ".join(command)
    try:
        run = subprocess.run(
            command, cwd=ROOT, capture_output=True, text=True,
            timeout=int(CFG.get("audit_timeout_seconds", 900)),
        )
    except subprocess.TimeoutExpired:
        return False, rendered_command, "binding probe timed out; this has no mathematical meaning"
    finally:
        probe_path.unlink(missing_ok=True)
    output = (run.stdout + "\n" + run.stderr).strip()
    record_attempt(row, rendered_command, run.returncode == 0, output)
    if SORRY_IN_PROBE.search(output):
        return False, rendered_command, (
            "the binding elaborated only because its term is closed by `sorry`; "
            "Lean exits 0 on a sorry, so exit status alone is not a proof\n" + output
        )
    return run.returncode == 0, rendered_command, output


def expected_type_probe(row):
    """Ask Lean whether the author-confirmed expected TYPE elaborates at its seat.

    Until now the expected type was only compared as a string against a
    declaration header, so a row could sit author-confirmed carrying a type the
    elaborator had never seen -- `projectiveZero` is a paper name, not a Lean
    constant, and six rows carried it.  A name check is not an elaboration.
    """
    required = ("probe_source", "probe_anchor")
    if not all(isinstance(row.get(k), str) and str(row[k]) for k in required):
        return True, "", ""            # nothing to place it in; other checks apply
    expected = str(row.get("expected_type", "")).strip()
    if not expected:
        return True, "", ""
    try:
        source_path = safe_path(str(row["probe_source"]))
    except ValueError as error:
        return False, "", str(error)
    if not source_path.exists():
        return True, "", ""
    source = source_path.read_text()
    anchor = str(row["probe_anchor"])
    if source.count(anchor) != 1:
        return True, "", ""
    at = source.index(anchor)
    line_at = source.rfind("\n", 0, at) + 1
    indent = re.match(r"[ \t]*", source[line_at:at]).group(0)
    context = str(row.get("probe_type_context", "")).strip()
    declarations = [*context.splitlines(),
                    "have _kgtExpectedType : " + expected + " := by sorry"]
    declaration = "\n".join(indent + line for line in declarations)
    probed = source.replace(anchor, declaration + "\n" + anchor, 1)
    with tempfile.NamedTemporaryFile(
        mode="w", suffix=".lean", prefix="kgt-type-", delete=False, encoding="utf-8",
    ) as handle:
        handle.write(probed)
        probe_path = pathlib.Path(handle.name)
    command = ["lake", "env", "lean", str(probe_path)]
    try:
        run = subprocess.run(
            command, cwd=ROOT, capture_output=True, text=True,
            encoding="utf-8", errors="replace",
            timeout=int(CFG.get("audit_timeout_seconds", 900)),
        )
    except subprocess.TimeoutExpired:
        return True, " ".join(command), "expected-type probe timed out; tooling only"
    finally:
        probe_path.unlink(missing_ok=True)
    output = (run.stdout + "\n" + run.stderr).strip()
    unknown = UNKNOWN_NAME.findall(output)
    if unknown:
        return False, " ".join(command), (
            "the author-confirmed expected type names " + ", ".join(sorted(set(unknown)))
            + ", which Lean does not know at this seat; a paper name is not a Lean "
              "spelling and a header match is not an elaboration\n" + output
        )
    return True, " ".join(command), output


UNKNOWN_NAME = re.compile(r"unknown (?:identifier|constant) [`']([^`']+)[`']")


def record_attempt(row, command, green, output):
    """Append the literal fact that a term was put in front of the kernel.

    `exact_attempt_emitted` was a boolean that changed ledger wording and
    inserted nothing.  This is the ground truth the claim gate reads: without a
    line here, no term has ever reached this seat, and prose about the seat is
    a report standing in for the work.
    """
    try:
        path = safe_path(".provenance/attempts.jsonl")
    except ValueError:
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    entry = {
        "id": str(row.get("id", "")),
        "target_declaration": str(row.get("target_declaration", "")),
        "exact_expression": str(row.get("exact_expression", "")),
        "command": command,
        "kernel_green": bool(green),
        "kernel_output": output[:4000],
    }
    with path.open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(entry, ensure_ascii=False) + "\n")


def literal_axioms(line: str) -> list[str] | None:
    match = re.fullmatch(r"'.+' depends on axioms: \[([^]]*)\]", line.strip())
    if match:
        return [item.strip() for item in match.group(1).split(",") if item.strip()]
    if re.fullmatch(r"'.+' does not depend on any axioms", line.strip()):
        return []
    return None


def rejected(code: str, message: str) -> dict[str, object]:
    return {"schema": 1, "status": code, "message": message, "by_label": {}}


def safe_path(relative: str) -> pathlib.Path:
    path = (ROOT / relative).resolve()
    try:
        path.relative_to(ROOT.resolve())
    except ValueError as error:
        raise ValueError("receipt evidence path escapes the active project") from error
    return path


def normalize(data: dict[str, object]) -> dict[str, object]:
    if data.get("schema") != 1:
        return rejected("RECEIPT_SCHEMA_REJECTED", "receipt schema must be 1")
    if list(data.get("allowed_axioms", [])) != ALLOWED:
        return rejected(
            "RECEIPT_AXIOM_POLICY_MISMATCH",
            "receipt axiom policy differs from the active project manifest",
        )

    fingerprints = data.get("fingerprints")
    master_name = str(CFG["master"])
    master_path = ROOT / master_name
    source_dir = ROOT / str(CFG["source_dir"])
    master_hash = sha256(master_path)
    source_hash = tree_digest(list(source_dir.rglob("*.lean")))
    if not isinstance(fingerprints, dict) or fingerprints.get(master_name) != master_hash:
        return rejected(
            "RECEIPT_STALE",
            f"receipt does not carry the current SHA-256 for {master_name}",
        )
    if fingerprints.get("lean_source_tree") != source_hash:
        return rejected(
            "RECEIPT_STALE",
            "receipt does not carry the current Lean source-tree fingerprint",
        )

    master_labels = set(re.findall(r"\\label\{([^}]+)\}", master_path.read_text()))
    ratified_bindings, registry_error = author_registry(master_hash)

    by_label: dict[str, dict[str, list[dict[str, object]]]] = {}

    def add(label: object, kind: str, row: dict[str, object]) -> str | None:
        if not isinstance(label, str) or not label:
            return f"{kind} receipt lacks a master label"
        if label not in master_labels:
            return f"{kind} receipt names unknown master label {label}"
        bucket = by_label.setdefault(
            label, {"inference": [], "bindings": [], "open": [], "rejections": []}
        )
        bucket[kind].append(row)
        return None

    for raw in data.get("inference", []):
        if not isinstance(raw, dict):
            return rejected("RECEIPT_SCHEMA_REJECTED", "inference receipt is not an object")
        row = dict(raw)
        error = add(row.get("master"), "inference", row)
        if error:
            return rejected("RECEIPT_SCHEMA_REJECTED", error)
        if row.get("status") != "INFERENCE_CERTIFIED":
            return rejected(
                "RECEIPT_SCHEMA_REJECTED",
                f"{row.get('receipt', 'inference')} has an unknown inference status",
            )
        if row.get("status") == "INFERENCE_CERTIFIED":
            axiom_print = str(row.get("axiom_print", "")).strip()
            receipt_name = str(row.get("receipt", "")).strip()
            live_axioms = list(row.get("axioms", []))
            sound = (
                row.get("semantic_link") is True
                and row.get("kernel_green") is True
                and row.get("axiom_ok") is True
                and set(live_axioms).issubset(set(ALLOWED))
                and "sorryAx" not in live_axioms
                and literal_axioms(axiom_print) == live_axioms
                and bool(receipt_name)
                and axiom_print.startswith(f"'{receipt_name}' ")
                and isinstance(row.get("type"), str)
                and bool(str(row.get("type")).strip())
            )
            if not sound:
                return rejected(
                    "RECEIPT_SCHEMA_REJECTED",
                    f"{row.get('receipt', 'inference')} claims certification without its exact checks",
                )

    bindings_by_id: dict[str, dict[str, object]] = {}
    for raw in data.get("bindings", []):
        if not isinstance(raw, dict):
            return rejected("RECEIPT_SCHEMA_REJECTED", "binding receipt is not an object")
        row = dict(raw)
        binding_id = str(row.get("id", "")).strip()
        if not binding_id or binding_id in bindings_by_id:
            return rejected(
                "RECEIPT_SCHEMA_REJECTED",
                "every authored binding must have a unique nonempty id",
            )
        bindings_by_id[binding_id] = row
        error = add(row.get("master"), "bindings", row)
        if error:
            return rejected("RECEIPT_SCHEMA_REJECTED", error)
        if row.get("status") not in {
            "BINDING_READY", "BINDING_UNRESOLVED",
            "AUTHOR_BOUND_LEAN_PENDING", "AUTHOR_CONFIRMATION_REQUIRED",
            "LEAN_BINDING_REJECTED",
        }:
            return rejected(
                "RECEIPT_SCHEMA_REJECTED",
                f"{row.get('id', 'binding')} has an unknown binding status",
            )
        author_digest = author_binding_identity(row)
        ratified = ratified_bindings.get(binding_id)
        author_confirmed = (
            registry_error is None
            and ratified is not None
            and ratified.get("author_confirmed") is True
            and matches_ratified_binding(row, ratified)
            and row.get("author_confirmed") is True
            and bool(author_digest)
            and row.get("author_binding_sha256") == author_digest
            and row.get("author_binding_digest") == author_digest
        )
        if row.get("status") == "BINDING_READY":
            expression = str(row.get("exact_expression", "")).strip()
            expected_type = str(row.get("expected_type", "")).strip()
            seat_identity = "\0".join(str(row.get(field, "")) for field in (
                "id", "target_declaration", "probe_source", "probe_anchor", "probe_template",
            )) + "\0" + author_digest
            expected_identity = binding_identity(
                expression, expected_type, master_hash, source_hash, seat_identity,
            )
            probe_green, probe_command, probe_output = run_binding_probe(row)
            row["probe_command"] = probe_command
            row["probe_output"] = probe_output
            ready = (
                author_confirmed
                and bool(expression)
                and expression == str(ratified.get("exact_expression", "")).strip()
                and bool(expected_type)
                and row.get("identity_hash") == expected_identity
                and probe_green
            )
        elif row.get("status") == "AUTHOR_BOUND_LEAN_PENDING":
            ready = (
                author_confirmed
                and not str(row.get("exact_expression", "")).strip()
                and not str(ratified.get("exact_expression", "")).strip()
                and row.get("typechecked") is False
                and all(isinstance(row.get(key), str) and str(row[key]).strip()
                        for key in ("probe_source", "probe_anchor", "probe_template"))
                and "{expected_type}" in str(row.get("probe_template", ""))
                and "{exact_expression}" in str(row.get("probe_template", ""))
            )
        elif row.get("status") == "AUTHOR_CONFIRMATION_REQUIRED":
            ready = (
                row.get("author_confirmed") is False
                and (ratified is None or ratified.get("author_confirmed") is False)
            )
        elif row.get("status") == "LEAN_BINDING_REJECTED":
            expression = str(row.get("exact_expression", "")).strip()
            probe_green, probe_command, probe_output = run_binding_probe(row)
            row["probe_command"] = probe_command
            row["probe_output"] = probe_output
            ready = (
                author_confirmed and bool(expression)
                and expression == str(ratified.get("exact_expression", "")).strip()
                and not probe_green
            )
        else:  # migration-only; it can never satisfy the execution gate
            ready = (
                not str(row.get("exact_expression", "")).strip()
                and row.get("typechecked") is False
            )
        if row.get("status") != "BINDING_UNRESOLVED" and registry_error is not None:
            return rejected("AUTHOR_BINDING_REGISTRY_REJECTED", registry_error)
        if row.get("status") != "BINDING_UNRESOLVED":
            type_ok, type_command, type_message = expected_type_probe(row)
            row["expected_type_command"] = type_command
            row["expected_type_output"] = type_message
            if not type_ok:
                return rejected("EXPECTED_TYPE_NOT_ELABORABLE",
                                str(row.get("id", "binding")) + ": " + type_message)
        if not ready:
            return rejected(
                "RECEIPT_SCHEMA_REJECTED",
                f"{row.get('id', 'binding')} claims readiness without its exact, author-confirmed identity",
            )

    for raw in data.get("open", []):
        if not isinstance(raw, dict):
            return rejected("RECEIPT_SCHEMA_REJECTED", "open-seat receipt is not an object")
        row = dict(raw)
        error = add(row.get("master"), "open", row)
        if error:
            return rejected("RECEIPT_SCHEMA_REJECTED", error)
        if row.get("status") != "OPEN_SEAT":
            return rejected(
                "RECEIPT_SCHEMA_REJECTED",
                f"{row.get('declaration', 'open seat')} has an unknown open-seat status",
            )
        if row.get("status") == "OPEN_SEAT" and not (
            row.get("semantic_link") is True
            and row.get("diagnostic_seen") is True
            and isinstance(row.get("command"), str)
            and bool(str(row.get("command")).strip())
            and isinstance(row.get("kernel_message"), str)
            and bool(str(row.get("kernel_message")).strip())
        ):
            return rejected(
                "RECEIPT_SCHEMA_REJECTED",
                f"{row.get('declaration', 'open seat')} is not localized by live evidence",
            )

    for raw in data.get("rejections", []):
        if not isinstance(raw, dict):
            return rejected("RECEIPT_SCHEMA_REJECTED", "rejection receipt is not an object")
        row = dict(raw)
        error = add(row.get("master"), "rejections", row)
        if error:
            return rejected("RECEIPT_SCHEMA_REJECTED", error)
        required = ["binding_id", "exact_term", "expected_type", "kernel_message", "command"]
        binding = bindings_by_id.get(str(row.get("binding_id", "")))
        if row.get("status") != "EXACT_CONSTRUCTION_REJECTED" or not all(
            isinstance(row.get(field), str) and bool(str(row.get(field)).strip())
            for field in required
        ) or row.get("author_confirmed") is not True or binding is None or not (
            binding.get("status") == "LEAN_BINDING_REJECTED"
            and row.get("master") == binding.get("master")
            and row.get("exact_term") == binding.get("exact_expression")
            and row.get("expected_type") == binding.get("expected_type")
            and row.get("author_binding_sha256") == binding.get("author_binding_sha256")
        ):
            return rejected(
                "RECEIPT_SCHEMA_REJECTED",
                "an exact-construction rejection must be tied to the centrally reprobed, author-confirmed binding and quote its term, type, command, and kernel message",
            )

    clauses: dict[str, dict[str, object]] = {}
    for label, bucket in by_label.items():
        inferences = bucket["inference"]
        bindings = bucket["bindings"]
        opens = bucket["open"]
        rejections = bucket["rejections"]
        inference_closed = bool(inferences) and all(
            row.get("status") == "INFERENCE_CERTIFIED" for row in inferences
        )
        unresolved = [row for row in bindings if row.get("status") != "BINDING_READY"]
        if rejections:
            status = "EXACT_CONSTRUCTION_REJECTED"
        elif inference_closed and unresolved:
            status = "INFERENCE_CERTIFIED_BINDING_OPEN"
        elif opens and inference_closed:
            status = "INFERENCE_CERTIFIED_WIRING_OPEN"
        elif opens:
            status = "OPEN_SEAT"
        elif inference_closed:
            status = "INFERENCE_CERTIFIED"
        else:
            status = "NO_CERTIFIED_INFERENCE_RECEIPT"
        clauses[label] = {
            "status": status,
            "inference_count": len(inferences),
            "certified_inference_count": sum(
                row.get("status") == "INFERENCE_CERTIFIED" for row in inferences
            ),
            "binding_count": len(bindings),
            "unresolved_binding_count": len(unresolved),
        }

    action_required = [
        str(row.get("id", "binding"))
        for bucket in by_label.values()
        for row in bucket["bindings"]
        if row.get("status") != "BINDING_READY"
    ]
    return {
        "schema": 1,
        "status": "RECEIPTS_CURRENT",
        "allowed_axioms": ALLOWED,
        "by_label": by_label,
        "clauses": clauses,
        "action_required_bindings": action_required,
        "bindings_ready": not action_required,
    }


def load_receipts(run_fresh: bool = True) -> dict[str, object]:
    config = CFG.get("receipt_import")
    if config is None:
        return {"schema": 1, "status": "NOT_CONFIGURED", "by_label": {}, "clauses": {}}
    if not isinstance(config, dict):
        return rejected("RECEIPT_CONFIG_REJECTED", "receipt_import must be an object")
    command = config.get("command")
    evidence_name = config.get("evidence")
    if not isinstance(command, list) or not command or not all(isinstance(x, str) for x in command):
        return rejected("RECEIPT_CONFIG_REJECTED", "receipt command must be a nonempty argument list")
    if not isinstance(evidence_name, str):
        return rejected("RECEIPT_CONFIG_REJECTED", "receipt evidence path is missing")
    try:
        evidence = safe_path(evidence_name)
    except ValueError as error:
        return rejected("RECEIPT_CONFIG_REJECTED", str(error))

    if run_fresh:
        started = time.time_ns()
        run = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, timeout=3600)
        if run.returncode != 0:
            detail = (run.stdout + "\n" + run.stderr).strip().splitlines()
            return rejected(
                "RECEIPT_PRODUCER_REJECTED",
                detail[-1] if detail else f"receipt producer exited {run.returncode}",
            )
        if not evidence.exists() or evidence.stat().st_mtime_ns < started:
            return rejected("RECEIPT_STALE", "receipt producer did not freshly rewrite its evidence")
    if not evidence.exists():
        return rejected("RECEIPT_MISSING", f"no receipt evidence at {evidence_name}")
    try:
        data = json.loads(evidence.read_text())
    except (OSError, json.JSONDecodeError) as error:
        return rejected("RECEIPT_SCHEMA_REJECTED", str(error))
    if not isinstance(data, dict):
        return rejected("RECEIPT_SCHEMA_REJECTED", "receipt evidence root is not an object")
    return normalize(data)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--no-run", action="store_true", help="validate existing evidence without rerunning producer")
    parser.add_argument(
        "--require-ready", action="store_true",
        help="fail unless every authored binding has a fresh seat-specific Lean probe",
    )
    args = parser.parse_args()
    result = load_receipts(run_fresh=not args.no_run)
    valid = result["status"] in {"RECEIPTS_CURRENT", "NOT_CONFIGURED"}
    if not valid:
        print(json.dumps(result, indent=2, ensure_ascii=False, sort_keys=True))
        return 1
    if args.require_ready and result.get("bindings_ready") is not True:
        print(json.dumps({
            "schema": 1,
            "status": "AUTHOR_BINDING_ACTION_REQUIRED",
            "message": (
                "author-confirmed bindings are mandatory transcription work; "
                "place each exact expression at its production seat and contact Lean"
            ),
            "action_required_bindings": result.get("action_required_bindings", []),
            "clauses": result.get("clauses", {}),
        }, indent=2, ensure_ascii=False, sort_keys=True))
        return 1
    print(json.dumps(result, indent=2, ensure_ascii=False, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
