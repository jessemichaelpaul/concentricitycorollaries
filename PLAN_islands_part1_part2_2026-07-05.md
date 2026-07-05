# PLAN — the islands: Part 1/Part 2 delineation and the fan-out runway (2026-07-05, evening)

**Status: CONFIRMED IN DIALOGUE** (author, in-session, 2026-07-05 evening — including the
Island P naming ruling: **the One-Hyperplane Theorem**; Q1/Q2/Q3 resolved, §4). This
document is Step 1 of the author's revised runway and re-scopes the execution sequence of
HANDOFF.md / OPENER_next_threads.md / DESIGN_translations.md §#2–#3–#5 (superseded per the
Juncture Protocol, §6, at juncture ①).

**The framing of record (author, 2026-07-05 evening dialogue):** the base 𝓑 over the
general ring 𝓡 is disconnected — levels, dust, by construction (π₀(𝓑) = ℝ, PROVED). The
A-section's transport connects it at N (`concentricity_transport`, PROVED, certificate).
The connection is level-blind by design (Pin 2, PROVED): in the compactified 𝕆*, every
hyperplane {Re = σ} meets every other at the single point N, so arriving together at N
carries no information about which hyperplane a zero-sphere came from. Whether the
zero-dust was already bound at a FINITE point — one hyperplane, one σ — is **Island P**
(§3.5), the project's only open mathematics.

## §0 — The correction of record (the conflation, named)

DESIGN_translations §#3 drafted `zetaSection : ASection` with `F := riemannZeta` and
docstrings citing classical `riemannZeta` facts directly into the class fields. That
conflates the member with its stem. The master's architecture (Parts 1–2):

- **The member is ζ_𝕆** (`def:zeta_O`) — an octonionic object on 𝕆* = S⁸, built slicewise
  from slice-regular theory. IT is what lives in 𝓡 (`thm:zeta-in-R`) and IT is the
  A-section (`cor:zeta-section`).
- **Classical ζ lives on compactified ℂ** (`def:zeta-Cstar`: ζ_ℂ* : ℂ* → ℂ*, ζ_ℂ*(1) = ∞,
  ζ_ℂ*(∞) = 1).
