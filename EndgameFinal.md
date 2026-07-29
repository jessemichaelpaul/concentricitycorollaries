# EndgameFinal

The author's argument, stated so that it can be typed once and go green: his words, the precise
statement of each clause, the Lean objects that carry it, and the exact Mathlib declaration each
step consumes. Draft of 2026-07-29; every Lean line is `#print`/`#check` output or a verified
`file:line`, never a recollection.

---

# 0 — WHAT `ι_A` IS, AND WHAT `∫𝓡_A` IS

**The author, 2026-07-29, correcting a model gloss that had been written into this section:**

> It is a natural transformation **OF THE TOTAL GROTHENDIECK CONSTRUCTION**. It is an inverse image
> **OF** the total `F_A(X)`.

**`F_A(X)` is the total. `𝓡_A(X)` is the inverse image of that total. `ι_A` is the inclusion of
the one in the other — a natural transformation of the total Grothendieck construction.** That is
what `ι_A` is, and every statement about it belongs there.

| | `ι_A` | `∫𝓡_A` |
|---|---|---|
| what it **is** | the **inverse image of the total `F_A`**, included in it — a natural transformation **of the total Grothendieck construction** | that inverse image **as a category**: a `Type` with a `Category` instance |
| at the total | `Grothendieck.map (Functor.whiskerRight (AsectionCResidueInclusion A) Grpd.forgetToCat) : ∫𝓡_A ⥤ T_A` | `Grothendieck (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat)`, sitting inside `T_A` |
| its presentation | `AsectionCResidueInclusion A : 𝓡_A ⟶ F_A`, componentwise `(IsCResidueState A X).ι`, naturality `rfl` | objects `⟨base, fiber⟩`; morphisms `Grothendieck.Hom` |
| kind | a **morphism** | a **category** |
| can it be `IsConnected`? | **no** — `IsConnected` takes a category | **yes** — this is where connectedness is stated |

**Why the inverse-image reading is the load-bearing one.** `IsCResidueState`
(`ASectionCResidueInverseImage.lean:60`) is a preimage taken *under the action*: membership is
`∃ xN, IsNorthCResidueState A xN ∧ ∃ g : projectiveNorth ⟶ X, (AsectionActionTransport A g).obj xN = x`.
The file's own name says it — `InverseImageCResidueStateWorldGroupoid`. Nothing is cut out by an
external test after the fact; the base arrow and the action are **part of the preimage itself**.

**Consequence for the open term.** The author's sentence is *"`ι_A` is a transitive action
groupoid."* In Lean that sentence is **stated about `∫𝓡_A`**:

```lean
∀ P Q : Grothendieck (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat), Nonempty (P ⟶ Q)
```

**The subject is `ι_A`; the type is `∫𝓡_A`.** Both readings are needed and neither may replace the
other.

**`∫𝓡_A` is INSIDE `T_A`** — *"the Grothendieck construction is basically a gigantic graph"* — and
the functor above is that inside-ness, kernel-accepted 2026-07-29. Pins: `Grothendieck.map`
(`Grothendieck.lean:242`), `Functor.whiskerRight`, `Grpd.forgetToCat` (`Grpd/Basic.lean:77`).
Because `ι_A` is full and faithful at each `X` (`bb02b54`) and `𝓡_A` is definitionally its own
image (`ι_obj` = `rfl`, `FullSubcategory.lean:62`; `liftCompιIso` = `Iso.refl`, `:167`), that
functor is an **isomorphism onto its image** — so a property proved of `∫𝓡_A` *is* a property of
`ι_A`'s image inside `T_A`. That is *"a transitive action groupoid whose fully faithful image is
`∫𝓡_A`."*

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

> `\int R_A` isn't "parallel" to `T_A`, it is **INSIDE IT** — the Grothendieck construction is
> basically a gigantic graph. … **BUT THAT IS JUST A SUBCATEGORY OF THE GROTHENDIECK CONSTRUCTION
> AND IT IS A REAL VALUE TRANSPORT — THAT IS WHAT `\iota_A` *IS*** — and any two square frames are
> connected by **the same morphisms that built that functor**.

