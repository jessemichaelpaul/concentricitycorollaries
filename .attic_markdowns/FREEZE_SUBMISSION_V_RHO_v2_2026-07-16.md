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

# FREEZE SUBMISSION v2 — four literal type signatures, provenance, obligations

**AUDIT REQUEST — check against ALIGNMENT points 20–23 and the proof-order audit.**

**Prepared by:** Fable, 2026-07-16, revising the superseded draft per the cross-audit
ruling (Codex; ratified by the author). **Small by instruction:** the four proposed
types with every field displayed, a field-by-field provenance table (proof-order
classes 1–4; class 4 banned), and the remaining obligations. **No implementation.**
No κ, no c, no `A.obj`, no associated bundle, no total object, no colimit anywhere
below. States carry a VARYING intrinsic datum; arrows certify per-arrow equalities;
the colimit — later — performs the identifications.

---

## 1. `VObj` — the proposed state record

```lean
/-- PROPOSED (not implemented): a normalized value state of the distinguished fibre. -/
structure VObj (A : ASection) : Type where
  world      : SphereWorld
  point      : ↥(Octonion.sliceSphere world.val)
  level      : OnePoint ℝ
  level_spec : level = OnePoint.map Octonion.re point.val
```

- `level` is the intrinsic real/level datum, **compactified**: finite points x get
  `some (re x)`; the north-pole state gets `∞` honestly — no junk value, no generic
  projection pretending finiteness at N (the O1 species question is thereby EXACT:
  see obligations). Zero states: `level = some ((A.sphereZero n).re)` via
  `normalizedZeroLift_re` (NormalizedBase:92). **`level` varies by state. No field
  relates it to any common value.**
