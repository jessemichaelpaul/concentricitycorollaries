# OPERATIONAL BRIEF — Concentricity over the Octonions

*Dual use: claude.ai project instructions now; **CLAUDE.md in the Lean repo**, unchanged.
**Replaces all earlier project instructions.** HANDOFF.md, when present, carries only the
current task and is replaced, never appended.*

## The object

**The Concentricity Theorem** (master `thm:concentricity`). An **A-section**
(`def:A-section`) is a section A of the commutative ring 𝓡 of slice-preserving
slice-regular functions on the compactified octonions 𝕆\* = S⁸ (equivalently: a
slice-preserving *semiregular* function) with four properties:

- **C1** — meromorphic continuation with exactly one pole; simple, at a real point, of value ∞ = N;
- **C2** — infinite Euler product: A = exp(Σₚ ℓₚ) on a slice right half-space Ω₀, an infinite
  summable slice-preserving family, zero-free there;
- **C3** — infinite slice-regular Weierstrass factorization A = qᵐ·R·e^g·∏ₙ 𝓔(·;qₙ) over its
  full divisor, {qₙ} enumerating the residue-ℂ zero-spheres;
- **C4** — infinitely many residue-ℂ zeros.

**Theorem:**
the residue-ℂ zero 6-spheres of an A-section lie in a **single connected component** of
𝒯_A = ∫_𝓑 F.

Neither ½ nor any functional equation appears in the statement or the proof. The class
plausibly contains many L-functions; ζ_𝕆 is one member, with private extra properties.
**RH appears exactly once**, as `cor:rh`, downstream, via ζ's own functional equation.
Provenance: exploratory — the theorem was found before its corollary; the document's order
mirrors the discovery order.

## Sources of truth, in order

1. **Lean code**, once it exists — `lake build` is the meter.
2. **`Octonionic_RH_master.tex`** (v4) — the author's paper, fully folded: `def:A-section`,
   `lem:exp-degenerate` + `rmk:concentric-gloss`, `\uses{}` annotations document-wide.
   **One open item**: the placement sentence, marked as the document's single red `\TODO`
   inside the proof of `thm:concentricity` — the author's to supply, in the sourced register
   (levels and winding through the triangle π∘E = exp; no metric vocabulary).
