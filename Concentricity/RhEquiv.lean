/-
Concentricity/RhEquiv.lean

Island B7 (PLAN_islands_part1_part2_2026-07-05.md): `thm:rh-equiv` — the
proved rows. Master (verbatim): "The following are equivalent: (a) the
Riemann Hypothesis; (b) the nontrivial-zero 6-spheres {S_ρ} of ζ_𝕆
(Theorem thm:zero-spheres) are concentric — they share a single common
centre, necessarily a point of the real axis. When they hold, the common
centre is ½." Per `rmk:half-downstream`: ½ enters ONLY in (b)⇒(a), through
the functional equation — this file is the only place it appears.

Concentricity (b) is rendered at the sphere parameters: B6's sphere
`zeroSphere σ γ` (γ > 0) is "the round sphere of radius γ centred at the
real point σ" (`mem_zeroSphere_iff`: re = σ on the sphere), so a common
centre is one c with σ = c for every upper-half zero parameter.

Landed PROVED here: (a)⇒(b) with the centre ½ (`concentric_of_RH`); the
functional-equation transfer in the strip (`riemannZeta_one_sub_zero`,
master proof clause "if ρ is a nontrivial zero then so is 1−ρ̄", through
the completed FE and the conjugation pin); and the rigidity row
(`upperZero_re_eq_half_of_concentric`, master: "Concentricity forces
σ_ρ = c = 1 − σ_ρ, hence σ_ρ = ½") — the whole of (b)⇒(a) on the non-real
zeros.

NOT landed (R6-flagged, the one remaining classical leaf): the full iff
against Mathlib's `RiemannHypothesis` needs "every nontrivial zero is
non-real" — the real-zero exclusion ζ(σ) ≠ 0 on σ ∈ (0,1)
(ZetaStrip.lean header). The iff row lands when that leaf does, by author
ruling.

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file targets ZERO
sorries.
-/
import Concentricity.ZeroSpheres
import Concentricity.ZetaStrip

noncomputable section

open Complex

/-- A non-real point is a nontrivial-zero candidate: not a trivial zero
(those are real) and not the pole point 1 (real). PROVED helper. -/
theorem nontrivial_of_im_ne_zero {s : ℂ} (him : s.im ≠ 0) :
    (¬∃ n : ℕ, s = -2 * (n + 1)) ∧ s ≠ 1 := by
  constructor
  · rintro ⟨n, rfl⟩
    apply him
    simp
  · intro h
    rw [h] at him
    exact him Complex.one_im

/-- **(a) ⇒ (b), with the centre** (master: "under RH every σ_ρ = ½, so all
spheres share the centre ½"): under Mathlib's `RiemannHypothesis`, every
upper-half zero parameter — the centre of B6's `zeroSphere σ γ` — is ½.
PROVED. -/
theorem concentric_of_RH (h : RiemannHypothesis) ⦃σ γ : ℝ⦄ (hγ : 0 < γ)
    (hz : riemannZeta ⟨σ, γ⟩ = 0) : σ = 1 / 2 := by
  have him : (⟨σ, γ⟩ : ℂ).im ≠ 0 := ne_of_gt hγ
  obtain ⟨htriv, hone⟩ := nontrivial_of_im_ne_zero him
  exact h ⟨σ, γ⟩ hz htriv hone

/-- **The functional-equation transfer in the strip** (master proof clause,
verbatim: "By the functional equation (Theorem thm:riemann), if ρ is a
nontrivial zero then so is 1−ρ̄ = (1−σ_ρ)+iγ_ρ"): a strip zero at ⟨σ, γ⟩
gives a strip zero at ⟨1−σ, γ⟩ — through the unconditional completed
functional equation, the Γ-divisor bridges (ZetaStrip.lean), and the
conjugation pin (ZetaConj.lean). PROVED. -/
theorem riemannZeta_one_sub_zero {s : ℂ} (h0 : 0 < s.re) (h1 : s.re < 1)
    (hz : riemannZeta s = 0) : riemannZeta (1 - s) = 0 := by
  have hs0 : s ≠ 0 := by
    intro h
    rw [h] at h0
    simp at h0
  have hΓ : Gammaℝ s ≠ 0 := by
    rw [Ne, Gammaℝ_eq_zero_iff]
    rintro ⟨n, hn⟩
    rw [hn] at h0
    rw [show (-(2 * (n : ℂ))).re = -(2 * (n : ℝ)) by simp] at h0
    have hn0 : (0 : ℝ) ≤ 2 * n := by positivity
    linarith
  have h1s : (1 : ℂ) - s ≠ 0 := by
    intro h
    rw [sub_eq_zero] at h
    have := congrArg Complex.re h
    rw [Complex.one_re] at this
    linarith [this]
  refine riemannZeta_eq_zero_of_completed h1s ?_
  rw [completedRiemannZeta_one_sub]
  exact completedRiemannZeta_eq_zero_of_zeta hs0 hΓ hz

/-- **The rigidity row — (b) ⇒ every centre is ½** (master, verbatim:
"suppose the spheres share a common centre c ∈ ℝ … Concentricity forces
σ_ρ = c = 1−σ_ρ, hence σ_ρ = ½"; `rmk:half-downstream`: this is the ONLY
entry point of ½): if all upper-half zero parameters share one centre c,
then each is ½ — the sphere of ρ is centred at σ, the sphere of 1−ρ̄ at
1−σ (the FE transfer folded to the upper half by the conjugation pin), and
c = σ = 1−σ. This is (b)⇒(a) in full on the non-real zeros; the real case
is the R6-flagged leaf (file header). PROVED. -/
theorem upperZero_re_eq_half_of_concentric {c : ℝ}
    (hc : ∀ ⦃σ γ : ℝ⦄, 0 < γ → riemannZeta ⟨σ, γ⟩ = 0 → σ = c)
    ⦃σ γ : ℝ⦄ (hγ : 0 < γ) (hz : riemannZeta ⟨σ, γ⟩ = 0) : σ = 1 / 2 := by
  have him : (⟨σ, γ⟩ : ℂ).im ≠ 0 := ne_of_gt hγ
  obtain ⟨htriv, hone⟩ := nontrivial_of_im_ne_zero him
  obtain ⟨h0, h1⟩ := nontrivialZero_re_mem_Ioo hz htriv hone
  have hz1 : riemannZeta (1 - ⟨σ, γ⟩) = 0 := riemannZeta_one_sub_zero h0 h1 hz
  have hz2 : riemannZeta ⟨1 - σ, γ⟩ = 0 := by
    have hconj := riemannZeta_conj (1 - ⟨σ, γ⟩)
    rw [hz1, map_zero] at hconj
    have harg : (starRingEnd ℂ) (1 - (⟨σ, γ⟩ : ℂ)) = (⟨1 - σ, γ⟩ : ℂ) := by
      apply Complex.ext
      · rw [Complex.conj_re, Complex.sub_re, Complex.one_re]
      · rw [Complex.conj_im, Complex.sub_im, Complex.one_im]
        change -(0 - γ) = γ
        ring
    rwa [harg] at hconj
  have h₁ : σ = c := hc hγ hz
  have h₂ : 1 - σ = c := hc hγ hz2
  linarith
