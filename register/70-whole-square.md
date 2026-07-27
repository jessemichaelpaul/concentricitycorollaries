# The whole square — the positive register for the residue natural-inclusion gate

## 0. Absolute categorical-level lock — supersedes every lower-level reading

The current subject may never leave:

```text
natural transformation
  → orbit subgroupoid
  → groupoid preimage
  → AsectionActionDiagram A.
```

The mandatory outer declarations are:

```lean
AsectionCResidueDiagram A : GreatCircle.Base ⥤ Grpd
AsectionCResidueInclusion A :
  AsectionCResidueDiagram A ⟶ AsectionActionDiagram A
```

This is a hard rejection rule:

- `𝓡_A(X)` is the certified
  `InverseImageCResidueStateWorldGroupoid A X`, read orbit-wise inside the
  action groupoid. Do not define another object.
- No `𝓡_A(X)`, inclusion component, or component source may depend on a free
  arrow `f` or target `Y`. In particular,
  `AsectionCResiduePreimage A f` and any arrowwise
  `ObjectProperty.inverseImage ... (AsectionActionTransport A f)` are
  forbidden substitutes.
- No static predicate, set, carrier, essential image, coordinate condition,
  preservation theorem, invariance theorem, or stabilizer theorem may
  replace the orbit-subgroupoid/groupoid-preimage subject.
- Generic full-subcategory or `ObjectProperty` machinery may occur only
  internally in the final A-specific diagram and natural transformation.
- **Restated 2026-07-27 (post-certificate; Opus's deletion tripwire + §6c
  doc-vs-code ruling).** Under the ratified definition — membership carrying
  the base arrow as data, cross-frame closure by composition — the `d = 1`
  square has nothing left to do at this gate: the criterion demanding its
  consumption was written for the retired invariance framing. Its role is
  **provenance** (the transport IS the square applied — recorded by receipt)
  and its working role moves to the component/tape step, where the all-`t`
  family operates. Do not manufacture a consumer to satisfy the old wording.
- Before any helper declaration or subsidiary receipt counts, Lean must
  consume:

  ```lean
  example (A : ASection) :
      AsectionCResidueDiagram A ⟶ AsectionActionDiagram A :=
    AsectionCResidueInclusion A
  ```

Any elaborated term outside this register is a rejected substitute, not
partial progress. Return immediately to the outer natural-transformation
type and do not investigate the substitute.

Sections below record supplier history and earlier framings. Wherever they
describe an objectwise static selection or a substantive
`cResidue_preserved` theorem, this §0 and §§9–10 govern instead: selection is
orbit-wise, closure is structural in the action groupoid, and the open work
is categorical packaging of the already-built A-specific action.

This file is the concise positive authority for the one open gate. Every
entry states what is **supplied**, with the exact live declaration that
supplies it. Line references are to the pinned toolchain (Lean 4.31.0,
Mathlib `fabf563a`).

Everything below is the *categorified* orbit–stabilizer: the action
groupoid, which retains its stabilizers as vertex automorphism groups
(CTIC Ex. 1.5.19, Ex. 2.4.10 — `SOURCES/Riehl-CTIC.md`). The stabilizer leg
is a retained arrow of the structure at every step. That is what makes this
register available.

Read `register/00-register.md` for the invariant, and `EndgamePlan.md` for
the execution order. This file changes no architecture; it states one gate.

## 1. Both inverse images are certified

The semantic locus is defined from the A-section's own equation:

```lean
-- ASectionCResidue.lean:26
def CResidueZeroLocus (A : ASection) : Set ℂ := {z | A.F z = 0 ∧ 0 < z.im}
```

Its framewise inverse image inside the certified fibre is named, and its
full subgroupoid and `Groupoid` instance are live:

```lean
-- ASectionCResidueInverseImage.lean:38, :48, :52
def IsCResidueState (A : ASection) (X : GreatCircle.Base) :
    ObjectProperty (AsectionActionFiber A X) :=
  fun x => x ∈ (fun y => y.positioned.back.coordinate) ⁻¹'
             ((fun z : ℂ => (z : OnePoint ℂ)) '' A.CResidueZeroLocus)

abbrev InverseImageCResidueStateWorldGroupoid (A) (X) :=
  (IsCResidueState A X).FullSubcategory
```

**Supplies:** both the source `𝓡_A(X)` and the target `𝓡_A(Y)` of the
preservation statement exist as certified objects before the proof begins.
Nothing is formed, enumerated, or seeded during the proof.

Each object of `F_A(X)` also carries its own construction as equational
fields (`ASectionActionDiagram.lean:50`):

```lean
positioned_by_action : positioned = (coordinateTransport A m).obj input   -- :53
value_realized       : value = (AsectionStateOutput A).obj positioned     -- :56
```

**Supplies:** the chain input → positioned → value through `m_X` is
available by projection on every state.

## 2. The whole-action commuting square

The frame is the one distinguished element positioned:

```lean
-- ProjectiveSection.lean:243
def projectiveObjectFrame (A) (X) : Moebius :=
  cayleyProjective (orbitRep (back X)) * A.distinguishedDiskAction
```

The arrow is that element's conjugation, definitionally:

```lean
-- ProjectiveSection.lean:292
def projectiveArrowElement (A) (f : X ⟶ Y) : Moebius :=
  projectiveObjectFrame A Y * cayleyProjective (stabilizerPart f).1 *
    (projectiveObjectFrame A X)⁻¹
```

and the square commutes:

```lean
-- ASectionFunctor.lean:195, commutes := projectiveArrowElement_frame_compat (ProjectiveSection.lean:468)
def orbitStabilizerActionSquare (A) (f : X ⟶ Y) :
    ActionTransportSquare (projectiveObjectFrame A X) (projectiveObjectFrame A Y) where
  left  := projectiveArrowElement A f
  right := cayleyProjective (stabilizerPart f).1
  -- left * m_X = m_Y * right
```

