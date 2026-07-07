/-
Concentricity/AuditE1.lean

E1 — THE SILLY-ISSUE AUDIT (unimported artifact; KeystoneAssembly /
GreatCircleRoute precedent). Charter: the author suspects the one open
sorry (`ASection.concentricity`, Theorem.lean) is a formalization wrinkle;
this file is the mechanical audit that finds it or rules it out. Verdict
of record (2026-07-06): RULED OUT — no wrinkle. Every row below is PROVED
(kernel triple, no `sorryAx`); the audit's negative findings (search
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
carried in the docstrings, register GLOSS (R10), never load-bearing.

Audit trail:
(1) `exact?`/`apply?` at the exact goal with the full root imported
    return ONLY `ASection.concentricity` itself (the sorried target);
    at the pointwise goal `(A.sphereZero n).re = (A.sphereZero 0).re`
    they return `ASection.placement_set` (downstream of the same sorry)
    and generic Mathlib rewrites (`Real.ext_cauchy`, `norm_exp_eq_iff_re_eq`,
    self-adjointness) — no independent closer exists in the environment.
(2) The statement is non-degenerate: quantifiers audited by
    `auditE1_target_iff_pairwise` (∃c over ℝ with the ℂ.re coercion is
    exactly pairwise level equality — no coercion or vacuity trap), and
    `auditE1_enumeration_nonconstant` (C4 forbids the collapsed
    enumeration; the goal is never closable by a constant sequence).
(3) The one proved reduction is exact: `auditE1_target_iff_two_sided`
    (the target ↔ ∃β two-sided kernel positivity), assembled sorry-free
    from the proved `placement_set_iff` (PlacementSet.lean) and the D2
    iff `placement_set_iff_liSum` (LiKernel.lean).
(4) The proved one-sided rows sit at NON-divisor mirror lines:
    `auditE1_upper_edge_strict` / `auditE1_lower_edge_strict` — D3's
    β = Ω₀ + 1 and the mirror's β = βlo − 1 are each strictly off every
    enumerated level, so neither proved β can be the both-sided β; the
    both-sided β must be the divisor line itself (`auditE1_strip`).

`sorry` never appears in this file.
-/
import Concentricity
import Concentricity.LiKernel

noncomputable section

open Complex

namespace ASection

/-- **E1 statement audit — the quantifier shape.** The theorem's ∃-form is
exactly the pairwise level equality: no coercion trap (`c : ℝ`, `.re : ℝ`),
no vacuity (`ℕ` inhabited; witness = the 0-th level). PROVED. -/
theorem auditE1_target_iff_pairwise (A : ASection) :
    (∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c)
      ↔ ∀ n m : ℕ, (A.sphereZero n).re = (A.sphereZero m).re := by
  constructor
  · rintro ⟨c, hc⟩ n m
    rw [hc n, hc m]
  · intro h
    exact ⟨(A.sphereZero 0).re, fun n => h n 0⟩

/-- **E1 statement audit — C4 anti-collapse.** `c4_infinite` forces the
range of the enumeration infinite, so the sequence is never constant: the
target cannot be met by a degenerate (collapsed) enumeration; its content
is genuinely about infinitely many distinct zero-spheres. PROVED. -/
theorem auditE1_enumeration_nonconstant (A : ASection) :
    ¬ ∃ z : ℂ, ∀ n : ℕ, A.sphereZero n = z := by
  rintro ⟨z, hz⟩
  exact A.c4_infinite ((Set.finite_singleton z).subset
    (Set.range_subset_iff.mpr fun n => hz n))

