# HANDOFF — current task: the two-index bricks (replaces ALL earlier handoffs)

Read order: (1) `CLAUDE.md` — rules, architecture, pins. (2) This file. (3)
`PLAN_two_index_bricks.md` — the current task's statement shapes (author-confirmed
direction). (4) `SCAN_shapes_and_C5_ledger.md` — this session's full record; do not
re-derive anything recorded there. `HANDOFF_concentricity_argument.md` (2026-07-03,
03:39) remains valid as the diagnosis of record; nothing in it is overturned.

## Where things stand (2026-07-04, end of Fable session)

**Ledger: 1 sorry / 0 project axioms.** The sorry is
`ASection.transportLevel_placement` (Theorem.lean:201) — literally
`(A.sphereZero n).re = (A.sphereZero m).re`. `winding_lift_unique` is CLOSED σ-free
(covering-map uniqueness, per BRIEF_beta_sigma Option A — the author's instinct,
executed). `concentricity` is proved ON the placement (congrArg of the level read-off);
everything funnels through the one goal.

## What happened this session (so you don't repeat it)

Nine forcing vocabularies were proposed and run to completion — coequalizer/pushout at
𝔫, Euler-summability license, great-circle gluing, U(1)-in-G₂ restriction morphisms,
Grothendieck topology on 𝓑, winding non-extension (Rem 2.1), C4 cone-limit, compactified
base (= the 01:41 plan; its run-record IS the 03:39 handoff), and the applied-triangle
reading. Every run lands on the same unconsumed row. The records, with sources fetched
and quoted (Quillen §1 verbatim — Theorem A, the precofibred corollary, and Cor. 2,
which is the citation for why N-as-terminal is vacuous): `SCAN_shapes_and_C5_ledger.md`
§3 (shapes), §6 (colimit-at-𝔫 dichotomy), §7 (chart orders at N: closeness is
first-order and level-blind; the level is the second-order coefficient), §8 (what a
level IS; consumption table — all four class hypotheses are spent, each level-uniform;
placement is the only unconsumed line). Structural ceilings, established: the toolkit is
unary, the goal is binary; N-asymptotics at best give `Tendsto` (tail), never equality
at finite pairs; `zigzag_iff_level` makes transport-connectivity and level-equality one
proposition, so transport cannot prove the level.

## Author's rulings this session (R6, recorded)

