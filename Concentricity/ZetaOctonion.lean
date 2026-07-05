/-
Concentricity/ZetaOctonion.lean

Islands B1 + B2 + B3(preservation face) + B4 + B5(upper half)
(PLAN_islands_part1_part2_2026-07-05.md): the octonionic zeta ζ_𝕆 on
𝕆* = OnePoint Octonion (master `def:zeta_O`), its evaluation clauses, the
slice display law on BOTH half-planes and at the real points (master
`prop:well-defined` — Island B2), the real-clause faithfulness
(`def:zeta_O`(ii)), G₂-equivariance (B4), the upper-half Zero Equivalence
(B5, the bridge), and the slice-preservation face of `thm:zeta-in-R`
(Island B3; the slice-regularity clause rides its docstring per the
`Octonion.exp` convention of Toolkit.lean).

Template: `Octonion.exp` (Concentricity/Toolkit.lean) — the same junk-robust
`dir`/`sliceCoord` slice display, with the compactified pole/∞ cases of
`def:zeta_O`(iii)–(iv) on top.

The conjugation pin (R5 sweep, cluster 2) is DERIVED in-repo
(Concentricity/ZetaConj.lean) and consumed HERE and nowhere else — by the
lower-half display, the real clause, and B3's faces — exactly the single
crossing point promised at the B1 landing.

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file targets ZERO
sorries.
-/
import Concentricity.ZetaCstar
import Concentricity.ZetaConj
import Concentricity.Slice

noncomputable section

open scoped OnePoint Classical
open Octonion

/-- **The octonionic zeta function** (master `def:zeta_O`, verbatim): "The
octonionic zeta function ζ_𝕆 : 𝕆* → 𝕆* is defined slicewise from the
compactified classical zeta (Definition def:zeta-Cstar) through the slice
identifications φ_v : ℂ* ≅ ℂ_v* = S²_v …: (i) for s ∈ 𝕆∖ℝ, with w = im(s),
v = w/|w| ∈ S⁶, γ = |w| > 0, σ = re(s), so s = σ + γv:
ζ_𝕆(s) := φ_v(ζ_ℂ*(σ + iγ)); (ii) for s ∈ ℝ∖{1}: ζ_𝕆(s) := ζ_ℂ*(s) = ζ(s)
∈ ℝ; (iii) for s = 1 (the simple pole, Definition def:zeta-Cstar):
ζ_𝕆(1) := ∞ = N; (iv) for s = ∞ = N: ζ_𝕆(∞) := ζ_ℂ*(∞) = 1."

Rendered through the junk-robust slice display of Concentricity/Slice.lean,
exactly as `Octonion.exp` (Toolkit.lean): clauses (i)–(ii) are the one
display `sliceEmbed (dir s) (ζ(sliceCoord s))` (at real s the direction junk
is never consumed — the coordinate is real and the embedding collapses to
`ofReal`); clause (iii) is the peeled pole case (`sliceCoord s = 1` forces
`s = 1` real, so the pole case is exactly `s = ofReal 1`); clause (iv) is
the ∞ case. The value ζ_ℂ*(σ+iγ) is `zetaC` of A1 at the slice coordinate;
away from the pole it is the coordinate value `riemannZeta (sliceCoord s)`
(`zetaC_coe`), which is the form consumed by the display. -/
def zetaO : OnePoint Octonion → OnePoint Octonion
  | ∞ => ((ofReal 1 : Octonion) : OnePoint Octonion)
  | (s : Octonion) =>
      if s = ofReal 1 then ∞
      else ((sliceEmbed (dir s) (riemannZeta (sliceCoord s)) : Octonion) :
        OnePoint Octonion)

/-- `def:zeta_O`(iv): "ζ_𝕆(∞) := ζ_ℂ*(∞) = 1". -/
theorem zetaO_infty : zetaO ∞ = ((ofReal 1 : Octonion) : OnePoint Octonion) :=
  rfl

