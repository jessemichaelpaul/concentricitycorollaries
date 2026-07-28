# The endgame

One square, included, is one orbit. Its `π₀` is one class. That class's real level is `c`.

This file is the execution surface and nothing else. Architecture is `00`/`50`; the closed `ι_A`
gate is `70`; failures are `60`. Every line below links theory → skill → live Lean.

## The statement

```lean
ASection.concentricity (A : ASection) : ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c
```

Goes at `Concentricity/Theorem.lean`, the slot marked **"THE ONE OPEN NODE of the repository"**
(`:224`), which already carries the author's *Proof plan of record, 2026-07-07, verbatim*. Import
chain is wired: `Corollaries.lean → ConcentricityReadout.lean:7 → Theorem.lean`. No new module.

**One gate, not several.** State the signature before the body; elaborate continuously; one triple
certificate. Intermediates are terms inside the proof and are not separate declarations.

## The object

```lean
∫𝓡_A  =  Grothendieck (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat)
```

The author, 2026-07-27: *"the full inclusion of that square which is `∫R_A`, and it is that which is
connected."* It is **one orbit** because it is the image of **one square** — not a fibre at `N` with
a total built over it. `IsConnected` and `Unique (ConnectedComponents _)` are Mathlib's vocabulary
for stating and reading that; they are types inside the proof, never project objects.

## The chain

| # | step | theory | live Lean | status |
|---|---|---|---|---|
| 0 | the square, positioned at the frame that **is** the element, both faces held | — (authored) | `projectiveObjectFrame_north` `ProjectiveSection.lean:260`; `distinguishedDiskAction_fixes_cayley_N` `:219`, `_zero` `:232` | ✅ |
| 1 | the diagram and its natural inclusion | CTIC Prop. 2.4.14, p. 77 | `AsectionCResidueDiagram` `ASectionCResidueDiagram.lean:154`; `AsectionCResidueInclusion` `:163`; naturality `rfl` | ✅ `57384ae` |
| 2 | totalize over the same base | Mathlib | `Grothendieck.map` `:242`, `Grothendieck.functor_comp_forget` `:269` | term to write |
| 3 | one orbit | CTIC Ex. 1.5.19, p. 37 — hom-sets are a disjoint union over `O_x`, each `≅ G_x`: inhabited **iff** same orbit, and the stabilizer is retained | template = the proof at `Action.lean:128`; arrow constructor `homOfPair` `:148`; `zigzag_isConnected` `IsConnected.lean:436` | term to write |
| 4 | `π₀` is one class | CHT Rem. 8.3.5, p. 102 — nonempty + connected ⟺ singleton | `ConnectedComponents J := Quotient (Zigzag.setoid J)` `ConnectedComponents.lean:40`; `Quotient.sound` on `isPreconnected_zigzag` `:418` | term to write |
| 5 | the components comparison | CHT p. 102, the el-identity | `pi0GrothendieckEquiv` `Theorem.lean:108` — takes `B ⥤ Grpd`, instantiates at `𝓡_A` with zero adaptation | ✅ |
| 6 | read the level at the class | — (authored) | `transportLevel A n = (A.sphereZero n).re` `Theorem.lean:171`; representatives `residueTotal A n I` `ASectionTotalActionState.lean:117`, over `normalizedFootpoint (A.sphereZero n).re` | ✅ |
| 7 | `c`, then the corollaries fire | CHT/CTIC as above | `ASection.concentricity`; `riemannHypothesis_iff_concentric` `RhEquiv.lean:135` | ✅ downstream |

**Order is forced at rows 4–5.** Rem. 8.3.5 speaks about a *category*, so it applies to `∫𝓡_A`,
which has zigzags. `colim (π₀ ∘ 𝓡_A)` is a *set*. The comparison then transports an
already-established singleton; the colimit's universal property is what yields the reader.

## The read-set — closed, and verified closed

Everything the endgame needs is listed below and is already in the right register. **A name outside
this set is not a supplier.** Needing one is a stop condition, reported to the author — not a reason
to search. This is the protection the write-set alone never gave: every drift on record came from
reading the wrong folder, not from writing one.

