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
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.Analysis.Real.Sqrt
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

/-! ### Linear-algebra helpers for the dimension count (P4.2.e) -/

@[simp] theorem fst_smul (r : ℝ) (x : Octonion) : (r • x).1 = r • x.1 := rfl
@[simp] theorem snd_smul (r : ℝ) (x : Octonion) : (r • x).2 = r • x.2 := rfl

/-- `normSq` is quadratically homogeneous. Componentwise via
`Quaternion.normSq_smul` (Mathlib/Algebra/Quaternion.lean:1091). -/
theorem normSq_smul (r : ℝ) (x : Octonion) : normSq (r • x) = r ^ 2 * normSq x := by
  show Quaternion.normSq (r • x.1) + Quaternion.normSq (r • x.2)
      = r ^ 2 * (Quaternion.normSq x.1 + Quaternion.normSq x.2)
  rw [Quaternion.normSq_smul, Quaternion.normSq_smul]
  ring

/-- Additivity of the polarization form in its first argument.
Componentwise via `innerO_def'`. -/
theorem innerO_add_left (x y z : Octonion) :
    innerO (x + y) z = innerO x z + innerO y z := by
  rw [innerO_def', innerO_def', innerO_def']
  simp only [fst_add, snd_add, Quaternion.re_add, Quaternion.imI_add,
    Quaternion.imJ_add, Quaternion.imK_add]
  ring

/-- Homogeneity of the polarization form in its first argument.
Componentwise via `innerO_def'`. -/
theorem innerO_smul_left (r : ℝ) (x y : Octonion) :
    innerO (r • x) y = r * innerO x y := by
  rw [innerO_def', innerO_def']
  simp only [fst_smul, snd_smul, Quaternion.re_smul, Quaternion.imI_smul,
    Quaternion.imJ_smul, Quaternion.imK_smul, smul_eq_mul]
  ring

/-- Positive definiteness of `normSq`. Componentwise via
`Quaternion.normSq_nonneg`/`normSq_ne_zero` (Mathlib/Algebra/Quaternion.lean:1121–1124). -/
theorem normSq_pos_of_ne_zero {x : Octonion} (hx : x ≠ 0) : 0 < normSq x := by
  have h1 : (0 : ℝ) ≤ Quaternion.normSq x.1 := Quaternion.normSq_nonneg
  have h2 : (0 : ℝ) ≤ Quaternion.normSq x.2 := Quaternion.normSq_nonneg
  show 0 < Quaternion.normSq x.1 + Quaternion.normSq x.2
  rcases eq_or_ne x.1 0 with hx1 | hx1
  · have hx2 : x.2 ≠ 0 := fun h => hx (Prod.ext hx1 h)
    have : Quaternion.normSq x.2 ≠ 0 := Quaternion.normSq_ne_zero.mpr hx2
    have := lt_of_le_of_ne h2 (Ne.symm this)
    linarith
  · have : Quaternion.normSq x.1 ≠ 0 := Quaternion.normSq_ne_zero.mpr hx1
    have := lt_of_le_of_ne h1 (Ne.symm this)
    linarith

/-- Normalization: a nonzero octonion scaled by the inverse of its Euclidean
norm has unit `normSq`. `Real.sq_sqrt` (Mathlib/Analysis/Real/Sqrt.lean:178). -/
theorem normSq_normalize {x : Octonion} (hx : x ≠ 0) :
    normSq ((Real.sqrt (normSq x))⁻¹ • x) = 1 := by
  have hpos := normSq_pos_of_ne_zero hx
  rw [normSq_smul, inv_pow, Real.sq_sqrt hpos.le]
  exact inv_mul_cancel₀ hpos.ne'

/-- `innerO` bundled as an ℝ-linear map in its first argument. -/
def innerOLinear (y : Octonion) : Octonion →ₗ[ℝ] ℝ where
  toFun x := innerO x y
  map_add' x x' := innerO_add_left x x' y
  map_smul' r x := innerO_smul_left r x y

@[simp] theorem innerOLinear_apply (y x : Octonion) : innerOLinear y x = innerO x y := rfl

instance : FiniteDimensional ℝ Octonion :=
  inferInstanceAs (FiniteDimensional ℝ (Quaternion ℝ × Quaternion ℝ))

/-- 𝕆 is 8-dimensional over ℝ: the Cayley–Dickson double of the
4-dimensional ℍ (`Quaternion.finrank_eq_four`,
Mathlib/Algebra/Quaternion.lean:972; `Module.finrank_prod`,
Mathlib/LinearAlgebra/Dimension/Constructions.lean:161). -/
theorem finrank_eq_eight : Module.finrank ℝ Octonion = 8 := by
  have h : Module.finrank ℝ (Quaternion ℝ × Quaternion ℝ) = 8 := by
    rw [Module.finrank_prod, Quaternion.finrank_eq_four]
  exact h

/-- P4.2.e — every unit imaginary extends to a basic triple. Dimension count
in the 8-dimensional positive-definite form: rank-nullity
(`LinearMap.ker_ne_bot_of_finrank_lt`,
Mathlib/LinearAlgebra/FiniteDimensional/Lemmas.lean:178) produces a nonzero
vector orthogonal to `{1, u}` (normalized: `w`), then one orthogonal to
`{1, u, w, u·w}` (normalized: `z`). -/
theorem exists_basicTriple (u : Octonion) (hu : u ∈ unitImaginarySphere) :
    ∃ T : BasicTriple, T.u = u := by
  -- Step 1: a nonzero x ⊥ {1, u}.
  have hdim2 : Module.finrank ℝ (ℝ × ℝ) < Module.finrank ℝ Octonion := by
    rw [finrank_eq_eight, Module.finrank_prod, Module.finrank_self]
    norm_num
  obtain ⟨x, hxker, hx0⟩ := (Submodule.ne_bot_iff _).mp
    (LinearMap.ker_ne_bot_of_finrank_lt
      (f := (innerOLinear 1).prod (innerOLinear u)) hdim2)
  have hfx := LinearMap.mem_ker.mp hxker
  have hx1 : innerO x 1 = 0 := congrArg Prod.fst hfx
  have hxu : innerO x u = 0 := congrArg Prod.snd hfx
  -- Normalize to w.
  set c : ℝ := (Real.sqrt (normSq x))⁻¹ with hc
  set w : Octonion := c • x with hwdef
  have hNw : normSq w = 1 := normSq_normalize hx0
  have hrw : re w = 0 := by
    rw [← innerO_one w, hwdef, innerO_smul_left, hx1, mul_zero]
  have huw : innerO u w = 0 := by
    rw [innerO_comm, hwdef, innerO_smul_left, hxu, mul_zero]
  -- Step 2: a nonzero y ⊥ {1, u, w, u·w}.
  have hdim4 : Module.finrank ℝ (ℝ × ℝ × ℝ × ℝ) < Module.finrank ℝ Octonion := by
    rw [finrank_eq_eight, Module.finrank_prod, Module.finrank_prod,
      Module.finrank_prod, Module.finrank_self]
    norm_num
  obtain ⟨y, hyker, hy0⟩ := (Submodule.ne_bot_iff _).mp
    (LinearMap.ker_ne_bot_of_finrank_lt
      (f := (innerOLinear 1).prod ((innerOLinear u).prod
        ((innerOLinear w).prod (innerOLinear (u * w)))) ) hdim4)
  have hfy := LinearMap.mem_ker.mp hyker
  have hy1 : innerO y 1 = 0 := congrArg Prod.fst hfy
  have hyu : innerO y u = 0 := congrArg Prod.fst (congrArg Prod.snd hfy)
  have hyw : innerO y w = 0 :=
    congrArg Prod.fst (congrArg Prod.snd (congrArg Prod.snd hfy))
  have hyuw : innerO y (u * w) = 0 :=
    congrArg Prod.snd (congrArg Prod.snd (congrArg Prod.snd hfy))
  -- Normalize to z.
  set d : ℝ := (Real.sqrt (normSq y))⁻¹ with hd
  set z : Octonion := d • y with hzdef
  have hNz : normSq z = 1 := normSq_normalize hy0
  have hrz : re z = 0 := by
    rw [← innerO_one z, hzdef, innerO_smul_left, hy1, mul_zero]
  have huz : innerO u z = 0 := by
    rw [innerO_comm, hzdef, innerO_smul_left, hyu, mul_zero]
  have hwz : innerO w z = 0 := by
    rw [innerO_comm, hzdef, innerO_smul_left, hyw, mul_zero]
  have hmulz : innerO (u * w) z = 0 := by
    rw [innerO_comm, hzdef, innerO_smul_left, hyuw, mul_zero]
  exact ⟨⟨u, w, z, hu, ⟨hrw, hNw⟩, ⟨hrz, hNz⟩, huw, huz, hwz, hmulz⟩, rfl⟩

end Octonion
