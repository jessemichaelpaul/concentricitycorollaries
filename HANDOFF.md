# HANDOFF — fan-out phase: everything downstream of the locked theorem (replaces ALL earlier handoffs; 2026-07-05, evening)

**Read order:** (1) CLAUDE.md. (2) This file. (3) `DESIGN_translations.md` — the approved
statement spec for this phase. (4) `PLAN_two_index_bricks.md` + `DESIGN_B2_2_kernels.md` —
the bricks. (5) `Concentricity/TransportObject.lean` — the locked theorem.
Threads: Claude Code (Lane A: build, goal-closing, commits) · Opus chat (Lane B: master
folds, SOURCES) · Fable chat (coordination, ledger audit). `OPENER_next_threads.md` carries
the paste-ready lane instructions.

## The locked centre

`ASection.concentricity_transport` (master `thm:concentricity`) is PROVED — kernel
certificate on record, verbatim:

    'ASection.concentricity_transport' depends on axioms: [propext, Classical.choice, Quot.sound]

Mathlib's three foundational axioms only; no `sorryAx`; no project axioms. Everything in
this phase fans out from it and nothing in this phase may modify it, its file, or its cone.

## Ledger — exact, no rounding

- Imported root: **2 sorries / 0 axioms** — the ONE welded node: `placement_set`
  (PlacementSet.lean:46) ≡ `transportLevel_placement` (Theorem.lean:213) via the proved
  `placement_set_iff`. Gates only the `cor:nontrivial` → `cor:rh` chain.
- Proved stock this phase builds on: the divisor bundle (`stem_zero_of_sphereZero`,
  `sphereZero_complete` = the stem-level zero dictionary), Brick 1 + B2.1 ledger rows
  (PlacementSet.lean), `riemannZeta_nontrivialZeros_infinite` (ZetaInfinitude.lean),
  G₂ orbit transitivity (G2.lean).
- Unimported on disk: LiKernel, KeystoneAssembly, KeystoneFinality (→ `attic/` per H2).
- Superseded process docs live in `archive/` (git history preserves everything).
- **PUSH DEFERRED** (author): main ahead of origin stays local until the runway's
  quiet-push step.

## Open author ruling (R6) — non-blocking

`transportClass`/`Populated` read frozen `transportLevel` as each zero's arrival address:
letter-of-§4, audit-verified inert (Pin 2 forbids readback; proof consumes witness arrows
only). Options: (i) sanction + one docstring line (recommended); (ii) re-route through the
witness arrow's source (definitionally identical). If (i), execute as H4.

## Execution sequence (Lane A) — spec = DESIGN_translations.md; shapes there are the
author-approved words

- **H1–H3 housekeeping** (per OPENER): verify build after archive move; move the three
  unimported Lean artifacts to `attic/`; docstring scrub — remove process meta-commentary
  from `Concentricity/*.lean`, KEEP master labels, verbatim sourced quotes + pinpoint
  cites (R10), honesty-pin content, PROVED/OPEN/GAP markers. Docstring-only; every
  statement and proof byte-identical; lake gates.
- **#1** `zero_equivalence` — free, over the proved divisor bundle.
- **#4** `nontrivial_one_centre` — one line; compiles but its cone contains the open
  node: placement-gated, never reported as proved until the bricks close.
- **#3** `Concentricity/ZetaSection.lean` — `zetaSection : ASection` with every field
  sorried first (design field table), after a day-one R5 sweep reporting live-Mathlib
  coverage of the `riemannZeta` cluster (continuation, pole, FE, Euler product, Hadamard).
  Close fields cheapest-first; ledger delta per commit.
- **#5** `riemannHypothesis` — drafted sorried per design; FE pin verified live. Closes
  only when #3's fields and `placement_set` are both closed.
- **Bricks in parallel — THE LONG POLE:** B2.2 pairing + closing clause toward
  `placement_set` (Brick 1, B2.1 already proved). The only open mathematics in the repo.

Lane B: master folds (theorem restated on the populated 𝒯_A; red TODO into
`cor:nontrivial` with \uses{placement}; rmk:pi0-split reshape) + Part 1–2 verbatim
SOURCES excerpts for the ζ_𝕆 chain; journal-only citations (R11).

## Publication runway (author's sequence)

1. This phase: translations + ζ_𝕆 + corollary drafts; bricks toward `placement_set`.
2. Blueprint website compiled PRIVATELY; \uses{} graph = Lean dependency graph; prose
   polish in the author's register (style reference: the author's "What is Microhistory?"
   essay — request from the author when this phase opens; not in the repo).
3. QUIET push of what's needed.
4. **Announcement ONLY after project-wide 0 sorries / 0 project axioms** (R9's literal
   gate). The announcement carries the ledger verbatim; the honesty pins are the shield.

## Standing rules

Zeros are output, never input. No statement edits to pass proofs. Frozen rows stay
frozen. Centres never enter the theorem file. N is real — on the great circle ℝ ∪ {N}.
Design-spec shapes are the approved words; genuinely new statements need
words-before-commits. R5 live checks on every Mathlib name; R6-stop with the exact goal
on any resist; lake gates all.
