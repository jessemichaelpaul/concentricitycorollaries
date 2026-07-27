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
import Concentricity.RhEquiv

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

/-! ## STAGE B2a — fiber counts, nonvanishing, and P's local order -/

/-- The fiber over any point is finite (it sits in a norm ball). PROVED
helper. -/
theorem zetaSphereZero_fiber_finite (s : ℂ) :
    {n : ℕ | zetaSphereZero n = s}.Finite := by
  refine Set.Finite.subset (zetaSphereZero_norm_lt_finite (‖s‖ + 1)) ?_
  intro n hn
  have h : zetaSphereZero n = s := hn
  simp only [Set.mem_setOf_eq, h]
  linarith [norm_nonneg s]

/-- **The divisor-repetition readout**: over an upper-half zero the fiber
has exactly the multiplicity many indices — the pairs construction,
counted. PROVED. -/
theorem zetaSphereZero_fiber_ncard {s : ℂ} (hs : s ∈ zetaUpperZeros) :
    {n : ℕ | zetaSphereZero n = s}.ncard = zetaZeroMult s := by
  set φ : ℕ → ℂ × ℕ := fun n => ((zetaZeroEnum n : ↥zetaZeroPairs) : ℂ × ℕ)
    with hφ_def
  have hφinj : Function.Injective φ := fun a b hab =>
    zetaZeroEnum.injective (Subtype.ext hab)
  have himg : φ '' {n : ℕ | zetaSphereZero n = s}
      = ({s} : Set ℂ) ×ˢ Set.Iio (zetaZeroMult s) := by
    ext ⟨v, k⟩
    constructor
    · rintro ⟨n, hn, hφn⟩
      have h1 : zetaSphereZero n = s := hn
      have hmem : φ n ∈ zetaZeroPairs := (zetaZeroEnum n).2
      have hv : (φ n).1 = s := h1
      rw [← hφn]
      refine Set.mem_prod.mpr ⟨?_, ?_⟩
      · show (φ n).1 ∈ ({s} : Set ℂ)
        rw [hv]
        rfl
      · show (φ n).2 ∈ Set.Iio (zetaZeroMult (s : ℂ))
        rw [Set.mem_Iio, ← hv]
        exact hmem.2
    · rintro ⟨hv, hk⟩
      have hv' : v = s := hv
      subst hv'
      rw [Set.mem_Iio] at hk
      have hp : (v, k) ∈ zetaZeroPairs := ⟨hs, hk⟩
      refine ⟨zetaZeroEnum.symm ⟨(v, k), hp⟩, ?_, ?_⟩
      · show zetaSphereZero _ = v
        rw [zetaSphereZero, Equiv.apply_symm_apply]
      · rw [hφ_def]
        simp only [Equiv.apply_symm_apply]
  have h1 : ({n : ℕ | zetaSphereZero n = s}).ncard
      = (φ '' {n : ℕ | zetaSphereZero n = s}).ncard :=
    (Set.ncard_image_of_injective _ hφinj).symm
  rw [h1, himg]
  have h2 : ({s} : Set ℂ) ×ˢ Set.Iio (zetaZeroMult s)
      = (fun k => (s, k)) '' Set.Iio (zetaZeroMult s) := by
    ext ⟨v, k⟩
    simp [Set.mem_prod, eq_comm, and_comm]
  rw [h2, Set.ncard_image_of_injective _ (fun a b hab => (Prod.mk.injEq _ _ _ _).mp hab |>.2),
    show Set.Iio (zetaZeroMult s) = ↑(Finset.range (zetaZeroMult s)) by
      rw [Finset.coe_range],
    Set.ncard_coe_finset, Finset.card_range]

