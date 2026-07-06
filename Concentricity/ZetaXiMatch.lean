/-
Concentricity/ZetaXiMatch.lean

The Weierstrass package build, STAGE B1 (author "Stage B execute", 2026-07-05):
the conjugation infrastructure and the analytic package of the canonical
product P — toward the divisor match ∀ s, ord_s ξ = ord_s P (stage B2),
which is the precise level-matching the extension move needs: ξ carries the
one stem's divisor, P carries the enumeration's, and matching orders
everywhere is what lets stage C write ξ = e^g·P through the entire-log
engine.

PROVED here:
- `weierstrassE_conj` / `spherePrimary_conj`: real-coefficient
  conj-equivariance of the factors;
- `AnalyticAt.conj_comp_conj`: the conjugation sandwich preserves
  analyticity (the ZetaConj HasDerivAt sandwich, upgraded);
- `IsIntrinsic.analyticOrderAt_conj`: intrinsic entire functions have
  conjugation-symmetric divisors — the lower half of the order match for
  free;
- `zetaProd` (P itself), analytic everywhere (the §4α block over the
  stage-A majorant) and intrinsic;
- `completedRiemannZeta₀_conj` (Λ₀ is intrinsic — the ZetaConj identity-
  theorem pattern on the CONNECTED plane, no puncture needed: Λ₀ is
  entire) and `xi_intrinsic`.

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file targets ZERO
sorries.
-/
import Concentricity.ZetaWeierstrass

noncomputable section

open Complex

/-! ## Conjugation equivariance of the factors -/

/-- E_p has real coefficients: conj-equivariance. PROVED helper. -/
theorem weierstrassE_conj (p : ℕ) (w : ℂ) :
    weierstrassE p ((starRingEnd ℂ) w) = (starRingEnd ℂ) (weierstrassE p w) := by
  rw [weierstrassE, weierstrassE, map_mul, map_sub, map_one]
  congr 1
  rw [← Complex.exp_conj]
  congr 1
  rw [map_sum]
  refine Finset.sum_congr rfl fun k _ => ?_
  rw [map_div₀, map_pow, map_add, map_natCast, map_one]

/-- The conjugate-pair factor is intrinsic in the variable (the pair is
swap-symmetric under conjugation). PROVED helper. -/
theorem spherePrimary_conj (p : ℕ) (a w : ℂ) :
    spherePrimary p a ((starRingEnd ℂ) w)
      = (starRingEnd ℂ) (spherePrimary p a w) := by
  rw [spherePrimary, spherePrimary, map_mul]
  have h1 : (starRingEnd ℂ) w / a = (starRingEnd ℂ) (w / (starRingEnd ℂ) a) := by
    rw [map_div₀, starRingEnd_self_apply]
  have h2 : (starRingEnd ℂ) w / (starRingEnd ℂ) a = (starRingEnd ℂ) (w / a) := by
    rw [map_div₀]
  rw [h1, h2, weierstrassE_conj, weierstrassE_conj]
  ring

/-! ## The conjugation sandwich on analyticity and orders -/

/-- The conjugation sandwich preserves analyticity (the ZetaConj
`HasDerivAt.conj_comp_conj`, upgraded through a ball). PROVED. -/
theorem AnalyticAt.conj_comp_conj {g : ℂ → ℂ} {s : ℂ} (hg : AnalyticAt ℂ g s) :
    AnalyticAt ℂ (fun z => (starRingEnd ℂ) (g ((starRingEnd ℂ) z)))
      ((starRingEnd ℂ) s) := by
  obtain ⟨r, hr, hdiff⟩ : ∃ r > 0, ∀ w ∈ Metric.ball s r, DifferentiableAt ℂ g w := by
    have h := hg.eventually_analyticAt
    rw [Filter.eventually_iff, Metric.mem_nhds_iff] at h
    obtain ⟨r, hr, hball⟩ := h
    exact ⟨r, hr, fun w hw => (hball hw).differentiableAt⟩
  have hd : DifferentiableOn ℂ
      (fun z => (starRingEnd ℂ) (g ((starRingEnd ℂ) z)))
      (Metric.ball ((starRingEnd ℂ) s) r) := by
    intro w hw
    have hcw : (starRingEnd ℂ) w ∈ Metric.ball s r := by
      rw [Metric.mem_ball, dist_eq_norm] at hw ⊢
      rw [show (starRingEnd ℂ) w - s
          = (starRingEnd ℂ) (w - (starRingEnd ℂ) s) by
        rw [map_sub, starRingEnd_self_apply], RCLike.norm_conj]
      exact hw
    exact ((hdiff _ hcw).hasDerivAt.conj_comp_conj
      ).differentiableAt.differentiableWithinAt
  exact (hd.analyticOnNhd Metric.isOpen_ball) _
    (Metric.mem_ball_self hr)

