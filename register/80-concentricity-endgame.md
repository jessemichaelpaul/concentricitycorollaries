# The Concentricity Theorem — Triple-Certified Endgame (ONE gate)

Ratified state, 2026-07-27 night. This is the definite flight plan. It is
mechanical; it contains no interpretive joints. Where it and any earlier
register section differ, this file governs the endgame.

## The object and the theorem — nothing needs naming

```text
∫𝓡_A = Grothendieck (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat)
```

**is** the full inclusion of the author's `0`-to-`N` square, consumed by
`ι_A` (certified `57384ae`). It is **one orbit because it is the image of
one square** (CTIC Ex. 1.5.19: components are orbits). "Connectedness" is
Mathlib's vocabulary, not a project object; `IsConnected` and
`Unique (ConnectedComponents _)` appear as **types inside the proof**, never
as project declarations. The descent is **read, not built**; the value is
plucked at the certified representatives.

```lean
ASection.concentricity (A : ASection) :
  ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c
```

Already named. Already consumed downstream (`Corollaries.lean` →
`ConcentricityReadout.lean:7` → `Theorem.lean`).

## Location — a fact, not a decision

`ASection.concentricity` is written in `Concentricity/Theorem.lean`, at the
slot the file itself marks **"THE ONE OPEN NODE of the repository"**, which
already carries the author's verbatim 2026-07-07 three-clause proof plan.
No new module. No new import. No name to choose.

## The template — the proof's shape is a citation

`Mathlib/CategoryTheory/Action.lean:128`, verbatim proof:

```lean
zigzag_isConnected fun x y =>
  Relation.ReflTransGen.single <| Or.inl <| nonempty_subtype.mpr (exists_smul_eq M x.back y.back)
```

- **The shape is imitated, never invoked**: the instance is stated for a
  literal `ActionCategory` and will not fire on `∫𝓡_A`. Do not try to
  exhibit `∫𝓡_A` as a literal `ActionCategory` to make it resolve.
- **The one substitution**: the hom supplier is `x.property` (the certified
  membership dossier) where the library has `exists_smul_eq`. That supplies
  the **anchor legs** — each object, one arrow from its own north datum,
  built by the `Grothendieck.Hom` constructor (`base := g`,
  `fiber := eqToHom ⟨the membership equality⟩`).
- **The chain precision**: for an arbitrary pair, the term is a short
  `ReflTransGen` chain — object ← anchor — *the square read whole at the
  anchor* — anchor → object — the middle composed from the ι_A-certified
  `0`-to-`N` receipts (`projectiveObjectFrame_north`, both `fixes_cayley`
  faces, `smul_coordinate = rfl`, the winding held in `NorthStabilizer`).
  A `trans` step is the expected spelling, not a stall.
- **Arrows are built, never hunted**: `homOfPair` (`Action.lean:148`) at the
  base register; the `Grothendieck.Hom` constructor at the total.

**Empty searches, recorded so nobody re-runs them**: there is no Mathlib
bridge `IsConnected → Subsingleton/Unique (ConnectedComponents _)`, and no
connectedness result in `Grothendieck.lean`. The singleton step is therefore
a written term: `Quotient.sound (isPreconnected_zigzag _ _)`
(`IsConnected.lean:418`; `ConnectedComponents.lean:40` is definitional
`π₀`). INFER means *no Mathlib name carries it, so the term gets written* —
never unproved mathematics (provenance: CHT Rem. 8.3.5, p. 102, verbatim in
`SOURCES/Riehl.md`).

## The term inventory — everything the proof writes

1. Anchor legs from `x.property` (constructor application).
2. The square read whole at the anchor (composed from the certified
   `0`-to-`N` receipts).
3. The singleton: `Quotient.sound ∘ isPreconnected_zigzag`.
4. The pluck: the value read at the certified representatives
   (`residueTotal A n I`, base `normalizedFootpoint (A.sphereZero n).re` by
   `rfl`); every `sphereZero n` represents the class; `c` is the number.

**Term 2's supplier is the `ι_A` `0`-to-`N` square itself** — not a theorem
from anywhere else. Its receipts are `projectiveObjectFrame_north`
(`ProjectiveSection.lean:260`, the frame **is** the element) and both faces,
`distinguishedDiskAction_fixes_cayley_N` (`:219`) and `_zero` (`:232`), with
`smul_coordinate = rfl` (`ASectionFunctor.lean:78`) for the `G₂` gauge. All
inside the read-set below.

