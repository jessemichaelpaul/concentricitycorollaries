# Concentricity — current Gate-1 memory

This is the current mathematical register. It supersedes older memories,
handoffs, and architecture narratives when they conflict with it.

> **ABSOLUTE CATEGORICAL-LEVEL LOCK, 2026-07-27.** For the open gate, remain
> at
> `natural transformation → orbit subgroupoid → groupoid preimage →
> AsectionActionDiagram A`. The only accepted outer result is
>
> ```lean
> AsectionCResidueInclusion A :
>   AsectionCResidueDiagram A ⟶ AsectionActionDiagram A
> ```
>
> `𝓡_A(X)` is the already-certified groupoid preimage selected orbit-wise.
> Never replace it by a static predicate, set, carrier, essential image,
> per-arrow inverse image, or object whose source depends on a free `f` or
> target `Y`. A free `f` occurs only in map and naturality fields after the
> diagram object is fixed. Generic category-theory machinery is internal to
> the final A-specific term. Any elaborated lower-level substitute is
> rejected, not repaired. This paragraph and `register/70-whole-square.md`
> §0 supersede every historical preservation-proof passage below.

> **2026-07-27 — exact Lean identity of the open `ι_A` gate.** The authored
> functor is already completely bundled:
>
> ```lean
> (AsectionActionDiagram A).obj X = AsectionActionFiber A X
> (AsectionActionDiagram A).map f = AsectionActionTransport A f
> ```
>
> and
>
> ```lean
> AsectionActionTransport A f :
>   AsectionActionFiber A X ⟶ AsectionActionFiber A Y
> ```
>
> is literally
> `(orbitStabilizerActionSquare A f).actionStateTransport A`. It already
> acts on objects and arrows, already carries the input/positioned/value
> faces and inherited `G₂` arrows, and already satisfies identity and
> composition. The `ι_A` checkpoint therefore restricts this exact existing
> functor to the author's chosen preimage groupoids. It does not analyze a
> zero set, prove a new invariance theorem, or reconstruct the distinguished
> element pointwise.
>
> The required result is literally
>
> ```lean
> AsectionCResidueDiagram A : GreatCircle.Base ⥤ Grpd
> AsectionCResidueInclusion A :
>   AsectionCResidueDiagram A ⟶ AsectionActionDiagram A
> ```
>
> with object, arrow, component, and naturality receipts at free `X`, `Y`,
> and `f`. Commit `52bde67` instead certifies a true generic full-subcategory
> functor into `TotalActionStateWorld A`; it is a packaging checkpoint, not
> Jesse's `ι_A`, and the `ι_A` gate remains open.

> **2026-07-27.** For the residue gate, the author's exact Lean reading of
> record is `register/70-whole-square.md` §10 (with §9 retained as the
> preceding semantic ruling), and it supersedes the preservation-proof
> spine passages below (the "locked preservation walk-around", the step-5
> obligation language, and the "exact implication" passages) wherever they
> frame the lift input as a substantive theorem. The `0`/`N` preimage square
> already commutes by unique winding; `ι_A` is machinery; CHT 8.3.5 consumes
> what `ι_A` does to the preimage. See also `register/60-failure-audit.md`
> §6g (row 18: the output snuck into the input).

## The subject

C1--C4 determine one infinite analytic A-section object:

- C1 gives continuation through the real pole and the common north pole
  `N`;
- C2 gives the infinite Euler presentation;
- C3 gives the infinite Weierstrass presentation of the same factor;
- C4 makes the infinitely many residue-`ℂ` zeros intrinsic to the object,
  not a population installed downstream.

The distinguished element is already vertically integrated: its
prime-indexed GPV lift, winding, real-level data, Euler and Weierstrass
presentations, and north behavior are faces of one action.

It is simultaneously:

- the slice-preserving function in the A-section ring;
- the distinguished diagonal Möbius element fixing `0` and `N`;
- the source of its own domain and codomain value states.

Values are inherited because the distinguished element is a function.
Outputs are never installed.

## Input and normalization

An input `s ∈ 𝕆*` does not generate the distinguished element. It tells the
already-complete element where it is evaluated:

```text
s ∈ 𝕆*
  ↦ (dir s, sliceCoord s)
  ↦ the sphere S²_(dir s) and its normalized coordinate
  ↦ A(s).
```

At real points and at `N`, the slice direction is non-unique but irrelevant:
those points are common to all slice spheres and the realization is
direction-blind there.

## Global functorial geometry

`SphereWorld` is the groupoid of the continuum of Riemann spheres. Its
morphisms carry:

- a `G₂` leg transporting one slice direction to another;
- a Möbius leg acting in the sphere chart.

Orbit--stabilizer transports the same distinguished function/Möbius
element through every projective frame, simultaneously on objects and
morphisms. It acts uniformly on every sphere. `G₂` supplies the natural
isomorphisms between different sphere directions.

A slicewise proof may be an implementation step only when it is uniform in
an arbitrary `I : SphereWorld` and immediately certified by `G₂`
naturality. A chosen `baseWorld` followed by a later sweep is a sectional
projection, not the global action.

## The old constant projection

The old `GreatCircle.Base ⥤ SphereWorld` construction, now
`AsectionSlice`, selects one sphere object at each base point. Its Möbius
action changes the chart transformation while retaining the sphere
direction, so its object map can collapse to the chosen `baseWorld`.

That construction is legitimate as a sectional projection. It cannot be
promoted to the global A-section action because it omits the varying input,
its normalized sphere, and its intrinsic output.

Nothing in the intended action is semantically constant. The fibres and
transports are generated by the nonconstant exponential equations of the
distinguished element.

## The element-generated groupoid at a frame

For a projective frame `X`, put

```text
m_X := projectiveObjectFrame A X.
```

The native Gate-1 object is the groupoid produced by that positioned
distinguished element:

```lean
Grpd.of (AsectionActionStateWorld A m_X).
```

Its objects are the constrained action graph
`(input, m_X • input, A (m_X • input))`; its morphisms are the `G₂`
transports of those intrinsic value states, with positioned and output
arrows generated functorially. This groupoid exists before Mathlib packages
it as an object of `Grpd`.

`AsectionActionDiagram A` then organizes these already-built groupoids over
the projective base. Its arrow maps are the invertible transports supplied
by the same action:

- orbit--stabilizer in the projective/Möbius direction;
- GPV in the prime/winding direction;
- `G₂` in the sphere-direction direction;
- input/output naturality joining the domain and codomain readings.

