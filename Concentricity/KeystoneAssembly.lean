/-
Concentricity/KeystoneAssembly.lean

WORKING ARTIFACT — the keystone assembly attempt (author's dispatch,
2026-07-04 evening: "CLOSE THE KEYSTONE BY ASSEMBLY"). NOT imported by the
root; carries the attempt's single `sorry` at the exact resisting goal (R6).

The placement sentence (HANDOFF "The keystone"), assembled clause-by-clause
against the PROVED nodes: `exists_log_continuation`, `stem_identity` (via
the proved PlacementSet layer), `winding_lift_unique`,
`winding_loop_defect`, `lem:exp-degenerate` (stem form derived inline;
octonionic form `Octonion.exp_fibre_neg_real`, proved),
`TotalObject.level_eq_of_zigzag` (proved). Each clause consumable today is
consumed and compiles; the seam is marked at the one goal that resists.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.Theorem
import Concentricity.Toolkit

noncomputable section

open CategoryTheory

namespace KeystoneAssembly

/-- Clause (a), defect form — CONSUMED: along any closed value-loop of the
section avoiding the pole and the zeros, the continuation of the
hypercomplex logarithm exists (`exists_log_continuation`, PROVED) and its
endpoint defect is `2πiℤ` (`winding_loop_defect`, PROVED). The CLOSURE
clause — "the lift is itself a loop" ([Cor. 5.13]{GPVwind}, σ ∈ {0,−1} per
obstruction interval) — is the recorded σ/σᶜ definition-layer gap
(`winding_loop_defect` docstring) and is NOT consumed here. -/
theorem value_loop_lift_defect (A : ASection) (γ : C(unitInterval, ℂ))
    (hpole : ∀ t, γ t ≠ (A.pole : ℂ)) (hz : ∀ t, A.F (γ t) ≠ 0)
    (hloop : γ 0 = γ 1) :
    ∃ γ' : C(unitInterval, ℂ), (∀ t, Complex.exp (γ' t) = A.F (γ t)) ∧
      ∃ k : ℤ, γ' 1 - γ' 0 = (k : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) := by
  have hcont : Continuous fun t : unitInterval => A.F (γ t) :=
    continuous_iff_continuousAt.mpr fun t =>
      ((A.c1_analyticAt _ (hpole t)).continuousAt).comp
        (map_continuous γ).continuousAt
  obtain ⟨γ', hγ'⟩ := exists_log_continuation ⟨_, hcont⟩ hz
  refine ⟨γ', hγ', winding_loop_defect ⟨_, hcont⟩ ?_ γ' hγ'⟩
  change A.F (γ 0) = A.F (γ 1)
  rw [hloop]

/-- Clause (c) — CONSUMED: the traversing lift is unique-tame once its
initial value is fixed (`winding_lift_unique`, PROVED; the C2/C3 agreement
feeding it is the proved `stem_identity` / `stem_identity_logDeriv` layer). -/
theorem value_loop_lift_unique (v : C(unitInterval, ℂ)) (hv : ∀ t, v t ≠ 0)
    (γ₁ γ₂ : C(unitInterval, ℂ)) (h₁ : ∀ t, Complex.exp (γ₁ t) = v t)
    (h₂ : ∀ t, Complex.exp (γ₂ t) = v t) (h0 : γ₁ 0 = γ₂ 0) : γ₁ = γ₂ :=
  winding_lift_unique v hv γ₁ γ₂ h₁ h₂ h0

/-- Clause (b) — CONSUMED (stem form of `lem:exp-degenerate`; octonionic
form `Octonion.exp_fibre_neg_real`, PROVED): every point of the lift lying
over a negative-real value `−r` carries the single level `log r` — all
multiplicity in the fibre is in the winding direction, none in the level. -/
theorem lift_level_at_degenerate {w : ℂ} {r : ℝ} (hr : 0 < r)
    (h : Complex.exp w = -(r : ℂ)) : w.re = Real.log r := by
  have habs := congrArg norm h
  rw [Complex.norm_exp, norm_neg, Complex.norm_real, Real.norm_eq_abs,
    abs_of_pos hr] at habs
  rw [← habs, Real.log_exp]

/-- Clauses (d)+(e) — CONSUMED as the frame: the conclusion is the level
read-off of a zigzag between the canonical objects of 𝒯 beneath the two
zero-spheres (`TotalObject.level_eq_of_zigzag`, PROVED). What remains — the
`sorry` below — is the POPULATION of that zigzag by the transport: the
placement sentence's "value-loops close, through the single pole cone (C1),
into loops of the winding lift (Cor 5.13); such a loop joins the residue-ℂ
zeros … to the residue-ℝ degenerate locus …, which lies over one real
level." This is the assembly's exact resisting goal. -/
theorem transportLevel_placement_attempt (A : ASection) (n m : ℕ) :
    A.transportLevel n = A.transportLevel m := by
  have hzig : Zigzag (TotalObject.ofLevel (A.transportLevel n))
      (TotalObject.ofLevel (A.transportLevel m)) := by
    sorry
  exact TotalObject.level_eq_of_zigzag hzig

/-- The frame's own measure, machine-checked (`zigzag_iff_level`, PROVED
both ways): in the static base the population goal above and the placement
conclusion are one proposition — the level is conserved along every zigzag,
so the zigzag must be SUPPLIED to 𝒯 by the loop assembly; it cannot be
extracted from 𝒯. -/
example (A : ASection) (n m : ℕ) :
    Zigzag (TotalObject.ofLevel (A.transportLevel n))
        (TotalObject.ofLevel (A.transportLevel m))
      ↔ A.transportLevel n = A.transportLevel m :=
  TotalObject.zigzag_iff_level

end KeystoneAssembly
