# Orbit–stabilizer groupoids: theory and citations

> **Concentricity gate warning.** The abstract restriction criterion recorded
> below is background theory only. For the live project, do not begin from a
> predicate or the pointwise implication `P_X(x) → P_Y(F(f)(x))`. Begin from
> the already-certified orbit subgroupoid/groupoid preimage and require the
> exact A-specific natural transformation
> `AsectionCResidueDiagram A ⟶ AsectionActionDiagram A`. The categorical
> lock in the parent `SKILL.md` overrides any lower-level reading of this
> reference.

## Primary categorical source

Emily Riehl, *Category Theory in Context*, Dover Publications, 2016.

- Author-hosted book page: <https://emilyriehl.github.io/books/>
- Author-hosted PDF: <https://emilyriehl.github.io/files/context.pdf>
- Project transcription and verification record:
  `SOURCES/Riehl-CTIC.md`

Use the following pinpoint citations.

| role | statement | pinpoint |
|---|---|---|
| categorified orbit–stabilizer | the action groupoid has points as objects and acting elements as arrows; components are orbits and vertex automorphisms are stabilizers | Example 1.5.19, book p. 37 |
| invariant subsystem | objectwise subsets form a subfunctor when every transition map restricts | Exercise 2.1.iv, book p. 59 |
| category of elements | the category of elements of a `G`-set is its action groupoid | Example 2.4.10, book p. 75 |
| natural transformations totalize | the category-of-elements construction is fully faithful into categories over the base; a natural transformation induces a functor of totals over that base | Proposition 2.4.14, book p. 77 |

Riehl’s statements in Exercise 2.1.iv and Proposition 2.4.14 are
`Set`-valued. For groupoid-valued diagrams they provide the conceptual
source; Mathlib’s full-subcategory and Grothendieck constructions provide
the implementation.

## Components source

Emily Riehl, *Categorical Homotopy Theory*, Cambridge University Press,
2014, §8.3.

- Author-hosted PDF:
  <https://emilyriehl.github.io/files/cathtpy.pdf>
- Project transcription and verification record:
  `SOURCES/Riehl.md`

Remark 8.3.5, book p. 102, says that a category is categorically connected
when every pair of objects is joined by a finite zigzag, and that a category
is nonempty and categorically connected exactly when its connected-component
set is a singleton.

Here “connected” is purely categorical. It refers to zigzags in an action
groupoid and the cardinality of `π₀`; it is not topological connectedness of
the complex zero locus, an octonionic sphere, or any analytic space.

The category-of-elements identity immediately preceding the remark,

```text
π₀(el X) ≅ colim X,
```

is the discrete-fibre case of the in-repo groupoid-valued theorem
`pi0GrothendieckEquiv`.

## Citation-ready mathematical capsule

For a group `G` acting on a set `X`, form the action groupoid `X // G`.
Objects are elements of `X`; an arrow `x ⟶ y` is a group element `g` with
`g • x = y`. Its connected components are the `G`-orbits, and the
automorphism group of `x` is `Stab_G(x)`. Consequently the usual
quotient–orbit equivalence

```text
G / Stab_G(x) ≃ Orb_G(x)
```

is the set-level shadow of the groupoid presentation. A transitive action
gives a categorically connected action groupoid while retaining
stabilizers; freeness is the additional condition needed for
contractibility.

If `P_X` is an invariant object property in each fibre of a diagram `F`,
the transition condition

```text
P_X(x) → P_Y(F(f)(x))
```

produces the restricted diagram. Its inclusion is natural, and the induced
map of categories of elements or Grothendieck totals lies over the original
base. **For a subsystem selected orbit-wise — a union of components — this
transition condition is vacuously satisfied:** arrows of an action groupoid
cannot leave the orbit of their domain (Ex. 1.5.19's hom-set
decomposition), and stabilizer arrows are vertex automorphisms. The
condition has content only for objectwise static selections, which the
Concentricity lock forbids as the gate's subject.

## Master-writing cautions

- Cite Example 1.5.19 for components/orbits and
  automorphisms/stabilizers.
