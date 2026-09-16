# Semantic Harness

This directory contains two connected Haskell layers:

- a typed policy core for routing Lean work and assessing promotion into the
  Concentricity production dependency path;
- a repo-local Codex lifecycle adapter that injects the current author
  contract, saves conversation history, preserves context across compaction,
  and denies known semantic substitutions before a production tool runs.

Conversation, read-only inspection, and ordinary implementation-level Lean
experiments remain open. The adapter constrains mutations: it binds production
editing to the finalized active node, protects author and governance state,
disables mathematical delegation, and turns a real semantic mismatch into an
explain-back request rather than an agent-authored replacement proof.

The design separates questions that the retired claim validator merged:

1. **Semantic authority:** does the construction follow Jesse's current
   corrections and the master?
2. **Frozen-plan conformance:** is the worker executing the assigned plan node
   without rewriting the plan to fit its proof?
3. **Operational authority:** did the current task actually authorize this
   delegation, file mutation, cleanup, or master/governance edit?
4. **Kernel evidence:** does the exact term elaborate and build against the
   current source?
5. **Production reachability:** does the checked declaration actually reach
   `ASection.concentricity` through the intended dependency path?

## Binding mathematical distinction

Orbit-stabilizer is required. The A-specific functors are coordinate-free
matrix group actions, except for the G2 automorphism component. Well-definedness
of the slice-preserving exponential group action also requires the Part 2 GPV
lemmas and propositions, especially uniqueness.

The quarantined construction is the separate north-point implementation:
coordinates, a chosen N-frame or representative, and an object-position
matrix. Removing or rewriting orbit-stabilizer itself is denied.

## Known open goals and Lean errors

The live `sorry` and the frame dependency in the indexed action diagram are
assigned implementation work. Repeating that they remain open does not change
the mathematical route. `known-open-goal`, `interface-mismatch`, and
`missing-lean-implementation` now route to the next edit on the production
dependency path. When a proposed Lean term fails, the useful report gives its
expected and actual types and the next interface repair while preserving the
GPV-derived matrix action, orbit--stabilizer, and original evaluation.

The lifecycle adapter also injects this instruction into task context. For an
explicit formalization turn, the Stop hook now checks whether the task actually
changed production Lean code. If it only reports the known gap, writes a
provenance note, runs an unchanged build, or edits a comment, Codex receives
one concrete continuation at the indexed action diagram. The check is scoped
to that task's turn and stops retrying when Codex sets `stop_hook_active`.

## Build, install, and test

From this directory:

    mkdir -p /tmp/concentricity-harness-core
    ghc -O2 -Wall -outputdir /tmp/concentricity-harness-core \
      -i. Main.hs -o /tmp/concentricity-harness-core/semantic-harness
    ghc -O0 -Wall -outputdir /tmp/concentricity-harness-core \
      -i. Spec.hs -o /tmp/concentricity-harness-core/spec
    /tmp/concentricity-harness-core/spec

Build the Codex adapter in its separate output directory because both test
programs have a Main module:

    mkdir -p /tmp/concentricity-harness-hook
    mkdir -p ../../.local/semantic-harness/bin
    ghc -O2 -Wall -outputdir /tmp/concentricity-harness-hook \
      -i. HookMain.hs \
      -o ../../.local/semantic-harness/bin/semantic-harness-hook

    mkdir -p /tmp/concentricity-harness-hook-test
    ghc -O0 -Wall -outputdir /tmp/concentricity-harness-hook-test \
      -i. HookSpec.hs -o /tmp/concentricity-harness-hook-test/hook-spec
    /tmp/concentricity-harness-hook-test/hook-spec

The repository hook definition is .codex/hooks.json and the hooks feature is
enabled in .codex/config.toml. Codex requires the user to review and trust the
exact project-local hook hash through /hooks. A changed hook remains skipped
until it is reviewed again.

## Codex lifecycle behavior

- SessionStart reloads the compact current context, finalized task contract,
  and curated prior-task anchors after startup, resume, clear, or compaction.
- UserPromptSubmit appends the exact user prompt to
  .local/semantic-harness/conversation-history.jsonl and retains it by session
  and turn. Protected-edit authorization reads that turn's prompt, so another
  active task cannot replace it.
- PreCompact refuses to compact if the current GPV/orbit author contract is
  missing or stale, and archives the available raw transcript.
