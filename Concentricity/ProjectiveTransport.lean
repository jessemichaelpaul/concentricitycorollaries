/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.CayleyDictionary
import Concentricity.FaithfulApply

/-!
# GPV value-transport cargo on the projective great circle

This file contains the compactified stem and GPV lift facts loaded into the
completed A-section functor.  Its endpoints are objects of
`GreatCircle.Point`, the object carrier of the unique projective base.
-/

noncomputable section

open Complex Filter

namespace ASection

/-- The compactified stem of an A-section.  The unique finite C1 pole is
sent to the common point `N = ∞`; away from that pole the finite chart is
the stem `A.F`, and the domain point at infinity carries the compactified
datum `A.valueAtInfinity`. -/
noncomputable def Fstar (A : ASection) : OnePoint ℂ → OnePoint ℂ :=
  fun z => OnePoint.rec A.valueAtInfinity
    (fun w => if w = (A.pole : ℂ) then OnePoint.infty
      else OnePoint.some (A.F w)) z

@[simp] theorem Fstar_infty (A : ASection) :
    A.Fstar OnePoint.infty = A.valueAtInfinity := rfl

/-- C1's unique finite pole has compactified value `N = ∞`. -/
@[simp] theorem Fstar_pole (A : ASection) :
    A.Fstar ((A.pole : ℂ) : OnePoint ℂ) = OnePoint.infty := by
  change (if (A.pole : ℂ) = (A.pole : ℂ) then OnePoint.infty
    else OnePoint.some (A.F (A.pole : ℂ))) = OnePoint.infty
  simp

/-- Away from the C1 pole, the compactified stem is the ordinary finite
stem value. -/
@[simp] theorem Fstar_coe (A : ASection) (z : ℂ)
    (hz : z ≠ (A.pole : ℂ)) :
    A.Fstar (z : OnePoint ℂ) = (A.F z : OnePoint ℂ) := by
  change (if z = (A.pole : ℂ) then OnePoint.infty
    else OnePoint.some (A.F z)) = OnePoint.some (A.F z)
  simp [hz]

/-! ## The one Euler–Weierstrass unit at the pole -/

/-- C1 supplies the nonvanishing analytic factor left after cancelling the
unique simple pole.  This is the pole-chart form of the one distinguished
Euler–Weierstrass transport unit. -/
private theorem c1PoleFactor_exists (A : ASection) :
    ∃ g : ℂ → ℂ, AnalyticAt ℂ g (A.pole : ℂ) ∧
      g (A.pole : ℂ) ≠ 0 ∧
      ∀ᶠ z in nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ,
        A.F z = (z - (A.pole : ℂ)) ^ (-1 : ℤ) • g z := by
  have hmer : MeromorphicAt A.F (A.pole : ℂ) :=
    A.meromorphic _ (Set.mem_univ _)
  exact (meromorphicOrderAt_eq_int_iff hmer).mp A.c1_simple

/-- The analytic C1 pole factor, determined by the A-section. -/
noncomputable def c1PoleFactor (A : ASection) : ℂ → ℂ :=
  Classical.choose (c1PoleFactor_exists A)

theorem c1PoleFactor_analyticAt (A : ASection) :
    AnalyticAt ℂ A.c1PoleFactor (A.pole : ℂ) :=
  (Classical.choose_spec (c1PoleFactor_exists A)).1

theorem c1PoleFactor_ne_zero (A : ASection) :
    A.c1PoleFactor (A.pole : ℂ) ≠ 0 :=
  (Classical.choose_spec (c1PoleFactor_exists A)).2.1

/-- Cancelling the C1 pole recovers the analytic transport factor on the
punctured pole chart. -/
theorem c1PoleFactor_eventually (A : ASection) :
    ∀ᶠ z in nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ,
      (z - (A.pole : ℂ)) * A.F z = A.c1PoleFactor z := by
  filter_upwards [(Classical.choose_spec (c1PoleFactor_exists A)).2.2,
    self_mem_nhdsWithin]
    with z hzF hz
  simp only [c1PoleFactor]
  rw [hzF, zpow_neg_one, smul_eq_mul]
  have hne : z - (A.pole : ℂ) ≠ 0 :=
    sub_ne_zero.mpr (Set.mem_compl_singleton_iff.mp hz)
  field_simp

