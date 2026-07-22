> ## RETIRED - PRE-REBUILD MATERIAL, NOT CURRENT (marked 2026-07-20)
>
> This file sits in a retired directory and predates the projective rebuild. It may describe
> objects, bases, functors, and file locations that no longer exist.
>
> **Known stale across this material:**
> - The `cayleyProjective` / generic-Moebius route and the `Hypothesis A (_D)` cargo-as-fields
>   pattern are **SUPERSEDED**. Cargo is not attached to the action; it IS the action. The
>   A-determined Euler/Weierstrass pole action is carried by `stabilizerPart` via orbit-stabilizer.
> - **Deleted modules:** AFunctor, TwoWorlds, PhiConversion, Recovery, ConnectedBase, InboxWire,
>   SynthesisE6, IntegrateTheorem, NormalizedCone, NormalizedNLeg, Base, TransportObject,
>   FaithfulApply, KeystoneAssembly, KeystoneFinality, RecoveryAudit. Their facts were rehomed,
>   largely into ProjectiveCargo / ProjectiveTransport.
> - **Every file:line citation here is unreliable.** Resolve names against the live tree only.
> - Any `rho`/`V_RHO`, `el(V)`, `Disc R`, per-zero `Z_n -> N` leg, generic action record, or
>   parameterized carrier appearing below is a retired substitution, not the construction.
>
> **Current and authoritative:** `PROOF_OUTLINE_LOCKED.md` and
> `BOARD_LECTURE_CONCENTRICITY_2026-07-17.md` (the author own), plus `RESUME_2026-07-20.md`
> for live state.
>
> **Do not take construction, architecture, or status from this file.**

# PROOF PLAN — `riemannZeta_nontrivialZeros_infinite` (plan only; no code)

