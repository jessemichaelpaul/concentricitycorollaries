import Concentricity.Theorem

noncomputable section

open CategoryTheory

namespace ASection

/-!
Local pre-flight for the open north comparison.

This first isolates the categorical tail: once the exact distinguished
pole-action comparison supplies a north loop whose transported input has
the target coordinate, `G₂` supplies precisely the remaining direction
arrow.
-/

theorem residueActionState_north_input_audit
    (A : ASection) (n : ℕ) (I : SphereWorld) :
    (residueActionState A projectiveNorth n I).input.back.coordinate =
      (A.distinguishedDiskAction⁻¹).val
        (A.sphereZero n : OnePoint ℂ) := by
  simp [residueActionState, AsectionActionState.ofInput,
    residueState, projectiveNorth, projectiveObjectFrame_north]

theorem residueActionTransport_north_input_audit
    (A : ASection) (n : ℕ) (I : SphereWorld)
    (k : projectiveNorth ⟶ projectiveNorth) :
    (((AsectionActionTransport A k).obj
        (residueActionState A projectiveNorth n I)).input.back.coordinate) =
      (GreatCircle.cayleyProjective
        (GreatCircle.stabilizerPart k).1).val
          ((A.distinguishedDiskAction⁻¹).val
            (A.sphereZero n : OnePoint ℂ)) := by
  rw [AsectionActionTransport_obj_input]
  simp [orbitStabilizerActionSquare, residueActionState,
    AsectionActionState.ofInput, residueState, projectiveNorth,
    projectiveObjectFrame_north]

theorem northFiberHom_of_coordinate_audit
    (A : ASection)
    (xN yN : AsectionActionFiber A projectiveNorth)
    (k : projectiveNorth ⟶ projectiveNorth)
    (hcoordinate :
      (((AsectionActionTransport A k).obj xN).input.back.coordinate) =
        yN.input.back.coordinate) :
    Nonempty ((AsectionActionTransport A k).obj xN ⟶ yN) := by
  let tx := (AsectionActionTransport A k).obj xN
  have key : ∀ s t : AsectionState A, s.coordinate = t.coordinate →
      ∃ g : G2, g • s = t := by
    rintro ⟨sw, sc⟩ ⟨tw, tc⟩ hc
    obtain ⟨g, hg⟩ :=
      G2.exists_smul_eq_of_mem_unitImaginarySphere sw.2 tw.2
    refine ⟨g, ?_⟩
    simp only [HSMul.hSMul, SMul.smul, AsectionState.mk.injEq]
    exact ⟨Subtype.ext hg, hc⟩
  obtain ⟨g₂, hstate⟩ := key tx.input.back yN.input.back hcoordinate
  exact ⟨InducedCategory.homMk
    (show tx.input ⟶ yN.input from ⟨g₂, hstate⟩)⟩