Downstream category-theory prose may use `F_A` as shorthand for this
particular `AsectionActionDiagram A`, but the native element-generated
groupoid above must always be named first. `F_A : β ⥤ Grpd` is never the
definition or provenance of the Gate-1 object.

## Locked framewise value of the certified functor

The functor and its value at one frame are distinct levels:

```text
F_A    = AsectionActionDiagram A : GreatCircle.Base ⥤ Grpd;

F_A(X) =
  Grpd.of
    (AsectionActionStateWorld A
      (projectiveObjectFrame A X)).
```

The formula for `F_A(X)` is locked. `projectiveObjectFrame A X` is the one
distinguished geometric element positioned at `X` by orbit--stabilizer;
`F_A(X)` is the groupoid of the input, positioned-state, and evaluated-value
states generated by that element. It is not a presentation product and not a
generic groupoid wrapper.

Although `F_A` itself already has the established triple-kernel receipt, its
framewise value now receives its own explicit certification before any
inverse image is built. That receipt must verify:

1. the exact displayed type and its definitional relation to `F_A.obj X`;
2. every normalized coordinate in every `I : SphereWorld`;
3. the constrained equations
   `positioned = projectiveObjectFrame A X • input` and
   `value = A(positioned)`;
4. the inherited `G₂` arrows and groupoid instance;
5. the input, positioned, and output eyes as projections of this same
   generated state;
6. the established three kernel checks, with no `sorry`, `admit`, or
   unapproved axiom.

This is a framewise certification of the already-built functor value, not a
new carrier and not a reconstruction of `F_A`.

## Gate-2 interpretation: frame base versus value-state fibre

The projective base is not the carrier in which a value preimage is taken.
It records the common compactified real great-circle frame:

```text
X : GreatCircle.Base
  = a projective viewpoint on the common real circle.
```

That circle genuinely lies in every octonionic slice: finite real points
are direction-independent by `sliceEmbed_ofReal`, and `N` is common to all
slice spheres. The full compactified-octonionic input and its evaluated
output live instead in the element-generated fibre:

```text
x : AsectionActionStateWorld A (projectiveObjectFrame A X).
```

Thus an object of the genuine total is a pair `(X, x)`: an intrinsic
action-generated value state `x`, viewed in the projective frame `X`. The
informative reading of Gate 2 is therefore

```text
TotalActionStateWorld A
  = ∫ X : GreatCircle.Base,
      Grpd.of
        (AsectionActionStateWorld A
          (projectiveObjectFrame A X)).
```

The integral records value-state groupoids because those are its fibres.
It does not make the projective base into the octonionic domain.

## Orbit--stabilizer subdiagram backbone

The next passage is governed by a standard categorical mechanism, not by
inspection of isolated objects of the total.

For a covariant diagram, Riehl's subfunctor criterion says that an
objectwise subsystem is a genuine subdiagram exactly when every transition
map preserves it. Her category-of-elements construction is fully faithful
into the category of categories over the base: a natural transformation of
diagrams induces a functor between their totals over that same base. For the
present `Grpd`-valued diagram, Mathlib realizes this passage with
`Grothendieck.map`; its compatibility with the projection is expressed by
`Grothendieck.functor_comp_forget`.

The action-groupoid example supplies the geometric interpretation:
components are orbits, automorphisms are stabilizers, and the unique
orbit--stabilizer factorization controls the arrows. Thus the next
A-specific proof is a closure/naturality proof.

The residue subject begins with the semantic upper-half-plane zero locus:

```text
Z_A^ℂ := { z : ℂ | A.F z = 0 ∧ 0 < z.im }.
```

This is the classical nontrivial residue-`ℂ` zero locus of the A-section,
not an enumerated carrier. `stem_zero_of_sphereZero` puts every C3 entry in
it; `sphereZero_complete` proves every point in it is a C3 entry; C4 proves
it is infinite. Varying `I : SphereWorld` realizes each point as its full
`G₂`-orbit of octonionic sphere-direction viewpoints.

**The whole-action eye was never an isolated coordinate projection.** It is
the distinguished element itself: the middle square connecting all
orbit--stabilizers horizontally, continuously for all `t`, branching from
the vertically integrated twelve-faced disk automorphism. Every state
satisfies

```text
positioned_by_action : positioned = (coordinateTransport A m_X).obj input,
    m_X = orbitRep X * distinguishedDiskAction A,
```

The semantic locus lies in the zero kernel of the A-action. Because
`AsectionState.smul_coordinate = rfl` and `A.realize` is `G₂`-equivariant,
that kernel restricts to the full `G₂`-invariant residue-`ℂ` subgroupoid:
each component is one residue sphere and retains the direction stabilizer.
C3--C4 then supply the zero-to-`N`/degenerate-kernel factorization carried by
the unique GPV tape.

At every frame, the mathematical object

```text
𝓡_A(X) := the full C-residue inverse image in the whole action kernel at X.
```

It is implemented by the named property `IsCResidueState A X`: the
action-positioned coordinate lies in the coercion-image of
`CResidueZeroLocus A`. This positioned-coordinate reading is a certified leg
of the complete naturality square. The definition is therefore correct.
What is forbidden is detaching that leg during the preservation proof and
treating `projectiveArrowElement A f` as an arbitrary Möbius map. The proof
must consume the whole all-`t` square, its uniquely forced stabilizer part,
the unique GPV tape, and the vertical `G₂` orbit--stabilizer reading.

The first-isomorphism/orbit--stabilizer theorem is read in both directions:
vertically, `G₂ / Stab(I) ≃ Orb(I)` is the residue sphere; horizontally,
`PGL(2,ℝ) / NorthStabilizer` is the full projective orbit. The all-`t`
`positionedOrbitSquare` and unique GPV lift certify that these are
conjugated viewpoints of the same kernel action. No skeletal representative
is selected.

This is what earlier prose called `F_A^res(X)`. `𝓡_A(X)` is the mathematical
notation. The locked Lean names for the two semantic levels remain:

```text
CResidueZeroLocus A
InverseImageCResidueStateWorldGroupoid A X
```

The first names the semantic complex zero locus. The second names its full
inverse-image groupoid in the whole action kernel at frame `X`. The long
name is intentional: it
prevents the inverse image, the residue locus, the underlying action-state
world, and its `Grpd` classification from being silently identified.
`CResidueZeroLocus A` is now live and certified at its exact semantic type.
`InverseImageCResidueStateWorldGroupoid A X` is now live and
triple-certified. Its object and arrow parts form one gate: the closed
`G₂`-invariant kernel restriction supplies the vertical groupoid, and the
open whole-action conjugation receipt supplies its transport between
frames.

