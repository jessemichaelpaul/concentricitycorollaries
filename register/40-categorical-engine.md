# Generic categorical engine

This file records reusable category theory only. It does not define Jesse's
A-section functor or prescribe the project readout.

Before using a Lean name, reread its live declaration in
`Concentricity/Theorem.lean`.

Primary project source: `SOURCES/Riehl.md`, transcribing Emily Riehl,
*Categorical Homotopy Theory*, §8.3.

## 1. Grothendieck construction

For `F : B ⥤ Cat`, `Grothendieck F` has:

- objects `⟨b, x⟩`, with `b : B` and `x : F.obj b`;
- morphisms with a base leg `f : b ⟶ b'` and a fibre leg
  `(F.map f).obj x ⟶ x'`.

For `F : B ⥤ Grpd`, use `F ⋙ Grpd.forgetToCat`.

This construction assembles a diagram whose objects and arrows already
exist. It does not manufacture an action, value state, invariant, cone, or
distinguished subsystem.

## 2. Connected components

`ConnectedComponents C` is the quotient of objects of `C` by finite
zigzags. The in-repo functor is:

```lean
pi0Functor : Cat ⥤ Type
```

Riehl Remark 8.3.5 states:

- a category is connected exactly when every pair of objects is joined by a
  finite zigzag;
- a category is nonempty and connected exactly when its `π₀` is a singleton.

`π₀` reads the components of the category supplied to it. It does not prove
that a project-specific family belongs to one component.

## 3. Riehl Lemma 8.3.4

The literal statement is a finality criterion:

```text
K : C ⥤ D is final
  iff
for every d : D, the slice d/K is nonempty and connected.
```

Finality says that, for every diagram `X : D ⥤ M`, the canonical comparison
from the colimit of `X ⋙ K` to the colimit of `X` is an isomorphism.

The project must name the actual `K`, the actual target object `d`, and the
literal slice `d/K`. Do not substitute whole-total connectedness, generic
zigzags, or an arrow hunt.

## 4. Category-of-elements identity

Inside the proof of Lemma 8.3.4, Riehl uses:

```text
π₀(el X) ≅ colim_C X
```

for `X : C ⥤ Set`. Each arrow in `el X` imposes an identification in every
cone under `X`.

This statement is cone-relative: first know the diagram and cone being
read. It is literature backing for the identifications made by a colimit,
not authorization to create a category of elements as a project object.

## 5. Grothendieck-components equivalence

The separate in-repo theorem is:

```lean
pi0GrothendieckEquiv (F : B ⥤ Grpd) :
  ConnectedComponents (Grothendieck (F ⋙ Grpd.forgetToCat))
    ≃ Limits.colimit ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor)
```

and:

```lean
pi0_grothendieck (F : B ⥤ Grpd) :
  Nonempty
    (ConnectedComponents (Grothendieck (F ⋙ Grpd.forgetToCat))
      ≃ Limits.colimit ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor))
```

This is an equivalence, not equality, not `π₀` itself, and not Riehl's
Lemma 8.3.4.

Its forward map descends `toColimitObj` over the zigzag quotient; its inverse
uses the canonical `pi0Cocone`. These are the mechanics proving the generic
equivalence. They do not identify a project-specific chosen family.

## 6. Colimit descent through a chosen cone

For a diagram `P : B ⥤ Type` and a cocone `c` with apex `α`,

```lean
Limits.colimit.desc P c : Limits.colimit P ⟶ α
```

is the unique map induced by the cone, and `colimit.ι_desc_apply` computes it
on representatives.

The codomain `α` is chosen with the cone. Category theory does not force it
to be `ℝ`. A real cone reads real information; a complex or richer cone can
read different information already preserved by the same diagram.

The induced map reads compatible data. It does not create a value after the
quotient.

## 7. Separation rules

Keep distinct:

1. Riehl's finality criterion;
2. the category-of-elements identity inside its proof;
3. Remark 8.3.5 on connectedness and singleton `π₀`;
4. the separate `pi0GrothendieckEquiv`;
5. the universal colimit cocone;
6. the generic `pi0Cocone`;
7. any project-specific cone chosen from the completed action.

Never call the generic components equivalence “the entire readout.”
