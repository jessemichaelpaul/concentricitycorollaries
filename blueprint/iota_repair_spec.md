# The ι repair — spec derived from live types

## ⭐⭐ THE LINE RUNS AT ι — author, 2026-08-05

> I **am** confident everything from hypotheses forward up to $\iota$ full and
> faithful was built correctly. Because I just forced you to use my hypotheses
> and objects that I built instead of generic ones. **I'm not confident what is
> above this is my stuff, probably not. Maybe some of it.**

- **Below the line — trusted.** Hypotheses → the residue subdiagram → the
  inclusion → full and faithful. Built with his objects. Do not re-audit it and
  do not "simplify" it.
- **Above the line — suspect.** The transitivity lemma and everything after.
  Possibly a paraphrase shaped like his argument rather than his argument.

**One confirmed instance already.** The existential inside
`northProducersConnectedAmbient` asks for two **state-indexed** stabilizer
parts, `rE`/`rW` attached to `x0`/`y0`. That is shaped like master (I), but his
$r_1,r_2$ are the residual factors of the two *runs* of one construction — not
data attached to states. The statement was never his, which is why it could not
be closed.

**Standing test above the line:** when a statement resists, first ask whether it
is the author's or someone's paraphrase of the author's — *before* trying to
prove it. That check is free and would have saved most of 2026-08-05.

## ⭐ THE CONNECTOR IS GREEN AND IN-REPO — 2026-08-05

The author: *"it is transitive on unit imaginary octonions (from that
functor)"*, and that is what **eats** the inverse-image C-residue locus.

```
G2.exists_smul_eq_of_mem_unitImaginarySphere :
  ∀ {u v : Octonion},
    u ∈ Octonion.unitImaginarySphere → v ∈ Octonion.unitImaginarySphere →
      ∃ g, g • u = v
depends on axioms: [propext, Classical.choice, Quot.sound]
```

Master `thm:G2-S6`, **proved in-repo** (`G2.lean:183`), closed against the P4.2
decomposition — extend both points to basic triples (P4.2.e), match the triples
(P4.2.f). Not an axiom, not a citation.

It is **already consumed** at `SliceSphereWorld.lean:284`:

```lean
theorem sphereWorld_zigzag (I J : SphereWorld) : CategoryTheory.Zigzag I J := by
  obtain ⟨g, hg⟩ := G2.exists_smul_eq_of_mem_unitImaginarySphere I.prop J.prop
  exact CategoryTheory.Zigzag.of_hom (dirHomTo g hg)
```

**Any two sphere worlds are joined by a direction morphism built straight from
the G₂ element.** That is the "connected because of G₂" of master (Φ), and it is
a named green declaration — nothing to construct.

Why this is the whole point, in the author's words: $F_A$ **sweeps the slice**;
the direction $I$ ranges over $S^6$ and $G_2$ carries it; $D_A$ positions the
coordinate in the slice it selects; $A_{\OO}$ realizes the value.
`residueActionState_positioned` shows a residue state is indexed by exactly
$(n, I)$ — zero index and direction. **$G_2$ transitive on the unit imaginary
octonions is why $\int\mathcal R_A$ is transitive while the ambient is not**,
and it is why this is a constructible proof rather than a search.

**Care note:** the transitivity lemma as currently written is repetitive and
carries too much. Simplifying it means routing through this connector rather
than through the relative-loop apparatus. Do not discard the working parts
while doing so — `northProducersConnected` (fullness) and
`northMembersConnected` (arbitrary members) are already built.

## ⛔ FIRST: "EMPTY" IS WITHDRAWN — 2026-08-05

This file repeatedly characterised parts of the construction as empty, hollow,
or contributing nothing. **That word was mine, it came from a code report, and
it is withdrawn.** It was never a statement about the mathematics and there was
no basis for it.

What is actually true is narrow and local: **one line in one Lean proof** —
`hprovenance : X = X` in `cResidue_lands` (`ASectionCResidueDiagram.lean:67`) —
is trivial. That is a fact about how that one proof was written. It says
nothing whatever about:

- **Euler-to-North.** `canonicalAsectionPresentation_euler_toNorth` carries the
  complete prime tape to the common north frame at every instant.
- **GPV unique winding.** The lift is unique and the winding is fixed; that is
  what pins the tape.
- **The commuting dictionary**
  $$z \;\longmapsto\; e^{z}\in\mathbb C^{\times} \;\longmapsto\;
    M(z)=\operatorname{diag}(e^{z},1) \;\longmapsto\; D(z)\in\mathrm{M\ddot ob}(\mathbb C^{*})$$
  through $C(-)C^{-1}$. The common Euler–Weierstrass multiplier is followed
  directly through it. **It is a commuting square, and its input is now the
  C-residue locus.**

