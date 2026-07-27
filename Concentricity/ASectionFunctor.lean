/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ASectionEquivariant
import Concentricity.ProjectiveSection
import Mathlib.CategoryTheory.Groupoid
import Mathlib.CategoryTheory.Groupoid.Discrete
import Mathlib.CategoryTheory.Groupoid.Grpd.Basic

/-!
# The normalized point-graph projection

`AsectionSlice` remembers the sphere direction and the Möbius shadow of the
normalized orbit--stabilizer action.  This file keeps the normalized point
in that sphere as well.  Its A-value is computed by `A.realize`; it is not a
separately supplied label.

The fibre arrows are the `G₂` direction changes.  A projective-base arrow
acts on the normalized chart coordinate by the already-certified
`projectiveArrowElement`.  Since the `G₂` action changes only the sphere
direction while the Möbius action changes only the chart coordinate, these
two actions commute definitionally.

This is a useful point-graph projection, but it is not the global generated
action or `AsectionActionDiagram`: its projective maps do not yet carry the
domain/codomain naturality square of the complete
Euler--Weierstrass--GPV action.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-- A normalized A-section state: a point in a chosen member of the
continuum of slice spheres. Its canonical function value is read by
`AsectionState.output`. -/
structure AsectionState (A : ASection) where
  world : SphereWorld
  coordinate : OnePoint ℂ

namespace AsectionState

/-- The actual normalized octonionic input represented by a state. -/
def input {A : ASection} (x : AsectionState A) : OnePoint Octonion :=
  spherePt x.world.val x.coordinate

/-- The canonical output of the one A-section function: `A.realize input`. -/
def output {A : ASection} (x : AsectionState A) : OnePoint Octonion :=
  A.realize x.input

/-- A Möbius element acts on the normalized chart coordinate while
retaining the chosen sphere world. -/
def mobius {A : ASection} (m : Moebius) (x : AsectionState A) :
    AsectionState A where
  world := x.world
  coordinate := m.val x.coordinate

/-- `G₂` sweeps a normalized state through the continuum of slice worlds
without changing its intrinsic chart coordinate. -/
instance (A : ASection) : SMul G2 (AsectionState A) where
  smul g x :=
    { world :=
        ⟨g • x.world.val,
          G2.smul_mem_unitImaginarySphere g x.world.prop⟩
      coordinate := x.coordinate }

instance (A : ASection) : MulAction G2 (AsectionState A) where
  one_smul x := by cases x; rfl
  mul_smul g h x := by cases x; rfl

@[simp] theorem smul_world (A : ASection) (g : G2) (x : AsectionState A) :
    (g • x).world.val = g • x.world.val := rfl

@[simp] theorem smul_coordinate (A : ASection) (g : G2)
    (x : AsectionState A) :
    (g • x).coordinate = x.coordinate := rfl

/-- The normalized input realization is `G₂`-equivariant. -/
theorem input_equivariant (A : ASection) (g : G2) (x : AsectionState A) :
    (g • x).input = g • x.input := by
  exact (smul_spherePt g x.world.val x.coordinate).symm

/-- The A-generated output is transported by the same `G₂` action. -/
theorem output_equivariant (A : ASection) (g : G2) (x : AsectionState A) :
    (g • x).output = g • x.output := by
  rw [output, output, input_equivariant, A.realize_equivariant]

end AsectionState

/-- The slice-preserving value map on one represented sphere.  This is the
domain-to-codomain register of the A-action at a fixed world. -/
def sphereValueMap (A : ASection) (I : SphereWorld) :
    ↑(Octonion.sliceSphere I.val) → ↑(Octonion.sliceSphere I.val) :=
  fun q => ⟨A.realize q.val, A.realize_mem_sliceSphere I.prop q.prop⟩

/-- The point transport in a slice induced by one projective
orbit--stabilizer arrow. -/
def projectivePointHom (A : ASection) {X Y : GreatCircle.Base}
    (f : X ⟶ Y) (I : SphereWorld) : I ⟶ I :=
  ⟨1, one_smul G2 I.val, projectiveArrowElement A f⟩

/-- The overly strong same-leg version of projective value naturality.
The semantic preflight records that this does not follow from the current
green declarations: the completed action may instead have distinct native
domain and codomain legs. -/
def SameLegProjectiveValueNaturality (A : ASection) : Prop :=
  ∀ ⦃X Y : GreatCircle.Base⦄ (f : X ⟶ Y) (I : SphereWorld)
      (q : ↑(Octonion.sliceSphere I.val)),
    (A.projectivePointHom f I).realize (A.sphereValueMap I q) =
      A.sphereValueMap I ((A.projectivePointHom f I).realize q)

/-- A paired transport square for the two registers of the A-action.
`domainLeg` transports the normalized input, while `codomainLeg` transports
the value produced by `A.realize`.  The two endpoint equations are the
commuting square itself; neither leg is inferred from the other. -/
structure AsectionTransportSquare (A : ASection) (I J : SphereWorld)
    (q : ↑(Octonion.sliceSphere I.val))
    (r : ↑(Octonion.sliceSphere J.val)) where
  domainLeg : I ⟶ J
  codomainLeg : I ⟶ J
  domain_naturality : domainLeg.realize q = r
  codomain_naturality :
    codomainLeg.realize (A.sphereValueMap I q) = A.sphereValueMap J r

/-- The A-specific datum required to lift one projective base arrow to a
generated value-state fibre. The eventual `AsectionActionDiagram` must
obtain this from the native Euler--Weierstrass--GPV action, uniformly and
compatibly with identity and composition. -/
structure ProjectiveValueTransport (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) (I : SphereWorld)
    (q : ↑(Octonion.sliceSphere I.val)) where
  targetWorld : SphereWorld
  target : ↑(Octonion.sliceSphere targetWorld.val)
  square : AsectionTransportSquare A I targetWorld q target

/-! ## The action-level commuting squares

These are the naturality squares of the geometric action itself.  They are
not the rejected assertion that `A.realize` commutes with an arbitrary
Möbius map on points. -/

/-- A two-sided commuting square between two Möbius action states. -/
@[ext]
structure ActionTransportSquare (source target : Moebius) where
  left : Moebius
  right : Moebius
  commutes : left * source = target * right

/-- The group equality in an action-transport square is the commuting
point-square at every chart coordinate. -/
theorem ActionTransportSquare.apply {source target : Moebius}
    (f : ActionTransportSquare source target) (z : OnePoint ℂ) :
    f.left.val (source.val z) = target.val (f.right.val z) := by
  exact congrArg (fun m : Moebius => m.val z) f.commutes

/-- Identity square on one action state. -/
def ActionTransportSquare.id (a : Moebius) :
    ActionTransportSquare a a where
  left := 1
  right := 1
  commutes := by simp

/-- Vertical composition of action-transport squares. -/
def ActionTransportSquare.comp {a b c : Moebius}
    (f : ActionTransportSquare a b) (g : ActionTransportSquare b c) :
    ActionTransportSquare a c where
  left := g.left * f.left
  right := g.right * f.right
  commutes := by
    calc
      (g.left * f.left) * a = g.left * (f.left * a) := by group
      _ = g.left * (b * f.right) := by rw [f.commutes]
      _ = (g.left * b) * f.right := by group
      _ = (c * g.right) * f.right := by rw [g.commutes]
      _ = c * (g.right * f.right) := by group

