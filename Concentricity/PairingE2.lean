/-
Concentricity/PairingE2.lean

E2 — the two-index pairing, argument-principle face (the D4 face of
DESIGN_B2_2_kernels.md, deferred there by ruling and rendered here as far
as the pin supports; B2.1/B2.2 of PLAN_two_index_bricks.md). UNIMPORTED
ARTIFACT (KeystoneAssembly / GreatCircleRoute / LoopAssembly / PhiConversion
precedent): not in the root import list; the root ledger is untouched.
EVERY row in this file is PROVED — no `sorry` anywhere here.

R5 SWEEP OF RECORD (2026-07-06, this session, against the pinned Mathlib):
the pin carries the full circle-integral Cauchy stock
(`Complex.circleIntegral_eq_zero_of_differentiable_on_off_countable`,
`DifferentiableOn.circleIntegral_sub_inv_smul`,
`circleIntegral.integral_congr/integral_add/integral_fun_sum`,
`CircleIntegrable.fun_sum`, `ContinuousOn.circleIntegrable`) and Jensen's
formula for meromorphic functions
(`MeromorphicOn.circleAverage_log_norm`, Analysis/Complex/JensenFormula.lean),
but NO argument principle, NO residue API (grep "argument principle",
"residue" over Mathlib/Analysis: empty of contour-residue content), NO
rectangle-contour or contour-shift machinery, and NO vertical-line limit
stock. The contour face of the E2 engine is therefore rendered on CIRCLES:
the finite-contour residue ledger below is an argument-principle INSTANCE
for the A-section, derived from C3's factorization rather than from a
general residue theorem the pin does not have.

WHAT THE ROWS SAY (the register conversion, master vocabulary): the
K-weighted circle pairing of the continued log-derivative over an
upper-half-plane disk EQUALS the kernel sum over the enumerated zeros the
disk traps — VALUE data (the integral of the section's logarithmic
derivative round a circle) equals DOMAIN data (the divisor read through the
kernel), with the zeros arriving as residues: the OUTPUT register of the
theorem (R4). The liSum of the BL ladder (LiKernel.lean, D0–D3 + mirror +
D2) is then exactly the limit of these contour pairings along any
exhausting family of admissible disks — `liSum_eq_lim_circleIntegral_re`
below, with the existence of such a family PROVED
(`exists_exhausting_disks`).

WHAT REMAINS (the honest pin, R6/R8 — recorded, not sorried): with
the two-sided liSum reduction below, the full remaining mathematics of
the repository's one open node is the single sentence

  ∃ β : ℝ, (∀ a < β, ∀ n ≥ 1, 0 ≤ A.liSum a β n)
         ∧ (∀ a > β, ∀ n ≥ 1, 0 ≤ A.liSum a β n)

