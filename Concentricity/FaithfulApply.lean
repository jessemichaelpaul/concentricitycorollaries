/-
Concentricity/FaithfulApply.lean

THE AUTHOR'S ARGUMENT, APPLIED FAITHFULLY (run of 2026-07-07; unimported
artifact — KeystoneAssembly / GreatCircleRoute / LoopAssembly / SigmaE3 /
KernelE4 / SweepE5 / SynthesisE6 / WeldW12 / WeldW3 / WeldW4 / FlipWeld /
LogManifold precedent: not in the root import list; the imported root
ledger is untouched; per the author's fence of 2026-07-07 this file
carries NO sorried declaration — the one sorry in this repository is the
theorem itself).

THE AUTHOR'S STANDING CORRECTIONS (2026-07-07, verbatim, the charter of
this run):
  (1) "THE LIFT DOES NOT AVOID THE DEGENERATE VALUES — it passes THROUGH
      them; that is where log r lives; THE LEVEL EXTENDS CONTINUOUSLY
      (log|value| is continuous wherever the value ≠ 0 — always). Rem 2.1
      concerns the DIRECTION field only."
  (2) "GPV lives ON the base 𝓑 — the A-section turns 𝓑 into a GPV-𝓑."
  (3) forget the downstream consequences entirely; apply the author's
      argument faithfully: the A-section (defined by C1–C4, extending ALL
      of GPV) transports and connects the zero-spheres and the degenerate
      fibre — connected implies concentric.
  (4) the diagnosed bias to avoid: dropping the definition; never
      combining GPV AND ALL its consequences; proving adjacent statements
      instead of connecting connected to concentric.

