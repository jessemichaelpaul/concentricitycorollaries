/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.LoopAssembly

/-!
# C1 cone cargo on the projective base

These are the already-proved cone tape rows formerly housed in the retired
static transport assembly.  They depend only on the analytic development and
are retained here for the projective disk action over `GreatCircle.Base`.
-/

noncomputable section

open Complex Filter

namespace ASection

/-- The section is zero-free on a punctured real interval at its C1 pole. -/
theorem eventually_ne_zero_near_pole (A : ASection) :
    ∃ δ > 0, ∀ x : ℝ, x ≠ A.pole → |x - A.pole| < δ →
      A.F ((x : ℝ) : ℂ) ≠ 0 := by
  rcases (A.meromorphic (A.pole : ℂ)
      (Set.mem_univ _)).eventually_eq_zero_or_eventually_ne_zero with hzero | hne
  · exfalso
    have htop : meromorphicOrderAt A.F (A.pole : ℂ) = ⊤ :=
      meromorphicOrderAt_eq_top_iff.mpr hzero
    rw [A.c1_simple] at htop
    exact WithTop.coe_ne_top htop
  · rw [Filter.eventually_iff, Metric.mem_nhdsWithin_iff] at hne
    obtain ⟨δ, hδ, h⟩ := hne
    refine ⟨δ, hδ, fun x hx hxd => ?_⟩
    have hxne : ((x : ℝ) : ℂ) ∈ ({(A.pole : ℂ)}ᶜ : Set ℂ) := by
      simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
      exact fun h' => hx (Complex.ofReal_injective h')
    have hdist : dist ((x : ℝ) : ℂ) ((A.pole : ℝ) : ℂ) < δ := by
      rw [Complex.isometry_ofReal.dist_eq, Real.dist_eq]
      exact hxd
    exact h ⟨Metric.mem_ball.mpr hdist, hxne⟩

