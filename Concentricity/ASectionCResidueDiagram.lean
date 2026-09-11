/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ASectionCResidueInverseImage
import Concentricity.ASectionTotalActionState
import Mathlib.CategoryTheory.Grothendieck
import Mathlib.CategoryTheory.Groupoid.Subgroupoid

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

/-- The A-section transport is the native orbit--stabilizer square's transport.
That native square is the `d = distinguishedDiskAction` specialization of the
tape-positioned family; a general Euler tape occupies the same action slot as
`d = diskExpAction (tape.lift t)` rather than multiplying onto it. -/
theorem AsectionActionTransport_eq_squareTransport
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    (A.orbitStabilizerActionSquare f).actionStateTransport A
      = A.AsectionActionTransport f := rfl

private theorem cResidue_lands
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    ∀ x : InverseImageCResidueStateWorldGroupoid A X,
      IsCResidueState A Y
        (((A.orbitStabilizerActionSquare f).actionStateTransport A).obj x.obj) := by
  intro x
  obtain ⟨n, I, g, hg⟩ := x.property
  refine ⟨n, I, g ≫ f, ?_⟩
  rw [AsectionActionTransport_eq_squareTransport]
  calc (AsectionActionTransport A (g ≫ f)).obj
        (residueActionState A (projectivePole A) n I)
      = (AsectionActionTransport A f).obj
          ((AsectionActionTransport A g).obj
            (residueActionState A (projectivePole A) n I)) :=
        congrArg (fun F => F.obj
          (residueActionState A (projectivePole A) n I))
          (AsectionActionTransport_comp A g f)
    _ = (AsectionActionTransport A f).obj x.obj :=
        congrArg (fun y => (AsectionActionTransport A f).obj y) hg

/-- The existing A-section transport, restricted to the certified residue
groupoid preimages.  Its action is the certified distinguished specialization
of the same tape-positioned family. -/
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
    show PX.ι ⋙ AsectionActionTransport A (f ≫ g) =
      (PX.ι ⋙ AsectionActionTransport A f) ⋙ AsectionActionTransport A g
    rw [AsectionActionTransport_comp, Functor.assoc]
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

/-! ## The fixed-A input/output eyes on the inverse-image groupoid -/

/-- The input to `AsectionEquivariant A` on the C-residue inverse-image
groupoid.  The input is read from the positioned face of the accepted
A-specific action graph, after restricting that graph to
`IsCResidueState A X`. -/
def AsectionCResidueEquivariantInput (A : ASection)
    (X : GreatCircle.Base) :
    InverseImageCResidueStateWorldGroupoid A X ⥤ H1 :=
  (IsCResidueState A X).ι ⋙ AsectionActionPositioned A X ⋙
    AsectionStateInput A

/-- The realized value eye on the same C-residue inverse-image groupoid. -/
def AsectionCResidueEquivariantOutput (A : ASection)
    (X : GreatCircle.Base) :
    InverseImageCResidueStateWorldGroupoid A X ⥤ H1 :=
  (IsCResidueState A X).ι ⋙ AsectionActionOutput A X

/-- On the inverse-image groupoid itself, output is input followed by the
equivariant realization of this same fixed A-section.  This is the typed
form of the in/out-A triangle used by the production residue total. -/
theorem AsectionCResidue_input_then_equivariant (A : ASection)
    (X : GreatCircle.Base) :
    AsectionCResidueEquivariantInput A X ⋙ A.AsectionEquivariant =
      AsectionCResidueEquivariantOutput A X := by
  calc
    AsectionCResidueEquivariantInput A X ⋙ A.AsectionEquivariant =
        (IsCResidueState A X).ι ⋙ AsectionActionPositioned A X ⋙
          (AsectionStateInput A ⋙ A.AsectionEquivariant) := rfl
    _ = (IsCResidueState A X).ι ⋙ AsectionActionPositioned A X ⋙
          AsectionStateOutput A :=
      congrArg
        (fun F => (IsCResidueState A X).ι ⋙
          AsectionActionPositioned A X ⋙ F)
        (AsectionState_input_then_equivariant A)
    _ = AsectionCResidueEquivariantOutput A X := rfl

/-- The natural inclusion of the C-residue orbit subgroupoid into the
complete A-section action diagram. -/
def AsectionCResidueInclusion (A : ASection) :
    AsectionCResidueDiagram A ⟶ AsectionActionDiagram A where
  app X := (IsCResidueState A X).ι
  naturality := by
    intro X Y f
    rfl


/-! ## The residue system over the A-section's base (master `def:residue-subdiagram`) -/

private theorem continuedCResidue_lands
    (A : ASection) {X Y : (continuedBase A).objs} (f : X ⟶ Y) :
    ∀ x : ContinuedCResidueFiber A X,
      IsContinuedCResidueState A Y
        ((AsectionActionTransport A ((continuedBaseForget A).map f)).obj x.obj) := by
  intro x
  obtain ⟨n, I, g, hg⟩ := x.property
  refine ⟨n, I, g ≫ f, ?_⟩
  change (AsectionActionTransport A
    ((continuedBaseForget A).map g ≫ (continuedBaseForget A).map f)).obj
    (residueActionState A (projectivePole A) n I) = _
  calc (AsectionActionTransport A
        ((continuedBaseForget A).map g ≫ (continuedBaseForget A).map f)).obj
        (residueActionState A (projectivePole A) n I)
      = (AsectionActionTransport A ((continuedBaseForget A).map f)).obj
          ((AsectionActionTransport A ((continuedBaseForget A).map g)).obj
            (residueActionState A (projectivePole A) n I)) :=
        congrArg (fun F => F.obj
          (residueActionState A (projectivePole A) n I))
          (AsectionActionTransport_comp A ((continuedBaseForget A).map g)
            ((continuedBaseForget A).map f))
    _ = (AsectionActionTransport A ((continuedBaseForget A).map f)).obj x.obj :=
        congrArg (fun y => (AsectionActionTransport A ((continuedBaseForget A).map f)).obj y) hg

