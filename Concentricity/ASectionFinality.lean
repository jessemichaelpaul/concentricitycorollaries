/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ASectionTotalActionState
import Concentricity.Theorem
import Mathlib.CategoryTheory.Limits.Final

/-!
# The intrinsic C-residue north family

Gate 7 has two categorical stages.  This file first manifests the already
proved normalized GPV north square as the actual transport used by the
accepted action diagram.  It then applies finality to that intrinsic family
and, separately, the Grothendieck-components equivalence.

No zero carrier or zero-only action diagram is introduced here.  The
inhabitants are the existing `residueTotal A n I`, and the categorical legs
are the existing Grothendieck transports whose action-square provenance is
proved below.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-- Re-express an action state `m` as the same positioned action with a
right-hand factor `d` absorbed into its input coordinate.  The positioned
output is unchanged; only the input presentation changes. -/
def ActionTransportSquare.introduceRightFactor (m d : Moebius) :
    ActionTransportSquare m (m * d) where
  left := 1
  right := d⁻¹
  commutes := by simp

/-- Remove a right-hand action factor from the action-state presentation.
This is the inverse reparametrization to `introduceRightFactor`. -/
def ActionTransportSquare.removeRightFactor (m d : Moebius) :
    ActionTransportSquare (m * d) m where
  left := 1
  right := d
  commutes := by simp

/-- The accepted orbit--stabilizer transport to `N` is exactly the
categorical manifestation of the normalized GPV north square.

The first square absorbs the source GPV multiplier into the input
presentation, `normalizedNActionSquare` carries the complete action tape to
the north chart, and the last square removes the (equal) endpoint
multiplier.  Closedness of the lift identifies the two endpoint
multipliers, leaving precisely the native north-stabilizer leg used by
`AsectionActionDiagram`. -/
theorem normalizedNActionSquare_factors_orbitStabilizer
    (A : ASection) (n : ℕ) (I : SphereWorld) :
    let X := normalizedFootpoint (A.sphereZero n).re
    let N := GreatCircle.pointObj
      (OnePoint.infty : GreatCircle.Point)
    let tape := A.normalizedNActionTape n I
    let d₀ := GreatCircle.diskExpAction (tape.lift 0)
    let d₁ := GreatCircle.diskExpAction (tape.lift 1)
    orbitStabilizerActionSquare A (A.normalizedNBaseHom n) =
      ((ActionTransportSquare.introduceRightFactor
          (projectiveObjectFrame A X) d₀).comp
        (A.normalizedNActionSquare n I)).comp
          (ActionTransportSquare.removeRightFactor
            (projectiveObjectFrame A N) d₁) := by
  dsimp only
  apply ActionTransportSquare.ext
  · simp [ActionTransportSquare.comp,
      ActionTransportSquare.introduceRightFactor,
      ActionTransportSquare.removeRightFactor,
      orbitStabilizerActionSquare]
  ·
    have hclosed :
        GreatCircle.diskExpAction
            ((A.normalizedNActionTape n I).lift 1) =
          GreatCircle.diskExpAction
            ((A.normalizedNActionTape n I).lift 0) := by
      exact congrArg GreatCircle.diskExpAction
        (A.normalizedNActionTape n I).lift_closed
    simp [ActionTransportSquare.comp,
      ActionTransportSquare.introduceRightFactor,
      ActionTransportSquare.removeRightFactor,
      orbitStabilizerActionSquare, hclosed, mul_assoc]

