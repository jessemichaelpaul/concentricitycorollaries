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
import Concentricity.SynthesisE6

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

/-! ## §C — the receipt: the two-center death at the target -/

/-- **W4 — THE DRIVE** (the limb's target: the repository's one open node,
`ASection.concentricity`, Theorem.lean:237; statement identical). The
two-center death, with the joined boards fed in full — every possession
below is PROVED in this file, WeldW12, WeldW3, SynthesisE6, KernelE4,
SigmaE3, LoopAssembly, or LiKernel:

SUPPOSE TWO LEVELS (the equivalent faces, driven directly): the
supposition denies the second family at β = supLevel
(`concentricity_iff_second_family_at_supLevel`), denies ∃β two-sided in
BOTH its order form (`concentricity_iff_exists_two_sided_level`) and its
kernel form (`placement_set_iff_liSum`), and supplies a zero strictly
below the top level, hence a PAIR at distinct levels
(`exists_zero_level_above`).

THE COUNTING (§A): two disjoint strip rectangles separated by Re = β,
each trapping ≥ 1 zero, each value-loop winding EXACTLY its own count,
the ledgers exactly additive. THE WALLS (W12): the right half-space is
winding-inert (`stemWinding_F_halfSpace`, the Euler sum the global lift)
with majorant-controlled wall argument (`arg_control_right_wall`); the
left region is zero-free and winding-inert (`exists_leftWall_zero_free`,
`stemWinding_F_leftRegion`). THE ONE BAND (§B): both side loops
obstructed alone; the composite through C1's cone closes — winding zero,
unique tame lift a loop, every lift closed. THE OCTONIONIC REGISTER
(W3): the sphere loops are tame with constant companion; the realized
value loops wind the tallies ≥ 1 and touch the degenerate fibre; the
touched fibres and the kernel are concentric (`exp_fibre_concentric`);
the two zeros' encounters share ONE ladder (`shared_ladder_encounters`).
THE CONE (E6): `pole_cone_eps_delta`, the zero–witness pair closing at
tally 1 (`zero_pole_pair_closes_through_witness`), the Φ glue and its
wedge.

RECEIPT (R6, 2026-07-06): goal at the stop
  ⊢ False
and RESISTS. Machine verdicts of this burn, verbatim: `exact?` at the
seam with the complete feed — "(deterministic) timeout at `whnf`, maximum
number of heartbeats (200000) has been reached" (the search does not
terminate on the full board); `exact?` at the equivalent face
`⊢ A.supLevel ≤ (A.sphereZero k).re` with the §A/§B rows and the E4 edge
families in context — "`exact?` could not close the goal."
Equivalent-face forms of the same stop (KernelE4, proved iffs):
  ⊢ A.supLevel ≤ (A.sphereZero k).re        (any k — no zero strictly
                                             below the top level)
  ⊢ 0 ≤ A.liSum a A.supLevel j              (supLevel < a, 1 ≤ j — the
                                             second family at supLevel)
