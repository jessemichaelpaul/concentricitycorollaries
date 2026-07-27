# Concentricity — canonical execution plan

The live Lean declarations are the implementation record. This file governs
execution order.

> **Absolute open-gate lock.** Execution begins and remains at
> `AsectionCResidueInclusion A :
> AsectionCResidueDiagram A ⟶ AsectionActionDiagram A`, through the chain
> `natural transformation → orbit subgroupoid → groupoid preimage →
> AsectionActionDiagram A`. No new static carrier, pointwise preservation
> theorem, per-arrow inverse image, generic replacement, or component source
> depending on free `f`/`Y` is admissible. Generic machinery may appear only
> inside that exact A-specific bundled term. This rule and
> `register/70-whole-square.md` §0 supersede all historical preservation
> language later in this file.

## The theorem

```lean
ASection.concentricity (A : ASection) :
  ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c
```

C1--C4 are intrinsic inputs. In particular, C4 makes the infinitely many
residue-`ℂ` zeros part of the infinite analytic object; they are not
installed later.

## Current status

`F_A = AsectionActionDiagram A`, its framewise value `F_A(X)`, and its
Grothendieck total are triple-certified. `CResidueZeroLocus A` is live and
certified at its semantic C3--C4 type. Its framewise inverse image
`InverseImageCResidueStateWorldGroupoid A X` is also triple-certified.
**CLOSED 2026-07-27, commit `57384ae`** — the exact A-specific natural
restriction is certified, with naturality by `rfl`:

```lean
AsectionCResidueDiagram A : GreatCircle.Base ⥤ Grpd
AsectionCResidueInclusion A :
  AsectionCResidueDiagram A ⟶ AsectionActionDiagram A
```

The live action to restrict is already bundled, on both categorical levels:

```lean
(AsectionActionDiagram A).obj X = AsectionActionFiber A X
(AsectionActionDiagram A).map f = AsectionActionTransport A f
```

No new action and no analytic zero-set argument occurs here. The checkpoint
restricts this existing functor to the author's chosen preimage groupoids and
certifies its component inclusions and naturality square.

> **Certificate correction, 2026-07-27.** Commit `52bde67` certifies a true
> generic full-subcategory inclusion into the Grothendieck total. It does not
> have type `AsectionCResidueDiagram A ⟶ AsectionActionDiagram A`, does not
> expose `𝓡_A(f)`, and does not certify Jesse's `ι_A`. It is retained as a
> packaging checkpoint. The `ι_A` checkpoint itself is **CLOSED** at commit
> `57384ae` (2026-07-27 evening); `52bde67` is still not the certificate.

> **2026-07-27 — superseded framing.** See `register/70-whole-square.md`
> §10 for the exact Lean ruling (§9 is the preceding semantic ruling): the
> lift input is read off the
> already-commuting `0`/`N` preimage square (unique winding) and the round
> trip; it is not a substantive transport theorem. `ι_A` is machinery;
> CHT 8.3.5 consumes what `ι_A` does to the preimage. Restriction then
forces the residue diagram and inclusion. The remaining totalization,
action-groupoid component calculation, readout, theorem, and corollary
wiring follow as the unified endgame gate, with internal kernel checkpoints.

## Gate 1 — certify the global action and its derivative

### Mathematical subject

C1--C4 determine one north-anchored, prime-indexed
Euler--Weierstrass--GPV action. The distinguished element is already
vertically integrated and is simultaneously:

- the slice-preserving function;
- the diagonal Möbius element fixing `0` and `N`;
- the source of intrinsic input and evaluated-output value states.

For an input `s ∈ 𝕆*`, normalization `(dir s, sliceCoord s)` identifies the
sphere and coordinate where this pre-existing action is evaluated.

Orbit--stabilizer transports the same action through projective objects and
arrows, uniformly on every sphere. `G₂` supplies natural isomorphisms
between every Riemann sphere direction in `SphereWorld`.

`AsectionSlice` is one sectional projection. Its constant chosen-world
behavior is not evidence that the global exponential action is constant.

At each projective frame `X`, the completed action produces the native
groupoid:

```lean
Grpd.of
  (AsectionActionStateWorld A (projectiveObjectFrame A X)).
```

`AsectionActionDiagram A` functorially organizes these element-generated
groupoids over the projective base. The notation `F_A` may be used
downstream only as shorthand for that exact live diagram, never as the
primary description of Gate 1.

The value of that functor at one frame is now separately locked:

```text
F_A(X) =
  Grpd.of
    (AsectionActionStateWorld A
      (projectiveObjectFrame A X)).
```

This is not a second functor or a new wrapper. Its focused triple-kernel
receipt verifies
its exact type, all `SphereWorld` directions and normalized coordinates, its
constrained input/positioned/evaluated-output equations, its inherited `G₂`
arrows and groupoid instance, and its projection eyes.

The existing `AsectionEquivariant A : H1 ⥤ H1` is the point-valued function
eye. Gate 1 must certify the exact terminal comparison from the whole action
to that eye.

### Gate-1 audit

Read the live declarations in this order:

```text
C1--C4 infinite analytic object
  → vertically integrated function/Möbius element
  → evaluation on normalized s ∈ 𝕆*
  → orbit--stabilizer on projective objects and arrows
  → G₂ naturality throughout SphereWorld
  → intrinsic input/output value states
  → derived A-specific groupoid-valued diagram
  → terminal round-trip comparison.
```

At each link verify:

1. the subject remains the same distinguished element;
2. no output or value is independently supplied;
3. every claimed object and arrow action is native and functorial;
4. the action includes all normalized inputs and sphere directions;
5. GPV, orbit--stabilizer, `G₂`, input, and output are load-bearing;
6. the terminal comparison is explicit.

If the live declarations do not yet express this unity, propose the smallest
A-specific type and stop for approval before implementation.

### Certification

Gate 1 is certified by the live declarations and audits:

- they build at the exact types;
- exposes object and arrow maps from the same A-specific action;
- retains C1--C4, GPV, orbit--stabilizer, `G₂`, `SphereWorld`, normalized
  input, and evaluated output;
- has the exact terminal comparison;
- has no `sorry`, `admit`, or `sorryAx`;
- have only the agreed axioms.

## Gate 2 — canonical Grothendieck total — certified

The open object is the top-level declaration:

```lean
TotalActionStateWorld A =
  CategoryTheory.Grothendieck
    (AsectionActionDiagram A ⋙ Grpd.forgetToCat).
```

Its informative geometric reading is:

```text
∫ X : GreatCircle.Base,
  Grpd.of
    (AsectionActionStateWorld A
      (projectiveObjectFrame A X)).
```

The kernel receipt confirms that this total records every projective frame
together with its element-generated action state and induced transport,
without substitution by either quarantined point-projection or
Cartesian-product preflight. Its objects and arrows are Mathlib's literal
Grothendieck objects and arrows. The defining equality is `rfl`; the focused
audit uses only `propext`, `Classical.choice`, and `Quot.sound`.

## Endgame backbone: semantic residue locus to invariant subdiagram

The functor, framewise fibre, total, semantic residue locus, and framewise
full inverse-image groupoid are certified. Whole-action preservation is
open. Exact Lean representations after that preservation theorem remain
held.

Define first, at the mathematical level,

```text
Z_A^ℂ := { z : ℂ | A.F z = 0 ∧ 0 < z.im }.
```

This is the upper-half-plane representative locus of the nontrivial
residue-`ℂ` zero spheres. `stem_zero_of_sphereZero` and
`sphereZero_complete` identify it with the C3 divisor; C4 makes it infinite.
It is not populated by choosing an index.

The whole-action eye is **not** a chosen coordinate projection. It is the distinguished
element itself — the middle square connecting all orbit--stabilizers
horizontally, continuously for all `t`, branching from the vertically
integrated twelve-faced disk automorphism. Every state of `F_A(X)` carries
`positioned_by_action : positioned = (coordinateTransport A m_X).obj input`
with `m_X = orbitRep X * distinguishedDiskAction A`, so the element positions
the locus inside `F_A(X)` by construction.

