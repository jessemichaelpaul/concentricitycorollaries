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

# PLAN_base_stage1 — the base groupoid, spec of record v3 (2026-07-11, scope-narrowed)

*v3 supersedes v2 (same date): the author narrowed the build authorization — Phase 1
builds ONLY the base groupoid, verifies it is a groupoid, places it, saves it, and STOPS.
The v2 F5–F9 breadth (dictionary, Cayley formula, rotation embedding, action rows, π₀
facts) is DEFERRED until the author's conceptualization of the A-section functor is
formalized. Rulings: ALIGNMENT points 17–19. Codex builds; Fable verifies; the author
rules. Provisional names go through the naming table (point 14).*

## The architecture of record (unchanged from v2 — the author's level assignment)

| Level | What belongs there |
|---|---|
| Domain 𝕆* | octonionic points; the original slice-preserving section with its fixed normalization |
| Base 𝓑 | `OnePoint ℝ` and its PGL(2,ℝ) automorphisms, U(1) visible; N an ordinary distinguished object |
| Indexed functor A | normalized analytic/sphere-world states and their transport under base arrows |
| Total 𝒯_A = ∫_𝓑 A | pairs (b, x); combined base-channel + fibre morphisms — value transports ride the channels here |
| Colimit/π₀ | π₀(𝒯_A) ≅ colim_𝓑 π₀∘A; transported component classes identified |
| Theorem | all normalized zero addresses share κ; the preserved real coordinate gives c |

No Euler data, zeros, logarithmic lifts, winding, centers, or C1–C4 witnesses belong in 𝓑.
G₂ (acts on 𝕆*, fixes the real circle pointwise) is never identified with PGL(2,ℝ)
(moves base points, including N); their interaction is functorial design.

## THE AUTHORIZED BUILD (all of Phase 1 — nothing else)

- **B1 — carrier.** `BasePoint := OnePoint ℝ`. (`circleEmbed`, ConnectedBase.lean:73,
  keeps its existing role; untouched.)
- **B2 — the native action (cite, don't build).** `MulAction (GL (Fin 2) ℝ) (OnePoint ℝ)`
  — pin, Topology/Compactification/OnePoint/ProjectiveLine.lean:126.
- **B3 — the descent (load-bearing: 𝓑 cannot be formed without it).** Prove scalar
  matrices act trivially on `OnePoint ℝ`; descend via `Matrix.ProjGenLinGroup.
  mulActionOfGL` (pin, LinearAlgebra/Matrix/GeneralLinearGroup/Projective.lean:85; the
  pin's own worked example: UpperHalfPlane/MoebiusAction.lean:275) to
  `BaseAut := Matrix.ProjGenLinGroup (Fin 2) ℝ`  (= `PGL(2, ℝ)`, :29, notation :34)
  acting on `BasePoint`. *(Faithfulness: DEFERRED — a property, not needed for
  groupoid-ness.)*
- **B4 — the base groupoid, its verification, and its placement.**
  `𝓑 := CategoryTheory.ActionCategory BaseAut BasePoint` (pin, Action.lean:48).
  Kernel confirmation it IS a groupoid: the pin instance
  `Groupoid (ActionCategory G X)` (Action.lean:137) elaborating on 𝓑, plus a
  `#print axioms` ledger row. Placement — the great circle inside 𝕆*:
  `OnePoint.map Octonion.ofReal : OnePoint ℝ → OnePoint Octonion` (the established
  `OnePoint.map` register, same pattern as `circleEmbed`; the same construction register
  as the domain groupoid `H1 := ActionCategory G2 (OnePoint Octonion)`, G2.lean:231 —
  base and domain now live in one architectural register).
- **Save and STOP.** Green build; `#print axioms` rows into GREEN_LEDGER; tree
  comparison; intentional commit (point 16). Then the phase ends.

## DEFERRED (parked until the A-functor conceptualization is formalized — repointed then)

- F5 the dictionary `cayleyBoundary : OnePoint ℝ ≃ₜ Circle` (in-repo; pin TODO
  ProjectiveLine.lean:20)
- F6 the Cayley formula / intertwining square (the disk chart as theorem)
- F7 `baseRotation : Circle →* BaseAut` + boundary-rotation correspondence
- F8 full-group action rows at finite points and at N (`smul_infty_eq_ite` consumers)
- F9 component/π₀ facts — noting the pin already holds
  `IsConnected (ActionCategory M X)` from `IsPretransitive` (Action.lean:128): one
  instance away when repointed
- faithfulness of the descended action
- **the repointing of the entire C1–C4 / W1–W4 / GPV ledger of results** onto the new
  objects
- B3a/B3b (the enriched fibre-morphism design; the μ naturality suite, codomain-free) —
  functor/total-object stages, unchanged from v2's relocation

## Order of record (the author)

**Base groupoid → A-functor conceptualization (𝓑 → the sphere world) → repoint theorems
→ total object.** Look-ahead rule: while designing the functor's object-to-object and
morphism-to-morphism analytic content, look ahead to the total object ONLY — no further.
