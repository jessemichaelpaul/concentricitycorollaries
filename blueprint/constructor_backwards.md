# The constructor used backwards — 2026-08-06, seventh instance

**What I did.** In a scratch file I built the two runs as

```lean
set k₁ := ASection.faceOfStabilizerPart r₁
set k₂ := ASection.faceOfStabilizerPart r₂
```

from residual factors `r₁ r₂` that nothing supplied, and the residual the
kernel then printed was

```
⊢ ∃ r₁ r₂ uStar, cayleyProjective r₁ uStar = (back xN.input).coordinate
               ∧ cayleyProjective r₂ uStar = (back yN.input).coordinate
```

which is `∃ rE rW uStar` with the subscripts changed — the old argument, sixth
re-derivation, recorded in `old_argument_audit.md` and `two_runs_defect.md`.
Having manufactured it, I then went to a file outside the seat's read surface
looking for a transitivity fact to satisfy it: a producer, one file over, for
an obligation I had just created.

**The inversion.** `faceOfStabilizerPart` (`Theorem.lean:514`) is the
constructor for when $r$ is **already in hand**: orbit--stabilizer gives
$k=o_N\,r\,o_0^{-1}$ and the factorization is the constructor. The author's
$r_i$ are `stabilizerPart(eulerToNorth_i)` — **read off the runs**. Using the
constructor in the other direction converts "where do the runs come from" into
"find two stabilizer elements", which is the producer hunt CLAUDE.md names as
the symptom, and it is `feedback-determined-not-produced` exactly.

**Where the wire was supposed to go.** The run is the tape:
`canonicalAsectionPresentation_euler_toNorth` (`ASectionFunctor.lean:1097`),
the square at instant `t` with base arrow `orbitHomToNorth X`, supplied at
every instant out of C2's Euler loop. Its type was read from the kernel and
then not used. `AsectionCResidueDiagram.lean:30` already names the link: one
family, two multipliers — `d = 1` for the inverse-image transport,
`d = diskExpAction (tape.lift t)` for the tape.

**What this says about `cc4a74d`.** `ASection.northComparison_of_boundaryReadings`
takes `k₁ k₂` and a shared `uStar` as bare hypotheses. The algebra inside it is
the master's — (S)+(B)+(P) ⟹ (I) by `inputEquation_of_boundaryReading`, (R) by
`stabilizerPart_comp`/`stabilizerPart_inv`, (Φ) by
`northFiberHom_of_coordinate` — but the statement does not say where the runs
came from, and that empty slot is what let the constructor-backwards move in.
Two subscripted runs with no tape behind them is the two-faces shape.

**Standing.** Do not build a run from a stabilizer part. The runs come from the
presentation; the residual factors are read off them.
