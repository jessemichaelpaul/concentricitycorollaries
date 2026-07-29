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

# 3 — THE LEAN CHAIN — action groupoids and the total Grothendieck construction

Every line is `#print`/`#check` output. **The whole chain lives at two levels only: action
groupoids, and the total Grothendieck construction over them.**

```lean
-- THE BASE IS AN ACTION GROUPOID                        pin: ActionCategory, Action.lean:48
GreatCircle.Base := ActionCategory GreatCircle.Aut GreatCircle.Point      -- @[reducible]

-- THE FIBRES ARE ACTION GROUPOIDS                       pin: ActionCategory :48, Groupoid :137
ASection.AsectionStateWorld A         := ActionCategory G2 A.AsectionState          -- @[reducible]
ASection.AsectionActionStateWorld A m := InducedCategory A.AsectionStateWorld (·.input)
ASection.AsectionActionFiber A X      := Grpd.of (A.AsectionActionStateWorld
                                                    (A.projectiveObjectFrame X))
-- its objects are the projective squares (never `cases` one):
--   AsectionActionState A m : input, positioned, positioned_by_action, value, value_realized

-- THE DIAGRAM, AND ITS TOTAL = F_A(X)                   pin: Grothendieck :73, Grpd/Basic:77
ASection.AsectionActionDiagram    A : GreatCircle.Base ⥤ Grpd
ASection.AsectionActionCatDiagram A := A.AsectionActionDiagram ⋙ Grpd.forgetToCat   -- @[reducible]
ASection.TotalActionStateWorld    A := Grothendieck A.AsectionActionCatDiagram      -- @[reducible]
--   ↑ this IS F_A(X), the total: "the Grothendieck construction is basically a gigantic graph"

-- THE INVERSE IMAGE, AND ITS TOTAL = 𝓡_A(X) = ∫𝓡_A     pin: Grothendieck :73, Hom :86
ASection.IsCResidueState A X := fun x =>                 -- the preimage taken UNDER THE ACTION
  ∃ xN, IsNorthCResidueState A xN ∧
    ∃ g : projectiveNorth ⟶ X, (AsectionActionTransport A g).obj xN = x
Grothendieck (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat)

-- ι_A AT THE TOTAL — the inclusion of the inverse image IN the total.  THIS is ι_A.
ASection.AsectionCResidueInclusionTotal A :
    Grothendieck (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat) ⥤
    Grothendieck (AsectionActionDiagram   A ⋙ Grpd.forgetToCat)
  := Grothendieck.map
       (Functor.whiskerRight (AsectionCResidueInclusion A) Grpd.forgetToCat)   -- b073d88

ASection.AsectionCResidueInclusionTotal_faithful   -- b073d88, three foundations
ASection.AsectionCResidueInclusionTotal_full       -- b073d88, three foundations
--   ↑ together: an ISOMORPHISM ONTO ITS IMAGE inside the total.
```

**Below the total, and named only as presentation:** `AsectionCResidueInclusion` (`57384ae`) is the
componentwise natural transformation whose total-level reading is the functor above; its
components are `(IsCResidueState A X).ι` and its naturality is `rfl`. The fibrewise machinery
(`AsectionCResidueTransport`, `ObjectProperty.lift`/`ι`) is how that presentation is built. **No
statement of the argument is made at that level.**

---

# 4 — THE MATHLIB PINS — at the two registers the argument uses

