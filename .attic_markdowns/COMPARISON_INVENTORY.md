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

# COMPARISON INVENTORY — the typed bridges of the enriched section functor

*First cut, 2026-07-11 (Fable, from the three-way Jesse/Codex/Fable convergence). **Not yet
completed against the import graph** — rows marked `TO-VERIFY` cite statements not re-read
this session; more gaps may surface. The three gaps at the bottom are prominent **candidates**,
not a certified-complete list.*

## The driving question (Codex, 2026-07-11, ratified)

> What is the smallest honest enriched arrow type whose constructors can be extracted from
> the existing C1–C4/W1–W4 certificates, whose composition is proved, and whose preservation
> field is exactly the real coordinate needed at the normalized zeros?

## The design principle of record (Jesse + Codex, 2026-07-11)

**Build the complete enriched action first. Derive its connectivity second. Apply the two
categorical theorems third. Read the generic c from the preserved real coordinate last.**

## Standing rules (today's rulings — these bind the build)

1. **No primitive `Z_n ⟶ N` generators.** The common-N connection is a *consequence* of the
   correct functor — composites/zigzags that emerge from the enriched action — never a family
   of arrows inserted into the definition. (Jesse: "that's too specific… forced from the
   correct functorial definition.")
2. **No `center(𝔫) : ℝ` label.** N is the common compactified *geometric witness*, not the
   finite real number c. Assigning it a label would encode `Re(ρ_n) = center(𝔫)` into arrow
   existence. Object data is heterogeneous: zeros retain `Re(ρ_n)`; other objects retain only
   what is analytically meaningful for them. **c := Re(ρ_0), chosen at the very end**;
   component invariance does the rest.
3. **No pre-named pole image.** `F_A(pole loop) = band(−1)` is WITHDRAWN (2026-07-11): W4's
   row is winding accounting only (verified below); integer windings exponentiate to phase 1.
   The pole's fibre action is *computed* from the comparison rows, never named in advance.
4. **Preservation is a well-definedness obligation.** Real-center/level preservation is proved
   *when each arrow is constructed*, from its certified cargo — not an independent hypothesis,
   not a post-colimit lemma. The quotient only descends what the arrows prove.
5. **Four −1's = four types** until comparison maps exist: `−1 : ℤ` (winding), `−1` in the GPV
   signature type, `−1 : Circle` (band), `−1 : ℂ` (value). The "mouth" is the geometric
   forecast (gloss register, R10); the comparisons below are the derived layer that must
   earn it.

---

## A — Winding ⟷ lift-height register

**A1. `ASection.Realizes`** (ConnectedBase.lean:88) — the base arrow's current identity datum.
- Typed: `OnePoint ℝ → OnePoint ℝ → ℤ → Prop`; cargo `γ Γ : C(unitInterval, ℂ)` with
  `Γ 1 − Γ 0 = 2π·I·k` — winding `k : ℤ` ⟷ lift defect (purely imaginary).
- Provenance: kernel (definitional). Status: **GREEN**.
- Functor use: base hom identity. Center use: via A4. Connectivity: generator.

**A2. `ASection.GpvTransport`** (Recovery.lean:23) — the enriched record: domain path,
value path, lift, `value_compact`, winding; `id`/`inv`/`comp` proved (Recovery.lean:136–253).
- Status: **GREEN**. Functor use: **the current best candidate germ for the driving
  question's arrow type** (needs: full-circle objects incl. N; the preservation field;
  cargo retained past `GpvRealizes`'s `Nonempty` truncation — see H3).

**A3. `winding_height_shift`** (SigmaE3.lean:879) —
`(γ' 1).im − (γ' 0).im = stemWinding γ · 2π`.
- Typed: winding `ℤ` ⟷ **imaginary** height shift `ℝ`. Status: **GREEN** (DERIVED, R10).
- Center use: none directly — this is the *quotiented* direction (2π per turn), the
  complement of the level. Docstring wires it to Cor 5.21's `|σᶜ|/2` via
  `crossing_band_ledger` ("flips step the band, bounces conserve it") — see E2/D3.

**A4. `realizes_value_eq`** (ConcentricityReadout.lean:83) — every base arrow conserves the
compactified value: `Fstar σ = Fstar σ'` (the lift defect is purely imaginary, so the value
path closes). Status: **GREEN**. Functor use: **preservation prototype** (value register).
Descends: `value_const_on_component` (:106), **GREEN** — the π₀-recursion prototype.

**A5. `winding_loop_defect_level_zero`** — "all multiplicity in the winding direction, none
in the level." Cited in A4's docstring. Status: GREEN per citation, **TO-VERIFY** exact
statement/location.

## B — Value ⟷ level register (the concentric family)

**B1. `exp_fibre_level`** (LoopAssembly.lean:161) — `exp w = −(r:ℂ) → w.re = Real.log r`.
- Typed: value `−r : ℂ` ⟷ level `log r : ℝ`. Provenance: master `lem:exp-degenerate`.
- Status: **GREEN**. Center use: THE value-level comparison (one level per fibre).

**B2. `shared_ladder_encounters`** (LoopAssembly.lean:271) — ∀ ε ∃ r < ε: both zeros'
ε-neighborhoods hit the same value `−r`. Status: **GREEN**.
- Connectivity use: **asymptotic support only** — not arrows. `shared_level_at_scale`
  (ConcentricityReadout.lean:123) adds one-level-per-fibre. **GREEN**.

**B3. Collapse rows** (NormalizedBase.lean, 2026-07-11, certified):
`Octonion.norm_smul`, `norm_sliceEmbed_sub_sliceEmbed` (worlds diverge by exactly
`|Im z|·‖I−J‖`; coincide on the circle), `norm_sliceEmbed` (world-independent norm),
`normalizedZeroLift_norm`, `normalizedZero_collapse_at_N` (uniform-in-world escape).
- Status: **GREEN**. Connectivity use: **asymptotic support only** (Codex's qualification
  stands: escape ≠ categorical legs). Note `TopologicalSpace Octonion` exists
  (WeldW3.lean:89) — the literal `OnePoint`-convergence row is statable when wanted.

## C — Pole / C1 register

**C1. `stemWinding_circle_pole`** — C1's pole loop ⟷ `−1 : ℤ`. Status: GREEN per repeated
use (WeldW4, NormalizedPoleBridge); **TO-VERIFY** exact statement/location.

**C2. `normalizedZero_pole_power_closes`** (NormalizedPoleBridge.lean) — zero-loop winding =
divisor multiplicity; pole loop = −1; `Γz·Γp^m` admits a **closed** lift. Status: **GREEN**
(every n, every world). Connectivity use: **composite material** (never primitive legs —
Rule 1). Center use: decided by arrow extraction, not asserted here.

**C3. `two_center_winding_onto_one_band`** (WeldW4.lean:165) — two-center configuration:
`1 ≤ stemWinding Γn`, `1 ≤ stemWinding Γm`, `stemWinding Γp = −1`, individual lifts do NOT
close, composite does. Status: **GREEN** — **verified 2026-07-11: the row lives entirely in
the ℤ-winding/lift register; it contains no Möbius/band image of anything** (basis of Rule 3).

## D — Band / U(1) / Möbius register

**D1. `bandMoebiusHom : Circle →* Moebius`** (SliceSphereWorld.lean:167) and
**`bandEnd I : Circle →* End I`** (:272) — U(1) inside the Möbius group, acting in every
world. Status: **GREEN**. Functor use: the fibre's automorphism receptacle (whatever lands
there must arrive via a computed comparison — Rule 3).

