/-
Concentricity/ZetaInfinitude.lean

Route A of PROOF_PLAN_zeta_infinitude.md (approved via map thread): the
Hadamard-infinitude fact as a SORRIED THEOREM, proved in-repo — never an
axiom (author's ruling 2026-07-03, carried by HANDOFF.md; supersedes the
same-day axiom ruling). Master: `cor:hadamard-infinitude` (under
`thm:hadamard`), consumed at `cor:zeta-section`.

Gate: zero sorries + zero project axioms; this file's target sorry is
burned down lemma-by-lemma (A1–A10), one commit per lemma on green,
pin-present names only (v4.31.0 = fabf563a).

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.NumberTheory.LSeries.Nonvanishing
import Mathlib.Analysis.SpecialFunctions.Gamma.Deligne
import Mathlib.Tactic.FieldSimp

noncomputable section

/-- **The target** (author's ruling, verbatim statement): the Riemann zeta
function has infinitely many nontrivial zeros. The nontriviality predicate
mirrors Mathlib's `RiemannHypothesis` exclusions; the trivial-zero clause
matches `riemannZeta_neg_two_mul_nat_add_one` (RiemannZeta.lean:171)
verbatim.

Proof route (approved): Route A of PROOF_PLAN_zeta_infinitude.md — suppose
finitely many; extract the finite zero divisor of ξ
(`MeromorphicOn.extract_zeros_poles`), take a global logarithm, bound growth
via the Mellin/theta representation and the unconditional functional
equation, force the log-factor affine by Borel–Carathéodory + Cauchy
estimates, contradict Γ-growth on the real axis. Queued (R8); burned down
at A1–A10 below. -/
theorem riemannZeta_nontrivialZeros_infinite :
    {s : ℂ | riemannZeta s = 0 ∧ (¬∃ n : ℕ, s = -2 * (n + 1)) ∧ s ≠ 1}.Infinite := by
  sorry

/-! ## A1 — the completed ξ and its entirety -/

/-- Route A, A1 data: ξ(s) = s(s−1)Λ(s) in its **entire normalization**
`s(s−1)·Λ₀(s) + 1`.

Pin: `completedRiemannZeta_eq` (RiemannZeta.lean:84):
Λ(s) = Λ₀(s) − 1/s − 1/(1−s), so s(s−1)Λ(s) = s(s−1)Λ₀(s) − (s−1) + s
= s(s−1)Λ₀(s) + 1 away from {0, 1}. Mathlib's Λ carries junk values at 0
and 1, which make the naive product `s*(s-1)*Λ(s)` discontinuous there —
the entire side is therefore the definition, and `xi_eq` records the
agreement off {0, 1}. -/
def xi (s : ℂ) : ℂ := s * (s - 1) * completedRiemannZeta₀ s + 1

/-- ξ agrees with s(s−1)Λ(s) away from 0 and 1
(pin: `completedRiemannZeta_eq`). -/
theorem xi_eq {s : ℂ} (hs0 : s ≠ 0) (hs1 : s ≠ 1) :
    xi s = s * (s - 1) * completedRiemannZeta s := by
  have h1 : (1 : ℂ) - s ≠ 0 := sub_ne_zero.mpr (Ne.symm hs1)
  rw [xi, completedRiemannZeta_eq]
  field_simp
  ring

/-- **A1** — ξ is entire (pin: `differentiable_completedZeta₀`,
RiemannZeta.lean:89). -/
theorem xi_entire : Differentiable ℂ xi :=
  ((differentiable_id.mul (differentiable_id.sub_const 1)).mul
    differentiable_completedZeta₀).add_const 1

/-! ## A2 — the zero-set dictionary: zeros of ξ = nontrivial zeros of ζ -/

/-- ξ(0) = 1: the pole factor kills the Λ₀ term. -/
theorem xi_zero : xi 0 = 1 := by simp [xi]

/-- ξ(1) = 1: the pole factor kills the Λ₀ term. -/
theorem xi_one : xi 1 = 1 := by simp [xi]

/-- Λ does not vanish at the even nonpositive integers (the `Gammaℝ`
poles): by the functional equation `completedRiemannZeta_one_sub`
(RiemannZeta.lean:105), Λ(−2n) = Λ(1+2n), and the latter is nonzero since
ζ does not vanish on re ≥ 1 (`riemannZeta_ne_zero_of_one_le_re`,
Nonvanishing.lean:410, junk value at 1 included) while
ζ = Λ/Γℝ (`riemannZeta_def_of_ne_zero`, RiemannZeta.lean:152). -/
theorem completedRiemannZeta_neg_two_mul_ne_zero (n : ℕ) :
    completedRiemannZeta (-(2 * (n : ℂ))) ≠ 0 := by
  have hre : (1 + 2 * (n : ℂ)).re = 1 + 2 * (n : ℝ) := by simp
  have hn0 : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
  have hs0 : (1 : ℂ) + 2 * (n : ℂ) ≠ 0 := by
    intro h
    have h' := congrArg Complex.re h
    rw [hre] at h'
    simp only [Complex.zero_re] at h'
    linarith
  have hζ : riemannZeta (1 + 2 * (n : ℂ)) ≠ 0 := by
    apply riemannZeta_ne_zero_of_one_le_re
    rw [hre]
    linarith
  intro hΛ
  have hFE : completedRiemannZeta (1 - (1 + 2 * (n : ℂ)))
      = completedRiemannZeta (1 + 2 * (n : ℂ)) :=
    completedRiemannZeta_one_sub _
  rw [show (1 : ℂ) - (1 + 2 * (n : ℂ)) = -(2 * (n : ℂ)) from by ring, hΛ] at hFE
  apply hζ
  rw [riemannZeta_def_of_ne_zero hs0, ← hFE, zero_div]

/-- **A2** — the zeros of ξ are exactly the target set: the zeros of ζ
that are neither trivial (`riemannZeta_neg_two_mul_nat_add_one`,
RiemannZeta.lean:171) nor the junk point 1. Bookkeeping through
ζ = Λ/Γℝ (`riemannZeta_def_of_ne_zero`), the Γℝ zero set
(`Complex.Gammaℝ_eq_zero_iff`, Gamma/Deligne.lean:73), ζ(0) = −1/2
(`riemannZeta_zero`), and the Λ-nonvanishing of
`completedRiemannZeta_neg_two_mul_ne_zero`. -/
theorem xi_zeros_eq_nontrivialZeros :
    {s : ℂ | xi s = 0}
      = {s : ℂ | riemannZeta s = 0 ∧ (¬∃ n : ℕ, s = -2 * (n + 1)) ∧ s ≠ 1} := by
  ext s
  simp only [Set.mem_setOf_eq]
  constructor
  · intro hxi
    have hs0 : s ≠ 0 := by
      rintro rfl
      rw [xi_zero] at hxi
      exact one_ne_zero hxi
    have hs1 : s ≠ 1 := by
      rintro rfl
      rw [xi_one] at hxi
      exact one_ne_zero hxi
    have hΛ : completedRiemannZeta s = 0 := by
      have h := xi_eq hs0 hs1
      rw [hxi] at h
      rcases mul_eq_zero.mp h.symm with h' | h'
      · exact absurd h' (mul_ne_zero hs0 (sub_ne_zero.mpr hs1))
      · exact h'
    have hG : Complex.Gammaℝ s ≠ 0 := by
      intro hG0
      obtain ⟨n, rfl⟩ := Complex.Gammaℝ_eq_zero_iff.mp hG0
      exact completedRiemannZeta_neg_two_mul_ne_zero n hΛ
    refine ⟨?_, ?_, hs1⟩
    · rw [riemannZeta_def_of_ne_zero hs0, hΛ, zero_div]
    · rintro ⟨n, rfl⟩
      apply hG
      rw [Complex.Gammaℝ_eq_zero_iff]
      exact ⟨n + 1, by push_cast; ring⟩
  · rintro ⟨hζ, htriv, hs1⟩
    have hs0 : s ≠ 0 := by
      rintro rfl
      rw [riemannZeta_zero] at hζ
      norm_num at hζ
    have hG : Complex.Gammaℝ s ≠ 0 := by
      intro hG0
      obtain ⟨n, hn⟩ := Complex.Gammaℝ_eq_zero_iff.mp hG0
      rcases n with _ | m
      · apply hs0
        rw [hn]
        norm_num
      · apply htriv
        exact ⟨m, by rw [hn]; push_cast; ring⟩
    have hΛ : completedRiemannZeta s = 0 := by
      have hdiv : completedRiemannZeta s / Complex.Gammaℝ s = 0 := by
        rw [← riemannZeta_def_of_ne_zero hs0, hζ]
      exact (div_eq_zero_iff.mp hdiv).resolve_right hG
    rw [xi_eq hs0 hs1, hΛ, mul_zero]
