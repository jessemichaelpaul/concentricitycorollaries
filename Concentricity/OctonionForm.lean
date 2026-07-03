/-
Concentricity/OctonionForm.lean

The polarization form of `normSq` and the composition-algebra identities on
𝕆 — the machinery for Phase 4 #2 (`thm:G2-S6` transitivity, PHASE4_PLAN),
also consumed by #7 (the isometry block).

Register (R10): everything here is DERIVED — proved in-repo from the
Cayley–Dickson construction, `normSq_mul` (proved, Degen), and
alternativity (proved). Baez02/Schafer66 are faithfulness glosses for the
composition-algebra vocabulary, never load.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.Octonion
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Abel

noncomputable section

namespace Octonion

/-- The polarization bilinear form of `normSq`:
`⟪x, y⟫ = (N(x+y) − N(x) − N(y))/2`. -/
def innerO (x y : Octonion) : ℝ := (normSq (x + y) - normSq x - normSq y) / 2

theorem innerO_comm (x y : Octonion) : innerO x y = innerO y x := by
  rw [innerO, innerO, add_comm x y]
  ring

/-- `⟪x, 1⟫ = re x` — the form sees the real part. Componentwise. -/
theorem innerO_one (x : Octonion) : innerO x 1 = re x := by
  have hq : Quaternion.normSq (x.1 + 1) = Quaternion.normSq x.1 + 2 * x.1.re + 1 := by
    simp only [Quaternion.normSq_def', Quaternion.re_add, Quaternion.imI_add,
      Quaternion.imJ_add, Quaternion.imK_add, Quaternion.re_one, Quaternion.imI_one,
      Quaternion.imJ_one, Quaternion.imK_one]
    ring
  have h2 : (x + 1).2 = x.2 := by
    show x.2 + 0 = x.2
    rw [add_zero]
  show (normSq (x + 1) - normSq x - normSq 1) / 2 = re x
  rw [normSq_one,
    show normSq (x + 1) = Quaternion.normSq ((x + 1).1) + Quaternion.normSq ((x + 1).2) from rfl,
    h2, show (x + 1).1 = x.1 + 1 from rfl, hq]
  show (Quaternion.normSq x.1 + 2 * x.1.re + 1 + Quaternion.normSq x.2
      - (Quaternion.normSq x.1 + Quaternion.normSq x.2) - 1) / 2 = x.1.re
  ring

/-- The explicit coordinate form of the polarization: `⟪x, y⟫` is the
Euclidean pairing of the 8 real coordinates. Componentwise. -/
theorem innerO_def' (x y : Octonion) :
    innerO x y = x.1.re * y.1.re + x.1.imI * y.1.imI + x.1.imJ * y.1.imJ
      + x.1.imK * y.1.imK + x.2.re * y.2.re + x.2.imI * y.2.imI
      + x.2.imJ * y.2.imJ + x.2.imK * y.2.imK := by
  show (Quaternion.normSq (x.1 + y.1) + Quaternion.normSq (x.2 + y.2)
      - (Quaternion.normSq x.1 + Quaternion.normSq x.2)
      - (Quaternion.normSq y.1 + Quaternion.normSq y.2)) / 2 = _
  simp only [Quaternion.normSq_def', Quaternion.re_add, Quaternion.imI_add,
    Quaternion.imJ_add, Quaternion.imK_add]
  ring

theorem innerO_neg_right (x y : Octonion) : innerO x (-y) = -innerO x y := by
  rw [innerO_def', innerO_def']
  simp only [fst_neg, snd_neg, Quaternion.re_neg, Quaternion.imI_neg,
    Quaternion.imJ_neg, Quaternion.imK_neg]
  ring

