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

# THE FREEZE TABLE — 𝒱 = A(N) and ρ : BH ⥤ Grpd

> **SUPERSEDED DRAFT (2026-07-16, the cross-audit ruling — Codex, ratified by the
> author): NOT frozen, NOT ready for Lean.** Retained for the record. Corrections of
> record: no κ and no common-c content in any carrier (the colimit performs the
> identification); `NormalizedSlicePoint` carries no real-datum field as-is; GPV cargo
> requires exact endpoint-compatibility and species treatment (loops prove relations,
> arrows are not loops; `GpvBase` excludes singular points and needs the north-pole
> retyping); ρ must be ONE exact definition (dictionary = coordinate engine, transports
> = analytic engine, joined by a theorem); generator correspondences remain named
> obligations; the `G ×_H 𝒱` line is REMOVED (total-object material, deferred).
> **The submission of record is FREEZE_SUBMISSION_V_RHO_v2_2026-07-16.md.**

**AUDIT REQUEST — check against ALIGNMENT points 20–23.**

**Prepared by:** Fable (kernel/greps, Desktop tree — canonical), 2026-07-16 — the
Phase-1 exit deliverable, produced AFTER the exhaustive relation search per the
directive's order. **Register (point 22, the bill of materials):** every line below is
typed and linked to kernel-printed supply (GREEN_LEDGER: 242 CERTIFIED, zero project
axioms). **Nothing here is implemented**; the author ratifies line by line, Codex
cross-audits, and only then Lean.