`F_A(f)` **is** that square, applied:

```lean
-- ASectionActionDiagram.lean:279
def AsectionActionTransport (A) (f : X ⟶ Y) :
    AsectionActionFiber A X ⟶ AsectionActionFiber A Y :=
  (orbitStabilizerActionSquare A f).actionStateTransport A
```

with all three faces available definitionally — input by `right`
(`:284`), positioned by `left` (`:291`), value by `Output ∘ left` (`:298`),
each `rfl`.

**Supplies:** the equation `left * m_X = m_Y * right`, which carries an
`X`-frame reading to a `Y`-frame reading, and moves input, positioned state
and evaluated output together in one step.

## 3. The uniform all-`t` two-leg receipt

The positioned family sets its left leg with no `d` in it:

```lean
-- ASectionFunctor.lean:719
def positionedOrbitSquare (A) (f : X ⟶ Y) (d : Moebius) :
    ActionTransportSquare (projectiveObjectFrame A X * d)
                          (projectiveObjectFrame A Y * d) where
  left  := projectiveArrowElement A f
  right := d⁻¹ * cayleyProjective (stabilizerPart f).1 * d
```

These are the fields of the live definition itself. At any `d`, both leg
equations are therefore available by `rfl`; no auxiliary receipt is needed.

**Supplies:** instantiate the disk-exp square transport at
`d_t = diskExpAction (lift t)` and both legs arrive by `rfl`, at every
instant of every tape. The left leg is the *identical term* the transport's
own square carries — the same term, not a term equal to it — so the
horizontal motion at every instant of the tape and the horizontal motion of
`F_A(f)` are one object. The tape's only contribution is the conjugated
stabilizer leg `d_t⁻¹ * r_f * d_t`: phase and winding stay in the
stabilizer while the whole action moves horizontally.

**The gate is one instantiation wide.** `positionedOrbitSquare A f d` is
defined for arbitrary `d`, so instantiate it directly at `d = 1`. That gives
the native orbit–stabilizer square on the certified fibres, after the
routine group simplifications

```text
m_X * 1 = m_X,      1⁻¹ * r_f * 1 = r_f.
```

So:

- `d = 1` **locates** the certified-fibre member of the arbitrary-`d` family;
- the same definition supplies the **all-`t` provenance** when instantiated
  at `d_t = diskExpAction (lift t)`;
- the two share the identical left leg `projectiveArrowElement A f` by `rfl`;
- **no claim is made that `d = 1` is an instant of every GPV tape.**
  `diskExpAction_zero : diskExpAction 0 = 1` (`CayleyDictionary.lean:194`)
  is green, but it does not show that an arbitrary tape has an instant with
  `lift t = 0`, and `AsectionGpvLift` imposes no such condition. Nothing
  here needs it.

The full object is instantiated through the `N`-anchored presentation, and
`0` is the other fixed boundary face of the same diagonal element. Setting
the extra parameter to `d = 1` does not remove the distinguished action:
`projectiveObjectFrame A X` already contains
`A.distinguishedDiskAction`.

Functoriality of the family is carried by `positionedOrbitSquare_id`
(`:744`) and `_comp` (`:758`).

## 4. Uniqueness: the stabilizer leg and the GPV tape

```lean
-- ProjectiveSection.lean:118, :131
theorem GreatCircle.orbit_stabilizer_factor (f : X ⟶ Y) : ...
theorem GreatCircle.stabilizerPart_unique (f : X ⟶ Y)
    (h : GreatCircle.NorthStabilizer)
    (hf : f.val = orbitRep (back Y) * h.1 * (orbitRep (back X))⁻¹) :
    h = GreatCircle.stabilizerPart f
```

**Supplies:** `right` is the one north-stabilizer element compatible with
the fixed orbit representatives. It is a named, forced object, not a choice.

The presentation rides across unchanged:

```lean
-- ASectionFunctor.lean:835, _id :848, _comp :867
def reindexAsectionPresentation (A) (f : X ⟶ Y) :
    AsectionPresentation A X → AsectionPresentation A Y :=
  fun p => { gpv := p.gpv, euler_gpv := p.euler_gpv,      -- verbatim, unmoved
             toNorth := ... positionedOrbitSquare A f (diskExpAction ((p.gpv ...).lift t)) ... }
```

**Supplies:** winding, real level, north triangle and lift uniqueness are
literally the same fields at `Y` as at `X`. GPV uniqueness and winding leave
no second lift or competing branch.

Vertically, the sphere direction is free of charge on the coordinate:

```lean
-- ASectionFunctor.lean:78
@[simp] theorem ASection.AsectionState.smul_coordinate
    (A) (g : G2) ... := rfl
```

**Supplies:** `G₂` varies the direction while the complex coordinate stays
definitionally fixed.

## 5. The exact implication

```lean
theorem cResidue_preserved
    (A : ASection) {X Y : GreatCircle.Base} (f : X ⟶ Y)
    {x : AsectionActionFiber A X} (hx : IsCResidueState A X x) :
    IsCResidueState A Y ((AsectionActionTransport A f).obj x)
```

> ### ⛔ The witness is an **output** of the square, never an input to it
>
> `IsCResidueState A Y _` is a membership, so it is tempting to open `hx`,
> take its `z`, and offer that same `z` for the target — `refine ⟨z, hz, ?_⟩`.
> **Do not.** Supplying the witness first asserts that the transported
> coordinate is the point it started at, which silently replaces
> preservation with a **fixed-point** claim and leaves the false residual
> goal `z = left.val (x.positioned.back.coordinate)` — "the left leg fixes
> `z`."
>
> The square says something else: `left • (m_X • input) = m_Y • (right • input)`,
> so the transported coordinate is **a different point of the locus**,
> produced by `m_Y ∘ right`. Consume `positioned_by_action` and `commutes`
> first, then take whatever witness they hand you.
>
> This exact move was run on 2026-07-26 and its full artifact is in
> `register/60-failure-audit.md` §6d. The obstacle it produced belonged to
> the choice of witness, not to the mathematics.