/-- Intrinsic everywhere-analytic functions have conjugation-symmetric
divisors: ord at conj s = ord at s. The lower half of the divisor match,
for free. PROVED. -/
theorem IsIntrinsic.analyticOrderAt_conj {f : ℂ → ℂ} (hf : IsIntrinsic f)
    (hall : ∀ z, AnalyticAt ℂ f z) (s : ℂ) :
    analyticOrderAt f ((starRingEnd ℂ) s) = analyticOrderAt f s := by
  have hconj_tendsto : Filter.Tendsto (starRingEnd ℂ)
      (nhds ((starRingEnd ℂ) s)) (nhds s) := by
    have h := Complex.continuous_conj.tendsto ((starRingEnd ℂ) s)
    rwa [starRingEnd_self_apply] at h
  cases hn : analyticOrderAt f s with
  | top =>
    rw [analyticOrderAt_eq_top] at hn ⊢
    filter_upwards [hconj_tendsto.eventually hn] with z hz
    have h1 := hf z
    rw [hz] at h1
    have h2 := congrArg (starRingEnd ℂ) h1.symm
    rwa [starRingEnd_self_apply, map_zero] at h2
  | coe n =>
    rw [(hall s).analyticOrderAt_eq_natCast] at hn
    obtain ⟨g, hg_an, hg_ne, hev⟩ := hn
    rw [(hall _).analyticOrderAt_eq_natCast]
    refine ⟨fun z => (starRingEnd ℂ) (g ((starRingEnd ℂ) z)),
      hg_an.conj_comp_conj, ?_, ?_⟩
    · intro h0
      have h0' : (starRingEnd ℂ) (g ((starRingEnd ℂ) ((starRingEnd ℂ) s))) = 0 := h0
      rw [starRingEnd_self_apply] at h0'
      exact hg_ne (by simpa using h0')
    · filter_upwards [hconj_tendsto.eventually hev] with z hz
      have h1 : f z = (starRingEnd ℂ) (f ((starRingEnd ℂ) z)) := by
        have h := hf ((starRingEnd ℂ) z)
        rwa [starRingEnd_self_apply] at h
      rw [h1, hz, smul_eq_mul, smul_eq_mul, map_mul, map_pow, map_sub,
        starRingEnd_self_apply]

/-! ## The canonical product P -/

/-- **P** — the genus-n canonical product over the divisor-repeated
enumeration (the Weierstrass side of the one stem). -/
noncomputable def zetaProd (z : ℂ) : ℂ :=
  ∏' n, spherePrimary n (zetaSphereZero n) z

/-- P is analytic everywhere — the §4α Weierstrass-convergence block over
the stage-A majorant. PROVED. -/
theorem zetaProd_analyticAt (z : ℂ) : AnalyticAt ℂ zetaProd z := by
  obtain ⟨r, hr, u, hu, hbound⟩ := zetaC3_locMajorant_proved z
  have htend : MultipliableLocallyUniformlyOn
      (fun n => spherePrimary n (zetaSphereZero n)) (Metric.ball z r) := by
    have h1 : MultipliableLocallyUniformlyOn
        (fun n w => 1 + (spherePrimary n (zetaSphereZero n) w - 1))
        (Metric.ball z r) :=
      Summable.multipliableLocallyUniformlyOn_nat_one_add Metric.isOpen_ball hu
        (Filter.Eventually.of_forall fun n w hw => hbound n w hw)
        (fun n => ((differentiable_spherePrimary _ _).sub_const
          1).continuous.continuousOn)
    exact MultipliableLocallyUniformlyOn_congr (fun n w _ => by ring) h1
  have h2 := hasProdLocallyUniformlyOn_iff_tendstoLocallyUniformlyOn.mp
    htend.hasProdLocallyUniformlyOn
  have hdiff := h2.differentiableOn
    (Filter.Eventually.of_forall fun t => fun w _ =>
      (DifferentiableAt.fun_finsetProd fun i _ =>
        (differentiable_spherePrimary _ _).differentiableAt
          ).differentiableWithinAt)
    Metric.isOpen_ball
  exact (hdiff.analyticOnNhd Metric.isOpen_ball) _ (Metric.mem_ball_self hr)

/-- P is intrinsic (termwise conj-equivariance through the product).
PROVED. -/
theorem zetaProd_intrinsic : IsIntrinsic zetaProd := by
  intro z
  have hm := (zetaC3_multipliable_proved z).hasProd
  have hmap := hm.map ((starRingEnd ℂ) : ℂ →* ℂ) Complex.continuous_conj
  have hcongr : (fun n => spherePrimary n (zetaSphereZero n) ((starRingEnd ℂ) z))
      = fun n => (starRingEnd ℂ) (spherePrimary n (zetaSphereZero n) z) :=
    funext fun n => spherePrimary_conj _ _ _
  rw [zetaProd, zetaProd, hcongr]
  exact hmap.tprod_eq

/-! ## ξ is intrinsic -/

/-- Λ₀ is intrinsic — the ZetaConj identity-theorem pattern, on the whole
(connected) plane since Λ₀ is entire; the agreement region Re > 1 unfolds
Λ₀ through the divisor bridge and the pinned conj-equivariances. PROVED. -/
theorem completedRiemannZeta₀_conj (s : ℂ) :
    completedRiemannZeta₀ ((starRingEnd ℂ) s)
      = (starRingEnd ℂ) (completedRiemannZeta₀ s) := by
  have hf : AnalyticOnNhd ℂ completedRiemannZeta₀ Set.univ :=
    fun z _ => differentiable_completedZeta₀.analyticAt z
  have hg : AnalyticOnNhd ℂ
      (fun w => (starRingEnd ℂ) (completedRiemannZeta₀ ((starRingEnd ℂ) w)))
      Set.univ := by
    intro z _
    have h := (differentiable_completedZeta₀.analyticAt
      ((starRingEnd ℂ) z)).conj_comp_conj
    rwa [starRingEnd_self_apply] at h
  have key : ∀ v : ℂ, v ≠ 0 → 0 < v.re → completedRiemannZeta₀ v
      = Gammaℝ v * riemannZeta v + 1 / v + 1 / (1 - v) := by
    intro v hv0 hvre
    have h1 := completedRiemannZeta_eq v
    have h2 := riemannZeta_def_of_ne_zero hv0
    have hΓ : Gammaℝ v ≠ 0 := Gammaℝ_ne_zero_of_re_pos hvre
    have h3 : Gammaℝ v * riemannZeta v = completedRiemannZeta v := by
      rw [h2]
      field_simp
    rw [h1] at h3
    linear_combination -h3
  have hev : completedRiemannZeta₀ =ᶠ[nhds (2 : ℂ)]
      fun w => (starRingEnd ℂ) (completedRiemannZeta₀ ((starRingEnd ℂ) w)) := by
    have hopen : IsOpen {w : ℂ | 1 < w.re} :=
      isOpen_lt continuous_const Complex.continuous_re
    filter_upwards [hopen.mem_nhds
      (by norm_num : (2 : ℂ) ∈ {w : ℂ | 1 < w.re})] with w hw
    have hwre : 1 < w.re := hw
    have hw0 : w ≠ 0 := by
      intro h
      rw [h] at hwre
      simp only [Complex.zero_re] at hwre
      linarith
    have hcw0 : (starRingEnd ℂ) w ≠ 0 := fun h =>
      hw0 (by simpa using congrArg (starRingEnd ℂ) h)
    rw [key w hw0 (by linarith),
      key ((starRingEnd ℂ) w) hcw0 (by rw [Complex.conj_re]; linarith),
      Gammaℝ_conj, riemannZeta_conj, map_add, map_add, map_mul,
      starRingEnd_self_apply, starRingEnd_self_apply, map_div₀, map_one,
      starRingEnd_self_apply, map_div₀, map_one, map_sub, map_one,
      starRingEnd_self_apply]
  have hkey := hf.eqOn_of_preconnected_of_eventuallyEq hg isPreconnected_univ
    (Set.mem_univ (2 : ℂ)) hev (Set.mem_univ s)
  have h2 := congrArg (starRingEnd ℂ) hkey
  rw [starRingEnd_self_apply] at h2
  exact h2.symm

/-- ξ is intrinsic — pointwise algebra over `completedRiemannZeta₀_conj`.
PROVED. -/
theorem xi_intrinsic : IsIntrinsic xi := by
  intro z
  rw [xi, xi, completedRiemannZeta₀_conj, map_add, map_one, map_mul, map_mul,
    map_sub, map_one]
