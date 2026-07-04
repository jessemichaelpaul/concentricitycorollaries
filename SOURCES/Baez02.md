# Baez02 - J. C. Baez, "The octonions"

## Bibliographic record (verified live 2026-07-02)
- Journal: Bulletin (New Series) of the American Mathematical Society, Volume 39, Number 2, pages 145-205; article electronically published on December 21, 2001; print issue dated April 2002 (Crossref "published print" field). Verified live 2026-07-02 two ways: (a) the front matter of the published PDF served openly by ams.org (transcribed below), and (b) the Crossref record for the DOI.
- DOI: 10.1090/S0273-0979-01-00934-X (verified via api.crossref.org, 2026-07-02: container-title "Bulletin of the American Mathematical Society", author John Baez, volume 39, issue 2, pages 145-205, published online December 21, 2001, published print April 2002, ISSN 0273-0979 print / 1088-9485 electronic, publisher American Mathematical Society).
- Front matter as printed on p. 145 of the published PDF (transcribed from page image):
  > BULLETIN (New Series) OF THE
  > AMERICAN MATHEMATICAL SOCIETY
  > Volume 39, Number 2, Pages 145-205
  > S 0273-0979(01)00934-X
  > Article electronically published on December 21, 2001
  and, footnote on p. 145:
  > Received by the editors May 31, 2001, and in revised form August 2, 2001.
  > 2000 *Mathematics Subject Classification.* Primary 17-02, 17A35, 17C40, 17C90, 22E70.
  with the copyright line "(c)2001 John C. Baez".
- Erratum exists: "ERRATA FOR "THE OCTONIONS"", Bull. Amer. Math. Soc., Volume 42, Number 2, Page 213; S 0273-0979(05)01052-9; article electronically published on January 26, 2005; DOI 10.1090/S0273-0979-05-01052-9 (record located via the Crossref API; full one-page erratum PDF fetched live from ams.org 2026-07-02 and read). Its nine corrections concern pages 146, 171 (twice), 172 (twice), 173, 182, 200 and 203 of the article - NONE touch the pages quoted below (153, 154, 185, 201).
- Master bibitem check: `\bibitem{Baez02} J.~C.~Baez, \emph{The octonions}, Bull.\ Amer.\ Math.\ Soc.\ \textbf{39} (2002), 145--205.` - matches the verified record (2002 = print-issue year).
- R11 note: journal-published; the journal record above was resolved live (Crossref DOI record + AMS-served PDF front matter). The arXiv version (math/0105155) exists but was not used for anything in this file.

## Pinpointed statements (VERBATIM)
Transcription method: the AMS PDF's embedded text layer is unreliable for mathematics (it drops conjugation stars, overbars and minus signs), so every quote below was transcribed by hand from high-resolution page images rendered from the published PDF itself (pages 145, 153, 154, 185, 201 of the article; see Provenance). Printed mathematics is transliterated into LaTeX: blackboard-bold R, C, H, O are written $\mathbb{R},\mathbb{C},\mathbb{H},\mathbb{O}$; Baez's Lie algebras $\mathfrak{g}_2$ and $\mathfrak{der}$ are printed in fraktur; the conjugation symbol is Baez's printed superscript asterisk $^*$; primes and subscripts are as printed.

### Section 2.2 opening - the Cayley-Dickson construction named (p. 153)
> **2.2. The Cayley-Dickson construction.** It would be nice to have a construction of the normed division algebras $\mathbb{R},\mathbb{C},\mathbb{H},\mathbb{O}$ that explained why each one fits neatly inside the next. It would be nice if this construction made it clear why $\mathbb{H}$ is noncommutative and $\mathbb{O}$ is nonassociative. It would be even better if this construction gave an infinite sequence of algebras, doubling in dimension each time, with the normed division algebras as the first four. In fact, there is such a construction: it's called the Cayley-Dickson construction.

(location: Section 2.2, first paragraph, p. 153. The header "The Cayley-Dickson construction." is printed in boldface; "Cayley-Dickson" is printed with an en-dash.)