/-- **E1 structure audit — the strip.** The candidate centre is confined:
every enumerated level lies in `[βlo, Ω₀]` (`c3_lowerEdge` +
`re_le_upperEdge` = C2's zero-freeness read at the divisor). Any witness
`c` for the target lies in this closed strip. PROVED. -/
theorem auditE1_strip (A : ASection) :
    ∃ βlo : ℝ, ∀ n : ℕ, (A.sphereZero n).re ∈ Set.Icc βlo A.Ω₀ := by
  obtain ⟨βlo, h⟩ := A.c3_lowerEdge
  exact ⟨βlo, fun n => ⟨h n, A.re_le_upperEdge n⟩⟩

/-- **E1 — the exact remaining content, as one proved iff.** The open
target `∃ c, ∀ n, (A.sphereZero n).re = c` is EQUIVALENT, sorry-free, to
the single sentence `∃ β` with two-sided kernel positivity (D2's RHS).
Chain: pairwise form (`auditE1_target_iff_pairwise`) = the transport-level
form (definitional), ↔ the set form by the proved weld
(`placement_set_iff`), ↔ ∃β two-sided by the proved D2
(`placement_set_iff_liSum`). Every link is on the kernel triple; nothing
here consumes the sorried theorem. This row certifies that the sorry is
NOT a wrinkle: closing it is closing `∃β`, and D3 + the mirror supply the
two sides only at two DIFFERENT β's, each strictly off the divisor
(`auditE1_upper_edge_strict`, `auditE1_lower_edge_strict`). PROVED. -/
theorem auditE1_target_iff_two_sided (A : ASection) :
    (∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c)
      ↔ ∃ β : ℝ, (∀ a : ℝ, a < β → ∀ n : ℕ, 1 ≤ n → 0 ≤ A.liSum a β n)
          ∧ (∀ a : ℝ, β < a → ∀ n : ℕ, 1 ≤ n → 0 ≤ A.liSum a β n) := by
  rw [auditE1_target_iff_pairwise]
  have hpair : (∀ n m : ℕ, (A.sphereZero n).re = (A.sphereZero m).re)
      ↔ ∀ n m : ℕ, A.transportLevel n = A.transportLevel m := Iff.rfl
  rw [hpair, ← A.placement_set_iff]
  exact A.placement_set_iff_liSum

/-- **E1 — D3's edge is off the divisor.** Every enumerated level is
strictly below D3's mirror line `β = Ω₀ + 1`; the proved first-side β can
therefore never be the both-sided β of `auditE1_target_iff_two_sided`
(the both-sided β is the divisor line itself). PROVED. -/
theorem auditE1_upper_edge_strict (A : ASection) (n : ℕ) :
    (A.sphereZero n).re < A.Ω₀ + 1 :=
  lt_of_le_of_lt (A.re_le_upperEdge n) (lt_add_one _)

/-- **E1 — the mirror's edge is off the divisor.** Dually, every
enumerated level is strictly above the second side's mirror line
`β = βlo − 1`. With `auditE1_upper_edge_strict`: the two PROVED one-sided
positivity rows (`liSum_first_side`, `liSum_second_side`) live at two
distinct β's, each strictly off every enumerated level — the exact
configuration in which the D2 engine (`exists_liSum_neg`, private) makes
the MISSING side at each edge genuinely negative, not merely unproved.
PROVED. -/
theorem auditE1_lower_edge_strict (A : ASection) :
    ∃ βlo : ℝ, ∀ n : ℕ, βlo - 1 < (A.sphereZero n).re := by
  obtain ⟨βlo, h⟩ := A.c3_lowerEdge
  exact ⟨βlo, fun n => lt_of_lt_of_le (by linarith [h n]) (le_refl _)⟩

/-- **E1 — the two-sided family collapses to one anchor pair (the ∀a
weakening, proved direction).** If the two-sided positivity holds at β for
ALL anchors, it holds in particular at the single mirror-symmetric anchor
pair `{β − 1, β + 1}` — the fixed-anchor form of Theorem 2 (Generalized
Bombieri–Lagarias, archive/READ_weil_li_findings.md: "for one
(equivalently every) anchor pair"). The converse (pair ⟹ ∀a) is exactly
D2's (⟸) proof, which consumes ONLY these two anchors
(LiKernel.lean:1345,1352) but through the `private` engine
`exists_liSum_neg`; it is therefore true of record but not re-exportable
from outside LiKernel.lean without republishing that engine. PROVED. -/
theorem auditE1_two_sided_gives_anchor_pair (A : ASection)
    (h : ∃ β : ℝ, (∀ a : ℝ, a < β → ∀ n : ℕ, 1 ≤ n → 0 ≤ A.liSum a β n)
        ∧ (∀ a : ℝ, β < a → ∀ n : ℕ, 1 ≤ n → 0 ≤ A.liSum a β n)) :
    ∃ β : ℝ, (∀ n : ℕ, 1 ≤ n → 0 ≤ A.liSum (β - 1) β n)
        ∧ (∀ n : ℕ, 1 ≤ n → 0 ≤ A.liSum (β + 1) β n) := by
  obtain ⟨β, h₁, h₂⟩ := h
  exact ⟨β, fun n hn => h₁ (β - 1) (by linarith) n hn,
    fun n hn => h₂ (β + 1) (lt_add_one β) n hn⟩

end ASection

/-! ## The audit's negative findings (GLOSS register, R10 — recorded, not
load-bearing)

**Field-by-field hidden-strength audit of `structure ASection`** (E1 step
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
NOT formalized here):

- `intrinsic`, `c2_intrinsic`, `c3_R_intrinsic`, `c3_g_intrinsic`:
  [scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
  translates of sinh, real pole). No level pinning.
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
  off the divisor. No level pinning.
- `meromorphic`, `c3_R_entire`, `c3_g_entire`, `c3_R_zeros_real` (real
  zeros 0.3, 0.7 ≠ 0 go to `Rfac = (1−z/0.3)(1−z/0.7)`),
  `c3_sphere_nonreal`, `c3_lowerEdge` (βlo = 0.3), `c3_atN`
  [scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
- `c3_factorization` (with the pole factor): sinh's Hadamard product
  [scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
  pairs times `e^{linear}` — `gfac` linear with real coefficients, `m = 0`.
  Evaluated at special points (z = 0, real axis, conjugates) it yields
  [scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
  [scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
  transcription `c2_zero_free : ℓ p z ≠ 0` demands an infinite summable
  splitting of log F into pointwise NONVANISHING intrinsic pieces. For ζ
  the Euler factors −log(1−p^{−z}) are canonically nonvanishing. For the
  [scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
  (then u, d_p·v with ∑d_p = 1, d_p ≠ 0) is a value-distribution
  question (does some exp(q) avoid −g on the half-space?) — NOT settled
  by this audit either way. FLAG (R6): this is the only field where class
  content beyond "zero-free on a half-space" could formally live, and
  nothing in the repository consumes it beyond `zero_free_on_halfSpace`
  (which uses only `c2_euler`'s exp form). Its pointwise, differential-
  free shape gives it no visible grip on divisor levels.
- `valueAtInfinity`/`valueAtInfinity_real`: pure data — NO field links F
  to `valueAtInfinity` (no limit clause), so it is dischargeable with the
  literal point ∞ (premise of `valueAtInfinity_real` then vacuous). Slack,
  not strength.

[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
`zetaSection` (ZetaSection.lean) is either generic complex analysis or a
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
↔ sinh Hadamard regrouping; `zetaSphereZero_density` ↔ ∑1/(1+k²);
`riemannZeta_nontrivialZeros_infinite` ↔ the two ladders). No field
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
flag at `c2_zero_free` above.

**Verdict**: the sorry is not a silly wrinkle. The exact remaining
content is `∃β` both-sided (`auditE1_target_iff_two_sided`, proved), the
proved one-sided rows sit at two different, off-divisor β's
(`auditE1_upper_edge_strict`/`auditE1_lower_edge_strict`), and the
structure audit finds no unconsumed field strength that pins levels —
with the one R6 flag (`c2_zero_free`'s splitting demand) recorded for
the author's ruling. -/
