/-
Concentricity/ZetaOctonion.lean

Islands B1 + B5(upper half) (PLAN_islands_part1_part2_2026-07-05.md): the
octonionic zeta ζ_𝕆 on 𝕆* = OnePoint Octonion (master `def:zeta_O`), its
evaluation clauses, the slice display law on the upper half-plane, and the
upper-half Zero Equivalence (master `thm:zero-equivalence`, the bridge).

Template: `Octonion.exp` (Concentricity/Toolkit.lean) — the same junk-robust
`dir`/`sliceCoord` slice display, with the compactified pole/∞ cases of
`def:zeta_O`(iii)–(iv) on top.

Deferred to the conjugation pin (R5 sweep, cluster 2): the lower-half
display (master `prop:well-defined`'s φ₋ᵥ clause) and the real-clause
faithfulness (`def:zeta_O`(ii)) — both consume ζ(conj s) = conj (ζ s), which
enters there and nowhere else. Stated when the pin lands; nothing here
consumes them.

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file targets ZERO
sorries.
-/
import Concentricity.ZetaCstar
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
