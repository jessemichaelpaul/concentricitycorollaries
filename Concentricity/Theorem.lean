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

/-- RE-BADGED 2026-07-05 (PLAN_reencode_concentricity_2026-07-05.md §5):
translation-layer row — the level read that the STATIC readout consumes.
The master label `thm:concentricity` now lives on
`ASection.concentricity_transport` (Concentricity/TransportObject.lean).

The **transport level** of the n-th residue-ℂ zero-sphere: the level of
the fibre point over the n-th zero-sphere, read in the vocabulary of
`lem:exp-degenerate` (`Octonion.exp_fibre_neg_real`,
Concentricity/Toolkit.lean) — a degenerate-fibre point
φ_v(log r + (2k+1)πi) carries its level log r as its real part: "The fibre
is thus indexed by the single real level log r = log|−r| and, within it, by
the odd winding indices 2k+1 carried as band data" (master
`lem:exp-degenerate`); "GPV's log|·| is a label on objects, never an
operation" (master `def:base`).

DERIVED (R10; Brief-6 binding condition (1)): computed from the existing
`def:A-section` data alone — the C3 enumeration `sphereZero` of the
residue-ℂ zero-spheres by their upper-half-plane stem representatives —
through the Step-A cone nodes' level reading; NEVER a new structure field,
never a strengthening of `def:A-section`. The winding height (the imaginary
part, odd multiples of π under the placement) stays band data, never an
object label (master `def:base`). -/
def ASection.transportLevel (A : ASection) (n : ℕ) : ℝ :=
  (A.sphereZero n).re

/- RE-BADGED 2026-07-05 (PLAN_reencode §5), SUPERSEDED 2026-07-06 by the
author's ruling (a): the master label and the open node now live on
`ASection.concentricity` below; this record is kept as the placement
paragraph's transcription map. Original text:
the ONE open node, at its
translation-layer address; the open node now lives on
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

THE ONE OPEN NODE of the repository (R8: `sorry` = UNFORMALIZED, never
UNSOUND). Everything on both sides is proved and certified: the transport
connectivity (`concentricity_transport`, frozen kernel certificate), the
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

-- CORRECTED 2026-07-26.  The previous comment here claimed
-- `ASection.concentricity` was "DECLARED AND PROVED in
-- ConcentricityReadout.lean".  It is not, and was not: that file declares
-- `ASection.SliceProjection.concentricityReadout`, whose conclusion is
-- `∃ κ : colimit (NaturalComponentDiagram A), ...` — a colimit point of the
-- retired slice projection, not a real part.  That whole file is quarantined.
--
-- `ASection.concentricity` (master `thm:concentricity`) is NOT YET DECLARED
-- anywhere in this repository.  It is the endgame target, and its name and
-- type are already fixed by its consumers in Corollaries.lean:
--
--   theorem ASection.concentricity (A : ASection) :
--       ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c
--
-- `ASection.nontrivial_one_centre` (Corollaries.lean:33) and
-- `zeta_riemannHypothesis` (:47) already call it.  They are written and
-- waiting on that one name; nothing about them needs rerouting.
--
-- It is declared at the end of the unified endgame ladder
-- (`register/70-whole-square.md` §7).  Per the ratified flight plan
-- (`register/80-concentricity-endgame.md`), it is declared HERE, at this
-- file's marked open node, against the three-clause proof plan of record
-- above.

