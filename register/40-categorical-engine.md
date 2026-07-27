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

- a category is categorically connected exactly when every pair of objects
  is joined by a finite zigzag;
- a category is nonempty and categorically connected exactly when its `π₀`
  is a singleton.

`π₀` reads the components of the category supplied to it. It does not prove
that a project-specific family belongs to one component.

This is categorical connectedness only. It is not topological connectedness
of an object space, zero locus, or sphere.

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
read.

**Status corrected 2026-07-25 (author's ruling).** An earlier version of this
file called the passage "literature backing … not authorization to create a
category of elements as a project object," and `SOURCES/Riehl.md` carries the
same commentary. That demotion is **superseded**. The el-identity is the
*mechanism*: it is what turns a chosen transport system into its colimit
class, and with Remark 8.3.5 it is what yields the singleton. The verbatim
Riehl quotation in `SOURCES/Riehl.md` stands untouched; only the commentary
around it is superseded.

Mathlib makes the connection literal — a category of elements **is** a
Grothendieck construction:

```lean
grothendieckTypeToCat : Grothendieck (G ⋙ typeToCat) ≌ G.Elements
```

(`Mathlib/CategoryTheory/Grothendieck.lean:404`), so `el X` is not a foreign
object standing beside `∫`; it is `∫` applied to a `Type`-valued diagram.

What remains forbidden is *inventing* a category of elements to hunt for a
project meaning afterwards. The chosen system is read first; the generic name
is assigned to it after.

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

**How it relates to §4.** This is the `Grpd`-valued extension of the
el-identity, not an unrelated theorem. Specialize `F` to discrete fibres,
`F = X ⋙ typeToCat` for `X : B ⥤ Set`: then `π₀ ∘ F = X`, and by
`grothendieckTypeToCat` the source is `el X`, so the statement becomes
Riehl's `π₀(el X) ≅ colim X` exactly. Groupoid fibres are the general case;
the discrete case is Riehl's.

So §3, §4, §5 and Remark 8.3.5 are **consecutive layers of one engine**, not
independent results. Keeping their statements distinct (§7) is a discipline
about which statement is being cited, never a claim that they are unrelated.

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

**Project-route distinction.** The generic theorem permits many cocones and
apices. In the locked Concentricity route, however, the completed action
already supplies a particular `ℝ`-valued real-level orbit invariant. Its
compatibility means it factors uniquely through the orbit/component
quotient; the corresponding cocone expresses that fixed invariant. Thus
generic codomain freedom does not create a project-level ambiguity in
`val_A`.

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

Distinct **statements**, one **engine**. Keeping them apart is about citing
the right statement; it is not a claim that they are unrelated results, and
separating them so hard that the specialization chain is severed is its own
error (recorded 2026-07-25).

## 8. Citation map for the locked endgame

Two **different** Riehl books, with colliding statement numbers. Always name which.

| endgame step | statement | source |
|---|---|---|
| an objectwise choice is a **subdiagram** only when every transition map restricts to it | Exercise 2.1.iv (subfunctors) | CTIC, book p. 59 — `SOURCES/Riehl-CTIC.md` |
| a natural transformation of diagrams **is** a functor of their totals over the base | Proposition 2.4.14 (`Set`-valued; fully faithful into `CAT/C`, covariant image = discrete left fibrations) | CTIC, book p. 77 — `SOURCES/Riehl-CTIC.md` |
| the same passage for **groupoid** fibres, as actually used | `Grothendieck.map` + `functor_comp_forget` | Mathlib `Grothendieck.lean:242`, `:269` |
| components are orbits, automorphisms are stabilizers; representatives must not be hand-chosen | Example 1.5.19 (*"a categorification of the orbit-stabilizer theorem"*) | CTIC, book p. 37 — `SOURCES/Riehl-CTIC.md` |
| the category of elements of a `G`-set **is** the action groupoid; free + transitive ⇒ contractible, transitive alone ⇒ connected with stabilizer retained | Example 2.4.10 | CTIC, book p. 75 — `SOURCES/Riehl-CTIC.md` |
| finality criterion: `K` final ⇔ every `d/K` non-empty and connected | Lemma 8.3.4 | **CHT**, book p. 101 — `SOURCES/Riehl.md` |
| `π₀(el X) ≅ colim_C X`, arrows are forced identifications in any cone | inside 8.3.4's proof | **CHT**, book p. 102 — `SOURCES/Riehl.md` |
| non-empty + connected ⇔ `π₀` a singleton | Remark 8.3.5 | **CHT**, book p. 102 — `SOURCES/Riehl.md` |
| `π₀(∫F) ≃ colim(π₀∘F)` for `Grpd`-valued `F` | `pi0GrothendieckEquiv` / master `lem:pi0-grothendieck` | `Concentricity/Theorem.lean:108`, `:144` |
| the Grothendieck construction / categories fibered in groupoids | §3.1 | Vistoli — **not yet transcribed**; master bibitem only |

CTIC states 2.1.iv and 2.4.14 for `Set`-valued diagrams. The project's fibres are groupoids, so CTIC
is the conceptual source and Mathlib is the implementation. Do not cite 2.4.14 as if it covered the
groupoid case directly.

## 9. Naming discipline

Generic constructions are **applied to** the author's objects. The result gets
an A-specific name; the generic name never becomes the subject.
`Grothendieck.functor` is not a rival to his total — it is what produces it,
just as `pi0GrothendieckEquiv` is stated for arbitrary `F` and instantiated at
his. That two terms are not literally the same Lean term is a fact about
names, never a mathematical objection.

Consequently: **do not name a project object in advance to fit a generic
letter.** Do not introduce a `K_A`, a zero diagram, or any other symbol and
then hunt for its project meaning. Discuss the theory with the generic
symbols; read the chosen system from the completed action; assign the generic
name to it afterwards.

## 10. Thomason's stronger comparison (held)

For a diagram of small categories `F : D ⥤ Cat`, Thomason's theorem compares
the whole homotopy type:

```text
|hocolim NF| ≃ B(∫ F).
```

`SOURCES/Thomason79.md` records the journal metadata and the displayed
statement through Sharma's quotation, with the explicit limitation that the
original paywalled article text was not fetched. `SOURCES/GJ.md` supplies
the nerve/bisimplicial machinery and Theorem B; `SOURCES/Quillen73.md` and
Riehl §8.5 supply Theorem A and homotopy-finality context.

This comparison is stronger than the `π₀` statement used by the project. It
is banked for post-Lean exposition and further formalization, not part of
the current execution route.
