---
name: orbit-stabilizer-groupoids
description: Apply orbit–stabilizer theory through action groupoids in Lean and in the Concentricity project. Use for action categories, groupoid components and stabilizers, quotient–orbit equivalences, invariant full subgroupoids, ObjectProperty.lift, natural inclusion squares, G₂ transport, GL/PGL/Möbius actions in SphereWorld, the residue-subdiagram preservation gate, Riehl Remark 8.3.5, connected components, pi0GrothendieckEquiv, and the concentricity readout.
---

# Orbit–stabilizer groupoids

Treat the action groupoid as the categorification of the action. Its objects
are points, its arrows are acting group elements, its connected components
are orbits, and its vertex automorphism groups are stabilizers.

For Concentricity work, first read `register/00-register.md`,
`CURRENT_GATE1_MEMORY.md`, and `EndgamePlan.md`. The project register fixes
the subject and gate. This skill supplies the generic theory, the Lean
dictionary, and the exact instantiation; it never replaces the register.

## Read the targeted references

1. Read `references/theory-and-citations.md` for Riehl’s statements and
   citation-ready provenance.
2. Read `references/lean-dictionary.md` before writing Lean involving an
   action groupoid, invariant full subgroupoid, restriction, or totalization.
3. Read `references/concentricity-instantiation.md` for `G₂`,
   `SphereWorld`, `GL`/`PGL`/`Moebius`, `F_A`, `𝓡_A`, and the current
   preservation gate and readout stack.

## Automatic register checkpoint

For Concentricity proof work, perform this checkpoint twice:

1. after the first proof action and before any second proof action;
2. immediately before every kernel certification.

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

⛔ **Do not require a textbook row for an authored fact.** That the whole
A-action preserves its own semantic residue kernel is not a theorem of any
external text and cannot be, because the object is the author's. Demanding a
citation for it sends the reader hunting for a generic theorem that does not
exist — and an agent that cannot fill a required field will either manufacture
a citation or report a gap. Both are the recorded failure mode.

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

`cited theory fact` may name more than one citation when the term legitimately
composes several; one line per obligation, not one line per rewrite.

### Kernel contact precedes diagnosis

**No claim about what a goal requires may be made except by quoting elaborator
output.** Writing a term into an unbuilt file is *written*, never
*instantiated*, *verified*, or *consumed* — use the accurate word. A supplier
audit may be opened only against a printed goal.

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
4. Define an invariant subsystem objectwise as an `ObjectProperty` and its
   `FullSubcategory`. Preserve its provenance as an inverse image when that
   is how it is obtained.
5. Prove the single restriction witness:

   ```text
   P_X(x) → P_Y(F(f)(x)).
   ```

   Compose existing action/naturality squares. Do not install invariance by
   saturation or redefine the property during the proof.

   ⛔ **When `P` is a membership, the witness is an output of the square,
   never an input to it.** Opening the hypothesis and offering its own
   witness back for the target — `refine ⟨z, hz, ?_⟩` — asserts that the
   transported point is the point it started at. That replaces preservation
   with a **fixed-point** claim and leaves a false residual goal of the form
   "the left leg fixes `z`". Consume the provenance field and the square's
   `commutes` first; take whatever witness they produce. The transported
   point is generally a *different* element of the same invariant set.
6. Give that witness to `ObjectProperty.lift`. Take the inclusion square
   from `liftCompιIso`; do not rebuild `map_id`, `map_comp`, fullness, or
   faithfulness.
7. Assemble the objectwise lifts into the subdiagram and its natural
   inclusion. Use functor composition `⋙`; remember that action-category
   labels compose in reverse multiplication order.
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
2. show the preservation witness with free `X`, `Y`, `f`, and `x`;
3. show the `ObjectProperty.lift` restriction and `liftCompιIso` square;
4. identify the exact action groupoid, orbit, stabilizer, and named
   component carrier used for Remark 8.3.5;
5. distinguish categorical connectedness from topological connectedness;
6. show the exact `pi0GrothendieckEquiv` instantiation and real-level
   descent;
7. run the focused Lean build;
8. print the axiom surface and check for `sorry`, `admit`, and new axioms.