**D2. `bandMoebius_apply_infty` / `_apply_zero`** (:138, :147) — the band fixes N and 0 in
every world. Status: **GREEN**. Caution recorded (Codex): the band does **not** fix finite
real points (`r ↦ c·r`); setwise family behavior ≠ individual-coordinate preservation.

**D3. `crossing_band_ledger`** (SigmaE3) — "flips step the band, bounces conserve it" — the
signature-flip ⟷ band-step comparison. Status: partially wired per A3's docstring;
**TO-VERIFY** exact statement and type.

**D4. Point-level Möbius action on `sliceSphere I`** — the chart conjugation
(`spherePt`-style machinery was in the deleted SliceSphereWorld tail). Status: **GAP
(mechanical)** — needed for the pointed fibre groupoid (Step 2).

## E — Signature register (GPV)

**E1. Cor 5.13** (SOURCES/GPVwind.md, verbatim pin) — a loop lifts iff σ ∈ {0, −1} on each
obstruction interval; then the lift is a loop. Status: **SOURCED only**. This is the
July-7 isolated joint: the one untranscribed GPV consequence, at NONEMPTY obstruction sets
(real crossings; Rem 2.1: `dir` has no continuous extension there).

**E2. Cor 5.21** (pin) — winding = |σᶜ|/2: **the signature register is graded in
half-turns**; the ÷2 is the one SOURCED home of half-turn grading. Partially wired
(A3 docstring, D3 ledger). The typed bridge σᶜ-type ⟷ ℤ: **GAP** (see G1).

