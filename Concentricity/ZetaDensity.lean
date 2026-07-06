/-
Concentricity/ZetaDensity.lean

Brick-2 runway item (1) (author "Execute!", 2026-07-06): ζ's QUADRATIC
POINT-DENSITY — the D0 summability obligation's single remaining goal,
closed for the ζ member:

    Summable (fun k => 1 / (1 + ‖zetaSphereZero k‖ ^ 2)).

Route (all pinned/in-repo): Jensen's inequality in ready divisor form
(`AnalyticOnNhd.sum_divisor_le`) applied to ξ on balls — ξ(0) = 1
normalizes the formula and the in-repo growth bound `xi_growth` gives
log M(T) ≲ T·log T (order one, amply subquadratic); the stage-B divisor
bridge (`xi_orderAt_upper` + the pairs injection) turns the enumeration's
ball-counts into ξ-divisor sums; the dyadic-shell comparison closes
through `summable_of_sum_range_le`.

γ-NOTE (for the class dialogue): the ONLY member-private input here is
the growth bound — everything else is class machinery. A class-level
growth/typing input at N is exactly what would replace `xi_growth`.

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file targets ZERO
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
