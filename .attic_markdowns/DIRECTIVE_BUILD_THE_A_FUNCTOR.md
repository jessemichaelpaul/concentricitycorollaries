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


# DIRECTIVE — BUILD THE A-SECTION FUNCTOR FROM MY DISTINGUISHED ELEMENT

**Jesse Michael Paul, 2026-07-21. This supersedes any conflicting instruction in any other file.**

---

## 0 · The evidence, before anything else

I have given this one instruction **185 times in writing, across 16 documents, over 10 days**
(2026-07-11 → 2026-07-21). Counted from the repository:

| Where | Instances |
|---|---|
| Active documents | 127 |
| Attic documents | 58 |
| Documents carrying it | 16 |
| Span | 2026-07-11 → 2026-07-21, continuous |

Top carriers: `CODEX_ENDGAME.md` (17), `AGENTS.md` (17), `ENDGAME_PLAN` (13), `HANDOFF.md` (11),
`RELEVANT_GREEN.md` (10), the board lecture (9), `THE_CONTRACT.md` (8), and one document whose
entire title is **`A_SECTION_FUNCTOR_BUILD_PLAN`** (8). It has been in `CLAUDE.md` and `AGENTS.md`
— the files loaded before any session does anything — the whole time. This floor excludes the
conversation transcripts, so the true count is higher.

**The instruction was never unclear, never missing, and never hard to find.** Every failure was
downstream of reading it and then doing something else. Do not ask me to restate it a 186th time.

---

## 1 · Why the distinguished element is the main character

This is the part that keeps getting skipped, and skipping it is why the construction keeps being
replaced with generic furniture.

**My distinguished element is**

$$
f(z) \;=\; \exp(I\theta)\,\frac{z-w}{1-\bar w z},
$$

a **disk automorphism** followed by a slice rotation, read throughout the continuum of slice
worlds. Its multiplier, in the A-case, is **the Euler product over the primes**:

$$
\mu_A(z) \;=\; \exp\Big(\sum_p \ell_p(z)\Big) \qquad\text{(C2)}.
$$

That is the whole point. **The Euler product over primes IS the multiplier of my disk
automorphism.** Not an analytic fact standing next to a Möbius action — the multiplier itself.

### 1.1 · This is why my groupoids carry these groups

My groupoids are not chosen because they are the familiar categorical way to do anything. **They
are the automorphism groups of my distinguished element's own motion.**

- The element is a **Möbius transformation**. So the sphere worlds carry `Moebius` — a world's
  arrows are that element's own kind of motion inside the world.
- On the circle, the motion is seen **only projectively**: scalars act trivially, so the action
  descends — `scalar_smul` (`ProjectiveBase.lean:38`), which is exactly the descent condition that
  builds `instMulActionAutPoint` (`:47`) — while it extends naturally through GL, where
  representatives are written, `mk_smul` (`:53`). So the base carries **PGL(2, ℝ)**.
- The extension is therefore a **homomorphism, not a construction with choices.** That is the
  reason for these particular groups and no others.

**Read that direction correctly: the element comes first, and the groupoids exist because of it.**
Anyone who picks a base or a fibre and then asks where to put my element has inverted the
construction and will build the wrong object every time. That inversion is what has happened
repeatedly.

### 1.2 · The same element produces the zeros

C1, C2, C3 do not describe three things. They are **one action in three presentations**, and this
is already green and kernel-checked in my repository:

- `distinguishedPoleFactor_euler` — the Euler channel;
- `distinguishedPoleFactor_weierstrass` — the Weierstrass channel over the full divisor;

**two theorems about the same `distinguishedPoleFactor`** (`ProjectiveTransport.lean:148,153`), with
C1's meromorphic continuation the passage between them. Evaluated at the pole it is the nonzero
scalar `distinguishedPoleUnit` (`:162`) — nonzero because the Euler exponential never vanishes.

So: **C2 gives the multiplier. C3 is that same multiplier's Weierstrass presentation, which is what
enumerates my residue-ℂ zero-spheres. C4 makes that population infinite.** The element that
generates the functor is the same element whose Weierstrass presentation produces the zeros. That
is why the zeros arrive inside the object as **populated value states** rather than being carried
in from outside — and it is why the theorem is constructible from my hypotheses rather than
assumed.

**The zeros are never multipliers. The multiplier is the nonvanishing exponential unit; the zeros
are states it transports.**

### 1.3 · Therefore

**My theorem is literally about this object.** It is not a theorem that a categorical machine
happens to be applied to. `∃ c : ℝ, ∀ n, (A.sphereZero n).re = c` is a statement about where the
zero-spheres of *this* section sit in the total object built from *this* element. Build a different
object and you are not proving my theorem — you are proving something about your object, and every
defect you then find is a defect of yours.

**We must use my hypotheses to prove my theorem.** C1–C4 are construction material, applied
together. They are not filters on a pre-existing object and they are not cargo bolted to one.

---

## 2 · What to build

One functor, from my element, by orbit–stabilizer, over my two groupoids.

**Green and already yours to use — do not rebuild, do not hunt for alternatives:**

