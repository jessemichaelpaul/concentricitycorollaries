#!/usr/bin/env python3
"""
Step 1 of the provenance repair: kernel ground truth on CONTENT vs PLUMBING.

The certificate table matches a master clause to a Lean *name* and checks that
the name compiles with an allowed axiom surface.  It never checks what the
declaration's TYPE says.  A declaration of the form

    clause-hypotheses -> clause-conclusion

passes name-matching and carries no content: it is the consumer of the clause,
not its supplier.  In the limit it degenerates to `P -> P`.

This script takes every declaration cited by the manifest, asks the kernel for
its exact type, splits that type into binders / hypotheses / conclusion, and
classifies it:

    CONTENT          unconditional, and mentions the author's own objects
    GENERIC_ALGEBRA  unconditional, but author-free (category/group identities)
    CONSUMER         takes, as an argument or hypothesis, an inhabitant of the
                     very thing it concludes  (the "k and phi are arguments" case)
    IDENTITY         a hypothesis is literally the conclusion  (`P -> P`)
    CONDITIONAL      other hypotheses stand between it and its conclusion

The headline number is SUPPLIER COVERAGE: how much of the certified record
actually asserts something, as opposed to composing something already assumed.

Writes blueprint/inference_content_audit.md and exits nonzero if any cited
declaration is IDENTITY (a certificate carrying zero information).
"""

from __future__ import annotations

import json
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
MANIFEST = ROOT / "blueprint" / "lean_certificate_manifest.json"
OUT = ROOT / "blueprint" / "inference_content_audit.md"

# Tokens that make a statement specific to the author's construction rather
# than a generic categorical or group-theoretic identity.
AUTHOR_TOKENS = (
    "ASection", "sphereZero", "distinguishedDiskAction", "CResidue",
    "residueActionState", "AsectionAction", "transportLevel", "zetaSection",
    "zetaO", "riemannZeta", "RiemannHypothesis", "GpvTransport",
    "projectiveObjectFrame", "IsNorthCResidueState", "IsCResidueState",
)

OPENERS, CLOSERS = "([{⟨⟦", ")]}⟩⟧"


def depth_split(s: str, sep: str) -> list[str]:
    """Split on `sep` only at bracket depth zero."""
    out, buf, depth, i = [], [], 0, 0
    while i < len(s):
        c = s[i]
        if c in OPENERS:
            depth += 1
        elif c in CLOSERS:
            depth -= 1
        if depth == 0 and s.startswith(sep, i):
            out.append("".join(buf))
            buf = []
            i += len(sep)
            continue
        buf.append(c)
        i += 1
    out.append("".join(buf))
    return out


def find_at_depth(s: str, ch: str, start: int = 0) -> int:
    depth = 0
    for i in range(start, len(s)):
        c = s[i]
        if c in OPENERS:
            depth += 1
        elif c in CLOSERS:
            depth -= 1
        elif c == ch and depth == 0:
            return i
    return -1


BINDER_RE = re.compile(r"[(\[{]\s*([^:()\[\]{}]+?)\s*:\s*(.+)")


def parse_binder_group(group: str) -> list[tuple[str, str]]:
    """`(A : ASection) (n : ℕ) {X : B}` -> [(names, type), ...]"""
    binders, buf, depth = [], [], 0
    for c in group:
        if c in OPENERS:
            if depth == 0 and buf and "".join(buf).strip() == "":
                buf = []
            depth += 1
        elif c in CLOSERS:
            depth -= 1
            buf.append(c)
            if depth == 0:
                binders.append("".join(buf).strip())
                buf = []
                continue
        buf.append(c)
    parsed = []
    for b in binders:
        inner = b[1:-1] if b and b[0] in OPENERS else b
        idx = find_at_depth(inner, ":")
        if idx < 0:
            continue
        parsed.append((inner[:idx].strip(), inner[idx + 1:].strip()))
    return parsed


def decompose(ty: str) -> tuple[list[tuple[str, str]], list[str], str]:
    """Return (explicit binders, hypotheses, conclusion)."""
    ty = " ".join(ty.split())
    binders: list[tuple[str, str]] = []
    hyps: list[str] = []
    while True:
        ty = ty.strip()
        if ty.startswith("∀"):
            comma = find_at_depth(ty, ",", 1)
            if comma < 0:
                break
            binders += parse_binder_group(ty[1:comma])
            ty = ty[comma + 1:]
            continue
        arrow = -1
        depth = 0
        for i, c in enumerate(ty):
            if c in OPENERS:
                depth += 1
            elif c in CLOSERS:
                depth -= 1
            elif c == "→" and depth == 0:
                arrow = i
                break
        if arrow < 0:
            break
        hyps.append(ty[:arrow].strip())
        ty = ty[arrow + 1:]
    return binders, hyps, ty.strip()


