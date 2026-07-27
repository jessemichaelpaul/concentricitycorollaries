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
5. **One component through `N` — the ONE substantive remaining theorem.**
   The tapes join every selected orbit through the anchor; suppliers green:
   `normalizedNBaseHom`, `normalizedNActionSquare` (its `commutes` consumes
   `lift_closed`), `lift_unique`/`winding_lift_unique`, `orbitHomToNorth`,
   the `positionedOrbitSquare` family. Then CHT Rem. 8.3.5 (p. 102,
   verbatim in `SOURCES/Riehl.md`): nonempty + zigzag-connected ⟺ `π₀`
   singleton. Lean: `ConnectedComponents = Quotient (Zigzag.setoid)`,
   `isPreconnected_zigzag`; the anonymous transitive-action instance
   (`Action.lean:128`) by resolution only. Categorical connectedness, never
   topological.
6. **Components comparison** — the el-identity (CHT p. 102):
   `π₀(∫𝓡_A) ≃ colim(π₀ ∘ 𝓡_A)` — in-repo `pi0GrothendieckEquiv`
   (`Theorem.lean:108`).
7. **Descent — the author's.** The `ℝ`-valued real-level orbit invariant is
   constant on the one component; it descends to `val_A`;
   `c := val_A k_A`; `ASection.concentricity`; the corollaries fire through
   the certified equivalence.

Generic and already implemented at the pins: steps 1, 2, 4, 6, and the
8.3.5 half of 5. The author's: step 0 (certified), step 3 (certified
selection), the tape half of step 5 (suppliers certified; one theorem to
assemble), and step 7 (his invariant). **There is nothing else in this
project.**

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
