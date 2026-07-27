---
name: orbit-stabilizer-groupoids
description: Apply orbit–stabilizer theory through action groupoids in Lean and in the Concentricity project. Use for action categories, groupoid components and stabilizers, quotient–orbit equivalences, orbit subgroupoids, groupoid preimages, natural transformations, G₂ transport, GL/PGL/Möbius actions in SphereWorld, the A-specific residue natural-inclusion gate, Riehl Remark 8.3.5, connected components, pi0GrothendieckEquiv, and the concentricity readout.
---

# Orbit–stabilizer groupoids

Treat the action groupoid as the categorification of the action. Its objects
are points, its arrows are acting group elements, its connected components
are orbits, and its vertex automorphism groups are stabilizers.

For Concentricity work, first read `register/00-register.md`,
`CURRENT_GATE1_MEMORY.md`, and `EndgamePlan.md`. The project register fixes
the subject and gate. This skill supplies the generic theory, the Lean
dictionary, and the exact instantiation; it never replaces the register.

## Absolute categorical-level lock for Concentricity

Remain inside this exact register:

```text
natural transformation
  → orbit subgroupoid
  → groupoid preimage
  → AsectionActionDiagram A.
```

The current outer target is:

```lean
AsectionCResidueInclusion A :
  AsectionCResidueDiagram A ⟶ AsectionActionDiagram A
```

This rule is unconditional:

1. `𝓡_A(X)` is the already-certified groupoid preimage selected orbit-wise
   inside the action groupoid. Never replace or re-express it as a new
   static predicate, set, carrier, essential image, or arrow-indexed
   inverse image.
2. An object assignment or component source may depend only on `A` and `X`,
   never on a free `f` or target `Y`. A free `f` belongs only to the diagram
   map and naturality fields after the objects are fixed.
3. Never turn structural orbit closure into a preservation, invariance, or
   stabilizer theorem. Action-groupoid arrows remain in their orbits and
   stabilizers are vertex automorphisms.
4. Generic `ObjectProperty.lift`, full-subcategory, and inverse-image
   machinery may occur only inside the final A-specific diagram and natural
   transformation. None may become the subject.
5. The literal `positionedOrbitSquare A f (1 : Moebius)` must be consumed by
   the final registered construction. A neighboring `example` does not
   count.
6. If any proposed term leaves this register, reject it even when it
   elaborates. Resume from the outer natural-transformation type; do not
   diagnose or repair the substitute.

## Read the targeted references

1. Read `references/theory-and-citations.md` for Riehl’s statements and
   citation-ready provenance.
2. Read `references/lean-dictionary.md` before writing Lean involving an
   action groupoid, invariant full subgroupoid, restriction, or totalization.
3. Read `references/concentricity-instantiation.md` for `G₂`,
   `SphereWorld`, `GL`/`PGL`/`Moebius`, `F_A`, `𝓡_A`, and the current
   preservation gate and readout stack.

## Continuous register checkpoint

For Concentricity proof work, keep this checkpoint active throughout one
uninterrupted registered kernel loop. State it:

1. when the real target, theorem, and intended bundled term are fixed, before
   the first edit or elaboration;
2. immediately before every kernel certification.

It is an invariant, not a separate pre-flight phase or a stopping boundary.

State:

```text
REGISTER CHECK
gate:
target file:
active theorem:
mathematical provenance:
approved supplier:
instantiated A-specific object:
intended proof term:
```

All entries must occur in the approved library and naming table in
`references/concentricity-instantiation.md`. A generic Mathlib theorem may
appear only together with the exact A-specific object at which it is being
instantiated.

### Kernel consumers instantiate the authored object

Here, a **consumer** is an object-instantiating kernel receipt, not an
illustrative example. Lean may use the `example` command as syntax, but every
such receipt must quantify over and visibly consume the exact authored
functorial objects:

```text
F_A(X), F_A(Y), F_A(f),
𝓡_A(X), 𝓡_A(Y), 𝓡_A(f),
ι_X, ι_Y, and the naturality square of ι_A at f.
```

A check of generic `ObjectProperty.lift`, a generic full subcategory, or an
arbitrary functor does not certify this gate. Generic category theory supplies
the construction shape; the certificate is its elaborated instantiation at
Jesse's categorified orbit--stabilizer diagram.

The pointwise goal Lean displays is the objectwise shadow of that functorial
construction, never the subject replacing it.

**`mathematical provenance` closes the loop to the sources — in three kinds,
and the third is the normal case here.**

1. **Generic categorical** — CTIC (`SOURCES/Riehl-CTIC.md`), CHT
   (`SOURCES/Riehl.md`), or a pinned Mathlib statement. Supplies the *shape*:
   restriction criteria, `ObjectProperty.lift`, `Grothendieck.map`, component
   calculations.