### Complex numbers as pairs of reals - the un-conjugated doubling formulas (p. 153)
> As Hamilton noted, the complex number $a+bi$ can be thought of as a pair $(a,b)$ of real numbers. Addition is done component-wise, and multiplication goes like this:
> $$(a,b)(c,d) = (ac - db, ad + cb).$$
> We can also define the conjugate of a complex number by
> $$(a,b)^* = (a,-b).$$

(location: Section 2.2, p. 153, immediately after the paragraph above; both displayed equations are unnumbered.)

### The doubling multiplication formula (2) and conjugate formula (3) (pp. 153-154)
> Now that we have the complex numbers, we can define the quaternions in a similar way. A quaternion can be thought of as a pair of complex numbers. Addition is done component-wise, and multiplication goes like this:
> $$(a,b)(c,d) = (ac - db^*, a^*d + cb).\tag{2}$$
> This is just like our formula for multiplication of complex numbers, but with a couple of conjugates thrown in. If we included them in the previous formula, nothing would change, since the conjugate of a real number is just itself. We can also define the conjugate of a quaternion by
> $$(a,b)^* = (a^*, -b).\tag{3}$$

(location: sentence begins at the foot of p. 153 and continues at the top of p. 154; equations (2) and (3) are printed on p. 154 with their equation numbers "(2)" and "(3)" at the left margin. In equation (2) as printed, the conjugation star sits on $b$ in the first component ($db^*$) and on $a$ in the second component ($a^*d$).)

### Octonions as pairs of quaternions; the construction named again (p. 154)
> The game continues! Now we can define an octonion to be a pair of quaternions. As before, we add and multiply them using formulas (2) and (3). This trick for getting new algebras from old is called the **Cayley-Dickson construction**.

(location: p. 154, paragraph immediately after equation (3); "Cayley-Dickson construction" is printed in boldface here.)

### The general Cayley-Dickson step on a $*$-algebra (p. 154)
> To see this clearly, it helps to be a bit more formal. Define a $*$**-algebra** to be an algebra $A$ equipped with a **conjugation**, that is, a real-linear map $*\colon A \to A$ with
> $$a^{**} = a, \qquad (ab)^* = b^*a^*$$
> for all $a,b \in A$.

> Starting from any $*$-algebra $A$, the Cayley-Dickson construction gives a new $*$-algebra $A'$. Elements of $A'$ are pairs $(a,b) \in A^2$, and multiplication and conjugation are defined using equations (2) and (3).

(location: both on p. 154; the first is mid-page ("$*$-algebra" and "conjugation" printed in boldface), the second is the paragraph directly before Proposition 1 at the foot of p. 154.)

### Section 4.1 opening - $\mathrm{G}_2$ is the automorphism group of the octonions (p. 185)
> **4.1. $\mathbf{G_2}$.** In 1914, Elie Cartan noted that the smallest of the exceptional Lie groups, $\mathrm{G}_2$, is the automorphism group of the octonions [14]. Its Lie algebra $\mathfrak{g}_2$ is therefore $\mathfrak{der}(\mathbb{O})$, the derivations of the octonions. Let us take these facts as definitions of $\mathrm{G}_2$ and its Lie algebra and work out some of the consequences.

(location: Section 4.1, first paragraph, p. 185. "Elie" is printed with an acute accent: Élie. $\mathfrak{g}_2$ and $\mathfrak{der}$ are printed in fraktur.)

