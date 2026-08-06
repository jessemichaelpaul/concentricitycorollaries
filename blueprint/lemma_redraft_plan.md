# Redraft plan — the transitivity lemma

Author, 2026-08-05: *"the proof in my lemma is very messy and the notation is
mixing up the disk actions, the euler to north action and points in several
locations… KEN is playing a role of a point and the euler to north action all
at once… it's not in a logical order."*

**Not yet drafted. This is the plan, for curation in chat first.**

## 1. The notation collision

Three kinds of object share conventions and slide into one another:

| register | what lives there | current symbols |
|---|---|---|
| **points** | coordinates and directions | $u_\ast$, $u_i$, $z_i$, $I_i$ |
| **elements** | Möbius elements that *act* | $D_A$, $C(r_i)$, $a_A(b)$, $a_A(f)$ |
| **base arrows** | morphisms of $\mathcal B$ | $k_{EN,i}$, $k$, $g$, $h$ |

`k_{EN,i}` is the worst: the subscript names the **construction** (Euler to
north), the symbol is a **base arrow** $0\to N$, and the same phrase names the
**action** two paragraphs earlier. One string, three jobs.

**Proposed:** rename the two transports $e_1,e_2:0\to N$ — "the Euler-to-north
transport of run $i$" — which frees $k$ to mean only the loop
$k=e_1^{-1}\fatsemi e_2:N\to N$. Then $r_i=\operatorname{stabilizerPart}(e_i)$
and $R_i=C(r_i)$, and *Euler to north* stays the name of the construction and
never of a symbol.

## 2. The order collision

- Graph (A) is **used** at `:1532` and only **stated** at `:1589` — fifty lines
  later, after a `\newpage` and a mid-proof restart ("And now we can conjugate
  all of these points of view").
- The pole-datum and nonvanishing material at `:1568–:1587` re-establishes what
  `Definition~\ref{def:base}` already gave, inside the comparison.
- Net effect: the reader meets each object twice, and neither time in place.

## 3. The order he asked for (revised by him, 2026-08-05)

1. **Let.** $\iota_1,\iota_2\in\int\mathcal R_A$ arbitrary. Nothing else.

2. **Display the two.** Side by side, each recalling what built it: index
   $n_i$, direction $I_i$, positioned $z_i=\operatorname{sphereZero}(n_i)$,
   input $u_i=D_A^{-1}\!\cdot z_i$. **Their only difference is the input.**

3. **What built each one**, below that: display

   $$(I,u)\longmapsto \bigl((I,u),\;D_A\!\cdot\!(I,u),\;A_{\OO}(D_A\!\cdot\!(I,u))\bigr)$$

   **twice, one per $\iota$, next to each other**, each carrying its C3
   coordinate, the Euler-to-north action, and the $G_2$ transitivity. The input
   is read off the **middle entry**. Fix the three registers here.

4. **Redisplay the GPV winding passage** — *before* the explanation in 5,
   because a reader will otherwise be confused about how we get squares from
   "one input each" when a real winding is happening by construction:

   > Along an Euler half-space loop $\delta$, $\Gamma_A(t)=\sum_{p\in A.\iota}\ell_p(\delta(t))$
   > and $e^{\Gamma_A(t)}=A(\delta(t))$, with the prime index retained inside
   > the complete summation. Local normal convergence makes $\Gamma_A$
   > continuous, the zero-free half-space makes its value tape lie in
   > $\mathbb C^\times$, and the GPV uniqueness theorem fixes the whole lift
   > once $\Gamma_A(0)$ is chosen. Since $\delta(0)=\delta(1)$, the same prime
   > sum occurs at both endpoints, so its checked winding is $k=0$. At every
   > instant the square `canonicalAsectionPresentation_euler_toNorth` carries
   > this complete prime tape to the common north frame.

5. **The explanation**, in his words: even though we begin with two
   coordinates, **the Euler-to-north winding is the mystery of the critical
   strip**. In the squares above, as $t$ runs from $0$ to $N$,
   orbit–stabilizer is well defined at **all** $t$ up through $N$ — where Euler
   becomes Weierstrass and there is an exact divisor through $N$. That is what
   makes the matrix invertible there, and it is what allows the argument to
   close. Whereas **$G_2$ transitive on unit imaginary octonions is the
   morphism that connects these two C-residue systems.**

6. **(S), (B), (I)** — simpler now, and the display can be cleaner.

7. Then $r=r_2r_1^{-1}$, the loop $k$, (R); $G_2$ for the direction; (Φ) as the
   two components; then $g,h$, (G), fullness, done.

Drops the `\newpage`, the restart sentence, and the pole-datum rebuild — the
last belongs where $D_A$ is first defined, not inside the comparison.

## 3b. Symbol inventory of the lemma body (`:1504–:1800`), measured

| symbol | uses | issue |
|---|---|---|
| `a_A` | 32 | one symbol, two argument kinds — $a_A(b)$ object frame, $a_A(f)$ arrow element. Principled, but never stated |
| `F_A` | 23 | **aliased**: also written $\mathcal A_A$; both live in the lemma |
| `D_A` | 17 | **aliased**: $D=D_A$ introduced at `:1526`, then both used |
| `C` | 17 | **overloaded**: the Cayley matrix, and the homomorphism $C(-)$ |
| `k_{EN,1}`, `k_{EN,2}` | 11 each | a construction's name serving as a base-arrow symbol |
| $u_\ast,u_i,z_i$ | ~30 | points; never separated in prose from the elements acting on them |
| $\iota$ | 4 | the protagonists appear four times in their own lemma |

**Three abbreviations are introduced mid-lemma** — $D=D_A$, $F_A=\mathcal A_A$,
and $C$ — all in the two paragraphs at `:1525–:1530`. That is the shorthand to
remove: this is a constructible proof, so names stay spelled out and compression
happens only at a display that needs it, announced there.

### Naming the transports — `e_i` WITHDRAWN

`e_1,e_2` was my proposal and it is wrong for this paper: `e` occurs nowhere,
so it is a *new* bare letter, which is the very thing being removed. A bare
letter also hides the reason the object exists, and in a constructible proof
every object has one.

**Proposed instead**, spelled out, indexed by the thing that actually differs:

$$\operatorname{eulerToNorth}(\iota_1),\quad
  \operatorname{eulerToNorth}(\iota_2)\;:\;0\longrightarrow N$$
$$r_i=\operatorname{stabilizerPart}\bigl(\operatorname{eulerToNorth}(\iota_i)\bigr)$$

This matches the Lean name `canonicalAsectionPresentation_euler_toNorth`, keeps
*Euler to north* as the name of the **construction** and never of a symbol,
carries the one real difference (the input) in the index, introduces no new
letters, and leaves $k$ free for the loop alone.

## 4. Still open before drafting

- Is $e_1,e_2$ the naming he wants for the two transports (freeing $k$ for the
  loop alone)?
- Should step 5 name $\mathcal T_A$ explicitly as "the total this restricts", or
  stay at the level of the equivariant register?
