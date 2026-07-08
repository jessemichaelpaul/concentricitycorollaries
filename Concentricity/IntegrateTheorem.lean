/-
Concentricity/IntegrateTheorem.lean

MODE A — THE THEOREM, UPDATED (the author's workflow, 2026-07-07, binding:
"prove concentricity DIRECTLY FROM the theorem we already have —
`ASection.concentricity_transport` — the same construction with the
A-section's now-formalized GPV base riding it: witnesses/arrows/fibre data
carrying the level tapes, the lifts through the degenerate passages, the
band assignments — so the one-component conclusion lives on the
fully-updated A-section object and its readout is driven at the target").

Unimported artifact (KeystoneAssembly / GreatCircleRoute / LoopAssembly /
FaithfulApply precedent: not in the root import list; the imported root
ledger is untouched). Per the author's fence of 2026-07-07 this file
carries NO sorried declaration — the one sorry in this repository is the
theorem itself (`ASection.concentricity`, Theorem.lean).

CONTENTS:
  §0  the cone's tape rows (NEW, PROVED) — the 𝔫-end of the great-circle
      leg: the section is zero-free on the punctured real interval at the
      pole (`eventually_ne_zero_near_pole`, C1's order −1 through the
      meromorphic dichotomy), the great-circle tape log‖A‖ ESCAPES at 𝔫
      (`cone_tape_escape` — `rmk:collapse-cone` in tape vocabulary), the
      tape is continuous on zero-free real segments and sweeps every
      intermediate level (IVT, `real_segment_tape_sweeps`), and the two
      sides of 𝔫 SHARE every sufficiently high level
      (`cone_junction_levels_shared` — the junction readout's cone end).
  §1  MODE A1 — the GPV-enriched witness (`GpvTransportWitness`): the
      FROZEN `TransportWitness` datum (closing arrow + C1 certificate)
      EXTENDED with the GPV cargo the certified board proves for every
      A-section: the GPV-𝓑 clause (every domain path: lift exists/unique,
      level tape log‖value‖ continuous and lift-independent —
      `gpvBase_transport`), the degenerate passages at the witness's own
      sphere (`neg_reals_swept_near_sphereZero`), the band pinned at every
      passage (`degenerate_stretch_pins_band`), the cone escape and the
      cone passages (§0, `pole_degenerate_passages`), the fibre concentric
      per level (`Octonion.exp_fibre_concentric`). EVERY A-section is
      GPV-populated (`gpvPopulated`), and the enrichment literally EXTENDS
      the frozen population (`gpvPopulated_extends_populated`, `rfl`).
  §2  MODE A2 — the theorem updated: the one-component conclusion RIDING
      the enriched witnesses (`concentricity_transport_gpv`,
      `transport_universal_gpv`), the enriched zigzag object whose EDGES
      carry the tapes (`GpvZigzag`, `gpvZigzag`), and THE JUNCTION READOUT
      (`gpv_zigzag_readout`): what the composite witness path's conserved
      tape data yields — at the sphere end, one shared value −r at every
      scale with the fibre concentric at log r; at the cone end, every
      sufficiently high level shared on both sides of 𝔫. This is the exact
      quantitative relation the enriched zigzag yields (both ends in the
      VALUE register; the drive record at the end carries the verdict).
  §3  MODE B — the two-level apparatus (`not_concentric_iff_spread`,
      `two_level_apparatus`): the supposition of two distinct levels
      conjoined with the updated theorem's one-component conclusion and
      the counting/rigidity cargo, packaged for the contradiction drive.
  §4  THE DRIVE RECORD (prose; per the fence, no sorried declarations).

`sorry` marks UNFORMALIZED, never UNSOUND (R8); this file carries none.
-/
import Concentricity.FaithfulApply

noncomputable section

open Complex Filter

namespace ASection

/-! ## §0 — the cone's tape rows (the 𝔫-end of the great-circle leg) -/

/-- **The section is zero-free on the punctured real interval at the
pole** (NEW, PROVED). C1's simple pole (`c1_simple`, order −1) through the
meromorphic dichotomy
(`MeromorphicAt.eventually_eq_zero_or_eventually_ne_zero`): the vanishing
branch would force order ⊤ against −1 (`meromorphicOrderAt_eq_top_iff`);
the nonvanishing branch restricts from the punctured plane neighbourhood
to the punctured real interval along the great circle. -/
theorem eventually_ne_zero_near_pole (A : ASection) :
    ∃ δ > 0, ∀ x : ℝ, x ≠ A.pole → |x - A.pole| < δ →
      A.F ((x : ℝ) : ℂ) ≠ 0 := by
  rcases (A.meromorphic (A.pole : ℂ)
      (Set.mem_univ _)).eventually_eq_zero_or_eventually_ne_zero with hzero | hne
  · exfalso
    have htop : meromorphicOrderAt A.F (A.pole : ℂ) = ⊤ :=
      meromorphicOrderAt_eq_top_iff.mpr hzero
    rw [A.c1_simple] at htop
    exact WithTop.coe_ne_top htop
  · rw [Filter.eventually_iff, Metric.mem_nhdsWithin_iff] at hne
    obtain ⟨δ, hδ, h⟩ := hne
    refine ⟨δ, hδ, fun x hx hxd => ?_⟩
    have hxne : ((x : ℝ) : ℂ) ∈ ({(A.pole : ℂ)}ᶜ : Set ℂ) := by
      simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
      exact fun h' => hx (Complex.ofReal_injective h')
    have hdist : dist ((x : ℝ) : ℂ) ((A.pole : ℝ) : ℂ) < δ := by
      rw [Complex.isometry_ofReal.dist_eq, Real.dist_eq]
      exact hxd
    exact h ⟨Metric.mem_ball.mpr hdist, hxne⟩

/-- **THE CONE'S TAPE ESCAPE** (NEW, PROVED) — `rmk:collapse-cone` in the
tape vocabulary of the author's correction (1): along the great circle
ℝ ∪ {N}, within a δ-interval at the pole the section is zero-free AND its
level tape log‖A‖ exceeds any bound M. The 𝔫-end of every enriched
witness leg. From `pole_cone_eps_delta` (C1's cone ε–δ, LoopAssembly,
PROVED) at ε := exp(−M), and §0's zero-freeness. -/
theorem cone_tape_escape (A : ASection) (M : ℝ) :
    ∃ δ > 0, ∀ x : ℝ, x ≠ A.pole → |x - A.pole| < δ →
      A.F ((x : ℝ) : ℂ) ≠ 0 ∧ M < Real.log ‖A.F ((x : ℝ) : ℂ)‖ := by
  obtain ⟨δ₁, hδ₁, h₁⟩ := A.eventually_ne_zero_near_pole
  obtain ⟨δ₂, hδ₂, h₂⟩ := A.pole_cone_eps_delta (Real.exp (-M)) (Real.exp_pos _)
  refine ⟨min δ₁ δ₂, lt_min hδ₁ hδ₂, fun x hx hxd => ?_⟩
  have hne := h₁ x hx (lt_of_lt_of_le hxd (min_le_left _ _))
  have hxC : ((x : ℝ) : ℂ) ≠ (A.pole : ℂ) := fun h' =>
    hx (Complex.ofReal_injective h')
  have hdC : dist ((x : ℝ) : ℂ) ((A.pole : ℝ) : ℂ) < δ₂ := by
    rw [Complex.isometry_ofReal.dist_eq, Real.dist_eq]
    exact lt_of_lt_of_le hxd (min_le_right _ _)
  have hinv := h₂ _ hxC hdC
  refine ⟨hne, ?_⟩
  have hpos : 0 < ‖A.F ((x : ℝ) : ℂ)‖ := norm_pos_iff.mpr hne
  rw [norm_inv, Real.exp_neg] at hinv
  have hlt : Real.exp M < ‖A.F ((x : ℝ) : ℂ)‖ :=
    (inv_lt_inv₀ hpos (Real.exp_pos M)).mp hinv
  exact (Real.lt_log_iff_exp_lt hpos).mpr hlt

/-- The great-circle tape is continuous on any real set avoiding the pole
where the section does not vanish (the author's correction (1): "the level
extends continuously — log|value| is continuous wherever the value ≠ 0").
PROVED. -/
theorem tape_continuousOn_real (A : ASection) {S : Set ℝ}
    (hpole : ∀ y ∈ S, y ≠ A.pole) (hne : ∀ y ∈ S, A.F ((y : ℝ) : ℂ) ≠ 0) :
    ContinuousOn (fun y : ℝ => Real.log ‖A.F ((y : ℝ) : ℂ)‖) S := by
  intro y hy
  have hyC : ((y : ℝ) : ℂ) ≠ (A.pole : ℂ) := fun h' =>
    hpole y hy (Complex.ofReal_injective h')
  have h1 : ContinuousAt A.F ((y : ℝ) : ℂ) := (A.c1_analyticAt _ hyC).continuousAt
  have h2 : ContinuousAt (fun t : ℝ => A.F ((t : ℝ) : ℂ)) y :=
    h1.comp Complex.continuous_ofReal.continuousAt
  have h4 : ContinuousAt (fun t : ℝ => Real.log ‖A.F ((t : ℝ) : ℂ)‖) y :=
    h2.norm.log (norm_ne_zero_iff.mpr (hne y hy))
  exact h4.continuousWithinAt

/-- **The tape sweeps every intermediate level** (NEW, PROVED — IVT on the
great-circle leg): on a zero-free real segment avoiding the pole, every
level between the endpoint tape values is attained. The quantitative
content of "the tape is continuous through every degenerate passage". -/
theorem real_segment_tape_sweeps (A : ASection) {u v : ℝ} (huv : u ≤ v)
    (hpole : ∀ y ∈ Set.Icc u v, y ≠ A.pole)
    (hne : ∀ y ∈ Set.Icc u v, A.F ((y : ℝ) : ℂ) ≠ 0) {L : ℝ}
    (hL : L ∈ Set.uIcc (Real.log ‖A.F ((u : ℝ) : ℂ)‖)
      (Real.log ‖A.F ((v : ℝ) : ℂ)‖)) :
    ∃ y ∈ Set.Icc u v, Real.log ‖A.F ((y : ℝ) : ℂ)‖ = L := by
  have huIcc : Set.uIcc u v = Set.Icc u v := Set.uIcc_of_le huv
  have hcont : ContinuousOn (fun y : ℝ => Real.log ‖A.F ((y : ℝ) : ℂ)‖)
      (Set.uIcc u v) := by
    rw [huIcc]
    exact A.tape_continuousOn_real hpole hne
  obtain ⟨y, hy, hyL⟩ := intermediate_value_uIcc hcont hL
  rw [huIcc] at hy
  exact ⟨y, hy, hyL⟩

/-- **THE JUNCTION'S CONE END — both legs share every sufficiently high
level** (NEW, PROVED). The composite witness path of the enriched zigzag
(n's leg to 𝔫, reversed m's leg) rides the great circle into the cone from
both sides; by the escape (`cone_tape_escape`) and the sweep
(`real_segment_tape_sweeps`), there is a threshold L₀ above which EVERY
level is a tape value on BOTH sides of 𝔫: the two legs' tape ranges
overlap in a half-line through the cone. This is the conserved-data
relation of the enriched zigzag at its junction. -/
theorem cone_junction_levels_shared (A : ASection) :
    ∃ L₀ : ℝ, ∀ L : ℝ, L₀ ≤ L →
      (∃ x : ℝ, x < A.pole ∧ Real.log ‖A.F ((x : ℝ) : ℂ)‖ = L) ∧
      (∃ x : ℝ, A.pole < x ∧ Real.log ‖A.F ((x : ℝ) : ℂ)‖ = L) := by
  obtain ⟨δ, hδ, h⟩ := A.cone_tape_escape 0
  set x₁ : ℝ := A.pole - δ / 2 with hx₁_def
  set x₂ : ℝ := A.pole + δ / 2 with hx₂_def
  have hx₁ne : x₁ ≠ A.pole := by
    rw [hx₁_def]
    intro h'
    linarith
  have hx₂ne : x₂ ≠ A.pole := by
    rw [hx₂_def]
    intro h'
    linarith
  have hx₁d : |x₁ - A.pole| < δ := by
    rw [hx₁_def, abs_of_neg (by linarith)]
    linarith
  have hx₂d : |x₂ - A.pole| < δ := by
    rw [hx₂_def, abs_of_pos (by linarith)]
    linarith
  refine ⟨max (Real.log ‖A.F ((x₁ : ℝ) : ℂ)‖) (Real.log ‖A.F ((x₂ : ℝ) : ℂ)‖),
    fun L hL => ?_⟩
  obtain ⟨δL, hδL, hesc⟩ := A.cone_tape_escape L
  constructor
  · -- the left side of 𝔫: sweep the segment [x₁, pole − min δL δ / 2]
    set xr : ℝ := A.pole - min δL δ / 2 with hxr_def
    have hmin : 0 < min δL δ := lt_min hδL hδ
    have hx₁xr : x₁ ≤ xr := by
      rw [hx₁_def, hxr_def]
      have := min_le_right δL δ
      linarith
    have hxrp : xr < A.pole := by rw [hxr_def]; linarith
    have hseg : ∀ y ∈ Set.Icc x₁ xr, y ≠ A.pole ∧ |y - A.pole| < δ := by
      rintro y ⟨hy₁, hy₂⟩
      have hylt : y < A.pole := lt_of_le_of_lt hy₂ hxrp
      refine ⟨ne_of_lt hylt, ?_⟩
      rw [abs_of_neg (by linarith)]
      rw [hx₁_def] at hy₁
      linarith
    have hxrne : xr ≠ A.pole := ne_of_lt hxrp
    have hxrδL : |xr - A.pole| < δL := by
      rw [hxr_def, abs_of_neg (by linarith)]
      have := min_le_left δL δ
      linarith
    have hxrL : L < Real.log ‖A.F ((xr : ℝ) : ℂ)‖ := (hesc xr hxrne hxrδL).2
    have hx₁L : Real.log ‖A.F ((x₁ : ℝ) : ℂ)‖ ≤ L :=
      le_trans (le_max_left _ _) hL
    obtain ⟨y, hy, hyL⟩ := A.real_segment_tape_sweeps hx₁xr
      (fun y hy => (hseg y hy).1)
      (fun y hy => (h y (hseg y hy).1 (hseg y hy).2).1)
      (Set.mem_uIcc.mpr (Or.inl ⟨hx₁L, hxrL.le⟩))
    exact ⟨y, lt_of_le_of_lt hy.2 hxrp, hyL⟩
  · -- the right side of 𝔫: sweep the segment [pole + min δL δ / 2, x₂]
    set xr : ℝ := A.pole + min δL δ / 2 with hxr_def
    have hmin : 0 < min δL δ := lt_min hδL hδ
    have hxrx₂ : xr ≤ x₂ := by
      rw [hx₂_def, hxr_def]
      have := min_le_right δL δ
      linarith
    have hxrp : A.pole < xr := by rw [hxr_def]; linarith
    have hseg : ∀ y ∈ Set.Icc xr x₂, y ≠ A.pole ∧ |y - A.pole| < δ := by
      rintro y ⟨hy₁, hy₂⟩
      have hygt : A.pole < y := lt_of_lt_of_le hxrp hy₁
      refine ⟨(ne_of_lt hygt).symm, ?_⟩
      rw [abs_of_pos (by linarith)]
      rw [hx₂_def] at hy₂
      linarith
    have hxrne : xr ≠ A.pole := (ne_of_lt hxrp).symm
    have hxrδL : |xr - A.pole| < δL := by
      rw [hxr_def, abs_of_pos (by linarith)]
      have := min_le_left δL δ
      linarith
    have hxrL : L < Real.log ‖A.F ((xr : ℝ) : ℂ)‖ := (hesc xr hxrne hxrδL).2
    have hx₂L : Real.log ‖A.F ((x₂ : ℝ) : ℂ)‖ ≤ L :=
      le_trans (le_max_right _ _) hL
    obtain ⟨y, hy, hyL⟩ := A.real_segment_tape_sweeps hxrx₂
      (fun y hy => (hseg y hy).1)
      (fun y hy => (h y (hseg y hy).1 (hseg y hy).2).1)
      (Set.mem_uIcc.mpr (Or.inr ⟨hx₂L, hxrL.le⟩))
    exact ⟨y, lt_of_lt_of_le hxrp hy.1, hyL⟩

/-! ## §1 — MODE A1: the GPV-enriched witness

The frozen `TransportWitness` (TransportObject.lean: the closing arrow of
𝒯^𝔫 at the level + C1's certificate) EXTENDED with the GPV cargo — the
data of the A-section's now-formalized GPV base (the author's correction
(2): "GPV lives ON the base 𝓑 — the A-section turns 𝓑 into a GPV-𝓑").
Every field's content is a certified row of the board; `gpvPopulated`
below assembles them for EVERY A-section. -/

/-- **The GPV-enriched transport witness at the n-th zero-sphere** (Mode
A1). Extends the frozen datum with: (a) the GPV-𝓑 clause — along every
pole-avoiding nonvanishing domain path the lift exists, its level tape is
log‖value‖ at every instant, the tape is continuous and lift-independent,
the lift unique through its basepoint; (b) the degenerate passages at this
witness's own sphere — every scale, every sufficiently small −r is a value
of A near the sphere; (c) the band pinned at every degenerate passage —
every lift rides ONE rung, its tape the same moving log‖value‖; (d) the
cone escape — the great-circle tape at 𝔫 exceeds every bound (zero-free);
(e) the cone passages — degenerate values with level above every bound on
the real axis at 𝔫; (f) the fibre concentric per level — one level per
degenerate value, all freedom in direction and winding. -/
structure GpvTransportWitness (A : ASection) (n : ℕ) : Type where
  /-- The frozen transport datum: the closing arrow at the level
  `transportLevel n` of 𝒯^𝔫, with C1 instantiated (TransportObject.lean,
  frozen). -/
  witness : A.TransportWitness (A.transportLevel n)
  /-- (a) the GPV-𝓑 clause (`gpvBase_transport`, FaithfulApply §1). -/
  gpv_base : ∀ (δ : C(unitInterval, ℂ)) (_ : ∀ t, δ t ≠ (A.pole : ℂ))
      (_ : ∀ t, A.F (δ t) ≠ 0),
      ∃ Γ : C(unitInterval, ℂ),
        (∀ t, Complex.exp (Γ t) = A.F (δ t)) ∧
        (∀ t, (Γ t).re = Real.log ‖A.F (δ t)‖) ∧
        (Continuous fun t => (Γ t).re) ∧
        (∀ Γ' : C(unitInterval, ℂ), (∀ t, Complex.exp (Γ' t) = A.F (δ t)) →
          Γ' 0 = Γ 0 → Γ' = Γ) ∧
        (∀ Γ' : C(unitInterval, ℂ), (∀ t, Complex.exp (Γ' t) = A.F (δ t)) →
          ∀ t, (Γ' t).re = (Γ t).re)
  /-- (b) the degenerate passages at this sphere
  (`neg_reals_swept_near_sphereZero`, LoopAssembly). -/
  sphere_passages : ∀ ε > 0, ∃ η > 0, ∀ r : ℝ, 0 < r → r < η →
      ∃ z : ℂ, dist z (A.sphereZero n) < ε ∧ A.F z = -(r : ℂ)
  /-- (c) the band pinned at every degenerate passage
  (`degenerate_stretch_pins_band`, InboxWire §B). -/
  passage_band : ∀ (z : unitInterval → ℂ) (Γ' : C(unitInterval, ℂ)),
      (∀ t, Complex.exp (Γ' t) = A.F (z t)) → ∀ a b : unitInterval, a ≤ b →
      (∀ t, a ≤ t → t ≤ b → (A.F (z t)).re < 0 ∧ (A.F (z t)).im = 0) →
      ∃ k : ℤ, ∀ t, a ≤ t → t ≤ b →
        (Γ' t).im = (2 * (k : ℝ) + 1) * Real.pi
        ∧ (Γ' t).re = Real.log ‖A.F (z t)‖
  /-- (d) the cone escape (§0, `cone_tape_escape`). -/
  cone_escape : ∀ M : ℝ, ∃ δ > 0, ∀ x : ℝ, x ≠ A.pole → |x - A.pole| < δ →
      A.F ((x : ℝ) : ℂ) ≠ 0 ∧ M < Real.log ‖A.F ((x : ℝ) : ℂ)‖
  /-- (e) the cone passages (`pole_degenerate_passages`, LogManifold §D). -/
  cone_passages : ∀ M : ℝ, ∀ δ > 0, ∃ x : ℝ, x ≠ A.pole ∧ |x - A.pole| < δ ∧
      ∃ r : ℝ, 0 < r ∧ M < Real.log r ∧ A.F ((x : ℝ) : ℂ) = -(r : ℂ)
  /-- (f) the fibre concentric per level (`Octonion.exp_fibre_concentric`,
  WeldW3). -/
  fibre_concentric : ∀ r : ℝ, 0 < r → ∀ q₁ q₂ : Octonion,
      Octonion.exp q₁ = Octonion.ofReal (-r) →
      Octonion.exp q₂ = Octonion.ofReal (-r) →
      Octonion.re q₁ = Octonion.re q₂

/-- The GPV-enriched population: an enriched witness at every enumerated
zero-sphere (the enriched form of the frozen `ASection.Populated`). -/
def GpvPopulated (A : ASection) : Type := ∀ n : ℕ, A.GpvTransportWitness n

/-- **EVERY A-section is GPV-populated** (Mode A1's theorem): the enriched
witness is assembled at every n from the certified board — the frozen
population supplies the arrow and C1; `gpvBase_transport`,
`neg_reals_swept_near_sphereZero`, `degenerate_stretch_pins_band`,
`cone_tape_escape`, `pole_degenerate_passages`,
`Octonion.exp_fibre_concentric` supply the cargo. No new hypothesis, no
strengthening of `def:A-section`: every field is a proved consequence of
C1–C4 (R3: the four hypotheses applied together). -/
def gpvPopulated (A : ASection) : A.GpvPopulated := fun n =>
  { witness := A.populated n
    gpv_base := fun δ hp hne => A.gpvBase_transport δ hp hne
    sphere_passages := A.neg_reals_swept_near_sphereZero n
    passage_band := fun z Γ' hlift _ _ hab hstretch =>
      A.degenerate_stretch_pins_band z Γ' hlift hab hstretch
    cone_escape := A.cone_tape_escape
    cone_passages := fun M => A.pole_degenerate_passages M
    fibre_concentric := fun _ hr _ _ h₁ h₂ =>
      Octonion.exp_fibre_concentric hr h₁ h₂ }

/-- The enrichment EXTENDS the frozen population — the arrow of the
enriched witness IS the frozen closing arrow (definitional; the
anti-vacuity pin of Mode A1). -/
theorem gpvPopulated_extends_populated (A : ASection) (n : ℕ) :
    (A.gpvPopulated n).witness.arrow = (A.populated n).arrow := rfl

/-- Forgetting the cargo returns a frozen population: the enriched object
sits OVER the frozen one (the update is conservative — Mode A's "same
construction"). -/
def GpvPopulated.forget {A : ASection} (hA : A.GpvPopulated) : A.Populated :=
  fun n => (hA n).witness

/-! ## §2 — MODE A2: the theorem updated -/

/-- **THE CONCENTRICITY TRANSPORT THEOREM, UPDATED** (Mode A2; master
`thm:concentricity` on the enriched object): the residue-ℂ zero classes of
a GPV-populated A-section lie in a single connected component of the
populated total object 𝒯^𝔫 — the SAME construction as the frozen
`concentricity_transport` (TransportObject.lean), now consuming the
ENRICHED witnesses: the coincidence is produced by the enriched witnesses'
own closing arrows, so the one-component conclusion lives on the
fully-updated A-section object (its arrows carrying the level tapes, the
degenerate passages, the band assignments of §1). -/
theorem concentricity_transport_gpv (A : ASection) (hA : A.GpvPopulated)
    (n m : ℕ) : A.transportClass n = A.transportClass m :=
  A.concentricity_transport hA.forget n m

/-- The updated theorem, class-wide (the enriched form of the frozen
`transport_universal`): EVERY A-section's zero classes coincide in 𝒯^𝔫,
through its own GPV-enriched population. -/
theorem transport_universal_gpv (A : ASection) (n m : ℕ) :
    A.transportClass n = A.transportClass m :=
  A.concentricity_transport_gpv A.gpvPopulated n m

/-- **The enriched zigzag** (Mode A2's object): the two closing edges of
the witness zigzag n → 𝔫 ← m, each carrying its GPV cargo (the tapes, the
passages, the bands), together with the class coincidence they produce.
The EDGES carry the level tapes — the zigzag is the updated theorem's
witness object. -/
structure GpvZigzag (A : ASection) (n m : ℕ) : Type where
  /-- the n-edge: the enriched witness at the n-th sphere. -/
  edgeN : A.GpvTransportWitness n
  /-- the m-edge: the enriched witness at the m-th sphere. -/
  edgeM : A.GpvTransportWitness m
  /-- the coincidence the two edges produce: one component of 𝒯^𝔫. -/
  class_eq : A.transportClass n = A.transportClass m

/-- Every A-section carries an enriched zigzag between every pair of its
zero-spheres — Mode A2's population of the updated theorem. -/
def gpvZigzag (A : ASection) (n m : ℕ) : A.GpvZigzag n m :=
  { edgeN := A.gpvPopulated n
    edgeM := A.gpvPopulated m
    class_eq := A.transport_universal_gpv n m }

/-- **THE JUNCTION READOUT** (Mode A2's drive at the composite witness
path — the exact quantitative relation the enriched zigzag's conserved
data yields). Along the composite path (n's leg to 𝔫, reversed m's leg):
(1) ONE COMPONENT — the class coincidence, riding the enriched witnesses;
(2) THE SPHERE END — at every scale ε the two spheres' degenerate
    encounters share ONE value −r (r < ε), and the fibre over that one
    value is concentric: every two lift positions over −r carry the SAME
    level log r (all freedom is winding/band);
(3) THE CONE END — there is a threshold L₀ above which EVERY level is a
    tape value on BOTH sides of 𝔫: the two legs' tape ranges overlap in a
    half-line through the cone.
Both conserved readings live in the VALUE register (the tape reads
log‖A‖, the encounter reads log r); the drive record (§4) carries what
this yields at the DOMAIN-register target. -/
theorem gpv_zigzag_readout (A : ASection) (hA : A.GpvPopulated) (n m : ℕ) :
    A.transportClass n = A.transportClass m
    ∧ (∀ ε > 0, ∃ r : ℝ, 0 < r ∧ r < ε ∧
        (∃ z : ℂ, dist z (A.sphereZero n) < ε ∧ A.F z = -(r : ℂ)) ∧
        (∃ w : ℂ, dist w (A.sphereZero m) < ε ∧ A.F w = -(r : ℂ)) ∧
        ∀ w₁ w₂ : ℂ, Complex.exp w₁ = -(r : ℂ) → Complex.exp w₂ = -(r : ℂ) →
          w₁.re = w₂.re)
    ∧ (∃ L₀ : ℝ, ∀ L : ℝ, L₀ ≤ L →
        (∃ x : ℝ, x < A.pole ∧ Real.log ‖A.F ((x : ℝ) : ℂ)‖ = L) ∧
        (∃ x : ℝ, A.pole < x ∧ Real.log ‖A.F ((x : ℝ) : ℂ)‖ = L)) := by
  refine ⟨A.concentricity_transport_gpv hA n m, fun ε hε => ?_,
    A.cone_junction_levels_shared⟩
  obtain ⟨r, hr, hrε, hzn, hzm⟩ := A.shared_ladder_encounters n m ε hε
  exact ⟨r, hr, hrε, hzn, hzm, fun w₁ w₂ h₁ h₂ =>
    (exp_fibre_level hr h₁).trans (exp_fibre_level hr h₂).symm⟩

/-! ## §3 — MODE B: the two-level apparatus -/

/-- The negation of the target in the section's own coordinates: NOT
concentric ⟺ positive level spread (KernelE4's minimal-node dictionary,
¬-form). PROVED. -/
theorem not_concentric_iff_spread (A : ASection) :
    ¬(∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c)
      ↔ A.infLevel < A.supLevel := by
  rw [A.concentricity_iff_infLevel_eq_supLevel]
  exact ⟨fun h => lt_of_le_of_ne A.infLevel_le_supLevel h,
    fun h h' => absurd h' (ne_of_lt h)⟩

/-- **MODE B — the two-level apparatus, assembled** (the contradiction
drive's feed, in one record): under the supposition of two distinct
levels, the board yields JOINTLY —
(1) the updated theorem's one-component conclusion (the enriched zigzag
    between the two named spheres — Mode B's "the proved one-component
    conclusion" clause);
(2) W2(d)'s counting pair: a wall Re = β strictly between the levels, and
    admissible rectangles strictly left/right, each trapping its sphere,
    each with the section's value-loop winding EXACTLY its own trapped
    count ≥ 1;
(3) crossing-sign rigidity on the great circle: at every real footpoint
    (≠ pole, value ≠ 0) the sign of the gauged crossing value is computed
    by the REAL divisor and pole alone — the two named spheres are
    sign-invisible at every crossing between the levels.
Each conjunct PROVED; the drive at `False` from this record is §4's
verdict. -/
theorem two_level_apparatus (A : ASection) (hA : A.GpvPopulated) {n m : ℕ}
    (hsep : (A.sphereZero n).re < (A.sphereZero m).re) :
    (A.transportClass n = A.transportClass m)
    ∧ (∃ β : ℝ, (A.sphereZero n).re < β ∧ β < (A.sphereZero m).re ∧
      ∃ xn₁ xn₂ yn₁ yn₂ xm₁ xm₂ ym₁ ym₂ : ℝ,
        xn₂ < β ∧ β < xm₁ ∧ 0 < yn₁ ∧ 0 < ym₁ ∧
        A.sphereZero n ∈ openRect xn₁ xn₂ yn₁ yn₂ ∧
        A.sphereZero m ∈ openRect xm₁ xm₂ ym₁ ym₂ ∧
        ∃ sn sm : Finset ℕ,
          (∀ k, k ∈ sn ↔ A.sphereZero k ∈ openRect xn₁ xn₂ yn₁ yn₂) ∧
          (∀ k, k ∈ sm ↔ A.sphereZero k ∈ openRect xm₁ xm₂ ym₁ ym₂) ∧
          1 ≤ sn.card ∧ 1 ≤ sm.card ∧
          ∃ Γn Γm : C(unitInterval, ℂ),
            (∀ t, Γn t = A.F (rectLoop xn₁ xn₂ yn₁ yn₂ t)) ∧
            (∀ t, Γm t = A.F (rectLoop xm₁ xm₂ ym₁ ym₂ t)) ∧
            stemWinding Γn = sn.card ∧ stemWinding Γm = sm.card)
    ∧ (∀ x : ℝ, (x : ℂ) ≠ (A.pole : ℂ) → A.F (x : ℂ) ≠ 0 →
        0 < (((x : ℂ) - (A.pole : ℂ)) * A.F (x : ℂ)).re
          * ((x : ℂ) ^ A.m * A.Rfac (x : ℂ)).re) :=
  ⟨A.concentricity_transport_gpv hA n m,
    A.counting_pair_of_two_levels hsep,
    fun x hx hF => A.crossing_sign_rigid x hx hF⟩

end ASection
