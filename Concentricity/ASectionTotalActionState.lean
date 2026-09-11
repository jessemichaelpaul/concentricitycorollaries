/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ASectionGpvRealFace
import Concentricity.NormalizedBase
import Mathlib.CategoryTheory.Grothendieck

/-!
# The genuine action-generated total

The canonical top-level Grothendieck total of the certified action diagram,
together with its insertion and transport, and the Gate-6 recognition of the
generated residue outputs.

This file contains **only** live, certified material.  The obsolete
point-projection and per-zero north-leg preflights have been removed.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-! ## The genuine action-generated total -/

/-- The accepted action diagram viewed in `Cat`, exactly as required by
the Grothendieck construction. -/
abbrev AsectionActionCatDiagram (A : ASection) :
    GreatCircle.Base ⥤ Cat :=
  AsectionActionDiagram A ⋙ Grpd.forgetToCat

/-- The genuine total category of the complete positioned A-action. -/
abbrev TotalActionStateWorld (A : ASection) :=
  CategoryTheory.Grothendieck (AsectionActionCatDiagram A)

/-- Carry the natural GPV real face of A_A into its existing Grothendieck
total, using the fibre functors and their proved transport compatibility. -/
def totalGpvRealFace (A : ASection) : TotalActionStateWorld A ⥤ Discrete ℝ :=
  CategoryTheory.Grothendieck.functorFrom
    (fun X => (poleGpvRealFace A).app X)
    (fun {X Y} f => eqToHom
      (actionGpvRealFace_transport A A.distinguishedPoleLog
        (orbitStabilizerActionSquare A f)).symm)
    (fun _ => Subsingleton.elim _ _)
    (fun _ _ _ _ _ => Subsingleton.elim _ _)

/-- The total's GPV real face has exactly the value derived in its fibre. -/
theorem totalGpvRealFace_obj (A : ASection) (P : TotalActionStateWorld A) :
    ((totalGpvRealFace A).obj P).as =
      Octonion.re (stateGpvGenerator A A.distinguishedPoleLog P.fiber.input.back) := rfl

theorem totalGpvRealFace_level (A : ASection) (P : TotalActionStateWorld A) :
    ((totalGpvRealFace A).obj P).as = A.distinguishedPoleLog.re :=
  stateGpvGenerator_re A A.distinguishedPoleLog P.fiber.input.back

/-- Insert one action-generated fibre state into the genuine total. -/
def totalMk (A : ASection) (X : GreatCircle.Base)
    (x : AsectionActionFiber A X) : TotalActionStateWorld A :=
  ⟨X, x⟩

@[simp] theorem totalMk_base (A : ASection) (X : GreatCircle.Base)
    (x : AsectionActionFiber A X) :
    (totalMk A X x).base = X := rfl

@[simp] theorem totalMk_fiber (A : ASection) (X : GreatCircle.Base)
    (x : AsectionActionFiber A X) :
    (totalMk A X x).fiber = x := rfl

/-- The canonical cocartesian morphism carrying a total object along a
projective base arrow.  Its target is produced by the already-green action
diagram; no connector or output state is supplied separately. -/
def totalTransport (A : ASection) (X : TotalActionStateWorld A)
    {Y : GreatCircle.Base} (f : X.base ⟶ Y) :
    X ⟶ CategoryTheory.Grothendieck.transport X f :=
  CategoryTheory.Grothendieck.toTransport X f

@[simp] theorem totalTransport_base (A : ASection)
    (X : TotalActionStateWorld A)
    {Y : GreatCircle.Base} (f : X.base ⟶ Y) :
    (totalTransport A X f).base = f := rfl

@[simp] theorem totalTransport_fiber (A : ASection)
    (X : TotalActionStateWorld A)
    {Y : GreatCircle.Base} (f : X.base ⟶ Y) :
    (totalTransport A X f).fiber = 𝟙 _ := rfl

/-! ## Gate 6: recognize the generated residue outputs

The accepted fibre over `X` applies the projective frame of `X` to its
input.  Hence the canonical representative of an already-generated residue
state is its inverse-frame preimage.  Applying the fibre action then returns
the actual residue state, whose value is evaluated by the same A-section
action.  Nothing zero-specific is added to the carrier.
-/

