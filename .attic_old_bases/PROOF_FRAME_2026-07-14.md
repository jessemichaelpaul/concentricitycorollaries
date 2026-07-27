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

# THE CONCENTRICITY THEOREM — THE PROOF FRAME (2026-07-14)

*The frame of record: statement, objects, proof, build targets — each step with its
citation and its Lean instrument.*

## The theorem

Let A be a section of the commutative ring R of slice-preserving functions under the
star product over the octonions, having properties C1–C4. Then the infinitely many
ℂ-residue zeros of the A-section share one real value c. Hence they are concentric.

The statement in Lean:

```lean
def ConcentricityStatement (s : ASection) : Prop :=
  ∃ c : ConnectedComponents s.Total, ∀ d : ConnectedComponents s.Total, d = c
```

π₀(𝒯_A) is a singleton: one conserved kind of object. The scalar reading — the shared
real center — is derived from it in the projection layer (step 6), where
Corollaries.lean consumes it.

## The objects

**𝓑 — the base.** The compactified real great circle carrying its full projective
automorphisms: 𝓑 = PGL(2,ℝ) ⋉ (ℝ ∪ {∞}).

```lean
GreatCircle.Base := ActionCategory PGL(2, ℝ) (OnePoint ℝ)
-- ProjectiveBase.lean; kernel-checked
```

A base arrow is a group element together with its transport equation:
`(p ⟶ q) = { m // m • p.back = q.back }` — `ActionCategory.hom_as_subtype`
(Mathlib, Action.lean:92).

**The sphere world.** One groupoid: the slice Riemann spheres S²_I, one for every
imaginary direction I ∈ S⁶; the G₂ direction arrows between worlds; the Möbius
automorphisms within each world; the U(1) band inside; every world glued along the one
great circle, sharing 0 and N.

```lean
SphereWorld · SphereHom (rot : G2, rot_eq, mob : Moebius)
-- SliceSphereWorld.lean; built
```

**A — the section functor.** Built from C1–C4:

```lean
A : GreatCircle.Base ⥤ Grpd
```

Object action: the section's own evaluation, normalized into the worlds. Arrow action:
the value transports C1–C4 certify — the Euler product of C2, zero-free on its
half-space; the Weierstrass factorization of C3 over the divisor; C1's continuation
through N, where the two exponential presentations are held together by the identity
theorem and the unique tame lifts; the winding conserved. W1–W4 certify the laws:

```lean
A.map_id · A.map_comp
```

**𝒯_A — the ℂ-residue value-transport category.**

```lean
s.Total := Grothendieck (A ⋙ Grpd.forgetToCat)
-- Mathlib, CategoryTheory.Grothendieck
```

Objects: a place on the circle together with an analytic state in the world over it.
Morphisms: a base channel together with its compatible fibre transport. A groupoid,
since the base and the fibres are.

## The proof

**1. Population.** C4 populates the category:

```lean
instance : Nonempty s.Total          -- from C3/C4: the infinite fleet
```

**2. Conservation.** The real value carried by the normalized states is respected by
every morphism — within each fibre and across every base transport — so it is a cocone
under π₀ ∘ A with vertex ℝ.

```lean
CategoryTheory.NatTrans · Functor.const · Limits.Cocone
```

Discharged from the certified transport rows: the level rides the lift
(`winding_lift_unique`, Toolkit.lean:301; `stemWinding_eq_of_lift`, SigmaE3.lean:98);
the phase rides the band (`bandEnd`, SliceSphereWorld.lean:272); the level and crossing
rows (`exp_fibre_level`, LoopAssembly.lean:161; `crossing_height_odd_of_neg`,
SigmaE3.lean:730).

**3. The zigzags.** Any two objects of 𝒯_A are joined by a finite zigzag of its own
morphisms — the zigzags A's transports generate.

```lean
Zigzag                    -- IsConnected.lean:314
Zigzag.of_hom             -- IsConnected.lean:341
zigzag_isConnected :
  [Nonempty J] → (∀ j₁ j₂, Zigzag j₁ j₂) → IsConnected J
                          -- IsConnected.lean:436
```

yielding

