import Concentricity.ASectionCResidueDiagram
import Concentricity.ASectionTotalActionState

noncomputable section

open CategoryTheory

#check @ASection.AsectionActionTransport
#check @ASection.positionedOrbitSquare
#check @ObjectProperty.inverseImage
#check @ObjectProperty.lift
#check @ObjectProperty.fullyFaithfulι
#check @ObjectProperty.liftCompιIso

/- The literal `d = 1` member is the native square underlying `F_A(f)`. -/
example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    ASection.ActionTransportSquare
      (ASection.projectiveObjectFrame A X)
      (ASection.projectiveObjectFrame A Y) := by
  simpa using ASection.positionedOrbitSquare A f (1 : Moebius)

/- The ambient objects and arrow are Jesse's exact action functor. -/
example (A : ASection) (X : GreatCircle.Base) :
    (ASection.AsectionActionDiagram A).obj X =
      ASection.AsectionActionFiber A X :=
  rfl

example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    (ASection.AsectionActionDiagram A).map f =
      ASection.AsectionActionTransport A f :=
  rfl

/- The source is literally the full groupoid preimage of the named target
residue groupoid under `F_A(f)`. -/
example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    ASection.AsectionCResiduePreimage A f =
      ((ASection.IsCResidueState A Y).inverseImage
        (ASection.AsectionActionTransport A f)).FullSubcategory :=
  rfl

example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (x : ASection.AsectionCResiduePreimage A f) :
    ASection.IsCResidueState A Y
      ((ASection.AsectionActionTransport A f).obj x.obj) :=
  x.property

/- Its arrows are exactly the arrows inherited from the ambient source
fibre. -/
example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (x y : ASection.AsectionCResiduePreimage A f)
    (h : x.obj ⟶ y.obj) :
    x ⟶ y :=
  ObjectProperty.homMk h

/- A genuine semantic residue state inhabits the groupoid preimage.
Transport it backward along the groupoid inverse of `f`; applying `F_A(f)`
again returns the named target residue state by the already-certified
identity and composition laws. -/
example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (n : ℕ) (I : SphereWorld) :
    ASection.AsectionCResiduePreimage A f := by
  let y :
      ASection.InverseImageCResidueStateWorldGroupoid A Y := by
    refine ⟨ASection.residueActionState A Y n I, ?_⟩
    refine
      ⟨A.sphereZero n,
        A.sphereZero_mem_CResidueZeroLocus n, ?_⟩
    change
      (A.sphereZero n : OnePoint ℂ) =
        (ASection.residueActionState A Y n I).positioned.back.coordinate
    rw [ASection.residueActionState_positioned]
    rfl
  refine
    ⟨(ASection.AsectionActionTransport A
        (CategoryTheory.Groupoid.inv f)).obj y.obj, ?_⟩
  have htransport :
      (ASection.AsectionActionTransport A f).obj
          ((ASection.AsectionActionTransport A
            (CategoryTheory.Groupoid.inv f)).obj y.obj) =
        y.obj := by
    have hinv :
        CategoryTheory.Groupoid.inv f ≫ f = 𝟙 Y := by
      exact CategoryTheory.Groupoid.inv_comp f
    have hfunctor :
        ASection.AsectionActionTransport A
            (CategoryTheory.Groupoid.inv f ≫ f) =
          𝟭 (ASection.AsectionActionFiber A Y) := by
      calc
        ASection.AsectionActionTransport A
            (CategoryTheory.Groupoid.inv f ≫ f) =
            ASection.AsectionActionTransport A (𝟙 Y) :=
          congrArg (ASection.AsectionActionTransport A) hinv
        _ = 𝟭 (ASection.AsectionActionFiber A Y) :=
          ASection.AsectionActionTransport_id A Y
    calc
      _ = (ASection.AsectionActionTransport A
            (CategoryTheory.Groupoid.inv f ≫ f)).obj y.obj := by
          exact congrArg (fun F => F.obj y.obj)
            (ASection.AsectionActionTransport_comp A
              (CategoryTheory.Groupoid.inv f) f).symm
      _ = y.obj := by
          exact CategoryTheory.Functor.congr_obj hfunctor y.obj
  change
    ASection.IsCResidueState A Y
      ((ASection.AsectionActionTransport A f).obj
        ((ASection.AsectionActionTransport A
          (CategoryTheory.Groupoid.inv f)).obj y.obj))
  rw [htransport]
  exact y.property

/- The top map is literally the Mathlib lift of the existing action map. -/
example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    ASection.AsectionCResidueTransport A f =
      (ASection.IsCResidueState A Y).lift
        (((ASection.IsCResidueState A Y).inverseImage
            (ASection.AsectionActionTransport A f)).ι ⋙
          ASection.AsectionActionTransport A f)
        (fun x => x.property) :=
  rfl

/- Both vertical components are the exact named inclusions. -/
example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    ASection.AsectionCResidueInclusion A f =
      ((ASection.IsCResidueState A Y).inverseImage
        (ASection.AsectionActionTransport A f)).ι :=
  rfl

example (A : ASection) (Y : GreatCircle.Base) :
    (ASection.IsCResidueState A Y).ι.FullyFaithful :=
  ObjectProperty.fullyFaithfulι (ASection.IsCResidueState A Y)

/- The whole preimage square commutes definitionally. -/
example (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    ASection.AsectionCResidueTransport A f ⋙
        (ASection.IsCResidueState A Y).ι ≅
      ASection.AsectionCResidueInclusion A f ⋙
        ASection.AsectionActionTransport A f :=
  ASection.AsectionCResidueInclusionSquare A f

#print axioms ASection.AsectionCResiduePreimage
#print axioms ASection.AsectionCResidueTransport
#print axioms ASection.AsectionCResidueInclusion
#print axioms ASection.AsectionCResidueInclusionSquare