/-- P does not vanish away from the enumerated pairs. PROVED. -/
theorem zetaProd_ne_zero {z : ℂ}
    (h1 : ∀ n, z ≠ zetaSphereZero n)
    (h2 : ∀ n, z ≠ (starRingEnd ℂ) (zetaSphereZero n)) : zetaProd z ≠ 0 := by
  obtain ⟨r, hr, u, hu, hbound⟩ := zetaC3_locMajorant_proved z
  refine tprod_ne_zero_of_norm_sub_one_le hu
    (fun n => hbound n z (Metric.mem_ball_self hr)) fun n => ?_
  have ha : zetaSphereZero n ≠ 0 := by
    intro h
    have := zetaSphereZero_im_pos n
    rw [h] at this
    simp at this
  exact spherePrimary_ne_zero _ ha (h1 n) (h2 n)

/-- The tail past a finite index set is summable at every point (the
stage-A geometric bound off the finitely many exceptions). PROVED
helper. -/
theorem zetaTail_summable (t : Finset ℕ) (w : ℂ) :
    Summable fun n =>
      (if n ∈ t then (1 : ℂ) else spherePrimary n (zetaSphereZero n) w) - 1 := by
  have hbad := zetaSphereZero_norm_lt_finite (2 * (‖w‖ + 1))
  refine Summable.of_norm_bounded_eventually summable_geoBound ?_
  filter_upwards [hbad.eventually_cofinite_notMem,
    t.finite_toSet.eventually_cofinite_notMem] with n hn1 hn2
  have hn2' : n ∉ t := by simpa using hn2
  rw [if_neg hn2']
  exact zetaWeierstrass_bound_of_far (by positivity)
    (by linarith [norm_nonneg w]) (not_lt.mp hn1)

/-- The head/tail split of P at a finite index set, at every point (the
StemFactorization `hsplit` pattern). PROVED helper. -/
theorem zetaProd_split (t : Finset ℕ) (w : ℂ) :
    zetaProd w = (∏ n ∈ t, spherePrimary n (zetaSphereZero n) w) *
      ∏' n, (if n ∈ t then (1 : ℂ) else spherePrimary n (zetaSphereZero n) w) := by
  have hhead : HasProd
      (fun n => if n ∈ t then spherePrimary n (zetaSphereZero n) w else 1)
      (∏ n ∈ t, if n ∈ t then spherePrimary n (zetaSphereZero n) w else 1) :=
    hasProd_prod_of_ne_finset_one fun b hb => if_neg hb
  have htail : Multipliable fun n =>
      (if n ∈ t then (1 : ℂ) else spherePrimary n (zetaSphereZero n) w) := by
    have h1 := Complex.multipliable_one_add_of_summable (zetaTail_summable t w)
    exact h1.congr fun n => by ring
  calc zetaProd w
      = ∏' n, ((if n ∈ t then spherePrimary n (zetaSphereZero n) w else 1) *
          (if n ∈ t then (1 : ℂ) else spherePrimary n (zetaSphereZero n) w)) := by
        rw [zetaProd]
        exact tprod_congr fun n => by by_cases hn : n ∈ t <;> simp [hn]
    _ = (∏' n, if n ∈ t then spherePrimary n (zetaSphereZero n) w else 1) *
          ∏' n, (if n ∈ t then (1 : ℂ) else spherePrimary n (zetaSphereZero n) w) :=
        Multipliable.tprod_mul hhead.multipliable htail
    _ = _ := by
        rw [hhead.tprod_eq]
        congr 1
        exact Finset.prod_congr rfl fun n hn => if_pos hn

/-- **P's order at an upper zero is the multiplicity** — the fiber peel
(each fiber factor is (w−s)·unit) against the analytic nonvanishing tail;
the exponent is the fiber count = the multiplicity
(`zetaSphereZero_fiber_ncard`). PROVED. -/
theorem zetaProd_orderAt_upper {s : ℂ} (hs : s ∈ zetaUpperZeros) :
    analyticOrderAt zetaProd s = (zetaZeroMult s : ℕ∞) := by
  have hsim : 0 < s.im := hs.2
  have hs0 : s ≠ 0 := by
    intro h
    rw [h] at hsim
    simp at hsim
  have hconj : s ≠ (starRingEnd ℂ) s := by
    intro h
    have h2 := congrArg Complex.im h
    rw [Complex.conj_im] at h2
    linarith
  have hfibfin := zetaSphereZero_fiber_finite s
  set t : Finset ℕ := hfibfin.toFinset with ht_def
  have hcard : t.card = zetaZeroMult s := by
    rw [ht_def, ← Set.ncard_eq_toFinset_card _ hfibfin]
    exact zetaSphereZero_fiber_ncard hs
  have hmem_t : ∀ n, n ∈ t ↔ zetaSphereZero n = s := fun n =>
    hfibfin.mem_toFinset
  -- the fiber peel at every point
  have hpeel : ∀ w : ℂ, (∏ n ∈ t, spherePrimary n (zetaSphereZero n) w)
      = (w - s) ^ t.card * ∏ n ∈ t, sphereUnit n s w := by
    intro w
    calc (∏ n ∈ t, spherePrimary n (zetaSphereZero n) w)
        = ∏ n ∈ t, ((w - s) * sphereUnit n s w) :=
          Finset.prod_congr rfl fun n hn => by
            rw [show zetaSphereZero n = s from (hmem_t n).mp hn]
            exact spherePrimary_eq_sub_mul_sphereUnit _ hs0 w
      _ = (∏ _n ∈ t, (w - s)) * ∏ n ∈ t, sphereUnit n s w :=
          Finset.prod_mul_distrib
      _ = (w - s) ^ t.card * ∏ n ∈ t, sphereUnit n s w := by
          rw [Finset.prod_const]
  -- the majorant ball at s, for the tail's analyticity
  obtain ⟨r, hr, u, hu, hbound⟩ := zetaC3_locMajorant_proved s
  have hupos : ∀ n, 0 ≤ u n := fun n =>
    le_trans (norm_nonneg _) (hbound n s (Metric.mem_ball_self hr))
  have hitem : ∀ n : ℕ, Differentiable ℂ fun w =>
      (if n ∈ t then (1 : ℂ) else spherePrimary n (zetaSphereZero n) w) := by
    intro n
    by_cases hn : n ∈ t
    · simp only [if_pos hn]
      exact differentiable_const 1
    · simp only [if_neg hn]
      exact differentiable_spherePrimary _ _
  have hTdiff : DifferentiableOn ℂ
      (fun w => ∏' n, (if n ∈ t then (1 : ℂ)
        else spherePrimary n (zetaSphereZero n) w))
      (Metric.ball s r) := by
    have htend : MultipliableLocallyUniformlyOn
        (fun n w => if n ∈ t then (1 : ℂ)
          else spherePrimary n (zetaSphereZero n) w)
        (Metric.ball s r) := by
      have h1 : MultipliableLocallyUniformlyOn
          (fun n w => 1 + ((if n ∈ t then (1 : ℂ)
            else spherePrimary n (zetaSphereZero n) w) - 1))
          (Metric.ball s r) :=
        Summable.multipliableLocallyUniformlyOn_nat_one_add Metric.isOpen_ball hu
          (Filter.Eventually.of_forall fun n w hw => by
            by_cases hn : n ∈ t
            · simpa [if_pos hn] using hupos n
            · rw [if_neg hn]
              exact hbound n w hw)
          (fun n => ((hitem n).sub_const 1).continuous.continuousOn)
      exact MultipliableLocallyUniformlyOn_congr (fun n w _ => by ring) h1
    have h2 := hasProdLocallyUniformlyOn_iff_tendstoLocallyUniformlyOn.mp
      htend.hasProdLocallyUniformlyOn
    exact h2.differentiableOn
      (Filter.Eventually.of_forall fun τ => fun w _ =>
        (DifferentiableAt.fun_finsetProd fun i _ =>
          (hitem i).differentiableAt).differentiableWithinAt)
      Metric.isOpen_ball
  -- the tail is nonzero at s
  have hTa : (∏' n, (if n ∈ t then (1 : ℂ)
      else spherePrimary n (zetaSphereZero n) s)) ≠ 0 := by
    refine tprod_ne_zero_of_norm_sub_one_le hu (fun n => ?_) (fun n => ?_)
    · by_cases hn : n ∈ t
      · simpa [if_pos hn] using hupos n
      · rw [if_neg hn]
        exact hbound n s (Metric.mem_ball_self hr)
    · by_cases hn : n ∈ t
      · rw [if_pos hn]
        exact one_ne_zero
      · rw [if_neg hn]
        have han : zetaSphereZero n ≠ 0 := by
          intro h
          have := zetaSphereZero_im_pos n
          rw [h] at this
          simp at this
        refine spherePrimary_ne_zero _ han (fun h => hn ?_) (fun h => ?_)
        · exact (hmem_t n).mpr h.symm
        · have h2 : s.im = -(zetaSphereZero n).im := by
            rw [h, Complex.conj_im]
          have := zetaSphereZero_im_pos n
          linarith
  -- assemble G
  have hζcast : analyticOrderAt zetaProd s = ((t.card : ℕ) : ℕ∞) → _ := id
  rw [show ((zetaZeroMult s : ℕ) : ℕ∞) = ((t.card : ℕ) : ℕ∞) by rw [hcard]]
  rw [(zetaProd_analyticAt s).analyticOrderAt_eq_natCast]
  refine ⟨fun w => (∏ n ∈ t, sphereUnit n s w) *
      ∏' n, (if n ∈ t then (1 : ℂ) else spherePrimary n (zetaSphereZero n) w),
    ?_, ?_, ?_⟩
  · -- analytic at s
    have hQ : AnalyticAt ℂ (fun w => ∏ n ∈ t, sphereUnit n s w) s := by
      have hd : DifferentiableOn ℂ (fun w => ∏ n ∈ t, sphereUnit n s w)
          (Metric.ball s r) := fun w _ =>
        (DifferentiableAt.fun_finsetProd fun i _ =>
          (differentiable_sphereUnit _ _).differentiableAt).differentiableWithinAt
      exact (hd.analyticOnNhd Metric.isOpen_ball) _ (Metric.mem_ball_self hr)
    have hTan : AnalyticAt ℂ
        (fun w => ∏' n, (if n ∈ t then (1 : ℂ)
          else spherePrimary n (zetaSphereZero n) w)) s :=
      (hTdiff.analyticOnNhd Metric.isOpen_ball) _ (Metric.mem_ball_self hr)
    exact hQ.mul hTan
  · -- nonzero at s
    have hQne : (∏ n ∈ t, sphereUnit n s s) ≠ 0 :=
      Finset.prod_ne_zero_iff.mpr fun n _ => sphereUnit_ne_zero _ hs0 hconj
    exact mul_ne_zero hQne hTa
  · -- the identity, everywhere
    refine Filter.Eventually.of_forall fun w => ?_
    rw [smul_eq_mul, zetaProd_split t w, hpeel w]
    ring