/-- The frame-correct fibre representative whose positioned state is the
actual `n`-th residue state in the slice world `I`. -/
noncomputable def residueActionState (A : ASection)
    (X : GreatCircle.Base) (n : ℕ) (I : SphereWorld) :
    AsectionActionFiber A X :=
  AsectionActionState.ofInput A X
    ((coordinateTransport A (projectiveObjectFrame A X)⁻¹).obj
      ((A.residueState n I : AsectionState A) :
        AsectionStateWorld A))

/-- The inverse-frame representative is positioned back at the actual
action-generated residue state. -/
@[simp] theorem residueActionState_positioned (A : ASection)
    (X : GreatCircle.Base) (n : ℕ) (I : SphereWorld) :
    (residueActionState A X n I).positioned =
      ((A.residueState n I : AsectionState A) :
        AsectionStateWorld A) := by
  change
    (coordinateTransport A (projectiveObjectFrame A X)).obj
        ((coordinateTransport A (projectiveObjectFrame A X)⁻¹).obj
          ((A.residueState n I : AsectionState A) :
            AsectionStateWorld A)) =
      ((A.residueState n I : AsectionState A) :
        AsectionStateWorld A)
  change
    ((coordinateTransport A (projectiveObjectFrame A X)⁻¹ ⋙
        coordinateTransport A (projectiveObjectFrame A X)).obj
      ((A.residueState n I : AsectionState A) :
        AsectionStateWorld A)) =
      ((A.residueState n I : AsectionState A) :
        AsectionStateWorld A)
  rw [coordinateTransport_mul]
  simp [coordinateTransport_one]

/-- The canonical total representative of the `n`-th residue sphere in
the slice world `I`.  As `I` ranges over `SphereWorld`, this is the full
`G₂`-swept residue-sphere family already generated by the action. -/
noncomputable def residueTotal (A : ASection) (n : ℕ)
    (I : SphereWorld) : TotalActionStateWorld A :=
  totalMk A (normalizedFootpoint (A.sphereZero n).re)
    (residueActionState A
      (normalizedFootpoint (A.sphereZero n).re) n I)

