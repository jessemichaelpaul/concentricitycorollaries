import Concentricity.ASectionActionDiagram

open CategoryTheory

namespace ASection

/-! Kernel receipt for the four-part geometric walk-around. -/

#check H1
#check AsectionState.input
#check AsectionState.output
#check AsectionEquivariant
#check AsectionState_input_then_equivariant

#check distinguishedPoleFactor_euler
#check distinguishedPoleFactor_weierstrass
#check eulerPrimeSum
#check eulerDiskAction_eq_value
#check distinguishedDiskAction_eq_fullMultiplier
#check distinguishedDiskAction_fixes_cayley_zero
#check distinguishedDiskAction_fixes_cayley_N

#check GpvTransport.lift_endpoint_re_eq
#check GpvTransport.level
#check GpvTransport.lift_unique
#check GpvTransport.level_independent
#check AsectionGpvLift.winding
#check canonicalAsectionPresentation_euler_toNorth
#check canonicalAsectionPresentation_gpv_action
#check canonicalAsectionPresentation_gpv_unique

#check GreatCircle.orbit_stabilizer_factor
#check GreatCircle.stabilizerPart_unique
#check GreatCircle.stabilizerPart_id
#check GreatCircle.stabilizerPart_comp
#check projectiveArrowElement_id
#check projectiveArrowElement_comp
#check ActionTransportSquare
#check projectiveGpvActionSquare
#check projectiveGpvActionSquare_level

#check G2.exists_smul_eq_of_mem_unitImaginarySphere
#check smul_spherePt
#check AsectionActionState.ofCoordinate

#print axioms ASection.AsectionState_input_then_equivariant
#print axioms ASection.distinguishedPoleFactor_euler
#print axioms ASection.distinguishedPoleFactor_weierstrass
#print axioms ASection.eulerDiskAction_eq_value
#print axioms ASection.distinguishedDiskAction_fixes_cayley_zero
#print axioms ASection.distinguishedDiskAction_fixes_cayley_N
#print axioms ASection.GpvTransport.lift_endpoint_re_eq
#print axioms ASection.GpvTransport.level
#print axioms ASection.GpvTransport.lift_unique
#print axioms ASection.GpvTransport.level_independent
#print axioms ASection.canonicalAsectionPresentation_euler_toNorth
#print axioms ASection.canonicalAsectionPresentation_gpv_unique
#print axioms GreatCircle.orbit_stabilizer_factor
#print axioms GreatCircle.stabilizerPart_unique
#print axioms GreatCircle.stabilizerPart_comp
#print axioms ASection.projectiveArrowElement_comp
#print axioms ASection.projectiveGpvActionSquare
#print axioms ASection.projectiveGpvActionSquare_level
#print axioms G2.exists_smul_eq_of_mem_unitImaginarySphere
#print axioms smul_spherePt
#print axioms ASection.AsectionActionState.ofCoordinate

end ASection
