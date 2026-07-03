/-
Concentricity/Slice.lean

Slice geometry on the octonions and the realization of an A-section on the
compactified 𝕆* (master `def:slices`, `def:section-map`, `rmk:compactify`) —
the bridge from the stem encoding to the two-worlds layer, consumed by the
section functor Φ (`thm:section-functor`, next increment).

Master `def:slices` (verbatim, quoted per clause below): "For any unit
imaginary octonion v ∈ S⁶, the *complex slice* is ℂ_v = {a + bv : a, b ∈ ℝ}
⊂ 𝕆. Since v² = −1, this is a subalgebra isomorphic to ℂ via the ℝ-algebra
isomorphism φ_v : ℂ → ℂ_v, i ↦ v. … Its one-point compactification is the
*slice Riemann sphere* ℂ_v* := ℂ_v ∪ {∞} = S²_v …"

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.ASection
import Concentricity.G2
import Mathlib.Analysis.SpecialFunctions.Sqrt

noncomputable section

namespace Octonion

/-- The imaginary part: "An octonion s ∈ 𝕆 decomposes as s = σ + w with
σ = re(s) ∈ ℝ and w = im(s) ∈ im(𝕆) ≅ ℝ⁷" (master, §Octonions and slices). -/
def im (x : Octonion) : Octonion := x - ofReal (re x)

/-- The Euclidean norm, from the Cayley–Dickson `normSq`. -/
def norm (x : Octonion) : ℝ := Real.sqrt (normSq x)

/-- The direction I(q) of an octonion: the unit imaginary part. Junk value 0
for real octonions — GPVwind Rem 2.1 (SOURCES/GPVwind.md): the direction has
no continuous extension to ℝ; the junk value is never consumed (the
realization formula below is direction-blind at real points because
intrinsic stems are real there). -/
def dir (x : Octonion) : Octonion := (norm (im x))⁻¹ • im x

/-- The slice coordinate of q = σ + γ·I(q): the upper-half-plane point
σ + iγ, γ = ‖im q‖ ≥ 0. -/
def sliceCoord (x : Octonion) : ℂ := ⟨re x, norm (im x)⟩

/-- φ_v (master `def:slices`): the slice embedding ℂ → ℂ_v ⊆ 𝕆, i ↦ v. -/
def sliceEmbed (v : Octonion) (z : ℂ) : Octonion := ofReal z.re + z.im • v

/-- master `def:slices`: "Since v² = −1, this is a subalgebra isomorphic to
ℂ via the ℝ-algebra isomorphism φ_v : ℂ → ℂ_v, i ↦ v" — multiplicativity of
the slice embedding. Queued (R8): distributivity + `v * v = −1`
(`sq_eq_neg_one_of_mem_unitImaginarySphere`) + scalar-multiplication
compatibility of the Cayley–Dickson product. -/
theorem sliceEmbed_mul {v : Octonion} (hv : v ∈ unitImaginarySphere) (z w : ℂ) :
    sliceEmbed v (z * w) = sliceEmbed v z * sliceEmbed v w := by
  sorry

/-- The direction of a non-real octonion is a unit imaginary octonion.
Queued (R8): `re (im x) = 0` by construction and `normSq (dir x) = 1` by
the smul-homogeneity of `normSq`. -/
theorem dir_mem_unitImaginarySphere {x : Octonion} (hx : im x ≠ 0) :
    dir x ∈ unitImaginarySphere := by
  sorry

/-- The slice Riemann sphere ℂ_v* = ℂ_v ∪ {∞} = S²_v (master `def:slices`),
as a subset of the compactified 𝕆*. "All slice spheres share the single
point at infinity, as well as the real axis." -/
def sliceSphere (v : Octonion) : Set (OnePoint Octonion) :=
  insert OnePoint.infty ((↑) '' Set.range (sliceEmbed v))

end Octonion

namespace ASection

open Classical in
/-- The **realization** of an A-section on the compactified octonions
𝕆* = S⁸ (master `def:section-map`: "A(x + Iy) = F₁(x + iy) + I·F₂(x + iy),
F₁, F₂ ℝ-valued, the same for every I ∈ S⁶"; `rmk:compactify`: the passage
to 𝕆* is a marked derivation node).

Clauses: at a finite point q, the value is φ_{I(q)}(F(σ + iγ)) when the stem
is analytic at the slice coordinate, and ∞ = N at the pole (C1: "its value
there is the point at infinity ∞ = N"); at q = ∞ it is the compactified
value datum. At real q the direction junk is never consumed: the intrinsic
stem is real there (`StemRing.real_on_real`), so the imaginary component of
the formula vanishes. -/
def realize (A : ASection) (q : OnePoint Octonion) : OnePoint Octonion :=
  OnePoint.rec
    (OnePoint.map (fun z : ℂ => Octonion.ofReal z.re) A.valueAtInfinity)
    (fun x =>
      if AnalyticAt ℂ A.F (Octonion.sliceCoord x) then
        ((Octonion.sliceEmbed (Octonion.dir x) (A.F (Octonion.sliceCoord x)) : Octonion) :
          OnePoint Octonion)
      else OnePoint.infty)
    q

/-- master `def:section-map`(i) — "*Slice preservation of values.*
A(ℂ_I*) ⊆ ℂ_I* for every I: the value at a point lies on that point's own
slice sphere (Definition def:R)." Queued (R8). -/
theorem realize_mem_sliceSphere (A : ASection) {v : Octonion}
    (hv : v ∈ Octonion.unitImaginarySphere) {q : OnePoint Octonion}
    (hq : q ∈ Octonion.sliceSphere v) :
    A.realize q ∈ Octonion.sliceSphere v := by
  sorry

/-- master `def:section-map`(ii) — "*G₂-equivariance.* For g ∈ G₂ and
non-real q = x + Iy, A(g·q) = F₁ + g(I)F₂ = g·(F₁ + I F₂) = g·A(q) …; for
q ∈ ℝ ∪ {N} both sides are G₂-fixed." Queued (R8): the one I-independent
real stem (Wang Rem. 2.11, SOURCES/Wang.md) against the G₂ slice
relabelling. -/
theorem realize_equivariant (A : ASection) (g : G2) (q : OnePoint Octonion) :
    A.realize (g • q) = g • A.realize q := by
  sorry

/-- master `def:section-map`(iii) — "*Blindness to the sphere direction.*
On a G₂-orbit S_(σ,γ) the stem coordinates (F₁, F₂)(σ + iγ) are constant; in
particular if A vanishes at one point of the orbit it vanishes on the whole
orbit (Lemma lem:residue-spheres)." Stem-level statement: the slice
coordinate is G₂-invariant. Queued (R8). -/
theorem sliceCoord_smul_invariant (g : G2) (x : Octonion) :
    Octonion.sliceCoord (g • x) = Octonion.sliceCoord x := by
  sorry

end ASection
