import Concentricity.ASectionActionDiagram

open CategoryTheory

namespace ASection

/-!
This audit imports the accepted action diagram through its canonical
dependency chain:

`ASectionEquivariant` → `ASectionFunctor` → `ASectionActionDiagram`.

It does not import the auxiliary `ASectionGenerated` or `ASectionAction`
modules.
-/

#check AsectionActionState.ofCoordinate
#check AsectionActionState_ofInput_input
#check AsectionActionState_ofInput_positioned
#check AsectionActionState_ofInput_value
#check AsectionActionTransport_obj_input
#check AsectionActionTransport_obj_positioned
#check AsectionActionTransport_obj_value
#check AsectionActionOutput

#print axioms ASection.AsectionActionState.ofCoordinate
#print axioms ASection.ActionTransportSquare.actionStateTransport
#print axioms ASection.AsectionActionTransport_id
#print axioms ASection.AsectionActionTransport_comp
#print axioms ASection.AsectionActionDiagram
#print axioms ASection.AsectionActionOutput_eq

end ASection
