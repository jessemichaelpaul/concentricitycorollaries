/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ProjectiveBase
import Concentricity.SliceSphereWorld
import Concentricity.Toolkit
import Mathlib.Analysis.Complex.UnitDisc.Basic

/-!
# The Cayley dictionary for the distinguished section transport

The locked base carrier is already the compactified real circle
`OnePoint ℝ`.  This file supplies the explicit Cayley coordinate change
used by the distinguished Möbius family; it does not replace the base.

The first half of the dictionary is the matrix of

`z ↦ (z - i) / (z + i)`.

It sends the compactified real point `∞` to the circle point `1`.  The
second half identifies the phase in every slice world with the existing
band endomorphism through the slice exponential.
-/

noncomputable section

open scoped MatrixGroups

namespace GreatCircle

/-- The complex Cayley matrix, acting by `z ↦ (z - i) / (z + i)`. -/
def cayleyGL : GL (Fin 2) ℂ :=
  Matrix.GeneralLinearGroup.mkOfDetNeZero
    !![(1 : ℂ), -Complex.I; 1, Complex.I] (by
      rw [Matrix.det_fin_two_of]
      simp)

@[simp]
theorem cayleyGL_val :
    cayleyGL.val = !![(1 : ℂ), -Complex.I; 1, Complex.I] := rfl

/-- The Cayley coordinate change as a Möbius transformation of the
compactified complex line. -/
def cayleyMoebius : Moebius := Moebius.of cayleyGL

/-- Real projective matrices, complexified and conjugated into Cayley
coordinates. -/
def cayleyConjGL : GL (Fin 2) ℝ →* GL (Fin 2) ℂ :=
  (MulAut.conj cayleyGL).toMonoidHom.comp
    (Matrix.GeneralLinearGroup.map Complex.ofRealHom)

/-- A complex general-linear matrix regarded as its Möbius permutation. -/
def glToMoebius : GL (Fin 2) ℂ →* Moebius :=
  (MulAction.toPermHom (GL (Fin 2) ℂ) (OnePoint ℂ)).rangeRestrict

/-! ## The diagonal nonzero-scalar action -/

/-- The general-linear matrix `diag(u, 1)` for a nonzero complex scalar.
This is the general-modulus form of the band matrix used by the A-section's
Euler/Weierstrass transport. -/
def diagonalGL (u : ℂˣ) : GL (Fin 2) ℂ :=
  Matrix.GeneralLinearGroup.mkOfDetNeZero
    !![((u : ℂ)), 0; 0, 1] (by
      rw [Matrix.det_fin_two_of]
      simpa using u.ne_zero)

@[simp]
theorem diagonalGL_val (u : ℂˣ) :
    (diagonalGL u).val = !![((u : ℂ)), 0; 0, 1] := rfl

theorem diagonalGL_one : diagonalGL 1 = 1 := by
  apply Units.ext
  rw [diagonalGL_val]
  exact (Matrix.one_fin_two).symm

theorem diagonalGL_mul (u v : ℂˣ) :
    diagonalGL (u * v) = diagonalGL u * diagonalGL v := by
  apply Units.ext
  show (diagonalGL (u * v)).val = (diagonalGL u).val * (diagonalGL v).val
  rw [diagonalGL_val, diagonalGL_val, diagonalGL_val, Matrix.mul_fin_two]
  norm_num

/-- Nonzero complex scalars embedded diagonally in `GL(2, ℂ)`. -/
def diagonalGLHom : ℂˣ →* GL (Fin 2) ℂ where
  toFun := diagonalGL
  map_one' := diagonalGL_one
  map_mul' := diagonalGL_mul

/-- The compactified-line action `z ↦ λz` of a nonzero complex scalar. -/
def diagonalMoebiusHom : ℂˣ →* Moebius :=
  glToMoebius.comp diagonalGLHom

/-! ## The exponential/GPV diagonal action

The logarithmic GPV coordinate is not extra data attached to a Möbius
element.  Exponentiation sends it to the nonzero diagonal multiplier itself.
Its real part is the multiplier's modulus level and its `2πiℤ` ambiguity is
exactly the winding/band direction.
-/