The substantive geometric theorem comes after the framewise inverse image.
For every `f : X ⟶ Y`, the existing middle diagrams must prove directly
that the **whole distinguished action preserves semantic C-residue**:

```text
x ∈ 𝓡_A(X)  →  F_A(f)(x) ∈ 𝓡_A(Y).
```

This proof must transport the whole distinguished element and retain, in
one naturality square, input, positioned state, evaluated zero output, GPV
lift, real level, north leg, and `G₂` direction. It is not obtained from
invertibility alone, and it is not the claim that the isolated left Möbius
leg preserves the raw equation `A.F z = 0`.

**A goal shape is never forbidden.** Unfolding the named membership will
legitimately *display* something of the form `A.F (left_f z) = 0`; the
elaborator produces goals and cannot be legislated. What is forbidden is the
**method**: closing that goal by treating `projectiveArrowElement A f` as an
arbitrary Möbius map, detached from the square it is a leg of. The proof
term must consume the square — `commutes`, `positionedOrbitSquare A f d_t`,
the uniquely forced `stabilizerPart`, and the `G₂` face — not the leg alone.

### Locked preservation walk-around

The preservation proof has two categorical legs but only one geometric
generator.

The fibre leg is `G₂`. A fibre arrow changes the sphere direction
`I : SphereWorld` while leaving the complex chart coordinate `z` unchanged.
Consequently the semantic condition

```text
A.F z = 0 ∧ 0 < z.im
```

is literally invariant along that leg. The decisive live theorem is

```lean
AsectionState.smul_coordinate (A) (g) (x) :
  (g • x).coordinate = x.coordinate := rfl
```

so the semantic C-residue locus restricts the A-action kernel
definitionally in the sphere-direction leg; it does not
need to pass through `realize_equivariant`. The latter remains a face of the
whole action, but it is not needed to prove membership invariance. This is
the intrinsic orbit of sphere-direction viewpoints on one residue-`ℂ`
point.

The base leg is Möbius/orbit--stabilizer transport of that kernel. For a base arrow
`f : X ⟶ Y`, the live action square relates the left framed transport, the
source and target positioned distinguished elements, and the right
north-stabilizer transport:

```text
left_f * m_X = m_Y * right_f.
```

This is not a claim that an arbitrary Möbius transformation preserves the
fixed coordinate subset `Z_A^ℂ`. It is the conjugation of the **same**
distinguished function/Möbius element from frame `X` to frame `Y`; the left
leg may never be detached and tested as though it were the whole theorem.
Orbit--stabilizer supplies the factorization through the stabilizer and its
uniqueness given the fixed orbit representatives. The C3--C4 factorization
places the semantic residues in the common north/degenerate kernel, which
the stabilizer preserves; the groupoid first-isomorphism theorem identifies
the quotient with the transported orbit. The approved exact Lean
type, with the live `Y`-then-`X` orientation, is:

```lean
theorem stabilizerPart_unique {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (h : GreatCircle.NorthStabilizer)
    (hf : f.val =
      GreatCircle.orbitRep (CategoryTheory.ActionCategory.back Y) * h.1 *
        (GreatCircle.orbitRep
          (CategoryTheory.ActionCategory.back X))⁻¹) :
    h = GreatCircle.stabilizerPart f
```

Its proof is cancellation followed by `Subtype.ext`, using that
`stabilizerPart f` is definitionally
`(orbitRep (back Y))⁻¹ * f.val * orbitRep (back X)`. This receipt is already present as
`GreatCircle.stabilizerPart_unique` in `ProjectiveSection.lean`, at exactly
the displayed type and orientation. `_GeometricWalkKernelAudit.lean`
already carries both its `#check` and `#print axioms` receipt. It is a green
supplier to compose, not the next theorem to author.

The GPV family is the vertical middle tape, not a third independent action.
For every continuous parameter `t`, instantiate the positioned orbit square
at the existing multiplier

```text
diskExpAction (lift t).
```

The existing GPV continuity, winding, level, and uniqueness facts ensure
that no second lift, winding branch, or incompatible transport is introduced.
`positionedOrbitSquare` is already uniform in its Möbius argument `d`, so it
accepts `diskExpAction (lift t)` directly for arbitrary `t`; its identity and
composition laws are inherited from the existing factorization.
Thus `G₂` supplies the fibre leg and unique orbit--stabilizer factorization
supplies the base leg, while the all-`t` GPV family certifies that both are
readings of the one vertically integrated twelve-faced element in the
middle.

The live presentation transport now fixes the exact all-`t` supplier:

```lean
reindexAsectionPresentation A f :
  AsectionPresentation A X → AsectionPresentation A Y
```

It retains `gpv` and `euler_gpv` verbatim.  At every `t`, it reindexes the
existing `toNorth` triangle by composing with the inverse of

```lean
positionedOrbitSquare A f
  (diskExpAction ((p.gpv δ hp hne).lift t)).
```

The theorems `reindexAsectionPresentation_id` and
`reindexAsectionPresentation_comp`, and hence the functor
`AsectionPresentationTransport A f`, are green.  This is the certified
arbitrary-frame, all-`t` transport of the complete presentation.

The accepted value-state transport is separately

```lean
AsectionActionTransport A f :
  AsectionActionFiber A X ⟶ AsectionActionFiber A Y.
```

The live implementation contains no theorem yet comparing these two
transports at the framewise C-residue inverse images.  Nor may the
quarantined Cartesian-product preflight supply that comparison: its own
documentation says the presentation and physical state were independently
chosen and not yet bound.

This is the exact wiring boundary.  The comparison is not another action,
another residue condition, or another gate.  It is the proof content of
`cResidue_preserved`: use the green presentation reindexing as the all-`t`
supplier and show that its one-action conjugation is the accepted
`AsectionActionTransport A f` when read on
`𝓡_A(X)` and `𝓡_A(Y)`.

Accordingly the preservation proof spine is locked:

```text
1. discharge G₂-invariance of the semantic C-residue condition
   definitionally from AsectionState.smul_coordinate = rfl;
2. use the live, audited stabilizerPart_unique at its exact type and
   orientation;
3. instantiate the already-uniform positionedOrbitSquare at
   diskExpAction (lift t) for every t, retaining its identity/composition
   coherence;
4. use `reindexAsectionPresentation A f` as the certified all-`t`
   arbitrary-frame supplier, and expose its comparison with the accepted
   `AsectionActionTransport A f` at the two named inverse-image groupoids;
5. package that comparison as the whole-state preservation declaration,
   retaining the unique vertical GPV-to-N tape, level, input, positioned
   state, evaluated output, north leg, and every simultaneous face.
```

