# HANDOFF — current-task opener (replaces ALL earlier handoffs)

Read order: (1) `CLAUDE.md` — rules R1–R11, architecture map, pins (pins updated today:
VS entry now carries the journal record and points to SOURCES/VS.md; GPVwind entry carries
the JMAA record and the corrected tameness numbering). (2) This file. (3) Nothing else until
the task requires it. The settled list stays settled; quote the master, never paraphrase it.

## State (2026-07-02, end of thread 3)

* Repo `~/Desktop/concentricity` = private GitHub `jessemichaelpaul/concentricity`;
  commit-to-main only, **no PRs** (standing ruling; `/create-pr` fired twice by accident —
  always discard). Site loop: `./rebuild.sh` then Cmd+R; `leanblueprint serve` if stopped.
* **Lean: `Concentricity/Octonion.lean` COMPLETE** — CD(ℍ) construction per R9, all four
  closures committed (`61fd9f8` normSq_mul via Degen, convention checked 8/8; `bb33245`
  imaginary-sphere square; `2f3b749` alt_left; `060f7c4` alt_right). Sorry count 0, zero
  axioms, zero project leaves. No other Lean exists yet (`Basic.lean` is a stub).
* **Recon gate PASSED** (Code-tab pass cross-read against RECON_MATHLIB.md plus independent
  grep audit in the map thread). Binding resolutions: statement layer cites **pin-present
  names only** (Mathlib v4.31.0 = commit fabf563a); the deck-group block
  (liftPathQuotient etc.) is post-pin — backport priced ~300 lines, not built;
  `monodromyFunctor` IS pin-present (Topology/Homotopy/Lifting.lean:394); `windingNumber`
  absent everywhere — ~200–300 lines in-repo when needed; `SummationFilter` is in the pin —
  bare `∏'`/`Summable` already unconditional, pin those forms in C2/C3.
* **Declared permanent axiom** (author's ruling): `riemannZeta_nontrivialZeros_infinite`,
  C4-floor form, predicate mirrors Mathlib's `RiemannHypothesis` trivial-zero exclusion +
  `s ≠ 1`. Written ONLY when the ZetaO bucket exists. Docstring: Titchmarsh Ch. 2 verbatim
  (GAP — author's UNCG scan) + price of deletion ~2,000–4,000 lines (falling; Mathlib's
  ValueDistribution cluster). If cor:zeta-section's Lean proof demands more than infinitude,
  report the exact demanded statement before widening the leaf. Gate per amended R9:
  zero sorries + `#print axioms` = declared leaf set (currently this one alone);
  Mathlib's three foundational axioms always print and are not counted.
* **SOURCES/**: `Thomason79.md` committed (GAP: original printed Thm 1.2 — Cambridge
  paywall; author has UNCG access; the nLab file is the WRONG Thomason paper — homotopy
  limit problem, not the 1979 hocolim paper). Untracked, awaiting author review: `AdF.md`,
  `AdFslice.md`, `BisiWinkelmann.md`, `GJ.md`, `GPVwind.md`, `Quillen73.md`, `Riehl.md`,
  `VS.md`. Map thread pre-reviewed and endorsed: VS.md (version-of-record, zero gaps),
  GPVwind.md (see FLAGS), Thomason79.md. Still missing vs Pins: Wang, Baez, Titchmarsh
  GAP-stub, classical Riemann/Euler/Hadamard-bearing references as needed.
* **Rem 5.2 attribution RESOLVED empirically**: the quotes live in VS alone (Math. Z.
  302(2), printed p. 988 — SOURCES/VS.md); the winding paper contains NO Remark 5.2 and
  never prints "degenerate" (SOURCES/GPVwind.md FLAGS, full environment inventory).
  Master's GPVwind bibitem corrected accordingly (Rem 5.2 clauses struck; tameness
  numbering fixed: paths Def 4.7, maps Def 4.20, at-parameter Def 5.2; journal record
  added: J. Math. Anal. Appl. 536(1) (2024), Paper No. 128219). CAVEAT for the SOURCES
  pass: GPVwind excerpts are arXiv v1; JMAA-version numbering unverified (publisher 403)
  — author to confirm via library.
* **Master edits today (author-approved, applied via map thread, in tree)**:
  thm:log-manifold cite now lists true environment types (Prop 5.1, Rem 5.2, Def 5.3,
  Prop 5.4, Def 5.5); lem:exp-degenerate gained the closing acknowledgment sentence
  (VS Preface p. 972 prints the fibre formula as unproved motivation; slice-form
  derivation stays load-bearing); GPVwind bibitem corrected. CLAUDE.md pin updates
  match. Blueprint regenerates from the master on rebuild — one rebuild pending.
* CI: stock Lean Action runs on push (nibbles free minutes; disable offered, declined
  for now). Octonion build receipt: olean at 20:46 preceding commit 20:47 — formal
  build-tail-with-commit discipline reaffirmed below.

## Current task

1. Fold outstanding tree changes into quiet commits and push: (a) author edits
   (master + CLAUDE.md), message: `Author: VS/GPVwind flags resolved (cite types,
   Preface acknowledgment, pin exactified, bibitem corrected)`; (b) this HANDOFF.md.
2. Author reviews the 8 untracked SOURCES files (3 pre-reviews on record); commit
   approved ones individually, Thomason79-style messages, GAP discipline throughout.
   Then fetch the still-missing pins (Wang, Baez; Titchmarsh as GAP-stub).
3. **Statement layer per Phase 3**, citing pin-present names only, leaves as axioms
   with verbatim SOURCES/ docstrings, sorries per R8: 𝓡 via the stem functor over
   Mathlib's Hol(ℂ) → `structure ASection` (C2 stated as `cexp (∑' p, ℓ p)`,
   unconditional forms pinned) → G₂ := AlgAut(𝕆) → 𝓗₁ = G₂ ⋉ 𝕆* (ActionCategory) →
   𝒮₂ → Φ → 𝓑 (levels, static) → F (band U(1)) → 𝒯_A = ∫_𝓑 F (CategoryTheory.Grothendieck)
   → the π₀ lemma (ConnectedComponents) → theorem statement → **STOP at the red
   placement `\TODO`** — the sentence is the author's alone.
4. Author's lane: the placement sentence (note: the TODO's phrase "the conserved-level
   readout of Corollary cor:nontrivial" now reads through `thm:connected-concentric`);
   UNCG library errands — Titchmarsh Ch. 2 page (load-bearing: axiom docstring),
   Thomason original Thm 1.2 (paper hygiene), JMAA numbering check for GPVwind (R11).

## Failure modes (all prior ones stand) + today's additions

* Session resets lose chat state, never file state: on reset, read CLAUDE.md + this
  file, claim nothing you can't see (no build log in context = say so, don't assert green).
* Scope drift after resets: "queue / pending my approval" ≠ "do now". Wording approvals
  come BEFORE commits. No PRs. No installs without naming the tool and why.
* Commit-on-green means SHOW the green: build tail in-thread with the commit.
* Unresolved attributions are settled by verbatim quotes from ALL claimants
  (the Rem 5.2 method), never from memory or bibitem annotations.
* The sorry ledger will balloon when the statement layer lands — by design (R8).
  Sorry count is queue length, never error count. Octonion went 4→0 in one evening.
* "Concentric" stays translation vocabulary; the base is levels + winding; never attach
  metric language to 𝓑. The dictionary (`thm:connected-concentric`) stays independent of
  the collapse — graph-visible, never re-folded.
