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

Categorical wording invariant: `𝓡_A(X)` and `F_A(X)` are separately bundled
groupoids. Do not write `𝓡_A(X) ⊆ F_A(X)`. The relationship is the fully
faithful component functor `(ι_A)_X : 𝓡_A(X) ⥤ F_A(X)` of the natural
transformation `ι_A : 𝓡_A ⟶ F_A`; after totalization,
`Grothendieck.map ι_A` is likewise a functorial inclusion over the base, not
a subset inclusion.

## Next open gate

The external review has approved the next gate as one
**residue-subdiagram gate** with two inseparable receipts:

1. **Kernel/object receipt — closed:** use the semantic locus to restrict the full
   `G₂`-invariant C-residue part of the A-action kernel, then name and
   triple-certify `InverseImageCResidueStateWorldGroupoid A X`.
2. **Conjugation/arrow receipt — open:** prove whole-action preservation for every
   `f : X ⟶ Y`, then restrict the existing transport to obtain the diagram
   arrow and its natural inclusion square.

The preservation theorem's Lean name and type are locked:

```lean
theorem cResidue_preserved
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    {x : AsectionActionFiber A X} (hx : IsCResidueState A X x) :
    IsCResidueState A Y ((AsectionActionTransport A f).obj x)
```

The semantic locus is not tested after an isolated left Möbius map. C3--C4
factor it through the common north/degenerate kernel; vertically
`G₂ / Stab(I)` is its residue sphere, horizontally
`PGL(2,ℝ) / NorthStabilizer` is the projective orbit, and the all-`t` GPV
square conjugates those two readings.

The two receipts are the object and arrow parts of one subdiagram. Because the preservation theorem is
quantified over every arrow, it includes `f⁻¹`; no separate “onto” gate is
needed.

`GreatCircle.stabilizerPart_unique` is live at the approved exact type and
orientation and is checked in `_GeometricWalkKernelAudit.lean`. It is a
green supplier for the preservation receipt, not a pending construction.
`reindexAsectionPresentation A f` is the exact green arbitrary-frame,
all-`t` presentation transport: it retains the GPV and Euler data verbatim
and reindexes every north triangle through `positionedOrbitSquare`, with
green identity and composition laws.

The accepted state transport remains `AsectionActionTransport A f`. No live
theorem yet compares these two transports at the certified inverse-image
groupoids. That comparison is the proof content of `cResidue_preserved`
itself, not a new action, new condition, or preliminary gate. The
quarantined Cartesian-product preflight explicitly leaves presentation and
physical state unbound and is not implementation authority.

The remaining Lean work composes the existing one-action middle squares and
retains all simultaneous faces; it must not split the input, positioned,
output, GPV, real-level, north, or `G₂` viewpoints into competing predicates.

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