/-- A logarithmic coordinate exponentiated as a nonzero complex unit. -/
noncomputable def expUnit (z : ℂ) : ℂˣ :=
  Units.mk0 (Complex.exp z) (Complex.exp_ne_zero z)

@[simp] theorem expUnit_coe (z : ℂ) :
    ((expUnit z : ℂˣ) : ℂ) = Complex.exp z := rfl

@[simp] theorem expUnit_zero : expUnit 0 = 1 := by
  apply Units.ext
  simp

theorem expUnit_add (z w : ℂ) :
    expUnit (z + w) = expUnit z * expUnit w := by
  apply Units.ext
  exact Complex.exp_add z w

/-- The complete exponential diagonal action before changing to the Cayley
disk chart.  Addition of logarithmic lifts is composition of multipliers. -/
noncomputable def expDiagonalMoebius (z : ℂ) : Moebius :=
  diagonalMoebiusHom (expUnit z)

@[simp] theorem expDiagonalMoebius_zero : expDiagonalMoebius 0 = 1 := by
  rw [expDiagonalMoebius, expUnit_zero, map_one]

theorem expDiagonalMoebius_add (z w : ℂ) :
    expDiagonalMoebius (z + w) =
      expDiagonalMoebius z * expDiagonalMoebius w := by
  unfold expDiagonalMoebius
  rw [expUnit_add, map_mul]

/-- The diagonal Möbius element acts on the finite chart by multiplication
by its defining nonzero scalar. -/
theorem diagonalMoebiusHom_apply_coe (u : ℂˣ) (z : ℂ) :
    (diagonalMoebiusHom u).val (z : OnePoint ℂ) =
      ((((u : ℂ) * z) : ℂ) : OnePoint ℂ) := by
  change diagonalGL u • (z : OnePoint ℂ) =
    ((((u : ℂ) * z) : ℂ) : OnePoint ℂ)
  rw [OnePoint.smul_some_eq_ite]
  have h10 : (diagonalGL u) 1 0 = 0 := by
    show (!![((u : ℂ)), 0; 0, 1] : Matrix (Fin 2) (Fin 2) ℂ) 1 0 = 0
    simp
  have h11 : (diagonalGL u) 1 1 = 1 := by
    show (!![((u : ℂ)), 0; 0, 1] : Matrix (Fin 2) (Fin 2) ℂ) 1 1 = 1
    simp
  have h00 : (diagonalGL u) 0 0 = (u : ℂ) := by
    show (!![((u : ℂ)), 0; 0, 1] : Matrix (Fin 2) (Fin 2) ℂ) 0 0 = (u : ℂ)
    simp
  have h01 : (diagonalGL u) 0 1 = 0 := by
    show (!![((u : ℂ)), 0; 0, 1] : Matrix (Fin 2) (Fin 2) ℂ) 0 1 = 0
    simp
  rw [h10, h11, h00, h01]
  norm_num

/-- Every nonzero diagonal multiplier fixes the shared north pole.  This is
the generic matrix calculation used below at A's distinguished
Euler–Weierstrass multiplier; it does not replace that A-specific element. -/
@[simp] theorem diagonalMoebiusHom_apply_infty (u : ℂˣ) :
    (diagonalMoebiusHom u).val (OnePoint.infty : OnePoint ℂ) =
      OnePoint.infty := by
  change diagonalGL u • (OnePoint.infty : OnePoint ℂ) = OnePoint.infty
  rw [OnePoint.smul_infty_eq_ite]
  have h10 : (diagonalGL u) 1 0 = 0 := by
    show (!![((u : ℂ)), 0; 0, 1] : Matrix (Fin 2) (Fin 2) ℂ) 1 0 = 0
    simp
  rw [if_pos h10]

