/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.StemFactorization

/-!
# The semantic C-residue zero locus

This file names only the intrinsic upper-half-plane zero locus supplied by
C3 and made infinite by C4.  It does not form an inverse-image groupoid,
restrict `AsectionActionDiagram`, or assert preservation under its arrows.
Those are the next gate.

The locus is defined by the A-section equation itself.  The sphere-zero
enumeration appears only in theorems proving that C3 is complete for this
semantic definition; it does not populate the carrier.
-/

noncomputable section

namespace ASection

/-- The intrinsic nontrivial residue-`ℂ` zero locus of an A-section. -/
def CResidueZeroLocus (A : ASection) : Set ℂ :=
  {z | A.F z = 0 ∧ 0 < z.im}

@[simp] theorem mem_CResidueZeroLocus_iff (A : ASection) (z : ℂ) :
    z ∈ A.CResidueZeroLocus ↔ A.F z = 0 ∧ 0 < z.im :=
  Iff.rfl

/-- Every C3 sphere-zero belongs to the semantic residue locus. -/
theorem sphereZero_mem_CResidueZeroLocus (A : ASection) (n : ℕ) :
    A.sphereZero n ∈ A.CResidueZeroLocus :=
  ⟨A.stem_zero_of_sphereZero n, A.c3_sphere_nonreal n⟩

/-- C3 is complete for the semantic residue locus: every member is one of
the intrinsic sphere-zeros. -/
theorem mem_CResidueZeroLocus_iff_exists_sphereZero
    (A : ASection) (z : ℂ) :
    z ∈ A.CResidueZeroLocus ↔ ∃ n, A.sphereZero n = z := by
  constructor
  · intro hz
    exact A.sphereZero_complete hz.1 hz.2
  · rintro ⟨n, rfl⟩
    exact A.sphereZero_mem_CResidueZeroLocus n

/-- The semantic locus is exactly the C3 divisor supplied by the A-section.
This is a characterization of the semantically defined set, not its
construction from an index. -/
theorem CResidueZeroLocus_eq_range (A : ASection) :
    A.CResidueZeroLocus = Set.range A.sphereZero := by
  ext z
  exact A.mem_CResidueZeroLocus_iff_exists_sphereZero z

/-- C4 makes the semantic C-residue locus infinite. -/
theorem CResidueZeroLocus_infinite (A : ASection) :
    A.CResidueZeroLocus.Infinite := by
  rw [A.CResidueZeroLocus_eq_range]
  exact A.c4_infinite

end ASection
