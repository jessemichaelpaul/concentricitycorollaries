/-
Concentricity/SliceSphereWorld.lean

THE TRUE 𝒮₂ — the slice-sphere world (author's dictation of record,
DESIGN_S2_slice_world_2026-07-07.md, with the author's correction of
2026-07-07: THE GPV BASE IS ON THE GREAT CIRCLE — the base 𝓑 lives on the
ONE circle S¹ = ℝ ∪ {N}, shared by every world of the round trip; the
2-spheres COME FROM the circle, glued along it; the cargo attaches to THE
CIRCLE, not per-sphere; the original cone/witness argument runs essentially
unchanged on the corrected object).

The rendered `S2` (TwoWorlds.lean — a point-level quotient) is NOT the
author's 𝒮₂; every categorical argument run on it ran on the wrong range
object. This file builds the object the author dictated:

  • OBJECTS: the slice Riemann spheres S²_I, one for EVERY unit imaginary
    octonion I ∈ S⁶ (`SphereWorld`), each realized on `sliceSphere I` via
    the chart `spherePt I` (the compactified `sliceEmbed`).
  • MORPHISMS: each sphere's own Möbius self-maps (`Moebius`, the honest
    Möbius transformation group of the Riemann sphere — the image of
    GL(2,ℂ) in Perm(ℂ∪{∞}), Mathlib's `OnePoint.instGLAction`), the band
    U(1) phases among them (`bandMoebiusHom`), and the direction G₂ maps
    between spheres (`dirHom`). A GROUPOID (`instGroupoidSphereWorld`).
  • THE ONE GREAT CIRCLE: S¹ = ℝ ∪ {N} is the SAME circle in every sphere
    (`oneGreatCircle_subset_sliceSphere`, `spherePt_image_stdCircle`), it
    is exactly the pairwise intersection of independent spheres
    (`sliceSphere_inter'`) and exactly the G₂-fixed locus
    (`oneGreatCircle_eq_fixedLocus`); its carrier IS the compactified base
    𝓑^𝔫 = OnePoint ℝ (`circleBase` — levels + the one N).
  • Φ AT SPHERE LEVEL: the A-section carries each sphere into itself BY
    DEFINITION (def:R, `realize_mem_sliceSphere`) — the self-map datum
    `ASection.sphereMap`, G₂-equivariant (Wang Rem 2.11,
    `realize_equivariant`; the square `sphereMap_dir_natural`).
  • THE GPV BASE ON THE CIRCLE: the degenerate fibre of each world hangs
    off the circle at the single level log r (`exp_slice_fibre_iff`,
    `exp_slice_fibre_level`, `exp_slice_fibre_band` — lem:exp-degenerate
    read in the world's chart), the level point lies ON the circle
    (`fibre_level_mem_circle`) and is the SAME point for all worlds
    (`fibre_level_shared`, the circle being pointwise G₂-fixed).
  • THE ROUND TRIP (the functorial airplane): 𝕆* → 𝒮₂ → 𝕆* — takeoff
    `sphereOfPt`/`takeoff`, the section's action in the slice world,
    landing by the sphere's inclusion; the composite IS the realization
    (`flight_eq_realize`), and the one circle is closed under the whole
    trip (`flight_mem_oneGreatCircle`).
  • THE ORIGINAL ARGUMENT ON THE CORRECTED OBJECT: the glued transport
    𝒯 = ∫_{𝓑^𝔫} (const 𝒮₂) (`GluedTransport`) — base = the circle with
    its closing arrows c ⟶ 𝔫 (C1's cone through the one N), fibre = the
    true sphere world (the band lives inside it, `bandToWorld`; the frozen
    𝒯^𝔫 maps into it, `transportToGlued`). The cone/witness pattern of the
    frozen `concentricity_transport` runs verbatim
    (`ASection.glued_concentricity_transport`), and the static dictionary
    reads one component = one level = one point of the circle
    (`staticLevelClass`).

Import discipline: only root-imported (green) modules are consumed —
TransportObject (the frozen carrier and BaseC), ZeroSpheres (the B6 sphere
geometry) — plus Mathlib. The sorried working artifacts (GreatCircleRoute,
LoopAssembly, PhiConversion, …) are NOT imported; the few of their PROVED
rows this file needs are re-derived here, cited row-by-row. Nothing in
this file consumes `ASection.concentricity`, `transportLevel_placement`,
or `placement_set` — no row below rides the open node.

NO sorried declaration in this file (the author's binding rule for this
build: helpers never sorried, receipts never landed — any resistance is
prose in the run report, never a Lean row). `sorry` marks UNFORMALIZED,
never UNSOUND (R8); this file carries NONE.
-/
import Concentricity.TransportObject
import Concentricity.ZeroSpheres
import Mathlib.Topology.Compactification.OnePoint.ProjectiveLine

noncomputable section

open CategoryTheory Octonion

/-! ## §1 — The Möbius group of the standard slice Riemann sphere

Each slice Riemann sphere S²_I = ℂ_I ∪ {N} is chart-identified with the
standard Riemann sphere `OnePoint ℂ` (master `def:slices`: the ℝ-algebra
isomorphism φ_v : ℂ → ℂ_v). Its Möbius transformation self-maps are the
fractional-linear bijections — the image of GL(2,ℂ) acting on `OnePoint ℂ`
through ℙ¹(ℂ) (Mathlib `OnePoint.instGLAction`,
Mathlib/Topology/Compactification/OnePoint/ProjectiveLine.lean — R5
verified against the pin; the action factors through PGL(2,ℂ), the
classical Möbius group, and taking the image in Perm(ℂ∪{∞}) quotients the
scalars away, so the elements below ARE the Möbius self-maps). -/

/-- **The Möbius group** of the standard Riemann sphere: the image of
GL(2,ℂ) in the self-bijections of ℂ ∪ {∞} — the honest group of Möbius
transformation self-maps (PGL(2,ℂ) as maps). -/
def Moebius : Subgroup (Equiv.Perm (OnePoint ℂ)) :=
  (MulAction.toPermHom (GL (Fin 2) ℂ) (OnePoint ℂ)).range

/-- The Möbius map of a matrix. -/
def Moebius.of (g : GL (Fin 2) ℂ) : Moebius :=
  ⟨MulAction.toPermHom (GL (Fin 2) ℂ) (OnePoint ℂ) g, ⟨g, rfl⟩⟩

theorem Moebius.of_apply (g : GL (Fin 2) ℂ) (z : OnePoint ℂ) :
    (Moebius.of g).val z = g • z := rfl

/-- The band matrix of a phase c ∈ U(1): diag(c, 1). The band U(1) of
master `def:two-worlds` ("the phases u_θ : z ↦ e^{Iθ}z — the Möbius
self-maps of S²_I fixing the value-origin 0, the point at infinity N, and
the modulus") sits inside the Möbius group through it. -/
def bandGL (c : Circle) : GL (Fin 2) ℂ :=
  Matrix.GeneralLinearGroup.mkOfDetNeZero !![(c : ℂ), 0; 0, 1] (by
    rw [Matrix.det_fin_two_of]
    simp)

theorem bandGL_val (c : Circle) : (bandGL c).val = !![(c : ℂ), 0; 0, 1] := rfl

/-- The band phase as a Möbius self-map. -/
def bandMoebius (c : Circle) : Moebius := Moebius.of (bandGL c)

/-- The band's Möbius action at a finite chart point: the phase rotation
z ↦ c·z (the u_θ of master `def:two-worlds`, c = e^{iθ}). -/
theorem bandMoebius_apply_coe (c : Circle) (z : ℂ) :
    (bandMoebius c).val (z : OnePoint ℂ) = (((c : ℂ) * z : ℂ) : OnePoint ℂ) := by
  rw [bandMoebius, Moebius.of_apply, OnePoint.smul_some_eq_ite]
  have h10 : (bandGL c) 1 0 = 0 := by
    show (!![(c : ℂ), 0; 0, 1] : Matrix (Fin 2) (Fin 2) ℂ) 1 0 = 0
    simp
  have h11 : (bandGL c) 1 1 = 1 := by
    show (!![(c : ℂ), 0; 0, 1] : Matrix (Fin 2) (Fin 2) ℂ) 1 1 = 1
    simp
  have h00 : (bandGL c) 0 0 = (c : ℂ) := by
    show (!![(c : ℂ), 0; 0, 1] : Matrix (Fin 2) (Fin 2) ℂ) 0 0 = (c : ℂ)
    simp
  have h01 : (bandGL c) 0 1 = 0 := by
    show (!![(c : ℂ), 0; 0, 1] : Matrix (Fin 2) (Fin 2) ℂ) 0 1 = 0
    simp
  rw [h10, h11, h00, h01]
  norm_num

/-- The band fixes the point at infinity N (`def:two-worlds`, band
clause). -/
theorem bandMoebius_apply_infty (c : Circle) :
    (bandMoebius c).val (OnePoint.infty : OnePoint ℂ) = OnePoint.infty := by
  rw [bandMoebius, Moebius.of_apply, OnePoint.smul_infty_eq_ite]
  have h10 : (bandGL c) 1 0 = 0 := by
    show (!![(c : ℂ), 0; 0, 1] : Matrix (Fin 2) (Fin 2) ℂ) 1 0 = 0
    simp
  rw [if_pos h10]

/-- The band fixes the value-origin 0 (`def:two-worlds`, band clause). -/
theorem bandMoebius_apply_zero (c : Circle) :
    (bandMoebius c).val ((0 : ℂ) : OnePoint ℂ) = ((0 : ℂ) : OnePoint ℂ) := by
  rw [bandMoebius_apply_coe, mul_zero]

/-- The band matrix family is multiplicative at the identity (helper). -/
theorem bandGL_one : bandGL 1 = 1 := by
  apply Units.ext
  rw [bandGL_val, Circle.coe_one]
  exact (Matrix.one_fin_two).symm

/-- The band matrix family is multiplicative (helper). -/
theorem bandGL_mul (c₁ c₂ : Circle) : bandGL (c₁ * c₂) = bandGL c₁ * bandGL c₂ := by
  apply Units.ext
  show (bandGL (c₁ * c₂)).val = (bandGL c₁).val * (bandGL c₂).val
  rw [bandGL_val, bandGL_val, bandGL_val, Matrix.mul_fin_two, Circle.coe_mul]
  norm_num

/-- **U(1) lives in the Möbius group**: the band, as a homomorphism of
groups Circle →* Möbius (the "S¹ and U(1) live there too" clause of the
author's dictation). -/
def bandMoebiusHom : Circle →* Moebius where
  toFun := bandMoebius
  map_one' := by
    rw [bandMoebius, bandGL_one]
    exact Subtype.ext (map_one (MulAction.toPermHom (GL (Fin 2) ℂ) (OnePoint ℂ)))
  map_mul' c₁ c₂ := by
    rw [bandMoebius, bandGL_mul]
    exact Subtype.ext (map_mul (MulAction.toPermHom (GL (Fin 2) ℂ) (OnePoint ℂ)) _ _)

/-! ## §2 — The sphere world: the TRUE 𝒮₂ as a groupoid

Author's dictation (DESIGN_S2, verbatim): "The OBJECTS of 𝒮₂ are the slice
Riemann spheres S²_I, one for EVERY unit imaginary octonion I ∈ S⁶. Not
points. … What makes 𝒮₂ a groupoid: each S²_I carries its own Möbius
transformation self-maps; and S¹ and U(1) live there too."

A morphism I ⟶ J carries a direction datum (g ∈ G₂ with g·I = J, the
relabelling of worlds — master `def:two-worlds`, direction clause) and a
Möbius datum (a Möbius self-map, read in the source world's chart; the
chart relabelling is direction-equivariant, `smul_spherePt` below, so the
convention is presentation-robust). Composition is componentwise; every
morphism is invertible — a groupoid. -/

/-- **The objects of the TRUE 𝒮₂**: one slice Riemann sphere S²_I per unit
imaginary octonion I ∈ S⁶ (`unitImaginarySphere`). The sphere itself is
carried by `sliceSphere I` (Slice.lean) through the chart `spherePt`
below. -/
def SphereWorld : Type := {v : Octonion // v ∈ unitImaginarySphere}

/-- The morphisms of the TRUE 𝒮₂: a direction leg g : I → g·I (G₂) and a
Möbius leg (the sphere's own self-maps, band U(1) included), read in the
source chart. -/
@[ext]
structure SphereHom (I J : SphereWorld) : Type where
  /-- The direction datum: the G₂ relabelling of worlds. -/
  rot : G2
  /-- The direction leg lands in the target world. -/
  rot_eq : rot • I.val = J.val
  /-- The Möbius datum: a Möbius self-map of the sphere, in the source
  world's chart. -/
  mob : Moebius

instance : CategoryTheory.Category SphereWorld where
  Hom := SphereHom
  id I := ⟨1, one_smul G2 I.val, 1⟩
  comp φ ψ := ⟨ψ.rot * φ.rot, by rw [mul_smul, φ.rot_eq, ψ.rot_eq], ψ.mob * φ.mob⟩
  id_comp φ := by
    apply SphereHom.ext
    · exact mul_one φ.rot
    · exact mul_one φ.mob
  comp_id φ := by
    apply SphereHom.ext
    · exact one_mul φ.rot
    · exact one_mul φ.mob
  assoc φ ψ χ := by
    apply SphereHom.ext
    · exact (mul_assoc χ.rot ψ.rot φ.rot).symm
    · exact (mul_assoc χ.mob ψ.mob φ.mob).symm

theorem SphereHom.comp_rot {I J K : SphereWorld} (φ : I ⟶ J) (ψ : J ⟶ K) :
    (φ ≫ ψ).rot = ψ.rot * φ.rot := rfl

theorem SphereHom.comp_mob {I J K : SphereWorld} (φ : I ⟶ J) (ψ : J ⟶ K) :
    (φ ≫ ψ).mob = ψ.mob * φ.mob := rfl

theorem SphereHom.id_rot (I : SphereWorld) : SphereHom.rot (𝟙 I) = 1 := rfl

theorem SphereHom.id_mob (I : SphereWorld) : SphereHom.mob (𝟙 I) = 1 := rfl

/-- **𝒮₂ is a groupoid** (the author's dictation: "What makes 𝒮₂ a
groupoid: each S²_I carries its own Möbius transformation self-maps"):
every morphism inverts componentwise — G₂ and Möbius are groups. -/
instance : CategoryTheory.Groupoid SphereWorld where
  inv φ := ⟨φ.rot⁻¹, by rw [← φ.rot_eq, inv_smul_smul], φ.mob⁻¹⟩
  inv_comp φ := by
    apply SphereHom.ext
    · exact mul_inv_cancel φ.rot
    · exact mul_inv_cancel φ.mob
  comp_inv φ := by
    apply SphereHom.ext
    · exact inv_mul_cancel φ.rot
    · exact inv_mul_cancel φ.mob

/-- The direction morphism g : I → g·I of the sphere world (master
`def:two-worlds`, direction clause, now at SPHERE level: worlds
relabelled, not points moved). -/
def dirHom (g : G2) (I : SphereWorld) :
    I ⟶ (⟨g • I.val, G2.smul_mem_unitImaginarySphere g I.prop⟩ : SphereWorld) :=
  ⟨g, rfl, 1⟩

/-- A direction morphism with a prescribed target (the `eqToHom`-free
form: the target is an object with the same carrier). -/
def dirHomTo (g : G2) {I J : SphereWorld} (h : g • I.val = J.val) : I ⟶ J :=
  ⟨g, h, 1⟩

/-- The Möbius self-map morphism of a single world. -/
def mobHom (I : SphereWorld) (m : Moebius) : I ⟶ I :=
  ⟨1, one_smul G2 I.val, m⟩

/-- The band phase as a morphism of each world: u_θ ∈ 𝒮₂(I, I). -/
def bandHomAt (I : SphereWorld) (c : Circle) : I ⟶ I :=
  mobHom I (bandMoebiusHom c)

/-- **U(1) lives in every world of 𝒮₂**: the band as a monoid homomorphism
into the endomorphisms of each sphere-object. -/
def bandEnd (I : SphereWorld) : Circle →* CategoryTheory.End I where
  toFun c := bandHomAt I c
  map_one' := by
    apply SphereHom.ext
    · rfl
    · exact map_one bandMoebiusHom
  map_mul' c₁ c₂ := by
    apply SphereHom.ext
    · exact (_root_.one_mul (1 : G2)).symm
    · exact map_mul bandMoebiusHom c₁ c₂

/-- **The sphere world is connected**: any two worlds are joined by a
direction morphism — G₂ acts transitively on S⁶ (master `thm:G2-S6`,
Baez; the in-repo PROVED `G2.exists_smul_eq_of_mem_unitImaginarySphere`).
π₀(𝒮₂) is a single component: the slice Riemann spheres form ONE glued
world. -/
theorem sphereWorld_zigzag (I J : SphereWorld) : CategoryTheory.Zigzag I J := by
  obtain ⟨g, hg⟩ := G2.exists_smul_eq_of_mem_unitImaginarySphere I.prop J.prop
  exact CategoryTheory.Zigzag.of_hom (dirHomTo g hg)

/-- The basepoint world: the Cayley–Dickson unit direction (0, 1) ∈ ℍ × ℍ
(the inhabitant of S⁶, `Octonion.unitImaginarySphere_nonempty`'s
witness). -/
def baseWorld : SphereWorld :=
  ⟨((0 : Quaternion ℝ), (1 : Quaternion ℝ)),
    ⟨rfl, by simp [Octonion.normSq]⟩⟩

/-! ## §3 — The charts and the ONE great circle (the gluing geometry)

Author's dictation (verbatim): "THERE IS ONE GREAT CIRCLE IN ALL WORLDS.
The S¹ = ℝ ∪ {N} is the SAME circle in the domain 𝕆*, in every slice
Riemann sphere S²_I of 𝒮₂, and in the landed range 𝕆* — one circle shared
across every world the round trip touches." The spheres are glued along
it; the correction of 2026-07-07: all the 2-spheres COME FROM the great
circle, and the GPV base lives ON it. -/

/-- The chart of the world I: the compactified slice embedding
OnePoint ℂ → 𝕆*, ∞ ↦ N, ζ ↦ φ_I(ζ) (master `def:slices`: "Its one-point
compactification is the slice Riemann sphere ℂ_v* := ℂ_v ∪ {∞} = S²_v"). -/
def spherePt (v : Octonion) : OnePoint ℂ → OnePoint Octonion :=
  OnePoint.map (sliceEmbed v)

theorem spherePt_infty (v : Octonion) :
    spherePt v OnePoint.infty = OnePoint.infty := rfl

theorem spherePt_coe (v : Octonion) (ζ : ℂ) :
    spherePt v (ζ : OnePoint ℂ) = ((sliceEmbed v ζ : Octonion) : OnePoint Octonion) := rfl

/-- The slice embedding is injective along a unit imaginary direction
(the chart is faithful; `re_sliceEmbed`/`im_sliceEmbed` + unit length). -/
theorem sliceEmbed_injective {v : Octonion} (hv : v ∈ unitImaginarySphere) :
    Function.Injective (sliceEmbed v) := by
  intro ζ ζ' h
  have hre : ζ.re = ζ'.re := by
    have := congrArg re h
    rwa [re_sliceEmbed hv, re_sliceEmbed hv] at this
  have him' : ζ.im • v = ζ'.im • v := by
    have := congrArg im h
    rwa [im_sliceEmbed hv, im_sliceEmbed hv] at this
  have him : ζ.im = ζ'.im := by
    by_contra hne
    have hsub : (ζ.im - ζ'.im) • v = 0 := by
      rw [sub_smul, him', sub_self]
    have hv0 : v = 0 := by
      have h1 := congrArg (fun t => (ζ.im - ζ'.im)⁻¹ • t) hsub
      simpa [smul_smul, inv_mul_cancel₀ (sub_ne_zero.mpr hne)] using h1
    have := hv.2
    rw [hv0, normSq_zero] at this
    norm_num at this
  exact Complex.ext hre him

/-- The chart is injective. -/
theorem spherePt_injective {v : Octonion} (hv : v ∈ unitImaginarySphere) :
    Function.Injective (spherePt v) := by
  intro z z' h
  induction z using OnePoint.rec with
  | infty =>
    induction z' using OnePoint.rec with
    | infty => rfl
    | coe ζ' => exact absurd h.symm (OnePoint.coe_ne_infty _)
  | coe ζ =>
    induction z' using OnePoint.rec with
    | infty => exact absurd h (OnePoint.coe_ne_infty _)
    | coe ζ' =>
      rw [spherePt_coe, spherePt_coe, OnePoint.coe_eq_coe] at h
      rw [sliceEmbed_injective hv h]

/-- The chart's range is exactly the slice Riemann sphere: the world S²_I
IS the image of the standard sphere under the chart. -/
theorem range_spherePt (v : Octonion) : Set.range (spherePt v) = sliceSphere v := by
  ext q
  constructor
  · rintro ⟨z, rfl⟩
    induction z using OnePoint.rec with
    | infty => exact Set.mem_insert _ _
    | coe ζ => exact Set.mem_insert_of_mem _ ⟨sliceEmbed v ζ, ⟨ζ, rfl⟩, rfl⟩
  · intro hq
    rcases Set.mem_insert_iff.mp hq with rfl | ⟨x, ⟨ζ, rfl⟩, rfl⟩
    · exact ⟨OnePoint.infty, rfl⟩
    · exact ⟨(ζ : OnePoint ℂ), rfl⟩

/-- The inner product of a unit imaginary octonion with itself is 1 (from
the polarization definition of `innerO` and `normSq_smul`). -/
theorem innerO_self_of_unit {v : Octonion} (hv : v ∈ unitImaginarySphere) :
    innerO v v = 1 := by
  have h2 : v + v = (2 : ℝ) • v := by rw [two_smul]
  rw [innerO, h2, normSq_smul, hv.2]
  norm_num

/-- The chart coordinate read on 𝕆*: at a finite point x the pair
(re x, ⟨im x, v⟩) — the honest inverse of the chart on its world (the
signed height along the world's own direction; junk elsewhere, never
consumed off the sphere). -/
def coordAt (v : Octonion) : OnePoint Octonion → OnePoint ℂ :=
  OnePoint.map fun x => ⟨re x, innerO (im x) v⟩

theorem coordAt_infty (v : Octonion) :
    coordAt v OnePoint.infty = OnePoint.infty := rfl

theorem coordAt_coe (v : Octonion) (x : Octonion) :
    coordAt v (x : OnePoint Octonion) = ((⟨re x, innerO (im x) v⟩ : ℂ) : OnePoint ℂ) := rfl

/-- Chart round trip, coordinate side: the coordinate of a chart point is
the chart parameter (unconditional). -/
theorem coordAt_spherePt {v : Octonion} (hv : v ∈ unitImaginarySphere)
    (z : OnePoint ℂ) : coordAt v (spherePt v z) = z := by
  induction z using OnePoint.rec with
  | infty => rfl
  | coe ζ =>
    rw [spherePt_coe, coordAt_coe, OnePoint.coe_eq_coe]
    apply Complex.ext
    · exact re_sliceEmbed hv ζ
    · show innerO (im (sliceEmbed v ζ)) v = ζ.im
      rw [im_sliceEmbed hv, innerO_smul_left, innerO_self_of_unit hv, _root_.mul_one]

/-- Chart round trip, point side: on its own sphere the chart inverts the
coordinate read. -/
theorem spherePt_coordAt {v : Octonion} (hv : v ∈ unitImaginarySphere)
    {q : OnePoint Octonion} (hq : q ∈ sliceSphere v) :
    spherePt v (coordAt v q) = q := by
  rw [← range_spherePt] at hq
  obtain ⟨z, rfl⟩ := hq
  rw [coordAt_spherePt hv]

/-- The chart is direction-equivariant: g ∘ φ_I = φ_{g·I} on the whole
compactified sphere (`G2.smul_sliceEmbed`; N is G₂-fixed) — the worlds are
relabelled, the chart parameters untouched. -/
theorem smul_spherePt (g : G2) (v : Octonion) (z : OnePoint ℂ) :
    g • spherePt v z = spherePt (g • v) z := by
  induction z using OnePoint.rec with
  | infty => rfl
  | coe ζ =>
    rw [spherePt_coe, spherePt_coe, G2.smul_onePoint_coe, G2.smul_sliceEmbed]

/-- G₂ carries worlds to worlds: the sphere of I goes to the sphere of
g·I. -/
theorem smul_mem_sliceSphere {v : Octonion} {q : OnePoint Octonion} (g : G2)
    (hq : q ∈ sliceSphere v) : g • q ∈ sliceSphere (g • v) := by
  rw [← range_spherePt] at hq
  obtain ⟨z, rfl⟩ := hq
  rw [smul_spherePt, ← range_spherePt]
  exact ⟨z, rfl⟩

/-- G₂ preserves the inner product (polarization + the isometry block
`G2.smul_normSq`/`smul_add`). -/
theorem G2.smul_innerO (g : G2) (x y : Octonion) :
    innerO (g • x) (g • y) = innerO x y := by
  rw [innerO, innerO, ← G2.smul_add, G2.smul_normSq, G2.smul_normSq, G2.smul_normSq]

/-- The coordinate read is direction-equivariant: the coordinate of the
relabelled point in the relabelled world is the original coordinate
(`G2.smul_re`, `G2.smul_im`, `G2.smul_innerO`). -/
theorem coordAt_smul (g : G2) (v : Octonion) (q : OnePoint Octonion) :
    coordAt (g • v) (g • q) = coordAt v q := by
  induction q using OnePoint.rec with
  | infty => rfl
  | coe x =>
    rw [G2.smul_onePoint_coe, coordAt_coe, coordAt_coe, OnePoint.coe_eq_coe]
    apply Complex.ext
    · exact G2.smul_re g x
    · show innerO (im (g • x)) (g • v) = innerO (im x) v
      rw [G2.smul_im, G2.smul_innerO]

/-! ### The ONE great circle -/

/-- **The one great circle** S¹ = ℝ ∪ {N} ⊂ 𝕆* (master `def:carrier`,
~line 653: "ℝ ∪ {N} is one great circle through the single N"; the
author's dictation: "THERE IS ONE GREAT CIRCLE IN ALL WORLDS"). The same
set as the unimported route artifact's `greatCircle`
(GreatCircleRoute.lean), re-derived here on the clean import chain. -/
def oneGreatCircle : Set (OnePoint Octonion) :=
  insert OnePoint.infty ((↑) '' Set.range ofReal)

theorem infty_mem_oneGreatCircle :
    (OnePoint.infty : OnePoint Octonion) ∈ oneGreatCircle :=
  Set.mem_insert _ _

theorem ofReal_mem_oneGreatCircle (r : ℝ) :
    ((ofReal r : Octonion) : OnePoint Octonion) ∈ oneGreatCircle :=
  Set.mem_insert_of_mem _ ⟨ofReal r, ⟨r, rfl⟩, rfl⟩

/-- The circle lies on EVERY sphere: every world contains the one great
circle (all slices share ℝ and the single ∞ — master `def:slices`; the
gluing clause of the author's dictation). -/
theorem oneGreatCircle_subset_sliceSphere (v : Octonion) :
    oneGreatCircle ⊆ sliceSphere v := by
  rintro x hx
  rcases Set.mem_insert_iff.mp hx with rfl | ⟨y, ⟨r, rfl⟩, rfl⟩
  · exact Set.mem_insert _ _
  · exact Set.mem_insert_of_mem _
      ⟨ofReal r, ⟨(r : ℂ), sliceEmbed_ofReal v r⟩, rfl⟩

/-- The standard circle of the model sphere: ℝ ∪ {∞} ⊂ ℂ ∪ {∞}. -/
def stdCircle : Set (OnePoint ℂ) :=
  insert OnePoint.infty ((↑) '' Set.range (Complex.ofReal))

/-- **The same circle in ALL worlds**: every chart carries the standard
circle of the model sphere onto the ONE great circle — not a copy per
world, the one circle itself (`sliceEmbed_ofReal`: φ_v is the identity on
ℝ, for every v). -/
theorem spherePt_image_stdCircle (v : Octonion) :
    spherePt v '' stdCircle = oneGreatCircle := by
  ext q
  constructor
  · rintro ⟨z, hz, rfl⟩
    rcases Set.mem_insert_iff.mp hz with rfl | ⟨y, ⟨r, rfl⟩, rfl⟩
    · exact infty_mem_oneGreatCircle
    · rw [spherePt_coe, sliceEmbed_ofReal]
      exact ofReal_mem_oneGreatCircle r
  · intro hq
    rcases Set.mem_insert_iff.mp hq with rfl | ⟨y, ⟨r, rfl⟩, rfl⟩
    · exact ⟨OnePoint.infty, Set.mem_insert _ _, rfl⟩
    · refine ⟨((r : ℂ) : OnePoint ℂ),
        Set.mem_insert_of_mem _ ⟨(r : ℂ), ⟨r, rfl⟩, rfl⟩, ?_⟩
      rw [spherePt_coe, sliceEmbed_ofReal]

/-- Real-scalar rigidity on unit imaginaries: a•w = b•v with v, w units
and b ≠ 0 forces v = ±w (re-derived from the unimported route artifact's
PROVED row, GreatCircleRoute.lean `unit_smul_eq_unit_smul`). -/
theorem unit_smul_eq_unit_smul' {v w : Octonion} (hv : v ∈ unitImaginarySphere)
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

/-- **The gluing is EXACT** (the play's `lem:great-circle`, intersection
clause; re-derived from GreatCircleRoute.lean's PROVED `sliceSphere_inter`
on the clean chain): worlds of independent directions (v ≠ ±w) meet
EXACTLY in the one great circle — the spheres emanate from the circle and
share nothing else. -/
theorem sliceSphere_inter' {v w : Octonion} (hv : v ∈ unitImaginarySphere)
    (hw : w ∈ unitImaginarySphere) (hvw : v ≠ w) (hvw' : v ≠ -w) :
    sliceSphere v ∩ sliceSphere w = oneGreatCircle := by
  ext x
  constructor
  · rintro ⟨hxv, hxw⟩
    rcases Set.mem_insert_iff.mp hxv with rfl | ⟨y, ⟨ζ, rfl⟩, rfl⟩
    · exact infty_mem_oneGreatCircle
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
          rw [sliceEmbed_ofReal]
          exact ofReal_mem_oneGreatCircle σ
        · exfalso
          rcases unit_smul_eq_unit_smul' hv hw hζim him with h | h
          · exact hvw h
          · exact hvw' h
  · intro hx
    exact ⟨oneGreatCircle_subset_sliceSphere v hx,
      oneGreatCircle_subset_sliceSphere w hx⟩

/-- **The fixed locus** (the author: "G₂ fixes ℝ ∪ {∞} in 𝕆* and
everything else is imaginary"; re-derived from GreatCircleRoute.lean's
PROVED `greatCircle_eq_fixedLocus` on the clean chain): the one great
circle is precisely the G₂-fixed locus of 𝕆* — the base 𝓑 lives on a
circle every direction morphism of 𝒮₂ fixes POINTWISE. -/
theorem oneGreatCircle_eq_fixedLocus :
    oneGreatCircle = {x : OnePoint Octonion | ∀ g : G2, g • x = x} := by
  ext x
  constructor
  · intro hx g
    rcases Set.mem_insert_iff.mp hx with rfl | ⟨y, ⟨r, rfl⟩, rfl⟩
    · exact G2.smul_onePoint_infty g
    · rw [G2.smul_onePoint_coe, G2.smul_ofReal]
  · intro hfix
    by_contra hx
    induction x using OnePoint.rec with
    | infty => exact hx infty_mem_oneGreatCircle
    | coe y =>
      have hyim : im y ≠ 0 := by
        intro h0
        rw [Octonion.eq_ofReal_of_im_eq_zero h0] at hx
        exact hx (ofReal_mem_oneGreatCircle (re y))
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
        have h2 := hdir.2
        rw [h, normSq_zero] at h2
        norm_num at h2
      apply hdir0
      rw [smul_neg] at him
      have h4 : (sliceCoord y).im • dir y + (sliceCoord y).im • dir y = 0 :=
        add_eq_zero_iff_eq_neg.mpr him.symm
      have h5 : (sliceCoord y).im • dir y = 0 := by
        have h6 : (2 : ℝ) • ((sliceCoord y).im • dir y) = 0 := by
          rw [two_smul]
          exact h4
        have h7 := congrArg (fun t => (2⁻¹ : ℝ) • t) h6
        simpa [smul_smul] using h7
      have h8 := congrArg (fun t => ((sliceCoord y).im)⁻¹ • t) h5
      simpa [smul_smul, inv_mul_cancel₀ hcoord_im] using h8

/-- **The carrier of the base IS the circle** (the author's correction of
2026-07-07: "the GPV base is ON THE GREAT CIRCLE — that's it"): the
compactified base 𝓑^𝔫 = OnePoint ℝ (TransportObject.lean `BaseC` — the
levels plus the one 𝔫) is in canonical bijection with the one great
circle: level c ↔ the real point c of the circle, 𝔫 ↔ the one N. -/
def circleBase : BaseC ≃ ↥oneGreatCircle where
  toFun x :=
    OnePoint.rec ⟨OnePoint.infty, infty_mem_oneGreatCircle⟩
      (fun c => ⟨((ofReal c : Octonion) : OnePoint Octonion),
        ofReal_mem_oneGreatCircle c⟩) x
  invFun q :=
    OnePoint.rec BaseC.nPt (fun y => BaseC.lvl (re y)) q.val
  left_inv x := by
    induction x using OnePoint.rec with
    | infty => rfl
    | coe c =>
      show BaseC.lvl (re (ofReal c)) = BaseC.lvl c
      rw [re_ofReal]
  right_inv q := by
    obtain ⟨x, hx⟩ := q
    rcases Set.mem_insert_iff.mp hx with rfl | ⟨y, ⟨r, rfl⟩, rfl⟩
    · rfl
    · exact Subtype.ext (by
        show ((ofReal (re (ofReal r)) : Octonion) : OnePoint Octonion)
          = ((ofReal r : Octonion) : OnePoint Octonion)
        rw [re_ofReal])

theorem circleBase_lvl (c : ℝ) :
    (circleBase (BaseC.lvl c)).val = ((ofReal c : Octonion) : OnePoint Octonion) := rfl

theorem circleBase_nPt :
    (circleBase BaseC.nPt).val = (OnePoint.infty : OnePoint Octonion) := rfl

/-! ## The section on the world: slice preservation (green stock) and THE
LANDING — the one great circle is section-invariant -/

namespace ASection

/-- **THE LANDING ON THE BASE** (the round trip closed on the circle): the
A-section carries THE ONE GREAT CIRCLE into itself — a real point's value
is real (`real_on_real`, intrinsicality: the imaginary component of the
realization vanishes on ℝ regardless of direction), the pole goes to ∞
(still on the circle), and ∞ goes to its compactified value, real or ∞
(`valueAtInfinity`). The GPV base lives ON the circle; the circle is
section-invariant: the airplane's flight restricted to the base stays on
the base. Sphere preservation is the already-proved
`realize_mem_sliceSphere` (Slice.lean, `def:section-map`(i)) — together:
the section preserves every world AND the one circle they share. -/
theorem realize_circle_to_circle (A : ASection) {x : OnePoint Octonion}
    (hx : x ∈ oneGreatCircle) : A.realize x ∈ oneGreatCircle := by
  rcases Set.mem_insert_iff.mp hx with rfl | ⟨y, ⟨c, rfl⟩, rfl⟩
  · -- ∞ ↦ the compactified value, real or ∞ — on the circle either way
    rw [realize_infty]
    induction A.valueAtInfinity using OnePoint.rec with
    | infty =>
        simp only [OnePoint.map_infty]
        exact Set.mem_insert _ _
    | coe z =>
        simp only [OnePoint.map_some]
        exact Set.mem_insert_iff.mpr
          (Or.inr ⟨Octonion.ofReal z.re, ⟨z.re, rfl⟩, rfl⟩)
  · -- a real point ↦ its real value (or ∞ at the pole)
    rw [realize_coe]
    split_ifs with h
    · have hcoord : Octonion.sliceCoord (Octonion.ofReal c) = (c : ℂ) := by
        unfold Octonion.sliceCoord
        rw [Octonion.im_ofReal, Octonion.norm_zero, Octonion.re_ofReal]
        exact Complex.ext rfl (Complex.ofReal_im c).symm
      have him : (A.F (c : ℂ)).im = 0 := A.real_on_real c
      have hembed : Octonion.sliceEmbed (Octonion.dir (Octonion.ofReal c))
          (A.F (Octonion.sliceCoord (Octonion.ofReal c)))
          = Octonion.ofReal ((A.F (c : ℂ)).re) := by
        rw [hcoord]
        unfold Octonion.sliceEmbed
        rw [him, zero_smul, add_zero]
      rw [hembed]
      exact Set.mem_insert_iff.mpr
        (Or.inr ⟨Octonion.ofReal ((A.F (c : ℂ)).re), ⟨(A.F (c : ℂ)).re, rfl⟩, rfl⟩)
    · exact Set.mem_insert _ _

end ASection

/-! ## The round trip on the base: the flight as a self-map of 𝓑 -/

namespace ASection

/-- The circle-restricted flight: the section's action on the one great
circle, landed (via `realize_circle_to_circle`) as a self-map of the
circle's own points. -/
def circleFlight (A : ASection) (p : ↥oneGreatCircle) : ↥oneGreatCircle :=
  ⟨A.realize p.val, A.realize_circle_to_circle p.property⟩

/-- **THE ROUND TRIP ON THE BASE** (the landing readout): through
`circleBase` — the GPV base IS the one great circle — the section's
flight restricted to the circle is a self-map of the transport's base 𝓑
itself. The airplane takes off from the base, flies through the sphere
world (every world preserved, `realize_mem_sliceSphere`), and lands on
the base. -/
def baseFlight (A : ASection) : BaseC → BaseC :=
  fun b => circleBase.symm (A.circleFlight (circleBase b))

end ASection

namespace ASection

/-- The flight lands a level at its VALUE's level: at an analytic real
point c, the flight reads lvl c ↦ lvl ((F c).re) — the section's real
values steering the base (the value is real by `real_on_real`, so its
level IS its real part). -/
theorem baseFlight_lvl (A : ASection) (c : ℝ)
    (h : AnalyticAt ℂ A.F (Octonion.sliceCoord (Octonion.ofReal c))) :
    A.baseFlight (BaseC.lvl c) = BaseC.lvl ((A.F (c : ℂ)).re) := by
  unfold baseFlight circleFlight
  have hcoord : Octonion.sliceCoord (Octonion.ofReal c) = (c : ℂ) := by
    unfold Octonion.sliceCoord
    rw [Octonion.im_ofReal, Octonion.norm_zero, Octonion.re_ofReal]
    exact Complex.ext rfl (Complex.ofReal_im c).symm
  have him : (A.F (c : ℂ)).im = 0 := A.real_on_real c
  have hval : A.realize ((circleBase (BaseC.lvl c)).val)
      = ((Octonion.ofReal ((A.F (c : ℂ)).re) : Octonion) : OnePoint Octonion) := by
    rw [circleBase_lvl, realize_coe, if_pos h, hcoord]
    congr 1
    unfold Octonion.sliceEmbed
    rw [him, zero_smul, add_zero]
  simp only [hval]
  show BaseC.lvl (Octonion.re (Octonion.ofReal ((A.F (c : ℂ)).re)))
      = BaseC.lvl ((A.F (c : ℂ)).re)
  rw [Octonion.re_ofReal]

/-- The flight lands the pole at 𝔫: C1's simple pole forbids analyticity
at the pole's slice coordinate, so the realization there is ∞ — the
flight carries the pole's level to the witness point. The cone of the
transport IS the flight's landing at the pole. -/
theorem baseFlight_pole (A : ASection) :
    A.baseFlight (BaseC.lvl A.pole) = BaseC.nPt := by
  unfold baseFlight circleFlight
  have hcoord : Octonion.sliceCoord (Octonion.ofReal A.pole) = (A.pole : ℂ) := by
    unfold Octonion.sliceCoord
    rw [Octonion.im_ofReal, Octonion.norm_zero, Octonion.re_ofReal]
    exact Complex.ext rfl (Complex.ofReal_im _).symm
  have hnot : ¬ AnalyticAt ℂ A.F (Octonion.sliceCoord (Octonion.ofReal A.pole)) := by
    rw [hcoord]
    intro han
    have h0 := han.meromorphicOrderAt_nonneg
    rw [A.c1_simple] at h0
    have h1 : (0 : ℤ) ≤ (-1 : ℤ) := by exact_mod_cast h0
    norm_num at h1
  have hval : A.realize ((circleBase (BaseC.lvl A.pole)).val) = OnePoint.infty := by
    rw [circleBase_lvl, realize_coe, if_neg hnot]
  simp only [hval]
  rfl

end ASection

/-! ## THE READOUT SPEC (the author, 2026-07-07): σ MAPS TO ITSELF — σ = c
FROM THE WINDING. The level of each zero's transport datum is the flight's
FIXED datum (not a value-read): conserved along every zigzag
(`TotalObject.level_eq_of_zigzag`), closed by every lift
(`winding_loop_defect_level_zero`), one per fibre (`exp_fibre_level`).
The full airplane carries: one component through 𝔫 (`classOf_eq_nClass` /
`transport_universal`), the cone as the flight's own landing
(`baseFlight_pole`), every world and the circle preserved
(`realize_mem_sliceSphere`, `realize_circle_to_circle`), the winding
tallies at the zeros (SigmaE3/WeldW12), the fibre joins
(`zero_encounters_joined_concentric`). The readout to be driven: the one
connected component's self-mapped σ IS the one centre —
`ASection.concentricity`. -/
