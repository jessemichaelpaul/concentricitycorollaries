/-
Concentricity/InboxWire.lean

THE INBOX WIRE (2026-07-07, author-directed): the ranked UNTRANSCRIBED
load-bearing items of the four inbox-paper inventories (GPV winding
arXiv:2307.14047v1; AdF *-logarithm; AdFslice/GV Weierstrass; the
categorical pins Riehl/Goerss–Jardine), wired into the A-section as
PROVED rows — each consuming `def:A-section` fields together with the
octonionic register (Octonion.exp / sliceEmbed / dir / the fibre rows).

UNIMPORTED ARTIFACT (KeystoneAssembly / LoopAssembly precedent): not
reachable from Concentricity.lean; the root ledger is untouched. ZERO
sorries in this file — every row is proved on the kernel triple.

THE AUTHOR'S WHY (2026-07-07, the strategy of record, verbatim): "The why
for the target to close IS the literature on octonionic and quaternionic
winding numbers and unique lifts and the GPV degenerate base, and how the
A-section combines the relevant facts from the literature with C1-C4
jointly — an A-section is C1-C4 AND a GPV base with a concentric family
and unique lifts and winding." Each row's docstring records the source
clause it transcribes and the part of the why it wires.

PROVENANCE REGISTER (R2/R10): quotes marked [SOURCES] are from pinned
SOURCES/ files or the master; quotes marked [INBOX] are from the
2026-07-07 full-text inventory of the inbox PDFs (GPV Prop 4.3, Cor 4.4,
Def 3.5 are NOT in SOURCES/GPVwind.md — flagged for the SOURCES pass;
provenance: arXiv:2307.14047v1, the author's own inbox file, read end to
end by the inventory agent).

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file has none.
-/
import Concentricity.WeldW12
import Concentricity.PhiConversion

noncomputable section

open Filter

/-! ## §A — GPV Prop 4.3: the branch ladder, TOTAL (the k-indexed
classification of ALL continuations)

[INBOX] GPV Prop 4.3 (arXiv:2307.14047v1; not in SOURCES/GPVwind.md,
flagged): for γ missing ℝ, "for every k ∈ ℤ there is one and only one
lift Γ_k to E(D_{2k}) with initial point (γ(a), Arg_{2k}(γ(a)))",
explicitly Γ_k(t) = (γ(t), Arg_{2k}(γ(t))), and (log_k∘γ)(t) = L∘Γ_k(t)
= log|γ(t)| + Arg_{2k}(γ(t)) is "the k-th branch of the hypercomplex
logarithm along γ" — THE UNIQUE continuation with that initial point.
[INBOX] GPV Def 3.5 + eq (3.1): the branch identity
Arg_{2l+1} = Arg_{−(2l+2)} — only the EVEN branches are distinct, so the
distinct branches form a single ℤ-ladder.

What was already in-repo: existence (`exists_log_continuation`),
uniqueness from an initial value (`winding_lift_unique`), the
lift-independent defect (`winding_defect_lift_independent`). What was NOT:
the TOTALITY — that the continuations of one value path are EXACTLY the
2πiℤ-ladder over any one of them. That is the content wired here, on the
stem register (the shadow of GPV Def 4.10, the repo's convention). -/

/-- **GPV Prop 4.3's classification, stem form** (the branch ladder is
TOTAL): given one continuation γ₁ of the nonvanishing value path γ, a map
γ₂ is a continuation of γ **iff** it is γ₁ shifted by a constant integer
multiple of 2πi. Forward: the shift is read off at t = 0
(`Complex.exp_eq_exp_iff_exists_int`) and propagated by the uniqueness of
lifts (`winding_lift_unique`, Toolkit.lean — GPVwind Def 4.7's tameness
on the stem); backward: the shift exponentiates away
(`Complex.exp_int_mul_two_pi_mul_I`). This is [INBOX] Prop 4.3's "one and
only one lift Γ_k ... for every k ∈ ℤ" together with [INBOX] Def 3.5's
eq (3.1) (only even branches distinct): the distinct branches of the
hypercomplex logarithm along γ are exactly the ℤ-ladder with rung 2πi.
WHY-WIRE: the unique-lift clause of the author's why — the transport
attached to a value path carries NO data beyond one lift and the ladder;
whatever one branch says at a passage, every branch says. PROVED. -/
theorem lift_ladder (γ γ₁ : C(unitInterval, ℂ)) (hγ : ∀ t, γ t ≠ 0)
    (h₁ : ∀ t, Complex.exp (γ₁ t) = γ t) (γ₂ : C(unitInterval, ℂ)) :
    (∀ t, Complex.exp (γ₂ t) = γ t)
      ↔ ∃ k : ℤ, ∀ t, γ₂ t = γ₁ t + (k : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) := by
  constructor
  · intro h₂
    obtain ⟨n, hn⟩ := Complex.exp_eq_exp_iff_exists_int.mp ((h₂ 0).trans (h₁ 0).symm)
    set γ₃ : C(unitInterval, ℂ) :=
      ⟨fun t => γ₁ t + (n : ℂ) * (2 * (Real.pi : ℂ) * Complex.I),
        (map_continuous γ₁).add continuous_const⟩ with hγ₃
    have h₃ : ∀ t, Complex.exp (γ₃ t) = γ t := by
      intro t
      show Complex.exp (γ₁ t + (n : ℂ) * (2 * (Real.pi : ℂ) * Complex.I)) = γ t
      rw [Complex.exp_add, h₁ t, Complex.exp_int_mul_two_pi_mul_I, mul_one]
    have h0 : γ₂ 0 = γ₃ 0 := by
      show γ₂ 0 = γ₁ 0 + (n : ℂ) * (2 * (Real.pi : ℂ) * Complex.I)
      exact hn
    have heq := winding_lift_unique γ hγ γ₂ γ₃ h₂ h₃ h0
    exact ⟨n, fun t => by rw [heq]; rfl⟩
  · rintro ⟨k, hk⟩ t
    rw [hk t, Complex.exp_add, h₁ t, Complex.exp_int_mul_two_pi_mul_I, mul_one]