> This is transitivity of an action groupoid, `\int R_A` **NOT *group theory***. It is at the level
> of the **categorification of orbit-stabilizer theory** and it is about transitivity of the **real
> value transport `\iota_A`**, which is a *transitive action groupoid* whose **fully faithful image
> is `\int R_A`**.

---

# 2 — THE ARGUMENT MADE PRECISE, clause by clause

Each entry keeps the author's clause and states it in the register where it can be typed. **The
prose is not replaced; it is pinned.**

### "the diagram for `ι_A` : `𝓡_A(X) ⇉ F_A(X)`"

**Positively, in the author's terms:** `F_A(X)` is **the total**. `𝓡_A(X)` is **the inverse image
of that total**. `ι_A` is the inclusion of the one in the other — **a natural transformation of the
total Grothendieck construction**. That is the whole of what `ι_A` is, and it is where every
statement about it belongs.

**Lean, at the total:**

```lean
Grothendieck.map (Functor.whiskerRight (AsectionCResidueInclusion A) Grpd.forgetToCat)
  : Grothendieck (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat)     -- 𝓡_A(X), the inverse image
  ⥤ Grothendieck (AsectionActionDiagram   A ⋙ Grpd.forgetToCat)     -- F_A(X), the total
```

**Mathlib:** `Grothendieck.map` (`Grothendieck.lean:242`) · `Functor.whiskerRight` ·
`Grpd.forgetToCat` (`Grpd/Basic.lean:77`).

### "which is my C-residue system as an action groupoid, `∫𝓡_A`"

**Precisely (the author):** the **inverse image of the total `F_A`**, as a category — it sits
**inside** `T_A`, it is not a second total built alongside it. `ι_A` itself does not occur in its
type: the type names only the restricted diagram.
**Lean:** `Grothendieck (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat)`.
**Mathlib:** `Grothendieck` (`Grothendieck.lean:73`), `Grothendieck.Hom` (`:86`),
`Grpd.forgetToCat` (`Grpd/Basic.lean:77`).

### "we are free to pick a preimage of whatever we want"

**Precisely:** no preimage has to be chosen, because membership **is** the preimage datum — an
object of `𝓡_A(X)` carries, in its own `IsCResidueState` witness, a north object and a base arrow
that produced it. Choice never enters.
**Lean:** `IsCResidueState` (`ASectionCResidueInverseImage.lean:60`) —
`∃ xN, IsNorthCResidueState A xN ∧ ∃ g : projectiveNorth ⟶ X, (AsectionActionTransport A g).obj xN = x`.

### "any two projective squares in the C-residue image (the *objects* of `∫𝓡_A`) can be connected by a groupoid element (a morphism)"

**Precisely:** `∀ P Q : ∫𝓡_A, Nonempty (P ⟶ Q)`. Objects are `⟨X, x⟩` — a base position and a
projective square. A square is `AsectionActionState`: two corners and their constraint faces;
`cases`/`mk.injEq` destroys it.
**Lean:** `ASection.sweepTransitive_on_residueSystem` (`Theorem.lean:397`) — **the one open term**.

### "it had to use my distinguished disk action morphism AND the A section equivariant functor BOTH (and not in a simple one sits inside the other way)"

**Precisely:** the joining datum is **one** groupoid element in which both mechanisms are present.
Not two legs assembled, and not one mechanism containing the other. `Grothendieck.Hom`'s `base` and
`fiber` fields are **Mathlib's encoding** (`Grothendieck.lean:86`), not a decomposition of the
mathematics: a term fills both, and what is struck is sourcing them from two independent searches.

### "any two square frames are connected by the same morphisms that built that functor"

