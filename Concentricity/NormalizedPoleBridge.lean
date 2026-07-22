/-
Concentricity/NormalizedPoleBridge.lean

Step 3 of the normalized section construction: the C3 zero loop and the C1
pole loop meet in one certified winding datum. This is analytic transport
cargo for the future normalized morphism `Z_n ⟶ N`; it is not yet presented
as a categorical arrow.
-/
import Concentricity.SigmaE3
import Concentricity.NormalizedBase

noncomputable section

namespace ASection

/-- The normalized n-th zero object carries the C3 zero-loop side of the
C1/C3 pole bridge, while retaining its real-circle label. -/
theorem normalizedZero_pole_winding (A : ASection) (n : ℕ) (I : SphereWorld) :
    (A.normalizedZero n I).label = (A.sphereZero n).re ∧
    ∃ εz > 0, ∃ εp > 0,
      ∀ ε₁ : ℝ, 0 < ε₁ → ε₁ ≤ εz → ∀ ε₂ : ℝ, 0 < ε₂ → ε₂ ≤ εp →
      ∃ Γz Γp : C(unitInterval, ℂ),
        (∀ t, Γz t = A.F (circleLoop (A.sphereZero n) ε₁ t)) ∧
        (∀ t, Γp t = A.F (circleLoop (A.pole : ℂ) ε₂ t)) ∧
        (∀ t, (Γz * Γp) t ≠ 0) ∧ (Γz * Γp) 0 = (Γz * Γp) 1 ∧
        stemWinding (Γz * Γp) =
          (Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n} : ℤ) - 1 := by
  refine ⟨rfl, ?_⟩
  obtain ⟨εz, hεz, hεzim, hz⟩ := A.stemWinding_circle_sphereZero n
  obtain ⟨εp, hεp, hp⟩ := A.stemWinding_circle_pole
  refine ⟨εz, hεz, εp, hεp, fun ε₁ h₁ h₁' ε₂ h₂ h₂' => ?_⟩
  obtain ⟨Γz, hΓzval, hΓzne, hΓzloop, hΓzwind⟩ := hz ε₁ h₁ h₁'
  obtain ⟨Γp, hΓpval, hΓpne, hΓploop, hΓpwind⟩ := hp ε₂ h₂ h₂'
  have hprod_ne : ∀ t, (Γz * Γp) t ≠ 0 := fun t => by
    rw [ContinuousMap.mul_apply]
    exact mul_ne_zero (hΓzne t) (hΓpne t)
  have hprod_loop : (Γz * Γp) 0 = (Γz * Γp) 1 := by
    rw [ContinuousMap.mul_apply, ContinuousMap.mul_apply, hΓzloop, hΓploop]
  refine ⟨Γz, Γp, hΓzval, hΓpval, hprod_ne, hprod_loop, ?_⟩
  rw [stemWinding_mul Γz Γp hΓzne hΓpne hΓzloop hΓploop, hΓzwind, hΓpwind]
  ring

/-- The full multiplicity-aware zero--pole closure.  The C3 zero loop has
winding equal to its divisor multiplicity, while C1's pole loop has winding
`-1`; multiplying the pole loop by that multiplicity cancels the total
winding.  Thus every enumerated zero, not only a simple one, has a closed
lift through the compactified witness. -/
theorem normalizedZero_pole_power_closes (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    ∃ εz > 0, ∃ εp > 0,
      ∀ ε₁ : ℝ, 0 < ε₁ → ε₁ ≤ εz → ∀ ε₂ : ℝ, 0 < ε₂ → ε₂ ≤ εp →
      ∃ Γz Γp Γ' : C(unitInterval, ℂ),
        (∀ t, Γz t = A.F (circleLoop (A.sphereZero n) ε₁ t)) ∧
        (∀ t, Γp t = A.F (circleLoop (A.pole : ℂ) ε₂ t)) ∧
        (∀ t, Complex.exp (Γ' t) =
          (Γz * Γp ^ Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n}) t) ∧
        Γ' 1 = Γ' 0 := by
  obtain ⟨εz, hεz, hεzim, hz⟩ := A.stemWinding_circle_sphereZero n
  obtain ⟨εp, hεp, hp⟩ := A.stemWinding_circle_pole
  refine ⟨εz, hεz, εp, hεp, fun ε₁ h₁ h₁' ε₂ h₂ h₂' => ?_⟩
  obtain ⟨Γz, hΓzval, hΓzne, hΓzloop, hΓzwind⟩ := hz ε₁ h₁ h₁'
  obtain ⟨Γp, hΓpval, hΓpne, hΓploop, hΓpwind⟩ := hp ε₂ h₂ h₂'
  let N : ℕ := Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n}
  let Θ : C(unitInterval, ℂ) := Γz * Γp ^ N
  have hΘne : ∀ t, Θ t ≠ 0 := fun t => by
    simp only [Θ, ContinuousMap.mul_apply, ContinuousMap.pow_apply]
    exact mul_ne_zero (hΓzne t) (pow_ne_zero _ (hΓpne t))
  have hΘloop : Θ 0 = Θ 1 := by
    simp only [Θ, ContinuousMap.mul_apply, ContinuousMap.pow_apply, hΓzloop, hΓploop]
  have hΘwind : stemWinding Θ = 0 := by
    change stemWinding (Γz * Γp ^ N) = 0
    rw [stemWinding_mul Γz (Γp ^ N) hΓzne
      (fun t => pow_ne_zero _ (hΓpne t)) hΓzloop
      (by simp only [ContinuousMap.pow_apply, hΓploop]),
      stemWinding_pow Γp hΓpne hΓploop N, hΓzwind, hΓpwind]
    simp only [N]
    push_cast
    ring
  obtain ⟨Γ', hΓ'lift, hΓ'close⟩ :=
    (stemWinding_eq_zero_iff Θ hΘne hΘloop).mp hΘwind
  refine ⟨Γz, Γp, Γ', hΓzval, hΓpval, ?_, hΓ'close⟩
  intro t
  rw [hΓ'lift t]

end ASection
