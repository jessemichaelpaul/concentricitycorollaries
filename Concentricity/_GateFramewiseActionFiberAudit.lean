import Concentricity.ASectionActionDiagram

noncomputable section

open CategoryTheory

namespace ASection

/-!
Focused kernel receipt for the exact framewise value `F_A(X)`.

This audits the already-built value of `AsectionActionDiagram`; it does not
construct another functor, carrier, or wrapper.
-/

#check AsectionActionFiber
#check AsectionActionState.ofCoordinate
#check AsectionActionInput
#check AsectionActionPositioned
#check AsectionActionOutput

example (A : ASection) (X : GreatCircle.Base) :
    (AsectionActionDiagram A).obj X =
      Grpd.of
        (AsectionActionStateWorld A
          (projectiveObjectFrame A X)) :=
  rfl

example (A : ASection) (X : GreatCircle.Base) :
    projectiveObjectFrame A X =
      GreatCircle.cayleyProjective
          (GreatCircle.orbitRep
            (CategoryTheory.ActionCategory.back X)) *
        A.distinguishedDiskAction :=
  rfl

example (A : ASection) (X : GreatCircle.Base)
    (I : SphereWorld) (z : OnePoint ℂ) :
    (AsectionActionDiagram A).obj X :=
  AsectionActionState.ofCoordinate A X I z

example (A : ASection) (X : GreatCircle.Base)
    (x : AsectionActionFiber A X) :
    x.positioned =
      (coordinateTransport A (projectiveObjectFrame A X)).obj x.input :=
  x.positioned_by_action

example (A : ASection) (X : GreatCircle.Base)
    (x : AsectionActionFiber A X) :
    x.value = (AsectionStateOutput A).obj x.positioned :=
  x.value_realized

example (A : ASection) (X : GreatCircle.Base) :
    Groupoid
      (AsectionActionStateWorld A
        (projectiveObjectFrame A X)) :=
  inferInstance

example (A : ASection) (X : GreatCircle.Base)
    (x y : AsectionActionFiber A X) (f : x ⟶ y) :
    G2 :=
  f.hom.val

example (A : ASection) (X : GreatCircle.Base) :
    AsectionActionOutput A X =
      AsectionActionPositioned A X ⋙ AsectionStateOutput A :=
  AsectionActionOutput_eq A X

#print axioms ASection.projectiveObjectFrame
#print axioms ASection.AsectionActionState.ofCoordinate
#print axioms ASection.AsectionActionState.positioned_by_action
#print axioms ASection.AsectionActionState.value_realized
#print axioms ASection.AsectionActionInput
#print axioms ASection.AsectionActionPositioned
#print axioms ASection.AsectionActionOutput
#print axioms ASection.AsectionActionOutput_eq

end ASection
