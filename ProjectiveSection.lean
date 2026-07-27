/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.CayleyDictionary
import Concentricity.NormalizedNLeg
import Concentricity.Theorem
import Mathlib.CategoryTheory.Groupoid.Grpd.Basic
import Mathlib.CategoryTheory.Grothendieck

/-!
# The projective A-section connection

This file packages the distinguished projective action together with the
`ASection`-specific population and the certified C1/C3 zero--N closures.  The
exported construction is the connection package, not a value-free replacement
functor: its populated total objects and its genuine zero--N transports are
fields of the same object.
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

end GreatCircle

namespace ASection

/-- The distinguished projective action in every slice world simultaneously.
The world is retained; the arrow's own Cayley/Möbius element conjugates the
Möbius leg. -/
private def distinguishedWorldAction (m : Moebius) : SphereWorld ⥤ SphereWorld where
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

private theorem distinguishedWorldAction_one :
    distinguishedWorldAction 1 = Functor.id SphereWorld := by
  refine CategoryTheory.Functor.ext (fun I => rfl) fun I J f => ?_
  simp only [Functor.id_map]
  apply SphereHom.ext
  · rfl
  · change 1 * f.mob * 1⁻¹ = f.mob
    group

private theorem distinguishedWorldAction_comp (m n : Moebius) :
    distinguishedWorldAction m ⋙ distinguishedWorldAction n =
      distinguishedWorldAction (n * m) := by
  refine CategoryTheory.Functor.ext (fun I => rfl) fun I J f => ?_
  simp only [Functor.comp_map]
  apply SphereHom.ext
  · rfl
  · change n * (m * f.mob * m⁻¹) * n⁻¹ =
        (n * m) * f.mob * (n * m)⁻¹
    group

/-- The categorical skeleton forced by the locked projective action.  It is
private: the public construction below exports it only together with the
section's analytic connection and population. -/
private def projectiveSkeleton : GreatCircle.Base ⥤ Grpd.{0, 0} where
  obj _ := Grpd.of SphereWorld
  map f := distinguishedWorldAction (GreatCircle.cayleyProjective f.val)
  map_id b := by
    rw [CategoryTheory.ActionCategory.id_val, map_one]
    exact distinguishedWorldAction_one
  map_comp f g := by
    rw [CategoryTheory.ActionCategory.comp_val, map_mul]
    exact (distinguishedWorldAction_comp
      (GreatCircle.cayleyProjective f.val)
      (GreatCircle.cayleyProjective g.val)).symm

/-- The total category of a groupoid-valued functor on the locked base. -/
abbrev ProjectiveTotal (F : GreatCircle.Base ⥤ Grpd.{0, 0}) : Type :=
  Grothendieck (F ⋙ Grpd.forgetToCat)

/-- The genuine projective section connection.  Besides the functor laws it
contains the C3/C4 populated zero states, their common N-states, the actual
total morphisms over `toNHom`, and the C1/C3 analytic closure certificate for
each such transport. -/
structure ProjectiveConnection (A : ASection) where
  toFunctor : GreatCircle.Base ⥤ Grpd.{0, 0}
  zeroState : (n : ℕ) → (I : SphereWorld) → ProjectiveTotal toFunctor
  northState : (I : SphereWorld) → ProjectiveTotal toFunctor
  zeroToN : (n : ℕ) → (I : SphereWorld) → zeroState n I ⟶ northState I
  zeroToN_analytic : ∀ n I, NormalizedNLeg A n I

/-- C1--C4 package the distinguished action, its populated C-residue states,
and their certified transports to the shared witness. -/
def projectiveConnection (A : ASection) : ProjectiveConnection A where
  toFunctor := projectiveSkeleton
  zeroState n I :=
    ⟨GreatCircle.pointObj ((A.sphereZero n).re : GreatCircle.Point), I⟩
  northState I :=
    ⟨GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point), I⟩
  zeroToN n I :=
    { base := GreatCircle.toNHom (A.sphereZero n).re
      fiber := mobHom I
        (GreatCircle.cayleyProjective
          (GreatCircle.toNHom (A.sphereZero n).re).val) }
  zeroToN_analytic n I := A.normalizedNLeg n I

/-- **The genuine A-section functor on the locked base**, exported through
the analytic connection package. -/
def projectiveSectionFunctor (A : ASection) : GreatCircle.Base ⥤ Grpd.{0, 0} :=
  (projectiveConnection A).toFunctor

/-- The total object of the genuine projective A-section functor. -/
abbrev Total (A : ASection) : Type :=
  ProjectiveTotal (projectiveSectionFunctor A)

instance (A : ASection) : Category (Total A) := inferInstance

/-- The populated n-th C-residue zero in the total object. -/
def zeroTotal (A : ASection) (n : ℕ) (I : SphereWorld) : Total A :=
  (projectiveConnection A).zeroState n I

/-- The copy of the common witness in world `I`. -/
def northTotal (A : ASection) (I : SphereWorld) : Total A :=
  (projectiveConnection A).northState I

/-- The genuine total morphism from a populated zero state to the common
witness. -/
def zeroToN (A : ASection) (n : ℕ) (I : SphereWorld) :
    zeroTotal A n I ⟶ northTotal A I :=
  (projectiveConnection A).zeroToN n I

/-- The analytic certificate carried by the genuine zero--N transport. -/
def zeroToN_analytic (A : ASection) (n : ℕ) (I : SphereWorld) :
    NormalizedNLeg A n I :=
  (projectiveConnection A).zeroToN_analytic n I

/-- Each genuine zero--N morphism supplies its finite zigzag. -/
def zeroToNZigzag (A : ASection) (n : ℕ) (I : SphereWorld) :
    Zigzag (zeroTotal A n I) (northTotal A I) :=
  Zigzag.of_hom (zeroToN A n I)

/-- Two populated zero states in one world are joined by the genuine
transport through the shared witness N.  Both legs carry their analytic
closure certificates through `zeroToN_analytic`. -/
def zerosJoinedThroughN (A : ASection) (n m : ℕ) (I : SphereWorld) :
    Zigzag (zeroTotal A n I) (zeroTotal A m I) :=
  (zeroToNZigzag A n I).trans (zeroToNZigzag A m I).symm

/-- The certified Grothendieck/colimit readout for the genuine functor. -/
noncomputable def projectiveReadout (A : ASection) :
    ConnectedComponents (Total A) ≃
      Limits.colimit (((projectiveSectionFunctor A ⋙ Grpd.forgetToCat) ⋙
        pi0Functor)) :=
  pi0GrothendieckEquiv (projectiveSectionFunctor A)

end ASection
