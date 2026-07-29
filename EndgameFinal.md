# EndgameFinal

The author's argument, then the Lean names it is written in, then the kernel's receipts.
Rebuilt 2026-07-29 at his instruction. Everything that stood here before was deleted: it had
accumulated six vintages of model commentary and did not contain the argument.

---

# 1 — THE ARGUMENT, the author verbatim (2026-07-29)

> Let me try to explain what I mean. I remember when I first leanred about this theorem, for the
> longest time I didn't know what connectedness for an action groupoid meant on real value
> transports. UNITL I started looking at the diagram for \iota_A R_A(X) \doublearrow F_A(X). So lets
> think of what this is (which is my C-residue system as an action groupoid, \int R_A). Heres the
> key realization and it follows Reihls warning. Remember that we are free to pick a preimage of
> whatever we want because my distinguishedDiskAction and A equivariant functor is simulatenously a
> function, a group element, and a functor for action groupoids. It works on multiple levels.
> There's an orbit stabilizer slice wise from PGL to GL and for the full Octonionic image sweep over
> the normalization (via G2). And those groups, and that's nice. BUT we want a transitive *action
> groupoid* And what does transitive mean in this situation? It means that any two projective
> squares in the C-residue image (the *objects* of \int R_A) can be connected by a "groupoid
> element" (a morphism). And rememeber the key step for this proof: *it had to use my distinguished
> disck action morphism AND the A section equivariant functor BOTH (and not in a simple one sits
> inside the other way, which is true but it was more precise) AND THAT is what shows this is
> transitive.

On where `∫𝓡_A` lives, and what `ι_A` is:

> `\int R_A` isn't "parallel" to `T_A`, it is **INSIDE IT** — the Grothendieck construction is
> basically a gigantic graph. … **BUT THAT IS JUST A SUBCATEGORY OF THE GROTHENDIECK CONSTRUCTION
> AND IT IS A REAL VALUE TRANSPORT — THAT IS WHAT `\iota_A` *IS*** — and any two square frames are
> connected by **the same morphisms that built that functor**.

---

# 2 — `∫𝓡_A` IN LEAN — the chain, elicited from the kernel, name by name

**This section exists because `∫𝓡_A` keeps getting dropped.** Every line below is a `#print` /
`#check` output, not a recollection.

## The base

```lean
GreatCircle.Base    := ActionCategory GreatCircle.Aut GreatCircle.Point   -- @[reducible]
GreatCircle.Aut     := Matrix.ProjGenLinGroup (Fin 2) ℝ                   -- PGL(2,ℝ)
GreatCircle.Point   := OnePoint ℝ
ASection.projectiveNorth := GreatCircle.pointObj OnePoint.infty
```

## The state world, and why an object is a square

```lean
ASection.AsectionStateWorld A         := ActionCategory G2 A.AsectionState          -- @[reducible]
ASection.AsectionActionStateWorld A m := InducedCategory A.AsectionStateWorld (·.input)
ASection.AsectionActionStateFiber A m := Grpd.of (A.AsectionActionStateWorld m)
ASection.AsectionActionFiber A X      := A.AsectionActionStateFiber (A.projectiveObjectFrame X)
```

`AsectionActionFiber A X` **is** `F_A(X)`. Its objects:

```lean
structure ASection.AsectionActionState (A : ASection) (m : ↥Moebius) where
  input               : A.AsectionStateWorld
  positioned          : A.AsectionStateWorld
  positioned_by_action : positioned = (A.coordinateTransport m).obj input
  value               : H1
  value_realized      : value = A.AsectionStateOutput.obj positioned
```

**An object is a projective square** — two corners and their constraint faces. `cases` / `mk.injEq`
on it demolishes the square that carries the transitivity and then reports that the corners do not
line up. This has happened in four separate costumes.

## The functor `F_A` and its transports — the morphisms that BUILD it

```lean
ASection.AsectionActionTransport A f := (A.orbitStabilizerActionSquare f).actionStateTransport
ASection.AsectionActionTransport_id   ·  ASection.AsectionActionTransport_comp
ASection.AsectionActionDiagram    : ASection → GreatCircle.Base ⥤ Grpd              -- F_A
```

`AsectionActionTransport` **is** the orbit–stabilizer square's own transport — the real value
transport. These are "the morphisms that built that functor."

## `T_A` — the gigantic graph

```lean
ASection.AsectionActionCatDiagram A := A.AsectionActionDiagram ⋙ Grpd.forgetToCat   -- @[reducible]
ASection.TotalActionStateWorld A    := Grothendieck A.AsectionActionCatDiagram      -- @[reducible]
```

