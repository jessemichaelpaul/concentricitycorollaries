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

noncomputable section

namespace Octonion

/-- The polarization bilinear form of `normSq`:
`⟪x, y⟫ = (N(x+y) − N(x) − N(y))/2`. -/
def innerO (x y : Octonion) : ℝ := (normSq (x + y) - normSq x - normSq y) / 2

theorem innerO_comm (x y : Octonion) : innerO x y = innerO y x := by
  rw [innerO, innerO, add_comm x y]
  ring

/-- `⟪x, 1⟫ = re x` — the form sees the real part. Queued (R8):
componentwise. -/
theorem innerO_one (x : Octonion) : innerO x 1 = re x := by
  sorry

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
`⟪x·y, x·z⟫ = N(x)·⟪y, z⟫`. Queued (R8): polarize `normSq_mul` (proved,
Degen) in the second argument, using left distributivity. -/
theorem innerO_mul_mul_left (x y z : Octonion) :
    innerO (x * y) (x * z) = normSq x * innerO y z := by
  sorry

/-- P4.2.b′ — composition polarized on the right. Queued (R8). -/
theorem innerO_mul_mul_right (x y z : Octonion) :
    innerO (x * z) (y * z) = innerO x y * normSq z := by
  sorry

/-- P4.2.c — orthogonal imaginary octonions anticommute:
`re x = re y = 0` and `⟪x, y⟫ = 0` force `x·y = −(y·x)`. Queued (R8):
linearize the quadratic identity P4.2.a at `x + y`. -/
theorem mul_anticomm_of_orthogonal {x y : Octonion}
    (hx : re x = 0) (hy : re y = 0) (hxy : innerO x y = 0) :
    x * y = -(y * x) := by
  sorry

/-- P4.2.d — the product of orthogonal unit imaginaries is a unit imaginary
orthogonal to both factors. Queued (R8): composition (P4.2.b) +
anticommutation (P4.2.c). -/
theorem mul_mem_unitImaginarySphere_of_orthogonal {u w : Octonion}
    (hu : u ∈ unitImaginarySphere) (hw : w ∈ unitImaginarySphere)
    (huw : innerO u w = 0) :
    u * w ∈ unitImaginarySphere ∧ innerO u (u * w) = 0 ∧ innerO w (u * w) = 0 := by
  sorry

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
