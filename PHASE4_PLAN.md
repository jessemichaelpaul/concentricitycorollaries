# PHASE 4 PLAN — burn-down of the 13 statement-layer sorries (plan only; no proofs)

Per the burn-down ruling (2026-07-03): itemization first; **no lane-1 lemma lands until the
author approves this plan.** R2/R8 throughout: the proof of `thm:concentricity` is a
transcription of the master's cocartesian proof, never invented mathematics; the finality
remark stays expository (not formalized); any step that won't close is an R6 stop with the
exact failing goal.

Legend — **TRANSLATE**: transcription + goal-closing against pin-present ingredients.
**LITERATURE INPUT**: a cited theorem with no Mathlib counterpart — per R9 priced, then
proved in-repo (never an axiom). Pin = Mathlib v4.31.0 (= fabf563a) in `.lake`.

## The 13 sorries

| # | sorry | master node | SOURCES | class | est. lines |
|---|---|---|---|---|---|
| 1 | `StemRing.eq_zero_or_eq_zero_of_mul_eq_zero` | `prop:R-domain` ("If f, g ∈ 𝓡 and f∗g = 0, then f = 0 or g = 0"; proof: slicewise pointwise product + identity principle) | — (derived) | TRANSLATE — `eq_zero_or_eq_zero_of_mul_eq_zero` for analytic functions (Analysis/Analytic/IsolatedZeros.lean:300; smul form :276); `Differentiable.analyticOnNhd` (VERIFY-AT-BUILD exact name); `isPreconnected_univ` | 20–50 |
| 2 | `G2.exists_smul_eq_of_mem_unitImaginarySphere` | `thm:G2-S6` transitivity clause ("G₂ acts transitively on S⁶") | SOURCES/Baez02.md (substance at printed p. 185; stabilizer clause is a GAP and is **not** consumed) | **LITERATURE INPUT** — no Mathlib G₂. In-repo route: (i) the conjugation family (a,b) ↦ (q a q\*, q b q\*), unit q ∈ ℍ, closed under the CD twist by direct computation; (ii) a second family moving ℍ-directions into the doubled ones; assemble transitivity on S⁶ via the basic-triple argument (Baez §4 substance). Priciest lane-1 leaf; consumed by `lem:residue-spheres` (in the theorem's cone). Author may re-scope its schedule; it blocks only the sphere-orbit reading, not the level machinery | 500–1000 |
| 3 | `Base.totalObject_components_eq_levels` | π₀ readout ("π₀(𝒯_A) ≅ colim(π₀∘F) ≅ π₀(𝓑) = the levels") | — (derived) | TRANSLATE — the band fibre `SingleObj Circle` has one object, so objects of 𝒯 ≅ ℝ × pt; cross-level zigzags die on the `Discrete ℝ` factor; within-level connectivity is trivial. ConnectedComponents.lean:40; Grothendieck.lean | 60–120 |
| 4 | `Octonion.sliceEmbed_mul` | `def:slices` ("φ_v : ℂ → ℂ_v, i ↦ v" is an ℝ-algebra isomorphism) | — (derived) | TRANSLATE — new Octonion helpers `(r•x)*y = r•(x*y)`, `x*(r•y) = r•(x*y)` (componentwise from `mul_def` + Quaternion smul simp lemmas, cf. Quaternion.lean:1092); then distribute with the proved `sq_eq_neg_one_of_mem_unitImaginarySphere` | 60–120 |
| 5 | `Octonion.dir_mem_unitImaginarySphere` | unit-direction fact behind `def:slices`/`def:section-map` | — (derived) | TRANSLATE — `re (im x) = 0` by construction; `Quaternion.normSq_smul` (Quaternion.lean:1091); `Real.sq_sqrt`/`Real.sqrt_pos` | 60–120 |
| 6 | `ASection.realize_mem_sliceSphere` | `def:section-map`(i) ("A(ℂ_I*) ⊆ ℂ_I*") | Wang Rem 2.11 rides on the stem definition (SOURCES/Wang.md), faithfulness never load | TRANSLATE — `x = φ_v ζ ⇒ im x = ζ.im • v ⇒ dir x ∈ {v, −v}` (+ real junk case); `φ_{−v} w = φ_v (conj w)`; intrinsicality of the stem symmetrizes | 120–220 |
| 7 | `ASection.realize_equivariant` | `def:section-map`(ii) (equivariance display) | SOURCES/Wang.md | TRANSLATE with real content — key new sub-lemma: the **quadratic identity** `x² = 2(re x)·x − normSq x` in 𝕆 (componentwise, CD); it forces every G₂ element to preserve `re` and `normSq` of non-real elements (minimal-polynomial uniqueness), whence `dir (g•x) = g • dir x` and `g (φ_v w) = φ_{g v} w` (linearity + `smul_ofReal`, proved) | 200–350 |
| 8 | `ASection.sliceCoord_smul_invariant` | `def:section-map`(iii) (stem constancy on orbits) | — (derived) | TRANSLATE — corollary of #7's isometry block | 20–40 |
| 9 | `sectionFunctor` | `thm:section-functor` (proof: "the standard fact that an equivariant map of G-sets induces a functor of the associated translation groupoids, applied to A") | — (derived) | TRANSLATE — needs #7; ActionCategory hom API (CategoryTheory/Action.lean:48–100, VERIFY-AT-BUILD the hom constructor), `Quotient.functor` (CategoryTheory/Quotient.lean), `eqToHom` composition lemmas against `SliceWorld.Rel` | 120–220 |
| 10 | `sectionFunctor_obj` | object pin of `thm:section-functor` | — | TRANSLATE — `rfl` (or one `simp`) once #9 is constructed | 5–10 |
| 11 | `pi0_grothendieck` | `lem:pi0-grothendieck` (proof "direct at the level of categories": zigzags project to the base and join fibrewise) | Thomason reading stays expository (SOURCES/Thomason79.md); Quillen π₀(BC) ↔ components recorded (SOURCES/Quillen73.md), not load-bearing | TRANSLATE — Type-valued colimit machinery (Limits/Types/Colimits.lean:102/150); Grothendieck base/fibre projections; ConnectedComponents quotient API | 200–350 |
| 12 | `assemblyComponent` | the assembly paragraphs of `thm:concentricity`'s proof (transcribed, never paraphrased — the "precedes" discipline) | SOURCES/VS.md (Rem 5.2), SOURCES/GPVwind.md (Cor 5.13, Cor 5.21, Def 4.7/5.11) | TRANSLATE over the **cone completion** below — decomposition: (a) degenerate fibre (`lem:exp-degenerate`, stem level); (b) C2/C3 agreement by the identity theorem (Analytic/Uniqueness cluster); (c) tame lift exists and is a loop (winding nodes); (d) level read-off into 𝓑 | 400–800 |
| 13 | `concentricity` | the readout paragraph ("π₀ reads off their component") | — | TRANSLATE — #12 + #11 + #3: all spheres share the level, levels are the components | 80–160 |

## Cone completion — new statements Phase 4 must ADD first

The assembly (#12) consumes master nodes not yet stated in Lean. Stating them balloons
the ledger before it drops (HANDOFF failure-mode note anticipates exactly this):

- **`lem:exp-degenerate`** (DERIVED in the master from the slice form) — stem level:
  `exp⁻¹(−r) = {log r + (2k+1)πi}`. Pin: `Complex.exp_eq_one_iff` / `Complex.log`
  cluster. State ~10, prove 60–150.
- **`thm:slice-exp`** (VS Prop 5.1; AdF Rem 2.23) — mostly definitional in the stem
  encoding (the slice exponential IS `Complex.exp` through φ_v). State ~10, prove 30–80.
- **`thm:identity`** (slice identity theorem, CSS12) — stem level: uniqueness of analytic
  continuation (Analysis/Analytic/Uniqueness.lean). State ~10, prove 20–60.
- **`thm:winding-lift`** (GPVwind Def 5.11/Prop 4.2) — **LITERATURE INPUT** with a
  near-free floor: `Complex.isCoveringMap_exp` (Analysis/Complex/CoveringMap.lean:40) +
  the path/homotopy lifting and `monodromyFunctor` API (Topology/Homotopy/Lifting.lean:394,
  per the recon gate). State ~30, prove 200–400.
- **`prop:winding-signature`** (GPVwind Cor 5.13 + Cor 5.21) — **LITERATURE INPUT**.
  R2 note: SOURCES/GPVwind.md records a GAP — the definitions of the signature σ and
  circular signature σᶜ (Def 5.7 and neighbours) were outside the pinned excerpt targets;
  a SOURCES top-up is required **before** these can be stated verbatim. Cor 5.21 carries
  the printed hypothesis "σᶜ(γ) even" (FLAGS). State ~20 (after top-up), prove 150–300.

## Totals and order of attack

Lane-1 base burn ≈ 1,400–2,600 lines; cone completion ≈ 500–1,000; the G2-S6 literature
input 500–1,000 on top. Phase 4 grand total ≈ **2,400–4,600 lines**.

Order (author's ruling, 2026-07-03, superseding the cheap-first proposal): **#2 (G2-S6)
FIRST** — cleared up front, not saved for last; the visible ledger drop starts once it
lands. Then cheap-first: 1 → 3 → 4 → 5 → 7 (isometry block) → 8 → 6 → 9 → 10 → 11 →
cone completion → 12 → 13.

Standing flags the assembly transcription will touch (both already reported, neither
resolved by me): the `def:base` "How the section populates" paragraph still cites
`[Def. 4.20, Def. 5.2]{GPVwind}` for unique-companion (the Def 4.7 ruling corrected the
proof paragraph and the bibitem; this occurrence looks left over); the CLAUDE.md AdF
§1/§11 pin fix (GPS 1606.03609) awaits the author's word.

*Approval gate: no lane-1 lemma lands until the author approves this itemization.*
