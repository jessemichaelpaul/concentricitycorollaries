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

# 𝒱/ρ TRANSPORT-PRESENTATION CERTIFICATE

**AUDIT REQUEST — check against ALIGNMENT points 20–23 and the proof-order audit.**

**Prepared by:** Fable, 2026-07-16, per the cross-audit ruling and the author's
register correction: **no real-valued register is selected as "the" datum** — the base
coordinate σ, the slice coordinate Re(q), and the GPV lift level Re Γ = log‖γ‖ are
coordinated aspects of one certified transport, related by bridge theorems where the
passages occur; the finite zigzag through N and the colimit identification are LATER
categorical consumption, listed in §7 and used nowhere in §§1–6. Raw analytic
representatives never enter categorical equality: labels are invariant, representatives
are propositional (`Nonempty`), per the certified `GpvRealizes` precedent.

---

## §1 Typed state endpoints (the species that OCCUR in certified transports)

**The three registers and their bridge theorems (no selection):**

| Pair | Bridge theorem (exact) | Where it holds |
|---|---|---|
| Re Γ ↔ log‖γ‖ | `sweepE5_lift_level_tape`; `Octonion.lift_level_tape`; `realizes_gpv_lift` clause (f) | every lift of every nonvanishing value path |
| Re q ↔ log‖exp q‖ | `Octonion.level_eq_log_norm_exp`; `re_Llog_of_mem` | the E⁺ register, all q |
| Re Γ ↔ Re Σℓₚ ↔ log‖F‖ | `ASection.euler_branch_level` | right of the wall (C2's half-space) |
| Re w ↔ log r at degenerate values | `exp_fibre_level`; `Octonion.degenerate_level_readout` | fibre over −r |
| slice coordinate ↔ enumerated label | `normalizedZeroLift_re` (re of the zero's lift = (sphereZero n).re) | the populated zero states |
| σ ↔ value at σ | `Fstar_coe`/`Fstar_infty` (retyping O8) | the great-circle endpoints |

**Species table (forced by the literal sources/targets of certified transports):**

| Species | Exact type / minimal retyping | Constructors | Population | Occurs in |
|---|---|---|---|---|
| S1 great-circle endpoint | `σ : OnePoint ℝ` (retypes to `GreatCircle.Point`) | — | — | `GpvTransport A σ σ' k` endpoints; `NonSingular` guards identities |
| S2 pointed slice state | `NormalizedSlicePoint = Σ I : SphereWorld, ↥(sliceSphere I.val)` (on disk) | `⟨I, q⟩`; section action `normalizedSectionObject`, `compactifiedSphereMap` | — | vertical/band legs; the section's own action |
| S3 populated C-residue zero state | `NormalizedZeroObject` (on disk: index/world/footpoint/label + `label_zero`) | `normalizedZero (n)(I)`; `normalizedZeroSlicePoint` | **C4** (`c4_infinite`) through **C3**'s enumeration (divisor honesty: `stem_zero_of_sphereZero`/`sphereZero_complete`) | loop centers; power-closure legs; the N-legs' sources |
| S4 north-pole state | **forced record** (O1 resolved by theorems, not by call): base ∞ + `valueAtInfinity : OnePoint ℂ` + `valueAtInfinity_real` — exactly what `Fstar_infty` (`rfl`) and `realize_infty` evaluate to | — | **C1** (the compactified continuation datum) | target of every N-leg (`NormalizedNLeg.target`); identity conditional: `NonSingular ∞ ⟺ valueAtInfinity ∉ {0, ∞}` |
| S5 degenerate fibre state | `sliceEmbed v ⟨log r, (2k+1)πi⟩ : Octonion` (E⁺ register) | via `exp_fibre_neg_real` (the full fibre = S⁶ × ℤ) | C3's encounters (`neg_reals_swept_near_sphereZero`, `shared_ladder_encounters`) | endpoints of certified FIBRE paths (`exp_fibre_sphere_connected`/`_conj_joined`); representative data, not proposed 𝒱-objects |

**The zero/pole endpoint species — decided by the theorems (Codex's question 3):**
`lift_exp` forces `value t ≠ 0` for all t, so zero/pole are NEVER endpoints of the
nonvanishing-path species. The certified rows use them as **(b) limiting witnesses**
(loop centers: `circleLoop (sphereZero n) ε`, `circleLoop (pole) ε`; the winding rows)
**and (d) morphisms after power normalization** (`normalizedZero_pole_power_closes`:
the multiplicity-power composite admits a CLOSED lift; `zero_pole_pair_closes_through_witness`
at tally 1). Therefore the representative type is an **actual indexed species**
(§4), with a nonsingular-path constructor and a power-closure constructor — never one
uniform record with commentary.

**Proposed `VObj` (minimal, per the ruling "only the analytic data required for typed
sources and targets"):**

```lean
/-- PROPOSED: the fibre state — an indexed species, no selected real register. -/
inductive VObj (A : ASection) : Type
  | state (X : ASection.NormalizedSlicePoint)                    -- S2 (S3 by constructors)
  | north (v : OnePoint ℂ) (hv : ∀ z : ℂ, v = (z : OnePoint ℂ) → z.im = 0)  -- S4
```

(S3 enters as `state (normalizedZeroSlicePoint n I)` — population, not a new species;
the register data of a state are READ by the bridge theorems, never stored as a
selected field.)

## §2 Transport generators (literal source → target; constructing theorem)

| Generator family | Source → target (literal) | Constructing theorem |
|---|---|---|
| vertical/directional | `I ⟶ ⟨g • I.val⟩` in SphereWorld; on states via equivariance | `dirHom`/`dirHomTo`; `normalizedZeroLift_equivariant`, `normalizedSectionPoint_equivariant`, `G2.smul_sliceEmbed` |
| band/phase | `I ⟶ I` per world | `bandHomAt`, `bandEnd` (with `bandMoebius_apply_zero`/`_infty`) |
| tape (translation channel) | δ 0 → δ 1 (δ pole-avoiding, F∘δ nonvanishing) with the 5-clause package | `gpvBase_transport` (FaithfulApply:122) |
| tape through degenerate stretches | real segments with negative values | `great_circle_lift_through_degenerate`, `great_circle_passage_total`, `degenerate_stretch_pins_band`, `real_segment_lift_neg`/`_pos` |
| cone/pole channel | real x near p₀ (both sides) | `pole_cone_eps_delta`, `cone_tape_escape`, `cone_junction_levels_shared`, `pole_degenerate_passages` |
| Euler–Weierstrass junction (a RELATION, not an arrow) | the two presentations of one transport | `stem_identity_logDeriv`; `euler_branch_ladder` |
| W1/W2 identity representatives | `GpvTransport A σ σ 0` | `GpvTransport.ofEulerHalfSpaceLoop`/`.ofLeftRegionLoop` |
| crossing/flip | crossing data at isolated real crossings; conjugated | `crossingData_of_isolated`/`_of_finite_obstruction`; `CrossingData.ofConj`(+`_isFlip`); the flip producers |
| north-pole legs | `normalizedZero n I` → S4 | `normalizedNLeg` (closure field = `normalizedZero_pole_power_closes`); `zero_pole_pair_closes_through_witness` |
| fibre paths (S5) | `sliceEmbed v ⟨log r,(2k+1)πi⟩` → same for w, −v | `exp_fibre_sphere_connected`, `exp_fibre_conj_joined`, `degenerate_passage` |

## §3 Presentation-invariant arrow labels

**What survives forgetting the representative (each with its invariance theorem):**

| Invariant | Why invariant |
|---|---|
| the geometric `SphereHom` component (rot, mob) | exact structural data (componentwise groupoid) |
| the winding `k : ℤ` | `stemWinding_eq_of_lift` (every lift computes the same k); `lift_ladder` (representatives differ by 2πik); `winding_defect_lift_independent`; `stemWinding_eq_of_homotopy` |
| the endpoints (X, Y) | typed |
| the multiplicity tally at zero species | `Nat.card` fibre; `fiber_tally_pos`; `sphereZero_fiber_finite` |
| the crossing/σᶜ class where the species carries crossings | `stemSignature`/`circularSignature` parity rows; `stemSignature_eq_circularSignature` |
| the component label of the base element (reflection channel) | pin `signDet` |

**Proposed label type (no real coordinate, no raw paths):**

```lean
/-- PROPOSED: the presentation-invariant arrow label. -/
structure VArrowLabel (A : ASection) (X Y : VObj A) : Type where
  leg     : SphereLeg X Y      -- the SphereHom data lifted to the species (north cases typed per S4)
  winding : ℤ
```

(Discrete junction/crossing labels attach per species inside the REPRESENTATIVE, where
the relations consume them; they enter the label only if a relation theorem requires
distinguishing arrows the pair (leg, winding) identifies — none currently does.)

## §4 The realization relation

```lean
/-- PROPOSED: the indexed representative species (raw analytic data live HERE). -/
inductive VTransportRep (A : ASection) : (X Y : VObj A) → VArrowLabel A X Y → Type
  | nonsingular   -- value/lift paths, ∀ t value t ≠ 0, lift_exp, endpoint compat, defect = 2πi·winding
      ... : VTransportRep A X Y f
  | powerClosure  -- zero/pole species: the multiplicity-power composite with CLOSED lift
      ... : VTransportRep A X Y f      -- per normalizedZero_pole_power_closes
  | fibrePath     -- S5 legs: the certified degenerate-fibre paths
      ... : VTransportRep A X Y f

def VRealizes (A : ASection) (X Y : VObj A) (f : VArrowLabel A X Y) : Prop :=
  Nonempty (VTransportRep A X Y f)

-- PROPOSED Hom, the certified precedent's pattern:
--   Hom X Y := { f : VArrowLabel A X Y // VRealizes A X Y f }
```

**Subtype vs quotient — compared against the precedent:** `GpvRealizes` +
`instGroupoidGpvBase` (Recovery:273/:276, CERTIFIED) implements exactly this subtype
pattern, and its groupoid laws reduce to ℤ identities. The invariance theorems (§3)
say the label is a complete invariant along each channel, so no quotient is indicated;
a quotient would become necessary only if a relation theorem identified DISTINCT
labels — none does. **Ruling proposed: the subtype pattern, following the certified
precedent, with the label enriched from `k : ℤ` to (leg, k).**

## §5 Relations and groupoid laws (literal vs retyping)

| Law | Proof source | Status |
|---|---|---|
| identity (nonsingular σ) | `GpvTransport.id`; `realizes_id` | literal (endpoint retyping O8) |
| identity (zero/pole/N species) | the power-closure constructor; `zero_pole_pair_closes_through_witness`; S4 conditional via `NonSingular ∞` | literal rows; species packaging new |
| inverse | `GpvTransport.inv`; `stemWinding_inv`; SphereHom inverses | literal |
| composition | `GpvTransport.comp` (k + k′); `stemWinding_mul`/`_finset_prod`; SphereHom comp | literal |
| associativity (label level) | ℤ addition; SphereHom assoc (componentwise) | literal instances |
| representative independence | `winding_lift_unique`; `lift_ladder`; `winding_defect_lift_independent`; `stemWinding_eq_of_homotopy`; `winding_loop_closed` | literal |
| junction compatibility (Euler = Weierstrass) | `stem_identity_logDeriv`; `euler_branch_ladder`/`_level` | literal |
| conjugation/flip compatibility | `CrossingData.ofConj_isFlip`; `conjLoop` rows; `bounce_conserves_band`/`flip_steps_band`; `sliceEmbed_neg_conj` | literal |
| winding normalization / uniqueness | `stemWinding_spec`/`_eq_of_lift`; `winding_loop_defect_level_zero` (the level face of closure) | literal |
| σ/σᶜ apparatus | the §2 register of EXHAUSTIVE_RELATION_INVENTORY (accepted) | literal |

## §6 The stabilizer representation

```lean
/-- PROPOSED signatures (no implementation). -/
def rhoObj (A : ASection) (h : ↥H) : VObj A → VObj A
def rhoMap (A : ASection) (h : ↥H) {X Y : VObj A} :
    (f : VHom A X Y) → VHom A (rhoObj A h X) (rhoObj A h Y)
theorem rhoOne (A : ASection) : ∀ X, rhoObj A 1 X = X ∧ HEq-free map clause
theorem rhoMul (A : ASection) (h₁ h₂ : ↥H) :
    ∀ X, rhoObj A (h₂ * h₁) X = rhoObj A h₂ (rhoObj A h₁ X) ∧ map clause
```

**Generator–relations table for H (affine class at 𝔫):**

| Generator | Normal form in H | Action on labels | Analytic realization | Cayley/Möbius expression | Joining theorem | Multiplication compatibility |
|---|---|---|---|---|---|---|
| translation t_b | class of [[1,b],[0,1]] | leg unchanged; winding by the channel's loops | the tape package (`gpvBase_transport`; degenerate stretches per the §2 rows) | `cayleyProjective` image; the w-leg of `distinguishedMoebius` | **O5-t (obligation)**: motion of the tape transport = the dictionary chart action | affine group law → `distinguishedCompW`/`CompPhase` cocycle + `winding_lift_unique` |
| dilation d_a (a > 0) | class of [[a,0],[0,1]] | leg unchanged; winding via cone loops | the cone/junction package (`pole_cone_*`, `cone_junction_levels_shared`, pole bridge) | dictionary image | **O5-d (obligation)** | same pattern |
| reflection r | class of [[−1,0],[0,1]] (`signDet` = −1) | mob conjugated (`conjLoop` register) | the crossing/flip package (`CrossingData.ofConj`, sign rigidity) | dictionary image; `sliceEmbed_neg_conj` as the value-side mirror | **O5-r (obligation)** | r² = 1 → two flips step-and-return (`flip_steps_band` twice) + uniqueness |

Status column is honest: the three joining theorems (O5-t/d/r) and the typed
normal-form maps (O6) are THE remaining construction obligations of the freeze; every
other cell is a literal certified row. ρ's laws then close: geometric component by
Möbius multiplication (`cayleyProjective_mul`; pin `comp_val` order), analytic
component by Law-3 uniqueness — as ONE definition whose two views are joined by O5.

## §7 Later colimit consumption (listed only — used NOWHERE above)

The arrows that will generate the finite zigzag through N, when — and only when — the
categorical proof runs on the finished A: the N-legs (`normalizedNLeg` per (n, I) with
the power-closure), the two-center annihilation (`two_center_winding_onto_one_band`),
the junction sharing (`cone_junction_levels_shared`), the vertical legs joining worlds
(`sphereWorld_zigzag`, `exp_fibre_sphere_connected`), and the ladder encounters
(`shared_ladder_encounters`). π₀, the Grothendieck construction, the colimit, the
singleton, and c appear at that phase and not before.