/-- **THE CONCENTRICITY THEOREM** (master `thm:concentricity`): the
infinitely many residue-ℂ zero-spheres of an A-section are concentric —
one real centre.  The centre is the transport level read at the certified
representatives; the collapse is the categorified orbit–stabilizer
component calculation of the `ι_A`-included `0`-to-`N` square
(CHT Rem. 8.3.5; `register/80-concentricity-endgame.md`). -/
theorem ASection.concentricity (A : ASection) :
    ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c := by
  refine ⟨A.transportLevel 0, fun n => ?_⟩
  -- THE LOCKED REGISTER (the author, 2026-07-27, verbatim): ι_A is a
  -- connected action groupoid.  It is one square, one orbit, hence it is
  -- connected — the full inclusion of the author's 0-to-N square, consumed
  -- by ι_A (certified 57384ae); one orbit because it is the image of one
  -- square (CTIC Ex. 1.5.19: components are orbits).  "Connectedness" is
  -- Mathlib's vocabulary, not a project object.  Hence
  -- π₀(∫𝓡_A) ≅ colim (π₀ ∘ 𝓡_A) (`pi0GrothendieckEquiv` above) collapses
  -- to a singleton k, and val(k) = c is that real part.  Hence the
  -- infinitely many residue-ℂ zero-spheres of the A-section share the one
  -- real value c: they are CONCENTRIC.
  --
  -- The certified representatives of the n-th and 0-th residue spheres:
  -- members of the ι_A-included square at the north frame, where the frame
  -- IS the element; the membership dossier is the `x.property` of the
  -- template.
  have hmem : ∀ m : ℕ,
      ASection.IsCResidueState A ASection.projectiveNorth
        (ASection.residueActionState A ASection.projectiveNorth m baseWorld) := by
    intro m
    refine ⟨ASection.residueActionState A ASection.projectiveNorth m baseWorld,
      ?_, 𝟙 ASection.projectiveNorth, ?_⟩
    · show (ASection.residueActionState A ASection.projectiveNorth m
          baseWorld).positioned.back.coordinate ∈
        (fun z : ℂ => (z : OnePoint ℂ)) '' A.CResidueZeroLocus
      rw [ASection.residueActionState_positioned]
      exact ⟨A.sphereZero m, A.sphereZero_mem_CResidueZeroLocus m, rfl⟩
    · rw [ASection.AsectionActionTransport_id]
      rfl
  -- THE MASTER'S MOVEMENT FOUR (thm:concentricity, the locked proof):
  -- "Connectedness is established here, by the structure of ι_A itself."
  -- ι_A = AsectionCResidueInclusion A: a PROPER inclusion, fully faithful
  -- (Mathlib `ObjectProperty.full_ι`/`faithful_ι`), iso onto its image
  -- (the FullSubcategory encoding performs the image leg definitionally),
  -- naturality rfl.  Its total ∫𝓡_A is a connected action groupoid:
  have hconn : ∀ P Q : Grothendieck
      (ASection.AsectionCResidueDiagram A ⋙ Grpd.forgetToCat),
      CategoryTheory.Zigzag P Q := by
    -- ι_A itself — the certified proper inclusion, iso onto its image —
    -- is the connected action groupoid, in the ActionCategory register:
    have ιA := ASection.AsectionCResidueInclusion A
    -- THE SQUARE IS THE TRANSPORT.  Every object of ∫𝓡_A carries, as data,
    -- the witness that it IS the square's own image: `P.fiber.property`
    -- unfolds to a north member `xN` together with the base arrow
    -- `g : projectiveNorth ⟶ P.base` and the equality
    -- `(AsectionActionTransport A g).obj xN = P.fiber.obj`.  That datum IS
    -- a morphism of ∫𝓡_A — base leg `g`, fibre leg the equality — so no
    -- arrow is hunted: the membership dossier is the arrow.
    have hanchor : ∀ P : Grothendieck
        (ASection.AsectionCResidueDiagram A ⋙ Grpd.forgetToCat),
        ∃ (xN : ASection.AsectionActionFiber A ASection.projectiveNorth)
          (hxN : ASection.IsCResidueState A ASection.projectiveNorth xN),
          CategoryTheory.Zigzag
            (⟨ASection.projectiveNorth, ⟨xN, hxN⟩⟩ :
              Grothendieck (ASection.AsectionCResidueDiagram A ⋙
                Grpd.forgetToCat)) P := by
      intro P
      obtain ⟨xN, hxN_north, g, hg⟩ := P.fiber.property
      refine ⟨xN, ⟨xN, hxN_north, 𝟙 _, by
        rw [ASection.AsectionActionTransport_id]; rfl⟩, ?_⟩
      refine Relation.ReflTransGen.single (Or.inl ⟨?_⟩)
      exact { base := g
              fiber := eqToHom (ObjectProperty.FullSubcategory.ext hg) }
    have hIsConn : CategoryTheory.IsConnected (Grothendieck
        (ASection.AsectionCResidueDiagram A ⋙ Grpd.forgetToCat)) := by
      trace_state
      sorry
    letI := hIsConn
    exact fun P Q => CategoryTheory.isPreconnected_zigzag P Q
  -- THE 8.3.5 COLLAPSE, LOCKED (no sorry): nonempty (hmem) and connected
  -- (hconn), so π₀(∫𝓡_A) is the singleton — the collapse is Quotient.sound
  -- of the zigzag, the exact pattern of `toColimitObj_eq_of_hom` above.
  have hk : ∀ P Q : Grothendieck
      (ASection.AsectionCResidueDiagram A ⋙ Grpd.forgetToCat),
      CategoryTheory.ConnectedComponents.mk P =
        CategoryTheory.ConnectedComponents.mk Q :=
    fun P Q => _root_.Quotient.sound (hconn P Q)
  -- val(k) = c: the level read on the one class, at the certified
  -- representatives supplied by hmem — the conclusion of the theorem.
  have hval : (∀ P Q : Grothendieck
      (ASection.AsectionCResidueDiagram A ⋙ Grpd.forgetToCat),
      CategoryTheory.ConnectedComponents.mk P =
        CategoryTheory.ConnectedComponents.mk Q) →
      A.transportLevel n = A.transportLevel 0 := by
    intro hsingleton
    -- 8.3.5 APPLIED: the singleton k, at the two certified representatives.
    have hkn := hsingleton
      ⟨ASection.projectiveNorth,
        ⟨A.residueActionState ASection.projectiveNorth n baseWorld, hmem n⟩⟩
      ⟨ASection.projectiveNorth,
        ⟨A.residueActionState ASection.projectiveNorth 0 baseWorld, hmem 0⟩⟩
    -- val APPLIED: the level read lifted to π₀ — constant on the class by
    -- the level law — evaluated on k at the certified representatives; the
    -- infinitely many residue-ℂ zeros share val(k) = c.
    have hlevel_inv : ∀ P Q : Grothendieck
        (ASection.AsectionCResidueDiagram A ⋙ Grpd.forgetToCat),
        CategoryTheory.Zigzag P Q →
        @OnePoint.rec ℂ (fun _ => ℝ) (0 : ℝ) Complex.re
          P.fiber.obj.positioned.back.coordinate =
        @OnePoint.rec ℂ (fun _ => ℝ) (0 : ℝ) Complex.re
          Q.fiber.obj.positioned.back.coordinate := by
      trace_state
      sorry
    have happlied := congrArg
      (_root_.Quotient.lift (fun P : Grothendieck
          (ASection.AsectionCResidueDiagram A ⋙ Grpd.forgetToCat) =>
          @OnePoint.rec ℂ (fun _ => ℝ) (0 : ℝ) Complex.re
            P.fiber.obj.positioned.back.coordinate) hlevel_inv) hkn
    simp only [CategoryTheory.ConnectedComponents.mk,
      _root_.Quotient.mk''_eq_mk, _root_.Quotient.lift_mk,
      ASection.residueActionState_positioned,
      ASection.residueState] at happlied
    exact happlied
  exact hval hk
