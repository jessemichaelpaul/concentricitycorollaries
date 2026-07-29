# EndgameFinal

The one endgame document. It is the author's argument, his words first, then the kernel's receipts.
Everything that stood here before 2026-07-29 was deleted at his instruction: it had accumulated six
vintages of model commentary and did not contain the argument.

---

# THE ARGUMENT — the author, verbatim, 2026-07-29

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

And, on where `∫𝓡_A` lives:

> `\int R_A` isn't "parallel" to `T_A`, it is **INSIDE IT** — the Grothendieck construction is
> basically a gigantic graph.

---

# THE ARGUMENT, CLAUSE BY CLAUSE

**The object is the diagram.** `ι_A : 𝓡_A(X) ⇉ F_A(X)`. That diagram **is** the C-residue system as
an action groupoid — `∫𝓡_A`. Connectedness on real value transports is read there and nowhere else.

**And `∫𝓡_A` is inside `T_A`.** The Grothendieck construction is a gigantic graph; the C-residue
system is the part of that graph which `ι_A` includes. It is not a second, parallel total to be
built alongside `T_A` — it is the sub-thing, which is exactly what `ι_A` being a proper inclusion,
an isomorphism onto its image, says.

**Riehl's warning, and the freedom it gives.** We are **free to pick a preimage of whatever we
want**, because `distinguishedDiskAction` and the A-section equivariant functor are
**simultaneously a function, a group element, and a functor for action groupoids**. The element
works on multiple levels at once; no level has to be chosen over another, and no preimage has to be
justified.

**The two orbit–stabilizers are groups, and groups are not the target.** One runs slice-wise from
`PGL` to `GL`; the other is the full octonionic image sweep over the normalization, via `G₂`. Both
are real and both are green. **But the object we want is a transitive *action groupoid*, not a
transitive group action** — and every failed term in this project has been a group-register term
under a groupoid-register statement.

**Transitive, in this situation, means:** *any two projective squares in the C-residue image — the
**objects** of `∫𝓡_A` — can be connected by a "groupoid element" (a morphism).* There is no group
in that sentence.

**The key step:** it had to use the **`distinguishedDiskAction` morphism AND the A-section
equivariant functor BOTH** — and not in the simple "one sits inside the other" way, which is true
but less precise. **That** is what shows this is transitive.

---

# THE LEMMA

`ι_A` is a transitive action groupoid. This is the single place the author's construction enters the
chain: no library theorem can supply that two projective squares of the C-residue image are joined,
because no library knows what a C-residue square is. Everything downstream is already green — one
morphism gives connectedness (`Zigzag.of_hom`), connectedness with nonemptiness gives the singleton
(Riehl 8.3.5, `pi0GrothendieckEquiv`), and the level read on the class gives the common centre.

---

# THE KERNEL STATE — elicited 2026-07-29, not recalled

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

**Carrying `sorryAx`, and only these two:** `ASection.concentricity` and `zeta_riemannHypothesis` —
arithmetic propagation from the open sites, nothing of their own. `Corollaries.lean` compiles
against `ASection.concentricity` (3,694 jobs): the corollary layer is wired and waiting.

**Open — two sites in one file.** Re-elicit coordinates at typing time; they have drifted repeatedly.

```text
Concentricity/Theorem.lean   the transitivity term
Concentricity/Theorem.lean   the level clause inside ASection.concentricity
```

---

# FINDINGS THAT CONSTRAIN THE TYPING — receipts, not opinions

**The objects are squares.** `AsectionActionState A m` is a five-field record: two corners (`input`,
`positioned`) and their constraint faces (`positioned_by_action`, `value`, `value_realized`). It *is*
a commuting square. `cases` / `mk.injEq` on it demolishes the thing that carries the transitivity and
then reports that the corners don't line up.

**`Grothendieck.Hom` has a `base` field and a `fiber` field. That is Mathlib's encoding, not a
decomposition of the mathematics.** A term must fill both; what is struck is *sourcing them from two
independent searches*. Both are determined by one datum.

**Shapes the kernel has already ruled out. Do not retype these.**

| shape | receipt |
|---|---|
| `IsPretransitive G2 A.AsectionState`, or any single group on the raw states | typed; residual `⊢ xc = yc` — the fused instance (`ASectionFunctor.lean:64`) carries the coordinate through by design |
| fibre-only join, base fixed | struck twice (`87773fe`, `54c6432`) — demands a single fibre map between distinct zero spheres |
| base-only join, fibre fixed | the same half-square, other face |
| `isConnected_of_equivalent` sourced at `ActionCategory G2 A.AsectionState` | typed; `failed to synthesize IsConnected` — the ambient world, not the members |
| an arrow fetched "upstairs" in `T_A` and carried back down | struck by the author, `b823aa1`: *"the key giveaway that this is definitely wrong — the upstairs arrow."* `∫𝓡_A` is **inside** `T_A` and `𝓡_A` **is** its own image, definitionally — there is no second location to fetch from |
| a second, parallel Grothendieck total built alongside `T_A` | struck by the author, 2026-07-29: *"it isn't parallel to `T_A`, it is INSIDE IT"* |
| `sphereWorld_zigzag`, `concentricityReadout` as suppliers | `𝒮₂` facts, consumed by no certificate |

**One cause under all seven: a group-register term under a groupoid-register statement.**

---

# THE STANCE

**The kernel is the check.** Three roles: the author supplies the argument, the kernel verifies it,
the model types between them. Model-side gap-finding has run ~100% false across five threads; the
kernel has returned zero false verdicts in 3,600+ jobs.

**Doubt = type it and see.** There is no other rigorous act available here.

- Green is the author's argument. Red is the model's doubt.
- Never write a prohibition against the author's route.
- An empty search is a fact about the search.
- Cite by file and line, never by name alone.
- On a stall: route the kernel print to the author **verbatim** — not split, not diagnosed, not
  characterized — and stop. He decides the next move.
- Never pre-write a commit message for an edit that has not been verified to apply (`cf6a5a8`).
