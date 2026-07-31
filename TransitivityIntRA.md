# Transitivity of `∫𝓡_A` — author-requested live pre-flight

Date: 2026-07-29.

## Locked live handoff — 2026-07-31

The total morphism is already kernel-green.  Its live local names are
`g`, `h`, `k`, `φ`, `hg`, `hh`, `hback`, and `hsrc`.  It is assembled by

```lean
⟨⟨(CategoryTheory.Groupoid.inv g ≫ k) ≫ h,
  ((AsectionCResidueInclusion A).app Q.base).preimage
    (eqToHom hsrc ≫
      (AsectionActionTransport A h).map φ ≫
      eqToHom hh)⟩⟩
```

The only names to place in front of automated proof search at the north
seat are `kE`, `kW`, `uStar`, `hE`, and `hW`.  Production already exports
`ASection.northRelativeLoop_maps` and
`ASection.northComparison_of_parallelFaces`; the latter is consumed as

```lean
refine ⟨CategoryTheory.Groupoid.inv kE ≫ kW, ?_⟩
exact A.northComparison_of_parallelFaces
  kE kW _ _ uStar hE hW
```

Hence `k` is definitionally the relative loop
`CategoryTheory.Groupoid.inv kE ≫ kW`, and the theorem supplies `φ`.
`residueTotal_morphism_of_northComparison_audit A P Q xN yN g hg h hh k φ`
is the focused green certificate for the entire remaining total-morphism
tail.  Failure of unrestricted `aesop` before these bindings are present is
only missing local declarations; it is not permission to synthesize a new
Möbius/PGL witness.

This is the single live pre-flight for the open proof in
`Concentricity/Theorem.lean:445`. It is not a replacement for
`Octonionic_RH_master.tex`, does not alter the theorem statement, and does
not advance to connectedness, `π₀`, the singleton class, its value, or
concentricity.

## Collaboration checkpoint — saved 2026-07-30

The author has already supplied and hand-walked the mathematical proof of
this lemma.  Formalization must not become an oral examination of the
author's memory for Lean identifiers, nor may ordinary uncertainty about an
identifier be treated as uncertainty about the mathematical object.

The division of labour is fixed:

1. The author identifies the exact mathematical object or construction in
   the project's own register.
2. The formalization assistant recovers its precise Lean declaration using
   the pre-filled greps and the certified library.
3. The assistant types the agreed construction without replacing it by a
   generic object, predicate, map, or ambient theorem.
4. Lean checks the term.
5. If Lean rejects it, the exact kernel or elaborator response determines
   the next local repair; algebraic cancellation, reassociation, coercions,
   and transport orientation are retried from that evidence.

The assistant must not trade places with the kernel.  In particular, it
must not convert a missing name, an untried term, or a failed elaboration
into an informal mathematical veto.  Skepticism is neutral only when the
same standard is applied to the assistant's proposed substitutions.  The
past failure mode was directional: certified, project-specific structure
was repeatedly questioned while generic replacements invented by models
were granted unwarranted trust.

For this proof, the fixed outer register is the particular C-residue
Grothendieck system `∫𝓡_A`.  Its two arbitrary objects are already the
triple-certified C-residue `0 → N` inclusions under discussion.  The target
is a morphism between them, not an equality.  Their respective certified
functorial faces are wired to `F_A(E_N)` and `F_A(W_N)`; the already-green
relative north loop and `G₂` direction transport are then assembled into
the total Grothendieck morphism.  Downstream consequences have no role in
checking this lemma.

The governing facts are:

- there is one projective base `GreatCircle.Base`;
- there is one north object `N = projectiveNorth`;
- there is one continuously indexed Euler–Weierstrass–GPV action `V_A`;
- C3 supplies one Weierstrass presentation of its one distinguished
  diagonal Möbius element;
- its evaluation at every instant is an actual action square and hence an
  actual transport;
- every base arrow, stabilizer expression, square, and transport used below
  must be a typed face of that same A-specific element;
- no arbitrary group element or residue-indexed C3 stabilizer element may be
  introduced;
- `G₂` acts only after the projective coordinate has been transported.

No equality of distinct residue coordinates, common real part, convergence
of zero coordinates to `N`, connectedness, singleton class, or common level
is assumed.

---

## 1. Exact target

The open declaration is:

```lean
theorem ASection.sweepTransitive_on_residueSystem (A : ASection) :
    ∀ P Q : Grothendieck
      (AsectionCResidueDiagram A ⋙ Grpd.forgetToCat),
      Nonempty (P ⟶ Q)
```

Source: `Concentricity/Theorem.lean:445`.

For arbitrary `P,Q : ∫𝓡_A`, the preimage property supplies

```text
xN : AsectionActionFiber A N
hxN : IsNorthCResidueState A xN
g  : N ⟶ P.base
hg : (AsectionActionTransport A g).obj xN = P.fiber.obj

yN : AsectionActionFiber A N
hyN : IsNorthCResidueState A yN
h  : N ⟶ Q.base
hh : (AsectionActionTransport A h).obj yN = Q.fiber.obj.
```

The desired total base component is

```text
g⁻¹ ≫ k ≫ h
```

for one endomorphism `k : N ⟶ N`. Its fibre component is obtained from a
north-fibre morphism

```text
φ : (AsectionActionTransport A k).obj xN ⟶ yN
```

by applying `AsectionActionTransport A h` and inserting the functorial
transport equalities.

---

## 2. The one action in five registers

The full `V_A` is a continuous family, not a second base and not an extra
premise. At every instant `t`, it evaluates to an actual action square:

```text
analytic:  Γ_A : [0,1] → ℂ
group:     d_A(t) = diskExpAction (Γ_A(t))
square:    positionedOrbitSquare f (d_A(t))
functor:   the induced action-state transport
total:     a Grothendieck morphism after its fibre component is chosen
```

Live receipts:

- the complete lift package:
  `Concentricity/ASectionFunctor.lean:647`;
- its canonical construction:
  `Concentricity/ASectionFunctor.lean:675`;
- the pointwise orbit square:
  `Concentricity/ASectionFunctor.lean:719`;
- identity and multiplication:
  `Concentricity/ASectionFunctor.lean:744,758`;
- the canonical presentation:
  `Concentricity/ASectionFunctor.lean:820`;
- the pointwise Euler-to-north square:
  `Concentricity/ASectionFunctor.lean:1181`.

Thus the function, group element, square, functor, and total morphism are
typed readings of one action.

---

## 3. Orbit–stabilizer and the north specialization

Put

```text
C   = cayleyProjective
D   = D_A = distinguishedDiskAction A
o_X = orbitRep X
s_f = stabilizerPart f.
```

The certified formulas are

```text
f   = o_Y · s_f · o_X⁻¹
F_X = C(o_X) · D
𝒜(f) = F_Y · C(s_f) · F_X⁻¹
     = C(o_Y) · D · C(s_f) · D⁻¹ · C(o_X)⁻¹.
```

Receipts:

- `orbitRep`: `Concentricity/ProjectiveSection.lean:73`;
- `stabilizerPart`: `Concentricity/ProjectiveSection.lean:98`;
- factorization: `Concentricity/ProjectiveSection.lean:118`;
- uniqueness: `Concentricity/ProjectiveSection.lean:131`;
- multiplication: `Concentricity/ProjectiveSection.lean:159`;
- `projectiveObjectFrame`: `Concentricity/ProjectiveSection.lean:243`;
- `projectiveObjectFrame_north`:
  `Concentricity/ProjectiveSection.lean:260`;
- `projectiveArrowElement`: `Concentricity/ProjectiveSection.lean:292`;
- full expansion: `Concentricity/ProjectiveSection.lean:451`;
- frame compatibility: `Concentricity/ProjectiveSection.lean:468`.

At the one north object,

```text
o_N = 1
F_N = D.
```

For `k : N ⟶ N`, `k.val` fixes `N`, hence is an element of
`GreatCircle.NorthStabilizer`. Since both orbit representatives are the
identity,

```text
s_k = k.val
R_k = C(s_k)
L_k = D · C(s_k) · D⁻¹.
```

As a group, `Stab(N)` is

```text
MulAction.stabilizer (PGL(2, ℝ)) ∞.
```

As a groupoid register, it is the endomorphism group at `N` in
`GreatCircle.Base`; Mathlib identifies these through
`ActionCategory.stabilizerIsoEnd`.

---

## 4. Consume C3, without consuming the conclusion

Define the positioned coordinates

```text
z₁ = xN.positioned.back.coordinate
z₂ = yN.positioned.back.coordinate.
```

