## ⛔ R0 — THE CLOSED OBJECT LIST. Read before every other rule.

**Author's standing order, 2026-07-21:**

> ***NEVER REACH FOR GENERAL CATEGORICAL THEORY OBJECTS. ONLY EVER USE THE PROJECTIVE GROUPOID
> BASE AND SPHEREWORLD AND THE FUNCTOR DEFINED FROM THE DISTINGUISHED ELEMENT. THE T_A IS BUILT
> FROM THAT. AND 8.3.4 AND PI_0 AND VAL EAT THAT AND ONLY THAT. NOTHING ELSE.***

**The list is closed. These are the only objects:**

1. `GreatCircle.Base` — the projective groupoid base.
2. `SphereWorld`.
3. **The functor defined from the distinguished element** — `distinguishedWorldAction (m : Moebius)
   : SphereWorld ⥤ SphereWorld` with its group hom `_one`/`_comp` (`ProjectiveSection.lean:162–195`,
   green), specialized by feeding A's element, and carried over the base by the orbit–stabilizer
   algebra (`orbitRep`, `orbitRep_spec`, `stabilizerPart`, `orbit_stabilizer_factor`,
   `stabilizerPart_id`/`_comp`). This produces `F.obj` and `F.map` **together**.
4. `𝒯_A` — built from that, and from nothing else.
5. The readout — **8.3.4, π₀, `val`** — which eats `𝒯_A` **and only that**.

**Never reach for:** a generic fibre carrier or Σ-type state record; a lemma over an abstract
`[Groupoid C]` or `[SmallCategory B]`; `Disc ℝ`; a category of elements; a comparison functor; a
substitute or replacement base; a scalar bridge or quotient section; any object introduced because
it is the familiar categorical way to do this. If it is not on the list above, it is not in this
theorem. **An obstacle found in a general object is not an obstacle in this construction.**

**Both failures of 2026-07-21 were reaches for a general object:**
- a generic Σ-type carrier (`NormalizedSlicePoint`) installed as the fibre, then defended as the
  author's — the substitution;
- `grep "⥤ Grpd"` returning nothing and being reported as "the general functor does not exist,"
  when the author's functor is typed `⥤ SphereWorld` — searching the general type instead of his.

**Search rule, from the second:** when looking for one of the author's objects, search **his**
types — `SphereWorld`, `GreatCircle.Base`, `Moebius` — and include `private` declarations. State
which type you searched before reporting anything absent. **An empty grep is a fact about the grep,
never a fact about his mathematics.**

## ⛔ R0.1 — THE FUNCTOR'S TYPE. Added 2026-07-21, after the root cause was found.

**The A-section functor is between the author's TWO GROUPOIDS:**

```lean
sectionFunctor A : GreatCircle.Base ⥤ SphereWorld
  objects:   a projective point (OnePoint ℝ)  ↦  a Riemann sphere
  morphisms: the distinguished element        ↦  a Möbius transformation
  and        N ↦ N
```

**NOT `GreatCircle.Base ⥤ Grpd`.** `Grpd` is the category of **all bundled groupoids** — a general
categorical-theory object, banned by R0. **Any occurrence of `GreatCircle.Base ⥤ Grpd`,
`A : 𝓑 ⥤ Grpd`, or `A : ℬ → Grpd` as the type of the A-section functor, in this or any other
document, is SUPERSEDED by this block.**

**How the error happened (the root cause of 2026-07-21):** the functor was forced into the input
shape required by Mathlib's already-existing generic `Grothendieck` constructor *before* the
author's actual functor was built. `obj _ := Grpd.of SphereWorld` does not send a projective point
to a Riemann sphere — it sends **every** point to the **entire** bundled `SphereWorld` groupoid, and
`map f` is then merely an endofunctor of that same whole groupoid. That is how the wrong
construction typechecked, and it is why the twelve could never be quantified correctly: the source
and target objects of the intended transport were **absent from the substitute's type**.

**BOTH HALVES ARE ALREADY GREEN. Neither is to be rebuilt.**