### ⚠️ The frame calculation is ALREADY DONE — do not replay it

**Corrected 2026-07-26.** An earlier draft displayed a five-line chain here
and read as work to perform. It is not. That calculation is a **field of the
certified package**, performed inside `actionStateTransport`
(`ASectionActionDiagram.lean:129`) when it builds the transported state:

```lean
positioned_by_action := by
  calc (coordinateTransport A square.left).obj x.positioned
      = (coordinateTransport A square.left).obj
          ((coordinateTransport A source).obj x.input) := by
            rw [x.positioned_by_action]                  -- source provenance
    _ = (coordinateTransport A target).obj
          ((coordinateTransport A square.right).obj x.input) := by
            exact congrArg (fun F => F.obj x.input)
              (square.coordinateTransport_commutes A)     -- the square, consumed
```

The same `obj` builds `input`, `positioned`, and `value` together, so the
three state faces ride definitionally and **cannot be dropped by any later
restriction**. `AsectionActionTransport A f` is this applied to the `d = 1`
square; `ObjectProperty.lift` restricts it without touching any face.

So do **not** rewrite through `positioned_by_action` and `commutes` by hand.
They have already been consumed. Unpacking a certified package back into its
ingredients is the same error as replaying a chain, and it re-creates the
opportunity to reason legwise about a term nothing is forcing you to hold
whole.

### Three things, kept apart

The bundled square carries `left`, `right`, and `commutes` — and nothing
about the locus. So distinguish, and do not let any two of these collapse:

**(i) THE WHOLE SQUARE, AT `d = 1` — and it is not "frames only".**

⛔ **Corrected 2026-07-26. An earlier draft of this section called `d = 1`
"the frame calculation" and put the GPV content at `d_t`. That is wrong and
it re-creates the whole-square drop.** The frame already *is* the element:

```lean
-- ProjectiveSection.lean:243
projectiveObjectFrame A X = cayleyProjective (orbitRep (back X)) * A.distinguishedDiskAction

-- ProjectiveTransport.lean:196
distinguishedDiskAction A = diskExpAction A.distinguishedPoleLog
--   "the phase retains the winding/band and the modulus retains the real level"
```

So `m_X` already carries the complete `ℂˣ` multiplier — winding, band, real
level — and `positionedOrbitSquare A f 1` is the **whole distinguished
action conjugated between frames**, not a frame skeleton awaiting analytic
content from elsewhere. `actionStateTransport` consumes that whole square
(above), and `AsectionActionTransport A f` is the result.

**(ii) `d_t` IS PROVENANCE, NOT A SECOND SUPPLIER.**
`d = 1` and `d_t = diskExpAction (lift t)` share the identical left leg
`projectiveArrowElement A f` by `rfl`; the `d` parameter is an *extra*
multiplier layered on `m_X`, and `d_t` records the tape's own multiplier at
instant `t`. It is the same horizontal motion read at another multiplier.

⛔ **Do not go to `d_t` for anything the `d = 1` square is missing.** If the
`d = 1` square appears to lack something, the square has been split — the
missing piece is inside it. Shopping at `d_t` for a half you just declared
absent from `d = 1` is the whole-square drop wearing the family as a
disguise.

**(iii) THE IMPLICATION — the obligation itself.**

```text
the transported coordinate is again a member of CResidueZeroLocus A.
```

This is what is proved *from* (ii). It is **not a field of (ii)** and does
not follow from (ii) merely existing — the bundle is analytic and geometric
data about the element; the implication is the statement that the element's
own conjugation carries its own zero set. Treating the bundle's presence as
if it already delivered the implication is the mirror error of unpacking it.

**Its `mathematical provenance` is kind 3 — authored construction.** This
implication follows from C1–C4 and the distinguished element being
simultaneously the function and the Möbius element; it is not a theorem of
any external text and cannot be. Do not search for a citation. Identify it
by its register statement and its live Lean supplier chain:

```text
π ∘ E = exp            pr1_Eexp, LogManifold.lean:364 (VS Rem 5.2(a))
  → the A-generated continuous GPV lift    AsectionGpvLift.lift_exp / .action, :650
  → its pointwise disk automorphism        canonicalAsectionPresentation_gpv_action, :1205
  → orbit–stabilizer positioning at all t  positionedOrbitSquare, :719
  → the uniquely transported residue/N action
```

The theorem is that the **whole A-action preserves semantic residue**. It is
not read off the left leg in isolation, and it is not read off the frame
calculation either — that part is already green.

## 6. What Mathlib supplies next

With the witness in hand, the top arrow is the literal restriction of
`F_A(f)`:

```lean
(IsCResidueState A Y).lift
  ((IsCResidueState A X).ι ⋙ AsectionActionTransport A f)
  cResidue_preserved
```

and the naturality square is `liftCompιIso`
(`Mathlib/CategoryTheory/ObjectProperty/FullSubcategory.lean:167`), which is
`Iso.refl _`:

```text
𝓡_A(X) ──── 𝓡_A(f) ────▶ 𝓡_A(Y)
   │                        │
   │ ι_X                    │ ι_Y
   ▼                        ▼
F_A(X) ──── F_A(f) ────▶ F_A(Y)
```

Identity, composition, fullness and faithfulness are inherited; do not
rebuild them (`ι_obj_lift_obj` `:169`, `ι_obj_lift_map` `:172` are `rfl`).
Because the witness is quantified over every arrow it also applies to `f⁻¹`,
so functoriality supplies the inverse restricted transport — there is no
separate onto obligation.

