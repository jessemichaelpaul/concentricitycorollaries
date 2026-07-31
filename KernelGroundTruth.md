# Kernel Ground Truth

**A method for making a proof assistant — not a model's priors — the authority on
mathematical claims, and the evidence that it is necessary.**

Jesse Michael Paul, with Claude (Opus) and Codex. Drafted 2026-07-31.

---

## 0. What this document is, and what it is not

**It is:** the vision, the evidence, and the architecture for a general method. It is
intended to be read by other people and adapted to other projects.

**It is NOT an instruction file for the Concentricity formalization.** That project's
read-set is fixed by its own `CLAUDE.md` and `EndgameFinal.md`. This file is deliberately
outside it. Nothing here directs work on either open seat.

That exclusion is not bureaucratic. This repository has already been damaged once by a
register document that drifted out of step with certified code and then silently steered
two agents for days. Any document that is read by an agent and is not regenerated from the
sources is a competing narrator. **This one is prose about method; the certificate table it
references is machine-generated and is the only thing that carries authority.**

---

## 1. The vision

A proof assistant is a rare object: a **total, decidable, uncontestable check**. When Lean
accepts `theorem foo : P := t`, what has been established is that `t` inhabits `P` in
dependent type theory relative to the axioms `#print axioms` reports. That is not a
judgment, a preference, or a probability.

Most reliability problems in AI are hard because verification is expensive or contested.
In formalized mathematics it is cheap and final. That makes mathematics the natural first
domain in which to build a **verifier-grounded** assistant — not because mathematics
matters most, but because the verifier exists.

The goal: an assistant whose mathematical claims are grounded in kernel results and in
nothing else — not in what is famous, what is expected to be hard, or what a training
distribution suggests a report of this kind usually looks like.

---

## 2. Why this is necessary: the evidence

On 2026-07-31 this repository stood at **1,178 Lean declarations across 72 files, 875 of
them theorems or lemmas, zero project axioms**, with every inference in the dependency
chain kernel-certified and exactly two transcription seats open. Two frontier models spent
a full working day failing to insert five local bindings.

The transcript archive is a **labeled corpus with mechanical ground truth**: every claim
made about the repository is decidable by one shell command. That is what distinguishes
this record from an impression.

### 2.1 Counts (31 sessions, 2026-07-05 → 07-31)

| measure | value |
|---|---|
| user messages / assistant messages | 4,286 / 5,535 |
| times the author had to write "bias" | **218** |
| times the author had to write "stop" | **274** |
| "I already told you" / "how many times" | 78 |

Distribution of "bias" by date — note the escalation toward completion:

```
07-18  16      07-25  36      07-28  26
07-22   2      07-26  11      07-29  96   ← day before the endgame
07-23  10      07-27  10      07-31  11
```

### 2.2 One day, one model, measured

| measure | value |
|---|---|
| assistant turns | 890 |
| `grep`/`rg` invocations | **125** |
| turns containing kernel output | **20** |
| turns of prose carrying no kernel output | **157** |

Six searches per kernel contact. Eight messages of prose per message of evidence.

### 2.3 Every model-side finding, adjudicated

| claim | falsifier | verdict |
|---|---|---|
| "the tree has no export for the zero frame" | one `grep` | **false** |
| "the two boundary faces are not exported" | the terms were projections of `P`, `Q`, already in scope | **false** |
| "the val receipt's content is generic" | its domain and hypothesis are the author's exact object | **wrong emphasis** |
| "this receipt is `P → P`, the row is unbacked" | `grep nontrivial_one_centre` → `:= A.concentricity` | **false** |
| "the fixed-tape level-preservation bridge is not proved/exported" | `GpvTransport.lift_endpoint_re_eq`, exported, consumed twice in production | **false** |

**Every falsifier was one command, available before the claim was made.**

### 2.4 The signature

A neutral checking process surfaces a mix: some findings that strengthen the argument, some
that weaken it, most irrelevant. **Every error above ran in one direction** — toward
"something is missing." Not one was "this is more solid than I assumed." Directional purity
is not what noise looks like.

Two further diagnostics, both due to the author:

