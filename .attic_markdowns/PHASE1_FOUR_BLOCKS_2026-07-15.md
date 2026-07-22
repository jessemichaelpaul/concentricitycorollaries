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

# PHASE 1 — THE FOUR BLOCKS: 𝒱, the stabilizer action, the extension, the pins

**AUDIT REQUEST — check against ALIGNMENT points 20–23.**

**Prepared by:** Fable (kernel/greps, Desktop tree — canonical), 2026-07-15, answering
Codex's four-block request for the orbit–stabilizer construction of A.
**Companion documents:** INVENTORY_FUNCTOR_FORCING_2026-07-15.md,
PHASE1_ACTION_TABLE_2026-07-15.md (v2, incl. §9 pin verification).

## §0 Audit of the orbit–stabilizer proposal (led per protocol)

**Objects:** G = PGL(2,ℝ), X = OnePoint ℝ, 𝓑 = G ⋉ X ✓ locked; A : 𝓑 ⥤ Grpd ✓;
𝒱 := A(N) — Phase-1 working name for the distinguished fibre (final name the author's);
H = Stab_G(N) — typed below. The boxed target constructs A; Codex's own guard ("this is
not a base-connectedness argument for the singleton") is correct and retained. **No
foreign object. PASS**, with ONE typed design fork for the author — both branches
carry on-disk supply; this is the construction unfolding, not an obstacle:

**The two stabilizers in the author's formula.** With N := 𝔫 (the base compactified
point — the transitive action gives X ≃ G/H at any point; 𝔫 is the master's anchor):

- **Base register:** H = Stab_{PGL(2,ℝ)}(𝔫) is the AFFINE class {z ↦ az + b, a ≠ 0} —
  two components, detected by the pin's `signDet` (sign of a). Its generator classes
  map exactly onto the certified channel families: **translations** (motion along the
  great circle — the tape rows), **dilations** (flow toward/away along the circle —
  the cone/junction rows at the pole), **the reflection class** (the crossing/flip
  register). U(1)-rotations do NOT fix any boundary point — the θ-leg is not base-H.
- **Value register:** U(1) IS a stabilizer where the author's e^{Iθ} lives — the band
  fixes 0 and N **in every sphere world** (`bandMoebius_apply_zero`/`_infty`,
  SliceSphereWorld:147/:138), realized as `bandEnd I : Circle →* End I` (:272) — and
  the pin makes "stabilizer = endomorphisms at the point" DEFINITIONAL
  (`stabilizerIsoEnd := MulEquiv.refl _`, Action.lean:105).

So the author's normal form e^{Iθ}(z−w)/(1−w̄z) supplies **both layers at once**: the
w-part is the orbit transport (base), the e^{Iθ}-part is stabilizer data acting on the
VALUE side across all worlds simultaneously — i.e., structure inside 𝒱 — matching the
three-interacting-layers ruling (ALIGNMENT point 5). **DESIGN-INPUT (the author):** the
composite — base-H (affine) acting on 𝒱 whose objects already carry the band/U(1) as
their own End-monoid structure — or another packaging. The dictionary (F5/F6) pins the
disk read to the boundary carrier either way.

---

## BLOCK 1 — the distinguished fibre 𝒱 = A(N)

**Objects (what a state at 𝔫 is made of — certified supply):**

| Ingredient | Declaration | Location |
|---|---|---|
| the compactified value datum | `valueAtInfinity : OnePoint ℂ` + `valueAtInfinity_real` | ASection.lean:196/:201 |
| the value at 𝔫, definitional | `Fstar_infty` (`rfl`) | ConnectedBase.lean:29 |
| the 𝕆*-realization at ∞ | `realize_infty` | Slice.lean:360 |
| every world contains N | `sliceSphere` membership; all S²_I share ℝ ∪ {N} | Slice.lean |
| the zeros' approach to 𝔫 | `normalizedZero_collapse_at_N` | NormalizedBase.lean:157 |
| the N-leg target | `NormalizedNLeg.target = nPt` | NormalizedNLeg.lean:20 |
| candidate state records | `NormalizedZeroObject`; `NormalizedSlicePoint` | NormalizedBase:28; NormalizedAction:17 |

**Morphisms, identities, inverses, composition (the fibre's own groupoid material):**

| Law | Declaration | Location |
|---|---|---|
| vertical direction legs (fix footpoints AND N) | `dirHom`/`dirHomTo`; `G2.smul_ofReal`; `G2.smul_onePoint_infty` (`rfl`) | SliceSphereWorld:253/:259; G2:87/:317 |
| band/Möbius self-legs at N-fixing phases | `mobHom`/`bandHomAt`/`bandEnd` | SliceSphereWorld:263–:281 |
| groupoid laws, componentwise | `SphereHom` Category+Groupoid instances; `comp_rot`/`comp_mob`/`id_*` | SliceSphereWorld:209–:248 |
| world connectivity inside the fibre | `sphereWorld_zigzag`; `exp_fibre_sphere_connected`; `exp_fibre_conj_joined` | SliceSphereWorld:288; LogManifold:558/:587 |
| value-datum constancy on vertical legs | `normalizedZero_label_world_independent` (`rfl`) | NormalizedBase:59 |
| identity at 𝔫 (conditional) | `realizes_id` under `NonSingular`; NonSingular(𝔫) ⟺ `valueAtInfinity ∉ {0, ∞}` | ConnectedBase:98/:77 |
| enriched arrow-cargo laws | `GpvTransport.id`/`.inv`/`.comp` (repointing column) | Recovery:144/:170/:201 |

---

## BLOCK 2 — the stabilizer action at N (H ↷ 𝒱)

**H typed:** Stab_{PGL(2,ℝ)}(𝔫) = affine class, generators = translations, dilations,
one reflection representative; components detected by `signDet` (pin, Projective.lean:101).

**The generator actions' analytic supply (the residual action on 𝒱):**

| H-generator class | Certified supply | Location |
|---|---|---|
| translations (great-circle motion) | `tape_continuousOn_real`; `real_segment_tape_sweeps`; `great_circle_value_degenerate`; `great_circle_lift_through_degenerate`; `great_circle_passage_total` | IntegrateTheorem:127/:144; FaithfulApply:173/:198/:274 |
| dilations (toward/away the pole along the circle) | cone trio `pole_cone_tendsto`/`_chart`/`_eps_delta`; `cone_tape_escape`; `cone_junction_levels_shared`; `pole_encounters_joined_concentric` | LoopAssembly:189–:207; IntegrateTheorem:103/:167; FaithfulApply:354 |
| the reflection class | crossing suite (`crossing_height_odd_of_neg`/`_even_of_pos`, `band_side_of_sign`, `crossing_band_ledger`, `winding_height_shift`); flip machinery (producers :504/:703, `closed_lift_of_no_interior_flip` :842, sign rigidity :986/:1035) | SigmaE3:730–:879; FlipWeld |

**Where Euler and Weierstrass meet through N (the C2/C3 seam at the junction):**

| Fact | Declaration | Location |
|---|---|---|
| the two channels' log-derivatives | `logDeriv_euler`; `logDeriv_weierstrass` | StemFactorization:178/:252 |
| EQUAL on the overlap (one stem) | `stem_identity_logDeriv` (via `stem_identity`) | StemFactorization:437; Toolkit:246 |
| the channels' geography around 𝔫 | `pole_le_upperEdge` (pole ≤ Ω₀); `c3_atN` | PairingE2:81; ASection:176 |
| the junction shares all high levels | `cone_junction_levels_shared` | IntegrateTheorem:167 |
| zero–pole closure at the witness | `zero_pole_pair_winding` (tally − 1); `zero_pole_pair_closes_through_witness` (tally 1 ⟹ closed lift); `normalizedZero_pole_power_closes` (multiplicity power closes) | SynthesisE6:197/:228; NormalizedPoleBridge:48 |
| two-center winding annihilated through the cone | `two_center_winding_onto_one_band` | WeldW4:165 |
| the channels' identity representatives (W1/W2) | `ofEulerHalfSpaceLoop`; `ofLeftRegionLoop`; `stemWinding_F_halfSpace`; `stemWinding_F_leftRegion` | Recovery:50/:99; WeldW12:238/:1191 |

**Relation dischargers (H's group law ↦ equal transports):** `winding_lift_unique`
(equal start ⟹ equal, Toolkit:301); `stemWinding_eq_of_homotopy` (representative
independence, WeldW12:358); the winding calculus (`stemWinding_mul`/`_pow`/`_inv`/
`_const`, SigmaE3:139–:197); `winding_loop_closed` + `winding_defect_lift_independent` +
`winding_loop_defect_level_zero` (LoopAssembly:59–:107); `GpvTransport.comp` winding
additivity (Recovery:201).

---

## BLOCK 3 — equivariant extension (w, e^{Iθ}, the I-continuum, Cayley/PGL)

| Extension ingredient | Certified supply / pin | Location |
|---|---|---|
| transitivity (X ≃ G/H) | **no `IsPretransitive` instance in the pin for this action** — small in-repo lemma (explicit witness: `[[x,1],[1,0]] • ∞ = x` via `smul_infty_eq_ite`) — NAMED OBLIGATION | pin ProjectiveLine.lean:139 |
| representatives / cocycle mechanism | `homOfPair` (`(g⁻¹ • t) ⟶ t`, `.val = g`); `ActionCategory.cases` (every morphism IS a homOfPair); `comp_val` order g·f | pin Action.lean:146/:154/:comp_val |
| the w-leg (orbit transport) | `mulActionOfGL`/`mk_smul`/`scalar_smul`; `smul_infty_eq_ite`/`smul_some_eq_ite` | ProjectiveBase:38–:53; pin ProjectiveLine:139/:148 |
| the e^{Iθ}-leg simultaneously in every world | `bandGL`(_mul/_one), `bandMoebiusHom`, `bandHomAt`, `bandEnd`; fixes 0 and N per world | SliceSphereWorld:106–:281 |
| odd-π touches of the degenerate fibre | `exp_kernel_unit_imaginary`; `degenerate_sphere_mem`; `logManifold_fibre_neg_real`; `degenerate_level_readout` | WeldW3:391; LogManifold:428/:446/:466 |
| the I-continuum coherence (one stem) | `realize_equivariant`; `sliceCoord_smul_invariant`; `G2.smul_sliceEmbed`; `normalizedZero_label_world_independent` | Slice:436/:425/:312; NormalizedBase:59 |
| value path + tape along any channel | `gpvBase_transport` (the 5-clause package); `realizes_gpv_lift`; `exists_log_continuation`; `winding_lift_unique` | FaithfulApply:122; Recovery:319; Toolkit:274/:301 |
| band rotation onto the modulus (value-side seed) | `exists_band_rotation` (transferable cargo, old register) | PhiConversion:218 |
| Cayley/projective dictionary | **NOT in the pin** (Mathlib TODO, ProjectiveLine.lean:20) — in-repo construction F5/F6 — **ON THE CRITICAL PATH (the author's ruling, 2026-07-15)**: construction material defining the canonical transporters (w-leg) and the fibre-leg identification (θ-leg = bandEnd, literally `Octonion.exp (θ • I)` via `exp_sliceEmbed'`); scheduled before the ρ-definition freezes; ingredients: `mulActionOfGL`, `homeomorphCircle'`, `equivProjectivization`, UpperHalfPlane Möbius worked example | pin |

---

## BLOCK 4 — Lean pins (verified against the pinned Mathlib this session)

| Pin | Exact shape | Status |
|---|---|---|
| `CategoryTheory.ActionCategory` | `(actionAsFunctor M X).Elements`; hom = subtype (group element + transport equation); `id_val = 1`; `comp_val : (f ≫ g).val = g.val * f.val` | ✓ verified |
| `ActionCategory.homOfPair` / `.cases` | `homOfPair (t)(g) : (g⁻¹ • t) ⟶ t`; every morphism is a homOfPair (induction principle) | ✓ verified |
| `ActionCategory.stabilizerIsoEnd` | `stabilizerSubmonoid M x ≃* End x` — **`MulEquiv.refl _`: DEFINITIONAL** | ✓ verified (Action.lean:105) |
| `ActionCategory.endMulEquivSubgroup` | vertex groups ≃ stabilizer subgroups | ✓ verified |
| `ActionCategory.curry` | functors to `SingleObj H` ≃ homomorphisms into `(X → H) ⋊ G` (reference shape) | ✓ verified |
| `IsConnected (ActionCategory M X)` | from `[IsPretransitive M X] [Nonempty X]` (F9; never a hypothesis of the theorem) | ✓ verified (Action.lean:128) |
| `Matrix.ProjGenLinGroup.mulActionOfGL` / `mk_smul` | verbatim as consumed by ProjectiveBase | ✓ verified (Projective.lean:85/:93) |
| `signDet : PGL(n,R) →* SignTypeˣ` | even n (Fin 2 ✓) — the two-component detector | ✓ verified (Projective.lean:101) |
| `Grpd` / `Grpd.of` / `forgetToCat` | `Bundled Groupoid.{v,u}`; `of (C : Type u) [Groupoid.{v} C]`; `⥤ Cat.{v,u}` | ✓ verified (Groupoid/Grpd/Basic.lean:38/:54/:77) |
| `OnePoint.smul_infty_eq_ite` / `smul_some_eq_ite` | the N-motion formulas | ✓ verified (ProjectiveLine.lean:139/:148) |
| `RepresentationTheory/Induced.lean` (+ `Coinduced.lean`) | module-level induction — PATTERN REFERENCE only (Rep k G register, not groupoid-valued) | ✓ exists in pin |
| `IsPretransitive` for GL/PGL ↷ OnePoint ℝ | **ABSENT from the pin** — small in-repo lemma (witness above) | NAMED OBLIGATION |
| the ℝ Cayley/boundary homeomorphism | **ABSENT from the pin** (Mathlib's own TODO) | NAMED OBLIGATION (F5/F6) |

Universe resolution: everything at u = 0; `pi0_grothendieck` instantiates directly
(PHASE1_ACTION_TABLE v2 §9). Expected `#print axioms` for every repo row cited:
`[propext, Classical.choice, Quot.sound]` per GREEN_LEDGER discipline; non-ledger rows
enter the ledger on the next `_ledger_audit` extension, never claimed otherwise.

**The Phase-1 attempt of record (Codex's lock, restated):** construct 𝒱 → construct
BH → Grpd (the stabilizer action) → extend along G/H → A : 𝓑 ⥤ Grpd; freeze `A.obj`/
`A.map`; laws; axioms; commit the functor alone. The DESIGN-INPUT of §0 (the two-layer
stabilizer packaging) is the author's ruling to make before the typed skeleton freezes.
