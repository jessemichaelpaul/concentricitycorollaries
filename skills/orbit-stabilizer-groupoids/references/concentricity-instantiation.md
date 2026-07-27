# Concentricity instantiation

Read `register/00-register.md`, `CURRENT_GATE1_MEMORY.md`, and
`EndgamePlan.md` first. Those files decide the current boundary.

## The action-groupoid tower — read this before anything else

**The tower is built from `ActionCategory` at its base levels, and every later
level inherits those arrows.** State it precisely, because the precision is
what controls location error — the live types are these:

```lean
H1                           := ActionCategory G2 (OnePoint Octonion)   -- G2.lean:231
AsectionStateWorld A         := ActionCategory G2 (AsectionState A)     -- ASectionFunctor.lean:396
GreatCircle.Base             := ActionCategory Aut Point                -- ProjectiveBase.lean:58
                                 -- Aut = PGL(2,ℝ), Point = OnePoint ℝ

AsectionActionStateWorld A m := InducedCategory (AsectionStateWorld A)
                                  (fun x : AsectionActionState A m => x.input)
                                                                        -- ASectionActionDiagram.lean:62
AsectionActionStateFiber A m : Grpd                                     -- :71
AsectionActionFiber A X      := AsectionActionStateFiber A
                                  (projectiveObjectFrame A X)           -- :217   ← F_A(X)
IsCResidueState A X          : ObjectProperty (AsectionActionFiber A X) -- 𝓡_A(X) is its FullSubcategory
```

Read the two columns exactly:

| level | literally | inherits from |
|---|---|---|
| `H1`, `AsectionStateWorld A`, `GreatCircle.Base` | `ActionCategory` | — |
| `AsectionActionStateWorld A m`, so `F_A(X)` | `InducedCategory` | `ActionCategory G2 (AsectionState A)` |
| `𝓡_A(X)` | `FullSubcategory` | `F_A(X)` |
| `∫𝓡_A` | `Grothendieck` | `𝓡_A` over `𝓑` |

`InducedCategory`, `FullSubcategory`, and `Grothendieck` are how value states,
the residue restriction, and the base-indexing **ride on** the action groupoid.
They retain its arrows — the `G₂` element is still there, `𝓡_A(X)` is full so
stabilizers are kept — and they are not replacement subjects.

⚠️ **But they are not `ActionCategory`, and that has one operational
consequence:** a Mathlib instance stated for `ActionCategory G X` — such as the
transitive-action `IsConnected` instance at `Action.lean:128` — **does not
resolve automatically** for an `InducedCategory`, a `FullSubcategory`, or a
Grothendieck total. No such automatic instances exist at the pinned revision.
The component receipt for the residue total is therefore an internal
A-specific proof from the inherited vertical and horizontal action arrows, not
an instance lookup. That receipt belongs to its own ladder row; it is not part
of the `ι_A` checkpoint and must not be attempted there.

**The same acting group `G₂` occurs at `H1`, at `AsectionStateWorld`, and hence
in every fibre.** That is not a coincidence to be established downstream. The
distinguished element is simultaneously a group element and a function
(`eulerDiskAction_eq_value`), and `AsectionEquivariant A : H1 ⥤ H1`
(`ASectionEquivariant.lean:43`) is the function eye on the very same action
groupoid. `H1`, the fibres, and the base are views of one element, not three
constructions to be reconciled.

⛔ **Consequence for the endgame.** The total `∫𝓡_A` is the Grothendieck
*packaging* of this tower; the tower is the subject. Do not treat the
`Grothendieck` type as the primary fact and then go looking for a bridge back
to action groupoids — that inverts the direction of determination
(`register/60-failure-audit.md` §1) and manufactures a gap that is not there.
The categorified orbit–stabilizer reading — components are orbits,
automorphisms are stabilizers (CTIC Ex. 1.5.19, Ex. 2.4.10) — applies to these
objects because they *are* action groupoids, and Remark 8.3.5 is applied to
that reading.

