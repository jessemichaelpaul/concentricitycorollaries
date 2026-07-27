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

# THE THEOREM OF RECORD AND ITS BUILD — outline ↔ canyon ↔ objects

*2026-07-11 (Fable, from the author's outline of this date; companion to
COMPARISON_INVENTORY.md, whose Rules 1–5 and design principle bind everything below).
All quotes verbatim; nothing from memory.*

---

## §1 The three texts, side by side

**The agreed refined statement (2026-07-11 — the author's outline as jointly reformulated
with Codex; provenance correction of record, same date: this text is the *refined*
formulation, NOT the author's original outline verbatim — the original ran
section-of-R → the groupoids and the functor → the colimit/Grothendieck argument, and is
preserved by the proof plan of record quoted below):**

> **Concentricity Theorem.** Let A be a section of the ring R of slice-preserving functions
> on 𝕆* satisfying C1–C4. Then the infinitely many C-residue zero spheres of A belong to one
> connected component of its enriched total section transport. The real-center coordinate
> carried by the section functor descends to this unique component class, which therefore
> carries one real value c. Equivalently, every C-residue zero sphere has real center c.

*(D1 prose note: "this unique component class" reads as "their common component class" —
the ∃κ form; the statement never claims `Subsingleton (π₀ T_A)`.)*

**The master's `thm:concentricity` (Octonionic_RH_master.tex:1143, verbatim):**

> Let A be an A-section (Definition def:A-section). Then the infinitely many residue-ℂ zero
> spheres of A all lie in a single connected component of the total object 𝒯_A (Definition
> def:base) — equivalently, they have one and the same image in π₀(𝒯_A).

**The proof plan of record (the author, 2026-07-07, verbatim; Theorem.lean:237):**

> 1. A is a member of the ring 𝓡 of slice-preserving functions on the octonions, with
>    properties C1–C4.
> 2. THAT IMPLIES THE GPV-BASE — which has everything: σ = c, unique winding, the
>    *concentric* fibres and their connection.
> 3. The concentricity OF THE GPV BASE is EXTENDED to the concentricity of the infinitely
>    many ℂ-residue spheres of the A-section, which land in a connected component.

**The alignment:** the outline = the master's statement, with two changes and no loss —
(i) the total object is the **enriched** transport (this audit's object correction:
`T_A = ∫_{B_A} F_A` on the corrected base and pointed fibre), and (ii) the center clause is
**promoted into the theorem statement** (previously the readout stood outside it). The
ordering — component class first, pointwise equalities last — is the canyon ordering, and it
matches the proof plan's own order: base (2), then extension into one component (3).
The master's statement is the **∃κ form** ("one and the same image"), not
`Subsingleton (π₀ T_A)` — see ruling D1.

## §2 The two-level formal statement

**Primary (integrated) theorem — the theorem of record:**

```
∃ κ : π₀(T_A), ∃ c : ℝ, ∀ n (I : SphereWorld), [Z_{n,I}] = κ ∧ center (Z_{n,I}) = c
```

**API corollary (zero content — a projection):**

```
theorem zero_real_parts_common (A : ASection) :
    ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c
```

Resolved points (no ruling needed):

- **center is not a total function** (Rule 2, heterogeneous data): `center (Z_{n,I})`
  compiles to the *label field* of the zero object — `(A.normalizedZero n I).label` — which
  is **definitionally** `(A.sphereZero n).re` (`label_zero : label = (A.sphereZero n).re`,
  GREEN, NormalizedBase.lean). Codex's "center(Zₙ) reduces to Re(ρₙ)" is literally `rfl`
  on the built objects. Hence the pointwise corollary is *contained* in the integrated
  theorem; its proof is a projection, never a separate analytic argument.
- **Why the corollary is kept at all**: `Corollaries.lean` (`cor:nontrivial`, `cor:rh`)
  consumes exactly the pointwise shape today. The corollary is the API seam that keeps the
  famous consequence a two-liner without unpacking the Grothendieck construction.
- **World-independence inside the statement**: the zeros are addressed as `Z_{n,I}` over all
  worlds; their common class over `I` is part of what the built connectivity must deliver
  (fibre zigzags via G₂ — F1), so the statement quantifies over `I`.

**Rulings — RESOLVED (Codex 2026-07-11 evening, author-ratified):**

- **D1 — RESOLVED: the ∃κ form.** All zero spheres share one component class; no claim
  that every object of the whole Grothendieck construction belongs to it. Prose says
  "their common component class," never "the unique component class."
