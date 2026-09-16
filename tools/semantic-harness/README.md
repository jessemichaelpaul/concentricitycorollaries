# Semantic harness for novel mathematics

This Haskell program was developed by Jesse Michael Paul during the Lean 4
formalization of his Concentricity Theorem. It addresses a recurring problem
in formalizing a new argument: a proof assistant can accept a term at a type
even when the chosen type or construction differs from the author’s intended
mathematics. The harness records the intended objects, arrows, hypotheses,
and proof order alongside the evidence that a Lean declaration actually
checks and reaches the public theorem.

The repository includes two layers:

1. `SemanticHarness.hs` is a policy and assessment library. It describes the
   Concentricity construction as an ordered path, classifies proposed
   techniques by their mathematical effect, routes implementation problems
   to suitable work, and checks candidate manifests against the current
   policy. It allows implementation experiments while quarantining changes
   to authored mathematical meaning.
2. `CodexHook.hs` and `MiniJson.hs` form an optional local lifecycle adapter.
   The adapter reloads an author contract, preserves prompts and transcripts
   in private local state, and checks proposed production edits against the
   active task scope. `HookMain.hs` is its executable entry point.

The harness separates authorial meaning, task authorization, Lean kernel
evidence, and production reachability. A local Lean build is useful evidence;
it counts toward the theorem only when the checked declaration is used by
the intended production dependency path. A manifest can claim a build or
review receipt, but the current public CLI cannot mint a trusted receipt or
promote that claim to a release certificate.

A known open goal is work to implement, not evidence against the authored
argument. The `known-open-goal`, `interface-mismatch`, and
`missing-lean-implementation` routes point to the next edit on the live
production path. A failed Lean term calls for its exact expected and actual
types and a concrete interface repair. The optional adapter injects this
instruction into local task context; it does not inspect assistant prose or
add a new pause gate.

## Files

- `SemanticHarness.hs`, `Main.hs`, `Spec.hs`: policy library, CLI, and tests.
- `CodexHook.hs`, `MiniJson.hs`, `HookMain.hs`, `HookSpec.hs`: optional lifecycle
  adapter, JSON parser, entry point, and tests.
- `semantic-harness.cabal`: package definition.
- `examples/`: illustrative manifests for an allowed slice action and a
  rejected shared-base substitution.

Private author interviews, conversation logs, task contracts, and local hook
configuration are kept outside this public source. The adapter needs that
local configuration before it can govern a coding session; the policy CLI
and tests can be built from the files here.

## Build and test

With GHC available, from this directory:

```sh
mkdir -p /tmp/concentricity-harness-core
ghc -O2 -Wall -outputdir /tmp/concentricity-harness-core \
  -i. Main.hs -o /tmp/concentricity-harness-core/semantic-harness
ghc -O0 -Wall -outputdir /tmp/concentricity-harness-core \
  -i. Spec.hs -o /tmp/concentricity-harness-core/spec
/tmp/concentricity-harness-core/spec

mkdir -p /tmp/concentricity-harness-hook
ghc -O0 -Wall -outputdir /tmp/concentricity-harness-hook \
  -i. HookSpec.hs -o /tmp/concentricity-harness-hook/hook-spec
/tmp/concentricity-harness-hook/hook-spec
```

The command line program accepts:

```text
semantic-harness policy
semantic-harness route known-open-goal
semantic-harness route <signal>
semantic-harness lint <candidate.manifest>
semantic-harness assess <candidate.manifest>
```

`lint` checks whether a proposal respects the policy while reporting any
missing evidence. `assess` exits successfully only for candidates eligible
for production or release. With the current manifest interface, hand-written
evidence remains unverified, so a manifest alone cannot pass `assess`.
