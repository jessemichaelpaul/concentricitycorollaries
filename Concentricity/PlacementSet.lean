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
upper-half-plane zeros of the stem share one real part. -/
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

end ASection
