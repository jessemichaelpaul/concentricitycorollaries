# THREAD HANDOFF — COMPLETE THE UPSTREAM A-ACTION BEFORE ANYTHING DOWNSTREAM

**Author:** Jesse Michael Paul  
**Workspace:** `/Users/jessepaul/Desktop/concentricity`  
**Date:** 2026-07-22  
**Scope:** one upstream task only

## First-turn instruction

Read, in this order:

1. `AGENTS.md`
2. `/Users/jessepaul/.codex/skills/concentricity-functorial-register/SKILL.md`
3. `FINAL_PLAN_2026-07-21.md`
4. the final section of `MEMORY.md`, beginning at
   `2026-07-22 SESSION FAILURE LEDGER`
5. the live definitions named below

Then report the exact live types and the precise upstream delta in no more
than a few sentences.  **Do not edit, build, design a replacement object, or
look downstream in the first response.**  Jesse will provide the granular
implementation steps and will direct each gate.

## The correction that governs this thread

There is literally no looking ahead.  The completeness of the disk action is
fixed by Jesse's hypotheses, C1--C4, and their intrinsic W/GPV consequences.
Nothing about `𝒯_A`, 8.3.4, `labelCocone`, `val`, a deletion test, or a later
naturality proof determines what action must be built.

The dependency direction is strictly:

```text
C1--C4 / W1--W4 / GPV
  -> the complete function-valued Euler--Weierstrass--GPV disk action
  -> wholesale orbit--stabilizer on GreatCircle.Base and SphereWorld
  -> sectionFunctor A : GreatCircle.Base ⥤ SphereWorld
  -> exact 𝒯_A
  -> 8.3.4 / π₀ / labelCocone / val
  -> ∃ c : ℝ, ∀ n, (A.sphereZero n).re = c
```

This thread works only on the first three arrows, under Jesse's granular
direction.  It must not inspect or modify the total/readout to decide the
upstream action.

## Exact live truncation

The full C2 action already exists as a function of `z`:

```lean
noncomputable def eulerPrimeSum (A : ASection) (z : ℂ) : ℂ :=
  ∑' p : A.ι, A.ℓ p z

noncomputable def eulerDiskAction (A : ASection) (z : ℂ) : Moebius :=
  GreatCircle.diskExpAction (A.eulerPrimeSum z)
```

`eulerDiskAction_eq_value` proves that on the C2 half-space its multiplier is
literally `A.F z`.  C1 continues that same function through `N`; C3/W3 give
the Weierstrass presentation of that same function at and through `N`; the
GPV value tape, logarithmic lift, winding, and real level are coordinates and
consequences of that same action.

The current orbit--stabilizer frame does **not** consume that function.  It
consumes:

```lean
noncomputable def distinguishedDiskAction (A : ASection) : Moebius :=
  GreatCircle.diskExpAction A.distinguishedPoleLog

def projectiveObjectFrame (A : ASection) (X : GreatCircle.Base) : Moebius :=
  GreatCircle.cayleyProjective
      (GreatCircle.orbitRep (CategoryTheory.ActionCategory.back X)) *
    distinguishedPoleElement A
```

Here `distinguishedPoleElement A := A.distinguishedDiskAction`.  This is one
Möbius element obtained from the pole value.  Therefore the current
`projectiveObjectFrame`, `projectiveArrowElement`, and `sectionFunctor` carry a
single value of the action rather than the complete `z`-dependent action C2
supplies.  That is the upstream truncation to repair.

## The mathematical object is fixed

- Base: `GreatCircle.Base`.
- World groupoid: `SphereWorld`.
- Functor: `sectionFunctor A : GreatCircle.Base ⥤ SphereWorld`.
- Full multiplier type: `ℂˣ`, never `Circle`.
- Mechanism: the already-green `orbitRep` / `stabilizerPart` factorization,
  carrying the complete A-action wholesale.
- The twelve and the full W1--W4/GPV closure are native facts, coordinates,
  and consequences of that complete action.  They are not proof fields,
  wrappers, twelve conjuncts, independently supplied paths, or arrow-indexed
  cargo.

Do not introduce another groupoid, generic fibre, state record, diagram,
comparison functor, category of elements, `Disc ℝ`, scalar bridge, quotient
section, per-arrow transport, or per-index connector.

## Preserve these live suppliers

Do not discard or broadly revert:

- `eulerPrimeSum`
- `eulerDiskAction`
- `eulerDiskAction_eq_value`
- `projective_gpv_transport`
- `projective_gpv_disk_action`
- the proved C1/C3/W1--W4 continuation and winding/level results
- `distinguishedWorldAction` and its group laws
- `orbitRep`, `orbitRep_spec`, `orbitRep_infty`
- `stabilizerPart`, `orbit_stabilizer_factor`, and the identity/composition
  laws
- the removal of the former welds that accepted an arrow `f` beside an
  independently supplied `h : GpvTransport ...`

The task is to change what the orbit--stabilizer construction carries, not to
replace the proven analytic or group-theoretic infrastructure.

## Forbidden failure modes

1. Do not call the pole-value element the complete action because native
   facts can be cited beside it.
2. Do not demand that theorem proof names appear inside the data definition
   of the functor.
3. Do not decide completeness from `labelCocone`, `val`, the total, a deletion
   test, or any downstream goal.
4. Do not atomize the action into individual arrows or choose a GPV transport
   independently.
5. Do not invent a wrapper or theorem-field carrier to make facts visible.
6. Do not change `totalTransport` or any downstream declaration in this pass.
7. Do not run ahead after a local green result.  Stop at each gate Jesse sets.
8. Do not revert a file or commit when Jesse rejects one field or name; make a
   narrow correction only.
9. Do not report a typing problem in an invented substitute as a problem in
   Jesse's construction.
10. Do not ask Jesse for the geometry again.  It is recorded here; ask only
    for the next granular Lean step if he has not supplied it.

## Working-tree and commit discipline

The workspace contains substantial existing changes belonging to Jesse and
earlier work.  Preserve all unrelated modifications.  Before every edit,
inspect the exact target diff.  Stage and commit only files Jesse explicitly
authorizes for that gate.  Run at most one serial build after the preflight and
only when Jesse directs it.

Recent memory commits:

- `5f74912` — initial session failure ledger
- `2846e16` — correction: action completeness is determined upstream

Commit `2bc5211` contains useful suppliers and also a later
`totalTransport` change motivated by a rejected syntactic-visibility
criterion.  Do not touch that downstream declaration in this upstream pass,
and do not revert the commit wholesale.

## Stop condition for this handoff

The next agent's first job is only to align with the exact upstream delta and
then follow Jesse's granular steps.  It must not claim the functor is complete
until the complete C2/C1/C3/W/GPV function-valued disk action—not the pole
value alone—is what the orbit--stabilizer construction actually carries.

