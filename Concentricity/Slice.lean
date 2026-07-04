/-
Concentricity/Slice.lean

Slice geometry on the octonions and the realization of an A-section on the
compactified 𝕆* (master `def:slices`, `def:section-map`, `rmk:compactify`) —
the bridge from the stem encoding to the two-worlds layer, consumed by the
section functor Φ (`thm:section-functor`, next increment).

Master `def:slices` (verbatim, quoted per clause below): "For any unit
imaginary octonion v ∈ S⁶, the *complex slice* is ℂ_v = {a + bv : a, b ∈ ℝ}
⊂ 𝕆. Since v² = −1, this is a subalgebra isomorphic to ℂ via the ℝ-algebra
isomorphism φ_v : ℂ → ℂ_v, i ↦ v. … Its one-point compactification is the
*slice Riemann sphere* ℂ_v* := ℂ_v ∪ {∞} = S²_v …"

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.ASection
import Concentricity.G2
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.Tactic.Module

noncomputable section

namespace Octonion

/-! ### Componentwise helpers (DERIVED, R10) -/

theorem ofReal_eq_smul_one (r : ℝ) : ofReal r = r • (1 : Octonion) := by
  refine Prod.ext ?_ ?_
  · show ((r : ℝ) : Quaternion ℝ) = r • (1 : Quaternion ℝ)
    simpa [Algebra.algebraMap_eq_smul_one] using
      (congrFun Quaternion.algebraMap_def r).symm
  · show (0 : Quaternion ℝ) = r • (0 : Quaternion ℝ)
    rw [smul_zero]

theorem re_smul (r : ℝ) (x : Octonion) : re (r • x) = r * re x := by
  show (r • x).1.re = r * x.1.re
  rw [show (r • x).1 = r • x.1 from rfl, Quaternion.re_smul, smul_eq_mul]

theorem re_add (x y : Octonion) : re (x + y) = re x + re y := rfl

theorem re_sub (x y : Octonion) : re (x - y) = re x - re y := rfl

theorem re_one : re (1 : Octonion) = 1 := rfl

/-- The imaginary part: "An octonion s ∈ 𝕆 decomposes as s = σ + w with
σ = re(s) ∈ ℝ and w = im(s) ∈ im(𝕆) ≅ ℝ⁷" (master, §Octonions and slices). -/
def im (x : Octonion) : Octonion := x - ofReal (re x)

/-- The Euclidean norm, from the Cayley–Dickson `normSq`. -/
def norm (x : Octonion) : ℝ := Real.sqrt (normSq x)

/-- The direction I(q) of an octonion: the unit imaginary part. Junk value 0
for real octonions — GPVwind Rem 2.1 (SOURCES/GPVwind.md): the direction has
no continuous extension to ℝ; the junk value is never consumed (the
realization formula below is direction-blind at real points because
intrinsic stems are real there). -/
def dir (x : Octonion) : Octonion := (norm (im x))⁻¹ • im x

/-- The slice coordinate of q = σ + γ·I(q): the upper-half-plane point
σ + iγ, γ = ‖im q‖ ≥ 0. -/
def sliceCoord (x : Octonion) : ℂ := ⟨re x, norm (im x)⟩

/-- φ_v (master `def:slices`): the slice embedding ℂ → ℂ_v ⊆ 𝕆, i ↦ v. -/
def sliceEmbed (v : Octonion) (z : ℂ) : Octonion := ofReal z.re + z.im • v