- **The bridge is the Zero Equivalence Theorem** (`thm:zero-equivalence`): zero of ζ_𝕆 iff
  zero of ζ_ℂ* at the slice coordinate; classical facts cross INTO the octonionic layer
  only over this bridge (+ `thm:zero-spheres`' residue dictionary).

Stem-encoding note (so the correction is resolved, not papered over): in the repo,
`ASection` is stem-encoded (`F : ℂ → ℂ` per `def:section-map`, the Wang node), so the
*fields* of `zetaSection` are stem-level transcriptions and the stem of ζ_𝕆 is the
classical ζ. Both layers are needed and neither substitutes for the other: the Part-2
islands (ζ_𝕆, zero-equivalence, zero-spheres) are what make reading the stem-level fields
as facts about ζ_𝕆's zero-spheres FAITHFUL. `cor:zeta-section` = the stem-level instance
+ the octonionic reading, welded by the islands. Without the islands the instance is a
statement about classical ζ only — the conflation this plan removes.

## §1 — Island inventory, Part 1 (classical background, compactified ℂ)

Each island: master label · verbatim statement (transcribed; proofs omitted) · Lean shape
· existing stock. All Part-1/Part-2 islands are placement-free and logically independent
of `thm:concentricity`.

### A1 — `def:zeta-Cstar` (compactified classical zeta)

MASTER (verbatim): "ζ_ℂ* : ℂ* → ℂ* is the meromorphic continuation of ζ regarded as a map
to the Riemann sphere: ζ_ℂ*(s) = ζ(s) for s ∈ ℂ∖{1}; ζ_ℂ*(1) = ∞ (the simple pole,
Theorem thm:riemann); and ζ_ℂ*(∞) = 1, since ζ(s) → 1 as Re(s) → +∞ (the p-test: only the
n = 1 term of Σ_n n^{-s} survives). It is holomorphic into ℂ* on ℂ*∖{1}, its sole pole
being s = 1. The functional equation, the conjugate symmetry ζ_ℂ*(s̄) = conj(ζ_ℂ*(s)), and
Hardy's infinitude (Theorem thm:hardy) hold verbatim for ζ_ℂ*, as they concern values on
ℂ∖{1} where ζ_ℂ* = ζ." (\uses{thm:riemann})

Lean shape:
```lean
def zetaC : OnePoint ℂ → OnePoint ℂ   -- ℂ* = OnePoint ℂ (Mathlib OnePoint)
-- zetaC (some s) = if s = 1 then ∞ else some (riemannZeta s); zetaC ∞ = some 1
```
Stock: `OnePoint` in use already (ASection.valueAtInfinity). Pins to verify live (R5):
`riemannZeta`, `differentiableAt_riemannZeta`, conjugate symmetry (form to locate:
`riemannZeta_conj` or via `LSeries`/`DirichletContinuation` API), ζ(s) → 1 as Re s → ∞
(locate or derive from the Dirichlet series tail bound).

### A2 — `lem:zero-Cstar` (compactification does not move the zeros)

MASTER (verbatim): "Z(ζ_ℂ*) = Z(ζ): the zeros of ζ_ℂ* in ℂ* are exactly the zeros of ζ in
ℂ; in particular the nontrivial zeros coincide." (\uses{def:zeta-Cstar})

Lean shape: `theorem zetaC_zero_iff (s : ℂ) : zetaC s = some 0 ↔ riemannZeta s = 0 ∧ s ≠ 1`
(shape to finalize against the arbiter; the two adjoined values are non-zeros by
computation). Expected free.

### A3 — the classical citation stock (Part 1 theorems the corollaries cite)

- `thm:riemann` (continuation; single simple pole; ξ entire; FE ξ(s) = ξ(1−s);
  ξ(s̄) = conj ξ(s); trivial zeros at −2,−4,…; nontrivial zeros in 0 < Re s < 1).
  Lean status: continuation/pole in Mathlib (`riemannZeta` cluster); FE pin to verify
  live (`riemannZeta_one_sub` / `completedRiemannZeta` FE — exact name reported at the
  R5 sweep); ξ-entirety already in-repo as `xi_entire` (ZetaInfinitude.lean, PROVED).
- `thm:euler` (infinite Euler product, exp-of-sum form, zero-free on Re s > 1).
  Lean status: Mathlib `EulerProduct` cluster — R5 sweep to report exact coverage of the
  exp-log form.
- `thm:hadamard` (ξ entire of order 1, infinitely many zeros = nontrivial zeros, Hadamard
  factorization ξ(s) = ξ(0)·∏_ρ (1 − s/ρ)e^{s/ρ}).
  Lean status: **partially in-repo, PROVED** — ZetaInfinitude.lean carries the entire-ξ
  normalization (`xi`, `xi_entire`), `xi_zeros_eq_nontrivialZeros`, divisor machinery,
  `xi_factorization_of_finite`, and the Borel–Carathéodory growth stock. AUTHOR INPUT
  PENDING: whether a fuller infinite-product formalization exists elsewhere to wire in,
  or whether the infinite-product form is assembled from this stock when C3-for-ζ closes
  (see §4, Q1).
- `cor:hadamard-infinitude` — **PROVED in-repo**: `riemannZeta_nontrivialZeros_infinite`
  (ZetaInfinitude.lean, clean axiom triple).
- `thm:hardy` (infinitely many zeros ON the line). Load check: the master cites Hardy only
  as "also" alongside `cor:hadamard-infinitude` (zero-spheres (iv), cor:rh's "in
  particular"). NOT load-bearing for any island below; propose: cite-only, no Lean row
  (author to confirm, §4 Q2).

## §2 — Island inventory, Part 2 (the octonionic zeta and the equivalence)

### B1 — `def:zeta_O` (octonionic zeta)

MASTER (verbatim, the display): "The octonionic zeta function ζ_𝕆 : 𝕆* → 𝕆* is defined
slicewise from the compactified classical zeta (Definition def:zeta-Cstar) through the
slice identifications φ_v : ℂ* ≅ ℂ_v* = S²_v …: (i) for s ∈ 𝕆∖ℝ, with w = im(s),
v = w/|w| ∈ S⁶, γ = |w| > 0, σ = re(s), so s = σ + γv: ζ_𝕆(s) := φ_v(ζ_ℂ*(σ + iγ));
(ii) for s ∈ ℝ∖{1}: ζ_𝕆(s) := ζ_ℂ*(s) = ζ(s) ∈ ℝ; (iii) for s = 1 (the simple pole…):
ζ_𝕆(1) := ∞ = N; (iv) for s = ∞ = N: ζ_𝕆(∞) := ζ_ℂ*(∞) = 1."
(\uses{def:zeta-Cstar, def:slices, thm:extension})

Lean shape — the `Octonion.exp` precedent (Toolkit.lean:47, PROVED pattern) is the exact
template; the slice display via the junk-robust `dir`/`sliceCoord` conventions of
Slice.lean:
```lean
def zetaO : OnePoint Octonion → OnePoint Octonion
-- finite non-pole s: sliceEmbed (dir s) ∘ (zetaC value at sliceCoord s), with the
-- pole case (s = 1) ↦ ∞ and ∞ ↦ some 1; the real case collapses by the junk-robust
-- convention exactly as Octonion.exp does (dir = 0 ⇒ ofReal)
```
Stock: `sliceEmbed`, `sliceCoord`, `dir`, `unitImaginarySphere` (Slice.lean, in use);
`OnePoint Octonion` (TwoWorlds H1 objects). New: the pole/∞ case split over `OnePoint`.

### B2 — `prop:well-defined`

MASTER (verbatim, statement): "ζ_𝕆 : 𝕆* → 𝕆* is well-defined." — content: the φ_{±v}
ambiguity cancels by conjugate symmetry (ζ_ℂ*(σ − iγ) = conj ζ_ℂ*(σ + iγ)).
(\uses{def:zeta_O, thm:riemann})

Lean shape: in the `dir`/`sliceCoord` encoding the canonical representative is fixed, so
well-definedness renders as the slice display law (the `exp_sliceEmbed'` pattern,
Toolkit.lean:117):
```lean
theorem zetaO_sliceEmbed {v} (hv : v ∈ unitImaginarySphere) (ζ : ℂ) :
    zetaO (sliceEmbed v ζ) = <sliceEmbed v (zetaC ζ)>   -- both half-planes; conj symmetry
```
Consumes: conjugate symmetry of ζ (A3 pin). This is where it enters, once.

### B3 — `thm:zeta-in-R`

MASTER (verbatim): "ζ_𝕆 ∈ 𝓡." — proof route: ζ_𝕆|_{ℂ_v*} = φ_v ∘ ζ_ℂ* ∘ φ_v⁻¹ slicewise
holomorphic away from the pole; equivalently ζ_𝕆 = ext(ζ) (thm:extension, CSS12
Thm 5.1.5); slice preserving by thm:slice-pres; sections of 𝓡 = slice-regular
slice-preserving maps 𝕆* → 𝕆* (def:R). (\uses{thm:slice-pres, thm:extension, def:R,
prop:well-defined})

Lean shape: the typing package on `zetaO` — slicewise display (B2) + slice preservation
(values land in the same slice: `re`/`im` computation over `sliceEmbed`) + the intrinsic
stem read-off (`IsIntrinsic riemannZeta` at stem level — conjugate symmetry again, one
consumption point). The slice-REGULARITY clause at the octonionic layer rides the same
sorried-cone conventions as `Octonion.exp`'s display pins (R8; the slice-analytic layer's
queued rows) — statement lands, cites CSS12 Thm 5.1.5 verbatim in the docstring, closes
with that layer. NOT a blocker for the corollaries: `cor:zeta-section`'s Lean instance
consumes the stem-level `intrinsic`/`meromorphic` fields (ASection), which close from
Mathlib pins; B3 is the octonionic face of the same content.

### B4 — `thm:G2-equiv` (+ `rmk:G2-compact`)

MASTER (verbatim): "ζ_𝕆(g·s) = g·ζ_𝕆(s) for all g ∈ G₂, s ∈ 𝕆." (\uses{def:G2,
def:zeta_O}) — with `rmk:G2-compact` extending the action to 𝕆* = S⁸ fixing ℝ ∪ {∞}
pointwise ("in Lean, OnePoint" — the master's own pointer).

Lean shape: `zetaO (g • s) = g • zetaO s` over the G2.lean action (orbit transitivity
`exists_smul_eq_of_mem_unitImaginarySphere` PROVED there; the relabelling law
g ∘ φ_v = φ_{g(v)} is the `sliceEmbed`/automorphism computation). Feeds B6(i).

### B5 — `thm:zero-equivalence` (the bridge)

MASTER (verbatim): "Let ρ = σ + iγ ∈ ℂ*. For every v ∈ S⁶, ζ_𝕆(σ + γv) = 0 ⟺
ζ_ℂ*(ρ) = 0. Equivalently: a non-real s ∈ 𝕆* is a zero of ζ_𝕆 if and only if its slice
coordinate φ_v⁻¹(s) is a zero of ζ_ℂ*; by Lemma lem:zero-Cstar these are exactly the
nontrivial zeros of the classical ζ." (\uses{def:zeta_O, thm:slice-pres, lem:zero-Cstar})

Lean shape: through B2's display + `sliceEmbed` sends 0 ↦ 0 injectively on a slice
(Slice.lean norm computations, PROVED stock):
```lean
theorem zetaO_zero_iff {v} (hv : v ∈ unitImaginarySphere) (σ γ : ℝ) (hγ : 0 < γ) :
    zetaO (sliceEmbed v ⟨σ, γ⟩) = 0 ↔ riemannZeta ⟨σ, γ⟩ = 0
```
This is THE crossing point: every classical fact consumed downstream about zeros crosses
here, nowhere else.

### B6 — `thm:zero-spheres` (residue dictionary, 6-sphere geometry)

MASTER (verbatim, abridged to the four clauses): "For a nontrivial zero ρ = σ + iγ of
ζ_ℂ* (so γ > 0) set S_ρ = {σ + γv : v ∈ S⁶} = σ + γ·S⁶ ⊂ 𝕆. Then: (i) S_ρ is a 6-sphere
— the round sphere of radius γ centred at the real point σ — equivalently the G₂-orbit of
any one of its points (thm:G2-equiv; thm:G2-S6, Baez); (ii) every point of S_ρ is a zero
of ζ_𝕆, and conjugate zeros give the same sphere, S_ρ = S_ρ̄; (iii) the nontrivial-zero
set is the disjoint union Z^nt_𝕆* = ⊔_{[ρ]} S_ρ over conjugate pairs, with distinct pairs
giving disjoint spheres; (iv) there are infinitely many such spheres
(cor:hadamard-infinitude; also Hardy)." (\uses{thm:zero-equivalence, thm:G2-S6,
thm:G2-equiv, cor:hadamard-infinitude})

