/-
Concentricity/SigmaE3.lean

E3 — THE σ-APPARATUS + ARGUMENT-PRINCIPLE-VIA-WINDING (unimported working
artifact; KeystoneAssembly / GreatCircleRoute / LoopAssembly precedent;
NOT imported by the root — the imported ledger is untouched). The recorded
queued buildout of the `winding_loop_defect` GAP (Toolkit.lean): GPVwind's
σ definition layer rendered on the stem register — where the direction
field is ±i by half-plane — Cor 5.13's closure clause landed as a winding
iff, and the PAYOFF: the argument principle in winding form, WITHOUT
integration. The winding of a closed value-loop is DEFINED by the lift
defect (the proved Toolkit/LoopAssembly rows), is ADDITIVE under pointwise
products (lifts add along `exp`), vanishes on slit-plane loops
(`Complex.log` is the single-valued lift), and the C3 local form
(`stem_local_form`, PlacementSet.lean) then hands every small circle about
an enumerated zero its exact count — the fiber tally, ≥ 1 — and the pole
its −1 (`c1_simple` through `meromorphicOrderAt_eq_int_iff`).

WHAT IS PROVED HERE (all rows on the kernel triple; helpers never sorried,
R8):

§A — the winding engine: `stemWinding` (defect/2πi, total with junk value
0), `stemWinding_spec`/`_eq_of_lift` (every lift computes it),
`stemWinding_eq_zero_iff` (Cor 5.13's closure clause, stem-honest: the
lift closes iff the winding vanishes), `_const`, `_mul` (multiplicativity
— the integration-free argument-principle engine), `_pow`, `_inv`,
`_eq_zero_of_slitPlane`, `_eq_zero_of_near_const` (the Rouché-zero row).

§B — circle contours and the LOCAL ARGUMENT PRINCIPLE: `circleLoop` rows;
`stemWinding_circleLoop_sub_center` (the model loop winds once — explicit
lift `log ε + 2πit`); `ASection.stemWinding_circle_sphereZero` (**every
small circle about `sphereZero n` winds exactly the fiber tally**, via the
C3 peel + multiplicativity + the Rouché-zero row — never an integral);
`ASection.fiber_tally_pos`; `ASection.sigma_level_separation` (**two
distinct levels give a vertical line `Re = β` strictly between them and
contours left and right of it, each winding ≥ 1**).

§C — the σ-apparatus (GPVwind Defs 5.1/5.2/5.7/5.15–5.19, SOURCES/
GPVwind.md, rendered on the stem; every row PROVED): `obstructionSet`,
`stemDirSign`, `CrossingData` + flip/bounce dichotomy, `stemSignature` +
the alternating collapse + **Cor 5.13's {0,−1} auto-pass at positive
crossings**, `intervalSign`, `circularSignature`; the band rows —
`lift_height_pi_iff` (rungs = obstruction set), `arc_band_confined`
(Props 5.5/5.6's conservation, IVT), `crossing_height_odd_of_neg` /
`_even_of_pos` (`lem:exp-degenerate` band parities), `band_side_of_sign` +
`crossing_band_ledger` (Prop 5.8's mechanism: flips step the band, bounces
conserve it), `winding_height_shift` (Cor 5.21's accounting: height shift
= 2π per winding unit).

§D — the divisor counting and the drive: `ASection.stemWinding_circle_pole`
(**the pole circle winds exactly −1**), `ASection.
no_closed_lift_around_sphereZero` (the obstruction reading — Cor 5.13's
criterion FAILS at every zero circle), and the drive
`ASection.concentricity_via_sigma`.

THE RECEIPT (the file's ONE `sorry`, R6/R8 — the exact resisting goal):
`concentricity_via_sigma` at `⊢ False` with the complete board fed; see
its docstring for the seam record, the `exact?` verdict, and the litmus
consistency note. The imported root ledger is untouched.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.LoopAssembly
import Mathlib.Data.Real.Sign

noncomputable section

open Complex

/-! ## §A — the winding engine (Cor 5.13's closure clause, stem-honest) -/

open scoped Classical in
/-- **The winding number of a closed nonvanishing stem loop** — DEFINED by
the lift defect: the unique `k : ℤ` with `γ' 1 − γ' 0 = k·2πi` for any
log-continuation `γ'` (`winding_loop_defect`, Toolkit.lean — proved;
lift-independence is `winding_defect_lift_independent`, LoopAssembly §A —
proved). Total with junk value 0 off the loop hypotheses (the realize-style
junk-robust convention). This is the ω of GPVwind Cor 5.21 on the stem. -/
def stemWinding (γ : C(unitInterval, ℂ)) : ℤ :=
  if h : (∀ t, γ t ≠ 0) ∧ γ 0 = γ 1 then
    (winding_loop_defect γ h.2 (exists_log_continuation γ h.1).choose
      (exists_log_continuation γ h.1).choose_spec).choose
  else 0

/-- Spec: every lift's defect is `2πi` times the winding. -/
theorem stemWinding_spec (γ : C(unitInterval, ℂ)) (hγ : ∀ t, γ t ≠ 0)
    (hloop : γ 0 = γ 1) (γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) :
    γ' 1 - γ' 0 = (stemWinding γ : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) := by
  rw [stemWinding, dif_pos ⟨hγ, hloop⟩]
  have hch := (exists_log_continuation γ hγ).choose_spec
  have hdef := winding_defect_lift_independent γ hγ γ'
    (exists_log_continuation γ hγ).choose hlift hch
  rw [hdef]
  exact (winding_loop_defect γ hloop _ hch).choose_spec

/-- Uniqueness: any lift's integer defect computes the winding. -/
theorem stemWinding_eq_of_lift (γ : C(unitInterval, ℂ)) (hγ : ∀ t, γ t ≠ 0)
    (hloop : γ 0 = γ 1) (γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) (k : ℤ)
    (hk : γ' 1 - γ' 0 = (k : ℂ) * (2 * (Real.pi : ℂ) * Complex.I)) :
    stemWinding γ = k := by
  have h := stemWinding_spec γ hγ hloop γ' hlift
  rw [hk] at h
  have hc : (2 * (Real.pi : ℂ) * Complex.I) ≠ 0 := by
    simp [Real.pi_ne_zero, Complex.I_ne_zero]
  have h2 : (k : ℂ) = (stemWinding γ : ℂ) := mul_right_cancel₀ hc h
  exact_mod_cast h2.symm

/-- **Cor 5.13's closure clause, stem-honest iff** (GPVwind Cor 5.13,
SOURCES/GPVwind.md, verbatim: "Then a lift of γ in 𝓔⁺_𝕂 exists if and only
if σ(γ|_{[ξ_l,ξ_{l+1}]}) ∈ {0,−1} for each l = 1,…,m−1. If it exists, the
lift is a loop."). On the stem the continuation over the cover ALWAYS
exists (`exists_log_continuation`); the criterion's honest stem content is
therefore the CLOSURE face: a closed lift exists iff the winding vanishes.
DERIVED (R10) — the octonionic σ-criterion itself (WHICH loops lift) stays
on the direction field with no stem carrier (Rem 2.1; the recorded GAP of
`winding_loop_defect`). -/
theorem stemWinding_eq_zero_iff (γ : C(unitInterval, ℂ)) (hγ : ∀ t, γ t ≠ 0)
    (hloop : γ 0 = γ 1) :
    stemWinding γ = 0 ↔
      ∃ γ' : C(unitInterval, ℂ), (∀ t, Complex.exp (γ' t) = γ t) ∧ γ' 1 = γ' 0 := by
  constructor
  · intro h0
    obtain ⟨γ', hlift⟩ := exists_log_continuation γ hγ
    refine ⟨γ', hlift, ?_⟩
    have h := stemWinding_spec γ hγ hloop γ' hlift
    rw [h0] at h
    push_cast at h
    rw [zero_mul] at h
    exact sub_eq_zero.mp h
  · rintro ⟨γ', hlift, hclose⟩
    refine stemWinding_eq_of_lift γ hγ hloop γ' hlift 0 ?_
    rw [hclose]
    push_cast
    ring

/-- Constant loops wind zero. -/
theorem stemWinding_const (c : ℂ) (hc : c ≠ 0) :
    stemWinding (ContinuousMap.const unitInterval c) = 0 := by
  refine stemWinding_eq_of_lift _ (fun _ => hc) rfl
    (ContinuousMap.const unitInterval (Complex.log c))
    (fun t => by
      rw [ContinuousMap.const_apply, ContinuousMap.const_apply]
      exact Complex.exp_log hc) 0 ?_
  push_cast
  simp

