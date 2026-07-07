/-
Concentricity/LogManifold.lean

THE E⁺ / CONTINUOUS-LEVEL BUILDOUT (working artifact; KeystoneAssembly /
GreatCircleRoute / LoopAssembly / SigmaE3 / WeldW3 / SweepE5 precedent;
NOT imported by the root — the imported ledger is untouched). Built on the
author's standing corrections (2026-07-07, quoted per row below):

  (1) "THE LIFT DOES NOT AVOID THE DEGENERATE VALUES — it passes THROUGH
      them; that is where log r lives; THE LEVEL EXTENDS CONTINUOUSLY
      (log|value| is continuous wherever the value ≠ 0 — always). Rem 2.1
      concerns the DIRECTION field only."
  (2) "GPV lives ON the base 𝓑 — the A-section turns 𝓑 into a GPV-𝓑."

WHAT IS PROVED HERE (every row below is PROVED; this file carries NO
`sorry`; helpers never sorried, R8):

§0 — continuity supplements for the artifact-local topology of 𝕆
(WeldW3 §W0): `re`, `normSq`, `norm`, `ofReal`, `im` are continuous.

§A — THE CONTINUOUS LEVEL (the author's correction (1) as theorems): the
level log‖·‖ is continuous off 0 — always, degenerate passages included
(`continuousOn_log_norm`, `level_tape_continuous`); the level of ANY lift
datum equals the log-modulus of the value under it
(`level_eq_log_norm_exp`, `lift_level_tape` — VS Def 5.3's level component
on 𝕆, the octonionic twin of the PROVED stem rows `sweepE5_level_readout`
/ `sweepE5_lift_level_tape`); hence the lift's level is continuous and
lift-independent even when NO continuity of the lift is assumed
(`lift_level_continuous`, `lift_level_unique`) and closes along every
closed value path (`lift_loop_level_closes`); the real-segment lifts
THROUGH the degenerate set, exactly as GPV print them
(`real_segment_lift_neg`, `real_segment_lift_pos`).

§B — THE E⁺ ENVIRONMENT (master `thm:log-manifold`; VS Prop 5.1, Rem 5.2,
Def 5.3, Prop 5.4, Def 5.5): the E⁺-exponential `Eexp`, the logarithm
manifold `logManifold` (the image of the exponential graph), the commuting
triangle π∘E = exp (`pr1_Eexp`, definitional), the E⁺-logarithm `Llog`
with L∘E = id and E∘L = id on the manifold (`Llog_Eexp`, `Eexp_Llog`,
`exp_Llog` — Prop 5.4), the LEVEL readout re∘L = log‖·‖ (`re_Llog_of_mem`),
the degenerate locus inside the manifold (`logManifold_fibre_neg_real`,
`degenerate_sphere_mem`, `degenerate_level_readout`), and THE OCTONIONIC
DIFFERENCE as connectivity: the unit imaginary sphere S⁶ is
path-connected on the repo's own type (`sphere_path`), so each degenerate
sphere of the fibre is path-connected THROUGH the fibre
(`exp_fibre_sphere_connected`), joining what over the stem ℂ is a
disconnected conjugate PAIR of points (`exp_fibre_conj_joined`); the
passage bundle (`degenerate_passage`).

§C — THE WINDING LIFT (master `thm:winding-lift`; GPVwind Def 4.1,
Prop 4.2, Def 5.11): the lift predicate `IsLift` (pr₁∘Γ = γ, Def 4.1),
the printed equivalence lift ⟺ continuation with the printed
correspondence Γ = (exp∘γ̃, im γ̃), γ̃ = L∘Γ (`isLift_of_continuation`,
`continuation_of_isLift`, `lift_iff_continuation` — Prop 4.2; the reverse
direction CONSUMES the continuous level of §A at every degenerate
passage); Def 5.11 ON THE UNIVERSAL COVER (`IsLoopLift`: pr₁∘Γ = γ∘exp,
iℝ coordinatized by ℝ through `Circle.exp`), with the level tape
(`IsLoopLift.level_tape`), the level's 2π-periodicity — the level of the
cover lift is itself a LOOP even when the lift winds
(`IsLoopLift.level_periodic`, the cover twin of the PROVED stem row
`winding_loop_defect_level_zero`) — and its continuity
(`IsLoopLift.level_continuous`).

§D — THE PASSAGE-LEVEL READOUT AT THE ZEROS AND THE POLE: near an
enumerated zero the level tape runs to −∞ (`zero_passage_level_atBot`;
encounter forms already PROVED: `neg_reals_swept_near_sphereZero`,
`sweepE5_encounter_levels_unbounded_below`), and the E⁺ fibre data over
each encounter is a full S⁶ × ℤ at the ONE level log r
(`zero_passage_manifold_data`); near the POLE the level tape runs to +∞
(`pole_passage_level_atTop`), and the degenerate encounters near the pole
happen ON THE REAL AXIS — the great circle through N — with levels above
every bound (`pole_degenerate_passages`, `pole_passage_manifold_data`,
from C1's simple pole factorization + the real stem); THE LEVEL CIRCLE:
on the compactified level line OnePoint ℝ (the base 𝓑's object line —
`TotalObject.level`, Base.lean — compactified through the one N) the two
ends MEET: the pole end and every zero's end tend to the SAME point ∞
(`level_circle_meets`).

REGISTER (R10, honesty): every row is VALUE-side or E⁺-side — the levels
read here are log‖value‖, the degenerate data lie over the VALUES the
section sweeps. No row identifies a value-side fibre level log r with the
DOMAIN-side transport level Re(sphereZero ·); that identification is the
target `ASection.concentricity` (Theorem.lean, the repository's one open
node), and the PROVED wedge rows `sweepE5_encounter_level_not_unique` /
`sweepE5_encounter_levels_unbounded_below` (SweepE5 §B) show the
value-side register alone assigns no canonical level to a zero-sphere.

`sorry` marks UNFORMALIZED, never UNSOUND (R8); this file carries none.
-/
import Concentricity.WeldW3
import Concentricity.SweepE5
import Mathlib.Analysis.SpecialFunctions.Complex.Circle

noncomputable section

open Filter

namespace Octonion

/-! ## §0 — continuity supplements (the artifact-local topology of 𝕆)

WeldW3 §W0 installs the product (= norm) topology of the Cayley–Dickson
pair ℍ × ℍ with `ContinuousAdd` and `ContinuousSMul ℝ`. The rows below
add the group structure and the componentwise continuity of the repo's
own coordinates — DERIVED (R10), everything componentwise from Mathlib's
`Quaternion.continuous_re` / `continuous_normSq` / `continuous_coe`. -/

/-- The additive group topology of the Cayley–Dickson pair (Prod
instance), in the `inferInstanceAs` pattern of WeldW3 §W0. -/
instance : IsTopologicalAddGroup Octonion :=
  inferInstanceAs (IsTopologicalAddGroup (Quaternion ℝ × Quaternion ℝ))

/-- The real part is continuous (first quaternion component's `re`). -/
theorem continuous_re : Continuous re := by
  show Continuous fun x : Quaternion ℝ × Quaternion ℝ => x.1.re
  exact Quaternion.continuous_re.comp continuous_fst

/-- The Cayley–Dickson `normSq` is continuous (sum of the two
quaternionic `normSq`). -/
theorem continuous_normSq : Continuous normSq := by
  show Continuous fun x : Quaternion ℝ × Quaternion ℝ =>
    Quaternion.normSq x.1 + Quaternion.normSq x.2
  exact (Quaternion.continuous_normSq.comp continuous_fst).add
    (Quaternion.continuous_normSq.comp continuous_snd)

/-- The Euclidean norm is continuous. -/
theorem continuous_norm : Continuous norm :=
  Real.continuous_sqrt.comp continuous_normSq

/-- The real embedding ℝ → 𝕆 is continuous. -/
theorem continuous_ofReal : Continuous ofReal := by
  show Continuous fun r : ℝ => (((r : ℝ) : Quaternion ℝ), (0 : Quaternion ℝ))
  exact Quaternion.continuous_coe.prodMk continuous_const

/-- The imaginary part is continuous: `im x = x − ofReal (re x)`. -/
theorem continuous_im : Continuous im :=
  continuous_id.sub (continuous_ofReal.comp continuous_re)

/-! ## §A — THE CONTINUOUS LEVEL

The author's standing correction (2026-07-07), verbatim: "THE LIFT DOES
NOT AVOID THE DEGENERATE VALUES — it passes THROUGH them; that is where
log r lives; THE LEVEL EXTENDS CONTINUOUSLY (log|value| is continuous
wherever the value ≠ 0 — always). Rem 2.1 concerns the DIRECTION field
only." (GPVwind Rem 2.1, SOURCES/GPVwind.md, verbatim: "the function 𝓘
cannot be extended as a continuous function to any single point of the
real axis ℝ of 𝕂" — the DIRECTION; the LEVEL has no such obstruction.) -/

/-- **The level is continuous off 0 — always, degenerate passages
included** (the author's correction (1) as a theorem). The level function
log‖·‖ is continuous at every nonzero octonion, in particular at every
negative real — the degenerate values of `lem:exp-degenerate` — where the
DIRECTION field of GPVwind Rem 2.1 has no continuous extension. PROVED. -/
theorem continuousOn_log_norm :
    ContinuousOn (fun q : Octonion => Real.log (norm q)) {q : Octonion | q ≠ 0} := by
  intro q hq
  exact ((Real.continuousAt_log (ne_of_gt (norm_pos_of_ne_zero hq))).comp
    continuous_norm.continuousAt).continuousWithinAt

/-- **The level tape of a nonvanishing value path is continuous** — the
path form of `continuousOn_log_norm`: through every degenerate passage
(values on ℝ⁻ included) the level log‖γ t‖ moves continuously. PROVED. -/
theorem level_tape_continuous (γ : C(unitInterval, Octonion))
    (hγ : ∀ t, γ t ≠ 0) :
    Continuous fun t => Real.log (norm (γ t)) :=
  (continuous_norm.comp (map_continuous γ)).log
    fun t => ne_of_gt (norm_pos_of_ne_zero (hγ t))

/-- **The register conversion LEVEL = log‖VALUE‖, octonionic total form**
(VS Def 5.3, SOURCES/VS.md, verbatim: "L(q, p) := log|q| + p" — the level
coordinate of the E⁺-logarithm is the log-modulus of the value; master
`thm:slice-exp`, verbatim: "Consequently |exp q| = e^{re q} depends only
on the real part"): the real part of ANY point equals the log-modulus of
its exponential value. The octonionic twin of the PROVED stem row
`sweepE5_level_readout` (SweepE5 §A). PROVED, one line from the proved
`norm_exp` (Toolkit.lean). -/
theorem level_eq_log_norm_exp (q : Octonion) :
    re q = Real.log (norm (exp q)) := by
  rw [norm_exp, Real.log_exp]

/-- **The octonionic level tape** (comb row U1(a); GPV §5 prose, ar5iv
paragraph S5.p2, verbatim — transcribed by the 2026-07-07 literature
comb, not yet a SOURCES/GPVwind.md pin (flagged): "if γ([a,b]) ⊂ ℝ, then,
necessarily either γ([a,b]) ⊂ ℝ⁻ and we have the lifts of the form
Γ(t) = log|γ(t)| + I(2k+1)π, or γ([a,b]) ⊂ ℝ⁺ and then we have the lifts
of the form Γ(t) = log|γ(t)| + I2kπ for any I ∈ 𝕊." — the level of the
printed lift IS log|γ(t)|): at EVERY instant, any octonionic
log-continuation's level is the log-modulus of the value under it. The
octonionic twin of the PROVED `sweepE5_lift_level_tape`. PROVED. -/
theorem lift_level_tape (γ Γ : C(unitInterval, Octonion))
    (hlift : ∀ t, exp (Γ t) = γ t) (t : unitInterval) :
    re (Γ t) = Real.log (norm (γ t)) := by
  rw [← hlift t, norm_exp, Real.log_exp]

/-- **The lift's level is continuous with NO continuity assumed of the
lift** (the author's correction (1), sharpest form): for a BARE function
Γ' satisfying exp∘Γ' = γ pointwise — the direction/height data of Γ' may
jump arbitrarily at every degenerate passage (Rem 2.1's obstruction) —
the LEVEL t ↦ re (Γ' t) is nonetheless continuous, because it equals the
value's own level tape log‖γ t‖. The level rides the VALUE; the direction
never enters. PROVED. -/
theorem lift_level_continuous (γ : C(unitInterval, Octonion))
    (Γ' : unitInterval → Octonion) (hlift : ∀ t, exp (Γ' t) = γ t) :
    Continuous fun t => re (Γ' t) := by
  have hγ : ∀ t, γ t ≠ 0 := fun t => by
    rw [← hlift t]; exact exp_ne_zero _
  have heq : (fun t => re (Γ' t)) = fun t => Real.log (norm (γ t)) := by
    funext t
    rw [← hlift t, norm_exp, Real.log_exp]
  rw [heq]
  exact level_tape_continuous γ hγ

/-- **The level datum is lift-independent**: any two lift data over the
one value path carry the SAME level at every instant — the sphere/band
freedom of the fibre (the "for any I ∈ 𝕊" and the k of GPV's printed
lifts) moves directions and heights only, never the level. PROVED. -/
theorem lift_level_unique (γ : C(unitInterval, Octonion))
    (Γ₁ Γ₂ : unitInterval → Octonion) (h₁ : ∀ t, exp (Γ₁ t) = γ t)
    (h₂ : ∀ t, exp (Γ₂ t) = γ t) (t : unitInterval) :
    re (Γ₁ t) = re (Γ₂ t) := by
  rw [show re (Γ₁ t) = Real.log (norm (γ t)) from by
      rw [← h₁ t, norm_exp, Real.log_exp],
    show re (Γ₂ t) = Real.log (norm (γ t)) from by
      rw [← h₂ t, norm_exp, Real.log_exp]]

/-- **Closure in the level is unconditional, octonionic register**: along
any CLOSED octonionic value path, every log-continuation closes in the
LEVEL outright — "all multiplicity in the fibre lies in the winding
direction ([Cor. 5.21]{GPVwind}), none in the level" (master, placement
paragraph). The octonionic twin of the PROVED stem row
`winding_loop_defect_level_zero` (LoopAssembly §A). PROVED. -/
theorem lift_loop_level_closes (γ : C(unitInterval, Octonion))
    (hloop : γ 0 = γ 1) (Γ' : unitInterval → Octonion)
    (hlift : ∀ t, exp (Γ' t) = γ t) :
    re (Γ' 1) = re (Γ' 0) := by
  rw [show re (Γ' 1) = Real.log (norm (γ 1)) from by
      rw [← hlift 1, norm_exp, Real.log_exp],
    show re (Γ' 0) = Real.log (norm (γ 0)) from by
      rw [← hlift 0, norm_exp, Real.log_exp],
    hloop]

/-- The fibre formula of `lem:exp-degenerate` in iff form at a point (the
proved `exp_fibre_neg_real` (Toolkit.lean) read off the set former). -/
theorem exp_eq_neg_ofReal_iff {r : ℝ} (hr : 0 < r) (q : Octonion) :
    exp q = ofReal (-r) ↔ ∃ v ∈ unitImaginarySphere, ∃ k : ℤ,
      q = sliceEmbed v ⟨Real.log r, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩ := by
  have h := Set.ext_iff.mp (exp_fibre_neg_real hr) q
  simpa only [Set.mem_setOf_eq] using h

/-- **The lift of a negative real segment — THROUGH the degenerate set**
(comb row U1(b); GPV §5 prose S5.p2, verbatim quote in `lift_level_tape`'s
docstring: "either γ([a,b]) ⊂ ℝ⁻ and we have the lifts of the form
Γ(t) = log|γ(t)| + I(2k+1)π … for any I ∈ 𝕊"): a value path running
entirely along the negative reals — entirely INSIDE the degenerate set of
VS Rem 5.2(b) — has, for EVERY direction I ∈ S⁶ and every odd rung 2k+1,
a continuous octonionic lift whose level is the continuous log|γ(t)| and
whose height and direction are CONSTANT. This is where log r lives (the
author's correction (1)); the lift exists AT and THROUGH the degenerate
values. PROVED. -/
theorem real_segment_lift_neg (x : C(unitInterval, ℝ)) (hx : ∀ t, x t < 0)
    {v : Octonion} (hv : v ∈ unitImaginarySphere) (k : ℤ) :
    ∃ Γ : C(unitInterval, Octonion),
      (∀ t, exp (Γ t) = ofReal (x t)) ∧
      ∀ t, Γ t = sliceEmbed v ⟨Real.log |x t|, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩ := by
  have hcont : Continuous fun t : unitInterval =>
      ofReal (Real.log |x t|) + (((2 * k + 1 : ℤ) : ℝ) * Real.pi) • v := by
    refine Continuous.add ?_ continuous_const
    exact continuous_ofReal.comp
      ((continuous_abs.comp (map_continuous x)).log
        fun t => ne_of_gt (abs_pos.mpr (ne_of_lt (hx t))))
  refine ⟨⟨fun t => ofReal (Real.log |x t|)
      + (((2 * k + 1 : ℤ) : ℝ) * Real.pi) • v, hcont⟩, fun t => ?_, fun t => rfl⟩
  show exp (sliceEmbed v ⟨Real.log |x t|, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩)
      = ofReal (x t)
  have hr : 0 < -x t := by linarith [hx t]
  have habs : |x t| = -(x t) := abs_of_neg (hx t)
  have h := (exp_eq_neg_ofReal_iff hr
    (sliceEmbed v ⟨Real.log (-(x t)), ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩)).mpr
    ⟨v, hv, k, rfl⟩
  rw [habs, h, neg_neg]

/-- **The lift of a positive real segment** (GPV §5 prose S5.p2, verbatim
quote in `lift_level_tape`'s docstring: "or γ([a,b]) ⊂ ℝ⁺ and then we
have the lifts of the form Γ(t) = log|γ(t)| + I2kπ for any I ∈ 𝕊"): the
even-rung lifts over the positive reals; at k = 0 the lift is the real
branch log∘γ itself — GPVwind Rem 2.1's own closing clause
(SOURCES/GPVwind.md, verbatim): "the function Arg … can be extended (as
the zero function) to the positive real axis ℝ⁺ of 𝕂." PROVED. -/
theorem real_segment_lift_pos (x : C(unitInterval, ℝ)) (hx : ∀ t, 0 < x t)
    {v : Octonion} (hv : v ∈ unitImaginarySphere) (k : ℤ) :
    ∃ Γ : C(unitInterval, Octonion),
      (∀ t, exp (Γ t) = ofReal (x t)) ∧
      ∀ t, Γ t = sliceEmbed v ⟨Real.log |x t|, ((2 * k : ℤ) : ℝ) * Real.pi⟩ := by
  have hcont : Continuous fun t : unitInterval =>
      ofReal (Real.log |x t|) + (((2 * k : ℤ) : ℝ) * Real.pi) • v := by
    refine Continuous.add ?_ continuous_const
    exact continuous_ofReal.comp
      ((continuous_abs.comp (map_continuous x)).log
        fun t => ne_of_gt (abs_pos.mpr (ne_of_gt (hx t))))
  refine ⟨⟨fun t => ofReal (Real.log |x t|)
      + (((2 * k : ℤ) : ℝ) * Real.pi) • v, hcont⟩, fun t => ?_, fun t => rfl⟩
  show exp (sliceEmbed v ⟨Real.log |x t|, ((2 * k : ℤ) : ℝ) * Real.pi⟩)
      = ofReal (x t)
  rw [exp_sliceEmbed' hv]
  have hexp : Complex.exp ⟨Real.log |x t|, ((2 * k : ℤ) : ℝ) * Real.pi⟩
      = ((x t : ℝ) : ℂ) := by
    have habs : |x t| = x t := abs_of_pos (hx t)
    apply Complex.ext
    · rw [Complex.exp_re, Complex.ofReal_re]
      show Real.exp (Real.log |x t|) * Real.cos (((2 * k : ℤ) : ℝ) * Real.pi) = x t
      rw [habs, Real.exp_log (hx t), Real.cos_int_mul_pi,
        Even.neg_one_zpow (⟨k, by ring⟩ : Even (2 * k)), _root_.mul_one]
    · rw [Complex.exp_im, Complex.ofReal_im]
      show Real.exp (Real.log |x t|) * Real.sin (((2 * k : ℤ) : ℝ) * Real.pi) = 0
      rw [Real.sin_int_mul_pi, mul_zero]
  rw [hexp]
  exact sliceEmbed_ofReal v (x t)

/-! ## §B — THE E⁺ ENVIRONMENT (master `thm:log-manifold`)

Master `thm:log-manifold` (verbatim): "Let T : 𝕆 → 𝕆 × im 𝕆,
T(x+Iy) = (sinh x cos y + I sinh x sin y, Iy), and 𝕆⁺ = {q : re q > 0}.
The *logarithm manifold* is E⁺_𝕆 := T(𝕆⁺), the semi-helicoidal
hypercomplex 8-manifold; equivalently it is the image of the exponential
graph, parametrised by the *E⁺_𝕆-exponential* E : 𝕆 → E⁺_𝕆 ⊂ 𝕆 × im 𝕆,
E(x+Iy) = (exp(x+Iy), Iy) = (e^x cos y + Ie^x sin y, Iy), an immersion
and a diffeomorphism, with inverse the *E⁺_𝕆-logarithm* L : E⁺_𝕆 → 𝕆,
L(q,p) = log|q| + p (here p = Arg(q)). Writing π for the projection to
the first factor, π∘E = exp (Theorem thm:slice-exp); but
π : E⁺_𝕆 → 𝕆∖{0} is *not* a covering and not an open map, precisely
because exp is not open. Thus E⁺_𝕆 is an adapted blow-up of 𝕆 along the
real axis: it unwraps the multivalued logarithm into the single-valued L,
and a branch of the hypercomplex logarithm is log_𝕆 = L∘(π|_Ω)⁻¹ on any
path-connected Ω ⊂ E⁺_𝕆 on which π|_Ω is injective."
(Cites: [Prop. 5.1, Rem. 5.2, Def. 5.3, Prop. 5.4, Def. 5.5]{VS};
[§3]{GPVwind}.)

RENDERING NOTE (R10): the master's own "equivalently" clause is what is
transcribed — the manifold as the image of the exponential graph,
parametrised by E. The sinh presentation T(𝕆⁺) (VS Prop 5.1's f) and the
smooth ("immersion and diffeomorphism", "semi-helicoidal") structure are
recorded here, untranscribed; the transcribable content of the diffeo
clause — the mutually inverse pair (E, L) — is proved below. -/

/-- **The E⁺_𝕆-exponential** (VS Prop 5.1, SOURCES/VS.md, verbatim: "The
𝓔⁺_𝕂-exponential map E : 𝕂 → 𝓔⁺_𝕂 ⊂ 𝕂 × Im(𝕂) defined by:
E(x+Iy) = (exp(x+Iy), Iy) = (exp x cos y + I exp x sin y, Iy) is an
immersion and a diffeomorphism between 𝕂 and 𝓔⁺_𝕂. … this manifold will
be denoted simply by 𝓔⁺_𝕂, and called the logarithm manifold."): on the
repo's type, E(q) = (exp q, im q) — for q = x + Iy the second factor Iy
is exactly `Octonion.im q`. -/
def Eexp (q : Octonion) : Octonion × Octonion := (exp q, im q)

/-- **The logarithm manifold E⁺_𝕆** — the image of the exponential graph
(master `thm:log-manifold`, the "equivalently" clause, quoted in the
section header). The degenerate spheres of VS Rem 5.2(b) live INSIDE it
(`logManifold_fibre_neg_real` below). -/
def logManifold : Set (Octonion × Octonion) := Set.range Eexp

/-- **The commuting triangle π∘E = exp** (VS Rem 5.2(a), SOURCES/VS.md,
verbatim: "If π : 𝕂 × Im(𝕂) → 𝕂 denotes the projection on the first
factor, then by definition the following equality holds
(π ∘ E)(q) = exp(q) for all q ∈ 𝕂."). Definitional, as printed ("by
definition"). -/
theorem pr1_Eexp (q : Octonion) : (Eexp q).1 = exp q := rfl

/-- The second factor of E is the argument datum Iy = im q
(VS Def 5.3: "p is called the argument of q, and denoted by Arg(q)"). -/
theorem pr2_Eexp (q : Octonion) : (Eexp q).2 = im q := rfl

/-- **The E⁺_𝕆-logarithm** (VS Def 5.3, SOURCES/VS.md, verbatim: "The
𝓔⁺_𝕂-logarithm L : 𝓔⁺_𝕂 ⊂ 𝕂 × Im(𝕂) → 𝕂 is defined as follows, in terms
of the real logarithm log, L(q, p) := log|q| + p"). Stated on all of
𝕆 × 𝕆 (the manifold-membership rows below consume it on E⁺_𝕆, VS's
domain). -/
def Llog (x : Octonion × Octonion) : Octonion :=
  ofReal (Real.log (norm x.1)) + x.2

/-- **L∘E = id** (VS Prop 5.4, SOURCES/VS.md, verbatim: "The map
L : 𝓔⁺_𝕂 → 𝕂 is the inverse of the 𝓔⁺_𝕂-exponential E, and a
diffeomorphism from 𝓔⁺_𝕂 to 𝕂." — the left-inverse identity; the smooth
structure is recorded, untranscribed). The single-valuedness of the
master's "it unwraps the multivalued logarithm into the single-valued L".
PROVED from the proved `norm_exp` (Toolkit.lean). -/
theorem Llog_Eexp (q : Octonion) : Llog (Eexp q) = q := by
  show ofReal (Real.log (norm (exp q))) + im q = q
  rw [norm_exp, Real.log_exp]
  show ofReal (re q) + (q - ofReal (re q)) = q
  abel

/-- E is injective (the transcribable face of Prop 5.1's "immersion and a
diffeomorphism"). PROVED from the left inverse. -/
theorem Eexp_injective : Function.Injective Eexp := fun a b hab => by
  rw [← Llog_Eexp a, ← Llog_Eexp b, hab]

/-- **E∘L = id on the manifold** (VS Prop 5.4, the right-inverse
identity). PROVED. -/
theorem Eexp_Llog {x : Octonion × Octonion} (hx : x ∈ logManifold) :
    Eexp (Llog x) = x := by
  obtain ⟨q, rfl⟩ := hx
  rw [Llog_Eexp]

/-- **exp(L x) = π x on the manifold** — the display closing VS Def 5.5
(SOURCES/VS.md, the paragraph after Def 5.5, verbatim): "Notice that, as
expected, with the notations of Definition 5.5 we have that
exp(log_𝕂 q) = π(E(L(π|_Ω⁻¹(q)))) = π(π|_Ω⁻¹(q)) = q for all q in
π(Ω)." PROVED. -/
theorem exp_Llog {x : Octonion × Octonion} (hx : x ∈ logManifold) :
    exp (Llog x) = x.1 := by
  obtain ⟨q, rfl⟩ := hx
  rw [Llog_Eexp]
  rfl

/-- **THE LEVEL COMPONENT OF L** (VS Def 5.3's "log|q|" clause, read on
the level register): on the manifold, the level of the L-logarithm of a
point is the log-modulus of its value — re∘L = log‖π(·)‖. This is the
register conversion the whole file rides; the E⁺ form of
`level_eq_log_norm_exp`. PROVED. -/
theorem re_Llog_of_mem {x : Octonion × Octonion} (hx : x ∈ logManifold) :
    re (Llog x) = Real.log (norm x.1) := by
  obtain ⟨q, rfl⟩ := hx
  rw [Llog_Eexp]
  exact level_eq_log_norm_exp q

/-- **Every direction of S⁶ and every odd rung is realized in the
manifold over a degenerate value** — the S⁶ of directions available at a
passage (VS Rem 5.2(b), SOURCES/VS.md, verbatim: exp "is not an open map
(it has a non–empty degenerate set consisting of spheres)"). PROVED. -/
theorem degenerate_sphere_mem {r : ℝ} (hr : 0 < r) {v : Octonion}
    (hv : v ∈ unitImaginarySphere) (k : ℤ) :
    (ofReal (-r), (((2 * k + 1 : ℤ) : ℝ) * Real.pi) • v) ∈ logManifold := by
  refine ⟨sliceEmbed v ⟨Real.log r, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩, ?_⟩
  have h1 : exp (sliceEmbed v ⟨Real.log r, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩)
      = ofReal (-r) :=
    (exp_eq_neg_ofReal_iff hr _).mpr ⟨v, hv, k, rfl⟩
  have h2 : im (sliceEmbed v ⟨Real.log r, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩)
      = (((2 * k + 1 : ℤ) : ℝ) * Real.pi) • v := im_sliceEmbed hv _
  show (exp _, im _) = _
  rw [h1, h2]

/-- **The degenerate locus inside E⁺_𝕆** (master `lem:exp-degenerate`
lifted through the graph; VS Rem 5.2(b)'s "degenerate set consisting of
spheres" as it sits inside the manifold): the fibre of π over −r within
E⁺_𝕆 is exactly the family of direction 6-spheres at the odd rungs,
paired with the one value. PROVED from the proved
`Octonion.exp_fibre_neg_real` (Toolkit.lean). -/
theorem logManifold_fibre_neg_real {r : ℝ} (hr : 0 < r) :
    {x : Octonion × Octonion | x ∈ logManifold ∧ x.1 = ofReal (-r)}
      = {x : Octonion × Octonion | ∃ v ∈ unitImaginarySphere, ∃ k : ℤ,
          x = (ofReal (-r), (((2 * k + 1 : ℤ) : ℝ) * Real.pi) • v)} := by
  ext x
  simp only [Set.mem_setOf_eq]
  constructor
  · rintro ⟨⟨q, rfl⟩, h1⟩
    have hq : exp q = ofReal (-r) := h1
    obtain ⟨v, hv, k, rfl⟩ := (exp_eq_neg_ofReal_iff hr q).mp hq
    refine ⟨v, hv, k, ?_⟩
    show (exp _, im _) = _
    rw [hq, im_sliceEmbed hv]
  · rintro ⟨v, hv, k, rfl⟩
    exact ⟨degenerate_sphere_mem hr hv k, rfl⟩

/-- **The level readout at a degenerate passage**: every manifold point
over the value −r has L-level exactly log r — "The fibre is thus indexed
by the single real level log r = log|−r|" (master `lem:exp-degenerate`,
verbatim). PROVED. -/
theorem degenerate_level_readout {r : ℝ} (hr : 0 < r)
    {x : Octonion × Octonion} (hx : x ∈ logManifold)
    (h1 : x.1 = ofReal (-r)) :
    re (Llog x) = Real.log r := by
  rw [re_Llog_of_mem hx, h1, norm_ofReal, abs_neg, abs_of_pos hr]

/-- **The unit imaginary sphere S⁶ is path-connected on the repo's own
type** (master `thm:G2-S6`'s underlying sphere; the octonionic
difference of WELD STEP (a), WeldW3: on the stem the direction set is
the disconnected S⁰). Antipodal pairs are joined by WeldW3's proved
great-circle row `direction_path_to_neg`; non-antipodal pairs by the
normalized segment, which never vanishes (the segment (1−t)u + tw of two
unit vectors vanishes only at t = 1/2 with w = −u). PROVED. -/
theorem sphere_path {u w : Octonion} (hu : u ∈ unitImaginarySphere)
    (hw : w ∈ unitImaginarySphere) :
    ∃ p : C(unitInterval, Octonion), p 0 = u ∧ p 1 = w ∧
      ∀ t, p t ∈ unitImaginarySphere := by
  by_cases hwu : w = -u
  · subst hwu
    obtain ⟨p, h0, h1, hmem, -⟩ := direction_path_to_neg hu
    exact ⟨p, h0, h1, hmem⟩
  · have hnormSq_u : normSq u = 1 := hu.2
    have hnormSq_w : normSq w = 1 := hw.2
    set seg : C(unitInterval, Octonion) :=
      ⟨fun t => (1 - (t : ℝ)) • u + (t : ℝ) • w,
        ((continuous_const.sub continuous_subtype_val).smul
          continuous_const).add
          (continuous_subtype_val.smul continuous_const)⟩ with hseg_def
    have hseg_val : ∀ t : unitInterval,
        seg t = (1 - (t : ℝ)) • u + (t : ℝ) • w := fun _ => rfl
    have hne : ∀ t : unitInterval, seg t ≠ 0 := by
      intro t h0
      rw [hseg_val t] at h0
      have h1 : (1 - (t : ℝ)) • u = -((t : ℝ) • w) :=
        eq_neg_of_add_eq_zero_left h0
      have h2 := congrArg normSq h1
      rw [normSq_smul,
        show -((t : ℝ) • w) = (-1 : ℝ) • ((t : ℝ) • w) from
          (neg_one_smul ℝ _).symm,
        normSq_smul, normSq_smul, hnormSq_u, hnormSq_w] at h2
      have h3 : (1 - (t : ℝ)) ^ 2 = (t : ℝ) ^ 2 := by linear_combination h2
      have hthalf : (t : ℝ) = 1 / 2 := by linear_combination (-(1 : ℝ) / 2) * h3
      apply hwu
      have h6 : ((2 : ℝ) * (1 - (t : ℝ))) • u + ((2 : ℝ) * (t : ℝ)) • w
          = (0 : Octonion) := by
        rw [← smul_smul, ← smul_smul, ← smul_add, h0, smul_zero]
      rw [hthalf] at h6
      norm_num at h6
      exact eq_neg_of_add_eq_zero_right h6
    have hnorm_pos : ∀ t : unitInterval, 0 < norm (seg t) :=
      fun t => norm_pos_of_ne_zero (hne t)
    set p : C(unitInterval, Octonion) :=
      ⟨fun t => (norm (seg t))⁻¹ • seg t,
        ((continuous_norm.comp (map_continuous seg)).inv₀
          fun t => (hnorm_pos t).ne').smul (map_continuous seg)⟩ with hp_def
    have hp_val : ∀ t : unitInterval,
        p t = (norm (seg t))⁻¹ • seg t := fun _ => rfl
    have hmem : ∀ t, p t ∈ unitImaginarySphere := by
      intro t
      refine ⟨?_, ?_⟩
      · rw [hp_val t, re_smul]
        have hre0 : re (seg t) = 0 := by
          rw [hseg_val t, re_add, re_smul, re_smul, hu.1, hw.1]
          ring
        rw [hre0, mul_zero]
      · rw [hp_val t]
        exact normSq_normalize (hne t)
    have hseg0 : seg 0 = u := by
      rw [hseg_val 0]
      show (1 - ((0 : unitInterval) : ℝ)) • u + ((0 : unitInterval) : ℝ) • w = u
      norm_num
    have hseg1 : seg 1 = w := by
      rw [hseg_val 1]
      show (1 - ((1 : unitInterval) : ℝ)) • u + ((1 : unitInterval) : ℝ) • w = w
      norm_num
    have hnorm_u : norm u = 1 := by
      show Real.sqrt (normSq u) = 1
      rw [hnormSq_u, Real.sqrt_one]
    have hnorm_w : norm w = 1 := by
      show Real.sqrt (normSq w) = 1
      rw [hnormSq_w, Real.sqrt_one]
    refine ⟨p, ?_, ?_, hmem⟩
    · rw [hp_val 0, hseg0, hnorm_u, inv_one, one_smul]
    · rw [hp_val 1, hseg1, hnorm_w, inv_one, one_smul]

/-- **THE FIBRE IS CONNECTED THROUGH THE DIRECTIONS — the octonionic
difference at a degenerate passage**: any two directions of the one
degenerate 6-sphere (fixed value −r, fixed odd rung 2k+1) are joined by a
continuous path running entirely INSIDE the fibre over −r. Over the stem
ℂ the same fibre {log r + i(2k+1)π : k ∈ ℤ} is a discrete set — nothing
joins anything. This is VS Rem 5.2(b)'s "degenerate set consisting of
spheres" doing its work: the sphere is a CONNECTED object. PROVED. -/
theorem exp_fibre_sphere_connected {r : ℝ} (hr : 0 < r) {v₀ v₁ : Octonion}
    (hv₀ : v₀ ∈ unitImaginarySphere) (hv₁ : v₁ ∈ unitImaginarySphere)
    (k : ℤ) :
    ∃ p : C(unitInterval, Octonion),
      p 0 = sliceEmbed v₀ ⟨Real.log r, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩ ∧
      p 1 = sliceEmbed v₁ ⟨Real.log r, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩ ∧
      ∀ t, exp (p t) = ofReal (-r) := by
  obtain ⟨q, hq0, hq1, hqmem⟩ := sphere_path hv₀ hv₁
  set p : C(unitInterval, Octonion) :=
    ⟨fun t => ofReal (Real.log r) + (((2 * k + 1 : ℤ) : ℝ) * Real.pi) • q t,
      continuous_const.add (continuous_const.smul (map_continuous q))⟩
      with hp_def
  have hp_slice : ∀ t : unitInterval,
      p t = sliceEmbed (q t) ⟨Real.log r, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩ :=
    fun _ => rfl
  refine ⟨p, ?_, ?_, fun t => ?_⟩
  · rw [hp_slice 0, hq0]
  · rw [hp_slice 1, hq1]
  · rw [hp_slice t]
    exact (exp_eq_neg_ofReal_iff hr _).mpr ⟨q t, hqmem t, k, rfl⟩

/-- **The stem-conjugate pair is JOINED over 𝕆** — the sharpest form of
the octonionic difference: the two stem fibre points log r ± i(2k+1)π,
DISCONNECTED over ℂ, are the two ends of one continuous path inside the
octonionic fibre (the S⁶ path from v to −v, WeldW3's great circle;
φ_{−v}(w̄) = φ_v(w), `sliceEmbed_neg_conj`). This is why the base 𝓑 keeps
only the LEVEL as an object label — the height's sign is not even a
well-defined datum of the octonionic sphere ("Winding is band data, never
an object label", master `def:base`). PROVED. -/
theorem exp_fibre_conj_joined {r : ℝ} (hr : 0 < r) {v : Octonion}
    (hv : v ∈ unitImaginarySphere) (k : ℤ) :
    ∃ p : C(unitInterval, Octonion),
      p 0 = sliceEmbed v ⟨Real.log r, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩ ∧
      p 1 = sliceEmbed v ⟨Real.log r, -(((2 * k + 1 : ℤ) : ℝ) * Real.pi)⟩ ∧
      ∀ t, exp (p t) = ofReal (-r) := by
  have hvneg : -v ∈ unitImaginarySphere := by
    constructor
    · rw [show -v = (-1 : ℝ) • v from (neg_one_smul ℝ v).symm, re_smul, hv.1]
      ring
    · rw [show -v = (-1 : ℝ) • v from (neg_one_smul ℝ v).symm, normSq_smul,
        hv.2]
      norm_num
  obtain ⟨p, h0, h1, hexp⟩ := exp_fibre_sphere_connected hr hv hvneg k
  refine ⟨p, h0, ?_, hexp⟩
  rw [h1]
  have hconj : (starRingEnd ℂ) ⟨Real.log r, -(((2 * k + 1 : ℤ) : ℝ) * Real.pi)⟩
      = ⟨Real.log r, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩ := by
    apply Complex.ext
    · rw [Complex.conj_re]
    · rw [Complex.conj_im]
      ring
  rw [← hconj, sliceEmbed_neg_conj]

/-- **THE DEGENERATE PASSAGE, bundled** (mission row (b)): an octonionic
value path hitting −r at t₀ has (i) at the passage instant, the FULL
S⁶ × ℤ of E⁺ lift data over its value, every one of them at the single
level log r; (ii) a level tape continuous through the passage — the
passage is where log r lives, and the level crosses it continuously (the
author's correction (1)); (iii) the tape reading log r at t₀. PROVED. -/
theorem degenerate_passage (γ : C(unitInterval, Octonion))
    (hγ : ∀ t, γ t ≠ 0) {t₀ : unitInterval} {r : ℝ} (hr : 0 < r)
    (ht₀ : γ t₀ = ofReal (-r)) :
    (∀ v ∈ unitImaginarySphere, ∀ k : ℤ,
        (γ t₀, (((2 * k + 1 : ℤ) : ℝ) * Real.pi) • v) ∈ logManifold ∧
        re (Llog (γ t₀, (((2 * k + 1 : ℤ) : ℝ) * Real.pi) • v)) = Real.log r)
    ∧ Continuous (fun t => Real.log (norm (γ t)))
    ∧ Real.log (norm (γ t₀)) = Real.log r := by
  refine ⟨fun v hv k => ?_, level_tape_continuous γ hγ, ?_⟩
  · rw [ht₀]
    have hmem := degenerate_sphere_mem hr hv k
    exact ⟨hmem, degenerate_level_readout hr hmem rfl⟩
  · rw [ht₀, norm_ofReal, abs_neg, abs_of_pos hr]

/-! ## §C — THE WINDING LIFT (master `thm:winding-lift`)

Master `thm:winding-lift` (verbatim): "Let γ : [a,b] → 𝕆 ∖ {0} be a path
(on each slice ℂ_v this is the classical complex continuation). A
*continuation of the hypercomplex logarithm along γ* is a path
γ̃ : [a,b] → 𝕆 with exp∘γ̃ = γ, and a *lift of γ* to the logarithm
manifold E⁺_𝕆 (Theorem thm:log-manifold) is a path Γ : [a,b] → E⁺_𝕆 with
pr₁∘Γ = γ. … The two data are *equivalent*: a lift Γ exists if and only
if a continuation γ̃ exists, and they correspond by γ̃ = L∘Γ,
Γ = (exp∘γ̃, im γ̃), where L is the E⁺_𝕆-logarithm of Theorem
thm:log-manifold ([Prop. 4.2]{GPVwind}). For a *loop* γ : S¹ → 𝕆∖{0} the
lift is taken on the universal cover exp : iℝ → S¹, as a continuous
Γ : iℝ → E⁺_𝕆 with pr₁∘Γ = γ∘exp ([Def. 5.11]{GPVwind})." -/

/-- **The lift of a path to E⁺_𝕆** (GPVwind Def 4.1, SOURCES/GPVwind.md,
verbatim: "Let γ : [a,b] → 𝕂∖{0} be a path. Then a path
Γ : [a,b] → 𝓔⁺_𝕂 is a lift of γ (to 𝓔⁺_𝕂) if pr₁∘Γ = γ"). The
E⁺-membership clause carries "Γ : [a,b] → 𝓔⁺_𝕂"; the `commutes` clause is
the printed composite. -/
structure IsLift (γ : C(unitInterval, Octonion))
    (Γ : C(unitInterval, Octonion × Octonion)) : Prop where
  mem : ∀ t, Γ t ∈ logManifold
  commutes : ∀ t, (Γ t).1 = γ t

/-- **Continuation ⟹ lift, with the printed correspondence
Γ = (exp∘γ̃, im γ̃)** (master `thm:winding-lift`; GPVwind Prop 4.2's easy
direction): a continuation γ̃ of the hypercomplex logarithm along γ hands
the E⁺-lift (exp∘γ̃, im γ̃) = E∘γ̃. Continuity of the lift needs only the
continuity of γ and of `im` (§0) — never the direction field. PROVED. -/
theorem isLift_of_continuation (γ γ' : C(unitInterval, Octonion))
    (h : ∀ t, exp (γ' t) = γ t) :
    ∃ Γ : C(unitInterval, Octonion × Octonion),
      IsLift γ Γ ∧ ∀ t, Γ t = Eexp (γ' t) := by
  have hcont : Continuous fun t : unitInterval =>
      ((γ t, im (γ' t)) : Octonion × Octonion) :=
    (map_continuous γ).prodMk (continuous_im.comp (map_continuous γ'))
  refine ⟨⟨fun t => (γ t, im (γ' t)), hcont⟩, ⟨fun t => ?_, fun t => rfl⟩,
    fun t => ?_⟩
  · refine ⟨γ' t, ?_⟩
    show (exp (γ' t), im (γ' t)) = _
    rw [h t]
    rfl
  · show ((γ t, im (γ' t)) : Octonion × Octonion) = (exp (γ' t), im (γ' t))
    rw [h t]

/-- **Lift ⟹ continuation, with the printed correspondence γ̃ = L∘Γ**
(master `thm:winding-lift`; GPVwind Prop 4.2): the E⁺-logarithm of the
lift is a continuation. THE CONTINUOUS LEVEL IS THE LOAD-BEARING STEP:
the continuity of γ̃ = L∘Γ at a degenerate passage is exactly §A's
`level_tape_continuous` — the level component log‖γ t‖ of L moves
continuously through the passage (the author's correction (1)), while
the argument component (Γ t).2 rides the continuous Γ. PROVED. -/
theorem continuation_of_isLift (γ : C(unitInterval, Octonion))
    (hγ : ∀ t, γ t ≠ 0) (Γ : C(unitInterval, Octonion × Octonion))
    (h : IsLift γ Γ) :
    ∃ γ' : C(unitInterval, Octonion),
      (∀ t, exp (γ' t) = γ t) ∧ ∀ t, γ' t = Llog (Γ t) := by
  have heq : (fun t : unitInterval => Llog (Γ t))
      = fun t => ofReal (Real.log (norm (γ t))) + (Γ t).2 := by
    funext t
    show ofReal (Real.log (norm ((Γ t).1))) + (Γ t).2 = _
    rw [h.commutes t]
  have hcont : Continuous fun t : unitInterval => Llog (Γ t) := by
    rw [heq]
    exact (continuous_ofReal.comp (level_tape_continuous γ hγ)).add
      (continuous_snd.comp (map_continuous Γ))
  refine ⟨⟨fun t => Llog (Γ t), hcont⟩, fun t => ?_, fun t => rfl⟩
  show exp (Llog (Γ t)) = γ t
  rw [exp_Llog (h.mem t), h.commutes t]

/-- **"The two data are equivalent"** (master `thm:winding-lift`,
verbatim; GPVwind Prop 4.2): a lift to E⁺_𝕆 exists iff a continuation of
the hypercomplex logarithm exists. PROVED. -/
theorem lift_iff_continuation (γ : C(unitInterval, Octonion))
    (hγ : ∀ t, γ t ≠ 0) :
    (∃ Γ : C(unitInterval, Octonion × Octonion), IsLift γ Γ)
      ↔ ∃ γ' : C(unitInterval, Octonion), ∀ t, exp (γ' t) = γ t := by
  constructor
  · rintro ⟨Γ, hΓ⟩
    obtain ⟨γ', h1, -⟩ := continuation_of_isLift γ hγ Γ hΓ
    exact ⟨γ', h1⟩
  · rintro ⟨γ', h⟩
    obtain ⟨Γ, hΓ, -⟩ := isLift_of_continuation γ γ' h
    exact ⟨Γ, hΓ⟩

/-- **The loop lift on the universal cover** (GPVwind Def 5.11,
SOURCES/GPVwind.md, verbatim: "Let γ : S¹ → 𝕂∖{0} be a continuous loop.
Then a continuous function Γ : iℝ → 𝓔⁺ is a lift of γ if the following
diagram commutes:" — the printed square has vertices iℝ, Γ(iℝ) ⊂ 𝓔⁺_𝕂,
S¹, γ(S¹) ⊂ 𝕂∖{0} with arrows Γ, exp, pr₁, γ; its commutativity is
pr₁∘Γ = γ∘exp. Master `thm:winding-lift`, verbatim: "For a loop
γ : S¹ → 𝕆∖{0} the lift is taken on the universal cover exp : iℝ → S¹,
as a continuous Γ : iℝ → E⁺_𝕆 with pr₁∘Γ = γ∘exp").

RENDERING: iℝ is coordinatized by ℝ through y ↦ iy, under which the
printed cover exp : iℝ → S¹ is Mathlib's `Circle.exp : C(ℝ, Circle)`
(`Circle.coe_exp`: ↑(Circle.exp y) = Complex.exp (y·i), definitional);
Γ's continuity is carried by the bundled `C(ℝ, ·)`. -/
structure IsLoopLift (γ : C(Circle, Octonion))
    (Γ : C(ℝ, Octonion × Octonion)) : Prop where
  mem : ∀ y : ℝ, Γ y ∈ logManifold
  commutes : ∀ y : ℝ, (Γ y).1 = γ (Circle.exp y)

/-- **The level tape of the loop lift**: at every cover instant, the
lift's L-level is the log-modulus of the loop value under it (VS
Def 5.3's level component along Def 5.11's square). PROVED. -/
theorem IsLoopLift.level_tape {γ : C(Circle, Octonion)}
    {Γ : C(ℝ, Octonion × Octonion)} (h : IsLoopLift γ Γ) (y : ℝ) :
    re (Llog (Γ y)) = Real.log (norm (γ (Circle.exp y))) := by
  rw [re_Llog_of_mem (h.mem y), h.commutes y]

/-- **THE LEVEL OF THE COVER LIFT IS ITSELF A LOOP** — 2π-periodic even
when Γ winds: the lift on the universal cover may climb the rungs (the
winding, GPVwind Cor 5.21 — band data), but its LEVEL descends to the
circle unconditionally, because it is the level tape of the 2π-periodic
value γ∘exp. The cover form of the PROVED stem row
`winding_loop_defect_level_zero` (LoopAssembly §A: "all multiplicity in
the fibre lies in the winding direction …, none in the level", master
placement paragraph). PROVED. -/
theorem IsLoopLift.level_periodic {γ : C(Circle, Octonion)}
    {Γ : C(ℝ, Octonion × Octonion)} (h : IsLoopLift γ Γ) (y : ℝ) :
    re (Llog (Γ (y + 2 * Real.pi))) = re (Llog (Γ y)) := by
  rw [h.level_tape, h.level_tape, Circle.exp_add_two_pi]

/-- **The level of the cover lift is continuous** — across every
degenerate passage of the loop's values (the author's correction (1) on
the cover). PROVED. -/
theorem IsLoopLift.level_continuous {γ : C(Circle, Octonion)}
    {Γ : C(ℝ, Octonion × Octonion)} (h : IsLoopLift γ Γ)
    (hγ : ∀ z, γ z ≠ 0) :
    Continuous fun y : ℝ => re (Llog (Γ y)) := by
  have heq : (fun y : ℝ => re (Llog (Γ y)))
      = fun y => Real.log (norm (γ (Circle.exp y))) := by
    funext y
    rw [h.level_tape y]
  rw [heq]
  exact (continuous_norm.comp
      ((map_continuous γ).comp (map_continuous Circle.exp))).log
    fun y => ne_of_gt (norm_pos_of_ne_zero (hγ _))

end Octonion

/-! ## §D — THE PASSAGE-LEVEL READOUT AT THE ZEROS AND THE POLE

What the degenerate passages carry near the two marked points of an
A-section: near an enumerated zero the values sweep every small negative
real (`neg_reals_swept_near_sphereZero`, LoopAssembly §C, PROVED) and the
level tape runs to −∞; near the pole (C1, verbatim: "meromorphic
continuation with exactly one pole; simple, at a real point, of value
∞ = N") the level tape runs to +∞, and the degenerate encounters happen
ON THE REAL AXIS — the great circle ℝ ∪ {N} through the witness. The two
ends of the level line meet on the compactified level circle
(`level_circle_meets`): the base 𝓑's object line (`TotalObject.level`,
Base.lean — "objects = the real levels of the degenerate fibre", master
`def:base`), compactified through the one N. -/

/-- The coe ℝ → OnePoint ℝ carries the cocompact filter to the point at
infinity — the compactification of the level line into the level CIRCLE
(both ends of ℝ close up at the single ∞). -/
theorem level_coe_cocompact_tendsto :
    Filter.Tendsto ((↑) : ℝ → OnePoint ℝ) (Filter.cocompact ℝ)
      (nhds OnePoint.infty) := by
  rw [← Filter.coclosedCompact_eq_cocompact]
  exact OnePoint.tendsto_coe_infty

namespace ASection

/-- **The passage levels at an enumerated zero run to −∞** — the full
tape form of the PROVED encounter rows (`neg_reals_swept_near_sphereZero`
LoopAssembly §C; `sweepE5_encounter_levels_unbounded_below` SweepE5 §B):
along EVERY punctured approach to the n-th zero-sphere the value-side
level log‖A(z)‖ tends to −∞ — the zero is the −∞ end of the level line
in the value register. (F vanishes at the enumerated zero,
`stem_zero_of_sphereZero`; the zero is isolated by C3's local peel
`stem_local_form`, so the tape is defined on the punctured
neighbourhood.) PROVED. -/
theorem zero_passage_level_atBot (A : ASection) (n : ℕ) :
    Filter.Tendsto (fun z => Real.log ‖A.F z‖)
      (nhdsWithin (A.sphereZero n) {A.sphereZero n}ᶜ) Filter.atBot := by
  have him : 0 < (A.sphereZero n).im := A.c3_sphere_nonreal n
  have hap : A.sphereZero n ≠ (A.pole : ℂ) := by
    intro h; rw [h] at him; simp at him
  have hFa : A.F (A.sphereZero n) = 0 := A.stem_zero_of_sphereZero n
  have han : AnalyticAt ℂ A.F (A.sphereZero n) := A.c1_analyticAt _ hap
  obtain ⟨G, hGa, hGne, hev⟩ := A.stem_local_form n
  have hGnear : ∀ᶠ z in nhds (A.sphereZero n), G z ≠ 0 :=
    hGa.continuousAt.eventually_ne hGne
  have hne : ∀ᶠ z in nhdsWithin (A.sphereZero n) {A.sphereZero n}ᶜ,
      A.F z ≠ 0 := by
    filter_upwards [eventually_nhdsWithin_of_eventually_nhds hev,
      eventually_nhdsWithin_of_eventually_nhds hGnear,
      self_mem_nhdsWithin] with z h1 h2 hz
    rw [h1]
    exact mul_ne_zero (pow_ne_zero _ (sub_ne_zero.mpr hz)) h2
  have h0 : Filter.Tendsto (fun z => ‖A.F z‖)
      (nhdsWithin (A.sphereZero n) {A.sphereZero n}ᶜ) (nhds 0) := by
    have h1 := (han.continuousAt.tendsto).mono_left
      (nhdsWithin_le_nhds :
        nhdsWithin (A.sphereZero n) {A.sphereZero n}ᶜ ≤ _)
    rw [hFa] at h1
    simpa using h1.norm
  have hmem : Filter.Tendsto (fun z => ‖A.F z‖)
      (nhdsWithin (A.sphereZero n) {A.sphereZero n}ᶜ)
      (nhdsWithin 0 (Set.Ioi 0)) := by
    rw [tendsto_nhdsWithin_iff]
    exact ⟨h0, hne.mono fun z hz => Set.mem_Ioi.mpr (norm_pos_iff.mpr hz)⟩
  exact Real.tendsto_log_nhdsGT_zero.comp hmem

/-- **The passage levels at the pole run to +∞** — the other end of the
level line: at the one simple pole (C1) the values leave every bounded
set (`pole_cone_tendsto`, LoopAssembly §C, PROVED — the cone at N), so
the value-side level log‖A(z)‖ tends to +∞. The pole is the +∞ end of
the level line in the value register — "values near N: levels
log r → +∞". PROVED. -/
theorem pole_passage_level_atTop (A : ASection) :
    Filter.Tendsto (fun z => Real.log ‖A.F z‖)
      (nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ) Filter.atTop :=
  Real.tendsto_log_atTop.comp
    (tendsto_norm_cobounded_atTop.comp A.pole_cone_tendsto)

/-- **The degenerate encounters NEAR THE POLE lie on the real axis — the
great circle through N — with levels above every bound.** C1's simple
pole factorizes the stem as F = (z − p)⁻¹·g with g analytic and
nonvanishing at p (`meromorphicOrderAt_eq_int_iff` at `c1_simple`); g is
REAL at the real pole (the intrinsic stem, `real_on_real`), so on the
side of the pole where (x − p) opposes the sign of g(p) the section's
values are NEGATIVE REALS of modulus above every bound: degenerate
values −r with level log r > M, arbitrarily close to the pole, ON the
real axis ℝ ⊂ ℝ ∪ {N} (the fixed great circle of the translation
groupoid, master §The architecture). Every such encounter value carries
its full octonionic fibre at the ONE level log r
(`pole_passage_manifold_data` below). PROVED. -/
theorem pole_degenerate_passages (A : ASection) (M : ℝ) :
    ∀ δ > 0, ∃ x : ℝ, x ≠ A.pole ∧ |x - A.pole| < δ ∧
      ∃ r : ℝ, 0 < r ∧ M < Real.log r ∧ A.F ((x : ℝ) : ℂ) = -(r : ℂ) := by
  -- C1's factorization at the simple pole
  have hmer : MeromorphicAt A.F (A.pole : ℂ) :=
    A.meromorphic _ (Set.mem_univ _)
  obtain ⟨g, hg_an, hg_ne, hg_eq⟩ :=
    (meromorphicOrderAt_eq_int_iff hmer).mp A.c1_simple
  -- the coe ℝ → ℂ carries the punctured real line into the punctured plane
  have hcoe : Filter.Tendsto (fun x : ℝ => ((x : ℝ) : ℂ))
      (nhdsWithin A.pole {A.pole}ᶜ)
      (nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ) := by
    rw [tendsto_nhdsWithin_iff]
    constructor
    · exact (Complex.continuous_ofReal.tendsto _).mono_left nhdsWithin_le_nhds
    · filter_upwards [self_mem_nhdsWithin] with x hx
      exact Set.mem_compl_singleton_iff.mpr
        fun h => hx (Complex.ofReal_injective h)
  -- g is real at the pole: g = (z − p)·F on the punctured line, F real on ℝ
  have hgx_eventually : ∀ᶠ x : ℝ in nhdsWithin A.pole {A.pole}ᶜ,
      (g ((x : ℝ) : ℂ)).im = 0 := by
    filter_upwards [hcoe.eventually hg_eq, self_mem_nhdsWithin] with x hx hxne
    have hsub_ne : ((x : ℝ) : ℂ) - (A.pole : ℂ) ≠ 0 := by
      rw [sub_ne_zero]
      exact fun h => hxne (Complex.ofReal_injective h)
    have hg_val : g ((x : ℝ) : ℂ)
        = (((x : ℝ) : ℂ) - (A.pole : ℂ)) * A.F ((x : ℝ) : ℂ) := by
      rw [hx, zpow_neg_one, smul_eq_mul]
      field_simp
    rw [hg_val, ← Complex.ofReal_sub, Complex.im_ofReal_mul,
      A.real_on_real x, mul_zero]
  have hg_real : (g (A.pole : ℂ)).im = 0 := by
    have hlim : Filter.Tendsto (fun x : ℝ => (g ((x : ℝ) : ℂ)).im)
        (nhdsWithin A.pole {A.pole}ᶜ) (nhds ((g (A.pole : ℂ)).im)) :=
      (Complex.continuous_im.tendsto _).comp
        ((hg_an.continuousAt.tendsto).comp
          (hcoe.mono_right nhdsWithin_le_nhds))
    have hzero : Filter.Tendsto (fun x : ℝ => (g ((x : ℝ) : ℂ)).im)
        (nhdsWithin A.pole {A.pole}ᶜ) (nhds 0) :=
      Filter.Tendsto.congr' (hgx_eventually.mono fun x hx => hx.symm)
        tendsto_const_nhds
    exact tendsto_nhds_unique hlim hzero
  set c : ℝ := (g (A.pole : ℂ)).re with hc_def
  have hc : c ≠ 0 := by
    intro h0
    apply hg_ne
    apply Complex.ext
    · rw [Complex.zero_re, ← hc_def]; exact h0
    · rw [Complex.zero_im]; exact hg_real
  have habs_c : 0 < |c| := abs_pos.mpr hc
  -- the factorization radius and the g-continuity radius
  rw [Filter.eventually_iff] at hg_eq
  obtain ⟨ε₁, hε₁, hball⟩ := Metric.mem_nhdsWithin_iff.mp hg_eq
  obtain ⟨ε₂, hε₂, hg_close⟩ :=
    Metric.continuousAt_iff.mp hg_an.continuousAt (|c| / 2)
      (half_pos habs_c)
  intro δ hδ
  set B : ℝ := min (min (min δ ε₁) ε₂) (|c| / 2 * Real.exp (-M)) with hB_def
  have hB : 0 < B :=
    lt_min (lt_min (lt_min hδ hε₁) hε₂)
      (mul_pos (half_pos habs_c) (Real.exp_pos _))
  set η : ℝ := B / 2 with hη_def
  have hη : 0 < η := half_pos hB
  have hηB : η < B := by rw [hη_def]; linarith
  have hBle₁ : B ≤ δ :=
    le_trans (min_le_left _ _) (le_trans (min_le_left _ _) (min_le_left _ _))
  have hBle₂ : B ≤ ε₁ :=
    le_trans (min_le_left _ _) (le_trans (min_le_left _ _) (min_le_right _ _))
  have hBle₃ : B ≤ ε₂ := le_trans (min_le_left _ _) (min_le_right _ _)
  have hBle₄ : B ≤ |c| / 2 * Real.exp (-M) := min_le_right _ _
  -- the g-side re-bound at distance η
  have hclose : ∀ x : ℝ, |x - A.pole| = η →
      |(g ((x : ℝ) : ℂ)).re - c| < |c| / 2 := by
    intro x hxdist
    have hdistC : dist ((x : ℝ) : ℂ) (A.pole : ℂ) = |x - A.pole| := by
      rw [dist_eq_norm, ← Complex.ofReal_sub, Complex.norm_real,
        Real.norm_eq_abs]
    have hg_close' : dist (g ((x : ℝ) : ℂ)) (g (A.pole : ℂ)) < |c| / 2 := by
      apply hg_close
      rw [hdistC, hxdist]
      linarith
    calc |(g ((x : ℝ) : ℂ)).re - c|
        = |(g ((x : ℝ) : ℂ) - g (A.pole : ℂ)).re| := by
          rw [Complex.sub_re, hc_def]
      _ ≤ ‖g ((x : ℝ) : ℂ) - g (A.pole : ℂ)‖ := Complex.abs_re_le_norm _
      _ < |c| / 2 := by rw [← dist_eq_norm]; exact hg_close'
  -- the shared endgame: any point at distance η on the negative side
  have key : ∀ x : ℝ, x ≠ A.pole → |x - A.pole| = η →
      |(g ((x : ℝ) : ℂ)).re - c| < |c| / 2 →
      (x - A.pole)⁻¹ * (g ((x : ℝ) : ℂ)).re < 0 →
      ∃ r : ℝ, 0 < r ∧ M < Real.log r ∧ A.F ((x : ℝ) : ℂ) = -(r : ℂ) := by
    intro x hxne hxdist hcl hsign
    have hdistC : dist ((x : ℝ) : ℂ) (A.pole : ℂ) = |x - A.pole| := by
      rw [dist_eq_norm, ← Complex.ofReal_sub, Complex.norm_real,
        Real.norm_eq_abs]
    have hxC_ne : ((x : ℝ) : ℂ) ≠ (A.pole : ℂ) := by
      exact_mod_cast hxne
    have hball_mem : ((x : ℝ) : ℂ)
        ∈ Metric.ball (A.pole : ℂ) ε₁ ∩ {(A.pole : ℂ)}ᶜ := by
      constructor
      · rw [Metric.mem_ball, hdistC, hxdist]
        linarith
      · exact Set.mem_compl_singleton_iff.mpr hxC_ne
    have hfact : A.F ((x : ℝ) : ℂ)
        = (((x : ℝ) : ℂ) - (A.pole : ℂ)) ^ (-1 : ℤ) • g ((x : ℝ) : ℂ) :=
      hball hball_mem
    have hFx : A.F ((x : ℝ) : ℂ)
        = (((x - A.pole : ℝ) : ℂ))⁻¹ * g ((x : ℝ) : ℂ) := by
      rw [hfact, zpow_neg_one, smul_eq_mul, Complex.ofReal_sub]
    have hFre : (A.F ((x : ℝ) : ℂ)).re
        = (x - A.pole)⁻¹ * (g ((x : ℝ) : ℂ)).re := by
      rw [hFx, ← Complex.ofReal_inv, Complex.re_ofReal_mul]
    have hFim : (A.F ((x : ℝ) : ℂ)).im = 0 := A.real_on_real x
    have hre_mag : |c| / 2 ≤ |(g ((x : ℝ) : ℂ)).re| := by
      have h1 := abs_sub_abs_le_abs_sub c ((g ((x : ℝ) : ℂ)).re)
      rw [abs_sub_comm] at h1
      linarith
    have hFneg : (A.F ((x : ℝ) : ℂ)).re < 0 := by
      rw [hFre]; exact hsign
    refine ⟨-(A.F ((x : ℝ) : ℂ)).re, by linarith, ?_, ?_⟩
    · rw [Real.lt_log_iff_exp_lt (by linarith)]
      have habs_x : 0 < |x - A.pole| := abs_pos.mpr (sub_ne_zero.mpr hxne)
      have hr_eq : -(A.F ((x : ℝ) : ℂ)).re
          = |(g ((x : ℝ) : ℂ)).re| / |x - A.pole| := by
        rw [← abs_of_neg hFneg, hFre, abs_mul, abs_inv, inv_mul_eq_div]
      rw [hr_eq, lt_div_iff₀ habs_x]
      calc Real.exp M * |x - A.pole| = Real.exp M * η := by rw [hxdist]
        _ < Real.exp M * B :=
            mul_lt_mul_of_pos_left hηB (Real.exp_pos M)
        _ ≤ Real.exp M * (|c| / 2 * Real.exp (-M)) :=
            mul_le_mul_of_nonneg_left hBle₄ (Real.exp_pos M).le
        _ = |c| / 2 := by
            rw [Real.exp_neg]
            field_simp
        _ ≤ |(g ((x : ℝ) : ℂ)).re| := hre_mag
    · apply Complex.ext
      · rw [Complex.neg_re, Complex.ofReal_re, neg_neg]
      · rw [Complex.neg_im, Complex.ofReal_im, neg_zero]
        exact hFim
  -- the side choice by the sign of g(p)
  rcases lt_or_gt_of_ne hc with hcneg | hcpos
  · -- c < 0: the RIGHT side x = p + η, where (x − p)⁻¹ > 0 and re g < 0
    set x : ℝ := A.pole + η with hx_def
    have hxsub : x - A.pole = η := by rw [hx_def]; ring
    have hxne : x ≠ A.pole := by
      rw [hx_def]
      exact ne_of_gt (by linarith)
    have hxdist : |x - A.pole| = η := by rw [hxsub, abs_of_pos hη]
    have hcl := hclose x hxdist
    have hgneg : (g ((x : ℝ) : ℂ)).re < 0 := by
      have h1 : (g ((x : ℝ) : ℂ)).re - c ≤ |(g ((x : ℝ) : ℂ)).re - c| :=
        le_abs_self _
      rw [abs_of_neg hcneg] at hcl
      linarith
    have hsign : (x - A.pole)⁻¹ * (g ((x : ℝ) : ℂ)).re < 0 := by
      rw [hxsub]
      exact mul_neg_of_pos_of_neg (inv_pos.mpr hη) hgneg
    obtain ⟨r, hr, hrM, hFr⟩ := key x hxne hxdist hcl hsign
    exact ⟨x, hxne, by rw [hxdist]; linarith, r, hr, hrM, hFr⟩
  · -- c > 0: the LEFT side x = p − η, where (x − p)⁻¹ < 0 and re g > 0
    set x : ℝ := A.pole - η with hx_def
    have hxsub : x - A.pole = -η := by rw [hx_def]; ring
    have hxne : x ≠ A.pole := by
      rw [hx_def]
      exact ne_of_lt (by linarith)
    have hxdist : |x - A.pole| = η := by rw [hxsub, abs_neg, abs_of_pos hη]
    have hcl := hclose x hxdist
    have hgpos : 0 < (g ((x : ℝ) : ℂ)).re := by
      rw [abs_of_pos hcpos, abs_lt] at hcl
      linarith [hcl.1]
    have hsign : (x - A.pole)⁻¹ * (g ((x : ℝ) : ℂ)).re < 0 := by
      rw [hxsub, inv_neg]
      exact mul_neg_of_neg_of_pos (neg_lt_zero.mpr (inv_pos.mpr hη)) hgpos
    obtain ⟨r, hr, hrM, hFr⟩ := key x hxne hxdist hcl hsign
    exact ⟨x, hxne, by rw [hxdist]; linarith, r, hr, hrM, hFr⟩

/-- **What the passages near a zero carry** (mission row (d), zero side):
within any ε of the n-th enumerated zero there are degenerate encounters
at values −r with level log r BELOW every bound M
(`sweepE5_encounter_levels_unbounded_below`, PROVED), and over each
encounter value the E⁺ manifold holds the FULL S⁶ × ℤ of fibre data —
every direction, every odd rung — all of it at the ONE level log r. The
levels met near a zero run to −∞ along the value register. PROVED. -/
theorem zero_passage_manifold_data (A : ASection) (n : ℕ) :
    ∀ ε > 0, ∀ M : ℝ, ∃ r : ℝ, 0 < r ∧ Real.log r < M ∧
      (∃ z : ℂ, dist z (A.sphereZero n) < ε ∧ A.F z = -(r : ℂ)) ∧
      ∀ v ∈ Octonion.unitImaginarySphere, ∀ k : ℤ,
        (Octonion.ofReal (-r), (((2 * k + 1 : ℤ) : ℝ) * Real.pi) • v)
            ∈ Octonion.logManifold ∧
        Octonion.re (Octonion.Llog
          (Octonion.ofReal (-r), (((2 * k + 1 : ℤ) : ℝ) * Real.pi) • v))
            = Real.log r := by
  intro ε hε M
  obtain ⟨r, hr, hrM, z, hz, hzv⟩ :=
    A.sweepE5_encounter_levels_unbounded_below n ε hε M
  refine ⟨r, hr, hrM, ⟨z, hz, hzv⟩, fun v hv k => ?_⟩
  have hmem := Octonion.degenerate_sphere_mem hr hv k
  exact ⟨hmem, Octonion.degenerate_level_readout hr hmem rfl⟩

/-- **What the passages near the pole carry** (mission row (d), pole
side): within any δ of the pole, ON THE REAL AXIS, there are degenerate
encounters at values −r with level log r ABOVE every bound M
(`pole_degenerate_passages`), and over each encounter value the E⁺
manifold holds the full S⁶ × ℤ of fibre data at the ONE level log r. The
levels met near the pole run to +∞ along the value register. PROVED. -/
theorem pole_passage_manifold_data (A : ASection) (M : ℝ) :
    ∀ δ > 0, ∃ x : ℝ, x ≠ A.pole ∧ |x - A.pole| < δ ∧
      ∃ r : ℝ, 0 < r ∧ M < Real.log r ∧ A.F ((x : ℝ) : ℂ) = -(r : ℂ) ∧
      ∀ v ∈ Octonion.unitImaginarySphere, ∀ k : ℤ,
        (Octonion.ofReal (-r), (((2 * k + 1 : ℤ) : ℝ) * Real.pi) • v)
            ∈ Octonion.logManifold ∧
        Octonion.re (Octonion.Llog
          (Octonion.ofReal (-r), (((2 * k + 1 : ℤ) : ℝ) * Real.pi) • v))
            = Real.log r := by
  intro δ hδ
  obtain ⟨x, hxne, hxδ, r, hr, hrM, hFr⟩ := A.pole_degenerate_passages M δ hδ
  refine ⟨x, hxne, hxδ, r, hr, hrM, hFr, fun v hv k => ?_⟩
  have hmem := Octonion.degenerate_sphere_mem hr hv k
  exact ⟨hmem, Octonion.degenerate_level_readout hr hmem rfl⟩

/-- **THE LEVEL CIRCLE — the two ends meet at the one N** (the author's
great circle of levels: the base 𝓑 compactified through N). On the
compactified level line OnePoint ℝ — the base's object line
(`TotalObject.level` : TotalObject → ℝ, Base.lean; master `def:base`:
"objects = the real levels of the degenerate fibre") closed up at a
single point at infinity — the value-side level tape of an A-section
tends to the SAME point ∞ along the pole (levels → +∞,
`pole_passage_level_atTop`) and along every enumerated zero (levels
→ −∞, `zero_passage_level_atBot`): the +∞ end and the −∞ end of the
level line are one point of the circle. The pole and the zeros are the
two ends of the level line, meeting through the one N — the compactified
reading of C1's cone (`rmk:collapse-cone`; the c3_atN register note:
"Every mirror circle closes through the one N"). REGISTER (R10): a
statement about the VALUE-side tape; no placement claim rides on it.
PROVED. -/
theorem level_circle_meets (A : ASection) (n : ℕ) :
    Filter.Tendsto (fun z => ((Real.log ‖A.F z‖ : ℝ) : OnePoint ℝ))
      (nhdsWithin (A.pole : ℂ) {(A.pole : ℂ)}ᶜ) (nhds OnePoint.infty)
    ∧ Filter.Tendsto (fun z => ((Real.log ‖A.F z‖ : ℝ) : OnePoint ℝ))
      (nhdsWithin (A.sphereZero n) {A.sphereZero n}ᶜ)
      (nhds OnePoint.infty) :=
  ⟨level_coe_cocompact_tendsto.comp
      (A.pole_passage_level_atTop.mono_right atTop_le_cocompact),
    level_coe_cocompact_tendsto.comp
      ((A.zero_passage_level_atBot n).mono_right atBot_le_cocompact)⟩

end ASection
