/-
Concentricity/NormalizedNLeg.lean

Step 4 of the normalized section construction: a certified analytic leg from
each normalized C-residue zero object toward the common compactified witness
N. The next step will package these legs as morphisms of the normalized
transport category.
-/
import Concentricity.NormalizedPoleBridge

noncomputable section

namespace ASection

/-- The source object of the normalized n-th witness leg in slice world `I`. -/
def NormalizedNLeg.source (A : ASection) (n : ℕ) (I : SphereWorld) :
    NormalizedZeroObject A := A.normalizedZero n I

/-- The common compactified target of every normalized witness leg. -/
def NormalizedNLeg.target : NormalizedCircleBase :=
  (OnePoint.infty : GreatCircle.Point)

/-- Analytic certificate carried by the normalized leg: the C3 zero loop and
the multiplicity-corrected C1 pole loop admit a common closed logarithmic
lift. -/
structure NormalizedNLeg (A : ASection) (n : ℕ) (I : SphereWorld) : Type where
  closure :
    ∃ εz > 0, ∃ εp > 0,
      ∀ ε₁ : ℝ, 0 < ε₁ → ε₁ ≤ εz → ∀ ε₂ : ℝ, 0 < ε₂ → ε₂ ≤ εp →
      ∃ Γz Γp Γ' : C(unitInterval, ℂ),
        (∀ t, Γz t = A.F (circleLoop (A.sphereZero n) ε₁ t)) ∧
        (∀ t, Γp t = A.F (circleLoop (A.pole : ℂ) ε₂ t)) ∧
        (∀ t, Complex.exp (Γ' t) =
          (Γz * Γp ^ Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n}) t) ∧
        Γ' 1 = Γ' 0

/-- C1 and C3 construct a normalized analytic leg to the common witness for
every zero index and every slice world. -/
def normalizedNLeg (A : ASection) (n : ℕ) (I : SphereWorld) :
    NormalizedNLeg A n I :=
  ⟨A.normalizedZero_pole_power_closes n I⟩

/-- One concrete zero--pole value tape extracted from the normalized
analytic leg.  Its radii, value loops, and logarithmic lift are all produced
by C1/C3; no endpoint or value label is supplied separately. -/
structure NormalizedNActionTape (A : ASection) (n : ℕ) : Type where
  zeroRadius : ℝ
  poleRadius : ℝ
  zeroRadius_pos : 0 < zeroRadius
  poleRadius_pos : 0 < poleRadius
  zeroLoop : C(unitInterval, ℂ)
  poleLoop : C(unitInterval, ℂ)
  lift : C(unitInterval, ℂ)
  zeroLoop_eq :
    ∀ t, zeroLoop t =
      A.F (circleLoop (A.sphereZero n) zeroRadius t)
  poleLoop_eq :
    ∀ t, poleLoop t =
      A.F (circleLoop (A.pole : ℂ) poleRadius t)
  lift_exp :
    ∀ t, Complex.exp (lift t) =
      (zeroLoop *
        poleLoop ^ Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n}) t
  lift_unique :
    ∀ lift' : C(unitInterval, ℂ),
      (∀ t, Complex.exp (lift' t) =
        (zeroLoop *
          poleLoop ^ Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n}) t) →
      lift' 0 = lift 0 →
      lift' = lift
  lift_closed : lift 1 = lift 0

/-- Every normalized zero-to-N leg supplies a concrete closed action tape.
Choosing radii inside the certified neighborhoods only exposes the data
already carried by `normalizedNLeg`. -/
theorem normalizedNActionTape_exists (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    Nonempty (NormalizedNActionTape A n) := by
  obtain ⟨εz, hεz, εp, hεp, hclosure⟩ :=
    (A.normalizedNLeg n I).closure
  have hzhalf : 0 < εz / 2 := by linarith
  have hphalf : 0 < εp / 2 := by linarith
  have hzle : εz / 2 ≤ εz := by linarith
  have hple : εp / 2 ≤ εp := by linarith
  obtain ⟨Γz, Γp, Γ', hΓz, hΓp, hΓ'exp, hΓ'closed⟩ :=
    hclosure (εz / 2) hzhalf hzle (εp / 2) hphalf hple
  have hvalue_ne_zero :
      ∀ t,
        (Γz *
          Γp ^ Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n}) t ≠ 0 := by
    intro t hzero
    exact Complex.exp_ne_zero (Γ' t) ((hΓ'exp t).trans hzero)
  exact ⟨
    { zeroRadius := εz / 2
      poleRadius := εp / 2
      zeroRadius_pos := hzhalf
      poleRadius_pos := hphalf
      zeroLoop := Γz
      poleLoop := Γp
      lift := Γ'
      zeroLoop_eq := hΓz
      poleLoop_eq := hΓp
      lift_exp := hΓ'exp
      lift_unique := fun lift' hlift' hzero =>
        winding_lift_unique
          (Γz *
            Γp ^ Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n})
          hvalue_ne_zero lift' Γ' hlift' hΓ'exp hzero
      lift_closed := hΓ'closed }⟩

/-- The A-generated closed action tape on the n-th normalized N-leg. -/
noncomputable def normalizedNActionTape (A : ASection) (n : ℕ)
    (I : SphereWorld) : NormalizedNActionTape A n :=
  Classical.choice (A.normalizedNActionTape_exists n I)

@[simp] theorem normalizedNLeg_source_label (A : ASection) (n : ℕ)
    (I : SphereWorld) : (NormalizedNLeg.source A n I).label =
      (A.sphereZero n).re := rfl

@[simp] theorem normalizedNLeg_target_is_N :
    CategoryTheory.ActionCategory.back NormalizedNLeg.target =
      (OnePoint.infty : GreatCircle.Point) := rfl

end ASection
