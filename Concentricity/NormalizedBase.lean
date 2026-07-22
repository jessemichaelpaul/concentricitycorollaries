/-
Concentricity/NormalizedBase.lean

Step 1 of the normalized section construction: the compactified circle and
its zero-sphere objects. This is deliberately separate from the older
non-singular GPV transport base. The carrier is the locked projective great
circle `GreatCircle.Point = OnePoint ℝ`, including the common compactified
point N.
-/
import Concentricity.ProjectiveBase
import Concentricity.SliceSphereWorld
import Concentricity.InboxWire

noncomputable section

namespace ASection

/-- The full compactified great-circle base of the normalized section action.
Unlike `A.Base`, no finite-value or nonzero restriction is imposed here. -/
abbrev NormalizedCircleBase := GreatCircle.Point

/-- The real-circle footpoint at a finite real label. -/
def normalizedFootpoint (x : ℝ) : NormalizedCircleBase := (x : OnePoint ℝ)

/-- A normalized C-residue zero object consists of its index, an arbitrary
slice sphere from the continuum of worlds, and its common real-circle
footpoint. The same label occurs in every world because all slice spheres
share the compactified real circle. -/
structure NormalizedZeroObject (A : ASection) where
  index : ℕ
  world : SphereWorld
  footpoint : NormalizedCircleBase
  label : ℝ
  footpoint_label : footpoint = normalizedFootpoint label
  label_zero : label = (A.sphereZero index).re

/-- The normalized zero object in a chosen slice world. Varying `world`
sweeps the entire normalized slice-sphere family while preserving the one
real-circle label. -/
def normalizedZero (A : ASection) (n : ℕ) (I : SphereWorld) :
    NormalizedZeroObject A where
  index := n
  world := I
  footpoint := normalizedFootpoint ((A.sphereZero n).re)
  label := (A.sphereZero n).re
  footpoint_label := rfl
  label_zero := rfl

@[simp] theorem normalizedZero_index (A : ASection) (n : ℕ) (I : SphereWorld) :
    (A.normalizedZero n I).index = n := rfl

@[simp] theorem normalizedZero_label (A : ASection) (n : ℕ) (I : SphereWorld) :
    (A.normalizedZero n I).label = (A.sphereZero n).re := rfl

@[simp] theorem normalizedZero_footpoint (A : ASection) (n : ℕ) (I : SphereWorld) :
    (A.normalizedZero n I).footpoint = normalizedFootpoint ((A.sphereZero n).re) := rfl

/-- The zero label is independent of the slice-world choice: it is the one
point of the great circle shared by every normalized Riemann sphere. -/
theorem normalizedZero_label_world_independent (A : ASection) (n : ℕ)
    (I J : SphereWorld) :
    (A.normalizedZero n I).label = (A.normalizedZero n J).label := rfl

/-- The underlying octonionic point of the real label is likewise independent
of the chosen slice direction. -/
theorem normalizedZero_on_shared_circle (A : ASection) (n : ℕ)
    (I J : SphereWorld) :
  Octonion.sliceEmbed I.val (((A.normalizedZero n I).label : ℝ) : ℂ) =
      Octonion.sliceEmbed J.val (((A.normalizedZero n J).label : ℝ) : ℂ) := by
  rw [normalizedZero_label, normalizedZero_label]
  rw [Octonion.sliceEmbed_ofReal, Octonion.sliceEmbed_ofReal]

/-- The actual point of the n-th C-residue sphere in the slice world `I`.
As `I` ranges over `SphereWorld`, these are the points of the normalized
octonionic zero sphere. -/
def normalizedZeroLift (A : ASection) (n : ℕ) (I : SphereWorld) : Octonion :=
  Octonion.sliceEmbed I.val (A.sphereZero n)

/-- The compactified form of a normalized zero-sphere point. -/
def normalizedZeroPoint (A : ASection) (n : ℕ) (I : SphereWorld) :
    OnePoint Octonion := (A.normalizedZeroLift n I : OnePoint Octonion)

