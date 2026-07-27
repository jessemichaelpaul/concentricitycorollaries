> ## RETIRED - PRE-REBUILD MATERIAL, NOT CURRENT (marked 2026-07-20)
>
> This file sits in a retired directory and predates the projective rebuild. It may describe
> objects, bases, functors, and file locations that no longer exist.
>
> **Known stale across this material:**
> - The `cayleyProjective` / generic-Moebius route and the `Hypothesis A (_D)` cargo-as-fields
>   pattern are **SUPERSEDED**. Cargo is not attached to the action; it IS the action. The
>   A-determined Euler/Weierstrass pole action is carried by `stabilizerPart` via orbit-stabilizer.
> - **Deleted modules:** AFunctor, TwoWorlds, PhiConversion, Recovery, ConnectedBase, InboxWire,
>   SynthesisE6, IntegrateTheorem, NormalizedCone, NormalizedNLeg, Base, TransportObject,
>   FaithfulApply, KeystoneAssembly, KeystoneFinality, RecoveryAudit. Their facts were rehomed,
>   largely into ProjectiveCargo / ProjectiveTransport.
> - **Every file:line citation here is unreliable.** Resolve names against the live tree only.
> - Any `rho`/`V_RHO`, `el(V)`, `Disc R`, per-zero `Z_n -> N` leg, generic action record, or
>   parameterized carrier appearing below is a retired substitution, not the construction.
>
> **Current and authoritative:** `PROOF_OUTLINE_LOCKED.md` and
> `BOARD_LECTURE_CONCENTRICITY_2026-07-17.md` (the author own), plus `RESUME_2026-07-20.md`
> for live state.
>
> **Do not take construction, architecture, or status from this file.**

# MASTER DIFF — the concentric fold (author's ruling, 2026-07-06; words-before-commits)

Status: DRAFT for the author's review. Nothing applied. Deliverable per R7
(diffs against the master, never essays); the master is the author's document
(transcribe, never paraphrase — the diff shows exact before/after).

Source of the fold: the author's dictated sentences of the 2026-07-06 dialogue,
verbatim in the commit messages of `b24a25c` (the articulation, PROVED:
`ASection.concentric_articulation`, kernel triple) and `26195ae`. The ruling:
Pin 3 retired; the concentric claim is about THE SECTION, not the base; 𝓑 is
level-blind, the A-section glues all the levels, and that gluing is the
theorem (+ lemma); the corollaries note ζ_𝕆 instantiates, and the FE pins the
real centre.

---

## Fold 1 — new lemma after `thm:concentricity` (the articulation)

INSERT after the proof of Theorem \ref{thm:concentricity} (after line ~1205,
before `rmk:two-index-roadmap`):

```tex
\begin{lemma}[The concentric component]\label{lem:concentric-component}
\uses{thm:concentricity, lem:exp-degenerate, def:base}
\lean{ASection.concentric_articulation}
The connected component of Theorem~\ref{thm:concentricity} is defined by the
degenerate fibre through the witness $\nfr$: every residue-$\CC$ zero class is
the class of $\nfr$ --- the attachment of the grown arrows of \textup{C1}'s
cone --- and each degenerate fibre is itself concentric, carrying exactly one
real level with all multiplicity in the winding band
(Lemma~\ref{lem:exp-degenerate}). $\mathcal B$ by itself is level-blind; the
$A$-section functor, with its conjoined properties \textup{C1--C4} and the
loop assembly, is what glues the levels. The infinitely many residue-$\CC$
zero-spheres of \textup{C3} therefore lie in one \emph{concentric} component
of $\mathcal T_A$.
\end{lemma}
\begin{proof}
Clause by clause on the formalization's certified rows: one component is
Theorem~\ref{thm:concentricity}; the component is the witness class by the
cone's arrows (\texttt{classOf\_eq\_nClass}); per-fibre concentricity is
Lemma~\ref{lem:exp-degenerate} (\texttt{exp\_fibre\_level},
\texttt{exp\_fibre\_height\_band}). Certificate:
\texttt{[propext, Classical.choice, Quot.sound]}.
\end{proof}
```

## Fold 2 — the placement passage inside the proof of `thm:concentricity`

REPLACE (lines ~1163-1176, from "That the degenerate fibre" through "Granting
the placement, the proof concludes."):

```tex
--- BEFORE ---
... the level is a conserved quantity along every zigzag of $\mathcal T_A$:
zero-spheres sharing a component share a level. That the degenerate fibre of
the unique tame transport attached to the $A$-section --- the residue-$\CC$
zero-spheres $\{q_n\}$ of \textup{C3} --- lies over a \emph{single} level is
the \emph{placement}, the document's one open node, in its official
enumeration-free set-level form (the zero set is the stem's alone): on any
slice $\CC_I$,
\begin{equation}\label{eq:placement-set} ... \end{equation}
The route on record toward it is Remark~\ref{rmk:two-index-roadmap}
\textup{(}in the formalization: \texttt{ASection.transportLevel\_placement},
held as the repository's single load-bearing \texttt{sorry}\textup{)}.
Granting the placement, the proof concludes.

--- AFTER ---
... the level is a conserved quantity along every zigzag of $\mathcal T_A$:
zero-spheres sharing a component share a level. The connected component of
the $A$-section is defined by the degenerate fibre through the witness $\nfr$
(Lemma~\ref{lem:concentric-component}): $\mathcal B$ by itself is
level-blind, and the $A$-section functor --- with its conjoined properties
\textup{C1--C4} and the loop assembly --- is what glues the levels; the
degenerate fibre of the unique tame transport --- the residue-$\CC$
zero-spheres $\{q_n\}$ of \textup{C3} --- accordingly lies over a single
level: on any slice $\CC_I$,
\begin{equation}\label{eq:placement-set} ... \end{equation}
[equation retained verbatim — it is consumed downstream by
Corollary~\ref{cor:nontrivial} and Theorem~\ref{thm:rh-equiv}]. The proof
concludes.
```

NOTE FOR REVIEW (transcription honesty, R2): the AFTER text carries the
inference "the component is defined by the fibre through 𝔫, hence the fibre
lies over a single level" on the word *accordingly*. In the formalization
this is the step the Lean transcription of the folded proof must supply when
it closes `ASection.transportLevel_placement` from
`ASection.concentric_articulation` — the transcription runs after this fold
is approved, lake as the meter, per the standing rule.

## Fold 3 — supersession notes

- `rmk:two-index-roadmap`: ADD closing sentence: "Superseded as the route of
  record by Lemma~\ref{lem:concentric-component} (2026-07-06); retained as
  the equation-layer rendering of the same gluing (the ladder D0--D3 and the
  reduction \texttt{placement\_set\_iff\_liSum} are proved in the
  formalization)."
- Pin 3 (formalization-side, TransportObject.lean docstring): retired per the
  author's ruling — recorded here for the docstring scrub at
  cleanup-on-green; the FROZEN file itself is not touched until that pass.

## What the Lean transcribes after approval

1. `cor:nontrivial` (Corollaries.lean): proof re-routed per the printed
   proof — Theorem + Lemma~\ref{lem:concentric-component} + the dictionary
   `thm:connected-concentric`.
2. `transportLevel_placement` (Theorem.lean:213): closed by the folded
   proof's *accordingly* step; `placement_set` follows by the proved weld;
   `cor:rh` closes with ½ from `thm:rh-equiv`'s proved rigidity.
3. Certificates re-printed for the full chain; ledger target 0 sorries /
   0 axioms; then wiring, attic, blueprint — the cleanup-on-green runway.
