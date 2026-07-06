/-
Concentricity/ZetaDensity.lean

The D0 summability obligation, ζ-member payoff row. The density itself
(Jensen + dyadic shells) lives in ZetaDensityCore.lean, below ZetaSection,
where it discharges the `c3_atN` field (C3 THROUGH N). With the class row
`ASection.liSum_summable` closed from `c3_atN`, this file's payoff row is
the specialization to `zetaSection` — kept as the named D0-for-ζ receipt.

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file carries ZERO
sorries.
-/
import Concentricity.ZetaDensityCore
import Concentricity.LiKernel
import Concentricity.ZetaSection

noncomputable section

/-! ## The D0 summability obligation, closed for the ζ member -/

/-- **D0 for ζ** (the obligation of DESIGN §D0, member face): the paired
kernel sums of `zetaSection` converge — the class row
`ASection.liSum_summable`, closed from `c3_atN` (C3 THROUGH N) through the
PROVED reduction `liSum_summable_of_density_at`, read at the member. With
this, the BL ladder's D0 rung is green for the member that `cor:rh`
consumes — and for the class, by the same clause. PROVED. -/
theorem zetaSection_liSum_summable (a β : ℝ) (n : ℕ) :
    Summable fun k => 2 * (liKernel n a β (zetaSection.sphereZero k)).re :=
  zetaSection.liSum_summable a β n
