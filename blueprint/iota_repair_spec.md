# The ι repair — spec derived from live types

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