- **D2 — RESOLVED: plain proposition, name on the integrated theorem.**
  `def ConcentricityStatement (A : ASection) : Prop := ∃ κ, ∃ c, ∀ n I, zeroClass A n I = κ
  ∧ zeroCenter A n I = c`; `theorem concentricity (A) : ConcentricityStatement A`.
  Named projection lemmas `zero_classes_common` and `zero_real_parts_common` (existential
  eliminated locally — no `Classical.choice`). No structure packaging (avoids the theorem's
  packaging being mistaken for another constructed analytic object). `Corollaries.lean`
  rewired ONCE to consume `zero_real_parts_common` — the categorical theorem, not its
  scalar shadow, carries the name `ASection.concentricity`.
- **D3 — RESOLVED: master untouched until green.** The proposed language is prepared but
  applied only after the corrected functor, total object, integrated theorem, and pointwise
  projection all build — "prevents the prose from outrunning Lean again."

## §3 Clause-by-clause match: outline → proof plan → canyon → objects → rows

| Outline clause | Proof-plan clause | Canyon register | Build object | Inventory rows |
|---|---|---|---|---|
| "section of the ring R … satisfying C1–C4" | (1) | the analytic layer | `ASection` | GREEN (ASection.lean) |
| "enriched total section transport" | (2) | the rivers assembled | `T_A = ∫_{B_A} F_A` | GAP-3 (arrow type), G2, D4 |
| "infinitely many C-residue zero spheres" | (3) input | the fleet | `normalizedZero n I` + `c4_infinite` | G1-obj GREEN |
| "belong to one connected component" | (3) landing | confluence — derived, never inserted (Rule 1) | zigzags of the built action; engines H1/H2 | H1 GREEN; H2 = generic lemma TO-LOCATE or prove for the corrected construction (Codex: the old green singleton was the thin transport's); connectivity = derived |
| "real-center coordinate carried by the section functor" | (2) "concentric fibres" | object data + arrow preservation field (Rule 4) | label field + `EnrichedHom` preservation | G1-obj GREEN; A4 prototype; GAP-3 |
| "descends to this unique component class" | (3) extension | π₀ quotient-recursion — bookkeeping | `value_const_on_component` pattern | A4 GREEN (prototype) |
| "carries one real value c" | (3) | c plucked at the end: **c := Re(ρ₀)** (Rule 2) | the integrated theorem's ∃c | — |
| "equivalently … real center c" | — | the API projection | `zero_real_parts_common` | definitional (label_zero) |

## §4 The build, object by object

### 4.1 `B_A` — the GPV base groupoid (proof-plan clause 2: "has everything")

- **Objects**: the full compactified great circle (`OnePoint ℝ`, N included as object —
  carrier only; no thin-cone arrows ride along, no label on N per Rule 2).
- **Arrows**: the enriched section transports — the GAP-3 arrow type, germ `GpvTransport`
  (domain path, value path, log lift, winding; `id`/`inv`/`comp` GREEN), extended with:
  the preservation field (Rule 4) and the retained cargo (past `GpvRealizes`'s `Nonempty`
  truncation, whose fate the arrow-type ruling decides — H3).
- **Constructors already literal (GREEN)**: W1 `ofEulerHalfSpaceLoop` (C2's Euler
  half-space), W2 `ofLeftRegionLoop` (left region), and the C1/C3 composite closures
  (`normalizedZero_pole_power_closes` — composite material, never primitive legs, Rule 1).
  The value-coincidence arrows (`realizes_of_value_eq`) are a **candidate only, subject to
  audit** (Codex's correction): an arrow created solely from equality of endpoint values
  may again be a substitute for the actual section transport — admit only after checking
  against the intended path/lift cargo.
- **The clause-2 content carried**: "σ = c, unique winding" quoted as the author's words
  from the proof plan of record — **inventory task P-1 (Codex's correction): determine
  what σ and c denoted in that document before any use**; the GPV signature σ, the real
  center c, and integer winding are different registers, and nothing currently justifies
  reading "σ = c" as a cross-register identification. Unique winding = GPV unique tame
  lift (F4, canonicity of extraction). The concentric fibres (B1 `exp_fibre_level` — one
  level per fibre) with the ladder (B2) as **analytic support toward** their connection —
  support, not yet the categorical connection.

### 4.2 The ONE sphere-world groupoid 𝒮₂ (the fibre side — author's correction, 2026-07-11)

- **The author's ruling of record**: each sphere is NOT a groupoid unto itself. 𝒮₂ is **one
  groupoid** — infinitely (continuously) many objects (the slice spheres `S²_I`, `I ∈ S⁶`),
  G₂ morphisms *between* worlds, infinitely many Möbius automorphisms *within* each world,
  a distinguished copy of U(1) in every `End(I)` (`bandEnd`, GREEN). The existing
  `SphereWorld` already has exactly this shape — retained.
- **Points: objects or cargo? — an explicit 0.3 decision (Codex's correction).** Two
  levels exist: `SphereWorld` (objects = whole spheres) and `NormalizedSlicePoint`
  (sphere + a point on it). The author's picture suggests the categorical fibre may be the
  sphere-world level, with the normalized zero realizations and section values as
  **structured cargo** on objects and arrows, rather than every point a separate object.
  Do NOT automatically promote `NormalizedSlicePoint` to a groupoid; decide in the
  arrow/object ruling (Phase 0.3). Zeros' data stays GREEN either way
  (`normalizedZeroSlicePoint`, labels, equivariance).
- **The circle discipline**: worlds coincide on the shared circle and diverge by exactly
  `|Im z|·‖I−J‖` (B3, GREEN); the band fixes the two shared points in every world (D2 rows).
- **N's three appearances stay in three types** (base circle's N; each sphere's ∞; the
  compactified 𝕆*'s N): the enriched functor provides their compatibility — never a
  definitional identification, never arbitrary arrows.

### 4.3 `F_A` — the A-section functor (the author: "a TON of content")

The functor is **extraction, with no free parameters**: object action = the section's own
point action (`normalizedSectionObject`, GREEN, world-preserving); morphism action extracted
from each transport's certified cargo; `map_id`/`map_comp` from the transport laws.
The TON, enumerated — what the functor carries and where each piece enters:

- **C1**: the pole anchor and its winding −1 (C1 row); the cone junction rows
  (`cone_tape_escape`, `CONE_JUNCTION_LEVELS_SHARED`) as the junction's analytic support.
- **C2**: the Euler transports (W1/W2 constructors), zero-freeness on the half-space.
- **C3**: the Weierstrass divisor, multiplicity-corrected closure (C2-row), the enumeration
  `sphereZero`.
- **C4**: infinitude (`c4_infinite`) — the fleet the component must hold.
- **GPV**: unique/tame lifts (F4) = canonicity of the extraction (well-definedness, Rule 4);
  winding cargo (A1–A3); the signature bridges = GAP-1/GAP-2 (computed, never named, Rule 3).
- **Equivariance/naturality — SCOPED (Codex's correction, ratified)**: G₂ squares GREEN
  (F2). The remaining obligations are (i) compatibility with the **specific Möbius
  transformations extracted from the section transport** and (ii) the U(1) phase behavior
  obtained from the lift — NOT blanket commutation with the full Möbius group (U(1) is not
  central in Möbius; `bandEnd` copies are automatically compatible along pure-G₂ legs,
  whose Möbius leg is trivial, and not otherwise). The plan distinguishes: ambient Möbius
  arrows in the fibre / the action actually induced by transport / naturality proved /
  naturality required.
- **Preservation**: the real-center field discharged per constructor from the cargo
  (Rule 4) — the well-definedness proof of the enriched functor, in the author's words.

### 4.4 `T_A` and the engines

`T_A = ∫_{B_A} F_A` (Grothendieck, Mathlib); engine H1 GREEN and generic
(`pi0_grothendieck`); H2 (connected ⟺ singleton — Riehl Rem 8.3.5's clause) is standard
and likely short but must be **located in Mathlib or proved for the corrected
construction** before being marked green (the previously-green singleton was the old thin
transport's); `toColimitObj_eq_of_zigzag` GREEN and generic.
Connectivity of the zeros' addresses: **derived** from the built action (Rule 1),
through composites/zigzags the analytic construction determines.

### 4.5 The statement level

Integrated theorem (per D1/D2, RESOLVED above) → API corollary `zero_real_parts_common` → 
`Corollaries.lean` chain unchanged (`cor:nontrivial`, `cor:rh` — the famous consequence
stays a two-liner). Master diff prepared for the author's curation (D3).

## §5 Execution order (the design principle, mapped to sessions)

1. **Inventory completion** against the import graph (the TO-VERIFY rows; confirm/grow gaps).
2. **The arrow-type AND fibre-design ruling** (GAP-3, the driving question) — R6 dialogue:
   author + Codex + Fable against the completed inventory. Decides: the exact base objects
   and enriched arrows; the actual fibre `F_A(b)` — including whether points are objects or
   cargo, and how the normalized zeros become addressable over a base point. (D1/D2
   statement rulings RESOLVED 2026-07-11; Codex's nine-step order of the same date refines
   this list and is adopted in PLAN_lean_formalization.)
3. **Lean, stage 1**: the arrow type + `B_A` (constructors, laws, preservation fields).
4. **Lean, stage 2**: point-level Möbius charts (D4) + pointed fibre groupoid (G2).
5. **Lean, stage 3**: `F_A` by extraction (well-definedness = W1–W4 consumption; naturality
   squares); `T_A`.
6. **Lean, stage 4**: connectivity derived; engines applied; the integrated theorem; the
   API corollary; Corollaries rewired if D2 requires; axiom audit toward 0/0.
