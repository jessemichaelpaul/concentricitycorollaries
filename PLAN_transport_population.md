> **REVOKED 2026-07-04 — superseded by PLAN_two_index_bricks.md; do NOT execute; run-record: HANDOFF_concentricity_argument.md §3.5(b), SCAN §6.**

# Plan — populate 𝒯_A, retire the `transportLevel := re` shortcut

**Status:** proposal for the author's ruling (R6). No Lean written. HEAD `bf78b47`,
ledger 1/0 (sole sorry: `ASection.transportLevel_placement`, Theorem.lean:203).
Reopening `transportLevel`/`assemblyComponent` is a statement-layer change →
words-before-commits, author's call.

## The defect, precisely (master vs. code)

`def:base`, "How the section populates the diagram" (verbatim): the transport data over
𝓑 is the winding lift of the section's value-paths; "the residue-ℂ zero-spheres of A
appear in 𝒯_A as the **degenerate fibre** of this transport — an output of the
construction, never an input."

- **Proved and sound** (section-independent spine): `TotalObject = ∫_𝓑 F`,
  `levelClass : π₀(𝒯) ≃ ℝ`, `level_eq_of_zigzag`, `totalObject_components_eq_levels`
  (Base.lean); the cone/analytic layer (Toolkit.lean): `exp_fibre_neg_real`
  (`lem:exp-degenerate`), `stem_identity`, `exists_log_continuation`,
  `winding_lift_unique`, `winding_loop_defect`; Φ = `sectionFunctor : H1 ⥤ S2` with
  `sectionFunctor_obj`, `sectionFunctor_map_direction` (TwoWorlds.lean).
- **Missing** (the un-forced move): the map that sends A's zeros *into* 𝒯_A as the
  degenerate fibre of the populated transport. It was short-circuited to
  `transportLevel A n := (A.sphereZero n).re` (Theorem.lean) — each zero assigned the
  level of its own real part, with no lemma forcing agreement. `placement` therefore
  reads as a bare arithmetic identity over the free field `sphereZero`, and is
  unprovable as stated.

The whole substantive content of `thm:concentricity` lives in this missing node. The
spine is standard category theory; the claim that C1–C4 force the zeros onto one level
is exactly the population `def:base` prescribes and the code deferred.

## CORRECTION (supersedes the cocartesian framing below): the cone is final, by the small argument

The joining is C1 — the dropped hypothesis. NOT a cocartesian level-match, NOT Quillen A.
Zeros are OUTPUT: no level is assigned to any zero; they pop out connected.

1. **The cone.** C1: A at its simple real pole has value 𝔫 = ∞ = N (the ∞ object of
   𝒮₂ = OnePoint Octonion; rmk:two-poles). Every zero-bearing continuation maps into 𝔫 — a
   morphism X ⟶ 𝔫 per zero-bearing object (rmk:collapse-cone: "the pole pulls a cone …").
2. **Unique/tame.** C2 gives the continuation (exists_log_continuation); C3 the one stem, so
   the companion is unique (stem_identity, winding_lift_unique) — the map into 𝔫 is the only one.
3. **𝔫 final ⇒ one component (THE SMALL ARGUMENT).** C4 = the whole zero-bearing part. A
   morphism X ⟶ 𝔫 gives `Zigzag X 𝔫`, so every zero-bearing X shares 𝔫's connected component.
   Directly from `CategoryTheory.Zigzag` / `ConnectedComponents`. NO Functor.Final, NO Quillen A.
4. **Zeros out.** `assemblyComponent A` = the class of 𝔫 (single, not ℕ-indexed); concentricity
   reads every residue-ℂ zero into it as output. DELETE `transportLevel := (sphereZero n).re`
   and `transportLevel_placement` — backwards artifacts, not to be proved.

Anti-shortcut: no step reads `(sphereZero n).re`; no zero is fed in to pick its component. If
X ⟶ 𝔫 can't be built from C1 + the proved lifts, R6-STOP with the exact missing arrow.

---

## (superseded) The cocartesian π₀ argument — retained for the dependency record

