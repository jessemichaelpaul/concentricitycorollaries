#!/usr/bin/env python3
"""
Step 2 of the provenance repair: match master CLAUSES to Lean TYPES.

The certificate table answers "does the cited name exist and compile".  This
answers the question that actually protects the record:

    does the cited declaration's TYPE say what the clause SAYS?

Five detectors, each of which corresponds to a failure that really happened:

  D1 SYMBOL_COVERAGE      the clause names an object (\\texttt{}, \\operatorname{})
                          that appears in NO cited declaration's type.
                          -> caught nothing in July; this is the (B) hole.
  D2 UNACCOUNTED_PARAM    the declaration takes an explicit argument whose type
                          the clause never quantifies.
                          -> the `d` multiplier story.
  D3 ANTECEDENT_IS_CONCL  a hypothesis is (or heads) the conclusion: the
                          declaration consumes the clause instead of asserting it.
                          -> `nontrivial_one_centre`, `P -> P`.
  D4 KIND                 theorem vs definition, from the kernel.  A definition
                          carries content in its BUNDLED PROOF FIELDS (functor
                          laws, hom laws), so its companion `_id`/`_comp`/`_map_*`
                          lemmas are located and reported rather than the def
                          being dismissed as contentless.
  D5 UNCITED_CLAUSE       a clause marked \\leanok with no \\lean{}, or whose
                          \\lean{} names do not resolve in the environment.

Writes blueprint/type_clause_match.md.
"""

from __future__ import annotations

import json
import pathlib
import re
import subprocess
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from inference_content_audit import (  # noqa: E402
    ROOT, MANIFEST, audit_modules, classify, decompose, head, norm,
    kernel_types, probe_types,
)

MASTER = ROOT / "Octonionic_RH_master.tex"
OUT = ROOT / "blueprint" / "type_clause_match.md"

# D2 compares Lean binder heads against LaTeX prose. That is not a sound test
# — prose says "the projective base", the type says `GreatCircle.Base` — so it
# is off unless --strict is passed. It needs a real quantifier census, not a
# string match, and until it has one its output is noise rather than evidence.
STRICT = "--strict" in sys.argv

ENV = r"(theorem|lemma|proposition|corollary|definition|condition|remark)"
ENV_RE = re.compile(
    r"\\begin\{" + ENV + r"\}(?:\[[^\]]*\])?(.*?)\\end\{\1\}", re.S)
LABEL_RE = re.compile(r"\\label\{([^}]*)\}")
LEAN_RE = re.compile(r"\\lean\{([^}]*)\}", re.S)
USES_RE = re.compile(r"\\uses\{([^}]*)\}", re.S)
TEXTTT_RE = re.compile(r"\\texttt\{([^}]*)\}")
OPNAME_RE = re.compile(r"\\operatorname\{([^}]*)\}")


def clauses() -> list[dict]:
    src = MASTER.read_text()
    out = []
    for m in ENV_RE.finditer(src):
        kind, body = m.group(1), m.group(2)
        lab = LABEL_RE.search(body)
        if not lab:
            continue
        names: list[str] = []
        for g in LEAN_RE.findall(body):
            names += [n.strip() for n in g.replace("\n", " ").split(",")
                      if n.strip()]
        symbols = set()
        for rx in (TEXTTT_RE, OPNAME_RE):
            for s in rx.findall(body):
                s = s.replace("\\_", "_").replace("\\-", "").replace("\\", "")
                s = s.strip()
                if len(s) > 2 and re.match(r"^[A-Za-z][A-Za-z0-9_.]*$", s):
                    symbols.add(s)
        statement = LEAN_RE.sub("", USES_RE.sub("", body))
        statement = LABEL_RE.sub("", statement).replace("\\leanok", "")
        out.append({
            "kind": kind, "label": lab.group(1), "lean": names,
            "symbols": sorted(symbols), "leanok": "\\leanok" in body,
            "text": " ".join(statement.split()),
        })
    return out


def kernel_kinds(names: list[str], manifest: dict) -> dict[str, str]:
    """Ask the kernel whether each constant is a theorem or a definition."""
    if not names:
        return {}
    mods = [m for m in audit_modules(manifest)
            if (ROOT / (m.replace(".", "/") + ".lean")).exists()]
    quoted = ", ".join("`" + n for n in names)
    src = "".join(f"import {m}\n" for m in mods) + f"""
open Lean Elab Command in
run_cmd do
  let env ← getEnv
  for n in [{quoted}] do
    match env.find? n with
    | some (.thmInfo _)  => logInfo s!"KIND {{n}} theorem"
    | some (.defnInfo _) => logInfo s!"KIND {{n}} definition"
    | some (.axiomInfo _) => logInfo s!"KIND {{n}} axiom"
    | some _ => logInfo s!"KIND {{n}} other"
    | none => logInfo s!"KIND {{n}} absent"
"""
    tmp = ROOT / ".type_clause_match.lean"
    tmp.write_text(src)
    try:
        res = subprocess.run(["lake", "env", "lean", str(tmp)], cwd=ROOT,
                             capture_output=True, text=True, timeout=1800)
    finally:
        tmp.unlink(missing_ok=True)
    kinds = {}
    for line in res.stdout.splitlines():
        m = re.search(r"KIND (\S+) (\w+)", line)
        if m:
            kinds[m.group(1)] = m.group(2)
    return kinds