/-- On the accepted value-state fibres, the native north transport is the
three-square composite consisting of input reparametrization, the genuine
normalized GPV north square, and endpoint reparametrization at `N`. -/
theorem normalizedNActionTransport_factorization
    (A : ASection) (n : ℕ) (I : SphereWorld) :
    let X := normalizedFootpoint (A.sphereZero n).re
    let N := GreatCircle.pointObj
      (OnePoint.infty : GreatCircle.Point)
    let tape := A.normalizedNActionTape n I
    let d₀ := GreatCircle.diskExpAction (tape.lift 0)
    let d₁ := GreatCircle.diskExpAction (tape.lift 1)
    AsectionActionTransport A (A.normalizedNBaseHom n) =
      ((ActionTransportSquare.introduceRightFactor
            (projectiveObjectFrame A X) d₀).actionStateTransport A ⋙
        (A.normalizedNActionSquare n I).actionStateTransport A) ⋙
          (ActionTransportSquare.removeRightFactor
            (projectiveObjectFrame A N) d₁).actionStateTransport A := by
  dsimp only
  rw [AsectionActionTransport,
    normalizedNActionSquare_factors_orbitStabilizer A n I]
  rw [ActionTransportSquare.actionStateTransport_comp,
    ActionTransportSquare.actionStateTransport_comp]

/-- The north endpoint of the existing C-residue representative under its
own accepted categorical north transport. -/
noncomputable def residueNorthTotal (A : ASection) (n : ℕ)
    (I : SphereWorld) : TotalActionStateWorld A :=
  CategoryTheory.Grothendieck.transport (residueTotal A n I)
    (A.normalizedNBaseHom n)

/-- The genuine categorical north leg of the `n`-th realized residue
sphere.  Its action-square content is
`normalizedNActionTransport_factorization`; no morphism is selected or
installed separately. -/
noncomputable def residueToNorth (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    residueTotal A n I ⟶ residueNorthTotal A n I :=
  totalTransport A (residueTotal A n I) (A.normalizedNBaseHom n)

@[simp] theorem residueNorthTotal_base (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    (residueNorthTotal A n I).base =
      GreatCircle.pointObj
        (OnePoint.infty : GreatCircle.Point) := rfl

/-- The north endpoint is the complete value-state produced by applying
the accepted action transport to the existing residue representative.
This is the full image in the fibre over `N`, not merely its base
projection. -/
@[simp] theorem residueNorthTotal_fiber (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    (residueNorthTotal A n I).fiber =
      (AsectionActionTransport A (A.normalizedNBaseHom n)).obj
        (residueTotal A n I).fiber := rfl

/-- The input eye of the internal north image is transported by the right
leg of the same orbit--stabilizer square. -/
@[simp] theorem residueNorthTotal_input (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    (residueNorthTotal A n I).fiber.input =
      (coordinateTransport A
        (orbitStabilizerActionSquare
          A (A.normalizedNBaseHom n)).right).obj
        (residueTotal A n I).fiber.input := rfl

/-- The positioned eye of the internal north image is transported by the
left leg of the same orbit--stabilizer square. -/
@[simp] theorem residueNorthTotal_positioned (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    (residueNorthTotal A n I).fiber.positioned =
      (coordinateTransport A
        (orbitStabilizerActionSquare
          A (A.normalizedNBaseHom n)).left).obj
        (residueTotal A n I).fiber.positioned := rfl

/-- The value eye at the internal north image is still generated by
evaluating the one A-section action on its transported positioned state. -/
@[simp] theorem residueNorthTotal_value (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    (residueNorthTotal A n I).fiber.value =
      (AsectionStateOutput A).obj
        (residueNorthTotal A n I).fiber.positioned := rfl

@[simp] theorem residueToNorth_base (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    (residueToNorth A n I).base =
      A.normalizedNBaseHom n := rfl

/-- The component witness contributed by the genuine north morphism. -/
noncomputable def residueNorthZigzag (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    Zigzag (residueTotal A n I) (residueNorthTotal A n I) :=
  Zigzag.of_hom (residueToNorth A n I)

/-- The real register is carried by the very same indexed north leg whose
categorical manifestation is `residueToNorth`. -/
theorem residueToNorth_level (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    ((A.normalizedNActionTape n I).lift 0).re =
      ((A.normalizedNActionTape n I).lift 1).re :=
  A.normalizedNActionSquare_level n I

end ASection
