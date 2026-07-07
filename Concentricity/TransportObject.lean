/-
Concentricity/TransportObject.lean

The POPULATED total object (author's ruling 2026-07-05; PLAN_reencode_
concentricity_2026-07-05.md): the compactified base — levels ℝ plus the one
point at infinity 𝔫 — with the closing arrows c ⟶ 𝔫 (the great circle
closing through the pole, `def:carrier`: every slice sphere shares the single
N; ℝ ∪ {N} is one great circle). The re-encoded Concentricity Theorem lives
here: the residue-ℂ zero classes are connected at 𝔫 by the section's own
transport — the small argument, Zigzag/ConnectedComponents only; no
Functor.Final, no Quillen A.

HONESTY PINS (load-bearing; do not remove):
- Pin 1 `transport_universal`: the statement is class-wide BY DESIGN — any
  [scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
- Pin 2 `transport_not_level_separating`: the populated object separates NO
  levels; no centre readout exists here. `cor:nontrivial` does not ride on
  this object — it consumes `placement_set` (Pin 3), whose sorry is the one
  open node, unchanged in statement, at its new (translation-layer) address.
- Pin 3 `translation_requires_placement`: the static readout weld.

The static spine (Base.lean, Theorem.lean frozen rows) is untouched and
load-bearing for the translation layer. `sorry` marks UNFORMALIZED, never
UNSOUND (R8). This file targets ZERO sorries.
-/
import Concentricity.Theorem
import Concentricity.PlacementSet
import Mathlib.Topology.Compactification.OnePoint.Basic
import Mathlib.CategoryTheory.Category.Preorder

noncomputable section

open CategoryTheory

/-- **𝓑^𝔫, the compactified base** (PLAN_reencode §3a; `def:carrier`,
master ~line 653: "ℝ ∪ {N} is one great circle through the single N"):
levels ℝ and the point at infinity, as `OnePoint ℝ`. A `def` wrapper so no
ambient `OnePoint` instances leak in; the category structure is the thin one
below. -/
def BaseC := OnePoint ℝ

namespace BaseC

/-- The point at infinity 𝔫 of the compactified base
(`OnePoint.infty`, Mathlib/Topology/Compactification/OnePoint/Basic.lean:68).

**N is REAL** (author's directive 2026-07-05): it is the point at infinity of
the compactified REAL axis — it lies on the one great circle ℝ ∪ {N}
(`def:carrier`, master ~653), the G₂-fixed circle every slice sphere shares.
The closing arrows below land on this real point. -/
def nPt : BaseC := OnePoint.infty

/-- A finite level, as an object of 𝓑^𝔫 (`OnePoint.some`, ibid.:74). -/
def lvl (c : ℝ) : BaseC := OnePoint.some c

/-- The thin order of the great circle's closing: `x ≤ y` iff `x = y` or
`y = 𝔫`. Identities, the closing arrows `c ⟶ 𝔫`, and nothing else — in
particular no arrows between distinct finite levels and no arrows out of 𝔫
(master `def:base` static clause, kept: finite levels connect only THROUGH
𝔫). -/
instance : Preorder BaseC where
  le x y := x = y ∨ y = nPt
  le_refl x := Or.inl rfl
  le_trans x y z hxy hyz := by
    rcases hyz with h | h
    · rw [← h]; exact hxy
    · exact Or.inr h

-- The category structure is the global thin instance `Preorder.smallCategory`
-- (Mathlib/CategoryTheory/Category/Preorder.lean:47) on the Preorder above.

/-- Every object closes to 𝔫. -/
theorem le_nPt (x : BaseC) : x ≤ nPt := Or.inr rfl

end BaseC

/-- **F on the compactified base** (master `def:base`, band clause unchanged):
the constant functor at the band groupoid U(1). Winding stays band data,
never an object label. -/
def bandFunctorC : BaseC ⥤ Grpd :=
  (Functor.const BaseC).obj (Grpd.of (SingleObj Circle))

/-- **The populated total object 𝒯^𝔫 = ∫_{𝓑^𝔫} F** (Grothendieck, as for the
static `TotalObject`). -/
def TotalTransport := Grothendieck (bandFunctorC ⋙ Grpd.forgetToCat)

instance : Category TotalTransport :=
  inferInstanceAs (Category (Grothendieck (bandFunctorC ⋙ Grpd.forgetToCat)))

namespace TotalTransport

/-- The canonical object over a base point (single band object per fibre,
as in `TotalObject.ofLevel`). -/
def ofBase (x : BaseC) : TotalTransport :=
  Grothendieck.mk (F := bandFunctorC ⋙ Grpd.forgetToCat)
    x (SingleObj.star Circle)

/-- The object at 𝔫 — the cone point the value-loops close through (C1;
`rmk:collapse-cone`). -/
def nObj : TotalTransport := ofBase BaseC.nPt

/-- The closing arrow of 𝒯^𝔫 over `x ⟶ 𝔫`: base leg the thin-category
arrow, fibre leg the identity of the band (the constant functor transports
trivially). This is the arrow the transport RIDES; its register as the
section's transport is the witness structure below. The arrow lands on the
REAL point N of the great circle ℝ ∪ {N}: it is the categorical shadow of
the section's continuation through its real pole to N (C1;
`rmk:collapse-cone` — the preimage of any neighbourhood of N is a
neighbourhood of the pole). -/
def toNHom (x : BaseC) : ofBase x ⟶ nObj :=
  { base := homOfLE (BaseC.le_nPt x)
    fiber := 𝟙 _ }

/-- THE SMALL ARGUMENT (PLAN_transport_population §CORRECTION, resurrected
under the 2026-07-05 re-pricing): a morphism to 𝔫 puts any object in 𝔫's
zigzag class. Directly `Zigzag.of_hom`. -/
theorem zigzag_to_n (x : BaseC) : Zigzag (ofBase x) nObj :=
  Zigzag.of_hom (toNHom x)

/-- Class-of-level read: every base point's class is 𝔫's class. -/
theorem classOf_eq_nClass (x : BaseC) :
    CategoryTheory.ConnectedComponents.mk (ofBase x)
      = CategoryTheory.ConnectedComponents.mk nObj :=
  _root_.Quotient.sound' (zigzag_to_n x)

/-- **HONESTY PIN 2** — the populated object separates no levels: all
finite-level classes coincide (they all equal 𝔫's). Consequently NO centre
readout exists from 𝒯^𝔫, and `cor:nontrivial` does not ride on this object
(it consumes `placement_set`; Pin 3). This is the recorded July-4 mechanism
("N-terminal collapses π₀ for every section"), now stated as a theorem and
priced into the corollary chain instead of hidden
(HANDOFF_concentricity_argument.md §3.5; author's re-pricing 2026-07-05). -/
theorem transport_not_level_separating (c c' : ℝ) :
    CategoryTheory.ConnectedComponents.mk (ofBase (BaseC.lvl c))
      = CategoryTheory.ConnectedComponents.mk (ofBase (BaseC.lvl c')) :=
  (classOf_eq_nClass _).trans (classOf_eq_nClass _).symm

end TotalTransport

/-- **The transport witness** at a level (PLAN_reencode §3b, packaging (ii),
author-approved 2026-07-05): the closing arrow of 𝒯^𝔫 at that level, carried
together with C1 instantiated (the simple pole — the cone through which the
value-loops close; `c1_simple`). The remaining transport register — the
continuation on Ω₀ (`exists_log_continuation`), the one stem
(`stem_identity`), uniqueness of the tame lift (`winding_lift_unique`), the
loop closure (`winding_loop_defect`; GPVwind Cor 5.13) — is PROVED in
Concentricity/Toolkit.lean; the witness packages the arrow those rows
justify (R10: the citation lives here, the lemmas stay where they are). -/
structure ASection.TransportWitness (A : ASection) (c : ℝ) : Type where
  /-- The closing arrow at level c — the transport riding the great circle
  through the pole. -/
  arrow : TotalTransport.ofBase (BaseC.lvl c) ⟶ TotalTransport.nObj
  /-- C1, consumed: the pole is simple (order −1), value 𝔫
  (`rmk:two-poles`). -/
  pole_simple : meromorphicOrderAt A.F (A.pole : ℂ) = ((-1 : ℤ) : WithTop ℤ)

/-- The population of the diagram by the section: a witness at the level of
each residue-ℂ zero-sphere. The landing uses the FROZEN row
`ASection.transportLevel` (the only level datum on record); by Pin 2 it
cannot manufacture separation, so the anti-shortcut guard (PLAN_reencode §4)
is safe: connectivity comes from the arrows, never from the levels. -/
def ASection.Populated (A : ASection) : Type :=
  ∀ n : ℕ, A.TransportWitness (A.transportLevel n)

/-- Every A-section populates its diagram: the closing arrow is the great
circle's (def:carrier — geometry of 𝕆*, not a free apex), and C1 is a field
of the class. -/
def ASection.populated (A : ASection) : A.Populated :=
  fun _ => ⟨TotalTransport.toNHom _, A.c1_simple⟩

/-- The class in which the n-th residue-ℂ zero-sphere arrives in the
POPULATED object. -/
def ASection.transportClass (A : ASection) (n : ℕ) :
    CategoryTheory.ConnectedComponents TotalTransport :=
  CategoryTheory.ConnectedComponents.mk
    (TotalTransport.ofBase (BaseC.lvl (A.transportLevel n)))

/-- **The Concentricity Theorem, re-encoded** (master `thm:concentricity`,
author's ruling 2026-07-05 — "pure diagram connectivity built from the
transport, connect at 𝔫 by construction"): the residue-ℂ zero classes of an
A-section lie in a single connected component of the populated total object
𝒯^𝔫 — connected at 𝔫 by the section's own transport. The proof consumes the
witnesses (the arrows), never a level comparison. -/
theorem ASection.concentricity_transport (A : ASection) (hA : A.Populated)
    (n m : ℕ) : A.transportClass n = A.transportClass m :=
  (_root_.Quotient.sound' (Zigzag.of_hom (hA n).arrow)).trans
    (_root_.Quotient.sound' (Zigzag.of_hom (hA m).arrow)).symm

/-- **HONESTY PIN 1** — class-wide by design: EVERY A-section is so
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
the previous handoff's verification step included — this discharges that
step as a positive fact). "It's provable, holds for every section — the
entire point of building all of this machinery" (author, 2026-07-05). The
level-separating content lives downstream, at `placement_set` (Pin 3). -/
theorem ASection.transport_universal (A : ASection) (n m : ℕ) :
    A.transportClass n = A.transportClass m :=
  A.concentricity_transport A.populated n m

/-- **HONESTY PIN 3** — the address of the remaining content: on the STATIC
object, one component IS one level (the proved spine: `levelClass`,
`zigzag_iff_level`), so the static concentricity statement is EQUIVALENT to
the placement — the same node, translation-layer address. With the proved
weld `placement_set_iff` (PlacementSet.lean), `cor:nontrivial` consumes
exactly `placement_set`. Its sorry is the project's one open node; nothing
in this file closes, weakens, or hides it. -/
theorem ASection.translation_requires_placement (A : ASection) :
    (∀ n m : ℕ, A.transportLevel n = A.transportLevel m)
      ↔ ∀ n m : ℕ, assemblyComponent A n = assemblyComponent A m := by
  constructor
  · intro h n m
    rw [assemblyComponent_eq, assemblyComponent_eq]
    exact congrArg (⇑TotalObject.levelClass.symm) (h n m)
  · intro h n m
    have h' := h n m
    rw [assemblyComponent_eq, assemblyComponent_eq] at h'
    exact TotalObject.levelClass.symm.injective h'
