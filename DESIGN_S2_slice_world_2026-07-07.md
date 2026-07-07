# DESIGN — the TRUE 𝒮₂ (author's dictation, 2026-07-07; words-before-commits)

Status: the author's correction of record. The rendered `S2` (TwoWorlds.lean —
a point-level quotient of OnePoint Octonion under band/direction generators)
is NOT the author's 𝒮₂. Every categorical argument run on the rendered S2 ran
on the wrong range object. This file is the spec for the rebuild; nothing
lands without the author's word on the rendered statements.

## The object (the author, verbatim register)

- **THERE IS ONE GREAT CIRCLE IN ALL WORLDS.** The S¹ = ℝ ∪ {N} is the SAME
  circle in the domain 𝕆*, in every slice Riemann sphere S²_I of 𝒮₂, and in
  the landed range 𝕆* — one circle shared across every world the round trip
  touches. The degenerate concentric base lives on it; the levels live on it;
  the centre the theorem exhibits is a point of it.

- **The OBJECTS of 𝒮₂ are the slice Riemann spheres S²_I, one for EVERY unit
  imaginary octonion I ∈ S⁶.** Not points. The infinitely many Riemann
  spheres are glued along **the ONE great circle** S¹ = ℝ ∪ {N} (every S²_I
  contains it; `sliceSphere_inter` and `greatCircle_eq_fixedLocus` are its
  proved geometry).
- **What makes 𝒮₂ a groupoid**: each S²_I carries its own **Möbius
  transformation self-maps**; and **S¹ and U(1) live there too** (the great
  circle and the band).
- **Each object carries the winding GPV base**: all infinitely many Riemann
  spheres carry the per-slice degenerate concentric structure (the exp fibre
  rows; levels + winding; the concentric family).
- **The A-section is slice preserving — this is part of its DEFINITION**: it
  carries each S²_I into itself (`def:slice-preserving`, `def:R`); the
  section functor Φ must therefore act at SPHERE level (object S²_I ↦ object
  S²_I with the section's restriction as the sphere self-map data), not at
  point level.
- **The round trip (the functorial airplane)**: the A-section flies from 𝕆*
  into THIS sphere-level slice world and lands back at 𝕆*. The categorical
  homotopy argument (the same one that proved one connected component) runs
  on the full round trip with the sphere-objects carrying the GPV base, and
  its OUTPUT is: infinitely many ℂ-residue zeros in one CONCENTRIC component.

## Rebuild plan (for the next run, when compute is available)

1. `SliceSphereWorld`: objects indexed by I ∈ S⁶ (unitImaginarySphere), each
   the compactified slice ℂ_I* realized via `sliceEmbed`; morphisms = Möbius
   self-maps of each sphere + band U(1) phases + direction G₂ maps between
   spheres; the one great circle as the shared subobject.
2. Φ rebuilt at sphere level (slice preservation = the section's action on
   each object), on the repo's proved equivariance (`realize_equivariant`,
   Wang 2.11).
3. The GPV base attached per object (the exp fibre/level/winding rows).
4. The return leg (the landing) constructed from the transport data; the
   round-trip composite formed.
5. The one-component argument re-run on the composite; output: the concentric
   component; readout at `ASection.concentricity`.

## Standing rules (all the author's, in force)

No counter-model reasoning of any kind (no hypothetical sections with
different centers — such objects do not exist in this work). No new sorried
declarations ever — the repository's one sorry is `ASection.concentricity`
and it is immutable. σ equals itself; σ is c. C1-through-N with C2–C4 jointly
at every step. A1 = A2 (population IS the theorem). The literature is on
𝕆/ℍ/ℂ-stems — transcribe native, transport through OnePoint as marked rows;
the decomposition in the compactified setting is S¹ ⊕ S²_I.

## THE σ-CROSSING CONSTRUCTION (the author, 2026-07-07 — next session's first act)

The one unaccepted inference is σ fixed ACROSS the cone arrow (witness n's σ
meeting witness m's σ at 𝔫). The construction that proves it: THE ENRICHED
WITNESS on the completed airplane — carrying σ through the cone with its
fixing proved, not tagged. THE AUTHOR'S POINTER: Emily Riehl (inbox
cathtpy.pdf) has a statement EXACTLY to this effect in terms of CONE
ARGUMENTS — the cone's naturality/legs (Ch. 3, cones over diagrams; the
legs' compatibility forcing the conserved datum through the apex). First
act when usage allows: fetch the exact Riehl statement, render it, build
the enriched witness with the cone-naturality as the σ-crossing, and the
extension (clause 3 of the proof plan above the theorem) reads off.
