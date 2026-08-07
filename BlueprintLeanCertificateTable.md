# Blueprint–Lean certificate table

Generated mechanically from the current master, current Lean sources, and the pinned toolchain.
The manifest is the single human-ratified mapping from a master clause to a Lean declaration; the generator verifies the exact master anchor, exact Lean type, fresh kernel run, axiom surface, and source fingerprints.
Regenerate with `scripts/generate_blueprint_lean_table.py`. The generator reads and probes `Concentricity/Theorem.lean`; it does not edit either production seat.

Current count: 9 terminal certificates; 6 inference certificates; 0 unpacked dossier bindings ready; 1 author bindings confirmed; 0 confirmed bindings awaiting Lean spelling; 0 production seats open.

Certificate meanings:

- `TERMINAL_CERTIFIED`: master `\lean{...}` link + fresh provider build/type check + exact allowed axiom surface.
- `INFERENCE_CERTIFIED`: exact master-clause anchor + focused current-source kernel proof + exact allowed axiom surface; production wiring may still be open.
- `OPEN_SEAT`: Lean reached the precise declaration/instantiation/wiring boundary printed below.

Allowed axiom surface: `['propext', 'Classical.choice', 'Quot.sound']`.

## Already terminal-certified

| Master semantics | Lean declaration | Master | Kernel/type | Axioms | Status |
|---|---|---:|---:|---:|---|
| G₂ supplies the remaining sphere-direction action | `G2.exists_smul_eq_of_mem_unitImaginarySphere` | ✓ | ✓ | ✓ | `TERMINAL_CERTIFIED` |
| octonionic action world | `H1` | ✓ | ✓ | ✓ | `TERMINAL_CERTIFIED` |
| slice-value world | `SphereWorld` | ✓ | ✓ | ✓ | `TERMINAL_CERTIFIED` |
| projective action-groupoid base | `GreatCircle.Base` | ✓ | ✓ | ✓ | `TERMINAL_CERTIFIED` |
| chosen orbit representative has the required endpoint | `GreatCircle.orbitRep_spec` | ✓ | ✓ | ✓ | `TERMINAL_CERTIFIED` |
| total Grothendieck construction | `CategoryTheory.Grothendieck` | ✓ | ✓ | ✓ | `TERMINAL_CERTIFIED` |
| C-residue zero locus | `ASection.CResidueZeroLocus` | ✓ | ✓ | ✓ | `TERMINAL_CERTIFIED` |
| C-residue inverse-image diagram | `ASection.AsectionCResidueDiagram` | ✓ | ✓ | ✓ | `TERMINAL_CERTIFIED` |
| inclusion of the inverse-image diagram in the total action diagram | `ASection.AsectionCResidueInclusion` | ✓ | ✓ | ✓ | `TERMINAL_CERTIFIED` |

## Triple-certified at the level of inference