namespace ASection

/-- **The k-th branch of log A right of the wall IS the Euler sum plus
2πik** — [INBOX] GPV Prop 4.3 instantiated on the A-section with C2's own
data as the k = 0 branch. Master `def:A-section` C2 (verbatim): "On a
slice right half-space Ω₀ ⊂ 𝕆*, A = exp(∑_p ℓ_p)" — so along ANY domain
path in the half-space, the Euler sum ∑_p ℓ_p is itself a continuation of
the hypercomplex logarithm along A's value path (continuity by
`c2_locMajorant` through the PROVED `continuousOn_eulerSum`,
WeldW12.lean), and by the classification `lift_ladder` the continuations
of A's values are EXACTLY the family {∑_p ℓ_p + 2πik : k ∈ ℤ}.
Consumes C2 in all four clauses: `c2_euler` (the lift equation),
`c2_locMajorant`/`c2_analyticAt` (continuity), `c2_zero_free` through
`zero_free_on_halfSpace` (nonvanishing). WHY-WIRE: "the A-section
combines the relevant facts from the literature with C1–C4 jointly" —
here GPV's branch classification lands with C2 supplying the canonical
branch outright; the transport's lift data over Ω₀ is pinned to the Euler
family with NO freedom beyond the winding rung. PROVED. -/
theorem euler_branch_ladder (A : ASection) (z : C(unitInterval, ℂ))
    (hz : ∀ t, A.Ω₀ < (z t).re) (γ₂ : C(unitInterval, ℂ)) :
    (∀ t, Complex.exp (γ₂ t) = A.F (z t))
      ↔ ∃ k : ℤ, ∀ t, γ₂ t
          = (∑' p : A.ι, A.ℓ p (z t)) + (k : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) := by
  have hopen : IsOpen {w : ℂ | A.Ω₀ < w.re} := isOpen_lt continuous_const Complex.continuous_re
  have hcontE : Continuous fun t : unitInterval => ∑' p : A.ι, A.ℓ p (z t) :=
    continuous_iff_continuousAt.mpr fun t =>
      (A.continuousOn_eulerSum.continuousAt (hopen.mem_nhds (hz t))).comp
        (map_continuous z).continuousAt
  have hcontF : Continuous fun t : unitInterval => A.F (z t) := by
    have heq : (fun t : unitInterval => A.F (z t))
        = fun t => Complex.exp (∑' p : A.ι, A.ℓ p (z t)) :=
      funext fun t => A.c2_euler (z t) (hz t)
    rw [heq]
    exact Complex.continuous_exp.comp hcontE
  exact lift_ladder ⟨fun t => A.F (z t), hcontF⟩
    ⟨fun t => ∑' p : A.ι, A.ℓ p (z t), hcontE⟩
    (fun t => A.zero_free_on_halfSpace (hz t))
    (fun t => (A.c2_euler (z t) (hz t)).symm) γ₂

/-- **The branch-independent level right of the wall** — [INBOX] GPV
Prop 4.3's value→level register conversion ("(log_k∘γ)(t) = L∘Γ_k(t) =
log|γ(t)| + Arg_{2k}(γ(t))" — the level component log|γ(t)| is the SAME
for every k), instantiated on the A-section with C2 NAMING the level:
every branch of log A along a half-space domain path carries, at every
instant, (i) the Euler sum's own level Re Σ ℓ_p — the ladder shift of
`euler_branch_ladder` is purely imaginary — and (ii) the value tape
log‖A(z t)‖ ([SOURCES] VS Def 5.3: "L(q, p) := log|q| + p"). WHY-WIRE:
the two names of the ONE level — C2's analytic name (the Euler sum's real
part) and the GPV base's geometric name (the log-modulus of the value) —
agree branch-independently; the winding freedom of §A never touches it.
PROVED. -/
theorem euler_branch_level (A : ASection) (z : C(unitInterval, ℂ))
    (hz : ∀ t, A.Ω₀ < (z t).re) (γ₂ : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ₂ t) = A.F (z t)) (t : unitInterval) :
    (γ₂ t).re = (∑' p : A.ι, A.ℓ p (z t)).re
    ∧ (γ₂ t).re = Real.log ‖A.F (z t)‖ := by
  constructor
  · obtain ⟨k, hk⟩ := (A.euler_branch_ladder z hz γ₂).mp hlift
    rw [hk t, Complex.add_re]
    have hzero : ((k : ℂ) * (2 * (Real.pi : ℂ) * Complex.I)).re = 0 := by
      simp [Complex.mul_re]
    rw [hzero, add_zero]
  · rw [← hlift t, Complex.norm_exp, Real.log_exp]

end ASection

/-! ## §B — the degenerate passage PINS the band (what uniqueness forces
where the transport meets the degenerate set)