/-- **Multiplicativity — the integration-free argument-principle engine**:
windings add along the pointwise product of loops, because lifts ADD along
`exp` (`exp (w₁+w₂) = exp w₁ · exp w₂`). Every counting row of §B/§D rides
this row; no contour integral is ever taken. -/
theorem stemWinding_mul (γ₁ γ₂ : C(unitInterval, ℂ))
    (h₁ : ∀ t, γ₁ t ≠ 0) (h₂ : ∀ t, γ₂ t ≠ 0)
    (hl₁ : γ₁ 0 = γ₁ 1) (hl₂ : γ₂ 0 = γ₂ 1) :
    stemWinding (γ₁ * γ₂) = stemWinding γ₁ + stemWinding γ₂ := by
  obtain ⟨γ₁', hγ₁'⟩ := exists_log_continuation γ₁ h₁
  obtain ⟨γ₂', hγ₂'⟩ := exists_log_continuation γ₂ h₂
  have hne : ∀ t, (γ₁ * γ₂) t ≠ 0 := fun t => by
    rw [ContinuousMap.mul_apply]
    exact mul_ne_zero (h₁ t) (h₂ t)
  have hloop : (γ₁ * γ₂) 0 = (γ₁ * γ₂) 1 := by
    rw [ContinuousMap.mul_apply, ContinuousMap.mul_apply, hl₁, hl₂]
  have hsum : ∀ t, Complex.exp ((γ₁' + γ₂') t) = (γ₁ * γ₂) t := fun t => by
    rw [ContinuousMap.add_apply, Complex.exp_add, hγ₁' t, hγ₂' t,
      ContinuousMap.mul_apply]
  have hd₁ := stemWinding_spec γ₁ h₁ hl₁ γ₁' hγ₁'
  have hd₂ := stemWinding_spec γ₂ h₂ hl₂ γ₂' hγ₂'
  refine stemWinding_eq_of_lift _ hne hloop (γ₁' + γ₂') hsum _ ?_
  rw [ContinuousMap.add_apply, ContinuousMap.add_apply]
  push_cast
  linear_combination hd₁ + hd₂

/-- Powers: winding is `N`-linear along loop powers. -/
theorem stemWinding_pow (γ : C(unitInterval, ℂ)) (hγ : ∀ t, γ t ≠ 0)
    (hloop : γ 0 = γ 1) (N : ℕ) :
    stemWinding (γ ^ N) = N * stemWinding γ := by
  induction N with
  | zero =>
    have h : (γ ^ 0 : C(unitInterval, ℂ)) = ContinuousMap.const unitInterval 1 := by
      ext t
      rw [ContinuousMap.pow_apply, pow_zero, ContinuousMap.const_apply]
    rw [h, stemWinding_const 1 one_ne_zero]
    ring
  | succ n ih =>
    have h : (γ ^ (n + 1) : C(unitInterval, ℂ)) = γ ^ n * γ := pow_succ γ n
    have hn : ∀ t, (γ ^ n : C(unitInterval, ℂ)) t ≠ 0 := fun t => by
      rw [ContinuousMap.pow_apply]
      exact pow_ne_zero n (hγ t)
    have hnl : (γ ^ n : C(unitInterval, ℂ)) 0 = (γ ^ n) 1 := by
      rw [ContinuousMap.pow_apply, ContinuousMap.pow_apply, hloop]
    rw [h, stemWinding_mul (γ ^ n) γ hn hγ hnl hloop, ih]
    push_cast
    ring

/-- Inverses: winding negates along the pointwise inverse loop. -/
theorem stemWinding_inv (γ : C(unitInterval, ℂ)) (hγ : ∀ t, γ t ≠ 0)
    (hloop : γ 0 = γ 1) (δ : C(unitInterval, ℂ)) (hδ : ∀ t, δ t = (γ t)⁻¹) :
    stemWinding δ = -stemWinding γ := by
  have hδne : ∀ t, δ t ≠ 0 := fun t => by
    rw [hδ t]
    exact inv_ne_zero (hγ t)
  have hδloop : δ 0 = δ 1 := by rw [hδ 0, hδ 1, hloop]
  have hprod : γ * δ = ContinuousMap.const unitInterval 1 := by
    ext t
    rw [ContinuousMap.mul_apply, hδ t, ContinuousMap.const_apply,
      mul_inv_cancel₀ (hγ t)]
  have h := stemWinding_mul γ δ hγ hδne hloop hδloop
  rw [hprod, stemWinding_const 1 one_ne_zero] at h
  omega

/-- Slit-plane loops wind zero: `Complex.log` is the single-valued lift. -/
theorem stemWinding_eq_zero_of_slitPlane (γ : C(unitInterval, ℂ))
    (hloop : γ 0 = γ 1) (hs : ∀ t, γ t ∈ Complex.slitPlane) :
    stemWinding γ = 0 := by
  have hγ : ∀ t, γ t ≠ 0 := fun t => Complex.slitPlane_ne_zero (hs t)
  have hcont : Continuous fun t => Complex.log (γ t) :=
    continuous_iff_continuousAt.mpr fun t =>
      (continuousAt_clog (hs t)).comp (map_continuous γ).continuousAt
  refine stemWinding_eq_of_lift γ hγ hloop ⟨fun t => Complex.log (γ t), hcont⟩
    (fun t => Complex.exp_log (hγ t)) 0 ?_
  show Complex.log (γ 1) - Complex.log (γ 0) = _
  rw [← hloop]
  push_cast
  ring

/-- The Rouché-zero row: a loop staying within `‖w‖` of a nonzero `w`
winds zero. -/
theorem stemWinding_eq_zero_of_near_const (γ : C(unitInterval, ℂ))
    (hloop : γ 0 = γ 1) {w : ℂ} (hw : w ≠ 0)
    (hnear : ∀ t, ‖γ t - w‖ < ‖w‖) : stemWinding γ = 0 := by
  have hδcont : Continuous fun t => γ t / w := (map_continuous γ).div_const w
  set δ : C(unitInterval, ℂ) := ⟨fun t => γ t / w, hδcont⟩ with hδ_def
  have hδslit : ∀ t, δ t ∈ Complex.slitPlane := fun t => by
    have h1 : δ t = 1 + (γ t - w) / w := by
      show γ t / w = 1 + (γ t - w) / w
      rw [← div_self hw, ← add_div]
      congr 1
      ring
    rw [h1]
    refine Complex.mem_slitPlane_of_norm_lt_one ?_
    rw [norm_div]
    exact (div_lt_one (norm_pos_iff.mpr hw)).mpr (hnear t)
  have hδloop : δ 0 = δ 1 := by
    show γ 0 / w = γ 1 / w
    rw [hloop]
  have hδwind : stemWinding δ = 0 := stemWinding_eq_zero_of_slitPlane δ hδloop hδslit
  have hγeq : γ = ContinuousMap.const unitInterval w * δ := by
    ext t
    rw [ContinuousMap.mul_apply, ContinuousMap.const_apply]
    show γ t = w * (γ t / w)
    rw [mul_comm]
    exact (div_mul_cancel₀ (γ t) hw).symm
  have hδne : ∀ t, δ t ≠ 0 := fun t => Complex.slitPlane_ne_zero (hδslit t)
  rw [hγeq, stemWinding_mul _ δ (fun _ => hw) hδne rfl hδloop,
    stemWinding_const w hw, hδwind]
  norm_num

/-! ## §B — circle contours and the local argument principle -/

/-- The standard positively-oriented circle contour about `c` of radius `ε`. -/
def circleLoop (c : ℂ) (ε : ℝ) : C(unitInterval, ℂ) :=
  ⟨fun t => c + (ε : ℂ) * Complex.exp (2 * Real.pi * Complex.I * ((t : ℝ) : ℂ)),
    by fun_prop⟩

theorem circleLoop_apply (c : ℂ) (ε : ℝ) (t : unitInterval) :
    circleLoop c ε t = c + (ε : ℂ) * Complex.exp (2 * Real.pi * Complex.I * ((t : ℝ) : ℂ)) :=
  rfl

theorem circleLoop_closed (c : ℂ) (ε : ℝ) : circleLoop c ε 0 = circleLoop c ε 1 := by
  rw [circleLoop_apply, circleLoop_apply]
  norm_num