/-- The C1 cone tape escapes every finite level near the pole. -/
theorem cone_tape_escape (A : ASection) (M : ℝ) :
    ∃ δ > 0, ∀ x : ℝ, x ≠ A.pole → |x - A.pole| < δ →
      A.F ((x : ℝ) : ℂ) ≠ 0 ∧ M < Real.log ‖A.F ((x : ℝ) : ℂ)‖ := by
  obtain ⟨δ₁, hδ₁, h₁⟩ := A.eventually_ne_zero_near_pole
  obtain ⟨δ₂, hδ₂, h₂⟩ := A.pole_cone_eps_delta (Real.exp (-M)) (Real.exp_pos _)
  refine ⟨min δ₁ δ₂, lt_min hδ₁ hδ₂, fun x hx hxd => ?_⟩
  have hne := h₁ x hx (lt_of_lt_of_le hxd (min_le_left _ _))
  have hxC : ((x : ℝ) : ℂ) ≠ (A.pole : ℂ) := fun h' =>
    hx (Complex.ofReal_injective h')
  have hdC : dist ((x : ℝ) : ℂ) ((A.pole : ℝ) : ℂ) < δ₂ := by
    rw [Complex.isometry_ofReal.dist_eq, Real.dist_eq]
    exact lt_of_lt_of_le hxd (min_le_right _ _)
  have hinv := h₂ _ hxC hdC
  refine ⟨hne, ?_⟩
  have hpos : 0 < ‖A.F ((x : ℝ) : ℂ)‖ := norm_pos_iff.mpr hne
  rw [norm_inv, Real.exp_neg] at hinv
  have hlt : Real.exp M < ‖A.F ((x : ℝ) : ℂ)‖ :=
    (inv_lt_inv₀ hpos (Real.exp_pos M)).mp hinv
  exact (Real.lt_log_iff_exp_lt hpos).mpr hlt

/-- The great-circle level tape is continuous away from the pole and zeros. -/
theorem tape_continuousOn_real (A : ASection) {S : Set ℝ}
    (hpole : ∀ y ∈ S, y ≠ A.pole) (hne : ∀ y ∈ S, A.F ((y : ℝ) : ℂ) ≠ 0) :
    ContinuousOn (fun y : ℝ => Real.log ‖A.F ((y : ℝ) : ℂ)‖) S := by
  intro y hy
  have hyC : ((y : ℝ) : ℂ) ≠ (A.pole : ℂ) := fun h' =>
    hpole y hy (Complex.ofReal_injective h')
  have h1 : ContinuousAt A.F ((y : ℝ) : ℂ) := (A.c1_analyticAt _ hyC).continuousAt
  have h2 : ContinuousAt (fun t : ℝ => A.F ((t : ℝ) : ℂ)) y :=
    h1.comp Complex.continuous_ofReal.continuousAt
  have h4 : ContinuousAt (fun t : ℝ => Real.log ‖A.F ((t : ℝ) : ℂ)‖) y :=
    h2.norm.log (norm_ne_zero_iff.mpr (hne y hy))
  exact h4.continuousWithinAt

/-- The real tape attains every intermediate level on a zero-free segment. -/
theorem real_segment_tape_sweeps (A : ASection) {u v : ℝ} (huv : u ≤ v)
    (hpole : ∀ y ∈ Set.Icc u v, y ≠ A.pole)
    (hne : ∀ y ∈ Set.Icc u v, A.F ((y : ℝ) : ℂ) ≠ 0) {L : ℝ}
    (hL : L ∈ Set.uIcc (Real.log ‖A.F ((u : ℝ) : ℂ)‖)
      (Real.log ‖A.F ((v : ℝ) : ℂ)‖)) :
    ∃ y ∈ Set.Icc u v, Real.log ‖A.F ((y : ℝ) : ℂ)‖ = L := by
  have huIcc : Set.uIcc u v = Set.Icc u v := Set.uIcc_of_le huv
  have hcont : ContinuousOn (fun y : ℝ => Real.log ‖A.F ((y : ℝ) : ℂ)‖)
      (Set.uIcc u v) := by
    rw [huIcc]
    exact A.tape_continuousOn_real hpole hne
  obtain ⟨y, hy, hyL⟩ := intermediate_value_uIcc hcont hL
  rw [huIcc] at hy
  exact ⟨y, hy, hyL⟩

/-- Both C1 cone legs carry every sufficiently high level. -/
theorem cone_junction_levels_shared (A : ASection) :
    ∃ L₀ : ℝ, ∀ L : ℝ, L₀ ≤ L →
      (∃ x : ℝ, x < A.pole ∧ Real.log ‖A.F ((x : ℝ) : ℂ)‖ = L) ∧
      (∃ x : ℝ, A.pole < x ∧ Real.log ‖A.F ((x : ℝ) : ℂ)‖ = L) := by
  obtain ⟨δ, hδ, h⟩ := A.cone_tape_escape 0
  set x₁ : ℝ := A.pole - δ / 2 with hx₁_def
  set x₂ : ℝ := A.pole + δ / 2 with hx₂_def
  have hx₁ne : x₁ ≠ A.pole := by
    rw [hx₁_def]
    intro h'
    linarith
  have hx₂ne : x₂ ≠ A.pole := by
    rw [hx₂_def]
    intro h'
    linarith
  have hx₁d : |x₁ - A.pole| < δ := by
    rw [hx₁_def, abs_of_neg (by linarith)]
    linarith
  have hx₂d : |x₂ - A.pole| < δ := by
    rw [hx₂_def, abs_of_pos (by linarith)]
    linarith
  refine ⟨max (Real.log ‖A.F ((x₁ : ℝ) : ℂ)‖) (Real.log ‖A.F ((x₂ : ℝ) : ℂ)‖),
    fun L hL => ?_⟩
  obtain ⟨δL, hδL, hesc⟩ := A.cone_tape_escape L
  constructor
  · set xr : ℝ := A.pole - min δL δ / 2 with hxr_def
    have hmin : 0 < min δL δ := lt_min hδL hδ
    have hx₁xr : x₁ ≤ xr := by
      rw [hx₁_def, hxr_def]
      have := min_le_right δL δ
      linarith
    have hxrp : xr < A.pole := by rw [hxr_def]; linarith
    have hseg : ∀ y ∈ Set.Icc x₁ xr, y ≠ A.pole ∧ |y - A.pole| < δ := by
      rintro y ⟨hy₁, hy₂⟩
      have hylt : y < A.pole := lt_of_le_of_lt hy₂ hxrp
      refine ⟨ne_of_lt hylt, ?_⟩
      rw [abs_of_neg (by linarith)]
      rw [hx₁_def] at hy₁
      linarith
    have hxrne : xr ≠ A.pole := ne_of_lt hxrp
    have hxrδL : |xr - A.pole| < δL := by
      rw [hxr_def, abs_of_neg (by linarith)]
      have := min_le_left δL δ
      linarith
    have hxrL : L < Real.log ‖A.F ((xr : ℝ) : ℂ)‖ := (hesc xr hxrne hxrδL).2
    have hx₁L : Real.log ‖A.F ((x₁ : ℝ) : ℂ)‖ ≤ L :=
      le_trans (le_max_left _ _) hL
    obtain ⟨y, hy, hyL⟩ := A.real_segment_tape_sweeps hx₁xr
      (fun y hy => (hseg y hy).1)
      (fun y hy => (h y (hseg y hy).1 (hseg y hy).2).1)
      (Set.mem_uIcc.mpr (Or.inl ⟨hx₁L, hxrL.le⟩))
    exact ⟨y, lt_of_le_of_lt hy.2 hxrp, hyL⟩
  · set xr : ℝ := A.pole + min δL δ / 2 with hxr_def
    have hmin : 0 < min δL δ := lt_min hδL hδ
    have hxrx₂ : xr ≤ x₂ := by
      rw [hx₂_def, hxr_def]
      have := min_le_right δL δ
      linarith
    have hxrp : A.pole < xr := by rw [hxr_def]; linarith
    have hseg : ∀ y ∈ Set.Icc xr x₂, y ≠ A.pole ∧ |y - A.pole| < δ := by
      rintro y ⟨hy₁, hy₂⟩
      have hygt : A.pole < y := lt_of_lt_of_le hxrp hy₁
      refine ⟨(ne_of_lt hygt).symm, ?_⟩
      rw [abs_of_pos (by linarith)]
      rw [hx₂_def] at hy₂
      linarith
    have hxrne : xr ≠ A.pole := (ne_of_lt hxrp).symm
    have hxrδL : |xr - A.pole| < δL := by
      rw [hxr_def, abs_of_pos (by linarith)]
      have := min_le_left δL δ
      linarith
    have hxrL : L < Real.log ‖A.F ((xr : ℝ) : ℂ)‖ := (hesc xr hxrne hxrδL).2
    have hx₂L : Real.log ‖A.F ((x₂ : ℝ) : ℂ)‖ ≤ L :=
      le_trans (le_max_right _ _) hL
    obtain ⟨y, hy, hyL⟩ := A.real_segment_tape_sweeps hxrx₂
      (fun y hy => (hseg y hy).1)
      (fun y hy => (h y (hseg y hy).1 (hseg y hy).2).1)
      (Set.mem_uIcc.mpr (Or.inr ⟨hx₂L, hxrL.le⟩))
    exact ⟨y, lt_of_lt_of_le hxrp hy.1, hyL⟩

end ASection

