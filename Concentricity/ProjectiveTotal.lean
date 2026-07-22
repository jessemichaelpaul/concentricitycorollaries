/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ProjectiveSection
import Concentricity.NormalizedBase

/-!
# The direct total of the A-section action

The completed geometric functor `sectionFunctor A` first determines every
base-arrow action on the whole `SphereWorld` continuum.  The Grothendieck
construction is then applied to that exact A-specific action.  It is not used
to choose or reconstruct the A-section functor.

The twelve certified analytic facts, and any further native facts needed,
belong to this same distinguished Euler--Weierstrass action.  The structural
formula below shows that every transport used in the total is literally the
full A-specialized orbit--stabilizer action.  Thus those facts already hold
throughout `A.TotalA`; C3/C4 below identify and count particular zero outputs,
not the total's analytic content.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-- The action of the completed direct A-section functor on the
`SphereWorld` continuum.  Its arrow map is the same framed
source/stabilizer/target transition that defines `(sectionFunctor A).map f`;
the object frame and arrow transition are consumed as one construction.
The fibre carrier is the whole `SphereWorld` at every projective footpoint
because objects of the total are all pairs `(b, I)`; the resulting diagram is
not constant, since every transition is definitionally induced by A's exact
framed arrow. -/
def sectionAction (A : ASection) : GreatCircle.Base ⥤ Grpd.{0, 0} where
  obj _ := Grpd.of SphereWorld
  map f := distinguishedWorldAction ((sectionFunctor A).map f).mob
  map_id X := by
    rw [sectionFunctor_map_mob, projectiveArrowElement_id]
    exact distinguishedWorldAction_one
  map_comp f g := by
    rw [sectionFunctor_map_mob, sectionFunctor_map_mob,
      sectionFunctor_map_mob, projectiveArrowElement_comp]
    exact (distinguishedWorldAction_comp
      (projectiveArrowElement A f) (projectiveArrowElement A g)).symm

/-- Every action map is definitionally induced by the corresponding arrow of
the direct sphere-valued A-section functor. -/
theorem sectionAction_map (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    (sectionAction A).map f =
      distinguishedWorldAction ((sectionFunctor A).map f).mob := rfl

/-- Every sphere-world transport used by the total is literally the direct
A-section arrow acting on the incoming transport. -/
theorem sectionAction_transport_mob (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y)
    {I J : SphereWorld} (φ : I ⟶ J) :
    (((sectionAction A).map f).map φ).mob =
      projectiveArrowElement A f * φ.mob *
        (projectiveArrowElement A f)⁻¹ := by
  rw [sectionAction_map]
  rfl

/-- Expanded structural gate for every genuine transport in `A.TotalA`:
the full `ℂˣ` distinguished element, both orbit representatives, the residual
stabilizer, and the incoming Möbius leg occur in the transport itself. -/
theorem sectionAction_transport_full (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y)
    {I J : SphereWorld} (φ : I ⟶ J) :
    ((sectionAction A).map f).map φ =
      ⟨φ.rot, φ.rot_eq,
        (GreatCircle.cayleyProjective
            (GreatCircle.orbitRep
              (CategoryTheory.ActionCategory.back Y)) *
          GreatCircle.diagonalMoebiusHom A.distinguishedPoleUnit *
          GreatCircle.cayleyProjective (GreatCircle.stabilizerPart f).1 *
          (GreatCircle.diagonalMoebiusHom A.distinguishedPoleUnit)⁻¹ *
          (GreatCircle.cayleyProjective
            (GreatCircle.orbitRep
              (CategoryTheory.ActionCategory.back X)))⁻¹) *
        φ.mob *
        (GreatCircle.cayleyProjective
            (GreatCircle.orbitRep
              (CategoryTheory.ActionCategory.back Y)) *
          GreatCircle.diagonalMoebiusHom A.distinguishedPoleUnit *
          GreatCircle.cayleyProjective (GreatCircle.stabilizerPart f).1 *
          (GreatCircle.diagonalMoebiusHom A.distinguishedPoleUnit)⁻¹ *
          (GreatCircle.cayleyProjective
            (GreatCircle.orbitRep
              (CategoryTheory.ActionCategory.back X)))⁻¹)⁻¹⟩ := by
  apply SphereHom.ext
  · rfl
  · rw [sectionAction_transport_mob,
        projectiveArrowElement_eq_full_factorization]

/-- The intended total `𝒯_A`, formed by the Grothendieck recipe from the
action induced by the exact direct A-section functor. -/
abbrev TotalA (A : ASection) : Type :=
  Grothendieck (sectionAction A ⋙ Grpd.forgetToCat)

instance (A : ASection) : Category A.TotalA := inferInstance

/-- Objects of `𝒯_A` are precisely a projective footpoint together with a
sphere world. -/
def totalMk (A : ASection) (b : GreatCircle.Base) (I : SphereWorld) :
    A.TotalA :=
  Grothendieck.mk (F := sectionAction A ⋙ Grpd.forgetToCat) b I

@[simp] theorem totalMk_base (A : ASection) (b : GreatCircle.Base)
    (I : SphereWorld) : (totalMk A b I).base = b := rfl

@[simp] theorem totalMk_world (A : ASection) (b : GreatCircle.Base)
    (I : SphereWorld) : (totalMk A b I).fiber = I := rfl

/-- The C3 n-th zero output in world `I`, at its own projective footpoint. -/
def zeroTotal (A : ASection) (n : ℕ) (I : SphereWorld) : A.TotalA :=
  totalMk A (normalizedFootpoint (A.sphereZero n).re) I

/-- The common compactified witness in world `I`. -/
def northTotal (A : ASection) (I : SphereWorld) : A.TotalA :=
  totalMk A
    (GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point)) I

@[simp] theorem zeroTotal_base (A : ASection) (n : ℕ) (I : SphereWorld) :
    (zeroTotal A n I).base =
      normalizedFootpoint (A.sphereZero n).re := rfl

@[simp] theorem zeroTotal_world (A : ASection) (n : ℕ) (I : SphereWorld) :
    (zeroTotal A n I).fiber = I := rfl

@[simp] theorem northTotal_base (A : ASection) (I : SphereWorld) :
    (northTotal A I).base =
      GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point) := rfl

@[simp] theorem northTotal_world (A : ASection) (I : SphereWorld) :
    (northTotal A I).fiber = I := rfl

/-- The wholesale total transport induced by a base arrow. -/
def totalTransport (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (I : SphereWorld) : totalMk A X I ⟶ totalMk A Y I :=
  (Grothendieck.ιNatTrans
    (F := sectionAction A ⋙ Grpd.forgetToCat) f).app I

/-- C3 supplies every indexed zero output in every sphere world. -/
theorem zeroTotal_populated (A : ASection) (n : ℕ) (I : SphereWorld) :
    ∃ X : A.TotalA, X = zeroTotal A n I :=
  ⟨zeroTotal A n I, rfl⟩

/-- C4 supplies the infinite output population. -/
theorem zeroTotal_c4_infinite (A : ASection) :
    (Set.range A.sphereZero).Infinite :=
  A.c4_infinite

end ASection