/-- Reversal of an action-transport square. -/
def ActionTransportSquare.inv {a b : Moebius}
    (f : ActionTransportSquare a b) : ActionTransportSquare b a where
  left := f.left⁻¹
  right := f.right⁻¹
  commutes := by
    calc
      f.left⁻¹ * b =
          f.left⁻¹ * (b * f.right) * f.right⁻¹ := by group
      _ = f.left⁻¹ * (f.left * a) * f.right⁻¹ := by rw [f.commutes]
      _ = a * f.right⁻¹ := by group

/-- Orbit--stabilizer supplies the horizontal naturality square of A's
positioned action at every projective-base arrow. -/
def orbitStabilizerActionSquare (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    ActionTransportSquare (projectiveObjectFrame A X)
      (projectiveObjectFrame A Y) where
  left := projectiveArrowElement A f
  right := GreatCircle.cayleyProjective (GreatCircle.stabilizerPart f).1
  commutes := projectiveArrowElement_frame_compat A f

/-- GPV winding supplies the vertical naturality square: the two endpoints
are the same exponential action, because winding changes only the lift
rung. -/
def GpvTransport.actionSquare {A : ASection}
    {X Y : GreatCircle.Base} {k : ℤ} (h : GpvTransport A X Y k) :
    ActionTransportSquare
      (GreatCircle.diskExpAction (h.lift 0))
      (GreatCircle.diskExpAction (h.lift 1)) where
  left := 1
  right := 1
  commutes := by
    simpa using h.diskExpAction_endpoint_eq

/-- The GPV exponential action positioned in the orbit--stabilizer frame
over a projective-base object.  Both factors are readings of A's one
geometric action: the frame supplies the projective position and the GPV
factor supplies the value/lift register. -/
def positionedGpvAction (A : ASection) (X : GreatCircle.Base)
    {Y : GreatCircle.Base} {k : ℤ} (h : GpvTransport A X Y k)
    (t : unitInterval) : Moebius :=
  projectiveObjectFrame A X * GreatCircle.diskExpAction (h.lift t)

/-- The complete domain/codomain square obtained by putting the GPV endpoint
square inside the unique orbit--stabilizer square.

The left leg is the genuine framed projective transition.  The right leg is
the north-stabilizer factor conjugated by the GPV exponential action.  The
square commutes because `projectiveArrowElement_frame_compat` is the
orbit--stabilizer square and `diskExpAction_endpoint_eq` is the GPV square.
Thus naturality is a property of the already-built geometric action, not an
extra compatibility assumption. -/
def projectiveGpvActionSquare (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) {k : ℤ}
    (h : GpvTransport A X Y k) :
    ActionTransportSquare
      (positionedGpvAction A X h 0)
      (projectiveObjectFrame A Y *
        GreatCircle.diskExpAction (h.lift 1)) where
  left := projectiveArrowElement A f
  right :=
    (GreatCircle.diskExpAction (h.lift 0))⁻¹ *
      GreatCircle.cayleyProjective (GreatCircle.stabilizerPart f).1 *
        GreatCircle.diskExpAction (h.lift 0)
  commutes := by
    have hgpv :
        GreatCircle.diskExpAction (h.lift 0) =
          GreatCircle.diskExpAction (h.lift 1) :=
      h.diskExpAction_endpoint_eq
    unfold positionedGpvAction
    rw [← hgpv]
    calc
      projectiveArrowElement A f *
          (projectiveObjectFrame A X *
            GreatCircle.diskExpAction (h.lift 0)) =
          (projectiveArrowElement A f * projectiveObjectFrame A X) *
            GreatCircle.diskExpAction (h.lift 0) := by group
      _ = (projectiveObjectFrame A Y *
            GreatCircle.cayleyProjective
              (GreatCircle.stabilizerPart f).1) *
            GreatCircle.diskExpAction (h.lift 0) := by
          rw [projectiveArrowElement_frame_compat]
      _ = (projectiveObjectFrame A Y *
              GreatCircle.diskExpAction (h.lift 0)) *
            ((GreatCircle.diskExpAction (h.lift 0))⁻¹ *
              GreatCircle.cayleyProjective
                (GreatCircle.stabilizerPart f).1 *
              GreatCircle.diskExpAction (h.lift 0)) := by group

/-- The real output register carried by the complete projective/GPV square
is unchanged between its two endpoints.  This is the level face of the same
square, not a downstream descent condition. -/
theorem projectiveGpvActionSquare_level (A : ASection)
    {X Y : GreatCircle.Base} (_f : X ⟶ Y) {k : ℤ}
    (h : GpvTransport A X Y k) :
    (h.lift 0).re = (h.lift 1).re := by
  exact h.lift_endpoint_re_eq

/-- The actual projective-base leg underlying the n-th normalized
zero-to-N action square. -/
def normalizedNBaseHom (A : ASection) (n : ℕ) :
    normalizedFootpoint (A.sphereZero n).re ⟶
      GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point) :=
  GreatCircle.toNHom (A.sphereZero n).re

/-- Each C-residue output's own closed zero--pole tape, positioned by the
same orbit--stabilizer action, gives its full action square to the common
north chart.  The source is indexed by the actual zero and the GPV tape is
the one extracted from `normalizedNLeg`; an arbitrary real point cannot be
substituted into this declaration. -/
noncomputable def normalizedNActionSquare (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    let tape := A.normalizedNActionTape n I
    ActionTransportSquare
      (projectiveObjectFrame A
          (normalizedFootpoint (A.sphereZero n).re) *
        GreatCircle.diskExpAction (tape.lift 0))
      (projectiveObjectFrame A
          (GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point)) *
        GreatCircle.diskExpAction (tape.lift 1)) := by
  let tape := A.normalizedNActionTape n I
  let f := A.normalizedNBaseHom n
  refine
    { left := projectiveArrowElement A f
      right :=
        (GreatCircle.diskExpAction (tape.lift 0))⁻¹ *
          GreatCircle.cayleyProjective
            (GreatCircle.stabilizerPart f).1 *
          GreatCircle.diskExpAction (tape.lift 0)
      commutes := ?_ }
  have hgpv :
      GreatCircle.diskExpAction (tape.lift 0) =
        GreatCircle.diskExpAction (tape.lift 1) := by
    exact congrArg GreatCircle.diskExpAction tape.lift_closed.symm
  rw [← hgpv]
  calc
    projectiveArrowElement A f *
        (projectiveObjectFrame A
            (normalizedFootpoint (A.sphereZero n).re) *
          GreatCircle.diskExpAction (tape.lift 0)) =
        (projectiveArrowElement A f *
          projectiveObjectFrame A
            (normalizedFootpoint (A.sphereZero n).re)) *
          GreatCircle.diskExpAction (tape.lift 0) := by group
    _ = (projectiveObjectFrame A
            (GreatCircle.pointObj
              (OnePoint.infty : GreatCircle.Point)) *
          GreatCircle.cayleyProjective
            (GreatCircle.stabilizerPart f).1) *
          GreatCircle.diskExpAction (tape.lift 0) := by
        rw [projectiveArrowElement_frame_compat]
    _ = (projectiveObjectFrame A
            (GreatCircle.pointObj
              (OnePoint.infty : GreatCircle.Point)) *
          GreatCircle.diskExpAction (tape.lift 0)) *
        ((GreatCircle.diskExpAction (tape.lift 0))⁻¹ *
          GreatCircle.cayleyProjective
            (GreatCircle.stabilizerPart f).1 *
          GreatCircle.diskExpAction (tape.lift 0)) := by group

