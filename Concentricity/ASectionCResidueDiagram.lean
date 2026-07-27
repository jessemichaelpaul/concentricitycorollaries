/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ASectionCResidueInverseImage
import Concentricity.ASectionTotalActionState

/-!
# The functorial C-residue preimage

The already-certified framewise inverse image is a separately bundled
groupoid.  The distinguished action sends that groupoid to its functorial
image in the next ambient fibre.  After totalization, the residue-positioned
objects form the full preimage groupoid in the Grothendieck construction,
with its literal functorial inclusion into the ambient total.

There is deliberately no theorem asserting that a fixed carrier in the
source fibre is preserved as the same fixed carrier in the target fibre:
the zeros are outputs of the action, and the target is the image of the
source preimage groupoid under that action.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-- What the distinguished action does to the separately bundled preimage
groupoid: include it in its ambient fibre and apply the already-certified
whole-action transport.  Its codomain is the functorial image in `F_A(Y)`,
not a second copy of a fixed source carrier. -/
def AsectionCResidueTransport
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    InverseImageCResidueStateWorldGroupoid A X ⥤
      AsectionActionFiber A Y :=
  (IsCResidueState A X).ι ⋙ AsectionActionTransport A f

/-- On objects, the residue transport is literally the ambient action
applied to the object of the preimage groupoid.  This is the definitional
receipt replacing the spurious fixed-carrier preservation obligation. -/
@[simp] theorem cResidue_preserved
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (x : InverseImageCResidueStateWorldGroupoid A X) :
    (AsectionCResidueTransport A f).obj x =
      (AsectionActionTransport A f).obj x.obj := rfl

/-- The semantic residue condition on an object of the complete
Grothendieck total, evaluated in that object's own fibre. -/
def IsTotalCResidueState (A : ASection) :
    ObjectProperty (TotalActionStateWorld A) :=
  fun x => IsCResidueState A x.base x.fiber

/-- The totalized preimage groupoid consumed by the component argument.
It is separately bundled; it is not identified with the ambient total. -/
abbrev AsectionCResidueDiagram (A : ASection) :=
  (IsTotalCResidueState A).FullSubcategory

/-- The literal functorial inclusion of the separately bundled totalized
preimage into the complete action total. -/
def AsectionCResidueInclusion (A : ASection) :
    AsectionCResidueDiagram A ⥤ TotalActionStateWorld A :=
  (IsTotalCResidueState A).ι

end ASection