**At the total, and this is the supplier:** a morphism of `𝓡_A(X)` **is** a morphism of `F_A(X)` —
same base leg, same value transport. `ι_A` introduces nothing at the inverse image; it carries each
morphism across unchanged.
**Lean:** `Grothendieck.Hom` is the morphism at both totals, and
`Grothendieck.map (Functor.whiskerRight (AsectionCResidueInclusion A) Grpd.forgetToCat)` is what
carries one to the other.
**Mathlib:** `Grothendieck.Hom` (`Grothendieck.lean:86`) · `Grothendieck.map` (`:242`) ·
`Grothendieck.functor_comp_forget` (`:269`).

### "a transitive action groupoid whose fully faithful image is `∫𝓡_A`"

**At the total:** `Grothendieck.map (Functor.whiskerRight (AsectionCResidueInclusion A) Grpd.forgetToCat)`
is an isomorphism onto its image inside `F_A(X)` — the inverse image sits in the total as itself,
nothing collapsed and nothing added.
**Certified:** `AsectionCResidueInclusion_app_fullyFaithful` / `…_app_full` / `…_app_faithful`
(`Theorem.lean:372`, `:377`, `:382`, `bb02b54`), on exactly the three foundations.
**Registration note, kernel-elicited 2026-07-29:** the *total-level* heads `.Full` and `.Faithful`
for that functor **fail to synthesize** — they are not registered anywhere in the tree. That is a
fact about the name, not the object: the same empty shelf that hid Declaration 1 under `ι` instead
of `ι_A`'s own name until `bb02b54`.

### "connectedness for an action groupoid … on real value transports"

**Precisely:** one morphism between any two objects gives `Zigzag`; `Zigzag` for all pairs gives
`IsConnected`; `IsConnected` with `Nonempty` gives the `π₀` singleton (Riehl 8.3.5).
**Mathlib:** `Zigzag` (`IsConnected.lean:314`) · `Zigzag.of_hom` (`:341`) · `zigzag_isConnected` ·
`isPreconnected_zigzag` · `ConnectedComponents` (`ConnectedComponents.lean:40`).

---

# 3 — THE LEAN CHAIN, kernel-elicited, with its Mathlib pin

**This section exists because `∫𝓡_A` keeps getting dropped.**

