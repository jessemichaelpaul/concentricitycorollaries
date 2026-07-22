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

# INVENTORY — THE FUNCTOR FORCING RECONSTRUCTION

**AUDIT REQUEST — check against ALIGNMENT points 20–23.**

**Prepared by:** Fable (kernel/greps, Desktop tree — canonical), 2026-07-15.
**Instruction of record (the author + Codex, 2026-07-15):** "Fable's inventory should now
do exactly one thing: reconstruct how the certified analytic declarations force `A.obj`,
`A.map`, and their laws, including how the real value is present in the transported
colimit elements themselves."
**Register:** dependency reconstruction, not an options exercise. Every row cites a
declaration verified on disk this session; tier language cites GREEN_LEDGER.md rows only.
DESIGN-INPUT cells are named questions for the author — nothing here decides them.

---

## §0 State at assembly

- Both trees byte-identical (full recursive diff; sole stray = the superseded
  `HANDOFF_CODEX_2026-07-11.md`, Codex tree only). Same `lean-toolchain`, same manifest.
- `lake env lean _ledger_audit.lean` rerun this session: 36 prints = 30 clean + 6
  `sorryAx`, matching GREEN_LEDGER exactly; zero project axioms.
- Sorry census (verified at token level + block-comment check): **4 live sorried
  declarations on disk, 3 in the root import closure** — ConcentricityReadout.lean:208
  (`totalA_pi0_singleton`), :262 (`zero_levels_common`), WeldW3.lean:668
  (`concentricity_via_weldW3`, dead-route receipt, consumed by nothing), plus the orphan
  KeystoneFinality.lean:122 (dropped finality route; no file imports it).
  FlipWeld.lean:1235 is inside the block comment opened at :1110 — NOT live.
  WeldW4.lean has NO live sorry (its §C receipt is docstring-only; never formalized).
  None artificial. The two ConcentricityReadout sorries are the OLD chain's two steps,
  replaced (never patched) by the locked outline.

---

## §1 The backwards column — what the certified engine demands of A

From Theorem.lean (all CERTIFIED, ledger rows):

- `pi0_grothendieck {B : Type u} [SmallCategory B] (F : B ⥤ Grpd.{u, u}) :
  Nonempty (ConnectedComponents (Grothendieck (F ⋙ Grpd.forgetToCat))
  ≃ Limits.colimit ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor))` — :144.
- `pi0GrothendieckEquiv` — :108; forward leg `Quotient.lift (toColimitObj F)` over
  `toColimitObj_eq_of_zigzag` (:92); inverse `colimit.desc` of `pi0Cocone`.
- `toColimitObj` (:68): a total object ↦ the colimit class of its fibre component.
- `toColimitObj_eq_of_hom` (:77): ONE total morphism collapses the comparison — the
  base leg absorbed by `colimit.w`, the fibre leg by the fibre's own π₀.

The generic tail (kernel-checked standalone by BOTH assistants 2026-07-14; ledger rows
`Pi0SingletonStatement` / `pi0Singleton_of_isConnected`): `Nonempty` + `∀ x y, Zigzag x y`
→ `IsConnected` (`zigzag_isConnected`) → π₀ singleton.

**Therefore the engine demands of A exactly five things:**

1. `GreatCircle.Base : SmallCategory` at the engine's universe; `A.obj b : Grpd.{u,u}`
   (mechanical preflight rows — instance chain recorded before build).
2. An object action `A.obj` whose objects are the normalized value states (the elements
   π₀∘A sees are exactly these — nothing ambient).
3. A morphism action `A.map f` per base arrow, with `map_id`/`map_comp` (consumed by the
   Grothendieck construction's hom shape: a total hom is a base leg `f` + a fibre leg
   `(A.map f).obj X.fiber ⟶ Y.fiber`).
