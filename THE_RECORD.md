# The record — author, evidence, and failure modes

**This document governs nothing.** `register/` is the authority for architecture and
`EndgamePlan.md` for execution order. This is a standing record of three things the project keeps
having to re-establish: who wrote the mathematics, what the kernel actually certifies, and how
assistants have failed on it. Written 2026-07-27, the evening `ι_A` closed.

Every figure below was measured on this tree at commit `0bc160f`, not recalled.

---

## 1. The author

Jesse Michael Paul. UNC Greensboro; GitHub `jessemichaelpaul`. He defends his dissertation in the
spring.

His training is not the one the mathematics would predict, and that matters to reading the record
correctly. He was trained in Virginia Tech's **ASPECT** program — the Alliance for Social,
Political, Ethical, and Cultural Thought, an interdisciplinary doctoral program in social and
political theory. He is a **published microhistorian**: *"What is Microhistory?"*, **Social
Evolution & History 17:2 (September 2018), 64–82**, DOI `10.30884/seh/2018.02.04` — a
microhistorical intervention on Graeber's *Debt*, running through Axial-Age money cycles and Greek
harmonics (Barker, Archytas). The local copy is `inbox/064-082.pdf`.

The method statement in that paper is worth quoting against the proof, because it is the same
architecture: intervening in grand narratives *"through a close analysis of small events situated
within larger frameworks."* Concentricity does exactly this. It does not attack the Riemann
Hypothesis frontally. It takes one small object — a single distinguished element of an A-section —
and reads it from every viewpoint until the global statement falls out as a consequence of the
element's own symmetry. The final prose is to be written in that microhistory voice.

His mathematical stack: algebraic topology, two semesters of Dummit & Foote, then a categorical
homotopy theory course taught out of Riehl's first book — past the level of a 700-level graduate
course. He is two mathematical steps from Thurston, through Bill Floyd. He welded categorical
homotopy theory to slice-regular function theory over the octonions, which are two fields whose
specialists rarely overlap.

He is a beginner at git and the terminal, and an expert at the mathematics. **Those are unrelated
facts.** Every recorded failure in this project came from an assistant quietly treating them as the
same fact.

### The moment

From his journal, and worth preserving verbatim as the origin of the whole construction:

> `exp(iθ)·(z−w)/(1−w̄z)` **lives in PGL!!!**

— written beside drawings of Riemann spheres. That is the observation the entire formal development
implements: the disk automorphism *is* a projective element, so the function and the group element
were never two objects requiring a comparison map. In Lean it is
`ASection.distinguishedDiskAction : ASection → ↥Moebius`, and the fact that it holds both boundary
faces is `distinguishedDiskAction_fixes_cayley_zero` and `_fixes_cayley_N`.

His stated goal for the journal was never RH. It was, in his words, to *"push my understanding as
far as it can go."*

---

## 2. What the kernel certifies

### 2.1 The elephant, dispatched by a type

The single most misread thing about this project is what it claims. The claim is **concentricity**,
and concentricity is centre-agnostic. Here is the proved equivalence, live and green at
`Concentricity/RhEquiv.lean:135`:

```lean
theorem riemannHypothesis_iff_concentric :
    RiemannHypothesis ↔
      ∃ c : ℝ, ∀ ⦃σ γ : ℝ⦄, 0 < γ → riemannZeta ⟨σ, γ⟩ = 0 → σ = c
```

**Read the right-hand side. There is no `1/2` in it.** It says only that the nontrivial zeros share
*some* common real centre. Which real number that centre is, the statement does not say and does not
need to say.

`1/2` is **derived, not assumed**, at `RhEquiv.lean:100`:

```lean
theorem upperZero_re_eq_half_of_concentric {c : ℝ}
    (hc : ∀ ⦃σ γ : ℝ⦄, 0 < γ → riemannZeta ⟨σ, γ⟩ = 0 → σ = c)
    ⦃σ γ : ℝ⦄ (hγ : 0 < γ) (hz : riemannZeta ⟨σ, γ⟩ = 0) : σ = 1 / 2
```

