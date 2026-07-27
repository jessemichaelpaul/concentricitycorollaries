/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ASectionCResidueInverseImage

/-!
# The functorial C-residue preimage square

For the already-certified A-section action map `F_A(f)`, the source is the
full groupoid preimage of the named target residue groupoid.  Its objects
therefore carry the target residue membership definitionally, and its arrows
are inherited from the ambient source fibre `F_A(X)`.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-- The named full groupoid preimage of `𝓡_A(Y)` under the existing
categorified A-section action `F_A(f)`. -/
abbrev AsectionCResiduePreimage
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :=
  ((IsCResidueState A Y).inverseImage
    (AsectionActionTransport A f)).FullSubcategory

instance (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    Groupoid (AsectionCResiduePreimage A f) :=
  inferInstanceAs
    (Groupoid
      (InducedCategory (AsectionActionFiber A X)
        ObjectProperty.FullSubcategory.obj))

/-- The preimage functor into the named target residue groupoid.  The
landing field is exactly the defining property of an object of the
groupoid preimage. -/
def AsectionCResidueTransport
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    AsectionCResiduePreimage A f ⥤
      InverseImageCResidueStateWorldGroupoid A Y :=
  (IsCResidueState A Y).lift
    (((IsCResidueState A Y).inverseImage
        (AsectionActionTransport A f)).ι ⋙
      AsectionActionTransport A f)
    (fun x => x.property)

/-- The named fully faithful inclusion of the groupoid preimage into the
ambient source fibre `F_A(X)`. -/
def AsectionCResidueInclusion
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    AsectionCResiduePreimage A f ⥤ AsectionActionFiber A X :=
  ((IsCResidueState A Y).inverseImage
    (AsectionActionTransport A f)).ι

/-- The defining commuting square of the groupoid preimage. -/
def AsectionCResidueInclusionSquare
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    AsectionCResidueTransport A f ⋙
        (IsCResidueState A Y).ι ≅
      AsectionCResidueInclusion A f ⋙
        AsectionActionTransport A f :=
  (IsCResidueState A Y).liftCompιIso
    (((IsCResidueState A Y).inverseImage
        (AsectionActionTransport A f)).ι ⋙
      AsectionActionTransport A f)
    (fun x => x.property)

end ASection
