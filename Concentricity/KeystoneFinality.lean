/-
Concentricity/KeystoneFinality.lean

The keystone via the finality cone at N (DESIGN_keystone_finality.md;
author's mechanism, 2026-07-05). Renders and wires the three possessions:

  (S1) the value-loop assembly converges into the unique cone at N — from
       the section's own convergence (C2: the Euler assembly; C3: the
       Weierstrass assembly through the pole). PROVED below, both halves,
       hypotheses literally the `c2_*` / `c3_*` fields. VACUITY GUARD
       honored: no terminal object on `Base` anywhere in this file — the
       finality is the section's analytic data (SCAN §3.3, Quillen Cor 2).
  (S2) the level is the invariant carried into the cone — `inv_re_bridge`
       (PROVED), read at each enumerated zero. PROVED below.
  (S3) one cone ⟹ one level — C3's through-the-pole factorization
       (`c3_factorization`) against C1's single simple pole (`c1_simple`);
       fields of `def:A-section`, fed directly, never derived.

CONCLUSION register only: levels/winding/convergence — no centre, radius,
"concentric", ½, or ζ in this file.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.Theorem
import Concentricity.PlacementSet

noncomputable section

open Filter

namespace ASection

/-- The enumerated zero-sphere representatives are nonzero (residue-ℂ:
strictly upper-half, `c3_sphere_nonreal`). -/
theorem sphereZero_ne_zero (A : ASection) (n : ℕ) : A.sphereZero n ≠ 0 := by
  intro h
  have him := A.c3_sphere_nonreal n
  rw [h] at him
  simp at him

/-- **(S2) — the cone invariant at N**: the datum `‖ρ‖²·Re(1/ρ)` the cone
carries for the n-th zero-sphere (the second-order coefficient of approach;
`1/ρ → 0` as `ρ → N`). Differences/equalities of these only (PLAN §6
admissibility rides along; no absolute level is named). -/
def coneInvariant (A : ASection) (n : ℕ) : ℝ :=
  ‖A.sphereZero n‖ ^ 2 * (1 / A.sphereZero n).re

/-- **(S2) rendered, PROVED**: the transport level IS the invariant carried
into the cone — `inv_re_bridge` read at the n-th zero. -/
theorem transportLevel_eq_coneInvariant (A : ASection) (n : ℕ) :
    A.transportLevel n = A.coneInvariant n :=
  (inv_re_bridge (A.sphereZero_ne_zero n)).symm

/-- **(S1), Euler half, PROVED**: on the half-space Ω₀ the partial Euler
assembly of the section converges to the section itself — the value
assembly of C2, converging toward the one continued object whose single
cone is C1's pole. Hypotheses are literally `c2_summable` + `c2_euler`. -/
theorem euler_assembly_tendsto (A : ASection) {z : ℂ} (hz : A.Ω₀ < z.re) :
    Tendsto (fun s : Finset A.ι => Complex.exp (∑ p ∈ s, A.ℓ p z))
      atTop (nhds (A.F z)) := by
  have hs : HasSum (fun p => A.ℓ p z) (∑' p, A.ℓ p z) :=
    (A.c2_summable z hz).hasSum
  have hexp := (Complex.continuous_exp.continuousAt
    (x := ∑' p, A.ℓ p z)).tendsto.comp hs
  rw [A.c2_euler z hz]
  exact hexp

/-- **(S1), Weierstrass half, PROVED**: at every point the partial
through-the-pole assembly of C3 converges to the full factor over the
divisor. Hypothesis is literally `c3_multipliable`. -/
theorem weierstrass_assembly_tendsto (A : ASection) (z : ℂ) :
    Tendsto (fun N => ∏ k ∈ Finset.range N,
        spherePrimary (A.genus k) (A.sphereZero k) z)
      atTop (nhds (∏' k, spherePrimary (A.genus k) (A.sphereZero k) z)) :=
  (A.c3_multipliable z).hasProd.tendsto_prod_nat

/-- **The keystone via the finality cone** (DESIGN target; author's
mechanism 2026-07-05): both transport levels are the level-limit carried
into the unique finality cone at N; hence equal. Wiring of (S1)+(S2)+(S3);
the KeystoneAssembly zigzag then closes by `zigzag_iff_level.mpr`. -/
theorem transportLevel_const_via_finality (A : ASection) (n m : ℕ) :
    A.transportLevel n = A.transportLevel m := by
  -- (S2): read both levels as the invariants the cone carries
  rw [A.transportLevel_eq_coneInvariant n, A.transportLevel_eq_coneInvariant m]
  -- (S3): feed the through-the-pole factorization and the single cone
  have hS3_factor := A.c3_factorization
  have hS3_cone := A.c1_simple
  -- (S1): feed the assembly convergence, both halves
  have hS1_euler := @A.euler_assembly_tendsto
  have hS1_weier := A.weierstrass_assembly_tendsto
  -- feed check (dispatch: "first check it isn't a possession you haven't
  -- fed in") — the remaining possessions of def:A-section, all in context:
  have hP01 := A.intrinsic
  have hP02 := A.meromorphic
  have hP03 := A.c1_analyticAt
  have hP04 := A.ι_infinite
  have hP05 := A.c2_intrinsic
  have hP06 := A.c2_analyticAt
  have hP07 := A.c2_zero_free
  have hP08 := A.c2_summable
  have hP09 := A.c2_euler
  have hP10 := A.c2_locMajorant
  have hP11 := A.c3_R_intrinsic
  have hP12 := A.c3_R_entire
  have hP13 := A.c3_R_zeros_real
  have hP14 := A.c3_g_intrinsic
  have hP15 := A.c3_g_entire
  have hP16 := A.c3_sphere_nonreal
  have hP17 := A.c3_multipliable
  have hP18 := A.c3_locMajorant
  have hP19 := A.c3_lowerEdge
  have hP20 := A.c4_infinite
  have hP21 := A.valueAtInfinity_real
  -- FEED-CHECK RECEIPT (dispatch 2026-07-05): with every propositional
  -- field of `def:A-section` in context (hP01–hP21, hS3_*, hS1_*) and the
  -- data fields accessible through `A`, `exact?` searched the context and
  -- the library and could not close the goal below. R6 of record:
  --   ⊢ A.coneInvariant n = A.coneInvariant m
  -- Both S1 halves are convergence statements at a fixed point z (unary in
  -- z); S2 is per-index; no fed statement relates the invariants across
  -- the index pair (n, m). `sorry` marks UNFORMALIZED, never UNSOUND (R8).
  sorry

end ASection
