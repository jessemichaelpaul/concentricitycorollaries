import Concentricity.ZetaSection
import Concentricity.ZetaDivisor
import Concentricity.RhEquiv

noncomputable section

/-!
Focused receipts for the corollary layer.  Each theorem consumes the exact
upstream conclusion used by the production corollary; no corollary adds a
new inference seat.
-/

theorem ASection.nontrivial_one_centre_of_concentricity_audit
    (A : ASection)
    (hconcentricity : ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c) :
    ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c :=
  hconcentricity

theorem zeta_riemannHypothesis_of_concentricity_audit
    (hconcentricity :
      ∃ c : ℝ, ∀ n : ℕ, (zetaSection.sphereZero n).re = c) :
    RiemannHypothesis := by
  obtain ⟨c, hc⟩ := hconcentricity
  refine riemannHypothesis_iff_concentric.mpr ⟨c, fun σ γ hγ hz => ?_⟩
  obtain ⟨n, hn⟩ :=
    zetaSphereZero_surjective (s := (⟨σ, γ⟩ : ℂ)) ⟨hz, hγ⟩
  have hcn : (zetaSphereZero n).re = c := hc n
  rw [hn] at hcn
  exact hcn

theorem zeta_criticalLine_zeros_infinite_of_RH_audit
    (hRH : RiemannHypothesis) :
    {s : ℂ | riemannZeta s = 0 ∧ s.re = 1 / 2}.Infinite := by
  refine Set.Infinite.mono ?_ riemannZeta_nontrivialZeros_infinite
  intro s hs
  exact ⟨hs.1, hRH s hs.1 hs.2.1 hs.2.2⟩

#check @ASection.nontrivial_one_centre_of_concentricity_audit
#check @zeta_riemannHypothesis_of_concentricity_audit
#check @zeta_criticalLine_zeros_infinite_of_RH_audit

#print axioms ASection.nontrivial_one_centre_of_concentricity_audit
#print axioms zeta_riemannHypothesis_of_concentricity_audit
#print axioms zeta_criticalLine_zeros_infinite_of_RH_audit
