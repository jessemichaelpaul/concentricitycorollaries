# Final Concentricity handoff

Saved 2026-08-29. This file records the current mathematical and operational
state for closing `ASection.concentricity`. It supersedes the 2026-08-15
north-seed and direct-objectwise-readout handoff. Git history retains that
older checkpoint; it is not execution authority.

## Authority and mandatory reading order

1. Read `Octonionic_RH_master.tex` in full. It is the mathematical authority,
   especially the constructions of `A^slice`, `A_O`, `A_A`, `T_A`,
   the residue-C subdiagram `R_A`, its total inclusion, transitivity, and the
   component-colimit readout.
2. Read this handoff in full. It is the operational authority for reconciling
   Lean with the master.
3. Rescan the live Lean before editing it. A declaration that compiles is not
   thereby correct if its objects, fibres, or readout do not match the master.
4. Treat blueprint sources and pages as generated outputs.

## One constructible register

There is one fixed-A action and one semantic residue-C inverse-image
restriction of it.

* C2 supplies the Euler logarithmic presentation and its GPV lift.
* C1 continues the pole-cancelled factor through the finite real input
  `p_A = 1`.
* C3 supplies the Weierstrass presentation of that same continued factor.
* Evaluation at `p_A` supplies the invertible multiplier `u_A`; the matrix
  `diag(u_A, 1)` and Cayley projectivization produce the A-specific disk
  action `D_A`.
* The constructed orbit representatives and unique stabilizer factors have
  one role: they prove that the object and arrow assignments of
  `A^slice : B -> SphereWorld` are well defined and functorial.
* `A_O : H_1 -> H_1` realizes the positioned slice state equivariantly.
* `A_A : B -> Grpd` has the resulting complete A-specific state triples as
  its fibre objects and uses the already-constructed matrix actions of
  `A^slice` directly; `T_A = int_B A_A` is their action total.

The finite input pole `p_A`, the compactified target value `N`, and a
residue-C zero-sphere output are different objects and must never be
identified. The residue subdiagram is not generated from objects of
`A_A(N)` and is not a north-residue subsystem.

Every category, functor, and morphism used in the argument is constructed
from this fixed A-section. The projective and `G2` groups provide the group
elements, but the actual arrows are always the arrows of the already-built
A-specific action groupoids. No independent ambient Möbius action is an
alternative theorem seat.

After the proof that `A^slice` is a functor, neither `N`, the representatives
`o_b`, nor the stabilizer factors `r_h` may be reopened. They are not analytic
inputs, residue seeds, projections to the pole fibre, transports in `A_A`, or
readouts. The Grothendieck projection only forgets `(b,x)` to `b` and
`(h,gamma)` to `h`; passage to or from the pole fibre is an actual base
morphism acted on by the A-specific transport functor.

No proof-only abbreviation may replace an entry of the state triple. Every
object remains the displayed complete triple, and every component morphism is
the concrete matrix group action in its corresponding action groupoid.

For `h : a -> b`, the normalized input of the transported triple is written
directly as

```text
A^slice(b)⁻¹ · (A^slice(h) · (A^slice(a) · u)).
```

The positioned entry is `A^slice(h) · (A^slice(a) · (I,u))`, and the value
entry is `A_O` applied to that positioned entry. The cancellation by
`A^slice(b)⁻¹` proves that the result is an object of `A_A(b)`. The arrow map
retains the same `G2` matrix. Identities and composites are proved by the
identity and composition equations of the already-built functor `A^slice`.

## Locked definition of the residue-C subdiagram

An A-specific state in the fibre `A_A(b)` is the complete triple

```text
((I,u), A^slice(b) · (I,u), A_O(A^slice(b) · (I,u))).
```

Its residue condition is semantic: the positioned second entry is one of the
already constructed residue-C zero-sphere states. The third entry is its
determined realization by `A_O`; no new residue coordinate or new notation is
added to the locus.

For a base object `a`, select `x : A_A(a)` when a residue-C state
`x0 : A_A(p_A)` and a base morphism `h : p_A -> a` satisfy the action-image
equation

```text
A_A(h)(x0) = x.
```

### Meaning of full subgroupoid

Do not merely assert that `R_A(a)` is a full subgroupoid. Construct its
object and arrow data in order:

```text
Ob R_A(a)
  := {x : Ob A_A(a) | x has the displayed action-image data}.

Hom_{R_A(a)}(x,y)
  := {G2 arrows x -> y in A_A(a)}.
```

The identity, composite, and inverse are the corresponding arrows of
`A_A(a)`.
Their source and target objects remain selected, so they belong to the
displayed hom-sets; associativity, identities, and inverses are exactly those
of `A_A(a)`. This constructs
the groupoid `R_A(a)`. “Full subgroupoid” is the name for the resulting
construction, not a property to assert without exhibiting it.

The inclusion is then defined on objects and arrows by `x |-> x` and
`gamma |-> gamma`. For selected `x,y`, it induces the explicit bijection

```text
Hom_{R_A(a)}(x,y) ~= Hom_{A_A(a)}(iota_{A,a}(x), iota_{A,a}(y)).
```

