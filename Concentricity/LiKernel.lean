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

/-- **C-1 — the named obligation** (DESIGN D0: well-definedness =
summability, from the divisor's convergence; "expected derivable from the
§4α majorants / genus data; if not derivable class-wide, R6 stop —
author's word"). Lands sorried by ruling. REGISTER (author, 2026-07-04):
convergence is a possession of the class — C3's divisor control with C1
closing the divisor through the pole is exactly the density that makes the
paired kernel sums converge; this sorry is "a debt of transcription, not
of belief" (R8: UNFORMALIZED, never UNSOUND). No convergence hypothesis is
being added; C-1 is not a C5-in-disguise; the statements are deliberately
bare. Burn-order fence: D3/D2 hold until this closes. -/
theorem liSum_summable (A : ASection) (a β : ℝ) (n : ℕ) :
    Summable fun k => 2 * (liKernel n a β (A.sphereZero k)).re := by
  sorry

end ASection

/-- **D1 — finite-multiset Bombieri–Lagarias** (ladder L2; DESIGN:
"unconditional, pure algebra + Dirichlet approximation … the reduction's
engine, fully formalizable now"): for a finite multiset avoiding the
anchors, two-sided positivity for all n ⟺ all elements have `Re = β`.

FIDELITY NOTE (author's rider 1, 2026-07-04): the `im ≠ 0` hypothesis
STRENGTHENS the BL source's literal two-point avoidance; it is chosen as
the consumer-exact rendering — it keeps every kernel anchor-free for every
quantified `a` (any real element is some `a`'s mirror), and the D2 consumer
feeds only conjugate-closed zero multisets, all non-real. -/
theorem finite_BL (S : Multiset ℂ) (β : ℝ) (hS : ∀ z ∈ S, z.im ≠ 0) :
    ((∀ a : ℝ, a < β → ∀ n : ℕ, 1 ≤ n →
        0 ≤ (S.map fun z => 2 * (liKernel n a β z).re).sum)
      ∧ (∀ a : ℝ, β < a → ∀ n : ℕ, 1 ≤ n →
        0 ≤ (S.map fun z => 2 * (liKernel n a β z).re).sum))
      ↔ ∀ z ∈ S, z.re = β := by
  sorry

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

/-- **D3 — the first side, derived** (ladder L1; DESIGN: from
`zero_free_on_halfSpace` (C2) — every level is bounded above by the
half-space edge, and the one-sided Theorem 2 direction converts the bound
into the positivity family). Makes "the remaining gap = the second side" a
literal Lean fact. -/
theorem ASection.liSum_first_side (A : ASection) :
    ∃ β : ℝ, ∀ a : ℝ, a < β → ∀ n : ℕ, 1 ≤ n → 0 ≤ A.liSum a β n := by
  sorry