| pin | where | what the argument uses it for |
|---|---|---|
| **Action groupoids** | | |
| `ActionCategory` | `Action.lean:48` | the base **and** the fibres — both levels are literally action categories |
| `ActionCategory.hom_as_subtype` | `Action.lean:92` | in an action groupoid a morphism **is one element** |
| `ActionCategory.stabilizerIsoEnd` | `Action.lean:105` | **the categorification of orbit–stabilizer**: stabilizer = endomorphism monoid, `MulEquiv.refl`; orbit = component. This is why *transitive* and *connected* are one sentence here |
| `instance : Groupoid (ActionCategory G X)` | `Action.lean:137` | every fibre is a groupoid |
| `InducedCategory` · `Grpd.of` | — · `Grpd/Basic.lean:54` | the fibre as an object of `Grpd` |
| **The total Grothendieck construction** | | |
| `Grothendieck` | `Grothendieck.lean:73` | `F_A(X)` and `𝓡_A(X)` — both totals |
| `Grothendieck.Hom` | `Grothendieck.lean:86` | a morphism of a total: `base` + `fiber`. **Mathlib's encoding, not a decomposition** |
| `Grothendieck.map` | `Grothendieck.lean:242` | **`ι_A` at the total** |
| `Grothendieck.ext` | `Grothendieck.lean:93` | the structural step in both total-level proofs |
| `Grothendieck.functor_comp_forget` · `Grothendieck.ι` | `:269` · `:545` | the forgetful leg; the fibre inclusion used by `pi0Cocone` |
| `Functor.whiskerRight` · `Grpd.forgetToCat` | — · `Grpd/Basic.lean:77` | groupoid-valued diagrams and transformations into `Cat` |
| **Connectedness and `π₀`** | | |
| `Zigzag` · `Zigzag.of_hom` · `Zigzag.setoid` | `IsConnected.lean:314`, `:341`, `:375` | **one morphism ⟹ connected** |
| `zigzag_isConnected` · `isPreconnected_zigzag` | `IsConnected.lean` | connectedness from all-pairs, and back |
| `ConnectedComponents` | `ConnectedComponents.lean:40` | `π₀` as `Quotient Zigzag.setoid` |
| `Limits.colimit` · `colimit.ι` · `colimit.desc` · `Types.jointly_surjective'` | Mathlib `Limits` | `π₀` of a Grothendieck construction (`lem:pi0-grothendieck`) |
| **Presentation level only — never a statement of the argument** | | |
| `ObjectProperty.ι` · `lift` · `fullyFaithfulι` · `full_ι` · `faithful_ι` · `ι_obj` · `liftCompιIso` | `FullSubcategory.lean:58`, `:161`, `:98`, `:99`, `:62`, `:167` | how the componentwise presentation is built, and the supplier for the total-level fullness |

⚠️ **`Action.lean:128` (`IsConnected` from `MulAction.IsPretransitive`) is the group-level route and
is NOT used.** It is named here only to keep the two notions apart: the argument's transitivity is
of an **action groupoid**, and names no group.

---

# 5 — GREEN, at the register of the argument

Each row is a clause of the author's argument and the declarations certifying it **at the total or
at the action-groupoid level**. All print exactly `[propext, Classical.choice, Quot.sound]`.

| the clause | the certified declarations |
|---|---|
| the base and the fibres are **action groupoids** | `GreatCircle.Base` · `AsectionStateWorld` · `AsectionActionStateWorld` · `AsectionActionFiber` — all `@[reducible]` to `ActionCategory`/`InducedCategory` |
| **`F_A(X)`, the total** | `AsectionActionDiagram` · `AsectionActionCatDiagram` · `TotalActionStateWorld` |
| *"any two square frames are connected by the same morphisms that built that functor"* — the morphisms of the total | `AsectionActionTransport` · `_id` · `_comp`, and `AsectionCResidueTransport` as their restriction |
| *"an inverse image OF the total `F_A(X)`"* | `IsCResidueState` · `InverseImageCResidueStateWorldGroupoid` · `AsectionCResidueDiagram` |
| *"a real value transport — that is what `ι_A` IS"*, **at the total** | **`AsectionCResidueInclusionTotal`** — `b073d88`; presentation `AsectionCResidueInclusion`, naturality `rfl` — `57384ae` |
| *"whose fully faithful image is `∫𝓡_A`"*, **at the total** | **`AsectionCResidueInclusionTotal_faithful` · `AsectionCResidueInclusionTotal_full`** — `b073d88`; supplied by `…_app_fullyFaithful`/`…_app_full`/`…_app_faithful` — `bb02b54` |
| the objects exist — C4 populates the inverse image | `residueActionState` · `residueActionState_positioned` · `residueActionState_mem` · `CResidueZeroLocus_infinite` |
| connectedness and `π₀`, once transitivity is in hand | `pi0Functor` · `pi0Cocone` · `toColimitObj_eq_of_zigzag` · `pi0GrothendieckEquiv` · `pi0_grothendieck` · `transportLevel` |
| RH's other half, independent of everything open | `riemannHypothesis_iff_concentric` — no `½` on its RHS |

