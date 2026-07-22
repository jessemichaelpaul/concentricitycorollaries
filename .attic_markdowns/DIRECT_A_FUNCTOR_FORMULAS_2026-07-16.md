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

# DIRECT A-FUNCTOR FORMULAS — 2026-07-16

**AUDIT REQUEST — check against ALIGNMENT points 20–23.** Wherever older alignment
prose conflicts, `PROOF_OUTLINE_LOCKED.md` is the sole architectural record.

**Prepared by:** Fable, 2026-07-16, to the author's and Codex's joint specification:
five sections, one formula each, no new inventory, no alternative designs, no
total-object look-ahead beyond the required types. Scope = PROOF_OUTLINE_LOCKED §12,
build targets 1–4:

\[
\mathrm{C1\text{–}C4}\Longrightarrow A:\mathcal B\to\mathbf{Grpd},\qquad
\mathcal B = PGL(2,\mathbb R)\ltimes\operatorname{OnePoint}(\mathbb R).
\]

Every formula below is over declarations already on disk; the complete list of
missing items is in §5 and is short. None of the banned objects appears anywhere in
this artifact.

---

## 1. `A.obj b`

For `A : ASection`, `b : GreatCircle.Point`:

```lean
def sectionObj (A : ASection) (b : GreatCircle.Point) : Grpd :=
  Grpd.of ASection.NormalizedSlicePoint
```

where `ASection.NormalizedSlicePoint = Σ I : SphereWorld, ↥(Octonion.sliceSphere I.val)`
(NormalizedAction.lean:17 — on disk, certified) is made a groupoid by the **one
smallest missing definition**,

```lean
def spherePointMap {I J : SphereWorld} (φ : I ⟶ J) :
    ↥(Octonion.sliceSphere I.val) → ↥(Octonion.sliceSphere J.val)
```

— the point action of a sphere-world morphism: the `mob` leg acts on the point's
coordinate through the world's own compactified chart (the chart is
`OnePoint.map (Octonion.sliceEmbed I.val)`, whose inverse on the sphere carrier is the
computation already run inside `realize_mem_sliceSphere` — `sliceCoord_sliceEmbed`,
`dir_sliceEmbed_of_pos`/`_of_neg`/`_of_im_zero`, Slice.lean:161–:177); the `rot` leg
relabels by `g • ·` (`G2.smul_sliceEmbed` Slice:312, `G2.smul_onePoint_infty`). Then

```lean
instance : Groupoid ASection.NormalizedSlicePoint
-- Hom X Y := { φ : X.1 ⟶ Y.1 // spherePointMap φ X.2 = Y.2 }
```

with all laws componentwise from the certified `SphereWorld` groupoid
(SliceSphereWorld:209–:248) plus `spherePointMap_id`/`spherePointMap_comp` (§5) and
`Subtype.ext`.

**Why this carrier and no other (all existing declarations):**

- It is the domain-and-codomain of the section's own normalized action
  `normalizedSectionObject : NormalizedSlicePoint → NormalizedSlicePoint`
  (NormalizedAction:23, CERTIFIED) — the state space on which *this* `A` acts and in
  which its values lie by slice preservation (`realize_mem_sliceSphere`, Slice:371 =
  def:R). Not a designed container.
- C3/C4 populate it with `A`'s actual zero states through the existing constructor
  `normalizedZeroSlicePoint n I` (NormalizedAction:28), carrying their own addresses
  (`normalizedZeroLift_re` NormalizedBase:92,
  `normalizedZero_label_world_independent` NormalizedBase:59).
- **The one N:** the north state is the literal shared point
  `OnePoint.infty ∈ Octonion.sliceSphere I.val` for every world (`sliceSphere` =
  `insert ∞ …`, Slice:195). No north-object record, no auxiliary north map; the value
  there is C1's compactified datum (`valueAtInfinity`(+`_real`) ASection:196/:201,
  `Fstar_infty`, `realize_infty`). Circle points generally are shared across worlds on
  the nose (`sliceEmbed_ofReal` Slice:107).
