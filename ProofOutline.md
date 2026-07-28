# Proof outline — the blueprint spine

**Generated directly from `Octonionic_RH_master.tex`. Do not hand-edit — regenerate.**

Part A is the statement list in order with the `\lean{}` tags that make the blueprint click
through to live declarations. Part B is the Concentricity Theorem's proof, verbatim from the
master, because that proof *is* the endgame spine.

---

## Part A — statements in order


#### Introduction

### PART — Classical Background

#### The Riemann zeta function
- **Theorem** `thm:riemann` — Meromorphic continuation and functional equation; Riemann Riemann1859
- **Theorem** `thm:euler` — Infinite Euler product; [Ch.~1
- **Theorem** `thm:hadamard` — Infinite Hadamard product; [Ch.~2
- **Corollary** `cor:hadamard-infinitude` — Infinitude of the nontrivial zeros
- **Theorem** `thm:hardy` — Hardy Hardy14
- **Definition** `def:zeta-Cstar` — Compactified classical zeta
- **Lemma** `lem:zero-Cstar` — Compactification does not move the zeros

### PART — Slice-Preserving Theory, the Ring  R, and the Equivalence

#### Octonions and slices
- **Definition** `def:octonions`
- **Theorem** `thm:artin` — Artin Schafer66
- **Corollary** `cor:powers`
- **Definition** `def:slices` — Complex slices and slice Riemann spheres

#### Slice-preserving functions
- **Definition** `def:slice-regular` — Slice regularity; [Def.~5.1.1
- **Theorem** `thm:rep-formula` — Representation Formula; [Thm.~5.1.7
- **Theorem** `thm:identity` — Identity Theorem; [Cor.~5.1.9
- **Theorem** `thm:extension` — Extension Theorem; [Thm.~5.1.5
- **Definition** `def:slice-preserving` — Slice-preserving functions; [Def.~2.7, Rem.~2.8

#### The octonionic zeta function
- **Definition** `def:zeta_O` — Octonionic zeta
- **Proposition** `prop:well-defined` — Well-definedness

#### R
- **Definition** `def:R` — The ring of slice-preserving functions under the regular product
- **Theorem** `thm:wang` — Regular product on slice-preserving functions; [Rem.~2.11
- **Proposition** `prop:R-comm-ring`
- **Proposition** `prop:R-domain` — R is an integral domain

#### The slice-preserving analytic toolkit on the compactified octonions
- **Theorem** `thm:slice-exp` — The slice exponential; [3
- **Theorem** `thm:log-manifold` — The logarithm manifold E^+_; [Prop.~5.1, Rem.~5.2, Def.~5.3, Prop.~5.4, Def.~5.5
- **Lemma** `lem:exp-degenerate` — The degenerate set of the exponential; its fibre over a real value
- **Definition** `def:slice-squares` — Slice restriction and the I-independent lift; [Rem.~2.11
- **Theorem** `thm:winding-lift` — The winding lift; [Def.~3.4, Def.~4.1, Prop.~4.2, Def.~5.11
- **Proposition** `prop:winding-signature` — Tameness, existence, and the winding number; [Def.~4.20, Cor.~5.21, Cor.~5.22

#### Slice preservation and symmetries
- **Theorem** `thm:slice-pres` — Slice preservation
- **Theorem** `thm:zeta-in-R` — is a section of  R
- **Definition** `def:G2` — The automorphism group
- **Theorem** `thm:G2-equiv` — -equivariance
- **Theorem** `thm:G2-S6` — Baez02

#### Zero geometry and the equivalence
- **Theorem** `thm:zero-equivalence` — Zero Equivalence Theorem
- **Theorem** `thm:zero-spheres` — Nontrivial zeros are infinitely many disjoint 6-spheres
- **Theorem** `thm:rh-equiv` — The equivalence: concentricity  RH

### PART — The Categorical Construction and the Concentricity Theorem

#### The geometric worlds and the categorical construction
- **Definition** `def:carrier` — The compactified octonions ^*=S^8
- **Definition** `def:section-map` — The section's slice data and equivariance
- **Definition** `def:two-worlds` — The octonionic and slice-value worlds  
  ↳ Lean: `H1, S2`
- **Definition** `def:base` — The projective base, genuine section functor, and total category  
  ↳ Lean: `GreatCircle.Base, CategoryTheory.Grothendieck`

#### The concentricity theorem
- **Proposition** `prop:weierstrass` — Slice-regular Weierstrass factorization; the content of C3
- **Lemma** `lem:residue-spheres` — Residue- zeros are 6-sphere components of  H_1
- **Lemma** `lem:pi0-grothendieck` — _0 of a Grothendieck construction  
  ↳ Lean: `CategoryTheory.Grothendieck`
- **Definition** `def:A-section` — A-sections
- **Definition** `def:residue-subdiagram` — The residue subdiagram and its inclusion  
  ↳ Lean: `ASection.CResidueZeroLocus, ASection.AsectionCResidueDiagram, ASection.AsectionCResidueInclusion`
- **Theorem** `thm:concentricity` — Concentricity
- **Corollary** `cor:nontrivial` — Translation to the classical framework

#### Corollaries
- **Corollary** `cor:zeta-section` — is an A-section
- **Corollary** `cor:rh` — Riemann Hypothesis

---

## Part B — the Concentricity Theorem, verbatim

```latex
\begin{theorem}[Concentricity]\label{thm:concentricity}
\uses{def:A-section, def:base, def:residue-subdiagram, lem:residue-spheres, lem:pi0-grothendieck,
thm:winding-lift, prop:winding-signature, thm:identity}
Let $A$ be an $A$-section. The infinitely many C-residue zeros transported by the A-section functor
$\mathcal A_A:\mathcal B\to\mathbf{Grpd}$, from the projective great-circle base
$\mathcal B$ to the A-generated normalized value groupoids, form exactly one
colimit/component class, and that
singleton class
carries one real value
\[
  c\in\RR.
\]
Consequently every populated residue-$\CC$ zero $6$-sphere has centre $c$, so the infinitely
many populated residue-$\CC$ zero spheres are concentric. The theorem does not prescribe the
numerical value of $c$.
\end{theorem}
\begin{proof}
We consider a slice-preserving section $A$ of the ring $\mathcal R$ on the compactified
octonions $\OO^{*}$. Slice preservation hands us, for each slice, an isomorphism onto a
Riemann sphere, pinned down by a normalization of $\OO^{*}$; and this is already the push
toward a functorial point of view, because the spheres do not come one at a time --- they come
as a family with coherent identifications, and such a family is organized by a functor. The
hypotheses push in the same direction. Specifying the analytic object, the theory suggests
exponential equations; and $\OO^{*}$ comes from the Cayley--Dickson construction with only one
real axis. The projective great circle that axis compactifies to is framed by $PGL(2,\RR)$: a
projective coordinate frame in which $\exp(I\theta)$ lives, and the analytic sections of
$\mathcal R$ themselves transform as M\"obius transformations --- self-transformations of the
slice-preserving section. Frames and transformations compose, invert, and act: they are
groupoids. That is the base $\mathcal B$ of Definition~\ref{def:base}
\textup{(}\texttt{GreatCircle.Base}\textup{)}, arrived at by the shape of the ring rather than
by choice.

Conditions C1--C4 now determine what kind of distinguished action the A-section is. The
exponential equations lead to the commuting triangle $\pi\circ E=\exp$ of the logarithm
manifold \textup{(}Theorems~\ref{thm:slice-exp} and~\ref{thm:log-manifold}\textup{)}, giving
the unique tame lift of any exponential base \textup{(}Theorem~\ref{thm:winding-lift},
Proposition~\ref{prop:winding-signature}\textup{)}; since C2 supplies an Euler product, the
winding of that lift is partitioned and well-defined at every prime, all of it carried in one
diagonal M\"obius element --- a group and a function, and a functor. C3 supplies the unique
factorization at $N$ \textup{(}Proposition~\ref{prop:weierstrass}\textup{)}. That the Euler
diagonal element and the Weierstrass factorization are connected by the same unique tame lift
is what gives the distinguished disk action its structure: the degenerate fibre of
Lemma~\ref{lem:exp-degenerate}, with its one real level and its winding heights, is this
action's own level-and-height bookkeeping. Each of these points of view is by itself
fragmentary; conjugated, they show how A-section functors act. And they act on groupoids, so
the construction is completed by categorified orbit--stabilizer theory, which is how such a
functor is made well-defined on all of $\OO^{*}$: the M\"obius group law gives the local
action, orbit representatives position the element at every footpoint, stabilizer
compatibility makes the positioning independent of the representatives, and the group identity
and multiplication supply the functor laws. The $G_2$-equivariant realization
\textup{(}Theorem~\ref{thm:G2-equiv}\textup{)} lifts the same action to the value states,
along the continuum of Riemann spheres through the one point $N$. The result is the A-section
functor $\mathcal A_A:\mathcal B\to\mathbf{Grpd}$ of Definition~\ref{def:base}, whose states
carry their real-value data and whose arrows are the element's actual value transports.

From the functor we form its total Grothendieck construction,
$\mathcal T_A=\int_{\mathcal B}\mathcal A_A$ \textup{(}Definition~\ref{def:base}\textup{)}: an
object is a base position together with a normalized value state in its fibre, a morphism is a
base channel together with the compatible transport, and the whole is an action groupoid
formed from the distinguished element. It is in this total, and not in any set, that the
residue-$\CC$ zeros are found. The distinguished element fixes $0$ and $N$, and between them
the upper half-space; at the north frame, where the positioning factor is trivial and the
frame is the element itself, the equation $A=0$ on that half-space selects the residue states,
with Euler presenting at one end, Weierstrass at the other. The preimage of this selection
under the action --- the preimage of the total action groupoid, membership travelling by
composition in the base --- is the residue subdiagram $\mathcal R_A$ of
Definition~\ref{def:residue-subdiagram}, included in $\mathcal A_A$ by $\iota_A$. The
restriction of the total object to this preimage sits over the same base:
\[
\begin{tikzcd}[column sep=large]
\int_{\mathcal B}\mathcal R_A \arrow[rr, hook, "\int\iota_A"] \arrow[dr, "\pi_{\mathcal R}"'] & &
\int_{\mathcal B}\mathcal A_A \arrow[dl, "\pi_{\mathcal A}"] \\
& \mathcal B &
\end{tikzcd}
\]

Connectedness is established here, by the structure of $\iota_A$ itself. Because $\iota_A$ is
a faithful embedding, an isomorphism onto its image, there is a canonical diagram of three
categories: the domain $\mathcal R_A$, the image subcategory $\operatorname{Im}(\iota_A)$, and
the full target $\mathcal A_A$. This creates a mandatory span of functors, a length-two
zigzag:
\[
\begin{tikzcd}[column sep=large]
& \operatorname{Im}(\iota_A) \arrow[dl, "\iota_A^{-1}"'] \arrow[dr, hook, "j"] & \\
\mathcal R_A & & \mathcal A_A
\end{tikzcd}
\]
This follows immediately, because $\iota_A$ is a \emph{proper} inclusion and a natural
isomorphism onto its image.
The backward path exists because $\iota_A:\mathcal R_A\to\operatorname{Im}(\iota_A)$ is a
strict isomorphism of categories, hence fully invertible; the forward path is the canonical,
non-invertible inclusion $j:\operatorname{Im}(\iota_A)\hookrightarrow\mathcal A_A$. Any
relation of the full category back to the restricted domain traverses exactly this roof. A
category is connected when any pair of its objects is joined by a finite zigzag of morphisms,
and the residue total inherits its zigzags through this span from the action that produced it:
$\int_{\mathcal B}\mathcal R_A$ is a connected action groupoid. Concretely, the element's
unique tame continuous lift runs the members into one another while fixing the real level, a
difference of winding being purely vertical \textup{(}Lemma~\ref{lem:exp-degenerate}\textup{)}.

By Remark~8.3.5 of \cite{Riehl}, a category is nonempty and connected if and only if its
$\pi_0$ is the singleton set. Condition C4 supplies nonemptiness --- infinitely many
residue-$\CC$ zero-sphere states populate the preimage --- and connectedness was just
established. Therefore, by Lemma~\ref{lem:pi0-grothendieck}
\textup{(}\texttt{pi0GrothendieckEquiv}\textup{)},
\[
\pi_0\Bigl(\int_{\mathcal B}\mathcal R_A\Bigr)\;\cong\;\operatorname*{colim}_{\mathcal B}\,(\pi_0\circ\mathcal R_A)
\]
collapses to a singleton $\kappa$. The class and its value are kept in distinct registers:
$\kappa$ is the unique transport class, and $c\in\RR$ is the one real level present in the
states $\kappa$ identifies, conserved along every connecting transport by the lift's level
law; the level read is \texttt{ASection.transportLevel} in the Lean source. Reading the level
on $\kappa$ returns a single number. The populated residue-$\CC$ zero $6$-sphere states all
represent $\kappa$, so each has centre $c$. Hence, the infinitely many residue-$\CC$ zero
spheres of the A-section are concentric.
\end{proof}
```