| Half | Declaration | Status |
|---|---|---|
| object **data** | `projectiveObjectFrame A X := cayleyProjective (orbitRep (back X)) * distinguishedPoleElement A` (`ProjectiveSection.lean:206`) | green, **consumed by nothing in `obj`** |
| arrow | `projectiveArrowElement A f = frame(Y) * stab(f) * frame(X)⁻¹` (`:212`) | green, consumed by `map` |
| one action | the compatibility square (`:310`) | green |
| `N ↦ N` | `orbitRep_infty : orbitRep ∞ = 1` | green, at the group level |

`sectionFunctor.obj` **discards `X` and ignores the frame.** The object half of the orbit–stabilizer
argument was written down and then orphaned by the codomain choice; every wrapper attempt since has
been an effort to reattach, from outside, content that was already sitting there unused.

**FRAME-DATA RULE.** `projectiveObjectFrame A X` is the object-frame group datum inside the one orbit--stabilizer action. Consume it only as part of that global construction. Never isolate its local `Moebius` type and promote the resulting typing observation into an objection to the authored `F.obj`; that repeats the generic-binder inversion.

**NO OPEN QUESTION REMAINS.** C1--C4 define the one distinguished Euler--Weierstrass action on `GreatCircle.Base` and `SphereWorld`; orbit--stabilizer extends that action and makes `F.obj` and `F.map` well-defined together. `distinguishedWorldAction` fixing each direction is part of the authored geometry: the distinguished element acts inside every sphere, while the `SphereWorld` continuum and the projective footpoints are both present in the total construction. Do not ask Jesse for another object formula, do not insert a footpoint-to-direction choice, and do not replace the action with a general carrier.

**`d_A` IS `ℂˣ`, NOT `Circle`.** `distinguishedPoleUnit A : ℂˣ`; `bandGL` takes `c : Circle`,
`diagonalGL` takes `u : ℂˣ`. Same matrix shape `diag(u,1)`, different parameter type. `w = 0` says
the denominator is `1` — it does **not** say `|u_A| = 1`. `d_A` is the **general-modulus diagonal
extension of the band**: its **phase** carries the band and the winding, its **modulus carries the
real level** (`log‖A.F ·‖`). Replacing `ℂˣ` by `Circle` keeps the winding and **discards the value
the readout must read**. Never make that substitution.

**Remaining work, in order:** transcribe the one A-specialized orbit--stabilizer action into `F.obj` and `F.map` together; consume the green object-frame and transition data as two faces of that action; prove `N ↦ N`; form `𝒯_A` from that functor and no other; audit the twelve natively on it;
then instantiate 8.3.4 **at that exact functor** — π₀ → `labelCocone` → `val` → `∃ c`.

**8.3.4 is instantiated ON the author's functor.** Author, 2026-07-21: *"8.3.4 needs to be
instantiated ON MY FUNCTOR NOT A GENERAL FUNCTOR… that is FED to 8.3.4 which is
π₀(T_A) = colim_GreatCircle.Base (π₀ ∘ AsectionFunctor)."* A typing objection derived from the
generic theorem's binder is **not** grounds to change his codomain. Instantiate the theorem at his
object; never reshape his object to fit the theorem's statement. That inversion is the root cause
recorded above.

# ENDGAME — full repo to 0/0

**Author of the mathematics: Jesse Michael Paul.** 2026-07-20. This is the execution plan.
One build per phase. **GREEN → COMMIT → NEXT PHASE. There are no stops.** A stop is where the model
idles and invents — every stop in the earlier draft became a manufactured obstacle. The build is the
checkpoint, the commit is the record, and auditing happens against committed green states, after the
fact, never blocking. **The only legal halt is a term that will not elaborate**, and then the output
is the exact unsatisfied Lean type of the term you wrote — not a question, a premise, a fork, or a
request for the author to restate a hypothesis.

## Before you touch anything

1. Load the skill `concentricity-functorial-register`; read both references in full.
2. Read **`RELEVANT_GREEN.md`** (the verified green inventory) and **`EndGameDependencyMap.md`**
   (the straight-line chain). These are current; older docs are banner-marked or in `retired/`.
