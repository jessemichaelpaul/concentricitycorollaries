## ⛔ R0 — THE CLOSED OBJECT LIST. Read before every other rule.

**Canonical execution and memory:** read `FINAL_PLAN_2026-07-21.md` and
`MEMORY.md`. They supersede conflicting plan/status prose below; the live Lean
types remain the implementation record.

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

# THE CONCENTRICITY THEOREM — PROOF OUTLINE LOCKDOWN V2

**Mathematical author and final authority:** Jesse Michael Paul

**Codex/Opus joint draft:** 2026-07-17

**Author ratification:** RATIFIED, 2026-07-17
**Status:** canonical V2 architecture; promoted over the former `PROOF_OUTLINE_LOCKED.md`

**Author's corrected ruling, 2026-07-21.** The A-section functor is the wholesale specialization of
the already-proved general distinguished-element orbit--stabilizer construction. That construction
defines `F.obj` and `F.map` simultaneously across the whole continuum. There is no independently
chosen or constant fibre: `NormalizedSlicePoint` and `NormalizedSliceHom` are not the author's
objects and arrows. **The two groupoids are the projective base `GreatCircle.Base` — where the disk
automorphism lives — and `SphereWorld`; `𝒯_A` is built from those** (author, 2026-07-21).
C1--C4/W/GPV are properties of the genuine transports everywhere, not
theorem-fields retained beside an A-free action. The canonical outputs are
`zeroTotal A n I`; C4 must also be consumed as infinitude of populated zero objects in
`Total A`. The real readout is `val := colimit.desc (labelCocone) : colim → ℝ` — the intrinsic
label descended OUT of the colimit; `c := val κ`. This IS the `F : J → α` at the read-out
(REQUIRED); forbidden is only a map fabricated apart from the label, the pre-colimit
`constant_of_preserves_morphisms` (needs `IsConnected`), a scalar functor, bridge, or `Disc ℝ`.
The only place a genuine gap can be is **upstream**: the functor's arrows carry the label
(§0, §11 Step 2), before any colimit.

## 0. The resolving distinction

There are two construction layers, and they must never again be collapsed.

First, the distinguished Möbius/exponential motion

$$
f(z)=\exp(I\theta)\frac{z-w}{1-\bar w z}
$$

extends by orbit–stabilizer to a well-defined general slice-preserving functor over the
continuum of slice worlds. Its well-definition, identity law, and composition law are pure
group-theoretic facts. **C1–C4 play zero role in this layer.** The live source's
`projectiveSkeleton`/`projectiveConnection` path is an A-free shortcut through
`cayleyProjective`; it is not the authored functor and supplies neither the accepted `obj` nor the
accepted `map`.

Second, the general functor becomes the A-section functor only when C1–C4 and their certified
W/GPV consequences are retained by the categorical interface consumed by its objects and
maps. Only this cargo-bearing interface is used to form the total object of the Concentricity
Theorem. This is the mathematical requirement; the exact Lean object/Hom packaging is an
author ruling, not a choice made by this outline.

In symbols:

$$
F_{\mathrm{gen}}
\xrightarrow{\text{C1--C4/W/GPV cargo on the existing action}}
A:\mathcal B\longrightarrow\mathbf{Grpd}
\xrightarrow{\text{Grothendieck}}
\mathcal T_A.
$$

No later step may call the projected, value-free action “the A-section functor.”

## 1. The theorem

Let `A` be an A-section: a section of the commutative ring $\mathcal R$ of slice-preserving
functions on $\mathbb O^*$ satisfying C1–C4.

The populated C-residue value states of the **cargo-bearing A-section functor** have one
colimit/component class. That class intrinsically carries one real value $c\in\mathbb R$.
Consequently

$$
\exists c\in\mathbb R\;\forall n,\quad \operatorname{Re}(A.\mathrm{sphereZero}(n))=c.
$$

Thus all infinitely many populated C-residue zero $6$-spheres have the same real centre and
are concentric. The theorem does not prescribe the numerical value of $c$.

The Lean Conclusion Gate is literal:

