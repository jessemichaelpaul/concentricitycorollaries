/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.CayleyDictionary
import Concentricity.FaithfulApply
import Concentricity.NormalizedNLeg
import Concentricity.ProjectiveCone

/-!
# GPV value-transport cargo on the projective great circle

This file contains the compactified stem and GPV lift facts loaded into the
completed A-section functor.  Its endpoints are objects of the unique
projective groupoid `GreatCircle.Base`.
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

/-- A compactified GPV value transport between two objects of the one
projective great-circle base.  The endpoints are genuine objects of
`GreatCircle.Base`, not bare points later wrapped into that groupoid. -/
structure GpvTransport (A : ASection)
    (X Y : GreatCircle.Base) (k : ℤ) : Type where
  domain : C(unitInterval, OnePoint ℂ)
  value : C(unitInterval, ℂ)
  lift : C(unitInterval, ℂ)
  domain_zero : domain 0 = GreatCircle.cayleyCoord
    (CategoryTheory.ActionCategory.back X)
  domain_one : domain 1 = GreatCircle.cayleyCoord
    (CategoryTheory.ActionCategory.back Y)
  value_compact : ∀ t, ((value t : ℂ) : OnePoint ℂ) = A.Fstar (domain t)
  value_ne_zero : ∀ t, value t ≠ 0
  lift_exp : ∀ t, Complex.exp (lift t) = value t
  winding : lift 1 - lift 0 = 2 * Real.pi * Complex.I * (k : ℂ)

/-- Every point of the GPV lift acts through the same exponential diagonal
action whose multiplier is the transport's own value tape.  Thus value,
lift, level, and winding are coordinates of the distinguished action itself,
not data attached to a later sphere-world arrow. -/
theorem GpvTransport.diskExpAction_eq_value {A : ASection}
    {X Y : GreatCircle.Base} {k : ℤ} (h : GpvTransport A X Y k)
    (t : unitInterval) :
    GreatCircle.diskExpAction (h.lift t) =
      GreatCircle.diskDiagonalMoebiusHom
        (Units.mk0 (h.value t) (h.value_ne_zero t)) := by
  unfold GreatCircle.diskExpAction
  apply congrArg GreatCircle.diskDiagonalMoebiusHom
  apply Units.ext
  exact h.lift_exp t

/-- A complete GPV winding changes only the logarithmic rung: its two
endpoints determine the same `ℂˣ` Cayley-disk automorphism.  This is the
base-action form of the winding law, before orbit--stabilizer transports the
action through `SphereWorld`. -/
theorem GpvTransport.diskExpAction_endpoint_eq {A : ASection}
    {X Y : GreatCircle.Base} {k : ℤ} (h : GpvTransport A X Y k) :
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

/-- GPV winding changes only height, so the transported real level is the
same at both endpoints. -/
theorem GpvTransport.lift_endpoint_re_eq {A : ASection}
    {X Y : GreatCircle.Base} {k : ℤ} (h : GpvTransport A X Y k) :
    (h.lift 0).re = (h.lift 1).re := by
  have hw := congrArg Complex.re h.winding
  norm_num [Complex.mul_re] at hw
  linarith

/-- The real level carried at every instant by a projective-base transport is
the logarithm of the norm of its own value tape. -/
theorem GpvTransport.level {A : ASection}
    {X Y : GreatCircle.Base} {k : ℤ} (h : GpvTransport A X Y k)
    (t : unitInterval) :
    (h.lift t).re = Real.log ‖h.value t‖ := by
  rw [← h.lift_exp t, Complex.norm_exp, Real.log_exp]

/-- The transported real level varies continuously along every genuine
projective-base transport. -/
theorem GpvTransport.continuous_level {A : ASection}
    {X Y : GreatCircle.Base} {k : ℤ} (h : GpvTransport A X Y k) :
    Continuous fun t => (h.lift t).re :=
  Complex.continuous_re.comp (map_continuous h.lift)

