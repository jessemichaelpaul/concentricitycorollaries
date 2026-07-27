# Relevant green declarations

This is an evidence ledger. Green declarations support gate receipts but do
not replace them. Gates 1 and 2 are certified; the residue-subdiagram gate
is open.

## Infinite analytic action

Green suppliers include:

- C1 continuation and the common pole/north geometry;
- the infinite Euler prime presentation;
- the infinite Weierstrass divisor presentation;
- C4 infinitude of the residue-`ℂ` zeros;
- the prime-indexed GPV lift, uniqueness, winding, and real-level laws;
- the distinguished diagonal disk action and its fixed points `0`, `N`.

These are faces of one vertically integrated function/Möbius element.

## Normalized input and function eye

Green:

- `Octonion.dir`;
- `Octonion.sliceCoord`;
- `A.realize`;
- `realize_mem_sliceSphere`;
- `sliceCoord_smul_invariant`;
- `realize_equivariant`;
- `AsectionState`;
- `AsectionStateWorld`;
- `AsectionState.smul_coordinate`;
- `AsectionStateInput`;
- `AsectionStateOutput`;
- `AsectionState_input_then_equivariant`;
- `AsectionGenerated`;
- `AsectionGenerated_eq_equivariant`;
- `AsectionGenerated_iso_equivariant`;
- `AsectionEquivariant`.

`AsectionEquivariant` is a genuine point-valued eye, not yet the completed
global receipt.

## SphereWorld and projective geometry

Green:

- `SphereWorld` and its groupoid instance;
- `SphereHom.rot` and `SphereHom.mob`;
- `AsectionSlice`;
- `coordinateTransport`;
- `projectiveObjectFrame`;
- `projectiveArrowElement`;
- `orbitRep`;
- `stabilizerPart`;
- `orbit_stabilizer_factor`;
- `stabilizerPart_unique`;
- identity and composition laws.

`AsectionSlice` is evidence for one sectional projection only.

## Natural action squares

Green:

- `ActionTransportSquare`;
- `orbitStabilizerActionSquare`;
- `positionedOrbitSquare`;
- `positionedOrbitSquare_id`;
- `positionedOrbitSquare_comp`;
- `GpvTransport.actionSquare`;
- `projectiveGpvActionSquare`;
- `projectiveGpvActionSquare_level`;
- `normalizedNActionSquare`;
- `normalizedNActionSquare_level`;
- the input/output commutation readings;
- identity, composition, and inverse receipts where declared.

The all-`t` presentation transport is also green:

- `AsectionPresentation`;
- `reindexAsectionPresentation`;
- `reindexAsectionPresentation_id`;
- `reindexAsectionPresentation_comp`;
- `AsectionPresentationTransport`;
- `AsectionPresentationTransport_id`;
- `AsectionPresentationTransport_comp`.

`reindexAsectionPresentation A f` retains `gpv` and `euler_gpv` verbatim and
reindexes every `toNorth` triangle through `positionedOrbitSquare` at the
corresponding lift instant. It is the exact arbitrary-frame all-`t`
supplier. It is not itself the transport of an object of `F_A(X)`.

These squares supplied Gate-1 evidence and now supply the preservation
evidence for the residue-subdiagram gate. Their separate compilation does
not by itself prove the whole-action residue-preservation theorem.
The open receipt is the comparison of this green presentation transport
with the accepted `AsectionActionTransport A f` at the two certified
inverse-image groupoids. The quarantined Cartesian-product preflight is not
such a comparison.

## Certified Gate-1 object

At frame `X`, the native groupoid is:

```lean
Grpd.of
  (AsectionActionStateWorld A (projectiveObjectFrame A X)).
```

`AsectionActionDiagram A` organizes these element-generated groupoids over
the projective base. The Gate-1 audits certify all normalized inputs and
sphere directions, intrinsic evaluated output, orbit--stabilizer and GPV
naturality, the north-square factorization, and the terminal comparison.
The focused framewise receipt additionally certifies its exact value at
every `X`, including the inherited `G₂` arrows and all three state eyes.

## Semantic C-residue locus

Green:

- `CResidueZeroLocus`;
- `mem_CResidueZeroLocus_iff`;
- `sphereZero_mem_CResidueZeroLocus`;
- `mem_CResidueZeroLocus_iff_exists_sphereZero`;
- `CResidueZeroLocus_eq_range`;
- `CResidueZeroLocus_infinite`.

The locus is defined by `A.F z = 0 ∧ 0 < z.im`. C3 proves its exact divisor
characterization and C4 proves infinitude. No inverse-image groupoid or
preservation theorem is installed with it.

## Generic category theory

Green:

- `pi0Functor`;
- `pi0Cocone`;
- `toColimitObj`;
- `toColimitObj_eq_of_hom`;
- `toColimitObj_eq_of_zigzag`;
- `pi0GrothendieckEquiv`;
- `pi0_grothendieck`.

These are generic machinery only. They do not certify the project
instantiation or the chosen zero system.

## Receipt boundary

Gates 1 and 2 are certified. Gate 2's focused receipt verifies:

- `TotalActionStateWorld A` is definitionally Mathlib's
  `CategoryTheory.Grothendieck
    (AsectionActionDiagram A ⋙ Grpd.forgetToCat)`;
- its objects carry a projective base object and the exact
  element-generated action-state fibre;
- its morphisms carry a base arrow and the induced fibre leg;
- `totalMk` and `totalTransport` expose those fields;
- only `propext`, `Classical.choice`, and `Quot.sound` occur.

The framewise fibre, semantic C-residue locus, and framewise full
inverse-image groupoid receipts are closed. The focused inverse-image audit
checks the literal `Set.preimage`, arbitrary semantic residues and
`SphereWorld` directions, both forcing equations, inherited `G₂` arrows,
the groupoid instance, and the agreed axiom surface. Whole-action
preservation is the next open theorem. Every later categorical readout
remains held.