### Basic triples (p. 185)
> What are automorphisms of the octonions like? One way to analyze this involves subalgebras of the octonions. Any octonion $e_1$ whose square is $-1$ generates a subalgebra of $\mathbb{O}$ isomorphic to $\mathbb{C}$. If we then pick any octonion $e_2$ with square equal to $-1$ that anticommutes with $e_1$, the elements $e_1, e_2$ generate a subalgebra isomorphic to $\mathbb{H}$. Finally, if we pick any octonion $e_3$ with square equal to $-1$ that anticommutes with $e_1, e_2$, and $e_1e_2$, the elements $e_1, e_2, e_3$ generate all of $\mathbb{O}$. We call such a triple of octonions a **basic triple**. Given any basic triple, there exists a unique way to define $e_4, \ldots, e_7$ so that the whole multiplication table in Section 2 holds. In fact, this follows from the remarks on the Cayley-Dickson construction at the end of Section 2.3.

(location: Section 4.1, second paragraph, p. 185; "basic triple" printed in boldface.)

### The $\mathrm{G}_2$ action on the 6-sphere of unit imaginary octonions (p. 185)
> It follows that given any two basic triples, there exists a unique automorphism of $\mathbb{O}$ mapping the first to the second. Conversely, it is obvious that any automorphism maps basic triples to basic triples. This gives a nice description of the group $\mathrm{G}_2$, as follows.
>
> Fix a basic triple $e_1, e_2, e_3$. There is a unique automorphism of the octonions mapping this to any other basic triple, say $e_1', e_2', e_3'$. Now our description of basic triples so far has been purely algebraic, but we can also view them more geometrically as follows: a basic triple is any triple of unit imaginary octonions (i.e. imaginary octonions of norm one) such that each is orthogonal to the algebra generated by the other two. This means that our automorphism can map $e_1$ to any point $e_1'$ on the 6-sphere of unit imaginary octonions, then map $e_2$ to any point $e_2'$ on the 5-sphere of unit imaginary octonions that are orthogonal to $e_1'$, and then map $e_3$ to any point $e_3'$ on the 3-sphere of unit imaginary octonions that are orthogonal to $e_1', e_2'$ and $e_1'e_2'$. It follows that
> $$\dim \mathrm{G}_2 = \dim S^6 + \dim S^5 + \dim S^3 = 14.$$

(location: Section 4.1, third and fourth paragraphs, p. 185. This is the passage that supports "$\mathrm{G}_2$ acts transitively on the unit 6-sphere of imaginary octonions" - transitivity is asserted in the words "can map $e_1$ to any point $e_1'$ on the 6-sphere of unit imaginary octonions". No stabilizer is identified here; see FLAGS.)

### The only SU(3) statement adjacent to this circle of ideas (p. 201, Conclusions)
> - Octonions and the geometry of the 'squashed 7-spheres', that is, the homogeneous spaces $\mathrm{Spin}(7)/\mathrm{G}_2$, $\mathrm{Spin}(6)/\mathrm{SU}(3)$, and $\mathrm{Spin}(5)/\mathrm{SU}(2)$, all of which are diffeomorphic to $S^7$ with its usual smooth structure [21].

(location: Section 5 (Conclusions), p. 201, one bullet item in the "It also includes:" list. Note this is a statement about quotients of Spin groups being 7-spheres; it is NOT the statement $S^6 = \mathrm{G}_2/\mathrm{SU}(3)$.)

## Provenance
- Fetched from (all 2026-07-02):
  - https://www.ams.org/journals/bull/2002-39-02/S0273-0979-01-00934-X/S0273-0979-01-00934-X.pdf - the published article PDF (61 pages, pp. 145-205), downloaded with curl using a browser user agent (the AMS site returns 403/Cloudflare challenges to non-browser clients, including WebFetch).
  - https://api.crossref.org/works/10.1090/S0273-0979-01-00934-X - Crossref record for the article (journal, volume 39, issue 2, pages 145-205, published online 2001-12-21, published print April 2002, ISSN, publisher).
  - https://api.crossref.org/journals/0273-0979/works?query=errata+octonions - located the erratum record: DOI 10.1090/s0273-0979-05-01052-9, "Errata for ``The Octonions''", volume 42, issue 02, published 2005-01-26 (Crossref lists its pages as 213-214; see FLAGS).
  - https://www.ams.org/journals/bull/2005-42-02/S0273-0979-05-01052-9/S0273-0979-05-01052-9.pdf - the one-page erratum PDF, downloaded and read in full (text layer plus page image).
  - https://www.ams.org/journals/bull/2005-42-02/S0273-0979-05-01043-8/S0273-0979-05-01043-8.pdf - fetched while locating the erratum; it is a different item (Baez's book review of Conway-Smith, Bull. AMS 42 (2005), 229-243) and was not used.
  - https://www.ams.org/journals/bull/2002-39-02/S0273-0979-01-00934-X/ - article landing page: 403 via WebFetch; via curl it returns a JavaScript shell without article metadata. Not used; the PDF front matter and Crossref serve as the record instead.
  - A web search (2026-07-02) surfaced the existence of the erratum, which was then verified via Crossref and the AMS PDF as above.