/-- `def:zeta_O`(iii): "ζ_𝕆(1) := ∞ = N" — the simple pole is carried to
the single point at infinity (`rmk:domain`: "the simple pole at s = 1 is
carried to the point at infinity ∞ = N, which is the image of the pole, not
a zero"). -/
theorem zetaO_one : zetaO ((ofReal 1 : Octonion) : OnePoint Octonion) = ∞ := by
  simp [zetaO]

/-- A non-real slice point is not the pole point: the pole `1` is real
(`im (ofReal 1) = 0`), a slice embedding with positive imaginary coordinate
is not (`im_sliceEmbed`). PROVED helper. -/
theorem sliceEmbed_ne_pole {v : Octonion} (hv : v ∈ unitImaginarySphere)
    {ζ : ℂ} (hζ : 0 < ζ.im) : sliceEmbed v ζ ≠ ofReal 1 := by
  intro h
  have him := congrArg im h
  rw [im_sliceEmbed hv, im_ofReal] at him
  have h2 := congrArg normSq him
  rw [normSq_smul, hv.2, _root_.mul_one, normSq_zero] at h2
  exact absurd (pow_eq_zero_iff two_ne_zero |>.mp h2) (ne_of_gt hζ)

/-- **The slice display law, upper half** (master `def:zeta_O`(i), rendered;
the `exp_sliceEmbed` pattern of Toolkit.lean): on the upper-half slice
coordinate, ζ_𝕆 is the slice embedding of the classical value —
ζ_𝕆(φ_v(ζ)) = φ_v(ζ(ζ)). The lower-half clause (conjugate symmetry,
`prop:well-defined`) waits on the R5 conjugation pin. -/
theorem zetaO_sliceEmbed {v : Octonion} (hv : v ∈ unitImaginarySphere)
    {ζ : ℂ} (hζ : 0 < ζ.im) :
    zetaO ((sliceEmbed v ζ : Octonion) : OnePoint Octonion)
      = ((sliceEmbed v (riemannZeta ζ) : Octonion) : OnePoint Octonion) := by
  have hcoord : sliceCoord (sliceEmbed v ζ) = ζ := by
    rw [sliceCoord_sliceEmbed hv, abs_of_pos hζ]
  simp only [zetaO]
  rw [if_neg (sliceEmbed_ne_pole hv hζ), hcoord, dir_sliceEmbed_of_pos hv hζ]

/-- `sliceCoord` is G₂-invariant — the isometry block of Slice.lean
(`G2.smul_re`, `G2.smul_im`, `G2.smul_norm`, all PROVED) read at the slice
coordinate. PROVED helper. -/
theorem _root_.G2.smul_sliceCoord (g : G2) (x : Octonion) :
    sliceCoord (g • x) = sliceCoord x := by
  rw [sliceCoord, sliceCoord, G2.smul_re, G2.smul_im, G2.smul_norm]

/-- **G₂-equivariance of ζ_𝕆** (master `thm:G2-equiv`, verbatim):
"ζ_𝕆(g·s) = g·ζ_𝕆(s) for all g ∈ G₂, s ∈ 𝕆." Master proof clause carried:
"g carries the slice ℂ_v to the slice ℂ_{g(v)} by the isometric relabelling
φ_{g(v)} = g ∘ φ_v" — here `G2.smul_sliceEmbed` (PROVED, Slice.lean).
Extended to 𝕆* per `rmk:G2-compact` (the action fixes ∞ = N). Island B4;
feeds B6(i), the zero-spheres as G₂-orbits. -/
theorem zetaO_equivariant (g : G2) (x : OnePoint Octonion) :
    zetaO (g • x) = g • zetaO x := by
  cases x with
  | infty =>
    rw [G2.smul_onePoint_infty, zetaO_infty, G2.smul_onePoint_coe, G2.smul_ofReal]
  | coe s =>
    rw [G2.smul_onePoint_coe]
    by_cases hs : s = ofReal 1
    · subst hs
      rw [G2.smul_ofReal, zetaO_one, G2.smul_onePoint_infty]
    · have hgs : g • s ≠ ofReal 1 := fun h => hs (by
        have h' : g⁻¹ • (g • s) = g⁻¹ • (ofReal 1 : Octonion) := by rw [h]
        rwa [inv_smul_smul, G2.smul_ofReal] at h')
      simp only [zetaO]
      rw [if_neg hgs, if_neg hs, G2.smul_sliceCoord, G2.smul_dir,
        ← G2.smul_sliceEmbed, ← G2.smul_onePoint_coe]

/-- The slice embedding vanishes only at the vanishing coordinate
(`normSq_sliceEmbed`). PROVED helper. -/
theorem sliceEmbed_eq_zero_iff {v : Octonion} (hv : v ∈ unitImaginarySphere)
    (ζ : ℂ) : sliceEmbed v ζ = 0 ↔ ζ = 0 := by
  constructor
  · intro h
    have h2 := congrArg normSq h
    rw [normSq_sliceEmbed hv, normSq_zero] at h2
    have hre : ζ.re = 0 := by nlinarith [sq_nonneg ζ.re, sq_nonneg ζ.im]
    have him : ζ.im = 0 := by nlinarith [sq_nonneg ζ.re, sq_nonneg ζ.im]
    exact Complex.ext hre him
  · rintro rfl
    rw [show ((0 : ℂ)) = ((0 : ℝ) : ℂ) by norm_num, sliceEmbed_ofReal]
    show ofReal 0 = 0
    rw [ofReal]
    norm_num
    rfl

/-- **The Zero Equivalence Theorem, upper half** (master
`thm:zero-equivalence`, verbatim): "Let ρ = σ + iγ ∈ ℂ*. For every v ∈ S⁶,
ζ_𝕆(σ + γv) = 0 ⟺ ζ_ℂ*(ρ) = 0." Master proof clause carried: "An
isomorphism is injective and sends 0 to 0, so φ_v(z) = 0 ⟺ z = 0; with
z = ζ_ℂ*(ρ) this gives both implications."

THE BRIDGE (PLAN_islands §2, B5): every classical fact consumed downstream
about the zeros of ζ_𝕆 crosses here, nowhere else. Stated at the coordinate
(`riemannZeta ζ = 0`), which by A2's `zetaC_coe_eq_zero_iff` is the ζ_ℂ*
statement away from the pole — and the pole is excluded here by `0 < ζ.im`. -/
theorem zetaO_zero_iff {v : Octonion} (hv : v ∈ unitImaginarySphere)
    {ζ : ℂ} (hζ : 0 < ζ.im) :
    zetaO ((sliceEmbed v ζ : Octonion) : OnePoint Octonion)
      = ((0 : Octonion) : OnePoint Octonion) ↔ riemannZeta ζ = 0 := by
  rw [zetaO_sliceEmbed hv hζ, OnePoint.coe_eq_coe, sliceEmbed_eq_zero_iff hv]

/-- Pole exclusion at any non-real coordinate (the `sliceEmbed_ne_pole`
argument, sign-free). PROVED helper. -/
theorem sliceEmbed_ne_pole' {v : Octonion} (hv : v ∈ unitImaginarySphere)
    {ζ : ℂ} (hζ : ζ.im ≠ 0) : sliceEmbed v ζ ≠ ofReal 1 := by
  intro h
  have him := congrArg im h
  rw [im_sliceEmbed hv, im_ofReal] at him
  have h2 := congrArg normSq him
  rw [normSq_smul, hv.2, _root_.mul_one, normSq_zero] at h2
  exact hζ (pow_eq_zero_iff two_ne_zero |>.mp h2)

/-- **The slice display law, lower half** (master `prop:well-defined`, proof
clause verbatim: "we must check φ_v(ζ_ℂ*(σ+iγ)) = φ_{−v}(ζ_ℂ*(σ−iγ)). By
conjugate symmetry ζ_ℂ*(σ−iγ) = conj ζ_ℂ*(σ+iγ) …: the two sign reversals —
one from conjugating the input, one from the reversed identification —
cancel."): at a negative-imaginary coordinate the canonical representative
conjugates (`sliceCoord_sliceEmbed`), the direction reverses
(`dir_sliceEmbed_of_neg`), and the conjugation pin (`riemannZeta_conj`,
ZetaConj.lean) with `sliceEmbed_neg_conj` cancels the two reversals — the
`exp_sliceEmbed_of_im_neg` pattern (Toolkit.lean). PROVED. -/
theorem zetaO_sliceEmbed_of_im_neg {v : Octonion}
    (hv : v ∈ unitImaginarySphere) {ζ : ℂ} (hζ : ζ.im < 0) :
    zetaO ((sliceEmbed v ζ : Octonion) : OnePoint Octonion)
      = ((sliceEmbed v (riemannZeta ζ) : Octonion) : OnePoint Octonion) := by
  have hcoord : sliceCoord (sliceEmbed v ζ) = (starRingEnd ℂ) ζ := by
    rw [sliceCoord_sliceEmbed hv, abs_of_neg hζ]
    exact Complex.ext (Complex.conj_re ζ).symm (Complex.conj_im ζ).symm
  simp only [zetaO]
  rw [if_neg (sliceEmbed_ne_pole' hv (ne_of_lt hζ)), hcoord,
    dir_sliceEmbed_of_neg hv hζ, riemannZeta_conj, sliceEmbed_neg_conj]

/-- `def:zeta_O`(ii) faithfulness (master, verbatim): "for s ∈ ℝ∖{1}:
ζ_𝕆(s) := ζ_ℂ*(s) = ζ(s) ∈ ℝ" — at a real point away from the pole the
junk-robust display collapses to the REAL classical value: the direction
junk is never consumed (`dir` vanishes, the zero-direction embedding is
`ofReal`), and the value is real by the conjugation pin
(`riemannZeta_im_ofReal`). PROVED. -/
theorem zetaO_ofReal {σ : ℝ} (hσ : σ ≠ 1) :
    zetaO ((ofReal σ : Octonion) : OnePoint Octonion)
      = ((ofReal ((riemannZeta σ).re) : Octonion) : OnePoint Octonion) := by
  have hne : ofReal σ ≠ ofReal 1 := by
    intro h
    have hre := congrArg re h
    rw [re_ofReal, re_ofReal] at hre
    exact hσ hre
  have hdir : dir (ofReal σ) = 0 := by
    rw [dir, im_ofReal, smul_zero]
  have hcoord : sliceCoord (ofReal σ) = (σ : ℂ) := by
    rw [sliceCoord, re_ofReal, im_ofReal, norm_zero]
    exact Complex.ext (Complex.ofReal_re σ).symm (Complex.ofReal_im σ).symm
  simp only [zetaO]
  rw [if_neg hne, hdir, hcoord, sliceEmbed_zero_dir]

/-- **Island B2 — `prop:well-defined`** (master, verbatim): "ζ_𝕆 : 𝕆* → 𝕆*
is well-defined." In the `dir`/`sliceCoord` encoding the canonical
representative is fixed, so well-definedness renders as the ONE display law
with no sign hypothesis (the `exp_sliceEmbed'` pattern, Toolkit.lean): for
every coordinate ζ ≠ 1, ζ_𝕆(φ_v(ζ)) = φ_v(ζ_ℂ*(ζ)) — the upper half is B1's
display, the lower half is the conjugation-pin cancellation
(`zetaO_sliceEmbed_of_im_neg`), and at real coordinates both sides collapse
to the real value (`zetaO_ofReal` + `riemannZeta_im_ofReal`), which is
`def:zeta_O`(ii)'s clause. PROVED. -/
theorem zetaO_sliceEmbed' {v : Octonion} (hv : v ∈ unitImaginarySphere)
    {ζ : ℂ} (hζ : ζ ≠ 1) :
    zetaO ((sliceEmbed v ζ : Octonion) : OnePoint Octonion)
      = ((sliceEmbed v (riemannZeta ζ) : Octonion) : OnePoint Octonion) := by
  rcases lt_trichotomy ζ.im 0 with hneg | hzero | hpos
  · exact zetaO_sliceEmbed_of_im_neg hv hneg
  · obtain ⟨σ, rfl⟩ : ∃ σ : ℝ, ((σ : ℝ) : ℂ) = ζ :=
      ⟨ζ.re, Complex.ext (Complex.ofReal_re _)
        (by rw [Complex.ofReal_im]; exact hzero.symm)⟩
    have hσ : σ ≠ 1 := by
      intro h
      apply hζ
      rw [h, Complex.ofReal_one]
    have hval : riemannZeta ((σ : ℝ) : ℂ)
        = (((riemannZeta ((σ : ℝ) : ℂ)).re : ℝ) : ℂ) :=
      Complex.ext (Complex.ofReal_re _).symm
        (by rw [Complex.ofReal_im]; exact riemannZeta_im_ofReal σ)
    rw [sliceEmbed_ofReal, zetaO_ofReal hσ]
    conv_rhs => rw [hval, sliceEmbed_ofReal]
  · exact zetaO_sliceEmbed hv hpos

/-- **Island B3 — `thm:zeta-in-R`** (master, verbatim): "ζ_𝕆 ∈ 𝓡." The
slice-PRESERVATION face (master proof clause, verbatim: "By Theorem
thm:slice-pres it is slice preserving, ζ_𝕆(ℂ_v*) ⊆ ℂ_v*"): ζ_𝕆 maps each
compactified slice sphere into itself — the `realize_mem_sliceSphere`
pattern (Slice.lean) over the B2 display law; the pole lands on ∞ ∈ every
sphere, ∞ lands on the real value 1 ∈ every sphere.

The slice-REGULARITY clause (master proof, verbatim: "Equivalently
ζ_𝕆 = ext(ζ) is the slice-regular extension of the holomorphic,
conjugation-symmetric ζ on ℂ∖{1} (Theorem thm:extension, [CSS12,
Thm. 5.1.5]); hence ζ_𝕆 is slice regular on 𝕆*∖{1,∞} (slice regularity is
slicewise holomorphy, Definition def:slice-regular)") rides this docstring
per the `Octonion.exp` convention (Toolkit.lean, `thm:slice-exp`'s
regularity clause — the octonionic slice-analytic layer is the queued
characterization). The stem-level faces consumed by the corollaries are
`riemannZeta_intrinsic` (ZetaConj.lean) and Mathlib's
`differentiableAt_riemannZeta` — per PLAN_islands B3: "NOT a blocker for
the corollaries". -/
theorem zetaO_mem_sliceSphere {v : Octonion} (hv : v ∈ unitImaginarySphere)
    {q : OnePoint Octonion} (hq : q ∈ sliceSphere v) :
    zetaO q ∈ sliceSphere v := by
  rcases Set.mem_insert_iff.mp hq with rfl | hq'
  · rw [zetaO_infty]
    exact Set.mem_insert_of_mem _
      ⟨ofReal 1, ⟨((1 : ℝ) : ℂ), sliceEmbed_ofReal v 1⟩, rfl⟩
  · obtain ⟨x, hx, rfl⟩ := hq'
    obtain ⟨ζ, rfl⟩ := hx
    by_cases hζ : ζ = 1
    · subst hζ
      have h1 : sliceEmbed v (1 : ℂ) = ofReal 1 := by
        rw [show (1 : ℂ) = ((1 : ℝ) : ℂ) from Complex.ofReal_one.symm,
          sliceEmbed_ofReal]
      rw [h1, zetaO_one]
      exact Set.mem_insert _ _
    · rw [zetaO_sliceEmbed' hv hζ]
      exact Set.mem_insert_of_mem _
        ⟨sliceEmbed v (riemannZeta ζ), ⟨riemannZeta ζ, rfl⟩, rfl⟩
