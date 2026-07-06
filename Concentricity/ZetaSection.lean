/-
Concentricity/ZetaSection.lean

Island C1, stage 2 — `cor:zeta-section` (master, verbatim): "ζ_𝕆 is an
A-section (Definition def:A-section): a section of 𝓡 satisfying
(C1)–(C4)." The `zetaSection : ASection` instance per the author-approved
field table (DESIGN_translations.md §#3), landed by the design's own rule:
"Land fields incrementally, each sorried until its classical fact is in
(R8)". [Disambiguation, author 2026-07-05: "Island C1" = this corollary;
"the C1 fields" = the pole cluster of def:A-section.]

PROVED fields (in stock): F, intrinsic (ZetaConj), meromorphic +
c1_analyticAt + c1_simple (ZetaPole), sphereZero (the divisor-repeated
enumeration, ZetaDivisor) with c3_sphere_nonreal + c4_infinite,
c3_lowerEdge (the strip, ZetaStrip: ζ supplies 0 < Re ρ outright —
member-private, PLAN §6-admissible as a bound, not a level), ι_infinite,
valueAtInfinity = 1 (def:zeta-Cstar) + realness, m := 0 (ζ(0) = −1/2),
genus := 1 (order-1 Hadamard shape).

PROVED rows (closed 2026-07-05, same session): the C2 cluster (six rows —
the SYMMETRIZED Euler-factor logs, equal to −log(1 − p^{−z}) on Ω₀ by
`zetaEulerLog_eq_of_re_pos`, globally intrinsic by construction; the
exp-of-sum Euler product through the pinned
`riemannZeta_eulerProduct_exp_log`; majorant (3/2)·p^{−(1+δ)}); the Rfac
rows (three — the 1/Γℝ unit with the origin's zero divided out:
intrinsic via `Gamma_conj`, entire via `differentiable_Gammaℝ_inv` +
`Gammaℝ_residue_zero` removable origin, zeros = the trivial zeros −2n,
real and nonzero, via `Gammaℝ_eq_zero_iff`).