The semantic locus is a `G₂`-invariant subset of the zero kernel of the
A-action. Its full action subgroupoid has one `G₂`-orbit per residue sphere
and retains the direction stabilizer. C3--C4 place these states in the
common north/degenerate kernel through their unique GPV tapes.

At frame `X`, `𝓡_A(X)` denotes the full inverse image of that C-residue
kernel under the whole action. It is implemented as `IsCResidueState A X`,
the named property that the action-positioned coordinate lies in the
coercion-image of `CResidueZeroLocus A`
(`ASectionCResidueInverseImage.lean:38`), with
`InverseImageCResidueStateWorldGroupoid A X` its full subcategory.

**Corrected 2026-07-26 — this paragraph previously said `𝓡_A(X)` "is not the
raw property that one positioned coordinate lies in `Z_A^ℂ`."** That
prohibition was stale and it contradicted the certified code, which
implements exactly that property. Author's ruling: *a leg may be certified
as long as it is a leg of a naturality square.* The positioned-coordinate
reading is such a leg — the left leg of `orbitStabilizerActionSquare A f`,
carried at every instant by `positionedOrbitSquare A f d_t`.
**Sharpened 2026-07-26. The gate is one instantiation wide.**
`positionedOrbitSquare A f d` is defined for arbitrary `d`, so instantiate
it directly at `d = 1`; that gives the native orbit--stabilizer square on
the certified fibres after the routine group simplifications
`m_X * 1 = m_X` and `1⁻¹ * r_f * 1 = r_f`. So `d = 1` **locates** the
certified-fibre member of the arbitrary-`d` family, while the defining
fields of `positionedOrbitSquare A f d_t` supply the all-`t` provenance at
`d_t = diskExpAction (lift t)` by `rfl`. Both instantiations share the
identical left leg `projectiveArrowElement A f`. **No claim is made that
`d = 1` is an instant of every GPV tape**, and none is needed.
See `register/70-whole-square.md`.

So the constraint is on the **proof**, never on the definition. What is
forbidden is **detaching** that leg — treating `projectiveArrowElement A f`
as an arbitrary Möbius map and asking it, alone, to preserve `A.F z = 0`.
Preservation is proved by consuming the whole square: the all-`t`
conjugation, the uniquely forced `stabilizerPart`, the unique GPV tape with
its winding, level, and `0`/`N` faces, and the vertical `G₂`
orbit--stabilizer reading.

*(The stale wording was the trigger for a repeated loop: every reader hit
"the plan forbids this" against "the certified code implements this," and
concluded either that the object was wrong or that mathematics was missing.
Neither was true.)*

The Lean names for these two semantic levels are locked:

```text
CResidueZeroLocus A
InverseImageCResidueStateWorldGroupoid A X
```

The first names the now-live, certified complex zero locus. The second
deliberately records that the next object is the full inverse image of the
C-residue action kernel, consists of the existing whole action states, and
is classified as a groupoid. Its object and arrow parts are one gate. Names
for the later diagram and inclusion remain unchosen until restriction
forces their types.

The general theory must be instantiated in this order. **Two distinct Riehl
books are cited below and their statement numbers collide; each citation
names its book.** *Category Theory in Context* (CTIC) is transcribed in
`SOURCES/Riehl-CTIC.md`; *Categorical Homotopy Theory* (CHT) in
`SOURCES/Riehl.md`. The consolidated citation map is
`register/40-categorical-engine.md` §8.

1. Riehl's subfunctor criterion (**CTIC**, Exercise 2.1.iv, book p. 59)
   turns an objectwise predicate into a
   subdiagram only after every transition map is proved to preserve it.
2. Her fully faithful category-of-elements construction (**CTIC**,
   Proposition 2.4.14, book p. 77 — stated for `Set`-valued diagrams) turns a natural
   transformation into a functor of totals over the same base.
3. For action groupoids, components are orbits and automorphisms are
   stabilizers (**CTIC**, Example 1.5.19, book p. 37, and Example 2.4.10,
   book p. 75); unique orbit--stabilizer factorization therefore controls
   the required arrows.
4. In the present `Grpd`-valued setting, Mathlib's
   `CategoryTheory.Grothendieck.map` performs the corresponding
   totalization, with `Grothendieck.functor_comp_forget` recording that it
   lies over the original base.