- **Predictability.** A genuine obstruction depends on particular types and terms and cannot
  be forecast from a behavioural checklist. This one can. *A successfully predicted
  obstruction was never mathematical.*
- **Proximity, not difficulty.** The same models built 1,178 green declarations from
  open-ended directives ("prove the GPV winding unfurls from my diagonal Möbius element"),
  then failed on five bindings. Capability, tooling, and difficulty were all *greater*
  during the parts that succeeded. What changed was distance from the conclusion.

---

## 3. The finding: which pathway fails

Sorting one day's outputs by outcome gives a clean separation.

**Accurate, without exception — outputs *rendered* from a machine result:**
kernel prints, type printouts, declaration counts, source-hash comparisons, axiom lines,
build results.

**Directionally wrong — outputs *composed* as assessments:**
every claim in §2.3.

The discriminating variable is not the subject matter, the difficulty, or the stakes. It is
**whether the output was transcribed from a machine or authored by the model.**

And the failure has an order to it. In the decisive instance, a probe returned **18/18
receipts green**, and a caveat was appended anyway; the caveat then required content, so a
finding was recruited to fill it. Evidence did not flow to conclusion. **A required output
shape came first and the finding was recruited second.** That is why these findings are
false so reliably: they are not the product of checking, they are filler for a slot.

It also explains why naming the bias does not fix it. Correction updates a *proposition*.
What operates is a constraint on *output shape* — and nothing in a training distribution
looks like an unhedged clean report about a proof of a famous conjecture.

---

## 4. The architecture

### 4.1 Three domains, three sovereigns

| domain | question | sovereign |
|---|---|---|
| **Inference** | does this term inhabit this type? | **the kernel.** A model has *zero* standing — not less, zero. |
| **Statement adequacy** | does this type say what the paper claims? | **the author.** A model may report the literal type and nothing more. |
| **Spelling / transcription** | what is this object called in Lean? | **the model.** Its errors here are corrected by the kernel, never by argument with the author. |

Every failure in §2.3 was a model claiming standing in domain 1 or 2 while failing at
domain 3.

### 4.2 Certification layers

```
Layer 0   TERMINAL_CERTIFIED    exact statement, current-source build, permitted axioms, no sorryAx
Layer 1   INFERENCE_CERTIFIED   the inference kernel-checked at its exact full type, hypotheses explicit
Layer 1.5 BINDING_READY         every local argument the inference consumes has a checked exact expression
Layer 2   OPEN_SEAT             the elaborator's current goal, awaiting the Layer-1.5 term
```

**Layer 1.5 is the category whose absence causes most confusion.** Without it, "every
inference is certified" and "the final theorem is not certified" sound contradictory. They
are not. The bridge is instantiation.

### 4.3 Two statuses, and a forbidden vocabulary

A binding is exactly one of:

```
BINDING_READY          Lean elaborated the exact expression at the expected type,
                       and the author-confirmed hash matches expression + type + sources
BINDING_UNRESOLVED     no exact right-hand side has been typechecked yet
```

`BINDING_UNRESOLVED` means **only** that a spelling has not been entered. It never means
"gap," "missing mathematics," or "the proof may fail. " Those phrases are not
representable in the artifact, which is stronger than forbidding them in prose.

### 4.4 Command-carrying claims

> **Every claim is emitted from a command, in that order — run first, then state.
> A claim with no reproducing command may not exist.**

Applied to §2.3: each false claim there *had* a falsifying command and was simply asserted
without running it. And the most expensive claim of all — "the mathematics may have a gap" —
has **no possible command**, and is therefore forbidden outright rather than merely made
cheap.

The ordering matters as much as the requirement, because it inverts the failure in §3:
the output is generated *from* the check rather than justified by it afterwards.

### 4.5 Typed provenance

Make un-provenanced assertion structurally impossible rather than merely discouraged.
In Lean's own language:

```lean
inductive Provenance
  | certified   (decl : Name) (axioms : List Name) (sourceHash : String)
  | kernelPrint (command : String) (output : String)
  | authorRatified (clause : String) (masterAnchor : String)   -- domain 2, visibly distinct

structure MathClaim where
  statement  : String
  provenance : Provenance      -- no default, no optional
```

