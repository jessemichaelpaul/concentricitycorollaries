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

# AERIAL INVENTORY — the exhaustive sweep of the airplane and its geography

*2026-07-13 (Fable, for Codex and the author). Provenance: a 15-agent workflow over all
61 files / 22,789 lines of `Concentricity/` — thirteen readers classifying every
declaration onto the aerial frame of reference (the exhaustion checklist of 2026-07-12),
one coverage synthesizer, one adversarial completeness critic. 934 rows extracted.
Machine-readable appendix: `AERIAL_ROWS.tsv` (all rows, greppable). TIER DISCIPLINE
(ALIGNMENT point 20): sweep status = proved-in-file; kernel TIER claims live only in
GREEN_LEDGER.md — cite the ledger, never this file, for certification.*

## §0 Headlines for the build

1. **The morphism cargo is done.** Winding/holonomy, GPV records, exponential lifts, and
   the exp(lift)=value, G₂-equivariance, slice-preservation, Euler/Weierstrass-overlap,
   and pole/inverse-chart diagrams are all proved over safe frames (stem/domain-H1/
   carrier/zeta). The analytic depth of the canyon is fully stocked.
2. **The endgame is already genericized.** `ASection.NormalizedZeroCone`
   (NormalizedCone.lean:25) packages zeroObj/N/realLabel/zero_label/toN/label_transport
   over ANY category, and `zero_levels_common` (:36) + `concentricity_of_normalized_
   zero_cone` (:49) are PROVED generically — labels transported along toN, no direct
   zero-to-zero arrow. **Constructing one honest instance over the corrected
   architecture closes the readout.** Rule-1 obligation: the instance's `toN` arrows
   must be DERIVED from the built action, never inserted.
3. **Exactly two checklist cells are ABSENT, and they are the two E1 builds**: the
   ℂ*-diagonal path (only the U(1) band diag(c,1), |c|=1, exists; the radial component
   lives only as level-tape lemmas) and the base/sphere Möbius compatibility square
   (no row relates PGL(2,ℝ) base arrows to sphere-world Möbius arrows). The functor
   phase's new mathematics is precisely: `diagGL : ℂˣ → GL(2,ℂ)` extending `bandGL`,
   and the E1 channel squares.
4. **The locked base is a deliberate orphan.** Zero references to `GreatCircle.*`
   outside ProjectiveBase.lean — as ruled (point 19: build, verify, save, STOP). Wiring
   the fibre functor over it is the single biggest missing piece, and it was always the
   next phase.
5. **The Normalized layer's contamination is exactly two aliases deep**:
   `NormalizedCircleBase := BaseC` and `NormalizedNLeg.target = BaseC.nPt`. A mechanical
   retarget once the base of record changes — the layer's equivariance and slice rows
   are otherwise safe (sphereworld/mixed).
6. **No faithful zero address exists yet**: `zeroAddress` ignores its index (constant
   address). E4 (population: Z_{n,I} as genuine per-index objects) is confirmed open.
7. **The zeta payoff chain is fully green and waiting** (zetaSection with all C1–C4
   fields, divisor enumeration, Hadamard stages, RH equivalence) — unblocked the moment
   the abstract functor closes.
8. **Uniqueness got stronger**: beyond the canonicity cluster, the sweep surfaced
   `stemWinding_eq_of_homotopy` (WeldW12.lean:358 — GPV Def 4.20 stem-rendered, proved:
   homotopy-invariance of stem winding via IsCoveringMap.liftHomotopy). E2's
   characterization strategy has its homotopy leg already in the kernel.

## §1 Sorry census (corrected 2026-07-13)

Four sorried declarations on disk; THREE inside the root import closure; the audited
theorem-chain still gates through exactly the two ConcentricityReadout rows:

| Declaration | Location | In root closure? | Register |
|---|---|---|---|
| `ASection.totalA_pi0_singleton` | ConcentricityReadout.lean:197 | YES (root) | the known gate |
| `ASection.zero_levels_common` | ConcentricityReadout.lean:243 | YES (root) | the known gate |
| `ASection.concentricity_via_weldW3` | WeldW3.lean:639 | **YES** (root → ConcentricityReadout → AFunctor → WeldW3) | old-register restatement of the same readout |
| `ASection.transportLevel_const_via_finality` | KeystoneFinality.lean:81 | NO (zero importers — orphan) | the dropped finality route, still on disk |

All four are the same final readout restated (the critic's finding); the two artifact
rows are attic candidates per the standing refactor plan, not proof obligations.

## §2 The numbers

**934 rows** from 61 files: 693 proved, 237 defs, 4 sorried.

Typed-over (the contamination axis): stem 340, domain-H1 238, zeta 135, mixed 61, old-total 42, generic 36, carrier 33, sphereworld 27, old-base 15, locked-base 7.
**Safe core = 816 rows** (stem+carrier+sphereworld+locked-base+domain-H1+zeta+generic);
**contaminated = 57 rows** (old-base 15 + old-total 42), all base/total WIRING, no analytic content;
mixed = 61 (mostly Normalized-layer rows pinned by the two aliases).

Frame distribution: ANALYTIC-SUPPORT 203, MOR-winding 95, MAP-readout 86, OBJ-zero 46, DIAG-slice 46, OBJ-poleN 37, OTHER 37, OBJ-presentation 36, MOR-gpv 36, MAP-address 35, MAP-eval 29, MAP-lift 28, MOR-g2 27, OBJ-world 26, MOR-laws 24, ENGINE 24, DIAG-center 18, OBJ-base 16, MOR-u1 15, MAP-projection 11, DIAG-euler-weier 11, DIAG-equivariance 10, DIAG-poleN 9, MOR-transition 7, MAP-compactify 5, MOR-mobius 5, MOR-pgl 4, DIAG-laws 3, DIAG-triangle 2, MAP-normalization 2, OBJ-state 1.

## §3 Coverage against the exhaustion checklist (20 COVERED / 8 PARTIAL / 2 ABSENT)

- **PARTIAL** — Object: base point b in OnePoint(R)
  - GreatCircle.Point Concentricity/ProjectiveBase.lean:30 (locked-base,def)
  - GreatCircle.Base Concentricity/ProjectiveBase.lean:58 (locked-base,def)
  - BaseC.lvl Concentricity/TransportObject.lean:54 (old-total,def)
  - ASection.anchor Concentricity/ConcentricityReadout.lean:139 (old-base,def)
  - *missing*: The base point exists on the new locked base only as defs (Point/Base/groupoid witness); every proved row about A-specific base points (anchor, NonSingular, Realizes) is typed over old-base or old-total. No proved row places a section datum at a GreatCircle.Point.
- **COVERED** — Object: world I in S^6
  - SphereWorld Concentricity/SliceSphereWorld.lean:194 (sphereworld,def)
  - Octonion.unitImaginarySphere Concentricity/Octonion.lean:142 (domain-H1,def)
  - Octonion.dir_mem_unitImaginarySphere Concentricity/Slice.lean:98 (domain-H1,proved)
  - Octonion.sphere_path Concentricity/LogManifold.lean:479 (domain-H1,proved)
- **COVERED** — Object: normalized section state
  - ASection.NormalizedSlicePoint Concentricity/NormalizedAction.lean:17 (sphereworld,def)
  - ASection.normalizedSectionPoint_mem_sliceSphere Concentricity/NormalizedBase.lean:101 (mixed,proved)
  - ASection.normalizedSectionObject_zero_value Concentricity/NormalizedAction.lean:71 (mixed,proved)
  - ASection.normalizedSectionPoint_equivariant Concentricity/NormalizedAction.lean:48 (mixed,proved)
- **COVERED** — Object: zero state Z_{n,I}
  - ASection.NormalizedZeroObject Concentricity/NormalizedBase.lean:28 (mixed,def)
  - ASection.normalizedZero Concentricity/NormalizedBase.lean:39 (mixed,def)
  - ASection.normalizedZeroPoint_mem_sliceSphere Concentricity/NormalizedBase.lean:83 (mixed,proved)
  - ASection.realize_sphereZero_pt Concentricity/PhiConversion.lean:467 (domain-H1,proved)
- **COVERED** — Object: pole/N state
  - ASection.realize_pole Concentricity/PhiConversion.lean:514 (domain-H1,proved)
  - ASection.pole_passage_level_atTop Concentricity/LogManifold.lean:845 (stem,proved)
  - riemannZeta_orderAt_one Concentricity/ZetaPole.lean:92 (zeta,proved)
  - BaseC.nPt Concentricity/TransportObject.lean:51 (old-total,def)
- **COVERED** — Object: Euler and Weierstrass presentations of the same state
  - ASection.c2_euler Concentricity/ASection.lean:90 (stem,def)
  - ASection.c3_factorization Concentricity/ASection.lean:184 (stem,def)
  - ASection.euler_assembly_tendsto Concentricity/KeystoneFinality.lean:58 (stem,proved)
  - ASection.weierstrass_assembly_tendsto Concentricity/KeystoneFinality.lean:71 (stem,proved)
- **PARTIAL** — Morphism: base PGL arrow
  - GreatCircle.Aut Concentricity/ProjectiveBase.lean:33 (locked-base,def)
  - GreatCircle.scalar_smul Concentricity/ProjectiveBase.lean:38 (locked-base,proved)
  - GreatCircle.mk_smul Concentricity/ProjectiveBase.lean:53 (locked-base,proved)
  - GreatCircle.instMulActionAutPoint Concentricity/ProjectiveBase.lean:47 (locked-base,def)
  - *missing*: PGL(2,R) arrows exist with proved scalar descent, but the base groupoid is a dead end: grep confirms no other file references GreatCircle.*. No functor out of it, no section transport typed over its arrows, no relation to Fstar/circleEmbed.
- **COVERED** — Morphism: G2 direction arrow
  - dirHom Concentricity/SliceSphereWorld.lean:253 (sphereworld,def)
  - S2.directionHom_mul Concentricity/TwoWorlds.lean:109 (domain-H1,proved)
  - ASection.worldRot_comp Concentricity/AFunctor.lean:68 (sphereworld,proved)
  - G2.exists_smul_eq_of_mem_unitImaginarySphere Concentricity/G2.lean:194 (domain-H1,proved)
- **COVERED** — Morphism: sphere Moebius arrow
  - Moebius Concentricity/SliceSphereWorld.lean:92 (carrier,def)
  - Moebius.of_apply Concentricity/SliceSphereWorld.lean:99 (carrier,proved)
  - mobHom Concentricity/SliceSphereWorld.lean:263 (sphereworld,def)
  - SphereHom Concentricity/SliceSphereWorld.lean:200 (sphereworld,def)
- **COVERED** — Morphism: U(1) phase path
  - bandMoebiusHom Concentricity/SliceSphereWorld.lean:167 (carrier,def)
  - bandEnd Concentricity/SliceSphereWorld.lean:272 (sphereworld,def)
  - bandGL_mul Concentricity/SliceSphereWorld.lean:158 (carrier,proved)
  - S2.exists_band_rotation Concentricity/PhiConversion.lean:218 (stem,proved)
- **ABSENT** — Morphism: C* diagonal path
  - bandGL Concentricity/SliceSphereWorld.lean:106 (carrier,def)
  - Octonion.level_tape_continuous Concentricity/LogManifold.lean:162 (domain-H1,proved)
  - sweepE5_level_readout Concentricity/SweepE5.lean:89 (stem,proved)
  - *missing*: No diag(lambda,1) arrow for lambda in C* anywhere (grep for a diagonal/scale GL row returns nothing; only the Circle-restricted bandGL exists). The phase component (U(1)) and the radial component (level tapes log-norm) both exist separately over safe frames, but the unified C*-diagonal path as a morphism is unbuilt.
- **COVERED** — Morphism: GPV domain/value/lift record
  - ASection.GpvTransport Concentricity/Recovery.lean:23 (carrier,def)
  - ASection.gpvBase_transport Concentricity/FaithfulApply.lean:122 (stem,proved)
  - ASection.gpvBase_transport_star Concentricity/ConnectedBase.lean:44 (carrier,proved)
  - ASection.GpvTransport.ofEulerHalfSpaceLoop Concentricity/Recovery.lean:50 (carrier,def)
- **COVERED** — Morphism: winding/holonomy
  - stemWinding Concentricity/SigmaE3.lean:79 (stem,def)
  - stemWinding_spec Concentricity/SigmaE3.lean:86 (stem,proved)
  - ASection.stemWinding_circle_sphereZero Concentricity/SigmaE3.lean:348 (stem,proved)
  - ASection.stemWinding_circle_pole Concentricity/SigmaE3.lean:895 (stem,proved)
- **PARTIAL** — Morphism: presentation-transition arrow
  - ASection.NormalizedNLeg Concentricity/NormalizedNLeg.lean:25 (mixed,def)
  - ASection.normalizedNLeg Concentricity/NormalizedNLeg.lean:38 (mixed,def)
  - ASection.GpvTransport.ofEulerHalfSpaceLoop Concentricity/Recovery.lean:50 (carrier,def)
  - ASection.stem_identity_logDeriv Concentricity/StemFactorization.lean:437 (stem,proved)
  - *missing*: The transition-tagged arrows that exist (NormalizedNLeg, W1/W2 loop constructors) are def-only, and NormalizedNLeg's target aliases BaseC.nPt (old-total). No explicit Euler<->Weierstrass presentation-transition morphism lives in any category; the underlying equality is proved but only as an analytic identity (item 27).
- **COVERED** — Morphism: identity, inverse, composition
  - instCategorySphereWorld Concentricity/SliceSphereWorld.lean:209 (sphereworld,def)
  - SphereHom.comp_rot Concentricity/SliceSphereWorld.lean:226 (sphereworld,proved)
  - ASection.GpvTransport.comp Concentricity/Recovery.lean:201 (carrier,def)
  - ASection.realizes_comp Concentricity/ConnectedBase.lean:145 (old-base,proved)
- **PARTIAL** — Structural map: base projection
  - ASection.gpvForget Concentricity/Recovery.lean:296 (old-base,def)
  - ASection.GpvPopulated.forget Concentricity/IntegrateTheorem.lean:343 (old-total,def)
  - H1.coordFunctor Concentricity/PhiConversion.lean:84 (domain-H1,def)
  - *missing*: Every explicit base-projection row is def-only and typed over old-base/old-total; the Grothendieck total-to-base forgetful exists only implicitly inside TotalA/TotalTransport (both old-total). No base projection targets the locked base.
- **COVERED** — Structural map: world projection
  - Octonion.dir Concentricity/Slice.lean:58 (domain-H1,def)
  - Octonion.dir_mem_unitImaginarySphere Concentricity/Slice.lean:98 (domain-H1,proved)
  - ASection.normalizedSectionObject_world Concentricity/NormalizedAction.lean:59 (mixed,proved)
  - ASection.normalizedZeroSlicePoint_world Concentricity/NormalizedAction.lean:62 (mixed,proved)
- **COVERED** — Structural map: section evaluation
  - ASection.realize Concentricity/Slice.lean:340 (domain-H1,def)
  - sectionFunctor Concentricity/TwoWorlds.lean:142 (domain-H1,def)
  - ASection.compactifiedSphereMap_val Concentricity/Recovery.lean:310 (sphereworld,proved)
  - ASection.Fstar_coe Concentricity/ConnectedBase.lean:32 (carrier,proved)
- **PARTIAL** — Structural map: normalization
  - ASection.normalizedFootpoint Concentricity/NormalizedBase.lean:22 (old-total,def)
  - ASection.normalizedZero_footpoint Concentricity/NormalizedBase.lean:54 (mixed,proved)
  - ASection.NormalizedCircleBase Concentricity/NormalizedBase.lean:19 (old-total,def)
  - ASection.normalizedZeroLift_re Concentricity/NormalizedBase.lean:92 (mixed,proved)
  - *missing*: Normalization's label side is proved (label retained in every world), but its codomain is NormalizedCircleBase := BaseC — a def-alias of the old-total base. The map itself is def-only and contaminated by that alias; a one-line retarget to the base of record clears it.
- **COVERED** — Structural map: compactified value map
  - ASection.Fstar Concentricity/ConnectedBase.lean:26 (carrier,def)
  - ASection.Fstar_coe Concentricity/ConnectedBase.lean:32 (carrier,proved)
  - zetaC_zero_iff Concentricity/ZetaCstar.lean:66 (carrier,proved)
  - ASection.circleEmbed Concentricity/ConnectedBase.lean:73 (carrier,def)
- **COVERED** — Structural map: exponential lift map
  - exists_log_continuation Concentricity/Toolkit.lean:274 (stem,proved)
  - Octonion.Llog_Eexp Concentricity/LogManifold.lean:384 (domain-H1,proved)
  - Octonion.lift_iff_continuation Concentricity/LogManifold.lean:704 (domain-H1,proved)
  - lift_ladder Concentricity/InboxWire.lean:73 (stem,proved)
- **PARTIAL** — Structural map: real-center readout
  - Octonion.exp_fibre_concentric Concentricity/WeldW3.lean:377 (domain-H1,proved)
  - ASection.concentricity_iff_infLevel_eq_supLevel Concentricity/KernelE4.lean:294 (stem,proved)
  - ASection.zero_levels_common Concentricity/ConcentricityReadout.lean:243 (stem,sorried)
  - ASection.readout Concentricity/AFunctor.lean:149 (old-total,def)
  - *missing*: The level machinery (level = log r fibre rows, KernelE4 iff-nodes, sup/inf apparatus) is fully proved over stem/domain-H1, but the theorem-closing readout rows are the repository's sorries (zero_levels_common, totalA_pi0_singleton, concentricity_via_weldW3, transportLevel_const_via_finality) and the pi0 readout equivalence (ASection.readout) is typed over old-total. ASection.concentricity (ConcentricityReadout.lean:269, proved) rests on the sorried zero_levels_common.
- **COVERED** — Structural map: zero-address map
  - ASection.sphereZero Concentricity/ASection.lean:115 (stem,def)
  - ASection.sphereZero_complete Concentricity/StemFactorization.lean:133 (stem,proved)
  - zetaSphereZero_range Concentricity/ZetaDivisor.lean:178 (zeta,proved)
  - ASection.zeroAddress Concentricity/ConcentricityReadout.lean:161 (mixed,def)
- **COVERED** — Diagram: G2 equivariance
  - ASection.realize_equivariant Concentricity/Slice.lean:436 (domain-H1,proved)
  - zetaO_equivariant Concentricity/ZetaOctonion.lean:110 (domain-H1,proved)
  - ASection.normalizedSectionPoint_equivariant Concentricity/NormalizedAction.lean:48 (mixed,proved)
  - G2.smul_sliceEmbed Concentricity/Slice.lean:312 (domain-H1,proved)
- **COVERED** — Diagram: slice preservation
  - ASection.realize_mem_sliceSphere Concentricity/Slice.lean:371 (domain-H1,proved)
  - zetaO_mem_sliceSphere Concentricity/ZetaOctonion.lean:262 (domain-H1,proved)
  - riemannZeta_intrinsic Concentricity/ZetaConj.lean:125 (zeta,proved)
  - ASection.normalizedSectionPoint_mem_sliceSphere Concentricity/NormalizedBase.lean:101 (mixed,proved)
- **ABSENT** — Diagram: base/sphere Moebius compatibility
  - GreatCircle.mk_smul Concentricity/ProjectiveBase.lean:53 (locked-base,proved)
  - Moebius.of_apply Concentricity/SliceSphereWorld.lean:99 (carrier,proved)
  - ASection.circleEmbed Concentricity/ConnectedBase.lean:73 (carrier,def)
  - *missing*: No row relates a PGL(2,R) base arrow to a sphere Moebius arrow — no square through circleEmbed, no restriction/extension map PGL(2,R) -> Moebius, no statement that the base circle's Moebius action is the sphere Moebius action restricted to R union {N}. Both sides exist separately; the compatibility diagram is entirely unbuilt.
- **COVERED** — Diagram: Euler/Weierstrass equality on overlap
  - ASection.stem_identity_logDeriv Concentricity/StemFactorization.lean:437 (stem,proved)
  - ASection.circleIntegral_pairing_halfSpace Concentricity/PairingE2.lean:665 (stem,proved)
  - xi_orderAt_eq_zetaProd_orderAt Concentricity/ZetaXiMatch.lean:575 (zeta,proved)
  - zeta_hadamard Concentricity/ZetaAssembly.lean:164 (zeta,proved)
- **COVERED** — Diagram: pole/inverse-chart compatibility at N
  - ASection.pole_cone_chart Concentricity/LoopAssembly.lean:199 (stem,proved)
  - ASection.pole_cone_eps_delta Concentricity/LoopAssembly.lean:207 (stem,proved)
  - inv_re_bridge Concentricity/StemFactorization.lean:425 (generic,proved)
  - ASection.level_circle_meets Concentricity/LogManifold.lean:1098 (mixed,proved)
- **COVERED** — Diagram: exp(lift)=value
  - Octonion.pr1_Eexp Concentricity/LogManifold.lean:364 (domain-H1,proved)
  - Octonion.exp_Llog Concentricity/LogManifold.lean:407 (domain-H1,proved)
  - ASection.gpvBase_transport Concentricity/FaithfulApply.lean:122 (stem,proved)
  - Octonion.level_eq_log_norm_exp Concentricity/LogManifold.lean:176 (domain-H1,proved)
- **PARTIAL** — Diagram: center naturality
  - Octonion.exp_fibre_concentric Concentricity/WeldW3.lean:377 (domain-H1,proved)
  - ASection.normalizedZero_label_world_independent Concentricity/NormalizedBase.lean:59 (sphereworld,proved)
  - ASection.NormalizedZeroCone.zero_levels_common Concentricity/NormalizedCone.lean:36 (generic,proved)
  - ASection.realizes_value_eq Concentricity/ConcentricityReadout.lean:83 (old-base,proved)
  - *missing*: Unconditional center-conservation is proved on fibres (exp_fibre_concentric), worlds (label world-independence), and modulus reads (zigzag_modulus/zigzag_coordRead). But naturality on A's actual transport arrows is either CONDITIONAL — NormalizedZeroCone takes label_transport as a hypothesis field and no cone instance is constructed — or typed over old objects (realizes_value_eq old-base, value_const_on_component mixed over TotalA). Constructing the cone instance is exactly the remaining functor-build target.
- **COVERED** — Diagram: identity/composition compatibility
  - ASection.worldRot_one Concentricity/AFunctor.lean:59 (sphereworld,proved)
  - ASection.worldRot_comp Concentricity/AFunctor.lean:68 (sphereworld,proved)
  - S2.directionHom_one Concentricity/TwoWorlds.lean:96 (domain-H1,proved)
  - S2.directionHom_mul Concentricity/TwoWorlds.lean:109 (domain-H1,proved)

*(Critic's precision adopted on two 'COVERED' calls: the normalized-section-state object
is THIN — `NormalizedSlicePoint` is a generic (world, point) pair, not an A-distinguished
state; and 'world projection' rows exist under other filings (`Octonion.dir`). Both feed
the fibre-object ruling.)*

## §4 The four statements of the unique functor, mapped

Per the characterization strategy (the author + Codex, 2026-07-12): the functor is to be
FORCED by commuting diagrams; existence and uniqueness proved; laws by uniqueness.

**(1) Existence on objects** (A.obj = evaluation/normalization): evaluation machinery is
rich and safe (MAP-eval 29 rows — `realize`, `F`, `Fstar` with the named pole repair;
equivariance certified). The gap is the fibre-OBJECT type itself: the A-distinguished
normalized state (critic: current OBJ-state is one generic pair). This is the 0.3
fibre-object ruling, now with its exact inventory context.

**(2) Existence on morphisms** (A.map on the channels): fibre-side transports exist in
force (MOR-gpv 36 rows incl. W1/W2 constructors and id/inv/comp laws; MOR-g2 27;
MOR-u1 15). The two ABSENT cells are exactly the base-to-fibre channel squares — the
E1 builds (rotation square; dilation/diag square) plus the `diagGL` torus extension.
Nothing else is missing at this statement.

**(3) Uniqueness on morphisms**: the canonicity cluster is CERTIFIED in the ledger
(`winding_lift_unique`, `stemWinding_eq_of_lift`, `exists_log_continuation`, the
triangle field) and the sweep adds `stemWinding_eq_of_homotopy` (proved) — the homotopy
leg. The one open analytic leg remains GAP-1 (Cor 5.13's signature criterion), consumed
only if a relation check needs loop-closure.

**(4) Preservation of the real-center readout**: the generic theorem EXISTS AND IS
PROVED (`NormalizedZeroCone` + its two consequences, §0.2). `label_transport` is a
hypothesis field awaiting the honest instance; the label itself is definitional
(`normalizedZero_label`, rfl). DIAG-center holds 18 rows, MAP-readout 86. The r-register
ruling (center as the natural datum, level as transport evidence — P-1) types the
instance.

## §5 Contamination (the coverage synthesizer's summary, adopted)

Contamination is concentrated in three row families, all base/total-object wiring rather than analytic content. (1) old-base — the ConnectedBase winding groupoid: ASection.Base/NonSingular/Realizes, realizes_id/inv/comp, instGroupoidBase, plus Recovery's groupoid packaging of the GPV records (GpvBase, GpvRealizes, instGroupoidGpvBase, gpvForget, realizes_gpv_lift) and ConcentricityReadout's realizes_of_value_eq/realizes_value_eq/anchor. The GpvTransport record itself is clean (carrier/stem); only its groupoid host is old. (2) old-total — the BaseC/TotalTransport family (nPt, lvl, preorder, bandFunctorC, nObj, toNHom, all zigzag/class/witness/transportClass rows including concentricity_transport, transport_universal, and IntegrateTheorem's gpv engine rows), the static Base.lean family (Base, bandFunctor, TotalObject, level, levelClass), and AFunctor's functorA/TotalA/readout — the pi0 readout equivalence itself is typed over this frame. (3) alias leakage into the new layer: NormalizedCircleBase := BaseC and normalizedFootpoint (old-total), and NormalizedNLeg.target = BaseC.nPt — the otherwise-safe Normalized* files are welded to the old total object at exactly these two points. By contrast the stem, domain-H1, carrier, sphereworld, zeta, and generic families (roughly 85% of proved rows, including the entire winding/lift/level engine, all equivariance and slice-preservation diagrams, and the full zeta instantiation) are typed over safe objects. The locked-base family (ProjectiveBase) is clean but orphaned — no other file references it.

## §6 Critic corrections and housekeeping (adopted into this report)

- stemWinding | Concentricity/SigmaE3.lean:79 — filed MAP-lift, but the def IS the winding/holonomy datum (docstring: 'This is the omega of GPVwind Cor 5.21 on the stem'; defined via the lift defect k*2*pi*i). Its own spec/uniqueness rows (stemWinding_spec :86, stemWinding_eq_of_lift :98) are filed MOR-winding; the definition row should be MOR-winding too.
- SliceWorld.Gen | Concentricity/TwoWorlds.lean:43 — filed MOR-mobius, but verified against the file: the inductive has exactly three constructors — direction (g : G2) (a G2 direction arrow), band, and bandInfty (U(1) phase arrows). There is NO Moebius constructor; the sphere Moebius arrows live only in SliceSphereWorld.SphereHom. Frame should be MOR-g2/MOR-u1, and filing it MOR-mobius overstates Moebius coverage in TwoWorlds' S2.
- ASection.NormalizedNLeg.target | Concentricity/NormalizedNLeg.lean:20 and normalizedNLeg_target_is_N | :46 — typed_over 'carrier', but target := BaseC.nPt and NormalizedCircleBase := BaseC; every other BaseC row (TransportObject.lean:40/51/54, NormalizedBase.lean:19) is typed old-total. Inconsistent typed_over; should be old-total.
- ASection.GpvTransport.ofEulerHalfSpaceLoop | Concentricity/Recovery.lean:50 and ofLeftRegionLoop | :99 — filed MOR-transition, but verified in the file they are constructors of GpvTransport A sigma sigma 0 (W1/W2 winding-zero welds at a single circle point), not presentation-transition arrows. The parent structure GpvTransport (:23) is MOR-gpv and id/inv/comp are MOR-laws; these two belong with MOR-gpv. Their MOR-transition tag masks the real zero-row status of the checklist's presentation-transition arrow.
- ASection.neg_reals_swept_near_sphereZero | Concentricity/LoopAssembly.lean:225 and shared_ladder_encounters | :271 — filed MOR-transition, but both are pure existence/analytic statements (for-all-eps exists r, exists z with A.F z = -r); they are not arrows of any category. ANALYTIC-SUPPORT (or MAP-eval) is the honest frame; same masking effect as above.
- Octonion.exp_fibre_sphere_connected | Concentricity/LogManifold.lean:558 — filed OBJ-world, but verified in the file it asserts the existence of a continuous PATH p : C(unitInterval, Octonion) inside the exp-fibre over -r joining two directions; it is fibre-connectivity feeding the centre readout (MAP-lift or DIAG-center), not an object row. Octonion.direction_path_to_neg (WeldW3.lean:147, also filed OBJ-world) has the same shape — a path datum, not an object.
- ASection.GpvTransport.id | Concentricity/Recovery.lean:144 typed 'mixed' while GpvTransport.inv (:170) and .comp (:201) are typed 'carrier' — the three are the same structure family over OnePoint R / OnePoint C; the typed_over should agree (carrier).

Housekeeping: `Basic.lean` carries only the dead scaffold `def hello := "world"`
(attic candidate). `RecoveryAudit.lean` #checks reference `ASection.ofEulerHalfSpaceLoop`
naming that may have drifted from `ASection.GpvTransport.*` — confirm it still
elaborates. Four trivial `inferInstance` Category wrappers were skipped by the sweep
(AFunctor.lean:140, TransportObject.lean:87, Base.lean:44/:63) — noted for completeness.

## §7 Reproduction

Workflow run `wf_e17c633e-830` (15 agents; journal in the session transcript dir);
full row set: `AERIAL_ROWS.tsv`. Re-verification of any row: read the cited file:line;
tier claims: extend `_ledger_audit.lean` and run `lake env lean _ledger_audit.lean`.
