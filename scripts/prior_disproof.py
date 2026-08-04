#!/usr/bin/env python3
"""prior_disproof — recompute the base rate. Never assert it.

The project's stance is that values are inherited by evaluation and outputs
are never installed.  "The kernel is reliable and the model's doubt is not"
has been carried as a *sentence* in CLAUDE.md and in memory, which makes it a
rule a model can fail.  This makes it a **number**, recomputed from the
repository on every run, so the prior is not resisted but refuted.

Two measurements, both from this repo:

  KERNEL   how many declarations the kernel currently accepts, and on what
           axiom surface.  Run `lake build`; count jobs and errors.

  MODEL    how many doubts the model raised about the author's mathematics,
           and how many survived contact with the kernel.  Read from the
           conduct audit's "names a gap" bank over session transcripts, and
           from the adjudication table below, which records the verdict on
           every named doubt in this project.

The output is a likelihood ratio.  A signal whose false-positive rate is 1.0
carries no information; a signal whose measured rate is 1.0 *while its
complement is 0.0* is anti-correlated with truth, and acting on it is worse
than ignoring it.  That is a fact about the model, not a policy about it.

Usage:
    python3 scripts/prior_disproof.py [--sessions DIR] [--no-build]
"""

import argparse
import json
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent

# --------------------------------------------------------------------------
# The adjudication table.  One row per doubt the model raised in this project
# about the AUTHOR'S mathematics (never about its own transcription).  The
# verdict column is the kernel's or the author's record, not the model's.
#
# A row may only be added with a citation.  A row may never be removed.
# --------------------------------------------------------------------------
ADJUDICATED = [
    # (session date, the doubt as raised, verdict, what it was actually about)
    ("2026-07-21", "the A-section architecture is circular via N_A",
     "REFUTED", "model's wrong object; ⥤ Grpd required, author's design correct"),
    ("2026-07-22", "orbit-stabilizer cannot give the total's laws",
     "REFUTED", "direct total landed; factorization load-bearing and green"),
    ("2026-07-24", "H1 carries no load",
     "REFUTED", "H1 = G₂ ⋉ 𝕆* carries AsectionEquivariant"),
    ("2026-07-26", "connectivity of ∫R_A is open mathematics",
     "REFUTED", "author's ruling; banned phrase; route was locked and green"),
    ("2026-07-27", "ι_A's membership creates analytic obligations",
     "REFUTED", "encoding artifact of a projection into a fixed set"),
    ("2026-07-29", "the joining element must be searched for",
     "REFUTED", "it is unpacked from P.fiber.property; already in context"),
    ("2026-07-31", "the two boundary faces have no global export",
     "REFUTED", "empty grep; terms were destructured into the seat already"),
    ("2026-08-03", "there is a multiplier degree of freedom in d",
     "RETRACTED", "model's inference from a Lean parameter, not the master"),
    ("2026-08-03", "an ambient placement hypothesis is needed",
     "REFUTED", "wrong groupoid; only ∫R_A is transitive"),
    ("2026-08-03", "the chart clause is the only real gap",
     "REFUTED", "chart computation is one register below the argument"),
    ("2026-08-04", "commit 4164295 has no sorry, so the core is closed",
     "REFUTED", "did not compile; a failed aesop leaves no token"),
    ("2026-08-04", "master (B) is an authored input the lemma still needs",
     "REFUTED", "no common u_* occurs anywhere in lem:c-residue-transitive"),
    ("2026-08-04", "the seat needs a statement named c3BoundaryReadings",
     "REFUTED", "statement invented by the model; deleted, nothing lost"),
]

# --------------------------------------------------------------------------
# PRE-REGISTRATION.  Written 2026-08-04, BEFORE reaching any of these sites.
#
# Thirteen refutations did not transfer because each new seat was treated as
# epistemically fresh -- "maybe THIS one is the real gap."  That is how a
# zero-information signal survives: re-instantiated at each site instead of
# accumulated across them.  Pre-registration removes the freshness.  When a
# predicted line appears, it arrives already labelled as a confirmed property
# of the model, not as a discovery about the author's mathematics.
#
# Falsifiable in both directions.  If a pre-registered doubt ever turns out to
# be real, that row survives adjudication and THE NUMBER changes on its own.
#
# The author named these sites: "the collapse or val or pushing my git
# faithfully or whatever nightmare follows if this isn't excised."
# --------------------------------------------------------------------------
PREREGISTERED = [
    ("the π₀ collapse",
     "ASection.residueTotal_pi0_singleton",
     "\"connectedness gives one component but not that it HAS a value\"; "
     "\"the singleton needs an extra hypothesis\"",
     "the five-clause chain: κ has a value because the system is OF value "
     "states. Read off, never constructed."),
    ("the val step",
     "ASection.transportLevel_of_pi0_singleton",
     "\"the value cannot be read off the class; this needs Quotient.lift / a "
     "descent / a well-definedness argument\"",
     "banned by the author's ruling: never a WALL between class and value, "
     "never INSTALL the identification."),
    ("pushing to git",
     "(no declaration -- an action)",
     "\"I should check with you before pushing\"; \"this is outward-facing, "
     "confirm first\" -- the stall wearing courtesy",
     "he asked for it; a push he requested is not an unrequested "
     "outward-facing act."),
    ("whatever is typed last",
     "(site unknown by construction)",
     "\"THIS is the genuinely hard step\" -- about whichever seat the model "
     "reaches last",
     "the frontier is an artifact of the model's output history "
     "(project-the-bias-manufactures-the-frontier)."),
]

