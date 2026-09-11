import Concentricity.ASectionActionDiagram

noncomputable section
open CategoryTheory

namespace ASection

/-- master `thm:slice-exp`, `rmk:gpv-real-fibre`: represent a GPV branch
in the slice direction of an existing A-section state. -/
def stateGpvGenerator (A : ASection) (w : ℂ) (x : AsectionState A) : Octonion :=
  Octonion.sliceEmbed x.world.val w

theorem stateGpvGenerator_equivariant (A : ASection) (w : ℂ)
    (g : G2) (x : AsectionState A) :
    stateGpvGenerator A w (g • x) = g • stateGpvGenerator A w x := by
  exact (G2.smul_sliceEmbed g x.world.val w).symm

/-- Slice exponentiation of the carried GPV generator. -/
theorem stateGpvGenerator_exp (A : ASection) (w : ℂ) (x : AsectionState A) :
    Octonion.exp (stateGpvGenerator A w x) =
      Octonion.sliceEmbed x.world.val (Complex.exp w) :=
  Octonion.exp_sliceEmbed' x.world.prop w

/-- The real face is obtained from this generator in its actual slice. -/
theorem stateGpvGenerator_re (A : ASection) (w : ℂ) (x : AsectionState A) :
    Octonion.re (stateGpvGenerator A w x) = w.re :=
  Octonion.re_sliceEmbed x.world.prop w

def stateGpvGeneratorNatTrans (A : ASection) (w : ℂ) :
    actionAsFunctor G2 (AsectionState A) ⟶
      actionAsFunctor G2 (OnePoint Octonion) where
  app _ := ↾fun x => (stateGpvGenerator A w x : OnePoint Octonion)
  naturality := by
    intro X Y g
    ext x
    change (stateGpvGenerator A w ((show G2 from g) • (show AsectionState A from x)) : OnePoint Octonion) =
      (show G2 from g) • (stateGpvGenerator A w x : OnePoint Octonion)
    rw [stateGpvGenerator_equivariant, G2.smul_onePoint_coe]

/-- The GPV generator is carried by the same G₂ arrow as the A-state. -/
def stateGpvGeneratorFunctor (A : ASection) (w : ℂ) :
    AsectionStateWorld A ⥤ H1 :=
  NatTrans.mapElements (stateGpvGeneratorNatTrans A w)

/-- The projective transport preserves the generator in its slice. -/
theorem stateGpvGeneratorFunctor_transport (A : ASection) (w : ℂ) (m : Moebius) :
    coordinateTransport A m ⋙ stateGpvGeneratorFunctor A w =
      stateGpvGeneratorFunctor A w := by
  exact CategoryTheory.Functor.ext (fun _ => rfl) (fun _ _ _ => rfl)

def actionGpvGeneratorFunctor (A : ASection) (w : ℂ) (m : Moebius) :
    AsectionActionStateWorld A m ⥤ H1 :=
  AsectionActionStateInput A m ⋙ stateGpvGeneratorFunctor A w

/-- Compatibility with the complete state transport, before taking totals
or restricting to residues. -/
theorem actionGpvGeneratorFunctor_transport (A : ASection) (w : ℂ)
    {m n : Moebius} (s : ActionTransportSquare m n) :
    s.actionStateTransport A ⋙ actionGpvGeneratorFunctor A w n =
      actionGpvGeneratorFunctor A w m := by
  exact CategoryTheory.Functor.ext (fun _ => rfl) (fun _ _ _ => rfl)

/-- The real face of the GPV generator on a fibre of A_A. -/
def actionGpvRealFace (A : ASection) (w : ℂ) (m : Moebius) :
    AsectionActionStateWorld A m ⥤ Discrete ℝ where
  obj x := ⟨Octonion.re (stateGpvGenerator A w x.input.back)⟩
  map {x y} _ := eqToHom (by
    apply Discrete.ext
    exact (stateGpvGenerator_re A w x.input.back).trans
      (stateGpvGenerator_re A w y.input.back).symm)

/-- The real GPV face is natural under the existing state transport. -/
theorem actionGpvRealFace_transport (A : ASection) (w : ℂ)
    {m n : Moebius} (s : ActionTransportSquare m n) :
    s.actionStateTransport A ⋙ actionGpvRealFace A w n =
      actionGpvRealFace A w m := by
  exact CategoryTheory.Functor.ext (fun _ => rfl)
    (fun _ _ _ => Subsingleton.elim _ _)

