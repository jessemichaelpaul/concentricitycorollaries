/-
Concentricity/StemRing.lean

The ring 𝓡 of slice-preserving slice-regular functions, DEFINED by the stem
(R9 zero-axiom strategy: 𝓡 is defined by the stem functor over Mathlib's
holomorphic functions on ℂ; literature is cited for faithfulness of
definitions, never as load).

Master references (verbatim quotes in the docstrings below):
`def:R`, `def:slice-preserving` (characterisation (ii): the inducing stem
function F = F₁ + ιF₂ has ℝ-valued components), `thm:wang` (Wang Rem. 2.11,
SOURCES/Wang.md: on slice-preserving functions the regular product restricts
slicewise to the pointwise product — the faithfulness of the pointwise ring
structure used here), `prop:R-comm-ring`, `prop:R-domain`,
`rmk:slice-pres-compact` (compactified transport is a marked derivation node,
never an assumption).

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Mathlib.Analysis.Complex.Basic
import Mathlib.Analysis.Complex.CauchyIntegral
import Mathlib.Analysis.Analytic.IsolatedZeros
import Mathlib.Analysis.Calculus.FDeriv.Add
import Mathlib.Analysis.Calculus.FDeriv.Mul
import Mathlib.Algebra.Algebra.Subalgebra.Basic
import Mathlib.Tactic.Linarith

noncomputable section

/-- An **intrinsic stem**: `F : ℂ → ℂ` commuting with conjugation.
Master `def:slice-preserving`(i)/(ii): "f is *intrinsic*: f(qᶜ) = f(q)ᶜ", and
"the inducing stem function F = F₁ + ιF₂ has ℝ-valued components F₁, F₂" —
over ℂ the two renderings coincide: `F(conj z) = conj (F z)`. -/
def IsIntrinsic (F : ℂ → ℂ) : Prop :=
  ∀ z, F (starRingEnd ℂ z) = starRingEnd ℂ (F z)

/-- The ring **𝓡** (master `def:R`: "𝓡 := 𝒪_{𝕆*} is the set of all
slice-regular functions f : 𝕆* → 𝕆* that are slice preserving …, equipped
with pointwise addition and the regular (∗) product"), in its stem encoding:
entire intrinsic stems, an ℝ-subalgebra of `ℂ → ℂ` under pointwise
operations.

Pointwise multiplication of stems is the faithful rendering of the regular
product on the slice-preserving class — master `thm:wang` (Wang Rem. 2.11):
"the regular product restricts on each slice to the pointwise product,
(f ∗ g)|_{Ω_v}(w) = f(w)·g(w) ∈ ℂ_v" — cited for faithfulness, never as
load (R9). The compactified reading (𝕆* = S⁸, value sphere S²_v) is the
marked derivation node of `rmk:slice-pres-compact`. -/
def StemRing : Subalgebra ℝ (ℂ → ℂ) where
  carrier := {F | Differentiable ℂ F ∧ IsIntrinsic F}
  add_mem' := by
    rintro a b ⟨ha_d, ha_i⟩ ⟨hb_d, hb_i⟩
    exact ⟨ha_d.add hb_d, fun z => by simp [Pi.add_apply, ha_i z, hb_i z]⟩
  zero_mem' :=
    ⟨differentiable_const 0, fun z => by simp⟩
  mul_mem' := by
    rintro a b ⟨ha_d, ha_i⟩ ⟨hb_d, hb_i⟩
    exact ⟨ha_d.mul hb_d, fun z => by simp [Pi.mul_apply, ha_i z, hb_i z]⟩
  one_mem' :=
    ⟨differentiable_const 1, fun z => by simp⟩
  algebraMap_mem' := fun r =>
    ⟨differentiable_const _, fun z => by simp⟩

/-- Master `prop:R-comm-ring`: "(𝓡, +, ∗) is a commutative ring with identity
1 ∈ 𝓡." In the stem encoding this is definitional: a subalgebra of the
commutative ring `ℂ → ℂ`. -/
example : CommRing StemRing := inferInstance

namespace StemRing

theorem differentiable (f : StemRing) : Differentiable ℂ (f : ℂ → ℂ) :=
  f.2.1

theorem isIntrinsic (f : StemRing) : IsIntrinsic (f : ℂ → ℂ) :=
  f.2.2

/-- Master `prop:R-domain`: "If f, g ∈ 𝓡 and f ∗ g = 0, then f = 0 or
g = 0." Proof: on a slice the pointwise product of holomorphic functions
vanishes identically iff one factor does (classical identity principle on
the connected slice; master cites `thm:wang` + `thm:identity`). Pin:
`AnalyticOnNhd.eq_zero_or_eq_zero_of_mul_eq_zero`
(Mathlib/Analysis/Analytic/IsolatedZeros.lean:300),
`Complex.analyticOnNhd_univ_iff_differentiable`
(Mathlib/Analysis/Complex/CauchyIntegral.lean:678), `isPreconnected_univ`. -/
theorem eq_zero_or_eq_zero_of_mul_eq_zero {f g : StemRing} (h : f * g = 0) :
    f = 0 ∨ g = 0 := by
  have hf : AnalyticOnNhd ℂ (f : ℂ → ℂ) Set.univ :=
    Complex.analyticOnNhd_univ_iff_differentiable.mpr (differentiable f)
  have hg : AnalyticOnNhd ℂ (g : ℂ → ℂ) Set.univ :=
    Complex.analyticOnNhd_univ_iff_differentiable.mpr (differentiable g)
  have hfg : ∀ z ∈ Set.univ, (f : ℂ → ℂ) z * (g : ℂ → ℂ) z = 0 := by
    intro z _
    have h0 : ((f * g : StemRing) : ℂ → ℂ) z = ((0 : StemRing) : ℂ → ℂ) z := by
      rw [h]
    simpa using h0
  rcases AnalyticOnNhd.eq_zero_or_eq_zero_of_mul_eq_zero hf hg hfg
      isPreconnected_univ with h1 | h1
  · left
    apply Subtype.ext
    funext z
    simpa using h1 z (Set.mem_univ z)
  · right
    apply Subtype.ext
    funext z
    simpa using h1 z (Set.mem_univ z)

/-- An intrinsic stem is real on the real axis — the stem-level form of
master `def:slice-preserving`(iii) ("f(Ω ∩ ℝ) ⊆ ℝ"). DERIVED (R10):
`F(x) = F(conj x) = conj (F x)` for real `x`. -/
theorem real_on_real {F : ℂ → ℂ} (hF : IsIntrinsic F) (x : ℝ) :
    (F x).im = 0 := by
  have h := hF x
  rw [Complex.conj_ofReal] at h
  have him := congrArg Complex.im h
  simp only [Complex.conj_im] at him
  linarith

end StemRing
