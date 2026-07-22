# EndGameDependencyMap — from the live tree to the Zulip release

**Author of the mathematics: Jesse Michael Paul.** 2026-07-20. The dependency chain for everything
up to publication. References only live objects. Verified-green components are in
`RELEVANT_GREEN.md`; live session state and acceptance checks are in `RESUME_2026-07-20.md`.
Supersedes the old `DEPENDENCY_TABULATION.md` (retired).

Notation: `[G]` = green now · `[ ]` = to do · `←` = depends on.

---

## The chain

```
[G] base + distinguished element + SphereWorld + orbit–stabilizer + engine + cargo   (RELEVANT_GREEN)
        │
[ ] PHASE 1 · complete A-specialized functor
        │   F.obj and F.map simultaneously from the distinguished-element orbit–stabilizer proof
        │   ← distinguished element [G]    ← μ_A = exp(∑' p, A.ℓ p z), c2_euler [G]
        │   ← orbit_stabilizer_factor / stabilizerPart_id / stabilizerPart_comp [G]
        │   ← spherePointMap (+ _conj) [G]
        │   removes: the A-free shortcut and detached cargo wrappers
        │   guard: deleting A's data must break F.obj/F.map themselves
        ▼
[ ] PHASE 2 · total object
        │   A.TotalA carries automatically (defined in terms of the functor) — verify only
        │   ← Phase 1
        ▼
[ ] PHASE 3 · the finale (fills the two sorries)
        │   concentricityReadout  ← toColimitObj_eq_of_zigzag [G] on the functor's own
        │                            through-N transports (Phase 1)
        │   labelCocone A         ← the action's own value preservation (gpv_endpoint_re,
        │                            d_exp_fibre_level, d_level_eq_log_norm_exp) [G]
        │   val A                 ← colimit.desc + ι_desc_apply [G]
        │   val_zeroTotal         ← normalizedZero_label / normalizedZeroLift_re [G]
        │   concentricity         ← atomic calc through κ; replaces both sorry bodies
        ▼
[ ] CERTIFICATE
        │   one full build; then IN ORDER:
        │     #print ASection.concentricity   — read it: ∃ c : ℝ, ∀ n, (A.sphereZero n).re = c
        │     #print axioms                    — [propext, Classical.choice, Quot.sound], no sorryAx
        │   (green certifies whatever is written; the statement is read first)
        ▼
[ ] RH COROLLARY
        │   zeta_riemannHypothesis  ← concentricity, RhEquiv (½ enters ONLY here, non-circular)
        ▼
[ ] ZULIP RELEASE  (plan: ZULIP_RELEASE_PLAN_2026-07-17.md — re-verify against final state)
            1. fresh-history repo containing ONLY the concentricity + RH material
               (retired/ is gitignored and does not transport; nothing in git history
                should reference retired objects)
            2. blueprint / exposition from PROOF_OUTLINE_LOCKED + BOARD_LECTURE
            3. certificate (axioms + printed statements) included
            4. post
```

## Critical path, one line

Phase 1 is the only real construction. Everything downstream of it is either verify-only
(the total) or the engine consuming the loaded object wholesale (the finale). The finale is five
declarations, two of which are already-typed sorries. There is no branch — it is a straight line.

## What is NOT on the path (do not let it re-enter)

- No `cayleyProjective` / generic Möbius family in the final functor.
- No `Hypothesis A (_D)` wrapper or cargo-as-fields.
- No per-zero `Z_n ⟶ N` leg, hunted arrow, private north, pairwise `re`-equality, `IsConnected`,
  or populated subcategory.
- No independently chosen or constant fibre carrier; no `NormalizedSlicePoint`/`NormalizedSliceHom`
  standing in for the objects and arrows produced by orbit–stabilizer.
- Nothing from `retired/` or any banner-marked document.
