/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ASectionActionDiagram
import Concentricity.NormalizedBase
import Mathlib.CategoryTheory.Grothendieck

/-!
# QUARANTINED preflight totals — not the genuine total

**Nothing in this file is on a live path.**  It holds the two superseded
attempts at an A-section total, kept as an explicit record of what was tried
and why it was set aside:

* `ASection.PointProjection` — the normalized point-graph projection.  It
  retains only the projected point, so the value tape, lift, winding and
  level never board.
* `ASection.JuxtapositionPreflight` — the Cartesian
  `state × presentation` total.  It leaves the physical state and the GPV
  presentation independently chosen and unbound, so it cannot serve as a
  binding theorem between the two transports.

Neither preflight is an input to the genuine total, to the residue
subdiagram gate, or to any component or readout argument.  Note that
`JuxtapositionPreflight` shadows the names `totalMk` and `residueTotal`;
those shadows are confined to this file.

The genuine total is
`A.TotalActionStateWorld = ∫ (AsectionActionDiagram A)` in
`Concentricity/ASectionTotalActionState.lean`.  Import that file, never this
one.
-/

noncomputable section

open CategoryTheory

namespace ASection

namespace PointProjection

/-- The total category of the normalized point-graph projection. -/
abbrev AsectionPointTotal (A : ASection) :=
  CategoryTheory.Grothendieck
    ((AsectionPointProjection A) ⋙ CategoryTheory.Grpd.forgetToCat)

/-- Insert a normalized A-state into the fibre over a projective-base
object. -/
def totalState (A : ASection) (b : GreatCircle.Base)
    (x : AsectionState A) : AsectionPointTotal A :=
  ⟨b, (x : AsectionStateWorld A)⟩

@[simp] theorem totalState_base (A : ASection) (b : GreatCircle.Base)
    (x : AsectionState A) :
    (totalState A b x).base = b := rfl

@[simp] theorem totalState_fiber_back (A : ASection) (b : GreatCircle.Base)
    (x : AsectionState A) :
    CategoryTheory.ActionCategory.back (totalState A b x).fiber = x := rfl

/-- The normalized octonionic input retained by an object of the point
projection total. -/
def totalInput (A : ASection) (X : AsectionPointTotal A) : OnePoint Octonion :=
  X.fiber.back.input

/-- The A-generated octonionic output retained by an object of the point
projection total. -/
def totalOutput (A : ASection) (X : AsectionPointTotal A) : OnePoint Octonion :=
  X.fiber.back.output

@[simp] theorem totalState_input (A : ASection) (b : GreatCircle.Base)
    (x : AsectionState A) :
    totalInput A (totalState A b x) = x.input := rfl

@[simp] theorem totalState_output (A : ASection) (b : GreatCircle.Base)
    (x : AsectionState A) :
    totalOutput A (totalState A b x) = x.output := rfl

/-- A full realized residue-`ℂ` sphere output, placed over its own
projective footpoint. -/
def residuePointTotal (A : ASection) (n : ℕ) (I : SphereWorld) :
    AsectionPointTotal A :=
  totalState A (normalizedFootpoint (A.sphereZero n).re)
    (A.residueState n I)

@[simp] theorem residuePointTotal_base (A : ASection) (n : ℕ) (I : SphereWorld) :
    (residuePointTotal A n I).base =
      normalizedFootpoint (A.sphereZero n).re := rfl

@[simp] theorem residuePointTotal_input (A : ASection) (n : ℕ) (I : SphereWorld) :
    totalInput A (residuePointTotal A n I) =
      A.normalizedZeroPoint n I := by
  exact A.residueState_input n I

@[simp] theorem residuePointTotal_output (A : ASection) (n : ℕ) (I : SphereWorld) :
    totalOutput A (residuePointTotal A n I) =
      A.normalizedSectionPoint n I := by
  exact A.residueState_output n I

/-- The intrinsic real register of each represented residue sphere is
retained by its normalized input state in the point projection total. -/
theorem residuePointTotal_real_register (A : ASection) (n : ℕ) (I : SphereWorld) :
    Octonion.re (A.normalizedZeroLift n I) =
      (A.sphereZero n).re :=
  A.normalizedZeroLift_re n I

