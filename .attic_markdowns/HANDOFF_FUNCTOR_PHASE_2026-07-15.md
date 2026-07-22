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

# CODEX/FABLE HANDOFF — FUNCTOR PHASE

**Author:** Jesse Michael Paul

**Date:** 2026-07-15

**Next phase:** construct the genuine section functor `A`

## Read first

1. `PROOF_OUTLINE_LOCKED.md` — theorem and proof architecture of record.
2. `Concentricity/ProjectiveBase.lean` — locked base groupoid.
3. `Concentricity/SliceSphereWorld.lean` — retained sphere-world groupoid.
4. `INVENTORY_REPORT_functor_2026-07-12.md` and `GREEN_LEDGER.md` — inventory only;
   every reused declaration must be rechecked against the new endpoints.
5. `COROLLARY_REWIRE_PLAN.md` — downstream API target.
6. `ENDGAME_RELEASE_PLAN.md` — private completion and publication gates.

## Locked architecture

\[
  \mathcal B
  =PGL(2,\mathbb R)\ltimes\operatorname{OnePoint}(\mathbb R),
  \qquad
  A:\mathcal B\to\mathbf{Grpd},
  \qquad
  \mathcal T_A=\int_{\mathcal B}A.
\]

`A` is the one section functor carrying the analytic value transports. `π₀ ∘ A` is
the components diagram already required by the certified colimit theorem; it is not a
replacement of `A`.

## Immediate build scope

The next thread begins with conceptual and typed design of `A.obj` and `A.map`.

Before implementation, freeze:

- the exact normalized analytic value-state type in each fibre;
- how the retained `SphereWorld` supplies its object and morphism geometry;
- how C1, C2, C3, and C4 enter the object/morphism construction;
- which W1–W4 and GPV results prove well-definedness and functor laws;
- how the real-value content rides inside the genuine transports without becoming an
  external invariant hypothesis;
- the exact imports and names, with every old double or surrogate flagged.

Then implement only the functor and its immediate laws, run `lake build`, audit its
axioms and dependency closure, save, and commit before constructing the total object.

## Guardrails

- Do not import or reuse the old `ConnectedBase`/`AFunctor` architecture wholesale.
- Do not use the artificial `poleGen` functor as the section functor.
- Do not assume base or fibre connectedness.
- Do not add an independent Set-valued value diagram, `Disc ℝ`, comparison bridge, or
  center-pinning map.
- Do not add pairwise indexed zero equalities.
- Do not add a global `realValue_preserved` hypothesis to the categorical tail.
- Do not construct the total object before the genuine functor is locked and green.
- Do not change definitions because of an anticipated RH consequence.

## Completion condition for the next phase

The functor phase is complete only when:

- the genuine `A : GreatCircle.Base ⥤ Grpd` is implemented;
- `A.map_id` and `A.map_comp` are kernel-checked;
- the analytic meaning of its object and arrow actions is documented against C1–C4;
- its imports contain no surrogate architecture;
- `lake build` is green;
- `#print axioms` contains no project axiom or `sorryAx`;
- the result is committed without sweeping unrelated dirty-tree changes into the
  commit.
