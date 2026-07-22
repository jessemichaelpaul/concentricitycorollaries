/-
Concentricity/WeldW3.lean

W3 — GPV WELDED TO C1–C4 ON THE OCTONIONIC REGISTER (working artifact;
KeystoneAssembly / GreatCircleRoute / LoopAssembly / SigmaE3 precedent;
NOT imported by the root — the imported ledger is untouched). The author's
point of view (2026-07-06, the organizing principle): the A-section is
DEFINED by C1–C4 and EXTENDS ALL OF GPV — the winding/tameness theory is a
body of consequences the definition already owns; these rows weld it in on
the repo's own octonionic types (Octonion.dir, sliceEmbed,
unitImaginarySphere, the sphere geometry), never as citations.

WHAT IS PROVED HERE (all rows on the kernel triple; helpers never sorried,
R8) — four weld steps:

§W0 — the artifact-local topology of 𝕆 (the product = norm topology of the
Cayley–Dickson pair ℍ × ℍ), needed only to STATE GPVwind's octonionic
paths γ : [a,b] → 𝕂 ∖ {0} on the repo's own type.

WELD STEP (a) — THE OCTONIONIC DIFFERENCE as a theorem pair: on the stem
(ℂ) the direction set is S⁰ = {±1}, disconnected — no continuous direction
path joins 1 to −1 (`stem_direction_disconnected`, IVT); on 𝕆 it is S⁶,
connected — an explicit great-circle path of directions joins v to −v
inside the unit imaginary sphere, never real
(`Octonion.direction_path_to_neg`, from the basic-triple orthogonal
partner P4.2.e; the master's clause is `thm:G2-S6`, G₂ transitive on S⁶).

WELD STEP (b) — TAME SPHERE-ENCLOSING LOOPS: for the n-th residue-ℂ
zero-sphere σₙ + γₙS⁶ the octonionic loop `ASection.sphereLoop` (the
ε-circle in the slice ℂ_v about the enumerated zero) encircles the sphere
(`sphereLoop_encircles`), has EMPTY obstruction set — GPVwind Def 5.1's
T = γ⁻¹(ℝ) = ∅ (`sphereLoop_obstruction_empty`) — hence carries the
CONSTANT companion field v (`sphereLoop_companion`), unique in 𝕊/{±Id}
(`Octonion.companion_forced` + `sphereLoop_tame` — Def 4.7's tameness:
unique companion); its stem carrier admits NO Def 5.2 crossing data
(`sphereLoop_crossing_isEmpty`), so there are no flips and no bounces, the
circular signature is 0 with even parity — Def 5.19's closing clause
(`sphereLoop_sigma_c_zero`) — and the domain loop's own winding is 0,
consistent with Cor 5.21's ω = |σᶜ|/2 (`sphereLoop_domain_winding_zero`).

WELD STEP (c) — THE BAND READING ("the kernel of exp is concentric for all
imaginary octonions", the author, 2026-07-06): the octonionic degenerate
fibre carries ONE level (`Octonion.exp_fibre_re`,
`Octonion.exp_fibre_concentric` — the fibre's spheres are concentric about
the single real centre log r), the fibre over −1 IS the family of
concentric spheres (2k+1)π·S⁶ about 0 in im 𝕆
(`Octonion.exp_kernel_unit_imaginary`), and along the sphere-loop's VALUE
loop every log-lift closes in the LEVEL and shifts by exactly
tally · 2π in the BAND (`ASection.sphereLoop_value_band` — level conserved,
winding is band data; `winding_loop_defect_level_zero` +
`winding_height_shift` welded to the fiber tally).

WELD STEP (d) — THE TOUCH ("the winding is unique and tame and already
touches the ℂ-residues", the author, 2026-07-06): the REALIZED value loop
of the tame sphere-enclosing loop is the slice embedding of the stem value
loop — the companion v carries through the values, def:section-map(i)
(`ASection.realize_sphereLoop`) — and winds exactly the enumerated
divisor's fiber tally ≥ 1 (`ASection.sphereLoop_value_winding`); a winding
value-loop MUST meet the negative reals — the real-axis obstruction as a
theorem (`stemWinding_pos_meets_neg_real`, IVT on the lift's height) — so
every tame sphere-enclosing loop's value data touches `lem:exp-degenerate`'s
fibre at some −r, whose octonionic fibre carries the ONE level log r
(`ASection.sphereLoop_touches_degenerate`).

The historical target-level receipt has been retired.  The proved W3 supplier
rows above remain; no target theorem or `sorry` is declared in this file.
-/
import Concentricity.SigmaE3

noncomputable section

/-! ## §W0 — the artifact-local topology of 𝕆

GPVwind's objects are continuous paths and loops `γ : [a,b] → 𝕂 ∖ {0}`
(Def 4.1, Def 4.7, Def 5.11 — SOURCES/GPVwind.md). The repo's `Octonion`
(the Cayley–Dickson pair, Concentricity/Octonion.lean) carries no
topology; these instances install the product topology of ℍ × ℍ (= the
norm topology of `Octonion.normSq`), by `inferInstanceAs` in the exact
pattern of the repo's own `AddCommGroup`/`Module`/`FiniteDimensional`
instances. Artifact-local: the root never imports this file. -/

namespace Octonion

/-- The product (= norm) topology of the Cayley–Dickson pair. -/
instance : TopologicalSpace Octonion :=
  inferInstanceAs (TopologicalSpace (Quaternion ℝ × Quaternion ℝ))

/-- Addition is continuous (componentwise, from ℍ's normed structure). -/
instance : ContinuousAdd Octonion :=
  inferInstanceAs (ContinuousAdd (Quaternion ℝ × Quaternion ℝ))

/-- The real scalar action is continuous (componentwise, from ℍ's normed
ℝ-algebra structure). -/
instance : ContinuousSMul ℝ Octonion :=
  inferInstanceAs (ContinuousSMul ℝ (Quaternion ℝ × Quaternion ℝ))

/-- The slice embedding in scalar-action form (helper for continuity):
φ_v(z) = z.re • 1 + z.im • v. Definitional, through
`ofReal_eq_smul_one` (Concentricity/Slice.lean). -/
theorem sliceEmbed_eq_smul (v : Octonion) (z : ℂ) :
    sliceEmbed v z = z.re • (1 : Octonion) + z.im • v := by
  rw [show sliceEmbed v z = ofReal z.re + z.im • v from rfl, ofReal_eq_smul_one]

end Octonion

/-! ## WELD STEP (a) — the octonionic difference -/

/-- **WELD STEP (a), the ℂ side — the direction set S⁰ is disconnected.**
On the stem register the direction field of GPVwind Def 5.2 is carried by
the sign of the imaginary part (`stemDirSign`, SigmaE3 §C: "the field
Y/|Y| of GPVwind (5.4) is sign(im γ t)·i ∈ {±i}"): the direction set is
the two-point S⁰. This row is the disconnection as a theorem: NO
continuous ±1-valued path joins 1 to −1 — a loop in ℂ around a zero is
forced through the real-axis obstruction (GPVwind Def 5.1: "the set
T := γ⁻¹(ℝ) … the obstruction set"), because its direction data cannot
pass from v to −v continuously. IVT on the connected `unitInterval`
(`intermediate_value_univ`, Mathlib/Topology/Order/IntermediateValue
.lean:175; `ConnectedSpace unitInterval`, Mathlib/Topology/UnitInterval
.lean:164). PROVED. -/
theorem stem_direction_disconnected :
    ¬ ∃ f : C(unitInterval, ℝ), f 0 = 1 ∧ f 1 = -1 ∧ ∀ t, f t = 1 ∨ f t = -1 := by
  rintro ⟨f, h0, h1, hval⟩
  have hmem : (0 : ℝ) ∈ Set.Icc (f 1) (f 0) := by
    rw [h0, h1]
    constructor <;> norm_num
  obtain ⟨t, ht⟩ := intermediate_value_univ 1 0 (map_continuous f) hmem
  rcases hval t with h | h <;> rw [ht] at h <;> norm_num at h

/-- **WELD STEP (a), the 𝕆 side — the direction set S⁶ is connected.**
The octonionic difference: a continuous path of directions joins v to −v
INSIDE the unit imaginary sphere, never touching ℝ — the great circle
t ↦ cos(πt)·v + sin(πt)·w through an orthogonal unit imaginary partner w.
The partner is the repo's own basic-triple extension
(`Octonion.exists_basicTriple`, P4.2.e, OctonionForm.lean — DERIVED, R10);
the master's clause is `thm:G2-S6` (Baez, SOURCES/Baez02.md: "the
automorphism … can map e₁ to any point e₁′ on the 6-sphere of unit
imaginary octonions"). Membership: `re` linear, `normSq_add_eq` +
orthogonality; the path avoids ℝ outright (fourth clause), so GPVwind
Rem 2.1's obstruction ("the function 𝓘 cannot be extended as a continuous
function to any single point of the real axis ℝ of 𝕂",
SOURCES/GPVwind.md) is never met. This is exactly what the stem lacks
(`stem_direction_disconnected`). PROVED. -/
theorem Octonion.direction_path_to_neg {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) :
    ∃ p : C(unitInterval, Octonion), p 0 = v ∧ p 1 = -v ∧
      (∀ t, p t ∈ Octonion.unitImaginarySphere) ∧
      (∀ t, Octonion.im (p t) ≠ 0) := by
  obtain ⟨T, hTu⟩ := Octonion.exists_basicTriple v hv
  have hw : T.w ∈ Octonion.unitImaginarySphere := T.hw
  have hvw : Octonion.innerO v T.w = 0 := by rw [← hTu]; exact T.huw
  have hcont : Continuous fun t : unitInterval =>
      Real.cos (Real.pi * (t : ℝ)) • v + Real.sin (Real.pi * (t : ℝ)) • T.w :=
    ((Real.continuous_cos.comp (continuous_const.mul continuous_subtype_val)).smul
        continuous_const).add
      ((Real.continuous_sin.comp (continuous_const.mul continuous_subtype_val)).smul
        continuous_const)
  set p : C(unitInterval, Octonion) := ⟨_, hcont⟩ with hp_def
  have hval : ∀ t : unitInterval, p t
      = Real.cos (Real.pi * (t : ℝ)) • v + Real.sin (Real.pi * (t : ℝ)) • T.w :=
    fun _ => rfl
  have hmem : ∀ t, p t ∈ Octonion.unitImaginarySphere := by
    intro t
    rw [hval t]
    refine ⟨?_, ?_⟩
    · rw [Octonion.re_add, Octonion.re_smul, Octonion.re_smul, hv.1, hw.1]
      ring
    · rw [Octonion.normSq_add_eq, Octonion.normSq_smul, Octonion.normSq_smul,
        hv.2, hw.2, Octonion.innerO_smul_left, Octonion.innerO_comm,
        Octonion.innerO_smul_left, Octonion.innerO_comm, hvw]
      linear_combination Real.sin_sq_add_cos_sq (Real.pi * (t : ℝ))
  refine ⟨p, ?_, ?_, hmem, ?_⟩
  · have hcoe : ((0 : unitInterval) : ℝ) = 0 := rfl
    rw [hval 0, hcoe, mul_zero, Real.cos_zero, Real.sin_zero, one_smul,
      zero_smul, add_zero]
  · have h1 : Real.pi * ((1 : unitInterval) : ℝ) = Real.pi := by norm_num
    rw [hval 1, h1, Real.cos_pi, Real.sin_pi, zero_smul, add_zero]
    exact neg_one_smul ℝ v
  · intro t hcontra
    have hre := (hmem t).1
    have hnormSq := (hmem t).2
    have him_eq : Octonion.im (p t)
        = p t - Octonion.ofReal (Octonion.re (p t)) := rfl
    rw [him_eq, hre, show Octonion.ofReal (0 : ℝ) = 0 from by
      rw [Octonion.ofReal_eq_smul_one, zero_smul], sub_zero] at hcontra
    rw [hcontra, Octonion.normSq_zero] at hnormSq
    norm_num at hnormSq

/-! ## WELD STEP (b) — tame sphere-enclosing loops -/

/-- **WELD STEP (b) — Def 4.7's companion is pointwise forced off ℝ.**
GPVwind Def 4.7 (SOURCES/GPVwind.md, verbatim): "A path
𝔍^γ : [a,b] → 𝕊/{±Id} such that γ(t) ∈ ℂ_{𝔍^γ(t)} for every t ∈ [a,b] is
called a companion of the path γ. … If the path γ has a unique companion
𝔍^γ, then both γ and the pair (γ, 𝔍^γ) are called a tame path." On the
repo's types: at any non-real point, ANY slice-membership witness w
(q ∈ ℂ_w, w ∈ S⁶) is ± the direction — the companion class in 𝕊/{±Id} is
unique, tameness holds pointwise wherever the path avoids ℝ. PROVED. -/
theorem Octonion.companion_forced {q w : Octonion}
    (hw : w ∈ Octonion.unitImaginarySphere) {ξ : ℂ}
    (hq : q = Octonion.sliceEmbed w ξ) (him : Octonion.im q ≠ 0) :
    w = Octonion.dir q ∨ w = -Octonion.dir q := by
  have hξ : ξ.im ≠ 0 := by
    intro h0
    apply him
    rw [hq, Octonion.im_sliceEmbed hw, h0, zero_smul]
  rcases lt_or_gt_of_ne hξ with hneg | hpos
  · right
    rw [hq, Octonion.dir_sliceEmbed_of_neg hw hneg, neg_neg]
  · left
    rw [hq, Octonion.dir_sliceEmbed_of_pos hw hpos]

namespace ASection

/-- **WELD STEP (b) — the sphere-enclosing octonionic loop.** For the n-th
residue-ℂ zero-sphere σₙ + γₙS⁶ (C3's enumeration `sphereZero`, master
`thm:zero-spheres`), the ε-circle in the slice ℂ_v about the enumerated
zero, as a continuous loop in 𝕆 — GPVwind's object γ : [a,b] → 𝕂 ∖ {0}
(Def 4.1/5.11 vocabulary) on the repo's own type. The stem carrier is
SigmaE3's `circleLoop`. -/
def sphereLoop (A : ASection) (n : ℕ) (v : Octonion) (ε : ℝ) :
    C(unitInterval, Octonion) :=
  ⟨fun t => Octonion.sliceEmbed v (circleLoop (A.sphereZero n) ε t), by
    simp only [Octonion.sliceEmbed_eq_smul]
    exact ((Complex.continuous_re.comp (map_continuous _)).smul continuous_const).add
      ((Complex.continuous_im.comp (map_continuous _)).smul continuous_const)⟩

/-- The loop's value, unfolded (definitional pin). -/
theorem sphereLoop_apply (A : ASection) (n : ℕ) (v : Octonion) (ε : ℝ)
    (t : unitInterval) :
    A.sphereLoop n v ε t
      = Octonion.sliceEmbed v (circleLoop (A.sphereZero n) ε t) := rfl

/-- The sphere loop is closed (a loop in GPVwind Def 5.11's sense: the
endpoints agree; the stem carrier's closure is `circleLoop_closed`).
WELD STEP (b). PROVED. -/
theorem sphereLoop_closed (A : ASection) (n : ℕ) (v : Octonion) (ε : ℝ) :
    A.sphereLoop n v ε 0 = A.sphereLoop n v ε 1 := by
  rw [sphereLoop_apply, sphereLoop_apply, circleLoop_closed]

/-- **WELD STEP (b) — the loop encircles the zero-sphere.** The enclosed
slice point φ_v(ρₙ) lies on the sphere locus of `thm:zero-spheres`
(re = σₙ, ‖im‖ = γₙ — "the round sphere of radius γ centred at the real
point σ"), and the loop's slice coordinate circles the enumerated zero at
exact distance ε. PROVED. -/
theorem sphereLoop_encircles (A : ASection) (n : ℕ) {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) {ε : ℝ} (hε : 0 < ε)
    (hlt : ε < (A.sphereZero n).im) :
    (Octonion.re (Octonion.sliceEmbed v (A.sphereZero n)) = (A.sphereZero n).re
      ∧ Octonion.norm (Octonion.im (Octonion.sliceEmbed v (A.sphereZero n)))
          = (A.sphereZero n).im)
    ∧ ∀ t, Octonion.sliceCoord (A.sphereLoop n v ε t)
          = circleLoop (A.sphereZero n) ε t
        ∧ ‖circleLoop (A.sphereZero n) ε t - A.sphereZero n‖ = ε := by
  refine ⟨⟨Octonion.re_sliceEmbed hv _, ?_⟩, fun t => ⟨?_, circleLoop_dist _ hε t⟩⟩
  · rw [Octonion.im_sliceEmbed hv, Octonion.norm_smul_unit hv]
    exact abs_of_pos (A.c3_sphere_nonreal n)
  · rw [sphereLoop_apply, Octonion.sliceCoord_sliceEmbed hv]
    exact Complex.ext rfl (abs_of_pos (circleLoop_im_pos hε hlt t))

/-- **WELD STEP (b) — the obstruction set is EMPTY.** GPVwind Def 5.1
(SOURCES/GPVwind.md, verbatim): "For a path γ : [a,b] → 𝕂 ∖ {0} we define
the set T := γ⁻¹(ℝ) to be the obstruction set (for the lift of γ) and its
points as obstruction parameters." For ε < γₙ the sphere-enclosing loop
never meets ℝ: T = ∅ — no obstruction parameters exist, so Def 5.2's
flip/bounce data is vacuous and Cor 5.13's σ-criterion is never engaged
on the DOMAIN loop. PROVED. -/
theorem sphereLoop_obstruction_empty (A : ASection) (n : ℕ) {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) {ε : ℝ} (hε : 0 < ε)
    (hlt : ε < (A.sphereZero n).im) (t : unitInterval) :
    Octonion.im (A.sphereLoop n v ε t) ≠ 0 := by
  rw [sphereLoop_apply, Octonion.im_sliceEmbed hv]
  intro h
  have h2 := congrArg Octonion.normSq h
  rw [Octonion.normSq_smul, hv.2, mul_one, Octonion.normSq_zero] at h2
  have h3 := circleLoop_im_pos hε hlt t
  have h4 := pow_eq_zero_iff (two_ne_zero) |>.mp h2
  linarith

/-- **WELD STEP (b) — the constant companion field.** Along the whole
sphere-enclosing loop the direction is the ONE unit imaginary v: the
companion of GPVwind Def 4.7 is the constant field t ↦ v (γ(t) ∈ ℂ_v for
every t, witnessed by the loop's own slice form). PROVED. -/
theorem sphereLoop_companion (A : ASection) (n : ℕ) {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) {ε : ℝ} (hε : 0 < ε)
    (hlt : ε < (A.sphereZero n).im) (t : unitInterval) :
    Octonion.dir (A.sphereLoop n v ε t) = v := by
  rw [sphereLoop_apply]
  exact Octonion.dir_sliceEmbed_of_pos hv (circleLoop_im_pos hε hlt t)

/-- **WELD STEP (b) — the loop is TAME (Def 4.7: unique companion).**
Any pointwise companion value w of the sphere-enclosing loop (a slice
membership γ(t) ∈ ℂ_w with w ∈ S⁶) is ±v — one class in 𝕊/{±Id}, the
paper's codomain: the companion is unique, the pair (γ, 𝔍^γ) is a tame
path (GPVwind Def 4.7, SOURCES/GPVwind.md verbatim in
`Octonion.companion_forced`). PROVED. -/
theorem sphereLoop_tame (A : ASection) (n : ℕ) {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) {ε : ℝ} (hε : 0 < ε)
    (hlt : ε < (A.sphereZero n).im) (t : unitInterval) {w : Octonion}
    (hw : w ∈ Octonion.unitImaginarySphere) {ξ : ℂ}
    (hq : A.sphereLoop n v ε t = Octonion.sliceEmbed w ξ) :
    w = v ∨ w = -v := by
  have h := Octonion.companion_forced hw hq
    (A.sphereLoop_obstruction_empty n hv hε hlt t)
  rwa [A.sphereLoop_companion n hv hε hlt t] at h

/-- **WELD STEP (b) — no crossing data on the stem carrier.** GPVwind
Def 5.2's data (one-sided limits of Y/|Y| at obstruction parameters —
flips and bounces) lives on γ⁻¹(ℝ); for the sphere-enclosing loop the
stem carrier stays strictly in the upper half-plane, so SigmaE3's
`CrossingData` type (the Def 5.2 rendering) is EMPTY: no flips occur, no
bounces occur. PROVED. -/
theorem sphereLoop_crossing_isEmpty (A : ASection) (n : ℕ) {ε : ℝ}
    (hε : 0 < ε) (hlt : ε < (A.sphereZero n).im) :
    IsEmpty (CrossingData (circleLoop (A.sphereZero n) ε)) :=
  ⟨fun d => absurd d.obstruction (ne_of_gt (circleLoop_im_pos hε hlt d.t))⟩

/-- **WELD STEP (b) — σᶜ parity: the circular signature is 0, even.**
GPVwind Def 5.19's closing clause (SOURCES/GPVwind.md, verbatim): "If
there are no flips, then we define σ(γ,𝔍) := 0, σᶜ(γ,𝔍) := 0." The
sphere-enclosing loop HAS no flips (its crossing type is empty), so any
flip enumeration is empty (m = 0), the circular signature vanishes, and
Cor 5.21's printed even-hypothesis (FLAGS item 3) holds. PROVED. -/
theorem sphereLoop_sigma_c_zero (A : ASection) (n : ℕ) {ε : ℝ}
    (hε : 0 < ε) (hlt : ε < (A.sphereZero n).im) {m : ℕ}
    (flips : Fin m → CrossingData (circleLoop (A.sphereZero n) ε))
    (signs : Fin m → ℝ) :
    m = 0 ∧ circularSignature signs = 0 ∧ Even m := by
  have hempty := A.sphereLoop_crossing_isEmpty n hε hlt
  have hm : m = 0 := by
    by_contra h
    exact hempty.false (flips ⟨0, Nat.pos_of_ne_zero h⟩)
  subst hm
  refine ⟨rfl, ?_, ⟨0, rfl⟩⟩
  simp [circularSignature]

/-- **WELD STEP (b) — the domain loop's winding is 0 (Cor 5.21 read).**
GPVwind Cor 5.21 (SOURCES/GPVwind.md, verbatim, even-hypothesis included):
"Let γ be a loop and σᶜ(γ) even. Then ω(γ,𝔍) = |σᶜ(γ,𝔍)|/2." For the
sphere-enclosing loop σᶜ = 0 (`sphereLoop_sigma_c_zero`), and indeed its
stem carrier winds 0 about the value-origin — the upper half-plane is
slit-plane material (`stemWinding_eq_zero_of_slitPlane`, SigmaE3). ALL the
winding of the assembly is in the VALUE loop (weld step (d)), none in the
domain loop. PROVED. -/
theorem sphereLoop_domain_winding_zero (A : ASection) (n : ℕ) {ε : ℝ}
    (hε : 0 < ε) (hlt : ε < (A.sphereZero n).im) :
    stemWinding (circleLoop (A.sphereZero n) ε) = 0 := by
  refine stemWinding_eq_zero_of_slitPlane _ (circleLoop_closed _ _) fun t => ?_
  exact Complex.mem_slitPlane_iff.mpr
    (Or.inr (ne_of_gt (circleLoop_im_pos hε hlt t)))

end ASection

/-! ## WELD STEP (c) — the band reading: the kernel is concentric -/

/-- **WELD STEP (c) — one level per fibre, octonionic register.** Master
`lem:exp-degenerate` ("The fibre is thus indexed by the single real level
log r = log|−r|") read on 𝕆: every octonionic point of the degenerate
fibre over −r carries the ONE real part log r. Direct from the PROVED
`Octonion.exp_fibre_neg_real` (Toolkit.lean). PROVED. -/
theorem Octonion.exp_fibre_re {r : ℝ} (hr : 0 < r) {q : Octonion}
    (h : Octonion.exp q = Octonion.ofReal (-r)) :
    Octonion.re q = Real.log r := by
  have hq : q ∈ {q : Octonion | Octonion.exp q = Octonion.ofReal (-r)} := h
  rw [Octonion.exp_fibre_neg_real hr] at hq
  obtain ⟨v, hv, k, rfl⟩ := hq
  exact Octonion.re_sliceEmbed hv _

/-- **WELD STEP (c) — the fibre is CONCENTRIC.** Any two octonionic points
of the one degenerate fibre share their real part: the fibre's spheres
are concentric about the single real centre log r ("the kernel of exp is
concentric", the author, 2026-07-06; `rmk:concentric-gloss` is the
downstream metric gloss). PROVED. -/
theorem Octonion.exp_fibre_concentric {r : ℝ} (hr : 0 < r) {q₁ q₂ : Octonion}
    (h₁ : Octonion.exp q₁ = Octonion.ofReal (-r))
    (h₂ : Octonion.exp q₂ = Octonion.ofReal (-r)) :
    Octonion.re q₁ = Octonion.re q₂ :=
  (Octonion.exp_fibre_re hr h₁).trans (Octonion.exp_fibre_re hr h₂).symm

/-- **WELD STEP (c) — "the kernel of exp is concentric for all imaginary
octonions" (the author, 2026-07-06), as a theorem.** The degenerate fibre
over −1 is EXACTLY the family of concentric spheres (2k+1)π·S⁶ about 0
inside the imaginary octonions — the degenerate structure on the unit
imaginary S⁶: level log 1 = 0 (all fibre points imaginary), all
multiplicity in the odd winding radii. VS Rem 5.2(b) (SOURCES/VS.md,
verbatim): exp "has a non-empty degenerate set consisting of spheres".
PROVED from `Octonion.exp_fibre_neg_real` at r = 1. -/
theorem Octonion.exp_kernel_unit_imaginary (q : Octonion) :
    Octonion.exp q = Octonion.ofReal (-1)
      ↔ ∃ v ∈ Octonion.unitImaginarySphere, ∃ k : ℤ,
          q = (((2 * k + 1 : ℤ) : ℝ) * Real.pi) • v := by
  have hset := Set.ext_iff.mp (Octonion.exp_fibre_neg_real (r := 1) one_pos) q
  simp only [Set.mem_setOf_eq] at hset
  have hpt : ∀ v : Octonion, ∀ k : ℤ,
      Octonion.sliceEmbed v ⟨Real.log 1, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩
        = (((2 * k + 1 : ℤ) : ℝ) * Real.pi) • v := by
    intro v k
    rw [show Octonion.sliceEmbed v ⟨Real.log 1, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩
        = Octonion.ofReal (Real.log 1)
          + (((2 * k + 1 : ℤ) : ℝ) * Real.pi) • v from rfl,
      Real.log_one, show Octonion.ofReal (0 : ℝ) = 0 from by
        rw [Octonion.ofReal_eq_smul_one, zero_smul], zero_add]
  constructor
  · intro hq
    obtain ⟨v, hv, k, hk⟩ := hset.mp hq
    exact ⟨v, hv, k, by rw [hk, hpt]⟩
  · rintro ⟨v, hv, k, rfl⟩
    exact hset.mpr ⟨v, hv, k, (hpt v k).symm⟩

namespace ASection

/-- **WELD STEP (c) — the winding lives on the band S¹ over the level.**
Along the sphere-enclosing loop's VALUE loop, EVERY log-lift closes in the
LEVEL — the real part returns exactly (`winding_loop_defect_level_zero`,
LoopAssembly §A: "all multiplicity in the fibre lies in the winding
direction …, none in the level", master placement paragraph) — and shifts
in the BAND by exactly (fiber tally)·2π (`winding_height_shift`, SigmaE3 —
Cor 5.21's accounting, welded to the enumerated divisor through
`stemWinding_circle_sphereZero`). Level conserved; winding is band data
(master `def:base`: "Winding is band data, never an object label").
PROVED. -/
theorem sphereLoop_value_band (A : ASection) (n : ℕ) :
    ∃ ε₀ > 0, ε₀ < (A.sphereZero n).im ∧ ∀ ε : ℝ, 0 < ε → ε ≤ ε₀ →
      ∃ Γ : C(unitInterval, ℂ),
        (∀ t, Γ t = A.F (circleLoop (A.sphereZero n) ε t)) ∧
        ∀ γ' : C(unitInterval, ℂ), (∀ t, Complex.exp (γ' t) = Γ t) →
          (γ' 1).re = (γ' 0).re ∧
          (γ' 1).im - (γ' 0).im
            = (Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n} : ℝ)
                * (2 * Real.pi) := by
  obtain ⟨ε₀, hε₀, hε₀im, h⟩ := A.stemWinding_circle_sphereZero n
  refine ⟨ε₀, hε₀, hε₀im, fun ε hε hεle => ?_⟩
  obtain ⟨Γ, hΓval, hΓne, hΓloop, hΓwind⟩ := h ε hε hεle
  refine ⟨Γ, hΓval, fun γ' hlift => ?_⟩
  refine ⟨winding_loop_defect_level_zero Γ hΓloop γ' hlift, ?_⟩
  have hshift := winding_height_shift Γ hΓne hΓloop γ' hlift
  rw [hΓwind] at hshift
  rw [hshift]
  push_cast
  ring

end ASection

/-! ## WELD STEP (d) — the touch: the divisor in the winding -/

namespace ASection

/-- **WELD STEP (d) — the realized value loop rides the companion.** The
A-section's realization carries the tame sphere-enclosing loop to the
slice embedding OF THE STEM VALUE LOOP along the SAME companion v — slice
preservation of values, master `def:section-map`(i) ("the value at a point
lies on that point's own slice sphere"): the tame domain data and the
value data share the one slice ℂ_v. PROVED through `realize_coe`
(Slice.lean) and C1's analyticity off the pole. -/
theorem realize_sphereLoop (A : ASection) (n : ℕ) {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) {ε : ℝ} (hε : 0 < ε)
    (hlt : ε < (A.sphereZero n).im) (t : unitInterval) :
    A.realize ((A.sphereLoop n v ε t : Octonion) : OnePoint Octonion)
      = ((Octonion.sliceEmbed v (A.F (circleLoop (A.sphereZero n) ε t)) :
          Octonion) : OnePoint Octonion) := by
  have him : 0 < (circleLoop (A.sphereZero n) ε t).im := circleLoop_im_pos hε hlt t
  have hcoord : Octonion.sliceCoord (A.sphereLoop n v ε t)
      = circleLoop (A.sphereZero n) ε t := by
    rw [sphereLoop_apply, Octonion.sliceCoord_sliceEmbed hv]
    exact Complex.ext rfl (abs_of_pos him)
  have hne : circleLoop (A.sphereZero n) ε t ≠ (A.pole : ℂ) := by
    intro h
    rw [h, Complex.ofReal_im] at him
    exact lt_irrefl 0 him
  have hA : AnalyticAt ℂ A.F (Octonion.sliceCoord (A.sphereLoop n v ε t)) := by
    rw [hcoord]
    exact A.c1_analyticAt _ hne
  rw [realize_coe, if_pos hA, hcoord, sphereLoop_apply,
    Octonion.dir_sliceEmbed_of_pos hv him]

/-- **WELD STEP (d) — the value winding IS the enumerated divisor's
tally.** The realized value loop of the tame sphere-enclosing loop (the
slice embedding of the stem value loop, `realize_sphereLoop`) winds
exactly the fiber tally of the enumerated zero — ≥ 1 ("the winding is
unique and tame and ALREADY TOUCHES THE ℂ-RESIDUES", the author,
2026-07-06). Welds `stemWinding_circle_sphereZero` (SigmaE3 §B, the local
argument principle: the C3 peel, never an integral) to the octonionic
loop. PROVED. -/
theorem sphereLoop_value_winding (A : ASection) (n : ℕ) {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) :
    ∃ ε₀ > 0, ε₀ < (A.sphereZero n).im ∧ ∀ ε : ℝ, 0 < ε → ε ≤ ε₀ →
      ∃ Γ : C(unitInterval, ℂ),
        (∀ t, Γ t = A.F (circleLoop (A.sphereZero n) ε t)) ∧
        (∀ t, A.realize ((A.sphereLoop n v ε t : Octonion) : OnePoint Octonion)
            = ((Octonion.sliceEmbed v (Γ t) : Octonion) : OnePoint Octonion)) ∧
        (∀ t, Γ t ≠ 0) ∧ Γ 0 = Γ 1 ∧
        stemWinding Γ
          = (Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n} : ℤ) ∧
        1 ≤ stemWinding Γ := by
  obtain ⟨ε₀, hε₀, hε₀im, h⟩ := A.stemWinding_circle_sphereZero n
  refine ⟨ε₀, hε₀, hε₀im, fun ε hε hεle => ?_⟩
  obtain ⟨Γ, hΓval, hΓne, hΓloop, hΓwind⟩ := h ε hε hεle
  have hlt : ε < (A.sphereZero n).im := lt_of_le_of_lt hεle hε₀im
  refine ⟨Γ, hΓval, fun t => ?_, hΓne, hΓloop, hΓwind, ?_⟩
  · rw [hΓval t]
    exact A.realize_sphereLoop n hv hε hlt t
  · rw [hΓwind]
    exact_mod_cast A.fiber_tally_pos n

end ASection

/-- **WELD STEP (d) — winding forces a degenerate encounter (the
real-axis obstruction as a theorem).** A closed nonvanishing value-loop
with winding ≥ 1 MUST meet the negative reals: its log-lift's height
climbs by ≥ 2π (`winding_height_shift`), so by IVT it crosses an odd rung
(2k+1)π — and at that parameter the value is −e^{level} (master
`lem:exp-degenerate`'s stem display; the rungs are `lift_height_pi_iff`'s
locus). This is the (a)-difference in action: in the VALUE plane the
direction set is S⁰, and a loop that winds cannot avoid the obstruction
set (GPVwind Def 5.1). PROVED. -/
theorem stemWinding_pos_meets_neg_real (γ : C(unitInterval, ℂ))
    (hγ : ∀ t, γ t ≠ 0) (hloop : γ 0 = γ 1) (hw : 1 ≤ stemWinding γ) :
    ∃ t : unitInterval, ∃ r : ℝ, 0 < r ∧ γ t = -(r : ℂ) := by
  obtain ⟨γ', hlift⟩ := exists_log_continuation γ hγ
  have hshift := winding_height_shift γ hγ hloop γ' hlift
  have hπ : (0 : ℝ) < Real.pi := Real.pi_pos
  set h₀ : ℝ := (γ' 0).im with hh₀
  set j : ℤ := ⌈(h₀ / Real.pi - 1) / 2⌉ with hj
  set y : ℝ := ((2 * j + 1 : ℤ) : ℝ) * Real.pi with hy
  have h₁ : h₀ ≤ y := by
    have h := Int.le_ceil ((h₀ / Real.pi - 1) / 2)
    rw [← hj] at h
    have h' : h₀ / Real.pi ≤ 2 * (j : ℝ) + 1 := by linarith
    have h'' := mul_le_mul_of_nonneg_right h' hπ.le
    rw [div_mul_cancel₀ h₀ hπ.ne'] at h''
    rw [hy]
    push_cast
    linarith
  have h₂ : y ≤ (γ' 1).im := by
    have h := Int.ceil_lt_add_one ((h₀ / Real.pi - 1) / 2)
    rw [← hj] at h
    have h' : 2 * (j : ℝ) + 1 < h₀ / Real.pi + 2 := by linarith
    have h'' := mul_lt_mul_of_pos_right h' hπ
    rw [add_mul (h₀ / Real.pi) 2 Real.pi, div_mul_cancel₀ h₀ hπ.ne'] at h''
    have hcast : (1 : ℝ) ≤ (stemWinding γ : ℝ) := by exact_mod_cast hw
    have h2π : (0 : ℝ) ≤ 2 * Real.pi := by positivity
    have hmul : 1 * (2 * Real.pi) ≤ (stemWinding γ : ℝ) * (2 * Real.pi) :=
      mul_le_mul_of_nonneg_right hcast h2π
    rw [hy]
    push_cast
    linarith
  have hcont : Continuous fun t : unitInterval => (γ' t).im :=
    Complex.continuous_im.comp (map_continuous γ')
  obtain ⟨t, ht⟩ := intermediate_value_univ (0 : unitInterval) 1 hcont ⟨h₁, h₂⟩
  have ht' : (γ' t).im = y := ht
  refine ⟨t, Real.exp ((γ' t).re), Real.exp_pos _, ?_⟩
  rw [← hlift t]
  apply Complex.ext
  · rw [Complex.exp_re, ht', hy, Real.cos_int_mul_pi,
      Odd.neg_one_zpow (⟨j, by ring⟩ : Odd (2 * j + 1)), Complex.neg_re,
      Complex.ofReal_re]
    ring
  · rw [Complex.exp_im, ht', hy, Real.sin_int_mul_pi, mul_zero,
      Complex.neg_im, Complex.ofReal_im, neg_zero]

namespace ASection

/-- **WELD STEP (d) — the tame sphere-loop's value data touches the
degenerate fibre, and the touched fibre carries ONE level.** For every
small radius the tame sphere-enclosing loop's value loop meets some −r
(0 < r < any bound is not claimed — the WINDING forces the encounter,
`stemWinding_pos_meets_neg_real`, the argument-principle route; compare
`neg_reals_swept_near_sphereZero`, LoopAssembly §C, the open-mapping
route), and EVERY octonionic point of the degenerate fibre over that −r
carries the single level log r (`Octonion.exp_fibre_re` — the concentric
reading, weld step (c)). The enumerated divisor (C3/C4) is what makes the
winding ≥ 1: the touch is the divisor's, not a choice. PROVED. -/
theorem sphereLoop_touches_degenerate (A : ASection) (n : ℕ) :
    ∃ ε₀ > 0, ε₀ < (A.sphereZero n).im ∧ ∀ ε : ℝ, 0 < ε → ε ≤ ε₀ →
      ∃ t : unitInterval, ∃ r : ℝ, 0 < r ∧
        A.F (circleLoop (A.sphereZero n) ε t) = -(r : ℂ) ∧
        ∀ q : Octonion, Octonion.exp q = Octonion.ofReal (-r) →
          Octonion.re q = Real.log r := by
  obtain ⟨ε₀, hε₀, hε₀im, h⟩ := A.stemWinding_circle_sphereZero n
  refine ⟨ε₀, hε₀, hε₀im, fun ε hε hεle => ?_⟩
  obtain ⟨Γ, hΓval, hΓne, hΓloop, hΓwind⟩ := h ε hε hεle
  have hw : 1 ≤ stemWinding Γ := by
    rw [hΓwind]
    exact_mod_cast A.fiber_tally_pos n
  obtain ⟨t, r, hr, hΓt⟩ := stemWinding_pos_meets_neg_real Γ hΓne hΓloop hw
  exact ⟨t, r, hr, by rw [← hΓval t]; exact hΓt,
    fun q hq => Octonion.exp_fibre_re hr hq⟩

/-! ## The receipt — the W3 board fed at the target -/

/- **W3 — THE DRIVE** (the limb's target: the repository's one open node,
`ASection.concentricity`, Theorem.lean). Every possession fed below is
PROVED in this file or on the certified board:

(a) THE OCTONIONIC DIFFERENCE — S⁶ connected (a direction path v → −v
    avoiding ℝ, `Octonion.direction_path_to_neg`), S⁰ disconnected
    (`stem_direction_disconnected`);
(b) TAME SPHERE-ENCLOSING LOOPS — empty obstruction set, constant unique
    companion (Def 4.7 tameness), no flips/bounces, σᶜ = 0 even, domain
    winding 0 (`sphereLoop_*` rows);
(c) THE BAND READING — the kernel concentric for all imaginary octonions
    (`exp_kernel_unit_imaginary`, `exp_fibre_concentric`), level closes /
    band shifts tally·2π along the value lift (`sphereLoop_value_band`);
(d) THE TOUCH — the realized value loop rides the companion and winds the
    fiber tally ≥ 1 (`realize_sphereLoop`, `sphereLoop_value_winding`),
    winding forces degenerate encounters at fibres of ONE level
    (`stemWinding_pos_meets_neg_real`, `sphereLoop_touches_degenerate`),
    two zeros' encounters share one value (`shared_ladder_encounters`,
    LoopAssembly §C).

RECEIPT (R6, 2026-07-06): goal at the stop
  ⊢ False
and RESISTS. `exact?` at the seam: could not close the goal. THE PRECISE
MISSING INFERENCE, one sentence: every W3 possession pins VALUE-side data
— the touched levels log r are the levels of the values the loop sweeps
(arbitrarily small r near ANY zero, log r unbounded below), the band
shift counts the divisor, the tame companion is a DOMAIN direction — and
no fed statement identifies a VALUE-side fibre level log r with the
DOMAIN-side transport level Re(sphereZero ·): the identification of the
two registers is `eq:placement-set` itself (Island P, the placement
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
equally tame, its value loops wind its tallies, its encounters touch
one-level fibres — because every proof consumes C1 (the pole), C3's local
peel, and exp's geometry only, never the placement. The GPV clause that
resists transcription on the octonionic register: Cor 5.13's σ ∈ {0,−1}
lift-existence criterion for loops with NONEMPTY obstruction set — its
flip data is one-sided-LIMIT data of the direction field at real
crossings, where `Octonion.dir` has junk value 0 and, by GPVwind Rem 2.1
(SOURCES/GPVwind.md, verbatim: "the function 𝓘 cannot be extended as a
continuous function to any single point of the real axis ℝ of 𝕂"), no
continuous extension exists to carry it; its stem shadow (closure,
`stemWinding_eq_zero_iff`; the crossing ledger, SigmaE3 §C) is already
PROVED and level-blind. The `sorry` is the ROUTE RECEIPT (unimported
artifact; R8), not a queue item. -/
end ASection
