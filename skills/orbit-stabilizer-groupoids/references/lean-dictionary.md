# Lean dictionary for orbit–stabilizer groupoids

## Version pin

The project uses:

```text
Lean 4.31.0
Mathlib v4.31.0
revision fabf563a7c95a166b8d7b6efca11c8b4dc9d911f
```

Read exact types from `.lake/packages/mathlib` before implementation.

Pinned source prefix:

```text
https://github.com/leanprover-community/mathlib4/blob/
fabf563a7c95a166b8d7b6efca11c8b4dc9d911f/
```

## Action groupoid

Source: `Mathlib/CategoryTheory/Action.lean`.

| declaration | role |
|---|---|
| `CategoryTheory.actionAsFunctor` | a group or monoid action as a functor from the one-object category |
| `CategoryTheory.ActionCategory` | the category of elements of that action functor |
| `ActionCategory.objEquiv` | identifies action-category objects with acted-on points |
| `ActionCategory.hom_as_subtype` | arrows are scalars satisfying `g • x = y` |
| `ActionCategory.stabilizerIsoEnd` | the point stabilizer is definitionally the endomorphism monoid |
| `ActionCategory.instGroupoid` | a group action produces a groupoid |
| *(anonymous instance,* `Action.lean:128`*)* | a nonempty transitive action produces a connected action category — **obtain by resolution, never by name** (see below) |

Critical composition convention:

```lean
(f ≫ g).val = g.val * f.val
```

Do not reverse `f` and `g` when translating categorical composition into
group multiplication.

## Quotient–orbit equivalence

Source: `Mathlib/GroupTheory/GroupAction/Quotient.lean`.

Mathlib’s exact orientation is:

```lean
MulAction.orbitEquivQuotientStabilizer G x :
  MulAction.orbit G x ≃ G ⧸ MulAction.stabilizer G x
```

Use `.symm` for the customary displayed direction
`G / Stab(x) ≃ Orb(x)`.

Related declarations:

| declaration | role |
|---|---|
| `MulAction.ofQuotientStabilizer` | sends a stabilizer coset to its action on `x` |
| `MulAction.injective_ofQuotientStabilizer` | uniqueness of the quotient presentation |
| `MulAction.orbitEquivQuotientStabilizer_symm_apply` | evaluates the quotient–orbit equivalence as the action |
| `MulAction.stabilizer_quotient` | the vertex stabilizer in `G ⧸ H` is `H` |

The set equivalence and the action groupoid are complementary:
`orbitEquivQuotientStabilizer` supplies the quotient–orbit carrier
equivalence, while `stabilizerIsoEnd` identifies the retained vertex group.

## Full invariant subgroupoid

Source:
`Mathlib/CategoryTheory/ObjectProperty/FullSubcategory.lean`.

Given `P : ObjectProperty D`:

```lean
P.FullSubcategory
P.ι : P.FullSubcategory ⥤ D
P.fullyFaithfulι
```

If `F : C ⥤ D` and `hF : ∀ X, P (F.obj X)`, use:

```lean
P.lift F hF : C ⥤ P.FullSubcategory
P.liftCompιIso F hF : P.lift F hF ⋙ P.ι ≅ F
```

The latter is `Iso.refl _`; the restriction square is definitionally the
ambient functor. The object and map projections are also `rfl`:

```lean
P.ι_obj_lift_obj
P.ι_obj_lift_map
```

### Standard restriction pattern

> **Concentricity gate warning (2026-07-27).** The pattern below is generic
> background for objectwise selections. In the live project it may occur
> only INSIDE the final A-specific construction — never as the subject, and
> never as an instruction to begin from an objectwise predicate and prove
> `hT`. For orbit-wise selections the `hT` clause is **vacuous**: arrows of
> an action groupoid cannot leave the orbit of their domain (CTIC
> Ex. 1.5.19). The categorical lock in the parent `SKILL.md` overrides any
> lower-level reading of this section.

For object properties `P_X` and `P_Y`, an ambient functor
`T : D_X ⥤ D_Y`, and a preservation proof:

```lean
hT : ∀ x : P_X.FullSubcategory, P_Y (T.obj x.obj)
```

define:

```lean
P_Y.lift (P_X.ι ⋙ T) hT
```

The inclusion square is:

```lean
P_Y.liftCompιIso (P_X.ι ⋙ T) hT
```