@[simp] theorem residueTotal_base (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    (residueTotal A n I).base =
      normalizedFootpoint (A.sphereZero n).re := rfl

/-- The genuine total representative retains the actual residue state as
its positioned face. -/
@[simp] theorem residueTotal_positioned (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    (residueTotal A n I).fiber.positioned =
      ((A.residueState n I : AsectionState A) :
        AsectionStateWorld A) :=
  residueActionState_positioned A _ n I

/-- Evaluating the A-section at an enumerated residue point gives the
compactified octonionic zero.  This is a consequence of the existing C3
stem-zero theorem and the slice realization; it is not carrier data. -/
theorem normalizedSectionPoint_eq_zero (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    A.normalizedSectionPoint n I =
      ((0 : Octonion) : OnePoint Octonion) := by
  have him : 0 < (A.sphereZero n).im :=
    A.c3_sphere_nonreal n
  have hzp : A.sphereZero n ≠ (A.pole : ℂ) := by
    intro h
    rw [h] at him
    simp [Complex.ofReal_im] at him
  have hcoord :
      Octonion.sliceCoord
          (Octonion.sliceEmbed I.val (A.sphereZero n)) =
        A.sphereZero n := by
    rw [Octonion.sliceCoord_sliceEmbed I.prop]
    exact Complex.ext rfl (abs_of_pos him)
  have han :
      AnalyticAt ℂ A.F
        (Octonion.sliceCoord
          (Octonion.sliceEmbed I.val (A.sphereZero n))) := by
    rw [hcoord]
    exact A.c1_analyticAt _ hzp
  rw [normalizedSectionPoint, normalizedZeroPoint, normalizedZeroLift,
    A.realize_coe, if_pos han, hcoord,
    Octonion.dir_sliceEmbed_of_pos I.prop him,
    A.stem_zero_of_sphereZero]
  rw [OnePoint.coe_eq_coe]
  rw [show ((0 : ℂ)) = ((0 : ℝ) : ℂ) by norm_num,
    Octonion.sliceEmbed_ofReal]
  rw [Octonion.ofReal]
  norm_num
  rfl

/-- The value carried by the genuine total representative is zero.  The
value is read from the generated output field after identifying its
positioned face with the actual residue state. -/
@[simp] theorem residueTotal_value_back (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    (residueTotal A n I).fiber.value.back =
      ((0 : Octonion) : OnePoint Octonion) := by
  calc
    (residueTotal A n I).fiber.value.back =
        ((AsectionStateOutput A).obj
          (residueTotal A n I).fiber.positioned).back := by
            rw [(residueTotal A n I).fiber.value_realized]
    _ = ((AsectionStateOutput A).obj
          (((A.residueState n I : AsectionState A) :
            AsectionStateWorld A))).back := by
          rw [residueTotal_positioned]
    _ = A.normalizedSectionPoint n I := A.residueState_output n I
    _ = ((0 : Octonion) : OnePoint Octonion) :=
      normalizedSectionPoint_eq_zero A n I

/-- The positioned representative keeps the chosen sphere direction.
Thus the universally quantified `I` in `residueTotal` is the full
`G₂`-swept family, not one selected slice. -/
@[simp] theorem residueTotal_positioned_world (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    (residueTotal A n I).fiber.positioned.back.world = I := by
  rw [residueTotal_positioned]
  rfl


/-! ## The A-section functor over the A-section's base (master `def:base`)

master `def:base`: the states are transported "by the Möbius transformation
assigned by the already-proved functor `A^slice` and the A-specific GPV
transport".  Over the A-section's base `continuedBase A` — the subgroupoid of
`B` whose morphisms are the real matrices between two points joined by a GPV
transport of the pole-cancelled factor — the transport along a morphism `h`
is the Möbius matrix `A^slice(h)`, and the endpoint actions of any transport
joining its ends are the frames of `A^slice` at those ends
(`GpvTransport.diskExpAction_zero`, `GpvTransport.diskExpAction_one`). -/

/-- `A_A` over the A-section's base: along a real matrix `h : a → b` joined by
a transport of `g_A`, the states move by the Möbius matrix
`P(b) · cayleyProjective(h) · P(a)⁻¹`. -/
def continuedActionDiagram (A : ASection) : (continuedBase A).objs ⥤ Grpd where
  obj X := AsectionActionFiber A X.1
  map f := (Classical.choice f.property).stateTransport f.val
  map_id X := AsectionActionTransport_id A X.1
  map_comp f g := AsectionActionTransport_comp A f.val g.val

/-- The GPV witnesses construct the same action diagram on the continued
base. Equality here includes the whole state functor and preserves the
existing total construction. -/
theorem continuedActionDiagram_eq_restriction (A : ASection) :
    continuedActionDiagram A =
      continuedBaseForget A ⋙ AsectionActionDiagram A := rfl

/-- Any GPV run witnessing a continued-base arrow gives the actual map of
`A_A`; the choice used in the definition does not affect that map. -/
theorem continuedActionDiagram_map_eq_gpv (A : ASection)
    {X Y : (continuedBase A).objs} (f : X ⟶ Y)
    (τ : GpvTransport A X.1 Y.1) :
    (continuedActionDiagram A).map f = τ.stateTransport f.val := by
  exact GpvTransport.stateTransport_independent _ τ f.val

/-- `T_A` over the A-section's base. -/
abbrev ContinuedTotal (A : ASection) :=
  CategoryTheory.Grothendieck (continuedActionDiagram A ⋙ Grpd.forgetToCat)

/-- The same total real face on the continued base, using the established
base-forgetful functor and Grothendieck's base-change construction. -/
def continuedTotalGpvRealFace (A : ASection) : ContinuedTotal A ⥤ Discrete ℝ :=
  CategoryTheory.Grothendieck.pre (AsectionActionCatDiagram A)
    (continuedBaseForget A) ⋙ totalGpvRealFace A

/-- The real level of the unique real GPV fibre at an object of the
A-section's base: `log ‖g_A(b)‖`, the real part shared by every logarithm of
`g_A(b)` (master `lem:real-level`, `rmk:gpv-real-fibre`).  At the pole it is
`Re λ_A`. -/
noncomputable def baseLevel (A : ASection) (X : (continuedBase A).objs) : ℝ :=
  Real.log ‖(A.poleFactorUnit X.1 : ℂ)‖

/-- At an object of the base with point `x`, the unit is `g_A(x)`. -/
theorem poleFactorUnit_of_mem (A : ASection) (X : (continuedBase A).objs)
    {x : ℝ} (hX : CategoryTheory.ActionCategory.back X.1 = (x : GreatCircle.Point))
    (hx : A.distinguishedPoleFactor (x : ℂ) ≠ 0) :
    (A.poleFactorUnit X.1 : ℂ) = A.distinguishedPoleFactor (x : ℂ) := by
  have hXeq : X.1 = ((x : GreatCircle.Point) : GreatCircle.Base) := by
    obtain ⟨X, _⟩ := X
    cases X
    cases hX
    rfl
  rw [hXeq, poleFactorUnit_coe A x hx]
  rfl

/-- The level at the source of a transport is the real part of its lift at
the start. -/
theorem baseLevel_eq_lift_zero (A : ASection) {X Y : (continuedBase A).objs}
    (τ : GpvTransport A X.1 Y.1) :
    baseLevel A X = (τ.lift 0).re := by
  obtain ⟨x, hX, hx⟩ := τ.exists_source_point
  have hne : A.distinguishedPoleFactor (x : ℂ) ≠ 0 := by
    rw [← hx, ← τ.value_eq 0]; exact τ.value_ne_zero 0
  rw [baseLevel, poleFactorUnit_of_mem A X hX hne, τ.level 0, τ.value_eq 0, hx]

/-- The level at the target of a transport is the real part of its lift at
the end. -/
theorem baseLevel_eq_lift_one (A : ASection) {X Y : (continuedBase A).objs}
    (τ : GpvTransport A X.1 Y.1) :
    baseLevel A Y = (τ.lift 1).re := by
  obtain ⟨y, hY, hy⟩ := τ.exists_target_point
  have hne : A.distinguishedPoleFactor (y : ℂ) ≠ 0 := by
    rw [← hy, ← τ.value_eq 1]; exact τ.value_ne_zero 1
  rw [baseLevel, poleFactorUnit_of_mem A Y hY hne, τ.level 1, τ.value_eq 1, hy]

/-- At the pole the level is `Re λ_A`. -/
theorem baseLevel_pole (A : ASection) :
    baseLevel A (continuedPole A) = A.distinguishedPoleLog.re := by
  have h := poleFactorUnit_of_mem A (continuedPole A) rfl A.distinguishedPoleFactor_ne_zero
  rw [baseLevel, h, ← A.exp_distinguishedPoleLog, Complex.norm_exp, Real.log_exp]

/-- The read on `T_A` over the A-section's base: the real level of the unique
real GPV fibre at the object's base point. -/
noncomputable def totalLevelRead (A : ASection) (P : ContinuedTotal A) : ℝ :=
  baseLevel A P.base

/-- **The kernel's criterion.** Along a morphism of the A-section's base from
`X` to `Y`, joined by the transport `τ`, the level read is preserved exactly
when the norms of `g_A` at the two ends agree — the two ends of the lift have
the same real part exactly when the two values have the same norm
(`lem:real-level`: `Re Γ(t) = log ‖v(t)‖`). -/
theorem baseLevel_eq_iff (A : ASection) {X Y : (continuedBase A).objs}
    (τ : GpvTransport A X.1 Y.1) :
    baseLevel A X = baseLevel A Y ↔ ‖τ.value 0‖ = ‖τ.value 1‖ := by
  rw [baseLevel_eq_lift_zero A τ, baseLevel_eq_lift_one A τ, τ.level 0, τ.level 1]
  constructor
  · intro h
    exact Real.log_injOn_pos (Set.mem_Ioi.mpr (norm_pos_iff.mpr (τ.value_ne_zero 0)))
      (Set.mem_Ioi.mpr (norm_pos_iff.mpr (τ.value_ne_zero 1))) h
  · intro h
    rw [h]

/- The next gate, not this one, consumes the native northward zigzags and
applies the component/colimit machinery to these recognized inhabitants. -/

end ASection