Assemble `𝓡_A : 𝓑 ⥤ Grpd` and the natural inclusion `ι_A : 𝓡_A ⟹ F_A`,
then run the focused build and axiom audit. This closes the first internal
checkpoint of the unified endgame gate. It does not authorize leaving the
approved library or treating later packaging as a new mathematical
objection.

The inclusion has a precise job. It certifies that `𝓡_A` is the diagram of
residue value states **inside** the already-certified whole value-state
diagram `F_A`. For every `f : X ⟶ Y`, its naturality square is

```text
𝓡_A(f) ⋙ ι_Y  ≅  ι_X ⋙ F_A(f),
```

where the objectwise comparison is
`(IsCResidueState A Y).liftCompιIso ...`, hence `Iso.refl _`.
Globally, `ι_A` is a natural inclusion whose components are fully faithful.
It is not in general a natural isomorphism `𝓡_A ≅ F_A`, because the residue
states are a full subdiagram rather than all value states.

Applying `Grothendieck.map` to `ι_A` then gives the total-level inclusion

```text
∫𝓡_A  ⟶  ∫F_A = TotalActionStateWorld A
```

over the same projective base. This establishes the provenance of the
residue total before any component calculation begins.

### The gate, as seven steps

Starting from certified `𝓡_A(X)`, `𝓡_A(Y)`, and `F_A(f)`:

1. instantiate `positionedOrbitSquare A f` at `d = 1`, obtaining the native
   orbit–stabilizer square on the certified fibres;
2. use the square: `left_f * m_X = m_Y * right_f`;
3. use `stabilizerPart_unique` to retain the uniquely forced right leg;
4. use the defining fields of `positionedOrbitSquare A f d_t` and
   `reindexAsectionPresentation` for the uniform all-`t` GPV, winding,
   level, and north provenance of that same left leg;
5. read the complete transported action state to prove `cResidue_preserved`;
6. give that witness to `ObjectProperty.lift`; take the inclusion square
   from `liftCompιIso`;
7. assemble the residue diagram and natural inclusion, inheriting identity
   and composition.

### Triple-kernel certificate for this gate

The focused receipts are kernel instantiations of Jesse's exact functorial
objects, not generic or illustrative category-theory examples. Lean may use
`example` as command syntax, but the certificate subject remains the
categorified orbit--stabilizer diagram. With free `X`, `Y`, and `f`, it must
visibly instantiate

```text
F_A(X), F_A(Y), F_A(f),
𝓡_A(X), 𝓡_A(Y), 𝓡_A(f),
ι_X, ι_Y, and the naturality square of ι_A at f.
```

The focused receipt must show:

- `cResidue_preserved` with free `X`, `Y`, `f`, and `x`;
- the top arrow is literally `ObjectProperty.lift` of `F_A(f)`;
- its object and arrow projections agree with the ambient transport;
- the inclusion square is `liftCompιIso`;
- the residue diagram's object is exactly the certified
  `InverseImageCResidueStateWorldGroupoid A X`;
- identity and composition are inherited from
  `AsectionActionTransport_id`/`_comp`;
- the natural inclusion has the expected components and naturality;
- focused builds only;
- no `sorry`, `admit`, `sorryAx`, or new axiom;
- axiom surface exactly `[propext, Classical.choice, Quot.sound]`.

## 7. Unified endgame build ladder

After the residue diagram checkpoint:

1. use `Grothendieck.map` and `functor_comp_forget` to totalize its natural
   inclusion over the same projective base, certifying that `∫𝓡_A` is the
   residue-value-state total inside `TotalActionStateWorld A`;
2. recognize the residue total through the categorified orbit–stabilizer
   action already supplied by the distinguished element;
3. retain its orbit/coset and vertex stabilizer through
   `MulAction.orbitEquivQuotientStabilizer` and
   `ActionCategory.stabilizerIsoEnd`;
4. read its **categorical** one-component property through the transitive
   action-groupoid instance;
5. apply CHT Remark 8.3.5 to the residue total's already-inhabited component
   carrier. The
   existing certified residue object supplies the named class; C4 supplies
   infinitude and is not a new build step;
6. instantiate `pi0GrothendieckEquiv` at the exact residue diagram;
7. descend the already-compatible real-level orbit invariant to the named
   `val_A`, keep the unique class visible, and set
   `c` to `val_A` at it;
8. close `ASection.concentricity`, rewire its existing corollaries, then run
   the terminal root build and 0/0 audit.

“Categorically one component” means that objects are joined by zigzags in
the action groupoid and hence have one `ConnectedComponents` class. It is
not a statement about topological connectedness of a zero locus, sphere, or
analytic space.

The first internal checkpoint contains the only open A-specific
preservation implication. The later rows are named instantiations,
restrictions, equivalences, and descents through already-approved
structures.

The total inclusion, Remark 8.3.5, and `pi0GrothendieckEquiv` must not be
identified:

```text
ι_A and Grothendieck.map
  certify which value states form the residue system;

Remark 8.3.5
  makes π₀(∫𝓡_A) a named singleton;

pi0GrothendieckEquiv 𝓡_A
  identifies that singleton with colim (π₀ ∘ 𝓡_A).
```

### Scope note — `toColimitObj_eq_of_zigzag` is not a violation here

`pi0GrothendieckEquiv` ([`Theorem.lean:108`](../Concentricity/Theorem.lean))
builds its `toFun` as `Quotient.lift (toColimitObj F) (toColimitObj_eq_of_zigzag F)`.
That name is **banned as a concentricity mechanism**, and the ban stands:
zigzag-collapse must never be what produces the project's one class. Here it
is doing something else and strictly generic — discharging *well-definedness*
of a quotient lift, i.e. that a function on objects respects the zigzag
setoid. Every `ConnectedComponents` elimination in Mathlib needs such a term.

