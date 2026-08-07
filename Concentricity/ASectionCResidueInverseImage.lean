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

`𝓡_A(X)` at an arbitrary frame is the image of that square under the same
A-specific action functor: an object belongs when it is the image under
`AsectionActionTransport A g` for a base arrow `g : projectiveNorth ⟶ X`.

Thus the base arrow and the action on objects and arrows are part of the
groupoid preimage itself.  No external fixed carrier is tested after
transport, and cross-frame closure is composition in the base groupoid.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-! ## The semantic input groupoid locus

The residue equation selects the positioned coordinate `D_A(u)`, but the
object which the action transports is its input `u`.  The base of the residue
total is therefore the inverse-image **groupoid locus** of those inputs, not
the projective object at which the equation happened to be read.
-/

/-- Input coordinates whose image under the one distinguished
Euler--Weierstrass disk action is an authored semantic C-residue coordinate. -/
def IsCResidueInput (A : ASection) :
    ObjectProperty (CategoryTheory.ActionCategory Moebius (OnePoint ℂ)) :=
  fun u =>
    ∃ z : ℂ, z ∈ A.CResidueZeroLocus ∧
      A.distinguishedDiskAction.val
        (CategoryTheory.ActionCategory.back u) = (z : OnePoint ℂ)

/-- The semantic C-residue inverse-image groupoid locus.  Its arrows are the
native Möbius input transports; the distinguished disk action transports those
arrows by conjugation on the positioned face. -/
abbrev CResidueInputWorld (A : ASection) :=
  (IsCResidueInput A).FullSubcategory

instance (A : ASection) : Groupoid (CResidueInputWorld A) :=
  inferInstanceAs
    (Groupoid
      (InducedCategory
        (CategoryTheory.ActionCategory Moebius (OnePoint ℂ))
        ObjectProperty.FullSubcategory.obj))

namespace CResidueInputBase

/-- A complex projective representative carrying a finite input to the
compactified point at infinity. -/
def toInfinityGL (z : ℂ) : GL (Fin 2) ℂ :=
  Matrix.GeneralLinearGroup.mkOfDetNeZero !![0, 1; 1, -z] (by
    rw [Matrix.det_fin_two_of]
    norm_num)

@[simp] theorem toInfinityGL_val (z : ℂ) :
    (toInfinityGL z).val = !![0, 1; 1, -z] := rfl

theorem toInfinityGL_smul (z : ℂ) :
    toInfinityGL z • (z : OnePoint ℂ) = OnePoint.infty := by
  rw [OnePoint.smul_some_eq_ite]
  simp [toInfinityGL_val]

/-- A complex projective representative carrying infinity to a finite
input. -/
def fromInfinityGL (z : ℂ) : GL (Fin 2) ℂ :=
  Matrix.GeneralLinearGroup.mkOfDetNeZero !![z, -1; 1, 0] (by
    rw [Matrix.det_fin_two_of]
    norm_num)

@[simp] theorem fromInfinityGL_val (z : ℂ) :
    (fromInfinityGL z).val = !![z, -1; 1, 0] := rfl

theorem fromInfinityGL_smul (z : ℂ) :
    fromInfinityGL z • (OnePoint.infty : OnePoint ℂ) = (z : OnePoint ℂ) := by
  rw [OnePoint.smul_infty_eq_ite]
  simp [fromInfinityGL_val]

/-- The native Möbius representative carrying an arbitrary input to
infinity. -/
def toInfinity : OnePoint ℂ → Moebius :=
  OnePoint.rec 1 (fun z => Moebius.of (toInfinityGL z))

theorem toInfinity_spec (u : OnePoint ℂ) :
    (toInfinity u).val u = OnePoint.infty := by
  induction u using OnePoint.rec with
  | infty => rfl
  | coe z =>
      change toInfinityGL z • (z : OnePoint ℂ) = OnePoint.infty
      exact toInfinityGL_smul z

/-- The native Möbius representative carrying infinity to an arbitrary
input. -/
def fromInfinity : OnePoint ℂ → Moebius :=
  OnePoint.rec 1 (fun z => Moebius.of (fromInfinityGL z))

theorem fromInfinity_spec (u : OnePoint ℂ) :
    (fromInfinity u).val OnePoint.infty = u := by
  induction u using OnePoint.rec with
  | infty => rfl
  | coe z =>
      change fromInfinityGL z • (OnePoint.infty : OnePoint ℂ) =
        (z : OnePoint ℂ)
      exact fromInfinityGL_smul z

/-- The native Möbius arrow between two arbitrary compactified complex
inputs. -/
def transport (u v : OnePoint ℂ) : Moebius :=
  fromInfinity v * toInfinity u

theorem transport_spec (u v : OnePoint ℂ) :
    (transport u v).val u = v := by
  change (fromInfinity v).val ((toInfinity u).val u) = v
  rw [toInfinity_spec, fromInfinity_spec]

end CResidueInputBase

/-- The base morphism between two arbitrary objects of the semantic
C-residue inverse-image groupoid locus. -/
def CResidueInputHom (A : ASection) (u v : CResidueInputWorld A) : u ⟶ v :=
  ObjectProperty.homMk
    (show u.obj ⟶ v.obj from
      ⟨CResidueInputBase.transport u.obj.back v.obj.back,
        CResidueInputBase.transport_spec u.obj.back v.obj.back⟩)

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