theorem northState_is_residueActionState_audit
    (A : ASection) (zN : AsectionActionFiber A projectiveNorth)
    (hzN : IsNorthCResidueState A zN) :
    ∃ n : ℕ, ∃ I : SphereWorld,
      zN = residueActionState A projectiveNorth n I := by
  obtain ⟨z, hz, hzcoord⟩ := hzN
  obtain ⟨n, hn⟩ :=
    (A.mem_CResidueZeroLocus_iff_exists_sphereZero z).mp hz
  let I : SphereWorld := zN.positioned.back.world
  refine ⟨n, I, ?_⟩
  have hpositioned_world :
      zN.positioned.back.world = I := rfl
  have hpositioned_coordinate :
      zN.positioned.back.coordinate =
        (A.sphereZero n : OnePoint ℂ) :=
    hzcoord.symm.trans
      (congrArg (fun w : ℂ => (w : OnePoint ℂ)) hn).symm
  have hpositioned :
      zN.positioned =
        ((A.residueState n I : AsectionState A) :
          AsectionStateWorld A) := by
    have state_eq :
        ∀ s t : AsectionState A,
          s.world = t.world →
          s.coordinate = t.coordinate →
          s = t := by
      rintro ⟨sw, sc⟩ ⟨tw, tc⟩ hw hc
      cases hw
      cases hc
      rfl
    rw [← CategoryTheory.ActionCategory.back_coe zN.positioned]
    apply congrArg
    exact state_eq _ _ hpositioned_world hpositioned_coordinate
  have hinput :
      zN.input =
        (coordinateTransport A
          (projectiveObjectFrame A projectiveNorth)⁻¹).obj
            ((A.residueState n I : AsectionState A) :
              AsectionStateWorld A) := by
    have hgraph := zN.positioned_by_action
    rw [hpositioned] at hgraph
    have hinv := congrArg
      (fun y => (coordinateTransport A
        (projectiveObjectFrame A projectiveNorth)⁻¹).obj y) hgraph
    calc
      zN.input =
          (coordinateTransport A
            (projectiveObjectFrame A projectiveNorth)⁻¹).obj
              ((coordinateTransport A
                (projectiveObjectFrame A projectiveNorth)).obj
                  zN.input) := by
            change zN.input =
              ((coordinateTransport A
                (projectiveObjectFrame A projectiveNorth) ⋙
                coordinateTransport A
                  (projectiveObjectFrame A projectiveNorth)⁻¹).obj
                    zN.input)
            rw [coordinateTransport_mul]
            simp [coordinateTransport_one]
      _ = (coordinateTransport A
            (projectiveObjectFrame A projectiveNorth)⁻¹).obj
              ((A.residueState n I : AsectionState A) :
                AsectionStateWorld A) := hinv.symm
  apply AsectionActionState.ext
  · exact hinput
  · simpa only [residueActionState_positioned] using hpositioned
  · rw [zN.value_realized,
      (residueActionState A projectiveNorth n I).value_realized,
      residueActionState_positioned, hpositioned]

/-!
The exact relative-loop calculation from the master proof.  No generic
transitivity assertion enters: `kE` and `kW` are the two supplied faces
from the same source, and the common source orbit representative cancels.
-/

theorem northRelativeLoop_stabilizer_audit {X : GreatCircle.Base}
    (kE kW : X ⟶ projectiveNorth) :
    GreatCircle.stabilizerPart
        (CategoryTheory.Groupoid.inv kE ≫ kW) =
      GreatCircle.stabilizerPart kW *
        (GreatCircle.stabilizerPart kE)⁻¹ := by
  rw [GreatCircle.stabilizerPart_comp]
  have hinv :
      GreatCircle.stabilizerPart (CategoryTheory.Groupoid.inv kE) =
        (GreatCircle.stabilizerPart kE)⁻¹ := by
    have hmul :
        GreatCircle.stabilizerPart kE *
            GreatCircle.stabilizerPart (CategoryTheory.Groupoid.inv kE) =
          1 := by
      calc
        GreatCircle.stabilizerPart kE *
              GreatCircle.stabilizerPart (CategoryTheory.Groupoid.inv kE) =
            GreatCircle.stabilizerPart
              (CategoryTheory.Groupoid.inv kE ≫ kE) :=
          (GreatCircle.stabilizerPart_comp
            (CategoryTheory.Groupoid.inv kE) kE).symm
        _ = GreatCircle.stabilizerPart (𝟙 projectiveNorth) :=
          congrArg GreatCircle.stabilizerPart
            (CategoryTheory.Groupoid.inv_comp kE)
        _ = 1 := GreatCircle.stabilizerPart_id projectiveNorth
    exact eq_inv_of_mul_eq_one_right hmul
  rw [hinv]