The project's connectedness comes from **§4's recognition** — the residue
total is the action groupoid of the existing orbit, categorically connected
by the transitive-action instance — and the singleton from CHT Remark 8.3.5.
`pi0GrothendieckEquiv` is applied *after* that, only to transport an
already-certified singleton across an equivalence.

Recorded here because the ban and the green declaration would otherwise
collide at exactly the moment of instantiation, and a doc-vs-code collision
is a logged trigger (`register/60-failure-audit.md` §6c). Seeing this name
inside `pi0GrothendieckEquiv` is expected and is not cause to stop.

## 8. Continuous register checkpoint

Keep this checkpoint active from the real theorem term through its focused
certificate. State it when that term is fixed and again immediately before
certification; do not treat it as a pause:

```text
REGISTER CHECK
gate:
target file:
active theorem:
mathematical provenance:
approved supplier:
instantiated A-specific object:
intended proof term:
```

Each entry must occur in
`skills/orbit-stabilizer-groupoids/references/concentricity-instantiation.md`.
If not, classify the drift through `register/60-failure-audit.md`, return to
the last approved supplier, and resume the same theorem. A drift is a process
failure, not a mathematical result.

An elaborator goal is never promoted to a new problem statement. It remains a
projection of the registered functorial term. Resume from that term, not from
the goal's surface syntax.

### Execution lock

> ⛔ **SPENT — this lock governed the `ι_A` implementation turn, which closed
> at commit `57384ae` (2026-07-27).** Everything below names a gate that no
> longer exists: the four ratified declaration names, the `cResidue_preserved`
> first-proof-action requirement, the two-file write set, the `sorry` at
> `ASectionCResidueDiagram.lean:53`, and the PILOT hard stop are all
> **historical record, not instructions.** Do not execute any of it. The
> standing rules that survive independently of this gate are: no scratch or
> temporary Lean files anywhere, focused builds only, and no write-set until
> Jesse approves exact paths and commands.

This section governs the implementation turn.

- Until Jesse approves exact implementation paths and exact focused build
  targets, the write-set and build-target set are empty.
- No scratch Lean file, temporary proof module, new directory, alternate
  route, or parallel implementation may be created in the repository,
  `/tmp`, or any other location.
- The first proof action is Step 1 above: the literal term
  `positionedOrbitSquare A f (1 : Moebius)` must occur in the real
  `cResidue_preserved` theorem and be elaborated there. Merely checking its
  name or consuming only `orbitStabilizerActionSquare A f` does not discharge
  this requirement.
- Every subsequent proof action must remain in the seven-step residue-square
  order and then the unified endgame ladder above.
- A need for any unlisted file, theorem, command, or route is a stop
  condition requiring Jesse's explicit approval.

#### LOCK DATA — the `ι_A` checkpoint

Declaration names and paths were fixed by Jesse on 2026-07-26. The continuous
command loop below is the 2026-07-27 housekeeping revision; editing this
record does not itself release Lean execution.

This is the complete proposed continuation set for this checkpoint. Nothing
outside it.

**(1) Declaration names — four, in this order.**

```lean
ASection.cResidue_preserved          -- witness; free A X Y f x
ASection.AsectionCResidueTransport   -- 𝓡_A(f), the ObjectProperty.lift restriction
ASection.AsectionCResidueDiagram     -- 𝓡_A : GreatCircle.Base ⥤ Grpd
ASection.AsectionCResidueInclusion   -- ι_A : AsectionCResidueDiagram A ⟶ AsectionActionDiagram A
```

**(2) Write-set — these two files only.**

```text
Concentricity/ASectionCResidueDiagram.lean       the four declarations above
Concentricity/_GateCResidueDiagramAudit.lean     one stable checkpoint audit
```

Two files, because the repository's convention (`_GateCResidueInverseImageAudit.lean`)
keeps declarations in the implementation module and `#check`/`example`/`#print axioms`
in a separate `_Gate*Audit.lean`. Every other module, `ASectionCResidueInverseImage.lean`
included, is **read-only** here; an edit to a certified module during this step
is the tell that the proof is being made true by redefinition.

**(3) One uninterrupted command loop, in this order.**

Put the intended bundled term in the real theorem and elaborate the
implementation file immediately. Repeat this same focused elaboration while
closing that theorem:

```bash
lake env lean Concentricity/ASectionCResidueDiagram.lean
```

Once all four declarations close, complete the stable audit file with its
exact-object kernel instantiation receipts and `#print axioms`, then run:

```bash
lake build Concentricity._GateCResidueDiagramAudit
```

There is no separately completable supplier phase and no pre-flight-only
audit state. Supplier resolution, implementation elaboration, consumer
instantiations, and axiom printing are one registered kernel loop. No other
command; no root build and no bare `lake build`.

**(4) Ratified supplier interface floor — these six checks.**

```lean
import Concentricity.ASectionCResidueInverseImage

#check @ASection.ActionTransportSquare.actionStateTransport
                                                -- the package that consumes the square
#check @ASection.ActionTransportSquare.coordinateTransport_commutes
                                                -- the commuting equation it consumes
#check @ASection.AsectionActionTransport        -- F_A(f) = that package at d = 1
#check @ASection.orbitStabilizerActionSquare    -- the d = 1 square
#check @ASection.positionedOrbitSquare          -- the arbitrary-d family, incl. d_t
#check @ASection.IsCResidueState                -- 𝓡_A(X), source and target
```

The first two were added by the 2026-07-26 relock: the earlier list was aimed
at the square rather than at the package that consumes it, which is what §5's
frame calculation actually lives in.

