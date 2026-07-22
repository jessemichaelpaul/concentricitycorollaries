/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ProjectiveSection
import Concentricity.NormalizedBase

/-!
# The direct total of the A-section action

The completed geometric functor `sectionFunctor A` first determines every
base object and arrow action on the whole `SphereWorld` continuum.  Its total
is defined directly from those objects and arrows, without an intermediate
`Grpd`-valued diagram.

Every transport used in the total is typed through the full A-specialized
orbit--stabilizer transition.  C3/C4 below identify and count particular zero
outputs; the native analytic-cargo gate remains upstream of the readout.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-- The action of the direct sphere-valued arrow is exactly the framed
source/stabilizer/target transition. -/
theorem sectionFunctor_transition (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) :
    distinguishedWorldAction ((sectionFunctor A).map f).mob =
      projectiveTransition A f := by
  rw [sectionFunctor_map_mob, projectiveTransition_eq]

/-- Identity and composition for the transition used directly by `TotalA`. -/
@[simp] theorem projectiveTransition_id (A : ASection)
    (X : GreatCircle.Base) :
    projectiveTransition A (𝟙 X) = Functor.id SphereWorld := by
  rw [projectiveTransition_eq, projectiveArrowElement_id]
  exact distinguishedWorldAction_one

theorem projectiveTransition_comp (A : ASection)
    {X Y Z : GreatCircle.Base} (f : X ⟶ Y) (g : Y ⟶ Z) :
    projectiveTransition A (f ≫ g) =
      projectiveTransition A f ⋙ projectiveTransition A g := by
  rw [projectiveTransition_eq, projectiveTransition_eq,
    projectiveTransition_eq, projectiveArrowElement_comp]
  exact (distinguishedWorldAction_comp
    (projectiveArrowElement A f) (projectiveArrowElement A g)).symm

@[simp] theorem projectiveTransition_obj (A : ASection)
    {X Y : GreatCircle.Base} (f : X ⟶ Y) (I : SphereWorld) :
    (projectiveTransition A f).obj I = I := rfl

@[simp] theorem projectiveTransition_map_id (A : ASection)
    (X : GreatCircle.Base) {I J : SphereWorld} (φ : I ⟶ J) :
    (projectiveTransition A (𝟙 X)).map φ = φ := by
  apply SphereHom.ext
  · rfl
  · simp only [projectiveTransition, projectiveObjectAction,
      distinguishedWorldAction, Functor.comp_map,
      GreatCircle.stabilizerPart_id, Subgroup.coe_one, map_one]
    change _ = φ.mob
    group

theorem projectiveTransition_map_comp (A : ASection)
    {X Y Z : GreatCircle.Base} (f : X ⟶ Y) (g : Y ⟶ Z)
    {I J : SphereWorld} (φ : I ⟶ J) :
    (projectiveTransition A (f ≫ g)).map φ =
      (projectiveTransition A g).map
        ((projectiveTransition A f).map φ) := by
  apply SphereHom.ext
  · rfl
  · simp only [projectiveTransition, projectiveObjectAction,
      distinguishedWorldAction, Functor.comp_map,
      GreatCircle.stabilizerPart_comp, Subgroup.coe_mul, map_mul]
    group

@[simp] theorem sectionFunctorAction_id (A : ASection)
    (X : GreatCircle.Base) :
    distinguishedWorldAction ((sectionFunctor A).map (𝟙 X)).mob =
      Functor.id SphereWorld := by
  rw [sectionFunctor_transition, projectiveTransition_id]

@[simp] theorem sectionFunctorAction_map_id (A : ASection)
    (X : GreatCircle.Base) {I J : SphereWorld} (φ : I ⟶ J) :
    (distinguishedWorldAction ((sectionFunctor A).map (𝟙 X)).mob).map φ =
      φ := by
  apply SphereHom.ext
  · rfl
  · change projectiveArrowElement A (𝟙 X) * φ.mob *
        (projectiveArrowElement A (𝟙 X))⁻¹ = φ.mob
    rw [projectiveArrowElement_id]
    group

theorem sectionFunctorAction_map_comp (A : ASection)
    {X Y Z : GreatCircle.Base} (f : X ⟶ Y) (g : Y ⟶ Z)
    {I J : SphereWorld} (φ : I ⟶ J) :
    (distinguishedWorldAction ((sectionFunctor A).map (f ≫ g)).mob).map φ =
      (distinguishedWorldAction ((sectionFunctor A).map g).mob).map
        ((distinguishedWorldAction ((sectionFunctor A).map f).mob).map φ) := by
  apply SphereHom.ext
  · rfl
  · change projectiveArrowElement A (f ≫ g) * φ.mob *
        (projectiveArrowElement A (f ≫ g))⁻¹ =
      projectiveArrowElement A g *
        (projectiveArrowElement A f * φ.mob *
          (projectiveArrowElement A f)⁻¹) *
        (projectiveArrowElement A g)⁻¹
    rw [projectiveArrowElement_comp]
    group

/-- The objects of the exact total `𝒯_A`: a projective footpoint together
with a sphere produced by the A-positioned object action at that footpoint. -/
structure TotalA (A : ASection) where
  base : GreatCircle.Base
  fiber : SphereWorld