| Master clause | Focused Lean receipt | Edge | Master/identity | Kernel/type | Axioms | Status |
|---|---|---|---:|---:|---:|---|
| a north C-residue state is the exact C3 residue action state | `ASection.northState_is_residueActionState_audit` (Concentricity/_GateNorthCResidueTransitivityAudit.lean:61) | `inference` | ✗ | ✓ | ✓ | `NOT_CERTIFIED` |
| the north input is D_A⁻¹(sphereZero n) | `ASection.residueActionState_north_input_audit` (Concentricity/_GateNorthCResidueTransitivityAudit.lean:18) | `inference` | ✗ | ✓ | ✓ | `NOT_CERTIFIED` |
| a north loop acts by C(stabilizerPart k) on the stored input | `ASection.residueActionTransport_north_input_audit` (Concentricity/_GateNorthCResidueTransitivityAudit.lean:26) | `inference` | ✗ | ✓ | ✓ | `NOT_CERTIFIED` |
| the common source factor cancels in k_E⁻¹ ≫ k_W | `ASection.northRelativeLoop_stabilizer_audit` (Concentricity/_GateNorthCResidueTransitivityAudit.lean:137) | `inference` | ✓ | ✓ | ✓ | `INFERENCE_CERTIFIED` |
| the relative loop carries the first certified input to the second | `ASection.northRelativeLoop_maps_audit` (Concentricity/_GateNorthCResidueTransitivityAudit.lean:165) | `inference` | ✗ | ✓ | ✓ | `NOT_CERTIFIED` |
| the two parallel faces and G₂ package the north-fibre morphism | `ASection.northComparison_of_parallelFaces_audit` (Concentricity/_GateNorthCResidueTransitivityAudit.lean:201) | `inference` | ✗ | ✓ | ✓ | `NOT_CERTIFIED` |
| the same relative calculation holds in the two-legged square functor register | `ASection.relativeActionSquare_transport_audit` (Concentricity/_GateNorthCResidueTransitivityAudit.lean:286) | `inference` | ✗ | ✓ | ✓ | `NOT_CERTIFIED` |
| g⁻¹ ≫ k ≫ h and fullness produce P ⟶ Q inside ∫R_A | `ASection.residueTotal_morphism_of_northComparison_audit` (Concentricity/_GateNorthCResidueTransitivityAudit.lean:293) | `inference` | ✗ | ✓ | ✓ | `NOT_CERTIFIED` |
| transitivity of the exact ∫R_A implies IsConnected for that exact ∫R_A | `ASection.residueTotal_isConnected_of_transitive_audit` (Concentricity/_GateNorthCResidueTransitivityAudit.lean:359) | `inference` | ✓ | ✓ | ✓ | `INFERENCE_CERTIFIED` |
| connectedness of the exact ∫R_A makes π₀ of that exact ∫R_A a singleton | `ASection.residueTotal_pi0_singleton_of_connected_audit` (Concentricity/_GateNorthCResidueTransitivityAudit.lean:374) | `inference` | ✓ | ✓ | ✓ | `INFERENCE_CERTIFIED` |
| the general one-centre corollary is exactly the concentricity conclusion | `ASection.nontrivial_one_centre_of_concentricity_audit` (Concentricity/_GateCorollaryInferenceAudit.lean:13) | `identity` | ✓ | ✓ | ✓ | `INFERENCE_CERTIFIED` |
| the zeta specialization and proved concentricity equivalence imply RH | `zeta_riemannHypothesis_of_concentricity_audit` (Concentricity/_GateCorollaryInferenceAudit.lean:19) | `inference` | ✓ | ✓ | ✓ | `INFERENCE_CERTIFIED` |
| RH and the proved infinitude imply infinitely many critical-line zeros | `zeta_criticalLine_zeros_infinite_of_RH_audit` (Concentricity/_GateCorollaryInferenceAudit.lean:31) | `inference` | ✓ | ✓ | ✓ | `INFERENCE_CERTIFIED` |

## Binding identity layer

The first table records the project-specific objects already unpacked from the two arbitrary objects. The second table separates the author's confirmed mathematical binding from the typist's Lean spelling. Author confirmation hashes the master label, paper object, local role, and expected type; Lean then checks the recovered candidate expression independently at that exact type.

| Exact project-specific locals | Provenance | Source exact | Kernel reached consumer | Status |
|---|---|---:|---:|---|
| `xN, hxN, g, hg` | the inverse-image dossier carried by the arbitrary object P; `obtain ⟨xN, hxN, g, hg⟩ := P.fiber.property` | ✗ | ✗ | `BINDING_UNRESOLVED` |
| `yN, hyN, h, hh` | the inverse-image dossier carried by the arbitrary object Q; `obtain ⟨yN, hyN, h, hh⟩ := Q.fiber.property` | ✗ | ✗ | `BINDING_UNRESOLVED` |

| Paper object | Lean local | Expected type | Author binding | Master link and target | Candidate expression | Lean elaboration | Status |
|---|---|---|---|---:|---|---:|---|
| the post-collapse residue read instantiated at the n-th and 0-th certified representatives | `hkn` | `A.transportLevel n = A.transportLevel 0` | ✓ confirmed | ✓ | `hkn` | — | `LEAN_BINDING_REJECTED` |

### Exact seat attempts

Lean was contacted with the exact candidate expression for: `seat2.transportLevelCollapse`. Each remaining row stays mandatory transcription work.

## Current production boundary

| Master result | Exact remaining role | Production declaration | Lean contact | Status |
|---|---|---|---:|---|
| `lem:c-residue-transitive` | the action-groupoid composition in ∫R_A, instantiated at the two semantic inverse-image objects ι_A(x₀) and ι_A(y₀) | `ASection.sweepTransitive_on_residueSystem` (Concentricity/Theorem.lean:940) | — | `UNLOCATED_OPEN_SEAT` |
| `thm:concentricity` | the val step: the π₀-class equality instantiated at the n-th and 0-th certified representatives, carried across to the real-valued level equality | `ASection.transportLevel_of_pi0_singleton` (downstream) | — | `UNLOCATED_OPEN_SEAT` |

The current production run reaches exactly two errors: the north existential in `sweepTransitive_on_residueSystem` and the real-valued equality in `concentricity`. The inference table above is independently green against the exact current source prefix; the open seats do not downgrade those receipts.

## Exact checked types

### `G2.exists_smul_eq_of_mem_unitImaginarySphere`

```lean
G2.exists_smul_eq_of_mem_unitImaginarySphere : ∀ {u v : Octonion},
  u ∈ Octonion.unitImaginarySphere → v ∈ Octonion.unitImaginarySphere → ∃ g, g • u = v
```

### `H1`

```lean
H1 : Type
```

