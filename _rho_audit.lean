import Concentricity

-- ρ-laws kernel pass, 2026-07-15: one #print axioms per table row not already in
-- GREEN_LEDGER. Names per the second-pass sweep; any unknown-identifier error is
-- corrected and rerun before rows enter the ledger.

-- Identity / constant-winding (ρ(1) = 1)
#print axioms ASection.GpvTransport.id
#print axioms ASection.GpvTransport.ofEulerHalfSpaceLoop
#print axioms ASection.GpvTransport.ofLeftRegionLoop
#print axioms stemWinding_const
#print axioms ASection.stemWinding_F_halfSpace
#print axioms ASection.stemWinding_F_leftRegion
-- Composition (ρ(h₂h₁) = ρ(h₂)ρ(h₁))
#print axioms ASection.GpvTransport.comp
#print axioms stemWinding_mul
#print axioms stemWinding_pow
#print axioms stemWinding_finset_prod
-- Presentation independence
#print axioms stemWinding_eq_of_homotopy
#print axioms stemWinding_eq_zero_iff
#print axioms winding_loop_closed
#print axioms winding_defect_lift_independent
#print axioms winding_loop_defect_level_zero
#print axioms ASection.realizes_gpv_lift
-- Inverse transport
#print axioms ASection.GpvTransport.inv
#print axioms stemWinding_inv
-- Euler/Weierstrass agreement
#print axioms stem_identity
#print axioms ASection.stem_identity_logDeriv
#print axioms ASection.logDeriv_euler
#print axioms ASection.logDeriv_weierstrass
-- Translation relations (tape)
#print axioms ASection.tape_continuousOn_real
#print axioms ASection.real_segment_tape_sweeps
#print axioms ASection.gpvBase_transport
#print axioms ASection.great_circle_lift_through_degenerate
#print axioms ASection.great_circle_passage_total
-- Dilation relations (cone/junction)
#print axioms ASection.pole_cone_eps_delta
#print axioms ASection.normalizedZero_pole_power_closes
#print axioms ASection.zero_pole_pair_closes_through_witness
#print axioms ASection.two_center_winding_onto_one_band
#print axioms ASection.pole_encounters_joined_concentric
#print axioms ASection.zero_encounters_joined_concentric
-- Reflection relations (crossing/flip)
#print axioms crossing_height_even_of_pos
#print axioms band_side_of_sign
#print axioms closed_lift_of_no_interior_flip
#print axioms exists_interior_flip_of_stemWinding_ne_zero
#print axioms ASection.crossing_sign_rigid
#print axioms ASection.crossing_sign_const_between
#print axioms stemSignature_mem_of_pos
-- Internal U(1) interaction (conjugation/equivariance models)
#print axioms bandGL_mul
#print axioms bandMoebiusHom
#print axioms bandEnd
#print axioms sphereWorld_zigzag
#print axioms Octonion.exp_kernel_unit_imaginary
#print axioms S2.exists_band_rotation
#print axioms Octonion.lift_iff_continuation
#print axioms Octonion.IsLoopLift.level_periodic
