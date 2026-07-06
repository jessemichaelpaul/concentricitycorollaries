/-
Concentricity/ZetaDensityCore.lean

Brick-2 runway item (1) (author "Execute!", 2026-07-06): ζ's QUADRATIC
POINT-DENSITY — the discharge of `c3_atN` (C3 THROUGH N) for the ζ member:

    Summable (fun k => 1 / (1 + ‖zetaSphereZero k‖ ^ 2)).

Route (all pinned/in-repo): Jensen's inequality in ready divisor form
(`AnalyticOnNhd.sum_divisor_le`) applied to ξ on balls — ξ(0) = 1
normalizes the formula and the in-repo growth bound `xi_growth` gives
log M(T) ≲ T·log T (order one, amply subquadratic); the stage-B divisor
bridge (`xi_orderAt_upper` + the pairs injection) turns the enumeration's
ball-counts into ξ-divisor sums; the dyadic-shell comparison closes
through `summable_of_sum_range_le`.

Jensen + growth is ζ's member-private ROUTE to the fact; the fact itself
is C3's own convergence clause through N (`ASection.c3_atN`, author's
register 2026-07-06). This file sits BELOW ZetaSection so the instance
can consume `zetaSphereZero_density`; the D0 payoff row lives in
ZetaDensity.lean.

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file carries ZERO
sorries.
-/
import Concentricity.ZetaXiMatch
import Mathlib.Analysis.Complex.JensenFormula
import Mathlib.Data.Set.Card.Arithmetic

noncomputable section

open Complex

/-! ## Milestone (i): the Jensen counting bound -/

/-- The upper zeros in a ball, as a finite set. PROVED helper. -/
theorem zetaUpperZeros_ball_finite (T : ℝ) :
    {s : ℂ | s ∈ zetaUpperZeros ∧ ‖s‖ < T}.Finite := by
  refine Set.Finite.subset
    ((isCompact_closedBall (0 : ℂ) T).inter_riemannZetaZeros_finite) ?_
  intro s hs
  refine ⟨?_, ?_⟩
  · simpa [Metric.mem_closedBall, dist_zero_right] using hs.2.le
  · rw [mem_riemannZetaZeros]
    exact hs.1.1

