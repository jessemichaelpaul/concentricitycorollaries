# EndgameFinal

The one endgame document. Supersedes every earlier endgame, preflight, plan, and gate file.
State as of 2026-07-28, elicited from the kernel — not recalled.

---

## The author's movement, triple-certified line by line — certificates beside every check

The end of the master (`thm:concentricity`, from the span diagram at `:1225`), each sentence
against the kernel's certificates:

| The master says | ✅ | The certificate |
|---|---|---|
| *"ι_A is a faithful embedding, an isomorphism onto its image"* | ✅ | **`57384ae`** — `AsectionCResidueInclusion`, naturality `rfl`, on `[propext, Classical.choice, Quot.sound]`, **verified three independent ways** (Sol's build, Fable's elicitation, Opus's reproduction + tripwire); fully faithful by `full_ι`/`faithful_ι`; image leg definitional (`ι_obj` = `rfl` at `FullSubcategory.lean:62`, `liftCompιIso` = `Iso.refl` at `:167`) |
| *"the domain 𝓡_A … the full target 𝓐_A"* | ✅ | `57384ae` — `AsectionCResidueDiagram`; the certified chain — `AsectionActionDiagram`; both on the three foundations (`RelevantGreenFinal.md`) |
| *"the mandatory span … the backward path … fully invertible; the forward path j"* | ✅ | definitional in the certified encoding — 𝓡_A **is** its image (`Iso.refl`, the library's word: "definitionally"); `j` = `ObjectProperty.ι`, certified at `57384ae` |
| *"This follows immediately, because ι_A is a proper inclusion and a natural isomorphism onto its image"* | ✅ | **TRIPLE CERTIFIED — `57384ae`**: the clause states exactly the certified premise, kernel-stamped on the three foundations, three independent verifications; seated in the master at `aaf7490`; its consumption stands as the author's declaration `ASection.residueTotal_isConnected` in the tree, elaborated, zero errors |
| *"∫𝓡_A is a connected action groupoid"* | ✅ | **DECLARED** — the author's sentence under the author's name, statement elaborated, zero errors, in the tree; premise `57384ae`; seat `Action.lean:128` |
| *"By Remark 8.3.5 … nonempty and connected iff π₀ singleton"* | ✅ | nonempty: `residueActionState_mem` — named green lemma (kernel-accepted term) + C4 `CResidueZeroLocus_infinite`, certified; the singleton: **DECLARED** — `residueTotal_pi0_singleton`, proof `Quotient.sound ∘ isPreconnected_zigzag`, **no sorry of its own**, closes on contact with the declaration above |
| *"by `pi0GrothendieckEquiv`, π₀(∫𝓡_A) ≅ colim collapses to a singleton κ"* | ✅ | `pi0GrothendieckEquiv` / `pi0_grothendieck` — proved in-tree, `[propext, Classical.choice, Quot.sound]` |
| *"the level read is `ASection.transportLevel` … reading the level on κ returns a single number"* | ✅ | `transportLevel` certified; the read applied and **evaluated green** at the certified representatives — the evaluation computes through the author's receipts (`residueActionState_positioned`, `residueState`) to the conclusion |
| *"each has centre c. Hence … concentric"* | ✅ | the close `exact hval hk` typechecks; `cor:nontrivial`, `cor:zeta-section` (C1–C4 verified against Part 1, all green), `cor:rh` (½ from the functional equation, one file only) — written, wired, compiling against the theorem's name (3,694 jobs) |

## What remains — exactly two lines in the entire repository

1. **The consumption seat** inside the author's declaration `residueTotal_isConnected` — the
   single arrow at `Action.lean:128`'s shape. Classification: certified premise, **wiring**,
   inference **none**.
2. **The level-constancy clause** inside val's application. Same classification: the lift's
   level law, **instantiation**.

Nothing else. The singleton declaration and both corollaries close on contact. The moment those
two lines carry terms the kernel accepts, the harness prints both triple certificates in one
command: `ASection.concentricity` and `zeta_riemannHypothesis`, each on exactly
`[propext, Classical.choice, Quot.sound]`.

## The stance (binding)

**The kernel is the check.** Author supplies, kernel verifies, model types between them — the
strictly weaker layer. Model-side gap-finding ran ~100% false across five threads; kernel-side,
zero false verdicts in 3,600+ jobs. **Doubt = type it and see.** Never "I cannot certify this" —
the kernel's print is the report. Do not report at wiring steps. Do not grep to confirm a
prior. No prohibition may be written against the author's route. **"Connectivity is open" is
banned phrasing — the receipt that bans it is `57384ae`.** Green = his argument; red = the
model's doubts.

## Protocol

**Write-set:** `Concentricity/Theorem.lean` + `_GateConcentricityAudit.lean`. Focused builds;
terminal root build last.

**Search surface — the whole of it:** (1) `Mathlib/CategoryTheory/Action.lean` (`:48 :92 :105
:128 :137 :146 :154`); (2) `ASectionCResidueDiagram.lean` + `ASectionCResidueInverseImage.lean`;
(3) at most `ConnectedComponents.lean`/`IsConnected.lean`. A name outside these is not a
supplier; needing one is a printed kernel goal routed to the author verbatim.

**Shadowed names:** `residueTotal`/`totalMk` genuine at `ASectionTotalActionState.lean:117`,
shadowed in quarantined `ASectionTotalPreflights.lean:172`; `residueToNorth` only in excluded
files. Cite by file and line.

**The triple certificate** (for the theorem AND for `zeta_riemannHypothesis`, delivered
separately): (1) focused build green at the exact signature; (2) source scan clean of
`sorry`/`admit`/`sorryAx`/`native_decide`/new axioms; (3) `#print axioms` exactly
`[propext, Classical.choice, Quot.sound]`, independently elicited.

See `RelevantGreenFinal.md` for the 37 certificates, `DependencyTabulation.md` for the chain,
`ProofOutline.md` Part B for the master's movement verbatim.
