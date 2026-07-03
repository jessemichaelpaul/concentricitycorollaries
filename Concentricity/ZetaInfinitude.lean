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
import Mathlib.Analysis.Meromorphic.FactorizedRational
import Mathlib.Analysis.Complex.HasPrimitives
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

/-! ## A3 — factorization of ξ under the finiteness hypothesis -/

/-- ξ is analytic on all of ℂ (A1 upgraded via `Differentiable.analyticAt`,
CauchyIntegral.lean:649). -/
theorem xi_analyticOnNhd : AnalyticOnNhd ℂ xi Set.univ :=
  fun z _ => xi_entire.analyticAt z

/-- ξ is nowhere locally constant zero: its meromorphic order is finite at
every point. Pin: `meromorphicOrderAt_eq_top_iff` (Meromorphic/Order.lean:64)
plus the identity principle
`AnalyticOnNhd.eqOn_zero_of_preconnected_of_frequently_eq_zero`
(IsolatedZeros.lean:214), contradicting ξ(0) = 1. -/
theorem xi_meromorphicOrderAt_ne_top (u : ℂ) : meromorphicOrderAt xi u ≠ ⊤ := by
  intro htop
  have hfreq : ∃ᶠ z in nhdsWithin u {u}ᶜ, xi z = 0 :=
    (meromorphicOrderAt_eq_top_iff.mp htop).frequently
  have h0 : xi 0 = 0 :=
    xi_analyticOnNhd.eqOn_zero_of_preconnected_of_frequently_eq_zero
      isPreconnected_univ (Set.mem_univ u) hfreq (Set.mem_univ 0)
  rw [xi_zero] at h0
  exact one_ne_zero h0

/-- The divisor of ξ is nonnegative: ξ is analytic, so its meromorphic order
is nonnegative everywhere (`AnalyticAt.meromorphicOrderAt_nonneg`,
Meromorphic/Order.lean:291; `WithTop.untop₀_nonneg`, Untop0.lean:108). -/
theorem xi_divisor_nonneg (z : ℂ) : 0 ≤ MeromorphicOn.divisor xi Set.univ z := by
  rw [MeromorphicOn.divisor_apply xi_analyticOnNhd.meromorphicOn (Set.mem_univ z)]
  exact WithTop.untop₀_nonneg.mpr (xi_entire.analyticAt z).meromorphicOrderAt_nonneg

/-- Off the zero set of ξ, the divisor of ξ vanishes
(`AnalyticAt.meromorphicOrderAt_eq`, Meromorphic/Order.lean:279;
`AnalyticAt.analyticOrderAt_eq_zero`, Analytic/Order.lean:133). -/
theorem xi_divisor_eq_zero_of_ne_zero {u : ℂ} (hu : xi u ≠ 0) :
    MeromorphicOn.divisor xi Set.univ u = 0 := by
  rw [MeromorphicOn.divisor_apply xi_analyticOnNhd.meromorphicOn (Set.mem_univ u),
    (xi_entire.analyticAt u).meromorphicOrderAt_eq,
    ((xi_entire.analyticAt u).analyticOrderAt_eq_zero).mpr hu]
  simp

/-- If the nontrivial-zero set is finite, the divisor of ξ has finite
support: the support lies in the zero set of ξ, which is the
nontrivial-zero set by A2. -/
theorem xi_divisor_support_finite
    (hfin : {s : ℂ | riemannZeta s = 0 ∧ (¬∃ n : ℕ, s = -2 * (n + 1)) ∧ s ≠ 1}.Finite) :
    (MeromorphicOn.divisor xi Set.univ).support.Finite := by
  have hzfin : {s : ℂ | xi s = 0}.Finite := by
    rw [xi_zeros_eq_nontrivialZeros]; exact hfin
  refine hzfin.subset fun u hu => ?_
  by_contra hxi
  exact hu (xi_divisor_eq_zero_of_ne_zero hxi)

