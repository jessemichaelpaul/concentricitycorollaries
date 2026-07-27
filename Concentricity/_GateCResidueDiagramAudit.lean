import Concentricity.ASectionCResidueDiagram

noncomputable section

open CategoryTheory

#check @ASection.ActionTransportSquare.actionStateTransport
#check @ASection.ActionTransportSquare.coordinateTransport_commutes
#check @ASection.AsectionActionTransport
#check @ASection.orbitStabilizerActionSquare
#check @ASection.positionedOrbitSquare
#check @ASection.IsCResidueState
#check @ASection.InverseImageCResidueStateWorldGroupoid

#check @ObjectProperty.lift
#check @ObjectProperty.fullyFaithfulι
#check @ObjectProperty.liftCompιIso

/- The literal `d = 1` member of the pre-existing positioned family is the
native orbit--stabilizer square on the certified fibres. -/
example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    ASection.ActionTransportSquare
      (ASection.projectiveObjectFrame A X)
      (ASection.projectiveObjectFrame A Y) := by
  simpa using ASection.positionedOrbitSquare A f (1 : Moebius)

#check @ASection.AsectionCResidueTransport
#check @ASection.cResidue_preserved
#check @ASection.IsTotalCResidueState
#check @ASection.AsectionCResidueDiagram
#check @ASection.AsectionCResidueInclusion

/- The source is the separately bundled preimage groupoid, while the target
is its image in the next ambient fibre.  No fixed target-carrier membership
appears in this type. -/
example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (x : ASection.InverseImageCResidueStateWorldGroupoid A X) :
    (ASection.AsectionCResidueTransport A f).obj x =
      (ASection.AsectionActionTransport A f).obj x.obj :=
  ASection.cResidue_preserved A f x

/- The total preimage predicate reads the certified fibrewise predicate in
the object's own base fibre. -/
example (A : ASection) (X : GreatCircle.Base)
    (x : ASection.AsectionActionFiber A X) :
    ASection.IsTotalCResidueState A (ASection.totalMk A X x) ↔
      ASection.IsCResidueState A X x :=
  Iff.rfl

/- `ι_A` is literally the full-subcategory inclusion functor between the
separately bundled total preimage and the ambient Grothendieck total. -/
example (A : ASection) :
    ASection.AsectionCResidueInclusion A =
      (ASection.IsTotalCResidueState A).ι :=
  rfl

example (A : ASection) (x : ASection.AsectionCResidueDiagram A) :
    (ASection.AsectionCResidueInclusion A).obj x = x.obj :=
  rfl

example (A : ASection) :
    (ASection.AsectionCResidueInclusion A).FullyFaithful :=
  ObjectProperty.fullyFaithfulι (ASection.IsTotalCResidueState A)

#print axioms ASection.AsectionCResidueTransport
#print axioms ASection.cResidue_preserved
#print axioms ASection.IsTotalCResidueState
#print axioms ASection.AsectionCResidueInclusion