/-- The enumeration's ball-count is at most the summed multiplicities of
the upper zeros in the ball (the pairs injection + the union bound).
PROVED. -/
theorem zetaEnum_count_le_sum_mult (T : ℝ) :
    ({k : ℕ | ‖zetaSphereZero k‖ < T}.ncard : ℝ)
      ≤ ∑ ρ ∈ (zetaUpperZeros_ball_finite T).toFinset,
          (zetaZeroMult ρ : ℝ) := by
  classical
  set φ : ℕ → ℂ × ℕ := fun n => ((zetaZeroEnum n : ↥zetaZeroPairs) : ℂ × ℕ)
    with hφ_def
  have hφinj : Function.Injective φ := fun a b hab =>
    zetaZeroEnum.injective (Subtype.ext hab)
  have himg : φ '' {k : ℕ | ‖zetaSphereZero k‖ < T}
      ⊆ ⋃ ρ ∈ (zetaUpperZeros_ball_finite T).toFinset,
          ({ρ} : Set ℂ) ×ˢ Set.Iio (zetaZeroMult ρ) := by
    rintro ⟨v, i⟩ ⟨k, hk, hφk⟩
    rw [← hφk]
    have hnorm : ‖zetaSphereZero k‖ < T := hk
    have hmem : φ k ∈ zetaZeroPairs := (zetaZeroEnum k).2
    refine Set.mem_biUnion ?_ (Set.mem_prod.mpr ⟨rfl, hmem.2⟩)
    rw [Finset.mem_coe, Set.Finite.mem_toFinset]
    exact ⟨hmem.1, hnorm⟩
  have h1 : ({k : ℕ | ‖zetaSphereZero k‖ < T}.ncard : ℝ)
      = ((φ '' {k : ℕ | ‖zetaSphereZero k‖ < T}).ncard : ℝ) := by
    rw [Set.ncard_image_of_injective _ hφinj]
  rw [h1]
  have h2 : (φ '' {k : ℕ | ‖zetaSphereZero k‖ < T}).ncard
      ≤ ∑ ρ ∈ (zetaUpperZeros_ball_finite T).toFinset,
          (({ρ} : Set ℂ) ×ˢ Set.Iio (zetaZeroMult ρ)).ncard := by
    refine le_trans (Set.ncard_le_ncard himg ?_) (Finset.set_ncard_biUnion_le _ _)
    exact Set.Finite.biUnion (Set.finite_mem_finset _) fun ρ _ =>
      (Set.finite_singleton ρ).prod (Set.finite_Iio _)
  calc ((φ '' {k : ℕ | ‖zetaSphereZero k‖ < T}).ncard : ℝ)
      ≤ ((∑ ρ ∈ (zetaUpperZeros_ball_finite T).toFinset,
          (({ρ} : Set ℂ) ×ˢ Set.Iio (zetaZeroMult ρ)).ncard : ℕ) : ℝ) :=
        Nat.cast_le.mpr h2
    _ = ∑ ρ ∈ (zetaUpperZeros_ball_finite T).toFinset,
          ((({ρ} : Set ℂ) ×ˢ Set.Iio (zetaZeroMult ρ)).ncard : ℝ) := by
        push_cast
        rfl
    _ = ∑ ρ ∈ (zetaUpperZeros_ball_finite T).toFinset, (zetaZeroMult ρ : ℝ) := ?_
  refine Finset.sum_congr rfl fun ρ _ => ?_
  have h3 : (({ρ} : Set ℂ) ×ˢ Set.Iio (zetaZeroMult ρ)).ncard
      = zetaZeroMult ρ := by
    rw [show ({ρ} : Set ℂ) ×ˢ Set.Iio (zetaZeroMult ρ)
        = (fun i => (ρ, i)) '' Set.Iio (zetaZeroMult ρ) by
      ext ⟨v, i⟩
      simp [Set.mem_prod, eq_comm, and_comm],
      Set.ncard_image_of_injective _
        (fun a b hab => (Prod.mk.injEq _ _ _ _).mp hab |>.2),
      show Set.Iio (zetaZeroMult ρ) = ↑(Finset.range (zetaZeroMult ρ)) by
        rw [Finset.coe_range],
      Set.ncard_coe_finset, Finset.card_range]
  rw [h3]

/-- The multiplicity sum over ball zeros is at most the ξ-divisor's total
over the closed ball (divisor values are the multiplicities at the ball
zeros, by the stage-B order match, and nonnegative everywhere since ξ is
analytic). PROVED. -/
theorem sum_mult_le_finsum_divisor (T : ℝ) :
    (∑ ρ ∈ (zetaUpperZeros_ball_finite T).toFinset, (zetaZeroMult ρ : ℤ))
      ≤ ∑ᶠ u, MeromorphicOn.divisor xi (Metric.closedBall 0 |T|) u := by
  classical
  have hxa : AnalyticOnNhd ℂ xi (Metric.closedBall (0 : ℂ) |T|) :=
    fun z _ => xi_analyticAt z
  have hsupp : (MeromorphicOn.divisor xi
      (Metric.closedBall 0 |T|)).support.Finite :=
    (MeromorphicOn.divisor xi _).finiteSupport (isCompact_closedBall _ _)
  have hval : ∀ ρ ∈ (zetaUpperZeros_ball_finite T).toFinset,
      MeromorphicOn.divisor xi (Metric.closedBall 0 |T|) ρ
        = (zetaZeroMult ρ : ℤ) := by
    intro ρ hρ
    rw [Set.Finite.mem_toFinset] at hρ
    have hmem : ρ ∈ Metric.closedBall (0 : ℂ) |T| := by
      rw [Metric.mem_closedBall, dist_zero_right]
      exact hρ.2.le.trans (le_abs_self T)
    rw [MeromorphicOn.AnalyticOnNhd.divisor_apply hxa hmem, xi_orderAt_upper hρ.1]
    rfl
  have hnn : ∀ u ∈ hsupp.toFinset,
      0 ≤ MeromorphicOn.divisor xi (Metric.closedBall 0 |T|) u := by
    intro u hu
    rw [Set.Finite.mem_toFinset] at hu
    have humem : u ∈ Metric.closedBall (0 : ℂ) |T| :=
      (MeromorphicOn.divisor xi _).supportWithinDomain hu
    rw [MeromorphicOn.AnalyticOnNhd.divisor_apply hxa humem]
    cases h : analyticOrderAt xi u with
    | top => simp
    | coe n => simp
  rw [finsum_eq_finset_sum_of_support_subset _
    (by rw [Set.Finite.coe_toFinset] : Function.support
      (MeromorphicOn.divisor xi (Metric.closedBall 0 |T|))
      ⊆ ↑hsupp.toFinset)]
  have hsub : (zetaUpperZeros_ball_finite T).toFinset ⊆ hsupp.toFinset := by
    intro ρ hρ
    have h1 := hval ρ hρ
    rw [Set.Finite.mem_toFinset] at hρ ⊢
    rw [Function.mem_support, h1]
    have hpos := zetaZeroMult_pos hρ.1
    exact_mod_cast hpos.ne'
  calc (∑ ρ ∈ (zetaUpperZeros_ball_finite T).toFinset, (zetaZeroMult ρ : ℤ))
      = ∑ ρ ∈ (zetaUpperZeros_ball_finite T).toFinset,
          MeromorphicOn.divisor xi (Metric.closedBall 0 |T|) ρ :=
        (Finset.sum_congr rfl hval).symm
    _ ≤ ∑ u ∈ hsupp.toFinset,
          MeromorphicOn.divisor xi (Metric.closedBall 0 |T|) u :=
        Finset.sum_le_sum_of_subset_of_nonneg hsub fun u hu _ => hnn u hu

