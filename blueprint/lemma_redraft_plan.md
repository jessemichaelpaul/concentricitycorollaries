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

## 3. The order he asked for

1. **Let.** $\iota_1,\iota_2\in\int\mathcal R_A$ arbitrary. Nothing else.
2. **What built each one.** The equivariant functor supplies the input; $F_A$
   records $\bigl((I,u),\,D_A\!\cdot\!(I,u),\,A_{\OO}(D_A\!\cdot\!(I,u))\bigr)$
   — state (A) *here*, once, and read the input off its **middle entry**. Fix
   the three registers in one place.
3. **Display the two.** $\iota_1,\iota_2$ side by side, each recalling what
   built it: index $n_i$, direction $I_i$, positioned $z_i=\operatorname{sphereZero}(n_i)$,
   input $u_i=D_A^{-1}\!\cdot z_i$. **Their only difference is the input.**
4. **What connects them is what produced the total.** The A-section equivariant
   register — the thing that swept out $\mathcal T_A$ — restricted to the
   zero-sphere locus. State this *before* constructing anything.
5. **Construct the morphism.** (S) → (B) → (I) → $r=r_2r_1^{-1}$ → $k$ and (R)
   for the coordinate; $G_2$ transitive on $S^6$ for the direction; (Φ) as the
   two components. Then $g,h$, (G), fullness, done.

Drops the `\newpage`, the restart sentence, and the pole-datum rebuild — the
last belongs where $D_A$ is first defined, not inside the comparison.

## 4. Open for his call before drafting

- Is $e_1,e_2$ the naming he wants for the two transports?
- Should step 4 name $\mathcal T_A$ explicitly as "the total this restricts", or
  stay at the level of the equivariant register?
