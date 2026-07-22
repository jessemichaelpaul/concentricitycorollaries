/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ProjectiveTotal
import Concentricity.Theorem

/-!
# Riehl 8.3.4 on the exact A-section total

The reusable π₀--Grothendieck equivalence is instantiated only after the
direct sphere-valued A-section functor and its induced continuum action have
formed `A.TotalA`.  The component diagram below is a readout of that exact
action; it is not a replacement construction.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-- The component diagram of the exact A-section continuum action. -/
abbrev ComponentDiagram (A : ASection) : GreatCircle.Base ⥤ Type :=
  ((sectionAction A ⋙ Grpd.forgetToCat) ⋙ pi0Functor)

/-- Riehl 8.3.4 instantiated literally on the action whose Grothendieck
construction is `A.TotalA`. -/
noncomputable def projectiveReadout (A : ASection) :
    ConnectedComponents A.TotalA ≃ Limits.colimit A.ComponentDiagram :=
  pi0GrothendieckEquiv (sectionAction A)

/-- The comparison sends a total object to the colimit class of its world
component at its own projective footpoint. -/
abbrev totalColimitClass (A : ASection) (X : A.TotalA) :
    Limits.colimit A.ComponentDiagram :=
  toColimitObj (sectionAction A) X

/-- The canonical total transport carries every C3 zero output to the shared
compactified witness in the same world. -/
theorem zeroColimitClass_eq_north (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    totalColimitClass A (zeroTotal A n I) =
      totalColimitClass A (northTotal A I) :=
  toColimitObj_eq_of_hom (sectionAction A)
    (totalTransport A (GreatCircle.toNHom (A.sphereZero n).re) I)

/-- At the shared witness, the whole `SphereWorld` continuum contributes one
fibre component. -/
theorem northColimitClass_world_independent (A : ASection)
    (I J : SphereWorld) :
    totalColimitClass A (northTotal A I) =
      totalColimitClass A (northTotal A J) := by
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
sphere world, has the one colimit class `κ`. -/
theorem concentricityReadout (A : ASection) :
    ∃ κ : Limits.colimit A.ComponentDiagram,
      ∀ n : ℕ, ∀ I : SphereWorld,
        totalColimitClass A (zeroTotal A n I) = κ := by
  refine ⟨totalColimitClass A (northTotal A baseWorld), ?_⟩
  intro n I
  exact (zeroColimitClass_eq_north A n I).trans
    (northColimitClass_world_independent A I baseWorld)

end ASection