3. **SOURCES/** — verbatim one-page excerpts of every cited statement (build per Pins).
4. **`DEPENDENCY_TABULATION.md`** — the backwards dependency audit; consumer columns = the
   annotation skeleton; Lean bucket mapping (Spine / ClassicalInputs / ZetaO / Translation / RH).

## The architecture (the map — do not re-derive it)

- **𝓗₁ = G₂ ⋉ 𝕆\***, translation (action) groupoid; components = orbits: ℝ ∪ {N} fixed,
  direction 6-spheres S₍σ,γ₎ (residue-ℂ).
- **𝒮₂**, the slice world: the codomain 𝕆\* by its slice decomposition (ℂ_I = Span_ℝ(1, I);
  slices share ℝ and the single ∞); morphisms = band U(1) phases (fixing 0, ∞, modulus) and
  direction G₂.
- **Φ : 𝓗₁ → 𝒮₂**, the section functor: Φ(q) = A(q) on objects, direction morphisms on
  morphisms; equivariance from the one I-independent real stem (Wang 2.11).
- **𝓑**, the base of the exponential's **degenerate set** (the construction uses only
  levels and winding): objects = the real levels of the degenerate fibre,
  exp⁻¹(−r) = {log r + I(2k+1)π} — *proved* from the slice form (`lem:exp-degenerate`),
  absent over ℂ (VS Rem 5.2(b)); **static**: no morphisms between distinct levels, so the
  level is a conserved quantity along every zigzag. Winding is band data, never an object
  label. **F** = the band U(1); **𝒯_A = ∫_𝓑 F**. "Concentric" is the downstream metric
  gloss (`rmk:concentric-gloss`), translation vocabulary only.
- **Proof shape**: C1–C4 *assemble* the transport — C2/C3 are two exponential expressions of
  the one stem, agreeing by the identity theorem, hence the unique tame lift; C1's pole is
  the cone through 𝔫, closing lifts into loops (Cor 5.13); C4 makes the degenerate fibre
  infinite. Zeros arrive as the **degenerate fibre — output, never input**. Readout:
  π₀(𝒯_A) ≅ colim_𝓑(π₀∘F) ≅ π₀(𝓑) = the levels. **Two proofs**: cocartesian (primary,
  Lean-native) and finality (Quillen Thm A / precofibred corollary; expository remark,
  deliberately left for the community to formalize).
- Then the translation corollaries; then `cor:rh` — two lines, functional equation, done.

## Rules

- **R1** — Every step carries a tag: master label, SOURCES/ file, or Mathlib declaration.
  Untagged reasoning stops and fetches the source.
- **R2** — Quote the master and the sources; never reconstruct from training knowledge or
  first principles. Unclear step ⇒ open the source before writing.
- **R3** — All four hypotheses are construction material, applied together; never weakened,
  dropped, or treated as filters on a pre-existing object.
- **R4** — Build from the hypotheses; read the zeros off at the end. Translation theorems
  attach only after the theorem, as corollaries.
- **R5** — Verify Mathlib names against live docs before use. Every axiom carries the
  verbatim source statement in its docstring. Live docs are for diagnosis; the pin binds
  citations.
- **R6** — Ask the author when a ruling is needed; mark real gaps as gaps; never invent
  done-ness.
- **R7** — Deliverables are files or diffs against the master, not essays about it.
- **R8** — `sorry` marks UNFORMALIZED, never UNSOUND. Axiom leaves are permanent and cited;
  sorries are queue items. The model's role is translation and goal-closing, never
  evaluation of the mathematics. A statement that seems wrong is an R6 stop: cite the exact
  failing goal or type error and ask. No prose verdicts, anywhere.
- **R9** — **No existence axioms.** Every object (𝕆 via Cayley–Dickson over Mathlib's ℍ,
  G₂ := AlgAut(𝕆), the groupoids, Φ, 𝓑, F, 𝒯_A) is constructed; axiom leaves are theorems
  from the literature, never existence claims. Zero-axiom target: R is defined by the stem
  functor over Mathlib's Hol(C); literature is cited for faithfulness of definitions, never
  as load. Each remaining axiom's docstring carries its price of deletion. The gate is
  literal: zero sorries and zero project axioms — the declared leaf set is empty;
  `riemannZeta_nontrivialZeros_infinite` enters as a sorried theorem and is proved
  in-repo. (Mathlib's three foundational axioms always print and are not counted.)
- **R10** — **Three registers, typographically distinct**, especially in the
  slice-preserving octonionic layer (mostly axiomatized): SOURCED statements are verbatim
  quotes with pinpoint cites (in Lean, the quote lives in the axiom's docstring; any
  compactified or notational transport is its own marked derivation node, per
  `rmk:compactify`); DERIVED facts are lemmas with proofs, never citations; GLOSSES —
  geometric or intuitive descriptions — live in remarks, are never cited, never
  load-bearing. Case study: "concentric" was a gloss riding on a citation; it is now
  `lem:exp-degenerate` (sourced + proved) plus `rmk:concentric-gloss` (gloss).
- **R11** — Final bibliography is journal-only — no arXiv references; verify
  venue/volume/pages/DOI live during the SOURCES pass.

## Pins (banked; turn each into a SOURCES/ file)

- **Quillen, *Higher algebraic K-theory: I*, §1** (full text extracted in-thread): Theorem A
  (Y\\f contractible for all Y ⇒ homotopy equivalence; dual over f/Y); corollary —
  pre(co)fibred with contractible fibres ⇒ equivalence; π₀(BC) ↔ components of C;
  initial/final object ⇒ contractible; bisimplicial realization lemma.
  https://www.sas.rochester.edu/mth/sites/doug-ravenel/otherpapers/Quillen-Higher-I.pdf
- **Thomason, MPCPS 85 (1979), Thm 1.2**: |hocolim NF| ≃ B(∫F). nLab scan textless;
  statement via Sharma arXiv:2205.13686.
- **Riehl, CHT**: Part I = Ch. 1–6; finality §8.3/§8.5.
  https://emilyriehl.github.io/files/cathtpy.pdf
- **Goerss–Jardine** (Ch. I nerve; Ch. IV bisimplicial engine):
  https://www.sas.rochester.edu/mth/sites/doug-ravenel/otherpapers/Goerss-Jardine2.pdf
- **VS, "Slice conformality…" — Math. Z. 302(2) (2022), 971–994, DOI
  10.1007/s00209-022-03079-4, open access; version-of-record excerpts in SOURCES/VS.md
  (supersedes the old GPV_pdf.pdf note)**:
  **Rem 5.2(a)** verbatim: (π∘E)(q) = exp(q) — *the commuting triangle*. **Rem 5.2(b)**
  verbatim (printed p. 988): "Unlike what happens in the complex setting, the map
  π : 𝓔⁺_K → K is not a covering. It is not an open map as well, due to the fact that
  exp : K → K is not an open map (it has a non–empty degenerate set consisting of
  spheres)." Prop 4.1/Thm 4.2 (stereographic atlas); Prop 5.1, Rem 5.2, Def 5.3,
  Prop 5.4, Def 5.5 (E⁺, L — environment types per the print). The fibre formula
  exp⁻¹(−r) = {log r + I(2k+1)π} is **derived** (`lem:exp-degenerate`); VS's Preface
  (p. 972) prints it as unproved motivation — acknowledged in the master's lemma,
  derivation load-bearing.
- **GPV winding — J. Math. Anal. Appl. 536(1) (2024), Paper No. 128219, DOI
  10.1016/j.jmaa.2024.128219 (arXiv:2307.14047 v1; excerpts in SOURCES/GPVwind.md;
  JMAA-version numbering unverified — publisher 403, author to confirm via library)**:
  Def 5.11 (loop lift, pr₁∘Γ = γ∘exp); Def 4.7 (tame path = unique companion; Def 4.20
  for maps; Def 5.2 = tame/semi-tame at an obstruction parameter — the paper has NO
  Rem 5.2 and never prints "degenerate": those quotes are VS's, per SOURCES/GPVwind.md
  FLAGS); **Cor 5.13** (lift exists iff σ ∈ {0,−1} per obstruction interval; then a loop)
  — supersedes the old 5.22 cite; Cor 5.21 (winding = |σᶜ|/2); Rem 2.1 (the direction
  I(q) has no continuous extension to ℝ).
- **Wang Rem 2.11**; **Bisi–Winkelmann §3.2/§3.7**; **AdF 1801.01318 Prop 3.1 + Thm 3.2**
  (C3); **AdF 2106.04227 §1, §11** (slices; semiregular); **Baez** (G₂ ↷ S⁶, stab SU(3)).
- **Mathlib** (verify live): `CategoryTheory.Grothendieck` (✓ verified — *not* the
  Grothendieck-topology files), `CategoryTheory.ConnectedComponents` + `IsConnected`
  (✓ verified — connectedness is *defined* by "functors to discrete categories are
  constant"), `ActionCategory`, `Functor.Final`, `OnePoint`. Day-one checks: octonions
  (likely absent — build CD(ℍ) in-repo per R9), `riemannZeta` cluster (continuation, FE,
  Euler product — possibly Mathlib-native, shrinking the classical leaves).

## Phase

1. **The placement sentence** — the author's, into the one red `\TODO`; sourced register.
2. **SOURCES/** — Quillen §1, VS Rem 5.2, GPV winding statements first (all already
   extracted in-thread).
3. **Statement layer** in Claude Code: repo = lake + Mathlib + leanblueprint. First file:
   `structure ASection` (the four fields), first lemma the slice-preserving stem package;
   then 𝓗₁, 𝒮₂, Φ, 𝓑, F, 𝒯_A, the π₀ lemma, the theorem statement; leaves as axioms with
   verbatim docstrings. Sorries per R8.
4. Prove the categorical spine; then the assembly against the leaves.
5. Blueprint site (the LaTeX **is** the human face; prose iterates freely); verify
   everything; then post.
