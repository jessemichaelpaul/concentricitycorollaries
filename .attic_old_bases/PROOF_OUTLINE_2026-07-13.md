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

# THE PROOF OUTLINE OF RECORD (the author, 2026-07-13 — verbatim; supersedes all prior chains)

*Transcribed exactly as given; clause numbers added for F0 reference only. Governed by
ALIGNMENT points 20–23 (the guardrails, the three certificates, the cross-audit). Every
F0 bill-of-materials stub cites one clause below as its fidelity anchor.*

## The author's words (verbatim)

> Let A be a section of the commutative ring R of slice preserving functions under the
> star product over the octonions having properties C1–C4. Then the infinitely many
> C-residue zeros of the A section share one real value c. Hence they are concentric.
>
> Proof. By C1–C4 we build B, Sphere World, and the functor A. Then (proper categorical
> statement needed) real value transports are in one class (or one component, or
> whatever) and hence by π₀(𝒯_A) ≅ colim_𝓑(π₀∘A) and (the emily riehl lemma) the latter
> is a real singleton c, which all C-residue zeros share in common.
>
> That is the outline, that is the intuition. What remains is hunting down the right
> categorical statements so the solution follows from *categorical homotopy theory*
> which is the natural home for proving whether or not spheres are concentric or not.
> And all that remains is to find the placement of the structural claim and not slip
> into failure modes.

## Clause numbering (for stub anchoring)

- **O1 (hypotheses)**: A a section of the commutative ring R of slice-preserving
  functions under the star product over the octonions, with C1–C4.
- **O2 (conclusion)**: the infinitely many ℂ-residue zeros share one real value c;
  hence concentric.
- **O3 (construction)**: by C1–C4, build 𝓑, SphereWorld, and the functor A.
- **O4 (THE STRUCTURAL CLAIM — the open placement)**: "(proper categorical statement
  needed) real value transports are in one class (or one component, or whatever)."
- **O5 (the readout)**: by π₀(𝒯_A) ≅ colim_𝓑(π₀∘A) and the Riehl lemma, the latter is a
  real singleton c, shared by all ℂ-residue zeros.
- **O6 (method)**: the solution follows from categorical homotopy theory — the natural
  home for concentricity of spheres; find the placement of O4; no failure modes.

## Fable's audit (per point 23; findings only in the legitimate forms)

**Objects table**: R with star product → `def:R`/StemRing (his) ✓ · 𝓑 → GreatCircle.Base
(LOCKED) ✓ · SphereWorld → SliceSphereWorld.lean:194 (LOCKED) ✓ · the functor A → the one
section functor (point 14) ✓ · 𝒯_A = ∫_𝓑 A ✓ · the engine → `pi0_grothendieck`
(CERTIFIED) ✓ · the Riehl lemma → Rem 8.3.5 + the p.102 el-identity (SOURCES, verbatim)
✓. **No foreign objects.**

