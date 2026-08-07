/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ASectionCResidueInverseImage
import Concentricity.ASectionTotalActionState
import Mathlib.CategoryTheory.Grothendieck

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

/-! ## The action over the semantic input locus

Here the base arrow is the native Möbius arrow between two inputs of the
semantic inverse-image locus.  The one north disk action transports it: the
right leg moves the input and the conjugate left leg moves the positioned
coordinate.  The winding remains inside that disk action.  No equality of
the two input coordinates is asserted.
-/

/-- The north action states evaluated at one object of the semantic
C-residue input locus. -/
def IsCResidueStateOverInput (A : ASection) (u : CResidueInputWorld A) :
    ObjectProperty (AsectionActionFiber A projectiveNorth) :=
  fun x => x.input.back.coordinate = u.obj.back

instance (A : ASection) (u : CResidueInputWorld A) :
    Groupoid ((IsCResidueStateOverInput A u).FullSubcategory) :=
  inferInstanceAs
    (Groupoid
      (InducedCategory (AsectionActionFiber A projectiveNorth)
        ObjectProperty.FullSubcategory.obj))

/-- The one distinguished disk action transports a semantic input-locus
arrow.  Its right leg is the supplied input arrow; its left leg is that same
arrow conjugated by the north frame, which is `D_A`. -/
def CResidueInputActionSquare (A : ASection)
    {u v : CResidueInputWorld A} (f : u ⟶ v) :
    ActionTransportSquare
      (projectiveObjectFrame A projectiveNorth)
      (projectiveObjectFrame A projectiveNorth) where
  left := projectiveObjectFrame A projectiveNorth * f.hom.val *
    (projectiveObjectFrame A projectiveNorth)⁻¹
  right := f.hom.val
  commutes := by group

private theorem cResidueInput_lands (A : ASection)
    {u v : CResidueInputWorld A} (f : u ⟶ v) :
    ∀ x : (IsCResidueStateOverInput A u).FullSubcategory,
      IsCResidueStateOverInput A v
        (((CResidueInputActionSquare A f).actionStateTransport A).obj x.obj) := by
  intro x
  change
    (CResidueInputActionSquare A f).right.val x.obj.input.back.coordinate =
      v.obj.back
  rw [x.property]
  exact f.hom.property

/-- Restriction of the already-built action-state transport to one arrow of
the semantic C-residue input groupoid locus. -/
def AsectionCResidueInputTransport (A : ASection)
    {u v : CResidueInputWorld A} (f : u ⟶ v) :
    (IsCResidueStateOverInput A u).FullSubcategory ⥤
      (IsCResidueStateOverInput A v).FullSubcategory :=
  (IsCResidueStateOverInput A v).lift
    ((IsCResidueStateOverInput A u).ι ⋙
      (CResidueInputActionSquare A f).actionStateTransport A)
    (cResidueInput_lands A f)

private theorem CResidueInputActionSquare_id (A : ASection)
    (u : CResidueInputWorld A) :
    CResidueInputActionSquare A (𝟙 u) =
      ActionTransportSquare.id (projectiveObjectFrame A projectiveNorth) := by
  apply ActionTransportSquare.ext
  · simp only [CResidueInputActionSquare, ActionTransportSquare.id,
      ObjectProperty.FullSubcategory.id_hom,
      CategoryTheory.ActionCategory.id_val]
    group
  · simp only [CResidueInputActionSquare, ActionTransportSquare.id,
      ObjectProperty.FullSubcategory.id_hom,
      CategoryTheory.ActionCategory.id_val]

private theorem CResidueInputActionSquare_comp (A : ASection)
    {u v w : CResidueInputWorld A} (f : u ⟶ v) (g : v ⟶ w) :
    CResidueInputActionSquare A (f ≫ g) =
      (CResidueInputActionSquare A f).comp
        (CResidueInputActionSquare A g) := by
  apply ActionTransportSquare.ext
  · simp only [CResidueInputActionSquare, ActionTransportSquare.comp,
      ObjectProperty.FullSubcategory.comp_hom,
      CategoryTheory.ActionCategory.comp_val]
    group
  · simp only [CResidueInputActionSquare, ActionTransportSquare.comp,
      ObjectProperty.FullSubcategory.comp_hom,
      CategoryTheory.ActionCategory.comp_val]

private theorem input_lift_eq_of_eq
    {C D : Type*} [Category C] [Category D]
    (P : ObjectProperty D) {F G : C ⥤ D}
    (h : F = G) (hF : ∀ x, P (F.obj x))
    (hG : ∀ x, P (G.obj x)) :
    P.lift F hF = P.lift G hG := by
  subst G
  have hp : hF = hG := Subsingleton.elim _ _
  subst hp
  rfl