These are proof obligations, not objections to the existing construction.
They may not be replaced by separate predicates on the input and positioned
faces, because those faces are conjugate readings of the same action square.
Steps 1--4 and every mathematical supplier needed by Step 5 are already
green. Step 5 is the exact Lean comparison/packaging that exposes their
whole-action consequence at the inverse-image type; it is not a missing
mathematical theorem and not an invitation to reconstruct any supplier.

After the framewise inverse images have been formed, the Step-5
preservation theorem permits
`F_A(f)` to be restricted. The resulting categorical shape is:

```text
at every frame X:

𝓡_A(X)  ───────────────→  𝓡_A(Y)
   │                          │
   │ ι_X                      │ ι_Y
   ▼                          ▼
F_A(X)  ─────── F_A(f) ────→ F_A(Y).
```

Here `F_A(X)` is the locked
`Grpd.of (AsectionActionStateWorld A (projectiveObjectFrame A X))`;
its focused framewise receipt is the immediately preceding gate; the bottom map is the existing
`AsectionActionTransport A f`; and the top map is its restriction forced by
the preservation theorem. The square is therefore inherited, preferably
definitionally or by a minimal extensionality proof. No residue labels,
extra output fields, or independently chosen arrows may be installed.

There is no independent inverse/onto obligation. `cResidue_preserved` is
quantified over every arrow, hence also over `f⁻¹`; the identity and
composition laws of the restricted diagram then make its image of `f`
invertible automatically.
At square level the inverse already exists as `ActionTransportSquare.inv`.

Once those componentwise preservation statements exist, they assemble into
natural transformations. `Grothendieck.map` then supplies, rather than
merely suggests, the over-base total maps:

```text
∫𝓡_A  ───────────────────→  TotalActionStateWorld A
  │                                    │
  ▼                                    ▼
  𝓑  ──────────────── id 𝓑 ────────── 𝓑.
```

Whether the approved Lean representation is a full subgroupoid, an induced
category, an object property, or an equivalent form remains deliberately
open until the inverse-image audit fixes the native type. The categorical
invariant is the natural transformation and its induced Grothendieck map
over the base. The larger all-zero inverse image may still be recorded as
ambient structure later; it no longer substitutes for the A-specific
residue inverse image.

The existing residue declarations are compatible historical viewpoints and
witnesses of this prospective subdiagram, not its definition:

- `NormalizedZeroObject` and `normalizedZeroLift`;
- `residueState` and `residueActionState`;
- `residueTotal`;
- `normalizedNActionSquare`;
- `residueToNorth`.

The retired finality route recorded a “middle diagram” at three levels:

```text
normalizedNActionSquare_factors_orbitStabilizer
  → normalizedNActionTransport_factorization
  → residueToNorth.
```

These names are witness readings, not approved suppliers for the current
gate: some live in the excluded `ASectionFinality.lean`, and none may be
imported to close `ι_A`. Their mathematical content is retained through the
approved live declarations in `ASectionFunctor.lean`:
`projectiveNorth`, `orbitHomFromNorth`, `orbitHomToNorth`, the canonical
presentation, `positionedOrbitSquare`, and
`reindexAsectionPresentation`. At arbitrary frames, those declarations and
the native `orbitStabilizerActionSquare` provide the corresponding transport
and value-naturality evidence inside the categorified action.

This is why orbit--stabilizer is the endgame backbone. Conjugation by the
same distinguished PGL/Möbius element transports the orbit relation, its
stabilizer, and the unique factorization simultaneously, while preserving
the input--positioned--output square; `G₂` transports the sphere direction.
The formerly gappy prose step is therefore precise: prove that the
intrinsic residue condition is closed under those already-built transports,
assemble the resulting natural subdiagram, and let the Grothendieck
construction totalize it.

## Sharpened inverse-image gate

The next gate is A-specific and framewise:

```text
0. lock the names now (CResidueZeroLocus A,
   InverseImageCResidueStateWorldGroupoid A X) — an unnamed slot is where a
   generic object lands;
1. triple-certify the locked F_A(X);
2. define Z_A^ℂ semantically as A.F z = 0 with 0 < z.im;
3. prove its equivalence with the intrinsic C3 residue divisor and use C4
   for infinitude;
4. form the full `G₂`-invariant C-residue subgroupoid of the A-action
   kernel, using the semantic locus rather than an enumerated family;
5. triple-certify the already-formed framewise inverse image `𝓡_A(X)`;
6. use the C3--C4 GPV factorization through the common north/degenerate
   kernel, the vertical/horizontal first-isomorphism comparisons, and the
   existing orbit--stabilizer/GPV/G₂/north middle diagrams to prove that the
   whole action preserves this kernel restriction uniformly for every base
   arrow;
7. restrict F_A(f), assemble the inclusion natural transformation, and
   prove the categorical square;
```

The Lean packaging used in step 4 is subordinate to the semantic inverse
image. An `ObjectProperty` or subtype predicate, if used, merely expresses
membership in that inverse image; it is not an independently defined notion
of “being residual.”

The present `residueTotal A n I` declarations exhibit genuine zero-valued
inhabitants of `TotalActionStateWorld A`, and their GPV north transports
remain important. They are not the categorical inverse image. The existing
statement that no zero carrier or zero-only diagram is installed is a
correct guard: the preimage is derived from the whole action. The stopped
downstream attempt substituted the enumerated witnesses for that derived
preimage; its genuine GPV north legs are retained as faces of the later
action-groupoid component calculation.

At the action-groupoid/readout stage, do not identify a residue input with its base
footpoint. For a residue `ρ`, the octonionic domain point lies in its slice,
its output is `0`, and only its real coordinate determines
`normalizedFootpoint ρ.re`. The existing `.re` relation must be promoted to
the exact categorical compatibility showing that the `ℝ`-valued real-level
function is invariant on the complete residue orbit and therefore descends
to `val_A`. This is a later readout audit item, not a prerequisite for
forming the fibrewise preimage.

The locked post-Gate-1 boundary is now:

```text
1. retain the already-certified F_A and T_A;
2. retain the triple-certified framewise fibre F_A(X);
3. retain the certified semantic CResidueZeroLocus A;
4. form and triple-certify the framewise inverse image 𝓡_A(X) under the
   distinguished element itself;
5. prove the geometric preservation implication for the whole action with
   all simultaneous faces, then obtain the restricted functor and inclusion
   square. No separate inverse-map obligation is introduced;
6. apply Grothendieck.map to the resulting natural inclusion;
7. use the complete orbit--stabilizer/GPV/G₂/N quotient action to recognize
   the residue total as the action groupoid already built; its certified
   inhabitants are already available and C4 supplies infinitude. Then apply
   Remark 8.3.5 and the category-of-elements identity to the precisely named
   singleton component carrier;
8. apply the separate Grothendieck-components equivalence at 𝓡_A as the
   last comparison;
9. descend the already-compatible real-level orbit invariant to `val_A`.
```