Per the ruling of 2026-07-03 (HANDOFF.md carries it): the Hadamard-infinitude fact is a
**sorried theorem, proved in-repo** — never an axiom. Gate: zero sorries + zero project
axioms. This file itemizes the proof for approval; **no lemma lands until the itemization
is approved** (author's order of work, item 1).

## Target statement (verbatim from the ruling)

```lean
theorem riemannZeta_nontrivialZeros_infinite :
    {s : ℂ | riemannZeta s = 0 ∧ (¬∃ n : ℕ, s = -2 * (n + 1)) ∧ s ≠ 1}.Infinite :=
  sorry
```

Note: the nontriviality predicate `s = -2 * (n + 1)` matches Mathlib's trivial-zero lemma
verbatim (`riemannZeta_neg_two_mul_nat_add_one : riemannZeta (-2 * (n + 1)) = 0`,
RiemannZeta.lean:171 in the pinned v4.31.0).

## Verification legend

- **PRESENT** — declaration exists in the pinned Mathlib (v4.31.0, `.lake/packages/mathlib`),
  verified by grep 2026-07-02/03, with file:line.
- **ASSEMBLE** — all ingredients present; glue lemma to write in-repo.
- **ABSENT** — theory to build in-repo; estimate given.
- **VERIFY-AT-BUILD** — name believed present, exact form to confirm when the lemma lands
  (R5: the failing goal, not prose, arbitrates).

---

## Route A — the cheap route (ruling's sketch): finitely many zeros ⇒ contradiction

Shape: suppose the nontrivial-zero set `Z` is finite. Write
`ξ s := s * (s - 1) * completedRiemannZeta s` (entire; zeros = exactly `Z`). Extract the
finite zero divisor: `ξ = P · h` with `P` the finite factorized rational and `h` entire
nonvanishing; take a global logarithm `h = exp ∘ g`; bound `|ξ|` by `exp(C·R·log R)` on
big circles from the Mellin/theta representation + the unconditional functional equation;
Borel–Carathéodory turns the resulting bound on `Re g` into `|g| = O(R log R)`, so Cauchy
estimates force `g` affine (`g = a + b·s`); then along real `σ → ∞`, Γ-growth in
`ξ(σ) = σ(σ-1)π^{-σ/2}Γ(σ/2)ζ(σ)` beats `|P(σ)·e^{a+bσ}|` — contradiction.

| # | lemma (working name) | statement sketch | pin-present ingredients | est. lines |
|---|---|---|---|---|
| A1 | `xi` + `xi_entire` | `ξ s = s*(s-1)*completedRiemannZeta s` extends entire | `completedRiemannZeta₀` def (RiemannZeta.lean:63), `differentiable_completedZeta₀` (:89), Λ/Λ₀ relation (VERIFY-AT-BUILD: exact `completedRiemannZeta_eq` form) | 40–80 |
| A2 | `xi_zeros_eq_nontrivialZeros` | zeros of `ξ` = the target set | `Complex.Gamma_ne_zero` (VERIFY-AT-BUILD; real version Gamma/Basic.lean:490), `riemannZeta_ne_zero_of_one_lt_re` (Dirichlet.lean:326), `riemannZeta_ne_zero_of_one_le_re` (Nonvanishing.lean), FE `riemannZeta_one_sub` (RiemannZeta.lean:176), trivial zeros (:171), Γ-pole bookkeeping | 150–250 |
| A3 | `xi_factorization_of_finite` | `Z` finite ⇒ `ξ = (∏ᶠ (·-u)^(divisor ξ u)) • h`, `h` entire nonvanishing, **everywhere** (upgrade from codiscrete equality by continuity/identity) | **PRESENT**: `MeromorphicOn.extract_zeros_poles` (Meromorphic/FactorizedRational.lean:291); identity-theorem upgrade ASSEMBLE | 80–150 |
| A4 | `exists_log_of_entire_nonvanishing` | `h` entire, nowhere 0 ⇒ `∃ g` entire, `h = exp ∘ g` | ASSEMBLE: `isCoveringMap_exp` (Complex/CoveringMap.lean:40) + simply-connected lifting; holomorphy of the lift from local sections. Alternative: primitive of `h'/h` (VERIFY-AT-BUILD: primitive-existence on ℂ) | 60–150 |
| A5 | `completedZeta₀_growth` | `‖completedRiemannZeta₀ s‖ ≤ exp (C * ‖s‖ * log ‖s‖)` for `‖s‖` large | the Mellin/theta rep behind the definition: `WeakFEPair.hasMellin`, `differentiable_Λ₀`, `functional_equation₀` (AbstractFuncEq.lean:200–429; `completedRiemannZeta₀ = completedHurwitzZetaEven₀ 0`); growth NOT exposed as a lemma — derive from the integral rep's decay hypotheses. **Priciest analytic block of Route A** | 200–400 |
| A6 | `xi_growth` | same bound for `ξ` | A1 + A5, polynomial prefactor absorbed | 20–40 |
| A7 | `log_factor_growth` | `Re g ≤ C·R·log R` on `‖s‖ = R` ⇒ `‖g‖ ≤ C'·R·log R` on `‖s‖ = R/2` | **PRESENT**: `borelCaratheodory`, `borelCaratheodory_zero` (Complex/BorelCaratheodory.lean:86,109); `log‖P‖` lower bound elementary | 80–150 |
| A8 | `affine_of_subquadratic_growth` | entire `g`, `‖g‖ = O(R log R)` ⇒ `g = a + b·s` | Cauchy coefficient estimates (VERIFY-AT-BUILD: `cauchyPowerSeries` norm bound name in Complex/CauchyIntegral.lean); Liouville pattern | 80–150 |
| A9 | `gamma_lower_bound_real` | `Γ(σ/2) ≥ exp(c·σ·log σ)` along reals (or along `σ = 2n`) | `Real.Gamma_nat_eq_factorial` (Gamma/Basic.lean:34), factorial lower bounds; ζ(σ) → 1 or ζ(σ) ≥ 1 for real σ > 1 (small derive from the series; `riemannZeta_eulerProduct_exp_log`, DirichletLSeries.lean:160, available if useful) | 40–80 |
| A10 | `riemannZeta_nontrivialZeros_infinite` | assemble: finite ⇒ A3–A8 give `ξ = P·e^{a+bs}` ⇒ A9 contradiction; conclude via A2 | glue | 60–120 |

**Route A total: ~750–1500 lines**, no new theory files; every named external ingredient is
in the pinned Mathlib now.

## Route B — the standard order-1 route (for comparison)

Prove `ξ` entire of order ≤ 1 (same growth block A5/A6), build Hadamard factorization for
order-≤1 entire functions, conclude: finitely many zeros would make `ξ = P·e^{a+bs}`,
same contradiction A9/A10.

| block | status | est. lines |
|---|---|---|
| A1, A2, A5, A6, A9, A10 (shared) | as above | 500–970 |
| Jensen's formula | **PRESENT** — Complex/JensenFormula.lean (new in the pin; already consumes `extract_zeros_poles`) | 0 |
| zero-counting from Jensen (`N(R) = O(R log R)`), exponent of convergence ≤ 1 | ABSENT | 200–400 |
| genus-1 canonical products (Weierstrass `E₁` factors, convergence, growth) | ABSENT | 500–900 |
| Hadamard factorization theorem, order ≤ 1 | ABSENT | 400–700 |
| specialization to finite zero set | trivial once the theorem exists | 50 |

**Route B total: ~1650–3000 lines.** Reusable theory (canonical products, Hadamard) —
upstreamable to Mathlib as self-justifying pieces; Mathlib's ValueDistribution +
JensenFormula clusters are visibly growing toward it, so part may land upstream on its own
schedule.

## Comparison

- Route A is Hadamard **specialized to the finite case**, where `extract_zeros_poles` +
  Borel–Carathéodory replace the entire canonical-product apparatus. Roughly half the
  lines, no new theory files, all external names already in the pin.
- Route B builds the general theorem; ~2× the cost; the surplus is exactly the
  upstreamable part.
- Shared risk either way: **A5** (the growth bound) — it is the one genuinely analytic
  block, and it is needed by both routes. A2 (the zero-set dictionary) is bookkeeping-heavy
  but elementary.
- The old axiom docstring priced deletion at ~2,000–4,000 lines; Route A undercuts that
  because `extract_zeros_poles`, `borelCaratheodory`, and `JensenFormula` have since
  landed in Mathlib.

## Consequences already recorded (from the ruling)

- No axiom docstring ⇒ no verbatim Titchmarsh excerpt required anywhere in the Lean.
  Titchmarsh86 remains in the master's bibliography as an ordinary reference —
  provenance, never load.
- Lane discipline: statement layer (ASection first, stop at the placement TODO) is the
  primary lane; these lemmas are the second lane, **one commit per lemma on green, only
  after this plan is approved**.

*STOP point per the ruling: nothing below A1 lands until the author approves this
itemization.*