/-- master (Obj)/(A): the A-specific transport along a morphism of the base,
restricted to the residue states. -/
def continuedCResidueTransport
    (A : ASection) {X Y : (continuedBase A).objs} (f : X ⟶ Y) :
    ContinuedCResidueFiber A X ⥤ ContinuedCResidueFiber A Y :=
  (IsContinuedCResidueState A Y).lift
    ((IsContinuedCResidueState A X).ι ⋙ AsectionActionTransport A f.1)
    (continuedCResidue_lands A f)

@[simp] theorem continuedCResidueTransport_obj
    (A : ASection) {X Y : (continuedBase A).objs} (f : X ⟶ Y)
    (x : ContinuedCResidueFiber A X) :
    ((continuedCResidueTransport A f).obj x).obj =
      (AsectionActionTransport A ((continuedBaseForget A).map f)).obj x.obj :=
  rfl

@[simp] theorem continuedCResidueTransport_map_hom
    (A : ASection) {X Y : (continuedBase A).objs} (f : X ⟶ Y)
    {x y : ContinuedCResidueFiber A X} (h : x ⟶ y) :
    ((continuedCResidueTransport A f).map h).hom =
      (AsectionActionTransport A ((continuedBaseForget A).map f)).map h.hom :=
  rfl

private theorem continuedCResidueTransport_id
    (A : ASection) (X : (continuedBase A).objs) :
    continuedCResidueTransport A (𝟙 X) =
      𝟭 (Grpd.of (ContinuedCResidueFiber A X)) := by
  let P := IsContinuedCResidueState A X
  let hcanonical : ∀ x : P.FullSubcategory, P (P.ι.obj x) :=
    fun x => x.property
  have hambient :
      P.ι ⋙ AsectionActionTransport A ((continuedBaseForget A).map (𝟙 X)) = P.ι := by
    change P.ι ⋙ AsectionActionTransport A (𝟙 X.1) = P.ι
    rw [AsectionActionTransport_id]
    rfl
  calc
    continuedCResidueTransport A (𝟙 X) =
        P.lift P.ι hcanonical :=
      lift_eq_of_eq P hambient (continuedCResidue_lands A (𝟙 X)) hcanonical
    _ = 𝟭 (Grpd.of (ContinuedCResidueFiber A X)) := rfl

private theorem continuedCResidueTransport_comp
    (A : ASection) {X Y Z : (continuedBase A).objs}
    (f : X ⟶ Y) (g : Y ⟶ Z) :
    continuedCResidueTransport A (f ≫ g) =
      continuedCResidueTransport A f ⋙
        continuedCResidueTransport A g := by
  let PX := IsContinuedCResidueState A X
  let PZ := IsContinuedCResidueState A Z
  let ambient :=
    (PX.ι ⋙ AsectionActionTransport A ((continuedBaseForget A).map f)) ⋙
      AsectionActionTransport A ((continuedBaseForget A).map g)
  let hdirect : ∀ x : PX.FullSubcategory, PZ (ambient.obj x) :=
    fun x => continuedCResidue_lands A g
      ((continuedCResidueTransport A f).obj x)
  have hambient :
      PX.ι ⋙ AsectionActionTransport A ((continuedBaseForget A).map (f ≫ g)) =
        ambient := by
    change PX.ι ⋙ AsectionActionTransport A
        ((continuedBaseForget A).map f ≫ (continuedBaseForget A).map g) =
      (PX.ι ⋙ AsectionActionTransport A ((continuedBaseForget A).map f)) ⋙
        AsectionActionTransport A ((continuedBaseForget A).map g)
    rw [AsectionActionTransport_comp, Functor.assoc]
  calc
    continuedCResidueTransport A (f ≫ g) =
        PZ.lift ambient hdirect :=
      lift_eq_of_eq PZ hambient
        (continuedCResidue_lands A (f ≫ g)) hdirect
    _ = continuedCResidueTransport A f ⋙
        continuedCResidueTransport A g := rfl

/-- `R_A` over the A-section's base: the residue states, transported by the
A-specific action along the morphisms of that base. -/
def continuedCResidueDiagram (A : ASection) :
    (continuedBase A).objs ⥤ Grpd where
  obj X := Grpd.of (ContinuedCResidueFiber A X)
  map f := continuedCResidueTransport A f
  map_id X := continuedCResidueTransport_id A X
  map_comp f g := continuedCResidueTransport_comp A f g

/-- `ι_A` over the A-section's base: the natural inclusion of `R_A` into
`A_A`, componentwise the identity on the residue states. -/
def continuedCResidueInclusion (A : ASection) :
    continuedCResidueDiagram A ⟶ continuedActionDiagram A where
  app X := (IsContinuedCResidueState A X).ι
  naturality := by
    intro X Y f
    rfl


end ASection
