# PLAN — the twelve on the disk automorphism, extended row-by-row by orbit–stabilizer

**Author's plan. One complete vertical slice per pass. No step is a judgment call.**

This plan replaces the former first half of the twelve-fact plan. It adds no
new criterion. The construction moves only forward from C1–C4 and their
intrinsic W1–W4/GPV consequences:

```text
C1–C4 / W1–W4 / GPV
  -> the complete function-valued Euler–Weierstrass–GPV disk action
  -> for each load-bearing fact, in its own pass:
       prove it natively on that disk action
       -> immediately extend that same fact wholesale by orbit–stabilizer
       -> verify it simultaneously at every object and along every arrow
       -> stop
  -> the completed sectionFunctor A : GreatCircle.Base ⥤ SphereWorld
  -> the exact 𝒯_A formed from that functor
  -> the C3/C4 output population
  -> 8.3.4 / π₀
  -> labelCocone
  -> val := colimit.desc labelCocone
  -> ∃ c : ℝ, ∀ n, (A.sphereZero n).re = c
```

Nothing downstream determines an upstream definition. No analytic fact is
allowed to wait for a later batch transfer.

---

## The vertical-slice rule

Every analytic row is completed by the same four-step pass:

1. **Disk-action step.** Prove the fact directly as a native property or
   coordinate of the complete A-generated disk action. Preserve the fact's
   native quantifiers. The action's `ℂˣ` multiplier carries both coordinates:
   its modulus is the real level, and its phase is the winding/band.
2. **Immediate orbit–stabilizer step.** In the same pass, carry that property
   through the already-green
   `orbitRep` / `stabilizerPart` / `orbit_stabilizer_factor`
   construction. The transfer is wholesale across the continuum of
   `GreatCircle.Base` objects and arrows and across `SphereWorld`; it is
   never a selected arrow or independently supplied transport.
3. **Acceptance step.** Print the exact disk-action declaration and the exact
   orbit-stabilized declaration. Verify that the latter is a property of the
   same object-and-arrow action used by `sectionFunctor A`, not a wrapper,
   theorem field, unused hypothesis, or citation beside it. Run only the
   row-specific check Jesse authorizes.
4. **Stop.** Report the two declarations and their check output. Do not begin
   the next row until Jesse accepts the current vertical slice.

Thus the work is:

```text
Fact 1 on disk -> orbit–stabilizer transfer -> global verification -> stop
Fact 2 on disk -> orbit–stabilizer transfer -> global verification -> stop
Fact 3 on disk -> orbit–stabilizer transfer -> global verification -> stop
...
```

There is no later “Phase 2” that transfers all twelve in a batch.

---

## Standing rules for every pass

1. **The twelve keep their native quantifiers.** They are not atomized into
   separately chosen data for arbitrary `f`, `φ`, or `n`. A wholesale
   theorem may quantify over the entire base action; it never selects a local
   connector or accepts a GPV transport independently beside an arrow.
2. **Nothing is installed in a carrier.** No analytic datum becomes a field of
   `TotalHom`, `TotalA`, a wrapper record, or a replacement fibre.
3. **No specification layer.** Do not recreate
   `ProjectiveSpecification.lean`, twelve conjuncts, a theorem-field bundle,
   or a generic “action with properties” object.
4. **Nothing looks ahead.** No row is justified by `𝒯_A`, 8.3.4, π₀,
   `labelCocone`, `val`, a deletion test, or an invented naturality cone.
5. **The full multiplier remains `ℂˣ`.** Never replace it with `Circle`.
   Phase carries winding/band; modulus carries real level.
6. **The orbit–stabilizer vehicle is not redesigned.** Both orbit-representative
   legs, `stabilizerPart`, the identity/composition laws, and
   `distinguishedWorldAction` remain the mechanism. Each pass changes or
   proves what that mechanism carries, not how the mechanism works.
7. **One row per pass.** A narrow objection receives a narrow correction.
   Never revert a file, commit, or accepted pass.
8. **Fixed report format.** Give the new disk-action declaration verbatim, the
   new orbit-stabilized declaration verbatim, and the authorized check output.
   No summary prose, self-assessment, or new failure ledger.
9. **A green build is not architectural acceptance.** Compilation checks the
   term supplied. Acceptance also requires that the term is this exact vertical
   slice of Jesse's construction.
10. **One serial build only when directed.** Never run parallel builds.

---

## The twelve vertical passes

The live analytic suppliers are preserved. Each pass identifies its fact with
the complete disk action and immediately completes its orbit–stabilizer
extension before the next pass begins.

The locked execution order is:

```text
4 -> 5 -> 6 -> 1 -> 2 -> 3 -> 7 -> 8 -> 9 -> 10 -> 12
-> functor acceptance -> exact 𝒯_A -> 11
```

