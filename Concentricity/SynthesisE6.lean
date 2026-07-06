/-
Concentricity/SynthesisE6.lean

E6 — THE SYNTHESIS (unimported working artifact; KeystoneAssembly /
GreatCircleRoute / LoopAssembly / PhiConversion / AuditE1 / PairingE2 /
SigmaE3 / KernelE4 / SweepE5 precedent; the imported root ledger — 1 sorry,
0 axioms, the theorem `ASection.concentricity` the only leaf — is
untouched). The five engines' artifacts are here CONSUMED, not narrated
(the author's directive, 2026-07-06: "don't wait for the winding
definition to not be used and just narrate about it … make sure to use the
articulation to prove concentricity or fill in the gap … the zero spheres
are what it is transporting through the winding definition … make sure Φ
is about the A-section specifically and not a general base"): this file
imports E4's minimal-node reduction (KernelE4), E3's winding engine
(SigmaE3), the Φ-conversion rows (PhiConversion), E5's register-wedge rows
(SweepE5), and through them the loop assembly (LoopAssembly: the
articulation, the cone, the shared ladder) and the kernel ladder
(LiKernel: D0–D3 + mirror + D2's iff) — and composes them into rows none
of the single engines proved, plus ONE drive at the theorem's statement.

WHAT IS PROVED HERE (all rows on the kernel triple; helpers never sorried,
R8):

ROW A `exists_zero_level_above` — E4's top level read as a pair supplier:
  a zero strictly below the top level has a second zero strictly above it
  (`exists_lt_of_lt_csSup` on E4's `levelSet`).
ROW B `negation_winding_configuration` — E4 × E3, the negation cashed in
  FULL: ¬(one centre) yields two enumerated zeros at distinct levels, a
  vertical line Re = β strictly between them, circle contours strictly
  left and right, value-windings ≥ 1 on BOTH sides, and BOTH side loops
  OBSTRUCTED (no closed lift — GPVwind Cor 5.13's criterion fails on each
  side of the line, stem-honest closure form `stemWinding_eq_zero_iff`).
ROW C `zero_pole_pair_winding` — THE ASSEMBLED PAIR through the witness:
  the pointwise product of the value-loop around an enumerated zero-sphere
  with the value-loop around C1's pole winds exactly (fiber tally) − 1
  (`stemWinding_mul`: lifts add along exp — the integration-free
  argument-principle engine; the zero-sphere's transport datum MEETS the
  witness 𝔫's −1).
ROW C' `zero_pole_pair_closes_through_witness` — at fiber tally 1 the
  assembled pair CLOSES: each factor loop is obstructed alone, the
  zero–witness product admits a closed lift (the author's sentence "the
  zero spheres are what it is transporting through the winding definition"
  rendered as a theorem: the zero's +1 annihilates against the cone's −1;
  one loop, closed through the witness N).
ROW D `phi_shared_ladder_glue` — THE ROUND TRIP, OUTBOUND LEG, Φ ON THE
  A-SECTION SPECIFICALLY (`sectionFunctor A`, never a bare base): at the
  shared-ladder encounters (one value −r for BOTH zeros' neighbourhoods,
  LoopAssembly §C) the octonionic realizations of the two encounters are
  carried by Φ into ONE component of 𝒮₂ — 𝕆* → slice Riemann spheres,
  glued, with the conserved read the encounter's own value modulus.
ROW E `phi_encounter_read_not_unique` — the wedge INSIDE the Φ register
  (E5 × Φ, new): near ONE zero-sphere two encounters at distinct values
  −r₁ ≠ −r₂ have Φ-images in DIFFERENT components of 𝒮₂ (moduli r₁² ≠ r₂²,
  `S2.zigzag_modulus`) — Φ's encounter carriage assigns NO canonical
  𝒮₂-component (hence no level) to a single zero-sphere; the recorded
  failure mode of every prior route, now a theorem in Φ's own vocabulary.
ROW F `articulation_fibre_applied` — the articulation APPLIED, not cited:
  clause (iii) of `concentric_articulation` (the fibre is concentric)
  consumed AT the shared-ladder encounters — every pair of logarithms of
  the two zeros' shared encounter value carries ONE level, log r, exactly
  (`exp_fibre_level`; heights band data only).

THE DRIVE `concentricity_synthesis` — statement = the theorem
(`ASection.concentricity`, Theorem.lean:237, the repository's one open
node), with the FULLEST board ever fed: rows A–F above + the pole −1 +
the cone ε–δ + the articulation's three clauses + the Φ-collapse
(properness included) + the level tape + D2's iff + E4's edge families.
ONE receipt `sorry` at the exact resisting goal ⊢ False; the receipt
docstring carries the record, the `exact?` verdict, and the missing piece
in the author's round-trip vocabulary.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.KernelE4
import Concentricity.SigmaE3
import Concentricity.PhiConversion
import Concentricity.SweepE5

noncomputable section

open CategoryTheory

/-- Local sphere witness (PhiConversion's is `private`; the identical row
`Octonion.unitImaginarySphere_nonempty` lives in ZeroSpheres.lean atop the
ζ tower, unimported here). PROVED helper. -/
private theorem unitSphereE6_nonempty : Octonion.unitImaginarySphere.Nonempty := by
  refine ⟨((0 : Quaternion ℝ), (1 : Quaternion ℝ)), ?_, ?_⟩
  · rfl
  · simp [Octonion.normSq]

/-- A point within `ε` of a stem point whose imaginary part exceeds `ε`
stays in the open upper half-plane (`Complex.abs_im_le_norm`,
Mathlib/Analysis/RCLike/Basic.lean:694). PROVED helper. -/
private theorem im_pos_of_close {z ρ : ℂ} {ε : ℝ} (hd : dist z ρ < ε)
    (hε : ε < ρ.im) : 0 < z.im := by
  have h1 : |(z - ρ).im| ≤ ‖z - ρ‖ := Complex.abs_im_le_norm _
  rw [Complex.sub_im, ← dist_eq_norm] at h1
  have h2 := abs_le.mp h1
  linarith [h2.1]

/-- The slice coordinate of an embedded upper-half point is the point
itself — the ε-encounter form of `ASection.sliceCoord_sphere_pt`
(PhiConversion.lean), off the enumerated divisor. PROVED helper. -/
private theorem sliceCoord_embed_of_im_pos {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) {z : ℂ} (hz : 0 < z.im) :
    Octonion.sliceCoord (Octonion.sliceEmbed v z) = z := by
  rw [Octonion.sliceCoord_sliceEmbed hv]
  exact Complex.ext rfl (abs_of_pos hz)

/-- The embedding of a non-real point is non-real — the ε-encounter form
of `ASection.im_sphere_pt_ne_zero` (PhiConversion.lean). PROVED helper. -/
private theorem im_embed_ne_zero {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) {z : ℂ} (hz : z.im ≠ 0) :
    Octonion.im (Octonion.sliceEmbed v z) ≠ 0 := by
  rw [Octonion.im_sliceEmbed hv]
  intro h0
  have h1 := congrArg Octonion.normSq h0
  rw [Octonion.normSq_smul, hv.2, mul_one, Octonion.normSq_zero] at h1
  exact pow_ne_zero 2 hz h1

namespace ASection

/-- **ROW A — the pair supplier at the top level** (E4's `supLevel` stock
consumed): a zero strictly below the top level admits a second enumerated
zero strictly above its own level — `exists_lt_of_lt_csSup`
(Mathlib/Order/ConditionallyCompleteLattice/Basic.lean:404) on E4's
`levelSet`. With `concentricity_iff_supLevel_le` (KernelE4, PROVED) this
turns the theorem's NEGATION into the two-zero configuration E3's
separation row consumes. PROVED. -/
theorem exists_zero_level_above (A : ASection) {k : ℕ}
    (hk : (A.sphereZero k).re < A.supLevel) :
    ∃ m : ℕ, (A.sphereZero k).re < (A.sphereZero m).re := by
  have hk' : (A.sphereZero k).re < sSup A.levelSet := hk
  obtain ⟨x, hx_mem, hx⟩ := exists_lt_of_lt_csSup A.levelSet_nonempty hk'
  obtain ⟨m, hm⟩ := hx_mem
  refine ⟨m, ?_⟩
  have hmx : (A.sphereZero m).re = x := hm
  linarith

/-- **ROW B — the negation cashed in full (E4 × E3, new)**: if the
zero-spheres are NOT concentric, then two enumerated zeros sit at distinct
levels, a vertical line `Re = β` runs strictly between them, circle
contours stay strictly left resp. right of the line, the value-loops of
the section wind ≥ 1 around 0 on BOTH sides, and BOTH side loops are
OBSTRUCTED — no closed lift exists on either side (GPVwind Cor 5.13's
criterion fails on each side of the line; stem-honest closure form
`stemWinding_eq_zero_iff`, SigmaE3 §A). Route: the E4 minimal node
(`concentricity_iff_supLevel_le`) + ROW A + `sigma_level_separation`
(SigmaE3 §B ← the C3 peel `stem_local_form` + `stemWinding_mul`). PROVED.

LITMUS note (R10, GLOSS): this row holds for ANY section with a two-level
divisor — it is the configuration the missing inference must kill, not a
closure. -/
theorem negation_winding_configuration (A : ASection)
    (hno : ¬ ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c) :
    ∃ n m : ℕ, (A.sphereZero n).re < (A.sphereZero m).re ∧
      ∃ β : ℝ, (A.sphereZero n).re < β ∧ β < (A.sphereZero m).re ∧
      ∃ ε > 0,
        (∀ t, (circleLoop (A.sphereZero n) ε t).re < β) ∧
        (∀ t, β < (circleLoop (A.sphereZero m) ε t).re) ∧
        ∃ Γn Γm : C(unitInterval, ℂ),
          (∀ t, Γn t = A.F (circleLoop (A.sphereZero n) ε t)) ∧
          (∀ t, Γm t = A.F (circleLoop (A.sphereZero m) ε t)) ∧
          (∀ t, Γn t ≠ 0) ∧ (∀ t, Γm t ≠ 0) ∧
          1 ≤ stemWinding Γn ∧ 1 ≤ stemWinding Γm ∧
          ¬ (∃ Γ' : C(unitInterval, ℂ),
              (∀ t, Complex.exp (Γ' t) = Γn t) ∧ Γ' 1 = Γ' 0) ∧
          ¬ (∃ Γ' : C(unitInterval, ℂ),
              (∀ t, Complex.exp (Γ' t) = Γm t) ∧ Γ' 1 = Γ' 0) := by
  have hnot : ¬ ∀ k : ℕ, A.supLevel ≤ (A.sphereZero k).re :=
    fun h => hno ((A.concentricity_iff_supLevel_le).mpr h)
  push Not at hnot
  obtain ⟨k, hk⟩ := hnot
  obtain ⟨m, hkm⟩ := A.exists_zero_level_above hk
  obtain ⟨β, hβ₁, hβ₂, ε, hε, hL, hR, Γn, Γm, hΓn, hΓm, hΓnne, hΓmne, hwn, hwm⟩ :=
    A.sigma_level_separation hkm
  have hΓnloop : Γn 0 = Γn 1 := by rw [hΓn 0, hΓn 1, circleLoop_closed]
  have hΓmloop : Γm 0 = Γm 1 := by rw [hΓm 0, hΓm 1, circleLoop_closed]
  refine ⟨k, m, hkm, β, hβ₁, hβ₂, ε, hε, hL, hR, Γn, Γm, hΓn, hΓm, hΓnne, hΓmne,
    hwn, hwm, ?_, ?_⟩
  · intro hclosed
    have h0 := (stemWinding_eq_zero_iff Γn hΓnne hΓnloop).mpr hclosed
    omega
  · intro hclosed
    have h0 := (stemWinding_eq_zero_iff Γm hΓmne hΓmloop).mpr hclosed
    omega

/-- **ROW C — the assembled zero–witness pair (new)**: the pointwise
product of the value-loop around the n-th zero-sphere with the value-loop
around C1's pole winds exactly (fiber tally) − 1. The zero-sphere's
transport datum (its winding, +tally — `stemWinding_circle_sphereZero`,
the C3 peel) MEETS the witness 𝔫's datum (−1, `stemWinding_circle_pole` ←
`c1_simple`) under the σ-engine's additivity (`stemWinding_mul`: lifts add
along exp). This is the author's assembly sentence in the stem register:
the A-section transports the zero-spheres through the winding definition
to the degenerate fibre through the witness N. PROVED. -/
theorem zero_pole_pair_winding (A : ASection) (n : ℕ) :
    ∃ εz > 0, ∃ εp > 0, ∀ ε₁ : ℝ, 0 < ε₁ → ε₁ ≤ εz → ∀ ε₂ : ℝ, 0 < ε₂ → ε₂ ≤ εp →
      ∃ Γz Γp : C(unitInterval, ℂ),
        (∀ t, Γz t = A.F (circleLoop (A.sphereZero n) ε₁ t)) ∧
        (∀ t, Γp t = A.F (circleLoop (A.pole : ℂ) ε₂ t)) ∧
        (∀ t, (Γz * Γp) t ≠ 0) ∧ (Γz * Γp) 0 = (Γz * Γp) 1 ∧
        stemWinding (Γz * Γp)
          = (Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n} : ℤ) - 1 := by
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

/-- **ROW C' — the pair CLOSES through the witness (new)**: at fiber tally
1, each factor loop is obstructed ALONE (the zero circle winds +1, the
pole circle −1 — no closed lift on either, Cor 5.13's criterion failing
at each), yet the ASSEMBLED zero–witness product admits a CLOSED lift
(winding 1 − 1 = 0; `stemWinding_eq_zero_iff` forward). The author's
sentence as a theorem: the loop assembly closes the zero-sphere's
transport exactly THROUGH the cone at N — neither piece closes without
the other; the A-section as a whole (C1's pole + C3's divisor jointly)
supplies the closure. PROVED. -/
theorem zero_pole_pair_closes_through_witness (A : ASection) (n : ℕ)
    (htally : Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n} = 1) :
    ∃ εz > 0, ∃ εp > 0, ∀ ε₁ : ℝ, 0 < ε₁ → ε₁ ≤ εz → ∀ ε₂ : ℝ, 0 < ε₂ → ε₂ ≤ εp →
      ∃ Γz Γp : C(unitInterval, ℂ),
        (∀ t, Γz t = A.F (circleLoop (A.sphereZero n) ε₁ t)) ∧
        (∀ t, Γp t = A.F (circleLoop (A.pole : ℂ) ε₂ t)) ∧
        ¬ (∃ Γ' : C(unitInterval, ℂ),
            (∀ t, Complex.exp (Γ' t) = Γz t) ∧ Γ' 1 = Γ' 0) ∧
        ¬ (∃ Γ' : C(unitInterval, ℂ),
            (∀ t, Complex.exp (Γ' t) = Γp t) ∧ Γ' 1 = Γ' 0) ∧
        ∃ Γ' : C(unitInterval, ℂ),
          (∀ t, Complex.exp (Γ' t) = (Γz * Γp) t) ∧ Γ' 1 = Γ' 0 := by
  obtain ⟨εz, hεz, hεzim, hz⟩ := A.stemWinding_circle_sphereZero n
  obtain ⟨εp, hεp, hp⟩ := A.stemWinding_circle_pole
  refine ⟨εz, hεz, εp, hεp, fun ε₁ h₁ h₁' ε₂ h₂ h₂' => ?_⟩
  obtain ⟨Γz, hΓzval, hΓzne, hΓzloop, hΓzwind⟩ := hz ε₁ h₁ h₁'
  obtain ⟨Γp, hΓpval, hΓpne, hΓploop, hΓpwind⟩ := hp ε₂ h₂ h₂'
  rw [htally] at hΓzwind
  have hprod_ne : ∀ t, (Γz * Γp) t ≠ 0 := fun t => by
    rw [ContinuousMap.mul_apply]
    exact mul_ne_zero (hΓzne t) (hΓpne t)
  have hprod_loop : (Γz * Γp) 0 = (Γz * Γp) 1 := by
    rw [ContinuousMap.mul_apply, ContinuousMap.mul_apply, hΓzloop, hΓploop]
  have hprod_wind : stemWinding (Γz * Γp) = 0 := by
    rw [stemWinding_mul Γz Γp hΓzne hΓpne hΓzloop hΓploop, hΓzwind, hΓpwind]
    norm_num
  refine ⟨Γz, Γp, hΓzval, hΓpval, ?_, ?_,
    (stemWinding_eq_zero_iff (Γz * Γp) hprod_ne hprod_loop).mp hprod_wind⟩
  · intro hclosed
    have h0 := (stemWinding_eq_zero_iff Γz hΓzne hΓzloop).mpr hclosed
    rw [h0] at hΓzwind
    norm_num at hΓzwind
  · intro hclosed
    have h0 := (stemWinding_eq_zero_iff Γp hΓpne hΓploop).mpr hclosed
    rw [h0] at hΓpwind
    norm_num at hΓpwind

/-- **ROW D — THE ROUND TRIP, OUTBOUND LEG (Φ × the shared ladder, new)**:
at the shared-ladder encounters (LoopAssembly §C: ONE value −r for BOTH
zeros' ε-neighbourhoods) the octonionic realizations of the two encounter
points are carried by Φ — the section functor OF THE A-SECTION
(`sectionFunctor A`, master `thm:section-functor`; never a bare base) —
into ONE component of 𝒮₂ (`phi_encounter_zigzag`, PhiConversion §Φ3(γ)).
The author's round trip, outbound: from 𝕆* (two distinct zero-spheres,
two distinct 𝓗₁-components) through the slice Riemann spheres (one
𝒮₂-component, conserved read = the encounter's value modulus r²), the
A-section itself doing the carrying. PROVED. -/
theorem phi_shared_ladder_glue (A : ASection) (n m : ℕ) :
    ∀ ε > 0, ε < (A.sphereZero n).im → ε < (A.sphereZero m).im →
      ∃ r : ℝ, 0 < r ∧ r < ε ∧
      ∃ z w : ℂ, dist z (A.sphereZero n) < ε ∧ dist w (A.sphereZero m) < ε ∧
        A.F z = -(r : ℂ) ∧ A.F w = -(r : ℂ) ∧ 0 < z.im ∧ 0 < w.im ∧
        ∀ v₁ : Octonion, v₁ ∈ Octonion.unitImaginarySphere →
        ∀ v₂ : Octonion, v₂ ∈ Octonion.unitImaginarySphere →
          Zigzag
            ((sectionFunctor A).obj
              (H1.of ((Octonion.sliceEmbed v₁ z : Octonion) : OnePoint Octonion)))
            ((sectionFunctor A).obj
              (H1.of ((Octonion.sliceEmbed v₂ w : Octonion) : OnePoint Octonion))) := by
  intro ε hε hεn hεm
  obtain ⟨r, hr, hrε, ⟨z, hzd, hzv⟩, ⟨w, hwd, hwv⟩⟩ :=
    A.shared_ladder_encounters n m ε hε
  have hzim : 0 < z.im := im_pos_of_close hzd hεn
  have hwim : 0 < w.im := im_pos_of_close hwd hεm
  refine ⟨r, hr, hrε, z, w, hzd, hwd, hzv, hwv, hzim, hwim,
    fun v₁ hv₁ v₂ hv₂ => ?_⟩
  have hxim := im_embed_ne_zero hv₁ hzim.ne'
  have hyim := im_embed_ne_zero hv₂ hwim.ne'
  have hxcoord := sliceCoord_embed_of_im_pos hv₁ hzim
  have hycoord := sliceCoord_embed_of_im_pos hv₂ hwim
  have hzpole : z ≠ (A.pole : ℂ) := fun h => by
    rw [h, Complex.ofReal_im] at hzim
    exact lt_irrefl 0 hzim
  have hwpole : w ≠ (A.pole : ℂ) := fun h => by
    rw [h, Complex.ofReal_im] at hwim
    exact lt_irrefl 0 hwim
  have hax : AnalyticAt ℂ A.F (Octonion.sliceCoord (Octonion.sliceEmbed v₁ z)) := by
    rw [hxcoord]
    exact A.c1_analyticAt z hzpole
  have hay : AnalyticAt ℂ A.F (Octonion.sliceCoord (Octonion.sliceEmbed v₂ w)) := by
    rw [hycoord]
    exact A.c1_analyticAt w hwpole
  have hval : A.F (Octonion.sliceCoord (Octonion.sliceEmbed v₁ z))
      = A.F (Octonion.sliceCoord (Octonion.sliceEmbed v₂ w)) := by
    rw [hxcoord, hycoord, hzv, hwv]
  exact A.phi_encounter_zigzag hxim hyim hax hay hval

/-- **ROW E — the wedge inside the Φ register (E5 × Φ, new)**: near ONE
enumerated zero-sphere, two encounters at distinct values −r₁ ≠ −r₂
(`sweepE5_encounter_level_not_unique`, PROVED) have Φ-realizations in
DIFFERENT components of 𝒮₂ — the conserved modulus read separates them
(r₁² ≠ r₂², `S2.zigzag_modulus` through `realize_coe` and the C3-analytic
branch). Φ's encounter carriage therefore assigns NO canonical
𝒮₂-component to a single zero-sphere: with ROW D, the value-side reads
GLUE across distinct spheres and SEPARATE within one sphere — the exact
opposite of a level readout. The recorded failure mode of every prior
route (GreatCircleRoute, LoopAssembly Draft I, PhiConversion (δ)), now a
theorem in the section functor's own vocabulary. PROVED. -/
theorem phi_encounter_read_not_unique (A : ASection) (n : ℕ) :
    ∀ ε > 0, ε < (A.sphereZero n).im →
      ∃ r₁ r₂ : ℝ, 0 < r₁ ∧ 0 < r₂ ∧ r₁ ≠ r₂ ∧
      ∃ z₁ z₂ : ℂ, dist z₁ (A.sphereZero n) < ε ∧ dist z₂ (A.sphereZero n) < ε ∧
        A.F z₁ = -(r₁ : ℂ) ∧ A.F z₂ = -(r₂ : ℂ) ∧ 0 < z₁.im ∧ 0 < z₂.im ∧
        ∀ v₁ : Octonion, v₁ ∈ Octonion.unitImaginarySphere →
        ∀ v₂ : Octonion, v₂ ∈ Octonion.unitImaginarySphere →
          ¬ Zigzag
            ((sectionFunctor A).obj
              (H1.of ((Octonion.sliceEmbed v₁ z₁ : Octonion) : OnePoint Octonion)))
            ((sectionFunctor A).obj
              (H1.of ((Octonion.sliceEmbed v₂ z₂ : Octonion) : OnePoint Octonion))) := by
  intro ε hε hεim
  obtain ⟨r₁, r₂, hr₁, hr₂, hne, ⟨z₁, hz₁d, hz₁v⟩, ⟨z₂, hz₂d, hz₂v⟩⟩ :=
    A.sweepE5_encounter_level_not_unique n ε hε
  have hz₁im : 0 < z₁.im := im_pos_of_close hz₁d hεim
  have hz₂im : 0 < z₂.im := im_pos_of_close hz₂d hεim
  refine ⟨r₁, r₂, hr₁, hr₂, hne, z₁, z₂, hz₁d, hz₂d, hz₁v, hz₂v, hz₁im, hz₂im,
    fun v₁ hv₁ v₂ hv₂ hZ => ?_⟩
  have hxcoord := sliceCoord_embed_of_im_pos hv₁ hz₁im
  have hycoord := sliceCoord_embed_of_im_pos hv₂ hz₂im
  have hz₁pole : z₁ ≠ (A.pole : ℂ) := fun h => by
    rw [h, Complex.ofReal_im] at hz₁im
    exact lt_irrefl 0 hz₁im
  have hz₂pole : z₂ ≠ (A.pole : ℂ) := fun h => by
    rw [h, Complex.ofReal_im] at hz₂im
    exact lt_irrefl 0 hz₂im
  have hax : AnalyticAt ℂ A.F (Octonion.sliceCoord (Octonion.sliceEmbed v₁ z₁)) := by
    rw [hxcoord]
    exact A.c1_analyticAt z₁ hz₁pole
  have hay : AnalyticAt ℂ A.F (Octonion.sliceCoord (Octonion.sliceEmbed v₂ z₂)) := by
    rw [hycoord]
    exact A.c1_analyticAt z₂ hz₂pole
  rw [sectionFunctor_obj, sectionFunctor_obj, ASection.realize_coe,
    ASection.realize_coe, if_pos hax, if_pos hay] at hZ
  have hmod := S2.zigzag_modulus hZ
  rw [SliceWorld.modulus_coe, SliceWorld.modulus_coe,
    Octonion.normSq_sliceEmbed
      (Octonion.dir_mem_unitImaginarySphere (im_embed_ne_zero hv₁ hz₁im.ne')),
    Octonion.normSq_sliceEmbed
      (Octonion.dir_mem_unitImaginarySphere (im_embed_ne_zero hv₂ hz₂im.ne')),
    hxcoord, hycoord, hz₁v, hz₂v] at hmod
  have heq : (-(r₁ : ℂ)).re ^ 2 + (-(r₁ : ℂ)).im ^ 2
      = (-(r₂ : ℂ)).re ^ 2 + (-(r₂ : ℂ)).im ^ 2 := OnePoint.coe_eq_coe.mp hmod
  simp only [Complex.neg_re, Complex.neg_im, Complex.ofReal_re, Complex.ofReal_im,
    neg_zero, neg_sq] at heq
  rcases lt_or_gt_of_ne hne with h | h
  · nlinarith [mul_pos (sub_pos.mpr h) (add_pos hr₁ hr₂)]
  · nlinarith [mul_pos (sub_pos.mpr h) (add_pos hr₂ hr₁)]

/-- **ROW F — the articulation APPLIED at the shared ladder (new)**: the
author's clause (iii) — "the residue-ℂ zero spheres … are therefore
concentric (because the fibre is)" — CONSUMED, not cited: at the shared
encounter value −r of the two zeros' neighbourhoods, every pair of
logarithms carries ONE level, log r exactly (`concentric_articulation`
clause (iii) = `exp_fibre_level`; heights band data only). The fibre
through the witness IS concentric; the row hands the drive that
possession at the divisor's own encounter data. PROVED. -/
theorem articulation_fibre_applied (A : ASection) (n m : ℕ) :
    ∀ ε > 0, ∃ r : ℝ, 0 < r ∧ r < ε ∧
      ∃ z w : ℂ, dist z (A.sphereZero n) < ε ∧ dist w (A.sphereZero m) < ε ∧
        A.F z = -(r : ℂ) ∧ A.F w = -(r : ℂ) ∧
        (∀ w₁ w₂ : ℂ, Complex.exp w₁ = A.F z → Complex.exp w₂ = A.F w →
          w₁.re = w₂.re ∧ w₁.re = Real.log r) := by
  intro ε hε
  obtain ⟨-, -, h_fibre⟩ := A.concentric_articulation
  obtain ⟨r, hr, hrε, ⟨z, hzd, hzv⟩, ⟨w, hwd, hwv⟩⟩ :=
    A.shared_ladder_encounters n m ε hε
  refine ⟨r, hr, hrε, z, w, hzd, hwd, hzv, hwv, fun w₁ w₂ h₁ h₂ => ?_⟩
  rw [hzv] at h₁
  rw [hwv] at h₂
  exact ⟨h_fibre r hr w₁ w₂ h₁ h₂, exp_fibre_level hr h₁⟩

/-- **E6 — THE DRIVE** (statement = `ASection.concentricity`,
Theorem.lean:237 — the repository's one open node; the root row is
UNTOUCHED). The fullest board ever fed, every possession PROVED:

(1) ROW B — the negation yields the separated-winding configuration with
    BOTH side loops obstructed (E4's minimal node + ROW A + E3's
    separation);
(2) C1's witness — the pole circle winds exactly −1
    (`stemWinding_circle_pole`), the cone ε–δ (`pole_cone_eps_delta`);
(3) ROWS C/C' — the assembled zero–witness pairs: winding tally − 1;
    closure at tally 1 (the loop assembly THROUGH the cone at N);
(4) the articulation's three clauses (`concentric_articulation`: one
    component, defined through the witness 𝔫, the fibre concentric) +
    ROW F — clause (iii) applied at the shared-ladder encounters;
(5) Φ ON THE A-SECTION — ROW D (the round trip's outbound leg: the two
    spheres' encounters glued into one 𝒮₂-component), ROW E (the wedge:
    one sphere's encounters separated across values), the properness of
    the collapse (`phi_collapse_proper`);
(6) the level tape (`sweepE5_lift_level_tape`), D2's iff
    (`placement_set_iff_liSum` — the target IS ∃β two-sided positivity),
    and E4's edge families (`liSum_first_family_at_supLevel`,
    `liSum_second_family_at_infLevel`).

RECEIPT (R6, 2026-07-06 — the E6 synthesis burn). Goal at the stop:
  ⊢ False
and RESISTS. `exact?` at the seam with ALL of (1)–(6) in context: "could
not close the goal" (machine verdict, this burn). THE PRECISE MISSING
PIECE, in the author's round-trip vocabulary: the A-section's round trip
𝕆* → slice Riemann spheres → 𝕆* is carried OUTBOUND in full by the
possessions — each zero-sphere is one 𝓗₁-component, Φ (of the A-section
itself) glues every sphere to the one value-origin and carries the
encounters with conserved value modulus, the winding definition
transports each zero's datum to the degenerate fibre through the witness
N (the zero–witness pair closes), and the fibre through the witness is
concentric (one level log r per encounter value, heights band data only).
What has NO carrier among the possessions is the RETURN LEG — "back into
𝕆* again from the zero": reading the value-register level (log r —
which near every zero-sphere is unbounded below, not unique, and
Φ-separated: ROWS E and the sweepE5 rows) back as the DOMAIN-register
coordinate Re(sphereZero ·) of the sphere it came from. Every fed row
returns value-side data; the goal names domain-side levels; the
identification of the two registers is `eq:placement-set` itself — the
master's one open node ("Granting the placement, the proof concludes",
master, proof of `thm:concentricity`; E5's sweep verdict: no printed
proof to transcribe). LITMUS (the charter's honesty pin): every
possession (1)–(6) holds VERBATIM for a hypothetical section with a
two-level divisor (zeros at Re 0.3/0.7) — its circles wind on both
sides, its pairs close through the witness, its ladders share values,
its Φ glues and separates identically — so no assembly of these
possessions alone can derive `False`; a proof that closed from them
would be wrong. The `sorry` is the ROUTE RECEIPT (unimported artifact;
R8), not a queue item. -/
theorem concentricity_synthesis (A : ASection) :
    ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c := by
  by_contra hno
  -- (1) the negation cashed in full: separated windings, both sides obstructed
  obtain ⟨n, m, hnm, β, hβ₁, hβ₂, ε, hε, hL, hR, Γn, Γm, hΓn, hΓm, hΓnne, hΓmne,
    hwn, hwm, hobs_n, hobs_m⟩ := A.negation_winding_configuration hno
  -- (2) C1's witness: the pole winds −1; the cone ε–δ at N
  obtain ⟨εp, hεp, hpole⟩ := A.stemWinding_circle_pole
  have hcone := A.pole_cone_eps_delta
  -- (3) the assembled zero–witness pairs (windings tally − 1; closure at 1)
  have hpair_n := A.zero_pole_pair_winding n
  have hpair_m := A.zero_pole_pair_winding m
  -- (4) the articulation, its clauses APPLIED
  obtain ⟨h_one, h_witness, h_fibre⟩ := A.concentric_articulation
  have hart := A.articulation_fibre_applied n m
  -- (5) Φ on the A-section: the round trip's outbound leg and its wedge
  have hglue := A.phi_shared_ladder_glue n m
  have hwedge := A.phi_encounter_read_not_unique n
  have hproper := A.phi_collapse_proper
  -- (6) the level tape, D2's iff, E4's edge families
  have htape := @sweepE5_lift_level_tape
  have hD2 := A.placement_set_iff_liSum
  have hfirst_top := A.liSum_first_family_at_supLevel
  have hsecond_bot := A.liSum_second_family_at_infLevel
  -- RECEIPT: ⊢ False — the return leg of the round trip has no carrier;
  -- the register identification is eq:placement-set itself.
  sorry

end ASection