The argument is Quillen's π₀ shadow, not any analytic bridge. Master, **"The cocartesian
computation of π₀"** (verbatim): π₀(𝒯_A) ≅ colim_𝓑(π₀∘F) ≅ π₀(𝓑), "under which a
residue-ℂ zero-sphere maps to the class of the base object beneath it, and two of them
share a component of 𝒯_A if and only if they share that class." Quillen §1 (SOURCES/
Quillen73.md, verbatim): `p : ∫_𝓑 F → 𝓑` is precofibred with connected fibre (the band
U(1)); the corollary to Theorem A ("prefibred or precofibred with contractible fibres ⇒
homotopy equivalence") has as its π₀ shadow "connected components of BC ↔ components of C".
The finality/Quillen-A route is the master's *secondary* proof (`rmk:pi0-split`),
expressly left for the community; the cocartesian one is primary and Lean-native.

**Already proved — the entire cocartesian machine.** `levelClass : π₀(TotalObject) ≃ ℝ`,
`pi0_grothendieck` (#11), `level_eq_of_zigzag`, `totalObject_components_eq_levels` — all
closed, cocartesian register, no Quillen-A/Thomason input (PHASE4_PLAN guardrail). The π₀
read-off is done. There is no open analytic node; my earlier "node 3 / (i)(ii)(iii)"
crux was a stray toward the argument-principle and is **withdrawn**.

**The one un-built step: land the zeros as the degenerate fibre of the single assembled
transport** (retiring `transportLevel := (sphereZero n).re`). This is the forced
construction, and it uses ALL FOUR hypotheses jointly (R3) to produce ONE connected
transport — no step is optional, none is a design choice:

- **C2** — A = exp(∑ₚ ℓₚ), zero-free on Ω₀ ⇒ the hypercomplex-log continuation (the
  transport) exists outright (`exists_log_continuation`, PROVED).
- **C3** — A = qᵐ·R·eᵍ·∏ 𝓔 over the full divisor; C2 and C3 are two exponential
  expressions of the one stem, agreeing on the overlap by the Identity Theorem
  (`stem_identity`, PROVED) ⇒ the tame lift is **unique** (`winding_lift_unique`, PROVED).
- **C1** — one simple real pole = the cone 𝔫 through which the value-loops close
  (`winding_loop_defect`, PROVED) ⇒ the transport closes into a **single loop**; the pole
  is where the zero-bearing levels join.
- **C4** — infinitely many zeros ⇒ the degenerate fibre is infinite — still one component.

The single connected transport is the joint output of C1–C4. Its degenerate fibre is
therefore ONE zigzag-connected locus in 𝒯_A; `level_eq_of_zigzag` (PROVED) collapses it
to one level; `levelClass` (PROVED) reads one level as one component. Placement discharged.

## Remaining Lean work (zeros are OUTPUT — the construction never takes a zero as input, R3/R4)

The construction is indexed by the transport, never by the zeros. `sphereZero` does not
appear until the final readout, and even there it is read *off* the constructed fibre,
never fed *in*.

1. **The assembled transport (from C1–C4 alone).** Build the value-loop lift of A and its
   degenerate fibre as a locus in 𝒯_A: C2 gives the continuation (`exists_log_continuation`),
   C3 makes it the one stem hence unique (`stem_identity`, `winding_lift_unique`), C1 closes
   it into a single loop through the pole cone (`winding_loop_defect`), the fibre points sit
   at level log r (`exp_fibre_neg_real`). No mention of `sphereZero` anywhere in this node.

2. **One component (the cocartesian readout).** The assembled transport is a single
   connected locus, so its image in 𝒯_A is one zigzag-class ⇒ `level_eq_of_zigzag` ⇒ one
   level ⇒ `levelClass` ⇒ one component. Produce a SINGLE
   `assemblyComponent A : ConnectedComponents TotalObject` — the component of the transport's
   degenerate fibre. NOT ℕ-indexed. Categorical, via zigzag reachability, **not** analytic.

3. **Read the zeros off (output).** By C3, each residue-ℂ zero `sphereZero n` is a point of
   this degenerate fibre (the factorization's divisor IS the fibre — C3, `def:base`'s
   "output, never input"). So each maps into `assemblyComponent A`. This is the only place
   `sphereZero` enters, and it enters as a readout of the already-built fibre.
   **ANTI-INPUT GUARD (load-bearing).** The zero is never located, never fed into the
   transport, never used to pick a component. `assemblyComponent A` is built in node 2 with
   no reference to `sphereZero`; node 3 only *matches* zeros into it. If the match cannot be
   made without feeding the zero back into the construction (re-reading `sphereZero`'s real
   part to choose its home), that is an R6 STOP — surface the exact missing link — NOT a
   disguised shortcut.

4. **placement / concentricity.** `assemblyComponent` becomes single (not ℕ-indexed); the
   `transportLevel := (sphereZero n).re` shortcut and the `transportLevel_placement`
   arithmetic identity are DELETED, not proved — they were artifacts of the zeros-as-input
   encoding. `concentricity`'s final statement (all residue-ℂ zeros in one component) is
   unchanged in type; its proof now reads them off node-2's single component via node 3.

**Statement-layer edits this entails (author's word given):** `assemblyComponent` ℕ-indexed
→ single; delete `transportLevel`/`transportLevel_placement`; `concentricity` proof rerouted,
its type fixed. This is the forced consequence of "zeros are output," not a design choice.

## Statement-layer edits this entails (author's approval)

- `ASection.transportLevel` — from `(sphereZero n).re` to `(transportObject A n).level`.
- new `ASection.transportObject : ASection → ℕ → TotalObject` (node 2).
- `assemblyComponent`/`concentricity` statements: unchanged in *type*; their proofs now
  route through nodes 1–4 instead of the placeholder. `thm:concentricity`'s final
  statement does not move.

## Net-zero audit (answer to the author's question)

- **Theorem & corollary *statements*: net zero.** `thm:concentricity`, `cor:rh`,
  `cor:nontrivial`, `cor:zeta-section` are unchanged. The RH corollaries consume
  concentricity as a black box + ζ's functional equation; they are not in Lean yet and
  are untouched by this fix.
- **Everything downstream of concentricity (RH included): net zero.** No corollary changes;
  they simply gain a sound theorem to cite once node 3 closes.
- **Proof obligation: NOT net zero, but constructible.** The substantive work relocates
  from the mis-stated arithmetic sorry to the forced construction above: populate the
  transport, land the zeros as its degenerate fibre, read off via the already-proved
  cocartesian π₀. No open analytic question, no author ruling — the construction is forced
  by C1–C4 + the lift literature. This fix makes the ledger *honest*, and the remaining
  work is wiring + the one-component (single-loop) lemma.
