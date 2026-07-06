# PREP — Island P examination (banked 2026-07-05, evening; opens phase (4))

*The author's brief history of the concentricity intuition, the two-circles
reading, the literature-review scope, and the P-routes record — so the (4)
juncture opens with this on the table. Feeds the phase-4 microhistory prose
(inbox/064-082.pdf) and the planned board lecture on `thm:concentricity`.*

## 1. The brief history of the intuition (author, 2026-07-05 dialogue; receipts in the record)

1. **The seed — GPV/VS's *concentric* degenerate fibres.** VS Rem 5.2(b)
   (SOURCES/VS.md, verbatim in `lem:exp-degenerate`): π : 𝓔⁺ → 𝕂 "is not a
   covering… because exp is not open: it has a non-empty *degenerate set
   consisting of spheres*." The fibre over −r is the 6-sphere family of radii
   π, 3π, 5π, … about the centre log r — concentric in the sources' own
   geometry. VS printed the fibre formula unproved (Preface, p. 972); the
   master's `lem:exp-degenerate` derives it from the slice form, PROVED in
   Toolkit.lean.
2. **Built over S¹.** The winding circle is literal in the Lean: the band
   functor is the constant functor at `SingleObj Circle`; GPV Cor 5.13 (the
   lift per the obstruction interval, then a loop) is the winding node. GPV's
   concentric exp family over S¹ = 𝒯 = ∫_𝓑 F with F ≡ S¹.
3. **The Euler product hands the A-section the same structure.** C2:
   A = exp(Σₚ ℓₚ) on Ω₀, zero-free there — the section is an exp-family
   member where it is a product, so it inherits a degenerate fibre, and the
   zeros arrive AS that fibre (output, never input; R4 — now the literal
   shape of `concentricity_transport`).
4. **The extension move (the original idea).** Euler and Weierstrass are two
   exponential expressions of the one stem (identity theorem — the unique
   tame lift), so exp's concentric degenerate structure extends along the
   section: the infinitely many ℂ-residue spheres land in ONE connected
   component (the locked theorem, with the author's "infinitely many"
   wording), and "concentric" transports only downstream
   (`rmk:concentric-gloss`). Discovery order: theorem before corollary; the
   paper's order mirrors it.

## 2. The two-circles reading (the author thinks these concurrently)