```lean
-- the base                                        pin: ActionCategory, Action.lean:48
GreatCircle.Base    := ActionCategory GreatCircle.Aut GreatCircle.Point   -- @[reducible]
GreatCircle.Aut     := Matrix.ProjGenLinGroup (Fin 2) ℝ                   -- PGL(2,ℝ)
GreatCircle.Point   := OnePoint ℝ
ASection.projectiveNorth := GreatCircle.pointObj OnePoint.infty

-- the state world                                 pin: ActionCategory :48, InducedCategory
ASection.AsectionStateWorld A         := ActionCategory G2 A.AsectionState          -- @[reducible]
ASection.AsectionActionStateWorld A m := InducedCategory A.AsectionStateWorld (·.input)
ASection.AsectionActionStateFiber A m := Grpd.of (A.AsectionActionStateWorld m)      -- Grpd/Basic:54
ASection.AsectionActionFiber A X      := A.AsectionActionStateFiber (A.projectiveObjectFrame X)

-- an OBJECT IS A PROJECTIVE SQUARE (never `cases` it)
structure ASection.AsectionActionState (A : ASection) (m : ↥Moebius) where
  input                : A.AsectionStateWorld
  positioned           : A.AsectionStateWorld
  positioned_by_action : positioned = (A.coordinateTransport m).obj input
  value                : H1
  value_realized       : value = A.AsectionStateOutput.obj positioned

-- the real value transports — THE MORPHISMS THAT BUILD THE FUNCTOR
ASection.AsectionActionTransport A f := (A.orbitStabilizerActionSquare f).actionStateTransport
ASection.AsectionActionTransport_id · ASection.AsectionActionTransport_comp
ASection.AsectionActionDiagram : ASection → GreatCircle.Base ⥤ Grpd                  -- F_A

-- the gigantic graph                              pin: Grothendieck, Grothendieck.lean:73
ASection.AsectionActionCatDiagram A := A.AsectionActionDiagram ⋙ Grpd.forgetToCat    -- @[reducible]
ASection.TotalActionStateWorld A    := Grothendieck A.AsectionActionCatDiagram        -- T_A, @[reducible]

-- the C-residue system, INSIDE it                 pin: ObjectProperty.FullSubcategory :58/:161
ASection.IsNorthCResidueState A : ObjectProperty (AsectionActionFiber A projectiveNorth)  -- :48
ASection.IsCResidueState A X    : ObjectProperty (AsectionActionFiber A X)                -- :60
  := fun x => ∃ xN, IsNorthCResidueState A xN ∧
                ∃ g : projectiveNorth ⟶ X, (AsectionActionTransport A g).obj xN = x
ASection.InverseImageCResidueStateWorldGroupoid A X := (IsCResidueState A X).FullSubcategory  -- :71
ASection.AsectionCResidueTransport A f :=                                                     -- :76
  (A.IsCResidueState Y).lift ((A.IsCResidueState X).ι ⋙ A.AsectionActionTransport f) _
ASection.AsectionCResidueDiagram A : GreatCircle.Base ⥤ Grpd                                  -- :154

-- ι_A : THE INVERSE IMAGE **OF** THE TOTAL F_A, included in it (the author).
--       Below is its PRESENTATION, componentwise; its total-level reading is the last block.
--                                                 pin: ObjectProperty.ι, FullSubcategory:58
ASection.AsectionCResidueInclusion A : A.AsectionCResidueDiagram ⟶ A.AsectionActionDiagram    -- :163
  := { app := fun X => (A.IsCResidueState X).ι, naturality := rfl }        -- 57384ae

-- ∫𝓡_A : THE CATEGORY                             pin: Grothendieck :73, Grothendieck.Hom :86
Grothendieck (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat)

-- ∫𝓡_A INSIDE T_A                                 pin: Grothendieck.map :242, Functor.whiskerRight
Grothendieck.map (Functor.whiskerRight (AsectionCResidueInclusion A) Grpd.forgetToCat)
```

---

# 4 — THE MATHLIB PINS — every declaration the argument consumes

Verified `file:line` under `Mathlib/CategoryTheory/`.

| pin | where | what the argument uses it for |
|---|---|---|
| `ActionCategory` | `Action.lean:48` | the base, and the state world: both levels are literally action categories |
| `ActionCategory.hom_as_subtype` | `Action.lean:92` | an arrow **is** one group element — the group-level reading |
| `ActionCategory.stabilizerIsoEnd` | `Action.lean:105` | **the categorification**: stabilizer = endomorphism monoid, `MulEquiv.refl` |
| `instance … IsConnected (ActionCategory M X)` | `Action.lean:128` | the **group-level** route, consuming `IsPretransitive`. Kernel-settled unclosable on the raw states — listed to keep the two notions apart, not used |
| `instance : Groupoid (ActionCategory G X)` | `Action.lean:137` | why every fibre is a groupoid |
| `ActionCategory.homOfPair` · `.cases` | `Action.lean:146`, `:154` | constructing / destructing group-level arrows |
| `Grothendieck` | `Grothendieck.lean:73` | `T_A` and `∫𝓡_A` |
| `Grothendieck.Hom` | `Grothendieck.lean:86` | **the encoding**: `base` + `fiber` fields |
| `Grothendieck.map` | `Grothendieck.lean:242` | **`∫𝓡_A` inside `T_A`**, applied to `ι_A` |
| `Grothendieck.functor_comp_forget` | `Grothendieck.lean:269` | compatibility of `map` with the forgetful leg |
| `Grothendieck.ι` | `Grothendieck.lean:545` | the fibre inclusion, used by `pi0Cocone` |
| `Functor.whiskerRight` | — | turning `ι_A` into a transformation of `Cat`-valued diagrams |
| `Grpd.of` · `Grpd.forgetToCat` | `Grpd/Basic.lean:54`, `:77` | groupoid-valued diagrams into `Cat` |
| `ObjectProperty.ι` | `FullSubcategory.lean:58` | **`ι_A`'s component at each `X`** |
| `ObjectProperty.ι_obj` = `rfl` | `FullSubcategory.lean:62` | `𝓡_A` **is** its own image, definitionally |
| `ObjectProperty.fullyFaithfulι` (consumed at `:98`) · `full_ι` `:98` · `faithful_ι` `:99` | `FullSubcategory.lean` | Declaration 1, at `ι_A`'s own name |
| `ObjectProperty.lift` | `FullSubcategory.lean:161` | `𝓡_A(f)` as the restriction of `F_A(f)` |
| `ObjectProperty.liftCompιIso` = `Iso.refl` | `FullSubcategory.lean:167` | the library's own word: *definitionally* |
| `Zigzag` · `Zigzag.of_hom` · `Zigzag.setoid` | `IsConnected.lean:314`, `:341`, `:375` | **one morphism ⟹ connected** |
| `zigzag_isConnected` · `isPreconnected_zigzag` | `IsConnected.lean` | connectedness from all-pairs zigzags, and back |
| `isConnected_of_equivalent` | `IsConnected.lean:262` | transport of connectedness along an equivalence |
| `ConnectedComponents` | `ConnectedComponents.lean:40` | `π₀` as `Quotient Zigzag.setoid` |
| `Limits.colimit` · `colimit.ι` · `colimit.desc` · `Types.jointly_surjective'` | Mathlib `Limits` | the `π₀`-of-Grothendieck equivalence (`lem:pi0-grothendieck`) |