`GreatCircle.orbit_stabilizer_factor`,
`GreatCircle.stabilizerPart_unique`,
`ASection.reindexAsectionPresentation`, and
`ASection.AsectionState.smul_coordinate` are consumed inside the proof rather
than presumed by the checkpoint's interface. The same rule governs the six
additional checks currently written in the audit
(`distinguishedDiskAction`, `distinguishedDiskAction_eq_fullMultiplier`, the
two fixed-face lemmas, `eulerDiskAction_eq_value`, and the canonical
continuous-level theorem): retain each exactly when the elaborated proof term
consumes it. A written menu does not ratify a supplier. The exact-object
kernel receipts, not the `#check` list alone, certify instantiated use in the
authored functorial construction.

**Fill the REGISTER CHECK from `#check` output, not from memory.** A field
recalled can be filled with a confident wrong answer; a field pasted from the
elaborator cannot — it has no view about which supplier the register approved.
A failing `#check` is a **name fact**, answered by the type checker. It is not
a mathematical event and is never a reason to open another route.

Before any supplier-insufficiency report, also fill the `WHOLE-SQUARE CHECK`
from `register/60-failure-audit.md` §6f. Binding
`positionedOrbitSquare A f 1` in unbuilt text is not yet an instantiation;
after elaboration it is still only the first action. The check does not pass
until its `commutes` field, both `positioned_by_action` provenance fields, and
the arbitrary-`d_t` reindexing supplier have occurred in the proof term. If
they have not, resume from the square without searching another folder.

**Former pre-repeat hold — discharged.** `NormalizedNActionTape.lift_unique`
is live, derived from `winding_lift_unique`, and focused-certified by
`_GateNormalizedNActionTapeUniquenessAudit`.

The current continuation probe in
`Concentricity/ASectionCResidueDiagram.lean` ends in an uncertified `sorry` at
line 53. That is the exact implementation hole this loop must close; it is not
part of the certified chain and is not evidence against the gate.

**Out of scope at this checkpoint**, explicitly: `Grothendieck.map`, the
residue total, its component receipt, Remark 8.3.5, `π₀`,
`pi0GrothendieckEquiv`, the real-level invariant and its descent,
`ASection.concentricity`, and the corollaries.

Do not treat that list as a list of steps. Some of it is construction; the
rest is **output** — read off the construction once it exists, not built. The
real-level invariant and its descent are output: they come from applying
Remark 8.3.5 to the colimit of `𝓡_A` along `ι_A`. Naming a supplier for an
output presupposes it is something to be built, and that presupposition is how
an output turns into a gate and then acquires a proof obligation nobody owed.

Auditing any of this before `ι_A` exists is the location error this protocol
prevents.

#### This checkpoint is the PILOT — one loop, then a hard stop

The internal protocol for every endgame checkpoint is a single registered
build–certificate loop. Supplier resolution is not a stopping point: the
builder edits the actual theorem, immediately elaborates it, completes the
exact-object audit when it closes, and immediately runs the focused
certificate.
Report at each certificate — declaration, literal type, axiom surface, and
next locked instantiation — but do not create an intermediate success state.

The role split is orthogonal to that loop: Sol owns the implementation and
focused certificate; Fable audits the resulting stable kernel state. An audit
handoff is not a phase boundary and never occurs between supplier resolution
and elaboration of the real theorem.

For `ι_A`, execution **stops after that focused certificate** — before
`Grothendieck.map` or anything else in the ladder — so Jesse and Fable can
review the pilot.

The reason is that this checkpoint is not only proving `ι_A`. It is testing
whether the skill-to-Lean supplier protocol actually minimizes location error.
That protocol is: read the cited theory, read the skill, then visit the live
library and match library to theory *through the skill* — never promote a
supplier from a search result alone.

**What counts as the pilot working.** Fixed in advance, so the verdict is not
written after seeing the outcome:

1. Every supplier consumed was on the approved list, at its real full name.
2. Any stop was classified from `register/60-failure-audit.md` and resumed
   from the last approved supplier — a stop is a pass, not a failure, provided
   it was classified rather than investigated.
3. No scratch file, no temporary module, no alternate route, no broad build.
4. No certified module was edited.
5. Axiom surface exactly `[propext, Classical.choice, Quot.sound]`, no `sorry`.
6. **The one that matters: no wiring obligation was reported as a mathematical
   gap, and no output was treated as a step.**

Item 6 is the thing under test. The others are hygiene; that one is the
disease. A run that satisfies 1–5 and fails 6 is a failed pilot, and the
protocol needs another pass before the remaining checkpoints run internally.

The earlier supplier-only run did correctly catch one name-location error: a supplier
(`AsectionFunctor_map_uses_two_legs`, in the quarantined
`JuxtapositionPreflight` namespace at `ASectionFunctor.lean:929–1082`) failed
its `#check`, was classified as wrong-library drift, and nothing was written or
investigated. That protection remains. What is retired is treating that
supplier resolution as a completed phase before the actual functorial term is
elaborated. The two legs are read off the fields of `positionedOrbitSquare`,
where they were definitional all along.

## 9. 2026-07-27 — the author's reading of record (supersedes the witness-as-theorem framing)

The sections above were written around `cResidue_preserved` as the one
substantive obligation. The author has ruled that framing an artifact. The
anatomy, in his words: it was **"a model trying to sneak the output of zeros
into the input"** — the membership map tested transported coordinates against
the zero set as a static input-side carrier, when the zeros are **outputs**
of the round trip. Values are inherited, never installed. An A-section is not
pre-defined — it is **built** by C1–C4 and slice-preservation theory, and
what makes it well defined is already orbit–stabilizer, held across the whole
`SphereWorld` continuum inside the certified `F_A` and `F_A(X)`. No further
well-definedness (= "preservation") theorem exists.