- Cite Example 2.4.10 for the identification of a `G`-set’s category of
  elements with its action groupoid.
- Cite Exercise 2.1.iv for the restriction condition.
- Cite Proposition 2.4.14 only for the `Set`-valued category-of-elements
  passage. Say explicitly that the groupoid-valued implementation is
  supplied by Mathlib.
- Do not claim that transitivity removes stabilizers. Transitivity gives
  categorical connectedness; free transitivity gives contractibility.
- Do not choose a skeletal representative when naturality matters. The
  action groupoid retains all viewpoints and their stabilizers.
- Cite Remark 8.3.5 from *Categorical Homotopy Theory*, not *Category
  Theory in Context*. The two books contain colliding section and statement
  numbers.
- Do not use C4 as a component argument. In Concentricity the residue
  inverse image already has certified inhabitants; C4 supplies the stronger
  infinitude statement. The action-groupoid orbit calculation supplies
  categorical connectedness.

## The preimage process for the Grothendieck construction

The residue gate's construction is a standard literature process, not a
project invention: take a full preimage of an objectwise class inside the
fibres of a diagram, then include its total into the ambient total — **a
preimage for the total Grothendieck construction**.

- CTIC Exercise 2.1.iv (book p. 59): an objectwise class whose transition
  maps restrict is a subfunctor.
- CTIC Proposition 2.4.14 (book p. 77): a natural transformation of diagrams
  induces a functor of their categories of elements over the same base;
  applied to a subfunctor inclusion, this is the inclusion of totals.
- In fibrational language, this is the full inverse image of a class of
  objects under the Grothendieck construction: the full subcategory of the
  total on the selected objects, lying over the same base. Mathlib supplies
  the pieces at the pinned revision: `ObjectProperty.FullSubcategory`
  (fibrewise preimage), `CategoryTheory.Grothendieck.map` (totalized
  inclusion), `Grothendieck.functor_comp_forget` (over the base).

For Concentricity (reading of record, `register/70-whole-square.md` §9):
`𝓡_A(X)` is the fibrewise full preimage of the semantic C-residue locus in
the certified `F_A(X)`, but it is a separately bundled groupoid, not a
set-theoretic subset of `F_A(X)`. The datum is the natural transformation
`ι_A : 𝓡_A ⟶ F_A`; each component
`(ι_A)_X : 𝓡_A(X) ⥤ F_A(X)` is a fully faithful inclusion functor, and
`liftCompιIso = Iso.refl _` supplies its naturality square. Thus `𝓡_A` is
naturally isomorphic onto the image of its own functorial transport, never
to all of `F_A`. `Grothendieck.map ι_A` is correspondingly the functorial
inclusion of the separately bundled residue total into the ambient total,
over the same base — not a subset inclusion. This is the preimage for the
total Grothendieck construction consumed by CHT Remark 8.3.5. No invariance
theorem occurs anywhere in this process.

## The applied chain from `F_A` to `c` (2026-07-27 — the whole remaining project, cited)

**Step 0 — certified, the author's.** `F_A = AsectionActionDiagram A` with
`obj X = AsectionActionFiber A X`, `map f = AsectionActionTransport A f`
(the `d = 1` orbit–stabilizer square applied; laws `_id`/`_comp` at
`ASectionActionDiagram.lean:306/:313`, consumed as the functor's own
fields); base `ActionCategory PGL(2,ℝ) (OnePoint ℝ)`, anchor `N`, unique
factorization (`orbit_stabilizer_factor`, `stabilizerPart_unique`); total
`T_A` the literal Grothendieck construction (Gate 2).

1. **Action groupoid structure** — CTIC Ex. 1.5.19 (p. 37): components ARE
   orbits; stabilizers ARE vertex automorphisms; the hom-sets out of `x`
   land only in `O_x` — **arrows cannot leave orbits**. Lean:
   `ActionCategory.stabilizerIsoEnd`,
   `MulAction.orbitEquivQuotientStabilizer`; in-repo vertical instance
   `zeroSphere_eq_orbit` (`ZeroSpheres.lean:70`).
