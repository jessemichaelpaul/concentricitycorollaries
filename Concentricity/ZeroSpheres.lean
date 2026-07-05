/-
Concentricity/ZeroSpheres.lean

Island B6 (PLAN_islands_part1_part2_2026-07-05.md): the zero 6-spheres
(master `thm:zero-spheres`) — clauses (i) the sphere as a single G₂-orbit,
(ii) every point a zero + conjugate zeros give the same sphere, (iii)
distinct parameters give disjoint spheres, and (iv) — first the stepping
stone (infinitude of the parameter set), then, with clusters 2/4 landed
(the conjugation pin, ZetaConj.lean; the zero location,
ZetaStrip/ZetaRealZeros.lean), the FULL sphere-count
(`zeroSpheres_infinite`): infinitely many zero 6-spheres, as sets.

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file targets ZERO
sorries.
-/
import Concentricity.ZetaOctonion
import Concentricity.ZetaInfinitude
import Concentricity.ZetaRealZeros

noncomputable section

open scoped OnePoint
open Octonion

/-- **The zero sphere** S_ρ (master `thm:zero-spheres`, verbatim): "For a
nontrivial zero ρ = σ + iγ of ζ_ℂ* (so γ > 0) set
S_ρ = {σ + γv : v ∈ S⁶} = σ + γ·S⁶ ⊂ 𝕆." Defined for any parameters; the
zero-bearing hypotheses enter the clauses. -/
def zeroSphere (σ γ : ℝ) : Set Octonion :=
  (fun v => sliceEmbed v ⟨σ, γ⟩) '' unitImaginarySphere

/-- G₂ preserves the unit imaginary sphere (the isometry block:
`G2.smul_re`, `G2.smul_normSq`, both PROVED). PROVED helper. -/
theorem _root_.G2.smul_mem_unitImaginarySphere (g : G2) {v : Octonion}
    (hv : v ∈ unitImaginarySphere) : g • v ∈ unitImaginarySphere :=
  ⟨by rw [G2.smul_re]; exact hv.1, by rw [G2.smul_normSq]; exact hv.2⟩

