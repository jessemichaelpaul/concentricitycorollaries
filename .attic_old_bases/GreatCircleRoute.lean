/-
Concentricity/GreatCircleRoute.lean

R6 RECORD — P-ROUTE 4, the author's one-great-circle argument (dialogue
2026-07-05: "on complex, quaternionic, and crucially octonionic spheres
there is only ONE great circle — that's where 𝓑 lives and where the
A-section lives; two ℂ-residue zeros with different centers both lie on
the hyperplane through S¹; G₂ fixes ℝ ∪ {∞} in 𝕆* and everything else is
imaginary"), rendered per the Juncture Protocol and the P-route 3
precedent (OneHyperplaneRoute.lean): the GEOMETRIC clauses are PROVED
below — they are real content, the archived great-circle play's
`lem:great-circle` formal at last — and the placement clause is fed every
proved row, with the resisting goal recorded in-file.

RECEIPT (clause (d)): with (a) the one-component fact, (b) the unique
great circle and its G₂-fixity, and (c) the sphere/hyperplane geometry
ALL FED AS PROVED ROWS, the remaining goal is `z.re = w.re` with no
hypothesis mentioning the real parts: (a)–(c) hold verbatim for EVERY
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
— Pin 2 `transport_not_level_separating` is the proved form of the
obstruction: the transport object carries no level-separating invariant,
and the G₂-fixed circle is fixed at EVERY level, so it separates none).
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
one stem) — the Brick 2 address. Lake's verdict, recorded.

