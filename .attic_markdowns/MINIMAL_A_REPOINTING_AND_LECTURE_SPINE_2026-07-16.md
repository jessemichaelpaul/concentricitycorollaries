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

# MINIMAL A-REPOINTING AND LECTURE SPINE — 2026-07-16 (REVISED after Codex's cross-audit)

**AUDIT REQUEST — check against ALIGNMENT points 20–23.** `PROOF_OUTLINE_LOCKED.md` is
the sole architectural record. Two groupoids and one section functor:
𝓑 = PGL(2,ℝ) ⋉ OnePoint ℝ (`GreatCircle.Base`), 𝒮₂ = `SphereWorld`, A : 𝓑 ⥤ Grpd.
No new carrier, fibre groupoid, stabilizer representation, north family, or bundle is
proposed anywhere below. No Lean is edited.

**REVISION RECORD (2026-07-16, later).** Codex's cross-audit of the first version is
ACCEPTED IN FULL: the proposed `sectionFunctorB` (`obj _ := Grpd.of SphereWorld`,
`map f := worldMob (cayleyProjective f.val)`) never consumed `A` — a value-free
substitute (the `A`-parameter unused; `worldMob` fixes every object and conjugates a
label; `sphereWorld_zigzag` already makes π₀(SphereWorld) a singleton with no `A`
anywhere — the forbidden generic-singleton shape). The verdict `REPOINTING PLUS ONE
BRIDGE (worldMob)` is WITHDRAWN; `worldMob` is quarantined to possible-helper status.
§3 is rewritten as the three exact pins Codex requested; §4's universal headline is
corrected to the multiplicity-general closure; §5 carries the honest verdict.

**Supersession note (recorded per guardrail 3):** the pointed-carrier fibre of
`DIRECT_A_FUNCTOR_FORMULAS_2026-07-16.md` §1 (a `Groupoid` instance on
`NormalizedSlicePoint`) was withdrawn earlier this same day as a carrier design. Note
the standing tension the audit surfaces (accepted, not relitigated): the populated
value states live in `NormalizedSlicePoint`, and `SphereWorld`'s objects (bare
directions) cannot hold them — the fibre-type ruling is the author's, with both prior
artifacts in view (Pin 1, typing consequence).