⛔ **Do not import a component argument from `ASectionFinality.lean`.** That
file belongs to the retired **finality** route. Its declarations may be green,
but green in another register is not a supplier here. The locked route is
orbit–stabilizer through to Remark 8.3.5; reaching into finality to patch an
apparent gap is a location error, not a repair.

## The two acting directions

### Sphere direction: `G₂`

`SphereWorld` has one object for every unit imaginary octonion direction.
A morphism `SphereHom I J` contains:

```lean
rot : G2
rot_eq : rot • I.val = J.val
mob : Moebius
```

`SphereWorld` is a groupoid because both legs are invertible.
`dirHom` exposes the `G₂` leg. Within an `AsectionState`, the `G₂` action
changes the world and leaves the complex coordinate definitionally fixed:

```lean
ASection.AsectionState.smul_coordinate ... := rfl
```

### Projective/Möbius direction: `GL`, `PGL`, and `Moebius`

Keep the live types distinct:

```text
GL(2,ℂ)
  → Moebius
  = image in Perm(OnePoint ℂ)
  = PGL(2,ℂ) as actual Möbius self-maps.

GreatCircle.Aut
  = PGL(2,ℝ).

GreatCircle.Base
  = ActionCategory GreatCircle.Aut (OnePoint ℝ).

cayleyProjective
  : GreatCircle.Aut →* Moebius.
```

Thus the real projective orbit–stabilizer action is transported into the
Möbius self-maps used in each Riemann-sphere chart. Do not call all three
types `GL`; state which level is meant.

`distinguishedWorldAction m` acts on every `SphereWorld` morphism by:

```text
rot ↦ rot
mob ↦ m * mob * m⁻¹.
```

This is the explicit conjugation of Möbius viewpoints while retaining the
`G₂` direction.

## The two-level instantiation and the exact A-specific restriction (2026-07-27)

The tower is the categorified orbit–stabilizer theory applied twice, and the
already-certified A-specific functor is what the restriction machinery
consumes.

- **Level 0:** `𝓑 = ActionCategory PGL(2,ℝ) (OnePoint ℝ)` is CTIC 1.5.19's
  translation groupoid: one orbit (transitive), anchor `N`, vertex group
  `NorthStabilizer`, and the *arrow-level* orbit–stabilizer content is the
  unique canonical form `orbitRep(Y) · stab · orbitRep(X)⁻¹`
  (`orbit_stabilizer_factor`, `stabilizerPart_unique`).
- **Level 1:** each fibre sits over
  `AsectionStateWorld A = ActionCategory G₂ (AsectionState A)`:
  components = residue spheres (`zeroSphere_eq_orbit`), vertex groups =
  direction stabilizers.
- **Level 2:** by CTIC 2.4.10 applied at the top, `T_A = ∫F_A` **is** the
  action groupoid of the induced action of the base's arrows on the total
  value states — an arrow of `T_A` is literally the element moving a state.

**The gate is CTIC 2.1.iv instantiated at Jesse's already-built functor:**

```lean
(AsectionActionDiagram A).obj X = AsectionActionFiber A X
(AsectionActionDiagram A).map f = AsectionActionTransport A f
```

`AsectionActionTransport A f` already is the categorified action on objects
and arrows. The checkpoint chooses the author's preimage groupoids and
restricts this exact functor to them. `𝓡_A(f)`, the componentwise fully
faithful `ι_A`, and its naturality (`liftCompιIso`) are the restriction
machinery applied at that A-specific object. No analytic zero-set argument
or reconstructed action is an input to this checkpoint.

**The forbidden treatments of the restriction** (all ran on 2026-07-27;
see `register/60-failure-audit.md` §§6h, 6j):

1. **fill-by-hunt** — search for a generic invariance lemma. None exists
   and none can; `exact?`/`apply?` returned empty on record.
2. **slot-deletion** — certify a total-level construction that never
   consumes the transport (`52bde67`: true generic mathematics, the
   author's argument in zero conclusions — reclassified as a packaging
   checkpoint, NOT the `ι_A` gate).
3. **slot-as-burden** — hand the slot back to the author as a new proof
   debt.
4. **pointwise regression** — after the exact functor has been identified,
   analyze a zero predicate or generic essential image instead of restricting
   `AsectionActionTransport A f`.