theorem northRelativeLoop_maps_audit {X : GreatCircle.Base}
    (kE kW : X ⟶ projectiveNorth)
    (uStar u₁ u₂ : OnePoint ℂ)
    (hE :
      (GreatCircle.cayleyProjective
        (GreatCircle.stabilizerPart kE).1).val uStar = u₁)
    (hW :
      (GreatCircle.cayleyProjective
        (GreatCircle.stabilizerPart kW).1).val uStar = u₂) :
    (GreatCircle.cayleyProjective
      (GreatCircle.stabilizerPart
        (CategoryTheory.Groupoid.inv kE ≫ kW)).1).val u₁ = u₂ := by
  rw [GreatCircle.stabilizerPart_comp]
  have hinv :
      GreatCircle.stabilizerPart (CategoryTheory.Groupoid.inv kE) =
        (GreatCircle.stabilizerPart kE)⁻¹ := by
    have hmul :
        GreatCircle.stabilizerPart kE *
            GreatCircle.stabilizerPart (CategoryTheory.Groupoid.inv kE) =
          1 := by
      calc
        GreatCircle.stabilizerPart kE *
              GreatCircle.stabilizerPart (CategoryTheory.Groupoid.inv kE) =
            GreatCircle.stabilizerPart
              (CategoryTheory.Groupoid.inv kE ≫ kE) :=
          (GreatCircle.stabilizerPart_comp
            (CategoryTheory.Groupoid.inv kE) kE).symm
        _ = GreatCircle.stabilizerPart (𝟙 projectiveNorth) :=
          congrArg GreatCircle.stabilizerPart
            (CategoryTheory.Groupoid.inv_comp kE)
        _ = 1 := GreatCircle.stabilizerPart_id projectiveNorth
    exact eq_inv_of_mul_eq_one_right hmul
  rw [hinv, Subgroup.coe_mul, Subgroup.coe_inv, map_mul, map_inv]
  rw [← hE]
  simpa using hW

theorem northComparison_of_parallelFaces_audit
    (A : ASection) {X : GreatCircle.Base}
    (kE kW : X ⟶ projectiveNorth)
    (xN yN : AsectionActionFiber A projectiveNorth)
    (uStar : OnePoint ℂ)
    (hE :
      (GreatCircle.cayleyProjective
        (GreatCircle.stabilizerPart kE).1).val uStar =
          xN.input.back.coordinate)
    (hW :
      (GreatCircle.cayleyProjective
        (GreatCircle.stabilizerPart kW).1).val uStar =
          yN.input.back.coordinate) :
    Nonempty
      ((AsectionActionTransport A
        (CategoryTheory.Groupoid.inv kE ≫ kW)).obj xN ⟶ yN) := by
  apply northFiberHom_of_coordinate_audit
  rw [AsectionActionTransport_obj_input]
  change
    (GreatCircle.cayleyProjective
      (GreatCircle.stabilizerPart
        (CategoryTheory.Groupoid.inv kE ≫ kW)).1).val
          xN.input.back.coordinate =
      yN.input.back.coordinate
  exact northRelativeLoop_maps_audit kE kW uStar
    xN.input.back.coordinate yN.input.back.coordinate hE hW

/-!
The same comparison in its native slice-world register.  A sphere morphism
already carries its Möbius stem; no projective element is chosen here.
Composition in `SphereWorld` gives the relative stem, and the north-pole
A-action conjugates that stem by the distinguished disk action.
-/

theorem sphereWorld_relative_stem_audit
    {I J : SphereWorld} (E W : I ⟶ J) :
    (CategoryTheory.Groupoid.inv E ≫ W).mob =
      W.mob * E.mob⁻¹ := by
  rfl

theorem northPoleAction_relative_stem_audit
    (A : ASection) {I J : SphereWorld} (E W : I ⟶ J) :
    ((northPoleAction A).map
      (CategoryTheory.Groupoid.inv E ≫ W)).mob =
        A.distinguishedDiskAction *
          (W.mob * E.mob⁻¹) *
            A.distinguishedDiskAction⁻¹ := by
  rfl