/-- Circle points sit at exact distance `ε` from the centre. -/
theorem circleLoop_dist (c : ℂ) {ε : ℝ} (hε : 0 < ε) (t : unitInterval) :
    ‖circleLoop c ε t - c‖ = ε := by
  rw [circleLoop_apply, add_sub_cancel_left, norm_mul, Complex.norm_exp]
  have hre : (2 * Real.pi * Complex.I * ((t : ℝ) : ℂ)).re = 0 := by
    simp [Complex.mul_re, Complex.mul_im]
  rw [hre, Real.exp_zero, mul_one, Complex.norm_real, Real.norm_eq_abs,
    abs_of_pos hε]

/-- The centred model loop `t ↦ ε e^{2πit}` winds once: the explicit lift
is `t ↦ log ε + 2πit`. -/
theorem stemWinding_circleLoop_sub_center (c : ℂ) {ε : ℝ} (hε : 0 < ε)
    (δ : C(unitInterval, ℂ)) (hδ : ∀ t, δ t = circleLoop c ε t - c) :
    stemWinding δ = 1 := by
  have hδval : ∀ t, δ t = (ε : ℂ) * Complex.exp (2 * Real.pi * Complex.I * ((t : ℝ) : ℂ)) := by
    intro t
    rw [hδ t, circleLoop_apply, add_sub_cancel_left]
  have hδne : ∀ t, δ t ≠ 0 := fun t => by
    rw [hδval t]
    exact mul_ne_zero (by exact_mod_cast hε.ne') (Complex.exp_ne_zero _)
  have hδloop : δ 0 = δ 1 := by
    rw [hδ 0, hδ 1, circleLoop_closed]
  have hcont : Continuous fun t : unitInterval =>
      (Real.log ε : ℂ) + 2 * Real.pi * Complex.I * ((t : ℝ) : ℂ) := by fun_prop
  refine stemWinding_eq_of_lift δ hδne hδloop ⟨_, hcont⟩ (fun t => ?_) 1 ?_
  · show Complex.exp ((Real.log ε : ℂ) + 2 * Real.pi * Complex.I * ((t : ℝ) : ℂ)) = δ t
    rw [Complex.exp_add, hδval t]
    congr 1
    rw [← Complex.ofReal_exp, Real.exp_log hε]
  · change (Real.log ε : ℂ) + 2 * Real.pi * Complex.I * (((1 : unitInterval) : ℝ) : ℂ)
        - ((Real.log ε : ℂ) + 2 * Real.pi * Complex.I * (((0 : unitInterval) : ℝ) : ℂ)) = _
    norm_num

/-- Circle points stay in the open upper half-plane when `ε < im c`. -/
theorem circleLoop_im_pos {c : ℂ} {ε : ℝ} (hε : 0 < ε) (hlt : ε < c.im)
    (t : unitInterval) : 0 < (circleLoop c ε t).im := by
  have h1 : |(circleLoop c ε t - c).im| ≤ ‖circleLoop c ε t - c‖ :=
    Complex.abs_im_le_norm _
  rw [circleLoop_dist c hε t] at h1
  have h2 : (circleLoop c ε t - c).im = (circleLoop c ε t).im - c.im := by
    rw [Complex.sub_im]
  rw [h2] at h1
  have := abs_le.mp h1
  linarith [this.1]

namespace ASection

/-- The section is continuous along any circle avoiding the pole. -/
theorem continuous_F_circleLoop (A : ASection) {c : ℂ} {ε : ℝ}
    (havoid : ∀ t, circleLoop c ε t ≠ (A.pole : ℂ)) :
    Continuous fun t : unitInterval => A.F (circleLoop c ε t) :=
  continuous_iff_continuousAt.mpr fun t =>
    ((A.c1_analyticAt _ (havoid t)).continuousAt).comp
      (map_continuous (circleLoop c ε)).continuousAt

/-- The fiber tally at an enumerated zero is positive. -/
theorem fiber_tally_pos (A : ASection) (n : ℕ) :
    0 < Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n} := by
  have hfin : {k : ℕ | A.sphereZero k = A.sphereZero n}.Finite :=
    A.sphereZero_fiber_finite n
  have : Finite {k : ℕ | A.sphereZero k = A.sphereZero n} := hfin.to_subtype
  have : Nonempty {k : ℕ | A.sphereZero k = A.sphereZero n} :=
    ⟨⟨n, rfl⟩⟩
  exact Nat.card_pos

/-- **The local argument principle at an enumerated zero, PROVED**: along
every sufficiently small circle about `sphereZero n` the value-loop of the
stem winds exactly the fiber tally — in particular at least once. Route:
the C3 peel `stem_local_form` (PlacementSet.lean: `F = (z−ρ)^N·G` near ρ,
`G` analytic nonvanishing at ρ) + `stemWinding_mul`/`_pow` + the model row
(the centred factor winds once per power) + the Rouché-zero row on the
unit factor (`G` stays within `‖G ρ‖` of `G ρ` on a small circle). The
divisor enters a winding possession here — output of C3, never input
(R4). -/
theorem stemWinding_circle_sphereZero (A : ASection) (n : ℕ) :
    ∃ ε₀ > 0, ε₀ < (A.sphereZero n).im ∧ ∀ ε : ℝ, 0 < ε → ε ≤ ε₀ →
      ∃ Γ : C(unitInterval, ℂ),
        (∀ t, Γ t = A.F (circleLoop (A.sphereZero n) ε t)) ∧
        (∀ t, Γ t ≠ 0) ∧ Γ 0 = Γ 1 ∧
        stemWinding Γ
          = (Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n} : ℤ) := by
  set ρ : ℂ := A.sphereZero n with hρ_def
  set N : ℕ := Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n} with hN_def
  have him : 0 < ρ.im := A.c3_sphere_nonreal n
  obtain ⟨G, hGa, hGne, hev⟩ := A.stem_local_form n
  obtain ⟨r₁, hr₁pos, hr₁⟩ := Metric.eventually_nhds_iff.mp hev
  obtain ⟨r₂, hr₂pos, hr₂⟩ :=
    Metric.continuousAt_iff.mp hGa.continuousAt ‖G ρ‖ (norm_pos_iff.mpr hGne)
  refine ⟨min (min r₁ r₂) ρ.im / 2, by positivity, ?_, ?_⟩
  · have h1 : min (min r₁ r₂) ρ.im ≤ ρ.im := min_le_right _ _
    linarith
  intro ε hε hεle
  have hεr₁ : ε < r₁ := by
    have h1 : min (min r₁ r₂) ρ.im ≤ min r₁ r₂ := min_le_left _ _
    have h2 : min r₁ r₂ ≤ r₁ := min_le_left _ _
    linarith
  have hεr₂ : ε < r₂ := by
    have h1 : min (min r₁ r₂) ρ.im ≤ min r₁ r₂ := min_le_left _ _
    have h2 : min r₁ r₂ ≤ r₂ := min_le_right _ _
    linarith
  have hεim : ε < ρ.im := by
    have h1 : min (min r₁ r₂) ρ.im ≤ ρ.im := min_le_right _ _
    linarith
  -- the circle avoids the pole (upper half-plane vs the real pole)
  have hupper : ∀ t, 0 < (circleLoop ρ ε t).im := circleLoop_im_pos hε hεim
  have havoid : ∀ t, circleLoop ρ ε t ≠ (A.pole : ℂ) := fun t h => by
    have := hupper t
    rw [h, Complex.ofReal_im] at this
    exact lt_irrefl 0 this
  -- the circle sits inside both radii
  have hdist : ∀ t, dist (circleLoop ρ ε t) ρ = ε := fun t => by
    rw [dist_eq_norm]
    exact circleLoop_dist ρ hε t
  have hfac : ∀ t, A.F (circleLoop ρ ε t)
      = (circleLoop ρ ε t - ρ) ^ N * G (circleLoop ρ ε t) := fun t =>
    hr₁ (by rw [hdist t]; exact hεr₁)
  have hGnear : ∀ t, dist (G (circleLoop ρ ε t)) (G ρ) < ‖G ρ‖ := fun t =>
    hr₂ (by rw [hdist t]; exact hεr₂)
  have hGcirc_ne : ∀ t, G (circleLoop ρ ε t) ≠ 0 := fun t h => by
    have := hGnear t
    rw [h, dist_zero_left] at this
    exact lt_irrefl _ this
  -- the bundled value-loop
  set Γ : C(unitInterval, ℂ) :=
    ⟨fun t => A.F (circleLoop ρ ε t), A.continuous_F_circleLoop havoid⟩ with hΓ_def
  have hΓval : ∀ t, Γ t = A.F (circleLoop ρ ε t) := fun t => rfl
  -- the centred factor loop and its power
  set δ : C(unitInterval, ℂ) :=
    ⟨fun t => circleLoop ρ ε t - ρ, (map_continuous _).sub continuous_const⟩
    with hδ_def
  have hδval : ∀ t, δ t = circleLoop ρ ε t - ρ := fun t => rfl
  have hδne : ∀ t, δ t ≠ 0 := fun t => by
    intro h
    have h2 := circleLoop_dist ρ hε t
    rw [hδval t] at h
    rw [h, norm_zero] at h2
    exact hε.ne h2
  have hδloop : δ 0 = δ 1 := by
    rw [hδval 0, hδval 1, circleLoop_closed]
  have hδwind : stemWinding δ = 1 :=
    stemWinding_circleLoop_sub_center ρ hε δ hδval
  -- the unit factor loop (the quotient bundle)
  have hδpow_ne : ∀ t, (δ ^ N : C(unitInterval, ℂ)) t ≠ 0 := fun t => by
    rw [ContinuousMap.pow_apply]
    exact pow_ne_zero N (hδne t)
  set Gc : C(unitInterval, ℂ) :=
    ⟨fun t => Γ t / (δ t) ^ N,
      (map_continuous Γ).div ((map_continuous δ).pow N)
        (fun t => pow_ne_zero N (hδne t))⟩ with hGc_def
  have hGcval : ∀ t, Gc t = G (circleLoop ρ ε t) := fun t => by
    change Γ t / (δ t) ^ N = G (circleLoop ρ ε t)
    rw [hΓval t, hfac t, hδval t]
    exact mul_div_cancel_left₀ _ (pow_ne_zero N (sub_ne_zero.mpr (fun h => by
      have h2 := circleLoop_dist ρ hε t
      rw [h, sub_self, norm_zero] at h2
      exact hε.ne h2)))
  have hGcne : ∀ t, Gc t ≠ 0 := fun t => by
    rw [hGcval t]
    exact hGcirc_ne t
  have hGcloop : Gc 0 = Gc 1 := by
    rw [hGcval 0, hGcval 1, circleLoop_closed]
  have hGcwind : stemWinding Gc = 0 := by
    refine stemWinding_eq_zero_of_near_const Gc hGcloop hGne (fun t => ?_)
    rw [hGcval t, ← dist_eq_norm]
    exact hGnear t
  -- the factorization at the level of loops
  have hΓfac : Γ = δ ^ N * Gc := by
    ext t
    rw [ContinuousMap.mul_apply, ContinuousMap.pow_apply]
    change Γ t = (δ t) ^ N * (Γ t / (δ t) ^ N)
    rw [mul_comm]
    exact (div_mul_cancel₀ (Γ t) (pow_ne_zero N (hδne t))).symm
  have hΓne : ∀ t, Γ t ≠ 0 := fun t => by
    rw [hΓval t, hfac t]
    exact mul_ne_zero (pow_ne_zero N (fun h => hδne t (by rw [hδval t]; exact h)))
      (hGcirc_ne t)
  have hΓloop : Γ 0 = Γ 1 := by
    rw [hΓval 0, hΓval 1, circleLoop_closed]
  have hδpow_loop : (δ ^ N : C(unitInterval, ℂ)) 0 = (δ ^ N) 1 := by
    rw [ContinuousMap.pow_apply, ContinuousMap.pow_apply, hδloop]
  refine ⟨Γ, hΓval, hΓne, hΓloop, ?_⟩
  rw [hΓfac, stemWinding_mul _ _ hδpow_ne hGcne hδpow_loop hGcloop,
    stemWinding_pow δ hδne hδloop N, hδwind, hGcwind]
  ring