**The correct treatment — restrict the live functor.** The authored
construction has already filled the categorical action slot:

```lean
AsectionActionTransport A f :
  AsectionActionFiber A X ⟶ AsectionActionFiber A Y
```

Its definition is
`(orbitStabilizerActionSquare A f).actionStateTransport A`; its object,
arrow, identity, and composition behavior is already certified. The formal
landing argument required by `ObjectProperty.lift` is a packaging receipt
for the author's chosen preimage, not a new theorem about a static carrier.
The kernel checkpoint must consume this exact functor, its restricted map,
both inclusion components, and the naturality square.

**Theory ruling (2026-07-27, read verbatim from `SOURCES/Riehl-CTIC.md`):**
Ex. 1.5.19's hom-set decomposition — *"the set of morphisms with domain `x`
is a disjoint union of hom-sets `Hom(x,y)` where `y` ranges over the orbit
`O_x`"* — means an arrow of an action groupoid **cannot leave the orbit of
its domain**, and stabilizer arrows are vertex **automorphisms**.
Consequently a subsystem selected **orbit-wise** (a union of components)
satisfies Ex. 2.1.iv's restriction clause **vacuously**: no closure witness,
no preservation theorem, no stabilizer-stability check exists for it. The
"slot" arises **only** under object-wise static selection — the encoding
that generated every phantom obligation of 2026-07-25/27. Division of
labor: **selection is semantic and the author's** (which orbits, read off
the zeros — non-circular); **closure is structural and automatic**
(components); **stabilizers are retained free** (vertex groups). The one
substantive remaining item is 8.3.5 **connectivity** through `N` (the
tapes), never closure. Combined with the target-first gate in `SKILL.md`,
both failure axes — wrong outer object, object-wise encoding — are closed
mechanically.

## Generic-to-project dictionary

| generic orbit–stabilizer datum | Concentricity datum |
|---|---|
| acting group in a fibre | `G2` |
| acted-on points in a fibre | `AsectionState A`, with varying `SphereWorld` direction |
| action groupoid | `AsectionStateWorld A = ActionCategory G2 (AsectionState A)` |
| projective acting group | `GreatCircle.Aut = PGL(2,ℝ)` |
| projective action groupoid | `GreatCircle.Base` |
| Möbius realization | `cayleyProjective : GreatCircle.Aut →* Moebius` |
| projective stabilizer | `GreatCircle.NorthStabilizer` |
| factorization | `GreatCircle.orbit_stabilizer_factor` |
| uniqueness | `GreatCircle.stabilizerPart_unique` |
| framed action square | `orbitStabilizerActionSquare A f` |
| all-parameter family | `positionedOrbitSquare A f d` |
| value-state transport | `AsectionActionTransport A f` |

The horizontal factorization is:

```text
f.val
  = orbitRep(back Y)
      * stabilizerPart(f)
      * orbitRep(back X)⁻¹.
```

The fixed representatives force the stabilizer term uniquely by
`GreatCircle.stabilizerPart_unique`.

## Approved endgame library

Every implementation action must stay inside this library. The continuous
register checkpoint in `SKILL.md` fixes one row with the real theorem term
and keeps it active through kernel certification.

| role | approved source |
|---|---|
| distinguished element, two-legged squares, all-`t` tape | `Concentricity/ASectionFunctor.lean` |
| projective frames and unique stabilizer factorization | `Concentricity/ProjectiveSection.lean` |
| certified ambient fibres and transports | `Concentricity/ASectionActionDiagram.lean` |
| semantic residue locus | `Concentricity/ASectionCResidue.lean` |
| certified framewise inverse image | `Concentricity/ASectionCResidueInverseImage.lean` |
| canonical ambient total | `Concentricity/ASectionTotalActionState.lean` |
| generic `π₀`/Grothendieck comparison | `Concentricity/Theorem.lean` |
| action groupoids and categorical connectedness | pinned `Mathlib/CategoryTheory/Action.lean` and `IsConnected.lean` |
| component carrier | pinned `Mathlib/CategoryTheory/ConnectedComponents.lean` |
| quotient–orbit equivalence | pinned `Mathlib/GroupTheory/GroupAction/Quotient.lean` |
| full-subcategory restriction | pinned `Mathlib/CategoryTheory/ObjectProperty/FullSubcategory.lean` |
| totalization | pinned `Mathlib/CategoryTheory/Grothendieck.lean` |