None of those is empty. Read every later section of this file with that
correction in force, and do not repeat the word.

Codex's diagnosis is confirmed against source. This file records what the
kernel already has, what is missing, and the exact chain that closes seat 1.
Every line cites file:line.

## Confirmed: the faces never entered

`ASectionCResidueInverseImage.lean:48–54`

```lean
def IsNorthCResidueState (A : ASection) :
    ObjectProperty (AsectionActionFiber A projectiveNorth) :=
  fun x =>
    x ∈ (fun y => y.positioned.back.coordinate) ⁻¹'
          ((fun z : ℂ => (z : OnePoint ℂ)) '' A.CResidueZeroLocus)
```

Residue-locus membership of the **positioned** coordinate. No face, no tape,
no common input.

Its own docstring, `:43–47`, says the opposite: *"the frame at which
`projectiveObjectFrame A` is `distinguishedDiskAction A`, **holding both fixed
faces, so this fibre carries the whole `0`-to-`N` core rather than a point**."*
**The docstring names what the definition dropped.** That is why every session
loops: an agent reads it, destructures, finds four components, and concludes
its own lookup failed — which `EndgameFinal.md:42–48` then confirms for it.

`ASectionCResidueDiagram.lean:67–71` — the square cancels itself:

```lean
have hprovenance :
    (AsectionActionTransport A f).obj x.obj =
      (AsectionActionTransport A f).obj x.obj := by
  rw [← htransport, htransport]
```

`squareAtOne`, `hsquare`, `htransport` are built at `:27–49` and consumed only
here, into `X = X`. The witness is `g ≫ f` (`:55`).

## The chain that closes seat 1 — all of it already green

`Theorem.lean:554` builds a face **from** its residual factor, out of the
common projective zero frame:

```lean
def ASection.faceOfStabilizerPart (r : GreatCircle.NorthStabilizer) :
    GreatCircle.pointObj ((0 : ℝ) : GreatCircle.Point) ⟶ ASection.projectiveNorth
```

`Theorem.lean:568` — `stabilizerPart (faceOfStabilizerPart r) = r`, master (R)
uniqueness.

`Theorem.lean:647` — the comparison, stated on the residual factors themselves:

```lean
theorem ASection.northComparison_of_residualFactors (A : ASection)
    (rE rW : GreatCircle.NorthStabilizer)
    (xN yN : A.AsectionActionFiber ASection.projectiveNorth)
    (uStar : OnePoint ℂ)
    (hE : (GreatCircle.cayleyProjective rE.1).val uStar = xN.input.back.coordinate)
    (hW : (GreatCircle.cayleyProjective rW.1).val uStar = yN.input.back.coordinate) :
    Nonempty ((A.AsectionActionTransport
        (CategoryTheory.Groupoid.inv (ASection.faceOfStabilizerPart rE)
          ≫ ASection.faceOfStabilizerPart rW)).obj xN ⟶ yN)
```

Its conclusion is **type-identical** to the seat's existential at
`Theorem.lean:1029–1031`, with

```lean
k := Groupoid.inv (faceOfStabilizerPart rE) ≫ faceOfStabilizerPart rW
```

which has type `projectiveNorth ⟶ projectiveNorth` because both faces leave
`pointObj 0`. Nothing has to be constructed at the seat.

## The single missing datum

`northComparison_of_residualFactors` needs `rE`, `rW`, and `hE`, `hW` **at one
shared `uStar`**. `grep -rn uStar Concentricity/*.lean` returns only bound
variables inside lemma statements — `uStar` is never data of `A` and never data
of a state.

So the missing content of `IsNorthCResidueState` is exactly master (I):

> each north residue state's input coordinate lies in the north-stabilizer
> orbit of the one common tape input `u_*`

i.e. the predicate must additionally carry

```lean
∃ r : GreatCircle.NorthStabilizer,
  (GreatCircle.cayleyProjective r.1).val uStar = x.input.back.coordinate
```

Per-state existential quantification of `uStar` does **not** work: `xN` and
`yN` would supply different inputs and the comparison would not apply. The
shared input is the mathematical content, and it is what was dropped.

## Where `uStar` lives — corrected by the author, 2026-08-05

My first reading (read it off a "common source object") was wrong. The author
pointed at the type name, and the type settles it.

`ASectionFunctor.lean:726` — `toNorth` is a **field** of
`AsectionPresentation`, not something to be built:

