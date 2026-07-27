# Riehl-CTIC — E. Riehl, "Category Theory in Context" (CTIC)

**A SECOND, DISTINCT RIEHL BOOK.** `SOURCES/Riehl.md` documents *Categorical Homotopy Theory* (CHT),
which is where Lemma 8.3.4, Remark 8.3.5, and the category-of-elements identity live. This file
documents *Category Theory in Context*, which is where the orbit–stabilizer categorification, the
subfunctor criterion, and the fully faithful category-of-elements construction live. **The statement
numbering collides between the two books** — an earlier thread cited "Lemma 8.3.4 (Cat-in-Context,
p.102)", crossing them. Always name which book.

## Bibliographic record (verified live 2026-07-26)

- Book: Emily Riehl, *Category Theory in Context*, Dover Publications, 2016 (title page of the free
  PDF reads "Category Theory in Context / Emily Riehl").
- Free PDF: `https://emilyriehl.github.io/files/context.pdf`, listed on the author's own books page
  `https://emilyriehl.github.io/books/` — the same page that hosts `cathtpy.pdf`. Fetched
  to `inbox/context.pdf`; 1,585,443 bytes, 296 PDF pages, PDF 1.7, full text layer. Re-downloaded
  from the author on 2026-07-26 and verified byte-for-byte identical, with SHA-256
  `0aa3402d3ba0fb6c7f3d7dd1ab70e6b4d452a25d02a97293f8672258f7a87cbb`.
- The author's books page carries the arrangement note recorded in `SOURCES/Riehl.md`: free to view
  and download for personal use only, not for re-distribution, re-sale, or use in derivative works.

## Pinpointed statements (VERBATIM)

Extracted from `inbox/context.pdf` via the pypdf text layer, 2026-07-25. Transcription conventions:
the PDF text layer drops most inter-token spacing and renders the integral sign of the
category-of-elements notation as a bare `R`; both are restored below and marked. Book page numbers
are taken from the running headers of the same pages.

### Example 1.5.19 — *a categorification of the orbit-stabilizer theorem* (book p. 37 = PDF p. 57)

> Example 1.5.19 (a categorification of the orbit-stabilizer theorem). Let `X : BG → Set` be a left
> `G`-set. Its **action groupoid** `X//G` has elements of the set `X` as objects. A morphism
> `g : x → y` is an element `g ∈ G` so that `g · x = y`. The objects in the skeleton `sk(X//G)` are
> in bijection with the connected components in the action groupoid. These are precisely the
> **orbits** of the group action, which partition `X` in precisely this manner.
>
> Consider `x ∈ X` as a representative of its orbit `O_x`. Because the action groupoid is equivalent
> to its skeleton, we must have `Hom_{sk(X//G)}(O_x, O_x) ≅ Hom_{X//G}(x, x) =: G_x`, the
> automorphisms of `x` in `X//G`. This group consists of precisely those `g ∈ G` so that `g · x = x`.
> In other words, the group `Hom_{X//G}(x,x)` is the **stabilizer** `G_x` of `x` with respect to the
> `G`-action. Note that this argument implies that any pair of elements in the same orbit must have
> isomorphic stabilizers. There are no morphisms between distinct objects in a skeletal groupoid.
> Hence, the skeleton of the action groupoid is the disjoint union of the stabilizer groups, indexed
> by the orbits of the action of `G` on `X`.
>
> The set of morphisms in the action groupoid with domain `x` is isomorphic to `G`. This set may be
> expressed as a disjoint union of hom-sets `Hom_{X//G}(x,y)`, where `y` ranges over the orbit `O_x`.
> Each of these hom-sets is isomorphic to `Hom_{X//G}(x,x) ≅ G_x`. In particular,
> `|G| = |O_x| · |G_x|`, proving the **orbit-stabilizer theorem**.

This is the passage the author remembered, and it is titled exactly that.

### Exercise 2.1.iv — subfunctors (book p. 59 = PDF p. 79)

> 2.1.iv. A functor `F` defines a **subfunctor** of `G` if there is a natural transformation
> `α : F ⇒ G` whose components are monomorphisms. In the case of `G : C^op → Set`, a subfunctor is
> given by a collection of subsets `Fc ⊂ Gc` so that each `Gf : Gc → Gc′` restricts to a function
> `Ff : Fc → Fc′`. Characterize those subsets that assemble into a subfunctor of the represented
> functor `C(−,c)`.