private theorem AsectionCResidueInputTransport_id (A : ASection)
    (u : CResidueInputWorld A) :
    AsectionCResidueInputTransport A (𝟙 u) =
      𝟭 ((IsCResidueStateOverInput A u).FullSubcategory) := by
  let P := IsCResidueStateOverInput A u
  let hcanonical : ∀ x : P.FullSubcategory, P (P.ι.obj x) :=
    fun x => x.property
  have hambient :
      P.ι ⋙ (CResidueInputActionSquare A (𝟙 u)).actionStateTransport A =
        P.ι := by
    rw [CResidueInputActionSquare_id,
      ActionTransportSquare.actionStateTransport_id]
    rfl
  calc
    AsectionCResidueInputTransport A (𝟙 u) =
        P.lift P.ι hcanonical :=
      input_lift_eq_of_eq P hambient
        (cResidueInput_lands A (𝟙 u)) hcanonical
    _ = 𝟭 ((IsCResidueStateOverInput A u).FullSubcategory) := rfl

private theorem AsectionCResidueInputTransport_comp (A : ASection)
    {u v w : CResidueInputWorld A} (f : u ⟶ v) (g : v ⟶ w) :
    AsectionCResidueInputTransport A (f ≫ g) =
      AsectionCResidueInputTransport A f ⋙
        AsectionCResidueInputTransport A g := by
  let Pu := IsCResidueStateOverInput A u
  let Pw := IsCResidueStateOverInput A w
  let ambient :=
    (Pu.ι ⋙ (CResidueInputActionSquare A f).actionStateTransport A) ⋙
      (CResidueInputActionSquare A g).actionStateTransport A
  let hdirect : ∀ x : Pu.FullSubcategory, Pw (ambient.obj x) :=
    fun x => cResidueInput_lands A g
      ((AsectionCResidueInputTransport A f).obj x)
  have hambient :
      Pu.ι ⋙ (CResidueInputActionSquare A (f ≫ g)).actionStateTransport A =
        ambient := by
    rw [CResidueInputActionSquare_comp,
      ActionTransportSquare.actionStateTransport_comp]
    rfl
  calc
    AsectionCResidueInputTransport A (f ≫ g) =
        Pw.lift ambient hdirect :=
      input_lift_eq_of_eq Pw hambient
        (cResidueInput_lands A (f ≫ g)) hdirect
    _ = AsectionCResidueInputTransport A f ⋙
        AsectionCResidueInputTransport A g := rfl

/-- The C-residue action diagram on its actual semantic input-groupoid base. -/
def AsectionCResidueInputDiagram (A : ASection) :
    CResidueInputWorld A ⥤ Grpd where
  obj u := Grpd.of ((IsCResidueStateOverInput A u).FullSubcategory)
  map f := AsectionCResidueInputTransport A f
  map_id u := AsectionCResidueInputTransport_id A u
  map_comp f g := AsectionCResidueInputTransport_comp A f g

/-- After the semantic base arrow has moved the input, the existing `G₂`
direction action supplies the remaining morphism in the target fibre. -/
theorem CResidueInputFiberHom (A : ASection)
    {u v : CResidueInputWorld A} (f : u ⟶ v)
    (x : (IsCResidueStateOverInput A u).FullSubcategory)
    (y : (IsCResidueStateOverInput A v).FullSubcategory) :
    Nonempty ((AsectionCResidueInputTransport A f).obj x ⟶ y) := by
  let tx := ((AsectionCResidueInputTransport A f).obj x).obj
  have hcoordinate : tx.input.back.coordinate = y.obj.input.back.coordinate :=
    ((AsectionCResidueInputTransport A f).obj x).property.trans y.property.symm
  have key : ∀ s t : AsectionState A, s.coordinate = t.coordinate →
      ∃ g : G2, g • s = t := by
    rintro ⟨sw, sc⟩ ⟨tw, tc⟩ hc
    obtain ⟨g, hg⟩ :=
      G2.exists_smul_eq_of_mem_unitImaginarySphere sw.2 tw.2
    refine ⟨g, ?_⟩
    simp only [HSMul.hSMul, SMul.smul, AsectionState.mk.injEq]
    exact ⟨Subtype.ext hg, hc⟩
  obtain ⟨g₂, hstate⟩ := key tx.input.back y.obj.input.back hcoordinate
  exact ⟨ObjectProperty.homMk
    (InducedCategory.homMk
      (show tx.input ⟶ y.obj.input from ⟨g₂, hstate⟩))⟩

/-- The Grothendieck total of the C-residue diagram over its semantic input
groupoid locus. -/
abbrev CResidueInputTotalCategory (A : ASection) : Type :=
  Grothendieck (AsectionCResidueInputDiagram A ⋙ Grpd.forgetToCat)

/-- Transitivity of the semantic C-residue total: first move between the
two arbitrary input-locus objects, then use `G₂` inside the target fibre. -/
theorem CResidueInputTotal_transitive (A : ASection) :
    ∀ P Q : CResidueInputTotalCategory A, Nonempty (P ⟶ Q) := by
  intro P Q
  let f : P.base ⟶ Q.base := CResidueInputHom A P.base Q.base
  obtain ⟨φ⟩ := CResidueInputFiberHom A f P.fiber Q.fiber
  exact ⟨⟨f, φ⟩⟩

