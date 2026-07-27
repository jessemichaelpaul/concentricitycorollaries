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
AsectionState.smul_coordinate ... := rfl
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
| factorization | `orbit_stabilizer_factor` |
| uniqueness | `stabilizerPart_unique` |
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
`stabilizerPart_unique`.

## Approved endgame library

Every implementation action must stay inside this library. The automatic
register checkpoint in `SKILL.md` names one row before a second proof action
and again before kernel certification.

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
targets approved in the endgame pre-flight. A file being nearby, historical,
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

The one substantive witness is:

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

Its identity and composition laws are green. The accepted state transport
is separately `AsectionActionTransport A f`. No live theorem yet compares
them at the two certified residue inverse images. That comparison is the
proof content of `cResidue_preserved`, not another action or another gate.

**The gate is one instantiation wide.** `positionedOrbitSquare A f d` is
defined for arbitrary `d`, so instantiate it directly at `d = 1`; that gives
the native orbit–stabilizer square on the certified fibres — the square
`AsectionActionTransport A f` is built from — after the routine group
simplifications `m_X * 1 = m_X` and `1⁻¹ * r_f * 1 = r_f`. So `d = 1`
**locates** the certified-fibre member of the arbitrary-`d` family, and
`AsectionFunctor_map_uses_two_legs` supplies the all-`t` provenance at
`d_t`. **No claim is made that `d = 1` is an instant of every GPV tape** —
`AsectionGpvLift` imposes no such condition, and nothing here needs it. No
comparison lemma between two squares is required.

`positionedOrbitSquare A f d_t` carries the *identical* left leg
`projectiveArrowElement A f` for every `t` — the same term, not a term
equal to it. The uniform receipt is green:

```lean
-- ASectionFunctor.lean:1047
theorem AsectionFunctor_map_uses_two_legs (A) (f : X ⟶ Y)
    (p : AsectionPresentation A X) (δ) (hp) (hne) (t : unitInterval) :
    let d := GreatCircle.diskExpAction ((p.gpv δ hp hne).lift t)
    ((positionedOrbitSquare A f d).left  = projectiveArrowElement A f) ∧
    ((positionedOrbitSquare A f d).right =
      d⁻¹ * cayleyProjective (stabilizerPart f).1 * d) :=
  ⟨rfl, rfl⟩
```

Instantiate at `d_t` and both legs arrive by `rfl`. The tape's only
contribution is the conjugated stabilizer leg `d_t⁻¹ * r_f * d_t`.

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
   unique class `k_A`, and define `c := val_A k_A`;
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

The component calculation is not a new proof that a separately assembled
system happens to be one orbit. It recognizes the categorified
orbit–stabilizer action already built from the distinguished element.
Likewise, nonemptiness is not an open task: the certified inverse image
already has inhabitants, and C4 supplies the stronger infinitude result.

## Pre-flight A-specific naming table

Use these names in the implementation pre-flight so no generic slot becomes
the subject:

**RATIFIED (Jesse, 2026-07-26) — the `ι_A` checkpoint. These four names only.**

| mathematical object | Lean name |
|---|---|
| preservation witness | `ASection.cResidue_preserved` |
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
| its distinguished unique class `k_A` | *(unnamed)* |

Names are ratified one checkpoint at a time, at the checkpoint. A provisional
name written down early becomes a subject nobody approved.
| descended real-level reader `val_A` | `cResidueVal A` |
| centre `c = val_A(k_A)` | `cResidueCentre A` |

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
