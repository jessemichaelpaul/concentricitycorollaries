/-
Concentricity/Base.lean

The base 𝓑 of the exponential's degenerate set, the band F, and the total
object 𝒯 = ∫_𝓑 F via Mathlib's Grothendieck construction (R9: every object
constructed; master `def:base`).

Master `def:base` (quoted clause-by-clause in the docstrings): the base is
the groupoid of the real levels of the degenerate fibre
exp⁻¹(−r) = {log r + I(2k+1)π} (`lem:exp-degenerate` — proved in the master,
its Lean form queued with the slice-analytic layer); STATIC: no morphisms
between distinct levels; winding is band data, never an object label.

The subscript in the master's 𝒯_A rides on the populated transport (the
winding lifts of the section's value-loops, an output of the C1–C4 assembly,
Phase 4); the underlying category ∫_𝓑 F below is section-independent, which
is exactly the master's "zeros arrive as the degenerate fibre — output,
never input".

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.G2
import Mathlib.CategoryTheory.Groupoid.Grpd.Basic
import Mathlib.CategoryTheory.Grothendieck
import Mathlib.CategoryTheory.ConnectedComponents
import Mathlib.CategoryTheory.SingleObj
import Mathlib.Analysis.Complex.Circle

noncomputable section

open CategoryTheory

/-- **𝓑** (master `def:base`): "The *base* 𝓑 is the groupoid of these
levels: one object for each real level c, with the direction automorphisms
G₂ at each level. … Distinct levels are distinct objects with *no* morphisms
between them, so the level is constant along every zigzag and π₀(𝓑) is the
set of levels by construction."

Rendered as the product of the discrete category on ℝ (the levels — no
cross-level morphisms) with the one-object groupoid on G₂ (the direction
automorphisms at each level). -/
def Base := Discrete ℝ × SingleObj G2

instance : Category Base :=
  inferInstanceAs (Category (Discrete ℝ × SingleObj G2))

/-- **F** (master `def:base`): "Let F : 𝓑 → Grpd send each level to the band
groupoid U(1) (one object; automorphism group the phases) and each direction
morphism to the identity of the band." The band is the one-object groupoid
on Mathlib's `Circle`; F is the constant functor, so every base morphism
goes to the identity. The winding index 2k+1 "is carried by the band as an
automorphism datum within a component … and is never an object label of 𝓑". -/
def bandFunctor : Base ⥤ Grpd :=
  (Functor.const Base).obj (Grpd.of (SingleObj Circle))

/-- **𝒯 = ∫_𝓑 F** (master `def:base`): "The *Grothendieck construction* of F
is the category 𝒯_A = ∫_𝓑 F, with objects the pairs (c, x), x in the band
over c, and morphisms the pairs (f, φ) moving the base and transporting the
fibre" — Mathlib's `CategoryTheory.Grothendieck`, as the master's own Lean
pointer prescribes. -/
def TotalObject := Grothendieck (bandFunctor ⋙ Grpd.forgetToCat)

instance : Category TotalObject :=
  inferInstanceAs (Category (Grothendieck (bandFunctor ⋙ Grpd.forgetToCat)))

namespace TotalObject

/-- The level read-off on the objects of 𝒯 (master `def:base`: "objects the
pairs (c, x), x in the band over c" — the read-off returns c, the real
level). DERIVED (R10): the base of a Grothendieck object, projected to its
`Discrete ℝ` factor. -/
def level (X : TotalObject) : ℝ :=
  (Grothendieck.base X).1.as

/-- The level is a conserved quantity along every zigzag of 𝒯 (master
`def:base`: "Distinct levels are distinct objects with *no* morphisms
between them, so the level is constant along every zigzag"). DERIVED: every
`Grothendieck.Hom` projects to a morphism of the base, whose `Discrete ℝ`
component forces equal levels (`Discrete.eq_of_hom`); zigzags transport
along the projection functor (`zigzag_obj_of_zigzag`, `eq_of_zigzag`). -/
theorem level_eq_of_zigzag {X Y : TotalObject} (h : Zigzag X Y) :
    level X = level Y :=
  eq_of_zigzag ℝ
    (zigzag_obj_of_zigzag
      (Grothendieck.forget (bandFunctor ⋙ Grpd.forgetToCat) ⋙
        CategoryTheory.Prod.fst (Discrete ℝ) (SingleObj G2)) h)

/-- The canonical object of 𝒯 over a real level: the single band object in
the single fibre over the level c (master `def:base`: "one object for each
real level c"). -/
def ofLevel (r : ℝ) : TotalObject :=
  Grothendieck.mk (F := bandFunctor ⋙ Grpd.forgetToCat)
    (⟨r⟩, SingleObj.star G2) (SingleObj.star Circle)

/-- The π₀ readout as a named equivalence (master, proof of
`thm:concentricity`: "Readout: π₀(𝒯_A) ≅ colim_𝓑(π₀∘F) ≅ π₀(𝓑) = the
levels"). Forward: the level read-off, zigzag-invariant
(`level_eq_of_zigzag`), descended along the `ConnectedComponents` quotient;
inverse: the class of the canonical object. Both fibres over a level are
single-object, so two objects over one level are equal and the round trips
are definitional. Cocartesian register only (PHASE4_PLAN guardrail):
no Quillen A / Thomason input. -/
def levelClass : ConnectedComponents TotalObject ≃ ℝ where
  toFun := Quotient.lift level fun _ _ h => level_eq_of_zigzag h
  invFun r := Quotient.mk (Zigzag.setoid TotalObject) (ofLevel r)
  left_inv := Quotient.ind fun X => rfl
  right_inv _ := rfl

end TotalObject

/-- The π₀ readout, specialized to the band diagram (master, proof of
`thm:concentricity`: "Readout: π₀(𝒯_A) ≅ colim_𝓑(π₀∘F) ≅ π₀(𝓑) = the
levels"; the general statement is `lem:pi0-grothendieck`, queued for the
Phase-4 spine). Each band fibre is connected and the base levels are
discrete, so the components of 𝒯 are the levels ℝ. CLOSED by
`TotalObject.levelClass`. -/
theorem totalObject_components_eq_levels :
    Nonempty (ConnectedComponents TotalObject ≃ ℝ) :=
  ⟨TotalObject.levelClass⟩
