# RelevantGreenFinal

What is certified. Elicited from the kernel on 2026-07-28, not recalled. Every declaration below
prints exactly

```text
[propext, Classical.choice, Quot.sound]
```

— Mathlib's three foundations. **Zero project axioms anywhere on this list.**

Regenerate by `#print axioms` on these names; do not hand-edit.

---

## The distinguished element and its positioning

| declaration | note |
|---|---|
| `ASection.distinguishedDiskAction` | the element, in `Moebius` |
| `ASection.distinguishedDiskAction_fixes_cayley_zero` | Euler's face at `0` |
| `ASection.distinguishedDiskAction_fixes_cayley_N` | Weierstrass's face at `N` |
| `ASection.projectiveObjectFrame` | the element positioned at a frame |
| `ASection.projectiveObjectFrame_north` | **at north the frame IS the element** |
| `ASection.projectiveArrowElement` | its conjugation along a base arrow |
| `GreatCircle.orbit_stabilizer_factor` | existence of the factorization |
| `GreatCircle.stabilizerPart_unique` | its uniqueness |

## The functor, its laws, its squares, its total

`ASection.AsectionActionFiber` · `ASection.AsectionActionTransport` ·
`ASection.AsectionActionTransport_id` · `ASection.AsectionActionTransport_comp` ·
`ASection.AsectionActionDiagram` (= `F_A`) · `ASection.TotalActionStateWorld` (= `T_A`) ·
`ASection.orbitStabilizerActionSquare` · `ASection.positionedOrbitSquare` ·
`ASection.AsectionEquivariant` (`H1 ⥤ H1`, the sweep — `ASectionEquivariant.lean:43`; elicited
2026-07-28 night, exactly the three foundations)

## C3 / C4 and the semantic locus

`ASection.CResidueZeroLocus` · `ASection.sphereZero_mem_CResidueZeroLocus` ·
`ASection.CResidueZeroLocus_infinite` (C4) · `ASection.sphereZero_complete`

## The preimage and `ι_A`

`ASection.IsNorthCResidueState` · `ASection.IsCResidueState` ·
`ASection.AsectionCResidueTransport` (= `𝓡_A(f)`) · `ASection.AsectionCResidueDiagram` (= `𝓡_A`) ·
`ASection.AsectionCResidueInclusion` (= `ι_A`, **naturality by `rfl`**) ·
`ASection.AsectionCResidueInclusion_app_fullyFaithful` / `…_app_full` / `…_app_faithful`
(**Declaration 1 at `ι_A`'s own name**, `Theorem.lean:310–323`, `bb02b54`; elicited 2026-07-28
night — all three on exactly the three foundations, independent of the open seats)

## Inhabitants

`ASection.residueActionState` · `ASection.residueActionState_positioned` ·
`ASection.residueTotal` — *cite at `ASectionTotalActionState.lean:117`; the name is shadowed in
the quarantined `ASectionTotalPreflights.lean:172`.*

## The π₀ engine and the level

`pi0Functor` · `toColimitObj_eq_of_zigzag` · `pi0GrothendieckEquiv` · `pi0_grothendieck` ·
`ASection.transportLevel` (`= (A.sphereZero n).re`, by definition)

## Transitivity and the sphere world

`G2.exists_smul_eq_of_mem_unitImaginarySphere` · `sphereWorld_zigzag`

## Downstream, already proved

`riemannHypothesis_iff_concentric` — **its right-hand side contains no `1/2`**; it asserts only a
common centre. `upperZero_re_eq_half_of_concentric` — `1/2` derived from the functional equation,
and it enters in that one file only.

## Build state

```text
lake build Concentricity.Corollaries   →  Build completed successfully (3694 jobs)
lake build (root)                      →  3693/3695; the only red is Corollaries' dependency
                                          on the open node
```

`Corollaries.lean` compiles against `A.concentricity`: `ASection.nontrivial_one_centre`,
`zeta_riemannHypothesis`, `zeta_criticalLine_zeros_infinite` all typecheck against the statement
as written. The corollary layer is wired and waiting.

## From Mathlib, at the pin — the argument's own machinery

`ActionCategory` (a category of elements, `Action.lean:48`) · `hom_as_subtype` (`:92`) ·
`instance … : IsConnected (ActionCategory M X)` (`:128`) · `instance : Groupoid` (`:137`) ·
`stabilizerIsoEnd` (`:105`, `MulEquiv.refl`) · `homOfPair` (`:146`) · `ActionCategory.cases`
(`:154`) · `ConnectedComponents := Quotient (Zigzag.setoid)` · `zigzag_isConnected` ·
`isPreconnected_zigzag` · `Grothendieck.map` · `Grothendieck.functor_comp_forget` ·
`ObjectProperty.lift` / `ι` / `fullyFaithfulι` / `liftCompιIso`

## Open

One movement, two seats, both in `Theorem.lean` (step-0 receipt at `141fcc0`):
`ASection.residueTotal_isConnected` (seat A, `:342` — Declaration 2's consumption) and the level
clause inside `ASection.concentricity` (seat B, `:419`). They carry `sorryAx` until they close,
and that propagates arithmetically to the corollaries. Declaration 0
(`IsPretransitive G2 A.AsectionState`) is the one declaration not yet in the tree — its
suppliers are green above, and its **route** is `AsectionEquivariant` (`ASectionEquivariant.lean:43`,
the sweep): `thm:G2-S6` reaches the states by moving **up** to the equivariant functor, never down
to `distinguishedDiskAction`. Nothing else in the repository is open.