def head(expr: str) -> str:
    e = expr.strip()
    while e and e[0] in OPENERS:
        e = e[1:].strip()
    m = re.match(r"[∃∀]", e)
    if m:
        return "∃" if e[0] == "∃" else "∀"
    m = re.match(r"([A-Za-z_][A-Za-z0-9_.']*)", e)
    return m.group(1) if m else e[:12]


def strip_outer(s: str) -> str:
    """Drop redundant balanced outer parentheses: `(P)` and `P` are one type."""
    s = s.strip()
    while len(s) >= 2 and s[0] == "(" and s[-1] == ")":
        depth = 0
        for i, c in enumerate(s):
            if c in OPENERS:
                depth += 1
            elif c in CLOSERS:
                depth -= 1
                if depth == 0 and i != len(s) - 1:
                    return s
        s = s[1:-1].strip()
    return s


def norm(s: str) -> str:
    return " ".join(strip_outer(s).split())


def author_specific(ty: str) -> bool:
    return any(t in ty for t in AUTHOR_TOKENS)


def classify(ty: str) -> tuple[str, str]:
    binders, hyps, concl = decompose(ty)
    nconcl = norm(concl)
    chead = head(concl)

    for h in hyps:
        if norm(h) == nconcl:
            return "IDENTITY", "a hypothesis is literally the conclusion"

    # An explicit argument inhabiting the very thing concluded.
    for names, bty in binders:
        if chead in ("Nonempty", "∃") and ("⟶" in bty or "≅" in bty):
            return "CONSUMER", f"takes `{names} : {bty}` — an inhabitant of what it concludes"
        if head(bty) == chead and chead not in ("∀", "ℕ", "ℝ", "ℂ"):
            return "CONSUMER", f"takes `{names} : {bty}` — same head as the conclusion"

    for h in hyps:
        if head(h) == chead and chead != "∀":
            return "CONSUMER", f"assumes `{norm(h)[:70]}` — same head as the conclusion"

    if not hyps:
        if author_specific(ty):
            return "CONTENT", "unconditional, and about the author's own objects"
        return "GENERIC_ALGEBRA", "unconditional, but author-free"

    return "CONDITIONAL", f"{len(hyps)} hypothesis(es) stand between it and the conclusion"


PROBE_TXT = ROOT / "blueprint" / "lean_certificate_probe.txt"


def probe_types() -> dict[str, str]:
    """Types recovered from the captured probe output.

    A name found ONLY here is `probe-only`: it was elaborated in a temporary
    file, `#check`ed, and discarded.  It is not in the built library, so no
    production declaration can depend on it.  That is a provenance fact and the
    report must carry it rather than silently treat it as a library receipt.
    """
    if not PROBE_TXT.exists():
        return {}
    out: dict[str, str] = {}
    current = None
    for line in PROBE_TXT.read_text().splitlines():
        m = re.match(r"^@?([A-Za-z_][A-Za-z0-9_.']*)\s*:\s*(.*)$", line)
        if m and (m.group(1).endswith("_audit") or "." in m.group(1)):
            current = m.group(1).split(".")[-1]
            out[current] = m.group(2)
        elif current and line.startswith(" "):
            out[current] += " " + line.strip()
        elif not line.strip():
            current = None
    return out


def cited(manifest: dict) -> list[tuple[str, str, str]]:
    rows = []
    for section in ("terminal", "inference", "open"):
        for e in manifest.get(section, []):
            name = e.get("declaration") or e.get("receipt")
            if name:
                rows.append((section, e.get("master", "—"), name))
    return rows


def audit_modules(manifest: dict) -> list[str]:
    """Modules carrying the cited receipts, taken from the manifest itself."""
    mods = ["Concentricity.Theorem", "Concentricity.Corollaries",
            "Concentricity._GateNorthCResidueTransitivityAudit"]
    for key in ("corollary_inference_probe", "terminal_probe"):
        path = manifest.get(key, "")
        if path.endswith(".lean") and path.startswith("Concentricity/"):
            mods.append(path[:-5].replace("/", "."))
    seen, out = set(), []
    for m in mods:
        if m not in seen:
            seen.add(m)
            out.append(m)
    return out


def run_lean(src: str) -> tuple[str, str]:
    tmp = ROOT / ".inference_content_audit.lean"
    tmp.write_text(src)
    try:
        res = subprocess.run(
            ["lake", "env", "lean", str(tmp)],
            cwd=ROOT, capture_output=True, text=True, timeout=1800,
        )
    finally:
        tmp.unlink(missing_ok=True)
    return res.stdout, res.stderr


