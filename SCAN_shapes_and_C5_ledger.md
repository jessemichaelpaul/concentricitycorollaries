# SHAPES SCAN + C5 LEDGER — the placement node
2026-07-04 · for HANDOFF.md (replaces, never appends) · fences held: anti-vacuity, R2, R8, no statement edits to pass a proof

## 0. What was scanned (register: this section is reporting, not mathematics)

- **Master v4** (`Octonionic_RH_master_v4.md`, project cache): read at `thm:concentricity` (proof in full, incl. the red `\TODO`), `rmk:pi0-split`, `rmk:collapse-vs-translation`, `cor:nontrivial`, `thm:rh-equiv` region. NOT read line-by-line elsewhere.
- **PROJECT_BRIEF_v2.md**: read in full. Identical in substance to the operational brief.
- **Quillen, *Higher algebraic K-theory: I*, §1** (Ravenel-hosted PDF, fetched 2026-07-04): text layer live; the Theorem-A page-run captured verbatim (Appendix A). OCR noise flagged with `[sic]`/brackets.
- **Riehl, CHT** (cathtpy.pdf, fetched): extraction reached front matter + ToC + Ch. 1 only. ToC confirms §8.3 *Final functors in unenriched category theory* p. 101, §8.5 *Homotopy final functors* p. 103. **Pinpoint wording NOT captured — SOURCES/ pull still queued.** Statement shape verified against nLab *final functor* (secondary, quoted §3.4).
- **Goerss–Jardine** (fetched): extraction reached front matter + ToC (Ch. IV *Bisimplicial sets* p. 195 confirmed). **Body NOT captured — SOURCES/ pull still queued.**
- **Thomason Thm 1.2**: not re-fetched; pin stands (statement via Sharma arXiv:2205.13686): |hocolim NF| ≃ B(∫F).
- The six cached project PDFs (files/): not opened this session; presumed the slice-regular sources (GPV/VS, winding, Wang, AdF). Identify next session if needed.

## 1. The node, verbatim (master v4, inside the proof of `thm:concentricity`)

