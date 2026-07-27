/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.CayleyDictionary
import Concentricity.ProjectiveTransport

/-!
# The A-section functor on the projective base

The distinguished Euler--Weierstrass action determined by `A` is extended over
every object and arrow of `GreatCircle.Base` by the full orbit--stabilizer
factorization.  The exported `sectionFunctor A` is this A-defined functor.
Its total is deliberately not formed until this direct functor between the two
authored geometric groupoids is complete.  No separate analytic interface or
colimit readout is introduced here.
-/

noncomputable section

open CategoryTheory

namespace GreatCircle

/-- A finite point of the locked compactified real circle, regarded as an
object of its action groupoid. -/
def pointObj (x : GreatCircle.Point) : GreatCircle.Base := x

/-- A projective transformation carrying the finite point `x` to the shared
compactified witness `N`. -/
def toNGL (x : ℝ) : GL (Fin 2) ℝ :=
  Matrix.GeneralLinearGroup.mkOfDetNeZero !![0, 1; 1, -x] (by
    rw [Matrix.det_fin_two_of]
    norm_num)

@[simp] theorem toNGL_val (x : ℝ) :
    (toNGL x).val = !![0, 1; 1, -x] := rfl

theorem toNGL_smul (x : ℝ) :
    toNGL x • (x : GreatCircle.Point) = OnePoint.infty := by
  rw [OnePoint.smul_some_eq_ite]
  simp [toNGL_val]

/-- The genuine base leg from the finite footpoint `x` to the one shared
witness `N`. -/
def toNHom (x : ℝ) :
    pointObj (x : GreatCircle.Point) ⟶
      pointObj (OnePoint.infty : GreatCircle.Point) :=
  ⟨Matrix.ProjGenLinGroup.mk (toNGL x), by
    change Matrix.ProjGenLinGroup.mk (toNGL x) • (x : GreatCircle.Point) =
      (OnePoint.infty : GreatCircle.Point)
    rw [GreatCircle.mk_smul]
    exact toNGL_smul x⟩

/-- A canonical projective representative carrying the shared witness `N`
to a finite point of the compactified real circle. -/
def orbitGL (x : ℝ) : GL (Fin 2) ℝ :=
  Matrix.GeneralLinearGroup.mkOfDetNeZero !![x, -1; 1, 0] (by
    rw [Matrix.det_fin_two_of]
    norm_num)

@[simp] theorem orbitGL_val (x : ℝ) :
    (orbitGL x).val = !![x, -1; 1, 0] := rfl

theorem orbitGL_smul_infty (x : ℝ) :
    orbitGL x • (OnePoint.infty : GreatCircle.Point) = (x : GreatCircle.Point) := by
  rw [OnePoint.smul_infty_eq_ite]
  simp [orbitGL_val]

/-- The chosen orbit representative `N → b`, including the identity
representative at `N` itself. -/
def orbitRep : GreatCircle.Point → GreatCircle.Aut :=
  OnePoint.rec 1 fun x => Matrix.ProjGenLinGroup.mk (orbitGL x)

@[simp] theorem orbitRep_infty :
    orbitRep (OnePoint.infty : GreatCircle.Point) = 1 := rfl

@[simp] theorem orbitRep_coe (x : ℝ) :
    orbitRep (x : GreatCircle.Point) =
      Matrix.ProjGenLinGroup.mk (orbitGL x) := rfl

theorem orbitRep_spec (b : GreatCircle.Point) :
    orbitRep b • (OnePoint.infty : GreatCircle.Point) = b := by
  induction b using OnePoint.rec with
  | infty => simp
  | coe x =>
      rw [orbitRep_coe, GreatCircle.mk_smul]
      exact orbitGL_smul_infty x

/-- The base stabilizer at the one shared witness. -/
abbrev NorthStabilizer :=
  MulAction.stabilizer GreatCircle.Aut
    (OnePoint.infty : GreatCircle.Point)

