> ## STATUS CLAIMS IN THIS FILE WERE NOT VERIFIED - corrected 2026-07-19
>
> This document asserted that the on-disk functor was built by the Moebius/**orbit-stabilizer**
> construction. **That was false**, and the same claim was repeated across several documents
> (AGENTS.md, A_SECTION_FUNCTOR_BUILD_PLAN, CONCENTRICITY_THEOREM_CLOSE_GUIDE,
> CONCENTRICITY_DOCUMENT_MAP, CARGO_INVENTORY, ZULIP_RELEASE_PLAN).
>
> Verified against the source, 2026-07-19:
>
>     grep -rn "orbit_stabilizer_factor" Concentricity/*.lean
>     # one hit: its own declaration, ProjectiveSection.lean:115. Consumed by nothing.
>
> `projectiveConnection`s `map` routed every base arrow through `cayleyProjective f.val` - a
> generic monoid hom into `Moebius` - bypassing `orbitRep` / `stabilizerPart` /
> `orbit_stabilizer_factor` entirely. `_D` occurred in none of the twelve `Hypothesis` field
> types, so the analytic cargo sat beside the functor rather than being carried by it.
> Repair to the author-s actual construction was begun the evening of 2026-07-19.
>
> **The author-s own specification is correct and takes precedence over this file:**
> PROOF_OUTLINE_LOCKED.md and BOARD_LECTURE_CONCENTRICITY_2026-07-17.md.
>
> **Rule going forward:** a status claim in a document is not evidence. Verify it against the
> source and record the command that verifies it.

# BUILDING THE A-SECTION FUNCTOR AFTER THE GENERAL $F$-FUNCTOR

**Mathematical author:** Jesse Michael Paul  
**Codex/Opus construction draft:** 2026-07-17  
**Author ratification:** RATIFIED, 2026-07-17  
**Status:** operational Step 2 plan under `PROOF_OUTLINE_LOCKED.md`

## 1. Purpose and exact source boundary

The mathematical order is fixed:

$$
\text{pure Möbius/orbit--stabilizer action}
\longrightarrow
\text{A-section interface carrying C1--C4/W/GPV}
\longrightarrow
\text{its Grothendieck total}.
$$

C1--C4 play no role in the pure action’s well-definition. They and their certified
consequences are what distinguish the A-section interface later consumed by the theorem.

The A-section functor is built over **one** functor only:

```lean
(projectiveConnection A).toFunctor : GreatCircle.Base ⥤ Grpd
```

the projective Möbius/orbit–stabilizer action (its `obj`/`map` body contains no `A`),
**analytically enriched** with the C1–C4/W/GPV cargo (Rulings A/B). That enriched functor
**is** the A-section functor. Nothing else is involved.

`sectionFunctor A : H1 ⥤ S2` is a **legacy functor over the WRONG groupoids** (the translation
groupoid `H1` and `S2`, not `GreatCircle.Base`). It is **not** the general functor and plays
**no role** in this construction. **Delete it** — leaving it around causes conflation problems.

Other exact current types are:

```lean
projectiveSectionFunctor A : GreatCircle.Base ⥤ Grpd
Total A := ProjectiveTotal (projectiveSectionFunctor A)
zeroTotal A n I : Total A
A.c4_infinite : (Set.range A.sphereZero).Infinite
```

`projectiveSectionFunctor A` currently projects only `.toFunctor`. `ProjectiveConnection A`
stores A-specific states and `zeroToN_analytic` beside that functor. The fibre carrier currently
**on disk** is `NormalizedSlicePoint`, with morphisms `NormalizedSliceHom` — **that is the
shortcut's carrier, not the author's object** (ruling, 2026-07-21: *"There is no one fibre of my
functor"*; *"NormalizedSlicePoint and NormalizedSliceHom have nothing to do with my
orbit–stabilizer construction"*). The two groupoids are `GreatCircle.Base` and `SphereWorld`, and
`obj` is an output of the orbit–stabilizer construction — a description of what is on disk is not
a specification of what the functor's fibre is.

## 2. Ratified author rulings

These rulings are complete and may not be reopened.

### Ruling A — identify the general projective functor

The general $F$-functor is exactly

```lean
(projectiveConnection A).toFunctor : GreatCircle.Base ⥤ Grpd
```

with its A-free Möbius object/map body. It is not the witness $N$. `sectionFunctor A : H1 ⥤ S2`
is a legacy functor over the wrong groupoids — **delete it**; it is not part of this construction.

### Ruling B — ⛔ SUPERSEDED, 2026-07-21

~~The A-section functor **is** the general Möbius/orbit–stabilizer action **analytically
enriched**: the full C1–C4/W/GPV cargo … **is attached to the action as cited theorem-fields, and
the finale consumes those fields.** … Only the fibre carrier *object types*
`NormalizedSlicePoint`/`NormalizedSliceHom` are unchanged (no new fields on the carrier).~~

**Replaced by the author's ruling of 2026-07-21.** The A-section functor is the **wholesale
specialization** of the already-proved general distinguished-element orbit–stabilizer
construction; that one construction *"ensures that F.map and F.obj are simultaneously well defined
on the whole continuum of groupoids."* The two groupoids are **`GreatCircle.Base`** — where the
disk automorphism lives — **and `SphereWorld`**; `𝒯_A` is built from those. So:

- the fibre is **not** an unchanged carrier retained from the shortcut; `obj` is an output;
- the twelve are **properties of the construction's own transports**, carried everywhere
  simultaneously — **not theorem-fields attached beside the action**, which is exactly the
  "frictionless void" the author names;
- deleting the A-specialization must break the **functor's own elaboration**, not merely a
  wrapper or a downstream proof.

### Ruling C — state the canonical zero-output interface

The canonical outputs are `zeroTotal A n I : Total A`, outputs never inputs. Consume both
`A.c4_infinite : (Set.range A.sphereZero).Infinite` and its derived statement that infinitely
many populated zero objects occur in `Total A`.

### Ruling D — state the intrinsic real-value readout

The common value is read off the colimit by `val := colimit.desc (labelCocone) : colim → ℝ` —
the intrinsic label descended out of the colimit; `c := val κ`. This IS the `F : J → α` at the
read-out (F = `val`, J = the colimit, α = ℝ) — REQUIRED; forbidden is only a map fabricated
apart from the label or the pre-colimit `constant_of_preserves_morphisms` (needs `IsConnected`).
No `Disc ℝ`, independent scalar functor, or projection bridge. The colimit identifies the zeros
through the zero→N transports (`toColimitObj_eq_of_zigzag`), **not** a separate
`zigzag_isConnected`/`IsConnected` step; the engine is `pi0GrothendieckEquiv` (Riehl Lemma
8.3.4's proof); its arrows identify the zeros into one class, and `val` reads off `c`. Remark 8.3.5 is credited
for the singleton statement only. Any genuine gap is upstream — the functor's arrows carry the
cargo — never after the colimit.

If a named supplier is absent, record the exact Lean type and stop under the seam rule; never
invent a substitute.

## 3. Non-negotiable mathematical rules

1. **Pure first.** The Möbius formula and orbit--stabilizer alone prove the general functor laws.
2. **No parallel action.** The completed A-section interface uses the author-identified existing
   action; no constant, discrete, or replacement functor is introduced.
3. **Cargo is load-bearing.** The final theorem must become ill-typed if its required analytic
   suppliers are removed from the completed interface.
4. **Zeros are outputs.** C3 supplies the C-residue zero states and C4 supplies their infinitude.
   Neither supplies concentricity, and neither is used to build the pure action.
5. **One $N$.** There is one shared compactified witness, never an indexed family of private
   north objects requiring connectors.
6. **No hand assembly.** No `Classical.choose`, zero-to-zero map, private-$N$ connector, or
   manually composed zigzag is introduced.
7. **Positive type check only.** Do not use the rejected A-free `rfl` comparison between two
   sections. Inspect the printed completed interface and its consumed suppliers.

## 4. Cargo inventory — supplier audit, not a carrier prescription

After Rulings A--D, print the live types of the already-proved author declarations supplying:

- C1 pole/compactified-$N$ content;
- C2 Euler exponential channel;
- C3 Weierstrass divisor and normalized C-residue outputs;
- C4 infinitude;
- normalized zero and pole content;
- GPV transport algebra;
- winding, lift existence/uniqueness, tameness, crossing, and welding consequences;
- the three chart registers of the transported level;
- world/direction compatibility;
- the intrinsic real-value readout named in Ruling D.

For each item record the exact declaration, printed type, axiom report, and the exact slot in the
author-ruled completed interface that consumes it. A filename, docstring, or nearby sibling
field is not enough.

## 5. Step-by-step construction after the rulings

### Step 1 — certify the pure general action

Print the author-identified declaration from Ruling A and its unfolded `obj`, `map`, `map_id`,
and `map_comp`. Confirm that its laws use only the Möbius/Cayley action, orbit--stabilizer/group
laws, and the fixed base/sphere-world categorical laws. C1--C4 must be absent from this
dependency closure.

Do not rebuild the action. Correct only misleading names or prose if Jesse authorizes that
editorial change.

### Step 2 — declare the author-ruled completed interface

Transcribe the exact object, Hom, and exported functor types from Ruling B. This is the only
permitted representation. If Lean requests an additional field or compatibility statement,
print its exact type and stop for Jesse’s dictation.

The underlying action remains the pure action from Step 1. This step does not reprove its
functor laws and does not turn analytic specifications into new theorem hypotheses.

### Step 3 — fill the analytic interface by citation

Fill each slot from the cargo inventory with its named green supplier. Work through the
geographic registers—base/circle, slice/value, GPV tape, Euler passage, Weierstrass passage,
the shared $N$, and direction/world compatibility—without inventing a second proof chain.

Gate:

- every slot has a printed supplier;
- every supplier’s axiom report is expected;
- no supplier depends on a quarantined substitute carrier;
- no `sorryAx` occurs.

### Step 4 — export the completed A-section functor

Export precisely the author-ruled functor from Step 2. Its printed interface and dependency
closure must show that:

- it uses the same underlying Möbius action as Step 1;
- all analytic content required by the finale is reachable through the completed interface;
- projecting the current general action alone is no longer sufficient to type the theorem.

The name `projectiveSectionFunctor A` may be retained or changed only by Jesse’s ruling; names
do not decide identity, printed types do.

### Step 5 — form the corresponding total object

Form the Grothendieck construction of the exact completed functor from Step 4. Do not retarget
`Total A` until its printed definition visibly uses that exact functor. Print the object and Hom
types of the resulting total and the axiom report.

No extra “ordinary-state” litmus test is imposed. The only gate is fidelity to the author-ruled
interface.

### Step 6 — install the C3/C4 outputs

Begin from the exact current terms

```lean
zeroTotal A n I : Total A
A.c4_infinite : (Set.range A.sphereZero).Infinite
```

and transcribe the output function and infinitude proposition fixed in Ruling C. C3 identifies
the zero outputs; C4 proves only their infinitude. The constructor contains each sphere’s own
real coordinate and no common centre.

Gate:

- exact output-family type printed;
- exact C4 consequence printed;
- no pairwise map or equality;
- full build and expected axiom report.

### Step 7 — freeze the finale interface

Before opening `concentricity_theorem`, print one sheet containing:

1. the pure general action;
2. the completed A-section functor;
3. its Grothendieck total;
4. the canonical C3/C4 output family and infinitude statement;
5. the exact relation supplier and intrinsic real-value readout from Ruling D;
6. `pi0GrothendieckEquiv` specialized to that exact completed functor.

All six must refer to the same author-ruled construction. At that point this plan ends and
`CONCENTRICITY_THEOREM_CLOSE_GUIDE_2026-07-17.md` begins.

## 6. Terminal condition for this phase

This phase is complete only when the interface sheet in Step 7 is green, axiom-audited, and
approved by Jesse. It is not a cleanup checkpoint. Save the certificate and move directly to
the categorical finale.