```lean
∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c
```

It belongs in `concentricity_theorem` itself, alongside the singleton and analytic-content
clauses. A docstring, companion theorem, or downstream corollary does not satisfy this gate.

## 2. The zero-spheres are outputs

The zero-spheres are not objects supplied in advance to force a categorical conclusion.

C3 identifies the residue-$\mathbb C$ divisor states. C4 makes that output population
infinite. After the A-section functor and its total object are built, those states arrive as
outputs of the completed transport. “Degenerate fibre” is the mathematical description; the
current exact terms are `zeroTotal A n I : Total A` and
`A.c4_infinite : (Set.range A.sphereZero).Infinite`. Their completed output and infinitude
types must be fixed by the author before implementation.

> **The zeros arrive as the degenerate fibre — output, never input.**

No common centre, pairwise real-part equality, or concentricity statement occurs in the input
data.

## 3. The fixed geometric registers

The construction uses the author’s existing objects:

- the compactified octonions $\mathbb O^*=S^8$;
- the continuum of complex slices $\mathbb C_I^*$, $I\in S^6$;
- the one geometric point $N=\infty$, shared by every compactified slice;
- the projective action groupoid
  $\mathcal B=PGL(2,\mathbb R)\ltimes\operatorname{OnePoint}(\mathbb R)$;
- the sphere-world groupoid with its direction and Möbius arrows.

Different categorical registers may represent $N$, but there is one geometric $N$. There are
never index-dependent private copies $N_n$ requiring new connectors.

No generic replacement base, constant diagram, `Disc ℝ`, or independent Set-valued value
architecture is introduced.

## 4. The general slice-preserving $F$-functor

The general functor is assembled from the distinguished disk automorphism and rotation. The
orbit–stabilizer extension supplies its global object action over the continuum. Stabilizer
compatibility supplies representative independence. The group identity and multiplication
laws supply `map_id` and `map_comp`.

This step proves only the categorical action and its functor laws. It does not contain:

- the A-section’s pole;
- the Euler and Weierstrass channels;
- the zero population;
- the winding and lift certificates;
- the intrinsic real-value transport.

The clean separation is mandatory: deleting C1–C4 must leave the general functor intact, while
preventing the promotion to the A-section functor.

## 5. Promotion to the A-section functor

Let `A : ASection` carry C1–C4. The existing general action is now equipped with the analytic
content that makes it the A-section functor:

- C1: continuation through the unique simple real pole, with value at the common witness $N$;
- C2: the Euler exponential channel and its zero-free half-space;
- C3: the Weierstrass channel over the full divisor and the normalized C-residue states;
- C4: the infinite populated output family;
- the winding, lift-uniqueness, tameness, crossing, welding, normalized-zero, and GPV
  consequences already proved in the repository.

These are not new hypotheses and not an independent analytic campaign. They are the existing
theorems about this A-section, installed as specifications carried by the general action’s
objects and morphisms.

The Lean representation, once dictated by the author, must preserve the following honesty
condition:

> Projecting away the analytic fields may recover the general action, but the exported
> A-section functor and the total category consumed by the theorem must retain the cargo.

No carrier is selected independently of this construction. In particular,
`NormalizedSlicePoint` and `NormalizedSliceHom` do not prescribe the objects or arrows. The twelve
facts are properties of transports produced by the A-specialized orbit--stabilizer functor itself.
Deleting the A-specialization must break the functor, not merely a wrapper or downstream proof.

## 6. The A-section total object

Only after Section 5 is kernel-checked do we form

$$
\mathcal T_A=\int_{\mathcal B}A.
$$

Mathematically, an object of $\mathcal T_A$ is a base position together with an A-section value
state, and a morphism is a base arrow together with the compatible A-section transport. This
sentence does not prescribe a new Lean field layout; the exact representation is Ruling B of
the build plan.

This is the round trip of the construction: the base motion, the sweep through the continuum
of sphere worlds, and the common landing at $N$ live in one total categorical object.

