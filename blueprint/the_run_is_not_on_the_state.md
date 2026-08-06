# The run is not carried by the state — 2026-08-06

Searched inside the seat's read surface for what attaches a C-residue state to
a tape instant, instead of inventing one. What the search returns, and the
check that it is quarantine.

## The hit, and why it is not the answer

`ASectionFunctor.lean:981` pairs a residue state with the tape:

```lean
noncomputable def residueFiberState (A : ASection) (X : GreatCircle.Base)
    (n : ℕ) (I : SphereWorld) : AsectionFiberType A X :=
  ((A.residueState n I : AsectionStateWorld A),
    Discrete.mk (canonicalAsectionPresentation A X))
```

docstring: *"Every C-residue sphere produced by A is a physical object of every
full fibre, paired with A's canonical Euler--Weierstrass--GPV presentation."*

It sits inside `namespace JuxtapositionPreflight` (`:845`--`:998`) — the
quarantine CLAUDE.md warns a bare grep lands in. Its own two docstrings say so
outright: the presentation is *"independently chosen and therefore not yet
bound to the physical state"*, and `AsectionFiberTransport` (`:861`) is *"the
whole **two-face** fibre."*

## What that establishes

The two-face structure has a home, and it is the preflight. The live fibre the
seat runs on, `AsectionActionFiber`, carries **no** presentation: its objects
are `AsectionActionState` — input, positioned, realized value — and nothing
else.

So a live north C-residue state does **not** carry a run. Any step that asks
"which run produced this state" is looking for the preflight's shape inside the
live object, and will not find it. That is the same error as
`constructor_backwards.md` one level down: there, the run was manufactured from
a residual factor; here, it would be sought on the state.

## Method note

The register gate's message is the answer, not an obstacle: *"the objects for
this seat are inside the surface; a name that is not there is not the object."*
Searching outside the surface for a producer is how the sixth re-derivation
happened. Searching inside it, and then checking the hit against the
quarantine, is what this file records.