/-- An arrow of `𝒯_A`: a base arrow together with the sphere arrow after the
matching full orbit--stabilizer transition. -/
structure TotalHom (A : ASection) (X Y : A.TotalA) where
  base : X.base ⟶ Y.base
  fiber :
    (distinguishedWorldAction ((sectionFunctor A).map base).mob).obj
        X.fiber ⟶ Y.fiber

theorem TotalHom.ext (A : ASection) {X Y : A.TotalA}
    (f g : TotalHom A X Y) (hbase : f.base = g.base)
    (hfiber : eqToHom (by rw [hbase]) ≫ f.fiber = g.fiber) : f = g := by
  cases f
  cases g
  cases hbase
  simp_all

private def totalId (A : ASection) (X : A.TotalA) : TotalHom A X X where
  base := 𝟙 X.base
  fiber := 𝟙 X.fiber

private def totalComp (A : ASection) {X Y Z : A.TotalA}
    (f : TotalHom A X Y) (g : TotalHom A Y Z) : TotalHom A X Z where
  base := f.base ≫ g.base
  fiber :=
    (distinguishedWorldAction
      ((sectionFunctor A).map g.base).mob).map f.fiber ≫ g.fiber

instance (A : ASection) : Category A.TotalA where
  Hom := TotalHom A
  id X := totalId A X
  comp f g := totalComp A f g
  id_comp f := by
    cases f
    simp [totalComp, totalId, distinguishedWorldAction]
  comp_id f := by
    cases f
    simp [totalComp, totalId, distinguishedWorldAction,
      projectiveArrowElement_id]
    apply SphereHom.ext <;> rfl
  assoc f g h := by
    cases f
    cases g
    cases h
    simp [totalComp, distinguishedWorldAction,
      projectiveArrowElement_comp, Category.assoc]
    apply SphereHom.ext
    · rfl
    · group

/-- Objects of `𝒯_A` are precisely a projective footpoint together with a
sphere world. -/
def totalMk (A : ASection) (b : GreatCircle.Base) (I : SphereWorld) :
    A.TotalA :=
  ⟨b, (projectiveObjectAction A b).obj I⟩

/-- Build a total arrow by applying the exact orbit--stabilizer transition to
the supplied sphere arrow before placing it over the base arrow. -/
def totalHomMk (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    {I J : SphereWorld} (φ : I ⟶ J) :
    totalMk A X I ⟶ totalMk A Y J := by
  refine ⟨f, ?_⟩
  change I ⟶ J
  exact (distinguishedWorldAction ((sectionFunctor A).map f).mob).map φ

@[simp] theorem totalMk_base (A : ASection) (b : GreatCircle.Base)
    (I : SphereWorld) : (totalMk A b I).base = b := rfl

@[simp] theorem totalMk_world (A : ASection) (b : GreatCircle.Base)
    (I : SphereWorld) :
    (totalMk A b I).fiber = (projectiveObjectAction A b).obj I := rfl

/-- The C3 n-th zero output in world `I`, at its own projective footpoint. -/
def zeroTotal (A : ASection) (n : ℕ) (I : SphereWorld) : A.TotalA :=
  totalMk A (normalizedFootpoint (A.sphereZero n).re) I

/-- The common compactified witness in world `I`. -/
def northTotal (A : ASection) (I : SphereWorld) : A.TotalA :=
  totalMk A
    (GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point)) I

@[simp] theorem zeroTotal_base (A : ASection) (n : ℕ) (I : SphereWorld) :
    (zeroTotal A n I).base =
      normalizedFootpoint (A.sphereZero n).re := rfl

@[simp] theorem zeroTotal_world (A : ASection) (n : ℕ) (I : SphereWorld) :
    (zeroTotal A n I).fiber =
      (projectiveObjectAction A
        (normalizedFootpoint (A.sphereZero n).re)).obj I := rfl

@[simp] theorem northTotal_base (A : ASection) (I : SphereWorld) :
    (northTotal A I).base =
      GreatCircle.pointObj (OnePoint.infty : GreatCircle.Point) := rfl

@[simp] theorem northTotal_world (A : ASection) (I : SphereWorld) :
    (northTotal A I).fiber =
      (projectiveObjectAction A
        (GreatCircle.pointObj
          (OnePoint.infty : GreatCircle.Point))).obj I := rfl

/-- The wholesale total transport induced by a base arrow. -/
def totalTransport (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    (I : SphereWorld) : totalMk A X I ⟶ totalMk A Y I :=
  totalHomMk A f (𝟙 I)

/-- C3 supplies every indexed zero output in every sphere world. -/
theorem zeroTotal_populated (A : ASection) (n : ℕ) (I : SphereWorld) :
    ∃ X : A.TotalA, X = zeroTotal A n I :=
  ⟨zeroTotal A n I, rfl⟩

/-- C4 supplies the infinite output population. -/
theorem zeroTotal_c4_infinite (A : ASection) :
    (Set.range A.sphereZero).Infinite :=
  A.c4_infinite

end ASection