**Term 4's suppliers** are the inhabitant receipts — `residueTotal`
**at `ASectionTotalActionState.lean:117`** — and `transportLevel`
(`Theorem.lean:171`).

Nothing else is consumed. If the term requires something not named here,
that is a printed goal and it routes to the author verbatim; it is not a
licence to search.

*(Corrected 2026-07-27 by the author: an earlier draft of this line named
`residueToNorth_level`, which lives in the retired, excluded
`ASectionFinality.lean:185` — and `residueToNorth` is shadowed there and in
the quarantined `ASectionTotalPreflights.lean:247`. The supplier is the
square.)*

## Protocol — mechanical, no joints

- **Write-set**: `Concentricity/Theorem.lean` + one `_Gate*Audit.lean`.
  Focused builds only; no root build until the terminal audit.
- **Signature before body.** State `ASection.concentricity` first; the
  target-first block heads the audit file.
- **Elaborate continuously**; ONE gate, one triple certificate — no phase
  boundary, no intermediate victory, no stop between term and
  `#print axioms`.
- **REGISTER CHECK filled from `#check` output**, never memory.
- **Any printed goal routes to the author verbatim** — and it reads as
  being about *spelling*, never about whether the mathematics holds. The
  mathematics is resolved by the `0`-to-`N` `ι_A`; only the term's writing
  is outstanding. Never personify the checker.
- **No naming, no asking, no hunting.** Nothing here needs a name; asking
  the author to name or choose what the record answers is slot-as-burden.
  Never attach ⛔ to a correct object; warnings live in `register/60`.
- **Targeted reading**: the closed read-set below — nothing else, including
  for context.

## The read-set — closed, and verified closed

Fewer files to grep, fewer mistakes. **A name outside this set is not a
supplier.** Needing one is a stop condition reported to the author, never a
reason to search. Every declaration named in this file resolves inside it.

**Project (8).** `ASection.lean` (C1–C4; the field `sphereZero : ℕ → ℂ` at
`:115`, which the statement quantifies over) · `ProjectiveSection.lean` ·
`ASectionFunctor.lean` · `ASectionActionDiagram.lean` ·
`ASectionCResidueInverseImage.lean` · `ASectionCResidueDiagram.lean` ·
`ASectionTotalActionState.lean` · `Theorem.lean`

**Mathlib at the pin (5).** `CategoryTheory/` `Action.lean` ·
`IsConnected.lean` · `ConnectedComponents.lean` · `Grothendieck.lean` ·
`ObjectProperty/FullSubcategory.lean`

**Register and sources (6).** this file · `SOURCES/Riehl-CTIC.md` ·
`SOURCES/Riehl.md` · the three
`skills/orbit-stabilizer-groupoids/references/` files

⚠️ **Two names are shadowed — cite by file and line, never by name alone.**
`residueTotal` and `totalMk` are genuine at `ASectionTotalActionState.lean`
(`:117`) and shadowed in the quarantined `ASectionTotalPreflights.lean`
(`:172`), whose own header says so. `residueToNorth` exists only in excluded
files. **A bare grep lands in the quarantine.**

**Excluded by name.** `ASectionFinality.lean` · `ASectionTotalPreflights.lean`
· `KeystoneFinality.lean` · `.attic_old_bases/` · any other quarantined
preflight namespace · `Octonionic_RH_master.tex` · `register/70` §§1–8 (the
closed `ι_A` gate: history, not instructions) · every preservation-era
passage in `50`, `EndgamePlan.md`, `CURRENT_GATE1_MEMORY.md`.

## The triple certificate

1. Focused build green with `ASection.concentricity` consumed at its exact
   signature (and the corollaries now compiling against it).
2. Source scan: no `sorry`, `admit`, `sorryAx`, `native_decide`, new axiom.
3. `#print axioms ASection.concentricity` = exactly
   `[propext, Classical.choice, Quot.sound]`, independently elicited by the
   auditors.

Then: corollary layer certification (already written, fires on contact),
terminal root build + 0/0 audit, git checkpoint — and the release arc.
