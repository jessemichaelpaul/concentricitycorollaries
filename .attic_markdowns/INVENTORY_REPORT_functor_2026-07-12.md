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

# INVENTORY REPORT — the functor phase (compiled 2026-07-12, the 2026-07-11-late session; Fable, for Codex and the author)

*Purpose: the verified inventory the A-functor design builds on. Every tier claim below
was produced by an actual kernel pass (`lake env lean _ledger_audit.lean`, plus direct
file elaborations where noted) — GREEN_LEDGER.md holds the rows. The contamination
boundary is drawn per the author's rule: results proved over objects other than the
locked 𝓑 (`GreatCircle.Base`) and `SphereWorld` cannot feed the main theorem.*

## §1 The locked objects

- **𝓑 = PGL(2,ℝ) ⋉ OnePoint ℝ** — `GreatCircle.{Point, Aut, scalar_smul,
  instMulActionAutPoint, mk_smul, Base, groupoid}` (ProjectiveBase.lean; commit
  `be198af`, Codex tree; file content identical in both trees). All rows CERTIFIED,
  independently re-audited. Section-independent by design (ALIGNMENT points 17–19).
- **SphereWorld** (SliceSphereWorld.lean:194) — objects are literally the imaginary
  directions `{v // v ∈ unitImaginarySphere}` = S⁶; `bandEnd : Circle →* End I` (:272);
  ambient `Moebius ≤ Perm (OnePoint ℂ)` with the `Moebius.of : GL(2,ℂ) →` door (:92/:96);
  the G₂/equivariance layer CERTIFIED (`realize_equivariant`, `G2.smul_sliceEmbed`,
  `sliceCoord_smul_invariant`).
- Level table of record: ALIGNMENT point 18 (base ↛ analytic data; fibres carry I ∈ S⁶
  and G₂ arrows; 𝒯_A carries the pairs and the riding transports; π₀/colim reads).

## §2 The Euler-down picture — CERTIFIED, base-agnostic

The degenerate exponential family read down through C2, each seam a kernel row:

| Fact | Row | Tier |
|---|---|---|
| exp w = −r ⟹ Re w = log r (the level) | `exp_fibre_level` LoopAssembly.lean:161 | CERTIFIED |
| negative real value ⟹ lift height (2k+1)π (the odd rung) | `crossing_height_odd_of_neg` SigmaE3.lean:730 | CERTIFIED |
| rung shifts = winding | `winding_height_shift` SigmaE3.lean:879 | CERTIFIED |
| strip-side ledger at crossings | `crossing_band_ledger` SigmaE3.lean:849 | CERTIFIED |
| the pole loop winds −1 (C1's anchor) | `stemWinding_circle_pole` SigmaE3.lean:895 | CERTIFIED |
| no closed lift around a sphere zero | `no_closed_lift_around_sphereZero` SigmaE3.lean:983 | CERTIFIED |
| both zero neighbourhoods attain a common −r at every scale | `shared_ladder_encounters` LoopAssembly.lean:271 | CERTIFIED |
| near the C1 pole the log-level exceeds every M — the **value-∞ (+∞) approach to N**, distinct from the ladder's log r → −∞ end (r→0⁺, C3 side); both ends compactify to N, distinguished before compactification (corrected 2026-07-12, Codex #2) | `cone_tape_escape` IntegrateTheorem.lean:103 | CERTIFIED |
| every high level attained both sides of the pole | `cone_junction_levels_shared` IntegrateTheorem.lean:167 | CERTIFIED |

−1 register map (MINUS_ONE_DOSSIER): **value / U(1) half-turn / ℤ rung** are certified
with their three bridges; the **σ (signature) register is the open one** — see §4.
`shared_ladder_encounters` is an ∃r statement: the encounter choice is NOT canonical
(ALIGNMENT point 7); the encounter-relations DETERMINE item stands.

## §3 The GPV canonicity cluster — sources banked, core already kernel-certified

**Sources** (SOURCES/GPVwind.md, Section-4 top-up, 2026-07-11): Prop 4.2 (lift ⟺ log
continuation), **Prop 4.3** ("there exists ONE, AND ONLY ONE, lift Γ_k … the UNIQUE
continuation"), Cor 4.4, Prop 4.12/Cor 4.13 (the companion case, ℤ-indexed branches),
Def 4.7 (tame = unique companion), Rem 4.16 (slice paths carry the constant companion;
twisted loops must cross ℝ), Thm 4.27 (winding classifies untwisted tame loops up to
c-homotopy). **Provenance policy (the author's ruling) satisfied**: double-sourced — the
ar5iv fetch (byte-identical to the recorded provenance) AND the inbox PDF (Prop 4.3
wording verified identical by direct text extraction; the inbox copy is the authors'
30-page manuscript layout). JMAA journal-typeset numbering remains unverified
(publisher 403) — the caveat rides, nothing rests on it.

**Kernel-first: the stem-level core is ALREADY proved in-repo to the triple cert:**

| GPV statement | In-repo stem analog | Tier |
|---|---|---|
| existence (4.2/4.12) | `exists_log_continuation` Toolkit.lean:274 | CERTIFIED |
| uniqueness given initial value (4.3) | `winding_lift_unique` Toolkit.lean:301 | CERTIFIED |
| loop version | `KeystoneAssembly.value_loop_lift_unique` :52 | CERTIFIED\* |
| the winding computed by any lift | `stemWinding_spec` SigmaE3.lean:86 | CERTIFIED |
| every lift computes the same k | `stemWinding_eq_of_lift` SigmaE3.lean:98 | CERTIFIED |

\* by direct elaboration — the file is an UNIMPORTED artifact importing the contaminated
old Base.lean. **Resolution (Codex #4, adjudicated 2026-07-12): it is a wrapper around
the already-certified `winding_lift_unique`; use the Toolkit theorem directly — no
salvage needed unless the loop-specific name clarifies the final API. Do not import
KeystoneAssembly.**

**Register note**: the hypercomplex companion layer reduces at stem level — GPV Rem 4.16
gives slice paths the constant companion, and Wang Rem 2.11's one I-independent real stem
is the project's register; companion subtleties survive only at real crossings (flips),
which the certified crossing suite already governs on the −1 side.

**The canonicity chain for `A.map` (Codex's level assignment, now sourced and mostly
certified)**: unique companion (tame; free for stem paths) → unique lift given the
initial value (`winding_lift_unique` — CERTIFIED) → the rung canonical
(`stemWinding_eq_of_lift` — CERTIFIED) → the triangle certifies section-evaluation
compatibility (`GpvTransport.lift_exp` — CERTIFIED field) → W1–W4 supply id/inv/comp.

## §4 The actual remaining gaps (the functor phase's named obligations)

1. **GAP-1**: Cor 5.13's signature criterion (loop lift exists iff σ ∈ {0,−1} per
   obstruction interval) — no in-repo analog found. Flags attached: Cor 5.21 carries the
   printed evenness hypothesis; the paper's name for σᶜ is "circular signature."
2. **Thm 4.27** (winding classifies loops up to c-homotopy) — no in-repo analog; an
   obligation ONLY if the fibre-arrow class is taken as homotopy class rather than the
   lift record itself. A fibre-Hom design input for 0.3, not automatically work.
3. **G₂ fixed-locus converse** (fixed by all of G₂ ⟹ real): forward direction CERTIFIED
   (`G2.smul_ofReal`); converse absent from the repo. **DESIGN-DEPENDENT (Codex #5,
   adjudicated 2026-07-12)**: needed only if the conserved readout is first constructed
   octonion-valued and then proved real; if the normalized state carries a real label
   from the outset (the theorem-of-record design), the converse is unnecessary.
   (Baez pin: G₂ ↷ S⁶ transitively, if ever consumed.)
4. **The fibre-Hom record constraint**: no endpoint truncation — `Realizes`'s `Nonempty`
   (H3) and `SphereHom.mob`'s endpoint field (point 6) are the two recorded deficiencies;
   the fibre arrow carries the GPV record (`GpvTransport` fields are CERTIFIED and typed
   over the carrier — the cargo rides as-is).
5. **N's arrows**: `GpvTransport`'s fields exclude singular endpoints (nonvanishing,
   finite compactified values) — N's identity and arrows are their own design item
   (point 3), confirmed at field level.
6. **μ naturality suite** (points 12/17, B3b): μ(t) = exp(lift t − lift 0) codomain-free;
   its interactions with the two base channels, the two sphere-world families, C1–C4,
   W1–W4, and composition/inversion are typed lemmas to derive.
7. **The compactified pole representation (Codex #6, CONFIRMED at definition level
   2026-07-12)**: `Fstar` (ConnectedBase.lean:26) sends every finite point to
   `↑(A.F z)` — including the C1 pole, where the raw stem value rides instead of ∞. The
   honest compactified section map must send `↑(A.pole) ↦ ∞` before GPV transport through
   the C1 anchor can be typed. A named repair, prior to `A.map`.
8. **The A.map determination (Codex #7 — the design gate's sharpest form)**: C1–C4 do
   not state blanket PGL-equivariance; for an arbitrary base arrow `f : b → b'`,
   `A.map f` is one of — reindexing of normalized states along the base action / an
   analytically extracted transport / a restriction to the channels the section
   realizes / cargo-canonical reindexing. The 0.3 ruling decides; the register ruling
   (§8) favors the cargo-canonical option.

## §5 Safe inventory (feeds the functor)

- **Stem/path analytics, base-agnostic**: the SigmaE3 crossing/winding suite, the
  LoopAssembly ladder/level rows, the Toolkit lift rows, the IntegrateTheorem cone rows
  (§2–§3 tables), `neg_reals_swept_near_sphereZero` and neighbours.
- **Over SphereWorld (locked)**: the NormalizedBase rows (labels world-independent,
  collapse at N, lift norms), `bandEnd`, the equivariance layer, `normalizedZero` data.
- **Over the carrier**: `GpvTransport` + laws (id/inv/comp) + W1/W2 constructors
  (`ofEulerHalfSpaceLoop` Recovery.lean:50, `ofLeftRegionLoop` :99) + the C1/C3 closures
  (`normalizedZero_pole_power_closes`, NormalizedPoleBridge.lean:48).
- **The analytic package**: `ASection`/`zetaSection` (CERTIFIED), the continuation
  package (ZetaPole), `riemannZeta_nontrivialZeros_infinite` (CERTIFIED, proved in-repo).
- **Over legitimate domain objects, role pending the naming table**: `H1 := ActionCategory
  G2 (OnePoint Octonion)` (G2.lean:231 — the master's 𝓗₁, same construction register as
  𝓑) and the Φ-register `sectionFunctor` (PhiConversion) — NOT contaminated; their reuse
  under the one letter A is a point-14 naming decision.

## §6 Contaminated (cannot feed the theorem as-is)

| Object | Location | Status/fate |
|---|---|---|
| `ASection.Base` (NonSingular-restricted) + `Realizes` | ConnectedBase.lean:83/:88 | superseded by 𝓑; protected-not-deleted; naming table |
| `Base := Discrete ℝ × SingleObj G2` + `TotalObject` | Base.lean:42/:61 | old static era; slated deletion per the standing refactor plan; still imported by root |
| `TotalTransport` | TransportObject.lean:85 | old thin transport; slated deletion |
| glued-transport tail (GLUEDTRANSPORT, `transportToGlued`, …) | SliceSphereWorld.lean tail | old-register prior art for ∫A's seams; audit-and-repoint, never silent reuse |
| `functorA` / `TotalA` / `readout` + ConcentricityReadout chain | AFunctor.lean, ConcentricityReadout.lean | over old `A.Base`; SORRY-GATED at the theorem end; superseded, fates via naming table |
| KeystoneAssembly / KernelE4 / SynthesisE6 artifact family | unimported files | salvage rows individually (e.g. `value_loop_lift_unique`), never import wholesale |

## §7 Order of record (unchanged)

Base groupoid (LOCKED) → **A-functor conceptualization** (now: inspect SphereWorld
against the kernel — largely done above; sketch one generic total morphism (b,x) → (b′,x′);
freeze the fibre Hom type) → repoint theorems → total object. Look ahead to 𝒯_A only.

## §8 The register ruling and the adjudicated corrections (2026-07-12, three-way)

**The proof-organization ruling (the author, ratifying Codex's diagnosis).** The failure
mode: organizing the analytic inventory as a PRE-COLIMIT proof of pairwise zero
identifications ("enough transports to show [Z_{n,I}] = κ", or worse, "the one map that
pins all spheres to one centre") — that reduces the Grothendieck machinery to
bookkeeping, and it is backwards. **The colimit performs the identifications** (Riehl
Rem 8.3.5 + the category-of-elements computation π₀(el X) ≅ colim X, checked against the
local inbox Riehl PDF): the arrows OF THE DIAGRAM generate exactly the colimit's
identifications. The corrected burden, in order:

1. A is a genuine functor (canonicity from the certified stem cluster, §3);
2. the fibres are populated by the normalized A-states (C4 = the infinite population);
3. fibre structure from the retained SphereWorld — the cargo design keeps its
   connectivity available (favors points/values-as-cargo in the 0.3 fork);
4. the real coordinate is a NATURAL datum: `r_b : Obj (A b) → ℝ` preserved by fibre
   morphisms and by every base transport (`r_{b'} (A.map f x) = r_b x`) — a compatible
   cocone on π₀∘A, which then **descends through the colimit automatically**;
5. C1–C4/W1–W4 discharge the preservation and population obligations — never a checklist
   for pairwise zigzags.

**The safeguard (both directions honest)**: a connected base with a constant connected
fibre is trivially connected independent of C1–C4 — the old substitute failure. The
construction is honest only because the objects are A's states, A.map is induced by the
section, the coordinate comes from the states, its preservation is proved from
C1–C4/W1–W4, and the zeros enter through the population. The zigzag engine
(`toColimitObj_eq_of_zigzag`, CERTIFIED) remains the generic Lean mechanism certifying
the colimit identification — the correction is about proof ORGANIZATION, never about
the engine.

**The seven corrections, adjudicated**: #1 stale ledger counts — GENUINE (Fable's
mid-flight bookkeeping); recounted, 35 · 0 · 6, pending list cleaned. #2 the two
approaches to N have opposite level signs — GENUINE (a gloss conflation in the chat and
ledger, statements were always correct); fixed in both. #3 stem-lift certified vs
hypercomplex tameness — PRECISION, no discrepancy: the Rem 4.16/Wang reduction is source
guidance, not a certified row; the typed bridge is functor-phase work only if a design
choice consumes it (the author: the full hypercomplex setting is likely unnecessary).
#4 KeystoneAssembly — GENUINE and confirmed by the root import graph (the audit line
errored "unknown constant"): use `winding_lift_unique` directly, do not import. #5 G₂
converse — ALIGNED: design-dependent obligation, both statements agree. #6 the Fstar
pole representation — GENUINE, confirmed at the definition (§4 item 7). #7 the A.map
determination — AGREED, banked as the design gate's sharpest form (§4 item 8).

**The sync diagnosis (why the threads talked past each other)**: chat ≠ repo. The
inventory findings lived in chat while banking was interrupted twice (a computer restart
killed a background kernel run silently; a session boundary hit mid-ledger-update); a
turn that ran post-restart wrote this report and fixed the audit file WITHOUT its
transcript being visible to any thread — so no thread could vouch for the disk state,
and Codex correctly audited the deltas. Protocol, banked as ALIGNMENT point 20: (i) no
tier claim outside GREEN_LEDGER.md — reports cite ledger rows, never fresh claims;
(ii) after any interruption, first act = rerun `_ledger_audit.lean` and diff against the
ledger; (iii) every banked edit syncs to both trees in the same turn it is made.
