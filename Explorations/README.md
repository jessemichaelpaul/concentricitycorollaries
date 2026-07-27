# Explorations — the general theory (NOT retired, NOT public)

Mathematically interesting material that is **not** part of the Concentricity proof or the
public `concentricityandcorollaries` release, but is worth keeping for future work.

## What lives here

The **general slice-preserving object** — a general ring element with C1 (meromorphic
continuation, one pole), built via the A-free geometric route:

- `cayleyProjective : PGL(2,ℝ) →* Moebius` and its Cayley chain — the base motion realized as a
  disk automorphism *parameterized by the bare base motion*, with no A.
- the generic families `distinguishedWorldAction (m : Moebius)`, `distinguishedStateAction (m : Moebius)`.

A-sections are the **specialization** of this general object: the same disk-automorphism geometry,
but reparameterized by A's Euler product (`A.F = exp(∑' ℓ_p)`) via `sliceEmbed ∘ A.F`, and
extended across the base by orbit–stabilizer. So this folder is the general case; the proof is the
special case.

## Rules

- **Not imported by `Concentricity.lean` (root).** Nothing here is in the 0/0 build closure.
- **Not part of the Zulip release.** The public page is a curated `concentricityandcorollaries`.
- **Keep the distinguished *element* out of here** — `distinguishedMoebius`/`distinguishedGL` (the
  Blaschke building block) stay in `CayleyDictionary.lean`; A's action is built from them.

## Status

This folder is frozen until the accepted commuting-action construction and terminal 0/0 are complete.
It supplies no execution phase, functor swap, or alternative construction for the theorem. The
binding order remains `PLAN_TWELVE_ON_THE_DISK_ACTION_2026-07-22.md`.
