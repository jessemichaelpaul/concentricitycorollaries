# HANDOFF — theorem landed; PHASE = the logically-independent translations, then the ζ_𝕆 corollaries (replaces ALL earlier handoffs; 2026-07-05, night)

**Read order:** (1) CLAUDE.md. (2) This file. (3) `PLAN_reencode_concentricity_2026-07-05.md`
(approved). (4) `Concentricity/TransportObject.lean`. Threads: Claude Code (Lane A: build,
goal-closing, commits) · Opus chat (Lane B: master folds, SOURCES) · Fable chat (coordination).

## Ledger — exact, no rounding

- `concentricity_transport` (the master's `thm:concentricity`, re-encoded per the author's
  2026-07-05 ruling) is LANDED CLOSED: zero sorries in TransportObject.lean, zero axioms,
  and its dependency cone does NOT touch the open node. **GATE NOT YET RUN:** `lake build`
  (Fable's sandbox has no toolchain — Claude Code's first act). "Proved" is claimable only
  after green; until then the claim of record is "written closed, gate pending."
- Repo-wide after green: **0 axioms; ONE open welded node** — `placement_set`
  (PlacementSet.lean:46) ≡ `transportLevel_placement` (Theorem.lean, re-badged) via the
  proved `placement_set_iff`. It gates ONLY the translation `cor:nontrivial` → `cor:rh`,
  never the theorem. `riemannZeta_nontrivialZeros_infinite`: proved in-repo. LiKernel:
  unimported, on disk. Keystone artifacts: parked, not imported.

## The phase — translations (author, 2026-07-05: all LOGICALLY INDEPENDENT of the theorem
and of each other; R4: attached after, as corollaries; each lands sorried, then closes)

- **T1 — ζ_𝕆 constructed** (master `def:zeta_O`, Part 1–2): build the octonionic zeta in
  Lean — the slice-preserving section whose stem is Mathlib's `riemannZeta` (StemRing.lean
  is the seat; R9: constructed, never axiomatized; R5: verify the `riemannZeta` cluster —
  continuation, pole at 1, Euler product — against live Mathlib). Well-definedness =
  slice-preservation + semiregularity + value N at the pole (`rmk:two-poles`).
- **T2 — zero dictionary:** classical nontrivial zero ρ ⟺ residue-ℂ zero-sphere S_(σ,γ)
  (master `thm:zero-spheres`, `lem:zero-Cstar`, `lem:residue-spheres`).
- **T3 — equivalence theorem:** RH ⟺ the nontrivial zeros are concentric 6-spheres about
  one real centre (master `thm:rh-equiv`, Part 2).
- **T4 — residue translation:** residue-ℂ = classically nontrivial; residue-ℝ = trivial
  (the residue dictionary, master `cor:zeta-section` proof block).
- **T5 — connected = concentric** (one STATIC component ⟺ one σ; the hyperplane/centre
  reading): carrier is the re-badged static row + Pin 3
  (`translation_requires_placement`). **This is the ONE non-free translation — it consumes
  `placement_set` (OPEN).** It stays sorried; the bricks (`PLAN_two_index_bricks.md`)
  target it. Do NOT fold any of it into `concentricity_transport` (author's directive).
- **C1 — main corollary: ζ_𝕆 is an A-section** (master `cor:zeta-section`): C1–C4 from
  T1 + classical facts (continuation/simple pole; Euler; slice-regular Weierstrass/AdF;
  infinitude — already proved in-repo).
- **C2 — final corollary `cor:rh`:** transport theorem + T5(placement) + T2/T3/T4 + the
  functional equation pin ½. **Remains gated by `placement_set`; no other claim is made.**

Execution order (Lane A): gate build → T1 → T2/T4 → T3 → C1; T5/bricks in parallel as the
long pole; C2 assembles last. Statements sorried first (R8), one goal at a time, R6-stop
with the exact goal on any resist. Lane B: the master folds already spec'd (PLAN_reencode
§7) + Part 1–2 verbatim SOURCES excerpts for T1–T4; journal-only citations (R11).

## After the corollaries — publication runway (author's sequence)

1. Blueprint/private-website pass: LaTeX is the human face; verify \uses{} graph = Lean
   dependency graph; ledger page states the honest split.
2. Prose polish in the author's register, style reference = the author's "What is
   Microhistory?" essay (request it from the author when this phase opens; it is not in
   the repo).
3. **Zulip announcement (author drops it).** The announcement MUST carry the ledger
   verbatim: proved = the class theorem (connectivity, class-wide by design), the
   translations T1–T4, and ζ_𝕆 ∈ class; open = `placement_set` ⇒ `cor:nontrivial` ⇒
   `cor:rh`. The honesty pins are the shield: point readers at them first.

## Standing rules for this phase

Zeros are output, never input. No statement edits to pass proofs. Frozen rows stay frozen.
Centres never enter the theorem file. N is real — on the great circle ℝ ∪ {N}; witness
docstrings carry it. Words-before-commits for every new statement; lake gates all.
