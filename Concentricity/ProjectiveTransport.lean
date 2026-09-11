/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.CayleyDictionary
import Concentricity.FaithfulApply
import Concentricity.ProjectiveCone
import Mathlib.CategoryTheory.Groupoid.Subgroupoid

/-!
# GPV value transport on the projective great circle

The pole-cancelled factor `g_A` of master `def:DA`, made one function on the
plane; the GPV transport of master `def:gpv-transport` between two objects
of the projective base, carrying its domain path, the value of `g_A` along
it, and the logarithmic lift; the circuit case with its winding integer; the
composition and inverse of transports; and the arrival at the pole of master
`lem:finite-pole-arrival`.
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

/-- master `def:DA`: the pole-cancelled factor `g_A`, one function on the
plane.  Away from the pole it is `(z - p_A) · A(z)`, the factor condition C1
continues; at the pole it is the finite nonzero value the continuation
produces (`c1PoleFactor`). -/
noncomputable def distinguishedPoleFactor (A : ASection) (z : ℂ) : ℂ :=
  if z = (A.pole : ℂ) then A.c1PoleFactor (A.pole : ℂ)
  else (z - (A.pole : ℂ)) * A.F z

@[simp] theorem distinguishedPoleFactor_pole (A : ASection) :
    A.distinguishedPoleFactor (A.pole : ℂ) = A.c1PoleFactor (A.pole : ℂ) := by
  simp [distinguishedPoleFactor]

theorem distinguishedPoleFactor_of_ne (A : ASection) {z : ℂ}
    (hz : z ≠ (A.pole : ℂ)) :
    A.distinguishedPoleFactor z = (z - (A.pole : ℂ)) * A.F z := by
  simp [distinguishedPoleFactor, hz]

/-- The pole-cancelled factor agrees with the analytic C1 factor on a
neighbourhood of the pole. -/
theorem distinguishedPoleFactor_eventuallyEq_c1 (A : ASection) :
    A.distinguishedPoleFactor =ᶠ[nhds (A.pole : ℂ)] A.c1PoleFactor := by
  have hwithin : ∀ᶠ z in nhds (A.pole : ℂ), z ∈ ({(A.pole : ℂ)}ᶜ : Set ℂ) →
      A.distinguishedPoleFactor z = A.c1PoleFactor z := by
    rw [← eventually_nhdsWithin_iff]
    filter_upwards [A.c1PoleFactor_eventually, self_mem_nhdsWithin] with z hz hzp
    rw [distinguishedPoleFactor_of_ne A (Set.mem_compl_singleton_iff.mp hzp), hz]
  filter_upwards [hwithin] with z hz
  by_cases hzp : z = (A.pole : ℂ)
  · subst hzp
    exact A.distinguishedPoleFactor_pole
  · exact hz (Set.mem_compl_singleton_iff.mpr hzp)

theorem distinguishedPoleFactor_analyticAt (A : ASection) :
    AnalyticAt ℂ A.distinguishedPoleFactor (A.pole : ℂ) :=
  A.c1PoleFactor_analyticAt.congr A.distinguishedPoleFactor_eventuallyEq_c1.symm

theorem distinguishedPoleFactor_ne_zero (A : ASection) :
    A.distinguishedPoleFactor (A.pole : ℂ) ≠ 0 := by
  rw [distinguishedPoleFactor_pole]
  exact A.c1PoleFactor_ne_zero