/-- **The Jensen count** (`AnalyticOnNhd.sum_divisor_le` on ξ, r := T,
R := 2T; ξ(0) = 1 normalizes): the enumeration's ball-count at radius
T ≥ 1 is at most log M(2T) / log 2 with M the growth-bound value. PROVED. -/
theorem zetaEnum_count_le {C₁ : ℝ} (hC₁ : 1 ≤ C₁)
    (hgrow : ∀ s : ℂ, ‖xi s‖ ≤ C₁ * Real.exp (C₁ * (‖s‖ + 2) * Real.log (‖s‖ + 2)))
    {T : ℝ} (hT : 1 ≤ T) :
    ({k : ℕ | ‖zetaSphereZero k‖ < T}.ncard : ℝ)
      ≤ (Real.log C₁ + C₁ * (2 * T + 2) * Real.log (2 * T + 2)) / Real.log 2 := by
  have hTpos : (0 : ℝ) < T := by linarith
  set M : ℝ := C₁ * Real.exp (C₁ * (2 * T + 2) * Real.log (2 * T + 2)) with hM_def
  have hM1 : 1 ≤ M := by
    rw [hM_def]
    have hexp : (1 : ℝ) ≤ Real.exp (C₁ * (2 * T + 2) * Real.log (2 * T + 2)) := by
      rw [← Real.exp_zero]
      apply Real.exp_le_exp.mpr
      have hlog : 0 ≤ Real.log (2 * T + 2) :=
        Real.log_nonneg (by linarith)
      positivity
    nlinarith
  have hjensen := AnalyticOnNhd.sum_divisor_le (c := (0 : ℂ)) (r := T)
    (R := 2 * T) (M := M) (f := xi)
    (by rw [abs_of_pos hTpos]; exact hTpos)
    (by rw [abs_of_pos hTpos, abs_of_pos (by linarith : (0:ℝ) < 2*T)]; linarith)
    hM1
    (fun z _ => xi_analyticAt z)
    (by rw [xi_zero]; exact one_ne_zero)
    ?_
  · have hchain := le_trans
      (by exact_mod_cast sum_mult_le_finsum_divisor T :
        ((∑ ρ ∈ (zetaUpperZeros_ball_finite T).toFinset,
          (zetaZeroMult ρ : ℤ)) : ℝ)
        ≤ ((∑ᶠ u, MeromorphicOn.divisor xi (Metric.closedBall 0 |T|) u : ℤ) : ℝ))
      hjensen
    have hcount := zetaEnum_count_le_sum_mult T
    have hnorm : ‖xi 0‖ = 1 := by rw [xi_zero, norm_one]
    rw [hnorm, div_one] at hchain
    have hratio : Real.log (2 * T / T) = Real.log 2 := by
      rw [show 2 * T / T = 2 by field_simp]
    rw [hratio] at hchain
    have hMlog : Real.log M
        = Real.log C₁ + C₁ * (2 * T + 2) * Real.log (2 * T + 2) := by
      rw [hM_def, Real.log_mul (by linarith) (Real.exp_ne_zero _),
        Real.log_exp]
    rw [hMlog] at hchain
    calc ({k : ℕ | ‖zetaSphereZero k‖ < T}.ncard : ℝ)
        ≤ ∑ ρ ∈ (zetaUpperZeros_ball_finite T).toFinset,
            (zetaZeroMult ρ : ℝ) := hcount
      _ = ((∑ ρ ∈ (zetaUpperZeros_ball_finite T).toFinset,
            (zetaZeroMult ρ : ℤ)) : ℝ) := by push_cast; rfl
      _ ≤ _ := hchain
  · intro z hz
    have hznorm : ‖z‖ = |2 * T| := by
      have := mem_sphere_zero_iff_norm.mp hz
      exact this
    rw [abs_of_pos (by linarith : (0:ℝ) < 2 * T)] at hznorm
    calc ‖xi z‖ ≤ C₁ * Real.exp (C₁ * (‖z‖ + 2) * Real.log (‖z‖ + 2)) := hgrow z
      _ = M := by rw [hM_def, hznorm]


