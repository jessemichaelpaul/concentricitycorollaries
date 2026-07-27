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

# MASTER DIFF — Lane B folds (2026-07-04) — REVISED after reading the committed master

## What the 47-line fold (94d830e) already landed — discovered while drafting

- The \TODO is GONE: the author's placement paragraph now sits in the proof
  (sourced register: triangle, levels, winding, Cor 5.13/5.21 — exactly as required).
- rmk:pi0-split is ALREADY placement-consuming: `\uses{lem:pi0-grothendieck,
  eq:placement-set}`, the "post-placement reading" framing, and the honest closer
  "Absent the placement … this half asserts nothing." (Fold 5: done.)
- C3 pole factor + "nonzero residue-ℝ" wording: done (previously noted).
- The R6 (a)/(b) question is therefore MOOT — the fold already chose (a):
  the dependence is meant to be blueprint-visible via a labeled node.

## The problem the fold left behind

`eq:placement-set` is referenced twice (the \uses and an \eqref) but **defined
nowhere** — the master currently has a dangling reference (renders "(??)").
The labeled node everyone points at doesn't exist yet. Separately, the
placement paragraph's final clause ("…and the degenerate fibre … lies over a
single level") reads, cold, as if concluded by the static-base sentence —
but level-conservation along zigzags gives "zeros sharing a component share a
level" (= zigzag_iff_level), not "all zeros share a component." The OPEN flag
that Lane B task 1 requires is not yet visible at the spot.

## APPLIED (author-approved wording, α ruling)

- **Edit A** — C2: "…an infinite family {ℓ_p} … the family summable *locally
  normally* on Ω₀ (the sense in which the cited Euler products converge;
  Theorem thm:euler)…" C3: "…the factorization holds with either family
  infinite, the product converging *locally normally* on 𝕆*∖{p₀} (the
  convergence of Proposition prop:weierstrass)." — APPLIED to the tex.

## AWAITING THE AUTHOR'S WORD (one wording approval — Edit B touches his paragraph)

**Edit B — define the missing node; make OPEN visible.** Replace the placement
paragraph's final sentence (proof of thm:concentricity, after "…none in the
level."):

OLD (final sentence of the paragraph):

```tex
Since
$\mathcal B$ is static --- no morphisms between distinct levels (Definition~\ref{def:base})
--- the level is a conserved quantity along every zigzag of $\mathcal T_A$, and the
degenerate fibre of the unique tame transport attached to the $A$-section --- the
residue-$\CC$ zero-spheres $\{q_n\}$ of \textup{C3} --- lies over a \emph{single} level.
```

NEW:

```tex
Since
$\mathcal B$ is static --- no morphisms between distinct levels (Definition~\ref{def:base})
--- the level is a conserved quantity along every zigzag of $\mathcal T_A$: zero-spheres
sharing a component share a level. That the degenerate fibre of the unique tame transport
attached to the $A$-section --- the residue-$\CC$ zero-spheres $\{q_n\}$ of \textup{C3} ---
lies over a \emph{single} level is the \emph{placement}, the document's one open node, in
its official enumeration-free set-level form (the zero set is the stem's alone): on any
slice $\CC_I$,
\begin{equation}\label{eq:placement-set}
  A_I(z)=A_I(w)=0,\quad \Im z>0,\quad \Im w>0
  \;\;\Longrightarrow\;\; \Re z=\Re w \qquad (z,w\in\CC_I).
\end{equation}
The route on record toward it is Remark~\ref{rmk:two-index-roadmap} \textup{(}in the
formalization: \texttt{ASection.transportLevel\_placement}, held as the repository's
single load-bearing \texttt{sorry}\textup{)}. Granting the placement, the proof concludes.
```

(The following "cocartesian computation" paragraph already says "By the assembly
and the placement above" — the referent now exists.)

**Edit C — rmk:two-index-roadmap** (lands together with B; it references the label).
Insert after \end{proof} of thm:concentricity, before rmk:pi0-split:

```tex
\begin{remark}[The two-index route; equation only]\label{rmk:two-index-roadmap}
The placement \eqref{eq:placement-set} is a two-index statement --- an equality between
data indexed by the Euler family of \textup{C2} and data indexed by the zero-spheres of
\textup{C3}. The route on record (author, 2026-07-04) stays entirely in the equation
layer: \textup{(i)} the logarithmic derivative of the stem identity --- the \textup{C2}
Euler side equated with the \textup{C3} Weierstrass side through the explicit pole factor
--- where an individual index $p$ first meets an individual index $n$; \textup{(ii)} the
pairing of the two expansions against test functions, the
$\sum_p\!\leftrightarrow\!\sum_n$ ledger; \textup{(iii)} the closing clause, stated
value-free and in level-differences only. No morphism is added anywhere: the objects
$\mathcal B$, $F$, $\mathcal T_A$ of Definition~\ref{def:base} are unchanged, and the
statement of Theorem~\ref{thm:concentricity} is untouched. The clause of \textup{(iii)}
either derives from \textup{C1--C4} or stands as a named additional property of the member
under study; deciding which is the route's endpoint.
\end{remark}
```

## FLAGGED, author's choice now-or-later (Edit D — rmk:status refresh)

1. "…is conspicuously marked inside the proof" — after Edit B this can point at
   the label: "…is carried as the labeled open node \eqref{eq:placement-set}
   inside the proof."
2. "A machine formalization is future work; nothing in this document has been
   run in Lean." — STALE: the repository builds green; the categorical spine,
   both worlds, and the transport are formalized; thm:concentricity is proved
   in Lean conditional on the placement node; current ledger 7 sorries
   (6 statement-layer, 1 the node) / 0 project axioms. Proposed replacement
   drafted on request — or hold for a milestone pass. Author's call.
