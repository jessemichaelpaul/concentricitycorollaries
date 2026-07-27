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

# PLAN — the connected object (2026-07-08, author-directed)

Sources of truth: **kernel > author > master**. This builds the author's ACTUAL object, which
had never been built; the prior objects (const fibre over a thin-cone/"static" base) were the
wrong register. The master and `CLAUDE.md` already record the connected reading (2026-07-08).

## STATUS

- **#4 — compactified stem + transport** — ✅ `ConnectedBase.lean` (`Fstar`,
  `gpvBase_transport_star`), axiom-clean.
- **#3 — `𝓑`, the transport groupoid** — ✅ `ConnectedBase.lean`, axiom-clean
  `[propext, Classical.choice, Quot.sound]`, zero `sorry` (2026-07-09).
  `Base A` = non-singular circle points; `Hom σ σ' = {k : ℤ // Realizes A σ σ' k}` (a tame
  `A`-transport of winding `k`); `id`/`comp`/`inv` = `realizes_id`/`realizes_comp`/`realizes_inv`
  (resting / concatenation-windings-add / reversal-negates); `instGroupoidBase` strictly
  associative by `Subtype.ext` of the `ℤ` law. **The base is IMPLIED by `A`** (`Realizes` → `Fstar`
  → the section's structure, ultimately C1–C4), not bolted on. `IsConnected 𝓑` is **NOT** built in
  — the zeros coinciding is #10.
- **#6 — `A.transport`, the section functor** — ✅ `SectionFunctor.lean`, axiom-clean
  `[propext, Classical.choice, Quot.sound]` (2026-07-09). `A.transport : A.Base ⥤ Grpd`, the
  **honest constant `SphereWorld`-carrier**: `obj = SphereWorld` (the `S⁶` direction fibre = the
  concentric degenerate sphere per sheet, `exp_kernel_unit_imaginary` — forced by **slice
  preservation**), `map = Id` (a value-loop winds the value, doesn't move the direction). No free
  choice — the fibre and its constancy trace to slice preservation. Faithful-instance checks pass
  (the A-analogue of B's five): genuine functor `𝓑 ⥤ Grpd`, `𝒯_A = Grothendieck (A.transport ⋙
  forget)` exists, `transport_readout = pi0_grothendieck A.transport` (master step 8) applies,
  `toColimitObj_eq_of_zigzag` available. The concentric content is NOT in the functor's action —
  it's the two facts the readout reads off it: `exp_fibre_concentric` (**C2**) + the join
  `two_center_winding_onto_one_band` through `N` (**C1+C3**), over **C4**-many pairs.
- **#7 — `𝒯_A = ∫_𝓑 A.transport`** — ✅ exists + checked (the Grothendieck of `A.transport`).
- **#10 — the theorem** — NEXT: the zeros zigzag-join through `N` (`two_center_winding_onto_one_band`,
  value-side, placement-free) → one component via `toColimitObj_eq_of_zigzag`. Conclusion =
  **one connected component of `𝒯_A`** (categorical, value-side). NOT domain-side `Re = c` (that
  crossing needs the placement — the trap that sorried the old `concentricity_via_weldW4`).

## The object (grounded, connected, placement-free)

- **Base `𝓑`** = the transport groupoid over the non-singular circle points (`Base A`, built).
  Its arrows are `A`'s value-path transports, recorded by winding. `π₀(𝓑)` is one point — but that
  is a **downstream readout (#10)**, proved from the arrows zigzag-joining the zeros, NOT assumed
  in `𝓑`. The great circle `S¹ = ℝ ∪ {∞} ⊂ 𝕆*` is the point set; `𝒯_A` lives in `𝕆*`, not on
  `E⁺_𝕆`. VS non-covering (Rem 5.2b / Def 5.5) is about logarithm branches, never taken — irrelevant.
- **The fibre functor — `A` ITSELF, the transport (there is no separate `F`)**. A functor
  `𝓑 ⥤ Grpd` (what `pi0_grothendieck` wants), each non-singular point carrying its slice world
  (`SphereWorld`/`𝒮₂` as-is — Riemann spheres `S²_v`, Möbius self-maps, `U(1) ⊂ G₂` inside), and
  the action on a morphism `⟨k, …⟩` = **the Möbius/band turn by the winding `k`**. `A` carries
  `𝓑`'s arrows into the fibre. Spec: `DESIGN_S2_slice_world_2026-07-07.md`.
- **Total object `𝒯_A = ∫_𝓑 A`** (`CategoryTheory.Grothendieck`).
- **Readout** = `π₀(𝒯_A) ≅ colim_𝓑(π₀∘A)` = in-repo `pi0_grothendieck` (`Theorem.lean`, the form of
  Mathlib `colimitFiberwiseColimitIso`, NO connectedness hypothesis). The zeros' image (the
  degenerate fibre — **output**) is ONE connected component = the centre. **Connected = concentric.
  PLACEMENT-FREE. Island P dropped.**

## Keep / delete

- **KEEP:** `H1` (`G₂ ⋉ 𝕆*`), `SphereWorld` (`𝒮₂`), all ~200 GPV/analytic facts (unique winding,
  exp manifolds, `exp_fibre_concentric`, `sliceCoord_smul_invariant`, …), **W1–W4** (`WeldW12`,
  `WeldW3`, `WeldW4`, `FlipWeld`).
- **DELETE (junk / wrong register):** `circleBase`, `worldFunctorC` + the C-objects, `BaseC`,
  `RTBase`, `SBase`, `RoundTripNat_routeA/B/C`, `RoundTrip_finalityglue`, `RunFinality_probe`,
  `AuthorsArgument`, `FinalityCone`, `FinalityConeS2` — and the `transportLevel_placement`
  **sorry** (finality-only; no dangling sorry). Verify `lake build` stays green after each
  deletion (nothing root-imported depends on them).

## Lean build sequence (math-first → `lake build` at each step)

1. **`𝓑` — the transport groupoid.** ✅ DONE (`ConnectedBase.lean`, see STATUS). Built as `A`'s
   value-path transport groupoid over the non-singular circle points, NOT by proving `π₀ = point`
   inside it (that is #5/#10).
2. **The fibre functor `𝓑 ⥤ Grpd` — `A` the transport (no separate `F`).** Fibre = `SphereWorld`
   as-is; the action on a morphism `⟨k, …⟩` = the **Möbius/band turn by winding `k`**. Design
   inputs (skim first): the ~200 weld/analytic facts that tie the base to C1–C4, and `SphereWorld`
   itself — `sphereMap`, `sphereMap_dir_natural`, the `Groupoid` instance, the band `U(1)`, W1–W4
   (`SigmaE3`, `WeldW3`). Reuse, don't rebuild.
3. **`𝒯_A = ∫_𝓑 A`** (`Grothendieck`). Plumbing (`typeToCat` / `grothendieckTypeToCat` if the
   `π₀` target must be `Type`/`Discrete`).
4. **Readout.** Apply in-repo `pi0_grothendieck` (form of `colimitFiberwiseColimitIso`, no
   connectedness hypothesis): `π₀(𝒯_A) ≅ colim_𝓑(π₀∘A)`.
5. **`thm:concentricity` on `𝒯_A`.** The residue-ℂ zeros (degenerate fibre, output) have one image
   in `π₀(𝒯_A)` — proved via the transport-arrows zigzag-joining the zeros (`toColimitObj_eq_of_zigzag`).
   Axiom-clean `[propext, Classical.choice, Quot.sound]`. **No sorry, no placement.**

## Mathlib tools (verified present)

`colimitFiberwiseColimitIso`, `fiberwiseColimit`, `hasColimitsOfShape_grothendieck`,
`isColimitCoconeOfFiberwiseCocone`, `Grothendieck.transport`, `ConnectedComponents.functorToDiscrete`,
`typeToCat` (Cat.lean:408), `Grothendieck.grothendieckTypeToCat`.
Secondary — do NOT use (finality): `Functor.Final.colimitIso`.

## Rule

Each step: (a) show the math first (grounded, cited), (b) construct in Lean, (c) `lake build`,
(d) report raw. No pre-litigating the readout — build it, read the kernel. A green with clean
axioms is the proof.