The operative clause is the second sentence: **the transition maps must restrict.** That closure
condition is what makes an objectwise choice a subdiagram rather than a collection of selected
objects.

### Example 2.4.10 — the category of elements of a `G`-set is the action groupoid (book p. 75 = PDF p. 95)

> Example 2.4.10. The category of elements of a `G`-set `X : BG → Set` is isomorphic to the action
> groupoid `X//G` introduced in Example 1.5.19: its objects are elements `x ∈ X` and its morphisms
> `g : x → y` are elements `g ∈ G` so that `g · x = y`. By Example 2.3.7, if `X` is representable,
> then any element of `X` may be chosen as a universal element. By Proposition 2.4.9, it follows that
> `X` is representable if and only if `∫X ≅ X//G` is a contractible groupoid.
>
> We now prove the claim made in Example 2.3.7, that any free and transitive left `G`-set is
> representable. If the action of `G` on `X` is free and transitive, then for each pair of elements
> `x, y ∈ X`, there exists a unique `g ∈ G` so that `g · x = y`. This tells us that there is a unique
> morphism in each hom-set of the action groupoid `X//G` or equivalently the category of elements
> `∫X`. Thus, these categories are contractible groupoids …

*(`∫` restored from the text layer's bare `R`.)*

Note the quantifier: **free and transitive** gives contractibility. A transitive action that is not
free gives a connected groupoid retaining a nontrivial stabilizer.

### Proposition 2.4.14 — the category of elements is fully faithful into `CAT/C` (book p. 77 = PDF p. 97)

> 2.4.14. The construction of the category of elements defines fully faithful functors
> `Set^C → CAT/C` and `Set^{C^op} → CAT/C` whose essential image, in the case of covariant
> `C`-indexed functors, is the full subcategory of **discrete left fibrations**, and whose essential
> image, in the case of contravariant `C`-indexed functors, is the full subcategory of **discrete
> right fibrations**.
>
> In particular, the projection functor `Π : ∫F → C` away from the category of elements is a discrete
> left fibration if `F` is covariant and a discrete right fibration if `F` is contravariant.
> Proposition 2.4.14 asserts further that this property characterizes the functors produced by the
> category of elements construction. Moreover, by fully faithfulness, natural transformations
> `α : F ⇒ G` can be identified with functors `∫α : ∫F → ∫G` over `C`.

*(`∫` restored from the text layer's bare `R`; the displayed diagram of the two functors is rendered
inline.)*

The last sentence is the one the project uses: **a natural transformation of diagrams is the same
thing as a functor of their totals over the base.** Note also that the covariant case gives a
discrete **left** fibration — consistent with the covariant Grothendieck construction being an
opfibration.

## Deep-dive extraction, 2026-07-27 — the skeleton warning and the contractibility rung

Added at the author's request ("some are clearer than others for this particular application").
Extracted from the local `inbox/context.pdf` text layer **and** verified against 150-dpi ghostscript
renders of the same pages read as images — the second pass the GAPS section below previously
recorded as impossible on this machine. The `≅` signs the text layer drops are restored from the
renders and marked.

### The skeleton warning (book p. 37 = PDF p. 57) — VERBATIM, replacing the earlier paraphrase

> "no reason that a functor `F : C → D` would necessarily restrict to define a functor between the
> chosen skeletal subcategories. It is possible to choose a functor `skF : skC → skD` whose
> inclusion into `D` is naturally isomorphic to the restriction of `F` to `skC`, but these choices
> **will not be strictly functorial**."

and its footnote 42, on the same page:

> "There is, however, a *pseudofunctor* `sk(−) : CAT → CAT`, but a precise definition of this
> concept is beyond the scope of this text."

This is the sharpest form of the project's rule against choosing representatives: skeletonization is
only a **pseudofunctor**. The residue gate's datum is a *natural transformation*, so a skeletal
choice could not have carried it even in principle.

### Example 1.5.18(i) (book p. 37) — what a skeleton keeps, and what it discards

> "The skeleton of a connected groupoid is the group of automorphisms of any of its objects (see
> Proposition 1.5.13)."

Read against Ex. 1.5.19's "there are no morphisms between distinct objects in a skeletal groupoid":
the skeleton of a connected groupoid **retains the stabilizer and discards every arrow witnessing
the connectedness** — exactly the data the component calculation consumes.

### Proposition 2.4.9 (book p. 75 = PDF p. 95) — where "contractible" actually enters CTIC

