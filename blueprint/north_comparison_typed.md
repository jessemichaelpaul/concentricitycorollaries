# The north comparison, typed — 2026-08-06

The master's chain in `lem:c-residue-transitive` elaborates green from the
declarations that survived the deletion of the old argument's seven. Probed
with `lake env lean` against `Concentricity.Theorem` at `8a070b5`; no errors.

## What was typed

Two runs of the one construction out of the one source object, and the same
$D_A$ at north in both:

```lean
example (A : ASection) {X : GreatCircle.Base}
    (k₁ k₂ : X ⟶ ASection.projectiveNorth)
    (xN yN : A.AsectionActionFiber ASection.projectiveNorth)
    (uStar : OnePoint ℂ)
    (hB₁ : (A.orbitStabilizerActionSquare k₁).left.val
              ((A.projectiveObjectFrame X).val uStar)
            = (A.projectiveObjectFrame ASection.projectiveNorth).val
                xN.input.back.coordinate)
    (hB₂ : (A.orbitStabilizerActionSquare k₂).left.val
              ((A.projectiveObjectFrame X).val uStar)
            = (A.projectiveObjectFrame ASection.projectiveNorth).val
                yN.input.back.coordinate) :
    Nonempty ((A.AsectionActionTransport
      (CategoryTheory.Groupoid.inv k₁ ≫ k₂)).obj xN ⟶ yN)
```

The hypotheses are the master's (B), the C3 boundary readings, with (P)
already rewritten into the right-hand side: $a_A(k_i)\cdot(a_A(0)\cdot u_\ast)
= D_A\cdot u_i$. Nothing is existentially quantified.

## The steps, and the declaration each one is

| master | declaration | file |
|---|---|---|
| (S) | `orbitStabilizerActionSquare.commutes` = `projectiveArrowElement_frame_compat` | `ASectionFunctor.lean:196` |
| (S)+(B)+(P) ⟹ (I) | `ASection.inputEquation_of_boundaryReading` | `Theorem.lean:544` |
| (R) | `GreatCircle.stabilizerPart_comp`, `ASection.stabilizerPart_inv` | `ProjectiveSection.lean:159`, `Theorem.lean:475` |
| (Φ) direction half | `ASection.northFiberHom_of_coordinate` | `Theorem.lean:452` |

Two definitional facts carry the joins, so no glue is needed:
`(A.orbitStabilizerActionSquare k).right` **is**
`cayleyProjective (stabilizerPart k)`, and `AsectionActionTransport_obj_input`
is how the loop acts on the stored input.

## What is not yet typed

(B) itself, for two given north C-residue states — the two runs $k_1,k_2$ and
the source input $u_\ast$ they are read at. `residueState_graph`
(`Theorem.lean:585`) already supplies the right-hand side of (B) as master (P),
$D_A\cdot u_i=z_i$ with $z_i$ the authored C3 coordinate. What (B) adds is the
left-hand side: that the run carried $u_\ast$ there.

## Not to be done

Do not restate this as `∃ rE rW uStar`. That was the old argument and it is
what `blueprint/old_argument_audit.md` records. The runs are two sweeps of one
construction, not two faces, and the residual factors are `stabilizerPart` of
the runs — determined, never produced.
