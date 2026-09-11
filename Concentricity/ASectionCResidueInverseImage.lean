/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ASectionActionDiagram
import Concentricity.ASectionCResidue
import Concentricity.ASectionTotalActionState
import Mathlib.CategoryTheory.ObjectProperty.FullSubcategory

/-!
# The semantic C-residue inverse image

The residue condition is the semantic C-residue zero-sphere condition already
defined by `CResidueZeroLocus`.  This module applies that condition to the
complete states of `AsectionActionDiagram` and forms the corresponding full
subgroupoids.  It introduces no second residue locus and no independent
output datum.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-- A pole-fibre residue seed is one of the already-generated state triples
whose positioned entry is an enumerated residue-`ℂ` point.  Its third entry
is not supplied separately: `value_realized` evaluates the fixed A-section,
and `normalizedSectionPoint_eq_zero` proves that value is zero. -/
def IsPoleCResidueState (A : ASection) :
    ObjectProperty (AsectionActionFiber A (projectivePole A)) :=
  fun x => ∃ n : ℕ, ∃ I : SphereWorld,
    residueActionState A (projectivePole A) n I = x

/-- The A-specific transport saturation of the realized residue seeds.
Membership records the pole-fibre zero-sphere index and direction, the actual
projective-base arrow, and the reaching equation in the existing action
diagram. -/
def IsCResidueState (A : ASection) (X : GreatCircle.Base) :
    ObjectProperty (AsectionActionFiber A X) :=
  fun x =>
    ∃ n : ℕ, ∃ I : SphereWorld,
      ∃ g : projectivePole A ⟶ X,
        (AsectionActionTransport A g).obj
          (residueActionState A (projectivePole A) n I) = x

/-- The full orbit subgroupoid on the A-action images of the realized
residue seeds.  A separately bundled groupoid, never a subset of
`AsectionActionFiber A X`. -/
abbrev InverseImageCResidueStateWorldGroupoid
    (A : ASection) (X : GreatCircle.Base) :=
  (IsCResidueState A X).FullSubcategory

instance (A : ASection) (X : GreatCircle.Base) :
    Groupoid (InverseImageCResidueStateWorldGroupoid A X) :=
  inferInstanceAs
    (Groupoid
      (InducedCategory (AsectionActionFiber A X)
        ObjectProperty.FullSubcategory.obj))


/-! ## The residue system over the A-section's base

master `def:residue-subdiagram`, (W)/(O), over the base the hypotheses supply
(`continuedBase`): a state over `X` is a C-residue state when it is the
A-specific transport of a pole seed along a morphism of that base from the
pole — a real matrix `g : p_A → X` joined to the pole by a GPV transport of
the pole-cancelled factor. -/

/-- master (W)/(O) over the A-section's base. -/
def IsContinuedCResidueState (A : ASection) (X : (continuedBase A).objs) :
    ObjectProperty (AsectionActionFiber A X.1) :=
  fun x =>
    ∃ n : ℕ, ∃ I : SphereWorld, ∃ g : continuedPole A ⟶ X,
      (AsectionActionTransport A ((continuedBaseForget A).map g)).obj
        (residueActionState A (projectivePole A) n I) = x

/-- The fibre of the residue system over an object of the A-section's base:
the full subgroupoid of `A_A(X)` on the residue states; its morphisms are the
`G₂` automorphisms between them. -/
abbrev ContinuedCResidueFiber (A : ASection) (X : (continuedBase A).objs) :=
  (IsContinuedCResidueState A X).FullSubcategory

instance (A : ASection) (X : (continuedBase A).objs) :
    Groupoid (ContinuedCResidueFiber A X) :=
  inferInstanceAs
    (Groupoid
      (InducedCategory (AsectionActionFiber A X.1)
        ObjectProperty.FullSubcategory.obj))

end ASection
