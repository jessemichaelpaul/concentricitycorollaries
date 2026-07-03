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

/-! ## A9 — real-axis lower bound for ξ -/

/-- ζ has real part ≥ 1 at real arguments σ > 1: the Dirichlet series
`ζ(σ) = ∑ n^{−σ}` has nonnegative real terms, and the n = 1 term equals 1.
Pins: `LSeriesHasSum_one` (Dirichlet.lean:311), `Complex.hasSum_re`
(Complex/Basic.lean:607), `le_hasSum` (InfiniteSum/Order.lean:105),
`Complex.ofReal_cpow` (Pow/Complex.lean). -/
theorem one_le_riemannZeta_re_of_real {σ : ℝ} (hσ : 1 < σ) :
    1 ≤ (riemannZeta (σ : ℂ)).re := by
  have hσ' : 1 < (σ : ℂ).re := by simpa using hσ
  have hsum : HasSum (fun n : ℕ => (LSeries.term 1 (σ : ℂ) n).re)
      (riemannZeta (σ : ℂ)).re :=
    Complex.hasSum_re (LSeriesHasSum_one hσ')
  have hterm : ∀ n : ℕ, n ≠ 0 →
      (LSeries.term 1 (σ : ℂ) n).re = ((n : ℝ) ^ σ)⁻¹ := by
    intro n hn
    rw [LSeries.term_of_ne_zero hn, Pi.one_apply,
      show ((n : ℂ)) ^ (σ : ℂ) = (((n : ℝ) ^ σ : ℝ) : ℂ) by
        rw [Complex.ofReal_cpow (Nat.cast_nonneg n), Complex.ofReal_natCast],
      one_div, ← Complex.ofReal_inv, Complex.ofReal_re]
  have hnonneg : ∀ j : ℕ, j ≠ 1 → 0 ≤ (LSeries.term 1 (σ : ℂ) j).re := by
    intro j _
    rcases eq_or_ne j 0 with rfl | hj
    · simp [LSeries.term_zero]
    · rw [hterm j hj]; positivity
  have h1 : (LSeries.term 1 (σ : ℂ) 1).re = 1 := by
    rw [hterm 1 one_ne_zero]
    simp
  calc (1 : ℝ) = (LSeries.term 1 (σ : ℂ) 1).re := h1.symm
    _ ≤ (riemannZeta (σ : ℂ)).re := le_hasSum hsum 1 hnonneg

/-- **A9** — the real-axis Γ-growth of ξ beats every geometric sequence:
along σ = 2n + 2, eventually K^n ≤ ‖ξ(σ)‖. Route: ξ(σ) = σ(σ−1)Λ(σ) (A1),
Λ(σ) = ζ(σ)·Γℝ(σ) (`riemannZeta_def_of_ne_zero`, RiemannZeta.lean:152),
Γℝ(2n+2) = π^{−(n+1)}·n! (`Complex.Gammaℝ_def`, Deligne.lean:45;
`Complex.Gamma_nat_eq_factorial`, Gamma/Basic.lean:324;
`Complex.norm_cpow_eq_rpow_re_of_pos`, Pow/Real.lean:337), ‖ζ(2n+2)‖ ≥ 1
(`one_le_riemannZeta_re_of_real`), and n! eventually dominates π·(Kπ)^n
(`FloorSemiring.tendsto_pow_div_factorial_atTop`,
Topology/Algebra/Order/Floor.lean:54). -/
theorem gamma_lower_bound_real (K : ℝ) :
    ∀ᶠ (n : ℕ) in Filter.atTop, K ^ n ≤ ‖xi (2 * (n : ℂ) + 2)‖ := by
  set K' : ℝ := |K| + 1 with hK'
  have hK'0 : 0 < K' := by positivity
  -- the factorial eventually dominates K'^n · π^(n+1)
  have hfact : ∀ᶠ (n : ℕ) in Filter.atTop,
      K' ^ n * Real.pi ^ (n + 1) ≤ (Nat.factorial n : ℝ) := by
    have h0 := FloorSemiring.tendsto_pow_div_factorial_atTop (K := ℝ) (K' * Real.pi)
    have hπ : (0 : ℝ) < Real.pi⁻¹ := by positivity
    filter_upwards [h0.eventually (gt_mem_nhds hπ)] with n hn
    have hfac : (0 : ℝ) < (Nat.factorial n : ℝ) := by exact_mod_cast Nat.factorial_pos n
    rw [div_lt_iff₀ hfac] at hn
    have hπpos := Real.pi_pos
    have hkey : Real.pi * (K' * Real.pi) ^ n < (Nat.factorial n : ℝ) := by
      calc Real.pi * (K' * Real.pi) ^ n
          < Real.pi * (Real.pi⁻¹ * (Nat.factorial n : ℝ)) := by
            exact mul_lt_mul_of_pos_left hn hπpos
        _ = (Nat.factorial n : ℝ) := by field_simp
    calc K' ^ n * Real.pi ^ (n + 1) = Real.pi * (K' * Real.pi) ^ n := by ring
      _ ≤ (Nat.factorial n : ℝ) := hkey.le
  -- the pointwise lower bound ‖ξ(2n+2)‖ ≥ n!/π^(n+1)
  have hxi_lower : ∀ n : ℕ,
      (Nat.factorial n : ℝ) * (Real.pi ^ (n + 1))⁻¹ ≤ ‖xi (2 * (n : ℂ) + 2)‖ := by
    intro n
    set s : ℂ := 2 * (n : ℂ) + 2 with hs
    have hs_re : s.re = 2 * (n : ℝ) + 2 := by simp [hs]
    have hn0 : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    have hs0 : s ≠ 0 := by
      intro h
      have h' := congrArg Complex.re h
      rw [hs_re] at h'
      simp only [Complex.zero_re] at h'
      linarith
    have hs1 : s ≠ 1 := by
      intro h
      have h' := congrArg Complex.re h
      rw [hs_re] at h'
      simp only [Complex.one_re] at h'
      linarith
    have hG : Complex.Gammaℝ s ≠ 0 := by
      intro h
      obtain ⟨m, hm⟩ := Complex.Gammaℝ_eq_zero_iff.mp h
      have h' := congrArg Complex.re hm
      rw [hs_re] at h'
      have hm0 : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
      have : (-(2 * (m : ℂ))).re = -(2 * (m : ℝ)) := by simp
      rw [this] at h'
      linarith
    have hΛ : completedRiemannZeta s = riemannZeta s * Complex.Gammaℝ s := by
      rw [riemannZeta_def_of_ne_zero hs0, div_mul_cancel₀ _ hG]
    have hs2 : s / 2 = (n : ℂ) + 1 := by rw [hs]; ring
    have hGval : Complex.Gammaℝ s = (Real.pi : ℂ) ^ (-s / 2) * ((Nat.factorial n : ℕ) : ℂ) := by
      rw [Complex.Gammaℝ_def, hs2, Complex.Gamma_nat_eq_factorial]
    have hneg : -s / 2 = -((n : ℂ) + 1) := by rw [hs]; ring
    have hnorm_pi : ‖(Real.pi : ℂ) ^ (-s / 2)‖ = (Real.pi ^ (n + 1))⁻¹ := by
      rw [hneg, Complex.norm_cpow_eq_rpow_re_of_pos Real.pi_pos]
      have hre : (-((n : ℂ) + 1)).re = -((n : ℝ) + 1) := by simp
      rw [hre, Real.rpow_neg Real.pi_pos.le]
      congr 1
      rw [show ((n : ℝ) + 1) = ((n + 1 : ℕ) : ℝ) by push_cast; ring, Real.rpow_natCast]
    have hGnorm : ‖Complex.Gammaℝ s‖ = (Real.pi ^ (n + 1))⁻¹ * (Nat.factorial n : ℝ) := by
      rw [hGval, norm_mul, hnorm_pi]
      congr 1
      rw [show ((Nat.factorial n : ℕ) : ℂ) = (((Nat.factorial n : ℕ) : ℝ) : ℂ) by push_cast; ring,
        Complex.norm_real, Real.norm_of_nonneg (by positivity)]
    have hζ : 1 ≤ ‖riemannZeta s‖ := by
      have hcast : s = ((2 * (n : ℝ) + 2 : ℝ) : ℂ) := by rw [hs]; push_cast; ring
      have h1 : 1 < (2 * (n : ℝ) + 2 : ℝ) := by linarith
      calc (1 : ℝ) ≤ (riemannZeta ((2 * (n : ℝ) + 2 : ℝ) : ℂ)).re :=
            one_le_riemannZeta_re_of_real h1
        _ ≤ |(riemannZeta ((2 * (n : ℝ) + 2 : ℝ) : ℂ)).re| := le_abs_self _
        _ ≤ ‖riemannZeta ((2 * (n : ℝ) + 2 : ℝ) : ℂ)‖ := Complex.abs_re_le_norm _
        _ = ‖riemannZeta s‖ := by rw [← hcast]
    have hs_norm : 1 ≤ ‖s‖ := by
      calc (1 : ℝ) ≤ |s.re| := by
            rw [hs_re, abs_of_nonneg (by linarith)]; linarith
        _ ≤ ‖s‖ := Complex.abs_re_le_norm s
    have hs1_norm : 1 ≤ ‖s - 1‖ := by
      have hre : (s - 1).re = 2 * (n : ℝ) + 1 := by
        rw [Complex.sub_re, hs_re, Complex.one_re]; ring
      calc (1 : ℝ) ≤ |(s - 1).re| := by
            rw [hre, abs_of_nonneg (by linarith)]; linarith
        _ ≤ ‖s - 1‖ := Complex.abs_re_le_norm _
    have hxi_val : xi s = s * (s - 1) * (riemannZeta s * Complex.Gammaℝ s) := by
      rw [xi_eq hs0 hs1, hΛ]
    rw [hxi_val]
    calc (Nat.factorial n : ℝ) * (Real.pi ^ (n + 1))⁻¹
        = (Real.pi ^ (n + 1))⁻¹ * (Nat.factorial n : ℝ) := by ring
      _ ≤ ‖riemannZeta s‖ * ‖Complex.Gammaℝ s‖ := by
          rw [hGnorm]
          exact le_mul_of_one_le_left (by positivity) hζ
      _ ≤ ‖s - 1‖ * (‖riemannZeta s‖ * ‖Complex.Gammaℝ s‖) :=
          le_mul_of_one_le_left (by positivity) hs1_norm
      _ ≤ ‖s‖ * (‖s - 1‖ * (‖riemannZeta s‖ * ‖Complex.Gammaℝ s‖)) :=
          le_mul_of_one_le_left (by positivity) hs_norm
      _ = ‖s * (s - 1) * (riemannZeta s * Complex.Gammaℝ s)‖ := by
          rw [norm_mul, norm_mul, norm_mul]; ring
  -- assemble
  filter_upwards [hfact] with n hn
  have h1 : K ^ n ≤ K' ^ n := by
    calc K ^ n ≤ |K ^ n| := le_abs_self _
      _ = |K| ^ n := abs_pow K n
      _ ≤ K' ^ n := by
          apply pow_le_pow_left₀ (abs_nonneg K)
          rw [hK']
          linarith
  have h2 : K' ^ n ≤ (Nat.factorial n : ℝ) * (Real.pi ^ (n + 1))⁻¹ := by
    have hπpow : (0 : ℝ) < Real.pi ^ (n + 1) := by positivity
    have := (le_div_iff₀ hπpow).mpr hn
    rwa [div_eq_mul_inv] at this
  exact h1.trans (h2.trans (hxi_lower n))

/-! ## A5 — growth of the completed zeta: ‖Λ₀(s)‖ ≤ C·exp(C·(‖s‖+2)·log(‖s‖+2)) -/

section GrowthBound

open Set MeasureTheory HurwitzZeta Asymptotics

/-- The norm of `Λ₀` is bounded by the norm-integral of its Mellin integrand
(`WeakFEPair.Λ₀`, AbstractFuncEq.lean:385; `mellin`, MellinTransform.lean:91;
`norm_integral_le_integral_norm`; `Complex.norm_cpow_eq_rpow_re_of_pos`,
Pow/Real.lean:337). -/
theorem lambda0_norm_le (w : ℂ) :
    ‖(hurwitzEvenFEPair 0).Λ₀ w‖
      ≤ ∫ t in Ioi (0 : ℝ), t ^ (w.re - 1) * ‖(hurwitzEvenFEPair 0).f_modif t‖ := by
  have h1 : ‖(hurwitzEvenFEPair 0).Λ₀ w‖
      = ‖∫ t in Ioi (0 : ℝ), (t : ℂ) ^ (w - 1) • (hurwitzEvenFEPair 0).f_modif t‖ := rfl
  rw [h1]
  refine (norm_integral_le_integral_norm _).trans (le_of_eq ?_)
  refine setIntegral_congr_fun measurableSet_Ioi fun t ht => ?_
  rw [norm_smul, Complex.norm_cpow_eq_rpow_re_of_pos ht, Complex.sub_re, Complex.one_re]

/-- The Mellin integrand of `f_modif` is norm-integrable on (0, ∞) for every
real exponent (`StrongFEPair.hasMellin`, AbstractFuncEq.lean:203, applied to
`WeakFEPair.toStrongFEPair`, AbstractFuncEq.lean:307). -/
theorem f_modif_norm_integrable (c : ℝ) :
    IntegrableOn (fun t : ℝ => t ^ (c - 1) * ‖(hurwitzEvenFEPair 0).f_modif t‖)
      (Ioi (0 : ℝ)) := by
  have h2 : IntegrableOn
      (fun t : ℝ => ‖(t : ℂ) ^ ((c : ℂ) - 1) • (hurwitzEvenFEPair 0).f_modif t‖)
      (Ioi (0 : ℝ)) :=
    ((hurwitzEvenFEPair 0).toStrongFEPair.hasMellin (c : ℂ)).1.norm
  refine (integrableOn_congr_fun (fun t ht => ?_) measurableSet_Ioi).mp h2
  rw [norm_smul, Complex.norm_cpow_eq_rpow_re_of_pos ht]
  norm_num

/-- The (0, 1] piece of the Mellin bound is uniformly bounded over all
exponents x ≥ 1/4 (`Real.rpow_le_rpow_of_exponent_ge`, Pow/Real.lean:639;
`setIntegral_mono_on`, Bochner/Set.lean:764). -/
theorem piece_A_bound : ∃ C₀ : ℝ, 0 ≤ C₀ ∧ ∀ x : ℝ, 1 / 4 ≤ x →
    (∫ t in Ioc (0 : ℝ) 1, t ^ (x - 1) * ‖(hurwitzEvenFEPair 0).f_modif t‖) ≤ C₀ := by
  refine ⟨∫ t in Ioc (0 : ℝ) 1, t ^ (1 / 4 - 1 : ℝ) * ‖(hurwitzEvenFEPair 0).f_modif t‖,
    setIntegral_nonneg measurableSet_Ioc fun t ht =>
      mul_nonneg (Real.rpow_nonneg ht.1.le _) (norm_nonneg _), fun x hx => ?_⟩
  refine setIntegral_mono_on
    ((f_modif_norm_integrable x).mono_set Ioc_subset_Ioi_self)
    ((f_modif_norm_integrable (1 / 4)).mono_set Ioc_subset_Ioi_self)
    measurableSet_Ioc fun t ht => ?_
  exact mul_le_mul_of_nonneg_right
    (Real.rpow_le_rpow_of_exponent_ge ht.1 ht.2 (by linarith)) (norm_nonneg _)

/-- Uniform exponential decay of `f_modif` on (1, ∞): the theta-kernel decay
(`isBigO_atTop_evenKernel_sub`, HurwitzZetaEven.lean:223) on a tail, plus a
compactness bound (`IsCompact.exists_bound_of_continuousOn`,
Normed/Group/Bounded.lean:96; `continuousOn_evenKernel`,
HurwitzZetaEven.lean:116) on the middle range. -/
theorem f_modif_exp_decay : ∃ p C₂ : ℝ, 0 < p ∧ 0 ≤ C₂ ∧
    ∀ t : ℝ, 1 < t →
      ‖(hurwitzEvenFEPair 0).f_modif t‖ ≤ C₂ * Real.exp (-p * t) := by
  obtain ⟨p, hp, hbig₀⟩ := isBigO_atTop_evenKernel_sub (0 : UnitAddCircle)
  have hbig : (fun t : ℝ => evenKernel 0 t - 1)
      =O[Filter.atTop] fun t : ℝ => Real.exp (-p * t) := by simpa using hbig₀
  obtain ⟨c, hc, hbigW⟩ := hbig.exists_pos
  have hev := hbigW.bound
  rw [Filter.eventually_atTop] at hev
  obtain ⟨T₀, hT₀⟩ := hev
  set T : ℝ := max T₀ 2 with hT
  have hcont : ContinuousOn (fun t : ℝ => evenKernel 0 t - 1) (Icc (1 : ℝ) T) :=
    ((continuousOn_evenKernel 0).mono fun t ht =>
      lt_of_lt_of_le zero_lt_one ht.1).sub continuousOn_const
  obtain ⟨M, hM⟩ := isCompact_Icc.exists_bound_of_continuousOn hcont
  set C₂ : ℝ := max c (max M 0 * Real.exp (p * T)) with hC₂
  have hC₂0 : 0 ≤ C₂ := le_trans hc.le (le_max_left _ _)
  have hf₀ : (hurwitzEvenFEPair 0).f₀ = 1 := if_pos rfl
  refine ⟨p, C₂, hp, hC₂0, fun t ht => ?_⟩
  have hnorm : ‖(hurwitzEvenFEPair 0).f_modif t‖ = ‖evenKernel 0 t - 1‖ := by
    have h1 : (hurwitzEvenFEPair 0).f_modif t
        = (hurwitzEvenFEPair 0).f t - (hurwitzEvenFEPair 0).f₀ := by
      simp only [WeakFEPair.f_modif, Pi.add_apply]
      rw [Set.indicator_of_mem (Set.mem_Ioi.mpr ht),
        Set.indicator_of_notMem (Set.notMem_Ioo_of_ge ht.le), add_zero]
    rw [h1, hf₀, show (hurwitzEvenFEPair 0).f t = ((evenKernel 0 t : ℝ) : ℂ) from rfl,
      show ((evenKernel 0 t : ℝ) : ℂ) - 1 = ((evenKernel 0 t - 1 : ℝ) : ℂ) by push_cast; ring,
      Complex.norm_real]
  rw [hnorm]
  rcases le_or_gt T t with hTt | htT
  · have h1 := hT₀ t (le_trans (le_max_left _ _) hTt)
    calc ‖evenKernel 0 t - 1‖ ≤ c * ‖Real.exp (-p * t)‖ := h1
      _ = c * Real.exp (-p * t) := by
          rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
      _ ≤ C₂ * Real.exp (-p * t) :=
          mul_le_mul_of_nonneg_right (le_max_left _ _) (Real.exp_pos _).le
  · have hmem : t ∈ Icc (1 : ℝ) T := ⟨ht.le, htT.le⟩
    have h1 : ‖evenKernel 0 t - 1‖ ≤ max M 0 := le_trans (hM t hmem) (le_max_left _ _)
    have h2 : (1 : ℝ) ≤ Real.exp (p * T) * Real.exp (-p * t) := by
      rw [← Real.exp_add, ← Real.exp_zero]
      apply Real.exp_le_exp.mpr
      nlinarith [hp, htT.le]
    calc ‖evenKernel 0 t - 1‖ ≤ max M 0 := h1
      _ ≤ max M 0 * (Real.exp (p * T) * Real.exp (-p * t)) :=
          le_mul_of_one_le_right (le_max_right _ _) h2
      _ = max M 0 * Real.exp (p * T) * Real.exp (-p * t) := by ring
      _ ≤ C₂ * Real.exp (-p * t) :=
          mul_le_mul_of_nonneg_right (le_max_right _ _) (Real.exp_pos _).le

/-- The (1, ∞) piece: the Γ-type bound
`∫₁^∞ t^{x−1}·‖f_modif t‖ dt ≤ C₃·exp(x·log(A·x))`, via the elementary
estimate `log t ≤ log(2x/p) + pt/(2x) − 1` (`Real.log_le_sub_one_of_pos`,
Log/Basic.lean:306; `integrableOn_exp_mul_Ioi`, ImproperIntegrals.lean:78). -/
theorem piece_B_bound : ∃ C₃ A : ℝ, 0 ≤ C₃ ∧ 0 < A ∧ ∀ x : ℝ, 1 / 4 ≤ x →
    (∫ t in Ioi (1 : ℝ), t ^ (x - 1) * ‖(hurwitzEvenFEPair 0).f_modif t‖)
      ≤ C₃ * Real.exp (x * Real.log (A * x)) := by
  obtain ⟨p, C₂, hp, hC₂, hdecay⟩ := f_modif_exp_decay
  set Cp : ℝ := ∫ t in Ioi (1 : ℝ), Real.exp (-(p / 2) * t) with hCp
  have hCp0 : 0 ≤ Cp :=
    setIntegral_nonneg measurableSet_Ioi fun t _ => (Real.exp_pos _).le
  refine ⟨C₂ * Cp, 2 / p, mul_nonneg hC₂ hCp0, by positivity, fun x hx => ?_⟩
  have hx0 : 0 < x := by linarith
  have hpt : ∀ t : ℝ, t ∈ Ioi (1 : ℝ) →
      t ^ (x - 1) * ‖(hurwitzEvenFEPair 0).f_modif t‖
        ≤ C₂ * Real.exp (x * Real.log (2 / p * x)) * Real.exp (-(p / 2) * t) := by
    intro t ht
    rw [mem_Ioi] at ht
    have ht0 : (0 : ℝ) < t := lt_trans zero_lt_one ht
    have hlog : Real.log t ≤ Real.log (2 / p * x) + p / (2 * x) * t - 1 := by
      have hu : (0 : ℝ) < t * (p / (2 * x)) := by positivity
      have h1 := Real.log_le_sub_one_of_pos hu
      rw [Real.log_mul (ne_of_gt ht0) (by positivity)] at h1
      have h2 : Real.log (p / (2 * x)) = -Real.log (2 / p * x) := by
        rw [← Real.log_inv]
        congr 1
        field_simp
      linarith [h1, h2]
    have h3 : t ^ (x - 1) ≤ t ^ x :=
      Real.rpow_le_rpow_of_exponent_le ht.le (by linarith)
    have h4 : t ^ x = Real.exp (Real.log t * x) := Real.rpow_def_of_pos ht0 x
    have h5 : Real.log t * x ≤ x * Real.log (2 / p * x) + p / 2 * t - x := by
      have hmul := mul_le_mul_of_nonneg_left hlog hx0.le
      have hxx : x * (p / (2 * x) * t) = p / 2 * t := by
        field_simp
      nlinarith [hmul, hxx]
    have h6 : t ^ (x - 1) ≤ Real.exp (x * Real.log (2 / p * x) + p / 2 * t - x) := by
      rw [h4] at h3
      exact h3.trans (Real.exp_le_exp.mpr (by linarith))
    have h7 : ‖(hurwitzEvenFEPair 0).f_modif t‖ ≤ C₂ * Real.exp (-p * t) := hdecay t ht
    calc t ^ (x - 1) * ‖(hurwitzEvenFEPair 0).f_modif t‖
        ≤ Real.exp (x * Real.log (2 / p * x) + p / 2 * t - x)
            * (C₂ * Real.exp (-p * t)) :=
          mul_le_mul h6 h7 (norm_nonneg _) (Real.exp_pos _).le
      _ = C₂ * Real.exp (x * Real.log (2 / p * x) + p / 2 * t - x + -p * t) := by
          rw [Real.exp_add]
          ring
      _ ≤ C₂ * Real.exp (x * Real.log (2 / p * x) + -(p / 2) * t) := by
          apply mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr (by linarith)) hC₂
      _ = C₂ * Real.exp (x * Real.log (2 / p * x)) * Real.exp (-(p / 2) * t) := by
          rw [Real.exp_add]
          ring
  have hint1 : IntegrableOn
      (fun t : ℝ => t ^ (x - 1) * ‖(hurwitzEvenFEPair 0).f_modif t‖) (Ioi (1 : ℝ)) :=
    (f_modif_norm_integrable x).mono_set (Ioi_subset_Ioi zero_le_one)
  have hint2 : IntegrableOn
      (fun t : ℝ => C₂ * Real.exp (x * Real.log (2 / p * x)) * Real.exp (-(p / 2) * t))
      (Ioi (1 : ℝ)) :=
    (integrableOn_exp_mul_Ioi (by linarith) 1).const_mul _
  calc (∫ t in Ioi (1 : ℝ), t ^ (x - 1) * ‖(hurwitzEvenFEPair 0).f_modif t‖)
      ≤ ∫ t in Ioi (1 : ℝ),
          C₂ * Real.exp (x * Real.log (2 / p * x)) * Real.exp (-(p / 2) * t) :=
        setIntegral_mono_on hint1 hint2 measurableSet_Ioi hpt
    _ = C₂ * Real.exp (x * Real.log (2 / p * x)) * Cp := by
        rw [hCp, ← integral_const_mul]
    _ = C₂ * Cp * Real.exp (x * Real.log (2 / p * x)) := by ring

/-- Right-half growth bound for `Λ₀` of the theta FE-pair: split the Mellin
norm-integral at t = 1 (`setIntegral_union`, Bochner/Set.lean:87;
`Set.Ioc_union_Ioi_eq_Ioi`, Interval/Set/LinearOrder.lean:198). -/
theorem lambda0_bound_right : ∃ C₀ C₃ A : ℝ, 0 ≤ C₀ ∧ 0 ≤ C₃ ∧ 0 < A ∧
    ∀ w : ℂ, 1 / 4 ≤ w.re →
      ‖(hurwitzEvenFEPair 0).Λ₀ w‖
        ≤ C₀ + C₃ * Real.exp (w.re * Real.log (A * w.re)) := by
  obtain ⟨C₀, hC₀, hA⟩ := piece_A_bound
  obtain ⟨C₃, A, hC₃, hApos, hB⟩ := piece_B_bound
  refine ⟨C₀, C₃, A, hC₀, hC₃, hApos, fun w hw => ?_⟩
  refine (lambda0_norm_le w).trans ?_
  have hsplit : (∫ t in Ioi (0 : ℝ), t ^ (w.re - 1) * ‖(hurwitzEvenFEPair 0).f_modif t‖)
      = (∫ t in Ioc (0 : ℝ) 1, t ^ (w.re - 1) * ‖(hurwitzEvenFEPair 0).f_modif t‖)
        + ∫ t in Ioi (1 : ℝ), t ^ (w.re - 1) * ‖(hurwitzEvenFEPair 0).f_modif t‖ := by
    rw [← setIntegral_union (Ioc_disjoint_Ioi le_rfl) measurableSet_Ioi
      ((f_modif_norm_integrable w.re).mono_set Ioc_subset_Ioi_self)
      ((f_modif_norm_integrable w.re).mono_set (Ioi_subset_Ioi zero_le_one)),
      Ioc_union_Ioi_eq_Ioi zero_le_one]
  rw [hsplit]
  exact add_le_add (hA w.re hw) (hB w.re hw)

/-- The Λ₀-functional equation specializes to the reflection
`Λ₀(w) = Λ₀(1/2 − w)` (`WeakFEPair.functional_equation₀`,
AbstractFuncEq.lean:429; `hurwitzEvenFEPair_zero_symm`,
HurwitzZetaEven.lean:279). -/
theorem lambda0_reflect (w : ℂ) :
    (hurwitzEvenFEPair 0).Λ₀ w = (hurwitzEvenFEPair 0).Λ₀ ((1 : ℂ) / 2 - w) := by
  have h := (hurwitzEvenFEPair 0).functional_equation₀ w
  rw [hurwitzEvenFEPair_zero_symm] at h
  have hk : (((hurwitzEvenFEPair 0).k : ℝ) : ℂ) = (1 : ℂ) / 2 := by
    rw [show (hurwitzEvenFEPair 0).k = 1 / 2 from rfl]
    push_cast
    norm_num
  have hε : (hurwitzEvenFEPair 0).ε = 1 := rfl
  rw [hk, hε, one_smul] at h
  exact h.symm

/-- Pure-real massage: the raw bound `C₀ + C₁·exp(x·log(A·x))` for
1/4 ≤ x ≤ X + 2 is absorbed into the single-constant form
`C·exp(C·(X+2)·log(X+2))`. Elementary log/exp bookkeeping
(`Real.log_mul`, `Real.log_nonpos`, `Real.log_le_log`, `Real.one_le_exp`). -/
theorem growth_massage {C₀ C₁ A : ℝ} (hC₀ : 0 ≤ C₀) (hC₁ : 0 ≤ C₁) (hA : 0 < A) :
    ∃ C : ℝ, 0 < C ∧ ∀ x X : ℝ, 1 / 4 ≤ x → x ≤ X + 2 → 0 ≤ X →
      C₀ + C₁ * Real.exp (x * Real.log (A * x))
        ≤ C * Real.exp (C * (X + 2) * Real.log (X + 2)) := by
  have hlog2 : 0 < Real.log 2 := Real.log_pos one_lt_two
  set L : ℝ := max (Real.log A) 0 with hLdef
  have hL0 : 0 ≤ L := le_max_right _ _
  set C' : ℝ := 2 * L / Real.log 2 + 1 with hC'def
  have hC'0 : 0 < C' := by positivity
  set C : ℝ := C' + (C₀ + C₁) + 1 with hCdef
  have hC0 : 0 < C := by positivity
  refine ⟨C, hC0, fun x X hx hxX hX => ?_⟩
  have hx0 : 0 < x := by linarith
  have hX2 : (2 : ℝ) ≤ X + 2 := by linarith
  have hlogX : Real.log 2 ≤ Real.log (X + 2) := Real.log_le_log two_pos hX2
  have hlogX0 : 0 < Real.log (X + 2) := lt_of_lt_of_le hlog2 hlogX
  have hXlog0 : 0 ≤ (X + 2) * Real.log (X + 2) := by positivity
  have hlogA_le : Real.log A ≤ L := le_max_left _ _
  have hLlog : L ≤ 2 * L / Real.log 2 * Real.log (X + 2) := by
    rw [div_mul_eq_mul_div, le_div_iff₀ hlog2]
    nlinarith [mul_le_mul_of_nonneg_left hlogX hL0,
      mul_nonneg hL0 hlogX0.le]
  have hkey : x * Real.log (A * x) ≤ C' * ((X + 2) * Real.log (X + 2)) := by
    have hlogAx : Real.log (A * x) = Real.log A + Real.log x :=
      Real.log_mul hA.ne' hx0.ne'
    rcases le_or_gt x 1 with hx1 | hx1
    · have h1 : x * Real.log x ≤ 0 :=
        mul_nonpos_of_nonneg_of_nonpos hx0.le (Real.log_nonpos hx0.le hx1)
      have h2 : x * Real.log A ≤ L := by
        rcases le_or_gt (Real.log A) 0 with hLA | hLA
        · exact le_trans (mul_nonpos_of_nonneg_of_nonpos hx0.le hLA) hL0
        · calc x * Real.log A ≤ 1 * Real.log A :=
              mul_le_mul_of_nonneg_right hx1 hLA.le
            _ = Real.log A := one_mul _
            _ ≤ L := hlogA_le
      have h3 : x * Real.log (A * x) ≤ L := by
        rw [hlogAx, mul_add]
        linarith
      calc x * Real.log (A * x) ≤ L := h3
        _ ≤ 2 * L / Real.log 2 * Real.log (X + 2) := hLlog
        _ ≤ 2 * L / Real.log 2 * ((X + 2) * Real.log (X + 2)) := by
            apply mul_le_mul_of_nonneg_left ?_ (by positivity)
            nlinarith [mul_nonneg (by linarith : (0 : ℝ) ≤ X + 1) hlogX0.le]
        _ ≤ C' * ((X + 2) * Real.log (X + 2)) := by
            apply mul_le_mul_of_nonneg_right ?_ hXlog0
            rw [hC'def]
            linarith
    · have hlx0 : 0 ≤ Real.log x := Real.log_nonneg hx1.le
      have hlxle : Real.log x ≤ Real.log (X + 2) := Real.log_le_log hx0 hxX
      have h1 : x * Real.log x ≤ (X + 2) * Real.log (X + 2) :=
        mul_le_mul hxX hlxle hlx0 (by linarith)
      have h2 : x * Real.log A ≤ (X + 2) * L := by
        rcases le_or_gt (Real.log A) 0 with hLA | hLA
        · exact le_trans (mul_nonpos_of_nonneg_of_nonpos hx0.le hLA)
            (mul_nonneg (by linarith) hL0)
        · calc x * Real.log A ≤ (X + 2) * Real.log A :=
              mul_le_mul_of_nonneg_right hxX hLA.le
            _ ≤ (X + 2) * L := mul_le_mul_of_nonneg_left hlogA_le (by linarith)
      have h3 : (X + 2) * L ≤ (X + 2) * (2 * L / Real.log 2 * Real.log (X + 2)) :=
        mul_le_mul_of_nonneg_left hLlog (by linarith)
      rw [hlogAx, mul_add]
      calc x * Real.log A + x * Real.log x
          ≤ (X + 2) * (2 * L / Real.log 2 * Real.log (X + 2))
            + (X + 2) * Real.log (X + 2) := by linarith [h2.trans h3, h1]
        _ = C' * ((X + 2) * Real.log (X + 2)) := by
            rw [hC'def]
            ring
  have hCC' : C' ≤ C := by
    rw [hCdef]
    linarith
  have hexp : Real.exp (x * Real.log (A * x))
      ≤ Real.exp (C * (X + 2) * Real.log (X + 2)) := by
    apply Real.exp_le_exp.mpr
    calc x * Real.log (A * x) ≤ C' * ((X + 2) * Real.log (X + 2)) := hkey
      _ ≤ C * ((X + 2) * Real.log (X + 2)) := mul_le_mul_of_nonneg_right hCC' hXlog0
      _ = C * (X + 2) * Real.log (X + 2) := by ring
  have hone : (1 : ℝ) ≤ Real.exp (C * (X + 2) * Real.log (X + 2)) := by
    apply Real.one_le_exp
    rw [mul_assoc]
    exact mul_nonneg hC0.le hXlog0
  calc C₀ + C₁ * Real.exp (x * Real.log (A * x))
      ≤ C₀ * Real.exp (C * (X + 2) * Real.log (X + 2))
        + C₁ * Real.exp (C * (X + 2) * Real.log (X + 2)) := by
        apply add_le_add
        · exact le_mul_of_one_le_right hC₀ hone
        · exact mul_le_mul_of_nonneg_left hexp hC₁
    _ = (C₀ + C₁) * Real.exp (C * (X + 2) * Real.log (X + 2)) := by ring
    _ ≤ C * Real.exp (C * (X + 2) * Real.log (X + 2)) := by
        apply mul_le_mul_of_nonneg_right ?_ (Real.exp_pos _).le
        rw [hCdef]
        linarith

/-- **A5** — the completed-zeta growth bound: there is C > 0 with
`‖completedRiemannZeta₀ s‖ ≤ C·exp(C·(‖s‖+2)·log(‖s‖+2))` for every s.
Derived from the Mellin/theta representation (`completedRiemannZeta₀` =
`(hurwitzEvenFEPair 0).Λ₀ (s/2) / 2`, RiemannZeta.lean:63 +
HurwitzZetaEven.lean:302) via `lambda0_bound_right` on the right half-plane
and the unconditional functional equation `lambda0_reflect` on the left. -/
theorem completedZeta₀_growth : ∃ C : ℝ, 0 < C ∧ ∀ s : ℂ,
    ‖completedRiemannZeta₀ s‖
      ≤ C * Real.exp (C * (‖s‖ + 2) * Real.log (‖s‖ + 2)) := by
  obtain ⟨C₀, C₃, A, hC₀, hC₃, hApos, hright⟩ := lambda0_bound_right
  obtain ⟨C, hCpos, hmas⟩ := growth_massage hC₀ hC₃ hApos
  refine ⟨C, hCpos, fun s => ?_⟩
  have hhalf : ‖completedRiemannZeta₀ s‖ ≤ ‖(hurwitzEvenFEPair 0).Λ₀ (s / 2)‖ := by
    have hval : completedRiemannZeta₀ s = ((hurwitzEvenFEPair 0).Λ₀ (s / 2)) / 2 := rfl
    rw [hval, norm_div, Complex.norm_ofNat]
    exact div_le_self (norm_nonneg _) one_le_two
  have hs2 : ‖s / 2‖ ≤ ‖s‖ := by
    rw [norm_div, Complex.norm_ofNat]
    exact div_le_self (norm_nonneg _) one_le_two
  refine hhalf.trans ?_
  rcases le_or_gt (1 / 4 : ℝ) ((s / 2).re) with hcase | hcase
  · refine (hright (s / 2) hcase).trans ?_
    apply hmas _ _ hcase ?_ (norm_nonneg s)
    calc (s / 2).re ≤ |(s / 2).re| := le_abs_self _
      _ ≤ ‖s / 2‖ := Complex.abs_re_le_norm _
      _ ≤ ‖s‖ := hs2
      _ ≤ ‖s‖ + 2 := by linarith
  · rw [lambda0_reflect (s / 2)]
    have hre' : ((1 : ℂ) / 2 - s / 2).re = 1 / 2 - (s / 2).re := by
      rw [Complex.sub_re, show ((1 : ℂ) / 2) = (((1 : ℝ) / 2 : ℝ) : ℂ) by norm_num,
        Complex.ofReal_re]
    have hge : 1 / 4 ≤ ((1 : ℂ) / 2 - s / 2).re := by
      rw [hre']
      linarith
    refine (hright _ hge).trans ?_
    apply hmas _ _ hge ?_ (norm_nonneg s)
    rw [hre']
    have h1 : -(s / 2).re ≤ |(s / 2).re| := neg_le_abs _
    have h2 : |(s / 2).re| ≤ ‖s‖ := (Complex.abs_re_le_norm _).trans hs2
    linarith

end GrowthBound

/-! ## A6 — the same growth bound for ξ -/

/-- **A6** — ξ obeys the same growth-bound shape as Λ₀: the polynomial
prefactor s(s−1) is absorbed into the exponential
(`completedZeta₀_growth`; `Real.exp_log`, `Real.exp_add`). -/
theorem xi_growth : ∃ C : ℝ, 0 < C ∧ ∀ s : ℂ,
    ‖xi s‖ ≤ C * Real.exp (C * (‖s‖ + 2) * Real.log (‖s‖ + 2)) := by
  obtain ⟨C, hC, hbound⟩ := completedZeta₀_growth
  refine ⟨C + 2, by linarith, fun s => ?_⟩
  set X : ℝ := ‖s‖ + 2 with hX
  have hX2 : (2 : ℝ) ≤ X := by
    rw [hX]
    linarith [norm_nonneg s]
  have hXnn : (0 : ℝ) ≤ X := by linarith
  have hlogX : 0 < Real.log X := Real.log_pos (by linarith)
  have h1 : ‖xi s‖ ≤ ‖s‖ * ‖s - 1‖ * ‖completedRiemannZeta₀ s‖ + 1 := by
    rw [xi]
    calc ‖s * (s - 1) * completedRiemannZeta₀ s + 1‖
        ≤ ‖s * (s - 1) * completedRiemannZeta₀ s‖ + ‖(1 : ℂ)‖ := norm_add_le _ _
      _ = ‖s‖ * ‖s - 1‖ * ‖completedRiemannZeta₀ s‖ + 1 := by
          rw [norm_mul, norm_mul, norm_one]
  have h2 : ‖s - 1‖ ≤ X := by
    calc ‖s - 1‖ ≤ ‖s‖ + ‖(1 : ℂ)‖ := norm_sub_le _ _
      _ = ‖s‖ + 1 := by rw [norm_one]
      _ ≤ X := by rw [hX]; linarith
  have h3 : ‖s‖ ≤ X := by rw [hX]; linarith
  have h4 : ‖s‖ * ‖s - 1‖ * ‖completedRiemannZeta₀ s‖
      ≤ X * X * (C * Real.exp (C * X * Real.log X)) := by
    apply mul_le_mul (mul_le_mul h3 h2 (norm_nonneg _) hXnn) (hbound s)
      (norm_nonneg _) (mul_nonneg hXnn hXnn)
  have h5 : X * X ≤ Real.exp (2 * X * Real.log X) := by
    have hXpos : (0 : ℝ) < X := by linarith
    have hxx : X * X = Real.exp (Real.log X + Real.log X) := by
      rw [Real.exp_add, Real.exp_log hXpos]
    rw [hxx]
    apply Real.exp_le_exp.mpr
    nlinarith [hlogX.le, hX2]
  have hexp_nonneg : 0 ≤ (C + 2) * X * Real.log X :=
    mul_nonneg (mul_nonneg (by linarith) hXnn) hlogX.le
  calc ‖xi s‖ ≤ ‖s‖ * ‖s - 1‖ * ‖completedRiemannZeta₀ s‖ + 1 := h1
    _ ≤ X * X * (C * Real.exp (C * X * Real.log X)) + 1 := by linarith [h4]
    _ ≤ Real.exp (2 * X * Real.log X) * (C * Real.exp (C * X * Real.log X)) + 1 := by
        have := mul_le_mul_of_nonneg_right h5
          (mul_nonneg hC.le (Real.exp_pos (C * X * Real.log X)).le)
        linarith
    _ = C * (Real.exp (2 * X * Real.log X) * Real.exp (C * X * Real.log X)) + 1 := by
        ring
    _ = C * Real.exp (2 * X * Real.log X + C * X * Real.log X) + 1 := by
        rw [← Real.exp_add]
    _ = C * Real.exp ((C + 2) * X * Real.log X) + 1 := by
        rw [show 2 * X * Real.log X + C * X * Real.log X
          = (C + 2) * X * Real.log X by ring]
    _ ≤ C * Real.exp ((C + 2) * X * Real.log X)
        + 1 * Real.exp ((C + 2) * X * Real.log X) := by
        have := Real.one_le_exp hexp_nonneg
        nlinarith
    _ = (C + 1) * Real.exp ((C + 2) * X * Real.log X) := by ring
    _ ≤ (C + 2) * Real.exp ((C + 2) * X * Real.log X) :=
        mul_le_mul_of_nonneg_right (by linarith) (Real.exp_pos _).le
