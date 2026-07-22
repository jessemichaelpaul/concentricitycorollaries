# BOARD LECTURE — from the Cayley–Dickson question to Concentricity

**Mathematical author:** Jesse Michael Paul  
**Prose draft:** Codex, using Jesse’s 2018 microhistory paper as the voice reference  
**Cross-model review:** Opus pending  
**Author ratification:** pending  
**Status:** historical lecture draft; not a proof-execution instruction. For execution use
`PLAN_TWELVE_ON_THE_DISK_ACTION_2026-07-22.md` and `HANDOFF.md`.

> **AUTHOR SUPERSESSION — 2026-07-19 (night), extended 2026-07-21.** Where this lecture
> separates a generic action from analytic cargo later placed on it, read the corrected
> construction: the distinguished element builds the C2 Euler product; Euler and Weierstrass
> are the pole action; and orbit--stabilizer proves that same A-dependent action global and
> functorial over `GreatCircle.Base`. There is no generic action interface and no later
> cargo insertion.
>
> **Board 4 was rewritten on 2026-07-21** to carry that derivation in full — the element
> $d_A$, the $w=0$ specialization, the mirrored orbit–stabilizer extension, and the reason
> $F.\mathrm{obj}$ and $F.\mathrm{map}$ come out of it *together*. Author's ruling of that
> date: *"MY groupoids are my projective base (where that disk automorphism lives) and the
> SphereWorld and T_A is built from that"*; *"There is no one fibre of my functor."* Boards
> 5–9 should be read against Board 4 as rewritten, not against the earlier
> "general functor $+$ cargo" line it replaced.

## The lecture’s point of view

I did not begin by trying to prove the Riemann Hypothesis. I began with a different and much
older question: what is the Cayley–Dickson construction doing, why does algebra change as one
moves from the reals to the complexes, quaternions, and octonions, and why does the familiar
sequence stop where it does? That question led to the slice-preserving functions on the
octonions and to the commutative ring they form under the regular product. Only afterward did
the zeta function appear as one section of this larger structure.

This history matters mathematically. If we begin with the famous corollary, the construction
can look like a machine invented to reach a predetermined answer. If we begin where the
construction actually began, the scale changes. We first see a general geometric mechanism,
then one class of sections that carries additional analytic structure, and only at the end a
categorical theorem that reads what this structure has already assembled.

The lecture therefore moves twice between scales. It begins with the large landscape of the
Cayley–Dickson algebras, descends to one distinguished Möbius/exponential motion and the exact
objects and arrows it generates, and then rises again through the Grothendieck construction and
the colimit. The short conclusion is visible only after the detailed construction has fixed the
right point of view.

## Board 1 — Cayley–Dickson and the slice landscape

I begin with

$$
\mathbb R\subset\mathbb C\subset\mathbb H\subset\mathbb O,
\qquad
\mathbb O^*=\mathbb O\cup\{\infty\}\cong S^8.
$$

The octonions are noncommutative and nonassociative, but every imaginary unit
$I\in S^6$ determines an associative complex slice

$$
\mathbb C_I=\operatorname{Span}_{\mathbb R}(1,I).
$$

All of these slices share the real axis, and after compactification they share the same point
at infinity, which I call $N$. The important object is not one preferred complex plane. It is
the continuum of slice planes together with their common real and compactified geometry.

This is also where I introduce the ring $\mathcal R$ of slice-preserving functions. A section
$A\in\mathcal R$ has one real stem, read in every complex slice. The same stem gives many
charts, not many unrelated functions. That fact will later let one distinguished motion be
read simultaneously throughout the continuum of sphere worlds.

## Board 2 — the motion first, and the groups it forces

I want to be careful about the order here, because getting it backwards is the single most
reliable way to build the wrong object. **I do not begin with a category and then look for
somewhere to put my function.** I begin with one motion, and the groups on the board are the
groups that motion already has.

The motion is a **disk automorphism**, written on the next board. Three facts about it fix
everything in this lecture's vocabulary.

**First: it is a Möbius transformation.** So the arrows inside a single slice sphere are Möbius
self-maps. I do not choose that; the motion is one. Writing `Moebius` on the board is recording
what the element already is.

