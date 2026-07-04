/-
Concentricity/Toolkit.lean

The cone completion (PHASE4_PLAN §"Cone completion"; Brief 5): the master
nodes consumed by the assembly of `thm:concentricity` — the slice exponential
(`thm:slice-exp`), the degenerate fibre (`lem:exp-degenerate`), the identity
theorem in stem form (`thm:identity`), and the two GPVwind winding nodes
(`thm:winding-lift`, `prop:winding-signature`).

STATEMENTS land here sorried (the waived balloon — the sorry-count increase
is waived for exactly these rows and no others). Each docstring quotes its
master node verbatim plus its SOURCES pointers (R1/R2/R10).

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.Slice
import Mathlib.Analysis.SpecialFunctions.Complex.Log
import Mathlib.Topology.UnitInterval
import Mathlib.Topology.ContinuousMap.Basic

noncomputable section

open scoped Topology

namespace Octonion

/-- **The slice exponential** (master `thm:slice-exp`, verbatim): "The
exponential exp : 𝕆 → 𝕆 ∖ {0}, exp(q) = ∑_{k≥0} q^k/k! (powers well defined
by Corollary cor:powers), is a slice-regular, slice-preserving entire
function (Definition def:slice-preserving), given on each slice by
exp(x+Iy) = e^x(cos y + I sin y), x, y ∈ ℝ, I ∈ S⁶. Consequently
|exp q| = e^{re q} depends only on the real part, and exp is nowhere zero."
(Cites: [§3]{GPVwind}; [Prop. 5.1]{VS}; [Rem. 2.23]{AdF}.)

