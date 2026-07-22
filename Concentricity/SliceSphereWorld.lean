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
import Concentricity.G2
import Concentricity.ZeroSpheres
import Mathlib.Analysis.SpecialFunctions.Complex.Circle
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

/-! ## §3 — The native realization of each sphere world

`SphereWorld` uses a unit imaginary direction as the index of the
corresponding slice Riemann sphere.  The chart below is the certified
identification of that represented object with its actual carrier in
`OnePoint Octonion`.  It also turns every `SphereHom.mob` into an honest
map of the represented source sphere to the represented target sphere.
-/

/-- The compactified slice chart of the sphere world indexed by `v`. -/
def spherePt (v : Octonion) : OnePoint ℂ → OnePoint Octonion :=
  OnePoint.map (sliceEmbed v)

@[simp] theorem spherePt_infty (v : Octonion) :
    spherePt v OnePoint.infty = OnePoint.infty := rfl

@[simp] theorem spherePt_coe (v : Octonion) (ζ : ℂ) :
    spherePt v (ζ : OnePoint ℂ) =
      ((sliceEmbed v ζ : Octonion) : OnePoint Octonion) := rfl

/-- The slice chart is faithful along a unit imaginary direction. -/
theorem sliceEmbed_injective {v : Octonion} (hv : v ∈ unitImaginarySphere) :
    Function.Injective (sliceEmbed v) := by
  intro ζ ζ' h
  have hre : ζ.re = ζ'.re := by
    have h' := congrArg re h
    rwa [re_sliceEmbed hv, re_sliceEmbed hv] at h'
  have him' : ζ.im • v = ζ'.im • v := by
    have h' := congrArg im h
    rwa [im_sliceEmbed hv, im_sliceEmbed hv] at h'
  have him : ζ.im = ζ'.im := by
    by_contra hne
    have hsub : (ζ.im - ζ'.im) • v = 0 := by
      rw [sub_smul, him', sub_self]
    have hv0 : v = 0 := by
      have h1 := congrArg (fun t => (ζ.im - ζ'.im)⁻¹ • t) hsub
      simpa [smul_smul, inv_mul_cancel₀ (sub_ne_zero.mpr hne)] using h1
    have hunit := hv.2
    rw [hv0, normSq_zero] at hunit
    norm_num at hunit
  exact Complex.ext hre him

/-- The compactified chart is injective. -/
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

/-- The chart image is exactly the represented slice Riemann sphere. -/
theorem range_spherePt (v : Octonion) :
    Set.range (spherePt v) = sliceSphere v := by
  ext q
  constructor
  · rintro ⟨z, rfl⟩
    induction z using OnePoint.rec with
    | infty => exact Set.mem_insert _ _
    | coe ζ =>
        exact Set.mem_insert_of_mem _
          ⟨sliceEmbed v ζ, ⟨ζ, rfl⟩, rfl⟩
  · intro hq
    rcases Set.mem_insert_iff.mp hq with rfl | ⟨x, ⟨ζ, rfl⟩, rfl⟩
    · exact ⟨OnePoint.infty, rfl⟩
    · exact ⟨(ζ : OnePoint ℂ), rfl⟩

/-- A unit imaginary octonion has unit self-inner-product. -/
theorem innerO_self_of_unit {v : Octonion} (hv : v ∈ unitImaginarySphere) :
    innerO v v = 1 := by
  have h2 : v + v = (2 : ℝ) • v := by rw [two_smul]
  rw [innerO, h2, normSq_smul, hv.2]
  norm_num

/-- The inverse chart coordinate on the represented sphere. -/
def coordAt (v : Octonion) : OnePoint Octonion → OnePoint ℂ :=
  OnePoint.map fun x => ⟨re x, innerO (im x) v⟩

@[simp] theorem coordAt_infty (v : Octonion) :
    coordAt v OnePoint.infty = OnePoint.infty := rfl

@[simp] theorem coordAt_coe (v : Octonion) (x : Octonion) :
    coordAt v (x : OnePoint Octonion) =
      ((⟨re x, innerO (im x) v⟩ : ℂ) : OnePoint ℂ) := rfl

/-- Coordinate-chart round trip. -/
@[simp] theorem coordAt_spherePt {v : Octonion}
    (hv : v ∈ unitImaginarySphere) (z : OnePoint ℂ) :
    coordAt v (spherePt v z) = z := by
  induction z using OnePoint.rec with
  | infty => rfl
  | coe ζ =>
      rw [spherePt_coe, coordAt_coe, OnePoint.coe_eq_coe]
      apply Complex.ext
      · exact re_sliceEmbed hv ζ
      · show innerO (im (sliceEmbed v ζ)) v = ζ.im
        rw [im_sliceEmbed hv, innerO_smul_left,
          innerO_self_of_unit hv, _root_.mul_one]

/-- Chart-coordinate round trip on the represented sphere. -/
@[simp] theorem spherePt_coordAt {v : Octonion}
    (hv : v ∈ unitImaginarySphere) {q : OnePoint Octonion}
    (hq : q ∈ sliceSphere v) :
    spherePt v (coordAt v q) = q := by
  rw [← range_spherePt] at hq
  obtain ⟨z, rfl⟩ := hq
  rw [coordAt_spherePt hv]

/-- The sphere charts are equivariant under the direction action. -/
theorem smul_spherePt (g : G2) (v : Octonion) (z : OnePoint ℂ) :
    g • spherePt v z = spherePt (g • v) z := by
  induction z using OnePoint.rec with
  | infty => rfl
  | coe ζ =>
      rw [spherePt_coe, spherePt_coe,
        G2.smul_onePoint_coe, G2.smul_sliceEmbed]

/-- The direction action carries each represented sphere to its target. -/
theorem smul_mem_sliceSphere {v : Octonion} {q : OnePoint Octonion}
    (g : G2) (hq : q ∈ sliceSphere v) :
    g • q ∈ sliceSphere (g • v) := by
  rw [← range_spherePt] at hq
  obtain ⟨z, rfl⟩ := hq
  rw [smul_spherePt, ← range_spherePt]
  exact ⟨z, rfl⟩

/-- A chart point of a represented sphere, packaged in its carrier. -/
def sphereChartPoint (I : SphereWorld) (z : OnePoint ℂ) :
    ↑(Octonion.sliceSphere I.val) :=
  ⟨spherePt I.val z, by
    rw [← range_spherePt]
    exact ⟨z, rfl⟩⟩

/-- The genuine point-map represented by a `SphereWorld` morphism.
The Möbius leg acts in the source chart and the result lands in the target
slice sphere; the direction leg identifies that target chart geometrically. -/
def SphereHom.realize {I J : SphereWorld} (f : I ⟶ J)
    (q : ↑(Octonion.sliceSphere I.val)) :
    ↑(Octonion.sliceSphere J.val) :=
  ⟨spherePt J.val (f.mob.val (coordAt I.val q.val)), by
    rw [← range_spherePt]
    exact ⟨f.mob.val (coordAt I.val q.val), rfl⟩⟩

/-- On chart points, `SphereHom.realize` is exactly the Möbius action. -/
@[simp] theorem SphereHom.realize_sphereChartPoint
    {I J : SphereWorld} (f : I ⟶ J) (z : OnePoint ℂ) :
    (f.realize (sphereChartPoint I z)).val =
      spherePt J.val (f.mob.val z) := by
  change spherePt J.val
      (f.mob.val (coordAt I.val (spherePt I.val z))) =
    spherePt J.val (f.mob.val z)
  rw [coordAt_spherePt I.prop]

/-- The realized target chart agrees with the direction relabelling. -/
theorem SphereHom.realize_sphereChartPoint_eq_rot
    {I J : SphereWorld} (f : I ⟶ J) (z : OnePoint ℂ) :
    (f.realize (sphereChartPoint I z)).val =
      f.rot • spherePt I.val (f.mob.val z) := by
  rw [SphereHom.realize_sphereChartPoint, smul_spherePt, f.rot_eq]

/-- Identity morphisms realize as identity maps of the represented sphere. -/
@[simp] theorem SphereHom.realize_id (I : SphereWorld)
    (q : ↑(Octonion.sliceSphere I.val)) :
    SphereHom.realize (𝟙 I) q = q := by
  apply Subtype.ext
  change spherePt I.val (coordAt I.val q.val) = q.val
  exact spherePt_coordAt I.prop q.prop

/-- Composition in `SphereWorld` realizes as composition of point maps. -/
theorem SphereHom.realize_comp {I J K : SphereWorld}
    (f : I ⟶ J) (g : J ⟶ K)
    (q : ↑(Octonion.sliceSphere I.val)) :
    SphereHom.realize (f ≫ g) q =
      SphereHom.realize g (SphereHom.realize f q) := by
  apply Subtype.ext
  change spherePt K.val
      ((g.mob * f.mob).val (coordAt I.val q.val)) =
    spherePt K.val
      (g.mob.val (coordAt J.val
        (spherePt J.val (f.mob.val (coordAt I.val q.val)))))
  rw [coordAt_spherePt J.prop]
  rfl

end
