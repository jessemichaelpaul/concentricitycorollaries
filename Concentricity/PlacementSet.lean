/-
Concentricity/PlacementSet.lean

The set-level placement (OFFICIAL form of the open node, author's ruling
2026-07-04), the divisor bundle tying it to the frozen row, and Brick 1 of
the two-index plan — the log-derivative engine where an individual Euler
index p meets an individual Weierstrass index n for the first time
(PLAN_two_index_bricks.md §1–§3; SCAN_shapes_and_C5_ledger.md is the
session record).

All statements land sorried (R8; the balloon 1/0 → 7/0 is waived per the
HANDOFF trajectory). The frozen row `ASection.transportLevel_placement`
is NOT edited. Per-statement checks run at this landing (author ruling 4,
2026-07-04): (a) conclusion-check — every conclusion is the value-level
fact (a real-number equality, a stem-zero equation, an identity of complex
numbers), no stand-ins; (b) PLAN §6 admissibility — no statement names a
σ₀, a ½, or any absolute level; only differences/equalities of levels
appear.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.Theorem
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Meromorphic.TrailingCoefficient
import Mathlib.Analysis.SpecialFunctions.Log.Summable
import Mathlib.Analysis.Complex.LocallyUniformLimit
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.Calculus.LogDerivUniformlyOn
import Mathlib.Analysis.Normed.Module.MultipliableUniformlyOn
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv

noncomputable section

namespace ASection

/-! ## §1 — The set-level placement (OFFICIAL form of the open node) -/

/-- The placement, set-level (OFFICIAL form of the open node; author's
ruling 2026-07-04 — enumeration-free, "the zero set is F's alone"). Any two
upper-half-plane zeros of the stem share one real part. Master label:
`eq:placement-set` (the labeled OPEN node inside the proof of
`thm:concentricity`, landed d8f5b93). -/
theorem placement_set (A : ASection) :
    ∀ ⦃z w : ℂ⦄, A.F z = 0 → A.F w = 0 → 0 < z.im → 0 < w.im →
      z.re = w.re := by
  sorry

/-! ## §2 — The divisor bundle (set form ⟷ frozen row; both directions
need the §4 convergence upgrade) -/