1. **Set-level placement is the OFFICIAL form of the node** (enumeration-free — "the
   zero set is F's alone"): see PLAN §1. The frozen row stays; the set form + divisor
   bundle + iff land as additional statements.
2. **The route is the two-index plan** (author's insight, converged in-session): Brick 1
   `stem_identity_logDeriv` — the log-derivative of `stem_identity`, FE-free, where an
   individual Euler p meets an individual Weierstrass n for the first time; Brick 2 the
   test-function pairing (Σ_p ↔ Σ_n ledger); Brick 3 the closing clause.
3. **Groupoid-layer variants deprioritized** (site-at-N etc. — "we probably don't need
   them"); no further N-forcing runs.
4. **Stem encoding confirmed correct** (author asked): `F : ℂ → ℂ` is `def:section-map`
   via the Wang node (`thm:wang`, StemRing.lean); the 𝕆*→𝕆* face is
   `sectionFunctor : H1 ⥤ S2` (TwoWorlds.lean). Both worlds are formalized.
5. **C3 carries the pole factor** (PLAN §8): `c3_factorization` is amended to the
   (z − pole)·F form — transcription repair (full divisor includes the pole at −1;
   frozen shape collides with `c1_simple` under the §4 upgrade and makes
   `cor:zeta-section` unbuildable). `logDeriv_weierstrass` gains −1/(z − pole);
   master C3 display gains the explicit factor.
6. **`rmk:pi0-split` finality half made placement-consuming** (PLAN §9, Lane B's leak
   find under the sharpened criterion — verified): explicit `\uses{}` on the placement
   + a post-placement-reading sentence; fibred half unchanged. Rides in the Lane B
   task-1 diff.

## Care points (named, R6 — not formalities)

- **Operative vacuity criterion (sharpened 2026-07-04, author's correction):** a route is
  vacuous iff it changes what is concluded — connectivity in a *modified* object instead
  of the real-number equality of levels. A route that derives the level equality itself
  from C1–C4 is not vacuous; it is the theorem. Uniformity-over-the-class is fatal only
  for category-modifying constructions (coequalizer legs, N-terminal; SCAN §6(2b)); it is
  harmless for equation-routes (the bricks). Difficulty estimates gate nothing;
  `lake build` gates everything.

- **Convergence upgrade** (PLAN §4): bare `Summable`/`Multipliable` license neither
  term-by-term log-differentiation nor tprod-vanishing. Needed by the divisor bundle
  AND Brick 1. Derive-if-derivable first; adding class hypotheses is an R3 statement
  change requiring the author's explicit ruling.
- **R5**: verify Mathlib names live before commit (tprod zero lemma, logDeriv API;
  `CategoryTheory.Grothendieck` re-verified live this session).
- **Brick 3 honesty pin**: Bricks 1–2 state the closing clause; they do not discharge
  it. The clause (positivity that equalizes levels) is the relocated C5; classical home
  Weil's criterion / Li's criterion — read both at class level and write the exact
  target before any claim. "Euler + Weierstrass alone force one level" is GRH-scale for
  the class. The genuinely uncharted parts: a class-level FE-free pairing has never been
  formalized in Lean, and whether the band/winding packaging gives a new handle on the
  positivity term is open and fair to explore.

## Ledger trajectory (net-0 execution; balloon is waived per Toolkit pattern)

Phase 0 (now): 1/0. Phase 1 (Lane A lands PlacementSet.lean statements): balloon to
~7/0 — all statement-layer, none load-bearing. Phase 2 (author's §4 ruling, then close
divisor bundle + Brick 1): drive to ~3/0. Phase 3 (Brick 2 pairing: state, then close
the ledger identity): brief balloon, then ~2/0. Phase 4 (Brick 3: the (iv) sentence,
value-free + covariant): either a C1–C4 derivation closes placement_set → placement →
concentricity → **0/0**, or the sentence stands as the named C5 target — the honest
alternative endpoint. Division of labor: Lane A (Claude Code) = all Lean, lake
arbiter; Lane B = master folds (five), SOURCES, (iv) drafting; author = rulings, gates,
midnight rule. No lane writes another's layer.

## First acts

1. `PLAN_two_index_bricks.md` §7 order: confirm shapes → land
   `Concentricity/PlacementSet.lean` → import → `lake build` → repair against the
   arbiter.
2. SOURCES pulls: SATISFIED 2026-07-04 — SOURCES/Riehl.md (§8.3/§8.5 pinpoints) and
   SOURCES/GJ.md (Ch. IV engine) were already complete on disk (2026-07-02/03) and were
   independently re-verified 2026-07-04 against the repo copies in inbox/ (dated
   provenance lines in each file; every quote matched verbatim). The "front matter
   only" note was a later session's fetch record, not the state of SOURCES/.
   Quillen §1 verbatim is captured in SCAN Appendix A.
3. Class-level Weil/Li read for the Brick-3 target shape.

## File inventory (this session's additions, repo root)

- `PLAN_two_index_bricks.md` — the current task (statement shapes, obligations, order).
- `SCAN_shapes_and_C5_ledger.md` — the full session record (§0–§8 + Quillen capture).
- `MASTER_DIFF_great_circle_play.tex` — LaTeX statements of the great-circle chain
  (lem:great-circle, lem:fan, lem:level-invariance, prop:placement-gc) if wanted for the
  master's prose.

The standing fences hold: anti-vacuity, R2, R8, no statement edits to pass a proof. The
frame is one two-index sentence from closing; the current task is to build the pairing
that states that sentence exactly, and to read its classical home before deciding what,
if anything, closes it.
