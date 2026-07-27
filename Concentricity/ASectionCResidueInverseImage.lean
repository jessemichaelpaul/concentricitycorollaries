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

The equation selects at exactly one frame, and that frame is not a point.
At `projectiveNorth` the positioning factor is trivial, so the frame **is**
the distinguished element itself:

```text
projectiveObjectFrame_north :
  projectiveObjectFrame A (pointObj ∞) = distinguishedDiskAction A
```

and that element holds *both* boundary faces —
`distinguishedDiskAction_fixes_cayley_zero` and
`distinguishedDiskAction_fixes_cayley_N`.  So what the already-certified
semantic locus `CResidueZeroLocus A` selects there is the whole `0`-to-`N`
core: Euler presenting at `0`, Weierstrass at `N`, the square spanning them.

⛔ **Do not read this as "the residues at the north point."**  The selected
object is that square, and `𝓡_A(X)` at an arbitrary frame is the image of
the square under the same A-specific action functor — an object belongs when
it is the image under `AsectionActionTransport A g` for a base arrow
`g : projectiveNorth ⟶ X`.  Reading it as a plural of points manufactures a
"join the distinct zeros" obligation that the author struck: if the selected
object is the square, there is nothing to join.  The point-reading is weaker
than what is triple-certified here.

Thus the base arrow and the action on objects and arrows are part of the
groupoid preimage itself.  No external fixed carrier is tested after
transport, and cross-frame closure is composition in the base groupoid.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-- The semantic C-residue objects in the fibre over `projectiveNorth` — the
frame at which `projectiveObjectFrame A` *is* `distinguishedDiskAction A`,
holding both fixed faces, so this fibre carries the whole `0`-to-`N` core
rather than a point.  This is the only place the intrinsic equation selects
objects; everywhere else the action carries the selection. -/
def IsNorthCResidueState (A : ASection) :
    ObjectProperty (AsectionActionFiber A projectiveNorth) :=
  fun x =>
    x ∈
      (fun y : AsectionActionFiber A projectiveNorth =>
          y.positioned.back.coordinate) ⁻¹'
        ((fun z : ℂ => (z : OnePoint ℂ)) '' A.CResidueZeroLocus)

/-- The orbitwise groupoid preimage, under the already-certified A-specific
action diagram, of the `0`-to-`N` core selected at `projectiveNorth`.  The
witness arrow is data of the preimage over the base groupoid, so subsequent
transport is composition, not a separate preservation theorem. -/
def IsCResidueState (A : ASection) (X : GreatCircle.Base) :
    ObjectProperty (AsectionActionFiber A X) :=
  fun x =>
    ∃ xN : AsectionActionFiber A projectiveNorth,
      IsNorthCResidueState A xN ∧
        ∃ g : projectiveNorth ⟶ X,
          (AsectionActionTransport A g).obj xN = x

/-- The full orbit subgroupoid on the A-action images of the semantic
`0`-to-`N` core.  A separately bundled groupoid, never a subset of
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

end ASection