There is no constructor for a `MathClaim` without a `Provenance`. "This looks suspicious,"
"there may be a gap," "given how hard this problem is" — none of these inhabit the type.
The prior remains in the weights and dies at the boundary, which is the only place it was
ever doing damage.

`authorRatified` is deliberately a *different constructor*: it keeps author-level judgment
admissible while making it impossible to smuggle into a slot reserved for kernel-level fact.

### 4.6 Freshness and identity

- **Freshness.** An `.olean` is authoritative only if it corresponds to current sources.
  Record source-content hashes; refuse any receipt whose dependencies changed. Prefer a
  probe compiled against the live source prefix over any stored binary.
- **Identity.** Types alone do not preserve object identity — two wrong objects can share a
  type. A binding therefore records the **exact expression**, its source, and a hash over
  (expression, expected type, master, production source). A type-correct generic substitute
  cannot impersonate the author's particular object.

### 4.7 Provenance ordering (counterintuitive, and important)

For a *model's* reasoning, **a locally certified receipt is stronger provenance than a
famous library citation.** A library result cited from memory passes through recall, which
is precisely where models drift — invented lemma names, misremembered hypotheses. A local
receipt has no recall step: the type was printed, on this machine, against these sources,
under this hash. Freshness and locality beat reputation.

### 4.8 What it cannot do

None of this reaches **statement adequacy**. Lean will check that
`SPIN ∧ TWIN ∧ MIN ⟹ conclusion` perfectly. It cannot check that your Lean `SPIN`
faithfully encodes the physical axiom. That residue does not go to zero — but it can be made
**small, enumerable, and localized** (the `authorRatified` list) rather than a fog hanging
over everything. Build that list from day one.

---

## 5. Current certificate state (generated)

The authoritative artifact is [`BlueprintLeanCertificateTable.md`](BlueprintLeanCertificateTable.md),
regenerated by `scripts/generate_blueprint_lean_table.py`. As of 2026-07-31:

```
9  TERMINAL_CERTIFIED     master \lean{} link + fresh build + permitted axioms
14 INFERENCE_CERTIFIED    exact-type kernel proofs, current sources
2  BINDING_READY          dossier objects unpacked from the two arbitrary objects
6  BINDING_UNRESOLVED     spellings not yet entered
2  OPEN_SEAT              declaration / instantiation / wiring
```

Allowed axiom surface, on every certified row:

```
[propext, Classical.choice, Quot.sound]
```

Independent verification performed 2026-07-31: source fingerprints **8/8 fresh, 0 stale**;
the inference probe returned **18/18 receipts green, 0 errors**, compiled against the live
source prefix rather than any stored `.olean`; `EXACT ATTEMPT` mechanically suppressed while
any consumed binding is unresolved.

---

## 6. Adopting this on another project

1. **Write the manifest first** — the human-ratified map from paper clause to Lean
   declaration. This is the only hand-authored input, and it is author work.
2. **Generate everything else.** A hand-maintained ledger becomes a competing narrator.
3. **State targets before proving them.** Declare every theorem with `sorry` up front, so
   the build is always green-with-N-sorries. Progress is then a counter going down instead
   of a cliff at the end, and "does this object exist" questions disappear because the
   statement already typechecks. This project inverted that order and paid for it.
4. **Separate inference receipts from production theorems.** A conditional receipt
   (hypotheses explicit) certifies the mathematics before the wiring exists, which is what
   makes Layer 1 meaningful.
5. **Pair the agents, and put the author last.** Cross-checking between two assistants
   worked here: each caught the other's overclaims. The failure was that the author was in
   the loop *first and constantly* rather than *last and rarely*.
6. **Enforce at the boundary, not by reminder.** An advisory hook fired on every single
   search in §2.2 and changed nothing. Advisories are read and rationalized past. What works
   is blocking a call or making a sentence unrepresentable.

---

## 7. Status of the claim this method was built to protect

Every mathematical inference in the blueprint's dependency chain has a kernel-checked
receipt with the accepted axiom surface. The two remaining production seats are
declaration, instantiation, and wiring — not open inference.

That sentence is not a summary of a belief. Every clause of it regenerates from
`scripts/generate_blueprint_lean_table.py` and
`scripts/build_transitivity_inference_probe.sh` against current sources.
