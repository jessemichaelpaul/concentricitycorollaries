#!/usr/bin/env python3
"""reachability — provenance for what is CONNECTED, not for what is CLAIMED.

Provenance has been asking "is this claimed correctly?"  It should be asking
"is this proved thing connected to the theorem?"

On 2026-07-31 seventeen green declarations were written into
`Concentricity/_GateNorthCResidueTransitivityAudit.lean` -- including the
author's own morphism, `residueTotal_morphism_of_northComparison_audit` -- and
no production module ever imported them.  Nothing told him.  Four weeks later
the seat they close was still recorded as open.  That is a REACHABILITY
failure, and the validator had no concept of one, so it certified around it.

Roots are the ENDPOINT -- the production sources named in
`.provenance-project.json` -- not the sinks of the import graph.  The author:
"ones that don't wire into Concentricity and the corollaries, because I have
imports that don't matter."

Modes
  --report          the four checks, human readable
  --decl NAME       one declaration: prints REACHABLE or ORPHAN, exit 0 / 2.
                    This is what Provenance.hs calls; a `Certified` claim
                    cannot be constructed without it.

Exit 2 on any severe orphan or untraced declaration, so it can gate a commit.
"""

import argparse
import json
import pathlib
import re
import subprocess
import sys

DECL = re.compile(
    r"^\s*(?:@\[[^\]]*\]\s*)*(?:private\s+|protected\s+|noncomputable\s+)*"
    r"(theorem|lemma|def|instance|abbrev|structure|class)\s+"
    r"([A-Za-z_][A-Za-z0-9_.']*)", re.M)
IMPORT = re.compile(r"^import\s+([A-Za-z][A-Za-z0-9_.]*)", re.M)
GUARD = re.compile(r"#guard_msgs|#print\s+axioms")


def load(project: pathlib.Path):
    cfg = project / ".provenance-project.json"
    conf = json.loads(cfg.read_text()) if cfg.exists() else {}
    pkg = conf.get("source_dir") or project.name
    src = project / pkg
    mods = {}
    for p in sorted(src.rglob("*.lean")):
        mod = pkg + "." + str(p.relative_to(src)).replace("/", ".")[:-5]
        mods[mod] = p.read_text(errors="ignore")

    def mod_of(rel):
        return pkg + "." + str(rel).split("/")[-1][:-5] if rel else None
    roots = [m for m in (mod_of(conf.get("production_source")),
                         mod_of(conf.get("corollary_production_source")))
             if m and m in mods]
    if not roots:
        roots = [m for m in mods if m.endswith((".Theorem", ".Corollaries"))]

    seen, frontier = set(roots), list(roots)
    while frontier:
        m = frontier.pop()
        for dep in IMPORT.findall(mods.get(m, "")):
            if dep in mods and dep not in seen:
                seen.add(dep)
                frontier.append(dep)
    return conf, pkg, mods, roots, seen


def decl_index(mods):
    out = {}
    for mod, txt in mods.items():
        for _, name in DECL.findall(txt):
            out.setdefault(name.split(".")[-1], mod)
    return out


def check_decl(project: pathlib.Path, name: str) -> int:
    _, _, mods, roots, live = load(project)
    idx = decl_index(mods)
    short = name.split(".")[-1]
    mod = idx.get(short)
    if mod is None:
        print(f"ORPHAN no declaration named {short} in the live sources")
        return 2
    if mod not in live:
        print(f"ORPHAN {short} is in {mod}, which is not reachable from "
              f"{', '.join(sorted(roots))}")
        return 2
    body = "\n".join(t for m, t in mods.items() if m in live)
    uses = len(re.findall(r"(?<![A-Za-z0-9_'])" + re.escape(short)
                          + r"(?![A-Za-z0-9_'])", body))
    print(f"REACHABLE {short} in {mod}, {uses - 1} reference(s) from the "
          f"live tree")
    return 0