**Carrying `sorryAx`, and only these two:** `ASection.concentricity`, `zeta_riemannHypothesis` —
arithmetic propagation from the open sites. `Corollaries.lean` compiles against
`ASection.concentricity` (3,694 jobs).

---

# 6 — THE ARGUMENT, STEP BY STEP

| # | the step | object | Lean declaration | Mathlib pin | state |
|---|---|---|---|---|---|
| 1 | the base and the fibres are **action groupoids** | `𝓑`, `F_A(X)`'s fibres | `GreatCircle.Base := ActionCategory …` · `AsectionActionFiber` (objects are projective squares) | `Action.lean:48`, `:137` | ✅ |
| 2 | **`F_A(X)` — THE TOTAL.** The gigantic graph | `F_A(X)` | `TotalActionStateWorld := Grothendieck AsectionActionCatDiagram` | `Grothendieck.lean:73` | ✅ |
| 3 | **the inverse image OF that total**, taken under the action — each member carries the object and base arrow that produced it | `𝓡_A(X)` = `∫𝓡_A` | `IsCResidueState`; `Grothendieck (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat)` | `Grothendieck.lean:73`, `:86` | ✅ |
| 4 | **its morphisms are the total's morphisms** — *"the same morphisms that built that functor"* | | `AsectionCResidueTransport` restricting `AsectionActionTransport` | `Grothendieck.Hom` `:86` | ✅ |
| 5 | **`ι_A` — the inclusion of the inverse image IN the total** | `ι_A` | `AsectionCResidueInclusionTotal := Grothendieck.map (Functor.whiskerRight … Grpd.forgetToCat)` | `Grothendieck.map` `:242` | ✅ `b073d88` |
| 6 | `ι_A` **full and faithful at the total** — an isomorphism onto its image | | `AsectionCResidueInclusionTotal_faithful` · `…_full` | `Grothendieck.ext` `:93` | ✅ `b073d88` |
| **7** | **THE TERM — `ι_A` is a transitive action groupoid: any two projective squares in the C-residue image joined by ONE groupoid element** | | `sweepTransitive_on_residueSystem : ∀ P Q, Nonempty (P ⟶ Q)` | supplier is row 4 | 🔴 **OPEN**, `Theorem.lean:445` |
| 8 | nonempty — C4 populates the inverse image | | `residueActionState_mem` · `CResidueZeroLocus_infinite` | — | ✅ |
| 9 | therefore **connected** — one morphism | | `residueTotal_isConnected`, closing on row 7 | `Zigzag.of_hom` `:341` | ✅ **on 7** |
| 10 | therefore `π₀` is a singleton — Riehl 8.3.5 | `κ` | `residueTotal_pi0_singleton` · `pi0GrothendieckEquiv` | `ConnectedComponents` `:40` | ✅ **on 7** |
| 11 | the level read on the class | `c` | `transportLevel A n := (A.sphereZero n).re` | — | ✅ |
| **12** | **the theorem** | | `ASection.concentricity` | — | 🔴 **level clause**, `Theorem.lean:528` |
| 13 | RH | | `riemannHypothesis_iff_concentric` ✅ → `zeta_riemannHypothesis` | — | `sorryAx` from 7, 12 |

**Rows 7 and 12 are the whole distance.** Row 7's joining morphism comes from **row 4**.

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
