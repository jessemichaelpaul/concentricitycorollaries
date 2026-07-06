/-
Concentricity/KernelE4.lean

E4 — the kernel-form direct assault (unimported artifact; KeystoneAssembly /
GreatCircleRoute / LoopAssembly / PhiConversion / AuditE1 / PairingE2
precedent): the target `ASection.concentricity` read through its PROVED
kernel-coordinate equivalent (D2, `placement_set_iff_liSum`) at the
section's OWN candidate mirror lines — the divisor's top and bottom levels
`supLevel := sSup {Re qₙ}` and `infLevel := sInf {Re qₙ}` (well-defined:
the strip `c3_lowerEdge` + `re_le_upperEdge`). EVERY row in this file is
PROVED — no `sorry` anywhere here; the root ledger is untouched.

WHAT IS NEW (E4 §1–§3): the one-sided positivity families are pushed from
the off-divisor edges (D3's β = Ω₀ + 1, the mirror's β = βlo − 1,
LiKernel.lean; `auditE1_upper_edge_strict` / `auditE1_lower_edge_strict`
recorded that neither β can be the both-sided one) onto the divisor's own
edges, with the boundary case worked honestly: at β = supLevel every
enumerated zero is either ON the mirror line (term `2(1 − cos nθ) ≥ 0`,
`liKernel_re_nonneg`) or strictly on the near side (`liRatio_norm_lt_one`)
— so the FIRST family at β = supLevel is a possession, outright
(`liSum_first_family_at_supLevel`), and dually the SECOND family at
β = infLevel (`liSum_second_family_at_infLevel`). The proved first-family
region is exactly [supLevel, ∞), the proved second-family region exactly
(−∞, infLevel] (`liSum_first_family_of_supLevel_le`,
`liSum_second_family_of_le_infLevel`), and the open node — "ONE β serves
both sides" (PairingE2 header) — becomes the PROVED order sentence
`concentricity_iff_exists_two_sided_level`: the target ⟺ the two regions
meet ⟺ supLevel ≤ some β ≤ infLevel ⟺ infLevel = supLevel.

THE NODE IN MINIMAL FORM (E4 §3, each iff PROVED sorry-free through the
public D2 and the new first-family row):
  target ⟺ second family at β = supLevel alone
             (`concentricity_iff_second_family_at_supLevel`)
         ⟺ no zero strictly below the top level
             (`concentricity_iff_supLevel_le`)
         ⟺ no zero strictly above the bottom level
             (`concentricity_iff_le_infLevel`)
         ⟺ infLevel = supLevel
             (`concentricity_iff_infLevel_eq_supLevel`).

