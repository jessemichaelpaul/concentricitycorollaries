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
gives a connected action groupoid while retaining stabilizers; freeness is
the additional condition needed for contractibility.

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
  connectedness; free transitivity gives contractibility.
- Do not choose a skeletal representative when naturality matters. The
  action groupoid retains all viewpoints and their stabilizers.

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
