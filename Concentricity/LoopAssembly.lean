/-
Concentricity/LoopAssembly.lean

WORKING ARTIFACT — the loop-assembly closer, DUAL CURATION (author's
dispatch, 2026-07-06: two draft shapes of the one idea, both rendered as
far as they go; lake decides). NOT imported by the root; per the
KeystoneAssembly / GreatCircleRoute precedent the two `sorry`s below are
ROUTE RECEIPTS at the exact resisting goals (R6), not queue items — the
imported ledger (2/0, the welded pair) is untouched.

WHAT IS PROVED HERE (all rows below the receipts' section are consumed by
the receipts as PROVED possessions; helpers are never sorried, R8):

§A — the σ-closure rows: the stem-honest content of GPVwind Cor 5.13's
closure clause ("If it exists, the lift is a loop") — the endpoint defect
of a log-continuation is a datum of the LOOP, not the lift
(`winding_defect_lift_independent`); once one lift closes, every lift
closes (`winding_loop_closed`); and the LEVEL face of closure is
unconditional (`winding_loop_defect_level_zero`) — the defect is 2πiℤ,
purely a height datum: "all multiplicity in the fibre lies in the winding
direction ([Cor. 5.21]{GPVwind}), none in the level" (master, placement
paragraph). The σ/σᶜ criterion itself (WHICH loops lift) stays octonionic
— the recorded GAP of `winding_loop_defect` (Toolkit.lean) stands: the
direction flips of GPVwind Def 5.2 have no stem carrier (Rem 2.1).

§B — `lem:exp-degenerate`, stem fibre rows: the fibre over −r is the one
level log r with odd-π heights (`exp_eq_neg_real_iff`, iff form);
`exp_fibre_level`; `exp_fibre_height_band`.

§C — the assembly rows: C1's cone at N (`pole_cone_tendsto`,
`pole_cone_chart`, `pole_cone_eps_delta` — Draft I's ε–δ correspondence,
PROVED); C3's degenerate encounters (`neg_reals_swept_near_sphereZero` —
near an enumerated zero the stem's values sweep every small negative
real); and the SHARED LADDER (`shared_ladder_encounters`): for every ε
the two zeros' encounter data share ONE value −r, hence ONE ladder of
`lem:exp-degenerate` fibre data — one level log r exactly, heights band
data only.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.Theorem
import Concentricity.StemFactorization
import Concentricity.LiKernel
import Mathlib.Analysis.Complex.OpenMapping

noncomputable section

open Filter

/-! ## §A — the σ-closure rows (GPVwind Cor 5.13, closure clause, stem form) -/

/-- **The defect is the loop's, not the lift's** (PROVED): any two
log-continuations of the one nonvanishing path have the same endpoint
defect. Derived over the proved `winding_lift_unique` (Toolkit.lean): the
initial-value shift `γ₂ + (γ₁ 0 − γ₂ 0)` is again a lift (the shift
exponentiates to 1) sharing γ₁'s initial value, hence IS γ₁. This is the
well-definedness of the winding datum that GPVwind's σ-apparatus computes
(Def 5.7/5.19; SOURCES/GPVwind.md). -/
theorem winding_defect_lift_independent (γ : C(unitInterval, ℂ)) (hγ : ∀ t, γ t ≠ 0)
    (γ₁ γ₂ : C(unitInterval, ℂ)) (h₁ : ∀ t, Complex.exp (γ₁ t) = γ t)
    (h₂ : ∀ t, Complex.exp (γ₂ t) = γ t) :
    γ₁ 1 - γ₁ 0 = γ₂ 1 - γ₂ 0 := by
  set c : ℂ := γ₁ 0 - γ₂ 0 with hc_def
  have hexpc : Complex.exp c = 1 := by
    rw [hc_def, Complex.exp_sub, h₁ 0, h₂ 0, div_self (hγ 0)]
  set γ₃ : C(unitInterval, ℂ) :=
    ⟨fun t => γ₂ t + c, (map_continuous γ₂).add continuous_const⟩ with hγ₃_def
  have h₃ : ∀ t, Complex.exp (γ₃ t) = γ t := by
    intro t
    change Complex.exp (γ₂ t + c) = γ t
    rw [Complex.exp_add, h₂ t, hexpc, mul_one]
  have h0 : γ₃ 0 = γ₁ 0 := by
    change γ₂ 0 + c = γ₁ 0
    rw [hc_def]; ring
  have heq : γ₃ = γ₁ := winding_lift_unique γ hγ γ₃ γ₁ h₃ h₁ h0
  have h1' : γ₁ 1 = γ₂ 1 + c := by rw [← heq]; rfl
  have h0' : γ₁ 0 = γ₂ 0 + c := by rw [← heq]; rfl
  rw [h1', h0']; ring