Rendering: DEFINED through the slice display — the value at q is the slice
embedding of the classical complex exponential of the slice coordinate,
exp(q) := φ_{I(q)}(exp_ℂ(σ + iγ)). The master's power-series clause is the
characterization, queued with the proofs of the display pins below. At real
q the direction junk (dir q = 0, GPVwind Rem 2.1 — SOURCES/GPVwind.md: "the
function 𝓘 cannot be extended as a continuous function to any single point
of the real axis ℝ of 𝕂") is never consumed: the slice coordinate is then
real, Complex.exp of a real is real, and the zero-direction embedding
collapses to `ofReal` — the realize-style junk-robust convention of
Concentricity/Slice.lean. -/
def exp (q : Octonion) : Octonion :=
  sliceEmbed (dir q) (Complex.exp (sliceCoord q))

/-- The display pin of master `thm:slice-exp` ("given on each slice by
exp(x+Iy) = e^x(cos y + I sin y)"), upper-half convention: on the
upper-half-plane slice coordinate (0 ≤ ζ.im — including the real axis, where
the junk-robust convention makes both sides real, see `Octonion.exp`), the
slice exponential is the slice embedding of the classical complex
exponential. Queued (R8): `dir_sliceEmbed_of_pos`/`of_im_zero` +
`sliceCoord_sliceEmbed` of Concentricity/Slice.lean. -/
theorem exp_sliceEmbed {v : Octonion} (hv : v ∈ unitImaginarySphere) {ζ : ℂ}
    (hζ : 0 ≤ ζ.im) : exp (sliceEmbed v ζ) = sliceEmbed v (Complex.exp ζ) :=
  sorry

/-- The display pin of master `thm:slice-exp`, lower-half clause (the
conjugate case, needed for faithfulness of the master's "x, y ∈ ℝ": for
ζ.im < 0 the direction reads −v and the coordinate conjugates,
`dir_sliceEmbed_of_neg`, and φ_{−v}(w̄) = φ_v(w) (`sliceEmbed_neg_conj`)
together with exp_ℂ ∘ conj = conj ∘ exp_ℂ symmetrize). Queued (R8). -/
theorem exp_sliceEmbed_of_im_neg {v : Octonion} (hv : v ∈ unitImaginarySphere)
    {ζ : ℂ} (hζ : ζ.im < 0) :
    exp (sliceEmbed v ζ) = sliceEmbed v (Complex.exp ζ) :=
  sorry

/-- master `thm:slice-exp`, modulus clause (verbatim): "Consequently
|exp q| = e^{re q} depends only on the real part". Queued (R8): pin
`Complex.norm_exp` (Mathlib/Analysis/SpecialFunctions/Complex/Log.lean, in
use at :55) through the slice embedding. -/
theorem norm_exp (q : Octonion) : norm (exp q) = Real.exp (re q) := by
  by_cases him : im q = 0
  · have hdir : dir q = 0 := by rw [dir, him, smul_zero]
    have hcoordim : (sliceCoord q).im = 0 := by
      show norm (im q) = 0
      rw [him, norm_zero]
    rw [exp, hdir, sliceEmbed_zero_dir, norm_ofReal, Complex.exp_re, hcoordim,
      Real.cos_zero, _root_.mul_one]
    show |Real.exp (re q)| = Real.exp (re q)
    exact abs_of_pos (Real.exp_pos _)
  · rw [exp, norm, normSq_sliceEmbed (dir_mem_unitImaginarySphere him),
      Complex.exp_re, Complex.exp_im,
      show (Real.exp (sliceCoord q).re * Real.cos (sliceCoord q).im) ^ 2
            + (Real.exp (sliceCoord q).re * Real.sin (sliceCoord q).im) ^ 2
          = Real.exp (sliceCoord q).re ^ 2 from by
        linear_combination (Real.exp (sliceCoord q).re) ^ 2
          * Real.sin_sq_add_cos_sq (sliceCoord q).im,
      Real.sqrt_sq (Real.exp_nonneg _)]
    rfl

/-- master `thm:slice-exp`, nowhere-zero clause (verbatim): "and exp is
nowhere zero." Queued (R8): from `norm_exp` and `Real.exp_pos`. -/
theorem exp_ne_zero (q : Octonion) : exp q ≠ 0 := by
  intro h
  have hnorm := norm_exp q
  rw [h, norm_zero] at hnorm
  exact ne_of_lt (Real.exp_pos (re q)) hnorm

/-- **The degenerate fibre** (master `lem:exp-degenerate`).

SOURCED clauses (verbatim). VS Rem 5.2(a) (SOURCES/VS.md, printed p. 988):
"(a) If π : 𝕂 × Im(𝕂) → 𝕂 denotes the projection on the first factor, then
by definition the following equality holds (π ∘ E)(q) = exp(q) for all
q ∈ 𝕂." — the commuting triangle. VS Rem 5.2(b) (verbatim, printed p. 988):
"(b) Unlike what happens in the complex setting, the map π : 𝓔_𝕂^+ → 𝕂 is
not a covering. It is not an open map as well, due to the fact that
exp : 𝕂 → 𝕂 is not an open map (it has a non–empty degenerate set consisting
of spheres)." GPVwind Rem 2.1 (SOURCES/GPVwind.md): "It is worthwhile
noticing that the function 𝓘 cannot be extended as a continuous function to
any single point of the real axis ℝ of 𝕂."

PROVED from the slice form (master's derivation sentence, verbatim): "For
r > 0, exp⁻¹(−r) = { log r + I(2k+1)π : I ∈ S⁶, k ∈ ℤ }: by Theorem
thm:slice-exp, exp(x+Iy) = e^x cos y + Ie^x sin y = −r forces e^x sin y = 0,
hence y ∈ πℤ; negativity of the value forces y = (2k+1)π and x = log r; the
direction I is unconstrained. The fibre is thus indexed by the single real
level log r = log|−r| and, within it, by the odd winding indices 2k+1
carried as band data (the winding lift, Theorem thm:winding-lift;
[Cor. 5.21]{GPVwind}). The fibre formula itself appears, stated without
proof as Preface motivation, in [VS] (p. 972); the slice-form derivation
above is the load-bearing statement." Queued (R8): pin
`Complex.exp_eq_one_iff` (Mathlib/Analysis/SpecialFunctions/Complex/Log
.lean:141) and the `Complex.log` cluster. -/
theorem exp_fibre_neg_real {r : ℝ} (hr : 0 < r) :
    {q : Octonion | exp q = ofReal (-r)}
      = {q : Octonion | ∃ v ∈ unitImaginarySphere, ∃ k : ℤ,
          q = sliceEmbed v ⟨Real.log r, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩} :=
  sorry

end Octonion

/-- **The identity theorem, stem form** (master `thm:identity`, verbatim;
[Cor. 5.1.9]{CSS12}): "Let f be slice regular on an axially symmetric slice
domain Ω. If f vanishes on a subset of a single slice Ω ∩ ℂ_{v₀} with an
accumulation point in Ω ∩ ℂ_{v₀}, then f ≡ 0 on all of Ω."

Stem rendering (the slice-preserving class is carried by its one
holomorphic stem, `def:section-map`): two entire stems agreeing at points
accumulating to z₀ — agreement frequently in the punctured neighbourhood —
agree everywhere. Queued (R8): pin
`AnalyticOnNhd.eqOn_of_preconnected_of_frequently_eq` /
`AnalyticOnNhd.eq_of_frequently_eq`
(Mathlib/Analysis/Analytic/IsolatedZeros.lean:238/:261; the eventuallyEq
forms and cross-references at Mathlib/Analysis/Analytic/Uniqueness
.lean:222/:233), `isPreconnected_univ`. -/
theorem stem_identity {F G : ℂ → ℂ} (hF : AnalyticOnNhd ℂ F Set.univ)
    (hG : AnalyticOnNhd ℂ G Set.univ) {z₀ : ℂ}
    (hfg : ∃ᶠ z in 𝓝[≠] z₀, F z = G z) : Set.EqOn F G Set.univ :=
  hF.eqOn_of_preconnected_of_frequently_eq hG isPreconnected_univ (Set.mem_univ z₀) hfg

/-- **The winding lift, slice form** (master `thm:winding-lift`, verbatim;
[Def. 3.4, Def. 4.1, Prop. 4.2, Def. 5.11]{GPVwind}): "Let
γ : [a,b] → 𝕆 ∖ {0} be a path (on each slice ℂ_v this is the classical
complex continuation). A continuation of the hypercomplex logarithm along γ
is a path γ̃ : [a,b] → 𝕆 with exp ∘ γ̃ = γ, and a lift of γ to the logarithm
manifold E⁺_𝕆 (Theorem thm:log-manifold) is a path Γ : [a,b] → E⁺_𝕆 with
pr₁ ∘ Γ = γ. … The two data are equivalent: a lift Γ exists if and only if a
continuation γ̃ exists, and they correspond by γ̃ = L ∘ Γ,
Γ = (exp ∘ γ̃, im γ̃), where L is the E⁺_𝕆-logarithm of Theorem
thm:log-manifold ([Prop. 4.2]{GPVwind}). For a loop γ : S¹ → 𝕆 ∖ {0} the
lift is taken on the universal cover exp : iℝ → S¹, as a continuous
Γ : iℝ → E⁺_𝕆 with pr₁ ∘ Γ = γ ∘ exp ([Def. 5.11]{GPVwind})."

Loop clause per GPVwind Def 5.11 (SOURCES/GPVwind.md, verbatim): "Let
γ : S¹ → 𝕂 ∖ {0} be a continuous loop. Then a continuous function
Γ : iℝ → 𝓔⁺ is a lift of γ if the following diagram commutes:" — the
square's commutativity is pr₁ ∘ Γ = γ ∘ exp (the explicit composite for
path lifts, pr₁ ∘ Γ = γ, is printed in Def 4.1, per SOURCES/GPVwind.md).

Slice form: on a slice this is the classical complex continuation of the
logarithm along a nonvanishing path. Queued (R8): floor
`Complex.isCoveringMap_exp` (Mathlib/Analysis/Complex/CoveringMap.lean:40)
+ path lifting. -/
theorem exists_log_continuation (γ : C(unitInterval, ℂ))
    (hγ : ∀ t, γ t ≠ 0) :
    ∃ γ' : C(unitInterval, ℂ), ∀ t, Complex.exp (γ' t) = γ t :=
  sorry

/-- master `prop:winding-signature`(i) (verbatim; header cites
[Def. 4.20, Cor. 5.21, Cor. 5.22]{GPVwind}): "Uniqueness (tameness). γ is
tame when it admits a unique companion imaginary-unit field; its lift is
then unique ([Def. 4.20]{GPVwind})."

GPVwind Def 4.7 (SOURCES/GPVwind.md, verbatim — the PATH version of the
tameness package; Def 4.20 is the map version, per SOURCES FLAGS item 2):
"Let [a,b] ⊂ ℝ and let γ : [a,b] → 𝕂 ∖ {0} be a path. A path
𝔍^γ : [a,b] → 𝕊/{±Id} such that γ(t) ∈ ℂ_{𝔍^γ(t)} for every t ∈ [a,b] is
called a companion of the path γ. … If the path γ has a unique companion
𝔍^γ, then both γ and the pair (γ, 𝔍^γ) are called a tame path."

Stem form: on a single slice the companion is the slice itself (the
master's parenthesis in `thm:winding-lift`: "on each slice ℂ_v this is the
classical complex continuation"), so tameness holds by fiat and the lift is
unique once its initial value is fixed — uniqueness of lifts over the
covering floor `Complex.isCoveringMap_exp`
(Mathlib/Analysis/Complex/CoveringMap.lean:40). Queued (R8). -/
theorem winding_lift_unique (γ : C(unitInterval, ℂ)) (hγ : ∀ t, γ t ≠ 0)
    (γ₁ γ₂ : C(unitInterval, ℂ)) (h₁ : ∀ t, Complex.exp (γ₁ t) = γ t)
    (h₂ : ∀ t, Complex.exp (γ₂ t) = γ t) (h0 : γ₁ 0 = γ₂ 0) : γ₁ = γ₂ :=
  sorry

/-- master `prop:winding-signature`(ii)/(iii), the stateable frame over the
`exists_log_continuation` vocabulary — the loop defect. Master (ii)
(verbatim): "Existence and closure. A lift of a loop γ exists if and only
if the signature satisfies σ(γ|_{[ξ_l,ξ_{l+1}]}) ∈ {0,−1} on each
obstruction interval; and if it exists, the lift is itself a loop
([Cor. 5.13]{GPVwind}; pinned against the arXiv text — the earlier citation
to Cor. 5.22 is superseded)." Master (iii) (verbatim): "Winding number. For
an untwisted tame loop with even circular signature σᶜ, the winding number
is ω = |σᶜ|/2 ([Cor. 5.21]{GPVwind})."

GPVwind Cor 5.21 (SOURCES/GPVwind.md, verbatim, printed hypothesis
included per FLAGS item 3): "Let γ be a loop and σᶜ(γ) even. Then
ω(γ, 𝔍) = |σᶜ(γ, 𝔍)|/2." — σᶜ is the paper's "circular signature"
(Def 5.19; FLAGS item 4: "coherent" was a stray).

What is rendered here (the frame both clauses share): along a LOOP, any
continuation of the logarithm has endpoint defect an integer multiple of
2πi — the integer is the winding number ω whose value Cor 5.21 computes,
and whose odd heights (2k+1)π over the negative reals are exactly the band
data of `Octonion.exp_fibre_neg_real` (`lem:exp-degenerate`). GAP (recorded
per Brief 5 row (v); SOURCES untouched): the verbatim σ/σᶜ apparatus —
GPVwind Def 5.2 (one-sided limits of Y(t)/|Y(t)|, flip/bounce), Def 5.7
(σ as the alternating flip sum), Def 5.15 (obstruction intervals),
Def 5.19 (circular signature) — is definition-layer buildout over the
direction field, not statement transcription; without it the closure
clause of Cor 5.13 cannot be rendered soundly in this slice vocabulary
(R8: `sorry` marks UNFORMALIZED, never UNSOUND), so its consumption stays
inside the assembly transcription seam. Queued (R8): pin
`Complex.exp_eq_one_iff` (Mathlib/Analysis/SpecialFunctions/Complex/Log
.lean:141). -/
theorem winding_loop_defect (γ : C(unitInterval, ℂ)) (hloop : γ 0 = γ 1)
    (γ' : C(unitInterval, ℂ)) (hlift : ∀ t, Complex.exp (γ' t) = γ t) :
    ∃ k : ℤ, γ' 1 - γ' 0 = (k : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) := by
  have h : Complex.exp (γ' 1) = Complex.exp (γ' 0) := by
    rw [hlift 1, hlift 0, hloop]
  obtain ⟨n, hn⟩ := Complex.exp_eq_exp_iff_exists_int.1 h
  exact ⟨n, by rw [hn]; ring⟩