Injectivity follows because the underlying arrow is unchanged; surjectivity
follows because every arrow in `A_A(a)` between the selected source and target
objects was retained.
This is not a literal equality of dependent Lean arrow types.

For a base arrow `h2 : a -> b`, selected-object closure uses the same state
`x0` and the composite `h1 ≫ h2`:

```text
A_A(h1 ≫ h2)(x0)
  = A_A(h2)(A_A(h1)(x0))
  = A_A(h2)(x).
```

After selected-object closure, define `R_A(h2)(x) := A_A(h2)(x)` with the
constructed action-image data. Define the arrow map through the fibrewise
bijection. Verify preservation of identities and composition after applying
the faithful target-fibre inclusion. Then verify separately, on objects and
arrows, the base identity and base composition equalities. Only after those steps
has the functor `R_A : B -> Grpd` been constructed. Finally, evaluate the
object and arrow equations to prove that the fibre inclusions form
`iota_A : R_A => A_A`.

## Two distinct fullness statements

Do not collapse these assertions.

1. **Fibrewise fullness.** The inclusion
   `iota_{A,a} : R_A(a) -> A_A(a)` is full and faithful because it is the
   displayed bijection on each hom-set. Concretely it retains the same
   underlying `G2` arrow in `A_A(a)`, while Lean wraps that arrow with the proof
   that its source and target objects are selected.
2. **Total fullness.** The induced functor
   `int iota_A : int_B R_A -> T_A` is full and faithful. This is the next
   lemma and requires a proof about total morphism pairs `(h, gamma)`, since a
   total morphism contains both a base and a fibre component.

Exactly one naturality square is used in the total lemma: the square for
`iota_A : R_A => A_A`. Evaluating it at an object identifies the transported
source of the fibre component; this source equality is not a second square.
The two total hom-sets are dependent coproducts over base arrows `h : a -> b`,
and the induced map is simply `(h,gamma) |-> (h,iota(gamma))`: it fixes `h`
while applying the fibrewise hom-set bijection in the `h`-summand. Equality
of images gives equality of the displayed base components and then
fibrewise injectivity; a target pair keeps its base component while
fibrewise surjectivity supplies its preimage. This is the entire reason the
total functor is full and faithful.

## Locked transitivity proof

Begin with arbitrary total objects `P = (a,x)` and `Q = (b,y)` and display
their complete triples and positioned second entries. Their residue membership
witnesses give actual transports from pole-fibre residue states `x0` and `y0`.
Invert the first transport and compose back through the second.

The comparison at the pole uses the normalized pole-fibre transitivity proved
immediately after functoriality of `A^slice`: the concrete real-projective
matrix calculation supplies an actual `k : p_A -> p_A` satisfying

```text
A^slice(p_A)⁻¹ · (A^slice(k) · (A^slice(p_A) · u1)) = u2.
```

This is the normalized-input formula of `A_A(k)` itself. Its inverse
cancellation gives the displayed commutative action square and maps the
positioned entry. Do not expand `k` through a north representative or a
stabilizer factor. The fibre component is the concrete matrix
`gamma : A_A(k)(x0) -> y0` in the `G2` action groupoid; `gamma I1 = I2`, and
equivariance of `A_O` maps the realized third entry. The required total
morphism is the composite with base component `(h1⁻¹ ≫ k) ≫ h2`.

The residue restriction is essential. On the semantic zero-sphere locus the
realized states are the relevant `G2` orbits, so this comparison produces a
morphism between arbitrary residue-total objects. The ambient total `T_A`
also contains arbitrary realizations in `O*` and is not asserted transitive.

Do not revive a north-residue seed, `IsNorthCResidueState`, a north comparison
producer, or an independent generic PGL/Möbius comparison. Use the actual
projective matrix morphism whose action is already bound into the production
`AsectionActionDiagram A`.

## Locked post-transitivity readout

The proof order is:

```text
int_B R_A is transitive
  -> int_B R_A is nonempty and connected
  -> pi0(int_B R_A) is a singleton
  -> pi0(int_B R_A) ~= colim_B(pi0 o R_A)
  -> colim_B(pi0 o R_A) = {kappa}.
```

The readout is not a direct function `Ob(int_B R_A) -> Real` followed by
`constant_of_preserves_morphisms`.

For each fibre, the intrinsic real face already bound into the A-specific
action is a functor

```text
Lambda_b : R_A(b) -> Discrete Real.
```

The adjunction `pi0 |- Discrete` descends it to

```text
lambda_b : pi0(R_A(b)) -> Real.
```

Compatibility with every base transport assembles

```text
lambda : pi0 o R_A => Delta(Real).
```

The colimit universal property produces

```text
barLambda : colim_B(pi0 o R_A) -> Real.
```

The certified `sphereZero n` representatives all enter `barLambda` through
the sole colimit element `kappa`, so their real coordinates agree directly.
After the master display `(Read)`, no further evaluation argument is needed:
the colimit injection, `barLambda`, and the certified representative formula
immediately give
`Re(A.sphereZero(n)) = Re(A.sphereZero(0))`.

