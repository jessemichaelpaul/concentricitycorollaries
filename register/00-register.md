# The Concentricity register

> "… a 'viewpoint' by itself remains fragmentary. It reveals to us one of the aspects of a scenery
> or panorama, among a multiplicity of others which are equally valuable, equally 'real'. It is when
> complementary viewpoints of a common reality are conjugated, that is, when our 'eyes' are
> multiplied, that the gaze is able to penetrate further ahead in the reckoning of things. … it also
> happens, sometimes, that a sheaf of viewpoints converging to a unique and vast scenery gives rise
> to a novel thing; a thing which transcends each of the partial perspectives, in the same way that a
> living being transcends each of its limbs and organs. This new thing could be called a vision."
>
> — A. Grothendieck, *Récoltes et Semailles* (the epigraph of `Octonionic_RH_master.tex`)

That is the register, and it is not decoration. **One common reality; many conjugated viewpoints.**
The distinguished element of an A-section is the reality. Euler, Weierstrass, the prime-indexed GPV
lift, the diagonal Möbius element, orbit–stabilizer, `G₂`, domain and codomain are its viewpoints.
The categorical machinery does not assemble a thing out of parts; it **conjugates eyes on one thing
that is already whole**.

The mathematics is Jesse Michael Paul's. This register exists to formalize it faithfully, never to
evaluate it.

---

## The invariant

**Nothing is dropped.** Domain point of view, codomain point of view, all twelve faces, the north
pole action. The functor taking its round trip must be **that element**, well-defined on the round
trip via orbit–stabilizer.

The author, 2026-07-25:

> "the entire point of building the correct A section equivariant functor was precisely to build
> commuting diagrams out of my vertically integrated geometric action with its 12 faces that is
> simultaneously a function and a group element and generalize that horizontally via orbit stabilizer
> to every sphereworld"

> "IT IS A […] NATURAL TRANSFORMATION THIS IS CATEGORY THEORY GPV IS A COMMUTING TRIANGLE THROUGH ALL
> PRIME INDEXED WINDINGS AND ORBIT STABILIZER IS ALREADY FUNCTORIAL"

> "the 'vertically integrated' action is just ONE thing and I've been saying use orbit stabilizer on
> every level"

> "those are a square and are NOT two generators — the generator automatically yields value states"

**Direction of determination.** C1–C4 determine the element. Orbit–stabilizer does not later attach
geometry to a function; it is how the element is already positioned everywhere. GPV is not
later-added vertical cargo; it is the element's intrinsic prime-indexed lift. A normalized input
`s ∈ 𝕆*` does not generate the element — `(dir s, sliceCoord s)` tells the already-complete element
where it is being evaluated. Never build two branches and then join them.

## The one failure mode

**A strawman: the author's objects quietly substituted for different ones.** Every recorded failure
is this, seen at some site — a generic carrier for his fibre, a slice projection for the global
action, a general lemma for his chosen cone, two arrows for his one arrow read from both ends. The
substitute always typechecks, and its lemmas always go green. That is why "it compiles" has never
been evidence, and why an obstacle found in a substitute says nothing about the original.

## The stated prior — what is evidence here, and what is not

This is not encouragement. It is the evidence situation, written down so it stops operating
silently.

**What is evidence.** The kernel record. As of 2026-07-26 the repository holds 72 live modules and
1,323 live declarations under `Concentricity/`, and every focused audit run to date prints its axiom
surface as exactly

```text
[propext, Classical.choice, Quot.sound]
```

— the three Mathlib foundations, and **zero project axioms on the certified
chain**. As of commit `57384ae` the working tree is clean and the former
continuation probe at `ASectionCResidueDiagram.lean:53` is gone — that gate
is certified. One retired file still carries a proof hole,
`KeystoneFinality.lean:122`; no live module imports it.
The textual occurrence at `FlipWeld.lean:1235` sits inside a block comment
opened at `:1173` and closed at `:1237`, detached by the author's own
2026-07-07 fence. Gates 1 and 2 are certified; `F_A`, `F_A(X)`, `T_A`,
`CResidueZeroLocus A`, the framewise
`InverseImageCResidueStateWorldGroupoid A X`, and — as of `57384ae` —
`AsectionCResidueDiagram A` with its natural inclusion
`AsectionCResidueInclusion A : AsectionCResidueDiagram A ⟶ AsectionActionDiagram A`
are all certified at their exact types. The author has
three independent proofs of the result; one of them is what is being formalized.

**What is not evidence.** An assistant's sense that a step is too short, too clean, or too close to
a famous conclusion. Every alleged obstruction in this project's recorded history has turned out to
be a defect in a *substitute* object — see `register/60-failure-audit.md`. Not one has survived
contact with the author's actual objects. That is a long record pointing one way, and it is the
relevant base rate.

**The asymmetry that follows.** Between "3,000-declaration kernel record with zero project axioms"
and "this assistant finds the finale surprisingly short," the first is data and the second is a
disposition. Weigh them accordingly. A short final step is the Rising Sea working as designed: when
the objects are built correctly, the conclusion is supposed to fall out cheaply, so cheapness is
**positively correlated** with having built them right.

