/-
Concentricity/ZetaPole.lean

C1 stock for `cor:zeta-section` (Island C1, PLAN_islands §3): the classical
zeta's C1 package at stem level — analyticity away from the pole point 1,
meromorphy on all of ℂ, and the SIMPLE pole (meromorphic order exactly −1
at 1) — shaped for the ASection fields `c1_analyticAt`, `meromorphic`,
`c1_simple` at `pole := 1`. DERIVED (R10) from pinned Mathlib only:
`differentiableAt_riemannZeta`, `riemannZeta_residue_one` (the residue is
1), the removable-singularity extension (`continuousAt_update_same` +
`Complex.analyticAt_of_differentiable_on_punctured_nhds_of_continuousAt`),
and the `meromorphicOrderAt_eq_int_iff` reading (the PlacementSet.lean
B2.1 pattern, `logDeriv_local_form`/`ledger_orderAt_zero`).

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file targets ZERO
sorries.
-/
import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Complex.RemovableSingularity
import Mathlib.Analysis.Meromorphic.Order

noncomputable section

open Complex

/-- ζ is analytic away from 1 (the ζ member's `c1_analyticAt`; master C1
"meromorphically continued … with exactly one pole", stem level). DERIVED
(R10). -/
theorem riemannZeta_analyticAt {s : ℂ} (hs : s ≠ 1) :
    AnalyticAt ℂ riemannZeta s :=
  DifferentiableOn.analyticOnNhd
    (fun z hz => (differentiableAt_riemannZeta hz).differentiableWithinAt)
    isOpen_compl_singleton s hs

/-- The removable extension of (s−1)·ζ(s) across the pole, value 1 at 1 —
the residue (`riemannZeta_residue_one`). The unit accompanying the simple
pole. -/
def zetaPoleUnit : ℂ → ℂ :=
  Function.update (fun s => (s - 1) * riemannZeta s) 1 1

theorem zetaPoleUnit_one : zetaPoleUnit 1 = 1 :=
  Function.update_self ..

theorem zetaPoleUnit_apply_of_ne {s : ℂ} (hs : s ≠ 1) :
    zetaPoleUnit s = (s - 1) * riemannZeta s :=
  Function.update_of_ne hs _ _

/-- The unit is analytic at the pole point: differentiable on the punctured
neighbourhood, continuous across it by `riemannZeta_residue_one` — the
removable-singularity theorem. PROVED. -/
theorem zetaPoleUnit_analyticAt_one : AnalyticAt ℂ zetaPoleUnit 1 := by
  apply analyticAt_of_differentiable_on_punctured_nhds_of_continuousAt
  · filter_upwards [self_mem_nhdsWithin] with z hz
    have hz1 : z ≠ 1 := hz
    have hev : (fun s => (s - 1) * riemannZeta s) =ᶠ[nhds z] zetaPoleUnit := by
      filter_upwards [isOpen_compl_singleton.mem_nhds
        (Set.mem_compl_singleton_iff.mpr hz1)] with w hw
      exact (zetaPoleUnit_apply_of_ne (Set.mem_compl_singleton_iff.mp hw)).symm
    exact (((differentiableAt_id.sub_const 1).mul
      (differentiableAt_riemannZeta hz1)).congr_of_eventuallyEq hev.symm)
  · exact continuousAt_update_same.mpr riemannZeta_residue_one

/-- ζ is meromorphic at its pole: (z−1)²·ζ(z) is the analytic
(z−1)·`zetaPoleUnit`(z), everywhere — including the junk-matched value at
1. PROVED. -/
theorem riemannZeta_meromorphicAt_one : MeromorphicAt riemannZeta 1 := by
  refine ⟨2, ?_⟩
  have hfun : (fun z : ℂ => (z - 1) ^ 2 • riemannZeta z)
      = fun z => (z - 1) * zetaPoleUnit z := by
    funext z
    by_cases hz : z = 1
    · subst hz
      simp [zetaPoleUnit_one]
    · rw [zetaPoleUnit_apply_of_ne hz, smul_eq_mul]
      ring
  rw [hfun]
  exact (analyticAt_id.sub analyticAt_const).mul zetaPoleUnit_analyticAt_one

/-- ζ is meromorphic on all of ℂ (the ζ member's `meromorphic` field;
"a slice-preserving semiregular function", stem level). DERIVED (R10). -/
theorem riemannZeta_meromorphicOn : MeromorphicOn riemannZeta Set.univ := by
  intro s _
  by_cases hs : s = 1
  · subst hs
    exact riemannZeta_meromorphicAt_one
  · exact (riemannZeta_analyticAt hs).meromorphicAt

/-- **The simple pole** (the ζ member's `c1_simple` at `pole := 1`; master
C1 "exactly one pole; it is simple"): meromorphic order exactly −1 at 1 —
the `meromorphicOrderAt_eq_int_iff` presentation with the removable unit,
whose value at the pole is the residue 1 ≠ 0. PROVED. -/
theorem riemannZeta_orderAt_one :
    meromorphicOrderAt riemannZeta 1 = ((-1 : ℤ) : WithTop ℤ) := by
  refine (meromorphicOrderAt_eq_int_iff riemannZeta_meromorphicAt_one).mpr
    ⟨zetaPoleUnit, zetaPoleUnit_analyticAt_one,
      by rw [zetaPoleUnit_one]; exact one_ne_zero, ?_⟩
  filter_upwards [self_mem_nhdsWithin] with z hz
  have hz1 : z ≠ 1 := hz
  rw [zetaPoleUnit_apply_of_ne hz1, zpow_neg_one, smul_eq_mul, ← mul_assoc,
    inv_mul_cancel₀ (sub_ne_zero.mpr hz1), one_mul]