- Fetch quality: FULL published text fetched (primary source, not a secondary rendering). Caveat on the text layer: pypdf extraction of this PDF loses math diacritics (conjugation stars, overbars, minus signs) and mangles spacing, so it was used only for locating passages; all quotes above were transcribed by hand from page images rendered (via qlmanage) from the downloaded PDF at pages 1 (=p. 145), 9 (=p. 153), 10 (=p. 154), 41 (=p. 185) and 57 (=p. 201) of the file. The LaTeX in the quotes is a faithful transliteration of the printed glyphs, not the author's source code.
- Search coverage: the extracted text of all 61 pages was searched for "SU(3)" (case-insensitive), "stabilizer", "transitiv", "unit imaginary", "6-sphere". Occurrences of SU(3): p. 193 (lowercase $\mathfrak{su}(3)$ in the magic-square Lie algebra tables) and p. 201 (bullet quoted above). p. 184 contains the definition of $\mathrm{SU}(n)$ among the classical groups and $\mathfrak{su}(n+1)$, but no literal SU(3) (corrected against a re-fetch: text-layer search plus the p. 184 page image, 2026-07-03). This search ran on the lossy text layer, so a small residual risk of a missed occurrence remains; the whole of Section 4.1 (pp. 185-189) was additionally read page by page and contains no SU(3).

## GAPS (author to supply)
- The pinned stabilizer claim: no statement in Baez02 identifies the stabilizer of a point of the unit 6-sphere of imaginary octonions under the $\mathrm{G}_2$ action as $\mathrm{SU}(3)$ (equivalently $S^6 \cong \mathrm{G}_2/\mathrm{SU}(3)$). If this statement is load-bearing for the formalization, a source that actually prints it is needed - it cannot be cited to Baez02. (Author to choose the source; per R2/R5 it must then get its own SOURCES/ file.)

## FLAGS
- Pin vs. paper: the CLAUDE.md pin reads "Baez (G2 acts on S6, stabilizer SU(3))". Baez02 supports, verbatim (p. 185, quoted above): $\mathrm{G}_2$ is the automorphism group of the octonions (taken as definition), and the unique automorphism carrying one basic triple to another "can map $e_1$ to any point $e_1'$ on the 6-sphere of unit imaginary octonions" - i.e. transitivity of the action on $S^6$, in substance. But NO sentence in the article identifies the stabilizer as $\mathrm{SU}(3)$, and no formula $S^6 = \mathrm{G}_2/\mathrm{SU}(3)$ appears anywhere in it. The only SU(3) statement in the vicinity of these ideas is the p. 201 squashed-7-spheres bullet (quoted verbatim above), which concerns $\mathrm{Spin}(7)/\mathrm{G}_2$, $\mathrm{Spin}(6)/\mathrm{SU}(3)$, $\mathrm{Spin}(5)/\mathrm{SU}(2)$ being diffeomorphic to $S^7$ - a different statement. Both sides are recorded verbatim above; resolution is the author's.
- Minor metadata discrepancy on the erratum: Crossref lists its pages as "213-214", while the erratum's own printed head reads "Volume 42, Number 2, Page 213" and the piece occupies the single page 213.
