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

# DESIGN — the translation corollaries (Lane B, 2026-07-04)

> **SUPERSESSION BANNER (2026-07-05, juncture ① — see
> `PLAN_islands_part1_part2_2026-07-05.md`):** the FRAMING of §#2–#3 (classical ζ cited
> directly into the member's fields) is superseded by PLAN_islands §0 — the member is
> ζ_𝕆 (`def:zeta_O`); classical ζ lives on ℂ* (`def:zeta-Cstar`) and enters only over
> the Zero Equivalence bridge (`thm:zero-equivalence`). The statement SHAPES (#4, #5, and
> the #3 field table read at stem level) remain author-approved words. #1-octonionic is
> NO LONGER deferred — it is Island B6. The keystone/placement node is now **Island P,
> the One-Hyperplane Theorem** (PLAN_islands §3.5), with the author's standing
> reservation recorded there.

Register: design spec, words-before-commits. Shapes are SCHEMATIC; Lane A finalizes
hypotheses/names against the arbiter (R5 live checks flagged inline) and returns the
rendered statements for the author before landing. These are **logically independent**
of `thm:concentricity` — they attach AFTER the keystone (`transportLevel_placement`) is
green and **cannot destabilize the net-0 close**. They enter only to land ζ in `𝓡`, cite
classical facts to make it an A-section, and pin ½. No `def:A-section` change anywhere.

## Disambiguation — what is already in, what is master-only

**Already in Lean (proved / green):**
- `concentricity` (Theorem.lean:243) — one connected S⁶ / one component — proved modulo
  the keystone `transportLevel_placement`.
- the divisor bundle — `stem_zero_of_sphereZero`, `sphereZero_complete` (PlacementSet.lean)
  — this **is** `thm:zero-equivalence` at stem level: `{sphereZero n}` = the UHP zeros of
  the stem. (#1 stem-level = DONE.)
- `riemannZeta_nontrivialZeros_infinite` (ZetaInfinitude.lean) — C4's engine for ζ, proved,
  clean axiom triple.
- G₂ orbit transitivity `exists_smul_eq_of_mem_unitImaginarySphere` (G2.lean) — the
  6-sphere-as-orbit half of `thm:zero-spheres`.

**Master-only, to formalize (this doc):** `cor:nontrivial` (#4), `cor:rh` (#5), the ζ_𝕆
object and its C1–C3 fields → `cor:zeta-section` (#3), the octonionic 6-sphere geometry of
`thm:zero-spheres` (#1 octonionic layer), `thm:zeta-in-R` (#2, folded into #3's `intrinsic`
+ `meromorphic` fields).

Order of surface area, low→high: **#4 (one line) → #1 stem (already in) → #2/#3 (the ζ_𝕆
build, the only real work — classical bookkeeping, no new mathematics) → #5 (assembly) →
#1 octonionic (optional geometry, may defer).**

---

## #4 — `cor:nontrivial` (one component → one real centre)

Direct from the keystone; `transportLevel n = (sphereZero n).re` (Theorem.lean:165).

```lean
/-- master `cor:nontrivial`: the residue-ℂ zeros share one real centre. -/
theorem ASection.nontrivial_one_centre (A : ASection) :
    ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c :=
  ⟨(A.sphereZero 0).re, fun n => A.transportLevel_placement n 0⟩
```

Audit: metric "centre" is the downstream gloss (`rmk:concentric-gloss`); the *content* is
the level equality. One line, no new input beyond the keystone.

---

## #1 — `thm:zero-equivalence` / `thm:zero-spheres`

**Stem level (operative for #5): already in** as the divisor bundle. Record it under the
master name for the blueprint:

```lean
/-- master `thm:zero-equivalence` (stem form): the C3 enumeration is exactly the UHP
zero set of the stem. = `stem_zero_of_sphereZero` ∧ `sphereZero_complete`. -/
theorem ASection.zero_equivalence (A : ASection) (z : ℂ) (hz : 0 < z.im) :
    A.F z = 0 ↔ ∃ n, A.sphereZero n = z :=
  ⟨fun h => A.sphereZero_complete h hz, by rintro ⟨n, rfl⟩; exact A.stem_zero_of_sphereZero n⟩
```

**Octonionic level (the 6-sphere geometry):** the H₁/G₂ realization; `S_ρ = σ + γ·S⁶` is a
G₂-orbit, the nontrivial-zero set is `⊔ S_ρ`. Half in already (`G2.exists_smul_eq_…`).
SCHEMATIC, may DEFER (not needed for #5 — RH reads off the stem):

```lean
-- def zeroSphere (σ γ : ℝ) : Set (OnePoint Octonion) := …   -- σ + γ • unitImaginarySphere
-- theorem zeroSphere_eq_G2orbit … (uses exists_smul_eq_of_mem_unitImaginarySphere — PROVED)
-- theorem nontrivialZeroSet_eq_iSup_zeroSphere … (⊔ over conjugate pairs, pairwise disjoint)
```

---

## #2 + #3 — `thm:zeta-in-R` and `cor:zeta-section`: build `zetaSection : ASection`

The one substantive item — but classical bookkeeping, no new mathematics. Every field is a
`riemannZeta` fact; `thm:zeta-in-R` is exactly the `intrinsic` + `meromorphic` fields. Build
in a new `Concentricity/ZetaSection.lean`. Field-by-field target (R5: verify every Mathlib
name live; several may be Mathlib-native, shrinking the work):

```lean
noncomputable def zetaSection : ASection where
  F           := riemannZeta
  -- thm:zeta-in-R:
  intrinsic   := …    -- ζ(conj s) = conj (ζ s)      [R5: riemannZeta_conj / from Dirichlet series]
  meromorphic := …    -- MeromorphicOn riemannZeta univ  [R5: analytic off 1 ⇒ meromorphic]
  -- C1 (single simple pole at 1):
  pole          := 1
  c1_analyticAt := …  -- ∀ z ≠ 1, AnalyticAt ℂ riemannZeta z   [R5: differentiableAt_riemannZeta]
  c1_simple     := …  -- meromorphicOrderAt riemannZeta 1 = -1  [R5: simple pole, residue 1]
  -- C2 (infinite Euler product on Re > 1):
  ι            := Nat.Primes            -- ι_infinite := inferInstance (primes infinite)
  ι_infinite   := …
  ℓ            := fun p z => -Complex.log (1 - (p:ℂ) ^ (-z))   -- Euler-factor log
  Ω₀           := 1
  c2_intrinsic := …   -- each ℓ p intrinsic
  c2_analyticAt := …  -- analytic on Re > 1
  c2_zero_free := …   -- 1 - p^{-z} ≠ 0 on Re > 1
  c2_summable  := …   -- Σ_p ℓ p z summable on Re > 1   [R5: riemannZeta_eulerProduct cluster]
  c2_euler     := …   -- riemannZeta z = exp (∑' p, ℓ p z) on Re > 1
  c2_locMajorant := … -- local majorant (Titchmarsh Ch.1 register; from p^{-Re z} bound)
  -- C3 (infinite Weierstrass over the full divisor, through the pole):
  m        := 0                          -- ζ(0) = -1/2 ≠ 0
  Rfac     := …    -- Weierstrass product over the trivial zeros -2,-4,…  (residue-ℝ)
  gfac     := …    -- Hadamard entire exponential factor
  genus    := fun _ => 1                 -- ζ/ξ is order 1
  sphereZero := …  -- enumeration of the UHP nontrivial zeros
  c3_R_intrinsic := … ; c3_R_entire := … ; c3_R_zeros_real := …   -- Rfac facts (trivial zeros real, nonzero)
  c3_g_intrinsic := … ; c3_g_entire := …
  c3_sphere_nonreal := …                 -- UHP representatives: 0 < im
  c3_multipliable   := …                 -- the Hadamard product converges   [R5: completedRiemannZeta Hadamard]
  c3_locMajorant    := …                 -- local majorant of the primary factors (order-1)
  c3_lowerEdge      := …    -- ∃ βlo, ∀ k, βlo ≤ (sphereZero k).re  (critical strip: 0 < Re ρ)
  c3_factorization  := …    -- (z-1)·ζ = z^0 · Rfac · e^gfac · ∏ 𝓔(·;qₙ)  (Hadamard, pole factor per PLAN §8)
  -- C4 (infinitely many residue-ℂ zeros):
  c4_infinite := riemannZeta_nontrivialZeros_infinite     -- PROVED
  -- compactification datum:
  valueAtInfinity      := (1 : ℂ)        -- ζ*(∞) = 1  (def:zeta-Cstar; separate from the theorem)
  valueAtInfinity_real := …              -- 1 is real
```

Notes for Lane A:
- `thm:zeta-in-R` (#2) is literally the `intrinsic` + `meromorphic` fields — no separate
  theorem needed unless the blueprint wants it named.
- The heavy fields are `c2_euler`, `c2_summable` (Mathlib `riemannZeta` Euler-product
  cluster — verify how much is native), and `c3_multipliable`/`c3_factorization` (Hadamard;
  Mathlib has `completedRiemannZeta` — check for a Hadamard/product API; else in-repo
  assembly over the divisor). `c3_lowerEdge` for ζ is the critical strip `0 < Re ρ`
  (member-private, classical) — NOT the class-general question; ζ supplies it outright.
- Land fields incrementally, each sorried until its classical fact is in (R8); the object
  type-checks with sorried fields, so `cor:rh` (#5) can be drafted against it in parallel.

---

## #5 — `cor:rh` (the functional equation pins ½; the only place ζ or ½ appears)

```lean
/-- master `cor:rh`: every nontrivial zero of ζ has real part ½. -/
theorem riemannHypothesis {ρ : ℂ}
    (hρ : riemannZeta ρ = 0) (h0 : 0 < ρ.re) (h1 : ρ.re < 1) : ρ.re = 1 / 2 := by
  -- (1) all UHP nontrivial zeros share one centre c:
  --     zetaSection.nontrivial_one_centre  (#4) ∘ zero_equivalence (#1 stem, divisor bundle)
  -- (2) ρ (WLOG upper half; conjugate symmetry) is one of them ⇒ ρ.re = c
  -- (3) functional equation: riemannZeta ρ = 0 ⇒ riemannZeta (1 - ρ) = 0, still nontrivial
  --     [R5: riemannCompletedZeta_one_sub / completedRiemannZeta functional equation]
  --     ⇒ (1 - ρ).re = c, i.e. 1 - c = c ⇒ c = 1/2
  sorry
```

This is `thm:rh-equiv` read on `zetaSection`: concentricity gives one centre (no ½, no FE),
then the FE alone forces `c = 1 - c`. Two lines of real content once `zetaSection` and the
Mathlib FE pin are in. ½ enters here and nowhere earlier.

---

## Formalization order (once the keystone is green)

1. `#4 nontrivial_one_centre` — one line; land immediately after the keystone.
2. `#1 zero_equivalence` (stem) — record over the proved divisor bundle.
3. `#3 zetaSection` — build in `Concentricity/ZetaSection.lean`, fields sorried→closed as
   Mathlib pins land; `#2` is its `intrinsic`/`meromorphic` fields.
4. `#5 riemannHypothesis` — assemble; verify the Mathlib functional-equation pin live (R5).
5. `#1 octonionic` 6-sphere geometry — optional/blueprint; defer (RH reads off the stem).

Gate reminder (R9): the literal net-0 is over the WHOLE repo. `zetaSection`'s sorried
fields count until closed — but they are classical `riemannZeta` facts, not open mathematics,
and each carries its Mathlib pin. `cor:rh` is not needed for `thm:concentricity`'s own
0/0 (the theorem is member-free); it is the downstream payoff.