C3/C4 then supply the outputs `zeroTotal A n I`. C4 is consumed both as
`A.c4_infinite` and as the derived statement that infinitely many populated zero objects occur
in `Total A`. These are outputs, never inputs.

## 7. The components diagram is a readout, not a replacement

Apply connected components to the genuine A-section functor:

$$
P_A=\pi_0\circ A:\mathcal B\longrightarrow\mathbf{Set}.
$$

`P_A` is the diagram demanded by the Grothendieck/colimit theorem. It is not a second project
architecture. Its elements and maps are the component classes and induced maps of the
cargo-bearing groupoids already constructed.

## 8. The categorical-homotopy readout

The finale uses one Grothendieck/colimit mechanism:

$$
\pi_0(\mathcal T_A)
\simeq
\operatorname*{colim}_{\mathcal B}(\pi_0\circ A).
$$

Riehl’s proof of Lemma 8.3.4 explains the quotient: an arrow supplies exactly the relation
requiring the corresponding elements to be identified in every cone. The project’s
`pi0GrothendieckEquiv` is the formal certified instance. These are presented as the literature
explanation and the Lean realization of one readout, not as two independent constructions.

The category of elements need not be introduced as a new project object, and no claim of
literal definitional equality is required. What matters is the certified equivalence and the
identification relation it computes.

## 9. The transported singleton

The categorical theorem now consumes the completed functor all at once.

The A-section’s global maps carry the real-value transports throughout the continuum and meet
at the one witness $N$. The colimit imposes all identifications generated by those existing
maps. C4 supplies a nonempty infinite populated output. Riehl’s Remark 8.3.5 supplies the
singleton statement. The engine is the proof of Lemma 8.3.4, formalized by
`pi0GrothendieckEquiv`; the colimit identifies the zeros through the zero→N transports
(`toColimitObj_eq_of_zigzag`), **not** through a separate `zigzag_isConnected`/`IsConnected`
step. The cargo transports feed the cocone at the completed functor, and the canonical
populated range is read as the singleton class $\{\kappa\}$. No new “populated category” or
hand-built join object is introduced.

There is no intermediate “join the zeros” construction:

- no zero-to-zero connector;
- no chosen zero-to-$N$ leg added after the functor;
- no $N$-to-$N$ connector;
- no indexed copies of $N$;
- no `Classical.choose` assembly;
- no manually composed pairwise zigzag;
- no pre-colimit equality of two centres.

The functor was built globally for this purpose. The colimit performs the identification
wholesale.

## 10. The real singleton and Concentricity

The unique class is not value-free. Its elements are A-section value states produced by the
completed functor and its arrows are the genuine real-value transports. The intrinsic-value readout is
`val := colimit.desc (labelCocone) : colim → ℝ` — the label descended OUT of the colimit;
`c := val κ`, $\kappa=\{c\}$. This IS the `F : J → α` at the read-out (required), not a
fabricated or pre-colimit `constant_of_preserves_morphisms` map. No independent point/hom carrier is
interposed between the distinguished element and the functor.

Lean reads the output in two types:

$$
\kappa:\pi_0(\mathcal T_A),
\qquad
c:\mathbb R.
$$

Mathematically these are the same output in two registers:

$$
\kappa=\{c\}.
$$

Reading the real value of this singleton gives $c$. Every populated C-residue zero-sphere is an
output state in that class, so every sphere has centre $c$. Hence the infinitely many spheres
are concentric.

No independent scalar functor, projection bridge, global preservation hypothesis, or
post-colimit decoration is introduced.

## 11. Locked proof order

The order is:

1. Construct the general slice-preserving $F$-functor by the Möbius formula and
   orbit–stabilizer. C1–C4 absent.
2. Install C1–C4/W/GPV cargo on its existing object and morphism actions, thereby obtaining the
   A-section functor.
3. Kernel-check and axiom-audit that cargo-bearing functor.
4. Form its Grothendieck total object $\mathcal T_A$.
5. Populate the C-residue zero-spheres through the author-ruled C3/C4 output interface; consume
   C4 in its exact ruled type.
