/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ASectionCResidueInverseImage

/-!
# The C-residue orbit subgroupoid and its natural inclusion

The objects are the already-certified framewise groupoid preimages
`InverseImageCResidueStateWorldGroupoid A X`.  Their maps are the existing
categorified A-section transport, read on those groupoid preimages.  No
arrow-indexed object or replacement carrier is introduced.
-/

noncomputable section

open CategoryTheory

namespace ASection

private theorem cResidue_lands
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    ∀ x : InverseImageCResidueStateWorldGroupoid A X,
      IsCResidueState A Y ((AsectionActionTransport A f).obj x.obj) := by
  intro x
  obtain ⟨xN, hxN, g, hg⟩ := x.property
  refine ⟨xN, hxN, g ≫ f, ?_⟩
  calc (AsectionActionTransport A (g ≫ f)).obj xN
      = (AsectionActionTransport A f).obj
          ((AsectionActionTransport A g).obj xN) :=
        congrArg (fun F => F.obj xN) (AsectionActionTransport_comp A g f)
    _ = (AsectionActionTransport A f).obj x.obj :=
        congrArg (fun y => (AsectionActionTransport A f).obj y) hg

/-- The existing A-section transport, restricted to the certified residue
groupoid preimages.  The literal `d = 1` positioned square is the native
member of the already-certified all-`d` family. -/
def AsectionCResidueTransport
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    InverseImageCResidueStateWorldGroupoid A X ⥤
      InverseImageCResidueStateWorldGroupoid A Y :=
  (IsCResidueState A Y).lift
    ((IsCResidueState A X).ι ⋙ AsectionActionTransport A f)
    (cResidue_lands A f)

@[simp] theorem AsectionCResidueTransport_obj
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (x : InverseImageCResidueStateWorldGroupoid A X) :
    ((AsectionCResidueTransport A f).obj x).obj =
      (AsectionActionTransport A f).obj x.obj :=
  rfl

@[simp] theorem AsectionCResidueTransport_map_hom
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    {x y : InverseImageCResidueStateWorldGroupoid A X} (h : x ⟶ y) :
    ((AsectionCResidueTransport A f).map h).hom =
      (AsectionActionTransport A f).map h.hom :=
  rfl

private theorem lift_eq_of_eq
    {C D : Type*} [Category C] [Category D]
    (P : ObjectProperty D) {F G : C ⥤ D}
    (h : F = G) (hF : ∀ x, P (F.obj x))
    (hG : ∀ x, P (G.obj x)) :
    P.lift F hF = P.lift G hG := by
  subst G
  have hp : hF = hG := Subsingleton.elim _ _
  subst hp
  rfl

private theorem AsectionCResidueTransport_id
    (A : ASection) (X : GreatCircle.Base) :
    AsectionCResidueTransport A (𝟙 X) =
      𝟭 (Grpd.of (InverseImageCResidueStateWorldGroupoid A X)) := by
  let P := IsCResidueState A X
  let hcanonical : ∀ x : P.FullSubcategory, P (P.ι.obj x) :=
    fun x => x.property
  have hambient :
      P.ι ⋙ AsectionActionTransport A (𝟙 X) = P.ι := by
    rw [AsectionActionTransport_id]
    rfl
  calc
    AsectionCResidueTransport A (𝟙 X) =
        P.lift P.ι hcanonical :=
      lift_eq_of_eq P hambient (cResidue_lands A (𝟙 X)) hcanonical
    _ = 𝟭 (Grpd.of (InverseImageCResidueStateWorldGroupoid A X)) := rfl

private theorem AsectionCResidueTransport_comp
    (A : ASection) {X Y Z : GreatCircle.Base}
    (f : X ⟶ Y) (g : Y ⟶ Z) :
    AsectionCResidueTransport A (f ≫ g) =
      AsectionCResidueTransport A f ⋙
        AsectionCResidueTransport A g := by
  let PX := IsCResidueState A X
  let PZ := IsCResidueState A Z
  let ambient :=
    (PX.ι ⋙ AsectionActionTransport A f) ⋙
      AsectionActionTransport A g
  let hdirect : ∀ x : PX.FullSubcategory, PZ (ambient.obj x) :=
    fun x => cResidue_lands A g
      ((AsectionCResidueTransport A f).obj x)
  have hambient :
      PX.ι ⋙ AsectionActionTransport A (f ≫ g) = ambient := by
    rw [AsectionActionTransport_comp]
    rfl
  calc
    AsectionCResidueTransport A (f ≫ g) =
        PZ.lift ambient hdirect :=
      lift_eq_of_eq PZ hambient
        (cResidue_lands A (f ≫ g)) hdirect
    _ = AsectionCResidueTransport A f ⋙
        AsectionCResidueTransport A g := rfl

/-- The certified residue groupoid preimages, transported by the same
A-specific action diagram. -/
def AsectionCResidueDiagram (A : ASection) :
    GreatCircle.Base ⥤ Grpd where
  obj X := Grpd.of (InverseImageCResidueStateWorldGroupoid A X)
  map f := AsectionCResidueTransport A f
  map_id X := AsectionCResidueTransport_id A X
  map_comp f g := AsectionCResidueTransport_comp A f g

/-- The natural inclusion of the C-residue orbit subgroupoid into the
complete A-section action diagram. -/
def AsectionCResidueInclusion (A : ASection) :
    AsectionCResidueDiagram A ⟶ AsectionActionDiagram A where
  app X := (IsCResidueState A X).ι
  naturality := by
    intro X Y f
    rfl

end ASection
