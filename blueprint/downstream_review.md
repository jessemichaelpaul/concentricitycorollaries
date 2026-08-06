# The chain above ι, reviewed against his objects — 2026-08-05

Each rung read from the kernel, checked for what it is stated *about*.

## The rungs

**1. Transitivity.**
```
sweepTransitive_on_residueSystem :
  ∀ (A) (P Q : A.residueTotalCategory), Nonempty (P ⟶ Q)
```
Stated at `residueTotalCategory`, which is `Grothendieck (AsectionCResidueDiagram
⋙ Grpd.forgetToCat)` **by `rfl`**, and which carries `residueTotalGroupoid`.
So it is a statement about the action groupoid $\int\mathcal R_A$, not a bare
category. **This rung carries the open step.**

**2. Connectivity.**
```
residueTotal_isConnected : ∀ (A), IsConnected (Grothendieck (…))
```
Same object, by the `rfl` above. No glue at the seam.

**3. The singleton.**
```
residueTotal_pi0_singleton :
  ∀ (A) (P Q : Grothendieck (…)), ConnectedComponents.mk P = ConnectedComponents.mk Q
```
Same object. Accepts objects of `residueTotalCategory` directly.

**4. The val step.**
```
transportLevel_of_pi0_singleton (A) (n)
  (hmem : ∀ m, A.IsCResidueState projectiveNorth
                 (A.residueActionState projectiveNorth m baseWorld)) :
  ConnectedComponents.mk ⟨projectiveNorth, ⟨residueActionState … n baseWorld, _⟩⟩
    = ConnectedComponents.mk ⟨projectiveNorth, ⟨residueActionState … 0 baseWorld, _⟩⟩
  → A.transportLevel n = A.transportLevel 0
```

## `val` is not post hoc

```
transportLevel A n = (A.sphereZero n).re
```

**The level is the real part of the $n$-th C3 zero, definitionally.** It is read
off the value system, not computed after the fact — matching the master's
"their real coordinate is definitionally the project's level read
$\operatorname{transportLevel}_A(n)=\operatorname{Re}A.\mathrm{sphereZero}(n)$."

And the π₀ equality it consumes is taken at genuine objects of
$\int\mathcal R_A$: Grothendieck objects over `projectiveNorth` whose fibre
carries a `property` witness. The hypothesis `hmem` is discharged by
```
residueActionState_mem : ∀ (A) (m),
  A.IsCResidueState projectiveNorth (A.residueActionState projectiveNorth m baseWorld)
```
which is green. So the singleton is applied to states that carry their residue
condition, and the value it yields is the zero's own real part.

## One observation, not a defect

`transportLevel_of_pi0_singleton` pins **both** objects to `baseWorld`, a single
fixed direction, and varies only the zero index $n$ against $0$. That is
legitimate — the level does not depend on the direction — but it means the $G_2$
freedom is not exercised at this step. The direction transitivity does its work
one rung earlier, inside the comparison. Worth knowing when reading the chain:
the singleton is being read along the index, at one direction.

## Modules beside the argument

`ASectionAction` (8 declarations) is consumed by nothing outside itself.
`ASectionGenerated` (7 declarations) is consumed only by `ASectionAction`. They
form a closed pair, `ASectionGenerated → ASectionAction → nothing`, and neither
is in the import closure of `Corollaries`. Deleting them removes nothing the
argument uses.

## Which of these are his

By `scripts/authored.sh`:

| declaration | status |
|---|---|
| `sweepTransitive_on_residueSystem` | TAGGED |
| `residueTotal_isConnected` | TAGGED |
| `residueTotal_pi0_singleton` | TAGGED |
| `transportLevel` | TAGGED |
| `residueActionState_mem` | TAGGED |
| `nontrivial_one_centre` | TAGGED |
| `transportLevel_of_pi0_singleton` | **ABSENT** |

Six of the seven are named in the master's `\lean{}` tags. **The one exception
is the val step itself** — `transportLevel_of_pi0_singleton` appears nowhere in
the master, in tags or prose.

That does not make it wrong: the master *describes* the step plainly —
*"instantiating the singleton equality at the $n$-th and $0$-th certified
representatives is itself the val step"* — so the mathematics is stated. What is
absent is the declaration name, which means nobody has checked this particular
statement against the text. Given that the only other ABSENT declaration in the
seat chain, `northProducersConnectedAmbient`, turned out to state something the
master does not produce, **this one is worth reading before it is trusted** —
specifically its pinning of both objects to `baseWorld`.
