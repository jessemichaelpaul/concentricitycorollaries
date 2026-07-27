import Concentricity.ASectionTotalActionState

noncomputable section

open CategoryTheory

namespace ASection

#check TotalActionStateWorld
#check totalMk
#check totalTransport

example (A : ASection) :
    TotalActionStateWorld A =
      CategoryTheory.Grothendieck
        ((AsectionActionDiagram A) ⋙ Grpd.forgetToCat) := rfl

example (A : ASection) (X Y : TotalActionStateWorld A) (f : X ⟶ Y) :
    X.base ⟶ Y.base :=
  f.base

example (A : ASection) (X Y : TotalActionStateWorld A) (f : X ⟶ Y) :
    ((AsectionActionCatDiagram A).map f.base).toFunctor.obj X.fiber ⟶
      Y.fiber :=
  f.fiber

#print axioms ASection.AsectionActionDiagram
#print axioms ASection.TotalActionStateWorld
#print axioms ASection.totalMk
#print axioms ASection.totalTransport
#print axioms ASection.totalTransport_base
#print axioms ASection.totalTransport_fiber

end ASection