/-- master `def:slices`: "Since v² = −1, this is a subalgebra isomorphic to
ℂ via the ℝ-algebra isomorphism φ_v : ℂ → ℂ_v, i ↦ v" — multiplicativity of
the slice embedding. Distributivity + `v * v = −1`
(`sq_eq_neg_one_of_mem_unitImaginarySphere`) + scalar-multiplication
compatibility of the Cayley–Dickson product (the `IsScalarTower`/
`SMulCommClass` instances of Concentricity/OctonionForm.lean). -/
theorem sliceEmbed_mul {v : Octonion} (hv : v ∈ unitImaginarySphere) (z w : ℂ) :
    sliceEmbed v (z * w) = sliceEmbed v z * sliceEmbed v w := by
  have hv2 : v * v = -1 := sq_eq_neg_one_of_mem_unitImaginarySphere hv
  simp only [sliceEmbed, ofReal_eq_smul_one, Complex.mul_re, Complex.mul_im]
  rw [mul_add, add_mul, add_mul, smul_mul_smul_comm, smul_mul_smul_comm,
    smul_mul_smul_comm, smul_mul_smul_comm, hv2, Octonion.one_mul,
    Octonion.mul_one, Octonion.one_mul]
  module

/-- The imaginary part has no real part — by construction. -/
theorem re_im (x : Octonion) : re (im x) = 0 := by
  rw [im, re_sub, re_ofReal, sub_self]

theorem im_ofReal (r : ℝ) : im (ofReal r) = 0 := by
  rw [im, re_ofReal, sub_self]

/-- Vanishing imaginary part characterizes the real axis. -/
theorem eq_ofReal_of_im_eq_zero {x : Octonion} (h : im x = 0) :
    x = ofReal (re x) := by
  rw [im] at h
  exact sub_eq_zero.mp h

/-- The direction of a non-real octonion is a unit imaginary octonion:
`re (im x) = 0` by construction and `normSq (dir x) = 1` by the
smul-homogeneity of `normSq` (`normSq_normalize`). -/
theorem dir_mem_unitImaginarySphere {x : Octonion} (hx : im x ≠ 0) :
    dir x ∈ unitImaginarySphere := by
  refine ⟨?_, ?_⟩
  · show re ((norm (im x))⁻¹ • im x) = 0
    rw [re_smul, re_im, mul_zero]
  · exact normSq_normalize hx

/-! ### Slice computations for the value-preservation clause (DERIVED) -/

theorem sliceEmbed_ofReal (v : Octonion) (r : ℝ) :
    sliceEmbed v (r : ℂ) = ofReal r := by
  rw [sliceEmbed, Complex.ofReal_re, Complex.ofReal_im, zero_smul, add_zero]

theorem re_sliceEmbed {v : Octonion} (hv : v ∈ unitImaginarySphere) (ζ : ℂ) :
    re (sliceEmbed v ζ) = ζ.re := by
  rw [sliceEmbed, re_add, re_ofReal, re_smul, hv.1, mul_zero, add_zero]

theorem im_sliceEmbed {v : Octonion} (hv : v ∈ unitImaginarySphere) (ζ : ℂ) :
    im (sliceEmbed v ζ) = ζ.im • v := by
  rw [im, re_sliceEmbed hv, sliceEmbed, add_sub_cancel_left]

theorem norm_smul_unit {v : Octonion} (hv : v ∈ unitImaginarySphere) (r : ℝ) :
    norm (r • v) = |r| := by
  rw [norm, normSq_smul, hv.2, _root_.mul_one, Real.sqrt_sq_eq_abs]

theorem norm_zero : norm (0 : Octonion) = 0 := by
  rw [norm, normSq_zero, Real.sqrt_zero]

theorem norm_pos_of_ne_zero {x : Octonion} (hx : x ≠ 0) : 0 < norm x := by
  rw [norm]
  exact Real.sqrt_pos.mpr (normSq_pos_of_ne_zero hx)

theorem normSq_ofReal (r : ℝ) : normSq (ofReal r) = r ^ 2 := by
  rw [ofReal_eq_smul_one, normSq_smul, normSq_one, _root_.mul_one]

theorem norm_ofReal (r : ℝ) : norm (ofReal r) = |r| := by
  rw [norm, normSq_ofReal, Real.sqrt_sq_eq_abs]