6. Apply the certified Grothendieck/colimit readout.
7. Apply Riehl’s finite-zigzag/singleton criterion through the author-ruled canonical
   range/singleton interface, without introducing a populated category.
8. Read $c$ off κ by `val := colimit.desc (labelCocone) : colim → ℝ` (the label descended out
   of the colimit); $c := \text{val }\kappa$, $\kappa=\{c\}$. `val` is the `F : J → α` at the
   read-out (required), not a fabricated or pre-colimit `constant_of_preserves_morphisms` map.
9. Put `∃ c : ℝ, ∀ n, (A.sphereZero n).re = c` in the theorem’s type.
10. Stop at terminal green and produce the author’s certificate.

This order is never reversed. In particular, Riehl is never applied to the projected general
functor as though it were the A-section functor.

## 12. Current Lean source boundary

The actual source currently contains:

- `ASection`: the C1–C4 analytic data package;
- `sectionFunctor A : H1 ⥤ S2`: a point-level equivariant section functor, useful geometric
  background but not the final projective sphere-world proof engine;
- the distinguished projective action used by `projectiveSectionFunctor`;
- `ProjectiveConnection A`, with a general `toFunctor` and A-specific zero/certificate fields
  beside it;
- `projectiveSectionFunctor A`, whose unfolded `obj` and `map` contain no occurrence of `A`;
- `Total A`, formed from that projected general functor;
- indexed `zeroTotal A n I` outputs;
- `A.c4_infinite`, not yet consumed as infinitude of the projective total output range.

This factual list establishes the exact Step 2 delta: replace the entire shortcut functor with the
A-specialized distinguished-element orbit--stabilizer construction, so `obj` and `map` are produced
together and the twelve are properties of its genuine transports; retire the hand-built
`northWorldHom`/`PopulatedTransport` route; consume the canonical outputs; and perform the
label readout by `val := colimit.desc (labelCocone)` (the label descended out of the colimit;
`c := val κ`) — the `F : J → α` at the read-out, not a fabricated or pre-colimit
`constant_of_preserves_morphisms` map. Rulings A--D are complete and may not be reopened.

## 13. Construction and proof gates

This outline fixes the mathematical precondition: no proof step begins until the cargo-bearing
A-section functor, its corresponding total object, and the canonical C3/C4 output interface are
kernel-checked and axiom-audited.

The bounded construction procedure belongs only to
`A_SECTION_FUNCTOR_BUILD_PLAN_2026-07-17.md`. The theorem-closing procedure belongs only to
`CONCENTRICITY_THEOREM_CLOSE_GUIDE_2026-07-17.md`. Neither procedure may alter the mathematical
order fixed here.

## 14. Forbidden substitutions

- treating the general functor as the A-section functor;
- using C1–C4 to prove the pure functor laws;
- placing analytic cargo beside a functor and then projecting it away before forming the total;
- forming the theorem’s total object from a value-free projection;
- making the zero-spheres inputs;
- assuming or manually constructing concentricity;
- connecting indexed zeros or indexed north states by hand;
- replacing the author’s groupoids with generic, constant, discrete, or Set-valued templates;
- adding `Disc ℝ`, a scalar comparison functor, or a global `realValue_preserved` hypothesis;
- proving pairwise real-part equalities before the colimit;
- importing connectedness from the base, fibres, or topology;
- moving the common-centre conclusion out of the theorem type;
- changing the proof because of a downstream consequence.

## 15. Terminal state

Terminal green requires all of the following simultaneously:

- the printed type of `concentricity_theorem` contains the common-centre conclusion;
- the proof consumes the cargo-bearing A-section functor and its total object;
- the analytic cargo is load-bearing;
- no `sorryAx` appears;
- the axiom report is exactly the expected foundational set;
- the full build is green.

The exact certificate, commit, tag, bundle, and stop procedure is governed only by
`CONCENTRICITY_THEOREM_CLOSE_GUIDE_2026-07-17.md`. Terminal green is the endpoint: no cleanup,
simplification, reformulation, or consequence-driven recheck occurs afterward.
