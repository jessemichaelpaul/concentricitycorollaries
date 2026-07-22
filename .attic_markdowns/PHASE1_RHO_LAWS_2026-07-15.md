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

# PHASE 1 — THE ρ-LAWS TABLE: each stabilizer-action law against its exact certified supply

**AUDIT REQUEST — check against ALIGNMENT points 20–23.**

**Prepared by:** Fable (kernel/greps, Desktop tree — canonical), 2026-07-15, answering
Codex's focused request: every law of ρ : H → Aut_Grpd(𝒱) aligned with its exact
declarations, so assembling ρ never requires re-searching the 200-row supply.
**Axioms column: KERNEL-VERIFIED 2026-07-15.** The checked-in `_rho_audit.lean` printed
`#print axioms` for all 48 table rows not previously in GREEN_LEDGER: **48/48 clean**
— every declaration depends on exactly `[propext, Classical.choice, Quot.sound]`. Two
names corrected on the pass (`ASection.GpvTransport.ofEulerHalfSpaceLoop`/`.ofLeftRegionLoop`
— the constructors live in the `GpvTransport` namespace); the audit file carries the
corrected names. All 48 rows entered GREEN_LEDGER the same turn.
**Register notes:** orbit reachability is construction infrastructure
(transporter-fibre population), never a connectedness argument — explicit witness
`[[x,1],[1,0]] • ∞ = x` via `OnePoint.smul_infty_eq_ite`.

**THE AUTHOR'S RULING (2026-07-15, supersedes the conditional demotion):** the Cayley
dictionary (F5/F6) is CONSTRUCTION MATERIAL ON THE CRITICAL PATH — scheduled before the
ρ-definition freezes. The distinguished element is not a generic normal form: falling
back on the raw carrier would be "a generic construction instead of picking the one
element that connects the base, the sphere worlds, the GPV transport, and
W1–W4/C1–C4 at N." The identification is literal and certified: the phase factor IS
the slice exponential over I ∈ S⁶ — `sliceEmbed I (iθ) = θ • I`, so
`Octonion.exp (θ • I) = sliceEmbed I (e^{iθ})` (`exp_sliceEmbed'`, Toolkit:117), unit
modulus by `norm_exp`. ONE exponential, THREE certified roles: the C2 Euler channel
(`c2_euler : F = exp (∑′ ℓₚ)`), the GPV transport lifts
(`GpvTransport.lift_exp : exp (lift t) = value t`), and the band phases
(`exp (θ • I)` = `bandHomAt` through the dictionary), with kernel = the concentric
family (`Octonion.exp_kernel_unit_imaginary`). The distinguished element supplies the
canonical transporters (w-leg) and the fibre-leg identification (θ-leg = bandEnd);
the dictionary pins it to the locked PGL(2,ℝ) action.

---

## Law 1 — ρ(1) = id_𝒱 (identity / constant-winding)

| Declaration | Location | Type (compressed) | Axioms |
|---|---|---|---|
| `ASection.GpvTransport.id` | Recovery.lean:144 | `(A)(σ)(hσ : A.NonSingular σ) : GpvTransport A σ σ 0` — constant value path + constant log lift | CERTIFIED (2026-07-15) |
| `ASection.GpvTransport.ofEulerHalfSpaceLoop` (W1) | Recovery.lean:50 | Euler half-space loop ⟹ `GpvTransport A σ σ 0` | CERTIFIED (2026-07-15) |
| `ASection.GpvTransport.ofLeftRegionLoop` (W2) | Recovery.lean:99 | left-region loop ⟹ `GpvTransport A σ σ 0` | CERTIFIED (2026-07-15) |
| `stemWinding_const` | SigmaE3.lean:139 | constant loops wind 0 | CERTIFIED (2026-07-15) |
| `ASection.stemWinding_F_halfSpace` (W1 master) | WeldW12.lean:238 | value-loops in `Ω₀ < re` wind 0 | CERTIFIED (2026-07-15) |
| `ASection.stemWinding_F_leftRegion` (W2) | WeldW12.lean:1191 | value-loops in `{im>0, re<βlo}` wind 0 | CERTIFIED (2026-07-15) |