The only admissible new Lean modules are the exact gate modules and audit
targets approved in the registered gate lock. A file being nearby, historical,
compiled, or apparently useful does not put it in this library.

## Certified residue objects

At frame `X`:

```text
F_A(X)
  = Grpd.of
      (AsectionActionStateWorld A
        (projectiveObjectFrame A X)).
```

The semantic locus is:

```text
CResidueZeroLocus A
  = {z : ℂ | A.F z = 0 ∧ 0 < z.im}.
```

The certified inverse-image property and full subgroupoid are:

```lean
IsCResidueState A X :
  ObjectProperty (AsectionActionFiber A X)

InverseImageCResidueStateWorldGroupoid A X
  = (IsCResidueState A X).FullSubcategory
```

No enumeration or new arrow populates this subgroupoid.

## Exact open gate

> **2026-07-27 exact Lean ruling:** the subject is already the functor
> `AsectionActionDiagram A`, with object map
> `AsectionActionFiber A X` and arrow map
> `AsectionActionTransport A f`. The open gate restricts those exact maps to
> the author's chosen preimage and packages the component inclusions and
> naturality square. See `register/70-whole-square.md` §10 and
> `register/60-failure-audit.md` §6j.

> ✅ **CLOSED at `57384ae`.** Historical. The certified landing receipt is the
> private `ASection.cResidue_lands`; there is no substantive preservation
> theorem, and none was ever owed (`register/70` §§9–10).

If the representation uses `ObjectProperty.lift`, its formal landing receipt
may retain the registered name:

```lean
theorem cResidue_preserved
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    {x : AsectionActionFiber A X} (hx : IsCResidueState A X x) :
    IsCResidueState A Y ((AsectionActionTransport A f).obj x)
```

The all-`t` presentation supplier is already green:

```lean
reindexAsectionPresentation A f
```

It retains `gpv` and `euler_gpv` and reindexes each north triangle through:

```lean
positionedOrbitSquare A f
  (diskExpAction ((p.gpv δ hp hne).lift t)).
```

Its identity and composition laws are green. The accepted state transport is
already `AsectionActionTransport A f`; do not replace it with the
presentation supplier or unpack it into pointwise coordinate conditions.
The `ι_A` certificate is the restriction of that transport and the
naturality of its component inclusions.

**The gate is one instantiation wide.** `positionedOrbitSquare A f d` is
defined for arbitrary `d`, so instantiate it directly at `d = 1`; that gives
the native orbit–stabilizer square on the certified fibres — the square
`AsectionActionTransport A f` is built from — after the routine group
simplifications `m_X * 1 = m_X` and `1⁻¹ * r_f * 1 = r_f`. So `d = 1`
**locates** the certified-fibre member of the arbitrary-`d` family, and
the defining fields of `positionedOrbitSquare A f d_t` supply the all-`t`
provenance there by `rfl`. **No claim is made that `d = 1` is an instant of
every GPV tape** —
`AsectionGpvLift` imposes no such condition, and nothing here needs it. No
comparison lemma between two squares is required.

The full object is instantiated through the `N`-anchored presentation, while
`0` is the other fixed boundary face of the same diagonal element. Setting
the extra parameter to `d = 1` removes no part of the distinguished action:
that action is already contained in `projectiveObjectFrame A X`.

`positionedOrbitSquare A f d_t` carries the *identical* left leg
`projectiveArrowElement A f` for every `t` — the same term, not a term
equal to it. Both leg equations are the fields of the live definition and
reduce by `rfl`; no separate theorem is a supplier for this gate.

Instantiate at `d_t` and both legs arrive by `rfl`. The tape's only
contribution is the conjugated stabilizer leg `d_t⁻¹ * r_f * d_t`.

### Exact all-`t` supplier inventory