/-- A second logarithmic lift of the same projective-base value tape is
uniquely determined by its initial value. -/
theorem GpvTransport.lift_unique {A : ASection}
    {X Y : GreatCircle.Base} {k : ℤ} (h : GpvTransport A X Y k)
    (lift' : C(unitInterval, ℂ))
    (hlift' : ∀ t, Complex.exp (lift' t) = h.value t)
    (hzero : lift' 0 = h.lift 0) :
    lift' = h.lift := by
  exact winding_lift_unique h.value h.value_ne_zero lift' h.lift
    hlift' h.lift_exp hzero

/-- The real level belongs to the projective-base value transport, not to a
choice of logarithmic lift: every lift of the same value tape has the same
real part at every instant. -/
theorem GpvTransport.level_independent {A : ASection}
    {X Y : GreatCircle.Base} {k : ℤ} (h : GpvTransport A X Y k)
    (lift' : C(unitInterval, ℂ))
    (hlift' : ∀ t, Complex.exp (lift' t) = h.value t)
    (t : unitInterval) :
    (lift' t).re = (h.lift t).re := by
  rw [h.level t, ← hlift' t, Complex.norm_exp, Real.log_exp]

/-- At the source object, the GPV value tape is exactly the compactified
`A`-value at that projective-base footpoint. -/
theorem GpvTransport.value_at_source {A : ASection}
    {X Y : GreatCircle.Base} {k : ℤ} (h : GpvTransport A X Y k) :
    ((h.value 0 : ℂ) : OnePoint ℂ) =
      A.Fstar (GreatCircle.cayleyCoord
        (CategoryTheory.ActionCategory.back X)) := by
  calc
    ((h.value 0 : ℂ) : OnePoint ℂ) = A.Fstar (h.domain 0) :=
      h.value_compact 0
    _ = A.Fstar (GreatCircle.cayleyCoord
        (CategoryTheory.ActionCategory.back X)) :=
      congrArg A.Fstar h.domain_zero

/-- At the target object, the GPV value tape is exactly the compactified
`A`-value at that projective-base footpoint. -/
theorem GpvTransport.value_at_target {A : ASection}
    {X Y : GreatCircle.Base} {k : ℤ} (h : GpvTransport A X Y k) :
    ((h.value 1 : ℂ) : OnePoint ℂ) =
      A.Fstar (GreatCircle.cayleyCoord
        (CategoryTheory.ActionCategory.back Y)) := by
  calc
    ((h.value 1 : ℂ) : OnePoint ℂ) = A.Fstar (h.domain 1) :=
      h.value_compact 1
    _ = A.Fstar (GreatCircle.cayleyCoord
        (CategoryTheory.ActionCategory.back Y)) :=
      congrArg A.Fstar h.domain_one

/-- A genuine GPV transport over the projective base preserves the logarithm
of the norm between its source and target value states. -/
theorem GpvTransport.endpoint_log_norm_eq {A : ASection}
    {X Y : GreatCircle.Base} {k : ℤ} (h : GpvTransport A X Y k) :
    Real.log ‖h.value 0‖ = Real.log ‖h.value 1‖ := by
  calc
    Real.log ‖h.value 0‖ = (h.lift 0).re := (h.level 0).symm
    _ = (h.lift 1).re := h.lift_endpoint_re_eq
    _ = Real.log ‖h.value 1‖ := h.level 1

/-- Since the GPV value tape never vanishes, preservation of its logarithmic
real level is equivalently preservation of the endpoint norm itself. -/
theorem GpvTransport.endpoint_norm_eq {A : ASection}
    {X Y : GreatCircle.Base} {k : ℤ} (h : GpvTransport A X Y k) :
    ‖h.value 0‖ = ‖h.value 1‖ := by
  apply Real.log_injOn_pos
  · exact Set.mem_Ioi.mpr (norm_pos_iff.mpr (h.value_ne_zero 0))
  · exact Set.mem_Ioi.mpr (norm_pos_iff.mpr (h.value_ne_zero 1))
  · exact h.endpoint_log_norm_eq

/-- Reversing a compactified GPV transport reverses its base path and
negates its winding.  The value and lift tapes are the same tapes read in
the opposite direction. -/
noncomputable def GpvTransport.inv {A : ASection}
    {X Y : GreatCircle.Base} {k : ℤ} (h : GpvTransport A X Y k) :
    GpvTransport A Y X (-k) := by
  let rev : C(unitInterval, unitInterval) :=
    ⟨unitInterval.symm, unitInterval.continuous_symm⟩
  refine
    { domain := h.domain.comp rev
      value := h.value.comp rev
      lift := h.lift.comp rev
      domain_zero := ?_
      domain_one := ?_
      value_compact := ?_
      value_ne_zero := ?_
      lift_exp := ?_
      winding := ?_ }
  · simpa [rev] using h.domain_one
  · simpa [rev] using h.domain_zero
  · intro t
    exact h.value_compact (rev t)
  · intro t
    exact h.value_ne_zero (rev t)
  · intro t
    exact h.lift_exp (rev t)
  · have hrev0 : rev 0 = 1 := unitInterval.symm_zero
    have hrev1 : rev 1 = 0 := unitInterval.symm_one
    change h.lift (rev 1) - h.lift (rev 0) =
      2 * Real.pi * Complex.I * ((-k : ℤ) : ℂ)
    rw [hrev1, hrev0]
    rw [← neg_sub, h.winding]
    push_cast
    ring

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

/-- W1 as a literal projective-base transport: a loop in C2's Euler
half-space carries the prime-sum lift and has winding zero.  The resulting
datum is a `GpvTransport` over the same point of the shared compactified
great circle. -/
noncomputable def GpvTransport.ofEulerHalfSpaceLoop (A : ASection)
    (X : GreatCircle.Base) (δ : C(unitInterval, ℂ))
    (hstart : ((δ 0 : ℂ) : OnePoint ℂ) = GreatCircle.cayleyCoord
      (CategoryTheory.ActionCategory.back X))
    (hloop : δ 0 = δ 1)
    (hpole : ∀ t, δ t ≠ (A.pole : ℂ))
    (hhalf : ∀ t, A.Ω₀ < (δ t).re) :
    GpvTransport A X X 0 := by
  let value : C(unitInterval, ℂ) := A.projectiveValuePath δ hpole
  have hvalue : ∀ t, value t = A.F (δ t) := fun _ => rfl
  have hne : ∀ t, value t ≠ 0 := fun t => by
    rw [hvalue t]
    exact A.zero_free_on_halfSpace (hhalf t)
  have hopen : IsOpen {z : ℂ | A.Ω₀ < z.re} :=
    isOpen_lt continuous_const Complex.continuous_re
  have hcont : Continuous fun t : unitInterval =>
      ∑' p : A.ι, A.ℓ p (δ t) :=
    continuous_iff_continuousAt.mpr fun t =>
      (A.continuousOn_eulerSum.continuousAt
        (hopen.mem_nhds (hhalf t))).comp (map_continuous δ).continuousAt
  let lift : C(unitInterval, ℂ) :=
    ⟨fun t => ∑' p : A.ι, A.ℓ p (δ t), hcont⟩
  have hlift : ∀ t, Complex.exp (lift t) = value t := fun t => by
    rw [hvalue t]
    exact (A.c2_euler (δ t) (hhalf t)).symm
  have hclosed : lift 1 = lift 0 := by
    change (∑' p : A.ι, A.ℓ p (δ 1)) = ∑' p : A.ι, A.ℓ p (δ 0)
    rw [← hloop]
  let domain : C(unitInterval, OnePoint ℂ) :=
    ⟨fun t => ((δ t : ℂ) : OnePoint ℂ),
      OnePoint.continuous_coe.comp (map_continuous δ)⟩
  refine
    { domain := domain
      value := value
      lift := lift
      domain_zero := hstart
      domain_one := ?_
      value_compact := ?_
      value_ne_zero := hne
      lift_exp := hlift
      winding := ?_ }
  · change ((δ 1 : ℂ) : OnePoint ℂ) = GreatCircle.cayleyCoord
      (CategoryTheory.ActionCategory.back X)
    rw [← hloop]
    exact hstart
  · intro t
    change ((A.F (δ t) : ℂ) : OnePoint ℂ) =
      A.Fstar ((δ t : ℂ) : OnePoint ℂ)
    exact (A.Fstar_coe (δ t) (hpole t)).symm
  · rw [hclosed]
    norm_num

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

end ASection
