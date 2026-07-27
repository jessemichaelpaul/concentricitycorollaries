import Concentricity.ASectionCResidue

namespace ASection

/-!
Focused kernel receipt for the semantic C3--C4 residue-`ℂ` zero locus.

No inverse-image groupoid or preservation theorem is imported or declared.
-/

#check CResidueZeroLocus
#check mem_CResidueZeroLocus_iff
#check sphereZero_mem_CResidueZeroLocus
#check mem_CResidueZeroLocus_iff_exists_sphereZero
#check CResidueZeroLocus_eq_range
#check CResidueZeroLocus_infinite

example (A : ASection) (z : ℂ) :
    z ∈ A.CResidueZeroLocus ↔ A.F z = 0 ∧ 0 < z.im :=
  A.mem_CResidueZeroLocus_iff z

#print axioms ASection.CResidueZeroLocus
#print axioms ASection.mem_CResidueZeroLocus_iff
#print axioms ASection.sphereZero_mem_CResidueZeroLocus
#print axioms ASection.mem_CResidueZeroLocus_iff_exists_sphereZero
#print axioms ASection.CResidueZeroLocus_eq_range
#print axioms ASection.CResidueZeroLocus_infinite

end ASection