### `SphereWorld`

```lean
SphereWorld : Type
```

### `GreatCircle.Base`

```lean
GreatCircle.Base : Type
```

### `GreatCircle.orbitRep_spec`

```lean
GreatCircle.orbitRep_spec : ∀ (b : GreatCircle.Point), GreatCircle.orbitRep b • OnePoint.infty = b
```

### `CategoryTheory.Grothendieck`

```lean
CategoryTheory.Grothendieck : {C : Type u_1} →
  [inst : CategoryTheory.Category.{u_2, u_1} C] → CategoryTheory.Functor C CategoryTheory.Cat → Type (max u_1 u_3)
```

### `ASection.CResidueZeroLocus`

```lean
ASection.CResidueZeroLocus : ASection → Set ℂ
```

### `ASection.AsectionCResidueDiagram`

```lean
ASection.AsectionCResidueDiagram : ASection → CategoryTheory.Functor GreatCircle.Base CategoryTheory.Grpd
```

### `ASection.AsectionCResidueInclusion`

```lean
ASection.AsectionCResidueInclusion : (A : ASection) → A.AsectionCResidueDiagram ⟶ A.AsectionActionDiagram
```

### `ASection.northState_is_residueActionState_audit`

```lean
ASection.northState_is_residueActionState_audit : ∀ (A : ASection) (zN : ↑(A.AsectionActionFiber projectiveNorth)),
  A.IsNorthCResidueState zN → ∃ n I, zN = A.residueActionState projectiveNorth n I
```

### `ASection.residueActionState_north_input_audit`

```lean
ASection.residueActionState_north_input_audit : ∀ (A : ASection) (n : ℕ) (I : SphereWorld),
  (ActionCategory.back (A.residueActionState projectiveNorth n I).input).coordinate =
    ↑A.distinguishedDiskAction⁻¹ ↑(A.sphereZero n)
```

### `ASection.residueActionTransport_north_input_audit`

```lean
ASection.residueActionTransport_north_input_audit : ∀ (A : ASection) (n : ℕ) (I : SphereWorld)
  (k : projectiveNorth ⟶ projectiveNorth),
  (ActionCategory.back
        ((A.AsectionActionTransport k).obj (A.residueActionState projectiveNorth n I)).input).coordinate =
    ↑(GreatCircle.cayleyProjective ↑(GreatCircle.stabilizerPart k)) (↑A.distinguishedDiskAction⁻¹ ↑(A.sphereZero n))
```

### `ASection.northRelativeLoop_stabilizer_audit`

```lean
ASection.northRelativeLoop_stabilizer_audit : ∀ {X : GreatCircle.Base} (kE kW : X ⟶ projectiveNorth),
  GreatCircle.stabilizerPart (Groupoid.inv kE ≫ kW) = GreatCircle.stabilizerPart kW * (GreatCircle.stabilizerPart kE)⁻¹
```

### `ASection.northRelativeLoop_maps_audit`

```lean
ASection.northRelativeLoop_maps_audit : ∀ {X : GreatCircle.Base} (kE kW : X ⟶ projectiveNorth) (uStar u₁ u₂ : OnePoint ℂ),
  ↑(GreatCircle.cayleyProjective ↑(GreatCircle.stabilizerPart kE)) uStar = u₁ →
    ↑(GreatCircle.cayleyProjective ↑(GreatCircle.stabilizerPart kW)) uStar = u₂ →
      ↑(GreatCircle.cayleyProjective ↑(GreatCircle.stabilizerPart (Groupoid.inv kE ≫ kW))) u₁ = u₂
```

### `ASection.northComparison_of_parallelFaces_audit`

```lean
ASection.northComparison_of_parallelFaces_audit : ∀ (A : ASection) {X : GreatCircle.Base} (kE kW : X ⟶ projectiveNorth)
  (xN yN : ↑(A.AsectionActionFiber projectiveNorth)) (uStar : OnePoint ℂ),
  ↑(GreatCircle.cayleyProjective ↑(GreatCircle.stabilizerPart kE)) uStar = (ActionCategory.back xN.input).coordinate →
    ↑(GreatCircle.cayleyProjective ↑(GreatCircle.stabilizerPart kW)) uStar = (ActionCategory.back yN.input).coordinate →
      Nonempty ((A.AsectionActionTransport (Groupoid.inv kE ≫ kW)).obj xN ⟶ yN)
```

### `ASection.relativeActionSquare_transport_audit`

```lean
ASection.relativeActionSquare_transport_audit : ∀ (A : ASection) {source target : ↥Moebius}
  (E W : ActionTransportSquare source target),
  (E.inv.comp W).actionStateTransport A = E.inv.actionStateTransport A ⋙ W.actionStateTransport A
```

### `ASection.residueTotal_morphism_of_northComparison_audit`