The construction has exactly two circles:
- **the winding S¹** (GPV's band), fibred at every level — F ≡ S¹;
- **the great circle ℝ ∪ {N}** (the level axis, closed through the one N) —
  the archived great-circle play (2026-07-04) opens with `lem:great-circle`:
  "The compactified real axis is the unique circle through N common to every
  slice sphere, and it is precisely the fixed locus of G₂ acting on 𝕆*."

𝒯 is the second circle carrying the first: the great circle with an S¹ of
winding over every level. Thinking the one-real-axis idea and the concentric
exp family concurrently is thinking ∫_𝓑 F itself.

## 3. What is proved vs. open, exactly (the litmus for any new route)

- PROVED: the component through N swallows EVERY level — Pin 2
  (`transport_not_level_separating`): the compactified object alone connects
  too well; no centre readout exists there. The section's transport register
  (continuation, one stem, unique tame lift, loop closure) is PROVED in
  Toolkit.lean; the assembly "the single tame loop visits all of {qₙ}" is
  the open node.
- OPEN (Island P, the One-Hyperplane Theorem): `placement_set` ≡
  `transportLevel_placement` (one welded node) — any two upper-half stem
  zeros share one real part. Not derivable from the locked theorem (the
  0.3/0.7 litmus). Any candidate route must either produce this or land on
  it; lake decides.

## 4. The P-routes record (render in dialogue, in this order)

1. **The author's one-great-circle sketch (2026-07-05, new):** two ℂ-residue
   zeros with different centers both lie on the hyperplane through S¹; G₂
   fixes ℝ ∪ {∞} in 𝕆* and everything else is imaginary; on complex,
   quaternionic, and octonionic spheres there is only ONE great circle —
   where 𝓑 and the A-section live. To render FIRST at the juncture.
2. **P-route 3 (rendered, 2026-07-04):** contradiction clause resisted at
   ⊢ False (OneHyperplaneRoute.lean receipt); Pin 2 refutes the
   two-components step in the object of record.
3. **P-route 3′ (rendered):** per-level norths N₁, N₂ — in the honest
   TwoNorth ambient the one-component reading is PROVED equal to the level
   equality, i.e. to Island P itself; the locked theorem does not transport
   there.
4. **Brick 2 (the analytic route of record):** the two-index pairing
   (PLAN_two_index_bricks §5 = master `rmk:two-index-roadmap`); Brick 1 +
   B2.1 PROVED (PlacementSet.lean).

## 5. Literature review scope (BEFORE (4) in earnest; author directive)

Hunting ground for "a simple category-theoretic argument (possibly several)"
— the one-real-axis fact says all level-cones factor through a single object
over a single circle; π₀(𝒯_A) is a colimit = a left Kan extension to the
point:

- **Quillen, Higher K-theory I, §1** (pinned; full text banked): Theorem A;
  the pre(co)fibred corollary — already the master's second proof route
  (finality remark). Question: does the great-circle inclusion (or the
  N-cone) admit a finality/cofinality reading that SEPARATES levels rather
  than connecting them (the Pin-2 trap)?
- **Thomason MPCPS 85 (1979) Thm 1.2** (pinned): |hocolim NF| ≃ B(∫F) —
  the homotopy-colimit reading of the transport object.
- **Riehl, CHT §8.3/§8.5** (pinned): finality via comma categories; Kan
  extensions formulation — π₀ readouts as Lan along the terminal functor;
  pointwise formulas over the comma objects (the level-fibres).
- **Kan-extension angle (new for the review):** the placement is a statement
  that a certain Lan is CONSTANT on the zero-classes; look for conditions
  (connectedness of comma categories = Quillen A's hypothesis) that the
  section's transport data — the S¹-winding over the great circle — could
  supply. The obstruction to keep in view: any argument usable by EVERY
  C1-bearing section is dead on arrival (Pin 1: the class-wide transport
  connects; the 0.3/0.7 hypothetical). The route must consume C2/C3's one
  stem (the tame-lift uniqueness), not just C1's cone.
- Community-formalization note: the finality proof of the master is
  deliberately left expository (rmk; two-proofs policy) — the review may
  sharpen what its Lean-native form would need.

## 6. Board-lecture gate (author, 2026-07-05)

Target: a board lecture on `thm:concentricity` + this history, with "most of
the analysis facts citable on that day" — i.e. the Weierstrass package
(`zetaC3_package`) closed, leaving the ledger at Island P + nothing. The
package build is running (genus-per-zero Weierstrass route; see the
ZetaWeierstrass series of commits).

## 7. P-route 4 rendered (2026-07-06, GreatCircleRoute.lean — unimported artifact)

The one-great-circle route went to lake. THE GEOMETRY IS NOW PROVED — the
archived play's `lem:great-circle`, formal: `sliceSphere_inter` (slice
spheres of independent directions meet EXACTLY in ℝ ∪ {N} — the unique
common circle through N) and `greatCircle_eq_fixedLocus` (the circle is
precisely the G₂-fixed locus: "everything else is imaginary" — any
non-real point is moved by the direction-reversing element). Both on the
kernel triple; folding into the master is the author's call.

Clause (d) — "hence the two centers agree" — RESISTS at exactly the
recorded obstruction: with (a) one-component (Pin 1), (b) the unique
circle + fixity, and (c) the sphere/hyperplane geometry all fed as proved
rows, the goal `z.re = w.re` remains with no hypothesis mentioning the
real parts; Pin 2 is the proved form of the wall (no level-separating
invariant on the transport object; the G₂-fixed circle is fixed at EVERY
level, so it separates none). Receipt in-file (`placement_via_greatCircle`,
sorry = receipt, unimported). Consistent with routes 3/3′: per the
litmus, the closing route must consume C2/C3's one-stem rigidity —
Brick 2 — OR the categorical review must produce an invariant that the
0.3/0.7 hypothetical cannot carry.
