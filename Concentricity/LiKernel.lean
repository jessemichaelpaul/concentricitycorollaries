/-
Concentricity/LiKernel.lean

B2.2 — the anchor-pair Möbius-kernel pairing (DESIGN_B2_2_kernels.md,
author-confirmed renderings 2026-07-04, landed statements-first). Grounded
in the adopted (iv) target v0.2 (PLAN §6; READ_weil_li_findings.md) and
Theorem 2 of the generalized Bombieri–Lagarias source (READ provenance).

Kernel family: K(n, a, β; z) = 1 − ((z − a)/(z − (2β − a)))ⁿ — anchor pair
{a, 2β − a}, mirror-symmetric about Re = β; all parameters real and BOUND
(quantified), never named constants.

Admissibility audit (PLAN §6, run per shape at this landing): no ½, no
named level — β existential, a bound relative to β; differences-only —
kernels see z − a and z − (2β − a) alone, translation-covariant; exact per
n, no Tendsto; sums real via conjugation; zeros as output — liSum reads
the divisor, nothing feeds a zero in; frozen statements and def:A-section
untouched. D4 (the explicit-formula face) is DEFERRED by ruling — not
drafted here.

Burn order (author's rider 2, junk-value hygiene): D1 → C-1 → D3 → D2.
No positivity proof (D3, D2) may land while C-1 is open, and the
conclusion-check at D3/D2 includes: the proof does not route through the
divergent-tsum branch (a divergent tsum is 0, which would satisfy
0 ≤ liSum spuriously). If C-1 stalls: R6 stop with the exact goal; D3/D2
hold.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.PlacementSet
import Mathlib.Algebra.Order.BigOperators.Group.Multiset
import Mathlib.Topology.Sequences
import Mathlib.Topology.MetricSpace.ProperSpace
import Mathlib.Analysis.SpecificLimits.Basic

noncomputable section

/-- **D0 — the kernel** (DESIGN §"The kernel family"):
`K(n, a, β; z) = 1 − ((z − a)/(z − (2β − a)))ⁿ`. The anchor pair
`{a, 2β − a}` is mirror-symmetric about `Re = β`; the kernel's unit circle
is that line. -/
def liKernel (n : ℕ) (a β : ℝ) (z : ℂ) : ℂ :=
  1 - ((z - (a : ℂ)) / (z - (2 * (β : ℂ) - (a : ℂ)))) ^ n

namespace ASection

/-- **D0 — the sum.** The doubled real part renders the conjugate-paired
sum (the kernel has real parameters, so `K(conj ρ) = conj (K ρ)` — the
design's first rendering option). No junk values: the kernel's pole
`2β − a` is real while every `sphereZero k` has `im > 0`, so the sum never
touches a division by zero — totality is genuine. -/
def liSum (A : ASection) (a β : ℝ) (n : ℕ) : ℝ :=
  ∑' k, 2 * (liKernel n a β (A.sphereZero k)).re

/- D0's summability obligation (the retired "C-1" label) is CLOSED at the
end of this file (`ASection.liSum_summable`) — it consumes the reduction
stock below, so its proof sits after it in file order. -/

end ASection

/-! ## D1 scaffolding (all PROVED helpers; R8: helpers are never sorried)

The key identity, the ratio's modulus trichotomy, and the simultaneous
return of unit powers. R5 record: the pin's Dirichlet approximation
(`Real.exists_int_int_abs_mul_sub_le`,
Mathlib/NumberTheory/DiophantineApproximation/Basic.lean) is
one-dimensional and Mathlib carries no simultaneous variant (grep
2026-07-04: "simultaneous" empty over NumberTheory/), so the joint return
is proved inline — the sanctioned pigeonhole, executed in metric form:
sequential compactness of the finite torus supplies the
two-multiples-in-one-cell step, and the exponent difference is the
return. -/

/-- The anchor-pair Möbius ratio underlying the kernel:
`liKernel n a β z = 1 - (liRatio a β z) ^ n` definitionally. Its unit
circle is the mirror line `Re = β` (the key identity below). -/
def liRatio (a β : ℝ) (z : ℂ) : ℂ :=
  (z - (a : ℂ)) / (z - (2 * (β : ℂ) - (a : ℂ)))

theorem liKernel_eq_ratio (n : ℕ) (a β : ℝ) (z : ℂ) :
    liKernel n a β z = 1 - liRatio a β z ^ n := rfl

/-- Off the real axis the ratio's numerator is nonzero (the anchor `a` is
real). -/
theorem liRatio_num_ne_zero {z : ℂ} (hz : z.im ≠ 0) (a : ℝ) :
    z - (a : ℂ) ≠ 0 := by
  intro h
  apply hz
  simpa using congrArg Complex.im h

/-- Off the real axis the ratio's denominator is nonzero (the mirror
anchor `2β − a` is real) — totality of the kernel is genuine, no junk
division. -/
theorem liRatio_den_ne_zero {z : ℂ} (hz : z.im ≠ 0) (a β : ℝ) :
    z - (2 * (β : ℂ) - (a : ℂ)) ≠ 0 := by
  have h2 : 2 * (β : ℂ) - (a : ℂ) = ((2 * β - a : ℝ) : ℂ) := by push_cast; ring
  rw [h2]
  intro h
  apply hz
  simpa using congrArg Complex.im h

theorem liRatio_ne_zero {z : ℂ} (hz : z.im ≠ 0) (a β : ℝ) :
    liRatio a β z ≠ 0 :=
  div_ne_zero (liRatio_num_ne_zero hz a) (liRatio_den_ne_zero hz a β)

/-- **The key identity** (mission D1): the difference of squared distances
to the anchor pair reads off the side of the mirror line:
`‖z − a‖² − ‖z − (2β − a)‖² = 4(β − a)(Re z − β)`. Hence the ratio modulus
is `< 1 ⟺ (β − a)(Re z − β) < 0` and `= 1 ⟺ Re z = β`. -/
theorem normSq_anchor_sub_mirror (z : ℂ) (a β : ℝ) :
    ‖z - (a : ℂ)‖ ^ 2 - ‖z - (2 * (β : ℂ) - (a : ℂ))‖ ^ 2
      = 4 * (β - a) * (z.re - β) := by
  have h2 : 2 * (β : ℂ) - (a : ℂ) = ((2 * β - a : ℝ) : ℂ) := by push_cast; ring
  rw [h2]
  simp only [← Complex.normSq_eq_norm_sq, Complex.normSq_apply, Complex.sub_re,
    Complex.sub_im, Complex.ofReal_re, Complex.ofReal_im]
  ring