/-! ## Milestone (ii): the dyadic-shell comparison and the density -/

/-- The shell index of an enumerated zero: j with 2^j ≤ ⌊‖qₖ‖⌋+1 < 2^(j+1). -/
noncomputable def zetaShellIdx (k : ℕ) : ℕ :=
  Nat.log 2 (⌊‖zetaSphereZero k‖⌋₊ + 1)

/-- Shell bounds: the norm sits inside its dyadic shell. PROVED helper. -/
theorem zetaShellIdx_bounds (k : ℕ) :
    (2 : ℝ) ^ zetaShellIdx k - 1 ≤ ‖zetaSphereZero k‖ ∧
      ‖zetaSphereZero k‖ < 2 ^ (zetaShellIdx k + 1) := by
  set m : ℕ := ⌊‖zetaSphereZero k‖⌋₊ + 1 with hm_def
  have hlow : (2 : ℕ) ^ zetaShellIdx k ≤ m :=
    Nat.pow_log_le_self 2 (by omega)
  have hhigh : m < (2 : ℕ) ^ (zetaShellIdx k + 1) :=
    Nat.lt_pow_succ_log_self (by norm_num) m
  constructor
  · have h1 : (m : ℝ) ≤ ‖zetaSphereZero k‖ + 1 := by
      rw [hm_def]
      push_cast
      have := Nat.floor_le (norm_nonneg (zetaSphereZero k))
      linarith
    have h2 : ((2 : ℝ)) ^ zetaShellIdx k ≤ (m : ℝ) := by
      exact_mod_cast hlow
    linarith
  · have h1 : ‖zetaSphereZero k‖ < (m : ℝ) := by
      rw [hm_def]
      push_cast
      exact Nat.lt_floor_add_one _
    have h2 : (m : ℝ) < (2 : ℝ) ^ (zetaShellIdx k + 1) := by
      exact_mod_cast hhigh
    linarith

/-- Term bound on a shell: 1/(1+‖qₖ‖²) ≤ 4/4^j. PROVED helper. -/
theorem zeta_term_le_shell (k : ℕ) :
    1 / (1 + ‖zetaSphereZero k‖ ^ 2) ≤ 4 / (4 : ℝ) ^ zetaShellIdx k := by
  have hlow := (zetaShellIdx_bounds k).1
  have hnn := norm_nonneg (zetaSphereZero k)
  have hpow : (4 : ℝ) ^ zetaShellIdx k = ((2 : ℝ) ^ zetaShellIdx k) ^ 2 := by
    rw [show (4 : ℝ) = 2 ^ 2 by norm_num, ← pow_mul, ← pow_mul, mul_comm]
  have h2j : (0 : ℝ) < 2 ^ zetaShellIdx k := by positivity
  rw [div_le_div_iff₀ (by positivity) (by positivity), hpow]
  nlinarith [mul_nonneg
      (by linarith : (0:ℝ) ≤ ‖zetaSphereZero k‖ + 1 - 2 ^ zetaShellIdx k)
      (by positivity : (0:ℝ) ≤ ‖zetaSphereZero k‖ + 1 + 2 ^ zetaShellIdx k),
    sq_nonneg (‖zetaSphereZero k‖ - 1)]

