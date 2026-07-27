import Concentricity

-- GREEN_LEDGER kernel pass, 2026-07-11: one #print axioms per ledger row.

-- G₂ action layer
#print axioms G2.smul_one
#print axioms G2.smul_ofReal
#print axioms G2.smul_sliceEmbed
-- Equivariance layer (Slice.lean)
#print axioms ASection.sliceCoord_smul_invariant
#print axioms ASection.realize_mem_sliceSphere
#print axioms ASection.realize_equivariant
-- GPV transport (Recovery.lean)
#print axioms ASection.GpvTransport.lift_exp
#print axioms ASection.GpvTransport.winding
-- Winding bridges (SigmaE3.lean)
#print axioms crossing_height_odd_of_neg
#print axioms crossing_band_ledger
#print axioms winding_height_shift
#print axioms ASection.stemWinding_circle_pole
#print axioms ASection.no_closed_lift_around_sphereZero
-- Collapse rows (NormalizedBase.lean)
#print axioms ASection.normalizedZero_collapse_at_N
#print axioms ASection.normalizedZeroLift_norm
#print axioms ASection.normalizedZero_label_world_independent
-- The zeta instance
#print axioms zetaSection
-- The engines (Theorem.lean)
#print axioms pi0_grothendieck
#print axioms toColimitObj_eq_of_zigzag
-- The current readout chain (ConcentricityReadout.lean / AFunctor.lean)
#print axioms ASection.functorA
#print axioms ASection.readout
#print axioms ASection.totalA_pi0_singleton
#print axioms ASection.zero_levels_common
#print axioms ASection.concentricity
-- The classical leaf proved in-repo (R9) and the Corollaries chain
#print axioms riemannZeta_nontrivialZeros_infinite
#print axioms ASection.nontrivial_one_centre
#print axioms zeta_riemannHypothesis
#print axioms zeta_criticalLine_zeros_infinite
-- The Euler-down / shared-ladder rows (stem-level, base-agnostic; 2026-07-11 late)
#print axioms exp_fibre_level
#print axioms ASection.shared_ladder_encounters
#print axioms ASection.cone_tape_escape
#print axioms ASection.cone_junction_levels_shared
-- The GPV canonicity cluster, stem-level in-repo analogs (2026-07-11 late)
#print axioms exists_log_continuation
#print axioms winding_lift_unique
-- KeystoneAssembly.value_loop_lift_unique: NOT in the root import closure (unimported
-- artifact; imports the old Base.lean). Audited CERTIFIED 2026-07-12 by direct file
-- elaboration (scratch copy + #print axioms). Do not print here.
#print axioms stemWinding_spec
#print axioms stemWinding_eq_of_lift