Passes 4–6 come first because the C1/C3 continuation and its pole/zero
winding structure make the one action well-defined through the shared `N`.
The GPV rows are then read from that established action. The core C2 supplier
is already live as `eulerDiskAction A z`, with `eulerDiskAction_eq_value`
identifying its multiplier with `A.F z` on the Euler half-space; Pass 1 checks
and transfers the remaining C2 level coordinate rather than rebuilding that
supplier.

### Pass 4 — C1 two-sided cone junction

- Supplier: `cone_junction_levels_shared`.
- Disk target: both cone-junction levels are moduli of the same C1-continued
  action.
- Immediate transfer target: both sides remain one globally well-defined
  action through every object frame and arrow transition.

### Pass 5 — C1 pole winding

- Supplier: `stemWinding_circle_pole`.
- Disk target: pole winding is the phase coordinate of the continued action at
  the shared north pole.
- Immediate transfer target: the same phase coordinate is carried across the
  entire orbit–stabilized action.

### Pass 6 — C3 zero winding with multiplicity

- Supplier: `stemWinding_circle_sphereZero`.
- Disk target: winding and multiplicity at every C3 zero are phase coordinates
  of the same action.
- Immediate transfer target: those zero coordinates are well-defined at every
  corresponding footpoint and in every sphere world simultaneously.

### Pass 1 — C2 Euler/GPV level

- Supplier: `euler_branch_level`.
- Existing success: `eulerDiskAction A z` and `eulerDiskAction_eq_value`
  already expose C2's complete function-valued disk action on its half-space.
- Disk target: the prime-sum lift and `Real.log ‖A.F z‖` are the real/modulus
  coordinate of that action.
- Immediate transfer target: that same real level is well-defined everywhere
  the orbit-stabilized A-action has an object or arrow.

### Pass 2 — generated GPV disk action

- Supplier: `projective_gpv_disk_action`.
- Existing success: it already identifies the GPV logarithmic lift with
  `diskExpAction` and the multiplier `A.F`.
- Immediate transfer target: carry that A-generated action wholesale through
  every object frame and arrow transition. No independently supplied
  `GpvTransport` is accepted beside a functor arrow.

### Pass 3 — GPV endpoint real-level conservation

- Suppliers: `GpvTransport.diskExpAction_eq_value`,
  `diskExpAction_endpoint_eq`, `lift_endpoint_re_eq`, `value_at_source`,
  `value_at_target`, `endpoint_log_norm_eq`, and `endpoint_norm_eq`.
- Disk target: the value tape, lift, endpoint action, and conserved real level
  are coordinates of one disk action.
- Immediate transfer target: every orbit-stabilized A-transport carries that
  same endpoint real-level conservation simultaneously.

### Pass 7 — complex exponential-fibre level

- Supplier: `exp_fibre_level`.
- Disk target: the complex exponential-fibre level is the modulus coordinate
  of the action.
- Immediate transfer target: that level is carried globally by the
  orbit-stabilized action.

### Pass 8 — octonionic exponential level

- Supplier: `Octonion.level_eq_log_norm_exp`.
- Disk target: the octonionic chart reads the same modulus/real-level
  coordinate.
- Immediate transfer target: this chart reading is well-defined across the
  complete sphere-world extension.

### Pass 9 — exponential-fibre height and band

- Supplier: `exp_fibre_height_band`.
- Disk target: the band is the phase coordinate and its uniqueness is the
  action's branch choice.
- Immediate transfer target: the band/branch coordinate is carried wholesale
  through the orbit-stabilized action.

### Pass 10 — normalized zero collapse at the shared N

- Supplier: `normalizedZero_collapse_at_N`.
- Disk target: collapse at the one common `N` is native C3/W3 behavior of the
  same action, in every world.
- Immediate transfer target: the collapse is well-defined across all relevant
  object frames and arrow transitions without a per-index connector.

### Pass 12 — normalized-zero real value

- Supplier: `normalizedZeroLift_re`.
- Disk target: each zero's real part is the action's native modulus/real-level
  coordinate at that footpoint, in every world.
- Immediate transfer target: those genuine real-value states and transports
  are present throughout the orbit-stabilized action.

### Functor acceptance gate

After Passes 1–10 and 12, accept

```lean
sectionFunctor A : GreatCircle.Base ⥤ SphereWorld
```

only when its exact object frames and arrow transitions carry every preceding
vertical slice, including `N ↦ N`. The live
`sectionFunctor_map_full` orbit–stabilizer factorization remains structurally
unchanged: both orbit-representative legs, `stabilizerPart`, and the
distinguished-action position stay. What occupies and is proved about that
position is now the complete function-valued action.

There is no separate bulk-transfer phase after this gate.

### Form the exact total, then Pass 11 — C4 output population

Only after the functor acceptance gate is the exact `𝒯_A` formed from that
functor.

