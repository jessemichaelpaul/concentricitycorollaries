/-
Concentricity/ZetaWeierstrass.lean

The Weierstrass package build, STAGE A (author "cleared for go time",
2026-07-05; the genus-per-zero amendment 2b045db): CONVERGENCE of the
genus-n canonical product over the divisor-repeated enumeration — the
`c3_multipliable` and `c3_locMajorant` conjuncts of `zetaC3_package`, as
standalone PROVED rows, Jensen-free:

- the elementary-factor tail bound ‖E_p(w) − 1‖ ≤ 4‖w‖^{p+1} on ‖w‖ ≤ 1/2
  (E_p = exp of the log-Taylor tail: `norm_log_sub_logTaylor_le` +
  `norm_exp_sub_one_le`);
- the pair bound ‖spherePrimary p a z − 1‖ ≤ 16(‖z‖/‖a‖)^{p+1};
- only finitely many enumerated zeros in any ball (the pinned
  `IsCompact.inter_riemannZetaZeros_finite` through the pairs
  enumeration) — so past the finite exceptional set the majorant is
  geometric.

Stage B (divisor/order matching against ξ) and stage C (assembly:
xi = e^g·P via the entire-log engine, then (z−1)ζ = Rfac·e^g·P by the
Γℝ-cancellation xi·Rfac = (z−1)ζ off {0,1}) follow; `zetaC3_package`
stays the ONE sorried leaf until stage C closes it.

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file targets ZERO
sorries.
-/
import Concentricity.ZetaDivisor
import Concentricity.StemFactorization

noncomputable section

open Complex

/-! ## The elementary-factor tail bound -/