---

# 5 — GREEN, by the clause of the argument it certifies

**41 declarations — every name in the table below — each printing exactly
`[propext, Classical.choice, Quot.sound]`. Zero project axioms.** Re-elicited 2026-07-29 by
`#print axioms` over this exact list; 41 of 41 clean.

| the author's clause | the certified declarations |
|---|---|
| *"simultaneously a function, a group element, and a functor"* | `distinguishedDiskAction` · `_fixes_cayley_zero` (Euler at `0`) · `_fixes_cayley_N` (Weierstrass at `N`) · `projectiveObjectFrame` · `projectiveObjectFrame_north` · `projectiveArrowElement` |
| *"an orbit stabilizer slice wise from PGL to GL"* | `GreatCircle.orbit_stabilizer_factor` · `GreatCircle.stabilizerPart_unique` |
| *"the full Octonionic image sweep over the normalization (via G2)"* | `AsectionEquivariant` · `AsectionEquivariant_map_val` · `AsectionState.input_equivariant` · `G2.exists_smul_eq_of_mem_unitImaginarySphere` |
| *"the same morphisms that built that functor"* | `AsectionActionTransport` · `_id` · `_comp` · `orbitStabilizerActionSquare` · `positionedOrbitSquare` · `AsectionActionDiagram` · `TotalActionStateWorld` |
| *"the C-residue image"* | `CResidueZeroLocus` · `sphereZero_mem_CResidueZeroLocus` · `CResidueZeroLocus_infinite` (C4) · `sphereZero_complete` · `IsNorthCResidueState` · `IsCResidueState` · `AsectionCResidueTransport` · `AsectionCResidueDiagram` |
| *"a real value transport — that is what `ι_A` IS"* | `AsectionCResidueInclusion`, naturality `rfl` — **`57384ae`** |
| *"whose fully faithful image is `∫𝓡_A`"* | `…_app_fullyFaithful` · `…_app_full` · `…_app_faithful` — **`bb02b54`** |
| the objects exist (C4 populates the preimage) | `residueActionState` · `residueActionState_positioned` · `residueActionState_mem` |
| *"connectedness … on real value transports"*, once transitivity is in hand | `pi0Functor` · `pi0Cocone` · `toColimitObj_eq_of_zigzag` · `pi0GrothendieckEquiv` · `pi0_grothendieck` · `transportLevel` |
| RH's other half, independent of everything open | `riemannHypothesis_iff_concentric` — **no `½` on its RHS**; the `½` comes from the functional equation in one file only |