> **[TODO:** The placement sentence (the author's). Ruling implemented: *static base* — 𝓑 carries no morphisms between distinct levels, so the level is a conserved quantity along every zigzag of 𝒯_A and π₀(𝓑) is the set of levels by construction; the conserved-level readout of Corollary `cor:nontrivial` is then immediate. Required here, in the sourced register of Remark `rmk:concentric-gloss`: the statement, in terms of levels and winding through the commuting triangle π∘E = exp only, that the degenerate fibre of the unique tame transport attached to an A-section lies over a ***single*** level. Metric vocabulary (centres, radii, "concentric") may not appear.**]**

Lean twin: the one `sorry`, `ASection.transportLevel_placement` (handoff §2 ledger).

## 2. The constraint every candidate shape must respect (proved, in-repo and in-master)

Master v4, the cocartesian computation (proof of `thm:concentricity`):

> π₀(𝒯_A) ≅ colim_𝓑(π₀∘F) ≅ π₀(𝓑), under which a residue-ℂ zero-sphere maps to the class of the base object beneath it, and two of them share a component of 𝒯_A **if and only if** they share that class.

[`lem:pi0-grothendieck`; Lean: `levelClass`, `zigzag_iff_level` — proved.] This is an isomorphism, not an estimate. Consequence, tagged and unavoidable: **any argument placing all zero-spheres in one component factors through the single-level sentence of §1.** A categorical shape can help only by (a) supplying that sentence, or (b) adding morphisms to 𝓑/𝒯_A — i.e., changing the object the theorem is about (fenced).

## 3. The shapes the pinned sources actually contain

### 3.1 Quillen Theorem A [SOURCED — Appendix A, capture lines 326–329]
> "Theorem A. If the category Y\f is contractible for every object Y [of C′ — OCR garbled], the functor f is a homotopy equivalence. … this result admits a dual formulation to the effect that f is a homotopy equivalence when all of the categories f/Y are contractible."

Information flow: connectivity/contractibility of the commas is the **hypothesis**; equivalence is the output. Applied at the π₀ shadow (as `rmk:pi0-split` does): to conclude the zero-bearing levels merge, the commas across distinct levels must already be connected — which, over the static base, is the single-level sentence again. Theorem A **receives** the placement; it cannot emit it.

### 3.2 Quillen, corollary to Theorem A [SOURCED — capture lines 354–356]
> "Corollary. Suppose that f is either prefibred or precofibred, and that f⁻¹(Y) is contractible for every Y. [Then] f is a homotopy equivalence. This follows from Prop. 2, Cor. 1."

Applied to p : ∫_𝓑 F → 𝓑 with connected band fibres: its π₀ shadow **is** the readout π₀(𝒯_A) ≅ π₀(𝓑) of §2 — the master's primary computation, lifted from π₀ to homotopy. It preserves the levels; it has no power to merge them.

### 3.3 Quillen Corollary 2 [SOURCED — capture line 290] — the fence, now source-tagged
> "Corollary 2. A category having either an initial or a final object is contractible."

This is the verbatim reason the adjoin-N-as-terminal move is vacuous: it contracts B(𝒯_A) for **every** section, zeros or none, killing the iff of §2 and with it `thm:rh-equiv`'s content. The fence in the handoff (§5 "do not") now carries its citation.

### 3.4 Finality [Riehl §8.3/§8.5 — PIN, wording pull queued; nLab *final functor* secondary, fetched]
> nLab, Definition: "A functor F : C → D is final if for every object d ∈ D the comma category (d/F) is (non-empty and) connected." Idea: "F is final if restricting diagrams along F does not change their colimit."

Finality **preserves** colimits along a functor whose commas are already connected. Same flow as 3.1: connectedness in, invariance out. π₀ is untouched except through hypotheses that are the node itself.

### 3.5 Thomason Thm 1.2 [PIN] and GJ Ch. IV [PIN, pull queued]
B(∫_𝓑 F) ≃ hocolim_𝓑(B∘F); the bisimplicial engine (diagonal/realization comparisons) supplies weak equivalences between models of the **same** homotopy colimit. Every arrow is an equivalence over the same base diagram; π₀ = colim_𝓑 π₀F = the levels, always.

### 3.6 Conclusion of the scan
Every shape in Quillen §1 / Riehl §8.3–8.5 / GJ IV / Thomason is of one of two forms: *two computations of one homotopy type agree*, or *given connectivity of commas/fibres, a comparison map is an equivalence*. All of them transport connectivity; none create it. Against the proved iso of §2, the categorical layer is a faithful reader of levels. **The single-level sentence of the TODO is not producible at this layer; it is the one analytic input the frame is built to receive.** This confirms the handoff's §3 stop-node, now with the sources attached. The cut-cocartesian chase is not missing a cleverer shape — it is complete, and correct, as a readout.

On the specific hope in the session brief — pulling VS **weak concentricity** through the section: VS gives *per-fibre* concentricity (exp⁻¹(x) is one concentric family, one level, per value x — VS Preface p. 972, pinned). The gap between "each fibre sits over one level" and "the zeros occupy a **single** fibre/level" is exactly §1. Writing the single-fibre step as derived, without a source, is the fenced move (handoff §5).

## 4. C5 ledger — bare, category-free sentences about ζ's zeros
Fence: not the functional equation; not RH-strength-by-another-name. Status against known literature (statuses are reporting, not verdicts on the program).

| # | Bare sentence | Status vs. fence |
|---|---|---|
| a | "Every nontrivial zero of ζ has the same real part." | The target itself (= placement, = concentricity; FE then pins ½ via `thm:rh-equiv`/`cor:rh`). As an input: circular. |
| a′ | "The degenerate values of the stem's unique tame transport all lie over one level" (single-fibre form). | Same content as (a) in the master's register. |
| b | "ζ has no zeros with real part ≥ 1" (+ VP widening). | Known, Euler-product route, no FE — bounds where zeros are *not*; does not equalize the ones that exist. |
| c | "Infinitely many zeros lie on the critical line" (Hardy); "a positive proportion do" (Levinson, Conrey ≥ 2/5). | Known; proofs route through the (approximate) FE; and *many on* ≠ *all on one*. |
| d | "RH ⟺ ζ′ has no zeros in 0 < σ < ½" (Speiser). | Equivalence, FE-dependent; circular-adjacent. |
| e | Zero-density: N(σ,T) ≪ T^{θ(σ)}, θ < 1 for σ > ½ (Ingham, Huxley). | Known; *few off-line* ≠ *none off-line*; cannot equalize. |
| f | de Bruijn–Newman: RH ⟺ Λ ≤ 0; known Λ ≥ 0 (Rodgers–Tao). | Built on Ξ, i.e. on the FE object; and the known direction gives no equalizing force. |
| g | "The Euler product converges for σ > ½" / M(x) = O(x^{½+ε}) etc. | Each RH-equivalent or stronger: RH-strength by another name. |
| h | Selberg-class structure (degree classification, Kaczorowski–Perelli). | Real theorems, no FE assumed beyond the class axioms — none equalize real parts; "all class members concentric" **is** GRH for the class. |

Ledger conclusion (= handoff §4, unchanged by this scan): stated for **all** A-sections from C1–C4 alone, the placement sentence is GRH-scale — its proof would prove GRH for every member, and its failure would be an off-line zero of some Euler-product L-function. The master's own escape hatch is already in its text: *"ζ_𝕆 is one member, with private extra properties."* A legitimate C5 is a **private property of ζ** beyond C1–C4 and short of the FE that pins one level. Naming it is the discovery point; no known candidate appears in the table.

## 5. Recording options for the node (R6 — author's ruling required)

1. **Sorry stands.** `ASection.transportLevel_placement` remains the one sorry; its docstring carries §1 verbatim and points at this ledger. Zero edits; the master's TODO stays red. (R8: queue item, honestly labeled — with the annotation that what is queued is open mathematics, not translation backlog.)
2. **Named hypothesis.** Add **C5 (placement)** to `def:A-section` — "the degenerate fibre of the unique tame transport lies over a single level" — making `thm:concentricity` unconditional from C1–C5 and moving the open mathematics into the instantiation `ζ_𝕆 satisfies C5`, one clearly-flagged node. Non-vacuous, no hidden edits — but it is a statement change, hence yours alone.
3. **Commission the C5 hunt.** A deep literature pass (post-2023 included: Selberg-class placement results, pair-correlation-without-RH, de Branges-type positivity, Li-coefficient criteria, arithmetic quantum chaos) hunting any equalizing fact not in the table. Honest odds are honest odds; the table is what a first sweep returns.

## 6. The extended-triangle colimit reading (author's proposal, 2026-07-04), run precisely

Proposal as received: extend the commuting triangle π∘E = exp into a larger diagram over 𝕆*; at N the unique lift is characterized by a colimit (coequalizer or pushout); the colimit carries all residue-ℂ zeros into one connected component; concentric ℂ-data is obtained from per-slice concentric pieces (S¹ ⊕ S²) assembling every slice. Two readings, each run to its end.

**(1) In spaces — the slice assembly.** The colimit of the slice diagram {ℂ_I* : I ∈ S⁶} glued along the shared ℝ ∪ {N} is 𝕆* itself — the slice decomposition [AdF 2106.04227 §1, pin; `rmk:compactify`]. Its effect on zero loci is the **proved** assembly: for fixed (σ,τ) the per-slice pair σ ± Iτ glues over I ∈ S⁶ into one connected 6-sphere S₍σ,γ₎ [`lem:residue-spheres`, `thm:zero-spheres`]; within one degenerate fibre the k-ladder is concentric at a single level, winding on the band [`lem:exp-degenerate`; VS weak concentricity, pin]. Every gluing arrow of this diagram — direction G₂, band U(1), orthogonal U(1), and the lift-closure at the pole cone — **fixes the real level** [brief/def:base: "static… the level is a conserved quantity along every zigzag"]. Output: one connected S⁶ *per zero*, concentric ladder *per fibre*. No arrow of the diagram relates distinct levels σ₁ ≠ σ₂; π₀ of the assembled zero locus is still the set of levels.

**(2) In Cat — the colimit at 𝔫.** Let u, v : X ⇉ 𝒯_A be any parallel pair (span, for a pushout) built from C1–C4 data, Q the (homotopy) coequalizer. π₀(hocolim) = colim π₀ [Thomason pin; GJ IV pin], so the identifications in π₀(Q) are exactly those asserted by the legs. Dichotomy:

- **(2a)** level(u(x)) = level(v(x)) for every x — true of every arrow family constructed so far. Then Q identifies within levels only; the levels survive; no forcing.
- **(2b)** some x has level(u(x)) ≠ level(v(x)). The pair (u,v) is built from C1–C4 data, hence exists for **every** A-section uniformly; Q merges those levels regardless of where the section's zeros sit. "One component of Q" then constrains nothing, and the readout iff [master: "share a component **if and only if** they share that class"; Lean `zigzag_iff_level`] fails in Q — `cor:nontrivial`'s translation (one component ⇒ one centre) does not survive the passage. Vacuous, with the mechanism now source-tagged: [Quillen §1, Cor. 2 — Appendix A].
- The third branch is, definitionally, **C5**: legs whose existence is conditional on a property of the section beyond C1–C4. Then Q closes the proof — *from C5*.

**What the unique lift at 𝔫 actually carries.** Cor 5.13 gives existence-and-loop-closure of the tame lift; Cor 5.21 gives winding ω = |σᶜ|/2 [GPV winding, pins]. Both are discrete (a yes/no; an integer). The level is a real number. A colimit whose arrows carry only discrete invariants cannot pin a continuum equality [handoff §3.4]. For the diagram to escape (2a) non-vacuously, some arrow must carry the real level itself across levels — and "such arrows exist over a *single* level" is verbatim the TODO of §1.

**The obligation, stated as a target.** *There is a leg (u,v) at 𝔫, constructed from C1–C4 plus a named ζ-private property, with level(u(x)) ≠ level(v(x)) for some x, and whose existence fails for a hypothetical section with split zero levels.* Naming the ζ-private property that powers the leg is naming C5. The colimit vocabulary relocates §4; it does not answer it.

## 7. The proposed license "nothing beyond summable after Euler" (C5 := C2 + C3), run precisely

Proposal as received: the level-crossing leg of §6 is licensed by C2-summability and C3 alone — in the chart p ↦ 1/p toward N there is a residue-ℂ sphere arbitrarily close to every residue-ℝ point; both the degenerate fibre and the zeros are pulled to N by C2/C3; this forces infinitely many concentric S⁶ and licenses the arrow.

**(i) Where the license lands in the §6 dichotomy.** C2 and C3 are fields of `def:A-section` — every A-section has them by definition. A leg whose existence proof consumes only C2/C3 (+C4) therefore exists for **every** A-section uniformly. That is branch **(2b)** verbatim: Q merges levels for all sections, zeros wherever they sit; the readout iff [`zigzag_iff_level`] dies in Q; `cor:nontrivial` cannot translate. The §6 target required the leg's existence to **fail** for a hypothetical split-level section — but a split-level section still satisfies C2 and C3 (an off-line zero of an Euler-product L-function lives in a section with full Euler product and full Hadamard–Weierstrass factorization; that is what a GRH counterexample *is*). The handoff banked exactly this reduction, in advance [handoff §5]: *"If it reduces to Euler + Weierstrass + continuation, that is GRH and is not known to suffice."*

**(ii) The chart computation — where the level lives at N.** In the slice chart, for a zero ρ = σ + Iτ:

  1/ρ = σ/(σ² + τ²) − I·τ/(σ² + τ²)  ≈  σ/τ² − I/τ  (τ → ∞).

Distance to the real circle ℝ ∪ {N} in the chart: |Im(1/ρ)| ≈ 1/τ — **first order, level-blind**. The observed fact — "a residue-ℂ sphere arbitrarily close to every residue-ℝ point near N" — is this first-order decay, and it holds for every level simultaneously: a hypothetical section with zeros at σ₁ ≠ σ₂ has *both* families arbitrarily close to the real circle at N. Accumulation at N is the compactification working (one point swallows all unbounded directions), not level data; if chart-proximity at N carried the level, the static base could not have been built. The level survives only at **second order**: τ² · Re(1/ρ) → σ. So the proposal, made exact in its own chart vocabulary, is:

> **C5-chart form:** *τₙ² · Re(1/ρₙ) has one common limit over the residue-ℂ zeros.*

— which is ledger **(a)** again (all real parts equal), now located: concentricity is the statement that the **second-order coefficient of approach to N is constant**. First-order closeness cannot see it.

**(iii) The strengthened-summability reading.** If "summable after Euler" is pushed to convergence of the Euler data on a half-space reaching past σ = 1 toward the critical line, that is ledger **(g)**: Euler-product convergence on σ > ½ is RH-equivalent-or-stronger. The class-level C2 gives a zero-free half-space and no more [ledger (b)].

**(iv) What stands.** Accumulation of the zero-spheres and of the fibre ladder at N: real (C4 + compactness of S⁸, C1's cone). Per-fibre concentricity: real [`lem:exp-degenerate`, VS]. Infinitude: real (C4; Route A proved for ζ). The open quantifier is unmoved: *per fibre* concentric (proved) vs. *one fibre* (the TODO). §7 relocates the placement sentence to a sharp new register — the second-order coefficient at N — without discharging it. The sorry stands; the target of §6 stands: a license whose failure mode is split-level sections.

## 8. "What is a level?" — the definitional answer, the base's morphisms, and the site variant

**Level, defined** [`def:base`, `lem:exp-degenerate`]. The degenerate fibre of exp over a real value −r is {log r + I(2k+1)π : I ∈ S⁶, k}. Its **level** is the real number log r — the one real coordinate every point of the fibre shares. Objects of 𝓑 are the levels: real numbers, points of ℝ ⊂ ℝ ∪ {N}. For a residue-ℂ zero-sphere S₍σ,γ₎ the level is σ; under the Part-2 translation, the level of a classical zero ρ is Re ρ. Lean: `levelClass`.

**The great-circle instinct, objectwise: right.** 𝓑's object set is ℝ = the shared circle minus N (N is the pole, C1 — the cone point, never a level). The base *is* the great circle in that sense. [master `def:base`; architecture line "ℝ ∪ {N} fixed"]

**Why U(1) ⊂ G₂ yields no arrows between levels.** G₂ = Aut(𝕆) fixes the real line pointwise [Baez pin; draft `g2_fixed_locus`]. Hence every U(1) ≤ G₂ fixes **every point of the circle** — its action on levels is the identity. In 𝓗₁ = G₂ ⋉ 𝕆*, the orbit of a real point is a singleton; the architecture's own words — "ℝ ∪ {N} fixed" — *are* this statement. Restriction/inclusion along U(1) ⊂ G₂ produces arrows within a level's fan, never between levels. The staticness of 𝓑 is not a formalizer's choice; it is the fixed-locus computation of the project's own architecture.

**Why static is the semantic link, not a defect.** Master, `rmk:collapse-vs-translation`: "the components of the static base are the real levels …, so one connected component is one real centre." With inter-level arrows added, the construction stays perfectly well-defined — and `cor:nontrivial` stops following: one component no longer means one centre, severing `thm:concentricity` from concentricity and from `thm:rh-equiv`. On well-definedness: the spine type-checks as built (0 axioms). A construction does not need the theorem to be well-defined — that is R4 ("build from the hypotheses; read the zeros off at the end").

**Consumption table — where each hypothesis is spent.**

| Hypothesis | Consumed by | Level behavior |
|---|---|---|
| C1 (one pole, 𝔫) | the cone; lifts close into loops [Cor 5.13, `rmk:collapse-cone`] | level-uniform |
| C2 (infinite Euler, summable, zero-free Ω₀) | existence of the continuation/lift [`thm:winding-lift`]. The prime tail accumulates at N *inside the fixed circle* (primes are real points); that accumulation is spent on lift existence | level-uniform |
| C3 (infinite Weierstrass, full divisor) | the second exponential expression; one stem via `thm:identity` — this *is* "Weierstrass moves the Euler product along the continuum," and it is spent on uniqueness/tameness of the lift | level-uniform |
| C4 (infinitely many residue-ℂ zeros) | infinitude of the degenerate fibre (the k-ladder) | level-uniform |
| **Placement (single level)** | **nothing — the open slot** | — |

All four class hypotheses are consumed; each is level-uniform; none outputs an inter-level identification. The placement is the only unconsumed line.

**The Grothendieck-topology variant (author's proposal, this session).** A topology on 𝓑 (covering sieves = cofinite tails at N, say) adds **no morphisms** and leaves π₀ of the underlying category unchanged — it changes which presheaves are sheaves (descent), not connectivity. A sheaf-theoretic restatement over a site-at-N is a *new* theorem requiring its own readout-to-centres; gluing along tail covers is uniform in the section, so §6's licensing question recurs at the descent step. Geometric gloss (R10 — remark register, never load-bearing): taking the base as the topological circle makes the *ambient* connected trivially; the theorem needs the zero-**level set** connected as a subobject, and a countable set of reals is connected iff it is one point. The project's original register (compactified Hurwitz tower cofibered in groupoids; Stacks Project sources — metadata provenance) is available for stating the site version, statements-first, same discipline, on request.

## Appendix A — Quillen §1 capture (SOURCES/Quillen-S1 draft; OCR noise marked)

Fetched 2026-07-04 from https://www.sas.rochester.edu/mth/sites/doug-ravenel/otherpapers/Quillen-Higher-I.pdf (extraction lines 280–367; page markers "92/85", "93/86" visible in the run — LNM 341, §1).

> Proposition 2. A natural transformation θ [OCR: e]: f → g of functors from C to C′ induces a homotopy [B C] × I → [B C′] between Bf [and] Bg.
>
> We will say that a functor is a homotopy equivalence if it induces a homotopy equivalence of classifying spaces, and that a category is contractible if its classifying space is.
>
> Corollary 1. If a functor f has either a left or a right adjoint, f [is a] homotopy equivalence.
>
> Corollary 2. A category having either an initial or a final object is contractible.
>
> [§]Sufficient conditions for a functor to be a homotopy equivalence. Let f: [C → C′] be a functor … If Y is a fixed object of [C′], let Y\f denote the category consisting of pairs (X,v) with v : Y → fX, in which a morphism from (X,v) to (X′,v′) is a map w: X → X′ such that f(w)v = v′. … Similarly one defines the category f/Y consisting of pairs (X,u) with u: fX → Y.
>
> **Theorem A.** If the category Y\f is contractible for every object Y [of C′], the functor f is a homotopy equivalence.
>
> In view of [duality] this result admits a dual formulation to the effect that f is a homotopy equivalence when all of the categories f/Y are contractible.
>
> [Prefibred/precofibred:] It is easily seen that f makes [C] a prefibred category over [C′] … if and only if for every object Y of C′ the functor f⁻¹(Y) → Y\f, X ↦ (X, id_Y) has a right adjoint. … Dually, f makes C into a precofibred category over C′ when the functors f⁻¹(Y) → f/Y have left adjoints …
>
> **Corollary.** Suppose that f is either prefibred or precofibred, and that f⁻¹(Y) is contractible for every Y. [Then] f is a homotopy equivalence. This follows from Prop. 2, Cor. 1.

Queued for SOURCES/: Riehl §8.3 + §8.5 exact wording (pp. 101–103); GJ Ch. IV realization lemma; Thomason 1.2 via Sharma.