Do not manually reconstruct object maps, morphism maps, identity laws,
composition laws, or fullness/faithfulness.

## Natural subdiagram

For `F : B ⥤ Grpd`, object properties `P_X`, and preservation under every
`F.map f`:

1. set the object of the restricted diagram at `X` to
   `Grpd.of P_X.FullSubcategory`;
2. set its arrow map to the `ObjectProperty.lift` restriction;
3. inherit identities and composition from `F` and the definitional
   inclusion;
4. define the inclusion natural transformation from the full-subcategory
   inclusions.

Use functor composition `⋙`, not morphism composition `≫`.

## Totalization after restriction

Source: `Mathlib/CategoryTheory/Grothendieck.lean`.

Once `ι : R ⟶ F` exists:

```lean
CategoryTheory.Grothendieck.map ι
```

is the induced functor of totals, and:

```lean
CategoryTheory.Grothendieck.functor_comp_forget
```

states that it lies over the original base. Do not invoke this before the
restricted diagram and natural inclusion are certified.

This total map certifies provenance:

```text
∫R ⟶ ∫F
```

This is a functor between separately bundled categories, not a
set-theoretic subset inclusion. It says functorially that the restricted
total consists of the selected value states in the ambient total. It does
not itself prove that `π₀(∫R)` is a singleton, and it does not replace
`pi0GrothendieckEquiv`.

## Remark 8.3.5: categorical components

Sources:

```text
Mathlib/CategoryTheory/Action.lean
Mathlib/CategoryTheory/IsConnected.lean
Mathlib/CategoryTheory/ConnectedComponents.lean
```

Keep the three levels distinct:

```text
transitive group action
  → categorically connected ActionCategory
  → singleton ConnectedComponents carrier.
```

The first arrow is a Mathlib instance. ⛔ **It is declared anonymously, so it
has no source-written name — do not cite one.** The source reads:

```lean
-- Mathlib/CategoryTheory/Action.lean:128
instance [IsPretransitive M X] [Nonempty X] : IsConnected (ActionCategory M X) :=
```

Lean auto-generates the name; a guessed auto-name (for example
`ActionCategory.instIsConnectedOfIsPretransitiveOfNonempty`) may not resolve,
and a name-resolution failure inside a pre-flight is a fact about the name,
never about the mathematics. Obtain it by typeclass resolution instead:

```lean
(inferInstance : IsConnected (ActionCategory G X))
```

or `#synth IsConnected (ActionCategory G X)` in a pre-flight. Supply
`[IsPretransitive G X]` and `[Nonempty G X]`-style instances and resolution
finds it. It proves **categorical** connectedness of the action groupoid; it
says nothing about topological connectedness of `X`.

The component carrier is:

```lean
ConnectedComponents C = Quotient (Zigzag.setoid C).
```

For `[IsPreconnected C]`, `isPreconnected_zigzag x y` supplies the relation
between any two representatives. Consequently the exact Lean proof that
`ConnectedComponents C` is a subsingleton is quotient induction followed by:

```lean
Quotient.sound (isPreconnected_zigzag x y)
```

Mathlib does not provide a project-named Remark-8.3.5 wrapper at the pinned
revision. Name the small generic receipt once, then instantiate it at the
already-recognized A-specific action groupoid. Obtain its inhabited element
from an existing object of that groupoid. Do not use C4 to build the object
and do not replace the named carrier by `PUnit` or the notation `1`.

## Grothendieck components and the named reader

The in-repo comparison is:

```lean
pi0GrothendieckEquiv (F : B ⥤ Grpd) :
  ConnectedComponents (Grothendieck (F ⋙ Grpd.forgetToCat))
    ≃ Limits.colimit ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor)
```

Instantiate it only after the exact residue diagram has been named. The
left side is the component carrier of the residue total; the right side is
the colimit of the residue component diagram. This equivalence does not
create categorical connectedness or the real-valued reader.

The project’s already-compatible real-level orbit invariant descends after
the component calculation. Keep visible:

```text
named singleton component carrier
named unique class
val_A : named carrier → ℝ
c is val_A at that class.
```

Remark 8.3.5 supplies singletonness. `pi0GrothendieckEquiv` supplies the
presentation comparison. The existing real-level face supplies `val_A`.
The natural inclusion and its `Grothendieck.map` supply the statement that
the category being calculated is the residue-value-state system inside the
ambient action.