/-- Membership characterization: for γ > 0 the sphere is exactly the locus
`re = σ, ‖im‖ = γ` — the hyperplane-and-radius reading (master (i): "the
round sphere of radius γ centred at the real point σ"). PROVED. -/
theorem mem_zeroSphere_iff {σ γ : ℝ} (hγ : 0 < γ) {x : Octonion} :
    x ∈ zeroSphere σ γ ↔ re x = σ ∧ Octonion.norm (im x) = γ := by
  constructor
  · rintro ⟨v, hv, rfl⟩
    refine ⟨re_sliceEmbed hv _, ?_⟩
    rw [im_sliceEmbed hv]
    show Octonion.norm ((⟨σ, γ⟩ : ℂ).im • v) = γ
    rw [norm_smul_unit hv]
    exact abs_of_pos hγ
  · rintro ⟨hre, him⟩
    have hx : im x ≠ 0 := by
      intro h0
      rw [h0] at him
      have : Octonion.norm (0 : Octonion) = 0 := by
        rw [Octonion.norm, normSq_zero, Real.sqrt_zero]
      rw [this] at him
      exact absurd him.symm (ne_of_gt hγ)
    refine ⟨dir x, dir_mem_unitImaginarySphere hx, ?_⟩
    have hcoord : (⟨σ, γ⟩ : ℂ) = sliceCoord x := by
      rw [sliceCoord, ← hre, ← him]
    change sliceEmbed (dir x) ⟨σ, γ⟩ = x
    rw [hcoord, sliceEmbed_dir_sliceCoord]

/-- **(i) — the sphere is a single G₂-orbit** (master, verbatim):
"S_ρ is a 6-sphere … equivalently the G₂-orbit of any one of its points
σ + γv₀ (Theorem thm:G2-equiv; G₂ acts transitively on S⁶ with stabiliser
SU(3), Theorem thm:G2-S6, Baez)." Orbit realization over the PROVED
`G2.exists_smul_eq_of_mem_unitImaginarySphere` + `G2.smul_sliceEmbed`;
"no embedding or diffeomorphism is invoked" (master). -/
theorem zeroSphere_eq_orbit {σ γ : ℝ} {v₀ : Octonion}
    (hv₀ : v₀ ∈ unitImaginarySphere) :
    zeroSphere σ γ = Set.range fun g : G2 => g • sliceEmbed v₀ ⟨σ, γ⟩ := by
  ext x
  constructor
  · rintro ⟨v, hv, rfl⟩
    obtain ⟨g, hg⟩ := G2.exists_smul_eq_of_mem_unitImaginarySphere hv₀ hv
    refine ⟨g, ?_⟩
    change g • sliceEmbed v₀ ⟨σ, γ⟩ = sliceEmbed v ⟨σ, γ⟩
    rw [G2.smul_sliceEmbed, hg]
  · rintro ⟨g, rfl⟩
    exact ⟨g • v₀, G2.smul_mem_unitImaginarySphere g hv₀,
      (G2.smul_sliceEmbed g v₀ _).symm⟩

/-- **(ii), first half — every point of S_ρ is a zero of ζ_𝕆** (master,
verbatim): "For any v ∈ S⁶, ζ_𝕆(σ + γv) = φ_v(ζ_ℂ*(ρ)) = φ_v(0) = 0 by the
Zero Equivalence Theorem." Through the PROVED bridge `zetaO_zero_iff`. -/
theorem zeroSphere_zeros {σ γ : ℝ} (hγ : 0 < γ)
    (hz : riemannZeta ⟨σ, γ⟩ = 0) :
    ∀ x ∈ zeroSphere σ γ, zetaO (x : OnePoint Octonion)
      = ((0 : Octonion) : OnePoint Octonion) := by
  rintro x ⟨v, hv, rfl⟩
  exact (zetaO_zero_iff hv hγ).mpr hz

/-- (ii) converse direction (feeds (iii)'s "⊆"): a non-real zero of ζ_𝕆
lies on the sphere of its slice coordinate, and that coordinate is a zero
of ζ. PROVED through the bridge. -/
theorem mem_zeroSphere_of_zetaO_zero {x : Octonion} (hx : im x ≠ 0)
    (hz : zetaO (x : OnePoint Octonion) = ((0 : Octonion) : OnePoint Octonion)) :
    x ∈ zeroSphere (re x) (Octonion.norm (im x))
      ∧ riemannZeta (sliceCoord x) = 0 := by
  have hγ : 0 < Octonion.norm (im x) := norm_pos_of_ne_zero hx
  have hmem : x ∈ zeroSphere (re x) (Octonion.norm (im x)) :=
    (mem_zeroSphere_iff hγ).mpr ⟨rfl, rfl⟩
  refine ⟨hmem, ?_⟩
  have hxdisp : sliceEmbed (dir x) (sliceCoord x) = x := sliceEmbed_dir_sliceCoord x
  have hcoord_im : 0 < (sliceCoord x).im := hγ
  rw [← hxdisp] at hz
  exact (zetaO_zero_iff (dir_mem_unitImaginarySphere hx) hcoord_im).mp hz

/-- The unit imaginary sphere is symmetric under negation (`re_smul`,
`normSq_smul` at −1). PROVED helper. -/
theorem _root_.Octonion.neg_mem_unitImaginarySphere {v : Octonion}
    (hv : v ∈ unitImaginarySphere) : -v ∈ unitImaginarySphere := by
  constructor
  · rw [← neg_one_smul ℝ v, re_smul, hv.1, mul_zero]
  · rw [← neg_one_smul ℝ v, normSq_smul, hv.2]
    norm_num

/-- **(ii), second half — conjugate zeros give the same sphere** (master:
"S_ρ̄ = {σ + γ(−v) : v ∈ S⁶} = S_ρ, since v ↦ −v is a bijection of S⁶").
Rendered as: the sphere of the conjugated coordinate ⟨σ, −γ⟩ is the sphere
of ⟨σ, γ⟩. PROVED. -/
theorem zeroSphere_neg (σ γ : ℝ) : zeroSphere σ (-γ) = zeroSphere σ γ := by
  have key : ∀ (v : Octonion), sliceEmbed v ⟨σ, -γ⟩ = sliceEmbed (-v) ⟨σ, γ⟩ := by
    intro v
    change ofReal σ + (⟨σ, -γ⟩ : ℂ).im • v = ofReal σ + (⟨σ, γ⟩ : ℂ).im • (-v)
    change ofReal σ + (-γ) • v = ofReal σ + γ • (-v)
    rw [smul_neg, neg_smul]
  ext x
  constructor
  · rintro ⟨v, hv, rfl⟩
    exact ⟨-v, Octonion.neg_mem_unitImaginarySphere hv, (key v).symm⟩
  · rintro ⟨v, hv, rfl⟩
    refine ⟨-v, Octonion.neg_mem_unitImaginarySphere hv, ?_⟩
    change sliceEmbed (-v) ⟨σ, -γ⟩ = sliceEmbed v ⟨σ, γ⟩
    rw [key (-v), neg_neg]

/-- **(iii) — distinct parameters give disjoint spheres** (master:
"Disjointness: if σ + γv = σ' + γ'w, uniqueness of the real/imaginary parts
gives σ = σ' and γv = γ'w, whence γ = γ' …; so two spheres coincide or are
disjoint" — equal parameters give literally the same set, so the rendered
clause is the disjointness half). PROVED via the membership
characterization. -/
theorem zeroSphere_disjoint {σ₁ γ₁ σ₂ γ₂ : ℝ} (hγ₁ : 0 < γ₁) (hγ₂ : 0 < γ₂)
    (h : (σ₁, γ₁) ≠ (σ₂, γ₂)) :
    Disjoint (zeroSphere σ₁ γ₁) (zeroSphere σ₂ γ₂) := by
  rw [Set.disjoint_left]
  intro x hx₁ hx₂
  obtain ⟨hre₁, him₁⟩ := (mem_zeroSphere_iff hγ₁).mp hx₁
  obtain ⟨hre₂, him₂⟩ := (mem_zeroSphere_iff hγ₂).mp hx₂
  exact h (Prod.ext_iff.mpr ⟨hre₁.symm.trans hre₂, him₁.symm.trans him₂⟩)

/-- **(iv), the stepping stone** — the parameter set (σ, |γ|) of the
nontrivial zeros is infinite: the PROVED infinitude
`riemannZeta_nontrivialZeros_infinite` pushed through the ≤2-to-1 parameter
map s ↦ (s.re, |s.im|) (the fibre over (σ, γ) is {σ + iγ, σ − iγ}).

Master (iv) ("there are infinitely many such spheres") closes from this
plus the zero-location pins (the R5 sweep, clusters 2/4: conjugate symmetry
to fold onto the upper half; real-zero exclusion so every parameter has
γ > 0) — recorded here, not sorried; the sphere-count form lands when the
pins do. -/
theorem zeroParams_infinite :
    ((fun s : ℂ => (s.re, |s.im|)) ''
      {s : ℂ | riemannZeta s = 0 ∧ (¬∃ n : ℕ, s = -2 * (n + 1)) ∧ s ≠ 1}).Infinite := by
  intro hfin
  apply riemannZeta_nontrivialZeros_infinite
  have hcover : {s : ℂ | riemannZeta s = 0 ∧ (¬∃ n : ℕ, s = -2 * (n + 1)) ∧ s ≠ 1}
      ⊆ ⋃ p ∈ (fun s : ℂ => (s.re, |s.im|)) ''
          {s : ℂ | riemannZeta s = 0 ∧ (¬∃ n : ℕ, s = -2 * (n + 1)) ∧ s ≠ 1},
        ({⟨p.1, p.2⟩, ⟨p.1, -p.2⟩} : Set ℂ) := by
    intro s hs
    refine Set.mem_biUnion (Set.mem_image_of_mem _ hs) ?_
    rcases le_or_gt 0 s.im with h | h
    · rw [Set.mem_insert_iff]
      exact Or.inl (Complex.ext rfl (abs_of_nonneg h).symm)
    · rw [Set.mem_insert_iff, Set.mem_singleton_iff]
      exact Or.inr (Complex.ext rfl (by rw [abs_of_neg h, neg_neg]))
  exact (hfin.biUnion fun p _ => (Set.finite_singleton _).insert _).subset hcover

/-- The unit imaginary sphere is inhabited — the Cayley–Dickson unit
(0, 1) ∈ ℍ × ℍ: real part 0, norm-square 0 + 1. PROVED helper. -/
theorem _root_.Octonion.unitImaginarySphere_nonempty :
    unitImaginarySphere.Nonempty := by
  refine ⟨((0 : Quaternion ℝ), (1 : Quaternion ℝ)), ?_, ?_⟩
  · rfl
  · simp [Octonion.normSq]

/-- Every zero sphere is nonempty. PROVED helper. -/
theorem zeroSphere_nonempty (σ γ : ℝ) : (zeroSphere σ γ).Nonempty := by
  obtain ⟨v, hv⟩ := Octonion.unitImaginarySphere_nonempty
  exact ⟨sliceEmbed v ⟨σ, γ⟩, v, hv, rfl⟩

/-- **(iv) COMPLETE — "there are infinitely many such spheres"** (master
`thm:zero-spheres`(iv), verbatim; the full sphere-count form, closing the
stepping stone): the set of zero 6-spheres is infinite AS A SET OF SETS.
Route: cluster 4 (`nontrivialZero_im_ne_zero`) makes every nontrivial-zero
parameter upper-half (γ = |Im ρ| > 0), the conjugation pin folds the lower
half up, the parameter set is infinite (`zeroParams_infinite`), and
distinct parameters give distinct spheres (disjoint by
`zeroSphere_disjoint`, nonempty by `zeroSphere_nonempty`). PROVED. -/
theorem zeroSpheres_infinite :
    {S : Set Octonion | ∃ σ γ : ℝ, 0 < γ ∧ riemannZeta ⟨σ, γ⟩ = 0
      ∧ S = zeroSphere σ γ}.Infinite := by
  set P : Set (ℝ × ℝ) := (fun s : ℂ => (s.re, |s.im|)) ''
    {s : ℂ | riemannZeta s = 0 ∧ (¬∃ n : ℕ, s = -2 * (n + 1)) ∧ s ≠ 1}
    with hP_def
  have hPinf : P.Infinite := zeroParams_infinite
  have hPpos : ∀ p ∈ P, 0 < p.2 := by
    rintro p ⟨s, hs, rfl⟩
    exact abs_pos.mpr (nontrivialZero_im_ne_zero hs.1 hs.2.1 hs.2.2)
  have hPzero : ∀ p ∈ P, riemannZeta ⟨p.1, p.2⟩ = 0 := by
    rintro p ⟨s, hs, rfl⟩
    rcases abs_cases s.im with ⟨heq, _⟩ | ⟨heq, _⟩
    · have hs' : (⟨s.re, |s.im|⟩ : ℂ) = s := Complex.ext rfl heq
      rw [hs']
      exact hs.1
    · have hs' : (⟨s.re, |s.im|⟩ : ℂ) = (starRingEnd ℂ) s :=
        Complex.ext (by rw [Complex.conj_re]) (by rw [Complex.conj_im]; exact heq)
      rw [hs', riemannZeta_conj, hs.1, map_zero]
  have hinj : Set.InjOn (fun p : ℝ × ℝ => zeroSphere p.1 p.2) P := by
    intro p hp q hq heq
    by_contra hne
    have hne' : (p.1, p.2) ≠ (q.1, q.2) := by
      rw [Prod.mk.eta, Prod.mk.eta]
      exact hne
    have hdisj := zeroSphere_disjoint (hPpos p hp) (hPpos q hq) hne'
    have heq' : zeroSphere p.1 p.2 = zeroSphere q.1 q.2 := heq
    rw [heq'] at hdisj
    obtain ⟨x, hx⟩ := zeroSphere_nonempty q.1 q.2
    exact Set.disjoint_left.mp hdisj hx hx
  refine Set.Infinite.mono ?_ (hPinf.image hinj)
  rintro S ⟨p, hp, rfl⟩
  exact ⟨p.1, p.2, hPpos p hp, hPzero p hp, rfl⟩
