import Concentricity.ASectionTotalActionState

noncomputable section

/-- The literal public conclusion of the Concentricity Theorem.  This audit
contains no proof and no reference to either the old slice projection or the
new total; it checks only that the intended mathematical statement is
well-typed over an A-section. -/
def ASection.ConcentricityConclusion (A : ASection) : Prop :=
  ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c

#check ASection.sphereZero
#check ASection.ConcentricityConclusion

example (A : ASection) :
    A.ConcentricityConclusion ↔
      ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c :=
  Iff.rfl
