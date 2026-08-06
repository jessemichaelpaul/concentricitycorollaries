# What is in the argument, and what is beside it — 2026-08-05

Measured by import closure, not by name. `Corollaries.lean` declares
`zeta_riemannHypothesis`, so the argument is everything it transitively
imports.

**51 of 72 modules are in that closure. 21 are outside it.**

## The two arms

The tree is not a line. It has two arms meeting at `Corollaries`:

- **Categorical arm** — … → `Theorem` → `ConcentricityReadout` → `Corollaries`
- **Analytic arm** — `ZetaSection`, `ZetaDivisor`, `RhEquiv`, `ZetaAssembly`,
  `ZetaDensityCore`, `ZetaWeierstrass`, `ZetaXiMatch` → `Corollaries`

The analytic arm does **not** import `Theorem` and does not need to. A first
pass that measured reachability *from* `Theorem` mislabelled that whole arm as
disconnected; it is connected to the conclusion, just not through the theorem.
Reachability from the conclusion is the right test.

## Outside the closure

**Fifteen audit probes** — `_Gate*`, `_Single*`, `_Blueprint*`, `_Geometric*`.
Expected: they are receipts, not argument. `_GateNorthCResidueTransitivityAudit`
is the largest at 421 lines and holds green declarations imported by nothing.

**Six substantive modules**, the real candidates for superseded attempts:

| module | lines |
|---|---|
| `KernelE4` | 475 |
| `WeldW4` | 236 |
| `ASectionGenerated` | 162 |
| `ASectionAction` | 121 |
| `Spine` | 34 |
| `ZetaDensity` | 29 |

`ASectionAction` and `ASectionGenerated` sit beside `ASectionFunctor`, which
**is** in the closure — so those two are candidates for earlier versions of the
same construction. `KernelE4` carries a comment stating nothing consumes its
sorried theorem, which matches the `FlipWeld`/`KeystoneFinality` pattern
already removed.

**Not yet checked, and the check before any deletion:** whether each of the six
holds a declaration that nothing else provides. Deleting a superseded attempt is
housekeeping; deleting the only home of a used declaration is not. Run
`scripts/authored.sh check NAME` and a consumer grep per declaration first.

## The one open step

`Theorem.lean:1049`, inside `northProducersConnectedAmbient`, with `:1117` and
`:1161` downstream of it. **The first move is not to prove it.** Its existential
asks for two *state-indexed* stabilizer parts; the master produces the residual
factors of two sweeps of one construction. Check whether the statement is the
author's before attempting it — `scripts/authored.sh check
northProducersConnectedAmbient` reports ABSENT.