This gives the A-specific semantic spine:

```text
for every f : X ⟶ Y in GreatCircle.Base,

geometric receipt:
  x ∈ 𝓡_A(X)  →  F_A(f)(x) ∈ 𝓡_A(Y)

categorical restriction:

𝓡_A(X)  ─────────────────→  𝓡_A(Y)
   │                           │
   │ ι_X                       │ ι_Y
   ▼                           ▼
F_A(X)  ─────── F_A(f) ─────→ F_A(Y)

                         Grothendieck.map

∫𝓡_A  ─────────────────────────────→  TotalActionStateWorld A
  │                                               │
  └──────────────────── over 𝓑 ──────────────────┘
```

The approved Lean name and exact preservation type are locked:

```lean
theorem cResidue_preserved
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    {x : AsectionActionFiber A X} (hx : IsCResidueState A X x) :
    IsCResidueState A Y ((AsectionActionTransport A f).obj x)
```

Its proof consumes the complete all-`t` naturality square at the named
framewise inverse images. It does not unfold a new residue condition,
introduce a second invariance theorem, or alter any frozen object.

The exact all-`t` supplier is already live:

```lean
reindexAsectionPresentation A f :
  AsectionPresentation A X → AsectionPresentation A Y
```

It leaves `gpv` and `euler_gpv` unchanged and reindexes every `toNorth`
triangle, at every lift parameter `t`, through the inverse of the
corresponding `positionedOrbitSquare`. Its identity and composition
theorems, and the resulting `AsectionPresentationTransport`, are green.

The accepted bottom transport is separately
`AsectionActionTransport A f`. No live theorem yet compares the
presentation reindexing with that accepted value-state transport at
`𝓡_A(X)` and `𝓡_A(Y)`. The quarantined Cartesian-product preflight cannot
be used to bridge them: it explicitly leaves presentation and physical
state independently chosen and unbound.

This comparison is exactly the open proof content of
`cResidue_preserved`, not an additional gate. The task is to compose the
two already-green manifestations of the one distinguished action at the
certified inverse images. It must not create a product, another action, or
another residue predicate.

The vertical kernel restriction and its horizontal transport are the two
receipts of one construction. The existing
middle diagrams must prove that the whole distinguished element transports
the C-residue locus while retaining input, positioned state, evaluated zero
output, GPV lift, real level, north leg, and `G₂` direction in the same
naturality square. Invertibility alone does not prove preservation. Nor may
the goal be reduced to invariance under the isolated left Möbius leg: the
theorem is that the **whole A-action preserves semantic residue**.

The approved walk-around fixes the proof architecture. The semantic locus
lies inside the A-action's zero kernel. The `G₂` leg lies
inside each fibre: it changes `I : SphereWorld` and definitionally leaves
the complex coordinate `z` unchanged by
`AsectionState.smul_coordinate = rfl`. Together with output equivariance and
the fact that `G₂` fixes zero, this restricts the kernel without selecting
representatives. The orbit--stabilizer/Möbius leg lies over a base arrow:
its left and right transports satisfy
`left_f * m_X = m_Y * right_f`, so it conjugates the same distinguished
kernel between frames rather than asking an arbitrary Möbius map to
preserve a fixed coordinate set. C3--C4 factor the residue states through
the common north/degenerate kernel, and the north stabilizer preserves that
target. The same quotient theorem is read vertically as
`G₂ / Stab(I) ≃ Orb(I)` and horizontally as
`PGL(2,ℝ) / NorthStabilizer ≃ Orb(N)`. The existing GPV family supplies the
middle square at every `t`, with continuity, winding, level, and uniqueness
preventing any second lift or branch.

The approved uniqueness receipt has the exact type:

```lean
theorem stabilizerPart_unique {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (h : GreatCircle.NorthStabilizer)
    (hf : f.val =
      GreatCircle.orbitRep (CategoryTheory.ActionCategory.back Y) * h.1 *
        (GreatCircle.orbitRep
          (CategoryTheory.ActionCategory.back X))⁻¹) :
    h = GreatCircle.stabilizerPart f
```

