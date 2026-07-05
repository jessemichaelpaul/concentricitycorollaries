/-
Concentricity/OneHyperplaneRoute.lean

WORKING ARTIFACT — P-route 3 (author's proposition, 2026-07-05 night):
Island P (the One-Hyperplane Theorem) by contradiction against the
concentricity theorem. NOT imported by the root; carries the render's
single `sorry` at the exact resisting goal (R6).

Author's proposition (verbatim): "An A-section has one hyperplane. Proof.
Suppose not. Then A has two different base objects B_1, B_2 over different
great circles. Hence, the A section is disconnected. Contradiction to
concentricity theorem. Hence A section has one hyperplane."

Render, clause by clause; every consumable clause CONSUMED and PROVED:
  (a) "Suppose not" — `by_contra`.
  (b) "two different base objects over different levels" — PROVED
      (`base_objects_distinct`).
  (c) "hence the A-section is disconnected" — PROVED in the STATIC object:
      no zigzag joins distinct levels (`static_disconnected_of_ne`, from
      the proved `level_eq_of_zigzag`).
  (d) "contradiction to concentricity theorem" — the theorem of record is
      about the POPULATED object (`transport_universal`, PROVED, locked,
      fed below); Pin 2 (`transport_not_level_separating`, PROVED, fed
      below) exhibits the populated connection holding for EVERY pair of
      levels, so it coexists with (c)'s static disconnection; the exact
      resisting goal is recorded at the seam.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.TransportObject

noncomputable section

open CategoryTheory

/-- Clause (b), PROVED: distinct levels name distinct base objects of the
static total object (master `def:base`: "Distinct levels are distinct
objects"). -/
theorem base_objects_distinct {c₁ c₂ : ℝ} (h : c₁ ≠ c₂) :
    TotalObject.ofLevel c₁ ≠ TotalObject.ofLevel c₂ :=
  fun he => h (congrArg TotalObject.level he)

/-- Clause (c), PROVED: the static object is disconnected across distinct
levels — no zigzag joins them (master `def:base`: "no morphisms between
distinct levels"; `level_eq_of_zigzag`, PROVED). -/
theorem static_disconnected_of_ne {c₁ c₂ : ℝ} (h : c₁ ≠ c₂) :
    ¬ Zigzag (TotalObject.ofLevel c₁) (TotalObject.ofLevel c₂) :=
  fun hz => h (TotalObject.level_eq_of_zigzag hz)

/-- **P-route 3, the render** (author's proposition, 2026-07-05). Clauses
(a)–(c) consumed proved; the concentricity theorem and Pin 2 fed; the
contradiction clause (d) is the recorded seam below. -/
theorem ASection.one_hyperplane_route3 (A : ASection) (n m : ℕ) :
    A.transportLevel n = A.transportLevel m := by
  -- (a) "Suppose not."
  by_contra hne
  -- (b) "Then A has two different base objects B₁, B₂ over different
  --     great circles." — PROVED:
  have hobj : TotalObject.ofLevel (A.transportLevel n)
      ≠ TotalObject.ofLevel (A.transportLevel m) := base_objects_distinct hne
  -- (c) "Hence, the A section is disconnected." — PROVED, static object:
  have hstatic : ¬ Zigzag (TotalObject.ofLevel (A.transportLevel n))
      (TotalObject.ofLevel (A.transportLevel m)) := static_disconnected_of_ne hne
  -- (d) "Contradiction to concentricity theorem." — the theorem, FED
  --     (POPULATED object; PROVED, locked, kernel certificate):
  have hthm : A.transportClass n = A.transportClass m := A.transport_universal n m
  -- Pin 2, FED (PROVED): the populated object connects EVERY pair of
  -- levels — the same conclusion as hthm, level-free:
  have hpin2 := TotalTransport.transport_not_level_separating
    (A.transportLevel n) (A.transportLevel m)
  -- R6 RECORD (P-route 3 seam, 2026-07-05): no False arrives from
  -- hstatic + hthm. hpin2 shows hthm holds for every level pair, so hthm
  -- adds nothing against hne; and hstatic is `zigzag_iff_level`'s reading
  -- of hne itself (the static disconnection IS the supposition restated),
  -- not an independent fact colliding with the theorem. The route closes
  -- iff the concentricity theorem is read on the STATIC object — and
  -- `TotalObject.zigzag_iff_level` (PROVED both ways) makes that reading
  -- the same proposition as this theorem's goal. Exact resisting goal:
  --   ⊢ False
  sorry
