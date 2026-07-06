/-
Concentricity/ZetaDivisor.lean

Island C1, stage 1 (author ruling 2026-07-05: "divisor-repeated enumeration
and infinite Weierstrass through the pole N"): the DIVISOR-REPEATED
enumeration of ζ's upper-half zeros — the `sphereZero` data of the
`zetaSection` instance (`cor:zeta-section`), each zero repeated per its
analytic multiplicity, so the gated `c3_factorization` row is
unconditionally faithful (no hidden simplicity-of-zeros assumption; R8:
a sorry must never be UNSOUND, and simplicity of ζ's zeros is open).

All PROVED, from pinned Mathlib + in-repo stock only:
- the upper-half zero set is countable (discreteness:
  `IsCompact.inter_riemannZetaZeros_finite` over a ball cover) and
  infinite (`riemannZeta_nontrivialZeros_infinite` folded to the upper
  half by the conjugation pin + cluster 4);
- the multiplicity (`analyticOrderAt`) is positive and finite at each
  zero (finite by the identity theorem on the connected ℂ∖{1} against
  ζ(2) ≠ 0);
- the pairs (zero, index < multiplicity) biject with ℕ
  (`nonempty_denumerable_iff`), giving the enumeration together with
  membership, completeness, and the infinite range (C4's engine).

The fiber-cardinality readout (fiber over each zero = its multiplicity)
is definitionally carried by the pairs construction and is stated at the
`c3_factorization` closure, where it is first consumed.

`sorry` marks UNFORMALIZED, never UNSOUND (R8). This file targets ZERO
sorries.
-/
import Concentricity.ZetaStrip
import Concentricity.ZetaConj
import Concentricity.ZetaPole
import Concentricity.ZetaRealZeros
import Concentricity.ZetaInfinitude
import Mathlib.NumberTheory.LSeries.ZetaZeros
import Mathlib.Logic.Denumerable
import Mathlib.Analysis.Analytic.Order

noncomputable section

open Complex

/-- The upper-half zeros of ζ — automatically nontrivial (non-real). -/
def zetaUpperZeros : Set ℂ := {s : ℂ | riemannZeta s = 0 ∧ 0 < s.im}

/-- Countability, from discreteness: each closed ball meets the zero set
finitely (`IsCompact.inter_riemannZetaZeros_finite`), and countably many
balls cover ℂ. PROVED. -/
theorem zetaUpperZeros_countable : zetaUpperZeros.Countable := by
  have hcover : zetaUpperZeros
      ⊆ ⋃ n : ℕ, Metric.closedBall (0 : ℂ) n ∩ riemannZetaZeros := by
    intro s hs
    obtain ⟨n, hn⟩ := exists_nat_ge ‖s‖
    refine Set.mem_iUnion.mpr ⟨n, ?_, ?_⟩
    · simpa [Metric.mem_closedBall, dist_zero_right] using hn
    · rw [mem_riemannZetaZeros]
      exact hs.1
  refine Set.Countable.mono hcover ?_
  exact Set.countable_iUnion fun n =>
    ((isCompact_closedBall _ _).inter_riemannZetaZeros_finite).countable

/-- Infinitude, folded to the upper half: the proved nontrivial-zero
infinitude, with cluster 4 (every nontrivial zero non-real) and the
conjugation pin covering the lower half. PROVED. -/
theorem zetaUpperZeros_infinite : zetaUpperZeros.Infinite := by
  intro hfin
  apply riemannZeta_nontrivialZeros_infinite
  have hcover : {s : ℂ | riemannZeta s = 0 ∧ (¬∃ n : ℕ, s = -2 * (n + 1)) ∧ s ≠ 1}
      ⊆ ⋃ u ∈ zetaUpperZeros, ({u, (starRingEnd ℂ) u} : Set ℂ) := by
    intro s hs
    have him := nontrivialZero_im_ne_zero hs.1 hs.2.1 hs.2.2
    rcases lt_or_gt_of_ne him with hneg | hpos
    · have hmem : (starRingEnd ℂ) s ∈ zetaUpperZeros := by
        refine ⟨?_, ?_⟩
        · rw [riemannZeta_conj, hs.1, map_zero]
        · rw [Complex.conj_im]
          linarith
      refine Set.mem_biUnion hmem ?_
      rw [Set.mem_insert_iff, Set.mem_singleton_iff]
      right
      rw [starRingEnd_self_apply]
    · exact Set.mem_biUnion (⟨hs.1, hpos⟩ : s ∈ zetaUpperZeros)
        (Set.mem_insert _ _)
  exact (hfin.biUnion fun u _ => (Set.finite_singleton _).insert _).subset hcover

/-- The multiplicity of a ζ-zero — the analytic order as a natural number
(the divisor value). -/
def zetaZeroMult (s : ℂ) : ℕ := analyticOrderNatAt riemannZeta s

/-- At an upper-half zero the multiplicity is positive and finite:
nonzero because ζ is analytic there and vanishes
(`analyticOrderAt_ne_zero`), finite because ζ ≡ 0 near a point would
propagate over the connected ℂ∖{1} to ζ(2) = 0 (the ZetaConj identity-
theorem pattern) against the pinned nonvanishing. PROVED. -/
theorem zetaZeroMult_pos {s : ℂ} (hs : s ∈ zetaUpperZeros) :
    0 < zetaZeroMult s := by
  have hs1 : s ≠ 1 := by
    intro h
    have h2 := hs.2
    rw [h] at h2
    simp at h2
  have hne_top : analyticOrderAt riemannZeta s ≠ ⊤ := by
    intro htop
    have hev := analyticOrderAt_eq_top.mp htop
    have hζ : AnalyticOnNhd ℂ riemannZeta ({(1 : ℂ)}ᶜ : Set ℂ) := fun z hz =>
      riemannZeta_analyticAt (Set.mem_compl_singleton_iff.mp hz)
    have h0 : AnalyticOnNhd ℂ (fun _ : ℂ => (0 : ℂ)) ({(1 : ℂ)}ᶜ : Set ℂ) :=
      fun _ _ => analyticAt_const
    have hUconn : IsPreconnected ({(1 : ℂ)}ᶜ : Set ℂ) := by
      refine (isConnected_compl_singleton_of_one_lt_rank ?_ 1).isPreconnected
      rw [← Module.finrank_eq_rank, Complex.finrank_real_complex]
      exact_mod_cast one_lt_two
    have hEq := hζ.eqOn_of_preconnected_of_eventuallyEq h0 hUconn
      (Set.mem_compl_singleton_iff.mpr hs1) hev
    have h2 : riemannZeta 2 = 0 :=
      hEq (by norm_num : (2 : ℂ) ∈ ({(1 : ℂ)}ᶜ : Set ℂ))
    exact riemannZeta_ne_zero_of_one_le_re (by norm_num) h2
  have hne0 : analyticOrderAt riemannZeta s ≠ 0 :=
    analyticOrderAt_ne_zero.mpr ⟨riemannZeta_analyticAt hs1, hs.1⟩
  refine Nat.pos_of_ne_zero fun h0 => ?_
  rcases ENat.toNat_eq_zero.mp h0 with h | h
  · exact hne0 h
  · exact hne_top h

/-- The divisor as a set of pairs: (zero, repetition index below its
multiplicity) — the multiset carrier of the repeated enumeration. -/
def zetaZeroPairs : Set (ℂ × ℕ) :=
  {p | p.1 ∈ zetaUpperZeros ∧ p.2 < zetaZeroMult p.1}

theorem zetaZeroPairs_countable : zetaZeroPairs.Countable :=
  Set.Countable.mono
    (fun p hp => Set.mem_prod.mpr ⟨hp.1, Set.mem_univ p.2⟩)
    (zetaUpperZeros_countable.prod Set.countable_univ)

theorem zetaZeroPairs_infinite : zetaZeroPairs.Infinite := by
  have hinj : Set.InjOn (fun s : ℂ => ((s, 0) : ℂ × ℕ)) zetaUpperZeros :=
    fun a _ b _ h => congrArg Prod.fst h
  have himg : (fun s : ℂ => ((s, 0) : ℂ × ℕ)) '' zetaUpperZeros
      ⊆ zetaZeroPairs := by
    rintro p ⟨s, hs, rfl⟩
    exact ⟨hs, zetaZeroMult_pos hs⟩
  exact (zetaUpperZeros_infinite.image hinj).mono himg

/-- The bijective enumeration of the divisor pairs
(`nonempty_denumerable_iff`: countable + infinite). -/
noncomputable def zetaZeroEnum : ℕ ≃ ↥zetaZeroPairs :=
  haveI hc : Countable ↥zetaZeroPairs := zetaZeroPairs_countable.to_subtype
  haveI hi : Infinite ↥zetaZeroPairs := zetaZeroPairs_infinite.to_subtype
  haveI := (nonempty_denumerable_iff.mpr ⟨hc, hi⟩).some
  (Denumerable.eqv _).symm

/-- **The divisor-repeated enumeration** — the `sphereZero` data of
`cor:zeta-section` (author ruling 2026-07-05): each upper-half zero
appears exactly its multiplicity many times, through the pairs
bijection. -/
noncomputable def zetaSphereZero (n : ℕ) : ℂ :=
  ((zetaZeroEnum n : ↥zetaZeroPairs) : ℂ × ℕ).1

theorem zetaSphereZero_mem (n : ℕ) : zetaSphereZero n ∈ zetaUpperZeros :=
  (zetaZeroEnum n).2.1

/-- Feeds `c3_sphere_nonreal`. -/
theorem zetaSphereZero_im_pos (n : ℕ) : 0 < (zetaSphereZero n).im :=
  (zetaSphereZero_mem n).2

theorem zetaSphereZero_zero (n : ℕ) : riemannZeta (zetaSphereZero n) = 0 :=
  (zetaSphereZero_mem n).1

/-- Completeness: every upper-half zero is enumerated (the divisor
surjects). PROVED. -/
theorem zetaSphereZero_surjective {s : ℂ} (hs : s ∈ zetaUpperZeros) :
    ∃ n, zetaSphereZero n = s := by
  refine ⟨zetaZeroEnum.symm ⟨(s, 0), hs, zetaZeroMult_pos hs⟩, ?_⟩
  rw [zetaSphereZero, Equiv.apply_symm_apply]

/-- The range is exactly the upper-half zero set. PROVED. -/
theorem zetaSphereZero_range : Set.range zetaSphereZero = zetaUpperZeros := by
  ext s
  constructor
  · rintro ⟨n, rfl⟩
    exact zetaSphereZero_mem n
  · exact zetaSphereZero_surjective

/-- C4's engine at the enumeration: the range is infinite (feeds
`c4_infinite`). PROVED. -/
theorem zetaSphereZero_range_infinite :
    (Set.range zetaSphereZero).Infinite := by
  rw [zetaSphereZero_range]
  exact zetaUpperZeros_infinite