The cited theory is Riehl, *Categorical Homotopy Theory*, Remark 8.3.5 and
Mathlib `ConnectedComponents.typeToCatHomEquiv` for `pi0 |- Discrete`;
Riehl, *Category Theory in Context*, Definitions 3.1.1 and 3.1.5--3.1.6 and
Mathlib `Limits.colimit.desc` and `Limits.colimit.iota_desc` for the constant
diagram and universal colimit cocone; and the stated Grothendieck-components
equivalence `pi0(int F) ~= colim(pi0 o F)`.

## Lean reconciliation rule

No claim is made here that the current Lean residue diagram, total inclusion,
transitivity theorem, or readout already implements the corrected master.
Before closing any `sorry`, audit the live declarations against the objects,
arrows, functors, and proof order above. Legacy declarations implementing a
north-seed diagram, a semantic-input replacement total, or a direct objectwise
constant readout must not be used merely because they elaborate.

In the current tree this specifically retires the theorem route through
`CResidueInputTotalCategory`, `CResidueInputTotal_transitive`,
`cResidueInput_level_transport`, and the direct
`constant_of_preserves_morphisms` readout. The fact that the first of these
admits every Möbius arrow is a modeling error, not a second interpretation of
the theorem. Likewise, the declarations built around
`ResidueNorthOrbitProducer` are legacy scaffolding and are not to be closed.
The production seat remains `AsectionCResidueDiagram A`, its Grothendieck
total inside `ambientTotalCategory A`, and the component-colimit readout of
the master. The current implementation of `AsectionActionTransport` through
`orbitStabilizerActionSquare`, and the north-specific comparison declarations
in `Theorem.lean`, do not satisfy the finalized boundary merely because they
elaborate. Reconcile the production transport with the direct
`A^slice(b)⁻¹ · A^slice(h) · A^slice(a)` object formula before closing the
theorem.

The first Lean pass must answer, in order:

1. Does `AsectionCResidueDiagram A` select the semantic residue-C state triples
   inside the production `AsectionActionDiagram A`?
2. Is every fibre literally the full subgroupoid on those selected objects?
3. Is its base-arrow action the restriction of the production A-specific
   transport, with closure proved by composing the action-image morphism?
4. Is `iota_A` the literal natural fibre inclusion, and is its induced total
   functor proved full and faithful by the pair `(h,gamma)` argument?
5. Does transitivity use the arbitrary complete triples, the direct normalized
   action of an actual `k : p_A -> p_A`, `G2`, and equivariance of `A_O`,
   without reopening north representatives or stabilizer factors?
6. Does the readout pass through `pi0 o R_A`, `lambda`, and `barLambda`
   only after the production residue total has collapsed to one component?

Only after these questions are answered from the live types should the Lean
implementation be changed.

## Final implementation order

1. Keep the existing action-groupoid foundations and state triples:
   `AsectionActionStateWorld` and its inferred `Groupoid` instance. Rebuild
   `AsectionActionTransport`, its identity/composition proofs, and
   `AsectionActionDiagram` from the already-proved `AsectionSlice` action,
   using the direct transport formula fixed above and retaining each `G2`
   matrix on arrows.
2. Prove the normalized pole-fibre transitivity statement for the direct
   production transport: the concrete real-projective matrix action supplies
   `k : p_A -> p_A` with the displayed normalized-input equality.
3. Reconcile `IsCResidueState` and `AsectionCResidueDiagram` with the exact
   pole-fibre action-image definition of the master. Remove or quarantine the
   competing semantic-input and north-seed routes from the release path.
4. Keep the full-subgroupoid fibres and the natural inclusion. Recheck the
   total inclusion at the explicit pair map
   `(h,gamma) |-> (h,iota(gamma))`.
5. Prove production-total transitivity directly from arbitrary complete
   triples: inverse A-specific transports to the pole fibre, the direct
   normalized action of the constructed `k`, `G2` for the direction,
   equivariance for the realized value, and composition back to the target
   object.
6. Instantiate the already-proved groupoid/connectedness and
   `pi0GrothendieckEquiv` machinery on this production residue total.
7. Define the fibrewise intrinsic-real functors, descend them through
   `ConnectedComponents.typeToCatHomEquiv`, prove their naturality under the
   A-specific residue transports, and construct `barLambda` with the colimit
   universal property.
8. Prove the certified representative calculation
   `lambda_b([x_n]) = (sphereZero n).re`; then the singleton colimit gives
   `(sphereZero n).re = (sphereZero 0).re` directly.
9. State `ASection.concentricity` on that result and run the full release
   verification below.

`ASection.ZeroDensity` belongs to the separate Li-kernel/density development
and is not an input to any step in this list.

## Verification after Lean reconciliation

Completion requires the kernel:

1. focused and full Lean builds succeed;
2. the target proof's executable-sorry scan is clean;
3. no project axiom is introduced;
4. release declarations use only `propext`, `Classical.choice`, and
   `Quot.sound`;
5. the blueprint is regenerated from the master and agrees with the live
   declaration names.
