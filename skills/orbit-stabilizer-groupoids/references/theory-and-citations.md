# Orbit–stabilizer groupoids: theory and citations

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
base.

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