- `level_spec` makes the datum determined-by-point (structural per the backwards
  ruling, zero freedom, zero content beyond the record's own coherence).

| Field | Proof-order class | Supply |
|---|---|---|
| `world` | 2 (categorical structure) | `SphereWorld` (SliceSphereWorld:194, CERTIFIED instances) |
| `point` | 2 | `sliceSphere` (Slice:195); population constructor `normalizedZeroSlicePoint` (NormalizedAction:28) — C4 enters here (class 1) |
| `level` | 1 (analytic input: the state's real datum) | `Octonion.re`; `normalizedZeroLift_re`; the compactified register = the level circle (`level_circle_meets`, LogManifold:1098) |
| `level_spec` | 3 (well-definition) | `OnePoint.map` (pin) |

**No class-4 field.**

## 2. `VHom` — the proposed arrow record

```lean
/-- PROPOSED (not implemented): an enriched fibre arrow. -/
structure VHom (A : ASection) (X Y : VObj A) : Type where
  leg       : SphereHom X.world Y.world
  point_eq  : spherePointMap leg X.point = Y.point        -- O4: spherePointMap
  level_eq  : X.level = Y.level                           -- constructor property
  value     : C(unitInterval, ℂ)
  lift      : C(unitInterval, ℂ)
  lift_exp  : ∀ t, Complex.exp (lift t) = value t
  ends      : VEndCompat A X Y value                      -- O2: endpoint compatibility
```

- `level_eq` is **per-arrow conservation as a constructor obligation** — discharged at
  each construction site from certified rows (vertical legs: `rfl`-grade,
  `G2.smul_ofReal`/`normalizedZero_label_world_independent`; transport-built arrows:
  the tape rows `lift_level_tape`/`lift_level_unique`, loop closure
  `winding_loop_defect_level_zero` where the site is a loop). It is NOT a global
  hypothesis; it is NOT `level = c`.
- `value`/`lift`/`lift_exp` are the GPV commuting-triangle cargo (the `GpvTransport`
  field pattern, Recovery:23). **Species note (per the ruling):** nonvanishing
  (`∀ t, value t ≠ 0`) and the winding field attach on the NONSINGULAR species; arrows
  whose endpoints are zero/pole states carry the closure-form cargo instead
  (multiplicity-power register: `normalizedZero_pole_power_closes`,
  `zero_pole_pair_closes_through_witness`) — the O3 species table decides field-by-field.
- Loop theorems are used ONLY to prove relations and presentation independence
  (Law 3); no general arrow is treated as a loop.

| Field | Class | Supply |
|---|---|---|
| `leg` | 2 | `SphereHom` (:200) with certified groupoid laws |
| `point_eq` | 3 | O4's `spherePointMap` (mob in the source chart via `sliceCoord`/`sliceEmbed`; rot relabelling via `G2.smul_sliceEmbed`) |
| `level_eq` | 3 | per-site discharge rows above |
| `value`, `lift`, `lift_exp` | 1 | the GPV triangle (`GpvTransport.lift_exp` pattern, CERTIFIED); `gpvBase_transport` (FaithfulApply:122) supplies them along any admissible channel |
| `ends` | 3 | O2 |

**No class-4 field.**

## 3–4. `ρ` — ONE definition (value transport), with the dictionary joined by theorem

```lean
/-- PROPOSED (not implemented): the stabilizer action on objects. -/
def rhoObj (A : ASection) (h : ↥H) : VObj A → VObj A
-- X ↦ the state reached by transporting X along h's channel:
--   world unchanged; point moved by the transported value data; level by O5's law.

/-- PROPOSED (not implemented): the stabilizer action on arrows. -/
def rhoMap (A : ASection) (h : ↥H) {X Y : VObj A} :
    VHom A X Y → VHom A (rhoObj A h X) (rhoObj A h Y)
-- leg: rot unchanged, mob conjugated (the Law-9 set);
-- cargo: value/lift transported along h's channel (gpvBase_transport);
-- level_eq: from the transported tape (O5).
```

**The unification requirement, honored as stated:** ρ is DEFINED by the value
transport (the analytic engine); the dictionary is its coordinate engine through the
mandatory agreement theorem —

- **O5 (the join):** the underlying geometric motion of `rhoObj A h` equals the chart
  action of `ρ₀ h := GreatCircle.cayleyProjective h.val` — a THEOREM connecting the
  two typed views, never commentary. Inputs: `cayleyCoord_equivariant`,
  `distinguishedMoebius_apply/_mul`, `distinguished_phase_is_band`,
  `exp_phase_eq_sliceEmbed`, the μ(t) triangle (point 12).
- **Functor laws, by component:** geometric component by Möbius multiplication
  (`cayleyProjective_mul`; pin `comp_val` order recorded); analytic component by
  uniqueness and winding relations (`winding_lift_unique`,
  `stemWinding_eq_of_homotopy`, `winding_loop_closed`, `GpvTransport.comp`'s
  winding arithmetic).

| Component | Class | Supply |
|---|---|---|
| `rhoObj` value motion | 1 | `gpvBase_transport`; channel rows per generator (O6) |
| `rhoObj` level law | 3 | O5 + the tape rows |
| `rhoMap` leg conjugation | 3 | Law-9 set (O7); model `G2.smul_sliceEmbed` |
| `rhoMap` cargo transport | 1/3 | `gpvBase_transport` + Law-3 uniqueness |
| laws ρ(1)=1, ρ(h₂h₁)=ρ(h₂)ρ(h₁) | 3 | the two-component sources above |

**No class-4 component.** BH = `SingleObj ↥H` enters only as the packaging of these
laws; π₀, the Grothendieck construction, colimits, corollaries: **absent by design.**

## 5. Remaining obligations (named; each with its supply pointer)

| # | Obligation | Supply / note |
|---|---|---|
| O1 | the north-pole state species: is `(world, ∞, ∞)` the whole N-state, or does it carry the compactified value datum? | `valueAtInfinity`(+`_real`), `Fstar_infty`, `realize_infty`, `realize_pole`; the three-register N discipline — **the author's call on the exact record** |
| O2 | `VEndCompat`: the exact endpoint map state ↦ value coordinate (X, σ, value 0, lift 0 compatibility) | `Fstar`/`circleEmbed` content (retyped per O8); `cayleyCoord` |
| O3 | the arrow species table: nonsingular (nonvanishing + winding fields) vs zero/pole endpoints (closure-form cargo) | the three-case identity decomposition; power-closure rows |
| O4 | `spherePointMap` (the leg's point action) | `sliceCoord`/`sliceEmbed` laws; `G2.smul_sliceEmbed`; `Moebius.of_apply` |
| O5 | the dictionary ⟷ transport agreement theorem (the join) | listed above |
| O6 | the three generator normal-form maps (translations↔tape, dilations↔cone/junction, reflection↔crossing/flip) — REMAIN OBLIGATIONS until the typed maps are written | the channel row clusters |
| O7 | the Law-9 conjugation set | PHASE1_RHO_LAWS Law 9 inputs |
| O8 | the two retypings (Recovery endpoints; NormalizedBase carrier) | mechanical; cargo untouched |
| O9 | pretransitivity one-liner | `smul_infty_eq_ite` witness |

## 6. Compliance echo (the ruling's distinctions, one line each)

Intrinsic `level` field: present; `level = c`: **absent**. Arrow conservation: per-arrow
constructor property; global `realValue_preserved`: **absent**. Loop closure: relations
and presentation independence only. N: exact species (O1), no generic projection.
Dictionary and transports: two typed views joined by O5. κ: **absent** (π₀(𝒯_A) does
not exist at this phase). `A.obj`/associated bundle/total object/colimit: **absent**.