- **b-uniformity of the carrier is type-forced, not designed:** `GreatCircle.Base` is
  a groupoid (ProjectiveBase:62), so `A.map f` is invertible for every arrow, and the
  action reaches every point from `N` (the recorded orbit-reachability witness, a
  construction-infrastructure register note — PHASE1_RHO_LAWS, `[[x,1],[1,0]] • ∞ = x`
  via `OnePoint.smul_infty_eq_ite`). Hence every fibre is isomorphic to the fibre at
  `N`; the `b`-dependence of the construction lives in the addressing (§2's landing
  law) and in the population, exactly where PROOF_OUTLINE_LOCKED §4 puts the analytic
  content. Geometrically this is the author's shared-circle fact: every slice sphere
  passes through every point of the one great circle, so the state continuum touches
  every address.

## 2. `(A.map f).obj`

For `f : (b : GreatCircle.Base) ⟶ (b' : GreatCircle.Base)` — literally
`f.val : GreatCircle.Aut = PGL(2,ℝ)` together with the stored transport equation
`f.property : f.val • b = b'` (Mathlib `ActionCategory.hom_as_subtype`, verified) —
and `X : (sectionObj A b).α`, `X = ⟨I, q⟩`:

```lean
def chartMoebius (g : GreatCircle.Aut) : Moebius :=
  cayleyMoebius⁻¹ * cayleyProjective g * cayleyMoebius
```

(existing pieces only: CayleyDictionary:46/:94 — `f.val`'s Möbius action read back in
the flat world chart; ONE element, the same in every slice sphere), and

```lean
(sectionMap A f).obj ⟨I, q⟩ :=
  ⟨I, spherePointMap (mobHom I (chartMoebius f.val)) q⟩
```

- The world is unchanged; the point moves by the one Möbius element of `f.val`, read
  in the world's own chart via the existing self-map morphism `mobHom`
  (SliceSphereWorld:263) — "simultaneously through every slice sphere".
- **The distinguished normal form:** on the identity component
  `cayleyProjective f.val = distinguishedMoebius u w` — the author's element
  `z ↦ u(z−w)/(1−w̄z)` (CayleyDictionary:187; per-generator instances are the missing
  lemma `cayleyProjective_distinguished`, §5). The `w`-part is the normalized orbit
  motion; the `u`-part is the residual band datum — at `w = 0` it is literally the
  certified band (`distinguished_phase_is_band` CayleyDictionary:231), which is
  literally the slice exponential in every world (`exp_phase_eq_sliceEmbed`
  CayleyDictionary:383). The reflection component is labeled by the pin `signDet` and
  read through the conjugate chart (`sliceEmbed_neg_conj` Slice:182; W3 row, §5).
- **The transport equation is the landing law:** on the shared circle the moved
  marker lands at `b'` — the missing lemma `chartMoebius_circleEmbed :
  (chartMoebius g).val (circleEmbed σ) = circleEmbed (g • σ)`, derived from the
  certified `cayleyCoord_equivariant` (F5, CayleyDictionary:118) with
  `complexPoint = circleEmbed` (the same function, `OnePoint.map` of the real
  embedding). Applied at `σ = b` with `f.property`, the marker reaches `b'`.
- **The reached value state is the section's own evaluation there:**
  `normalizedSectionObject A ⟨I, (sectionMap A f).obj X |>.2⟩` (NormalizedAction:23),
  world-preserving by slice preservation. The value is determined by the state —
  never a stored field, never a selected register.

**Where C1–C4 enter (headline consequences, not the inventory):**

- **C1** — the evaluation layer is total at every circle address: the pole's value is
  the point `N` (`realize_pole` PhiConversion:514) and the continuation through `N`
  is the compactified datum (`valueAtInfinity`(+`_real`), `Fstar_infty`,
  `realize_infty`); C1's simple-pole winding `−1` (`stemWinding_circle_pole`,
  SigmaE3) is the datum W4 consumes to close transports through the singular
  addresses.
