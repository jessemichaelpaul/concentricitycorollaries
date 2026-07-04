# Quillen73 - D. Quillen, "Higher algebraic K-theory: I"

## Bibliographic record (verified live 2026-07-02)
- Book chapter (NOT a journal article): Quillen, D. (1973). Higher algebraic K-theory: I. In: Bass, H. (eds) Higher K-Theories. Lecture Notes in Mathematics, vol 341. Springer, Berlin, Heidelberg, pp. 85-147. (Verified live on the Springer chapter landing page, 2026-07-02.)
- DOI: 10.1007/BFb0067053 (chapter landing page https://link.springer.com/chapter/10.1007/BFb0067053, reached 2026-07-02 via Springer's idp.springer.com cookie redirect; page states pages 85-147, Print ISBN 978-3-540-06434-3, Online ISBN 978-3-540-37767-2, publisher Springer Berlin Heidelberg, year 1973, editor H. Bass, series Lecture Notes in Mathematics vol 341).
- arXiv: none (1973 paper, predates arXiv).
- Full text fetched: yes - the Ravenel-hosted scan of the typewritten original, https://www.sas.rochester.edu/mth/sites/doug-ravenel/otherpapers/Quillen-Higher-I.pdf (63 pages, PDF 1.4, downloaded 2026-07-02). The scan carries an OCR text layer that is noisy; every quote below was transcribed from the page IMAGES (rendered at 200 dpi via ghostscript) and cross-checked against the OCR layer.
- Pagination of the scan (see FLAGS): each sheet carries THREE printed numbers - a top-center folio running 77-139, a top-right typescript page number running 1-63, and a bottom-center folio running 85-147. The bottom-center folios match the Springer record (pp. 85-147) and the master bibitem. Locations below give all three.
- R11 note: this is a Springer book-series publication (Lecture Notes in Mathematics 341), not a journal; the published Springer record above was verified live (venue, volume, pages, DOI all resolved on the publisher landing page 2026-07-02). No arXiv version exists, so the journal-only rule is satisfied by the Springer LNM record.
- Transcription conventions: in the typescript, category letters (C, C', I, Ord) are typed with double underlines and theorem/corollary statements are underlined; both are rendered here as plain text. "C'" is the typescript's C-prime; "°" marks the dual/opposite category (typed as a superscript circle, e.g. C°, Ord°); subscripts/superscripts are rendered with _ and ^.

## Pinpointed statements (VERBATIM)

### pi_0(BC) = components of C (unnumbered prose, opening of Section 1)
Location: Section 1 ("The classifying space of a small category"), unnumbered prose; scan sheet 5 of 63; top folio 81; typescript page 5; bottom folio 89.
> Let X be an object of C. Using X to denote also the corresponding 0-cell of BC, we have a family of homotopy groups pi_i(BC,X), i >= 0, which will be called the homotopy groups of C with basepoint X and denoted simply pi_i(C,X). Of course, pi_0(C,X) is not a group, but a pointed set, which can be described as the set pi_0 C of components of the category C pointed by the component containing X. In effect, connected components of BC are in one-one correspondence with components of C.

(Commentary, not citation: this statement is UNNUMBERED in the original - it is prose in the opening pages of Section 1, before Proposition 1. The typescript prints "pi_0 C" for the set of components, with C double-underlined.)

### Proposition 2 and the definitions "homotopy equivalence" / "contractible"
Location: Section 1, subsection "Properties of the classifying space functor"; scan sheet 8; top folio 84; typescript page 8; bottom folio 92.
> Proposition 2. A natural transformation theta : f -> g of functors from C to C' induces a homotopy BC x I -> BC' between Bf and Bg.
>
> In effect, the triple (f,g,theta) can be viewed as a functor C x 1 -> C', where 1 is the ordered set {0 < 1}, and B1 is the unit interval.
>
> We will say that a functor is a homotopy equivalence if it induces a homotopy equivalence of classifying spaces, and that a category is contractible if its classifying space is.

### Corollary 1 of Proposition 2 (adjoint => homotopy equivalence)
Location: immediately after Proposition 2; scan sheet 8; top folio 84; typescript page 8; bottom folio 92.
> Corollary 1. If a functor f has either a left or a right adjoint, then f is a homotopy equivalence.
>
> For if f' is say left adjoint to f, then there are natural transformations f'f -> id, id -> ff', whence Bf' is a homotopy inverse for Bf.

### Corollary 2 of Proposition 2 (initial or final object => contractible)
Location: immediately after Corollary 1; scan sheet 8; top folio 84; typescript page 8; bottom folio 92.
> Corollary 2. A category having either an initial or a final object is contractible.
>
> For then the functor from the category to the punctual category has an adjoint.

(Commentary, not citation: numbering caution - Section 1 contains TWO corollaries numbered "Corollary 2". This one belongs to Proposition 2. The other, "Corollary 2. Any filtering category is contractible.", belongs to Proposition 3 and is printed on scan sheet 9 / top folio 85 / bottom folio 93. Pinpoint cites should therefore say "Prop. 2, Cor. 2", which is also how Quillen himself cites into this cluster - see the Corollary to Theorem A below, whose proof line reads "Prop. 2, Cor. 1".)

### Definitions of Y\f and f/Y (lead-in to Theorem A)
Location: Section 1, subsection "Sufficient conditions for a functor to be a homotopy equivalence"; scan sheet 9; top folio 85; typescript page 9; bottom folio 93.
> Let f : C -> C' be a functor and denote objects of C by X, X', etc. and objects of C' by Y, Y', etc. If Y is a fixed object of C', let Y\f denote the category consisting of pairs (X,v) with v : Y -> fX, in which a morphism from (X,v) to (X',v') is a map w : X -> X' such that f(w)v = v'. In particular, when f is the identity functor of C', we obtain the category Y\C' of objects under Y. Similarly one defines the category f/Y consisting of pairs (X,u) with u : fX -> Y.

### Theorem A, with its dual formulation
Location: scan sheet 9; top folio 85; typescript page 9; bottom folio 93.
> Theorem A. If the category Y\f is contractible for every object Y of C', then the functor f is a homotopy equivalence.
>
> In view of (3), this result admits a dual formulation to the effect that f is a homotopy equivalence when all of the categories f/Y are contractible.

(Commentary, not citation: the dual formulation is printed as prose immediately below the theorem, not as a separately numbered statement. "(3)" is the canonical cellular homeomorphism BC = BC° - see the next entry.)

### Equation (3), referenced by the dual formulation
Location: Section 1, subsection "Properties of the classifying space functor"; scan sheet 7; top folio 83; typescript page 7; bottom folio 91.
> As a particularly interesting example, we note that there is an obvious canonical cellular homeomorphism
>
> (3)  BC = BC°
>
> where C° is the dual category, which is not realized by a functor from C to C° except in very special cases, e.g. groups.

### Definitions: fibre, prefibred/fibred, precofibred/cofibred (lead-in to the Corollary)
Location: scan sheet 9; top folio 85; typescript page 9; bottom folio 93 (between Theorem A's Example and the Corollary).
> Before proving the theorem we derive a corollary. First we recall the definition of fibred and cofibred categories [SGA 1, Exp. VI] in a suitable form. Let f^{-1}(Y) denote the fibre of f over Y, that is, the subcategory of C whose arrows are those mapped to the identity of Y by f. It is easily seen that f makes C a prefibred category over C' in the sense of loc.cit. if and only if for every object Y of C' the functor
>
> f^{-1}(Y) -> Y\f , X |-> (X, id_Y)
>
> has a right adjoint. Denoting the adjoint by (X,v) |-> v^*X, we obtain for any map v : Y -> Y' a functor
>
> v^* : f^{-1}(Y') -> f^{-1}(Y)
>
> determined up to canonical isomorphism, called base-change by v. The prefibred category C over C' is a fibred category if for every pair u,v of composable arrows in C', the canonical morphism of functors u^*v^* -> (vu)^* is an isomorphism. We will call such functors f prefibred and fibred respectively.
>
> Dually, f makes C into a precofibred category over C' when the functors f^{-1}(Y) -> f/Y have left adjoints (X,v) |-> v_*X. In this case the functor v_* : f^{-1}(Y) -> f^{-1}(Y') induced by v : Y -> Y' is called cobase-change by v, and C is a cofibred category when (vu)_* -~-> v_*u_* for all composable u,v. Such functors f will be called precofibred and cofibred respectively.

(Commentary, not citation: "-~->" renders the typescript's arrow surmounted by a tilde, i.e. canonical isomorphism.)

### Corollary to Theorem A (pre(co)fibred with contractible fibres => homotopy equivalence)
Location: scan sheet 9; top folio 85; typescript page 9; bottom folio 93 (unnumbered "Corollary", directly under the definitions above).
> Corollary. Suppose that f is either prefibred or precofibred, and that f^{-1}(Y) is contractible for every Y. Then f is a homotopy equivalence.
>
> This follows from Prop. 2, Cor. 1.

(Commentary, not citation: the printed proof line cites only "Prop. 2, Cor. 1" (the adjoint criterion, which makes f^{-1}(Y) -> Y\f resp. f^{-1}(Y) -> f/Y a homotopy equivalence); the application of Theorem A / its dual is left implicit. The corollary itself is UNNUMBERED - it is "the corollary" to Theorem A, and Quillen refers back to it that way, e.g. "Therefore s and t are homotopy equivalences by the corollary." on scan sheet 10.)

### The bisimplicial realization lemma (three realizations agree)
Location: Section 1, run-up to the proof of Theorem A; scan sheet 10; top folio 86; typescript page 10; bottom folio 94 (unnumbered "Lemma").
Lead-in and setup:
> We now turn to the proof of Theorem A. We will need a standard fact about the realization of bisimplicial spaces which we now derive.
>
> Let Ord be the category of ordered sets p = {0 < 1 < .. < p}, p in N, so that by definition simplicial objects are functors with domain Ord°. The realization functor
>
> (p |-> X_p) |-> |p |-> X_p|
>
> from simplicial spaces to spaces ([Segal 1]) may be defined as the functor left adjoint to the functor which associates to a space Y the simplicial space p |-> Hom(Delta^p, Y), where Hom denotes function space and Delta^p is the simplex having p as its set of vertices. In particular the realization functor commutes with inductive limits.
>
> Let T : p,q |-> T_pq be a bisimplicial space, i.e. a functor from Ord° x Ord° to spaces. Realizing with respect to q keeping p fixed, we obtain a simplicial space p |-> |q |-> T_pq| which may then be realized with respect to p. Also, we may realize first in the p-direction and then in the q-direction, or we may realize the diagonal simplicial space p |-> T_pp. It is well-known (e.g. [Tornehave]) that these three procedures yield the same result:

The Lemma:
> Lemma. There are homeomorphisms
>
> |p |-> T_pp| = |p |-> |q |-> T_pq|| = |q |-> |p |-> T_pq||
>
> which are functorial in the simplicial space T.

(Commentary, not citation: the closing phrase really reads "functorial in the simplicial space T" in the original, although T was introduced two sentences earlier as a BIsimplicial space; transcription is verbatim. Section 1 contains two unnumbered lemmas; this is the first. The second - the quasi-fibration lemma below - is the "lemma below (Th. B)" invoked inside the proof of Theorem A as the alternative to "a basic result of May and Tornehave ([Tornehave, A.3])".)

### The realization/quasi-fibration lemma (used for Theorem B)
Location: Section 1, inside the run-up to the proof of Theorem B; scan sheet 14; top folio 90; typescript page 14; bottom folio 98 (unnumbered "Lemma").
> Lemma. Let i |-> X_i be a functor from a small category I to topological spaces, and let g : X_I -> BI be the space over BI obtained by realizing the simplicial space
>
> p |-> (coproduct over i_0 -> .. -> i_p of) X_{i_0} .
>
> If X_i -> X_{i'} is a homotopy equivalence for every arrow i -> i' in I, then g is a quasi-fibration.

(Commentary, not citation: the display is a disjoint-union symbol (an amalgamated coproduct, typed as a doubled-bar II) indexed underneath by "i_0 -> .. -> i_p", applied to X_{i_0}; the parenthetical rendering above is mine, the symbols are the typescript's.)

## Provenance
- Fetched from:
  - https://www.sas.rochester.edu/mth/sites/doug-ravenel/otherpapers/Quillen-Higher-I.pdf (downloaded 2026-07-02; 4,647,407 bytes, 63 pages, PDF 1.4; a scan of the typewritten original bearing the running title "Higher algebraic K-theory: I / Daniel Quillen" on its first sheet). The embedded OCR text layer is noisy (systematic character damage, e.g. "hOlllotopy"); it was used only to LOCATE statements. All quotes above were transcribed by reading 200-dpi ghostscript renderings of scan sheets 5, 7, 8, 9, 10 and 14, then cross-checked against the OCR layer.
  - https://link.springer.com/chapter/10.1007/BFb0067053 (Springer chapter landing page, fetched 2026-07-02 through Springer's idp.springer.com cookie-redirect chain; yielded the full record quoted in the Bibliographic section: title, author Daniel Quillen (Massachusetts Institute of Technology), editor H. Bass, book "Higher K-Theories", series Lecture Notes in Mathematics vol 341, publisher Springer Berlin Heidelberg, year 1973, pages 85-147, DOI 10.1007/BFb0067053, Print ISBN 978-3-540-06434-3, Online ISBN 978-3-540-37767-2).
  - Web search (to locate the DOI): confirmed the chapter DOI 10.1007/BFb0067053 before resolving the landing page.
- Fetch quality: full text of the paper obtained (scan with page images readable at 200 dpi); publisher metadata obtained from the landing page. The Springer-published PDF itself was NOT fetched (paywalled), so the scan's page-for-page identity with the Springer printing rests on the matching bottom folios (85-147, 63 sheets = 63 pages) - see FLAGS.

## GAPS (author to supply)
- Conference provenance of the volume (the LNM 341 volume is commonly described as the proceedings of the 1972 Battelle Institute conference, Seattle): this appeared only in search-result snippets, not on the resolved Springer landing page, so it is NOT entered in the record above. If the master's bibitem should carry the proceedings note, the author should verify it on the Springer BOOK page (10.1007/BFb0067048) or the printed volume.
- The Springer-published pagination of each quoted statement was inferred from the scan's bottom folios (85-147), which match the Springer page range; direct confirmation against the paywalled Springer PDF was not possible. If pinpoint page cites in print must be beyond doubt, the author should spot-check one page (e.g. Theorem A on p. 93) against a library copy.

## FLAGS
- Master bibitem gloss vs. printed Theorem A. The master bibitem reads, verbatim: "(Theorem~A: a functor whose comma categories are contractible is final and induces an equivalence of classifying spaces)". The printed Theorem A (scan sheet 9; top folio 85; bottom folio 93) reads, verbatim: "Theorem A. If the category Y\f is contractible for every object Y of C', then the functor f is a homotopy equivalence." The printed statement asserts a HOMOTOPY equivalence of classifying spaces and says nothing about the functor being "final"; the word "final" does not occur in Theorem A or its surrounding text (finality-style language enters this repo's pins via Quillen Theorem A's role in later literature, e.g. Riehl CHT sect. 8.3/8.5). Not resolved here; recorded for the author.
- Dual pagination in the fetched scan. Every sheet carries a top-center folio (running 77 on sheet 1 to 139 on sheet 63, verified on sheets 1-16 via the OCR layer and on sheets 5, 7, 8, 9, 10, 14 visually) AND a bottom-center folio (running 85-147, verified on the same sheets: e.g. sheet 9 has top folio 85, typescript page 9, bottom folio 93). The Springer record and the master bibitem both give pp. 85-147, agreeing with the BOTTOM folios. The origin of the 77-139 numbering is unknown to this pass and is not resolved here; all locations above therefore cite all three printed numbers.