/-- The diagonal scalar embedding into the Möbius group is injective. -/
theorem diagonalMoebiusHom_injective :
    Function.Injective diagonalMoebiusHom := by
  intro u v huv
  have h_at_one := congrArg
    (fun m : Moebius => m.val (((1 : ℂ) : OnePoint ℂ))) huv
  rw [diagonalMoebiusHom_apply_coe, diagonalMoebiusHom_apply_coe,
    mul_one, mul_one] at h_at_one
  have huv_coe : (u : ℂ) = (v : ℂ) := OnePoint.coe_injective h_at_one
  exact Units.ext huv_coe

/-- The general-modulus diagonal multiplier in the same Cayley chart as the
projective great-circle action.  This is the disk-automorphism form consumed
by the A-section orbit--stabilizer construction. -/
noncomputable def diskDiagonalMoebiusHom : ℂˣ →* Moebius where
  toFun u := cayleyMoebius * diagonalMoebiusHom u * cayleyMoebius⁻¹
  map_one' := by simp
  map_mul' u v := by
    rw [map_mul]
    group

/-- The exponential diagonal action in the projective Cayley disk chart. -/
noncomputable def diskExpAction (z : ℂ) : Moebius :=
  diskDiagonalMoebiusHom (expUnit z)

@[simp] theorem diskExpAction_zero : diskExpAction 0 = 1 := by
  rw [diskExpAction, expUnit_zero, map_one]

theorem diskExpAction_add (z w : ℂ) :
    diskExpAction (z + w) = diskExpAction z * diskExpAction w := by
  unfold diskExpAction
  rw [expUnit_add, map_mul]

/-- The Cayley-conjugated real action before projectivization. -/
def cayleyConjMoebiusGL : GL (Fin 2) ℝ →* Moebius :=
  glToMoebius.comp cayleyConjGL

/-- Scalar real matrices become the identity Möbius transformation after
complexification and Cayley conjugation. -/
theorem cayleyConjMoebiusGL_scalar :
    cayleyConjMoebiusGL.comp (Matrix.GeneralLinearGroup.scalar (Fin 2)) = 1 := by
  ext u z
  change (cayleyConjGL (Matrix.GeneralLinearGroup.scalar (Fin 2) u)) • z = z
  change ((MulAut.conj cayleyGL)
    (Matrix.GeneralLinearGroup.map Complex.ofRealHom
      (Matrix.GeneralLinearGroup.scalar (Fin 2) u))) • z = z
  rw [MulAut.conj_apply]
  have hs : Matrix.GeneralLinearGroup.map Complex.ofRealHom
      (Matrix.GeneralLinearGroup.scalar (Fin 2) u) =
      Matrix.GeneralLinearGroup.scalar (Fin 2) (Units.map Complex.ofRealHom u) := by
    apply Units.ext
    ext i j
    by_cases hij : i = j
    · subst j
      simp [Matrix.GeneralLinearGroup.map_apply]
    · simp [Matrix.GeneralLinearGroup.map_apply, hij]
  rw [hs]
  have hc : Matrix.GeneralLinearGroup.scalar (Fin 2) (Units.map Complex.ofRealHom u)
      ∈ Subgroup.center (GL (Fin 2) ℂ) := by
    rw [Matrix.GeneralLinearGroup.center_eq_range_scalar]
    exact ⟨Units.map Complex.ofRealHom u, rfl⟩
  rw [← hc.comm cayleyGL]
  simp only [mul_inv_cancel_right]
  induction z using OnePoint.rec with
  | infty => simp [OnePoint.smul_infty_eq_ite]
  | coe z => simp [OnePoint.smul_some_eq_ite]

/-- The Cayley-conjugated action of the locked projective automorphism
group on the complex boundary. -/
def cayleyProjective : GreatCircle.Aut →* Moebius :=
  Matrix.ProjGenLinGroup.lift cayleyConjMoebiusGL cayleyConjMoebiusGL_scalar

@[simp]
theorem cayleyProjective_mk (g : GL (Fin 2) ℝ) :
    cayleyProjective (Matrix.ProjGenLinGroup.mk g) = cayleyConjMoebiusGL g := rfl

/-- The locked real projective point, embedded in the compactified complex
line without changing its base identity. -/
def complexPoint (x : GreatCircle.Point) : OnePoint ℂ :=
  x.map Complex.ofRealHom

