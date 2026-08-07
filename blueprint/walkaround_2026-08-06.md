# Walk-around — what is standing, 2026-08-06 evening

Written while Codex runs the winding-as-base-arrow change. No claims here that
a program did not print; every status line names the program that said it.

## The two holes, and only two

`lake build Concentricity.Theorem`, forced with `touch` (an unchanged job count
after an edit means the file was not recompiled — that mistake was made twice
today):

```
warning: Concentricity/Theorem.lean:969:8: declaration uses `sorry`
warning: Concentricity/Theorem.lean:1011:8: declaration uses `sorry`
Build completed successfully (3655 jobs).
```

- `sweepTransitive_on_residueSystem` — the north comparison.
- `transportLevel_of_pi0_singleton` — the val step, the register crossing from
  an equality of π₀ classes to an equality in `ℝ`. Its docstring has called it
  the second unformalized input since it was written.

`residueTotal_pi0_singleton` is **not** a hole; it is proved at `:997` from
`residueTotal_pi0_singleton_of_connected` and only inherits. Two reports today
named it wrongly.

## What the certificate table says

`BlueprintLeanCertificateTable.md`: 9 terminal certificates, 6 inference
certificates, allowed axiom surface `[propext, Classical.choice, Quot.sound]`.

Terminal, and therefore not to be retyped without counting the cost:
`G2.exists_smul_eq_of_mem_unitImaginarySphere`, `H1`, `SphereWorld`,
`GreatCircle.Base`, `GreatCircle.orbitRep_spec`, `CategoryTheory.Grothendieck`,
`ASection.CResidueZeroLocus`, **`ASection.AsectionCResidueDiagram`**,
**`ASection.AsectionCResidueInclusion`**.

The last two are what a base-register change would touch, and
`residueTotalCategory` is `Grothendieck (AsectionCResidueDiagram ⋙
Grpd.forgetToCat)` by `rfl`, so the endgame chain hangs off them.

Two rows of that table are now stale: the production seat is listed as
`ASection.northProducersConnected`, which was deleted this morning, and the
binding rows still name `kE`, `kW`, `uStar` — the seven-deletion objects.

## Codex's finding, stated plainly

The winding is a **base** movement. The current encoding gives it nowhere to
live, so every attempt pushed it into a fibre hom, and a fibre hom of
`AsectionStateWorld` preserves the input coordinate — which is why every route
terminated in the false `u₁ = u₂` or in a demand for a north-stabilizer element
to repair it. That is a representation finding, not a mathematical objection,
and it accounts for the whole shape of the failure.

## Tonight's six re-derivations, so they are not paid for again

Each began the same way: a step whose term was not visible, filled with an
existential rather than left as the report.

1. `∃ rE rW uStar` — the inherited statement.
2. Renaming to `r₁ r₂` and believing the structure changed.
3. `northComparison_of_boundaryReadings` (`cc4a74d`) — the same content stated
   on (B) instead of on an existential, still taking two runs as bare
   hypotheses with nothing behind them.
4. `faceOfStabilizerPart r₁`, `faceOfStabilizerPart r₂` — the constructor used
   backwards: it is for when `r` is already in hand, and using it to *obtain*
   `r` regenerates the existential exactly.
5. Searching `CayleyDictionary.lean`, outside the seat's read surface, for a
   transitivity fact to satisfy an obligation that had just been manufactured.
6. `k := 𝟙`, which demands `u₁ = u₂`.

The 2026-08-04 adjudication in `scripts/prior_disproof.py` already contains
item 3 under a different name: *"the seat needs a statement named
`c3BoundaryReadings` — statement invented by the model; deleted, nothing
lost."* Thirteen doubts raised over the project, zero survived.

## What is green and unaffected by any of it

The algebra of the comparison, typed today and elaborating with no error:
(S)+(B)+(P) ⟹ (I) is `inputEquation_of_boundaryReading`; (R) is
`stabilizerPart_comp` with `stabilizerPart_inv`; the direction half is
`northFiberHom_of_coordinate`, which discharges `I₁ → I₂` by `G₂` and never
reaches the coordinate goal. Everything from the hypotheses forward to `ι_A`
full and faithful is untouched by tonight.

## Stale registers — fixed, and the two that need the author

**Fixed.** `blueprint/lean_certificate_manifest.json`: the five `seat1`
bindings (`kE`, `kW`, `uStar`, `hE`, `hW`) all had
`target_declaration = ASection.northComparison_of_parallelFaces`, which was
deleted in `a6bdaf7`, so they could never probe and rendered as
`AUTHOR_BINDING_TARGET_MISMATCH`. Removed. The open seat named
`ASection.northProducersConnected`, also deleted; repointed to
`ASection.sweepTransitive_on_residueSystem`, where the `sorry` actually is.

**Not regenerated, deliberately.** `BlueprintLeanCertificateTable.md`,
`Ledger.md`, the two `ProvenanceLedger` PDFs and the certificate evidence files
were regenerated once and then restored to `HEAD`. Both generators ran while
`ASectionCResidueInverseImage.olean` was absent — the tree was mid-edit — so
every inference receipt came back `NOT_CERTIFIED` with

```
error: object file '.lake/build/lib/lean/Concentricity/ASectionCResidueInverseImage.olean'
of module Concentricity.ASectionCResidueInverseImage does not exist
```

and `Ledger.md` took a `RECEIPT_PRODUCER_REJECTED` stamp across its rows. That
is a missing object file, not a mathematical verdict. **Regenerate both once
the tree is whole**; the manifest correction above is what makes the
regeneration correct when it happens.

**Needs the author — outside the seat's read surface.** `AGENTS.md` and
`TransitivityIntRA.md` still give the retired argument as a *procedure*.
`AGENTS.md:381` hands an agent the literal line

```
exact northComparison_of_parallelFaces A kE kW _ _ uStar hE hW
```

with the same route at `:60`, `:131`, `:140`, `:200`, `:206`, `:224`, and
`TransitivityIntRA.md` at `:20`, `:25`, `:598`--`:613`, `:793`. Every one of
those names a declaration deleted in `a6bdaf7`. This is the re-installation
mechanism the 2026-08-06 loop ran on — an agent reads the entry-point file, the
two-faces frame is reinstated, and the search for `kE`, `kW`, `u_*` starts
again. The declarations are gone from the Lean and the master's tags are fixed;
these two files are where the old argument still reads as current.

## Standing note for the next session

`AsectionCResidueDiagram` and `AsectionCResidueInclusion` are terminal
certificates below the ι line the author said was built correctly with his
objects. Add beside them; do not retype them in a single shot.
