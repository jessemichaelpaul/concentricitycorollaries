> ## RETIRED - PRE-REBUILD MATERIAL, NOT CURRENT (marked 2026-07-20)
>
> This file sits in a retired directory and predates the projective rebuild. It may describe
> objects, bases, functors, and file locations that no longer exist.
>
> **Known stale across this material:**
> - The `cayleyProjective` / generic-Moebius route and the `Hypothesis A (_D)` cargo-as-fields
>   pattern are **SUPERSEDED**. Cargo is not attached to the action; it IS the action. The
>   A-determined Euler/Weierstrass pole action is carried by `stabilizerPart` via orbit-stabilizer.
> - **Deleted modules:** AFunctor, TwoWorlds, PhiConversion, Recovery, ConnectedBase, InboxWire,
>   SynthesisE6, IntegrateTheorem, NormalizedCone, NormalizedNLeg, Base, TransportObject,
>   FaithfulApply, KeystoneAssembly, KeystoneFinality, RecoveryAudit. Their facts were rehomed,
>   largely into ProjectiveCargo / ProjectiveTransport.
> - **Every file:line citation here is unreliable.** Resolve names against the live tree only.
> - Any `rho`/`V_RHO`, `el(V)`, `Disc R`, per-zero `Z_n -> N` leg, generic action record, or
>   parameterized carrier appearing below is a retired substitution, not the construction.
>
> **Current and authoritative:** `PROOF_OUTLINE_LOCKED.md` and
> `BOARD_LECTURE_CONCENTRICITY_2026-07-17.md` (the author own), plus `RESUME_2026-07-20.md`
> for live state.
>
> **Do not take construction, architecture, or status from this file.**

# PHASE 1 — CANDIDATE A1: EQUIVARIANT ADDRESSED VALUE STATES

**Authorial architecture:** Jesse Michael Paul, locked 2026-07-15.

**Status:** Phase-1 candidate for discussion and typed preflight. This file defines no
Lean object and constructs no total category.

## 1. Aim

Construct one well-defined functor

\[
  A:\mathcal B\longrightarrow\mathbf{Grpd},\qquad
  \mathcal B=PGL(2,\mathbb R)\ltimes\operatorname{OnePoint}(\mathbb R),
\]

from the sufficient C1--C4 hypotheses and the certified W1--W4/VT supply. The
construction need not be unique and need not consume every available declaration.

The total-object typing is used backwards as a constraint only:

\[
  (b,x),\qquad
  (f,\varphi):(b,x)\to(b',x'),\qquad
  \varphi:A(f)(x)\to x'.
\]

## 2. Candidate fibre objects

A fibre object over `b : GreatCircle.Base` is an **addressed normalized value state**.
Its origin has the forced two-constructor form

```lean
inductive ValueOrigin (A : ASection)
  | zero (n : ℕ) (I : SphereWorld)
  | north
```

The `north` origin carries no arbitrary world choice: it is the one point shared by
every slice world. An addressed state contains:

1. a `ValueOrigin A`;
2. for a zero origin, the normalized zero/value state supplied by
   `NormalizedZeroObject` and `NormalizedSlicePoint`;
3. its current base footpoint `b`;
4. section-derived channel cargo carrying the normalized origin to `b`.

Schematic dependent type:

```lean
structure AddressedState (A : ASection) (b : GreatCircle.Base) where
  origin  : ValueOrigin A
  channel : SectionChannel A (originFootpoint A origin) b.back
```

The literal fields will be minimized after `SectionChannel` is frozen; fields determined
by `index` and `world` are not duplicated in the Lean record.

The initial C4 population is the canonical state with

```lean
index   := n
world   := I
origin  := A.normalizedZero n I
channel := identity address at origin.footpoint
```

The N-anchor is the canonical addressed state with origin `ValueOrigin.north` and the
identity address at the compactified point. `NormalizedNLeg` supplies the nontrivial
zero-to-N generator between these actual objects.

Categorical identity at a zero or pole state is the ordinary reflexive transport. It is
not forced through `GpvTransport.id`, whose nonvanishing guard correctly applies only to
nonsingular logarithmic channels.

## 3. Candidate analytic channel

`SectionChannel A σ σ'` is the section-derived cargo that can be composed and reversed.
Its nontrivial generating forms are:

- a nonsingular GPV step carrying `GpvTransport A σ σ' k`;
- a vertical sphere-world step carrying `SphereHom` (direction + Möbius/band);
- a real-crossing/flip step carrying the certified crossing data;
- a zero-to-N step carrying `NormalizedNLeg` and the relevant fields of
  `GpvTransportWitness`;
- a pole/N-junction step carrying the cone and winding-closure certificates.

It also has the structural constructors:

- reflexivity;
- reversal;
- composition.

The structural constructors do not add analytic hypotheses. Their analytic meanings and
relations are certified by `GpvTransport.inv`, `GpvTransport.comp`, the winding calculus,
the crossing/flip suite, and W1--W4.

The fullest existing field inventory is `GpvTransportWitness`; Candidate A1 consumes
only the fields needed by the channel constructors and does not import its obsolete
carrier or its old total-object conclusions.

## 4. Candidate fibre morphisms

For `X Y : AddressedState A b`, a fibre morphism is a genuine generated transport from
`X` to `Y`, carrying both analytic and sphere-world legs. The proposed strict packaging
follows the already successful `GpvBase` pattern:

```lean
structure TransportLabel where
  winding : ℤ
  sphere  : SphereHom X.world Y.world

def StateHom (X Y : AddressedState A b) :=
  { d : TransportLabel X Y // Nonempty (TransportEvidence A X Y d) }
```