/-- The normalized zero point lies in the chosen slice Riemann sphere. -/
theorem normalizedZeroPoint_mem_sliceSphere (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    A.normalizedZeroPoint n I ∈ Octonion.sliceSphere I.val := by
  apply Set.mem_insert_of_mem
  refine ⟨A.normalizedZeroLift n I, ?_, rfl⟩
  exact ⟨A.sphereZero n, rfl⟩

/-- Normalization retains the real label: the real coordinate of every
slice realization of the zero sphere is `Re (sphereZero n)`. -/
theorem normalizedZeroLift_re (A : ASection) (n : ℕ) (I : SphereWorld) :
    Octonion.re (A.normalizedZeroLift n I) = (A.sphereZero n).re := by
  exact Octonion.re_sliceEmbed I.prop _

/-- The section's actual normalized action at a zero-sphere point.  Slice
preservation keeps this value in the same normalized Riemann sphere. -/
def normalizedSectionPoint (A : ASection) (n : ℕ) (I : SphereWorld) :
    OnePoint Octonion := A.realize (A.normalizedZeroPoint n I)

theorem normalizedSectionPoint_mem_sliceSphere (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    A.normalizedSectionPoint n I ∈ Octonion.sliceSphere I.val :=
  A.realize_mem_sliceSphere I.prop (A.normalizedZeroPoint_mem_sliceSphere n I)

end ASection

/-! ## The rivers meet (the author's clauses, 2026-07-11)

"Each sphere carries its own Möbius self-maps and all spheres meet at N" —
the worlds share the one great circle exactly (`sliceEmbed_ofReal`: on the
circle the readings COINCIDE), and off the circle two worlds' readings of
the same chart point differ by exactly `z.im • (I − J)`: the divergence is
linear in the distance to the circle. "All the C-residue spheres get
arbitrarily close together and so collapse at N itself": the norm of every
slice realization is world-independent (`= ‖ρ_n‖`), so the green march
`sphereZero_norm_tendsto_atTop` (InboxWire) carries EVERY world's
realization past every ball simultaneously. -/

namespace Octonion

/-- Scaling of the octonionic norm (the general form of `norm_smul_unit`). -/
theorem norm_smul (r : ℝ) (x : Octonion) : norm (r • x) = |r| * norm x := by
  rw [norm, norm, normSq_smul, Real.sqrt_mul (sq_nonneg r), Real.sqrt_sq_eq_abs]

/-- **The sphere continuum collapses onto the one great circle**: two worlds'
readings of the same chart point differ by exactly `|Im z|` times the
directions' separation — at `Im z = 0` the worlds coincide
(`sliceEmbed_ofReal`), and the divergence off the circle is linear in the
distance to it. -/
theorem norm_sliceEmbed_sub_sliceEmbed (z : ℂ) (I J : Octonion) :
    norm (sliceEmbed I z - sliceEmbed J z) = |z.im| * norm (I - J) := by
  rw [sliceEmbed, sliceEmbed, add_sub_add_left_eq_sub, ← smul_sub, norm_smul]

/-- The octonionic norm of a slice realization is the complex modulus —
independent of the world. -/
theorem norm_sliceEmbed {v : Octonion} (hv : v ∈ unitImaginarySphere) (ζ : ℂ) :
    norm (sliceEmbed v ζ) = ‖ζ‖ := by
  rw [norm, normSq_sliceEmbed hv, Complex.norm_def, Complex.normSq_apply]
  congr 1
  ring

end Octonion

namespace ASection

/-- The collapse datum is world-independent: the norm of the n-th normalized
zero point is `‖ρ_n‖` in EVERY world. -/
theorem normalizedZeroLift_norm (A : ASection) (n : ℕ) (I : SphereWorld) :
    Octonion.norm (A.normalizedZeroLift n I) = ‖A.sphereZero n‖ :=
  Octonion.norm_sliceEmbed I.prop _

/-- **The C-residue spheres collapse at N, all worlds simultaneously** (the
author's clause, 2026-07-11): past every ball, every world's realization of
every sufficiently high zero — the spheres crowd the one compactified
witness together. Rides the green march `sphereZero_norm_tendsto_atTop`. -/
theorem normalizedZero_collapse_at_N (A : ASection) (R : ℝ) :
    ∀ᶠ n in Filter.atTop, ∀ I : SphereWorld,
      R < Octonion.norm (A.normalizedZeroLift n I) := by
  filter_upwards [A.sphereZero_norm_tendsto_atTop.eventually_gt_atTop R] with n hn I
  rw [A.normalizedZeroLift_norm n I]
  exact hn

end ASection