- PreToolUse blocks known rejected production patterns, edits outside the
  active node, deletion of orbit-stabilizer, unauthorized protected-state
  edits, destructive shell bypasses, and mathematical agent delegation.
- PostToolUse compares production Lean code before and after an allowed patch.
  Comment-only changes and rejected patches do not count as implementation.
- Stop gives an explicit formalization turn one continuation when no production
  Lean code edit occurred. Audit, status, and Haskell maintenance turns are
  outside this check; a genuine source conflict may still be explained.
- SessionEnd archives the raw local transcript when Codex supplies its path.

The Stop hook is bounded to one continuation to avoid a retry loop. It detects
the specific premature finish in which a formalization task makes no production
Lean code edit. It cannot establish that an attempted edit follows the master
or closes the theorem; source review and the Lean kernel remain necessary.

An approved transition can temporarily list an
`approved-protected-path` in the task contract. This records Jesse's visible
authorization durably, so a multi-step master or governance update does not
depend on keyword matching against each follow-up message. Frozen paths still
take precedence and must be explicitly unfrozen for the transition; after the
approved work is verified, the path is removed from the approval list and
frozen again.

The orbit-stabilizer guard evaluates the semantic replacement rather than a
bare deleted line. It permits replacing the obsolete north-stabilizer prose
only when the new production text positively retains GPV uniqueness, the
matrix group action, orbit-stabilizer, and the input's actual sphere. Known
quarantined additions are checked first and remain denied.

Hook coverage is a strong workflow guardrail, not a security boundary. Codex
documents that some specialized tool paths may bypass ordinary tool hooks.
Release still requires source review, dependency reachability, a full Lean
build, escape-hatch checks, and the axiom audit.

## Commands

```sh
semantic-harness policy
semantic-harness route known-open-goal
semantic-harness route interface-mismatch
semantic-harness route candidate-kernel-green
semantic-harness route plan-node-ready
semantic-harness route plan-drift-detected
semantic-harness route master-edit-proposed
semantic-harness route stop-requested
semantic-harness lint examples/slice-action.valid.manifest
semantic-harness assess examples/common-beta.rejected.manifest
```

`lint` exits successfully when the semantic policy is clear even if verified
evidence is not yet available. `assess` exits successfully only for
`production-eligible` or `release-eligible` candidates. In the present version,
no public API can create the adapter-verified receipts required for those
states, so a hand-authored manifest cannot promote itself.

## Technique quarantine

Known authored and retired techniques are recorded in `concentricityPolicy`.
Manifest entries have three forms:

- `technique=<registered-name>` uses the project policy;
- `technique=impl:<name>` is an unregistered implementation move and remains
  allowed under ordinary review;
- `technique=semantic:<name>` is an unapproved semantic move and is confined to
  scratch work until it receives an author or master anchor.

This is the implementation of “semantic fidelity, implementation
flexibility”: the harness does not blacklist unfamiliar Lean tactics, but it
does prevent a compiling agent proposal from silently changing the carrier,
arrows, hypotheses, or proof order.

## Freshness and corrections

Every receipt carries a source fingerprint, semantic-policy revision, and
frozen-plan revision. A source edit invalidates the first; a new author
correction invalidates the second; an approved plan amendment invalidates the
third. The current reference revisions are
`A-2026-09-14-043/gpv-orbit-author-route-v1` and
`CONCENTRICITY_EXECUTION_PLAN/checkpoints-1-5/A-2026-09-14-043`.

A correct explain-back is semantic evidence only. It does not authorize an
agent, master edit, governance edit, cleanup, revert, or production promotion.
The routing table treats those as separate operational proposals. A stop signal
suggests only cancellation and withholds every write capability.

The example receipts are illustrative only and are internally marked
`ManifestDeclared`. They are reported but never counted toward promotion. A
production adapter must mint opaque receipts from fixed, structured commands
and exact outputs. A separate trusted task-scope adapter must bind work to the
current user request, exact writable targets, delegation policy, and frozen
plan node. The intended evidence adapters are:

- a focused Lean build/elaboration adapter;
- a source-aware, read-only fidelity review adapter;
- a transitive production dependency adapter;
- release adapters for full build, escape hatches, axiom surface, master sync,
  and, as optional hardening unless adopted into the release contract,
  independent kernel replay/comparator.

The policy core never executes arbitrary shell text.  This removes the command
injection and substring-matching weaknesses of the retired `KernelPrint`
constructor.