/-- master `def:DA`, the Euler presentation: on the half-space of C2 the
pole-cancelled factor is `(z - p_A) exp(∑ ℓ_p)`. -/
theorem distinguishedPoleFactor_euler (A : ASection) :
    ∀ᶠ z in nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ,
      A.Ω₀ < z.re →
        A.distinguishedPoleFactor z =
          (z - (A.pole : ℂ)) * Complex.exp (∑' p : A.ι, A.ℓ p z) := by
  filter_upwards [self_mem_nhdsWithin] with z hz hhalf
  rw [distinguishedPoleFactor_of_ne A (Set.mem_compl_singleton_iff.mp hz),
    A.c2_euler z hhalf]

/-- master `def:DA`, the Weierstrass presentation: away from the pole the
pole-cancelled factor is the C3 product. -/
theorem distinguishedPoleFactor_weierstrass (A : ASection) :
    ∀ᶠ z in nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ,
      A.distinguishedPoleFactor z =
        z ^ A.m * A.Rfac z * Complex.exp (A.gfac z) *
          ∏' n, spherePrimary (A.genus n) (A.sphereZero n) z := by
  filter_upwards [self_mem_nhdsWithin] with z hz
  rw [distinguishedPoleFactor_of_ne A (Set.mem_compl_singleton_iff.mp hz)]
  exact A.c3_factorization z (Set.mem_compl_singleton_iff.mp hz)

/-- The pole-cancelled factor is `(z - p_A)·F(z)` on a punctured
neighbourhood of the pole. -/
theorem distinguishedPoleFactor_eventually (A : ASection) :
    ∀ᶠ z in nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ,
      A.distinguishedPoleFactor z = (z - (A.pole : ℂ)) * A.F z := by
  filter_upwards [self_mem_nhdsWithin] with z hz
  exact distinguishedPoleFactor_of_ne A (Set.mem_compl_singleton_iff.mp hz)

/-- The pole-cancelled factor is continuous on the whole plane: analytic at
the pole, and the product of `z - p_A` with the stem elsewhere. -/
theorem continuous_distinguishedPoleFactor (A : ASection) :
    Continuous A.distinguishedPoleFactor := by
  rw [continuous_iff_continuousAt]
  intro z
  by_cases hz : z = (A.pole : ℂ)
  · subst hz
    exact A.distinguishedPoleFactor_analyticAt.continuousAt
  · have hev : (fun w => (w - (A.pole : ℂ)) * A.F w) =ᶠ[nhds z]
        A.distinguishedPoleFactor := by
      filter_upwards [isOpen_ne.mem_nhds hz] with w hw
      exact (distinguishedPoleFactor_of_ne A hw).symm
    refine ContinuousAt.congr ?_ hev
    exact ((continuous_id.sub continuous_const).continuousAt).mul
      (A.c1_analyticAt z hz).continuousAt

/-- The nonzero scalar carried by the diagonal `w = 0` distinguished
element at the common pole chart. -/
noncomputable def distinguishedPoleUnit (A : ASection) : ℂˣ :=
  Units.mk0 (A.distinguishedPoleFactor (A.pole : ℂ))
    A.distinguishedPoleFactor_ne_zero

/-- The pole multiplier `u_A = g_A(p_A)` is real: the stem is real on the real
axis, the pole is real, and the pole-cancelled factor is analytic at the pole. -/
theorem distinguishedPoleUnit_im_eq_zero (A : ASection) :
    (A.distinguishedPoleUnit : ℂ).im = 0 := by
  change (A.distinguishedPoleFactor (A.pole : ℂ)).im = 0
  have hcont : ContinuousAt A.distinguishedPoleFactor (A.pole : ℂ) :=
    A.distinguishedPoleFactor_analyticAt.continuousAt
  have hmap : Filter.Tendsto (fun x : ℝ => (x : ℂ))
      (nhdsWithin A.pole (Set.Ioi A.pole))
      (nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ) := by
    apply tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within
    · exact (Complex.continuous_ofReal.tendsto A.pole).mono_left nhdsWithin_le_nhds
    · filter_upwards [self_mem_nhdsWithin] with x hx
      exact Set.mem_compl_singleton_iff.mpr
        (fun h => ne_of_gt hx (Complex.ofReal_injective h))
  have h1 : Filter.Tendsto (fun x : ℝ => (A.distinguishedPoleFactor (x : ℂ)).im)
      (nhdsWithin A.pole (Set.Ioi A.pole))
      (nhds (A.distinguishedPoleFactor (A.pole : ℂ)).im) :=
    (Complex.continuous_im.tendsto _).comp
      (hcont.tendsto.comp (hmap.mono_right nhdsWithin_le_nhds))
  have h2 : Filter.Tendsto (fun x : ℝ => (A.distinguishedPoleFactor (x : ℂ)).im)
      (nhdsWithin A.pole (Set.Ioi A.pole)) (nhds 0) := by
    apply tendsto_const_nhds.congr'
    filter_upwards [hmap.eventually A.distinguishedPoleFactor_eventually] with x hx
    rw [hx, ← Complex.ofReal_sub, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
      A.real_on_real x, mul_zero, zero_mul, add_zero]
  exact tendsto_nhds_unique h1 h2

/-- The logarithmic coordinate of the continued Euler--Weierstrass unit at
the common pole chart.  Its exponential is the full `ℂˣ` multiplier; changing
the logarithmic branch changes only the GPV winding rung. -/
noncomputable def distinguishedPoleLog (A : ASection) : ℂ :=
  Complex.log (A.distinguishedPoleFactor (A.pole : ℂ))

@[simp] theorem exp_distinguishedPoleLog (A : ASection) :
    Complex.exp A.distinguishedPoleLog =
      A.distinguishedPoleFactor (A.pole : ℂ) := by
  exact Complex.exp_log A.distinguishedPoleFactor_ne_zero

/-- The pole unit is the exponential unit of the GPV logarithmic action. -/
theorem expUnit_distinguishedPoleLog (A : ASection) :
    GreatCircle.expUnit A.distinguishedPoleLog = A.distinguishedPoleUnit := by
  apply Units.ext
  exact A.exp_distinguishedPoleLog

/-- C1's continuation and C3's Weierstrass presentation land in the same
Cayley-disk exponential action as C2's prime-sum lift. -/
theorem diskExpAction_distinguishedPoleLog (A : ASection) :
    GreatCircle.diskExpAction A.distinguishedPoleLog =
      GreatCircle.diskDiagonalMoebiusHom A.distinguishedPoleUnit := by
  unfold GreatCircle.diskExpAction
  rw [A.expUnit_distinguishedPoleLog]

/-- The one C1--C3 Euler--Weierstrass--GPV disk action carried from the
projective north chart.  Its parameter is the complete nonzero complex unit:
the phase retains the winding/band and the modulus retains the real level. -/
noncomputable def distinguishedDiskAction (A : ASection) : Moebius :=
  GreatCircle.diskExpAction A.distinguishedPoleLog

/-- The distinguished disk action retains the full `ℂˣ` multiplier supplied
by the C1 continuation and its C2/C3 presentations. -/
theorem distinguishedDiskAction_eq_fullMultiplier (A : ASection) :
    A.distinguishedDiskAction =
      GreatCircle.diskDiagonalMoebiusHom A.distinguishedPoleUnit := by
  exact A.diskExpAction_distinguishedPoleLog

/-! ## C2 populates the distinguished projective-base action -/

/-- C2's canonical prime-sum logarithmic coordinate. -/
noncomputable def eulerPrimeSum (A : ASection) (z : ℂ) : ℂ :=
  ∑' p : A.ι, A.ℓ p z

/-- The C2 Euler multiplier as the distinguished Cayley-disk action. -/
noncomputable def eulerDiskAction (A : ASection) (z : ℂ) : Moebius :=
  GreatCircle.diskExpAction (A.eulerPrimeSum z)

/-- On the Euler half-space, the distinguished action's multiplier is
literally A's value `exp (∑ₚ ℓₚ)`. -/
theorem eulerDiskAction_eq_value (A : ASection) (z : ℂ)
    (hz : A.Ω₀ < z.re) :
    A.eulerDiskAction z =
      GreatCircle.diskDiagonalMoebiusHom
        (Units.mk0 (A.F z) (A.zero_free_on_halfSpace hz)) := by
  unfold eulerDiskAction GreatCircle.diskExpAction GreatCircle.expUnit eulerPrimeSum
  apply congrArg GreatCircle.diskDiagonalMoebiusHom
  apply Units.ext
  exact (A.c2_euler z hz).symm

/-! ## C1 and C3 join C2: two matrices, one action

The identification below lives in `Moebius` — the matrix group the action
groupoids are built from — never between ℂ-valued entries.  One subject
throughout: the C1-continued factor pushed through the one dictionary.  C2
reads it where the pole chart meets the Euler half-space, as the explicit
pole-factor matrix times the Euler-product matrix; C3 reads the same
element in Weierstrass form.  Its value at the pole itself is
`distinguishedDiskAction` (`distinguishedDiskAction_eq_fullMultiplier`).
No second action is defined and no bridge is stated: two matrices are one
action because C1 continues the entry and C3 presents it. -/

/-- TWO matrices are ONE action, because of C1 and C3 applied to the
distinguished Euler-product action.  On the punctured pole chart, the
matrix of the C1-continued factor is the pole-factor matrix times the
Euler-product matrix wherever the chart meets the half-space, and is the
Weierstrass-form matrix outright — equalities in the Möbius matrix group,
the analytic identities entering only through the entries. -/
theorem distinguished_euler_weierstrass_one_action (A : ASection) :
    ∀ᶠ z in nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ,
      ∃ (hg : A.distinguishedPoleFactor z ≠ 0)
        (hp : z - (A.pole : ℂ) ≠ 0)
        (hw : z ^ A.m * A.Rfac z * Complex.exp (A.gfac z) *
            ∏' n, spherePrimary (A.genus n) (A.sphereZero n) z ≠ 0),
        (A.Ω₀ < z.re →
          GreatCircle.diskDiagonalMoebiusHom
              (Units.mk0 (A.distinguishedPoleFactor z) hg) =
            GreatCircle.diskDiagonalMoebiusHom
                (Units.mk0 (z - (A.pole : ℂ)) hp) *
              A.eulerDiskAction z) ∧
        GreatCircle.diskDiagonalMoebiusHom
            (Units.mk0 (A.distinguishedPoleFactor z) hg) =
          GreatCircle.diskDiagonalMoebiusHom
            (Units.mk0
              (z ^ A.m * A.Rfac z * Complex.exp (A.gfac z) *
                ∏' n, spherePrimary (A.genus n) (A.sphereZero n) z) hw) := by
  have hne : ∀ᶠ z in nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ,
      A.distinguishedPoleFactor z ≠ 0 :=
    (A.distinguishedPoleFactor_analyticAt.continuousAt.eventually_ne
      A.distinguishedPoleFactor_ne_zero).filter_mono nhdsWithin_le_nhds
  filter_upwards [hne, A.distinguishedPoleFactor_euler,
    A.distinguishedPoleFactor_weierstrass, self_mem_nhdsWithin]
    with z hg heuler hweier hz
  have hzp : z ≠ (A.pole : ℂ) := Set.mem_compl_singleton_iff.mp hz
  have hp : z - (A.pole : ℂ) ≠ 0 := sub_ne_zero.mpr hzp
  have hw : z ^ A.m * A.Rfac z * Complex.exp (A.gfac z) *
      ∏' n, spherePrimary (A.genus n) (A.sphereZero n) z ≠ 0 :=
    fun hc => hg (hweier.trans hc)
  refine ⟨hg, hp, hw, fun hhalf => ?_, ?_⟩
  · have hval : A.distinguishedPoleFactor z =
        (z - (A.pole : ℂ)) * A.F z := by
      rw [heuler hhalf, ← A.c2_euler z hhalf]
    rw [A.eulerDiskAction_eq_value z hhalf, ← map_mul]
    apply congrArg GreatCircle.diskDiagonalMoebiusHom
    apply Units.ext
    simpa using hval
  · exact congrArg GreatCircle.diskDiagonalMoebiusHom (Units.ext hweier)

/-! ## The authored regularized Euler/Weierstrass boundary action

The GPV value tape itself is `A.F ∘ δ` on the zero-free locus.  At the
simple pole, C1 binds that tape to the regularized value
`(z - pole) * A.F z`, represented by `distinguishedPoleFactor`.  The value of
that analytic factor at the pole is nonzero, so it passes through the same
diagonal/Cayley dictionary as every GPV lift value.  This is the boundary
action positioned at North; it is not a GPV endpoint value of `A.F` at the
pole. -/

/-- The regularized C1 pole-chart value, read as an exponential disk action.
Away from the pole its Euler and Weierstrass presentations are supplied by
`distinguished_euler_weierstrass_one_action`; at the pole it remains a
nonzero multiplier. -/
noncomputable def regularizedPoleChartAction (A : ASection) (z : ℂ)
    (hz : A.distinguishedPoleFactor z ≠ 0) : Moebius :=
  GreatCircle.diskDiagonalMoebiusHom
    (Units.mk0 (A.distinguishedPoleFactor z) hz)

/-- At the pole, the regularized Euler/Weierstrass boundary action is exactly
the distinguished physical disk action `D_A`. -/
theorem regularizedPoleChartAction_at_pole (A : ASection) :
    A.regularizedPoleChartAction (A.pole : ℂ)
        A.distinguishedPoleFactor_ne_zero =
      A.distinguishedDiskAction := by
  exact A.distinguishedDiskAction_eq_fullMultiplier.symm

/-- The existing C1--C3 boundary theorem, exposed with the regularized action
as its subject: on the punctured pole chart it is the pole-factor times the
Euler action wherever the Euler half-space applies, and the Weierstrass
matrix outright. -/
theorem regularizedPoleChartAction_presentations (A : ASection) :
    ∀ᶠ z in nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ,
      ∃ (hg : A.distinguishedPoleFactor z ≠ 0)
        (hp : z - (A.pole : ℂ) ≠ 0)
        (hw : z ^ A.m * A.Rfac z * Complex.exp (A.gfac z) *
            ∏' n, spherePrimary (A.genus n) (A.sphereZero n) z ≠ 0),
        (A.Ω₀ < z.re →
          A.regularizedPoleChartAction z hg =
            GreatCircle.diskDiagonalMoebiusHom
                (Units.mk0 (z - (A.pole : ℂ)) hp) *
              A.eulerDiskAction z) ∧
        A.regularizedPoleChartAction z hg =
          GreatCircle.diskDiagonalMoebiusHom
            (Units.mk0
              (z ^ A.m * A.Rfac z * Complex.exp (A.gfac z) *
                ∏' n, spherePrimary (A.genus n) (A.sphereZero n) z) hw) := by
  simpa only [regularizedPoleChartAction] using
    A.distinguished_euler_weierstrass_one_action

/-! ## The pole lies at the boundary of the Euler half-space

master `def:A-section` (C2): the pole of C1 arises "from the divergence of
the prime sum at the boundary of the half-space".  Inside the open
half-space the section is the exponential of the completed prime sum, hence
continuous there; a simple pole is not. -/

/-- The pole is not inside the open Euler half-space. -/
theorem pole_re_le_Ω₀ (A : ASection) : (A.pole : ℂ).re ≤ A.Ω₀ := by
  by_contra hlt
  push_neg at hlt
  have hopen : IsOpen {z : ℂ | A.Ω₀ < z.re} :=
    isOpen_lt continuous_const Complex.continuous_re
  have hmem : (A.pole : ℂ) ∈ {z : ℂ | A.Ω₀ < z.re} := hlt
  have hcontF : ContinuousAt A.F (A.pole : ℂ) := by
    have h1 : ContinuousAt (fun z => Complex.exp (∑' p : A.ι, A.ℓ p z))
        (A.pole : ℂ) :=
      Complex.continuous_exp.continuousAt.comp
        (A.continuousOn_eulerSum.continuousAt (hopen.mem_nhds hmem))
    refine h1.congr ?_
    filter_upwards [hopen.mem_nhds hmem] with z hz
    exact (A.c2_euler z hz).symm
  obtain ⟨g, hg, hg0, hev⟩ :=
    (meromorphicOrderAt_eq_int_iff (A.meromorphic _ (Set.mem_univ _))).mp
      A.c1_simple
  have h1 : Tendsto (fun z => (z - (A.pole : ℂ)) * A.F z)
      (nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ) (nhds 0) := by
    have hmul : ContinuousAt (fun z : ℂ => (z - (A.pole : ℂ)) * A.F z) (A.pole : ℂ) :=
      ((continuous_id.sub continuous_const).continuousAt).mul hcontF
    have := hmul.tendsto
    simp only [sub_self, zero_mul] at this
    exact this.mono_left nhdsWithin_le_nhds
  have h2 : Tendsto (fun z => (z - (A.pole : ℂ)) * A.F z)
      (nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ) (nhds (g (A.pole : ℂ))) := by
    refine (hg.continuousAt.tendsto.mono_left nhdsWithin_le_nhds).congr' ?_
    filter_upwards [hev, self_mem_nhdsWithin] with z hz hzp
    have hne : z - (A.pole : ℂ) ≠ 0 :=
      sub_ne_zero.mpr (Set.mem_compl_singleton_iff.mp hzp)
    rw [hz, zpow_neg_one, smul_eq_mul]
    field_simp
  exact hg0 (tendsto_nhds_unique h2 h1)

/-- The finite pole of the A-section as an object of the projective base
(master `def:base`: "the finite pole `p_A` is one of its objects"). -/
def projectivePole (A : ASection) : GreatCircle.Base :=
  (((A.pole : ℝ) : GreatCircle.Point) : GreatCircle.Base)

/-! ## The GPV transport (master `def:gpv-transport`) -/

/-- master `def:gpv-transport`: a projective-base transport from `X` to `Y`
carries three synchronized data of one instant `t ∈ [0,1]`: the domain path
`δ` in the one plane every slice identifies with, running from the point of
`X` to the point of `Y`; the value the pole-cancelled factor `g_A` takes
there, the one factor condition C1 continues through the pole, presented by
the Euler product on the half-space and by the Weierstrass product at the
pole (`lem:finite-pole-arrival`: "the value along the run is `g_A(δ(t))`");
and the logarithmic lift `Γ` of that value.  The winding equation belongs
to the circuit case, `GpvCircuit` below. -/
structure GpvTransport (A : ASection) (X Y : GreatCircle.Base) : Type where
  domain : C(unitInterval, ℂ)
  value : C(unitInterval, ℂ)
  lift : C(unitInterval, ℂ)
  domain_zero : ((domain 0 : ℂ) : OnePoint ℂ) =
    GreatCircle.complexPoint (CategoryTheory.ActionCategory.back X)
  domain_one : ((domain 1 : ℂ) : OnePoint ℂ) =
    GreatCircle.complexPoint (CategoryTheory.ActionCategory.back Y)
  value_eq : ∀ t, value t = A.distinguishedPoleFactor (domain t)
  value_ne_zero : ∀ t, value t ≠ 0
  lift_exp : ∀ t, Complex.exp (lift t) = value t

namespace GpvTransport

variable {A : ASection} {X Y Z : GreatCircle.Base}

/-- Every point of the GPV lift acts through the same exponential diagonal
action whose multiplier is the transport's own value tape (master
`def:gpv-transport`, the matrix square at each instant). -/
theorem diskExpAction_eq_value (h : GpvTransport A X Y) (t : unitInterval) :
    GreatCircle.diskExpAction (h.lift t) =
      GreatCircle.diskDiagonalMoebiusHom
        (Units.mk0 (h.value t) (h.value_ne_zero t)) := by
  unfold GreatCircle.diskExpAction
  apply congrArg GreatCircle.diskDiagonalMoebiusHom
  apply Units.ext
  exact h.lift_exp t

/-- master `lem:real-level`: the real level at every instant is the
logarithm of the norm of the value. -/
theorem level (h : GpvTransport A X Y) (t : unitInterval) :
    (h.lift t).re = Real.log ‖h.value t‖ := by
  rw [← h.lift_exp t, Complex.norm_exp, Real.log_exp]

/-- master `lem:real-level`: the real level is continuous along the
transport. -/
theorem continuous_level (h : GpvTransport A X Y) :
    Continuous fun t => (h.lift t).re :=
  Complex.continuous_re.comp (map_continuous h.lift)

/-- master `lem:real-level`: a second lift of the same value tape is
determined by its initial value. -/
theorem lift_unique (h : GpvTransport A X Y)
    (lift' : C(unitInterval, ℂ))
    (hlift' : ∀ t, Complex.exp (lift' t) = h.value t)
    (hzero : lift' 0 = h.lift 0) :
    lift' = h.lift :=
  winding_lift_unique h.value h.value_ne_zero lift' h.lift
    hlift' h.lift_exp hzero

/-- master `lem:real-level`: every lift of the same value tape has the same
real part at every instant. -/
theorem level_independent (h : GpvTransport A X Y)
    (lift' : C(unitInterval, ℂ))
    (hlift' : ∀ t, Complex.exp (lift' t) = h.value t)
    (t : unitInterval) :
    (lift' t).re = (h.lift t).re := by
  rw [h.level t, ← hlift' t, Complex.norm_exp, Real.log_exp]

/-- At the source, the value is the pole-cancelled factor at the point of
the source object. -/
theorem value_at_source (h : GpvTransport A X Y) :
    h.value 0 = A.distinguishedPoleFactor (h.domain 0) :=
  h.value_eq 0

/-- At the target, the value is the pole-cancelled factor at the point of
the target object. -/
theorem value_at_target (h : GpvTransport A X Y) :
    h.value 1 = A.distinguishedPoleFactor (h.domain 1) :=
  h.value_eq 1

/-- The source object is a finite point of the base, and the domain path
starts there. -/
theorem exists_source_point (h : GpvTransport A X Y) :
    ∃ x : ℝ, CategoryTheory.ActionCategory.back X = (x : GreatCircle.Point) ∧
      h.domain 0 = (x : ℂ) := by
  have hfin : ∀ b : GreatCircle.Point,
      ((h.domain 0 : ℂ) : OnePoint ℂ) = GreatCircle.complexPoint b →
        ∃ x : ℝ, b = (x : GreatCircle.Point) ∧ h.domain 0 = (x : ℂ) := by
    intro b hb
    induction b using OnePoint.rec with
    | infty => exact absurd hb (OnePoint.coe_ne_infty _)
    | coe x => exact ⟨x, rfl, OnePoint.coe_injective hb⟩
  exact hfin _ h.domain_zero

/-- The target object is a finite point of the base, and the domain path
ends there. -/
theorem exists_target_point (h : GpvTransport A X Y) :
    ∃ y : ℝ, CategoryTheory.ActionCategory.back Y = (y : GreatCircle.Point) ∧
      h.domain 1 = (y : ℂ) := by
  have hfin : ∀ b : GreatCircle.Point,
      ((h.domain 1 : ℂ) : OnePoint ℂ) = GreatCircle.complexPoint b →
        ∃ y : ℝ, b = (y : GreatCircle.Point) ∧ h.domain 1 = (y : ℂ) := by
    intro b hb
    induction b using OnePoint.rec with
    | infty => exact absurd hb (OnePoint.coe_ne_infty _)
    | coe y => exact ⟨y, rfl, OnePoint.coe_injective hb⟩
  exact hfin _ h.domain_one

/-- Reversing a transport reverses its domain path; the value and lift
tapes are the same tapes read in the opposite direction. -/
noncomputable def inv (h : GpvTransport A X Y) : GpvTransport A Y X := by
  let rev : C(unitInterval, unitInterval) :=
    ⟨unitInterval.symm, unitInterval.continuous_symm⟩
  refine
    { domain := h.domain.comp rev
      value := h.value.comp rev
      lift := h.lift.comp rev
      domain_zero := ?_
      domain_one := ?_
      value_eq := ?_
      value_ne_zero := ?_
      lift_exp := ?_ }
  · simpa [rev] using h.domain_one
  · simpa [rev] using h.domain_zero
  · intro t
    exact h.value_eq (rev t)
  · intro t
    exact h.value_ne_zero (rev t)
  · intro t
    exact h.lift_exp (rev t)

/-- The identity transport at a finite base point where the pole-cancelled
factor is nonzero: the constant path. -/
noncomputable def refl (A : ASection) (x : ℝ)
    (hx : A.distinguishedPoleFactor x ≠ 0) :
    GpvTransport A ((x : GreatCircle.Point) : GreatCircle.Base)
      ((x : GreatCircle.Point) : GreatCircle.Base) where
  domain := ContinuousMap.const _ (x : ℂ)
  value := ContinuousMap.const _ (A.distinguishedPoleFactor x)
  lift := ContinuousMap.const _ (Complex.log (A.distinguishedPoleFactor x))
  domain_zero := rfl
  domain_one := rfl
  value_eq := fun _ => rfl
  value_ne_zero := fun _ => hx
  lift_exp := fun _ => Complex.exp_log hx

/-- Two composable transports meet at one point of the plane: the end of
the first domain path is the start of the second. -/
theorem join_eq (h₁ : GpvTransport A X Y) (h₂ : GpvTransport A Y Z) :
    h₁.domain 1 = h₂.domain 0 :=
  OnePoint.coe_injective (h₁.domain_one.trans h₂.domain_zero.symm)

/-- Composition of transports: the domain and value paths concatenate, and
the second lift is shifted by the whole winding separating the two
logarithms of the common value at the joint, so the lifts concatenate
continuously (`lem:finite-pole-arrival`: two lifts of one value differ by
`2πik`). -/
noncomputable def comp (h₁ : GpvTransport A X Y) (h₂ : GpvTransport A Y Z) :
    GpvTransport A X Z := by
  have hjoin : h₁.domain 1 = h₂.domain 0 := join_eq h₁ h₂
  have hval : h₁.value 1 = h₂.value 0 := by
    rw [h₁.value_eq, h₂.value_eq, hjoin]
  have hexp : Complex.exp (h₂.lift 0) = Complex.exp (h₁.lift 1) := by
    rw [h₂.lift_exp, h₁.lift_exp, hval]
  have hexp_shift : Complex.exp (h₂.lift 0 - h₁.lift 1) = 1 := by
    rw [Complex.exp_sub, hexp, div_self (Complex.exp_ne_zero _)]
  let lift₂ : C(unitInterval, ℂ) :=
    h₂.lift - ContinuousMap.const _ (h₂.lift 0 - h₁.lift 1)
  have hlift₂ : ∀ t, lift₂ t = h₂.lift t - (h₂.lift 0 - h₁.lift 1) :=
    fun _ => rfl
  have hlift₂_zero : lift₂ 0 = h₁.lift 1 := by
    rw [hlift₂]
    ring
  let δ : Path (h₁.domain 0) (h₂.domain 1) :=
    (⟨h₁.domain, rfl, rfl⟩ : Path (h₁.domain 0) (h₁.domain 1)).trans
      (⟨h₂.domain, hjoin.symm, rfl⟩ : Path (h₁.domain 1) (h₂.domain 1))
  let v : Path (h₁.value 0) (h₂.value 1) :=
    (⟨h₁.value, rfl, rfl⟩ : Path (h₁.value 0) (h₁.value 1)).trans
      (⟨h₂.value, hval.symm, rfl⟩ : Path (h₁.value 1) (h₂.value 1))
  let Γ : Path (h₁.lift 0) (lift₂ 1) :=
    (⟨h₁.lift, rfl, rfl⟩ : Path (h₁.lift 0) (h₁.lift 1)).trans
      (⟨lift₂, hlift₂_zero, rfl⟩ : Path (h₁.lift 1) (lift₂ 1))
  refine
    { domain := δ.toContinuousMap
      value := v.toContinuousMap
      lift := Γ.toContinuousMap
      domain_zero := ?_
      domain_one := ?_
      value_eq := ?_
      value_ne_zero := ?_
      lift_exp := ?_ }
  · show ((δ 0 : ℂ) : OnePoint ℂ) = _
    rw [δ.source]
    exact h₁.domain_zero
  · show ((δ 1 : ℂ) : OnePoint ℂ) = _
    rw [δ.target]
    exact h₂.domain_one
  · intro t
    show v t = A.distinguishedPoleFactor (δ t)
    simp only [δ, v, Path.trans_apply]
    split_ifs
    · exact h₁.value_eq _
    · exact h₂.value_eq _
  · intro t
    show v t ≠ 0
    simp only [v, Path.trans_apply]
    split_ifs
    · exact h₁.value_ne_zero _
    · exact h₂.value_ne_zero _
  · intro t
    show Complex.exp (Γ t) = v t
    simp only [Γ, v, Path.trans_apply]
    split_ifs
    · exact h₁.lift_exp _
    · change Complex.exp (lift₂ _) = h₂.value _
      rw [hlift₂, Complex.exp_sub, h₂.lift_exp, hexp_shift, div_one]

/-! ### Arrival at the pole (master `lem:finite-pole-arrival`) -/

/-- A transport ending at the pole ends its domain path at the pole. -/
theorem domain_one_pole (h : GpvTransport A X (projectivePole A)) :
    h.domain 1 = (A.pole : ℂ) :=
  OnePoint.coe_injective h.domain_one

/-- A transport starting at the pole starts its domain path at the pole. -/
theorem domain_zero_pole (h : GpvTransport A (projectivePole A) Y) :
    h.domain 0 = (A.pole : ℂ) :=
  OnePoint.coe_injective h.domain_zero

/-- master `lem:finite-pole-arrival`: `v(1) = g_A(p_A) = u_A`. -/
theorem value_one_pole (h : GpvTransport A X (projectivePole A)) :
    h.value 1 = A.distinguishedPoleFactor (A.pole : ℂ) := by
  rw [h.value_eq 1, h.domain_one_pole]

/-- master `lem:finite-pole-arrival`: `D(Γ(1)) = D(λ_A) = D_A`, the
arriving action is the distinguished disk action, for every branch. -/
theorem diskExpAction_at_pole (h : GpvTransport A X (projectivePole A)) :
    GreatCircle.diskExpAction (h.lift 1) = A.distinguishedDiskAction := by
  calc
    GreatCircle.diskExpAction (h.lift 1) =
        A.regularizedPoleChartAction (A.pole : ℂ)
          A.distinguishedPoleFactor_ne_zero := by
      unfold GreatCircle.diskExpAction GreatCircle.expUnit
        ASection.regularizedPoleChartAction
      apply congrArg GreatCircle.diskDiagonalMoebiusHom
      apply Units.ext
      exact (h.lift_exp 1).trans h.value_one_pole
    _ = A.distinguishedDiskAction := A.regularizedPoleChartAction_at_pole

/-- master `lem:finite-pole-arrival`: `Re Γ(1) = Re λ_A`. -/
theorem level_at_pole (h : GpvTransport A X (projectivePole A)) :
    (h.lift 1).re = A.distinguishedPoleLog.re := by
  have hlog : Real.log ‖A.distinguishedPoleFactor (A.pole : ℂ)‖ =
      A.distinguishedPoleLog.re := by
    rw [← A.exp_distinguishedPoleLog, Complex.norm_exp, Real.log_exp]
  rw [h.level 1, h.value_one_pole, hlog]

/-- master `lem:finite-pole-arrival`: two runs to the pole differ at the
pole by one whole winding, `Γ₂(1) − Γ₁(1) = 2πik`. -/
theorem joint_winding (h₁ : GpvTransport A X (projectivePole A))
    (h₂ : GpvTransport A Y (projectivePole A)) :
    ∃ k : ℤ, h₂.lift 1 - h₁.lift 1 =
      2 * Real.pi * Complex.I * (k : ℂ) := by
  have e1 : Complex.exp (h₁.lift 1) =
      A.distinguishedPoleFactor (A.pole : ℂ) := by
    rw [h₁.lift_exp 1, h₁.value_one_pole]
  have e2 : Complex.exp (h₂.lift 1) =
      A.distinguishedPoleFactor (A.pole : ℂ) := by
    rw [h₂.lift_exp 1, h₂.value_one_pole]
  obtain ⟨k, hk⟩ := Complex.exp_eq_exp_iff_exists_int.mp (e2.trans e1.symm)
  exact ⟨k, by rw [hk]; ring⟩

/-- The real levels of two runs to the pole agree there. -/
theorem joint_re_eq (h₁ : GpvTransport A X (projectivePole A))
    (h₂ : GpvTransport A Y (projectivePole A)) :
    (h₁.lift 1).re = (h₂.lift 1).re := by
  rw [h₁.level_at_pole, h₂.level_at_pole]

end GpvTransport

/-! ## The circuit case (master `def:gpv-transport`, the winding equation) -/

/-- master `def:gpv-transport`, the circuit case: "when the value path is a
circuit", the source and target values agree, the two endpoint logarithms
differ by one whole winding `2πik`, and `k` is the winding integer. -/
structure GpvCircuit (A : ASection) (X Y : GreatCircle.Base) (k : ℤ)
    extends GpvTransport A X Y where
  winding : lift 1 - lift 0 = 2 * Real.pi * Complex.I * (k : ℂ)

namespace GpvCircuit

variable {A : ASection} {X Y : GreatCircle.Base} {k : ℤ}

/-- A complete winding changes only the logarithmic rung: the two endpoints
of a circuit generate the same exponential action. -/
theorem diskExpAction_endpoint_eq (h : GpvCircuit A X Y k) :
    GreatCircle.diskExpAction (h.lift 0) =
      GreatCircle.diskExpAction (h.lift 1) := by
  unfold GreatCircle.diskExpAction
  apply congrArg GreatCircle.diskDiagonalMoebiusHom
  apply Units.ext
  have hlift : h.lift 1 =
      h.lift 0 + (k : ℂ) * (2 * Real.pi * Complex.I) := by
    calc
      h.lift 1 = (h.lift 1 - h.lift 0) + h.lift 0 := by ring
      _ = (2 * Real.pi * Complex.I * (k : ℂ)) + h.lift 0 := by
        rw [h.winding]
      _ = h.lift 0 + (k : ℂ) * (2 * Real.pi * Complex.I) := by ring
  change Complex.exp (h.lift 0) = Complex.exp (h.lift 1)
  rw [hlift, Complex.exp_add, Complex.exp_int_mul_two_pi_mul_I, mul_one]

/-- The winding changes only height: the real level is the same at both
endpoints of a circuit. -/
theorem lift_endpoint_re_eq (h : GpvCircuit A X Y k) :
    (h.lift 0).re = (h.lift 1).re := by
  have hw := congrArg Complex.re h.winding
  norm_num [Complex.mul_re] at hw
  linarith

/-- A circuit preserves the logarithm of the norm between its source and
target values. -/
theorem endpoint_log_norm_eq (h : GpvCircuit A X Y k) :
    Real.log ‖h.value 0‖ = Real.log ‖h.value 1‖ := by
  calc
    Real.log ‖h.value 0‖ = (h.lift 0).re := (h.level 0).symm
    _ = (h.lift 1).re := h.lift_endpoint_re_eq
    _ = Real.log ‖h.value 1‖ := h.level 1

/-- Since the value tape never vanishes, a circuit preserves the endpoint
norm itself. -/
theorem endpoint_norm_eq (h : GpvCircuit A X Y k) :
    ‖h.value 0‖ = ‖h.value 1‖ := by
  apply Real.log_injOn_pos
  · exact Set.mem_Ioi.mpr (norm_pos_iff.mpr (h.value_ne_zero 0))
  · exact Set.mem_Ioi.mpr (norm_pos_iff.mpr (h.value_ne_zero 1))
  · exact h.endpoint_log_norm_eq

/-- Reversing a circuit negates its winding. -/
noncomputable def inv (h : GpvCircuit A X Y k) : GpvCircuit A Y X (-k) :=
  { h.toGpvTransport.inv with
    winding := by
      have hrev0 : unitInterval.symm 0 = 1 := unitInterval.symm_zero
      have hrev1 : unitInterval.symm 1 = 0 := unitInterval.symm_one
      change h.lift (unitInterval.symm 1) - h.lift (unitInterval.symm 0) =
        2 * Real.pi * Complex.I * ((-k : ℤ) : ℂ)
      rw [hrev1, hrev0, ← neg_sub, h.winding]
      push_cast
      ring }

/-- master `def:gpv-transport`, the Euler half-space circuit: along a loop
`δ` in the zero-free half-space of C2, the pole-cancelled factor is
presented as `(z - p_A) exp(∑ ℓ_p)` (`def:DA`); its lift is the principal
logarithm of the pole factor, continuous because the pole lies at the
boundary of the half-space (`pole_re_le_Ω₀`), plus the completed prime sum,
continuous by local normal convergence; the loop returns to the same
element of the fibre, winding zero. -/
noncomputable def ofEulerHalfSpaceLoop (A : ASection)
    (X : GreatCircle.Base) (δ : C(unitInterval, ℂ))
    (hstart : ((δ 0 : ℂ) : OnePoint ℂ) = GreatCircle.complexPoint
      (CategoryTheory.ActionCategory.back X))
    (hloop : δ 0 = δ 1)
    (hhalf : ∀ t, A.Ω₀ < (δ t).re) :
    GpvCircuit A X X 0 := by
  have hpos : ∀ t, 0 < (δ t - (A.pole : ℂ)).re := fun t => by
    rw [Complex.sub_re]
    linarith [hhalf t, A.pole_re_le_Ω₀]
  have hslit : ∀ t, δ t - (A.pole : ℂ) ∈ Complex.slitPlane := fun t =>
    Complex.mem_slitPlane_iff.mpr (Or.inl (hpos t))
  have hsub : ∀ t, δ t - (A.pole : ℂ) ≠ 0 := fun t =>
    Complex.slitPlane_ne_zero (hslit t)
  have hpole : ∀ t, δ t ≠ (A.pole : ℂ) := fun t => sub_ne_zero.mp (hsub t)
  have hopen : IsOpen {z : ℂ | A.Ω₀ < z.re} :=
    isOpen_lt continuous_const Complex.continuous_re
  have hsum_cont : Continuous fun t : unitInterval =>
      ∑' p : A.ι, A.ℓ p (δ t) :=
    continuous_iff_continuousAt.mpr fun t =>
      (A.continuousOn_eulerSum.continuousAt
        (hopen.mem_nhds (hhalf t))).comp (map_continuous δ).continuousAt
  have hlog_cont : Continuous fun t : unitInterval =>
      Complex.log (δ t - (A.pole : ℂ)) :=
    continuous_iff_continuousAt.mpr fun t =>
      (continuousAt_clog (hslit t)).comp
        (f := fun s : unitInterval => δ s - (A.pole : ℂ))
        ((map_continuous δ).sub continuous_const).continuousAt
  let value : C(unitInterval, ℂ) :=
    ⟨fun t => A.distinguishedPoleFactor (δ t),
      A.continuous_distinguishedPoleFactor.comp (map_continuous δ)⟩
  let lift : C(unitInterval, ℂ) :=
    ⟨fun t => Complex.log (δ t - (A.pole : ℂ)) + ∑' p : A.ι, A.ℓ p (δ t),
      hlog_cont.add hsum_cont⟩
  have hval : ∀ t, value t =
      (δ t - (A.pole : ℂ)) * Complex.exp (∑' p : A.ι, A.ℓ p (δ t)) := fun t => by
    show A.distinguishedPoleFactor (δ t) = _
    rw [distinguishedPoleFactor_of_ne A (hpole t), A.c2_euler (δ t) (hhalf t)]
  have hlift : ∀ t, Complex.exp (lift t) = value t := fun t => by
    show Complex.exp (Complex.log (δ t - (A.pole : ℂ)) +
      ∑' p : A.ι, A.ℓ p (δ t)) = value t
    rw [Complex.exp_add, Complex.exp_log (hsub t), hval t]
  have hclosed : lift 1 = lift 0 := by
    show Complex.log (δ 1 - (A.pole : ℂ)) + ∑' p : A.ι, A.ℓ p (δ 1) =
      Complex.log (δ 0 - (A.pole : ℂ)) + ∑' p : A.ι, A.ℓ p (δ 0)
    rw [← hloop]
  exact
    { domain := δ
      value := value
      lift := lift
      domain_zero := hstart
      domain_one := by
        change ((δ 1 : ℂ) : OnePoint ℂ) = _
        rw [← hloop]
        exact hstart
      value_eq := fun _ => rfl
      value_ne_zero := fun t => by
        rw [hval t]
        exact mul_ne_zero (hsub t) (Complex.exp_ne_zero _)
      lift_exp := hlift
      winding := by
        rw [hclosed]
        norm_num }

end GpvCircuit


/-! ## The base the A-section functors are built over (master `def:base`)

master `def:base`: on a base arrow the states are transported "by the Möbius
transformation assigned by the already-proved functor `A^slice` and the
A-specific GPV transport".  The base the A-section functors are built over is
therefore the subgroupoid of the projective base whose morphisms are the real
matrices `h : a → b` between two points that a GPV transport of the
pole-cancelled factor joins.  Its objects are the finite points of the
compactified real line where `g_A ≠ 0`, the pole among them; the identity is
the constant transport, and inverses and composites are the reversed and
concatenated transports. -/

/-- The A-section's base: the subgroupoid of `B` whose morphisms are the real
matrices between two points joined by a GPV transport of the pole-cancelled
factor. -/
def continuedBase (A : ASection) : CategoryTheory.Subgroupoid GreatCircle.Base where
  arrows X Y := {_h | Nonempty (GpvTransport A X Y)}
  inv := fun {_X _Y} {_h} hh => hh.map GpvTransport.inv
  mul := fun {_X _Y _Z} {_p} hp {_q} hq =>
    hp.elim fun τ₁ => hq.elim fun τ₂ => ⟨τ₁.comp τ₂⟩

/-- A real matrix `h : X ⟶ Y` is a morphism of the A-section's base exactly when
a GPV transport of the pole-cancelled factor joins `X` to `Y`. -/
theorem mem_continuedBase_arrows (A : ASection) {X Y : GreatCircle.Base}
    (h : X ⟶ Y) :
    h ∈ (continuedBase A).arrows X Y ↔ Nonempty (GpvTransport A X Y) :=
  Iff.rfl

/-- The objects of the A-section's base are the finite points of the
compactified real line where the pole-cancelled factor is nonzero. -/
theorem mem_continuedBase_objs (A : ASection) (X : GreatCircle.Base) :
    X ∈ (continuedBase A).objs ↔
      ∃ x : ℝ, CategoryTheory.ActionCategory.back X = (x : GreatCircle.Point) ∧
        A.distinguishedPoleFactor (x : ℂ) ≠ 0 := by
  constructor
  · rintro ⟨_h, ⟨τ⟩⟩
    obtain ⟨x, hX, hx⟩ := τ.exists_source_point
    refine ⟨x, hX, ?_⟩
    rw [← hx, ← τ.value_eq 0]
    exact τ.value_ne_zero 0
  · rintro ⟨x, hX, hx⟩
    refine ⟨CategoryTheory.CategoryStruct.id X, ?_⟩
    change Nonempty (GpvTransport A X X)
    have hXeq : X = ((x : GreatCircle.Point) : GreatCircle.Base) := by
      cases X
      cases hX
      rfl
    subst hXeq
    exact ⟨GpvTransport.refl A x hx⟩

/-- The pole is an object of the A-section's base: `g_A(p_A) = u_A ≠ 0`. -/
theorem projectivePole_mem_continuedBase (A : ASection) :
    projectivePole A ∈ (continuedBase A).objs :=
  (mem_continuedBase_objs A _).mpr
    ⟨A.pole, rfl, A.distinguishedPoleFactor_ne_zero⟩

/-- The pole as an object of the A-section's base. -/
def continuedPole (A : ASection) : (continuedBase A).objs :=
  ⟨projectivePole A, A.projectivePole_mem_continuedBase⟩

/-- The forgetful functor from the A-section's base to the projective base:
it keeps the real matrix and forgets that a transport joins its ends. -/
abbrev continuedBaseForget (A : ASection) :
    CategoryTheory.Functor (continuedBase A).objs GreatCircle.Base :=
  (continuedBase A).hom

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

/-- The A-section itself generates the complete GPV logarithmic disk action
along every pole-avoiding, zero-free projective-base path.  No transport datum
is supplied independently: the value tape is `A.F ∘ δ`, the lift is produced by
GPV continuation, and its exponential is definitionally read by the same
`diskExpAction` used by the distinguished action. -/
theorem projective_gpv_disk_action (A : ASection)
    (δ : C(unitInterval, ℂ))
    (hp : ∀ t, δ t ≠ (A.pole : ℂ))
    (hne : ∀ t, A.F (δ t) ≠ 0) :
    ∃ Γ : C(unitInterval, ℂ),
      (∀ t, GreatCircle.diskExpAction (Γ t) =
        GreatCircle.diskDiagonalMoebiusHom
          (Units.mk0 (A.F (δ t)) (hne t))) ∧
      (∀ t, (Γ t).re = Real.log ‖A.F (δ t)‖) ∧
      (Continuous fun t => (Γ t).re) ∧
      (∀ Γ' : C(unitInterval, ℂ),
        (∀ t, Complex.exp (Γ' t) = A.F (δ t)) →
          Γ' 0 = Γ 0 → Γ' = Γ) ∧
      (∀ Γ' : C(unitInterval, ℂ),
        (∀ t, Complex.exp (Γ' t) = A.F (δ t)) →
          ∀ t, (Γ' t).re = (Γ t).re) := by
  obtain ⟨Γ, hlift, hlevel, hcontinuous, hunique, hindependent⟩ :=
    A.projective_gpv_transport δ hp hne
  refine ⟨Γ, ?_, hlevel, hcontinuous, hunique, hindependent⟩
  intro t
  unfold GreatCircle.diskExpAction GreatCircle.expUnit
  apply congrArg GreatCircle.diskDiagonalMoebiusHom
  apply Units.ext
  exact hlift t

/-! ## The authored 0-to-N run on the regularized tape

The author's order (recorded 2026-08-15/16): δ consumed once through the
Euler half-space, C1 continuing through the finite pole on the regularized
tape `distinguishedPoleFactor`, the north frame receiving the output by
positioning (`rmk:infty-marked`) — the one action presents as Weierstrass
at `N`, with δ(1) at the pole.  The raw `Fstar` tape cannot travel through
the pole (its compactified value is infinite there); the object C1
continues is the regularized factor, nonzero at the pole. -/

/-- The 0-to-N run of the one Euler-to-north/Weierstrass construction: a
transport on the regularized C1 tape, entering from the Euler half-space
(the author's "δ consumed once through the half-space") and ending at the
pole — δ(1) at the pole, where the north frame receives its output by
positioning. -/
structure RegularizedNorthRun (A : ASection) : Type where
  domain : C(unitInterval, ℂ)
  value : C(unitInterval, ℂ)
  lift : C(unitInterval, ℂ)
  start_half : A.Ω₀ < (domain 0).re
  domain_one : domain 1 = (A.pole : ℂ)
  value_reg : ∀ t, value t = A.distinguishedPoleFactor (domain t)
  value_ne_zero : ∀ t, value t ≠ 0
  lift_exp : ∀ t, Complex.exp (lift t) = value t

/-- The run's level at every instant is the logarithm of the norm of its
own regularized value tape. -/
theorem RegularizedNorthRun.level {A : ASection}
    (r : A.RegularizedNorthRun) (t : unitInterval) :
    (r.lift t).re = Real.log ‖r.value t‖ := by
  rw [← r.lift_exp t, Complex.norm_exp, Real.log_exp]

/-- **The run presents as Weierstrass at `N`**: at δ(1) — the pole — the
exponential disk action of the run's lift IS the one distinguished disk
action `D_A`.  The element face of C1's continuation, received at the
north frame by positioning. -/
theorem RegularizedNorthRun.diskExpAction_at_pole {A : ASection}
    (r : A.RegularizedNorthRun) :
    GreatCircle.diskExpAction (r.lift 1) = A.distinguishedDiskAction := by
  have hval : r.value 1 = A.distinguishedPoleFactor (A.pole : ℂ) := by
    rw [r.value_reg 1, r.domain_one]
  calc
    GreatCircle.diskExpAction (r.lift 1) =
        A.regularizedPoleChartAction (A.pole : ℂ)
          A.distinguishedPoleFactor_ne_zero := by
      unfold GreatCircle.diskExpAction GreatCircle.expUnit
        ASection.regularizedPoleChartAction
      apply congrArg GreatCircle.diskDiagonalMoebiusHom
      apply Units.ext
      exact (r.lift_exp 1).trans hval
    _ = A.distinguishedDiskAction := A.regularizedPoleChartAction_at_pole

/-- The run's level at `N` is the real part of the distinguished pole log
`λ_A`: every run carries the same real number to the north frame. -/
theorem RegularizedNorthRun.level_at_pole {A : ASection}
    (r : A.RegularizedNorthRun) :
    (r.lift 1).re = A.distinguishedPoleLog.re := by
  have hval : r.value 1 = A.distinguishedPoleFactor (A.pole : ℂ) := by
    rw [r.value_reg 1, r.domain_one]
  have hlog : Real.log ‖A.distinguishedPoleFactor (A.pole : ℂ)‖ =
      A.distinguishedPoleLog.re := by
    rw [← A.exp_distinguishedPoleLog, Complex.norm_exp, Real.log_exp]
  rw [r.level 1, hval, hlog]

/-- **At `N` two runs differ only imaginarily** (the author, 2026-08-16):
both lifts arrive as logarithms of the same distinguished pole value, so
their discrepancy at the joint is a whole winding, `2πik`. -/
theorem RegularizedNorthRun.joint_winding {A : ASection}
    (r₁ r₂ : A.RegularizedNorthRun) :
    ∃ k : ℤ, r₂.lift 1 - r₁.lift 1 =
      2 * Real.pi * Complex.I * (k : ℂ) := by
  have h1 : Complex.exp (r₁.lift 1) =
      A.distinguishedPoleFactor (A.pole : ℂ) := by
    rw [r₁.lift_exp 1, r₁.value_reg 1, r₁.domain_one]
  have h2 : Complex.exp (r₂.lift 1) =
      A.distinguishedPoleFactor (A.pole : ℂ) := by
    rw [r₂.lift_exp 1, r₂.value_reg 1, r₂.domain_one]
  obtain ⟨k, hk⟩ := Complex.exp_eq_exp_iff_exists_int.mp (h2.trans h1.symm)
  exact ⟨k, by rw [hk]; ring⟩

/-- The real levels of any two runs agree at `N` outright. -/
theorem RegularizedNorthRun.joint_re_eq {A : ASection}
    (r₁ r₂ : A.RegularizedNorthRun) :
    (r₁.lift 1).re = (r₂.lift 1).re := by
  rw [r₁.level_at_pole, r₂.level_at_pole]

end ASection
