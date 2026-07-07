/-
Concentricity/FlipWeld.lean

THE FLIP BUILDOUT — the machine-isolated final GPV clause (unimported
working artifact; KeystoneAssembly / GreatCircleRoute / SigmaE3 / WeldW12
precedent; NOT imported by the root — the imported ledger is untouched).

THE AUTHOR'S REGISTER (2026-07-07, folded in throughout): GPV LIVES ON THE
BASE 𝓑 ITSELF — the base is the levels-and-winding structure of exp's
degenerate set, GPV's home; "static" is ONLY the categorical encoding (no
morphisms between distinct levels = the level conserved), never the absence
of GPV's dynamics. The A-section is DEFINED by C1–C4 and extends ALL of
GPV; the flip data below is the last untranscribed part of GPV's life
on 𝓑.

WHAT IS TRANSCRIBED (SOURCES/GPVwind.md, verbatim quotes in the docstrings;
every §A–§D row PROVED on the kernel triple; helpers never sorried, R8):

§A — Def 5.2's flip machinery at ISOLATED stem crossings + Rem 2.1's junk
honesty: `stemDirSign_eq_zero_iff` (the direction datum AT the crossing is
the junk 0 — the data is one-sided), `stem_sign_eq_on_free` (IVT sign
constancy along obstruction-free arcs), `obstruction_free_left/right`
(finite obstruction sets isolate every crossing), and THE EXISTENCE ROW
`crossingData_of_isolated`: at an isolated interior stem crossing the
one-sided limits of Def 5.2's field Y/|Y| EXIST — Def 5.2's clause 3
("not tame") is EMPTY on the stem at isolated crossings; tameness is
automatic and the flip/bounce dichotomy (`CrossingData.flip_or_bounce`,
SigmaE3) is total.

