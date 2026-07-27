/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.ASectionEquivariant
import Concentricity.ProjectiveTransport

/-!
# An unfolded formula for the canonical A-section action

The compactified stem action `A.Fstar` is evaluated in the normalized slice
coordinate and then realized in that point's own octonionic slice.  This is
the global, action-generated face of the A-section round trip.  It is defined
on all of `H1 = G₂ ⋉ 𝕆*`; no Euler half-space or nonvanishing hypothesis
occurs in its carrier or functor type.

The canonical functor is `AsectionEquivariant`. The declarations below give
an independent `A.Fstar` formula for its object map and prove the two
formulae equal. They are coherence receipts for one function, not a second
A-section action and not a dependency of `AsectionActionDiagram`.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-- Evaluate the complete compactified stem action in the octonionic slice
of its input.

At a finite octonion, `A.Fstar` supplies the full C1-continued stem value and
`spherePt` realizes it in the input direction.  At the compactification point
`N`, C1's compactified real datum is realized on the common real axis.  The
output is therefore an unfolded formula for the same function represented
canonically by `A.realize`. -/
noncomputable def generatedRealize (A : ASection)
    (q : OnePoint Octonion) : OnePoint Octonion :=
  OnePoint.rec
    (OnePoint.map (fun z : ℂ => Octonion.ofReal z.re)
      (A.Fstar OnePoint.infty))
    (fun x =>
      spherePt (Octonion.dir x)
        (A.Fstar ((Octonion.sliceCoord x : ℂ) : OnePoint ℂ)))
    q

@[simp] theorem generatedRealize_infty (A : ASection) :
    A.generatedRealize OnePoint.infty =
      OnePoint.map (fun z : ℂ => Octonion.ofReal z.re)
        (A.Fstar OnePoint.infty) :=
  rfl

@[simp] theorem generatedRealize_coe (A : ASection) (x : Octonion) :
    A.generatedRealize (x : OnePoint Octonion) =
      spherePt (Octonion.dir x)
        (A.Fstar
          ((Octonion.sliceCoord x : ℂ) : OnePoint ℂ)) :=
  rfl

/-- The compactified `A.Fstar` formula and `A.realize` are the same global
A-action.

This is not definitional bookkeeping: at a finite point it uses C1 to
separate the unique simple pole from the analytic chart, while at `N` it
uses the compactified value carried by the section. The theorem compares
two complete presentations of the one distinguished action; the particular
rewrite path below does not partition that action's simultaneous geometric
readings. -/
theorem generatedRealize_eq_realize (A : ASection)
    (q : OnePoint Octonion) :
    A.generatedRealize q = A.realize q := by
  induction q using OnePoint.rec with
  | infty =>
      rw [generatedRealize_infty, A.Fstar_infty, A.realize_infty]
  | coe x =>
      rw [generatedRealize_coe, A.realize_coe]
      by_cases hp : Octonion.sliceCoord x = (A.pole : ℂ)
      · have hnot : ¬ AnalyticAt ℂ A.F (Octonion.sliceCoord x) := by
          intro han
          have hnonneg :
              0 ≤ meromorphicOrderAt A.F (A.pole : ℂ) := by
            rw [← hp]
            exact han.meromorphicOrderAt_nonneg
          rw [A.c1_simple] at hnonneg
          have hbad : (0 : ℤ) ≤ -1 := by
            exact_mod_cast hnonneg
          norm_num at hbad
        rw [if_neg hnot, hp, A.Fstar_pole, spherePt_infty]
      · rw [if_pos (A.c1_analyticAt _ hp), A.Fstar_coe _ hp,
          spherePt_coe]

/-- The globally generated realization is `G₂`-equivariant.  The stem
coordinate is invariant under `G₂`, while the slice chart is transported by
the same action.  At `N`, the compactified value is real and hence fixed. -/
theorem generatedRealize_equivariant (A : ASection) (g : G2)
    (q : OnePoint Octonion) :
    A.generatedRealize (g • q) = g • A.generatedRealize q := by
  induction q using OnePoint.rec with
  | infty =>
    rw [G2.smul_onePoint_infty, generatedRealize_infty, A.Fstar_infty]
    induction hval : A.valueAtInfinity using OnePoint.rec with
    | infty =>
      rw [OnePoint.map_infty]
      rfl
    | coe z =>
      rw [OnePoint.map_some, G2.smul_onePoint_coe, G2.smul_ofReal]
  | coe x =>
    rw [G2.smul_onePoint_coe, generatedRealize_coe,
      generatedRealize_coe, sliceCoord_smul_invariant,
      G2.smul_dir, smul_spherePt]

/-- The equivariance square of the generated compactified stem action. -/
def generatedRealizeNatTrans (A : ASection) :
    CategoryTheory.actionAsFunctor G2 (OnePoint Octonion) ⟶
      CategoryTheory.actionAsFunctor G2 (OnePoint Octonion) where
  app _ := ↾A.generatedRealize
  naturality := by
    intro X Y g
    ext q
    exact A.generatedRealize_equivariant g q

/-- The global action-generated A-section round trip on compactified
octonions.

Its object map evaluates `A.Fstar` in the normalized slice coordinate; its
arrow map retains the native `G₂` element.  The public type is total on
`H1`, with no half-space or nonvanishing binder. -/
def AsectionGenerated (A : ASection) : H1 ⥤ H1 :=
  CategoryTheory.NatTrans.mapElements A.generatedRealizeNatTrans

@[simp] theorem AsectionGenerated_obj (A : ASection) (q : H1) :
    (A.AsectionGenerated).obj q =
      ⟨q.fst, A.generatedRealize q.back⟩ :=
  rfl

@[simp] theorem AsectionGenerated_map_val (A : ASection)
    {q r : H1} (f : q ⟶ r) :
    ((A.AsectionGenerated).map f).val = f.val :=
  rfl

/-- Equality of two formulae for the one A-specific distinguished action.
The equality is proved from their object maps and common native `G₂`
transport; it is not obtained by defining the unfolded formula through
`A.realize`. -/
theorem AsectionGenerated_eq_equivariant (A : ASection) :
    A.AsectionGenerated = A.AsectionEquivariant := by
  have h :
      A.generatedRealizeNatTrans = A.realizeNatTrans := by
    apply CategoryTheory.NatTrans.ext
    funext X
    ext q
    exact A.generatedRealize_eq_realize q
  exact congrArg CategoryTheory.NatTrans.mapElements h

/-- The natural equality certificate between the unfolded and canonical
round-trip formulae for the one distinguished A-action. -/
def AsectionGenerated_iso_equivariant (A : ASection) :
    A.AsectionGenerated ≅ A.AsectionEquivariant :=
  eqToIso A.AsectionGenerated_eq_equivariant

end ASection
