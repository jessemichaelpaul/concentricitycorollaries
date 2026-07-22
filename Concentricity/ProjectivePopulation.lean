/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ProjectiveSection
import Concentricity.NormalizedBase
import Concentricity.Theorem

/-!
# The populated total of the A-section functor

This file forms no second functor and no second total.  It places the C3
zero-sphere outputs directly in the Grothendieck total of
`ASection.sectionFunctor A`, consumes C4 as their infinite indexed
population, and records their common colimit class using the functor's own
base transports and the full `SphereWorld` continuum.  The rejected
`ProjectiveSpecification` wrapper layer is intentionally not imported: the
twelve analytic facts remain upstream in the distinguished action.
-/

noncomputable section

open CategoryTheory

namespace ASection

namespace sectionFunctor

/-- The categorical view used only to form the total of the completed direct
A-section functor.  Its transition is induced from the direct sphere-world
arrow `(sectionFunctor A).map f`; no independent base action or replacement
functor is introduced. -/
def totalDiagram (A : ASection) :
    GreatCircle.Base ⥤ Grpd.{0, 0} where
  obj _ := Grpd.of SphereWorld
  map f := distinguishedWorldAction ((sectionFunctor A).map f).mob
  map_id X := by
    rw [sectionFunctor_map_mob, projectiveArrowElement_id]
    exact distinguishedWorldAction_one
  map_comp f g := by
    rw [sectionFunctor_map_mob, projectiveArrowElement_comp]
    exact (distinguishedWorldAction_comp
      (projectiveArrowElement A f) (projectiveArrowElement A g)).symm

end sectionFunctor

/-- The intended total `𝒯_A`, formed only after the authored direct
`sectionFunctor A : GreatCircle.Base ⥤ SphereWorld` is complete.  Its objects
are the natural pairs `(b, I)` of a projective footpoint and a sphere world. -/
abbrev TotalA (A : ASection) : Type :=
  Grothendieck (sectionFunctor.totalDiagram A ⋙ Grpd.forgetToCat)

instance (A : ASection) : Category A.TotalA := inferInstance

/-- The n-th C-residue zero sphere in world I, at its own projective
real-value footpoint.  No point/hom carrier is interposed. -/
def zeroTotal (A : ASection) (n : ℕ) (I : SphereWorld) : A.TotalA :=
  Grothendieck.mk
    (F := sectionFunctor.totalDiagram A ⋙ Grpd.forgetToCat)
    (GreatCircle.pointObj
      (normalizedFootpoint (A.sphereZero n).re))
    I

/-- The shared compactified witness in a specified sphere world. -/
def northTotal (A : ASection) (I : SphereWorld) : A.TotalA :=
  Grothendieck.mk
    (F := sectionFunctor.totalDiagram A ⋙ Grpd.forgetToCat)
    (GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point))
    I

@[simp] theorem zeroTotal_base (A : ASection) (n : ℕ) (I : SphereWorld) :
    (zeroTotal A n I).base =
      GreatCircle.pointObj
        (normalizedFootpoint (A.sphereZero n).re) := rfl

@[simp] theorem zeroTotal_fiber (A : ASection) (n : ℕ) (I : SphereWorld) :
    (zeroTotal A n I).fiber = I := rfl

@[simp] theorem northTotal_base (A : ASection) (I : SphereWorld) :
    (northTotal A I).base =
      GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point) := rfl

@[simp] theorem northTotal_fiber (A : ASection) (I : SphereWorld) :
    (northTotal A I).fiber = I := rfl

/-- The total's canonical transport along the existing projective base arrow
to `N`.  No fibre arrow is selected or assembled: `Grothendieck.ιNatTrans`
lifts the direct functor-induced action wholesale. -/
def zeroToNorthHom (A : ASection) (n : ℕ) (I : SphereWorld) :
    zeroTotal A n I ⟶ northTotal A I :=
  (Grothendieck.ιNatTrans
    (F := sectionFunctor.totalDiagram A ⋙ Grpd.forgetToCat)
    (GreatCircle.toNHom (A.sphereZero n).re)).app I

/-- C3 supplies every indexed populated zero object. -/
theorem zeroTotal_populated (A : ASection) (n : ℕ) (I : SphereWorld) :
    ∃ X : A.TotalA, X = zeroTotal A n I :=
  ⟨zeroTotal A n I, rfl⟩

/-- C4 is consumed as the infinitude of the C-residue population that the
preceding function places in the total. -/
theorem zeroTotal_c4_infinite (A : ASection) :
    (Set.range A.sphereZero).Infinite :=
  A.c4_infinite

end ASection
