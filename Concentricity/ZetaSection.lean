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

SORRIED rows (R8 — UNFORMALIZED, never UNSOUND; each a true classical
fact over explicit data, none conditional on open questions):
- the C2 cluster (six rows): the Euler-factor logs ℓ p = −log(1 − p^{−z})
  — intrinsic, analytic, zero-free, summable, the exp-of-sum Euler
  product, the local majorant. Mathlib's `eulerProduct` cluster is the
  closing stock (R5-verified present).
- the Rfac rows (three): zetaRfac = the 1/Γℝ unit with the origin's zero
  divided out (`Function.update`; trivial zeros = the nonzero real
  divisor) — intrinsic, entire, zeros real-and-nonzero.
- `zetaC3_package` (one row): THE gated classical input — the infinite
  Weierstrass factorization of (s−1)ζ through the pole N over the
  divisor-repeated enumeration (author: "infinite Weierstrass through
  the pole N gets us attached to the infinitely many ℂ-residue side").
  gfac and its four consumer rows are `choose`-extracted from it, so the
  entire C3 gap is ONE named leaf.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.ASection
import Concentricity.ZetaDivisor
import Concentricity.RhEquiv

noncomputable section

open Complex

/-! ## C2 data and rows: the Euler-factor logarithms -/

/-- C2 data — the Euler family: ℓ_p(z) = −log(1 − p^{−z})
(design table; master C2 "A = exp(Σₚ ℓₚ)"). -/
noncomputable def zetaEulerLog (p : Nat.Primes) (z : ℂ) : ℂ :=
  -Complex.log (1 - ((p : ℕ) : ℂ) ^ (-z))

/-- C2: each ℓ_p is intrinsic (real positive base; the conjugation
argument of ZetaConj). SORRIED (R8; classical, closes on the pin
patterns). -/
theorem zetaC2_intrinsic : ∀ p : Nat.Primes, IsIntrinsic (zetaEulerLog p) := by
  sorry

/-- C2: each ℓ_p is analytic on Re > 1 (|p^{−z}| < 1 keeps 1 − p^{−z} in
the slit plane). SORRIED (R8). -/
theorem zetaC2_analyticAt : ∀ p : Nat.Primes, ∀ z : ℂ, (1 : ℝ) < z.re →
    AnalyticAt ℂ (zetaEulerLog p) z := by
  sorry

/-- C2: "each zero-free on Ω₀" — ℓ_p(z) = 0 would force p^{−z} = 0.
SORRIED (R8). -/
theorem zetaC2_zero_free : ∀ p : Nat.Primes, ∀ z : ℂ, (1 : ℝ) < z.re →
    zetaEulerLog p z ≠ 0 := by
  sorry

/-- C2: summability of the family on Re > 1 (dominated by Σ p^{−Re z}).
SORRIED (R8). -/
theorem zetaC2_summable : ∀ z : ℂ, (1 : ℝ) < z.re →
    Summable fun p : Nat.Primes => zetaEulerLog p z := by
  sorry

/-- C2: the Euler product in exp-of-sum form, ζ = exp(Σₚ ℓₚ) on Re > 1
(Mathlib `eulerProduct` cluster, R5-verified present). SORRIED (R8). -/
theorem zetaC2_euler : ∀ z : ℂ, (1 : ℝ) < z.re →
    riemannZeta z = Complex.exp (∑' p : Nat.Primes, zetaEulerLog p z) := by
  sorry

/-- §4α: the local majorant of the Euler family (Titchmarsh Ch. 1
register; from the p^{−Re z} bound on a ball). SORRIED (R8). -/
theorem zetaC2_locMajorant : ∀ z : ℂ, (1 : ℝ) < z.re →
    ∃ r > 0, ∃ u : Nat.Primes → ℝ, Summable u ∧
      ∀ p, ∀ w ∈ Metric.ball z r, ‖zetaEulerLog p w‖ ≤ u p := by
  sorry

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

/-- Rfac is intrinsic (Γ commutes with conjugation; π real). SORRIED
(R8). -/
theorem zetaRfac_intrinsic : IsIntrinsic zetaRfac := by
  sorry

/-- Rfac is entire (`differentiable_one_div_Gammaℝ` + the removable
origin). SORRIED (R8). -/
theorem zetaRfac_entire : Differentiable ℂ zetaRfac := by
  sorry

/-- Rfac vanishes exactly at the nonzero reals −2, −4, …
(`Gammaℝ_eq_zero_iff`; the origin's value is 1/2 ≠ 0). SORRIED (R8). -/
theorem zetaRfac_zeros_real : ∀ z : ℂ, zetaRfac z = 0 → z.im = 0 ∧ z ≠ 0 := by
  sorry

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
