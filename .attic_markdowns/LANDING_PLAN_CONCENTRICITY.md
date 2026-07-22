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

# LANDING PLAN — the Concentricity Theorem (corrected architecture: the cargo makes the A-section)

**Author of the mathematics and of every ruling: Jesse Michael Paul.**
Drafted with Fable (audit seat), 2026-07-17, corrected after the author's board-lecture
walkthrough. Codex builds; Fable audits each step; the author rules every seam.

---

## THE SHAPE OF THE PROOF (read this before any step — it is the whole resolution)

The functor `f(z) = exp(Iθ)·(z − w)/(1 − w̄z)` — a disk automorphism times a rotation — is
**well-defined by Möbius / group facts alone**, via orbit–stabilizer. **C1–C4 play NO role in
its well-definition.** That generic functor exists and its functor laws hold from pure group
structure.

**But the generic functor is NOT the A-section.** It *becomes* the author's A-section only when
the C1–C4 cargo — the register of charts at N, the degenerate exponential base,
`normalizedZero_pole_power_closes`, the `stemWinding` facts, the W-suite, the whole field of
~200 theorems — **rides on `f.obj`/`f.map`**, everywhere the distinguished element lives (which
is everywhere, by the orbit–stabilizer extension).

**Therefore the A-section functor and its total object are the genuinely un-built objects.**
What is currently in the tree (`projectiveSectionFunctor`, `map := distinguishedStateAction …`)
is the *generic* functor — A-independent by construction at this stage. That absence is what
made every model land on the value-free functor and hand-fake the connection (`northWorldHom`):
the cargo that would have made the colimit force connectedness *for free* was never on the maps.

Once the cargo is on the functor, the total object is the **round trip** (takeoff from the base,
sweep the sphere-world, land at N), the zero-spheres are **populated onto it as outputs** (C4,
never inputs), and the categorical-homotopy finale — **only two theorems** — forces
concentricity, with nothing connected by hand.

**There is no "join the zeros" step. Connectedness is not local/topological — it is a property
of the real-value transports, which the cargo puts there, and which the colimit reads off.**

---

## THE RULE FOR EVERY STEP

- **One criterion:** a declaration either **carries the author's cargo on the functor / cites
  the colimit engine**, or it is a finding. No built/chosen/hand-composed connecting map
  (`Classical.choose`, a hand `{ base, fiber }` link, a manual zigzag) — RULED-2.
- **Preflight before build:** exact Lean type + the green declaration that closes it + expected
  axioms. Clean preflight ⇒ green build. The kernel is a checker, not a judge.
- **One step, then stop:** build + `#print axioms` after each; Fable audits; author rules any
  seam; only then the next step.
- **Conclusion Gate:** `∃ c : ℝ, ∀ n, (A.sphereZero n).re = c` lives in the theorem's TYPE
  (RULED-5). **Terminal green:** on the real green — certificate → commit → tag → bundle → STOP.

---

## Step 1 — The generic well-defined functor (Möbius/orbit–stabilizer; NO C1–C4)

`f(z) = exp(Iθ)·(z − w)/(1 − w̄z)` over `GreatCircle.Base`, well-defined by group facts;
functor laws from `cayleyProjective_mul` / `distinguishedStateAction_comp`. C1–C4 nowhere.
This part is essentially what `projectiveSectionFunctor` already is — keep it, but know it is
**not yet the A-section.**

## Step 2 — Make it the A-section: put the cargo on `f.obj` / `f.map` (THE KEY UN-BUILT STEP)

Attach the C1–C4 cargo onto the functor's object and morphism fields, everywhere the
distinguished element lives (everywhere, by the extension): the register of charts at N, the
degenerate exponential base, `normalizedZero_pole_power_closes` (NormalizedPoleBridge:48),
`stemWinding_circle_pole`/`_sphereZero` (SigmaE3:895/:348), the W-suite, the GPV
uniqueness/conservation cluster, `realize_equivariant`, `normalizedZeroLift_re`, … — the
~200-theorem field. **Until this is done it is NOT the author's functor (RULED-1); after it, it
is.** These are cited facts about the maps, never new hypotheses (outline §5). The `A` in
`A.map`/`A.obj` becomes genuine *here*, through the cargo — not through the generic maps.

## Step 3 — The round-trip total object; zeros populated as OUTPUTS

`𝒯_A = ∫ (the A-section functor)` — the round trip (takeoff → sweep the sphere-world → land at
N). Populate the C-residue zero-spheres onto it as **outputs** (C4: `c4_infinite`), at their own
footpoints — never inputs, never assumed concentric. (Say this out loud in the lecture: the
zeros arrive as the degenerate fibre, output not input.)

## Step 4 — The two-theorem finale (categorical homotopy; the cargo forces it)

- **The colimit readout — one theorem (two collapse to one):** `π₀(𝒯_A) ≅ colim_𝓑(π₀∘A)`.
  Because `el(π₀∘A)` **is** `𝒯_A`, Riehl's category-of-elements identity `π₀(el X) ≅ colim` and
  the certified `pi0GrothendieckEquiv` (Theorem.lean:108) are the *same* statement.
- **Rem 8.3.5:** a category is nonempty ∧ connected ⟺ its `π₀` is a singleton.

The cargo on the transports (Step 2) makes the populated zeros nonempty (C4) and connected
through the common witness N — so Rem 8.3.5 **forces** the singleton κ. **No arrow is built,
chosen, or composed.** `northWorldHom`/`zeroZigzag`/`populatedHom` are retired here — they were
compensating for the cargo that Step 2 now supplies.

## Step 5 — Read c; the conclusion in the TYPE (outline §10)

`c :=` the class's `label` — `label := (A.sphereZero n).re`, a `rfl` field (NormalizedBase:45);
`∀ n` because every populated zero is in κ; bridge `normalizedZeroLift_re` (:93). Land
`∃ c : ℝ, ∀ n, (A.sphereZero n).re = c` **in the theorem type**. Honesty guard: deleting the
cargo must break the theorem.

## Step 6 — The theorem + certificate (Conclusion Gate)

`concentricity_theorem` carrying the conclusion clause in its type. Certificate = build line +
`#print axioms` (`[propext, Classical.choice, Quot.sound]`, no `sorryAx`) + printed statement,
one message; author ratifies against `thm:concentricity`. Then commit → tag → bundle → STOP.

## Step 7 — Wire the corollaries (already green under the sorry)

`zeta_riemannHypothesis : RiemannHypothesis` and the rest already compile, resting *only* on
`ASection.concentricity` (`#print axioms` confirmed: `[propext, sorryAx, Classical.choice,
Quot.sound]`). When Step 6's green theorem replaces that node, the same print loses `sorryAx`
and RH is unconditional. Then: save, delete the superseded sorried chain to **0/0**, authorship,
prose (the author's voice), Zulip — on the author's explicit word only.

---

## Seam register (fill as we go)
Any needed statement with no green supplier ⇒ its exact Lean type + STOP for the author's
dictation. Never invent it.
