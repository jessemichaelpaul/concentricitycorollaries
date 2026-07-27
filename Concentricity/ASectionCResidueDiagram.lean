/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ASectionCResidueInverseImage

/-!
# The C-residue subdiagram

The already-certified framewise inverse images of the semantic C-residue
locus are restricted along the whole A-section action. The resulting
diagram and its natural inclusion inherit their maps and coherence from the
ambient action through `ObjectProperty.lift`.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-- The whole A-section action preserves the certified semantic residue
inverse image at every projective-base arrow. -/
theorem cResidue_preserved
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    {x : AsectionActionFiber A X} (hx : IsCResidueState A X x) :
    IsCResidueState A Y ((AsectionActionTransport A f).obj x) := by
  let squareAtOne := positionedOrbitSquare A f (1 : Moebius)
  let xN := Classical.choose hx
  have hxN := (Classical.choose_spec hx).1
  let g := Classical.choose (Classical.choose_spec hx).2
  have hg := Classical.choose_spec (Classical.choose_spec hx).2
  refine ⟨xN, hxN, g ≫ f, ?_⟩
  rw [AsectionActionTransport_comp]
  change
    (AsectionActionTransport A f).obj
        ((AsectionActionTransport A g).obj xN) =
      (AsectionActionTransport A f).obj x
  exact congrArg (fun y => (AsectionActionTransport A f).obj y) hg

/-- The literal restriction of the whole A-section transport to its
framewise C-residue inverse images. -/
def AsectionCResidueTransport
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    InverseImageCResidueStateWorldGroupoid A X ⥤
      InverseImageCResidueStateWorldGroupoid A Y :=
  (IsCResidueState A Y).lift
    ((IsCResidueState A X).ι ⋙ AsectionActionTransport A f)
    (fun x => cResidue_preserved A f x.property)

/-- The C-residue inverse images, functorially transported by the same
distinguished A-section action. -/
def AsectionCResidueDiagram (A : ASection) :
    GreatCircle.Base ⥤ Grpd where
  obj X := Grpd.of (InverseImageCResidueStateWorldGroupoid A X)
  map f := AsectionCResidueTransport A f
  map_id X := by
    apply CategoryTheory.Functor.ext
    · intro x
      apply ObjectProperty.FullSubcategory.ext
      change (AsectionActionTransport A (𝟙 X)).obj x.obj = x.obj
      rw [AsectionActionTransport_id]
      rfl
    · intro x y f
      apply ObjectProperty.hom_ext
      change (AsectionActionTransport A (𝟙 X)).map f.hom = f.hom
      rw [AsectionActionTransport_id]
      rfl
  map_comp f g := by
    apply CategoryTheory.Functor.ext
    · intro x
      apply ObjectProperty.FullSubcategory.ext
      change
        (AsectionActionTransport A (f ≫ g)).obj x.obj =
          (AsectionActionTransport A g).obj
            ((AsectionActionTransport A f).obj x.obj)
      rw [AsectionActionTransport_comp]
      rfl
    · intro x y h
      apply ObjectProperty.hom_ext
      change
        (AsectionActionTransport A (f ≫ g)).map h.hom =
          (AsectionActionTransport A g).map
            ((AsectionActionTransport A f).map h.hom)
      rw [AsectionActionTransport_comp]
      rfl

/-- The natural inclusion of the C-residue diagram into the complete
A-section action diagram. Its naturality square is `liftCompιIso`. -/
def AsectionCResidueInclusion (A : ASection) :
    AsectionCResidueDiagram A ⟶ AsectionActionDiagram A where
  app X := (IsCResidueState A X).ι
  naturality := by
    intro X Y f
    rfl

end ASection
