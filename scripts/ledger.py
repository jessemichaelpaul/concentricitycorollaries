#!/usr/bin/env python3
"""ledger.py — the author's decision surface.

One row per mathematical statement IN THE AUTHOR'S MASTER. For each, everything
the machinery knows, and one column saying what decision (if any) is his to make.

    python3 scripts/ledger.py            # readable table to stdout
    python3 scripts/ledger.py --write    # write Ledger.md
    python3 scripts/ledger.py --live     # elaborate axiom surfaces (slow, honest)

Design rules, learned the hard way on 2026-07-31:

  * UNTAGGED IS NOT UNPROVED. The repository holds ~1,178 declarations with two
    sorry terms, both in dead files. An untagged statement is almost always a
    proved result that has not been wired to its statement.
  * UNKNOWN IS NOT CLEAN. If an axiom surface cannot be determined, say so.
    Never let "not recorded" read as green.
  * OWNERSHIP IS THE AUTHOR'S. Nothing here infers what counts as his object.
"""
from __future__ import annotations
import json, pathlib, re, subprocess, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent

# EVERY project-specific value is read from the repo this script sits in.
# Nothing about any other project may appear in this file — that is the whole
# point of a per-project ledger, and a hardcoded number is a leak.
# ACTIVE PROJECT LOCK — exactly one project is entered at a time.
_lock = pathlib.Path.home() / ".provenance-active"
if _lock.exists():
    _active = pathlib.Path(_lock.read_text().strip()).resolve()
    if _active != ROOT.resolve():
        print(f"REFUSED: the active project is {_active.name}, not {ROOT.name}.")
        print(f"         enter it first:  \"$HOME/Desktop/Kernel Ground Truth/enter.sh\" {ROOT}")
        raise SystemExit(3)

_cfg = json.loads((ROOT / ".provenance-project.json").read_text())
if _cfg.get("kind") == "machinery":
    print(f"REFUSED: {_cfg['name']} is the machinery project — it has no master")
    print("         and no Lean sources, so there is nothing to compile a ledger")
    print("         against. Enter a mathematical project instead.")
    raise SystemExit(3)
PROJECT = _cfg["name"]
MASTER = ROOT / _cfg["master"]
SRCDIR = _cfg["source_dir"]
OUT = ROOT / "Ledger.md"
ALLOWED = {"propext", "Classical.choice", "Quot.sound"}
ENVS = r"(theorem|lemma|definition|proposition|corollary)"


def sh(cmd: str) -> str:
    return subprocess.run(cmd, shell=True, cwd=ROOT, capture_output=True,
                          text=True).stdout


def prose(body: str) -> str:
    """A readable one-line rendering of the author's statement."""
    t = re.sub(r"\\lean\{[^}]*\}|\\uses\{[^}]*\}|\\leanok", " ", body)
    t = re.sub(r"\\textup\{|\\emph\{|\\texttt\{|\\text\{", "", t)
    t = re.sub(r"\\\[.*?\\\]", " … ", t, flags=re.S)          # display math
    t = re.sub(r"\$[^$]*\$", "·", t)                            # inline math
    t = re.sub(r"\\[a-zA-Z]+\*?", "", t)
    t = re.sub(r"[{}]", "", t)
    t = re.sub(r"\s+", " ", t).strip()
    return t[:110] + ("…" if len(t) > 110 else "")


def environments():
    txt = MASTER.read_text()
    rows = []
    for m in re.finditer(rf"\\begin\{{{ENVS}\}}(\[[^\]]*\])?\\label\{{([^}}]+)\}}", txt):
        kind, title, label = m.group(1), (m.group(2) or "")[1:-1], m.group(3)
        end = txt.find(f"\\end{{{kind}}}", m.end())
        body = txt[m.end(): end if end > 0 else m.end() + 4000]
        decls = [d.strip() for g in re.findall(r"\\lean\{([^}]*)\}", body)
                 for d in g.split(",") if d.strip()]
        rows.append({"kind": kind, "label": label, "title": title,
                     "decls": decls, "prose": prose(body)})
    return rows


def decl_exists(name: str) -> bool:
    base = name.split(".")[-1]
    return bool(sh(f"grep -rlE '(theorem|lemma|def|instance|abbrev|structure) +"
                   f"([A-Za-z_][A-Za-z0-9_]*\\.)*{base}\\b' {SRCDIR} 2>/dev/null").strip())