— BOTH one-sided families are proved (`liSum_first_side` at β = Ω₀ + 1,
`liSum_second_side` at β = βlo − 1, LiKernel.lean); the open content is
that ONE β serves both sides. The two faces this file does NOT close, named
exactly: (i) the contour SHIFT — connecting the strip-trapping contours to
the zero-free half-space where the Euler side of the proved seed
`stem_identity_logDeriv` converges — needs rectangle/vertical-line residue
bookkeeping with T → ∞ limits, machinery the pin does not carry; (ii) the
SIGN — positivity of the Euler-side pairing at a common β is the C-2 heart
of READ_weil_li_findings.md, not derivable from the fields' shapes alone by
any route recorded so far (every C1-bearing section satisfies every row of
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
UNSOUND (R8); this file carries none.
-/
import Concentricity.LiKernel
import Mathlib.Topology.Algebra.Module.Cardinality

noncomputable section

open Complex

namespace ASection

/-! ## §A — geometry rows: joint C1+C2 consumption

The pole of C1 cannot sit in C2's zero-free half-space: the Euler
majorant bounds the section on a ball at the pole, against the simple
pole's blow-up. Consequences: the half-space is pole-free, and the C3
real skeleton R is nonvanishing there. -/

/-- **The pole lies at or left of the half-space edge** (C1 + C2, jointly):
if `Ω₀ < pole`, the §4α Euler majorant `c2_locMajorant` bounds
`‖F‖ ≤ exp(Σ u)` on a ball at the pole inside the half-space (`c2_euler`),
while C1's simple pole (`c1_simple`, order −1 presentation through the
pin's `meromorphicOrderAt_eq_int_iff`) forces `‖F‖ = ‖z − pole‖⁻¹·‖g‖ → ∞`
there. PROVED. -/
theorem pole_le_upperEdge (A : ASection) : A.pole ≤ A.Ω₀ := by
  by_contra hlt
  rw [not_le] at hlt
  have hpole_half : A.Ω₀ < ((A.pole : ℂ)).re := by simpa using hlt
  obtain ⟨g, hg_an, hg_ne, hev⟩ :=
    (meromorphicOrderAt_eq_int_iff (A.meromorphic (A.pole : ℂ) (Set.mem_univ _))).mp
      A.c1_simple
  obtain ⟨r, hr, u, hu, hbound⟩ := A.c2_locMajorant (A.pole : ℂ) hpole_half
  set ρ : ℝ := min r (A.pole - A.Ω₀) with hρdef
  have hρ : 0 < ρ := lt_min hr (by linarith)
  -- inside the ρ-ball we are in the half-space
  have hhalf : ∀ w : ℂ, dist w (A.pole : ℂ) < ρ → A.Ω₀ < w.re := by
    intro w hw
    have h1 : |(w - (A.pole : ℂ)).re| ≤ ‖w - (A.pole : ℂ)‖ := Complex.abs_re_le_norm _
    have h2 : ‖w - (A.pole : ℂ)‖ < ρ := by rwa [← dist_eq_norm]
    have h3 := (abs_lt.mp (lt_of_le_of_lt h1 h2)).1
    rw [Complex.sub_re, Complex.ofReal_re] at h3
    have h4 : ρ ≤ A.pole - A.Ω₀ := min_le_right _ _
    linarith
  -- the Euler bound on the ball
  set B : ℝ := Real.exp (∑' p, u p) with hBdef
  have hB0 : 0 < B := Real.exp_pos _
  have hFb : ∀ w : ℂ, dist w (A.pole : ℂ) < ρ → ‖A.F w‖ ≤ B := by
    intro w hw
    have hw2 : A.Ω₀ < w.re := hhalf w hw
    have hwr : w ∈ Metric.ball (A.pole : ℂ) r :=
      Metric.mem_ball.mpr (lt_of_lt_of_le hw (min_le_left _ _))
    have hsn : Summable fun p => ‖A.ℓ p w‖ :=
      Summable.of_nonneg_of_le (fun p => norm_nonneg _) (fun p => hbound p w hwr) hu
    rw [A.c2_euler w hw2, Complex.norm_exp]
    refine Real.exp_le_exp.mpr ?_
    calc (∑' p, A.ℓ p w).re ≤ |(∑' p, A.ℓ p w).re| := le_abs_self _
      _ ≤ ‖∑' p, A.ℓ p w‖ := Complex.abs_re_le_norm _
      _ ≤ ∑' p, ‖A.ℓ p w‖ := norm_tsum_le_tsum_norm hsn
      _ ≤ ∑' p, u p := hsn.tsum_le_tsum (fun p => hbound p w hwr) hu
  -- g stays away from 0 near the pole
  set m0 : ℝ := ‖g (A.pole : ℂ)‖ with hm0def
  have hm0 : 0 < m0 := norm_pos_iff.mpr hg_ne
  have hgev : ∀ᶠ w in nhds (A.pole : ℂ), m0 / 2 < ‖g w‖ :=
    (hg_an.continuousAt.norm).eventually_const_lt (by linarith)
  -- package the pole presentation and the g bound into one punctured eventuality
  have hboth : ∀ᶠ w in nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ,
      A.F w = (w - (A.pole : ℂ)) ^ (-1 : ℤ) • g w ∧ m0 / 2 < ‖g w‖ :=
    hev.and (eventually_nhdsWithin_of_eventually_nhds hgev)
  rw [eventually_nhdsWithin_iff, Metric.eventually_nhds_iff] at hboth
  obtain ⟨ε, hε, hball⟩ := hboth
  -- the witness point
  set δ : ℝ := min (min (ε / 2) (ρ / 2)) (m0 / (4 * B)) with hδdef
  have hδ0 : 0 < δ := by
    refine lt_min (lt_min (by linarith) (by linarith)) ?_
    positivity
  set w : ℂ := (A.pole : ℂ) + (δ : ℂ) with hwdef
  have hwd : dist w (A.pole : ℂ) = δ := by
    rw [hwdef, dist_eq_norm, add_sub_cancel_left, Complex.norm_real,
      Real.norm_eq_abs, abs_of_pos hδ0]
  have hwne : w ≠ (A.pole : ℂ) := by
    rw [hwdef]
    intro h
    have h2 : (δ : ℂ) = 0 := by linear_combination h
    exact hδ0.ne' (by exact_mod_cast h2)
  have hδε : δ < ε := lt_of_le_of_lt (le_trans (min_le_left _ _) (min_le_left _ _))
    (by linarith)
  have hδρ : δ < ρ := lt_of_le_of_lt (le_trans (min_le_left _ _) (min_le_right _ _))
    (by linarith)
  obtain ⟨hFw, hgw⟩ := hball (by rwa [hwd]) (Set.mem_compl_singleton_iff.mpr hwne)
  have hFB := hFb w (by rwa [hwd])
  -- compute ‖F w‖ from the pole presentation
  have hnorm : ‖A.F w‖ = δ⁻¹ * ‖g w‖ := by
    rw [hFw, zpow_neg_one, norm_smul, norm_inv]
    congr 2
    rw [hwdef, add_sub_cancel_left, Complex.norm_real, Real.norm_eq_abs,
      abs_of_pos hδ0]
  -- the contradiction: δ⁻¹·(m0/2) ≤ B while δ ≤ m0/(4B)
  have h1 : δ⁻¹ * (m0 / 2) ≤ B := by
    have hinv : (0 : ℝ) ≤ δ⁻¹ := by positivity
    calc δ⁻¹ * (m0 / 2) ≤ δ⁻¹ * ‖g w‖ := mul_le_mul_of_nonneg_left hgw.le hinv
      _ = ‖A.F w‖ := hnorm.symm
      _ ≤ B := hFB
  have h2 : δ ≤ m0 / (4 * B) := min_le_right _ _
  have h3 : m0 / 2 ≤ B * δ := by
    rw [inv_mul_le_iff₀ hδ0] at h1
    linarith
  have h4 : B * δ ≤ B * (m0 / (4 * B)) := mul_le_mul_of_nonneg_left h2 hB0.le
  have h5 : B * (m0 / (4 * B)) = m0 / 4 := by
    field_simp
  linarith

/-- The half-space is pole-free (the reading of `pole_le_upperEdge` at a
point). PROVED. -/
theorem ne_pole_of_re_gt (A : ASection) {z : ℂ} (hz : A.Ω₀ < z.re) :
    z ≠ (A.pole : ℂ) := by
  intro h
  rw [h, Complex.ofReal_re] at hz
  linarith [A.pole_le_upperEdge]

/-- **The C3 real skeleton is nonvanishing on the half-space**: a zero of R
with `Ω₀ < Re z` is real (`c3_R_zeros_real`), so the §8-repaired
factorization would force a stem zero inside C2's zero-free half-space.
PROVED. -/
theorem Rfac_ne_zero_of_re_gt (A : ASection) {z : ℂ} (hz : A.Ω₀ < z.re) :
    A.Rfac z ≠ 0 := by
  intro h0
  have hzp : z ≠ (A.pole : ℂ) := A.ne_pole_of_re_gt hz
  have hfac := A.c3_factorization z hzp
  rw [h0, mul_zero, zero_mul, zero_mul] at hfac
  rcases mul_eq_zero.mp hfac with h | h
  · exact absurd (sub_eq_zero.mp h) hzp
  · exact A.zero_free_on_halfSpace hz h

/-! ## §B — the finite-contour residue ledger

The C3 factorization split at the finite index set a disk traps, the
complement analytic and nonvanishing on the disk, and the Cauchy stock of
the pin: the K-weighted circle pairing of `logDeriv F` reads off the
trapped zeros with weight `2πi·K` each — B2.1's residue ledger in its
summed, integral form, an argument-principle instance for the A-section. -/

/-- Any closed disk holds finitely many enumeration indices: `c3_atN`'s
quadratic point-density sends the terms `1/(1 + ‖ρₖ‖²)` to zero, while
indices with `ρₖ` in a bounded set keep them bounded below. PROVED. -/
theorem indices_in_closedBall_finite (A : ASection) (c : ℂ) (R : ℝ) :
    {k : ℕ | A.sphereZero k ∈ Metric.closedBall c R}.Finite := by
  by_contra hinf
  rw [Set.not_finite] at hinf
  have hbdd : ∀ k ∈ {k : ℕ | A.sphereZero k ∈ Metric.closedBall c R},
      1 / (1 + (‖c‖ + R) ^ 2) ≤ 1 / (1 + ‖A.sphereZero k‖ ^ 2) := by
    intro k hk
    have hdist : dist (A.sphereZero k) c ≤ R := Metric.mem_closedBall.mp hk
    have h1 : ‖A.sphereZero k‖ ≤ ‖c‖ + R := by
      calc ‖A.sphereZero k‖ = ‖(A.sphereZero k - c) + c‖ := by ring_nf
        _ ≤ ‖A.sphereZero k - c‖ + ‖c‖ := norm_add_le _ _
        _ ≤ R + ‖c‖ := by
            rw [← dist_eq_norm]
            exact add_le_add hdist le_rfl
        _ = ‖c‖ + R := add_comm _ _
    have h2 : (0 : ℝ) ≤ ‖c‖ + R := le_trans (norm_nonneg _) h1
    have h3 : ‖A.sphereZero k‖ ^ 2 ≤ (‖c‖ + R) ^ 2 :=
      pow_le_pow_left₀ (norm_nonneg _) h1 2
    gcongr
  have hev : ∀ᶠ k in Filter.atTop,
      1 / (1 + ‖A.sphereZero k‖ ^ 2) < 1 / (1 + (‖c‖ + R) ^ 2) := by
    have h := A.c3_atN.tendsto_cofinite_zero.eventually_lt_const
      (show (0 : ℝ) < 1 / (1 + (‖c‖ + R) ^ 2) by positivity)
    rwa [Nat.cofinite_eq_atTop] at h
  obtain ⟨M, hM⟩ := Filter.eventually_atTop.mp hev
  obtain ⟨k, hkS, hkM⟩ := hinf.exists_gt M
  exact absurd (hbdd k hkS) (not_le.mpr (hM k hkM.le))

/-- The tail of the C3 product with the factors of a finite index set
removed (replaced by 1) — the complement's infinite part. -/
def sphereTail (A : ASection) (s : Finset ℕ) (z : ℂ) : ℂ :=
  ∏' k, (if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) z)

/-- The C3 tprod splits at any finite index set, at any point away from the
pole: head finset times tail. The §4α majorant at the point supplies the
tail's multipliability; `stem_local_form`'s in-ball split (StemFactorization.lean),
rendered pointwise. PROVED. -/
theorem tprod_split_finset (A : ASection) (s : Finset ℕ) {z : ℂ}
    (hzp : z ≠ (A.pole : ℂ)) :
    (∏' k, spherePrimary (A.genus k) (A.sphereZero k) z)
      = (∏ k ∈ s, spherePrimary (A.genus k) (A.sphereZero k) z) *
        A.sphereTail s z := by
  classical
  obtain ⟨r, hr, u, hu, hbound⟩ := A.c3_locMajorant z hzp
  have hupos : ∀ k, 0 ≤ u k := fun k =>
    le_trans (norm_nonneg _) (hbound k z (Metric.mem_ball_self hr))
  have hhead : HasProd
      (fun k => if k ∈ s then spherePrimary (A.genus k) (A.sphereZero k) z else 1)
      (∏ k ∈ s, if k ∈ s then spherePrimary (A.genus k) (A.sphereZero k) z else 1) :=
    hasProd_prod_of_ne_finset_one fun b hb => if_neg hb
  have htail_sum : Summable fun k =>
      ‖(if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) z) - 1‖ := by
    refine Summable.of_nonneg_of_le (fun k => norm_nonneg _) (fun k => ?_) hu
    by_cases hk : k ∈ s
    · simpa [if_pos hk] using hupos k
    · rw [if_neg hk]
      exact hbound k z (Metric.mem_ball_self hr)
  have htail : Multipliable fun k =>
      (if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) z) := by
    have h1 := multipliable_one_add_of_summable (f := fun k =>
      (if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) z) - 1)
      htail_sum
    have h2 : (fun k => 1 + ((if k ∈ s then (1 : ℂ) else
        spherePrimary (A.genus k) (A.sphereZero k) z) - 1))
        = fun k => (if k ∈ s then (1 : ℂ) else
          spherePrimary (A.genus k) (A.sphereZero k) z) := by
      funext k
      ring
    rwa [h2] at h1
  calc (∏' k, spherePrimary (A.genus k) (A.sphereZero k) z)
      = ∏' k, ((if k ∈ s then spherePrimary (A.genus k) (A.sphereZero k) z else 1) *
          (if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) z)) :=
        tprod_congr fun k => by by_cases hk : k ∈ s <;> simp [hk]
    _ = (∏' k, if k ∈ s then spherePrimary (A.genus k) (A.sphereZero k) z else 1) *
          ∏' k, (if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) z) :=
        Multipliable.tprod_mul hhead.multipliable htail
    _ = (∏ k ∈ s, spherePrimary (A.genus k) (A.sphereZero k) z) * A.sphereTail s z := by
        rw [hhead.tprod_eq, sphereTail]
        congr 1
        exact Finset.prod_congr rfl fun k hk => if_pos hk

/-- The `s`-complement of the enumerated head in the §8-repaired C3
factorization: everything except the head's primary factors, carried
against the pole. On `z ≠ pole`, `F = (∏_{k∈s} 𝓔ₖ) · sphereComplement s`
(`eq_head_mul_complement`). -/
def sphereComplement (A : ASection) (s : Finset ℕ) (z : ℂ) : ℂ :=
  z ^ A.m * A.Rfac z * Complex.exp (A.gfac z) * A.sphereTail s z / (z - (A.pole : ℂ))

/-- The stem factors globally as head times complement, away from the pole.
PROVED from the §8-repaired `c3_factorization` and the pointwise split. -/
theorem eq_head_mul_complement (A : ASection) (s : Finset ℕ) {z : ℂ}
    (hzp : z ≠ (A.pole : ℂ)) :
    A.F z = (∏ k ∈ s, spherePrimary (A.genus k) (A.sphereZero k) z) *
      A.sphereComplement s z := by
  have hfac := A.c3_factorization z hzp
  rw [A.tprod_split_finset s hzp] at hfac
  have hdne : z - (A.pole : ℂ) ≠ 0 := sub_ne_zero.mpr hzp
  rw [sphereComplement, mul_div_assoc']
  rw [eq_div_iff hdne]
  linear_combination hfac

/-- The tail is nonvanishing wherever its factors are (the §4α majorant at
the point + `tprod_ne_zero_of_norm_sub_one_le`). PROVED. -/
theorem sphereTail_ne_zero (A : ASection) (s : Finset ℕ) {z : ℂ}
    (hzp : z ≠ (A.pole : ℂ))
    (hne : ∀ k, k ∉ s → spherePrimary (A.genus k) (A.sphereZero k) z ≠ 0) :
    A.sphereTail s z ≠ 0 := by
  classical
  obtain ⟨r, hr, u, hu, hbound⟩ := A.c3_locMajorant z hzp
  have hupos : ∀ k, 0 ≤ u k := fun k =>
    le_trans (norm_nonneg _) (hbound k z (Metric.mem_ball_self hr))
  refine tprod_ne_zero_of_norm_sub_one_le hu (fun k => ?_) (fun k => ?_)
  · by_cases hk : k ∈ s
    · simpa [if_pos hk] using hupos k
    · rw [if_neg hk]
      exact hbound k z (Metric.mem_ball_self hr)
  · by_cases hk : k ∈ s
    · rw [if_pos hk]
      exact one_ne_zero
    · rw [if_neg hk]
      exact hne k hk

/-- The complement is nonvanishing wherever its visible factors are.
PROVED. -/
theorem sphereComplement_ne_zero (A : ASection) (s : Finset ℕ) {z : ℂ}
    (hzp : z ≠ (A.pole : ℂ)) (hz0 : z ≠ 0) (hR : A.Rfac z ≠ 0)
    (hne : ∀ k, k ∉ s → spherePrimary (A.genus k) (A.sphereZero k) z ≠ 0) :
    A.sphereComplement s z ≠ 0 := by
  have htail := A.sphereTail_ne_zero s hzp hne
  exact div_ne_zero (mul_ne_zero (mul_ne_zero (mul_ne_zero (pow_ne_zero _ hz0) hR)
    (Complex.exp_ne_zero _)) htail) (sub_ne_zero.mpr hzp)

/-- The complement is analytic away from the pole: the tail converges
locally normally on the §4α majorant ball (Weierstrass convergence theorem,
the `stem_local_form` scaffolding), the finite factors are entire, and the
pole factor is invertible off the pole. PROVED. -/
theorem sphereComplement_analyticAt (A : ASection) (s : Finset ℕ) {z : ℂ}
    (hzp : z ≠ (A.pole : ℂ)) : AnalyticAt ℂ (A.sphereComplement s) z := by
  classical
  obtain ⟨r, hr, u, hu, hbound⟩ := A.c3_locMajorant z hzp
  have hupos : ∀ k, 0 ≤ u k := fun k =>
    le_trans (norm_nonneg _) (hbound k z (Metric.mem_ball_self hr))
  set ρ : ℝ := min r (dist z (A.pole : ℂ)) with hρdef
  have hρ : 0 < ρ := lt_min hr (dist_pos.mpr hzp)
  have hsub : Metric.ball z ρ ⊆ Metric.ball z r :=
    Metric.ball_subset_ball (min_le_left _ _)
  have hnopole : ∀ w ∈ Metric.ball z ρ, w ≠ (A.pole : ℂ) := by
    intro w hw h
    rw [h] at hw
    have h1 : dist (A.pole : ℂ) z < ρ := Metric.mem_ball.mp hw
    rw [dist_comm] at h1
    exact absurd h1 (not_lt.mpr (min_le_right _ _))
  have hitem : ∀ k : ℕ, Differentiable ℂ fun w =>
      (if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) w) := by
    intro k
    by_cases hk : k ∈ s
    · simp only [if_pos hk]
      exact differentiable_const 1
    · simp only [if_neg hk]
      exact differentiable_spherePrimary _ _
  have hTdiff : DifferentiableOn ℂ
      (fun w => ∏' k, if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) w)
      (Metric.ball z r) := by
    have htend : MultipliableLocallyUniformlyOn
        (fun k w => if k ∈ s then (1 : ℂ) else spherePrimary (A.genus k) (A.sphereZero k) w)
        (Metric.ball z r) := by
      have h1 : MultipliableLocallyUniformlyOn
          (fun k w => 1 + ((if k ∈ s then (1 : ℂ) else
            spherePrimary (A.genus k) (A.sphereZero k) w) - 1))
          (Metric.ball z r) :=
        Summable.multipliableLocallyUniformlyOn_nat_one_add Metric.isOpen_ball hu
          (Filter.Eventually.of_forall fun k w hw => by
            by_cases hk : k ∈ s
            · simpa [if_pos hk] using hupos k
            · rw [if_neg hk]
              exact hbound k w hw)
          (fun k => ((hitem k).sub_const 1).continuous.continuousOn)
      exact MultipliableLocallyUniformlyOn_congr (fun k w _ => by ring) h1
    have h2 := hasProdLocallyUniformlyOn_iff_tendstoLocallyUniformlyOn.mp
      htend.hasProdLocallyUniformlyOn
    exact h2.differentiableOn
      (Filter.Eventually.of_forall fun t => fun w _ =>
        (DifferentiableAt.fun_finsetProd fun i _ =>
          (hitem i).differentiableAt).differentiableWithinAt)
      Metric.isOpen_ball
  have hCdiff : DifferentiableOn ℂ (A.sphereComplement s) (Metric.ball z ρ) := by
    intro w hw
    have hT_at : DifferentiableAt ℂ
        (fun w => ∏' k, if k ∈ s then (1 : ℂ) else
          spherePrimary (A.genus k) (A.sphereZero k) w) w :=
      (hTdiff.mono hsub).differentiableAt (Metric.isOpen_ball.mem_nhds hw)
    have hpow : DifferentiableAt ℂ (fun w : ℂ => w ^ A.m) w := by fun_prop
    have hden : DifferentiableAt ℂ (fun w : ℂ => w - (A.pole : ℂ)) w := by fun_prop
    exact ((((hpow.mul A.c3_R_entire.differentiableAt).mul
      A.c3_g_entire.differentiableAt.cexp).mul hT_at).div hden
      (sub_ne_zero.mpr (hnopole w hw))).differentiableWithinAt
  exact hCdiff.analyticAt (Metric.isOpen_ball.mem_nhds (Metric.mem_ball_self hρ))

/-- The continued log-derivative splits over the head at any point where
the visible factors are nonvanishing: `F′/F = Σ_{k∈s} 𝓔ₖ′/𝓔ₖ + C′/C` — the
per-zero terms of `logDeriv_weierstrass` regrouped against an analytic
complement. PROVED. -/
theorem logDeriv_eq_sum_head_add_complement (A : ASection) (s : Finset ℕ)
    {z : ℂ} (hzp : z ≠ (A.pole : ℂ)) (hz0 : z ≠ 0) (hR : A.Rfac z ≠ 0)
    (hne : ∀ k, spherePrimary (A.genus k) (A.sphereZero k) z ≠ 0) :
    logDeriv A.F z
      = (∑ k ∈ s, logDeriv (spherePrimary (A.genus k) (A.sphereZero k)) z)
        + logDeriv (A.sphereComplement s) z := by
  have hev : A.F =ᶠ[nhds z] fun w =>
      (∏ k ∈ s, spherePrimary (A.genus k) (A.sphereZero k) w) *
        A.sphereComplement s w := by
    filter_upwards [isOpen_compl_singleton.mem_nhds
      (Set.mem_compl_singleton_iff.mpr hzp)] with w hw
    exact A.eq_head_mul_complement s (Set.mem_compl_singleton_iff.mp hw)
  have hprod_ne : (∏ k ∈ s, spherePrimary (A.genus k) (A.sphereZero k) z) ≠ 0 :=
    Finset.prod_ne_zero_iff.mpr fun k _ => hne k
  have hcomp_ne : A.sphereComplement s z ≠ 0 :=
    A.sphereComplement_ne_zero s hzp hz0 hR (fun k _ => hne k)
  have hprod_d : DifferentiableAt ℂ
      (fun w => ∏ k ∈ s, spherePrimary (A.genus k) (A.sphereZero k) w) z :=
    DifferentiableAt.fun_finsetProd fun i _ =>
      (differentiable_spherePrimary _ _).differentiableAt
  have hcomp_d : DifferentiableAt ℂ (A.sphereComplement s) z :=
    (A.sphereComplement_analyticAt s hzp).differentiableAt
  have hkey : logDeriv A.F z = logDeriv (fun w =>
      (∏ k ∈ s, spherePrimary (A.genus k) (A.sphereZero k) w) *
        A.sphereComplement s w) z := by
    simp only [logDeriv_apply]
    rw [hev.deriv_eq, hev.eq_of_nhds]
  rw [hkey, logDeriv_mul z hprod_ne hcomp_ne hprod_d hcomp_d,
    logDeriv_prod (fun k _ => hne k)
      (fun k _ => (differentiable_spherePrimary _ _).differentiableAt)]

end ASection

/-- The primary factor's log-derivative peels its simple pole: away from
the conjugate pair, `𝓔′/𝓔 (z) = (z − a)⁻¹ + u′/u (z)` with `u` the entire
unit of the fiber peeling (StemFactorization.lean). PROVED. -/
theorem logDeriv_spherePrimary_peel (p : ℕ) {a z : ℂ} (ha : a ≠ 0)
    (hz₁ : z ≠ a) (hz₂ : z ≠ starRingEnd ℂ a) :
    logDeriv (spherePrimary p a) z
      = (z - a)⁻¹ + logDeriv (sphereUnit p a) z := by
  have hfun : spherePrimary p a = fun w => (w - a) * sphereUnit p a w :=
    funext fun w => spherePrimary_eq_sub_mul_sphereUnit p ha w
  rw [hfun, logDeriv_mul (f := fun w : ℂ => w - a) (g := sphereUnit p a) z
    (sub_ne_zero.mpr hz₁) (sphereUnit_ne_zero p ha hz₂)
    (by fun_prop) ((differentiable_sphereUnit p a).differentiableAt)]
  congr 1
  rw [logDeriv_apply, deriv_sub_const, deriv_id'']
  rw [one_div]

/-- Analyticity of the log-derivative at a point of analyticity and
nonvanishing. PROVED helper. -/
theorem analyticAt_logDeriv {f : ℂ → ℂ} {z : ℂ} (hf : AnalyticAt ℂ f z)
    (hne : f z ≠ 0) : AnalyticAt ℂ (logDeriv f) z :=
  hf.deriv.div hf hne

namespace ASection

/-- **E2/B2.2 — THE FINITE-CONTOUR RESIDUE LEDGER, PROVED** (the
argument-principle instance for the A-section; the pin has no residue
theorem — this row derives the instance from C3's factorization). For any
circle whose closed disk lies in the open upper half-plane, whose boundary
avoids the enumerated zeros, and any weight `g` analytic on the closed
disk: the `g`-weighted circle pairing of the continued log-derivative
equals `2πi` times the sum of `g` over the enumerated zeros the disk traps
(with the enumeration's multiplicity, each index its own term).

VALUE register (the integral of the section's logarithmic derivative — the
one meromorphic object whose Euler expression lives on the half-space)
equals DOMAIN register (the divisor, read through the weight): the zeros
arrive as residues, the theorem's OUTPUT (R4). -/
theorem circleIntegral_mul_logDeriv (A : ASection) {c : ℂ} {R : ℝ}
    (hR : 0 < R) {g : ℂ → ℂ}
    (hg : ∀ z ∈ Metric.closedBall c R, AnalyticAt ℂ g z)
    (hup : ∀ z ∈ Metric.closedBall c R, 0 < z.im)
    (hsph : ∀ k, A.sphereZero k ∉ Metric.sphere c R)
    {s : Finset ℕ} (hs : ∀ k, k ∈ s ↔ A.sphereZero k ∈ Metric.ball c R) :
    (∮ z in C(c, R), g z * logDeriv A.F z)
      = (2 * (Real.pi : ℂ) * Complex.I) * ∑ k ∈ s, g (A.sphereZero k) := by
  classical
  have hρ0 : ∀ k, A.sphereZero k ≠ 0 := by
    intro k h
    have him := A.c3_sphere_nonreal k
    rw [h] at him
    simp at him
  -- pointwise facts at points of the closed disk
  have hfacts : ∀ z ∈ Metric.closedBall c R, z ≠ (A.pole : ℂ) ∧ z ≠ 0 ∧
      A.Rfac z ≠ 0 ∧ ∀ k, z ≠ starRingEnd ℂ (A.sphereZero k) := by
    intro z hz
    have hzim : 0 < z.im := hup z hz
    refine ⟨?_, ?_, ?_, ?_⟩
    · intro h
      rw [h] at hzim
      simp at hzim
    · intro h
      rw [h] at hzim
      simp at hzim
    · intro h
      exact absurd (A.c3_R_zeros_real z h).1 (ne_of_gt hzim)
    · intro k h
      have h2 : z.im = -(A.sphereZero k).im := by
        rw [h, Complex.conj_im]
      have := A.c3_sphere_nonreal k
      linarith
  -- nonvanishing of every primary factor at boundary points
  have hbne : ∀ z ∈ Metric.sphere c R, ∀ k,
      spherePrimary (A.genus k) (A.sphereZero k) z ≠ 0 := by
    intro z hz k
    have hzcb : z ∈ Metric.closedBall c R := Metric.sphere_subset_closedBall hz
    refine spherePrimary_ne_zero _ (hρ0 k) ?_ ((hfacts z hzcb).2.2.2 k)
    intro h
    exact hsph k (h ▸ hz)
  -- nonvanishing of tail factors at interior points
  have hine : ∀ z ∈ Metric.closedBall c R, ∀ k, k ∉ s →
      spherePrimary (A.genus k) (A.sphereZero k) z ≠ 0 := by
    intro z hz k hk
    refine spherePrimary_ne_zero _ (hρ0 k) ?_ ((hfacts z hz).2.2.2 k)
    intro h
    rcases Metric.mem_closedBall.mp hz |>.lt_or_eq with hlt | heq
    · exact hk ((hs k).mpr (h ▸ Metric.mem_ball.mpr hlt))
    · exact hsph k (h ▸ Metric.mem_sphere.mpr heq)
  -- the regular rest of the decomposition
  set Hrest : ℂ → ℂ := fun z =>
    (∑ k ∈ s, logDeriv (sphereUnit (A.genus k) (A.sphereZero k)) z)
      + logDeriv (A.sphereComplement s) z with hHrest_def
  -- Hrest is analytic at every point of the closed disk
  have hHrest_an : ∀ z ∈ Metric.closedBall c R, AnalyticAt ℂ Hrest z := by
    intro z hz
    obtain ⟨hzp, hz0, hRne, hconj⟩ := hfacts z hz
    have h1 : AnalyticAt ℂ
        (fun w => ∑ k ∈ s, logDeriv (sphereUnit (A.genus k) (A.sphereZero k)) w) z :=
      Finset.analyticAt_fun_sum s fun k _ =>
        analyticAt_logDeriv ((differentiable_sphereUnit (A.genus k) (A.sphereZero k)).analyticAt z)
          (sphereUnit_ne_zero _ (hρ0 k) (hconj k))
    have h2 : AnalyticAt ℂ (logDeriv (A.sphereComplement s)) z :=
      analyticAt_logDeriv (A.sphereComplement_analyticAt s hzp)
        (A.sphereComplement_ne_zero s hzp hz0 hRne (hine z hz))
    exact h1.add h2
  -- the pointwise decomposition on the circle
  have hEq : Set.EqOn (fun z => g z * logDeriv A.F z)
      (fun z => (∑ k ∈ s, g z * (z - A.sphereZero k)⁻¹) + g z * Hrest z)
      (Metric.sphere c R) := by
    intro z hz
    have hzcb : z ∈ Metric.closedBall c R := Metric.sphere_subset_closedBall hz
    obtain ⟨hzp, hz0, hRne, hconj⟩ := hfacts z hzcb
    have hallne : ∀ k, spherePrimary (A.genus k) (A.sphereZero k) z ≠ 0 :=
      hbne z hz
    have hzρ : ∀ k, z ≠ A.sphereZero k := by
      intro k h
      exact hsph k (h ▸ hz)
    have hsplit := A.logDeriv_eq_sum_head_add_complement s hzp hz0 hRne hallne
    have hpeel : ∀ k ∈ s, logDeriv (spherePrimary (A.genus k) (A.sphereZero k)) z
        = (z - A.sphereZero k)⁻¹
          + logDeriv (sphereUnit (A.genus k) (A.sphereZero k)) z :=
      fun k _ => logDeriv_spherePrimary_peel _ (hρ0 k) (hzρ k) (hconj k)
    show g z * logDeriv A.F z
      = (∑ k ∈ s, g z * (z - A.sphereZero k)⁻¹) + g z * Hrest z
    rw [hsplit, Finset.sum_congr rfl hpeel, Finset.sum_add_distrib, hHrest_def]
    rw [← Finset.mul_sum]
    ring
  -- integrability of the pieces on the circle
  have hg_cont : ContinuousOn g (Metric.sphere c R) := fun z hz =>
    ((hg z (Metric.sphere_subset_closedBall hz)).continuousAt).continuousWithinAt
  have hint_head : ∀ k ∈ s,
      CircleIntegrable (fun z => g z * (z - A.sphereZero k)⁻¹) c R := by
    intro k _
    refine ContinuousOn.circleIntegrable hR.le ?_
    refine hg_cont.mul (ContinuousOn.inv₀
      ((continuousOn_id.sub continuousOn_const)) ?_)
    intro z hz
    refine sub_ne_zero.mpr ?_
    intro h
    exact hsph k (h ▸ hz)
  have hint_rest : CircleIntegrable (fun z => g z * Hrest z) c R := by
    refine ContinuousOn.circleIntegrable hR.le ?_
    intro z hz
    have hzcb : z ∈ Metric.closedBall c R := Metric.sphere_subset_closedBall hz
    exact (((hg z hzcb).mul (hHrest_an z hzcb)).continuousAt).continuousWithinAt
  -- the integral splits
  rw [circleIntegral.integral_congr hR.le hEq,
    circleIntegral.integral_add (CircleIntegrable.fun_sum s hint_head) hint_rest,
    circleIntegral.integral_fun_sum hint_head]
  -- each head term is a Cauchy integral
  have hgd : DifferentiableOn ℂ g (Metric.closedBall c R) := fun w hw =>
    ((hg w hw).differentiableAt).differentiableWithinAt
  have hhead_eval : ∀ k ∈ s, (∮ z in C(c, R), g z * (z - A.sphereZero k)⁻¹)
      = (2 * (Real.pi : ℂ) * Complex.I) * g (A.sphereZero k) := by
    intro k hk
    have hmem : A.sphereZero k ∈ Metric.ball c R := (hs k).mp hk
    have hC := hgd.circleIntegral_sub_inv_smul hmem
    rw [smul_eq_mul] at hC
    rw [← hC]
    refine circleIntegral.integral_congr hR.le fun z _ => ?_
    rw [smul_eq_mul, mul_comm]
  -- the rest integrates to zero (Cauchy–Goursat on the disk)
  have hrest_zero : (∮ z in C(c, R), g z * Hrest z) = 0 := by
    refine Complex.circleIntegral_eq_zero_of_differentiable_on_off_countable hR.le
      Set.countable_empty ?_ ?_
    · intro z hz
      exact (((hg z hz).mul (hHrest_an z hz)).continuousAt).continuousWithinAt
    · intro z hz
      have hzcb : z ∈ Metric.closedBall c R :=
        Metric.ball_subset_closedBall hz.1
      exact ((hg z hzcb).mul (hHrest_an z hzcb)).differentiableAt
  rw [hrest_zero, add_zero, Finset.sum_congr rfl hhead_eval, ← Finset.mul_sum]

/-- The head finsets exist: the canonical finset of indices a disk traps.
PROVED from `indices_in_closedBall_finite`. -/
theorem exists_head_finset (A : ASection) (c : ℂ) (R : ℝ) :
    ∃ s : Finset ℕ, ∀ k, k ∈ s ↔ A.sphereZero k ∈ Metric.ball c R := by
  have hfin : {k : ℕ | A.sphereZero k ∈ Metric.ball c R}.Finite :=
    (A.indices_in_closedBall_finite c R).subset fun k hk =>
      Metric.ball_subset_closedBall hk
  exact ⟨hfin.toFinset, fun k => hfin.mem_toFinset⟩

/-- **The kernel instance of the ledger**: the anchor-pair Möbius kernel of
the BL ladder (LiKernel.lean) is analytic off the real axis — its anchors
are real — so on every admissible upper-half disk the K-weighted pairing
reads off the trapped zeros: `∮ K·F′/F = 2πi·Σ_{trapped} K(ρₖ)`. The
two-index pairing (kernel index n, divisor index k) in integral form.
PROVED. -/
theorem circleIntegral_liKernel_logDeriv (A : ASection) (n : ℕ) (a β : ℝ)
    {c : ℂ} {R : ℝ} (hR : 0 < R)
    (hup : ∀ z ∈ Metric.closedBall c R, 0 < z.im)
    (hsph : ∀ k, A.sphereZero k ∉ Metric.sphere c R)
    {s : Finset ℕ} (hs : ∀ k, k ∈ s ↔ A.sphereZero k ∈ Metric.ball c R) :
    (∮ z in C(c, R), liKernel n a β z * logDeriv A.F z)
      = (2 * (Real.pi : ℂ) * Complex.I) *
          ∑ k ∈ s, liKernel n a β (A.sphereZero k) := by
  refine A.circleIntegral_mul_logDeriv hR (fun z hz => ?_) hup hsph hs
  have hzim : z.im ≠ 0 := ne_of_gt (hup z hz)
  have hden : z - (2 * (β : ℂ) - (a : ℂ)) ≠ 0 := liRatio_den_ne_zero hzim a β
  have h1 : AnalyticAt ℂ (fun w => (w - (a : ℂ)) / (w - (2 * (β : ℂ) - (a : ℂ)))) z :=
    (analyticAt_id.sub analyticAt_const).div
      (analyticAt_id.sub analyticAt_const) hden
  exact analyticAt_const.sub (h1.pow n)

/-- The zero-free half-space traps nothing: on circles whose closed disk
sits in `{Re > Ω₀}`, every weighted pairing of the log-derivative vanishes
(C2's zero-freeness + `pole_le_upperEdge` make `logDeriv F` analytic on the
disk; Cauchy–Goursat). The ledger's boundary case: the value register with
an empty domain register. PROVED. -/
theorem circleIntegral_mul_logDeriv_halfSpace (A : ASection) {c : ℂ} {R : ℝ}
    (hR : 0 ≤ R) {g : ℂ → ℂ}
    (hg : ∀ z ∈ Metric.closedBall c R, AnalyticAt ℂ g z)
    (hhalf : ∀ z ∈ Metric.closedBall c R, A.Ω₀ < z.re) :
    (∮ z in C(c, R), g z * logDeriv A.F z) = 0 := by
  have han : ∀ z ∈ Metric.closedBall c R, AnalyticAt ℂ (fun w => g w * logDeriv A.F w) z := by
    intro z hz
    have hzΩ : A.Ω₀ < z.re := hhalf z hz
    have hFan : AnalyticAt ℂ A.F z := A.c1_analyticAt z (A.ne_pole_of_re_gt hzΩ)
    exact (hg z hz).mul (analyticAt_logDeriv hFan (A.zero_free_on_halfSpace hzΩ))
  refine Complex.circleIntegral_eq_zero_of_differentiable_on_off_countable hR
    Set.countable_empty ?_ ?_
  · exact fun z hz => ((han z hz).continuousAt).continuousWithinAt
  · exact fun z hz => (han z (Metric.ball_subset_closedBall hz.1)).differentiableAt

/-- **B2.2's drafted pairing shape, landed**: on circles in the overlap the
two expansions of the one stem pair equally against any weight — the seed
`stem_identity_logDeriv` under the integral sign. The Euler side and the
five-term Weierstrass side agree as circle pairings wherever both converge;
the ledger above is what the SAME integral computes once the contour
travels where only the Weierstrass side lives. PROVED. -/
theorem circleIntegral_pairing_halfSpace (A : ASection) {c : ℂ} {R : ℝ}
    (hR : 0 ≤ R) (g : ℂ → ℂ)
    (hhalf : ∀ z ∈ Metric.closedBall c R, A.Ω₀ < z.re)
    (h0 : ∀ z ∈ Metric.sphere c R, z ≠ 0) :
    (∮ z in C(c, R), g z * ∑' p : A.ι, deriv (A.ℓ p) z)
      = ∮ z in C(c, R), g z *
          (-(1 / (z - (A.pole : ℂ))) + (A.m : ℂ) / z
            + deriv A.Rfac z / A.Rfac z + deriv A.gfac z
            + ∑' n, deriv (spherePrimary (A.genus n) (A.sphereZero n)) z /
                spherePrimary (A.genus n) (A.sphereZero n) z) := by
  refine circleIntegral.integral_congr hR fun z hz => ?_
  have hzcb : z ∈ Metric.closedBall c R := Metric.sphere_subset_closedBall hz
  have hzΩ : A.Ω₀ < z.re := hhalf z hzcb
  congr 1
  exact A.stem_identity_logDeriv z hzΩ (A.ne_pole_of_re_gt hzΩ) (h0 z hz)
    (A.zero_free_on_halfSpace hzΩ) (A.Rfac_ne_zero_of_re_gt hzΩ)

/-! ## §C — liSum as the limit of contour pairings (the D4 readout)

The BL ladder's kernel sums (LiKernel.lean) are exactly the limits of the
finite-contour pairings along any exhausting family of admissible disks:
the ledger's finite sums tend to `liSum` because the sum is genuinely
summable (D0). The existence of an exhausting family is PROVED below —
horocycle-style disks centered on the imaginary axis. -/

/-- Head sums along any eventually-covering finset sequence tend to the
full kernel sum — `liSum_summable` (D0) read through the `HasSum` filter.
PROVED. -/
theorem tendsto_head_sums_liSum (A : ASection) (a β : ℝ) (n : ℕ)
    {s : ℕ → Finset ℕ} (hcover : ∀ k, ∀ᶠ j in Filter.atTop, k ∈ s j) :
    Filter.Tendsto
      (fun j => ∑ k ∈ s j, 2 * (liKernel n a β (A.sphereZero k)).re)
      Filter.atTop (nhds (A.liSum a β n)) := by
  have hsum := (A.liSum_summable a β n).hasSum
  have hfin : Filter.Tendsto s Filter.atTop Filter.atTop := by
    rw [Filter.atTop_finset_eq_iInf]
    simp only [Filter.tendsto_iInf, Filter.tendsto_principal]
    intro k
    filter_upwards [hcover k] with j hj
    simpa [Finset.singleton_subset_iff] using hj
  exact hsum.comp hfin

/-- The ledger's readout in the ladder's own real coordinates: the doubled
real-part head sums are the real parts of the normalized contour pairings.
PROVED from the kernel ledger. -/
theorem head_kernel_sum_eq_circleIntegral_re (A : ASection) (n : ℕ) (a β : ℝ)
    {c : ℂ} {R : ℝ} (hR : 0 < R)
    (hup : ∀ z ∈ Metric.closedBall c R, 0 < z.im)
    (hsph : ∀ k, A.sphereZero k ∉ Metric.sphere c R)
    {s : Finset ℕ} (hs : ∀ k, k ∈ s ↔ A.sphereZero k ∈ Metric.ball c R) :
    ∑ k ∈ s, 2 * (liKernel n a β (A.sphereZero k)).re
      = ((((Real.pi : ℂ) * Complex.I)⁻¹ *
          ∮ z in C(c, R), liKernel n a β z * logDeriv A.F z)).re := by
  rw [A.circleIntegral_liKernel_logDeriv n a β hR hup hsph hs]
  have hπ : ((Real.pi : ℂ)) ≠ 0 := Complex.ofReal_ne_zero.mpr Real.pi_ne_zero
  have hI : Complex.I ≠ 0 := Complex.I_ne_zero
  have hcalc : (((Real.pi : ℂ) * Complex.I)⁻¹ *
      ((2 * (Real.pi : ℂ) * Complex.I) *
        ∑ k ∈ s, liKernel n a β (A.sphereZero k)))
      = 2 * ∑ k ∈ s, liKernel n a β (A.sphereZero k) := by
    field_simp
  rw [hcalc]
  rw [show ((2 : ℂ) * ∑ k ∈ s, liKernel n a β (A.sphereZero k)).re
      = 2 * (∑ k ∈ s, liKernel n a β (A.sphereZero k)).re by
    simp [Complex.mul_re]]
  rw [Complex.re_sum, Finset.mul_sum]

/-- **The D4 readout — liSum IS the limit of contour pairings** (the
explicit-formula face's value-register rendering): along any exhausting
family of admissible upper-half disks, the normalized K-weighted circle
pairings of the continued log-derivative converge to the BL ladder's
kernel sum. Everything on the domain side of D2's iff is hereby expressed
in the VALUE register — contour integrals of `K · F′/F`. PROVED. -/
theorem liSum_eq_lim_circleIntegral_re (A : ASection) (a β : ℝ) (n : ℕ)
    {c : ℕ → ℂ} {R : ℕ → ℝ} (hR : ∀ j, 0 < R j)
    (hup : ∀ j, ∀ z ∈ Metric.closedBall (c j) (R j), 0 < z.im)
    (hsph : ∀ j k, A.sphereZero k ∉ Metric.sphere (c j) (R j))
    (hcover : ∀ k, ∀ᶠ j in Filter.atTop,
      A.sphereZero k ∈ Metric.ball (c j) (R j)) :
    Filter.Tendsto
      (fun j => ((((Real.pi : ℂ) * Complex.I)⁻¹ *
        ∮ z in C(c j, R j), liKernel n a β z * logDeriv A.F z)).re)
      Filter.atTop (nhds (A.liSum a β n)) := by
  have hSfin : ∀ j, {k | A.sphereZero k ∈ Metric.ball (c j) (R j)}.Finite :=
    fun j => (A.indices_in_closedBall_finite (c j) (R j)).subset
      fun k hk => Metric.ball_subset_closedBall hk
  have hs_mem : ∀ j k, k ∈ (hSfin j).toFinset ↔
      A.sphereZero k ∈ Metric.ball (c j) (R j) :=
    fun j k => (hSfin j).mem_toFinset
  have hcov : ∀ k, ∀ᶠ j in Filter.atTop, k ∈ (hSfin j).toFinset :=
    fun k => (hcover k).mono fun j hj => (hs_mem j k).mpr hj
  have htend := A.tendsto_head_sums_liSum a β n hcov
  refine htend.congr fun j => ?_
  exact A.head_kernel_sum_eq_circleIntegral_re n a β (hR j) (hup j) (hsph j)
    (hs_mem j)

/-- **The exhausting disks exist**: horocycle-style disks centered on the
imaginary axis — center `(j+1)·i`, radius inside `((j+1) − 2/(j+2),
(j+1) − 1/(j+2))` chosen off the countable set of zero-hitting radii
(`Set.Countable.dense_compl`). Their closed disks stay in the open upper
half-plane, their boundaries avoid the divisor, and every fixed point of
the upper half-plane — in particular every enumerated zero — is eventually
trapped. PROVED. -/
theorem exists_exhausting_disks (A : ASection) :
    ∃ (c : ℕ → ℂ) (R : ℕ → ℝ), (∀ j, 0 < R j) ∧
      (∀ j, ∀ z ∈ Metric.closedBall (c j) (R j), 0 < z.im) ∧
      (∀ j k, A.sphereZero k ∉ Metric.sphere (c j) (R j)) ∧
      (∀ k, ∀ᶠ j in Filter.atTop,
        A.sphereZero k ∈ Metric.ball (c j) (R j)) := by
  classical
  -- the centers
  set ctr : ℕ → ℂ := fun j => ((j : ℝ) + 1 : ℝ) * Complex.I with hctr_def
  have hctr_im : ∀ j, (ctr j).im = (j : ℝ) + 1 := by
    intro j
    simp [hctr_def]
  have hctr_re : ∀ j, (ctr j).re = 0 := by
    intro j
    simp [hctr_def]
  -- the radii: in the window, avoiding the countable zero-distance set
  have hch : ∀ j : ℕ, ∃ r : ℝ,
      r ∈ (Set.range fun k => dist (A.sphereZero k) (ctr j))ᶜ ∧
      r ∈ Set.Ioo ((j : ℝ) + 1 - 2 / ((j : ℝ) + 2)) ((j : ℝ) + 1 - 1 / ((j : ℝ) + 2)) := by
    intro j
    have hj2 : (0 : ℝ) < (j : ℝ) + 2 := by positivity
    refine (Set.Countable.dense_compl ℝ (Set.countable_range _)).exists_mem_open
      isOpen_Ioo ⟨(j : ℝ) + 1 - 3 / 2 / ((j : ℝ) + 2), ?_⟩
    constructor
    · rw [sub_lt_sub_iff_left]
      rw [div_lt_div_iff_of_pos_right hj2]
      norm_num
    · rw [sub_lt_sub_iff_left]
      rw [div_lt_div_iff_of_pos_right hj2]
      norm_num
  choose Rad hRadmem hRadIoo using hch
  have hRlow : ∀ j : ℕ, (j : ℝ) + 1 - 2 / ((j : ℝ) + 2) < Rad j := fun j => (hRadIoo j).1
  have hRhigh : ∀ j : ℕ, Rad j < (j : ℝ) + 1 - 1 / ((j : ℝ) + 2) := fun j => (hRadIoo j).2
  have hRpos : ∀ j, 0 < Rad j := by
    intro j
    have h1 := hRlow j
    have hj2 : (0 : ℝ) < (j : ℝ) + 2 := by positivity
    have h2 : 2 / ((j : ℝ) + 2) ≤ 1 := by
      rw [div_le_one hj2]
      have : (0 : ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
      linarith
    have : (0 : ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
    linarith
  refine ⟨ctr, Rad, hRpos, ?_, ?_, ?_⟩
  · -- upper half-plane
    intro j z hz
    have hd : dist z (ctr j) ≤ Rad j := Metric.mem_closedBall.mp hz
    have him : |(z - ctr j).im| ≤ ‖z - ctr j‖ := Complex.abs_im_le_norm _
    rw [← dist_eq_norm] at him
    have h1 : |z.im - ((j : ℝ) + 1)| ≤ Rad j := by
      rw [Complex.sub_im, hctr_im j] at him
      linarith
    have h2 := (abs_le.mp h1).1
    have hj2 : (0 : ℝ) < (j : ℝ) + 2 := by positivity
    have h3 : (0 : ℝ) < 1 / ((j : ℝ) + 2) := by positivity
    have h4 := hRhigh j
    linarith
  · -- boundary avoidance
    intro j k hmem
    exact hRadmem j ⟨k, Metric.mem_sphere.mp hmem⟩
  · -- coverage
    intro k
    set w : ℂ := A.sphereZero k with hw_def
    have hwim : 0 < w.im := A.c3_sphere_nonreal k
    obtain ⟨J, hJ⟩ := exists_nat_ge ((‖w‖ ^ 2 + 4) / (2 * w.im))
    rw [Filter.eventually_atTop]
    refine ⟨J, fun j hj => ?_⟩
    rw [Metric.mem_ball]
    have hj2 : (0 : ℝ) < (j : ℝ) + 2 := by positivity
    have hjJ : (J : ℝ) ≤ (j : ℝ) := Nat.cast_le.mpr hj
    -- the key quantity: q := (j+1) − 2/(j+2), with 0 ≤ q < Rad j
    set q : ℝ := (j : ℝ) + 1 - 2 / ((j : ℝ) + 2) with hq_def
    have h0j : (0 : ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
    have hfrac_le : 2 / ((j : ℝ) + 2) ≤ 1 := by
      rw [div_le_one hj2]
      linarith
    have hq_nonneg : 0 ≤ q := by
      rw [hq_def]
      linarith
    have hqR : q < Rad j := hRlow j
    -- distance-squared comparison
    have hkey : dist w (ctr j) ^ 2 < q ^ 2 := by
      have hd2 : dist w (ctr j) ^ 2
          = w.re * w.re + (w.im - ((j : ℝ) + 1)) * (w.im - ((j : ℝ) + 1)) := by
        rw [dist_eq_norm, ← Complex.normSq_eq_norm_sq, Complex.normSq_apply,
          Complex.sub_re, Complex.sub_im, hctr_re j, hctr_im j, sub_zero]
      have hnormsq : ‖w‖ ^ 2 = w.re * w.re + w.im * w.im := by
        rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]
      -- from j ≥ J: 2j·im w ≥ ‖w‖² + 4
      have h1 : (‖w‖ ^ 2 + 4) / (2 * w.im) ≤ (j : ℝ) := le_trans hJ hjJ
      have h2 : ‖w‖ ^ 2 + 4 ≤ (j : ℝ) * (2 * w.im) := by
        rwa [div_le_iff₀ (by positivity)] at h1
      have hfrac_pos : (0 : ℝ) < 2 / ((j : ℝ) + 2) := by positivity
      have hfrac_mul : 2 / ((j : ℝ) + 2) * ((j : ℝ) + 2) = 2 :=
        div_mul_cancel₀ _ hj2.ne'
      rw [hd2, hq_def]
      nlinarith [hwim, hnormsq, hfrac_pos, hfrac_mul, h2,
        sq_nonneg (2 / ((j : ℝ) + 2))]
    have hlt := lt_of_pow_lt_pow_left₀ 2 hq_nonneg hkey
    linarith [hqR]

/-- **The capstone of the rendering — every kernel sum of the BL ladder has
a contour representation, unconditionally**: for every A-section, every
anchor pair and every n, there is an exhausting family of admissible
upper-half disks along which the normalized `K`-weighted circle pairings of
`logDeriv F` converge to `liSum a β n`. The D2 sentence's every summand now
reads in the VALUE register. PROVED (`exists_exhausting_disks` +
`liSum_eq_lim_circleIntegral_re`). -/
theorem exists_liSum_contour_representation (A : ASection) (a β : ℝ) (n : ℕ) :
    ∃ (c : ℕ → ℂ) (R : ℕ → ℝ), (∀ j, 0 < R j) ∧
      (∀ j, ∀ z ∈ Metric.closedBall (c j) (R j), 0 < z.im) ∧
      Filter.Tendsto
        (fun j => ((((Real.pi : ℂ) * Complex.I)⁻¹ *
          ∮ z in C(c j, R j), liKernel n a β z * logDeriv A.F z)).re)
        Filter.atTop (nhds (A.liSum a β n)) := by
  obtain ⟨c, R, hR, hup, hsph, hcover⟩ := A.exists_exhausting_disks
  exact ⟨c, R, hR, hup, A.liSum_eq_lim_circleIntegral_re a β n hR hup hsph hcover⟩

/-! ## §D — the drive at the theorem: the exact bridge, and the residual

the two-sided liSum reduction is the machine-checked reduction of the
repository's one open node to the single ∃β sentence, in this file's own
vocabulary — the proved D2 chain +
`stem_zero_of_sphereZero`/`c3_sphere_nonreal`. Both one-sided families are
proved at their own β (`liSum_first_side` at Ω₀ + 1, `liSum_second_side`
at βlo − 1); the resisting goal of the E2 route, exactly:

  ⊢ ∃ β : ℝ, (∀ a < β, ∀ n ≥ 1, 0 ≤ A.liSum a β n)
           ∧ (∀ a > β, ∀ n ≥ 1, 0 ≤ A.liSum a β n)

The ledger above expresses every `liSum` through contour pairings of
`K·F′/F`; the seed expresses `F′/F` through the Euler family on the
half-space. The two faces that would join them — the contour shift across
the strip (no rectangle/limit stock in the pin) and the SIGN of the
Euler-side pairing at one common β (the C-2 heart; no producer in the
fields) — are the named remainder. No row of this file is consumed by the
root; nothing here claims the node. -/

end ASection