> "For any functor `F : C → Set`, the full subcategory of `∫F` spanned by its representations is
> either empty or a contractible groupoid."

Its proof supplies the operative definition, via Lemma 1.6.16:

> "the subcategory spanned by the initial objects is either empty or is a contractible groupoid:
> there exists a **unique** (iso)morphism between any two initial objects."

### Example 2.4.10, completed (book p. 75)

> "By Proposition 2.4.9, it follows that `X` is representable if and only if `∫X ≅ X//G` is a
> contractible groupoid."
>
> "If the action of `G` on `X` is free and transitive, then for each pair of elements `x, y ∈ X`,
> there exists a unique `g ∈ G` so that `g · x = y`. This tells us that there is a **unique**
> morphism in each hom-set of the action groupoid `X//G` … Thus, these categories are contractible
> groupoids …"

*(`∫` restored from the text layer's bare `R`, confirmed on the render.)*

### What this settles for the project

The two books give a ladder of collapses, and the project sits on a named rung of it:

| collapse | hypothesis | citation |
|---|---|---|
| `π₀` is a singleton | **non-empty + connected** | CHT Rem. 8.3.5, p. 102 |
| `∫F` contractible (unique iso between any two objects) | action **free** and transitive | CTIC Prop. 2.4.9 + Ex. 2.4.10, p. 75; Lem. 1.6.16 |
| nerve contractible (`EG`) | translation groupoid: unique morphism per hom-set | CHT Ex. 8.5.4, p. 104 |

**The discriminator is freeness, and the project's action is transitive and not free** — the
stabilizers (`NorthStabilizer` horizontally, the sphere-direction stabilizer vertically) are
retained deliberately. So the correct claim is *connected with stabilizers*, which is precisely and
only what Remark 8.3.5 consumes. **Contractibility must never be asserted here**; it is a strictly
stronger statement and it is false of this action.

## How these are used in this project — and how they are not

- Riehl states 2.1.iv and 2.4.14 for **`Set`-valued** diagrams. The project's fibres are groupoids,
  not sets, so the passage from a natural transformation to a functor of totals is taken from
  Mathlib's `CategoryTheory.Grothendieck.map` (`Grothendieck.lean:242`), with
  `Grothendieck.functor_comp_forget` (`:269`) recording that the induced functor lies over the same
  base. CTIC is the conceptual source; Mathlib is the implementation.
- Example 1.5.19 is the **geometric interpretation** — components are orbits, automorphisms are
  stabilizers — not a project object. The project's own orbit–stabilizer machinery is already green:
  `orbitRep_spec`, `orbit_stabilizer_factor`, `stabilizerPart_id`/`_comp` in
  `Concentricity/ProjectiveSection.lean`.
- Riehl warns immediately before 1.5.19 that choosing skeletal representatives is not in general
  strictly functorial ("there is no reason that a functor `F : C → D` would necessarily restrict to
  define a functor between …", book p. 37). This is why the project's north objects must be produced
  by the distinguished action and its existing transports, never selected as a hand-chosen skeleton.

## GAPS

- **Partly closed 2026-07-27.** The deep-dive section above adds the p. 37 skeleton warning with
  footnote 42, Example 1.5.18(i), Proposition 2.4.9 with its Lemma 1.6.16 definition, and the
  remainder of Example 2.4.10. Still not transcribed: section 2.3, Lemma 2.4.7, Propositions 2.4.8
  and 1.5.13, Lemma 1.6.16's own statement in situ, and Exercise 2.4.viii, to which 2.4.14 defers
  its full-faithfulness proof.
- Book page numbers are taken from the free PDF's running headers. The Dover printed edition was not
  consulted; if pinpoint cites to the printed edition are needed, that check is outstanding.
- ~~Quotes were extracted from the pypdf text layer only… `pdftoppm` is not installed.~~
  **Closed 2026-07-27 for pp. 37 and 75.** `pdftoppm` is indeed absent, but ghostscript
  (`/opt/local/bin/gs`) is present; PDF pp. 57 and 95 were rendered at 150 dpi and read as images,
  and every quotation from those two pages — including the four original Example 1.5.19 clauses —
  matches the text layer, with the dropped `≅` signs restored from the renders. The remaining
  original quotations (Exercise 2.1.iv, PDF p. 79; Proposition 2.4.14, PDF p. 97) are still
  text-layer only.
