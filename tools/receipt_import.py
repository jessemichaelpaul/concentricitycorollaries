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
import time
import re


ROOT = pathlib.Path(__file__).resolve().parent.parent
CFG = json.loads((ROOT / ".provenance-project.json").read_text())
ALLOWED = list(CFG.get("allowed_axioms", [
    "propext", "Classical.choice", "Quot.sound",
]))


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
) -> str:
    """Identity of an authored binding at one exact project revision."""
    value = hashlib.sha256()
    for part in (expression, expected_type, master_hash, source_hash):
        value.update(part.encode())
        value.update(b"\0")
    return value.hexdigest()


def author_binding_identity(row: dict[str, object]) -> str:
    """Identity of the author's semantic binding, before Lean spelling."""
    fields = ("id", "master", "paper_object", "expected_type")
    parts = [str(row[field]) for field in fields]
    parts.extend(str(item) for item in row.get("required_master_declarations", []))
    parts.append(str(row.get("target_declaration", "")))
    payload = "\0".join(parts)
    return hashlib.sha256(payload.encode()).hexdigest()


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

    for raw in data.get("bindings", []):
        if not isinstance(raw, dict):
            return rejected("RECEIPT_SCHEMA_REJECTED", "binding receipt is not an object")
        row = dict(raw)
        error = add(row.get("master"), "bindings", row)
        if error:
            return rejected("RECEIPT_SCHEMA_REJECTED", error)
        if row.get("status") not in {
            "BINDING_READY",
            "AUTHOR_BOUND_LEAN_PENDING",
            "AUTHOR_CONFIRMATION_REQUIRED",
            "AUTHOR_BINDING_TARGET_MISMATCH",
            "LEAN_BINDING_REJECTED",
        }:
            return rejected(
                "RECEIPT_SCHEMA_REJECTED",
                f"{row.get('id', 'binding')} has an unknown binding status",
            )
        author_digest = author_binding_identity(row)
        author_confirmed = (
            row.get("author_confirmed") is True
            and row.get("author_binding_sha256") == author_digest
            and row.get("author_binding_digest") == author_digest
        )
        if row.get("status") == "BINDING_READY":
            expression = str(row.get("exact_expression", "")).strip()
            expected_type = str(row.get("expected_type", "")).strip()
            expected_identity = binding_identity(
                expression, expected_type, master_hash, source_hash,
            )
            ready = (
                row.get("typechecked") is True
                and author_confirmed
                and bool(expression)
                and bool(expected_type)
                and row.get("identity_hash") == expected_identity
            )
        elif row.get("status") == "AUTHOR_BOUND_LEAN_PENDING":
            ready = (
                author_confirmed
                and not str(row.get("exact_expression", "")).strip()
                and row.get("typechecked") is False
            )
        elif row.get("status") == "LEAN_BINDING_REJECTED":
            ready = (
                author_confirmed
                and bool(str(row.get("exact_expression", "")).strip())
                and row.get("typechecked") is False
            )
        elif row.get("status") == "AUTHOR_CONFIRMATION_REQUIRED":
            ready = row.get("author_confirmed") is False
        else:
            ready = (
                row.get("master_targets_linked") is False
                or row.get("target_typed") is False
            )
        if not ready:
            return rejected(
                "RECEIPT_SCHEMA_REJECTED",
                f"{row.get('id', 'binding')} has inconsistent author-binding or Lean-instantiation evidence",
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
        required = ["exact_term", "expected_type", "kernel_message", "command"]
        if row.get("status") != "EXACT_CONSTRUCTION_REJECTED" or not all(
            isinstance(row.get(field), str) and bool(str(row.get(field)).strip())
            for field in required
        ) or row.get("author_confirmed") is not True:
            return rejected(
                "RECEIPT_SCHEMA_REJECTED",
                "an exact-construction rejection must be author-confirmed and quote the term, type, command, and kernel message",
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
            status = (
                "INFERENCE_CERTIFIED_AUTHOR_BOUND_LEAN_PENDING"
                if all(row.get("status") == "AUTHOR_BOUND_LEAN_PENDING" for row in unresolved)
                else "INFERENCE_CERTIFIED_BINDING_OPEN"
            )
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
            "author_confirmed_binding_count": sum(
                row.get("author_confirmed") is True for row in bindings
            ),
            "unresolved_binding_count": len(unresolved),
        }

    return {
        "schema": 1,
        "status": "RECEIPTS_CURRENT",
        "allowed_axioms": ALLOWED,
        "by_label": by_label,
        "clauses": clauses,
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
    args = parser.parse_args()
    result = load_receipts(run_fresh=not args.no_run)
    print(json.dumps(result, indent=2, ensure_ascii=False, sort_keys=True))
    return 0 if result["status"] in {"RECEIPTS_CURRENT", "NOT_CONFIGURED"} else 1


if __name__ == "__main__":
    raise SystemExit(main())
