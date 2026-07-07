/-
Concentricity/WeldW12.lean

W1+W2 — ONE WELD (the author's charter, 2026-07-06: "W1 and W2 are not
separate"): the FIRST connection of GPV's winding theory to C2, plus the
strip's two walls, joined into class-wide finite-rectangle counting rows.
UNIMPORTED ARTIFACT (KeystoneAssembly / GreatCircleRoute / LoopAssembly /
SigmaE3 / PairingE2 precedent): not in the root import list; the root
ledger (2/0) is untouched. EVERY row in this file is PROVED — no `sorry`
anywhere here; the drive's residual is recorded in prose (§F), not sorried.

THE POINT OF VIEW (the author, 2026-07-06, the organizing principle): the
A-section is DEFINED by C1–C4 and EXTENDS ALL OF GPV — the winding/tameness
theory is a body of consequences the definition already owns, never yet
welded in. Each row's docstring names the weld step it serves.

THE WELD, row by row:

§A — W1(a), the C2 circle rows (c2_locMajorant AND c2_zero_free consumed
JOINTLY, the first time ever): `c2_tail_confinement` (the tails of {ℓₚ}
are uniformly small on a ball, each member zero-free there — punctured
confinement — so the factors exp(ℓₚ) sit inside any disk about 1);
`stemWinding_c2_factor` (each Euler factor's value-loop winds ZERO along
every half-space loop — the explicit closed lift ℓₚ∘γ);
`stemWinding_F_halfSpace` (THE W1 MASTER ROW: the section's own value-loops
wind zero throughout C2's half-space — the Euler sum IS the global lift;
GPV's winding welded to C2).

§B — W1(b), argument control on right-wall segments: `arg_control_right_wall`
— along any vertical segment {a} × [T₁,T₂] with a > Ω₀, the canonical lift
S = Σₚ ℓₚ of A is continuous with |Im S| ≤ M (M from the §4α majorants
through compactness), so the variation of arg A along the wall is ≤ 2M.

§C — W2(c), THE LEFT WALL: `F_ne_zero_of_re_lt_lowerEdge` /
`exists_leftWall_zero_free` — the upper-half stem is zero-free on
{Im > 0, Re < βlo}, from `sphereZero_complete` (every upper zero is
enumerated) + `c3_lowerEdge` (every enumerated zero has Re ≥ βlo);
`stemWinding_F_leftRegion` — value-loops in the (convex) left region wind
zero: the left twin of the W1 master row.

§D — the GPV homotopy-rectangle engine (GPVwind Def 4.20, the MAP/tame-
rectangle version, stem-rendered): `stemWinding_eq_of_homotopy` (free
homotopy invariance of the winding, via the pin's homotopy lifting property
`IsCoveringMap.liftHomotopy` over `Complex.isCoveringMap_exp` — R5 verified
live, Mathlib/Topology/Homotopy/Lifting.lean); `stemWinding_comp_eq_zero_of_convex`
(nonvanishing continuous images of convex carriers wind zero — the domain
contraction pushed through g); `stemWinding_eq_of_common_halfPlane` (the
pointwise half-plane comparison: two loops sharing an open half-plane
witness have equal windings — quotient loop in the slit plane);
`stemWinding_eq_zero_of_halfPlane`.

§E — W2(d), the counting weld (E2's residue ledger and E3's winding rows
joined on RECTANGLES): `rectLoop` (the four-edge boundary loop) with its
frame rows; `stemWinding_rectLoop_sub_interior` (the rectangle model row:
the boundary winds ONCE about every interior point — proved by the
half-plane comparison against the phase-aligned circle, no integral, no
homotopy); `ASection.stemWinding_F_rectLoop` (THE COUNTING ROW: for an
upper-half rectangle whose frame carries no enumerated zero, the winding of
the section's value-loop along the boundary equals the number of enumerated
zeros trapped, with the enumeration's multiplicity; the pole is real —
outside every upper-half rectangle — so no pole term arises);
`ASection.stemWinding_F_stripRect` (the spanning instance: left edge left
of βlo — zero-free by §C; right edge right of Ω₀ — zero-free by C2, its
argument controlled by §B; the count is the full height-window divisor
count, the class-wide N(T) row).

§F — the drive at the target's minimal face:
`ASection.counting_pair_of_two_levels` — two enumerated zeros at distinct
levels yield a line Re = β strictly between and two rectangles, strictly
left and right of it, each trapping ≥ 1 zero, each with its value-loop
winding EQUAL to its own trapped count (E3's `sigma_level_separation` gave
windings ≥ 1 on circles; the counting rows sharpen both to equalities on
rectangles). THE VERDICT OF RECORD (R6, no sorry spent): the counting
forces NO relation between the two rectangles' data beyond additivity —
for any admissible rectangle the winding is pinned to its own trapped
count, so the union rectangle's winding is the sum of the parts (plus any
middle-strip captures), and every row here holds verbatim for a two-level
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
right rectangles wind their own counts, all ledgers balance). The missing
inference is exactly E3's receipt and E1's audit: a producer for the
cross-contour constraint — the register identification `eq:placement-set`
(equivalently ∃β two-sided, `auditE1_target_iff_two_sided`) — which no
assembly of the fed possessions supplies.

`sorry` marks UNFORMALIZED, never UNSOUND (R8); this file carries none.
-/
import Concentricity.SigmaE3
import Concentricity.PairingE2
import Mathlib.Topology.Homotopy.Lifting

noncomputable section

open Complex

/-! ## §0 — coordinate helpers (private; consumed by every rectangle row) -/

private theorem addMulI_re (x y : ℝ) :
    (((x : ℝ) : ℂ) + ((y : ℝ) : ℂ) * Complex.I).re = x := by
  rw [Complex.add_re, Complex.ofReal_re, Complex.mul_re, Complex.I_re, Complex.I_im,
    Complex.ofReal_re, Complex.ofReal_im]
  ring

private theorem addMulI_im (x y : ℝ) :
    (((x : ℝ) : ℂ) + ((y : ℝ) : ℂ) * Complex.I).im = y := by
  rw [Complex.add_im, Complex.ofReal_im, Complex.mul_im, Complex.I_re, Complex.I_im,
    Complex.ofReal_re, Complex.ofReal_im]
  ring

private theorem neg_I_mul_re (z : ℂ) : (-Complex.I * z).re = z.im := by
  rw [Complex.mul_re, Complex.neg_re, Complex.neg_im, Complex.I_re, Complex.I_im]
  ring

private theorem neg_one_mul_re (z : ℂ) : ((-1 : ℂ) * z).re = -z.re := by
  rw [neg_one_mul, Complex.neg_re]

private theorem ofReal_mul_I_re (θ : ℝ) : (((θ : ℝ) : ℂ) * Complex.I).re = 0 := by
  rw [Complex.mul_re, Complex.I_re, Complex.I_im, Complex.ofReal_re, Complex.ofReal_im]
  ring

private theorem ofReal_mul_I_im (θ : ℝ) : (((θ : ℝ) : ℂ) * Complex.I).im = θ := by
  rw [Complex.mul_im, Complex.I_re, Complex.I_im, Complex.ofReal_re, Complex.ofReal_im]
  ring

namespace ASection

/-! ## §A — W1(a): the C2 circle rows (c2_locMajorant + c2_zero_free, jointly) -/