Lean shape: `def zeroSphere (σ γ : ℝ) : Set Octonion := (fun v => sliceEmbed v ⟨σ, γ⟩) ''
unitImaginarySphere` (the DESIGN_translations #1-octonionic sketch, now first-class, not
deferred); (i) = G₂-orbit realization (`exists_smul_eq_…` PROVED + B4); (ii) = B5;
(iii) = re/im uniqueness over `sliceEmbed` (Slice.lean stock); (iv) =
`riemannZeta_nontrivialZeros_infinite` (PROVED) through B5.

### B7 — `thm:rh-equiv`

MASTER (verbatim): "The following are equivalent: (a) the Riemann Hypothesis; (b) the
nontrivial-zero 6-spheres {S_ρ} of ζ_𝕆 (Theorem thm:zero-spheres) are concentric — they
share a single common centre, necessarily a point of the real axis. When they hold, the
common centre is ½." (\uses{thm:zero-spheres, thm:riemann})

Lean shape: over B6's `zeroSphere` with centre read-off σ; (b) ⇒ (a) consumes the FE pin
(A3) — the ONLY place ½ enters, per `rmk:half-downstream`. Placement-free as a theorem
(it's an iff; neither side is asserted).

## §3 — Island inventory, the corollaries (consume islands; the only placement-gated rows)

### C1 — `cor:zeta-section` (\uses{def:A-section, thm:zeta-in-R, thm:riemann, thm:euler, cor:hadamard-infinitude, prop:weierstrass, thm:zero-spheres})

MASTER (verbatim): "ζ_𝕆 is an A-section (Definition def:A-section): a section of 𝓡
satisfying (C1)–(C4)." — with the proof's field-by-field citation of Part-1 facts and the
residue dictionary, and the pole factor "(q−1)ζ_𝕆 = q^m R e^g ∏_n 𝓔(·;q_n) (pole factor
at p₀ = 1; classically, Hadamard factors (s−1)ζ(s))", m = 0 (ζ(0) = −½ ≠ 0).