2. **External analytic literature** — the octonionic and winding sources in
   `SOURCES/` (VS, GPVwind, and the rest). Example: `pr1_Eexp`
   (`LogManifold.lean:362`) is the commuting triangle `π ∘ E = exp`, cited
   verbatim to VS Rem 5.2(a) and proved `rfl`.
3. **Authored construction** — a fact about the distinguished element that
   follows from C1–C4 and exists nowhere outside this project. Identified by
   **its register statement plus its live Lean supplier chain**, never by a
   citation.

⛔ **Do not require a textbook row for an authored fact.** In the current
`ι_A` checkpoint, the exact authored input is already the functor
`AsectionActionDiagram A`, whose object map is `AsectionActionFiber A X` and
whose arrow map is `AsectionActionTransport A f`. Demanding a separate
invariance citation or theorem after that functor has been built sends the
reader hunting for a generic result that does not exist and replaces the
restriction gate with a pointwise strawman.

The literature supplies general forms; the author's constructions supply the
particular objects and the load-bearing hypotheses. For A-specific steps,
kind 3 is the ordinary case and kind 1 is what applies *afterwards*, once the
authored witness exists. Record both columns; do not force an authored step
into a textbook row.

Kind 3 is not a free pass. It is discharged the same way as the others — by
naming the register statement that asserts it and the exact live declarations
that carry it, then elaborating. What changes is the source of authority, not
the standard of evidence.

### The test is whether the proof term can be named — not how many rewrites it has

**One obligation, one certificate.** A proof that internally rewrites five
times is still one step if its term can be stated before the file is opened:
*"the `calc` chain of `register/70-whole-square.md` §5, closing on the target's
own `positioned_by_action`"* is a named term. Do **not** split a short proof
into several gates — that manufactures ceremony and, worse, invites a chain of
certificates that each live on one face.

The trigger is narrow: **if the intended proof term cannot be named at all,
the obligation is not yet understood.** Then, and only then, work out its
parts. This is not a licence to decompose by default.

`mathematical provenance` may name more than one source when the term legitimately
composes several; one line per obligation, not one line per rewrite.

### Kernel contact precedes diagnosis

**No claim about what a goal requires may be made except by quoting elaborator
output.** Writing a term into an unbuilt file is *written*, never
*instantiated*, *verified*, or *consumed* — use the accurate word. A supplier
audit may be opened only against a printed goal.

An elaborator goal is never promoted to a new problem statement. It remains a
projection of the last registered functorial term. Resume from that term, not
from the goal's surface syntax.

This is stricter than "print the stuck goal and say so": it forbids speaking
about a goal that has never been produced. A report of supplier insufficiency
derived from reading rather than elaboration is a claim about the register,
not about the mathematics.

If an entry points to a scratch, temporary, retired, attic, archive,
exploration, alternate-tree, or unapproved file:

1. stop the proof action;
2. return to this skill and the project register;
3. classify the drift using `register/60-failure-audit.md`;
4. report the classification;
5. resume only from the last approved supplier.

Do not reinterpret a drift as a mathematical obstruction. Do not continue
until the checkpoint passes.

## Registered kernel loop

**Step 0 — the TARGET-FIRST GATE (mandatory, mechanical, 2026-07-27).** The
audit file's first content is the requested OUTER declaration consumed at its
exact ratified type, e.g.:

```lean
#check ASection.AsectionCResidueDiagram

example (A : ASection) :
    ASection.AsectionCResidueDiagram A ⟶
      ASection.AsectionActionDiagram A :=
  ASection.AsectionCResidueInclusion A
```

That block must compile before any subsidiary audit counts. Rules:

1. The final declaration's signature is written before its body; no helper
   construction begins first.
2. A natural-transformation component at `X` may mention only `A` and `X` in
   its source type — never a free `f` or `Y`. **No declaration depending on
   a free arrow can be accepted as `ι_A`.**
3. A certificate may be announced only when the audit literally consumes the
   requested declaration at its requested outer type; certifying helper
   declarations does not count.
4. The bundled diagram and bundled natural transformation are audited first;
   the `d = 1` square, `liftCompιIso`, examples, and axiom prints come after.
5. Previously certified machinery is named in the preflight and visibly
   consumed by the final term; reimplementing its pattern is forbidden.
6. If the exact signature fails to elaborate, the only permitted output is
   Lean's exact goal — never a nearby substitute construction.

The gate is kernel-enforced, not interpretive: neither the author's nor the
auditor's manual catch is the mechanism.

1. Lock the theorem, A-specific object, intended bundled term, implementation
   file, audit file, and exact focused commands together.
2. Put the intended term in the real theorem and immediately elaborate that
   implementation file.
3. At a stop, quote the exact goal and check that the whole bundle remains
   present: square, commuting field, source and target provenance, and the
   arbitrary-parameter reindexing supplier.