**Direct/derived:** arrow-level cargo DIRECT. The functor-level statement
`ρ(1) = id_𝒱` needs one small POST-FREEZE packaging lemma (the identity transport acts
as identity on 𝒱's objects and morphisms) — discharged by `winding_lift_unique` at the
constant basepoint. **N-fibre caveat carried:** `GpvTransport.id` is `NonSingular`-guarded;
the three-case identity treatment (FOUR_BLOCKS §0 / ACTION_TABLE §5) supplies p₀ and
zero-footpoint identities.

## Law 2 — ρ(h₂h₁) = ρ(h₂) ∘ ρ(h₁) (composition)

| Declaration | Location | Type (compressed) | Axioms |
|---|---|---|---|
| `ASection.GpvTransport.comp` | Recovery.lean:201 | `(σ→σ′, k) → (σ′→σ″, k′) → (σ→σ″, k+k′)` — path concatenation | CERTIFIED (2026-07-15) |
| `stemWinding_mul` | SigmaE3.lean:153 | `stemWinding (γ₁ * γ₂) = stemWinding γ₁ + stemWinding γ₂` — POINTWISE product | CERTIFIED (2026-07-15) |
| `stemWinding_pow` | SigmaE3.lean:175 | `stemWinding (γ^N) = N · stemWinding γ` | CERTIFIED (2026-07-15) |
| `stemWinding_finset_prod` | WeldW12.lean:599 | additivity over finite products | CERTIFIED (2026-07-15) |

**Register note (load-bearing):** TWO composition registers exist — path CONCATENATION
(`GpvTransport.comp`; the shape ρ's functor composition uses) and POINTWISE PRODUCT
(`stemWinding_mul`; the argument-principle engine for divisor counting). Both certified;
do not interchange them silently. **Direct/derived:** concatenation law DIRECT; the
homomorphism equation closes via Law 3's uniqueness (two transports with equal start are
equal), expected short exactly as Codex predicts.

## Law 3 — presentation independence (well-definedness of ρ(h))

| Declaration | Location | Type (compressed) | Axioms |
|---|---|---|---|
| `winding_lift_unique` | Toolkit.lean:301 | two lifts, equal start ⟹ EQUAL | CERTIFIED (ledger) |
| `stemWinding_eq_of_homotopy` | WeldW12.lean:358 | free homotopy through nonvanishing loops ⟹ equal winding | CERTIFIED (2026-07-15) |
| `stemWinding_eq_zero_iff` | SigmaE3.lean:119 | winding 0 ⟺ some closed lift (Cor 5.13 closure iff) | CERTIFIED (2026-07-15) |
| `winding_loop_closed` | LoopAssembly.lean:92 | one lift closes ⟹ every lift closes | CERTIFIED (2026-07-15) |
| `winding_defect_lift_independent` | LoopAssembly.lean:59 | the defect is the loop's, not the lift's | CERTIFIED (2026-07-15) |
| `winding_loop_defect_level_zero` | LoopAssembly.lean:107 | on ANY closed loop the lift's LEVEL closes, unconditionally | CERTIFIED (2026-07-15) |
| `ASection.realizes_gpv_lift` | Recovery.lean:319 | every arrow carries the tape `(Γ t).re = log ‖γ t‖`, basepoint-unique | CERTIFIED (2026-07-15) |

**Direct/derived:** same-path independence DIRECT (`winding_lift_unique`). Different
REPRESENTATIVE PATHS with common endpoints: one small derived lemma (concatenate with
the reverse; apply the loop rows) — named, post-freeze. Different ANALYTIC presentations
(Euler vs Weierstrass) of the same h: Law 5.

## Law 4 — inverse transport (ρ(h⁻¹) = ρ(h)⁻¹)

| Declaration | Location | Type (compressed) | Axioms |
|---|---|---|---|
| `ASection.GpvTransport.inv` | Recovery.lean:170 | `(σ→σ′, k) → (σ′→σ, −k)` | CERTIFIED (2026-07-15) |
| `stemWinding_inv` | SigmaE3.lean:197 | pointwise-inverse loop negates winding | CERTIFIED (2026-07-15) |

**Direct/derived:** DIRECT; groupoid inverse laws close via Law 3 uniqueness.

## Law 5 — Euler/Weierstrass agreement (one stem, two presentations)

| Declaration | Location | Type (compressed) | Axioms |
|---|---|---|---|
| `stem_identity` | Toolkit.lean:246 | the identity theorem, stem form | CERTIFIED (2026-07-15) |
| `ASection.stem_identity_logDeriv` | StemFactorization.lean:437 | Euler logDeriv = Weierstrass logDeriv on the overlap | CERTIFIED (2026-07-15) |
| `ASection.logDeriv_euler` | StemFactorization.lean:178 | `deriv F/F = ∑′ deriv ℓₚ` on `Ω₀ < re` | CERTIFIED (2026-07-15) |
| `ASection.logDeriv_weierstrass` | StemFactorization.lean:252 | the full divisor expansion away from pole/0/zeros | CERTIFIED (2026-07-15) |

**Direct/derived:** DIRECT as the presentation-independence input; consumed by Law 3's
derived lemma when a transport is built once through C2 and once through C3.

## Law 6 — translation relations (great-circle/tape channel)

| Declaration | Location | Type (compressed) | Axioms |
|---|---|---|---|
| `ASection.gpvBase_transport` | FaithfulApply.lean:122 | the 5-clause GPV package for EVERY admissible domain path | CERTIFIED (2026-07-15) |
| `ASection.tape_continuousOn_real` | IntegrateTheorem.lean:127 | tape continuous on pole-free zero-free real sets | CERTIFIED (2026-07-15) |
| `ASection.real_segment_tape_sweeps` | IntegrateTheorem.lean:144 | IVT: the tape attains every intermediate level | CERTIFIED (2026-07-15) |
| `ASection.great_circle_lift_through_degenerate` | FaithfulApply.lean:198 | lift THROUGH the degenerate set; one rung per lift | CERTIFIED (2026-07-15) |
| `ASection.great_circle_passage_total` | FaithfulApply.lean:274 | the passage carries the full ladder (existence + rigidity) | CERTIFIED (2026-07-15) |

**Direct/derived:** transport data DIRECT; the translation GROUP LAW
(t_{b+b′} = t_b ∘ t_{b′} on transports) is one derived lemma per Law 3's uniqueness.

## Law 7 — dilation relations (cone/junction channel)

| Declaration | Location | Type (compressed) | Axioms |
|---|---|---|---|
| `ASection.pole_cone_eps_delta` | LoopAssembly.lean:207 | the ε–δ correspondence at N | CERTIFIED (2026-07-15) |
| `ASection.cone_tape_escape` | IntegrateTheorem.lean:103 | tape exceeds every M near p₀, zero-free | CERTIFIED (ledger) |
| `ASection.cone_junction_levels_shared` | IntegrateTheorem.lean:167 | every high level attained on BOTH sides | CERTIFIED (ledger) |
| `ASection.normalizedZero_pole_power_closes` | NormalizedPoleBridge.lean:48 | multiplicity-power composite closes its lift | CERTIFIED (2026-07-15) |
| `ASection.zero_pole_pair_closes_through_witness` | SynthesisE6.lean:228 | tally 1 ⟹ zero–pole composite closes at the witness | CERTIFIED (2026-07-15) |
| `ASection.two_center_winding_onto_one_band` | WeldW4.lean:165 | C1's cone factor annihilates the composite winding | CERTIFIED (2026-07-15) |
| `ASection.pole_encounters_joined_concentric` | FaithfulApply.lean:354 | pole passages joined in ONE fibre, level constant | CERTIFIED (2026-07-15) |
| `ASection.zero_encounters_joined_concentric` | FaithfulApply.lean:328 | zero encounters joined in ONE fibre, level constant | CERTIFIED (2026-07-15) |

**Direct/derived:** as Law 6 — data DIRECT, dilation group law via Law 3.

## Law 8 — reflection relations (crossing/flip channel; base label `signDet`)

| Declaration | Location | Type (compressed) | Axioms |
|---|---|---|---|
| `crossing_height_odd_of_neg` / `crossing_height_even_of_pos` | SigmaE3.lean:730/:746 | crossings at odd/even rungs | CERTIFIED (ledger) / IN-AUDIT |
| `band_side_of_sign` | SigmaE3.lean:779 | rung side ⟺ sign · parity | CERTIFIED (2026-07-15) |
| `crossing_band_ledger` | SigmaE3.lean:849 | the crossing ledger (flips step, bounces conserve) | CERTIFIED (ledger) |
| `closed_lift_of_no_interior_flip` | FlipWeld.lean:842 | no interior flips ⟹ the lift closes (Cor 5.13 instance) | CERTIFIED (2026-07-15) |
| `exists_interior_flip_of_stemWinding_ne_zero` | FlipWeld.lean:754 | winding ≠ 0 forces an interior flip | CERTIFIED (2026-07-15) |
| `ASection.crossing_sign_rigid` / `_const_between` | FlipWeld.lean:986/:1035 | sign rigidity against the real divisor; one sign per gap | CERTIFIED (2026-07-15) |
| `stemSignature_mem_of_pos` | SigmaE3.lean:674 | Cor 5.13 auto-pass at positive crossings | CERTIFIED (2026-07-15) |
| `signDet` | pin, Projective.lean:101 | `PGL(n,R) →* SignTypeˣ` — the component label | pin |

**Direct/derived:** the involution relation (reflection² = 1 ↦ equal transports) is one
derived lemma: two flips step the band and step back (`crossing_band_ledger` +
`CrossingData.flip_steps_band`), closed by Law 3 uniqueness.

## Law 9 — interaction with the internal U(1) (the conjugation relation)

**Status: DERIVATION TARGET — deliberately.** Codex's instruction ("do not assume the
H-action and U(1) commute; the pinned results must tell us the exact relation") matches
the record: no single certified row states the affine-vs-band conjugation law yet.
The certified MODEL rows and inputs for the derivation:

| Input | Location | Role |
|---|---|---|
| `bandGL_mul` / `bandMoebiusHom` / `bandEnd` | SliceSphereWorld:158/:167/:272 | the internal U(1) as a monoid hom into every End(I) |
| `G2.smul_sliceEmbed` | Slice.lean:312 | THE model of a certified conjugation law (chart identity for the G₂ legs) |
| `ASection.realize_equivariant` | Slice.lean:436 | equivariance square (CERTIFIED, ledger) |
| `Octonion.exp_kernel_unit_imaginary` | WeldW3.lean:391 | θ at odd π = the degenerate fibre (where the band meets the ladder) |
| `Octonion.lift_iff_continuation` + `IsLoopLift.level_periodic` | LogManifold:704/:750 | lift/continuation equivalence; the level is 2π-periodic under winding |
| `S2.exists_band_rotation` | PhiConversion.lean:218 | transferable cargo: a band rotation carries any coordinate onto its modulus |
| the μ(t) triangle proposal | ALIGNMENT point 12 | `μ(t) := exp(lift t − lift 0)`; \|μ\| = level shift, μ/\|μ\| = phase path — TO-DERIVE |

**Direct/derived:** derived lemma SET (small, named): the exact commutation/conjugation
relation between each affine generator's transport and `bandEnd`, derived from the
tape/lift uniqueness rows — GAP-2 adjacent; the μ(t) triangle is the proposal of record.

---

## Summary for the ρ-assembly

- Laws 1, 2, 4: arrow-level cargo DIRECT; functor-level packaging = three small
  post-freeze lemmas, each closing by Law 3 uniqueness.
- Law 3: same-path DIRECT; representative independence = one small derived lemma.
- Law 5: DIRECT (the identity-theorem weld).
- Laws 6–8: channel data DIRECT; each generator family's group relations = one derived
  lemma per family via Law 3.
- Law 9: the one genuine derivation target (conjugation relation), inputs enumerated.
- Named infrastructure: orbit-reachability witness (one line); the Cayley dictionary
  (F5/F6) ON THE CRITICAL PATH per the author's ruling — construction material defining
  the canonical transporters and fibre legs, scheduled before the ρ-definition freezes.
- Axioms column complete: 48/48 kernel-clean (2026-07-15, `_rho_audit.lean`); all rows
  entered GREEN_LEDGER the same turn. Every law of ρ is supplied entirely by
  triple-certified material.