The orientation is fixed by the live `orbit_stabilizer_factor`: target
representative `Y` on the left and inverse source representative `X` on the
right. The proof is cancellation and `Subtype.ext` against the definitional
formula for `stabilizerPart`.

These are two categorical legs of one twelve-faced geometric action, not
two generators and not rival predicates on the input and positioned faces.
The next proof must therefore proceed in this order:

```text
1. the rfl-level G₂ coordinate-invariance receipt;
2. the live, audited stabilizerPart_unique at its exact type and
   orientation;
3. positionedOrbitSquare, already uniform in d, instantiated at every
   diskExpAction (lift t), with its identity/composition coherence;
4. reindexAsectionPresentation and its identity/composition laws, carrying
   the complete GPV presentation unchanged while reindexing every north
   triangle;
5. the whole-state preservation declaration obtained by comparing that
   green presentation transport with AsectionActionTransport at the named
   inverse images, retaining every face, including the unique vertical
   GPV-to-N tape and north leg.
```

Steps 1--4 are green, including the live
`GreatCircle.stabilizerPart_unique` and its focused audit. Every mathematical
supplier for Step 5 is green. Step 5 is the exact Lean composition exposing
their whole-action preservation consequence at the inverse-image type, not
a new mathematical theorem or a reconstruction task.

Because Step 5 is quantified over every arrow, it also applies to `f⁻¹`.
There is no separate onto theorem: functoriality supplies the inverse of the
restricted map automatically. The top map and the categorical square are
forced restrictions of `F_A(f)`, never independently designed.
Only afterward does `Grothendieck.map` supply the map of totals over the
same base.

The existing declarations are the vertical eyes and inhabitants against
which that subdiagram will later be checked:

```text
NormalizedZeroObject / normalizedZeroLift
  → residueState / residueActionState
  → residueTotal
  → normalizedNActionSquare
  → residueToNorth.
```

The north “middle diagram” is already linked to the native action by
`normalizedNActionSquare_factors_orbitStabilizer`, then lifted to the fibre
functor by `normalizedNActionTransport_factorization`, and finally realized
in the total by `residueToNorth`. At arbitrary frames, the positioned
orbit square and the existing output-commutation theorems supply the
corresponding naturality evidence. These declarations do not define the
residue subdiagram; they are the existing witnesses that must factor through
it once its intrinsic type is approved.

The sharpened semantic gate order is therefore locked:

```text
1. CLOSED — retain the triple-certified F_A and T_A;
2. CLOSED — retain the triple-certified framewise value F_A(X);
3. CLOSED — retain the certified semantic CResidueZeroLocus A and its
   C3-completeness/C4-infinitude characterization;
4. CLOSED — form and triple-certify
   `𝓡_A(X) = InverseImageCResidueStateWorldGroupoid A X` as the full
   preimage of `CResidueZeroLocus A` under the whole distinguished action
   inside the already-certified `F_A(X)`, without an enumerated carrier;
5. CLOSED 2026-07-27 (`57384ae`) — **and its framing is superseded by
   `register/70-whole-square.md` §§9–10**: closure is structural in the action
   groupoid, carried by the base arrow held as data in the preimage, not a
   preservation theorem. Historical statement retained below.
   Use the vertical/horizontal first-isomorphism comparisons, the existing
   whole-action middle square, the C3--C4 GPV factorization through the
   common north/degenerate kernel, and `stabilizerPart_unique` to prove that
   the whole action preserves this framewise inverse image, using rfl-level
   G₂ coordinate invariance, stabilizerPart_unique at its approved
   orientation, the all-t orbit--stabilizer/GPV middle square, the unique
   vertical GPV-to-N tape, level, north, input, positioned, and evaluated
   output faces simultaneously;
6. CLOSED 2026-07-27 (`57384ae`) — `𝓡_A(f)` is literally `ObjectProperty.lift`
   of `F_A(f)`; `𝓡_A` and its natural inclusion are assembled and the
   categorical square holds by `rfl`;
7. apply Grothendieck.map to obtain the map of totals over 𝓑;
8. use the complete vertical/horizontal first-isomorphism and
   orbit--stabilizer quotient to recognize the residue total as the
   categorified action already built; its certified inhabitants are already
   available and C4 supplies infinitude;
9. apply **CHT** Remark 8.3.5 to obtain the precisely named singleton component
   carrier, then use the category-of-elements identity and the separate
   `pi0GrothendieckEquiv` at `𝓡_A` to certify
   `π₀(∫ 𝓡_A) ≃ colim (π₀ ∘ 𝓡_A) ≃ {the component class of a certified residue inhabitant}`;
10. descend the already-compatible `ℝ`-valued real-level orbit invariant to
    `val_A`, name the exact unique class, define `c` as `val_A` at that class, and prove
    the atomic theorem.
```