@[simp] theorem complexPoint_zero :
    complexPoint ((0 : ℝ) : GreatCircle.Point) = ((0 : ℂ) : OnePoint ℂ) := by
  simp [complexPoint]

/-- Cayley coordinates on the locked base circle. -/
def cayleyCoord (x : GreatCircle.Point) : OnePoint ℂ :=
  cayleyGL • complexPoint x

@[simp]
theorem cayleyCoord_infty : cayleyCoord (OnePoint.infty : GreatCircle.Point) =
    ((1 : ℂ) : OnePoint ℂ) := by
  rw [cayleyCoord, complexPoint]
  simp [OnePoint.smul_infty_eq_ite, cayleyGL_val]

/-- F5: the Cayley dictionary intertwines the locked projective action with
the conjugated Möbius action. -/
theorem cayleyCoord_equivariant (g : GreatCircle.Aut) (x : GreatCircle.Point) :
    (cayleyProjective g).val (cayleyCoord x) = cayleyCoord (g • x) := by
  induction g using Matrix.ProjGenLinGroup.induction_on with
  | mk g =>
      rw [cayleyProjective_mk, GreatCircle.mk_smul]
      change (cayleyConjGL g) • (cayleyGL • x.map Complex.ofRealHom) =
        cayleyGL • ((g • x).map Complex.ofRealHom)
      rw [OnePoint.map_smul]
      change (cayleyGL * Matrix.GeneralLinearGroup.map Complex.ofRealHom g *
        cayleyGL⁻¹) • (cayleyGL • x.map Complex.ofRealHom) =
        cayleyGL • ((Matrix.GeneralLinearGroup.map Complex.ofRealHom g) •
          x.map Complex.ofRealHom)
      simp [mul_smul]

/-- The north-pole convention: the compactified real point maps to the
circle identity `1`. -/
@[simp]
theorem cayleyMoebius_apply_infty :
    cayleyMoebius.val (OnePoint.infty : OnePoint ℂ) = ((1 : ℂ) : OnePoint ℂ) := by
  rw [cayleyMoebius, Moebius.of_apply, OnePoint.smul_infty_eq_ite]
  simp [cayleyGL_val]

/-- Every general-modulus diagonal disk multiplier fixes the Cayley image of
the one projective north point. -/
@[simp] theorem diskDiagonalMoebiusHom_fixes_cayley_infty (u : ℂˣ) :
    (diskDiagonalMoebiusHom u).val
        (cayleyCoord (OnePoint.infty : GreatCircle.Point)) =
      cayleyCoord (OnePoint.infty : GreatCircle.Point) := by
  rw [cayleyCoord_infty]
  change (cayleyMoebius * diagonalMoebiusHom u * cayleyMoebius⁻¹).val
      (((1 : ℂ) : OnePoint ℂ)) = (((1 : ℂ) : OnePoint ℂ))
  rw [← cayleyMoebius_apply_infty]
  change cayleyMoebius.val
      ((diagonalMoebiusHom u).val
        ((cayleyMoebius⁻¹).val (cayleyMoebius.val OnePoint.infty))) =
    cayleyMoebius.val OnePoint.infty
  have hc : (cayleyMoebius⁻¹).val
      (cayleyMoebius.val OnePoint.infty) = OnePoint.infty := by
    exact cayleyMoebius.val.symm_apply_apply OnePoint.infty
  rw [hc, diagonalMoebiusHom_apply_infty]