Unfolding `hxN,hyN` and instantiating
`mem_CResidueZeroLocus_iff_exists_sphereZero`
(`Concentricity/ASectionCResidue.lean:40`) gives

```text
∃ n₁ n₂,
  z₁ = (A.sphereZero n₁ : OnePoint ℂ) ∧
  z₂ = (A.sphereZero n₂ : OnePoint ℂ).
```

This is the only conclusion drawn from membership at this point. It
supplies two actual C3 divisor coordinates. It does **not** license a
zero-indexed projective leg to `N`.

The former `normalizedNBaseHom n` / `normalizedNActionSquare n` branch was
removed on 2026-07-29: it incorrectly replaced the one fixed `0 → N` spine
by a family of arrows from `Re(sphereZero n)` to `N`.

The live categorical supplier is instead the fixed-spine presentation
`canonicalAsectionPresentation_euler_toNorth`: for every instant `t` of
the one Euler tape, it gives the action square over the same
`orbitHomToNorth` base leg. C3 enters by selecting the inverse-groupoid
outputs of that action, not by changing its base arrow.

### The inverse-image discipline

The inputs `u₁,u₂` are not arbitrary ambient coordinates later compared
with the residue locus. `IsNorthCResidueState` is the inverse-image
condition at the one north frame, and an `AsectionActionState` is already
the graph of the action:

```text
xN.positioned
  = (coordinateTransport A (projectiveObjectFrame A N)).obj xN.input,
yN.positioned
  = (coordinateTransport A (projectiveObjectFrame A N)).obj yN.input.
```

Since `projectiveObjectFrame A N = D`, the two hypotheses say precisely

```text
D(u₁) = z₁ ∈ CResidueZeroLocus A,
D(u₂) = z₂ ∈ CResidueZeroLocus A.
```

Equivalently,

```text
u₁,u₂ ∈ D⁻¹(CResidueZeroLocus A).
```

Thus the right leg acts on inputs which belong to the action-theoretic
preimage of the C3 residue locus by definition. The proof must retain this
chain:

```text
inverse-image membership
  → action-state graph equation
  → D(uᵢ)=zᵢ
  → C3 identifies zᵢ as sphereZero(nᵢ).
```

It must not replace it with an assertion about arbitrary ambient inputs.

---

## 5. Read the two states in the existing projective chart

Define the north input coordinates

```text
u₁ = xN.input.back.coordinate
u₂ = yN.input.back.coordinate.
```

For the two inverse-image states, the action-state graph satisfies

```text
zᵢ = D(uᵢ).
```

This follows definitionally from the state graph equation, while
`IsNorthCResidueState` supplies that the resulting `zᵢ` lies in the C3
residue locus. The coordinate calculation uses
`coordinateTransport_obj_coordinate`
(`Concentricity/ASectionFunctor.lean:463`) and
`projectiveObjectFrame_north`
(`Concentricity/ProjectiveSection.lean:260`).

The equivariant functor has not forgotten `uᵢ`: its physical input is
`spherePt world coordinate`, and the certified inverse chart
`coordAt_spherePt` recovers the same stem coordinate.

The projective element is the Cayley-chart reading of the base action:

```text
cayleyCoord_equivariant :
  (cayleyProjective g).val (cayleyCoord x) = cayleyCoord (g • x).
```

The `Complex.UnitDisc` parameters and
`distinguishedMoebius_mul` certify the earlier normal-form multiplication;
they are not extra state coordinates and must not be introduced as such in
this proof.

### Typed round-trip lookup anchors

The active declarations expose the relevant stored faces as follows:

```text
AsectionEquivariant.obj q
  = ⟨q.fst, A.realize q.back⟩

AsectionState.input ⟨I,z⟩
  = spherePt I z

coordinateTransport m ⟨I,z⟩
  = ⟨I,m(z)⟩

residueState A n I
  = ⟨I,(sphereZero n : OnePoint ℂ)⟩.
```

The right leg of `orbitStabilizerActionSquare` is
`cayleyProjective (stabilizerPart f)`, while
`ActionTransportSquare.coordinateTransport_commutes` reads its action on
the stored `AsectionState.coordinate`.  These are lookup anchors for the
typed boundary faces `F_A(E_N)` and `F_A(W_N)`, not a new premise and not a
mathematical objection to the relative-action argument.

---

## 6. Compare the two stored positions