SORRIED (R8 — UNFORMALIZED, never UNSOUND): ONE row, `zetaC3_package` —
the infinite Weierstrass factorization of (s−1)ζ through the pole N over
the divisor-repeated enumeration (author: "infinite Weierstrass through
the pole N gets us attached to the infinitely many ℂ-residue side").
gfac and its four consumer rows are `choose`-extracted from it, so the
entire C3 gap is ONE named leaf.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.ASection
import Concentricity.ZetaDivisor
import Concentricity.RhEquiv
import Mathlib.Analysis.SpecialFunctions.Log.Summable
import Mathlib.Analysis.SpecialFunctions.Complex.LogBounds

noncomputable section

open Complex

/-! ## C2 data and rows: the Euler-factor logarithms -/

/-- C2 data — the Euler family, in the conjugation-SYMMETRIZED form
(master C2 "A = exp(Σₚ ℓₚ)"; design table modulo the R8 repair, author
2026-07-05 session): on Ω₀ this equals the classical −log(1 − p^{−z})
(`zetaEulerLog_eq_of_re_pos`), while the symmetrization makes global
intrinsicality a formal identity — the naive branch hits the log cut at
Re z ≤ 0, where the naive form is NOT intrinsic, so the naive data would
have made `c2_intrinsic` an unsound sorry. -/
noncomputable def zetaEulerLog (p : Nat.Primes) (z : ℂ) : ℂ :=
  (-Complex.log (1 - ((p : ℕ) : ℂ) ^ (-z))
    - (starRingEnd ℂ) (Complex.log (1 - ((p : ℕ) : ℂ) ^ (-(starRingEnd ℂ z))))) / 2

/-- C2: each ℓ_p is intrinsic — by the symmetrized shape, a formal
computation. PROVED. -/
theorem zetaC2_intrinsic : ∀ p : Nat.Primes, IsIntrinsic (zetaEulerLog p) := by
  intro p z
  rw [zetaEulerLog, zetaEulerLog, map_div₀, map_sub, map_neg,
    starRingEnd_self_apply, starRingEnd_self_apply]
  rw [map_ofNat]
  ring

/-- The norm of p^{−w} is p^{−Re w}. PROVED helper. -/
theorem norm_prime_cpow_neg (p : Nat.Primes) (w : ℂ) :
    ‖((p : ℕ) : ℂ) ^ (-w)‖ = ((p : ℕ) : ℝ) ^ (-w.re) := by
  have hcast : ((p : ℕ) : ℂ) = (((p : ℕ) : ℝ) : ℂ) := by norm_cast
  rw [hcast, Complex.norm_cpow_eq_rpow_re_of_pos
    (by exact_mod_cast p.2.pos), Complex.neg_re]

/-- On Re w > 0 the norm of p^{−w} is below 1. PROVED helper. -/
theorem norm_prime_cpow_neg_lt_one (p : Nat.Primes) {w : ℂ}
    (hw : 0 < w.re) : ‖((p : ℕ) : ℂ) ^ (-w)‖ < 1 := by
  rw [norm_prime_cpow_neg]
  exact Real.rpow_lt_one_of_one_lt_of_neg
    (by exact_mod_cast p.2.one_lt) (by linarith)

/-- **The workhorse**: on Re z > 0 the symmetrized ℓ_p collapses to the
classical −log(1 − p^{−z}) — the conjugate summand folds by `log_conj`
(the factor stays in the right half-plane, off the cut) and the
real-base cpow conjugation. PROVED. -/
theorem zetaEulerLog_eq_of_re_pos (p : Nat.Primes) {z : ℂ} (hz : 0 < z.re) :
    zetaEulerLog p z = -Complex.log (1 - ((p : ℕ) : ℂ) ^ (-z)) := by
  have hczre : 0 < ((starRingEnd ℂ) z).re := by rwa [Complex.conj_re]
  have hnorm := norm_prime_cpow_neg_lt_one p hczre
  set w : ℂ := 1 - ((p : ℕ) : ℂ) ^ (-(starRingEnd ℂ) z) with hw_def
  have hwre : 0 < w.re := by
    rw [hw_def, Complex.sub_re, Complex.one_re]
    have h1 := Complex.abs_re_le_norm (((p : ℕ) : ℂ) ^ (-(starRingEnd ℂ) z))
    have h2 := (abs_lt.mp (lt_of_le_of_lt h1 hnorm)).2
    linarith
  have harg : w.arg ≠ Real.pi := by
    intro h
    have := Complex.arg_eq_pi_iff.mp h
    linarith [this.1]
  have hfold : (starRingEnd ℂ) (Complex.log w) = Complex.log ((starRingEnd ℂ) w) :=
    (Complex.log_conj w harg).symm
  have hconjw : (starRingEnd ℂ) w = 1 - ((p : ℕ) : ℂ) ^ (-z) := by
    rw [hw_def, map_sub, map_one]
    congr 1
    have hcast : ((p : ℕ) : ℂ) = (((p : ℕ) : ℝ) : ℂ) := by norm_cast
    rw [hcast]
    have harg' : ((((p : ℕ) : ℝ)) : ℂ).arg ≠ Real.pi := by
      rw [Complex.arg_ofReal_of_nonneg (by positivity)]
      exact Real.pi_ne_zero.symm
    calc (starRingEnd ℂ) (((((p : ℕ) : ℝ)) : ℂ) ^ (-(starRingEnd ℂ) z))
        = (starRingEnd ℂ) ((starRingEnd ℂ) ((((p : ℕ) : ℝ)) : ℂ)
            ^ (-(starRingEnd ℂ) z)) := by rw [Complex.conj_ofReal]
      _ = ((((p : ℕ) : ℝ)) : ℂ) ^ (starRingEnd ℂ) (-(starRingEnd ℂ) z) :=
          (Complex.cpow_conj _ _ harg').symm
      _ = ((((p : ℕ) : ℝ)) : ℂ) ^ (-z) := by
          rw [map_neg, starRingEnd_self_apply]
  rw [zetaEulerLog, hfold, hconjw]
  ring

/-- The classical Euler log is differentiable where Re > 0 (the factor is
in the slit plane; the cpow is entire in the exponent). PROVED helper. -/
theorem differentiableAt_eulerLog_classical (p : Nat.Primes) {w : ℂ}
    (hw : 0 < w.re) :
    DifferentiableAt ℂ (fun v => -Complex.log (1 - ((p : ℕ) : ℂ) ^ (-v))) w := by
  have hbase : ((p : ℕ) : ℂ) ≠ 0 := by exact_mod_cast p.2.pos.ne'
  have hcpow : DifferentiableAt ℂ (fun v : ℂ => ((p : ℕ) : ℂ) ^ (-v)) w := by
    have heq : (fun v : ℂ => ((p : ℕ) : ℂ) ^ (-v))
        = fun v => Complex.exp (Complex.log ((p : ℕ) : ℂ) * -v) := by
      funext v
      exact Complex.cpow_def_of_ne_zero hbase _
    rw [heq]
    fun_prop
  have hre : 0 < (1 - ((p : ℕ) : ℂ) ^ (-w)).re := by
    rw [Complex.sub_re, Complex.one_re]
    have h1 := Complex.abs_re_le_norm (((p : ℕ) : ℂ) ^ (-w))
    have h2 := (abs_lt.mp (lt_of_le_of_lt h1 (norm_prime_cpow_neg_lt_one p hw))).2
    linarith
  have hmem : (1 - ((p : ℕ) : ℂ) ^ (-w)) ∈ Complex.slitPlane := Or.inl hre
  exact ((Complex.differentiableAt_log hmem).comp w
    ((differentiableAt_const _).sub hcpow)).neg

/-- C2: each ℓ_p is analytic on Re > 1. PROVED — the symmetrized form
agrees with the classical one on the open half-plane
(`zetaEulerLog_eq_of_re_pos`), which is differentiable there. -/
theorem zetaC2_analyticAt : ∀ p : Nat.Primes, ∀ z : ℂ, (1 : ℝ) < z.re →
    AnalyticAt ℂ (zetaEulerLog p) z := by
  intro p z hz
  have hopen : IsOpen {w : ℂ | 0 < w.re} :=
    isOpen_lt continuous_const Complex.continuous_re
  have hzmem : z ∈ {w : ℂ | 0 < w.re} := by
    show (0 : ℝ) < z.re
    linarith
  have hG : AnalyticAt ℂ (fun v => -Complex.log (1 - ((p : ℕ) : ℂ) ^ (-v))) z := by
    refine DifferentiableOn.analyticOnNhd
      (fun w hw => (differentiableAt_eulerLog_classical p hw).differentiableWithinAt)
      hopen z hzmem
  refine hG.congr ?_
  filter_upwards [hopen.mem_nhds hzmem] with w hw
  exact (zetaEulerLog_eq_of_re_pos p hw).symm

/-- C2: "each zero-free on Ω₀" — a vanishing log would force
p^{−z} = 0 against the nonvanishing of cpow at nonzero base. PROVED. -/
theorem zetaC2_zero_free : ∀ p : Nat.Primes, ∀ z : ℂ, (1 : ℝ) < z.re →
    zetaEulerLog p z ≠ 0 := by
  intro p z hz h0
  rw [zetaEulerLog_eq_of_re_pos p (by linarith), neg_eq_zero] at h0
  have hnorm := norm_prime_cpow_neg_lt_one p (by linarith : 0 < z.re)
  have hw0 : 1 - ((p : ℕ) : ℂ) ^ (-z) ≠ 0 := by
    intro h
    have h1 : ((p : ℕ) : ℂ) ^ (-z) = 1 := by
      have := sub_eq_zero.mp h
      exact this.symm
    rw [h1] at hnorm
    simp at hnorm
  have hexp := Complex.exp_log hw0
  rw [h0, Complex.exp_zero] at hexp
  have h1 : ((p : ℕ) : ℂ) ^ (-z) = 0 := by
    linear_combination hexp
  have hbase : ((p : ℕ) : ℂ) ≠ 0 := by exact_mod_cast p.2.pos.ne'
  rw [Complex.cpow_def_of_ne_zero hbase] at h1
  exact Complex.exp_ne_zero _ h1

/-- Summability of p^{−z} over the primes for Re z > 1 (restriction of
the ℕ p-series). PROVED helper. -/
theorem summable_prime_cpow_neg {z : ℂ} (hz : (1 : ℝ) < z.re) :
    Summable fun p : Nat.Primes => ((p : ℕ) : ℂ) ^ (-z) := by
  have h1 : Summable fun n : ℕ => 1 / (n : ℂ) ^ z :=
    Complex.summable_one_div_nat_cpow.mpr hz
  have h2 : Summable fun n : ℕ => (n : ℂ) ^ (-z) := by
    refine h1.congr fun n => ?_
    rw [Complex.cpow_neg, one_div]
  exact h2.subtype _

/-- C2: summability of the family on Re > 1 (`summable_log_one_add_of_summable`
over the dominated p^{−z}). PROVED. -/
theorem zetaC2_summable : ∀ z : ℂ, (1 : ℝ) < z.re →
    Summable fun p : Nat.Primes => zetaEulerLog p z := by
  intro z hz
  have hlog : Summable fun p : Nat.Primes =>
      Complex.log (1 + -(((p : ℕ) : ℂ) ^ (-z))) :=
    Complex.summable_log_one_add_of_summable (summable_prime_cpow_neg hz).neg
  have h2 : Summable fun p : Nat.Primes =>
      -Complex.log (1 - ((p : ℕ) : ℂ) ^ (-z)) := by
    refine hlog.neg.congr fun p => ?_
    rw [sub_eq_add_neg]
  refine h2.congr fun p => ?_
  exact (zetaEulerLog_eq_of_re_pos p (by linarith)).symm

/-- C2: the Euler product in exp-of-sum form, ζ = exp(Σₚ ℓₚ) on Re > 1 —
the pinned `riemannZeta_eulerProduct_exp_log` read through the
symmetrization collapse. PROVED. -/
theorem zetaC2_euler : ∀ z : ℂ, (1 : ℝ) < z.re →
    riemannZeta z = Complex.exp (∑' p : Nat.Primes, zetaEulerLog p z) := by
  intro z hz
  rw [← riemannZeta_eulerProduct_exp_log hz]
  congr 1
  exact tsum_congr fun p => (zetaEulerLog_eq_of_re_pos p (by linarith)).symm

/-- §4α: the local majorant of the Euler family — on the half-width ball
Re w > 1 + δ, ‖ℓ_p‖ ≤ (3/2)·p^{−(1+δ)} (`norm_log_one_add_half_le_self`),
a summable p-series. PROVED. -/
theorem zetaC2_locMajorant : ∀ z : ℂ, (1 : ℝ) < z.re →
    ∃ r > 0, ∃ u : Nat.Primes → ℝ, Summable u ∧
      ∀ p, ∀ w ∈ Metric.ball z r, ‖zetaEulerLog p w‖ ≤ u p := by
  intro z hz
  set δ : ℝ := (z.re - 1) / 2 with hδ_def
  have hδ : 0 < δ := by rw [hδ_def]; linarith
  refine ⟨δ, hδ, fun p => 3 / 2 * ((p : ℕ) : ℝ) ^ (-(1 + δ)), ?_, ?_⟩
  · have h1 : Summable fun n : ℕ => (n : ℝ) ^ (-(1 + δ)) :=
      Real.summable_nat_rpow.mpr (by linarith)
    exact (h1.subtype _).mul_left _
  · intro p w hw
    have hwre : 1 + δ < w.re := by
      have h1 : |(w - z).re| < δ :=
        lt_of_le_of_lt (Complex.abs_re_le_norm _)
          (by rw [← dist_eq_norm]; exact Metric.mem_ball.mp hw)
      have h2 := (abs_lt.mp h1).1
      rw [Complex.sub_re] at h2
      have h3 : z.re = 1 + 2 * δ := by rw [hδ_def]; ring
      linarith
    have hw0 : 0 < w.re := by linarith
    rw [zetaEulerLog_eq_of_re_pos p hw0, norm_neg]
    have hple : ((p : ℕ) : ℝ) ^ (-w.re) ≤ ((p : ℕ) : ℝ) ^ (-(1 + δ)) :=
      Real.rpow_le_rpow_of_exponent_le
        (by exact_mod_cast p.2.one_lt.le) (by linarith)
    have hhalf : ‖((p : ℕ) : ℂ) ^ (-w)‖ ≤ 1 / 2 := by
      rw [norm_prime_cpow_neg]
      calc ((p : ℕ) : ℝ) ^ (-w.re) ≤ (2 : ℝ) ^ (-w.re) :=
            Real.rpow_le_rpow_of_nonpos (by norm_num)
              (by exact_mod_cast p.2.two_le) (by linarith)
        _ ≤ (2 : ℝ) ^ (-(1 : ℝ)) :=
            Real.rpow_le_rpow_of_exponent_le (by norm_num) (by linarith)
        _ = 1 / 2 := by
            rw [Real.rpow_neg_one]
            norm_num
    have hbound : ‖Complex.log (1 - ((p : ℕ) : ℂ) ^ (-w))‖
        ≤ 3 / 2 * ‖((p : ℕ) : ℂ) ^ (-w)‖ := by
      have h := Complex.norm_log_one_add_half_le_self
        (z := -(((p : ℕ) : ℂ) ^ (-w))) (by rwa [norm_neg])
      rw [norm_neg] at h
      calc ‖Complex.log (1 - ((p : ℕ) : ℂ) ^ (-w))‖
          = ‖Complex.log (1 + -(((p : ℕ) : ℂ) ^ (-w)))‖ := by
            rw [sub_eq_add_neg]
        _ ≤ 3 / 2 * ‖((p : ℕ) : ℂ) ^ (-w)‖ := h
    calc ‖Complex.log (1 - ((p : ℕ) : ℂ) ^ (-w))‖
        ≤ 3 / 2 * ‖((p : ℕ) : ℂ) ^ (-w)‖ := hbound
      _ = 3 / 2 * ((p : ℕ) : ℝ) ^ (-w.re) := by rw [norm_prime_cpow_neg]
      _ ≤ 3 / 2 * ((p : ℕ) : ℝ) ^ (-(1 + δ)) := by
          have := hple
          nlinarith [Real.rpow_nonneg (by positivity : (0:ℝ) ≤ ((p : ℕ) : ℝ)) (-w.re)]

/-! ## C3 data and rows: Rfac, and the gated Hadamard package -/

/-- C3 data — R over the residue-ℝ (trivial) zeros: the entire 1/Γℝ with
the origin's zero divided out (the `zetaPoleUnit` removable pattern;
value 1/2 = the residue reading of s·Γℝ(s) → 2 at 0). Its zeros are
exactly the trivial zeros −2, −4, … — real and nonzero, as
`c3_R_zeros_real` demands (the C3 one-word repair: q^m alone carries the
origin). -/
noncomputable def zetaRfac : ℂ → ℂ :=
  Function.update (fun s => (Gammaℝ s)⁻¹ / s) 0 (2⁻¹ : ℂ)

theorem zetaRfac_apply_of_ne {s : ℂ} (hs : s ≠ 0) :
    zetaRfac s = (Gammaℝ s)⁻¹ / s :=
  Function.update_of_ne hs _ _

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

/-- Rfac is intrinsic: away from 0 by `Gammaℝ_conj`, at 0 the update
value 1/2 is real. PROVED. -/
theorem zetaRfac_intrinsic : IsIntrinsic zetaRfac := by
  intro z
  by_cases hz : z = 0
  · subst hz
    rw [map_zero]
    show zetaRfac 0 = (starRingEnd ℂ) (zetaRfac 0)
    rw [show zetaRfac 0 = (2⁻¹ : ℂ) from Function.update_self .., map_inv₀,
      map_ofNat]
  · have hcz : (starRingEnd ℂ) z ≠ 0 := fun h =>
      hz (by simpa using congrArg (starRingEnd ℂ) h)
    rw [zetaRfac_apply_of_ne hcz, zetaRfac_apply_of_ne hz, map_div₀,
      map_inv₀, Gammaℝ_conj]

/-- Rfac is entire: off 0 the quotient of the entire 1/Γℝ
(`differentiable_Gammaℝ_inv`); across 0 the removable singularity, with
the limit 1/2 read from `Gammaℝ_residue_zero`. PROVED. -/
theorem zetaRfac_entire : Differentiable ℂ zetaRfac := by
  have hoff : ∀ z : ℂ, z ≠ 0 → DifferentiableAt ℂ zetaRfac z := by
    intro z hz
    have h1 : DifferentiableAt ℂ (fun s => (Gammaℝ s)⁻¹ / s) z :=
      (Complex.differentiable_Gammaℝ_inv z).div differentiableAt_id hz
    refine h1.congr_of_eventuallyEq ?_
    filter_upwards [isOpen_compl_singleton.mem_nhds
      (Set.mem_compl_singleton_iff.mpr hz)] with w hw
    exact zetaRfac_apply_of_ne (Set.mem_compl_singleton_iff.mp hw)
  intro z
  by_cases hz : z = 0
  · subst hz
    have han : AnalyticAt ℂ zetaRfac 0 := by
      apply analyticAt_of_differentiable_on_punctured_nhds_of_continuousAt
      · filter_upwards [self_mem_nhdsWithin] with w hw
        exact hoff w hw
      · have htend : Filter.Tendsto (fun s : ℂ => (Gammaℝ s)⁻¹ / s)
            (nhdsWithin 0 {(0 : ℂ)}ᶜ) (nhds (2⁻¹ : ℂ)) := by
          have h1 : Filter.Tendsto (fun s : ℂ => (s * Gammaℝ s)⁻¹)
              (nhdsWithin 0 {(0 : ℂ)}ᶜ) (nhds ((2 : ℂ)⁻¹)) :=
            (Gammaℝ_residue_zero.inv₀ two_ne_zero)
          refine h1.congr ?_
          intro s
          rw [mul_inv, div_eq_mul_inv, mul_comm]
        exact continuousAt_update_same.mpr htend
    exact han.differentiableAt
  · exact hoff z hz

/-- Rfac vanishes exactly at the nonzero reals −2, −4, … — the trivial
zeros as the residue-ℝ divisor (`Gammaℝ_eq_zero_iff`; the origin carries
the nonzero value 1/2). PROVED. -/
theorem zetaRfac_zeros_real : ∀ z : ℂ, zetaRfac z = 0 → z.im = 0 ∧ z ≠ 0 := by
  intro z hz
  by_cases h0 : z = 0
  · subst h0
    rw [show zetaRfac 0 = (2⁻¹ : ℂ) from Function.update_self ..] at hz
    norm_num at hz
  · refine ⟨?_, h0⟩
    rw [zetaRfac_apply_of_ne h0] at hz
    rcases div_eq_zero_iff.mp hz with h | h
    · rw [inv_eq_zero] at h
      obtain ⟨n, hn⟩ := Gammaℝ_eq_zero_iff.mp h
      rw [hn]
      simp
    · exact absurd h h0

/-- **THE GATED ROW — the infinite Weierstrass factorization through the
pole N** (author ruling 2026-07-05; master C3/`prop:weierstrass`, PLAN §8
pole-factor form: classically Hadamard factors (s−1)ζ(s)): there is a
slice-preserving entire g with, over the divisor-repeated enumeration
(ZetaDivisor.lean) at genus 1,
(z−1)·ζ(z) = z⁰·R(z)·e^{g(z)}·∏ₙ 𝓔(·; qₙ) — together with the product's
convergence and §4α majorant. ONE named leaf carrying the whole C3 gap;
`gfac` and its consumer rows are extracted from it by choice, so closing
this row closes Island C1's mathematics. SORRIED (R8 — UNFORMALIZED,
never UNSOUND; the divisor-repeated enumeration keeps it unconditional).
-/
theorem zetaC3_package : ∃ g : ℂ → ℂ, IsIntrinsic g ∧ Differentiable ℂ g ∧
    (∀ z : ℂ, Multipliable fun n => spherePrimary 1 (zetaSphereZero n) z) ∧
    (∀ z : ℂ, z ≠ ((1 : ℝ) : ℂ) → ∃ r > 0, ∃ u : ℕ → ℝ, Summable u ∧
      ∀ n, ∀ w ∈ Metric.ball z r,
        ‖spherePrimary 1 (zetaSphereZero n) w - 1‖ ≤ u n) ∧
    (∀ z : ℂ, z ≠ ((1 : ℝ) : ℂ) →
      (z - ((1 : ℝ) : ℂ)) * riemannZeta z
        = z ^ 0 * zetaRfac z * Complex.exp (g z) *
          ∏' n, spherePrimary 1 (zetaSphereZero n) z) := by
  sorry

/-- C3 data — the Hadamard exponential factor, extracted from the gated
package. -/
noncomputable def zetaGfac : ℂ → ℂ := zetaC3_package.choose

theorem zetaGfac_intrinsic : IsIntrinsic zetaGfac :=
  zetaC3_package.choose_spec.1

theorem zetaGfac_entire : Differentiable ℂ zetaGfac :=
  zetaC3_package.choose_spec.2.1

theorem zetaC3_multipliable :
    ∀ z : ℂ, Multipliable fun n => spherePrimary 1 (zetaSphereZero n) z :=
  zetaC3_package.choose_spec.2.2.1

theorem zetaC3_locMajorant : ∀ z : ℂ, z ≠ ((1 : ℝ) : ℂ) →
    ∃ r > 0, ∃ u : ℕ → ℝ, Summable u ∧
      ∀ n, ∀ w ∈ Metric.ball z r,
        ‖spherePrimary 1 (zetaSphereZero n) w - 1‖ ≤ u n :=
  zetaC3_package.choose_spec.2.2.2.1

theorem zetaC3_factorization : ∀ z : ℂ, z ≠ ((1 : ℝ) : ℂ) →
    (z - ((1 : ℝ) : ℂ)) * riemannZeta z
      = z ^ 0 * zetaRfac z * Complex.exp (zetaGfac z) *
        ∏' n, spherePrimary 1 (zetaSphereZero n) z :=
  zetaC3_package.choose_spec.2.2.2.2

/-! ## The instance -/

/-- **Island C1 — `cor:zeta-section`** (master, verbatim): "ζ_𝕆 is an
A-section (Definition def:A-section): a section of 𝓡 satisfying
(C1)–(C4)." — with m = 0 ("ζ(0) = −½ ≠ 0") and the pole factor
"(q−1)ζ_𝕆 = qᵐ R e^g ∏ₙ 𝓔(·;qₙ) (pole factor at p₀ = 1; classically,
Hadamard factors (s−1)ζ(s))". Stem-encoded per def:A-section; the
octonionic face is `zetaO` with B3 (`zetaO_mem_sliceSphere`,
`riemannZeta_intrinsic`). GATED: consumes the sorried rows above; never
reported "proved" before project-wide 0/0. -/
noncomputable def zetaSection : ASection where
  F := riemannZeta
  intrinsic := riemannZeta_intrinsic
  meromorphic := riemannZeta_meromorphicOn
  pole := 1
  c1_analyticAt := fun z hz =>
    riemannZeta_analyticAt (by rwa [Complex.ofReal_one] at hz)
  c1_simple := by
    rw [Complex.ofReal_one]
    exact riemannZeta_orderAt_one
  ι := Nat.Primes
  ι_infinite := inferInstance
  ℓ := zetaEulerLog
  Ω₀ := 1
  c2_intrinsic := zetaC2_intrinsic
  c2_analyticAt := zetaC2_analyticAt
  c2_zero_free := zetaC2_zero_free
  c2_summable := zetaC2_summable
  c2_euler := zetaC2_euler
  c2_locMajorant := zetaC2_locMajorant
  m := 0
  Rfac := zetaRfac
  gfac := zetaGfac
  genus := fun _ => 1
  sphereZero := zetaSphereZero
  c3_R_intrinsic := zetaRfac_intrinsic
  c3_R_entire := zetaRfac_entire
  c3_R_zeros_real := zetaRfac_zeros_real
  c3_g_intrinsic := zetaGfac_intrinsic
  c3_g_entire := zetaGfac_entire
  c3_sphere_nonreal := zetaSphereZero_im_pos
  c3_multipliable := zetaC3_multipliable
  c3_locMajorant := zetaC3_locMajorant
  c3_lowerEdge := by
    refine ⟨0, fun k => ?_⟩
    have hz := zetaSphereZero_zero k
    have him := zetaSphereZero_im_pos k
    obtain ⟨htriv, hone⟩ := nontrivial_of_im_ne_zero (ne_of_gt him)
    exact (nontrivialZero_re_mem_Ioo hz htriv hone).1.le
  c3_factorization := zetaC3_factorization
  c4_infinite := zetaSphereZero_range_infinite
  valueAtInfinity := ((1 : ℂ) : OnePoint ℂ)
  valueAtInfinity_real := by
    intro z hz
    have h1 : (1 : ℂ) = z := OnePoint.coe_eq_coe.mp hz
    rw [← h1]
    exact Complex.one_im