/-- The residual stabilizer element of a base arrow after removing its two
canonical orbit transports. -/
def stabilizerPart {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    NorthStabilizer :=
  ⟨(orbitRep (CategoryTheory.ActionCategory.back Y))⁻¹ * f.val *
      orbitRep (CategoryTheory.ActionCategory.back X), by
    have hf : (show GreatCircle.Aut from f.val) •
        CategoryTheory.ActionCategory.back X =
        CategoryTheory.ActionCategory.back Y := by
      have hf' := f.property
      change (show GreatCircle.Aut from f.val) •
        CategoryTheory.ActionCategory.back X =
        CategoryTheory.ActionCategory.back Y at hf'
      exact hf'
    change ((orbitRep (CategoryTheory.ActionCategory.back Y))⁻¹ * f.val *
      orbitRep (CategoryTheory.ActionCategory.back X)) •
      (OnePoint.infty : GreatCircle.Point) = OnePoint.infty
    rw [mul_smul, mul_smul, orbitRep_spec, hf]
    apply (inv_smul_eq_iff).2
    exact (orbitRep_spec (CategoryTheory.ActionCategory.back Y)).symm⟩

/-- Orbit–stabilizer factorization of every arrow of the locked base. -/
theorem orbit_stabilizer_factor {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    f.val = orbitRep (CategoryTheory.ActionCategory.back Y) *
      (stabilizerPart f).1 *
      (orbitRep (CategoryTheory.ActionCategory.back X))⁻¹ := by
  change f.val = orbitRep (CategoryTheory.ActionCategory.back Y) *
    ((orbitRep (CategoryTheory.ActionCategory.back Y))⁻¹ * f.val *
      orbitRep (CategoryTheory.ActionCategory.back X)) *
    (orbitRep (CategoryTheory.ActionCategory.back X))⁻¹
  group

/-- The residual north-stabilizer factor is uniquely forced by the fixed
orbit representatives.  This is the uniqueness half of the horizontal
orbit--stabilizer factorization used by every framed action square. -/
theorem stabilizerPart_unique {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (h : GreatCircle.NorthStabilizer)
    (hf : f.val =
      GreatCircle.orbitRep (CategoryTheory.ActionCategory.back Y) * h.1 *
        (GreatCircle.orbitRep
          (CategoryTheory.ActionCategory.back X))⁻¹) :
    h = GreatCircle.stabilizerPart f := by
  apply Subtype.ext
  change h.1 =
    (GreatCircle.orbitRep
      (CategoryTheory.ActionCategory.back Y))⁻¹ *
      f.val *
        GreatCircle.orbitRep
          (CategoryTheory.ActionCategory.back X)
  rw [hf]
  group

/-- The residual north-stabilizer element of an identity arrow is the
identity. -/
@[simp] theorem stabilizerPart_id (X : GreatCircle.Base) :
    stabilizerPart (𝟙 X) = 1 := by
  apply Subtype.ext
  change (orbitRep (CategoryTheory.ActionCategory.back X))⁻¹ * 1 *
    orbitRep (CategoryTheory.ActionCategory.back X) = 1
  group

/-- Residual north-stabilizer elements compose in the order dictated by the
action-category convention `(f ≫ g).val = g.val * f.val`. -/
theorem stabilizerPart_comp {X Y Z : GreatCircle.Base}
    (f : X ⟶ Y) (g : Y ⟶ Z) :
    stabilizerPart (f ≫ g) = stabilizerPart g * stabilizerPart f := by
  apply Subtype.ext
  change (orbitRep (CategoryTheory.ActionCategory.back Z))⁻¹ *
      ((show GreatCircle.Aut from g.val) * (show GreatCircle.Aut from f.val)) *
        orbitRep (CategoryTheory.ActionCategory.back X) =
    ((orbitRep (CategoryTheory.ActionCategory.back Z))⁻¹ *
      (show GreatCircle.Aut from g.val) *
        orbitRep (CategoryTheory.ActionCategory.back Y)) *
      ((orbitRep (CategoryTheory.ActionCategory.back Y))⁻¹ *
        (show GreatCircle.Aut from f.val) *
          orbitRep (CategoryTheory.ActionCategory.back X))
  group

end GreatCircle

namespace ASection

/-- The distinguished projective action in every slice world simultaneously.
The world is retained; the arrow's own Cayley/Möbius element conjugates the
Möbius leg. -/
def distinguishedWorldAction (m : Moebius) : SphereWorld ⥤ SphereWorld where
  obj I := I
  map {I J} f := ⟨f.rot, f.rot_eq, m * f.mob * m⁻¹⟩
  map_id I := by
    apply SphereHom.ext
    · rfl
    · change m * 1 * m⁻¹ = 1
      group
  map_comp f g := by
    apply SphereHom.ext
    · rfl
    · change m * (g.mob * f.mob) * m⁻¹ =
        (m * g.mob * m⁻¹) * (m * f.mob * m⁻¹)
      group

theorem distinguishedWorldAction_one :
    distinguishedWorldAction 1 = Functor.id SphereWorld := by
  refine CategoryTheory.Functor.ext (fun I => rfl) fun I J f => ?_
  simp only [Functor.id_map]
  apply SphereHom.ext
  · rfl
  · change 1 * f.mob * 1⁻¹ = f.mob
    group

theorem distinguishedWorldAction_comp (m n : Moebius) :
    distinguishedWorldAction m ⋙ distinguishedWorldAction n =
      distinguishedWorldAction (n * m) := by
  refine CategoryTheory.Functor.ext (fun I => rfl) fun I J f => ?_
  simp only [Functor.comp_map]
  apply SphereHom.ext
  · rfl
  · change n * (m * f.mob * m⁻¹) * n⁻¹ =
        (n * m) * f.mob * (n * m)⁻¹
    group

/-- A's own distinguished C1/C2/C3 Euler–Weierstrass disk element fixes the
one shared north pole.  The element is specifically
`A.distinguishedPoleUnit`, not an arbitrary replacement multiplier. -/
@[simp] theorem distinguishedDiskAction_fixes_cayley_N (A : ASection) :
    A.distinguishedDiskAction.val
        (GreatCircle.cayleyCoord
          (OnePoint.infty : GreatCircle.Point)) =
      GreatCircle.cayleyCoord
        (OnePoint.infty : GreatCircle.Point) := by
  rw [A.distinguishedDiskAction_eq_fullMultiplier]
  exact GreatCircle.diskDiagonalMoebiusHom_fixes_cayley_infty
    A.distinguishedPoleUnit

/-- The same distinguished diagonal action fixes projective zero intrinsically.
Euler at `0` and Weierstrass at `N` are the two boundary readings of this one
element, not two actions requiring a comparison theorem. -/
@[simp] theorem distinguishedDiskAction_fixes_cayley_zero (A : ASection) :
    A.distinguishedDiskAction.val
        (GreatCircle.cayleyCoord ((0 : ℝ) : GreatCircle.Point)) =
      GreatCircle.cayleyCoord ((0 : ℝ) : GreatCircle.Point) := by
  rw [A.distinguishedDiskAction_eq_fullMultiplier]
  exact GreatCircle.diskDiagonalMoebiusHom_fixes_cayley_zero
    A.distinguishedPoleUnit

/-- The A-positioned frame over a projective-base object.  The orbit
representative moves the common witness N to the object's footpoint, while
the one C1/C2/C3 element supplies A's action in that frame. -/
def projectiveObjectFrame (A : ASection) (X : GreatCircle.Base) : Moebius :=
  GreatCircle.cayleyProjective
      (GreatCircle.orbitRep (CategoryTheory.ActionCategory.back X)) *
    A.distinguishedDiskAction

/-- The object-side action at a base footpoint.  The orbit representative
positions A's one distinguished Euler–Weierstrass element at `X`; applying
the already-proved Möbius action gives its simultaneous action on the whole
`SphereWorld` continuum.  Its object map fixes each world because the
distinguished element moves inside each Riemann sphere rather than relabelling
the slice direction. -/
def projectiveObjectAction (A : ASection) (X : GreatCircle.Base) :
    SphereWorld ⥤ SphereWorld :=
  distinguishedWorldAction (projectiveObjectFrame A X)

/-- At the north object the orbit representative is the identity, so the
object frame is exactly A's distinguished Euler–Weierstrass element. -/
@[simp] theorem projectiveObjectFrame_north (A : ASection) :
    projectiveObjectFrame A
        (GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point)) =
      A.distinguishedDiskAction := by
  unfold projectiveObjectFrame
  change GreatCircle.cayleyProjective
      (GreatCircle.orbitRep (OnePoint.infty : GreatCircle.Point)) *
        A.distinguishedDiskAction = A.distinguishedDiskAction
  rw [GreatCircle.orbitRep_infty, map_one, one_mul]

/-- Every A-positioned object frame carries the one projective north point to
that object's footpoint in the common Cayley disk chart. -/
theorem projectiveObjectFrame_maps_N (A : ASection)
    (X : GreatCircle.Base) :
    (projectiveObjectFrame A X).val
        (GreatCircle.cayleyCoord
          (OnePoint.infty : GreatCircle.Point)) =
      GreatCircle.cayleyCoord
        (CategoryTheory.ActionCategory.back X) := by
  unfold projectiveObjectFrame
  change (GreatCircle.cayleyProjective
      (GreatCircle.orbitRep (CategoryTheory.ActionCategory.back X))).val
    (A.distinguishedDiskAction.val
      (GreatCircle.cayleyCoord
        (OnePoint.infty : GreatCircle.Point))) =
    GreatCircle.cayleyCoord (CategoryTheory.ActionCategory.back X)
  rw [A.distinguishedDiskAction_fixes_cayley_N,
    GreatCircle.cayleyCoord_equivariant, GreatCircle.orbitRep_spec]

/-- The full orbit–stabilizer transition between the A-positioned source and
target frames.  This is a_A(Y) * stab(f) * a_A(X)⁻¹; hence the object
frames and the arrow transition are two faces of the same group action. -/
def projectiveArrowElement (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) : Moebius :=
  projectiveObjectFrame A Y *
    GreatCircle.cayleyProjective (GreatCircle.stabilizerPart f).1 *
    (projectiveObjectFrame A X)⁻¹

/-- Every full framed arrow carries its source projective footpoint to its
target projective footpoint in the common Cayley disk chart. -/
theorem projectiveArrowElement_maps_footpoint (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    (projectiveArrowElement A f).val
        (GreatCircle.cayleyCoord
          (CategoryTheory.ActionCategory.back X)) =
      GreatCircle.cayleyCoord
        (CategoryTheory.ActionCategory.back Y) := by
  rw [← projectiveObjectFrame_maps_N A X]
  unfold projectiveArrowElement
  change (projectiveObjectFrame A Y).val
    ((GreatCircle.cayleyProjective (GreatCircle.stabilizerPart f).1).val
      (((projectiveObjectFrame A X)⁻¹).val
        ((projectiveObjectFrame A X).val
          (GreatCircle.cayleyCoord
            (OnePoint.infty : GreatCircle.Point))))) =
    GreatCircle.cayleyCoord (CategoryTheory.ActionCategory.back Y)
  have hframe : ((projectiveObjectFrame A X)⁻¹).val
      ((projectiveObjectFrame A X).val
        (GreatCircle.cayleyCoord
          (OnePoint.infty : GreatCircle.Point))) =
      GreatCircle.cayleyCoord
        (OnePoint.infty : GreatCircle.Point) := by
    exact (projectiveObjectFrame A X).val.symm_apply_apply _
  rw [hframe, GreatCircle.cayleyCoord_equivariant]
  have hstab := (GreatCircle.stabilizerPart f).2
  change (GreatCircle.stabilizerPart f).1 •
      (OnePoint.infty : GreatCircle.Point) =
    (OnePoint.infty : GreatCircle.Point) at hstab
  rw [hstab, projectiveObjectFrame_maps_N]

/-- The arrow-side action obtained from the source object frame, the
residual action at `N`, and the target object frame.  This is the
orbit–stabilizer construction itself at functor level: object frames and
arrow transport are consumed together, rather than defining `map` from an
unframed raw base arrow. -/
def projectiveTransition (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) : SphereWorld ⥤ SphereWorld :=
  distinguishedWorldAction ((projectiveObjectFrame A X)⁻¹) ⋙
    distinguishedWorldAction
      (GreatCircle.cayleyProjective (GreatCircle.stabilizerPart f).1) ⋙
    projectiveObjectAction A Y

/-- The framed transition is exactly conjugation by the full
orbit–stabilizer element `a_A(Y) · stab(f) · a_A(X)⁻¹`. -/
theorem projectiveTransition_eq (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    projectiveTransition A f =
      distinguishedWorldAction (projectiveArrowElement A f) := by
  unfold projectiveTransition projectiveObjectAction
  rw [distinguishedWorldAction_comp, distinguishedWorldAction_comp]
  congr 1

/-- The three base factors used above are exactly the factors of the given
projective-base arrow. -/
theorem projectiveArrowElement_base_factor
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    f.val =
      GreatCircle.orbitRep (CategoryTheory.ActionCategory.back Y) *
        (GreatCircle.stabilizerPart f).1 *
        (GreatCircle.orbitRep (CategoryTheory.ActionCategory.back X))⁻¹ :=
  GreatCircle.orbit_stabilizer_factor f

@[simp] theorem projectiveArrowElement_id (A : ASection)
    (X : GreatCircle.Base) :
    projectiveArrowElement A (𝟙 X) = 1 := by
  unfold projectiveArrowElement
  rw [GreatCircle.stabilizerPart_id]
  simp only [Subgroup.coe_one, map_one]
  group

theorem projectiveArrowElement_comp (A : ASection)
    {X Y Z : GreatCircle.Base} (f : X ⟶ Y) (g : Y ⟶ Z) :
    projectiveArrowElement A (f ≫ g) =
      projectiveArrowElement A g * projectiveArrowElement A f := by
  unfold projectiveArrowElement
  rw [GreatCircle.stabilizerPart_comp]
  simp only [Subgroup.coe_mul, map_mul]
  group

/-- The C2/C3 north-pole action of `A`, obtained by specializing the
already-built distinguished Möbius action at A's pole element. -/
def northPoleAction (A : ASection) : SphereWorld ⥤ SphereWorld :=
  distinguishedWorldAction A.distinguishedDiskAction

/-- The genuine sphere-world arrow between the A-positioned source and target
objects.  Its Möbius leg is the full orbit--stabilizer transition, so both
orbit representatives and A's distinguished Euler--Weierstrass element are
part of the arrow itself. -/
def projectiveArrowHom (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    (projectiveObjectAction A X).obj baseWorld ⟶
      (projectiveObjectAction A Y).obj baseWorld :=
  ⟨1, one_smul G2 baseWorld.val, projectiveArrowElement A f⟩

@[simp] theorem projectiveArrowHom_rot (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    (projectiveArrowHom A f).rot = 1 := rfl

@[simp] theorem projectiveArrowHom_mob (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    (projectiveArrowHom A f).mob = projectiveArrowElement A f := rfl

/-- The slice-level geometric projection of the A-section action.
At each projective footpoint, the object is the normalized slice sphere under
the A-positioned frame.  Every base arrow is carried by the matching full
orbit--stabilizer Möbius transition.  Object and arrow are therefore the two
faces of the same A-specialized action.

This is the green sphere-world projection used by the existing projective
theorems. The canonical octonionic function eye and
`AsectionActionDiagram` live at the higher categorical levels. -/
def AsectionSlice (A : ASection) : GreatCircle.Base ⥤ SphereWorld where
  obj X := (projectiveObjectAction A X).obj baseWorld
  map {X Y} f := projectiveArrowHom A f
  map_id X := by
    apply SphereHom.ext
    · rfl
    · exact projectiveArrowElement_id A X
  map_comp f g := by
    apply SphereHom.ext
    · rfl
    · exact projectiveArrowElement_comp A f g

/-- Compatibility name for the previously published slice-level functor.
New construction code should name `AsectionSlice`; this alias is retained
while the existing green dependency surface is migrated without churn. -/
abbrev sectionFunctor (A : ASection) : GreatCircle.Base ⥤ SphereWorld :=
  AsectionSlice A

@[simp] theorem sectionFunctor_map (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    (sectionFunctor A).map f = projectiveArrowHom A f := rfl

/-- The functor's object is produced by the A-positioned object action, not
by an independently selected bundled fibre. -/
@[simp] theorem sectionFunctor_obj (A : ASection) (X : GreatCircle.Base) :
    (sectionFunctor A).obj X =
      (projectiveObjectAction A X).obj baseWorld := rfl

/-- At the shared north object, the functor's object action is precisely A's
north-pole action. -/
theorem sectionFunctor_obj_north (A : ASection) :
    (sectionFunctor A).obj
        (GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point)) =
      (northPoleAction A).obj baseWorld := by
  rw [sectionFunctor_obj]
  unfold projectiveObjectAction northPoleAction
  rw [projectiveObjectFrame_north]

/-- Expanded form of the genuine transition between the two A-positioned
object frames.  Both orbit legs are present. -/
theorem projectiveArrowElement_eq_full_factorization (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    projectiveArrowElement A f =
      GreatCircle.cayleyProjective
          (GreatCircle.orbitRep
            (CategoryTheory.ActionCategory.back Y)) *
        A.distinguishedDiskAction *
        GreatCircle.cayleyProjective (GreatCircle.stabilizerPart f).1 *
        A.distinguishedDiskAction⁻¹ *
        (GreatCircle.cayleyProjective
          (GreatCircle.orbitRep
            (CategoryTheory.ActionCategory.back X)))⁻¹ := by
  rfl

/-- The transition carries the source A-frame to the target A-frame with
exactly the residual stabilizer action.  This is the object/arrow
compatibility supplied by the one orbit--stabilizer construction. -/
theorem projectiveArrowElement_frame_compat (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    projectiveArrowElement A f * projectiveObjectFrame A X =
      projectiveObjectFrame A Y *
        GreatCircle.cayleyProjective (GreatCircle.stabilizerPart f).1 := by
  unfold projectiveArrowElement
  group

/-- The Möbius leg of every genuine A-transport is the full
orbit--stabilizer transition generated from its source and target frames. -/
@[simp] theorem sectionFunctor_map_mob (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    ((sectionFunctor A).map f).mob = projectiveArrowElement A f := rfl

/-- The direct sphere-world arrow displays A's diagonal Euler--Weierstrass
element, both orbit representatives, and the residual stabilizer. -/
theorem sectionFunctor_map_full (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    (sectionFunctor A).map f =
      ⟨1, one_smul G2 baseWorld.val,
          GreatCircle.cayleyProjective
            (GreatCircle.orbitRep
              (CategoryTheory.ActionCategory.back Y)) *
          A.distinguishedDiskAction *
          GreatCircle.cayleyProjective (GreatCircle.stabilizerPart f).1 *
          A.distinguishedDiskAction⁻¹ *
          (GreatCircle.cayleyProjective
            (GreatCircle.orbitRep
              (CategoryTheory.ActionCategory.back X)))⁻¹⟩ := by
  apply SphereHom.ext
  · rfl
  · rw [sectionFunctor_map_mob,
        projectiveArrowElement_eq_full_factorization]

/-- On the represented slice spheres, the direct A-transport is exactly its
Möbius leg acting in the source and target charts. -/
theorem sectionFunctor_map_realize (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) (z : OnePoint ℂ) :
    (((sectionFunctor A).map f).realize
        (sphereChartPoint ((sectionFunctor A).obj X) z)).val =
      spherePt ((sectionFunctor A).obj Y).val
        ((projectiveArrowElement A f).val z) := by
  rw [SphereHom.realize_sphereChartPoint, sectionFunctor_map_mob]

/-- At the projective north object, A's object frame sends the common north
pole to itself: the authored `N ↦ N` gate. -/
theorem sectionFunctor_north_frame_fixes_N (A : ASection) :
    (projectiveObjectFrame A
        (GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point))).val
          (GreatCircle.cayleyCoord
            (OnePoint.infty : GreatCircle.Point)) =
        GreatCircle.cayleyCoord
          (OnePoint.infty : GreatCircle.Point) :=
  projectiveObjectFrame_maps_N A _

end ASection