**Scope check (one line, from the author's own D1)**: O5's "the latter is a real
singleton" admits two readings — (a) all of colim(π₀∘A) is a singleton; (b) the
ℂ-residue zero states' image in it is a single class, whose descended real value is c.
D1 (resolved, author-ratified) types the theorem as (b), the ∃κ form; (a) is the
optional stronger variant (point 10's H2) available only on the author's ruling. The F0
stub for O5 is typed as (b) unless the author rules (a).

**Species check**: O4's candidate discharges are per-zero, per-arrow statements of
already-certified species (welding/ladder/winding/label rows). PASS.

**Verdict: PASS**, with the O5 scope line awaiting the author's word and O4's placement
awaiting the author's ruling between the two candidates below.

## The O4 placement — RULED (the author, 2026-07-13)

**P-A (the anchor form: per-zero arrows to the C1 anchor) is STRUCK — a failure mode.**
The author's ruling, verbatim register: it is "a failure mode dressed up as category
theory and sneaking in pointwise local claims about zeros." Its proof burden is per-zero
arrow construction — the pointwise register. Accordingly the `NormalizedZeroCone`
cone-instance route is NOT the placement of record (its generic lemmas remain proved
facts in the repo; they are not the architecture). Fable's presentation of P-A and P-B
as "the same mathematics" is CORRECTED on the author's ruling: the statements may be
inter-derivable through the engine, but the proof burdens are different mathematics —
one pointwise, one structural — and the burden is what the failure mode lives in.

**P-B (the identification form, at the colimit) is the placement of record.** The
structural claim is a claim about THE DIAGRAM — the functor A that C1–C4 build — never
about zeros pointwise: the diagram's own arrows impose, through the colimit's quotient,
the identifications; the zeros SIT in the diagram (population) and inherit them; the
label is a cocone and descends (`colimit.desc`); c is named at the end. The remaining
hunt, now scoped by this ruling: **the structural theorem whose hypothesis is stated
about A/the diagram as a whole** (base connectivity + the functor's action), from which
the singleton class of real values emerges — "the structural theorem that ensures the
singleton is the real value all C-residues share that emerges from the constructible
proof" (the author). Hypotheses mentioning individual zeros are out of bounds.

**Where the Riehl p.102 identity goes (the author's question — before, during, or
after): DURING.** It is the internal mechanism OF the π₀/colim machinery, not a separate
step: it is what the isomorphism π₀(𝒯_A) ≅ colim_𝓑(π₀∘A) MEANS — the right side is the
quotient of fibrewise components by exactly the arrow-demanded identifications, and the
certified `pi0_grothendieck` already carries that content. So in the outline it is the
semantic content of O5's first citation; O4's typed form lives at the colimit register
as a diagram-level statement, and the engine carries it back to π₀(𝒯_A). The descent
(`colimit.desc`) operates AFTER the machinery; the naming of c is LAST.

## The value-transport statements (VT1–VT6 — the author's request, 2026-07-13: named
category theory, no invented gaps; every entry pinned, banked, or an explicitly NAMED
generic gap)

- **VT1 — what a value transport IS: naturality into a constant target.** The readout as
  a natural transformation r : (π₀∘A) ⟹ const ℝ — components r_b, ONE condition
  quantified over every base arrow g: r_{b'} ∘ (π₀∘A)(g) = r_b. Zeros never mentioned.
  Equivalently: a cocone under π₀∘A with vertex ℝ. Sources: Mathlib `NatTrans`,
  `Functor.const`, `Limits.Cocone`; Riehl CHT/CTC (natural transformation, cocone).
- **VT2 — the identification mechanism (the p.102 sentence at kernel grade).** Elements
  of a Types colimit are identified exactly along the diagram's transports:
  `Types.colimit_sound` (Limits/Types/Colimits.lean:203), `colimit_sound'` (:208),
  `colimit_eq` (:214) — pin-verified; literature: Riehl CHT p.102 (banked verbatim,
  SOURCES/Riehl.md). Operates DURING the machinery — it is the engine's meaning.
- **VT3 — connected constancy.** Object level, pinned: `constant_of_preserves_morphisms`
  (IsConnected.lean:148), `any_functor_const_on_obj` (:116) — on a connected category an
  assignment preserved by every morphism is constant. Colimit level (colim over
  connected J of a constant diagram ≅ the constant): NOT found packaged in the pin —
  **NAMED GENERIC GAP VT3c**, derivable from VT2 + connectivity by zigzag induction;
  same family as the elements-bridge lemma; zero project-specific content.
- **VT4 — the descent.** `colimit.desc` (HasLimits.lean:736) + `colimit.ι_desc`: every
  VT1-cocone factors uniquely through the colimit. Operates AFTER; c named LAST.
- **VT5 — the shadow's backbone.** π₀ ⊣ Disc (Riehl Rem 8.3.5, banked): left adjoints
  preserve colimits — why fibrewise π₀ and total π₀ agree; the repo's CERTIFIED
  `pi0_grothendieck` is its worked instance for the Grothendieck construction.
- **VT6 — generators and relations for the functor.** The base's own arrows are ALREADY
  "element + transport equation": `ActionCategory.hom_as_subtype` (Action.lean:92,
  pin-verified): (p ⟶ q) = { m : M // m • p.back = q.back }. Defining A on 𝓑's arrows =
  assigning each group element its transport, compatibly (an equivariant family);
  by the generator rulings it suffices to define on the generating channels and check
  relations — W1–W4's station. STRUCTURAL RHYME (recorded): the Elements Hom is
  { f // F.map f p.2 = q.2 } (Elements.lean:63) — arrow = datum + transport condition at
  BOTH ends of the architecture; the base's arrows and the colimit's identifications
  have the same shape. The author's "natural home" is visible in the pin itself.

**The composition (the author's mechanism, statements attached):** define A on the
generating channels (VT6) → the value squares on those generators are exactly where
C1–C4/W1–W4 enter (winding, level, continuation through N — the ℂ-residue data
"touching in the cone at N"), discharging VT1 → the machinery identifies (VT2, during;
the certified engine) → 𝓑 connected + VT3 force one value class → VT4 descends → c named
last. G₂'s finite zigzags connect the slice Riemann spheres INSIDE the fibres (feeding
π₀∘A); N connects the C2/C3 data INSIDE the functor's definition. No statement anywhere
quantifies over the zero family; the zeros inherit by population.

## Status

O1, O3 objects LOCKED or specced; O5's engine CERTIFIED (the p.102 mechanism inside
it); O5's descent Mathlib-native; VT1–VT6 pinned except two NAMED generic gaps (VT3c;
the elements-bridge), both derivable, both project-free. Open work, in order: the O5
scope word (the author); the O4 structural theorem assembled from VT1+VT3+VT5 under the
P-B scoping (diagram-level hypotheses only); then F0 stubs, author-ratified line by
line.