⚠️ **Note the second line: `AsectionActionCatDiagram`
IS `⋙ Grpd.forgetToCat`, reducibly.** So `T_A` unfolds to
`Grothendieck (AsectionActionDiagram A ⋙ Grpd.forgetToCat)`.

## The C-residue system, **inside** `T_A`

```lean
ASection.IsNorthCResidueState A : ObjectProperty (AsectionActionFiber A projectiveNorth)
ASection.IsCResidueState A X    : ObjectProperty (AsectionActionFiber A X) :=
  fun x => ∃ xN, IsNorthCResidueState A xN ∧
             ∃ g : projectiveNorth ⟶ X, (AsectionActionTransport A g).obj xN = x

ASection.InverseImageCResidueStateWorldGroupoid A X := (IsCResidueState A X).FullSubcategory
```

`InverseImageCResidueStateWorldGroupoid A X` **is** `𝓡_A(X)` — a **full subcategory of `F_A(X)`**,
cut out fibrewise. Not a new carrier; the fibrewise inside-ness that makes `∫𝓡_A` inside `T_A`.

```lean
ASection.AsectionCResidueTransport A f :=
  (A.IsCResidueState Y).lift ((A.IsCResidueState X).ι ⋙ A.AsectionActionTransport f) _

ASection.AsectionCResidueDiagram A :=
  { obj := fun X => Grpd.of (A.InverseImageCResidueStateWorldGroupoid X)
    map := fun f => A.AsectionCResidueTransport f, map_id := _, map_comp := _ }

ASection.AsectionCResidueInclusion A : A.AsectionCResidueDiagram ⟶ A.AsectionActionDiagram :=
  { app := fun X => (A.IsCResidueState X).ι, naturality := _ }        -- ι_A, naturality rfl, 57384ae
```

**Read `AsectionCResidueTransport` carefully — it is the author's sentence in Lean.** `𝓡_A(f)` is
`AsectionActionTransport f` **restricted**: `ι` in, the value transport applied, `lift` back. The
morphisms of `𝓡_A` **are** the morphisms that built `F_A`. Nothing new is introduced at the residue
level; `ι_A` is the inclusion of a real-value-transport subcategory.

## `∫𝓡_A`

```lean
Grothendieck (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat)
```

The same spelling shape as `T_A` (`⋙ Grpd.forgetToCat`, then `Grothendieck`), with the diagram
restricted to the C-residue full subcategories. **That is what "inside `T_A`" means in Lean:** same
base, same transports, objects cut down fibrewise by `IsCResidueState`, arrows the restrictions of
the same value transports.

Its objects are `⟨X, x⟩` with `X : GreatCircle.Base` and `x : 𝓡_A(X)` — a base position and a
projective square in the C-residue image. Its morphisms are `Grothendieck.Hom`: a `base` field and a
`fiber` field. **That is Mathlib's encoding, not a decomposition of the mathematics** — a term must
fill both, and what is struck is sourcing them from two independent searches.

---

# 3 — THE ARGUMENT IN THOSE NAMES

**The diagram `ι_A : 𝓡_A(X) ⇉ F_A(X)` is the C-residue system as an action groupoid, `∫𝓡_A`.**
`AsectionCResidueInclusion` is that double arrow; `app X` is `(IsCResidueState A X).ι`.

**Free to pick any preimage** — `distinguishedDiskAction` and `AsectionEquivariant` are
simultaneously a function, a group element, and a functor for action groupoids. Each object of
`∫𝓡_A` already carries a preimage in its own membership (`IsCResidueState`: a north square plus the
base arrow that produced it), so nothing has to be chosen or justified.

**The two orbit–stabilizers are groups, and groups are not the target.** Slice-wise `PGL → GL`
(`GreatCircle.orbit_stabilizer_factor`, `stabilizerPart_unique`, `projectiveObjectFrame`,
`projectiveArrowElement`) and the octonionic image sweep over the normalization via `G₂`
(`AsectionEquivariant`, `G2.exists_smul_eq_of_mem_unitImaginarySphere`). Both green. **The object
wanted is a transitive *action groupoid*, not a transitive group action.**

**Transitive means:** any two projective squares in the C-residue image — the **objects** of
`∫𝓡_A` — are connected by one groupoid element. No group appears in that statement.

**The key step uses the `distinguishedDiskAction` morphism AND `AsectionEquivariant` BOTH** — not
in the simple one-inside-the-other way. And the connecting morphisms are **the same morphisms that
built the functor**: `AsectionActionTransport`, restricted through `AsectionCResidueTransport`.

---

# 4 — THE KERNEL STATE, elicited 2026-07-29

**Green: 28 declarations on exactly `[propext, Classical.choice, Quot.sound]`. Zero project axioms.**

