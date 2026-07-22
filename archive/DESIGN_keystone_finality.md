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

# DESIGN — the keystone via the finality cone at N (Lane B, 2026-07-05)

Register: design spec, words-before-commits. Shapes are SCHEMATIC; Lane A finalizes
against the arbiter and returns rendered statements for the author before landing.
This closes the R6 of record (KeystoneAssembly.lean:75) — it supplies the one resisting
goal, the transport zigzag — by the author's mechanism (2026-07-05): the value-loop
assembly converges to the unique finality cone at N, so all zero-bearing levels coincide.

## Disambiguation (author's standing instruction) — CONCLUSION register only

This lemma proves the **conclusion** of `thm:concentricity`: `transportLevel n =
transportLevel m` (equivalently, one connected component). It is **member-free, value-free,
levels/winding/convergence only**. NO metric vocabulary — no "centre", "radius",
"concentric", no ½, no ζ. The geometric gloss ("zero-circles shrink to N and overlap on the
great circle") is `rmk:concentric-gloss` and belongs to the *translation* theorems
(`cor:nontrivial`, `cor:rh`), which attach downstream and independently. Keep them out of
this file.

## The move (why this is off the circular frame)

The resisting goal `Zigzag (ofLevel (transportLevel n)) (ofLevel (transportLevel m))` is,
by the PROVED `zigzag_iff_level`, the same proposition as `transportLevel n =
transportLevel m` — the static frame can only read the level, never manufacture the zigzag.
So we prove the level equality **directly**, as coinciding limits at N, and close the
zigzag by `zigzag_iff_level.mpr`. The content moves from the frame onto the analytic side,
where lake can gate it.

## Target

```lean
/-- The keystone, via the finality cone (author's mechanism, 2026-07-05). Both transport
levels are the common level-limit carried into the unique finality cone at N; hence equal.
Feeds `transportLevel_placement`; the KeystoneAssembly zigzag then closes by
`zigzag_iff_level.mpr`. CONCLUSION register (no metric vocabulary). -/
theorem ASection.transportLevel_const_via_finality (A : ASection) (n m : ℕ) :
    A.transportLevel n = A.transportLevel m := by
  -- from (S1) ∘ (S2) ∘ (S3) below
  sorry
```

## Three possessions the assembly consumes (held or proved — ASSEMBLE, do not derive)

All three are things the A-section already has: C2/C3 convergence, the proved `inv_re_bridge`,
and C3's factorization. This is wiring, not a derivation. Lake gates the wiring.

**(S1) N is final over the zero-bearing part — the SOURCED finality (Riehl 8.3.4 + 8.3.5;
master `rmk:pi0-split`).** This is the cross-index wire, and it is the master's own remark,
not a paraphrase.

Master `rmk:pi0-split`, finality half: "by C1 the continuation of A carries every
zero-bearing level of 𝓑 to the north pole 𝔫, and the winding lift supplies a unique tame
companion along each such continuation; so the comma category from a zero-bearing level to 𝔫
is non-empty and connected, and 𝔫 is final over the zero-bearing part of 𝓑 — the π₀ shadow of
Theorem A."

Riehl, `SOURCES/Riehl.md` (verbatim):
- **Lemma 8.3.4.** A functor `K : C → D` is final iff for each `d ∈ D`, the slice category
  `d/K` is non-empty and connected.
- **Remark 8.3.5.** A category is connected iff any two objects are joined by a finite
  zig-zag; `C` is non-empty and connected iff `π₀ C` is the singleton set.

The wire: the convergence — the residue-ℂ 6-spheres shrinking to arbitrarily small radius as
the zeros approach the one point N on the great circle (C1 continuation to 𝔫 +
`winding_lift_unique`'s unique tame companion) — is precisely what makes each comma-to-N
**non-empty and connected** (8.3.4's hypothesis). Then 8.3.4 gives 𝔫 final over the
zero-bearing part; 8.3.5 gives `π₀` a singleton there — any two zeros joined by a zig-zag;
and the level, conserved along that zig-zag (`level_eq_of_zigzag`, PROVED; the one cone is
`c3_factorization`), coincides: `coneInvariant n = coneInvariant m`. Mathlib:
`CategoryTheory.Functor.Final` + `IsConnected` (verify live, R5).

**VACUITY GUARD (SCAN §3.3, Quillen Cor 2):** 𝔫 must be final via the section's ACTUAL
convergence — the comma connectedness is C1/C3 data — never adjoined as a formal terminal
object on the base (which contracts for every section and voids `thm:rh-equiv`). The master
marks `rmk:pi0-split` "expository, not used here" for exactly this reason; this dispatch
promotes it to load-bearing on the strength of the convergence being the section's own data.
If the render reaches for a terminal object on the base, stop — that is the fenced move. If
finality gives one-component-with-N but the level-equality does not follow, that is an honest
R6 with the exact goal, for the author.

**(S2) The level is the invariant carried into the cone (τ–Re bridge).** `transportLevel n
= (sphereZero n).re` (definitional), and `inv_re_bridge` (`‖ρ‖²·Re(1/ρ) = Re ρ`, PROVED)
expresses that real part as the invariant read at N (the second-order coefficient of
approach; `1/ρ → 0` as `ρ → N`). This types each zero's level as the datum the cone carries.

```lean
-- theorem ASection.transportLevel_eq_coneInvariant (A : ASection) (n : ℕ) :
--     A.transportLevel n = <cone invariant at N of (sphereZero n)>   -- via inv_re_bridge
```

**(S3) One cone ⟹ one level — this IS C3, a possession.** The infinite Weierstrass
factorization through the pole (`c3_factorization`, the `(z − pole)·F` form over the full
divisor) is exactly the single meromorphic object carrying all the residue-ℂ zeros
`∏ₙ 𝓔(·;qₙ)` against the ONE pole (C1). "All zeros in the one cone" *is* the factorization
through the one pole — a field of `def:A-section`, consumed directly, never derived.
Uniqueness of the cone is C1's single simple pole; the zeros' membership in it is C3's
factorization through it. Nothing to prove here — feed `c3_factorization` (+ `c1_simple`).

```lean
-- consume A.c3_factorization (through-the-pole product over the full divisor)
--       + A.c1_simple (the single cone)
```

## How it closes

`transportLevel_const_via_finality := (S1) ▸ (S2) ▸ (S3)` gives `transportLevel n =
transportLevel m`; set `transportLevel_placement := transportLevel_const_via_finality`; the
KeystoneAssembly.lean:75 goal closes by `zigzag_iff_level.mpr`; `placement_set` closes by
the proved weld `placement_set_iff`; `concentricity` (already proved on top) goes green. The
two prior named absences are now located: (a) Cor 5.13's loop-closure clause lives inside
(S1)'s convergence (render the σ apparatus there or route via the defect form the
convergence already supplies); (b) the joining step IS (S2)+(S3) — the zeros enter the cone
by their level-invariant, no longer needing to sit literally on the value-`−r` fibre.

## Dispatch note

Install `lean@leanprover` (leanprover/skills) in Claude Code first — the `lean-proof` skill
is the discipline for wiring (S1)–(S3) against the arbiter. All three are possessions:
(S1) the C2/C3 convergence, (S2) the proved `inv_re_bridge`, (S3) `c3_factorization` +
`c1_simple`. Assemble; report the exact goal on any resist (R6). No pre-ranking of the
pieces — none is "the hard one"; lake gates the wiring.
