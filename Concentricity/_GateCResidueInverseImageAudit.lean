import Concentricity.ASectionCResidueInverseImage

noncomputable section

open CategoryTheory

namespace ASection

/-!
Focused kernel receipt for the framewise C-residue orbit preimage
`InverseImageCResidueStateWorldGroupoid A X`.

The semantic locus selects at the north frame — the whole `0`-to-`N` frame:
there the positioned element is the distinguished action itself, carrying
both fixed boundary faces. Membership at an arbitrary frame is the action's
own image with the base arrow as data; cross-frame closure is composition.
This file audits the object layer only.
-/

#check InverseImageCResidueStateWorldGroupoid
#check IsCResidueState
#check IsNorthCResidueState

/- The exact types. -/
example (A : ASection) (X : GreatCircle.Base) :
    InverseImageCResidueStateWorldGroupoid A X =
      (IsCResidueState A X).FullSubcategory :=
  rfl

/- The whole 0-to-N frame: at the north object the positioned frame is the
distinguished element itself, and it fixes both boundary faces. -/
#check @ASection.projectiveObjectFrame_north
#check @ASection.distinguishedDiskAction_fixes_cayley_zero
#check @ASection.distinguishedDiskAction_fixes_cayley_N

/- Membership carries the action's own witness arrow as data. -/
example (A : ASection) (X : GreatCircle.Base)
    (x : InverseImageCResidueStateWorldGroupoid A X) :
    ∃ xN : AsectionActionFiber A projectiveNorth,
      IsNorthCResidueState A xN ∧
        ∃ g : projectiveNorth ⟶ X,
          (AsectionActionTransport A g).obj xN = x.obj :=
  x.property

/- A semantic locus point yields a north residue state: the inverse-frame
representative of the intrinsic equation's own zero. -/
example (A : ASection) (I : SphereWorld) (z : ℂ)
    (hz : z ∈ A.CResidueZeroLocus) :
    { xN : AsectionActionFiber A projectiveNorth //
        IsNorthCResidueState A xN } := by
  refine ⟨AsectionActionState.ofInput A projectiveNorth
      ((coordinateTransport A (projectiveObjectFrame A projectiveNorth)⁻¹).obj
        (({ world := I, coordinate := (z : OnePoint ℂ) } :
            AsectionState A) : AsectionStateWorld A)), ⟨z, hz, ?_⟩⟩
  change
    (z : OnePoint ℂ) =
      (projectiveObjectFrame A projectiveNorth).val
        ((projectiveObjectFrame A projectiveNorth)⁻¹.val (z : OnePoint ℂ))
  simp

/- Every north residue state is a member at the north frame through the
identity arrow: the fibres are inhabited at the anchor. -/
example (A : ASection) (xN : AsectionActionFiber A projectiveNorth)
    (hxN : IsNorthCResidueState A xN) :
    InverseImageCResidueStateWorldGroupoid A projectiveNorth := by
  refine ⟨xN, xN, hxN, 𝟙 projectiveNorth, ?_⟩
  exact congrArg (fun F => F.obj xN)
    (AsectionActionTransport_id A projectiveNorth)

/- Members spread to every frame by the action's own transport: the fibres
are inhabited everywhere the base groupoid reaches. -/
example (A : ASection) (X : GreatCircle.Base)
    (g : projectiveNorth ⟶ X)
    (xN : AsectionActionFiber A projectiveNorth)
    (hxN : IsNorthCResidueState A xN) :
    InverseImageCResidueStateWorldGroupoid A X :=
  ⟨(AsectionActionTransport A g).obj xN, xN, hxN, g, rfl⟩

/- The inherited groupoid structure, with the G₂ arrow retained. -/
example (A : ASection) (X : GreatCircle.Base) :
    Groupoid (InverseImageCResidueStateWorldGroupoid A X) :=
  inferInstance

example (A : ASection) (X : GreatCircle.Base)
    (x y : InverseImageCResidueStateWorldGroupoid A X)
    (f : x ⟶ y) :
    G2 :=
  f.hom.hom.val

#print axioms ASection.InverseImageCResidueStateWorldGroupoid
#print axioms ASection.IsCResidueState
#print axioms ASection.IsNorthCResidueState

end ASection