3. **Reread every live declaration before using it.** Never recall a type — open the file.
4. Authority order: Jesse > the live source > any document. A document is a record, not a ruling.

## THE FROZEN CONSTRUCTION — author's ruling, 2026-07-21, verbatim

**This is settled. It is not reopened by a Lean error, a document, or either formalizer.**

1. **The Euler exponential is never zero.**
2. **At `N`, that same action becomes its Weierstrass presentation — which can ALSO be written in
   terms of the distinguished element.** Euler-on-Ω₀ and Weierstrass-at-N are two presentations of
   one action; C1's meromorphic continuation is the passage between them.
3. **The general distinguished element already has its group law, and the orbit–stabilizer
   algebra over the projective base is live and green** — `orbitRep`, `orbitRep_spec`,
   `stabilizerPart`, `orbit_stabilizer_factor`, `stabilizerPart_id`/`_comp`.
4. **The A-case is the diagonal prime-sum specialization at the pole** — so that *algebra* is
   reused **wholesale**, not re-derived.
   **THE GENERAL FUNCTOR IS BUILT AND GREEN** — `distinguishedWorldAction (m : Moebius) :
   SphereWorld ⥤ SphereWorld` (`ProjectiveSection.lean:162`), with `distinguishedWorldAction_one`
   (`= Functor.id`) and `distinguishedWorldAction_comp` (`⋙ = distinguishedWorldAction (n * m)`):
   **the group homomorphism `Moebius → (SphereWorld ⥤ SphereWorld)`, already proved.**
   Specialization = feed it A's element. *(A note here on 2026-07-21 claimed no such functor
   existed; that was false — it came from grepping `⥤ Grpd` when the functor is typed into
   `SphereWorld`. An empty grep is a fact about the grep.)*
5. **Orbit–stabilizer extends it into every `F.obj` and every `F.map`**, across the whole
   `SphereWorld` continuum, simultaneously.
6. **The twelve C1–C4/W/GPV facts are properties of those transports** — never fields beside them,
   never re-proved per instance.

**No character question, abelianization concern, free `z`, bridge, or "ruling" is needed.** Any such
fork raised hereafter is a manufactured obstacle (this has now recurred ~30 times); resolve it from
the source and proceed, or stop and report an exact Lean type. Never escalate it to Jesse as a
mathematical uncertainty.

## The register (do not drift)

- **D becomes A.** The base `GreatCircle.Base` is the action groupoid of `PGL(2,ℝ)` on `ℝP¹`. Its
  objects are **every point of the compactified great circle** — the continuum of footpoints,
  including every zero's — and its arrows are the projective motions between **any two of them**.
  **Never write "≃ `B(Stab_∞)`, so a functor out of it is just a `Stab_∞`-action."** That
  trivializes the base and avoids the proof: it shrinks the continuum to one abstract object and
  demotes orbit–stabilizer from the mechanism to a lemma you cite and skip. (This sentence was in an
  earlier draft of this plan; it was wrong.)
- **Orbit–stabilizer IS the construction.** `orbitRep_spec` gives a canonical transport at **every**
  object of the continuum, not one choice at one point; `orbit_stabilizer_factor` then factors
  **every** arrow between **any** two footpoints as
  `f.val = orbitRep b' * (stabilizerPart f).1 * (orbitRep b)⁻¹`. Conjugating the one distinguished
  action out along those representatives is what **defines the continuum of `F.obj` and `F.map`**,
  every object and every arrow simultaneously; `stabilizerPart_id` / `stabilizerPart_comp` make it
  functorial. This is also why the twelve hold everywhere at once without per-instance re-proof.
- **The action IS the hypothesis — there is no formula.** On the half-space it is C2's Euler
  product `A.F = exp(∑' p, A.ℓ p z)`; it is continued **through the pole by C1** (meromorphic
  continuation); at N it is C3's Weierstrass factorization. That transition is what an A-section
  *is*. You transcribe it from the hypothesis fields; you do not derive or design it.