/-! ## STAGE B2b — ξ's order and the divisor match -/

/-- ξ is analytic everywhere. PROVED helper. -/
theorem xi_analyticAt (z : ℂ) : AnalyticAt ℂ xi z :=
  xi_entire.analyticAt z

/-- ζ's order is finite at every non-pole point (the ZetaDivisor
identity-theorem block, extracted). PROVED helper. -/
theorem riemannZeta_orderAt_ne_top {s : ℂ} (hs1 : s ≠ 1) :
    analyticOrderAt riemannZeta s ≠ ⊤ := by
  intro htop
  have hev := analyticOrderAt_eq_top.mp htop
  have hζ : AnalyticOnNhd ℂ riemannZeta ({(1 : ℂ)}ᶜ : Set ℂ) := fun z hz =>
    riemannZeta_analyticAt (Set.mem_compl_singleton_iff.mp hz)
  have h0 : AnalyticOnNhd ℂ (fun _ : ℂ => (0 : ℂ)) ({(1 : ℂ)}ᶜ : Set ℂ) :=
    fun _ _ => analyticAt_const
  have hUconn : IsPreconnected ({(1 : ℂ)}ᶜ : Set ℂ) := by
    refine (isConnected_compl_singleton_of_one_lt_rank ?_ 1).isPreconnected
    rw [← Module.finrank_eq_rank, Complex.finrank_real_complex]
    exact_mod_cast one_lt_two
  have hEq := hζ.eqOn_of_preconnected_of_eventuallyEq h0 hUconn
    (Set.mem_compl_singleton_iff.mpr hs1) hev
  exact riemannZeta_ne_zero_of_one_le_re (by norm_num)
    (hEq (by norm_num : (2 : ℂ) ∈ ({(1 : ℂ)}ᶜ : Set ℂ)))

