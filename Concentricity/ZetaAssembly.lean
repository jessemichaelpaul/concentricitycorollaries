/-
Concentricity/ZetaAssembly.lean

The Weierstrass package build, STAGE C — THE ASSEMBLY (author "Stage C
execute", 2026-07-05): ξ = e^g·P with g entire and intrinsic, from the
stage-B divisor match through the divisor-extraction and entire-log
engines:

- ξ(0) = P(0) = 1, so neither is locally zero anywhere (identity theorem
  on the connected plane) — both meromorphic orders are finite;
- the quotient ξ/P is meromorphic with order ZERO everywhere (the stage-B
  match), so its divisor is empty and `MeromorphicOn.extract_zeros_poles`
  hands an entire nonvanishing h with ξ/P =ᶠ h on a codiscrete set;
- the ZetaInfinitude frequently-eq glue upgrades this to ξ = h·P
  everywhere (identity theorem);
- `exists_log_of_entire_nonvanishing` (the in-repo A4 engine) gives
  h = e^{g₀};
- h is intrinsic (agreement with ξ/P near 0, both sides intrinsic,
  identity theorem), so d := conj∘g₀∘conj − g₀ satisfies e^d ≡ 1; its
  derivative vanishes, so d is a CONSTANT c, and evaluating at 0 (where
  ξ(0) = P(0) = 1 forces e^{g₀(0)} = 1, Re g₀(0) = 0) pins e^{c/2} = 1;
- g := g₀ + c/2 = (g₀ + conj∘g₀∘conj)/2 is intrinsic, entire, and
  e^g = h.

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file targets ZERO
sorries.
-/
import Concentricity.ZetaXiMatch

noncomputable section

open Complex

/-! ## The values at 0 and finiteness of the orders -/

/-- E_p(0) = 1. PROVED helper. -/
theorem weierstrassE_zero (p : ℕ) : weierstrassE p 0 = 1 := by
  rw [weierstrassE]
  have h : (∑ k ∈ Finset.range p, (0 : ℂ) ^ (k + 1) / (k + 1)) = 0 := by
    refine Finset.sum_eq_zero fun k _ => ?_
    rw [zero_pow (Nat.succ_ne_zero k), zero_div]
  rw [h, Complex.exp_zero]
  ring

/-- P(0) = 1: every factor is 1 at the origin. PROVED. -/
theorem zetaProd_zero : zetaProd 0 = 1 := by
  rw [zetaProd]
  have h : ∀ n : ℕ, spherePrimary n (zetaSphereZero n) 0 = 1 := by
    intro n
    rw [spherePrimary, zero_div, zero_div, weierstrassE_zero]
    norm_num
  rw [tprod_congr h, tprod_one]

/-- An entire function with a nonzero value is nowhere locally zero.
PROVED helper. -/
theorem analyticOrderAt_ne_top_of_ne_zero {f : ℂ → ℂ}
    (hf : ∀ z, AnalyticAt ℂ f z) {w : ℂ} (hw : f w ≠ 0) (z : ℂ) :
    analyticOrderAt f z ≠ ⊤ := by
  intro htop
  have hev := analyticOrderAt_eq_top.mp htop
  have hfa : AnalyticOnNhd ℂ f Set.univ := fun t _ => hf t
  have h0a : AnalyticOnNhd ℂ (fun _ : ℂ => (0 : ℂ)) Set.univ :=
    fun _ _ => analyticAt_const
  have hEq := hfa.eqOn_of_preconnected_of_eventuallyEq h0a
    isPreconnected_univ (Set.mem_univ z) hev (Set.mem_univ w)
  exact hw hEq

/-- ξ's order is finite everywhere (ξ(0) = 1). PROVED. -/
theorem xi_orderAt_ne_top (z : ℂ) : analyticOrderAt xi z ≠ ⊤ :=
  analyticOrderAt_ne_top_of_ne_zero xi_analyticAt
    (by rw [xi_zero]; exact one_ne_zero) z

/-- P's order is finite everywhere (P(0) = 1). PROVED. -/
theorem zetaProd_orderAt_ne_top (z : ℂ) : analyticOrderAt zetaProd z ≠ ⊤ :=
  analyticOrderAt_ne_top_of_ne_zero zetaProd_analyticAt
    (by rw [zetaProd_zero]; exact one_ne_zero) z

/-! ## The quotient has empty divisor; extraction and the glue -/

/-- The quotient ξ/P is meromorphic on ℂ. PROVED helper. -/
theorem xiOverProd_meromorphicOn :
    MeromorphicOn (xi / zetaProd) Set.univ := fun z _ =>
  (xi_analyticAt z).meromorphicAt.div (zetaProd_analyticAt z).meromorphicAt

/-- The quotient's meromorphic order vanishes everywhere — the stage-B
divisor match, read through the analytic/meromorphic bridge. PROVED. -/
theorem xiOverProd_orderAt (z : ℂ) :
    meromorphicOrderAt (xi / zetaProd) z = 0 := by
  rw [meromorphicOrderAt_div (xi_analyticAt z).meromorphicAt
    (zetaProd_analyticAt z).meromorphicAt,
    (xi_analyticAt z).meromorphicOrderAt_eq,
    (zetaProd_analyticAt z).meromorphicOrderAt_eq,
    xi_orderAt_eq_zetaProd_orderAt z]
  cases hn : analyticOrderAt zetaProd z with
  | top => exact absurd hn (zetaProd_orderAt_ne_top z)
  | coe n =>
    simp

/-- ξ = h·P for an entire nonvanishing h — the extraction over the empty
divisor plus the ZetaInfinitude frequently-eq glue. PROVED. -/
theorem xi_eq_unit_mul_zetaProd :
    ∃ h : ℂ → ℂ, Differentiable ℂ h ∧ (∀ z, h z ≠ 0) ∧
      ∀ z, xi z = h z * zetaProd z := by
  have hsupp : (MeromorphicOn.divisor (xi / zetaProd) Set.univ).support.Finite := by
    refine Set.Finite.subset Set.finite_empty fun z hz => ?_
    have h1 : MeromorphicOn.divisor (xi / zetaProd) Set.univ z ≠ 0 :=
      Function.mem_support.mp hz
    refine absurd ?_ h1
    rw [MeromorphicOn.divisor_apply xiOverProd_meromorphicOn (Set.mem_univ z),
      xiOverProd_orderAt z]
    rfl
  obtain ⟨h, h_an, h_ne, h_eq⟩ :=
    xiOverProd_meromorphicOn.extract_zeros_poles
      (fun u => by rw [xiOverProd_orderAt]; exact WithTop.coe_ne_top) hsupp
  have hφ1 : (∏ᶠ u, (· - u) ^ MeromorphicOn.divisor (xi / zetaProd) Set.univ u)
      = (1 : ℂ → ℂ) := by
    have hz : ∀ u : ℂ, ((· - u) ^ MeromorphicOn.divisor (xi / zetaProd) Set.univ u)
        = (1 : ℂ → ℂ) := by
      intro u
      have h0 : MeromorphicOn.divisor (xi / zetaProd) Set.univ u = 0 := by
        rw [MeromorphicOn.divisor_apply xiOverProd_meromorphicOn (Set.mem_univ u),
          xiOverProd_orderAt u]
        rfl
      rw [h0]
      funext w
      simp
    exact finprod_eq_one_of_forall_eq_one hz
  -- frequently-eq at 0 from the codiscrete equality (the ZetaInfinitude block)
  have hfreq : ∃ᶠ z in nhdsWithin (0 : ℂ) {(0 : ℂ)}ᶜ,
      (xi / zetaProd) z = h z := by
    have hmem : {z | (xi / zetaProd) z = h z}
        ∈ Filter.codiscreteWithin (Set.univ : Set ℂ) := by
      filter_upwards [h_eq] with z hz
      rw [hφ1] at hz
      simpa [Pi.smul_apply', smul_eq_mul, Pi.one_apply] using hz
    have hnhds : {z | (xi / zetaProd) z = h z} ∪ (Set.univ : Set ℂ)ᶜ
        ∈ nhdsWithin (0 : ℂ) {(0 : ℂ)}ᶜ :=
      mem_codiscreteWithin_iff_forall_mem_nhdsNE.mp hmem 0 (Set.mem_univ 0)
    rw [Set.compl_univ, Set.union_empty] at hnhds
    exact (Filter.eventually_iff.mpr hnhds).frequently
  -- upgrade: xi and h·P agree frequently near 0, both analytic → everywhere
  have hfreq2 : ∃ᶠ z in nhdsWithin (0 : ℂ) {(0 : ℂ)}ᶜ,
      xi z = h z * zetaProd z := by
    have hPne : ∀ᶠ z in nhdsWithin (0 : ℂ) {(0 : ℂ)}ᶜ, zetaProd z ≠ 0 := by
      have hcont := (zetaProd_analyticAt 0).continuousAt.eventually_ne
        (by rw [zetaProd_zero]; exact one_ne_zero)
      exact eventually_nhdsWithin_of_eventually_nhds hcont
    refine (hfreq.and_eventually hPne).mono ?_
    rintro z ⟨hz1, hz2⟩
    have h1 : xi z / zetaProd z = h z := hz1
    exact (div_eq_iff hz2).mp h1
  have hxa : AnalyticOnNhd ℂ xi Set.univ := fun t _ => xi_analyticAt t
  have hEq : Set.EqOn xi (fun z => h z * zetaProd z) Set.univ :=
    hxa.eqOn_of_preconnected_of_frequently_eq
      (fun t _ => (h_an t (Set.mem_univ t)).mul (zetaProd_analyticAt t))
      isPreconnected_univ (Set.mem_univ 0) hfreq2
  exact ⟨h, fun z => (h_an z (Set.mem_univ z)).differentiableAt,
    fun z => h_ne ⟨z, Set.mem_univ z⟩, fun z => hEq (Set.mem_univ z)⟩

/-! ## Intrinsicality of the unit and the log; the master theorem -/

/-- **STAGE C COMPLETE — the Hadamard form**: ξ = e^g·P with g entire and
intrinsic. PROVED. -/
theorem zeta_hadamard : ∃ g : ℂ → ℂ, IsIntrinsic g ∧ Differentiable ℂ g ∧
    ∀ z : ℂ, xi z = Complex.exp (g z) * zetaProd z := by
  obtain ⟨h, h_diff, h_ne, h_eq⟩ := xi_eq_unit_mul_zetaProd
  -- h is intrinsic: near 0 it agrees with ξ/P, which is intrinsic there
  have h_intr : IsIntrinsic h := by
    intro z
    have hsand : ∀ t, AnalyticAt ℂ (fun w => (starRingEnd ℂ) (h ((starRingEnd ℂ) w))) t := by
      intro t
      have h1 := (h_diff.analyticAt ((starRingEnd ℂ) t)).conj_comp_conj
      rwa [starRingEnd_self_apply] at h1
    have hev : (fun w => (starRingEnd ℂ) (h ((starRingEnd ℂ) w))) =ᶠ[nhds (0 : ℂ)] h := by
      have hP0 := (zetaProd_analyticAt 0).continuousAt.eventually_ne
        (by rw [zetaProd_zero]; exact one_ne_zero)
      have hPc0 : Filter.Tendsto (starRingEnd ℂ) (nhds (0 : ℂ)) (nhds (0 : ℂ)) := by
        have h1 := Complex.continuous_conj.tendsto (0 : ℂ)
        rwa [map_zero] at h1
      filter_upwards [hP0, hPc0.eventually hP0] with w hw hcw
      have hxw := h_eq w
      have hxcw := h_eq ((starRingEnd ℂ) w)
      have hxi_c : xi ((starRingEnd ℂ) w) = (starRingEnd ℂ) (xi w) := xi_intrinsic w
      have hP_c : zetaProd ((starRingEnd ℂ) w) = (starRingEnd ℂ) (zetaProd w) :=
        zetaProd_intrinsic w
      -- conj (h (conj w)) = conj (xi (conj w) / P (conj w)) = xi w / P w = h w
      have h1 : h ((starRingEnd ℂ) w) = xi ((starRingEnd ℂ) w) / zetaProd ((starRingEnd ℂ) w) :=
        (eq_div_iff hcw).mpr hxcw.symm
      have h2 : h w = xi w / zetaProd w :=
        (eq_div_iff hw).mpr hxw.symm
      rw [h1, hxi_c, hP_c, ← map_div₀, starRingEnd_self_apply, ← h2]
    have hsa : AnalyticOnNhd ℂ (fun w => (starRingEnd ℂ) (h ((starRingEnd ℂ) w)))
        Set.univ := fun t _ => hsand t
    have hha : AnalyticOnNhd ℂ h Set.univ := fun t _ => h_diff.analyticAt t
    have hEq2 : Set.EqOn (fun w => (starRingEnd ℂ) (h ((starRingEnd ℂ) w))) h
        Set.univ :=
      hsa.eqOn_of_preconnected_of_eventuallyEq hha
        isPreconnected_univ (Set.mem_univ 0) hev
    have h3 : (starRingEnd ℂ) (h ((starRingEnd ℂ) ((starRingEnd ℂ) z)))
        = h ((starRingEnd ℂ) z) := hEq2 (Set.mem_univ ((starRingEnd ℂ) z))
    rw [starRingEnd_self_apply] at h3
    exact h3.symm
  -- the entire log of h
  obtain ⟨g₀, hg₀_diff, hg₀⟩ := exists_log_of_entire_nonvanishing h_diff h_ne
  -- d := conj∘g₀∘conj − g₀ is constant (e^d ≡ 1, derivative vanishes)
  set d : ℂ → ℂ := fun z => (starRingEnd ℂ) (g₀ ((starRingEnd ℂ) z)) - g₀ z
    with hd_def
  have hd_diff : Differentiable ℂ d := by
    refine Differentiable.sub ?_ hg₀_diff
    intro z
    exact ((hg₀_diff ((starRingEnd ℂ) z)).hasDerivAt.conj_comp_conj).differentiableAt
  have hexp_d : ∀ z, Complex.exp (d z) = 1 := by
    intro z
    rw [hd_def]
    have h1 : Complex.exp ((starRingEnd ℂ) (g₀ ((starRingEnd ℂ) z)))
        = (starRingEnd ℂ) (Complex.exp (g₀ ((starRingEnd ℂ) z))) := by
      rw [← Complex.exp_conj]
    rw [Complex.exp_sub, h1, ← hg₀ ((starRingEnd ℂ) z), ← hg₀ z]
    have hkey : (starRingEnd ℂ) (h ((starRingEnd ℂ) z)) = h z := by
      rw [h_intr z, starRingEnd_self_apply]
    rw [hkey]
    exact div_self (h_ne z)
  have hd_const : ∀ z, d z = d 0 := by
    have hderiv0 : ∀ z, deriv d z = 0 := by
      intro z
      have h1 : HasDerivAt (fun w => Complex.exp (d w))
          (Complex.exp (d z) * deriv d z) z :=
        ((hd_diff z).hasDerivAt).cexp
      have h2 : (fun w => Complex.exp (d w)) = fun _ => (1 : ℂ) :=
        funext fun w => hexp_d w
      rw [h2] at h1
      have h3 := h1.unique (hasDerivAt_const z 1)
      rcases mul_eq_zero.mp h3 with h4 | h4
      · exact absurd h4 (Complex.exp_ne_zero _)
      · exact h4
    intro z
    exact is_const_of_deriv_eq_zero hd_diff hderiv0 z 0
  -- pin e^{c/2} = 1 at the origin
  have hg₀0 : Complex.exp (g₀ 0) = 1 := by
    have h1 := h_eq 0
    rw [xi_zero, zetaProd_zero, mul_one] at h1
    rw [← hg₀ 0, ← h1]
  obtain ⟨n, hn⟩ := Complex.exp_eq_one_iff.mp hg₀0
  have hre0 : (g₀ 0).re = 0 := by
    rw [hn]
    simp [Complex.mul_re, Complex.mul_im, Complex.I_re, Complex.I_im]
  -- the symmetrized log
  set g : ℂ → ℂ := fun z => (g₀ z + (starRingEnd ℂ) (g₀ ((starRingEnd ℂ) z))) / 2
    with hg_def
  have hg_eq : ∀ z, g z = g₀ z + d 0 / 2 := by
    intro z
    show (g₀ z + (starRingEnd ℂ) (g₀ ((starRingEnd ℂ) z))) / 2 = g₀ z + d 0 / 2
    have h1 : (starRingEnd ℂ) (g₀ ((starRingEnd ℂ) z)) = d z + g₀ z := by
      show (starRingEnd ℂ) (g₀ ((starRingEnd ℂ) z))
        = ((starRingEnd ℂ) (g₀ ((starRingEnd ℂ) z)) - g₀ z) + g₀ z
      ring
    rw [h1, hd_const z]
    ring
  have hg0val : g 0 = 0 := by
    show (g₀ 0 + (starRingEnd ℂ) (g₀ ((starRingEnd ℂ) (0 : ℂ)))) / 2 = 0
    rw [map_zero]
    have h2 : g₀ 0 + (starRingEnd ℂ) (g₀ 0) = ((2 * (g₀ 0).re : ℝ) : ℂ) :=
      Complex.add_conj (g₀ 0)
    rw [h2, hre0]
    norm_num
  have hεone : Complex.exp (d 0 / 2) = 1 := by
    have h1 : Complex.exp (g 0) = 1 := by rw [hg0val, Complex.exp_zero]
    rw [hg_eq 0, Complex.exp_add, hg₀0, one_mul] at h1
    exact h1
  refine ⟨g, ?_, ?_, ?_⟩
  · -- intrinsic
    intro z
    show (g₀ ((starRingEnd ℂ) z)
        + (starRingEnd ℂ) (g₀ ((starRingEnd ℂ) ((starRingEnd ℂ) z)))) / 2
      = (starRingEnd ℂ) ((g₀ z + (starRingEnd ℂ) (g₀ ((starRingEnd ℂ) z))) / 2)
    rw [starRingEnd_self_apply, map_div₀, map_add, starRingEnd_self_apply,
      map_ofNat]
    ring
  · -- entire
    have hfun : g = fun z => g₀ z + d 0 / 2 := funext hg_eq
    rw [hfun]
    exact hg₀_diff.add_const _
  · -- ξ = e^g·P
    intro z
    rw [hg_eq z, Complex.exp_add, hεone, mul_one, ← hg₀ z]
    exact h_eq z
