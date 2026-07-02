# DEPENDENCY TABULATION — backwards from the four endpoints
*Built by tracing the statements and proofs as written in `Octonionic_RH_master_v2.tex`
(Parts 1–2 read in full this thread; Part 3 = v2). Inbound-`\ref` counts were used only to
find **missing citations**, never to decide logical need. Nothing is cut here; three items
are flagged as author calls.*

**Legend** — Lean disposition: **[M]** Mathlib (verify name live, R5) · **[F]** formalize
in-repo (short, given the leaves) · **[A]** axiom leaf, verbatim citation in comment.
"Consumers" = who needs it, traced through proof bodies.

---

## E. The four endpoints

| node | consumers | Lean |
|---|---|---|
| `thm:concentricity` | `cor:nontrivial`, `cor:rh` | [F] — the target |
| `cor:nontrivial` (translation) | `cor:rh` | [F] |
| `cor:zeta-section` | `cor:rh` | [F] |
| `cor:rh` | — (terminal) | [F] two lines |

---

## S. Part 3 spine (all KEEP — already minimal after v2)

| node | consumers | Lean |
|---|---|---|
| `def:carrier` (𝕆\* = S⁸, atlas) | `def:two-worlds`, `rmk:two-poles`, everything compactified | [M] `OnePoint` + sphere equiv (verify `onePointEquivSphereOfFinrankEq` live) |
| `rmk:compactify` (transport of uncompactified citations) | every compactified use of the literature — a **derivation-node pattern**, not an assumption | [F] per-use |
| `rmk:two-poles` (N vs 𝔫) | `thm:concentricity`, `def:base`, `rmk:collapse-cone` | [F] (definition of 𝔫) |
| `def:section-map` (stem; equivariance; blindness) | `thm:section-functor`, `thm:concentricity` assembly | [F] given Wang/BW leaves |
| `rmk:c4-role` | expository | prose only |
| `def:two-worlds` (𝓗₁, 𝒮₂) | `thm:section-functor`, `lem:residue-spheres`, `def:base` | [M] `ActionCategory` for 𝓗₁; [F] 𝒮₂ |
| `thm:section-functor` (Φ) | `thm:concentricity`, `rmk:collapse-cone` | [F] |
| `rmk:collapse-cone` | `thm:concentricity` readback | [F]/prose |
| `def:base` (𝓑, F, 𝒯_A) | `lem:pi0-grothendieck`, `thm:concentricity` | [M] `Grothendieck`; [F] 𝓑, F |
| `prop:weierstrass` | C3 of `thm:concentricity`, `cor:zeta-section` | [A] AdFslice Prop 3.1 + Thm 3.2; GV |
| `lem:residue-spheres` | `thm:concentricity`, `cor:nontrivial`, `prop:weierstrass` hypothesis note | [F] given Wang stem leaf |
| `lem:pi0-grothendieck` | `thm:concentricity`, `rmk:pi0-split` | [F] — π₀ ⊣ disc, zigzag; `ConnectedComponents` [M] |
| `rmk:pi0-split` (second proof) | recorded alternative | [F] optional; Quillen Thm A / precofibred corollary [A→M?] (`Functor.Final` exists — verify scope) |
| `thm:connected-concentric` (dictionary: one component = one level = one centre) | `cor:nontrivial` | [F] from `def:base` + `lem:exp-degenerate`; **independent of `thm:concentricity`** (v4 `\uses` graph verified) |
| `rmk:collapse-vs-translation` (pointer: dictionary vs application), `rmk:half-downstream`, `rmk:status` | expository structure | prose only |

---

## T. Part 2 — needed by the **Theorem** (general A; no ζ anywhere)

