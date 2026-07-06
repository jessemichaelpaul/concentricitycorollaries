/-
Concentricity/ZetaConj.lean

The conjugation pin (the R5 sweep's cluster 2), DERIVED in-repo (R10; the
ZetaInfinitude precedent): ζ(conj s) = conj (ζ s) for ALL s ∈ ℂ. The pinned
Mathlib has no such lemma (R5 verified 2026-07-05, repo-wide grep of the
riemannZeta cluster); the derivation is the classical reflection argument at
stem level — the Dirichlet series is conjugation-symmetric on {1 < Re s}
(each term 1/n^s conjugates in the exponent, `Complex.cpow_conj` at
nonnegative real base), the identity theorem
(`AnalyticOnNhd.eqOn_of_preconnected_of_eventuallyEq`) transports the
symmetry over the connected ℂ ∖ {1}
(`isConnected_compl_singleton_of_one_lt_rank`), and at s = 1 Mathlib's
ascribed value is real (`riemannZeta_one`), hence conjugation-fixed.

Single consumption point (PLAN_islands B2: "This is where it enters,
once"): `prop:well-defined` (the lower-half display), `def:zeta_O`(ii)
faithfulness, and the stem-level intrinsic read-off of `thm:zeta-in-R`.

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file targets ZERO
sorries.
-/
import Concentricity.StemRing
import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.NumberTheory.Harmonic.ZetaAsymp
import Mathlib.Analysis.Normed.Module.Connected
import Mathlib.Analysis.Analytic.Uniqueness

noncomputable section

open Complex ComplexConjugate

/-- Antiholomorphic sandwich: if `f` has derivative `d` at `conj z`, the
double conjugate `conj ∘ f ∘ conj` has derivative `conj d` at `z` — the
slopes conjugate termwise (`slope_def_field` + the ring-hom laws) and `conj`
carries the punctured neighbourhood of `z` to that of `conj z`. PROVED
helper. -/
theorem HasDerivAt.conj_comp_conj {f : ℂ → ℂ} {d z : ℂ}
    (hf : HasDerivAt f d (conj z)) :
    HasDerivAt (fun w => conj (f (conj w))) (conj d) z := by
  rw [hasDerivAt_iff_tendsto_slope] at hf ⊢
  have hmap : Filter.Tendsto (conj : ℂ → ℂ) (nhdsWithin z {z}ᶜ)
      (nhdsWithin (conj z) {conj z}ᶜ) := by
    rw [tendsto_nhdsWithin_iff]
    refine ⟨(Complex.continuous_conj.tendsto z).mono_left nhdsWithin_le_nhds, ?_⟩
    filter_upwards [self_mem_nhdsWithin] with u hu h
    exact hu ((starRingEnd ℂ).injective h)
  have hslope : ∀ u : ℂ, conj (slope f (conj z) (conj u))
      = slope (fun w => conj (f (conj w))) z u := by
    intro u
    rw [slope_def_field, slope_def_field, map_div₀, map_sub, map_sub,
      starRingEnd_self_apply, starRingEnd_self_apply]
  exact ((Complex.continuous_conj.tendsto d).comp (hf.comp hmap)).congr hslope

/-- **The conjugation pin** — DERIVED (R10): ζ(conj s) = conj (ζ s), for
every s ∈ ℂ (Mathlib's ascribed value at the pole point s = 1 included:
`riemannZeta_one` is real). On {1 < Re s} this is the Dirichlet series
termwise; on ℂ ∖ {1} it is the identity theorem; classically it is the
reflection ζ(s̄) = ζ(s)̄ (master `prop:well-defined` cites Titchmarsh Ch. 2
for this symmetry — the citation is for faithfulness, never as load; this
proof IS the load). -/
theorem riemannZeta_conj (s : ℂ) :
    riemannZeta (conj s) = conj (riemannZeta s) := by
  by_cases hs : s = 1
  · subst hs
    rw [map_one]
    have him : (riemannZeta 1).im = 0 := by
      have hval : riemannZeta 1
          = (((Real.eulerMascheroniConstant - Real.log (4 * Real.pi)) / 2 : ℝ)
            : ℂ) := by
        rw [riemannZeta_one, Complex.ofReal_div, Complex.ofReal_sub,
          Complex.ofReal_log (by positivity : (0 : ℝ) ≤ 4 * Real.pi),
          Complex.ofReal_mul]
        norm_num
      rw [hval, Complex.ofReal_im]
    have hre : riemannZeta 1 = ((riemannZeta 1).re : ℂ) :=
      Complex.ext rfl him
    rw [hre, Complex.conj_ofReal]
  · have hUopen : IsOpen ({(1 : ℂ)}ᶜ : Set ℂ) := isOpen_compl_singleton
    have hUconn : IsPreconnected ({(1 : ℂ)}ᶜ : Set ℂ) := by
      refine (isConnected_compl_singleton_of_one_lt_rank ?_ 1).isPreconnected
      rw [← Module.finrank_eq_rank, Complex.finrank_real_complex]
      exact_mod_cast one_lt_two
    have hf : AnalyticOnNhd ℂ riemannZeta ({(1 : ℂ)}ᶜ : Set ℂ) :=
      DifferentiableOn.analyticOnNhd
        (fun z hz => (differentiableAt_riemannZeta hz).differentiableWithinAt)
        hUopen
    have hg : AnalyticOnNhd ℂ (fun z => conj (riemannZeta (conj z)))
        ({(1 : ℂ)}ᶜ : Set ℂ) := by
      refine DifferentiableOn.analyticOnNhd (fun z hz => ?_) hUopen
      have hz1 : conj z ≠ 1 := by
        intro h
        apply hz
        have h2 := congrArg (starRingEnd ℂ) h
        rw [starRingEnd_self_apply, map_one] at h2
        exact h2
      exact ((differentiableAt_riemannZeta hz1).hasDerivAt.conj_comp_conj
        ).differentiableAt.differentiableWithinAt
    have h2U : (2 : ℂ) ∈ ({(1 : ℂ)}ᶜ : Set ℂ) := by norm_num
    have hev : riemannZeta =ᶠ[nhds (2 : ℂ)]
        fun z => conj (riemannZeta (conj z)) := by
      have hopen : IsOpen {z : ℂ | 1 < z.re} :=
        isOpen_lt continuous_const Complex.continuous_re
      have h2mem : (2 : ℂ) ∈ {z : ℂ | 1 < z.re} := by norm_num
      filter_upwards [hopen.mem_nhds h2mem] with z hz
      have hzre : 1 < z.re := hz
      have hzcre : 1 < (conj z).re := by rwa [Complex.conj_re]
      rw [zeta_eq_tsum_one_div_nat_cpow hzre,
        zeta_eq_tsum_one_div_nat_cpow hzcre, starRingEnd_apply, tsum_star]
      refine tsum_congr fun n => ?_
      rw [star_div₀, star_one, ← starRingEnd_apply,
        Complex.cpow_conj _ _ (by
          rw [Complex.natCast_arg]
          exact Real.pi_ne_zero.symm),
        Complex.conj_natCast, starRingEnd_self_apply]
    have hkey := hf.eqOn_of_preconnected_of_eventuallyEq hg hUconn h2U hev
      (Set.mem_compl_singleton_iff.mpr hs)
    have h2 := congrArg (starRingEnd ℂ) hkey
    rw [starRingEnd_self_apply] at h2
    exact h2.symm

/-- The stem-level intrinsic read-off (`thm:zeta-in-R`'s stem face, the one
consumed by `cor:zeta-section`'s `intrinsic` field; master
`def:slice-preserving` over the classical stem): ζ is an intrinsic stem. -/
theorem riemannZeta_intrinsic : IsIntrinsic riemannZeta :=
  fun z => riemannZeta_conj z

/-- ζ is real on the real axis (`def:zeta_O`(ii)'s "ζ(s) ∈ ℝ"; DERIVED from
the pin through `StemRing.real_on_real`). -/
theorem riemannZeta_im_ofReal (x : ℝ) : (riemannZeta x).im = 0 :=
  StemRing.real_on_real riemannZeta_intrinsic x

/-- Γℝ is intrinsic (π real; `Gamma_conj`). PROVED helper. -/
theorem Gammaℝ_conj (s : ℂ) :
    Gammaℝ ((starRingEnd ℂ) s) = (starRingEnd ℂ) (Gammaℝ s) := by
  rw [Gammaℝ, Gammaℝ, map_mul]
  congr 1
  · have hπ : ((Real.pi : ℝ) : ℂ).arg ≠ Real.pi := by
      rw [Complex.arg_ofReal_of_nonneg Real.pi_pos.le]
      exact Real.pi_ne_zero.symm
    have h := Complex.cpow_conj ((Real.pi : ℝ) : ℂ) (-s / 2) hπ
    rw [Complex.conj_ofReal] at h
    rw [← h]
    congr 1
    rw [map_div₀, map_neg, map_ofNat]
  · rw [← Complex.Gamma_conj]
    congr 1
    rw [map_div₀, map_ofNat]
