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

/-! ## Route 3′ (author's refinement, 2026-07-05 night)

Verbatim: "the theorem is read on both static objects inside the same
A-section: B₁ and B₂ both static, both with their own N₁, N₂ witnesses, so
it has two connected components. So it should contradict the concentricity
theorem. … One real hyperplane means one north pole object (the connecting
witness) over B, not one real hyperplane means two north pole objects."

Rendered in BOTH candidate ambients; each clause fed to lake. -/

/-- Route 3′, middle step ("so it has two connected components"), read in
the object of record 𝒯^𝔫 — REFUTED, and the refutation is the already-PROVED
Pin 2: two levels do NOT give two components there. The geometric reason is
the master's own compactification (`def:zeta_O`, verbatim): "It is one point
with two names, so ∞ = N; it is the only point at infinity, shared by 𝕆*
and by every slice Riemann sphere ℂ_v* = S²_v." — in 𝕆* there is no N₁ ≠ N₂:
both levels' closing witnesses (`toNHom`) land at the SAME `nObj` by the
type of the arrow, so the two cones are one cone. -/
theorem route3'_two_components_false_in_record (c₁ c₂ : ℝ) :
    CategoryTheory.ConnectedComponents.mk (TotalTransport.ofBase (BaseC.lvl c₁))
      = CategoryTheory.ConnectedComponents.mk (TotalTransport.ofBase (BaseC.lvl c₂)) :=
  TotalTransport.transport_not_level_separating c₁ c₂

/-- Route 3′'s intended ambient, built honestly: per-level norths — each
level `c` with its OWN witness target `N_c` (`Sum.inl` = levels, `Sum.inr`
= per-level norths; arrows: each level to ITS north only). This is NOT the
geometry of 𝕆* (one-point compactification, one N); it is constructed to
locate route 3′'s seam. -/
def TwoNorth := ℝ ⊕ ℝ

/-- A level object of the per-level-north ambient. -/
def TwoNorth.lvl (c : ℝ) : TwoNorth := Sum.inl c

/-- The north of a single level — route 3′'s `N_c`. -/
def TwoNorth.north (c : ℝ) : TwoNorth := Sum.inr c

instance : CategoryTheory.Category TwoNorth where
  Hom x y := PLift (x = y ∨ ∃ c : ℝ, x = Sum.inl c ∧ y = Sum.inr c)
  id x := ⟨Or.inl rfl⟩
  comp {x y z} f g := ⟨by
    rcases f.down with h | ⟨c, hx, hy⟩
    · rw [h]; exact g.down
    · rcases g.down with h' | ⟨c', hx', hy'⟩
      · rw [← h']; exact Or.inr ⟨c, hx, hy⟩
      · rw [hy] at hx'; cases hx'⟩
  id_comp _ := rfl
  comp_id _ := rfl
  assoc _ _ _ := rfl

/-- The level read-off of the per-level-north ambient (both a level and its
north carry the level). -/
def TwoNorth.levelF : CategoryTheory.Functor TwoNorth (CategoryTheory.Discrete ℝ) where
  obj x := CategoryTheory.Discrete.mk (Sum.elim id id x)
  map {x y} f := CategoryTheory.Discrete.eqToHom (by
    rcases f.down with h | ⟨c, hx, hy⟩
    · rw [h]
    · rw [hx, hy]; rfl)

/-- **Route 3′'s seam, machine-checked**: on the per-level-north ambient —
the one where "two hyperplanes give two components" HOLDS — the theorem's
one-component reading is the SAME proposition as the level equality, i.e.
as Island P (the `zigzag_iff_level` pattern, one ambient over). Forward:
the level is conserved along every zigzag (each north carries its own
level). Backward: equal levels, reflexive zigzag. So route 3′ needs, in
place of the (refuted) middle step in 𝒯^𝔫, exactly the proposition it set
out to prove; and the locked theorem does not transport here (the collapse
onto 𝒯^𝔫 merges all norths into the one N — that is
`route3'_two_components_false_in_record`). -/
theorem TwoNorth.zigzag_iff (c₁ c₂ : ℝ) :
    CategoryTheory.Zigzag (TwoNorth.lvl c₁) (TwoNorth.lvl c₂) ↔ c₁ = c₂ := by
  constructor
  · intro h
    exact CategoryTheory.eq_of_zigzag ℝ
      (CategoryTheory.zigzag_obj_of_zigzag TwoNorth.levelF h)
  · rintro rfl
    exact CategoryTheory.Zigzag.refl _
