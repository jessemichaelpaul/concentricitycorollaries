<!-- BEGIN KERNEL GROUND TRUTH PROVENANCE -->
# Kernel Ground Truth Provenance protocol

This project is instantiated for verifier-grounded formalization. The author
controls mathematical meaning and authored-object identity. Lean controls term
acceptance and axiom surfaces. The model performs spelling, instantiation, and
wiring. A theorem's fame, expected difficulty, or downstream consequence has
zero evidentiary weight at a local Lean seat.

## Monotone evidence order

Use only this order:

1. the ratified master and its authored-object anchors;
2. the read-only authored-binding registry and current project receipts;
3. the exact authored expression at its exact production seat;
4. Lean's literal response;
5. the production/root builds and literal axiom prints;
6. the matching committed source, readable ledger, and verified remote commit.

A certified supporting inference is settled. A later binding or wiring problem
cannot reopen it as mathematics. A timeout is an operational event only.

## Mandatory authored-binding queue

Run `python3 tools/receipt_import.py --require-ready`. Every
`AUTHOR_BOUND_LEAN_PENDING` or legacy `BINDING_UNRESOLVED` row is mandatory
transcription work. It is never grounds to stop, refuse, request that the author
restate the proof, or substitute a generic object.

The receipt producer has no authority to declare author confirmation. Its
paper object, dependent type, production seat, local name, template, and exact
ratified expression must match `.provenance/author_bindings.json`. A same-typed
term selected from another library cannot replace that expression.

Before each binding edit, record:

```text
TARGET DECLARATION:
AUTHOR BINDING ID:
PROJECT-SPECIFIC OBJECTS:
EXPECTED TYPE:
PRODUCTION SOURCE AND SEAT:
ROLE: declaration | instantiation | wiring
EXACT TERM TO ATTEMPT:
```

Then place that exact term and contact Lean immediately. Before the first exact
attempt, operations are limited to reading the seat, searching the active
project for the named suppliers, and printing their live types. Afterward only
Lean's literal elaborator output may direct spelling, implicit-argument,
coercion, orientation, reassociation, normalization, and packaging repairs.

Do not invent a replacement group element, functor, morphism, carrier, theorem,
representative, or generic analogue. Do not search a second project for a
substitute. Absence of a convenient exported name is a declaration or packaging
task. If a spelling remains unresolved after the project-specific search and
live type checks, report only:

```text
UNRESOLVED LEAN SPELLING:
EXPECTED TYPE:
SEARCHED PROJECT-SPECIFIC NAMES:
```

That report carries no mathematical conclusion. `EXACT_CONSTRUCTION_REJECTED`
is available only when the author-confirmed exact expression was centrally
reprobed at its own seat and the receipt quotes Lean's literal diagnostic.

## Completion and publication

Completion requires every authored binding ready, every configured production
and root build green, the current readable ledger, and the author-configured
literal axiom surface for every release target. Run
`python3 tools/release_gate.py` for that certificate. Raw `git push` is disabled;
run `python3 tools/verified_push.py`, which may report success only when the
author-configured remote branch resolves to the exact certified commit.
<!-- END KERNEL GROUND TRUTH PROVENANCE -->