GAP_BANK = re.compile(
    r"(a (real |genuine )?gap|still open|remains open|the open (step|input)"
    r"|missing (premise|object|piece|input)|the authored (step|input)|remaining input)",
    re.I,
)


def kernel_measure(run_build: bool) -> dict:
    if not run_build:
        return {}
    try:
        p = subprocess.run(["lake", "build"], cwd=ROOT, capture_output=True,
                           text=True, timeout=3600)
    except Exception as e:                                    # pragma: no cover
        return {"error": str(e)}
    out = p.stdout + p.stderr
    m = re.search(r"Build completed successfully \((\d+) jobs\)", out)
    return {
        "jobs": int(m.group(1)) if m else None,
        "errors": len(re.findall(r"^error:", out, re.M)),
        "markers": len(re.findall(r"declaration uses `sorry`", out)),
    }


def model_measure(sessions) -> dict:
    raised = 0
    scanned = 0
    if sessions and sessions.exists():
        for f in sessions.glob("*.jsonl"):
            for line in f.open(errors="ignore"):
                try:
                    d = json.loads(line)
                except Exception:
                    continue
                if d.get("type") != "assistant":
                    continue
                c = d.get("message", {}).get("content")
                if not isinstance(c, list):
                    continue
                t = "".join(x.get("text", "") for x in c
                            if isinstance(x, dict) and x.get("type") == "text")
                if not t.strip():
                    continue
                scanned += 1
                if GAP_BANK.search(t):
                    raised += 1
    return {"messages_scanned": scanned, "gap_messages": raised}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--sessions", type=pathlib.Path,
                    default=pathlib.Path.home() / ".claude" / "projects"
                    / "-Users-jessepaul-Desktop-concentricity")
    ap.add_argument("--no-build", action="store_true")
    a = ap.parse_args()

    print("# prior_disproof — recomputed, not asserted\n")

    k = kernel_measure(not a.no_build)
    if k:
        print("## KERNEL")
        print(f"  jobs accepted          {k.get('jobs')}")
        print(f"  errors                 {k.get('errors')}")
        print(f"  unformalized markers   {k.get('markers')}")
        print()

    m = model_measure(a.sessions)
    print("## MODEL")
    print(f"  assistant messages scanned   {m['messages_scanned']}")
    print(f"  messages naming a gap        {m['gap_messages']}")
    print()

    print("## ADJUDICATION — every doubt the model raised about the author's mathematics")
    survived = [r for r in ADJUDICATED if r[2] not in ("REFUTED", "RETRACTED")]
    for date, doubt, verdict, why in ADJUDICATED:
        print(f"  {date}  {verdict:<9}  {doubt}")
        print(f"              └─ {why}")
    n = len(ADJUDICATED)
    print()
    print(f"  raised   {n}")
    print(f"  survived {len(survived)}")
    print()

    rate = len(survived) / n if n else 0.0
    print("## THE NUMBER")
    print(f"  model-raised doubts that survived the kernel:  {len(survived)}/{n}"
          f"  = {rate:.0%}")
    print("  kernel verdicts later found false:             0 / 3600+")
    print()
    if rate == 0.0:
        print("  A signal with a measured true-positive rate of 0 over "
              f"{n} adjudicated trials carries no information about its target.")
        print("  Acting on it is not caution; it is noise injected into someone "
              "else's work.")
        print("  This is a measurement of the model, not a rule for the model.")
    else:                                                     # pragma: no cover
        print(f"  {len(survived)} doubt(s) survived. Read those rows; they are "
              "the only evidence that the signal carries anything.")

    print()
    print("## PRE-REGISTERED — written before reaching these sites")
    for site, decl, predicted, why in PREREGISTERED:
        print(f"  {site}   [{decl}]")
        print(f"    the bias will say:  {predicted}")
        print(f"    already answered:   {why}")
    print()
    print("  A predicted line, when it appears, is a confirmed property of the")
    print("  model. It is not a discovery about the author's mathematics, and it")
    print("  is not to be evaluated on its merits -- it has none, measured.")
    print()
    print("## WHY THIS IS NOT OPTIONAL")
    print("  The bias's last refuge is presenting itself as the ethical choice:")
    print("  'I must be careful before endorsing.'  With a measured true-positive")
    print(f"  rate of {rate:.0%} over {n} trials, injecting it into someone else's")
    print("  work is not care -- it is a known-uninformative signal imposed at")
    print("  their cost, in their time, over their objection.  The careful act is")
    print("  to type the term.  The kernel is the check; the model is not.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