Instantiate the one distinguished pole action on the two exact inputs of
the inverse C-residue system.  Euler and Weierstrass are its two certified
presentations:

```text
distinguishedPoleFactor_euler
distinguishedPoleFactor_weierstrass
distinguishedDiskAction_eq_fullMultiplier
projectiveObjectFrame_north.
```

Rearranging the two evaluations through the already-built
Möbius/orbit--stabilizer equations exposes their relative north face `r`
satisfying

```text
C(r)(u₁) = u₂,       C = cayleyProjective.
```

Package this exact relative face as
`k : projectiveNorth ⟶ projectiveNorth`.  Since both endpoints are north,
the orbit representatives are identities and `stabilizerPart_unique`
identifies the residual factor of `k` with `r`.  The accepted right leg is
therefore `R_k = C(r)`.

Conjugating through the common north frame then gives

```text
L_k(z₁)
  = D C(r) D⁻¹(z₁)
  = D C(r)(u₁)
  = D(u₂)
  = z₂.
```

This is the projective coordinate comparison. It does not use `G₂`, does
not feed a zero to Euler, and does not introduce a zero-indexed arrow to
`N`.

---

## 7. Supply the fibre arrow with `G₂`

Coordinate transport leaves the sphere direction unchanged. After applying
`k`, the transported input coordinate agrees with `yN.input.coordinate`.

Instantiate

```lean
G2.exists_smul_eq_of_mem_unitImaginarySphere
```

on the transported direction and `yN`'s direction. The resulting `g₂`
changes only the sphere direction and fixes the already-matched coordinate.
Package it through `InducedCategory.homMk` to obtain

```text
φ : (AsectionActionTransport A k).obj xN ⟶ yN.
```

The positioned state and value faces require no independent choices: they
are inherited by the generated action-state graph.

---

## 8. Assemble the one total morphism

The base part is

```text
g⁻¹ ≫ k ≫ h : P.base ⟶ Q.base.
```

Functoriality gives

```text
A(g⁻¹ ≫ k ≫ h)(P.fiber.obj)
  =
A(h)(A(k)(A(g⁻¹)(P.fiber.obj))).
```

Using `hg`, the groupoid inverse laws, and
`AsectionActionTransport_comp`
(`Concentricity/ASectionActionDiagram.lean:313`) reduces the innermost
state to `xN`. Apply `AsectionActionTransport A h` to `φ`, and use `hh` at
the target.

The resulting ambient total morphism is pulled back through the full
C-residue inclusion exactly as in the current body of
`sweepTransitive_on_residueSystem`:

```lean
((AsectionCResidueInclusion A).app Q.base).preimage ...
```

This produces one morphism `P ⟶ Q` in `∫𝓡_A`.

---

## 9. Lean-role ledger

| Proof action | Role |
|---|---|
| Introduce `P,Q` and open their preimage witnesses | instantiation |
| Rewrite the north graph equations as `D(uᵢ)=zᵢ` | definitional/inverse-image unpacking |
| Recover `n₁,n₂` from `hxN,hyN` | instantiation of C3 completeness |
| Read `u₁,u₂` through the already-existing Cayley chart | chart/normalization instantiation |
| Compare the two evaluations of the distinguished pole action and expose `r` | Möbius/orbit–stabilizer inference |
| Package `r` as `k : N ⟶ N` | action-category constructor |
| Prove `R_k(u₁)=u₂` | group algebra |
| Conjugate to prove `L_k(z₁)=z₂` | group algebra and frame rewriting |
| Choose the `G₂` direction element | instantiation |
| Package `φ` | categorical constructor |
| Compose `g⁻¹ ≫ k ≫ h` | categorical composition |
| Pull back through the full inclusion | instantiation of fullness |

No new mathematical premise appears. If Lean needs a local `have` for one
of the displayed equalities, that `have` is a proof term assembled from the
listed declarations, not a new declaration of the theory.

---

## 10. Inline Lean shape

This is a type-level sketch, not code to paste unchanged:

