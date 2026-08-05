# Housekeeping audit — 2026-08-05

Every line below quotes a program's output or a file:line. Nothing here is a
judgement about the mathematics.

## 1. The certificate table names a declaration that does not exist

`BlueprintLeanCertificateTable.md:75` maps

| blueprint clause | declaration named | status printed |
|---|---|---|
| `lem:c-residue-transitive` | `ASection.northProducersConnected` (downstream) | `UNLOCATED_OPEN_SEAT` |

`grep -rn "northProducersConnected"` over the four declared files
(`Theorem.lean`, `ASectionFunctor.lean`, `ASectionCResidueDiagram.lean`,
`ASectionCResidueInverseImage.lean`) returns **empty**.

The live declaration for that clause is

    Concentricity/Theorem.lean:1023
    theorem ASection.sweepTransitive_on_residueSystem (A : ASection) :
        ∀ P Q : A.residueTotalCategory, Nonempty (P ⟶ Q)

and it is consumed at `Theorem.lean:1043` by
`ASection.residueTotal_isConnected`.

So `UNLOCATED` is a fact about the generator's name map, not about the seat.
The table and the verdict are both written by
`scripts/generate_blueprint_lean_table.py`; the entry is stale there, so
hand-editing the table would be overwritten. **The generator's map is the fix.**
That file is outside the seat's declared read surface, so the author makes this
change.

## 2. The NOT_CERTIFIED verdict is driven by a stale registry, not by source

`blueprint/lean_inference_verdict.txt` prints, in the same file:

    PROJECT_INFERENCE_VERDICT=NOT_CERTIFIED
    OPEN_INFERENCE_SEATS=0
    OPEN_PRODUCTION_BINDING_SEATS=0
    REGISTERED_INFERENCE_RECEIPTS=13     CERTIFIED_INFERENCE_RECEIPTS=11
    CURRENT_SOURCE_INFERENCE_RECEIPTS=20 CERTIFIED_CURRENT_SOURCE_INFERENCE_RECEIPTS=20

The two receipts holding the verdict down are

    RECEIPT=ASection.northRelativeLoop_maps_audit        STATUS=NOT_CERTIFIED
    RECEIPT=ASection.relativeActionSquare_transport_audit STATUS=NOT_CERTIFIED

and the same file, seven lines later, prints both as certified against the
live source:

    CURRENT_SOURCE_RECEIPT=ASection.northRelativeLoop_maps_audit        STATUS=INFERENCE_CERTIFIED
    CURRENT_SOURCE_RECEIPT=ASection.relativeActionSquare_transport_audit STATUS=INFERENCE_CERTIFIED

Registered = 13, current source = 20. The registry is behind the source by
seven receipts, and the two it calls failures are certified in the source.

## 3. The two receipts the registry calls failures are the two the seat needs

`Concentricity/Theorem.lean:1023–1035`, the only hole in that declaration:

```lean
  obtain ⟨xN, hxN, g, hg⟩ := P.fiber.property
  obtain ⟨yN, hyN, h, hh⟩ := Q.fiber.property
  obtain ⟨k, ⟨φ⟩⟩ :
      ∃ k : projectiveNorth ⟶ projectiveNorth,
        Nonempty ((AsectionActionTransport A k).obj xN ⟶ yN) := by
    sorry
  exact A.residueTotal_morphism_of_northComparison
    P Q xN yN g hg h hh k φ
```

The hole asks for exactly the master's `(R)` and `(Φ)`: the relative loop
`k = k_E ; k_W⁻¹ : N ⟶ N` and the fibre arrow `φ : F_A(k)(x_N) ⟶ y_N`.
The two receipts named in §2 are the relative-loop lemmas.

**The destructuring yields four components, not six.** `P.fiber.property`
gives `xN, hxN, g, hg`; `Q.fiber.property` gives `yN, hyN, h, hh`. The two
boundary faces `F_A(E_N)`, `F_A(W_N)` are not among them. Whatever builds `k`
has to come from somewhere other than these projections.

## 4. Open seats, both named, both with exact types

| # | declaration | file:line of the hole | what the kernel is waiting for |
|---|---|---|---|
| 1 | `ASection.sweepTransitive_on_residueSystem` | `Theorem.lean:1032` | `∃ k : N ⟶ N, Nonempty ((AsectionActionTransport A k).obj xN ⟶ yN)` |
| 2 | `ASection.transportLevel_of_pi0_singleton` | `Theorem.lean:1076` | `A.transportLevel n = A.transportLevel 0` from `hkn`, an equality of π₀ classes |

`grep -c sorry` over the other three declared files returns `0`, `0`, `0`.
The remaining `sorry` occurrences in `Theorem.lean` (`:11`, `:187`, `:1064`)
are inside docstrings and comments.

## 5. Root-level PDF was 24 hours stale

`./Octonionic_RH_master.pdf` was Aug 4 10:41 while
`output/pdf/Octonionic_RH_master.pdf` was current. `scripts/master.sh` now
builds and refreshes the root copy in one step.

## 6. The standing agent instruction contradicts the live source

This is the one that costs sessions.

`EndgameFinal.md:42–48`, under the heading *"Read first: the joining element is
UNPACKED, never searched"*, instructs every agent that destructuring

```lean
P.fiber.property
Q.fiber.property
```

> already puts the exact faces in the local context as
>
>     xN, yN, g, h, hg, hh.
>
> There is therefore nothing global to grep for at this seam.

`EndgameFinal.md:12` adds that the relative middle loop `k` is *"read from
their already-fixed A-specific action faces."*

The live source, `Concentricity/Theorem.lean:1027–1028`:

```lean
  obtain ⟨xN, hxN, g, hg⟩ := P.fiber.property
  obtain ⟨yN, hyN, h, hh⟩ := Q.fiber.property
```

**Four components each, and the fourth is not a face.** The two boundary faces
are not in the local context. `k` is not in the local context either — it is
the existential the `sorry` at `:1032` is asked to produce.

So the standing instruction states as settled fact that the joining element is
already local, and forbids the search that would find it is not
(*"nothing global to grep for at this seam"*). The same sentence is repeated in
the register-gate hook text. An agent following the instruction cannot reach
the missing datum, and cannot report it as missing either, because the
instruction pre-classifies any such report as its own lookup error.

The instruction was true of a structure that carried the faces as data. It is
false of the structure now in the file. **Correcting `EndgameFinal.md:36–52` is
a precondition for the next seat attempt**, not a cleanup nicety.

## 7. The entry point sends agents to files the register gate blocks

`CLAUDE.md` — "Read these, and nothing else" — names:

    EndgameFinal.md
    Octonionic_RH_master.tex
    RelevantGreenFinal.md
    DependencyTabulation.md
    SOURCES/*.md

The register gate for seat `seat1-transitivity` allows:

    Concentricity/Theorem.lean
    Concentricity/ASectionFunctor.lean
    Concentricity/ASectionCResidueDiagram.lean
    Concentricity/ASectionCResidueInverseImage.lean
    Octonionic_RH_master.tex
    blueprint/*
    Ledger.md
    BlueprintLeanCertificateTable.md

Only the master is in both. Four of the five files the entry point requires are
refused by the gate, and four of the eight the gate permits are not mentioned by
the entry point. Every session opens by being told to read what it will then be
refused. The two lists need to be one list.