/-- C4 remains the infinitude certificate for this represented
population. -/
theorem residuePointTotal_population_infinite (A : ASection) :
    (Set.range A.sphereZero).Infinite :=
  A.c4_infinite

/-- The represented sphere inputs approach the common compactified north
point uniformly in the sphere direction. -/
theorem residuePointTotal_collapse_at_N (A : ASection) (R : ℝ) :
    ∀ᶠ n in Filter.atTop, ∀ I : SphereWorld,
      R < Octonion.norm (A.normalizedZeroLift n I) :=
  A.normalizedZero_collapse_at_N R

end PointProjection


/-! ## Quarantined Cartesian-product total

This block totalizes `JuxtapositionPreflight.AsectionFunctor`. It is kept as
a compiling preflight and deliberately nested so
`ASection.TotalActionStateWorld` cannot resolve to it. -/

namespace JuxtapositionPreflight

/-- The Grothendieck construction of the quarantined product diagram. -/
abbrev TotalA (A : ASection) :=
  CategoryTheory.Grothendieck
    ((AsectionFunctor A) ⋙ CategoryTheory.Grpd.forgetToCat)

/-- Insert one product-preflight fibre state into its quarantined total. -/
def totalMk (A : ASection) (b : GreatCircle.Base)
    (x : AsectionFiberType A b) : TotalA A :=
  ⟨b, x⟩

@[simp] theorem totalMk_base (A : ASection) (b : GreatCircle.Base)
    (x : AsectionFiberType A b) :
    (totalMk A b x).base = b := rfl

@[simp] theorem totalMk_fiber (A : ASection) (b : GreatCircle.Base)
    (x : AsectionFiberType A b) :
    (totalMk A b x).fiber = x := rfl

/-- The normalized octonionic input retained by a product-total object. -/
def totalInput (A : ASection) (X : TotalA A) : OnePoint Octonion :=
  X.fiber.1.back.input

/-- The output produced by `A.realize` and retained by the same total
object.  It is computed from the physical state, not installed as a label. -/
def totalOutput (A : ASection) (X : TotalA A) : OnePoint Octonion :=
  AsectionFiberOutput A X.fiber

/-- The complete Euler--Weierstrass--GPV presentation retained by a genuine
total object. -/
def totalPresentation (A : ASection) (X : TotalA A) :
    AsectionPresentation A X.base :=
  X.fiber.2.as

@[simp] theorem totalOutput_eq_realize (A : ASection) (X : TotalA A) :
    totalOutput A X = A.realize (totalInput A X) :=
  AsectionFiberOutput_eq_realize A X.fiber

/-- A physical residue state paired with the canonical presentation in the
product total. This juxtaposition does not yet certify generation. -/
noncomputable def residueTotal (A : ASection) (n : ℕ) (I : SphereWorld) :
    TotalA A :=
  totalMk A (normalizedFootpoint (A.sphereZero n).re)
    (residueFiberState A
      (normalizedFootpoint (A.sphereZero n).re) n I)

@[simp] theorem residueTotal_base (A : ASection) (n : ℕ) (I : SphereWorld) :
    (residueTotal A n I).base =
      normalizedFootpoint (A.sphereZero n).re := rfl

@[simp] theorem residueTotal_input (A : ASection) (n : ℕ) (I : SphereWorld) :
    totalInput A (residueTotal A n I) =
      A.normalizedZeroPoint n I :=
  residueFiberState_input A
    (normalizedFootpoint (A.sphereZero n).re) n I

@[simp] theorem residueTotal_output (A : ASection) (n : ℕ) (I : SphereWorld) :
    totalOutput A (residueTotal A n I) =
      A.normalizedSectionPoint n I :=
  residueFiberState_output A
    (normalizedFootpoint (A.sphereZero n).re) n I

@[simp] theorem residueTotal_presentation (A : ASection)
    (n : ℕ) (I : SphereWorld) :
    totalPresentation A (residueTotal A n I) =
      canonicalAsectionPresentation A
        (normalizedFootpoint (A.sphereZero n).re) := rfl