- **C2** — right of the wall the reached value state is never the origin
  (`zero_free_on_halfSpace` ASection:207 from `c2_euler`): the nonsingular rest
  states where identity transports rest (`GpvTransport.id` Recovery:144,
  `realizes_id` ConnectedBase:98).
- **C3** — the populated addresses are `A`'s actual divisor, both ways
  (`stem_zero_of_sphereZero`, `sphereZero_complete`, StemFactorization): the
  constructor of §1 places the zeros and only the zeros; their arrival at `N` is the
  certified collapse (`normalizedZero_collapse_at_N` NormalizedBase:157, riding
  `c3_atN`).
- **C4** — the population is infinite (`c4_infinite` ASection:189).

## 3. `(A.map f).map`

For a fibre morphism `α : X ⟶ Y` (a pinned `SphereHom`, §1), with
`m := chartMoebius f.val`:

```lean
(sectionMap A f).map α :=
  ⟨Groupoid.inv (mobHom X.1 m) ≫ α.val ≫ mobHom Y.1 m,
   spherePointMap_conj … ⟩
```

- Componentwise (certified `SphereHom.comp_rot`/`comp_mob`, `id_rot`/`id_mob`,
  SliceSphereWorld:226–:234): the `rot` leg is **unchanged**, the `mob` leg is
  **conjugated** — `(…, m * α.val.mob * m⁻¹)`. The `SphereWorld` groupoid supplies
  all of the geometry; equality of fibre morphisms is decided by `SphereHom.ext` and
  `Subtype.ext`.
- The pinning at the moved points is the one naturality lemma `spherePointMap_conj`
  (§5): chart algebra only — the `rot` leg commutes with the chart Möbius action by
  `G2.smul_sliceEmbed`, and the `mob` legs compose in `Equiv.Perm (OnePoint ℂ)`.
- **No raw path enters any categorical equality** (no existing fibre type does so,
  and none is introduced). W1–W4, GPV existence/uniqueness, winding, crossing, and
  welding facts are cited exactly where the specification places them: in §4 and the
  §5 tables, proving well-definition and independence of the chosen normal-form
  presentation — never as morphism data.

## 4. Orbit–stabilizer well-definition

`A.map` is defined once, directly (§2–§3). The factorization below is an *identity
about it* — the verification that global well-definition reduces to the
section-prescribed normalization transports and the residual action at `N`. No
induced construction, no independent `H`-action.

```lean
def H : Subgroup GreatCircle.Aut :=
  MulAction.stabilizer GreatCircle.Aut (OnePoint.infty : GreatCircle.Point)

def s : GreatCircle.Point → GreatCircle.Aut
  | OnePoint.infty => 1
  | (x : ℝ)        => Matrix.ProjGenLinGroup.mk
      (Matrix.GeneralLinearGroup.mkOfDetNeZero !![x, -1; 1, 0] (by norm_num))

theorem s_spec (x : GreatCircle.Point) : s x • (OnePoint.infty : GreatCircle.Point) = x
-- the recorded orbit-reachability witness ([[x,1],[1,0]] • ∞ = x, PHASE1_RHO_LAWS
-- register note), entry sign adjusted to det = 1 so the transporter lies on the
-- identity component; via GreatCircle.mk_smul + OnePoint.smul_infty_eq_ite.

def normalForm {b b' : GreatCircle.Point}
    (f : (b : GreatCircle.Base) ⟶ (b' : GreatCircle.Base)) : ↥H :=
  ⟨(s b')⁻¹ * f.val * s b, by
    -- (s b')⁻¹ • (f.val • (s b • ∞)) = (s b')⁻¹ • (f.val • b) = (s b')⁻¹ • b' = ∞
    simp [mul_smul, s_spec, f.property, inv_smul_eq_iff]⟩
```

**Exact A-dependent meanings.**

- `s x` — the canonical circle transporter `N → x`. Through the dictionary its
  Cayley image carries the circle point `1 = cayleyCoord N` (`cayleyCoord_infty`
  CayleyDictionary:111) to `cayleyCoord x`; its distinguished form is pure
  `w`-motion up to phase (§2).