Before claiming that continuity, automorphism, or uniqueness is missing,
inspect the live package at the object actually used:

- `GpvTransport.lift : C(unitInterval, ℂ)` is a continuous lift;
  `GpvTransport.diskExpAction_eq_value` identifies its disk automorphism at
  every `t`; `GpvTransport.continuous_level`, `lift_unique`, and
  `level_independent` supply its continuous and unique real-level data.
- `AsectionGpvLift.lift : C(unitInterval, ℂ)` is likewise continuous, while
  its fields `action`, `continuous_level`, `unique`, and
  `level_independent` are all quantified over the complete tape.
- `positionedOrbitSquare A f d` accepts arbitrary `d`, so
  `d = diskExpAction (lift t)` gives the whole square at every `t`.
- `reindexAsectionPresentation A f` retains `gpv` and `euler_gpv`
  definitionally and rebuilds `toNorth` from that same all-`t` square.

Do not transfer a field between unlike packages. **Author ruling,
2026-07-26:** `NormalizedNActionTape` exposes the same basepoint uniqueness
owned by the distinguished GPV element through the derived field:

```lean
lift_unique :
  ∀ lift' : C(unitInterval, ℂ),
    (∀ t, Complex.exp (lift' t) =
      (zeroLoop *
        poleLoop ^ Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n}) t) →
    lift' 0 = lift 0 →
    lift' = lift
```

The approved mathematical supplier is the already-proved
`winding_lift_unique`. The nonvanishing hypothesis it needs follows from
`lift_exp` and `Complex.exp_ne_zero` at every `t`. The former packaging
omission is repaired and focused-certified by
`_GateNormalizedNActionTapeUniquenessAudit`; do not borrow a theorem from
`ASectionFinality.lean`.

After `cResidue_preserved`, define the top arrow by:

```text
(IsCResidueState A Y).lift
  ((IsCResidueState A X).ι ⋙ AsectionActionTransport A f)
  preservationWitness
```

and take the inclusion square from `liftCompιIso`. Assemble the residue
diagram and natural inclusion, then pass its internal kernel checkpoint.
This is the first checkpoint of the unified endgame gate, not a reason to
leave the approved library.

## Categorified orbit–stabilizer and Remark 8.3.5 stack

After the restricted diagram and natural inclusion are certified:

1. apply `Grothendieck.map` to obtain its canonical total-level inclusion
   over `GreatCircle.Base`. This certifies that `∫𝓡_A` is the collection of
   residue value states inside `TotalActionStateWorld A`;
2. recognize the residue total through the action groupoid already supplied
   by the distinguished element and its vertical/horizontal
   orbit–stabilizer presentations;
3. retain the stabilizer at every vertex through
   `ActionCategory.stabilizerIsoEnd` and the quotient presentation through
   `MulAction.orbitEquivQuotientStabilizer`;
4. read categorical connectedness from the transitive action-groupoid
   instance;
5. apply CHT Remark 8.3.5 to the already-inhabited action groupoid and
   obtain a singleton `ConnectedComponents` carrier. The certified residue
   object supplies its named class; C4 supplies infinitude and is not a
   build step;
6. instantiate `pi0GrothendieckEquiv` at the exact residue diagram;
7. descend the existing real-level orbit invariant to `val_A`, name its
   unique class, and define `c` as `val_A` at it;
8. close `ASection.concentricity` and rewire its existing corollaries.

Every use of “connected” in this stack means categorically connected:
objects joined by zigzags in the action groupoid, equivalently one
`ConnectedComponents` class. No topological connectedness theorem occurs.

The natural inclusion and the component comparisons have separate roles:

```text
ι_A : 𝓡_A ⟹ F_A
  records residue states as a full subdiagram of all value states;

Grothendieck.map ι_A
  records the residue total inside the whole value-state total;

Remark 8.3.5
  computes the residue total's component carrier as a singleton;

pi0GrothendieckEquiv 𝓡_A
  transports that singleton to the colimit of π₀ ∘ 𝓡_A.
```

`ι_A` is a natural transformation with fully faithful components, not
generally a natural isomorphism `𝓡_A ≅ F_A`. The objectwise restriction
comparison