/-- C3/W presents the same C1-continued unit by the full Weierstrass
factorization near the pole. -/
theorem c1PoleFactor_weierstrass (A : ASection) :
    ∀ᶠ z in nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ,
      A.c1PoleFactor z =
        z ^ A.m * A.Rfac z * Complex.exp (A.gfac z) *
          ∏' n, spherePrimary (A.genus n) (A.sphereZero n) z := by
  filter_upwards [A.c1PoleFactor_eventually, self_mem_nhdsWithin]
    with z hz hzpole
  rw [← A.c3_factorization z hzpole]
  exact hz.symm

/-- C2 presents the same C1-continued unit by the prime-sum Euler
exponential wherever the pole chart meets the Euler half-space. -/
theorem c1PoleFactor_euler (A : ASection) :
    ∀ᶠ z in nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ,
      A.Ω₀ < z.re →
        A.c1PoleFactor z =
          (z - (A.pole : ℂ)) * Complex.exp (∑' p : A.ι, A.ℓ p z) := by
  filter_upwards [A.c1PoleFactor_eventually]
    with z hz hhalf
  rw [← A.c2_euler z hhalf]
  exact hz.symm

/-- C1, C2, and C3 jointly identify one analytic pole-chart factor: C1
continues it through the simple pole, while C2 and C3 give its Euler and
Weierstrass presentations. -/
private theorem distinguishedPoleFactor_exists (A : ASection) :
    ∃ g : ℂ → ℂ,
      AnalyticAt ℂ g (A.pole : ℂ) ∧
      g (A.pole : ℂ) ≠ 0 ∧
      (∀ᶠ z in nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ,
        A.Ω₀ < z.re →
          g z = (z - (A.pole : ℂ)) *
            Complex.exp (∑' p : A.ι, A.ℓ p z)) ∧
      (∀ᶠ z in nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ,
        g z = z ^ A.m * A.Rfac z * Complex.exp (A.gfac z) *
          ∏' n, spherePrimary (A.genus n) (A.sphereZero n) z) := by
  exact ⟨A.c1PoleFactor, A.c1PoleFactor_analyticAt,
    A.c1PoleFactor_ne_zero, A.c1PoleFactor_euler,
    A.c1PoleFactor_weierstrass⟩

/-- The one A-determined analytic factor carrying both the Euler and
Weierstrass presentations through the pole. -/
noncomputable def distinguishedPoleFactor (A : ASection) : ℂ → ℂ :=
  Classical.choose (distinguishedPoleFactor_exists A)

theorem distinguishedPoleFactor_analyticAt (A : ASection) :
    AnalyticAt ℂ A.distinguishedPoleFactor (A.pole : ℂ) :=
  (Classical.choose_spec (distinguishedPoleFactor_exists A)).1

theorem distinguishedPoleFactor_ne_zero (A : ASection) :
    A.distinguishedPoleFactor (A.pole : ℂ) ≠ 0 :=
  (Classical.choose_spec (distinguishedPoleFactor_exists A)).2.1

theorem distinguishedPoleFactor_euler (A : ASection) :
    ∀ᶠ z in nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ,
      A.Ω₀ < z.re →
        A.distinguishedPoleFactor z =
          (z - (A.pole : ℂ)) * Complex.exp (∑' p : A.ι, A.ℓ p z) :=
  (Classical.choose_spec (distinguishedPoleFactor_exists A)).2.2.1

theorem distinguishedPoleFactor_weierstrass (A : ASection) :
    ∀ᶠ z in nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ,
      A.distinguishedPoleFactor z =
        z ^ A.m * A.Rfac z * Complex.exp (A.gfac z) *
          ∏' n, spherePrimary (A.genus n) (A.sphereZero n) z :=
  (Classical.choose_spec (distinguishedPoleFactor_exists A)).2.2.2

/-- The nonzero scalar carried by the diagonal `w = 0` distinguished
element at the common pole chart. -/
noncomputable def distinguishedPoleUnit (A : ASection) : ℂˣ :=
  Units.mk0 (A.distinguishedPoleFactor (A.pole : ℂ))
    A.distinguishedPoleFactor_ne_zero

/-- A compactified GPV value transport between two objects of the one
projective great-circle base. -/
structure GpvTransport (A : ASection)
    (σ σ' : GreatCircle.Point) (k : ℤ) : Type where
  domain : C(unitInterval, OnePoint ℂ)
  value : C(unitInterval, ℂ)
  lift : C(unitInterval, ℂ)
  domain_zero : domain 0 = GreatCircle.complexPoint σ
  domain_one : domain 1 = GreatCircle.complexPoint σ'
  value_compact : ∀ t, ((value t : ℂ) : OnePoint ℂ) = A.Fstar (domain t)
  value_ne_zero : ∀ t, value t ≠ 0
  lift_exp : ∀ t, Complex.exp (lift t) = value t
  winding : lift 1 - lift 0 = 2 * Real.pi * Complex.I * (k : ℂ)

/-- GPV winding changes only height, so the transported real level is the
same at both endpoints. -/
theorem GpvTransport.lift_endpoint_re_eq {A : ASection}
    {σ σ' : GreatCircle.Point} {k : ℤ} (h : GpvTransport A σ σ' k) :
    (h.lift 0).re = (h.lift 1).re := by
  have hw := congrArg Complex.re h.winding
  norm_num [Complex.mul_re] at hw
  linarith

/-- The value path of the section along a domain path avoiding its pole. -/
def projectiveValuePath (A : ASection) (δ : C(unitInterval, ℂ))
    (hp : ∀ t, δ t ≠ (A.pole : ℂ)) : C(unitInterval, ℂ) :=
  ⟨fun t => A.F (δ t), continuous_iff_continuousAt.mpr fun t =>
    ((A.c1_analyticAt (δ t) (hp t)).continuousAt).comp
      (map_continuous δ).continuousAt⟩

@[simp] theorem projectiveValuePath_apply (A : ASection)
    (δ : C(unitInterval, ℂ)) (hp : ∀ t, δ t ≠ (A.pole : ℂ))
    (t : unitInterval) :
    A.projectiveValuePath δ hp t = A.F (δ t) := rfl

/-- The GPV lift, level tape, continuity, uniqueness, and lift-independent
level supplied by an A-section and loaded onto its projective disk action. -/
theorem projective_gpv_transport (A : ASection)
    (δ : C(unitInterval, ℂ))
    (hp : ∀ t, δ t ≠ (A.pole : ℂ))
    (hne : ∀ t, A.F (δ t) ≠ 0) :
    ∃ Γ : C(unitInterval, ℂ),
      (∀ t, Complex.exp (Γ t) = A.F (δ t)) ∧
      (∀ t, (Γ t).re = Real.log ‖A.F (δ t)‖) ∧
      (Continuous fun t => (Γ t).re) ∧
      (∀ Γ' : C(unitInterval, ℂ),
        (∀ t, Complex.exp (Γ' t) = A.F (δ t)) →
          Γ' 0 = Γ 0 → Γ' = Γ) ∧
      (∀ Γ' : C(unitInterval, ℂ),
        (∀ t, Complex.exp (Γ' t) = A.F (δ t)) →
          ∀ t, (Γ' t).re = (Γ t).re) := by
  set γ : C(unitInterval, ℂ) := A.projectiveValuePath δ hp with hγ_def
  have hγval : ∀ t, γ t = A.F (δ t) := fun t => rfl
  have hγne : ∀ t, γ t ≠ 0 := fun t => (hγval t).symm ▸ hne t
  obtain ⟨Γ, hΓ⟩ := exists_log_continuation γ hγne
  have hΓ' : ∀ t, Complex.exp (Γ t) = A.F (δ t) := fun t =>
    (hΓ t).trans (hγval t)
  have htape : ∀ t, (Γ t).re = Real.log ‖A.F (δ t)‖ := fun t => by
    rw [← hΓ' t, Complex.norm_exp, Real.log_exp]
  refine ⟨Γ, hΓ', htape, ?_, ?_, ?_⟩
  · have hcont : Continuous fun t => Real.log ‖A.F (δ t)‖ :=
      ((map_continuous γ).norm).log fun t =>
        ne_of_gt (norm_pos_iff.mpr (hγne t))
    exact hcont.congr fun t => (htape t).symm
  · intro Γ' hΓ'lift h0
    exact winding_lift_unique γ hγne Γ' Γ
      (fun t => (hΓ'lift t).trans (hγval t).symm)
      (fun t => (hΓ' t).trans (hγval t).symm) h0
  · intro Γ' hΓ'lift t
    rw [htape t, ← hΓ'lift t, Complex.norm_exp, Real.log_exp]

end ASection