def kernel_types(names: list[str], manifest: dict) -> dict[str, str]:
    """Ask the kernel, not the probe file.

    A module that fails to load must never silently zero the report: if the
    batch check does not resolve a name, that name is re-checked on its own so
    the failure is attributed, not absorbed.
    """
    mods = audit_modules(manifest)
    header = "".join(f"import {m}\n" for m in mods)
    blob, err = run_lean(header + "".join(f"#check @{n}\n" for n in names))
    if "error" in blob.lower() and "#check" not in blob:
        print("!! batch check failed; falling back to per-module probing",
              file=sys.stderr)
        print(blob.strip()[:400], file=sys.stderr)
        blob = ""
        for m in mods:
            b, _ = run_lean(f"import {m}\n"
                            + "".join(f"#check @{n}\n" for n in names))
            blob += "\n" + b
    types: dict[str, str] = {}
    current = None
    for line in blob.splitlines():
        m = re.match(r"^@?([A-Za-z_][A-Za-z0-9_.']*)\s*:\s*(.*)$", line)
        if m and m.group(1) in set(names):
            current = m.group(1)
            types[current] = m.group(2)
        elif current and (line.startswith(" ") or line.startswith("\t")):
            types[current] += " " + line.strip()
        elif line.strip() == "":
            current = None
    return types


def main() -> int:
    manifest = json.loads(MANIFEST.read_text())
    rows = cited(manifest)
    names = [n for _, _, n in rows]
    types = kernel_types(names, manifest)
    probe = probe_types()
    origin: dict[str, str] = {}
    for n in names:
        if n in types:
            origin[n] = "library"
        elif n.split(".")[-1] in probe:
            types[n] = probe[n.split(".")[-1]]
            origin[n] = "probe-only"
        else:
            origin[n] = "unresolved"

    tally: dict[str, int] = {}
    lines = [
        "# Inference content audit — CONTENT vs PLUMBING",
        "",
        "Generated by `scripts/inference_content_audit.py` from the manifest's",
        "cited declarations and their **exact kernel types**.",
        "",
        "The certificate table checks that a cited name compiles. This checks what",
        "its type *says*. A declaration whose hypotheses already contain its",
        "conclusion is the clause's consumer, not its supplier; in the limit it is",
        "`P → P`, which passes name-matching and carries no information.",
        "",
        "| section | master clause | declaration | in build? | verdict | why |",
        "|---|---|---|---|---|---|",
    ]
    unresolved = []
    for section, master, name in rows:
        ty = types.get(name)
        if ty is None:
            unresolved.append(name)
            verdict, why = "UNRESOLVED", "kernel did not return a type"
        else:
            verdict, why = classify(ty)
        tally[verdict] = tally.get(verdict, 0) + 1
        og = origin.get(name, "unresolved")
        badge = {"library": "yes", "probe-only": "**NO — probe only**",
                 "unresolved": "?"}[og]
        tally["_probe_only"] = tally.get("_probe_only", 0) + (og == "probe-only")
        lines += [f"| {section} | `{master}` | `{name}` | {badge} | **{verdict}** | {why} |"]

    total = len(rows)
    supplier = tally.get("CONTENT", 0)
    lines += [
        "",
        "## Coverage",
        "",
        f"- cited declarations: **{total}**",
        f"- **CONTENT** (unconditional, author-specific): **{supplier}**",
        f"- GENERIC_ALGEBRA: {tally.get('GENERIC_ALGEBRA', 0)}",
        f"- CONSUMER: {tally.get('CONSUMER', 0)}",
        f"- IDENTITY: {tally.get('IDENTITY', 0)}",
        f"- CONDITIONAL: {tally.get('CONDITIONAL', 0)}",
        f"- UNRESOLVED: {tally.get('UNRESOLVED', 0)}",
        "",
        f"- **not in the built library (probe-only): "
        f"{tally.get('_probe_only', 0)}/{total}** — elaborated in a temporary"
        " file, `#check`ed, discarded; no production declaration can depend on"
        " one.",
        "",
        f"**Supplier coverage: {supplier}/{total} "
        f"({100.0 * supplier / total:.0f}%).**",
        "",
        "A CONSUMER or IDENTITY row is not a defect in the mathematics. It records",
        "that the clause's antecedent is supplied somewhere else, or nowhere yet.",
    ]
    if unresolved:
        lines += ["", "Unresolved names: " + ", ".join(f"`{n}`" for n in unresolved)]

    OUT.write_text("\n".join(lines) + "\n")
    print("\n".join(lines[-14:]))
    print(f"\nwrote {OUT.relative_to(ROOT)}")
    return 1 if tally.get("IDENTITY", 0) else 0


if __name__ == "__main__":
    sys.exit(main())
