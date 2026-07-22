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

# COROLLARY REWIRE PLAN

**Author:** Jesse Michael Paul

**Locked:** 2026-07-15

**Dependency:** `PROOF_OUTLINE_LOCKED.md`

## Purpose

The Concentricity Theorem itself produces the common real center `c` of the populated
C-residue zero `S⁶`s. The corollary layer translates that conclusion into the classical
vocabulary and, where appropriate, identifies the numerical value of `c`.

The corollaries do not create concentricity, do not prove a second center theorem, and
do not replace the genuine functor or its colimit.

## Required dependency chain

1. `ASection.concentricity` proves that the C-residue value-transport colimit is the
   real singleton `{c}` and hence the C-residue zero spheres have common center `c`.
2. The C-residue/classical-zero translation identifies those spheres with the
   classically nontrivial zeros.
3. `ASection.nontrivial_one_centre` restates the already-proved geometric conclusion in
   the classical enumeration/set vocabulary. It is a translation lemma, not another
   proof of concentricity.
4. For `zetaSection`, the functional-equation rigidity theorem identifies the unnamed
   common center with `1 / 2`.
5. `zeta_riemannHypothesis` and the infinite-critical-line corollary consume those two
   results.

## Lean rewiring rules

- `Corollaries.lean` must cite `ASection.concentricity` directly.
- Any enumeration such as `sphereZero n` appears only in the translation/readback
  layer, never in the Concentricity Theorem's categorical engine.
- The bridge from the structural conclusion to the enumerated vocabulary must reduce
  to the definitions of C-residue population and its classical identification.
- No new `sorry`, axiom, center choice, or pairwise zero comparison may be introduced.
- The value `1 / 2` enters only through the functional-equation theorem downstream of
  concentricity.
- Old thin-base, `zeroAddress`, `TotalTransport`, and surrogate-readout artifacts must
  not enter the final import closure.

## Verification

After rewiring:

```lean
#check ASection.concentricity
#check ASection.nontrivial_one_centre
#check zeta_riemannHypothesis
#check zeta_criticalLine_zeros_infinite

#print axioms ASection.concentricity
#print axioms ASection.nontrivial_one_centre
#print axioms zeta_riemannHypothesis
#print axioms zeta_criticalLine_zeros_infinite
```

The target is zero project sorries and zero project axioms across the complete
corollary import closure.
