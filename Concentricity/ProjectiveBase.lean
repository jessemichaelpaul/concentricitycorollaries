/-
Copyright (c) 2026 Jesse Michael Paul. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jesse Michael Paul
-/
import Mathlib.CategoryTheory.Action
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Projective
import Mathlib.Topology.Compactification.OnePoint.ProjectiveLine

/-!
# The projective great-circle base

The intrinsic base groupoid of the Concentricity construction. Its objects
are the points of the compactified real great circle and its arrows are the
projective real Möbius transformations carrying one point to another.

This file is deliberately section-independent. Analytic data belonging to
an A-section enters only with the indexed section functor and its
Grothendieck construction.
-/

noncomputable section

open scoped MatrixGroups

namespace GreatCircle

/-- The object carrier of the base: the compactified real great circle. -/
abbrev Point := OnePoint Real

/-- The full projective real Möbius automorphism group of the great circle. -/
abbrev Aut := PGL(2, Real)

/-- Scalar matrices act trivially on the projective line. This is the
descent condition for Mathlib's native `GL(2, ℝ)` action on `OnePoint ℝ`. -/
@[simp]
theorem scalar_smul (u : Realˣ) (x : Point) :
    Matrix.GeneralLinearGroup.scalar (Fin 2) u • x = x := by
  induction x using OnePoint.rec with
  | infty => simp [OnePoint.smul_infty_eq_ite]
  | coe x => simp [OnePoint.smul_some_eq_ite]

/-- The projective Möbius action on the compactified real great circle,
obtained by descending Mathlib's native `GL(2, ℝ)` action through scalar
matrices. -/
instance instMulActionAutPoint : MulAction Aut Point :=
  Matrix.ProjGenLinGroup.mulActionOfGL scalar_smul

/-- A representative matrix acts through its projective class exactly as it
acts through Mathlib's native Möbius action. -/
@[simp]
theorem mk_smul (g : GL (Fin 2) Real) (x : Point) :
    Matrix.ProjGenLinGroup.mk g • x = g • x :=
  Matrix.ProjGenLinGroup.mk_smul scalar_smul g x

/-- The base groupoid `𝒷 = PGL(2, ℝ) ⋉ OnePoint ℝ`. -/
abbrev Base := CategoryTheory.ActionCategory Aut Point

/-- The action category is a groupoid because its acting monoid is a group.
This named witness records the Stage-1 groupoid check in the saved interface. -/
@[reducible] def groupoid : CategoryTheory.Groupoid Base := inferInstance

end GreatCircle