/-- **The σ-closure row, stem form** (PROVED) — the closure clause of
GPVwind Cor 5.13 (SOURCES/GPVwind.md, verbatim: "Then a lift of γ in
𝓔⁺_𝕂 exists if and only if σ(γ|_{[ξ_l,ξ_{l+1}]}) ∈ {0,−1} for each
l = 1,…,m−1. If it exists, the lift is a loop."), rendered in the slice
vocabulary of `exists_log_continuation`: on a single slice the companion
is the slice itself (Def 4.7 tameness by fiat, `winding_lift_unique`
docstring) and the direction flips of Def 5.2 have no carrier (Rem 2.1:
"the function 𝓘 cannot be extended as a continuous function to any single
point of the real axis ℝ of 𝕂"), so the σ-criterion's stem-honest role is
exactly the closure of SOME lift; this row is then the clause's force:
once one lift closes, EVERY lift closes. Direct from
`winding_defect_lift_independent`. -/
theorem winding_loop_closed (γ : C(unitInterval, ℂ)) (hγ : ∀ t, γ t ≠ 0)
    (γ₀ : C(unitInterval, ℂ)) (h₀ : ∀ t, Complex.exp (γ₀ t) = γ t)
    (hclose : γ₀ 1 = γ₀ 0)
    (γ' : C(unitInterval, ℂ)) (h' : ∀ t, Complex.exp (γ' t) = γ t) :
    γ' 1 = γ' 0 := by
  have h := winding_defect_lift_independent γ hγ γ' γ₀ h' h₀
  rw [hclose, sub_self] at h
  exact sub_eq_zero.mp h

/-- **Closure forces defect zero IN THE LEVEL, unconditionally** (PROVED):
along any closed value-loop, any log-continuation's endpoint defect is
2πiℤ (`winding_loop_defect`, Toolkit.lean) — purely a height datum, so the
endpoint LEVEL closes outright. The stem-honest face of the master's
placement-paragraph sentence "all multiplicity in the fibre lies in the
winding direction ([Cor. 5.21]{GPVwind}), none in the level". -/
theorem winding_loop_defect_level_zero (γ : C(unitInterval, ℂ)) (hloop : γ 0 = γ 1)
    (γ' : C(unitInterval, ℂ)) (hlift : ∀ t, Complex.exp (γ' t) = γ t) :
    (γ' 1).re = (γ' 0).re := by
  obtain ⟨k, hk⟩ := winding_loop_defect γ hloop γ' hlift
  have hre := congrArg Complex.re hk
  rw [Complex.sub_re] at hre
  have hzero : (((k : ℤ) : ℂ) * (2 * (Real.pi : ℂ) * Complex.I)).re = 0 := by
    simp [Complex.mul_re]
  rw [hzero] at hre
  linarith

/-! ## §B — `lem:exp-degenerate`, stem fibre rows -/

/-- **The stem fibre formula** (PROVED, iff form) — master
`lem:exp-degenerate` read on the stem: exp w = −r (r > 0) exactly when w
is the one level log r paired with an odd winding height (2k+1)π. The
octonionic form (direction sphere included) is the PROVED
`Octonion.exp_fibre_neg_real` (Toolkit.lean); this is its slice
coordinate. -/
theorem exp_eq_neg_real_iff {r : ℝ} (hr : 0 < r) (w : ℂ) :
    Complex.exp w = -(r : ℂ)
      ↔ ∃ k : ℤ, w = (Real.log r : ℂ) + ((2 * k + 1 : ℤ) : ℂ) * Real.pi * Complex.I := by
  have hr' : (r : ℂ) ≠ 0 := by
    exact_mod_cast hr.ne'
  have hlogr : Complex.exp ((Real.log r : ℝ) : ℂ) = (r : ℂ) := by
    rw [← Complex.ofReal_exp, Real.exp_log hr]
  constructor
  · intro h
    have hquot : Complex.exp (w - (Real.log r : ℂ) + Real.pi * Complex.I) = 1 := by
      rw [Complex.exp_add, Complex.exp_sub, h, hlogr, Complex.exp_pi_mul_I]
      field_simp
    obtain ⟨n, hn⟩ := Complex.exp_eq_one_iff.mp hquot
    refine ⟨n - 1, ?_⟩
    have hw : w = (Real.log r : ℂ)
        + ((n : ℂ) * (2 * Real.pi * Complex.I) - Real.pi * Complex.I) := by
      linear_combination hn
    rw [hw]
    push_cast
    ring
  · rintro ⟨k, rfl⟩
    have hsplit : (Real.log r : ℂ) + ((2 * k + 1 : ℤ) : ℂ) * Real.pi * Complex.I
        = ((Real.log r : ℝ) : ℂ) + ((k : ℂ) * (2 * Real.pi * Complex.I)
            + Real.pi * Complex.I) := by
      push_cast
      ring
    have hk1 : Complex.exp ((k : ℂ) * (2 * Real.pi * Complex.I)) = 1 :=
      Complex.exp_eq_one_iff.mpr ⟨k, rfl⟩
    rw [hsplit, Complex.exp_add, Complex.exp_add, hlogr, hk1, one_mul,
      Complex.exp_pi_mul_I]
    ring

/-- The level clause (PROVED): every fibre point over −r carries the ONE
level log r — "The fibre is thus indexed by the single real level
log r = log|−r|" (master `lem:exp-degenerate`). -/
theorem exp_fibre_level {r : ℝ} (hr : 0 < r) {w : ℂ}
    (h : Complex.exp w = -(r : ℂ)) : w.re = Real.log r := by
  have hnorm := congrArg norm h
  rw [Complex.norm_exp, norm_neg, Complex.norm_real, Real.norm_eq_abs,
    abs_of_pos hr] at hnorm
  rw [← hnorm, Real.log_exp]

/-- The band clause (PROVED): two fibre points over the one value −r agree
in the level EXACTLY and differ by band data only ("within it, by the odd
winding indices 2k+1 carried as band data", master `lem:exp-degenerate`;
winding is band data, never an object label, `def:base`). -/
theorem exp_fibre_height_band {r : ℝ} (hr : 0 < r) {w₁ w₂ : ℂ}
    (h₁ : Complex.exp w₁ = -(r : ℂ)) (h₂ : Complex.exp w₂ = -(r : ℂ)) :
    w₁.re = w₂.re ∧ ∃ k : ℤ, w₁ - w₂ = (k : ℂ) * (2 * Real.pi * Complex.I) := by
  refine ⟨(exp_fibre_level hr h₁).trans (exp_fibre_level hr h₂).symm, ?_⟩
  obtain ⟨n, hn⟩ := Complex.exp_eq_exp_iff_exists_int.mp (h₁.trans h₂.symm)
  exact ⟨n, by rw [hn]; ring⟩

/-! ## §C — the assembly rows: C1's cone, C3's encounters, the shared ladder -/

namespace ASection

/-- **C1's cone, PROVED**: at the one simple pole the section's values
leave every bounded set — the value-loops' closure point is N
(`rmk:two-poles`; `rmk:collapse-cone`: "the preimage of any neighbourhood
of N is a neighbourhood of the pole"). Fed by `c1_simple` alone through
the pin `tendsto_cobounded_of_meromorphicOrderAt_neg`
(Mathlib/Analysis/Meromorphic/Order.lean:149). -/
theorem pole_cone_tendsto (A : ASection) :
    Tendsto A.F (nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ) (Bornology.cobounded ℂ) := by
  apply tendsto_cobounded_of_meromorphicOrderAt_neg
  rw [A.c1_simple]
  exact_mod_cast neg_one_lt_zero

/-- The chart at N (PROVED): in the inverse chart the values approach the
point at infinity — the compactified reading of the cone
(`rmk:compactify`). -/
theorem pole_cone_chart (A : ASection) :
    Tendsto (fun z => (A.F z)⁻¹) (nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ) (nhds 0) :=
  tendsto_inv₀_cobounded.comp A.pole_cone_tendsto

/-- **Draft I's opening clause, PROVED — the ε–δ correspondence at N**:
"Given any arbitrarily small radius of unit imaginary octonions about N …
there is a radius around the pole in the domain" (author's Draft I,
2026-07-06) — for every ε-chart-ball about N there is a δ-ball about the
pole all of whose values land in it. -/
theorem pole_cone_eps_delta (A : ASection) :
    ∀ ε > 0, ∃ δ > 0, ∀ z : ℂ, z ≠ (A.pole : ℂ) → dist z (A.pole : ℂ) < δ →
      ‖(A.F z)⁻¹‖ < ε := by
  intro ε hε
  obtain ⟨δ, hδ, hh⟩ := Metric.tendsto_nhdsWithin_nhds.mp A.pole_cone_chart ε hε
  refine ⟨δ, hδ, fun z hz hzd => ?_⟩
  have h := hh (Set.mem_compl_singleton_iff.mpr hz) hzd
  rwa [dist_zero_right] at h

/-- **C3's degenerate encounters, PROVED**: near an enumerated zero the
stem's values sweep EVERY sufficiently small negative real — the local
peel `stem_local_form` (StemFactorization.lean, the C3 factorization read at
the zero) forces non-constancy, and the open mapping theorem (pin:
`AnalyticAt.eventually_constant_or_nhds_le_map_nhds`,
Mathlib/Analysis/Complex/OpenMapping.lean:119) hands every small value to
the ε-ball. The master's assembly meets its degenerate fibre here: "the
exp-preimage data over the real values met by the unique tame lift"
(placement paragraph). -/
theorem neg_reals_swept_near_sphereZero (A : ASection) (n : ℕ) :
    ∀ ε > 0, ∃ η > 0, ∀ r : ℝ, 0 < r → r < η →
      ∃ z : ℂ, dist z (A.sphereZero n) < ε ∧ A.F z = -(r : ℂ) := by
  intro ε hε
  have him : 0 < (A.sphereZero n).im := A.c3_sphere_nonreal n
  have hap : A.sphereZero n ≠ (A.pole : ℂ) := by
    intro h; rw [h] at him; simp at him
  have hFa : A.F (A.sphereZero n) = 0 := A.stem_zero_of_sphereZero n
  have han : AnalyticAt ℂ A.F (A.sphereZero n) := A.c1_analyticAt _ hap
  obtain ⟨G, hGa, hGne, hev⟩ := A.stem_local_form n
  rcases han.eventually_constant_or_nhds_le_map_nhds with hconst | hmap
  · exfalso
    rw [hFa] at hconst
    have hGnear : ∀ᶠ z in nhds (A.sphereZero n), G z ≠ 0 :=
      hGa.continuousAt.eventually_ne hGne
    have hfalse : ∀ᶠ z in nhdsWithin (A.sphereZero n) {(A.sphereZero n)}ᶜ, False := by
      filter_upwards [eventually_nhdsWithin_of_eventually_nhds hconst,
        eventually_nhdsWithin_of_eventually_nhds hev,
        eventually_nhdsWithin_of_eventually_nhds hGnear,
        self_mem_nhdsWithin] with z h1 h2 h3 hz
      rw [h1] at h2
      have hzne : z ≠ A.sphereZero n := hz
      rcases mul_eq_zero.mp h2.symm with h4 | h4
      · exact pow_ne_zero _ (sub_ne_zero.mpr hzne) h4
      · exact h3 h4
    obtain ⟨z, hz⟩ := hfalse.exists
    exact hz
  · rw [hFa] at hmap
    have himg : A.F '' Metric.ball (A.sphereZero n) ε ∈ nhds (0 : ℂ) :=
      hmap (Filter.image_mem_map (Metric.ball_mem_nhds _ hε))
    obtain ⟨η, hη, hsub⟩ := Metric.mem_nhds_iff.mp himg
    refine ⟨η, hη, fun r hr0 hrη => ?_⟩
    have hmem : -((r : ℝ) : ℂ) ∈ Metric.ball (0 : ℂ) η := by
      rw [Metric.mem_ball, dist_zero_right, norm_neg, Complex.norm_real,
        Real.norm_eq_abs, abs_of_pos hr0]
      exact hrη
    obtain ⟨z, hzball, hz⟩ := hsub hmem
    exact ⟨z, by rwa [Metric.mem_ball] at hzball, hz⟩

/-- **The SHARED ladder, PROVED**: for every ε the degenerate encounters
of the two enumerated zeros' ε-neighbourhoods share ONE value −r — hence
ONE ladder of `lem:exp-degenerate` fibre data: one level log r exactly,
heights band data only (`exp_fibre_height_band`). Draft I's fourth clause
("every degenerate encounter … lies on the ladder of one β: the heights
differ by band data only …, the level not at all") holds VERBATIM for the
VALUE-side ladder. -/
theorem shared_ladder_encounters (A : ASection) (n m : ℕ) :
    ∀ ε > 0, ∃ r : ℝ, 0 < r ∧ r < ε ∧
      (∃ z : ℂ, dist z (A.sphereZero n) < ε ∧ A.F z = -(r : ℂ)) ∧
      (∃ w : ℂ, dist w (A.sphereZero m) < ε ∧ A.F w = -(r : ℂ)) := by
  intro ε hε
  obtain ⟨ηn, hηn, hn⟩ := A.neg_reals_swept_near_sphereZero n ε hε
  obtain ⟨ηm, hηm, hm⟩ := A.neg_reals_swept_near_sphereZero m ε hε
  have hr0 : 0 < min (min ηn ηm) ε / 2 := by
    have := lt_min (lt_min hηn hηm) hε
    positivity
  refine ⟨min (min ηn ηm) ε / 2, hr0, ?_, ?_, ?_⟩
  · calc min (min ηn ηm) ε / 2 ≤ ε / 2 := by
          have := min_le_right (min ηn ηm) ε
          linarith
      _ < ε := by linarith
  · exact hn _ hr0 (by
      have h1 := min_le_left (min ηn ηm) ε
      have h2 := min_le_left ηn ηm
      linarith)
  · exact hm _ hr0 (by
      have h1 := min_le_left (min ηn ηm) ε
      have h2 := min_le_right ηn ηm
      linarith)

/-! ## §D — the two draft renders (dual curation; lake's verdicts recorded) -/

-- (removed 2026-07-10: `concentric_articulation` — a dead terminal theorem over
-- the old `TotalTransport` base, consumed by nothing. The concentric readout is
-- the cocartesian `readout` on `functorA`/`TotalA`, ConcentricityReadout.lean.)

/-! ## The re-encoded corollary chain (author's ruling, 2026-07-06:
"Pin 3 is now completely irrelevant. All infinitely many ℂ-residue zero
spheres are in one *concentric* component of the A section. Hence the
corollary just notes that ζ_𝕆 is an instantiation of an A-section. Hence
infinitely many concentric ℂ-residue zeros by the concentricity theorem
and lemma; the common center is real and is pinned by the functional
equation.") -/

end ASection