2. **The total is the action groupoid of the induced action** — CTIC
   Ex. 2.4.10 (p. 75) applied at the top; Mathlib `Grothendieck`; certified.
3. **The selection — semantic, the author's.** `CResidueZeroLocus A` (C3
   sound and complete both directions, C4 infinite — certified) names the
   orbits of the certified inhabitants (`residueActionState`,
   `residueTotal`). Orbit-wise selection ⟹ CTIC Ex. 2.1.iv's restriction
   clause (p. 59) is **vacuous** by step 1. No preservation theorem exists.
   `𝓡_A(X)` depends only on `A` and `X`.
4. **The inclusion** — CTIC Prop. 2.4.14 (p. 77): a natural transformation
   of diagrams IS a functor of totals over the base. Outer type,
   non-negotiable:
   `AsectionCResidueInclusion A : AsectionCResidueDiagram A ⟶
   AsectionActionDiagram A`; components fully faithful (Mathlib
   `ObjectProperty.ι`, `fullyFaithfulι`, `liftCompιIso`); totalized by
   `Grothendieck.map` with `functor_comp_forget` (CTIC is `Set`-valued
   conceptual source; Mathlib is the groupoid-valued implementation).
5. **One component — recognition, not a tape-joining theorem.**
   ⛔ **CORRECTED 2026-07-27 by the author.** This row previously read "the
   ONE substantive remaining theorem — the tapes join every selected orbit
   through the anchor." That framing is retired: it reads a later step as
   harder than the author states it, and it was acted on once. His ruling:
   *"we apply 8.3.5 first and the categorified orbit–stabilizer theorem to
   the `ι_A` (as `R_A`) and we get the singleton after a chain of one or two
   theorems tops (including `val`)."*

   The residue total **is** the action groupoid already built (CTIC
   Ex. 1.5.19 p. 37, Ex. 2.4.10 p. 75); its transitivity gives categorical
   connectedness with stabilizers retained. Then CHT Rem. 8.3.5 (p. 102,
   verbatim in `SOURCES/Riehl.md`): nonempty + zigzag-connected ⟺ `π₀`
   singleton — the certified inverse image already has inhabitants, so
   nonemptiness is not a build step and C4 is stronger than needed. Lean:
   `ConnectedComponents = Quotient (Zigzag.setoid)`, `isPreconnected_zigzag`;
   the anonymous transitive-action instance (`Action.lean:128`) by
   resolution only. Categorical connectedness, never topological.

   ⚠️ **Do not claim contractibility.** CTIC Ex. 2.4.10 gives that only for a
   **free and transitive** action; this action is transitive and *not* free —
   the stabilizers are retained on purpose. Connected-with-stabilizers is the
   claim, and it is exactly what Rem. 8.3.5 consumes.
6. **Components comparison** — the el-identity (CHT p. 102):
   `π₀(∫𝓡_A) ≃ colim(π₀ ∘ 𝓡_A)` — in-repo `pi0GrothendieckEquiv`
   (`Theorem.lean:108`).
7. **Descent — the author's.** The `ℝ`-valued real-level orbit invariant is
   constant on the one component; it descends to `val_A`;
   `c` is `val_A` at that class; `ASection.concentricity`; the corollaries fire through
   the certified equivalence.

Generic and already implemented at the pins: steps 1, 2, 4, 6, and the
8.3.5 half of 5. The author's: step 0 (certified), step 3 (certified
selection), the recognition half of step 5, and step 7 (his invariant).
**Step 4 is CLOSED at commit `57384ae`.** **There is nothing else in this
project.**

## The collapse steps, precisely cited (2026-07-27, post-ι_A)

For the remaining ladder rows 2–5, each generic statement with its exact
source and its Lean match. All CTIC/CHT quotations are verbatim-transcribed
in `SOURCES/Riehl-CTIC.md` and `SOURCES/Riehl.md`.

**Step 2 — recognize `∫𝓡_A` through the action groupoid; connectedness.**

- CTIC Ex. 1.5.19 (book p. 37): the action groupoid `X⫽G`; *components are
  orbits*; *vertex automorphisms are stabilizers*; the hom-sets out of `x`
  decompose over `O_x`.
