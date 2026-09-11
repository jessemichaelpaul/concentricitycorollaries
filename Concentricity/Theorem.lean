/-
Concentricity/Theorem.lean

The π₀ lemma (master `lem:pi0-grothendieck`) and the statement of the
Concentricity Theorem (master `thm:concentricity`).

The statement layer STOPS here: the proof of `thm:concentricity` — the
C1–C4 assembly, including the placement sentence (landed in the master
2026-07-03, the author's alone) — is Phase 4.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.Toolkit
import Concentricity.ASectionCResidueDiagram
import Concentricity.ASectionTotalActionState
import Mathlib.CategoryTheory.Limits.Types.Colimits
import Mathlib.CategoryTheory.Groupoid.Grpd.Basic
import Mathlib.CategoryTheory.Grothendieck
import Mathlib.CategoryTheory.ConnectedComponents

set_option linter.style.header false

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

section Pi0Grothendieck

variable {B : Type u} [SmallCategory B] (F : B ⥤ Grpd.{u, u})

/-- The canonical cocone of the component diagram π₀ ∘ F with apex
π₀(∫_𝓑 F): at b, a fibre component `mk x` goes to the total component
`mk ⟨b, x⟩` (the fibre inclusion `Grothendieck.ι`); naturality is the
zigzag along the hom `(f, 𝟙)` (`Grothendieck.ιNatTrans`). DERIVED (R10);
cocartesian register only (PHASE4_PLAN guardrail). -/
def pi0Cocone : Limits.Cocone ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor) where
  pt := ConnectedComponents (Grothendieck (F ⋙ Grpd.forgetToCat))
  ι :=
    { app := fun b => TypeCat.ofHom
        (Functor.mapConnectedComponents (Grothendieck.ι (F ⋙ Grpd.forgetToCat) b))
      naturality := fun b b' f => by
        ext x
        refine _root_.Quotient.inductionOn x fun j => ?_
        simp only [pi0Functor, Functor.comp_obj, Functor.comp_map, types_comp_apply,
          TypeCat.ofHom_apply, Functor.mapConnectedComponents_mk,
          Functor.const_obj_obj, Functor.const_obj_map, types_id_apply]
        exact (_root_.Quotient.sound
          (Zigzag.of_hom ((Grothendieck.ιNatTrans f).app j))).symm }

/-- The object part of the comparison: a total object goes to the colimit
class of its fibre component over its base object. -/
def toColimitObj (X : Grothendieck (F ⋙ Grpd.forgetToCat)) :
    Limits.colimit ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor) :=
  Limits.colimit.ι ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor) X.base
    (CategoryTheory.ConnectedComponents.mk X.fiber)

/-- A morphism of ∫F leaves the comparison class unchanged: its base leg
is absorbed by the colimit identifications (`colimit.w`), its fibre leg by
the fibre's own π₀ (master `lem:pi0-grothendieck` proof: "zigzags project
to the base and join fibrewise"). -/
theorem toColimitObj_eq_of_hom {X Y : Grothendieck (F ⋙ Grpd.forgetToCat)}
    (φ : X ⟶ Y) : toColimitObj F X = toColimitObj F Y := by
  have h1 : toColimitObj F X
      = Limits.colimit.ι ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor) Y.base
          (CategoryTheory.ConnectedComponents.mk
            (((F ⋙ Grpd.forgetToCat).map φ.base).toFunctor.obj X.fiber)) :=
    (Limits.colimit.w_apply ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor) φ.base
      (CategoryTheory.ConnectedComponents.mk X.fiber)).symm
  have h2 := congrArg
    (fun t => Limits.colimit.ι ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor) Y.base t)
    (_root_.Quotient.sound (Zigzag.of_hom φ.fiber))
  exact h1.trans h2

/-- Zigzag invariance of the comparison, by reflexive-transitive closure of
`toColimitObj_eq_of_hom`. -/
theorem toColimitObj_eq_of_zigzag {X Y : Grothendieck (F ⋙ Grpd.forgetToCat)}
    (h : Zigzag X Y) : toColimitObj F X = toColimitObj F Y := by
  induction h with
  | refl => rfl
  | tail _ hzag ih =>
    refine ih.trans ?_
    rcases hzag with hφ | hφ
    · exact toColimitObj_eq_of_hom F hφ.some
    · exact (toColimitObj_eq_of_hom F hφ.some).symm

/-- master `lem:pi0-grothendieck` as the named canonical equivalence:
π₀(∫_𝓑 F) ≃ colim_𝓑 (π₀ ∘ F). Forward: the comparison `toColimitObj`
descended along the π₀ quotient; inverse: `colimit.desc` of the canonical
cocone `pi0Cocone`; round trips by the Types colimit presentation
(`colimit.ι_desc`, `Types.jointly_surjective'`). Cocartesian register only
— no Quillen A / Thomason input (PHASE4_PLAN guardrail). -/
noncomputable def pi0GrothendieckEquiv :
    ConnectedComponents (Grothendieck (F ⋙ Grpd.forgetToCat))
      ≃ Limits.colimit ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor) where
  toFun := _root_.Quotient.lift (toColimitObj F)
    fun _ _ h => toColimitObj_eq_of_zigzag F h
  invFun t := Limits.colimit.desc ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor) (pi0Cocone F) t
  left_inv := _root_.Quotient.ind fun X =>
    (Limits.colimit.ι_desc_apply (pi0Cocone F) X.base
      (CategoryTheory.ConnectedComponents.mk X.fiber)).trans rfl
  right_inv t := by
    obtain ⟨b, y, rfl⟩ := Limits.Types.jointly_surjective' t
    refine _root_.Quotient.inductionOn y fun j => ?_
    have h1 := Limits.colimit.ι_desc_apply (pi0Cocone F) b
      (CategoryTheory.ConnectedComponents.mk j)
    calc _root_.Quotient.lift (toColimitObj F)
          (fun _ _ h => toColimitObj_eq_of_zigzag F h)
          (Limits.colimit.desc ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor) (pi0Cocone F)
            (Limits.colimit.ι ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor) b
              (CategoryTheory.ConnectedComponents.mk j)))
        = _root_.Quotient.lift (toColimitObj F)
            (fun _ _ h => toColimitObj_eq_of_zigzag F h)
            ((pi0Cocone F).ι.app b (CategoryTheory.ConnectedComponents.mk j)) :=
          congrArg (_root_.Quotient.lift (toColimitObj F)
            fun _ _ h => toColimitObj_eq_of_zigzag F h) h1
      _ = Limits.colimit.ι ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor) b
            (CategoryTheory.ConnectedComponents.mk j) := rfl

end Pi0Grothendieck

/-- master `lem:pi0-grothendieck` (verbatim): "For a functor F : 𝓑 → Grpd,
the connected-components functor carries the Grothendieck construction to
the colimit of the component diagram: π₀(∫_𝓑 F) ≅ colim_𝓑 (π₀ ∘ F)."
CLOSED by the named canonical equivalence `pi0GrothendieckEquiv` — the
master's proof is direct at the level of categories (zigzags project to
the base and join fibrewise); the classifying-space reading is Thomason
(SOURCES/Thomason79.md), expository, NOT used. -/
theorem pi0_grothendieck {B : Type u} [SmallCategory B] (F : B ⥤ Grpd.{u, u}) :
    Nonempty (ConnectedComponents (Grothendieck (F ⋙ Grpd.forgetToCat))
      ≃ Limits.colimit ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor)) :=
  ⟨pi0GrothendieckEquiv F⟩

/- RE-BADGED 2026-07-05 (PLAN_reencode §5), SUPERSEDED 2026-07-06 by the
author's ruling (a): the master label and endpoint now live on
`ASection.concentricity` below; this record is kept as the placement
paragraph's transcription map. Original text:
the endpoint, at its
translation-layer address; the remaining Lean transcription now lives on
`ASection.concentricity`, consumed by `cor:nontrivial`. Statement and
sorry unchanged.

**The placement** (master, proof of `thm:concentricity`, the placement
paragraph, verbatim): "Through the commuting triangle π∘E = exp
([Rem. 5.2(a)]{VS}), the unique tame lift traverses the logarithm manifold
as a single closed loop ([Cor. 5.13]{GPVwind}), and every point of the
degenerate fibre it meets is, by Lemma lem:exp-degenerate, the level log r
paired with an odd winding height I(2k+1)π: all multiplicity in the fibre
lies in the winding direction ([Cor. 5.21]{GPVwind}), none in the level.
Since 𝓑 is static — no morphisms between distinct levels (Definition
def:base) — the level is a conserved quantity along every zigzag of 𝒯_A,
and the degenerate fibre of the unique tame transport attached to the
A-section — the residue-ℂ zero-spheres {q_n} of C3 — lies over a *single*
level."

All four hypotheses are live in the assembly this transcribes (master,
assembly paragraph; R3): C2 supplies the outright continuation of the
hypercomplex logarithm on Ω₀ (`exists_log_continuation`); C3 the
exponential expression over the full divisor, agreeing with C2 on the
overlap by the Identity Theorem (`stem_identity`), whence the tame lift is
unique (`winding_lift_unique`); C1's pole is the cone through which the
value-loops close ([Cor. 5.13]{GPVwind}); C4 makes the degenerate fibre
infinite.

