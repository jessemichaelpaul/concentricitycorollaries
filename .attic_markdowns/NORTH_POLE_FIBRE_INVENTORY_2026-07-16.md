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

# NORTH-POLE FIBRE AND STABILIZER-ACTION INVENTORY

**AUDIT REQUEST — check against ALIGNMENT points 20–23.**

**Prepared by:** Fable (kernel/greps, Desktop tree — canonical), 2026-07-16, answering
the five-block request for the 𝒱 = A(N) freeze. **Notation adopted per the ratified
exchange:** G = PGL(2,ℝ), X = OnePoint ℝ = S¹, N = ∞ ∈ X, 𝓑 = G ⋉ X,
H = Stab_G(N) (affine class), BH = SingleObj H, 𝒱 = A(N), ρ : BH ⥤ Grpd,
**u = e^{Iθ} ∈ U(1)** (never c — c : ℝ is the theorem's center), μ(t) = exp(λ(t) − λ(0))
the GPV value-side path. H ≠ BH ≠ 𝒱.
**Axioms column: KERNEL-VERIFIED COMPLETE (2026-07-16).** Three passes cover every row:
the ledger (2026-07-11), the ρ-pass (`_rho_audit.lean`, 2026-07-15, 48/48), and this
session's `_npole_audit.lean` (**63/63 clean, zero name misses**) + `_cayley_audit.lean`
(**19/19 clean** — CayleyDictionary.lean built green in the canonical Desktop tree,
3621 jobs, lint notes only). Every declaration in this inventory depends on exactly
`[propext, Classical.choice, Quot.sound]`. All new rows entered GREEN_LEDGER the same
turn.

---

## BLOCK 1 — the object at N (what a state of 𝒱 is)

| Declaration | Location | Content | Axioms |
|---|---|---|---|
| `ASection.valueAtInfinity` (+ `_real`) | ASection.lean:196/:201 | the compactified value datum at N; real when finite (`rmk:compactify`) | field / CERTIFIED (2026-07-16) |
| `ASection.Fstar_infty` | ConnectedBase.lean:29 | `Fstar ∞ = valueAtInfinity` (`rfl`) | CERTIFIED (2026-07-16) |
| `ASection.realize_infty` | Slice.lean:360 | the 𝕆*-realization at ∞ = the value datum through re | CERTIFIED (2026-07-16) |
| `ASection.realize_pole` | PhiConversion.lean:514 | realize(p₀) = ∞ — the pole's value IS N | CERTIFIED (2026-07-16) |
| `ASection.NormalizedZeroObject` | NormalizedBase.lean:28 | `index/world/footpoint/label : ℝ/label_zero` — THE labeled state record | defs; label rows CERTIFIED (ledger) |
| `ASection.normalizedZero` (+ `_label`, `_footpoint`) | NormalizedBase.lean:39/:51/:54 | the constructor per (n, I); label = `(sphereZero n).re` | CERTIFIED (2026-07-16) |
| `ASection.normalizedZeroLift_re` | NormalizedBase.lean:92 | the octonionic lift's re IS the label | CERTIFIED (2026-07-16) |
| `ASection.normalizedZero_label_world_independent` | NormalizedBase.lean:59 | the label is direction-blind (`rfl`) | CERTIFIED (ledger) |
| `ASection.normalizedZero_collapse_at_N` | NormalizedBase.lean:157 | the zeros' arrival: eventually past every ball, in EVERY world | CERTIFIED (ledger) |
| `ASection.NormalizedSlicePoint` / `normalizedZeroSlicePoint` / `normalizedSectionObject` | NormalizedAction.lean:17/:28/:23 | the pointed slice continuum; zeros placed in it; the section's world-preserving action | CERTIFIED (2026-07-16) |
| `ASection.normalizedNLeg` (+ `NormalizedNLeg.target = nPt`) | NormalizedNLeg.lean:38/:20 | the certified analytic leg from each zero object toward N | CERTIFIED (2026-07-16) |
| `SphereWorld` / `baseWorld` | SliceSphereWorld.lean:194/:295 | the S⁶ world continuum; every world contains ℝ ∪ {N} | instance-verified |

**NonSingular at N, verbatim guard** (ConnectedBase:77): `Fstar(circleEmbed σ) ≠ ∞ ∧ ≠ 0`
— at σ = N this is the checkable condition `valueAtInfinity ∉ {0, ∞}`; the three-case
identity decomposition (p₀ / zero footpoints / base-N) stands as in FOUR_BLOCKS §0.

## BLOCK 2 — internal morphisms of 𝒱

| Family | Declarations | Location | Axioms |
|---|---|---|---|
| direction legs (fix ℝ and N pointwise — VERTICAL) | `dirHom`, `dirHomTo`; `G2.smul_ofReal`, `G2.smul_onePoint_infty` | SliceSphereWorld:253/:259; G2:87/:317 | CERTIFIED (2026-07-16) / ledger / CERTIFIED (2026-07-16) |
| band/Möbius legs (fix 0 and N per world) | `mobHom`, `bandHomAt`, `bandEnd`; `bandMoebius_apply_zero`/`_infty` | SliceSphereWorld:263–:281/:147/:138 | ρ-pass (bandEnd) / CERTIFIED (2026-07-16) |
| groupoid laws | `SphereHom.comp_rot`/`comp_mob`/`id_rot`/`id_mob`; Category+Groupoid instances | SliceSphereWorld:209–:248 | CERTIFIED (2026-07-16) |
| GPV arrows + laws | `GpvTransport` (.id/.inv/.comp, `toRealizes`, W1/W2 constructors); `realizes_gpv_lift` (tape) | Recovery.lean | ρ-pass CERTIFIED (+toRealizes CERTIFIED (2026-07-16)) |
| arrows closing AT N | `normalizedZero_pole_power_closes`; `zero_pole_pair_closes_through_witness`; `two_center_winding_onto_one_band` | NormalizedPoleBridge:48; SynthesisE6:228; WeldW4:165 | ρ-pass CERTIFIED |
| identities by case | `realizes_id` (NonSingular); the p₀/zero-footpoint supply (cone trio; fibre-tally winding rows) | ConnectedBase:98; LoopAssembly; SigmaE3 | CERTIFIED (2026-07-16) / ρ-pass |
| fibre connectivity through the degenerate fibre | `sphereWorld_zigzag`; `exp_fibre_sphere_connected`; `exp_fibre_conj_joined` | SliceSphereWorld:288; LogManifold:558/:587 | ρ-pass / CERTIFIED (2026-07-16) |
| the enriched witness record (field inventory of the fibre morphism) | `GpvTransportWitness`; `gpvPopulated`; `GpvZigzag`; `gpv_zigzag_readout` | IntegrateTheorem:270–:416 | CERTIFIED (2026-07-16) (gpvPopulated, transport_universal_gpv) — old carriers, repointing column |

## BLOCK 3 — C1–C4 at N

| Clause | Declarations | Location | Axioms |
|---|---|---|---|
| C1 — the pole normalization | `pole : ℝ`, `c1_analyticAt`, `c1_simple` (order −1); `stemWinding_circle_pole` (−1); cone trio (`pole_cone_tendsto`/`_chart`/`_eps_delta`); `eventually_ne_zero_near_pole` | ASection:63–:70; SigmaE3:895; LoopAssembly:189–:207; IntegrateTheorem:76 | fields CERTIFIED (2026-07-16); circle_pole CERTIFIED (ledger); eps_delta ρ-pass; rest CERTIFIED (2026-07-16) |
| C2 — the Euler channel toward N | `c2_euler` (F = exp Σℓₚ); `zero_free_on_halfSpace`; `stemWinding_F_halfSpace` (W1 master); `pole_le_upperEdge` (the pole sits ≤ Ω₀ — channel geography) | ASection:90/:207; WeldW12:238; PairingE2:81 | CERTIFIED (2026-07-16) / ρ-pass |
| C3 — the Weierstrass channel through N | `c3_factorization`; `c3_atN` (summability through N); `sphereZero_complete` + `stem_zero_of_sphereZero` (the divisor both ways); `stem_local_form`; ledger order/residue rows | ASection:184/:176; StemFactorization:67/:133/:549/:813/:826 | CERTIFIED (2026-07-16) |
| the seam (C2 = C3, one stem) | `stem_identity`; `stem_identity_logDeriv`; `logDeriv_euler`/`logDeriv_weierstrass` | Toolkit:246; StemFactorization:437/:178/:252 | ρ-pass CERTIFIED |
| C4 — population entering the fibre | `c4_infinite`; `normalizedZero` (per n, I); `no_finite_zero_accumulation` (zeros accumulate ONLY at N); `supLevel_attained_or_escape` | ASection:189; NormalizedBase:39; KernelE4:362/:459 | CERTIFIED (2026-07-16) |

## BLOCK 4 — W1–W4 at N

| W-content | Declarations | Location | Axioms |
|---|---|---|---|
| identity/zero-winding representatives (W1/W2) | `GpvTransport.ofEulerHalfSpaceLoop`/`.ofLeftRegionLoop`; `stemWinding_F_halfSpace`/`_F_leftRegion`; `stemWinding_const` | Recovery:50/:99; WeldW12:238/:1191; SigmaE3:139 | ρ-pass CERTIFIED |
| crossing/flip transport (W3/flip register) | crossing suite (odd/even rungs, `band_side_of_sign`, `crossing_band_ledger`, `winding_height_shift`); `CrossingData.bounce_conserves_band`/`flip_steps_band`; `arc_one_band`; flip producers; `closed_lift_of_no_interior_flip`; sign rigidity | SigmaE3:730–:879; FlipWeld:334–:1035 | ledger + ρ-pass + CERTIFIED (2026-07-16) (bounce/flip/arc) |
| odd-π degenerate encounters | `exp_kernel_unit_imaginary` ((2k+1)π·S⁶); `exp_eq_neg_real_iff`; `exp_fibre_level`/`_height_band`; `Octonion.exp_fibre_re`/`_concentric`; `sphereLoop_touches_degenerate`; `shared_ladder_encounters` | WeldW3:391/:364/:377/:576; LoopAssembly:126–:172/:271 | ρ-pass / ledger / CERTIFIED (2026-07-16) |
| zero–pole closure (W4) | `zero_pole_pair_winding` (tally − 1); `zero_pole_pair_closes_through_witness`; `normalizedZero_pole_winding`/`_power_closes`; `two_center_winding_onto_one_band`; `sphereLoop_value_winding` (tally); `stemWinding_circle_sphereZero`; `fiber_tally_pos` | SynthesisE6:197/:228; NormalizedPoleBridge:18/:48; WeldW4:165; WeldW3:487; SigmaE3:348/:330 | ρ-pass + CERTIFIED (2026-07-16) |
| cone/junction sharing | `cone_tape_escape`; `cone_junction_levels_shared`; `real_segment_tape_sweeps`; `pole_encounters_joined_concentric`/`zero_encounters_joined_concentric`; `sigma_level_separation` | IntegrateTheorem:103/:167/:144; FaithfulApply:354/:328; SigmaE3:467 | ledger + ρ-pass + CERTIFIED (2026-07-16) |

## BLOCK 5 — the stabilizer generator action (ρ's definition data)

| H-generator ↔ channel | Supply (see PHASE1_RHO_LAWS for law-by-law detail) | Axioms |
|---|---|---|
| translations ↔ tape | `gpvBase_transport` (5-clause package); tape continuity/sweep; degenerate-passage lifts | ρ-pass CERTIFIED |
| dilations ↔ cone/junction | cone trio; junction sharing; pole-bridge closures | ρ-pass CERTIFIED |
| reflection ↔ crossing/flip (`signDet` label) | the flip register end-to-end | ρ-pass CERTIFIED (+3 CERTIFIED (2026-07-16)) |
| conjugation with internal `bandEnd` | DERIVATION TARGET (Law 9): model rows `G2.smul_sliceEmbed` (CERTIFIED), `realize_equivariant` (CERTIFIED), `bandGL_mul`/`bandEnd` (ρ-pass); the μ(t) triangle (point 12, TO-DERIVE); **NEW: CayleyDictionary.lean lands the composition law** | see below |
| the exponential geometry (u = e^{Iθ} literally) | `exp_sliceEmbed'`/`norm_exp`/`exp_ne_zero`; `sphere_path`; `exp_fibre_sphere_connected`/`_conj_joined` | CERTIFIED (2026-07-16) |

**NEW — CayleyDictionary.lean (Codex, kernel-elaborated 2026-07-15/16; pulled into the
canonical tree and tri-synced this session; NOT yet in the root import closure):**
`GreatCircle.cayleyGL`/`cayleyProjective : GreatCircle.Aut →* Moebius` (the conjugation,
descending through scalar classes), `cayleyCoord` + `cayleyCoord_equivariant` (the
coordinate dictionary), `distinguishedGL`/`distinguishedMoebius (c : Circle)
(w : UnitDisc)` (the author's family), **`distinguishedCompW`/`distinguishedCompPhase`/
`distinguishedGL_mul`/`distinguishedMoebius_mul`** (the composition law: new orbit
coordinate w₃ + residual phase u₃ — the cocycle calculation), `distinguished_phase_is_band`,
`ASection.exp_phase_eq_sliceEmbed` (u = exp(θ•I) as a theorem). Zero `sorry` in-file;
`_cayley_audit.lean` running — rows enter the ledger on the pass.

---

## §6 Notices (Fable — things noticed, for the author and Codex)

1. **The BH-equivalence is a construction tool, never a base replacement.** G ⋉ X ≃ BH
   is used to DEFINE A by induction; 𝒯_A = ∫_𝓑 A stays over the full 𝓑 — the zeros'
   addresses live over their own footpoints (Rule 1). No step may quotient the base to
   one object in the theorem's statement or the total object.
2. **CayleyDictionary.lean needed pulling** — it existed only in Codex's session
   workspace; the sync protocol now covers three trees, and new Lean files must cross
   every turn they change. Pulled, tri-synced; root-import wiring is a Phase-2 step.
3. **`PHASE1_CANDIDATE_A1_2026-07-15.md` also arrived** with the pull (Codex's candidate
   design). It awaits the cross-audit when the author sends it for that purpose — not
   audited here.
4. **The u-notation** (u = e^{Iθ}, c reserved for the center) is adopted in this and
   future records.
5. **Suggested addition to 𝒱's freeze discussion** (inventory observation, author's
   call): the state records already carry the real datum as a FIELD with `rfl`-grade
   world-independence, and `winding_loop_defect_level_zero` gives unconditional level
   closure on loops — together these are the value-conservation shape freeze item #5
   wants, with no external map anywhere.
6. **Three-register N discipline** (pole p₀ / base-N / value-N) is load-bearing in
   Blocks 1–4 above; the master's three typed appearances stay separate, compatibility
   being the functor's job (ALIGNMENT point 10).
