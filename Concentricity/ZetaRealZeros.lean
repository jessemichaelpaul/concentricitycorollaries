/-
Concentricity/ZetaRealZeros.lean

The LAST cluster-4 leaf, DERIVED in-repo (R10; closes the R6 flag of
ZetaStrip.lean/RhEquiv.lean): ζ(σ) ≠ 0 for real σ ∈ (0, 1) — no real zeros
in the critical strip. The classical alternating-series argument, rendered
through the paired (absolutely convergent) form:

  S(s) := ∑ₖ [(2k+1)^(−s) − (2k+2)^(−s)]

- each pair is s·∫ t^(−s−1)dt over [2k+1, 2k+2] (FTC,
  `hasDerivAt_ofReal_cpow_const`), giving the majorant
  ‖pair‖ ≤ ‖s‖·(2k+1)^(−Re s−1) — summable p-series;
- S is analytic on the half-plane Re > 0 (the §4α Weierstrass-convergence
  pattern of StemFactorization.lean, `differentiableOn_tsum_of_summable_norm`);
- on Re > 1, S = (1 − 2^{1−s})·ζ(s) (even/odd split of the Dirichlet
  series, `HasSum.even_add_odd`);
- (1 − 2^{1−s})·ζ(s) continues across the pole as
  poleFactor · zetaPoleUnit (both removable-singularity units, the
  ZetaPole.lean pattern; the zero of 1 − 2^{1−s} at 1 cancels the pole);
- the identity theorem on the CONVEX half-plane (`convex_halfSpace_re_gt`,
  the ZetaConj.lean pattern) extends S = poleFactor·zetaPoleUnit to
  Re > 0;
- at real σ ∈ (0,1): S(σ) is a positive real (each pair positive,
  `Real.rpow_le_rpow_of_nonpos`), while a zero ζ(σ) = 0 would force
  S(σ) = 0.

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file targets ZERO
sorries.
-/
import Concentricity.ZetaPole
import Concentricity.ZetaStrip
import Mathlib.Analysis.PSeries
import Mathlib.Analysis.PSeriesComplex
import Mathlib.Analysis.Complex.LocallyUniformLimit
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.Analysis.SpecialFunctions.Pow.Deriv
import Mathlib.Analysis.Complex.Convex

noncomputable section

open Complex

/-- The k-th conjugate pair of the alternating series: (2k+1)^(−s) −
(2k+2)^(−s). Pairing makes the convergence absolute on Re s > 0. -/
def etaPair (s : ℂ) (k : ℕ) : ℂ :=
  ((2 * (k : ℝ) + 1 : ℝ) : ℂ) ^ (-s) - ((2 * (k : ℝ) + 2 : ℝ) : ℂ) ^ (-s)

/-- The paired alternating sum S(s). -/
def etaPaired (s : ℂ) : ℂ := ∑' k, etaPair s k

/-- The (n+1)-form Dirichlet term of ζ. -/
private def zterm (s : ℂ) (n : ℕ) : ℂ := 1 / ((n : ℂ) + 1) ^ s

