/-
Concentricity/G2.lean

G₂ := Aut(𝕆), its action on 𝕆 and on the compactified 𝕆* = OnePoint 𝕆, and
the octonionic world 𝓗₁ = G₂ ⋉ 𝕆* as Mathlib's ActionCategory (R9: every
object constructed).

Master references (quoted in docstrings): `def:G2`, `rmk:G2-compact`,
`thm:G2-S6` (Baez; SOURCES/Baez02.md), `def:two-worlds` (the octonionic
world half).

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.Octonion
import Concentricity.OctonionForm
import Mathlib.CategoryTheory.Action
import Mathlib.Topology.Compactification.OnePoint.Basic

noncomputable section

/-- **G₂** (master `def:G2`): "G₂ = Aut(𝕆) is the … group of ℝ-algebra
automorphisms of 𝕆." Constructed as multiplicative ℝ-linear self-equivalences
of the (non-associative) algebra 𝕆 — `AlgEquiv` requires associativity, so
the bundle is built by hand. The Lie-theoretic clauses of `def:G2`
(14-dimensional, compact, connected, simply connected) are not consumed by
the spine and are not stated here. -/
structure G2 where
  /-- The underlying ℝ-linear equivalence. -/
  toEquiv : Octonion ≃ₗ[ℝ] Octonion
  /-- Multiplicativity. -/
  map_mul' : ∀ x y, toEquiv (x * y) = toEquiv x * toEquiv y

namespace G2

@[ext]
theorem ext {g h : G2} (H : ∀ x, g.toEquiv x = h.toEquiv x) : g = h := by
  cases g; cases h
  congr 1
  exact LinearEquiv.ext H

instance : One G2 :=
  ⟨⟨LinearEquiv.refl ℝ Octonion, fun _ _ => rfl⟩⟩

/-- Composition: `(g * h)` acts as `g` after `h`. -/
instance : Mul G2 :=
  ⟨fun g h =>
    ⟨h.toEquiv.trans g.toEquiv, fun x y => by
      simp [LinearEquiv.trans_apply, h.map_mul', g.map_mul']⟩⟩