THE MISSING JOINT, in the weld vocabulary: every fed possession pins
VALUE-side data (the closed composite's conserved level is log r of the
values it sweeps; the touched ladders are the encounters' own; the
counting pins each rectangle's winding to its OWN trapped count,
additivity and nothing more) or DOMAIN-side direction data (the tame
companion v); the goal names DOMAIN-side LEVELS Re(sphereZero ·). The
identification of the two registers is `eq:placement-set` itself = ∃β
two-sided (`auditE1_target_iff_two_sided`) = W12 §F's cross-contour
constraint. THE UNTRANSCRIBED GPV CONSEQUENCE OF C1–C4: GPVwind
Cor 5.13's σ ∈ {0,−1} lift-existence criterion at NONEMPTY obstruction
sets on the octonionic register — its flip data (Def 5.2) lives on
one-sided limits of the direction field at real crossings, where
`Octonion.dir` is junk 0 and Rem 2.1 (verbatim: "the function 𝓘 cannot
be extended as a continuous function to any single point of the real
axis ℝ of 𝕂") forbids the continuous extension that would carry it; the
loops the C1–C4 board owns have EMPTY obstruction sets (WeldW3 §(b)) or
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
(the charter's honesty pin): every fed possession holds VERBATIM for a
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
beyond the feed could live is `c2_zero_free`'s splitting demand (AuditE1
§GLOSS flag, unresolved), the author's lane (R6). The `sorry` is the
ROUTE RECEIPT (unimported artifact; R8), not a queue item. -/
theorem concentricity_via_weldW4 (A : ASection) :
    ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c := by
  by_contra hno
  -- the equivalent faces, driven directly (KernelE4's proved iffs):
  -- the supposition denies the second family at β = supLevel …
  have hface₁ : ¬ ∀ a : ℝ, A.supLevel < a → ∀ j : ℕ, 1 ≤ j →
      0 ≤ A.liSum a A.supLevel j :=
    fun h => hno ((A.concentricity_iff_second_family_at_supLevel).mpr h)
  -- … and ∃β two-sided, in the order form and the kernel form (D2)
  have hface₂ : ¬ ∃ β : ℝ, A.supLevel ≤ β ∧ β ≤ A.infLevel :=
    fun h => hno ((A.concentricity_iff_exists_two_sided_level).mpr h)
  have hface₃ : ¬ ∃ β : ℝ,
      (∀ a : ℝ, a < β → ∀ j : ℕ, 1 ≤ j → 0 ≤ A.liSum a β j)
      ∧ (∀ a : ℝ, β < a → ∀ j : ℕ, 1 ≤ j → 0 ≤ A.liSum a β j) := by
    intro h
    have hplace := (A.placement_set_iff_liSum).mpr h
    exact hno ⟨(A.sphereZero 0).re, fun j =>
      hplace (A.stem_zero_of_sphereZero j) (A.stem_zero_of_sphereZero 0)
        (A.c3_sphere_nonreal j) (A.c3_sphere_nonreal 0)⟩
  -- the first family at supLevel is a possession — ONLY the second is denied
  have hfirst_top := A.liSum_first_family_at_supLevel
  -- the two-center pair
  have hnot : ¬ ∀ k : ℕ, A.supLevel ≤ (A.sphereZero k).re :=
    fun h => hno ((A.concentricity_iff_supLevel_le).mpr h)
  push Not at hnot
  obtain ⟨k, hk⟩ := hnot
  obtain ⟨m, hkm⟩ := A.exists_zero_level_above hk
  -- §A: the counting — two DISJOINT rectangles, exact counts ≥ 1 each
  obtain ⟨β, hβ₁, hβ₂, xn₁, xn₂, yn₁, yn₂, xm₁, xm₂, ym₁, ym₂, hxβ, hβx,
    hyn₁, hym₁, hρn, hρm, sn, sm, hsn, hsm, hcn, hcm, hdisj, hcard,
    Γn, Γm, hΓn, hΓm, hwn, hwm⟩ := A.two_center_disjoint_counts hkm
  -- W12: the walls — right half-space inert + argument-controlled; left
  -- region zero-free and inert
  have hwallR := @A.stemWinding_F_halfSpace
  have hwallR' := @A.arg_control_right_wall
  obtain ⟨βlo, hβlo, hleftfree⟩ := A.exists_leftWall_zero_free
  have hwallL := @A.stemWinding_F_leftRegion
  -- §B: the composite through the cone — the winding onto the ONE band
  obtain ⟨β', hβ'₁, hβ'₂, ε, hε, hL, hR, εp, hεp, Γn', Γm', Γp, Θ,
    hΓn', hΓm', hΓp, hwn', hwm', hwp, hobsn, hobsm, hΘval, hΘne, hΘloop,
    hΘwind, hΘcloses, hΘall, hΘunique⟩ := A.two_center_winding_onto_one_band hkm
  -- W3: the octonionic register — the difference, the tame loops, the
  -- touch, the concentric kernel, the shared ladder
  have hW3a := @Octonion.direction_path_to_neg
  have hW3a' := stem_direction_disconnected
  have hW3b := @A.sphereLoop_tame
  have hW3c := @A.sphereLoop_value_winding
  have hW3d := A.sphereLoop_touches_degenerate k
  have hW3d' := A.sphereLoop_touches_degenerate m
  have hW3e := @Octonion.exp_fibre_concentric
  have hshared := A.shared_ladder_encounters k m
  -- E6: the cone ε–δ, the zero–witness closure at tally 1, the Φ glue/wedge
  have hcone := A.pole_cone_eps_delta
  have hE6c := @A.zero_pole_pair_closes_through_witness
  have hE6d := A.phi_shared_ladder_glue k m
  have hE6e := A.phi_encounter_read_not_unique k
  -- RECEIPT: ⊢ False — the fed possessions pin value-side levels and
  -- domain-side directions; the goal names domain-side levels; the
  -- identification of the two registers is eq:placement-set itself.
  sorry

end ASection