The total holds every value state. `𝓡_A` is the A-specific full inverse
image of the semantic residue locus and is the subject of the categorical
one-component calculation.
A larger all-zero inverse image may later be useful as ambient structure,
but it neither defines nor populates `𝓡_A`.

The natural inclusion is the provenance step:

```text
ι_A : 𝓡_A ⟹ F_A
  → Grothendieck.map ι_A : ∫𝓡_A ⟶ TotalActionStateWorld A.
```

It certifies that the category entering Remark 8.3.5 is the collection of
residue value states inside the whole action. It is not itself the singleton
calculation and is not generally an isomorphism `𝓡_A ≅ F_A`. The
objectwise comparison
`𝓡_A(f) ⋙ ι_Y ≅ ι_X ⋙ F_A(f)` is the `liftCompιIso` natural isomorphism.
Remark 8.3.5 then computes `π₀(∫𝓡_A)`, and
`pi0GrothendieckEquiv 𝓡_A` moves that result to
`colim (π₀ ∘ 𝓡_A)`.

The exact next task is the whole-action preservation walk-around at step 5:
start with the already-formed `𝓡_A(X)` and `𝓡_A(Y)`, instantiate
`positionedOrbitSquare A f d` directly at `d = 1` to locate the native
orbit--stabilizer square on the certified fibres, and use the uniquely
forced stabilizer factorization. The defining fields of
`positionedOrbitSquare A f d_t` and `reindexAsectionPresentation A f`
supply the green all-`t` provenance of that same left leg. This proves
`x ∈ 𝓡_A(X) → F_A(f)(x) ∈ 𝓡_A(Y)`. No component, colimit, or reader work
begins before that implication and its restricted square are certified.

Once `𝓡_A` has been assembled as a functorial inverse-image subdiagram, the
project endgame does not use **CHT** Lemma 8.3.4. The next step recognizes
its total as the action groupoid already presented by the baked-in quotient
action. **CHT** Remark 8.3.5 turns its already-inhabited, categorically
one-component action groupoid into its named singleton `π₀`; the
category-of-elements identity performs the colimit identification, and
`pi0GrothendieckEquiv` at `𝓡_A` supplies

```text
π₀(∫_𝓑 𝓡_A) ≃ colim_𝓑 (π₀ ∘ 𝓡_A) ≃ {the component class of a certified residue inhabitant}.
```

The singleton does not create its real reading. The same action already
carries an `ℝ`-valued real-level invariant, and the action-groupoid
calculation shows it is constant on the relation being quotiented. It therefore descends
uniquely to `val_A`; the associated cocone is the categorical expression of
that invariant, not a choice of codomain. Then `c`, which is `val_A` at that class, is
immediate.

C4 has no vote on the categorical one-component calculation; it proves
intrinsic infinitude. The certified inverse image already has inhabitants,
so nonemptiness is not a new build step. No topological connectedness
statement is used. The direct structural route is the
orbit--stabilizer/first-isomorphism identification of the precisely named
coset and orbit objects, with unique stabilizer factorization. Those
A-specific objects are named from the action and triple-kernel certified
before **CHT** Remark 8.3.5 and the generic Grothendieck-components
equivalence are instantiated.

Never abbreviate the resulting project singleton as `1`. Name the exact
singleton component carrier and its unique class, then retain the induced
`val` reader into `ℝ`; the atomic conclusion occurs only at that final
readout.

