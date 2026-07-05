/-
Concentricity/ZetaStrip.lean

The zero-location cluster (the R5 sweep's cluster 4), the DERIVABLE core:
every nontrivial zero of ζ lies in the OPEN strip 0 < Re s < 1. DERIVED
in-repo (R10) from pinned Mathlib inputs only:
- nonvanishing on Re ≥ 1: `riemannZeta_ne_zero_of_one_le_re` (pinned,
  Mathlib/NumberTheory/LSeries/Nonvanishing.lean:410 — no s ≠ 1 needed,
  the ascribed value at 1 is nonzero);
- the reflection into Re ≤ 0: the unconditional completed functional
  equation `completedRiemannZeta_one_sub`, the ζ ↔ Λ divisor bridge
  (`riemannZeta_def_of_ne_zero`), and `Complex.Gammaℝ_eq_zero_iff` (a
  vanishing Γ-factor at Re ≤ 0 is exactly a trivial zero);
- `riemannZeta_zero` (ζ(0) = −1/2 ≠ 0) to exclude the origin.

The real-zero exclusion INSIDE the strip — ζ(σ) ≠ 0 for real σ ∈ (0, 1) —
is DERIVED in Concentricity/ZetaRealZeros.lean (the paired alternating
series; the pinned Mathlib has no such lemma). Cluster 4 is COMPLETE:
together, nontrivial zeros are non-real strip points
(`nontrivialZero_im_ne_zero`, RhEquiv.lean).

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file targets ZERO
sorries.
-/
import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.NumberTheory.LSeries.Nonvanishing
import Mathlib.NumberTheory.LSeries.DirichletContinuation
import Mathlib.Analysis.SpecialFunctions.Gamma.Deligne

noncomputable section

open Complex

/-- The divisor bridge, ζ-zero to Λ-zero: away from the origin, where the
Γ-factor does not vanish, a zero of ζ is a zero of the completed zeta.
DERIVED (R10). -/
theorem completedRiemannZeta_eq_zero_of_zeta {s : ℂ} (hs : s ≠ 0)
    (hΓ : Gammaℝ s ≠ 0) (hz : riemannZeta s = 0) :
    completedRiemannZeta s = 0 := by
  have h := riemannZeta_def_of_ne_zero hs
  rw [hz] at h
  rcases div_eq_zero_iff.mp h.symm with h0 | h0
  · exact h0
  · exact absurd h0 hΓ

/-- The divisor bridge, Λ-zero to ζ-zero: away from the origin a zero of
the completed zeta is a zero of ζ. DERIVED (R10). -/
theorem riemannZeta_eq_zero_of_completed {s : ℂ} (hs : s ≠ 0)
    (hΛ : completedRiemannZeta s = 0) : riemannZeta s = 0 := by
  rw [riemannZeta_def_of_ne_zero hs, hΛ, zero_div]

/-- **The open strip** (cluster 4, derivable core): a nontrivial zero of ζ
(in the nontrivial-zero vocabulary of `riemannZeta_nontrivialZeros_infinite`
and Mathlib's `RiemannHypothesis`) has 0 < Re s < 1. Re < 1 is the
nonvanishing half-plane directly; Re > 0 is the reflection — a zero at
Re ≤ 0 either has a vanishing Γ-factor (exactly a trivial zero,
`Gammaℝ_eq_zero_iff`) or transfers through the completed functional
equation to a zero at Re ≥ 1. DERIVED (R10). -/
theorem nontrivialZero_re_mem_Ioo {s : ℂ} (hz : riemannZeta s = 0)
    (htriv : ¬∃ n : ℕ, s = -2 * (n + 1)) (hone : s ≠ 1) :
    0 < s.re ∧ s.re < 1 := by
  have hlt : s.re < 1 := by
    by_contra hge
    rw [not_lt] at hge
    exact riemannZeta_ne_zero_of_one_le_re hge hz
  refine ⟨?_, hlt⟩
  by_contra hle
  rw [not_lt] at hle
  have hs0 : s ≠ 0 := by
    intro h
    rw [h, riemannZeta_zero] at hz
    norm_num at hz
  have hΓ : Gammaℝ s ≠ 0 := by
    rw [Ne, Gammaℝ_eq_zero_iff]
    rintro ⟨n, hn⟩
    rcases Nat.eq_zero_or_pos n with rfl | hpos
    · apply hs0
      rw [hn]
      norm_num
    · apply htriv
      obtain ⟨m, rfl⟩ := Nat.exists_eq_succ_of_ne_zero hpos.ne'
      refine ⟨m, ?_⟩
      rw [hn]
      push_cast
      ring
  have hΛ : completedRiemannZeta s = 0 :=
    completedRiemannZeta_eq_zero_of_zeta hs0 hΓ hz
  have h1s : (1 : ℂ) - s ≠ 0 := by
    intro h
    rw [sub_eq_zero] at h
    exact hone h.symm
  have hz' : riemannZeta (1 - s) = 0 := by
    refine riemannZeta_eq_zero_of_completed h1s ?_
    rw [completedRiemannZeta_one_sub]
    exact hΛ
  have hre' : 1 ≤ ((1 : ℂ) - s).re := by
    rw [Complex.sub_re, Complex.one_re]
    linarith
  exact riemannZeta_ne_zero_of_one_le_re hre' hz'