@[simp] theorem normalizedNActionSquare_left (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    (A.normalizedNActionSquare n I).left =
      projectiveArrowElement A (A.normalizedNBaseHom n) := rfl

@[simp] theorem normalizedNActionSquare_right (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    (A.normalizedNActionSquare n I).right =
      (GreatCircle.diskExpAction
          ((A.normalizedNActionTape n I).lift 0))⁻¹ *
        GreatCircle.cayleyProjective
          (GreatCircle.stabilizerPart (A.normalizedNBaseHom n)).1 *
        GreatCircle.diskExpAction
          ((A.normalizedNActionTape n I).lift 0) := rfl

/-- The real-level face of the normalized zero-to-N action square. -/
theorem normalizedNActionSquare_level (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    ((A.normalizedNActionTape n I).lift 0).re =
      ((A.normalizedNActionTape n I).lift 1).re := by
  exact congrArg Complex.re
    (A.normalizedNActionTape n I).lift_closed.symm

/-- Identity base transport gives the identity action square. -/
theorem orbitStabilizerActionSquare_id (A : ASection)
    (X : GreatCircle.Base) :
    orbitStabilizerActionSquare A (𝟙 X) =
      ActionTransportSquare.id (projectiveObjectFrame A X) := by
  apply ActionTransportSquare.ext
  · exact projectiveArrowElement_id A X
  · change GreatCircle.cayleyProjective
        (GreatCircle.stabilizerPart (𝟙 X)).1 = 1
    rw [GreatCircle.stabilizerPart_id]
    exact map_one GreatCircle.cayleyProjective

/-- Composition of base arrows is composition of their action-level
naturality squares. -/
theorem orbitStabilizerActionSquare_comp (A : ASection)
    {X Y Z : GreatCircle.Base} (f : X ⟶ Y) (g : Y ⟶ Z) :
    orbitStabilizerActionSquare A (f ≫ g) =
      (orbitStabilizerActionSquare A f).comp
        (orbitStabilizerActionSquare A g) := by
  apply ActionTransportSquare.ext
  · exact projectiveArrowElement_comp A f g
  · change GreatCircle.cayleyProjective
        (GreatCircle.stabilizerPart (f ≫ g)).1 =
      GreatCircle.cayleyProjective (GreatCircle.stabilizerPart g).1 *
        GreatCircle.cayleyProjective (GreatCircle.stabilizerPart f).1
    rw [GreatCircle.stabilizerPart_comp]
    exact map_mul GreatCircle.cayleyProjective _ _

/-- The normalized value-state groupoid.  Objects retain the actual
normalized sphere point; their A-output is `AsectionState.output`.
Morphisms are the genuine `G₂` direction transports. -/
abbrev AsectionStateWorld (A : ASection) :=
  CategoryTheory.ActionCategory G2 (AsectionState A)

instance (A : ASection) : Groupoid (AsectionStateWorld A) :=
  inferInstanceAs (Groupoid
    (CategoryTheory.ActionCategory G2 (AsectionState A)))

/-- The physical input carried by a normalized state, functorially in its
`G₂` direction transport. -/
def AsectionStateInputNatTrans (A : ASection) :
    CategoryTheory.actionAsFunctor G2 (AsectionState A) ⟶
      CategoryTheory.actionAsFunctor G2 (OnePoint Octonion) where
  app _ := ↾AsectionState.input
  naturality := by
    intro X Y g
    ext x
    exact AsectionState.input_equivariant A g x

/-- The input projection from normalized state-world to the octonionic
world `H1`. -/
def AsectionStateInput (A : ASection) : AsectionStateWorld A ⥤ H1 :=
  CategoryTheory.NatTrans.mapElements (AsectionStateInputNatTrans A)

/-- The physical A-output carried by a normalized state, functorially in
the same `G₂` direction transport. -/
def AsectionStateOutputNatTrans (A : ASection) :
    CategoryTheory.actionAsFunctor G2 (AsectionState A) ⟶
      CategoryTheory.actionAsFunctor G2 (OnePoint Octonion) where
  app _ := ↾AsectionState.output
  naturality := by
    intro X Y g
    ext x
    exact AsectionState.output_equivariant A g x

/-- The output projection from normalized state-world to `H1`. -/
def AsectionStateOutput (A : ASection) : AsectionStateWorld A ⥤ H1 :=
  CategoryTheory.NatTrans.mapElements (AsectionStateOutputNatTrans A)

/-- The physical output face is exactly the original equivariant A-action
applied to the physical input face. -/
theorem AsectionState_input_then_equivariant (A : ASection) :
    AsectionStateInput A ⋙ A.AsectionEquivariant =
      AsectionStateOutput A := by
  refine CategoryTheory.Functor.ext (fun _ => rfl) (fun _ _ _ => rfl)

/-- Möbius transport of the normalized chart coordinate, expressed as an
equivariant map of the `G₂` action. -/
def coordinateTransportNatTrans (A : ASection) (m : Moebius) :
    CategoryTheory.actionAsFunctor G2 (AsectionState A) ⟶
      CategoryTheory.actionAsFunctor G2 (AsectionState A) where
  app _ := ↾fun x =>
    x.mobius m
  naturality := by
    intro X Y g
    ext x
    cases x
    rfl

/-- The full state transport induced by a Möbius element. -/
def coordinateTransport (A : ASection) (m : Moebius) :
    AsectionStateWorld A ⥤ AsectionStateWorld A :=
  CategoryTheory.NatTrans.mapElements (coordinateTransportNatTrans A m)

@[simp] theorem coordinateTransport_obj_world (A : ASection) (m : Moebius)
    (x : AsectionStateWorld A) :
    ((coordinateTransport A m).obj x).back.world = x.back.world := rfl

@[simp] theorem coordinateTransport_obj_coordinate (A : ASection) (m : Moebius)
    (x : AsectionStateWorld A) :
    ((coordinateTransport A m).obj x).back.coordinate =
      m.val x.back.coordinate := rfl

@[simp] theorem coordinateTransport_map_val (A : ASection) (m : Moebius)
    {x y : AsectionStateWorld A} (f : x ⟶ y) :
    ((coordinateTransport A m).map f).val = f.val := rfl

theorem coordinateTransport_one (A : ASection) :
    coordinateTransport A 1 = 𝟭 (AsectionStateWorld A) := by
  refine CategoryTheory.Functor.ext (fun x => ?_) (fun x y f => ?_)
  · rfl
  · rfl

theorem coordinateTransport_mul (A : ASection) (m n : Moebius) :
    coordinateTransport A m ⋙ coordinateTransport A n =
      coordinateTransport A (n * m) := by
  refine CategoryTheory.Functor.ext (fun x => ?_) (fun x y f => ?_)
  · rfl
  · rfl

/-! ## Canonical input/output naturality of the one action -/

/-- A two-legged Möbius action square acts on the normalized state
transport.  This is the canonical square used by the positioned action
diagram; it does not pass through an auxiliary presentation of
`AsectionEquivariant`. -/
theorem ActionTransportSquare.coordinateTransport_commutes
    {source target : Moebius}
    (square : ActionTransportSquare source target) (A : ASection) :
    coordinateTransport A source ⋙ coordinateTransport A square.left =
      coordinateTransport A square.right ⋙
        coordinateTransport A target := by
  rw [coordinateTransport_mul, coordinateTransport_mul, square.commutes]

/-- The same action square commutes after reading the normalized input. -/
theorem ActionTransportSquare.input_commutes
    {source target : Moebius}
    (square : ActionTransportSquare source target) (A : ASection) :
    (coordinateTransport A source ⋙ coordinateTransport A square.left) ⋙
        AsectionStateInput A =
      (coordinateTransport A square.right ⋙
          coordinateTransport A target) ⋙ AsectionStateInput A := by
  rw [square.coordinateTransport_commutes A]

/-- The same action square commutes after evaluating the one canonical
A-section output. -/
theorem ActionTransportSquare.output_commutes
    {source target : Moebius}
    (square : ActionTransportSquare source target) (A : ASection) :
    (coordinateTransport A source ⋙ coordinateTransport A square.left) ⋙
        AsectionStateOutput A =
      (coordinateTransport A square.right ⋙
          coordinateTransport A target) ⋙ AsectionStateOutput A := by
  rw [square.coordinateTransport_commutes A]

/-- Orbit--stabilizer transports the canonical normalized input at every
projective arrow. -/
theorem orbitStabilizerActionSquare_input_commutes (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    (coordinateTransport A (projectiveObjectFrame A X) ⋙
        coordinateTransport A
          (orbitStabilizerActionSquare A f).left) ⋙
        AsectionStateInput A =
      (coordinateTransport A
          (orbitStabilizerActionSquare A f).right ⋙
        coordinateTransport A (projectiveObjectFrame A Y)) ⋙
        AsectionStateInput A :=
  (orbitStabilizerActionSquare A f).input_commutes A

/-- Orbit--stabilizer transports the canonical A-section output at every
projective arrow. -/
theorem orbitStabilizerActionSquare_output_commutes (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    (coordinateTransport A (projectiveObjectFrame A X) ⋙
        coordinateTransport A
          (orbitStabilizerActionSquare A f).left) ⋙
        AsectionStateOutput A =
      (coordinateTransport A
          (orbitStabilizerActionSquare A f).right ⋙
        coordinateTransport A (projectiveObjectFrame A Y)) ⋙
        AsectionStateOutput A :=
  (orbitStabilizerActionSquare A f).output_commutes A

/-- The combined projective/GPV square transports the canonical normalized
input. -/
theorem projectiveGpvActionSquare_input_commutes (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) {k : ℤ}
    (h : GpvTransport A X Y k) :
    (coordinateTransport A (positionedGpvAction A X h 0) ⋙
        coordinateTransport A
          (projectiveGpvActionSquare A f h).left) ⋙
        AsectionStateInput A =
      (coordinateTransport A
          (projectiveGpvActionSquare A f h).right ⋙
        coordinateTransport A
          (projectiveObjectFrame A Y *
            GreatCircle.diskExpAction (h.lift 1))) ⋙
        AsectionStateInput A :=
  (projectiveGpvActionSquare A f h).input_commutes A

/-- The combined projective/GPV square transports the canonical A-section
output without introducing a second round-trip functor. -/
theorem projectiveGpvActionSquare_output_commutes (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) {k : ℤ}
    (h : GpvTransport A X Y k) :
    (coordinateTransport A (positionedGpvAction A X h 0) ⋙
        coordinateTransport A
          (projectiveGpvActionSquare A f h).left) ⋙
        AsectionStateOutput A =
      (coordinateTransport A
          (projectiveGpvActionSquare A f h).right ⋙
        coordinateTransport A
          (projectiveObjectFrame A Y *
            GreatCircle.diskExpAction (h.lift 1))) ⋙
        AsectionStateOutput A :=
  (projectiveGpvActionSquare A f h).output_commutes A

/-- The normalized point-graph projection swept over the projective base.
It retains the input point and recomputes `A.realize` there, but it is not
the completed value-transport functor until the projective
domain/codomain square is supplied. -/
def AsectionPointProjection (A : ASection) : GreatCircle.Base ⥤ Grpd where
  obj _ := Grpd.of (AsectionStateWorld A)
  map {X Y} f := coordinateTransport A (projectiveArrowElement A f)
  map_id X := by
    rw [projectiveArrowElement_id]
    exact coordinateTransport_one A
  map_comp f g := by
    rw [projectiveArrowElement_comp]
    exact (coordinateTransport_mul A _ _).symm

/-- The normalized residue-`ℂ` sphere point is an object of every full
A-section fibre.  Its A-value is still computed by the same action. -/
def residueState (A : ASection) (n : ℕ) (I : SphereWorld) :
    AsectionState A where
  world := I
  coordinate := (A.sphereZero n : OnePoint ℂ)

@[simp] theorem residueState_input (A : ASection) (n : ℕ) (I : SphereWorld) :
    (A.residueState n I).input = A.normalizedZeroPoint n I := rfl

@[simp] theorem residueState_output (A : ASection) (n : ℕ) (I : SphereWorld) :
    (A.residueState n I).output = A.normalizedSectionPoint n I := rfl

@[simp] theorem residueState_input_re (A : ASection) (n : ℕ)
    (I : SphereWorld) :
    Octonion.re (A.normalizedZeroLift n I) = (A.sphereZero n).re :=
  A.normalizedZeroLift_re n I

/-! ## The complete analytic presentation of the one A-section action

The physical face is the `G₂` action groupoid of normalized states.  The
presentation face retains the *whole* A-generated GPV lift tape: its domain
and value paths, its continuous logarithmic lift, the exponential commuting
triangle, the real-level tape, uniqueness, and lift-independence.  The
prime index remains bound inside `A.eulerPrimeSum`; it is never replaced by
one endpoint logarithm.

At every instant of every such tape, orbit--stabilizer positions the complete
exponential action over the projective base.  The presentation is oriented
toward the common north frame `N`, so the base-arrow functor transports the
entire triangle, rather than only its endpoint multiplier. -/

/-- The shared north object of the projective base. -/
def projectiveNorth : GreatCircle.Base :=
  GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point)

/-- The canonical base arrow from the common north object to `X`. -/
def orbitHomFromNorth (X : GreatCircle.Base) : projectiveNorth ⟶ X :=
  ⟨GreatCircle.orbitRep (CategoryTheory.ActionCategory.back X),
    GreatCircle.orbitRep_spec (CategoryTheory.ActionCategory.back X)⟩

/-- The inverse canonical base arrow, oriented from `X` to the shared north
object. -/
def orbitHomToNorth (X : GreatCircle.Base) : X ⟶ projectiveNorth :=
  CategoryTheory.Groupoid.inv (orbitHomFromNorth X)

/-- The exact output package of `projective_gpv_disk_action`.  It retains a
complete continuous lift, not a chosen endpoint.  The equation `action`
is the Cayley-disk form of the commuting triangle through `exp`; `level`,
`continuous_level`, `unique`, and `level_independent` are the tame GPV
registers of that same lift. -/
structure AsectionGpvLift (A : ASection)
    (δ : C(unitInterval, ℂ))
    (hp : ∀ t, δ t ≠ (A.pole : ℂ))
    (hne : ∀ t, A.F (δ t) ≠ 0) where
  lift : C(unitInterval, ℂ)
  lift_exp : ∀ t, Complex.exp (lift t) = A.F (δ t)
  action :
    ∀ t, GreatCircle.diskExpAction (lift t) =
      GreatCircle.diskDiagonalMoebiusHom
        (Units.mk0 (A.F (δ t)) (hne t))
  level : ∀ t, (lift t).re = Real.log ‖A.F (δ t)‖
  continuous_level : Continuous fun t => (lift t).re
  unique :
    ∀ lift' : C(unitInterval, ℂ),
      (∀ t, Complex.exp (lift' t) = A.F (δ t)) →
        lift' 0 = lift 0 → lift' = lift
  level_independent :
    ∀ lift' : C(unitInterval, ℂ),
      (∀ t, Complex.exp (lift' t) = A.F (δ t)) →
        ∀ t, (lift' t).re = (lift t).re
  winding :
    δ 0 = δ 1 →
      lift 1 - lift 0 =
        (stemWinding (A.projectiveValuePath δ hp) : ℂ) *
          (2 * (Real.pi : ℂ) * Complex.I)

/-- The unique tame continuous GPV lift generated by `A` along a genuine
pole-avoiding, zero-free value path. -/
noncomputable def canonicalAsectionGpvLift (A : ASection)
    (δ : C(unitInterval, ℂ))
    (hp : ∀ t, δ t ≠ (A.pole : ℂ))
    (hne : ∀ t, A.F (δ t) ≠ 0) :
    AsectionGpvLift A δ hp hne := by
  let hex := A.projective_gpv_transport δ hp hne
  let Γ := Classical.choose hex
  have hs := Classical.choose_spec hex
  have hlift := hs.1
  have hlevel := hs.2.1
  have hcontinuous := hs.2.2.1
  have hunique := hs.2.2.2.1
  have hindependent := hs.2.2.2.2
  exact
    { lift := Γ
      lift_exp := hlift
      action := fun t => by
        unfold GreatCircle.diskExpAction GreatCircle.expUnit
        apply congrArg GreatCircle.diskDiagonalMoebiusHom
        apply Units.ext
        exact hlift t
      level := hlevel
      continuous_level := hcontinuous
      unique := hunique
      level_independent := hindependent
      winding := fun hloop => by
        apply stemWinding_spec (A.projectiveValuePath δ hp) hne
        · change A.F (δ 0) = A.F (δ 1)
          rw [hloop]
        · exact hlift }

/-- The complete exponential action of a GPV lift positioned over one
projective-base object. -/
def positionedLiftAction (A : ASection) (X : GreatCircle.Base)
    {δ : C(unitInterval, ℂ)}
    {hp : ∀ t, δ t ≠ (A.pole : ℂ)}
    {hne : ∀ t, A.F (δ t) ≠ 0}
    (L : AsectionGpvLift A δ hp hne) (t : unitInterval) : Moebius :=
  projectiveObjectFrame A X * GreatCircle.diskExpAction (L.lift t)

/-- Orbit--stabilizer transports a complete exponential action at one
instant of the GPV tape.  Its right leg is the stabilizer conjugated by the
actual multiplier at that instant; hence phase/winding stays in the
stabilizer while the whole action is moved horizontally. -/
def positionedOrbitSquare (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) (d : Moebius) :
    ActionTransportSquare
      (projectiveObjectFrame A X * d)
      (projectiveObjectFrame A Y * d) where
  left := projectiveArrowElement A f
  right :=
    d⁻¹ * GreatCircle.cayleyProjective
      (GreatCircle.stabilizerPart f).1 * d
  commutes := by
    calc
      projectiveArrowElement A f * (projectiveObjectFrame A X * d) =
          (projectiveArrowElement A f * projectiveObjectFrame A X) * d := by
            group
      _ = (projectiveObjectFrame A Y *
            GreatCircle.cayleyProjective
              (GreatCircle.stabilizerPart f).1) * d := by
            rw [projectiveArrowElement_frame_compat]
      _ = (projectiveObjectFrame A Y * d) *
            (d⁻¹ * GreatCircle.cayleyProjective
              (GreatCircle.stabilizerPart f).1 * d) := by
            group

/-- Identity and composition of the positioned squares are inherited from
the unique orbit--stabilizer factorization. -/
theorem positionedOrbitSquare_id (A : ASection)
    (X : GreatCircle.Base) (d : Moebius) :
    positionedOrbitSquare A (𝟙 X) d =
      ActionTransportSquare.id (projectiveObjectFrame A X * d) := by
  apply ActionTransportSquare.ext
  · exact projectiveArrowElement_id A X
  · change d⁻¹ *
      GreatCircle.cayleyProjective
        (GreatCircle.stabilizerPart (𝟙 X)).1 * d = 1
    rw [GreatCircle.stabilizerPart_id]
    change d⁻¹ * GreatCircle.cayleyProjective (1 : GreatCircle.Aut) * d = 1
    rw [map_one]
    group

theorem positionedOrbitSquare_comp (A : ASection)
    {X Y Z : GreatCircle.Base} (f : X ⟶ Y) (g : Y ⟶ Z)
    (d : Moebius) :
    positionedOrbitSquare A (f ≫ g) d =
      (positionedOrbitSquare A f d).comp
        (positionedOrbitSquare A g d) := by
  apply ActionTransportSquare.ext
  · exact projectiveArrowElement_comp A f g
  · change
      d⁻¹ * GreatCircle.cayleyProjective
          (GreatCircle.stabilizerPart (f ≫ g)).1 * d =
        (d⁻¹ * GreatCircle.cayleyProjective
            (GreatCircle.stabilizerPart g).1 * d) *
          (d⁻¹ * GreatCircle.cayleyProjective
            (GreatCircle.stabilizerPart f).1 * d)
    rw [GreatCircle.stabilizerPart_comp]
    change
      d⁻¹ * GreatCircle.cayleyProjective
          ((GreatCircle.stabilizerPart g).1 *
            (GreatCircle.stabilizerPart f).1) * d =
        (d⁻¹ * GreatCircle.cayleyProjective
            (GreatCircle.stabilizerPart g).1 * d) *
          (d⁻¹ * GreatCircle.cayleyProjective
            (GreatCircle.stabilizerPart f).1 * d)
    rw [map_mul]
    group

/-- An A-specific presentation over `X`.

`gpv` is the complete family of unique tame continuous lifts generated by
the A-action.  `toNorth` positions every instant of every lift in a
commuting orbit--stabilizer square whose target is the same action in the
north frame.  The infinite Euler prime family remains visible through
  `euler_gpv`, where `eulerPrimeSum` is definitionally the `tsum` over
`p : A.ι`. -/
@[ext]
structure AsectionPresentation (A : ASection) (X : GreatCircle.Base) where
  gpv :
    ∀ (δ : C(unitInterval, ℂ))
      (hp : ∀ t, δ t ≠ (A.pole : ℂ))
      (hne : ∀ t, A.F (δ t) ≠ 0),
      AsectionGpvLift A δ hp hne
  euler_gpv :
    ∀ (B : GreatCircle.Base)
      (δ : C(unitInterval, ℂ))
      (hstart : ((δ 0 : ℂ) : OnePoint ℂ) =
        GreatCircle.cayleyCoord
          (CategoryTheory.ActionCategory.back B))
      (hloop : δ 0 = δ 1)
      (hpole : ∀ t, δ t ≠ (A.pole : ℂ))
      (hhalf : ∀ t, A.Ω₀ < (δ t).re),
      GpvTransport A B B 0
  toNorth :
    ∀ (δ : C(unitInterval, ℂ))
      (hp : ∀ t, δ t ≠ (A.pole : ℂ))
      (hne : ∀ t, A.F (δ t) ≠ 0)
      (t : unitInterval),
      ActionTransportSquare
        (positionedLiftAction A X (gpv δ hp hne) t)
        (positionedLiftAction A projectiveNorth (gpv δ hp hne) t)

/-- The canonical A-generated presentation over every projective object. -/
noncomputable def canonicalAsectionPresentation (A : ASection)
    (X : GreatCircle.Base) :
    AsectionPresentation A X :=
  { gpv := fun δ hp hne => canonicalAsectionGpvLift A δ hp hne
    euler_gpv := fun B δ hstart hloop hpole hhalf =>
      GpvTransport.ofEulerHalfSpaceLoop A B δ hstart hloop hpole hhalf
    toNorth := fun δ hp hne t =>
      positionedOrbitSquare A (orbitHomToNorth X)
        (GreatCircle.diskExpAction
          ((canonicalAsectionGpvLift A δ hp hne).lift t)) }

/-- Reindex a complete presentation along one projective-base arrow.
For every instant of every lift, the inverse horizontal square first moves
from the new frame back to the old frame and then follows the existing
triangle to `N`.  No tape or prime index is discarded. -/
def reindexAsectionPresentation (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    AsectionPresentation A X → AsectionPresentation A Y :=
  fun p =>
    { gpv := p.gpv
      euler_gpv := p.euler_gpv
      toNorth := fun δ hp hne t =>
        (positionedOrbitSquare A f
          (GreatCircle.diskExpAction ((p.gpv δ hp hne).lift t))).inv.comp
            (p.toNorth δ hp hne t) }

/-- Reindexing by an identity base arrow leaves the complete presentation
unchanged. -/
theorem reindexAsectionPresentation_id (A : ASection)
    (X : GreatCircle.Base) (p : AsectionPresentation A X) :
    reindexAsectionPresentation A (𝟙 X) p = p := by
  apply AsectionPresentation.ext
  · rfl
  · rfl
  · refine heq_of_eq ?_
    funext δ hp hne t
    change
      (positionedOrbitSquare A (𝟙 X)
        (GreatCircle.diskExpAction ((p.gpv δ hp hne).lift t))).inv.comp
          (p.toNorth δ hp hne t) =
        p.toNorth δ hp hne t
    rw [positionedOrbitSquare_id]
    apply ActionTransportSquare.ext <;>
      simp [ActionTransportSquare.comp, ActionTransportSquare.inv,
        ActionTransportSquare.id]

/-- Reindexing respects composition in the projective base. -/
theorem reindexAsectionPresentation_comp (A : ASection)
    {X Y Z : GreatCircle.Base} (f : X ⟶ Y) (g : Y ⟶ Z)
    (p : AsectionPresentation A X) :
    reindexAsectionPresentation A (f ≫ g) p =
      reindexAsectionPresentation A g
        (reindexAsectionPresentation A f p) := by
  apply AsectionPresentation.ext
  · rfl
  · rfl
  · refine heq_of_eq ?_
    funext δ hp hne t
    change
      (positionedOrbitSquare A (f ≫ g)
        (GreatCircle.diskExpAction ((p.gpv δ hp hne).lift t))).inv.comp
          (p.toNorth δ hp hne t) =
        (positionedOrbitSquare A g
          (GreatCircle.diskExpAction ((p.gpv δ hp hne).lift t))).inv.comp
            ((positionedOrbitSquare A f
              (GreatCircle.diskExpAction
                ((p.gpv δ hp hne).lift t))).inv.comp
                  (p.toNorth δ hp hne t))
    rw [positionedOrbitSquare_comp]
    apply ActionTransportSquare.ext <;>
      simp [ActionTransportSquare.comp, ActionTransportSquare.inv]
    all_goals group

/-- The discrete groupoid of A-specific presentation squares over `X`. -/
abbrev AsectionPresentationWorld (A : ASection) (X : GreatCircle.Base) :=
  Discrete (AsectionPresentation A X)

/-- Functorial transport of presentation squares along the projective base. -/
def AsectionPresentationTransport (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    AsectionPresentationWorld A X ⥤ AsectionPresentationWorld A Y :=
  Discrete.functor fun p =>
    Discrete.mk (reindexAsectionPresentation A f p)

theorem AsectionPresentationTransport_id (A : ASection)
    (X : GreatCircle.Base) :
    AsectionPresentationTransport A (𝟙 X) =
      𝟭 (AsectionPresentationWorld A X) := by
  apply Discrete.functor_ext
  intro p
  apply Discrete.ext
  exact reindexAsectionPresentation_id A X p

theorem AsectionPresentationTransport_comp (A : ASection)
    {X Y Z : GreatCircle.Base} (f : X ⟶ Y) (g : Y ⟶ Z) :
    AsectionPresentationTransport A (f ≫ g) =
      AsectionPresentationTransport A f ⋙
        AsectionPresentationTransport A g := by
  apply Discrete.functor_ext
  intro p
  apply Discrete.ext
  exact reindexAsectionPresentation_comp A f g p

/-! ## Quarantined Cartesian-product preflight

This block is retained as a compiling record of the juxtaposition attempt.
Its names are deliberately nested so neither bare `AsectionFunctor` nor its
product fibre can silently enter the corrected construction. -/

namespace JuxtapositionPreflight

/-- The juxtaposition fibre over `X`. Its first factor is the physical
normalized `𝕆* → 𝕆*` graph (the output is computed by `A.realize`); its
second factor is the complete prime/Euler--Weierstrass--GPV presentation of
the action, independently chosen and therefore not yet bound to the physical
state. -/
abbrev AsectionFiberType (A : ASection) (X : GreatCircle.Base) :=
  AsectionStateWorld A × AsectionPresentationWorld A X

abbrev AsectionFiber (A : ASection) (X : GreatCircle.Base) : Grpd :=
  Grpd.of (AsectionFiberType A X)

/-- Transport of the whole two-face fibre. The physical state is retained,
while the entire lift family and all of its north triangles are reindexed by
the two-legged orbit--stabilizer squares. -/
def AsectionFiberTransport (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    AsectionFiber A X ⟶ AsectionFiber A Y :=
  (𝟭 (AsectionStateWorld A)).prod (AsectionPresentationTransport A f)

theorem AsectionFiberTransport_id (A : ASection)
    (X : GreatCircle.Base) :
    AsectionFiberTransport A (𝟙 X) = 𝟭 (AsectionFiber A X) := by
  unfold AsectionFiberTransport
  rw [AsectionPresentationTransport_id]
  rfl

set_option maxRecDepth 10000 in
theorem AsectionFiberTransport_comp (A : ASection)
    {X Y Z : GreatCircle.Base} (f : X ⟶ Y) (g : Y ⟶ Z) :
    AsectionFiberTransport A (f ≫ g) =
      AsectionFiberTransport A f ⋙ AsectionFiberTransport A g := by
  unfold AsectionFiberTransport
  rw [AsectionPresentationTransport_comp]
  refine CategoryTheory.Functor.ext (fun _ => rfl) (fun _ _ h => ?_)
  apply Prod.ext
  · change h.1 = 𝟙 _ ≫ h.1 ≫ 𝟙 _
    simp
  · subsingleton

/-- The quarantined groupoid-valued juxtaposition diagram. It is not the
accepted `AsectionActionDiagram`. -/
def AsectionFunctor (A : ASection) : GreatCircle.Base ⥤ Grpd where
  obj X := AsectionFiber A X
  map {X Y} f := AsectionFiberTransport A f
  map_id X := AsectionFiberTransport_id A X
  map_comp f g := AsectionFiberTransport_comp A f g

/-! ### Five projection receipts -/

/-- Forgetting the projective presentation recovers the physical normalized
state groupoid. -/
def AsectionFiberPhysical (A : ASection) (X : GreatCircle.Base) :
    AsectionFiberType A X ⥤ AsectionStateWorld A :=
  CategoryTheory.Prod.fst _ _

/-- Forgetting the physical state recovers the projective presentation
groupoid. -/
def AsectionFiberPresentation (A : ASection) (X : GreatCircle.Base) :
    AsectionFiberType A X ⥤ AsectionPresentationWorld A X :=
  CategoryTheory.Prod.snd _ _

/-- The physical input face of one full fibre. -/
def AsectionFiberInput (A : ASection) (X : GreatCircle.Base) :
    AsectionFiberType A X ⥤ H1 :=
  AsectionFiberPhysical A X ⋙ AsectionStateInput A

/-- The physical output face of one full fibre. -/
def AsectionFiberRealization (A : ASection) (X : GreatCircle.Base) :
    AsectionFiberType A X ⥤ H1 :=
  AsectionFiberPhysical A X ⋙ AsectionStateOutput A

/-- Forgetting the presentation recovers the graph of the original
`AsectionEquivariant`: output is input followed by A's physical action. -/
theorem AsectionFiber_input_then_equivariant (A : ASection)
    (X : GreatCircle.Base) :
  AsectionFiberInput A X ⋙ A.AsectionEquivariant =
      AsectionFiberRealization A X := by
  unfold AsectionFiberInput AsectionFiberRealization
  change AsectionFiberPhysical A X ⋙
      (AsectionStateInput A ⋙ A.AsectionEquivariant) =
    AsectionFiberPhysical A X ⋙ AsectionStateOutput A
  rw [AsectionState_input_then_equivariant]

@[simp] theorem AsectionFunctor_map_physical (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (x : AsectionFiberType A X) :
    (((AsectionFunctor A).map f).obj x).1 = x.1 := rfl

@[simp] theorem AsectionFunctor_map_presentation (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (x : AsectionFiberType A X) :
    (((AsectionFunctor A).map f).obj x).2.as =
      reindexAsectionPresentation A f x.2.as := rfl

/-- The output register of a full fibre object is computed by the original
physical A-action, never stored as a label. -/
def AsectionFiberOutput (A : ASection) {X : GreatCircle.Base}
    (x : AsectionFiberType A X) : OnePoint Octonion :=
  x.1.back.output

@[simp] theorem AsectionFiberOutput_eq_realize (A : ASection)
    {X : GreatCircle.Base} (x : AsectionFiberType A X) :
    AsectionFiberOutput A x = A.realize x.1.back.input := rfl

/-- Reindexing retains the complete GPV lift family definitionally. -/
@[simp] theorem AsectionFunctor_map_gpv (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (p : AsectionPresentation A X)
    (δ : C(unitInterval, ℂ))
    (hp : ∀ t, δ t ≠ (A.pole : ℂ))
    (hne : ∀ t, A.F (δ t) ≠ 0) :
    (reindexAsectionPresentation A f p).gpv δ hp hne =
      p.gpv δ hp hne := rfl

/-- Both native legs of the certified orbit--stabilizer square occur at
every instant of every GPV tape used by a base-arrow reindexing. -/
theorem AsectionFunctor_map_uses_two_legs (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (p : AsectionPresentation A X)
    (δ : C(unitInterval, ℂ))
    (hp : ∀ t, δ t ≠ (A.pole : ℂ))
    (hne : ∀ t, A.F (δ t) ≠ 0)
    (t : unitInterval) :
    let d := GreatCircle.diskExpAction ((p.gpv δ hp hne).lift t)
    ((positionedOrbitSquare A f d).left =
        projectiveArrowElement A f) ∧
      ((positionedOrbitSquare A f d).right =
        d⁻¹ * GreatCircle.cayleyProjective
          (GreatCircle.stabilizerPart f).1 * d) :=
  ⟨rfl, rfl⟩

/-- Every C-residue sphere produced by A is a physical object of every full
fibre, paired with A's canonical Euler--Weierstrass--GPV presentation.
Neither its value nor its real register is added as a field. -/
noncomputable def residueFiberState (A : ASection) (X : GreatCircle.Base)
    (n : ℕ) (I : SphereWorld) : AsectionFiberType A X :=
  ((A.residueState n I : AsectionStateWorld A),
    Discrete.mk (canonicalAsectionPresentation A X))

@[simp] theorem residueFiberState_input (A : ASection)
    (X : GreatCircle.Base) (n : ℕ) (I : SphereWorld) :
    (residueFiberState A X n I).1.back.input =
      A.normalizedZeroPoint n I :=
  A.residueState_input n I

@[simp] theorem residueFiberState_output (A : ASection)
    (X : GreatCircle.Base) (n : ℕ) (I : SphereWorld) :
    AsectionFiberOutput A (residueFiberState A X n I) =
      A.normalizedSectionPoint n I :=
  A.residueState_output n I

end JuxtapositionPreflight

/-- The infinite Euler prime stack is a literal full tape in every
canonical presentation.  Its lift at every instant is definitionally the
`tsum` over `p : A.ι`; the prime index never becomes an external parameter
of the A-section functor. -/
theorem canonicalAsectionPresentation_euler_prime_stack (A : ASection)
    (X B : GreatCircle.Base)
    (δ : C(unitInterval, ℂ))
    (hstart : ((δ 0 : ℂ) : OnePoint ℂ) =
      GreatCircle.cayleyCoord (CategoryTheory.ActionCategory.back B))
    (hloop : δ 0 = δ 1)
    (hpole : ∀ t, δ t ≠ (A.pole : ℂ))
    (hhalf : ∀ t, A.Ω₀ < (δ t).re)
    (t : unitInterval) :
    ((canonicalAsectionPresentation A X).euler_gpv
        B δ hstart hloop hpole hhalf).lift t =
      ∑' p : A.ι, A.ℓ p (δ t) :=
  rfl

/-- The prime-sum tape commutes pointwise with `exp`; this is the literal
lift triangle, not an endpoint comparison. -/
theorem canonicalAsectionPresentation_euler_lift_exp (A : ASection)
    (X B : GreatCircle.Base)
    (δ : C(unitInterval, ℂ))
    (hstart : ((δ 0 : ℂ) : OnePoint ℂ) =
      GreatCircle.cayleyCoord (CategoryTheory.ActionCategory.back B))
    (hloop : δ 0 = δ 1)
    (hpole : ∀ t, δ t ≠ (A.pole : ℂ))
    (hhalf : ∀ t, A.Ω₀ < (δ t).re)
    (t : unitInterval) :
    let tape :=
      (canonicalAsectionPresentation A X).euler_gpv
        B δ hstart hloop hpole hhalf
    Complex.exp (tape.lift t) = tape.value t :=
  ((canonicalAsectionPresentation A X).euler_gpv
    B δ hstart hloop hpole hhalf).lift_exp t

/-- The full Euler prime lift is tame/unique after its initial rung is
fixed. -/
theorem canonicalAsectionPresentation_euler_lift_unique (A : ASection)
    (X B : GreatCircle.Base)
    (δ : C(unitInterval, ℂ))
    (hstart : ((δ 0 : ℂ) : OnePoint ℂ) =
      GreatCircle.cayleyCoord (CategoryTheory.ActionCategory.back B))
    (hloop : δ 0 = δ 1)
    (hpole : ∀ t, δ t ≠ (A.pole : ℂ))
    (hhalf : ∀ t, A.Ω₀ < (δ t).re)
    (lift' : C(unitInterval, ℂ))
    (hlift' :
      ∀ t, Complex.exp (lift' t) =
        ((canonicalAsectionPresentation A X).euler_gpv
          B δ hstart hloop hpole hhalf).value t)
    (hzero :
      lift' 0 =
        ((canonicalAsectionPresentation A X).euler_gpv
          B δ hstart hloop hpole hhalf).lift 0) :
    lift' =
      ((canonicalAsectionPresentation A X).euler_gpv
        B δ hstart hloop hpole hhalf).lift :=
  ((canonicalAsectionPresentation A X).euler_gpv
    B δ hstart hloop hpole hhalf).lift_unique lift' hlift' hzero

/-- The real level of the full prime lift is continuous all the way along
the tape. -/
theorem canonicalAsectionPresentation_euler_level_continuous (A : ASection)
    (X B : GreatCircle.Base)
    (δ : C(unitInterval, ℂ))
    (hstart : ((δ 0 : ℂ) : OnePoint ℂ) =
      GreatCircle.cayleyCoord (CategoryTheory.ActionCategory.back B))
    (hloop : δ 0 = δ 1)
    (hpole : ∀ t, δ t ≠ (A.pole : ℂ))
    (hhalf : ∀ t, A.Ω₀ < (δ t).re) :
    Continuous fun t =>
      (((canonicalAsectionPresentation A X).euler_gpv
        B δ hstart hloop hpole hhalf).lift t).re :=
  ((canonicalAsectionPresentation A X).euler_gpv
    B δ hstart hloop hpole hhalf).continuous_level

/-- The Euler tape retains its complete winding equation.  On a loop inside
C2's half-space the whole prime-sum lift closes at winding zero. -/
theorem canonicalAsectionPresentation_euler_winding (A : ASection)
    (X B : GreatCircle.Base)
    (δ : C(unitInterval, ℂ))
    (hstart : ((δ 0 : ℂ) : OnePoint ℂ) =
      GreatCircle.cayleyCoord (CategoryTheory.ActionCategory.back B))
    (hloop : δ 0 = δ 1)
    (hpole : ∀ t, δ t ≠ (A.pole : ℂ))
    (hhalf : ∀ t, A.Ω₀ < (δ t).re) :
    let tape :=
      (canonicalAsectionPresentation A X).euler_gpv
        B δ hstart hloop hpole hhalf
    tape.lift 1 - tape.lift 0 =
      2 * Real.pi * Complex.I * ((0 : ℤ) : ℂ) :=
  ((canonicalAsectionPresentation A X).euler_gpv
    B δ hstart hloop hpole hhalf).winding

/-- The complete Euler prime tape also passes through the same
orbit--stabilizer triangle to `N` at every instant. -/
def canonicalAsectionPresentation_euler_toNorth (A : ASection)
    (X B : GreatCircle.Base)
    (δ : C(unitInterval, ℂ))
    (hstart : ((δ 0 : ℂ) : OnePoint ℂ) =
      GreatCircle.cayleyCoord (CategoryTheory.ActionCategory.back B))
    (hloop : δ 0 = δ 1)
    (hpole : ∀ t, δ t ≠ (A.pole : ℂ))
    (hhalf : ∀ t, A.Ω₀ < (δ t).re)
    (t : unitInterval) :
    let tape :=
      (canonicalAsectionPresentation A X).euler_gpv
        B δ hstart hloop hpole hhalf
    ActionTransportSquare
      (projectiveObjectFrame A X *
        GreatCircle.diskExpAction (tape.lift t))
      (projectiveObjectFrame A projectiveNorth *
        GreatCircle.diskExpAction (tape.lift t)) :=
  positionedOrbitSquare A (orbitHomToNorth X)
    (GreatCircle.diskExpAction
      (((canonicalAsectionPresentation A X).euler_gpv
        B δ hstart hloop hpole hhalf).lift t))

/-- Every point of every canonical GPV lift satisfies the exponential
commuting triangle of the A-generated action. -/
theorem canonicalAsectionPresentation_gpv_action (A : ASection)
    (X : GreatCircle.Base)
    (δ : C(unitInterval, ℂ))
    (hp : ∀ t, δ t ≠ (A.pole : ℂ))
    (hne : ∀ t, A.F (δ t) ≠ 0)
    (t : unitInterval) :
    GreatCircle.diskExpAction
        ((canonicalAsectionPresentation A X).gpv δ hp hne |>.lift t) =
      GreatCircle.diskDiagonalMoebiusHom
        (Units.mk0 (A.F (δ t)) (hne t)) :=
  ((canonicalAsectionPresentation A X).gpv δ hp hne).action t

/-- The canonical lift is tame/unique as a whole continuous path, not only
at its endpoint. -/
theorem canonicalAsectionPresentation_gpv_unique (A : ASection)
    (X : GreatCircle.Base)
    (δ : C(unitInterval, ℂ))
    (hp : ∀ t, δ t ≠ (A.pole : ℂ))
    (hne : ∀ t, A.F (δ t) ≠ 0)
    (lift' : C(unitInterval, ℂ))
    (hlift' : ∀ t, Complex.exp (lift' t) = A.F (δ t))
    (hzero :
      lift' 0 =
        ((canonicalAsectionPresentation A X).gpv δ hp hne).lift 0) :
    lift' = ((canonicalAsectionPresentation A X).gpv δ hp hne).lift :=
  ((canonicalAsectionPresentation A X).gpv δ hp hne).unique
    lift' hlift' hzero

end ASection