§B — Def 5.7/5.19's alternating flip sum, the integer skeleton:
`circularSignature_int_parity` (the alternating ±1 sum is an integer of
the flip count's parity, bounded by the flip count),
`stemSignature_int_parity`, `stemSignature_ne_zero_of_odd_flips`, and the
Cor 5.13 packaging `stemSignature_eq_neg_one_of_odd` (criterion + odd
flips ⇒ σ = −1).

§C — Cor 5.13 AT NONEMPTY OBSTRUCTION SETS, the stem face: `arc_one_band`
(each big arc's lift height lives in ONE rung band — "the log-lift's
imaginary part moves within (0,π) or (−π,0) per arc", generalized to every
band), the chaining rows `CrossingData.bounce_conserves_band` /
`CrossingData.flip_steps_band` (Prop 5.8's mechanism as an iff: bounces
conserve the side of the rung, flips swap it — how arcs chain), THE CORE
`exists_flip_of_up_rung` + `exists_flip_of_rung_between` (a lift height
passing a rung between two parameters forces an honest Def 5.2 FLIP
strictly between them — the csInf first-crossing argument), the loop row
`exists_interior_flip_of_stemWinding_ne_zero` (nonzero winding ⇒ an
interior flip exists, obstruction set finite), and the closure face
`closed_lift_of_no_interior_flip`: NO interior flips ⇒ σ = 0 (Def 5.7's
closing clause) ∈ {0,−1} ⇒ the lift exists and IS a loop — Cor 5.13's
criterion verified end-to-end on the stem in its no-flip instance.

§D — THE LEVEL CONTACT (where GPV touches the levels):
`ASection.domain_crossing_obstruction` (a domain path crossing the domain's
ℝ — where the levels live — lands IN the value obstruction set, crossing
value F(x) real: `real_on_real`, the intrinsicality row),
`weierstrassE_conj` / `spherePrimary_ofReal` / `_pos` (at real points every
residue-ℂ sphere factor is |·|² > 0 — the LEVELS' carriers are INVISIBLE to
crossing signs), `ASection.sphereTail_real_nonneg` (the full C3 sphere tail
is real ≥ 0 on ℝ), `ASection.crossing_sign_rigid` (the crossing sign is
computed by the REAL divisor and the pole alone),
`ASection.crossing_sign_const_between` (Def 5.7's σ-inputs are constant
between consecutive real-divisor points), and the assembly row
`ASection.rect_value_flip` (a rectangle trapping an enumerated zero forces
an interior FLIP on the section's value-loop — the divisor produces Def
5.2 flips, given a finite obstruction set).

THE RECEIPT (the file's ONE `sorry`, R6/R8 — the exact resisting goal):
`concentricity_via_flipWeld` at `⊢ False` with the complete board fed; see
its docstring for the two precise missing producers ((α) finiteness/
tameness of the value obstruction sets — GPV's OWN general case, Defs
5.15–5.19, companion-relative interval flips, is the remaining
untranscribed clause; (β) the cross-contour identification, the same seam
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
untouched.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.WeldW4
import Mathlib.Order.CompleteLatticeIntervals
import Mathlib.Topology.Order.DenselyOrdered
import Mathlib.Topology.Order.LeftRightNhds

noncomputable section

open Complex

/-! ## §A — Def 5.2's flip data at isolated stem crossings (Rem 2.1 honesty) -/

/-- **Rem 2.1's junk honesty, pointwise form** (GPVwind Rem 2.1,
SOURCES/GPVwind.md, verbatim: "the function 𝓘 cannot be extended as a
continuous function to any single point of the real axis ℝ of 𝕂"): AT an
obstruction parameter the pointwise stem direction datum is the junk value
`0` — never ±1, never a direction. The honest data of Def 5.2 is the pair
of ONE-SIDED limits (5.4), carried by `CrossingData` (SigmaE3). DERIVED
(R10). -/
theorem stemDirSign_eq_zero_iff (γ : C(unitInterval, ℂ)) (t : unitInterval) :
    stemDirSign γ t = 0 ↔ t ∈ obstructionSet γ := by
  unfold stemDirSign obstructionSet
  exact Real.sign_eq_zero_iff

/-- The ±1 helper: the sign of a nonzero real is a unit. -/
theorem sign_pm_of_ne_zero {x : ℝ} (hx : x ≠ 0) :
    Real.sign x = 1 ∨ Real.sign x = -1 := by
  rcases lt_or_gt_of_ne hx with h | h
  · exact Or.inr (Real.sign_of_neg h)
  · exact Or.inl (Real.sign_of_pos h)

/-- `(−1)^j` is a unit. -/
theorem neg_one_zpow_pm (j : ℤ) : (-1 : ℝ) ^ j = 1 ∨ (-1 : ℝ) ^ j = -1 := by
  rcases Int.even_or_odd j with hj | hj
  · exact Or.inl (Even.neg_one_zpow hj)
  · exact Or.inr (Odd.neg_one_zpow hj)

/-- Two distinct units are opposite. -/
theorem pm_resolve_neq {s z : ℝ} (hs : s = 1 ∨ s = -1) (hz : z = 1 ∨ z = -1)
    (h : s ≠ z) : s = -z := by
  rcases hs with h1 | h1 <;> rcases hz with h2 | h2 <;> subst h1 <;> subst h2 <;>
    first
      | exact absurd rfl h
      | norm_num

/-- **IVT sign constancy along an obstruction-free arc** (the mechanism
behind Def 5.2's one-sided limits on the stem): if the value stays off ℝ
throughout an open parameter interval, the direction sign `sign (im γ)` is
one constant on it — a sign change would force a crossing in between
(intermediate value). DERIVED (R10). -/
theorem stem_sign_eq_on_free (γ : C(unitInterval, ℂ)) {v w : unitInterval}
    (hfree : ∀ u, v < u → u < w → (γ u).im ≠ 0) {u₁ u₂ : unitInterval}
    (h₁ : v < u₁) (h₁' : u₁ < w) (h₂ : v < u₂) (h₂' : u₂ < w) :
    Real.sign ((γ u₁).im) = Real.sign ((γ u₂).im) := by
  -- the ordered core
  have core : ∀ p q : unitInterval, v < p → p < w → v < q → q < w → p ≤ q →
      Real.sign ((γ p).im) = Real.sign ((γ q).im) := by
    intro p q hp hp' hq hq' hpq
    have hcont : ContinuousOn (fun u => (γ u).im) (Set.Icc p q) :=
      (Complex.continuous_im.comp (map_continuous γ)).continuousOn
    have hmemfree : ∀ u ∈ Set.Icc p q, (γ u).im ≠ 0 := fun u hu =>
      hfree u (lt_of_lt_of_le hp hu.1) (lt_of_le_of_lt hu.2 hq')
    rcases lt_trichotomy ((γ p).im) 0 with hp0 | hp0 | hp0
    · rcases lt_trichotomy ((γ q).im) 0 with hq0 | hq0 | hq0
      · rw [Real.sign_of_neg hp0, Real.sign_of_neg hq0]
      · exact absurd hq0 (hmemfree q ⟨hpq, le_refl q⟩)
      · -- sign change: a zero in between, contradiction
        obtain ⟨u, hu, hu0⟩ := intermediate_value_Icc hpq hcont ⟨hp0.le, hq0.le⟩
        exact absurd hu0 (hmemfree u hu)
    · exact absurd hp0 (hmemfree p ⟨le_refl p, hpq⟩)
    · rcases lt_trichotomy ((γ q).im) 0 with hq0 | hq0 | hq0
      · obtain ⟨u, hu, hu0⟩ := intermediate_value_Icc' hpq hcont ⟨hq0.le, hp0.le⟩
        exact absurd hu0 (hmemfree u hu)
      · exact absurd hq0 (hmemfree q ⟨hpq, le_refl q⟩)
      · rw [Real.sign_of_pos hp0, Real.sign_of_pos hq0]
  rcases le_total u₁ u₂ with h | h
  · exact core u₁ u₂ h₁ h₁' h₂ h₂' h
  · exact (core u₂ u₁ h₂ h₂' h₁ h₁' h).symm

/-- **Finite obstruction sets isolate every crossing, left window**: below
any parameter `t > 0` there is a window `(v, t)` free of obstruction
parameters. (Def 5.1's obstruction set `T = γ⁻¹(ℝ)`, SOURCES/GPVwind.md;
the hypothesis of Def 5.2's enumeration `T = {a ≤ t₁ < … < t_p ≤ b}`.)
PROVED helper. -/
theorem obstruction_free_left (γ : C(unitInterval, ℂ))
    (hfin : (obstructionSet γ).Finite) {t : unitInterval} (ht : 0 < t) :
    ∃ v, v < t ∧ ∀ u, v < u → u < t → (γ u).im ≠ 0 := by
  classical
  set T' : Set unitInterval := obstructionSet γ ∩ Set.Iio t with hT'
  have hT'fin : T'.Finite := hfin.subset Set.inter_subset_left
  by_cases hne : T'.Nonempty
  · obtain ⟨x, hx⟩ := hne
    have hFne : hT'fin.toFinset.Nonempty := ⟨x, hT'fin.mem_toFinset.mpr hx⟩
    set v := hT'fin.toFinset.max' hFne with hv
    have hvT' : v ∈ T' := hT'fin.mem_toFinset.mp (hT'fin.toFinset.max'_mem hFne)
    refine ⟨v, hvT'.2, ?_⟩
    intro u h1 h2 him
    have huT' : u ∈ T' := ⟨him, h2⟩
    exact absurd (hT'fin.toFinset.le_max' u (hT'fin.mem_toFinset.mpr huT'))
      (not_le.mpr h1)
  · refine ⟨0, ht, ?_⟩
    intro u _ h2 him
    exact hne ⟨u, him, h2⟩

/-- Finite obstruction sets isolate every crossing, right window. PROVED
helper. -/
theorem obstruction_free_right (γ : C(unitInterval, ℂ))
    (hfin : (obstructionSet γ).Finite) {t : unitInterval} (ht : t < 1) :
    ∃ w, t < w ∧ ∀ u, t < u → u < w → (γ u).im ≠ 0 := by
  classical
  set T' : Set unitInterval := obstructionSet γ ∩ Set.Ioi t with hT'
  have hT'fin : T'.Finite := hfin.subset Set.inter_subset_left
  by_cases hne : T'.Nonempty
  · obtain ⟨x, hx⟩ := hne
    have hFne : hT'fin.toFinset.Nonempty := ⟨x, hT'fin.mem_toFinset.mpr hx⟩
    set w := hT'fin.toFinset.min' hFne with hw
    have hwT' : w ∈ T' := hT'fin.mem_toFinset.mp (hT'fin.toFinset.min'_mem hFne)
    refine ⟨w, hwT'.2, ?_⟩
    intro u h1 h2 him
    have huT' : u ∈ T' := ⟨him, h1⟩
    exact absurd (hT'fin.toFinset.min'_le u (hT'fin.mem_toFinset.mpr huT'))
      (not_le.mpr h2)
  · refine ⟨1, ht, ?_⟩
    intro u h1 _ him
    exact hne ⟨u, him, h1⟩

/-- **THE EXISTENCE ROW — Def 5.2 is total at isolated stem crossings**
(GPVwind Def 5.2, SOURCES/GPVwind.md, verbatim: "Consider the limits (5.4)
lim_{t→t_s^±} Y(t)/|Y(t)|. Let t_s ∈ (a,b). Then 1) γ is tame at t_s if
both limits are either equal or opposite. … 3) γ is not tame at t_s if at
least one of the limits in (5.4) does not exist."): at an ISOLATED interior
obstruction parameter of a stem path the one-sided limits ALWAYS exist —
on the stem the direction field is `sign(im γ)·i ∈ {±i}` off ℝ
(`stemDirSign`, SigmaE3), the target is discrete, and IVT sign constancy
(`stem_sign_eq_on_free`) makes each one-sided germ constant. Def 5.2's
clause 3 is EMPTY here: tameness is automatic, and the flip/bounce
dichotomy (`CrossingData.flip_or_bounce`, SigmaE3) is total. Rem 2.1's
honesty is kept: the datum AT `t` is the junk 0 (`stemDirSign_eq_zero_iff`);
only the one-sided data speak. DERIVED (R10). -/
theorem crossingData_of_isolated (γ : C(unitInterval, ℂ)) {t : unitInterval}
    (hobs : (γ t).im = 0)
    {v : unitInterval} (hv : v < t) (hfreeL : ∀ u, v < u → u < t → (γ u).im ≠ 0)
    {w : unitInterval} (hw : t < w) (hfreeR : ∀ u, t < u → u < w → (γ u).im ≠ 0) :
    ∃ d : CrossingData γ, d.t = t := by
  obtain ⟨pL, hpL1, hpL2⟩ := exists_between hv
  obtain ⟨pR, hpR1, hpR2⟩ := exists_between hw
  refine ⟨⟨t, hobs, Real.sign ((γ pL).im), Real.sign ((γ pR).im),
    sign_pm_of_ne_zero (hfreeL pL hpL1 hpL2),
    sign_pm_of_ne_zero (hfreeR pR hpR1 hpR2), ?_, ?_⟩, rfl⟩
  · filter_upwards [Ioo_mem_nhdsLT hv] with u hu
    exact stem_sign_eq_on_free γ hfreeL hu.1 hu.2 hpL1 hpL2
  · filter_upwards [Ioo_mem_nhdsGT hw] with u hu
    exact stem_sign_eq_on_free γ hfreeR hu.1 hu.2 hpR1 hpR2

/-- The finite-obstruction corollary: with `T = γ⁻¹(ℝ)` finite (Def 5.2's
standing hypothesis `T = {a ≤ t₁ < … < t_p ≤ b}`), EVERY interior
obstruction parameter carries crossing data. -/
theorem crossingData_of_finite_obstruction (γ : C(unitInterval, ℂ))
    (hfin : (obstructionSet γ).Finite) {t : unitInterval}
    (hobs : (γ t).im = 0) (h0 : 0 < t) (h1 : t < 1) :
    ∃ d : CrossingData γ, d.t = t := by
  obtain ⟨v, hv, hfreeL⟩ := obstruction_free_left γ hfin h0
  obtain ⟨w, hw, hfreeR⟩ := obstruction_free_right γ hfin h1
  exact crossingData_of_isolated γ hobs hv hfreeL hw hfreeR

/-! ## §B — Def 5.7/5.19: the alternating flip sum's integer skeleton -/

/-- The definitional bridge: `stemSignature` (SigmaE3's Def 5.7 rendering)
IS the circular-signature engine applied to the crossing-value signs. -/
theorem stemSignature_eq_circularSignature (γ : C(unitInterval, ℂ)) {m : ℕ}
    (ξ : Fin m → unitInterval) :
    stemSignature γ ξ = circularSignature fun l => Real.sign ((γ (ξ l)).re) :=
  rfl

/-- **The integer skeleton of Def 5.19's circular signature** (GPVwind
Def 5.19, SOURCES/GPVwind.md, verbatim: "σᶜ(γ,𝔍) := ∑_{l=1}^k
sign([e_l,s_{l+1}]))(−1)^l"; Def 5.16 makes each input ±1): an alternating
sum of `m` unit signs is an integer `k` with `|k| ≤ m` and `k ≡ m (mod 2)`.
The parity clause is the flip-count parity of Cor 5.21's accounting
(`ω = |σᶜ|/2` needs σᶜ even — FLAGS item 3). DERIVED (R10). -/
theorem circularSignature_int_parity : ∀ {m : ℕ} (signs : Fin m → ℝ),
    (∀ l, signs l = 1 ∨ signs l = -1) →
    ∃ k : ℤ, circularSignature signs = (k : ℝ) ∧ k.natAbs ≤ m ∧
      (m + k.natAbs) % 2 = 0 := by
  intro m
  induction m with
  | zero =>
    intro signs _
    exact ⟨0, by simp [circularSignature], by simp, by simp⟩
  | succ n ih =>
    intro signs hpm
    obtain ⟨k, hk, hk1, hk2⟩ := ih (fun l => signs l.succ) fun l => hpm l.succ
    have hsplit : circularSignature signs
        = -(signs 0) + (-1) * circularSignature fun l => signs l.succ := by
      unfold circularSignature
      rw [Fin.sum_univ_succ, Finset.mul_sum]
      congr 1
      · simp
      · refine Finset.sum_congr rfl fun l _ => ?_
        rw [Fin.val_succ, pow_succ]
        ring
    rcases hpm 0 with h0 | h0
    · refine ⟨-1 - k, ?_, by omega, by omega⟩
      rw [hsplit, h0, hk]
      push_cast
      ring
    · refine ⟨1 - k, ?_, by omega, by omega⟩
      rw [hsplit, h0, hk]
      push_cast
      ring

/-- Def 5.7's stem signature over nonzero real crossing values is an
integer of the flip count's parity, bounded by the flip count. -/
theorem stemSignature_int_parity (γ : C(unitInterval, ℂ)) {m : ℕ}
    (ξ : Fin m → unitInterval) (hne : ∀ l, (γ (ξ l)).re ≠ 0) :
    ∃ k : ℤ, stemSignature γ ξ = (k : ℝ) ∧ k.natAbs ≤ m ∧
      (m + k.natAbs) % 2 = 0 := by
  rw [stemSignature_eq_circularSignature]
  exact circularSignature_int_parity _ fun l => sign_pm_of_ne_zero (hne l)

/-- **An odd flip count forces σ ≠ 0** — Def 5.7's closing clause ("If
there are no flips, then we define σ(γ) := 0") read against the parity
skeleton: zero is even-parity, so an odd number of flips with nonzero real
crossing values can never sum to it. -/
theorem stemSignature_ne_zero_of_odd_flips (γ : C(unitInterval, ℂ)) {m : ℕ}
    (ξ : Fin m → unitInterval) (hne : ∀ l, (γ (ξ l)).re ≠ 0)
    (hm : m % 2 = 1) : stemSignature γ ξ ≠ 0 := by
  intro h0
  obtain ⟨k, hk, _, hpar⟩ := stemSignature_int_parity γ ξ hne
  rw [h0] at hk
  have hk0 : k = 0 := by exact_mod_cast hk.symm
  rw [hk0] at hpar
  omega

/-- **Cor 5.13's criterion at an odd flip count pins σ = −1** (GPVwind
Cor 5.13, SOURCES/GPVwind.md, verbatim: "Then a lift of γ in 𝓔⁺_𝕂 exists
if and only if σ(γ|_{[ξ_l,ξ_{l+1}]}) ∈ {0,−1} for each l = 1,…,m−1"): if
the criterion's admissible set is met and the flip count is odd, the
signature is exactly −1. -/
theorem stemSignature_eq_neg_one_of_odd (γ : C(unitInterval, ℂ)) {m : ℕ}
    (ξ : Fin m → unitInterval) (hne : ∀ l, (γ (ξ l)).re ≠ 0)
    (hm : m % 2 = 1)
    (hcrit : stemSignature γ ξ = 0 ∨ stemSignature γ ξ = -1) :
    stemSignature γ ξ = -1 := by
  rcases hcrit with h | h
  · exact absurd h (stemSignature_ne_zero_of_odd_flips γ ξ hne hm)
  · exact h

/-! ## §C — Cor 5.13 at nonempty obstruction sets: arcs, chaining, the flip
producer, and the no-flip closure -/

/-- **Each big arc lives in ONE band** (the stem form of "the log-lift's
imaginary part moves within (0,π) or (−π,0) per arc", every band): along a
parameter interval whose interior is obstruction-free, the lift's height
stays strictly inside a single rung band `(jπ, (j+1)π)`. Route:
`lift_height_pi_iff` (rungs = obstruction set) + `arc_band_confined`
(SigmaE3, Props 5.5/5.6's conservation). DERIVED (R10). -/
theorem arc_one_band (γ γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) {s t : unitInterval} (hst : s < t)
    (hfree : ∀ u, s < u → u < t → (γ u).im ≠ 0) :
    ∃ j : ℤ, ∀ u, s < u → u < t →
      (j : ℝ) * Real.pi < (γ' u).im ∧ (γ' u).im < ((j : ℝ) + 1) * Real.pi := by
  obtain ⟨p, hp1, hp2⟩ := exists_between hst
  have hπ := Real.pi_pos
  have hpfree : (γ p).im ≠ 0 := hfree p hp1 hp2
  have hprung : ∀ i : ℤ, (γ' p).im ≠ (i : ℝ) * Real.pi := by
    intro i hi
    exact hpfree ((lift_height_pi_iff γ γ' hlift p).mpr ⟨i, hi⟩)
  set j : ℤ := ⌊(γ' p).im / Real.pi⌋ with hj
  have hjle : (j : ℝ) * Real.pi ≤ (γ' p).im := by
    have h1 := Int.floor_le ((γ' p).im / Real.pi)
    calc (j : ℝ) * Real.pi ≤ ((γ' p).im / Real.pi) * Real.pi :=
          mul_le_mul_of_nonneg_right h1 hπ.le
    _ = (γ' p).im := div_mul_cancel₀ _ hπ.ne'
  have hjp : (j : ℝ) * Real.pi < (γ' p).im := lt_of_le_of_ne hjle (Ne.symm (hprung j))
  have hjp' : (γ' p).im < ((j : ℝ) + 1) * Real.pi := by
    have h1 := Int.lt_floor_add_one ((γ' p).im / Real.pi)
    have h2 : (γ' p).im / Real.pi * Real.pi < ((j : ℝ) + 1) * Real.pi :=
      mul_lt_mul_of_pos_right h1 hπ
    rwa [div_mul_cancel₀ _ hπ.ne'] at h2
  refine ⟨j, ?_⟩
  intro u hu1 hu2
  -- confinement between u and p across rungs j and j+1
  have key : ∀ i : ℤ, ((γ' u).im < (i : ℝ) * Real.pi ↔ (γ' p).im < (i : ℝ) * Real.pi) := by
    intro i
    rcases le_total u p with h | h
    · exact arc_band_confined γ γ' hlift h
        (fun q h1 h2 => hfree q (lt_of_lt_of_le hu1 h1) (lt_of_le_of_lt h2 hp2)) i
    · exact (arc_band_confined γ γ' hlift h
        (fun q h1 h2 => hfree q (lt_of_lt_of_le hp1 h1) (lt_of_le_of_lt h2 hu2)) i).symm
  have hufree : (γ u).im ≠ 0 := hfree u hu1 hu2
  have hurung : ∀ i : ℤ, (γ' u).im ≠ (i : ℝ) * Real.pi := by
    intro i hi
    exact hufree ((lift_height_pi_iff γ γ' hlift u).mpr ⟨i, hi⟩)
  constructor
  · have h1 : ¬((γ' u).im < (j : ℝ) * Real.pi) := by
      rw [key j]
      exact not_lt.mpr hjp.le
    exact lt_of_le_of_ne (not_lt.mp h1) (Ne.symm (hurung j))
  · have h1 : (γ' u).im < ((j + 1 : ℤ) : ℝ) * Real.pi := by
      rw [key (j + 1)]
      push_cast
      exact hjp'
    push_cast at h1
    exact h1

namespace CrossingData

variable {γ : C(unitInterval, ℂ)}

/-- The crossing's one-sided data live OFF the real axis, left germ: the
eventual direction sign is a unit, so the value is eventually non-real. -/
theorem eventually_im_ne_left (d : CrossingData γ) :
    ∀ᶠ u in nhdsWithin d.t (Set.Iio d.t), (γ u).im ≠ 0 := by
  filter_upwards [d.eventually_left] with u hu h0
  rw [h0, Real.sign_zero] at hu
  rcases d.sLeft_unit with h | h <;> rw [← hu] at h <;> norm_num at h

/-- Right germ of `eventually_im_ne_left`. -/
theorem eventually_im_ne_right (d : CrossingData γ) :
    ∀ᶠ u in nhdsWithin d.t (Set.Ioi d.t), (γ u).im ≠ 0 := by
  filter_upwards [d.eventually_right] with u hu h0
  rw [h0, Real.sign_zero] at hu
  rcases d.sRight_unit with h | h <;> rw [← hu] at h <;> norm_num at h

/-- The left band-side readout: eventually-above-the-rung on the left IS
the ledger equation `sLeft = (−1)^j` (`crossing_band_ledger`, SigmaE3 —
Prop 5.8's mechanism). Interior on the left so the germ is honest. -/
theorem eventually_above_iff_left (γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) (d : CrossingData γ) {j : ℤ}
    (hj : (γ' d.t).im = (j : ℝ) * Real.pi) (h0 : (0 : unitInterval) < d.t) :
    (∀ᶠ u in nhdsWithin d.t (Set.Iio d.t), (j : ℝ) * Real.pi < (γ' u).im)
      ↔ d.sLeft = (-1 : ℝ) ^ j := by
  haveI : (nhdsWithin d.t (Set.Iio d.t)).NeBot :=
    nhdsLT_neBot_of_exists_lt ⟨0, h0⟩
  have hL := (crossing_band_ledger γ γ' hlift d j hj).1
  constructor
  · intro h
    have := (h.and hL).mono fun u hu => hu.2.mp hu.1
    exact Filter.eventually_const.mp this
  · intro hq
    exact hL.mono fun u hu => hu.mpr hq

/-- The right band-side readout. -/
theorem eventually_above_iff_right (γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) (d : CrossingData γ) {j : ℤ}
    (hj : (γ' d.t).im = (j : ℝ) * Real.pi) (h1 : d.t < 1) :
    (∀ᶠ u in nhdsWithin d.t (Set.Ioi d.t), (j : ℝ) * Real.pi < (γ' u).im)
      ↔ d.sRight = (-1 : ℝ) ^ j := by
  haveI : (nhdsWithin d.t (Set.Ioi d.t)).NeBot :=
    nhdsGT_neBot_of_exists_gt ⟨1, h1⟩
  have hR := (crossing_band_ledger γ γ' hlift d j hj).2
  constructor
  · intro h
    have := (h.and hR).mono fun u hu => hu.2.mp hu.1
    exact Filter.eventually_const.mp this
  · intro hq
    exact hR.mono fun u hu => hu.mpr hq

/-- Eventually-below on the right is the NEGATED ledger equation — the
strict side uses the crossing data's own isolation
(`eventually_im_ne_right`: the germ is off ℝ, hence off every rung). -/
theorem eventually_below_iff_right (γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) (d : CrossingData γ) {j : ℤ}
    (hj : (γ' d.t).im = (j : ℝ) * Real.pi) (h1 : d.t < 1) :
    (∀ᶠ u in nhdsWithin d.t (Set.Ioi d.t), (γ' u).im < (j : ℝ) * Real.pi)
      ↔ ¬(d.sRight = (-1 : ℝ) ^ j) := by
  haveI : (nhdsWithin d.t (Set.Ioi d.t)).NeBot :=
    nhdsGT_neBot_of_exists_gt ⟨1, h1⟩
  have hR := (crossing_band_ledger γ γ' hlift d j hj).2
  have hne : ∀ᶠ u in nhdsWithin d.t (Set.Ioi d.t), (γ' u).im ≠ (j : ℝ) * Real.pi := by
    filter_upwards [d.eventually_im_ne_right] with u hu hru
    exact hu ((lift_height_pi_iff γ γ' hlift u).mpr ⟨j, hru⟩)
  constructor
  · intro h
    have := (h.and hR).mono fun u hu => by
      have : ¬((j : ℝ) * Real.pi < (γ' u).im) := not_lt.mpr hu.1.le
      exact fun hq => this (hu.2.mpr hq)
    exact Filter.eventually_const.mp this
  · intro hq
    filter_upwards [hR, hne] with u h2 h3
    have : ¬((j : ℝ) * Real.pi < (γ' u).im) := fun hgt => hq (h2.mp hgt)
    exact lt_of_le_of_ne (not_lt.mp this) h3

/-- **Bounces conserve the side of the rung** (GPVwind Def 5.2, verbatim:
"whereas if they are the same it is called a bounce"; the chaining clause
of Prop 5.8's mechanism: the arc after a bounce continues in the SAME band
as the arc before). DERIVED (R10). -/
theorem bounce_conserves_band (γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) (d : CrossingData γ) {j : ℤ}
    (hj : (γ' d.t).im = (j : ℝ) * Real.pi) (h0 : (0 : unitInterval) < d.t)
    (h1 : d.t < 1) (hb : d.IsBounce) :
    ((∀ᶠ u in nhdsWithin d.t (Set.Iio d.t), (j : ℝ) * Real.pi < (γ' u).im)
      ↔ (∀ᶠ u in nhdsWithin d.t (Set.Ioi d.t), (j : ℝ) * Real.pi < (γ' u).im)) := by
  rw [d.eventually_above_iff_left γ' hlift hj h0,
    d.eventually_above_iff_right γ' hlift hj h1]
  rw [IsBounce] at hb
  rw [hb]

/-- **Flips step the band** (GPVwind Def 5.2, verbatim: "if these limits
are opposite, then the parameter t_s is called a flip"; the chaining
clause: the arc after a flip continues in the ADJACENT band — above the
rung before iff below it after). DERIVED (R10). -/
theorem flip_steps_band (γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) (d : CrossingData γ) {j : ℤ}
    (hj : (γ' d.t).im = (j : ℝ) * Real.pi) (h0 : (0 : unitInterval) < d.t)
    (h1 : d.t < 1) (hf : d.IsFlip) :
    ((∀ᶠ u in nhdsWithin d.t (Set.Iio d.t), (j : ℝ) * Real.pi < (γ' u).im)
      ↔ (∀ᶠ u in nhdsWithin d.t (Set.Ioi d.t), (γ' u).im < (j : ℝ) * Real.pi)) := by
  rw [d.eventually_above_iff_left γ' hlift hj h0,
    d.eventually_below_iff_right γ' hlift hj h1]
  rw [IsFlip] at hf
  rw [hf]
  rcases d.sLeft_unit with h | h <;> rcases neg_one_zpow_pm j with h2 | h2 <;>
    rw [h, h2] <;> norm_num

end CrossingData

/-- **THE FLIP PRODUCER, ascending face** (the csInf first-crossing
argument): if the lift's height sits below the rung `jπ` at `a` and above
it at `b`, then STRICTLY BETWEEN `a` and `b` there is an honest Def 5.2
FLIP — the first parameter past which the height exceeds the rung is an
obstruction parameter whose one-sided direction limits exist and are
OPPOSITE. This is where Cor 5.13's criterion meets a nonempty obstruction
set on the stem: the height cannot change bands without a flip
(`arc_band_confined` forbids it along arcs, `bounce_conserves_band` at
bounces). PROVED. -/
theorem exists_flip_of_up_rung (γ γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t)
    (hfin : (obstructionSet γ).Finite) {a b : unitInterval} (hab : a < b)
    {j : ℤ} (ha : (γ' a).im < (j : ℝ) * Real.pi)
    (hb : (j : ℝ) * Real.pi < (γ' b).im) :
    ∃ d : CrossingData γ, a < d.t ∧ d.t < b ∧ d.IsFlip := by
  classical
  set h : unitInterval → ℝ := fun u => (γ' u).im with hh
  have hcont : Continuous h := Complex.continuous_im.comp (map_continuous γ')
  set S : Set unitInterval := {u | u ∈ Set.Icc a b ∧ (j : ℝ) * Real.pi < h u}
    with hS
  have hbS : b ∈ S := ⟨⟨hab.le, le_refl b⟩, hb⟩
  have hSne : S.Nonempty := ⟨b, hbS⟩
  have hSbdd : BddBelow S := ⟨a, fun x hx => hx.1.1⟩
  set c : unitInterval := sInf S with hc
  have hac : a ≤ c := le_csInf hSne fun x hx => hx.1.1
  have hcb : c ≤ b := csInf_le hSbdd hbS
  -- left of the first crossing the height is at or below the rung
  have hle : ∀ u, a ≤ u → u < c → h u ≤ (j : ℝ) * Real.pi := by
    intro u hau huc
    by_contra hgt
    have huS : u ∈ S := ⟨⟨hau, huc.le.trans hcb⟩, not_le.mp hgt⟩
    exact absurd (csInf_le hSbdd huS) (not_le.mpr huc)
  -- (i) the height at c is at most the rung
  have hclej : h c ≤ (j : ℝ) * Real.pi := by
    by_contra hgt
    rw [not_le] at hgt
    have hane : a ≠ c := by
      intro h'
      rw [← h'] at hgt
      exact absurd hgt (not_lt.mpr ha.le)
    have hac' : a < c := lt_of_le_of_ne hac hane
    haveI : (nhdsWithin c (Set.Iio c)).NeBot := nhdsLT_neBot_of_exists_lt ⟨a, hac'⟩
    have hev : ∀ᶠ u in nhds c, (j : ℝ) * Real.pi < h u :=
      hcont.continuousAt.eventually_mem (isOpen_Ioi.mem_nhds hgt)
    have hIoo : ∀ᶠ u in nhdsWithin c (Set.Iio c), u ∈ Set.Ioo a c := by
      filter_upwards [Ioo_mem_nhdsLT hac'] with u hu using hu
    obtain ⟨u, hu1, hu2⟩ :=
      ((hev.filter_mono nhdsWithin_le_nhds).and hIoo).exists
    have huS : u ∈ S := ⟨⟨hu2.1.le, hu2.2.le.trans hcb⟩, hu1⟩
    exact absurd (csInf_le hSbdd huS) (not_le.mpr hu2.2)
  have hcnotS : c ∉ S := fun hcS => absurd hcS.2 (not_lt.mpr hclej)
  -- c is strictly left of b
  have hcltb : c < b := by
    refine lt_of_le_of_ne hcb ?_
    intro h'
    rw [h'] at hclej
    exact absurd hb (not_lt.mpr hclej)
  -- points of S crowd c from the right
  have hfreq : ∃ᶠ u in nhdsWithin c (Set.Ioi c), (j : ℝ) * Real.pi < h u := by
    rw [Filter.frequently_iff]
    intro U hU
    obtain ⟨w, hcw, hIooU⟩ := (mem_nhdsGT_iff_exists_Ioo_subset' hcltb).mp hU
    obtain ⟨x, hxS, hxw⟩ := (csInf_lt_iff hSbdd hSne).mp (hc ▸ hcw)
    have hcx : c < x := by
      refine lt_of_le_of_ne (csInf_le hSbdd hxS) ?_
      intro h'
      rw [← h'] at hxS
      exact hcnotS hxS
    exact ⟨x, hIooU ⟨hcx, hxw⟩, hxS.2⟩
  -- (ii) the height at c is at least the rung
  have hjlec : (j : ℝ) * Real.pi ≤ h c := by
    by_contra hlt
    rw [not_le] at hlt
    have hev : ∀ᶠ u in nhds c, h u < (j : ℝ) * Real.pi :=
      hcont.continuousAt.eventually_mem (isOpen_Iio.mem_nhds hlt)
    obtain ⟨u, hu1, hu2⟩ :=
      (hfreq.and_eventually (hev.filter_mono nhdsWithin_le_nhds)).exists
    exact absurd hu1 (not_lt.mpr hu2.le)
  have hrung : h c = (j : ℝ) * Real.pi := le_antisymm hclej hjlec
  have hac' : a < c := by
    refine lt_of_le_of_ne hac ?_
    intro h'
    rw [← h'] at hrung
    exact absurd hrung (ne_of_lt ha)
  -- c is an obstruction parameter
  have hcobs : (γ c).im = 0 := (lift_height_pi_iff γ γ' hlift c).mpr ⟨j, hrung⟩
  -- interior windows free of other crossings
  have h0c : (0 : unitInterval) < c := lt_of_le_of_lt unitInterval.nonneg' hac'
  have hc1 : c < 1 := lt_of_lt_of_le hcltb unitInterval.le_one'
  obtain ⟨v, hvc, hfreeL⟩ := obstruction_free_left γ hfin h0c
  obtain ⟨w, hcw, hfreeR⟩ := obstruction_free_right γ hfin hc1
  set v' : unitInterval := v ⊔ a with hv'
  have hv'c : v' < c := sup_lt_iff.mpr ⟨hvc, hac'⟩
  have hfreeL' : ∀ u, v' < u → u < c → (γ u).im ≠ 0 := fun u h1 h2 =>
    hfreeL u (lt_of_le_of_lt le_sup_left h1) h2
  set w' : unitInterval := w ⊓ b with hw'
  have hcw' : c < w' := lt_inf_iff.mpr ⟨hcw, hcltb⟩
  have hfreeR' : ∀ u, c < u → u < w' → (γ u).im ≠ 0 := fun u h1 h2 =>
    hfreeR u h1 (lt_of_lt_of_le h2 inf_le_left)
  -- the two-sided band window
  have hball : ∀ᶠ u in nhds c, |h u - (j : ℝ) * Real.pi| < Real.pi := by
    have htend : Filter.Tendsto h (nhds c) (nhds ((j : ℝ) * Real.pi)) := by
      rw [← hrung]
      exact hcont.continuousAt
    have h2 := Metric.tendsto_nhds.mp htend Real.pi Real.pi_pos
    filter_upwards [h2] with u hu
    rwa [Real.dist_eq] at hu
  -- eventually-left: strictly below the rung
  have hbelowL : ∀ᶠ u in nhdsWithin c (Set.Iio c), h u < (j : ℝ) * Real.pi := by
    filter_upwards [Ioo_mem_nhdsLT hv'c] with u hu
    have hle' : h u ≤ (j : ℝ) * Real.pi :=
      hle u (le_sup_right.trans hu.1.le) hu.2
    have hne' : h u ≠ (j : ℝ) * Real.pi := fun heq =>
      hfreeL' u hu.1 hu.2 ((lift_height_pi_iff γ γ' hlift u).mpr ⟨j, heq⟩)
    exact lt_of_le_of_ne hle' hne'
  -- the right reference point and the eventual sign rows
  obtain ⟨pR, hpR1, hpR2⟩ := exists_between hcw'
  have hsL_unit : -(-1 : ℝ) ^ j = 1 ∨ -(-1 : ℝ) ^ j = -1 := by
    rcases neg_one_zpow_pm j with h2 | h2 <;> rw [h2]
    · right; norm_num
    · left; norm_num
  have hsR_unit : Real.sign ((γ pR).im) = 1 ∨ Real.sign ((γ pR).im) = -1 :=
    sign_pm_of_ne_zero (hfreeR' pR hpR1 hpR2)
  have hevL : ∀ᶠ u in nhdsWithin c (Set.Iio c),
      Real.sign ((γ u).im) = -(-1 : ℝ) ^ j := by
    filter_upwards [hbelowL, hball.filter_mono nhdsWithin_le_nhds,
      Ioo_mem_nhdsLT hv'c] with u h1 h2 h3
    have hsu : Real.sign ((γ u).im) = 1 ∨ Real.sign ((γ u).im) = -1 :=
      sign_pm_of_ne_zero (hfreeL' u h3.1 h3.2)
    have hside := band_side_of_sign (hlift u) h2 rfl hsu
    have hneq : Real.sign ((γ u).im) ≠ (-1 : ℝ) ^ j := fun heq =>
      absurd (hside.mpr heq) (not_lt.mpr h1.le)
    exact pm_resolve_neq hsu (neg_one_zpow_pm j) hneq
  have hevR : ∀ᶠ u in nhdsWithin c (Set.Ioi c),
      Real.sign ((γ u).im) = Real.sign ((γ pR).im) := by
    filter_upwards [Ioo_mem_nhdsGT hcw'] with u hu
    exact stem_sign_eq_on_free γ hfreeR' hu.1 hu.2 hpR1 hpR2
  -- the right sign is read at a frequent above-rung point
  have hsR_val : Real.sign ((γ pR).im) = (-1 : ℝ) ^ j := by
    obtain ⟨u, hu1, hu2, hu3⟩ :=
      (hfreq.and_eventually ((hball.filter_mono nhdsWithin_le_nhds).and hevR)).exists
    exact (band_side_of_sign (hlift u) hu2 hu3 hsR_unit).mp hu1
  refine ⟨⟨c, hcobs, -(-1 : ℝ) ^ j, Real.sign ((γ pR).im), hsL_unit, hsR_unit,
    hevL, hevR⟩, hac', hcltb, ?_⟩
  show Real.sign ((γ pR).im) = -(-(-1 : ℝ) ^ j)
  rw [neg_neg]
  exact hsR_val

/-- The value-conjugate of a stem loop (the reflection across ℝ — the
mirror move available on the stem because the slice picture is
conjugation-symmetric). -/
def conjLoop (γ : C(unitInterval, ℂ)) : C(unitInterval, ℂ) :=
  ⟨fun t => starRingEnd ℂ (γ t), Complex.continuous_conj.comp (map_continuous γ)⟩

theorem conjLoop_apply (γ : C(unitInterval, ℂ)) (t : unitInterval) :
    conjLoop γ t = starRingEnd ℂ (γ t) := rfl

/-- Conjugation preserves the obstruction set (Def 5.1's `T = γ⁻¹(ℝ)`): ℝ
is conjugation-fixed. -/
theorem conjLoop_obstructionSet (γ : C(unitInterval, ℂ)) :
    obstructionSet (conjLoop γ) = obstructionSet γ := by
  ext t
  show (conjLoop γ t).im = 0 ↔ (γ t).im = 0
  rw [conjLoop_apply, Complex.conj_im, neg_eq_zero]

/-- Crossing data transports back across conjugation with NEGATED one-sided
signs (the direction field flips with the mirror). -/
def CrossingData.ofConj {γ : C(unitInterval, ℂ)}
    (d : CrossingData (conjLoop γ)) : CrossingData γ where
  t := d.t
  obstruction := by
    have h := d.obstruction
    rw [conjLoop_apply, Complex.conj_im, neg_eq_zero] at h
    exact h
  sLeft := -d.sLeft
  sRight := -d.sRight
  sLeft_unit := by
    rcases d.sLeft_unit with h | h <;> rw [h]
    · right; norm_num
    · left; norm_num
  sRight_unit := by
    rcases d.sRight_unit with h | h <;> rw [h]
    · right; norm_num
    · left; norm_num
  eventually_left := by
    filter_upwards [d.eventually_left] with u hu
    rw [conjLoop_apply, Complex.conj_im, Real.sign_neg] at hu
    linarith
  eventually_right := by
    filter_upwards [d.eventually_right] with u hu
    rw [conjLoop_apply, Complex.conj_im, Real.sign_neg] at hu
    linarith

theorem CrossingData.ofConj_t {γ : C(unitInterval, ℂ)}
    (d : CrossingData (conjLoop γ)) : d.ofConj.t = d.t := rfl

/-- The mirror preserves flips (opposite-signs is a symmetric relation). -/
theorem CrossingData.ofConj_isFlip {γ : C(unitInterval, ℂ)}
    (d : CrossingData (conjLoop γ)) (hf : d.IsFlip) : d.ofConj.IsFlip := by
  rw [IsFlip] at hf ⊢
  show -d.sRight = -(-d.sLeft)
  rw [hf]

/-- **THE FLIP PRODUCER, both faces**: a lift height passing a rung between
two parameters — in either direction — forces a Def 5.2 FLIP strictly
between them. The descending face rides the ascending one through the
mirror `conjLoop` (height negates, rung `j ↦ −j`, flips are preserved).
PROVED. -/
theorem exists_flip_of_rung_between (γ γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t)
    (hfin : (obstructionSet γ).Finite) {a b : unitInterval} (hab : a < b)
    {j : ℤ}
    (hside : ((γ' a).im < (j : ℝ) * Real.pi ∧ (j : ℝ) * Real.pi < (γ' b).im) ∨
      ((γ' b).im < (j : ℝ) * Real.pi ∧ (j : ℝ) * Real.pi < (γ' a).im)) :
    ∃ d : CrossingData γ, a < d.t ∧ d.t < b ∧ d.IsFlip := by
  rcases hside with ⟨h1, h2⟩ | ⟨h1, h2⟩
  · exact exists_flip_of_up_rung γ γ' hlift hfin hab h1 h2
  · -- the mirror: conjugate loop, conjugate lift, rung −j
    set γc' : C(unitInterval, ℂ) :=
      ⟨fun t => starRingEnd ℂ (γ' t), Complex.continuous_conj.comp (map_continuous γ')⟩
      with hγc'
    have hliftc : ∀ t, Complex.exp (γc' t) = conjLoop γ t := fun t => by
      show Complex.exp (starRingEnd ℂ (γ' t)) = starRingEnd ℂ (γ t)
      rw [Complex.exp_conj, hlift t]
    have hfinc : (obstructionSet (conjLoop γ)).Finite := by
      rw [conjLoop_obstructionSet]
      exact hfin
    have hheight : ∀ u : unitInterval, (γc' u).im = -(γ' u).im := fun u =>
      Complex.conj_im _
    have ha' : (γc' a).im < ((-j : ℤ) : ℝ) * Real.pi := by
      rw [hheight]
      push_cast
      linarith
    have hb' : ((-j : ℤ) : ℝ) * Real.pi < (γc' b).im := by
      rw [hheight]
      push_cast
      linarith
    obtain ⟨dc, hd1, hd2, hd3⟩ :=
      exists_flip_of_up_rung (conjLoop γ) γc' hliftc hfinc hab ha' hb'
    refine ⟨dc.ofConj, ?_, ?_, dc.ofConj_isFlip hd3⟩
    · rw [CrossingData.ofConj_t]; exact hd1
    · rw [CrossingData.ofConj_t]; exact hd2

/-- `0 < 1` in the parameter interval. -/
theorem unitInterval_zero_lt_one : (0 : unitInterval) < 1 := by
  rw [← Subtype.coe_lt_coe]
  norm_num

/-- **NONZERO WINDING FORCES AN INTERIOR FLIP** (Cor 5.13 at a nonempty
obstruction set, stem face, contrapositive direction): a closed
nonvanishing value-loop with finite obstruction set and `stemWinding ≠ 0`
carries an interior Def 5.2 FLIP. Route: the winding is the lift's height
shift over `2π` (`winding_height_shift`, Cor 5.21's stem accounting), a
nonzero shift passes some rung strictly (floor selection), and the flip
producer fires between the endpoints. The obstruction set is NONEMPTY here
— the loop meets ℝ because its lift meets a rung
(`lift_height_pi_iff`) — this is exactly the face of Cor 5.13 that
SigmaE3's empty-obstruction closure iff (`stemWinding_eq_zero_iff`) does
not see. PROVED. -/
theorem exists_interior_flip_of_stemWinding_ne_zero (γ : C(unitInterval, ℂ))
    (hγ : ∀ t, γ t ≠ 0) (hloop : γ 0 = γ 1)
    (hfin : (obstructionSet γ).Finite) (hw : stemWinding γ ≠ 0) :
    ∃ d : CrossingData γ, 0 < d.t ∧ d.t < 1 ∧ d.IsFlip := by
  obtain ⟨γ', hlift⟩ := exists_log_continuation γ hγ
  have hshift := winding_height_shift γ hγ hloop γ' hlift
  have hπ := Real.pi_pos
  rcases lt_or_gt_of_ne hw with hneg | hpos
  · -- descending: h 1 ≤ h 0 − 2π; the rung above h 1
    have hwle : (stemWinding γ : ℝ) ≤ -1 := by
      have : stemWinding γ ≤ -1 := by omega
      exact_mod_cast this
    set j : ℤ := ⌊(γ' 1).im / Real.pi⌋ + 1 with hj
    have hj1 : (γ' 1).im < (j : ℝ) * Real.pi := by
      have h1 := Int.lt_floor_add_one ((γ' 1).im / Real.pi)
      have h2 : (γ' 1).im / Real.pi * Real.pi
          < ((⌊(γ' 1).im / Real.pi⌋ : ℝ) + 1) * Real.pi :=
        mul_lt_mul_of_pos_right h1 hπ
      rw [div_mul_cancel₀ _ hπ.ne'] at h2
      rw [hj]
      push_cast
      linarith
    have hj0 : (j : ℝ) * Real.pi < (γ' 0).im := by
      have h1 := Int.floor_le ((γ' 1).im / Real.pi)
      have h2 : (⌊(γ' 1).im / Real.pi⌋ : ℝ) * Real.pi ≤ (γ' 1).im := by
        have := mul_le_mul_of_nonneg_right h1 hπ.le
        rwa [div_mul_cancel₀ _ hπ.ne'] at this
      have h3 : (γ' 1).im + 2 * Real.pi ≤ (γ' 0).im := by
        have h4 : (stemWinding γ : ℝ) * (2 * Real.pi) ≤ (-1) * (2 * Real.pi) :=
          mul_le_mul_of_nonneg_right hwle (by positivity)
        linarith
      rw [hj]
      push_cast
      linarith
    exact exists_flip_of_rung_between γ γ' hlift hfin unitInterval_zero_lt_one
      (Or.inr ⟨hj1, hj0⟩)
  · -- ascending: h 0 + 2π ≤ h 1; the rung above h 0
    have hwge : (1 : ℝ) ≤ (stemWinding γ : ℝ) := by
      have : (1 : ℤ) ≤ stemWinding γ := by omega
      exact_mod_cast this
    set j : ℤ := ⌊(γ' 0).im / Real.pi⌋ + 1 with hj
    have hj0 : (γ' 0).im < (j : ℝ) * Real.pi := by
      have h1 := Int.lt_floor_add_one ((γ' 0).im / Real.pi)
      have h2 : (γ' 0).im / Real.pi * Real.pi
          < ((⌊(γ' 0).im / Real.pi⌋ : ℝ) + 1) * Real.pi :=
        mul_lt_mul_of_pos_right h1 hπ
      rw [div_mul_cancel₀ _ hπ.ne'] at h2
      rw [hj]
      push_cast
      linarith
    have hj1 : (j : ℝ) * Real.pi < (γ' 1).im := by
      have h1 := Int.floor_le ((γ' 0).im / Real.pi)
      have h2 : (⌊(γ' 0).im / Real.pi⌋ : ℝ) * Real.pi ≤ (γ' 0).im := by
        have := mul_le_mul_of_nonneg_right h1 hπ.le
        rwa [div_mul_cancel₀ _ hπ.ne'] at this
      have h3 : (γ' 0).im + 2 * Real.pi ≤ (γ' 1).im := by
        have h4 : (1 : ℝ) * (2 * Real.pi) ≤ (stemWinding γ : ℝ) * (2 * Real.pi) :=
          mul_le_mul_of_nonneg_right hwge (by positivity)
        linarith
      rw [hj]
      push_cast
      linarith
    exact exists_flip_of_rung_between γ γ' hlift hfin unitInterval_zero_lt_one
      (Or.inl ⟨hj0, hj1⟩)

/-- No interior flips ⇒ the winding vanishes (contrapositive of the flip
producer). -/
theorem stemWinding_eq_zero_of_no_interior_flip (γ : C(unitInterval, ℂ))
    (hγ : ∀ t, γ t ≠ 0) (hloop : γ 0 = γ 1)
    (hfin : (obstructionSet γ).Finite)
    (hnf : ∀ d : CrossingData γ, 0 < d.t → d.t < 1 → ¬d.IsFlip) :
    stemWinding γ = 0 := by
  by_contra hw
  obtain ⟨d, h1, h2, h3⟩ :=
    exists_interior_flip_of_stemWinding_ne_zero γ hγ hloop hfin hw
  exact hnf d h1 h2 h3

/-- **COR 5.13'S NO-FLIP INSTANCE, END TO END ON THE STEM** (GPVwind
Cor 5.13, SOURCES/GPVwind.md, verbatim: "Then a lift of γ in 𝓔⁺_𝕂 exists
if and only if σ(γ|_{[ξ_l,ξ_{l+1}]}) ∈ {0,−1} for each l = 1,…,m−1. If it
exists, the lift is a loop." + Def 5.7's closing clause, verbatim: "If
there are no flips, then we define σ(γ) := 0."): a closed nonvanishing
stem loop with finite obstruction set and NO interior flips has σ = 0 on
every subinterval by Def 5.7's clause, the criterion's admissible set
`{0, −1}` is met, and indeed the lift exists AND CLOSES — derived here
with no citation load: no flips ⇒ winding 0 (the flip producer) ⇒ a closed
lift (`stemWinding_eq_zero_iff`, SigmaE3's closure face). The nonempty
obstruction set is welcome: bounces may abound. DERIVED (R10). -/
theorem closed_lift_of_no_interior_flip (γ : C(unitInterval, ℂ))
    (hγ : ∀ t, γ t ≠ 0) (hloop : γ 0 = γ 1)
    (hfin : (obstructionSet γ).Finite)
    (hnf : ∀ d : CrossingData γ, 0 < d.t → d.t < 1 → ¬d.IsFlip) :
    ∃ γ' : C(unitInterval, ℂ), (∀ t, Complex.exp (γ' t) = γ t) ∧ γ' 1 = γ' 0 :=
  (stemWinding_eq_zero_iff γ hγ hloop).mp
    (stemWinding_eq_zero_of_no_interior_flip γ hγ hloop hfin hnf)

/-! ## §D — THE LEVEL CONTACT: where GPV's flip data touches the levels -/

/-- **THE CONTACT ROW** (the register identification made literal at the
crossing): a domain path crossing the DOMAIN's real axis — where the
levels `Re (sphereZero ·)` live — sends the crossing parameter INTO the
value-loop's obstruction set (Def 5.1's `T = Γ⁻¹(ℝ)`), and the crossing
VALUE is `F(x)` at the real footpoint: `ASection.real_on_real`
(intrinsicality, `def:section-map` "A(ℝ) ⊆ ℝ"). GPV's flip machinery reads
one-sided data AT these parameters; which side of ℝ the domain leaves them
toward is the band datum. PROVED. -/
theorem ASection.domain_crossing_obstruction (A : ASection)
    (δ Γ : C(unitInterval, ℂ)) (hΓ : ∀ t, Γ t = A.F (δ t)) {t : unitInterval}
    (ht : (δ t).im = 0) :
    t ∈ obstructionSet Γ ∧ Γ t = A.F (((δ t).re : ℝ) : ℂ) := by
  have hδ : δ t = (((δ t).re : ℝ) : ℂ) := by
    apply Complex.ext
    · simp
    · simp [ht]
  constructor
  · show (Γ t).im = 0
    rw [hΓ t, hδ]
    exact A.real_on_real _
  · rw [hΓ t]
    exact congrArg A.F hδ

/-- The elementary factor is conjugation-equivariant (real coefficients). -/
theorem weierstrassE_conj (p : ℕ) (w : ℂ) :
    weierstrassE p (starRingEnd ℂ w) = starRingEnd ℂ (weierstrassE p w) := by
  unfold weierstrassE
  rw [map_mul, map_sub, map_one]
  congr 1
  rw [← Complex.exp_conj]
  congr 1
  rw [map_sum]
  refine Finset.sum_congr rfl fun k _ => ?_
  rw [map_div₀, map_pow, map_add, map_natCast, map_one]

/-- **At a real point every residue-ℂ sphere factor is a square modulus**:
`𝓔(x; q)·𝓔(x; q̄) = |𝓔(x; q)|²` — the conjugate stem pair of C3's primary
factor collapses to `normSq` on ℝ. -/
theorem spherePrimary_ofReal (p : ℕ) (a : ℂ) (x : ℝ) :
    spherePrimary p a (x : ℂ)
      = ((Complex.normSq (weierstrassE p ((x : ℂ) / a)) : ℝ) : ℂ) := by
  unfold spherePrimary
  have h1 : (x : ℂ) / starRingEnd ℂ a = starRingEnd ℂ ((x : ℂ) / a) := by
    rw [map_div₀, Complex.conj_ofReal]
  rw [h1, weierstrassE_conj, Complex.mul_conj]

/-- Sphere factors are real and nonnegative on ℝ. -/
theorem spherePrimary_ofReal_im (p : ℕ) (a : ℂ) (x : ℝ) :
    (spherePrimary p a (x : ℂ)).im = 0 := by
  rw [spherePrimary_ofReal]
  exact Complex.ofReal_im _

theorem spherePrimary_ofReal_nonneg (p : ℕ) (a : ℂ) (x : ℝ) :
    0 ≤ (spherePrimary p a (x : ℂ)).re := by
  rw [spherePrimary_ofReal, Complex.ofReal_re]
  exact Complex.normSq_nonneg _

/-- **THE LEVELS' CARRIERS ARE INVISIBLE TO CROSSING SIGNS**: at every real
point the sphere factor of a NON-REAL zero is strictly positive — the
residue-ℂ zero-spheres (the objects whose levels the theorem reads) never
change the sign of the stem along ℝ. Def 5.7's σ-inputs `sign(γ(ξ))` at
domain-real crossings cannot see them; the spheres enter the flip ledger
only through the winding of the arcs BETWEEN crossings (§C). PROVED. -/
theorem spherePrimary_ofReal_pos (p : ℕ) {a : ℂ} (ha : a.im ≠ 0) (x : ℝ) :
    0 < (spherePrimary p a (x : ℂ)).re := by
  rw [spherePrimary_ofReal, Complex.ofReal_re]
  refine Complex.normSq_pos.mpr fun h => ?_
  have ha0 : a ≠ 0 := fun h' => ha (by rw [h']; simp)
  have hxa : (x : ℂ) = a :=
    (div_eq_one_iff_eq ha0).mp ((weierstrassE_eq_zero_iff p _).mp h)
  apply ha
  rw [← hxa]
  simp

/-- Products of real-nonnegative complexes stay real-nonnegative. -/
theorem re_mul_of_im_eq_zero {z w : ℂ} (hz : z.im = 0) (hw : w.im = 0) :
    (z * w).re = z.re * w.re ∧ (z * w).im = 0 := by
  constructor <;> simp [Complex.mul_re, Complex.mul_im, hz, hw]

/-- **The full C3 sphere tail is real and nonnegative on ℝ**: the infinite
product over the residue-ℂ divisor converges inside the closed set
`{im = 0, 0 ≤ re}` (each factor there by `spherePrimary_ofReal_nonneg`;
finite products stay there; `c3_multipliable` carries the limit in).
PROVED. -/
theorem ASection.sphereTail_real_nonneg (A : ASection) (x : ℝ) :
    (∏' n, spherePrimary (A.genus n) (A.sphereZero n) (x : ℂ)).im = 0 ∧
      0 ≤ (∏' n, spherePrimary (A.genus n) (A.sphereZero n) (x : ℂ)).re := by
  have hK : IsClosed {z : ℂ | z.im = 0 ∧ 0 ≤ z.re} := by
    have h1 : IsClosed {z : ℂ | z.im = 0} :=
      isClosed_eq Complex.continuous_im continuous_const
    have h2 : IsClosed {z : ℂ | 0 ≤ z.re} :=
      isClosed_le continuous_const Complex.continuous_re
    exact h1.inter h2
  have hfor : ∀ s : Finset ℕ,
      (∏ n ∈ s, spherePrimary (A.genus n) (A.sphereZero n) (x : ℂ))
        ∈ {z : ℂ | z.im = 0 ∧ 0 ≤ z.re} := by
    intro s
    refine Finset.prod_induction _ (· ∈ {z : ℂ | z.im = 0 ∧ 0 ≤ z.re})
      (fun a b ha hb => ?_) (by simp) fun n _ =>
        ⟨spherePrimary_ofReal_im _ _ x, spherePrimary_ofReal_nonneg _ _ x⟩
    obtain ⟨hmul, himul⟩ := re_mul_of_im_eq_zero ha.1 hb.1
    exact ⟨himul, by rw [hmul]; exact mul_nonneg ha.2 hb.2⟩
  have hmem := hK.mem_of_tendsto (A.c3_multipliable (x : ℂ)).hasProd
    (Filter.Eventually.of_forall hfor)
  exact hmem

/-- The entire factor `e^g` is real and strictly positive on ℝ (g is
intrinsic, `c3_g_intrinsic`). -/
theorem ASection.exp_gfac_real_pos (A : ASection) (x : ℝ) :
    (Complex.exp (A.gfac (x : ℂ))).im = 0 ∧
      0 < (Complex.exp (A.gfac (x : ℂ))).re := by
  have hg : (A.gfac (x : ℂ)).im = 0 := StemRing.real_on_real A.c3_g_intrinsic x
  constructor
  · rw [Complex.exp_im, hg, Real.sin_zero, mul_zero]
  · rw [Complex.exp_re, hg, Real.cos_zero, mul_one]
    exact Real.exp_pos _

/-- The crossing value is real together with its pole gauge. -/
theorem ASection.crossing_value_real (A : ASection) (x : ℝ) :
    (((x : ℂ) - (A.pole : ℂ)) * A.F (x : ℂ)).im = 0 := by
  have h1 : ((x : ℂ) - (A.pole : ℂ)).im = 0 := by simp
  exact (re_mul_of_im_eq_zero h1 (A.real_on_real x)).2

/-- **CROSSING-SIGN RIGIDITY — the arrangement row** ("the sign of F
between real zeros / the position of the crossing relative to the divisor
enters the flip data"): at a real footpoint `x` (≠ pole, value ≠ 0) the
sign of the gauged crossing value `(x − p₀)·F(x)` EQUALS the sign of the
REAL-DIVISOR part `x^m·R(x)` — the exponential factor is positive
(`exp_gfac_real_pos`), the sphere tail is positive there
(`sphereTail_real_nonneg` + ≠ 0 forced by `F(x) ≠ 0` through
`c3_factorization`). Def 5.7's σ-inputs at domain-real crossings are
therefore computed by the REAL divisor and the pole alone: the levels'
carriers are sign-invisible (`spherePrimary_ofReal_pos`). Stated as
positivity of the product of the two signed quantities. PROVED. -/
theorem ASection.crossing_sign_rigid (A : ASection) (x : ℝ)
    (hx : (x : ℂ) ≠ (A.pole : ℂ)) (hF : A.F (x : ℂ) ≠ 0) :
    0 < (((x : ℂ) - (A.pole : ℂ)) * A.F (x : ℂ)).re
      * ((x : ℂ) ^ A.m * A.Rfac (x : ℂ)).re := by
  have hfac := A.c3_factorization (x : ℂ) hx
  -- reality of the factors
  have hQim : ((x : ℂ) ^ A.m * A.Rfac (x : ℂ)).im = 0 :=
    (re_mul_of_im_eq_zero (by rw [← Complex.ofReal_pow]; exact Complex.ofReal_im _)
      (StemRing.real_on_real A.c3_R_intrinsic x)).2
  obtain ⟨hEim, hEpos⟩ := A.exp_gfac_real_pos x
  obtain ⟨hTim, hTnn⟩ := A.sphereTail_real_nonneg x
  -- the chained real product
  have hQE := re_mul_of_im_eq_zero hQim hEim
  have hQET := re_mul_of_im_eq_zero hQE.2 hTim
  have hchain : (((x : ℂ) - (A.pole : ℂ)) * A.F (x : ℂ)).re
      = ((x : ℂ) ^ A.m * A.Rfac (x : ℂ)).re
        * (Complex.exp (A.gfac (x : ℂ))).re
        * (∏' n, spherePrimary (A.genus n) (A.sphereZero n) (x : ℂ)).re := by
    rw [hfac, hQET.1, hQE.1]
  -- nonvanishing of the crossing value
  have hPne : ((x : ℂ) - (A.pole : ℂ)) * A.F (x : ℂ) ≠ 0 :=
    mul_ne_zero (sub_ne_zero.mpr hx) hF
  have hPre : (((x : ℂ) - (A.pole : ℂ)) * A.F (x : ℂ)).re ≠ 0 := by
    intro h
    exact hPne (by
      apply Complex.ext
      · rw [h]; simp
      · rw [A.crossing_value_real x]; simp)
  -- the tail and the real-divisor part are forced nonzero
  have hQne : ((x : ℂ) ^ A.m * A.Rfac (x : ℂ)).re ≠ 0 := by
    intro h
    apply hPre
    rw [hchain, h, zero_mul, zero_mul]
  have hTne : (∏' n, spherePrimary (A.genus n) (A.sphereZero n) (x : ℂ)).re ≠ 0 := by
    intro h
    apply hPre
    rw [hchain, h, mul_zero]
  have hTpos : 0 < (∏' n, spherePrimary (A.genus n) (A.sphereZero n) (x : ℂ)).re :=
    lt_of_le_of_ne hTnn (Ne.symm hTne)
  rw [hchain]
  nlinarith [mul_self_pos.mpr hQne, mul_pos hEpos hTpos]

/-- **Def 5.7's σ-inputs are CONSTANT between consecutive real-divisor
points**: on a real interval avoiding the pole and the stem's zeros, the
crossing sign is one sign (IVT on the real-valued restriction — the stem is
real on ℝ by intrinsicality). The flip data of any domain loop crossing ℝ
twice in the same divisor-free gap carries EQUAL crossing signs — the
positional information "between which divisor points did the loop cross"
is the ONLY sign information the crossing carries. PROVED. -/
theorem ASection.crossing_sign_const_between (A : ASection) {x₁ x₂ : ℝ}
    (hpole : ∀ y ∈ Set.Icc x₁ x₂, y ≠ A.pole)
    (hne : ∀ y ∈ Set.Icc x₁ x₂, A.F (y : ℂ) ≠ 0)
    {y₁ y₂ : ℝ} (h₁ : y₁ ∈ Set.Icc x₁ x₂) (h₂ : y₂ ∈ Set.Icc x₁ x₂) :
    0 < (A.F (y₁ : ℂ)).re * (A.F (y₂ : ℂ)).re := by
  set g : ℝ → ℝ := fun y => (A.F (y : ℂ)).re with hg
  have hgcont : ContinuousOn g (Set.Icc x₁ x₂) := by
    intro y hy
    have hyp : (y : ℂ) ≠ (A.pole : ℂ) := fun h =>
      hpole y hy (Complex.ofReal_inj.mp h)
    have h1 : ContinuousAt A.F ((y : ℝ) : ℂ) := (A.c1_analyticAt _ hyp).continuousAt
    exact (Complex.continuous_re.continuousAt.comp
      (h1.comp Complex.continuous_ofReal.continuousAt)).continuousWithinAt
  have hgne : ∀ y ∈ Set.Icc x₁ x₂, g y ≠ 0 := by
    intro y hy h0
    refine hne y hy ?_
    apply Complex.ext
    · show (A.F ((y : ℝ) : ℂ)).re = (0 : ℂ).re
      rw [Complex.zero_re]
      exact h0
    · rw [A.real_on_real y]
      simp
  by_contra hcon
  rw [not_lt] at hcon
  have hlt : g y₁ * g y₂ < 0 :=
    lt_of_le_of_ne hcon (mul_ne_zero (hgne y₁ h₁) (hgne y₂ h₂))
  have hsub : Set.uIcc y₁ y₂ ⊆ Set.Icc x₁ x₂ :=
    (Set.ordConnected_Icc).uIcc_subset h₁ h₂
  have h0mem : (0 : ℝ) ∈ Set.uIcc (g y₁) (g y₂) := by
    rcases mul_neg_iff.mp hlt with ⟨ha, hb⟩ | ⟨ha, hb⟩
    · exact Set.mem_uIcc.mpr (Or.inr ⟨hb.le, ha.le⟩)
    · exact Set.mem_uIcc.mpr (Or.inl ⟨ha.le, hb.le⟩)
  obtain ⟨y, hy, hy0⟩ := intermediate_value_uIcc (hgcont.mono hsub) h0mem
  exact hgne y (hsub hy) hy0

/-- **THE DIVISOR PRODUCES FLIPS — the assembly row of the contact**: a
rectangle trapping at least one enumerated zero (W2(d)'s counting weld:
value-winding = trapped count ≥ 1) forces an interior Def 5.2 FLIP on the
section's value-loop, PROVIDED the value-loop's obstruction set is finite.
The nonvanishing and closedness of the value-loop are not hypotheses —
they are FORCED by the nonzero counting (the winding's junk value is 0).
This is GPV pushed onto the divisor: the zero inside makes the value-loop
wind, the winding shifts the lift across a rung, and the shift is
impossible without a transversal crossing of ℝ by the VALUE — the "flip
line" of the stem through the zero. Def 5.1's obstruction set is genuinely
NONEMPTY here. PROVED (modulo its stated finiteness hypothesis — see the
receipt's residual (α)). -/
theorem ASection.rect_value_flip (A : ASection) {x₁ x₂ y₁ y₂ : ℝ}
    (hx : x₁ < x₂) (hy : y₁ < y₂) (hy₁ : 0 < y₁)
    (hframe : ∀ k, A.sphereZero k ∈ closedRect x₁ x₂ y₁ y₂ →
      A.sphereZero k ∈ openRect x₁ x₂ y₁ y₂)
    {s : Finset ℕ} (hs : ∀ k, k ∈ s ↔ A.sphereZero k ∈ openRect x₁ x₂ y₁ y₂)
    (hcard : s.Nonempty)
    (Γ : C(unitInterval, ℂ)) (hΓ : ∀ t, Γ t = A.F (rectLoop x₁ x₂ y₁ y₂ t))
    (hfin : (obstructionSet Γ).Finite) :
    ∃ d : CrossingData Γ, 0 < d.t ∧ d.t < 1 ∧ d.IsFlip := by
  have hw := A.stemWinding_F_rectLoop hx hy hy₁ hframe hs Γ hΓ
  have hcpos : 0 < s.card := Finset.card_pos.mpr hcard
  -- the nonzero counting forces the loop hypotheses
  have hcond : (∀ t, Γ t ≠ 0) ∧ Γ 0 = Γ 1 := by
    by_contra hc
    have h0 : stemWinding Γ = 0 := by
      unfold stemWinding
      rw [dif_neg hc]
    rw [hw] at h0
    have : s.card = 0 := by exact_mod_cast h0
    omega
  refine exists_interior_flip_of_stemWinding_ne_zero Γ hcond.1 hcond.2 hfin ?_
  rw [hw]
  exact_mod_cast hcpos.ne'

/-! ## §E — the drive and the receipt -/

namespace ASection

/- [receipt docstring, detached per the no-new-sorries fence] **THE DRIVE (the flip buildout assembled at the target)**. Statement =
the theorem's target (`ASection.concentricity`, Theorem.lean — the
repository's one open node). Every possession fed below is PROVED:

(0) the supposition names two enumerated zeros at distinct levels;
(1) W2(d)'s counting pair (`counting_pair_of_two_levels`, WeldW12): a
    vertical line `Re = β` strictly between the levels, admissible
    rectangles strictly left and right, each value-loop winding EXACTLY
    its own trapped count ≥ 1;
(2) the loop hypotheses for both value-loops are FORCED by the nonzero
    counting (the junk-value dodge inside `rect_value_flip`);
(3) THE NEW CLAUSE (this file): each side's value-loop, IF its obstruction
    set is finite, carries an interior Def 5.2 FLIP
    (`exists_interior_flip_of_stemWinding_ne_zero` ←
    `exists_flip_of_rung_between`, the csInf flip producer), and with NO
    interior flips the lift would close (`closed_lift_of_no_interior_flip`
    — Cor 5.13's no-flip instance, derived end-to-end);
(4) the σ ledger (§B + SigmaE3): `stemSignature_int_parity` (σ integer,
    `|σ| ≤ m`, parity = flip parity), `stemSignature_mem_of_pos` (the
    {0,−1} auto-pass at positive crossings), the chaining rows
    (`bounce_conserves_band` / `flip_steps_band`), `arc_one_band`;
(5) THE LEVEL CONTACT (§D): domain-real crossings land in the value
    obstruction set with value `F(x)` (`domain_crossing_obstruction` —
    `real_on_real`, the one intrinsicality row); crossing signs are rigid
    — the REAL divisor and the pole alone set them
    (`crossing_sign_rigid`, `crossing_sign_const_between`), the sphere
    divisor being sign-invisible on ℝ (`spherePrimary_ofReal_pos`,
    `sphereTail_real_nonneg`).

RECEIPT (R6, 2026-07-07): goal at the stop
  ⊢ False
and RESISTS. `exact?` at the seam: could not close the goal. THE TWO
PRECISE MISSING PRODUCERS, one sentence each:

(α) NO FED ROW BOUNDS THE VALUE OBSTRUCTION SETS — Def 5.1's
`T = Γ⁻¹(ℝ)` along a contour can a priori be infinite, and GPV's OWN
treatment of that case is not the point-tameness of Def 5.2 but the
companion-relative interval machinery (Def 5.15's induced subdivision —
finitely many big arcs by compactness, bridge prose S5.p21: "Since
γ([a,b]) is compact, there are only finitely many connected components of
γ([a,b])∖ℝ with endpoints of opposite sign" — Def 5.16's interval signs,
Def 5.17's interval flips, Def 5.19's σ(γ,𝔍)); transcribing THAT layer —
big arcs in place of isolated crossings — is the remaining untranscribed
part of GPV's life on 𝓑, and this file's isolated-crossing rows are its
Def 5.2 face (Rem 5.18: "If the interval [e_l, s_{l+1}] reduces to a
point, then the definition of tameness for intervals coincides with the
definition of tameness for points.").

(β) EVEN GRANTED (α), EVERY FLIP POSSESSION IS PER-CONTOUR — each
rectangle's flip ledger (its crossing parameters, signs, σ) is determined
by its OWN trapped divisor, and no fed statement relates the LEFT
rectangle's ledger to the RIGHT one's; the cross-contour constraint is
`eq:placement-set` ≡ ∃β two-sided (`auditE1_target_iff_two_sided`), the
same seam as E3's receipt, W12's verdict of record, and E1's audit.

[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
its rectangles trap their own zeros, their value-loops wind and flip, its
crossing signs are rigid against ITS real divisor, all ledgers balance
per contour — so no assembly of these possessions alone can close `False`;
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
fails. The `sorry` is the ROUTE RECEIPT (unimported artifact; R8), not a
queue item. -/
/- RECEIPT (prose only, per the author's fence 2026-07-07: no new sorried
declarations — the route account stands in the docstring above; the
attempted assembly is preserved as a comment for the record):
theorem concentricity_via_flipWeld (A : ASection) :
    ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c := by
  by_contra hno
  -- (0) two enumerated zeros at distinct levels
  have hpair : ∃ k : ℕ, (A.sphereZero k).re ≠ (A.sphereZero 0).re := by
    by_contra hall
    refine hno ⟨(A.sphereZero 0).re, fun k => ?_⟩
    by_contra hk
    exact hall ⟨k, hk⟩
  obtain ⟨k, hk⟩ := hpair
  obtain ⟨a, b, hab⟩ : ∃ a b : ℕ, (A.sphereZero a).re < (A.sphereZero b).re := by
    rcases lt_or_gt_of_ne hk with h | h
    · exact ⟨k, 0, h⟩
    · exact ⟨0, k, h⟩
  -- (1) the counting pair: line, rectangles, exact counts ≥ 1 (PROVED, W12)
  obtain ⟨β, hβa, hβb, xn₁, xn₂, yn₁, yn₂, xm₁, xm₂, ym₁, ym₂,
    hxn₂β, hβxm₁, hyn₁, hym₁, hmemn, hmemm, sn, sm, hsn, hsm, hsn1, hsm1,
    Γn, Γm, hΓn, hΓm, hwn, hwm⟩ := A.counting_pair_of_two_levels hab
  -- (2) the loop hypotheses are FORCED by the nonzero counting
  have hcondn : (∀ t, Γn t ≠ 0) ∧ Γn 0 = Γn 1 := by
    by_contra hc
    have h0 : stemWinding Γn = 0 := by
      unfold stemWinding
      rw [dif_neg hc]
    rw [hwn] at h0
    have : sn.card = 0 := by exact_mod_cast h0
    omega
  have hcondm : (∀ t, Γm t ≠ 0) ∧ Γm 0 = Γm 1 := by
    by_contra hc
    have h0 : stemWinding Γm = 0 := by
      unfold stemWinding
      rw [dif_neg hc]
    rw [hwm] at h0
    have : sm.card = 0 := by exact_mod_cast h0
    omega
  -- (3) THE NEW CLAUSE: finite obstruction sets would force interior flips
  --     on BOTH value-loops; no interior flips would CLOSE the lifts
  have hflipn : (obstructionSet Γn).Finite →
      ∃ d : CrossingData Γn, 0 < d.t ∧ d.t < 1 ∧ d.IsFlip := fun hfin =>
    exists_interior_flip_of_stemWinding_ne_zero Γn hcondn.1 hcondn.2 hfin
      (by rw [hwn]; exact_mod_cast (show sn.card ≠ 0 by omega))
  have hflipm : (obstructionSet Γm).Finite →
      ∃ d : CrossingData Γm, 0 < d.t ∧ d.t < 1 ∧ d.IsFlip := fun hfin =>
    exists_interior_flip_of_stemWinding_ne_zero Γm hcondm.1 hcondm.2 hfin
      (by rw [hwm]; exact_mod_cast (show sm.card ≠ 0 by omega))
  have hclosen := @closed_lift_of_no_interior_flip
  -- (4) the σ ledger: parity skeleton, {0,−1} auto-pass, chaining, arcs
  have hparity := @stemSignature_int_parity
  have hautopass := @stemSignature_mem_of_pos
  have hbounce := @CrossingData.bounce_conserves_band
  have hflipstep := @CrossingData.flip_steps_band
  have harcs := @arc_one_band
  -- (5) THE LEVEL CONTACT: domain crossings, rigid signs, invisible spheres
  have hcontact := @ASection.domain_crossing_obstruction
  have hrigid := @ASection.crossing_sign_rigid
  have hconst := @ASection.crossing_sign_const_between
  have hinvisible := @spherePrimary_ofReal_pos
  have htail := @ASection.sphereTail_real_nonneg
  -- RECEIPT
  sorry

-/

end ASection