```lean
toNorth : ∀ δ hp hne (t : unitInterval),
    ActionTransportSquare
      (positionedLiftAction A X (gpv δ hp hne) t)
      (positionedLiftAction A projectiveNorth (gpv δ hp hne) t)
```

**This is master (S).** A commuting action square, verticals = the frame at `X`
and the frame at north, supplied for every instant `t` of every lift `δ`.
`ASectionFunctor.lean:1097`, `canonicalAsectionPresentation_euler_toNorth`, is
the same square on the Euler half-space loop, carrying the complete prime tape
(`euler_gpv : GpvTransport A B B 0`, winding `k = 0` by `δ 0 = δ 1`).

Both are `positionedOrbitSquare A (orbitHomToNorth X) d`. From the `change` at
`ASectionCResidueDiagram.lean:38–43`, that square's input leg is

```
d⁻¹ * cayleyProjective (stabilizerPart f).1 * d
```

so at multiplier `d = 1` the input leg is literally `C(r_f)` — the master's
`R_•`. In `euler_toNorth`, `d = diskExpAction (tape.lift t)`: the input leg is
`C(r)` conjugated by the lift's own value at instant `t`.

So `uStar` is **not** a new parameter and **not** read off a source object. It
is the input coordinate at instant `t` of the Euler tape, and `toNorth` is what
carries it to north. The common source frame of the master is the square's left
vertical; the tape is `δ`.

`Theorem.lean:583–590` already performs the master's cancellation on such a
square:

```lean
(hB : sq.left.val (S.val uStar) = D.val u) : sq.right.val uStar = u
```

That is (S) + (B) ⟹ (I), green, on the square's own legs.

### Why there is no `weierstrass_toNorth`

C1 identifies both presentations with the continued factor `g_A`, and the
Weierstrass divisor is exact at `N` — the point at which the two presentations
are *the same function* (master, the pole-datum paragraph). So one square at
north carries both boundary presentations. `euler_toNorth` is not the Euler
half of a missing pair; it is that identification.

### What this leaves

The faces are in the encoding. What `IsNorthCResidueState` still fails to
retain is the **connection** between its selected output and the square that
produced it: the predicate names a residue-locus coordinate and forgets which
instant of which tape it came from. The repair is to have the north predicate
carry (or be defined through) the `toNorth` square at the instant that produced
its coordinate — then `rE`, `rW`, `uStar`, `hE`, `hW` are projections of that
square, exactly as Codex says, and `northComparison_of_residualFactors` closes
the seat.

## KERNEL RECEIPT — conditional, and stated as such, 2026-08-05

Typed and run, not argued. `lake build Concentricity.Theorem` completed (3657
jobs), with `sorry` warnings at `Theorem.lean:1023` and `:1065`. Then:

```lean
def IsNorthCResidueState' (A : ASection) (uStar : OnePoint ℂ) :
    ObjectProperty (A.AsectionActionFiber ASection.projectiveNorth) :=
  fun x =>
    ASection.IsNorthCResidueState A x ∧
      ∃ r : GreatCircle.NorthStabilizer,
        (GreatCircle.cayleyProjective r.1).val uStar = x.input.back.coordinate

theorem seat_closes_from_strengthened_predicate
    (A : ASection) (uStar : OnePoint ℂ)
    (xN yN : A.AsectionActionFiber ASection.projectiveNorth)
    (hx : IsNorthCResidueState' A uStar xN)
    (hy : IsNorthCResidueState' A uStar yN) :
    ∃ k : ASection.projectiveNorth ⟶ ASection.projectiveNorth,
      Nonempty ((A.AsectionActionTransport k).obj xN ⟶ yN) := by
  obtain ⟨-, rE, hE⟩ := hx
  obtain ⟨-, rW, hW⟩ := hy
  exact ⟨_, A.northComparison_of_residualFactors rE rW xN yN uStar hE hW⟩
```

```text
'seat_closes_from_strengthened_predicate' depends on axioms:
  [propext, Classical.choice, Quot.sound]
```

**What this declaration certifies, and what its chain does not.** The
declaration `seat_closes_from_strengthened_predicate` certifies its literal
type on the three standard axioms: *given* `hx` and `hy`, the seat's existential
follows by two destructures and one instantiation. Its chain takes `hx` and
`hy` as **hypotheses that are assumed, never discharged** — so this declaration
says nothing about whether any north residue state satisfies
`IsNorthCResidueState'`, and it does not close `Theorem.lean:1023` or `:1065`,
both of which remain `sorry` in the live build.

