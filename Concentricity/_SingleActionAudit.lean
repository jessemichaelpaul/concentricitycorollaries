import Concentricity.ASectionFunctor

open CategoryTheory

namespace ASection

/-!
This audit imports only the canonical functor/square module. It does not
import `ASectionGenerated`, `ASectionAction`, or the action diagram.
-/

#check AsectionState_input_then_equivariant
#check ActionTransportSquare.coordinateTransport_commutes
#check ActionTransportSquare.input_commutes
#check ActionTransportSquare.output_commutes
#check orbitStabilizerActionSquare_input_commutes
#check orbitStabilizerActionSquare_output_commutes
#check projectiveGpvActionSquare_input_commutes
#check projectiveGpvActionSquare_output_commutes

#print axioms ASection.AsectionState_input_then_equivariant
#print axioms ASection.orbitStabilizerActionSquare
#print axioms ASection.projectiveGpvActionSquare
#print axioms ASection.ActionTransportSquare.coordinateTransport_commutes
#print axioms ASection.ActionTransportSquare.output_commutes
#print axioms ASection.orbitStabilizerActionSquare_output_commutes
#print axioms ASection.projectiveGpvActionSquare_output_commutes

end ASection