/-- The shell fiber injects into the dyadic ball. PROVED helper. -/
theorem zeta_shell_card_le (n j : ℕ) :
    ((((Finset.range n).filter fun k => zetaShellIdx k = j)).card : ℝ)
      ≤ ({k : ℕ | ‖zetaSphereZero k‖ < 2 ^ (j + 1)}.ncard : ℝ) := by
  have hsub : ((((Finset.range n).filter fun k => zetaShellIdx k = j)) : Set ℕ)
      ⊆ {k : ℕ | ‖zetaSphereZero k‖ < 2 ^ (j + 1)} := by
    intro k hk
    rw [Finset.mem_coe, Finset.mem_filter] at hk
    have h1 := (zetaShellIdx_bounds k).2
    rw [hk.2] at h1
    exact h1
  have hcard := Set.ncard_le_ncard hsub (zetaSphereZero_norm_lt_finite _)
  rw [Set.ncard_coe_finset] at hcard
  exact_mod_cast hcard

/-- The dyadic ball count, in summable-friendly form:
N_j ≤ log C₁/log 2 + 8C₁(j+3)·2^j. PROVED. -/
theorem zeta_shell_count_bound {C₁ : ℝ} (hC₁ : 1 ≤ C₁)
    (hgrow : ∀ s : ℂ, ‖xi s‖ ≤ C₁ * Real.exp (C₁ * (‖s‖ + 2) * Real.log (‖s‖ + 2)))
    (j : ℕ) :
    ({k : ℕ | ‖zetaSphereZero k‖ < 2 ^ (j + 1)}.ncard : ℝ)
      ≤ Real.log C₁ / Real.log 2 + 8 * C₁ * ((j : ℝ) + 3) * 2 ^ j := by
  have h2j1 : (1 : ℝ) ≤ 2 ^ (j + 1) := one_le_pow₀ (by norm_num)
  have h2j : (1 : ℝ) ≤ (2 : ℝ) ^ j := one_le_pow₀ (by norm_num)
  refine le_trans (zetaEnum_count_le hC₁ hgrow h2j1) ?_
  have hlog2 : (0 : ℝ) < Real.log 2 := Real.log_pos one_lt_two
  have harg : 2 * (2 : ℝ) ^ (j + 1) + 2 ≤ 2 ^ (j + 3) := by
    rw [show (2 : ℝ) ^ (j + 3) = 8 * 2 ^ j by rw [pow_add]; ring,
      show 2 * (2 : ℝ) ^ (j + 1) + 2 = 4 * 2 ^ j + 2 by rw [pow_add]; ring]
    nlinarith
  have hargpos : (1 : ℝ) ≤ 2 * (2 : ℝ) ^ (j + 1) + 2 := by nlinarith
  have hlogarg : Real.log (2 * (2 : ℝ) ^ (j + 1) + 2)
      ≤ ((j : ℝ) + 3) * Real.log 2 := by
    calc Real.log (2 * (2 : ℝ) ^ (j + 1) + 2) ≤ Real.log ((2 : ℝ) ^ (j + 3)) :=
          Real.log_le_log (by linarith) harg
      _ = ((j : ℝ) + 3) * Real.log 2 := by
          rw [Real.log_pow]
          push_cast
          ring
  have hsplit : (Real.log C₁ + C₁ * (2 * 2 ^ (j + 1) + 2)
        * Real.log (2 * 2 ^ (j + 1) + 2)) / Real.log 2
      = Real.log C₁ / Real.log 2
        + C₁ * (2 * 2 ^ (j + 1) + 2) * Real.log (2 * 2 ^ (j + 1) + 2)
          / Real.log 2 := by
    ring
  rw [hsplit]
  have h2nd : C₁ * (2 * 2 ^ (j + 1) + 2) * Real.log (2 * 2 ^ (j + 1) + 2)
        / Real.log 2
      ≤ 8 * C₁ * ((j : ℝ) + 3) * 2 ^ j := by
    rw [div_le_iff₀ hlog2]
    have hlogpos : 0 ≤ Real.log (2 * 2 ^ (j + 1) + 2) :=
      Real.log_nonneg hargpos
    have hC₁0 : (0 : ℝ) ≤ C₁ := by linarith
    calc C₁ * (2 * 2 ^ (j + 1) + 2) * Real.log (2 * 2 ^ (j + 1) + 2)
        ≤ C₁ * 2 ^ (j + 3) * (((j : ℝ) + 3) * Real.log 2) := by
          refine mul_le_mul (mul_le_mul_of_nonneg_left harg hC₁0) hlogarg
            hlogpos (by positivity)
      _ = 8 * C₁ * ((j : ℝ) + 3) * 2 ^ j * Real.log 2 := by
          rw [show (2 : ℝ) ^ (j + 3) = 8 * 2 ^ j by rw [pow_add]; ring]
          ring
  linarith

