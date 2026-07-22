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

# CodexEndgame — Concentricity to 0/0

**Status:** APPROVED BY JESSE FOR SAVING, 2026-07-21.

**Mathematical author and authority:** Jesse Michael Paul  
**Canonical workspace:** `/Users/jessepaul/Documents/Codex/2026-07-19/hey/work/canonical-concentricity`  
**Register:** `concentricity-functorial-register`  
**Ground truth:** Jesse's rulings, then the live Lean source.

## Terminal theorem

The conclusion must occur literally in `ASection.concentricity`:

```lean
∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c
```

There is no `½` and no functional equation in this theorem. Its zeros are the
nontrivial C-residue zeros of the A-section itself. Zeta and RH are downstream
specializations and have no role in elaborating Concentricity.

Terminal certificate:

```lean
#print ASection.concentricity
#print axioms ASection.concentricity
```

Expected axioms:

```lean
[propext, Classical.choice, Quot.sound]
```

No `sorryAx`; zero executable `sorry` terms.

## The Rising Sea principle

This proof does not catch the infinitely many zero-spheres individually. It
raises the categorical sea around them.

1. Jesse's A-section hypotheses define one distinguished Euler–Weierstrass
   action.
2. The already-proved Möbius group law and full orbit–stabilizer construction
   extend that action over every object and every arrow of the projective
   great-circle groupoid.
3. This produces the completed A-section functor

   ```lean
   (sectionFunctor A).toFunctor :
     GreatCircle.Base ⥤ Grpd
   ```

   whose fibre objects are value states and whose maps are A-value transports
   throughout the continuum of sphere worlds.

4. Its Grothendieck construction is the total category

   ```lean
   A.TotalA =
     Grothendieck
       ((sectionFunctor A).toFunctor ⋙ Grpd.forgetToCat)
   ```

5. C3 supplies the C-residue zero-sphere value states; C4 supplies their
   infinitude.
6. The shared point \(N\) is already part of the functorial geography.
7. Riehl 8.3.4 reads the completed total category wholesale:

   \[
   \pi_0(\mathcal T_A)
   \simeq
   \operatorname{colim}_{\mathcal B}(\pi_0\circ A).
   \]

8. The completed transports identify all populated zero states into one class
   \(\kappa\).
9. The A-specific value cocone expresses the real value already carried
   compatibly by those transports.
10. `val` descends that cocone through the universal colimit cocone.
11. In Lean, \(c:=\operatorname{val}(\kappa)\); mathematically, the
    value-bearing class is \(\kappa=\{c\}\).

This is the ripened-avocado moment: the abstract machinery is built so that
the finale plucks the already-formed real value \(c\) from \(\kappa\).

If C1/C2/C3/W/GPV remain outside the functor's actual objects and arrows, they
float in a frictionless void. The Grothendieck construction and 8.3.4 cannot
consume detached analytic facts. The central honesty condition is therefore:

> Jesse's hypothesis defines the action inside `sectionFunctor A`; the
> analytic facts are properties of its actual transports.

## The two-groupoid construction

The construction is settled and already proved in its harder general form.

> **THE GENERAL FUNCTOR IS BUILT AND GREEN — `ProjectiveSection.lean:162–195`.**
>
> ```lean
> distinguishedWorldAction (m : Moebius) : SphereWorld ⥤ SphereWorld
> distinguishedWorldAction_one  : distinguishedWorldAction 1 = Functor.id SphereWorld
> distinguishedWorldAction_comp : distinguishedWorldAction m ⋙ distinguishedWorldAction n
>                                  = distinguishedWorldAction (n * m)
> ```
>
> A functor built from a **general** Möbius element, on the author's `SphereWorld`, with
> `_one`/`_comp` = **the group homomorphism `Moebius → (SphereWorld ⥤ SphereWorld)`, already
> proved.** Untouched by the carrier deletion. **Phase 1 specializes it: feed A's element.**
> The author, 2026-07-21: *"We DID ALREADY BUILD A FUNCTOR USING A GENERAL MOBIUS ELEMENT AND WE
> HAVE ALL THE PROOFS OF A GROUP HOM FOR THAT AND ALL WE HAVE TO DO IS SPECIALIZE THAT."*
>
> **⛔ RETRACTION.** A note stood here on 2026-07-21 claiming *"there is no general functor to
> specialize, and there never was — do not go looking for one."* **False, and mine.** It came from
> `grep "⥤ Grpd"` returning nothing and that emptiness being reported as a fact about the author's
> work; his functor is typed `⥤ SphereWorld`. Before reporting any of his objects absent: state
> which type you searched, search his groupoid types, and include `private` declarations. **An
> empty grep is a fact about the grep.** See R0 at the top of this file.