theorem sphereWorld_relative_stem_maps_audit
    {I J : SphereWorld} (E W : I ⟶ J)
    (uStar uE uW : OnePoint ℂ)
    (hE : E.mob.val uStar = uE)
    (hW : W.mob.val uStar = uW) :
    (CategoryTheory.Groupoid.inv E ≫ W).mob.val uE = uW := by
  rw [sphereWorld_relative_stem_audit, ← hE]
  simpa using hW

theorem sphereWorld_relative_functor_audit
    {I J : SphereWorld} (E W : I ⟶ J) :
    distinguishedWorldAction E.mob⁻¹ ⋙
        distinguishedWorldAction W.mob =
      distinguishedWorldAction (W.mob * E.mob⁻¹) := by
  exact distinguishedWorldAction_comp E.mob⁻¹ W.mob

/-!
The round-trip packaging: Euler and Weierstrass are parallel two-legged
action squares.  Reversing the Euler square and composing the Weierstrass
square produces an endosquare of their common target.  Its two stems are
the corresponding relative Möbius elements, and its action-state transport
is the composite functor supplied by the round trip.
-/

theorem relativeActionSquare_left_audit
    {source target : Moebius}
    (E W : ActionTransportSquare source target) :
    (E.inv.comp W).left = W.left * E.left⁻¹ := by
  rfl

theorem relativeActionSquare_right_audit
    {source target : Moebius}
    (E W : ActionTransportSquare source target) :
    (E.inv.comp W).right = W.right * E.right⁻¹ := by
  rfl

theorem relativeActionSquare_transport_audit
    (A : ASection) {source target : Moebius}
    (E W : ActionTransportSquare source target) :
    (E.inv.comp W).actionStateTransport A =
      E.inv.actionStateTransport A ⋙ W.actionStateTransport A := by
  exact ActionTransportSquare.actionStateTransport_comp A E.inv W

theorem residueTotal_morphism_of_northComparison_audit
    (A : ASection)
    (P Q : Grothendieck
      (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat))
    (xN yN : AsectionActionFiber A projectiveNorth)
    (g : projectiveNorth ⟶ P.base)
    (hg : (AsectionActionTransport A g).obj xN = P.fiber.obj)
    (h : projectiveNorth ⟶ Q.base)
    (hh : (AsectionActionTransport A h).obj yN = Q.fiber.obj)
    (k : projectiveNorth ⟶ projectiveNorth)
    (φ : (AsectionActionTransport A k).obj xN ⟶ yN) :
    Nonempty (P ⟶ Q) := by
  refine ⟨⟨(CategoryTheory.Groupoid.inv g ≫ k) ≫ h,
    ((AsectionCResidueInclusion A).app Q.base).preimage ?_⟩⟩
  have hback : (AsectionActionTransport A
      (CategoryTheory.Groupoid.inv g)).obj P.fiber.obj = xN := by
    calc
      (AsectionActionTransport A
          (CategoryTheory.Groupoid.inv g)).obj P.fiber.obj =
          (AsectionActionTransport A
            (CategoryTheory.Groupoid.inv g)).obj
              ((AsectionActionTransport A g).obj xN) := by rw [hg]
      _ = (AsectionActionTransport A
            (g ≫ CategoryTheory.Groupoid.inv g)).obj xN :=
          (congrArg (fun F => F.obj xN)
            (AsectionActionTransport_comp A g
              (CategoryTheory.Groupoid.inv g))).symm
      _ = xN := by
        have harrow : g ≫ CategoryTheory.Groupoid.inv g =
            𝟙 projectiveNorth := CategoryTheory.Groupoid.comp_inv g
        rw [harrow, AsectionActionTransport_id]
        rfl
  have hsrc : (AsectionActionTransport A
      ((CategoryTheory.Groupoid.inv g ≫ k) ≫ h)).obj P.fiber.obj =
      (AsectionActionTransport A h).obj
        ((AsectionActionTransport A k).obj xN) := by
    calc
      (AsectionActionTransport A
          ((CategoryTheory.Groupoid.inv g ≫ k) ≫ h)).obj P.fiber.obj =
          (AsectionActionTransport A h).obj
            ((AsectionActionTransport A
              (CategoryTheory.Groupoid.inv g ≫ k)).obj P.fiber.obj) :=
        congrArg (fun F => F.obj P.fiber.obj)
          (AsectionActionTransport_comp A
            (CategoryTheory.Groupoid.inv g ≫ k) h)
      _ = (AsectionActionTransport A h).obj
            ((AsectionActionTransport A k).obj
              ((AsectionActionTransport A
                (CategoryTheory.Groupoid.inv g)).obj P.fiber.obj)) := by
          rw [AsectionActionTransport_comp]
          rfl
      _ = (AsectionActionTransport A h).obj
            ((AsectionActionTransport A k).obj xN) := by rw [hback]
  refine eqToHom ?_ ≫
    (AsectionActionTransport A h).map φ ≫
    eqToHom ?_
  · exact hsrc
  · exact hh