Lean shape: `zetaSection : ASection` per the DESIGN_translations field table (which
stays correct AT STEM LEVEL: F := riemannZeta is the stem of ζ_𝕆), now explicitly welded
to the octonionic member by B1–B6 (the docstring cites the islands, and the octonionic
face is `sectionFunctor zetaSection` + `zetaO` with B3). Fields land sorried, close
cheapest-first, one commit per field/group, Mathlib pin per docstring (R5). Expected
heavy: `c2_euler`/`c2_summable` (Euler cluster coverage), `c3_multipliable`/
`c3_factorization` (Hadamard — §4 Q1 governs the route). `c3_lowerEdge` = the classical
strip bound (member-private; Re = 1 nonvanishing is in Mathlib, reflected by the FE).
`c4_infinite` closes from `riemannZeta_nontrivialZeros_infinite` through the enumeration
(`Set.Infinite.natEmbedding` route). `valueAtInfinity := 1` = A1's ζ_ℂ*(∞) = 1.

### C2 — `cor:nontrivial` (\uses{thm:concentricity, thm:connected-concentric, thm:zero-equivalence, thm:zero-spheres, lem:residue-spheres})

MASTER (verbatim): "Identifying residue-ℂ zeros with the classically nontrivial zeros,
and residue-ℝ zeros with the trivial ones (Part 2), such a section has its nontrivial
zeros realised as infinitely many pairwise disjoint concentric 6-spheres about a single
real centre."