end ASection

namespace ASection

/-- **Level separation, PROVED**: two enumerated zeros at distinct levels
admit a vertical line `Re = β` strictly between them and a common radius
`ε` whose circles stay strictly left resp. right of the line while the
value-loops wind at least once around `0` on each side. -/
theorem sigma_level_separation (A : ASection) {n m : ℕ}
    (hsep : (A.sphereZero n).re < (A.sphereZero m).re) :
    ∃ β : ℝ, (A.sphereZero n).re < β ∧ β < (A.sphereZero m).re ∧
      ∃ ε > 0,
        (∀ t, (circleLoop (A.sphereZero n) ε t).re < β) ∧
        (∀ t, β < (circleLoop (A.sphereZero m) ε t).re) ∧
        ∃ Γn Γm : C(unitInterval, ℂ),
          (∀ t, Γn t = A.F (circleLoop (A.sphereZero n) ε t)) ∧
          (∀ t, Γm t = A.F (circleLoop (A.sphereZero m) ε t)) ∧
          (∀ t, Γn t ≠ 0) ∧ (∀ t, Γm t ≠ 0) ∧
          1 ≤ stemWinding Γn ∧ 1 ≤ stemWinding Γm := by
  obtain ⟨εn, hεnpos, hεnim, hn⟩ := A.stemWinding_circle_sphereZero n
  obtain ⟨εm, hεmpos, hεmim, hm⟩ := A.stemWinding_circle_sphereZero m
  set gap : ℝ := (A.sphereZero m).re - (A.sphereZero n).re with hgap_def
  have hgap : 0 < gap := sub_pos.mpr hsep
  set β : ℝ := ((A.sphereZero n).re + (A.sphereZero m).re) / 2 with hβ_def
  set ε : ℝ := min (min εn εm) (gap / 2) / 2 with hε_def
  have hεpos : 0 < ε := by positivity
  have hεn : ε ≤ εn := by
    have h1 : min (min εn εm) (gap / 2) ≤ min εn εm := min_le_left _ _
    have h2 : min εn εm ≤ εn := min_le_left _ _
    have h3 : 0 < min (min εn εm) (gap / 2) := by positivity
    rw [hε_def]
    linarith
  have hεm : ε ≤ εm := by
    have h1 : min (min εn εm) (gap / 2) ≤ min εn εm := min_le_left _ _
    have h2 : min εn εm ≤ εm := min_le_right _ _
    have h3 : 0 < min (min εn εm) (gap / 2) := by positivity
    rw [hε_def]
    linarith
  have hεgap : ε < gap / 2 := by
    have h1 : min (min εn εm) (gap / 2) ≤ gap / 2 := min_le_right _ _
    have h3 : 0 < min (min εn εm) (gap / 2) := by positivity
    rw [hε_def]
    linarith
  refine ⟨β, by rw [hβ_def]; linarith, by rw [hβ_def]; linarith, ε, hεpos,
    ?_, ?_, ?_⟩
  · intro t
    have h1 : |(circleLoop (A.sphereZero n) ε t - A.sphereZero n).re|
        ≤ ‖circleLoop (A.sphereZero n) ε t - A.sphereZero n‖ :=
      Complex.abs_re_le_norm _
    rw [circleLoop_dist _ hεpos t, Complex.sub_re] at h1
    have h2 := (abs_le.mp h1).2
    rw [hβ_def]
    have := hεgap
    rw [hgap_def] at this
    linarith
  · intro t
    have h1 : |(circleLoop (A.sphereZero m) ε t - A.sphereZero m).re|
        ≤ ‖circleLoop (A.sphereZero m) ε t - A.sphereZero m‖ :=
      Complex.abs_re_le_norm _
    rw [circleLoop_dist _ hεpos t, Complex.sub_re] at h1
    have h2 := (abs_le.mp h1).1
    rw [hβ_def]
    have := hεgap
    rw [hgap_def] at this
    linarith
  · obtain ⟨Γn, hΓnval, hΓnne, -, hΓnwind⟩ := hn ε hεpos hεn
    obtain ⟨Γm, hΓmval, hΓmne, -, hΓmwind⟩ := hm ε hεpos hεm
    refine ⟨Γn, Γm, hΓnval, hΓmval, hΓnne, hΓmne, ?_, ?_⟩
    · rw [hΓnwind]
      exact_mod_cast A.fiber_tally_pos n
    · rw [hΓmwind]
      exact_mod_cast A.fiber_tally_pos m

end ASection

/-! ## §C — the σ-apparatus on the stem register (GPVwind Defs 5.1/5.2/5.7/5.15–5.19) -/

/-- GPVwind Def 5.1 (SOURCES/GPVwind.md, verbatim): "For a path
γ : [a,b] → 𝕂∖{0} we define the set T := γ⁻¹(ℝ) to be the obstruction set
(for the lift of γ) and its points as obstruction parameters." Stem
register (DERIVED, R10): ℝ ⊂ ℂ is the `im = 0` locus. -/
def obstructionSet (γ : C(unitInterval, ℂ)) : Set unitInterval :=
  {t | (γ t).im = 0}