/-- P4.2.a — the quadratic identity: `x² = 2(re x)·x − N(x)` (the minimal
polynomial of an octonion over ℝ). Componentwise from `mul_def` and the
quaternionic quadratic identity `a² = (a + a*)a − a*a`. Also the engine of
the Phase-4 #7 isometry block. -/
theorem mul_self_eq (x : Octonion) :
    x * x = (2 * re x) • x - ofReal (normSq x) := by
  have ha : x.1 * x.1
      = ((2 * x.1.re : ℝ) : Quaternion ℝ) * x.1 - ((Quaternion.normSq x.1 : ℝ) : Quaternion ℝ) := by
    have h1 := Quaternion.self_add_star' x.1
    have h2 := Quaternion.star_mul_self x.1
    calc x.1 * x.1 = (x.1 + star x.1) * x.1 - star x.1 * x.1 := by noncomm_ring
    _ = ((2 * x.1.re : ℝ) : Quaternion ℝ) * x.1 - ((Quaternion.normSq x.1 : ℝ) : Quaternion ℝ) := by
        rw [h1, h2]
  refine Prod.ext ?_ ?_
  · show x.1 * x.1 - star x.2 * x.2
        = (2 * re x) • x.1 - ((Quaternion.normSq x.1 + Quaternion.normSq x.2 : ℝ) : Quaternion ℝ)
    rw [ha, Quaternion.star_mul_self, Quaternion.coe_add, Quaternion.coe_mul_eq_smul, sub_sub]
    rfl
  · show x.2 * x.1 + x.2 * star x.1 = (2 * re x) • x.2 - 0
    rw [← mul_add, Quaternion.self_add_star', Quaternion.mul_coe_eq_smul, sub_zero]
    rfl

/-- P4.2.b — composition polarized on the left:
`⟪x·y, x·z⟫ = N(x)·⟪y, z⟫`. Polarizes `normSq_mul` (proved, Degen) in the
second argument through left distributivity. -/
theorem innerO_mul_mul_left (x y z : Octonion) :
    innerO (x * y) (x * z) = normSq x * innerO y z := by
  rw [innerO, innerO, ← mul_add, normSq_mul, normSq_mul, normSq_mul]
  ring

/-- P4.2.b′ — composition polarized on the right. -/
theorem innerO_mul_mul_right (x y z : Octonion) :
    innerO (x * z) (y * z) = innerO x y * normSq z := by
  rw [innerO, innerO, ← add_mul, normSq_mul, normSq_mul, normSq_mul]
  ring

/-- P4.2.c — orthogonal imaginary octonions anticommute:
`re x = re y = 0` and `⟪x, y⟫ = 0` force `x·y = −(y·x)`. Linearizes the
quadratic identity P4.2.a at `x + y`. -/
theorem mul_anticomm_of_orthogonal {x y : Octonion}
    (hx : re x = 0) (hy : re y = 0) (hxy : innerO x y = 0) :
    x * y = -(y * x) := by
  have hre : re (x + y) = 0 := by
    show x.1.re + y.1.re = 0
    rw [show x.1.re = re x from rfl, show y.1.re = re y from rfl, hx, hy, add_zero]
  have hN : normSq (x + y) = normSq x + normSq y := by
    have h := hxy
    rw [innerO] at h
    linarith
  have h := mul_self_eq (x + y)
  rw [hre, mul_zero, zero_smul, zero_sub, hN] at h
  have hxx := mul_self_eq x
  rw [hx, mul_zero, zero_smul, zero_sub] at hxx
  have hyy := mul_self_eq y
  rw [hy, mul_zero, zero_smul, zero_sub] at hyy
  have hofadd : ofReal (normSq x + normSq y) = ofReal (normSq x) + ofReal (normSq y) := by
    refine Prod.ext ?_ ?_
    · show ((normSq x + normSq y : ℝ) : Quaternion ℝ)
          = ((normSq x : ℝ) : Quaternion ℝ) + ((normSq y : ℝ) : Quaternion ℝ)
      rw [Quaternion.coe_add]
    · show (0 : Quaternion ℝ) = 0 + 0
      rw [add_zero]
  have hexp : (x + y) * (x + y) = x * x + x * y + (y * x + y * y) := by
    rw [add_mul, mul_add, mul_add]
  rw [hexp, hxx, hyy, hofadd] at h
  have hsum : x * y + y * x = 0 := by
    have h2 : x * y + y * x - (ofReal (normSq x) + ofReal (normSq y))
        = -(ofReal (normSq x) + ofReal (normSq y)) := by
      calc x * y + y * x - (ofReal (normSq x) + ofReal (normSq y))
          = -ofReal (normSq x) + x * y + (y * x + -ofReal (normSq y)) := by abel
        _ = -(ofReal (normSq x) + ofReal (normSq y)) := h
    have h3 := congrArg (fun t => t + (ofReal (normSq x) + ofReal (normSq y))) h2
    simpa using h3
  exact eq_neg_of_add_eq_zero_left hsum

/-- P4.2.d — the product of orthogonal unit imaginaries is a unit imaginary
orthogonal to both factors. Composition (P4.2.b/b′) against `u·1`, `1·w`,
and `u·u = −1` (proved, Octonion.lean). -/
theorem mul_mem_unitImaginarySphere_of_orthogonal {u w : Octonion}
    (hu : u ∈ unitImaginarySphere) (hw : w ∈ unitImaginarySphere)
    (huw : innerO u w = 0) :
    u * w ∈ unitImaginarySphere ∧ innerO u (u * w) = 0 ∧ innerO w (u * w) = 0 := by
  obtain ⟨hru, hNu⟩ := hu
  obtain ⟨hrw, hNw⟩ := hw
  have huu : u * u = -1 := sq_eq_neg_one_of_mem_unitImaginarySphere ⟨hru, hNu⟩
  have h3 : innerO u (u * w) = 0 := by
    have h := innerO_mul_mul_left u 1 w
    rw [Octonion.mul_one, innerO_comm 1 w, innerO_one, hrw] at h
    simpa using h
  have h4 : innerO w (u * w) = 0 := by
    have h := innerO_mul_mul_right 1 u w
    rw [Octonion.one_mul, innerO_comm 1 u, innerO_one, hru] at h
    simpa using h
  have h2 : normSq (u * w) = 1 := by
    rw [normSq_mul, hNu, hNw]
    norm_num
  have h1 : re (u * w) = 0 := by
    have h := innerO_mul_mul_left u w u
    rw [huu, innerO_comm w u, huw, innerO_neg_right] at h
    simp only [mul_zero, neg_eq_zero] at h
    rw [innerO_one] at h
    exact h
  exact ⟨⟨h1, h2⟩, h3, h4⟩

/-- A **basic triple**: pairwise-orthogonal unit imaginaries with the third
orthogonal to the quaternion subalgebra of the first two (Baez §4
vocabulary; faithfulness gloss, never load). Every basic triple frames
𝕆 by `(1, u, w, uw, z, uz, wz, (uw)z)`. -/
structure BasicTriple where
  u : Octonion
  w : Octonion
  z : Octonion
  hu : u ∈ unitImaginarySphere
  hw : w ∈ unitImaginarySphere
  hz : z ∈ unitImaginarySphere
  huw : innerO u w = 0
  huz : innerO u z = 0
  hwz : innerO w z = 0
  hmulz : innerO (u * w) z = 0

/-- P4.2.e — every unit imaginary extends to a basic triple. Queued (R8):
dimension count in the 8-dimensional positive-definite form (the orthogonal
complement of a span of ≤ 4 vectors contains a unit imaginary). -/
theorem exists_basicTriple (u : Octonion) (hu : u ∈ unitImaginarySphere) :
    ∃ T : BasicTriple, T.u = u := by
  sorry

end Octonion
