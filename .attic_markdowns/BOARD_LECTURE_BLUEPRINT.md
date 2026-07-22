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

# THE BOARD LECTURE / BLUEPRINT SPINE — Concentricity Theorem

**Author: Jesse Michael Paul.** Captured from the author's own board-lecture walkthrough and
corrections (2026-07-17 dialogue). **The prose is the author's, to be voice-lifted into his
microhistory register — assistants do not rewrite the sentences.** The `PREFLIGHT →` lines are
the matched Lean obligations Codex discharges (Fable's audit annotation). This document doubles
as the backbone of the `master.tex` concentricity proof and the blueprint spine, and as Codex's
build order. Two birds, one stone.

**Conclusion to reach (in the theorem's TYPE):** *all infinitely many C-residue zero-spheres of
an A-section functor are concentric — they share one real value `c`.*
`∃ c : ℝ, ∀ n, (A.sphereZero n).re = c`.

---

### Movement 1 — Background
Cayley–Dickson construction and the octonions; slice-preserving function theory; groupoids, the
Grothendieck construction, and categorical homotopy theory. *(Plant here the one idea the room
must carry: in categorical homotopy theory connectedness is not a local topological property —
it is a property of the real-value transports.)*
`PREFLIGHT →` background; no obligation. (CD octonions built in-repo per R9.)

### Movement 2 — The hypothesis, and what the section does
State the A-section: a section `A ∈ 𝓡` of slice-preserving functions on `𝕆* = S⁸` with C1–C4.
Preview what such a slice-preserving `A` naturally does by its definition.
`PREFLIGHT →` `def:A-section` (`ASection`, C1–C4 as fields/hypotheses); `master §def:A-section`.

### Movement 3 — The two groupoids
Construct the base groupoid `𝓑 = PGL(2,ℝ) ⋉ OnePoint ℝ` and the sphere-world groupoid.
`PREFLIGHT →` `GreatCircle.Base` (ProjectiveBase.lean, kernel-checked); `SphereWorld` groupoid
(SliceSphereWorld.lean). Both green.

### Movement 4 — The distinguished element ⇒ the GENERAL well-defined functor (no C1–C4)
Introduce the distinguished element `f(z) = exp(Iθ)·(z−w)/(1−w̄z)` — a disk automorphism times a
rotation — and how it connects to the hypotheses, but more importantly lets us build a
well-defined functor on a **continuum of maps** as `s ∈ 𝕆*`, which sweeps out the total object.
Review orbit–stabilizer: **the orbits are sets, the stabilizers are group elements** — the orbit
is the continuum swept, the stabilizer at N carries the witness structure. Prove well-definition
on objects and morphisms via the orbit–stabilizer construction. **C1–C4 play no role here — this
is just what a general exponential does.**
`PREFLIGHT →` the GENERAL functor: `projectiveSectionFunctor` shape (`map :=
distinguishedStateAction (cayleyProjective f.val)`), laws from `cayleyProjective_mul` /
`distinguishedStateAction_comp` / `ActionCategory.id_val`,`comp_val`. Well-defined, A-independent
— **not yet the A-section.**

### Movement 5 — The cargo makes it the A-section
Because the functor is well-defined, all that remains is to cite the analytic theorems as facts
about its maps. Instantaneously, via the distinguished element, define the cargo on **all** the
maps at once: the register of charts at N, the degenerate exponential base,
`normalizedZero_pole_power_closes`, the `stemWinding` facts, W1–W4, and the whole field of ~200
theorems — all falling on `f.obj` and `f.map` everywhere the distinguished element lives, which
is everywhere, since we extended it to everything in the total object. **This is where `A`
becomes genuine — the functor is only my A-section when it carries this cargo.**
`PREFLIGHT →` attach the C1–C4 cargo onto `f.obj`/`f.map` (outline §5 "where the specifications
attach"): `normalizedZero_pole_power_closes` (NormalizedPoleBridge:48), `stemWinding_circle_pole`
/`_sphereZero` (SigmaE3:895/:348), the GPV conservation cluster, `realize_equivariant`,
`normalizedZeroLift_re` (:93), the W-suite. **THE KEY UN-BUILT STEP (RULED-1).**

### Movement 6 — The round-trip total object; the zeros populated as OUTPUTS
The total object is the round trip (takeoff from the base, sweep the sphere-world, land at N).
It is populated with zero-sphere objects — **outputs, never inputs, never assumed concentric.**
Connectedness here is the property of the real-value transports, now carrying the cargo.
`PREFLIGHT →` `𝒯_A = ∫ (A-section functor)` (Grothendieck); populate with C4 (`c4_infinite`) zero
states at footpoints. "Zeros are the degenerate fibre — output, never input" (R4).

### Movement 7 — The two-theorem finale (the cargo forces it)
Having added those theorems to the fields of the functor (`f.obj`, `f.map`), **then** run the
colimit argument, which attaches all the transports at the common witness N. The field of facts
implies all the zero-spheres lie in one connected component of the colimit, preserving one real
value — a singleton, `c`. Hence they are concentric. *(Two of the big theorems collapse to one:
`el(π₀∘A)` is `𝒯_A`.)*
`PREFLIGHT →` (a) `pi0GrothendieckEquiv` / `lem:pi0-grothendieck`: `π₀(𝒯_A) ≅ colim(π₀∘A)`
(Theorem.lean:108; = Riehl p.102 identity, the two collapse to one); (b) Rem 8.3.5: nonempty ∧
connected ⟹ singleton. Cargo forces it. **No built connector (RULED-2).** Then read `c` off the
class (`label := (A.sphereZero n).re`, NormalizedBase:45) and land `∃ c, ∀ n, (A.sphereZero
n).re = c` **in the type.**

### Movement 8 — The equivalence theorems and corollaries (afterward, many colors of marker)
Then prove the equivalence theorems — that `ζ` is an A-section — and the corollaries.
`PREFLIGHT →` `zeta_riemannHypothesis : RiemannHypothesis` (Corollaries:46, already green under
the one sorry — `#print axioms` = `[propext, sorryAx, Classical.choice, Quot.sound]`, tracing
only to `ASection.concentricity`), `riemannHypothesis_iff_concentric` (RhEquiv:135, ½ enters
here only), `zeta_criticalLine_zeros_infinite` (Corollaries:57).

---

**The reflection to state out loud (the author's, verbatim intent):** stop and reflect on how
nontrivial this is — the finale being short is *earned*, not suspicious. Every ounce of
difficulty is front-loaded into the construction and the ~200 theorems of cargo; a proof where
the machinery is built so well that the conclusion is forced in two theorems is what a deep proof
looks like from the summit. The economy is the achievement.

**Where this lands in `master.tex`:** Movements 4–5 rewrite `def:base` (line 966 — currently
mis-states "C1–C4 construct the functor / the laws establish well-definedness"; correct to
general-`F`-then-cargo). Movement 7 is already correct at `lem:pi0-grothendieck` (line 1051).
Reconcile the retired `Φ : 𝓗₁ → 𝒮₂` (`thm:section-functor`, 927) with the locked `A : 𝓑 → Grpd`.