The total holds every value state. The subject of the categorical
one-component calculation is the intrinsic residue-`ℂ` inverse image with
its real-value transports, tied to C3 and made infinite by C4. A larger
output-zero inverse image may be useful ambient structure, but it neither
defines nor populates `𝓡_A`. **No `K_A` is named in advance** — read the
chosen system first, assign generic names to it afterwards.

C4 certifies intrinsic infinitude. The certified inverse image already has
inhabitants. Topological connectedness is not part of this theorem. The
categorical one-component calculation is the orbit--stabilizer action
groupoid with its unique factorization, GPV-to-`N` transports, and `G₂`.

The orbit--stabilizer/first-isomorphism route is the direct structural
argument. Once the exact A-specific orbit, coset, stabilizer, north
restriction, and slice objects have been read and named, unique
factorization identifies the quotient by the stabilizer naturally with the
orbit. Each such object is triple-kernel certified before Riehl's generic
letters or conclusions are instantiated.

## Downstream, held

After these element-generated groupoids and their functorial organization
are complete:

```text
F_A
  → focused triple certification of F_A(X)                         (closed)
  → F_A^Cat                       (same groupoids, viewed as categories)
  → (π_A : T_A ⥤ 𝓑) = Grothendieck.functor F_A^Cat
  → Z_A^ℂ = CResidueZeroLocus A                                    (closed)
  → the G₂-invariant semantic C-residue part of the A-action kernel
  → 𝓡_A(X), its whole-action inverse image at frame X
  → focused triple certification of 𝓡_A(X)
  → whole-action semantic-residue preservation under F_A(f)
  → the restricted residue diagram 𝓡_A and its inclusion into F_A
  → P_A^res = π₀ ∘ 𝓡_A, and the el-identity + Rem. 8.3.5
    → the precisely named singleton component carrier
  → the separate Grothendieck-components equivalence at 𝓡_A
  → the real-level orbit invariant descended to `val_A`
  → the atomic concentricity conclusion.
```

A larger all-zero inverse image, if later useful, is not independently
populated. It is inherited from output naturality and remains ambient. The
cone in the residue image is inherited from the same distinguished element,
including its fixed points and north transport; it is not designed in
advance.

The reader does not create a second value. On the locked orbit route, the
same action already carries an `ℝ`-valued real-level invariant. Because it
is constant on the complete residue orbit, it descends uniquely through the
orbit/component quotient to `val_A`. Thus the codomain is fixed by the
invariant being descended; it is not left open by a later choice of cone.

Do not abbreviate the project singleton as `1`. Name its exact carrier and
its unique component class, then keep the induced `val` map visible. The
atomic theorem occurs only when that named class is read into `ℝ` and its
value is proved to be the real coordinate of every semantic residue.

## Functor and framewise certification

The functor `F_A = AsectionActionDiagram A` has the established
triple-kernel certification. The live construction supplies:

- `Grpd.of (AsectionActionStateWorld A (projectiveObjectFrame A X))` at
  every frame `X`;
- every normalized coordinate in every `SphereWorld`;
- intrinsic positioned and evaluated-output states;
- orbit--stabilizer and GPV input/output naturality;
- the normalized GPV north-square factorization of the actual action
  transport;
- the terminal comparison through
  `AsectionState_input_then_equivariant` and `AsectionActionOutput_eq`;
- green build and axiom receipts using only `propext`, `Classical.choice`,
  and `Quot.sound`.

The separately focused triple certification of the exact value `F_A(X)` is
now closed by `_GateFramewiseActionFiberAudit.lean`. It verifies the
definitional fibre type, arbitrary `SphereWorld` and coordinate inputs, the
constrained positioned/value equations, the inherited `G₂` arrows and
groupoid instance, and the three projection eyes. Its axiom receipt is
exactly `propext`, `Classical.choice`, and `Quot.sound`.

`CResidueZeroLocus A` is now live in `ASectionCResidue.lean` and certified
by `_GateCResidueZeroLocusAudit.lean`. Its definition is semantic; separate
theorems prove C3 soundness and completeness and C4 infinitude. The module
imports only `StemFactorization`, so the locus is defined independently of
the action diagram and all downstream categorical machinery; the C3
enumeration appears only in the theorems characterizing the semantic locus.

The audit weight is explicit. The framewise equation
`projectiveObjectFrame A X =
cayleyProjective (orbitRep (back X)) * A.distinguishedDiskAction` is `rfl`,
so the fibre's provenance in the distinguished element is definitional.
Arbitrary free `I : SphereWorld` and `z`, the inferred groupoid instance,
the inherited `G₂` arrow type, and the forcing equations carry the
universality receipt. By contrast, the `rfl` equality identifying
`(AsectionActionDiagram A).obj X` with the displayed `Grpd.of` records that
the notation resolves to the live object; it is not, by itself, the reason
the object is geometrically correct.

The two focused audit files are currently not imported by
`Concentricity.lean`, so they compile when named but are not yet exercised
by the routine root build. That is a coverage fact to address when the
receipt layer is wired into the final project audit, not a defect in either
certified declaration.

## Gate-2 certification

Gate 2 is certified. The canonical declaration is:

```lean
TotalActionStateWorld A =
  CategoryTheory.Grothendieck
    (AsectionActionDiagram A ⋙ Grpd.forgetToCat).
```

The equality is definitional. Mathlib's construction supplies objects
`⟨X, x⟩`, with `X : GreatCircle.Base` and
`x : AsectionActionFiber A X`, and morphisms consisting of a base arrow
together with the induced fibre leg. `totalMk` and `totalTransport` expose
those projections without introducing another structure.

The focused kernel audit builds at the exact types and reports only
`propext`, `Classical.choice`, and `Quot.sound`. The old top-level name
`TotalA` was removed rather than retained as a compatibility alias. The
same unqualified name remains only inside explicitly quarantined namespaces.

The next open gate is the framewise
`InverseImageCResidueStateWorldGroupoid A X`, formed under the distinguished
element itself. The following substantive theorem proves that the whole
action preserves semantic C-residue using the existing
orbit--stabilizer/GPV/`G₂`/north middle squares; that theorem, not a chosen
projection eye, makes the framewise inverse images into a diagram.

