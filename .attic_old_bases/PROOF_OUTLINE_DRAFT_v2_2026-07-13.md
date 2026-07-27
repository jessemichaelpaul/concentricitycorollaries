> ## RETIRED - PRE-REBUILD MATERIAL, NOT CURRENT (marked 2026-07-20)
>
> This file sits in a retired directory and predates the projective rebuild. It may describe
> objects, bases, functors, and file locations that no longer exist.
>
> **Known stale across this material:**
> - The `cayleyProjective` / generic-Moebius route and the `Hypothesis A (_D)` cargo-as-fields
>   pattern are **SUPERSEDED**. Cargo is not attached to the action; it IS the action. The
>   A-determined Euler/Weierstrass pole action is carried by `stabilizerPart` via orbit-stabilizer.
> - **Deleted modules:** AFunctor, TwoWorlds, PhiConversion, Recovery, ConnectedBase, InboxWire,
>   SynthesisE6, IntegrateTheorem, NormalizedCone, NormalizedNLeg, Base, TransportObject,
>   FaithfulApply, KeystoneAssembly, KeystoneFinality, RecoveryAudit. Their facts were rehomed,
>   largely into ProjectiveCargo / ProjectiveTransport.
> - **Every file:line citation here is unreliable.** Resolve names against the live tree only.
> - Any `rho`/`V_RHO`, `el(V)`, `Disc R`, per-zero `Z_n -> N` leg, generic action record, or
>   parameterized carrier appearing below is a retired substitution, not the construction.
>
> **Current and authoritative:** `PROOF_OUTLINE_LOCKED.md` and
> `BOARD_LECTURE_CONCENTRICITY_2026-07-17.md` (the author own), plus `RESUME_2026-07-20.md`
> for live state.
>
> **Do not take construction, architecture, or status from this file.**

# THE CONCENTRICITY THEOREM — proof outline, draft v2.3 (Fable, 2026-07-13; for the author's lock-in)

*v2.3 — the author's connectedness correction: v2.2's movement V injected "connected
base + connected fibres" as the structural claim — a generic object-property the author
never stated (and which the project memory had already banned once). STRUCK. The
movement now carries his register only: conserved real value transport + the machinery's
finite zigzags riding the constructed arrows = one conserved kind of object. VT3 struck
from the chain. No property of base or fibre objects is asserted anywhere.*

