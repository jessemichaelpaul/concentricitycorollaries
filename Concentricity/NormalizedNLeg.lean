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
def NormalizedNLeg.target : NormalizedCircleBase := OnePoint.infty

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

@[simp] theorem normalizedNLeg_source_label (A : ASection) (n : ℕ)
    (I : SphereWorld) : (NormalizedNLeg.source A n I).label =
      (A.sphereZero n).re := rfl

@[simp] theorem normalizedNLeg_target_is_N :
    NormalizedNLeg.target = (OnePoint.infty : GreatCircle.Point) := rfl

end ASection