/-- The stem direction sign — the ±1 carrier of Def 5.2's unit field: on
the slice ℂ the decomposition γ(t) = x(t) + Y(t) has Y(t) = (im γ t)·i, so
the field Y/|Y| of GPVwind (5.4) is sign(im γ t)·i ∈ {±i}. DERIVED (R10);
GPVwind Rem 2.1 (verbatim: "the function 𝓘 cannot be extended as a
continuous function to any single point of the real axis ℝ of 𝕂") is why
the direction data below is one-sided. -/
def stemDirSign (γ : C(unitInterval, ℂ)) (t : unitInterval) : ℝ :=
  Real.sign ((γ t).im)

/-- GPVwind Def 5.2 rendering (SOURCES/GPVwind.md, verbatim clauses): "Let
the path γ(t) = x(t) + Y(t) : [a,b] → ℍ∖{0} be such that
T = γ⁻¹(ℝ) = {a ≤ t₁ < … < t_p ≤ b}. Consider the limits (5.4)
lim_{t→t_s^±} Y(t)/|Y(t)|. … 1) γ is tame at t_s if both limits are either
equal or opposite. In particular, if these limits are opposite, then the
parameter t_s is called a flip, whereas if they are the same it is called
a bounce". Stem register (DERIVED, R10): an obstruction parameter with its
one-sided direction data — the one-sided limits of `Y/|Y| = sign(im γ)·i`,
carried by eventual sign constancy (the target `{±i}` is discrete, so
convergence IS eventual equality on a punctured one-sided
neighbourhood). -/
structure CrossingData (γ : C(unitInterval, ℂ)) where
  t : unitInterval
  obstruction : (γ t).im = 0
  sLeft : ℝ
  sRight : ℝ
  sLeft_unit : sLeft = 1 ∨ sLeft = -1
  sRight_unit : sRight = 1 ∨ sRight = -1
  eventually_left : ∀ᶠ u in nhdsWithin t (Set.Iio t), Real.sign ((γ u).im) = sLeft
  eventually_right : ∀ᶠ u in nhdsWithin t (Set.Ioi t), Real.sign ((γ u).im) = sRight

namespace CrossingData

variable {γ : C(unitInterval, ℂ)}