Lean: consumes the locked `concentricity_transport`'s static translation — i.e.
`placement_set` (the one open node) through the proved welds. LANDS GATED (its
`#print axioms` shows `sorryAx` until the bricks close); never reported as proved.

### C3 — `cor:rh` (\uses{cor:zeta-section, thm:concentricity, cor:nontrivial, thm:rh-equiv})

MASTER (verbatim): "Every nontrivial zero of the classical Riemann zeta function has real
part ½; in particular infinitely many zeros lie on the line Re s = ½."

Lean: the DESIGN_translations §#5 shape (statement unchanged), assembled from C1 + C2 +
B7 + B5. GATED by `placement_set` and C1's field closure; both stated on landing.

## §3.5 — Island P: the One-Hyperplane Theorem (the level-content island)

**Name** (author's curation, 2026-07-05): the **One-Hyperplane Theorem** — all upper-half
stem zeros lie in a single hyperplane {Re = c}. Naming fences honored (author's register
rulings): no "concentric" (downstream metric gloss, `rmk:concentric-gloss`), no "connect"
(that word belongs to the theorem at N), member-free. Master anchor label:
`eq:placement-set` (unchanged underneath). Lean rows: `placement_set`
(PlacementSet.lean:46) ≡ `transportLevel_placement` (Theorem.lean:213), one node via the
proved weld `placement_set_iff`. Lean rename/alias deferred to the cleanup juncture.

MASTER (verbatim, `eq:placement-set`): "A_I(z) = A_I(w) = 0, Im z > 0, Im w > 0 ⟹
Re z = Re w  (z, w ∈ ℂ_I)."

**Character:** the ONLY island containing open mathematics; everything else in this plan
is classical bookkeeping or proved. It is NOT a translation (the translations are proved
iffs — the dictionary `thm:connected-concentric`, the welds); it is the substantive feed
the translations wait for. NOT derivable from the locked theorem: Pin 2 (PROVED) shows the
populated object separates no levels, and the 0.3/0.7 litmus shows any placement-free
chain to "one centre" would conclude 0.3 = 0.7. The dictionary converts it into centre
language; it cannot manufacture it (`zigzag_iff_level`, proved both directions: one STATIC
component IS the level equality, definitionally welded).

**Consumed by:** C2 (`cor:nontrivial`), and through it C3 (`cor:rh`) — nothing else;
no Part-1/Part-2 island touches it.

**Routes (both the author's):**
- **P-route 1 — the two-index bricks** (`rmk:two-index-roadmap`;
  PLAN_two_index_bricks.md + DESIGN_B2_2_kernels.md): Brick 1 (`stem_identity_logDeriv`)
  PROVED; B2.1 residue ledger PROVED; open = B2.2 pairing + the closing clause. The
  master's honest endpoint stands: the clause "either derives from C1–C4 or stands as a
  named additional property of the member under study."
- **P-route 2 — the preimage-at-N argument** (author, 2026-07-05 evening; design to be
  drafted in dialogue): shrinking neighborhoods of N in the slice spheres S²_I; the pole
  approach s → 1; Euler + Weierstrass-through-the-pole + the τ relation at the shared
  preimage. New ingredients relative to the prior renders (whose R6 records at
  KeystoneAssembly.lean:75 and KeystoneFinality.lean:118 are the wall any render must get
  through): the pole approach and the shrinking preimage neighborhoods. The design must
  state what the shared preimage at N witnesses BEYOND the component — how the
  second-order (level) datum survives arrival at the point where all hyperplanes meet
  (SCAN §7: closeness to N is first-order and level-blind; the level is the second-order
  coefficient, `inv_re_bridge`).

- **P-route 3 — the contradiction render** (author's proposition, 2026-07-05 night,
  verbatim): "An A-section has one hyperplane. Proof. Suppose not. Then A has two
  different base objects B_1, B_2 over different great circles. Hence, the A section is
  disconnected. Contradiction to concentricity theorem. Hence A section has one
  hyperplane." Rendered clause-by-clause in `Concentricity/OneHyperplaneRoute.lean`
  (unimported working artifact; lake decides): clauses (a)–(c) — the supposition, the two
  distinct base objects, the static disconnection across distinct levels — PROVED; the
  contradiction clause (d) is the recorded seam (see the file's R6 receipt).

**EXAMINATION DEFERRED (author, 2026-07-05 night):** after routes 3/3′ (rendered,
R6 records + the TwoNorth receipts in OneHyperplaneRoute.lean), the author's position:
𝒯^𝔫 is not the object of record — the A-SECTION is; the hypothesis is the A-section has
two real hyperplanes; what is actually needed is a concentricity statement about the S⁶
zero-spheres themselves; a quick argument directly on the A-section is suspected. Ruling:
push Island P aside, close ALL other islands first (with the zero-sphere theorem B6 in
view), then return. Lane A invited to think in parallel in the meantime.

**AUTHOR'S STANDING RESERVATION (2026-07-05 evening — recorded, UNRESOLVED):** the author
suspects the picture is simpler than Island P as framed: with each residue-ℂ zero
6-sphere its own closed point / connected object (`thm:zero-spheres`(i)–(ii), the AdF
residue dictionary), a DIRECT translation theorem "connected → concentric" should carry
the concentricity theorem to the geometric statement — "a more direct route from what the
A-section did (connecting levels), the geometric concentricity, and the other proved
half" — possibly making a separate hyperplane node unnecessary. To be re-examined FIRST
in the next design dialogue (before or alongside P-route 2): render the proposed direct
route precisely and locate, against the machine-checked welds (Pin 2, `zigzag_iff_level`,
the 0.3/0.7 litmus), either (a) the new content that discharges P, or (b) the exact goal
where the route lands on P. No prose verdicts; lake decides. Until then Island P stands
as the address of record and nothing consumes it silently.

## §4 — The DAG and the no-circularity pin

```
A1 → A2 → ┐
A3 (pins) → B1 → B2 → B3
            B1 → B4 ──┐
            B2 → B5 → B6 → B7
A3(infinitude, PROVED) ↗
[locked thm + placement_set] → C2
A3 + B* → C1;   C1 + C2 + B5 + B7 → C3
```
No island consumes a corollary; no Part-1/Part-2 island consumes `placement_set` or
`thm:concentricity`; ½ appears in B7((b)⇒(a)) and C3 only; zeros are output, never input
(R4) — the bricks toward `placement_set` (PLAN_two_index_bricks.md, unchanged) are the
only open mathematics and gate C2/C3 alone.

Author inputs — RESOLVED in dialogue (2026-07-05 evening):
- **Q1 (Hadamard):** no external formalization to wire; the R5 sweep REPORTS coverage
  (Mathlib + the in-repo ZetaInfinitude stock) before anything closes; any gap is an
  R6-stop decided in dialogue. "We should make sure Lean has what we need" (author).
- **Q2 (Hardy):** NO Lean row of any kind — not an axiom, not a sorry, nothing (the
  project is 0 axioms). Load-bearing nowhere in the DAG; the prose mention stays in the
  master. Governing principle (author): formalize exactly what qualifies ζ_𝕆 as an
  A-section, nothing more.
- **Q3 (layout):** confirmed as proposed (ZetaCstar / ZetaOctonion / ZeroSpheres /
  ZetaSection / Corollaries).

## §5 — The runway (author's revised sequence, replaces OPENER's H1–#5 ordering)

1. **Delineate** — this document, confirmed in dialogue. (Juncture ①: directional docs
   updated per §6.)
2. **Net-0 the islands, one at a time, no circularity** — order: A1 → A2 → R5 sweep for
   A3 pins (coverage REPORTED before anything closes) → B1 → B2 → B3 → B4 → B5 → B6 →
   B7 → C1 fields (cheapest-first) → C2, C3 landed GATED. Bricks toward `placement_set`
   run in parallel throughout — the long pole; C2/C3 close only when they do. Per commit:
   hash · files · imported-root ledger · `#print axioms` per newly closed row.
3. **Cleanup on green** — H2 attic, H3 docstring scrub (timeless voice), H4 line (ruling
   (i) pending), blueprint rebuild. Only after the repo is fully green.
4. **Prose/webpage** — the author curates paragraphs (microhistory voice; paper to be
   dropped in `inbox/`); blueprint site is the human face.
5. **The push and the announcement** — full careful push of everything (push currently
   DEFERRED, main ahead of origin); then the announcement of the concentricity theorem
   and its corollaries with certificates, at project-wide 0/0 and not before (the
   announcement gate; landed-gated rows are never "proved" before it).

## §6 — Juncture Protocol (directional docs; author's standing instruction 2026-07-05)

At EVERY phase boundary (juncture), before the phase's closing commit:
1. `lake build` green + ledger snapshot (imported-root sorries/axioms + certificates).
2. **HANDOFF.md** — replaced (never appended) to carry only the current task.
3. **OPENER_next_threads.md** — refreshed lane instructions.
4. **CLAUDE.md** — Phase section updated; any stale architecture/rules lines corrected
   (currently stale after this re-scope: the Phase list (statement-layer era), the "one
   open item: the placement sentence red \TODO" line (the node moved to
   `eq:placement-set` / translation layer), and the absence of the locked
   `concentricity_transport` carrier from "Sources of truth"). Proposed diff drafted at
   juncture ①, author-reviewed before landing (CLAUDE.md is the constitution).
5. Superseded PLAN/DESIGN docs → `archive/` with dated supersession banners
   (at juncture ①: DESIGN_translations.md gains a banner pointing here — its #4/#5
   statements and #3 field table remain the approved stem-level shapes; its #3 FRAMING is
   superseded by §0).
6. Commit the juncture record (docs + ledger), then open the next phase.
