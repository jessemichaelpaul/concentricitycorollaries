# Proof outline — the blueprint spine

**Generated directly from `Octonionic_RH_master.tex`. Do not edit by hand — regenerate.**
The master is the spine; this is its statement list in order, with the `\lean{}` tags that
make the blueprint click through to the live declarations.


### Introduction

## PART — Classical Background

### The Riemann zeta function
- **Theorem** `thm:riemann` — Meromorphic continuation and functional equation; Riemann Riemann1859
- **Theorem** `thm:euler` — Infinite Euler product; [Ch.~1
- **Theorem** `thm:hadamard` — Infinite Hadamard product; [Ch.~2
- **Corollary** `cor:hadamard-infinitude` — Infinitude of the nontrivial zeros
- **Theorem** `thm:hardy` — Hardy Hardy14
- **Definition** `def:zeta-Cstar` — Compactified classical zeta
- **Lemma** `lem:zero-Cstar` — Compactification does not move the zeros

## PART — Slice-Preserving Theory, the Ring  R, and the Equivalence

### Octonions and slices
- **Definition** `def:octonions`
- **Theorem** `thm:artin` — Artin Schafer66
- **Corollary** `cor:powers`
- **Definition** `def:slices` — Complex slices and slice Riemann spheres

### Slice-preserving functions
- **Definition** `def:slice-regular` — Slice regularity; [Def.~5.1.1
- **Theorem** `thm:rep-formula` — Representation Formula; [Thm.~5.1.7
- **Theorem** `thm:identity` — Identity Theorem; [Cor.~5.1.9
- **Theorem** `thm:extension` — Extension Theorem; [Thm.~5.1.5
- **Definition** `def:slice-preserving` — Slice-preserving functions; [Def.~2.7, Rem.~2.8

### The octonionic zeta function
- **Definition** `def:zeta_O` — Octonionic zeta
- **Proposition** `prop:well-defined` — Well-definedness

### R
- **Definition** `def:R` — The ring of slice-preserving functions under the regular product
- **Theorem** `thm:wang` — Regular product on slice-preserving functions; [Rem.~2.11
- **Proposition** `prop:R-comm-ring`
- **Proposition** `prop:R-domain` — R is an integral domain

### The slice-preserving analytic toolkit on the compactified octonions
- **Theorem** `thm:slice-exp` — The slice exponential; [3
- **Theorem** `thm:log-manifold` — The logarithm manifold E^+_; [Prop.~5.1, Rem.~5.2, Def.~5.3, Prop.~5.4, Def.~5.5
- **Lemma** `lem:exp-degenerate` — The degenerate set of the exponential; its fibre over a real value
- **Definition** `def:slice-squares` — Slice restriction and the I-independent lift; [Rem.~2.11
- **Theorem** `thm:winding-lift` — The winding lift; [Def.~3.4, Def.~4.1, Prop.~4.2, Def.~5.11
- **Proposition** `prop:winding-signature` — Tameness, existence, and the winding number; [Def.~4.20, Cor.~5.21, Cor.~5.22

### Slice preservation and symmetries
- **Theorem** `thm:slice-pres` — Slice preservation
- **Theorem** `thm:zeta-in-R` — is a section of  R
- **Definition** `def:G2` — The automorphism group
- **Theorem** `thm:G2-equiv` — -equivariance
- **Theorem** `thm:G2-S6` — Baez02

### Zero geometry and the equivalence
- **Theorem** `thm:zero-equivalence` — Zero Equivalence Theorem
- **Theorem** `thm:zero-spheres` — Nontrivial zeros are infinitely many disjoint 6-spheres
- **Theorem** `thm:rh-equiv` — The equivalence: concentricity  RH

## PART — The Categorical Construction and the Concentricity Theorem

### The geometric worlds and the categorical construction
- **Definition** `def:carrier` — The compactified octonions ^*=S^8
- **Definition** `def:section-map` — The section's slice data and equivariance
- **Definition** `def:two-worlds` — The octonionic and slice-value worlds  
  ↳ Lean: `H1, S2`
- **Definition** `def:base` — The projective base, genuine section functor, and total category  
  ↳ Lean: `GreatCircle.Base, CategoryTheory.Grothendieck`

### The concentricity theorem
- **Proposition** `prop:weierstrass` — Slice-regular Weierstrass factorization; the content of C3
- **Lemma** `lem:residue-spheres` — Residue- zeros are 6-sphere components of  H_1
- **Lemma** `lem:pi0-grothendieck` — _0 of a Grothendieck construction  
  ↳ Lean: `CategoryTheory.Grothendieck`
- **Definition** `def:A-section` — A-sections
- **Definition** `def:residue-subdiagram` — The residue subdiagram and its inclusion  
  ↳ Lean: `ASection.CResidueZeroLocus, ASection.AsectionCResidueDiagram, ASection.AsectionCResidueInclusion`
- **Theorem** `thm:concentricity` — Concentricity
- **Corollary** `cor:nontrivial` — Translation to the classical framework

### Corollaries
- **Corollary** `cor:zeta-section` — is an A-section
- **Corollary** `cor:rh` — Riemann Hypothesis