`TransportEvidence` is generated only by the certified section transports listed in
section 3. Labels compose strictly:

- winding by addition;
- direction and Möbius legs by `SphereHom` composition.

Evidence composes using the certified transport constructors. Category and groupoid laws
then reduce to the label laws by subtype extensionality, exactly as in
`instGroupoidGpvBase`.

The zero-to-N generator gives an analytic arrow from each populated zero state to the
common N-channel state. Its inverses and composites generate the required zigzags without
introducing pairwise indexed zero equalities.

## 5. Uniform base-channel assignment

Every base morphism is handled uniformly through Mathlib's pinned action-category API:

```lean
ActionCategory.homOfPair
ActionCategory.cases
```

Thus it is enough to construct, for a target `t` and group element `g`, the channel for

```lean
homOfPair t g : (g⁻¹ • t) ⟶ t
```

and prove its group coherence. The two group components are detected by
`Matrix.ProjGenLinGroup.signDet`.

The identity component is organized by the author's simultaneous family

\[
  f_{I,\theta,w}(z)=e^{I\theta}\frac{z-w}{1-\bar w z},\qquad I\in S^6.
\]

The Cayley/projective part supplies the horizontal base motion. The simultaneous
`e^{I\theta}` action supplies the vertical band leg in every sphere world. The GPV lift,
level tape, degenerate passages, and pole closure supply the analytic cargo. The other
PGL component is supplied through the determinant-sign split and the certified
crossing/flip channel.

The uniform parameter is one stem parameter `w = a + ib : ℂ` in the disk. In world
`I`, it is realized as `w_I = a + I b`, equivalently by `Octonion.sliceEmbed I w`.
Thus the formula is one intrinsic family specialized simultaneously to every slice, not
a separately chosen octonionic parameter in each world.

For the determinant-negative component the corresponding disk expression is of
conjugation/reflection type; on the slice continuum it exchanges the conjugate direction
register and is matched to the certified crossing/flip transport.

The exact Cayley formulas and mixed component relations are Phase-1 derivations, not new
hypotheses.

Fix a determinant-negative reflection representative `r`. The `signDet` split gives the
uniform presentation

\[
  g\in PGL(2,\mathbb R)^+
  \quad\text{or}\quad
  g=rh\ \text{ with }h\in PGL(2,\mathbb R)^+.
\]

Accordingly `baseChannel` is constructed from:

1. `positiveChannel h`, supplied by the simultaneous disk family and GPV cargo;
2. `reflectionChannel`, supplied by the crossing/flip cargo;
3. the relations `r² = 1`, positive-channel multiplication, and the mixed conjugation
   relation `r h r⁻¹`.

These four relation families are the complete group-level input to `map_id` and
`map_comp`; the definition remains uniform on all arrows through `ActionCategory.cases`.

## 6. Object and morphism actions

For `f : b ⟶ b'`, let `baseChannel A f` be the uniformly constructed section channel.

On objects:

```lean
(A.map f).obj X :=
  X with channel := X.channel.comp (baseChannel A f)
```

The endpoint equation is supplied by the base action equation stored in `f`.

On fibre morphisms, transport the evidence by the same channel action. In geometric
terms this is the simultaneous movement of the GPV cargo and the `SphereHom` cargo; in
the presented groupoid it is the induced action on labels and certified evidence.

```lean
(A.map f).map α := transportEvidence (baseChannel A f) α
```

The `e^{Iθ}` leg acts here on every world's band component; normalized lift uniqueness
and the W-relations identify equivalent representatives.

## 7. Functor laws

The required base bookkeeping is pinned:

```lean
ActionCategory.comp_val : (f ≫ g).val = g.val * f.val
```

Therefore the channel coherence is stated in the matching order:

```lean
baseChannel (f ≫ g) =
  (baseChannel f).comp (baseChannel g)
```

up to the chosen strict label/evidence presentation.

`map_id` consumes:

- the reflexive channel;
- zero winding;
- identity `SphereHom`;
- normalized lift uniqueness where a GPV representative is present.

`map_comp` consumes:

- `GpvTransport.comp`;
- `stemWinding_mul` and winding additivity;
- `SphereHom.comp_rot` / `SphereHom.comp_mob`;
- `bandGL_mul` / `bandEnd`;
- crossing/flip composition;
- the N/pole closure relations;
- representative independence by `stemWinding_eq_of_homotopy` and lift uniqueness.

## 8. Backwards total-object check

With Candidate A1, a future total object is

```lean
(b, X : AddressedState A b)
```

and a future total morphism is

```lean
(f : b ⟶ b', φ : (A.map f).obj X ⟶ Y).
```

This is exactly the two-leg reading of the distinguished Möbius family. No total object is
constructed during Phase 1 or before the functor is green and committed.

## 9. Certified supply consumed first

Minimal first-pass supply:

- `GreatCircle.Base`, `ActionCategory.cases`, `ActionCategory.comp_val`, `signDet`;
- `NormalizedZeroObject`, `NormalizedSlicePoint`, `normalizedZero`;
- `SphereWorld`, `SphereHom`, `dirHom`, `bandEnd`;
- `GpvTransport` with `.inv` and `.comp`;
- `winding_lift_unique`, `stemWinding_eq_of_homotopy`;
- `NormalizedNLeg`, `normalizedZero_pole_power_closes`;
- the crossing/flip constructor and closure rows;
- C4 population.

Additional certified declarations are pulled only when an exact relation requires them.

## 10. Phase-1 questions for authorial ratification

1. Is the addressed-state reading correct: a C-residue/N origin plus its genuine
   section-derived channel to the current projective base point?
2. Does the determinant-negative channel correspond to the certified crossing/flip
   generator in the intended presentation?