def companion_laws(name: str, all_names: set[str]) -> list[str]:
    """A definition's content lives in its laws; find them by convention."""
    stem = name.split(".")[-1]
    return sorted(n for n in all_names if n != name and stem in n
                  and re.search(r"_(id|comp|map|mul|one|spec|unique|"
                                r"commutes|eq|law)\b", n))


def main() -> int:
    manifest = json.loads(MANIFEST.read_text())
    cls = clauses()
    cited_names: list[str] = []
    for c in cls:
        cited_names += c["lean"]
    cited_names = sorted(set(cited_names))

    types = kernel_types(cited_names, manifest)
    probe = probe_types()
    for n in cited_names:
        if n not in types and n.split(".")[-1] in probe:
            types[n] = probe[n.split(".")[-1]]
    kinds = kernel_kinds([n for n in cited_names if n in types], manifest)
    known = set(types)

    findings: list[tuple[str, str, str, str]] = []  # detector, clause, name, note
    covered_clauses = 0
    for c in cls:
        if not c["lean"]:
            if c["leanok"]:
                findings.append(("D5_UNCITED_CLAUSE", c["label"], "—",
                                 "marked `\\leanok` with no `\\lean{}` tag"))
            continue
        covered_clauses += 1
        blob = " ".join(types.get(n, "") for n in c["lean"]) + " " + " ".join(c["lean"])
        for n in c["lean"]:
            if n not in types:
                findings.append(("D5_UNRESOLVED_NAME", c["label"], n,
                                 "cited but not found in the environment"))
                continue
            ty = types[n]
            verdict, why = classify(ty)
            if verdict in ("CONSUMER", "IDENTITY"):
                findings.append(("D3_ANTECEDENT_IS_CONCLUSION", c["label"], n,
                                 f"{verdict}: {why}"))
            binders, _, _ = decompose(ty) if STRICT else ([], [], "")
            for names_, bty in binders:
                h = head(bty)
                if h and len(h) > 3 and h not in c["text"] and h not in blob[:0] \
                        and h not in ("ASection",) and h not in c["symbols"]:
                    if not re.search(re.escape(h), c["text"]):
                        findings.append((
                            "D2_UNACCOUNTED_PARAM", c["label"], n,
                            f"takes `{names_} : {bty}`; the clause never "
                            f"quantifies `{h}`"))
                        break
            if kinds.get(n) == "definition":
                laws = companion_laws(n, known)
                note = ("definition — content is in its bundled laws; "
                        + ("companions cited: " + ", ".join(f"`{l}`" for l in laws)
                           if laws else "**no companion law is cited by this clause**"))
                findings.append(("D4_KIND_DEFINITION", c["label"], n, note))
        for s in c["symbols"]:
            if s not in blob:
                findings.append(("D1_SYMBOL_UNCOVERED", c["label"], s,
                                 "named by the clause; in no cited type"))

    by_det: dict[str, int] = {}
    for d, *_ in findings:
        by_det[d] = by_det.get(d, 0) + 1

    lines = [
        "# Type ↔ clause match — step 2",
        "",
        "Generated by `scripts/type_clause_match.py`. The certificate table checks",
        "that a cited name compiles. This checks whether its **type says what the",
        "clause says**.",
        "",
        f"- master clauses parsed: **{len(cls)}**",
        f"- clauses carrying a `\\lean{{}}` tag: **{covered_clauses}**",
        f"- distinct cited declarations: **{len(cited_names)}** "
        f"({len(known)} resolved)",
        "",
        "## Findings by detector",
        "",
        "" if STRICT else
        "> `D2_UNACCOUNTED_PARAM` is **disabled**: it compared Lean binder heads"
        " against LaTeX prose, which is not a sound test. It needs a quantifier"
        " census. Run with `--strict` to see its raw output.",
        "",
    ]
    for d in sorted(by_det):
        lines.append(f"- `{d}`: **{by_det[d]}**")
    lines += ["", "## Detail", "",
              "| detector | clause | object | note |", "|---|---|---|---|"]
    for d, lab, name, note in findings:
        lines.append(f"| `{d}` | `{lab}` | `{name}` | {note} |")

    OUT.write_text("\n".join(lines) + "\n")
    print("\n".join(lines[:20]))
    print(f"\nwrote {OUT.relative_to(ROOT)}  ({len(findings)} findings)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