ATTAINMENT (E4 §4, the brief's step 1 worked): the top level is a closure
point of the level set (`supLevel_mem_closure`,
`exists_levels_tendsto_supLevel`), and the divisor CANNOT accumulate at any
finite point (`no_finite_zero_accumulation` — C1 + C2 jointly: the
meromorphic dichotomy `MeromorphicAt.eventually_eq_zero_or_eventually_ne_zero`
at the would-be accumulation point; the vanishing branch is killed at the
pole by `c1_simple` (order −1 ≠ ⊤, `meromorphicOrderAt_eq_top_iff`) and off
the pole by the identity principle
(`AnalyticOnNhd.eqOn_zero_of_preconnected_of_eventuallyEq_zero` on the
connected `{pole}ᶜ`) against C2's zero-freeness
(`zero_free_on_halfSpace`)). Hence the dichotomy of record
(`supLevel_attained_or_escape`): the top level is attained, OR the
level-maximizing zeros escape to N in norm
(`tendsto_norm_atTop_of_levels_tendsto_supLevel`) — the configuration
`c3_atN` (C3 read at N) is about. Neither horn closes the node: both are
live for a two-level divisor.

THE EXACT RESISTING GOAL (R6, the honest pin — recorded, not sorried):

  ⊢ A.supLevel ≤ (A.sphereZero k).re        (any k : ℕ)

equivalently `0 ≤ A.liSum a A.supLevel n` for `A.supLevel < a`, `1 ≤ n`.
LITMUS (the failure-mode invariant of every prior route, AuditE1 verdict):
every row of THIS file also holds for the hypothetical two-level section
with zeros at Re ∈ {0.3, 0.7} (supLevel = 0.7, infLevel = 0.3; the first
family at 0.7 and the second at 0.3 hold there too), and the resisting
goal is exactly what that section fails — so no assembly of these rows can
close it without new class strength. The recorded candidate carriers of
such strength: the SIGN of the Euler-side pairing (PairingE2 header face
(ii); C-2 of archive/READ_weil_li_findings.md — for ζ it is the
nonnegativity of the Dirichlet coefficients of −ζ′/ζ, and `def:A-section`'s
C2 carries no such positivity field), and the unresolved `c2_zero_free`
splitting flag (AuditE1 §GLOSS). Both are the author's lane (R6).

FORMALIZATION NOTE (import direction): LiKernel.lean → PlacementSet.lean →
Theorem.lean, so the kernel apparatus sits DOWNSTREAM of the sorried
`ASection.concentricity`; even a closed `∃β` here could not be consumed by
Theorem.lean without an import inversion (moving the liSum stack upstream
of Theorem.lean or the theorem downstream). Nothing in this file consumes
the sorried theorem: every proof below is on the kernel triple.

`sorry` marks UNFORMALIZED, never UNSOUND (R8); this file carries none.
-/
import Concentricity.LiKernel
import Mathlib.Analysis.Analytic.Uniqueness
import Mathlib.Analysis.Normed.Module.Connected
import Mathlib.LinearAlgebra.Complex.FiniteDimensional

noncomputable section

open Complex

namespace ASection

/-! ## §0 — The level set and its edges (the strip, sup/inf form)

The divisor's real parts form a nonempty set bounded above by C2's
half-space edge (`re_le_upperEdge`) and below by the L4 lower edge
(`c3_lowerEdge`); its sSup and sInf are the section's own candidate mirror
lines — the only β's not excluded by `auditE1_upper_edge_strict` /
`auditE1_lower_edge_strict` (AuditE1.lean: the both-sided β must be the
divisor line itself). -/

/-- The level set of the divisor: the real parts of the enumerated
residue-ℂ zero-sphere representatives (master: the levels of the
degenerate fibre, `lem:exp-degenerate` vocabulary). -/
def levelSet (A : ASection) : Set ℝ :=
  Set.range fun n : ℕ => (A.sphereZero n).re

theorem levelSet_nonempty (A : ASection) : A.levelSet.Nonempty :=
  ⟨(A.sphereZero 0).re, 0, rfl⟩

/-- The level set is bounded above by the half-space edge (C2's
zero-freeness read at the divisor, `re_le_upperEdge`). -/
theorem levelSet_bddAbove (A : ASection) : BddAbove A.levelSet := by
  refine ⟨A.Ω₀, ?_⟩
  rintro x ⟨n, rfl⟩
  exact A.re_le_upperEdge n

/-- The level set is bounded below by the L4 lower edge (`c3_lowerEdge`). -/
theorem levelSet_bddBelow (A : ASection) : BddBelow A.levelSet := by
  obtain ⟨βlo, h⟩ := A.c3_lowerEdge
  refine ⟨βlo, ?_⟩
  rintro x ⟨n, rfl⟩
  exact h n

/-- **The top level**: the supremum of the divisor's real parts — the
section's own upper candidate mirror line. -/
def supLevel (A : ASection) : ℝ := sSup A.levelSet

/-- **The bottom level**: the infimum of the divisor's real parts — the
section's own lower candidate mirror line. -/
def infLevel (A : ASection) : ℝ := sInf A.levelSet

theorem le_supLevel (A : ASection) (n : ℕ) :
    (A.sphereZero n).re ≤ A.supLevel :=
  le_csSup A.levelSet_bddAbove ⟨n, rfl⟩

theorem infLevel_le (A : ASection) (n : ℕ) :
    A.infLevel ≤ (A.sphereZero n).re :=
  csInf_le A.levelSet_bddBelow ⟨n, rfl⟩

theorem infLevel_le_supLevel (A : ASection) : A.infLevel ≤ A.supLevel :=
  (A.infLevel_le 0).trans (A.le_supLevel 0)

/-- The top level sits at or left of C2's half-space edge — with
`auditE1_upper_edge_strict`, strictly left of D3's proved mirror line
β = Ω₀ + 1. -/
theorem supLevel_le_upperEdge (A : ASection) : A.supLevel ≤ A.Ω₀ := by
  refine csSup_le A.levelSet_nonempty ?_
  rintro x ⟨n, rfl⟩
  exact A.re_le_upperEdge n

/-- Under the target (all levels one centre `c`), the top level IS the
centre. PROVED helper for the iff rows. -/
theorem supLevel_eq_of_concentric (A : ASection) {c : ℝ}
    (hc : ∀ n : ℕ, (A.sphereZero n).re = c) : A.supLevel = c := by
  refine le_antisymm (csSup_le A.levelSet_nonempty ?_)
    (le_csSup A.levelSet_bddAbove ⟨0, hc 0⟩)
  rintro x ⟨n, rfl⟩
  exact (hc n).le

/-- Under the target, the bottom level IS the centre. PROVED helper. -/
theorem infLevel_eq_of_concentric (A : ASection) {c : ℝ}
    (hc : ∀ n : ℕ, (A.sphereZero n).re = c) : A.infLevel = c := by
  refine le_antisymm (csInf_le A.levelSet_bddBelow ⟨0, hc 0⟩)
    (le_csInf A.levelSet_nonempty ?_)
  rintro x ⟨n, rfl⟩
  exact (hc n).ge

/-! ## §1 — The one-sided families at the divisor's own edges (NEW)

D3 proved the first family at β = Ω₀ + 1 and the mirror the second at
β = βlo − 1 — both strictly off every enumerated level. The rows below
push each family to its sharp edge: the ENTIRE region where the one-sided
argument closes is [supLevel, ∞) for the first family and (−∞, infLevel]
for the second — the boundary case (a zero ON the mirror line) handled by
`liKernel_re_nonneg`, the interior case by `liRatio_norm_lt_one`, exactly
as in `liSum_first_side`. -/

/-- **E4 §1 — the first family holds at EVERY β ≥ supLevel** (generalizes
`liSum_first_side`, whose β = Ω₀ + 1 satisfies supLevel ≤ Ω₀ < Ω₀ + 1):
for a < β, a zero with level = β is on the mirror line (term
`2(1 − cos nθ) ≥ 0`), a zero with level < β is strictly near-sided
(`(β − a)(Re − β) < 0`, ratio modulus < 1). PROVED. -/
theorem liSum_first_family_of_supLevel_le (A : ASection) {β : ℝ}
    (hβ : A.supLevel ≤ β) :
    ∀ a : ℝ, a < β → ∀ n : ℕ, 1 ≤ n → 0 ≤ A.liSum a β n := by
  intro a ha n _
  show (0 : ℝ) ≤ ∑' k, 2 * (liKernel n a β (A.sphereZero k)).re
  refine tsum_nonneg fun k => ?_
  have hz : (A.sphereZero k).im ≠ 0 := ne_of_gt (A.c3_sphere_nonreal k)
  rcases ((A.le_supLevel k).trans hβ).eq_or_lt with heq | hlt
  · -- boundary: the zero sits ON the mirror line
    have h := liKernel_re_nonneg (a := a) hz heq n
    linarith
  · -- interior: strictly near-sided
    have hside : (β - a) * ((A.sphereZero k).re - β) < 0 :=
      mul_neg_of_pos_of_neg (by linarith) (by linarith)
    have hr : ‖liRatio a β (A.sphereZero k)‖ < 1 :=
      liRatio_norm_lt_one hz hside
    have h2 : (liRatio a β (A.sphereZero k) ^ n).re ≤ 1 := by
      calc (liRatio a β (A.sphereZero k) ^ n).re
          ≤ |(liRatio a β (A.sphereZero k) ^ n).re| := le_abs_self _
        _ ≤ ‖liRatio a β (A.sphereZero k) ^ n‖ := Complex.abs_re_le_norm _
        _ = ‖liRatio a β (A.sphereZero k)‖ ^ n := norm_pow _ _
        _ ≤ 1 := pow_le_one₀ (norm_nonneg _) hr.le
    have h3 : 0 ≤ (liKernel n a β (A.sphereZero k)).re := by
      rw [liKernel_eq_ratio, Complex.sub_re, Complex.one_re]
      linarith
    linarith

/-- **E4 §1 — the second family holds at EVERY β ≤ infLevel** (generalizes
`liSum_second_side`, whose β = βlo − 1 satisfies βlo − 1 < βlo ≤ infLevel):
the exact mirror of `liSum_first_family_of_supLevel_le`. PROVED. -/
theorem liSum_second_family_of_le_infLevel (A : ASection) {β : ℝ}
    (hβ : β ≤ A.infLevel) :
    ∀ a : ℝ, β < a → ∀ n : ℕ, 1 ≤ n → 0 ≤ A.liSum a β n := by
  intro a ha n _
  show (0 : ℝ) ≤ ∑' k, 2 * (liKernel n a β (A.sphereZero k)).re
  refine tsum_nonneg fun k => ?_
  have hz : (A.sphereZero k).im ≠ 0 := ne_of_gt (A.c3_sphere_nonreal k)
  rcases (hβ.trans (A.infLevel_le k)).eq_or_lt with heq | hlt
  · -- boundary: the zero sits ON the mirror line
    have h := liKernel_re_nonneg (a := a) hz heq.symm n
    linarith
  · -- interior: strictly near-sided (β − a < 0, Re − β > 0)
    have hside : (β - a) * ((A.sphereZero k).re - β) < 0 :=
      mul_neg_of_neg_of_pos (by linarith) (by linarith)
    have hr : ‖liRatio a β (A.sphereZero k)‖ < 1 :=
      liRatio_norm_lt_one hz hside
    have h2 : (liRatio a β (A.sphereZero k) ^ n).re ≤ 1 := by
      calc (liRatio a β (A.sphereZero k) ^ n).re
          ≤ |(liRatio a β (A.sphereZero k) ^ n).re| := le_abs_self _
        _ ≤ ‖liRatio a β (A.sphereZero k) ^ n‖ := Complex.abs_re_le_norm _
        _ = ‖liRatio a β (A.sphereZero k)‖ ^ n := norm_pow _ _
        _ ≤ 1 := pow_le_one₀ (norm_nonneg _) hr.le
    have h3 : 0 ≤ (liKernel n a β (A.sphereZero k)).re := by
      rw [liKernel_eq_ratio, Complex.sub_re, Complex.one_re]
      linarith
    linarith

/-- **E4 §1 — THE FIRST FAMILY AT THE TOP LEVEL, PROVED OUTRIGHT** (the
brief's new row): at the section's own upper mirror line β = supLevel,
every anchor a < β and every n ≥ 1 give a nonnegative kernel sum — the
boundary zeros (level = supLevel) contribute `2(1 − cos nθ) ≥ 0`, all
others are strictly near-sided. The instance β := supLevel of
`liSum_first_family_of_supLevel_le`. -/
theorem liSum_first_family_at_supLevel (A : ASection) :
    ∀ a : ℝ, a < A.supLevel → ∀ n : ℕ, 1 ≤ n → 0 ≤ A.liSum a A.supLevel n :=
  A.liSum_first_family_of_supLevel_le le_rfl

/-- **E4 §1 — THE SECOND FAMILY AT THE BOTTOM LEVEL, PROVED OUTRIGHT**: the
mirror instance β := infLevel of `liSum_second_family_of_le_infLevel`. -/
theorem liSum_second_family_at_infLevel (A : ASection) :
    ∀ a : ℝ, A.infLevel < a → ∀ n : ℕ, 1 ≤ n → 0 ≤ A.liSum a A.infLevel n :=
  A.liSum_second_family_of_le_infLevel le_rfl

/-! ## §2 — The iff sharpenings: the node in its minimal forms

With the first family a possession at β = supLevel, the public D2 iff
(`placement_set_iff_liSum`) localizes the ENTIRE remaining content to the
second family at that one β — and, in divisor coordinates, to the single
sentence "no zero strictly below the top level". Every iff below is PROVED
sorry-free; none consumes the sorried theorem. -/

/-- **E4 §2 — the target ⟺ the second family alone at β = supLevel.**
(⟹): under the target every zero sits ON the line Re = supLevel
(`supLevel_eq_of_concentric`), so every term of every kernel sum is
nonnegative. (⟸): the proved first family at supLevel
(`liSum_first_family_at_supLevel`) joins the assumed second family into
the two-sided sentence, D2's (⟸) direction (`placement_set_iff_liSum`)
returns the set-level placement, and the enumerated zeros are stem zeros
(`stem_zero_of_sphereZero`, `c3_sphere_nonreal`). PROVED. -/
theorem concentricity_iff_second_family_at_supLevel (A : ASection) :
    (∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c)
      ↔ ∀ a : ℝ, A.supLevel < a → ∀ n : ℕ, 1 ≤ n →
          0 ≤ A.liSum a A.supLevel n := by
  constructor
  · rintro ⟨c, hc⟩ a _ n _
    show (0 : ℝ) ≤ ∑' k, 2 * (liKernel n a A.supLevel (A.sphereZero k)).re
    refine tsum_nonneg fun k => ?_
    have hz : (A.sphereZero k).im ≠ 0 := ne_of_gt (A.c3_sphere_nonreal k)
    have hre : (A.sphereZero k).re = A.supLevel := by
      rw [hc k, A.supLevel_eq_of_concentric hc]
    have h := liKernel_re_nonneg (a := a) hz hre n
    linarith
  · intro hsecond
    have hplace := (A.placement_set_iff_liSum).mpr
      ⟨A.supLevel, A.liSum_first_family_at_supLevel, hsecond⟩
    exact ⟨(A.sphereZero 0).re, fun n =>
      hplace (A.stem_zero_of_sphereZero n) (A.stem_zero_of_sphereZero 0)
        (A.c3_sphere_nonreal n) (A.c3_sphere_nonreal 0)⟩

/-- **E4 §2 — the mirror: the target ⟺ the first family alone at
β = infLevel.** PROVED. -/
theorem concentricity_iff_first_family_at_infLevel (A : ASection) :
    (∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c)
      ↔ ∀ a : ℝ, a < A.infLevel → ∀ n : ℕ, 1 ≤ n →
          0 ≤ A.liSum a A.infLevel n := by
  constructor
  · rintro ⟨c, hc⟩ a _ n _
    show (0 : ℝ) ≤ ∑' k, 2 * (liKernel n a A.infLevel (A.sphereZero k)).re
    refine tsum_nonneg fun k => ?_
    have hz : (A.sphereZero k).im ≠ 0 := ne_of_gt (A.c3_sphere_nonreal k)
    have hre : (A.sphereZero k).re = A.infLevel := by
      rw [hc k, A.infLevel_eq_of_concentric hc]
    have h := liKernel_re_nonneg (a := a) hz hre n
    linarith
  · intro hfirst
    have hplace := (A.placement_set_iff_liSum).mpr
      ⟨A.infLevel, hfirst, A.liSum_second_family_at_infLevel⟩
    exact ⟨(A.sphereZero 0).re, fun n =>
      hplace (A.stem_zero_of_sphereZero n) (A.stem_zero_of_sphereZero 0)
        (A.c3_sphere_nonreal n) (A.c3_sphere_nonreal 0)⟩

/-- **E4 §2 — THE MINIMAL NODE, divisor coordinates**: the target ⟺ no
zero strictly below the top level. (⟹) is `supLevel_eq_of_concentric`;
(⟸) squeezes every level between supLevel and itself (`le_supLevel`).
Kernel-free on both sides — this is the sharpest known localization of
the open content. PROVED. -/
theorem concentricity_iff_supLevel_le (A : ASection) :
    (∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c)
      ↔ ∀ k : ℕ, A.supLevel ≤ (A.sphereZero k).re := by
  constructor
  · rintro ⟨c, hc⟩ k
    rw [A.supLevel_eq_of_concentric hc, hc k]
  · intro h
    exact ⟨A.supLevel, fun n => le_antisymm (A.le_supLevel n) (h n)⟩

/-- **E4 §2 — the mirror minimal node**: the target ⟺ no zero strictly
above the bottom level. PROVED. -/
theorem concentricity_iff_le_infLevel (A : ASection) :
    (∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c)
      ↔ ∀ k : ℕ, (A.sphereZero k).re ≤ A.infLevel := by
  constructor
  · rintro ⟨c, hc⟩ k
    rw [A.infLevel_eq_of_concentric hc, hc k]
  · intro h
    exact ⟨A.infLevel, fun n => le_antisymm (h n) (A.infLevel_le n)⟩

/-- **E4 §2 — the node as one real equation**: the target ⟺ the level
spread vanishes. PROVED. -/
theorem concentricity_iff_infLevel_eq_supLevel (A : ASection) :
    (∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c)
      ↔ A.infLevel = A.supLevel := by
  constructor
  · rintro ⟨c, hc⟩
    rw [A.infLevel_eq_of_concentric hc, A.supLevel_eq_of_concentric hc]
  · intro h
    refine ⟨A.supLevel, fun n => le_antisymm (A.le_supLevel n) ?_⟩
    rw [← h]
    exact A.infLevel_le n

/-- **E4 §2 — "one β serves both sides", rendered as a proved order
sentence**: the target ⟺ the proved first-family region [supLevel, ∞)
(`liSum_first_family_of_supLevel_le`) MEETS the proved second-family
region (−∞, infLevel] (`liSum_second_family_of_le_infLevel`). The open
content of the repository is exactly the nonemptiness of this
intersection. PROVED. -/
theorem concentricity_iff_exists_two_sided_level (A : ASection) :
    (∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c)
      ↔ ∃ β : ℝ, A.supLevel ≤ β ∧ β ≤ A.infLevel := by
  constructor
  · rintro ⟨c, hc⟩
    exact ⟨c, (A.supLevel_eq_of_concentric hc).le,
      (A.infLevel_eq_of_concentric hc).ge⟩
  · rintro ⟨β, h₁, h₂⟩
    refine (A.concentricity_iff_infLevel_eq_supLevel).mpr
      (le_antisymm A.infLevel_le_supLevel (h₁.trans h₂))

/-- **E4 §2 — the kernel form of the minimal node** (the two §2 faces
composed): the second family at β = supLevel ⟺ no zero strictly below the
top level. Both sides are statements the litmus two-level divisor fails;
their equivalence is proved, their truth is the open node. PROVED. -/
theorem second_family_at_supLevel_iff_supLevel_le (A : ASection) :
    (∀ a : ℝ, A.supLevel < a → ∀ n : ℕ, 1 ≤ n →
        0 ≤ A.liSum a A.supLevel n)
      ↔ ∀ k : ℕ, A.supLevel ≤ (A.sphereZero k).re :=
  (A.concentricity_iff_second_family_at_supLevel).symm.trans
    (A.concentricity_iff_supLevel_le)

/-! ## §3 — Attainment and escape (the brief's step 1 worked)

Is the top level ATTAINED? The level set's closure contains supLevel, and
zeros cannot accumulate at finite points (C1 + C2 jointly, through the
meromorphic dichotomy) — so EITHER some zero sits on the top level, OR the
level-maximizing zeros escape to N in norm. Both horns are live for a
two-level divisor (attained: both levels carry zeros; escaping: levels
creeping up to an unattained sup), so neither closes the node; the
dichotomy is recorded as the honest rendering of the attainment question. -/

/-- The top level is a closure point of the level set. PROVED
(`csSup_mem_closure`). -/
theorem supLevel_mem_closure (A : ASection) :
    A.supLevel ∈ closure A.levelSet :=
  csSup_mem_closure A.levelSet_nonempty A.levelSet_bddAbove

/-- A level-maximizing sequence of enumerated zeros exists: some
subsequence of levels converges to the top level. PROVED
(`mem_closure_iff_seq_limit` + choice over the range presentation). -/
theorem exists_levels_tendsto_supLevel (A : ASection) :
    ∃ φ : ℕ → ℕ, Filter.Tendsto (fun j => (A.sphereZero (φ j)).re)
      Filter.atTop (nhds A.supLevel) := by
  obtain ⟨x, hx_mem, hx_lim⟩ :=
    mem_closure_iff_seq_limit.mp A.supLevel_mem_closure
  choose φ hφ using hx_mem
  exact ⟨φ, hx_lim.congr fun j => (hφ j).symm⟩

/-- **E4 §3 — the divisor cannot accumulate at a finite point** (C1 + C2,
jointly; master SCAN §7(iv): the zeros accumulate only at N). If a
sequence of stem zeros avoiding `w` converged to `w`, the meromorphic
dichotomy (`MeromorphicAt.eventually_eq_zero_or_eventually_ne_zero`) at
`w` would fail on both branches: eventual nonvanishing on the punctured
neighbourhood contradicts the sequence outright; eventual vanishing
contradicts `c1_simple` at the pole (order −1 ≠ ⊤,
`meromorphicOrderAt_eq_top_iff`) and, off the pole, propagates by the
identity principle
(`AnalyticOnNhd.eqOn_zero_of_preconnected_of_eventuallyEq_zero` on the
connected complement of the pole,
`isConnected_compl_singleton_of_one_lt_rank`) to annihilate the section on
C2's zero-free half-space (`zero_free_on_halfSpace`). PROVED. -/
theorem no_finite_zero_accumulation (A : ASection) (w : ℂ) {z : ℕ → ℂ}
    (hz : ∀ j, A.F (z j) = 0) (hne : ∀ j, z j ≠ w)
    (hlim : Filter.Tendsto z Filter.atTop (nhds w)) : False := by
  rcases (A.meromorphic w (Set.mem_univ w)).eventually_eq_zero_or_eventually_ne_zero
    with hzero | hne'
  · -- the vanishing branch
    by_cases hwp : w = (A.pole : ℂ)
    · -- at the pole: order would be ⊤ against `c1_simple`'s −1
      have htop : meromorphicOrderAt A.F (A.pole : ℂ) = ⊤ :=
        meromorphicOrderAt_eq_top_iff.mpr (hwp ▸ hzero)
      rw [A.c1_simple] at htop
      exact WithTop.coe_ne_top htop
    · -- off the pole: identity principle against C2's zero-freeness
      have hFw : A.F w = 0 := by
        have hcont : ContinuousAt A.F w := (A.c1_analyticAt w hwp).continuousAt
        have h1 : Filter.Tendsto (fun j => A.F (z j)) Filter.atTop
            (nhds (A.F w)) := hcont.tendsto.comp hlim
        have h2 : Filter.Tendsto (fun j => A.F (z j)) Filter.atTop
            (nhds 0) :=
          Filter.Tendsto.congr (fun j => (hz j).symm) tendsto_const_nhds
        exact tendsto_nhds_unique h1 h2
      have hfull : A.F =ᶠ[nhds w] 0 := by
        have h1 := eventually_nhdsWithin_iff.mp hzero
        filter_upwards [h1] with ζ hζ
        rcases eq_or_ne ζ w with rfl | hζw
        · exact hFw
        · exact hζ hζw
      have hU : IsPreconnected ({(A.pole : ℂ)}ᶜ : Set ℂ) :=
        (isConnected_compl_singleton_of_one_lt_rank (by simp)
          ((A.pole : ℂ))).isPreconnected
      have hOn : AnalyticOnNhd ℂ A.F ({(A.pole : ℂ)}ᶜ : Set ℂ) :=
        fun ζ hζ => A.c1_analyticAt ζ hζ
      have hEq : Set.EqOn A.F 0 ({(A.pole : ℂ)}ᶜ : Set ℂ) :=
        hOn.eqOn_zero_of_preconnected_of_eventuallyEq_zero hU
          (Set.mem_compl_singleton_iff.mpr hwp) hfull
      -- a far-right real point is in the half-space and off the pole
      have hx₀half : A.Ω₀ < ((max A.Ω₀ A.pole + 1 : ℝ) : ℂ).re := by
        rw [Complex.ofReal_re]
        have := le_max_left A.Ω₀ A.pole
        linarith
      have hx₀ne : ((max A.Ω₀ A.pole + 1 : ℝ) : ℂ) ≠ (A.pole : ℂ) := by
        intro h
        have h1 := congrArg Complex.re h
        rw [Complex.ofReal_re, Complex.ofReal_re] at h1
        have := le_max_right A.Ω₀ A.pole
        linarith
      exact A.zero_free_on_halfSpace hx₀half
        (hEq (Set.mem_compl_singleton_iff.mpr hx₀ne))
  · -- the nonvanishing branch: pull back along the sequence
    have hlim' : Filter.Tendsto z Filter.atTop (nhdsWithin w {w}ᶜ) := by
      rw [tendsto_nhdsWithin_iff]
      exact ⟨hlim, Filter.Eventually.of_forall fun j => hne j⟩
    obtain ⟨j, hj⟩ := (hlim'.eventually hne').exists
    exact hj (hz j)

/-- **E4 §3 — the escape**: if the top level is NOT attained, every
level-maximizing sequence of zeros escapes to N in norm. A norm-bounded
subsequence would have a convergent sub-subsequence (properness of ℂ,
`IsCompact.tendsto_subseq'`); its limit `w` has `Re w = supLevel`
(continuity of `re` against the level convergence), so `w` is avoided by
every zero (their levels are strictly below the sup) — a finite
accumulation point, impossible (`no_finite_zero_accumulation`). PROVED. -/
theorem tendsto_norm_atTop_of_levels_tendsto_supLevel (A : ASection)
    (hna : ∀ k : ℕ, (A.sphereZero k).re < A.supLevel) {φ : ℕ → ℕ}
    (hφ : Filter.Tendsto (fun j => (A.sphereZero (φ j)).re) Filter.atTop
      (nhds A.supLevel)) :
    Filter.Tendsto (fun j => ‖A.sphereZero (φ j)‖) Filter.atTop
      Filter.atTop := by
  by_contra hcon
  rw [Filter.tendsto_atTop] at hcon
  push_neg at hcon
  obtain ⟨M, hM⟩ := hcon
  have hfreq : ∃ᶠ j in Filter.atTop,
      A.sphereZero (φ j) ∈ Metric.closedBall (0 : ℂ) M := by
    refine hM.mono fun j hj => ?_
    rw [Metric.mem_closedBall, dist_zero_right]
    exact hj.le
  obtain ⟨w, -, ψ, hψ, hlim⟩ :=
    (isCompact_closedBall (0 : ℂ) M).tendsto_subseq' hfreq
  have hlev : Filter.Tendsto (fun i => (A.sphereZero (φ (ψ i))).re)
      Filter.atTop (nhds A.supLevel) := hφ.comp hψ.tendsto_atTop
  have hre : Filter.Tendsto (fun i => (A.sphereZero (φ (ψ i))).re)
      Filter.atTop (nhds w.re) := (Complex.continuous_re.tendsto w).comp hlim
  have hwre : w.re = A.supLevel := tendsto_nhds_unique hre hlev
  have hne : ∀ i, A.sphereZero (φ (ψ i)) ≠ w := by
    intro i h
    have h1 := hna (φ (ψ i))
    rw [h, hwre] at h1
    exact lt_irrefl _ h1
  exact A.no_finite_zero_accumulation w
    (fun i => A.stem_zero_of_sphereZero (φ (ψ i))) hne hlim

/-- **E4 §3 — the attainment dichotomy of record**: the top level is
attained by some enumerated zero, or a level-maximizing sequence of zeros
escapes to N in norm. Neither horn closes the node (both are live for the
litmus two-level divisor); the dichotomy renders the brief's attainment
question honestly. PROVED. -/
theorem supLevel_attained_or_escape (A : ASection) :
    (∃ k : ℕ, (A.sphereZero k).re = A.supLevel)
      ∨ ∃ φ : ℕ → ℕ,
          Filter.Tendsto (fun j => (A.sphereZero (φ j)).re) Filter.atTop
            (nhds A.supLevel)
          ∧ Filter.Tendsto (fun j => ‖A.sphereZero (φ j)‖) Filter.atTop
              Filter.atTop := by
  by_cases h : ∃ k : ℕ, (A.sphereZero k).re = A.supLevel
  · exact Or.inl h
  · push_neg at h
    have hna : ∀ k : ℕ, (A.sphereZero k).re < A.supLevel :=
      fun k => (A.le_supLevel k).lt_of_ne (h k)
    obtain ⟨φ, hφ⟩ := A.exists_levels_tendsto_supLevel
    exact Or.inr ⟨φ, hφ,
      A.tendsto_norm_atTop_of_levels_tendsto_supLevel hna hφ⟩

end ASection
