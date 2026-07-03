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
import Mathlib.LinearAlgebra.Basis.Defs
import Mathlib.LinearAlgebra.LinearIndependent.Defs
import Mathlib.Analysis.Real.Sqrt
import Mathlib.Data.Fin.VecNotation
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
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

/-! ### Further polarization identities (P4.2.f machinery)

Everything below is DERIVED (R10) from the proved stock: `normSq_mul`
(Degen), the polarized composition identities P4.2.b/b′, the quadratic
identity P4.2.a, anticommutation P4.2.c, `alt_left`/`alt_right`
(Octonion.lean, proved). Baez §4 is a faithfulness gloss, never load. -/

theorem innerO_add_right (x y z : Octonion) :
    innerO x (y + z) = innerO x y + innerO x z := by
  rw [innerO_comm x, innerO_add_left, innerO_comm y, innerO_comm z]

theorem innerO_neg_left (x y : Octonion) : innerO (-x) y = -innerO x y := by
  rw [innerO_comm, innerO_neg_right, innerO_comm y x]

theorem innerO_one_left (x : Octonion) : innerO 1 x = re x := by
  rw [innerO_comm, innerO_one]

/-- The form against itself is the quadratic form. Componentwise. -/
theorem innerO_self (x : Octonion) : innerO x x = normSq x := by
  rw [innerO_def']
  show _ = Quaternion.normSq x.1 + Quaternion.normSq x.2
  rw [Quaternion.normSq_def', Quaternion.normSq_def']
  ring

/-- The parallelogram expansion of `normSq` — the polarization identity
read backwards. -/
theorem normSq_add_eq (x y : Octonion) :
    normSq (x + y) = normSq x + normSq y + 2 * innerO x y := by
  rw [innerO]; ring

/-- The **exchange identity**: full polarization of the composition law
P4.2.b in its first slot —
`⟪a·b, c·d⟫ + ⟪c·b, a·d⟫ = 2·⟪a,c⟫·⟪b,d⟫`. -/
theorem innerO_mul_exchange (a b c d : Octonion) :
    innerO (a * b) (c * d) + innerO (c * b) (a * d)
      = 2 * innerO a c * innerO b d := by
  have h := innerO_mul_mul_left (a + c) b d
  simp only [add_mul, innerO_add_left, innerO_add_right, innerO_mul_mul_left,
    normSq_add_eq] at h
  linear_combination h

/-- Exchange with `d = 1`: the trace-form adjointness
`⟪a·b, c⟫ + ⟪c·b, a⟫ = 2·⟪a,c⟫·re b`. -/
theorem innerO_mul_right_adjoint (a b c : Octonion) :
    innerO (a * b) c + innerO (c * b) a = 2 * innerO a c * re b := by
  have h := innerO_mul_exchange a b c 1
  rwa [Octonion.mul_one, Octonion.mul_one, innerO_one] at h

/-- Exchange with `c = 1`: the trace-form adjointness
`⟪a·b, d⟫ + ⟪b, a·d⟫ = 2·(re a)·⟪b,d⟫`. -/
theorem innerO_mul_left_adjoint (a b d : Octonion) :
    innerO (a * b) d + innerO b (a * d) = 2 * re a * innerO b d := by
  have h := innerO_mul_exchange a b 1 d
  rwa [Octonion.one_mul, Octonion.one_mul, innerO_one] at h

/-! ### Scalar–multiplication compatibility of the Cayley–Dickson product -/

instance : IsScalarTower ℝ Octonion Octonion :=
  ⟨fun r x y => by
    show (r • x) * y = r • (x * y)
    refine Prod.ext ?_ ?_
    · show (r • x.1) * y.1 - star y.2 * (r • x.2)
          = r • (x.1 * y.1 - star y.2 * x.2)
      rw [smul_sub, smul_mul_assoc, mul_smul_comm]
    · show y.2 * (r • x.1) + (r • x.2) * star y.1
          = r • (y.2 * x.1 + x.2 * star y.1)
      rw [smul_add, mul_smul_comm, smul_mul_assoc]⟩

instance : SMulCommClass ℝ Octonion Octonion :=
  ⟨fun r x y => by
    show r • (x * y) = x * (r • y)
    refine Prod.ext ?_ ?_
    · show r • (x.1 * y.1 - star y.2 * x.2)
          = x.1 * (r • y.1) - star (r • y.2) * x.2
      rw [Quaternion.star_smul, smul_sub, mul_smul_comm, smul_mul_assoc]
    · show r • (y.2 * x.1 + x.2 * star y.1)
          = (r • y.2) * x.1 + x.2 * star (r • y.1)
      rw [Quaternion.star_smul, smul_add, smul_mul_assoc, mul_smul_comm]⟩

/-! ### Linearized alternativity -/

/-- Left alternativity, linearized at `a + b`:
`(a·b)·c + (b·a)·c = a·(b·c) + b·(a·c)`. -/
theorem mul_alt_left_linear (a b c : Octonion) :
    (a * b) * c + (b * a) * c = a * (b * c) + b * (a * c) := by
  have h : (a * a) * c + ((a * b) * c + (b * a) * c) + (b * b) * c
      = a * (a * c) + (a * (b * c) + b * (a * c)) + b * (b * c) := by
    calc (a * a) * c + ((a * b) * c + (b * a) * c) + (b * b) * c
        = ((a + b) * (a + b)) * c := by simp only [add_mul, mul_add]; abel
      _ = (a + b) * ((a + b) * c) := alt_left (a + b) c
      _ = a * (a * c) + (a * (b * c) + b * (a * c)) + b * (b * c) := by
          simp only [add_mul, mul_add]; abel
  rw [alt_left a c, alt_left b c] at h
  exact add_left_cancel (add_right_cancel h)

/-- Right alternativity, linearized at `b + c`:
`a·(b·c) + a·(c·b) = (a·b)·c + (a·c)·b`. -/
theorem mul_alt_right_linear (a b c : Octonion) :
    a * (b * c) + a * (c * b) = (a * b) * c + (a * c) * b := by
  have h : a * (b * b) + (a * (b * c) + a * (c * b)) + a * (c * c)
      = (a * b) * b + ((a * b) * c + (a * c) * b) + (a * c) * c := by
    calc a * (b * b) + (a * (b * c) + a * (c * b)) + a * (c * c)
        = a * ((b + c) * (b + c)) := by simp only [add_mul, mul_add]; abel
      _ = (a * (b + c)) * (b + c) := alt_right a (b + c)
      _ = (a * b) * b + ((a * b) * c + (a * c) * b) + (a * c) * c := by
          simp only [add_mul, mul_add]; abel
  rw [alt_right a b, alt_right a c] at h
  exact add_left_cancel (add_right_cancel h)

/-- For a unit imaginary `v`: `v·(v·x) = −x` (left alternativity +
`v² = −1`). -/
theorem self_mul_mul {v : Octonion} (hv : v ∈ unitImaginarySphere)
    (x : Octonion) : v * (v * x) = -x := by
  rw [← alt_left, sq_eq_neg_one_of_mem_unitImaginarySphere hv, neg_mul,
    Octonion.one_mul]

/-- For a unit imaginary `v`: `(x·v)·v = −x` (right alternativity +
`v² = −1`). -/
theorem mul_mul_self {v : Octonion} (hv : v ∈ unitImaginarySphere)
    (x : Octonion) : (x * v) * v = -x := by
  rw [← alt_right, sq_eq_neg_one_of_mem_unitImaginarySphere hv, mul_neg,
    Octonion.mul_one]

namespace BasicTriple

variable (T : BasicTriple)

/-! ### The frame of a basic triple: membership and Gram facts (P4.2.f)

All entries of the Gram matrix of `(1, u, w, uw, z, uz, wz, (uw)z)` are
derived from the triple's orthogonality fields through P4.2.d and the
exchange identity. -/

theorem uw_mem : T.u * T.w ∈ unitImaginarySphere :=
  (mul_mem_unitImaginarySphere_of_orthogonal T.hu T.hw T.huw).1

theorem innerO_u_uw : innerO T.u (T.u * T.w) = 0 :=
  (mul_mem_unitImaginarySphere_of_orthogonal T.hu T.hw T.huw).2.1

theorem innerO_w_uw : innerO T.w (T.u * T.w) = 0 :=
  (mul_mem_unitImaginarySphere_of_orthogonal T.hu T.hw T.huw).2.2

theorem uz_mem : T.u * T.z ∈ unitImaginarySphere :=
  (mul_mem_unitImaginarySphere_of_orthogonal T.hu T.hz T.huz).1

theorem innerO_u_uz : innerO T.u (T.u * T.z) = 0 :=
  (mul_mem_unitImaginarySphere_of_orthogonal T.hu T.hz T.huz).2.1

theorem innerO_z_uz : innerO T.z (T.u * T.z) = 0 :=
  (mul_mem_unitImaginarySphere_of_orthogonal T.hu T.hz T.huz).2.2

theorem wz_mem : T.w * T.z ∈ unitImaginarySphere :=
  (mul_mem_unitImaginarySphere_of_orthogonal T.hw T.hz T.hwz).1

theorem innerO_w_wz : innerO T.w (T.w * T.z) = 0 :=
  (mul_mem_unitImaginarySphere_of_orthogonal T.hw T.hz T.hwz).2.1

theorem innerO_z_wz : innerO T.z (T.w * T.z) = 0 :=
  (mul_mem_unitImaginarySphere_of_orthogonal T.hw T.hz T.hwz).2.2

theorem uwz_mem : (T.u * T.w) * T.z ∈ unitImaginarySphere :=
  (mul_mem_unitImaginarySphere_of_orthogonal T.uw_mem T.hz T.hmulz).1

theorem innerO_uw_uwz : innerO (T.u * T.w) ((T.u * T.w) * T.z) = 0 :=
  (mul_mem_unitImaginarySphere_of_orthogonal T.uw_mem T.hz T.hmulz).2.1

theorem innerO_z_uwz : innerO T.z ((T.u * T.w) * T.z) = 0 :=
  (mul_mem_unitImaginarySphere_of_orthogonal T.uw_mem T.hz T.hmulz).2.2

/-- `z ⊥ uw` transports to `w ⊥ uz` through the exchange identity. -/
theorem innerO_w_uz : innerO T.w (T.u * T.z) = 0 := by
  have h := innerO_mul_left_adjoint T.u T.w T.z
  rw [T.hmulz, T.hu.1, T.hwz] at h
  linarith

/-- `z ⊥ uw` transports to `u ⊥ wz` through the exchange identity. -/
theorem innerO_u_wz : innerO T.u (T.w * T.z) = 0 := by
  have h := innerO_mul_left_adjoint T.w T.u T.z
  rw [mul_anticomm_of_orthogonal T.hw.1 T.hu.1
      (by rw [innerO_comm]; exact T.huw),
    innerO_neg_left, T.hmulz, T.hw.1, T.huz] at h
  linarith

theorem innerO_uw_uz : innerO (T.u * T.w) (T.u * T.z) = 0 := by
  rw [innerO_mul_mul_left, T.hwz, mul_zero]

theorem innerO_uz_wz : innerO (T.u * T.z) (T.w * T.z) = 0 := by
  rw [innerO_mul_mul_right, T.huw, zero_mul]

theorem innerO_uw_wz : innerO (T.u * T.w) (T.w * T.z) = 0 := by
  have h := innerO_mul_exchange T.u T.w T.w T.z
  rw [sq_eq_neg_one_of_mem_unitImaginarySphere T.hw, innerO_neg_left,
    innerO_one_left, T.uz_mem.1, T.huw, T.hwz] at h
  linarith

theorem innerO_uz_uwz : innerO (T.u * T.z) ((T.u * T.w) * T.z) = 0 := by
  rw [innerO_mul_mul_right, T.innerO_u_uw, zero_mul]

theorem innerO_wz_uwz : innerO (T.w * T.z) ((T.u * T.w) * T.z) = 0 := by
  rw [innerO_mul_mul_right, T.innerO_w_uw, zero_mul]

theorem innerO_u_uwz : innerO T.u ((T.u * T.w) * T.z) = 0 := by
  have h := innerO_mul_right_adjoint (T.u * T.w) T.z T.u
  rw [innerO_comm (T.u * T.z), T.innerO_uw_uz,
    innerO_comm (T.u * T.w) T.u, T.innerO_u_uw, T.hz.1] at h
  rw [innerO_comm]
  linarith

theorem innerO_w_uwz : innerO T.w ((T.u * T.w) * T.z) = 0 := by
  have h := innerO_mul_right_adjoint (T.u * T.w) T.z T.w
  rw [innerO_comm (T.w * T.z), T.innerO_uw_wz,
    innerO_comm (T.u * T.w) T.w, T.innerO_w_uw, T.hz.1] at h
  rw [innerO_comm]
  linarith

/-! ### The multiplication table of the frame (P4.2.f — the hard part)

Every product of two frame elements, derived from the proved stock:
`sq_eq_neg_one_of_mem_unitImaginarySphere`, P4.2.c anticommutation,
`self_mul_mul`/`mul_mul_self`, and the two linearized alternative laws.
The table is universal — the same right-hand sides for every basic
triple — which is exactly what makes the frame-matching linear map
multiplicative. -/

theorem mul_u_u : T.u * T.u = -1 :=
  sq_eq_neg_one_of_mem_unitImaginarySphere T.hu

theorem mul_w_w : T.w * T.w = -1 :=
  sq_eq_neg_one_of_mem_unitImaginarySphere T.hw

theorem mul_z_z : T.z * T.z = -1 :=
  sq_eq_neg_one_of_mem_unitImaginarySphere T.hz

theorem mul_uw_uw : (T.u * T.w) * (T.u * T.w) = -1 :=
  sq_eq_neg_one_of_mem_unitImaginarySphere T.uw_mem

theorem mul_uz_uz : (T.u * T.z) * (T.u * T.z) = -1 :=
  sq_eq_neg_one_of_mem_unitImaginarySphere T.uz_mem

theorem mul_wz_wz : (T.w * T.z) * (T.w * T.z) = -1 :=
  sq_eq_neg_one_of_mem_unitImaginarySphere T.wz_mem

theorem mul_uwz_uwz : ((T.u * T.w) * T.z) * ((T.u * T.w) * T.z) = -1 :=
  sq_eq_neg_one_of_mem_unitImaginarySphere T.uwz_mem

theorem mul_w_u : T.w * T.u = -(T.u * T.w) :=
  mul_anticomm_of_orthogonal T.hw.1 T.hu.1
    (by rw [innerO_comm]; exact T.huw)

theorem mul_z_u : T.z * T.u = -(T.u * T.z) :=
  mul_anticomm_of_orthogonal T.hz.1 T.hu.1
    (by rw [innerO_comm]; exact T.huz)

theorem mul_z_w : T.z * T.w = -(T.w * T.z) :=
  mul_anticomm_of_orthogonal T.hz.1 T.hw.1
    (by rw [innerO_comm]; exact T.hwz)

theorem mul_z_uw : T.z * (T.u * T.w) = -((T.u * T.w) * T.z) :=
  mul_anticomm_of_orthogonal T.hz.1 T.uw_mem.1
    (by rw [innerO_comm]; exact T.hmulz)

theorem mul_u_uw : T.u * (T.u * T.w) = -T.w := self_mul_mul T.hu T.w

theorem mul_u_uz : T.u * (T.u * T.z) = -T.z := self_mul_mul T.hu T.z

theorem mul_w_wz : T.w * (T.w * T.z) = -T.z := self_mul_mul T.hw T.z

theorem mul_uw_uwz : (T.u * T.w) * ((T.u * T.w) * T.z) = -T.z :=
  self_mul_mul T.uw_mem T.z

theorem mul_uz_z : (T.u * T.z) * T.z = -T.u := mul_mul_self T.hz T.u

theorem mul_wz_z : (T.w * T.z) * T.z = -T.w := mul_mul_self T.hz T.w

theorem mul_uwz_z : ((T.u * T.w) * T.z) * T.z = -(T.u * T.w) :=
  mul_mul_self T.hz (T.u * T.w)

theorem mul_w_uw : T.w * (T.u * T.w) = T.u := by
  rw [mul_anticomm_of_orthogonal T.hu.1 T.hw.1 T.huw, mul_neg,
    self_mul_mul T.hw T.u, neg_neg]

theorem mul_z_uz : T.z * (T.u * T.z) = T.u := by
  rw [mul_anticomm_of_orthogonal T.hu.1 T.hz.1 T.huz, mul_neg,
    self_mul_mul T.hz T.u, neg_neg]

theorem mul_z_wz : T.z * (T.w * T.z) = T.w := by
  rw [mul_anticomm_of_orthogonal T.hw.1 T.hz.1 T.hwz, mul_neg,
    self_mul_mul T.hz T.w, neg_neg]

theorem mul_z_uwz : T.z * ((T.u * T.w) * T.z) = T.u * T.w := by
  rw [mul_anticomm_of_orthogonal T.uw_mem.1 T.hz.1 T.hmulz, mul_neg,
    self_mul_mul T.hz (T.u * T.w), neg_neg]

theorem mul_uw_u : (T.u * T.w) * T.u = T.w := by
  rw [mul_anticomm_of_orthogonal T.uw_mem.1 T.hu.1
      (by rw [innerO_comm]; exact T.innerO_u_uw),
    T.mul_u_uw, neg_neg]

theorem mul_uw_w : (T.u * T.w) * T.w = -T.u := by
  rw [mul_anticomm_of_orthogonal T.uw_mem.1 T.hw.1
      (by rw [innerO_comm]; exact T.innerO_w_uw),
    T.mul_w_uw]

theorem mul_uz_u : (T.u * T.z) * T.u = T.z := by
  rw [mul_anticomm_of_orthogonal T.uz_mem.1 T.hu.1
      (by rw [innerO_comm]; exact T.innerO_u_uz),
    T.mul_u_uz, neg_neg]

theorem mul_wz_w : (T.w * T.z) * T.w = T.z := by
  rw [mul_anticomm_of_orthogonal T.wz_mem.1 T.hw.1
      (by rw [innerO_comm]; exact T.innerO_w_wz),
    T.mul_w_wz, neg_neg]

theorem mul_uwz_uw : ((T.u * T.w) * T.z) * (T.u * T.w) = T.z := by
  rw [mul_anticomm_of_orthogonal T.uwz_mem.1 T.uw_mem.1
      (by rw [innerO_comm]; exact T.innerO_uw_uwz),
    T.mul_uw_uwz, neg_neg]

theorem mul_uz_w : (T.u * T.z) * T.w = -((T.u * T.w) * T.z) := by
  have h := mul_alt_right_linear T.u T.z T.w
  rw [T.mul_z_w, mul_neg, neg_add_cancel] at h
  exact eq_neg_of_add_eq_zero_left h.symm

theorem mul_w_uz : T.w * (T.u * T.z) = (T.u * T.w) * T.z := by
  rw [mul_anticomm_of_orthogonal T.hw.1 T.uz_mem.1 T.innerO_w_uz,
    T.mul_uz_w, neg_neg]

theorem mul_u_wz : T.u * (T.w * T.z) = -((T.u * T.w) * T.z) := by
  have h := mul_alt_left_linear T.u T.w T.z
  rw [T.mul_w_u, neg_mul, add_neg_cancel, T.mul_w_uz] at h
  exact eq_neg_of_add_eq_zero_left h.symm

theorem mul_wz_u : (T.w * T.z) * T.u = (T.u * T.w) * T.z := by
  rw [mul_anticomm_of_orthogonal T.wz_mem.1 T.hu.1
      (by rw [innerO_comm]; exact T.innerO_u_wz),
    T.mul_u_wz, neg_neg]

theorem mul_uwz_u : ((T.u * T.w) * T.z) * T.u = -(T.w * T.z) := by
  have h := mul_alt_right_linear (T.u * T.w) T.z T.u
  rw [T.mul_z_u, mul_neg, neg_add_cancel, T.mul_uw_u] at h
  exact eq_neg_of_add_eq_zero_left h.symm

theorem mul_u_uwz : T.u * ((T.u * T.w) * T.z) = T.w * T.z := by
  rw [mul_anticomm_of_orthogonal T.hu.1 T.uwz_mem.1 T.innerO_u_uwz,
    T.mul_uwz_u, neg_neg]

theorem mul_uw_uz : (T.u * T.w) * (T.u * T.z) = -(T.w * T.z) := by
  have h := mul_alt_left_linear T.u (T.u * T.w) T.z
  rw [T.mul_u_uw, neg_mul, T.mul_uw_u, neg_add_cancel, T.mul_u_uwz] at h
  exact eq_neg_of_add_eq_zero_right h.symm

theorem mul_uz_uw : (T.u * T.z) * (T.u * T.w) = T.w * T.z := by
  rw [mul_anticomm_of_orthogonal T.uz_mem.1 T.uw_mem.1
      (by rw [innerO_comm]; exact T.innerO_uw_uz),
    T.mul_uw_uz, neg_neg]

theorem mul_uwz_w : ((T.u * T.w) * T.z) * T.w = T.u * T.z := by
  have h := mul_alt_right_linear (T.u * T.w) T.z T.w
  rw [T.mul_z_w, mul_neg, neg_add_cancel, T.mul_uw_w, neg_mul] at h
  have h2 := eq_neg_of_add_eq_zero_left h.symm
  rwa [neg_neg] at h2

theorem mul_w_uwz : T.w * ((T.u * T.w) * T.z) = -(T.u * T.z) := by
  rw [mul_anticomm_of_orthogonal T.hw.1 T.uwz_mem.1 T.innerO_w_uwz,
    T.mul_uwz_w]

theorem mul_uw_wz : (T.u * T.w) * (T.w * T.z) = T.u * T.z := by
  have h := mul_alt_left_linear T.w (T.u * T.w) T.z
  rw [T.mul_w_uw, T.mul_uw_w, neg_mul, add_neg_cancel, T.mul_w_uwz] at h
  have h2 := eq_neg_of_add_eq_zero_right h.symm
  rwa [neg_neg] at h2

theorem mul_wz_uw : (T.w * T.z) * (T.u * T.w) = -(T.u * T.z) := by
  rw [mul_anticomm_of_orthogonal T.wz_mem.1 T.uw_mem.1
      (by rw [innerO_comm]; exact T.innerO_uw_wz),
    T.mul_uw_wz]

theorem mul_uz_wz : (T.u * T.z) * (T.w * T.z) = -(T.u * T.w) := by
  have h := mul_alt_right_linear T.u T.z (T.w * T.z)
  rw [T.mul_z_wz, T.mul_wz_z, mul_neg, add_neg_cancel, T.mul_u_wz, neg_mul,
    T.mul_uwz_z, neg_neg] at h
  exact eq_neg_of_add_eq_zero_left h.symm

theorem mul_wz_uz : (T.w * T.z) * (T.u * T.z) = T.u * T.w := by
  rw [mul_anticomm_of_orthogonal T.wz_mem.1 T.uz_mem.1
      (by rw [innerO_comm]; exact T.innerO_uz_wz),
    T.mul_uz_wz, neg_neg]

theorem mul_uz_uwz : (T.u * T.z) * ((T.u * T.w) * T.z) = T.w := by
  have h := mul_alt_right_linear T.u T.z ((T.u * T.w) * T.z)
  rw [T.mul_z_uwz, T.mul_uwz_z, mul_neg, T.mul_u_uw, neg_neg,
    neg_add_cancel, T.mul_u_uwz, T.mul_wz_z] at h
  have h2 := eq_neg_of_add_eq_zero_left h.symm
  rwa [neg_neg] at h2

theorem mul_uwz_uz : ((T.u * T.w) * T.z) * (T.u * T.z) = -T.w := by
  rw [mul_anticomm_of_orthogonal T.uwz_mem.1 T.uz_mem.1
      (by rw [innerO_comm]; exact T.innerO_uz_uwz),
    T.mul_uz_uwz]

theorem mul_wz_uwz : (T.w * T.z) * ((T.u * T.w) * T.z) = -T.u := by
  have h := mul_alt_right_linear T.w T.z ((T.u * T.w) * T.z)
  rw [T.mul_z_uwz, T.mul_uwz_z, mul_neg, T.mul_w_uw, add_neg_cancel,
    T.mul_w_uwz, neg_mul, T.mul_uz_z, neg_neg] at h
  exact eq_neg_of_add_eq_zero_left h.symm

theorem mul_uwz_wz : ((T.u * T.w) * T.z) * (T.w * T.z) = T.u := by
  rw [mul_anticomm_of_orthogonal T.uwz_mem.1 T.wz_mem.1
      (by rw [innerO_comm]; exact T.innerO_wz_uwz),
    T.mul_wz_uwz, neg_neg]

/-! ### The frame as an orthonormal basis -/

/-- The frame of a basic triple: `(1, u, w, uw, z, uz, wz, (uw)z)`
(Baez §4 vocabulary; faithfulness gloss, never load). -/
def frame : Fin 8 → Octonion :=
  ![1, T.u, T.w, T.u * T.w, T.z, T.u * T.z, T.w * T.z, (T.u * T.w) * T.z]

set_option maxHeartbeats 1600000 in
/-- The frame is orthonormal: its Gram matrix is the identity. -/
theorem frame_innerO (i j : Fin 8) :
    innerO (T.frame i) (T.frame j) = if i = j then 1 else 0 := by
  fin_cases i <;> fin_cases j <;>
    simp [frame] <;>
    first
      | (rw [innerO_self]
         first
           | exact normSq_one
           | exact T.hu.2 | exact T.hw.2 | exact T.hz.2
           | exact T.uw_mem.2 | exact T.uz_mem.2 | exact T.wz_mem.2
           | exact T.uwz_mem.2)
      | exact T.huw | exact T.huz | exact T.hwz | exact T.hmulz
      | exact T.innerO_u_uw | exact T.innerO_w_uw
      | exact T.innerO_u_uz | exact T.innerO_z_uz
      | exact T.innerO_w_wz | exact T.innerO_z_wz
      | exact T.innerO_uw_uwz | exact T.innerO_z_uwz
      | exact T.innerO_w_uz | exact T.innerO_u_wz
      | exact T.innerO_uw_uz | exact T.innerO_uw_wz
      | exact T.innerO_uz_wz | exact T.innerO_uz_uwz
      | exact T.innerO_wz_uwz | exact T.innerO_u_uwz | exact T.innerO_w_uwz
      | (rw [innerO_one]
         first
           | exact T.hu.1 | exact T.hw.1 | exact T.hz.1
           | exact T.uw_mem.1 | exact T.uz_mem.1 | exact T.wz_mem.1
           | exact T.uwz_mem.1)
      | (rw [innerO_comm]
         first
           | exact T.huw | exact T.huz | exact T.hwz | exact T.hmulz
           | exact T.innerO_u_uw | exact T.innerO_w_uw
           | exact T.innerO_u_uz | exact T.innerO_z_uz
           | exact T.innerO_w_wz | exact T.innerO_z_wz
           | exact T.innerO_uw_uwz | exact T.innerO_z_uwz
           | exact T.innerO_w_uz | exact T.innerO_u_wz
           | exact T.innerO_uw_uz | exact T.innerO_uw_wz
           | exact T.innerO_uz_wz | exact T.innerO_uz_uwz
           | exact T.innerO_wz_uwz | exact T.innerO_u_uwz
           | exact T.innerO_w_uwz
           | (rw [innerO_one]
              first
                | exact T.hu.1 | exact T.hw.1 | exact T.hz.1
                | exact T.uw_mem.1 | exact T.uz_mem.1 | exact T.wz_mem.1
                | exact T.uwz_mem.1))

/-- Orthonormality forces linear independence: pairing a vanishing
combination with each frame element isolates its coefficient. -/
theorem frame_linearIndependent : LinearIndependent ℝ T.frame := by
  rw [Fintype.linearIndependent_iff]
  intro c hc i
  have h := congrArg (innerOLinear (T.frame i)) hc
  rw [map_sum, map_zero] at h
  simp only [map_smul, innerOLinear_apply, smul_eq_mul, frame_innerO,
    mul_ite, mul_zero, Finset.sum_ite_eq', Finset.mem_univ,
    if_true] at h
  simpa using h

/-- The frame as an ℝ-basis of 𝕆: 8 independent vectors in dimension 8
(`basisOfLinearIndependentOfCardEqFinrank`,
Mathlib/LinearAlgebra/FiniteDimensional/Lemmas.lean:286). -/
noncomputable def frameBasis : Module.Basis (Fin 8) ℝ Octonion :=
  basisOfLinearIndependentOfCardEqFinrank T.frame_linearIndependent
    (by rw [Fintype.card_fin, finrank_eq_eight])

theorem frameBasis_apply (i : Fin 8) : T.frameBasis i = T.frame i :=
  congrFun (coe_basisOfLinearIndependentOfCardEqFinrank _ _) i

end BasicTriple

end Octonion
