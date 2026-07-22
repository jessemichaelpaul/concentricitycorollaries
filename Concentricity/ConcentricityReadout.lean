/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ProjectivePopulation

/-!
# The π₀ readout of the completed A-section total

Riehl 8.3.4 is instantiated here, after the direct A-section functor and its
populated total are complete.  The colimit consumes that exact functorial
action wholesale.  The real readout below is the descent of the value already
carried by those states and transports.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-- The fibrewise connected-components diagram of the completed A-section
total. -/
abbrev ComponentDiagram (A : ASection) : GreatCircle.Base ⥤ Type :=
  ((sectionFunctor.totalDiagram A ⋙ Grpd.forgetToCat) ⋙ pi0Functor)

/-- Riehl 8.3.4 instantiated on the categorical total of the completed direct
A-section functor. -/
noncomputable def projectiveReadout (A : ASection) :
    ConnectedComponents A.TotalA ≃ Limits.colimit A.ComponentDiagram :=
  pi0GrothendieckEquiv (sectionFunctor.totalDiagram A)

/-- Each populated zero has the colimit class of the shared witness in its
own world, by its genuine total morphism. -/
theorem zeroColimitClass_eq_north (A : ASection) (n : ℕ) (I : SphereWorld) :
    toColimitObj (sectionFunctor.totalDiagram A) (zeroTotal A n I) =
      toColimitObj (sectionFunctor.totalDiagram A) (northTotal A I) :=
  toColimitObj_eq_of_hom (sectionFunctor.totalDiagram A)
    (zeroToNorthHom A n I)

/-- At the common witness, the full `SphereWorld` continuum contributes one
fibre component. -/
theorem northColimitClass_world_independent (A : ASection)
    (I J : SphereWorld) :
    toColimitObj (sectionFunctor.totalDiagram A) (northTotal A I) =
      toColimitObj (sectionFunctor.totalDiagram A) (northTotal A J) := by
  change Limits.colimit.ι A.ComponentDiagram
      (GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point))
      (CategoryTheory.ConnectedComponents.mk I) =
    Limits.colimit.ι A.ComponentDiagram
      (GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point))
      (CategoryTheory.ConnectedComponents.mk J)
  exact congrArg
    (Limits.colimit.ι A.ComponentDiagram
      (GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point)))
    (_root_.Quotient.sound (sphereWorld_zigzag I J))

/-- The wholesale categorical collapse: every C3 zero output, in every
sphere world, has one colimit class `κ`. -/
theorem concentricityReadout (A : ASection) :
    ∃ κ : Limits.colimit A.ComponentDiagram,
      ∀ n : ℕ, ∀ I : SphereWorld,
        toColimitObj (sectionFunctor.totalDiagram A) (zeroTotal A n I) = κ := by
  refine ⟨toColimitObj (sectionFunctor.totalDiagram A)
    (northTotal A baseWorld), ?_⟩
  intro n I
  exact (zeroColimitClass_eq_north A n I).trans
    (northColimitClass_world_independent A I baseWorld)

end ASection