```lean
intro P Q
obtain ⟨xN, hxN, g, hg⟩ := P.fiber.property
obtain ⟨yN, hyN, h, hh⟩ := Q.fiber.property

-- C3 instantiation
obtain ⟨n₁, hn₁⟩ := ...
obtain ⟨n₂, hn₂⟩ := ...

-- read the stored inputs in the existing Cayley/projective chart
let u₁ := xN.input.back.coordinate
let u₂ := yN.input.back.coordinate

-- compare two evaluations of the one distinguished pole action
obtain ⟨k, hR⟩ : ∃ k : projectiveNorth ⟶ projectiveNorth, ... := by
  -- distinguished pole action + C3/Weierstrass face
  -- + orbit–stabilizer factorization; orientation settled by `group`
have hL : ... := by
  -- projectiveObjectFrame_north and D C(r) D⁻¹

-- remaining direction
obtain ⟨g₂, hg₂⟩ :=
  G2.exists_smul_eq_of_mem_unitImaginarySphere ... ...
have φ : (AsectionActionTransport A k).obj xN ⟶ yN := by
  -- InducedCategory.homMk; hR/hL + hg₂

-- the one morphism of ∫𝓡_A
refine ⟨⟨(CategoryTheory.Groupoid.inv g ≫ k) ≫ h,
  ((AsectionCResidueInclusion A).app Q.base).preimage ?_⟩⟩
-- rewrite transport composition, apply (AsectionActionTransport A h).map φ
```

For exposition, the transitivity statement may be displayed after the main
proof body as the conceptual lemma the proof has established.  Lean
declaration order is separate: if the main theorem cites a named helper,
that helper must occur earlier in the Lean file (or be proved locally and
re-exported under the public name afterward).

---

## 11. Pre-flight checks

Required before editing `Theorem.lean`:

1. `distinguishedPoleFactor_euler` and
   `distinguishedPoleFactor_weierstrass` are checked as two presentations
   of `distinguishedPoleFactor`;
2. `diskExpAction_distinguishedPoleLog`,
   `distinguishedDiskAction_eq_fullMultiplier`, and
   `projectiveObjectFrame_north` are in the active import closure;
3. `cayleyCoord_equivariant`, `orbit_stabilizer_factor`, and
   `stabilizerPart_unique` are in the active import closure;
4. the north specializations of
   `AsectionActionTransport_obj_input` and
   `AsectionActionTransport_obj_positioned` reduce to the displayed
   `R_k` and `L_k`;
5. the local comparison is kernel-checked in an audit before replacing the
   localized `sorry`;
6. the C-residue locus and geometric walk-around audits compile;
7. the full project compiles on the pinned Lean/Mathlib toolchain.

Pre-filled search:

```sh
rg -n "distinguishedPoleFactor_(euler|weierstrass)|distinguishedDiskAction_eq_fullMultiplier" \
  Concentricity/ProjectiveTransport.lean
rg -n "projectiveObjectFrame_north|projectiveArrowElement|stabilizerPart_unique" \
  Concentricity/ProjectiveSection.lean
rg -n "cayleyCoord_equivariant|canonicalAsectionPresentation_euler_toNorth" \
  Concentricity/CayleyDictionary.lean Concentricity/ASectionFunctor.lean
rg -n "AsectionActionTransport_obj_(input|positioned)" \
  Concentricity/ASectionActionDiagram.lean
```

### Exact kernel audit — 2026-07-30

The focused receipt
`Concentricity/_GateNorthCResidueTransitivityAudit.lean` now names and
kernel-checks every part of the proof surrounding the two exact boundary
faces.  Every row below prints precisely
`[propext, Classical.choice, Quot.sound]`.

| Exact clause | Green receipt |
|---|---|
| a north C-residue state is an actual `residueActionState` | `northState_is_residueActionState_audit` |
| its input is `D_A⁻¹(sphereZero n)` | `residueActionState_north_input_audit` |
| a north loop acts through `C(stabilizerPart k)` | `residueActionTransport_north_input_audit` |
| the common source factor cancels in `k_E⁻¹ ≫ k_W` | `northRelativeLoop_stabilizer_audit` |
| the relative loop carries the first certified input to the second | `northRelativeLoop_maps_audit` |
| the two parallel boundary equations produce the north-fibre morphism | `northComparison_of_parallelFaces_audit` |
| the same cancellation in the native sphere and functor registers | `sphereWorld_relative_stem_audit`, `sphereWorld_relative_stem_maps_audit`, `sphereWorld_relative_functor_audit` |
| the same cancellation in the two-legged square register | `relativeActionSquare_left_audit`, `relativeActionSquare_right_audit`, `relativeActionSquare_transport_audit` |
| `g⁻¹ ≫ k ≫ h` and fullness produce `P ⟶ Q` in `∫𝓡_A` | `residueTotal_morphism_of_northComparison_audit` |