**Also green in `Theorem.lean`, and NOT the result:** `AsectionEquivariant_transitive` (`6596e04`)
and `AsectionEquivariant_transitive_states` (`8907f88`). Both quantify over the ambient world and
mention `ι_A` nowhere; they are `thm:G2-S6` re-spelled through the sweep. They are **suppliers at
most** — badging them as the transitivity of `ι_A` is what misled the team on 2026-07-29 and the
badge is retracted in their own docstrings (`4a167be`).

**Carrying `sorryAx`, and only these two:** `ASection.concentricity`, `zeta_riemannHypothesis` —
arithmetic propagation from the open sites. `Corollaries.lean` compiles against
`ASection.concentricity` (3,694 jobs).

---

# 6 — THE ARGUMENT, STEP BY STEP, IN LEAN

Read top to bottom. **Two rows are red; everything else is kernel-stamped.**

| # | the step | object | Lean declaration | Mathlib pin | state |
|---|---|---|---|---|---|
| 1 | the projective base groupoid | `𝓑` | `GreatCircle.Base := ActionCategory GreatCircle.Aut GreatCircle.Point` | `Action.lean:48` | ✅ |
| 2 | the element, positioned at every footpoint (`PGL → GL`) | | `distinguishedDiskAction` · `projectiveObjectFrame` · `projectiveObjectFrame_north` · `orbit_stabilizer_factor` · `stabilizerPart_unique` | — | ✅ |
| 3 | the octonionic image sweep over the normalization (`G₂`) | | `AsectionEquivariant : H1 ⥤ H1` · `AsectionEquivariant_map_val` · `G2.exists_smul_eq_of_mem_unitImaginarySphere` | `Action.lean:48` (`H1` is an action category) | ✅ |
| 4 | the fibre — **its objects are projective squares** | | `AsectionActionFiber`; objects `AsectionActionState` (two corners, three constraint faces) | `InducedCategory`, `Grpd.of` (`:54`) | ✅ |
| 5 | **the real value transports — the morphisms that build it** | | `AsectionActionTransport := (orbitStabilizerActionSquare f).actionStateTransport` · `_id` · `_comp` | — | ✅ |
| 6 | **`F_A(X)` — THE TOTAL.** The gigantic graph the argument lives in | `F_A(X)` = `T_A` | `TotalActionStateWorld := Grothendieck AsectionActionCatDiagram`, i.e. `Grothendieck (AsectionActionDiagram A ⋙ Grpd.forgetToCat)` | `Grothendieck.lean:73`, `Grpd/Basic:77` | ✅ |
| 7 | the preimage taken **under the action** — each member carries the north object and the base arrow that produced it | | `IsCResidueState := fun x => ∃ xN, IsNorthCResidueState A xN ∧ ∃ g, (AsectionActionTransport A g).obj xN = x` | — | ✅ |
| 8 | **the residue transports ARE the value transports, restricted** | | `AsectionCResidueTransport := (IsCResidueState Y).lift ((IsCResidueState X).ι ⋙ AsectionActionTransport f)` | `lift` `:161`, `ι` `:58` | ✅ |
| 9 | **`𝓡_A(X)` — THE INVERSE IMAGE OF THE TOTAL.** Not a diagram: the part of `F_A(X)` that `ι_A` includes | `𝓡_A(X)` = `∫𝓡_A` | `Grothendieck (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat)` | `Grothendieck.lean:73`, `:86` | ✅ |
| 10 | **`ι_A` — the inclusion of the inverse image in the total.** A natural transformation of the total Grothendieck construction; a real value transport | `ι_A` | `Grothendieck.map (Functor.whiskerRight (AsectionCResidueInclusion A) Grpd.forgetToCat) : 𝓡_A(X) ⥤ F_A(X)` | `Grothendieck.map` `:242`, `Functor.whiskerRight` | ✅ `57384ae` |
| 11 | `ι_A` full and faithful; `𝓡_A(X)` **is** its image | | `…_app_fullyFaithful` / `…_app_full` / `…_app_faithful` | `full_ι` `:98`, `faithful_ι` `:99`, `ι_obj` `:62`, `liftCompιIso` `:167` | ✅ `bb02b54` |
| **12** | **THE TERM — `ι_A` is a transitive action groupoid: any two projective squares in the C-residue image joined by ONE groupoid element, using the `distinguishedDiskAction` morphism AND `AsectionEquivariant` BOTH** | | `sweepTransitive_on_residueSystem : ∀ P Q : 𝓡_A(X), Nonempty (P ⟶ Q)` | supplier is row 8 | 🔴 **OPEN**, `Theorem.lean:397` |
| 13 | nonempty — C4 populates the inverse image | | `residueActionState` · `residueActionState_mem` · `CResidueZeroLocus_infinite` | — | ✅ |
| 14 | therefore connected — **one morphism** | | `residueTotal_isConnected`, closing on row 12 | `Zigzag.of_hom` `:341`, `zigzag_isConnected` | ✅ **on 12** |
| 15 | therefore `π₀` is a singleton — Riehl 8.3.5 | `κ` | `residueTotal_pi0_singleton` · `pi0GrothendieckEquiv` · `pi0_grothendieck` | `ConnectedComponents` `:40`, `isPreconnected_zigzag`, `Limits.colimit` | ✅ **on 12** |
| 16 | the level read on the class | `c` | `transportLevel A n := (A.sphereZero n).re` | — | ✅ |
| **17** | **the theorem** — the residue-`ℂ` zero spheres are concentric | | `ASection.concentricity : ∃ c, ∀ n, (A.sphereZero n).re = c` | — | 🔴 **level clause**, `Theorem.lean:480` |
| 18 | RH | | `riemannHypothesis_iff_concentric` ✅ → `zeta_riemannHypothesis` · `nontrivial_one_centre` · `zeta_criticalLine_zeros_infinite` | — | `sorryAx` from 12, 17 only |