*Drafted in the author's voice against PROOF_OUTLINE_2026-07-13.md (the outline of
record) under ALIGNMENT points 20–23. v2 FAILED the three-auditor adversarial audit (21
findings, including the failure mode committed at the draft's center); v2.1 fixed those;
v2.2 applies the author's two corrections of 2026-07-13: (i) the "one open structural
theorem" framing STRUCK — the one-load-bearing-step narrative is itself a failure-mode
marker; the structural claim is cited NOW and thereby decomposed into pinned components;
(ii) the structural movement placed BEFORE the assembly and the readout, which consume
it; (iii) the author's CD(stem) option recorded in movement III. Becomes the outline of
record only on the author's ratification.*

---

**Theorem.** Let A be a section of the commutative ring R of slice-preserving functions
under the star product over the octonions, having properties C1–C4. Then the infinitely
many ℂ-residue zeros of the A-section share one real value c. Hence they are concentric.

**The proof, as a chain.**

**I. The stage.** There is one compactified real great circle, ℝ ∪ {∞} — the axis every
slice Riemann sphere contains, the domain on which the section is meromorphic. It
carries its full projective automorphism group PGL(2,ℝ): the rotations seen through the
Poincaré disk, the dilations, all of it. The base is the translation groupoid
𝓑 = PGL(2,ℝ) ⋉ (ℝ ∪ {∞}). Its arrows are nothing exotic: a base arrow IS a group
element together with its transport equation — the same shape category theory uses
everywhere. *(Lean: `GreatCircle.Base`, LOCKED; rows in GREEN_LEDGER.)*

**II. The worlds.** There is one sphere world: the groupoid whose objects are the slice
Riemann spheres S²_I, one for every imaginary direction I ∈ S⁶, with the G₂ direction
arrows between worlds, the Möbius automorphisms within each world, and the U(1) band
inside — every world glued along the one great circle, every world sharing the same two
distinguished points, 0 and N. *(Lean: `SphereWorld`, LOCKED.)*

**III. The airplane.** From C1–C4 we build the section functor A : 𝓑 ⥤ Grpd — the one
airplane, viewed functorially. Its object action is the section's own evaluation,
normalized into the worlds. Its arrow action is defined on the generating channels of
the base and extended by the group's own relations, with W1–W4 as the relations'
certificates. This movement is where the analytic cargo boards — all of it, and only
here: the Euler product of C2, zero-free on its half-space; the Weierstrass
factorization of C3, carrying the divisor; the pole cone of C1, continuing the section
through N; the infinite fleet of C4; the unique tame lifts with their winding, which is
what makes the arrow action canonical rather than chosen. And here, inside the
functor's definition, N connects the C2 and C3 data: the two exponential presentations
are presentations of the one continued section — the identity theorem and the unique
tame lifts hold them together, and the continuation carries them through N. The
ℂ-residue zeros enter as population — objects the construction produces. Output, never
input. *(VT6: the base's arrows are already elements-with-transport-equations — define
on generators, relations checked once. THE AUTHOR'S RECORDED OPTION, undecided: the
generators and relations may be defined naturally through the Cayley–Dickson tower over
the stem — CD(stem) — "maybe we do maybe we don't"; a movement-III design question for
the functor build, not a commitment.)*

**IV. The value rides.** Each normalized state carries its real value, and the carriage
is natural — in both directions the record requires. Within each fibre, the value is
invariant under the fibre's own morphisms — the G₂ direction arrows, the band — so it
descends to the fibre's components, π₀(A b). Across the base, one square for every
arrow g: the value after transport equals the value before. Note the shape of the whole
claim: it is quantified over the arrows of the diagram, never over zeros. No zero is
mentioned; no pair of zeros is compared. The discharges are drawn, on the generating
channels, from what C1–C4 certify — the level rides the lift, the phase rides the band,
the winding is conserved, the continuation carries the value through N. *(VT1 — the
value-transport statement: naturality into a constant target, per ALIGNMENT point 20 —
preserved by fibre morphisms and base transports; the certified crossing/level/winding
rows are the species from which the discharges will be drawn.)*

**V. The categorical statement — cited now, up front.** *(v2.3 — the author's
correction of 2026-07-13 applied: the previous version of this movement injected
"connectedness" of the base and of the fibres as the structural claim. The author: "I
never said my base is connected... I don't care about the fibers 'being connected'...
Nothing about connectedness in whatever sense you are using it." Connectedness claims
are STRUCK; the movement now carries his register only.)* What must be true, and where
it is already written: in the colimit of the components diagram, two pieces of data are
identified exactly when the diagram's own arrows demand it, through finite zigzags —
that is Riehl's π₀ *(objects up to finite zigzags — Rem 8.3.5, verbatim in SOURCES)*,
her p. 102 identity *("each arrow connecting two objects in el X corresponds to a
condition demanding that these elements are identified in any cone under X" — verbatim
in SOURCES)*, and the pinned Mathlib relation *(`Types.colimit_sound`/`colimit_eq`:
identification in a Types colimit IS the equivalence the transports generate)*.
Conserved real values ride those zigzags unchanged — that is movement IV's naturality.
So when the machinery runs on the diagram we built — whose arrows carry the welds, the
continuation through N holding C2 and C3 together, the G₂ zigzags between the worlds,
all boarded in movement III — the value data of the ℂ-residue zeros connects by the
machinery's finite zigzags and is conserved along every one of them: **one kind of
object, one class, one value.** Nothing here asserts a property of the base or of the
fibres; the one-ness is read off the constructed diagram by the quotient — off the
welded morphisms, never off a generic property. *(Citations: Riehl Rem 8.3.5 + p. 102,
SOURCES verbatim; `Types.colimit_sound`/`colimit_eq`, pin; `toColimitObj_eq_of_zigzag`
+ `pi0_grothendieck`, CERTIFIED; `colimit.desc` waiting in VIII.)*

**VI. The assembly.** The Grothendieck construction assembles the flight:
𝒯_A = ∫_𝓑 A — objects the pairs (b, x), a place on the circle and a state in the world
over it; morphisms a base channel together with a fibre transport. Nothing new is
decided here; assembly is free. *(Mathlib `Grothendieck`; verified by the placement
audit.)*

**VII. The readout.** Now the categorical homotopy theory — the natural home for proving
whether spheres are concentric. The certified engine reads the assembled object:
π₀(𝒯_A) ≅ colim_𝓑(π₀ ∘ A) *(Lean: `pi0_grothendieck`, CERTIFIED; Thomason's π₀ shadow —
and its meaning IS Riehl's p. 102 identity: "each arrow connecting two objects in el X
corresponds to a condition demanding that these elements are identified in any cone
under X" — VT2, kernel-grade as the Types colimit relation, operating DURING, inside
the engine)*. Alongside it, Riehl's Remark 8.3.5: π₀ takes a category to its objects up
to finite zigzags. The colimit performs the identifications movement V cited — it, not
us; that is what the quotient is. The real-value-carrying components land in one class
κ, read off the structure; the ℂ-residue population inherits membership.

**VIII. The pluck.** The natural value of movement IV is a cocone under π₀ ∘ A; by the
universal property of the colimit it descends to a single map r̄ off the readout
*(VT4: `colimit.desc`)*. At the one class κ this names one real number: c := r̄(κ).
Every ℂ-residue zero sits in κ, so every ℂ-residue zero's real value is c. They share
one real value. Hence they are concentric. ∎ *(The pluck consumes only κ and the
cocone — verified adversarially: value(z) = r̄(κ) by `colimit.ι_desc`, no further lemma.)*

*(Scope, per D1, author-ratified, pending the author's O5 word: the theorem claims the
zeros' common class — the ∃κ form — never that the whole of π₀(𝒯_A) is a point.)*

---

**What the chain uses.** As movements: VT6 (III — generators and relations), VT1 (IV —
naturality of the value, both halves), VT2 with Riehl's π₀ (V and VII — the machinery's
zigzag identifications, cited), VT4 (VIII — the descent). Cited as pedigree: VT5 backs
the engine itself (π₀ ⊣ Disc). **VT3 is struck from the chain** per the author's
correction — connectedness, in any sense, is not a claim of this argument.

**The ledger.** LOCKED: the base (I), the sphere world (II). CERTIFIED: the engine
(VII); `toColimitObj_eq_of_zigzag` (V's mechanism at kernel grade); the transport laws
and uniqueness rows the arrow action rides (III); the crossing/level/winding rows — the
species from which IV's discharges will be drawn; the label's definitional projection
(`normalizedZero_label`, rfl, NormalizedBase.lean:51). PINNED verbatim: Riehl p. 102
and Rem 8.3.5 (SOURCES); the Types colimit relation (`colimit_sound`/`colimit_eq`);
`colimit.desc`; `hom_as_subtype`. OPEN — the honest work, every item named, none of
them "the one": the O5 scope word (the author); the 0.3 cargo ruling (the author); the
functor's construction on the generators (III, with the CD(stem) option to rule) — the
welds, the N-continuation, and the G₂ arrows built there ARE the zigzag supply the
machinery quotients along; the per-generator base squares AND the in-fibre invariance
discharges (IV); the typed population (III). No link of the chain quantifies over the
zero family; no link consumes the conclusion; no open item is permitted to be styled
"the load-bearing one"; no property of base or fibre objects is asserted anywhere.

**The two ends of the chain** *(the chain principle — the author, after Bill Floyd,
2026-07-13)*. The conclusion specifies the last links backward: c needs the descent;
the descent needs the natural value; the natural value needs squares on the generators
and invariance in the fibres. The hypotheses build the first links forward: C1–C4 make
the functor; the functor's generators are exactly where the squares live. The two ends
meet at movements III–IV — the functor and its cargo — with movement V's cited
structure standing before the machinery that consumes it. The requirements flow
backward, the constructions flow forward, and no link consumes the conclusion: that is
why the chain can be built from both ends at once without circularity.