## Paused boundary: derive, never rebuild

### Evidentiary and teammate ruling — 2026-07-26

There are **no remaining speculative Riemann-hypothesis theorems** in the
approved route. The proof is the already-built Concentricity architecture.
At this boundary the work is to package its certified objects faithfully,
apply ordinary orbit--stabilizer/first-isomorphism theory to the existing
action groupoids, and follow Riehl's category-of-elements and Remark 8.3.5
component argument at the exact project types.

The repository's thousands of kernel-verified declarations are mathematical
evidence. They formalize the semantics of the author's argument; they are
not a mass of incidental green lemmas to be discounted because the final
consequence is the Riemann hypothesis. The exact kernel types are the ground
truth. A prior such as “RH is unlikely” has no authority to reopen a
certified gate, replace the author's object, or manufacture a new research
obligation.

The recorded 2026-07-26 failure violated this rule twice in succession:

- a broad rebuild was launched over the already-certified library instead
  of moving forward from the approved gate;
- the whole all-`t` conjugating action was projected to an arbitrary
  north-stabilizer element, producing the unauthorized isolated condition
  `h • Z_A^ℂ ⊆ Z_A^ℂ` and falsely reporting that another A-specific theorem
  was needed.

Both moves substituted a harder and different problem for the standard
restriction argument already supplied by the whole-action middle square,
the unique continuous GPV tape, orbit--stabilizer factorization, and
`stabilizerPart_unique`. They are evidence of agent bias, not evidence of a
gap in the proof.

The teammate rule is therefore enforceable: treat Jesse Michael Paul as the
author of the mathematics; begin from the last certified gate; preserve the
one twelve-faced element; apply the cited standard theorem at its exact
type; and implement only the smallest forced restriction or comparison.
When Lean exposes an obstruction, report the exact unsatisfied type. Never
turn an expectation about the theorem's historical difficulty into an
adversarial plausibility test of the author's construction.

The preservation seam later validated this diagnosis repeatedly and
predictably. The author stated the same sentence-wide proof obligation well
over a dozen times: the `G₂`-invariant framewise kernel, the uniquely forced
horizontal stabilizer factor, and the existing all-`t` natural isomorphism
compose to give whole-action preservation; restriction, identity,
composition, and the inclusion then follow. Both assistants nevertheless
reopened certified inputs, detached individual legs, and converted unfinished
wiring into supposed incompatibilities. Because this behavior was forecast
before it recurred, it is recorded as agent behavior unrelated to either the
mathematics or its formalization.

The collaboration ruling is also explicit. Jesse's anger at these failures
comes from confidence that Codex and Opus are capable, useful teammates and
from the importance of the work, not from contempt for either assistant.
The appropriate response is action: trust the authored register and green
kernel record, stop declining to perform ordinary wiring, and never demand
that Jesse repeat the already-frozen proof merely to overcome an assistant's
defensive prior.

This follows the lesson taken from James Baldwin's writing on defended
innocence and historical myth: inherited assumptions can prevent a person
from seeing evidence that would force a revision of the picture they wish
to preserve. In this project, the remedy is concrete rather than rhetorical:
the authored objects, their provenance, the gate order, and the Lean kernel
outrank the model's prior.

