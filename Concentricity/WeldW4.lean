/-
Concentricity/WeldW4.lean

W4 — THE CLOSE (the author's assembly, 2026-07-06, verbatim: "the A-section
has to be assembled with all the correct properties… c2_zero_free binds the
primes concentrically because they are around the degenerate fibre for the
real part, and binds them concentrically as it Weierstrass factors through
N itself. The C2 is stronger because the uniqueness… GPV AND C1-C4 hence
concentric ℂ-residues"). UNIMPORTED ARTIFACT (KeystoneAssembly /
GreatCircleRoute / LoopAssembly / SigmaE3 / KernelE4 / SynthesisE6 /
WeldW12 / WeldW3 precedent): not in the root import list; the imported
root ledger (2/0) is untouched.

THE POINT OF VIEW (the author, 2026-07-06, the organizing principle): the
A-section is DEFINED by C1–C4 and EXTENDS ALL OF GPV — the winding/
tameness theory is a body of consequences the definition already owns.
Each row's docstring names the weld step it serves; no exploratory yield.

THE TWO-CENTER DEATH, driven row by row:

§A — `two_center_disjoint_counts` (serves the charter's counting step:
"W12's counting puts ≥ 1 zero in each of two strip rectangles separated by
β"): two enumerated zeros at distinct levels yield the line Re = β and two
admissible rectangles strictly left and right of it, each trapping ≥ 1
zero, each value-loop winding EXACTLY its own trapped count — and the two
trapped ledgers are DISJOINT with exactly additive cardinality (W12's
counting weld joined to `openRect_disjoint_of_le`). PROVED.

§B — `two_center_winding_onto_one_band` (serves the charter's closure
step: "W3's tame sphere-loops + the UNIQUE tame lift through the cone
carry the winding onto the ONE band"): at the same configuration, W3's
sphere-loop stem carriers (the ε-circles about the two zeros — the tame
loops of WeldW3 §(b), constant companion, empty obstruction set) wind
≥ 1 on each side of the line and are each OBSTRUCTED alone (no closed
lift, GPVwind Cor 5.13's criterion failing on each side); C1's cone
factor (the pole circle, winding −1, `stemWinding_circle_pole` ←
`c1_simple`) annihilates the WHOLE two-center winding in the pointwise
composite Γn · Γm · Γp^(wn+wm): winding ZERO, the unique tame lift closes
(Cor 5.13's closure clause, `stemWinding_eq_zero_iff`), EVERY lift closes
(`winding_loop_closed`), lifts are unique given the basepoint
(`winding_lift_unique`) — the ENTIRE two-center multiplicity, both sides
jointly, is carried onto the ONE band through the witness cone: level
closed, height closed, band data only. PROVED.

§C — THE RECEIPT `concentricity_via_weldW4`: the target with the joined
W12 + W3 + E6 + E4 boards fed in full — the counting pair, the walls
(right half-space winding-inert + majorant-controlled, left region
winding-inert), the composite through the cone, the octonionic tame
sphere-loops and their degenerate touches, the concentric kernel, the
shared ladder, the Φ glue/wedge, the equivalent faces (second family at
supLevel; ∃β two-sided). ONE `sorry` at the exact resisting goal
  ⊢ False
— see the receipt docstring for the seam record, the machine verdict, and
THE MISSING JOINT in the weld vocabulary.

VERDICT OF RECORD (R6): RESISTED. The two-center death needs exactly one
inference no fed possession supplies — the register identification
(value-side ladder level log r ↔ domain-side transport level
Re(sphereZero ·)) = `eq:placement-set` = ∃β two-sided
(`auditE1_target_iff_two_sided`) = the cross-contour constraint (WeldW12
§F verdict). THE UNTRANSCRIBED GPV CONSEQUENCE OF C1–C4, named: GPVwind
Cor 5.13's σ ∈ {0,−1} lift-EXISTENCE criterion for loops with NONEMPTY
obstruction set, on the octonionic register — its flip data (Def 5.2) is
one-sided-limit data of the direction field at real crossings, where
`Octonion.dir` has junk value 0 and, by GPVwind Rem 2.1 (SOURCES/
GPVwind.md, verbatim: "the function 𝓘 cannot be extended as a continuous
function to any single point of the real axis ℝ of 𝕂"), no continuous
extension exists to carry it; every loop the C1–C4 board owns has EMPTY
obstruction set (WeldW3 §(b)) or a level-blind stem shadow (closure ⟺
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
(the charter's honesty pin): every PROVED row of this file holds verbatim
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
configuration the missing joint must kill, they are not the kill; the one
field where class strength beyond the fed possessions could live is
`c2_zero_free`'s splitting demand (AuditE1 §GLOSS flag, unresolved), the
author's lane (R6).

`sorry` marks UNFORMALIZED, never UNSOUND (R8); this file carries exactly
one, the §C receipt.
-/
import Concentricity.WeldW12
import Concentricity.WeldW3

noncomputable section

open Complex

namespace ASection

/-! ## §A — the two-center counting configuration (W12 joined, ledgers
disjoint) -/

/-- **§A — the two-center counting configuration** (serves the charter's
counting step: "W12's counting puts ≥ 1 zero in each of two strip
rectangles separated by β"). Two enumerated zeros at distinct levels
yield the line Re = β strictly between them and two admissible rectangles
— strictly left and strictly right of the line — each trapping its zero,
each with the section's value-loop winding EXACTLY its own trapped count
(W12's `counting_pair_of_two_levels`), and the two trapped ledgers
DISJOINT with exactly additive cardinality (`openRect_disjoint_of_le` +
`Finset.card_union_of_disjoint`): the two-center supposition's divisor
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
missing joint must kill, it is not the kill. PROVED. -/
theorem two_center_disjoint_counts (A : ASection) {n m : ℕ}
    (hsep : (A.sphereZero n).re < (A.sphereZero m).re) :
    ∃ β : ℝ, (A.sphereZero n).re < β ∧ β < (A.sphereZero m).re ∧
    ∃ xn₁ xn₂ yn₁ yn₂ xm₁ xm₂ ym₁ ym₂ : ℝ,
      xn₂ < β ∧ β < xm₁ ∧ 0 < yn₁ ∧ 0 < ym₁ ∧
      A.sphereZero n ∈ openRect xn₁ xn₂ yn₁ yn₂ ∧
      A.sphereZero m ∈ openRect xm₁ xm₂ ym₁ ym₂ ∧
      ∃ sn sm : Finset ℕ,
        (∀ k, k ∈ sn ↔ A.sphereZero k ∈ openRect xn₁ xn₂ yn₁ yn₂) ∧
        (∀ k, k ∈ sm ↔ A.sphereZero k ∈ openRect xm₁ xm₂ ym₁ ym₂) ∧
        1 ≤ sn.card ∧ 1 ≤ sm.card ∧ Disjoint sn sm ∧
        (sn ∪ sm).card = sn.card + sm.card ∧
        ∃ Γn Γm : C(unitInterval, ℂ),
          (∀ t, Γn t = A.F (rectLoop xn₁ xn₂ yn₁ yn₂ t)) ∧
          (∀ t, Γm t = A.F (rectLoop xm₁ xm₂ ym₁ ym₂ t)) ∧
          stemWinding Γn = sn.card ∧ stemWinding Γm = sm.card := by
  classical
  obtain ⟨β, hβn, hβm, xn₁, xn₂, yn₁, yn₂, xm₁, xm₂, ym₁, ym₂,
    hxβ, hβx, hyn₁, hym₁, hρn, hρm, sn, sm, hsn, hsm, hcn, hcm,
    Γn, Γm, hΓn, hΓm, hwn, hwm⟩ := A.counting_pair_of_two_levels hsep
  have hdisjSet : Disjoint (openRect xn₁ xn₂ yn₁ yn₂) (openRect xm₁ xm₂ ym₁ ym₂) :=
    openRect_disjoint_of_le (le_of_lt (hxβ.trans hβx)) xn₁ yn₁ yn₂ xm₂ ym₁ ym₂
  have hdisj : Disjoint sn sm := by
    rw [Finset.disjoint_left]
    intro j hjn hjm
    exact (Set.disjoint_left.mp hdisjSet ((hsn j).mp hjn)) ((hsm j).mp hjm)
  exact ⟨β, hβn, hβm, xn₁, xn₂, yn₁, yn₂, xm₁, xm₂, ym₁, ym₂, hxβ, hβx,
    hyn₁, hym₁, hρn, hρm, sn, sm, hsn, hsm, hcn, hcm, hdisj,
    Finset.card_union_of_disjoint hdisj, Γn, Γm, hΓn, hΓm, hwn, hwm⟩

/-! ## §B — the composite through the cone: the winding onto the ONE band -/

/-- **§B — the two-center winding carried onto the ONE band through the
cone** (serves the charter's closure step: "W3's tame sphere-loops + the
UNIQUE tame lift through the cone (`winding_lift_unique`,
`pole_cone_eps_delta`, E6's cone-closure-at-tally-1) carry the winding
onto the ONE band"). At the two-center configuration: the ε-circles about
the two zeros — the stem carriers of WeldW3's tame sphere-enclosing loops
(§(b): constant companion, empty obstruction set) — stay strictly left
resp. right of the line Re = β and their value-loops wind ≥ 1 on EACH
side (`sigma_level_separation`); each side loop is OBSTRUCTED alone (no
closed lift — Cor 5.13's criterion failing on each side of the line,
stem-honest closure form `stemWinding_eq_zero_iff`); C1's cone factor —
the pole circle's value-loop, winding exactly −1
(`stemWinding_circle_pole` ← `c1_simple`) — annihilates the WHOLE
two-center winding in the pointwise composite Θ = Γn · Γm · Γp^(wn+wm):

  · winding ZERO (`stemWinding_mul`/`_pow`: lifts add along exp);
  · the unique tame lift CLOSES — Cor 5.13's closure clause, and EVERY
    lift closes (`winding_loop_closed`);
  · lifts are unique given the basepoint (`winding_lift_unique`,
    Def 4.7's tameness on the stem).

The ENTIRE two-center multiplicity — both sides jointly — is band data on
the one closed lift through the witness cone: level closed, height
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
the closed composite's level datum is VALUE-side; the row assembles the
one-band configuration the missing joint must read back to the DOMAIN
levels. PROVED. -/
theorem two_center_winding_onto_one_band (A : ASection) {n m : ℕ}
    (hsep : (A.sphereZero n).re < (A.sphereZero m).re) :
    ∃ β : ℝ, (A.sphereZero n).re < β ∧ β < (A.sphereZero m).re ∧
    ∃ ε > 0,
      (∀ t, (circleLoop (A.sphereZero n) ε t).re < β) ∧
      (∀ t, β < (circleLoop (A.sphereZero m) ε t).re) ∧
    ∃ εp > 0,
    ∃ Γn Γm Γp Θ : C(unitInterval, ℂ),
      (∀ t, Γn t = A.F (circleLoop (A.sphereZero n) ε t)) ∧
      (∀ t, Γm t = A.F (circleLoop (A.sphereZero m) ε t)) ∧
      (∀ t, Γp t = A.F (circleLoop (A.pole : ℂ) εp t)) ∧
      1 ≤ stemWinding Γn ∧ 1 ≤ stemWinding Γm ∧ stemWinding Γp = -1 ∧
      ¬ (∃ γ' : C(unitInterval, ℂ),
          (∀ t, Complex.exp (γ' t) = Γn t) ∧ γ' 1 = γ' 0) ∧
      ¬ (∃ γ' : C(unitInterval, ℂ),
          (∀ t, Complex.exp (γ' t) = Γm t) ∧ γ' 1 = γ' 0) ∧
      (∀ t, Θ t = Γn t * Γm t
          * Γp t ^ (stemWinding Γn + stemWinding Γm).toNat) ∧
      (∀ t, Θ t ≠ 0) ∧ Θ 0 = Θ 1 ∧ stemWinding Θ = 0 ∧
      (∃ θ : C(unitInterval, ℂ),
        (∀ t, Complex.exp (θ t) = Θ t) ∧ θ 1 = θ 0) ∧
      (∀ θ : C(unitInterval, ℂ),
        (∀ t, Complex.exp (θ t) = Θ t) → θ 1 = θ 0) ∧
      (∀ θ₁ θ₂ : C(unitInterval, ℂ), (∀ t, Complex.exp (θ₁ t) = Θ t) →
        (∀ t, Complex.exp (θ₂ t) = Θ t) → θ₁ 0 = θ₂ 0 → θ₁ = θ₂) := by
  obtain ⟨β, hβn, hβm, ε, hε, hL, hR, Γn, Γm, hΓn, hΓm, hΓnne, hΓmne, hwn, hwm⟩ :=
    A.sigma_level_separation hsep
  obtain ⟨εp, hεp, hpole⟩ := A.stemWinding_circle_pole
  obtain ⟨Γp, hΓp, hΓpne, hΓploop, hΓpwind⟩ := hpole εp hεp le_rfl
  have hΓnloop : Γn 0 = Γn 1 := by rw [hΓn 0, hΓn 1, circleLoop_closed]
  have hΓmloop : Γm 0 = Γm 1 := by rw [hΓm 0, hΓm 1, circleLoop_closed]
  set N : ℕ := (stemWinding Γn + stemWinding Γm).toNat with hN_def
  set Θ : C(unitInterval, ℂ) := Γn * Γm * Γp ^ N with hΘ_def
  have hΘval : ∀ t, Θ t = Γn t * Γm t * Γp t ^ N := by
    intro t
    rw [hΘ_def]
    simp only [ContinuousMap.mul_apply, ContinuousMap.pow_apply]
  have hΘne : ∀ t, Θ t ≠ 0 := fun t => by
    rw [hΘval t]
    exact mul_ne_zero (mul_ne_zero (hΓnne t) (hΓmne t)) (pow_ne_zero _ (hΓpne t))
  have hΘloop : Θ 0 = Θ 1 := by
    rw [hΘval 0, hΘval 1, hΓnloop, hΓmloop, hΓploop]
  have hpow_ne : ∀ t, (Γp ^ N : C(unitInterval, ℂ)) t ≠ 0 := fun t => by
    rw [ContinuousMap.pow_apply]
    exact pow_ne_zero _ (hΓpne t)
  have hpow_loop : (Γp ^ N : C(unitInterval, ℂ)) 0 = (Γp ^ N) 1 := by
    rw [ContinuousMap.pow_apply, ContinuousMap.pow_apply, hΓploop]
  have hmul_ne : ∀ t, (Γn * Γm : C(unitInterval, ℂ)) t ≠ 0 := fun t => by
    rw [ContinuousMap.mul_apply]
    exact mul_ne_zero (hΓnne t) (hΓmne t)
  have hmul_loop : (Γn * Γm : C(unitInterval, ℂ)) 0 = (Γn * Γm) 1 := by
    rw [ContinuousMap.mul_apply, ContinuousMap.mul_apply, hΓnloop, hΓmloop]
  have hΘwind : stemWinding Θ = 0 := by
    rw [hΘ_def, stemWinding_mul (Γn * Γm) (Γp ^ N) hmul_ne hpow_ne hmul_loop hpow_loop,
      stemWinding_mul Γn Γm hΓnne hΓmne hΓnloop hΓmloop,
      stemWinding_pow Γp hΓpne hΓploop N, hΓpwind, hN_def]
    omega
  obtain ⟨θ₀, hθ₀lift, hθ₀close⟩ := (stemWinding_eq_zero_iff Θ hΘne hΘloop).mp hΘwind
  refine ⟨β, hβn, hβm, ε, hε, hL, hR, εp, hεp, Γn, Γm, Γp, Θ, hΓn, hΓm, hΓp,
    hwn, hwm, hΓpwind, ?_, ?_, hΘval, hΘne, hΘloop, hΘwind,
    ⟨θ₀, hθ₀lift, hθ₀close⟩, ?_, ?_⟩
  · rintro ⟨γ', hlift, hclose⟩
    have h0 := (stemWinding_eq_zero_iff Γn hΓnne hΓnloop).mpr ⟨γ', hlift, hclose⟩
    omega
  · rintro ⟨γ', hlift, hclose⟩
    have h0 := (stemWinding_eq_zero_iff Γm hΓmne hΓmloop).mpr ⟨γ', hlift, hclose⟩
    omega
  · intro θ hθ
    exact winding_loop_closed Θ hΘne θ₀ hθ₀lift hθ₀close θ hθ
  · intro θ₁ θ₂ h₁ h₂ h0
    exact winding_lift_unique Θ hΘne θ₁ θ₂ h₁ h₂ h0

end ASection