/-- The real register visible on the physical side of the product total. -/
theorem residueTotal_real_register (A : ASection) (n : ℕ) (I : SphereWorld) :
    Octonion.re (A.normalizedZeroLift n I) =
      (A.sphereZero n).re :=
  A.normalizedZeroLift_re n I

/-- C4 supplies the infinite population represented in the product total. -/
theorem residueTotal_population_infinite (A : ASection) :
    (Set.range A.sphereZero).Infinite :=
  A.c4_infinite

/-- C1/C3 supply the uniform approach of the represented residue-sphere
inputs to the compactified north point. -/
theorem residueTotal_collapse_at_N (A : ASection) (R : ℝ) :
    ∀ᶠ n in Filter.atTop, ∀ I : SphereWorld,
      R < Octonion.norm (A.normalizedZeroLift n I) :=
  A.normalizedZero_collapse_at_N R

/-- The canonical branch in the product total generated by a base arrow.
Its target is exactly the whole fibre state produced by
`AsectionFunctor.map`; the fibre component is the identity on that produced
state. -/
def totalTransport (A : ASection) (X : TotalA A)
    {Y : GreatCircle.Base} (f : X.base ⟶ Y) :
    X ⟶ CategoryTheory.Grothendieck.transport X f :=
  CategoryTheory.Grothendieck.toTransport X f

@[simp] theorem totalTransport_base (A : ASection) (X : TotalA A)
    {Y : GreatCircle.Base} (f : X.base ⟶ Y) :
    (totalTransport A X f).base = f := rfl

@[simp] theorem totalTransport_fiber (A : ASection) (X : TotalA A)
    {Y : GreatCircle.Base} (f : X.base ⟶ Y) :
    (totalTransport A X f).fiber = 𝟙 _ := rfl

/-- The full target state obtained by transporting the `n`-th represented
residue sphere along its own orbit--stabilizer branch to `N`.

The target remains indexed by `n`; no common value or common centre is
assumed here. -/
noncomputable def residueNorthTotal (A : ASection)
    (n : ℕ) (I : SphereWorld) : TotalA A :=
  CategoryTheory.Grothendieck.transport (residueTotal A n I)
    (orbitHomToNorth (normalizedFootpoint (A.sphereZero n).re))

/-- The product-total branch from a paired residue state to its transported
north state. -/
noncomputable def residueToNorth (A : ASection)
    (n : ℕ) (I : SphereWorld) :
    residueTotal A n I ⟶ residueNorthTotal A n I :=
  totalTransport A (residueTotal A n I)
    (orbitHomToNorth (normalizedFootpoint (A.sphereZero n).re))

@[simp] theorem residueNorthTotal_base (A : ASection)
    (n : ℕ) (I : SphereWorld) :
    (residueNorthTotal A n I).base = projectiveNorth := rfl

@[simp] theorem residueToNorth_base (A : ASection)
    (n : ℕ) (I : SphereWorld) :
    (residueToNorth A n I).base =
      orbitHomToNorth (normalizedFootpoint (A.sphereZero n).re) := rfl

@[simp] theorem residueNorthTotal_input (A : ASection)
    (n : ℕ) (I : SphereWorld) :
    totalInput A (residueNorthTotal A n I) =
      A.normalizedZeroPoint n I := rfl

@[simp] theorem residueNorthTotal_output (A : ASection)
    (n : ℕ) (I : SphereWorld) :
    totalOutput A (residueNorthTotal A n I) =
      A.normalizedSectionPoint n I := rfl

@[simp] theorem residueNorthTotal_presentation (A : ASection)
    (n : ℕ) (I : SphereWorld) :
    totalPresentation A (residueNorthTotal A n I) =
      reindexAsectionPresentation A
        (orbitHomToNorth (normalizedFootpoint (A.sphereZero n).re))
        (canonicalAsectionPresentation A
          (normalizedFootpoint (A.sphereZero n).re)) := rfl

end JuxtapositionPreflight

end ASection