- `T x` — the induced value transport: the section's certificate along that channel,
  the 5-clause GPV package `gpvBase_transport` (FaithfulApply:122) /
  `gpvBase_transport_star` (ConnectedBase:44) on a circle channel from `N` to `x`,
  routed through the certified passage rows where the channel meets degenerate
  stretches or the cone (`great_circle_lift_through_degenerate` FaithfulApply:198,
  `great_circle_passage_total` FaithfulApply:274, `pole_cone_eps_delta`
  LoopAssembly:207, `cone_junction_levels_shared` IntegrateTheorem:167).
- **The residual action at `N`** — not a new definition: it is `A.map` at the
  `End(N)` arrows `⟨h, h • N = N⟩`, the same §2–§3 formula. Its value side is
  certified channel-by-channel by the three-generator table (translations ↔ tape,
  dilations ↔ cone/junction, reflection ↔ crossing/flip — PHASE1_RHO_LAWS Laws 6–8);
  its interaction with the internal band is the Law-9 derivation from the certified
  model rows (`G2.smul_sliceEmbed`, `realize_equivariant` Slice:436) plus the
  composition cocycle below.

**The unique winding data (the channels' rigid constants — added 2026-07-16 on the
author's review).** The transporter and residual channels are not generic: their
winding content is pinned by exact certified rows.

- `stemWinding_circle_pole` (SigmaE3:895): there is `ε₀ > 0` such that for every
  `0 < ε ≤ ε₀` the value loop `Γ t = A.F (circleLoop (A.pole) ε t)` is nonvanishing,
  closed, and `stemWinding Γ = -1` — **exactly −1**, read off `c1_simple`
  (meromorphic order −1). C1's signature datum.
- `stemWinding_circle_sphereZero` (SigmaE3:348): the value loop around the n-th zero
  winds by **exactly the divisor multiplicity**
  `Nat.card {k | A.sphereZero k = A.sphereZero n}`.
- `winding_lift_unique` (Toolkit:301) and `stemWinding_eq_zero_iff` (SigmaE3:119):
  the lift through a basepoint is **unique**, and winding 0 is **equivalent** to a
  closed lift (the GPV Cor 5.13 register).
- W4 consumes the −1 against the multiplicity: `normalizedZero_pole_winding`
  (NormalizedPoleBridge:18) — the composite zero-loop/pole-loop winding is
  `multiplicity − 1` — so the multiplicity-power composite winds 0 and closes
  (`normalizedZero_pole_power_closes`, NormalizedPoleBridge:48).

**Where the real value is conserved (the level rows riding every transport — added
2026-07-16 on the author's review).** These are theorems *about* the transports,
riding inside them; never a global hypothesis (the PROOF_OUTLINE_LOCKED §4 ban).

- Every certificate carries the tape: `gpvBase_transport` /
  `gpvBase_transport_star` and `realizes_gpv_lift` (Recovery:319) include
  `(Γ t).re = Real.log ‖γ t‖`, continuous in `t`, basepoint-unique; the tape is
  forced pointwise for ANY lift by `sweepE5_lift_level_tape` (SweepE5:100).
- On any closed loop the level closes **unconditionally**:
  `winding_loop_defect_level_zero` (LoopAssembly:107) — all multiplicity lies in the
  winding direction, none in the level.
- The two analytic names of the level agree, branch-independently:
  `euler_branch_level` (InboxWire:146) — C2's Euler real part `(∑' ℓₚ).re` equals
  `Real.log ‖A.F‖` along every lift right of the wall.
- The joins through the degenerate fibre hold the level **constant** along the whole
  path: `zero_encounters_joined_concentric` (FaithfulApply:328) and
  `pole_encounters_joined_concentric` (FaithfulApply:354), with the junction sharing
  `cone_junction_levels_shared` (IntegrateTheorem:167) and the IVT sweep
  `real_segment_tape_sweeps` (IntegrateTheorem:144).
- The populated states carry their labels intrinsically: `normalizedZeroLift_re`
  (NormalizedBase:92), world-independent (`normalizedZero_label_world_independent`
  NormalizedBase:59).

**The two laws (only these; both pure group algebra on sourced equations):**

- `h(1ₓ) = 1`: `(𝟙 x).val = 1` is `ActionCategory.id_val` (Mathlib, verified); then
  `(s x)⁻¹ * 1 * s x = 1` by `mul_one`, `inv_mul_cancel`.
- `h(g₂g₁) = h(g₂) · h(g₁)`: `(f ≫ f').val = f'.val * f.val` is
  `ActionCategory.comp_val` (Mathlib, verified); insert `s b' * (s b')⁻¹` and
  reassociate:
  `(s b'')⁻¹ * f'.val * f.val * s b = ((s b'')⁻¹ * f'.val * s b') * ((s b')⁻¹ * f.val * s b)`.

**Presentation independence (why the analytic assignment depends only on `f.val` and
the endpoints).** Geometric side: `chartMoebius` is a conjugated monoid-hom
composite, so `chartMoebius ((s b')⁻¹ * f.val * s b)` equals the conjugate of
`chartMoebius f.val` by the transporters' images — by `map_mul`/`map_inv`
(`cayleyProjective_mul` CayleyDictionary:217). Two factorizations of the same `f.val`
therefore act as the *same element* of `Equiv.Perm (OnePoint ℂ)`; the certified
distinguished composition law (`distinguishedMoebius_mul` CayleyDictionary:353, with
`distinguishedCompW`/`distinguishedCompPhase` — the cocycle) computes the composite's
`(u, w)` normal form in closed form, so no choice of presentation ever reaches the
element's identity. Analytic side: two channel presentations of the same arrow differ
by a loop, and the certificate is presentation-free by the Law-3 cluster —
`winding_lift_unique` (Toolkit:301), `stemWinding_eq_of_homotopy` (WeldW12:358),
`winding_loop_closed` (LoopAssembly:92) — with the resting loops' triviality supplied
by W1/W2 and the singular-address closures by W4 (§5 tables).

## 5. Literal functor packaging

```lean
def sectionObj (A : ASection) (b : GreatCircle.Point) : Grpd

def sectionMap (A : ASection)
    {b b' : GreatCircle.Point}
    (f : (b : GreatCircle.Base) ⟶ (b' : GreatCircle.Base)) :
    sectionObj A b ⥤ sectionObj A b'

theorem sectionMap_id (A : ASection) (b : GreatCircle.Point) :
    sectionMap A (𝟙 (b : GreatCircle.Base)) = 𝟭 (sectionObj A b)

theorem sectionMap_comp (A : ASection)
    {b b' b'' : GreatCircle.Point}
    (f : (b : GreatCircle.Base) ⟶ (b' : GreatCircle.Base))
    (g : (b' : GreatCircle.Base) ⟶ (b'' : GreatCircle.Base)) :
    sectionMap A (f ≫ g) = sectionMap A f ⋙ sectionMap A g

def sectionFunctor (A : ASection) : GreatCircle.Base ⥤ Grpd
-- obj x := sectionObj A x.back   (Mathlib ActionCategory.back; the Hom types are
-- definitionally the subtypes of §2, so no transport is needed)
-- map f := sectionMap A f
```

Per-field supply (existing theorem, or ONE precise missing lemma):

| Field / proof | Supply |
|---|---|
| `sectionObj` carrier | `NormalizedSlicePoint` (NormalizedAction:17, on disk) |
| `sectionObj` groupoid structure | **missing:** `spherePointMap` + `spherePointMap_id` + `spherePointMap_comp`; laws otherwise componentwise from the certified `SphereWorld` instances |
| `sectionMap.obj` | §2 formula; `mobHom` (SliceSphereWorld:263); `chartMoebius` from `cayleyMoebius`/`cayleyProjective` (existing) |
| `sectionMap.map` | §3 formula; **missing:** `spherePointMap_conj` |
| landing law | **missing:** `chartMoebius_circleEmbed`, from `cayleyCoord_equivariant` (certified) |
| `sectionMap_id` | `ActionCategory.id_val` (Mathlib) + `map_one` of `cayleyProjective` + `mobHom I 1 = 𝟙 I` (rfl-grade) + `spherePointMap_id` |
| `sectionMap_comp` | `ActionCategory.comp_val` (Mathlib) + `cayleyProjective_mul` (CayleyDictionary:217, certified) + `mobHom` multiplicativity (rfl-grade via `SphereHom.comp_mob`) + `spherePointMap_comp` |
| normal form / §4 | `s_spec` (**missing**, one-liner via the recorded witness); `ActionCategory.id_val`/`comp_val`; group algebra |
| distinguished form | **missing:** `cayleyProjective_distinguished` (per-generator `(u, w)` instances, computable from `distinguishedGL`) |

Complete missing-item ledger (nothing else is new): `spherePointMap`,
`spherePointMap_id`, `spherePointMap_comp`, `spherePointMap_conj`,
`chartMoebius_circleEmbed`, `cayleyProjective_distinguished`, `s_spec`, and the
`Groupoid` instance packaging of §1. Superseded, not consumed: `functorA`/`poleGen`
(AFunctor.lean — the HANDOFF guardrail). Consumed as single declarations pending the
mechanical O8 rehoming, never as an architecture import: `Fstar`, `circleEmbed`,
`NonSingular` (ConnectedBase.lean).

**C1–C4 dependency table (which functor obligation each discharges):**

| Clause | Exact contribution | Obligation discharged |
|---|---|---|
| C1 | `pole`, `c1_simple`; `realize_pole` (PhiConversion:514); `valueAtInfinity`(+`_real`), `Fstar_infty`, `realize_infty`; `stemWinding_circle_pole` (SigmaE3:895) — **winding exactly −1 around the pole** | totality of the object/evaluation layer at `p₀` and at the one shared `N`-state (§1–§2); the `−1` winding datum consumed by W4's closures |
| C2 | `c2_euler`; `zero_free_on_halfSpace` (ASection:207) | the nonsingular rest states where identity transports rest (`GpvTransport.id`, `realizes_id`); the half-space side of §4's presentation independence |
| C3 | `sphereZero`, `c3_factorization`; `stem_zero_of_sphereZero`/`sphereZero_complete` (StemFactorization); `c3_atN` | the §1 population places `A`'s actual zeros and only them, at their own addresses; their certified arrival at `N` (`normalizedZero_collapse_at_N`) |
| C4 | `c4_infinite` (ASection:189) | the population carried by the functor is infinite |

**W1–W4 dependency table:**

| Weld | Exact contribution | Obligation discharged |
|---|---|---|
| W1 | `GpvTransport.ofEulerHalfSpaceLoop` (Recovery:50); `stemWinding_F_halfSpace` (WeldW12:238) | identity certificates and presentation independence for channels resting or looping in the Euler half-space — the analytic face of `sectionMap_id` |
| W2 | `GpvTransport.ofLeftRegionLoop` (Recovery:99); `stemWinding_F_leftRegion` (WeldW12:1191) | the same on the left region — the other resting side of the divisor |
| W3 | the crossing suite (SigmaE3:730–:879); `crossing_sign_rigid` (FlipWeld:986); `sliceEmbed_neg_conj` (Slice:182) | well-definition of the reflection generator's action: conjugate chart reading, flip/bounce bookkeeping, sign rigidity — the `signDet` coset of §4's normal form |
| W4 | `normalizedZero_pole_winding` (NormalizedPoleBridge:18 — composite winding = multiplicity − 1); `normalizedZero_pole_power_closes` (NormalizedPoleBridge:48); `zero_pole_pair_closes_through_witness` (SynthesisE6:228); `two_center_winding_onto_one_band` (WeldW4:165) | totality of the transport certificates through the singular addresses: composite channels meeting zeros or `p₀` close, so §4's `T x` and the residual action at `N` are defined at every address, not only nonsingular ones |
