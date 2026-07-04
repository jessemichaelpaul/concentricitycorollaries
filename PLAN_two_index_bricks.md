# Plan — the two-index bricks (set-level placement + explicit-formula engine)

**Status:** author-confirmed direction (2026-07-04, in-session): "that's our one
sentence two-index gap … let's save this conversation and execute." Words-before-commits:
statement shapes below are for confirmation, then land in a new
`Concentricity/PlacementSet.lean`, import, `lake build`. Ledger at plan time: 1/0
(`ASection.transportLevel_placement`, Theorem.lean:201). Fences hold (anti-vacuity, R2,
R8, no statement edits to pass a proof). The frozen row is NOT edited; everything below
is additional statements.

## 0. Why this plan (one paragraph, from SCAN_shapes_and_C5_ledger.md)

The one sorry is `(A.sphereZero n).re = (A.sphereZero m).re` — a two-index equality.
Every closed tool is unary (one loop, one stem, one fibre); the group actions are
level-fixing; nine forcing vocabularies were run to the same unconsumed row (SCAN §6–§8).
The author's convergent insight: the missing structure is the pairing that lets an
individual Euler index p meet an individual Weierstrass index n — and its engine is
derivable: the logarithmic derivative of `stem_identity`. That is the class-level,
FE-free explicit-formula engine. Bricks 1–2 build the pairing; Brick 3 is the closing
clause (positivity), the relocated C5, classical home Weil/Li.

## 1. The set-level placement (author's ruling: OFFICIAL form of the node)

Enumeration-free; the zero set is F's alone; removes "we placed the zeros" — nothing
open changes.

```lean
/-- The placement, set-level (OFFICIAL form of the open node; author's ruling
2026-07-04). Any two upper-half-plane zeros of the stem share one real part. -/
theorem ASection.placement_set (A : ASection) :
    ∀ ⦃z w : ℂ⦄, A.F z = 0 → A.F w = 0 → 0 < z.im → 0 < w.im →
      z.re = w.re := by
  sorry
```

## 2. The divisor bundle (ties set form ⟷ frozen row; both directions need the
convergence upgrade of §4)

```lean
/-- Forward half: every enumerated sphere-zero is a stem zero. Needs: tprod
vanishes at a vanishing factor (R5: find/derive the Mathlib lemma; requires
§4 upgrade — bare Multipliable does not suffice). -/
theorem ASection.stem_zero_of_sphereZero (A : ASection) (n : ℕ) :
    A.F (A.sphereZero n) = 0 := by
  sorry

/-- Completeness half: every upper-half stem zero is enumerated. Needs §4
upgrade (a non-enumerated zero would force a factor-zero-free tprod to
vanish). -/
theorem ASection.sphereZero_complete (A : ASection) ⦃z : ℂ⦄
    (hz : A.F z = 0) (him : 0 < z.im) : ∃ n, A.sphereZero n = z := by
  sorry

/-- The equivalence pin: set form ⟷ frozen `transportLevel_placement`. -/
theorem ASection.placement_set_iff (A : ASection) :
    (∀ ⦃z w : ℂ⦄, A.F z = 0 → A.F w = 0 → 0 < z.im → 0 < w.im → z.re = w.re)
      ↔ ∀ n m : ℕ, A.transportLevel n = A.transportLevel m := by
  sorry
```

## 3. Brick 1 — `stem_identity_logDeriv` (the two-index engine, FE-free)

Individual p meets individual n for the first time. Shapes are SCHEMATIC — finalize
hypotheses (z ≠ 0 for the m/z term; `Rfac z ≠ 0`; zero-avoidance) against the arbiter
before commit.

```lean
/-- Euler side, on the half-space: F'/F = ∑' p, (ℓ p)'. Needs §4 upgrade to
differentiate through ∑'. -/
theorem ASection.logDeriv_euler (A : ASection) :
    ∀ z : ℂ, A.Ω₀ < z.re →
      deriv A.F z / A.F z = ∑' p : A.ι, deriv (A.ℓ p) z := by
  sorry

/-- Weierstrass side, away from pole and zeros: F'/F unfolds over individual
n (each zero its own term) + m/z + R'/R + g'. SCHEMATIC: tighten hypotheses.
Needs §4 upgrade to differentiate through ∏'. -/
theorem ASection.logDeriv_weierstrass (A : ASection) :
    ∀ z : ℂ, z ≠ (A.pole : ℂ) → z ≠ 0 → A.F z ≠ 0 → A.Rfac z ≠ 0 →
      deriv A.F z / A.F z =
        (A.m : ℂ) / z + deriv A.Rfac z / A.Rfac z + deriv A.gfac z +
        ∑' n, deriv (spherePrimary (A.genus n) (A.sphereZero n)) z /
                spherePrimary (A.genus n) (A.sphereZero n) z := by
  sorry
```

`stem_identity_logDeriv` := the two sides equated on the overlap (then continued):
the two-index ledger's seed.

## 4. The convergence upgrade (named obligation — R6, not a formality)

Bare `Summable` (`c2_summable`) and `Multipliable` (`c3_multipliable`) do not license
term-by-term log-differentiation or tprod-vanishing. Two routes, author's ruling
required (R3 — this touches the class definition):
- (a) **Derive** locally normal convergence where derivable from existing fields
  (preferred if it goes through; keeps `def:A-section` untouched);