```lean
ASection.residueTotal_morphism_of_northComparison_audit : ∀ (A : ASection)
  (P Q : Grothendieck (A.AsectionCResidueDiagram ⋙ Grpd.forgetToCat)) (xN yN : ↑(A.AsectionActionFiber projectiveNorth))
  (g : projectiveNorth ⟶ P.base),
  (A.AsectionActionTransport g).obj xN = P.fiber.obj →
    ∀ (h : projectiveNorth ⟶ Q.base),
      (A.AsectionActionTransport h).obj yN = Q.fiber.obj →
        ∀ (k : projectiveNorth ⟶ projectiveNorth) (φ : (A.AsectionActionTransport k).obj xN ⟶ yN), Nonempty (P ⟶ Q)
```

### `ASection.residueTotal_isConnected_of_transitive_audit`

```lean
ASection.residueTotal_isConnected_of_transitive_audit : ∀ (A : ASection),
  (∀ (P Q : Grothendieck (A.AsectionCResidueDiagram ⋙ Grpd.forgetToCat)), Nonempty (P ⟶ Q)) →
    CategoryTheory.IsConnected (Grothendieck (A.AsectionCResidueDiagram ⋙ Grpd.forgetToCat))
```

### `ASection.residueTotal_pi0_singleton_of_connected_audit`

```lean
ASection.residueTotal_pi0_singleton_of_connected_audit : ∀ (A : ASection)
  [CategoryTheory.IsConnected (Grothendieck (A.AsectionCResidueDiagram ⋙ Grpd.forgetToCat))]
  (P Q : Grothendieck (A.AsectionCResidueDiagram ⋙ Grpd.forgetToCat)),
  CategoryTheory.ConnectedComponents.mk P = CategoryTheory.ConnectedComponents.mk Q
```

### `ASection.nontrivial_one_centre_of_concentricity_audit`

```lean
ASection.nontrivial_one_centre_of_concentricity_audit : ∀ (A : ASection),
  (∃ c, ∀ (n : ℕ), (A.sphereZero n).re = c) → ∃ c, ∀ (n : ℕ), (A.sphereZero n).re = c
```

### `zeta_riemannHypothesis_of_concentricity_audit`

```lean
zeta_riemannHypothesis_of_concentricity_audit : (∃ c, ∀ (n : ℕ), (zetaSection.sphereZero n).re = c) → RiemannHypothesis
```

### `zeta_criticalLine_zeros_infinite_of_RH_audit`

```lean
zeta_criticalLine_zeros_infinite_of_RH_audit : RiemannHypothesis → {s | riemannZeta s = 0 ∧ s.re = 1 / 2}.Infinite
```

## Source fingerprints

| Source | SHA-256 |
|---|---|
| `Octonionic_RH_master.tex` | `d906ea1494831c4096add3725cdaeedf5cf079ab62bb547e96d19049d3376062` |
| `blueprint/lean_certificate_manifest.json` | `dc20b06e89ec6e41f71ee93be56d0f9c159571a849f447c9e8db6806741717d5` |
| `Concentricity/_BlueprintTerminalCertificateProbe.lean` | `2e898992124efa19b135e96f87d14813b03809f27f9cc7a69f85fb8d5f257d37` |
| `Concentricity/Theorem.lean` | `2c11a6501285c9ab7cb5dcd4af89eca72b36e95cd047e7a9e1e254e397821d14` |
| `Concentricity/_GateNorthCResidueTransitivityAudit.lean` | `07ddbe960df820ab93c25f87f4b963077f058fd3c79b739430a3c5ff6533d99a` |
| `scripts/build_transitivity_inference_probe.sh` | `e0982829e4937b00e01bda1b7b4a4e767c09f3a907ae65393a4590125a686683` |
| `Concentricity/_GateCorollaryInferenceAudit.lean` | `8bac693ca5c93deae6b9f1511e3f058efab47a8b657c061fc178176fe5636efb` |
| `Concentricity/Corollaries.lean` | `4866f494cf62579778905d6dd93b912a868a880b827c4456a060bdb08d441248` |
| `lean-toolchain` | `efac0b94923b2d8b6840cd35be9177ad0fc5ab2332f4f4311c98712cee92fdee` |
| `lakefile.toml` | `361be5c558f10fbc113a616222d2db2c08c9b353ddb12f0cac6d5ad9a0d0287d` |
| `lean_source_tree` | `432b81b904b71ec3caad45ab263cda1015811c605806d08963c883faf11f8af9` |

Raw kernel output: `blueprint/lean_certificate_probe.txt`.
Machine-readable evidence: `blueprint/lean_certificate_evidence.json`.
Composition-free verdict: `blueprint/lean_inference_verdict.txt`.
Semantic manifest: `blueprint/lean_certificate_manifest.json`.