- CTIC Ex. 2.4.10 (book p. 75): `∫X ≅ X⫽G` — the category of elements of an
  action IS its action groupoid. Its second paragraph carries the exact
  connectedness dichotomy, recorded in the SOURCES note: **"free and
  transitive" gives a contractible groupoid; "a transitive action that is
  not free gives a connected groupoid retaining a nontrivial stabilizer."**
  The project case is the second: connected, stabilizers retained.
- Mathlib: the anonymous instance at `Action.lean:128`
  (`[IsPretransitive M X] [Nonempty X] : IsConnected (ActionCategory M X)`),
  obtained by resolution only; it does not auto-resolve for
  `InducedCategory`/`FullSubcategory`/`Grothendieck`, so the project's
  connectedness receipt is an internal proof from the inherited arrows.

**The skeleton warning, and why this project passes it.** Riehl warns
immediately before Ex. 1.5.19 (book p. 37) that choosing skeletal
representatives is not in general functorial, and what `π₀` collapses to
**depends on the diagram fed in**. The project feeds the *defined preimage* —
`IsNorthCResidueState` selecting by the semantic equation at the 0-to-N
frame, spread by the action with the witness arrow as data — never a chosen
skeleton, never picked representatives. The singleton, when it arrives, is a
computation about that certified diagram, not an artifact of a choice.

**Step 3 — CHT Remark 8.3.5 (book p. 102, verbatim in `SOURCES/Riehl.md`).**

> "A category is **connected** just when any pair of objects can be joined
> by a finite zig-zag of arrows… A category `C` is non-empty and connected
> if and only if `π₀ C` is the singleton set."

- Nonempty: the certified inhabitant receipts (locus point → north state →
  member at every frame).
- Connected: step 2's receipt. Categorical zigzags only — never topology.
- Carrier: Mathlib `ConnectedComponents = Quotient (Zigzag.setoid C)`;
  the singleton receipt is quotient induction +
  `Quotient.sound (isPreconnected_zigzag x y)` (the dictionary's recipe).
- The carrier and its unique class receive **project names at the
  checkpoint** (never abbreviated `1`), per the author's standing rule.

**Step 4 — the components comparison.**

- The el-identity `π₀(el X) ≅ colim X`: CHT book p. 102, inside the proof
  of Lemma 8.3.4 — used as the *mechanism*; 8.3.4 itself is not
  instantiated on the locked route.
- In-repo `Grpd`-valued extension: `pi0GrothendieckEquiv`
  (`Theorem.lean:108`), whose argument type `B ⥤ Grpd` matches
  `AsectionCResidueDiagram A : GreatCircle.Base ⥤ Grpd` with zero
  adaptation.
- Over-base identification feeding it: CTIC Prop. 2.4.14 (book p. 77) as
  conceptual source; Mathlib `Grothendieck.map` + `functor_comp_forget` as
  implementation.

**Step 5 — the descent.** Generic: `Quotient.lift` well-definedness on the
component quotient (every `ConnectedComponents` elimination in Mathlib).
The author's: the exact live `ℝ`-valued real-level invariant and the names
`val_A`, the unique class, and `c` — **named by the author at the checkpoint**
(the two namings requested in the endgame table), with the codomain fixed by
the invariant being descended, never chosen by a cone.

## Secondary implementation sources

Official Mathlib documentation:

- Action categories:
  <https://leanprover-community.github.io/mathlib4_docs/Mathlib/CategoryTheory/Action.html>
- Quotient actions and orbit–stabilizer:
  <https://leanprover-community.github.io/mathlib4_docs/Mathlib/GroupTheory/GroupAction/Quotient.html>
- Full subcategories and lifts:
  <https://leanprover-community.github.io/mathlib4_docs/Mathlib/CategoryTheory/ObjectProperty/FullSubcategory.html>
- Grothendieck construction:
  <https://leanprover-community.github.io/mathlib4_docs/Mathlib/CategoryTheory/Grothendieck.html>

For theorem statements used in a formal proof, cite the project’s pinned
Mathlib revision and exact local declaration rather than relying on the
moving documentation site alone.