- (b) **Add** explicitly-flagged hypotheses (`c2_summable_locUniform`,
  `c3_multipliable_locNormal`) — strengthens the class; must be checked against the
  master's `def:A-section` wording and flagged in the LaTeX if adopted.

## 5. Brick 2 — the pairing (deferred until Brick 1 is green)

Test-function pairing of the two log-derivative expansions: the genuine Σ_p ↔ Σ_n
ledger. Statement shape drafted only after Brick 1's exact term shapes survive
`lake build`.

## 6. Brick 3 — the closing clause (honesty pin)

Bricks 1–2 STATE the closing clause sharply; they do not discharge it. The clause —
the positivity/inequality that equalizes the levels — is the relocated C5. Classical
home: **Weil's criterion** (RH ⟺ positivity of an explicit-formula pairing) and
**Li's criterion** (RH ⟺ nonnegativity of the Li sequence). First act: read both at
class level and write the exact class-level target the frame would need — including
whether the band/winding packaging offers a new handle on the positivity term. "Euler +
Weierstrass alone force one level" remains GRH-scale for the class (HANDOFF §4 of
2026-07-03/04); the discovery point, if any, is here.

**Value-free constraint (author's ruling, recorded):** the Brick-3 target sentence is
stated for the class with NO specific value — no ½, no named level. It asserts *one*
level, never *which*; value-pinning enters exactly once, downstream, via the member's
own functional equation (`cor:rh`). When reading Weil/Li: extract the shape (positivity
of a pairing over the two-index ledger) and strip the value — any ½ appearing in the
class-level target is a leak from downstream. The abstraction bridge between the
analytic criteria and the categorical readout is the **equality form** of the chart
statement — **|ρₙ|²·Re(1/ρₙ) equal over all n**, which is placement on the nose via the
identity |ρ|²·Re(1/ρ) = Re ρ (exact, every zero, no tail). [Corrected 2026-07-04 per
Lane B's precision catch: the earlier τₙ²-normalized quantity σₙτₙ²/(σₙ²+τₙ²) is only
the tail shadow — not equivalent at finite height; SCAN §7's limit-form caveat applies
to it, not to the |ρₙ|² form.]

**Statement-level admissibility test (Lane B 2026-07-04, endorsed):** the Brick-2
pairing must be covariant under the level-translation gauge — it may see *differences*
of levels only. Any completion factor, base point, or test-cone centering that names a
σ₀ re-imports a fixed locus and turns the clause absolute (the archimedean-style
"for symmetry" factor is the classical reflex to refuse). Run this check at every
statement landing. **Gauge caveat to verify first:** translation-closure of the class
holds up to re-bucketing the q^m origin factor into R (the slid origin is a real zero,
absorbable into Rfac per c3_R_zeros_real) — verify def:A-section/C3's wording permits
the migration; if the origin is genuinely distinguished, the gauge is
translations-fixing-0 and the "differences only" clause needs restating.

## 7. Execution order

1. Confirm §1–§3 statement shapes with the author (this document is the confirmation
   surface).
2. Land `Concentricity/PlacementSet.lean`; import in `Concentricity.lean`;
   `lake build`; repair names against the arbiter (R5 live checks: tprod zero lemma,
   logDeriv API).
3. §4 ruling, then close §2's bundle and Brick 1.
4. Brick 2 statement layer; Brick 3 reading + target statement.
5. Update blueprint/master only after the Lean shapes are green (R7: diffs, not essays).

## 8. Pole-factor ruling (author, 2026-07-04 — R6 recorded; R3 statement change, author's word given)

**C3 carries the pole factor.** Ground: the factorization is "over the **full
divisor**," and the full divisor of a meromorphic section includes the pole with
multiplicity −1 — classically Hadamard factors (s−1)ζ(s), and the 1/(s−1) is explicit
in the product form. As frozen, `c3_factorization` equates F with an entire-shaped
product away from the pole: under §4's convergence upgrade this collides with
`c1_simple` (order −1), and the intended instantiation (`cor:zeta-section`) would be
unbuildable (the equation is false by exactly the factor (z − pole) for the intended
witness). This is a transcription repair, not an edit-to-pass-a-proof; recorded as such.

Lean shape (Lane A; multiplication, not division):

```lean
c3_factorization : ∀ z : ℂ, z ≠ (A.pole : ℂ) →
    (z - (A.pole : ℂ)) * F z = z ^ m * Rfac z * Complex.exp (gfac z) *
      ∏' n, spherePrimary (genus n) (sphereZero n) z
```

Consequences: `logDeriv_weierstrass` (§3) gains the pole term −1/(z − pole) on the
Weierstrass side. Master (Lane B): C3's displayed formula gains the explicit pole
factor; "full divisor" becomes literal. Author's gloss, recorded: "we needed infinite
Weierstrass to pull along infinite Euler and the infinite C-residue zeros" — the pole
factor is what lets the one meromorphic object carry both infinite families against
the single pole.

## 9. rmk:pi0-split ruling (author, 2026-07-04, on Lane B's leak find)

The finality half of `rmk:pi0-split` is made **placement-consuming**: explicit
`\uses{}` on the placement and a one-sentence "post-placement reading" qualifier
(zero-bearing part = the single level; 𝔫 final over it — an honest readout). The
fibred half stays as is (clean re-derivation of π₀(𝒯_A) ≅ π₀(𝓑)). R10: the remark
remains expository register; the dependence is now explicit. Rides in the Lane B
task-1 diff.
