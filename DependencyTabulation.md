# DependencyTabulation

The live import chain feeding `ASection.concentricity` and its corollaries, in the current working
tree. 76 modules under `Concentricity/`. Read upward: each row imports the rows beneath it.

---

## The spine, endpoint downward

```text
Concentricity/Corollaries.lean
  ├── Concentricity.ZetaSection          ζ_𝕆 is an A-section (C1–C4 verified)
  ├── Concentricity.ZetaDivisor
  └── Concentricity.ConcentricityReadout
        ├── Concentricity.ProjectiveTotal
        └── Concentricity.Theorem                    ← THE ONE OPEN NODE
              ├── Concentricity.Toolkit
              ├── Concentricity.ASectionTotalActionState     (inhabitants: residueTotal :117)
              ├── Concentricity.ASectionCResidueDiagram      (𝓡_A, 𝓡_A(f), ι_A)
              │     └── Concentricity.ASectionCResidueInverseImage   (IsCResidueState)
              │           ├── Concentricity.ASectionActionDiagram    (F_A, F_A(f), T_A)
              │           │     └── Concentricity.ASectionFunctor    (positionedOrbitSquare,
              │           │                                           projectiveNorth,
              │           │                                           smul_coordinate)
              │           │           └── … ProjectiveSection.lean   (projectiveObjectFrame,
              │           │                                           _north, fixes_cayley,
              │           │                                           orbit_stabilizer_factor,
              │           │                                           stabilizerPart_unique)
              │           └── Concentricity.ASectionCResidue         (CResidueZeroLocus)
              └── Mathlib.CategoryTheory.{Grothendieck, ConnectedComponents,
                    Groupoid.Grpd.Basic, Limits.Types.Colimits}
```

## The three endpoint theorems

| declaration | file | status |
|---|---|---|
| `ASection.concentricity` | `Theorem.lean` | the node — its premises green, wiring in progress |
| `ASection.nontrivial_one_centre` | `Corollaries.lean:32` | compiles against the node |
| `zeta_riemannHypothesis` | `Corollaries.lean:46` | compiles against the node |
| `zeta_criticalLine_zeros_infinite` | `Corollaries.lean:57` | compiles against the node |

`riemannHypothesis_iff_concentric` (`RhEquiv.lean:135`) is **proved independently** and is what
turns concentricity into RH. Its statement contains no `1/2`.

## What the node consumes, by row

| # | step | supplier | state |
|---|---|---|---|
| 0 | the element positioned; both faces fixed | `projectiveObjectFrame_north`, `distinguishedDiskAction_fixes_cayley_zero/_N` | green |
| 1 | `F_A`, `F_A(f)`, laws | `AsectionActionDiagram`, `AsectionActionTransport`, `_id`, `_comp` | green |
| 2 | the semantic locus | `CResidueZeroLocus`, `sphereZero_mem_CResidueZeroLocus`, `CResidueZeroLocus_infinite` | green |
| 3 | the preimage | `IsNorthCResidueState`, `IsCResidueState` | green |
| 4 | `𝓡_A`, `𝓡_A(f)`, `ι_A` | `AsectionCResidueDiagram`, `AsectionCResidueTransport`, `AsectionCResidueInclusion` (naturality `rfl`) | green |
| 5 | inhabitants | `residueActionState`, `residueTotal` (`ASectionTotalActionState.lean:117`) | green |
| 6 | **`∫𝓡_A` is a connected action groupoid** | the argument is stated at the level of the connected action of the groupoid — that is *why* the real transports are connected; `ι_A` a proper inclusion, natural iso onto its image, `57384ae` | **green — certified premise.** Marking this "open" is the banned framing |
| 7 | singleton | CHT Rem. 8.3.5; `ConnectedComponents := Quotient (Zigzag.setoid)`; `Quotient.sound` | applied, locked, no `sorry` |
| 8 | components comparison | `pi0GrothendieckEquiv` (`Theorem.lean:108`) | green |
| 9 | the level read | `transportLevel` (`Theorem.lean:171`) at the representatives | follows from 7 |
| 10 | corollaries fire | `Corollaries.lean` | already building |

## Citation dependencies outside `Concentricity/`

`SOURCES/` is referenced **60+ times from certified modules** and is load-bearing documentation,
not archive: `GPVwind.md` (41), `VS.md` (11), `Baez02.md` (6), `Wang.md` (4), `Quillen73.md` (2),
`AdFslice.md` (2), plus `Riehl.md` and `Riehl-CTIC.md` for the categorical statements.

Live Lean also cites, by name, a few pre-register planning documents — `PHASE4_PLAN` (5×),
`PLAN_islands_part1_part2_2026-07-05.md` (4×), `READ_weil_li_findings.md` (3×),
`PROOF_PLAN_zeta_infinitude.md` (2×), `DESIGN_B2_2_kernels.md` (2×). These are retained solely so
those comments do not become ghost citations. **Do not read them as instructions.**

## Shadowed and absent names

- `residueTotal`, `totalMk` — genuine at `ASectionTotalActionState.lean:117`; shadowed in the
  quarantined `ASectionTotalPreflights.lean:172`. Cite by file and line.
- `residueToNorth` — exists only in excluded files (`ASectionFinality.lean`, the quarantined
  preflight).
- `ASection.concentricity_transport` / `Concentricity/TransportObject.lean` — **absent from the
  live tree.** It existed only in the removed July-8 worktree, built on retired objects
  (`BaseC`, `nObj`, `Populated`), and is preserved in history at branch
  `worktree-agent-a9741a6f5d3907e39`, commit `1782444`. `Theorem.lean`'s comment citing it is a
  ghost citation and is being corrected.