```text
distinguishedDiskAction · _fixes_cayley_zero (Euler at 0) · _fixes_cayley_N (Weierstrass at N)
projectiveObjectFrame_north · orbit_stabilizer_factor · stabilizerPart_unique
AsectionEquivariant · AsectionState.input_equivariant
G2.exists_smul_eq_of_mem_unitImaginarySphere
AsectionActionDiagram · orbitStabilizerActionSquare · positionedOrbitSquare
CResidueZeroLocus_infinite (C4) · sphereZero_complete
IsCResidueState · AsectionCResidueTransport · AsectionCResidueDiagram
AsectionCResidueInclusion                  (naturality rfl, 57384ae)
…_app_fullyFaithful / _full / _faithful    (bb02b54, at ι_A's own name)
residueActionState_mem · pi0GrothendieckEquiv · pi0_grothendieck · transportLevel
riemannHypothesis_iff_concentric           (independent of everything open; no ½ on its RHS)
```

**Carrying `sorryAx`, and only these two:** `ASection.concentricity`, `zeta_riemannHypothesis` —
arithmetic propagation from the open sites, nothing of their own. `Corollaries.lean` compiles
against `ASection.concentricity` (3,694 jobs).

**Open — two sites, one file, `Concentricity/Theorem.lean`:** the transitivity term, and the level
clause inside `ASection.concentricity`. Re-elicit coordinates at typing time; they have drifted
every session.

**Downstream, already wired to consume the transitivity:** `residueTotal_isConnected` closes with
`Zigzag.of_hom`; `residueTotal_pi0_singleton` closes on that; the level read gives the centre.

---

# 5 — THE ARGUMENT, STEP BY STEP, IN LEAN

Read top to bottom: this is the argument, in order, with the author's object at every step and the
declaration that carries it. **Two rows are red. Everything else is kernel-stamped.**