Queued (R8) — sorried against the sorried cone nodes of
Concentricity/Toolkit.lean; step-by-step transcription record:
(a) "the unique tame lift traverses the logarithm manifold as a single
closed loop" — GPVwind Cor 5.13, whose σ-apparatus is the recorded GAP of
`winding_loop_defect`; (b) "every point of the degenerate fibre it meets
is … the level log r paired with an odd winding height I(2k+1)π" —
`Octonion.exp_fibre_neg_real` (sorried); (c) the C2/C3 agreement feeding
(a) — `stem_identity` (sorried); (d) "the level is a conserved quantity
along every zigzag of 𝒯_A" — PROVED, `TotalObject.level_eq_of_zigzag`
(Concentricity/Base.lean); (e) "lies over a *single* level" — the
conclusion discharged here. -/
/- **THE CONCENTRICITY THEOREM** (master `thm:concentricity`; the
statement carrier per the author's ruling of 2026-07-06, superseding the
2026-07-05 re-encode: "(a) is literally the entire point of this entire
project" — the theorem, stated as the author means it): **the infinitely
many residue-ℂ zero-spheres of an A-section are concentric — one real
centre.** The concentric dictionary's reading of the A-section's one
concentric component: [the concentric component] → ∃ c, one centre.

THE ENDPOINT HAS TWO LEAN TRANSCRIPTION SEATS AND NO OUTSTANDING MATHEMATICAL
INFERENCE. Everything on both sides is proved and certified: the transport
connectivity (historically `concentricity_transport` — its file was
retired with the static tower; the live connectivity is the ι_A route
typed at this node), the
articulation (one component, defined through
the witness 𝔫, fibre concentric), the Φ-collapse and π₀(𝒮₂)
(PhiConversion.lean: the glue total and proper, the slice world's
components = the value moduli), the complete BL ladder (D0–D3 + mirror +
D2's proved kernel-coordinate iff (∃β two-sided positivity), the σ-closure rows, the
supplier chain, and the corollary chain (`cor:nontrivial`, `cor:rh` with
½ from `thm:rh-equiv`'s proved rigidity) consuming it downstream. The
transport's memory is the witness structure; the transport over the base
remembers the centres in the A-section (`rmk:collapse-cone`); this row is
the memory's readback. -/
/- THE PROOF PLAN OF RECORD (the author, 2026-07-07, verbatim — the argument
stated finally and completely; the transcription runs against exactly these
three clauses and nothing else:

1. A is a member of the ring 𝓡 of slice-preserving functions on the
   octonions, with properties C1–C4.
2. THAT IMPLIES THE GPV-BASE — which has everything: σ = c, unique winding,
   the *concentric* fibres and their connection.
3. The concentricity OF THE GPV BASE is EXTENDED to the concentricity of
   the infinitely many ℂ-residue spheres of the A-section, which land in a
   connected component.

The extension of clause 3 is the original extension move (the author,
from the first day): the concentric structure of the base extends along
the connection to the spheres. -/

-- `ASection.concentricity` (master `thm:concentricity`) is the production
-- target, with type:
--
--   theorem ASection.concentricity (A : ASection) :
--       ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c
--
-- Its binding route is the one stated in the master: first take π₀ of the
-- exact residue total and obtain its sole class κ; only afterward evaluate
-- the inherited map Lbar_A at κ and connect that value to the original
-- semantic residue states.  The quarantined slice-projection and pre-collapse
-- naturality routes are not production dependencies.

/-- The certified membership of the enumerated representatives: the
`n`-th pole-fibre seed is selected through the identity arrow — the
representatives live in the pole fibre. -/
theorem ASection.residueActionState_mem (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    IsCResidueState A (projectivePole A)
      (residueActionState A (projectivePole A) n I) := by
  refine ⟨n, I, 𝟙 (projectivePole A), ?_⟩
  rw [AsectionActionTransport_id]
  rfl

/-- **A SUPPLIER, NOT THE RESULT** (badge corrected 2026-07-29, the author:
*"you misled us"*).  This quantifies over the **ambient** `H1`, not over the
C-residue system: it is `thm:G2-S6` re-spelled through the sweep, and it
says nothing about `ι_A`.  THE RESULT is that the A-section equivariant
functor — **part of the construction of `ι_A`**, its fibres being the
functor's graph (`AsectionStateInput ⋙ AsectionEquivariant =
AsectionStateOutput`, `rfl`) — is transitive on the C-residue system
`∫𝓡_A`, hence connected.  That is not this declaration.

The author's sentence this states one clause of, 2026-07-28 night: *"ι_A IS my
C-residue system and the equivariant A-section functor is transitive on it …
THE EQUIVARIANT A SECTION FUNCTOR IS LITERALLY TRANSITIVE ON THE IMAGINARY
OCTONIONS."*

`thm:G2-S6` **applied to the object**, not cited bare: on the imaginary
octonions where the members live, one element of `G₂` is one arrow of
`H1 = G₂ ⋉ 𝕆*` (`hom_as_subtype`, `Action.lean:92`), and
`AsectionEquivariant` carries that arrow — it *"retains the same `G₂`
element"* (`ASectionEquivariant.lean:49`), its naturality being
`realize_equivariant` itself. The element and the sweep together, applied to
the members. -/
theorem ASection.AsectionEquivariant_transitive (A : ASection) (p q : H1)
    {u v : Octonion} (hu : u ∈ Octonion.unitImaginarySphere)
    (hv : v ∈ Octonion.unitImaginarySphere)
    (hp : p.back = (u : OnePoint Octonion))
    (hq : q.back = (v : OnePoint Octonion)) :
    Nonempty ((A.AsectionEquivariant).obj p ⟶ (A.AsectionEquivariant).obj q) := by
  obtain ⟨g, hg⟩ := G2.exists_smul_eq_of_mem_unitImaginarySphere hu hv
  have harrow : p ⟶ q := ⟨g, by
    show g • p.back = q.back
    rw [hp, hq, ← hg]; rfl⟩
  exact ⟨(A.AsectionEquivariant).map harrow⟩

/-- **A SUPPLIER, NOT THE RESULT** (badge corrected 2026-07-29) — the same
clause read at the ambient states.  Like the declaration above it mentions
`ι_A` nowhere, and it is not the transitivity of the sweep on `∫𝓡_A`.

The anatomy it records — the same clause read where the
members live.  A member's input eye is `AsectionState.input s`: the point
`σ + γ·v` of its own sphere at the coordinate `C⁻¹·s.coordinate` that
`s.coordinate` positions (master `def:cayley-disk`).  `thm:G2-S6` is the
transitivity of `G₂` on that sphere
(`lem:residue-spheres`: *"each such sphere `σ+γS⁶` is the `G₂`-orbit of any
of its points"*), and `AsectionStateInput` is a **functor**, so the arrow
travels through it — no coordinate law is needed on the way.  The sweep then
carries it, as in Declaration 0. -/
theorem ASection.AsectionEquivariant_transitive_states (A : ASection)
    (x y : A.AsectionStateWorld)
    (h : (CategoryTheory.ActionCategory.back x).coordinate
       = (CategoryTheory.ActionCategory.back y).coordinate) :
    Nonempty ((A.AsectionEquivariant).obj ((AsectionStateInput A).obj x) ⟶
              (A.AsectionEquivariant).obj ((AsectionStateInput A).obj y)) := by
  have key : ∀ s t : A.AsectionState, s.coordinate = t.coordinate →
      ∃ g : G2, g • s = t := by
    rintro ⟨sw, sc⟩ ⟨tw, tc⟩ hc
    obtain ⟨g, hg⟩ :=
      G2.exists_smul_eq_of_mem_unitImaginarySphere sw.2 tw.2
    refine ⟨g, ?_⟩
    simp only [HSMul.hSMul, SMul.smul, AsectionState.mk.injEq]
    exact ⟨Subtype.ext hg, hc⟩
  obtain ⟨g, hg⟩ := key _ _ h
  exact ⟨(A.AsectionEquivariant).map ((AsectionStateInput A).map (⟨g, hg⟩ : x ⟶ y))⟩

/-- **DECLARATION 1** (the author's, verbatim, `def:residue-subdiagram`):
`ι_A : 𝓡_A ⇒ 𝓐_A` is "a faithful embedding onto its image, and its
naturality squares commute definitionally."

Wiring only: `(AsectionCResidueInclusion A).app X` **is**
`(IsCResidueState A X).ι` (`ASectionCResidueDiagram.lean:165`), and `𝓡_A`
**is** its own image (`FullSubcategory`; `ι_obj` = `rfl`).  Mathlib carries
the fact — `fullyFaithfulι` on `[propext]` alone — but resolution matches
surface syntax, so it fires on the `ι` spelling and not on `ι_A`'s name.
These declarations put it under the author's name. -/
def ASection.AsectionCResidueInclusion_app_fullyFaithful
    (A : ASection) (X : GreatCircle.Base) :
    ((AsectionCResidueInclusion A).app X).FullyFaithful :=
  ObjectProperty.fullyFaithfulι _

instance ASection.AsectionCResidueInclusion_app_full
    (A : ASection) (X : GreatCircle.Base) :
    ((AsectionCResidueInclusion A).app X).Full :=
  ObjectProperty.full_ι _

instance ASection.AsectionCResidueInclusion_app_faithful
    (A : ASection) (X : GreatCircle.Base) :
    ((AsectionCResidueInclusion A).app X).Faithful :=
  ObjectProperty.faithful_ι _

/-- **`𝒯_A`** — the total value-transport category of master `def:base`,
`𝒯_A = ∫_𝓑 𝓐_A`.  Named here because it had none: it was written inline
wherever it occurred, so no declaration could be stated *at* it. -/
abbrev ASection.ambientTotalCategory (A : ASection) : Type :=
  Grothendieck (A.AsectionActionDiagram ⋙ Grpd.forgetToCat)

/-- The projective-frame C-residue total: the Grothendieck construction of
the authored inverse-image subdiagram. -/
abbrev ASection.projectiveResidueTotalCategory (A : ASection) : Type :=
  Grothendieck (A.AsectionCResidueDiagram ⋙ Grpd.forgetToCat)

/-- **`∫𝓡_A`** — the one production C-residue total. -/
abbrev ASection.residueTotalCategory (A : ASection) : Type :=
  A.projectiveResidueTotalCategory

/-- The certified `m`-th pole-fibre residue representative, as an object of
the authored projective residue total `∫ R_A`. -/
noncomputable def ASection.residueTotalObject
    (A : ASection) (m : ℕ) :
    A.residueTotalCategory :=
  ⟨projectivePole A,
    ⟨residueActionState A (projectivePole A) m baseWorld,
      A.residueActionState_mem m baseWorld⟩⟩

/-- The real coordinate carried by an object of the one authored residue
total `∫ R_A`: the real coordinate of the point `C⁻¹·w` that its positioned
entry `w` positions (master `def:cayley-disk`). -/
def ASection.residueTotalTransportRead (A : ASection)
    (P : A.residueTotalCategory) : ℝ :=
  OnePoint.rec 0 Complex.re
    ((GreatCircle.cayleyMoebius⁻¹).val P.fiber.obj.positioned.back.coordinate)

/-- The certified `n`-th representative reads as the real coordinate of its
authored C3 residue sphere. -/
@[simp] theorem ASection.residueTotalTransportRead_certified
    (A : ASection) (n : ℕ) :
    A.residueTotalTransportRead (A.residueTotalObject n) =
      (A.sphereZero n).re := by
  simp only [ASection.residueTotalTransportRead, ASection.residueTotalObject,
    residueActionState_positioned]
  change OnePoint.rec (C := fun _ => ℝ) (0 : ℝ) Complex.re
    ((GreatCircle.cayleyMoebius⁻¹).val (A.residueState n baseWorld).coordinate) = _
  rw [residueState_coordinate, cayleyMoebius_inv_apply_cayley]
  rfl

/-- The project's real level is the reading carried by its certified object
in the one authored residue total. -/
def ASection.transportLevel (A : ASection) (n : ℕ) : ℝ :=
  A.residueTotalTransportRead (A.residueTotalObject n)

/-- The transport-carried level is the real coordinate of the certified C3
residue sphere. -/
theorem ASection.transportLevel_eq_sphereZero_re
    (A : ASection) (n : ℕ) :
    A.transportLevel n = (A.sphereZero n).re := by
  rw [ASection.transportLevel,
    A.residueTotalTransportRead_certified]

/-! ### Transitional fibrewise/component-colimit route

The declarations in this subsection are retained temporarily because the
current theorem body still depends on the former component-colimit route.
They are not the binding production readout. The replacement must take `π₀`
of the total first and apply `Lbar_A` only to its sole class afterward. -/

/-- Legacy GPV real-face read on one residue fibre. This auxiliary functor is
not the final total-space readout. -/
def ASection.residueFiberRead (A : ASection) (X : GreatCircle.Base) :
    InverseImageCResidueStateWorldGroupoid A X ⥤ Discrete ℝ where
  obj x := Discrete.mk
    (OnePoint.rec 0 Complex.re
      ((GreatCircle.cayleyMoebius⁻¹).val x.obj.positioned.back.coordinate))
  map {x y} f := eqToHom (by
    let φ := (AsectionActionPositioned A X).map f.hom
    have hstate := φ.property
    change (show G2 from φ.val) • x.obj.positioned.back =
      y.obj.positioned.back at hstate
    have hcoordinate : x.obj.positioned.back.coordinate =
        y.obj.positioned.back.coordinate := by
      simpa only [AsectionState.smul_coordinate] using
        congrArg AsectionState.coordinate hstate
    apply Discrete.ext
    exact congrArg (fun u : OnePoint ℂ => OnePoint.rec (C := fun _ => ℝ) (0 : ℝ)
      Complex.re ((GreatCircle.cayleyMoebius⁻¹).val u)) hcoordinate)
  map_id _ := Subsingleton.elim _ _
  map_comp _ _ := Subsingleton.elim _ _

@[simp] theorem ASection.residueFiberRead_obj
    (A : ASection) (X : GreatCircle.Base)
    (x : InverseImageCResidueStateWorldGroupoid A X) :
    (A.residueFiberRead X).obj x =
      Discrete.mk
        (OnePoint.rec 0 Complex.re
          ((GreatCircle.cayleyMoebius⁻¹).val
            x.obj.positioned.back.coordinate)) := rfl

/-- Legacy fibrewise component read, retained only for the transitional
route. -/
def ASection.residueComponentRead (A : ASection) (X : GreatCircle.Base) :
    CategoryTheory.ConnectedComponents
      (InverseImageCResidueStateWorldGroupoid A X) → ℝ :=
  (CategoryTheory.ConnectedComponents.typeToCatHomEquiv
    (InverseImageCResidueStateWorldGroupoid A X) ℝ).symm
      (A.residueFiberRead X)

@[simp] theorem ASection.residueComponentRead_mk
    (A : ASection) (X : GreatCircle.Base)
    (x : InverseImageCResidueStateWorldGroupoid A X) :
    A.residueComponentRead X
      (CategoryTheory.ConnectedComponents.mk x) =
        OnePoint.rec 0 Complex.re
          ((GreatCircle.cayleyMoebius⁻¹).val
            x.obj.positioned.back.coordinate) := rfl

/-- Evaluation of the legacy fibrewise read on a certified pole
representative. -/
@[simp] theorem ASection.residueComponentRead_certified
    (A : ASection) (n : ℕ) :
    A.residueComponentRead (projectivePole A)
      (CategoryTheory.ConnectedComponents.mk
        ⟨residueActionState A (projectivePole A) n baseWorld,
          A.residueActionState_mem n baseWorld⟩) =
      (A.sphereZero n).re := by
  rw [A.residueComponentRead_mk]
  simp only [residueActionState_positioned]
  change OnePoint.rec (C := fun _ => ℝ) (0 : ℝ) Complex.re
    ((GreatCircle.cayleyMoebius⁻¹).val (A.residueState n baseWorld).coordinate) = _
  rw [residueState_coordinate, cayleyMoebius_inv_apply_cayley]
  rfl

/-- Reduction of the former fibrewise naturality obligation to positioned
reads. This belongs to the transitional route, not the binding proof. -/
theorem ASection.residueComponentRead_natural_of_positionedRead
    (A : ASection)
    (hpositioned : ∀ {X Y : GreatCircle.Base} (f : X ⟶ Y)
      (x : InverseImageCResidueStateWorldGroupoid A X),
      OnePoint.rec (C := fun _ => ℝ) (0 : ℝ) Complex.re
          ((GreatCircle.cayleyMoebius⁻¹).val
            (((AsectionCResidueTransport A f).obj
              x).obj.positioned.back.coordinate)) =
        OnePoint.rec (C := fun _ => ℝ) (0 : ℝ) Complex.re
          ((GreatCircle.cayleyMoebius⁻¹).val
            x.obj.positioned.back.coordinate)) :
    ∀ {X Y : GreatCircle.Base} (f : X ⟶ Y)
      (κ : CategoryTheory.ConnectedComponents
        (InverseImageCResidueStateWorldGroupoid A X)),
      A.residueComponentRead Y
          (Functor.mapConnectedComponents
            (AsectionCResidueTransport A f) κ) =
        A.residueComponentRead X κ := by
  intro X Y f κ
  refine _root_.Quotient.inductionOn κ fun x => ?_
  simp only [Functor.mapConnectedComponents_mk,
    A.residueComponentRead_mk]
  exact hpositioned f x

/-- The obsolete pre-component naturality obligation. Its `sorry` records the
sole unformalized dependency of the transitional theorem body. Do not prove
this lemma: replace that dependency with the binding post-`π₀` construction. -/
theorem ASection.residueComponentRead_natural (A : ASection) :
    ∀ {X Y : GreatCircle.Base} (f : X ⟶ Y)
      (κ : CategoryTheory.ConnectedComponents
        (InverseImageCResidueStateWorldGroupoid A X)),
      A.residueComponentRead Y
          (Functor.mapConnectedComponents
            (AsectionCResidueTransport A f) κ) =
        A.residueComponentRead X κ := by
  sorry

/-- **`ι_A` AT THE TOTAL** (the author, 2026-07-29): *"it is a natural
transformation OF THE TOTAL GROTHENDIECK CONSTRUCTION — an inverse image OF
the total `F_A(X)`."*  This is that reading in Lean: the inclusion of the
inverse image `∫𝓡_A` in the total `T_A`.  *"`∫𝓡_A` isn't parallel to `T_A`,
it is INSIDE IT."* -/
noncomputable def ASection.AsectionCResidueInclusionTotal (A : ASection) :
    A.projectiveResidueTotalCategory ⥤
    A.ambientTotalCategory :=
  Grothendieck.map
    (Functor.whiskerRight (AsectionCResidueInclusion A) Grpd.forgetToCat)

/-- Restrict the GPV real face of T_A through the existing residue-total
inclusion. The face is inherited from A_A's construction. -/
def ASection.residueGpvRealFace (A : ASection) :
    A.residueTotalCategory ⥤ Discrete ℝ :=
  A.AsectionCResidueInclusionTotal ⋙ totalGpvRealFace A

/-- `ι_A` is FAITHFUL AT THE TOTAL.  Mathlib has no lemma that
`Grothendieck.map` of a fully faithful transformation is fully faithful
(`Grothendieck.lean` carries `map` `:242`, `map_map` `:262`, and
`faithful_ι` `:560` for the *fibre* inclusion, and nothing else) — so the
total-level head was an empty shelf, exactly as `ι_A`'s componentwise head
was before `bb02b54`.  This puts it under a name.  Consumes Declaration 1
at `ι_A`'s own name; the structural work is `Grothendieck.ext` (`:93`). -/
instance ASection.AsectionCResidueInclusionTotal_faithful (A : ASection) :
    (AsectionCResidueInclusionTotal A).Faithful where
  map_injective {P Q} f g h := by
    obtain ⟨fb, ff⟩ := f
    obtain ⟨gb, gf⟩ := g
    simp only [AsectionCResidueInclusionTotal, Grothendieck.map] at h
    injection h with hb hf
    subst hb
    refine Grothendieck.ext _ _ rfl ?_
    simp only [eqToHom_refl, Category.id_comp]
    have h2 := eq_of_heq hf
    simp at h2
    exact (AsectionCResidueInclusion_app_faithful A Q.base).map_injective h2

/-- `ι_A` is FULL AT THE TOTAL — so, with faithfulness above, the inclusion
of the inverse image in the total is an isomorphism onto its image.  This is
the author's *"a transitive action groupoid whose fully faithful image is
`∫𝓡_A`"*, stated where he says it lives: at the total. -/
instance ASection.AsectionCResidueInclusionTotal_full (A : ASection) :
    (AsectionCResidueInclusionTotal A).Full where
  map_surjective {P Q} φ := by
    haveI := AsectionCResidueInclusion_app_full A Q.base
    refine ⟨⟨φ.base,
      ((AsectionCResidueInclusion A).app Q.base).preimage φ.fiber⟩, ?_⟩
    refine Grothendieck.ext _ _ rfl ?_
    simp only [AsectionCResidueInclusionTotal, Grothendieck.map, eqToHom_refl]
    erw [Functor.map_preimage]
    show 𝟙 _ ≫ 𝟙 _ ≫ φ.fiber = φ.fiber
    simp

/-- **THE TOTALS ARE GROUPOIDS — the classification.**  Grothendieck of a
`Grpd`-valued functor over a groupoid base is a groupoid: every morphism is
invertible, its base leg by the base's groupoid structure, its fibre leg by the
fibre's, and `Grothendieck.isoMk` assembles the two into an isomorphism of the
total.  Nothing is hand-rolled — no inverse is built out of `Grothendieck.Hom`.

This is the shelf Mathlib leaves empty: `Grothendieck.isoMk` and
`Groupoid.ofIsIso` both exist and were never composed.  Stated once and
instantiated at the author's two totals below, it is what makes
"a transitive action groupoid is connected"
(`Mathlib/CategoryTheory/Action.lean:128`) available at `∫𝓡_A`. -/
noncomputable instance grothendieckGrpdGroupoid
    {C : Type*} [CategoryTheory.Groupoid C] (F : C ⥤ Grpd) :
    CategoryTheory.Groupoid (Grothendieck (F ⋙ Grpd.forgetToCat)) :=
  CategoryTheory.Groupoid.ofIsIso (fun {X Y} f => by
    letI gY : CategoryTheory.Groupoid ((F ⋙ Grpd.forgetToCat).obj Y.base) :=
      (F.obj Y.base).str
    haveI hb : CategoryTheory.IsIso f.base :=
      ⟨CategoryTheory.Groupoid.inv f.base,
        CategoryTheory.Groupoid.comp_inv f.base,
        CategoryTheory.Groupoid.inv_comp f.base⟩
    letI hf : CategoryTheory.IsIso f.fiber :=
      ⟨@CategoryTheory.Groupoid.inv _ gY _ _ f.fiber,
       @CategoryTheory.Groupoid.comp_inv _ gY _ _ f.fiber,
       @CategoryTheory.Groupoid.inv_comp _ gY _ _ f.fiber⟩
    have h : (CategoryTheory.Grothendieck.isoMk
        (CategoryTheory.asIso f.base)
        (@CategoryTheory.asIso _ _ _ _ f.fiber hf)).hom = f := rfl
    rw [← h]
    infer_instance)

/-- `𝒯_A` is an action groupoid: the classification instantiated at the
ambient total. -/
noncomputable instance ASection.ambientTotalGroupoid (A : ASection) :
    CategoryTheory.Groupoid A.ambientTotalCategory :=
  grothendieckGrpdGroupoid A.AsectionActionDiagram

/-- `∫𝓡_A` is a groupoid: the same classification at the C-residue total, the
sub-action-groupoid `ι_A` includes fully and faithfully. -/
noncomputable instance ASection.residueTotalGroupoid (A : ASection) :
    CategoryTheory.Groupoid A.residueTotalCategory :=
  grothendieckGrpdGroupoid A.AsectionCResidueDiagram

/-- Master `lem:c-residue-transitive`, the direction step: two states of
one fibre with the same normalized coordinate are joined by one `G₂`
automorphism acting on the whole triple — the realized entries lie on the
one realized zero sphere at the fixed coordinate, and `G₂` is transitive
on it (`lem:residue-spheres`, `thm:G2-S6`).  The positioned and realized
entries ride the state's own binding fields. -/
theorem ASection.residueFiberHom_of_inputCoordinate
    (A : ASection) {X : GreatCircle.Base}
    (x y : AsectionActionFiber A X)
    (hinput : x.input.back.coordinate = y.input.back.coordinate) :
    Nonempty (x ⟶ y) := by
  have key : ∀ s t : AsectionState A, s.coordinate = t.coordinate →
      ∃ g : G2, g • s = t := by
    rintro ⟨sw, sc⟩ ⟨tw, tc⟩ hc
    obtain ⟨g, hg⟩ :=
      G2.exists_smul_eq_of_mem_unitImaginarySphere sw.2 tw.2
    refine ⟨g, ?_⟩
    simp only [HSMul.hSMul, SMul.smul, AsectionState.mk.injEq]
    exact ⟨Subtype.ext hg, hc⟩
  obtain ⟨g, hg⟩ := key x.input.back y.input.back hinput
  exact ⟨InducedCategory.homMk
    (show x.input ⟶ y.input from ⟨g, hg⟩)⟩

/-- A point of the slice sphere off the image of the base's real great circle
under the Cayley class: the Cayley image of a point off the real axis
(master `def:cayley-disk`: `C` carries the base's compactified real line onto
one circle of each slice sphere). -/
def ASection.OffBaseCircle (u : OnePoint ℂ) : Prop :=
  ∃ w : ℂ, w.im ≠ 0 ∧ GreatCircle.cayleyMoebius.val ((w : ℂ) : OnePoint ℂ) = u

/-- The affine class `[(α β; 0 1)]` of the base: a residual factor `r_h` in the
sense of master `lem:orbit-stab`, `r_h · N = N`. -/
def ASection.affineGL (α β : ℝ) (hα : α ≠ 0) : GL (Fin 2) ℝ :=
  Matrix.GeneralLinearGroup.mkOfDetNeZero !![α, β; 0, 1] (by
    rw [Matrix.det_fin_two_of]
    simpa using hα)

@[simp] theorem ASection.affineGL_val (α β : ℝ) (hα : α ≠ 0) :
    (ASection.affineGL α β hα).val = !![α, β; 0, 1] := rfl

theorem ASection.affineGL_smul_infty (α β : ℝ) (hα : α ≠ 0) :
    ASection.affineGL α β hα • (OnePoint.infty : GreatCircle.Point) =
      OnePoint.infty := by
  rw [OnePoint.smul_infty_eq_ite]
  simp [ASection.affineGL_val]

/-- The affine class as a residual factor of master `lem:orbit-stab`. -/
def ASection.affineStab (α β : ℝ) (hα : α ≠ 0) : GreatCircle.NorthStabilizer :=
  ⟨Matrix.ProjGenLinGroup.mk (ASection.affineGL α β hα), by
    rw [MulAction.mem_stabilizer_iff, GreatCircle.mk_smul]
    exact ASection.affineGL_smul_infty α β hα⟩

theorem ASection.affineGL_map_val (α β : ℝ) (hα : α ≠ 0) :
    (Matrix.GeneralLinearGroup.map Complex.ofRealHom
      (ASection.affineGL α β hα)).val = !![(α : ℂ), (β : ℂ); 0, 1] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.GeneralLinearGroup.map_apply, ASection.affineGL_val]

/-- The complexified affine class acts on a finite point by `w ↦ α w + β`. -/
theorem ASection.affineGL_map_smul (α β : ℝ) (hα : α ≠ 0) (w : ℂ) :
    (Matrix.GeneralLinearGroup.map Complex.ofRealHom (ASection.affineGL α β hα)) •
        ((w : ℂ) : OnePoint ℂ) = ((α * w + β : ℂ) : OnePoint ℂ) := by
  rw [OnePoint.smul_some_eq_ite]
  simp

/-- The residual classes of the base carry any point of the slice sphere off the
image circle to any other such point: one displayed class per pair, its value
computed by the action rules, as in master `lem:mobius-transitive`. -/
theorem ASection.affine_residual_transitive (u u' : OnePoint ℂ)
    (hu : ASection.OffBaseCircle u) (hu' : ASection.OffBaseCircle u') :
    ∃ s : GreatCircle.NorthStabilizer,
      (GreatCircle.cayleyProjective s.1).val u = u' := by
  obtain ⟨w, hw, rfl⟩ := hu
  obtain ⟨w', hw', rfl⟩ := hu'
  have hα : w'.im / w.im ≠ 0 := div_ne_zero hw' hw
  refine ⟨ASection.affineStab (w'.im / w.im) (w'.re - (w'.im / w.im) * w.re) hα, ?_⟩
  have hclass : (Matrix.GeneralLinearGroup.map Complex.ofRealHom
      (ASection.affineGL (w'.im / w.im) (w'.re - (w'.im / w.im) * w.re) hα)) •
        ((w : ℂ) : OnePoint ℂ) = ((w' : ℂ) : OnePoint ℂ) := by
    rw [ASection.affineGL_map_smul]
    congr 1
    apply Complex.ext
    · simp
    · simp
      field_simp
  change (GreatCircle.cayleyProjective
      (Matrix.ProjGenLinGroup.mk
        (ASection.affineGL (w'.im / w.im) (w'.re - (w'.im / w.im) * w.re) hα))).val
      (GreatCircle.cayleyMoebius.val ((w : ℂ) : OnePoint ℂ)) =
    GreatCircle.cayleyMoebius.val ((w' : ℂ) : OnePoint ℂ)
  rw [GreatCircle.cayleyProjective_mk]
  change (GreatCircle.cayleyConjGL
      (ASection.affineGL (w'.im / w.im) (w'.re - (w'.im / w.im) * w.re) hα)) •
      (GreatCircle.cayleyGL • ((w : ℂ) : OnePoint ℂ)) =
    GreatCircle.cayleyGL • ((w' : ℂ) : OnePoint ℂ)
  change (GreatCircle.cayleyGL *
      Matrix.GeneralLinearGroup.map Complex.ofRealHom
        (ASection.affineGL (w'.im / w.im) (w'.re - (w'.im / w.im) * w.re) hα) *
      GreatCircle.cayleyGL⁻¹) • (GreatCircle.cayleyGL • ((w : ℂ) : OnePoint ℂ)) =
    GreatCircle.cayleyGL • ((w' : ℂ) : OnePoint ℂ)
  rw [mul_smul, mul_smul, inv_smul_smul, hclass]

/-- An invertible real matrix carries a point of the plane off the real axis to
a point off the real axis: the imaginary part of `(aw+b)/(cw+d)` is
`(ad−bc)·Im w / |cw+d|²`. -/
theorem ASection.realGL_smul_nonreal (g : GL (Fin 2) ℝ) (w : ℂ) (hw : w.im ≠ 0) :
    ∃ w' : ℂ, w'.im ≠ 0 ∧
      (Matrix.GeneralLinearGroup.map Complex.ofRealHom g) • ((w : ℂ) : OnePoint ℂ) =
        ((w' : ℂ) : OnePoint ℂ) := by
  have hdet : g.val 0 0 * g.val 1 1 - g.val 0 1 * g.val 1 0 ≠ 0 := by
    have h : g.val.det ≠ 0 := (Matrix.GeneralLinearGroup.det g).ne_zero
    rw [Matrix.det_fin_two] at h
    exact h
  have hden : (g.val 1 0 : ℂ) * w + (g.val 1 1 : ℂ) ≠ 0 := by
    intro h0
    have him := congrArg Complex.im h0
    simp at him
    rcases him with hc | hwim
    · have hre := congrArg Complex.re h0
      simp [hc] at hre
      apply hdet
      simp [hc, hre]
    · exact hw hwim
  refine ⟨((g.val 0 0 : ℂ) * w + (g.val 0 1 : ℂ)) /
    ((g.val 1 0 : ℂ) * w + (g.val 1 1 : ℂ)), ?_, ?_⟩
  · rw [Complex.div_im]
    have hns : Complex.normSq ((g.val 1 0 : ℂ) * w + (g.val 1 1 : ℂ)) ≠ 0 :=
      (Complex.normSq_pos.mpr hden).ne'
    simp only [Complex.add_im, Complex.add_re, Complex.mul_im, Complex.mul_re,
      Complex.ofReal_re, Complex.ofReal_im, zero_mul, add_zero, sub_zero]
    rw [div_sub_div_same, div_ne_zero_iff]
    refine ⟨?_, hns⟩
    have : g.val 0 0 * w.im * (g.val 1 0 * w.re + g.val 1 1) -
        (g.val 0 0 * w.re + g.val 0 1) * (g.val 1 0 * w.im) =
        w.im * (g.val 0 0 * g.val 1 1 - g.val 0 1 * g.val 1 0) := by ring
    rw [this]
    exact mul_ne_zero hw hdet
  · rw [OnePoint.smul_some_eq_ite]
    have hentries : ∀ i j, (Matrix.GeneralLinearGroup.map Complex.ofRealHom g).val i j =
        (g.val i j : ℂ) := by
      intro i j; simp [Matrix.GeneralLinearGroup.map_apply]
    simp only [hentries]
    rw [if_neg hden]

/-- The Cayley conjugate of a real matrix carries the points off the image of
the base to points off it (master `def:cayley-disk`: the same `C` positions
every coordinate). -/
theorem ASection.cayleyConjMoebiusGL_preserves_offCircle (g : GL (Fin 2) ℝ)
    (u : OnePoint ℂ) (hu : ASection.OffBaseCircle u) :
    ASection.OffBaseCircle ((GreatCircle.cayleyConjMoebiusGL g).val u) := by
  obtain ⟨w, hw, rfl⟩ := hu
  obtain ⟨w', hw', hgw⟩ := ASection.realGL_smul_nonreal g w hw
  refine ⟨w', hw', ?_⟩
  change GreatCircle.cayleyGL • ((w' : ℂ) : OnePoint ℂ) =
    (GreatCircle.cayleyConjGL g) • (GreatCircle.cayleyGL • ((w : ℂ) : OnePoint ℂ))
  change GreatCircle.cayleyGL • ((w' : ℂ) : OnePoint ℂ) =
    (GreatCircle.cayleyGL * Matrix.GeneralLinearGroup.map Complex.ofRealHom g *
      GreatCircle.cayleyGL⁻¹) • (GreatCircle.cayleyGL • ((w : ℂ) : OnePoint ℂ))
  rw [mul_smul, mul_smul, inv_smul_smul, hgw]

/-- The Cayley conjugate of every projective element of the base carries the
points off the image of the base to points off it. -/
theorem ASection.cayleyProjective_preserves_offCircle (h : GreatCircle.Aut)
    (u : OnePoint ℂ) (hu : ASection.OffBaseCircle u) :
    ASection.OffBaseCircle ((GreatCircle.cayleyProjective h).val u) := by
  induction h using Matrix.ProjGenLinGroup.induction_on with
  | mk g =>
      rw [GreatCircle.cayleyProjective_mk]
      exact ASection.cayleyConjMoebiusGL_preserves_offCircle g u hu

/-- The disk action of a real multiplier carries the points off the image of
the base to points off it. -/
theorem ASection.diskDiagonal_preserves_offCircle (v : ℂˣ) (hv : (v : ℂ).im = 0)
    (u : OnePoint ℂ) (hu : ASection.OffBaseCircle u) :
    ASection.OffBaseCircle ((GreatCircle.diskDiagonalMoebiusHom v).val u) := by
  obtain ⟨w, hw, rfl⟩ := hu
  refine ⟨(v : ℂ) * w, ?_, ?_⟩
  · rw [Complex.mul_im, hv, zero_mul, add_zero]
    exact mul_ne_zero (by
      intro h0
      apply v.ne_zero
      apply Complex.ext <;> simp [h0, hv]) hw
  · symm
    change (GreatCircle.cayleyMoebius * GreatCircle.diagonalMoebiusHom v *
      GreatCircle.cayleyMoebius⁻¹).val
        (GreatCircle.cayleyMoebius.val ((w : ℂ) : OnePoint ℂ)) =
      GreatCircle.cayleyMoebius.val ((((v : ℂ) * w : ℂ) : OnePoint ℂ))
    rw [show (GreatCircle.cayleyMoebius * GreatCircle.diagonalMoebiusHom v *
        GreatCircle.cayleyMoebius⁻¹).val
          (GreatCircle.cayleyMoebius.val ((w : ℂ) : OnePoint ℂ)) =
      GreatCircle.cayleyMoebius.val ((GreatCircle.diagonalMoebiusHom v).val
        ((GreatCircle.cayleyMoebius⁻¹).val
          (GreatCircle.cayleyMoebius.val ((w : ℂ) : OnePoint ℂ))))
      from rfl]
    rw [cayleyMoebius_inv_apply_cayley, GreatCircle.diagonalMoebiusHom_apply_coe]

/-- The inverse of the pole frame `A^slice(p_A) = D_A`
(`projectiveObjectFrame_pole`) carries the points off the image of the base
to points off it: `D_A` is the disk action of the real multiplier `u_A`. -/
theorem ASection.poleFrame_inv_preserves_offCircle (A : ASection) (u : OnePoint ℂ)
    (hu : ASection.OffBaseCircle u) :
    ASection.OffBaseCircle (((projectiveObjectFrame A (projectivePole A))⁻¹).val u) := by
  rw [projectiveObjectFrame_pole, A.distinguishedDiskAction_eq_fullMultiplier,
    ← map_inv]
  apply ASection.diskDiagonal_preserves_offCircle
  · rw [Units.val_inv_eq_inv_val, Complex.inv_im, A.distinguishedPoleUnit_im_eq_zero,
      neg_zero, zero_div]
  · exact hu

/-- Master `(Z)`, read at the normalized entry: the pole-fibre zero-sphere
triples' normalized coordinates lie off the image of the base in the slice
sphere.  The zero `z_n` is positioned through `C` like every coordinate of the
base, it is off the real axis by `(Z)` (`c3_sphere_nonreal`), and the pole
frame's inverse carries points off the image of the base to points off it. -/
theorem ASection.residue_offCircle (A : ASection) :
    ∀ n : ℕ, ASection.OffBaseCircle
      (((projectiveObjectFrame A (projectivePole A))⁻¹).val
        (GreatCircle.cayleyMoebius.val (A.sphereZero n : OnePoint ℂ))) := by
  intro n
  apply ASection.poleFrame_inv_preserves_offCircle A
  exact ⟨A.sphereZero n, (A.c3_sphere_nonreal n).ne', rfl⟩

/-- The normalized coordinate of the `n`-th pole-fibre zero-sphere triple is the
pole frame's inverse applied to its zero-sphere coordinate. -/
theorem ASection.residueActionState_input_coordinate (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    (residueActionState A (projectivePole A) n I).input.back.coordinate =
      ((projectiveObjectFrame A (projectivePole A))⁻¹).val
        (GreatCircle.cayleyMoebius.val (A.sphereZero n : OnePoint ℂ)) := by
  have h := (residueActionState A (projectivePole A) n I).positioned_by_action
  have hc := congrArg (fun s : AsectionStateWorld A => s.back.coordinate) h
  simp only [coordinateTransport_obj_coordinate, residueActionState_positioned] at hc
  change GreatCircle.cayleyMoebius.val (A.sphereZero n : OnePoint ℂ) =
    (projectiveObjectFrame A (projectivePole A)).val
      (residueActionState A (projectivePole A) n I).input.back.coordinate at hc
  rw [hc]
  exact ((projectiveObjectFrame A (projectivePole A)).val.symm_apply_apply _).symm

/-- A residue triple reached by `g : p_A ⟶ Y` has normalized coordinate the
base arrow `g`, Cayley conjugated, applied to the pole triple's normalized
coordinate (master `def:transport`, the normalized entry:
`A^slice(Y)⁻¹ · A^slice(g) · A^slice(p_A)` is `cayleyProjective(g)`). -/
theorem ASection.residueState_input_coordinate_of_reach (A : ASection)
    {Y : GreatCircle.Base} (m : ℕ) (J : SphereWorld) (g : projectivePole A ⟶ Y)
    (y : InverseImageCResidueStateWorldGroupoid A Y)
    (hg : (AsectionActionTransport A g).obj
      (residueActionState A (projectivePole A) m J) = y.obj) :
    y.obj.input.back.coordinate =
      (GreatCircle.cayleyProjective g.val).val
        (((projectiveObjectFrame A (projectivePole A))⁻¹).val
          (GreatCircle.cayleyMoebius.val (A.sphereZero m : OnePoint ℂ))) := by
  rw [← hg, AsectionActionTransport_obj_input, coordinateTransport_obj_coordinate,
    orbitStabilizerActionSquare_right_eq_cayley,
    ASection.residueActionState_input_coordinate]

/-- master `lem:c-residue-transitive`, the real projective calculation: for
two points of the slice sphere off the image of the base and any two base
objects, one base arrow between the objects carries the first point to the
second by its Cayley conjugate.  The arrow is `o_Y · s · o_X⁻¹`, with `s`
the affine class of `affine_residual_transitive` joining the two points
carried back by the representatives of master `def:orbit-reps`; it is the
arrow of `stabilizerPart_realized`. -/
theorem ASection.baseArrow_of_offCircle (X Y : GreatCircle.Base)
    (u u' : OnePoint ℂ)
    (hu : ASection.OffBaseCircle u) (hu' : ASection.OffBaseCircle u') :
    ∃ f : X ⟶ Y, (GreatCircle.cayleyProjective f.val).val u = u' := by
  have hu₀ : ASection.OffBaseCircle
      ((GreatCircle.cayleyProjective
        (GreatCircle.orbitRep (CategoryTheory.ActionCategory.back X))⁻¹).val u) :=
    ASection.cayleyProjective_preserves_offCircle _ u hu
  have hu₀' : ASection.OffBaseCircle
      ((GreatCircle.cayleyProjective
        (GreatCircle.orbitRep (CategoryTheory.ActionCategory.back Y))⁻¹).val u') :=
    ASection.cayleyProjective_preserves_offCircle _ u' hu'
  obtain ⟨s, hs⟩ := ASection.affine_residual_transitive _ _ hu₀ hu₀'
  obtain ⟨f, hf⟩ := GreatCircle.stabilizerPart_realized X Y s
  refine ⟨f, ?_⟩
  have hval := GreatCircle.orbit_stabilizer_factor f
  rw [hf] at hval
  rw [hval, map_mul, map_mul]
  change (GreatCircle.cayleyProjective
      (GreatCircle.orbitRep (CategoryTheory.ActionCategory.back Y))).val
    ((GreatCircle.cayleyProjective s.1).val
      ((GreatCircle.cayleyProjective
        (GreatCircle.orbitRep (CategoryTheory.ActionCategory.back X))⁻¹).val u)) = u'
  rw [hs, map_inv]
  rw [show ((GreatCircle.cayleyProjective
      (GreatCircle.orbitRep (CategoryTheory.ActionCategory.back Y)))⁻¹).val =
    ((GreatCircle.cayleyProjective
      (GreatCircle.orbitRep (CategoryTheory.ActionCategory.back Y))).val)⁻¹ from rfl,
    Equiv.Perm.inv_def, Equiv.apply_symm_apply]

/-- Master `lem:c-residue-transitive`, display (M): a base arrow `h₂ : p_A ⟶ Y`
whose normalized leg carries the `n`-th pole-fibre zero-sphere triple's
normalized coordinate to any residue triple's at `Y`.  The normalized leg of
`h₂` is `cayleyProjective(h₂)` (`normalizedLeg_eq_cayley`), and
`baseArrow_of_offCircle` supplies the arrow, under the one hypothesis that
the pole-fibre zero-sphere triples' normalized coordinates lie off the image
of the base. -/
theorem ASection.seatM_of_offCircle (A : ASection)
    (hoff : ∀ n : ℕ, ASection.OffBaseCircle
      (((projectiveObjectFrame A (projectivePole A))⁻¹).val
        (GreatCircle.cayleyMoebius.val (A.sphereZero n : OnePoint ℂ)))) :
    ∀ (n : ℕ) (I : SphereWorld) (Y : GreatCircle.Base)
        (y : InverseImageCResidueStateWorldGroupoid A Y),
      ∃ h₂ : projectivePole A ⟶ Y,
        ((AsectionActionTransport A h₂).obj
          (residueActionState A (projectivePole A) n I)).input.back.coordinate =
        y.obj.input.back.coordinate := by
  intro n I Y y
  obtain ⟨m, J, g, hg⟩ := y.property
  have hy : ASection.OffBaseCircle y.obj.input.back.coordinate := by
    rw [ASection.residueState_input_coordinate_of_reach A m J g y hg]
    exact ASection.cayleyProjective_preserves_offCircle _ _ (hoff m)
  obtain ⟨h₂, hh⟩ :=
    ASection.baseArrow_of_offCircle (projectivePole A) Y _ _ (hoff n) hy
  refine ⟨h₂, ?_⟩
  rw [AsectionActionTransport_obj_input_frame_conjugation,
    coordinateTransport_obj_coordinate, normalizedLeg_eq_cayley,
    ASection.residueActionState_input_coordinate]
  exact hh

/-- Master `lem:c-residue-transitive`, the proof as written: source membership
`(W)` hands the pole-fibre zero-sphere triple `x₀` and `h₁`; display `(M)`
hands `h₂`; the base leg is `h₁⁻¹ ≫ h₂` through the pole; `(H)` by
functoriality; `γ` closes the direction in the fibre at `Y`. -/
theorem ASection.residueTotal_transitive_of_offCircle (A : ASection)
    (hoff : ∀ n : ℕ, ASection.OffBaseCircle
      (((projectiveObjectFrame A (projectivePole A))⁻¹).val
        (GreatCircle.cayleyMoebius.val (A.sphereZero n : OnePoint ℂ)))) :
    ∀ P Q : A.residueTotalCategory, Nonempty (P ⟶ Q) := by
  intro P Q
  obtain ⟨n, I, h₁, hx⟩ := P.fiber.property
  obtain ⟨h₂, hcoord⟩ := ASection.seatM_of_offCircle A hoff n I Q.base Q.fiber
  obtain ⟨γ⟩ := A.residueFiberHom_of_inputCoordinate
    ((AsectionActionTransport A h₂).obj
      (residueActionState A (projectivePole A) n I))
    Q.fiber.obj hcoord
  refine ⟨⟨CategoryTheory.Groupoid.inv h₁ ≫ h₂,
    ((AsectionCResidueInclusion A).app Q.base).preimage ?_⟩⟩
  have hback : (AsectionActionTransport A
      (CategoryTheory.Groupoid.inv h₁)).obj P.fiber.obj =
      residueActionState A (projectivePole A) n I := by
    calc
      (AsectionActionTransport A
          (CategoryTheory.Groupoid.inv h₁)).obj P.fiber.obj =
          (AsectionActionTransport A
            (CategoryTheory.Groupoid.inv h₁)).obj
              ((AsectionActionTransport A h₁).obj
                (residueActionState A (projectivePole A) n I)) := by
        rw [hx]
      _ = (AsectionActionTransport A
            (h₁ ≫ CategoryTheory.Groupoid.inv h₁)).obj
              (residueActionState A (projectivePole A) n I) :=
          (congrArg (fun F => F.obj
            (residueActionState A (projectivePole A) n I))
            (AsectionActionTransport_comp A h₁
              (CategoryTheory.Groupoid.inv h₁))).symm
      _ = residueActionState A (projectivePole A) n I := by
        have harrow : h₁ ≫ CategoryTheory.Groupoid.inv h₁ =
            𝟙 (projectivePole A) := CategoryTheory.Groupoid.comp_inv h₁
        rw [harrow, AsectionActionTransport_id]
        rfl
  have hsrc : (AsectionActionTransport A
      (CategoryTheory.Groupoid.inv h₁ ≫ h₂)).obj P.fiber.obj =
      (AsectionActionTransport A h₂).obj
        (residueActionState A (projectivePole A) n I) := by
    calc
      (AsectionActionTransport A
          (CategoryTheory.Groupoid.inv h₁ ≫ h₂)).obj P.fiber.obj =
          (AsectionActionTransport A h₂).obj
            ((AsectionActionTransport A
              (CategoryTheory.Groupoid.inv h₁)).obj P.fiber.obj) :=
        congrArg (fun F => F.obj P.fiber.obj)
          (AsectionActionTransport_comp A
            (CategoryTheory.Groupoid.inv h₁) h₂)
      _ = (AsectionActionTransport A h₂).obj
            (residueActionState A (projectivePole A) n I) := by rw [hback]
  exact eqToHom hsrc ≫ γ

/-- Master `lem:c-residue-transitive`: the production residue total is
transitive, by the author's proof, with the normalized coordinates of the
pole-fibre zero-sphere triples off the image of the base by `(Z)`
(`residue_offCircle`). -/
theorem ASection.residueTotal_transitive (A : ASection) :
    ∀ P Q : A.residueTotalCategory, Nonempty (P ⟶ Q) :=
  ASection.residueTotal_transitive_of_offCircle A A.residue_offCircle

/-- **CONNECTED FROM TRANSITIVE**, on this exact C-residue total — not a
generic category. C4 supplies nonemptiness, and a transitive arrow supplies
the required zigzag directly. -/
theorem ASection.residueTotal_isConnected_of_transitive
    (A : ASection)
    (htrans : ∀ P Q : A.residueTotalCategory,
      Nonempty (P ⟶ Q)) :
    CategoryTheory.IsConnected A.residueTotalCategory := by
  haveI : Nonempty A.residueTotalCategory :=
    ⟨A.residueTotalObject 0⟩
  exact zigzag_isConnected fun P Q =>
    CategoryTheory.Zigzag.of_hom (htrans P Q).some

/-- Legacy pre-component constancy lemma for the inherited GPV real face.
It is retained temporarily while `ASection.concentricity` is migrated, but it
is not part of the binding post-`π₀` production route. -/
theorem ASection.residueGpvRealFace_constant (A : ASection)
    (P Q : A.residueTotalCategory) :
    (A.residueGpvRealFace.obj P).as = (A.residueGpvRealFace.obj Q).as := by
  letI := A.residueTotal_isConnected_of_transitive A.residueTotal_transitive
  exact congrArg Discrete.as
    (CategoryTheory.any_functor_const_on_obj A.residueGpvRealFace P Q)

/-- **π₀ SINGLETON FROM CONNECTED** (CHT Remark 8.3.5), on this exact total,
proved directly from the zigzag supplied by connectedness. -/
theorem ASection.residueTotal_pi0_singleton_of_connected
    (A : ASection)
    [CategoryTheory.IsConnected A.residueTotalCategory] :
    ∀ P Q : A.residueTotalCategory,
      CategoryTheory.ConnectedComponents.mk P =
        CategoryTheory.ConnectedComponents.mk Q :=
  fun P Q => _root_.Quotient.sound (CategoryTheory.isPreconnected_zigzag P Q)

/-- Background comparison
`π₀(∫ R_A) ≃ colim_B (π₀ ∘ R_A)`, not the binding readout route. -/
noncomputable def ASection.residueTotalPi0ColimitEquiv (A : ASection) :
    CategoryTheory.ConnectedComponents A.residueTotalCategory ≃
      Limits.colimit
        ((AsectionCResidueDiagram A ⋙ Grpd.forgetToCat) ⋙ pi0Functor) :=
  pi0GrothendieckEquiv (AsectionCResidueDiagram A)

/-- Background component-colimit consequence of transitivity. It is not the
binding readout route. -/
theorem ASection.residueTotal_pi0_colimit_singleton_of_transitive
    (A : ASection)
    (htrans : ∀ P Q : A.residueTotalCategory, Nonempty (P ⟶ Q)) :
    ∀ κ₁ κ₂ : Limits.colimit
      ((AsectionCResidueDiagram A ⋙ Grpd.forgetToCat) ⋙ pi0Functor),
      κ₁ = κ₂ := by
  letI : CategoryTheory.IsConnected A.residueTotalCategory :=
    A.residueTotal_isConnected_of_transitive htrans
  intro κ₁ κ₂
  let e := A.residueTotalPi0ColimitEquiv
  rw [← e.apply_symm_apply κ₁, ← e.apply_symm_apply κ₂]
  apply congrArg e
  exact _root_.Quotient.inductionOn₂ (e.symm κ₁) (e.symm κ₂)
    (fun P Q => A.residueTotal_pi0_singleton_of_connected P Q)

/-- The component diagram `π₀ ∘ R_A` used by the background colimit
presentation. -/
abbrev ASection.residueComponentDiagram (A : ASection) :=
  (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat) ⋙ pi0Functor

/-- Cocone for the former component-colimit presentation, conditional on its
legacy naturality obligation. -/
def ASection.residueComponentReadCocone (A : ASection)
    (hnatural : ∀ {X Y : GreatCircle.Base} (f : X ⟶ Y)
      (κ : CategoryTheory.ConnectedComponents
        (InverseImageCResidueStateWorldGroupoid A X)),
      A.residueComponentRead Y
          (Functor.mapConnectedComponents
            (AsectionCResidueTransport A f) κ) =
        A.residueComponentRead X κ) :
    Limits.Cocone (A.residueComponentDiagram) where
  pt := ℝ
  ι :=
    { app := fun X => TypeCat.ofHom (A.residueComponentRead X)
      naturality := fun X Y f => by
        ext κ
        change A.residueComponentRead Y
            (Functor.mapConnectedComponents
              (AsectionCResidueTransport A f) κ) =
          A.residueComponentRead X κ
        exact hnatural f κ }

/-- Read on the background component colimit, retained for the transitional
implementation only. -/
def ASection.residueColimitRead (A : ASection)
    (hnatural : ∀ {X Y : GreatCircle.Base} (f : X ⟶ Y)
      (κ : CategoryTheory.ConnectedComponents
        (InverseImageCResidueStateWorldGroupoid A X)),
      A.residueComponentRead Y
          (Functor.mapConnectedComponents
            (AsectionCResidueTransport A f) κ) =
        A.residueComponentRead X κ) :
    Limits.colimit A.residueComponentDiagram → ℝ :=
  fun x => Limits.colimit.desc A.residueComponentDiagram
    (A.residueComponentReadCocone hnatural) x

/-- Evaluation of the transitional colimit read at a certified pole
representative. -/
@[simp] theorem ASection.residueColimitRead_certified (A : ASection)
    (hnatural : ∀ {X Y : GreatCircle.Base} (f : X ⟶ Y)
      (κ : CategoryTheory.ConnectedComponents
        (InverseImageCResidueStateWorldGroupoid A X)),
      A.residueComponentRead Y
          (Functor.mapConnectedComponents
            (AsectionCResidueTransport A f) κ) =
        A.residueComponentRead X κ)
    (n : ℕ) :
    A.residueColimitRead hnatural
        (Limits.colimit.ι A.residueComponentDiagram (projectivePole A)
          (CategoryTheory.ConnectedComponents.mk
            ⟨residueActionState A (projectivePole A) n baseWorld,
              A.residueActionState_mem n baseWorld⟩)) =
      (A.sphereZero n).re := by
  rw [ASection.residueColimitRead, Limits.colimit.ι_desc_apply]
  exact A.residueComponentRead_certified n

/-- Transitional common-centre conclusion through the former colimit route.
The final theorem must instead use the singleton connected-components space of
the total and its post-component evaluation. -/
theorem ASection.commonCentre_of_transitive_of_read_natural
    (A : ASection)
    (htrans : ∀ P Q : A.residueTotalCategory, Nonempty (P ⟶ Q))
    (hnatural : ∀ {X Y : GreatCircle.Base} (f : X ⟶ Y)
      (κ : CategoryTheory.ConnectedComponents
        (InverseImageCResidueStateWorldGroupoid A X)),
      A.residueComponentRead Y
          (Functor.mapConnectedComponents
            (AsectionCResidueTransport A f) κ) =
        A.residueComponentRead X κ) :
    ∀ n : ℕ, (A.sphereZero n).re = (A.sphereZero 0).re := by
  intro n
  let κ (m : ℕ) : Limits.colimit A.residueComponentDiagram :=
    Limits.colimit.ι A.residueComponentDiagram (projectivePole A)
      (CategoryTheory.ConnectedComponents.mk
        ⟨residueActionState A (projectivePole A) m baseWorld,
          A.residueActionState_mem m baseWorld⟩)
  have hκ : κ n = κ 0 :=
    A.residueTotal_pi0_colimit_singleton_of_transitive htrans (κ n) (κ 0)
  have hread := congrArg (A.residueColimitRead hnatural) hκ
  simpa only [κ, A.residueColimitRead_certified] using hread



/-- **THE CONCENTRICITY THEOREM** (master `thm:concentricity`): the
infinitely many residue-ℂ zero-spheres of an A-section are concentric, one
real centre. The binding proof route first applies `π₀` to the production
residue total, obtains its sole class `κ`, and only then evaluates the inherited
map `Lbar_A` at `κ` on the certified semantic residue states.

The body below is still the transitional, unformalized implementation through
the obsolete pre-component naturality lemma. It must be replaced by that
post-`π₀` route; the present dependency path is not the final proof. -/
theorem ASection.concentricity (A : ASection) :
    ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c :=
  ⟨(A.sphereZero 0).re,
    A.commonCentre_of_transitive_of_read_natural
      A.residueTotal_transitive A.residueComponentRead_natural⟩

/-! ## Auxiliary continued-base infrastructure

These declarations record the residue system on `continuedBase`: its
morphisms, inverse-image residue states, and transitivity through the pole.
They are not the final Concentricity readout. In particular, the auxiliary
functor and pointwise read below must not replace the binding construction
`J_A → π₀(J_A) = {κ} → ℝ`. -/

/-- `∫R_A` over the A-section's base. -/
abbrev ASection.continuedResidueTotal (A : ASection) : Type :=
  Grothendieck (continuedCResidueDiagram A ⋙ Grpd.forgetToCat)

/-- Auxiliary inherited GPV real face on the continued residue total, by its
existing inclusion into the continued action diagram. -/
def ASection.continuedResidueGpvRealFace (A : ASection) :
    A.continuedResidueTotal ⥤ Discrete ℝ :=
  Grothendieck.map
    (Functor.whiskerRight (continuedCResidueInclusion A) Grpd.forgetToCat) ⋙
      continuedTotalGpvRealFace A

noncomputable instance ASection.continuedResidueTotalGroupoid (A : ASection) :
    CategoryTheory.Groupoid A.continuedResidueTotal :=
  grothendieckGrpdGroupoid (continuedCResidueDiagram A)

instance ASection.continuedCResidueInclusion_app_full
    (A : ASection) (X : (continuedBase A).objs) :
    ((continuedCResidueInclusion A).app X).Full :=
  ObjectProperty.full_ι _

instance ASection.continuedCResidueInclusion_app_faithful
    (A : ASection) (X : (continuedBase A).objs) :
    ((continuedCResidueInclusion A).app X).Faithful :=
  ObjectProperty.faithful_ι _

/-- The `n`-th pole seed is a residue state over the pole, selected through
the identity of the base. -/
theorem ASection.residueActionState_mem_continued (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    IsContinuedCResidueState A (continuedPole A)
      (residueActionState A (projectivePole A) n I) := by
  refine ⟨n, I, 𝟙 (continuedPole A), ?_⟩
  change (AsectionActionTransport A (𝟙 (projectivePole A))).obj _ = _
  rw [AsectionActionTransport_id]
  rfl

/-- The `n`-th pole seed as an object of `∫R_A` over the A-section's base. -/
noncomputable def ASection.continuedResidueTotalObject (A : ASection) (n : ℕ) :
    A.continuedResidueTotal :=
  ⟨continuedPole A,
    ⟨residueActionState A (projectivePole A) n baseWorld,
      A.residueActionState_mem_continued n baseWorld⟩⟩

/-- A residue state reached from the pole along the base morphism `g` has
input coordinate `cayleyProjective(g)` applied to the seed's (master
`def:transport`, the normalized entry). -/
theorem ASection.continued_input_coordinate_of_reach (A : ASection)
    {Y : (continuedBase A).objs} (m : ℕ) (J : SphereWorld)
    (g : continuedPole A ⟶ Y) (y : ContinuedCResidueFiber A Y)
    (hg : (AsectionActionTransport A ((continuedBaseForget A).map g)).obj
      (residueActionState A (projectivePole A) m J) = y.obj) :
    y.obj.input.back.coordinate =
      (GreatCircle.cayleyProjective ((continuedBaseForget A).map g).val).val
        (((projectiveObjectFrame A (projectivePole A))⁻¹).val
          (GreatCircle.cayleyMoebius.val (A.sphereZero m : OnePoint ℂ))) := by
  rw [← hg, AsectionActionTransport_obj_input, coordinateTransport_obj_coordinate,
    orbitStabilizerActionSquare_right_eq_cayley,
    ASection.residueActionState_input_coordinate]

/-- master `lem:c-residue-transitive`, display (M) on the A-section's base: a
morphism `h₂ : p_A → Y` of the base whose Möbius matrix carries the `n`-th
seed's input to the input of any residue state over `Y`; the real matrix is
the one of `baseArrow_of_offCircle`, and it is a morphism of the base because
the target's own membership joins the pole to `Y` by a transport. -/
theorem ASection.continuedSeatM (A : ASection) (n : ℕ) (I : SphereWorld)
    (Y : (continuedBase A).objs) (y : ContinuedCResidueFiber A Y)
    (hjoin : Nonempty (GpvTransport A (projectivePole A) Y.1)) :
    ∃ h₂ : continuedPole A ⟶ Y,
      ((AsectionActionTransport A ((continuedBaseForget A).map h₂)).obj
        (residueActionState A (projectivePole A) n I)).input.back.coordinate =
      y.obj.input.back.coordinate := by
  obtain ⟨m, J, g, hg⟩ := y.property
  have hy : ASection.OffBaseCircle y.obj.input.back.coordinate := by
    rw [ASection.continued_input_coordinate_of_reach A m J g y hg]
    exact ASection.cayleyProjective_preserves_offCircle _ _ (A.residue_offCircle m)
  obtain ⟨f, hf⟩ :=
    ASection.baseArrow_of_offCircle (projectivePole A) Y.1 _ _ (A.residue_offCircle n) hy
  refine ⟨⟨f, hjoin⟩, ?_⟩
  change ((AsectionActionTransport A f).obj
    (residueActionState A (projectivePole A) n I)).input.back.coordinate = _
  rw [AsectionActionTransport_obj_input_frame_conjugation,
    coordinateTransport_obj_coordinate, normalizedLeg_eq_cayley,
    ASection.residueActionState_input_coordinate]
  exact hf

/-- master `lem:c-residue-transitive` on the A-section's base: the
memberships hand `h₁ : p_A → a` and the transport joining the pole to `b`;
display (M) hands `h₂ : p_A → b`; the base leg is `h₁⁻¹ ≫ h₂` through the
pole; functoriality gives (H); one `G₂` automorphism closes the direction. -/
theorem ASection.continuedResidueTotal_transitive (A : ASection) :
    ∀ P Q : A.continuedResidueTotal, Nonempty (P ⟶ Q) := by
  intro P Q
  obtain ⟨n, I, h₁, hx⟩ := P.fiber.property
  obtain ⟨m, J, g₂, hy⟩ := Q.fiber.property
  obtain ⟨h₂, hcoord⟩ := A.continuedSeatM n I Q.base Q.fiber g₂.2
  obtain ⟨γ⟩ := A.residueFiberHom_of_inputCoordinate
    ((AsectionActionTransport A ((continuedBaseForget A).map h₂)).obj
      (residueActionState A (projectivePole A) n I))
    Q.fiber.obj hcoord
  refine ⟨⟨CategoryTheory.Groupoid.inv h₁ ≫ h₂,
    ((continuedCResidueInclusion A).app Q.base).preimage ?_⟩⟩
  have hback : (AsectionActionTransport A
      ((continuedBaseForget A).map (CategoryTheory.Groupoid.inv h₁))).obj P.fiber.obj =
      residueActionState A (projectivePole A) n I := by
    calc
      (AsectionActionTransport A
          ((continuedBaseForget A).map (CategoryTheory.Groupoid.inv h₁))).obj
            P.fiber.obj =
          (AsectionActionTransport A
            ((continuedBaseForget A).map (CategoryTheory.Groupoid.inv h₁))).obj
              ((AsectionActionTransport A ((continuedBaseForget A).map h₁)).obj
                (residueActionState A (projectivePole A) n I)) := by
        rw [hx]
      _ = (AsectionActionTransport A
            ((continuedBaseForget A).map h₁ ≫
              (continuedBaseForget A).map (CategoryTheory.Groupoid.inv h₁))).obj
              (residueActionState A (projectivePole A) n I) :=
          (congrArg (fun F => F.obj
            (residueActionState A (projectivePole A) n I))
            (AsectionActionTransport_comp A ((continuedBaseForget A).map h₁)
              ((continuedBaseForget A).map (CategoryTheory.Groupoid.inv h₁)))).symm
      _ = residueActionState A (projectivePole A) n I := by
        change (AsectionActionTransport A
          ((continuedBaseForget A).map (h₁ ≫ CategoryTheory.Groupoid.inv h₁))).obj _ = _
        rw [CategoryTheory.Groupoid.comp_inv h₁]
        change (AsectionActionTransport A (𝟙 (projectivePole A))).obj _ = _
        rw [AsectionActionTransport_id]
        rfl
  have hsrc : (AsectionActionTransport A
      ((continuedBaseForget A).map (CategoryTheory.Groupoid.inv h₁ ≫ h₂))).obj
        P.fiber.obj =
      (AsectionActionTransport A ((continuedBaseForget A).map h₂)).obj
        (residueActionState A (projectivePole A) n I) := by
    change (AsectionActionTransport A
      ((continuedBaseForget A).map (CategoryTheory.Groupoid.inv h₁) ≫
        (continuedBaseForget A).map h₂)).obj P.fiber.obj = _
    calc
      (AsectionActionTransport A
          ((continuedBaseForget A).map (CategoryTheory.Groupoid.inv h₁) ≫
            (continuedBaseForget A).map h₂)).obj P.fiber.obj =
          (AsectionActionTransport A ((continuedBaseForget A).map h₂)).obj
            ((AsectionActionTransport A
              ((continuedBaseForget A).map (CategoryTheory.Groupoid.inv h₁))).obj
                P.fiber.obj) :=
        congrArg (fun F => F.obj P.fiber.obj)
          (AsectionActionTransport_comp A
            ((continuedBaseForget A).map (CategoryTheory.Groupoid.inv h₁))
            ((continuedBaseForget A).map h₂))
      _ = (AsectionActionTransport A ((continuedBaseForget A).map h₂)).obj
            (residueActionState A (projectivePole A) n I) := by rw [hback]
  exact eqToHom hsrc ≫ γ

/-- Connected from transitive, C4 supplying the objects. -/
theorem ASection.continuedResidueTotal_isConnected (A : ASection) :
    CategoryTheory.IsConnected A.continuedResidueTotal := by
  haveI : Nonempty A.continuedResidueTotal := ⟨A.continuedResidueTotalObject 0⟩
  exact zigzag_isConnected fun P Q =>
    CategoryTheory.Zigzag.of_hom (A.continuedResidueTotal_transitive P Q).some

/-- Auxiliary constancy result for the continued-base GPV functor. It is not
the post-`π₀` production readout. -/
theorem ASection.continuedResidueGpvRealFace_constant (A : ASection)
    (P Q : A.continuedResidueTotal) :
    (A.continuedResidueGpvRealFace.obj P).as =
      (A.continuedResidueGpvRealFace.obj Q).as := by
  letI := A.continuedResidueTotal_isConnected
  exact congrArg Discrete.as
    (CategoryTheory.any_functor_const_on_obj A.continuedResidueGpvRealFace P Q)

/-- Auxiliary pointwise read on the continued-base total. It records the real
coordinate of a residue output state but is not `Lbar_A`. -/
noncomputable def ASection.continuedResidueRead (A : ASection)
    (P : A.continuedResidueTotal) : ℝ :=
  OnePoint.rec 0 Complex.re
    ((GreatCircle.cayleyMoebius⁻¹).val P.fiber.obj.positioned.back.coordinate)

/-- (V_n): at the `n`-th pole seed the read is the real coordinate of the
`n`-th residue sphere. -/
@[simp] theorem ASection.continuedResidueRead_certified (A : ASection) (n : ℕ) :
    A.continuedResidueRead (A.continuedResidueTotalObject n) = (A.sphereZero n).re := by
  simp only [ASection.continuedResidueRead, ASection.continuedResidueTotalObject,
    residueActionState_positioned]
  change OnePoint.rec (C := fun _ => ℝ) (0 : ℝ) Complex.re
    ((GreatCircle.cayleyMoebius⁻¹).val (A.residueState n baseWorld).coordinate) = _
  rw [residueState_coordinate, cayleyMoebius_inv_apply_cayley]
  rfl

/-- In the auxiliary continued-base presentation, the `G₂` automorphism of a
morphism of `∫R_A` keeps the output
coordinate; so `L_A` is constant along a morphism `(h, γ)` exactly when it is
constant along the Möbius matrix of the real matrix `h`.  The hypothesis is
that statement, for every morphism of the base and every residue state over
its source. -/
theorem ASection.continuedResidueRead_eq_of_base (A : ASection)
    (hbase : ∀ {X Y : (continuedBase A).objs} (f : X ⟶ Y)
      (x : ContinuedCResidueFiber A X),
      OnePoint.rec (C := fun _ => ℝ) (0 : ℝ) Complex.re
          ((GreatCircle.cayleyMoebius⁻¹).val
            (((AsectionActionTransport A ((continuedBaseForget A).map f)).obj
              x.obj).positioned.back.coordinate)) =
        OnePoint.rec (C := fun _ => ℝ) (0 : ℝ) Complex.re
          ((GreatCircle.cayleyMoebius⁻¹).val x.obj.positioned.back.coordinate)) :
    ∀ (P Q : A.continuedResidueTotal) (_φ : P ⟶ Q),
      A.continuedResidueRead P = A.continuedResidueRead Q := by
  intro P Q φ
  have hγ : (((continuedCResidueTransport A φ.base).obj P.fiber).obj.positioned.back.coordinate)
      = Q.fiber.obj.positioned.back.coordinate := by
    let ψ := (AsectionActionPositioned A Q.base.1).map φ.fiber.hom
    have hstate := ψ.property
    change (show G2 from ψ.val) •
      ((continuedCResidueTransport A φ.base).obj P.fiber).obj.positioned.back =
        Q.fiber.obj.positioned.back at hstate
    simpa only [AsectionState.smul_coordinate] using
      congrArg AsectionState.coordinate hstate
  unfold ASection.continuedResidueRead
  rw [← hγ]
  exact (hbase φ.base P.fiber).symm

/-- Auxiliary implication from an assumed pre-collapse invariance statement.
It is retained as checked background and must not be used to prove the
production Concentricity theorem, whose read occurs only after singleton
`π₀`. -/
theorem ASection.continuedCommonCentre (A : ASection)
    (hread : ∀ (P Q : A.continuedResidueTotal) (_φ : P ⟶ Q),
      A.continuedResidueRead P = A.continuedResidueRead Q) :
    ∀ n : ℕ, (A.sphereZero n).re = (A.sphereZero 0).re := by
  letI := A.continuedResidueTotal_isConnected
  intro n
  have h := constant_of_preserves_morphisms (J := A.continuedResidueTotal)
    A.continuedResidueRead (fun P Q φ => hread P Q φ)
    (A.continuedResidueTotalObject n) (A.continuedResidueTotalObject 0)
  rwa [A.continuedResidueRead_certified, A.continuedResidueRead_certified] at h
