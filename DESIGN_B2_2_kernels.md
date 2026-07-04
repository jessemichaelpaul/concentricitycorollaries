# DESIGN — B2.2: the anchor-pair Möbius-kernel pairing (Lane B, 2026-07-04)

Register: design spec, words-before-commits. Lane A renders these shapes in Lean,
finalizes hypotheses against the arbiter (sanctioned tightening), and returns the
rendered statements for the author's confirmation before landing. Grounded in the
adopted (iv) target v0.2 (PLAN §6; READ_weil_li_findings.md) and Theorem 2 of the
generalized Bombieri–Lagarias source (READ provenance).

## The kernel family

For real a, β with a ≠ β, and n ≥ 1:

    K(n, a, β; z) := 1 − ((z − a) / (z − (2β − a)))ⁿ

Anchor pair {a, 2β − a}, mirror-symmetric about Re = β; the kernel's unit circle is
that line. All parameters real and BOUND (quantified), never named constants.

## Statement shapes (design level; Lane A finalizes)

**D0 — the sum (definition + well-definedness).**
    liSum A a β n := ∑' k, 2 * (K(n, a, β; A.sphereZero k)).re
Conjugation is proved in-frame, so the doubled real part renders the conjugate-paired
sum (rendering freedom: Lane A may instead sum a conjugate-closed multiset — pick
whichever the arbiter likes). Well-definedness = summability, from the divisor's
convergence: OBLIGATION C-1 (statement lands sorried; expected derivable from the
§4α majorants / genus data; if not derivable class-wide, R6 stop — author's word).

**D1 — finite-multiset BL (ladder L2; unconditional, pure algebra + Dirichlet
approximation).** For a FINITE multiset of complex numbers avoiding both anchors:
two-sided positivity for all n ⟺ all elements have Re = β. No analysis. This is the
reduction's engine, fully formalizable now.

**D2 — the class reduction (the adopted (iv), as an iff).**
    placement_set ↔ ∃ β : ℝ, (∀ a < β, ∀ n ≥ 1, 0 ≤ liSum A a β n)
                          ∧ (∀ a > β, ∀ n ≥ 1, 0 ≤ liSum A a β n)
Via Theorem 2 both-sidedly + D1 + the limit passage. The limit passage is the
analytic face — may land sorried with D1 proved; that isolates the gap exactly as
the ladder prescribes.

**D3 — the first side, derived (ladder L1).**
    ∃ β : ℝ, ∀ a < β, ∀ n ≥ 1, 0 ≤ liSum A a β n
from `zero_free_on_halfSpace` (C2): every level is bounded above by the half-space
edge, and the one-sided Theorem 2 direction converts the bound into the positivity
family. This makes "the remaining gap = the second side" a literal Lean fact.

**D4 (deferred flag, not for this landing) — the explicit-formula face.** The
arithmetic expression of liSum through the seed + residue ledger (contour integrals
of K-weighted logDeriv; generalized Littlewood). This is where the PRIME side enters
the positivity. Design only after D0–D3 are green — it consumes the (iv) assault
plan, and drafting it early would pre-read Brick 3's derivation strategy into
statements.

## Admissibility audit (per PLAN §6, run per shape at landing)

No ½, no named level — β existential, anchors bound ✓. Differences-only: kernels
depend on z − a and z − (2β − a); the whole family is translation-covariant ✓.
Exact per n — no Tendsto, no asymptotics ✓. Sums real via conjugation ✓. Zeros as
output: liSum reads the divisor; nothing feeds zeros in ✓. Frozen statements
untouched; def:A-section untouched ✓.

## Order

D0 (with C-1 sorried) → D1 (prove) → D3 (prove) → D2 (land; limit face may hold a
sorry, honestly labeled) → author reviews the survivor set → D4 design begins only
on the author's word. Ledger balloons under the waiver, then burns; every survivor
must be nameable as either the open node or a specified analytic obligation.
