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

# PHASE 1 ACTION TABLE v2 — the four levels of A, certified supply per cell

**AUDIT REQUEST — check against ALIGNMENT points 20–23.**

**Prepared by:** Fable (kernel/greps, Desktop tree — canonical), 2026-07-15. **v2, second
pass** (the author's deepening request): ~350 declarations surveyed across WeldW12/W3/W4,
SigmaE3, Toolkit, LoopAssembly, IntegrateTheorem, SynthesisE6, KernelE4, PairingE2,
SweepE5, LogManifold, PhiConversion, FaithfulApply, StemFactorization, TwoWorlds,
LiKernel, plus the N-dossier net. Supersedes v1 in place.
**Instruction of record (Codex phase plan, corrected 2026-07-15; the author):** Phase 1
runs backwards (total-object typing) and forwards (C1–C4/W1–W4/VT) in tandem, testing
candidate shapes, the distinguished family informing all four action levels; it ends with
exact candidates for `A.obj b`, `(A.map f).obj x`, `(A.map f).map α`, `A.map_id`,
`A.map_comp`, every piece linked to certified declarations, expected Lean types written.
**Register:** dependency reconstruction; DESIGN-INPUT cells are the author's; C1–C4 are
sufficient conditions — the construction selects from this supply.
**Census note (kernel-anchored):** live sorried declarations on disk = 4 (two in the old
ConcentricityReadout chain, the WeldW3 route receipt, the KeystoneFinality orphan).
Agent-pass claims of sorries in LiKernel/PhiConversion/TwoWorlds/WeldW4 were stale
docstring prose — token-level check + `_ledger_audit` refute them; `liSum_summable` is
CLOSED (LiKernel:324).

---

## §0 The backwards typing constraint (𝒯_A as guide, not yet construction)

Total object `(b, x)`, `x ∈ A(b)`; total morphism `(f, φ)`, `f : b ⟶ b′`,
`φ : (A.map f).obj x ⟶ x′` in `A(b′)`. A base arrow of `𝓑 = ActionCategory PGL(2,ℝ)
(OnePoint ℝ)` is a group element with its transport equation, so `A.map` is total on the
GROUP (both components); `map_id`/`map_comp` reduce to the group law + coherence.
Endpoints: `pi0_grothendieck` (Theorem.lean:144, `[SmallCategory B]`, `Grpd.{u,u}`),
`pi0GrothendieckEquiv` (:108), `toColimitObj(_eq_of_hom/_eq_of_zigzag)` (:68/:77/:92);
the generic singleton tail (certified standalone twice; to land in-repo).

---

## ROW 1 — `b ↦ A(b)`: the fibre groupoid

**Required output:** `A.obj b : Grpd` per `b : OnePoint ℝ`; objects = normalized value
states over b; populated at zero footpoints (C4); N-fibre included.

**States (certified):**
- `NormalizedZeroObject` (NormalizedBase:28): `index`, `world : SphereWorld`,
  `footpoint`, `label : ℝ`, `footpoint_label`, `label_zero : label = (sphereZero index).re`.
- `NormalizedSlicePoint` (NormalizedAction:17): `Σ I : SphereWorld, ↥(sliceSphere I.val)`;
  `normalizedZeroSlicePoint` (:28) places each zero in it; `normalizedSectionObject`
  (:23) — the section's own action, world-preserving (simp).
- Divisor honesty both ways: `stem_zero_of_sphereZero` (StemFactorization:67 — every
  enumerated sphere-zero IS a stem zero) and `sphereZero_complete` (:133 — every
  upper-half stem zero IS enumerated). The population is exactly the divisor.
- Local structure at each zero: `stem_local_form` (:549 — `(z−a)^N · G`, G analytic
  nonvanishing, N = fibre tally); `ledger_orderAt_zero`/`ledger_residueAt_zero`
  (:813/:826 — logDeriv has order −1, residue = multiplicity, at every enumerated zero).
- N-fibre data: `valueAtInfinity` + `valueAtInfinity_real` (ASection:196/:201);
  `Fstar_infty` (ConnectedBase:29); `realize_infty` (Slice:360);
  `normalizedZero_collapse_at_N` (NormalizedBase:157).

**Fibre-internal morphisms — the structural fact: G₂/direction legs are VERTICAL.**
`G2.smul_ofReal` (G2:87) + `G2.smul_onePoint_infty` (G2:317, `rfl`) fix every real point
and N, so direction morphisms move the WORLD, not the footpoint:
- `dirHom`/`dirHomTo`, `mobHom`/`bandHomAt`/`bandEnd` (SliceSphereWorld:253–:281);
- `sphereWorld_zigzag` (:288) — any two worlds joined by ONE direction morphism;
- `normalizedZero_label_world_independent` (NormalizedBase:59, `rfl`) — the label is
  constant along vertical arrows;
- fibre-connectivity through the degenerate fibre itself: `exp_fibre_sphere_connected`
  (LogManifold:558 — any two directions joined THROUGH the fibre, level constant log r)
  and `exp_fibre_conj_joined` (:587 — the stem-conjugate pair, disconnected over ℂ,
  JOINED over 𝕆 — the ℂ/𝕆 difference at fibre level);
- `sphere_path` (LogManifold:479 — S⁶ path-connected on the repo's own type; the
  GreatCircleRoute survivor).

**CAUTION ROW (certified honesty constraint for DESIGN-INPUT 4):**
`level_not_invariant` (PhiConversion:405) — in the OLD points-as-objects world with full
band arrows, the raw level (Re of the point) is NOT conserved by all arrows; only the
modulus is (`zigzag_iff_modulus` :294; `componentsEquiv : π₀(S2) ≃ OnePoint NNReal`
:384). The conserved datum of the locked design is therefore NOT a raw pointwise Re — it
is the normalized state's `label` (pinned to `(sphereZero n).re`, world-blind by `rfl`).
Any candidate fibre whose arrows include full band orbits between points must carry the
label as state data, not read it off the point. (These PhiConversion/TwoWorlds rows are
the OLD Φ/S2 register — see §7.)

**DESIGN-INPUT (the author):** the states over general (non-zero, non-N) footpoints
(candidates: `normalizedSectionPoint`, the C2 Euler-side data); whether the fibre
morphism type carries GPV cargo beside the SphereHom legs.

---

## ROW 2 — `x ↦ (A.map f).obj x`: the transported state

**Base motion:** `instMulActionAutPoint`/`mk_smul` (ProjectiveBase:47/:53);
`OnePoint.smul_infty_eq_ite` (pin) — N moves under general channels.

**Value/level content along the channel — the workhorse:** `gpvBase_transport`
(FaithfulApply:122, PROVED) — for EVERY pole-avoiding, zero-free domain path the section
hands the base the full GPV package: (a) continuation Γ exists; (b) level tape
`(Γ t).re = log |F(δ t)|`; (c) tape CONTINUOUS through degenerate passages; (d) lift
UNIQUE through its basepoint; (e) level LIFT-INDEPENDENT. Plus `GpvTransport` +
`realizes_gpv_lift` (Recovery:23/:319), `exists_log_continuation`/`winding_lift_unique`
(Toolkit:274/:301), `sweepE5_lift_level_tape` (SweepE5:100).

**Degenerate/real-crossing channels (where zero-freeness fails on the path):**
`great_circle_value_degenerate` (FaithfulApply:173 — negative great-circle values ARE
degenerate values), `great_circle_lift_through_degenerate` (:198 — continuous lift
THROUGH the degenerate set, one rung per lift, level = log|F|),
`great_circle_passage_total` (:274 — the passage carries the full ladder: existence +
rigidity), `real_segment_lift_neg`/`_pos` (LogManifold:259/:288).

**Through N (the junction):** `stemWinding_circle_pole` (SigmaE3:895);
`normalizedZero_pole_winding`/`_power_closes` (NormalizedPoleBridge:18/:48);
`zero_pole_pair_winding`/`zero_pole_pair_closes_through_witness` (SynthesisE6:197/:228);
`cone_tape_escape`/`cone_junction_levels_shared` (IntegrateTheorem:103/:167); the
pole-cone trio `pole_cone_tendsto`/`_chart`/`_eps_delta` (LoopAssembly:189/:198/:207);
`pole_encounters_joined_concentric` (FaithfulApply:354); LogManifold's
`pole_passage_level_atTop`/`pole_passage_manifold_data`.

**Named obligations:** the `Fstar` pole repair (pole ↦ ∞ — note `realize_pole`,
PhiConversion:514, already proves realize at p₀ = ∞ on the 𝕆* register); the
Recovery/NormalizedBase endpoint retyping (first mechanical tasks).

**DESIGN-INPUT:** whether the transported state's world datum is unchanged or rotated
(point 6/18: base channels are PGL, never identified with G₂).

---

## ROW 3 — `α ↦ (A.map f).map α`: the transported fibre morphism

**Constraint rows:** `G2.smul_sliceEmbed` (Slice:312), `realize_equivariant` (:436),
`bandGL_mul`/`bandMoebiusHom`, `SphereHom.comp_*`/`id_*` (SliceSphereWorld:226–:234),
`winding_lift_unique` (transported composites close by uniqueness, not computation).

**The E⁺ manifold engine (VS Props 4.1–5.4, all PROVED in LogManifold):** `Eexp` (:351),
`logManifold` (:357), `Llog` (:375), `Llog_Eexp` = id (:384), `Eexp_Llog` = id on the
manifold (:397), `pr1_Eexp` — the commuting triangle π∘E = exp (:364), `re_Llog_of_mem`
— the level component of L (:418), `lift_iff_continuation` (:704 — GPV Prop 4.2 BOTH
directions: lift ⟺ continuation), `IsLoopLift` + `level_periodic` (:729/:750 — the
cover lift's LEVEL is itself a loop, 2π-periodic even when the lift winds). This is the
certified machinery by which the θ-leg's phase data and the level data live on one
manifold with the level always readable.

**Fibre-morphism value laws:** `winding_loop_defect_level_zero` (LoopAssembly:107 —
level closes on EVERY closed loop, unconditionally), `lift_level_unique`/
`lift_loop_level_closes` (LogManifold:216/:231 — octonionic register),
`zero_encounters_joined_concentric` (FaithfulApply:328 — the two spheres' encounters
joined INSIDE one fibre with level CONSTANT along the join).

**Scoped-naturality cautions stand** (ALIGNMENT point 8): U(1) not central in Möbius;
`bandEnd` copies auto-cohere only along pure-G₂ legs. The θ-leg acts here; odd-π values
touch the degenerate fibre (`exp_kernel_unit_imaginary`, WeldW3:391;
`degenerate_sphere_mem`/`logManifold_fibre_neg_real`/`degenerate_level_readout`,
LogManifold:428/:446/:466 — the fibre is S⁶ × ℤ with one level).
**DESIGN-INPUT:** which fibre arrows the transport must move; `liftPhase`'s nature
(point-12 μ(t) triangle, TO-DERIVE).

---

## ROW 4 — `f·g ↦ coherent composition` (and `map_id`)

**Base side:** the group law (`mul_smul`, `mk_smul`).

**The winding calculus (complete, SigmaE3 §A):** `stemWinding_mul` (:153 —
multiplicativity, "the integration-free argument-principle engine"), `_pow` (:175),
`_inv` (:197), `_const` (:139), `_eq_zero_iff` (:119 — Cor 5.13's closure iff),
`_eq_zero_of_slitPlane` (:213), `_eq_zero_of_near_const` (:229 — the Rouché row),
`stemWinding_finset_prod` (WeldW12:599), `stemWinding_eq_of_homotopy` (WeldW12:358 —
representative-path independence). `GpvTransport.id`/`.inv`/`.comp`
(Recovery:144/:170/:201). `bandEnd` monoid laws. σ-closure: `winding_loop_closed`
(LoopAssembly:92 — one lift closes ⟹ all close), `winding_defect_lift_independent` (:59).

**Composites through N:** `normalizedZero_pole_power_closes`;
`two_center_winding_onto_one_band` (WeldW4:165); `zero_pole_pair_closes_through_witness`
(SynthesisE6:228).

**The counting layer (W1/W2's class-wide rows, WeldW12 tail):**
`stemWinding_rectLoop_sub_interior` (:855 — boundary winds once per interior point),
`stemWinding_F_rectLoop` (:1001 — winding = trapped count), `stemWinding_F_stripRect`
(:1158 — the strip N(T) row, heights isolated), `stemWinding_F_leftRegion` (:1191),
`counting_pair_of_two_levels` (:1230), `trapped_counts_additive` (:1370),
`exists_rect_head_finset` (:958). Zero-winding identity representatives:
`ofEulerHalfSpaceLoop`/`ofLeftRegionLoop` (Recovery:50/:99),
`stemWinding_F_halfSpace` (WeldW12:238).

---

## §5 THE N-DOSSIER — the three registers, kept strictly separate (ALIGNMENT point 10)

**(i) The pole p₀** — `A.pole : ℝ` (ASection:63), order −1 (`c1_simple` :70). Behavior:
`eventually_ne_zero_near_pole` (IntegrateTheorem:76), the cone trio (LoopAssembly),
`cone_tape_escape`, `stemWinding_circle_pole` (−1), `pole_le_upperEdge` (PairingE2:81 —
the pole sits at or left of the Euler edge), `ne_pole_of_re_gt` (:170),
`no_finite_zero_accumulation` (KernelE4:362 — zeros accumulate only at N),
`supLevel_attained_or_escape` (KernelE4:459 — attained ∨ escape to ∞),
`realize_pole` (PhiConversion:514 — realize(p₀) = ∞ on 𝕆*).

**(ii) The base compactified point 𝔫** — `OnePoint.infty : OnePoint ℝ` (old carrier
`BaseC.nPt`, TransportObject:51; retypes to `GreatCircle.Point`'s ∞). `circleEmbed`
(ConnectedBase:73) sends it to ∞ of ℂ*; `NormalizedNLeg.target` (NormalizedNLeg:20).

**(iii) The value register** — `valueAtInfinity : OnePoint ℂ` (+ real-when-finite,
ASection:196/:201), `Fstar_infty` (ConnectedBase:29, `rfl`), `realize_infty` (Slice:360),
`G2.smul_onePoint_infty` (G2:317).

**The NonSingular guard, verbatim (ConnectedBase:77):**
`NonSingular σ := Fstar(circleEmbed σ) ≠ ∞ ∧ Fstar(circleEmbed σ) ≠ 0`.
`Base := {σ // NonSingular σ}` (:83); `Realizes` (:88); `realizes_id` (:98 — the
identity as the constant value-path + constant log-lift, EXISTS only at nonsingular σ).

**Therefore the "N-fibre identity" obligation decomposes into THREE typed cases:**
1. **identity at p₀** (value = ∞): supply = the cone trio + `stemWinding_circle_pole`
   (−1) + `pole_encounters_joined_concentric`;
2. **identity at zero footpoints** (value = 0): supply = `stemWinding_circle_sphereZero`
   (winding = fibre tally, SigmaE3:348), `no_closed_lift_around_sphereZero` (:983), the
   power-closure `normalizedZero_pole_power_closes`, `zero_encounters_joined_concentric`;
3. **identity at base-𝔫**: `Fstar(∞) = valueAtInfinity`; NonSingular there IFF
   `valueAtInfinity ∉ {0, ∞}` — a typed, checkable condition; if it holds, the existing
   `realizes_id` shape already applies.

**The assembled enriched-arrow record (the fullest fibre-morphism field inventory on
disk):** `GpvTransportWitness` (IntegrateTheorem:270 — witness + `gpv_base` +
`sphere_passages` + `passage_band` + `cone_escape` + `cone_passages` +
`fibre_concentric`), `gpvPopulated` (:323 — EVERY A-section carries one at every zero),
`GpvZigzag` (:373), `gpv_zigzag_readout` (:402 — one class ∧ shared −r at every scale ∧
shared levels both sides of the pole). Typed on old carriers — repointing column; as a
FIELD INVENTORY it is Phase-1 input of the first rank.

---

## §6 The two-channel weld (C2 = C3 on the overlap) — the same-stem engine

`logDeriv_euler` (StemFactorization:178 — the Euler channel's log-derivative on Ω₀),
`logDeriv_weierstrass` (:252 — the Weierstrass channel's, away from pole/origin/zeros),
`stem_identity_logDeriv` (:437 — Euler = Weierstrass on the overlap, by the identity
theorem `stem_identity`, Toolkit:246), `ledger_meromorphic` (:454),
`circleIntegral_pairing_halfSpace` (PairingE2:665 — the Euler expansion against the
Weierstrass expansion under one contour). This is the certified content of "C2/C3 are
two exponential expressions of the one stem" — the seam data for any candidate that
builds Euler-side and Weierstrass-side transports separately and welds them.

**Brick-2 (LiKernel, D0–D3 CLOSED):** `liKernel`/`liSum`/`liRatio` (:42/:52/:77),
`normSq_anchor_sub_mirror` (:110), mirror-line rows (:120–:165), simultaneous return
(:183), `liSum_summable` (:324). Downstream/corollary-adjacent; not on Phase-1's
critical path; listed for completeness.

---

## §7 Register cautions (the naming alarm, handled)

- **TWO sphere-world-like objects exist on disk.** The LOCKED fibre geometry is
  `SphereWorld` (SliceSphereWorld.lean — S⁶ directions, `SphereHom` = rot + mob). The
  OLD Φ register is `SliceWorld := OnePoint Octonion` + `Gen` + `S2` (quotient path
  category) + `sectionFunctor : H1 ⥤ S2` (TwoWorlds.lean, PhiConversion.lean). The old
  register is import-clean but SUPERSEDED as architecture (ALIGNMENT point 14: audit
  candidates, never automatic ingredients; H1/Φ are not the base of A). Its
  TRANSFERABLE CARGO: `exists_band_rotation` (PhiConversion:218), the modulus-conservation
  rows, `componentsEquiv` (π₀(S2) ≃ OnePoint NNReal), `level_not_invariant` (the Row-1
  caution), `phi_glue`/`phi_collapse_proper` (the collapse facts that killed the old
  register — preserved as honesty rows), `realize_pole`.
- **GreatCircleRoute survivors:** `sphere_path` lives at LogManifold:479;
  `sliceSphere_inter` and `greatCircle_eq_fixedLocus` are NOT in the active tree
  (deleted with the file; archived in .attic_old_bases). If the F5/F6 dictionary or the
  base placement wants the great-circle geometry rows, they are re-derived or recovered
  from the attic — the author's call, flagged.

---

## §8 Phase-1 exit checklist (unchanged from v1)

| Deliverable | Expected shell | Verify live at typing |
|---|---|---|
| `A.obj b` | `GreatCircle.Base → Grpd`; per-b fibre groupoid of normalized states | `Grpd.of`, universes; ActionCategory carrier |
| `(A.map f).obj x` | fibre functor object action per base hom | ActionCategory hom shape |
| `(A.map f).map α` | fibre functor morphism action | — |
| `A.map_id` | `A.map (𝟙 b) = 𝟙 (A.obj b)` | Grpd hom = functor; equality register |
| `A.map_comp` | `A.map (f ≫ g) = A.map f ≫ A.map g` | same |

Expected `#print axioms` for every consumed supply row: `[propext, Classical.choice,
Quot.sound]`. The two retyping obligations precede candidate testing. No candidate is
named the section functor before the author ratifies the winner.

---

## §9 Pin verification (Fable, 2026-07-15 — the "verify live at typing" items, done now)

Verified verbatim against the pinned Mathlib (`.lake/packages/mathlib`):

- **`ActionCategory := (actionAsFunctor M X).Elements`** (CategoryTheory/Action.lean).
  A hom `p ⟶ q` is a subtype: a group element `.val` with the transport equation.
  `ActionCategory.id_val : (𝟙 x).val = 1`;
  **`comp_val : (f ≫ g).val = g.val * f.val`** — NOTE THE ORDER (g·f): any curried
  assignment defining `A.map` from group elements must respect this multiplication
  order in `map_comp`.
- **`homOfPair (t : X) (g : G) : (g⁻¹ • t) ⟶ t`** with `homOfPair.val = g`, and
  **`ActionCategory.cases`** — every morphism in the action groupoid IS a `homOfPair`:
  the pin's own induction principle, tailor-made for defining `A.map` by
  (target, group element) and discharging well-definedness and the laws.
- **`curry : (ActionCategory G X ⥤ SingleObj H) → (G →* (X → H) ⋊ G)`** — the pin's
  own statement that functors OUT of an action groupoid are curried semidirect-product
  data (reference shape; our codomain is Grpd, not SingleObj H — cited as intuition,
  not consumed).
- **`instance [IsPretransitive M X] [Nonempty X] : IsConnected (ActionCategory M X)`**
  — the F9 instance, in the pin (never a hypothesis of the theorem; noted per point 19).
- **`endMulEquivSubgroup`** — vertex groups ≃ stabilizer subgroups (End at a point).
- **`mulActionOfGL` (Projective.lean:85) + `mk_smul` (:93)** — verbatim as consumed by
  ProjectiveBase.lean.
- **`signDet : PGL(n, R) →* SignTypeˣ`** (Projective.lean:101, under
  `[Fact (Even (Fintype.card n))]` — satisfied at n = Fin 2): **the pin's own detector
  of PGL(2,ℝ)'s two components** (sign of determinant, well-defined on the projective
  group). The typed handle for the second-component/reflection channel (Row 4/§6 of
  INVENTORY; the crossing/flip register's base-side label).
- **`Grpd := Bundled Groupoid.{v, u}`; `Grpd.of (C : Type u) [Groupoid.{v} C] :
  Grpd.{v, u}`; `forgetToCat : Grpd.{v, u} ⥤ Cat.{v, u}`**
  (CategoryTheory/Groupoid/Grpd/Basic.lean:38/:54/:77).
- **Expected universe resolution — clean at u = 0:** `OnePoint ℝ : Type 0`,
  `PGL(2, ℝ) : Type 0`, so `GreatCircle.Base : Type 0` with `SmallCategory` holding;
  the state candidates (`NormalizedZeroObject`, `NormalizedSlicePoint`, `SphereWorld`)
  all live in `Type 0`, so fibres land in `Grpd.{0,0}` and `pi0_grothendieck`
  instantiates at u = 0 with no lifting.