## F — Direction / G₂ register

**F1. `dirHomTo` / `sphereWorld_zigzag`** (SliceSphereWorld.lean:259, :288) — G₂ transitivity
⟹ world-level 𝒮₂ is one component. Status: **GREEN**. Connectivity use: fibre zigzag material.

**F2. `normalizedZeroLift_equivariant` / `normalizedSectionPoint_equivariant`**
(NormalizedAction.lean) — the G₂ naturality squares of the section action. Status: **GREEN**.
Functor use: naturality (first of the "plays nicely" squares).

**F3. W3 rows `companion_forced`, `direction_path_to_neg`** — direction forcing; the odd-π
antipodal turn. Status: GREEN per prior certification; **TO-VERIFY** exact statements.
Functor use: the direction component of extraction.

**F4. `gpvPopulated` / `GpvTransportWitness`** (IntegrateTheorem.lean:269) — the enriched
witness fields incl. (a) unique tame lift. Status: GREEN per prior certification;
**TO-VERIFY** field list. Functor use: uniqueness = canonicity of extraction
(well-definedness, Rule 4).

## G — Object layer

**G1. `NormalizedZeroObject` / `normalizedZero`** (NormalizedBase.lean) — index, world,
footpoint, `label = Re(ρ_n)` (`label_zero` definitional). Status: **GREEN**. **Already
heterogeneous**: no label is assigned to `BaseC.nPt` — the object layer as built already
satisfies Rule 2. Do not add one.

**G2. `NormalizedSlicePoint` + `normalizedSectionObject`** (NormalizedAction.lean) — pointed
fibre objects; the section's world-preserving action. Status: **GREEN**. Groupoid structure
on it: **GAP** (Step 2, mechanical given D4).

## H — Categorical engines

**H1. `pi0_grothendieck`** — `π₀(∫F) ≅ colim(π₀∘F)`, generic over `F : B ⥤ Grpd`.
Status: **GREEN** (certified; applies unchanged to the corrected functor).

