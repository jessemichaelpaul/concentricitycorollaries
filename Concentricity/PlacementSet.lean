/-
Concentricity/PlacementSet.lean

The set-level placement (OFFICIAL form of the open node, author's ruling
2026-07-04), the divisor bundle tying it to the frozen row, and Brick 1 of
the two-index plan — the log-derivative engine where an individual Euler
index p meets an individual Weierstrass index n for the first time
(PLAN_two_index_bricks.md §1–§3; SCAN_shapes_and_C5_ledger.md is the
session record).

All statements land sorried (R8; the balloon 1/0 → 7/0 is waived per the
HANDOFF trajectory). The frozen row `ASection.transportLevel_placement`
is NOT edited. Per-statement checks run at this landing (author ruling 4,
2026-07-04): (a) conclusion-check — every conclusion is the value-level
fact (a real-number equality, a stem-zero equation, an identity of complex
numbers), no stand-ins; (b) PLAN §6 admissibility — no statement names a
σ₀, a ½, or any absolute level; only differences/equalities of levels
appear.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.Theorem
import Mathlib.Analysis.Calculus.Deriv.Basic

noncomputable section

namespace ASection

/-! ## §1 — The set-level placement (OFFICIAL form of the open node) -/

/-- The placement, set-level (OFFICIAL form of the open node; author's
ruling 2026-07-04 — enumeration-free, "the zero set is F's alone"). Any two
upper-half-plane zeros of the stem share one real part. -/
theorem placement_set (A : ASection) :
    ∀ ⦃z w : ℂ⦄, A.F z = 0 → A.F w = 0 → 0 < z.im → 0 < w.im →
      z.re = w.re := by
  sorry

/-! ## §2 — The divisor bundle (set form ⟷ frozen row; both directions
need the §4 convergence upgrade) -/

/-- Forward half: every enumerated sphere-zero is a stem zero. Needs: tprod
vanishes at a vanishing factor (R5: find/derive the Mathlib lemma; requires
the §4 upgrade — bare `Multipliable` does not suffice). -/
theorem stem_zero_of_sphereZero (A : ASection) (n : ℕ) :
    A.F (A.sphereZero n) = 0 := by
  sorry

/-- Completeness half: every upper-half stem zero is enumerated. Needs the
§4 upgrade (a non-enumerated zero would force a factor-zero-free tprod to
vanish). -/
theorem sphereZero_complete (A : ASection) ⦃z : ℂ⦄
    (hz : A.F z = 0) (him : 0 < z.im) : ∃ n, A.sphereZero n = z := by
  sorry

/-- The equivalence pin: set form ⟷ the frozen
`transportLevel_placement`. -/
theorem placement_set_iff (A : ASection) :
    (∀ ⦃z w : ℂ⦄, A.F z = 0 → A.F w = 0 → 0 < z.im → 0 < w.im → z.re = w.re)
      ↔ ∀ n m : ℕ, A.transportLevel n = A.transportLevel m := by
  sorry

/-! ## §3 — Brick 1: `stem_identity_logDeriv`, the two-index engine
(FE-free). Hypothesis shapes finalized against the arbiter per the
sanctioned pre-commit tightening; the Weierstrass side carries the pole
term from day one (§8 repair). -/

/-- Euler side, on the half-space: F′/F = ∑′ p, (ℓ p)′. Needs the §4
upgrade to differentiate through `∑'`. -/
theorem logDeriv_euler (A : ASection) :
    ∀ z : ℂ, A.Ω₀ < z.re →
      deriv A.F z / A.F z = ∑' p : A.ι, deriv (A.ℓ p) z := by
  sorry

/-- Weierstrass side, away from pole, origin, and zeros: F′/F unfolds over
individual n (each zero its own term) + m/z + R′/R + g′ − 1/(z − pole)
(the pole term from the §8 repair: (z − pole)·F equals the product, so F
inherits −1/(z − pole)). Needs the §4 upgrade to differentiate through
`∏'`. -/
theorem logDeriv_weierstrass (A : ASection) :
    ∀ z : ℂ, z ≠ (A.pole : ℂ) → z ≠ 0 → A.F z ≠ 0 → A.Rfac z ≠ 0 →
      deriv A.F z / A.F z =
        -(1 / (z - (A.pole : ℂ))) + (A.m : ℂ) / z
          + deriv A.Rfac z / A.Rfac z + deriv A.gfac z
          + ∑' n, deriv (spherePrimary (A.genus n) (A.sphereZero n)) z /
              spherePrimary (A.genus n) (A.sphereZero n) z := by
  sorry

end ASection