/-- Def 5.2, flip (verbatim: "if these limits are opposite, then the
parameter t_s is called a flip"). -/
def IsFlip (d : CrossingData γ) : Prop := d.sRight = -d.sLeft

/-- Def 5.2, bounce (verbatim: "whereas if they are the same it is called
a bounce"). -/
def IsBounce (d : CrossingData γ) : Prop := d.sRight = d.sLeft

/-- Def 5.2's tame dichotomy on the stem: every crossing datum is a flip
or a bounce. -/
theorem flip_or_bounce (d : CrossingData γ) : d.IsFlip ∨ d.IsBounce := by
  rcases d.sLeft_unit with h1 | h1 <;> rcases d.sRight_unit with h2 | h2 <;>
    simp [IsFlip, IsBounce, h1, h2]

/-- Flip and bounce are exclusive. -/
theorem not_flip_and_bounce (d : CrossingData γ) : ¬(d.IsFlip ∧ d.IsBounce) := by
  rintro ⟨h1, h2⟩
  rw [IsFlip] at h1
  rw [IsBounce] at h2
  rcases d.sLeft_unit with h | h <;> rw [h] at h1 h2 <;> rw [h1] at h2 <;>
    norm_num at h2

end CrossingData

/-- The alternating sum engine of Defs 5.7/5.19. -/
theorem sum_range_neg_one_pow_succ (m : ℕ) :
    ∑ l ∈ Finset.range m, (-1 : ℝ) ^ (l + 1) = if Even m then 0 else -1 := by
  induction m with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ, ih]
    rcases Nat.even_or_odd k with hk | hk
    · rw [if_pos hk, if_neg (by rw [Nat.not_even_iff_odd]; exact hk.add_one),
        pow_succ, hk.neg_one_pow]
      ring
    · rw [if_neg (by rw [Nat.not_even_iff_odd]; exact hk), if_pos hk.add_one,
        pow_succ, hk.neg_one_pow]
      ring

/-- GPVwind Def 5.7 (SOURCES/GPVwind.md, verbatim): "Let
γ : [a,b] → 𝕂∖{0} be a given path with γ⁻¹(ℝ) = {a ≤ t₁ < … < t_p ≤ b},
with points of γ⁻¹(ℝ) ∩ (a,b) all tame. Let a < ξ₁ < … < ξ_m < b be those
parameters in γ⁻¹(ℝ) which are flips. The signature σ(γ) is defined by
σ(γ) := ∑_{l=1}^m sign(γ(ξ_l))(−1)^l." Stem rendering (DERIVED, R10): the
alternating flip sum over an enumerated flip list (0-based `Fin m`, hence
the exponent `l.val + 1`). -/
def stemSignature (γ : C(unitInterval, ℂ)) {m : ℕ} (ξ : Fin m → unitInterval) : ℝ :=
  ∑ l : Fin m, Real.sign ((γ (ξ l)).re) * (-1 : ℝ) ^ (l.val + 1)

/-- Def 5.7's closing clause: "If there are no flips, then we define
σ(γ) := 0." -/
theorem stemSignature_no_flips (γ : C(unitInterval, ℂ)) (ξ : Fin 0 → unitInterval) :
    stemSignature γ ξ = 0 := by
  simp [stemSignature]

open scoped Classical in
/-- GPVwind Def 5.16 (SOURCES/GPVwind.md, verbatim): "If
γ([e_l, s_{l+1}]) ∩ (−∞,0) = ∅, then sign([e_l,s_{l+1}]) = 1; otherwise,
if γ([e_l, s_{l+1}]) ∩ (0,∞) = ∅, then sign([e_l,s_{l+1}]) = −1." — the
sign of an obstruction interval (Def 5.15's vocabulary: "The intervals
[e_l, s_{l+1}] are called obstruction intervals"). Stem rendering
(DERIVED, R10) on `re`. -/
def intervalSign (γ : C(unitInterval, ℂ)) (s e : unitInterval) : ℝ :=
  if ∀ u ∈ Set.Icc s e, 0 ≤ (γ u).re then 1 else -1

/-- GPVwind Def 5.19 (SOURCES/GPVwind.md, verbatim): "If γ is a loop, then
we define the circular signature with respect to 𝔍 to be
σᶜ(γ,𝔍) := ∑_{l=1}^k sign([e_l,s_{l+1}]))(−1)^l. If there are no flips,
then we define σ(γ,𝔍) := 0, σᶜ(γ,𝔍) := 0." (Printed anomalies transcribed
in SOURCES; the paper's name is "circular signature" — FLAGS item 4.)
Stem rendering (DERIVED, R10): the alternating sum over interval-sign
inputs. -/
def circularSignature {m : ℕ} (signs : Fin m → ℝ) : ℝ :=
  ∑ l : Fin m, signs l * (-1 : ℝ) ^ (l.val + 1)

/-- The constant-sign alternating collapse: if every flip value carries
one sign `s`, the signature is `0` (even count) or `−s` (odd count). -/
theorem stemSignature_const_sign (γ : C(unitInterval, ℂ)) {m : ℕ}
    (ξ : Fin m → unitInterval) {s : ℝ}
    (hs : ∀ l, Real.sign ((γ (ξ l)).re) = s) :
    stemSignature γ ξ = if Even m then 0 else -s := by
  have h1 : stemSignature γ ξ = ∑ l : Fin m, s * (-1 : ℝ) ^ (l.val + 1) := by
    unfold stemSignature
    exact Finset.sum_congr rfl fun l _ => by rw [hs l]
  rw [h1, ← Finset.mul_sum,
    Fin.sum_univ_eq_sum_range (fun l => (-1 : ℝ) ^ (l + 1)) m,
    sum_range_neg_one_pow_succ]
  rcases Nat.even_or_odd m with hm | hm
  · rw [if_pos hm, if_pos hm, mul_zero]
  · rw [if_neg (by rw [Nat.not_even_iff_odd]; exact hm),
      if_neg (by rw [Nat.not_even_iff_odd]; exact hm)]
    ring

/-- **Cor 5.13's criterion auto-passes at positive crossings**: with every
flip value on the positive reals (the corollary's normalization
`γ(ξ_k) > 0`), the signature lands in the corollary's admissible set
`{0, −1}` outright. -/
theorem stemSignature_mem_of_pos (γ : C(unitInterval, ℂ)) {m : ℕ}
    (ξ : Fin m → unitInterval) (hpos : ∀ l, 0 < (γ (ξ l)).re) :
    stemSignature γ ξ = 0 ∨ stemSignature γ ξ = -1 := by
  have h := stemSignature_const_sign γ ξ (s := 1)
    (fun l => Real.sign_of_pos (hpos l))
  rcases Nat.even_or_odd m with hm | hm
  · left
    rw [h, if_pos hm]
  · right
    rw [h, if_neg (by rw [Nat.not_even_iff_odd]; exact hm)]

/-! ### §C.2 — the band rows: rungs, arcs, and the crossing ledger (Cor 5.21 mechanism) -/

/-- The rungs: a lift's height is an integer π-multiple exactly over the
obstruction set. -/
theorem lift_height_pi_iff (γ γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) (t : unitInterval) :
    (γ t).im = 0 ↔ ∃ j : ℤ, (γ' t).im = (j : ℝ) * Real.pi := by
  rw [← hlift t, Complex.exp_im]
  constructor
  · intro h
    rcases mul_eq_zero.mp h with h' | h'
    · exact absurd h' (Real.exp_ne_zero _)
    · obtain ⟨j, hj⟩ := Real.sin_eq_zero_iff.mp h'
      exact ⟨j, hj.symm⟩
  · rintro ⟨j, hj⟩
    rw [hj, Real.sin_int_mul_pi, mul_zero]

/-- **Arc confinement (Props 5.5/5.6's conservation mechanism)**: along a
big arc — the value off the real axis throughout — the lift's height
never crosses any rung: endpoints sit on the same side of every `jπ`. -/
theorem arc_band_confined (γ γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) {s t : unitInterval} (hst : s ≤ t)
    (harc : ∀ u, s ≤ u → u ≤ t → (γ u).im ≠ 0) (j : ℤ) :
    ((γ' s).im < (j : ℝ) * Real.pi ↔ (γ' t).im < (j : ℝ) * Real.pi) := by
  have hnorung : ∀ u, s ≤ u → u ≤ t → (γ' u).im ≠ (j : ℝ) * Real.pi := by
    intro u h1 h2 h
    exact harc u h1 h2 ((lift_height_pi_iff γ γ' hlift u).mpr ⟨j, h⟩)
  have hcont : ContinuousOn (fun u => (γ' u).im) (Set.Icc s t) :=
    (Complex.continuous_im.comp (map_continuous γ')).continuousOn
  constructor
  · intro hs'
    by_contra ht'
    have hlt : (j : ℝ) * Real.pi < (γ' t).im :=
      lt_of_le_of_ne (not_lt.mp ht') (Ne.symm (hnorung t hst le_rfl))
    obtain ⟨u, hu, hu'⟩ := intermediate_value_Icc hst hcont ⟨hs'.le, hlt.le⟩
    exact hnorung u hu.1 hu.2 hu'
  · intro ht'
    by_contra hs'
    have hlt : (j : ℝ) * Real.pi < (γ' s).im :=
      lt_of_le_of_ne (not_lt.mp hs') (Ne.symm (hnorung s le_rfl hst))
    obtain ⟨u, hu, hu'⟩ := intermediate_value_Icc' hst hcont ⟨ht'.le, hlt.le⟩
    exact hnorung u hu.1 hu.2 hu'

/-- Negative-real crossings happen at ODD rungs (`lem:exp-degenerate`
band form). -/
theorem crossing_height_odd_of_neg (γ γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) (t : unitInterval)
    (hre : (γ t).re < 0) (him : (γ t).im = 0) :
    ∃ k : ℤ, (γ' t).im = (2 * (k : ℝ) + 1) * Real.pi := by
  have hr : 0 < -(γ t).re := by linarith
  have hval : γ t = -(((-(γ t).re) : ℝ) : ℂ) := by
    apply Complex.ext
    · simp
    · simpa using him
  have h := (exp_eq_neg_real_iff hr (γ' t)).mp (by rw [hlift t]; exact hval)
  obtain ⟨k, hk⟩ := h
  refine ⟨k, ?_⟩
  have := congrArg Complex.im hk
  simpa using this

/-- Positive-real crossings happen at EVEN rungs. -/
theorem crossing_height_even_of_pos (γ γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) (t : unitInterval)
    (hre : 0 < (γ t).re) (him : (γ t).im = 0) :
    ∃ k : ℤ, (γ' t).im = 2 * (k : ℝ) * Real.pi := by
  have h1 : Real.exp ((γ' t).re) * Real.sin ((γ' t).im) = 0 := by
    have h := congrArg Complex.im (hlift t)
    rw [Complex.exp_im] at h
    rw [h]
    exact him
  have hsin : Real.sin ((γ' t).im) = 0 := by
    rcases mul_eq_zero.mp h1 with h' | h'
    · exact absurd h' (Real.exp_ne_zero _)
    · exact h'
  obtain ⟨j, hj⟩ := Real.sin_eq_zero_iff.mp hsin
  have h2 : Real.exp ((γ' t).re) * Real.cos ((γ' t).im) = (γ t).re := by
    have h := congrArg Complex.re (hlift t)
    rw [Complex.exp_re] at h
    exact h
  rw [← hj, Real.cos_int_mul_pi] at h2
  rcases Int.even_or_odd j with he | ho
  · obtain ⟨k, hk⟩ := he
    refine ⟨k, ?_⟩
    rw [← hj, hk]
    push_cast
    ring
  · exfalso
    rw [Odd.neg_one_zpow ho] at h2
    have := Real.exp_pos ((γ' t).re)
    nlinarith

/-- The pointwise band-side reading: within one rung-band, the side of
the rung is read off the value's direction sign — `im γ > 0` above the
rung iff `(−1)^j = 1` (the parity twist of `sin` across rungs). -/
theorem band_side_of_sign {w v : ℂ} (hexp : Complex.exp w = v) {j : ℤ}
    (hband : |w.im - (j : ℝ) * Real.pi| < Real.pi) {s : ℝ}
    (hsign : Real.sign v.im = s) (hs : s = 1 ∨ s = -1) :
    ((j : ℝ) * Real.pi < w.im ↔ s = (-1 : ℝ) ^ j) := by
  have him : v.im = Real.exp w.re * Real.sin w.im := by
    rw [← hexp, Complex.exp_im]
  have hsplit : Real.sin w.im = (-1 : ℝ) ^ j * Real.sin (w.im - (j : ℝ) * Real.pi) := by
    have h := Real.sin_add_int_mul_pi (w.im - (j : ℝ) * Real.pi) j
    rw [sub_add_cancel] at h
    rw [h]
  have hvne : v.im ≠ 0 := by
    intro h
    rw [h, Real.sign_zero] at hsign
    rcases hs with h' | h' <;> rw [← hsign] at h' <;> norm_num at h'
  have hxne : w.im - (j : ℝ) * Real.pi ≠ 0 := by
    intro h
    apply hvne
    rw [him, hsplit, h, Real.sin_zero, mul_zero, mul_zero]
  have habs := abs_lt.mp hband
  have hexppos := Real.exp_pos w.re
  rcases lt_or_gt_of_ne hxne with hneg | hpos
  · -- below the rung: sin(x) < 0
    have hsinneg : Real.sin (w.im - (j : ℝ) * Real.pi) < 0 :=
      Real.sin_neg_of_neg_of_neg_pi_lt hneg habs.1
    constructor
    · intro h
      exfalso
      linarith [sub_pos.mpr h]
    · intro h
      exfalso
      rcases Int.even_or_odd j with hj | hj
      · rw [Even.neg_one_zpow hj] at h
        have hvneg : v.im < 0 := by
          rw [him, hsplit, Even.neg_one_zpow hj]
          nlinarith
        rw [Real.sign_of_neg hvneg] at hsign
        rw [← hsign] at h
        norm_num at h
      · rw [Odd.neg_one_zpow hj] at h
        have hvpos : 0 < v.im := by
          rw [him, hsplit, Odd.neg_one_zpow hj]
          nlinarith
        rw [Real.sign_of_pos hvpos] at hsign
        rw [← hsign] at h
        norm_num at h
  · -- above the rung: sin(x) > 0
    have hsinpos : 0 < Real.sin (w.im - (j : ℝ) * Real.pi) :=
      Real.sin_pos_of_pos_of_lt_pi hpos habs.2
    constructor
    · intro _
      rcases Int.even_or_odd j with hj | hj
      · rw [Even.neg_one_zpow hj]
        have hvpos : 0 < v.im := by
          rw [him, hsplit, Even.neg_one_zpow hj]
          nlinarith
        rw [Real.sign_of_pos hvpos] at hsign
        exact hsign.symm
      · rw [Odd.neg_one_zpow hj]
        have hvneg : v.im < 0 := by
          rw [him, hsplit, Odd.neg_one_zpow hj]
          nlinarith
        rw [Real.sign_of_neg hvneg] at hsign
        exact hsign.symm
    · intro _
      linarith

/-- **The crossing ledger (Prop 5.8's mechanism, PROVED)**: at a crossing
whose lift height is the rung `jπ`, the eventual side of the rung on each
one-sided approach is read off the crossing datum's direction sign against
the rung parity. Flips step the band, bounces conserve it. -/
theorem crossing_band_ledger (γ γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) (d : CrossingData γ) (j : ℤ)
    (hj : (γ' d.t).im = (j : ℝ) * Real.pi) :
    (∀ᶠ u in nhdsWithin d.t (Set.Iio d.t),
        (((j : ℝ) * Real.pi < (γ' u).im) ↔ d.sLeft = (-1 : ℝ) ^ j))
    ∧ ∀ᶠ u in nhdsWithin d.t (Set.Ioi d.t),
        (((j : ℝ) * Real.pi < (γ' u).im) ↔ d.sRight = (-1 : ℝ) ^ j) := by
  have htend : Filter.Tendsto (fun u => (γ' u).im) (nhds d.t)
      (nhds ((j : ℝ) * Real.pi)) := by
    rw [← hj]
    exact (Complex.continuous_im.comp (map_continuous γ')).continuousAt
  have hball : ∀ᶠ u in nhds d.t, |(γ' u).im - (j : ℝ) * Real.pi| < Real.pi := by
    have h := Metric.tendsto_nhds.mp htend Real.pi Real.pi_pos
    filter_upwards [h] with u hu
    rwa [Real.dist_eq] at hu
  constructor
  · filter_upwards [hball.filter_mono nhdsWithin_le_nhds, d.eventually_left]
      with u hu hsu
    exact band_side_of_sign (hlift u) hu hsu d.sLeft_unit
  · filter_upwards [hball.filter_mono nhdsWithin_le_nhds, d.eventually_right]
      with u hu hsu
    exact band_side_of_sign (hlift u) hu hsu d.sRight_unit

/-- **Cor 5.21's stem accounting** (GPVwind Cor 5.21, SOURCES/GPVwind.md,
verbatim, printed even-hypothesis included per FLAGS item 3: "Let γ be a
loop and σᶜ(γ) even. Then ω(γ,𝔍) = |σᶜ(γ,𝔍)|/2."): the lift's height
shift along a loop is `2π` per winding unit — the rung count of the shift
is even, twice the winding; the paper's `|σᶜ|/2` reads the same count off
the flips through the ledger (`crossing_band_ledger`: flips step the band,
bounces conserve it). DERIVED (R10). -/
theorem winding_height_shift (γ : C(unitInterval, ℂ)) (hγ : ∀ t, γ t ≠ 0)
    (hloop : γ 0 = γ 1) (γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) :
    (γ' 1).im - (γ' 0).im = (stemWinding γ : ℝ) * (2 * Real.pi) := by
  have h := stemWinding_spec γ hγ hloop γ' hlift
  have h2 := congrArg Complex.im h
  rw [Complex.sub_im] at h2
  rw [h2]
  simp [Complex.mul_im, Complex.mul_re]

namespace ASection

/-- **The local argument principle at the pole, PROVED**: C1's one simple
pole (`c1_simple`, order exactly `−1`) makes the value-loop along every
sufficiently small circle about the pole wind exactly `−1` — the divisor
counting's pole entry. -/
theorem stemWinding_circle_pole (A : ASection) :
    ∃ ε₀ > 0, ∀ ε : ℝ, 0 < ε → ε ≤ ε₀ →
      ∃ Γ : C(unitInterval, ℂ),
        (∀ t, Γ t = A.F (circleLoop (A.pole : ℂ) ε t)) ∧
        (∀ t, Γ t ≠ 0) ∧ Γ 0 = Γ 1 ∧ stemWinding Γ = -1 := by
  have hmero : MeromorphicAt A.F (A.pole : ℂ) := A.meromorphic _ (Set.mem_univ _)
  obtain ⟨g, hga, hgne, hev⟩ := (meromorphicOrderAt_eq_int_iff hmero).mp A.c1_simple
  rw [eventually_nhdsWithin_iff] at hev
  obtain ⟨r₁, hr₁pos, hr₁⟩ := Metric.eventually_nhds_iff.mp hev
  obtain ⟨r₂, hr₂pos, hr₂⟩ :=
    Metric.continuousAt_iff.mp hga.continuousAt ‖g (A.pole : ℂ)‖ (norm_pos_iff.mpr hgne)
  refine ⟨min r₁ r₂ / 2, by positivity, ?_⟩
  intro ε hε hεle
  have hεr₁ : ε < r₁ := by
    have h1 : min r₁ r₂ ≤ r₁ := min_le_left _ _
    have h2 : 0 < min r₁ r₂ := lt_min hr₁pos hr₂pos
    linarith
  have hεr₂ : ε < r₂ := by
    have h1 : min r₁ r₂ ≤ r₂ := min_le_right _ _
    have h2 : 0 < min r₁ r₂ := lt_min hr₁pos hr₂pos
    linarith
  have hdist : ∀ t, dist (circleLoop (A.pole : ℂ) ε t) (A.pole : ℂ) = ε := fun t => by
    rw [dist_eq_norm]
    exact circleLoop_dist _ hε t
  have havoid : ∀ t, circleLoop (A.pole : ℂ) ε t ≠ (A.pole : ℂ) := fun t h => by
    have h2 := hdist t
    rw [h, dist_self] at h2
    exact hε.ne h2
  have hfac : ∀ t, A.F (circleLoop (A.pole : ℂ) ε t)
      = (circleLoop (A.pole : ℂ) ε t - (A.pole : ℂ)) ^ (-1 : ℤ)
          • g (circleLoop (A.pole : ℂ) ε t) := fun t =>
    hr₁ (by rw [hdist t]; exact hεr₁) (havoid t)
  have hgnear : ∀ t, dist (g (circleLoop (A.pole : ℂ) ε t)) (g (A.pole : ℂ))
      < ‖g (A.pole : ℂ)‖ := fun t =>
    hr₂ (by rw [hdist t]; exact hεr₂)
  have hgcirc_ne : ∀ t, g (circleLoop (A.pole : ℂ) ε t) ≠ 0 := fun t h => by
    have h2 := hgnear t
    rw [h, dist_zero_left] at h2
    exact lt_irrefl _ h2
  set Γ : C(unitInterval, ℂ) :=
    ⟨fun t => A.F (circleLoop (A.pole : ℂ) ε t), A.continuous_F_circleLoop havoid⟩
    with hΓ_def
  have hΓval : ∀ t, Γ t = A.F (circleLoop (A.pole : ℂ) ε t) := fun t => rfl
  set δ : C(unitInterval, ℂ) :=
    ⟨fun t => circleLoop (A.pole : ℂ) ε t - (A.pole : ℂ),
      (map_continuous _).sub continuous_const⟩ with hδ_def
  have hδval : ∀ t, δ t = circleLoop (A.pole : ℂ) ε t - (A.pole : ℂ) := fun t => rfl
  have hδne : ∀ t, δ t ≠ 0 := fun t h => by
    have h2 := hdist t
    rw [dist_eq_norm, ← hδval t, h, norm_zero] at h2
    exact hε.ne h2
  have hδloop : δ 0 = δ 1 := by
    rw [hδval 0, hδval 1, circleLoop_closed]
  have hδwind : stemWinding δ = 1 :=
    stemWinding_circleLoop_sub_center _ hε δ hδval
  -- the value formula in field form
  have hΓform : ∀ t, Γ t = (δ t)⁻¹ * g (circleLoop (A.pole : ℂ) ε t) := fun t => by
    rw [hΓval t, hfac t, zpow_neg_one, smul_eq_mul, hδval t]
  have hΓne : ∀ t, Γ t ≠ 0 := fun t => by
    rw [hΓform t]
    exact mul_ne_zero (inv_ne_zero (hδne t)) (hgcirc_ne t)
  have hΓloop : Γ 0 = Γ 1 := by
    rw [hΓval 0, hΓval 1, circleLoop_closed]
  -- the product Γ·δ is the near-constant unit loop
  have hprod_val : ∀ t, (Γ * δ) t = g (circleLoop (A.pole : ℂ) ε t) := fun t => by
    rw [ContinuousMap.mul_apply, hΓform t, inv_mul_eq_div,
      div_mul_cancel₀ _ (hδne t)]
  have hprod_ne : ∀ t, (Γ * δ) t ≠ 0 := fun t => by
    rw [hprod_val t]
    exact hgcirc_ne t
  have hprod_loop : (Γ * δ) 0 = (Γ * δ) 1 := by
    rw [ContinuousMap.mul_apply, ContinuousMap.mul_apply, hΓloop, hδloop]
  have hprod_wind : stemWinding (Γ * δ) = 0 := by
    refine stemWinding_eq_zero_of_near_const (Γ * δ) hprod_loop hgne (fun t => ?_)
    rw [hprod_val t, ← dist_eq_norm]
    exact hgnear t
  have hsum := stemWinding_mul Γ δ hΓne hδne hΓloop hδloop
  rw [hprod_wind, hδwind] at hsum
  exact ⟨Γ, hΓval, hΓne, hΓloop, by omega⟩

end ASection

namespace ASection

/-- **The obstruction reading (Cor 5.13 contrapositive on the stem),
PROVED**: around every enumerated zero, every sufficiently small circle's
value-loop admits NO closed lift — the loop is obstructed; in the paper's
vocabulary its signature criterion fails. -/
theorem no_closed_lift_around_sphereZero (A : ASection) (n : ℕ) :
    ∃ ε₀ > 0, ε₀ < (A.sphereZero n).im ∧ ∀ ε : ℝ, 0 < ε → ε ≤ ε₀ →
      ∃ Γ : C(unitInterval, ℂ),
        (∀ t, Γ t = A.F (circleLoop (A.sphereZero n) ε t)) ∧
        ¬ ∃ Γ' : C(unitInterval, ℂ),
            (∀ t, Complex.exp (Γ' t) = Γ t) ∧ Γ' 1 = Γ' 0 := by
  obtain ⟨ε₀, hε₀, hε₀im, h⟩ := A.stemWinding_circle_sphereZero n
  refine ⟨ε₀, hε₀, hε₀im, fun ε hε hεle => ?_⟩
  obtain ⟨Γ, hΓval, hΓne, hΓloop, hΓwind⟩ := h ε hε hεle
  refine ⟨Γ, hΓval, fun hclosed => ?_⟩
  have h0 : stemWinding Γ = 0 :=
    (stemWinding_eq_zero_iff Γ hΓne hΓloop).mpr hclosed
  rw [hΓwind] at h0
  have := A.fiber_tally_pos n
  omega

end ASection

namespace ASection

/-- **E3 — THE DRIVE** (charter step 3: "connect to the ONE closed tame
loop through the cone (pole_cone_eps_delta, winding_loop_closed, C1: ONE
pole) — the loop assembly's counting constraint. Whatever inequality or
contradiction the counting yields, drive it to the theorem."). Statement =
the theorem's target (`ASection.concentricity`, Theorem.lean — the
repository's one open node). Every possession fed below is PROVED:

(0) the supposition names two enumerated zeros at distinct levels;
(1) THE σ-COUNTING (this file): a vertical line `Re = β` strictly between
    the levels, circle contours strictly left and right, value-windings =
    the fiber tallies ≥ 1 on EACH side (`sigma_level_separation` ←
    `stemWinding_circle_sphereZero` ← the C3 peel + multiplicativity) —
    hence BOTH side loops are OBSTRUCTED: no closed lift exists on either
    side of the line (`stemWinding_eq_zero_iff`, Cor 5.13's criterion in
    its stem-honest closure form);
(2) C1's pole entry: the pole circle winds exactly −1
    (`stemWinding_circle_pole` ← `c1_simple`);
(3) the cone at N and the closure rows (`pole_cone_eps_delta`,
    `pole_cone_tendsto`, `winding_loop_closed`,
    `winding_loop_defect_level_zero`, `winding_height_shift`);
(4) the σ-apparatus rows (`stemSignature_mem_of_pos` — the {0,−1}
    auto-pass at positive crossings, `crossing_band_ledger`,
    `arc_band_confined`, the rung parities);
(5) C2/C3's joint stem data (`stem_identity_logDeriv`,
    `shared_ladder_encounters`);
(6) the ladder reduction (`transportLevel_placement_of_two_sided`,
    `liSum_first_side`, `liSum_second_side`; D2's iff
    `placement_set_iff_liSum` makes the target the one sentence `∃β`
    two-sided).

RECEIPT (R6, 2026-07-06): goal at the stop
  ⊢ False
and RESISTS. `exact?` at the seam: could not close the goal. THE PRECISE
MISSING INFERENCE, one sentence: every winding possession above is LOCAL —
each contour lifts with its own defect, and no fed statement constrains
the winding integers ACROSS contours; the constraint that would tie them —
Cor 5.13's σ ∈ {0,−1} criterion on the ONE assembled loop through the cone
at N — lives on the octonionic direction field (Def 5.2's one-sided limits
of Y/|Y|), which has NO stem carrier (GPVwind Rem 2.1; the recorded GAP of
`winding_loop_defect`, Toolkit.lean), and its stem shadow (the closure iff
of this file) is exactly the register identification `eq:placement-set` in
σ-vocabulary. LITMUS (the charter's honesty pin): every row fed above
holds verbatim for a hypothetical section with a two-level divisor — its
circles wind ≥ 1 on both sides, its pole −1, all ledgers balance — so no
assembly of these possessions alone can close `False`; consistent with the
E1 audit (`auditE1_target_iff_two_sided`: the remaining content is `∃β`)
and the recorded failure mode of every prior route. The `sorry` is the
ROUTE RECEIPT (unimported artifact; R8), not a queue item. -/
theorem concentricity_via_sigma (A : ASection) :
    ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c := by
  by_contra hno
  -- (0) the supposition yields two enumerated zeros at distinct levels
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
  -- (1) THE σ-COUNTING (PROVED, this file): a vertical line Re = β strictly
  --     between the two levels; circle contours strictly left and right of
  --     it; the value-loops wind the fiber tallies ≥ 1 on EACH side
  obtain ⟨β, hβa, hβb, ε, hε, hleft, hright, Γa, Γb, hΓaval, hΓbval,
    hΓane, hΓbne, hwa, hwb⟩ := A.sigma_level_separation hab
  have hΓaloop : Γa 0 = Γa 1 := by
    rw [hΓaval 0, hΓaval 1, circleLoop_closed]
  have hΓbloop : Γb 0 = Γb 1 := by
    rw [hΓbval 0, hΓbval 1, circleLoop_closed]
  -- ... so BOTH side loops are obstructed: no closed lift exists for either
  --     (Cor 5.13's criterion fails on both sides of the line)
  have hobs_a : ¬ ∃ Γ' : C(unitInterval, ℂ),
      (∀ t, Complex.exp (Γ' t) = Γa t) ∧ Γ' 1 = Γ' 0 := by
    intro hclosed
    have h0 := (stemWinding_eq_zero_iff Γa hΓane hΓaloop).mpr hclosed
    omega
  have hobs_b : ¬ ∃ Γ' : C(unitInterval, ℂ),
      (∀ t, Complex.exp (Γ' t) = Γb t) ∧ Γ' 1 = Γ' 0 := by
    intro hclosed
    have h0 := (stemWinding_eq_zero_iff Γb hΓbne hΓbloop).mpr hclosed
    omega
  -- (2) the pole's entry: C1's ONE simple pole counts −1 (PROVED)
  have hpole := A.stemWinding_circle_pole
  -- (3) the cone at N and the closure rows (PROVED)
  have hcone := A.pole_cone_eps_delta
  have hcone' := A.pole_cone_tendsto
  have hclosure := @winding_loop_closed
  have hlevel := @winding_loop_defect_level_zero
  have hshift := @winding_height_shift
  -- (4) the σ-apparatus rows (PROVED): the {0,−1} auto-pass at positive
  --     crossings, the crossing ledger, arc confinement, rung parities
  have hsig := @stemSignature_mem_of_pos
  have hledger := @crossing_band_ledger
  have harc := @arc_band_confined
  have hodd := @crossing_height_odd_of_neg
  have heven := @crossing_height_even_of_pos
  -- (5) C2/C3's joint stem data (PROVED): the two-index engine, the shared
  --     degenerate encounters of the two zeros
  have hjoint := A.stem_identity_logDeriv
  have henc := A.shared_ladder_encounters a b
  -- (6) the ladder reduction (PROVED): the target IS ∃β two-sided
  have hladder := A.transportLevel_placement_of_two_sided
  have hfirst := A.liSum_first_side
  have hsecond := A.liSum_second_side
  -- RECEIPT
  sorry

end ASection
