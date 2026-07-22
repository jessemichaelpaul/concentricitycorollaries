# FINAL PLAN — the authored A-section construction to 0/0

**Author and mathematical authority: Jesse Michael Paul.** Locked 2026-07-21.
This file records the global mathematical chain. The accepted execution order
and live construction status are now governed by
`PLAN_TWELVE_ON_THE_DISK_ACTION_2026-07-22.md` and `HANDOFF.md`, which supersede
Sections 6–7 of the earlier version. Live Lean declarations still determine
what has actually been implemented; prose never upgrades an unbuilt object to
green.

## 1. The one constructible chain

The proof starts from the A-section hypotheses, not from a generic categorical
carrier:

\[
\mathrm{C1\!-\!C4/GPV/W}
\longrightarrow
\text{one distinguished Euler--Weierstrass disk action}
\longrightarrow
\text{orbit--stabilizer on }(\texttt{GreatCircle.Base},\texttt{SphereWorld})
\longrightarrow
(F_A.\mathrm{obj},F_A.\mathrm{map})
\longrightarrow
\mathcal T_A
\longrightarrow
\pi_0(\mathcal T_A)\cong
\operatorname*{colim}_{\texttt{GreatCircle.Base}}(\pi_0\circ F_A)
\longrightarrow
\texttt{val}
\longrightarrow
\exists c\in\mathbb R\;\forall n,\
  \operatorname{Re}(A.\texttt{sphereZero}(n))=c.
\]

This chain is strictly forward.  `ASection` denotes precisely the
slice-preserving analytic/meromorphic elements satisfying C1--C4 that occur in
the theorem.  The W/GPV facts are intrinsic consequences of that input.  The
zero spheres and their normalized/total realizations are outputs of the
orbit--stabilized action; no downstream zero object may be moved into the base
action or used to define `F_A.obj` or `F_A.map`.

Every arrow in that display is instantiated on Jesse's A-section construction.
The generic statement of Riehl 8.3.4 is never treated as a source of a new
functor, carrier, base, or total object.

## 2. The distinguished action comes first

- **C2** gives the nowhere-zero Euler multiplier
  \(\mu_A(z)=\exp(\sum_p\ell_p(z))\) on its GPV base.
- **C1** continues that same action through the unique pole \(N\).
- **C3** gives the Weierstrass presentation of the same action at and through
  \(N\); its divisor produces the residue-\(\mathbb C\) zero-spheres.
- **C4** says that output population is infinite.
- **GPV/W/D** give the lift, winding, real-level, world-independence, and band
  properties of this one action.

The native-action acceptance means **all** of the proved W1--W4 stack, not a
representative GPV lemma. The current execution handles the twelve required
rows one vertical pass at a time, with immediate orbit–stabilizer extension:

- **W1:** Euler-factor confinement, zero winding on the C2 half-space,
  the canonical prime-sum lift, and right-wall argument control;
- **W2:** the zero-free left wall, homotopy/rectangle winding, and the full
  divisor-counting weld;
- **W3:** tame sphere loops, companion and obstruction data, the band
  reading, degenerate-fibre concentricity, and the touch;
- **W4:** the joined two-side count and the unique closed lift through the C1
  cone onto the one band;
- **GPV:** existence, basepoint uniqueness, tameness, continuous and
  lift-independent real level, winding, crossing, and degenerate-passage
  consequences.

Only proved supplier rows are used.  Historical receipt declarations carrying
`sorry` are not part of the construction.  C3-at-`N` remains upstream: it is
the through-`N` Weierstrass presentation of the same exponential
distinguished action supplied by C2, not a later zero-object attachment.

The fractional/band part is the \(U(1)\) motion. Do not discard the full
nonzero Euler multiplier varying with `A.F z`: its phase records band/winding
and its modulus records the real level. `distinguishedPoleUnit A : ℂˣ` is the
pole coordinate of that action, not a replacement for its function-valued
dependence. `Circle` and `ℂˣ` have the same diagonal matrix shape only after
inclusion; they are not interchangeable types.

## 3. Orbit--stabilizer builds the A-section functor

The only geometric groupoids are:

1. `GreatCircle.Base`, the projective groupoid where the disk action lives;
2. `SphereWorld`, the continuum of Riemann-sphere worlds and their genuine
   direction/Möbius transports.

The already-green general distinguished-element laws and the already-green
orbit--stabilizer factorization are specialized to the element defined by A.
That one specialization makes **both** object transport and morphism transport
well-defined, including \(N\mapsto N\).  It is not a map-only repair, and no
carrier, wrapper, comparison functor, or replacement base is inserted.

The twelve certified analytic facts remain in their native quantifiers.  They
are the natural partitions of the distinguished action being transported
wholesale; they are not twelve new theorems quantified over arbitrary `f` and
`φ`.  Do not recreate `ProjectiveSpecification.lean` in any form.

## 4. The total and the outputs

Only after the preceding functor is complete is `𝒯_A` formed from it.  Its
objects and morphisms are the value-bearing states and transports generated by
that construction.  The C3 zero-spheres, quantified over all worlds, enter as
outputs.  C4 supplies their infinitude.  Nothing is populated by hand and no
per-index connector is chosen.

## 5. Instantiate 8.3.4 on this functor only

Instantiate the π₀--Grothendieck/colimit identity on the completed A-section
functor:

\[
\pi_0(\mathcal T_A)
\cong
\operatorname*{colim}_{\texttt{GreatCircle.Base}}(\pi_0\circ F_A).
\]

The colimit consumes the entire continuum of genuine A-transports at once.
It produces the single populated class `κ`; no individual-map hunt or
pairwise real-part equality occurs.

The intrinsic real label already carried by those transports descends as
`val := colimit.desc (labelCocone)`.  Set `c := val κ` and conclude, in the
type of the Concentricity theorem itself,

```lean
∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c
```

## 6. Live execution state

Green and preserved are the analytic suppliers, the general distinguished
Möbius action and group laws, and the complete orbit–stabilizer vehicle:
`orbitRep`, `orbitRep_spec`, `orbitRep_infty`, `stabilizerPart`,
`orbit_stabilizer_factor`, and their identity/composition laws.

The A-section functor and its total are not accepted yet. The current frame
still carries one pole-value element rather than the complete function-valued
action. The twelve must be completed as native disk-action properties and
immediately transported row-by-row before the functor and total gates close.

## 7. Accepted execution order

Execute `PLAN_TWELVE_ON_THE_DISK_ACTION_2026-07-22.md` exactly:

```text
4 -> 5 -> 6 -> 1 -> 2 -> 3 -> 7 -> 8 -> 9 -> 10 -> 12
-> sectionFunctor acceptance -> exact 𝒯_A -> 11
-> 8.3.4 -> π₀ -> labelCocone -> val -> ∃ c
```

Each analytic pass includes its immediate wholesale orbit–stabilizer
extension and verification. No fact waits for a later batch transfer. No
downstream naturality, cocone, component diagram, or readout consideration
may determine an upstream declaration.

Never construct a naturality cone. Once the functor and total are correct,
8.3.4 and π₀ detect that their genuine transports pull to the one common
witness `N`.

Terminal 0/0 means: full build green, no executable `sorry`, no `sorryAx`, the
agreed axiom set only, and the literal `∃ c` conclusion in the theorem's type.