| node | consumers | Lean |
|---|---|---|
| `def:octonions` | everything (⚠ uncited — add refs) | [A] structure w/ axioms — **day-one check: does Mathlib have 𝕆?** (it has ℍ) |
| `thm:artin` | `thm:wang`, `prop:R-comm-ring`, `cor:powers` | [A] Schafer |
| `cor:powers` | `thm:slice-exp` series, ∗-context (⚠ uncited — add ref at `thm:slice-exp`) | [F] from Artin leaf |
| `def:slices` (ℂ_v, φ_v, slice spheres) | `def:slice-regular`, `def:R`, `def:two-worlds`, `def:zeta_O` | [A] GPV VS Prop 4.1/Thm 4.2 for the sphere form; [F] the algebra span |
| `def:slice-regular` | `def:slice-preserving`, `thm:identity`, `def:R` | [A] CSS Def 5.1.1 |
| `thm:rep-formula` | `def:slice-preserving`(ii), `def:section-map` | [A] CSS Thm 5.1.7 |
| `thm:identity` | `thm:concentricity` assembly (C2/C3 agreement), `prop:R-comm-ring`, `prop:R-domain` | [A] CSS Cor 5.1.9 |
| `def:slice-preserving` | `def:R`, `def:slice-squares`, `def:section-map` | [A] AdF Def 2.7/Rem 2.8 + GPS |
| `rmk:slice-pres-compact` | compactified use of Defs/Thms above — derivation-node pattern | [F] per-use over `OnePoint` |
| `def:R` | `thm:concentricity` hypothesis, `prop:weierstrass`, everything | [F] structure |
| `thm:wang` (∗ = pointwise; comm./assoc.) | `prop:R-comm-ring`, `lem:residue-spheres`, `thm:section-functor` | [A] Wang Rem 2.11 |
| `prop:R-comm-ring` | `thm:section-functor` proof; the ring claim of the title | [F] given Wang + identity leaves — **showpiece** |
| `def:slice-squares` (I-independent lift, stem) | `def:section-map`, `thm:concentricity` assembly | [A] Wang 2.11; BW §3.7; GPS Def 2.1/Prop 2.2 |
| `thm:slice-exp` | `thm:log-manifold`, `thm:concentric-exp-base` | [A] GPV §3; VS Prop 5.1; AdF Rem 2.23 |
| `thm:log-manifold` (E⁺, L) | `thm:winding-lift`, `thm:concentric-exp-base` | [A] VS Prop 5.1–5.4, Def 5.3/5.5 |
| `thm:concentric-exp-base` | `def:base`, `thm:concentricity` assembly | [A] VS Rem 5.2(b); GPVwind Cor 5.21 |
| `thm:winding-lift` | `def:base` transport, `thm:concentricity` assembly | [A] GPVwind Def 3.4/4.1, Prop 4.2, Def 5.11 |
| `prop:winding-signature` (tame; exists+loop; winding) | `def:base`, `thm:concentricity` assembly | [A] GPVwind Def 4.20/5.2; **Cor 5.13**; Cor 5.21 |
| `def:G2` | `def:two-worlds`, `def:section-map`(ii), `rmk:G2-compact` | [A] Schafer/Baez (G₂ = Aut 𝕆, 14-dim compact) |
| `thm:G2-S6` | `lem:residue-spheres`, `def:two-worlds`, `thm:zero-spheres` | [A] Baez |
| `rmk:G2-compact` (action extends to 𝕆\*) | `def:two-worlds`, `lem:residue-spheres` | [F] from properness over `OnePoint` |

---

## Z. Part 1–2 — needed only by the **ζ corollaries** (never by the Theorem)

