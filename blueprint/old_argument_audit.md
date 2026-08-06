# What the old argument did wrong — audit, 2026-08-06

**The author, stated plainly:** $r_E$ is not his object. $r_W$ is not his
object. There is **one** distinguished disk action; by C1, Euler becomes
Weierstrass at $N$, and that identity is the witness; orbit–stabilizer runs on
that for all $t$, continuously, proved and declared.

**The old argument's error, in one line:** it split the one distinguished disk
action into two residual factors, one labelled Euler and one labelled
Weierstrass, and then had to relate them. With one action and the C1 identity
at $N$ as the witness, there is nothing to relate and no second factor to
produce.

Renaming $r_E,r_W$ to $r_1,r_2$ does **not** fix this. Two subscripted factors
is the same split. That rename was mine and it was cosmetic.

## The five live declarations carrying it

Signatures taking two faces `kE kW` or two residual factors `rE rW`:

| declaration | line | master |
|---|---|---|
| `northRelativeLoop_maps` | `Theorem.lean:476` | **TAGGED** |
| `northComparison_of_parallelFaces` | `:615` | **TAGGED** |
| `northComparison_of_residualFactors` | `:647` | ABSENT |
| `northRelativeLoop_stabilizer` | `:853` | ABSENT |
| `northProducersConnectedAmbient` | `:1022`, holds the `sorry` | ABSENT |

## The trace in the master

The transitivity lemma's `\lean{}` tag still reads

```
\lean{ASection.sweepTransitive_on_residueSystem,
      ASection.northRelativeLoop_maps,
      ASection.northComparison_of_parallelFaces}
```

Two of those three are the old argument's declarations. The lemma's prose was
rewritten on 2026-08-05/06; its tag was not touched. So the tag vouches for
declarations the prose no longer describes, which is why `scripts/authored.sh`
reports them TAGGED. **That stale tag is why the old argument still looks
authored.**

## Why the `sorry` cannot be filled

Typed, and the kernel printed it. Setting $r_E := 1$ and $u_\ast$ to $x_0$'s own
input coordinate discharges the first reading by `simp`, and the entire
remaining goal is

```
x0 y0 : AsectionActionFiber A projectiveNorth
hx0 : IsNorthCResidueState A x0
hy0 : IsNorthCResidueState A y0
⊢ NorthStabilizer
```

A **group element** demanded from two **membership propositions**. Nothing in
the context can produce one, and the author's construction never asks for one.
This is the "looking for a producer" shape recorded in `CLAUDE.md`, appearing
as the literal goal.

## What is not in question

`ι_A` and everything under it. The C-residue system supplies the C-residue zero
locus from the inverse-image groupoid; no chart is needed and no coordinate
obligation exists. `residueState_graph` hands over the C3 coordinate. $G_2$ is
transitive on the unit imaginary octonions, and `zeroSphere_eq_orbit` records
that a zero sphere **is** a $G_2$ orbit.

## Not to be done

Do not re-derive two factors under new names. Do not open a coordinate
obligation. Do not hunt a north-stabilizer element. Six attempts, all the same
shape.