[SOURCES] Master `lem:exp-degenerate` (derivation sentence, verbatim):
"The fibre is thus indexed by the single real level log r = log|−r| and,
within it, by the odd winding indices 2k+1 carried as band data". [SOURCES]
VS Rem 5.2(b) (printed p. 988, verbatim): exp "has a non–empty degenerate
set consisting of spheres". [INBOX] GPV §5 prose (the printed lift over a
negative-real segment, quoted in LogManifold.lean's comb row U1):
"either γ([a,b]) ⊂ ℝ⁻ and we have the lifts of the form
Γ(t) = log|γ(t)| + I(2k+1)π ... for any I ∈ 𝕊".

What was already in-repo: the pointwise fibre rows (`exp_eq_neg_real_iff`,
`exp_fibre_level`, `exp_fibre_height_band`, LoopAssembly §B), arcs OFF the
reals confined to one band (`arc_band_confined`, SigmaE3), and the
EXISTENCE of constant-height lifts along a negative-real segment
(`real_segment_lift_neg`, LogManifold §B). What was NOT: that EVERY
continuous continuation has its height FROZEN along a degenerate stretch —
uniqueness pins the band through the passage; only the level moves. -/

/-- **Rung rigidity**: a continuous real function taking only odd-rung
values (2k+1)π on a stretch is CONSTANT there. Mechanism: two distinct odd
rungs enclose an even rung, the intermediate value theorem
(`intermediate_value_Icc`/`Icc'`) produces a crossing of it, and parity
(2k+1 = 2m is impossible in ℤ) forbids it. The connectedness input is the
stretch's own; no covering theory is consumed. PROVED. -/
theorem odd_rung_rigidity (f : unitInterval → ℝ) (hf : Continuous f)
    {a b : unitInterval} (hab : a ≤ b)
    (hodd : ∀ t, a ≤ t → t ≤ b → ∃ k : ℤ, f t = (2 * (k : ℝ) + 1) * Real.pi) :
    ∀ t, a ≤ t → t ≤ b → f t = f a := by
  intro t ht1 ht2
  obtain ⟨ka, hka⟩ := hodd a le_rfl hab
  obtain ⟨kt, hkt⟩ := hodd t ht1 ht2
  by_contra hne
  have hkane : ka ≠ kt := by
    intro h
    exact hne (by rw [hkt, hka, h])
  have hnoeven : ∀ s : unitInterval, a ≤ s → s ≤ t → ∀ m : ℤ,
      f s ≠ 2 * (m : ℝ) * Real.pi := by
    intro s hs1 hs2 m hs
    obtain ⟨ks, hks⟩ := hodd s hs1 (hs2.trans ht2)
    rw [hks] at hs
    have h1 : (2 * (ks : ℝ) + 1) = 2 * (m : ℝ) := mul_right_cancel₀ Real.pi_ne_zero hs
    have h2 : (2 * ks + 1 : ℤ) = 2 * m := by exact_mod_cast h1
    omega
  have hcont : ContinuousOn f (Set.Icc a t) := hf.continuousOn
  rcases lt_or_gt_of_ne hkane with hlt | hlt
  · -- ka < kt: the even rung 2(ka+1)π lies strictly between f a and f t
    have hcast : ((ka : ℝ) + 1) ≤ (kt : ℝ) := by
      exact_mod_cast Int.lt_iff_add_one_le.mp hlt
    have hy1 : f a < 2 * ((ka : ℝ) + 1) * Real.pi := by
      rw [hka]
      exact mul_lt_mul_of_pos_right (by linarith) Real.pi_pos
    have hy2 : 2 * ((ka : ℝ) + 1) * Real.pi < f t := by
      rw [hkt]
      exact mul_lt_mul_of_pos_right (by linarith) Real.pi_pos
    obtain ⟨s, hs, hfs⟩ := intermediate_value_Icc ht1 hcont ⟨hy1.le, hy2.le⟩
    refine hnoeven s hs.1 hs.2 (ka + 1) ?_
    rw [hfs]
    push_cast
    ring
  · -- kt < ka: the even rung 2(kt+1)π lies strictly between f t and f a
    have hcast : ((kt : ℝ) + 1) ≤ (ka : ℝ) := by
      exact_mod_cast Int.lt_iff_add_one_le.mp hlt
    have hy1 : f t < 2 * ((kt : ℝ) + 1) * Real.pi := by
      rw [hkt]
      exact mul_lt_mul_of_pos_right (by linarith) Real.pi_pos
    have hy2 : 2 * ((kt : ℝ) + 1) * Real.pi < f a := by
      rw [hka]
      exact mul_lt_mul_of_pos_right (by linarith) Real.pi_pos
    obtain ⟨s, hs, hfs⟩ := intermediate_value_Icc' ht1 hcont ⟨hy1.le, hy2.le⟩
    refine hnoeven s hs.1 hs.2 (kt + 1) ?_
    rw [hfs]
    push_cast
    ring