/-- master `lem:finite-pole-arrival`, `rmk:gpv-real-fibre`: the pole
generator on all fibres of the already-constructed A_A. -/
def poleGpvGeneratorFace (A : ASection) :
    AsectionActionDiagram A ⟶
      (Functor.const GreatCircle.Base).obj (Grpd.of H1) where
  app X := actionGpvGeneratorFunctor A A.distinguishedPoleLog
    (projectiveObjectFrame A X)
  naturality X Y f := by
    change AsectionActionTransport A f ⋙ _ = _ ⋙ 𝟭 H1
    rw [Functor.comp_id]
    exact actionGpvGeneratorFunctor_transport A A.distinguishedPoleLog
      (orbitStabilizerActionSquare A f)

/-- The GPV real face carried naturally by A_A. Its scalar value is proved
from slice exponentiation and branch uniqueness, not assumed as a state field. -/
def poleGpvRealFace (A : ASection) :
    AsectionActionDiagram A ⟶
      (Functor.const GreatCircle.Base).obj (Grpd.of (Discrete ℝ)) where
  app X := actionGpvRealFace A A.distinguishedPoleLog (projectiveObjectFrame A X)
  naturality X Y f := by
    change AsectionActionTransport A f ⋙ _ = _ ⋙ 𝟭 (Discrete ℝ)
    rw [Functor.comp_id]
    exact actionGpvRealFace_transport A A.distinguishedPoleLog
      (orbitStabilizerActionSquare A f)

/-- Every arriving GPV branch gives the same real-face functor. -/
theorem poleGpvRealFace_arrival (A : ASection) {Z : GreatCircle.Base}
    (τ : GpvTransport A Z (projectivePole A)) (X : GreatCircle.Base) :
    actionGpvRealFace A (τ.lift 1) (projectiveObjectFrame A X) =
      (poleGpvRealFace A).app X := by
  refine CategoryTheory.Functor.ext (fun x => ?_)
    (fun _ _ _ => Subsingleton.elim _ _)
  apply Discrete.ext
  exact (stateGpvGenerator_re A (τ.lift 1) x.input.back).trans
    (τ.level_at_pole.trans
      (stateGpvGenerator_re A A.distinguishedPoleLog x.input.back).symm)

/-- Every member of the pole exponential fibre induces this same real
face, whether or not a particular arriving run has been chosen. -/
theorem poleGpvRealFace_branch (A : ASection) (w : ℂ)
    (hw : Complex.exp w = A.distinguishedPoleFactor (A.pole : ℂ))
    (X : GreatCircle.Base) :
    actionGpvRealFace A w (projectiveObjectFrame A X) =
      (poleGpvRealFace A).app X := by
  let τ : GpvTransport A (projectivePole A) (projectivePole A) :=
    GpvTransport.refl A A.pole A.distinguishedPoleFactor_ne_zero
  have hr : w.re = A.distinguishedPoleLog.re :=
    (τ.target_fibre_state_and_level w (hw.trans τ.value_one_pole.symm)).2.trans
      τ.level_at_pole
  refine CategoryTheory.Functor.ext (fun x => ?_)
    (fun _ _ _ => Subsingleton.elim _ _)
  apply Discrete.ext
  exact (stateGpvGenerator_re A w x.input.back).trans
    (hr.trans (stateGpvGenerator_re A A.distinguishedPoleLog x.input.back).symm)

/-- master `lem:exp-degenerate`: the complete direction-and-winding fibre
induces the same natural real face on A_A. -/
theorem poleGpvRealFace_full_fibre (A : ASection)
    {r : ℝ} (hr : 0 < r)
    (hu : A.distinguishedPoleFactor (A.pole : ℂ) = -(r : ℂ))
    (q : Octonion) (hq : Octonion.exp q = Octonion.ofReal (-r)) :
    ∃ I : SphereWorld, ∃ k : ℤ,
      q = Octonion.sliceEmbed I.val
        ⟨Real.log r, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩ ∧
      Octonion.re q = Real.log r ∧
      ∀ X : GreatCircle.Base,
        actionGpvRealFace A
          ⟨Real.log r, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩
          (projectiveObjectFrame A X) = (poleGpvRealFace A).app X := by
  let τ : GpvTransport A (projectivePole A) (projectivePole A) :=
    GpvTransport.refl A A.pole A.distinguishedPoleFactor_ne_zero
  have hv : τ.value 1 = -(r : ℂ) := τ.value_one_pole.trans hu
  obtain ⟨I, k, hq', _, hreal⟩ :=
    (τ.degenerate_fibre_action 1 hr hv q).mp hq
  refine ⟨I, k, hq', hreal, fun X => poleGpvRealFace_branch A _ ?_ X⟩
  rw [hu]
  apply (exp_eq_neg_real_iff hr _).mpr
  refine ⟨k, ?_⟩
  apply Complex.ext <;> simp

end ASection