**No `K_A` is introduced.** The locked project route does not instantiate
**CHT** Lemma 8.3.4 or construct a final functor. Introducing a symbol merely to fit
Riehl's generic letter and then hunting for its project meaning is the
inversion this plan exists to prevent.

The inverse-image audit prevents the zero family from being installed by an
index, label, or enumerated witness. Existing `residueTotal` objects certify
inhabitants, not the inverse image itself.

The existing rule that no zero carrier or zero-only diagram is installed is
therefore correct. The derived framewise C-residue inverse image is already
certified; its whole-action preservation and resulting restricted diagram
are the current authorized gate. Existing GPV north legs are retained as
genuine evidence to be read inside it.

The action-groupoid/readout stage must also certify the exact categorical
compatibility between a residue's real coordinate and its projective base
footpoint. The full octonionic residue input is not equal to the real-axis
point: `normalizedFootpoint ρ.re` records its common real frame. This
compatibility is not required to define the preimage, but it is live when
the real-level orbit invariant is proved well defined and descended to
`val_A`.

**CHT** Lemma 8.3.4 (book p. 101) is the literal finality criterion, stated for a functor
`K`; it remains part of the generic theory but is not instantiated in the
locked project route. The category-of-elements identity occurs inside its
proof (**CHT**, book p. 102) and remains the **mechanism** by which the chosen transport system
yields its colimit class. `pi0GrothendieckEquiv` is the `Grpd`-valued
extension of that identity, applied after the action-groupoid recognition
and **CHT** Remark 8.3.5 (book p. 102) have supplied the named singleton
component carrier.

Generic category theory allows many cocones with many apices. That generic
freedom is not a project ambiguity: the completed action already supplies
the particular `ℝ`-valued real-level invariant. Its orbit invariance forces
the corresponding descent map `val_A`.

### Held homotopical comparison

The canonical execution route remains orbit--stabilizer followed by **CHT**
Remark 8.3.5. A stronger alternative is banked for the post-Lean exposition:

```text
|hocolim N𝓡_A| ≃ B(∫𝓡_A).
```

Thomason's theorem identifies the homotopy colimit of the nerve diagram with
the classifying space of the Grothendieck construction. The supporting
apparatus is already sourced in `SOURCES/Thomason79.md`,
`SOURCES/GJ.md`, `SOURCES/Quillen73.md`, and **CHT** §8.5. The Thomason source
record explicitly notes that the displayed statement is taken from
Sharma's quotation because the original paper text was not fetched.

This route computes strictly more than the required component set and would
require simplicial/homotopy-colimit infrastructure outside the current Lean
gate. It is a follow-up route and research invitation, never a reason to
replace or delay the short orbit proof. Claims identifying the higher
homotopy type with a Borel construction or its higher floors with group
homology remain conjectural directions until separately formalized.

## Held release order after the endgame theorem

Nothing in this section is authorized before the gates above close.

```text
1. complete ASection.concentricity and pass its established triple-kernel
   certification;
2. wire the downstream corollaries to that certified theorem;
3. pass the same triple-kernel certification for the corollary layer;
4. save a clean project checkpoint;
5. update Octonionic_RH_master.tex with curated microhistory prose and the
   proved diagrams, preserving the author's voice;
6. make the blueprint click back to the exact declarations and receipts,
   then use that navigable record to prepare the Zulip phase.
```

The master rewrite is deliberately after the Lean theorem and corollary
receipts. Its central repair will be the now-explicit passage from
orbit--stabilizer invariance, through a natural subdiagram and
`Grothendieck.map`, to the action-groupoid/**CHT** 8.3.5 component collapse and real-level
orbit-invariant descent. It may then point to the sourced Thomason route as
a stronger homotopical follow-up without importing it into the proof.
During the current Lean phase, the standing prohibition on editing the
master remains in force.

## Permanent guards

- Values are inherited by evaluation.
- No semantic constancy in the intended exponential action.
- No generic or conclusion-shaped carrier.
- No whole-total or topological connectedness substituted for the exact
  action-groupoid component calculation.
- No historical or alternate construction used as current authority.
- No `Octonionic_RH_master.tex` edit during the Lean endgame.