/-- On the mirror line the ratio is unimodular. -/
theorem liRatio_norm_eq_one {z : ℂ} (hz : z.im ≠ 0) {a β : ℝ}
    (hre : z.re = β) : ‖liRatio a β z‖ = 1 := by
  have hkey : ‖z - (a : ℂ)‖ ^ 2 - ‖z - (2 * (β : ℂ) - (a : ℂ))‖ ^ 2
      = 4 * ((β - a) * (z.re - β)) := by
    linear_combination normSq_anchor_sub_mirror z a β
  rw [hre, sub_self, mul_zero, mul_zero] at hkey
  have hden : (0 : ℝ) < ‖z - (2 * (β : ℂ) - (a : ℂ))‖ :=
    norm_pos_iff.mpr (liRatio_den_ne_zero hz a β)
  have heq : ‖z - (a : ℂ)‖ = ‖z - (2 * (β : ℂ) - (a : ℂ))‖ :=
    (sq_eq_sq₀ (norm_nonneg _) (norm_nonneg _)).mp (by linarith)
  unfold liRatio
  rw [norm_div, heq, div_self hden.ne']

/-- Strictly on the near side of the mirror the ratio modulus is `< 1`
(the D3 case). -/
theorem liRatio_norm_lt_one {z : ℂ} (hz : z.im ≠ 0) {a β : ℝ}
    (h : (β - a) * (z.re - β) < 0) : ‖liRatio a β z‖ < 1 := by
  have hkey : ‖z - (a : ℂ)‖ ^ 2 - ‖z - (2 * (β : ℂ) - (a : ℂ))‖ ^ 2
      = 4 * ((β - a) * (z.re - β)) := by
    linear_combination normSq_anchor_sub_mirror z a β
  have hden : (0 : ℝ) < ‖z - (2 * (β : ℂ) - (a : ℂ))‖ :=
    norm_pos_iff.mpr (liRatio_den_ne_zero hz a β)
  have hlt : ‖z - (a : ℂ)‖ < ‖z - (2 * (β : ℂ) - (a : ℂ))‖ :=
    (sq_lt_sq₀ (norm_nonneg _) (norm_nonneg _)).mp (by linarith)
  unfold liRatio
  rw [norm_div]
  exact (div_lt_one hden).mpr hlt

/-- Strictly on the wrong side of the mirror the ratio modulus exceeds 1 —
the contrapositive's engine. -/
theorem one_lt_liRatio_norm {z : ℂ} (hz : z.im ≠ 0) {a β : ℝ}
    (h : 0 < (β - a) * (z.re - β)) : 1 < ‖liRatio a β z‖ := by
  have hkey : ‖z - (a : ℂ)‖ ^ 2 - ‖z - (2 * (β : ℂ) - (a : ℂ))‖ ^ 2
      = 4 * ((β - a) * (z.re - β)) := by
    linear_combination normSq_anchor_sub_mirror z a β
  have hden : (0 : ℝ) < ‖z - (2 * (β : ℂ) - (a : ℂ))‖ :=
    norm_pos_iff.mpr (liRatio_den_ne_zero hz a β)
  have hlt : ‖z - (2 * (β : ℂ) - (a : ℂ))‖ < ‖z - (a : ℂ)‖ :=
    (sq_lt_sq₀ (norm_nonneg _) (norm_nonneg _)).mp (by linarith)
  unfold liRatio
  rw [norm_div]
  exact (one_lt_div hden).mpr hlt

/-- Mirror-line termwise positivity: on `Re z = β` the ratio is
unimodular, so `Re K = 1 − Re(ωⁿ) ≥ 0` — the `2(1 − cos nθ) ≥ 0` form. -/
theorem liKernel_re_nonneg {z : ℂ} (hz : z.im ≠ 0) {a β : ℝ}
    (hre : z.re = β) (n : ℕ) : 0 ≤ (liKernel n a β z).re := by
  have h2 : (liRatio a β z ^ n).re ≤ 1 := by
    calc (liRatio a β z ^ n).re ≤ |(liRatio a β z ^ n).re| := le_abs_self _
      _ ≤ ‖liRatio a β z ^ n‖ := Complex.abs_re_le_norm _
      _ = 1 := by rw [norm_pow, liRatio_norm_eq_one hz hre, one_pow]
  rw [liKernel_eq_ratio, Complex.sub_re, Complex.one_re]
  linarith

/-- **The simultaneous return** (the Dirichlet/pigeonhole step of the D1
brief): finitely many unit complex numbers return jointly near 1 at
arbitrarily late powers. Proof: the orbit of multiples of `max N 1` on the
finite torus `∏_{ω ∈ t} S¹` (compact: `isCompact_univ_pi` +
`isCompact_sphere`) has a convergent subsequence
(`IsCompact.tendsto_subseq`); two subsequence points within `ε/2` of the
limit are within `ε` of each other, and dividing them — coordinatewise,
`‖ω^{j₂M} − ω^{j₁M}‖ = ‖ω^{(j₂−j₁)M} − 1‖` on the unit circle — produces
the return, of exponent `≥ max N 1`. -/
theorem exists_pow_forall_norm_sub_one_lt (t : Finset ℂ)
    (ht : ∀ ω ∈ t, ‖ω‖ = 1) {ε : ℝ} (hε : 0 < ε) (N : ℕ) :
    ∃ n : ℕ, N ≤ n ∧ 1 ≤ n ∧ ∀ ω ∈ t, ‖ω ^ n - 1‖ < ε := by
  classical
  set N₁ : ℕ := max N 1 with hN₁def
  set u : ℕ → (t → ℂ) := fun j ω => (ω : ℂ) ^ (j * N₁) with hudef
  have hmem : ∀ j, u j ∈ Set.univ.pi fun _ : t => Metric.sphere (0 : ℂ) 1 := by
    intro j
    rw [Set.mem_univ_pi]
    intro ω
    simp only [hudef]
    rw [mem_sphere_zero_iff_norm, norm_pow, ht ω ω.2, one_pow]
  have hcpt : IsCompact (Set.univ.pi fun _ : t => Metric.sphere (0 : ℂ) 1) :=
    isCompact_univ_pi fun _ => isCompact_sphere 0 1
  obtain ⟨p, -, φ, hφ, hconv⟩ := hcpt.tendsto_subseq hmem
  obtain ⟨K, hK⟩ := Metric.tendsto_atTop.mp hconv (ε / 2) (half_pos hε)
  have h₁ : dist (u (φ K)) p < ε / 2 := hK K le_rfl
  have h₂ : dist (u (φ (K + 1))) p < ε / 2 := hK (K + 1) (Nat.le_succ K)
  have hφlt : φ K < φ (K + 1) := hφ (Nat.lt_succ_self K)
  have hdist : dist (u (φ (K + 1))) (u (φ K)) < ε := by
    calc dist (u (φ (K + 1))) (u (φ K))
        ≤ dist (u (φ (K + 1))) p + dist (u (φ K)) p := dist_triangle_right _ _ _
      _ < ε / 2 + ε / 2 := add_lt_add h₂ h₁
      _ = ε := add_halves ε
  have key : ∀ i : t, ‖(i : ℂ) ^ ((φ (K + 1) - φ K) * N₁) - 1‖ < ε := by
    intro i
    have hcoord : dist (u (φ (K + 1)) i) (u (φ K) i)
        ≤ dist (u (φ (K + 1))) (u (φ K)) := dist_le_pi_dist _ _ i
    have hval : dist (u (φ (K + 1)) i) (u (φ K) i)
        = ‖(i : ℂ) ^ ((φ (K + 1) - φ K) * N₁) - 1‖ := by
      simp only [hudef]
      rw [dist_eq_norm]
      have hsplit : (i : ℂ) ^ (φ (K + 1) * N₁)
          = (i : ℂ) ^ (φ K * N₁) * (i : ℂ) ^ ((φ (K + 1) - φ K) * N₁) := by
        rw [← pow_add, ← Nat.add_mul, Nat.add_sub_cancel' hφlt.le]
      rw [hsplit]
      have hfac : (i : ℂ) ^ (φ K * N₁) * (i : ℂ) ^ ((φ (K + 1) - φ K) * N₁)
            - (i : ℂ) ^ (φ K * N₁)
          = (i : ℂ) ^ (φ K * N₁) * ((i : ℂ) ^ ((φ (K + 1) - φ K) * N₁) - 1) := by
        ring
      rw [hfac, norm_mul, norm_pow, ht i i.2, one_pow, one_mul]
    calc ‖(i : ℂ) ^ ((φ (K + 1) - φ K) * N₁) - 1‖
        = dist (u (φ (K + 1)) i) (u (φ K) i) := hval.symm
      _ ≤ dist (u (φ (K + 1))) (u (φ K)) := hcoord
      _ < ε := hdist
  refine ⟨(φ (K + 1) - φ K) * N₁, ?_, ?_, fun ω hω => key ⟨ω, hω⟩⟩
  · calc N ≤ N₁ := le_max_left _ _
      _ ≤ (φ (K + 1) - φ K) * N₁ := Nat.le_mul_of_pos_left _ (by omega)
  · have hpos : 0 < (φ (K + 1) - φ K) * N₁ :=
      Nat.mul_pos (by omega) (by omega)
    omega

/-- The D1 contrapositive engine: one element strictly on the wrong side
of the mirror for the anchor `a` drives some kernel sum negative. At a
simultaneous return of ALL the ratio directions every term is
`≤ 2 − rⁿ` (aligned cosine `> 1/2`, so `Re(wⁿ) > rⁿ/2`), and the
wrong-sided element's `rⁿ > 1ⁿ` outgrows `2·card S`. The side
classification is `a`-independent (`r > 1 ⟺ (β − a)(Re z − β) > 0`, the
key identity), so no "anchor close to β" care is needed. -/
theorem exists_liKernel_sum_neg (S : Multiset ℂ) (hS : ∀ z ∈ S, z.im ≠ 0)
    {a β : ℝ} {z₀ : ℂ} (hz₀ : z₀ ∈ S)
    (hwrong : 0 < (β - a) * (z₀.re - β)) :
    ∃ n : ℕ, 1 ≤ n ∧ (S.map fun z => 2 * (liKernel n a β z).re).sum < 0 := by
  classical
  set dir : ℂ → ℂ := fun z => liRatio a β z / (‖liRatio a β z‖ : ℂ) with hdir
  set t : Finset ℂ := S.toFinset.image dir with ht_def
  have ht : ∀ ω ∈ t, ‖ω‖ = 1 := by
    intro ω hω
    obtain ⟨z, hzS, rfl⟩ := Finset.mem_image.mp hω
    have hzim : z.im ≠ 0 := hS z (Multiset.mem_toFinset.mp hzS)
    have hne : liRatio a β z ≠ 0 := liRatio_ne_zero hzim a β
    simp only [hdir]
    rw [norm_div, Complex.norm_real, Real.norm_eq_abs, abs_norm,
      div_self (norm_ne_zero_iff.mpr hne)]
  have hr₀ : 1 < ‖liRatio a β z₀‖ := one_lt_liRatio_norm (hS z₀ hz₀) hwrong
  obtain ⟨N, hN⟩ := Filter.eventually_atTop.mp
    ((tendsto_pow_atTop_atTop_of_one_lt hr₀).eventually_gt_atTop
      (2 * (Multiset.card S : ℝ)))
  obtain ⟨n, hnN, hn1, halign⟩ :=
    exists_pow_forall_norm_sub_one_lt t ht one_half_pos N
  refine ⟨n, hn1, ?_⟩
  have hterm : ∀ z ∈ S, 2 * (liKernel n a β z).re
      ≤ 2 - ‖liRatio a β z‖ ^ n := by
    intro z hz
    have hzim := hS z hz
    have hwne : liRatio a β z ≠ 0 := liRatio_ne_zero hzim a β
    have hrpos : (0 : ℝ) < ‖liRatio a β z‖ := norm_pos_iff.mpr hwne
    have hrneC : ((‖liRatio a β z‖ : ℝ) : ℂ) ≠ 0 :=
      Complex.ofReal_ne_zero.mpr hrpos.ne'
    have hmemt : dir z ∈ t :=
      Finset.mem_image_of_mem dir (Multiset.mem_toFinset.mpr hz)
    have halz : ‖dir z ^ n - 1‖ < 1 / 2 := halign (dir z) hmemt
    have hfact : liRatio a β z ^ n
        = ((‖liRatio a β z‖ ^ n : ℝ) : ℂ) * dir z ^ n := by
      simp only [hdir]
      rw [div_pow, Complex.ofReal_pow, ← mul_div_assoc,
        mul_div_cancel_left₀ _ (pow_ne_zero n hrneC)]
    have hRe : (liRatio a β z ^ n).re
        = ‖liRatio a β z‖ ^ n * (dir z ^ n).re := by
      rw [hfact, Complex.re_ofReal_mul]
    have hdirRe : (1 : ℝ) / 2 < (dir z ^ n).re := by
      have h1 : (1 : ℝ) - (dir z ^ n).re ≤ ‖dir z ^ n - 1‖ := by
        calc (1 : ℝ) - (dir z ^ n).re = (1 - dir z ^ n).re := by
              rw [Complex.sub_re, Complex.one_re]
          _ ≤ |(1 - dir z ^ n).re| := le_abs_self _
          _ ≤ ‖1 - dir z ^ n‖ := Complex.abs_re_le_norm _
          _ = ‖dir z ^ n - 1‖ := norm_sub_rev _ _
      linarith
    have hprod : ‖liRatio a β z‖ ^ n * (1 / 2)
        < ‖liRatio a β z‖ ^ n * (dir z ^ n).re :=
      mul_lt_mul_of_pos_left hdirRe (pow_pos hrpos n)
    have hKre : (liKernel n a β z).re = 1 - (liRatio a β z ^ n).re := by
      rw [liKernel_eq_ratio, Complex.sub_re, Complex.one_re]
    rw [hKre, hRe]
    linarith
  have hsum2 : (S.map fun z => 2 - ‖liRatio a β z‖ ^ n).sum
      = 2 * (Multiset.card S : ℝ)
        - (S.map fun z => ‖liRatio a β z‖ ^ n).sum := by
    rw [Multiset.sum_map_sub]
    congr 1
    rw [Multiset.map_const', Multiset.sum_replicate, nsmul_eq_mul]
    ring
  have hnonneg : ∀ x ∈ S.map fun z => ‖liRatio a β z‖ ^ n, (0 : ℝ) ≤ x := by
    intro x hx
    obtain ⟨z, hzS, rfl⟩ := Multiset.mem_map.mp hx
    positivity
  have hsingle : ‖liRatio a β z₀‖ ^ n
      ≤ (S.map fun z => ‖liRatio a β z‖ ^ n).sum :=
    Multiset.single_le_sum hnonneg _ (Multiset.mem_map_of_mem _ hz₀)
  have hbig : 2 * (Multiset.card S : ℝ) < ‖liRatio a β z₀‖ ^ n := hN n hnN
  calc (S.map fun z => 2 * (liKernel n a β z).re).sum
      ≤ (S.map fun z => 2 - ‖liRatio a β z‖ ^ n).sum :=
        Multiset.sum_map_le_sum_map _ _ hterm
    _ = 2 * (Multiset.card S : ℝ)
        - (S.map fun z => ‖liRatio a β z‖ ^ n).sum := hsum2
    _ ≤ 2 * (Multiset.card S : ℝ) - ‖liRatio a β z₀‖ ^ n := by linarith
    _ < 0 := by linarith

/-- **D1 — finite-multiset Bombieri–Lagarias** (ladder L2; DESIGN:
"unconditional, pure algebra + Dirichlet approximation … the reduction's
engine, fully formalizable now"): for a finite multiset avoiding the
anchors, two-sided positivity for all n ⟺ all elements have `Re = β`.

FIDELITY NOTE (author's rider 1, 2026-07-04): the `im ≠ 0` hypothesis
STRENGTHENS the BL source's literal two-point avoidance; it is chosen as
the consumer-exact rendering — it keeps every kernel anchor-free for every
quantified `a` (any real element is some `a`'s mirror), and the D2 consumer
feeds only conjugate-closed zero multisets, all non-real.

PROVED (B2.2 burn, 2026-07-04). (⟸): the key identity
`‖z − a‖² − ‖z − (2β − a)‖² = 4(β − a)(Re z − β)` makes every ratio
unimodular on the mirror line, so each term is `2(1 − cos nθ) ≥ 0`
(`liKernel_re_nonneg`), on both sides. (⟹) by contraposition: an element
off the line is strictly wrong-sided for the anchor `a = β ∓ 1` — the
side classification `r > 1 ⟺ (β − a)(Re z − β) > 0` is `a`-independent —
and `exists_liKernel_sum_neg` drives the corresponding family negative at
a simultaneous return of all ratio directions (compactness pigeonhole,
`exists_pow_forall_norm_sub_one_lt`; R5: no simultaneous Dirichlet lemma
in the pin). -/
theorem finite_BL (S : Multiset ℂ) (β : ℝ) (hS : ∀ z ∈ S, z.im ≠ 0) :
    ((∀ a : ℝ, a < β → ∀ n : ℕ, 1 ≤ n →
        0 ≤ (S.map fun z => 2 * (liKernel n a β z).re).sum)
      ∧ (∀ a : ℝ, β < a → ∀ n : ℕ, 1 ≤ n →
        0 ≤ (S.map fun z => 2 * (liKernel n a β z).re).sum))
      ↔ ∀ z ∈ S, z.re = β := by
  constructor
  · rintro ⟨h₁, h₂⟩ z₀ hz₀
    by_contra hne
    rcases lt_or_gt_of_ne hne with hlt | hgt
    · -- `Re z₀ < β` is wrong-sided for the anchor `a = β + 1 > β`
      have hwrong : 0 < (β - (β + 1)) * (z₀.re - β) := by
        have h : (β - (β + 1)) * (z₀.re - β) = β - z₀.re := by ring
        rw [h]
        linarith
      obtain ⟨n, hn1, hneg⟩ := exists_liKernel_sum_neg S hS hz₀ hwrong
      exact absurd (h₂ (β + 1) (lt_add_one β) n hn1) (not_le.mpr hneg)
    · -- `Re z₀ > β` is wrong-sided for the anchor `a = β − 1 < β`
      have hwrong : 0 < (β - (β - 1)) * (z₀.re - β) := by
        have h : (β - (β - 1)) * (z₀.re - β) = z₀.re - β := by ring
        rw [h]
        linarith
      obtain ⟨n, hn1, hneg⟩ := exists_liKernel_sum_neg S hS hz₀ hwrong
      exact absurd (h₁ (β - 1) (by linarith) n hn1) (not_le.mpr hneg)
  · intro hall
    refine ⟨fun a ha n hn => ?_, fun a ha n hn => ?_⟩ <;>
    · refine Multiset.sum_nonneg fun x hx => ?_
      obtain ⟨z, hzS, rfl⟩ := Multiset.mem_map.mp hx
      have h : 0 ≤ (liKernel n a β z).re :=
        liKernel_re_nonneg (hS z hzS) (hall z hzS) n
      linarith

/-- **D2 — the class reduction: the adopted (iv) target v0.2, as an iff**
(DESIGN: via Theorem 2 both-sidedly + D1 + the limit passage; the limit
passage is the analytic face and may hold an honestly-labeled sorry after
D1 is proved — that isolates the gap exactly as the ladder prescribes).
A proved-equivalent restatement of the open node, never a hypothesis. -/
theorem ASection.placement_set_iff_liSum (A : ASection) :
    (∀ ⦃z w : ℂ⦄, A.F z = 0 → A.F w = 0 → 0 < z.im → 0 < w.im → z.re = w.re)
      ↔ ∃ β : ℝ, (∀ a : ℝ, a < β → ∀ n : ℕ, 1 ≤ n → 0 ≤ A.liSum a β n)
          ∧ (∀ a : ℝ, β < a → ∀ n : ℕ, 1 ≤ n → 0 ≤ A.liSum a β n) := by
  sorry

/- D3 — the first side — is PROVED at the end of this file
(`ASection.liSum_first_side`, after the reduction stock it consumes:
`re_le_upperEdge`). -/

/-! ## C-1 reduction stock (B2.2 burn session, 2026-07-04; all PROVED)

Steps (1), (3), (4) of the C-1 decomposition, landed proved: the upper
edge, the center-shift stability of quadratic point-density, the paired
binomial tail bound, the Sekatskii-(ii) bridge, and the comparison closing
C-1's summability FROM quadratic point-density (single-center form
included).

REGISTER (author's ruling, 2026-07-04; replaces the "R6 stop on quadratic
density" formerly recorded here — that stop mistook a possession for a
gap): C1–C4 are the DEFINITION of an A-section; they are not under
revision. Every convergence/density property C-1 needs is a possession of
that definition, carried by C3: the infinite Weierstrass factorization
over the full divisor, factoring THROUGH THE POLE, is one convergent
meromorphic section that joins the residue-ℂ zero-spheres (∏ₙ 𝓔(·;qₙ)) to
the residue-ℝ skeleton (R, the concentric real axis) against the single
pole at N. Its convergence is intrinsic to C3 being a factorization at
all — not a rider, not a side-condition. A divisor without a convergent
through-the-pole factorization is not an A-section — it fails C3 — so no
such object obstructs step (2). The remaining `sorry` at `liSum_summable`
is a debt of transcription (making C3's possession visible to the
checker), not of belief; the rendered transcription fix is
words-before-commits (author's gate). D3/D2 hold per the junk-tsum
hygiene rider until C-1 is green. -/

/-- **C-1 step (1) — the upper edge**: every enumerated zero-sphere
representative has real part at most the half-space abscissa — C2's
zero-freeness (`zero_free_on_halfSpace`) read at the divisor through
`stem_zero_of_sphereZero`. With `c3_lowerEdge` the divisor's real parts
lie in a bounded strip, so Sekatskii (ii)'s numerator `1 + |Re ρ|` is
bounded on the class. PROVED. -/
theorem ASection.re_le_upperEdge (A : ASection) (k : ℕ) :
    (A.sphereZero k).re ≤ A.Ω₀ := by
  by_contra h
  exact A.zero_free_on_halfSpace (not_le.mp h) (A.stem_zero_of_sphereZero k)

/-- **C-1 step (3) scaffolding — center-shift stability of quadratic
point-density**: density at one real center gives it at every real center
(`1 + ‖ρ − c‖² ≤ (2 + 2(c′ − c)²)(1 + ‖ρ − c′‖²)`). The C-1 residue is
therefore a single center-free goal. PROVED. -/
theorem summable_inv_one_add_norm_sq_center_shift {ρ : ℕ → ℂ} {c : ℝ}
    (h : Summable fun k => 1 / (1 + ‖ρ k - (c : ℂ)‖ ^ 2)) (c' : ℝ) :
    Summable fun k => 1 / (1 + ‖ρ k - (c' : ℂ)‖ ^ 2) := by
  refine Summable.of_nonneg_of_le (fun k => by positivity) (fun k => ?_)
    (h.mul_left (2 + 2 * (c' - c) ^ 2))
  have hpos : (0 : ℝ) < 1 + ‖ρ k - (c : ℂ)‖ ^ 2 := by positivity
  have hpos' : (0 : ℝ) < 1 + ‖ρ k - (c' : ℂ)‖ ^ 2 := by positivity
  have htri : ‖ρ k - (c : ℂ)‖ ≤ ‖ρ k - (c' : ℂ)‖ + |c - c'| := by
    calc ‖ρ k - (c : ℂ)‖ = ‖(ρ k - (c' : ℂ)) + ((c' : ℂ) - (c : ℂ))‖ := by
          congr 1
          ring
      _ ≤ ‖ρ k - (c' : ℂ)‖ + ‖(c' : ℂ) - (c : ℂ)‖ := norm_add_le _ _
      _ = ‖ρ k - (c' : ℂ)‖ + |c - c'| := by
          rw [← Complex.ofReal_sub, Complex.norm_real, Real.norm_eq_abs,
            abs_sub_comm]
  rw [mul_one_div, div_le_div_iff₀ hpos' hpos]
  nlinarith [htri, norm_nonneg (ρ k - (c : ℂ)), norm_nonneg (ρ k - (c' : ℂ)),
    abs_nonneg (c - c'), sq_abs (c - c'),
    sq_nonneg (‖ρ k - (c' : ℂ)‖ - |c - c'|)]

/-- **C-1 step (4) scaffolding — the paired binomial tail bound**: for
`‖w‖ ≤ D`, `1 ≤ D`, the remainder after the `j = 0, 1` binomial terms is
quadratic: `‖(1 + w)ⁿ − 1 − n·w‖ ≤ ‖w‖² (1 + D)ⁿ`. Isolates the one term
of the kernel expansion that needs `Re` (the `j = 1` term); the quadratic
remainder is what the point-density absorbs outright. PROVED. -/
theorem norm_one_add_pow_sub_one_sub_mul_le (n : ℕ) {w : ℂ} {D : ℝ}
    (hD : 1 ≤ D) (hw : ‖w‖ ≤ D) :
    ‖(1 + w) ^ n - 1 - (n : ℂ) * w‖ ≤ ‖w‖ ^ 2 * (1 + D) ^ n := by
  rcases Nat.eq_zero_or_pos n with rfl | hn
  · simp only [pow_zero, Nat.cast_zero, zero_mul, sub_zero, sub_self,
      norm_zero, mul_one]
    positivity
  have hD0 : (0 : ℝ) ≤ D := le_trans zero_le_one hD
  have hexp : (1 + w) ^ n = ∑ k ∈ Finset.range (n + 1), w ^ k * (n.choose k : ℂ) := by
    rw [add_comm 1 w, add_pow]
    exact Finset.sum_congr rfl fun k _ => by rw [one_pow, mul_one]
  have hsplit : ∑ k ∈ Finset.range (n + 1), w ^ k * (n.choose k : ℂ)
      = 1 + (n : ℂ) * w + ∑ k ∈ Finset.Ico 2 (n + 1), w ^ k * (n.choose k : ℂ) := by
    rw [Finset.range_eq_Ico,
      Finset.sum_eq_sum_Ico_succ_bot (by omega : (0 : ℕ) < n + 1), zero_add,
      Finset.sum_eq_sum_Ico_succ_bot (by omega : (1 : ℕ) < n + 1),
      show (1 : ℕ) + 1 = 2 from rfl,
      pow_zero, one_mul, pow_one, Nat.choose_zero_right, Nat.choose_one_right,
      Nat.cast_one]
    ring
  have hkey : (1 + w) ^ n - 1 - (n : ℂ) * w
      = ∑ k ∈ Finset.Ico 2 (n + 1), w ^ k * (n.choose k : ℂ) := by
    rw [hexp, hsplit]
    ring
  rw [hkey]
  have hbound : ∀ k ∈ Finset.Ico 2 (n + 1),
      ‖w ^ k * (n.choose k : ℂ)‖ ≤ ‖w‖ ^ 2 * (D ^ k * (n.choose k : ℝ)) := by
    intro k hk
    obtain ⟨hk2, -⟩ := Finset.mem_Ico.mp hk
    rw [norm_mul, norm_pow, Complex.norm_natCast]
    have hpowsplit : ‖w‖ ^ k = ‖w‖ ^ 2 * ‖w‖ ^ (k - 2) := by
      rw [← pow_add, Nat.add_sub_cancel' hk2]
    have hwk : ‖w‖ ^ (k - 2) ≤ D ^ k :=
      le_trans (pow_le_pow_left₀ (norm_nonneg w) hw _)
        (pow_le_pow_right₀ hD (by omega))
    calc ‖w‖ ^ k * (n.choose k : ℝ)
        = ‖w‖ ^ 2 * ‖w‖ ^ (k - 2) * (n.choose k : ℝ) := by rw [hpowsplit]
      _ ≤ ‖w‖ ^ 2 * D ^ k * (n.choose k : ℝ) :=
          mul_le_mul_of_nonneg_right
            (mul_le_mul_of_nonneg_left hwk (sq_nonneg _)) (Nat.cast_nonneg _)
      _ = ‖w‖ ^ 2 * (D ^ k * (n.choose k : ℝ)) := mul_assoc _ _ _
  calc ‖∑ k ∈ Finset.Ico 2 (n + 1), w ^ k * (n.choose k : ℂ)‖
      ≤ ∑ k ∈ Finset.Ico 2 (n + 1), ‖w ^ k * (n.choose k : ℂ)‖ :=
        norm_sum_le _ _
    _ ≤ ∑ k ∈ Finset.Ico 2 (n + 1), ‖w‖ ^ 2 * (D ^ k * (n.choose k : ℝ)) :=
        Finset.sum_le_sum hbound
    _ = ‖w‖ ^ 2 * ∑ k ∈ Finset.Ico 2 (n + 1), D ^ k * (n.choose k : ℝ) := by
        rw [Finset.mul_sum]
    _ ≤ ‖w‖ ^ 2 * ∑ k ∈ Finset.range (n + 1), D ^ k * (n.choose k : ℝ) := by
        refine mul_le_mul_of_nonneg_left
          (Finset.sum_le_sum_of_subset_of_nonneg ?_ ?_) (sq_nonneg _)
        · rw [Finset.range_eq_Ico]
          exact Finset.Ico_subset_Ico (by omega) le_rfl
        · intro k _ _
          exact mul_nonneg (pow_nonneg hD0 _) (Nat.cast_nonneg _)
    _ = ‖w‖ ^ 2 * (1 + D) ^ n := by
        rw [add_comm 1 D, add_pow]
        congr 1
        exact Finset.sum_congr rfl fun k _ => by rw [one_pow, mul_one]

/-- **Sekatskii (ii), in-frame**: from quadratic point-density at one
center, the strip (`c3_lowerEdge` + `re_le_upperEdge`) upgrades to the
bounded-numerator form `Σₖ (1 + |Re ρₖ|)/(1 + ‖ρₖ − c‖²) < ∞` at every
real center — the mission decomposition's `blDensity`, exactly Theorem 2's
convergence condition (READ_weil_li_findings.md, OCR shape flagged there).
PROVED. -/
theorem ASection.blDensity_of_density (A : ASection) {c₀ : ℝ}
    (hd : Summable fun k => 1 / (1 + ‖A.sphereZero k - (c₀ : ℂ)‖ ^ 2)) (c : ℝ) :
    Summable fun k =>
      (1 + |(A.sphereZero k).re|) / (1 + ‖A.sphereZero k - (c : ℂ)‖ ^ 2) := by
  obtain ⟨βlo, hβlo⟩ := A.c3_lowerEdge
  set N : ℝ := 1 + max |βlo| |A.Ω₀| with hN_def
  have hshift := summable_inv_one_add_norm_sq_center_shift hd c
  refine Summable.of_nonneg_of_le (fun k => by positivity) (fun k => ?_)
    (hshift.mul_left N)
  have h1 : |(A.sphereZero k).re| ≤ max |βlo| |A.Ω₀| := by
    rw [abs_le]
    constructor
    · have h2 := neg_abs_le βlo
      have h3 : |βlo| ≤ max |βlo| |A.Ω₀| := le_max_left _ _
      linarith [hβlo k]
    · have h2 := le_abs_self A.Ω₀
      have h3 : |A.Ω₀| ≤ max |βlo| |A.Ω₀| := le_max_right _ _
      linarith [A.re_le_upperEdge k]
  rw [mul_one_div]
  have h4 : 1 + |(A.sphereZero k).re| ≤ N := by
    rw [hN_def]
    linarith
  gcongr

/-- **C-1 steps (3)+(4) — the paired binomial comparison, PROVED**: C-1's
summability follows from quadratic point-density of the divisor at the
kernel's mirror anchor `2β − a`. The strip (`c3_lowerEdge` +
`re_le_upperEdge`) bounds the `j = 1` binomial term's numerator through
`Re` (the worked paired expansion's only `1/‖ρ − c‖`-order term); the
quadratic remainder is majorized outright by the tail bound. What remains
of C-1 is exactly the hypothesis `hd` — the R6 stop of record. -/
theorem ASection.liSum_summable_of_density (A : ASection) (a β : ℝ) (n : ℕ)
    (hd : Summable fun k =>
      1 / (1 + ‖A.sphereZero k - ((2 * β - a : ℝ) : ℂ)‖ ^ 2)) :
    Summable fun k => 2 * (liKernel n a β (A.sphereZero k)).re := by
  obtain ⟨βlo, hβlo⟩ := A.c3_lowerEdge
  set c : ℝ := 2 * β - a with hc_def
  set d : ℝ := c - a with hd_def
  set M : ℝ := max |βlo - c| |A.Ω₀ - c| with hM_def
  set D : ℝ := max |d| 1 with hD_def
  have hM0 : (0 : ℝ) ≤ M := le_trans (abs_nonneg _) (le_max_left _ _)
  have hD1 : (1 : ℝ) ≤ D := le_max_right _ _
  set B : ℝ := 4 * ((n : ℝ) * |d| * M + d ^ 2 * (1 + D) ^ n) with hB_def
  -- the tail: eventually 1 ≤ ‖ρₖ − c‖, from the density's vanishing terms
  have hev : ∀ᶠ k in Filter.atTop, 1 ≤ ‖A.sphereZero k - (c : ℂ)‖ := by
    have h0 : ∀ᶠ k in Filter.atTop,
        1 / (1 + ‖A.sphereZero k - (c : ℂ)‖ ^ 2) < 1 / 2 := by
      have h := hd.tendsto_cofinite_zero.eventually_lt_const one_half_pos
      rwa [Nat.cofinite_eq_atTop] at h
    filter_upwards [h0] with k hk
    by_contra hlt
    push_neg at hlt
    have hn0 := norm_nonneg (A.sphereZero k - (c : ℂ))
    have hle : 1 + ‖A.sphereZero k - (c : ℂ)‖ ^ 2 ≤ 2 := by nlinarith
    have hpos : (0 : ℝ) < 1 + ‖A.sphereZero k - (c : ℂ)‖ ^ 2 := by positivity
    have h2 := one_div_le_one_div_of_le hpos hle
    linarith
  refine Summable.of_norm_bounded_eventually_nat (hd.mul_left B) ?_
  filter_upwards [hev] with k hX1
  have him : (A.sphereZero k).im ≠ 0 := ne_of_gt (A.c3_sphere_nonreal k)
  have hreL : βlo ≤ (A.sphereZero k).re := hβlo k
  have hreU : (A.sphereZero k).re ≤ A.Ω₀ := A.re_le_upperEdge k
  set z : ℂ := A.sphereZero k with hz_def
  set X : ℝ := ‖z - (c : ℂ)‖ with hX_def
  have hX0 : (0 : ℝ) < X := lt_of_lt_of_le zero_lt_one hX1
  have hcC : 2 * (β : ℂ) - (a : ℂ) = ((c : ℝ) : ℂ) := by
    rw [hc_def]
    push_cast
    ring
  have hzc : z - ((c : ℝ) : ℂ) ≠ 0 := by
    rw [← hcC]
    exact liRatio_den_ne_zero him a β
  set w : ℂ := ((d : ℝ) : ℂ) / (z - ((c : ℝ) : ℂ)) with hw_def
  have hda : ((d : ℝ) : ℂ) = ((c : ℝ) : ℂ) - ((a : ℝ) : ℂ) := by
    rw [hd_def]
    push_cast
    ring
  -- the ratio in inverse-distance coordinates: liRatio = 1 + w
  have h1w : (1 : ℂ) + w = ((z - ((c : ℝ) : ℂ)) + ((d : ℝ) : ℂ)) / (z - ((c : ℝ) : ℂ)) := by
    rw [hw_def, add_div, div_self hzc]
  have hratio : liRatio a β z = 1 + w := by
    unfold liRatio
    rw [hcC, h1w, hda]
    congr 1
    ring
  have hK : liKernel n a β z = 1 - (1 + w) ^ n := by
    rw [liKernel_eq_ratio, hratio]
  -- norms of w
  have hnw : ‖w‖ = |d| / X := by
    rw [hw_def, norm_div, Complex.norm_real, Real.norm_eq_abs, hX_def]
  have hwD : ‖w‖ ≤ D := by
    rw [hnw]
    exact le_trans (div_le_self (abs_nonneg d) hX1) (le_max_left _ _)
  have hw2 : ‖w‖ ^ 2 = d ^ 2 / X ^ 2 := by
    rw [hnw, div_pow, sq_abs]
  have hT : ‖(1 + w) ^ n - 1 - (n : ℂ) * w‖ ≤ ‖w‖ ^ 2 * (1 + D) ^ n :=
    norm_one_add_pow_sub_one_sub_mul_le n hD1 hwD
  -- the strip bounds the j = 1 term's numerator
  have hstrip : |z.re - c| ≤ M := by
    rw [abs_le]
    constructor
    · have h2 := neg_abs_le (βlo - c)
      have h3 : |βlo - c| ≤ M := le_max_left _ _
      linarith
    · have h2 := le_abs_self (A.Ω₀ - c)
      have h3 : |A.Ω₀ - c| ≤ M := le_max_right _ _
      linarith
  have hwre : |w.re| ≤ |d| * M / X ^ 2 := by
    have h1 : w.re = d * ((z - ((c : ℝ) : ℂ))⁻¹).re := by
      rw [hw_def, div_eq_mul_inv, Complex.re_ofReal_mul]
    have h2 : ((z - ((c : ℝ) : ℂ))⁻¹).re = (z.re - c) / X ^ 2 := by
      rw [Complex.inv_re, Complex.normSq_eq_norm_sq, hX_def, Complex.sub_re,
        Complex.ofReal_re]
    rw [h1, h2]
    calc |d * ((z.re - c) / X ^ 2)| = |d| * |z.re - c| / X ^ 2 := by
          rw [abs_mul, abs_div, abs_of_nonneg (le_of_lt (pow_pos hX0 2)),
            mul_div_assoc]
      _ = |d| * |z.re - c| * (X ^ 2)⁻¹ := div_eq_mul_inv _ _
      _ ≤ |d| * M * (X ^ 2)⁻¹ :=
          mul_le_mul_of_nonneg_right
            (mul_le_mul_of_nonneg_left hstrip (abs_nonneg d))
            (inv_nonneg.mpr (le_of_lt (pow_pos hX0 2)))
      _ = |d| * M / X ^ 2 := (div_eq_mul_inv _ _).symm
  have hnre : ((n : ℂ) * w).re = (n : ℝ) * w.re := by
    simp [Complex.mul_re]
  -- the per-term bound
  have hKre : |(liKernel n a β z).re|
      ≤ ((n : ℝ) * |d| * M + d ^ 2 * (1 + D) ^ n) / X ^ 2 := by
    have hsplitK : liKernel n a β z
        = -((n : ℂ) * w) - ((1 + w) ^ n - 1 - (n : ℂ) * w) := by
      rw [hK]
      ring
    rw [hsplitK]
    have h4 : (-((n : ℂ) * w) - ((1 + w) ^ n - 1 - (n : ℂ) * w)).re
        = -(((n : ℂ) * w).re + ((1 + w) ^ n - 1 - (n : ℂ) * w).re) := by
      rw [Complex.sub_re, Complex.neg_re]
      ring
    rw [h4, abs_neg]
    calc |((n : ℂ) * w).re + ((1 + w) ^ n - 1 - (n : ℂ) * w).re|
        ≤ |((n : ℂ) * w).re| + |((1 + w) ^ n - 1 - (n : ℂ) * w).re| :=
          abs_add_le _ _
      _ ≤ (n : ℝ) * |d| * M / X ^ 2 + d ^ 2 * (1 + D) ^ n / X ^ 2 := by
          refine add_le_add ?_ ?_
          · rw [hnre, abs_mul, abs_of_nonneg (Nat.cast_nonneg (α := ℝ) n)]
            calc (n : ℝ) * |w.re| ≤ (n : ℝ) * (|d| * M / X ^ 2) :=
                  mul_le_mul_of_nonneg_left hwre (Nat.cast_nonneg n)
              _ = (n : ℝ) * |d| * M / X ^ 2 := by ring
          · calc |((1 + w) ^ n - 1 - (n : ℂ) * w).re|
                ≤ ‖(1 + w) ^ n - 1 - (n : ℂ) * w‖ := Complex.abs_re_le_norm _
              _ ≤ ‖w‖ ^ 2 * (1 + D) ^ n := hT
              _ = d ^ 2 * (1 + D) ^ n / X ^ 2 := by
                  rw [hw2]
                  ring
      _ = ((n : ℝ) * |d| * M + d ^ 2 * (1 + D) ^ n) / X ^ 2 :=
          (add_div _ _ _).symm
  -- assemble against the majorant
  have hX2 : (1 : ℝ) ≤ X ^ 2 := by nlinarith [hX1, hX0.le]
  have hXpos : (0 : ℝ) < X ^ 2 := pow_pos hX0 2
  have h1pos : (0 : ℝ) < 1 + X ^ 2 := by positivity
  have hS0 : (0 : ℝ) ≤ (n : ℝ) * |d| * M + d ^ 2 * (1 + D) ^ n := by
    have hD0 : (0 : ℝ) ≤ 1 + D := by linarith
    have h1 : (0 : ℝ) ≤ (n : ℝ) * |d| * M :=
      mul_nonneg (mul_nonneg (Nat.cast_nonneg n) (abs_nonneg d)) hM0
    have h2 : (0 : ℝ) ≤ d ^ 2 * (1 + D) ^ n :=
      mul_nonneg (sq_nonneg d) (pow_nonneg hD0 n)
    linarith
  rw [Real.norm_eq_abs, abs_mul, abs_two, mul_one_div]
  calc 2 * |(liKernel n a β z).re|
      ≤ 2 * (((n : ℝ) * |d| * M + d ^ 2 * (1 + D) ^ n) / X ^ 2) := by
        linarith [hKre]
    _ = (2 * ((n : ℝ) * |d| * M + d ^ 2 * (1 + D) ^ n)) / X ^ 2 := by ring
    _ ≤ (4 * ((n : ℝ) * |d| * M + d ^ 2 * (1 + D) ^ n)) / (1 + X ^ 2) := by
        rw [div_le_div_iff₀ hXpos h1pos]
        nlinarith [mul_nonneg hS0 (sub_nonneg.mpr hX2)]
    _ = B / (1 + X ^ 2) := by rw [hB_def]

/-- **The C-1 residue, single-center form (PROVED reduction)**: quadratic
point-density of the divisor at ONE real center closes C-1 for every
anchor pair and every `n` (center-shift + the paired binomial comparison).
The exact goal that remains of C-1 is the hypothesis `hd` — the R6 stop
of record. -/
theorem ASection.liSum_summable_of_density_at (A : ASection) {c₀ : ℝ}
    (hd : Summable fun k => 1 / (1 + ‖A.sphereZero k - (c₀ : ℂ)‖ ^ 2))
    (a β : ℝ) (n : ℕ) :
    Summable fun k => 2 * (liKernel n a β (A.sphereZero k)).re :=
  A.liSum_summable_of_density a β n
    (summable_inv_one_add_norm_sq_center_shift hd (2 * β - a))

/-! ## D0 and D3, closed (2026-07-06) -/

/-- **D0 — the summability obligation, CLOSED** (2026-06 label "C-1"
retired by author ruling — the label collided with hypothesis C1 and
Island C1). REGISTER (author, 2026-07-04, the ruling this closure
vindicates): convergence is a possession of the class — C3's divisor
control with C1 closing the divisor through the pole is exactly the
density that makes the paired kernel sums converge; the sorry that stood
here was "a debt of transcription, not of belief" (R8). DEBT PAID
(2026-07-06): the transcription is `c3_atN` — C3's own convergence clause
through N, the point where the divisor accumulates and every mirror
circle closes — consumed through the PROVED reduction
`liSum_summable_of_density_at` at c₀ = 0 (center-shift + the strip +
the Sekatskii-(ii) bridge + the paired binomial comparison). One clause,
every anchor pair, every n: the attachment of all the levels is the
section's own possession. Burn-order fence LIFTED: D3/D2 may land. -/
theorem ASection.liSum_summable (A : ASection) (a β : ℝ) (n : ℕ) :
    Summable fun k => 2 * (liKernel n a β (A.sphereZero k)).re := by
  refine A.liSum_summable_of_density_at (c₀ := 0) ?_ a β n
  exact A.c3_atN.congr fun k => by rw [Complex.ofReal_zero, sub_zero]

/-- **D3 — the first side, PROVED** (ladder L1; from
`zero_free_on_halfSpace` (C2) — every level is bounded above by the
half-space edge via `re_le_upperEdge`, so with β := Ω₀ + 1 every zero is
strictly on the near side of every mirror line with anchor a < β:
`liRatio_norm_lt_one` makes each ratio power sub-unimodular and every
term of the sum nonnegative). Makes "the remaining gap = the second
side" a literal Lean fact. Junk-tsum rider (burn-order fence, header):
the sums here are GENUINE — `liSum_summable` is closed above, so the
positivity is about convergent sums, never the divergent-tsum branch;
the termwise proof below is branch-free either way. -/
theorem ASection.liSum_first_side (A : ASection) :
    ∃ β : ℝ, ∀ a : ℝ, a < β → ∀ n : ℕ, 1 ≤ n → 0 ≤ A.liSum a β n := by
  refine ⟨A.Ω₀ + 1, fun a ha n _ => ?_⟩
  show (0 : ℝ) ≤ ∑' k, 2 * (liKernel n a (A.Ω₀ + 1) (A.sphereZero k)).re
  refine tsum_nonneg fun k => ?_
  have hz : (A.sphereZero k).im ≠ 0 := ne_of_gt (A.c3_sphere_nonreal k)
  have hside : (A.Ω₀ + 1 - a) * ((A.sphereZero k).re - (A.Ω₀ + 1)) < 0 := by
    have h1 := A.re_le_upperEdge k
    have h2 : (A.sphereZero k).re - (A.Ω₀ + 1) < 0 := by linarith
    have h3 : 0 < A.Ω₀ + 1 - a := by linarith
    exact mul_neg_of_pos_of_neg h3 h2
  have hr : ‖liRatio a (A.Ω₀ + 1) (A.sphereZero k)‖ < 1 :=
    liRatio_norm_lt_one hz hside
  have h2 : (liRatio a (A.Ω₀ + 1) (A.sphereZero k) ^ n).re ≤ 1 := by
    calc (liRatio a (A.Ω₀ + 1) (A.sphereZero k) ^ n).re
        ≤ |(liRatio a (A.Ω₀ + 1) (A.sphereZero k) ^ n).re| := le_abs_self _
      _ ≤ ‖liRatio a (A.Ω₀ + 1) (A.sphereZero k) ^ n‖ :=
          Complex.abs_re_le_norm _
      _ = ‖liRatio a (A.Ω₀ + 1) (A.sphereZero k)‖ ^ n := norm_pow _ _
      _ ≤ 1 := pow_le_one₀ (norm_nonneg _) hr.le
  have h3 : 0 ≤ (liKernel n a (A.Ω₀ + 1) (A.sphereZero k)).re := by
    rw [liKernel_eq_ratio, Complex.sub_re, Complex.one_re]
    linarith
  linarith
