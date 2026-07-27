import Concentricity

-- Exhaustive-relation-inventory kernel pass, 2026-07-16: newly surfaced rows
-- (not in GREEN_LEDGER, the ρ-pass, or the north-pole pass).

-- InboxWire (the recovered file)
#print axioms lift_ladder
#print axioms ASection.euler_branch_ladder
#print axioms ASection.euler_branch_level
#print axioms odd_rung_rigidity
#print axioms ASection.degenerate_stretch_pins_band
#print axioms stemWinding_eq_zero_of_offReal
#print axioms offReal_loop_every_branch_closes
#print axioms ASection.offReal_value_loop_closes
#print axioms ASection.sphereZero_norm_tendsto_atTop
#print axioms ASection.sphereZero_im_tendsto_atTop
#print axioms ASection.indices_below_height_finite
#print axioms s2_component_exp_eq_iff
#print axioms ASection.s2_value_class_halfSpace
-- ConnectedBase laws (legacy carrier; cargo)
#print axioms ASection.realizes_inv
#print axioms ASection.realizes_comp
#print axioms ASection.gpvBase_transport_star
-- Recovery tail (the enriched groupoid)
#print axioms ASection.GpvRealizes
#print axioms ASection.instGroupoidGpvBase
#print axioms ASection.gpvForget
#print axioms ASection.compactifiedSphereMap
-- LogManifold tail
#print axioms Octonion.level_tape_continuous
#print axioms Octonion.lift_level_tape
#print axioms Octonion.lift_level_continuous
#print axioms Octonion.lift_level_unique
#print axioms Octonion.lift_loop_level_closes
#print axioms Octonion.exp_eq_neg_ofReal_iff
#print axioms Octonion.real_segment_lift_neg
#print axioms Octonion.real_segment_lift_pos
#print axioms Octonion.Llog_Eexp
#print axioms Octonion.Eexp_injective
#print axioms Octonion.Eexp_Llog
#print axioms Octonion.re_Llog_of_mem
#print axioms Octonion.degenerate_sphere_mem
#print axioms Octonion.logManifold_fibre_neg_real
#print axioms Octonion.degenerate_level_readout
#print axioms Octonion.degenerate_passage
#print axioms Octonion.isLift_of_continuation
#print axioms Octonion.continuation_of_isLift
#print axioms ASection.zero_passage_level_atBot
#print axioms ASection.pole_passage_level_atTop
#print axioms ASection.pole_degenerate_passages
#print axioms ASection.zero_passage_manifold_data
#print axioms ASection.pole_passage_manifold_data
#print axioms ASection.level_circle_meets
-- IntegrateTheorem tail
#print axioms ASection.gpvPopulated_extends_populated
#print axioms ASection.concentricity_transport_gpv
#print axioms ASection.gpv_zigzag_readout
#print axioms ASection.not_concentric_iff_spread
#print axioms ASection.two_level_apparatus
#print axioms ASection.gpvZigzag
-- FlipWeld newly named (σ register + conjugation apparatus)
#print axioms stemSignature_eq_circularSignature
#print axioms conjLoop
#print axioms CrossingData.ofConj
#print axioms CrossingData.ofConj_isFlip
#print axioms crossingData_of_finite_obstruction
#print axioms exists_flip_of_up_rung
-- Slice.lean load-bearing new rows
#print axioms Octonion.sliceEmbed_dir_sliceCoord
#print axioms Octonion.sliceEmbed_neg_conj
#print axioms Octonion.dir_sliceEmbed_of_pos
#print axioms Octonion.dir_sliceEmbed_of_neg
#print axioms Octonion.sliceCoord_sliceEmbed
#print axioms G2.smul_re_normSq
#print axioms G2.smul_im
#print axioms G2.smul_dir
#print axioms G2.im_smul_ne_zero
-- Foundation keys
#print axioms Octonion.sq_eq_neg_one_of_mem_unitImaginarySphere
#print axioms Octonion.normSq_mul
#print axioms Octonion.alt_left
#print axioms Octonion.alt_right
#print axioms G2.exists_smul_eq_of_mem_unitImaginarySphere
#print axioms StemRing.real_on_real
-- Normalized new rows
#print axioms ASection.normalizedZero_on_shared_circle
#print axioms Octonion.norm_sliceEmbed_sub_sliceEmbed
#print axioms Octonion.norm_sliceEmbed
#print axioms ASection.normalizedWorldRotate
#print axioms ASection.normalizedZeroLift_equivariant
#print axioms ASection.normalizedSectionPoint_equivariant