UNIMPORTED ARTIFACT until the author rules (folding `lem:great-circle`
into the master is a separate decision from the route's outcome). The
`sorry` below is the ROUTE RECEIPT, not a queue item (R8; the
OneHyperplaneRoute precedent) — it does not touch the imported ledger.
-/
import Concentricity.ZeroSpheres
import Concentricity.Corollaries
import Concentricity.TransportObject

noncomputable section

open Octonion

/-! ## The great circle: PROVED geometry (the play's `lem:great-circle`) -/

/-- The compactified real axis ℝ ∪ {N} — the one great circle
(`def:carrier`). -/
def greatCircle : Set (OnePoint Octonion) :=
  insert OnePoint.infty ((↑) '' Set.range ofReal)

/-- The great circle lies on EVERY slice sphere (every slice shares ℝ and
the single ∞). PROVED. -/
theorem greatCircle_subset_sliceSphere (v : Octonion) :
    greatCircle ⊆ sliceSphere v := by
  rintro x hx
  rcases Set.mem_insert_iff.mp hx with rfl | ⟨y, ⟨r, rfl⟩, rfl⟩
  · exact Set.mem_insert _ _
  · exact Set.mem_insert_of_mem _
      ⟨ofReal r, ⟨(r : ℂ), sliceEmbed_ofReal v r⟩, rfl⟩

/-- Real-scalar rigidity on unit imaginaries: a•w = b•v with v, w units
and b ≠ 0 forces v = ±w. PROVED helper. -/
theorem unit_smul_eq_unit_smul {v w : Octonion} (hv : v ∈ unitImaginarySphere)
    (hw : w ∈ unitImaginarySphere) {a b : ℝ} (hb : b ≠ 0)
    (h : a • w = b • v) : v = w ∨ v = -w := by
  have hv' : v = (b⁻¹ * a) • w := by
    rw [mul_smul, h, smul_smul, inv_mul_cancel₀ hb, one_smul]
  have hnorm : (b⁻¹ * a) ^ 2 = 1 := by
    have h1 := congrArg normSq hv'
    rw [Octonion.normSq_smul, hw.2, hv.2] at h1
    linear_combination -h1
  have hcase : b⁻¹ * a = 1 ∨ b⁻¹ * a = -1 := by
    have h2 : (b⁻¹ * a - 1) * (b⁻¹ * a + 1) = 0 := by nlinarith
    rcases mul_eq_zero.mp h2 with h3 | h3
    · left; linarith
    · right; linarith
  rcases hcase with h3 | h3
  · left
    rw [hv', h3, one_smul]
  · right
    rw [hv', h3, neg_smul, one_smul]

/-- **The shared circle** (the play's `lem:great-circle`, intersection
clause): slice spheres of independent directions (v ≠ ±w) meet EXACTLY in
the great circle — "the unique circle through N common to every slice
sphere". PROVED. -/
theorem sliceSphere_inter {v w : Octonion} (hv : v ∈ unitImaginarySphere)
    (hw : w ∈ unitImaginarySphere) (hvw : v ≠ w) (hvw' : v ≠ -w) :
    sliceSphere v ∩ sliceSphere w = greatCircle := by
  ext x
  constructor
  · rintro ⟨hxv, hxw⟩
    rcases Set.mem_insert_iff.mp hxv with rfl | ⟨y, ⟨ζ, rfl⟩, rfl⟩
    · exact Set.mem_insert _ _
    · rcases Set.mem_insert_iff.mp hxw with hInf | ⟨y', ⟨ζ', hy'⟩, hcoe⟩
      · exact absurd hInf (OnePoint.coe_ne_infty _)
      · have hyy : sliceEmbed w ζ' = sliceEmbed v ζ := by
          rw [hy']
          exact OnePoint.coe_injective hcoe
        have him := congrArg im hyy
        rw [im_sliceEmbed hw, im_sliceEmbed hv] at him
        by_cases hζim : ζ.im = 0
        · obtain ⟨σ, rfl⟩ : ∃ σ : ℝ, ((σ : ℝ) : ℂ) = ζ :=
            ⟨ζ.re, Complex.ext (Complex.ofReal_re _)
              (by rw [Complex.ofReal_im]; exact hζim.symm)⟩
          refine Set.mem_insert_of_mem _ ⟨ofReal σ, ⟨σ, rfl⟩, ?_⟩
          rw [sliceEmbed_ofReal]
        · exfalso
          rcases unit_smul_eq_unit_smul hv hw hζim him with h | h
          · exact hvw h
          · exact hvw' h
  · intro hx
    exact ⟨greatCircle_subset_sliceSphere v hx,
      greatCircle_subset_sliceSphere w hx⟩

/-- **The fixed locus** (the play's fixity clause; the author's "G₂ fixes
ℝ ∪ {∞} in 𝕆* and everything else is imaginary"): the great circle is
precisely the G₂-fixed locus of 𝕆*. PROVED — the ⊇ direction moves any
non-real point off itself by reversing its direction (the antipodal pair
exists in S⁶). -/
theorem greatCircle_eq_fixedLocus :
    greatCircle = {x : OnePoint Octonion | ∀ g : G2, g • x = x} := by
  ext x
  constructor
  · intro hx g
    rcases Set.mem_insert_iff.mp hx with rfl | ⟨y, ⟨r, rfl⟩, rfl⟩
    · exact G2.smul_onePoint_infty g
    · rw [G2.smul_onePoint_coe, G2.smul_ofReal]
  · intro hfix
    by_contra hx
    induction x using OnePoint.rec with
    | infty => exact hx (Set.mem_insert _ _)
    | coe y =>
      have hyim : im y ≠ 0 := by
        intro h0
        exact hx (Set.mem_insert_of_mem _
          ⟨y, ⟨re y, (Octonion.eq_ofReal_of_im_eq_zero h0).symm⟩, rfl⟩)
      have hdir := dir_mem_unitImaginarySphere hyim
      have hneg := Octonion.neg_mem_unitImaginarySphere hdir
      obtain ⟨g, hg⟩ := G2.exists_smul_eq_of_mem_unitImaginarySphere hdir hneg
      have hfixy := hfix g
      rw [G2.smul_onePoint_coe, OnePoint.coe_eq_coe] at hfixy
      have hdisp := sliceEmbed_dir_sliceCoord y
      have hsmul : g • y = sliceEmbed (-(dir y)) (sliceCoord y) := by
        conv_lhs => rw [← hdisp]
        rw [G2.smul_sliceEmbed, hg]
      have him1 : im (g • y) = (sliceCoord y).im • -(dir y) := by
        rw [hsmul, im_sliceEmbed hneg]
      have him2 : im y = (sliceCoord y).im • dir y := by
        conv_lhs => rw [← hdisp]
        rw [im_sliceEmbed hdir]
      have him : (sliceCoord y).im • -(dir y) = (sliceCoord y).im • dir y := by
        rw [← him1, ← him2, hfixy]
      have hcoord_im : (sliceCoord y).im ≠ 0 := by
        show Octonion.norm (im y) ≠ 0
        exact ne_of_gt (norm_pos_of_ne_zero hyim)
      have hdir0 : dir y ≠ 0 := by
        intro h
        have := hdir.2
        rw [h, normSq_zero] at this
        norm_num at this
      apply hdir0
      have h3 : (sliceCoord y).im • -(dir y) = (sliceCoord y).im • dir y := him
      rw [smul_neg] at h3
      have h4 : (sliceCoord y).im • dir y + (sliceCoord y).im • dir y = 0 :=
        add_eq_zero_iff_eq_neg.mpr h3.symm
      have h5 : (sliceCoord y).im • dir y = 0 := by
        have h6 : (2 : ℝ) • ((sliceCoord y).im • dir y) = 0 := by
          rw [two_smul]
          exact h4
        have h7 := congrArg (fun t => (2⁻¹ : ℝ) • t) h6
        simpa [smul_smul] using h7
      have h8 := congrArg (fun t => ((sliceCoord y).im)⁻¹ • t) h5
      simpa [smul_smul, inv_mul_cancel₀ hcoord_im] using h8

/-! ## P-ROUTE 4: the placement clause, fed everything — the receipt -/

/-- **P-ROUTE 4's conclusion** (the placement, verbatim class form), with
the geometric clauses FED AS PROVED ROWS:
(a) the one component — `ASection.transport_universal` (PROVED,
    class-wide by design, Pin 1);
(b) the ONE great circle — `sliceSphere_inter` and
    `greatCircle_eq_fixedLocus` (PROVED above);
(c) the sphere/hyperplane geometry — `mem_zeroSphere_iff`,
    `zeroSphere_disjoint` (PROVED, Island B6).
Clause (d) — "hence the two centers agree" — RESISTS: the descent from
(a)'s component equality to a level equality needs a level-separating
invariant of the transport object, and Pin 2
(`TotalTransport.transport_not_level_separating`, PROVED) states it has
none; (b)'s circle is G₂-fixed at EVERY level, so it separates none
either. Goal at the stop: `z.re = w.re`, with no remaining hypothesis
[scrubbed 2026-07-07, author's ruling: the formalization follows the author's argument with no counter-model assumptions]
a closing route must consume C2/C3's joint rigidity — the one stem, the
Brick 2 address. The `sorry` is the ROUTE RECEIPT (unimported artifact;
R8), not a queue item. -/
theorem placement_via_greatCircle (A : ASection) ⦃z w : ℂ⦄
    (hz : A.F z = 0) (hw : A.F w = 0) (hzim : 0 < z.im) (hwim : 0 < w.im) :
    z.re = w.re := by
  have ha : ∀ n m : ℕ, A.transportClass n = A.transportClass m :=
    A.transport_universal
  have hb := @sliceSphere_inter
  have hb' := greatCircle_eq_fixedLocus
  have hc := @mem_zeroSphere_iff
  have hc' := @zeroSphere_disjoint
  sorry