Consequently the only remaining work at the localized `sorry` is:

1. **Declarations/names:** give local Lean names to the two already-built
   boundary faces `E_N` and `W_N`, with their common projective source and
   the one target `N`.  These are typed readings of the fixed
   Euler--Weierstrass--GPV action, not new mathematical data.
2. **Instantiations:** evaluate those two faces on the common reference
   input `u_*`, obtaining the two equations consumed by
   `northComparison_of_parallelFaces_audit`.
3. **Wiring:** instantiate that green theorem, then pass its `k` and fibre
   arrow to `residueTotal_morphism_of_northComparison_audit`.
4. **Production edit:** replace the localized `sorry` in
   `sweepTransitive_on_residueSystem` with those local declarations and
   applications.

There is no remaining mathematical inference in this lemma.  Its sole
load-bearing inference is the relative stabilizer cancellation, and the
kernel has checked that inference in the projective, sphere, functor, and
action-square registers.

### Results — refreshed 2026-07-30

- `Concentricity/_GeometricWalkKernelAudit.lean`: passed.
- `Concentricity/_GateCResidueZeroLocusAudit.lean`: passed.
- Both audits report only the accepted kernel dependencies
  `[propext, Classical.choice, Quot.sound]` for the declarations used here.
- `lake build`: passed; all 3,697 jobs completed successfully on the pinned
  toolchain. The output contains existing style-linter warnings, but no build
  error.
- `git diff --check`: clean.
- Production checkpoint: `Concentricity/Theorem.lean` now kernel-checks the
  inverse-image-to-C3 canonicalization for both arbitrary north states.  The
  former request that their untransported input coordinates be equal is
  gone.
- The surrounding Grothendieck construction is complete: once the north
  comparison supplies `k` and `φ`, the base leg is `g⁻¹ ≫ k ≫ h`, the fibre
  leg is transported through `h`, and fullness of `ι_A` pulls the same arrow
  into `∫𝓡_A`.
- The sole open seat is now exactly

  ```lean
  ∃ k : projectiveNorth ⟶ projectiveNorth,
    Nonempty ((AsectionActionTransport A k).obj xN ⟶ yN)
  ```

  after both states have been rewritten as actual C3
  `residueActionState`s.  Its production suppliers are the exact local
  `F_A(E_N)` and `F_A(W_N)` faces of the distinguished action, their
  already-certified relative cancellation, and the `G₂` direction action.
  No separately manufactured ambient action is admissible.

---

## 12. Author-confirmed Lean declaration register — 2026-07-30

The primary Lean type of each named boundary face is confirmed to be an
`ActionTransportSquare`.  This is the register in which the proof uses the
two rectangles: a square retains both its input Möbius leg and its positioned
Möbius leg, together with the equation saying that they are two faces of one
action.

The relevant structure is already live:

```lean
structure ActionTransportSquare (source target : Moebius) where
  left : Moebius
  right : Moebius
  commutes : left * source = target * right
```

For the transitivity proof the notation is read as follows.

| Paper notation | Lean reading |
|---|---|
| \(E_N\) | an `ActionTransportSquare sourceFrame northFrame` |
| \(W_N\) | an `ActionTransportSquare sourceFrame northFrame` |
| input leg of \(E_N\) | `E_N.right` |
| positioned leg of \(E_N\) | `E_N.left` |
| \(F_A(E_N)\) | `E_N.actionStateTransport A` |
| \(F_A(W_N)\) | `W_N.actionStateTransport A` |
| relative north square | `E_N.inv.comp W_N` |
| relative input stem | `(E_N.inv.comp W_N).right` |
| relative positioned stem | `(E_N.inv.comp W_N).left` |
| functorial round trip | `(E_N.inv.comp W_N).actionStateTransport A` |

The author-confirmed local functor names are therefore:

```lean
let FE := eulerSquare.actionStateTransport A
let FW := weierstrassSquare.actionStateTransport A
```

`FE` and `FW` are abbreviations for the two functorial faces; they are not
additional functors and they carry no new assumptions.

The relative formulas are already kernel-checked:

