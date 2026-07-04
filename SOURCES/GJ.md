# GJ - P. G. Goerss and J. F. Jardine, "Simplicial Homotopy Theory"

## Bibliographic record (verified live 2026-07-02)
- Book (monograph, not a journal article). Springer landing page verified live 2026-07-02: Title: Simplicial Homotopy Theory. Authors: Paul G. Goerss and John F. Jardine. Series: Modern Birkhäuser Classics. Publisher: Birkhäuser Basel. Year: 2009. XVI, 510 pages.
- DOI: 10.1007/978-3-0346-0189-4 (landing page https://link.springer.com/book/10.1007/978-3-0346-0189-4, reached 2026-07-02 via Springer's idp.springer.com redirect chain; the final page rendered and returned the metadata above).
- ISBN (softcover): 978-3-0346-0188-7; e-ISBN: 978-3-0346-0189-4.
- Edition lineage: the Springer landing page itself gave no explicit prior-edition statement. The lineage is printed in the fetched PDF's own front matter. Title page (PDF p. 4 of 520): "Reprint of the 1999 Edition". Copyright page (PDF p. 5 of 520), verbatim:
  > Originally published under the same title as volume 174 in the Progress in Mathematics series by Birkhäuser Verlag, Switzerland, ISBN 978-3-7643-6064-1 © 1999 Birkhäuser Verlag, P.O. Box 133, CH-4010 Basel, Switzerland
  The same copyright page carries: "© 2009 Birkhäuser Verlag AG", "Library of Congress Control Number: 2009933490", "ISBN 978-3-0346-0188-7 e-ISBN 978-3-0346-0189-4".
- Master bibitem check: "Modern Birkhäuser Classics, Birkhäuser, 2009" — matches the verified record.
- R11 note: this is a published book, not an arXiv preprint; publisher record (series, year, ISBNs, DOI) resolved live 2026-07-02. Journal volume/pages do not apply to a monograph.

## Pinpointed statements (VERBATIM)

All quotes below were transcribed from page images rendered out of the fetched PDF (see Provenance) and cross-checked against the PDF's embedded text layer. In print, C, D, A, P are calligraphic in Ch. I (transcribed as \mathcal{...}), and n, cat, S, Delta are boldface where noted. Mathematics is transcribed in LaTeX.

### Ch. I, Example 1.4 — the nerve / classifying space BC
(location: Section I.1 "Basic definitions", Example 1.4, book p. 5 = PDF p. 20 of 520; page image read visually)

> **Example 1.4.** Suppose that $\mathcal{C}$ is a (small) category. The *classifying space* (or nerve ) $B\mathcal{C}$ of $\mathcal{C}$ is the simplicial set with
> $$B\mathcal{C}_n = \hom_{\mathbf{cat}}(\mathbf{n},\mathcal{C}),$$
> where $\hom_{\mathbf{cat}}(\mathbf{n},\mathcal{C})$ denotes the set of functors from $\mathbf{n}$ to $\mathcal{C}$. In other words an $n$-simplex is a string
> $$a_0 \xrightarrow{\alpha_1} a_1 \xrightarrow{\alpha_2} \dots \xrightarrow{\alpha_n} a_n$$
> of composeable arrows of length $n$ in $\mathcal{C}$.

(Transcription notes, outside the quote: the space before the closing parenthesis in "(or nerve )" is in the printed original; "composeable" is the book's spelling. The nerve is introduced as a numbered Example, not a numbered Definition.)

Immediately following paragraph, same page (gloss on the name "classifying space"):

> We shall see later that there is a topological space $|Y|$ functorially associated to every simplicial set $Y$, called the realization of $Y$. The term "classifying space" for the simplicial set $B\mathcal{C}$ is therefore something of an abuse – one really means that $|B\mathcal{C}|$ is the classifying space of $\mathcal{C}$. Ultimately, however, it does not matter; the two constructions are indistinguishable from a homotopy theoretic point of view.

### Ch. IV, the diagonal simplicial set d(X)
(location: Section IV.1 "Bisimplicial sets: first properties", unnumbered paragraph between Example 1.2 and diagram (1.3), book p. 197 = PDF p. 212 of 520; page image read visually)

> The *diagonal simplicial set* $d(X)$ of a bisimplicial set $X$ has $n$-simplices given by
> $$d(X)_n = X(n,n).$$
> It can also be viewed as the composite functor
> $$\mathbf{\Delta}^{op} \xrightarrow{\Delta} \mathbf{\Delta}^{op}\times\mathbf{\Delta}^{op} \xrightarrow{X} \mathbf{S},$$
> where $\Delta$ is the diagonal functor.

### Ch. IV, Exercise 1.4 — d(X) as a coequalizer (realization presentation)
(location: Section IV.1, Exercise 1.4, book p. 198 = PDF p. 213 of 520; page image read visually)

> **Exercise 1.4.** Show that the resulting diagram
> $$\bigsqcup_{\mathbf{m}\xrightarrow{\theta}\mathbf{n}} X_n\times\Delta^m \rightrightarrows \bigsqcup_{n} X_n\times\Delta^n \xrightarrow{\gamma} d(X)$$
> is a coequalizer in the category of simplicial sets.

Immediately following sentence, same page:

> The exercise implies that the diagonal simplicial set $d(X)$ is a coend in the category of simplicial sets for the data given by all diagrams of the form (1.3).

### Ch. IV, Proposition 1.7 — pointwise weak equivalence implies diagonal weak equivalence
(location: Section IV.1, Proposition 1.7, book p. 199 = PDF p. 214 of 520; page image read visually)

Lead-in sentence, same page:

> Diagrams (1.5) and (1.6) and the gluing lemma (Lemma II.8.8) are the basis of an inductive argument leading to the proof of

> **Proposition 1.7.** Suppose that $f : X \to Y$ is a map of bisimplicial sets which is a pointwise weak equivalence in the sense that all of the maps $f : X_n \to Y_n$ are weak equivalences of simplicial sets. Then the induced map $f_* : d(X) \to d(Y)$ of associated diagonal simplicial sets is a weak equivalence.

### Ch. IV, Example 1.8 with (1.9) — the homotopy colimit as the diagonal of a bisimplicial set
(location: Section IV.1, Example 1.8 and displayed formula (1.9), book p. 199 = PDF p. 214 of 520; page image read visually)

> **Example 1.8.** Any simplicial set-valued functor $Z : I \to \mathbf{S}$ gives rise to a bisimplicial set $BEZ = BE_IZ$, with $(m,n)$-bisimplices
> $$BE_IZ_{m,n} = \bigsqcup_{i_0\to i_1\to\dots\to i_m} Z(i_0)_n. \qquad (1.9)$$
> Note that the indexing is over simplices of degree $m$ in the nerve $BI$ of the category $I$, or equivalently over strings of arrows of length $m$ in $I$.
> The *homotopy colimit* of the functor $Z$ is the diagonal $d(BE_IZ)$; one usually writes $\operatorname{holim}_{\longrightarrow\,I} Z = d(BE_IZ)$.

(Transcription note, outside the quote: the printed hocolim symbol is "holim" with a right arrow set beneath it and subscript $I$ — Goerss-Jardine's notation for the homotopy colimit.)

### Ch. IV, Theorem 5.6 — Quillen's Theorem B
(location: Section IV.5.2 "Theorem B.", Theorem 5.6, book p. 237 = PDF p. 252 of 520; page image read visually)

Lead-in sentence, same page:

> Quillen's Theorem B is the following:

> **Theorem 5.6.** Suppose that $F : C \to D$ is a functor between small categories such that for every morphism $\alpha : y \to y'$ of $D$ the induced simplicial set map $\alpha^* : B(y'\downarrow F) \to B(y\downarrow F)$ is a weak equivalence. Then, for every object $y$ of $D$, the commutative diagram
> $$\begin{array}{ccc} B(y\downarrow F) & \longrightarrow & BC \\ \downarrow & & \downarrow{\scriptstyle F_*} \\ B(y\downarrow D) & \longrightarrow & BD \end{array}$$
> of simplicial set maps is homotopy cartesian.

### Ch. IV, Lemma 5.7 — the homotopy-cartesian detection principle for homotopy colimits
(location: Section IV.5.2, Lemma 5.7 with displayed diagram (5.8), book p. 237 = PDF p. 252 of 520; page image read visually)

Lead-in sentence, same page:

> Theorem B has important applications in algebraic $K$-theory. In some sense, however, one of the steps in its proof is even more important, this being the following result:

> **Lemma 5.7.** Suppose that $X : I \to \mathbf{S}$ is a simplicial set valued functor which is defined on a small category $I$. Suppose further that the induced simplicial set map $X(\alpha) : X(i) \to X(j)$ is a weak equivalence for each morphism $\alpha : i \to j$ of the index category $I$. Then, for each object $j$ of $I$ the pullback diagram of simplicial sets
> $$\begin{array}{ccc} X(j) & \longrightarrow & \operatorname{holim}_{\longrightarrow} X \\ \downarrow & & \downarrow{\scriptstyle\pi} \\ * & \xrightarrow{\ j\ } & BI \end{array} \qquad (5.8)$$
> is homotopy cartesian.

### Ch. IV, proof of Lemma 5.7 — Proposition 1.7 as the working engine
(location: Section IV.5.2, inside the proof of Lemma 5.7, book p. 239 = PDF p. 254 of 520; page image read visually)

> The vertical maps $\theta_*$ induce weak equivalences of associated diagonal simplicial sets, by Proposition 1.7, and the diagonal of the top horizontal map is the weak equivalence
> $$i\times 1 : \Lambda^n_k\times X\sigma(0) \to \Delta^n\times X\sigma(0).$$
> It follows that the map $i_*$ of (5.10) is a weak equivalence. $\square$

## Provenance
- Fetched from:
  - https://www.sas.rochester.edu/mth/sites/doug-ravenel/otherpapers/Goerss-Jardine2.pdf (downloaded 2026-07-02; 2,411,067 bytes, PDF version 1.6, 520 pages). NOT a scan: the file is the Birkhäuser digital edition with a full embedded text layer (title page "Reprint of the 1999 Edition"; copyright page "© 2009 Birkhäuser Verlag AG", Modern Birkhäuser Classics series page present). Book page p corresponds to PDF page p+15 in the body (book p. 5 = PDF p. 20).
  - https://link.springer.com/book/10.1007/978-3-0346-0189-4 (Springer landing page, fetched 2026-07-02 through the idp.springer.com redirect chain; yielded title, authors, series, publisher, year, DOI, both ISBNs, page count "XVI, 510").
- Fetch quality: full for the book (complete PDF). Every quote above was transcribed from a rendered page image (single pages extracted with pypdf, converted to JPEG with macOS sips, read visually), because the embedded text layer, while complete, carries extraction artifacts (spacing breaks such as "o ft h e", run-together words such as "Theclassifying"). The text layer was used for locating statements and as a cross-check only; the images are the transcription source.
- Pages rendered and read visually: PDF pp. 20 (book 5), 212 (book 197), 213 (book 198), 214 (book 199), 252 (book 237), 254 (book 239). Front matter (PDF pp. 3-5: series page, title page, copyright page) read from the text layer, whose extraction on those pages is clean.
- Re-verified 2026-07-04 (Lane B): independent extraction (pdftotext -layout) plus a 140-dpi render of PDF p. 214 (book p. 199), from the author-supplied repo copy `inbox/Goerss-Jardine2.pdf` (2,411,067 bytes — byte-count identical to the 2026-07-02 download); Proposition 1.7, its lead-in sentence, and Example 1.8 with (1.9) matched verbatim. Quotes unchanged by this pass.

## GAPS (author to supply)
- None for the pinned targets: the Ch. I nerve definition and the Ch. IV bisimplicial statements were all fetched and transcribed from page images.
- Note for downstream use (not a fetch gap): GJ Ch. IV supplies the bisimplicial engine only. Printed statements of Quillen's Theorem A and of Thomason's theorem themselves do not exist in this book (see FLAGS) and must come from the Quillen and Thomason79 SOURCES files.

## FLAGS
- Master bibitem parenthetical vs. book content. The master bibitem reads, verbatim: "(Ch.~I: simplicial sets and the nerve; Ch.~IV: the bisimplicial engine behind Theorem~A and Thomason's theorem)". Against the fetched book: a case-sensitive search over the extracted text of all 520 pages (2026-07-02) finds NO occurrence of the string "Theorem A" and NO occurrence of "Thomason" (the only 'homas' hit is "Thomas Gunnarsson", book p. 126, credited for the axiomatic gluing-lemma argument); GJ's References section has no Thomason entry. What Ch. IV actually states is Quillen's Theorem B — Section 5.2 is titled "Theorem B.", opens "Quillen's Theorem B is the following:", and states it as Theorem 5.6 — together with Lemma 5.7 and Proposition 1.7, quoted above. Recorded both sides per instructions; whether "the bisimplicial engine behind Theorem A and Thomason's theorem" is intended as a characterization (GJ provides the machinery, not the named theorems) is left to the author.