/-- Every general-modulus diagonal disk multiplier also fixes the Cayley image
of the projective zero.  Thus `0` and `N` are the two intrinsic fixed boundary
points of the one diagonal action. -/
@[simp] theorem diskDiagonalMoebiusHom_fixes_cayley_zero (u : ℂˣ) :
    (diskDiagonalMoebiusHom u).val
        (cayleyCoord ((0 : ℝ) : GreatCircle.Point)) =
      cayleyCoord ((0 : ℝ) : GreatCircle.Point) := by
  rw [cayleyCoord, complexPoint_zero]
  change (cayleyMoebius * diagonalMoebiusHom u * cayleyMoebius⁻¹).val
      (cayleyMoebius.val (((0 : ℂ) : OnePoint ℂ))) =
    cayleyMoebius.val (((0 : ℂ) : OnePoint ℂ))
  change cayleyMoebius.val
      ((diagonalMoebiusHom u).val
        ((cayleyMoebius⁻¹).val
          (cayleyMoebius.val (((0 : ℂ) : OnePoint ℂ))))) =
    cayleyMoebius.val (((0 : ℂ) : OnePoint ℂ))
  have hc : (cayleyMoebius⁻¹).val
      (cayleyMoebius.val (((0 : ℂ) : OnePoint ℂ))) =
        ((0 : ℂ) : OnePoint ℂ) := by
    exact cayleyMoebius.val.symm_apply_apply _
  rw [hc, diagonalMoebiusHom_apply_coe, mul_zero]

/-- The finite-chart Cayley formula. -/
theorem cayleyMoebius_apply_real (x : ℝ) :
    cayleyMoebius.val (((x : ℂ) : OnePoint ℂ)) =
      ((((x : ℂ) - Complex.I) / ((x : ℂ) + Complex.I) : ℂ) : OnePoint ℂ) := by
  rw [cayleyMoebius, Moebius.of_apply, OnePoint.smul_some_eq_ite]
  have hden : (x : ℂ) + Complex.I ≠ 0 := by
    intro h
    have him := congrArg Complex.im h
    simp at him
  simp [cayleyGL_val, hden, div_eq_mul_inv, sub_eq_add_neg]

/-- The Cayley image of a finite real point has unit modulus. -/
theorem norm_cayley_real (x : ℝ) :
    ‖((x : ℂ) - Complex.I) / ((x : ℂ) + Complex.I)‖ = 1 := by
  rw [norm_div]
  have hnum : ‖(x : ℂ) - Complex.I‖ = Real.sqrt (x ^ 2 + 1) := by
    rw [Complex.norm_def]
    congr 1
    simp [Complex.normSq_apply]
    ring
  have hden : ‖(x : ℂ) + Complex.I‖ = Real.sqrt (x ^ 2 + 1) := by
    rw [Complex.norm_def]
    congr 1
    simp [Complex.normSq_apply]
    ring
  rw [hnum, hden, div_self]
  positivity

/-! ## The distinguished disk family -/

/-- The matrix of the distinguished disk automorphism
`z ↦ c * (z - w) / (1 - conj w * z)`. -/
def distinguishedGL (c : Circle) (w : Complex.UnitDisc) : GL (Fin 2) ℂ :=
  Matrix.GeneralLinearGroup.mkOfDetNeZero
    !![(c : ℂ), -(c : ℂ) * (w : ℂ); -starRingEnd ℂ (w : ℂ), 1] (by
      rw [Matrix.det_fin_two_of]
      have hw : (1 : ℂ) - (w : ℂ) * starRingEnd ℂ (w : ℂ) ≠ 0 := by
        rw [Complex.mul_conj]
        exact_mod_cast ne_of_gt (sub_pos.mpr w.normSq_lt_one)
      convert mul_ne_zero c.coe_ne_zero hw using 1 <;> ring)

@[simp]
theorem distinguishedGL_val (c : Circle) (w : Complex.UnitDisc) :
    (distinguishedGL c w).val =
      !![(c : ℂ), -(c : ℂ) * (w : ℂ); -starRingEnd ℂ (w : ℂ), 1] := rfl

/-- The distinguished element as an honest Möbius self-map. -/
def distinguishedMoebius (c : Circle) (w : Complex.UnitDisc) : Moebius :=
  Moebius.of (distinguishedGL c w)