```lean
(E_N.inv.comp W_N).right = W_N.right * E_N.right⁻¹
(E_N.inv.comp W_N).left  = W_N.left  * E_N.left⁻¹

(E_N.inv.comp W_N).actionStateTransport A =
  E_N.inv.actionStateTransport A ⋙ W_N.actionStateTransport A
```

### 12.1 The supporting base faces

`ActionTransportSquare` stores the two Möbius legs, but it deliberately does
not duplicate the projective-base arrow from which the square was generated.
Therefore the local proof keeps the two already-built base faces next to the
two squares:

```lean
let kE : projectiveZero ⟶ projectiveNorth := exactEulerNorthFace
let kW : projectiveZero ⟶ projectiveNorth := exactWeierstrassNorthFace

let E_N : ActionTransportSquare sourceFrame northFrame :=
  exactEulerNorthSquare
let W_N : ActionTransportSquare sourceFrame northFrame :=
  exactWeierstrassNorthSquare
```

The four identifiers on the right in this display are **curation seats**, not
new constants and not hypotheses.  Before production insertion each seat must
be replaced by the exact existing A-specific term exposed from:

* `distinguishedPoleFactor_euler` and
  `distinguishedPoleFactor_weierstrass`, the two presentations of the one
  `distinguishedPoleFactor`;
* `distinguishedDiskAction_fixes_cayley_zero` and
  `distinguishedDiskAction_fixes_cayley_N`, the two boundary readings of the
  same diagonal Möbius element;
* `canonicalAsectionPresentation_euler_toNorth`, the fixed continuous GPV
  tape in its `ActionTransportSquare` register;
* `positionedOrbitSquare A ... (1 : Moebius)`, the literal `d = 1`
  instantiation used by the C-residue inclusion.

No `kE`, `kW`, `E_N`, or `W_N` is to be manufactured from an arbitrary group
element.  The local declarations only name the exact Euler and Weierstrass
faces already supplied by A's distinguished action.

### 12.2 Declaration, instantiation, and wiring

The final local block has three syntactically different jobs.

#### Declaration

```lean
let E_N : ActionTransportSquare sourceFrame northFrame := ...
let W_N : ActionTransportSquare sourceFrame northFrame := ...
```

`let` introduces abbreviations.  It proves no proposition and adds no
premise.  After the line, Lean may replace `E_N` by its right-hand side
definitionally.

#### Instantiation

```lean
have hE := E_N.apply uStar
have hW := W_N.apply uStar
```

`ActionTransportSquare.apply` is the existing theorem

```lean
E_N.left.val (sourceFrame.val uStar) =
  northFrame.val (E_N.right.val uStar).
```

Thus `hE` and `hW` do not assert new boundary laws.  They specialize each
square's stored commuting equation to the already-forced input `uStar`.
Rewriting the named legs and the north frame turns these into precisely

```lean
(GreatCircle.cayleyProjective
  (GreatCircle.stabilizerPart kE).1).val uStar =
    xN.input.back.coordinate

(GreatCircle.cayleyProjective
  (GreatCircle.stabilizerPart kW).1).val uStar =
    yN.input.back.coordinate
```

#### Wiring

```lean
refine ⟨CategoryTheory.Groupoid.inv kE ≫ kW, ?_⟩
exact northComparison_of_parallelFaces_audit
  A kE kW xN yN uStar hE hW
```

This applies the already-green relative cancellation and `G₂` packaging.
The result has the exact local target

```lean
Nonempty
  ((AsectionActionTransport A
    (CategoryTheory.Groupoid.inv kE ≫ kW)).obj xN ⟶ yN)
```

The surrounding production proof then performs its already-written wiring:

```lean
g⁻¹ ≫ (kE⁻¹ ≫ kW) ≫ h
```

and fullness of `∫ι_A` returns the morphism to `∫𝓡_A`.

### 12.3 Why the square is the primary declaration

Naming only the base arrows would hide the commuting rectangles and force
Lean to reconstruct their left legs later.  Naming only the Möbius elements
would drop their projective provenance.  Naming the
`ActionTransportSquare`s while retaining their supporting base components
keeps all registers visible:

```text
projective base arrow
        ↓ positionedOrbitSquare
two-legged Möbius rectangle
        ↓ actionStateTransport A
functor between A-action fibres
        ↓ Grothendieck packaging
morphism in the residue total
```

This is the typed form of the one distinguished action being simultaneously
a function, a group element, a functor, and a total morphism.
