> **REVOKED 2026-07-04 — superseded by PLAN_two_index_bricks.md; do NOT execute; run-record: HANDOFF_concentricity_argument.md §3.5(b), SCAN §6.**

# Plan — the compactified base 𝓑 (supersedes PLAN_transport_population.md)

> **SUPERSEDED — DO NOT EXECUTE (2026-07-04).** This plan was run; its run-record is
> `HANDOFF_concentricity_argument.md` §3.5(b) and `SCAN_shapes_and_C5_ledger.md` §6
> (N-terminal collapses π₀ for every section; the readout iff dies — the sharpened
> vacuity criterion in HANDOFF names the mechanism). The only live plan is
> `PLAN_two_index_bricks.md`. Kept for the record per protocol.

**Status:** author-confirmed construction. HEAD `588a6f1`, ledger 1/0. Rebuilding 𝓑
is a statement-layer change → words-before-commits; author's word given.

## The dropped hypothesis, made literal

`Base.lean` builds `Base := Discrete ℝ × SingleObj G2` — the **uncompactified** level
line: no N, the great circle cut open into disconnected points. That is C1's point at
infinity deleted from the base. `zigzag_iff_level`, `level_eq_of_zigzag`, `levelClass`
are all correct theorems **about the wrong (N-less) category** — which is exactly why the
zeros looked unconnectable. The fix restores the compactification.

## The base as `def:carrier` actually has it

The true N is a **single** point — the one point at infinity of 𝕆* = S⁸ (def:carrier).
Every slice Riemann sphere ℂ_I* = S² shares it: ℂ_I* ∩ ℂ_J* = ℝ ∪ {N} (master line 909).
The compactified real axis ℝ ∪ {N} is **one great circle S¹** through that single N
(line 653). So the base lives on the compactified level circle, not `Discrete ℝ`.

**𝓑 (corrected).** Level space = `OnePoint ℝ` (= ℝ ∪ {N} = S¹), with the direction
automorphisms G₂ at each level. **N is a single object that every real level connects to**
— the great circle closing through the pole. So 𝓑 carries the closing morphisms `c ⟶ N`
(N terminal over the levels); distinct finite levels connect only *through* N. The U(1)
band rides on it exactly as before (F = SingleObj Circle); the winding index is read off
the band, never an object label.

## How the section populates it — all four hypotheses, one infinite object

A : 𝕆* → 𝕆* is one meromorphic function. C1: one simple pole, value N. C2 (infinite Euler
over the primes) and C3 (infinite Weierstrass) are two expressions of the one stem
(identity theorem), so the winding lift of A's value-loops is **unique**; the primes
concentrate at the pole, and the value-loops close through the single N. C4 makes the
object infinite — a continuum of loops around the slice Riemann spheres, all sharing the
one N simultaneously. This is the infinite cone lift; it attaches to N in the transport.

## The readout — zeros pop out connected, as OUTPUT

𝒯_A = ∫_𝓑 F over the compactified 𝓑. Because every zero-bearing level closes through the
single shared N, the residue-ℂ zeros arrive as the degenerate fibre in **one connected
component** of 𝒯_A — an output of the construction, never an input. No zero is placed at a
level up front; no zero is fed in to pick its component. π₀ reads the single component off
the populated transport.

The concentric / one-real-centre reading is the **downstream** translation
(`thm:connected-concentric`), logically independent, applied only after the theorem (R4).

## What this supersedes / reworks in Lean

- `Base` : `Discrete ℝ × SingleObj G2` → the compactified level category on `OnePoint ℝ`
  with N the single terminal-over-levels object carrying the `c ⟶ N` closing morphisms.
- `level`, `ofLevel`, `level_eq_of_zigzag`, `levelClass`, `zigzag_iff_level` — rebuilt for
  the compactified base (they were the N-less object's; the level read-off stays as data,
  but π₀ now closes through N, not by disconnected levels).
- `TotalObject`, `bandFunctor` (F = U(1)) — unchanged in shape; base swapped underneath.
- `assemblyComponent`/`concentricity` — final type unchanged; proof routes through the
  N-closure of the compactified transport. Delete the `transportLevel := (sphereZero n).re`
  shortcut and its arithmetic `placement`.

## Guard

No step reads `(sphereZero n).re`; no zero is placed before the readout. N is the single
forced point at infinity of 𝕆* (def:carrier), not a free apex — the `c ⟶ N` morphisms are
the value-loops closing through the pole, supplied by C1 + the unique winding lift (C2/C3),
on the infinite object (C4). If a morphism the construction needs cannot be built, R6-STOP
with the exact goal — do not substitute a level and do not drop the compactification.