/-- The squared norm of a slice embedding along a unit direction is the
Euclidean square of the coordinate: the real and imaginary legs are
orthogonal (`innerO_one` against the imaginarity of `v`). -/
theorem normSq_sliceEmbed {v : Octonion} (hv : v ∈ unitImaginarySphere) (ζ : ℂ) :
    normSq (sliceEmbed v ζ) = ζ.re ^ 2 + ζ.im ^ 2 := by
  have hcross : innerO (ofReal ζ.re) (ζ.im • v) = 0 := by
    rw [ofReal_eq_smul_one, innerO_smul_left, innerO_comm, innerO_smul_left,
      innerO_one, hv.1]
    ring
  rw [sliceEmbed, normSq_add_eq, normSq_ofReal, normSq_smul, hv.2, hcross]
  ring

/-- Reconstruction: every octonion is the slice embedding of its slice
coordinate along its direction — junk-robust at real points (the zero
direction is never consumed: the coordinate is then real). -/
theorem sliceEmbed_dir_sliceCoord (x : Octonion) :
    sliceEmbed (dir x) (sliceCoord x) = x := by
  show ofReal (re x) + norm (im x) • dir x = x
  by_cases him : im x = 0
  · rw [him, norm_zero, zero_smul, add_zero]
    exact (eq_ofReal_of_im_eq_zero him).symm
  · rw [dir, smul_smul, mul_inv_cancel₀ (ne_of_gt (norm_pos_of_ne_zero him)),
      one_smul, im]
    abel

theorem sliceCoord_sliceEmbed {v : Octonion} (hv : v ∈ unitImaginarySphere)
    (ζ : ℂ) : sliceCoord (sliceEmbed v ζ) = ⟨ζ.re, |ζ.im|⟩ := by
  rw [sliceCoord, re_sliceEmbed hv, im_sliceEmbed hv, norm_smul_unit hv]

theorem dir_sliceEmbed_of_pos {v : Octonion} (hv : v ∈ unitImaginarySphere)
    {ζ : ℂ} (h : 0 < ζ.im) : dir (sliceEmbed v ζ) = v := by
  rw [dir, im_sliceEmbed hv, norm_smul_unit hv, abs_of_pos h, smul_smul,
    inv_mul_cancel₀ (ne_of_gt h), one_smul]

theorem dir_sliceEmbed_of_neg {v : Octonion} (hv : v ∈ unitImaginarySphere)
    {ζ : ℂ} (h : ζ.im < 0) : dir (sliceEmbed v ζ) = -v := by
  rw [dir, im_sliceEmbed hv, norm_smul_unit hv, abs_of_neg h, smul_smul,
    inv_neg, neg_mul, inv_mul_cancel₀ (ne_of_lt h), neg_smul, one_smul]

theorem dir_sliceEmbed_of_im_zero {v : Octonion}
    (hv : v ∈ unitImaginarySphere) {ζ : ℂ} (h : ζ.im = 0) :
    dir (sliceEmbed v ζ) = 0 := by
  rw [dir, im_sliceEmbed hv, h, zero_smul, smul_zero]

/-- The slice embedding of the opposite direction sees the conjugate
coordinate: `φ_{−v}(w̄) = φ_v(w)`. -/
theorem sliceEmbed_neg_conj (v : Octonion) (w : ℂ) :
    sliceEmbed (-v) ((starRingEnd ℂ) w) = sliceEmbed v w := by
  rw [sliceEmbed, sliceEmbed, Complex.conj_re, Complex.conj_im, neg_smul,
    smul_neg, neg_neg]

/-- The zero-direction junk value is direction-blind: it lands on the real
axis. -/
theorem sliceEmbed_zero_dir (w : ℂ) : sliceEmbed 0 w = ofReal w.re := by
  rw [sliceEmbed, smul_zero, add_zero]