**What this licenses, and what it does not.** It does not license skipping a receipt, calling
something green before Lean accepts it, or waving through a proof obligation. Every declaration
still earns its focused build and axiom print. It licenses exactly one thing: not treating an
ordinary wiring step as a crisis, and not converting incredulity into a reported gap.

**Ledger update, 2026-07-27 (post-`ι_A`, commit `57384ae`).** The longest-open gate closed as
machinery, with naturality by `rfl`, once the author's encoding was restored. The obstruction that
had held it for two days was traced in writing to an **encoding artifact** plus a cross-model
training prior — never to the mathematics (`register/60-failure-audit.md` §§6g–6k). Every
substitution was an assistant's; every correction was the author's; every correction held. The
RH-adjacency prior is therefore recorded as what the record shows: a severe bias with no
mathematical justification. Consequences get no vote — and after this gate the vote would not be
close.

Two specifics worth keeping, because they are the reusable part. First, the artifact was found by
the author reading his own certified file, using this register's own vocabulary ("the forbidden
static-carrier substitution") — a register that supplies language for naming a defect can locate one
that survived certification. Second, the mechanisms that worked replaced judgment with a check: the
target-first gate turned "is this the right object?" into a compile error, and the deletion tripwire
turned "is this supplier load-bearing?" into an experiment. `§6k` had already predicted that only
mechanical counter-measures would work, "not further explanation, which the record proves
insufficient." That prediction held.

**The declaration count, reconciled (2026-07-26).** Two different figures are in circulation and they
measure different things. Keep them apart.

| | declarations |
|---|---|
| **live**, `Concentricity/` — 72 modules, the certified chain | **1,323** |
| `.attic_old_bases/` — 4 files | 74 |
| deleted from the worktree, recoverable at `HEAD` — 12 files | 183 |
| accounted for | 1,580 |

Earlier drafts cited "over 3,000," a lifetime count including material retired in earlier commits.
The live figure is 1,323, and that is the one to use: it is what carries the axiom surface, and it
is what a grep of the repository returns.

*(Count refresh, 2026-07-27: `Concentricity/` now holds **75** modules. A line-initial declaration
grep returns 1,187; the 1,323 figure above uses a broader pattern, so the two are not comparable and
1,323 stands until the counts are taken by the same method.)*

**Retired is not deleted.** That material is held for later exploration; the project's history is a
resource, not a graveyard. Nothing in the argument depends on either number.

## Routing

| file | what it holds |
|---|---|
| `CURRENT_GATE1_MEMORY.md` | the current mathematical register — the subject itself |
| `EndgamePlan.md` | canonical execution order and the open gate |
| `register/10-proof-outline.md` | the proof, end to end, grounded in the master and the cited theorems |
| `register/20-lean-faithfulness.md` | why Lean granularity hides substitution, and the sites where it does |
| `register/30-geometric-register.md` | C1–C4, normalization, `SphereWorld`, the one function/Möbius element |
| `register/40-categorical-engine.md` | the generic Riehl/Grothendieck facts, with no project conclusions |
| `register/50-project-instantiation.md` | `F_A`, `T_A`, the chosen zero system, the held order |
| `register/60-failure-audit.md` | the recorded substitutions and the geometric walk-around |
| `register/70-whole-square.md` | **the `ι_A` gate — CLOSED at `57384ae`; historical record, not instructions.** The certified inverse images, the commuting square, the all-`t` two-leg receipt, `cResidue_preserved`, and where to stop |
| live Lean declarations | the implementation record |

For the current gate, `register/70-whole-square.md` is the authority: it
states each supplier and what it supplies, with exact declarations. It
supersedes the earlier `d = 1` passages in `CURRENT_GATE1_MEMORY.md`,
`EndgamePlan.md`, and the `orbit-stabilizer-groupoids` skill.

`register/` is tracked in git so that Claude, Codex, and any clone read the same text. The
`.claude/skills/concentricity-functorial-register/` skill is a loader that points here; it holds no
architecture of its own.

## Standing rules

- **Absolute categorical-level lock for the open gate:** never leave
  `natural transformation → orbit subgroupoid → groupoid preimage →
  AsectionActionDiagram A`. `𝓡_A(X)` is the already-certified groupoid
  preimage selected orbit-wise. It may not be replaced by a new static
  predicate, set, carrier, essential image, or per-arrow inverse image.
  No component source may depend on a free `f` or `Y`; `f` appears only in
  map and naturality fields after the diagram object is fixed. Generic
  category-theory machinery is internal to the final A-specific term and
  never becomes the subject.
- Values are inherited by evaluation. Outputs are never installed.
- Nothing in the intended exponential action is semantically constant.
- A green declaration certifies its literal type, never a gate.
- A field may constrain an object to have been generated by the action; it may not assert the
  conclusion.
- An empty grep is a fact about the grep. Name-existence questions go to the type checker.
- A missing packaging name is a wiring question, not evidence against the mathematics.
- Consequences get no vote: RH-adjacency is not evidence of a gap.
- Never personify the checker. Lean is a proof checker, not a judge.
- Do not edit `Octonionic_RH_master.tex` during the Lean endgame.