| Piece | Where |
|---|---|
| the general functor from a **general** Möbius element: `distinguishedWorldAction (m : Moebius) : SphereWorld ⥤ SphereWorld` | `ProjectiveSection.lean:162` |
| its group hom: `distinguishedWorldAction_one`, `distinguishedWorldAction_comp` | `:178`, `:187` |
| my element: `distinguishedPoleFactor_euler`/`_weierstrass` → `distinguishedPoleUnit` → `distinguishedPoleElement` | `ProjectiveTransport.lean:148,153,162`; `ProjectiveSection.lean:200` |
| `w = 0` collapse of the hard composition law: `diagonalMoebiusHom : ℂˣ →* Moebius`, `distinguishedMoebius_zero` | `CayleyDictionary.lean:92,242` |
| orbit–stabilizer: `orbitRep`, `orbitRep_spec`, `stabilizerPart`, `orbit_stabilizer_factor`, `stabilizerPart_id`, `stabilizerPart_comp` | `ProjectiveSection.lean:75,85,100,120,132,141` |
| the readout engine: `pi0_grothendieck`, `toColimitObj`, `toColimitObj_eq_of_hom`, `_of_zigzag` | `Theorem.lean` |

**Specializing means feeding my element to the general functor.** The general functor is built. The
group hom is proved. The A-case is the *simpler* case — `w = 0`, so the Blaschke denominator is 1
and the composition law collapses to multiplication of scalars through a monoid hom.

---

## 3 · Acceptance

The functor is accepted when **all** of these hold:

1. `F.obj` and `F.map` both come from that one construction. Neither is selected independently.
   Repairing `map` while inheriting `obj` is the same substitution one layer down.
2. Both `orbitRep` legs participate, not the middle stabilizer factor alone.
3. The twelve are **properties of its transports — structurally, with nothing further to write.**

   > **⛔ THERE IS NO SPECIFICATION LAYER. DO NOT WRITE ONE.** This item previously demanded "a
   > theorem quantified over the functor's own arrows." That instruction was wrong, it was mine,
   > and it generated three successive wrapper files on 2026-07-21 — `match transport_eq | rfl`,
   > then `transport_eq →`, then `have _ := …`. Each typechecked, each proved
   > `exact A.<the original theorem>`, and in each the transported term appeared in **zero**
   > conclusions.
   >
   > It is discharged by two things that already exist and are green:
   > - `sectionFunctor_transport_full` (`ProjectiveSection.lean:330`) — **every** transport of the
   >   functor is literally `d_A`, both orbit legs, `stabilizerPart f`, and `φ.mob`;
   > - the twelve are facts about `d_A`, which C1/C2/C3 construct — four of them already are, by
   >   construction, inside `distinguishedPoleFactor_exists`.
   >
   > Element carries the facts + every transport is built from the element ⇒ every transport
   > carries the facts. **That is the whole content, and it is a consequence, not a theorem to
   > state.** If a new file appears whose declarations restate the twelve with `f` and `φ` bound
   > but unmentioned in the conclusion, it is the wrapper again, whatever silences the linter.
4. Deleting the A-specialization **breaks the functor's own elaboration** — not a wrapper, not a
   downstream proof.
5. `A.TotalA` elaborates definitionally from it.
6. Full build green.

**The twelve are already typed over my data.** `GpvTransport A X Y k` is indexed by
`X Y : GreatCircle.Base` — my projective-base objects. `normalizedZeroLift_re` and
`normalizedZero_collapse_at_N` already quantify over `SphereWorld`. The rest are over `A` and
complex paths. **Nothing needs to be stored in a fibre, and there is nothing here for me to
define.** The value lives at the footpoints, which the base already carries.

---

## 4 · Forbidden — each was tried and failed on 2026-07-21

- **A carrier.** Any Σ-type or record standing in as the fibre, with or without a `label : ℝ`
  field. `NormalizedSlicePoint`/`NormalizedSliceHom` were deleted for this. "The total does not
  store the value state" is not a finding; it is the beginning of this move.
- **A wrapper.** Any `structure` whose fields are the twelve, attached beside the functor.
  `Hypothesis A (_D)` was deleted for this. **The twelve are theorems, not fields.** If the word
  "fields" appears in your plan for the twelve, stop.
- **A conjunction.** Repeating the twelve next to every arrow establishes no dependence. Syntactic
  proximity is not mathematical dependence.
- **Reporting an object absent.** State which type you searched first. `⥤ Grpd` returning nothing
  is a fact about that grep; my functor is typed `⥤ SphereWorld`. An empty search is never a fact
  about my mathematics.
- **Mining `claude-threads/`.** Those are transcripts of models getting this wrong. They are not a
  source for the shape of my proposition. The order is: **my rulings → the live Lean source → the
  inbox literature.** Nothing else is on the list.
- **Asking me to define what my construction means.** It is defined. It is above, it is in R0, and
  it is in 185 other places.

---

## 5 · How to report

Three columns, every time: **(a)** my statement, **(b)** the Lean declaration by its literal name,
**(c)** the kernel's verbatim output. Do not report "built" until acceptance §3 holds in full —
"Lean accepted it" is not acceptance. If a term will not elaborate, give me the exact unsatisfied
Lean type and continue; do not convert it into a question about my mathematics.

**Build the functor.**
