# Concentricity — current handoff

Read, in order:

1. `register/00-register.md`
2. `CURRENT_GATE1_MEMORY.md`
3. `EndgamePlan.md`
4. `register/10-proof-outline.md`
5. `register/50-project-instantiation.md`

Do not reconstruct the architecture here; those files are the authority.

## Certified boundary

Gates 1 and 2 are certified. The canonical total is
`TotalActionStateWorld A`. The exact framewise value
`(AsectionActionDiagram A).obj X` and the semantic
`CResidueZeroLocus A` are certified.

The `ι_A` certificate is **not** closed. Commit `52bde67` proves a valid
generic full-subcategory inclusion into `TotalActionStateWorld A`, but that
declaration has the wrong categorical type for this gate and does not
instantiate the naturality square of Jesse's diagram. Do not cite it as the
`ι_A` certificate.

Categorical wording invariant: `𝓡_A(X)` and `F_A(X)` are separately bundled
groupoids. Do not write `𝓡_A(X) ⊆ F_A(X)`. The relationship is the fully
faithful component functor `(ι_A)_X : 𝓡_A(X) ⥤ F_A(X)` of the natural
transformation `ι_A : 𝓡_A ⟶ F_A`; after totalization,
`Grothendieck.map ι_A` is likewise a functorial inclusion over the base, not
a subset inclusion.

Recovery boundary: commit `02b5fd3` permanently records the restored
78-file certified Lean chain and its audit receipts. The governing
documents on disk are newer than their staging-time versions in that
commit; they remain scheduled for the separate governing-document commit.

## Next open gate

Absolute lock: the next gate never leaves
`natural transformation → orbit subgroupoid → groupoid preimage →
AsectionActionDiagram A`. Any object or component source depending on a
free `f` or target `Y`, any new static predicate/carrier, or any generic
substitute is rejected even if it elaborates. The exact live functor is:

```lean
(AsectionActionDiagram A).obj X = AsectionActionFiber A X
(AsectionActionDiagram A).map f = AsectionActionTransport A f

AsectionActionTransport A f :
  AsectionActionFiber A X ⟶ AsectionActionFiber A Y
```

The source and target are already the exact fibres `F_A(X)` and `F_A(Y)`;
the functor already acts on their objects and arrows. Keep the certified
orbit-wise groupoid preimage `InverseImageCResidueStateWorldGroupoid A X`,
assemble the fixed diagram, and expose its component inclusions. The
required output types are:

```lean
AsectionCResidueDiagram A : GreatCircle.Base ⥤ Grpd
AsectionCResidueInclusion A :
  AsectionCResidueDiagram A ⟶ AsectionActionDiagram A
```

At free `X`, `Y`, and `f`, the focused consumer must visibly instantiate:

```text
F_A(X), F_A(Y), F_A(f),
𝓡_A(X), 𝓡_A(Y), 𝓡_A(f),
(ι_A)_X, (ι_A)_Y, and the naturality square.
```

The top map is the restriction of the already-certified
`AsectionActionTransport A f`; its compatibility with the component
inclusions is supplied by the existing categorical machinery. Any
`ObjectProperty.lift` term is internal to the exact A-specific bundled
construction; it is never a separate proof subject or permission to define
another preimage. Do not unfold or analyze the zero locus during this
checkpoint.

The literal `positionedOrbitSquare A f (1 : Moebius)` receipt identifies the
native member of the existing all-`d` family underlying the same action. It
is provenance for `AsectionActionTransport`, not a second construction.

## Unified endgame boundary

The review is complete, so the unified endgame gate is authorized in the
order and with the internal kernel checkpoints recorded in
`register/70-whole-square.md`. Do not edit `Octonionic_RH_master.tex`.

After the residue diagram and its inclusion are certified, recognize its
total as the categorified orbit--stabilizer action already built, apply
Riehl Remark 8.3.5 to its categorical one-component calculation and the
separate components comparison, then descend the action's existing
`ℝ`-valued real-level orbit invariant to `val_A`. The certified inverse
image already has inhabitants; C4 supplies infinitude. No topological
connectedness statement occurs. The codomain is fixed by that invariant,
not selected by a later cone. Thomason's homotopy-colimit comparison is a
sourced post-Lean route that computes more structure; it is not part of the
current gate.