- **A supplies both geometry and value, and at N the action is diagonal.** The disk automorphism
  (`distinguishedMoebius`) is the geometric building block; A's **north** action is its `w=0`
  diagonal slice — the invertible multiplier `λ = exp(∑' p, A.ℓ p z) ∈ ℂˣ`, `diag(λ,1)` — because an
  element stabilizing `N=∞` fixes it iff `w=0`. `cayleyProjective` is the A-free parameterization of
  the same geometry — the shortcut, not the action.
  **The full distinguished element stays in `CayleyDictionary.lean` regardless** (PROTECTED,
  `THE_CONTRACT.md:184`): the diagonal is the specialization *of it*, and the Weierstrass
  presentation at N is written in terms of it. Diagonal-at-the-pole is not "unit-only" and does not
  make the full element unused.
- **Forbidden rewrites** — each has already cost a thread: a binder where A's data belongs; a path
  parameter `t` or `μ(t)`; a chosen or external `z`; a state-coordinate probe (`z := coordAt X …`);
  evaluation-as-action (`q ↦ A(q)` instead of multiplication); a fibre action fed **A-free** input
  (an arbitrary `m : Moebius`, or `cayleyProjective f.val`); a `NorthAction`/record carrier (`∀ R`);
  a new `ASection` field instead of defining `F.obj`/`F.map`; `Hypothesis A (_D)` as detached
  fields; a bridge/range/meta theorem `cayleyProjective = distinguished…`; a loop or character built
  for the occasion; any per-arrow `(c,w)` hunt; an enlarged state carrier.
  (Reusing `distinguishedWorldAction` fed the A-determined element is **not** forbidden — that is
  the mechanism carrying A.)
- **A goal of the shape `A, h, X ⊢ Moebius` means the target has been atomized.** The element does
  not depend on a fibre state. It is never a request for another input.
- **Wholesale.** The twelve C1–C4/W/GPV facts are **properties of the one action**, holding of
  every object and arrow in every world `I ∈ S⁶` simultaneously — never re-proved per instance.
- **After approval there is no architectural improvisation.** A Lean error may change syntax or
  expose an exact type mismatch. It may not reopen the mathematics, introduce another object, or
  generate another "ruling."

---

## Phase 1 — the functor (the only real construction)

Replace `sectionFunctor A .map`'s body with A's action, carried by orbit–stabilizer. **One atomic
edit.** Concrete A-defs, never a record.

