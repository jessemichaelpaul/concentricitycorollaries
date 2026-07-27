import Concentricity.ASectionCResidueDiagram

noncomputable section

open CategoryTheory

/- The requested outer declaration is the first certificate consumer. -/
example (A : ASection) :
    ASection.AsectionCResidueDiagram A ⟶
      ASection.AsectionActionDiagram A :=
  ASection.AsectionCResidueInclusion A

#check @ASection.ActionTransportSquare.actionStateTransport
#check @ASection.ActionTransportSquare.coordinateTransport_commutes
#check @ASection.AsectionActionTransport
#check @ASection.orbitStabilizerActionSquare
#check @ASection.positionedOrbitSquare
#check @ASection.IsNorthCResidueState
#check @ASection.IsCResidueState
#check @ObjectProperty.lift
#check @ObjectProperty.liftCompιIso
#check @ObjectProperty.fullyFaithfulι

/- The literal `d = 1` member is the native square underlying `F_A(f)`. -/
example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    ASection.ActionTransportSquare
      (ASection.projectiveObjectFrame A X)
      (ASection.projectiveObjectFrame A Y) := by
  simpa only [mul_one] using
    ASection.positionedOrbitSquare A f (1 : Moebius)

example (A : ASection) (X : GreatCircle.Base) :
    (ASection.AsectionActionDiagram A).obj X =
      ASection.AsectionActionFiber A X :=
  rfl

example (A : ASection) (Y : GreatCircle.Base) :
    (ASection.AsectionActionDiagram A).obj Y =
      ASection.AsectionActionFiber A Y :=
  rfl

example (A : ASection) (X : GreatCircle.Base) :
    (ASection.AsectionCResidueDiagram A).obj X =
      Grpd.of
        (ASection.InverseImageCResidueStateWorldGroupoid A X) :=
  rfl

example (A : ASection) (Y : GreatCircle.Base) :
    (ASection.AsectionCResidueDiagram A).obj Y =
      Grpd.of
        (ASection.InverseImageCResidueStateWorldGroupoid A Y) :=
  rfl

example (A : ASection) (X : GreatCircle.Base)
    (x : ASection.InverseImageCResidueStateWorldGroupoid A X) :
    ∃ xN : ASection.AsectionActionFiber A ASection.projectiveNorth,
      ASection.IsNorthCResidueState A xN ∧
        ∃ g : ASection.projectiveNorth ⟶ X,
          (ASection.AsectionActionTransport A g).obj xN = x.obj :=
  x.property

example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    (ASection.AsectionActionDiagram A).map f =
      ASection.AsectionActionTransport A f :=
  rfl

example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    (ASection.AsectionCResidueDiagram A).map f =
      ASection.AsectionCResidueTransport A f :=
  rfl

example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (x : ASection.InverseImageCResidueStateWorldGroupoid A X) :
    ASection.IsCResidueState A Y
      ((ASection.AsectionActionTransport A f).obj x.obj) :=
  ((ASection.AsectionCResidueTransport A f).obj x).property

example (A : ASection) (X : GreatCircle.Base) :
    (ASection.AsectionCResidueInclusion A).app X =
      (ASection.IsCResidueState A X).ι :=
  rfl

example (A : ASection) (Y : GreatCircle.Base) :
    (ASection.AsectionCResidueInclusion A).app Y =
      (ASection.IsCResidueState A Y).ι :=
  rfl

example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    ASection.AsectionCResidueTransport A f ⋙
        (ASection.IsCResidueState A Y).ι ≅
      (ASection.IsCResidueState A X).ι ⋙
        ASection.AsectionActionTransport A f :=
  (ASection.IsCResidueState A Y).liftCompιIso
    ((ASection.IsCResidueState A X).ι ⋙
      ASection.AsectionActionTransport A f)
    (fun x => ((ASection.AsectionCResidueTransport A f).obj x).property)

example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    (ASection.AsectionCResidueDiagram A).map f ⋙
        (ASection.AsectionCResidueInclusion A).app Y =
      (ASection.AsectionCResidueInclusion A).app X ⋙
        (ASection.AsectionActionDiagram A).map f :=
  (ASection.AsectionCResidueInclusion A).naturality f

example (A : ASection) (X : GreatCircle.Base) :
    ((ASection.AsectionCResidueInclusion A).app X).FullyFaithful :=
  ObjectProperty.fullyFaithfulι (ASection.IsCResidueState A X)

#print axioms ASection.AsectionCResidueTransport
#print axioms ASection.AsectionCResidueDiagram
#print axioms ASection.AsectionCResidueInclusion
#print axioms ASection.IsNorthCResidueState
#print axioms ASection.IsCResidueState