**Second: on the circle, the motion is seen only projectively.** A scalar multiple of a matrix
induces the same transformation of the compactified real line, so scalars act trivially and the
action **descends** — in Lean, `scalar_smul` (`ProjectiveBase.lean:38`), which is exactly the
descent condition producing the action `instMulActionAutPoint` (`:47`), while representatives are
still written in GL, `mk_smul` (`:53`). That is why the base carries

$$
\mathcal B \;=\; PGL(2,\mathbb R)\ltimes\operatorname{OnePoint}(\mathbb R),
$$

and not GL. **The extension through GL is a homomorphism, not a construction with choices.** That
is the whole reason for this group and no other.

**Third: the slices are relabelled by $G_2$.** The motion is read in every slice
$\mathbb C_I$, $I\in S^6$, and $G_2=\operatorname{Aut}(\mathbb O)$ is what carries one direction
to another. So an arrow between two sphere worlds carries a $G_2$ datum. And $G_2$ acts
*transitively* on $S^6$ (Baez; in Lean `exists_smul_eq_of_mem_unitImaginarySphere`), so any two
directions are joined.

That gives the two groupoids, and they are the only two:

- **$\mathcal B=$ `GreatCircle.Base`** — the projective action groupoid, where the disk
  automorphism lives;
- **`SphereWorld`** — one object per direction $I\in S^6$, with arrows
  $\;\texttt{rot}:G_2$ (moving the direction), $\;\texttt{rot\_eq}$ (landing in the target world),
  $\;\texttt{mob}:\texttt{Moebius}$ (moving inside the sphere).

**Why groupoids and not orbit sets.** An orbit set remembers *that* two points are related. An
action groupoid remembers *the transformation* that relates them. The colimit at the end of the
lecture is generated by arrows, so it can only see what the arrows carry — which is why the
transformations must be kept, and why nothing may be quotiented early.

**Orbit and stabilizer, stated precisely**, since the next board leans on both. An orbit is a set;
a stabilizer is a subgroup, whose elements fix the distinguished point. The stabilizer condition is
what makes an orbit-defined assignment independent of the representative chosen to reach a point.
That is the mechanism by which one motion at one point becomes a motion at *every* point.

Nothing analytic has entered yet. But notice that this board contains no free choices: every group
on it was forced by the motion.

## Board 3 — the distinguished action mechanism

Now I write the local formula that organizes the global action:

$$
f(z)=\exp(I\theta)\frac{z-w}{1-\bar w z}.
$$

This is a disk automorphism followed by a slice rotation. The variable $I$ ranges through
$S^6$, so the exponential factor is not a phase living in one chosen complex chart. It is the
same distinguished motion read throughout the continuum of slice worlds.

### 3.1 — the homomorphism (this is the centrepiece)

A Möbius element acts on a sphere world by **conjugation of the Möbius leg**, leaving the
direction alone:

$$
m\;\longmapsto\;\Big(\;I\mapsto I,\qquad
\langle \mathrm{rot},\ \mathrm{mob}\rangle \mapsto
\langle \mathrm{rot},\ m\,\mathrm{mob}\,m^{-1}\rangle\;\Big).
$$

The element does not relabel directions — it is a motion *inside* each sphere — so it fixes
objects and moves arrows. That is not a simplification; it is what the motion is.

This assignment is a **group homomorphism**

$$
\texttt{Moebius}\;\longrightarrow\;\big(\texttt{SphereWorld}\Rightarrow\texttt{SphereWorld}\big),
$$

and both laws are already proved in Lean (`ProjectiveSection.lean:162–195`):

$$
m=1\ \Rightarrow\ \text{the identity functor},
\qquad
(\,\cdot\, m)\ \text{then}\ (\,\cdot\, n)\;=\;(\,\cdot\, nm),
$$

that is, `distinguishedWorldAction_one` and `distinguishedWorldAction_comp`. Conjugation is a
homomorphism; there is nothing deeper, and nothing to choose.

**This is a green action mechanism, not a separately constructed project functor.** It takes a
Möbius element and supplies the identity and composition laws used by the A-specialized action.
It forms neither `sectionFunctor A` nor a total object by itself.