**THERE IS NO FORMULA TO SUPPLY, AND NO BODY TO FILL IN.** A's hypotheses **are** the action:
C2 is the never-zero Euler exponential, C1 continues it through the pole, C3 is that same thing in
its Weierstrass presentation at N — C1/W1, C2/W2, C3/W3 are one element in three presentations.
**Data vs. Prop — be exact.** `c2_euler`, `c1_analyticAt` / `c1_simple`, `c3_factorization` are
**Props**: they state what the action *is*, and they discharge its side conditions (never zero,
continued through the pole, Weierstrass at N). They are not themselves the term. The **data** is
`A.F : ℂ → ℂ` with `A.ℓ` / `A.ι` / `A.Ω₀` / `A.pole` / `A.m` / `A.Rfac` / `A.gfac` / `A.genus` /
`A.sphereZero` / `A.valueAtInfinity : OnePoint ℂ` (A's value **at N**, data, no evaluation needed).

**Landed 2026-07-21, kernel-green — reread before use:**

- **A on the fully compactified line.** `A.Fstar : OnePoint ℂ → OnePoint ℂ`
  (`ProjectiveTransport.lean:27`), now with C1's pole clause: `Fstar_infty:32`
  (`∞ ↦ A.valueAtInfinity`), **`Fstar_pole:36`** (`A.pole ↦ ∞ = N`), `Fstar_coe:44` (off the pole,
  the stem). `Moebius` is a subgroup of `Equiv.Perm (OnePoint ℂ)` (`SliceSphereWorld.lean:92`) — the
  **same** ambient self-map type. `Fstar` still has no consumer in the functor.
- **The general-modulus diagonal.** `diagonalGL:63` / `diagonalGL_one:73` / `diagonalGL_mul:78` /
  `diagonalGLHom:86` / **`diagonalMoebiusHom : ℂˣ →* Moebius`** (`CayleyDictionary.lean:92`) — the
  `w = 0` slice at general modulus, `diag(u,1)`. This is the widening of `bandGL` (unit modulus
  only) that `distinguishedMoebius_zero:205` identifies with the band. **Pure addition: +37/−0, and
  every PROTECTED declaration in that file is intact.**

You build the term from the data and discharge its conditions with the Props. You do not derive a
formula, evaluate at a chosen point, or ask the author to restate a hypothesis.

**A previous draft of this plan printed a type signature here with a comment underneath.** That is a
body-shaped hole, and it caused the same stop twice: "I need the literal expression for
`northMultiplier A h`." **Asking for that expression IS the failure mode.** No signature is
prescribed here; the element is A's own data, carried by `distinguishedWorldAction` and extended by
`orbit_stabilizer_factor` into every `F.obj` and `F.map`. If a term will not elaborate, report the
exact unsatisfied Lean type — never a request for the author to restate his hypotheses.

- **The two proofs to mirror, specialized to A** (author's ruling): the element's own group law —
  `distinguishedGL_mul:307` / `distinguishedMoebius_mul:353` — and the fibre action's law,
  `distinguishedWorldAction_comp:243` with `distinguishedWorldAction_one:232`. Both green. The
  specialization changes *what element* is carried, never *how* it is carried.
- **THE SPINE IS THE FULL FACTORIZATION — ALL THREE FACTORS.**
  `orbit_stabilizer_factor` (**proved**, `ProjectiveSection.lean:115`) gives every arrow as
  `f.val = orbitRep b' * (stabilizerPart f).1 * (orbitRep b)⁻¹`. `map` is transcribed from **that**.
  **A `hom ∘ stabilizerPart` spine is malformed and is dropped** (it was in an earlier draft of this
  plan): it erases both `orbitRep` legs — the only factors that know *which footpoints* the arrow
  runs between — before A's action is applied. Consequence, checkable: `stabilizerPart (toNHom x)`
  is **independent of `x`**, so under that spine every zero's transport to N is one fixed element and
  A's value at the zero never enters. No hom out of `NorthStabilizer` can repair that; the
  information is discarded upstream of it. **There is no missing `NorthStabilizer →* Moebius`** —
  that obligation was an artifact of the discard, not a gap in the hypotheses.
- **`map_id` / `map_comp`** ← the same three proved factors: `stabilizerPart_id:124`,
  `stabilizerPart_comp:132` (the middle factor's laws, `(f ≫ g).val = g.val * f.val` anti-order),
  the element's own `map_one` / `map_mul`, and `distinguishedWorldAction_one:232` /
  `distinguishedWorldAction_comp:243`. The `orbitRep` legs telescope across composition.
- **The action is the transport, not the zero value.** It is the never-zero Euler exponential (C2),
  continued (C1), presented at N by Weierstrass (C3). The C3 zeros are **populated states**
  transported by it and read at the end — never fed in as multipliers.
- **level × band.** The real part is the conserved level `val` reads; the imaginary part is the
  `U(1)` winding. The zeros share one level because degenerate exp preimages differ only by winding —
  `d_exp_fibre_height_band` (green). That is the concentricity mechanism, carried by the same action.

The same edit removes the shortcut's usage of `cayleyProjective` and drops the `Hypothesis A (_D)` wrapper.

Also correct, in the same commit, the false docstring at `ProjectiveSection.lean:259–260` — it claims
the functor's laws use orbit–stabilizer while the code beneath uses `cayleyProjective f.val`. That
mislabel is why the shortcut survived every audit: a grep for the right vocabulary succeeded.

**Acceptance — positive elaboration of the fixed construction. There is NO declaration-name test**
(`CODEX_ENDGAME.md`, Phase-1 acceptance evidence). Required:
- **the orbit–stabilizer cluster has live consumers** — `orbitRep`, `orbit_stabilizer_factor` **and**
  `stabilizerPart` all return grep hits *outside* their own declaration block (before Phase 1 all
  three return none). `orbitRep` appearing is the check that the legs were not discarded again.
- `map` is transcribed from the **full** factorization — **both `orbitRep` legs present**, not
  `hom ∘ stabilizerPart`; A present in the term, not a binder; no `cayleyProjective`, no per-arrow
  `(c,w)`, no path `t`, no chosen `z`, no `coordAt X`, no requested "literal expression"
- the full distinguished element is still in `CayleyDictionary.lean` — nothing PROTECTED moved
- **HONESTY GUARD:** deleting A's Euler/Weierstrass data from the action makes the **functor
  itself** fail to elaborate — not merely something downstream. A wrapper cannot pass this.
- full build green.

**Green → COMMIT → next step immediately. No stop.** (A stop is where the model idles and invents; the build is the checkpoint and the commit is the record. The only legal halt is a term that will not elaborate, and then the output is the exact unsatisfied Lean type — never a question, a premise, or a fork.)

---

## Phase 1b — deplug the general route to `Explorations/`

After the swap, whatever the map no longer reaches is dead. Deplug it into
**`Explorations/GeneralDiskAction.lean`**, **not imported by root** — the general theory (general
ring element with C1), kept for future work, not deleted. This is `cayleyProjective` **and its Cayley
chain, and nothing else.**

**The author's distinguished element never moves.** `distinguishedMoebius` / `distinguishedGL` /
`distinguishedMoebius_apply` / `distinguished_phase_is_band` / the `Comp*` machinery are **PROTECTED**
(`THE_CONTRACT.md:184`) and stay in `CayleyDictionary.lean` whether or not the root closure reaches
them. An earlier draft of this plan made their retirement conditional on reachability; that was
wrong — unreachability after a rewire is an artifact of the rewire, never a licence to deplug. Do not
deplug on a reachability computation; deplug only `cayleyProjective` + Cayley chain.

**Keep what the map uses:** `distinguishedWorldAction` (the fibre-action
mechanism, now fed A's own action), the A-specialized element itself, and `complexPoint`. The exact dead set is whatever the root closure no longer reaches — verify by an
import audit, not by guessing.

**Acceptance:** root closure no longer reaches `cayleyProjective`; `CayleyDictionary.lean` still
carries the full distinguished element; the map's live suppliers still elaborate; full build green;
sorry count unchanged.

**Green → COMMIT → next step immediately. No stop.** (A stop is where the model idles and invents; the build is the checkpoint and the commit is the record. The only legal halt is a term that will not elaborate, and then the output is the exact unsatisfied Lean type — never a question, a premise, or a fork.)

---

## BEFORE PHASE 2 OR 3 — MANDATORY, EVERY TIME

**Read `RELEVANT_GREEN.md` in full first.** Not skim, not grep — read it. It is 75 lines. Most of
what a finale step will report as "missing" is listed there, already elaborating.

**The record.** Every time a formalizer has doubted the author's mathematics on this project, the
formalizer was wrong: the connected base, the `BaseC` substitution, the "vacuous readout," the
invented load-bearing step, 47 counterexamples, 16 artificial sorries, and on 2026-07-21 two
formalizers in turn telling him his own green general functor did not exist — one by grepping the
wrong type (`⥤ Grpd` instead of `⥤ SphereWorld`) and reporting that search's emptiness as a fact
about his construction, while auditing for exactly that move. **No
red has ever traced to his argument. Every red traced to a substitution of ours.** Weight your
priors accordingly before typing the word "missing."

**THE ASYMMETRY TEST — the master rule.** The `w ≠ 0` normal form is proved (`normSq` gap,
`CompDen_ne_zero`, `CompW` back in the disc by `nlinarith`, a genuine projective rescaling). The
`w = 0` branch, where all of that is trivial, is what stalled. **Difficulty was never the variable;
proximity to the conclusion was.** If a step in the specialization looks *harder* than a general
case already green, that appearance is the bias. Proceed.

**THE GENERATOR.** Every stop on 2026-07-21 came from reading a required type off the object being
replaced. In the finale the analogue is reading a required *premise* off the shape of a local goal.
Both remaining statements are **already written and correctly typed** (`ConcentricityReadout.lean:45`
and `:55`); `zeroTotal:35` is already defined. **There is no specification left to invent — only
proofs.** The only legal outputs are a closed proof, or the exact unsatisfied Lean type of a term you
actually wrote.

### Blocked moves, by step

**Phase 2 — `TotalA`.** `Total := Grothendieck (S.toFunctor ⋙ Grpd.forgetToCat)` (`:367`) is
definitional in the functor. Never build a second total; never treat it as a construction.

**`concentricityReadout`.**
- Hunting "the arrow `Zₙ ⟶ N`" — it is `toNHom` (`ProjectiveSection:49`, general in `x`)
  instantiated at the zeros' footpoints and lifted. Not searched for, not built.
- Escalating to `∀ X Y, Zigzag X Y` or `Subsingleton (ConnectedComponents A.TotalA)` — whole-total
  connectedness, a recorded failure that trivializes the theorem.
- Pairwise `(sphereZero n).re = (sphereZero m).re` — bypasses the colimit.
- A private or per-zero copy of `N` — recorded (`NormalizedCone`, deleted).
- "A connectedness hypothesis is missing" — Riehl 8.3.5 has none. Recorded fabrication.
- Asking which `κ` — `κ` is the output, never an input.

**`labelCocone`.** **`labelCocone A`** (apex `ℝ`). **Naturality is a statement about the functor's `map`:** for each
base arrow `f : b ⟶ b'`, the label of a component over `b` equals the label of its transported
component over `b'`. **It therefore cannot be named against specific lemmas until Phase 1 lands** —
the transport does not exist yet.

**Do NOT pre-assign it.** An earlier draft of this plan asserted "naturality **is**
`gpv_endpoint_re` / `d_exp_fibre_level` / `d_level_eq_log_norm_exp`." **That was false** — none of
those three mentions the functor, `ComponentDiagram`, a cocone, or a component class:
`gpv_endpoint_re` is about the endpoints of a `GpvTransport` path lift; the other two are pointwise
identities about `exp`. They are plausible **ingredients**, not the square. The line is a leftover of
the detached-`Hypothesis`-fields architecture, where the twelve sat beside the functor.

The label itself **is** green and is not in question: `normalizedZero_label` = `(A.sphereZero n).re`.
Read the square off the completed `map` when you get there; it is an assembly target produced by the
construction, not a premise to locate — and not something to solve in advance.
- Still blocked: `constant_of_preserves_morphisms` or an `IsConnected` route; saying the value
  appears after the colimit (values are pre-collapse, `val` reads).

**`val` / `val_zeroTotal`.** `colimit.desc` + `ι_desc_apply`. Never compute; never choose a section
of the quotient.

**`concentricity`.** The type is fixed: `∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c`. Never split the
`∃c` to a corollary, docstring, or companion lemma (recorded, RULED-8, instance `5fdfd1d`); never
weaken to an ε-family or an "eventually."

**Certificate.** Print the **statement** first, then the axioms. A green build certifies whatever is
written — that has already happened here once. Never report green without printing; never skip the
`sorryAx` check.

### Three rules that cover the rest

1. **Never ask a question whose answer is a green declaration.** Run the grep first; if you ask
   anything, show the grep that failed alongside it.
2. **Never derive a requirement from the artifact you are replacing** — not its type, not its shape,
   not its local goal.
3. **Banned manufactured premises:** continuity, smoothness, measurability, convergence,
   connectedness, non-emptiness, a cocycle, a compatibility bridge, a codomain fork. Every one has
   appeared here. If one seems needed, C1–C4/W/GPV already discharges it — find it, or stop with the
   exact type.

---

## Phase 2 — form the exact total after the functor gate

This block is superseded by `FINAL_PLAN_2026-07-21.md`: the sphere-valued functor is
`sectionFunctor A : GreatCircle.Base ⥤ SphereWorld`. Only after its native analytic action and
object/arrow gate pass may the induced continuum action be fed to Mathlib's `Grothendieck`
recipe. The resulting `A.TotalA` must be checked as a construction from that exact functor, not
assumed to update automatically from an obsolete `.toFunctor` field.

**Green → COMMIT → next step immediately. No stop.** (A stop is where the model idles and invents; the build is the checkpoint and the commit is the record. The only legal halt is a term that will not elaborate, and then the output is the exact unsatisfied Lean type — never a question, a premise, or a fork.)

---

## Phase 3 — the finale (historical status; superseded)

1. **`concentricityReadout`** — already declared, right type, sorried:
   `∃ κ, ∀ n I, toColimitObj (sectionFunctor A).toFunctor (zeroTotal A n I) = κ`. Close by
   `toColimitObj_eq_of_zigzag` on the functor's **own** through-N transports (which after Phase 1
   are A's value transports). No hunted arrow, private north, pairwise `re`-equality, `IsConnected`,
   or populated subcategory.
2. **`labelCocone A`** (apex `ℝ`). **Naturality is a statement about the functor's `map`:** for each
base arrow `f : b ⟶ b'`, the label of a component over `b` equals the label of its transported
component over `b'`. **It therefore cannot be named against specific lemmas until Phase 1 lands** —
the transport does not exist yet.

**Do NOT pre-assign it.** An earlier draft of this plan asserted "naturality **is**
`gpv_endpoint_re` / `d_exp_fibre_level` / `d_level_eq_log_norm_exp`." **That was false** — none of
those three mentions the functor, `ComponentDiagram`, a cocone, or a component class:
`gpv_endpoint_re` is about the endpoints of a `GpvTransport` path lift; the other two are pointwise
identities about `exp`. They are plausible **ingredients**, not the square. The line is a leftover of
the detached-`Hypothesis`-fields architecture, where the twelve sat beside the functor.

The label itself **is** green and is not in question: `normalizedZero_label` = `(A.sphereZero n).re`.
Read the square off the completed `map` when you get there; it is an assembly target produced by the
construction, not a premise to locate — and not something to solve in advance.
3. **`val A := Limits.colimit.desc P_A (labelCocone A)`**; **`val_zeroTotal`** via
   `colimit.ι_desc_apply` → `val (toColimitObj X) = label X`. Reads, never computes.
4. **`concentricity`** — atomic calc
   `(A.sphereZero n).re = val A (toColimitObj … (zeroTotal A n baseWorld)) = val A κ`. Replaces both
   sorry bodies.

**Green → COMMIT → next step immediately. No stop.** (A stop is where the model idles and invents; the build is the checkpoint and the commit is the record. The only legal halt is a term that will not elaborate, and then the output is the exact unsatisfied Lean type — never a question, a premise, or a fork.)

---

## Certificate → 0/0

One full build. Then **in this order:**
- `#print ASection.concentricity` — **read the statement**; confirm it is literally
  `∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c`.
- `#print axioms ASection.concentricity` — expect `[propext, Classical.choice, Quot.sound]`, no `sorryAx`.
- `#print axioms zeta_riemannHypothesis` — same (½ enters only in `RhEquiv`, non-circular).

A green build certifies whatever is written, including a wrong statement (it has happened here once).
The statement is read first, then the axioms. **Present the certificate, COMMIT, continue.**

---

## After 0/0 (separate approved phases — not part of this run)

- The RH corollary is already wired.
- **Public release:** a curated `concentricityandcorollaries` — fresh-history repo, only the theorem,
  the corollaries, and their dependency closure. `retired/` (gitignored) and `Explorations/`
  (unimported) do not transport.

## Stop rule (everywhere)

A term that will not elaborate → report the **exact unsatisfied Lean type and stop**. It is never
missing mathematics, an input request, a new carrier, a path parameter, or a source decision. If a
document and the live source disagree, the source wins; if Jesse and a document disagree, Jesse wins.