- Supplier: `A.c4_infinite`.
- Output target: the C3 zero outputs of the completed action form an infinite
  genuine population in this exact total.
- Immediate transfer target: `zeroTotal_c4_infinite` is a statement about
  those orbit-stabilized outputs, not `:= A.c4_infinite` with the transported
  total absent from the conclusion.
- Stop and verify before touching any readout declaration.

Row 11 is deliberately executed after Row 12 because C4 population is an
output of the completed action and has no intended total object before this
gate. This is the only numerical reordering, and it enforces the forward
dependency from the hypotheses.

---

## Quarantine — no downstream construction during the twelve

Until Pass 11 is accepted, do not inspect, define, modify, or use any of the
following to decide an upstream declaration:

- any constructed naturality cone or project-level component diagram, at any
  stage;
- any cocone introduced before the exact total;
- `labelCocone` or `val`;
- an 8.3.4 or π₀ instantiation;
- an indexed `toNHom`, a chosen zero-to-N arrow, or a per-index connector;
- `Classical.choose` transport assembly;
- a generic `Grpd`-valued replacement for `sectionFunctor A`;
- a wrapper, theorem-field carrier, scalar bridge, quotient section, or
  `Disc ℝ`;
- a change to `totalTransport` made for syntactic visibility;
- any claim that a downstream naturality obligation determines what the disk
  action must contain.

No later naturality-cone construction is permitted. The completed functor and
exact total must themselves make the pull to the common witness `N` intrinsic,
so 8.3.4 and π₀ detect it. If the downstream readout appears to need a new
analytic fact or compatibility proof, the corresponding vertical slice was not
completed upstream; return to that named row.

---

## The readout — what is cited and what was constructed ahead of time

**Cited, keep unchanged.** `ConnectedComponents J := Quotient (Zigzag.setoid J)` is Riehl
Rem 8.3.5 verbatim — objects up to zig-zags. It quotients a category's own objects by its own
arrows, so applying it to `A.TotalA` is instantiation, not pre-construction. Same for
`Functor.mapConnectedComponents` and `pi0Functor : Cat ⥤ Type`. These are item 5 of R0's list.

**Constructed ahead of time — instantiate only at the author's objects.**
`pi0Cocone`, `toColimitObj`, `toColimitObj_eq_of_zigzag`, and
`pi0GrothendieckEquiv` (`Theorem.lean:31–130`) are reusable general suppliers.
Their canonical cocone already carries its naturality; never rebuild it as a
project naturality cone. They create no project functor or intermediary diagram. Instantiate or restate
them only at `A.TotalA` and `sectionFunctor A`; never reshape the author's
object to fit a generic binder.

**8.3.4 consumes arrows, never analytic facts.** `SOURCES/Riehl.md:55`, inside the proof: the
isomorphism `pi_0(el X) ≅ colim_C X` holds "because each arrow connecting two objects in el X
corresponds to a condition demanding that these elements are identified in any cone under X." An
arrow existing imposes an identification — that is the whole mechanism. `pi0Cocone` proves
naturality by `Zigzag.of_hom ((Grothendieck.ιNatTrans f).app j)`: that sentence transcribed.
There is no input slot for "the analytic fact at this map, for all spheres."

---

## The cocone establishes nothing

The zigzag produces the singleton. `labelCocone` **labels** it. The real values already ride the
transports, because the twelve are coordinates of the disk action.

Therefore: **no analytic fact or naturality cone is proved at the cocone stage.** If using the
naturally induced `labelCocone` appears to require one, the twelve are not yet coordinates of the
action. That work belongs upstream on the disk — never in the functor, and never as a field.

**Freeze rule.** Once the twelve are coordinates of the action, `sectionFunctor`,
`projectiveObjectFrame`, `projectiveArrowElement`, `projectiveTransition`, `TotalA` and
`TotalHom` are frozen. Any diff touching them while working on `labelCocone` or `val` is rejected
**without reading the justification** — the justification is always "naturality needs it," and
that sentence is the failure.

---

## Finale — `FINAL_PLAN` §7 steps 6–8, unchanged

6. `𝒯_A` is formed definitionally from the completed action
   (`ProjectiveTotal.lean`; category laws discharged by
   `projectiveTransition_id`/`_comp`). Populate its C3/C4 outputs.
7. Instantiate 8.3.4 at that exact functor **without an indexed connector** —
   `ConcentricityReadout.zeroColimitClass_eq_north` currently applies
   `GreatCircle.toNHom (A.sphereZero n).re` per `n`, which is the rejected
   per-index route. Then `labelCocone`, `val := colimit.desc labelCocone`,
   `c := val κ`, and the literal `∃ c`.
8. One serial build; print the theorem, its axioms, and the sorry audit.

**Terminal 0/0:** full build green, no executable `sorry`, no `sorryAx`, the agreed axiom set
only, and the literal `∃ c` conclusion in the theorem's type.
