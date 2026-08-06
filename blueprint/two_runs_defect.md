# The two-runs structure is the two-faces error renamed — 2026-08-06

**Author's correction:** each $D_A$ already has the Euler-to-north tape *inside
it*, because the winding has to be included. That was his original concern
about ι.

## Why that undoes what I wrote

$D_A=\operatorname{diskExpAction}(\lambda_A)$ and $\lambda_A$ is the
**logarithm** — the coordinate the winding lives in. So $D_A$ is not a bare
Möbius element that a tape transports; it is built through the lift, and the
tape is inside it.

Consequently there is **one** Euler-to-north, not two runs of one. The two
supplied states are

$$x_N=\bigl((I_1,u_1),\,z_1,\,A_{\OO}(z_1)\bigr),\quad z_1=D_A\!\cdot u_1$$
$$y_N=\bigl((I_2,u_2),\,z_2,\,A_{\OO}(z_2)\bigr),\quad z_2=D_A\!\cdot u_2$$

with the **same** $D_A$ in both middle entries, applied to two different inputs.

## What is therefore wrong in the master, and it is mine

The redrafted lemma currently has

$$\operatorname{eulerToNorth}_1,\ \operatorname{eulerToNorth}_2:0\to N$$
$$r_i=\operatorname{stabilizerPart}(\operatorname{eulerToNorth}_i),\qquad
  R_i=\operatorname{cayleyProjective}(r_i)$$
$$a_A(\operatorname{eulerToNorth}_i)\,a_A(0)=D_A\,R_i \tag{S}$$
$$a_A(\operatorname{eulerToNorth}_i)\cdot\bigl(a_A(0)\cdot u_\ast\bigr)=z_i \tag{B}$$
$$R_1\cdot u_\ast=u_1,\qquad R_2\cdot u_\ast=u_2 \tag{I}$$

**Two subscripted arrows is two faces.** I renamed $k_E,k_W$ to
$\operatorname{eulerToNorth}_1,\operatorname{eulerToNorth}_2$ and believed the
rename fixed it; it changed the labels and kept the structure. (I) then posits
two residual factors and one shared source input — scaffolding for a pair of
transports that does not exist.

## The cost of that error, recorded so it is not repeated

Every attempt to supply (I) reduced to "find a north-stabilizer element
carrying $u_1$ to $u_2$", because (I) says $u_1$ and $u_2$ lie in a common
north-stabilizer orbit. That is why the search kept ending at a transitivity
lemma the author says does not exist and is not needed — **the lemma was
scaffolding for my structure, not his.**

The wall was never in the Lean. It was in the statement I drafted, which I then
transcribed into the Lean and spent an afternoon trying to prove.

## What is open

With one $D_A$ carrying the tape, and two inputs:

- the **direction half** is $G_2$ transitive on the unit imaginary octonions,
  and `zeroSphere_eq_orbit` records that a zero sphere **is** a $G_2$ orbit;
- the **coordinate half** — what relates $u_1$ and $u_2$, or $z_1$ and $z_2$ —
  is not settled, and is not $u_\ast$ plus two runs.

Do not guess it. Four guesses so far, all the same shape: positing a producer
for a structure the author does not have.