```text
𝓡_A(f) ⋙ ι_Y ≅ ι_X ⋙ F_A(f)
```

is the natural isomorphism supplied by `liftCompιIso`; it is `Iso.refl _`.

### Exact certificate instantiations

The final audit does not certify a generic `ObjectProperty`, generic functor,
or generic natural transformation. Its kernel receipts instantiate the
authored action-groupoid tower at free project data:

```text
X Y : GreatCircle.Base,  f : X ⟶ Y,
F_A(X) = AsectionActionFiber A X,
F_A(f) = AsectionActionTransport A f,
𝓡_A(X) = InverseImageCResidueStateWorldGroupoid A X,
𝓡_A(f) = AsectionCResidueTransport A f,
naturality of ι_A at f = the liftCompιIso square.
```

The category-theory declarations supply the form of these objects and arrows.
Only the displayed A-specific instantiation is the certificate subject.
The audit's six ratified interface checks certify the fixed supplier floor.
Any additional check remains exactly when the elaborated proof term consumes
that declaration. Neither the floor nor an added supplier check is itself the
consumer certificate.

The component calculation is not a new proof that a separately assembled
system happens to be one orbit. It recognizes the categorified
orbit–stabilizer action already built from the distinguished element.
Likewise, nonemptiness is not an open task: the certified inverse image
already has inhabitants, and C4 supplies the stronger infinitude result.

## Registered A-specific naming table

Keep these names active through the implementation loop so no generic slot becomes
the subject:

**RATIFIED (Jesse, 2026-07-26) — the `ι_A` checkpoint. These four names only.**

> ✅ **CLOSED at `57384ae` (2026-07-27).** Historical record. One deviation in
> the certified implementation: the landing receipt is the private
> `ASection.cResidue_lands` in `ASectionCResidueDiagram.lean`, not a public
> `cResidue_preserved` — under the ratified preimage (base arrow held as
> data) it lands by composition `g ≫ f`, so it is machinery, exactly as
> `register/70` §9 predicted. The other three names are as ratified.

| mathematical object | Lean name |
|---|---|
| formal restriction landing receipt | `ASection.cResidue_preserved` |
| restricted arrow `𝓡_A(f)` | `ASection.AsectionCResidueTransport A f` |
| residue diagram `𝓡_A` | `ASection.AsectionCResidueDiagram A` |
| natural inclusion `ι_A : 𝓡_A ⟹ F_A` | `ASection.AsectionCResidueInclusion A` |

Each mirrors a live name — `AsectionActionTransport`, `AsectionActionDiagram` —
so the residue layer reads as the same construction restricted, not a new one.

**NOT YET RATIFIED — later ladder rows, listed only so the slots are visible.**
Do not use these in the `ι_A` checkpoint, and do not treat their presence here
as approval to build them:

| mathematical object | provisional slot |
|---|---|
| residue Grothendieck total `∫𝓡_A` | *(unnamed)* |
| total inclusion `∫ι_A` | *(unnamed)* |
| `π₀(∫𝓡_A)` | *(unnamed)* |
| its distinguished unique class | *(unnamed — read off a certified inhabitant, never named in advance)* |

Names are ratified one checkpoint at a time, at the checkpoint. A provisional
name written down early becomes a subject nobody approved.
| descended real-level reader `val_A` | `cResidueVal A` |
| centre `c`, i.e. `val_A` at that class | `cResidueCentre A` |

Each name denotes the displayed instantiated object, never a new carrier.
Its declaration is introduced only when the preceding checkpoint has fixed
the exact type.

## Do not substitute

- no selected skeleton for the action groupoid;
- no discrete replacement that erases stabilizers;
- no random Möbius-invariance theorem detached from the action square;
- no orbit saturation used to make preservation true by definition;
- no Cartesian product of state and presentation used as a binding theorem;
- no rebuilding of `map_id` or `map_comp` after `ObjectProperty.lift`;
- no promotion of `GL(2,ℂ)`, `PGL(2,ℝ)`, and `Moebius` to one undifferentiated type.
