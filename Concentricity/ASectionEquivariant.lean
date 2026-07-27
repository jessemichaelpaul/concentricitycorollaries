/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Concentricity.Slice

/-!
# The underlying equivariant action of an A-section

An A-section is not merely a family of values attached to the octonionic
world.  Its realization is `G₂`-equivariant, so it acts functorially on the
octonionic action groupoid `H1 = G₂ ⋉ 𝕆*`.

This is the canonical point-valued function eye of the distinguished
A-section action. The same action is swept across the projective base by
its orbit--stabilizer squares in `AsectionActionDiagram`. It must not be
replaced by the direction-only `AsectionSlice` projection.
-/

noncomputable section

open CategoryTheory

namespace ASection

/-- The equivariance square of the compactified A-realization, expressed as
a natural transformation of the `G₂` action on `𝕆*`. -/
def realizeNatTrans (A : ASection) :
    CategoryTheory.actionAsFunctor G2 (OnePoint Octonion) ⟶
      CategoryTheory.actionAsFunctor G2 (OnePoint Octonion) where
  app _ := ↾A.realize
  naturality := by
    intro X Y g
    ext q
    exact A.realize_equivariant g q

/-- The genuine point-valued slice functor of an A-section.

On objects it is the compactified slice-preserving realization `A.realize`.
On arrows it retains the same `G₂` element; `realize_equivariant` is exactly
the required naturality square. -/
def AsectionEquivariant (A : ASection) : H1 ⥤ H1 :=
  CategoryTheory.NatTrans.mapElements A.realizeNatTrans

@[simp] theorem AsectionEquivariant_obj (A : ASection) (q : H1) :
    (A.AsectionEquivariant).obj q = ⟨q.fst, A.realize q.back⟩ := rfl

@[simp] theorem AsectionEquivariant_map_val (A : ASection)
    {q r : H1} (f : q ⟶ r) :
    ((A.AsectionEquivariant).map f).val = f.val := rfl

end ASection