What it does establish is the shape of the repair: no coordinate construction
and no new mathematics are needed at the seat itself. The comparison
(`Theorem.lean:647`), the face constructor (`:554`), the uniqueness of the
residual factor (`:568`), the cancellation (`:583`), and the total morphism are
each already green on their own types.

### Remaining work, now bounded

1. Land the strengthened predicate at
   `ASectionCResidueInverseImage.lean:48`.
2. **Discharge it** where north residue states are produced. This is the one
   real obligation left, and it is the one the probe above deliberately did not
   touch.
3. Only after (2) does `Theorem.lean:1023` close by the three lines above.

### Step 2, stated correctly — author's correction, 2026-08-05

A first attempt at (2) proved a lemma quantified over *every* state of the
whole action fibre and *every* base arrow into north, with no residue locus in
it at all. The author rejected it, correctly. That statement is
`AsectionActionTransport_obj_input` restated at the coordinate level — the
functoriality of the coordinate action — and it ties nothing to the tape and
nothing to the residue selection. Worse, it lets `xN` and `yN` each bring their
own source, which is the same defect this whole file is about, reappearing one
level up because a generic object was substituted for the author's.

**The sharing is the content.** The inverse-image action groupoid was built
over the C-residues, so the source and the faces come from that construction
rather than being universally quantified. The statement is:

- `xN`, `yN` with `IsNorthCResidueState A xN` and `IsNorthCResidueState A yN`
  as **hypotheses**;
- **one** source on the fixed tape, supplying a single `u_*` to both;
- `k_E`, `k_W` the two boundary presentations out of that one source;
- conclusion: the two readings at that one `u_*`.

Typed check: that statement elaborates over the locus, and
`A.residueState_graph xN hx` destructures inside it — so the shape is
well-formed against the live types. It is not proved; the sharing is exactly
what is left.

Per the author, fullness and faithfulness of `ι_A` are what supply the sharing,
and both are built — master: *"Since `ι_A` is full, it has a preimage in the
residue total; faithfulness makes that preimage unique."* That is the next
place to look, and the standing rule applies: everything is in Lean and proved;
what fails is wiring, dropped, or orphaned — so look before writing.

## ⛔⛔ "BOUNDARY READINGS" IS OVERLOADED IN THE MASTER — 2026-08-05

`grep -n "boundary reading" Octonionic_RH_master.tex` returns exactly two hits,
and they denote **different things**:

- **`:1147`** — *"The Euler expression at $0$ and the Weierstrass expression at
  $N$ are consequently the two boundary readings of this one matrix-built
  function."* These are the two **fixed points** of $D_A$:
  $D_A(0)=0$ and $D_A(N)=N$, i.e.
  `distinguishedDiskAction_fixes_cayley_zero` and
  `distinguishedDiskAction_fixes_cayley_N`. **Both already green**, both already
  true of $D_A$, nothing to supply.
- **`:1642`** — *"The C3 boundary readings identify the corresponding positioned
  outputs"* — the authored coordinates $z_1,z_2$ of two given states.

Every time the author said "boundary reading" this session, I resolved it to
`:1642` and went looking for per-state data, a fixed tape, a δ, and a
north-stabilizer transitivity lemma. **He meant `:1147`, which is already
proved.** There is no supplier to find, because the facts are facts about the
one matrix-built function, not about the states.

There are also not two faces *at* $N$. C1 continues $g_A$ through the pole and
the Weierstrass divisor is exact at $N$, so at $N$ the two expressions are the
**same function**; the two readings are at $0$ and at $N$, the two fixed points.
The faces $k_E,k_W$ are transports $0\to N$, not two objects sitting at $N$.

Author, on the square: *"At every instant the square
`canonicalAsectionPresentation_euler_toNorth`"* — it holds at every instant, so
no distinguished instant needs choosing either.

**Disambiguating `:1147` vs `:1642` in the master is the highest-value prose
fix remaining.** It is the exact kind of ambiguity this session was opened to
remove, and it cost this session four wrong routes.

## ⛔ THE REPAIR DIRECTION ABOVE IS WRONG — author, 2026-08-05

Everything above that proposes **strengthening `IsNorthCResidueState` to carry
a face** is misconceived. The author's correction, exact:

> Of course it doesn't retain a boundary face. It's a preimage.

A preimage does not store the map that produced its elements. The faces are
**applied**, not retained. Storing them would put data on an object property
whose entire job is selection.

### How the faces actually enter