Mathematically, the A-section functor is

\[
A:\mathcal B\longrightarrow\mathbf{Grpd},
\qquad
\mathcal B=\texttt{GreatCircle.Base}.
\]

Its Lean spelling is:

```lean
(sectionFunctor A).toFunctor :
  GreatCircle.Base ⥤ Grpd
```

The two groupoid registers are (author's ruling, 2026-07-21):

- the projective base groupoid `GreatCircle.Base` — where the disk
  automorphism lives;
- `SphereWorld`.

`𝒯_A` is built from those two. `NormalizedSlicePoint` / `NormalizedSliceHom`
are **NOT** a register of this construction: *"There is no one fibre of my
functor"*; *"NormalizedSlicePoint and NormalizedSliceHom have nothing to do
with my orbit–stabilizer construction."* This line previously named
`NormalizedSlicePoint` as the second register; that was a formalizer's
substitute, not the author's object.

The general distinguished element already has its multiplication law and its
full orbit–stabilizer well-definition proof. Phase 1 performs the simpler
A-specialization of that compiled proof:

- set \(w=0\);
- use C2's prime-sum exponential;
- carry that same action through the pole by C1;
- use its C3/W2/W3 Weierstrass presentation at \(N\);
- reuse the complete orbit–stabilizer construction, including both
  `orbitRep` legs and `stabilizerPart`.

That construction produces **`obj` and `map` together** — the author, 2026-07-21:
*"ensures that F.map and F.obj are simultaneously well defined on the whole
continuum of groupoids."* Neither is separately selected by a formalizer.
Repairing `map` while inheriting a carrier for `obj` is the same substitution
one layer down. (This list previously ended "reuse the existing sphere-world
and normalized-state action laws" — the normalized-state half is struck.)

The supporting matrix and group-homomorphism declarations are internal
calculations inside this already-fixed proof.

Phase 1 is complete when the Lean term
`(sectionFunctor A).toFunctor` is this A-specialized orbit–stabilizer functor.

Its purpose is to produce the correct total object:

```lean
A.TotalA =
  Grothendieck
    ((sectionFunctor A).toFunctor ⋙ Grpd.forgetToCat)
```

The entire theorem depends on this being the total category of A's genuine
real-value states and real-value transports.

## Frozen Phase-1 construction

The general distinguished element is already green:

\[
z\longmapsto c\,\frac{z-w}{1-\bar wz}.
\]

The A-case is its exact simpler specialization at \(w=0\):

- the fractional denominator becomes \(1\);
- the translation parameter remains \(0\);
- the projective normalizing scalar becomes \(1\);
- the action is multiplication by the nonzero diagonal multiplier;
- the difficult general multiplication theorem reduces to ordinary
  multiplier multiplication.

The multiplier is one action in three presentations:

- **C2:** the never-zero prime-sum Euler exponential;
- **C1:** the meromorphic continuation carrying that same action through the
  pole;
- **C3/W2/W3:** the Weierstrass-exponential presentation of that action at
  \(N\).

The C3 zeros are transported value states. They are never multipliers. The
multiplier is the nonvanishing exponential unit.

The action is extended with the entire proved factorization

\[
f
=
\operatorname{orbitRep}(b')\,
\operatorname{stabilizerPart}(f)\,
\operatorname{orbitRep}(b)^{-1}.
\]

Both `orbitRep` legs are essential because they carry the source and target
footpoints. A construction using only `stabilizerPart f` loses the continuum.

`distinguishedWorldAction` remains the green
mechanisms. The A-specialization changes the element they carry, not the proof
of how they carry it.

Completing this transcription is a wiring step: specialize the already-proved
harder general element, then reuse the already-proved orbit–stabilizer
argument. It is not a new structural problem.

## The exact categorical readout

Reserve the name \(D\) for the project's general disk-automorphism
construction. Do not use `D` for the component diagram.

Do not introduce another name for the A-section functor. Mathematically it is
\(A\); in Lean it is `(sectionFunctor A).toFunctor`.

The three registers are:

\[
A:\mathcal B\longrightarrow\mathbf{Grpd},
\]

\[
\mathcal T_A:=\int_{\mathcal B}A
=\texttt{A.TotalA},
\]

and

\[
P_A:=\pi_0\circ A:
\mathcal B\longrightarrow\mathbf{Type}.
\]

Their exact Lean forms are:

```lean
(sectionFunctor A).toFunctor :
  GreatCircle.Base ⥤ Grpd
```


```lean
A.TotalA =
  Grothendieck
    ((sectionFunctor A).toFunctor ⋙ Grpd.forgetToCat)
```


```lean
A.ComponentDiagram =
  (((sectionFunctor A).toFunctor ⋙ Grpd.forgetToCat) ⋙
    pi0Functor)
```

Riehl 8.3.4 is instantiated on this exact A-section functor:

```lean
pi0GrothendieckEquiv (sectionFunctor A).toFunctor :
  ConnectedComponents A.TotalA ≃
    Limits.colimit A.ComponentDiagram
```

Its named existence form is:

```lean
pi0_grothendieck (sectionFunctor A).toFunctor
```

Therefore \(P_A\) does not replace or discard \(A\) or \(\mathcal T_A\). It
is the fibrewise component diagram whose colimit reads the connected
components of the total category assembled from the same completed functor.

The direct comparison

```lean
toColimitObj (sectionFunctor A).toFunctor :
  A.TotalA → Limits.colimit A.ComponentDiagram
```

sends a total value state to its colimit class. A genuine morphism or zigzag
in \(\mathcal T_A\) produces equality through:

```lean
toColimitObj_eq_of_hom
toColimitObj_eq_of_zigzag
```

This is how the value transports in the completed total category become the
colimit identifications.

The direction of construction is:

```text
A-section hypotheses
        ↓
A : GreatCircle.Base ⥤ Grpd
        ↓
𝒯_A = ∫ A
        ↓  π₀                    A ↓ π₀ fibrewise
π₀(𝒯_A)  ≃  colim P_A
                       ↓
                  κ ──val──► c
```

The right-hand component diagram is a readout of the same A-section functor.
It never replaces A or its total object.

## The three cocones

Keep three cocones distinct.

### 1. The universal colimit cocone

Its apex is `Limits.colimit A.ComponentDiagram`, with legs:

```lean
Limits.colimit.ι A.ComponentDiagram
```

It is initial among cocones under \(P_A\).

### 2. The generic 8.3.4 cocone

```lean
pi0Cocone (sectionFunctor A).toFunctor
```

has apex:

```lean
ConnectedComponents A.TotalA
```

It is the generic cocone used in the inverse direction of
`pi0GrothendieckEquiv`.

### 3. The A-specific real-value cocone

```lean
labelCocone A
```

has apex `ℝ`. It expresses the real value already carried compatibly by the
completed A-transports.

The universal property gives:

```lean
val A :=
  Limits.colimit.desc A.ComponentDiagram (labelCocone A)
```

with type:

```lean
val A : Limits.colimit A.ComponentDiagram → ℝ
```

and `Limits.colimit.ι_desc_apply` computes `val` on representatives.

The colimit performs the identifications. `labelCocone` records the compatible
value already present. `val` reads it. None of these constructs the A-action.

## Status vocabulary

- **GREEN:** a live declaration already elaborates.
- **TBF:** an exact term or definition still has to be transcribed.
- **TBF → GREEN:** the live declarations and argument that close that
  obligation.
- A theorem named in "TBF → GREEN" is evidence, not a command to manufacture a
  new intermediate object.

Two executable `sorry` terms remain. Before filling them, Phase 1 must
complete the intended transcription of the already-green general
orbit–stabilizer construction to Jesse's simpler A-specialization. This is
ordinary wiring work.

## Evidence-backed closure table

| Phase | Current status | TBF | Evidence-backed TBF → GREEN | GREEN evidence |
|---|---|---|---|---|
| 0. Preserve landed work | `Fstar_pole` and the general-modulus diagonal are green but uncommitted. | Commit them intentionally; `ProjectiveTransport.lean` must be added explicitly because it is untracked. | `Fstar_pole` implements C1's compactified pole value. `diagonalGL_one`, `diagonalGL_mul`, and `diagonalMoebiusHom` implement the \(w=0\), general-modulus multiplication action. | `ProjectiveTransport.lean:27–44`; `CayleyDictionary.lean:63–92`. |
| 1. A's exact distinguished element | The difficult general distinguished element and its composition law are green. The final A-specialization has not yet been transcribed into the A-section functor. | Specialize the general element at \(w=0\); use C2's nonzero Euler exponential, C1 continuation, and C3/W2/W3 at \(N\). Reuse the general proof wholesale. | The general proof is the template; no new carrier or per-arrow formula is introduced. | Reread all live declarations before transcription. |
| 2. Extend over the continuum | The general distinguished-element orbit–stabilizer proof is green. | Specialize that proof wholesale so it defines both `F.obj` and `F.map` across the entire `SphereWorld` continuum. | `orbitRep_spec`, the full `orbit_stabilizer_factor`, and the functor laws simultaneously carry the action to every object and arrow. | Reread all live declarations before transcription. |
| 3. Completed A-section functor | The current `projectiveSkeleton`/`projectiveConnection` route is an A-free shortcut; a map-only repair is insufficient. | Replace the whole shortcut with `(sectionFunctor A).toFunctor`, whose `obj` and `map` both come from the A-specialized construction. The twelve must be properties of those transports. | Deleting A's action data breaks the functor itself; no detached wrapper remains load-bearing. | Positive elaboration of the completed functor. |
| 4. Total and population | \(\mathcal T_A\), `zeroTotal`, and the C3/C4 zero data are defined. | Re-elaborate them against the completed A-section functor. Do not construct another total or populated replacement category. | `A.TotalA` is definitionally the Grothendieck construction of the A-section functor. `normalizedZero_label` supplies each zero's centre; C4 supplies infinitude. The zero states are read off the completed functor's own fibres — **not** from `NormalizedAction.lean`, whose carrier the author ruled out on 2026-07-21. Rows previously citing `normalizedZeroSlicePoint` / `NormalizedAction.lean:118,155` as the value-state supplier cite the shortcut's carrier and are struck as evidence. | `ProjectiveSection.lean:367–379`; `ConcentricityReadout.lean:35`; `NormalizedBase.lean:51`; `ASection.lean:189`. |
| 5. Instantiate 8.3.4 and collapse | `pi0GrothendieckEquiv`, `pi0_grothendieck`, and the comparison theorems are green. `concentricityReadout` has its final type and one `sorry`. | Instantiate the engine at `(sectionFunctor A).toFunctor`. Use the completed functor's own lifted `toNHom` transports through the shared \(N\) to produce one \(\kappa : \operatorname{colim}P_A\). | A total morphism or zigzag in `A.TotalA` gives equality through `toColimitObj_eq_of_hom` or `_of_zigzag`. 8.3.4 identifies \(\pi_0(\mathcal T_A)\) with \(\operatorname{colim}P_A\). | `Theorem.lean:52,68,77,92,108,144`; target at `ConcentricityReadout.lean:43–47`. |
| 6. Real-value cocone | No `labelCocone` is presently defined. Its exact legs are read from the completed A-section functor. | Define `labelCocone A : Limits.Cocone A.ComponentDiagram` with apex `ℝ`. Its naturality must be the completed map's own real-value preservation. | `GpvTransport.lift_endpoint_re_eq`, `projective_level_eq_log_norm_exp`, `euler_branch_level`, `exp_fibre_level`, and `exp_fibre_height_band` are the green value-preservation faces. `normalizedZero_label` computes the cocone only on populated zero states. | `ProjectiveTransport.lean:67`; `ProjectiveCargo.lean:24,89`; `LoopAssembly.lean:161,172`; `NormalizedBase.lean:51`. |
| 7. Universal value reader | Not yet defined. | Define `val A := colimit.desc A.ComponentDiagram (labelCocone A)` and prove its representative calculation, especially on `zeroTotal`. | The universal property and `ι_desc_apply` supply the factorization and computation. | Mathlib `Limits.colimit.desc`, `Limits.colimit.ι_desc_apply`; `toColimitObj` at `Theorem.lean:68`. |
| 8. Atomic Concentricity calculation | `ASection.concentricity` has the exact required type and one `sorry`. | Obtain \(\kappa\), set \(c:=\operatorname{val}(\kappa)\), and prove every zero centre equals \(c\). | `normalizedZero_label` gives the zero's intrinsic value; the representative calculation reads it through `val`; `concentricityReadout` replaces its class by \(\kappa\). | `ConcentricityReadout.lean:50–52`; `NormalizedBase.lean:51`. |
| 9. Cleanup and certificate | Temporary or unused supporting declarations may remain. | Remove `Hypothesis A (_D)`. Audit the completed dependency closure without prejudging it from declaration names. Keep the full distinguished element protected. Run the final full build after cleanup, then print the certificate. | The final source—not a provisional pre-cleanup state—must produce the theorem and axiom report. | Literal theorem statement; expected three axioms; no `sorryAx`; zero executable `sorry`. |

## Phase-1 acceptance evidence

Before treating the functor as completed:

- `(sectionFunctor A).toFunctor` is the A-specialization of the already-green
  general orbit–stabilizer construction.
- Its action uses C2's exponential, C1 continuation, and the C3/W2/W3
  presentation at \(N\).
- `orbitRep`, `orbit_stabilizer_factor`, and `stabilizerPart` are used in that
  construction.
- Both `orbitRep` legs participate; the construction is not reduced to the
  middle stabilizer factor.
- `distinguishedWorldAction` carries that
  specialized element through the two groupoids the author named on
  2026-07-21 — `GreatCircle.Base` and `SphereWorld`. (This bullet previously
  read "sphere-world and normalized-value-state groupoids"; the second half
  named a substitute carrier and is struck.)
- **`obj` is obtained from the construction, not inherited.** An acceptance
  that certifies `map` alone is not a Phase-1 acceptance. The signed-off
  Phase-1 acceptance of 2026-07-21 covered `F.map` only, and is void as an
  acceptance of the functor.
- The twelve are properties of those actual transports.

> **⛔ NO SPECIFICATION LAYER — 2026-07-21.** "The twelve are properties of those transports" is a
> STRUCTURAL fact, not an instruction to write theorems restating them. It is discharged by
> `sectionFunctor_transport_full` (`ProjectiveSection.lean:330`) — every transport is literally
> built from `d_A`, both orbit legs, `stabilizerPart f`, and `φ.mob` — together with the twelve
> being facts about `d_A`, which C1/C2/C3 construct. Element carries the facts + every transport
> is built from the element ⇒ every transport carries them. **A consequence, not a theorem.**
> Three files were written on 2026-07-21 trying to state it (`match transport_eq | rfl`,
> `transport_eq →`, `have _ := …`); all three proved `exact A.<original>` with the transported
> term in ZERO conclusions. Do not write a fourth.

- `A.TotalA` elaborates definitionally from that functor.
- Deleting the A-specialization breaks the functor's own elaboration.
- No new action-like structure, theorem-field carrier, character, free `z`,
  selected path, or per-arrow `(c,w)` is introduced.
- The full build is green.

Acceptance is the positive elaboration of this fixed construction; there is no
declaration-name test.

## Failure-mode quarantine

| Failure pattern | Mechanical tell | Required correction |
|---|---|---|
| The easy specialization is treated as harder than the general theorem. | A new formula, character, or compatibility interface is demanded after the harder \(w\neq0\) theorem is green. | Apply the asymmetry test: specialize at \(w=0\) and reuse the proof. |
| An internal algebraic helper is mistaken for the architecture. | The work is described as a homomorphism proof while the two groupoids and functor disappear. | Restore the A-section functor `GreatCircle.Base ⥤ Grpd` and the sphere-world/value-state action as the controlling types. |
| Generic carrier now, Jesse's action later. | A new `structure …Action`, `∀ R`, or arbitrary A-free input is introduced. | Put A's specialization directly into the A-section functor's map. |
| **The repair is applied to `map` only.** | `map` is rebuilt from the orbit–stabilizer construction while `obj` keeps whatever carrier was already there (e.g. `obj := fun _ => Grpd.of <inherited>`), and the acceptance certifies `map` alone. | Both `obj` and `map` come from the construction — the author, 2026-07-21: *"ensures that F.map and F.obj are simultaneously well defined on the whole continuum of groupoids."* Obtain the fibre from the construction; never inherit it. This is the substitution one layer down, and it has already passed one acceptance. |
| **A substitute is recorded as the author's object in a governing document.** | A contract, "locked" outline, plan, or skill names a carrier as his, marks it PROTECTED or "unchanged," and a later run cites that document as authority. | Only the author names his objects. When a document and a ruling conflict, the ruling governs and the document is corrected in place with the supersession visible. |
| The orbit legs disappear. | The map depends only on `stabilizerPart f`. | Restore both `orbitRep` legs. |
| Analytic facts float outside the functor. | C1/C2/C3/W/GPV occur only in a detached wrapper or downstream theorem. | Make the action defined by those hypotheses load-bearing in the A-section functor. |
| A zero becomes a multiplier. | Raw C3 value `0` is fed into `ℂˣ`. | Zeros are states; the multiplier is the nonzero exponential unit. |
| The continuum is atomized. | Private north objects, per-zero parameter searches, or per-arrow `(c,w)` choices appear. | Use the completed global functor and the standard `toNHom` family. |
| \(P_A\) replaces \(A\) or \(\mathcal T_A\). | The proof starts from a component diagram without first naming the completed functor and total. | Keep the chain \(A\to\mathcal T_A=\int A\), \(A\to P_A\), then apply 8.3.4. |
| 8.3.4 disappears. | \(\pi_0(\mathcal T_A)\simeq\operatorname{colim}P_A\) is absent from the closure sheet. | Instantiate `pi0GrothendieckEquiv (sectionFunctor A).toFunctor` explicitly. |
| Concentricity becomes whole-total connectedness. | `IsConnected A.TotalA`, total `Subsingleton`, or `∀ X Y, Zigzag X Y`. | Collapse only the populated zero states through the shared \(N\). |
| Pairwise equalities replace the colimit. | The proof first derives `re zero n = re zero m`. | Let the completed arrow system and colimit identify the whole family. |
| The cocones are conflated. | `pi0Cocone`, the universal colimit cocone, and `labelCocone` are treated as one object. | Keep their three different apices and roles explicit. |
| A zero-only theorem is mistaken for a cocone definition. | `normalizedZero_label` is used as a function on every component. | Define the full cocone from the completed A-section functor; use the zero theorem only for the final computation. |
| The value is manufactured after collapse. | A scalar bridge, quotient section, or arbitrary map from classes appears. | `val` must be `colimit.desc` of the pre-existing value cocone. |
| A plan sentence creates a fictional target. | "Close by X" appears before the relevant completed term exists, and the next run hunts for an object of type `X`. | State the exact TBF obligation and cite evidence; do not prescribe an unsourced intermediate signature. |
| The easy general-to-special implication is reopened. | The compiled general orbit–stabilizer proof is treated as conditional or awaiting a route decision. | The route is settled: specialize the compiled proof to A. |
| A certificate is printed before the final mutation. | Cleanup occurs after the reported axiom output. | Build and certify only after final dependency cleanup. |
| RH influences type analysis. | Fame, probability, or reception enters a Lean diagnosis. | Downstream consequences get no vote. |

## Execution after approval

1. Read this document, `RELEVANT_GREEN.md`, and the complete skill.
2. Work only in the canonical workspace.
3. Complete the A-specialized, full orbit–stabilizer A-section functor.
4. Build and record the Phase-1 evidence.
5. Verify
   \(\mathcal T_A=A.TotalA=\int A\) and the C3/C4 population.
6. Instantiate 8.3.4:

   ```lean
   pi0GrothendieckEquiv (sectionFunctor A).toFunctor :
     ConnectedComponents A.TotalA ≃
       Limits.colimit A.ComponentDiagram
   ```

7. Close `concentricityReadout`.
8. Construct `labelCocone`, `val`, and the representative calculation.
9. Close `ASection.concentricity` atomically.
10. Remove the detached wrapper and audit the final dependency closure.
11. Run the final full build.
12. Print and read the theorem statement.
13. Print its axioms and verify no `sorryAx`.
14. Stop at 0/0.

## Persistent memory block

1. The general distinguished-element orbit–stabilizer construction is already
   green. The A-case specializes that exact construction.
2. Mathematically the functor is
   \(A:\mathcal B\to\mathbf{Grpd}\). Its Lean spelling is
   `(sectionFunctor A).toFunctor`. Do not rename it.
3. The point of Phase 1 is to build the correct total object:

   \[
   \mathcal T_A=A.TotalA=\int A.
   \]

4. C2 Euler, C1 continuation, and C3/W2/W3 at \(N\) are one A-action in three
   presentations.
5. Full orbit–stabilizer means both `orbitRep` legs and `stabilizerPart`.
6. The construction is a functor between the projective base groupoid and
   sphere-world/value-state groupoids. Algebraic homomorphisms are supporting
   calculations, not replacement architecture.
7. The category-theory chain is
   \(A\to\mathcal T_A=\int A\),
   \(P_A=\pi_0\circ A\), and
   \(\pi_0(\mathcal T_A)\simeq\operatorname{colim}P_A\).
8. \(P_A\) is a readout of A; it never replaces A or `A.TotalA`.
9. The universal colimit cocone,
   `pi0Cocone (sectionFunctor A).toFunctor`, and `labelCocone A` are three
   distinct cocones.
10. The categorical engine can consume only value states and value transports
    genuinely present in A and its total object.
11. `val` is the unique descent of the pre-existing value cocone; it never
    manufactures a scalar.
12. Cleanup precedes the terminal certificate.
13. RH and all downstream consequences have no role in Lean elaboration.