### 3.2 — orbit–stabilizer carries one motion to every arrow

The base is not one object. Its objects are every point of the compactified great circle, and its
arrows are the projective motions between any two of them. Orbit–stabilizer is what turns one
motion at one point into a motion at all of them:

- `orbitRep_spec` — for **every** point $b$, a transport with $\operatorname{orbitRep}(b)\cdot\infty=b$;
- `orbit_stabilizer_factor` — **every** arrow $f:b\to b'$ factors as
  $\operatorname{orbitRep}(b')\cdot\operatorname{stab}(f)\cdot\operatorname{orbitRep}(b)^{-1}$.

If two elements represent the same orbit point their quotient lies in the stabilizer, and
stabilizer compatibility makes the induced assignment independent of that choice. Identity and
composition are then the ordinary group laws — `stabilizerPart_id`, `stabilizerPart_comp`.

**The mechanism is a composite of two homomorphisms:** base-arrow transition data are factored by
orbit–stabilizer, then the resulting Möbius element acts on `SphereWorld` by §3.1. Identity and
composition therefore require no choice per arrow. This is the entire content of "no map
hunting," but it is only the vehicle. The project functor is accepted later, after the complete
A-generated action and its twelve native facts occupy this vehicle row by row.

### 3.3 — what is and is not built here

At the end of this board we have the green `distinguishedWorldAction` and orbit–stabilizer
mechanism. We have not yet accepted `sectionFunctor A`, and no $\mathcal T_A$ is formed. There is
no third, intermediary functor between the two authored groupoids.

## Board 4 — the complete A-generated action, extended row by row

Only now do I state the A-section hypotheses. An A-section is a slice-preserving section in
$\mathcal R$ carrying four additional properties:

- C1 gives meromorphic continuation and the unique simple real pole whose value is the common
  compactified point $N$.
- C2 gives the Euler exponential channel on its right half-space.
- C3 gives the slice-regular Weierstrass channel over the full divisor and enumerates the
  residue-$\mathbb C$ zero-spheres.
- C4 states that this residue-$\mathbb C$ population is infinite.

I want to be exact about what these do. They determine the complete function-valued
Euler–Weierstrass–GPV disk action. Each of the twelve load-bearing facts is proved natively on
that action and, in the same pass, extended wholesale by the Board 3 orbit–stabilizer mechanism.
No fact is attached later as cargo, and no batch transfer is deferred until the end.

### 4.1 — C1–C3 describe one complete action

C2 already supplies the complete function-valued action as `eulerDiskAction A z`, with
`eulerDiskAction_eq_value` identifying its multiplier with `A.F z` on the Euler half-space. C1
continues that action through the common pole, while C3 gives its Weierstrass presentation and
zero outputs. These are not separate actions and are not fields attached to a functor afterward.

The distinguished pole unit $d_A\in\mathbb C^\times$ remains a genuine pole coordinate of this
action. Its phase and modulus retain the two coordinates at that pole. But the pole-value
specialization alone is not the complete action: replacing `eulerDiskAction A z` by only a
distinguished pole action would truncate the function-valued dependence that the twelve facts
must retain.

### 4.2 — the pole specialization is one coordinate, not the whole action

Board 3's element is

$$
f(z)=c\,\frac{z-w}{1-\bar w z}.
$$

At the shared pole the relevant Möbius specialization has $w=0$: the denominator becomes $1$,
the translation is $0$, and the motion is multiplication by $d_A$. In Lean,
`distinguishedMoebius_zero` (`CayleyDictionary.lean:242`) is that specialization, and the element
is

$$
\texttt{distinguishedPoleElement A} := \texttt{diagonalMoebiusHom}\;(\texttt{A.distinguishedPoleUnit})
\qquad(\texttt{ProjectiveSection.lean:200}).
$$

This coordinate has ordinary multiplicative laws because

$$
\texttt{diagonalMoebiusHom} : \mathbb C^{\times}\longrightarrow\texttt{Moebius}
$$

is a **monoid homomorphism** (`CayleyDictionary.lean:92`). Those laws are part of the green
vehicle. They do not license replacing the complete function-valued action with this single pole
value.

### 4.3 — immediate orbit–stabilizer extension

Every arrow $f$ of the projective base factors by `orbit_stabilizer_factor`:

$$
f=\operatorname{orbitRep}(b')\cdot\operatorname{stab}(f)\cdot\operatorname{orbitRep}(b)^{-1},
$$

with `orbitRep_spec` supplying a representative at every point and `stabilizerPart_id` /
`stabilizerPart_comp` supplying the identity and composition laws. **Both orbit legs are
essential**: they carry the source and target footpoints. The complete function-valued A-action
occupies the distinguished-action position in this fixed vehicle.

After every individual disk fact, that same fact is immediately extended through this
factorization at every object and along every arrow. There is no later batch-transfer phase.

### 4.4 — objects and arrows are accepted together

The orbit–stabilizer construction does not produce a map to be laid over a carrier chosen
elsewhere. Its object frames and arrow transitions are two faces of one action. Thus

$$
\text{ensures that } F.\mathrm{map} \text{ and } F.\mathrm{obj}
\text{ are simultaneously well defined on the whole continuum of groupoids.}
$$

The only accepted functor type is

```lean
sectionFunctor A : GreatCircle.Base ⥤ SphereWorld
```

It is accepted only after Passes 4, 5, 6, 1, 2, 3, 7, 8, 9, 10, and 12 have each completed their
disk proof and immediate global extension, including $N\mapsto N$. No projection,
bundled-groupoid codomain, or intermediary diagram is the A-section functor.

### 4.5 — why this is what makes the theorem run

Each accepted vertical pass makes one of the twelve a native property of A's complete disk action
and simultaneously of its orbit–stabilized object-and-arrow action. The construction therefore
moves only forward:

$$
\text{C1--C4/W/GPV}
\longrightarrow \text{complete disk action}
\longrightarrow \text{row-by-row orbit--stabilized action}
\longrightarrow \texttt{sectionFunctor A : GreatCircle.Base ⥤ SphereWorld}
\longrightarrow \mathcal T_A.
$$

Only after the functor acceptance gate is the exact $\mathcal T_A$ formed. Pass 11 then populates
that total with the C3/C4 outputs. Nothing downstream determines an upstream action definition.

And it is why the finale needs no map hunting. Boards 6–8 do not go looking for a morphism. The
sea has already risen: $\mathcal T_A$ carries the value everywhere, Riehl 8.3.4 reads
$\pi_0(\mathcal T_A)\simeq\operatorname{colim}P_A$ wholesale, and `val` descends the value cocone
that the transports already make compatible. The real number $c$ is plucked, not built. It is a
categorical homotopy theory argument.

## Board 5 — the round trip and the status of the zeros

After the A-section functor has been built, I form its Grothendieck construction:

$$
\mathcal T_A=\int_{\mathcal B}A.
$$

An object of $\mathcal T_A$ is one of the genuine sphere-world value states produced by the
completed action at its projective footpoint. A morphism is a genuine transport from that same
object-and-arrow action. This is the full round trip: takeoff from the base, passage through the
continuum of sphere worlds, and landing at the common witness $N$.

Here I stop and say the sentence a sharp listener must hear:

> **The zero-spheres are outputs. They are populated into the exact total only after functor
> acceptance: C3 supplies the zero states and C4 supplies their infinitude in Pass 11.
> They are never inputs, and they are never assumed concentric.**

C3 tells us which output states are the residue-$\mathbb C$ zeros. C4 tells us that there are
infinitely many of them. Their real centres are still the intrinsic real coordinates of those
output states. No equality between different centres has been assumed or proved at this
stage.

## Board 6 — why the total object was built

The Grothendieck construction is not decorative language for a pointwise analytic proof. If
the argument were merely to compare the zeros two at a time, there would have been no reason
to construct a total category at all.

The reason for $\mathcal T_A$ is the categorical readout

$$
\pi_0(\mathcal T_A)
\simeq
\operatorname*{colim}_{\mathcal B}(\pi_0\circ A).
$$

Riehl’s category-of-elements calculation explains the same quotient relation: every arrow in
the diagram imposes the corresponding identification in every cone, and the colimit is the
universal object carrying all of those identifications. In Lean the certified
`pi0GrothendieckEquiv` is the formal readout. I present these as one mechanism, not as two
successive constructions.

This is the place where the scale changes again. We no longer inspect one local chart or build
one connector between two selected zeros. We allow the colimit to consume the entire arrow
system of the completed A-section functor at once. The continuum was assembled globally, with the
common $N$ already inside the functorial geography. The colimit performs the identifications
forced by that geography wholesale.

## Board 7 — connectedness as transported value, not local topology

Categorical connectedness here is not connectedness of the underlying real line, of the base
space, of an individual fibre, or of an ambient topological space. It is the connectedness
generated by the actual real-value transports carried by $A$.

Riehl’s singleton criterion says that a nonempty connected category has one component. C4
supplies the nonempty populated output, while the completed A-section arrow system supplies the
transport structure meeting at $N$. Therefore the populated image in the colimit has one
class, which I call $\kappa$.

No arrow is selected between zero $n$ and zero $m$. No private copy of $N$ is attached to each
index. No pairwise equality of real parts is proved before the colimit. Those would all replace
the global construction with a hand-built imitation of it.

## Board 8 — the one class is the one real value

The class $\kappa$ is not an abstract component to which I later attach a number. Its elements
were normalized A-section value states because the complete action carried the real level through
the charts and transports before the colimit was formed.

Lean distinguishes the two registers

$$
\kappa:\pi_0(\mathcal T_A),
\qquad
c:\mathbb R,
$$

but mathematically the unique transported value class is

$$
\kappa=\{c\}.
$$

Reading the intrinsic real value of that singleton gives $c$. Every populated C-residue zero
sphere is one of its output states, so every sphere has centre $c$. Therefore all infinitely
many C-residue zero $6$-spheres of an A-section functor are concentric.

That is the theorem. The numerical value of $c$ is not part of it.

## Board 9 — equivalence theorems and corollaries

Only after the Concentricity Theorem is complete do I return to the classical zeta function.
The equivalence theorems identify the residue-$\mathbb C$ zero-spheres with the classically
nontrivial zeros. A separate theorem proves that the octonionic zeta is an A-section. The
functional equation then acts on an already-existing common centre and forces
$c=1-c$, hence $c=\tfrac12$.

This order is essential. The functional equation does not create concentricity. The number
$\tfrac12$ does not occur in the Concentricity Theorem. The Riemann Hypothesis is the
downstream specialization of a theorem found in the geometry of the larger ring.

## Questions to answer before leaving the board

**Did the argument assume the zero-spheres were concentric?**  
No. The zeros enter only after the A-section functor and its total object have been constructed.
They are C3/C4 outputs of the degenerate fibre.

**How is the A-section functor made well-defined?**  
C1–C4/W/GPV determine the complete A-generated action and its native facts. Each fact is then
extended immediately by the already-green Möbius/orbit–stabilizer mechanism. Only after all
vertical passes are accepted is `sectionFunctor A : GreatCircle.Base ⥤ SphereWorld` accepted.

**Are the zeros connected by hand through $N$?**  
No. The completed functor is global on the continuum and carries the common $N$. The
Grothendieck/colimit readout consumes its whole arrow system.

**Is connectedness being smuggled in from the base or the fibres?**  
No. The relevant connectedness is generated by the real-value transports of $A$.

**Why is the finale so short?**  
Because the complete action and all twelve native facts have already been extended over its
objects and arrows. The categorical theorem reads that completed structure.

## Suggested marker register

- **Black:** fixed definitions and theorem statements.
- **Blue:** the green Möbius/orbit–stabilizer vehicle.
- **Green:** the complete C1–C4/W/GPV disk action and each accepted vertical pass.
- **Orange:** the degenerate-fibre zero-spheres, marked explicitly as outputs.
- **Purple:** the Grothendieck construction, $\pi_0$, the colimit, and Riehl’s theorems.
- **Red:** the final readout $\kappa=\{c\}$ and the boundary separating Concentricity from the
  downstream $c=1/2$ corollary.