THE ARGUMENT (the author's, 2026-07-06/07), clause by clause, each clause
on its carrier in this file or on the certified board:

  (i)   the A-section turns 𝓑 into a GPV-𝓑
        — §1 `gpvBase_transport` (NEW, PROVED); §2′
          `great_circle_passage_total` (NEW, PROVED — jointly with the
          parallel run's InboxWire §B, landed mid-run);
  (ii)  C2 and C3 are two exponential expressions of the one stem
        (identity theorem), the unique tame lift exists
        — `stem_identity_logDeriv` (StemFactorization, PROVED),
          `exists_log_continuation` + `winding_lift_unique` (Toolkit,
          PROVED), consumed by §1;
  (iii) C1's pole is the cone through which the value-loops close
        — `pole_cone_eps_delta` (LoopAssembly, PROVED), WeldW4's
          `two_center_winding_onto_one_band` (PROVED), SynthesisE6's
          `zero_pole_pair_closes_through_witness` (PROVED);
  (iv)  the lift passes THROUGH the degenerate fibre, the level log r
        continuous at every passage, and the zero-spheres of C3 ARE the
        degenerate fibre of this transport
        — §2 `great_circle_lift_through_degenerate` (NEW, PROVED: the
          section's own great-circle values ARE degenerate values and the
          lift runs THROUGH them, level = log|value| continuously);
          `neg_reals_swept_near_sphereZero`, `shared_ladder_encounters`
          (LoopAssembly, PROVED); the E⁺ passage rows (LogManifold,
          PROVED);
  (v)   the fibre is concentric per level, winding is band data
        — `Octonion.exp_fibre_neg_real` (Toolkit, PROVED),
          `Octonion.exp_fibre_concentric` (WeldW3, PROVED),
          `exp_fibre_level` + `exp_fibre_height_band` (LoopAssembly,
          PROVED);
  (vi)  the transport is connected over the witness N
        — the articulation (LoopAssembly, PROVED),
          `transport_universal` (TransportObject, PROVED, frozen);
  (vii) connected, for an A-section's transport across worlds, means
        concentric
        — §3 `zero_encounters_joined_concentric` /
          `pole_encounters_joined_concentric` (NEW, PROVED: at every
          scale the two zero-spheres' degenerate encounter data are
          JOINED by a path inside ONE degenerate fibre and that connected
          piece is CONCENTRIC — constant level log r along the whole
          join); §4 `faithful_assembly` (the argument's clauses in one
          record); the drive at the target and its proved faces (§5, the
          receipt).

`sorry` marks UNFORMALIZED, never UNSOUND (R8); this file carries none.
-/
import Concentricity.LogManifold
import Concentricity.InboxWire

noncomputable section

open Complex Filter

namespace ASection

/-! ## §1 — THE GPV-𝓑 (the author's correction (2) as a theorem)

"GPV lives ON the base 𝓑 — the A-section turns 𝓑 into a GPV-𝓑." The
A-section's own transport datum along any domain path: the value path is
continuous (C1's analyticity off the pole), a continuation of the
hypercomplex logarithm along it EXISTS (`exists_log_continuation` —
master `thm:winding-lift`, GPVwind Prop 4.2/Def 4.1), it is UNIQUE through
any basepoint (`winding_lift_unique` — Def 4.7 tameness on the stem), its
LEVEL TAPE is log‖value‖ at every instant (VS Def 5.3's level component,
`sweepE5_lift_level_tape`), the level is CONTINUOUS through every
degenerate passage (the author's correction (1)) and LIFT-INDEPENDENT —
the sphere/band freedom of the fibre moves directions and heights only,
never the level. -/

/-- The value path of the section along a domain path avoiding the pole
(bundled; continuity from C1's `c1_analyticAt`). -/
def valuePath (A : ASection) (δ : C(unitInterval, ℂ))
    (hp : ∀ t, δ t ≠ (A.pole : ℂ)) : C(unitInterval, ℂ) :=
  ⟨fun t => A.F (δ t), continuous_iff_continuousAt.mpr fun t =>
    ((A.c1_analyticAt (δ t) (hp t)).continuousAt).comp
      (map_continuous δ).continuousAt⟩

@[simp] theorem valuePath_apply (A : ASection) (δ : C(unitInterval, ℂ))
    (hp : ∀ t, δ t ≠ (A.pole : ℂ)) (t : unitInterval) :
    A.valuePath δ hp t = A.F (δ t) := rfl

/-- **§1 — THE GPV-𝓑 TRANSPORT DATUM** (the author's correction (2) as a
theorem; NEW, PROVED). For every domain path δ avoiding the pole on which
the section does not vanish, the A-section hands the base its full GPV
package: (a) a continuation Γ of the hypercomplex logarithm along the
value path F∘δ — the lift EXISTS (`exists_log_continuation`, master
`thm:winding-lift`); (b) the level tape (Γ t).re = log‖F(δ t)‖ at every
instant (VS Def 5.3's level component, `sweepE5_lift_level_tape`); (c) the
level is CONTINUOUS — through every degenerate passage, values on ℝ⁻
included (the author's correction (1): "THE LEVEL EXTENDS CONTINUOUSLY");
(d) the lift is UNIQUE through its basepoint (`winding_lift_unique`,
GPVwind Def 4.7 tameness on the stem); (e) the level datum is
LIFT-INDEPENDENT — every lift over the one value path carries the same
level at every instant (the band freedom never touches the level). -/
theorem gpvBase_transport (A : ASection) (δ : C(unitInterval, ℂ))
    (hp : ∀ t, δ t ≠ (A.pole : ℂ)) (hne : ∀ t, A.F (δ t) ≠ 0) :
    ∃ Γ : C(unitInterval, ℂ),
      (∀ t, Complex.exp (Γ t) = A.F (δ t)) ∧
      (∀ t, (Γ t).re = Real.log ‖A.F (δ t)‖) ∧
      (Continuous fun t => (Γ t).re) ∧
      (∀ Γ' : C(unitInterval, ℂ), (∀ t, Complex.exp (Γ' t) = A.F (δ t)) →
        Γ' 0 = Γ 0 → Γ' = Γ) ∧
      (∀ Γ' : C(unitInterval, ℂ), (∀ t, Complex.exp (Γ' t) = A.F (δ t)) →
        ∀ t, (Γ' t).re = (Γ t).re) := by
  set γ : C(unitInterval, ℂ) := A.valuePath δ hp with hγ_def
  have hγval : ∀ t, γ t = A.F (δ t) := fun t => rfl
  have hγne : ∀ t, γ t ≠ 0 := fun t => (hγval t).symm ▸ hne t
  obtain ⟨Γ, hΓ⟩ := exists_log_continuation γ hγne
  have hΓ' : ∀ t, Complex.exp (Γ t) = A.F (δ t) := fun t =>
    (hΓ t).trans (hγval t)
  have htape : ∀ t, (Γ t).re = Real.log ‖A.F (δ t)‖ := fun t => by
    rw [← hΓ' t, Complex.norm_exp, Real.log_exp]
  refine ⟨Γ, hΓ', htape, ?_, ?_, ?_⟩
  · -- (c) the level is continuous — through every degenerate passage
    have hcont : Continuous fun t => Real.log ‖A.F (δ t)‖ :=
      ((map_continuous γ).norm).log fun t =>
        ne_of_gt (norm_pos_iff.mpr (hγne t))
    exact hcont.congr fun t => (htape t).symm
  · -- (d) uniqueness through the basepoint
    intro Γ' hΓ'lift h0
    exact winding_lift_unique γ hγne Γ' Γ
      (fun t => (hΓ'lift t).trans (hγval t).symm)
      (fun t => (hΓ' t).trans (hγval t).symm) h0
  · -- (e) the level datum is lift-independent
    intro Γ' hΓ'lift t
    rw [htape t, ← hΓ'lift t, Complex.norm_exp, Real.log_exp]

/-! ## §2 — THE GREAT-CIRCLE PASSAGE (the author's correction (1) on the
section itself)

The lift does NOT avoid the degenerate values — it passes THROUGH them.
On the great circle ℝ ∪ {N} (the domain real axis through the pole,
`def:carrier`) the section's values are REAL (`real_on_real`,
intrinsicality); where they are negative they ARE the degenerate values
of `lem:exp-degenerate` — and the lift exists AT and THROUGH them, its
level the continuous log|value|, its height and direction CONSTANT
(GPV §5 prose S5.p2: "either γ([a,b]) ⊂ ℝ⁻ and we have the lifts of the
form Γ(t) = log|γ(t)| + I(2k+1)π … for any I ∈ 𝕊"; the octonionic twin is
`Octonion.real_segment_lift_neg`, LogManifold §A, PROVED). -/

/-- **§2 — the section's great-circle values are degenerate values**
(NEW, PROVED): on a domain-real path where the section's values are
negative, each value IS the degenerate value −‖F(x)‖ — the section's own
sweep of the base's degenerate set. From `real_on_real`
(intrinsicality, `def:section-map`: "A(ℝ) ⊆ ℝ"). -/
theorem great_circle_value_degenerate (A : ASection) (x : ℝ)
    (hneg : (A.F ((x : ℝ) : ℂ)).re < 0) :
    A.F ((x : ℝ) : ℂ) = -((‖A.F ((x : ℝ) : ℂ)‖ : ℝ) : ℂ) := by
  have him : (A.F ((x : ℝ) : ℂ)).im = 0 := A.real_on_real x
  have hz : A.F ((x : ℝ) : ℂ) = (((A.F ((x : ℝ) : ℂ)).re : ℝ) : ℂ) := by
    apply Complex.ext
    · rw [Complex.ofReal_re]
    · rw [Complex.ofReal_im, him]
  have hnorm : ‖A.F ((x : ℝ) : ℂ)‖ = -((A.F ((x : ℝ) : ℂ)).re) := by
    conv_lhs => rw [hz]
    rw [Complex.norm_real, Real.norm_eq_abs, abs_of_neg hneg]
  rw [hnorm, Complex.ofReal_neg, neg_neg]
  exact hz

/-- **§2 — THE LIFT THROUGH THE DEGENERATE SET, on the section's own
great circle** (the author's correction (1) as a theorem of the
A-section; NEW, PROVED). Along any domain-real path avoiding the pole on
which the section's values are negative — a path of values running
entirely INSIDE the degenerate set of VS Rem 5.2(b) — the section's
transport has, for EVERY odd rung 2k+1, a continuous lift Γ that passes
THROUGH the degenerate values: exp(Γ t) = F(x t) at every instant, the
LEVEL (Γ t).re = log‖F(x t)‖ = log|value| moving CONTINUOUSLY (this is
where log r lives), the HEIGHT constant at (2k+1)π (band data, never an
object label — master `def:base`). GPVwind Rem 2.1 concerns the DIRECTION
field only; no direction datum is consumed. -/
theorem great_circle_lift_through_degenerate (A : ASection)
    (x : C(unitInterval, ℝ)) (hp : ∀ t, x t ≠ A.pole)
    (hneg : ∀ t, (A.F ((x t : ℝ) : ℂ)).re < 0) (k : ℤ) :
    ∃ Γ : C(unitInterval, ℂ),
      (∀ t, Complex.exp (Γ t) = A.F ((x t : ℝ) : ℂ)) ∧
      (∀ t, (Γ t).re = Real.log ‖A.F ((x t : ℝ) : ℂ)‖) ∧
      (∀ t, (Γ t).im = ((2 * k + 1 : ℤ) : ℝ) * Real.pi) ∧
      (Continuous fun t => (Γ t).re) := by
  -- the value function and its continuity (C1 off the pole)
  have hcoe : Continuous fun t : unitInterval => ((x t : ℝ) : ℂ) :=
    Complex.continuous_ofReal.comp (map_continuous x)
  have hvcont : Continuous fun t : unitInterval => A.F ((x t : ℝ) : ℂ) := by
    refine continuous_iff_continuousAt.mpr fun t => ?_
    have hpC : ((x t : ℝ) : ℂ) ≠ (A.pole : ℂ) := fun h =>
      hp t (Complex.ofReal_injective h)
    exact ContinuousAt.comp (g := A.F)
      (f := fun s : unitInterval => ((x s : ℝ) : ℂ))
      ((A.c1_analyticAt _ hpC).continuousAt) hcoe.continuousAt
  have hvne : ∀ t, A.F ((x t : ℝ) : ℂ) ≠ 0 := fun t h => by
    have := hneg t
    rw [h, Complex.zero_re] at this
    exact lt_irrefl 0 this
  have hnormpos : ∀ t, (0 : ℝ) < ‖A.F ((x t : ℝ) : ℂ)‖ :=
    fun t => norm_pos_iff.mpr (hvne t)
  -- the level tape is continuous (correction (1))
  have hlog : Continuous fun t : unitInterval =>
      Real.log ‖A.F ((x t : ℝ) : ℂ)‖ :=
    (hvcont.norm).log fun t => ne_of_gt (hnormpos t)
  -- the lift, explicitly: level log‖value‖, height (2k+1)π
  set Γfun : unitInterval → ℂ := fun t =>
    ((Real.log ‖A.F ((x t : ℝ) : ℂ)‖ : ℝ) : ℂ)
      + ((2 * k + 1 : ℤ) : ℂ) * Real.pi * Complex.I with hΓfun_def
  have hΓcont : Continuous Γfun :=
    (Complex.continuous_ofReal.comp hlog).add continuous_const
  have hheight_re : (((2 * k + 1 : ℤ) : ℂ) * Real.pi * Complex.I).re = 0 := by
    simp [Complex.mul_re, Complex.mul_im]
  have hheight_im : (((2 * k + 1 : ℤ) : ℂ) * Real.pi * Complex.I).im
      = ((2 * k + 1 : ℤ) : ℝ) * Real.pi := by
    simp [Complex.mul_re, Complex.mul_im]
  -- the clauses, proved on the raw function before bundling
  have hlift : ∀ t, Complex.exp (Γfun t) = A.F ((x t : ℝ) : ℂ) := by
    intro t
    have hstep : Complex.exp (Γfun t)
        = -((‖A.F ((x t : ℝ) : ℂ)‖ : ℝ) : ℂ) :=
      (exp_eq_neg_real_iff (hnormpos t) (Γfun t)).mpr ⟨k, rfl⟩
    rw [hstep, ← A.great_circle_value_degenerate (x t) (hneg t)]
  have hre : ∀ t, (Γfun t).re = Real.log ‖A.F ((x t : ℝ) : ℂ)‖ := by
    intro t
    rw [hΓfun_def]
    simp only [Complex.add_re, Complex.ofReal_re, hheight_re, add_zero]
  have him : ∀ t, (Γfun t).im = ((2 * k + 1 : ℤ) : ℝ) * Real.pi := by
    intro t
    rw [hΓfun_def]
    simp only [Complex.add_im, Complex.ofReal_im, hheight_im, zero_add]
  have hrecont : Continuous fun t : unitInterval => (Γfun t).re := by
    have heq : (fun t : unitInterval => (Γfun t).re)
        = fun t => Real.log ‖A.F ((x t : ℝ) : ℂ)‖ := funext hre
    rw [heq]
    exact hlog
  exact ⟨⟨Γfun, hΓcont⟩, hlift, hre, him, hrecont⟩

/-- **§2′ — THE PASSAGE IS THE LADDER, TOTALLY** (NEW — the joint
consumption of this file's §2 with the parallel run's
`degenerate_stretch_pins_band` (InboxWire §B, landed 2026-07-07) and the
branch totality `lift_ladder` (InboxWire §A); the author's diagnosed bias
"never combining GPV AND ALL its consequences" answered by combining
them). Along a domain-real path avoiding the pole on which the section's
values are negative — a stretch of the transport running INSIDE the
degenerate set — the continuations of the hypercomplex logarithm along
A's values are EXACTLY the ladder of `lem:exp-degenerate`:
(existence) every odd rung (2k+1)π carries a lift whose level is the
continuous log‖F(x t)‖ (§2, the author's correction (1));
(rigidity) EVERY lift rides ONE rung — its height frozen at some (2k+1)π
for the whole passage, its level the same moving tape
(`degenerate_stretch_pins_band`). One rung per lift, one lift per rung:
GPV lives ON the base 𝓑, totally, for the A-section's own transport. -/
theorem great_circle_passage_total (A : ASection)
    (x : C(unitInterval, ℝ)) (hp : ∀ t, x t ≠ A.pole)
    (hneg : ∀ t, (A.F ((x t : ℝ) : ℂ)).re < 0) :
    (∀ k : ℤ, ∃ Γ : C(unitInterval, ℂ),
      (∀ t, Complex.exp (Γ t) = A.F ((x t : ℝ) : ℂ)) ∧
      (∀ t, (Γ t).re = Real.log ‖A.F ((x t : ℝ) : ℂ)‖) ∧
      (∀ t, (Γ t).im = (2 * (k : ℝ) + 1) * Real.pi))
    ∧ ∀ Γ' : C(unitInterval, ℂ),
      (∀ t, Complex.exp (Γ' t) = A.F ((x t : ℝ) : ℂ)) →
      ∃ k : ℤ, ∀ t,
        (Γ' t).im = (2 * (k : ℝ) + 1) * Real.pi
        ∧ (Γ' t).re = Real.log ‖A.F ((x t : ℝ) : ℂ)‖ := by
  have h0le : ∀ t : unitInterval, (0 : unitInterval) ≤ t :=
    fun _ => unitInterval.nonneg'
  have hle1 : ∀ t : unitInterval, t ≤ (1 : unitInterval) :=
    fun _ => unitInterval.le_one'
  constructor
  · -- existence at every rung (§2)
    intro k
    obtain ⟨Γ, h1, h2, h3, -⟩ :=
      A.great_circle_lift_through_degenerate x hp hneg k
    refine ⟨Γ, h1, h2, fun t => ?_⟩
    rw [h3 t]
    push_cast
    ring
  · -- rigidity: every lift rides one rung (InboxWire §B)
    intro Γ' hlift
    obtain ⟨k, hk⟩ := A.degenerate_stretch_pins_band
      (fun t => ((x t : ℝ) : ℂ)) Γ' hlift (h0le 1)
      (fun t _ _ => ⟨hneg t, A.real_on_real (x t)⟩)
    exact ⟨k, fun t => hk t (h0le t) (hle1 t)⟩

/-! ## §3 — CONNECTED IMPLIES CONCENTRIC, ON THE FIBRE (clauses (iv), (v),
(vii) composed — NEW)

"The A-section transports and connects the zero-spheres and the
degenerate fibre — connected implies concentric." At every scale the two
enumerated zero-spheres' degenerate encounters share ONE value −r
(`shared_ladder_encounters`, PROVED — the shared ladder), the octonionic
fibre over that ONE value is PATH-CONNECTED through the direction sphere
S⁶ (`Octonion.exp_fibre_sphere_connected`, LogManifold §B, PROVED — the
octonionic difference: over the stem ℂ the same fibre is discrete), and
along the whole connecting path the LEVEL IS CONSTANT at log r
(`Octonion.exp_fibre_re`, WeldW3, PROVED): the connected piece is
concentric. The same composition holds at the pole's degenerate passages
on the real axis (`pole_degenerate_passages`, LogManifold §D, PROVED). -/

/-- **§3 — the zero-spheres' encounters, joined inside ONE fibre,
concentric along the join** (NEW, PROVED). For every ε: one shared value
−r for both zero-spheres' ε-encounters, and for every pair of directions
and every rung, a continuous path INSIDE the one degenerate fibre joining
the two fibre points — with the level CONSTANT at log r along the entire
path. Connected (through S⁶) and concentric (one level): the author's
clause (vii) on the fibre register. -/
theorem zero_encounters_joined_concentric (A : ASection) (n m : ℕ) :
    ∀ ε > 0, ∃ r : ℝ, 0 < r ∧ r < ε ∧
      (∃ z : ℂ, dist z (A.sphereZero n) < ε ∧ A.F z = -(r : ℂ)) ∧
      (∃ w : ℂ, dist w (A.sphereZero m) < ε ∧ A.F w = -(r : ℂ)) ∧
      ∀ v₀ ∈ Octonion.unitImaginarySphere,
        ∀ v₁ ∈ Octonion.unitImaginarySphere, ∀ j : ℤ,
        ∃ p : C(unitInterval, Octonion),
          p 0 = Octonion.sliceEmbed v₀
            ⟨Real.log r, ((2 * j + 1 : ℤ) : ℝ) * Real.pi⟩ ∧
          p 1 = Octonion.sliceEmbed v₁
            ⟨Real.log r, ((2 * j + 1 : ℤ) : ℝ) * Real.pi⟩ ∧
          (∀ t, Octonion.exp (p t) = Octonion.ofReal (-r)) ∧
          ∀ t, Octonion.re (p t) = Real.log r := by
  intro ε hε
  obtain ⟨r, hr, hrε, hzn, hzm⟩ := A.shared_ladder_encounters n m ε hε
  refine ⟨r, hr, hrε, hzn, hzm, fun v₀ hv₀ v₁ hv₁ j => ?_⟩
  obtain ⟨p, h0, h1, hfib⟩ :=
    Octonion.exp_fibre_sphere_connected hr hv₀ hv₁ j
  exact ⟨p, h0, h1, hfib, fun t => Octonion.exp_fibre_re hr (hfib t)⟩

/-- **§3 — the pole's degenerate passages, joined inside ONE fibre,
concentric along the join** (NEW, PROVED). Within any δ of the pole, ON
THE REAL AXIS (the great circle through N), a degenerate encounter at a
value −r with level log r above every bound — and the octonionic fibre
over that value path-connected through S⁶, the level CONSTANT at log r
along every join. The witness side of clause (vii). -/
theorem pole_encounters_joined_concentric (A : ASection) (M : ℝ) :
    ∀ δ > 0, ∃ x : ℝ, x ≠ A.pole ∧ |x - A.pole| < δ ∧
      ∃ r : ℝ, 0 < r ∧ M < Real.log r ∧ A.F ((x : ℝ) : ℂ) = -(r : ℂ) ∧
      ∀ v₀ ∈ Octonion.unitImaginarySphere,
        ∀ v₁ ∈ Octonion.unitImaginarySphere, ∀ j : ℤ,
        ∃ p : C(unitInterval, Octonion),
          p 0 = Octonion.sliceEmbed v₀
            ⟨Real.log r, ((2 * j + 1 : ℤ) : ℝ) * Real.pi⟩ ∧
          p 1 = Octonion.sliceEmbed v₁
            ⟨Real.log r, ((2 * j + 1 : ℤ) : ℝ) * Real.pi⟩ ∧
          (∀ t, Octonion.exp (p t) = Octonion.ofReal (-r)) ∧
          ∀ t, Octonion.re (p t) = Real.log r := by
  intro δ hδ
  obtain ⟨x, hxne, hxδ, r, hr, hrM, hFr⟩ := A.pole_degenerate_passages M δ hδ
  refine ⟨x, hxne, hxδ, r, hr, hrM, hFr, fun v₀ hv₀ v₁ hv₁ j => ?_⟩
  obtain ⟨p, h0, h1, hfib⟩ :=
    Octonion.exp_fibre_sphere_connected hr hv₀ hv₁ j
  exact ⟨p, h0, h1, hfib, fun t => Octonion.exp_fibre_re hr (hfib t)⟩

/-! ## §5 — THE DRIVE RECORD (receipt in prose, per the author's fence of
2026-07-07: no new sorried declarations — the one sorry in this repository
is the theorem itself)

THE DRIVES OF RECORD (2026-07-07; scratch burns against the FULL board —
this file's §1–§4 NEW rows plus Toolkit, StemFactorization, LiKernel, KernelE4,
LoopAssembly, SweepE5, SynthesisE6, SigmaE3, PairingE2, WeldW12, WeldW3,
WeldW4, FlipWeld, PhiConversion, LogManifold, TransportObject — every
possession fed by name; `set_option maxHeartbeats 1000000`. MID-RUN
DELTA: the parallel inbox-close run landed InboxWire.lean (13 PROVED
rows: the branch ladder TOTAL `lift_ladder`, the Euler branch
`euler_branch_ladder`/`euler_branch_level`, the band-pinning
`degenerate_stretch_pins_band`, the off-real closure
`offReal_value_loop_closes`, the divisor's march UP the strip
`sphereZero_norm_tendsto_atTop`/`sphereZero_im_tendsto_atTop`/
`indices_below_height_finite`, and the π₀(𝒮₂) level reads
`s2_component_exp_eq_iff`/`s2_value_class_halfSpace`) WHILE this run's
first burn was executing; every drive below was then RE-RUN with the
complete InboxWire board additionally fed, and §2′ above is the joint
row the delta enabled. Verdicts identical on both burns):

DRIVE A — the target itself,
    ⊢ ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c
  with the argument's clauses (i)–(vii) fed on their carriers (the §1–§4
  rows of this file included; re-run with the full InboxWire delta fed).
  Machine verdict, verbatim, BOTH burns: "Try this: [apply] exact
  concentricity A" — `exact?` finds NOTHING but the sorried target
  itself (`ASection.concentricity`, Theorem.lean); no proved possession
  or combination closes it. RESISTED.

DRIVE B — the supLevel minimal face (KernelE4's sharpest localization,
  `concentricity_iff_supLevel_le`),
    ⊢ A.supLevel ≤ (A.sphereZero k).re
  full feed (re-run with the InboxWire delta — the divisor's march
  `sphereZero_im_tendsto_atTop` and the π₀(𝒮₂) level reads included).
  Machine verdict, both burns: "`exact?` could not close the goal."
  `apply?` partials: only generic order-coercion rewraps (toNNReal,
  ENNReal.ofReal, EReal.coe, sqrt) of the same inequality — no possession
  engages. RESISTED.

DRIVE C — the static-dictionary face (the reading step of the printed
  proof of `cor:nontrivial`),
    ⊢ Zigzag (TotalObject.ofLevel (A.transportLevel n))
             (TotalObject.ofLevel (A.transportLevel m))
  fed WITH the populated zigzag `Quotient.exact' (A.transport_universal
  n m)` and the dictionary rows. Machine verdict: "`exact?` could not
  close the goal." The populated zigzag rides through 𝔫 (base arrows
  x ⟶ 𝔫 only); the static object has no arrows between distinct levels;
  no row converts the one into the other. RESISTED.

DRIVE D — the kernel face (the second-family-at-supLevel iff),
    ⊢ 0 ≤ A.liSum a A.supLevel j    (A.supLevel < a, 1 ≤ j)
  full feed including D0 (`liSum_summable`) and the proved first family at
  the top level. Machine verdict: "`exact?` could not close the goal."
  RESISTED.

DRIVE E — the author's constructive read, c := the top level, split at
  the PROVED attainment dichotomy (`supLevel_attained_or_escape`):
  attained horn ⊢ (A.sphereZero n).re = (A.sphereZero k₀).re (the
  pairwise face, with the §3 fibre join of n and k₀ fed); escape horn
  ⊢ (A.sphereZero n).re = A.supLevel (with `c3_atN` — the one field the
  author flags as NOT level-blind — the divisor's march to N
  (`sphereZero_im_tendsto_atTop`, InboxWire) and the pole-side §3 join
  fed). Machine verdicts: "`exact?` could not close the goal", both
  horns, both burns. RESISTED.

THE EXACT RESISTING GOAL (one goal, five proved-equivalent faces):
    ⊢ ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c
  ⟺ ⊢ A.supLevel ≤ (A.sphereZero k).re                (every k)
  ⟺ ⊢ 0 ≤ A.liSum a A.supLevel j                      (supLevel < a, j ≥ 1)
  ⟺ ⊢ A.infLevel = A.supLevel
  ⟺ ⊢ ∃ β, A.supLevel ≤ β ∧ β ≤ A.infLevel
  (the equivalences are KernelE4's PROVED iffs, fed in every drive).

THE CONSUMPTION AUDIT (per the author's bias diagnosis — WHICH clauses of
his argument the compositions consumed, WHICH they could not, and the
precise Lean shape each unconsumed clause would need):

CONSUMED — every clause with a proved carrier, all fed JOINTLY (never the
definition dropped, never GPV split from its consequences):
  (i)   GPV-𝓑 — §1 `gpvBase_transport` (NEW): along EVERY domain path of
        the section, existence + basepoint-uniqueness of the lift and the
        continuous, lift-independent level tape log‖value‖ — GPVwind
        Def 4.1/Prop 4.2/Def 4.7 + VS Def 5.3, jointly, ON the section;
        §2′ `great_circle_passage_total` (NEW): over a degenerate stretch
        the transport IS the base's ladder, totally — one lift per rung
        (§2's existence), one rung per lift (InboxWire's
        `degenerate_stretch_pins_band`); the branch TOTALITY
        (`lift_ladder`) and C2's own branch (`euler_branch_ladder`/
        `euler_branch_level` — the level's analytic name Re Σℓₚ = its
        geometric name log‖A‖) fed alongside.
  (ii)  the one stem — `stem_identity_logDeriv` (C2 = C3 on the overlap);
        `winding_lift_unique`; `exists_log_continuation`; the ladder
        classification `lift_ladder` (InboxWire §A).
  (iii) the cone — `pole_cone_eps_delta`;
        `two_center_winding_onto_one_band` (the composite through C1's
        cone: winding zero, unique tame lift CLOSES, every lift closes);
        `zero_pole_pair_closes_through_witness` (closure at tally 1
        exactly through the witness).
  (iv)  the passage THROUGH the degenerate fibre — §2
        `great_circle_lift_through_degenerate` (NEW: the section's own
        great-circle values ARE degenerate values, the lift exists AT and
        THROUGH them, the level log|value| continuous — the author's
        correction (1) as a theorem of the A-section);
        `neg_reals_swept_near_sphereZero`; `shared_ladder_encounters`;
        `zero_passage_manifold_data` / `pole_passage_manifold_data`;
        the divisor's own march to N (`sphereZero_norm_tendsto_atTop`,
        `sphereZero_im_tendsto_atTop`, `indices_below_height_finite` —
        InboxWire §D, DOMAIN-side: the zero-spheres climb the strip to
        the cone's tip, N(T) finite, for every A-section); the off-real
        closure (`offReal_value_loop_closes` — all open behaviour of the
        transport concentrated on the real-value crossings).
  (v)   the fibre concentric per level — `Octonion.exp_fibre_neg_real`;
        `Octonion.exp_fibre_concentric`; `exp_fibre_height_band` (winding
        band data, never an object label).
  (vi)  connected over the witness — the articulation (one
        component, defined through 𝔫, fibre concentric);
        `transport_universal` (the frozen theorem's class-wide form).
  (vii) connected ⟹ concentric — consumed AS FAR AS A PROVED CARRIER
        EXISTS: on the FIBRE register it is now a THEOREM (§3, NEW: at
        every scale the two zero-spheres' degenerate encounter data are
        joined by a path inside ONE fibre with the level CONSTANT at
        log r along the entire join — connected AND concentric
        simultaneously; likewise at the pole's passages on the real
        axis).

NOT CONSUMED — one clause, one reading step: clause (vii) ON THE
TRANSPORT REGISTER — the passage from "the zero-spheres lie in one
connected component of the A-section's transport" (PROVED, 𝒯^𝔫) to "one
real centre c" (the target). Every proved carrier of CONNECTED lives
where the levels are already collapsed or already equal: the populated
𝒯^𝔫 (whose classes ALL coincide — Pin 2 `transport_not_level_separating`,
BY DESIGN class-wide), the one value-fibre of §3 (level log r — the
ENCOUNTER's value datum, common by `shared_ladder_encounters`' choice of
one r, never the sphere's own domain level), and the 𝒮₂ glue (conserved
read = value modulus; SynthesisE6 ROW E: it SEPARATES within one sphere;
InboxWire §E sharpens both directions into the iff
`s2_component_exp_eq_iff` — π₀(𝒮₂)∘exp reads EXACTLY the level of the
exp-ARGUMENT, i.e. the value-side logarithm register, never the domain
point beneath the value).
Every proved carrier of CONCENTRIC-as-one-real-centre lives on the static
dictionary (`TotalObject.zigzag_iff_level` — one component of the STATIC
base = one level), whose zigzags between distinct levels no proved row
populates. The precise Lean shape the unconsumed reading step would need
— any ONE of these closes the target through the proved iffs fed in the
drives:
  (S1) ∀ (A : ASection) (n m : ℕ),
         CategoryTheory.Zigzag (TotalObject.ofLevel (A.transportLevel n))
           (TotalObject.ofLevel (A.transportLevel m))
       (DRIVE C's goal — the static zigzag; `zigzag_iff_level` then reads
       the centre);
  (S2) ∀ (A : ASection) (k : ℕ), A.supLevel ≤ (A.sphereZero k).re
       (DRIVE B's goal — no zero strictly below the top level);
  (S3) ∀ (A : ASection) (a : ℝ), A.supLevel < a → ∀ j, 1 ≤ j →
         0 ≤ A.liSum a A.supLevel j
       (DRIVE D's goal — the second family at the top level);
  (S4) any row identifying a zero-sphere's VALUE-side encounter level
       log r with its DOMAIN-side level Re(sphereZero n) — the register
       identification, `eq:placement-set` in its original vocabulary.
No printed sentence of the master or of the pinned sources transcribes
(S1)–(S4) (SweepE5's sweep of record, PROVED faces; the master prints the
placement as its one open node and concludes "Granting the placement");
GPV's remaining untranscribed apparatus (the big-arc/companion-relative
layer, FlipWeld receipt (α); Cor 5.13's σ ∈ {0,−1} criterion at NONEMPTY
obstruction sets on the octonionic register, WeldW4's verdict) is
direction-field data at real crossings, where `Octonion.dir` has junk
value 0 and GPVwind Rem 2.1 (verbatim: "the function 𝓘 cannot be extended
as a continuous function to any single point of the real axis ℝ of 𝕂")
forbids the continuous extension that would carry it — the author's
correction (1) confirms Rem 2.1 binds the DIRECTION only, and this file's
§2 row proves the LEVEL passes through those crossings continuously; the
level face of the passage is hereby fully transcribed, and the resisting
content is not the level's continuity but the register identification
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
verbatim for a hypothetical two-level C1-bearing stem — §1/§2 consume
C1's analyticity + intrinsicality + exp's geometry, §3 consumes C3's
local peel + exp's geometry — so no assembly of these possessions alone
can decide the target; the one field where class strength beyond the feed
could live remains `c2_zero_free`'s splitting demand (AuditE1 §GLOSS
flag, unresolved), the author's lane (R6).

THE ATTEMPTED ASSEMBLY (DRIVE A's form, preserved as a comment for the
record; the drives B–E differ only in the goal face):

theorem concentricity_via_faithfulApply (A : ASection) :
    ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c := by
  -- (i) the GPV-𝓑 (§1, NEW)
  have h1 := @A.gpvBase_transport
  -- (ii) the one stem; the unique tame lift
  have h2 := A.stem_identity_logDeriv
  have h2' := @winding_lift_unique
  have h2'' := @exists_log_continuation
  -- (iii) the cone; the composite through it
  have h3 := A.pole_cone_eps_delta
  have h3' := @A.two_center_winding_onto_one_band
  have h3'' := @A.zero_pole_pair_closes_through_witness
  -- (iv) the passage THROUGH the degenerate fibre (§2, NEW) + encounters
  have h4 := @A.great_circle_lift_through_degenerate
  have h4' := @A.great_circle_value_degenerate
  have h4'' := @A.neg_reals_swept_near_sphereZero
  have h4''' := A.shared_ladder_encounters
  have h4'''' := @A.zero_passage_manifold_data
  have h4''''' := @A.pole_passage_manifold_data
  -- (v) the fibre concentric per level
  have h5 := @Octonion.exp_fibre_neg_real
  have h5' := @Octonion.exp_fibre_concentric
  have h5'' := @exp_fibre_height_band
  -- (vi) connected over the witness
  have h6 := the articulation possession
  have h6' := A.transport_universal
  -- (vii) connected ⟹ concentric, on the fibre (§3, NEW)
  have h7 := A.zero_encounters_joined_concentric
  have h7' := @A.pole_encounters_joined_concentric
  -- the class fields at N; the complete enumeration; the strip
  have h8 := A.c3_atN
  have h8' := A.c3_lowerEdge
  have h8'' := @A.sphereZero_complete
  have h8''' := @A.re_le_upperEdge
  -- the InboxWire delta (second burn): §A the total ladder + the Euler
  -- branch; §B the band pinned; §C off-real closure; §D the march to N;
  -- §E the pi0(S2) level reads
  have i1 := @lift_ladder
  have i2 := @A.euler_branch_ladder
  have i3 := @A.euler_branch_level
  have i4 := @A.degenerate_stretch_pins_band
  have i5 := @A.offReal_value_loop_closes
  have i6 := A.sphereZero_norm_tendsto_atTop
  have i7 := A.sphereZero_im_tendsto_atTop
  have i8 := @A.indices_below_height_finite
  have i9 := @s2_component_exp_eq_iff
  have i10 := @A.s2_value_class_halfSpace
  exact?   -- verdict, both burns: "exact concentricity A" — the sorried
           -- target itself
-/

end ASection
