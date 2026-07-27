# Concentricity

Work only in `/Users/jessepaul/Desktop/concentricity`.

Load the `concentricity-functorial-register` skill for every task involving
the A-section action, `SphereWorld`, orbit--stabilizer, `G₂`,
`AsectionActionDiagram`, `F_A`, Grothendieck totals, zero preimages,
finality, `π₀`, readers, or the finale.

Also load the project-local `orbit-stabilizer-groupoids` skill for work on
action groupoids, quotient--orbit equivalences, stabilizers, invariant full
subgroupoids, `ObjectProperty.lift`, `G₂`, or the `GL`/`PGL`/`Moebius`
directions in `SphereWorld`. Its generic theory and Lean dictionary are
shared with Claude; the Concentricity register remains authoritative for
the project instantiation and gate boundary.

Read, in order:

1. `register/00-register.md` — the epigraph, the invariant, the one failure
   mode, and the routing table for everything below
2. `CURRENT_GATE1_MEMORY.md`
3. `CURRENT_GATE1_HANDOFF.md`
4. `EndgamePlan.md`
5. `PROOF_OUTLINE.md`
6. `CODEX.md`
7. `RELEVANT_GREEN.md`

`register/` is the shared register, tracked in git so that Claude, Codex, and
any clone read the same text. The
`concentricity-functorial-register` skill is a loader that points there and
holds no architecture of its own. `CURRENT_GATE1_MEMORY.md` is the
mathematical register, `EndgamePlan.md` the canonical execution plan, and the
live Lean declarations the implementation record.

Do not restate the architecture in agent instructions, skills, plans, or
handoffs. Point at `register/` instead — duplicated copies drift, and that
drift is what produced the conflicting plans this cleanup removed.

## Skills in a fresh clone

`skills/` is tracked. The discovery paths are not: `.claude/` is gitignored,
so a fresh clone gets the skill bodies but no way to find them. Recreate the
two symlinks once, from the repository root:

```bash
mkdir -p .claude/skills && ln -sfn ../../skills/concentricity-functorial-register .claude/skills/ && ln -sfn ../../skills/orbit-stabilizer-groupoids .claude/skills/
```

Codex's own discovery path is `~/.codex/skills/`; point it at the same two
tracked directories. Never copy a skill body into either location — a copy
is exactly the drift this layout exists to prevent.

Third-party PDFs in `inbox/` are deliberately untracked (`.gitignore`).
Several are personal-use-only and may not be redistributed. The tracked
citation record is `SOURCES/*.md`.

## Current boundary

Gates 1 and 2 are certified. The canonical total is
`TotalActionStateWorld A`. The exact framewise `F_A(X)` and the semantic
`CResidueZeroLocus A` are certified. The framewise
`InverseImageCResidueStateWorldGroupoid A X` is now also triple-certified.
The next open theorem proves that the whole action preserves semantic residue
and thereby assembles those already-certified fibres into a diagram. Every
subsequent gate is held.

Do not implement any further preimage until its exact A-specific type has
completed the geometric, categorical, and kernel walk-around and been
approved. The certified framewise residue inverse image named above is
already closed and must not be reconstructed.
Do not edit `Octonionic_RH_master.tex` during this Lean phase.

## Gate-1 subject

C1--C4 determine one infinite, vertically integrated
Euler--Weierstrass--GPV action. Its distinguished element is simultaneously
the slice-preserving function and the diagonal Möbius group element fixing
`0` and `N`. It therefore has intrinsic input and output value states.

For `s ∈ 𝕆*`, `(dir s, sliceCoord s)` is input to this already-complete
element. Orbit--stabilizer transports the same element through projective
objects and arrows, uniformly on every sphere. `G₂` supplies the natural
isomorphisms between the continuum of sphere directions in `SphereWorld`.

`AsectionSlice` is only the old sectional projection. At each frame `X`, the
Gate-1 object is
`Grpd.of (AsectionActionStateWorld A (projectiveObjectFrame A X))`.
`AsectionActionDiagram A` only organizes these already-built groupoids over
the base; it is not a generic or constant wrapper.

The existing `AsectionEquivariant A : H1 ⥤ H1` is a genuine point-valued
function eye. It is not yet, merely by existing, the completed global
Gate-1 receipt. Gate 1 must certify its terminal comparison with the whole
action.

## Standing rules

- Values are inherited by evaluation; outputs are never installed.
- Nothing in the intended exponential action is semantically constant.
- A green face or naturality square is evidence, not gate completion.
- Do not infer a missing two-dimensional index or another categorical
  wrapper.
- Do not design zeros, cone legs, north arrows, labels, readers, or a centre
  before the completed action is approved.
- The zero preimage and its transport/north structure are inherited from the
  completed action.
- The locked project route proves the complete residue action is one
  categorical orbit and applies Riehl Remark 8.3.5. Lemma 8.3.4 remains
  generic background, not a project gate unless a genuine north restriction
  later requires it.
- On the locked orbit route, the real-level face is already an
  `ℝ`-valued orbit invariant. Its descent defines `val_A`; a cocone is the
  categorical expression of that invariant, not a choice of codomain.
- Do not use historical, retired, attic, archive, or alternate-tree
  constructions as implementation authority.
