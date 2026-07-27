import Concentricity.ASectionCResidueInverseImage

noncomputable section

open CategoryTheory

namespace ASection

/-!
Focused kernel receipt for the framewise full inverse image
`InverseImageCResidueStateWorldGroupoid A X`.

This file audits only the object gate. It does not assert cross-frame
preservation, restrict `AsectionActionTransport`, assemble a diagram, or
totalize an inclusion.
-/

#check InverseImageCResidueStateWorldGroupoid
#check IsCResidueState

example (A : ASection) (X : GreatCircle.Base) :
    InverseImageCResidueStateWorldGroupoid A X =
      (IsCResidueState A X).FullSubcategory :=
  rfl

example (A : ASection) (X : GreatCircle.Base)
    (x : InverseImageCResidueStateWorldGroupoid A X) :
    IsCResidueState A X x.obj :=
  x.property

example (A : ASection) (X : GreatCircle.Base)
    (x : InverseImageCResidueStateWorldGroupoid A X) :
    ∃ z : ℂ,
      x.obj.positioned.back.coordinate = (z : OnePoint ℂ) ∧
        z ∈ A.CResidueZeroLocus := by
  rcases x.property with ⟨z, hz, hcoordinate⟩
  exact ⟨z, hcoordinate.symm, hz⟩

example (A : ASection) (X : GreatCircle.Base)
    (x : InverseImageCResidueStateWorldGroupoid A X) :
    x.obj.positioned =
      (coordinateTransport A (projectiveObjectFrame A X)).obj
        x.obj.input :=
  x.obj.positioned_by_action

example (A : ASection) (X : GreatCircle.Base)
    (x : InverseImageCResidueStateWorldGroupoid A X) :
    x.obj.value =
      (AsectionStateOutput A).obj x.obj.positioned :=
  x.obj.value_realized

example (A : ASection) (X : GreatCircle.Base)
    (I : SphereWorld) (z : ℂ) (hz : z ∈ A.CResidueZeroLocus) :
    InverseImageCResidueStateWorldGroupoid A X := by
  let state : AsectionActionFiber A X :=
    AsectionActionState.ofInput A X
      ((coordinateTransport A (projectiveObjectFrame A X)⁻¹).obj
        (({ world := I, coordinate := (z : OnePoint ℂ) } :
            AsectionState A) : AsectionStateWorld A))
  refine ⟨state, ?_⟩
  refine ⟨z, hz, ?_⟩
  change
    (z : OnePoint ℂ) =
      (projectiveObjectFrame A X).val
        ((projectiveObjectFrame A X)⁻¹.val (z : OnePoint ℂ))
  simp

example (A : ASection) (X : GreatCircle.Base) :
    Groupoid (InverseImageCResidueStateWorldGroupoid A X) :=
  inferInstance

example (A : ASection) (X : GreatCircle.Base)
    (x y : InverseImageCResidueStateWorldGroupoid A X)
    (f : x ⟶ y) :
    G2 :=
  f.hom.hom.val

#print axioms ASection.InverseImageCResidueStateWorldGroupoid
#print axioms ASection.IsCResidueState

end ASection