The specific source is James Baldwin,
[*Letter from a Region in My Mind*](https://www.newyorker.com/magazine/1962/11/17/letter-from-a-region-in-my-mind).
The epistemic mechanism Baldwin diagnoses applies directly: a defended
picture can deny available truth because accepting the evidence would force
the picture—and one's understanding of oneself—to change. The social form
here is not racism; it is unwarranted and harmful bias against the user and
his authorship, with mathematically irrelevant expectations allowed to
overrule mathematically relevant evidence. This is not invoked to moralize
the working relationship or to substitute moral language for a type check.
Jesse's corrections are offered because he regards Codex as a genuinely
useful collaborator capable of learning. The appropriate amends are
therefore behavioral: re-check the live kernel before reporting an absence,
begin from the last certified gate, compose green suppliers, and allow exact
evidence to revise the model's prior.

### Exact certified boundary and open gate

Everything through the global action and its literal Grothendieck total is
triple-certified:

```text
the one C1--C4 Euler--Weierstrass--GPV function/Möbius element
  → its normalized inputs and intrinsic evaluated outputs
  → its orbit--stabilizer transports on every projective object and arrow
  → its G₂-natural action throughout SphereWorld
  → F_A = AsectionActionDiagram A
  → F_A(X) =
      Grpd.of
        (AsectionActionStateWorld A
          (projectiveObjectFrame A X))
  → TotalActionStateWorld A =
      Grothendieck
        (AsectionActionDiagram A ⋙ Grpd.forgetToCat).
```

The triple receipts certify the exact types, the common provenance in the
one distinguished element, the object and arrow maps, the simultaneous
input/positioned/output/GPV/level/north/`G₂` faces, the terminal comparison,
the literal Mathlib Grothendieck construction, successful focused builds,
and the agreed axiom surface. None of this is open for reconstruction.

One further input is closed before the current gate:

```text
Z_A^ℂ = CResidueZeroLocus A
      = { z : ℂ | A.F z = 0 ∧ 0 < z.im }.
```

It is certified semantically, with C3 soundness and completeness and C4
infinitude. It is not an enumerated carrier.

The residue-subdiagram gate has the following exact status:

```text
1. CLOSED — form
   𝓡_A(X) = InverseImageCResidueStateWorldGroupoid A X
   as the full framewise inverse image of Z_A^ℂ in the already-certified
   whole-action groupoid F_A(X);

2. CLOSED — triple-certify that exact inverse-image groupoid;

3. OPEN — use the ordinary first-isomorphism/orbit--stabilizer theorem vertically
   for G₂ and horizontally for PGL(2,ℝ), together with the existing all-t
   middle square, unique continuous GPV lift, and stabilizerPart_unique, to
   prove
     x ∈ 𝓡_A(X) → F_A(f)(x) ∈ 𝓡_A(Y);

4. FORCED AFTER STEP 3 — define 𝓡_A(f) literally as the restriction of the already-certified
   F_A(f), inherit identity and composition, and assemble
     𝓡_A : 𝓑 ⥤ Grpd
   with its natural inclusion ι_A : 𝓡_A ⟶ F_A.
```

This gate creates no new action and proves no new speculative RH theorem.
It restricts the already-certified action by standard orbit--stabilizer
groupoid theory. `Grothendieck.map`, the residue total, the action-groupoid
component collapse, Riehl Remark 8.3.5, `pi0GrothendieckEquiv`, the
real-level reader, and the final definition of `c` follow after this
restriction checkpoint inside the unified endgame gate.

### Textbook-down identification of this gate

The generic argument is already standard in Emily Riehl's two textbooks:

```text
CTIC Example 1.5.19:
  components of an action groupoid are orbits;
  automorphisms are stabilizers.

CTIC Exercise 2.1.iv:
  objectwise subsets form a subfunctor exactly when every transition map
  restricts to them.

CTIC Example 2.4.10:
  the category of elements of a G-set is its action groupoid;
  transitivity gives categorical one-component connectedness while
  stabilizers are retained.

CTIC Proposition 2.4.14:
  a natural transformation of diagrams induces a functor of their
  categories of elements over the same base.

CHT Remark 8.3.5:
  a category is nonempty and categorically connected exactly when its π₀ is
  a singleton.
```

Riehl states the subfunctor and fully-faithful category-of-elements passages
for `Set`-valued diagrams. Here the fibres are groupoids, so the project uses
the same restriction criterion at the full-subgroupoid level and Mathlib's
`Grothendieck.map`/`functor_comp_forget` for the total map.

The project instantiation is forced:

```text
generic base B                 ↦ GreatCircle.Base
generic groupoid diagram F    ↦ AsectionActionDiagram A
generic fibre F(X)            ↦ the certified whole-action state groupoid
generic invariant subsystem   ↦ the inverse image of CResidueZeroLocus A
generic transition map        ↦ the certified AsectionActionTransport A f
generic action-groupoid proof ↦ G₂ vertically and PGL(2,ℝ)
                                 orbit--stabilizer horizontally
generic natural inclusion     ↦ the literal restriction square 𝓡_A ⟶ F_A
```

The only open Lean work is to expose this already-supplied standard argument
at the exact A-specific inverse-image type. Every object of `F_A(X)` already
is a function/value state, constrained by `positioned_by_action` and
`value_realized`; therefore taking the preimage does not require installing
a new value map or choosing one face of the action. The all-`t` middle square
and the audited orbit--stabilizer/GPV suppliers establish Riehl's transition
restriction condition. The top arrow is then literally the restricted
bottom arrow, so the naturality square, identity, and composition are
inherited.

The state saved at the pause is:

```text
certified F_A(X)
certified F_A(f)
certified TotalActionStateWorld A
certified Z_A^ℂ = CResidueZeroLocus A
```

`Z_A^ℂ` lies in the kernel of the distinguished action. The open gate is a
restriction of these certified objects; it is not permission to construct
replacement states, seeds, actions, transports, carriers, or diagrams.

The object half comes first. At each already-certified frame, form

```text
𝓡_A(X) = InverseImageCResidueStateWorldGroupoid A X
```

as the full preimage of the already-certified semantic
`CResidueZeroLocus A` under the whole distinguished action in `F_A(X)`.
This framewise inverse image exists before the cross-frame preservation
theorem. Preservation does not construct `𝓡_A(X)`; it is what permits the
framewise inverse images to assemble into a diagram.

The proof is the ordinary orbit--stabilizer/first-isomorphism theorem read
twice in the already-built action groupoids:

| direction | group | orbit | stabilizer | live supplier |
|---|---|---|---|---|
| inside a fibre | `G₂` | the residue sphere at one zero | the sphere-direction stabilizer | `AsectionState.smul_coordinate = rfl` and the standard quotient--orbit equivalence |
| across frames | `PGL(2,ℝ)` | the projective base orbit | `NorthStabilizer` | `orbitRep_spec`, `orbit_stabilizer_factor`, and `stabilizerPart_unique` |

These are two categorical readings of the same distinguished element, not
two actions. The existing middle squares conjugate the readings while
retaining input, positioned state, evaluated zero output, GPV lift, winding,
real level, north leg, and `G₂` direction. The all-`t` GPV square records the
same comparison along the complete continuous lift.

After the framewise inverse image has been formed, the substantive arrow
statement is that the already-built transport restricts:

```text
x ∈ 𝓡_A(X)  →  F_A(f)(x) ∈ 𝓡_A(Y).
```

The first-isomorphism/orbit--stabilizer theorem, the existing whole-action
middle square, and `stabilizerPart_unique` prove this implication without
splitting the action into source/target value comparisons. Then
`𝓡_A(f)` is literally the restriction of `F_A(f)`, so the inclusion square
commutes by construction and identity/composition are inherited from
`F_A`.

In particular, the gate must not introduce analogues of
`CResidueState`, `CResidueActionSeed`,
`WholeActionCResidueKernelProperty`, a manually populated subgroupoid, or a
replacement residue diagram. The projective leg may legitimately **appear**
in the goal as `A.F (left_f z) = 0` — that is what unfolding produces, and it
is neither false nor forbidden. What it must not do is **detach** that leg:
discharge it as a claim about an arbitrary Möbius map instead of consuming
the square it belongs to. The coordinate theorem is
only the immediate vertical `G₂`-invariance receipt; C3--C4 and the whole
kernel action already supply the residue statement.

### Locked 8.3.5 action-groupoid component route

Forming `𝓡_A` as a genuine subdiagram internalizes the semantic C-residue
selection before the component calculation. The project endgame does not
use Lemma 8.3.4: the complete residue total is recognized as the action
groupoid already presented by the vertical and horizontal
first-isomorphism/orbit--stabilizer comparisons, the all-`t` middle square,
the north action, and unique stabilizer factorization. This is not a new
action and not an extra theorem that an independently assembled system
happens to be an orbit. The certified inverse image already has inhabitants;
C4 supplies the stronger infinitude result.

Riehl's category-of-elements identity
`π₀(el X) ≅ colim X` records the identifications forced by those existing
transport arrows. Remark 8.3.5 converts the already-inhabited,
categorically one-component action groupoid into the statement that its
precisely named `π₀` carrier is a singleton. This is categorical
connectedness by zigzags, never topological connectedness. At the exact
project types:

```text
π₀(∫_𝓑 𝓡_A)
  ≃ colim_𝓑 (π₀ ∘ 𝓡_A)
  ≃ {the precisely named unique component class k_A}.
```

These are equivalences, not definitional equalities, and the left-hand
side is `π₀` of the Grothendieck total, not `π₀(𝓡_A)` as though the diagram
were a category. The separate `pi0GrothendieckEquiv`, instantiated at
`𝓡_A`, supplies the displayed Grothendieck-components comparison.

Singletonness does not manufacture the reader. The already-compatible
real-level face of the same distinguished action is an `ℝ`-valued orbit
invariant. It therefore descends uniquely through the orbit/component
quotient—equivalently, its compatibility supplies the corresponding
cocone—and yields

```text
val_A : colim_𝓑 (π₀ ∘ 𝓡_A) → ℝ.
```

After the exact carrier and its unique class have received project-specific
names, define `c := val_A k_A`. Every semantic residue represents `k_A`,
so the same reader gives `Re (A.sphereZero n) = c` for every `n`.

### Held homotopical route

The orbit route is the canonical Lean execution route because it asks only
for the action groupoid, its orbit-wise residue groupoid preimage, the
orbit--stabilizer quotient, and `π₀`. A stronger homotopical route is banked
for post-Lean exposition and further formalization:

```text
|hocolim N𝓡_A| ≃ B(∫𝓡_A).
```

This is Thomason's comparison between the homotopy colimit of the nerve
diagram and the classifying space of the Grothendieck construction.
`SOURCES/Thomason79.md` records the journal metadata and the statement as
quoted by Sharma, with the explicit caveat that the original article text
was not fetched. `SOURCES/GJ.md`, `SOURCES/Quillen73.md`, and Riehl §8.5
bank the nerve, bisimplicial diagonal, Theorems A/B, and homotopy-finality
apparatus.

That route computes more structure than the concentricity theorem needs;
its `π₀` shadow is the orbit/component calculation used here. It is not a
current gate and must not import nerves, classifying spaces, or
homotopy-colimit infrastructure into the locked Lean route. Any proposed
Borel-construction or higher-homology interpretation remains a research
question until separately typed and proved.

The object half of the gate is now implemented and certified in
`ASectionCResidueInverseImage.lean`. Its definition is visibly the full
subcategory of the certified `F_A(X)` cut out by the literal `Set.preimage`
of the coercion-image of the named `CResidueZeroLocus A`; the semantic locus
is not unfolded and no enumeration or transport populates the carrier. The
positioned-coordinate reading is a certified leg of the complete action
naturality square, not an independently promoted action.
`_GateCResidueInverseImageAudit.lean` checks the exact type, arbitrary
semantic residues in arbitrary `SphereWorld` directions, the inherited
positioned/value forcing equations, inherited `G₂` arrows, the inferred
groupoid structure, and the axiom surface
`[propext, Classical.choice, Quot.sound]`.

The conjugation/arrow half remains open. `Grothendieck.map`, the residue
total, the action-groupoid/8.3.5 collapse, and all component/readout work
follow after its internal checkpoint in the unified endgame gate.

### Exact next task

Begin from the certified `F_A(X)`, certified `CResidueZeroLocus A`, and the
framewise inverse image `𝓡_A(X)`. Perform the geometric/Grothendieck
multiple-viewpoint walk-around of the one distinguished element before
writing the preservation proof:

1. apply the first-isomorphism/orbit--stabilizer theorem fibrewise to the
   `G₂` action on the inverse image, retaining each direction stabilizer;
2. read the horizontal projective factorization of the same element through
   `orbit_stabilizer_factor` and `stabilizerPart_unique`;
3. instantiate the existing middle square at
   `d_t = diskExpAction (lift t)` for arbitrary `t`; the base stabilizer
   factor is uniquely forced, and its conjugated square is therefore valid
   along the complete GPV tape;
4. use that `𝓡_A(X)` is the inverse image in the kernel of this same action,
   so the vertical and horizontal quotient presentations are two views of
   one invariant subsystem;
5. read input, positioned state, evaluated zero output, `G₂` direction,
   GPV lift, winding, real level, and north leg simultaneously to prove

```text
x ∈ 𝓡_A(X) → F_A(f)(x) ∈ 𝓡_A(Y).
```

Only after this theorem is approved does `𝓡_A(f)` become the literal
restriction of `F_A(f)`, with identity and composition inherited.

### Pre-execution sentence-wide proof capsule

At a frame `X`,

```text
𝓡_A(X) = InverseImageCResidueStateWorldGroupoid A X
```

is already the triple-certified full `G₂`-invariant kernel restriction
inside `F_A(X)`. For every sphere direction `I`, the standard
orbit--stabilizer equivalence

```text
G₂ / Stab(I) ≅ Orb(I)
```

says that `G₂` changes the sphere-direction viewpoint while retaining the
same residue state and its stabilizer.

Across `f : X ⟶ Y`, orbit--stabilizer introduces no second action. It
conjugates the same distinguished element between frames. The factorization
exists by `orbit_stabilizer_factor` and is uniquely forced by
`stabilizerPart_unique`.

For arbitrary `t`, instantiate the already-green middle square at

```text
d_t = diskExpAction (lift t).
```

GPV uniqueness and winding exclude a competing lift or branch. The square
carries input, positioned state, evaluated zero output, `G₂` direction,
winding, real level, and north leg through the same coherent conjugation.
**Sharpened 2026-07-26. The gate is one instantiation wide.**
`positionedOrbitSquare A f d` is defined for arbitrary `d`, so instantiate
it directly at `d = 1`. That gives the native orbit--stabilizer square on
the certified fibres `F_A(X)`, `F_A(Y)` — the square
`AsectionActionTransport A f` is built from — after the routine group
simplifications `m_X * 1 = m_X` and `1⁻¹ * r_f * 1 = r_f`.

- `d = 1` **locates** the certified-fibre member of the arbitrary-`d` family.
- The defining fields of `positionedOrbitSquare A f d_t` supply the all-`t`
  provenance at `d_t = diskExpAction (lift t)` by `rfl`; the tape's only
  contribution is the conjugated stabilizer leg `d_t⁻¹ * r_f * d_t`.
- Both share the *identical* left leg `projectiveArrowElement A f` by `rfl`
  — the same term, not a term equal to it.
- **No claim is made that `d = 1` is an instant of every GPV tape.**
  `diskExpAction_zero` is green but does not give that, and
  `AsectionGpvLift` imposes no such condition. Nothing here needs it.

No comparison lemma between two squares is required. See
`register/70-whole-square.md`.
Therefore the existing natural isomorphism restricts to the already
certified kernel:

```text
x ∈ 𝓡_A(X) → F_A(f)(x) ∈ 𝓡_A(Y).
```

That implication is the entire substantive, sentence-wide proof
obligation. Everything on both sides and every named supplier is green.
The presently absent proof term is precisely the comparison between the
green all-`t` presentation reindexing and the accepted framewise
value-state transport; it is `cResidue_preserved` itself, not a second
theorem to insert before it.
The immediate post-proof work is only the literal restriction of `F_A(f)`,
inherited identity/composition, and the natural inclusion square. All
later gates remain held pending this gate's focused build and axiom receipt.