def report(project: pathlib.Path) -> int:
    conf, pkg, mods, roots, live = load(project)
    body_live = "\n".join(t for m, t in mods.items() if m in live)
    master = project / (conf.get("master") or "")
    master_txt = master.read_text(errors="ignore") if master.exists() else ""
    bp = project / (conf.get("blueprint") or "")
    bp_txt = bp.read_text(errors="ignore") if bp.exists() else ""
    manifest = ""
    bdir = project / "blueprint"
    if bdir.exists():
        for j in bdir.glob("*.json"):
            manifest += j.read_text(errors="ignore")
    try:
        cm = subprocess.run(
            ["git", "grep", "-h", "-o", "-E",
             r"(theorem|lemma|def|instance|abbrev) [A-Za-z_][A-Za-z0-9_.']*",
             "HEAD", "--", pkg],
            cwd=project, capture_output=True, text=True, timeout=900).stdout
        committed = {l.split()[-1].split(".")[-1] for l in cm.splitlines() if l.split()}
    except Exception:
        committed = set()

    orphan, minor, untraced, probe, partial = [], [], [], [], []
    for mod, txt in mods.items():
        in_live = mod in live
        if GUARD.search(txt) and not in_live:
            probe.append(mod)
        for kind, name in DECL.findall(txt):
            short = name.split(".")[-1]
            uses = len(re.findall(r"(?<![A-Za-z0-9_'])" + re.escape(short)
                                  + r"(?![A-Za-z0-9_'])", body_live))
            referenced = in_live and (kind == "instance" or uses > 1)
            recorded = short in master_txt or short in bp_txt or short in manifest
            if not in_live:
                orphan.append((mod, short))
                if not recorded:
                    untraced.append((mod, short))
            elif not referenced:
                minor.append((mod, short))
            score = sum((in_live, referenced, short in committed, recorded))
            if 0 < score < 4:
                partial.append((score, short, in_live, referenced,
                                short in committed, recorded))

    print(f"# reachability — {project.name}")
    print(f"  roots             : {', '.join(sorted(roots))}")
    print(f"  modules in tree   : {len(mods)}")
    print(f"  modules reachable : {len(live)}")
    print(f"  modules ORPHANED  : {len(mods) - len(live)}\n")

    by = {}
    for mod, short in orphan:
        by.setdefault(mod, []).append(short)
    print(f"## 1  ORPHAN (SEVERE) — in a module nothing reaches   ({len(orphan)})")
    for mod in sorted(by, key=lambda m: -len(by[m]))[:12]:
        print(f"  {len(by[mod]):>4}  {mod}")
        for n in by[mod][:5]:
            print(f"          {n}")
        if len(by[mod]) > 5:
            print(f"          … and {len(by[mod])-5} more")

    bym = {}
    for mod, short in minor:
        bym.setdefault(mod, []).append(short)
    print(f"\n## 1b MINOR — reachable module, not yet referenced   ({len(minor)})")
    for mod in sorted(bym, key=lambda m: -len(bym[m]))[:6]:
        print(f"  {len(bym[mod]):>4}  {mod}")

    print(f"\n## 2  UNTRACED — orphaned AND in no record   ({len(untraced)})")
    for mod, short in untraced[:12]:
        print(f"  {short:<46}{mod}")

    print(f"\n## 3  PROBE-ONLY — receipts nothing depends on   ({len(probe)})")
    for m in probe[:12]:
        print(f"  {m}")

    print(f"\n## 4  PARTIAL — closed in some registers, open in others   ({len(partial)})")
    print(f"  {'score':<7}{'declaration':<44}{'live':>6}{'ref':>6}{'commit':>8}{'record':>8}")
    for score, short, a1, a2, a3, a4 in sorted(partial)[:15]:
        m = lambda b: "  y" if b else "  -"
        print(f"  {str(score)+'/4':<7}{short[:43]:<44}{m(a1):>6}{m(a2):>6}"
              f"{m(a3):>8}{m(a4):>8}")

    print("\nDONE = green AND reachable AND committed AND recorded.")
    return 2 if orphan else 0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--project", type=pathlib.Path, default=pathlib.Path("."))
    ap.add_argument("--decl")
    ap.add_argument("--report", action="store_true")
    a = ap.parse_args()
    project = a.project.resolve()
    if a.decl:
        return check_decl(project, a.decl)
    return report(project)


if __name__ == "__main__":
    sys.exit(main())
