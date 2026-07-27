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

# The A functor — construction record (2026-07-10)

The section functor **A** and its total object **T_A**, over the connected object.
Design locked with the author; the bridge is built and `lake`-green.

## The object

**A : A.Base ⥤ Grpd** (the author names the functor "A" — it *is* the A-section
acting), with `obj = SphereWorld` (the true slice-world groupoid, `SliceSphereWorld.lean`):
A's normalization `s ↦ φ_{dir s}(F(sliceCoord s))` realizing the whole S₂ continuum of
Riemann spheres, swept as `s` ranges 𝕆*.

**F.map's morphism-map IS W1–W4.** The four value transports act on *every* Riemann sphere
simultaneously and warp them around the pole, thereby carrying a morphism of the base B to a
morphism of the slice world. That linking is literally the data of the functor's morphisms —
building W1–W4 *was* building `F.map`. There is **no constant functor anywhere** (a const fibre
over any base — the old `bandFunctorC`/`BaseC` — is the trap; this is the correct object over
`A.Base` + `SphereWorld`).

## The proof shape — `toNHom` re-seated

`T_A = ∫_{A.Base} A`. The witness **N** is the one pole object (where all spheres meet — the
continuation through ∞; all their north poles are the single N). Every object of `T_A` has an
**arrow to N** whose fibre leg is the pole rotation; then the three-line argument:

`Zigzag.of_hom (arrow to N)` → `classOf_eq_nClass` → **one component** → the colimit over the
connected great circle B reads the **conserved level** → `∃ c`, closing `ASection.concentricity`.

Robust: `sphereWorld_zigzag` gives π₀(SphereWorld) = one point (G₂-transitive on S⁶, Baez), and
B is the one connected great circle — so the colimit `π₀(T_A) ≅ colim_B(π₀∘A)` is one point.

## The bridge — GREEN (`Concentricity/AFunctor.lean`)

The one link that had to be nailed: **ℂ-valued lift → rotation around the pole → G₂ → `SphereHom`.**

```lean
worldRot (g : G2) : SphereWorld ⥤ SphereWorld     -- rotation endofunctor
worldRot_one  : worldRot 1 = 𝟭 SphereWorld
worldRot_comp : worldRot g ⋙ worldRot h = worldRot (h * g)
poleRot hv hw : G2                                 -- exists_smul_eq (G₂-transitivity, Baez)
poleRot_smul  : poleRot hv hw • v = w
dirLink (I J : SphereWorld) : I ⟶ J                -- := dirHomTo (poleRot ..) (poleRot_smul ..)
```

`dirLink` is the concrete "morphism of B ↦ morphism of the slice world": every sphere linked to
every other by the pole rotation, `dirHomTo`-realized.

**The SU(3) slack is fixed by uniqueness.** `poleRot` uses `Classical.choose` (the G₂ element to
a direction is not unique — the SU(3) stabilizer). That slack never reaches π₀ because the
**IntegrateTheorem combining theorem** — `gpvPopulated`/`GpvTransportWitness`
(`IntegrateTheorem.lean:269`): (a) `gpv_base` the *unique* tame lift, (d)/(e) the pole cone to N,
(b)/(c)/(f) the level/band — forces the level/component. Uniqueness of the tame lift pins what the
readout reads; the raw element's freedom is irrelevant.

Lean gotcha: `SphereWorld` is a `def`, so `(⟨v,hv⟩ : SphereWorld) ⟶ …` unfolds to the raw subtype
and loses the `Category` instance — take `SphereWorld` objects directly.

## Remaining

1. Assemble `T_A = ∫_{A.Base} A` (Mathlib `Grothendieck`).
2. The arrow-to-N for every object — fibre leg `dirLink`, sourced from `gpvPopulated`.
3. The three-line `Zigzag` argument (`zigzag_to_n` / `classOf_eq_nClass`, re-seated over `A.Base`).
4. The colimit readout `pi0_grothendieck` (`Theorem.lean`) → `∃ c` → close `ASection.concentricity`.