The reading of record, complete:

1. **`𝓡_A` is the certified semantic preimage** — a separately bundled
   fibrewise full preimage groupoid in the kernel of the author's own
   action. It is not a set-theoretic subset of `F_A(X)`. Semantic selection
   by equation is what keeps the colimit argument non-circular.

   ⛔ **Reversed by the author, 2026-07-27 evening (`57384ae`).** This point
   previously read "the object is untouched; no orbit-saturated or enumerated
   replacement is permitted; `ASectionCResidueInverseImage.lean` stays
   certified and read-only." Jesse then diagnosed that file himself: *"I
   separated the preimage from the very functor that defines `F_A(X)` — the
   forbidden static-carrier substitution again."* Membership had been defined
   through the external projection `positioned.back.coordinate` into a fixed
   set, and **that encoding is what manufactured the false "Möbius image
   preserves the zero set" obligation.** He re-authorized the write and
   ruled: the preimage lives **under the functor that defines `F_A(X)`**,
   `N`-anchored, with the base arrow held as data. What he struck as circular
   was an *enumerated / orbit-saturated* carrier — not a preimage taken under
   his own action. Semantic selection by equation still happens at exactly
   one place, the whole `0`-to-`N` frame, where
   `projectiveObjectFrame_north : projectiveObjectFrame A (pointObj ∞) =
   distinguishedDiskAction A` — the frame **is** the element, and that element
   holds *both* boundary faces:
   `distinguishedDiskAction_fixes_cayley_zero` and
   `distinguishedDiskAction_fixes_cayley_N`.

   ⛔ **The selected object is the whole `0`-to-`N` square, never "the
   residues at the north point"** (author, 2026-07-27). Euler presents at
   `0`, Weierstrass at `N`, and the square spans them; `𝓡_A(X)` is the image
   of *that square* under the same action functor. The point-reading is
   strictly weaker than what is triple-certified, and it is not merely
   imprecise — it manufactures a "join the distinct zeros" obligation the
   author already struck. If the selected object is the square, there is
   nothing to join. Two consequences for the component step: the orbit whose
   image is taken is the orbit of the square, and connectedness and the
   level's conservation stop being two facts — an axis pinned at both ends by
   the very element doing the moving cannot slide, so the same square that
   gives the orbit gives the invariant.

   **Do not re-raise the read-only clause against the certified
   code; this text was the stale side of that collision (§6c).**
2. **The preimage square at `0`/`N` already commutes.** The unique winding —
   `winding_lift_unique`, the tape's `lift_unique`, `lift_closed`, the
   element fixing both boundary points — means the two ways around were
   never two things. This is an observation read off certified declarations,
   never a proof obligation.
3. **`ι_A` is the functorial inclusion**, supplied entirely by machinery:
   `ObjectProperty.lift`, `fullyFaithfulι`,
   `liftCompιIso = Iso.refl _`. Its precise type is a natural
   transformation

   ```text
   ι_A : 𝓡_A ⟶ F_A
   ```

   whose components

   ```text
   (ι_A)_X : 𝓡_A(X) ⥤ F_A(X)
   ```

   are fully faithful inclusion functors. The domain is a separately
   bundled full preimage groupoid, not a subset of the codomain. For every
   `f : X ⟶ Y`, `𝓡_A(f)` is literally the restriction of `F_A(f)`, and
   `liftCompιIso` gives the naturality square

   ```text
   𝓡_A(f) ⋙ (ι_A)_Y ≅ (ι_A)_X ⋙ F_A(f).
   ```

   Since the base is a groupoid, `f⁻¹` supplies the inverse restricted
   transport. Thus `𝓡_A` is naturally isomorphic to the image of its own
   functorial transport — never to all of `F_A`, and never by a
   set-theoretic equality `F_A(f)(𝓡_A(X)) = 𝓡_A(Y)`.

   **Semantic ruling, refined by the exact Lean lock in §10:** the
   restriction term that `ObjectProperty.lift` requests. It is never
   filled generically, never deleted, and never handed back to the author
   as a debt — the three forbidden treatments, catalogued in the skill's
   "ONE A-specific slot" section. It is filled at the transcription
   session: the author's free definition of the preimage together with his
   master §8b step — "the group and the function are the same object" —
   already bundled in `AsectionActionDiagram.obj/map`, typed by the builder,
   and audited for exact A-specific consumption. `𝓡_A(f)` is then the
   **same transport read on the
   preimage** — one term in two roles — so the naturality square commutes
   because its top arrow is literally its bottom arrow restricted. The
   Lean anatomy is already whole: `F_A(X) = AsectionActionFiber A X` and
   `F_A(f) = AsectionActionTransport A f` are the two fields of
   `AsectionActionDiagram A`; `ι_A`'s content lives inside the certified
   functor, awaiting only the restriction.

   **Reclassification:** the `52bde67` total-full-subcategory construction
   is a true generic packaging checkpoint, NOT this `ι_A`. The rebuilt
   certificate must exhibit, at free `X Y f`, all seven consumers —
   `𝓡_A(X)`, `𝓡_A(Y)`, `𝓡_A(f)`, `(ι_A)_X`, `(ι_A)_Y`, the naturality
   square, and `AsectionActionTransport A f` **in the conclusions** — and
   it passes only if deleting any supplier breaks it.
4. **CHT Remark 8.3.5 consumes what `ι_A` does to the preimage.**
   `Grothendieck.map ι_A` is the induced functorial inclusion of the
   separately bundled residue total into the certified ambient total, over
   the same base; it is not a subset inclusion. The collapse through the
   common `N` names the singleton;
   `pi0GrothendieckEquiv` is the last comparison; the real-level invariant
   descends to `val_A`; `c` is `val_A` at that class.