**Rows 12 and 17 are the whole distance.** Row 12's joining morphism comes from **row 8** — *any
two square frames are connected by the same morphisms that built that functor.*

---

# ⚠️ THE WARNING — the author, 2026-07-29, verbatim

> This is transitivity of an action groupoid, `\int R_A` **NOT *group theory***. It is at the
> level of the **categorification of orbit-stabilizer theory** and it is about transitivity of the
> **real value transport `\iota_A`**, which is a *transitive action groupoid* whose **fully
> faithful image is `\int R_A`**.

**Read with §0.** The group-level pin (`Action.lean:128`, consuming `MulAction.IsPretransitive`) is
listed in §4 because it is the *other* notion, and naming it is how this document keeps the two
apart. The categorified pin is `stabilizerIsoEnd` (`Action.lean:105`): the stabilizer **is** the
endomorphism monoid and the orbit **is** the connected component — which is why, in this register,
*transitive* and *connected* are one sentence.

---

# 7 — THE STANCE

**The kernel is the check.** The author supplies the argument, the kernel verifies it, the model
types between them. Model-side gap-finding has run ~100% false across five threads; the kernel has
returned zero false verdicts in 3,600+ jobs.

**Doubt = type it and see.**

- Green is the author's argument. Red is the model's doubt.
- Never write a prohibition against the author's route.
- An empty search is a fact about the search. A missing name is a fact about the grep — check
  whether it is `@[reducible]` to something already present before reporting it.
- **Never conflate `ι_A` with `∫𝓡_A`, and never state `ι_A` at the diagram level (§0).** It is a natural transformation OF THE TOTAL — the inverse image of the total `F_A`. A statement about one is not a statement about the
  other, and the identification between them is Declaration 1, not an assumption.
- Cite by file and line, never by name alone.
- On a stall: route the kernel print to the author **verbatim** — not split, not diagnosed, not
  characterized — and stop.
- Never pre-write a commit message for an edit that has not been verified to apply.