/-- The semantic input-locus base object carried by the certified `n`-th
residue action state. -/
def residueInputObject (A : ASection) (n : ℕ) (I : SphereWorld) :
    CResidueInputWorld A := by
  let x := residueActionState A projectiveNorth n I
  refine ⟨(x.input.back.coordinate : OnePoint ℂ), ?_⟩
  refine ⟨A.sphereZero n, A.sphereZero_mem_CResidueZeroLocus n, ?_⟩
  change A.distinguishedDiskAction.val x.input.back.coordinate =
    (A.sphereZero n : OnePoint ℂ)
  have hgraph := congrArg
    (fun s : AsectionStateWorld A => s.back.coordinate)
    x.positioned_by_action
  simp only [coordinateTransport_obj_coordinate] at hgraph
  have hframe : projectiveObjectFrame A projectiveNorth =
      A.distinguishedDiskAction := projectiveObjectFrame_north A
  have hframeAt := congrArg
    (fun m : Moebius => m.val x.input.back.coordinate) hframe
  calc
    A.distinguishedDiskAction.val x.input.back.coordinate =
        (projectiveObjectFrame A projectiveNorth).val
          x.input.back.coordinate := hframeAt.symm
    _ = (A.sphereZero n : OnePoint ℂ) := by
      simpa only [x, residueActionState_positioned, residueState,
        CategoryTheory.ActionCategory.coe_back] using
        hgraph.symm

/-- The certified residue action state in the fibre over its own semantic
input-locus object. -/
def residueInputFiber (A : ASection) (n : ℕ) (I : SphereWorld) :
    (IsCResidueStateOverInput A (residueInputObject A n I)).FullSubcategory :=
  ⟨residueActionState A projectiveNorth n I, by
    simp [IsCResidueStateOverInput, residueInputObject]⟩

/-- The certified `n`-th representative as an object of the actual semantic
C-residue Grothendieck total. -/
def residueInputTotalObject (A : ASection) (n : ℕ) (I : SphereWorld) :
    CResidueInputTotalCategory A :=
  ⟨residueInputObject A n I, residueInputFiber A n I⟩

/-- The real coordinate carried inside a semantic C-residue transport state,
read from its positioned coordinate.  Infinity is irrelevant for certified
residue representatives, whose positioned coordinates are finite. -/
def residueInputTotalTransportRead (A : ASection)
    (P : CResidueInputTotalCategory A) : ℝ :=
  OnePoint.rec 0 Complex.re P.fiber.obj.positioned.back.coordinate

/-- Reading the positioned coordinate carried by a certified transport
representative yields the real coordinate of its residue sphere. -/
theorem residueInputTotalTransportRead_eq_sphereZero_re
    (A : ASection) (n : ℕ) (I : SphereWorld) :
    A.residueInputTotalTransportRead (A.residueInputTotalObject n I) =
      (A.sphereZero n).re := by
  simp [residueInputTotalTransportRead, residueInputTotalObject,
    residueInputFiber, residueActionState_positioned, residueState]
  rfl

/-- The real level is the real coordinate carried inside the certified
transport-residue representative at `baseWorld`. -/
def transportLevel (A : ASection) (n : ℕ) : ℝ :=
  A.residueInputTotalTransportRead
    (A.residueInputTotalObject n baseWorld)

/-- A certified transport representative carries exactly the project's real
transport level.  This is a theorem-level computation through its positioned
state. -/
@[simp] theorem residueInputTotalTransportRead_certified
    (A : ASection) (n : ℕ) (I : SphereWorld) :
    A.residueInputTotalTransportRead (A.residueInputTotalObject n I) =
      A.transportLevel n := by
  rw [A.residueInputTotalTransportRead_eq_sphereZero_re,
    transportLevel,
    A.residueInputTotalTransportRead_eq_sphereZero_re]

/-- The transport-carried level of the certified representative is the real
coordinate of its residue sphere. -/
theorem transportLevel_eq_sphereZero_re (A : ASection) (n : ℕ) :
    A.transportLevel n = (A.sphereZero n).re := by
  rw [transportLevel,
    A.residueInputTotalTransportRead_eq_sphereZero_re]

/-- The A-section transport **is** the positioned orbit square's transport, at
the native `d = 1` member of the all-`d` family.  The fixed `0`-to-`N` tape
lives in that same family at `d = diskExpAction (tape.lift t)`
\(`canonicalAsectionPresentation_euler_toNorth`\), so this equation is the link
between the inverse-image construction and the tape: one family, two
multipliers.  It holds definitionally; naming it keeps the link findable from
the residue side. -/
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
  obtain ⟨xN, hxN, g, hg⟩ := x.property
  refine ⟨xN, hxN, g ≫ f, ?_⟩
  rw [AsectionActionTransport_eq_squareTransport]
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
