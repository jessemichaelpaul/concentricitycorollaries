# Concentricity over the Octonions

This repository contains Jesse Michael Paul’s mathematical master,
`Octonionic_RH_master.tex`, and its Lean 4 formalization in `Concentricity/`.
The Lean library starts at `Concentricity.lean`.

It also contains Jesse’s [semantic harness](tools/semantic-harness/README.md),
a Haskell program developed for formalizing novel mathematics. The program
records the intended mathematical construction, checks whether a proposed
proof step follows it, and distinguishes a successful local build from a
dependency path that reaches the theorem. Its optional lifecycle adapter
uses the same policy during a local coding session.

The mathematical definitions, arguments, theorem statements, and exposition
are Jesse Michael Paul’s work. AI systems have assisted with proof engineering
and editing under his direction; they are not authors of the mathematics.

To check the sources locally, run `lake build Concentricity` for Lean and
`bash scripts/master.sh` for the manuscript. The Haskell guide gives its
separate build and test commands. A successful Lean build may still contain
unfinished proofs; the theorem’s axiom report is the final formal check.