/-- W1 helper (serves W1(a)/(b) and the §E right edge): **the Euler sum is
continuous on C2's half-space** — the §4α majorant ball, shrunk into the
half-space, carries the locally uniform convergence (pin, R5 verified live:
`continuousOn_tsum`, Mathlib/Analysis/Normed/Group/FunctionSeries.lean),
each member continuous there by `c2_analyticAt`. PROVED. -/
theorem continuousOn_eulerSum (A : ASection) :
    ContinuousOn (fun z => ∑' p : A.ι, A.ℓ p z) {z : ℂ | A.Ω₀ < z.re} := by
  intro z hz
  have hzre : A.Ω₀ < z.re := hz
  obtain ⟨r, hr, u, hu, hbound⟩ := A.c2_locMajorant z hzre
  set ρ : ℝ := min r (z.re - A.Ω₀) with hρ_def
  have hρ : 0 < ρ := lt_min hr (sub_pos.mpr hzre)
  have hhalf : ∀ w ∈ Metric.ball z ρ, A.Ω₀ < w.re := by
    intro w hw
    have h1 : |(w - z).re| ≤ ‖w - z‖ := Complex.abs_re_le_norm _
    have h2 : ‖w - z‖ < ρ := by
      rw [← dist_eq_norm]
      exact Metric.mem_ball.mp hw
    have h3 := (abs_lt.mp (lt_of_le_of_lt h1 h2)).1
    rw [Complex.sub_re] at h3
    have h4 : ρ ≤ z.re - A.Ω₀ := min_le_right _ _
    linarith
  have hsub : Metric.ball z ρ ⊆ Metric.ball z r :=
    Metric.ball_subset_ball (min_le_left _ _)
  have hcont : ContinuousOn (fun w => ∑' p : A.ι, A.ℓ p w) (Metric.ball z ρ) :=
    continuousOn_tsum
      (fun p w hw => ((A.c2_analyticAt p w (hhalf w hw)).continuousAt).continuousWithinAt)
      hu (fun p w hw => hbound p w (hsub hw))
  exact (hcont.continuousAt
    (Metric.isOpen_ball.mem_nhds (Metric.mem_ball_self hρ))).continuousWithinAt

/-- **W1(a) — factor confinement, the JOINT consumption of `c2_locMajorant`
and `c2_zero_free`** (the first row ever to consume both): on a majorant
ball inside the half-space, all but finitely many Euler members take values
in the PUNCTURED disk of radius δ — zero-free by `c2_zero_free`, small by
the §4α majorant tail — and their factors exp(ℓₚ) are confined to the disk
of radius 2δ about 1 (pin, R5 verified live: `Complex.norm_exp_sub_one_le`,
Mathlib/Analysis/Complex/Exponential.lean:439). Serves W1(a): the tail
factors are Rouché-trivial, each winding zero by the near-constant row.
PROVED. -/
theorem c2_tail_confinement (A : ASection) {z : ℂ} (hz : A.Ω₀ < z.re)
    {δ : ℝ} (hδ : 0 < δ) :
    ∃ r > 0, (∀ w ∈ Metric.ball z r, A.Ω₀ < w.re) ∧
      ∃ S : Finset A.ι, ∀ p, p ∉ S → ∀ w ∈ Metric.ball z r,
        A.ℓ p w ≠ 0 ∧ ‖A.ℓ p w‖ < δ ∧ ‖Complex.exp (A.ℓ p w) - 1‖ < 2 * δ := by
  classical
  obtain ⟨r, hr, u, hu, hbound⟩ := A.c2_locMajorant z hz
  set ρ : ℝ := min r (z.re - A.Ω₀) with hρ_def
  have hρ : 0 < ρ := lt_min hr (sub_pos.mpr hz)
  have hhalf : ∀ w ∈ Metric.ball z ρ, A.Ω₀ < w.re := by
    intro w hw
    have h1 : |(w - z).re| ≤ ‖w - z‖ := Complex.abs_re_le_norm _
    have h2 : ‖w - z‖ < ρ := by
      rw [← dist_eq_norm]
      exact Metric.mem_ball.mp hw
    have h3 := (abs_lt.mp (lt_of_le_of_lt h1 h2)).1
    rw [Complex.sub_re] at h3
    have h4 : ρ ≤ z.re - A.Ω₀ := min_le_right _ _
    linarith
  have hsub : Metric.ball z ρ ⊆ Metric.ball z r :=
    Metric.ball_subset_ball (min_le_left _ _)
  set ε₀ : ℝ := min δ 1 with hε₀_def
  have hε₀ : 0 < ε₀ := lt_min hδ one_pos
  have hev : ∀ᶠ p in Filter.cofinite, u p < ε₀ :=
    hu.tendsto_cofinite_zero.eventually_lt_const hε₀
  have hfin : {p : A.ι | ¬ u p < ε₀}.Finite := Filter.eventually_cofinite.mp hev
  refine ⟨ρ, hρ, hhalf, hfin.toFinset, ?_⟩
  intro p hp w hw
  have hup : u p < ε₀ := by
    by_contra h
    exact hp (hfin.mem_toFinset.mpr h)
  have hbw : ‖A.ℓ p w‖ ≤ u p := hbound p w (hsub hw)
  have hlt : ‖A.ℓ p w‖ < ε₀ := lt_of_le_of_lt hbw hup
  have hle1 : ‖A.ℓ p w‖ ≤ 1 := le_of_lt (lt_of_lt_of_le hlt (min_le_right _ _))
  have hltδ : ‖A.ℓ p w‖ < δ := lt_of_lt_of_le hlt (min_le_left _ _)
  refine ⟨A.c2_zero_free p w (hhalf w hw), hltδ, ?_⟩
  calc ‖Complex.exp (A.ℓ p w) - 1‖ ≤ 2 * ‖A.ℓ p w‖ := Complex.norm_exp_sub_one_le hle1
    _ < 2 * δ := by linarith

/-- **W1(a) — zero winding per Euler factor**: along ANY loop in C2's
half-space the factor exp(ℓₚ)'s value-loop winds zero — ℓₚ∘γ is itself an
explicit CLOSED lift (`c2_analyticAt` supplies its continuity). This is
GPV's winding welded to C2 member-by-member: no Euler factor can carry
winding, on any contour the half-space admits. Serves W1(a) and the §E
right-edge control. PROVED. -/
theorem stemWinding_c2_factor (A : ASection) (p : A.ι) (γ : C(unitInterval, ℂ))
    (hγ : ∀ t, A.Ω₀ < (γ t).re) (hloop : γ 0 = γ 1)
    (Γ : C(unitInterval, ℂ)) (hΓ : ∀ t, Γ t = Complex.exp (A.ℓ p (γ t))) :
    stemWinding Γ = 0 := by
  have hcont : Continuous fun t : unitInterval => A.ℓ p (γ t) :=
    continuous_iff_continuousAt.mpr fun t =>
      ((A.c2_analyticAt p (γ t) (hγ t)).continuousAt).comp (map_continuous γ).continuousAt
  have hΓne : ∀ t, Γ t ≠ 0 := fun t => by
    rw [hΓ t]
    exact Complex.exp_ne_zero _
  have hΓloop : Γ 0 = Γ 1 := by rw [hΓ 0, hΓ 1, hloop]
  refine stemWinding_eq_of_lift Γ hΓne hΓloop ⟨_, hcont⟩ (fun t => (hΓ t).symm) 0 ?_
  show A.ℓ p (γ 1) - A.ℓ p (γ 0) = _
  rw [hloop]
  push_cast
  ring

/-- **W1 MASTER ROW — the section's value-loops wind zero throughout C2's
half-space**: the Euler sum S = Σₚ ℓₚ is the outright GLOBAL lift of A on
the half-space (`c2_euler` + `continuousOn_eulerSum`), and a lift that is a
function closes on every loop. The first weld of GPVwind's winding data to
C2 as a whole: whatever winding the divisor forces (E3's circle rows, §E's
rectangle rows), NONE of it lives right of Ω₀ — the right wall of every
counting contour is winding-inert. Serves W1(a) and §E (the four-edge
decomposition's right edge). PROVED. -/
theorem stemWinding_F_halfSpace (A : ASection) (γ : C(unitInterval, ℂ))
    (hγ : ∀ t, A.Ω₀ < (γ t).re) (hloop : γ 0 = γ 1)
    (Γ : C(unitInterval, ℂ)) (hΓ : ∀ t, Γ t = A.F (γ t)) :
    stemWinding Γ = 0 := by
  have hopen : IsOpen {z : ℂ | A.Ω₀ < z.re} := isOpen_lt continuous_const Complex.continuous_re
  have hcont : Continuous fun t : unitInterval => ∑' p : A.ι, A.ℓ p (γ t) :=
    continuous_iff_continuousAt.mpr fun t =>
      (A.continuousOn_eulerSum.continuousAt (hopen.mem_nhds (hγ t))).comp
        (map_continuous γ).continuousAt
  have hlift : ∀ t, Complex.exp ((⟨_, hcont⟩ : C(unitInterval, ℂ)) t) = Γ t := by
    intro t
    show Complex.exp (∑' p : A.ι, A.ℓ p (γ t)) = Γ t
    rw [hΓ t]
    exact (A.c2_euler (γ t) (hγ t)).symm
  have hΓne : ∀ t, Γ t ≠ 0 := fun t => by
    rw [hΓ t]
    exact A.zero_free_on_halfSpace (hγ t)
  have hΓloop : Γ 0 = Γ 1 := by rw [hΓ 0, hΓ 1, hloop]
  refine stemWinding_eq_of_lift Γ hΓne hΓloop ⟨_, hcont⟩ hlift 0 ?_
  show (∑' p : A.ι, A.ℓ p (γ 1)) - (∑' p : A.ι, A.ℓ p (γ 0)) = _
  rw [hloop]
  push_cast
  ring

/-! ## §B — W1(b): argument control on right-wall segments -/

/-- **W1(b) — the right wall's argument is majorant-controlled**: along the
vertical segment {a} × [T₁,T₂] with a > Ω₀, the canonical lift
S(y) = Σₚ ℓₚ(a+iy) of A (exp∘S = A there, `c2_euler`) is continuous with
|Im S| ≤ M throughout — M produced from the §4α local majorants through
compactness of the segment (`continuousOn_eulerSum` +
`IsCompact.exists_bound_of_continuousOn`, R5 verified live) — so the
variation of arg A along the wall is at most 2M. Serves W1(b) and §E: in
the four-edge decomposition of any counting rectangle whose right edge
sits at Re = a > Ω₀, that edge's argument contribution is bounded by the
majorant data alone. PROVED. -/
theorem arg_control_right_wall (A : ASection) {a : ℝ} (ha : A.Ω₀ < a) {T₁ T₂ : ℝ}
    (hT : T₁ ≤ T₂) :
    ∃ M : ℝ, 0 ≤ M ∧ ∃ S' : ℝ → ℂ,
      ContinuousOn S' (Set.Icc T₁ T₂) ∧
      (∀ y ∈ Set.Icc T₁ T₂,
        Complex.exp (S' y) = A.F (((a : ℝ) : ℂ) + ((y : ℝ) : ℂ) * Complex.I)) ∧
      (∀ y ∈ Set.Icc T₁ T₂, |(S' y).im| ≤ M) ∧
      |(S' T₂).im - (S' T₁).im| ≤ 2 * M := by
  set wall : ℝ → ℂ := fun y => ((a : ℝ) : ℂ) + ((y : ℝ) : ℂ) * Complex.I with hwall_def
  have hwall_cont : Continuous wall := by
    rw [hwall_def]
    fun_prop
  have hmaps : Set.MapsTo wall (Set.Icc T₁ T₂) {z : ℂ | A.Ω₀ < z.re} := by
    intro y _
    show A.Ω₀ < (wall y).re
    rw [hwall_def]
    rw [addMulI_re]
    exact ha
  set S' : ℝ → ℂ := fun y => ∑' p : A.ι, A.ℓ p (wall y) with hS'_def
  have hS'cont : ContinuousOn S' (Set.Icc T₁ T₂) :=
    A.continuousOn_eulerSum.comp hwall_cont.continuousOn hmaps
  obtain ⟨M₀, hM₀⟩ := isCompact_Icc.exists_bound_of_continuousOn hS'cont
  have hmemT₁ : T₁ ∈ Set.Icc T₁ T₂ := ⟨le_refl _, hT⟩
  have hmemT₂ : T₂ ∈ Set.Icc T₁ T₂ := ⟨hT, le_refl _⟩
  have hbound : ∀ y ∈ Set.Icc T₁ T₂, |(S' y).im| ≤ max M₀ 0 := by
    intro y hy
    calc |(S' y).im| ≤ ‖S' y‖ := Complex.abs_im_le_norm _
      _ ≤ M₀ := hM₀ y hy
      _ ≤ max M₀ 0 := le_max_left _ _
  refine ⟨max M₀ 0, le_max_right _ _, S', hS'cont, ?_, hbound, ?_⟩
  · intro y hy
    exact (A.c2_euler (wall y) (hmaps hy)).symm
  · have h1 := hbound T₁ hmemT₁
    have h2 := hbound T₂ hmemT₂
    have h1' := abs_le.mp h1
    have h2' := abs_le.mp h2
    refine abs_le.mpr ⟨?_, ?_⟩ <;> linarith [h1'.1, h1'.2, h2'.1, h2'.2]

/-! ## §C — W2(c): the left wall -/

/-- **W2(c) — THE LEFT WALL, pointwise form**: the upper-half stem is
zero-free left of the lower edge — an upper-half zero there would be
enumerated (`sphereZero_complete`, PlacementSet.lean) with Re ≥ βlo
(`c3_lowerEdge`'s bound, taken as hypothesis in its witness form),
contradiction. Serves W2(c) and §E: the left edge of every strip-spanning
counting rectangle is zero-free. PROVED. -/
theorem F_ne_zero_of_re_lt_lowerEdge (A : ASection) {βlo : ℝ}
    (hβ : ∀ k : ℕ, βlo ≤ (A.sphereZero k).re) {z : ℂ}
    (him : 0 < z.im) (hre : z.re < βlo) : A.F z ≠ 0 := by
  intro h0
  obtain ⟨n, hn⟩ := A.sphereZero_complete h0 him
  have hb := hβ n
  rw [hn] at hb
  linarith

/-- **W2(c) — THE LEFT WALL, packaged**: `c3_lowerEdge` supplies the edge;
every point of {Im > 0, Re < βlo} is a nonvanishing point of the stem.
Serves W2(c). PROVED. -/
theorem exists_leftWall_zero_free (A : ASection) :
    ∃ βlo : ℝ, (∀ k : ℕ, βlo ≤ (A.sphereZero k).re) ∧
      ∀ z : ℂ, 0 < z.im → z.re < βlo → A.F z ≠ 0 := by
  obtain ⟨βlo, hβ⟩ := A.c3_lowerEdge
  exact ⟨βlo, hβ, fun z him hre => A.F_ne_zero_of_re_lt_lowerEdge hβ him hre⟩

end ASection

/-! ## §D — the GPV homotopy-rectangle engine (GPVwind Def 4.20, stem form) -/

/-- **GPVwind's homotopy rectangles, stem-rendered — free homotopy
invariance of the winding** (GPVwind Def 4.20, SOURCES/GPVwind.md,
verbatim: "Let [a,b]×[c,d] ⊂ ℝ² and let F : [a,b]×[c,d] → 𝕂∖{0} be a
continuous map. … If the map F has a unique companion 𝔍^F, then it is
called a tame map." — on the stem the companion is the slice itself, by
fiat, exactly as for paths (`winding_lift_unique` docstring, Toolkit.lean),
so every homotopy rectangle of stem loops is tame and lifts): a continuous
family of nonvanishing loops has constant winding. Route: the pin's
homotopy lifting property for covering maps (`IsCoveringMap.liftHomotopy`
over `Complex.isCoveringMap_exp`; R5 verified live,
Mathlib/Topology/Homotopy/Lifting.lean — "a covering map is a Hurewicz
fibration. Proposition 1.30 of [hatcher02]"), then the endpoint defect is a
continuous function of the deformation parameter with values in the
discrete lattice 2πiℤ (`winding_loop_defect`, Toolkit.lean), hence constant
on the connected interval. Serves W2(d): the convex-carrier row below and,
through it, the counting rows' winding-inert factors. PROVED. -/
theorem stemWinding_eq_of_homotopy (H : C(unitInterval × unitInterval, ℂ))
    (hne : ∀ q, H q ≠ 0) (hloops : ∀ s : unitInterval, H (s, 0) = H (s, 1))
    (γ₀ γ₁ : C(unitInterval, ℂ))
    (h₀ : ∀ t, γ₀ t = H (0, t)) (h₁ : ∀ t, γ₁ t = H (1, t)) :
    stemWinding γ₀ = stemWinding γ₁ := by
  -- bundle into the covering's base
  set Hs : C(unitInterval × unitInterval, {z : ℂ // z ≠ 0}) :=
    ⟨fun q => ⟨H q, hne q⟩, (map_continuous H).subtype_mk _⟩ with hHs_def
  -- the initial loop and its log-continuation
  have hγ₀ne : ∀ t, γ₀ t ≠ 0 := fun t => by
    rw [h₀ t]
    exact hne _
  obtain ⟨g₀, hg₀⟩ := exists_log_continuation γ₀ hγ₀ne
  have hH0 : ∀ t : unitInterval, Hs (0, t)
      = (fun z : ℂ => (⟨Complex.exp z, Complex.exp_ne_zero z⟩ : {z : ℂ // z ≠ 0})) (g₀ t) :=
    fun t => Subtype.ext (by
      show H (0, t) = Complex.exp (g₀ t)
      rw [hg₀ t]
      exact (h₀ t).symm)
  -- the lifted homotopy
  set H' : C(unitInterval × unitInterval, ℂ) :=
    Complex.isCoveringMap_exp.liftHomotopy Hs g₀ hH0 with hH'_def
  have hlifts : ∀ q, Complex.exp (H' q) = H q := fun q =>
    congrArg Subtype.val
      (congrFun (Complex.isCoveringMap_exp.liftHomotopy_lifts Hs g₀ hH0) q)
  -- the defect function: continuous, valued in the 2πiℤ lattice
  set d : unitInterval → ℂ := fun s => H' (s, 1) - H' (s, 0) with hd_def
  have hd_cont : Continuous d :=
    ((map_continuous H').comp (Continuous.prodMk_left 1)).sub
      ((map_continuous H').comp (Continuous.prodMk_left 0))
  have hd_lattice : ∀ s : unitInterval, ∃ k : ℤ,
      d s = (k : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) := by
    intro s
    set γs : C(unitInterval, ℂ) :=
      ⟨fun t => H (s, t), (map_continuous H).comp (Continuous.prodMk_right s)⟩
    set ls : C(unitInterval, ℂ) :=
      ⟨fun t => H' (s, t), (map_continuous H').comp (Continuous.prodMk_right s)⟩
    have hlp : ∀ t, Complex.exp (ls t) = γs t := fun t => hlifts (s, t)
    have hloop : γs 0 = γs 1 := hloops s
    obtain ⟨k, hk⟩ := winding_loop_defect γs hloop ls hlp
    exact ⟨k, hk⟩
  -- discreteness: the defect is constant on the connected interval
  have h2π_norm : ‖(2 * (Real.pi : ℂ) * Complex.I)‖ = 2 * Real.pi := by
    have hform : (2 * (Real.pi : ℂ) * Complex.I) = ((2 * Real.pi : ℝ) : ℂ) * Complex.I := by
      push_cast
      ring
    rw [hform, norm_mul, Complex.norm_I, mul_one, Complex.norm_real, Real.norm_eq_abs,
      abs_of_pos (by positivity)]
  have hd_const : d 1 = d 0 := by
    have hset : IsClopen {s : unitInterval | d s = d 0} := by
      constructor
      · exact isClosed_eq hd_cont continuous_const
      · rw [isOpen_iff_mem_nhds]
        intro s₀ hs₀
        have hball : d ⁻¹' Metric.ball (d s₀) (2 * Real.pi) ∈ nhds s₀ :=
          hd_cont.continuousAt.preimage_mem_nhds
            (Metric.ball_mem_nhds _ (by positivity))
        refine Filter.mem_of_superset hball ?_
        intro s hs
        obtain ⟨k, hk⟩ := hd_lattice s
        obtain ⟨k₀, hk₀⟩ := hd_lattice s₀
        have hdist : ‖d s - d s₀‖ < 2 * Real.pi := by
          rw [← dist_eq_norm]
          exact hs
        have hdiff : d s - d s₀ = ((k - k₀ : ℤ) : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) := by
          rw [hk, hk₀]
          push_cast
          ring
        have hnorm_eq : ‖d s - d s₀‖ = |((k - k₀ : ℤ) : ℝ)| * (2 * Real.pi) := by
          rw [hdiff, norm_mul, h2π_norm, Complex.norm_intCast]
        rw [hnorm_eq] at hdist
        have habs : |((k - k₀ : ℤ) : ℝ)| < 1 :=
          (mul_lt_iff_lt_one_left (by positivity)).mp hdist
        have hkk : k = k₀ := by
          have h1 : |k - k₀| < 1 := by exact_mod_cast habs
          have h2 := abs_lt.mp h1
          omega
        show d s = d 0
        rw [hk, hkk, ← hk₀]
        exact hs₀
    have huniv : {s : unitInterval | d s = d 0} = Set.univ := hset.eq_univ ⟨0, rfl⟩
    have h1 : (1 : unitInterval) ∈ {s : unitInterval | d s = d 0} := by
      rw [huniv]
      trivial
    exact h1
  -- read the two windings off the boundary lifts
  obtain ⟨k₀, hk₀⟩ := hd_lattice 0
  obtain ⟨k₁, hk₁⟩ := hd_lattice 1
  have hγ₁ne : ∀ t, γ₁ t ≠ 0 := fun t => by
    rw [h₁ t]
    exact hne _
  have hγ₀loop : γ₀ 0 = γ₀ 1 := by rw [h₀ 0, h₀ 1, hloops 0]
  have hγ₁loop : γ₁ 0 = γ₁ 1 := by rw [h₁ 0, h₁ 1, hloops 1]
  have hw₀ : stemWinding γ₀ = k₀ := by
    refine stemWinding_eq_of_lift γ₀ hγ₀ne hγ₀loop
      ⟨fun t => H' (0, t), (map_continuous H').comp (Continuous.prodMk_right 0)⟩
      (fun t => by
        show Complex.exp (H' (0, t)) = γ₀ t
        rw [hlifts (0, t)]
        exact (h₀ t).symm) k₀ ?_
    exact hk₀
  have hw₁ : stemWinding γ₁ = k₁ := by
    refine stemWinding_eq_of_lift γ₁ hγ₁ne hγ₁loop
      ⟨fun t => H' (1, t), (map_continuous H').comp (Continuous.prodMk_right 1)⟩
      (fun t => by
        show Complex.exp (H' (1, t)) = γ₁ t
        rw [hlifts (1, t)]
        exact (h₁ t).symm) k₁ ?_
    exact hk₁
  have hkk : k₁ = k₀ := by
    have h := hd_const
    rw [hk₁, hk₀] at h
    have h2πne : (2 * (Real.pi : ℂ) * Complex.I) ≠ 0 := by
      simp [Real.pi_ne_zero, Complex.I_ne_zero]
    have h3 := mul_right_cancel₀ h2πne h
    exact_mod_cast h3
  rw [hw₀, hw₁, hkk]

/-- **The convex-carrier row** (serves W2(d)): a continuous nonvanishing
function on a CONVEX carrier composes to a zero-winding loop — the domain
contraction to the loop's basepoint, pushed through g, is a free homotopy
of nonvanishing loops onto a constant (`stemWinding_eq_of_homotopy`). This
is the winding twin of E2's Cauchy–Goursat step, integral-free; in the
counting rows it retires the unit factors and the C3 complement on the
closed rectangle. PROVED. -/
theorem stemWinding_comp_eq_zero_of_convex {K : Set ℂ} (hK : Convex ℝ K)
    {g : ℂ → ℂ} (hg : ContinuousOn g K) (hgne : ∀ z ∈ K, g z ≠ 0)
    (γ : C(unitInterval, ℂ)) (hγK : ∀ t, γ t ∈ K) (hloop : γ 0 = γ 1)
    (Γ : C(unitInterval, ℂ)) (hΓ : ∀ t, Γ t = g (γ t)) :
    stemWinding Γ = 0 := by
  have hz₀K : γ 0 ∈ K := hγK 0
  set Φ : unitInterval × unitInterval → ℂ :=
    fun q => (1 - (q.1 : ℝ)) • γ q.2 + (q.1 : ℝ) • γ 0 with hΦ_def
  have hΦcont : Continuous Φ := by
    rw [hΦ_def]
    apply Continuous.add
    · exact (continuous_const.sub (continuous_subtype_val.comp continuous_fst)).smul
        ((map_continuous γ).comp continuous_snd)
    · exact (continuous_subtype_val.comp continuous_fst).smul continuous_const
  have hΦK : ∀ q, Φ q ∈ K := fun q =>
    hK (hγK q.2) hz₀K (sub_nonneg.mpr q.1.2.2) q.1.2.1 (by ring)
  set Hc : C(unitInterval × unitInterval, ℂ) :=
    ⟨fun q => g (Φ q), hg.comp_continuous hΦcont hΦK⟩ with hHc_def
  have hne : ∀ q, Hc q ≠ 0 := fun q => hgne _ (hΦK q)
  have hloops : ∀ s : unitInterval, Hc (s, 0) = Hc (s, 1) := by
    intro s
    show g ((1 - (s : ℝ)) • γ 0 + (s : ℝ) • γ 0)
      = g ((1 - (s : ℝ)) • γ 1 + (s : ℝ) • γ 0)
    rw [← hloop]
  have h₀γ : ∀ t, Γ t = Hc (0, t) := by
    intro t
    show Γ t = g ((1 - ((0 : unitInterval) : ℝ)) • γ t + ((0 : unitInterval) : ℝ) • γ 0)
    have h0 : ((0 : unitInterval) : ℝ) = 0 := rfl
    rw [h0, sub_zero, one_smul, zero_smul, add_zero, hΓ t]
  have h₁γ : ∀ t : unitInterval,
      (ContinuousMap.const unitInterval (g (γ 0))) t = Hc (1, t) := by
    intro t
    show g (γ 0)
      = g ((1 - ((1 : unitInterval) : ℝ)) • γ t + ((1 : unitInterval) : ℝ) • γ 0)
    have h1 : ((1 : unitInterval) : ℝ) = 1 := rfl
    rw [h1, sub_self, zero_smul, one_smul, zero_add]
  have h := stemWinding_eq_of_homotopy Hc hne hloops Γ
    (ContinuousMap.const unitInterval (g (γ 0))) h₀γ h₁γ
  rw [h, stemWinding_const _ (hgne _ hz₀K)]

/-- **The half-plane comparison row** (serves W2(d), the rectangle model):
two loops that share, at every time, a common open half-plane through 0 —
witnessed pointwise by c(t), no continuity required — have EQUAL windings:
the quotient loop avoids the closed negative reals (two vectors of a common
open half-plane are never antiparallel), so it winds zero by the slit-plane
row, and windings add along pointwise products. PROVED. -/
theorem stemWinding_eq_of_common_halfPlane (γ₁ γ₂ : C(unitInterval, ℂ))
    (hl₁ : γ₁ 0 = γ₁ 1) (hl₂ : γ₂ 0 = γ₂ 1) (c : unitInterval → ℂ)
    (h₁ : ∀ t, 0 < (c t * γ₁ t).re) (h₂ : ∀ t, 0 < (c t * γ₂ t).re) :
    stemWinding γ₁ = stemWinding γ₂ := by
  have hne₂ : ∀ t, γ₂ t ≠ 0 := by
    intro t h
    have hc := h₂ t
    rw [h, mul_zero] at hc
    simp at hc
  set δ : C(unitInterval, ℂ) :=
    ⟨fun t => γ₁ t / γ₂ t, (map_continuous γ₁).div (map_continuous γ₂) hne₂⟩ with hδ_def
  have hδval : ∀ t, δ t = γ₁ t / γ₂ t := fun t => rfl
  have hδslit : ∀ t, δ t ∈ Complex.slitPlane := by
    intro t
    rw [Complex.mem_slitPlane_iff]
    by_contra hcon
    push_neg at hcon
    obtain ⟨hre, him⟩ := hcon
    have hfac : γ₁ t = δ t * γ₂ t := by
      rw [hδval t, div_mul_cancel₀ _ (hne₂ t)]
    have hδre : δ t = (((δ t).re : ℝ) : ℂ) := by
      apply Complex.ext
      · rw [Complex.ofReal_re]
      · rw [Complex.ofReal_im]
        exact him
    have hmul : c t * γ₁ t = (((δ t).re : ℝ) : ℂ) * (c t * γ₂ t) := by
      conv_lhs => rw [hfac, hδre]
      ring
    have hkey : (c t * γ₁ t).re = (δ t).re * (c t * γ₂ t).re := by
      rw [hmul, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im]
      ring
    have hpos := h₁ t
    rw [hkey] at hpos
    nlinarith [h₂ t, hre]
  have hδne : ∀ t, δ t ≠ 0 := fun t => Complex.slitPlane_ne_zero (hδslit t)
  have hδloop : δ 0 = δ 1 := by
    rw [hδval 0, hδval 1, hl₁, hl₂]
  have hδwind : stemWinding δ = 0 := stemWinding_eq_zero_of_slitPlane δ hδloop hδslit
  have hγeq : γ₁ = γ₂ * δ := by
    ext t
    rw [ContinuousMap.mul_apply, hδval t, mul_comm, div_mul_cancel₀ _ (hne₂ t)]
  rw [hγeq, stemWinding_mul γ₂ δ hne₂ hδne hl₂ hδloop, hδwind, add_zero]

/-- **Half-plane loops wind zero** (serves W2(d) bookkeeping): a loop
confined to one open half-plane through 0 (witness constant c) winds zero —
compare with the constant loop conj c, which shares the half-plane since
c·conj c = |c|² > 0. PROVED. -/
theorem stemWinding_eq_zero_of_halfPlane (γ : C(unitInterval, ℂ)) (hloop : γ 0 = γ 1)
    (c : ℂ) (h : ∀ t, 0 < (c * γ t).re) : stemWinding γ = 0 := by
  have hc : c ≠ 0 := by
    intro hc0
    have h0 := h 0
    rw [hc0, zero_mul] at h0
    simp at h0
  have hconj_ne : starRingEnd ℂ c ≠ 0 := by
    rw [starRingEnd_apply]
    exact star_ne_zero.mpr hc
  have hconj : ∀ t : unitInterval,
      0 < (c * (ContinuousMap.const unitInterval (starRingEnd ℂ c)) t).re := by
    intro t
    show 0 < (c * starRingEnd ℂ c).re
    rw [Complex.mul_conj, Complex.ofReal_re]
    exact Complex.normSq_pos.mpr hc
  have h := stemWinding_eq_of_common_halfPlane γ
    (ContinuousMap.const unitInterval (starRingEnd ℂ c)) hloop rfl (fun _ => c) h hconj
  rw [h, stemWinding_const _ hconj_ne]

/-- **Winding additivity over finite products of loops** (serves W2(d)):
the finset form of `stemWinding_mul` — the integration-free argument
principle's summation layer. PROVED. -/
theorem stemWinding_finset_prod {ι : Type*} (s : Finset ι) (f : ι → C(unitInterval, ℂ))
    (hne : ∀ i ∈ s, ∀ t, f i t ≠ 0) (hloop : ∀ i ∈ s, f i 0 = f i 1) :
    stemWinding (∏ i ∈ s, f i) = ∑ i ∈ s, stemWinding (f i) := by
  induction s using Finset.cons_induction with
  | empty =>
    rw [Finset.prod_empty, Finset.sum_empty]
    have h1 : (1 : C(unitInterval, ℂ)) = ContinuousMap.const unitInterval 1 := by
      ext t
      rfl
    rw [h1, stemWinding_const 1 one_ne_zero]
  | cons a s ha ih =>
    have hmem : a ∈ Finset.cons a s ha := Finset.mem_cons.mpr (Or.inl rfl)
    have hne' : ∀ i ∈ s, ∀ t, f i t ≠ 0 :=
      fun i hi => hne i (Finset.mem_cons.mpr (Or.inr hi))
    have hloop' : ∀ i ∈ s, f i 0 = f i 1 :=
      fun i hi => hloop i (Finset.mem_cons.mpr (Or.inr hi))
    have hprod_ne : ∀ t, (∏ i ∈ s, f i) t ≠ 0 := by
      intro t
      rw [ContinuousMap.prod_apply]
      exact Finset.prod_ne_zero_iff.mpr fun i hi => hne' i hi t
    have hprod_loop : (∏ i ∈ s, f i) 0 = (∏ i ∈ s, f i) 1 := by
      rw [ContinuousMap.prod_apply, ContinuousMap.prod_apply]
      exact Finset.prod_congr rfl fun i hi => hloop' i hi
    rw [Finset.prod_cons, Finset.sum_cons,
      stemWinding_mul (f a) (∏ i ∈ s, f i) (fun t => hne a hmem t) hprod_ne
        (hloop a hmem) hprod_loop, ih hne' hloop']

/-! ## §E — W2(d): rectangles and the counting weld -/

/-- The open coordinate rectangle (the trap of the counting rows). -/
def openRect (x₁ x₂ y₁ y₂ : ℝ) : Set ℂ :=
  {z : ℂ | x₁ < z.re ∧ z.re < x₂ ∧ y₁ < z.im ∧ z.im < y₂}

/-- The closed coordinate rectangle (the convex carrier of the counting
rows). -/
def closedRect (x₁ x₂ y₁ y₂ : ℝ) : Set ℂ :=
  {z : ℂ | x₁ ≤ z.re ∧ z.re ≤ x₂ ∧ y₁ ≤ z.im ∧ z.im ≤ y₂}

/-- The closed rectangle is convex (intersection of four coordinate
half-planes; pin, R5 verified live: `convex_halfSpace_re_ge` and variants,
Mathlib/Analysis/Complex/Convex.lean). Serves W2(d): the convex-carrier row
applies on rectangles. PROVED. -/
theorem convex_closedRect (x₁ x₂ y₁ y₂ : ℝ) : Convex ℝ (closedRect x₁ x₂ y₁ y₂) := by
  have hset : closedRect x₁ x₂ y₁ y₂
      = {z : ℂ | x₁ ≤ z.re} ∩ ({z : ℂ | z.re ≤ x₂} ∩
        ({z : ℂ | y₁ ≤ z.im} ∩ {z : ℂ | z.im ≤ y₂})) := by
    ext z
    simp only [closedRect, Set.mem_setOf_eq, Set.mem_inter_iff]
  rw [hset]
  exact (convex_halfSpace_re_ge x₁).inter ((convex_halfSpace_re_le x₂).inter
    ((convex_halfSpace_im_ge y₁).inter (convex_halfSpace_im_le y₂)))

/-- The four-edge parametrization on [0,4]: bottom (left→right), right
(up), top (right→left), left (down). -/
noncomputable def rectAux (x₁ x₂ y₁ y₂ : ℝ) (τ : ℝ) : ℂ :=
  if τ ≤ 1 then ((x₁ + τ * (x₂ - x₁) : ℝ) : ℂ) + ((y₁ : ℝ) : ℂ) * Complex.I
  else if τ ≤ 2 then ((x₂ : ℝ) : ℂ) + ((y₁ + (τ - 1) * (y₂ - y₁) : ℝ) : ℂ) * Complex.I
  else if τ ≤ 3 then ((x₂ - (τ - 2) * (x₂ - x₁) : ℝ) : ℂ) + ((y₂ : ℝ) : ℂ) * Complex.I
  else ((x₁ : ℝ) : ℂ) + ((y₂ - (τ - 3) * (y₂ - y₁) : ℝ) : ℂ) * Complex.I

theorem rectAux_of_le_one {x₁ x₂ y₁ y₂ τ : ℝ} (h : τ ≤ 1) :
    rectAux x₁ x₂ y₁ y₂ τ
      = ((x₁ + τ * (x₂ - x₁) : ℝ) : ℂ) + ((y₁ : ℝ) : ℂ) * Complex.I := by
  unfold rectAux
  rw [if_pos h]

theorem rectAux_of_one_lt_le_two {x₁ x₂ y₁ y₂ τ : ℝ} (h1 : 1 < τ) (h2 : τ ≤ 2) :
    rectAux x₁ x₂ y₁ y₂ τ
      = ((x₂ : ℝ) : ℂ) + ((y₁ + (τ - 1) * (y₂ - y₁) : ℝ) : ℂ) * Complex.I := by
  unfold rectAux
  rw [if_neg (not_le.mpr h1), if_pos h2]

theorem rectAux_of_two_lt_le_three {x₁ x₂ y₁ y₂ τ : ℝ} (h2 : 2 < τ) (h3 : τ ≤ 3) :
    rectAux x₁ x₂ y₁ y₂ τ
      = ((x₂ - (τ - 2) * (x₂ - x₁) : ℝ) : ℂ) + ((y₂ : ℝ) : ℂ) * Complex.I := by
  unfold rectAux
  rw [if_neg (not_le.mpr (by linarith)), if_neg (not_le.mpr h2), if_pos h3]

theorem rectAux_of_three_lt {x₁ x₂ y₁ y₂ τ : ℝ} (h3 : 3 < τ) :
    rectAux x₁ x₂ y₁ y₂ τ
      = ((x₁ : ℝ) : ℂ) + ((y₂ - (τ - 3) * (y₂ - y₁) : ℝ) : ℂ) * Complex.I := by
  unfold rectAux
  rw [if_neg (not_le.mpr (by linarith)), if_neg (not_le.mpr (by linarith)),
    if_neg (not_le.mpr h3)]

/-- Continuity of the four-edge parametrization: three welds of
`Continuous.if_le` (pin, R5 verified live,
Mathlib/Topology/Order/OrderClosed.lean:646), the corner values matching.
PROVED. -/
theorem continuous_rectAux (x₁ x₂ y₁ y₂ : ℝ) : Continuous (rectAux x₁ x₂ y₁ y₂) := by
  unfold rectAux
  refine Continuous.if_le ?_ ?_ continuous_id continuous_const ?_
  · fun_prop
  · refine Continuous.if_le ?_ ?_ continuous_id continuous_const ?_
    · fun_prop
    · refine Continuous.if_le ?_ ?_ continuous_id continuous_const ?_
      · fun_prop
      · fun_prop
      · intro τ hτ
        rw [show (τ : ℝ) = 3 from hτ]
        push_cast
        ring
    · intro τ hτ
      rw [show (τ : ℝ) = 2 from hτ, if_pos (by norm_num : (2 : ℝ) ≤ 3)]
      push_cast
      ring
  · intro τ hτ
    rw [show (τ : ℝ) = 1 from hτ, if_pos (by norm_num : (1 : ℝ) ≤ 2)]
    push_cast
    ring

/-- **The rectangle boundary loop** (serves W2(d)): the positively-oriented
boundary of [x₁,x₂] × [y₁,y₂], traversed bottom–right–top–left from the
bottom-left corner. -/
noncomputable def rectLoop (x₁ x₂ y₁ y₂ : ℝ) : C(unitInterval, ℂ) :=
  ⟨fun t => rectAux x₁ x₂ y₁ y₂ (4 * (t : ℝ)),
    (continuous_rectAux x₁ x₂ y₁ y₂).comp (by fun_prop)⟩

theorem rectLoop_apply (x₁ x₂ y₁ y₂ : ℝ) (t : unitInterval) :
    rectLoop x₁ x₂ y₁ y₂ t = rectAux x₁ x₂ y₁ y₂ (4 * (t : ℝ)) := rfl

theorem rectLoop_closed (x₁ x₂ y₁ y₂ : ℝ) :
    rectLoop x₁ x₂ y₁ y₂ 0 = rectLoop x₁ x₂ y₁ y₂ 1 := by
  rw [rectLoop_apply, rectLoop_apply]
  have h0 : ((0 : unitInterval) : ℝ) = 0 := rfl
  have h1 : ((1 : unitInterval) : ℝ) = 1 := rfl
  rw [h0, h1, mul_zero, mul_one,
    rectAux_of_le_one (by norm_num), rectAux_of_three_lt (by norm_num)]
  push_cast
  ring

/-- The loop's image lies in the closed rectangle. PROVED. -/
theorem rectLoop_mem_closedRect {x₁ x₂ y₁ y₂ : ℝ} (hx : x₁ ≤ x₂) (hy : y₁ ≤ y₂)
    (t : unitInterval) : rectLoop x₁ x₂ y₁ y₂ t ∈ closedRect x₁ x₂ y₁ y₂ := by
  rw [rectLoop_apply]
  have h0 : (0 : ℝ) ≤ 4 * (t : ℝ) := by
    have := t.2.1
    linarith
  have h4 : 4 * (t : ℝ) ≤ 4 := by
    have := t.2.2
    linarith
  show x₁ ≤ _ ∧ _ ≤ x₂ ∧ y₁ ≤ _ ∧ _ ≤ y₂
  rcases le_or_gt (4 * (t : ℝ)) 1 with h1 | h1
  · rw [rectAux_of_le_one h1, addMulI_re, addMulI_im]
    refine ⟨?_, ?_, le_refl _, hy⟩
    · nlinarith [mul_nonneg h0 (sub_nonneg.mpr hx)]
    · nlinarith [mul_nonneg (sub_nonneg.mpr h1) (sub_nonneg.mpr hx)]
  · rcases le_or_gt (4 * (t : ℝ)) 2 with h2 | h2
    · rw [rectAux_of_one_lt_le_two h1 h2, addMulI_re, addMulI_im]
      refine ⟨hx, le_refl _, ?_, ?_⟩
      · nlinarith [mul_nonneg (by linarith : (0 : ℝ) ≤ 4 * (t : ℝ) - 1)
          (sub_nonneg.mpr hy)]
      · nlinarith [mul_nonneg (by linarith : (0 : ℝ) ≤ 2 - 4 * (t : ℝ))
          (sub_nonneg.mpr hy)]
    · rcases le_or_gt (4 * (t : ℝ)) 3 with h3 | h3
      · rw [rectAux_of_two_lt_le_three h2 h3, addMulI_re, addMulI_im]
        refine ⟨?_, ?_, hy, le_refl _⟩
        · nlinarith [mul_nonneg (by linarith : (0 : ℝ) ≤ 3 - 4 * (t : ℝ))
            (sub_nonneg.mpr hx)]
        · nlinarith [mul_nonneg (by linarith : (0 : ℝ) ≤ 4 * (t : ℝ) - 2)
            (sub_nonneg.mpr hx)]
      · rw [rectAux_of_three_lt h3, addMulI_re, addMulI_im]
        refine ⟨le_refl _, hx, ?_, ?_⟩
        · nlinarith [mul_nonneg (by linarith : (0 : ℝ) ≤ 4 - 4 * (t : ℝ))
            (sub_nonneg.mpr hy)]
        · nlinarith [mul_nonneg (by linarith : (0 : ℝ) ≤ 4 * (t : ℝ) - 3)
            (sub_nonneg.mpr hy)]

/-- The loop's image avoids the open rectangle: each edge pins one
coordinate to an edge value. PROVED. -/
theorem rectLoop_notMem_openRect (x₁ x₂ y₁ y₂ : ℝ) (t : unitInterval) :
    rectLoop x₁ x₂ y₁ y₂ t ∉ openRect x₁ x₂ y₁ y₂ := by
  rw [rectLoop_apply]
  intro hmem
  simp only [openRect, Set.mem_setOf_eq] at hmem
  rcases le_or_gt (4 * (t : ℝ)) 1 with h1 | h1
  · rw [rectAux_of_le_one h1] at hmem
    obtain ⟨-, -, h3, -⟩ := hmem
    rw [addMulI_im] at h3
    exact lt_irrefl _ h3
  · rcases le_or_gt (4 * (t : ℝ)) 2 with h2 | h2
    · rw [rectAux_of_one_lt_le_two h1 h2] at hmem
      obtain ⟨-, h2', -, -⟩ := hmem
      rw [addMulI_re] at h2'
      exact lt_irrefl _ h2'
    · rcases le_or_gt (4 * (t : ℝ)) 3 with h3 | h3
      · rw [rectAux_of_two_lt_le_three h2 h3] at hmem
        obtain ⟨-, -, -, h4'⟩ := hmem
        rw [addMulI_im] at h4'
        exact lt_irrefl _ h4'
      · rw [rectAux_of_three_lt h3] at hmem
        obtain ⟨h1', -, -, -⟩ := hmem
        rw [addMulI_re] at h1'
        exact lt_irrefl _ h1'

/-- The phase-aligned unit circle model: t ↦ exp(i(2πt − 3π/4)), starting
at the third-quadrant phase of the rectangle's bottom-left corner. Its four
quarter-arcs occupy the same four open half-planes as the rectangle's four
edges — the comparison partner of the model row. -/
noncomputable def phaseLoop : C(unitInterval, ℂ) :=
  ⟨fun t => Complex.exp (((2 * Real.pi * (t : ℝ) - 3 * Real.pi / 4 : ℝ) : ℂ) * Complex.I),
    by fun_prop⟩

theorem phaseLoop_apply (t : unitInterval) :
    phaseLoop t
      = Complex.exp (((2 * Real.pi * (t : ℝ) - 3 * Real.pi / 4 : ℝ) : ℂ) * Complex.I) := rfl

theorem phaseLoop_re (t : unitInterval) :
    (phaseLoop t).re = Real.cos (2 * Real.pi * (t : ℝ) - 3 * Real.pi / 4) := by
  rw [phaseLoop_apply, Complex.exp_re, ofReal_mul_I_re, ofReal_mul_I_im, Real.exp_zero,
    one_mul]

theorem phaseLoop_im (t : unitInterval) :
    (phaseLoop t).im = Real.sin (2 * Real.pi * (t : ℝ) - 3 * Real.pi / 4) := by
  rw [phaseLoop_apply, Complex.exp_im, ofReal_mul_I_re, ofReal_mul_I_im, Real.exp_zero,
    one_mul]

theorem phaseLoop_ne_zero (t : unitInterval) : phaseLoop t ≠ 0 := by
  rw [phaseLoop_apply]
  exact Complex.exp_ne_zero _

theorem phaseLoop_closed : phaseLoop 0 = phaseLoop 1 := by
  rw [phaseLoop_apply, phaseLoop_apply]
  have h0 : ((0 : unitInterval) : ℝ) = 0 := rfl
  have h1 : ((1 : unitInterval) : ℝ) = 1 := rfl
  rw [h0, h1]
  have harg : ((2 * Real.pi * 1 - 3 * Real.pi / 4 : ℝ) : ℂ) * Complex.I
      = ((2 * Real.pi * 0 - 3 * Real.pi / 4 : ℝ) : ℂ) * Complex.I
        + 2 * (Real.pi : ℂ) * Complex.I := by
    push_cast
    ring
  rw [harg, Complex.exp_add, Complex.exp_two_pi_mul_I, mul_one]

/-- The model winds once: the explicit lift is t ↦ i(2πt − 3π/4). PROVED. -/
theorem stemWinding_phaseLoop : stemWinding phaseLoop = 1 := by
  have hcont : Continuous fun t : unitInterval =>
      ((2 * Real.pi * (t : ℝ) - 3 * Real.pi / 4 : ℝ) : ℂ) * Complex.I := by fun_prop
  refine stemWinding_eq_of_lift phaseLoop phaseLoop_ne_zero phaseLoop_closed
    ⟨_, hcont⟩ (fun t => rfl) 1 ?_
  show ((2 * Real.pi * ((1 : unitInterval) : ℝ) - 3 * Real.pi / 4 : ℝ) : ℂ) * Complex.I
      - ((2 * Real.pi * ((0 : unitInterval) : ℝ) - 3 * Real.pi / 4 : ℝ) : ℂ) * Complex.I = _
  have h0 : ((0 : unitInterval) : ℝ) = 0 := rfl
  have h1 : ((1 : unitInterval) : ℝ) = 1 := rfl
  rw [h0, h1]
  push_cast
  ring

/-- **THE RECTANGLE MODEL ROW** (serves W2(d)): the rectangle boundary
winds exactly ONCE about every interior point. Integral-free and
homotopy-free: on each of the four quarters, the shifted boundary and the
phase-aligned circle model lie in one common open coordinate half-plane
(edges by construction, arcs by the sine/cosine sign lemmas), so the
half-plane comparison row equates the windings, and the model's winding is
its explicit lift's. This is E3's `stemWinding_circleLoop_sub_center` in
rectangle form — the local counting geometry the four-edge decomposition
needs. PROVED. -/
theorem stemWinding_rectLoop_sub_interior {x₁ x₂ y₁ y₂ : ℝ} {w : ℂ}
    (hw : w ∈ openRect x₁ x₂ y₁ y₂)
    (δ : C(unitInterval, ℂ)) (hδ : ∀ t, δ t = rectLoop x₁ x₂ y₁ y₂ t - w) :
    stemWinding δ = 1 := by
  simp only [openRect, Set.mem_setOf_eq] at hw
  obtain ⟨hw1, hw2, hw3, hw4⟩ := hw
  have hδloop : δ 0 = δ 1 := by
    rw [hδ 0, hδ 1, rectLoop_closed]
  set c : unitInterval → ℂ := fun t =>
    if 4 * (t : ℝ) ≤ 1 then Complex.I
    else if 4 * (t : ℝ) ≤ 2 then 1
    else if 4 * (t : ℝ) ≤ 3 then -Complex.I
    else -1 with hc_def
  have hπ := Real.pi_pos
  have key : ∀ t : unitInterval, 0 < (c t * δ t).re ∧ 0 < (c t * phaseLoop t).re := by
    intro t
    have ht0 : (0 : ℝ) ≤ (t : ℝ) := t.2.1
    have ht1 : (t : ℝ) ≤ 1 := t.2.2
    rcases le_or_gt (4 * (t : ℝ)) 1 with h1 | h1
    · have hct : c t = Complex.I := by
        rw [hc_def]
        simp only [if_pos h1]
      constructor
      · rw [hct, hδ t, rectLoop_apply, rectAux_of_le_one h1, I_mul_re, Complex.sub_im,
          addMulI_im]
        linarith
      · rw [hct, I_mul_re, phaseLoop_im]
        have hθub : 2 * Real.pi * (t : ℝ) - 3 * Real.pi / 4 ≤ -(Real.pi / 4) := by
          have hmul : 2 * Real.pi * (t : ℝ) ≤ 2 * Real.pi * (1 / 4) :=
            mul_le_mul_of_nonneg_left (by linarith) (by positivity)
          linarith
        have hθlb : -Real.pi < 2 * Real.pi * (t : ℝ) - 3 * Real.pi / 4 := by
          have hmul : 0 ≤ 2 * Real.pi * (t : ℝ) := by positivity
          linarith
        have hsin := Real.sin_neg_of_neg_of_neg_pi_lt (by linarith) hθlb
        linarith
    · rcases le_or_gt (4 * (t : ℝ)) 2 with h2 | h2
      · have hct : c t = 1 := by
          rw [hc_def]
          simp only [if_neg (not_le.mpr h1), if_pos h2]
        constructor
        · rw [hct, one_mul, hδ t, rectLoop_apply, rectAux_of_one_lt_le_two h1 h2,
            Complex.sub_re, addMulI_re]
          linarith
        · rw [hct, one_mul, phaseLoop_re]
          have hθlb : -(Real.pi / 4) < 2 * Real.pi * (t : ℝ) - 3 * Real.pi / 4 := by
            have hmul : 2 * Real.pi * (1 / 4) < 2 * Real.pi * (t : ℝ) :=
              mul_lt_mul_of_pos_left (by linarith) (by positivity)
            linarith
          have hθub : 2 * Real.pi * (t : ℝ) - 3 * Real.pi / 4 ≤ Real.pi / 4 := by
            have hmul : 2 * Real.pi * (t : ℝ) ≤ 2 * Real.pi * (1 / 2) :=
              mul_le_mul_of_nonneg_left (by linarith) (by positivity)
            linarith
          exact Real.cos_pos_of_mem_Ioo ⟨by linarith, by linarith⟩
      · rcases le_or_gt (4 * (t : ℝ)) 3 with h3 | h3
        · have hct : c t = -Complex.I := by
            rw [hc_def]
            simp only [if_neg (not_le.mpr h1), if_neg (not_le.mpr h2), if_pos h3]
          constructor
          · rw [hct, hδ t, rectLoop_apply, rectAux_of_two_lt_le_three h2 h3, neg_I_mul_re,
              Complex.sub_im, addMulI_im]
            linarith
          · rw [hct, neg_I_mul_re, phaseLoop_im]
            have hθlb : Real.pi / 4 < 2 * Real.pi * (t : ℝ) - 3 * Real.pi / 4 := by
              have hmul : 2 * Real.pi * (1 / 2) < 2 * Real.pi * (t : ℝ) :=
                mul_lt_mul_of_pos_left (by linarith) (by positivity)
              linarith
            have hθub : 2 * Real.pi * (t : ℝ) - 3 * Real.pi / 4 ≤ 3 * Real.pi / 4 := by
              have hmul : 2 * Real.pi * (t : ℝ) ≤ 2 * Real.pi * (3 / 4) :=
                mul_le_mul_of_nonneg_left (by linarith) (by positivity)
              linarith
            have hsin := Real.sin_pos_of_pos_of_lt_pi (x := 2 * Real.pi * (t : ℝ)
              - 3 * Real.pi / 4) (by linarith) (by linarith)
            linarith
        · have hct : c t = -1 := by
            rw [hc_def]
            simp only [if_neg (not_le.mpr h1), if_neg (not_le.mpr h2),
              if_neg (not_le.mpr h3)]
          constructor
          · rw [hct, neg_one_mul_re, hδ t, rectLoop_apply, rectAux_of_three_lt h3,
              Complex.sub_re, addMulI_re]
            linarith
          · rw [hct, neg_one_mul_re, phaseLoop_re]
            have hθlb : 3 * Real.pi / 4 < 2 * Real.pi * (t : ℝ) - 3 * Real.pi / 4 := by
              have hmul : 2 * Real.pi * (3 / 4) < 2 * Real.pi * (t : ℝ) :=
                mul_lt_mul_of_pos_left (by linarith) (by positivity)
              linarith
            have hθub : 2 * Real.pi * (t : ℝ) - 3 * Real.pi / 4 ≤ 5 * Real.pi / 4 := by
              have hmul : 2 * Real.pi * (t : ℝ) ≤ 2 * Real.pi * 1 :=
                mul_le_mul_of_nonneg_left ht1 (by positivity)
              linarith
            have hcos := Real.cos_neg_of_pi_div_two_lt_of_lt
              (x := 2 * Real.pi * (t : ℝ) - 3 * Real.pi / 4) (by linarith) (by linarith)
            linarith
  have h := stemWinding_eq_of_common_halfPlane δ phaseLoop hδloop phaseLoop_closed c
    (fun t => (key t).1) (fun t => (key t).2)
  rw [h, stemWinding_phaseLoop]

namespace ASection

/-- The head finsets exist for rectangles: the open rectangle is bounded,
so `c3_atN`'s quadratic point-density traps finitely many indices
(`indices_in_closedBall_finite`, PairingE2.lean). Serves W2(d). PROVED. -/
theorem exists_rect_head_finset (A : ASection) (x₁ x₂ y₁ y₂ : ℝ) :
    ∃ s : Finset ℕ, ∀ k, k ∈ s ↔ A.sphereZero k ∈ openRect x₁ x₂ y₁ y₂ := by
  have hsub : {k : ℕ | A.sphereZero k ∈ openRect x₁ x₂ y₁ y₂}
      ⊆ {k : ℕ | A.sphereZero k ∈ Metric.closedBall 0 (|x₁| + |x₂| + |y₁| + |y₂|)} := by
    intro k hk
    simp only [openRect, Set.mem_setOf_eq] at hk
    obtain ⟨h1, h2, h3, h4⟩ := hk
    simp only [Set.mem_setOf_eq, Metric.mem_closedBall, dist_zero_right]
    have hre : |(A.sphereZero k).re| ≤ |x₁| + |x₂| :=
      abs_le.mpr ⟨by linarith [neg_abs_le x₁, abs_nonneg x₂],
        by linarith [le_abs_self x₂, abs_nonneg x₁]⟩
    have him : |(A.sphereZero k).im| ≤ |y₁| + |y₂| :=
      abs_le.mpr ⟨by linarith [neg_abs_le y₁, abs_nonneg y₂],
        by linarith [le_abs_self y₂, abs_nonneg y₁]⟩
    calc ‖A.sphereZero k‖ ≤ |(A.sphereZero k).re| + |(A.sphereZero k).im| :=
        Complex.norm_le_abs_re_add_abs_im _
      _ ≤ |x₁| + |x₂| + (|y₁| + |y₂|) := add_le_add hre him
      _ = |x₁| + |x₂| + |y₁| + |y₂| := by ring
  have hfin : {k : ℕ | A.sphereZero k ∈ openRect x₁ x₂ y₁ y₂}.Finite :=
    (A.indices_in_closedBall_finite 0 (|x₁| + |x₂| + |y₁| + |y₂|)).subset hsub
  exact ⟨hfin.toFinset, fun k => hfin.mem_toFinset⟩

/-- **W2(d) — THE COUNTING WELD, the class-wide finite-rectangle counting
row** (E2's finite-contour residue ledger and E3's winding rows, joined):
for an upper-half rectangle whose frame (closed minus open) carries no
enumerated zero, the winding of the section's value-loop along the boundary
EQUALS the number of enumerated zeros the open rectangle traps — with the
enumeration's multiplicity, each index its own term. Poles accounted: C1's
one pole is real, hence outside every upper-half rectangle, and the pole
factor of the §8-repaired complement is retired by the convex-carrier row
with everything else.

Assembly: the global head/complement split `eq_head_mul_complement`
(PairingE2.lean) at loop level; windings add over the finite product
(`stemWinding_finset_prod`); each trapped index contributes its linear
factor's winding 1 (`stemWinding_rectLoop_sub_interior`) plus its unit's 0
(`stemWinding_comp_eq_zero_of_convex` — sphereUnit is nonvanishing on the
closed upper rectangle, its only zero being the conjugate); the complement
is analytic and nonvanishing on the convex closed rectangle
(`sphereComplement_analyticAt` / `_ne_zero`), so it winds 0. VALUE register
(the winding of A's value-loop) equals DOMAIN register (the trapped divisor
count): the zeros arrive as winding, the theorem's OUTPUT (R4); never an
integral. PROVED. -/
theorem stemWinding_F_rectLoop (A : ASection) {x₁ x₂ y₁ y₂ : ℝ}
    (hx : x₁ < x₂) (hy : y₁ < y₂) (hy₁ : 0 < y₁)
    (hframe : ∀ k, A.sphereZero k ∈ closedRect x₁ x₂ y₁ y₂ →
      A.sphereZero k ∈ openRect x₁ x₂ y₁ y₂)
    {s : Finset ℕ} (hs : ∀ k, k ∈ s ↔ A.sphereZero k ∈ openRect x₁ x₂ y₁ y₂)
    (Γ : C(unitInterval, ℂ)) (hΓ : ∀ t, Γ t = A.F (rectLoop x₁ x₂ y₁ y₂ t)) :
    stemWinding Γ = s.card := by
  classical
  -- pointwise facts on the closed rectangle
  have hKim : ∀ w ∈ closedRect x₁ x₂ y₁ y₂, 0 < w.im := fun w hw =>
    lt_of_lt_of_le hy₁ hw.2.2.1
  have hKfacts : ∀ w ∈ closedRect x₁ x₂ y₁ y₂, w ≠ (A.pole : ℂ) ∧ w ≠ 0 ∧
      A.Rfac w ≠ 0 ∧ ∀ k, w ≠ starRingEnd ℂ (A.sphereZero k) := by
    intro w hw
    have hwim : 0 < w.im := hKim w hw
    refine ⟨?_, ?_, ?_, ?_⟩
    · intro h
      rw [h] at hwim
      simp at hwim
    · intro h
      rw [h] at hwim
      simp at hwim
    · intro h
      exact absurd (A.c3_R_zeros_real w h).1 (ne_of_gt hwim)
    · intro k h
      have h2 : w.im = -(A.sphereZero k).im := by
        rw [h, Complex.conj_im]
      have := A.c3_sphere_nonreal k
      linarith
  have hρ0 : ∀ k, A.sphereZero k ≠ 0 := by
    intro k h
    have := A.c3_sphere_nonreal k
    rw [h] at this
    simp at this
  -- the loop's image: on the frame
  have hzK : ∀ t, rectLoop x₁ x₂ y₁ y₂ t ∈ closedRect x₁ x₂ y₁ y₂ := fun t =>
    rectLoop_mem_closedRect hx.le hy.le t
  have hzopen : ∀ t, rectLoop x₁ x₂ y₁ y₂ t ∉ openRect x₁ x₂ y₁ y₂ := fun t =>
    rectLoop_notMem_openRect _ _ _ _ t
  have hzρ : ∀ t k, rectLoop x₁ x₂ y₁ y₂ t ≠ A.sphereZero k := by
    intro t k h
    have h1 : A.sphereZero k ∈ closedRect x₁ x₂ y₁ y₂ := by
      rw [← h]
      exact hzK t
    have h2 := hframe k h1
    rw [← h] at h2
    exact hzopen t h2
  -- primary factors nonvanishing on the carrier (tail indices) and along the loop (all)
  have htail_ne : ∀ w ∈ closedRect x₁ x₂ y₁ y₂, ∀ k, k ∉ s →
      spherePrimary (A.genus k) (A.sphereZero k) w ≠ 0 := by
    intro w hw k hk
    refine spherePrimary_ne_zero _ (hρ0 k) ?_ ((hKfacts w hw).2.2.2 k)
    intro h
    have h1 : A.sphereZero k ∈ closedRect x₁ x₂ y₁ y₂ := by
      rw [← h]
      exact hw
    exact hk ((hs k).mpr (hframe k h1))
  have hloop_ne : ∀ t k, spherePrimary (A.genus k) (A.sphereZero k)
      (rectLoop x₁ x₂ y₁ y₂ t) ≠ 0 := fun t k =>
    spherePrimary_ne_zero _ (hρ0 k) (hzρ t k)
      ((hKfacts _ (hzK t)).2.2.2 k)
  -- the complement: analytic and nonvanishing on the convex carrier
  have hcomp_ne : ∀ w ∈ closedRect x₁ x₂ y₁ y₂, A.sphereComplement s w ≠ 0 := by
    intro w hw
    obtain ⟨hzp, hz0, hR, -⟩ := hKfacts w hw
    exact A.sphereComplement_ne_zero s hzp hz0 hR (fun k hk => htail_ne w hw k hk)
  have hcomp_cont : ContinuousOn (A.sphereComplement s) (closedRect x₁ x₂ y₁ y₂) :=
    fun w hw =>
      ((A.sphereComplement_analyticAt s (hKfacts w hw).1).continuousAt).continuousWithinAt
  -- bundle the loops
  have hzcont : Continuous fun t : unitInterval => rectLoop x₁ x₂ y₁ y₂ t :=
    map_continuous _
  have hzloop : rectLoop x₁ x₂ y₁ y₂ 0 = rectLoop x₁ x₂ y₁ y₂ 1 :=
    rectLoop_closed _ _ _ _
  set P : ℕ → C(unitInterval, ℂ) := fun k =>
    ⟨fun t => spherePrimary (A.genus k) (A.sphereZero k) (rectLoop x₁ x₂ y₁ y₂ t),
      ((differentiable_spherePrimary _ _).continuous).comp hzcont⟩ with hP_def
  set Cl : C(unitInterval, ℂ) :=
    ⟨fun t => A.sphereComplement s (rectLoop x₁ x₂ y₁ y₂ t),
      hcomp_cont.comp_continuous hzcont hzK⟩ with hCl_def
  have hΓfac : Γ = (∏ k ∈ s, P k) * Cl := by
    ext t
    rw [ContinuousMap.mul_apply, ContinuousMap.prod_apply]
    show Γ t = (∏ k ∈ s, spherePrimary (A.genus k) (A.sphereZero k)
      (rectLoop x₁ x₂ y₁ y₂ t)) * A.sphereComplement s (rectLoop x₁ x₂ y₁ y₂ t)
    rw [hΓ t]
    exact A.eq_head_mul_complement s (hKfacts _ (hzK t)).1
  -- winding bookkeeping
  have hP_ne : ∀ k ∈ s, ∀ t, P k t ≠ 0 := fun k _ t => hloop_ne t k
  have hP_loop : ∀ k ∈ s, P k 0 = P k 1 := by
    intro k _
    show spherePrimary _ _ (rectLoop x₁ x₂ y₁ y₂ 0)
      = spherePrimary _ _ (rectLoop x₁ x₂ y₁ y₂ 1)
    rw [hzloop]
  have hprod_ne : ∀ t, (∏ k ∈ s, P k) t ≠ 0 := by
    intro t
    rw [ContinuousMap.prod_apply]
    exact Finset.prod_ne_zero_iff.mpr fun k _ => hloop_ne t k
  have hprod_loop : (∏ k ∈ s, P k) 0 = (∏ k ∈ s, P k) 1 := by
    rw [ContinuousMap.prod_apply, ContinuousMap.prod_apply]
    exact Finset.prod_congr rfl fun k hk => hP_loop k hk
  have hCl_ne : ∀ t, Cl t ≠ 0 := fun t => hcomp_ne _ (hzK t)
  have hCl_loop : Cl 0 = Cl 1 := by
    show A.sphereComplement s (rectLoop x₁ x₂ y₁ y₂ 0)
      = A.sphereComplement s (rectLoop x₁ x₂ y₁ y₂ 1)
    rw [hzloop]
  have hCl_wind : stemWinding Cl = 0 :=
    stemWinding_comp_eq_zero_of_convex (convex_closedRect x₁ x₂ y₁ y₂) hcomp_cont
      hcomp_ne (rectLoop x₁ x₂ y₁ y₂) hzK hzloop Cl (fun t => rfl)
  -- per-index winding: 1 (interior linear factor) + 0 (unit factor)
  have hP_wind : ∀ k ∈ s, stemWinding (P k) = 1 := by
    intro k hk
    set δk : C(unitInterval, ℂ) :=
      ⟨fun t => rectLoop x₁ x₂ y₁ y₂ t - A.sphereZero k,
        hzcont.sub continuous_const⟩ with hδk_def
    set Uk : C(unitInterval, ℂ) :=
      ⟨fun t => sphereUnit (A.genus k) (A.sphereZero k) (rectLoop x₁ x₂ y₁ y₂ t),
        (differentiable_sphereUnit _ _).continuous.comp hzcont⟩ with hUk_def
    have hpeel : P k = δk * Uk := by
      ext t
      rw [ContinuousMap.mul_apply]
      show spherePrimary (A.genus k) (A.sphereZero k) (rectLoop x₁ x₂ y₁ y₂ t)
        = (rectLoop x₁ x₂ y₁ y₂ t - A.sphereZero k)
          * sphereUnit (A.genus k) (A.sphereZero k) (rectLoop x₁ x₂ y₁ y₂ t)
      exact spherePrimary_eq_sub_mul_sphereUnit _ (hρ0 k) _
    have hδk_ne : ∀ t, δk t ≠ 0 := fun t => sub_ne_zero.mpr (hzρ t k)
    have hδk_loop : δk 0 = δk 1 := by
      show rectLoop x₁ x₂ y₁ y₂ 0 - _ = rectLoop x₁ x₂ y₁ y₂ 1 - _
      rw [hzloop]
    have hUk_ne : ∀ t, Uk t ≠ 0 := fun t =>
      sphereUnit_ne_zero _ (hρ0 k) ((hKfacts _ (hzK t)).2.2.2 k)
    have hUk_loop : Uk 0 = Uk 1 := by
      show sphereUnit _ _ (rectLoop x₁ x₂ y₁ y₂ 0)
        = sphereUnit _ _ (rectLoop x₁ x₂ y₁ y₂ 1)
      rw [hzloop]
    have hδk_wind : stemWinding δk = 1 :=
      stemWinding_rectLoop_sub_interior ((hs k).mp hk) δk (fun t => rfl)
    have hUk_wind : stemWinding Uk = 0 :=
      stemWinding_comp_eq_zero_of_convex (convex_closedRect x₁ x₂ y₁ y₂)
        ((differentiable_sphereUnit _ _).continuous.continuousOn)
        (fun w hw => sphereUnit_ne_zero _ (hρ0 k) ((hKfacts w hw).2.2.2 k))
        (rectLoop x₁ x₂ y₁ y₂) hzK hzloop Uk (fun t => rfl)
    rw [hpeel, stemWinding_mul δk Uk hδk_ne hUk_ne hδk_loop hUk_loop, hδk_wind, hUk_wind,
      add_zero]
  -- assemble
  rw [hΓfac, stemWinding_mul _ Cl hprod_ne hCl_ne hprod_loop hCl_loop, hCl_wind, add_zero,
    stemWinding_finset_prod s P hP_ne hP_loop, Finset.sum_congr rfl hP_wind,
    Finset.sum_const, nsmul_eq_mul, mul_one]

/-- **W2(d) — the strip-spanning instance (the class-wide N(T) row)**: for
a rectangle whose left edge sits left of the divisor's lower edge (zero-free
wall, §C) and whose right edge sits right of Ω₀ (zero-free wall, C2; its
argument majorant-controlled, §B), the frame condition on the vertical
edges is AUTOMATIC — only the two horizontal lines need to miss the
divisor's heights — and the trapped set is exactly the full height window:
the winding of A's value-loop along the spanning boundary counts ALL
enumerated zeros with y₁ < Im < y₂, with multiplicity. PROVED. -/
theorem stemWinding_F_stripRect (A : ASection) {βlo x₁ x₂ y₁ y₂ : ℝ}
    (hβ : ∀ k : ℕ, βlo ≤ (A.sphereZero k).re) (hx₁ : x₁ < βlo) (hx₂ : A.Ω₀ < x₂)
    (hy : y₁ < y₂) (hy₁ : 0 < y₁)
    (hY₁ : ∀ k, (A.sphereZero k).im ≠ y₁) (hY₂ : ∀ k, (A.sphereZero k).im ≠ y₂)
    {s : Finset ℕ} (hs : ∀ k, k ∈ s ↔ A.sphereZero k ∈ openRect x₁ x₂ y₁ y₂)
    (Γ : C(unitInterval, ℂ)) (hΓ : ∀ t, Γ t = A.F (rectLoop x₁ x₂ y₁ y₂ t)) :
    stemWinding Γ = s.card ∧
      ∀ k, k ∈ s ↔ y₁ < (A.sphereZero k).im ∧ (A.sphereZero k).im < y₂ := by
  have hxle : x₁ < x₂ := by
    have h1 := hβ 0
    have h2 := A.re_le_upperEdge 0
    linarith
  have hframe : ∀ k, A.sphereZero k ∈ closedRect x₁ x₂ y₁ y₂ →
      A.sphereZero k ∈ openRect x₁ x₂ y₁ y₂ := by
    intro k hk
    obtain ⟨-, -, h3, h4⟩ := hk
    exact ⟨lt_of_lt_of_le hx₁ (hβ k), lt_of_le_of_lt (A.re_le_upperEdge k) hx₂,
      lt_of_le_of_ne h3 (hY₁ k).symm, lt_of_le_of_ne h4 (hY₂ k)⟩
  refine ⟨A.stemWinding_F_rectLoop hxle hy hy₁ hframe hs Γ hΓ, ?_⟩
  intro k
  rw [hs k]
  constructor
  · intro hk
    exact ⟨hk.2.2.1, hk.2.2.2⟩
  · intro hk
    exact ⟨lt_of_lt_of_le hx₁ (hβ k), lt_of_le_of_lt (A.re_le_upperEdge k) hx₂,
      hk.1, hk.2⟩

/-- **W2(c) companion — value-loops in the left region wind zero**: the
region {Im > 0, Re < βlo} is convex, A is analytic there (the pole is
real) and zero-free there (§C's left wall), so the convex-carrier row
retires it — the left twin of `stemWinding_F_halfSpace`. Serves W2(d):
neither wall region can hold any of the counting's winding. PROVED. -/
theorem stemWinding_F_leftRegion (A : ASection) {βlo : ℝ}
    (hβ : ∀ k : ℕ, βlo ≤ (A.sphereZero k).re)
    (γ : C(unitInterval, ℂ)) (hγim : ∀ t, 0 < (γ t).im) (hγre : ∀ t, (γ t).re < βlo)
    (hloop : γ 0 = γ 1) (Γ : C(unitInterval, ℂ)) (hΓ : ∀ t, Γ t = A.F (γ t)) :
    stemWinding Γ = 0 := by
  set K : Set ℂ := {z : ℂ | 0 < z.im} ∩ {z : ℂ | z.re < βlo} with hK_def
  have hKconv : Convex ℝ K := (convex_halfSpace_im_gt 0).inter (convex_halfSpace_re_lt βlo)
  have hKne : ∀ w ∈ K, w ≠ (A.pole : ℂ) := by
    intro w hw h
    have him : 0 < w.im := hw.1
    rw [h] at him
    simp at him
  have hFcont : ContinuousOn A.F K := fun w hw =>
    ((A.c1_analyticAt w (hKne w hw)).continuousAt).continuousWithinAt
  have hFne : ∀ w ∈ K, A.F w ≠ 0 := fun w hw =>
    A.F_ne_zero_of_re_lt_lowerEdge hβ hw.1 hw.2
  exact stemWinding_comp_eq_zero_of_convex hKconv hFcont hFne γ
    (fun t => ⟨hγim t, hγre t⟩) hloop Γ hΓ

/-! ## §F — the drive at the target's minimal face -/

/-- **THE DRIVE (W1+W2 assembled at the target's minimal face)**: two
enumerated zeros at distinct levels yield a line Re = β strictly between
them and two admissible rectangles — strictly left and strictly right of
the line, frames chosen off the divisor's countable coordinate sets — each
trapping its zero, each with the section's value-loop winding EQUAL to its
own trapped count (≥ 1). E3's `sigma_level_separation` produced windings
≥ 1 on circles; the counting weld sharpens both sides to exact counts on
rectangles.

VERDICT OF RECORD (R6; the report's residual, not a sorry): the counting
rows pin each rectangle's winding to ITS OWN trapped count — additivity
across rectangles and nothing more. No fed possession relates the LEFT
count to the RIGHT count, because for every admissible rectangle the
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
The missing producer is the same seam as E3's receipt and E1's audit: the
cross-contour constraint `eq:placement-set` ≡ ∃β two-sided
(`auditE1_target_iff_two_sided`). PROVED (the row itself). -/
theorem counting_pair_of_two_levels (A : ASection) {n m : ℕ}
    (hsep : (A.sphereZero n).re < (A.sphereZero m).re) :
    ∃ β : ℝ, (A.sphereZero n).re < β ∧ β < (A.sphereZero m).re ∧
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
          stemWinding Γn = sn.card ∧ stemWinding Γm = sm.card := by
  classical
  -- the coordinate picker: a point of any open interval off a countable set
  have hpick : ∀ a b : ℝ, a < b → ∀ S : Set ℝ, S.Countable →
      ∃ x, a < x ∧ x < b ∧ x ∉ S := by
    intro a b hab S hS
    obtain ⟨x, hxc, hxI⟩ := (Set.Countable.dense_compl ℝ hS).exists_mem_open isOpen_Ioo
      (⟨(a + b) / 2, by constructor <;> [linarith; linarith]⟩ :
        Set.Nonempty (Set.Ioo a b))
    exact ⟨x, hxI.1, hxI.2, hxc⟩
  set Xre : Set ℝ := Set.range fun k => (A.sphereZero k).re with hXre_def
  set Yim : Set ℝ := Set.range fun k => (A.sphereZero k).im with hYim_def
  have hXcnt : Xre.Countable := Set.countable_range _
  have hYcnt : Yim.Countable := Set.countable_range _
  have hXne : ∀ x, x ∉ Xre → ∀ k, (A.sphereZero k).re ≠ x := by
    intro x hx k h
    exact hx ⟨k, h⟩
  have hYne : ∀ y, y ∉ Yim → ∀ k, (A.sphereZero k).im ≠ y := by
    intro y hy k h
    exact hy ⟨k, h⟩
  set β : ℝ := ((A.sphereZero n).re + (A.sphereZero m).re) / 2 with hβ_def
  have hβn : (A.sphereZero n).re < β := by
    rw [hβ_def]
    linarith
  have hβm : β < (A.sphereZero m).re := by
    rw [hβ_def]
    linarith
  have hnim : 0 < (A.sphereZero n).im := A.c3_sphere_nonreal n
  have hmim : 0 < (A.sphereZero m).im := A.c3_sphere_nonreal m
  -- the eight coordinates
  obtain ⟨xn₁, hxn₁a, hxn₁b, hxn₁X⟩ :=
    hpick ((A.sphereZero n).re - 1) ((A.sphereZero n).re) (by linarith) Xre hXcnt
  obtain ⟨xn₂, hxn₂a, hxn₂b, hxn₂X⟩ :=
    hpick ((A.sphereZero n).re) β hβn Xre hXcnt
  obtain ⟨yn₁, hyn₁a, hyn₁b, hyn₁Y⟩ :=
    hpick 0 ((A.sphereZero n).im) hnim Yim hYcnt
  obtain ⟨yn₂, hyn₂a, hyn₂b, hyn₂Y⟩ :=
    hpick ((A.sphereZero n).im) ((A.sphereZero n).im + 1) (by linarith) Yim hYcnt
  obtain ⟨xm₁, hxm₁a, hxm₁b, hxm₁X⟩ :=
    hpick β ((A.sphereZero m).re) hβm Xre hXcnt
  obtain ⟨xm₂, hxm₂a, hxm₂b, hxm₂X⟩ :=
    hpick ((A.sphereZero m).re) ((A.sphereZero m).re + 1) (by linarith) Xre hXcnt
  obtain ⟨ym₁, hym₁a, hym₁b, hym₁Y⟩ :=
    hpick 0 ((A.sphereZero m).im) hmim Yim hYcnt
  obtain ⟨ym₂, hym₂a, hym₂b, hym₂Y⟩ :=
    hpick ((A.sphereZero m).im) ((A.sphereZero m).im + 1) (by linarith) Yim hYcnt
  -- frame conditions: no divisor point on either frame
  have hframen : ∀ k, A.sphereZero k ∈ closedRect xn₁ xn₂ yn₁ yn₂ →
      A.sphereZero k ∈ openRect xn₁ xn₂ yn₁ yn₂ := by
    intro k hk
    obtain ⟨h1, h2, h3, h4⟩ := hk
    exact ⟨lt_of_le_of_ne h1 (hXne xn₁ hxn₁X k).symm,
      lt_of_le_of_ne h2 (hXne xn₂ hxn₂X k),
      lt_of_le_of_ne h3 (hYne yn₁ hyn₁Y k).symm,
      lt_of_le_of_ne h4 (hYne yn₂ hyn₂Y k)⟩
  have hframem : ∀ k, A.sphereZero k ∈ closedRect xm₁ xm₂ ym₁ ym₂ →
      A.sphereZero k ∈ openRect xm₁ xm₂ ym₁ ym₂ := by
    intro k hk
    obtain ⟨h1, h2, h3, h4⟩ := hk
    exact ⟨lt_of_le_of_ne h1 (hXne xm₁ hxm₁X k).symm,
      lt_of_le_of_ne h2 (hXne xm₂ hxm₂X k),
      lt_of_le_of_ne h3 (hYne ym₁ hym₁Y k).symm,
      lt_of_le_of_ne h4 (hYne ym₂ hym₂Y k)⟩
  -- interior memberships
  have hρn_mem : A.sphereZero n ∈ openRect xn₁ xn₂ yn₁ yn₂ :=
    ⟨hxn₁b, hxn₂a, hyn₁b, hyn₂a⟩
  have hρm_mem : A.sphereZero m ∈ openRect xm₁ xm₂ ym₁ ym₂ :=
    ⟨hxm₁b, hxm₂a, hym₁b, hym₂a⟩
  -- geometric bounds
  have hxn : xn₁ < xn₂ := lt_trans hxn₁b hxn₂a
  have hyn : yn₁ < yn₂ := lt_trans hyn₁b hyn₂a
  have hxm : xm₁ < xm₂ := lt_trans hxm₁b hxm₂a
  have hym : ym₁ < ym₂ := lt_trans hym₁b hym₂a
  -- head finsets
  obtain ⟨sn, hsn⟩ := A.exists_rect_head_finset xn₁ xn₂ yn₁ yn₂
  obtain ⟨sm, hsm⟩ := A.exists_rect_head_finset xm₁ xm₂ ym₁ ym₂
  -- the value-loops
  have hMkΓ : ∀ a₁ a₂ b₁ b₂ : ℝ, a₁ ≤ a₂ → b₁ ≤ b₂ → 0 < b₁ →
      Continuous fun t : unitInterval => A.F (rectLoop a₁ a₂ b₁ b₂ t) := by
    intro a₁ a₂ b₁ b₂ ha hb hb₁
    refine continuous_iff_continuousAt.mpr fun t => ?_
    have hmem := rectLoop_mem_closedRect ha hb t
    have hne : rectLoop a₁ a₂ b₁ b₂ t ≠ (A.pole : ℂ) := by
      intro h
      have him : 0 < (rectLoop a₁ a₂ b₁ b₂ t).im := lt_of_lt_of_le hb₁ hmem.2.2.1
      rw [h] at him
      simp at him
    exact ((A.c1_analyticAt _ hne).continuousAt).comp (map_continuous _).continuousAt
  set Γn : C(unitInterval, ℂ) :=
    ⟨fun t => A.F (rectLoop xn₁ xn₂ yn₁ yn₂ t), hMkΓ _ _ _ _ hxn.le hyn.le hyn₁a⟩
    with hΓn_def
  set Γm : C(unitInterval, ℂ) :=
    ⟨fun t => A.F (rectLoop xm₁ xm₂ ym₁ ym₂ t), hMkΓ _ _ _ _ hxm.le hym.le hym₁a⟩
    with hΓm_def
  refine ⟨β, hβn, hβm, xn₁, xn₂, yn₁, yn₂, xm₁, xm₂, ym₁, ym₂,
    hxn₂b, hxm₁a, hyn₁a, hym₁a, hρn_mem, hρm_mem, sn, sm, hsn, hsm,
    Finset.card_pos.mpr ⟨n, (hsn n).mpr hρn_mem⟩,
    Finset.card_pos.mpr ⟨m, (hsm m).mpr hρm_mem⟩,
    Γn, Γm, fun t => rfl, fun t => rfl, ?_, ?_⟩
  · exact A.stemWinding_F_rectLoop hxn hyn hyn₁a hframen hsn Γn (fun t => rfl)
  · exact A.stemWinding_F_rectLoop hxm hym hym₁a hframem hsm Γm (fun t => rfl)

end ASection

/-- Two open rectangles separated by a vertical line are disjoint. Serves
§F: the drive's left and right rectangles (xn₂ < β < xm₁) trap disjoint
index sets. PROVED. -/
theorem openRect_disjoint_of_le {x₂ x₁' : ℝ} (h : x₂ ≤ x₁') (x₁ y₁ y₂ x₂' y₁' y₂' : ℝ) :
    Disjoint (openRect x₁ x₂ y₁ y₂) (openRect x₁' x₂' y₁' y₂') := by
  rw [Set.disjoint_left]
  intro z hz hz'
  have h1 : z.re < x₂ := hz.2.1
  have h2 : x₁' < z.re := hz'.1
  linarith

namespace ASection

/-- **The ONLY cross-contour relation the counting forces — additivity**
(the drive's verdict made a theorem; serves §F's report): disjoint traps
inside a bigger trap have counts summing to at most the bigger count. With
`stemWinding_F_rectLoop` this says: for disjoint admissible rectangles
inside a bigger admissible rectangle, the boundary windings ADD (up to the
middle-strip captures) — and that is ALL: no fed possession relates the
left count to the right count in any way that could distinguish one level
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
PROVED. -/
theorem trapped_counts_additive (A : ASection) {Un Um UR : Set ℂ}
    (hdisj : Disjoint Un Um) (hn : Un ⊆ UR) (hm : Um ⊆ UR)
    {sn sm sR : Finset ℕ}
    (hsn : ∀ k, k ∈ sn ↔ A.sphereZero k ∈ Un)
    (hsm : ∀ k, k ∈ sm ↔ A.sphereZero k ∈ Um)
    (hsR : ∀ k, k ∈ sR ↔ A.sphereZero k ∈ UR) :
    sn.card + sm.card ≤ sR.card := by
  classical
  have hdisj' : Disjoint sn sm := by
    rw [Finset.disjoint_left]
    intro k hkn hkm
    exact (Set.disjoint_left.mp hdisj ((hsn k).mp hkn)) ((hsm k).mp hkm)
  have hsub : sn ∪ sm ⊆ sR := by
    intro k hk
    rcases Finset.mem_union.mp hk with h | h
    · exact (hsR k).mpr (hn ((hsn k).mp h))
    · exact (hsR k).mpr (hm ((hsm k).mp h))
  calc sn.card + sm.card = (sn ∪ sm).card := (Finset.card_union_of_disjoint hdisj').symm
    _ ≤ sR.card := Finset.card_le_card hsub

end ASection
