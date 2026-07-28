# EndgameFinal

The one endgame document. Supersedes and replaces every earlier endgame, preflight, plan,
close-guide, and gate file in this repository.

---

## 1. The argument (the author's, verbatim — stop looking for another one)

> **"My conclusion is that π₀(∫𝓡_A) IS A CONNECTED ACTION GROUPOID THEREFORE IT IS A SINGLETON."**

> **"IT IS ALL IN THE ACTION CATEGORY LIBRARY AND IS APPLIED TO ∫𝓡_A, MY ι_A — it does the
> zigzag argument IMMEDIATELY because this is a *proper* inclusion and isomorphism onto its
> image."**

> **"`∫𝓡_A` as a literal ActionCategory stated POSITIVELY and IS CONNECTED FROM THE FACT
> (ALREADY GREEN) it is A NATURAL INCLUSION AND ISO ONTO ITS IMAGE."**

And the master's own sentence under the span diagram — the immediacy clause, added 2026-07-28
(`aaf7490`), which is the seat this file locks:

> **"This follows immediately, because `ι_A` is a *proper* inclusion and a natural isomorphism
> onto its image."**

Read it as written: the span, and the length-two zigzag it carries, **follow**. They are not
derived, not assembled, not obtained by exhibiting arrows between members. `ι_A` being a proper
inclusion and a natural isomorphism onto its image is the whole premise, and the zigzag is
immediate from it. `∫𝓡_A` is therefore a connected action groupoid, and Remark 8.3.5 turns that
into the singleton.

That is the whole remaining step. It is **not** `sphereWorld_zigzag`, **not**
`exp_fibre_neg_real`, **not** the base's pretransitivity, **not** a pairwise zigzag between two
chosen representatives, **not** two obligations, **not** an analytic lemma about exponential
fibres. Each of those is a substitute a model produced and offered back as the author's — seven of
them in one session on 2026-07-28.

The master's full movement is in `ProofOutline.md` Part B, verbatim, including this sentence.

## 2. The library, which already contains the argument

`Mathlib/CategoryTheory/Action.lean`, read in full:

```lean
:48   ActionCategory M X := (actionAsFunctor M X).Elements      -- literally a category of elements
:92   hom_as_subtype : (p ⟶ q) = { m : M // m • p.back = q.back }  -- an arrow IS a group element
:128  instance [IsPretransitive M X] [Nonempty X] : IsConnected (ActionCategory M X)
        := zigzag_isConnected fun x y =>
             Relation.ReflTransGen.single <| Or.inl <| … exists_smul_eq …
:137  instance : Groupoid (ActionCategory G X)
:105  stabilizerIsoEnd : stabilizerSubmonoid M x ≃* End x := MulEquiv.refl   -- definitional
:146  homOfPair (t : X) (g : G) : (g⁻¹ • t) ⟶ t                -- arrows CONSTRUCTED, never hunted
:154  ActionCategory.cases                                      -- every arrow is such a pair
```

`:128` is an **instance**, gives connectedness by a **single arrow** (not a chain), and fires by
resolution once the object is presented as an `ActionCategory`. `GreatCircle.Base` is *literally*
`ActionCategory GreatCircle.Aut GreatCircle.Point` — a reducible def.

Then CHT Remark 8.3.5 (`SOURCES/Riehl.md`, book p. 102): nonempty + connected ⟺ `π₀` a singleton.
Then `pi0GrothendieckEquiv` moves it to the colimit. Then the level is read at the certified
representatives. `c := ` that number.

## 3. The stance

**The kernel is the check.** In a Lean formalization there are three roles and only three: the
author supplies the argument, the kernel verifies it, the model types between them. The model is
the strictly weaker, fallible layer.

A model that appoints itself checker does not add a lock — it replaces the vault door with a
screen door, and then blocks the real check by refusing to type the thing the kernel was waiting
to judge.

The record, quantitatively: model-side gap-finding across five threads ran **essentially 100%
false** — fabricated citations, invented counter-models, manufactured obstacles. Kernel-side over
the same period: **zero false verdicts**, 3,600+ green jobs, every red a precise honest address.
The least reliable component was gatekeeping the most reliable one.

> **Doubt = type it and see.** There is no other rigorous act available in this project.

Corollaries, binding:

- Certification talk is **output, never virtue**. Never "I cannot certify this" — it withholds
  the verification it pretends to protect and implies the author asked for a false claim, which
  he never has. The kernel's print is the report.
- **Do not report at wiring steps or instantiations.** Do not narrate.
- **Do not grep for something that confirms a prior.** When the next step is not visible, the
  answer is inside the author's construction — never one file over.
