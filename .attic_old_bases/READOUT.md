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

# The readout — `pi0_grothendieck`, verbatim, and the plucked conclusion (2026-07-10)

The objects (B, A, T_A) are built and triple-certified (see `A_FUNCTOR_TABLE.md`). This is the
**Rising Sea** final mile: the conclusion is not proved by a further ascent — it is *plucked* by
applying the readout to the built objects. Guard the "it can't be this clean, there must be an
inference" reflex; that is the bias.

## The citation, verbatim

| | |
|---|---|
| **Theorem** | `pi0_grothendieck` = master `lem:pi0-grothendieck` (`Octonionic_RH_master.tex:1079`) |
| **Hypothesis** | *the whole of it:* "For a functor **F : 𝓑 → Grpd**." Nothing else. |
| **Conclusion** | "the connected-components functor carries the Grothendieck construction to the colimit of the component diagram: **π₀(∫_𝓑 F) ≅ colim_𝓑(π₀∘F)**." |
| **Ground** | Riehl, *Categorical Homotopy Theory*, **Rem. 8.3.5** (book p. 102): "π₀ … sends a category to its objects up to … zig-zags … C is non-empty and connected **iff π₀ C is the singleton set**." |
| **Cert** | `pi0_grothendieck` → `[propext, Classical.choice, Quot.sound]` (green) |

## The conclusion IS the centre — read, not inferred

Master readout paragraph (`master:1022`), verbatim:

> "…the degenerate-fibre objects — joined by the single closed loop of the unique tame lift — have
> **one and the same image, a *single* point of π₀(𝒯_A)**. **That point is the one real centre**
> log r — 'connected' and 'concentric' are here the same fact, a single image being the common
> centre, **read directly off the transport**."

So the single component's value **is** the conserved real centre `c`. `∃ c, ∀ n, (A.sphereZero n).re = c`
is that value read off — not a "level conserved ⇒ ∃ c" inference on top.

## Proof outline (plucked)

**NB — the base is NOT assumed connected.** The concentricity is not "everything is one component"
(that trivial, level-blind reading is the epistemic-fallacy bias). It is: the **C-residue zeros**,
joined by the **specific middle zig-zag** — the W1–W4 morphism winding every sphere to the one N —
land on one point of `π₀(T_A)`, and that point carries the real level `log r`. The colimit is the
**pushout of the C-residue zeros**, which carries the residue structure.

| step | content | source |
|---|---|---|
| 0 | Objects built: `B = A.Base`, `A = functorA`, `T_A = ∫_{A.Base} A` (all triple-certified) | `A_FUNCTOR_TABLE.md` |
| 1 | Apply `pi0_grothendieck` to `functorA`: `π₀(T_A) ≅ colim_{A.Base}(π₀∘A)` **(GREEN: `readout`)** | master `lem:pi0-grothendieck` |
| 2 | The C-residue zeros, joined by the **middle zig-zag** (the W1–W4 arrow to N), have **one image** — a single point of `π₀(T_A)` = the colimit's pushout of the residues | Riehl Rem 8.3.5 + the welds |
| 3 | That single point's value **is** the real centre `c = log r` — carried in on the zig-zag arrow (its level datum), read directly off the transport | master `:1022` |
| ⇒ | `∃ c, ∀ n, (A.sphereZero n).re = c` — plucked, closing `ASection.concentricity` | — |

## The Rising Sea

The intricate objects were the mountain of rock (a week). The theorem is not a further climb — the
water rose; the avocado is plucked. No hidden step.