**H2. Connected ⟺ π₀ singleton** (Riehl CHT Rem 8.3.5 clause). Status: **DOWNGRADED
2026-07-11 evening (Codex's correction)** — the previously-green singleton theorem was the
old thin transport's; the generic lemma is standard and likely short but must be **located
in Mathlib or proved for the corrected construction** before this row is green.
`toColimitObj_eq_of_zigzag` itself: **GREEN**, generic.

**H3. `GpvBase` / `instGroupoidGpvBase`** (Recovery.lean:258) — winding-labeled homs,
`Nonempty` truncation. Status: **GREEN**, flagged: the truncation discards exactly the cargo
extraction needs. Its fate is decided by the driving question's arrow type.

---

## The prominent candidate gaps (not certified-complete)

- **GAP-1 — the signature ⟷ winding typed bridge**: transcribe Cor 5.13/5.21 at nonempty
  obstruction sets (E1/E2) into typed comparison theorems. The July-7 isolated joint.
- **GAP-2 — the winding → band typed hom the functor actually uses** (if any): the pole
  action's home, **computed** from A3/D3/E2, never named (Rule 3).
- **GAP-3 — the enriched arrow type itself** (the driving question): full-circle objects,
  constructors extracted from C1–C4/W1–W4 certificates, composition proved, heterogeneous
  center-preservation field per Rule 2/4 — with N-connectivity *emerging* (Rule 1).

Plus known mechanical gaps: D4 (point-level Möbius charts — needed only if the 0.3 fibre
ruling makes points objects), G2 (fibre design per the 0.3 ruling), and the `TO-VERIFY`
rows above, to be completed against the import graph.

---

## Addendum (2026-07-11 evening) — rows from the three-way exchange on the −1 dossier

**W-1. ⚠ THE BAND NAMING COLLISION (Codex's find, verified against the rows).** Two
unrelated meanings of "band" coexist in the files: (a) the **logarithmic height strip**
between consecutive π-rungs — the "band" of `band_side_of_sign`, `crossing_band_ledger`,
`arc_band_confined` (SigmaE3); (b) the **U(1) subgroup** of Möbius self-maps — `bandGL`/
`bandMoebius`/`bandEnd` (SliceSphereWorld). **No Lean theorem identifies them**; the ledger
never produces an element of `Circle`, `Moebius`, or `SphereHom`. Every future row must say
which band it means. The ledger is input to GAP-2, not GAP-2's answer.

**W-2. The `liftPhase` candidate (Codex's proposal; Mathlib names verified 2026-07-11,
R5).** Candidate typed bridge: `liftPhase (w : ℂ) := Circle.exp w.im : Circle`.
Verified present in pinned Mathlib (`Mathlib/Analysis/SpecialFunctions/Complex/Circle.lean`):
`Circle.exp`, `Circle.periodic_exp` (period 2π), `Circle.exp_int_mul_two_pi = 1`,
`Circle.exp_add`, and **`Real.Angle.toCircle := Circle.periodic_exp.lift`** — the
height-mod-2π → U(1) map already at the quotient level. Expected facts (TO-DERIVE):
`liftPhase (w + 2πik) = liftPhase w`; at a negative-real encounter (odd rung,
`crossing_height_odd_of_neg`) `liftPhase w = −1` (via `Complex.exp_pi_mul_I`). The typed
chain it would assemble: winding k ↦ height shift 2πk (`winding_height_shift`) ↦ phase in
U(1) (`Real.Angle.toCircle`) ↦ −1 at the degenerate encounters; companion class
[±I] ∈ S⁶/{±Id} supplied by `companion_forced`/`direction_path_to_neg`. **Status:
TO-DERIVE — never pre-declared the functor action (Rule 3).** With B2 + B1 this yields the
sphere-independent local package `(level log r, phase −1, companion class [±I])` — the
candidate canonical datum for extraction, independence trio to prove: which zero
neighborhood, which rung, which representative of ±I.

**W-3. P-1 provenance question (Codex's correction).** The proof plan of record (clause 2)
says "σ = c, unique winding" — the inventory must determine what σ and c denoted **in that
document** (2026-07-07 register; cf. the banked "σ maps to ITSELF — σ = c from the
winding," commit 6c3edbd) before any architectural use. NOT to be read as
GPV-signature = real-center: those are different registers and nothing justifies the
identification.

**W-4. `realizes_of_value_eq` audit flag (Codex's correction).** Value-coincidence arrows
are a **candidate constructor only**: an arrow from mere endpoint-value equality may be a
substitute for the actual section transport. Audit against the intended path/lift cargo
before admission into `B_A`.

**W-5. The fifth −1 register** (see MINUS_ONE_DOSSIER.md §0/§5): the direction antipode —
GPV's companion is valued in 𝕊/{±Id} (Def 4.7 verbatim); flips ARE antipodal limit pairs
(Def 5.2; in-repo `IsFlip : d.sRight = −d.sLeft`, GREEN). `companion_forced` +
`direction_path_to_neg` (W3) prove the companion canonical modulo ±1 — exactly the
independence the extraction needs (the action must not depend on I vs −I).

**W-6. `shared_ladder_encounters` placement (ruled in the exchange).** Analytic support,
not the categorical connection: it supplies pairwise, arbitrarily fine common
negative-value encounters; with B1 and the parity rows it feeds the W-2 package. It
constructs no path, mentions no world, proves no naturality.

**W-7. THE THREE ACTION LAYERS (Codex's correction to the author's subgroup question,
kernel-verified 2026-07-11).** U(1) occurs abstractly as a Lie subgroup of G₂ (via the
SU(3) chain), but **the band action is not a G₂ restriction and full Möbius is not inside
G₂ at all**: PSL(2,ℂ) is noncompact 6-dimensional (no subgroup of compact G₂); decisively,
every G₂ automorphism fixes 1 and the reals pointwise — `G2.smul_one` (G2.lean:79),
`G2.smul_ofReal` (G2.lean:87), both **GREEN** — while the band sends `1 ↦ c`
(`bandMoebius_apply_coe`). Three interacting layers, one groupoid: G₂ *between* sphere
objects (fixing 1, ℝ, and N — `G2.smul_onePoint_infty`, GREEN, rfl); Möbius *within*
charts; U(1) inside Möbius fixing 0 and N. `SphereHom`'s two independent fields
`(rot : G2, mob : Moebius)` are the correct receptacle — vindicated, not an accident.

**W-9. THE EQUIVARIANCE-CANONICAL G₂ ACTION (the author's axial-symmetry resolution,
Codex-confirmed, kernel-verified 2026-07-11 late).** The functor never selects a
`g : G2` — slice preservation on axially symmetric domains means the ONE stem acts
uniformly in every slice, so the normalized section maps every existing direction arrow
to the SAME arrow. Kernel basis, all GREEN: `realize_equivariant` (Slice.lean:436 —
`A.realize (g • q) = g • A.realize q`, Wang Rem 2.11), `sliceCoord_smul_invariant`
(Slice.lean:425), `realize_mem_sliceSphere` (Slice.lean:371). The companion quotient
[±I] is REPURPOSED: it certifies representative independence (ℂ_I = ℂ_{−I}), never arrow
generation — the SU(3)-stabilizer ambiguity never arises. CONSTRAINT recorded: the
section's slice restriction is NOT generally Möbius (`q ↦ q²` acts as `z ↦ z²`) — the
section application is a non-invertible endofunctor, distinct from `F_A`'s invertible
values on base arrows; the two-actions distinction is a 0.3 agenda item. W-2 amended
accordingly: an endpoint `liftPhase` value loses winding — object vs path vs holonomy
class vs naturality witness is a Phase-0.1 DETERMINE item, and it is NOT the mob
component of one `SphereHom` by fiat.

**W-8. THE LAYER-COMPATIBILITY ROW IS ALREADY GREEN.** Codex's "chart identity"
`g(sliceEmbed_I z) = sliceEmbed_{gI} z` is `G2.smul_sliceEmbed` (Slice.lean:312, GREEN —
"the slice embedding intertwines the G₂ action"). Consequence recorded by Codex, ratified:
the same phase c can act in every chart along pure-G₂ legs (trivial Möbius leg); U(1) is
not central in Möbius, so no blanket naturality. **The candidate morphism decomposition of
the extraction** (TO-DERIVE with W-2, never pre-declared): analytic transport ↦
(G₂ direction leg from the companion class mod ±, U(1) component from `liftPhase`,
remaining Möbius component from the normalized sphere action) — jointly aiming at an
unambiguous `SphereHom` at each shared encounter `(log r, −1, [±I])`.