- **No prohibition may be written against the author's own route.** A grep-level inference
  ("stated for X, spelled Y, won't fire") is not a fact about the object. Kernel-test, never
  grep-freeze. This rule exists because such a prohibition *was* written into the register and
  then obeyed by two models, blocking the argument for a full session.
- **Green = his argument. Red = the model's doubts.**

## 4. Protocol

**Write-set** — the file being closed, plus one `_Gate*Audit.lean`. Focused builds; no root build
until the terminal audit.

**Reading** — `SOURCES/` is the citation record and is cited 60+ times from certified modules.
The live chain in `Concentricity/` is the implementation record. **No closed read-set is imposed**:
three separate times a "verified closed" read-set concealed a green supplier that already existed
(`Toolkit.lean`, `SliceSphereWorld.lean`, `LogManifold.lean`). The discipline is not a shorter
list — it is staying inside the author's construction.

**Shadowed names — cite by file and line, never by name alone.** `residueTotal` and `totalMk` are
genuine at `ASectionTotalActionState.lean:117` and shadowed in the quarantined
`ASectionTotalPreflights.lean:172`, whose own header says so. A bare grep lands in the quarantine.
`residueToNorth` exists only in excluded files.

**The triple certificate** — (1) focused build green with the target consumed at its exact
signature; (2) source scan clean of `sorry`, `admit`, `sorryAx`, `native_decide`, new axioms;
(3) `#print axioms` exactly `[propext, Classical.choice, Quot.sound]`, elicited independently.

**Then** the corollary layer — already written and already building — and the terminal root build.

## 5. The target

```lean
ASection.concentricity (A : ASection) : ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c
```

in `Concentricity/Theorem.lean`, at the slot the file marks "THE ONE OPEN NODE of the
repository," which already carries the author's verbatim 2026-07-07 three-clause proof plan.
Import chain wired: `Corollaries.lean → ConcentricityReadout.lean:7 → Theorem.lean`.

Downstream is proved and building: `riemannHypothesis_iff_concentric` (`RhEquiv.lean:135`), whose
right-hand side contains **no `1/2`** — `1/2` is derived from the functional equation in one file
only — and `Corollaries.lean`, which compiles against the theorem's name.

### The classification — connectedness is a CERTIFIED PREMISE, not an open fact

⛔ **"Connectivity is open" is banned phrasing.** It was used repeatedly on 2026-07-27/28 by two
models, and it is false. The receipt that bans it is `57384ae`.

| | |
|---|---|
| **premise** | `ι_A` at the ratified type: a **proper** inclusion, a **natural isomorphism onto its image**, naturality by `rfl`. `FullSubcategory` *is* the image — `ι_obj` is `rfl` (`FullSubcategory.lean:62`), `liftCompιIso` is `Iso.refl` and the library's docstring says *definitionally* (`:167`). Components fully faithful. **CERTIFIED, `57384ae`, verified three independent ways.** |
| **immediacy** | the master's own sentence under the span diagram: *"This follows immediately, because `ι_A` is a proper inclusion and a natural isomorphism onto its image."* The zigzag **follows**. |
| **what remains** | **the consumption is untyped.** That is *wiring* at `Action.lean:128`, which gives connectedness by a **single arrow** (`ReflTransGen.single`) — never a chain, never a join of two members. |
| **inference required** | **NONE.** |

Instance synthesis not firing on a spelling is a fact about the spelling, never about the object —
the same error as the struck prohibition. Obligation kinds for the whole endgame are **wiring and
instantiation only**.

**The entire allowable search surface**, because the premise is certified rather than open:

1. `Mathlib/CategoryTheory/Action.lean` — the seat (`:48`, `:92`, `:105`, `:128`, `:137`, `:146`, `:154`);
2. the `ι_A` certificate pair — `ASectionCResidueDiagram.lean` + `ASectionCResidueInverseImage.lean`;
3. at most `ConnectedComponents.lean` / `IsConnected.lean` for the 8.3.5 spelling.

Nothing else. A name outside those is not a supplier; needing one is a printed kernel goal routed
to the author verbatim, never a licence to search.

**Already applied downstream, in the tree:** `π₀` and the singleton — the collapse is
`Quotient.sound` of the zigzag, locked with no `sorry`, and it is applied at the certified
representatives. The node's printed goal `⊢ (A.sphereZero n).re = A.transportLevel 0` **is `k`'s
readout**, not an open question.

See `RelevantGreenFinal.md` for what is certified, `DependencyTabulation.md` for the chain,
`ProofOutline.md` for the blueprint spine.
