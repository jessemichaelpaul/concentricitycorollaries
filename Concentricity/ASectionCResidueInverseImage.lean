/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ASectionActionDiagram
import Concentricity.ASectionCResidue
import Mathlib.CategoryTheory.ObjectProperty.FullSubcategory

/-!
# The framewise C-residue orbit preimage

At the common north frame, the already-certified semantic locus
`CResidueZeroLocus A` selects the residue objects of the complete action
fibre.  At an arbitrary projective frame `X`, the residue system is the
orbitwise preimage supplied by the same A-specific action functor:
an object belongs when it is the image of a north residue object under
`AsectionActionTransport A g` for a base arrow `g : projectiveNorth ⟶ X`.

Thus the base arrow and the action on objects and arrows are part of the
groupoid preimage itself.  No external fixed carrier is tested after
transport, and cross-frame closure is composition in the base groupoid.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-- The semantic C-residue objects in the north fibre of the distinguished
A-section action.  This is the only point at which the intrinsic equation
selects objects. -/
def IsNorthCResidueState (A : ASection) :
    ObjectProperty (AsectionActionFiber A projectiveNorth) :=
  fun x =>
    x ∈
      (fun y : AsectionActionFiber A projectiveNorth =>
          y.positioned.back.coordinate) ⁻¹'
        ((fun z : ℂ => (z : OnePoint ℂ)) '' A.CResidueZeroLocus)

/-- The orbitwise groupoid preimage of the north residue objects under the
already-certified A-specific action diagram.  The witness arrow is data of
the preimage over the base groupoid, so subsequent transport is composition,
not a separate preservation theorem. -/
def IsCResidueState (A : ASection) (X : GreatCircle.Base) :
    ObjectProperty (AsectionActionFiber A X) :=
  fun x =>
    ∃ xN : AsectionActionFiber A projectiveNorth,
      IsNorthCResidueState A xN ∧
        ∃ g : projectiveNorth ⟶ X,
          (AsectionActionTransport A g).obj xN = x

/-- The full orbit subgroupoid on the A-action images of the semantic north
residue objects. -/
abbrev InverseImageCResidueStateWorldGroupoid
    (A : ASection) (X : GreatCircle.Base) :=
  (IsCResidueState A X).FullSubcategory

instance (A : ASection) (X : GreatCircle.Base) :
    Groupoid (InverseImageCResidueStateWorldGroupoid A X) :=
  inferInstanceAs
    (Groupoid
      (InducedCategory (AsectionActionFiber A X)
        ObjectProperty.FullSubcategory.obj))

end ASection