**Project (8 files).** `ASection.lean` (the structure — C1–C4 and the field `sphereZero : ℕ → ℂ`
at `:115`, which the statement quantifies over) · `Theorem.lean` · `ASectionCResidueDiagram.lean` ·
`ASectionCResidueInverseImage.lean` · `ASectionActionDiagram.lean` · `ASectionTotalActionState.lean`
· `ProjectiveSection.lean` · `RhEquiv.lean`

⚠️ **One name is shadowed.** `residueTotal` (and `totalMk`) are defined **twice**: the genuine one
at `ASectionTotalActionState.lean:117`, and a quarantined copy at `ASectionTotalPreflights.lean:172`
— that file's own header says so (`:11`, `:27`). A bare grep lands in the quarantine. Cite the
genuine one by file and line; never by name alone.

**Mathlib at the pin (5 files).** `CategoryTheory/Action.lean` · `CategoryTheory/IsConnected.lean` ·
`CategoryTheory/ConnectedComponents.lean` · `CategoryTheory/Grothendieck.lean` ·
`CategoryTheory/ObjectProperty/FullSubcategory.lean`

**Register and sources (6 files).** this file · `SOURCES/Riehl-CTIC.md` · `SOURCES/Riehl.md` ·
the three `skills/orbit-stabilizer-groupoids/references/` files

**Closed:** every declaration named in the chain table above resolves inside those twelve code
files. Nothing else is consulted, including for context.

**Excluded, by name.** `ASectionTotalPreflights.lean` (quarantined, and it **shadows** two names in
the read-set) · `ASectionFinality.lean` · `KeystoneFinality.lean` · `.attic_old_bases/` ·
any other quarantined preflight namespace · `Octonionic_RH_master.tex` · `register/70` §§1–8 (the closed
`ι_A` gate — history, not instructions) · every preservation-era passage in `50`, `EndgamePlan.md`,
and `CURRENT_GATE1_MEMORY.md`.

## Skill routing

| need | read |
|---|---|
| the citations, verbatim and render-verified | `SOURCES/Riehl-CTIC.md`, `SOURCES/Riehl.md` |
| the applied chain, the collapse ladder, the contractibility guard | `skills/orbit-stabilizer-groupoids/references/theory-and-citations.md` |
| Lean names, the supplier map, the obligation ledger | `.../references/concentricity-instantiation.md`, `.../references/lean-dictionary.md` |

**Contractibility is never asserted.** CTIC Prop. 2.4.9 with Lem. 1.6.16 requires a *unique* arrow
per hom-set — free *and* transitive. This action is transitive and not free; the stabilizers
(`NorthStabilizer` horizontally, the sphere-direction stabilizer vertically) are retained. Connected
with stabilizers is exactly and only what 8.3.5 consumes.

## Two searches already run — do not re-run

Over `Mathlib/CategoryTheory/` at the pin: there is **no** bridge
`IsConnected → Subsingleton/Unique (ConnectedComponents _)`, and **no** connectedness result in
`Grothendieck.lean`. Consequences: row 4 is a term to write, and the `Action.lean:128` instance will
**not** fire on `∫𝓡_A` — do not try to exhibit it as a literal `ActionCategory` to make it resolve.

A step marked *term to write* means no Mathlib name carries it. It never means unproved mathematics.

## Triple certification, here

1. focused build of `Theorem.lean` and one `_Gate*Audit.lean`; no root build until the terminal audit;
2. exact-object consumers at free `A` and `n` — the statement instantiated, not a generic example;
3. axiom surface exactly `[propext, Classical.choice, Quot.sound]`; no `sorry`, `admit`, `sorryAx`.

Then the coverage debt: wire the residue chain and the ten `_Gate*Audit` modules into
`Concentricity.lean`, so the terminal root build exercises the receipts.

## Standing rules

- The mathematics is resolved by the `0`-to-`N` `ι_A`. A goal the kernel prints concerns the
  spelling of a term, never whether the mathematics holds — it routes to the author verbatim, as an
  event, never as a plan.
- Nothing here needs a name. Both objects are named; the rest are terms.
- No arrow hunting: row 3's arrows come from `x.property` and `homOfPair`, row 0's object is the
  square.
- Never personify the checker; never attach a prohibition to a correct object.