1. **`AsectionState_input_then_equivariant`** (`ASectionFunctor.lean:352`,
   green, proved by `Functor.ext` on *both* components):
   ```lean
   AsectionStateInput A ⋙ A.AsectionEquivariant = AsectionStateOutput A
   ```
   It holds on arrows as well as objects, so the normalized input coordinates
   genuinely drive the realized A-values.
2. That composite's result carries the preimage property — the zero-locus
   selection at `:48`.
3. **`canonicalAsectionPresentation_euler_toNorth`** (`:1097`) carries the
   complete prime tape to the common north frame **at every instant**. C3
   supplies the Weierstrass boundary presentation there; C1 identifies both
   presentations with the continued factor `g_A`.
4. Sweeping the constrained graph through the base gives the A-section functor
   `AsectionActionDiagram A` (master `A_A : B ⥤ Grpd`).
5. The fibrewise inverse image is witness (W) — `IsCResidueState A X` — and
   `ι_{A,X}` is full and faithful by (H).
6. Transport is (C), recorded by `cResidue_lands`; naturality is (Nat)/(Inc);
   the total inclusion is `AsectionCResidueInclusionTotal`, with
   `_full` and `_faithful`.

**So the `sorry` in `northProducersConnectedAmbient` should be discharged by
applying the `euler_toNorth` square at the instant, not by adding a field to
the predicate.** The face is available because `toNorth` is supplied at every
instant; nothing needs to be remembered by the state.

Every "strengthen the predicate" probe recorded above therefore tests the wrong
design. They are kept only because their kernel receipts are honest about what
they assumed — not because the design is right.

### An invalid inference of mine, retracted 2026-08-05

I proved a coordinate lemma with `IsNorthCResidueState` as a hypothesis, then
proved the same conclusion with **no** residue hypothesis and an arbitrary base
object, and concluded the residue hypothesis was "decoration."

**That does not follow.** A strictly weaker statement also being provable says
only that my lemma's hypotheses were non-minimal. It says nothing about whether
the residue structure is load-bearing in the argument — and the argument is
about `∫𝓡_A`, which **is** a total C-residue system: `P.fiber.property` gives
`IsCResidueState A P.base P.fiber.obj` for *every* object, by construction
(checked: the `example` elaborates). The residue condition is not a hypothesis
one chooses to add; it is what the objects are.

The move was the generic-object substitution again, in a new costume: prove
something about a surrogate, then transfer a property of the surrogate
("hypothesis unused") back onto the author's object. Nothing about a generic
fibre transfers to `∫𝓡_A`.

It also inverted the logic. I said the open thing was "a production fact" and
that the residue hypothesis was idle — when **being a C-residue state is that
production fact**.

### Where north residue states come from — the author, 2026-08-05

There is no separate producer to hunt. The population is the preimage itself:

- `:48` selects at north — a state is a north residue state exactly when its
  positioned back-coordinate lies in `CResidueZeroLocus`, which C4 makes
  nonempty;
- `:60` spreads those over the base along `g`.

So `IsNorthCResidueState` is not missing a **constructor**. It is missing
**retention**: the selection records that the coordinate is an authored C3
zero and forgets the boundary face of the distinguished action that evaluates
there. Per the master, that face is what C3 supplies, together with the precise
inputs — `residueState_graph` already delivers the index `n` and, with
`projectiveObjectFrame_north`, the input `u = D_A⁻¹ z_n`.

Note also that `r_E`, `r_W` are **not per-state data**: master `(R)` makes them
the stabilizer parts of the two boundary faces of the *one* fixed tape, with
`u_*` the common source input. The states' inputs are the images of `u_*` under
those two faces. Any encoding that lets each state carry its own face or its
own input has already lost the statement.

### Locus facts confirmed from source

- `ASectionCResidue.lean:26` — `CResidueZeroLocus A = {z | A.F z = 0 ∧ 0 < z.im}`
- `:52` — `CResidueZeroLocus_eq_range : = Set.range A.sphereZero`
- `:58` — `CResidueZeroLocus_infinite`, from `c4_infinite` (`ASection.lean:189`)
- `:12` — the locus *"does not form an inverse-image groupoid"*, which is why
  the preimage is taken; the locus is semantic and C4 makes it nonempty.

Step 2 is where the two fixed-point theorems earn their place. The kernel gives
their types as `D_A (cayleyCoord 0) = cayleyCoord 0` and
`D_A (cayleyCoord ∞) = cayleyCoord ∞`, with
`projectiveObjectFrame_north : projectiveObjectFrame A (pointObj ∞) = distinguishedDiskAction A` —
which is the header's claim at `:22` that the element holds both boundary
faces, Euler presenting at `0` and Weierstrass at `N`.
