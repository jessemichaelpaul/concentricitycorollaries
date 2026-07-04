# READ — Weil/Li at class level: findings v1 (2026-07-04, Lane B)

Register: reading record + target-sentence draft. Nothing here is derived-in-repo;
verbatim statements carry provenance; my observations are marked DRAFT-DERIVED
(to be re-proved against the sources before anything hardens). Lane B edits files,
Lane A commits.

## Provenance (R11 pass)

- **Li**: X.-J. Li, "The positivity of a sequence of numbers and the Riemann
  hypothesis," J. Number Theory 65 (1997) 325–333.
- **BL**: E. Bombieri, J. C. Lagarias, "Complements to Li's criterion for the
  Riemann hypothesis," J. Number Theory 77 (1999) 274–287. PDF paywalled at
  ScienceDirect (fetch blocked) — **author-library flag**, GPV pattern; statement
  meanwhile via the Sekatskii version below + secondary confirmations.
- **Sekatskii (generalization; text in hand)**: arXiv:1304.7895; **version of
  record: Ukrainian Math. J. 64 (2014?) — Springer,
  DOI 10.1007/s11253-014-0940-9** (landing page seen in search; the arXiv text
  itself prints "Ukrainian Math. J., 64, 371-383, 2014"). Volume/pages to verify
  live at Springer during the SOURCES pass.
- **Weil**: A. Weil, "Sur les 'formules explicites' de la théorie des nombres
  premiers," Meddelanden Fran Lunds Univ. Mat. Sem. (dédié à M. Riesz), 1952,
  252–265. **Bombieri**: "Remarks on Weil's quadratic functional in the theory
  of prime numbers, I," Rend. Mat. Acc. Lincei (9) 11 (2000), 183–233 (EUDML
  entry seen; volume to verify).
- Statement-level secondary: AIM WWN pages "Weil's positivity criterion" (the
  Guinand–Weil formula; note it hard-codes ρ = 1/2 + iγ — the classical
  presentation is value-pinned by construction) and "Bombieri's refinement"
  (RH ⟺ Σ_ρ ĝ(ρ)·conj(ĝ)(1−ρ) > 0 for g ∈ C₀^∞(0,∞), ĝ the Mellin transform —
  note the kernel pairs ρ with 1−ρ: the FE reflection is inside the pairing).

## The statements (transcribed from Sekatskii's text; OCR cleaned, flagged)

**Theorem 2 (Generalized Bombieri–Lagarias).** Let a, β be real, a ≠ β, and R a
multiset of complex numbers ρ with
(i) 2β − a ∉ R;
(ii) Σ_ρ (1 + |Re ρ|)/(1 + |ρ − 2β|²) < ∞   [OCR shape — verify against BL/UMJ].
Then, for a < β, the following are equivalent:
(a) Re ρ ≤ β for every ρ ∈ R;
(b) k_{a,n} := Σ_ρ Re[ 1 − ((ρ − a)/(ρ − (2β − a)))ⁿ ] ≥ 0 for n = 1, 2, 3, …;
(c) for every ε > 0 there is c(ε) > 0 with k_{a,n} ≥ −c(ε)·e^{εn} for all n.
For a > β, (a) is replaced by (a′): Re ρ ≥ β for every ρ. Addendum (iii): if
ρ ∈ R ⟹ ρ̄ ∈ R with the same multiplicity, the Re[·] may be omitted (sums are real).

**Theorem 3 (Generalized Li).** Same convergence data, PLUS the reflection
condition (iii): ρ ∈ R ⟹ 2β − ρ ∈ R. Then positivity (for the a-family) is
equivalent to (a): **Re ρ = β for every ρ** — equality.

**Reading of the kernel.** ((ρ−a)/(ρ−(2β−a))) compares distances from ρ to the
anchor pair {a, 2β−a}, mirror-symmetric about the line Re = β; the unit circle
of the kernel IS that line. Classical Li: anchors {0, 1} (origin and pole),
β = 1/2 pre-named — named via the FE, which also supplies Theorem 3's
reflection condition. Conjugation's true role, source-confirmed: it makes the
sums real (addendum (iii) of Thm 2). It never pins.

