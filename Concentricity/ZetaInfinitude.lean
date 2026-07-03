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
