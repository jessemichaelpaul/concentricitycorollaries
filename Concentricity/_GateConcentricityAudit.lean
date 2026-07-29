import Concentricity.Theorem
import Concentricity.ASectionCResidueDiagram
import Concentricity.ASectionTotalActionState
import Concentricity.Corollaries

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

/- THE ι_A-ONWARD LEDGER (kernel receipts, raw).  Everything below except
the last three lines must print exactly [propext, Classical.choice,
Quot.sound].  The last three (the theorem and its two consumers) must
additionally show sorryAx — the two clause-holes at the node, the ONLY
open content in the repository. -/
#print axioms ASection.IsNorthCResidueState
#print axioms ASection.IsCResidueState
#print axioms ASection.AsectionCResidueTransport
#print axioms ASection.AsectionCResidueDiagram
#print axioms ASection.AsectionCResidueInclusion
#print axioms ASection.residueActionState
#print axioms ASection.residueActionState_positioned
#print axioms ASection.residueTotal
#print axioms ASection.residueTotal_value_back
#print axioms ASection.sphereZero_mem_CResidueZeroLocus
#print axioms ASection.CResidueZeroLocus_infinite
#print axioms pi0Functor
#print axioms pi0GrothendieckEquiv
#print axioms pi0_grothendieck
#print axioms ASection.transportLevel
#print axioms ASection.concentricity

/- THE COROLLARY LAYER (fires on the theorem's closure; until then these
show sorryAx through exactly the node and nowhere else). -/
#print axioms ASection.nontrivial_one_centre
#print axioms zeta_riemannHypothesis
