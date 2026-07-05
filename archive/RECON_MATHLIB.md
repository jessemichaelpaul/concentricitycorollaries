# RECON — Mathlib live-docs reconnaissance (R5), six items

*Date: 2026-07-02. Method: Loogle name-search (loogle.lean-lang.org) + mathlib4_docs module
pages + web check. Mathlib snapshot: docs served from commit `564ff5af` (visible in ZetaZeros
source links). Report only — no code. Each verdict: exists / partial / absent, declaration
names verbatim, price if absent. Cross-check target: Step 2's recon in the Code tab should
reproduce this; discrepancies = docs moved or a name was missed, resolve against live docs.*

---

## (a) Octonions / Cayley–Dickson — **ABSENT**

- Loogle `"Octonion"`: **0 declarations**. Loogle `"CayleyDickson"`: **0 declarations**.
- Substrate that DOES exist: `Quaternion` (Mathlib's ℍ, with norm, star, algebra structure).
- **Price:** in-repo construction per R9 — `CD(ℍ)` doubling over Mathlib's ℍ: carrier
  `ℍ × ℍ`, multiplication `(a,b)(c,d) = (ac − d*b, da + bc*)`, star `(a,b)* = (a*, −b)`,
  ℝ-algebra instance, norm and its multiplicativity, the 6-sphere of imaginary units.
  Self-contained; no analytic content. `G₂ := AlgAut(𝕆)` defined on top of it.

## (b) riemannZeta cluster — **EXISTS (rich)**

Modules: `Mathlib.NumberTheory.LSeries.{RiemannZeta, Dirichlet, Nonvanishing, ZetaZeros}`,
`Mathlib.NumberTheory.EulerProduct.DirichletLSeries`. (Literature companion: Stoll et al.,
"Formalizing zeta and L-functions in Lean", arXiv:2503.00959 — describes this cluster.)

- **Continuation:** `riemannZeta`, `analyticOn_riemannZeta : AnalyticOnNhd ℂ riemannZeta {1}ᶜ`,
  `differentiableAt_riemannZeta`, `differentiableOn_riemannZeta`.
- **Pole:** `riemannZeta_residue_one : Tendsto (fun s => (s-1) * riemannZeta s) (𝓝[≠] 1) (𝓝 1)`
  (and `completedRiemannZeta_residue_one`).
- **Functional equation:** `completedRiemannZeta_one_sub : Λ(1−s) = Λ(s)`,
  `completedRiemannZeta₀_one_sub`, asymmetric form `riemannZeta_one_sub`.
- **Euler product:** `riemannZeta_eulerProduct` (partial products), `riemannZeta_eulerProduct_tprod`
  (∏′ form), `riemannZeta_eulerProduct_hasProd`, and
  `riemannZeta_eulerProduct_exp_log : exp (∑' p, −log(1 − p^(−s))) = ζ(s)` for `1 < re s` —
  **this is exactly the C2 shape** (A = exp(Σₚ ℓₚ) on the half-space).
- **Zero-free half-plane:** `riemannZeta_ne_zero_of_one_lt_re`, and the closed version
  `riemannZeta_ne_zero_of_one_le_re` (re ≥ 1).
- **Trivial zeros:** `riemannZeta_neg_two_mul_nat_add_one : ζ(−2(n+1)) = 0`.
- **Formal RH statement exists in Mathlib:** `RiemannHypothesis : Prop`
  (module `Mathlib.NumberTheory.LSeries.RiemannZeta`) — `cor:rh`'s Lean statement should be
  literally this declaration (or proved equivalent to it), which maximizes external legibility.
- **Price:** ≈ 0 for the classical ℂ-side inputs to ζ_𝕆's C1/C2.

## (c) Hadamard factorization / infinitude of nontrivial zeros — **ABSENT (both)**

- Loogle `"Hadamard"` (118 hits): all are matrix Hadamard products
  (`Matrix.hadamard`), Hadamard **three-lines** theorem
  (`Complex.HadamardThreeLines.*`, module `Mathlib.Analysis.Complex.Hadamard`), and Hadamard
  matrices (`Matrix.IsHadamard`). **No entire-function factorization.**
- Infinitude of nontrivial zeros: no declaration found. What DOES exist (new module,
  useful substrate): `Mathlib.NumberTheory.LSeries.ZetaZeros` —
  `riemannZetaZeros : Set ℂ`, `mem_riemannZetaZeros`, `isClosed_riemannZetaZeros`,
  `isDiscrete_riemannZetaZeros`, `IsCompact.inter_riemannZetaZeros_finite`,
  `tendsto_riemannZeta_cofinite_cocompact`. Discreteness/finiteness-on-compacts only —
  **no existence or infinitude statement**.
- **Price:** this is the Hadamard-infinitude leaf of the working floor. Two routes:
  (i) burn down = build order-1 growth for `completedRiemannZeta₀` + Hadamard factorization
  in-repo — the largest single analytic build on the list; (ii) retain as the cited axiom
  leaf (docstring carries the verbatim source + price of deletion, per R9 addendum).
  Adjacent (NOT Mathlib): the PrimeNumberTheoremAnd project has zeta-zero material;
  worth a look during SOURCES pass, but nothing importable as a Mathlib name today.

## (d) Complex.exp as covering map + lifting API — **EXISTS (near-free, as priced)**

- `Complex.isCoveringMap_exp : IsCoveringMap fun z => ⟨exp z, _⟩` (exp : ℂ → ℂ∖{0}),
  module `Mathlib.Analysis.Complex.CoveringMap`. Also `Circle.isCoveringMap_exp`
  (module `Mathlib.Analysis.SpecialFunctions.Complex.Circle`).
- Lifting API, module `Mathlib.Topology.Homotopy.Lifting`:
  `IsCoveringMap.liftPath` (+ `liftPath_zero`, `liftPath_lifts`, `liftPath_trans`,
  `liftPath_const`), `IsCoveringMap.liftHomotopy` (docstring: homotopy lifting property,
  "a covering map is a Hurewicz fibration. Proposition 1.30 of [hatcher02]"),
  `IsCoveringMap.liftHomotopyRel`, `IsCoveringMap.liftPathQuotient`,
  `IsCoveringMap.monodromy`, and
  `IsCoveringMap.liftPath_apply_one_eq_of_homotopicRel` (endpoint invariance under
  rel-{0,1} homotopy — the endpoint/winding readout).
- **Price:** confirms the delta's pricing — if the placement runs slice-wise, the lifting
  floor is Mathlib-native; GPV ambient tame/signature machinery cited for context and
  faithfulness only.

## (e) Weierstrass products for entire functions — **ABSENT as general theory**

- Loogle `"Weierstrass"`: every hit is `Mathlib.AlgebraicGeometry.EllipticCurve.Weierstrass`
  (Weierstrass curves — unrelated). No elementary factors 𝓔(·;q), no general factorization
  theorem, no canonical-product theory.
- Working precedents (instances of ∏(1 + aₙ) machinery in anger):
  `multipliable_sineTerm` (module `Mathlib.Analysis.SpecialFunctions.Trigonometric.Cotangent`),
  `ModularForm.multipliable_one_sub_pow` (Dedekind eta, `‖q‖ < 1 → Multipliable (1 − q^(n+1))`).
- **Price:** define the elementary factors stem-wise in-repo and prove convergence with (f)'s
  toolkit; this is the Mathlib substrate for the AdF-factorization leaf (C3). Product
  machinery: free. Factorization theorem over the stems: ours to prove, or the leaf stays
  cited per R9 addendum.

## (f) Infinite products (Multipliable / tprod) for C2 — **EXISTS (rich)**

- Core: `Multipliable`, `HasProd`, `∏'` (tprod), modules
  `Mathlib.Topology.Algebra.InfiniteSum.{Defs, Basic, Group, Ring, NatInt, Order, …}`.
- **API caveat for the statement layer:** signatures now carry a `SummationFilter` parameter
  (`Multipliable f L`, `∏'[L]`) — a recent generalization. Pin the default (unconditional /
  atTop) form when stating C2/C3; `tprod_eq_of_multipliable_unconditional` bridges.
- Key C2/C3 bridges, module `Mathlib.Analysis.SpecialFunctions.Log.Summable`:
  `Complex.multipliable_of_summable_log : Summable (log ∘ f) → Multipliable f`,
  `Complex.multipliable_one_add_of_summable`,
  `multipliable_one_add_of_summable` (complete normed ring),
  `multipliable_norm_one_add_of_summable_norm`.
- Also: Cauchy criterion `multipliable_iff_cauchySeq_finset`;
  `multipliable_one_add_of_summable_prod` (semiring form);
  `Multipliable f ↔ …` congruence/cofinite lemmas for tail arguments.
- **Price:** ≈ 0. Summable slice-preserving families in C2 land directly on
  `Complex.multipliable_of_summable_log` at stem level.

---

## Bottom line vs the working floor (target 0–4, aspiration 0)

| Leaf | Mathlib today | Burn-down price |
|---|---|---|
| AdF factorization (C3) | substrate: (e) precedents + (f) toolkit | elementary factors + factorization over stems, in-repo |
| GPV Cor 5.13 (+5.21) | (d) covering + lifting + monodromy native | near-free slice-wise; GPV cited for faithfulness |
| G₂ transitivity on S⁶ | nothing (no 𝕆, no G₂) | build on CD(ℍ) from (a); classical, self-contained |
| Hadamard-infinitude (C4 for ζ_𝕆) | absent; ZetaZeros gives discreteness only | largest analytic build — likeliest to remain the cited leaf short-term |

Statement-layer notes: use Mathlib's `RiemannHypothesis : Prop` verbatim for `cor:rh`;
pin `SummationFilter` defaults in C2/C3; `riemannZeta_eulerProduct_exp_log` is the C2
witness for ζ on the ℂ side.

*Loogle queries used: "Octonion", "CayleyDickson", "riemannZeta", "isCoveringMap_exp",
"IsCoveringMap.lift", "RiemannHypothesis", "Hadamard", "Weierstrass", "multipliable_".*