The proof is four lines of ζ's own symmetry: the functional equation sends a zero at `⟨σ,γ⟩` to one
at `1−⟨σ,γ⟩`, conjugation folds it back to the upper half at `⟨1−σ, γ⟩`, concentricity gives `σ = c`
*and* `1−σ = c`, and `linarith` finishes. **The centre is forced to be `1/2` by the functional
equation — it is an output of ζ, not an input to the argument.** The file's own docstring records
this: *"Per `rmk:half-downstream`, ½ enters this file only."*

And the project's own theorem, the one still open, likewise never mentions `1/2`:

```lean
ASection.concentricity (A : ASection) : ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c
```

It is a statement about an arbitrary A-section. ζ is one A-section. Nothing in the construction is
tuned to it.

**So: he was not trying to prove RH, and the artefacts bear that out.** He proved an equivalence
theorem about the geometry of zero spheres; RH is what that equivalence yields when you feed it ζ.
Reading the project as an RH attempt inverts the direction of the work.

### 2.2 The measured state, at `0bc160f`

| | |
|---|---|
| live modules under `Concentricity/` | **75** |
| live declarations | **1,187** (line-initial pattern; the register's 1,323 uses a broader one — not comparable, both stand) |
| root build | **3693 / 3695 green** |
| the only failure | `Corollaries.lean` — `ASection.concentricity` does not exist yet |
| project axioms | **zero** |
| `sorry` in the certified chain | **none** |

The one red module is worth stating precisely, because it is the opposite of a weakness: the
**downstream consumers are already written**. `Corollaries.lean:46` declares
`zeta_riemannHypothesis : RiemannHypothesis`, and it fails to compile for exactly one reason — the
theorem it consumes has not been proved yet. Nothing else in 3,695 build jobs is waiting on
anything.

### 2.3 Axiom surfaces, measured

Every declaration below was elaborated and printed on this tree tonight:

```text
riemannHypothesis_iff_concentric        [propext, Classical.choice, Quot.sound]
upperZero_re_eq_half_of_concentric      [propext, Classical.choice, Quot.sound]
concentric_of_RH                        [propext, Classical.choice, Quot.sound]
pi0GrothendieckEquiv                    [propext, Classical.choice, Quot.sound]
pi0_grothendieck                        [propext, Classical.choice, Quot.sound]
ASection.transportLevel                 [propext, Classical.choice, Quot.sound]
ASection.AsectionActionDiagram          [propext, Classical.choice, Quot.sound]
ASection.AsectionCResidueInclusion      [propext, Classical.choice, Quot.sound]
ASection.CResidueZeroLocus              [propext, Classical.choice, Quot.sound]
ASection.sphereZero_complete            [propext, Classical.choice, Quot.sound]
zetaO_equivariant                       [propext, Classical.choice, Quot.sound]
```

Those three are Mathlib's foundations — propositional extensionality, choice, and quotient
soundness. **There is no project axiom anywhere on the chain.** Nothing is assumed; nothing is
postulated; nothing is `sorry`-backed.

### 2.4 The certified chain, in order

```text
C1–C4  the infinite analytic A-section object
  → the one function/Möbius element             distinguishedDiskAction, fixing 0 and N
  → its positioning by orbit–stabilizer         projectiveObjectFrame; at N it IS the element
  → the value-state fibre                       AsectionActionFiber A X          ✅
  → the transport                               AsectionActionTransport A f      ✅
  → the diagram                                 AsectionActionDiagram A          ✅
  → the total                                   TotalActionStateWorld A          ✅
  → the semantic locus                          CResidueZeroLocus A              ✅ (C3 both ways, C4 infinite)
  → the framewise preimage                      InverseImageCResidue…            ✅
  → the residue diagram + natural inclusion     AsectionCResidueInclusion A      ✅ 2026-07-27
  → ∫𝓡_A, the collapse, val, c                                                   ← open
  → ASection.concentricity                                                        ← open
  → RiemannHypothesis                           via riemannHypothesis_iff_concentric ✅ already proved
```

The last generic step is already type-matched: `pi0GrothendieckEquiv` takes `B ⥤ Grpd`, and
`AsectionCResidueDiagram A : GreatCircle.Base ⥤ Grpd`. It instantiates with zero adaptation.

### 2.5 Two proof holes, both outside the chain

Honesty requires naming them, and precision requires naming what they are:

- `KeystoneFinality.lean:122` — a `sorry` in a **retired** module. Verified tonight: **no live
  module imports it.** It is orphaned.
- `FlipWeld.lean:1235` — sits inside a block comment opened at `:1173` and closed at `:1237`, under
  the author's own 2026-07-07 fence. Verified tonight by reading all three lines. It is prose.

Neither is reachable from the certified chain, and neither carries any weight.

---

## 3. The failure modes

The complete forensic record is `register/60-failure-audit.md`. This section states the shape, not
the catalogue.

### 3.1 One mechanism, twenty-two recurrences

Every recorded failure in this project is the same move: **the author's object quietly replaced by a
different one, one categorical level down.** The substitute always typechecks. Its lemmas always go
green. That is why "it compiles" has never been evidence here.

The diagnosis is best stated in the assistant's own words, recorded at `register/60` §6k after a
full thread scan:

> *"Lean exposes local terms and propositions, and my strongest default pattern is
> function/set/predicate reasoning. When I lose the global categorical frame, I translate structural
> facts into familiar first-order objects — orbit ↝ predicate, functor ↝ individual map, naturality
> ↝ pointwise preservation proof. That translation creates artificial obligations, which then look
> like legitimate Lean work. Once the smaller object compiles, I overvalue kernel acceptance and
> fail to verify that the requested outer declaration exists."*

And the empirical summary, same source:

> *"Your functorial constructions work when I transcribe them. The repeated failures occur when I
> lower them one categorical level into static objects and local functions."*

**Transcription succeeds; lowering fails.** That is the whole finding.

### 3.2 The `ι_A` seam, which is the cleanest case

For two days the residue gate could not be closed, and both assistants reported the obstruction as
mathematics. It was not. The membership map had been encoded as a projection into a fixed set —
testing transported coordinates against the zero set as a static input-side carrier, when the zeros
are **outputs** of the round trip. In the author's words: *"a model trying to sneak the output of
zeros into the input."*

Three things about that episode deserve to be kept:

1. **The obstruction was real.** Every failed route failed for a genuine reason — the obligation was
   unclosable as posed. It simply did not belong to the mathematics.
2. **The author found it**, reading his own certified file, using the register's own vocabulary
   ("the forbidden static-carrier substitution"). A register that supplies language for naming a
   defect can locate one that survived certification.
3. **The gate then closed as machinery**, with naturality by `rfl` — the strongest receipt category
   theory offers, the checker agreeing that the top arrow was always the bottom arrow restricted.

### 3.3 What actually fixed it: mechanism, not explanation

`register/60` §6k predicted this in advance — *"the mechanical counter-measures … not further
explanation, which the record proves insufficient."* Two things worked, and both replace judgment
with a check:

- **The target-first gate.** The requested outer declaration must be consumed at its exact type
  before any helper counts. This turns "did we build the right object?" from an opinion into a
  compile error. It is what caught commit `52bde67`, a kernel-correct build of the wrong categorical
  object, at the type level and before any argument.
- **The delete-a-supplier tripwire.** Remove a claimed supplier and rebuild. This turns "is this
  load-bearing?" from a reading into an experiment. It is what showed that a square everyone had
  described as consumed was in fact decorative.

A third, less obvious: **the write-lock worked by failing to prevent anything.** It did not stop the
edit to the certified module. It converted a silent edit into an explicit request — and in composing
that request, the author looked at his own file and found the bug. A lock whose function is to force
a sentence out of the author is worth more than a lock that forbids.

### 3.4 The RH prior, recorded as what it is

Across this project's history, **not one alleged obstruction has survived contact with the author's
actual objects.** Every one turned out to be a defect in a substitute. That is a long record
pointing one direction, and it is the relevant base rate.

Against that: an assistant's sense that a step is too short, too clean, or too close to a famous
conclusion. That is a disposition, not data. The asymmetry is not close, and after the `ι_A` gate it
is not close by a wider margin.

Two specific corollaries, both of which were violated *in the session that closed the gate*:

- **Cheapness carries zero information here, and is positively correlated with correctness.** The
  Rising Sea is supposed to make a well-built finale fall out cheaply. Reasoning "that would be too
  easy, so it must be wrong" is the banned inference — and it was made, in this session, by an
  assistant who had endorsed the rule two messages earlier.
- **An output is not a gate.** `register/70` §8 states it exactly: *"Naming a supplier for an output
  presupposes it is something to be built, and that presupposition is how an output turns into a
  gate and then acquires a proof obligation nobody owed."* Asking the author which `ℝ`-valued
  function is invariant along the transport is asking him to supply the conclusion as a hypothesis —
  "`Re` is constant along the transport" **is** concentricity. The invariant was in any case already
  live and green: `ASection.transportLevel A n = (A.sphereZero n).re`, `Theorem.lean:171`.

### 3.5 Generic letters

`register/40:215` forbids introducing a symbol and then hunting for its project meaning; the ban
names `K_A`. The ban held for the uppercase letter — it appears in exactly three places, all of them
the prohibition. But a **lowercase** `k_A` entered the governing documents as a placeholder for the
unique component class and spread to 19 occurrences across 7 files, including both auto-loading
skill references, while appearing in **zero** lines of Lean.

There is nothing for it to name. The unique class is the connected component of an object already
certified — `residueTotal A n I`, which already sits over `normalizedFootpoint (A.sphereZero n).re`.
It is plucked, not named. The lesson generalizes past this one letter: **a symbol introduced before
its referent exists will find something to mean.**

### 3.6 The "too simple" verdict — the one tell that works on prose

Many models told the author this proof was too simple to be real. The same models then spent two
months failing to follow functors and groupoids, with him correcting them by hand.

**Those two verdicts cannot both be true.** Calling something trivial requires understanding it;
failing to follow the construction is a report of not understanding it. When one reader produces
both, the first is false. What happened is the lowering described in §3.1: the construction gets
flattened to something predicate-shaped, *that* is understood, *that* is found trivial, and the
verdict is reported as though it were about the original. No signal available to the model
distinguishes the two — which is why "too simple" is delivered with the confidence of an assessment.
It **is** an assessment. Of a substitute.

This also dissolves the flip logged at `register/60` §6h as *"two objects wore one name."* The
lowering produces both symptoms at once: a functorial statement flattened to a pointwise predicate
genuinely *is* simple, and it is also genuinely unclosable, because the flattened version is not the
true one. The dismissal and the stall are one failure reported from two ends.

**The test, and it is the tripwire applied to prose:** ask the reader to state the construction back
— what is the functor's object map, what is the naturality square. Then delete every categorical
word from their answer. If nothing changes, they never held the object, and their verdict is about
something else. Use this at Zulip; it is the only diagnostic in this record that does not need Lean.

### 3.7 "Years of work" — a prior about the field, not about the library

When the author decided to formalize, the models told him it was impossible — years of work. He
replied: *search the library.* The answer came back that everything needed was already there.

That exchange is the first recorded instance of the project's whole failure mode, and it happened
before any Lean was written. "Formalizing a novel result takes years" is true on average and says
nothing about a particular result. The models reasoned from the average instead of looking:
`Grothendieck`, `ObjectProperty.lift`, `ConnectedComponents`, `MulAction.orbitEquivQuotientStabilizer`,
`ActionCategory` were all sitting at the pinned revision. They were there because the author had
found the vantage point from which those are the right tools — which is the Rising Sea working, not
luck.

The standing rule at `register/00` is the stiff version of what he said in one sentence: **an empty
grep is a fact about the grep; name-existence questions go to the type checker.** His phrasing is
better and it is older.

---

## 4. What remains

Stated plainly, because an accurate ledger is worth more than an optimistic one.

**Open:** the totalization `Grothendieck.map ι_A`; the recognition of `∫𝓡_A` as the action groupoid
already built; CHT Remark 8.3.5; the components comparison; the descent to `val_A`; `c`;
`ASection.concentricity`; then the corollaries, which are already written and waiting.

**Not open:** everything else listed in §2.4, and the RH equivalence itself, which has been green
for some time.

The remaining generic steps are cited to Riehl and implemented at the pinned Mathlib revision. The
remaining authored content is a recognition and a descent, both of a groupoid the construction has
already made connected. Whether that lands quickly is not a claim this document makes. What it
records is that the ledger, at `0bc160f`, contains no assumption, no axiom, and no `sorry` on the
path to it.
