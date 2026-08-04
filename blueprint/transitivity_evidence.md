# Evidence record — `lem:c-residue-transitive`

Two independent measurements of the same object: what the kernel accepts, and
what the author supplied. Neither is the model's opinion. Regenerate the first
with `#print axioms`, the second with the transcript scan in
`scripts/prior_disproof.py`.

## I. Kernel — 20 declarations, measured

Every step of the master's proof, with the axiom surface `lake` reports.

| master step | declaration | `Theorem.lean` | axioms |
|---|---|---|---|
| (P) preimages of the zero locus | `residueState_graph` | :677 | ✅ three |
| (S) squares, reversal | `orbitStabilizerActionSquare_inv` | :540 | ✅ three |
| (S) squares, transport | `relativeSquare_transport` | :601 | ✅ three |
| (S)+(B) ⟹ (I) | `inputEquation_of_boundaryReading` | :584 | ✅ three |
| (R) inversion of a stabilizer part | `stabilizerPart_inv` | :515 | ✅ three |
| (R) the same through `C` | `cayleyProjective_stabilizerPart_inv` | :532 | ✅ three |
| (R) the relative loop carries $u_1\!\to\!u_2$ | `northRelativeLoop_maps` | :476 | ✅ three |
| (R) $k_\bullet=o_Nr_\bullet o_0^{-1}$ as constructor | `faceOfStabilizerPart` | :554 | ✅ three |
| (R) uniqueness half | `stabilizerPart_faceOfStabilizerPart` | :568 | ✅ three |
| (Φ) $G_2$ supplies the direction | `northFiberHom_of_coordinate` | :452 | ✅ three |
| (Φ) from two parallel faces | `northComparison_of_parallelFaces` | :615 | ✅ three |
| (Φ) on the forced residual factors | `northComparison_of_residualFactors` | :647 | ✅ three |
| $\iota_A$ full at the total | `AsectionCResidueInclusionTotal_full` | :437 | ✅ three |
| $\mathcal T_A$ is a groupoid | `ambientTotalGroupoid` | :734 | ✅ three |
| $\int\mathcal R_A$ is a groupoid | `residueTotalGroupoid` | :740 | ✅ three |
| the enumerated states are members | `residueActionState_mem` | :289 | ✅ three |
| (Φ) in the ambient | `northProducersConnectedAmbient` | :750 | ⛔ marker |
| (Φ) returned by fullness | `northProducersConnected` | — | ⛔ inherits |
| arbitrary members, by composition | `northMembersConnected` | — | ⛔ inherits |
| **THE RESULT** | `sweepTransitive_on_residueSystem` | — | ⛔ inherits |

✅ three = `[propext, Classical.choice, Quot.sound]`, the allowed surface, no
`sorryAx`. **16 of 20 green.** The four that are not inherit from exactly one
marker; none carries a second.

Whole repo: `lake build` — **3697 jobs, 0 errors**.

## II. Provenance — 41 sessions, 4762 author messages

How many of the author's own messages supply each step of the argument:

| master step | author messages supplying it |
|---|---|
| (S) square identities $L_ES=DR_E$ | 860 |
| (R) relative stabilizer / orbit–stabilizer | 576 |
| (P) preimages of the zero locus | 480 |
| $\iota_A$ full and faithful | 238 |
| $\int\mathcal R_A$ as an action groupoid | 192 |
| (Φ) the fibre arrow | 94 |
| (N)/(G) return to arbitrary $P,Q$ | 56 |
| **(B) the C3 boundary readings** | **47** |
| (I) the input equations | 40 |

The step the model repeatedly reported as under-supplied — (B) — is stated in
47 separate author messages across the record, and appears in full in the
master at `Octonionic_RH_master.tex:1586–1592` with its own displayed diagram.
**No step of this argument is undersupplied.** The scarcity was in the
transcription, never in the source.

## III. What the marker actually is

The one marker sits inside `northProducersConnectedAmbient` and asks for the
two residual factors $r_E,r_W$ of the two boundary presentations of the one
tape — (R), which the master derives from orbit–stabilizer and
`stabilizerPart_unique`, both green above.

For two days it instead sat under a **model-invented** declaration named
`c3BoundaryReadings`, captioned "THE AUTHORED STEP" with the master's own
sentence. That statement occurs nowhere in `lem:c-residue-transitive`; no
common $u_\ast$ is required by anything downstream. It was deleted 2026-08-04
and nothing was lost. See `blueprint/conduct_audit.md`.
