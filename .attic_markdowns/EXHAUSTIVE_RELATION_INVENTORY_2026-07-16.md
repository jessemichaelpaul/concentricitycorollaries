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

# EXHAUSTIVE RELATION INVENTORY — the complete declaration search of record

**AUDIT REQUEST — check against ALIGNMENT points 20–23.**

**Prepared by:** Fable (kernel/greps, Desktop tree — canonical), 2026-07-16, answering
the complete-declaration-search directive: statements and referenced constants searched,
never names alone; clean AND legacy files; four-way reuse classification; nothing
discarded for an obsolete endpoint; no obsolete carrier imported. **The 𝒱/ρ freeze
table is produced ONLY after this document** (the directive's order, honored).

## §0 Method and completeness claim

- **Mechanical baseline:** `DECL_INDEX_2026-07-16.tsv` — every top-level declaration in
  every `Concentricity/*.lean` file, parsed with namespace tracking, **1053 rows, no
  name filter**. Every pass below reconciled its counts against it.
- **Six passes:** foundation/algebra (152/152) · slice/exp/worlds (126/126) · legacy
  carriers (86/86) · transport/junction (174/174) · weld/σ reconciliation (284
  extracted; 2 gaps identified as `private` helpers) · ζ-instance family (in flight —
  classified wholesale per the author's ruling, §5).
- **Axiom discipline:** rows already kernel-printed cite GREEN_LEDGER / the ρ-pass /
  the north-pole pass. Newly surfaced rows are printing NOW via the checked-in
  `_exhaustive_audit.lean` (~75 prints); the ledger updates when it returns.
- **Classification override rule (applied throughout):** agent-pass reuse labels were
  advisory only. This document's classifications follow the ruling of record — any
  declaration whose ENDPOINT TYPE mentions `A.Base`, `TotalA`, `BaseC`, `TotalTransport`,
  `TotalObject`, or old `functorA` is REPOINT (content recorded, exact retyping stated)
  or SUPERSEDED-FORBIDDEN (the old chain itself) — never DIRECT.

## §1 What the exhaustive pass ADDED (the incompleteness, confirmed and closed)

The author's and Codex's incompleteness claims were correct. The genuinely new
material, by location:

**InboxWire.lean — an entire unswept file of WINDING/GPV/JUNCTION rows (all DIRECT):**

| Row | Line | Content |
|---|---|---|
| `lift_ladder` | :73 | GPV Prop 4.3's FULL classification: two lifts of one path differ by exactly 2πik — the complete rung ladder |
| `ASection.euler_branch_ladder` | :113 | the k-th branch of log A right of the wall IS the Euler sum + 2πik (C2 ⟷ GPV weld, stated directly) |
| `ASection.euler_branch_level` | :146 | the branch-INDEPENDENT level right of the wall: (γ₂ t).re = (Σℓₚ).re = log ‖F‖ |
| `odd_rung_rigidity` | :187 | a continuous function taking only odd-rung values is constant (IVT rigidity) |
| `ASection.degenerate_stretch_pins_band` | :258 | **THE DEGENERATE STRETCH PINS THE BAND**: on a negative-real stretch every lift has ONE frozen odd rung, level = log ‖F‖ |
| `stemWinding_eq_zero_of_offReal` / `offReal_loop_every_branch_closes` / `ASection.offReal_value_loop_closes` | :305/:316/:341 | GPV Cor 4.4 stem + A-section forms: off-real loops wind zero; every branch closes |
| `ASection.sphereZero_norm_tendsto_atTop` / `sphereZero_im_tendsto_atTop` | :398/:422 | the divisor leaves every ball; **climbs the strip to N** (Im ρₙ → +∞) |
| `ASection.indices_below_height_finite` | :456 | N(T) well-defined for the whole class |
| `s2_component_exp_eq_iff` | :508 | **π₀(𝒮₂) ∘ exp = the level, as an iff** |
| `ASection.s2_value_class_halfSpace` | :553 | the realized value's component over the half-space IS exp of C2's Euler level |

**ConnectedBase.lean — the winding-groupoid LAW SET (legacy carrier; cargo REPOINT,
retyping: `A.Base`/`circleEmbed`/`Fstar` endpoints → the locked base register):**
`Realizes` (:88, the winding-k transport relation), `realizes_id` (:98), `realizes_inv`
(:120, reversal negates winding), `realizes_comp` (:145, concatenation adds windings),
`instGroupoidBase` (:191, functor laws from ℤ identities), `gpvBase_transport_star`
(:44, the 5-clause GPV package on the COMPACTIFIED stem), `Fstar_coe` (:32).

**Recovery.lean tail — THE ENRICHED GROUPOID, already built (REPOINT column):**
`GpvBase` (:266), `GpvRealizes` (:273 — arrow = winding label backed by a literal
GpvTransport representative; `Nonempty` deliberate), `instGroupoidGpvBase` (:276 — the
groupoid instance on winding labels), `gpvForget` (:296 — faithful forgetful functor to
the old base), `compactifiedSphereMap` (+`_val`, :306/:310 — A's point-level action on
each compactified slice sphere). **This is the closest existing ancestor of 𝒱's
morphism design.**

**LogManifold.lean tail — the E⁺ manifold engine completed (all DIRECT):**
the level-tape quartet (`level_tape_continuous` :162, `lift_level_tape` :189,
`lift_level_continuous` :201 — NO continuity of the lift assumed, `lift_level_unique`
:216), `lift_loop_level_closes` (:231), the manifold package (`Eexp`/`logManifold`/
`Llog`, L∘E = id :384, E injective :392, E∘L = id on the manifold :397, `re_Llog_of_mem`
:418 — THE LEVEL COMPONENT), the degenerate-fibre package (:428–:466), the passage
bundle (:617), the lift⟺continuation pair (:660/:683/:704), the segment lifts
(`real_segment_lift_neg`/`_pos` :259/:288 — odd rungs over negatives, even over
positives), **the passage-level readouts** (`zero_passage_level_atBot` :807 — the tape
runs to −∞ at zeros; `pole_passage_level_atTop` :845 — to +∞ at the pole;
`pole_degenerate_passages` :863; the two `*_passage_manifold_data` rows :1046/:1068 —
every encounter is a full S⁶ × ℤ at ONE level), and **`level_circle_meets`** (:1098 —
on the compactified level line, the pole end and every zero's end tend to the SAME
point ∞: the level circle closes at N as a theorem).

**IntegrateTheorem.lean tail (old-carrier typed — REPOINT; field inventories of the
first rank):** `GpvTransportWitness`/`GpvPopulated`/`gpvPopulated`/
`gpvPopulated_extends_populated` (definitional anti-vacuity pin)/`GpvPopulated.forget`/
`concentricity_transport_gpv`/`transport_universal_gpv`/`GpvZigzag`/`gpvZigzag`/
`gpv_zigzag_readout`, plus `not_concentric_iff_spread` (:423 — NOT concentric ⟺
infLevel < supLevel, the two-level contrast in the section's own coordinates) and
`two_level_apparatus` (:446 — Mode B assembled).

**FlipWeld.lean — the conjugation apparatus, first surfaced by name (DIRECT):**
`stemSignature_eq_circularSignature` (:246), `conjLoop`(+`_apply`,
`_obstructionSet`, :646–:654), `CrossingData.ofConj`(+`_t`, `_isFlip`, :662–:692 —
crossing data under conjugation, flips preserved), `crossingData_of_finite_obstruction`
(:234), `exists_flip_of_up_rung` (:504), the `eventually_*` band-side rows (:389–:439).

**Slice.lean — 45 previously unswept rows (DIRECT):** the `im`/`norm`/`dir`/
`sliceCoord`/`sliceEmbed` coordinate apparatus with its laws — reconstruction
`sliceEmbed_dir_sliceCoord` (:151), conjugation `sliceEmbed_neg_conj` (:182 — the
opposite direction sees the conjugate), the direction trichotomy (:165–:175, junk value
0 on ℝ — GPV Rem 2.1's honesty), `sliceCoord_sliceEmbed` (:161), and the G₂ isometry
block (`smul_re_normSq` :236, `smul_im` :300, `smul_dir` :306, `im_smul_ne_zero` :221).

**Foundation layer (152 rows, all DIRECT):** the `BasicTriple` frame machinery
(OctonionForm — 136 frame/multiplication lemmas culminating in `frameBasis`), G₂
transitivity THROUGH frames (`exists_smul_basicTriple` → S⁶ transitivity),
`sq_eq_neg_one_of_mem_unitImaginarySphere` (v² = −1: the algebraic seed of the −1
register), `normSq_mul`, `alt_left`/`alt_right`, StemRing with `real_on_real`.

**NormalizedBase new rows (DIRECT):** `normalizedZero_on_shared_circle` (:65),
`norm_sliceEmbed_sub_sliceEmbed` (:131 — worlds' readings differ by |Im z|·‖I−J‖: the
continuum collapses onto the shared circle at Im z = 0), `norm_sliceEmbed` (:137);
NormalizedAction's equivariance pair (:39/:48).

## §2 The σ/σᶜ register (the author's addition, 2026-07-16 — its own family)

The P-1 provenance register ("σ maps to ITSELF — σ = c from the winding; the level is
the flight's FIXED datum"), assembled from certified rows:

| The self-map of the level | Row | Location |
|---|---|---|
| the level closes on EVERY loop, unconditionally | `winding_loop_defect_level_zero` | LoopAssembly:107 |
| octonionic register | `lift_loop_level_closes` | LogManifold:231 |
| the cover lift's level IS a loop (2π-periodic under winding) | `IsLoopLift.level_periodic` | LogManifold:750 |
| the level is lift-independent | `lift_level_unique`; `winding_defect_lift_independent` | LogManifold:216; LoopAssembly:59 |
| the level IS the tape | `sweepE5_lift_level_tape`; `lift_level_tape`; `level_eq_log_norm_exp` | SweepE5:100; LogManifold:189/:176 |

| σᶜ computes the winding | Row | Location |
|---|---|---|
| the alternating-sum skeletons | `stemSignature`/`circularSignature` + parity rows | SigmaE3:623–:674; FlipWeld:257/:290 |
| σ-forms agree | `stemSignature_eq_circularSignature` | FlipWeld:246 |
| Cor 5.21's accounting (2π per unit) | `winding_height_shift` | SigmaE3:879 |
| σᶜ = 0 on tame sphere loops | `sphereLoop_sigma_c_zero` | WeldW3:327 |
| the {0, −1} auto-pass; odd count pins −1 | `stemSignature_mem_of_pos`; `stemSignature_eq_neg_one_of_odd` | SigmaE3:674; FlipWeld:316 |
| the two-level contrast | `sigma_level_separation`; `not_concentric_iff_spread` | SigmaE3:467; IntegrateTheorem:423 |

## §3 Winding / GPV / W1–W4 / C1–C4 — coverage statement

The weld/σ reconciliation pass confirmed: **every declaration in WeldW12/W3/W4,
FlipWeld, SigmaE3, LoopAssembly, SweepE5, SynthesisE6, KernelE4, PairingE2, LiKernel,
StemFactorization is now named in the companion documents or §1 above** (counts match
the index; the two apparent gaps are `private` helpers — SynthesisE6's four named
private lemmas and LiKernel's four — noted, not extractable by name from outside their
files). The four families' law-aligned tables live in PHASE1_RHO_LAWS_2026-07-15.md
(the nine ρ-laws), PHASE1_ACTION_TABLE_2026-07-15.md v2 (the four action levels), and
NORTH_POLE_FIBRE_INVENTORY_2026-07-16.md (the five 𝒱-blocks); this document adds §1's
new rows to those tables by reference.

## §4 Legacy carriers — content and exact retyping (nothing discarded, nothing imported)

| Carrier | Analytic/categorical content worth carrying | Exact retyping |
|---|---|---|
| `Realizes` + id/inv/comp + `instGroupoidBase` (ConnectedBase) | winding-labeled transport groupoid with laws | endpoints `circleEmbed`/`Fstar`/`NonSingular` → the locked base register; content = ρ-law cargo |
| `GpvTransport`(+laws) / `GpvBase`/`GpvRealizes`/`instGroupoidGpvBase`/`gpvForget` (Recovery) | THE enriched transport groupoid over winding labels | `σ : OnePoint ℝ` endpoints → `GreatCircle.Point`; the fibre-morphism design ancestor |
| `GpvTransportWitness`/`gpvPopulated`/`GpvZigzag`/`gpv_zigzag_readout` (IntegrateTheorem) | the assembled witness cargo + junction readout | `TransportWitness`/`transportClass` components → the new 𝒯_A register |
| `TransportWitness`/`Populated`/`populated`/`transportClass`/`toNHom` (TransportObject) | the closing-arrow/population pattern | `BaseC`/`TotalTransport` → locked carriers |
| `transportLevel` (Theorem:171) | `(sphereZero n).re` — DERIVED, never a field | carrier-free; carries over verbatim |
| `Base`/`TotalObject`/`levelClass` (Base.lean); `functorA`/`TotalA`/`poleGen` (AFunctor); the two sorried steps + old `concentricity` (ConcentricityReadout); `NormalizedZeroCone` | — | **SUPERSEDED-FORBIDDEN as dependencies of the locked proof** (GREEN_LEDGER 2026-07-16); analytic glosses recorded in the pass reports; not consumed |
| `value_const_on_component`/`realizes_value_eq`/`realizes_of_value_eq`/`shared_level_at_scale` (ConcentricityReadout) | value-conservation content (W-4 item) | typed on old `TotalA`/`Fstar` — content re-derived on the new carrier at freeze time, never cited from the old chain |
| KeystoneAssembly trio; KeystoneFinality rows | wrappers/dropped route | use the Toolkit/LoopAssembly originals directly |

## §5 The ζ-instance layer (the author's ruling, 2026-07-16)

Concentricity is a geometric theorem about A-sections. The ζ files
(ZetaSection/ZetaPole/ZetaOctonion/ZetaInfinitude/ZetaXiMatch/ZetaRealZeros/
ZetaDivisor/ZetaWeierstrass/ZetaAssembly/ZetaCstar/ZetaConj/ZetaStrip/
ZetaDensityCore/ZetaDensity/RhEquiv) are the INSTANCE layer — `zetaSection` proving
ζ ∈ the class, consumed ONLY by the corollary layer per COROLLARY_REWIRE_PLAN,
downstream of the theorem. **Classification: LATER-CARGO wholesale; zero rows enter
the 𝒱/ρ freeze supply.** The instance-family census pass appends its per-file counts
on landing; any row it flags as class-general (about every A-section) is pulled out
of the instance layer and reclassified — none is expected.

## §6 Named corrections and notices

1. **`liftPhase` does not exist as a Lean declaration** — design-register name only
   (the ALIGNMENT DETERMINE item stands; nothing is missing on disk).
2. `concentricity_via_faithfulApply` (FaithfulApply:557) and `concentricity_via_flipWeld`
   (FlipWeld:1176) are **comment-fenced route receipts, not live declarations** (the
   token census stands: 4 live sorries on disk, per the census of record).
3. `degenerate_stretch_pins_band` lives in **InboxWire.lean** (referenced from
   `gpvPopulated`; the reference is cross-file, which is how it evaded name search).
4. Agent-pass reuse labels were overridden per §0's rule; several passes had labeled
   old-carrier rows DIRECT and law lemmas IRRELEVANT — corrected here.
5. Axioms for §1's new rows: **KERNEL-VERIFIED COMPLETE — `_exhaustive_audit.lean`
   printed 77/77 clean (2026-07-16), zero name misses**: every newly surfaced row
   (InboxWire, the ConnectedBase law set, the enriched groupoid, the LogManifold tail,
   the IntegrateTheorem tail, the conjugation apparatus, the Slice coordinate laws, the
   foundation keys, the Normalized additions) depends on exactly
   `[propext, Classical.choice, Quot.sound]`. All rows entered GREEN_LEDGER the same
   turn. Every declaration cited anywhere in this document is now kernel-printed.

*Next act (the directive's order): the minimal freeze table for 𝒱 and ρ, drawn from
this inventory + the five 𝒱-blocks + the ρ-laws table, for the author's ratification.*
