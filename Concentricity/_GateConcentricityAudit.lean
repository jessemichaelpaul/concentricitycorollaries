import Concentricity.Theorem
import Concentricity.ASectionCResidueDiagram
import Concentricity.ASectionTotalActionState

noncomputable section

open CategoryTheory

/- TARGET-FIRST GATE (register/80): the requested outer declaration is the
first consumer.  Nothing below counts until this compiles. -/
example (A : ASection) :
    ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c :=
  ASection.concentricity A

/- The read-set suppliers, at their real names. -/
#check @ASection.transportLevel
#check @ASection.AsectionCResidueDiagram
#check @ASection.AsectionCResidueInclusion
#check @ASection.IsCResidueState
#check @ASection.IsNorthCResidueState
#check @ASection.residueTotal
#check @ASection.sphereZero_mem_CResidueZeroLocus
#check @pi0Functor
#check @pi0GrothendieckEquiv
#check @CategoryTheory.ConnectedComponents
#check @CategoryTheory.isPreconnected_zigzag

/- Certificate receipts and #print axioms are completed when the theorem
closes (register/80: one gate, one triple certificate, no intermediate
victory). -/