**Quarantine list (Codex landing plan, step 1 — confirmed):** `ASection.functorA` +
`TotalA`/`readout` (AFunctor.lean); the `H1 ⥤ S2` endpoints of the old
`sectionFunctor` (its A-dependent content is mined in §1/§3, the wrapper quarantined);
`BaseC`-typed carriers (`NormalizedCircleBase`, `normalizedFootpoint` — the footpoint
field's carrier); `worldMob`-as-the-bridge; every value-free surrogate.

**The register test (the author's caution, 2026-07-16, made mechanical).** Φ — the old
`sectionFunctor : H1 ⥤ S2` — is NOT the A-section functor of the locked proof; it is
an earlier register's rendering, and many certified rows were proved in older
registers. Not fatal, but tracked from here on by one inspectable criterion, applied
at every consumption site: **look at the theorem's TYPE.** If a quarantined constant
(`H1`, `S2`, `ASection.Base`, `BaseC`, `functorA`, `TotalA`, `GpvBase`) appears in the
statement's type, the row is REGISTER-BOUND — its content is mined by re-proof on the
locked objects, never consumed as-is. If the type mentions only analytic constants
(`A.realize`, `A.F`, `stemWinding`, `sliceEmbed`, `GpvTransport`'s paths, `SphereWorld`,
`GreatCircle.*`, Mathlib), the row is FREE SUPPLY and transfers unchanged. Example, run
on Pin 1's rows: `realize_sphereZero_pt` is FREE (its type mentions only `A.realize`
and `sliceEmbed`); `phi_sphere_obj`/`phi_glue`/`phi_class_eq` are REGISTER-BOUND
wrappers of that same fact (their types mention `sectionFunctor`/`H1`/`S2`).

---

## 1. Existing `obj` and `map`

**`sectionFunctor`** — [TwoWorlds.lean:142](Concentricity/TwoWorlds.lean:142)

```lean
def sectionFunctor (A : ASection) : H1 ⥤ S2 where
  obj x := S2.of (A.realize (CategoryTheory.ActionCategory.back x))
  map {p q} f :=
    S2.directionHom f.val (A.realize (ActionCategory.back p))
      (A.realize (ActionCategory.back q))
      (by rw [← A.realize_equivariant]; exact congrArg A.realize f.property)
  map_id p := S2.directionHom_one _ _
  map_comp f g := S2.directionHom_mul _ _ _
```

The genuinely A-dependent Φ (master `thm:section-functor`): objects through the
realization, morphisms through the direction generators along `realize_equivariant`,
`map_id`/`map_comp` proved through the direction relations. Endpoints:
`H1 = ActionCategory G2 (OnePoint Octonion)` ([G2.lean:231](Concentricity/G2.lean:231))
and `S2 = CategoryTheory.Quotient SliceWorld.Rel` (point-level;
[TwoWorlds.lean:71](Concentricity/TwoWorlds.lean:71)).
**Classification: correct content on an obsolete endpoint.**

**`sectionFunctor_obj`** — TwoWorlds.lean:166
```lean
theorem sectionFunctor_obj (A : ASection) (x : OnePoint Octonion) :
    (sectionFunctor A).obj (H1.of x) = S2.of (A.realize x) := rfl
```
The object pin "Φ(q) = A(q)". **Correct content on an obsolete endpoint.**

**`sectionFunctor_map_direction`** — TwoWorlds.lean:156
```lean
theorem sectionFunctor_map_direction (A : ASection) (g : G2) (x : OnePoint Octonion) :
    (sectionFunctor A).map (show H1.of x ⟶ H1.of (g • x) from ⟨g, rfl⟩)
      = (Quotient.functor SliceWorld.Rel).map
          (Quiver.Hom.toPath (SliceWorld.Gen.direction g (A.realize x)))
        ≫ eqToHom (congrArg S2.of (A.realize_equivariant g x).symm) := rfl
```
The morphism pin "Φ(g : q → g·q) = (g : A(q) → A(g·q))".
**Correct content on an obsolete endpoint.**

**`worldRot`** — [AFunctor.lean:43](Concentricity/AFunctor.lean:43)
```lean
def worldRot (g : G2) : SphereWorld ⥤ SphereWorld where
  obj I := ⟨g • I.val, G2.smul_mem_unitImaginarySphere g I.prop⟩
  map {I J} φ := ⟨g * φ.rot * g⁻¹, …, φ.mob⟩
```
The G₂ endofunctor of the retained sphere world: rot conjugated, mob untouched.
**Correct reusable construction.**

**`worldRot_one`** (AFunctor.lean:59) `worldRot 1 = 𝟭 SphereWorld`;
**`worldRot_comp`** (AFunctor.lean:68) `worldRot g ⋙ worldRot h = worldRot (h * g)`.
Proofs: `Functor.ext` + `SphereHom.ext` + `group`.
**Both: correct reusable constructions** — and the exact proof template for the one
bridge in §3.

**`functorA`** — AFunctor.lean:124
```lean
def functorA (A : ASection) : A.Base ⥤ Grpd where
  obj _ := Grpd.of SphereWorld
  map {σ σ'} k := worldRot (poleGen ^ k.val)
```
Domain `A.Base = {σ : OnePoint ℝ // A.NonSingular σ}` (the old winding base,
ConnectedBase.lean:83); action a fixed powered rotation chosen at the `Classical.choose`
slack (`poleGen`). **Superseded wrapper** (the HANDOFF guardrail names it) — while its
`obj _ := Grpd.of SphereWorld` line and the `worldRot` content inside it remain correct
and are reused in §3. Not classified irrelevant: its elaboration kernel-tested the
exact syntax shape §3 needs.

**`normalizedSectionObject`** — [NormalizedAction.lean:23](Concentricity/NormalizedAction.lean:23)
```lean
def normalizedSectionObject (A : ASection) :
    NormalizedSlicePoint → NormalizedSlicePoint := fun X =>
  ⟨X.1, ⟨A.realize X.2.val, A.realize_mem_sliceSphere X.1.prop X.2.prop⟩⟩
```
The A-dependent object action on pointed slice states, world-preserving.
**Correct reusable construction.**

**`compactifiedSphereMap`** — [Recovery.lean:306](Concentricity/Recovery.lean:306)
```lean
def compactifiedSphereMap (A : ASection) (I : SphereWorld) :
    ↥(Octonion.sliceSphere I.val) → ↥(Octonion.sliceSphere I.val) :=
  fun q => ⟨A.realize q.val, A.realize_mem_sliceSphere I.prop q.prop⟩
```
The same section action per sphere; its own docstring: "deliberately not an invented
endofunctor of `SphereWorld`". **Correct reusable construction.**

**`GpvTransport.id`** — Recovery.lean:144
```lean
noncomputable def GpvTransport.id (A : ASection) (σ : OnePoint ℝ)
    (hσ : A.NonSingular σ) : GpvTransport A σ σ 0
```
Constant domain/value paths, constant log lift, winding 0.
**Correct reusable construction** — endpoints `OnePoint ℝ` are *literally*
`GreatCircle.Point` (an `abbrev`); no retyping exists to do.

**`GpvTransport.inv`** — Recovery.lean:170
```lean
noncomputable def GpvTransport.inv {A} {σ σ'} {k}
    (h : GpvTransport A σ σ' k) : GpvTransport A σ' σ (-k)
```
Path reversal, winding negated. **Correct reusable construction.**

**`GpvTransport.comp`** — Recovery.lean:201
```lean
noncomputable def GpvTransport.comp {A} {σ σ' σ''} {k k'}
    (h : GpvTransport A σ σ' k) (h' : GpvTransport A σ' σ'' k') :
    GpvTransport A σ σ'' (k + k')
```
Concatenation of domain and lift, the second lift deck-shifted to the first's endpoint,
windings adding. **Correct reusable construction.**

**`cayleyProjective`** — [CayleyDictionary.lean:94](Concentricity/CayleyDictionary.lean:94)
```lean
def cayleyProjective : GreatCircle.Aut →* Moebius :=
  Matrix.ProjGenLinGroup.lift cayleyConjMoebiusGL cayleyConjMoebiusGL_scalar
```
The locked projective group as Möbius transformations, a monoid hom, equivariant on
the base (`cayleyCoord_equivariant`, :118). **Correct reusable construction — already
on the locked endpoint.**

**`distinguishedMoebius_mul`** — CayleyDictionary.lean:353
```lean
theorem distinguishedMoebius_mul (c₁ c₂ : Circle) (w₁ w₂ : Complex.UnitDisc) :
    distinguishedMoebius c₂ w₂ * distinguishedMoebius c₁ w₁ =
      distinguishedMoebius (distinguishedCompPhase c₁ c₂ w₁ w₂)
        (distinguishedCompW c₁ w₁ w₂)
```
The distinguished family's closed composition law (the cocycle).
**Correct reusable construction.**

## 2. Exact endpoint mismatch

| Piece | Its literal endpoints | Required endpoints | The mismatch — nothing else |
|---|---|---|---|
| old `sectionFunctor` | `H1 = ActionCategory G2 (OnePoint Octonion)` ⥤ `S2` (point-level quotient) | `GreatCircle.Base` ⥤ `Grpd` | domain is the G₂ translation groupoid on points of 𝕆*, not the projective groupoid on the circle; codomain is a single point-level category, not `Grpd` with the retained `SphereWorld` |
| old `functorA` | `A.Base = {σ // NonSingular σ}` ⥤ `Grpd` | `GreatCircle.Base` ⥤ `Grpd` | domain is the nonsingular-restricted winding base (arrows = ℤ), not the full projective action groupoid; its `map` routes through the artificial `poleGen ^ k` instead of the arrow's own group element |
| locked `GreatCircle.Base` | `ActionCategory PGL(2,ℝ) (OnePoint ℝ)` — built, kernel-checked | (is the required domain) | none; its arrows already carry `f.val` and `f.property` |
| retained `SphereWorld` | a `Groupoid` — built, kernel-checked | must appear as `Grpd.of SphereWorld` | none; `functorA.obj` already elaborated exactly this |
| A-dependent GPV/value transport | `GpvTransport A σ σ' k`, `σ σ' : OnePoint ℝ` | endpoints on `GreatCircle.Point` | carrier: **none** — `GreatCircle.Point := OnePoint ℝ` is an `abbrev`. **But (audit correction, accepted):** sharing the carrier removes a retyping problem only; it does NOT produce a transport from a projective arrow. `f.property` is the bare action equation `f.val • b = b'` — no domain path, no value path, no lift, no winding. The arrow→transport link is a genuinely missing bridge (Pin 2, missing link ii) |

**The base naming collision (Codex's bookkeeping request).** Two Lean constants
coexist:

- `ASection.Base (A : ASection) : Type := { σ : OnePoint ℝ // A.NonSingular σ }`
  (ConnectedBase.lean:83) — section-dependent, nonsingular-restricted, arrows =
  ℤ-windings through `Realizes`; the OLD winding base; the domain of the superseded
  `functorA`.
- `GreatCircle.Base := CategoryTheory.ActionCategory GreatCircle.Aut GreatCircle.Point`
  (ProjectiveBase.lean:58) — the base whose Lean block PROOF_OUTLINE_LOCKED §2 prints
  verbatim as the locked 𝓑.

The record of record is unambiguous: 𝓑 = `GreatCircle.Base`; `A.Base` sits on the
quarantine list with `functorA`. Any prose occurrence of "`A.Base ⥤ Grpd`" as the
target should be read as `GreatCircle.Base ⥤ Grpd` unless the author rules otherwise —
mathematically both phrases have always meant *his* 𝓑; the collision is naming only,
and it plausibly accounts for part of the recurring register confusion (Codex's
surmise — agreed).

## 3. The three exact pins (replacing the withdrawn assembly)

The first version's `sectionFunctorB` is withdrawn (see the revision record). What
follows are the three pins Codex's audit requires, each as exact Lean terms or an
exactly named absence. No new object is proposed; the one design decision surfaced is
marked as the author's ruling.

### Pin 1 — the populated normalized value state (exact existing terms)

For a C-residue zero index `n` and world `I : SphereWorld`:

**The populated state:**
```lean
A.normalizedZeroSlicePoint n I : ASection.NormalizedSlicePoint
-- NormalizedAction.lean:28
-- = ⟨I, ⟨A.normalizedZeroPoint n I, A.normalizedZeroPoint_mem_sliceSphere n I⟩⟩
-- point = the compactified zero-sphere point sliceEmbed I (A.sphereZero n)
```

**Its normalized A-value — an exact term with a proved value:**
```lean
A.normalizedSectionPoint n I : OnePoint Octonion
-- NormalizedBase.lean:98  := A.realize (A.normalizedZeroPoint n I)
-- stays on the same sphere: normalizedSectionPoint_mem_sliceSphere (NormalizedBase:101)
```
whose value is the **one value-origin**:
```lean
A.realize_sphereZero_pt n I.prop :
  A.realize ((Octonion.sliceEmbed I.val (A.sphereZero n) : Octonion) : OnePoint Octonion)
    = ((0 : Octonion) : OnePoint Octonion)
-- PhiConversion.lean:467 (PROVED, from C3's divisor: stem_zero_of_sphereZero)
```
State-level form: `A.normalizedSectionObject (A.normalizedZeroSlicePoint n I)`, value
pin `normalizedSectionObject_zero_value` (NormalizedAction:71, `rfl`).

Register split of the glue rows (per the header's register test — the author's
caution: Φ is not his A-section): the FREE-SUPPLY fact is `realize_sphereZero_pt`
(PhiConversion:467 — every point of every residue-ℂ zero sphere realizes to the one
value-origin 0; type mentions only `A.realize`/`sliceEmbed`). The wrappers
`phi_sphere_obj` (:478), `phi_glue` (:488), `phi_class_eq` (:498) state the same
content THROUGH Φ's old endpoints — REGISTER-BOUND, quarantined as wrappers; on the
locked objects the glue is re-stated directly from the free fact ("the glue", the
author, 2026-07-06, survives as the realize-level statement).

**Its base position:**
```lean
(((A.sphereZero n).re : ℝ) : GreatCircle.Point)
-- with: Octonion.re (A.normalizedZeroLift n I) = (A.sphereZero n).re
--   (normalizedZeroLift_re, NormalizedBase:92)
-- world-independent: normalizedZero_label_world_independent (NormalizedBase:59)
```
Flag: the on-disk footpoint field (`NormalizedZeroObject.footpoint`,
`normalizedFootpoint`, NormalizedBase:22) is `BaseC`-typed — quarantined carrier; the
GreatCircle-typed address is the coercion above (mechanical).

**Typing consequence (stated, not designed):** these terms live in
`NormalizedSlicePoint` / `OnePoint Octonion`. `SphereWorld`'s objects are bare
directions and cannot hold them (the audit's point 4, accepted). Whatever `A.obj` the
author ratifies must have objects able to carry a pointed/valued state. That
fibre-type ruling is the author's (R6), with both prior artifacts and this audit in
view; this document deliberately makes no third proposal.

### Pin 2 — the distinguished-arrow chain (two certified legs, two named absences)

For `f : (b : GreatCircle.Base) ⟶ b'` — where `f.property` is ONLY the action
equation `f.val • b = b'` (audit point 3, accepted):

**Leg A (exists):** `f.val ↦` Möbius on the locked base:
`cayleyProjective f.val : Moebius` (CayleyDictionary:94), base-equivariant through
`cayleyCoord_equivariant` (:118).

**Missing link (i) — the (w, θ) normal form:**
```lean
theorem cayleyProjective_distinguished :
  -- for f.val in the identity component (signDet = 1):
  -- ∃ (θ : Circle) (w : Complex.UnitDisc),
  --   cayleyProjective f.val = distinguishedMoebius θ w
```
Named missing in DIRECT_A_FUNCTOR_FORMULAS §5; still missing; computable from
`distinguishedGL` per generator. Everything downstream of the normal form IS
certified: `distinguishedMoebius_mul` (:353 — the cocycle `distinguishedCompW`/
`distinguishedCompPhase`), `distinguished_phase_is_band` (:231 — the θ-leg is the
band), `exp_phase_eq_sliceEmbed` (:383 — the band phase is the slice exponential,
simultaneously in every world).

**Missing link (ii) — the arrow-to-channel map:**
```lean
def channelOf (f : (b : GreatCircle.Base) ⟶ (b' : GreatCircle.Base)) :
    C(unitInterval, OnePoint ℂ)
-- with channelOf f 0 = circleEmbed b  and  channelOf f 1 = circleEmbed b'
```
No such term exists (verified: the on-disk paths are segments, loops, and cone
approaches — `real_segment_tape_sweeps`, `circleLoop`, the cone trio — none indexed by
a projective arrow). This is the bridge that manufactures a transport from a
projective arrow; carrier-sharing alone does not.

**Leg B (exists):** channel ↦ GPV value transport, exposing the lift, winding, and
real-level tape: `gpvBase_transport` (FaithfulApply:122) / `gpvBase_transport_star`
(ConnectedBase:44) — for any domain path whose value path is finite and nonvanishing:
`exp Γ = γ`, the tape `(Γ t).re = Real.log ‖γ t‖` continuous, lift unique through its
basepoint (`winding_lift_unique`, Toolkit:301); the record `GpvTransport` with
`.id`/`.inv`/`.comp` (Recovery:144/:170/:201); routing where the channel meets
degenerate stretches or the cone (`great_circle_lift_through_degenerate`
FaithfulApply:198, `great_circle_passage_total` :274, `pole_cone_eps_delta`
LoopAssembly:207). Channel-choice independence: the Law-3 cluster
(`stemWinding_eq_of_homotopy` WeldW12:358, `winding_loop_closed` LoopAssembly:92) with
W1/W2's resting loops (Recovery:50/:99).

So Pin 2 reads, with absences displayed in place:
`f.val` → `cayleyProjective` (✓) → **[`cayleyProjective_distinguished` — MISSING]** →
distinguished `(w, θ)` with certified cocycle/band/exponential (✓) →
**[`channelOf` — MISSING]** → `gpvBase_transport` with lift, winding, tape (✓).

### Pin 3 — the action square (the one genuinely new proof obligation)

This square cannot be exhibited from existing terms: its categorical side (`A.map`)
does not yet exist, and the audit's finding is accepted — citing functions in prose
does not attach them. Once the author ratifies `A.obj`'s type (Pin 1's consequence)
and Pin 2's two links are built, the square to prove is:

- **object face:** for the Pin-1 populated state at `b`, the state reached by
  `A.map f` equals the state whose point is the distinguished sweep of the original
  point along `channelOf f`, with the section value re-read there
  (`normalizedSectionObject`), and whose address is `b'` (`f.property` through
  `cayleyCoord_equivariant`);
- **morphism face:** for a fibre morphism, the transported leg agrees with the
  distinguished conjugation (the Law-9 shape), the value cargo transported by Leg B
  and unique by `winding_lift_unique`.

Cells already certified: the landing law (`cayleyCoord_equivariant`), the cocycle
(`distinguishedMoebius_mul`), G₂-equivariance (`realize_equivariant` Slice:436,
`G2.smul_sliceEmbed` Slice:312), the tape and uniqueness (Leg B). The square itself —
**the typed equality between the distinguished A-dependent sweep and the categorical
action** — is the bridge, exactly as the audit states. `worldMob` remains available
only as a possible helper inside the morphism face; it is not the bridge.

## 4. Minimal board-lecture analytic spine

**The four hypotheses (what each contributes to the maps):**

- **C1** — the section is total through the two distinguished points: the pole's value
  is the point N (`realize_pole` PhiConversion:514; `valueAtInfinity`(+`_real`),
  `Fstar_infty`), and the pole's loop winds **exactly −1**
  (`stemWinding_circle_pole` SigmaE3:895, from `c1_simple`) — the annihilating datum
  the closures consume.
- **C2** — the Euler exponential channel, zero-free right of the wall
  (`c2_euler`, `zero_free_on_halfSpace` ASection:207) — where transports rest
  (`GpvTransport.id`) and W1's loops wind zero.
- **C3** — the enumerated divisor and its factorization (`sphereZero`,
  `c3_factorization`; honesty both ways: `stem_zero_of_sphereZero`/`sphereZero_complete`,
  StemFactorization), with degenerate encounters arbitrarily near every zero
  (`neg_reals_swept_near_sphereZero`) and summability through N (`c3_atN`,
  `normalizedZero_collapse_at_N` NormalizedBase:157).
- **C4** — the population is infinite (`c4_infinite` ASection:189): the C-residue
  states whose class the readout computes.

**The six headline facts (the smallest subset carrying
"genuine maps of A ⟹ one generated real-value C-residue class"):**

| # | Fact | Role in the implication |
|---|---|---|
| 1 | `winding_lift_unique` (Toolkit:301) | the transport along any channel is canonical — unique lift through its basepoint; the maps of A are well-defined and presentation-free, and the level tape rides each certificate |
| 2 | `stem_identity_logDeriv` (StemFactorization:437) | C2's and C3's presentations build the SAME transports where they meet — one functor, not two channels |
| 3 | `realize_equivariant` (Slice:436) | the section respects every G₂ direction leg — all worlds' copies of one zero state are joined vertically (blindness to direction, `lem:residue-spheres` register) |
| 4 | `Octonion.exp_fibre_concentric` (WeldW3:377) | any two points of one degenerate fibre share their real part — each identified class element carries exactly ONE real level (the seed concentricity) |
| 5 | `zero_encounters_joined_concentric` (FaithfulApply:328) | any two enumerated zeros' encounters share one value −r and are joined inside ONE fibre with the level CONSTANT along the join — the zero–zero edges of the generated zigzag, real value riding |
| 6 | `normalizedZero_pole_power_closes` (NormalizedPoleBridge:48) | **the multiplicity-general zero–N edge** (audit correction, accepted): for EVERY enumerated zero, the composite of its C3 zero loop with C1's pole loop raised to the divisor multiplicity winds 0 and admits a CLOSED lift — every populated state reaches the shared witness, at every multiplicity |

Chain: C3/C4 populate the states → facts 3, 5, 6 are the generated edges among them →
facts 1, 4 (with the tape) make every edge conserve the one real level → the generated
class is a real-value class.

**What the winding facts accomplish (Codex's division of labor, ratified by the
author — each certified fact has one exact job):**

| Certified fact | Exact job |
|---|---|
| `stemWinding_circle_pole = -1` (SigmaE3:895) | C1 identifies the pole contribution |
| `stemWinding_circle_sphereZero = multiplicity` (SigmaE3:348) | C3 identifies each zero contribution |
| `normalizedZero_pole_power_closes` (NormalizedPoleBridge:48) | zero winding m plus m pole turns of winding −1 gives total winding 0, hence a closed lift |
| `stemWinding_eq_zero_iff` (SigmaE3:119) | converts winding cancellation into existence of a closed logarithmic lift |
| `winding_lift_unique` (Toolkit:301) | makes choices of lift/presentation irrelevant once the starting point is fixed — **the key well-definedness tool** |
| `GpvTransport.comp` / `.id` / `.inv` (Recovery:201/:144/:170) | supplies exactly the transport algebra needed for identity, composition, and inversion |
| `winding_loop_defect_level_zero` (LoopAssembly:107) | even when winding is nonzero, the defect is purely imaginary, so the real level closes |
| `realizes_gpv_lift` (Recovery:319) | extracts the intrinsic tape `(Γ t).re = Real.log ‖γ t‖` from every realized transport |

The especially important observation (the defect is a height, never a level —
`GpvTransport.winding` is literally `lift 1 - lift 0 = 2·π·I·k`):

\[
\Gamma(1)-\Gamma(0)=2\pi i k
\quad\Longrightarrow\quad
\operatorname{Re}\Gamma(1)=\operatorname{Re}\Gamma(0).
\]

**Supporting proof infrastructure (correct, load-bearing, not additional conceptual
steps):** `zero_pole_pair_closes_through_witness` (SynthesisE6:228 — fact 6's tally-one
special case, demoted per the audit); `shared_ladder_encounters` (LoopAssembly:271 —
the value-sharing clause inside fact 5); `pole_encounters_joined_concentric`
(FaithfulApply:354 — the pole-side fibre joins behind fact 6);
`two_center_winding_onto_one_band` (WeldW4:165) and `normalizedZero_pole_winding`
(NormalizedPoleBridge:18 — the winding arithmetic under fact 6);
`sweepE5_lift_level_tape`, `euler_branch_level` (the level rows under fact 1); the
crossing/flip suite (W3, under the reflection channel); the cone/junction rows (under
the N-approach).

## 5. Categorical closure and verdict

The final chain, entirely certified ([Theorem.lean](Concentricity/Theorem.lean)):

1. `pi0Cocone` (:52) — the canonical cocone of `(A ⋙ Grpd.forgetToCat) ⋙ pi0Functor`.
2. `toColimitObj_eq_of_hom` (:77) — each arrow of the Grothendieck construction forces
   equal images in the colimit.
3. `toColimitObj_eq_of_zigzag` (:92) — extended along `CategoryTheory.Zigzag`: a
   **finite zigzag** of arrows forces equal colimit images.
4. `pi0GrothendieckEquiv` (:108) — π₀(∫ A) ≃ colim(π₀ ∘ A), inverse by
   `colimit.desc` of `pi0Cocone`.
5. `pi0_grothendieck` (:144) — the packaged statement of master `lem:pi0-grothendieck`.

Literature meaning (SOURCES/Riehl.md, verified against `inbox/cathtpy.pdf`): proof of
Lemma 8.3.4, p. 102 — "π₀(el X) ≅ colim_C X because each arrow connecting two objects
in el X corresponds to a condition demanding that these elements are identified in any
cone under X" — and Remark 8.3.5, p. 102 — π₀ sends a category to its objects modulo
**finite zig-zags**; nonempty and connected exactly when π₀ is a singleton. Mathlib's
quotient mechanism: `Limits.Types.colimit_sound`/`colimit_sound'`/`colimit_eq`.

Applied: the genuine maps of A (once assembled per §3's pins) generate finite zigzags
among the populated C-residue value states (§4, facts 3/5/6); step 3 sends each zigzag
to an equality in colim(π₀ ∘ A); through step 4 the populated states' image in
π₀(𝒯_A) is one class; §4's facts 1/4 say that class is a real-value class. **This is
finite-zigzag connectedness of the populated C-residue value transports — derived from
the constructed arrows. It is not topological connectedness, not connectedness of the
base, not connectedness of the fibres, and it is scoped to the populated C-residue
states.** A final contamination audit (Codex landing plan, step 8) must confirm the
conclusion never routes through `sphereWorld_zigzag`, a constant fibre, generic base
connectedness, or a preinstalled real-value condition.

**THE TWO REMAINING FACTS — the scope gate (Codex, 2026-07-16, after retracting its
own pairwise indexed-coordinate slip; ratified as the post-freeze rule).** The exact
conclusion is the outline's own: *the populated C-residue values transported by the
genuine A form one colimit/component class, and that singleton is one real-value
singleton {c}; therefore the populated zero spheres are concentric.* No pairwise
`Re ρₙ = Re ρₘ` statement is ever proved before the colimit. After the genuine functor
is green, exactly two substantive facts remain:

1. **Transport-generated joining.** The populated zero total-objects are joined by
   finite composites/zigzags of the genuine maps of A, through the common witness N.
   N is not terminal, not a final object, and does not receive a finite label.
2. **Intrinsic real-level preservation.** Those exact transports carry one relevant
   real level — the class they generate is already a real-value class, never an
   abstract component later equipped with a projection.

Everything else is machinery already green: `toColimitObj_eq_of_zigzag` (the zigzags
become colimit identifications), `pi0GrothendieckEquiv` (the colimit is π₀(𝒯_A)), C4
(the population), the geometric dictionary (the singleton read as concentricity). The
analytic supply feeding the two facts is the §4 spine and jobs table
(`normalizedZero_pole_power_closes`; `GpvTransport.id`/`.comp`/`.inv`;
`winding_lift_unique`; `realizes_gpv_lift`; `winding_loop_defect_level_zero`;
`zero_encounters_joined_concentric`; `Octonion.exp_fibre_concentric`; the
world-independence/equivariance rows) — a handful of interface theorems consuming the
certified library, not another analytic campaign.

**THE SCOPE GATE (binding once the functor freezes):** every proposed next step must
type directly as Fact 1 or Fact 2 — or it is rejected as out of scope. No further
carrier inventory, no terminal object, no pairwise coordinate theorem, no replacement
functor, no new categorical architecture.

**THE LOCKED LANDING SEQUENCE (Codex's plan, carried here as the sequence of record):**

1. **Quarantine all superseded constructions** — `AFunctor.functorA`, its
   `TotalA`/`readout`, the older `H1 ⥤ S2`, `BaseC`, every value-free surrogate
   (done — the header list, policed by the register test).
2. **Locate the actual distinguished sweep** — record the precise Lean definitions for
   its base-object assignment; sphere-world/value-state assignment; base-arrow leg;
   simultaneous band/fibre leg; object-to-object and morphism-to-morphism formulas
   (Pins 1–2 are this step's current state: the terms that exist, the two named
   absences).
3. **Factor, don't reconstruct** — if the existing assignments already have the shape
   of `A.obj`/`A.map`, package them directly; no new carrier, representation, or
   family of groupoids.
4. **Discharge well-definedness from the existing mathematics** —
   Cayley/distinguished multiplication for representative composition
   (`distinguishedMoebius_mul`); GPV lift uniqueness for presentation independence
   (`winding_lift_unique`); Euler–Weierstrass agreement for the two analytic
   presentations (`stem_identity_logDeriv`); orbit–stabilizer ONLY for extending the
   distinguished fibre action across the base.
5. **Discharge the two functor laws** — `map_id`: distinguished identity +
   `GpvTransport.id` + uniqueness; `map_comp`: distinguished multiplication +
   `GpvTransport.comp` + uniqueness.
6. **State the analytic cargo as theorems about the genuine maps** — the real-level
   tape rides each transport; winding defects are purely imaginary; zero/pole
   multiplicities cancel through N; normalized real labels are world-independent; the
   degenerate exponential fibres are concentric. Consequences of C1–C4 and the
   winding/GPV library — never new functor hypotheses.
7. **Only then instantiate the categorical tail** — 𝒯_A → π₀(𝒯_A) ≅ colim(π₀ ∘ A) →
   the real-value singleton → concentricity.
8. **Run the final contamination audit** — the conclusion must not arise from
   `sphereWorld_zigzag`, a constant fibre, generic base connectedness, or a
   preinstalled real-value condition.

**Verdict (revised after the cross-audit; the first version's
`REPOINTING PLUS ONE BRIDGE (worldMob)` is withdrawn):**

```text
NOT REPOINTING ONLY — THE BRIDGE IS THE ACTION SQUARE
```

The exact missing Lean, in dependency order:

```lean
-- (i)  the (w, θ) normal form of a locked-base element (Pin 2, link i)
theorem cayleyProjective_distinguished : …

-- (ii) the arrow-to-channel map (Pin 2, link ii)
def channelOf (f : (b : GreatCircle.Base) ⟶ (b' : GreatCircle.Base)) :
    C(unitInterval, OnePoint ℂ)

-- (iii) THE BRIDGE: the typed equality between the distinguished A-dependent
--       sweep and the categorical object/morphism action of A.map — statable
--       only after the author rules A.obj's type (Pin 1, typing consequence)
```

Everything else in §§1–2 and §§4–5 is certified supply.
