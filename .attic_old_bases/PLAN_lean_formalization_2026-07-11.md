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

# LEAN FORMALIZATION PLAN — the enriched build, phase by phase

*2026-07-11 (Fable, dictated structure by the author). Companions:
`PLAN_theorem_of_record_2026-07-11.md` (the statement + clause match),
`COMPARISON_INVENTORY.md` (Rules 1–5, the rows, the gaps — its rules bind every phase).
Every phase ends at a kernel verdict: `lake build` green + `#print axioms` on the phase's
named deliverables = exactly `[propext, Classical.choice, Quot.sound]`. Both trees synced at
every phase boundary. HANDOFF.md is replaced (never appended) at each phase completion.*

**The author's structure, verbatim intent:** check each groupoid is carefully built with all
the properties it must have *in virtue of A being slice-preserving and carrying the C1–C4
analytic content*; place the pieces so they satisfy the two categorical homotopy theorems in
the correct place of the proof's logic; purge stray artifacts of the old register; drive the
repo to 0/0. The phase after 0/0 is **intentionally left unplanned** (the author's call).

---

## Phase 0 — Preconditions: rulings and the completed inventory

**0.1 Inventory completion against the import graph.** Resolve every `TO-VERIFY` row
(A5 `winding_loop_defect_level_zero`, C1 `stemWinding_circle_pole` location, D3
`crossing_band_ledger`, F3 W3 rows, F4 `gpvPopulated` fields); confirm or grow the gap list.
*Deliverable:* COMPARISON_INVENTORY.md updated, no `TO-VERIFY` remaining.

**0.2 Statement rulings — RESOLVED (Codex 2026-07-11 evening, author-ratified).**
D1: the ∃κ form ("their common component class," never "the unique"). D2: plain Prop
`ConcentricityStatement` + `theorem concentricity`; projections `zero_classes_common`,
`zero_real_parts_common`; the name stays on the integrated theorem; `Corollaries.lean`
rewired once to consume `zero_real_parts_common`. D3: master untouched until the corrected
functor, total object, integrated theorem, and projection all build.

**0.3 The arrow-type AND fibre-design ruling (GAP-3, the driving question).** The R6
dialogue (author + Codex + Fable) against the completed inventory. Decides, jointly:
- the smallest honest enriched arrow type — constructors extractable from the C1–C4/W1–W4
  certificates, composition provable, preservation field exactly the real coordinate needed
  at the normalized zeros, cargo retention decided (`GpvRealizes`'s `Nonempty` fate, H3);
- **the actual fibre `F_A(b)`** (Codex's fifth correction): what groupoid sits over each
  compactified base object, and how a base transport induces a functor between fibres —
  `normalizedSectionObject` (an action on points) does not by itself define this;
- **points: objects or cargo** (the author's one-sphere-world correction): the fibre may be
  the ONE sphere-world groupoid with the zero realizations as structured cargo on objects
  and arrows, rather than `NormalizedSlicePoint` promoted to a groupoid — decide
  explicitly, do not promote by default;
- the `realizes_of_value_eq` audit: value-coincidence arrows admitted as constructors only
  if they survive the check against intended path/lift cargo (a substitute-arrow risk);
- the `liftPhase` candidate (from the −1 dossier exchange): `Circle.exp (Im w)` — verified
  present in pinned Mathlib with `periodic_exp`/`exp_int_mul_two_pi`/`Real.Angle.toCircle`
  (the height-mod-2π quotient map) — derive and verify as the GPV-lift → U(1) bridge;
  never pre-declare it the functor action.
*Deliverable:* the `EnrichedHom` + fibre spec, written into this file as an addendum before
Phase 1 begins. **No Lean in Phases 1–3 starts before 0.3 is ruled.**

**0.4 Execution order of record (Codex, ratified):** (1) complete the typed inventory;
(2) decide base objects + enriched arrows; (3) decide the fibre `F_A(b)` incl. how zeros
become addressable over a base point; (4) define the extracted functor, prove
preservation/naturality faces; (5) derive the common zero-component class κ; (6) apply the
Grothendieck/colimit equivalence; (7) the integrated theorem; (8) project the pointwise API
corollary; (9) only then master + downstream corollaries. Phases 1–6 below implement
steps 2–9 in that order.

## Phase 1 — The enriched GPV base `B_A` (proof-plan clause 2: "has everything")

**Build checklist** — each item is a named Lean deliverable:

- [ ] Objects: the full compactified circle (`OnePoint ℝ`; N an object, carrier only —
      Rule 2: **no label on N**, no thin-cone arrows imported with the carrier).
- [ ] The arrow type per the 0.3 ruling — germ `GpvTransport` (GREEN: domain path, value
      path, lift, winding; `id`/`inv`/`comp` proved) extended with the preservation field
      and retained cargo.
- [ ] Identity at every object **including N** (the current `GpvTransport.id` requires
      `NonSingular σ` — the N-object's identity needs its own constructor; flag for 0.3).
- [ ] Groupoid instance + laws (`id_comp`/`comp_id`/`assoc`/`inv_comp`/`comp_inv`).
- [ ] Constructors, each discharging its preservation field from certified cargo (Rule 4):
      - [ ] W1 `ofEulerHalfSpaceLoop` (C2 Euler half-space) — lift to the new type.
      - [ ] W2 `ofLeftRegionLoop` (C2/C3 left region) — lift to the new type.
      - [ ] value-coincidence arrows (`realizes_of_value_eq` pattern).
      - [ ] the C1/C3 multiplicity closures (`normalizedZero_pole_power_closes`) as
            **composite material** — Rule 1: never a primitive `Z_n ⟶ N` generator.
- [ ] Certified properties, in virtue of C1–C4:
      - [ ] every arrow conserves the compactified value (A4 lifted to the new type);
      - [ ] winding additivity under composition (from `comp`);
      - [ ] canonicity: the unique tame lift (F4) makes extraction representative-independent.

**Acceptance:** build green; `#print axioms` clean on the instance and every constructor;
no `sorry` introduced (R8: helpers never sorried).

## Phase 2 — The ONE sphere-world groupoid (the fibre side, per the 0.3 design)

*The author's correction of record (2026-07-11): each sphere is NOT a groupoid unto itself.
𝒮₂ is one groupoid — a continuum of sphere objects, G₂ legs between worlds, Möbius
automorphisms within each world, U(1) (`bandEnd`) distinguished in every `End(I)`. The
existing `SphereWorld` already has this shape and is retained. Whether points enter as
objects or as structured cargo is the 0.3 decision — this phase implements whichever was
ruled.*

- [ ] D4 (if the ruling needs point-level action): the Möbius chart action on
      `sliceSphere I` (chart conjugation; charts agree on the circle, B3 GREEN, is the
      compatibility anchor).
- [ ] The fibre per the 0.3 spec — either `SphereWorld` enriched with zero/section cargo on
      objects and arrows, or a pointed category; in both cases the zeros stay addressable
      (`normalizedZeroSlicePoint`/labels, GREEN).
- [ ] Certified properties, in virtue of slice preservation:
      - [ ] the section's action stays in each sphere (`normalizedSectionObject`, GREEN —
            re-seated per the ruling);
      - [ ] band fixes the two shared points in every world (D2 rows, GREEN);
      - [ ] world-level connectivity material (F1 `sphereWorld_zigzag`) consumed where the
            extraction needs it.
- [ ] N discipline: the base circle's N, each sphere's ∞, and 𝕆*'s N remain three typed
      appearances; compatibility is the functor's job — no definitional identification,
      no arbitrary arrows.

**Acceptance:** build green; axiom prints clean; the zeros addressable in the fibre per the
ruled design.

## Phase 3 — `F_A`, the A-section functor (the TON — extraction, no free parameters)

- [ ] The functor `F_A : B_A ⥤ Grpd` (fibre = the pointed slice world): object part per the
      0.3 design; **morphism part extracted from the transport's certified cargo** — no
      `Classical.choose`, no fixed generators, no pre-named pole image (Rule 3: the pole's
      action is computed through the GAP-1/GAP-2 comparisons).
- [ ] `map_id` / `map_comp` from the transport laws (Phase 1).
- [ ] Well-definedness (Rule 4, the author: "the proof of real-value-preserving arrows
      should be a well-definedness proof of the enriched functor"):
      - [ ] representative-independence via the unique tame lift (F4);
      - [ ] the preservation field consumed, never re-proved downstream.
- [ ] Naturality — "plays nicely", SCOPED (Codex's correction, ratified: U(1) is not
      central in Möbius; `bandEnd` copies are auto-compatible only along pure-G₂ legs):
      - [ ] G₂ squares (F2, GREEN — re-seat on the new types);
      - [ ] compatibility with the specific Möbius transformations **extracted from the
            section transport** (not blanket full-Möbius commutation);
      - [ ] the U(1) phase behavior obtained from the lift (the `liftPhase` bridge if the
            0.3 derivation confirms it).
- [ ] The TON audit — the functor demonstrably carries each item (a table in the file's
      docstring, row ↦ where consumed): C1 pole anchor + junction rows; C2 Euler transports;
      C3 divisor + multiplicity closure; C4 `c4_infinite`; GPV unique/tame lifts + winding
      cargo; the signature bridges (GAP-1/2) where the pole action lands.

**Acceptance:** build green; axiom prints clean on `F_A`, `map_id`, `map_comp`, every square.

## Phase 4 — Assembly: `T_A`, the two engines, the theorem (the logic in its order)

The canyon order, enforced: **action → connectivity → engines → read c** (design principle).

- [ ] `T_A = ∫_{B_A} F_A` (Mathlib `Grothendieck`); the zeros' **honest addresses**
      (consuming `n` and `I` — replacing the old `zeroAddress` that ignored `n`).
- [ ] Connectivity **derived** (Rule 1): the zigzags/composites joining the `Z_{n,I}`
      addresses, produced by the built action — whatever categorical shape the analytic
      construction yields; N mediates, nothing is inserted.
- [ ] Engine 1: `pi0_grothendieck` applied to `F_A` (H1, generic, GREEN).
- [ ] Engine 2: the component conclusion per D1 (∃κ — the zeros' one image; Subsingleton
      only if the construction yields it). The generic connected ⟺ π₀-singleton lemma is
      **located in Mathlib or proved for the corrected construction first** (Codex: the
      old green singleton was the thin transport's — H2 is not marked green until then);
      `toColimitObj_eq_of_zigzag` GREEN and generic.
- [ ] Descent: the preservation field descends through π₀ (the `value_const_on_component`
      pattern on the new objects) — quotient recursion, zero new analysis.
- [ ] **The integrated theorem** (statement per D1/D2):
      `∃ κ, ∃ c, ∀ n I, [Z_{n,I}] = κ ∧ center (Z_{n,I}) = c`, with **c := Re(ρ₀) chosen at
      the end** (Rule 2).
- [ ] The API corollary `zero_real_parts_common : ∃ c, ∀ n, (A.sphereZero n).re = c` — a
      projection (`label_zero` is `rfl`), zero content.
- [ ] `Corollaries.lean` rewired per the D2 naming ruling (or unchanged if the pointwise
      level keeps the name); `cor:nontrivial`/`cor:rh` re-certified.
- [ ] D3: the master diff (center clause into `thm:concentricity`) prepared for the
      author's curation.

**Acceptance:** the integrated theorem and the corollary print
`[propext, Classical.choice, Quot.sound]`; the two ConcentricityReadout sorries are
**replaced by this construction, not patched**.

## Phase 5 — The purge: stray artifacts of the old register

*Method: **attic first** (`.attic_old_bases/`), root imports pruned, grep audit that no live
file references an atticed name. Hard deletion only on the author's explicit ruling —
several items below are on THE_CONTRACT's PROTECTED list from the 2026-07-10 state, and the
contract file itself must be updated by the author's hand, not silently.*

Known artifacts (to be confirmed complete by a Phase-5 sweep):

- [ ] `functorA` / `poleGen` / `poleRot` / `dirLink` chain (AFunctor.lean) — the substitute
      functor (fixed chosen rotation; diagnosed 2026-07-11). **PROTECTED-list conflict:
      author's deletion ruling required.**
- [ ] `transport_pi0_singleton` + the `TotalTransport`/𝒯^𝔫 rows in ConcentricityReadout —
      the wrong-carrier singleton (the author's own catch: "π₀(𝒯^𝔫) IS NOT π₀(∫𝓑A)").
- [ ] `zeroAddress` (ignores `n`) — superseded in Phase 4.
- [ ] The two superseded sorries (`totalA_pi0_singleton`, `zero_levels_common`) — removed
      with their statements per D2, not left as dead rows.
- [ ] SliceSphereWorld.lean header — rewrite to match the 299-line reality (the doc drift
      that pointed sessions at deleted machinery).
- [ ] Old bases: Base.lean / TransportObject's thin-cone `BaseC` category (carrier reuse in
      NormalizedBase stays; the fiat-arrow category goes) / GluedTransport remnants —
      **subject to the standing DELETION FLAG** (TransportObject.TransportWitness types
      `GpvTransportWitness.witness`; carve out before any wholesale deletion).
- [ ] Side-file sorries outside the root chain: FlipWeld:1235, KeystoneFinality:122
      (disowned route), WeldW3:668 — resolve or attic explicitly.
- [ ] Register audit: no remaining docstring cites the retired objects as live.

**Acceptance:** root build green after every attic step; grep audits clean; headers match
file contents.

## Phase 6 — 0/0

- [ ] Ledger: **zero sorries, zero project axioms, project-wide** (the brief's gate: the
      declared leaf set is empty; `riemannZeta_nontrivialZeros_infinite` in-repo status
      re-verified).
- [ ] `#print axioms` sweep: the integrated theorem, `zero_real_parts_common`,
      `cor:nontrivial`, `cor:rh` — exactly the Mathlib three, no `sorryAx`, no project
      axioms anywhere in the closure.
- [ ] A permanent audit file (RecoveryAudit pattern) pinning the prints for the record.
- [ ] Both trees identical; final `lake build` count recorded.

*The author's expectation is recorded ("it will, because it just depends on this
statement"); the phase's acceptance criterion is the print itself.*

## Phase 7 — after

**Intentionally left unplanned** (the author, 2026-07-11, to stay level-headed). The brief's
standing order when its time comes: cleanup → blueprint → prose (author-curated) → repo
public → announcement. Nothing here is scheduled, drafted, or assumed.