/-- The shell majorant series is summable (geometric with a polynomial
factor). PROVED helper. -/
theorem summable_shellBound (D E : ℝ) :
    Summable (fun j : ℕ =>
      (D + E * ((j : ℝ) + 3) * 2 ^ j) * (4 / (4 : ℝ) ^ j)) := by
  have hgeo4 : Summable (fun j : ℕ => (1 / 4 : ℝ) ^ j) :=
    summable_geometric_of_lt_one (by norm_num) (by norm_num)
  have hgeo2 : Summable (fun j : ℕ => (1 / 2 : ℝ) ^ j) :=
    summable_geometric_of_lt_one (by norm_num) (by norm_num)
  have hpoly : Summable (fun j : ℕ => (j : ℝ) * (1 / 2 : ℝ) ^ j) := by
    have h := summable_pow_mul_geometric_of_norm_lt_one (R := ℝ) 1
      (r := 1 / 2) (by rw [Real.norm_eq_abs]; norm_num)
    refine h.congr fun j => ?_
    rw [pow_one]
  have hsum : Summable (fun j : ℕ =>
      4 * D * (1 / 4 : ℝ) ^ j
        + (4 * E * ((j : ℝ) * (1 / 2 : ℝ) ^ j) + 12 * E * (1 / 2 : ℝ) ^ j)) :=
    (hgeo4.mul_left _).add ((hpoly.mul_left _).add (hgeo2.mul_left _))
  refine hsum.congr fun j => ?_
  have h1 : (1 / 4 : ℝ) ^ j = ((4 : ℝ) ^ j)⁻¹ := by
    rw [one_div, inv_pow]
  have h2 : (1 / 2 : ℝ) ^ j = ((2 : ℝ) ^ j)⁻¹ := by
    rw [one_div, inv_pow]
  have h3 : (4 : ℝ) ^ j = 2 ^ j * 2 ^ j := by
    rw [show (4 : ℝ) = 2 * 2 by norm_num, mul_pow]
  have h20 : (2 : ℝ) ^ j ≠ 0 := by positivity
  rw [h1, h2, h3]
  field_simp
  ring

