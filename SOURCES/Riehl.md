# Riehl - E. Riehl, "Categorical Homotopy Theory" (CHT)

## Bibliographic record (verified live 2026-07-02)
- Book: Emily Riehl, *Categorical Homotopy Theory*, New Mathematical Monographs, No. 24, Cambridge University Press, 2014 (verified live on the Cambridge Core landing page, 2026-07-02; re-verified 2026-07-03: the page's "Publication date:" row lists 05 June 2014 for the digital edition and 26 May 2014 for the hardback/paperback — CORRECTED 2026-07-03: an earlier revision of this record read "online publication date 26 May 2014", crossing the two; author listed as "Emily Riehl (Harvard University, Massachusetts)", page count 372 pages).
- DOI: 10.1017/CBO9781107261457 (given on the Cambridge Core landing page as https://doi.org/10.1017/CBO9781107261457; fetched 2026-07-02).
- ISBN: print 9781107048454, online 9781107261457 (Cambridge Core landing page, 2026-07-02). The printed copyright page (CUP front-matter PDF, assets.cambridge.org) reads: "ISBN 978-1-107-04845-4 (hardback)", "First published 2014", "Information on this title: www.cambridge.org/9781107048454", Library of Congress line "QA612.7.R45 2015 / 514'.24-dc23 2013049898".
- Free PDF: https://emilyriehl.github.io/files/cathtpy.pdf (the URL in the CLAUDE.md pin), fetched 2026-07-02; 292 PDF pages, full text layer. The author's books page (https://emilyriehl.github.io/books/) carries the arrangement note, as extracted by the fetch tool: "This version is free to view and download for personal use only. Not for re-distribution, re-sale or use in derivative works."
- R11 note: this is a BOOK, not a journal article; the publisher record (CUP, New Mathematical Monographs 24, 2014, ISBNs, DOI above) was verified live and matches the master bibitem. No arXiv version is involved.

## Table of contents confirmations
- Pin check "Part I = Ch. 1-6": confirmed from the free PDF's Contents (PDF pp. vii-viii): "Part I. Derived functors and homotopy (co)limits" comprises Chapter 1 "All concepts are Kan extensions" through Chapter 6 "Homotopy limits and colimits: the practice"; Part II "Enriched homotopy theory" begins with Chapter 7.
- Chapter 8 lines, free PDF Contents (verbatim):
  > Chapter 8. Categorical tools for homotopy (co)limit computations 97
  > 8.1. Preservation of weighted limits and colimits 97
  > 8.2. Change of base for homotopy limits and colimits 99
  > 8.3. Final functors in unenriched category theory 101
  > 8.4. Final functors in enriched category theory 103
  > 8.5. Homotopy final functors 103
- Chapter 8 lines, PRINTED edition Contents (verbatim from the CUP front-matter PDF, assets.cambridge.org):
  > 8 Categorical tools for homotopy (co)limit computations 121
  > 8.1 Preservation of weighted limits and colimits 121
  > 8.2 Change of base for homotopy limits and colimits 124
  > 8.3 Final functors in unenriched category theory 126
  > 8.4 Final functors in enriched category theory 129
  > 8.5 Homotopy final functors 130
- NOTE (commentary, not citation): section NUMBERING agrees between the two versions; PAGINATION does not (see GAPS). Chapter 8 lies in Part II ("Enriched homotopy theory"), not Part I.

## Pinpointed statements (VERBATIM)
All quotes below are from the free PDF (https://emilyriehl.github.io/files/cathtpy.pdf), section 8.3 (book pp. 101-102) and section 8.5 (book pp. 103-105). Each was extracted from the PDF text layer (pypdf) AND verified against a 150-dpi render of the page read as an image. Transcription conventions (commentary): the book prints the category names C, D, M (and the enrichment base V) in script/calligraphic type, transcribed here as plain capitals; "1" below stands for the book's blackboard-bold terminal category; the symbol over the arrows in Definition 8.3.2 is the isomorphism sign, transcribed "->~"; boldface in the original is kept as **bold**.

### Lemma 8.3.1 (colimit reduction to a terminal object; book p. 101)
> Lemma 8.3.1. If D has a terminal object t and F : D -> M, then colim_D F ≅ Ft.

and its third proof (same page):
> Proof 3. The functor t : 1 -> D is a **final functor**, as defined below.

### Definition 8.3.2 (final and initial functors; book p. 101)
> Definition 8.3.2. A functor K : C -> D is **final** if for any functor F : D -> M, the canonical map
> colim_C FK ->~ colim_D F
> is an isomorphism, both sides existing if either does. Dually, K is **initial** if for any F : D -> M, the canonical map
> lim_D F ->~ lim_C FK
> is an isomorphism.

(location: section 8.3, book p. 101 = PDF page 117; the "->~" arrows carry the isomorphism sign ≅, verified on the page render.)

### Remark 8.3.3 (terminology; book p. 101)
> Remark 8.3.3. Final functors were originally called "cofinal," motivated by the notion of a cofinal subsequence (see Example 8.5.2). The terminology used here is the modern categorical consensus, adopted because the directionality of "cofinal" is confusing and the correct dual terminology is even more so.

### Lemma 8.3.4 (slice characterization of finality; book p. 101)
> Lemma 8.3.4. A functor K : C -> D is final if and only if for each d ∈ D, the slice category d/K is non-empty and connected.

(location: section 8.3, book p. 101 = PDF page 117; proof on book p. 102.)

### Remark 8.3.5 (connectedness, zig-zags, and pi_0; book p. 102)
> Remark 8.3.5. A category is **connected** just when any pair of objects can be joined by a finite zig-zag of arrows. Let pi_0 : Cat -> Set be the "path components" functor that sends a category to its collection of objects up to such zig-zags. This functor is left adjoint to the inclusion Set -> Cat, whose right adjoint is the functor that takes a category to its underlying set of objects. A category C is non-empty and connected if and only if pi_0 C is the singleton set.

(location: section 8.3, book p. 102 = PDF page 118, verified on the page render.)

### Section 8.5 lead-in and Definition 8.5.1 (homotopy final; book p. 103)
> Motivated by the definitions in sections 8.3 and 8.4, we introduce the homotopical version of initial and final functors. For this we need a homotopical notion: a simplicial set is **contractible** if the unique map to the terminal object is a weak homotopy equivalence.

> Definition 8.5.1. A functor K : C -> D is **homotopy final** if the simplicial set N(d/K) is contractible for all d ∈ D and **homotopy initial** if each N(K/d) is contractible.

(location: section 8.5, book p. 103 = PDF page 119.)

### Lemma 8.5.3 (initial object gives contractible nerve; book p. 104)
> Lemma 8.5.3. If D is a category with an initial object, then ND is contractible.

### Example 8.5.4 (the translation groupoid; book p. 104)
> Example 8.5.4. Lemma 8.5.3 gives another proof that the space EG defined in Example 4.5.5 is contractible. EG is the geometric realization of the nerve of the **translation groupoid** of the discrete group G. The translation groupoid is the category with elements of G as objects and a unique morphism in each hom-set; the intuition is the map g' -> g'' represents the unique g ∈ G so that gg' = g''. This category is equivalent to the terminal category and in particular has a initial object.

(location: section 8.5, book p. 104 = PDF page 120; "has a initial object" [sic] is as printed in the free PDF, verified on the page render.)

### Lemma 8.5.5 (homotopy final implies final; filtered converse; book p. 104)
> Lemma 8.5.5. If K : C -> D is homotopy final, then K is final. Conversely, if C is filtered and K : C -> D is a final functor, then K is homotopy final.

### Theorem 8.5.6 (homotopy finality; book p. 104)
> Theorem 8.5.6 (homotopy finality). Let F : D -> M be any diagram in a simplicial model category. If K : C -> D is homotopy final, then hocolim_C FK -> hocolim_D F is a weak equivalence.

(location: section 8.5, book p. 104 = PDF page 120; the proof, book p. 105, runs through the bar construction B(*, C, QFK) and concludes by 2-of-3. The text after the proof adds: "An alternate proof of this theorem will be given at the end of section 11.5.")

### Corollary 8.5.8 (Quillen's Theorem A; book p. 105)
> Corollary 8.5.8 (Quillen's Theorem A). If K : C -> D is homotopy final, then NC -> ND is a weak equivalence.

(location: section 8.5, book p. 105 = PDF page 121. Its two-line proof is, verbatim: "A map of simplicial sets is a weak equivalence just when the induced map of geometric realizations is a weak equivalence. But |NC| = B(*, C, *) ≅ hocolim_C *. So the map in question |NC| -> |ND| is just the map between the homotopy colimit of the restricted diagram C -K-> D -*-> Top and the homotopy colimit of * : D -> Top.")

## Provenance
- Fetched from:
  - https://emilyriehl.github.io/files/cathtpy.pdf (the free PDF named in the pin; 1.4 MB, 292 PDF pages, full text layer; downloaded 2026-07-02). Text extracted with pypdf; pages 117-121 (book pp. 101-105) additionally rendered to PNG at 150 dpi via ghostscript and read as images to verify every math symbol quoted above (the text layer drops the isomorphism sign, which the renders restore).
  - https://www.cambridge.org/core/books/categorical-homotopy-theory/556C7A200B521E61466BB7763C49DDA4 (Cambridge Core landing page: title, author, series New Mathematical Monographs No. 24, publication dates: digital 05 June 2014, hardback/paperback 26 May 2014 [corrected 2026-07-03; an earlier revision read "online date 26 May 2014"], print ISBN 9781107048454, online ISBN 9781107261457, DOI 10.1017/CBO9781107261457, 372 pages; fetched 2026-07-02, re-fetched 2026-07-03).
  - http://assets.cambridge.org/97811070/48454/frontmatter/9781107048454_frontmatter.pdf (CUP's own front matter of the PRINTED edition: title page "Categorical Homotopy Theory / EMILY RIEHL / Harvard University", series page "NEW MATHEMATICAL MONOGRAPHS" listing titles 1-23, copyright page, printed table of contents; fetched and text-extracted 2026-07-02).
  - https://emilyriehl.github.io/books/ (the author's books page; yielded the free-PDF arrangement note quoted in the record above; fetched 2026-07-02).
- Fetch quality: full text of the free PDF (primary source for all verbatim quotes, doubly verified text layer + page renders); printed edition verified by front matter only (body pages of the printed edition NOT fetched).
- Re-verified 2026-07-04 (Lane B): independent extraction (pdftotext -layout) plus 140-dpi renders of PDF pp. 117, 120, 121, from the author-supplied repo copy `inbox/cathtpy.pdf` (1,485,199 bytes); every statement quoted above matched verbatim. Quotes unchanged by this pass.

## GAPS (author to supply)
- PRINTED-EDITION PAGE NUMBERS for the quoted statements: the free PDF and the printed CUP edition paginate differently (free PDF: Ch. 8 begins p. 97, section 8.3 p. 101, section 8.5 p. 103; printed ToC: Ch. 8 begins p. 121, section 8.3 p. 126, section 8.5 p. 130). All quotes above cite free-PDF book pages. If pinpoint cites to the printed edition are needed, the printed body pages (paywalled/print-only) must be consulted.
- STATEMENT-NUMBER MATCH against the printed edition: section numbers 8.3/8.4/8.5 agree between the two tables of contents, but the numbering of the individual statements (8.3.2, 8.3.4, 8.5.1, 8.5.5, 8.5.6, 8.5.8) was verified only in the free PDF; the printed edition's body was not fetched, so an exact-match check of statement numbers and wording against the printed text is outstanding.
- The free PDF carries no copyright page and no explicit statement of how it differs from the printed edition; the pagination difference above was observed by comparing the two tables of contents, not asserted by either document.

## FLAGS
- Master bibitem vs. pin, chapter scope. The master bibitem reads (verbatim LaTeX): "\bibitem{Riehl} E.~Riehl, \emph{Categorical Homotopy Theory}, New Mathematical Monographs \textbf{24}, Cambridge University Press, 2014 (the nerve, classifying spaces, the two-sided bar construction, and homotopy colimits; Ch.~1, 4--6)." The CLAUDE.md pin reads: "Riehl, CHT: Part I = Ch. 1-6; finality section 8.3 / section 8.5." The finality material (sections 8.3/8.5) lives in Chapter 8, which the free PDF's Contents places in "Part II. Enriched homotopy theory" - i.e., outside the "Ch. 1, 4-6" span the bibitem parenthetically names. Both sides recorded; not resolved here.