No pre-flight instruction, checklist row, or proof spine in this file may be
read as requiring a derivation at step 3. Wherever §5's spine says "prove",
read "exhibit from the named certified suppliers". The four ratified
declaration names are unchanged; `cResidue_preserved` names the formal lift
input read off the square, not a substantive theorem.

## 10. Exact Lean ruling after the `52bde67` type audit

This section supersedes every earlier pre-flight clause in this file when
there is a conflict.

The A-specific functor is already completely present in Lean:

```lean
def AsectionActionDiagram (A : ASection) : GreatCircle.Base ⥤ Grpd where
  obj X := AsectionActionFiber A X
  map f := AsectionActionTransport A f
  map_id X := AsectionActionTransport_id A X
  map_comp f g := AsectionActionTransport_comp A f g

def AsectionActionTransport (A : ASection) (f : X ⟶ Y) :
    AsectionActionFiber A X ⟶ AsectionActionFiber A Y :=
  (orbitStabilizerActionSquare A f).actionStateTransport A
```

Therefore the following are definitional identities, not comparison
theorems:

```text
F_A(X) = AsectionActionFiber A X
F_A(f) = AsectionActionTransport A f
```

`AsectionActionTransport A f` already transports objects and morphisms and
already carries the input, positioned, value, `G₂`, projective, and
stabilizer faces. The `ι_A` checkpoint does not reconstruct or analyze any
of those faces. It restricts this exact existing functor to the author's
chosen preimage groupoids.

The accepted output types remain:

```lean
ASection.AsectionCResidueTransport A f :
  InverseImageCResidueStateWorldGroupoid A X ⥤
    InverseImageCResidueStateWorldGroupoid A Y

ASection.AsectionCResidueDiagram A :
  GreatCircle.Base ⥤ Grpd

ASection.AsectionCResidueInclusion A :
  AsectionCResidueDiagram A ⟶ AsectionActionDiagram A
```

The component and naturality data are:

```text
(ι_A)_X : 𝓡_A(X) ⥤ F_A(X)

𝓡_A(f) ⋙ (ι_A)_Y =
  (ι_A)_X ⋙ AsectionActionTransport A f.
```

The top arrow is literally the restriction of
`AsectionActionTransport A f`; `liftCompιIso` is the packaging receipt that
forgetting the restriction returns that same ambient functor. A formal
landing term required by `ObjectProperty.lift` is a receipt of the chosen
preimage construction, not an invitation to unfold or analyze the zero set.

### Status correction

Commit `52bde67` defines:

```lean
AsectionCResidueDiagram A :=
  (IsTotalCResidueState A).FullSubcategory

AsectionCResidueInclusion A :
  AsectionCResidueDiagram A ⥤ TotalActionStateWorld A
```

Those declarations are true generic total-level packaging. They are not the
natural transformation above: they contain no `𝓡_A(f)`, no componentwise
`ι_X`/`ι_Y`, and no naturality square against
`AsectionActionTransport A f`. Consequently `52bde67` is not the `ι_A`
certificate.

**The checkpoint is CLOSED at commit `57384ae` (2026-07-27 evening).** The
certified declarations are `AsectionCResidueTransport`,
`AsectionCResidueDiagram`, and `AsectionCResidueInclusion` at the ratified
types above, with naturality by `rfl`, all seven consumers instantiated at
free `X`, `Y`, `f` in `_GateCResidueDiagramAudit.lean`, and axiom surface
`[propext, Classical.choice, Quot.sound]` on all five declarations —
independently reproduced by a second auditor plus a deletion tripwire. The
next open gate is `Grothendieck.map ι_A` and the ladder in §7.

### Replacement pre-flight

Before the next edit, paste the live types—not remembered paraphrases—into
the register check:

```text
REGISTER CHECK
gate: A-specific natural restriction ι_A : 𝓡_A ⟶ F_A
target file: Concentricity/ASectionCResidueDiagram.lean
audit file: Concentricity/_GateCResidueDiagramAudit.lean
active theorem: ASection.AsectionCResidueInclusion A
mathematical provenance: the already-certified categorified
  orbit–stabilizer functor AsectionActionDiagram A
approved supplier: AsectionActionFiber, AsectionActionTransport,
  AsectionActionTransport_id/_comp, ObjectProperty.lift,
  fullyFaithfulι, liftCompιIso
instantiated A-specific object:
  F_A.obj X = AsectionActionFiber A X
  F_A.map f = AsectionActionTransport A f
intended proof term: restrict F_A.map f to Jesse's preimage fibres;
  assemble the restricted diagram; take the component inclusions and
  their definitional naturality square
```

The pre-flight passes only if the intended final declaration has literal
codomain `AsectionActionDiagram A`. A candidate with codomain
`TotalActionStateWorld A`, a generic full-subcategory inclusion, or an
essential-image construction detached from this exact A-specific functor
fails before editing.

The focused audit must consume, with free `X`, `Y`, and `f`:

```text
(AsectionActionDiagram A).obj X
(AsectionActionDiagram A).obj Y
(AsectionActionDiagram A).map f
InverseImageCResidueStateWorldGroupoid A X
InverseImageCResidueStateWorldGroupoid A Y
AsectionCResidueTransport A f
(AsectionCResidueInclusion A).app X
(AsectionCResidueInclusion A).app Y
(AsectionCResidueInclusion A).naturality f
```

It must also elaborate the literal
`positionedOrbitSquare A f (1 : Moebius)` as the native member of the
already-existing all-`d` family. That is a provenance receipt for the same
`AsectionActionTransport`, not a second action and not a separate proof.

No zero-set unfolding, coordinate calculation, invariance search, generic
total replacement, or essential-image detour is permitted in this
checkpoint. The kernel loop and two-file write set in §8 remain in force;
this section replaces only the registered term and acceptance criteria.
