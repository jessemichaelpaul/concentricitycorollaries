# PROVENANCE.md — Semantic fidelity without behavioral gates

## Purpose

Provenance exists to keep the Lean formalization faithful to Jesse Michael
Paul’s mathematics. It does not exist to restrict conversation, force models
through rituals, or replace mathematical judgment with registries.

The lightweight rule is:

> Preserve the authored semantics; verify formal claims with fresh Lean
> evidence.

## Authorship and reuse

This workflow was conceived and developed by Jesse Michael Paul during the
Concentricity project, in response to recurring semantic drift while
formalizing a novel mathematical argument with AI assistance. This document
is intended to let other researchers adapt the method when an argument is
unfamiliar to the assisting model or poorly represented in its training
context, or when the reputation or cultural framing of a downstream result may
bias work on an upstream theorem.

AI systems may assist with proof engineering and editorial implementation;
that assistance does not make them authors or coauthors of the mathematics or
of the research program they are helping to formalize.

## Division of responsibility

Jesse and `Octonionic_RH_master.tex` govern:

- the mathematical objects and their intended meanings;
- which hypotheses belong to the theorem;
- the direction and order of the argument;
- whether a Lean representation faithfully expresses the novel construction;
- authorship of the mathematical ideas.

The Lean kernel governs:

- whether declarations elaborate;
- which formal declarations and hypotheses the submitted term actually uses;
- which axioms a declaration uses.

Jesse and the master determine whether those formal dependencies are
semantically sufficient for the intended mathematics.

The assisting model governs:

- Lean syntax and proof engineering;
- discovery of existing definitions and lemmas;
- temporary probes and implementation experiments;
- local helper lemmas and refactors that preserve the authored semantics;
- clear reporting of evidence, uncertainty, and remaining work.

No automatic ownership registry, binding manifest, claim ratification, turn
counter, read gate, save gate, or conduct gate is needed.

## Semantic checksum

Before a substantial production change, briefly identify:

- **Master node:** the relevant label or passage.
- **Claim:** the mathematical fact currently being formalized.
- **Hypotheses consumed:** especially the relevant C1–C4 and GPV unique-fibre
  consequences.
- **Authored objects and arrows:** the actual carrier, maps, and their order.
- **Lean target:** the production declaration being proved or changed.
- **Dependency path:** how the work reaches `ASection.concentricity`.
- **Expected result:** the precise relationship the declaration must express.

This can be a short working note in the task. It is not a file-writing
requirement or a gate requiring approval.

For the final readout, the checksum must preserve

\[
J_A \xrightarrow{\pi_0} \pi_0(J_A)=\{\kappa\}
\xrightarrow{\overline L_A}\mathbb R,
\]

with state evaluation proved after passage to connected components.

## Evidence discipline

Use fresh evidence for current-status claims:

- elaborate the affected declaration or a focused probe;
- build the relevant production module;
- inspect the actual declaration type or axiom output;
- quote the exact Lean error when reporting a blocker.

Do not infer absence from a failed name search. Do not infer a mathematical gap
from a failed proof attempt, an awkward API, or an auxiliary construction that
does not yet connect to production.

Use precise status language:

- **proved:** accepted by Lean in the stated production dependency path;
- **elaborates:** the checked term or declaration compiles;
- **unformalized:** the mathematical step has not yet been expressed without
  an escape hatch;
- **interface issue:** the intended objects exist but the attempted Lean term
  does not connect them;
- **mathematical conflict:** explicit hypotheses yield an exact incompatible
  conclusion.

Reserve “gap,” “counterexample,” and “false” for concrete mathematical
evidence, not expectations attached to a downstream result.

## Freedom to explore

Models may create temporary probes, test equivalent Lean encodings, search
Mathlib, unfold definitions, and reorganize helper lemmas. This freedom
concerns implementation.

It does not authorize changing the semantic carrier, reversing the proof,
inventing a new bridge, or adding invariance, equivalence, or naturality
obligations absent from the master.

Auxiliary code becomes part of the formalization only when it connects to the
production theorem’s dependency graph.

## Downstream quarantine

During the upstream construction—through the semantic residue total,
transitivity and connectedness, singleton \(\pi_0\), and the post-\(\pi_0\)
real readout—exclude RH, zeta, the critical line, `1/2`, and perceived theorem
hardness from the reasoning. Concentricity is formalized on its own hypotheses
and action-groupoid structure. Downstream corollaries return only after that
production route is complete.

## Correction protocol

When Jesse corrects the mathematics:

1. state the corrected object, arrow, or order;
2. discard the premise that caused the mistake;
3. identify code or plan text that depended on that premise;
4. rebuild the semantic checksum from the corrected route;
5. resume forward formalization.

Changing terminology while preserving the rejected architecture is not a
valid correction.

## Release evidence

Release certification belongs to the final release stage, not to everyday
discussion. A release claim requires fresh evidence that:

- every intended Lean module builds;
- no executable `sorry`, `admit`, or `native_decide` remains;
- no project source declares an axiom;
- both release targets, `ASection.concentricity` and
  `zeta_riemannHypothesis`, use exactly `propext`, `Classical.choice`, and
  `Quot.sound`;
- `ASection.concentricity` follows the authored post-\(\pi_0\) dependency path;
- the master, production docstrings, and public theorem surface agree.

Git history, master labels, bibliographic citations in the master, and kernel
output are the durable provenance record. Behavioral surveillance is not.