4. Continue the same theorem under the same command. Supplier resolution is
   part of this loop; it is never a completed phase of its own.
5. Once the theorem closes, complete the exact-object kernel instantiation
   receipts and axiom prints immediately. Do not substitute generic or
   illustrative examples.
6. Run the focused certificate without switching registers.
7. Observe any gate-specific hard stop recorded in `register/70-whole-square.md`.

The unit of completion is the triple certificate. There is no terminal state
between stating the registered term and `#print axioms` reporting the three
foundations.

## Whole-structure consumption checkpoint

Before reporting a missing supplier or searching outside the approved source
row, distinguish **naming** a structure from **consuming** it. For a
preservation square, record:

```text
WHOLE-SQUARE CHECK
instantiated square:
commutes field consumed:
source provenance consumed:
target provenance consumed:
all-parameter supplier consumed:
exact remaining Lean goal:
```

Writing `let square := ...` in an unbuilt file is not a verified
instantiation. Even after elaboration, merely binding the square, projecting
one leg, or reasoning about that leg does not pass this check. First compose
`square.commutes` with the source and target provenance fields and keep the
square term present. For Concentricity, read the exact all-parameter inventory in
`references/concentricity-instantiation.md`.

Only a remaining goal produced after this composition can trigger a supplier
audit. Inspect the approved source row first. A repository-wide search may
locate a declaration, but it cannot approve one; a hit in a preflight,
quarantined namespace, retired route, or alternate folder is a location
failure and must not be promoted.

## Workflow

1. Name the acting group `G`, the acted-on type `X`, and the live action.
2. Identify the action groupoid `ActionCategory G X`; do not replace it by
   a discrete category or a selected skeleton.
3. Read components as orbits and endomorphisms as stabilizers. Use
   `MulAction.orbitEquivQuotientStabilizer` for the set-level quotient–orbit
   equivalence and `ActionCategory.stabilizerIsoEnd` for the groupoid-level
   vertex group.
4. For Concentricity, keep the already-certified
   `InverseImageCResidueStateWorldGroupoid A X` as the orbit-wise groupoid
   preimage. Do not define another subsystem.
5. Instantiate the previously certified categorical construction directly
   at `AsectionActionDiagram A`. Any formal `ObjectProperty.lift` argument
   is an internal packaging field supplied in that instantiation, never a
   new pointwise theorem to analyze.
6. Assemble the fixed diagram and its natural inclusion at the required
   outer types. Take identity, composition, fullness, faithfulness, and the
   inclusion square from the existing functorial machinery; do not rebuild
   them.
7. Audit the bundled natural transformation first. Only afterward inspect
   its component at free `X` and naturality at free `f`. Use functor
   composition `⋙`; remember that action-category labels compose in reverse
   multiplication order.
8. Apply `Grothendieck.map` only after the subdiagram and natural inclusion
   are certified.
9. Recognize the resulting residue total through the already-built action
   groupoid and its orbit–stabilizer presentation. Do not introduce a second
   action or prove topological connectedness.
10. Apply CHT Remark 8.3.5 only in its categorical sense: the already
    inhabited, categorically connected action groupoid has a singleton
    `ConnectedComponents` carrier.
11. Instantiate `pi0GrothendieckEquiv` at the named residue diagram, then
    descend the already-compatible real-level orbit invariant to the named
    reader and centre.

## Concentricity discipline

- Read `G₂` and the Möbius/projective action as two categorical directions
  of the same distinguished element, not two generators.
- In `SphereWorld`, retain both `SphereHom.rot : G2` and
  `SphereHom.mob : Moebius`.
- Distinguish the exact live groups:
  `Moebius` is the image of `GL(2,ℂ)` as self-maps of `OnePoint ℂ`;
  `GreatCircle.Aut` is `PGL(2,ℝ)`; `cayleyProjective` maps the real
  projective action into `Moebius`.
- Never promote a presentation transport directly to a state transport.
  Prove their comparison at the named project objects.
- Treat the approved endgame as one implementation gate with internal
  kernel checkpoints. Do not turn a routine later checkpoint into a new
  mathematical gate or leave the approved module chain.

## Verification

Before reporting completion:

1. show the exact acting groups, action groupoids, orbit, and stabilizer;
2. show with free `X`, `Y`, and `f` that
   `F_A.obj X = AsectionActionFiber A X` and
   `F_A.map f = AsectionActionTransport A f`;
3. show the A-specific restricted map, both inclusion components, and the
   `liftCompιIso` naturality square;
4. identify the exact action groupoid, orbit, stabilizer, and named
   component carrier used for Remark 8.3.5;
5. distinguish categorical connectedness from topological connectedness;
6. show the exact `pi0GrothendieckEquiv` instantiation and real-level
   descent;
7. run the focused Lean build;
8. print the axiom surface and check for `sorry`, `admit`, and new axioms.