/-- Γℝ is analytic on the right half-plane. PROVED helper. -/
theorem Gammaℝ_analyticAt_of_re_pos {s : ℂ} (hs : 0 < s.re) :
    AnalyticAt ℂ Gammaℝ s := by
  have hd : DifferentiableOn ℂ Gammaℝ {z : ℂ | 0 < z.re} := by
    intro z hz
    have hz' : (0 : ℝ) < z.re := hz
    have h1 : DifferentiableAt ℂ
        (fun w : ℂ => ((Real.pi : ℝ) : ℂ) ^ (-w / 2)) z := by
      have heq : (fun w : ℂ => ((Real.pi : ℝ) : ℂ) ^ (-w / 2))
          = fun w => Complex.exp (Complex.log ((Real.pi : ℝ) : ℂ) * (-w / 2)) := by
        funext w
        exact Complex.cpow_def_of_ne_zero
          (Complex.ofReal_ne_zero.mpr Real.pi_ne_zero) _
      rw [heq]
      fun_prop
    have h2 : DifferentiableAt ℂ (fun w : ℂ => Complex.Gamma (w / 2)) z := by
      have hpole : ∀ m : ℕ, z / 2 ≠ -(m : ℂ) := by
        intro m h
        have hz2 : z = -(m : ℂ) * 2 := by
          rw [← h]
          ring
        have hcast : -(m : ℂ) * 2 = ((-(m : ℝ) * 2 : ℝ) : ℂ) := by
          push_cast
          ring
        have hre : z.re = -(m : ℝ) * 2 := by
          rw [hz2, hcast, Complex.ofReal_re]
        have hm : (0 : ℝ) ≤ m := Nat.cast_nonneg m
        rw [hre] at hz'
        linarith
      exact (Complex.differentiableAt_Gamma _ hpole).comp z
        ((differentiable_id.div_const 2) z)
    have heqΓ : Gammaℝ = fun w : ℂ =>
        ((Real.pi : ℝ) : ℂ) ^ (-w / 2) * Complex.Gamma (w / 2) := by
      funext w
      rw [Gammaℝ]
    rw [heqΓ]
    exact (h1.mul h2).differentiableWithinAt
  exact (hd.analyticOnNhd (isOpen_lt continuous_const Complex.continuous_re))
    _ hs