/-- **A3** — under the finiteness hypothesis, ξ factors as a finite
factorized rational function times an entire nonvanishing function.
Pin: `MeromorphicOn.extract_zeros_poles`
(Meromorphic/FactorizedRational.lean:291); the codiscrete equality is
upgraded to everywhere by the identity principle
`AnalyticOnNhd.eqOn_of_preconnected_of_frequently_eq`
(IsolatedZeros.lean:238), both sides being analytic
(`Function.FactorizedRational.analyticAt`, FactorizedRational.lean:81);
the function-level finprod is evaluated pointwise by
`Function.FactorizedRational.finprod_eq_fun` (FactorizedRational.lean:67). -/
theorem xi_factorization_of_finite
    (hfin : {s : ℂ | riemannZeta s = 0 ∧ (¬∃ n : ℕ, s = -2 * (n + 1)) ∧ s ≠ 1}.Finite) :
    ∃ h : ℂ → ℂ, Differentiable ℂ h ∧ (∀ z, h z ≠ 0) ∧
      ∀ z, xi z = (∏ᶠ u, (z - u) ^ (MeromorphicOn.divisor xi Set.univ u)) * h z := by
  have hsupp : (MeromorphicOn.divisor xi Set.univ).support.Finite :=
    xi_divisor_support_finite hfin
  obtain ⟨h, h_an, h_ne, h_eq⟩ :=
    xi_analyticOnNhd.meromorphicOn.extract_zeros_poles
      (fun u => xi_meromorphicOrderAt_ne_top u) hsupp
  set φ : ℂ → ℂ := ∏ᶠ u, (· - u) ^ (MeromorphicOn.divisor xi Set.univ u) with hφ
  have hφ_an : AnalyticOnNhd ℂ φ Set.univ :=
    fun z _ => Function.FactorizedRational.analyticAt (xi_divisor_nonneg z)
  have hRHS_an : AnalyticOnNhd ℂ (fun z => φ z * h z) Set.univ :=
    fun z hz => (hφ_an z hz).mul (h_an z hz)
  -- extract frequent equality near 0 from the codiscrete equality
  have hfreq : ∃ᶠ z in nhdsWithin (0 : ℂ) {(0 : ℂ)}ᶜ, xi z = φ z * h z := by
    have hmem : {z | xi z = φ z * h z} ∈ Filter.codiscreteWithin (Set.univ : Set ℂ) := by
      filter_upwards [h_eq] with z hz
      simpa [Pi.smul_apply', smul_eq_mul] using hz
    have hnhds : {z | xi z = φ z * h z} ∪ (Set.univ : Set ℂ)ᶜ
        ∈ nhdsWithin (0 : ℂ) {(0 : ℂ)}ᶜ :=
      mem_codiscreteWithin_iff_forall_mem_nhdsNE.mp hmem 0 (Set.mem_univ 0)
    rw [Set.compl_univ, Set.union_empty] at hnhds
    exact (Filter.eventually_iff.mpr hnhds).frequently
  have hEq : Set.EqOn xi (fun z => φ z * h z) Set.univ :=
    xi_analyticOnNhd.eqOn_of_preconnected_of_frequently_eq hRHS_an
      isPreconnected_univ (Set.mem_univ 0) hfreq
  refine ⟨h, fun z => (h_an z (Set.mem_univ z)).differentiableAt,
    fun z => h_ne ⟨z, Set.mem_univ z⟩, fun z => ?_⟩
  have hz := hEq (Set.mem_univ z)
  rwa [hφ, Function.FactorizedRational.finprod_eq_fun hsupp] at hz

/-! ## A4 — global logarithm of an entire nonvanishing function -/

/-- **A4** — an entire nowhere-vanishing function has an entire logarithm.
Route: the logarithmic derivative `h'/h` is entire
(`DifferentiableOn.deriv`, CauchyIntegral.lean:644), so by Morera's theorem
for the complex plane it has a primitive g₀
(`Differentiable.isExactOn_univ`, HasPrimitives.lean:309); then
`h · exp(−g₀)` has vanishing derivative, hence is a nonzero constant
(`is_const_of_deriv_eq_zero`, MeanValue.lean:751), which is absorbed into
the logarithm (`Complex.exp_log`, Complex/Log.lean:41). -/
theorem exists_log_of_entire_nonvanishing {h : ℂ → ℂ}
    (hd : Differentiable ℂ h) (hne : ∀ z, h z ≠ 0) :
    ∃ g : ℂ → ℂ, Differentiable ℂ g ∧ ∀ z, h z = Complex.exp (g z) := by
  have hderiv : Differentiable ℂ (deriv h) :=
    differentiableOn_univ.mp (hd.differentiableOn.deriv isOpen_univ)
  have hf : Differentiable ℂ (fun z => deriv h z / h z) := hderiv.div hd hne
  obtain ⟨g₀, hg₀⟩ := hf.isExactOn_univ
  have hg₀' : ∀ z, HasDerivAt g₀ (deriv h z / h z) z :=
    fun z => hg₀ z (Set.mem_univ z)
  have hg₀_diff : Differentiable ℂ g₀ := fun z => (hg₀' z).differentiableAt
  set F : ℂ → ℂ := fun z => h z * Complex.exp (-(g₀ z)) with hF
  have hF_deriv : ∀ z, HasDerivAt F 0 z := by
    intro z
    have h1 : HasDerivAt h (deriv h z) z := (hd z).hasDerivAt
    have h2 : HasDerivAt (fun w => Complex.exp (-(g₀ w)))
        (Complex.exp (-(g₀ z)) * -(deriv h z / h z)) z := (hg₀' z).neg.cexp
    have h3 := h1.mul h2
    have key : deriv h z * Complex.exp (-(g₀ z))
        + h z * (Complex.exp (-(g₀ z)) * -(deriv h z / h z)) = 0 := by
      have hzne : h z ≠ 0 := hne z
      field_simp
      ring
    rwa [key] at h3
  have hF_diff : Differentiable ℂ F := fun z => (hF_deriv z).differentiableAt
  have hF_const : ∀ z, F z = F 0 := fun z =>
    is_const_of_deriv_eq_zero hF_diff (fun w => (hF_deriv w).deriv) z 0
  have hc : F 0 ≠ 0 := mul_ne_zero (hne 0) (Complex.exp_ne_zero _)
  refine ⟨fun z => g₀ z + Complex.log (F 0), hg₀_diff.add_const _, fun z => ?_⟩
  calc h z = h z * Complex.exp (-(g₀ z)) * Complex.exp (g₀ z) := by
        rw [mul_assoc, ← Complex.exp_add, neg_add_cancel, Complex.exp_zero, mul_one]
    _ = F 0 * Complex.exp (g₀ z) := by rw [← hF_const z]
    _ = Complex.exp (g₀ z + Complex.log (F 0)) := by
        rw [Complex.exp_add, Complex.exp_log hc, mul_comm]
