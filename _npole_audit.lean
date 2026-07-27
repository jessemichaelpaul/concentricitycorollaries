import Concentricity

-- North-pole fibre & stabilizer-action kernel pass, 2026-07-16: one #print axioms per
-- inventory row not already in GREEN_LEDGER or the 2026-07-15 ρ-pass.

-- Block 1 — the object at N
#print axioms ASection.valueAtInfinity_real
#print axioms ASection.Fstar_infty
#print axioms ASection.realize_infty
#print axioms ASection.realize_pole
#print axioms ASection.normalizedZero
#print axioms ASection.normalizedZero_label
#print axioms ASection.normalizedZero_footpoint
#print axioms ASection.normalizedZeroLift_re
#print axioms ASection.normalizedZeroPoint_mem_sliceSphere
#print axioms ASection.normalizedSectionPoint_mem_sliceSphere
#print axioms ASection.normalizedZeroSlicePoint
#print axioms ASection.normalizedSectionObject
#print axioms ASection.normalizedNLeg
#print axioms ASection.NormalizedNLeg.target
-- Block 2 — internal morphisms of 𝒱
#print axioms dirHom
#print axioms dirHomTo
#print axioms mobHom
#print axioms bandHomAt
#print axioms SphereHom.comp_rot
#print axioms SphereHom.comp_mob
#print axioms SphereHom.id_rot
#print axioms SphereHom.id_mob
#print axioms ASection.realizes_id
#print axioms ASection.GpvTransport.toRealizes
#print axioms G2.smul_onePoint_infty
#print axioms ASection.gpvPopulated
#print axioms ASection.transport_universal_gpv
-- Block 3 — C1–C4 at N
#print axioms ASection.c1_analyticAt
#print axioms ASection.c1_simple
#print axioms ASection.c2_euler
#print axioms ASection.c3_factorization
#print axioms ASection.c3_atN
#print axioms ASection.c4_infinite
#print axioms ASection.pole_le_upperEdge
#print axioms ASection.ne_pole_of_re_gt
#print axioms ASection.eventually_ne_zero_near_pole
#print axioms ASection.pole_cone_tendsto
#print axioms ASection.pole_cone_chart
#print axioms ASection.no_finite_zero_accumulation
#print axioms ASection.supLevel_attained_or_escape
#print axioms ASection.stem_zero_of_sphereZero
#print axioms ASection.sphereZero_complete
-- Block 4 — W1–W4 at N
#print axioms ASection.stemWinding_circle_sphereZero
#print axioms ASection.fiber_tally_pos
#print axioms ASection.sigma_level_separation
#print axioms ASection.zero_pole_pair_winding
#print axioms ASection.normalizedZero_pole_winding
#print axioms ASection.sphereLoop_value_winding
#print axioms ASection.sphereLoop_value_band
#print axioms ASection.sphereLoop_touches_degenerate
#print axioms Octonion.exp_fibre_re
#print axioms Octonion.exp_fibre_concentric
#print axioms CrossingData.bounce_conserves_band
#print axioms CrossingData.flip_steps_band
#print axioms arc_one_band
-- Block 5 — stabilizer/exponential geometry
#print axioms Octonion.exp_sliceEmbed'
#print axioms Octonion.norm_exp
#print axioms Octonion.exp_ne_zero
#print axioms exp_eq_neg_real_iff
#print axioms exp_fibre_height_band
#print axioms Octonion.sphere_path
#print axioms Octonion.exp_fibre_sphere_connected
#print axioms Octonion.exp_fibre_conj_joined