def candidates(label: str, title: str) -> list[str]:
    """Declarations whose NAME resembles this master site. These are SUGGESTIONS
    for the author, never a decision: the tool surfaces what exists, he says
    which one answers his statement."""
    # tokens the author himself used, from the label and the environment title
    toks = [t.lower() for t in re.split(r"[^A-Za-z]+", label + " " + title)
            if len(t) > 4 and t.lower() not in
            {"lemma", "theorem", "definition", "proposition", "corollary", "the"}]
    if not toks:
        return []
    hits: list[str] = []
    for line in sh(f"grep -rhoE '^(noncomputable )?(private |protected )?"
                   f"(theorem|lemma|def|instance|abbrev) +[A-Za-z_][A-Za-z0-9_.]*' "
                   f"{SRCDIR}/*.lean 2>/dev/null").split("\n"):
        nm = line.split()[-1] if line.split() else ""
        low = nm.lower()
        if nm and any(t in low for t in toks):
            hits.append(nm)
    return sorted(set(hits))[:3]


def live_axioms(name: str) -> str:
    out = sh(f"python3 tools/axioms_of.py {name!r} 2>&1").strip()
    if out.startswith("AXIOMS"):
        axs = {a.strip() for a in out[7:].split(",") if a.strip()}
        if "sorryAx" in axs:
            return "sorryAx"
        return "clean" if axs == ALLOWED else out[7:]
    return "UNKNOWN"


def main() -> int:
    live = "--live" in sys.argv
    rows = environments()
    out = []
    for r in rows:
        if not r["decls"]:
            cands = candidates(r["label"], r["title"])
            if cands:
                green = [c for c in cands if not live or live_axioms(c) == "clean"]
                r["state"] = "unwired — candidate exists"
                r["decision"] = ("**wiring**: is it `" + "` / `".join(cands[:3]) + "`?")
            else:
                r["state"], r["decision"] = "untagged — no candidate found", "**name the declaration**"
        else:
            missing = [d for d in r["decls"]
                       if not d.startswith("CategoryTheory.") and not decl_exists(d)]
            if missing:
                r["state"], r["decision"] = "tag unresolved", f"tag names {missing[0]}, not found"
            else:
                ax = [live_axioms(d) for d in r["decls"]
                      if not d.startswith("CategoryTheory.")] if live else []
                if any(a == "sorryAx" for a in ax):
                    r["state"], r["decision"] = "open", "the proof term"
                elif any(a == "UNKNOWN" for a in ax):
                    r["state"], r["decision"] = "unknown", "axiom surface undetermined"
                elif not live:
                    r["state"], r["decision"] = "tagged (axioms unchecked)", "run --live"
                else:
                    r["state"], r["decision"] = "wired", "—"
        out.append(r)

    tally = {}
    for r in out:
        tally[r["state"]] = tally.get(r["state"], 0) + 1

    ndecl = len(sh(f"grep -rhE '^(noncomputable )?(private |protected )?"
                   f"(theorem|lemma|def|instance|abbrev|structure) ' {SRCDIR}/*.lean "
                   f"2>/dev/null").strip().split("\n")) if sh(f"ls {SRCDIR}/*.lean 2>/dev/null").strip() else 0
    nsorry = len([x for x in sh(f"grep -rn '^\\s*sorry\\s*$|:= sorry' {SRCDIR}/*.lean "
                                f"2>/dev/null").strip().split("\n") if x.strip()])

    L = [f"# Ledger — {PROJECT}", "",
         f"One row per mathematical statement in `{MASTER.name}`. The rows are",
         "the author's; the verdicts are the kernel's. Nothing here is the assistant's",
         "opinion.", "",
         f"**`untagged` does NOT mean unproved.** This repository holds {ndecl} declarations",
         f"with {nsorry} `sorry` term(s). An untagged row may well be a proved result that has",
         "not yet been named at its statement.", "",
         "**`unknown` does NOT mean clean.** It means the axiom surface could not be",
         "determined and must not be read as green.", "",
         "| # | statement | Lean declaration | state | your decision |",
         "|---|---|---|---|---|"]
    for i, r in enumerate(out, 1):
        d = ", ".join(f"`{x}`" for x in r["decls"]) or "—"
        L.append(f"| {i} | **{r['title'] or r['label']}** — {r['prose']} | {d} "
                 f"| {r['state']} | {r['decision']} |")
    L += ["", "## Tally", ""]
    for k, v in sorted(tally.items(), key=lambda kv: -kv[1]):
        L.append(f"- **{v}** {k}")
    L += ["", f"(axiom surfaces {'elaborated live' if live else 'NOT checked — rerun with --live'})", ""]

    text = "\n".join(L)
    if "--write" in sys.argv:
        OUT.write_text(text); print(f"wrote {OUT.name}")
    else:
        print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
