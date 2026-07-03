/-
Concentricity/Theorem.lean

The π₀ lemma (master `lem:pi0-grothendieck`) and the statement of the
Concentricity Theorem (master `thm:concentricity`).

The statement layer STOPS here: the proof of `thm:concentricity` — the
C1–C4 assembly, including the placement sentence (landed in the master
2026-07-03, the author's alone) — is Phase 4.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.Base
import Concentricity.TwoWorlds
import Mathlib.CategoryTheory.Limits.Types.Colimits

noncomputable section

open CategoryTheory

universe v u

/-- The connected-components functor π₀ : Cat ⥤ Type (master
`lem:pi0-grothendieck` proof: "The functor π₀ : Cat → Set is left adjoint to
the inclusion of discrete categories, so it preserves colimits; and
components of a category correspond one-to-one with components of its
classifying space (Quillen §1, SOURCES/Quillen73.md)"). Object part is
Mathlib's `ConnectedComponents`, morphism part `Functor.mapConnectedComponents`. -/
def pi0Functor : Cat.{v, u} ⥤ Type u where
  obj C := ConnectedComponents C
  map F := TypeCat.ofHom (Functor.mapConnectedComponents F.toFunctor)
  map_id C := by
    ext x
    refine Quotient.inductionOn x fun j => ?_
    simp
  map_comp F G := by
    ext x
    refine Quotient.inductionOn x fun j => ?_
    simp

/-- master `lem:pi0-grothendieck` (verbatim): "For a functor F : 𝓑 → Grpd,
the connected-components functor carries the Grothendieck construction to
the colimit of the component diagram: π₀(∫_𝓑 F) ≅ colim_𝓑 (π₀ ∘ F)."
Queued (R8): the master's proof is direct at the level of categories
(zigzags project to the base and join fibrewise); the classifying-space
reading is Thomason (SOURCES/Thomason79.md), expository. -/
theorem pi0_grothendieck {B : Type u} [SmallCategory B] (F : B ⥤ Grpd.{u, u}) :
    Nonempty (ConnectedComponents (Grothendieck (F ⋙ Grpd.forgetToCat))
      ≃ Limits.colimit ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor)) := by
  sorry

/-- The component of 𝒯 in which the n-th residue-ℂ zero-sphere of an
A-section arrives — the OUTPUT of the C1–C4 assembly (master, proof of
`thm:concentricity`: "Hypotheses C1–C4 *assemble* the diagram; the
residue-ℂ zero-spheres then arrive as the degenerate fibre of its
transport, an output; and π₀ reads off their component").

Queued (R8): constructed by the Phase-4 assembly — the unique tame
transport extending the exponential's base (C2/C3 agreeing by the identity
theorem; C1's pole closing lifts into loops, GPVwind Cor 5.13;
`lem:exp-degenerate` supplying the level). Until then this is the named
seam between the statement layer and the proof. -/
def assemblyComponent (A : ASection) (n : ℕ) : ConnectedComponents TotalObject := by
  sorry

/-- **The Concentricity Theorem** (master `thm:concentricity`, verbatim):
"Let A be an A-section (Definition def:A-section). Then the residue-ℂ zero
spheres of A all lie in a single connected component of the total object
𝒯_A (Definition def:base) — equivalently, they have one and the same image
in π₀(𝒯_A)."

Queued (R8): the cocartesian proof (primary, Lean-native); the finality
proof (Quillen Thm A / precofibred corollary) is an expository remark,
deliberately left for the community to formalize. The statement layer stops
here. -/
theorem concentricity (A : ASection) (n m : ℕ) :
    assemblyComponent A n = assemblyComponent A m := by
  sorry