/-- The pair as the integral of the derivative across its step (FTC along
the real segment [2k+1, 2k+2]). PROVED helper. -/
theorem etaPair_eq_integral {s : ℂ} (hs : 0 < s.re) (k : ℕ) :
    etaPair s k
      = s * ∫ t in (2 * (k : ℝ) + 1)..(2 * (k : ℝ) + 2), (t : ℂ) ^ (-s - 1) := by
  have hs0 : -s ≠ 0 := by
    intro h
    rw [neg_eq_zero] at h
    rw [h] at hs
    simp at hs
  have hab : (2 * (k : ℝ) + 1) ≤ 2 * (k : ℝ) + 2 := by linarith
  have hpos : ∀ t ∈ Set.uIcc (2 * (k : ℝ) + 1) (2 * (k : ℝ) + 2), (0 : ℝ) < t := by
    intro t ht
    rw [Set.uIcc_of_le hab] at ht
    have : (0 : ℝ) < 2 * (k : ℝ) + 1 := by positivity
    linarith [ht.1]
  have hderiv : ∀ t ∈ Set.uIcc (2 * (k : ℝ) + 1) (2 * (k : ℝ) + 2),
      HasDerivAt (fun y : ℝ => (y : ℂ) ^ (-s)) (-s * (t : ℂ) ^ (-s - 1)) t :=
    fun t ht => hasDerivAt_ofReal_cpow_const (hpos t ht).ne' hs0
  have hint : IntervalIntegrable (fun t : ℝ => -s * (t : ℂ) ^ (-s - 1))
      MeasureTheory.volume (2 * (k : ℝ) + 1) (2 * (k : ℝ) + 2) := by
    apply ContinuousOn.intervalIntegrable
    intro t ht
    have hne : -s - 1 ≠ 0 := by
      intro h
      have := congrArg Complex.re h
      simp only [Complex.sub_re, Complex.neg_re, Complex.one_re,
        Complex.zero_re] at this
      linarith
    exact (continuousAt_const.mul
      (hasDerivAt_ofReal_cpow_const (hpos t ht).ne' hne).continuousAt
        ).continuousWithinAt
  have hFTC := intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint
  rw [intervalIntegral.integral_const_mul] at hFTC
  rw [etaPair]
  linear_combination hFTC

/-- The majorant: each pair is bounded by ‖s‖·(2k+1)^(−Re s − 1). PROVED
helper. -/
theorem etaPair_norm_le {s : ℂ} (hs : 0 < s.re) (k : ℕ) :
    ‖etaPair s k‖ ≤ ‖s‖ * (2 * (k : ℝ) + 1) ^ (-s.re - 1) := by
  rw [etaPair_eq_integral hs, norm_mul]
  refine mul_le_mul_of_nonneg_left ?_ (norm_nonneg s)
  have hab : (2 * (k : ℝ) + 1) ≤ 2 * (k : ℝ) + 2 := by linarith
  have hb := intervalIntegral.norm_integral_le_of_norm_le_const
    (C := (2 * (k : ℝ) + 1) ^ (-s.re - 1))
    (f := fun t : ℝ => (t : ℂ) ^ (-s - 1))
    (a := 2 * (k : ℝ) + 1) (b := 2 * (k : ℝ) + 2) ?_
  · calc ‖∫ t in (2 * (k : ℝ) + 1)..(2 * (k : ℝ) + 2), (t : ℂ) ^ (-s - 1)‖
        ≤ (2 * (k : ℝ) + 1) ^ (-s.re - 1) * |2 * (k : ℝ) + 2 - (2 * (k : ℝ) + 1)| :=
          hb
      _ = (2 * (k : ℝ) + 1) ^ (-s.re - 1) := by
          rw [show 2 * (k : ℝ) + 2 - (2 * (k : ℝ) + 1) = 1 by ring, abs_one,
            mul_one]
  · intro t ht
    rw [Set.uIoc_of_le hab] at ht
    have h1pos : (0 : ℝ) < 2 * (k : ℝ) + 1 := by positivity
    have htpos : (0 : ℝ) < t := lt_trans h1pos ht.1
    rw [Complex.norm_cpow_eq_rpow_re_of_pos htpos]
    have hre : (-s - 1).re = -s.re - 1 := by
      simp [Complex.sub_re, Complex.neg_re, Complex.one_re]
    rw [hre]
    exact Real.rpow_le_rpow_of_nonpos h1pos ht.1.le (by linarith)

/-- The p-series majorant is summable for any positive abscissa. PROVED
helper. -/
theorem summable_pairBound {ε : ℝ} (hε : 0 < ε) :
    Summable (fun k : ℕ => (2 * (k : ℝ) + 1) ^ (-ε - 1)) := by
  have h1 : Summable (fun k : ℕ => (((k : ℝ) + 1) ^ (ε + 1))⁻¹) := by
    have h2 := Real.summable_nat_rpow_inv.mpr (by linarith : 1 < ε + 1)
    have h3 := (summable_nat_add_iff 1).mpr h2
    refine h3.congr fun k => ?_
    push_cast
    ring_nf
  refine h1.of_nonneg_of_le (fun k => by positivity) fun k => ?_
  rw [show -ε - 1 = -(ε + 1) by ring,
    Real.rpow_neg (by positivity : (0 : ℝ) ≤ 2 * (k : ℝ) + 1)]
  have hbase : ((k : ℝ) + 1) ^ (ε + 1) ≤ (2 * (k : ℝ) + 1) ^ (ε + 1) :=
    Real.rpow_le_rpow (by positivity) (by linarith) (by linarith)
  rw [← one_div, ← one_div]
  exact one_div_le_one_div_of_le (by positivity) hbase

/-- Each pair is entire in s (constant positive real base). PROVED
helper. -/
theorem differentiable_etaPair (k : ℕ) :
    Differentiable ℂ (fun s => etaPair s k) := by
  have h1 : ∀ a : ℝ, 0 < a → Differentiable ℂ (fun s : ℂ => ((a : ℝ) : ℂ) ^ (-s)) := by
    intro a ha
    have heq : (fun s : ℂ => ((a : ℝ) : ℂ) ^ (-s))
        = fun s => Complex.exp (Complex.log ((a : ℝ) : ℂ) * -s) := by
      funext s
      exact Complex.cpow_def_of_ne_zero
        (Complex.ofReal_ne_zero.mpr ha.ne') _
    rw [heq]
    have hd : Differentiable ℂ (fun s : ℂ => Complex.log ((a : ℝ) : ℂ) * -s) := by
      fun_prop
    exact hd.cexp
  exact (h1 _ (by positivity)).sub (h1 _ (by positivity))

/-- Summability of the pairs on the open half-plane. PROVED helper. -/
theorem summable_etaPair {s : ℂ} (hs : 0 < s.re) :
    Summable (fun k => etaPair s k) :=
  Summable.of_norm_bounded ((summable_pairBound hs).mul_left ‖s‖)
    fun k => etaPair_norm_le hs k

/-- S is analytic on the open half-plane Re > 0 — the §4α
Weierstrass-convergence pattern. PROVED. -/
theorem etaPaired_analyticOnNhd :
    AnalyticOnNhd ℂ etaPaired {s : ℂ | 0 < s.re} := by
  refine DifferentiableOn.analyticOnNhd (fun z hz => ?_)
    (isOpen_lt continuous_const Complex.continuous_re)
  have hzre : 0 < z.re := hz
  set ε : ℝ := z.re / 2 with hε_def
  have hε : 0 < ε := by positivity
  have hball : ∀ w ∈ Metric.ball z ε, ε < w.re := by
    intro w hw
    have h1 : |(w - z).re| < ε :=
      lt_of_le_of_lt (Complex.abs_re_le_norm _)
        (by rw [← dist_eq_norm]; exact Metric.mem_ball.mp hw)
    have h2 := (abs_lt.mp h1).1
    rw [Complex.sub_re] at h2
    have h3 : z.re = 2 * ε := by rw [hε_def]; ring
    linarith
  set R : ℝ := ‖z‖ + ε with hR_def
  have hRnorm : ∀ w ∈ Metric.ball z ε, ‖w‖ ≤ R := by
    intro w hw
    have h1 : ‖w - z‖ < ε := by
      rw [← dist_eq_norm]
      exact Metric.mem_ball.mp hw
    have h2 : ‖w‖ - ‖z‖ ≤ ‖w - z‖ := norm_sub_norm_le w z
    rw [hR_def]
    linarith
  have hu : Summable (fun k : ℕ => R * (2 * (k : ℝ) + 1) ^ (-ε - 1)) :=
    (summable_pairBound hε).mul_left R
  have hle : ∀ k : ℕ, ∀ w ∈ Metric.ball z ε,
      ‖etaPair w k‖ ≤ R * (2 * (k : ℝ) + 1) ^ (-ε - 1) := by
    intro k w hw
    have hwre : 0 < w.re := lt_trans hε (hball w hw)
    refine le_trans (etaPair_norm_le hwre k) ?_
    have hmono : (2 * (k : ℝ) + 1) ^ (-w.re - 1)
        ≤ (2 * (k : ℝ) + 1) ^ (-ε - 1) :=
      Real.rpow_le_rpow_of_exponent_le
        (by linarith [Nat.cast_nonneg (α := ℝ) k])
        (by linarith [hball w hw])
    have hnw : ‖w‖ ≤ R := hRnorm w hw
    exact mul_le_mul hnw hmono (by positivity) (by rw [hR_def]; positivity)
  have hdiff : ∀ k : ℕ, DifferentiableOn ℂ (fun s => etaPair s k)
      (Metric.ball z ε) := fun k => (differentiable_etaPair k).differentiableOn
  exact ((Complex.differentiableOn_tsum_of_summable_norm hu hdiff
    Metric.isOpen_ball hle).differentiableAt
    (Metric.isOpen_ball.mem_nhds (Metric.mem_ball_self hε))).differentiableWithinAt

/-- On Re > 1, S(s) = (1 − 2^{1−s})·ζ(s): the even/odd split of the
Dirichlet series. PROVED. -/
theorem etaPaired_eq_of_one_lt_re {s : ℂ} (hs : 1 < s.re) :
    etaPaired s = (1 - 2 ^ (1 - s)) * riemannZeta s := by
  have hsum : Summable (zterm s) := by
    have h1 := Complex.summable_one_div_nat_cpow.mpr hs
    have h2 := (summable_nat_add_iff 1).mpr h1
    refine h2.congr fun n => ?_
    rw [zterm]
    norm_cast
  have hfsum : HasSum (zterm s) (riemannZeta s) := by
    have h2 : riemannZeta s = ∑' n, zterm s n := by
      rw [zeta_eq_tsum_one_div_nat_add_one_cpow hs]
      exact tsum_congr fun n => by rw [zterm]
    rw [h2]
    exact hsum.hasSum
  have hEven : Summable fun k => zterm s (2 * k) :=
    hsum.comp_injective (mul_right_injective₀ two_ne_zero)
  have hOdd : Summable fun k => zterm s (2 * k + 1) :=
    hsum.comp_injective fun a b h => by omega
  have hval : (∑' k, zterm s (2 * k)) + (∑' k, zterm s (2 * k + 1))
      = riemannZeta s :=
    (hEven.hasSum.even_add_odd hOdd.hasSum).unique hfsum
  have hterm : ∀ k : ℕ, zterm s (2 * k + 1) = 2 ^ (-s) * zterm s k := by
    intro k
    rw [zterm, zterm]
    have hb : ((2 * k + 1 : ℕ) : ℂ) + 1
        = ((2 : ℝ) : ℂ) * ((((k : ℝ) + 1) : ℝ) : ℂ) := by
      push_cast
      ring
    rw [hb, Complex.mul_cpow_ofReal_nonneg (by norm_num) (by positivity)]
    have hk' : ((((k : ℝ) + 1) : ℝ) : ℂ) = (k : ℂ) + 1 := by push_cast; ring
    have h2' : ((2 : ℝ) : ℂ) = (2 : ℂ) := by norm_num
    rw [hk', h2', Complex.cpow_neg, one_div, one_div, mul_inv]
  have hOddval : (∑' k, zterm s (2 * k + 1)) = 2 ^ (-s) * riemannZeta s := by
    rw [tsum_congr hterm, tsum_mul_left, hfsum.tsum_eq]
  have hEvenval : (∑' k, zterm s (2 * k))
      = riemannZeta s - 2 ^ (-s) * riemannZeta s := by
    rw [← hOddval]
    exact eq_sub_of_add_eq hval
  have hEta : ∀ k, etaPair s k = zterm s (2 * k) - zterm s (2 * k + 1) := by
    intro k
    rw [etaPair, zterm, zterm]
    have e1 : ((2 * (k : ℝ) + 1 : ℝ) : ℂ) = ((2 * k : ℕ) : ℂ) + 1 := by
      push_cast
      ring
    have e2 : ((2 * (k : ℝ) + 2 : ℝ) : ℂ) = ((2 * k + 1 : ℕ) : ℂ) + 1 := by
      push_cast
      ring
    rw [e1, e2, Complex.cpow_neg, Complex.cpow_neg, one_div, one_div]
  rw [etaPaired, tsum_congr hEta, hEven.tsum_sub hOdd, hEvenval, hOddval,
    show (1 : ℂ) - s = 1 + -s by ring, Complex.cpow_add _ _ two_ne_zero,
    Complex.cpow_one]
  ring

/-- The pole-cancelling factor (1 − 2^{1−s})/(s − 1), extended across 1 by
its limit log 2 (the derivative of −2^{1−s} at 1) — the removable unit for
the OTHER side of the cancellation. -/
def poleFactor : ℂ → ℂ :=
  Function.update (fun s => (1 - 2 ^ (1 - s)) / (s - 1)) 1 (Complex.log 2)

theorem poleFactor_apply_of_ne {s : ℂ} (hs : s ≠ 1) :
    poleFactor s = (1 - 2 ^ (1 - s)) / (s - 1) :=
  Function.update_of_ne hs _ _

/-- 2^{1−s} is entire in s. PROVED helper. -/
theorem differentiable_two_cpow_one_sub :
    Differentiable ℂ fun s : ℂ => (2 : ℂ) ^ (1 - s) := by
  have heq : (fun s : ℂ => (2 : ℂ) ^ (1 - s))
      = fun s => Complex.exp (Complex.log 2 * (1 - s)) := by
    funext s
    exact Complex.cpow_def_of_ne_zero two_ne_zero _
  rw [heq]
  have hd : Differentiable ℂ fun s : ℂ => Complex.log 2 * (1 - s) := by
    fun_prop
  exact hd.cexp

/-- The factor is analytic everywhere — removable singularity at 1 (the
`zetaPoleUnit_analyticAt_one` pattern), quotient elsewhere. PROVED. -/
theorem poleFactor_analyticAt (s : ℂ) : AnalyticAt ℂ poleFactor s := by
  by_cases hs : s = 1
  · subst hs
    apply analyticAt_of_differentiable_on_punctured_nhds_of_continuousAt
    · filter_upwards [self_mem_nhdsWithin] with z hz
      have hz1 : z ≠ 1 := hz
      have hev : (fun w => (1 - 2 ^ (1 - w)) / (w - 1)) =ᶠ[nhds z] poleFactor := by
        filter_upwards [isOpen_compl_singleton.mem_nhds
          (Set.mem_compl_singleton_iff.mpr hz1)] with w hw
        exact (poleFactor_apply_of_ne (Set.mem_compl_singleton_iff.mp hw)).symm
      exact ((((differentiable_const _).sub
        differentiable_two_cpow_one_sub) _).div
        ((differentiable_id.sub_const 1) _)
        (sub_ne_zero.mpr hz1)).congr_of_eventuallyEq hev.symm
    · have hd : HasDerivAt (fun z : ℂ => (2 : ℂ) ^ (1 - z)) (-Complex.log 2) 1 := by
        have heq : (fun z : ℂ => (2 : ℂ) ^ (1 - z))
            = fun z => Complex.exp (Complex.log 2 * (1 - z)) := by
          funext z
          exact Complex.cpow_def_of_ne_zero two_ne_zero _
        rw [heq]
        have h1 : HasDerivAt (fun z : ℂ => Complex.log 2 * (1 - z))
            (-Complex.log 2) 1 := by
          simpa using ((hasDerivAt_id (1 : ℂ)).const_sub 1).const_mul
            (Complex.log 2)
        simpa using h1.cexp
      have hslope := hasDerivAt_iff_tendsto_slope.mp hd
      have hneg := hslope.neg
      rw [neg_neg] at hneg
      have htend : Filter.Tendsto (fun z : ℂ => (1 - 2 ^ (1 - z)) / (z - 1))
          (nhdsWithin 1 {(1 : ℂ)}ᶜ) (nhds (Complex.log 2)) := by
        refine hneg.congr' ?_
        filter_upwards [self_mem_nhdsWithin] with z hz
        rw [slope_def_field]
        change -(((2 : ℂ) ^ (1 - z) - (2 : ℂ) ^ (1 - (1 : ℂ))) / (z - 1))
          = (1 - 2 ^ (1 - z)) / (z - 1)
        rw [show (1 : ℂ) - (1 : ℂ) = 0 from sub_self 1, Complex.cpow_zero]
        ring
      exact continuousAt_update_same.mpr htend
  · have h1 : AnalyticAt ℂ (fun w : ℂ => (1 - 2 ^ (1 - w)) / (w - 1)) s := by
      refine AnalyticAt.div ?_ (analyticAt_id.sub analyticAt_const)
        (sub_ne_zero.mpr hs)
      exact analyticAt_const.sub (differentiable_two_cpow_one_sub.analyticAt s)
    refine h1.congr ?_
    filter_upwards [isOpen_compl_singleton.mem_nhds
      (Set.mem_compl_singleton_iff.mpr hs)] with w hw
    exact (poleFactor_apply_of_ne (Set.mem_compl_singleton_iff.mp hw)).symm

/-- `zetaPoleUnit` is analytic at every point (at 1 by
`zetaPoleUnit_analyticAt_one`, elsewhere as (s−1)·ζ). PROVED. -/
theorem zetaPoleUnit_analyticAt (s : ℂ) : AnalyticAt ℂ zetaPoleUnit s := by
  by_cases hs : s = 1
  · subst hs
    exact zetaPoleUnit_analyticAt_one
  · have h1 : AnalyticAt ℂ (fun w : ℂ => (w - 1) * riemannZeta w) s :=
      (analyticAt_id.sub analyticAt_const).mul (riemannZeta_analyticAt hs)
    refine h1.congr ?_
    filter_upwards [isOpen_compl_singleton.mem_nhds
      (Set.mem_compl_singleton_iff.mpr hs)] with w hw
    exact (zetaPoleUnit_apply_of_ne (Set.mem_compl_singleton_iff.mp hw)).symm

/-- The identity theorem on the CONVEX half-plane: S = poleFactor ·
zetaPoleUnit on all of Re > 0 — the pole cancellation, analytically
continued. PROVED. -/
theorem etaPaired_eq_poleFactor_mul {s : ℂ} (hs : 0 < s.re) :
    etaPaired s = poleFactor s * zetaPoleUnit s := by
  have hconn : IsPreconnected {z : ℂ | 0 < z.re} :=
    (convex_halfSpace_re_gt 0).isPreconnected
  have hg : AnalyticOnNhd ℂ (fun z => poleFactor z * zetaPoleUnit z)
      {z : ℂ | 0 < z.re} :=
    fun z _ => (poleFactor_analyticAt z).mul (zetaPoleUnit_analyticAt z)
  have h2 : (2 : ℂ) ∈ {z : ℂ | 0 < z.re} := by norm_num
  have hev : etaPaired =ᶠ[nhds (2 : ℂ)]
      fun z => poleFactor z * zetaPoleUnit z := by
    have hopen1 : IsOpen {z : ℂ | 1 < z.re} :=
      isOpen_lt continuous_const Complex.continuous_re
    filter_upwards [hopen1.mem_nhds
      (by norm_num : (2 : ℂ) ∈ {z : ℂ | 1 < z.re})] with z hz
    have hzre : 1 < z.re := hz
    have hz1 : z ≠ 1 := by
      intro h
      rw [h] at hzre
      simp at hzre
    rw [etaPaired_eq_of_one_lt_re hzre, poleFactor_apply_of_ne hz1,
      zetaPoleUnit_apply_of_ne hz1]
    have hzne : z - 1 ≠ 0 := sub_ne_zero.mpr hz1
    field_simp
  exact etaPaired_analyticOnNhd.eqOn_of_preconnected_of_eventuallyEq hg hconn
    h2 hev hs

/-- **THE LEAF** (closes the R6 flag): ζ has no real zeros in the critical
strip — for real σ ∈ (0,1), ζ(σ) ≠ 0. A zero would force the paired
alternating sum S(σ) to vanish, but S(σ) is a strictly positive real:
1 − 2^{−σ} > 0 leads, and every pair (2k+1)^{−σ} − (2k+2)^{−σ} ≥ 0.
DERIVED (R10), completing cluster 4; `thm:rh-equiv`'s full iff and
`thm:zero-spheres`(iv)'s sphere-count consume exactly this row. -/
theorem riemannZeta_ne_zero_of_real_mem_Ioo {σ : ℝ} (h0 : 0 < σ)
    (h1 : σ < 1) : riemannZeta σ ≠ 0 := by
  intro hz
  have hσre : (0 : ℝ) < ((σ : ℂ)).re := by simpa using h0
  have hσ1 : (σ : ℂ) ≠ 1 := by
    intro h
    have h2 := congrArg Complex.re h
    simp only [Complex.ofReal_re, Complex.one_re] at h2
    linarith
  have heq := etaPaired_eq_poleFactor_mul hσre
  rw [zetaPoleUnit_apply_of_ne hσ1, hz, mul_zero, mul_zero] at heq
  have hpair : ∀ k : ℕ, etaPair (σ : ℂ) k
      = (((2 * (k : ℝ) + 1) ^ (-σ) - (2 * (k : ℝ) + 2) ^ (-σ) : ℝ) : ℂ) := by
    intro k
    rw [etaPair, Complex.ofReal_sub,
      Complex.ofReal_cpow (by positivity : (0 : ℝ) ≤ 2 * (k : ℝ) + 1),
      Complex.ofReal_cpow (by positivity : (0 : ℝ) ≤ 2 * (k : ℝ) + 2),
      Complex.ofReal_neg]
  have hsummable : Summable
      (fun k : ℕ => (2 * (k : ℝ) + 1) ^ (-σ) - (2 * (k : ℝ) + 2) ^ (-σ)) := by
    refine Complex.summable_ofReal.mp ?_
    exact (summable_etaPair hσre).congr hpair
  have hterm_nonneg : ∀ k : ℕ,
      (0 : ℝ) ≤ (2 * (k : ℝ) + 1) ^ (-σ) - (2 * (k : ℝ) + 2) ^ (-σ) := by
    intro k
    have := Real.rpow_le_rpow_of_nonpos
      (by positivity : (0 : ℝ) < 2 * (k : ℝ) + 1)
      (by linarith : (2 * (k : ℝ) + 1) ≤ 2 * (k : ℝ) + 2)
      (by linarith : -σ ≤ 0)
    linarith
  have hterm0 : (0 : ℝ)
      < (2 * ((0 : ℕ) : ℝ) + 1) ^ (-σ) - (2 * ((0 : ℕ) : ℝ) + 2) ^ (-σ) := by
    have hlt : (2 : ℝ) ^ (-σ) < 1 :=
      Real.rpow_lt_one_of_one_lt_of_neg one_lt_two (by linarith)
    have h1eq : (2 * ((0 : ℕ) : ℝ) + 1) ^ (-σ) = 1 := by
      norm_num
    have h2eq : (2 * ((0 : ℕ) : ℝ) + 2) ^ (-σ) = (2 : ℝ) ^ (-σ) := by
      norm_num
    rw [h1eq, h2eq]
    linarith
  have hSpos := hsummable.tsum_pos hterm_nonneg 0 hterm0
  rw [etaPaired, tsum_congr hpair, ← Complex.ofReal_tsum] at heq
  rw [Complex.ofReal_eq_zero] at heq
  exact absurd heq (ne_of_gt hSpos)

/-- Cluster 4 COMPLETE — every nontrivial zero is non-real: the strip
classification (`nontrivialZero_re_mem_Ioo`, ZetaStrip.lean) plus the
real-zero exclusion above. Consumed by `thm:rh-equiv`'s full iff
(RhEquiv.lean) and `thm:zero-spheres`(iv)'s sphere-count
(ZeroSpheres.lean). PROVED. -/
theorem nontrivialZero_im_ne_zero {s : ℂ} (hz : riemannZeta s = 0)
    (htriv : ¬∃ n : ℕ, s = -2 * (n + 1)) (hone : s ≠ 1) : s.im ≠ 0 := by
  intro him
  obtain ⟨h0, h1⟩ := nontrivialZero_re_mem_Ioo hz htriv hone
  have hseq : ((s.re : ℝ) : ℂ) = s :=
    Complex.ext (Complex.ofReal_re _)
      (by rw [Complex.ofReal_im]; exact him.symm)
  exact riemannZeta_ne_zero_of_real_mem_Ioo h0 h1 (by rw [hseq]; exact hz)