/-- tprod vanishes at a vanishing factor — with bare `Multipliable` (R5:
absent from the pin; the nearest lemma, `tprod_eq_zero_mul`, is ℕ-index
factor-splitting, different content). Partial products over finsets
containing the vanishing index are zero; the unconditional limit is unique
(T2). In-repo per the §4α presentation: this half needs NO class upgrade. -/
theorem _root_.Multipliable.tprod_eq_zero_of_eq_zero {ι : Type*} {f : ι → ℂ}
    (hf : Multipliable f) {i : ι} (h : f i = 0) : ∏' j, f j = 0 := by
  have hp := hf.hasProd
  have hev : ∀ᶠ s : Finset ι in Filter.atTop, ∏ j ∈ s, f j = 0 := by
    filter_upwards [Filter.eventually_ge_atTop ({i} : Finset ι)] with s hs
    exact Finset.prod_eq_zero (hs (Finset.mem_singleton_self i)) h
  exact tendsto_nhds_unique hp
    (Filter.Tendsto.congr' (hev.mono fun s hs => hs.symm) tendsto_const_nhds)

/-- The sphere primary factor vanishes at its own zero: `E(1) = 0`. -/
theorem _root_.spherePrimary_self_eq_zero (p : ℕ) {a : ℂ} (ha : a ≠ 0) :
    spherePrimary p a a = 0 := by
  rw [spherePrimary, weierstrassE, div_self ha]
  simp

/-- Forward half of the divisor bundle: every enumerated sphere-zero is a
stem zero — CLOSED with bare fields (the vanishing-factor lemma above needs
no §4 upgrade), through the §8-repaired `c3_factorization`. -/
theorem stem_zero_of_sphereZero (A : ASection) (n : ℕ) :
    A.F (A.sphereZero n) = 0 := by
  have him : 0 < (A.sphereZero n).im := A.c3_sphere_nonreal n
  have hz0 : A.sphereZero n ≠ 0 := by
    intro h
    rw [h] at him
    simp at him
  have hzp : A.sphereZero n ≠ (A.pole : ℂ) := by
    intro h
    rw [h] at him
    simp [Complex.ofReal_im] at him
  have hfac := A.c3_factorization (A.sphereZero n) hzp
  have hprod : (∏' k, spherePrimary (A.genus k) (A.sphereZero k) (A.sphereZero n)) = 0 :=
    (A.c3_multipliable (A.sphereZero n)).tprod_eq_zero_of_eq_zero
      (i := n) (spherePrimary_self_eq_zero _ hz0)
  rw [hprod, mul_zero] at hfac
  rcases mul_eq_zero.mp hfac with h | h
  · exact absurd (sub_eq_zero.mp h) hzp
  · exact h

/-- The elementary factor vanishes exactly at `w = 1`: `E_p(w) =
(1 − w)·exp(…)` and the exponential never vanishes. PROVED helper (R8:
helpers are never sorried). -/
theorem _root_.weierstrassE_eq_zero_iff (p : ℕ) (w : ℂ) :
    weierstrassE p w = 0 ↔ w = 1 := by
  unfold weierstrassE
  constructor
  · intro h
    rcases mul_eq_zero.mp h with h1 | h1
    · exact (sub_eq_zero.mp h1).symm
    · exact absurd h1 (Complex.exp_ne_zero _)
  · intro h
    rw [h, sub_self, zero_mul]

/-- The sphere primary factor is nonzero away from its conjugate stem pair
`{a, conj a}`. PROVED helper. -/
theorem _root_.spherePrimary_ne_zero (p : ℕ) {a z : ℂ} (ha : a ≠ 0)
    (hz₁ : z ≠ a) (hz₂ : z ≠ starRingEnd ℂ a) : spherePrimary p a z ≠ 0 := by
  have hc : starRingEnd ℂ a ≠ 0 := by simpa using ha
  refine mul_ne_zero (fun h => hz₁ ?_) (fun h => hz₂ ?_)
  · exact (div_eq_one_iff_eq ha).mp ((weierstrassE_eq_zero_iff _ _).mp h)
  · exact (div_eq_one_iff_eq hc).mp ((weierstrassE_eq_zero_iff _ _).mp h)

/-- The §4α tprod-nonvanishing estimate, derived in-repo from
`c3_locMajorant`-shaped data: a product with a summable `‖· − 1‖`-majorant
and all factors nonzero is nonzero. Pin (R5, verified live):
`tprod_one_add_ne_zero_of_summable`
(Mathlib/Analysis/SpecialFunctions/Log/Summable.lean:216). PROVED helper. -/
theorem _root_.tprod_ne_zero_of_norm_sub_one_le {ι : Type*} {f : ι → ℂ}
    {u : ι → ℝ} (hu : Summable u) (hle : ∀ i, ‖f i - 1‖ ≤ u i)
    (hne : ∀ i, f i ≠ 0) : (∏' i, f i) ≠ 0 := by
  have hsum : Summable fun i => ‖f i - 1‖ :=
    Summable.of_nonneg_of_le (fun i => norm_nonneg _) hle hu
  have h1 : (fun i => 1 + (f i - 1)) = f := by
    funext i
    ring
  have h := tprod_one_add_ne_zero_of_summable (f := fun i => f i - 1)
    (fun i h => hne i (by linear_combination h)) hsum
  rwa [h1] at h

/-- Completeness half: every upper-half stem zero is enumerated. CLOSED
through the §8-repaired `c3_factorization`: a non-enumerated upper-half zero
would make the left side vanish while every right-side factor — `z^m` (z ≠ 0),
`R` (`c3_R_zeros_real`), `e^g`, and the tprod (each primary factor avoids its
conjugate pair; §4α majorant + `tprod_ne_zero_of_norm_sub_one_le`) — is
nonzero. -/
theorem sphereZero_complete (A : ASection) ⦃z : ℂ⦄
    (hz : A.F z = 0) (him : 0 < z.im) : ∃ n, A.sphereZero n = z := by
  by_contra hno
  have hno' : ∀ n, A.sphereZero n ≠ z := fun n h => hno ⟨n, h⟩
  have hzp : z ≠ (A.pole : ℂ) := by
    intro h
    rw [h] at him
    simp at him
  have hz0 : z ≠ 0 := by
    intro h
    rw [h] at him
    simp at him
  have hfac_ne : ∀ n, spherePrimary (A.genus n) (A.sphereZero n) z ≠ 0 := by
    intro n
    have himn := A.c3_sphere_nonreal n
    have ha0 : A.sphereZero n ≠ 0 := by
      intro h
      rw [h] at himn
      simp at himn
    refine spherePrimary_ne_zero _ ha0 (fun h => hno' n h.symm) fun h => ?_
    have hzim : z.im = -(A.sphereZero n).im := by
      rw [h, Complex.conj_im]
    linarith
  obtain ⟨r, hr, u, hu, hbound⟩ := A.c3_locMajorant z hzp
  have hprod_ne : (∏' n, spherePrimary (A.genus n) (A.sphereZero n) z) ≠ 0 :=
    tprod_ne_zero_of_norm_sub_one_le hu
      (fun n => hbound n z (Metric.mem_ball_self hr)) hfac_ne
  have hR : A.Rfac z ≠ 0 := fun h => ne_of_gt him (A.c3_R_zeros_real z h).1
  have hfac := A.c3_factorization z hzp
  rw [hz, mul_zero] at hfac
  exact mul_ne_zero (mul_ne_zero (mul_ne_zero (pow_ne_zero _ hz0) hR)
    (Complex.exp_ne_zero _)) hprod_ne hfac.symm

/-- The equivalence pin: set form ⟷ the frozen
`transportLevel_placement`. CLOSED: → is the set form read at the two
enumerated zeros (`stem_zero_of_sphereZero` + `c3_sphere_nonreal`;
`transportLevel` is definitionally `(A.sphereZero ·).re`, Theorem.lean); ←
enumerates both zeros by `sphereZero_complete` and reads off the level
equality. -/
theorem placement_set_iff (A : ASection) :
    (∀ ⦃z w : ℂ⦄, A.F z = 0 → A.F w = 0 → 0 < z.im → 0 < w.im → z.re = w.re)
      ↔ ∀ n m : ℕ, A.transportLevel n = A.transportLevel m := by
  constructor
  · intro h n m
    exact h (A.stem_zero_of_sphereZero n) (A.stem_zero_of_sphereZero m)
      (A.c3_sphere_nonreal n) (A.c3_sphere_nonreal m)
  · intro h z w hz hw hzim hwim
    obtain ⟨n, hn⟩ := A.sphereZero_complete hz hzim
    obtain ⟨m, hm⟩ := A.sphereZero_complete hw hwim
    rw [← hn, ← hm]
    exact h n m

/-! ## §3 — Brick 1: `stem_identity_logDeriv`, the two-index engine
(FE-free). Hypothesis shapes finalized against the arbiter per the
sanctioned pre-commit tightening; the Weierstrass side carries the pole
term from day one (§8 repair). -/

/-- Euler side, on the half-space: F′/F = ∑′ p, (ℓ p)′. CLOSED via the §4α
field `c2_locMajorant`: on a majorant ball inside the half-space the sum
differentiates term-by-term (Weierstrass convergence theorem; pins, R5
verified live: `Complex.hasSum_deriv_of_summable_norm`,
`Complex.differentiableOn_tsum_of_summable_norm`,
Mathlib/Analysis/Complex/LocallyUniformLimit.lean), and F = exp ∘ S near z
(`c2_euler`) chains through `HasDerivAt.cexp`. -/
theorem logDeriv_euler (A : ASection) :
    ∀ z : ℂ, A.Ω₀ < z.re →
      deriv A.F z / A.F z = ∑' p : A.ι, deriv (A.ℓ p) z := by
  intro z hz
  obtain ⟨r, hr, u, hu, hbound⟩ := A.c2_locMajorant z hz
  set ρ : ℝ := min r (z.re - A.Ω₀)
  have hρ : 0 < ρ := lt_min hr (sub_pos.mpr hz)
  -- the majorant ball lies inside the half-space
  have hUhalf : ∀ w ∈ Metric.ball z ρ, A.Ω₀ < w.re := by
    intro w hw
    have h1 : |(w - z).re| < ρ :=
      lt_of_le_of_lt (Complex.abs_re_le_norm _)
        (by rw [← dist_eq_norm]; exact Metric.mem_ball.mp hw)
    have h2 := (abs_lt.mp h1).1
    rw [Complex.sub_re] at h2
    have h3 : ρ ≤ z.re - A.Ω₀ := min_le_right _ _
    linarith
  have hUsubball : Metric.ball z ρ ⊆ Metric.ball z r :=
    Metric.ball_subset_ball (min_le_left _ _)
  have hdiff : ∀ p, DifferentiableOn ℂ (A.ℓ p) (Metric.ball z ρ) := fun p w hw =>
    ((A.c2_analyticAt p w (hUhalf w hw)).differentiableAt).differentiableWithinAt
  have hle : ∀ p, ∀ w : ℂ, w ∈ Metric.ball z ρ → ‖A.ℓ p w‖ ≤ u p :=
    fun p w hw => hbound p w (hUsubball hw)
  have hzU : z ∈ Metric.ball z ρ := Metric.mem_ball_self hρ
  -- term-by-term differentiation of the stem sum
  have hHasSum : HasSum (fun p => deriv (A.ℓ p) z)
      (deriv (fun w => ∑' p, A.ℓ p w) z) :=
    Complex.hasSum_deriv_of_summable_norm hu hdiff Metric.isOpen_ball hle hzU
  have hSdiff : DifferentiableAt ℂ (fun w => ∑' p, A.ℓ p w) z :=
    (Complex.differentiableOn_tsum_of_summable_norm hu hdiff Metric.isOpen_ball
      hle).differentiableAt (Metric.isOpen_ball.mem_nhds hzU)
  -- F = exp ∘ S on the open half-space, hence near z
  have hopen : IsOpen {w : ℂ | A.Ω₀ < w.re} :=
    isOpen_lt continuous_const Complex.continuous_re
  have hev : A.F =ᶠ[nhds z] fun w => Complex.exp (∑' p, A.ℓ p w) := by
    filter_upwards [hopen.mem_nhds hz] with w hw
    exact A.c2_euler w hw
  have hderivF : deriv A.F z
      = Complex.exp (∑' p, A.ℓ p z) * deriv (fun w => ∑' p, A.ℓ p w) z := by
    rw [hev.deriv_eq]
    exact (hSdiff.hasDerivAt.cexp).deriv
  rw [hderivF, A.c2_euler z hz,
    mul_div_cancel_left₀ _ (Complex.exp_ne_zero _)]
  exact hHasSum.tsum_eq.symm

/-- The elementary factor composed with `z ↦ z/a` is entire. PROVED
helper. -/
theorem _root_.differentiable_weierstrassE_div (p : ℕ) (a : ℂ) :
    Differentiable ℂ fun z => weierstrassE p (z / a) := by
  unfold weierstrassE
  fun_prop

/-- The sphere primary factor is entire. PROVED helper. -/
theorem _root_.differentiable_spherePrimary (p : ℕ) (a : ℂ) :
    Differentiable ℂ (spherePrimary p a) := by
  have h : spherePrimary p a
      = fun z => weierstrassE p (z / a) * weierstrassE p (z / starRingEnd ℂ a) :=
    rfl
  rw [h]
  exact (differentiable_weierstrassE_div p a).mul
    (differentiable_weierstrassE_div p (starRingEnd ℂ a))

/-- Weierstrass side, away from pole, origin, and zeros: F′/F unfolds over
individual n (each zero its own term) + m/z + R′/R + g′ − 1/(z − pole)
(the pole term from the §8 repair: (z − pole)·F equals the product, so F
inherits −1/(z − pole)). CLOSED via the §4α field `c3_locMajorant`: the
product converges locally normally on a ball around z avoiding the pole
(pins, R5 verified live: `Summable.multipliableLocallyUniformlyOn_nat_one_add`,
Mathlib/Analysis/Normed/Module/MultipliableUniformlyOn.lean;
`logDeriv_tprod_eq_tsum`, Mathlib/Analysis/Calculus/LogDerivUniformlyOn.lean),
the log-derivative summability comes from Cauchy estimates on the majorant
ball (`Complex.cderiv_eq_deriv` + `Complex.norm_cderiv_le`), and the finite
factors log-differentiate by `logDeriv_mul`/`logDeriv_pow`/
`Complex.logDeriv_exp` against the §8-repaired `c3_factorization`. -/
theorem logDeriv_weierstrass (A : ASection) :
    ∀ z : ℂ, z ≠ (A.pole : ℂ) → z ≠ 0 → A.F z ≠ 0 → A.Rfac z ≠ 0 →
      deriv A.F z / A.F z =
        -(1 / (z - (A.pole : ℂ))) + (A.m : ℂ) / z
          + deriv A.Rfac z / A.Rfac z + deriv A.gfac z
          + ∑' n, deriv (spherePrimary (A.genus n) (A.sphereZero n)) z /
              spherePrimary (A.genus n) (A.sphereZero n) z := by
  intro z hzp hz0 hF hR
  obtain ⟨r, hr, u, hu, hbound⟩ := A.c3_locMajorant z hzp
  -- the working ball: inside the majorant ball, avoiding the pole
  set ρ : ℝ := min r (dist z (A.pole : ℂ)) with hρdef
  have hρ : 0 < ρ := lt_min hr (dist_pos.mpr hzp)
  have hsub : Metric.ball z ρ ⊆ Metric.ball z r :=
    Metric.ball_subset_ball (min_le_left _ _)
  have hnopole : ∀ w ∈ Metric.ball z ρ, w ≠ (A.pole : ℂ) := by
    intro w hw h
    rw [h] at hw
    have h1 : dist (A.pole : ℂ) z < ρ := Metric.mem_ball.mp hw
    rw [dist_comm] at h1
    exact absurd h1 (not_lt.mpr (min_le_right _ _))
  have hzU : z ∈ Metric.ball z ρ := Metric.mem_ball_self hρ
  -- factor nonvanishing at z, read off the §8-repaired factorization
  have hval := A.c3_factorization z hzp
  have hLHS : (z - (A.pole : ℂ)) * A.F z ≠ 0 :=
    mul_ne_zero (sub_ne_zero.mpr hzp) hF
  have hPne : (∏' n, spherePrimary (A.genus n) (A.sphereZero n) z) ≠ 0 := by
    intro h0
    rw [h0, mul_zero] at hval
    exact hLHS hval
  have hfne : ∀ n, spherePrimary (A.genus n) (A.sphereZero n) z ≠ 0 :=
    fun n h0 => hPne ((A.c3_multipliable z).tprod_eq_zero_of_eq_zero h0)
  -- local normal convergence of the product on the ball (§4α)
  have htend : MultipliableLocallyUniformlyOn
      (fun n => spherePrimary (A.genus n) (A.sphereZero n)) (Metric.ball z ρ) := by
    have h1 : MultipliableLocallyUniformlyOn
        (fun n w => 1 + (spherePrimary (A.genus n) (A.sphereZero n) w - 1))
        (Metric.ball z ρ) :=
      Summable.multipliableLocallyUniformlyOn_nat_one_add Metric.isOpen_ball hu
        (Filter.Eventually.of_forall fun n w hw => hbound n w (hsub hw))
        (fun n => ((differentiable_spherePrimary _ _).sub_const 1).continuous.continuousOn)
    exact MultipliableLocallyUniformlyOn_congr (fun n w _ => by ring) h1
  have hd : ∀ n, DifferentiableOn ℂ (spherePrimary (A.genus n) (A.sphereZero n))
      (Metric.ball z ρ) := fun n => (differentiable_spherePrimary _ _).differentiableOn
  -- the tprod is differentiable at z (Weierstrass convergence theorem)
  have hPdiffOn : DifferentiableOn ℂ
      (fun w => ∏' n, spherePrimary (A.genus n) (A.sphereZero n) w)
      (Metric.ball z ρ) := by
    have h2 := hasProdLocallyUniformlyOn_iff_tendstoLocallyUniformlyOn.mp
      htend.hasProdLocallyUniformlyOn
    exact h2.differentiableOn
      (Filter.Eventually.of_forall fun t => (fun w _ =>
        (DifferentiableAt.fun_finsetProd fun i _ =>
          (differentiable_spherePrimary _ _).differentiableAt).differentiableWithinAt))
      Metric.isOpen_ball
  have hPdiffAt : DifferentiableAt ℂ
      (fun w => ∏' n, spherePrimary (A.genus n) (A.sphereZero n) w) z :=
    hPdiffOn.differentiableAt (Metric.isOpen_ball.mem_nhds hzU)
  -- summability of the log-derivatives at z: Cauchy estimates on the ball
  have hupos : ∀ n, 0 ≤ u n := fun n =>
    le_trans (norm_nonneg _) (hbound n z (Metric.mem_ball_self hr))
  have hδ : 0 < r / 2 := by positivity
  have hderiv_le : ∀ n,
      ‖deriv (spherePrimary (A.genus n) (A.sphereZero n)) z‖ ≤ u n / (r / 2) := by
    intro n
    have hcb : Metric.closedBall z (r / 2) ⊆ Metric.ball z r :=
      Metric.closedBall_subset_ball (by linarith)
    have hdOn : DifferentiableOn ℂ
        (fun w => spherePrimary (A.genus n) (A.sphereZero n) w - 1)
        (Metric.ball z r) :=
      ((differentiable_spherePrimary _ _).sub_const 1).differentiableOn
    have heq := Complex.cderiv_eq_deriv Metric.isOpen_ball hdOn hδ hcb
    have hsphere : ∀ w ∈ Metric.sphere z (r / 2),
        ‖spherePrimary (A.genus n) (A.sphereZero n) w - 1‖ ≤ u n :=
      fun w hw => hbound n w (hcb (Metric.sphere_subset_closedBall hw))
    have h0 := Complex.norm_cderiv_le hδ hsphere
    rw [heq, deriv_sub_const] at h0
    exact h0
  have hmsum : Summable
      (fun n => logDeriv (spherePrimary (A.genus n) (A.sphereZero n)) z) := by
    have hev : ∀ᶠ n in Filter.atTop, u n ≤ 1 / 2 := by
      have h := hu.tendsto_cofinite_zero.eventually_le_const one_half_pos
      rwa [Nat.cofinite_eq_atTop] at h
    refine Summable.of_norm_bounded_eventually_nat
      ((hu.div_const (r / 2)).mul_right 2) ?_
    filter_upwards [hev] with n hn
    have hfz : 1 / 2 ≤ ‖spherePrimary (A.genus n) (A.sphereZero n) z‖ := by
      have h1 := abs_norm_sub_norm_le
        (spherePrimary (A.genus n) (A.sphereZero n) z) 1
      rw [norm_one] at h1
      have h2 := hbound n z (Metric.mem_ball_self hr)
      have h3 := (abs_le.mp h1).1
      linarith
    rw [logDeriv_apply, norm_div]
    calc ‖deriv (spherePrimary (A.genus n) (A.sphereZero n)) z‖ /
          ‖spherePrimary (A.genus n) (A.sphereZero n) z‖
        ≤ (u n / (r / 2)) / (1 / 2) :=
          div_le_div₀ (div_nonneg (hupos n) hδ.le) (hderiv_le n) one_half_pos hfz
      _ = u n / (r / 2) * 2 := by ring
  -- the log-derivative of the tprod is the sum of the log-derivatives
  have hlogP : logDeriv
      (fun w => ∏' n, spherePrimary (A.genus n) (A.sphereZero n) w) z
      = ∑' n, logDeriv (spherePrimary (A.genus n) (A.sphereZero n)) z :=
    logDeriv_tprod_eq_tsum Metric.isOpen_ball hzU hfne hd hmsum htend hPne
  -- the two sides of the factorization agree near z
  have hGH : (fun w => (w - (A.pole : ℂ)) * A.F w) =ᶠ[nhds z]
      (fun w => w ^ A.m * A.Rfac w * Complex.exp (A.gfac w) *
        ∏' n, spherePrimary (A.genus n) (A.sphereZero n) w) := by
    filter_upwards [Metric.isOpen_ball.mem_nhds hzU] with w hw
    exact A.c3_factorization w (hnopole w hw)
  have hkey : logDeriv (fun w => (w - (A.pole : ℂ)) * A.F w) z
      = logDeriv (fun w => w ^ A.m * A.Rfac w * Complex.exp (A.gfac w) *
          ∏' n, spherePrimary (A.genus n) (A.sphereZero n) w) z := by
    simp only [logDeriv_apply]
    rw [hGH.deriv_eq, hGH.eq_of_nhds]
  -- differentiability of the finite factors at z
  have hFd : DifferentiableAt ℂ A.F z := (A.c1_analyticAt z hzp).differentiableAt
  have hsubd : DifferentiableAt ℂ (fun w : ℂ => w - (A.pole : ℂ)) z := by fun_prop
  have hpowd : DifferentiableAt ℂ (fun w : ℂ => w ^ A.m) z := by fun_prop
  have hRd : DifferentiableAt ℂ A.Rfac z := A.c3_R_entire.differentiableAt
  have hgd : DifferentiableAt ℂ A.gfac z := A.c3_g_entire.differentiableAt
  have hexpd : DifferentiableAt ℂ (fun w => Complex.exp (A.gfac w)) z := hgd.cexp
  have hexp_ne : Complex.exp (A.gfac z) ≠ 0 := Complex.exp_ne_zero _
  have hpow_ne : z ^ A.m ≠ 0 := pow_ne_zero _ hz0
  -- expand the left side
  have hsub1 : logDeriv (fun w : ℂ => w - (A.pole : ℂ)) z
      = 1 / (z - (A.pole : ℂ)) := by
    rw [logDeriv_apply, deriv_sub_const]
    simp [deriv_id'']
  have hL : logDeriv (fun w => (w - (A.pole : ℂ)) * A.F w) z
      = 1 / (z - (A.pole : ℂ)) + logDeriv A.F z := by
    rw [logDeriv_mul (f := fun w : ℂ => w - (A.pole : ℂ)) (g := A.F) z
      (sub_ne_zero.mpr hzp) hF hsubd hFd, hsub1]
  -- expand the right side
  have hR1 : logDeriv (fun w => w ^ A.m * A.Rfac w * Complex.exp (A.gfac w) *
        ∏' n, spherePrimary (A.genus n) (A.sphereZero n) w) z
      = logDeriv (fun w => w ^ A.m * A.Rfac w * Complex.exp (A.gfac w)) z
        + logDeriv (fun w => ∏' n, spherePrimary (A.genus n) (A.sphereZero n) w) z :=
    logDeriv_mul (f := fun w => w ^ A.m * A.Rfac w * Complex.exp (A.gfac w))
      (g := fun w => ∏' n, spherePrimary (A.genus n) (A.sphereZero n) w) z
      (mul_ne_zero (mul_ne_zero hpow_ne hR) hexp_ne) hPne
      ((hpowd.mul hRd).mul hexpd) hPdiffAt
  have hR2 : logDeriv (fun w => w ^ A.m * A.Rfac w * Complex.exp (A.gfac w)) z
      = logDeriv (fun w => w ^ A.m * A.Rfac w) z
        + logDeriv (fun w => Complex.exp (A.gfac w)) z :=
    logDeriv_mul (f := fun w => w ^ A.m * A.Rfac w)
      (g := fun w => Complex.exp (A.gfac w)) z
      (mul_ne_zero hpow_ne hR) hexp_ne (hpowd.mul hRd) hexpd
  have hR3 : logDeriv (fun w => w ^ A.m * A.Rfac w) z
      = logDeriv (fun w : ℂ => w ^ A.m) z + logDeriv A.Rfac z :=
    logDeriv_mul (f := fun w : ℂ => w ^ A.m) (g := A.Rfac) z hpow_ne hR hpowd hRd
  have hR4 : logDeriv (fun w : ℂ => w ^ A.m) z = (A.m : ℂ) / z := logDeriv_pow z A.m
  have hR5 : logDeriv (fun w => Complex.exp (A.gfac w)) z = deriv A.gfac z := by
    have h := logDeriv_comp (f := Complex.exp) (g := A.gfac) (x := z)
      Complex.differentiable_exp.differentiableAt hgd
    rw [Complex.logDeriv_exp] at h
    simpa [Function.comp_def] using h
  -- assemble
  have main : 1 / (z - (A.pole : ℂ)) + logDeriv A.F z
      = (A.m : ℂ) / z + logDeriv A.Rfac z + deriv A.gfac z
        + ∑' n, logDeriv (spherePrimary (A.genus n) (A.sphereZero n)) z := by
    have h := hkey
    rw [hL, hR1, hR2, hR3, hR4, hR5, hlogP] at h
    linear_combination h
  have htsum_eq : (∑' n, deriv (spherePrimary (A.genus n) (A.sphereZero n)) z /
        spherePrimary (A.genus n) (A.sphereZero n) z)
      = ∑' n, logDeriv (spherePrimary (A.genus n) (A.sphereZero n)) z :=
    tsum_congr fun n => (logDeriv_apply _ _).symm
  rw [← logDeriv_apply A.F z, ← logDeriv_apply A.Rfac z, htsum_eq]
  linear_combination main

/-- **B2.0 — the inverse-coordinate bridge** (confirmed 2026-07-04): the
exact identity ‖ρ‖²·Re(1/ρ) = Re ρ — the ‖ρ‖²-form pinned, never
τ²-normalized (PLAN §6 correction). PROVED. -/
theorem _root_.inv_re_bridge {ρ : ℂ} (hρ : ρ ≠ 0) :
    ‖ρ‖ ^ 2 * (1 / ρ).re = ρ.re := by
  have hN : Complex.normSq ρ ≠ 0 := (Complex.normSq_pos.mpr hρ).ne'
  rw [one_div, Complex.inv_re, ← Complex.normSq_eq_norm_sq]
  field_simp

/-- **B2.0 — the official node in inverse-zero coordinates** (confirmed
2026-07-04): placement ⟷ the ‖ρ‖²·Re(1/ρ) values agree across the zero set —
the variable in which explicit-formula ledgers speak. Equalities across
zeros only; no absolute level (PLAN §6 admissibility). PROVED via the
bridge. -/
theorem placement_set_iff_inv_re (A : ASection) :
    (∀ ⦃z w : ℂ⦄, A.F z = 0 → A.F w = 0 → 0 < z.im → 0 < w.im → z.re = w.re)
      ↔ ∀ ⦃z w : ℂ⦄, A.F z = 0 → A.F w = 0 → 0 < z.im → 0 < w.im →
          ‖z‖ ^ 2 * (1 / z).re = ‖w‖ ^ 2 * (1 / w).re := by
  have hnz : ∀ {z : ℂ}, 0 < z.im → z ≠ 0 := by
    intro z hz h
    rw [h] at hz
    simp at hz
  constructor
  · intro H z w hz hw hzi hwi
    rw [inv_re_bridge (hnz hzi), inv_re_bridge (hnz hwi)]
    exact H hz hw hzi hwi
  · intro H z w hz hw hzi hwi
    have h := H hz hw hzi hwi
    rwa [inv_re_bridge (hnz hzi), inv_re_bridge (hnz hwi)] at h

/-- **The two-index ledger's seed** (PLAN §3: `stem_identity_logDeriv` — the
two log-derivative expansions of the one stem, equated on the overlap; the
continuation beyond the overlap is Brick-2 machinery). An individual Euler
index p and an individual Weierstrass index n meet in one identity, FE-free.
PROVED from Brick 1 (both rows closed on green). Conclusion is a value-level
identity; no σ₀, no ½ (PLAN §6 admissibility). -/
theorem stem_identity_logDeriv (A : ASection) :
    ∀ z : ℂ, A.Ω₀ < z.re → z ≠ (A.pole : ℂ) → z ≠ 0 → A.F z ≠ 0 →
      A.Rfac z ≠ 0 →
      ∑' p : A.ι, deriv (A.ℓ p) z =
        -(1 / (z - (A.pole : ℂ))) + (A.m : ℂ) / z
          + deriv A.Rfac z / A.Rfac z + deriv A.gfac z
          + ∑' n, deriv (spherePrimary (A.genus n) (A.sphereZero n)) z /
              spherePrimary (A.genus n) (A.sphereZero n) z := by
  intro z hΩ hp h0 hF hR
  rw [← A.logDeriv_euler z hΩ, A.logDeriv_weierstrass z hp h0 hF hR]

/-! ## B2.1 — the residue ledger (confirmed 2026-07-04; STRICTLY per-zero —
any summed residue statement is already a pairing and waits with B2.2) -/

/-- B2.1: the log-derivative of the stem is meromorphic on all of ℂ — the
Euler side's continuation IS the Weierstrass side, as one meromorphic
object. PROVED (Mathlib meromorphic calculus). -/
theorem ledger_meromorphic (A : ASection) :
    MeromorphicOn (fun z => deriv A.F z / A.F z) Set.univ :=
  fun z hz => ((A.meromorphic z hz).deriv).div (A.meromorphic z hz)

/-- B2.1 helper: any zero value is enumerated with finite multiplicity —
from `c3_locMajorant` (factors → 1 forces finite repetition at any point).
CLOSED: an infinite fiber would pin the majorant at `u k ≥ 1` infinitely
often (`spherePrimary_self_eq_zero` evaluated at the zero itself), against
`Summable u`. -/
theorem sphereZero_fiber_finite (A : ASection) (n : ℕ) :
    {k : ℕ | A.sphereZero k = A.sphereZero n}.Finite := by
  by_contra hinf
  have hS : {k : ℕ | A.sphereZero k = A.sphereZero n}.Infinite := hinf
  have hzp : A.sphereZero n ≠ (A.pole : ℂ) := by
    intro h
    have him := A.c3_sphere_nonreal n
    rw [h] at him
    simp at him
  obtain ⟨r, hr, u, hu, hbound⟩ := A.c3_locMajorant (A.sphereZero n) hzp
  -- every fiber index k forces 1 ≤ u k: the k-th factor vanishes at the zero
  have hone : ∀ k ∈ {k : ℕ | A.sphereZero k = A.sphereZero n}, (1 : ℝ) ≤ u k := by
    intro k hk
    have hk' : A.sphereZero k = A.sphereZero n := hk
    have ha0 : A.sphereZero k ≠ 0 := by
      intro h
      have him := A.c3_sphere_nonreal k
      rw [h] at him
      simp at him
    have h0 : spherePrimary (A.genus k) (A.sphereZero k) (A.sphereZero n) = 0 := by
      rw [← hk']
      exact spherePrimary_self_eq_zero _ ha0
    have hb := hbound k (A.sphereZero n) (Metric.mem_ball_self hr)
    rw [h0] at hb
    simpa using hb
  -- but the summable majorant is eventually below 1
  have hev : ∀ᶠ k in Filter.atTop, u k ≤ 1 / 2 := by
    have h := hu.tendsto_cofinite_zero.eventually_le_const one_half_pos
    rwa [Nat.cofinite_eq_atTop] at h
  obtain ⟨M, hM⟩ := Filter.eventually_atTop.mp hev
  obtain ⟨k, hkS, hkM⟩ := hS.exists_gt M
  have h1 := hone k hkS
  have h2 := hM k hkM.le
  linarith

/-- The zero-slot elementary factor peels its zero explicitly:
`E_p(z/a) = (z − a) · (−a⁻¹ · exp(…))`. PROVED helper (R8: helpers are
never sorried). -/
theorem _root_.weierstrassE_div_factor (p : ℕ) {a : ℂ} (ha : a ≠ 0) (z : ℂ) :
    weierstrassE p (z / a) = (z - a) *
      (-a⁻¹ * Complex.exp (∑ k ∈ Finset.range p, (z / a) ^ (k + 1) / (k + 1))) := by
  rw [weierstrassE]
  have h : 1 - z / a = (z - a) * -a⁻¹ := by
    have h1 : (z - a) * -a⁻¹ = -(z * a⁻¹) + a * a⁻¹ := by ring
    rw [h1, mul_inv_cancel₀ ha, div_eq_mul_inv]
    ring
  rw [h, mul_assoc]

/-- The entire unit accompanying `(z − a)` in a fiber factor of the
Weierstrass product (`stem_local_form` scaffolding). -/
def _root_.sphereUnit (p : ℕ) (a z : ℂ) : ℂ :=
  -a⁻¹ * Complex.exp (∑ k ∈ Finset.range p, (z / a) ^ (k + 1) / (k + 1)) *
    weierstrassE p (z / starRingEnd ℂ a)

/-- Fiber-factor peeling: the primary factor of a fiber member is `(z − a)`
times the unit. PROVED helper. -/
theorem _root_.spherePrimary_eq_sub_mul_sphereUnit (p : ℕ) {a : ℂ} (ha : a ≠ 0)
    (z : ℂ) : spherePrimary p a z = (z - a) * sphereUnit p a z := by
  rw [spherePrimary, sphereUnit, weierstrassE_div_factor p ha z]
  ring

/-- The unit is entire. PROVED helper. -/
theorem _root_.differentiable_sphereUnit (p : ℕ) (a : ℂ) :
    Differentiable ℂ (sphereUnit p a) := by
  have h1 : Differentiable ℂ fun z : ℂ =>
      -a⁻¹ * Complex.exp (∑ k ∈ Finset.range p, (z / a) ^ (k + 1) / (k + 1)) := by
    fun_prop
  exact h1.mul (differentiable_weierstrassE_div p (starRingEnd ℂ a))

/-- The unit avoids zero away from the conjugate point. PROVED helper. -/
theorem _root_.sphereUnit_ne_zero (p : ℕ) {a z : ℂ} (ha : a ≠ 0)
    (hz : z ≠ starRingEnd ℂ a) : sphereUnit p a z ≠ 0 := by
  have hc : starRingEnd ℂ a ≠ 0 := by simpa using ha
  rw [sphereUnit]
  exact mul_ne_zero (mul_ne_zero (neg_ne_zero.mpr (inv_ne_zero ha))
    (Complex.exp_ne_zero _))
    fun h => hz ((div_eq_one_iff_eq hc).mp ((weierstrassE_eq_zero_iff _ _).mp h))

/-- CORE of the B2.1 per-zero rows — the stem's local form at an enumerated
zero: near `a := A.sphereZero n` the stem factors as `(z − a)^N · G` with
`G` analytic and nonvanishing at `a` and `N` the fiber tally. Route: the
§8-repaired `c3_factorization`; the tprod split at the finite fiber
(`sphereZero_fiber_finite` + `Multipliable.prod_mul_tprod_compl`); the
explicit unit peeling on each fiber factor; the §4α scaffolding
(`Summable.multipliableLocallyUniformlyOn_nat_one_add` + Weierstrass
convergence) for the analytic, nonvanishing tail. PROVED helper. -/
theorem stem_local_form (A : ASection) (n : ℕ) :
    ∃ G : ℂ → ℂ, AnalyticAt ℂ G (A.sphereZero n) ∧ G (A.sphereZero n) ≠ 0 ∧
      A.F =ᶠ[nhds (A.sphereZero n)] fun z =>
        (z - A.sphereZero n) ^ Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n} *
          G z := by
  have him : 0 < (A.sphereZero n).im := A.c3_sphere_nonreal n
  have ha0 : A.sphereZero n ≠ 0 := by
    intro h; rw [h] at him; simp at him
  have hap : A.sphereZero n ≠ (A.pole : ℂ) := by
    intro h; rw [h] at him; simp at him
  have hconj : A.sphereZero n ≠ starRingEnd ℂ (A.sphereZero n) := by
    intro h
    have h2 := congrArg Complex.im h
    rw [Complex.conj_im] at h2
    linarith
  -- the finite fiber and its tally
  have hSfin := A.sphereZero_fiber_finite n
  set s : Finset ℕ := hSfin.toFinset with hs_def
  have hcard : Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n} = s.card := by
    rw [hs_def, Nat.card_coe_set_eq, Set.ncard_eq_toFinset_card _ hSfin]
  -- the §4α majorant ball at the zero
  obtain ⟨r, hr, u, hu, hbound⟩ := A.c3_locMajorant (A.sphereZero n) hap
  have hupos : ∀ k, 0 ≤ u k := fun k =>
    le_trans (norm_nonneg _) (hbound k (A.sphereZero n) (Metric.mem_ball_self hr))
  set ρ : ℝ := min r (dist (A.sphereZero n) (A.pole : ℂ)) with hρ_def
  have hρ : 0 < ρ := lt_min hr (dist_pos.mpr hap)
  have hsub : Metric.ball (A.sphereZero n) ρ ⊆ Metric.ball (A.sphereZero n) r :=
    Metric.ball_subset_ball (min_le_left _ _)
  have hnopole : ∀ w ∈ Metric.ball (A.sphereZero n) ρ, w ≠ (A.pole : ℂ) := by
    intro w hw h
    rw [h] at hw
    have h1 : dist (A.pole : ℂ) (A.sphereZero n) < ρ := Metric.mem_ball.mp hw
    rw [dist_comm] at h1
    exact absurd h1 (not_lt.mpr (min_le_right _ _))
  have hzball : A.sphereZero n ∈ Metric.ball (A.sphereZero n) ρ := Metric.mem_ball_self hρ
  -- the tail (fiber factors replaced by 1): differentiable on the majorant ball
  have hitem : ∀ k : ℕ, Differentiable ℂ fun w =>
      (if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) w) := by
    intro k
    by_cases hk : k ∈ s
    · simp only [if_pos hk]
      exact differentiable_const 1
    · simp only [if_neg hk]
      exact differentiable_spherePrimary _ _
  have hTdiff : DifferentiableOn ℂ
      (fun w => ∏' k, if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) w)
      (Metric.ball (A.sphereZero n) r) := by
    have htend : MultipliableLocallyUniformlyOn
        (fun k w => if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) w)
        (Metric.ball (A.sphereZero n) r) := by
      have h1 : MultipliableLocallyUniformlyOn
          (fun k w => 1 + ((if k ∈ s then (1 : ℂ) else
            spherePrimary (A.genus k) (A.sphereZero k) w) - 1))
          (Metric.ball (A.sphereZero n) r) :=
        Summable.multipliableLocallyUniformlyOn_nat_one_add Metric.isOpen_ball hu
          (Filter.Eventually.of_forall fun k w hw => by
            by_cases hk : k ∈ s
            · simpa [if_pos hk] using hupos k
            · rw [if_neg hk]
              exact hbound k w hw)
          (fun k => ((hitem k).sub_const 1).continuous.continuousOn)
      exact MultipliableLocallyUniformlyOn_congr (fun k w _ => by ring) h1
    have h2 := hasProdLocallyUniformlyOn_iff_tendstoLocallyUniformlyOn.mp
      htend.hasProdLocallyUniformlyOn
    exact h2.differentiableOn
      (Filter.Eventually.of_forall fun t => fun w _ =>
        (DifferentiableAt.fun_finsetProd fun i _ =>
          (hitem i).differentiableAt).differentiableWithinAt)
      Metric.isOpen_ball
  -- the tail is nonzero at the zero itself
  have hTa : (∏' k, if k ∈ s then (1 : ℂ) else
      spherePrimary (A.genus k) (A.sphereZero k) (A.sphereZero n)) ≠ 0 := by
    refine tprod_ne_zero_of_norm_sub_one_le hu (fun k => ?_) (fun k => ?_)
    · by_cases hk : k ∈ s
      · simpa [if_pos hk] using hupos k
      · rw [if_neg hk]
        exact hbound k (A.sphereZero n) (Metric.mem_ball_self hr)
    · by_cases hk : k ∈ s
      · rw [if_pos hk]; exact one_ne_zero
      · rw [if_neg hk]
        have himk := A.c3_sphere_nonreal k
        have hak : A.sphereZero k ≠ 0 := by
          intro h; rw [h] at himk; simp at himk
        have hne1 : A.sphereZero n ≠ A.sphereZero k := by
          intro h
          exact hk (hSfin.mem_toFinset.mpr h.symm)
        have hne2 : A.sphereZero n ≠ starRingEnd ℂ (A.sphereZero k) := by
          intro h
          have h2 : (A.sphereZero n).im = -(A.sphereZero k).im := by
            rw [h, Complex.conj_im]
          linarith
        exact spherePrimary_ne_zero _ hak hne1 hne2
  -- the tprod splits at the fiber, on the majorant ball (monoid-level route:
  -- head = finitely-supported HasProd, tail = §4α summable majorant →
  -- `multipliable_one_add_of_summable`, glued by `Multipliable.tprod_mul`)
  have hsplit : ∀ w ∈ Metric.ball (A.sphereZero n) r,
      (∏' k, spherePrimary (A.genus k) (A.sphereZero k) w)
      = (∏ k ∈ s, spherePrimary (A.genus k) (A.sphereZero k) w) *
        ∏' k, (if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) w) := by
    intro w hw
    have hhead : HasProd
        (fun k => if k ∈ s then spherePrimary (A.genus k) (A.sphereZero k) w else 1)
        (∏ k ∈ s, if k ∈ s then spherePrimary (A.genus k) (A.sphereZero k) w else 1) :=
      hasProd_prod_of_ne_finset_one fun b hb => if_neg hb
    have htail_sum : Summable fun k =>
        ‖(if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) w) - 1‖ := by
      refine Summable.of_nonneg_of_le (fun k => norm_nonneg _) (fun k => ?_) hu
      by_cases hk : k ∈ s
      · simpa [if_pos hk] using hupos k
      · rw [if_neg hk]
        exact hbound k w hw
    have htail : Multipliable fun k =>
        (if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) w) := by
      have h1 := multipliable_one_add_of_summable (f := fun k =>
        (if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) w) - 1)
        htail_sum
      have h2 : (fun k => 1 + ((if k ∈ s then (1 : ℂ) else
          spherePrimary (A.genus k) (A.sphereZero k) w) - 1))
          = fun k => (if k ∈ s then (1 : ℂ) else
            spherePrimary (A.genus k) (A.sphereZero k) w) := by
        funext k
        ring
      rwa [h2] at h1
    calc (∏' k, spherePrimary (A.genus k) (A.sphereZero k) w)
        = ∏' k, ((if k ∈ s then spherePrimary (A.genus k) (A.sphereZero k) w else 1) *
            (if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) w)) :=
          tprod_congr fun k => by by_cases hk : k ∈ s <;> simp [hk]
      _ = (∏' k, if k ∈ s then spherePrimary (A.genus k) (A.sphereZero k) w else 1) *
            ∏' k, (if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) w) :=
          Multipliable.tprod_mul hhead.multipliable htail
      _ = (∏ k ∈ s, spherePrimary (A.genus k) (A.sphereZero k) w) *
            ∏' k, (if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) w) := by
          rw [hhead.tprod_eq]
          congr 1
          exact Finset.prod_congr rfl fun k hk => if_pos hk
  -- the fiber product peels its zeros
  have hfib : ∀ z : ℂ, (∏ k ∈ s, spherePrimary (A.genus k) (A.sphereZero k) z)
      = (z - A.sphereZero n) ^ s.card *
        ∏ k ∈ s, sphereUnit (A.genus k) (A.sphereZero n) z := by
    intro z
    calc (∏ k ∈ s, spherePrimary (A.genus k) (A.sphereZero k) z)
        = ∏ k ∈ s, ((z - A.sphereZero n) * sphereUnit (A.genus k) (A.sphereZero n) z) :=
          Finset.prod_congr rfl fun k hk => by
            rw [show A.sphereZero k = A.sphereZero n from hSfin.mem_toFinset.mp hk]
            exact spherePrimary_eq_sub_mul_sphereUnit _ ha0 z
      _ = (∏ _k ∈ s, (z - A.sphereZero n)) *
            ∏ k ∈ s, sphereUnit (A.genus k) (A.sphereZero n) z :=
          Finset.prod_mul_distrib
      _ = (z - A.sphereZero n) ^ s.card *
            ∏ k ∈ s, sphereUnit (A.genus k) (A.sphereZero n) z := by
          rw [Finset.prod_const]
  -- assemble G
  refine ⟨fun z => z ^ A.m * A.Rfac z * Complex.exp (A.gfac z) *
      (∏ k ∈ s, sphereUnit (A.genus k) (A.sphereZero n) z) *
      (∏' k, if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) z) /
      (z - (A.pole : ℂ)), ?_, ?_, ?_⟩
  · -- analytic at the zero: differentiable on the pole-free ball
    have hGdiff : DifferentiableOn ℂ (fun z => z ^ A.m * A.Rfac z * Complex.exp (A.gfac z) *
        (∏ k ∈ s, sphereUnit (A.genus k) (A.sphereZero n) z) *
        (∏' k, if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) z) /
        (z - (A.pole : ℂ))) (Metric.ball (A.sphereZero n) ρ) := by
      intro w hw
      have hT_at : DifferentiableAt ℂ (fun z => ∏' k, if k ∈ s then (1 : ℂ) else
          spherePrimary (A.genus k) (A.sphereZero k) z) w :=
        (hTdiff.mono hsub).differentiableAt (Metric.isOpen_ball.mem_nhds hw)
      have hpow : DifferentiableAt ℂ (fun z : ℂ => z ^ A.m) w := by fun_prop
      have hQ : DifferentiableAt ℂ
          (fun z => ∏ k ∈ s, sphereUnit (A.genus k) (A.sphereZero n) z) w :=
        DifferentiableAt.fun_finsetProd fun i _ =>
          (differentiable_sphereUnit _ _).differentiableAt
      have hden : DifferentiableAt ℂ (fun z : ℂ => z - (A.pole : ℂ)) w := by fun_prop
      exact (((((hpow.mul A.c3_R_entire.differentiableAt).mul
        A.c3_g_entire.differentiableAt.cexp).mul hQ).mul hT_at).div hden
        (sub_ne_zero.mpr (hnopole w hw))).differentiableWithinAt
    exact hGdiff.analyticAt (Metric.isOpen_ball.mem_nhds hzball)
  · -- nonvanishing at the zero
    have hpow_ne : (A.sphereZero n) ^ A.m ≠ 0 := pow_ne_zero _ ha0
    have hR_ne : A.Rfac (A.sphereZero n) ≠ 0 :=
      fun h => ne_of_gt him (A.c3_R_zeros_real _ h).1
    have hQ_ne : (∏ k ∈ s, sphereUnit (A.genus k) (A.sphereZero n) (A.sphereZero n)) ≠ 0 :=
      Finset.prod_ne_zero_iff.mpr fun k _ => sphereUnit_ne_zero _ ha0 hconj
    exact div_ne_zero (mul_ne_zero (mul_ne_zero (mul_ne_zero (mul_ne_zero hpow_ne hR_ne)
      (Complex.exp_ne_zero _)) hQ_ne) hTa) (sub_ne_zero.mpr hap)
  · -- the local factorization, on the pole-free ball
    filter_upwards [Metric.isOpen_ball.mem_nhds hzball] with w hw
    have hwp : w ≠ (A.pole : ℂ) := hnopole w hw
    have hfacw := A.c3_factorization w hwp
    rw [hsplit w (hsub hw), hfib w] at hfacw
    have hdne : w - (A.pole : ℂ) ≠ 0 := sub_ne_zero.mpr hwp
    show A.F w = (w - A.sphereZero n) ^ Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n} *
      (w ^ A.m * A.Rfac w * Complex.exp (A.gfac w) *
        (∏ k ∈ s, sphereUnit (A.genus k) (A.sphereZero n) w) *
        (∏' k, if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) w) /
        (w - (A.pole : ℂ)))
    rw [hcard, ← mul_div_assoc, eq_div_iff hdne]
    linear_combination hfacw

/-- CORE presentation for the two remaining B2.1 rows: near an enumerated
zero the continued log-derivative is `(z − a)⁻¹ · u` with `u` analytic at
`a` and `u a = N`, the fiber tally — the simple pole and its trailing
coefficient in one package, shaped for `meromorphicOrderAt_eq_int_iff` and
`AnalyticAt.meromorphicTrailingCoeffAt_of_ne_zero_of_eq_nhdsNE`. PROVED
helper. -/
theorem logDeriv_local_form (A : ASection) (n : ℕ) :
    ∃ u : ℂ → ℂ, AnalyticAt ℂ u (A.sphereZero n) ∧
      u (A.sphereZero n) = (Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n} : ℂ) ∧
      u (A.sphereZero n) ≠ 0 ∧
      (fun z => deriv A.F z / A.F z)
        =ᶠ[nhdsWithin (A.sphereZero n) {A.sphereZero n}ᶜ]
          fun z => (z - A.sphereZero n) ^ (-1 : ℤ) • u z := by
  obtain ⟨G, hGa, hGne, hev⟩ := A.stem_local_form n
  set N := Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n} with hN_def
  have hNpos : 0 < N := by
    haveI : Nonempty {k : ℕ | A.sphereZero k = A.sphereZero n} := ⟨⟨n, rfl⟩⟩
    haveI : Finite {k : ℕ | A.sphereZero k = A.sphereZero n} :=
      (A.sphereZero_fiber_finite n).to_subtype
    exact Nat.card_pos
  have hval : ((N : ℂ) * G (A.sphereZero n) +
      (A.sphereZero n - A.sphereZero n) * deriv G (A.sphereZero n)) / G (A.sphereZero n)
      = (N : ℂ) := by
    simp only [sub_self, zero_mul, add_zero, mul_div_assoc, div_self hGne, mul_one]
  refine ⟨fun z => ((N : ℂ) * G z + (z - A.sphereZero n) * deriv G z) / G z,
    ?_, ?_, ?_, ?_⟩
  · exact ((analyticAt_const.mul hGa).add
      ((analyticAt_id.sub analyticAt_const).mul hGa.deriv)).div hGa hGne
  · exact hval
  · exact ne_of_eq_of_ne hval (Nat.cast_ne_zero.mpr hNpos.ne')
  · have hev2 : ∀ᶠ z in nhds (A.sphereZero n), A.F =ᶠ[nhds z]
        fun w => (w - A.sphereZero n) ^ N * G w :=
      Filter.Eventually.eventually_nhds hev
    have hGan : ∀ᶠ z in nhds (A.sphereZero n), AnalyticAt ℂ G z :=
      hGa.eventually_analyticAt
    have hGne2 : ∀ᶠ z in nhds (A.sphereZero n), G z ≠ 0 :=
      hGa.continuousAt.eventually_ne hGne
    filter_upwards [self_mem_nhdsWithin,
      eventually_nhdsWithin_of_eventually_nhds hev2,
      eventually_nhdsWithin_of_eventually_nhds hGan,
      eventually_nhdsWithin_of_eventually_nhds hGne2] with z hzmem hFz hGz hGnz
    have hzne : z ≠ A.sphereZero n := hzmem
    have hzsub : z - A.sphereZero n ≠ 0 := sub_ne_zero.mpr hzne
    have hd1 : HasDerivAt (fun w => (w - A.sphereZero n) ^ N * G w)
        ((N : ℂ) * (z - A.sphereZero n) ^ (N - 1) * 1 * G z +
          (z - A.sphereZero n) ^ N * deriv G z) z :=
      (((hasDerivAt_id z).sub_const (A.sphereZero n)).pow N).mul
        hGz.differentiableAt.hasDerivAt
    have hderivF : deriv A.F z
        = (N : ℂ) * (z - A.sphereZero n) ^ (N - 1) * 1 * G z +
          (z - A.sphereZero n) ^ N * deriv G z := by
      rw [hFz.deriv_eq]
      exact hd1.deriv
    have hFval : A.F z = (z - A.sphereZero n) ^ N * G z := hFz.eq_of_nhds
    obtain ⟨M, hM⟩ := Nat.exists_eq_succ_of_ne_zero hNpos.ne'
    rw [hderivF, hFval, hM]
    rw [zpow_neg_one, smul_eq_mul]
    simp only [Nat.add_sub_cancel, mul_one, pow_succ]
    push_cast
    field_simp

/-- B2.1 per-zero order: the continued log-derivative has a simple pole at
each enumerated zero (order −1 regardless of multiplicity). Residue-API
caveat as confirmed: the pin has no residue function; rendered via
`meromorphicOrderAt` + trailing coefficient. CLOSED: the
`logDeriv_local_form` presentation `(z − a)⁻¹ · u`, `u a = N ≠ 0`, read
through the pin's `meromorphicOrderAt_eq_int_iff`. -/
theorem ledger_orderAt_zero (A : ASection) (n : ℕ) :
    meromorphicOrderAt (fun z => deriv A.F z / A.F z) (A.sphereZero n)
      = ((-1 : ℤ) : WithTop ℤ) := by
  obtain ⟨u, hu_an, hu_val, hu_ne, hev⟩ := A.logDeriv_local_form n
  exact (meromorphicOrderAt_eq_int_iff
    (A.ledger_meromorphic (A.sphereZero n) (Set.mem_univ _))).mpr ⟨u, hu_an, hu_ne, hev⟩

/-- B2.1 per-zero residue value, trailing-coefficient rendering: the residue
of F′/F at an enumerated zero is its multiplicity tally in the enumeration.
STRICTLY per-zero (author's fence). CLOSED: the same `logDeriv_local_form`
presentation, read through the pin's
`AnalyticAt.meromorphicTrailingCoeffAt_of_ne_zero_of_eq_nhdsNE`; the
trailing coefficient is `u a = N`, the fiber tally. -/
theorem ledger_residueAt_zero (A : ASection) (n : ℕ) :
    meromorphicTrailingCoeffAt (fun z => deriv A.F z / A.F z) (A.sphereZero n)
      = (Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n} : ℂ) := by
  obtain ⟨u, hu_an, hu_val, hu_ne, hev⟩ := A.logDeriv_local_form n
  rw [hu_an.meromorphicTrailingCoeffAt_of_ne_zero_of_eq_nhdsNE hu_ne hev]
  exact hu_val

end ASection
