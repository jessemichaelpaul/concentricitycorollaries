/-
Concentricity/PhiConversion.lean

WORKING ARTIFACT — the Φ-conversion burn (author's ruling 2026-07-06: the
conversion step between the transport's one component and the dictionary's
one centre "is not on the static object, it's the section functor — that's
the only conversion step"). NOT imported by the root; per the
KeystoneAssembly / GreatCircleRoute / LoopAssembly precedent any `sorry`
below is a ROUTE RECEIPT at the exact resisting goal (R6), not a queue
item — the imported ledger (2/0, the welded pair) is untouched.

WHAT IS RENDERED HERE (helpers are never sorried, R8):

§Φ0 — the domain side: each residue-ℂ zero-sphere is ONE component of 𝓗₁
(`lem:residue-spheres` at the H1 register: `H1.sphere_zigzag`), the
conserved quantity of 𝓗₁'s components is the slice coordinate
(`H1.zigzag_coordRead`, via a functor to the discrete category), and
distinct coordinates are distinct components (`H1.zigzag_ne_of_coord_ne`)
— "distinct spheres are distinct orbits" (master, readback clause).

§Φ1 — Φ's collapse (`rmk:collapse-cone` as theorems): every point of every
residue-ℂ zero-sphere realizes to the value-origin 0
(`ASection.realize_sphereZero_pt`), so Φ carries EVERY sphere onto the
SINGLE object S2.of 0 (`ASection.phi_sphere_obj`, `ASection.phi_glue`) —
"the collapse belongs to this functor, not to the codomain" (master,
verbatim).

§Φ2 — π₀(𝒮₂) COMPUTED: the conserved quantity of the slice world's
components is exactly the VALUE modulus together with the point at
infinity — `S2.zigzag_iff_modulus` (both directions PROVED: the invariant
functor to the discrete category; the band rotation to the real
representative). The slice world's component structure carries the
modulus |A(q)| and NOTHING finer: band + direction collapse each modulus
sphere to one component.

§Φ3 — THE CONCENTRIC DICTIONARY (author's register, 2026-07-06: the
dictionary reads the concentric component OF THE A-SECTION as one real
centre; the static-base dictionary is not used): the reading driven at
the two targets, every honest composition of the §Φ0–§Φ2 rows with the
articulation (LoopAssembly.lean, proved) fed as possessions. The
composition rows (α) the value read, (β) the domain read + the
level-not-invariant witness, (γ) the encounter read, and the properness
of the collapse are all PROVED; the ONE `sorry` is the dictionary's
reading step — the route receipt records compositions (0), (α)–(δ) and
the missing Φ-datum in the docstring of `concentric_dictionary`.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.TwoWorlds
import Concentricity.LoopAssembly

noncomputable section

open CategoryTheory

/-! ## §Φ0 — the domain side: zero-spheres as 𝓗₁ components, and what
𝓗₁'s components conserve -/

namespace H1

/-- The slice-coordinate read on the objects of 𝓗₁ (∞ kept as ∞): the
datum `lem:residue-spheres` shows is constant on each orbit component. -/
def coordRead : OnePoint Octonion → OnePoint ℂ :=
  OnePoint.map Octonion.sliceCoord

theorem coordRead_coe (x : Octonion) :
    coordRead (x : OnePoint Octonion) = ((Octonion.sliceCoord x : ℂ) : OnePoint ℂ) :=
  rfl

/-- The coordinate read is G₂-invariant (master `def:section-map`(iii)
engine: `ASection.sliceCoord_smul_invariant`; ∞ is G₂-fixed). PROVED. -/
theorem coordRead_smul (g : G2) (x : OnePoint Octonion) :
    coordRead (g • x) = coordRead x := by
  induction x using OnePoint.rec with
  | infty => rfl
  | coe y =>
    rw [G2.smul_onePoint_coe, coordRead_coe, coordRead_coe,
      ASection.sliceCoord_smul_invariant g y]

/-- The coordinate functor 𝓗₁ ⥤ Disc(𝕆*-coordinates): the invariant of
`lem:residue-spheres`' component structure, packaged as a functor to the
discrete category (the register of `def:base`'s "connectivity here is the
groupoid's"). PROVED (Discrete homs are subsingletons). -/
def coordFunctor : H1 ⥤ Discrete (OnePoint ℂ) where
  obj p := ⟨coordRead (CategoryTheory.ActionCategory.back p)⟩
  map {p _} f := eqToHom (congrArg Discrete.mk
    ((congrArg coordRead f.property).symm.trans
      (coordRead_smul f.val (CategoryTheory.ActionCategory.back p))).symm)
  map_id _ := Subsingleton.elim _ _
  map_comp _ _ := Subsingleton.elim _ _

/-- **The conserved quantity of 𝓗₁'s components is the slice coordinate**
(master `lem:residue-spheres` proof: "the connected components of 𝓗₁ are
exactly the G₂-orbits"): a zigzag of 𝓗₁ preserves the coordinate read.
PROVED — functors preserve zigzags (`zigzag_obj_of_zigzag`), discrete
categories force equality (`eq_of_zigzag`). -/
theorem zigzag_coordRead {x y : OnePoint Octonion}
    (h : Zigzag (H1.of x) (H1.of y)) : coordRead x = coordRead y :=
  eq_of_zigzag _ (zigzag_obj_of_zigzag coordFunctor h)

/-- A direction morphism joins any point to its G₂-translate: the
generating zigzag of an orbit component. PROVED. -/
theorem zigzag_of_smul (g : G2) (x : OnePoint Octonion) :
    Zigzag (H1.of x) (H1.of (g • x)) :=
  Zigzag.of_hom ⟨g, rfl⟩

/-- **`lem:residue-spheres`, connectivity half, at the H1 register**: two
points of one sphere (equal slice coordinate, both along unit imaginary
directions) lie in ONE component of 𝓗₁ — the orbit transitivity
(`thm:G2-S6`, Baez; the in-repo `G2.exists_smul_eq_of_mem_unitImaginarySphere`)
read as a zigzag. PROVED. -/
theorem sphere_zigzag {v w : Octonion} (hv : v ∈ Octonion.unitImaginarySphere)
    (hw : w ∈ Octonion.unitImaginarySphere) (ζ : ℂ) :
    Zigzag (H1.of ((Octonion.sliceEmbed v ζ : Octonion) : OnePoint Octonion))
      (H1.of ((Octonion.sliceEmbed w ζ : Octonion) : OnePoint Octonion)) := by
  obtain ⟨g, hg⟩ := G2.exists_smul_eq_of_mem_unitImaginarySphere hv hw
  have h := zigzag_of_smul g ((Octonion.sliceEmbed v ζ : Octonion) : OnePoint Octonion)
  rw [G2.smul_onePoint_coe, G2.smul_sliceEmbed, hg] at h
  exact h

/-- **`lem:residue-spheres`, disjointness half, at the H1 register**
(master, readback clause: "distinct spheres are distinct orbits, hence
pairwise disjoint"): distinct slice coordinates are distinct components.
PROVED. -/
theorem zigzag_ne_of_coord_ne {x y : Octonion}
    (h : Octonion.sliceCoord x ≠ Octonion.sliceCoord y) :
    ¬ Zigzag (H1.of (x : OnePoint Octonion)) (H1.of (y : OnePoint Octonion)) := by
  intro hz
  have hc := zigzag_coordRead hz
  rw [coordRead_coe, coordRead_coe] at hc
  exact h (OnePoint.coe_eq_coe.mp hc)

end H1

/-! ## §Φ2 — π₀(𝒮₂) computed: the slice world's components carry the
VALUE modulus and nothing finer -/

/-- `normSq` is nonnegative (helper; from the in-repo positivity row).
PROVED. -/
theorem Octonion.normSq_nonneg (x : Octonion) : 0 ≤ Octonion.normSq x := by
  by_cases hx : x = 0
  · rw [hx, Octonion.normSq_zero]
  · exact (Octonion.normSq_pos_of_ne_zero hx).le

namespace SliceWorld

/-- The modulus read on the objects of 𝒮₂ (∞ kept as ∞): the quadratic
form `normSq`, the datum the band phases fix (master `def:two-worlds`:
"the Möbius self-maps of S²_I fixing the value-origin 0, the point at
infinity N, and the modulus"). -/
def modulus : SliceWorld → OnePoint ℝ :=
  OnePoint.map Octonion.normSq

theorem modulus_coe (x : Octonion) :
    modulus (x : OnePoint Octonion) = ((Octonion.normSq x : ℝ) : OnePoint ℝ) :=
  rfl

theorem modulus_infty :
    modulus (OnePoint.infty : OnePoint Octonion) = OnePoint.infty :=
  rfl

/-- **Every generator of 𝒮₂ conserves the modulus** (master
`def:two-worlds`: direction morphisms are G₂ — the isometry block; band
phases fix the modulus by their very clause). PROVED, by cases on the
generator. -/
theorem modulus_gen : ∀ {w w' : SliceWorld}, Gen w w' → modulus w = modulus w' := by
  intro w w' g
  cases g with
  | direction g w =>
    induction w using OnePoint.rec with
    | infty => rfl
    | coe x =>
      rw [G2.smul_onePoint_coe, modulus_coe, modulus_coe, G2.smul_normSq]
  | band hv θ ζ =>
    rw [modulus_coe, modulus_coe]
    have hsq : ∀ w : ℂ, w.re ^ 2 + w.im ^ 2 = ‖w‖ ^ 2 := fun w => by
      rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]
      ring
    rw [Octonion.normSq_sliceEmbed hv, Octonion.normSq_sliceEmbed hv, hsq, hsq,
      norm_mul, Complex.norm_exp_ofReal_mul_I, one_mul]
  | bandInfty hv θ => rfl

/-- The modulus, as a prefunctor from the generator quiver into the
discrete category on the compactified reals. -/
def modulusHom : SliceWorld ⥤q Discrete (OnePoint ℝ) where
  obj w := ⟨modulus w⟩
  map g := eqToHom (congrArg Discrete.mk (modulus_gen g))

end SliceWorld

namespace S2

/-- The modulus functor 𝒮₂ ⥤ Disc(ℝ ∪ {∞}): the generator prefunctor
lifted through the free path category (`Paths.lift`) and descended along
the direction relations (`Quotient.lift`; discrete homs are subsingletons,
so every relation is respected). PROVED. -/
def modulusFunctor : S2 ⥤ Discrete (OnePoint ℝ) :=
  CategoryTheory.Quotient.lift SliceWorld.Rel
    (CategoryTheory.Paths.lift SliceWorld.modulusHom)
    (fun _ _ _ _ _ => Subsingleton.elim _ _)

/-- **The conserved quantity of 𝒮₂'s components: the modulus** — a zigzag
of the slice world preserves the modulus read. PROVED (functors preserve
zigzags; discrete categories force equality). -/
theorem zigzag_modulus {w w' : OnePoint Octonion}
    (h : Zigzag (S2.of w) (S2.of w')) :
    SliceWorld.modulus w = SliceWorld.modulus w' :=
  eq_of_zigzag _ (zigzag_obj_of_zigzag modulusFunctor h)

/-- Each generator yields a zigzag of 𝒮₂. PROVED. -/
theorem zigzag_of_gen {w w' : SliceWorld} (g : SliceWorld.Gen w w') :
    Zigzag (S2.of w) (S2.of w') :=
  Zigzag.of_hom
    ((CategoryTheory.Quotient.functor SliceWorld.Rel).map (Quiver.Hom.toPath g))

/-- The band rotation that carries a slice coordinate onto its modulus:
θ = −arg ζ (`Complex.norm_mul_exp_arg_mul_I`). PROVED helper. -/
theorem exists_band_rotation (ζ : ℂ) :
    ∃ θ : ℝ, Complex.exp ((θ : ℂ) * Complex.I) * ζ = (‖ζ‖ : ℂ) := by
  refine ⟨-Complex.arg ζ, ?_⟩
  calc Complex.exp ((↑(-Complex.arg ζ) : ℂ) * Complex.I) * ζ
      = Complex.exp ((↑(-Complex.arg ζ) : ℂ) * Complex.I) *
          ((‖ζ‖ : ℂ) * Complex.exp ((Complex.arg ζ : ℂ) * Complex.I)) := by
        rw [Complex.norm_mul_exp_arg_mul_I ζ]
    _ = (‖ζ‖ : ℂ) * Complex.exp ((↑(-Complex.arg ζ) : ℂ) * Complex.I
          + (Complex.arg ζ : ℂ) * Complex.I) := by
        rw [Complex.exp_add]; ring
    _ = (‖ζ‖ : ℂ) := by
        push_cast
        rw [show -(Complex.arg ζ : ℂ) * Complex.I + (Complex.arg ζ : ℂ) * Complex.I = 0
            by ring,
          Complex.exp_zero, mul_one]

/-- The unit imaginary sphere is inhabited — the Cayley–Dickson unit
(0, 1) ∈ ℍ × ℍ. (Re-derived locally: the identical row
`Octonion.unitImaginarySphere_nonempty` lives in
Concentricity/ZeroSpheres.lean atop the ζ tower, not imported by this
artifact.) PROVED helper. -/
private theorem unitSphere_nonempty : Octonion.unitImaginarySphere.Nonempty := by
  refine ⟨((0 : Quaternion ℝ), (1 : Quaternion ℝ)), ?_, ?_⟩
  · rfl
  · simp [Octonion.normSq]

/-- **Every finite point of the slice world is band-connected to the real
representative of its modulus**: rotate the slice coordinate onto the
positive real axis (the band fixes the modulus; the real point is shared
by every slice sphere). PROVED. -/
theorem zigzag_to_norm (x : Octonion) :
    Zigzag (S2.of (x : OnePoint Octonion))
      (S2.of ((Octonion.ofReal (Octonion.norm x) : Octonion) : OnePoint Octonion)) := by
  obtain ⟨v, hv, ζ, hx, hζ⟩ :
      ∃ v ∈ Octonion.unitImaginarySphere, ∃ ζ : ℂ,
        Octonion.sliceEmbed v ζ = x ∧ ‖ζ‖ = Octonion.norm x := by
    by_cases him : Octonion.im x = 0
    · obtain ⟨v, hv⟩ := unitSphere_nonempty
      refine ⟨v, hv, ((Octonion.re x : ℝ) : ℂ), ?_, ?_⟩
      · rw [Octonion.sliceEmbed_ofReal]
        exact (Octonion.eq_ofReal_of_im_eq_zero him).symm
      · rw [Complex.norm_real, Real.norm_eq_abs, ← Octonion.norm_ofReal,
          ← Octonion.eq_ofReal_of_im_eq_zero him]
    · refine ⟨Octonion.dir x, Octonion.dir_mem_unitImaginarySphere him,
        Octonion.sliceCoord x, Octonion.sliceEmbed_dir_sliceCoord x, ?_⟩
      have h1 : Octonion.normSq x
          = (Octonion.sliceCoord x).re ^ 2 + (Octonion.sliceCoord x).im ^ 2 := by
        conv_lhs => rw [← Octonion.sliceEmbed_dir_sliceCoord x]
        exact Octonion.normSq_sliceEmbed
          (Octonion.dir_mem_unitImaginarySphere him) _
      rw [Octonion.norm, h1,
        show (Octonion.sliceCoord x).re ^ 2 + (Octonion.sliceCoord x).im ^ 2
            = ‖Octonion.sliceCoord x‖ ^ 2 from by
          rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]; ring,
        Real.sqrt_sq (norm_nonneg _)]
  obtain ⟨θ, hθ⟩ := exists_band_rotation ζ
  have h := zigzag_of_gen (SliceWorld.Gen.band hv θ ζ)
  rw [hθ, Octonion.sliceEmbed_ofReal, hζ, hx] at h
  exact h

/-- Two finite points of equal quadratic form lie in ONE component of 𝒮₂.
PROVED. -/
theorem zigzag_of_normSq_eq {x y : Octonion}
    (h : Octonion.normSq x = Octonion.normSq y) :
    Zigzag (S2.of (x : OnePoint Octonion)) (S2.of (y : OnePoint Octonion)) := by
  have hn : Octonion.norm x = Octonion.norm y := by
    rw [Octonion.norm, Octonion.norm, h]
  have h1 := zigzag_to_norm x
  rw [hn] at h1
  exact h1.trans (zigzag_to_norm y).symm

/-- **π₀(𝒮₂) COMPUTED** — the component relation of the slice world is
EXACTLY equality of the modulus read: forward, the invariant functor;
backward, the band rotation to the shared real representative. The slice
world's component structure carries the value modulus (plus the one ∞)
and NOTHING finer. PROVED, both directions. -/
theorem zigzag_iff_modulus {w w' : OnePoint Octonion} :
    Zigzag (S2.of w) (S2.of w') ↔ SliceWorld.modulus w = SliceWorld.modulus w' := by
  refine ⟨zigzag_modulus, fun h => ?_⟩
  induction w using OnePoint.rec with
  | infty =>
    induction w' using OnePoint.rec with
    | infty => exact Zigzag.refl _
    | coe y =>
      rw [SliceWorld.modulus_infty, SliceWorld.modulus_coe] at h
      exact absurd h.symm (OnePoint.coe_ne_infty _)
  | coe x =>
    induction w' using OnePoint.rec with
    | infty =>
      rw [SliceWorld.modulus_infty, SliceWorld.modulus_coe] at h
      exact absurd h (OnePoint.coe_ne_infty _)
    | coe y =>
      rw [SliceWorld.modulus_coe, SliceWorld.modulus_coe] at h
      exact zigzag_of_normSq_eq (OnePoint.coe_eq_coe.mp h)

/-- The modulus read, valued in the compactified nonnegative reals (the
exact component set). -/
def moduliRead : OnePoint Octonion → OnePoint NNReal :=
  OnePoint.map fun x => NNReal.mk (Octonion.normSq x) (Octonion.normSq_nonneg x)

theorem moduliRead_coe (x : Octonion) :
    moduliRead (x : OnePoint Octonion)
      = ((NNReal.mk (Octonion.normSq x) (Octonion.normSq_nonneg x)) : OnePoint NNReal) :=
  rfl

theorem moduliRead_infty : moduliRead OnePoint.infty = OnePoint.infty :=
  rfl

/-- The compactified-modulus read is determined by the modulus read.
PROVED helper. -/
theorem moduliRead_eq_of_modulus_eq {w w' : OnePoint Octonion}
    (h : SliceWorld.modulus w = SliceWorld.modulus w') :
    moduliRead w = moduliRead w' := by
  induction w using OnePoint.rec with
  | infty =>
    induction w' using OnePoint.rec with
    | infty => rfl
    | coe y =>
      rw [SliceWorld.modulus_infty, SliceWorld.modulus_coe] at h
      exact absurd h.symm (OnePoint.coe_ne_infty _)
  | coe x =>
    induction w' using OnePoint.rec with
    | infty =>
      rw [SliceWorld.modulus_infty, SliceWorld.modulus_coe] at h
      exact absurd h (OnePoint.coe_ne_infty _)
    | coe y =>
      rw [SliceWorld.modulus_coe, SliceWorld.modulus_coe] at h
      rw [moduliRead_coe, moduliRead_coe]
      exact congrArg OnePoint.some (NNReal.eq (OnePoint.coe_eq_coe.mp h))

/-- The real representative of a compactified modulus, as a component of
𝒮₂. -/
def componentOfModulus : OnePoint NNReal → ConnectedComponents S2 := fun r =>
  OnePoint.rec
    (CategoryTheory.ConnectedComponents.mk (S2.of OnePoint.infty))
    (fun s => CategoryTheory.ConnectedComponents.mk
      (S2.of ((Octonion.ofReal (Real.sqrt (s : ℝ)) : Octonion) : OnePoint Octonion)))
    r

/-- Round trip on the object side: the representative of a point's
modulus is the point's own component (the band rotation). PROVED. -/
theorem componentOfModulus_moduliRead (w : OnePoint Octonion) :
    componentOfModulus (moduliRead w)
      = CategoryTheory.ConnectedComponents.mk (S2.of w) := by
  induction w using OnePoint.rec with
  | infty => rfl
  | coe x =>
    rw [moduliRead_coe]
    refine _root_.Quotient.sound' (zigzag_of_normSq_eq ?_)
    rw [Octonion.normSq_ofReal, NNReal.coe_mk,
      Real.sq_sqrt (Octonion.normSq_nonneg x)]

/-- Round trip on the modulus side: the modulus of the real
representative is the modulus. PROVED helper. -/
theorem moduliRead_ofReal_sqrt (s : NNReal) :
    moduliRead ((Octonion.ofReal (Real.sqrt (s : ℝ)) : Octonion) : OnePoint Octonion)
      = (s : OnePoint NNReal) := by
  rw [moduliRead_coe]
  exact congrArg OnePoint.some (NNReal.eq (by
    rw [NNReal.coe_mk, Octonion.normSq_ofReal, Real.sq_sqrt s.coe_nonneg]))

/-- **π₀(𝒮₂), the named equivalence**: the components of the slice world
ARE the nonnegative moduli together with the point at infinity —
π₀(𝒮₂) ≃ [0,∞) ∪ {∞}. The value-side analogue of the base dictionary's
level read-off, PROVED: forward the modulus read (zigzag-invariant),
inverse the real representative √r; round trips by the band rotation. -/
def componentsEquiv : ConnectedComponents S2 ≃ OnePoint NNReal where
  toFun := Quotient.lift (fun X : S2 => moduliRead X.as) fun _ _ h =>
    moduliRead_eq_of_modulus_eq (zigzag_modulus h)
  invFun := componentOfModulus
  left_inv := Quotient.ind fun X => componentOfModulus_moduliRead X.as
  right_inv r := by
    induction r using OnePoint.rec with
    | infty => rfl
    | coe s => exact moduliRead_ofReal_sqrt s

/-- The equivalence at a canonical class, unfolded (definitional). -/
theorem componentsEquiv_mk (w : OnePoint Octonion) :
    componentsEquiv (CategoryTheory.ConnectedComponents.mk (S2.of w))
      = moduliRead w :=
  rfl

/-- **The level is NOT an 𝒮₂-invariant** (witness): the band connects the
real point 1 (level 1) to any unit imaginary point v (level 0) — same
modulus, different real parts. The band's rotation moves the level into
the height within each modulus circle; π₀(𝒮₂) forgets the level by
construction. PROVED. -/
theorem level_not_invariant {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) :
    Zigzag (S2.of ((1 : Octonion) : OnePoint Octonion))
      (S2.of (v : OnePoint Octonion)) :=
  zigzag_of_normSq_eq (by rw [Octonion.normSq_one, hv.2])

end S2

/-! ## §Φ1 — Φ's collapse: the zero-spheres onto the single object 0
(`rmk:collapse-cone` as theorems) -/

/-- `Octonion.ofReal` at 0 (helper). PROVED. -/
theorem Octonion.ofReal_zero : Octonion.ofReal 0 = 0 := by
  rw [Octonion.ofReal_eq_smul_one, zero_smul]

/-- The slice embedding of the coordinate 0 is the value-origin 0, along
every direction (helper). PROVED. -/
theorem Octonion.sliceEmbed_zero (v : Octonion) :
    Octonion.sliceEmbed v (0 : ℂ) = 0 := by
  rw [show ((0 : ℂ)) = ((0 : ℝ) : ℂ) by norm_num, Octonion.sliceEmbed_ofReal,
    Octonion.ofReal_zero]

namespace ASection

/-- The realization of an A-section at a non-real stem zero is the
value-origin 0 (master `def:section-map`(iii): "if A vanishes at one point
of the orbit it vanishes on the whole orbit"). PROVED. -/
theorem realize_of_stem_zero (A : ASection) {x : Octonion}
    (him : Octonion.im x ≠ 0) (hz : A.F (Octonion.sliceCoord x) = 0) :
    A.realize (x : OnePoint Octonion) = ((0 : Octonion) : OnePoint Octonion) := by
  have hpos : 0 < (Octonion.sliceCoord x).im := Octonion.norm_pos_of_ne_zero him
  have hnp : Octonion.sliceCoord x ≠ (A.pole : ℂ) := by
    intro h
    rw [h] at hpos
    simp at hpos
  have han : AnalyticAt ℂ A.F (Octonion.sliceCoord x) := A.c1_analyticAt _ hnp
  rw [realize_coe, if_pos han, hz, Octonion.sliceEmbed_zero]

/-- The slice coordinate of a sphere representative is the enumerated
zero itself (the upper-half representative; C3's `c3_sphere_nonreal`).
PROVED helper. -/
theorem sliceCoord_sphere_pt (A : ASection) (n : ℕ) {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) :
    Octonion.sliceCoord (Octonion.sliceEmbed v (A.sphereZero n))
      = A.sphereZero n := by
  rw [Octonion.sliceCoord_sliceEmbed hv]
  exact Complex.ext rfl (abs_of_pos (A.c3_sphere_nonreal n))

/-- A sphere representative is non-real (helper). PROVED. -/
theorem im_sphere_pt_ne_zero (A : ASection) (n : ℕ) {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) :
    Octonion.im (Octonion.sliceEmbed v (A.sphereZero n)) ≠ 0 := by
  have him : 0 < (A.sphereZero n).im := A.c3_sphere_nonreal n
  rw [Octonion.im_sliceEmbed hv]
  intro h0
  have h1 := congrArg Octonion.normSq h0
  rw [Octonion.normSq_smul, hv.2, mul_one, Octonion.normSq_zero] at h1
  exact pow_ne_zero 2 him.ne' h1

/-- **Every point of the n-th residue-ℂ zero-sphere realizes to 0**: the
enumerated stem zero (`stem_zero_of_sphereZero`, C3's divisor) read on the
whole orbit. PROVED. -/
theorem realize_sphereZero_pt (A : ASection) (n : ℕ) {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) :
    A.realize ((Octonion.sliceEmbed v (A.sphereZero n) : Octonion) : OnePoint Octonion)
      = ((0 : Octonion) : OnePoint Octonion) :=
  A.realize_of_stem_zero (A.im_sphere_pt_ne_zero n hv)
    (by rw [A.sliceCoord_sphere_pt n hv]; exact A.stem_zero_of_sphereZero n)

/-- **`rmk:collapse-cone`, object clause, as a theorem** (master,
verbatim: "Φ carries each residue-ℂ zero-sphere of A — a 6-sphere
component of 𝓗₁ (Lemma lem:residue-spheres) — onto the *single* object
0 ∈ 𝒮₂, the value-origin, fixed by band and direction"). PROVED. -/
theorem phi_sphere_obj (A : ASection) (n : ℕ) {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) :
    (sectionFunctor A).obj
        (H1.of ((Octonion.sliceEmbed v (A.sphereZero n) : Octonion) : OnePoint Octonion))
      = S2.of ((0 : Octonion) : OnePoint Octonion) :=
  (sectionFunctor_obj A _).trans (congrArg S2.of (A.realize_sphereZero_pt n hv))

/-- **THE GLUE** (the author's word, 2026-07-06: "the A-section functor …
is what glues these"): Φ carries ALL the residue-ℂ zero-spheres — every
point of every one of them — onto the ONE object S2.of 0. PROVED. -/
theorem phi_glue (A : ASection) (n m : ℕ) {v w : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) (hw : w ∈ Octonion.unitImaginarySphere) :
    (sectionFunctor A).obj
        (H1.of ((Octonion.sliceEmbed v (A.sphereZero n) : Octonion) : OnePoint Octonion))
      = (sectionFunctor A).obj
        (H1.of ((Octonion.sliceEmbed w (A.sphereZero m) : Octonion) : OnePoint Octonion)) :=
  (A.phi_sphere_obj n hv).trans (A.phi_sphere_obj m hw).symm

/-- The component form of the collapse: Φ's induced map on π₀ sends every
zero-sphere class to the class of the value-origin. PROVED. -/
theorem phi_class_eq (A : ASection) (n : ℕ) {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) :
    (sectionFunctor A).mapConnectedComponents
        (CategoryTheory.ConnectedComponents.mk
          (H1.of ((Octonion.sliceEmbed v (A.sphereZero n) : Octonion) : OnePoint Octonion)))
      = CategoryTheory.ConnectedComponents.mk
          (S2.of ((0 : Octonion) : OnePoint Octonion)) := by
  rw [Functor.mapConnectedComponents_mk]
  exact congrArg _ (A.phi_sphere_obj n hv)

/-- **`rmk:collapse-cone`, pole clause, as a theorem** (master, verbatim:
"and by C1 it carries the pole point onto the single object 𝔫"): the
realization at the pole is the point at infinity — C1's simple pole
(`c1_simple`) forbids analyticity there
(`AnalyticAt.meromorphicOrderAt_nonneg`,
Mathlib/Analysis/Meromorphic/Order.lean:291). PROVED. -/
theorem realize_pole (A : ASection) :
    A.realize ((Octonion.ofReal A.pole : Octonion) : OnePoint Octonion)
      = OnePoint.infty := by
  have hc : Octonion.sliceCoord (Octonion.ofReal A.pole) = (A.pole : ℂ) := by
    unfold Octonion.sliceCoord
    rw [Octonion.im_ofReal, Octonion.norm_zero, Octonion.re_ofReal]
    exact Complex.ext rfl (Complex.ofReal_im _).symm
  have hnot : ¬ AnalyticAt ℂ A.F ((A.pole : ℝ) : ℂ) := by
    intro han
    have h0 := han.meromorphicOrderAt_nonneg
    rw [A.c1_simple] at h0
    have h1 : (0 : ℤ) ≤ (-1 : ℤ) := by exact_mod_cast h0
    norm_num at h1
  rw [realize_coe, hc, if_neg hnot]

end ASection

/-! ## §Φ3 — the conversion driven: THE CONCENTRIC DICTIONARY on the
A-section register (author's ruling 2026-07-06: the dictionary reads the
concentric component OF THE A-SECTION as one real centre; the reading is
proved by the A-section's structure — Φ, the fibre, the glue) -/

namespace ASection

/-- **Composition (α), the VALUE read — PROVED as far as it goes**: the
π₀(𝒮₂)-read of every zero-sphere's Φ-image is the modulus 0 — the ONE
value-origin class, for every n and every direction. The glue is total;
the read is the same 0 at every sphere, so it carries NO level datum. -/
theorem phi_image_modulus (A : ASection) (n : ℕ) {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) :
    S2.componentsEquiv
        ((sectionFunctor A).mapConnectedComponents
          (CategoryTheory.ConnectedComponents.mk
            (H1.of ((Octonion.sliceEmbed v (A.sphereZero n) : Octonion)
              : OnePoint Octonion))))
      = ((0 : NNReal) : OnePoint NNReal) := by
  rw [A.phi_class_eq n hv, S2.componentsEquiv_mk, S2.moduliRead_coe]
  exact congrArg OnePoint.some (NNReal.eq (by
    rw [NNReal.coe_mk, Octonion.normSq_zero, NNReal.coe_zero]))

/-- **Composition (β), the DOMAIN read — PROVED as far as it goes**: the
two worlds share the underlying points of 𝕆* (master `def:two-worlds`),
so the n-th sphere's points can also be read as objects of 𝒮₂ ITSELF; the
conserved quantity of that read is ‖ρₙ‖² = σₙ² + γₙ² — the B2.0
inverse-coordinate variable (`inv_re_bridge`, PlacementSet.lean), NOT the
level σₙ: the band's rotation moves the level into the height within each
modulus circle, so the level alone is not an 𝒮₂-invariant. -/
theorem sphere_domain_modulus (A : ASection) (n : ℕ) {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) :
    SliceWorld.modulus
        ((Octonion.sliceEmbed v (A.sphereZero n) : Octonion) : OnePoint Octonion)
      = ((‖A.sphereZero n‖ ^ 2 : ℝ) : OnePoint ℝ) := by
  rw [SliceWorld.modulus_coe, Octonion.normSq_sliceEmbed hv]
  exact congrArg _ (by
    rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]; ring)

/-- **Composition (γ), the ENCOUNTER read — PROVED as far as it goes**:
at any two non-real domain points where the stem takes ONE common value
(the shared-ladder encounters, LoopAssembly §C), the Φ-images lie in ONE
component of 𝒮₂ — the value moduli match. This is the only place Φ's
carriage is non-degenerate (the read is the encounter's own r ≠ 0), and
the conserved datum is still the VALUE, never the domain level. -/
theorem phi_encounter_zigzag (A : ASection) {x y : Octonion}
    (hx : Octonion.im x ≠ 0) (hy : Octonion.im y ≠ 0)
    (hax : AnalyticAt ℂ A.F (Octonion.sliceCoord x))
    (hay : AnalyticAt ℂ A.F (Octonion.sliceCoord y))
    (hval : A.F (Octonion.sliceCoord x) = A.F (Octonion.sliceCoord y)) :
    Zigzag ((sectionFunctor A).obj (H1.of (x : OnePoint Octonion)))
      ((sectionFunctor A).obj (H1.of (y : OnePoint Octonion))) := by
  rw [sectionFunctor_obj, sectionFunctor_obj, realize_coe, realize_coe,
    if_pos hax, if_pos hay]
  refine S2.zigzag_of_normSq_eq ?_
  rw [Octonion.normSq_sliceEmbed (Octonion.dir_mem_unitImaginarySphere hx),
    Octonion.normSq_sliceEmbed (Octonion.dir_mem_unitImaginarySphere hy), hval]

/-- **The collapse is proper** (`rmk:collapse-cone`: "The collapse
belongs to this functor, not to the codomain"): C4 supplies two distinct
enumerated zeros; their sphere classes are DISTINCT components of 𝓗₁
(the coordinate read separates them) while their Φ-images are the SAME
component of 𝒮₂ (the glue) — the section functor's π₀-map is not
injective, machine-checked. PROVED. -/
theorem phi_collapse_proper (A : ASection) :
    ∃ (n m : ℕ) (v : Octonion) (_ : v ∈ Octonion.unitImaginarySphere),
      (CategoryTheory.ConnectedComponents.mk
          (H1.of ((Octonion.sliceEmbed v (A.sphereZero n) : Octonion) : OnePoint Octonion))
        ≠ CategoryTheory.ConnectedComponents.mk
          (H1.of ((Octonion.sliceEmbed v (A.sphereZero m) : Octonion) : OnePoint Octonion)))
      ∧ (sectionFunctor A).mapConnectedComponents
          (CategoryTheory.ConnectedComponents.mk
            (H1.of ((Octonion.sliceEmbed v (A.sphereZero n) : Octonion) : OnePoint Octonion)))
        = (sectionFunctor A).mapConnectedComponents
          (CategoryTheory.ConnectedComponents.mk
            (H1.of ((Octonion.sliceEmbed v (A.sphereZero m) : Octonion) : OnePoint Octonion))) := by
  obtain ⟨n, m, hnm⟩ : ∃ n m : ℕ, A.sphereZero n ≠ A.sphereZero m := by
    by_contra hall
    push Not at hall
    have hsub : Set.range A.sphereZero ⊆ {A.sphereZero 0} := by
      rintro _ ⟨k, rfl⟩
      exact hall k 0
    exact A.c4_infinite (Set.Finite.subset (Set.finite_singleton _) hsub)
  obtain ⟨v, hv⟩ := S2.unitSphere_nonempty
  refine ⟨n, m, v, hv, fun hclass => ?_, ?_⟩
  · refine H1.zigzag_ne_of_coord_ne
      (x := Octonion.sliceEmbed v (A.sphereZero n))
      (y := Octonion.sliceEmbed v (A.sphereZero m)) ?_ (Quotient.exact' hclass)
    rw [A.sliceCoord_sphere_pt n hv, A.sliceCoord_sphere_pt m hv]
    exact hnm
  · rw [Functor.mapConnectedComponents_mk, Functor.mapConnectedComponents_mk]
    exact congrArg _ (A.phi_glue n m hv hv)

/-- **THE CONCENTRIC DICTIONARY** (author's register, 2026-07-06): the
concentric component of the A-SECTION — the articulation's three clauses
(one component; defined through the witness N; the fibre concentric),
here as hypotheses — read as ONE REAL CENTRE, the reading to be proved
by the A-section's own structure: Φ, the fibre, the glue.

RECEIPT (R6, 2026-07-06 — the Φ-conversion burn). Goal at the stop:
  ⊢ ∃ c, ∀ (n : ℕ), (A.sphereZero n).re = c
unchanged by every feed below, and RESISTS. The record:

(0) THE HYPOTHESES ARE FREE. Each of the three concentric-component
clauses is a proved possession of the rendered structure with no
hypothesis at all (machine-checked at this burn): h_one is
`transport_universal`, h_witness is `classOf_eq_nClass`, h_fibre is
`exp_fibre_level` — so this dictionary's READING STEP carries the full
weight of the open node: were it to close, `placement_set` would be a
theorem of the class outright.

(α) THE VALUE READ (`phi_image_modulus`, PROVED): Φ carries every
sphere's H1-class to THE one 𝒮₂-class of the value-origin, and the
π₀(𝒮₂)-read of that class is the modulus 0 — the same 0 for every n. The
glue is total; the extracted datum is level-free.

(β) THE DOMAIN READ (`sphere_domain_modulus`, PROVED): reading the
sphere representatives as objects of 𝒮₂ itself, the conserved quantity
is ‖ρₙ‖² = σₙ² + γₙ² — and `S2.level_not_invariant` (PROVED) witnesses
that the level σ alone is NOT an 𝒮₂-invariant: the band rotates the
level into the height within each modulus circle. No rendered row forces
the sphere moduli ‖ρₙ‖ to agree across n, and modulus agreement would
not read back to level agreement without the height γₙ — the two data
the band mixes.

(γ) THE ENCOUNTER READ (`phi_encounter_zigzag`, PROVED): at the shared-
ladder encounters the Φ-images share one 𝒮₂-component with non-degenerate
read r — the encounter's own VALUE, conserved in the value fibre at any
domain level (the LoopAssembly draft-I receipt's litmus, intact under Φ).

(δ) THE REGISTER SEAM, stated as the needed datum: to consume h_fibre at
the goal's registers one needs an exp-fibre pair carrying the two DOMAIN
levels —
  ∃ r > 0, ∃ w₁ w₂, exp w₁ = −r ∧ exp w₂ = −r ∧
    w₁.re = Re ρₙ ∧ w₂.re = Re ρₘ
— and `exact?` at that seam: could not close the goal (no proved row
supplies it; every fibre point over −r has re = log r, the VALUE level).
`exact?` at THIS goal returns only the sorried LoopAssembly receipts —
no proved-row closure exists on the board.

THE MISSING INFERENCE, in the section-functor vocabulary (one sentence):
the reading consumes the base object BENEATH each collapsed sphere — the
datum `rmk:collapse-cone` assigns to the transport and expressly denies
to Φ ("the differing centres … are not remembered by Φ's object map;
they are remembered by the transport over the base") — and no rendered
Φ-carriage returns it: Φ sends every sphere to the one value-origin,
π₀(𝒮₂) conserves exactly the value modulus (0 there), so the
level-separating readout the dictionary needs is `eq:placement-set`
itself. `sorry` = ROUTE RECEIPT (unimported artifact; R8), not a queue
item. -/
theorem concentric_dictionary (A : ASection)
    (h_one : ∀ n m : ℕ, A.transportClass n = A.transportClass m)
    (h_witness : ∀ n : ℕ, A.transportClass n
        = CategoryTheory.ConnectedComponents.mk TotalTransport.nObj)
    (h_fibre : ∀ r : ℝ, 0 < r → ∀ w₁ w₂ : ℂ,
        Complex.exp w₁ = -(r : ℂ) → Complex.exp w₂ = -(r : ℂ) → w₁.re = w₂.re) :
    ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c := by
  -- Φ-carriage rows, all PROVED (this file):
  have hφ_sphere := @H1.sphere_zigzag           -- each sphere: ONE H1 class
  have hφ_coord := @H1.zigzag_coordRead          -- H1 conserves the coordinate
  have hφ_distinct := @H1.zigzag_ne_of_coord_ne  -- distinct spheres: distinct orbits
  have hφ_collapse := @ASection.phi_sphere_obj A -- Φ: every sphere ↦ the object 0
  have hφ_glue := @ASection.phi_glue A           -- the glue is total
  have hφ_proper := A.phi_collapse_proper        -- and proper: distinct orbits glued
  have hφ_cone := A.realize_pole                 -- Φ: the pole ↦ 𝔫
  have hφ_pi0 := @S2.zigzag_iff_modulus          -- π₀(𝒮₂) = the value modulus
  have hφ_value := @ASection.phi_image_modulus A -- (α): the value read = 0, all n
  have hφ_domain := @ASection.sphere_domain_modulus A -- (β): the domain read = ‖ρₙ‖²
  have hφ_encounter := @ASection.phi_encounter_zigzag A -- (γ): the encounter read
  -- the ladder/assembly possessions (LoopAssembly.lean, PROVED):
  have h_ladder := A.shared_ladder_encounters
  have h_cone := A.pole_cone_eps_delta
  have h_level := @winding_loop_defect_level_zero
  -- RECEIPT: ⊢ ∃ c, ∀ n, (A.sphereZero n).re = c — see the docstring's
  -- record (0), (α)–(δ); the reading step IS eq:placement-set.
  sorry

/-- **Target 1 — `cor:nontrivial`'s content via the Φ-conversion**
(RESISTED at the dictionary's reading step; rides the receipt): the
chain of record (author, 2026-07-06): ζ_𝕆 is an A-section → concentricity
(the theorem + the articulation + THIS dictionary) → the rh-equiv rows
(`riemannHypothesis_iff_concentric`,
`upperZero_re_eq_half_of_concentric`, RhEquiv.lean, PROVED stock) + the
functional equation pin ½. Everything on both sides of the dictionary's
one reading step is proved. -/
theorem nontrivial_one_centre_via_phi (A : ASection) :
    ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c := by
  obtain ⟨h_one, h_witness, h_fibre⟩ := A.concentric_articulation
  exact A.concentric_dictionary h_one h_witness h_fibre

/-- **Target 2 — the frozen row's statement, byte-identical, via the
Φ-conversion** (RESISTED; rides the dictionary's receipt). The root's
`ASection.transportLevel_placement` (Theorem.lean) is untouched. -/
theorem transportLevel_placement_via_phi (A : ASection) (n m : ℕ) :
    A.transportLevel n = A.transportLevel m := by
  obtain ⟨c, hc⟩ := A.nontrivial_one_centre_via_phi
  exact (hc n).trans (hc m).symm

end ASection