/-- **ξ's order at an upper zero is the multiplicity**: near the zero,
ξ = [z(z−1)Γℝ]·ζ with the bracket analytic and nonvanishing — the orders
add, and the bracket contributes zero. PROVED. -/
theorem xi_orderAt_upper {s : ℂ} (hs : s ∈ zetaUpperZeros) :
    analyticOrderAt xi s = (zetaZeroMult s : ℕ∞) := by
  have hsim : 0 < s.im := hs.2
  obtain ⟨htriv, hone⟩ := nontrivial_of_im_ne_zero (ne_of_gt hsim)
  obtain ⟨hre0, _⟩ := nontrivialZero_re_mem_Ioo hs.1 htriv hone
  have hs0 : s ≠ 0 := by
    intro h
    rw [h] at hre0
    simp at hre0
  have hΓs : Gammaℝ s ≠ 0 := Gammaℝ_ne_zero_of_re_pos hre0
  have hΓan : AnalyticAt ℂ Gammaℝ s := Gammaℝ_analyticAt_of_re_pos hre0
  have hUan : AnalyticAt ℂ (fun z : ℂ => z * (z - 1) * Gammaℝ z) s :=
    ((analyticAt_id.mul (analyticAt_id.sub analyticAt_const)).mul hΓan)
  have hev : xi =ᶠ[nhds s] (fun z : ℂ => z * (z - 1) * Gammaℝ z) * riemannZeta := by
    have hopen : IsOpen (({(0 : ℂ)}ᶜ ∩ {(1 : ℂ)}ᶜ) : Set ℂ) :=
      isOpen_compl_singleton.inter isOpen_compl_singleton
    have hmem : s ∈ (({(0 : ℂ)}ᶜ ∩ {(1 : ℂ)}ᶜ) : Set ℂ) :=
      ⟨Set.mem_compl_singleton_iff.mpr hs0, Set.mem_compl_singleton_iff.mpr hone⟩
    filter_upwards [hopen.mem_nhds hmem,
      hΓan.continuousAt.eventually_ne hΓs] with z hzmem hzΓ
    have hz0 : z ≠ 0 := Set.mem_compl_singleton_iff.mp hzmem.1
    have hz1 : z ≠ 1 := Set.mem_compl_singleton_iff.mp hzmem.2
    rw [Pi.mul_apply, xi_eq hz0 hz1, riemannZeta_def_of_ne_zero hz0]
    field_simp
  rw [analyticOrderAt_congr hev,
    analyticOrderAt_mul hUan (riemannZeta_analyticAt hone)]
  have hU0 : analyticOrderAt (fun z : ℂ => z * (z - 1) * Gammaℝ z) s = 0 := by
    rw [analyticOrderAt_eq_zero]
    right
    exact mul_ne_zero (mul_ne_zero hs0 (sub_ne_zero.mpr hone)) hΓs
  rw [hU0, zero_add, zetaZeroMult, analyticOrderNatAt]
  exact (ENat.coe_toNat (riemannZeta_orderAt_ne_top hone)).symm