| node | consumers | Lean |
|---|---|---|
| `thm:riemann` (continuation; FE; conj. symmetry; strip) | `def:zeta-Cstar`, C1 of `cor:zeta-section`, `thm:rh-equiv`, `cor:rh` | [M?] `riemannZeta`, `riemannZeta_one_sub` — **verify live**; else [A] |
| `thm:euler` | C2 of `cor:zeta-section` | [M?] Euler product for ζ — verify; else [A] |
| `thm:hadamard` (infinitude) | C4 of `cor:zeta-section`, `thm:zero-spheres`(iv) | likely [A] — verify |
| `def:zeta-Cstar` + `lem:zero-Cstar` | `def:zeta_O`, `thm:zero-equivalence`, `thm:zero-spheres` | [F] over `OnePoint` given `thm:riemann` |
| `def:zeta_O` | `thm:slice-pres`, `thm:zeta-in-R`, `thm:zero-equivalence`, C1 | [F] |
| `prop:well-defined` | **logically required by every use of `def:zeta_O`** (⚠ uncited — add `\ref` at `thm:zeta-in-R`) | [F] — conj.-symmetry cancellation |
| `rmk:domain` | bookkeeping of pole/∞ for `def:zeta_O` (⚠ uncited — merge-candidate into `def:zeta_O`, author's call) | prose/[F] |
| `thm:extension` | `thm:zeta-in-R` (ζ_𝕆 = ext ζ) — receipt: line 562 | [A] CSS Thm 5.1.5 |
| `thm:slice-pres` | `thm:zeta-in-R`, `thm:zero-equivalence` | [F] |
| `thm:zeta-in-R` | `cor:zeta-section` | [F] given extension leaf |
| `thm:G2-equiv` (ζ instance) | `thm:zero-spheres`(i); cited as pattern in `def:section-map`(ii) | [F] — **demotable**: instance of `def:section-map`(ii) once ζ_𝕆 ∈ 𝓡; author's call |
| `thm:zero-equivalence` | `cor:nontrivial`, `cor:zeta-section` dictionary, `thm:zero-spheres` | [F] |
| `thm:zero-spheres` | `cor:nontrivial`, `cor:zeta-section` (C4 + dictionary), `thm:rh-equiv` | [F] given `thm:G2-S6` |
| `thm:rh-equiv` | `cor:rh` | [F] two lines |

---

## Author calls (the only three — nothing else is cut)

1. **`prop:R-domain`** (integral domain): traced through all of Parts 1–3 and the
   corollaries — no statement or proof invokes integral-domain-ness ("ζ_𝕆 is not a unit"
   at line 569 uses only the existence of zeros). Cut, or demote to a remark for context.
2. **`thm:hardy`**: logically redundant given Hadamard everywhere it appears (C4;
   `thm:zero-spheres`(iv); `cor:rh`'s last clause follows from RH + infinitude). Demote to
   a parenthetical, or keep as context.
3. **`thm:G2-equiv`**: keep as the ζ instance feeding `thm:zero-spheres`, or restate as a
   one-line corollary of `def:section-map`(ii) + `thm:zeta-in-R`.

## Citation gaps to repair at fold-in (the orphan check's real yield)

- Add `\ref{prop:well-defined}` in `thm:zeta-in-R`'s proof (well-definition is load-bearing
  and currently uncited).
- Add `\ref{def:octonions}` at `def:slices`; add `\ref{cor:powers}` at `thm:slice-exp`.
- Trim `thm:G2-equiv` from `def:two-worlds`'s citation line (orbit structure needs only
  `thm:G2-S6` + `rmk:G2-compact`).
- Add `\uses{}` annotations to all Part 1–2 nodes per the consumer columns above — this
  table **is** the annotation skeleton for the blueprint.

## Totals

Kept: **4 endpoints + 15 spine + 21 theorem-bucket + 14 ζ-bucket ≈ 54 nodes.**
Axiom leaves: **~16** (Schafer/Artin; CSS ×4; AdF/GPS slice-preserving; Wang; BW; GPV/VS ×4;
GPVwind winding cluster; AdFslice+GV; Baez ×2) — plus **up to 3 classical leaves** that may
instead be Mathlib-native (`riemannZeta` cluster: verify live, day one). Everything else is
[M] or short [F]. Repo file mapping: **Spine.lean** ← S+T · **ClassicalInputs.lean** ← Z
rows 1–4 · **ZetaO.lean** ← Z rows 5–11 · **Translation.lean** ← Z rows 12–14 +
`thm:connected-concentric` · **RH.lean** ← `cor:rh`.

---

## Delta (2026-07-02, applied to v4 in-folder)

- **Added `thm:connected-concentric`** ("Connected is concentric: the dictionary"), derived
  register, `\uses{def:base, lem:exp-degenerate}` — **no arrow from `thm:concentricity`**;
  statement and proof assembled verbatim from existing master sentences (static-base
  construction, fibre formula, level/winding split). Consumer: `cor:nontrivial`.
- **`rmk:collapse-vs-translation`** reduced to a pointer remark (dictionary vs application).
- **Register fix:** `cor:nontrivial`'s proof no longer cites `rmk:concentric-gloss`
  (glosses are cited by nothing, per R10); its `\uses` now carries the dictionary
  (`def:base` dropped — routed through the dictionary).
- **v4 `\uses` graph audit (mechanical):** cone(`thm:concentricity`) = 28 nodes, all S+T;
  zero Z-bucket members. Classical facts (`thm:riemann`, `thm:euler`, `thm:hadamard`) enter
  first at `cor:zeta-section`; translation theorems at `cor:nontrivial`/`cor:zeta-section`;
  `cor:rh` terminal. No orphan `\uses` references.