/-- The slice Riemann sphere ℂ_v* = ℂ_v ∪ {∞} = S²_v (master `def:slices`),
as a subset of the compactified 𝕆*. "All slice spheres share the single
point at infinity, as well as the real axis." -/
def sliceSphere (v : Octonion) : Set (OnePoint Octonion) :=
  insert OnePoint.infty ((↑) '' Set.range (sliceEmbed v))

end Octonion

namespace G2

/-! ### The isometry block (master `def:section-map`(ii) proof engine)

The quadratic identity P4.2.a (`Octonion.mul_self_eq`) forces every G₂
element to preserve `re` and `normSq` of non-real elements (uniqueness of
the decomposition `x² = 2(re x)·x − N(x)`); real elements are G₂-fixed
(`G2.smul_ofReal`, proved). Everything DERIVED (R10). -/

theorem smul_add (g : G2) (a b : Octonion) : g • (a + b) = g • a + g • b :=
  g.toEquiv.map_add a b

theorem smul_sub (g : G2) (a b : Octonion) : g • (a - b) = g • a - g • b :=
  g.toEquiv.map_sub a b

theorem smul_rsmul (g : G2) (r : ℝ) (x : Octonion) :
    g • (r • x) = r • (g • x) :=
  g.toEquiv.map_smul r x

/-- G₂ preserves non-reality: automorphisms fix ℝ pointwise, so a
non-real octonion cannot land on the real axis. -/
theorem im_smul_ne_zero (g : G2) {x : Octonion} (hx : Octonion.im x ≠ 0) :
    Octonion.im (g • x) ≠ 0 := by
  intro h0
  apply hx
  have hyr := Octonion.eq_ofReal_of_im_eq_zero h0
  have h1 : g⁻¹ • (g • x) = g⁻¹ • Octonion.ofReal (Octonion.re (g • x)) := by
    rw [← hyr]
  rw [inv_smul_smul, G2.smul_ofReal] at h1
  rw [h1]
  exact Octonion.im_ofReal _