/-- The inverse of a multiplicative linear equivalence is multiplicative. -/
instance : Inv G2 :=
  ⟨fun g =>
    ⟨g.toEquiv.symm, fun x y => by
      apply g.toEquiv.injective
      simp [g.map_mul', LinearEquiv.apply_symm_apply]⟩⟩

instance : Group G2 where
  mul_assoc _ _ _ := ext fun _ => rfl
  one_mul _ := ext fun _ => rfl
  mul_one _ := ext fun _ => rfl
  inv_mul_cancel g := ext fun x => g.toEquiv.symm_apply_apply x

instance : MulAction G2 Octonion where
  smul g x := g.toEquiv x
  one_smul _ := rfl
  mul_smul _ _ _ := rfl

@[simp]
theorem smul_def (g : G2) (x : Octonion) : g • x = g.toEquiv x := rfl

@[simp]
theorem smul_mul (g : G2) (x y : Octonion) : g • (x * y) = (g • x) * (g • y) :=
  g.map_mul' x y

/-- Every automorphism fixes the unit (master `def:G2`: "Each g ∈ G₂ fixes
1"). DERIVED: `g 1 = g(1·x)` forces `g 1` to be a left unit on the range,
which is everything. -/
@[simp]
theorem smul_one (g : G2) : g • (1 : Octonion) = 1 := by
  have h := g.map_mul' 1 (g.toEquiv.symm 1)
  rw [Octonion.one_mul, LinearEquiv.apply_symm_apply] at h
  simpa [Octonion.mul_one] using h.symm

/-- Every automorphism fixes the real axis pointwise (master `def:G2`:
"… fixes 1, hence the real axis pointwise"). DERIVED from linearity. -/
@[simp]
theorem smul_ofReal (g : G2) (r : ℝ) : g • Octonion.ofReal r = Octonion.ofReal r := by
  have hr : Octonion.ofReal r = r • (1 : Octonion) := by
    refine Prod.ext ?_ ?_
    · show ((r : ℝ) : Quaternion ℝ) = r • (1 : Quaternion ℝ)
      simpa [Algebra.algebraMap_eq_smul_one] using (congrFun Quaternion.algebraMap_def r).symm
    · show (0 : Quaternion ℝ) = r • (0 : Quaternion ℝ)
      rw [smul_zero]
  rw [hr]
  calc g • (r • (1 : Octonion)) = r • (g • (1 : Octonion)) := g.toEquiv.map_smul r 1
  _ = r • (1 : Octonion) := by rw [smul_one]

set_option maxHeartbeats 1600000 in
/-- P4.2.f — G₂ acts transitively on basic triples (Baez §4 substance,
faithfulness gloss; DERIVED in-repo per PHASE4_PLAN #2). The frame
`(1, u, w, uw, z, uz, wz, (uw)z)` of a basic triple is an orthonormal
basis (`BasicTriple.frameBasis`), and the linear map matching two frames
is multiplicative because both frames carry the same multiplication table
(`BasicTriple.mul_*`, the P4.2.f table, universal across triples). -/
theorem exists_smul_basicTriple (T₁ T₂ : Octonion.BasicTriple) :
    ∃ g : G2, g • T₁.u = T₂.u ∧ g • T₁.w = T₂.w ∧ g • T₁.z = T₂.z := by
  classical
  set E : Octonion ≃ₗ[ℝ] Octonion :=
    T₁.frameBasis.equiv T₂.frameBasis (Equiv.refl (Fin 8)) with hE
  have hframe : ∀ i : Fin 8, E (T₁.frame i) = T₂.frame i := by
    intro i
    have h := Module.Basis.equiv_apply (b := T₁.frameBasis)
      (b' := T₂.frameBasis) (i := i) (e := Equiv.refl (Fin 8))
    rw [T₁.frameBasis_apply, T₂.frameBasis_apply, Equiv.refl_apply, ← hE] at h
    exact h
  -- The eight frame equations, in canonical-element form.
  have he0 : E (1 : Octonion) = 1 := hframe 0
  have he1 : E T₁.u = T₂.u := hframe 1
  have he2 : E T₁.w = T₂.w := hframe 2
  have he3 : E (T₁.u * T₁.w) = T₂.u * T₂.w := hframe 3
  have he4 : E T₁.z = T₂.z := hframe 4
  have he5 : E (T₁.u * T₁.z) = T₂.u * T₂.z := hframe 5
  have he6 : E (T₁.w * T₁.z) = T₂.w * T₂.z := hframe 6
  have he7 : E ((T₁.u * T₁.w) * T₁.z) = (T₂.u * T₂.w) * T₂.z := hframe 7
  -- Multiplicativity on frame pairs: both frames carry the same table.
  have hpair : ∀ i j : Fin 8,
      E (T₁.frame i * T₁.frame j) = E (T₁.frame i) * E (T₁.frame j) := by
    intro i j
    fin_cases i <;> fin_cases j <;>
      simp [Octonion.BasicTriple.frame, he0, he1, he2, he3, he4, he5, he6, he7,
        Octonion.BasicTriple.mul_u_u, Octonion.BasicTriple.mul_w_w,
        Octonion.BasicTriple.mul_z_z, Octonion.BasicTriple.mul_uw_uw,
        Octonion.BasicTriple.mul_uz_uz, Octonion.BasicTriple.mul_wz_wz,
        Octonion.BasicTriple.mul_uwz_uwz, Octonion.BasicTriple.mul_w_u,
        Octonion.BasicTriple.mul_z_u, Octonion.BasicTriple.mul_z_w,
        Octonion.BasicTriple.mul_z_uw, Octonion.BasicTriple.mul_u_uw,
        Octonion.BasicTriple.mul_u_uz, Octonion.BasicTriple.mul_w_wz,
        Octonion.BasicTriple.mul_uw_uwz, Octonion.BasicTriple.mul_uz_z,
        Octonion.BasicTriple.mul_wz_z, Octonion.BasicTriple.mul_uwz_z,
        Octonion.BasicTriple.mul_w_uw, Octonion.BasicTriple.mul_z_uz,
        Octonion.BasicTriple.mul_z_wz, Octonion.BasicTriple.mul_z_uwz,
        Octonion.BasicTriple.mul_uw_u, Octonion.BasicTriple.mul_uw_w,
        Octonion.BasicTriple.mul_uz_u, Octonion.BasicTriple.mul_wz_w,
        Octonion.BasicTriple.mul_uwz_uw, Octonion.BasicTriple.mul_uz_w,
        Octonion.BasicTriple.mul_w_uz, Octonion.BasicTriple.mul_u_wz,
        Octonion.BasicTriple.mul_wz_u, Octonion.BasicTriple.mul_uwz_u,
        Octonion.BasicTriple.mul_u_uwz, Octonion.BasicTriple.mul_uw_uz,
        Octonion.BasicTriple.mul_uz_uw, Octonion.BasicTriple.mul_uwz_w,
        Octonion.BasicTriple.mul_w_uwz, Octonion.BasicTriple.mul_uw_wz,
        Octonion.BasicTriple.mul_wz_uw, Octonion.BasicTriple.mul_uz_wz,
        Octonion.BasicTriple.mul_wz_uz, Octonion.BasicTriple.mul_uz_uwz,
        Octonion.BasicTriple.mul_uwz_uz, Octonion.BasicTriple.mul_wz_uwz,
        Octonion.BasicTriple.mul_uwz_wz]
  -- Bilinear bootstrap: from frame pairs to all pairs, one slot at a time.
  have hstep : ∀ (i : Fin 8) (y : Octonion),
      E (T₁.frame i * y) = E (T₁.frame i) * E y := by
    intro i
    have h : E.toLinearMap ∘ₗ LinearMap.mulLeft ℝ (T₁.frame i)
        = LinearMap.mulLeft ℝ (E (T₁.frame i)) ∘ₗ E.toLinearMap := by
      refine T₁.frameBasis.ext fun j => ?_
      rw [T₁.frameBasis_apply]
      simp only [LinearMap.comp_apply, LinearMap.mulLeft_apply,
        LinearEquiv.coe_coe]
      exact hpair i j
    intro y
    have h2 := LinearMap.congr_fun h y
    simpa only [LinearMap.comp_apply, LinearMap.mulLeft_apply,
      LinearEquiv.coe_coe] using h2
  have hmul : ∀ x y : Octonion, E (x * y) = E x * E y := by
    intro x y
    have h : E.toLinearMap ∘ₗ LinearMap.mulRight ℝ y
        = LinearMap.mulRight ℝ (E y) ∘ₗ E.toLinearMap := by
      refine T₁.frameBasis.ext fun i => ?_
      rw [T₁.frameBasis_apply]
      simp only [LinearMap.comp_apply, LinearMap.mulRight_apply,
        LinearEquiv.coe_coe]
      exact hstep i y
    have h2 := LinearMap.congr_fun h x
    simpa only [LinearMap.comp_apply, LinearMap.mulRight_apply,
      LinearEquiv.coe_coe] using h2
  exact ⟨⟨E, hmul⟩, he1, he2, he4⟩

/-- master `thm:G2-S6` (Baez, SOURCES/Baez02.md): "G₂ acts transitively on
S⁶ …" — the transitivity clause, on the unit imaginary sphere of
Concentricity/Octonion.lean. CLOSED against the P4.2 decomposition: extend
both points to basic triples (P4.2.e) and match the triples (P4.2.f).

SOURCES/Baez02.md records: transitivity is printed in substance at p. 185
("the automorphism … can map e₁ to any point e₁′ on the 6-sphere of unit
imaginary octonions"); the master's stabilizer clause ("with stabilizer
SU(3)") has NO located statement in Baez02 (SOURCES/Baez02.md GAP — second
source or drop, author's call) and is not consumed by the spine, so it is
not stated here. -/
theorem exists_smul_eq_of_mem_unitImaginarySphere
    {u v : Octonion} (hu : u ∈ Octonion.unitImaginarySphere)
    (hv : v ∈ Octonion.unitImaginarySphere) :
    ∃ g : G2, g • u = v := by
  obtain ⟨T₁, hT₁⟩ := Octonion.exists_basicTriple u hu
  obtain ⟨T₂, hT₂⟩ := Octonion.exists_basicTriple v hv
  obtain ⟨g, hg, -, -⟩ := exists_smul_basicTriple T₁ T₂
  exact ⟨g, by rw [hT₁, hT₂] at hg; exact hg⟩

end G2

/-- The action of G₂ on the compactified octonions 𝕆* = OnePoint 𝕆, fixing
∞ (master `rmk:G2-compact`: each g "extends uniquely to a homeomorphism of
the one-point compactification 𝕆* = 𝕆 ∪ {∞} = S⁸ fixing the point at
infinity ∞ = N"; the topological clauses are queued with the orbit lemmas,
the action itself is direct). -/
instance : MulAction G2 (OnePoint Octonion) where
  smul g := OnePoint.map (g • ·)
  one_smul x := by
    have h : (fun a : Octonion => (1 : G2) • a) = id := funext fun a => one_smul G2 a
    show OnePoint.map (fun a : Octonion => (1 : G2) • a) x = x
    rw [h, OnePoint.map_id, id_eq]
  mul_smul g h x := by
    have hc : (fun a : Octonion => (g * h) • a)
        = (fun a : Octonion => g • a) ∘ (fun a : Octonion => h • a) :=
      funext fun a => mul_smul g h a
    show OnePoint.map (fun a : Octonion => (g * h) • a) x
      = OnePoint.map (g • ·) (OnePoint.map (h • ·) x)
    rw [hc, OnePoint.map_comp]
    rfl

/-- **𝓗₁** (master `def:two-worlds`): "The *octonionic world* is the
translation groupoid 𝓗₁ = G₂ ⋉ 𝕆* of G₂ = Aut(𝕆) acting on 𝕆* = S⁸ …" —
Mathlib's `CategoryTheory.ActionCategory`, as the master's own Lean pointer
prescribes. Its connected components are the G₂-orbits (Quillen §1,
SOURCES/Quillen73.md); the two-kinds orbit description (`ℝ ∪ {N}` fixed;
direction 6-spheres) is queued with `thm:G2-S6`. -/
def H1 := CategoryTheory.ActionCategory G2 (OnePoint Octonion)

instance : CategoryTheory.Groupoid H1 :=
  inferInstanceAs (CategoryTheory.Groupoid (CategoryTheory.ActionCategory G2 (OnePoint Octonion)))
