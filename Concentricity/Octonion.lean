/-
Concentricity/Octonion.lean

The octonions 𝕆, constructed by Cayley–Dickson doubling over Mathlib's
quaternions (R9: no existence axioms — every object is constructed).

Doubling convention (project document RECON_MATHLIB.md, item (a); to be
cross-checked for faithfulness against SOURCES/Baez02.md when the SOURCES
pass lands — the citation is for faithfulness of the definition, never as
load, per the R9 addendum):

  (a, b) · (c, d) = (a c − d* b,  d a + b c*)        star (a, b) = (a*, −b)

where `*` is quaternion conjugation (Mathlib's `star`).

Master references: `def:octonions` (the four properties: division algebra,
normed, non-associative, alternative — stated below, proofs queued per R8),
`thm:artin` (Artin's theorem — axiom leaf pending SOURCES/Schafer66.md),
`cor:powers`.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Mathlib.Algebra.Quaternion
import Mathlib.Analysis.Quaternion
import Mathlib.Algebra.Ring.Identities
import Mathlib.Tactic.LinearCombination

noncomputable section

/-- The octonions: Cayley–Dickson double of Mathlib's quaternions.
Defined as a pair of quaternions; the twisted multiplication is installed
below. (`def` rather than `structure` so the additive/module structure is
inherited from the product.) -/
def Octonion : Type := Quaternion ℝ × Quaternion ℝ

namespace Octonion

/-- Additive structure: componentwise, inherited from ℍ × ℍ. -/
instance : AddCommGroup Octonion := inferInstanceAs (AddCommGroup (Quaternion ℝ × Quaternion ℝ))

/-- Real scalar action: componentwise, inherited from ℍ × ℍ. -/
instance : Module ℝ Octonion := inferInstanceAs (Module ℝ (Quaternion ℝ × Quaternion ℝ))

instance : Inhabited Octonion := ⟨0⟩

/-- The Cayley–Dickson multiplication:
`(a, b) · (c, d) = (a c − d* b, d a + b c*)`. -/
instance : Mul Octonion :=
  ⟨fun x y => (x.1 * y.1 - star y.2 * x.2, y.2 * x.1 + x.2 * star y.1)⟩

theorem mul_def (x y : Octonion) :
    x * y = (x.1 * y.1 - star y.2 * x.2, y.2 * x.1 + x.2 * star y.1) := rfl

/-- The multiplicative identity `(1, 0)`. -/
instance : One Octonion := ⟨((1 : Quaternion ℝ), (0 : Quaternion ℝ))⟩

theorem one_def : (1 : Octonion) = ((1 : Quaternion ℝ), (0 : Quaternion ℝ)) := rfl

/-- Octonionic conjugation: `star (a, b) = (a*, −b)`. -/
instance : Star Octonion := ⟨fun x => (star x.1, -x.2)⟩

theorem star_def (x : Octonion) : star x = (star x.1, -x.2) := rfl

@[simp] theorem fst_mul (x y : Octonion) : (x * y).1 = x.1 * y.1 - star y.2 * x.2 := rfl
@[simp] theorem snd_mul (x y : Octonion) : (x * y).2 = y.2 * x.1 + x.2 * star y.1 := rfl

-- Component lemmas for the inherited additive structure (the `def` wrapper
-- hides the `Prod` instances from `simp`, so these are restated as `rfl`).
@[simp] theorem fst_add (x y : Octonion) : (x + y).1 = x.1 + y.1 := rfl
@[simp] theorem snd_add (x y : Octonion) : (x + y).2 = x.2 + y.2 := rfl
@[simp] theorem fst_zero : (0 : Octonion).1 = 0 := rfl
@[simp] theorem snd_zero : (0 : Octonion).2 = 0 := rfl
@[simp] theorem fst_neg (x : Octonion) : (-x).1 = -x.1 := rfl
@[simp] theorem snd_neg (x : Octonion) : (-x).2 = -x.2 := rfl

/-- 𝕆 is a (non-unital-typeclass-path) non-associative ring: distributivity
and zero laws hold; associativity deliberately does NOT (master
`def:octonions`(iii)). The unit is installed separately with `one_mul`/`mul_one`. -/
instance : NonUnitalNonAssocRing Octonion where
  left_distrib x y z := by
    refine Prod.ext ?_ ?_ <;>
      simp only [fst_mul, snd_mul, fst_add, snd_add, mul_add, add_mul, star_add] <;>
      abel
  right_distrib x y z := by
    refine Prod.ext ?_ ?_ <;>
      simp only [fst_mul, snd_mul, fst_add, snd_add, mul_add, add_mul, star_add] <;>
      abel
  zero_mul x := by
    refine Prod.ext ?_ ?_ <;> simp
  mul_zero x := by
    refine Prod.ext ?_ ?_ <;> simp

@[simp] theorem one_mul (x : Octonion) : 1 * x = x := by
  refine Prod.ext ?_ ?_ <;> simp [mul_def, one_def]

@[simp] theorem mul_one (x : Octonion) : x * 1 = x := by
  refine Prod.ext ?_ ?_ <;> simp [mul_def, one_def]

/-- The real embedding ℝ → 𝕆 (through the first quaternion component). -/
def ofReal (r : ℝ) : Octonion := ((r : Quaternion ℝ), 0)

/-- The real part of an octonion: the real coefficient of its first
quaternion component. -/
def re (x : Octonion) : ℝ := x.1.re

@[simp] theorem re_ofReal (r : ℝ) : re (ofReal r) = r := by
  simp [re, ofReal]

/-- The squared norm: sum of the two quaternionic squared norms
(Cayley–Dickson doubling of the quaternionic `normSq`). -/
def normSq (x : Octonion) : ℝ := Quaternion.normSq x.1 + Quaternion.normSq x.2

@[simp] theorem normSq_zero : normSq 0 = 0 := by simp [normSq]

@[simp] theorem normSq_one : normSq 1 = 1 := by simp [normSq, one_def]

/-- `def:octonions`(ii) — 𝕆 is a normed algebra: `normSq` is multiplicative.
Engine: Mathlib's Degen eight-square identity `sum_eight_sq_mul_sum_eight_sq`
(Mathlib/Algebra/Ring/Identities.lean, pinned v4.31.0). Convention checked
before expansion (2026-07-02): all 8 real components of the CD product match
the identity's eight bilinear forms verbatim, under x₁..x₄ = x.1.(re,imI,imJ,imK),
x₅..x₈ = x.2.(re,imI,imJ,imK). -/
theorem normSq_mul (x y : Octonion) : normSq (x * y) = normSq x * normSq y := by
  simp only [normSq, Quaternion.normSq_def', fst_mul, snd_mul, Quaternion.re_sub,
    Quaternion.imI_sub, Quaternion.imJ_sub, Quaternion.imK_sub, Quaternion.re_add,
    Quaternion.imI_add, Quaternion.imJ_add, Quaternion.imK_add, Quaternion.re_mul,
    Quaternion.imI_mul, Quaternion.imJ_mul, Quaternion.imK_mul, Quaternion.re_star,
    Quaternion.imI_star, Quaternion.imJ_star, Quaternion.imK_star]
  linear_combination
    -@sum_eight_sq_mul_sum_eight_sq ℝ _ x.1.re x.1.imI x.1.imJ x.1.imK
      x.2.re x.2.imI x.2.imJ x.2.imK y.1.re y.1.imI y.1.imJ y.1.imK
      y.2.re y.2.imI y.2.imJ y.2.imK

/-- Purely imaginary octonions: vanishing real part (the real coefficient
of the ℝ⁸ decomposition is `x.1.re`; all seven remaining coordinates —
`x.1.imI/imJ/imK` and the four of `x.2` — are imaginary directions). -/
def IsImaginary (x : Octonion) : Prop := re x = 0

/-- The 6-sphere of unit imaginary octonions
(master: "the unit imaginary octonions form S⁶ ⊂ im(𝕆)"). -/
def unitImaginarySphere : Set Octonion := {v | re v = 0 ∧ normSq v = 1}

/-- A unit imaginary octonion squares to −1 (the slice-generator property,
consumed by `def:slices`). Queued proof (R8): with `re a = 0` one has
`a + star a = 0` and `a * a = −normSq a` in ℍ; the Cayley–Dickson components
then give `(a,b)² = (−normSq(a,b), 0)`. -/
theorem sq_eq_neg_one_of_mem_unitImaginarySphere
    {v : Octonion} (hv : v ∈ unitImaginarySphere) : v * v = -1 := by
  sorry

/-- `def:octonions`(iv) — alternativity, left law: `(x x) y = x (x y)`.
Queued proof (R8): 8-component expansion over ℝ, closable by `ring`;
watch elaboration cost (recon (a) note). Cited-for-faithfulness:
Schafer/Baez (SOURCES pass). -/
theorem alt_left (x y : Octonion) : (x * x) * y = x * (x * y) := by
  sorry

/-- `def:octonions`(iv) — alternativity, right law: `x (y y) = (x y) y`. -/
theorem alt_right (x y : Octonion) : x * (y * y) = (x * y) * y := by
  sorry

end Octonion