/-- The finite-chart formula for the distinguished element. -/
theorem distinguishedMoebius_apply (c : Circle) (w : Complex.UnitDisc) (z : ℂ)
    (hden : 1 - starRingEnd ℂ (w : ℂ) * z ≠ 0) :
    (distinguishedMoebius c w).val (z : OnePoint ℂ) =
      ((c : ℂ) * (z - (w : ℂ)) / (1 - starRingEnd ℂ (w : ℂ) * z) : ℂ) := by
  rw [distinguishedMoebius, Moebius.of_apply, OnePoint.smul_some_eq_ite]
  have hden' : -(starRingEnd ℂ (w : ℂ) * z) + 1 ≠ 0 := by
    intro h
    apply hden
    convert h using 1 <;> ring
  simp [distinguishedGL_val, div_eq_mul_inv, sub_eq_add_neg]
  rw [if_neg hden']
  ring_nf

/-- At `w = 0`, the distinguished family is exactly the existing band. -/
theorem distinguishedMoebius_zero (c : Circle) :
    distinguishedMoebius c 0 = bandMoebius c := by
  apply Subtype.ext
  change MulAction.toPermHom (GL (Fin 2) ℂ) (OnePoint ℂ) (distinguishedGL c 0) =
    MulAction.toPermHom (GL (Fin 2) ℂ) (OnePoint ℂ) (bandGL c)
  congr 1
  apply Units.ext
  rw [distinguishedGL_val, bandGL_val]
  norm_num

/-- Composition of Cayley-conjugated projective transformations is inherited
directly from the projective group law. -/
theorem cayleyProjective_mul (g h : GreatCircle.Aut) :
    cayleyProjective (g * h) = cayleyProjective g * cayleyProjective h :=
  map_mul cayleyProjective g h

/-- The phase parameter on the ordinary complex unit circle. -/
def phaseCircle (θ : ℝ) : Circle := Circle.exp θ

@[simp]
theorem phaseCircle_coe (θ : ℝ) :
    ((phaseCircle θ : Circle) : ℂ) = Complex.exp (θ * Complex.I) := by
  rw [phaseCircle, Circle.coe_exp]

/-- The zero-translation member of the distinguished family is the band
phase at angle `θ`. -/
theorem distinguished_phase_is_band (θ : ℝ) :
    distinguishedMoebius (phaseCircle θ) 0 = bandMoebius (phaseCircle θ) :=
  distinguishedMoebius_zero _

/-! ## Normal-form multiplication -/

/-- Denominator in the translated parameter of a composite distinguished
element. -/
def distinguishedCompDen (c₁ : Circle) (w₁ w₂ : Complex.UnitDisc) : ℂ :=
  (c₁ : ℂ) + (w₂ : ℂ) * starRingEnd ℂ (w₁ : ℂ)

/-- Numerator in the translated parameter of a composite distinguished
element. -/
def distinguishedCompNum (c₁ : Circle) (w₁ w₂ : Complex.UnitDisc) : ℂ :=
  (c₁ : ℂ) * (w₁ : ℂ) + (w₂ : ℂ)

/-- The norm-square gap controlling closure of the translation parameter
under composition. -/
theorem distinguishedComp_normSq_gap (c₁ : Circle) (w₁ w₂ : Complex.UnitDisc) :
    Complex.normSq (distinguishedCompDen c₁ w₁ w₂) -
        Complex.normSq (distinguishedCompNum c₁ w₁ w₂) =
      (1 - Complex.normSq (w₁ : ℂ)) * (1 - Complex.normSq (w₂ : ℂ)) := by
  simp [distinguishedCompDen, distinguishedCompNum, Complex.normSq,
    Complex.mul_re, Complex.mul_im]
  have hc := Circle.normSq_coe c₁
  simp [Complex.normSq] at hc
  nlinarith

theorem distinguishedCompDen_ne_zero (c₁ : Circle) (w₁ w₂ : Complex.UnitDisc) :
    distinguishedCompDen c₁ w₁ w₂ ≠ 0 := by
  intro h
  have hgap := distinguishedComp_normSq_gap c₁ w₁ w₂
  rw [h, Complex.normSq_zero] at hgap
  have h₁ : 0 < 1 - Complex.normSq (w₁ : ℂ) := sub_pos.mpr w₁.normSq_lt_one
  have h₂ : 0 < 1 - Complex.normSq (w₂ : ℂ) := sub_pos.mpr w₂.normSq_lt_one
  have hn := Complex.normSq_nonneg (distinguishedCompNum c₁ w₁ w₂)
  nlinarith [mul_pos h₁ h₂]

/-- The translated parameter after composing two distinguished elements. -/
def distinguishedCompW (c₁ : Circle) (w₁ w₂ : Complex.UnitDisc) : Complex.UnitDisc :=
  Complex.UnitDisc.mk
    (distinguishedCompNum c₁ w₁ w₂ / distinguishedCompDen c₁ w₁ w₂) (by
      rw [norm_div]
      apply (div_lt_one (norm_pos_iff.mpr
        (distinguishedCompDen_ne_zero c₁ w₁ w₂))).2
      have hgap := distinguishedComp_normSq_gap c₁ w₁ w₂
      have hpos : 0 < (1 - Complex.normSq (w₁ : ℂ)) *
          (1 - Complex.normSq (w₂ : ℂ)) :=
        mul_pos (sub_pos.mpr w₁.normSq_lt_one) (sub_pos.mpr w₂.normSq_lt_one)
      have hsq : ‖distinguishedCompNum c₁ w₁ w₂‖ ^ 2 <
          ‖distinguishedCompDen c₁ w₁ w₂‖ ^ 2 := by
        rw [← Complex.normSq_eq_norm_sq, ← Complex.normSq_eq_norm_sq]
        linarith
      nlinarith [norm_nonneg (distinguishedCompNum c₁ w₁ w₂),
        norm_nonneg (distinguishedCompDen c₁ w₁ w₂)])

/-- The residual phase after composing two distinguished elements. -/
def distinguishedCompPhase (c₁ c₂ : Circle) (w₁ w₂ : Complex.UnitDisc) : Circle :=
  ⟨(c₂ : ℂ) * distinguishedCompDen c₁ w₁ w₂ /
      ((c₁ : ℂ) * starRingEnd ℂ (distinguishedCompDen c₁ w₁ w₂)), by
    change (c₂ : ℂ) * distinguishedCompDen c₁ w₁ w₂ /
      ((c₁ : ℂ) * starRingEnd ℂ (distinguishedCompDen c₁ w₁ w₂)) ∈
        Metric.sphere (0 : ℂ) 1
    rw [mem_sphere_zero_iff_norm]
    simp [norm_div, norm_mul, Circle.norm_coe,
      distinguishedCompDen_ne_zero c₁ w₁ w₂]⟩

/-- The scalar used to normalize a product of distinguished matrices back
to the canonical lower-right entry `1`. -/
def distinguishedCompScalar (c₁ : Circle) (w₁ w₂ : Complex.UnitDisc) : ℂˣ :=
  Units.mk0 ((c₁ : ℂ) * starRingEnd ℂ (distinguishedCompDen c₁ w₁ w₂))
    (mul_ne_zero c₁.coe_ne_zero
      ((map_ne_zero (starRingEnd ℂ)).2
        (distinguishedCompDen_ne_zero c₁ w₁ w₂)))

/-- Matrix-level normal-form multiplication. -/
theorem distinguishedGL_mul (c₁ c₂ : Circle) (w₁ w₂ : Complex.UnitDisc) :
    distinguishedGL c₂ w₂ * distinguishedGL c₁ w₁ =
      Matrix.GeneralLinearGroup.scalar (Fin 2)
          (distinguishedCompScalar c₁ w₁ w₂) *
        distinguishedGL (distinguishedCompPhase c₁ c₂ w₁ w₂)
          (distinguishedCompW c₁ w₁ w₂) := by
  have hd := distinguishedCompDen_ne_zero c₁ w₁ w₂
  have hd' : (c₁ : ℂ) + (w₂ : ℂ) * starRingEnd ℂ (w₁ : ℂ) ≠ 0 := by
    simpa [distinguishedCompDen] using hd
  have hdc : starRingEnd ℂ (distinguishedCompDen c₁ w₁ w₂) ≠ 0 :=
    (map_ne_zero (starRingEnd ℂ)).2 hd
  have hdc' : starRingEnd ℂ (c₁ : ℂ) +
      starRingEnd ℂ (w₂ : ℂ) * (w₁ : ℂ) ≠ 0 := by
    convert hdc using 1 <;>
      simp [distinguishedCompDen, map_add, map_mul]
  have hdc'' : starRingEnd ℂ (c₁ : ℂ) +
      (w₁ : ℂ) * starRingEnd ℂ (w₂ : ℂ) ≠ 0 := by
    simpa [mul_comm] using hdc'
  have hc : (c₁ : ℂ) * starRingEnd ℂ (c₁ : ℂ) = 1 := by
    rw [Complex.mul_conj]
    norm_cast
    exact Circle.normSq_coe c₁
  apply Units.ext
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [distinguishedGL_val, distinguishedCompScalar, distinguishedCompPhase,
      distinguishedCompW, distinguishedCompNum, distinguishedCompDen,
      Matrix.GeneralLinearGroup.scalar]
  · field_simp [hd, hd', hdc, hdc', hdc'', Circle.coe_ne_zero, hc]
  · field_simp [hd, hd', hdc, hdc', hdc'', Circle.coe_ne_zero, hc]
    ring
  · field_simp [hd, hd', hdc, hdc', hdc'', Circle.coe_ne_zero, hc]
    calc
      -(starRingEnd ℂ (w₂ : ℂ) * (c₁ : ℂ)) - starRingEnd ℂ (w₁ : ℂ) =
          -(starRingEnd ℂ (w₂ : ℂ) * (c₁ : ℂ)) -
            starRingEnd ℂ (w₁ : ℂ) *
              ((c₁ : ℂ) * starRingEnd ℂ (c₁ : ℂ)) := by rw [hc]; ring
      _ = -((c₁ : ℂ) *
          (starRingEnd ℂ (w₁ : ℂ) * starRingEnd ℂ (c₁ : ℂ) +
            starRingEnd ℂ (w₂ : ℂ))) := by ring
  · rw [← hc]
    ring

/-- The distinguished disk family is closed under composition.  The
translation parameter stays in the disk and the residual coefficient stays
in `U(1)` by the preceding norm-square calculation. -/
theorem distinguishedMoebius_mul (c₁ c₂ : Circle) (w₁ w₂ : Complex.UnitDisc) :
    distinguishedMoebius c₂ w₂ * distinguishedMoebius c₁ w₁ =
      distinguishedMoebius (distinguishedCompPhase c₁ c₂ w₁ w₂)
        (distinguishedCompW c₁ w₁ w₂) := by
  change glToMoebius (distinguishedGL c₂ w₂) *
      glToMoebius (distinguishedGL c₁ w₁) = _
  rw [← map_mul, distinguishedGL_mul, map_mul]
  have hscalar : glToMoebius
      (Matrix.GeneralLinearGroup.scalar (Fin 2) (distinguishedCompScalar c₁ w₁ w₂)) = 1 := by
    ext z
    induction z using OnePoint.rec with
    | infty =>
        change Matrix.GeneralLinearGroup.scalar (Fin 2)
          (distinguishedCompScalar c₁ w₁ w₂) •
            (OnePoint.infty : OnePoint ℂ) = OnePoint.infty
        simp [OnePoint.smul_infty_eq_ite]
    | coe z =>
        change Matrix.GeneralLinearGroup.scalar (Fin 2)
          (distinguishedCompScalar c₁ w₁ w₂) •
            (z : OnePoint ℂ) = (z : OnePoint ℂ)
        simp [OnePoint.smul_some_eq_ite]
  rw [hscalar, one_mul]
  rfl

end GreatCircle

namespace ASection

/-- The distinguished phase is literally the octonionic slice exponential
in every sphere world. -/
theorem exp_phase_eq_sliceEmbed (I : SphereWorld) (θ : ℝ) :
    Octonion.exp (θ • I.val) =
      Octonion.sliceEmbed I.val (Complex.exp (θ * Complex.I)) := by
  have him : Octonion.sliceEmbed I.val (θ * Complex.I) = θ • I.val := by
    simp [Octonion.sliceEmbed, Octonion.ofReal_eq_smul_one]
  rw [← him, Octonion.exp_sliceEmbed' I.prop]

end ASection
