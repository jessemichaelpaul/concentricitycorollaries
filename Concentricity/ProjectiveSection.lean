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

/-- Every north-stabilizer class occurs as the residual factor of an arrow
in every hom-set of the base: the arrow with element `o_Y · s · o_X⁻¹`, the
orbit--stabilizer factorization read backward.  This is the availability of
the residual Cayley factor consumed by the choice (M) of master
`lem:c-residue-transitive`. -/
theorem stabilizerPart_realized (X Y : GreatCircle.Base)
    (s : GreatCircle.NorthStabilizer) :
    ∃ f : X ⟶ Y, GreatCircle.stabilizerPart f = s := by
  have haction :
      (GreatCircle.orbitRep (CategoryTheory.ActionCategory.back Y) * s.1 *
        (GreatCircle.orbitRep (CategoryTheory.ActionCategory.back X))⁻¹) •
        CategoryTheory.ActionCategory.back X =
      CategoryTheory.ActionCategory.back Y := by
    have hX : (GreatCircle.orbitRep (CategoryTheory.ActionCategory.back X))⁻¹ •
        CategoryTheory.ActionCategory.back X =
        (OnePoint.infty : GreatCircle.Point) := by
      rw [inv_smul_eq_iff]
      exact (GreatCircle.orbitRep_spec _).symm
    have hs' : (s : GreatCircle.Aut) •
        (OnePoint.infty : GreatCircle.Point) = OnePoint.infty := by
      have hmem := s.2
      rwa [MulAction.mem_stabilizer_iff] at hmem
    rw [mul_smul, mul_smul, hX, hs']
    exact GreatCircle.orbitRep_spec _
  refine ⟨⟨GreatCircle.orbitRep (CategoryTheory.ActionCategory.back Y) * s.1 *
    (GreatCircle.orbitRep (CategoryTheory.ActionCategory.back X))⁻¹,
    haction⟩, ?_⟩
  exact (GreatCircle.stabilizerPart_unique _ s (by group)).symm

/-! ## Transitivity of the base action (master `lem:projective-base-transitive`)

The master's proof displays one class per pair of objects, each value
computed by the action rules.  The witnesses are the standing matrices
`toNGL` and `orbitGL` together with the displayed translation class. -/

/-- The translation class of the master's display: it carries `a` to
`a + t` on the real line. -/
def translationGL (t : ℝ) : GL (Fin 2) ℝ :=
  Matrix.GeneralLinearGroup.mkOfDetNeZero !![1, t; 0, 1] (by
    rw [Matrix.det_fin_two_of]
    norm_num)

@[simp] theorem translationGL_val (t : ℝ) :
    (translationGL t).val = !![1, t; 0, 1] := rfl

theorem translationGL_smul (a t : ℝ) :
    translationGL t • ((a : ℝ) : GreatCircle.Point) =
      ((a + t : ℝ) : GreatCircle.Point) := by
  rw [OnePoint.smul_some_eq_ite]
  simp [translationGL_val, add_comm]

/-- The master's third displayed class: it carries the point at infinity
to `b`, its value read by the rule at infinity. -/
def fromInftyGL (b : ℝ) : GL (Fin 2) ℝ :=
  Matrix.GeneralLinearGroup.mkOfDetNeZero !![b, 1; 1, 0] (by
    rw [Matrix.det_fin_two_of]
    norm_num)

@[simp] theorem fromInftyGL_val (b : ℝ) :
    (fromInftyGL b).val = !![b, 1; 1, 0] := rfl

theorem fromInftyGL_smul_infty (b : ℝ) :
    fromInftyGL b • (OnePoint.infty : GreatCircle.Point) =
      ((b : ℝ) : GreatCircle.Point) := by
  rw [OnePoint.smul_infty_eq_ite]
  simp [fromInftyGL_val]

/-- The base action is transitive: one displayed class joins each pair of
points --- the master's four computed cases. -/
instance : MulAction.IsPretransitive GreatCircle.Aut GreatCircle.Point where
  exists_smul_eq x y := by
    induction x using OnePoint.rec with
    | infty =>
        induction y using OnePoint.rec with
        | infty => exact ⟨1, one_smul _ _⟩
        | coe b =>
            refine ⟨Matrix.ProjGenLinGroup.mk (fromInftyGL b), ?_⟩
            rw [GreatCircle.mk_smul]
            exact fromInftyGL_smul_infty b
    | coe a =>
        induction y using OnePoint.rec with
        | infty =>
            refine ⟨Matrix.ProjGenLinGroup.mk (toNGL a), ?_⟩
            rw [GreatCircle.mk_smul]
            exact toNGL_smul a
        | coe b =>
            refine ⟨Matrix.ProjGenLinGroup.mk (translationGL (b - a)), ?_⟩
            rw [GreatCircle.mk_smul, translationGL_smul]
            norm_num

/-- master `lem:projective-base-transitive`: the projective base is a
transitive groupoid --- the hom-set between any two objects is nonempty. -/
theorem base_transitive (X Y : GreatCircle.Base) : Nonempty (X ⟶ Y) := by
  obtain ⟨g, hg⟩ := MulAction.exists_smul_eq GreatCircle.Aut
    (CategoryTheory.ActionCategory.back X)
    (CategoryTheory.ActionCategory.back Y)
  exact ⟨⟨g, hg⟩⟩

/-! ## Transitivity of each slice M\"obius groupoid (master `lem:mobius-transitive`)

The same four computed cases on the fixed slice sphere, with the master's
displayed complex matrices. -/

/-- The complex translation class of the master's display. -/
def translationGLC (t : ℂ) : GL (Fin 2) ℂ :=
  Matrix.GeneralLinearGroup.mkOfDetNeZero !![1, t; 0, 1] (by
    rw [Matrix.det_fin_two_of]
    norm_num)

@[simp] theorem translationGLC_val (t : ℂ) :
    (translationGLC t).val = !![1, t; 0, 1] := rfl

theorem translationGLC_smul (u t : ℂ) :
    translationGLC t • ((u : ℂ) : OnePoint ℂ) =
      ((u + t : ℂ) : OnePoint ℂ) := by
  rw [OnePoint.smul_some_eq_ite]
  simp [translationGLC_val, add_comm]

/-- The master's second displayed class: it carries `u` to the point at
infinity, its denominator vanishing exactly at `u`. -/
def toInftyGLC (u : ℂ) : GL (Fin 2) ℂ :=
  Matrix.GeneralLinearGroup.mkOfDetNeZero !![0, 1; 1, -u] (by
    rw [Matrix.det_fin_two_of]
    norm_num)

@[simp] theorem toInftyGLC_val (u : ℂ) :
    (toInftyGLC u).val = !![0, 1; 1, -u] := rfl

theorem toInftyGLC_smul (u : ℂ) :
    toInftyGLC u • ((u : ℂ) : OnePoint ℂ) = OnePoint.infty := by
  rw [OnePoint.smul_some_eq_ite]
  simp [toInftyGLC_val]

/-- The master's third displayed class: it carries the point at infinity
to `v`, its value read by the rule at infinity. -/
def fromInftyGLC (v : ℂ) : GL (Fin 2) ℂ :=
  Matrix.GeneralLinearGroup.mkOfDetNeZero !![v, 1; 1, 0] (by
    rw [Matrix.det_fin_two_of]
    norm_num)

@[simp] theorem fromInftyGLC_val (v : ℂ) :
    (fromInftyGLC v).val = !![v, 1; 1, 0] := rfl

theorem fromInftyGLC_smul_infty (v : ℂ) :
    fromInftyGLC v • (OnePoint.infty : OnePoint ℂ) = ((v : ℂ) : OnePoint ℂ) := by
  rw [OnePoint.smul_infty_eq_ite]
  simp [fromInftyGLC_val]

/-- master `lem:mobius-transitive`: any two points of a slice Riemann
sphere are joined by an arrow of its M\"obius action groupoid --- one
displayed class per pair, the master's four computed cases. -/
theorem moebius_transitive (u v : OnePoint ℂ) :
    ∃ m : Moebius, m.val u = v := by
  induction u using OnePoint.rec with
  | infty =>
      induction v using OnePoint.rec with
      | infty => exact ⟨1, rfl⟩
      | coe b =>
          refine ⟨Moebius.of (fromInftyGLC b), ?_⟩
          rw [Moebius.of_apply]
          exact fromInftyGLC_smul_infty b
  | coe a =>
      induction v using OnePoint.rec with
      | infty =>
          refine ⟨Moebius.of (toInftyGLC a), ?_⟩
          rw [Moebius.of_apply]
          exact toInftyGLC_smul a
      | coe b =>
          refine ⟨Moebius.of (translationGLC (b - a)), ?_⟩
          rw [Moebius.of_apply, translationGLC_smul]
          norm_num

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

/-- The Cayley-projective orbit position over a base object: the
representative `o_b` of master `def:orbit-reps`, Cayley conjugated.  It
serves the presentation layer of `ASectionFunctor`; the frames of
`A^slice` below are the A-specific actions themselves. -/
def projectiveOrbitPosition (X : GreatCircle.Base) : Moebius :=
  GreatCircle.cayleyProjective
    (GreatCircle.orbitRep (CategoryTheory.ActionCategory.back X))

/-- Position one disk action over a projective-base object by the orbit
representative. -/
def projectiveTapeFrame (X : GreatCircle.Base) (d : Moebius) : Moebius :=
  projectiveOrbitPosition X * d

/-- The pole-cancelled factor `g_A` at a base point, as a unit of `ℂ`
(master `def:DA`): at a finite point where the factor is nonzero it is that
value, the multiplier the A-specific action exponentiates there; at the
pole it is `u_A`.  At the point at infinity and at the real zeros of the
factor, which no A-specific transport reaches, the unit is `1`. -/
noncomputable def poleFactorUnit (A : ASection) (X : GreatCircle.Base) : ℂˣ :=
  OnePoint.rec (C := fun _ => ℂˣ) 1
    (fun x : ℝ =>
      if h : A.distinguishedPoleFactor (x : ℂ) = 0 then 1
      else Units.mk0 (A.distinguishedPoleFactor (x : ℂ)) h)
    (CategoryTheory.ActionCategory.back X)

/-- At a finite base point where the pole-cancelled factor is nonzero, the
unit is that value. -/
theorem poleFactorUnit_coe (A : ASection) (x : ℝ)
    (hx : A.distinguishedPoleFactor (x : ℂ) ≠ 0) :
    A.poleFactorUnit ((x : GreatCircle.Point) : GreatCircle.Base) =
      Units.mk0 (A.distinguishedPoleFactor (x : ℂ)) hx := by
  show (if h : A.distinguishedPoleFactor (x : ℂ) = 0 then (1 : ℂˣ)
    else Units.mk0 (A.distinguishedPoleFactor (x : ℂ)) h) = _
  rw [dif_neg hx]

/-- At the pole the unit is the multiplier `u_A`. -/
theorem poleFactorUnit_pole (A : ASection) :
    A.poleFactorUnit (projectivePole A) = A.distinguishedPoleUnit := by
  apply Units.ext
  rw [projectivePole, poleFactorUnit_coe A A.pole A.distinguishedPoleFactor_ne_zero]
  rfl

/-- master `def:aslice`, the object assignment: `A^slice(b)` is the
A-specific disk action at the base point `b`, the value of the pole-cancelled
factor there exponentiated in the diagonal matrix and Cayley conjugated
(`def:cayley-disk`, `def:DA`).  At the pole it is `D_A`
(`projectiveObjectFrame_pole`). -/
noncomputable def projectiveObjectFrame (A : ASection) (X : GreatCircle.Base) : Moebius :=
  GreatCircle.diskDiagonalMoebiusHom (A.poleFactorUnit X)

/-- The object-side action at a base point: the A-specific disk action there,
acting on the whole `SphereWorld` continuum at once.  Its object map fixes
each world because the disk action moves inside each Riemann sphere rather
than relabelling the slice direction. -/
def projectiveObjectAction (A : ASection) (X : GreatCircle.Base) :
    SphereWorld ⥤ SphereWorld :=
  distinguishedWorldAction (projectiveObjectFrame A X)

/-- master `lem:finite-pole-arrival` at the object assignment: at the pole
the frame of `A^slice` is the distinguished disk action `D_A`. -/
@[simp] theorem projectiveObjectFrame_pole (A : ASection) :
    projectiveObjectFrame A (projectivePole A) = A.distinguishedDiskAction := by
  rw [projectiveObjectFrame, poleFactorUnit_pole,
    A.distinguishedDiskAction_eq_fullMultiplier]

/-- master `def:aslice`, the arrow assignment as displayed:
`P(b) · cayleyProjective(h) · P(a)⁻¹` — the positioned disk action at the
target, the base arrow, the inverse of the positioned disk action at the
source.  Read from right to left, `P(a)⁻¹` removes the positioned action at
the source, `cayleyProjective(h)` applies the base arrow, and `P(b)`
restores the positioned action at the target. -/
def projectiveArrowElement (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) : Moebius :=
  projectiveObjectFrame A Y *
    GreatCircle.cayleyProjective f.val *
    (projectiveObjectFrame A X)⁻¹

/-- The arrow-side action obtained from the source object frame, the base
arrow, and the target object frame: the positioning pattern of master
`def:aslice` at functor level, object frames and arrow transport consumed
together. -/
def projectiveTransition (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) : SphereWorld ⥤ SphereWorld :=
  distinguishedWorldAction ((projectiveObjectFrame A X)⁻¹) ⋙
    distinguishedWorldAction (GreatCircle.cayleyProjective f.val) ⋙
    projectiveObjectAction A Y

/-- The framed transition is exactly conjugation by the arrow element
`P(Y) · cayleyProjective(f) · P(X)⁻¹`. -/
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

/-- master `prop:aslice-functor`, the identity: `P(a)·cayleyProjective(1)·P(a)⁻¹ = 1`. -/
@[simp] theorem projectiveArrowElement_id (A : ASection)
    (X : GreatCircle.Base) :
    projectiveArrowElement A (𝟙 X) = 1 := by
  unfold projectiveArrowElement
  change projectiveObjectFrame A X * GreatCircle.cayleyProjective 1 *
    (projectiveObjectFrame A X)⁻¹ = 1
  rw [map_one]
  group

/-- master `prop:aslice-functor`, composition: the interior `P(b)⁻¹P(b)`
cancels and the two base factors multiply to the composite, by the
homomorphism law of `cayleyProjective`. -/
theorem projectiveArrowElement_comp (A : ASection)
    {X Y Z : GreatCircle.Base} (f : X ⟶ Y) (g : Y ⟶ Z) :
    projectiveArrowElement A (f ≫ g) =
      projectiveArrowElement A g * projectiveArrowElement A f := by
  unfold projectiveArrowElement
  change projectiveObjectFrame A Z *
      GreatCircle.cayleyProjective ((show GreatCircle.Aut from g.val) *
        (show GreatCircle.Aut from f.val)) *
      (projectiveObjectFrame A X)⁻¹ = _
  rw [map_mul]
  group

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

/-- The arrow element carries the source frame to the target frame with
exactly the base arrow between them:
`A^slice(f) · P(X) = P(Y) · cayleyProjective(f)`. -/
theorem projectiveArrowElement_frame_compat (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    projectiveArrowElement A f * projectiveObjectFrame A X =
      projectiveObjectFrame A Y * GreatCircle.cayleyProjective f.val := by
  unfold projectiveArrowElement
  group

/-- The Möbius leg of every arrow of `A^slice` is the arrow element
`P(Y) · cayleyProjective(f) · P(X)⁻¹`. -/
@[simp] theorem sectionFunctor_map_mob (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    ((sectionFunctor A).map f).mob = projectiveArrowElement A f := rfl

/-- On the represented slice spheres, the direct A-transport is exactly its
Möbius leg acting in the source and target charts. -/
theorem sectionFunctor_map_realize (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) (z : OnePoint ℂ) :
    (((sectionFunctor A).map f).realize
        (sphereChartPoint ((sectionFunctor A).obj X) z)).val =
      spherePt ((sectionFunctor A).obj Y).val
        ((projectiveArrowElement A f).val z) := by
  rw [SphereHom.realize_sphereChartPoint, sectionFunctor_map_mob]

end ASection