/-- The log-Taylor collapse: `logTaylor (p+1) (−w)` is minus the partial
Weierstrass exponent. PROVED helper. -/
theorem logTaylor_neg_eq (p : ℕ) (w : ℂ) :
    Complex.logTaylor (p + 1) (-w)
      = -∑ k ∈ Finset.range p, w ^ (k + 1) / (k + 1) := by
  rw [Complex.logTaylor, Finset.sum_range_succ']
  have h0 : ((-1 : ℂ)) ^ (0 + 1) * (-w) ^ 0 / (0 : ℕ) = 0 := by
    norm_num
  rw [h0, add_zero, ← Finset.sum_neg_distrib]
  refine Finset.sum_congr rfl fun k _ => ?_
  have hpow : ((-1 : ℂ)) ^ (k + 1 + 1) * (-w) ^ (k + 1)
      = -(w ^ (k + 1)) := by
    rw [neg_pow w (k + 1)]
    ring_nf
    rw [show ((-1 : ℂ)) ^ (k * 2) = 1 from Even.neg_one_pow ⟨k, by ring⟩,
      mul_one]
  rw [hpow]
  push_cast
  ring

/-- The Weierstrass factor is the exponential of the log-Taylor tail on
the open unit disc. PROVED helper. -/
theorem weierstrassE_eq_exp_tail {p : ℕ} {w : ℂ} (hw : ‖w‖ < 1) :
    weierstrassE p w
      = Complex.exp (Complex.log (1 + -w) - Complex.logTaylor (p + 1) (-w)) := by
  have hne : 1 - w ≠ 0 := by
    intro h
    have : w = 1 := by linear_combination -h
    rw [this] at hw
    simp at hw
  rw [weierstrassE]
  have h1 : (1 : ℂ) - w = Complex.exp (Complex.log (1 - w)) :=
    (Complex.exp_log hne).symm
  rw [h1, ← Complex.exp_add, logTaylor_neg_eq, sub_neg_eq_add,
    show (1 : ℂ) + -w = 1 - w by ring]

/-- **The tail bound**: ‖E_p(w) − 1‖ ≤ 4‖w‖^{p+1} for ‖w‖ ≤ 1/2. PROVED. -/
theorem norm_weierstrassE_sub_one_le (p : ℕ) {w : ℂ} (hw : ‖w‖ ≤ 1 / 2) :
    ‖weierstrassE p w - 1‖ ≤ 4 * ‖w‖ ^ (p + 1) := by
  have hw1 : ‖w‖ < 1 := lt_of_le_of_lt hw (by norm_num)
  have hnw : ‖-w‖ < 1 := by rwa [norm_neg]
  have hT := Complex.norm_log_sub_logTaylor_le p hnw
  rw [norm_neg] at hT
  set T : ℂ := Complex.log (1 + -w) - Complex.logTaylor (p + 1) (-w) with hT_def
  have hTle : ‖T‖ ≤ 2 * ‖w‖ ^ (p + 1) := by
    refine le_trans hT ?_
    rw [div_le_iff₀ (by positivity : (0 : ℝ) < (p : ℝ) + 1)]
    have hinv : (1 - ‖w‖)⁻¹ ≤ 2 := by
      calc (1 - ‖w‖)⁻¹ = 1 / (1 - ‖w‖) := (one_div _).symm
        _ ≤ 1 / (1 / 2) := one_div_le_one_div_of_le (by norm_num) (by linarith)
        _ = 2 := by norm_num
    have hinv0 : (0 : ℝ) ≤ (1 - ‖w‖)⁻¹ := by
      have hpos : (0 : ℝ) < 1 - ‖w‖ := by linarith
      positivity
    have hp1 : (1 : ℝ) ≤ (p : ℝ) + 1 := by
      have := Nat.cast_nonneg (α := ℝ) p
      linarith
    have hwn : (0 : ℝ) ≤ ‖w‖ ^ (p + 1) := by positivity
    nlinarith
  have hT1 : ‖T‖ ≤ 1 := by
    have hgeo : ‖w‖ ^ (p + 1) ≤ (1 / 2 : ℝ) ^ (p + 1) :=
      pow_le_pow_left₀ (norm_nonneg w) hw _
    have hhalf : ((1 : ℝ) / 2) ^ (p + 1) ≤ 1 / 2 := by
      have h := pow_le_one₀ (by norm_num : (0:ℝ) ≤ 1/2)
        (by norm_num : (1/2:ℝ) ≤ 1) (n := p)
      rw [pow_succ]
      nlinarith
    linarith
  have hexp := Complex.norm_exp_sub_one_le hT1
  rw [weierstrassE_eq_exp_tail hw1, ← hT_def]
  calc ‖Complex.exp T - 1‖ ≤ 2 * ‖T‖ := hexp
    _ ≤ 2 * (2 * ‖w‖ ^ (p + 1)) := by linarith
    _ = 4 * ‖w‖ ^ (p + 1) := by ring

/-- **The pair bound**: for ‖z‖ ≤ ‖a‖/2 (a ≠ 0),
‖spherePrimary p a z − 1‖ ≤ 16·(‖z‖/‖a‖)^{p+1}. PROVED. -/
theorem norm_spherePrimary_sub_one_le (p : ℕ) {a z : ℂ} (ha : a ≠ 0)
    (hz : ‖z‖ ≤ ‖a‖ / 2) :
    ‖spherePrimary p a z - 1‖ ≤ 16 * (‖z‖ / ‖a‖) ^ (p + 1) := by
  have hapos : (0 : ℝ) < ‖a‖ := norm_pos_iff.mpr ha
  have hca : ‖(starRingEnd ℂ) a‖ = ‖a‖ := by
    rw [RCLike.norm_conj]
  have hq1 : ‖z / a‖ ≤ 1 / 2 := by
    rw [norm_div, div_le_div_iff₀ hapos (by norm_num : (0:ℝ) < 2)]
    linarith
  have hq2 : ‖z / (starRingEnd ℂ) a‖ ≤ 1 / 2 := by
    rw [norm_div, hca, div_le_div_iff₀ hapos (by norm_num : (0:ℝ) < 2)]
    linarith
  have hA := norm_weierstrassE_sub_one_le p hq1
  have hB := norm_weierstrassE_sub_one_le p hq2
  rw [norm_div] at hA
  rw [norm_div, hca] at hB
  set e : ℝ := 4 * (‖z‖ / ‖a‖) ^ (p + 1) with he_def
  have hepos : 0 ≤ e := by positivity
  have he1 : e ≤ 2 := by
    have hq : ‖z‖ / ‖a‖ ≤ 1 / 2 := by
      rw [div_le_div_iff₀ hapos (by norm_num : (0:ℝ) < 2)]
      linarith
    have h1 : (‖z‖ / ‖a‖) ^ (p + 1) ≤ (1 / 2 : ℝ) ^ (p + 1) :=
      pow_le_pow_left₀ (by positivity) hq _
    have h2 : ((1 : ℝ) / 2) ^ (p + 1) ≤ 1 / 2 := by
      have h := pow_le_one₀ (by norm_num : (0:ℝ) ≤ 1/2)
        (by norm_num : (1/2:ℝ) ≤ 1) (n := p)
      rw [pow_succ]
      nlinarith
    rw [he_def]
    nlinarith
  set A : ℂ := weierstrassE p (z / a) with hA_def
  set B : ℂ := weierstrassE p (z / (starRingEnd ℂ) a) with hB_def
  have hsplit : spherePrimary p a z - 1 = (A - 1) * (B - 1) + (A - 1) + (B - 1) := by
    rw [spherePrimary, hA_def, hB_def]
    ring
  rw [hsplit]
  calc ‖(A - 1) * (B - 1) + (A - 1) + (B - 1)‖
      ≤ ‖(A - 1) * (B - 1) + (A - 1)‖ + ‖B - 1‖ := norm_add_le _ _
    _ ≤ ‖(A - 1) * (B - 1)‖ + ‖A - 1‖ + ‖B - 1‖ := by
        have := norm_add_le ((A - 1) * (B - 1)) (A - 1)
        linarith
    _ = ‖A - 1‖ * ‖B - 1‖ + ‖A - 1‖ + ‖B - 1‖ := by rw [norm_mul]
    _ ≤ e * e + e + e := by
        have hAn : (0 : ℝ) ≤ ‖A - 1‖ := norm_nonneg _
        have hBn : (0 : ℝ) ≤ ‖B - 1‖ := norm_nonneg _
        have h1 : ‖A - 1‖ ≤ e := hA
        have h2 : ‖B - 1‖ ≤ e := hB
        nlinarith
    _ ≤ 4 * e := by nlinarith
    _ = 16 * (‖z‖ / ‖a‖) ^ (p + 1) := by rw [he_def]; ring

/-! ## Finiteness: the enumeration escapes every ball -/

/-- Only finitely many enumerated zeros lie in any ball — the pinned
discreteness through the divisor pairs. PROVED. -/
theorem zetaSphereZero_norm_lt_finite (R : ℝ) :
    {n : ℕ | ‖zetaSphereZero n‖ < R}.Finite := by
  have hT : {q : ℂ × ℕ | q ∈ zetaZeroPairs ∧ ‖q.1‖ < R}.Finite := by
    have hZ : {s : ℂ | s ∈ zetaUpperZeros ∧ ‖s‖ < R}.Finite := by
      refine Set.Finite.subset
        ((isCompact_closedBall (0 : ℂ) R).inter_riemannZetaZeros_finite) ?_
      intro s hs
      refine ⟨?_, ?_⟩
      · simpa [Metric.mem_closedBall, dist_zero_right] using hs.2.le
      · rw [mem_riemannZetaZeros]
        exact hs.1.1
    have hcover : {q : ℂ × ℕ | q ∈ zetaZeroPairs ∧ ‖q.1‖ < R}
        ⊆ ⋃ s ∈ {s : ℂ | s ∈ zetaUpperZeros ∧ ‖s‖ < R},
            ({s} : Set ℂ) ×ˢ (Set.Iio (zetaZeroMult s)) := by
      rintro ⟨s, k⟩ ⟨⟨hmem, hk⟩, hnorm⟩
      exact Set.mem_biUnion ⟨hmem, hnorm⟩
        (Set.mk_mem_prod rfl hk)
    exact (hZ.biUnion fun s _ =>
      ((Set.finite_singleton s).prod (Set.finite_Iio _))).subset hcover
  have himg : {n : ℕ | ‖zetaSphereZero n‖ < R}
      = (fun n => ((zetaZeroEnum n : ↥zetaZeroPairs) : ℂ × ℕ))
        ⁻¹' {q : ℂ × ℕ | q ∈ zetaZeroPairs ∧ ‖q.1‖ < R} := by
    ext n
    simp only [Set.mem_setOf_eq, Set.mem_preimage]
    exact ⟨fun h => ⟨(zetaZeroEnum n).2, h⟩, fun h => h.2⟩
  rw [himg]
  refine Set.Finite.preimage ?_ hT
  intro a _ b _ hab
  exact zetaZeroEnum.injective (Subtype.ext hab)

/-! ## The convergence rows (stage-A conjuncts of the package) -/

/-- The geometric-with-finite-exceptions majorant at radius R: past the
finitely many n with ‖qₙ‖ < 2R, the pair bound is ≤ 16·2^{−(n+1)}.
PROVED helper. -/
theorem zetaWeierstrass_bound_of_far {n : ℕ} {w : ℂ} {R : ℝ}
    (hR : 0 < R) (hw : ‖w‖ ≤ R) (hfar : 2 * R ≤ ‖zetaSphereZero n‖) :
    ‖spherePrimary n (zetaSphereZero n) w - 1‖ ≤ 16 * (1 / 2 : ℝ) ^ (n + 1) := by
  have ha : zetaSphereZero n ≠ 0 := by
    intro h
    have := zetaSphereZero_im_pos n
    rw [h] at this
    simp at this
  have hapos : (0 : ℝ) < ‖zetaSphereZero n‖ := by linarith
  have hle : ‖w‖ ≤ ‖zetaSphereZero n‖ / 2 := by linarith
  refine le_trans (norm_spherePrimary_sub_one_le n ha hle) ?_
  have hq : ‖w‖ / ‖zetaSphereZero n‖ ≤ 1 / 2 := by
    rw [div_le_div_iff₀ hapos (by norm_num : (0:ℝ) < 2)]
    linarith
  have := pow_le_pow_left₀
    (by positivity : (0:ℝ) ≤ ‖w‖ / ‖zetaSphereZero n‖) hq (n + 1)
  nlinarith [this]

/-- The geometric majorant is summable. PROVED helper. -/
theorem summable_geoBound : Summable fun n : ℕ => 16 * (1 / 2 : ℝ) ^ (n + 1) := by
  have h0 : Summable fun n : ℕ => (1 / 2 : ℝ) ^ n :=
    summable_geometric_of_lt_one (by norm_num) (by norm_num)
  refine (h0.mul_left (16 * (1 / 2))).congr fun n => ?_
  rw [pow_succ]
  ring

/-- **Stage A, row 1 — `c3_multipliable` PROVED**: the genus-n product over
the divisor-repeated enumeration converges at every point (geometric past
the finitely many enumerated zeros in the doubled ball). -/
theorem zetaC3_multipliable_proved (z : ℂ) :
    Multipliable fun n => spherePrimary n (zetaSphereZero n) z := by
  set R : ℝ := ‖z‖ + 1 with hR_def
  have hRpos : 0 < R := by rw [hR_def]; positivity
  have hbad := zetaSphereZero_norm_lt_finite (2 * R)
  have hsum : Summable fun n => spherePrimary n (zetaSphereZero n) z - 1 := by
    refine Summable.of_norm_bounded_eventually summable_geoBound ?_
    filter_upwards [hbad.eventually_cofinite_notMem] with n hn
    exact zetaWeierstrass_bound_of_far hRpos
      (by rw [hR_def]; linarith [norm_nonneg z])
      (not_lt.mp hn)
  exact (Complex.multipliable_one_add_of_summable hsum).congr fun n => by ring

/-- **Stage A, row 2 — `c3_locMajorant` PROVED** (stated with no pole
hypothesis; the package conjunct follows a fortiori): on the unit ball
about any point, the product has a summable majorant — sup-bounds on the
finitely many near zeros (compactness), geometric past them. -/
theorem zetaC3_locMajorant_proved (z : ℂ) :
    ∃ r > 0, ∃ u : ℕ → ℝ, Summable u ∧
      ∀ n, ∀ w ∈ Metric.ball z r,
        ‖spherePrimary n (zetaSphereZero n) w - 1‖ ≤ u n := by
  set R : ℝ := ‖z‖ + 1 with hR_def
  have hRpos : 0 < R := by rw [hR_def]; positivity
  have hbad := zetaSphereZero_norm_lt_finite (2 * R)
  have hCex : ∀ n : ℕ, ∃ C : ℝ, ∀ w ∈ Metric.closedBall z 1,
      ‖spherePrimary n (zetaSphereZero n) w - 1‖ ≤ C := fun n =>
    (isCompact_closedBall z 1).exists_bound_of_continuousOn
      (((differentiable_spherePrimary n _).sub_const 1).continuous.continuousOn)
  refine ⟨1, one_pos, fun n =>
    if n ∈ hbad.toFinset then (hCex n).choose
    else 16 * (1 / 2 : ℝ) ^ (n + 1), ?_, ?_⟩
  · have hdiff : Summable fun n : ℕ =>
        (if n ∈ hbad.toFinset then (hCex n).choose
          else 16 * (1 / 2 : ℝ) ^ (n + 1)) - 16 * (1 / 2 : ℝ) ^ (n + 1) := by
      refine summable_of_ne_finset_zero (s := hbad.toFinset) fun n hn => ?_
      rw [if_neg hn, sub_self]
    refine (summable_geoBound.add hdiff).congr fun n => ?_
    ring
  · intro n w hw
    beta_reduce
    have hw1 : w ∈ Metric.closedBall z 1 :=
      Metric.ball_subset_closedBall hw
    by_cases hn : n ∈ hbad.toFinset
    · rw [if_pos hn]
      exact (hCex n).choose_spec w hw1
    · rw [if_neg hn]
      have hfar : 2 * R ≤ ‖zetaSphereZero n‖ := by
        have := Set.Finite.mem_toFinset hbad |>.not.mp hn
        simpa [not_lt] using this
      have hwR : ‖w‖ ≤ R := by
        have h1 : dist w z ≤ 1 := Metric.mem_closedBall.mp hw1
        have h2 : ‖w‖ - ‖z‖ ≤ ‖w - z‖ := norm_sub_norm_le w z
        rw [dist_eq_norm] at h1
        rw [hR_def]
        linarith
      exact zetaWeierstrass_bound_of_far hRpos hwR hfar