/-- **STAGE B COMPLETE — the divisor match**: ξ and P have identical
divisors at EVERY point of ℂ — the precise level-matching of the extension
move (author, 2026-07-05): the one stem's divisor (ξ) and the
enumeration's (P), equal order by order, the lower half folded up by
intrinsicality. PROVED. -/
theorem xi_orderAt_eq_zetaProd_orderAt (s : ℂ) :
    analyticOrderAt xi s = analyticOrderAt zetaProd s := by
  have hcore : ∀ w : ℂ, 0 ≤ w.im →
      analyticOrderAt xi w = analyticOrderAt zetaProd w := by
    intro w him
    by_cases hz : w ∈ zetaUpperZeros
    · rw [xi_orderAt_upper hz, zetaProd_orderAt_upper hz]
    · have hxine : xi w ≠ 0 := by
        intro h0
        have hmem : w ∈ {s : ℂ | xi s = 0} := h0
        rw [xi_zeros_eq_nontrivialZeros] at hmem
        obtain ⟨hz0, htriv, hone⟩ := hmem
        have him' := nontrivialZero_im_ne_zero hz0 htriv hone
        rcases lt_or_gt_of_ne him' with h | h
        · linarith
        · exact hz ⟨hz0, h⟩
      have hPne : zetaProd w ≠ 0 := by
        refine zetaProd_ne_zero (fun n hn => ?_) (fun n hn => ?_)
        · exact hz (by rw [hn]; exact zetaSphereZero_mem n)
        · have h1 := zetaSphereZero_im_pos n
          have h2 : w.im = -(zetaSphereZero n).im := by
            rw [hn, Complex.conj_im]
          linarith
      rw [analyticOrderAt_eq_zero.mpr (Or.inr hxine),
        analyticOrderAt_eq_zero.mpr (Or.inr hPne)]
  rcases le_or_gt 0 s.im with him | him
  · exact hcore s him
  · have hxi := xi_intrinsic.analyticOrderAt_conj xi_analyticAt
      ((starRingEnd ℂ) s)
    have hP := zetaProd_intrinsic.analyticOrderAt_conj zetaProd_analyticAt
      ((starRingEnd ℂ) s)
    rw [starRingEnd_self_apply] at hxi hP
    rw [hxi, hP]
    exact hcore _ (by rw [Complex.conj_im]; linarith)