/-- The isometry engine: G₂ preserves the real part and the quadratic
form. Non-real case: the two quadratic identities for `g•x` (its own, and
the g-transport of x's) force the coefficients to agree, since `{g•x, 1}`
is independent when `g•x` is non-real. Real case: `smul_ofReal`. -/
theorem smul_re_normSq (g : G2) (x : Octonion) :
    Octonion.re (g • x) = Octonion.re x ∧
      Octonion.normSq (g • x) = Octonion.normSq x := by
  by_cases hx : Octonion.im x = 0
  · rw [Octonion.eq_ofReal_of_im_eq_zero hx, G2.smul_ofReal]
    exact ⟨rfl, rfl⟩
  · have hy_im : Octonion.im (g • x) ≠ 0 := im_smul_ne_zero g hx
    have h1 : (g • x) * (g • x)
        = (2 * Octonion.re (g • x)) • (g • x)
          - Octonion.ofReal (Octonion.normSq (g • x)) :=
      Octonion.mul_self_eq (g • x)
    have h2 : (g • x) * (g • x)
        = (2 * Octonion.re x) • (g • x)
          - Octonion.ofReal (Octonion.normSq x) := by
      have hxx : g • (x * x)
          = g • ((2 * Octonion.re x) • x - Octonion.ofReal (Octonion.normSq x)) := by
        rw [Octonion.mul_self_eq x]
      rw [G2.smul_mul, smul_sub, smul_rsmul, G2.smul_ofReal] at hxx
      exact hxx
    have key : (2 * Octonion.re x - 2 * Octonion.re (g • x)) • (g • x)
        = (Octonion.normSq x - Octonion.normSq (g • x)) • (1 : Octonion) := by
      have h := h1.symm.trans h2
      rw [Octonion.ofReal_eq_smul_one, Octonion.ofReal_eq_smul_one] at h
      have h' := sub_eq_sub_iff_sub_eq_sub.mp h
      rw [← sub_smul, ← sub_smul] at h'
      have h'' : -((2 * Octonion.re (g • x) - 2 * Octonion.re x) • (g • x))
          = -((Octonion.normSq (g • x) - Octonion.normSq x) • (1 : Octonion)) := by
        rw [h']
      rwa [← neg_smul, ← neg_smul, neg_sub, neg_sub] at h''
    have hre : Octonion.re (g • x) = Octonion.re x := by
      by_contra hne
      have ha : 2 * Octonion.re x - 2 * Octonion.re (g • x) ≠ 0 := by
        intro h0
        apply hne
        linarith
      have hyval : (2 * Octonion.re x - 2 * Octonion.re (g • x))⁻¹
            • ((2 * Octonion.re x - 2 * Octonion.re (g • x)) • (g • x))
          = (2 * Octonion.re x - 2 * Octonion.re (g • x))⁻¹
            • ((Octonion.normSq x - Octonion.normSq (g • x)) • (1 : Octonion)) := by
        rw [key]
      rw [inv_smul_smul₀ ha, smul_smul] at hyval
      apply hy_im
      rw [hyval, ← Octonion.ofReal_eq_smul_one]
      exact Octonion.im_ofReal _
    refine ⟨hre, ?_⟩
    rw [hre, sub_self, zero_smul] at key
    have h0 := congrArg Octonion.re key.symm
    rw [Octonion.re_smul, Octonion.re_one, mul_one,
      show Octonion.re (0 : Octonion) = 0 from rfl] at h0
    linarith

theorem smul_re (g : G2) (x : Octonion) :
    Octonion.re (g • x) = Octonion.re x :=
  (smul_re_normSq g x).1

theorem smul_normSq (g : G2) (x : Octonion) :
    Octonion.normSq (g • x) = Octonion.normSq x :=
  (smul_re_normSq g x).2

theorem smul_norm (g : G2) (x : Octonion) :
    Octonion.norm (g • x) = Octonion.norm x := by
  rw [Octonion.norm, Octonion.norm, smul_normSq]

/-- The imaginary part commutes with the G₂ action. -/
theorem smul_im (g : G2) (x : Octonion) :
    Octonion.im (g • x) = g • Octonion.im x := by
  rw [Octonion.im, Octonion.im, smul_re, smul_sub, G2.smul_ofReal]

/-- The direction commutes with the G₂ action: `dir (g•x) = g • dir x`
(junk-consistent at real points: both sides are 0). -/
theorem smul_dir (g : G2) (x : Octonion) :
    Octonion.dir (g • x) = g • Octonion.dir x := by
  rw [Octonion.dir, Octonion.dir, smul_im, smul_norm, smul_rsmul]

/-- The slice embedding intertwines the G₂ action: `g(φ_v w) = φ_{g v} w`
(linearity + `smul_ofReal`). -/
theorem smul_sliceEmbed (g : G2) (v : Octonion) (ζ : ℂ) :
    g • Octonion.sliceEmbed v ζ = Octonion.sliceEmbed (g • v) ζ := by
  rw [Octonion.sliceEmbed, Octonion.sliceEmbed, smul_add, G2.smul_ofReal,
    smul_rsmul]

theorem smul_onePoint_infty (g : G2) :
    g • (OnePoint.infty : OnePoint Octonion) = OnePoint.infty := rfl

theorem smul_onePoint_coe (g : G2) (x : Octonion) :
    g • ((x : Octonion) : OnePoint Octonion)
      = ((g • x : Octonion) : OnePoint Octonion) := rfl

end G2

namespace ASection

open Classical in
/-- The **realization** of an A-section on the compactified octonions
𝕆* = S⁸ (master `def:section-map`: "A(x + Iy) = F₁(x + iy) + I·F₂(x + iy),
F₁, F₂ ℝ-valued, the same for every I ∈ S⁶"; `rmk:compactify`: the passage
to 𝕆* is a marked derivation node).

Clauses: at a finite point q, the value is φ_{I(q)}(F(σ + iγ)) when the stem
is analytic at the slice coordinate, and ∞ = N at the pole (C1: "its value
there is the point at infinity ∞ = N"); at q = ∞ it is the compactified
value datum. At real q the direction junk is never consumed: the intrinsic
stem is real there (`StemRing.real_on_real`), so the imaginary component of
the formula vanishes. -/
def realize (A : ASection) (q : OnePoint Octonion) : OnePoint Octonion :=
  OnePoint.rec
    (OnePoint.map (fun z : ℂ => Octonion.ofReal z.re) A.valueAtInfinity)
    (fun x =>
      if AnalyticAt ℂ A.F (Octonion.sliceCoord x) then
        ((Octonion.sliceEmbed (Octonion.dir x) (A.F (Octonion.sliceCoord x)) : Octonion) :
          OnePoint Octonion)
      else OnePoint.infty)
    q

open Classical in
/-- The realization at a finite point, unfolded (definitional). -/
theorem realize_coe (A : ASection) (x : Octonion) :
    A.realize (x : OnePoint Octonion)
      = if AnalyticAt ℂ A.F (Octonion.sliceCoord x) then
          ((Octonion.sliceEmbed (Octonion.dir x)
            (A.F (Octonion.sliceCoord x)) : Octonion) : OnePoint Octonion)
        else OnePoint.infty := rfl

/-- The realization at ∞, unfolded (definitional). -/
theorem realize_infty (A : ASection) :
    A.realize OnePoint.infty
      = OnePoint.map (fun z : ℂ => Octonion.ofReal z.re) A.valueAtInfinity :=
  rfl

/-- master `def:section-map`(i) — "*Slice preservation of values.*
A(ℂ_I*) ⊆ ℂ_I* for every I: the value at a point lies on that point's own
slice sphere (Definition def:R)." Proof: q = φ_v(ζ) forces
`im q = ζ.im • v`, so `dir q ∈ {v, −v}` (plus the real junk case, blind by
construction); `φ_{−v}(w̄) = φ_v(w)` and intrinsicality of the stem
symmetrize the negative case. -/
theorem realize_mem_sliceSphere (A : ASection) {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) {q : OnePoint Octonion}
    (hq : q ∈ Octonion.sliceSphere v) :
    A.realize q ∈ Octonion.sliceSphere v := by
  rcases Set.mem_insert_iff.mp hq with rfl | hq'
  · -- q = ∞: the compactified value is ∞ or real, both on every sphere.
    rw [realize_infty]
    induction hval : A.valueAtInfinity using OnePoint.rec with
    | infty => rw [OnePoint.map_infty]; exact Set.mem_insert _ _
    | coe z =>
      rw [OnePoint.map_some]
      exact Set.mem_insert_of_mem _
        ⟨Octonion.ofReal z.re, ⟨(z.re : ℂ), Octonion.sliceEmbed_ofReal v z.re⟩,
          rfl⟩
  · obtain ⟨x, hx, rfl⟩ := hq'
    obtain ⟨ζ, rfl⟩ := hx
    rw [realize_coe]
    by_cases hA : AnalyticAt ℂ A.F (Octonion.sliceCoord (Octonion.sliceEmbed v ζ))
    · rw [if_pos hA]
      rcases lt_trichotomy ζ.im 0 with hneg | hzero | hpos
      · -- lower half-plane: dir = −v, coordinate = ζ̄; intrinsicality flips.
        have hcoord : Octonion.sliceCoord (Octonion.sliceEmbed v ζ)
            = (starRingEnd ℂ) ζ := by
          rw [Octonion.sliceCoord_sliceEmbed hv]
          exact Complex.ext (by rw [Complex.conj_re])
            (by rw [Complex.conj_im, abs_of_neg hneg])
        rw [hcoord, Octonion.dir_sliceEmbed_of_neg hv hneg, A.intrinsic ζ,
          Octonion.sliceEmbed_neg_conj]
        exact Set.mem_insert_of_mem _ ⟨_, ⟨A.F ζ, rfl⟩, rfl⟩
      · -- real point: the direction junk is never consumed (the value is
        -- real by construction of the zero-direction embedding).
        have hcoord : Octonion.sliceCoord (Octonion.sliceEmbed v ζ)
            = (ζ.re : ℂ) := by
          rw [Octonion.sliceCoord_sliceEmbed hv]
          exact Complex.ext (by rw [Complex.ofReal_re])
            (by rw [Complex.ofReal_im, hzero, abs_zero])
        rw [hcoord, Octonion.dir_sliceEmbed_of_im_zero hv hzero,
          Octonion.sliceEmbed_zero_dir]
        exact Set.mem_insert_of_mem _
          ⟨_, ⟨((A.F (ζ.re : ℂ)).re : ℂ), Octonion.sliceEmbed_ofReal v _⟩, rfl⟩
      · -- upper half-plane: dir = v, coordinate = ζ.
        have hcoord : Octonion.sliceCoord (Octonion.sliceEmbed v ζ) = ζ := by
          rw [Octonion.sliceCoord_sliceEmbed hv]
          exact Complex.ext rfl (abs_of_pos hpos)
        rw [hcoord, Octonion.dir_sliceEmbed_of_pos hv hpos]
        exact Set.mem_insert_of_mem _ ⟨_, ⟨A.F ζ, rfl⟩, rfl⟩
    · rw [if_neg hA]
      exact Set.mem_insert _ _

/-- master `def:section-map`(iii) — "*Blindness to the sphere direction.*
On a G₂-orbit S_(σ,γ) the stem coordinates (F₁, F₂)(σ + iγ) are constant; in
particular if A vanishes at one point of the orbit it vanishes on the whole
orbit (Lemma lem:residue-spheres)." Stem-level statement: the slice
coordinate is G₂-invariant — corollary of the isometry block. -/
theorem sliceCoord_smul_invariant (g : G2) (x : Octonion) :
    Octonion.sliceCoord (g • x) = Octonion.sliceCoord x := by
  rw [Octonion.sliceCoord, Octonion.sliceCoord, G2.smul_re, G2.smul_im,
    G2.smul_norm]

/-- master `def:section-map`(ii) — "*G₂-equivariance.* For g ∈ G₂ and
non-real q = x + Iy, A(g·q) = F₁ + g(I)F₂ = g·(F₁ + I F₂) = g·A(q) …; for
q ∈ ℝ ∪ {N} both sides are G₂-fixed." The one I-independent real stem
(Wang Rem. 2.11, SOURCES/Wang.md) against the G₂ slice relabelling: the
slice coordinate is G₂-invariant (`sliceCoord_smul_invariant`), and the
direction is G₂-transported (`G2.smul_dir`). -/
theorem realize_equivariant (A : ASection) (g : G2) (q : OnePoint Octonion) :
    A.realize (g • q) = g • A.realize q := by
  induction q using OnePoint.rec with
  | infty =>
    rw [G2.smul_onePoint_infty, realize_infty]
    induction hval : A.valueAtInfinity using OnePoint.rec with
    | infty => rw [OnePoint.map_infty]; rfl
    | coe z =>
      rw [OnePoint.map_some]
      rw [G2.smul_onePoint_coe, G2.smul_ofReal]
  | coe x =>
    rw [G2.smul_onePoint_coe, realize_coe, realize_coe,
      sliceCoord_smul_invariant g x]
    by_cases hA : AnalyticAt ℂ A.F (Octonion.sliceCoord x)
    · rw [if_pos hA, if_pos hA, G2.smul_onePoint_coe, G2.smul_sliceEmbed,
        ← G2.smul_dir]
    · rw [if_neg hA, if_neg hA]
      rfl

end ASection