namespace ASection

/-- **THE DEGENERATE STRETCH PINS THE BAND** — what uniqueness forces at a
passage of the A-section's transport through the degenerate set: along any
stretch where A's values ride the negative reals (the degenerate values of
[SOURCES] VS Rem 5.2(b); the encounter data the PROVED
`neg_reals_swept_near_sphereZero` produces near every enumerated zero),
EVERY continuation of the hypercomplex logarithm along A's value path has
(i) its winding height FROZEN at one odd rung (2k+1)π — the band is pinned
for the whole passage, no multiplicity moves in the winding direction —
while (ii) its level at every instant of the passage is the moving tape
log‖A(z t)‖ ([SOURCES] VS Def 5.3: "L(q, p) := log|q| + p"). The pointwise
dual of the master's placement sentence ("all multiplicity in the fibre
lies in the winding direction ..., none in the level", master
`thm:concentricity` proof): ALONG a degenerate stretch, all motion is in
the level, none in the winding. Fed by `lem:exp-degenerate`'s stem iff
(`exp_eq_neg_real_iff`, LoopAssembly §B, PROVED) and `odd_rung_rigidity`;
the value path's own continuity is inherited from the lift (exp∘γ' = A∘z),
so no C1 pole-avoidance hypothesis is consumed. WHY-WIRE: "unique lifts
and the GPV degenerate base" — the passage through the base is where the
lift's freedom dies: one rung, one moving level. PROVED. -/
theorem degenerate_stretch_pins_band (A : ASection) (z : unitInterval → ℂ)
    (γ' : C(unitInterval, ℂ)) (hlift : ∀ t, Complex.exp (γ' t) = A.F (z t))
    {a b : unitInterval} (hab : a ≤ b)
    (hstretch : ∀ t, a ≤ t → t ≤ b → (A.F (z t)).re < 0 ∧ (A.F (z t)).im = 0) :
    ∃ k : ℤ, ∀ t, a ≤ t → t ≤ b →
      (γ' t).im = (2 * (k : ℝ) + 1) * Real.pi
      ∧ (γ' t).re = Real.log ‖A.F (z t)‖ := by
  have hodd : ∀ t, a ≤ t → t ≤ b →
      ∃ k : ℤ, (γ' t).im = (2 * (k : ℝ) + 1) * Real.pi := by
    intro t ht1 ht2
    obtain ⟨hre, him⟩ := hstretch t ht1 ht2
    have hr : 0 < -(A.F (z t)).re := by linarith
    have hval : A.F (z t) = -(((-(A.F (z t)).re : ℝ)) : ℂ) := by
      apply Complex.ext
      · simp
      · simpa using him
    obtain ⟨k, hk⟩ := (exp_eq_neg_real_iff hr (γ' t)).mp (by rw [hlift t]; exact hval)
    refine ⟨k, ?_⟩
    have := congrArg Complex.im hk
    simpa using this
  have hconst := odd_rung_rigidity (fun t => (γ' t).im)
    (Complex.continuous_im.comp (map_continuous γ')) hab hodd
  obtain ⟨k, hk⟩ := hodd a le_rfl hab
  refine ⟨k, fun t ht1 ht2 => ⟨?_, ?_⟩⟩
  · have h := hconst t ht1 ht2
    rw [show ((fun t => (γ' t).im) t = (fun t => (γ' t).im) a) = ((γ' t).im = (γ' a).im)
      from rfl] at h
    rw [h]
    exact hk
  · rw [← hlift t, Complex.norm_exp, Real.log_exp]

end ASection

/-! ## §C — GPV Cor 4.4: loops missing the reals close at EVERY branch

[INBOX] GPV Cor 4.4 (arXiv:2307.14047v1; not in SOURCES/GPVwind.md,
flagged): for loops missing ℝ, "every Γ_k is a loop;
log_k(γ(a)) = log_k(γ(b))". The stem shadow of "missing ℝ" is a value
loop with nonvanishing imaginary part; the slit-plane row
(`stemWinding_eq_zero_of_slitPlane`, SigmaE3, PROVED) absorbs it since
{im ≠ 0} ⊂ ℂ ∖ (−∞, 0]. -/

/-- **GPV Cor 4.4, winding clause, stem form**: a value loop missing the
reals winds zero. [INBOX] Cor 4.4's mechanism on the stem: off the reals
there are no degenerate encounters at all — no rung is ever touched
(`lift_height_pi_iff`, SigmaE3), so no defect can accumulate. PROVED, by
feeding {im ≠ 0} into the slit plane. -/
theorem stemWinding_eq_zero_of_offReal (γ : C(unitInterval, ℂ)) (hloop : γ 0 = γ 1)
    (him : ∀ t, (γ t).im ≠ 0) : stemWinding γ = 0 :=
  stemWinding_eq_zero_of_slitPlane γ hloop fun t =>
    Complex.mem_slitPlane_iff.mpr (Or.inr (him t))

/-- **GPV Cor 4.4, closure clause, stem form**: along a loop missing the
reals, EVERY branch of the logarithm closes — [INBOX] "every Γ_k is a
loop; log_k(γ(a)) = log_k(γ(b))". Assembled from the winding row above,
Cor 5.13's stem-honest closure iff (`stemWinding_eq_zero_iff`, SigmaE3,
PROVED), and the once-one-closes-all-close row (`winding_loop_closed`,
LoopAssembly §A, PROVED). PROVED. -/
theorem offReal_loop_every_branch_closes (γ : C(unitInterval, ℂ)) (hloop : γ 0 = γ 1)
    (him : ∀ t, (γ t).im ≠ 0) (γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) : γ' 1 = γ' 0 := by
  have hγ : ∀ t, γ t ≠ 0 := fun t h => him t (by rw [h, Complex.zero_im])
  obtain ⟨γ₀, h₀, hclose⟩ := (stemWinding_eq_zero_iff γ hγ hloop).mp
    (stemWinding_eq_zero_of_offReal γ hloop him)
  exact winding_loop_closed γ hγ γ₀ h₀ hclose γ' hlift

namespace ASection

/-- **GPV Cor 4.4 wired to the A-section, with the shadow honesty of
`def:section-map`**: if A's value loop misses the reals, then (i) the
DOMAIN loop itself already missed the reals — master `def:section-map`
(verbatim): "A(ℝ) ⊆ ℝ", the PROVED `real_on_real`: an A-section cannot
carry a real domain point off the reals, so every real-axis crossing
downstairs is one upstairs — and (ii) every branch of log A along the
loop closes. Clause (i) is the A-section's honesty for GPVwind Rem 2.1
([SOURCES], verbatim: "the function 𝓘 cannot be extended as a continuous
function to any single point of the real axis ℝ of 𝕂"): the direction
obstruction lives on the SAME crossings in domain and value registers.
WHY-WIRE: the winding literature meets C1–C4 — for value loops that never
touch the degenerate set the entire branch ladder closes rung by rung;
all open behaviour of the transport is concentrated on the real-value
crossings, exactly where the divisor (`stem_zero_of_sphereZero`: zeros
have value 0 ∈ ℝ) and the pole (C1: "at a real point") live. PROVED. -/
theorem offReal_value_loop_closes (A : ASection) (z : unitInterval → ℂ)
    (hz : z 0 = z 1) (him : ∀ t, (A.F (z t)).im ≠ 0) :
    (∀ t, (z t).im ≠ 0)
      ∧ ∀ γ' : C(unitInterval, ℂ),
          (∀ t, Complex.exp (γ' t) = A.F (z t)) → γ' 1 = γ' 0 := by
  constructor
  · intro t ht
    apply him t
    have hzt : z t = (((z t).re : ℝ) : ℂ) := by
      apply Complex.ext
      · rw [Complex.ofReal_re]
      · rw [Complex.ofReal_im]
        exact ht
    rw [hzt]
    exact A.real_on_real ((z t).re)
  · intro γ' hlift
    have hcont : Continuous fun t : unitInterval => A.F (z t) := by
      have heq : (fun t : unitInterval => A.F (z t))
          = fun t => Complex.exp (γ' t) := funext fun t => (hlift t).symm
      rw [heq]
      exact Complex.continuous_exp.comp (map_continuous γ')
    have hloop : (⟨fun t => A.F (z t), hcont⟩ : C(unitInterval, ℂ)) 0
        = (⟨fun t => A.F (z t), hcont⟩ : C(unitInterval, ℂ)) 1 := by
      show A.F (z 0) = A.F (z 1)
      rw [hz]
    exact offReal_loop_every_branch_closes ⟨fun t => A.F (z t), hcont⟩ hloop
      (fun t => him t) γ' hlift

end ASection

/-! ## §D — the divisor marches to N (the factorization's convergence
content at N, wired from `c3_atN`)

Master `def:A-section` C3 asserts the product "converging locally
normally on 𝕆* ∖ {p₀}" — read at N as the quadratic point-density
`c3_atN` (the field's docstring, author-ruled 2026-07-06). The printed
anchor in the inbox factorization paper is the divisor-discreteness
clause consumed by AdFslice Prop 3.1's proof ([INBOX], proof of case (ii),
citing the GSS book Theorem 3.12: "every closed ball of radius < 1
contains only finitely many real and spherical zeroes", with |bₙ| → 1,
|cₙ| → 1) — for the A-section's one-pole class the balls exhaust 𝕆* ∖ {N}
and the march is to N. The finite-in-every-ball row is already PROVED
(`indices_in_closedBall_finite`, PairingE2, from `c3_atN`); wired here is
the march itself, and — jointly with C2's wall and C3's lower edge — its
direction: UP the strip. -/

namespace ASection

/-- **The enumerated divisor leaves every bounded set**: ‖ρₙ‖ → ∞. The
A-section analogue of [INBOX] AdFslice Prop 3.1(ii)'s "|bₙ| → 1, |cₙ| → 1"
(GSS Thm 3.12 through the exhaustion — there the boundary is |q| = 1, here
it is the one point N of `rmk:compactify`): C3's convergence through N
forces the enumeration to march to N. Fed by `c3_atN` through the PROVED
`indices_in_closedBall_finite`. WHY-WIRE: C4 gives infinitely many
zero-spheres, C3-through-N herds all but finitely many of them out of
every chart ball — the degenerate fibre of the transport accumulates at
the cone's tip alone (SCAN §7(iv), now quantitative). PROVED. -/
theorem sphereZero_norm_tendsto_atTop (A : ASection) :
    Filter.Tendsto (fun n => ‖A.sphereZero n‖) Filter.atTop Filter.atTop := by
  rw [← Nat.cofinite_eq_atTop]
  refine Filter.tendsto_atTop.mpr fun R => ?_
  have hfin : {k : ℕ | ¬ R ≤ ‖A.sphereZero k‖}.Finite := by
    refine (A.indices_in_closedBall_finite 0 R).subset fun k hk => ?_
    simp only [Set.mem_setOf_eq, not_le] at hk
    simp only [Set.mem_setOf_eq, Metric.mem_closedBall, dist_zero_right]
    exact hk.le
  exact Filter.eventually_cofinite.mpr hfin

/-- **The divisor climbs the strip to N**: Im ρₙ → +∞ — the march of
`sphereZero_norm_tendsto_atTop` REDIRECTED by the two walls. Jointly
consumed: `c3_atN` (the march, through `indices_in_closedBall_finite`),
`c3_lowerEdge` (the left wall), `c2_zero_free` at the divisor (the right
wall, through the PROVED `re_le_upperEdge` — C2's "each zero-free on Ω₀"
read at C3's enumeration), and `c3_sphere_nonreal` (the upper-half
representatives). The real parts are trapped in the strip [βlo, Ω₀]
(`auditE1_strip`), so escape in norm is escape in height: the residue-ℂ
zero-spheres approach N along the vertical direction of the strip — the
class-wide form of the classical zeros-march-up-the-critical-strip
picture, for EVERY A-section. WHY-WIRE: connects the divisor's POSITIONS
to the N-passage geometry that C1's cone owns; the counting rows of
WeldW12 (`stemWinding_F_stripRect`) count exactly these climbers. PROVED. -/
theorem sphereZero_im_tendsto_atTop (A : ASection) :
    Filter.Tendsto (fun n => (A.sphereZero n).im) Filter.atTop Filter.atTop := by
  obtain ⟨βlo, hlo⟩ := A.c3_lowerEdge
  have hkey : ∀ n, ‖A.sphereZero n‖ + -(max |βlo| |A.Ω₀|) ≤ (A.sphereZero n).im := by
    intro n
    have h1 : ‖A.sphereZero n‖ ≤ |(A.sphereZero n).re| + |(A.sphereZero n).im| :=
      Complex.norm_le_abs_re_add_abs_im _
    have h2 : |(A.sphereZero n).im| = (A.sphereZero n).im :=
      abs_of_pos (A.c3_sphere_nonreal n)
    have h3 : |(A.sphereZero n).re| ≤ max |βlo| |A.Ω₀| := by
      rcases abs_cases (A.sphereZero n).re with ⟨heq, -⟩ | ⟨heq, -⟩
      · rw [heq]
        exact le_trans (le_trans (A.re_le_upperEdge n) (le_abs_self _)) (le_max_right _ _)
      · rw [heq]
        have h4 : -(A.sphereZero n).re ≤ -βlo := neg_le_neg (hlo n)
        exact le_trans (le_trans h4 (neg_le_abs βlo)) (le_max_left _ _)
    linarith
  exact tendsto_atTop_mono hkey
    (tendsto_atTop_add_const_right _ _ A.sphereZero_norm_tendsto_atTop)

/-- **N(T) is well-defined for the whole class**: below every height T
only finitely many enumerated zero-spheres — the strip walls
(`c3_lowerEdge` left, `c2_zero_free`-at-the-divisor right through
`re_le_upperEdge`) close the half-infinite band {Im ≤ T} of upper-half
representatives (`c3_sphere_nonreal`) into a bounded region, and
`c3_atN`'s point-density (`indices_in_closedBall_finite`, PairingE2,
PROVED) traps it. The [INBOX] AdFslice Prop 3.1(ii)/GSS Thm 3.12
finiteness clause in the vocabulary of WeldW12's counting rows: the
trapped-count of `stemWinding_F_stripRect` stabilizes in T — the
class-wide zero-counting function N(T) is a genuine (finite) count, for
EVERY A-section. WHY-WIRE: priority (ii)-(iii) joint — the divisor's
POSITIONS are countable-by-height exactly because C2, C3 and
C3-through-N hold together; the winding ledger counts finite totals.
PROVED. -/
theorem indices_below_height_finite (A : ASection) (T : ℝ) :
    {n : ℕ | (A.sphereZero n).im ≤ T}.Finite := by
  obtain ⟨βlo, hlo⟩ := A.c3_lowerEdge
  refine (A.indices_in_closedBall_finite 0 (max |βlo| |A.Ω₀| + |T|)).subset
    fun n hn => ?_
  simp only [Set.mem_setOf_eq] at hn
  simp only [Set.mem_setOf_eq, Metric.mem_closedBall, dist_zero_right]
  have h1 : ‖A.sphereZero n‖ ≤ |(A.sphereZero n).re| + |(A.sphereZero n).im| :=
    Complex.norm_le_abs_re_add_abs_im _
  have h2 : |(A.sphereZero n).im| ≤ |T| := by
    rw [abs_of_pos (A.c3_sphere_nonreal n)]
    exact le_trans hn (le_abs_self T)
  have h3 : |(A.sphereZero n).re| ≤ max |βlo| |A.Ω₀| := by
    rcases abs_cases (A.sphereZero n).re with ⟨heq, -⟩ | ⟨heq, -⟩
    · rw [heq]
      exact le_trans (le_trans (A.re_le_upperEdge n) (le_abs_self _)) (le_max_right _ _)
    · rw [heq]
      have h4 : -(A.sphereZero n).re ≤ -βlo := neg_le_neg (hlo n)
      exact le_trans (le_trans h4 (neg_le_abs βlo)) (le_max_left _ _)
  linarith

end ASection

/-! ## §E — π₀ of the value world reads EXACTLY the level (the
categorical-analytic joint shape)

[SOURCES] Riehl CHT Rem 8.3.5 (text p. 102, verbatim from the 2026-07-07
categorical inventory): "π₀ : Cat → Set is LEFT ADJOINT to the inclusion";
proof of Lemma 8.3.4 (verbatim): "for any X : C → Set, there is an
isomorphism π₀(el X) ≅ colim_C X because each arrow connecting two objects
in el X corresponds to a condition demanding that these elements are
identified in any cone under X" — the conserved quantity of the component
readout. [SOURCES] master `thm:slice-exp` (verbatim): "Consequently
|exp q| = e^{re q} depends only on the real part". The slice world's
components are COMPUTED (π₀(𝒮₂) ≃ [0,∞] via `S2.componentsEquiv`,
PhiConversion, PROVED); composing the two: the component functor of the
value world, evaluated on octonionic exponential values, is the level
readout and nothing else. -/

/-- **π₀(𝒮₂) ∘ exp = the level** (iff form): two octonionic exponential
values lie in ONE component of the slice world exactly when their
arguments share ONE level. Forward through the computed invariant
(`S2.zigzag_modulus` + `Octonion.norm_exp`); backward through the band
rotation (`S2.zigzag_of_normSq_eq`). The categorical component readout
([SOURCES] Riehl Rem 8.3.5's π₀, computed in-repo) and the analytic level
readout ([SOURCES] `thm:slice-exp` modulus clause) are ONE map on the
exponential's image. WHY-WIRE: "the A-section combines the categorical
homotopy theory with the analysis" — this is the value-side register of
that combination, proved: what π₀ conserves of an exponential value IS
the level the transport conserves ('the level is a conserved quantity
along every zigzag', master `def:base`), one register on each side of Φ.
PROVED. -/
theorem s2_component_exp_eq_iff (p q : Octonion) :
    CategoryTheory.ConnectedComponents.mk
        (S2.of ((Octonion.exp p : Octonion) : OnePoint Octonion))
      = CategoryTheory.ConnectedComponents.mk
        (S2.of ((Octonion.exp q : Octonion) : OnePoint Octonion))
      ↔ Octonion.re p = Octonion.re q := by
  have hnsq : ∀ w : Octonion, Octonion.normSq (Octonion.exp w)
      = Real.exp (2 * Octonion.re w) := by
    intro w
    have h2 : Octonion.normSq (Octonion.exp w)
        = Octonion.norm (Octonion.exp w) ^ 2 := by
      rw [Octonion.norm, Real.sq_sqrt (Octonion.normSq_nonneg _)]
    rw [h2, Octonion.norm_exp, sq, ← Real.exp_add, two_mul]
  constructor
  · intro h
    have hmod := S2.zigzag_modulus (_root_.Quotient.exact' h)
    rw [SliceWorld.modulus_coe, SliceWorld.modulus_coe] at hmod
    have hnormSq : Octonion.normSq (Octonion.exp p) = Octonion.normSq (Octonion.exp q) :=
      OnePoint.coe_eq_coe.mp hmod
    rw [hnsq, hnsq] at hnormSq
    have := Real.exp_eq_exp.mp hnormSq
    linarith
  · intro h
    exact _root_.Quotient.sound' (S2.zigzag_of_normSq_eq (by rw [hnsq, hnsq, h]))

namespace ASection

/-- **The 𝒮₂-component of A's realized value over the half-space IS the
exponential of C2's Euler level** — the section functor's object readout
composed with the computed π₀(𝒮₂), evaluated where C2 speaks: for a domain
point x whose slice coordinate lies right of the wall, the component of
the realized value Φ(x) = A(x) (master `thm:section-functor`: "Φ(q) = A(q)
on objects"; the octonionic register `realize` = sliceEmbed ∘ F ∘
sliceCoord) is the class of the REAL point e^{Re Σ ℓ_p} — the band
representative of the Euler branch's level. Jointly consumed: `c2_euler`
(the value), `c2_locMajorant`+`c1_simple` through `pole_le_upperEdge`
(PairingE2 §A, PROVED — the pole cannot be under the half-space, so the
realization's analyticity guard fires), the octonionic register (`sliceEmbed`, `dir`,
`normSq_sliceEmbed`, with `real_on_real` absorbing the real-axis junk
case), and the categorical computation (`S2.zigzag_of_normSq_eq`).
WHY-WIRE: the round trip of the author's why in one row — analysis (C2's
Euler sum) enters the categorical register (π₀ of the value world) as
exactly ONE datum, the level of the k-ladder of §A; π₀(𝒮₂) forgets the
band and the direction sphere and keeps the level's exponential
(`S2.level_not_invariant` records that it keeps nothing finer). PROVED. -/
theorem s2_value_class_halfSpace (A : ASection) {x : Octonion}
    (hx : A.Ω₀ < (Octonion.sliceCoord x).re) :
    CategoryTheory.ConnectedComponents.mk (S2.of (A.realize (x : OnePoint Octonion)))
      = CategoryTheory.ConnectedComponents.mk (S2.of
          ((Octonion.ofReal
            (Real.exp ((∑' p : A.ι, A.ℓ p (Octonion.sliceCoord x)).re))
            : Octonion) : OnePoint Octonion)) := by
  have hne : Octonion.sliceCoord x ≠ (A.pole : ℂ) := by
    intro h
    have h1 := congrArg Complex.re h
    rw [Complex.ofReal_re] at h1
    have h2 := A.pole_le_upperEdge
    rw [h1] at hx
    linarith
  have hana : AnalyticAt ℂ A.F (Octonion.sliceCoord x) :=
    A.c1_analyticAt (Octonion.sliceCoord x) hne
  have hreal : A.realize (x : OnePoint Octonion)
      = ((Octonion.sliceEmbed (Octonion.dir x) (A.F (Octonion.sliceCoord x))
          : Octonion) : OnePoint Octonion) := by
    rw [ASection.realize_coe, if_pos hana]
  have hFζ : A.F (Octonion.sliceCoord x)
      = Complex.exp (∑' p : A.ι, A.ℓ p (Octonion.sliceCoord x)) :=
    A.c2_euler (Octonion.sliceCoord x) hx
  have hresq : (A.F (Octonion.sliceCoord x)).re ^ 2
        + (A.F (Octonion.sliceCoord x)).im ^ 2
      = Real.exp (2 * (∑' p : A.ι, A.ℓ p (Octonion.sliceCoord x)).re) := by
    rw [hFζ, Complex.exp_re, Complex.exp_im]
    rw [show (Real.exp (∑' p : A.ι, A.ℓ p (Octonion.sliceCoord x)).re
            * Real.cos (∑' p : A.ι, A.ℓ p (Octonion.sliceCoord x)).im) ^ 2
          + (Real.exp (∑' p : A.ι, A.ℓ p (Octonion.sliceCoord x)).re
            * Real.sin (∑' p : A.ι, A.ℓ p (Octonion.sliceCoord x)).im) ^ 2
        = Real.exp (∑' p : A.ι, A.ℓ p (Octonion.sliceCoord x)).re ^ 2 from by
      linear_combination (Real.exp (∑' p : A.ι, A.ℓ p (Octonion.sliceCoord x)).re) ^ 2
        * Real.sin_sq_add_cos_sq (∑' p : A.ι, A.ℓ p (Octonion.sliceCoord x)).im]
    rw [sq, ← Real.exp_add, two_mul]
  have hvalsq : Octonion.normSq
      (Octonion.sliceEmbed (Octonion.dir x) (A.F (Octonion.sliceCoord x)))
      = Real.exp (2 * (∑' p : A.ι, A.ℓ p (Octonion.sliceCoord x)).re) := by
    by_cases him : Octonion.im x = 0
    · have hd : Octonion.dir x = 0 := by rw [Octonion.dir, him, smul_zero]
      have hζim : (Octonion.sliceCoord x).im = 0 := by
        show Octonion.norm (Octonion.im x) = 0
        rw [him, Octonion.norm_zero]
      have hFim : (A.F (Octonion.sliceCoord x)).im = 0 := by
        have hζre : Octonion.sliceCoord x
            = (((Octonion.sliceCoord x).re : ℝ) : ℂ) := by
          apply Complex.ext
          · rw [Complex.ofReal_re]
          · rw [Complex.ofReal_im]
            exact hζim
        rw [hζre]
        exact A.real_on_real ((Octonion.sliceCoord x).re)
      rw [hd, Octonion.sliceEmbed_zero_dir, Octonion.normSq_ofReal, ← hresq, hFim]
      ring
    · rw [Octonion.normSq_sliceEmbed (Octonion.dir_mem_unitImaginarySphere him), hresq]
  rw [hreal]
  refine _root_.Quotient.sound' (S2.zigzag_of_normSq_eq ?_)
  rw [hvalsq, Octonion.normSq_ofReal, sq, ← Real.exp_add, two_mul]

end ASection
