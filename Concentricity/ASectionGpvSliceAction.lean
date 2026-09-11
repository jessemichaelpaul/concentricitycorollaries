import Concentricity.ProjectiveSection

noncomputable section

namespace ASection

/-- master `thm:slice-exp`, `def:gpv-transport`: every instant of the
continued lift exponentiates to the continued value on every octonionic slice. -/
theorem GpvTransport.exp_slice_lift
    {A : ASection} {X Y : GreatCircle.Base} (τ : GpvTransport A X Y)
    (I : SphereWorld) (t : unitInterval) :
    Octonion.exp (Octonion.sliceEmbed I.val (τ.lift t)) =
      Octonion.sliceEmbed I.val (τ.value t) := by
  rw [Octonion.exp_sliceEmbed' I.prop, τ.lift_exp]

/-- master `lem:exp-degenerate`, `def:gpv-transport`: at a negative-real
value of the continued factor, the entire octonionic exponential fibre
generates the transport's matrix. Its direction and winding remain explicit. -/
theorem GpvTransport.degenerate_fibre_action
    {A : ASection} {X Y : GreatCircle.Base} (τ : GpvTransport A X Y)
    (t : unitInterval) {r : ℝ} (hr : 0 < r)
    (hvalue : τ.value t = -(r : ℂ)) (q : Octonion) :
    Octonion.exp q = Octonion.ofReal (-r) ↔
      ∃ I : SphereWorld, ∃ k : ℤ,
        q = Octonion.sliceEmbed I.val
          ⟨Real.log r, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩ ∧
        GreatCircle.diskExpAction
          ⟨Real.log r, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩ =
            GreatCircle.diskExpAction (τ.lift t) ∧
        Octonion.re q = Real.log r := by
  have hfibre := Set.ext_iff.mp (Octonion.exp_fibre_neg_real hr) q
  change (Octonion.exp q = Octonion.ofReal (-r) ↔
    ∃ v ∈ Octonion.unitImaginarySphere, ∃ k : ℤ,
      q = Octonion.sliceEmbed v
        ⟨Real.log r, ((2 * k + 1 : ℤ) : ℝ) * Real.pi⟩) at hfibre
  constructor
  · intro hq
    obtain ⟨v, hv, k, hq⟩ := hfibre.mp hq
    refine ⟨⟨v, hv⟩, k, hq, ?_, ?_⟩
    · apply congrArg GreatCircle.diskDiagonalMoebiusHom
      apply Units.ext
      change Complex.exp _ = Complex.exp (τ.lift t)
      rw [τ.lift_exp, hvalue]
      apply (exp_eq_neg_real_iff hr _).mpr
      refine ⟨k, ?_⟩
      apply Complex.ext <;> simp
    · rw [hq, Octonion.re_sliceEmbed hv]
  · rintro ⟨I, k, hq, _, _⟩
    exact hfibre.mpr ⟨I.val, I.prop, k, hq⟩

/-- master `lem:finite-pole-arrival`: the octonionic slice exponential
arrives at the continued pole multiplier on every slice. -/
theorem GpvTransport.exp_slice_lift_at_pole
    {A : ASection} {X : GreatCircle.Base}
    (τ : GpvTransport A X (projectivePole A)) (I : SphereWorld) :
    Octonion.exp (Octonion.sliceEmbed I.val (τ.lift 1)) =
      Octonion.sliceEmbed I.val (A.distinguishedPoleFactor (A.pole : ℂ)) := by
  rw [τ.exp_slice_lift, τ.value_one_pole]

end ASection