**THE D-CELLS ARE RESOLVED (the author's ruling, 2026-07-16):** the questions are
answered in the **BACKWARDS register** — each branch chosen so the proof goes through,
i.e., so that **real value transports are conserved structurally**: the conserved
datum is a field of the state, its conservation a constructor law of the arrow, and
ρ's action IS the value transport (with the dictionary as its coordinate expression).
No preservation statement is ever attached from outside. D1 = (b), D2 = (b),
D3 = (b)-with-(a)-as-chart, detailed in place below.

---

## §1 Frozen constants (no decision required — locked or pin-verified)

| Symbol | Lean carrier | Status |
|---|---|---|
| G | `GreatCircle.Aut = PGL(2, Real)` | locked (ProjectiveBase:33) |
| X | `GreatCircle.Point = OnePoint Real` | locked (:30) |
| 𝓑 | `GreatCircle.Base = ActionCategory Aut Point` + `groupoid` | locked (:58/:62) |
| N | `(OnePoint.infty : GreatCircle.Point)` | the distinguished object |
| H | `MulAction.stabilizer Aut N` (= End_𝓑(N) DEFINITIONALLY via pin `stabilizerIsoEnd = MulEquiv.refl`) | pin-verified |
| BH | `CategoryTheory.SingleObj H` | pin |
| u | `u = e^{Iθ} : Circle`; `exp (θ • I) = sliceEmbed I e^{iθ}` | `ASection.exp_phase_eq_sliceEmbed` (CayleyDictionary, CERTIFIED) |
| universes | everything at `Type 0`; fibres in `Grpd.{0,0}`; `pi0_grothendieck` instantiates directly | ACTION_TABLE §9 |
| dictionary | `GreatCircle.cayleyProjective : Aut →* Moebius` (+`_mul`, `_mk`); `cayleyCoord` + `cayleyCoord_equivariant`; `distinguishedMoebius (u)(w)` + composition law (`distinguishedCompW`/`distinguishedCompPhase`/`distinguishedMoebius_mul`) | CayleyDictionary, 19/19 CERTIFIED — on the critical path per the author's ruling |

---

## §2 𝒱 — the objects (freeze item 1)

**Minimal candidate carrier (on disk, certified):**

```lean
𝒱.Obj := ASection.NormalizedSlicePoint      -- NormalizedAction.lean:17
       = Σ I : SphereWorld, ↥(Octonion.sliceSphere I.val)
```

— a slice world I ∈ S⁶ together with a point of its compactified Riemann sphere: the
POINTED slice continuum. Certified facts making it the minimal genuine choice:

| Requirement | Supply (kernel-printed) |
|---|---|
| N present in every world | every `sliceSphere I.val` contains ℝ ∪ {∞} (Slice.lean:195) |
| C4 population | `normalizedZeroSlicePoint (n)(I)` places every zero in it (NormalizedAction:28); divisor honesty both ways (`stem_zero_of_sphereZero`/`sphereZero_complete`) |
| the section acts on it | `normalizedSectionObject` — world-preserving (NormalizedAction:23/:59); point-level: `compactifiedSphereMap` (Recovery:306) |
| the real datum is IN the state | the point's coordinate (`re_sliceEmbed`; for zero states the `label` pinned by `label_zero`, world-blind `rfl`) — NO external map, per κ = {c} |
| equivariance across the continuum | `normalizedZeroLift_equivariant`/`normalizedSectionPoint_equivariant`; `sliceCoord_smul_invariant` |
| collapse/arrival at N | `normalizedZero_collapse_at_N`; `level_circle_meets` |

**D1 — RESOLVED (b), the backwards register: the state carries the real datum as a
FIELD.** The colimit identifies the states themselves (PROOF_OUTLINE_LOCKED §10: "the
elements being transported and identified are already the normalized value states");
for the singleton to BE the real-value class (κ = {c}), the value content must sit in
the transported element structurally. The state record follows the
`NormalizedZeroObject` pattern extended to general states: world + point + the real
datum field, with the zero states' field pinned by `label_zero` and world-blind by
`rfl` (`normalizedZero_label_world_independent`, `normalizedZeroLift_re`). Branch (a)
(bare pointed continuum) is recorded as the underlying carrier the record projects to.

## §3 𝒱 — the morphisms (freeze items 2/4/5)

**Minimal candidate:** the action-groupoid shape over the pointed continuum — a
morphism `(I, q) ⟶ (J, q′)` is a `SphereHom I J` (rot g with `g • I.val = J.val`;
`mob : Moebius`) **together with the transport equation on the point**:

```lean
structure 𝒱.Hom (X Y : 𝒱.Obj) where
  leg : SphereHom X.1 Y.1                          -- SliceSphereWorld:200
  point_eq : transport leg X.2 = Y.2               -- the leg carries the point
```

where `transport leg` acts: `mob` in the source chart (through
`sliceCoord`/`sliceEmbed`), `rot` relabelling the world (`G2.smul_sliceEmbed` — the
chart identity, CERTIFIED). Groupoid laws componentwise, exactly the certified
SphereWorld pattern (`comp_rot`/`comp_mob`/`id_*`; inverses since G₂ and Moebius are
groups; pin `groupoidOfElements` as the model).

| Law | Supply |
|---|---|
| id / comp / inv | SphereHom instances (SliceSphereWorld:209–:248); `Moebius` group; transport-equation composition by `mul_smul`-style rewriting |
| vertical direction legs (fix footpoint AND label) | `dirHom`/`dirHomTo`; `G2.smul_ofReal`/`smul_onePoint_infty`; label constancy `rfl` |
| band legs fix 0 and N per world | `bandHomAt`/`bandEnd`; `bandMoebius_apply_zero`/`_infty` |
| fibre connectivity | `sphereWorld_zigzag`; through the degenerate fibre: `exp_fibre_sphere_connected`/`_conj_joined` |

**D2 — RESOLVED (b), the backwards register: the fibre morphism CARRIES the GPV
cargo.** "The real value rides the transports" is the content of the arrow itself
(outline §4); conservation of the conserved projection is a CONSTRUCTOR OBLIGATION of
the arrow, discharged at construction time by certified rows — never a theorem
attached to a geometry-only arrow afterward. The arrow record: the SphereHom leg +
transport equation (§3 above) PLUS the `GpvTransport`-style fields (value path, lift,
`lift_exp`, `winding` — Recovery:23, id/inv/comp already proved), following the
certified `GpvRealizes`/`instGroupoidGpvBase` pattern; the σ/σᶜ register thereby sits
inside every arrow — the level tape `(lift t).re = log ‖value t‖` with unconditional
loop closure (`winding_loop_defect_level_zero`) IS "the level is the flight's fixed
datum" as arrow structure. `GpvTransportWitness` (IntegrateTheorem:270) is the field
inventory of reference; endpoints retype per §6.1.

## §4 ρ : BH ⥤ Grpd — the stabilizer action (freeze items 3/6)

H = the affine class fixing 𝔫; generators = translations, dilations, the reflection
(components detected by pin `signDet`). **The composition law of the author's
distinguished family is already kernel-checked** (`distinguishedMoebius_mul`: new
orbit coordinate w₃ + residual phase u₃) — the cocycle that drives the extension.

**Minimal candidate (laws come FREE):** ρ acts through the dictionary —

```lean
ρ₀ : H →* Moebius := (GreatCircle.cayleyProjective).comp H.subtype
ρ (h) : 𝒱 ⥤ 𝒱 :=  -- on objects: (I, q) ↦ (I, ρ₀(h) · q)  (the mob leg in EVERY world)
                   -- on morphisms: conjugation of the mob component; rot unchanged
```

- `ρ(1) = id` and `ρ(h₂h₁) = ρ(h₂) ∘ ρ(h₁)`: **free from `cayleyProjective_mul`**
  (a MonoidHom composite) — the Law-1/Law-2 packaging lemmas reduce to `map_one`/
  `map_mul`. Mechanical check recorded: the pin's `comp_val : (f ≫ g).val = g.val *
  f.val` order.
- Well-definedness on morphisms (the Law-9 instance): ρ(h) must intertwine the legs —
  with dirHom legs via the chart identity `G2.smul_sliceEmbed`; with mob legs via
  Moebius multiplication; **the one derived-lemma set of the freeze** (named,
  bounded): the conjugation relation ρ₀(h)·mob·ρ₀(h)⁻¹ where legs don't commute —
  inputs enumerated in PHASE1_RHO_LAWS Law 9.

**The analytic content (why this ρ is not a shell):** the generator classes land on
the certified channels — translations ↔ the tape (`gpvBase_transport`, the sweep
rows), dilations ↔ the cone/junction (`pole_cone_*`, `cone_junction_levels_shared`,
the pole bridge closures), reflection ↔ the crossing/flip register (with
`conjLoop`/`CrossingData.ofConj` as the conjugation apparatus) — and the residual
phase u₃ of the composition law IS the band (`distinguished_phase_is_band`,
`exp_phase_eq_sliceEmbed`), touching the degenerate fibre at odd π
(`exp_kernel_unit_imaginary`). The value-register bookkeeping (what each channel does
to the conserved datum) is certified per channel and rides the readout, per the
sufficiency ruling: not every supplied row is consumed by ρ's definition.

**D3 — RESOLVED (b) with (a) as its coordinate chart, the backwards register: ρ IS
the value transport.** ρ(h) carries states along the section's value path over h's
base motion — the transports the colimit identifies are VALUE transports, so the
functor cannot be a geometry shell. The functor laws close by the Law-3 engine, not by
`map_mul`: two transports along the same channel with equal start are EQUAL
(`winding_lift_unique`; representative independence via `stemWinding_eq_of_homotopy`;
closure via `winding_loop_closed`) — so ρ(1) = id and ρ(h₂h₁) = ρ(h₂)∘ρ(h₁) are short
uniqueness arguments, exactly as predicted. The dictionary action (branch (a)) is the
CERTIFIED COORDINATE EXPRESSION of the same motion — the w-leg the canonical
transporter, the residual u₃ the band (`distinguishedMoebius_mul`,
`distinguished_phase_is_band`, `exp_phase_eq_sliceEmbed`) — supplying the cocycle
coherence; the two registers meet in the μ(t) triangle (point 12), whose derivation is
part of the Law-9 set. Per-channel value bookkeeping: translations ↔ tape, dilations ↔
cone/junction, reflection ↔ crossing/flip — each conserved-datum law certified.

## §5 The five exit deliverables — expected type shells

| Deliverable | Expected shell | Laws source |
|---|---|---|
| `V : Grpd` | `Grpd.of 𝒱.Obj` with the §3 groupoid | SphereWorld pattern |
| `ρ : SingleObj H ⥤ Grpd` (equivalently `H →* Aut_Grpd(V)`) | object ↦ V; `h` ↦ the §4 value-transport functor | Law-3 uniqueness (`winding_lift_unique` + homotopy rows); cocycle coherence from `distinguishedMoebius_mul` |
| extension data | transporters via `homOfPair`/`ActionCategory.cases` (pin); canonical s_x from the distinguished family (w-leg) | `distinguishedCompW` |
| `A.obj b` (Phase-2 target) | `G ×_H 𝒱` fibre at b — NOT constructed now | — |
| `A.map` laws (Phase-2 target) | cocycle identity h(g₂g₁) = h(g₂)h(g₁) — automatic | pin `comp_val` order |

**Expected `#print axioms` for every consumed row: `[propext, Classical.choice,
Quot.sound]`** — all supply is already printed; the only new obligations are the
D-cells' packaging lemmas and the Law-9 derived set.

## §6 Order of work after ratification

1. The two retyping obligations (Recovery endpoints; NormalizedBase carrier →
   `GreatCircle.Point`) — mechanical, cargo untouched.
2. The pretransitivity one-liner (`[[x,1],[1,0]] • ∞ = x` via `smul_infty_eq_ite`).
3. Wire `CayleyDictionary` (+`ProjectiveBase`) into the imports the construction uses.
4. Implement 𝒱 (per D1/D2), then ρ (per D3) with the Law-9 derived set; `lake build`;
   axiom audit; ledger; commit the functor-phase Step 2 alone.

## §7 NOT in this freeze (the guardrails, restated)

No total object, no colimit invocation, no statement carrier, no `realValue` map on
any carrier, no base-connectedness use, no ζ-layer consumption, no old-chain
dependency (SUPERSEDED-FORBIDDEN list stands), no deletion or root-import change
beyond §6.3's additive wiring. κ = {c} discipline: the value content lives in the
states and arrows; the carrier of the theorem's singleton freezes with A.obj, later.