/-- **ζ's QUADRATIC POINT-DENSITY** — Brick-2 runway item (1), the D0
summability obligation's remaining goal, closed for the ζ member: Jensen's
counting bound + the dyadic-shell comparison. PROVED. -/
theorem zetaSphereZero_density :
    Summable fun k => 1 / (1 + ‖zetaSphereZero k‖ ^ 2) := by
  obtain ⟨C, hCpos, hgrowC⟩ := xi_growth
  set C₁ : ℝ := max C 1 with hC₁_def
  have hC₁ : 1 ≤ C₁ := le_max_right _ _
  have hgrow : ∀ s : ℂ, ‖xi s‖
      ≤ C₁ * Real.exp (C₁ * (‖s‖ + 2) * Real.log (‖s‖ + 2)) := by
    intro s
    have hXnn : (0 : ℝ) ≤ (‖s‖ + 2) * Real.log (‖s‖ + 2) := by
      have h1 : (1 : ℝ) ≤ ‖s‖ + 2 := by linarith [norm_nonneg s]
      have h2 := Real.log_nonneg h1
      positivity
    have hCC₁ : C ≤ C₁ := le_max_left _ _
    have hexp : Real.exp (C * (‖s‖ + 2) * Real.log (‖s‖ + 2))
        ≤ Real.exp (C₁ * (‖s‖ + 2) * Real.log (‖s‖ + 2)) := by
      apply Real.exp_le_exp.mpr
      have h1 : C * (‖s‖ + 2) * Real.log (‖s‖ + 2)
          = C * ((‖s‖ + 2) * Real.log (‖s‖ + 2)) := by ring
      have h2 : C₁ * (‖s‖ + 2) * Real.log (‖s‖ + 2)
          = C₁ * ((‖s‖ + 2) * Real.log (‖s‖ + 2)) := by ring
      rw [h1, h2]
      nlinarith
    refine le_trans (hgrowC s) ?_
    have hep := Real.exp_pos (C * (‖s‖ + 2) * Real.log (‖s‖ + 2))
    have hep2 := Real.exp_pos (C₁ * (‖s‖ + 2) * Real.log (‖s‖ + 2))
    nlinarith
  set D : ℝ := Real.log C₁ / Real.log 2 with hD_def
  set E : ℝ := 8 * C₁ with hE_def
  have hDnn : 0 ≤ D :=
    div_nonneg (Real.log_nonneg hC₁) (Real.log_pos one_lt_two).le
  have hEnn : 0 ≤ E := by rw [hE_def]; linarith
  set g : ℕ → ℝ := fun j =>
    (D + E * ((j : ℝ) + 3) * 2 ^ j) * (4 / (4 : ℝ) ^ j) with hg_def
  have hgnn : ∀ j, 0 ≤ g j := by
    intro j
    rw [hg_def]
    have h1 : (0 : ℝ) ≤ (j : ℝ) + 3 := by positivity
    have h2 : (0 : ℝ) ≤ (2 : ℝ) ^ j := by positivity
    have h3 : (0 : ℝ) ≤ 4 / (4 : ℝ) ^ j := by positivity
    have h4 : 0 ≤ D + E * ((j : ℝ) + 3) * 2 ^ j := by
      have h5 := mul_nonneg (mul_nonneg hEnn h1) h2
      linarith
    exact mul_nonneg h4 h3
  have hg : Summable g := summable_shellBound D E
  refine summable_of_sum_range_le (c := ∑' j, g j) (fun k => by positivity) fun n => ?_
  set J : ℕ := ((Finset.range n).sup zetaShellIdx) + 1 with hJ_def
  have hmaps : ∀ k ∈ Finset.range n, zetaShellIdx k ∈ Finset.range J :=
    fun k hk => Finset.mem_range.mpr (Nat.lt_succ_of_le (Finset.le_sup hk))
  calc ∑ k ∈ Finset.range n, 1 / (1 + ‖zetaSphereZero k‖ ^ 2)
      = ∑ j ∈ Finset.range J, ∑ k ∈ (Finset.range n).filter
          (fun k => zetaShellIdx k = j), 1 / (1 + ‖zetaSphereZero k‖ ^ 2) :=
        (Finset.sum_fiberwise_of_maps_to hmaps _).symm
    _ ≤ ∑ j ∈ Finset.range J, g j := by
        refine Finset.sum_le_sum fun j _ => ?_
        calc ∑ k ∈ (Finset.range n).filter (fun k => zetaShellIdx k = j),
              1 / (1 + ‖zetaSphereZero k‖ ^ 2)
            ≤ ∑ _k ∈ (Finset.range n).filter (fun k => zetaShellIdx k = j),
              4 / (4 : ℝ) ^ j := by
              refine Finset.sum_le_sum fun k hk => ?_
              have h1 := zeta_term_le_shell k
              rw [(Finset.mem_filter.mp hk).2] at h1
              exact h1
          _ = ((((Finset.range n).filter
                (fun k => zetaShellIdx k = j)).card : ℝ))
              * (4 / (4 : ℝ) ^ j) := by
              rw [Finset.sum_const, nsmul_eq_mul]
          _ ≤ (D + E * ((j : ℝ) + 3) * 2 ^ j) * (4 / (4 : ℝ) ^ j) := by
              refine mul_le_mul_of_nonneg_right ?_ (by positivity)
              exact le_trans (zeta_shell_card_le n j)
                (zeta_shell_count_bound hC₁ hgrow j)
          _ = g j := by rw [hg_def]
    _ ≤ ∑' j, g j := hg.sum_le_tsum _ fun j _ => hgnn j