/-!
The two immediate consequences are certified conditionally on transitivity
of this exact C-residue total.  These receipts do not import a generic
category: every occurrence is definitionally
`Grothendieck (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat)`.
-/

theorem residueTotal_isConnected_of_transitive_audit
    (A : ASection)
    (htrans : ∀ P Q : Grothendieck
      (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat),
      Nonempty (P ⟶ Q)) :
    CategoryTheory.IsConnected (Grothendieck
      (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat)) := by
  haveI : Nonempty (Grothendieck
      (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat)) :=
    ⟨⟨projectiveNorth,
      ⟨residueActionState A projectiveNorth 0 baseWorld,
        A.residueActionState_mem 0⟩⟩⟩
  exact zigzag_isConnected fun P Q =>
    CategoryTheory.Zigzag.of_hom (htrans P Q).some

theorem residueTotal_pi0_singleton_of_connected_audit
    (A : ASection)
    [CategoryTheory.IsConnected (Grothendieck
      (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat))] :
    ∀ P Q : Grothendieck
      (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat),
      CategoryTheory.ConnectedComponents.mk P =
        CategoryTheory.ConnectedComponents.mk Q := by
  exact fun P Q =>
    _root_.Quotient.sound (CategoryTheory.isPreconnected_zigzag P Q)

#check @residueActionState_north_input_audit
#check @residueActionTransport_north_input_audit
#check @northFiberHom_of_coordinate_audit
#check @northState_is_residueActionState_audit
#check @northRelativeLoop_stabilizer_audit
#check @northRelativeLoop_maps_audit
#check @northComparison_of_parallelFaces_audit
#check @sphereWorld_relative_stem_audit
#check @northPoleAction_relative_stem_audit
#check @sphereWorld_relative_stem_maps_audit
#check @sphereWorld_relative_functor_audit
#check @relativeActionSquare_left_audit
#check @relativeActionSquare_right_audit
#check @relativeActionSquare_transport_audit
#check @residueTotal_morphism_of_northComparison_audit
#check @residueTotal_isConnected_of_transitive_audit
#check @residueTotal_pi0_singleton_of_connected_audit

#print axioms residueActionState_north_input_audit
#print axioms residueActionTransport_north_input_audit
#print axioms northFiberHom_of_coordinate_audit
#print axioms northState_is_residueActionState_audit
#print axioms northRelativeLoop_stabilizer_audit
#print axioms northRelativeLoop_maps_audit
#print axioms northComparison_of_parallelFaces_audit
#print axioms sphereWorld_relative_stem_audit
#print axioms northPoleAction_relative_stem_audit
#print axioms sphereWorld_relative_stem_maps_audit
#print axioms sphereWorld_relative_functor_audit
#print axioms relativeActionSquare_left_audit
#print axioms relativeActionSquare_right_audit
#print axioms relativeActionSquare_transport_audit
#print axioms residueTotal_morphism_of_northComparison_audit
#print axioms residueTotal_isConnected_of_transitive_audit
#print axioms residueTotal_pi0_singleton_of_connected_audit

end ASection