4. Population: the C-residue states as objects (C4).
5. Enough genuine transports that populated states are zigzag-joined (through N). This
   implication is ANALYTIC and belongs to the construction (the author: "that is why my
   theorem has hypotheses" — C1–C4 build the special A, never an arbitrary functor).

---

## §2 The forward column — what C1–C4 supply (ASection.lean, import-clean: StemRing + Mathlib only)

Data fields: `F : ℂ → ℂ` (:56, the one intrinsic stem), `intrinsic` (:58),
`meromorphic : MeromorphicOn F Set.univ` (:61), `pole : ℝ` (:63), `ι/ι_infinite/ℓ`
(:72–:76), `Ω₀ : ℝ` (:79), `m/Rfac/gfac/genus` (:104–:112), `sphereZero : ℕ → ℂ` (:115,
upper-half-plane representatives), `valueAtInfinity : OnePoint ℂ` (:196, the marked
`rmk:compactify` node).

**C1 (the anchor at N):** `c1_analyticAt` (:66), `c1_simple` (:70, meromorphic order
exactly −1). Certified consequence already on disk: `ASection.stemWinding_circle_pole`
(SigmaE3:895) — every small circle at the pole winds **−1**.

**C2 (the Euler channel, all clauses guarded by `Ω₀ < z.re`):** `c2_intrinsic`,
`c2_analyticAt`, `c2_zero_free`, `c2_summable`, `c2_euler` (`F z = exp (∑' p, ℓ p z)`),
`c2_locMajorant` (:81–:100). Certified consequences: `zero_free_on_halfSpace` (:207),
`stemWinding_F_halfSpace = 0` (WeldW12:238, the W1 master row),
`stemWinding_c2_factor = 0` (WeldW12:213 — each ℓₚ∘γ is itself a closed lift),
and the W1 loop constructor `GpvTransport.ofEulerHalfSpaceLoop` (Recovery:50).

**C3 (the divisor, through N):** `c3_R_*`, `c3_g_*`, `c3_sphere_nonreal`,
`c3_multipliable`, `c3_locMajorant`, `c3_lowerEdge`, `c3_atN`
(`Summable fun n => 1/(1+‖sphereZero n‖²)`), `c3_factorization` (:117–:184).
Certified consequences: the left wall (`F_ne_zero_of_re_lt_lowerEdge` WeldW12:320,
`exists_leftWall_zero_free` :332, feeding W2 `ofLeftRegionLoop` Recovery:99),
`no_closed_lift_around_sphereZero` (SigmaE3:983 — the obstruction at every zero),
`sphereLoop_value_winding` (WeldW3:487 — value winding = the divisor's tally ≥ 1).

**C4 (population):** `c4_infinite : (Set.range sphereZero).Infinite` (:189) — realized
as states by `NormalizedZeroObject` (§4 below).

**The compactified value:** `valueAtInfinity_real` (:201) — A(N), when finite, is real.

**The direction/G₂ supply (Slice.lean, CERTIFIED ledger rows):** `realize` (:340),
`realize_mem_sliceSphere` (:371, slice preservation of values),
`sliceCoord_smul_invariant` (:425, blindness to sphere direction),
`realize_equivariant` (:436, A(g·q) = g·A(q)) — the section's G₂ behavior induced by
equivariance, never extracted (ALIGNMENT point 6).

---

## §3 The arrow cargo — what A.map is made of

**The enriched arrow record already has the groupoid shape WITH laws**
(Recovery.lean — cargo CERTIFIED per ledger `lift_exp`/`winding` rows; endpoint typing
repoints, see §5):

```lean
structure GpvTransport (A : ASection) (σ σ' : OnePoint ℝ) (k : ℤ) where
  domain : C(unitInterval, OnePoint ℂ)
  value  : C(unitInterval, ℂ)
  lift   : C(unitInterval, ℂ)
  domain_zero/domain_one     -- endpoints at circleEmbed σ / σ'
  value_compact : ∀ t, ((value t : ℂ) : OnePoint ℂ) = A.Fstar (domain t)
  value_ne_zero : ∀ t, value t ≠ 0
  lift_exp : ∀ t, Complex.exp (lift t) = value t     -- the commuting triangle
  winding  : lift 1 - lift 0 = 2π i k
```

- `GpvTransport.id` (:144, winding 0) — **identity law material**.
- `GpvTransport.inv` (:170, σ′→σ, winding −k) — **inverse law material**.
- `GpvTransport.comp` (:201, winding k+k′) — **composition law material**.
- `ofEulerHalfSpaceLoop` (:50, W1) / `ofLeftRegionLoop` (:99, W2) — loop constructors.
- `realizes_gpv_lift` (:319): every arrow carries `(Γ t).re = Real.log ‖γ t‖` — a
  CONTINUOUS level tape — and the lift is UNIQUE once its basepoint is fixed.

**Canonicity (Toolkit.lean, CERTIFIED):** `exists_log_continuation` (:274),
`winding_lift_unique` (:301 — normalization: equal initial value), `winding_loop_defect`
(:343); `stemWinding` + `stemWinding_spec`/`stemWinding_eq_of_lift` (SigmaE3:79–:98 —
the rung k is canonical, every lift computes the same winding).

**Relation certificates at the seams:**
- Homotopy-rectangle engine: `stemWinding_eq_of_homotopy` (WeldW12:358), convex-carrier
  and half-plane comparison rows (:483/:529/:576), additivity `stemWinding_finset_prod`
  (:599), rectangle model (`rectLoop` :713 + counting rows).
- The crossing suite (SigmaE3, CERTIFIED ledger rows): `crossing_height_odd_of_neg`
  (:730) / `_even_of_pos` (:746), `band_side_of_sign` (:779), `crossing_band_ledger`
  (:849), `winding_height_shift` (:879).
- The flip machinery (FlipWeld, all live rows PROVED): crossing-data existence at
  isolated crossings (:216), signature parity skeleton (:257/:290), arc-one-band (:334),
  bounce-conserves/flip-steps band (:465/:480), the flip producers (:504/:703),
  `exists_interior_flip_of_stemWinding_ne_zero` (:754),
  `closed_lift_of_no_interior_flip` (:842 — Cor 5.13's no-flip instance end-to-end),
  crossing-sign rigidity rows (:986/:1035), `rect_value_flip` (:1082).
- W3 sphere-loop suite (WeldW3): S⁶ connected vs S⁰ disconnected (:147/:124), tame
  loops with EMPTY obstruction set and constant companion (:224–:348), the octonionic
  fibre rows (`Octonion.exp_fibre_re` :364, `exp_fibre_concentric` :377,
  `exp_kernel_unit_imaginary` :391 — "the kernel of exp is concentric"), the touch
  (:576) and `stemWinding_pos_meets_neg_real` (:519).
- W4 two-center rows (WeldW4): `two_center_disjoint_counts` (:106),
  `two_center_winding_onto_one_band` (:165 — C1's cone factor annihilates the whole
  two-center winding; every lift closes).

**The N-junction (the Euler↔Weierstrass connection through the pole):**
- `cone_tape_escape` (IntegrateTheorem:103) — near the pole the tape log‖A‖ exceeds
  every M, zero-free on the δ-interval (the +∞ approach to N).
- `cone_junction_levels_shared` (:167) — every sufficiently high level attained on
  BOTH sides of the pole.
- The pole bridge (NormalizedPoleBridge): `normalizedZero_pole_winding` (:18 —
  `stemWinding (Γz·Γp) = multiplicity − 1`) and `normalizedZero_pole_power_closes`
  (:48 — the multiplicity-power composite admits a CLOSED lift: `Γ' 1 = Γ' 0`).
- The N-leg (NormalizedNLeg): `NormalizedNLeg` record (:25, the closure datum),
  `source = normalizedZero n I` with `label = (sphereZero n).re` (:42), `target = N`
  (:46) — the certified analytic leg from each zero object toward the common witness.
- The ladder (LoopAssembly, CERTIFIED): `exp_fibre_level` (:161 —
  `exp w = −r ⟹ w.re = log r`), `shared_ladder_encounters` (:271 — one shared −r per
  pair and scale; ∃-shape, encounters not canonical, ALIGNMENT point 7).

---

## §4 Where the real value is present in the transported elements themselves

This is the κ = {c} register (the author's ruling, 2026-07-15): the value content is
IN the states and IN the arrows — no projection map exists anywhere in the certified
cargo, and none is needed.

**In the states** (NormalizedBase, CERTIFIED rows):

```lean
structure NormalizedZeroObject (A : ASection) where
  index : ℕ
  world : SphereWorld
  footpoint : NormalizedCircleBase          -- the circle point AT the label
  label : ℝ                                 -- THE REAL DATUM, a field
  footpoint_label : footpoint = normalizedFootpoint label
  label_zero : label = (A.sphereZero index).re
```

- `normalizedZero_label_world_independent` (:59, `rfl`) — the label is the SAME in
  every world: the datum is direction-blind.
- `normalizedZeroLift_re` (:92) — the octonionic lift's real part IS `(sphereZero n).re`.
- `normalizedZeroLift_norm` (:149), `normalizedZero_collapse_at_N` (:157) — the fleet
  escapes every ball, in every world simultaneously (the approach to N).

**In the arrows:** `GpvTransport.lift` with `lift_exp` — by `realizes_gpv_lift` the
arrow's own lift carries the level tape `(lift t).re = log ‖value t‖`, continuous,
basepoint-unique; `winding` carries the band datum k ∈ ℤ. The value rides INSIDE the
transport record.

**In the fibre geometry (octonionic register):** `exp_fibre_level` /
`Octonion.exp_fibre_re` / `exp_fibre_concentric` — one level `log r` per degenerate
fibre, the fibre concentric about the single real centre; `exp_kernel_unit_imaginary` —
the degenerate fibre over −1 is exactly the concentric family `(2k+1)π·S⁶`.

**At N:** `valueAtInfinity_real` (A(N) real when finite); `cone_junction_levels_shared`
(both sides of the pole share every high level); the pole bridge closes lifts through N.

---

## §5 Contamination / repointing map

**Import-clean of all old bases** (checked file-by-file this session): ASection.lean,
Slice.lean, Toolkit.lean, SigmaE3.lean, LoopAssembly.lean, WeldW12.lean, WeldW3.lean,
WeldW4.lean, FlipWeld.lean, NormalizedAction/PoleBridge/NLeg (which inherit only
through NormalizedBase).

**Repointing column** (cargo certified; endpoint TYPES reference old carriers —
one-step retyping obligations when A freezes, not math changes):

| File | Old-carrier reference | What repoints |
|---|---|---|
| Recovery.lean | imports ConnectedBase — `GpvTransport` endpoints via `circleEmbed`/`Realizes`/`NonSingular` | endpoints retype to the locked base register |
| NormalizedBase.lean | imports TransportObject — `NormalizedCircleBase := BaseC` | footpoint carrier retypes to `GreatCircle.Point` (same `OnePoint ℝ`) |
| IntegrateTheorem.lean | imports FaithfulApply + TransportObject — `gpvZigzag`/`transport_universal_gpv` typed on old objects | stem content salvages; carriers retype |
| ConcentricityReadout.lean | `value_const_on_component` on old `TotalA`; `transportClass` on old `TotalTransport` | old-chain rows; superseded by the locked outline |

**Superseded-shape artifact (author's ruling requested):** NormalizedCone.lean —
imports AFunctor; its `NormalizedZeroCone` carries `realLabel : C → ℝ` with blanket
`label_transport : ∀ f, realLabel X = realLabel Y` — exactly the externalized
preservation shape the locked outline retires (§4: no global realValue hypothesis;
no projection). Flagged, untouched.

**The old chain itself** (replace-never-patch): Base.lean, TransportObject.lean,
ConnectedBase.lean, AFunctor.lean, ConcentricityReadout.lean.

---

## §6 The forcing skeleton (generator/relation table, filled where certified rows exist)

**The author's register correction (2026-07-15, on receipt of this report):** C1–C4 are
SUFFICIENT conditions — the hypotheses of the theorem. This inventory reconstructs what
they SUPPLY; it does not claim a unique functor is fixed, nor that every supplied row
must be consumed. The design target is a WELL-DEFINED `A : 𝓑 ⥤ Grpd` whose transports
preserve the real values in the colimit — the construction selects from the supply, the
author guiding the assembly.

𝓑 = ActionCategory PGL(2,ℝ) (OnePoint ℝ): every arrow IS a group element with its
transport equation, so `A.map` on all arrows = an action-compatible assignment on
PGL(2,ℝ) over the point family; `map_id`/`map_comp` reduce to the group law + the
assignment's coherence. Generators and their certified supply:

| Base channel | Forced fibre action (source) | Certified supply rows | Relation certificate | Real datum carried |
|---|---|---|---|---|
| identity at b | identity transport | `GpvTransport.id` (winding 0); uniqueness `winding_lift_unique` | `map_id` from lift uniqueness at fixed basepoint | level tape constant |
| identity-component channels (disk family e^{Iθ}(z−w)/(1−w̄z) through the Cayley dictionary, ALIGNMENT 17 — **F5/F6 now due**) | continuation transports; μ(t) = exp(lift t − lift 0) family (point 12, proposal of record — derive as lemmas) | `exists_log_continuation`, `realizes_gpv_lift`, `stemWinding_spec` | `GpvTransport.comp` + homotopy rows (WeldW12:358+) | \|μ\| = level shift; μ/\|μ\| = phase path, winding as holonomy |
| U(1)/band inside the identity component | band phase in every world | `bandEnd` (SliceSphereWorld:272), crossing/band ledger (SigmaE3) | `bandGL_mul`, band rows | rung parity / strip side |
| real crossings | crossing transport | crossing suite (SigmaE3:730–:983), flip machinery (FlipWeld) | ledger + flip producer + no-flip closure | value sign ↔ rung parity ↔ strip side |
| the N-channel (pole) | the cone/junction transports; the N-leg | C1 anchor (`stemWinding_circle_pole` = −1), pole bridge closes, `cone_junction_levels_shared`, `NormalizedNLeg` | multiplicity-power closure (`normalizedZero_pole_power_closes`) | tape escapes both sides; A(N) real |
| loops (W1/W2) | zero-winding representatives | `ofEulerHalfSpaceLoop`, `ofLeftRegionLoop`, `stemWinding_F_halfSpace` | winding additivity (`stemWinding_finset_prod`) | level tape closed |
| **second PGL(2,ℝ) component** | **DESIGN-INPUT** — candidate correspondence: the reflection class ↔ the crossing/flip register | (candidate rows above) | **DESIGN-INPUT** | **DESIGN-INPUT** |
| G₂/direction legs (fibre-internal, not base) | same direction arrow (equivariance, never extracted) | `realize_equivariant`, `dirHom`/`dirHomTo`, `G2.smul_sliceEmbed` | equivariance square GREEN | label world-independent (`rfl`) |

**DESIGN-INPUT cells (the author's guidance, per point 15 — answered a posteriori by
the most natural functor; the four DETERMINE items of ALIGNMENT §worklist carry in):**
1. The exact normalized state type of `A.obj b` — which of the certified state records
   (NormalizedZeroObject / NormalizedSlicePoint / the GpvTransport-enriched form) is the
   object, and what the non-zero states over general b are.
2. Which base generator family presents the channels (the disk family + what represents
   the second component; the Cayley dictionary F5/F6 lands here).
3. Whether direction morphisms store G₂ elements, paths, or quotient classes; the
   nature of `liftPhase` (object / path / holonomy / naturality witness).
4. Which projection of the state is THE conserved datum across all channels (the label
   `(sphereZero n).re` is the certified candidate for the zero states — world-blind,
   `rfl`; the arrows' level tape shifts along general channels and closes on loops and
   through N by the certified closure rows).

---

### §6a The author's banked generator proposal (2026-07-15 — TO-DERIVE, never assumed)

The distinguished element

\[
  f(z)=e^{I\theta}\frac{z-w}{1-\bar w z}
\]

(the disk automorphism family; U(1) ⊂ PSU(1,1), the identity component read through the
Cayley dictionary — ALIGNMENT 17; F5/F6 now due) as the generator family whose value
transports move through the GPV registers (the degenerate exp base) through W2/W3
correctly and EXTEND through the winding closure through N. Candidate certified supply
if derived: the W2 left-region loop (`ofLeftRegionLoop`), the W3 sphere-loop suite
(tame, empty obstruction set, constant companion), the ladder (`exp_fibre_level`,
`shared_ladder_encounters`), and the N-closure rows
(`normalizedZero_pole_power_closes`, `cone_junction_levels_shared`,
`stemWinding_circle_pole`). Sits beside the point-12 μ(t) triangle proposal
(|μ| the level shift, μ/|μ| the phase path, winding as holonomy) — both derive as
lemmas, never assumed.

**The author's clarification (2026-07-15, second pass): the element is proposed at the
TOTAL-OBJECT level, not base-only.** The phase is exp(Iθ) with **I ∈ S⁶** — the band
phase read simultaneously in EVERY sphere world (the fibre leg: `bandHomAt I` at angle
θ for every I, fixing 0 and N in each world — `bandMoebius_apply_zero`/`_infty`),
while the Möbius part (z−w)/(1−w̄z) is the base leg (the circle channel through the
Cayley dictionary). One formula therefore supplies BOTH legs of a Grothendieck
morphism of 𝒯_A = ∫_𝓑 A — (base channel, fibre transport) — coherently across the
continuum, because all S²_I share ℝ ∪ {N} and real data are direction-blind
(`sliceCoord_smul_invariant`; the label's world-independence, `rfl`). The phase
parameter runs along the degenerate exp base itself: `exp_kernel_unit_imaginary`
(WeldW3:391) prints the kernel as the concentric family (2k+1)π·S⁶, so θ sweeping the
odd multiples of π touches the degenerate fibre — the level (real part) stays put, the
band coordinate moves — and the accumulated k is the winding, closed through N by the
pole-bridge rows. Candidate answer to the freeze item "how the retained SphereWorld
supplies the morphism geometry": the fibre leg of `A.map` on identity-component
generators is the I-indexed band family (`bandEnd`), the w-part riding as the
transport's lift/tape data. TO-DERIVE.

## §7 Named gaps and obligations (the four legitimate forms only)

- **Fstar pole repair** — pole ↦ ∞ not yet encoded on the compactified stem (named
  obligation, ALIGNMENT point 20(b)).
- **GAP-1** — Cor 5.13's signature criterion as Lean (evenness flag; "circular
  signature" naming). Partial in-repo: `stemSignature_eq_neg_one_of_odd`
  (FlipWeld:316), `closed_lift_of_no_interior_flip` (:842).
- **GAP-2** — the bridge from companion antipode to the octonionic direction action,
  and log-strip data to the Möbius U(1) action (`liftPhase` a candidate input).
- **Repointing obligations** — §5 table (Recovery endpoints; NormalizedBase carrier;
  IntegrateTheorem carriers).
- **Superseded-shape artifact** — NormalizedCone.lean (author's ruling requested).
- **Sorry census unchanged** — 2 old-chain steps (replaced by the locked outline),
  1 dead-route receipt (WeldW3, attic candidate), 1 orphan (KeystoneFinality).
- `KeystoneAssembly.value_loop_lift_unique` — wrapper; use `winding_lift_unique`
  directly (Codex #4, adjudicated).

---

## §8 The phase queue — certified supply per phase task (Codex plan of 2026-07-15, audited PASS)

### Phase 1 — freeze the mathematical endpoints

| Backwards demand | Certified supply on disk |
|---|---|
| generic total-object API | `Grothendieck` obj/hom shape; `pi0_grothendieck` (Theorem.lean:144); `pi0GrothendieckEquiv` (:108); `toColimitObj`(_eq_of_hom/_eq_of_zigzag) (:68/:77/:92) |
| universe/instance preflight | `GreatCircle.Base := ActionCategory Aut Point` (ProjectiveBase:58) + `groupoid` (:62); target `Grpd.{u,u}`, `SmallCategory B` |
| what a state must contain | `NormalizedZeroObject` (NormalizedBase:28 — index, world, footpoint, `label : ℝ`, `label_zero`); `NormalizedSlicePoint` (NormalizedAction:17) |
| what a fibre morphism must contain | `GpvTransport` fields (Recovery:23 — domain/value/lift/`lift_exp`/`winding`); `SphereHom` legs (`rot`+`rot_eq`, `mob`; SliceSphereWorld:200) |
| how the real value is present | `label_zero`; `normalizedZeroLift_re` (:92); `realizes_gpv_lift` tape `(Γ t).re = log ‖γ t‖` (Recovery:319) |
| population entry | `c4_infinite` (ASection:189); `normalizedZero` constructor (NormalizedBase:39) |
| singleton tail (Phase 5 dep) | `Pi0SingletonStatement`/`pi0Singleton_of_isConnected` — certified standalone twice; **LAND IN-REPO (queued)** |

### Phase 2 — the generator action (the eight tasks of the distinguished family)

| Task | Certified supply / status |
|---|---|
| 1. uniform stem/slice form ∀ I | `sliceEmbed` (Slice:65), `sliceEmbed_mul` (:73), `G2.smul_sliceEmbed`, `sliceCoord_smul_invariant` (:425), `realize_equivariant` (:436); one intrinsic stem `F` |
| 2. Cayley-conjugated projective action | `scalar_smul`/`instMulActionAutPoint`/`mk_smul` (ProjectiveBase); pin's `mulActionOfGL` + UpperHalfPlane Möbius worked example; **the ℝ dictionary homeomorphism is NOT in the pin (Mathlib TODO, ProjectiveLine.lean:20) — in-repo construction, F5/F6 (the one from-scratch piece)** |
| 3. simultaneous phase ↔ band | `bandGL`(_val/_one/_mul), `bandMoebius_apply_coe/_zero/_infty`, `bandMoebiusHom`, `bandHomAt`, `bandEnd : Circle →* End I` (SliceSphereWorld:106–:281) |
| 4. value path ↔ GPV lift + tape | `exists_log_continuation` (Toolkit:274), `winding_lift_unique` (:301), `realizes_gpv_lift` (Recovery:319), `stemWinding_spec`/`_eq_of_lift` (SigmaE3:86/:98) |
| 5. odd-π degenerate encounters | `exp_fibre_level`/`exp_fibre_height_band` (LoopAssembly:161/:172); `Octonion.exp_fibre_re`/`_concentric`/`exp_kernel_unit_imaginary` (WeldW3:364/:377/:391); `crossing_height_odd_of_neg` (SigmaE3:730); `shared_ladder_encounters` (LoopAssembly:271) |
| 6. extension through N | `stemWinding_circle_pole` (SigmaE3:895); `normalizedZero_pole_winding`/`_power_closes` (NormalizedPoleBridge:18/:48); `NormalizedNLeg` (NormalizedNLeg:25); `cone_tape_escape`/`cone_junction_levels_shared` (IntegrateTheorem:103/:167); `two_center_winding_onto_one_band` (WeldW4:165); `valueAtInfinity_real` (ASection:201) |
| 7. composition/inversion | `GpvTransport.id`/`.inv`/`.comp` (Recovery:144/:170/:201); `bandEnd` monoid laws; `SphereHom.comp_*`/`id_*`; `stemWinding_finset_prod` (WeldW12:599); homotopy invariance (WeldW12:358) |
| 8. second component ↔ crossing/flip | crossing suite (SigmaE3:730–:983); FlipWeld: `crossingData_of_isolated` (:216), flip producers (:504/:703), `exists_interior_flip_of_stemWinding_ne_zero` (:754), `stemWinding_eq_zero_of_no_interior_flip` (:821), `closed_lift_of_no_interior_flip` (:842), bounce/flip band steps (:465/:480), `arc_one_band` (:334), `crossing_sign_rigid`/`_const_between` (:986/:1035); junk-honesty `stemDirSign_eq_zero_iff` (:96); GPV Rem 2.1 (SOURCES/GPVwind) |

### Phase 3 — candidate testing: fixed requirements ↔ supply

Genuine states = the §4 records; certified transports = §3; groupoid pattern =
SphereWorld's `Groupoid` instance + `GpvTransport.inv`; `map_id`/`map_comp` =
`GpvTransport.id`/`.comp` + `winding_lift_unique` (uniqueness-based law proofs);
no obsolete imports = the §5 repointing table. **Critical path: the §5 retypings
(Recovery endpoints; NormalizedBase carrier) come FIRST — cargo proofs unchanged.**
Naming rule: no candidate is called the section functor until the author ratifies
the winner.

### Phase 4 — implementation preflight rows

Expected `#print axioms` for every consumed row above: `[propext, Classical.choice,
Quot.sound]` (all cited rows are CERTIFIED per GREEN_LEDGER). ProjectiveBase enters
the root import closure at this phase's build step (deliberate, ledger note).

### Phase 5 — total object

`Grothendieck (A ⋙ forgetToCat)`; population via the C4 states; zigzags from the
constructed transports; `pi0_grothendieck` + the landed generic tail; κ = {c} with
no post-colimit projection step (PROOF_OUTLINE_LOCKED §1 note).

---

*End of inventory. Next act per the phase brief: the high-level design dialogue on the
six freeze items, the author guiding, both assistants cross-auditing; then the typed
generator/relation table; then the bill of materials; then Lean.*
