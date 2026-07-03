/-
Concentricity/Spine.lean

The categorical spine of the Concentricity Theorem. Increment 1 — the ring 𝓡
and the A-section package — lands in Concentricity/StemRing.lean and
Concentricity/ASection.lean; later increments add 𝓗₁, 𝒮₂, Φ, 𝓑, F, 𝒯_A, the
π₀ lemma, and the theorem statement here.

STATEMENT LAYER (CLAUDE.md Phase 3). An earlier uncommitted draft of this file
rendered 𝓡 and the C1–C4 predicates as INTERIM AXIOMS with priced deletion; it
was superseded before committing by the R9 zero-axiom target itself: 𝓡 is
DEFINED by the stem functor over Mathlib's holomorphic functions on ℂ
(StemRing.lean), and `structure ASection` carries C1–C4 as data and properties
of the intrinsic stem (ASection.lean; C2 stated as `Complex.exp (∑' p, ℓ p z)`,
unconditional forms pinned). Declared leaf set: EMPTY — the literal gate is
zero sorries + zero project axioms.

Master references: `def:R`, `thm:wang`, `def:A-section`.
Sources: SOURCES/Wang.md (Rem 2.11), SOURCES/AdF.md, SOURCES/AdFslice.md.

`sorry` marks UNFORMALIZED, never UNSOUND (R8).
-/
import Concentricity.StemRing
import Concentricity.ASection

noncomputable section

namespace Concentricity

/-- Notation `𝓡` for the ring of slice-preserving slice-regular functions in
its stem encoding (master `def:R`; Concentricity/StemRing.lean). -/
scoped notation "𝓡" => StemRing

end Concentricity