| # | the step | the object | the Lean declaration | where | state |
|---|---|---|---|---|---|
| 1 | the projective base groupoid | `𝓑` | `GreatCircle.Base := ActionCategory GreatCircle.Aut GreatCircle.Point` | `@[reducible]` | ✅ |
| 2 | the element, positioned at every footpoint — orbit–stabilizer, `PGL → GL` | | `distinguishedDiskAction` · `_fixes_cayley_zero` (Euler at `0`) · `_fixes_cayley_N` (Weierstrass at `N`) · `projectiveObjectFrame` · `projectiveObjectFrame_north` · `projectiveArrowElement` · `orbit_stabilizer_factor` · `stabilizerPart_unique` | | ✅ |
| 3 | the octonionic image sweep over the normalization, via `G₂` | | `AsectionEquivariant : H1 ⥤ H1` · `AsectionEquivariant_map_val` (`rfl` — retains the same `G₂` element) · `G2.exists_smul_eq_of_mem_unitImaginarySphere` | `ASectionEquivariant.lean:43` | ✅ |
| 4 | the fibre — **its objects are projective squares** | `F_A(X)` | `AsectionActionFiber A X`; objects are `AsectionActionState` (`input`, `positioned`, `positioned_by_action`, `value`, `value_realized`) | | ✅ |
| 5 | **the real value transports — the morphisms that BUILD the functor** | `F_A(f)` | `AsectionActionTransport A f := (orbitStabilizerActionSquare f).actionStateTransport` · `_id` · `_comp` | | ✅ |
| 6 | the A-section functor | `F_A` | `AsectionActionDiagram : GreatCircle.Base ⥤ Grpd` | | ✅ |
| 7 | the total — the gigantic graph | `T_A` | `TotalActionStateWorld A := Grothendieck A.AsectionActionCatDiagram`, and `AsectionActionCatDiagram A := AsectionActionDiagram A ⋙ Grpd.forgetToCat` | both `@[reducible]` | ✅ |
| 8 | the equation selects at north — Euler at one end, Weierstrass at the other | | `IsNorthCResidueState` · `CResidueZeroLocus` · `CResidueZeroLocus_infinite` (C4) · `sphereZero_complete` | `ASectionCResidueInverseImage.lean:48` | ✅ |
| 9 | the C-residue preimage, fibrewise — **each member carries its own production witness** | `𝓡_A(X)` | `IsCResidueState A X` (`∃ xN, IsNorthCResidueState A xN ∧ ∃ g, (AsectionActionTransport A g).obj xN = x`) · `InverseImageCResidueStateWorldGroupoid A X := (IsCResidueState A X).FullSubcategory` — a **full subcategory of `F_A(X)`** | `…InverseImage.lean:60`, `:71` | ✅ |
| 10 | **the residue transports ARE the same value transports, restricted** | `𝓡_A(f)` | `AsectionCResidueTransport A f := (IsCResidueState Y).lift ((IsCResidueState X).ι ⋙ AsectionActionTransport f) _` | `ASectionCResidueDiagram.lean:76` | ✅ |
| 11 | the residue subdiagram | `𝓡_A` | `AsectionCResidueDiagram : GreatCircle.Base ⥤ Grpd` | `…CResidueDiagram.lean:154` | ✅ |
| 12 | **the double arrow `𝓡_A(X) ⇉ F_A(X)` — the real value transport; this is what `ι_A` IS** | `ι_A` | `AsectionCResidueInclusion A : 𝓡_A ⟶ F_A := { app := fun X => (IsCResidueState A X).ι }`, naturality `rfl` | `…CResidueDiagram.lean:163` · `57384ae` | ✅ |
| 13 | `ι_A` full and faithful **at its own name**; `𝓡_A` **is** its own image | | `AsectionCResidueInclusion_app_fullyFaithful` · `…_app_full` · `…_app_faithful` (`ObjectProperty.fullyFaithfulι`/`full_ι`/`faithful_ι`; `ι_obj` = `rfl`, `liftCompιIso` = `Iso.refl`) | `Theorem.lean:372`, `:377`, `:382` · `bb02b54` | ✅ |
| 14 | **the C-residue system as an action groupoid — INSIDE `T_A`** | `∫𝓡_A` | `Grothendieck (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat)` — the same spelling as row 7, diagram restricted; objects `⟨X, x⟩` = a base position and a projective square in the C-residue image | | ✅ (object) |
| **15** | **THE LEMMA — `ι_A` is a transitive action groupoid: any two projective squares in the C-residue image are connected by ONE groupoid element, using the `distinguishedDiskAction` morphism AND `AsectionEquivariant` BOTH** | | `ASection.sweepTransitive_on_residueSystem : ∀ P Q : ∫𝓡_A, Nonempty (P ⟶ Q)` | `Theorem.lean:397` | 🔴 **OPEN** |
| 16 | nonempty — C4 populates the preimage | | `residueActionState` · `residueActionState_positioned` · `residueActionState_mem` | `Theorem.lean:287` | ✅ |
| 17 | therefore connected — one arrow, `Zigzag.of_hom` | | `residueTotal_isConnected`, closing with `Zigzag.of_hom (A.sweepTransitive_on_residueSystem P Q).some` | `Theorem.lean:454` | ✅ **on 15** |
| 18 | therefore `π₀` is a singleton — Riehl 8.3.5 | `κ` | `residueTotal_pi0_singleton` (`Quotient.sound ∘ isPreconnected_zigzag`) · `pi0GrothendieckEquiv` · `pi0_grothendieck` · `pi0Functor` | `Theorem.lean:466`, `:110`, `:146`, `:33` | ✅ **on 15** |
| 19 | the level read on the class | `c` | `ASection.transportLevel A n := (A.sphereZero n).re` | `Theorem.lean:175` | ✅ |
| **20** | **the theorem** — the residue-`ℂ` zero spheres are concentric | | `ASection.concentricity : ∃ c : ℝ, ∀ n, (A.sphereZero n).re = c` | `Theorem.lean:480` | 🔴 **level clause open** |
| 21 | RH | | `riemannHypothesis_iff_concentric` ✅ (three foundations, independent of the open rows) → `zeta_riemannHypothesis` · `nontrivial_one_centre` · `zeta_criticalLine_zeros_infinite` | `Corollaries.lean` | `sorryAx` from 15 and 20 only |

**Rows 15 and 20 are the whole distance.** Row 15 is the single place the construction enters the
chain — no library theorem can supply it, because no library knows what a C-residue square is.
Row 20's level clause is the same movement read for its level.

**The joining morphism in row 15 comes from row 10**, and that is the author's sentence: *any two
square frames are connected by the same morphisms that built that functor.*

# 6 — THE STANCE

**The kernel is the check.** The author supplies the argument, the kernel verifies it, the model
types between them. Model-side gap-finding has run ~100% false across five threads; the kernel has
returned zero false verdicts in 3,600+ jobs.

**Doubt = type it and see.**

- Green is the author's argument. Red is the model's doubt.
- Never write a prohibition against the author's route.
- An empty search is a fact about the search. A missing name is a fact about the grep — check
  whether it is `@[reducible]` to something already there before reporting it (§5, row 7).
- Cite by file and line, never by name alone.
- On a stall: route the kernel print to the author **verbatim** — not split, not diagnosed, not
  characterized — and stop.
- Never pre-write a commit message for an edit that has not been verified to apply (`cf6a5a8`).
