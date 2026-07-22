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

# PRIVATE ENDGAME AND RELEASE PLAN

**Author:** Jesse Michael Paul

**Locked:** 2026-07-15

**Status:** private workflow; no publication or public push is authorized by this file

## 1. Mathematical and kernel completion

- Complete the genuine functor `A`, its total object, Concentricity Theorem, and
  corollaries.
- Achieve zero `sorry` declarations and zero project axioms in the public import
  closure.
- Record exact `#print axioms` reports for the theorem and every headline corollary.
- Distinguish standard foundational dependencies such as `propext`,
  `Classical.choice`, and `Quot.sound` from project axioms.

## 2. Repository cleanup

- Determine the minimal public import closure.
- Remove or archive stale surrogate bases, artificial counterexamples, abandoned
  theorem statements, audit scratch files, and contaminated experimental artifacts.
- Preserve useful general lemmas only when their statements, provenance, names, and
  dependencies are correct.
- Ensure the canonical proof outline and source ledger agree with the final Lean
  declarations.
- Verify that no private inbox PDFs, tokens, local paths, machine-generated scratch
  output, or private dialogue records are tracked for release.

## 3. Authorship and acknowledgment

The Concentricity Theorem, its mathematical architecture, and all proof-direction
rulings are due to Jesse Michael Paul.

Suggested acknowledgment:

> The Concentricity Theorem and its proof architecture are due to Jesse Michael Paul.
> The Lean formalization was developed by Jesse Michael Paul with AI-assisted
> implementation, inventory, and editing using Claude and OpenAI Codex. All
> mathematical definitions, theorem statements, and proof-direction rulings were made
> by the author; the Lean kernel provides formal verification.

Repository headers, `README`, `CITATION.cff`, and release metadata should name Jesse
Michael Paul as author. AI assistance is acknowledged separately and is not listed as
mathematical coauthorship.

## 4. Reproducibility gate

- Build from a fresh private clone with the pinned Lean and Mathlib versions.
- Run the full build without relying on untracked local files.
- Run the theorem/axiom audit from the fresh clone.
- Check the dependency and import graphs against the intended public architecture.
- Have the Desktop/Fable tree and Codex tree independently reproduce the same commit
  and kernel results.

## 5. Exposition and blueprint

- Reconcile the paper theorem, Lean theorem, proof outline, and corollary statements.
- Update the blueprint so every mathematical step links to its final Lean declaration.
- Cite the categorical and analytic literature at the exact step it supports.
- Clearly separate the proved Concentricity Theorem from the downstream translation
  and numerical identification of the center.
- Include a concise Mathlib inventory of reusable contributions developed during the
  formalization.

## 6. Private review

- Perform a final mathematical dependency audit.
- Perform a final formalization audit for sorries, axioms, unsafe declarations,
  untracked dependencies, and name collisions.
- Review the public tree for stale or misleading statements.
- Prepare the Zulip announcement and Mathlib contribution request privately.

## 7. Publication gate

Nothing becomes public until Jesse Michael Paul explicitly authorizes the release.

After authorization:

1. push the audited release commit;
2. create the chosen tag or release;
3. publish the readable blueprint and paper materials;
4. post the Zulip announcement with exact build instructions and theorem names;
5. propose generally useful library additions to Mathlib in appropriately scoped
   contributions.

No force push, public repository conversion, release, Zulip post, pull request, or
Mathlib submission is authorized before that explicit decision.