```lean
IsConnected s.Total
```

Mathlib's meaning of connected is exact for this argument (IsConnected.lean:60, :75):
a category is connected when every assignment of a value to its objects that is
respected by every transport is constant — one conserved kind of object.

**4. The constancy.** Mathlib's theorem (IsConnected.lean:164):

```lean
constant_of_preserves_morphisms' [IsConnected J] (F : J → α)
    (h : ∀ j₁ j₂ (f : j₁ ⟶ j₂), F j₁ = F j₂) :
    ∃ a : α, ∀ j, F j = a
```

applied with the component assignment — `F := fun X => ⟦X⟧`,
`h := fun X Y f => Quotient.sound (Zigzag.of_hom f)` — yields the singleton:

```lean
∃ c, ∀ d, d = c          -- ConcentricityStatement s   ∎
```

**5. The reading.** The certified readout identifies the class:

```lean
pi0_grothendieck A : π₀(s.Total) ≅ colim (π₀ ∘ A)
-- Theorem.lean:144; CERTIFIED, axioms [propext, Classical.choice, Quot.sound]
```

Riehl, CHT p. 102 (verbatim, SOURCES/Riehl.md): "each arrow connecting two objects in
el X corresponds to a condition demanding that these elements are identified in any
cone under X" — at kernel grade: `Types.colimit_sound` (Types/Colimits.lean:203),
`Types.colimit_eq` (:214). The colimit performs exactly the identifications the
transports generate. And Remark 8.3.5 (verbatim, SOURCES): π₀ sends a category to its
objects up to finite zigzags; a category is nonempty and connected if and only if π₀ is
the singleton.

**6. The value.** The conserved value of step 2 factors through the components and
through the colimit:

```lean
Quotient.lift             -- a value constant on zigzag classes descends to π₀
colimit.desc              -- a cocone factors uniquely through the colimit
                          -- (HasLimits.lean:736)
colimit.ι_desc_apply      -- the computation rule (Types/Colimits.lean:180)
```

giving one map r̄ off the readout. At the one class: **c := r̄(κ)** — one real number,
named after the fact. The projection layer derives the scalar corollary — the ℂ-residue
zeros share the real value c — from the population and r̄, and Corollaries.lean →
cor:rh consumes it unchanged.

## The conserved value and the singleton

**Nonempty is C4's whisper.** IsConnected = IsPreconnected + Nonempty. Preconnectedness
alone says at most one conserved value class; nonemptiness says at least one object
exists to carry a value. Together: exactly one — the singleton. C4 supplies
nonemptiness with infinite room to spare: the population isn't merely nonempty, it's
the infinite fleet.

**And the three faces are one statement.** Riehl's Remark 8.3.5 closes the circle: a
category is nonempty and connected iff π₀ is a singleton. The conserved-assignment
definition, the zigzag characterization, and the π₀-singleton reading are three faces
of the same fact — Riehl states the equivalence on p. 102, Mathlib holds all three with
proofs, and `constant_of_preserves_morphisms'` is the executable form: hand it a value
assignment and the per-arrow conservation hypothesis, receive ∃ a, ∀ j, F j = a — one
common value, its identity unspecified until you look. The ℂ-residue zeros, sitting as
population in the transport category the section built, are one conserved kind of
object; the conserved readout cannot tell them apart; the one value it reports —
plucked afterward, named c — is the common center. Concentricity is the blindness of a
conserved invariant on a category rich enough in transports, and every clause of that
sentence is a cited line in the library.

## The build targets

Four constructions close the frame; each lands with the three certificates
(fidelity, dependency, kernel):

1. **A** — the functor on 𝓑's arrows, `map_id`/`map_comp` certified by W1–W4.
2. **The population** — the ℂ-residue states as objects of 𝒯_A (C3/C4).
3. **The conservation discharges** — step 2's cocone, from the certified rows.
4. **`IsConnected s.Total`** — step 3, by `zigzag_isConnected`, from the transports the
   functor carries.

Then steps 4–6 close `ConcentricityStatement` from the library, and `#print axioms`
prints `[propext, Classical.choice, Quot.sound]`.