## The finding (DRAFT-DERIVED — the FE-free escape, present in the source itself)

Theorem 2 exists in BOTH one-sided forms around the same β: an anchor a₁ < β
detects Re ρ ≤ β; an anchor a₂ > β detects Re ρ ≥ β. Conjunction pins:

> **Two-sided positivity at a common β ⟺ Re ρ = β for every ρ — with NO
> reflection symmetry in R.** The FE is not needed for pinning; it is needed
> classically only because β is NAMED (½) before the argument starts. Quantify
> β existentially and the criterion becomes value-free.

## Target sentence v0.2 (the (iv) draft; value-free, covariant, per-pair exact)

> **(iv)** For the zero multiset R_A of an A-section (upper-half stem zeros with
> conjugates; convergence (ii) supplied by the divisor data — check C-1 below),
> **there exists a real β such that for one (equivalently every) anchor pair
> a₁ < β < a₂ the generalized-Li sums k_{a₁,n} and k_{a₂,n} are nonnegative for
> all n ≥ 1.**
>
> By Theorem 2 (both sides), this is EQUIVALENT to placement_set: all levels
> equal (the common value β — existential, never named). The closing clause of
> the two-index route is exactly the two-sided positivity; deriving it from
> C1–C4 through the ledger is endpoint 0/0; naming it is the C5 endpoint.

Admissibility audit of v0.2: no ½, no named level (β bound by ∃) ✓; anchors are
bound variables, mirror-symmetric — gauge-covariant (translate everything) ✓;
inequalities are exact for each n, sums over all zeros — no Tendsto, no
N-asymptotics-to-finite-pairs leak ✓; conjugation (proved in-frame) makes every
sum real via Thm 2(iii)-addendum ✓; the kernels route through logDeriv/contour
machinery = the seed + B2.1 residue ledger (Li's own derivation is a contour
integral of g·(log ξ)′ — Sekatskii Thms 4–5 = generalized Littlewood) ✓.

## Checks queued (the read's remaining obligations)

- **C-1 (analytic, likely cheap):** the convergence condition (ii) for R_A from
  C3/C4 divisor data (§4α majorants / genus of the primaries; classical genus-1
  density for ζ). If (ii) fails class-wide, the class needs it stated — R3
  territory, author's word.
- **C-2 (the hard center, unchanged by the reduction):** derive two-sided
  positivity from C1–C4 — this is where "GRH-scale for the class" now lives,
  in its sharpest known form. One-sided cones (g⋆g̃ / a < β) are the classically
  available kind; **the second side is the uncharted part** — the precise new
  question for the band/winding packaging: does the octonionic transport supply
  the a > β family?
- **C-3:** verify BL's original (ii) wording and Theorem statements against the
  journal PDF (library); verify Sekatskii UMJ volume/pages live at Springer.
- **C-4:** Weil-cone route (Bombieri refinement kernel pairs ρ with 1−ρ — FE
  inside the pairing; document why the class pairing folds by conjugation
  instead, and what replaces the 1−ρ slot: nothing — the two-sided anchors
  make it unnecessary).
- **C-5 (naming hygiene):** if derivation fails, the named hypothesis is
  "two-sided generalized-Li positivity" — the honest C5, checkable per member
  by classical means? NO — per member it is RH-equivalent (Thm 2 is an iff).
  So as C5 it hits circularity-B for cor:rh unless the second side is derived
  from structure. Record: the ONLY fully honest endpoints are (0/0 via C-2) or
  (named C5 with cor:rh explicitly withheld). No third door.

## Consequence for Brick 2 (design input for Lane A, via the author's gate)

B2.2's eventual non-tautological face is now identified: the pairing against
the **anchor-pair Möbius kernels** ((z−a)/(z−(2β−a)))ⁿ (equivalently their log
derivatives), contour-shifted; B2.1's residue ledger is exactly its
bookkeeping. B2.0's inverse-coordinate bridge is the n = 1 shadow. Recommend:
B2.2 waits for the author's ruling on v0.2, then is drafted directly against
the kernel family — one design, no rework.
