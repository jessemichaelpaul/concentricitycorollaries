# BisiWinkelmann - C. Bisi and J. Winkelmann, "Invariants and Automorphisms for Slice Regular Functions: The Octonionic Case" (arXiv:2411.16762), with companion "Invariants and automorphisms for slice regular functions" (arXiv:2411.15896)

## Bibliographic record (verified live 2026-07-02)
- **Primary paper (the octonionic case), arXiv:2411.16762**: title on abs page "Invariants and Automorphisms for slice regular functions : the octonionic case"; title as typeset in the paper's HTML "Invariants and Automorphisms for Slice Regular Functions: The Octonionic Case"; authors Cinzia Bisi and Joerg Winkelmann; math.CV (+ math.DG, math.GN, math.RA), MSC 30G35; arXiv DOI 10.48550/arXiv.2411.16762. Submission history (abs page, fetched 2026-07-02): "[v1] Sun, 24 Nov 2024 17:32:01 UTC (31 KB) [v2] Fri, 12 Jun 2026 14:51:00 UTC (31 KB)". Comments field verbatim: "arXiv admin note: text overlap with arXiv:2411.15896 Accepted version. All referees' comments included in this version". Journal reference field verbatim (author-supplied, spelling as printed): "Proceedings Royal Society Edinbourgh - Section A - Mathematics (2026)". No journal DOI is given on the abs page.
- **Journal record of the primary paper: PARTIAL.** The arXiv journal-ref (above) indicates acceptance in Proceedings of the Royal Society of Edinburgh, Section A (2026), but as of 2026-07-02 no publisher record is resolvable: a Crossref query filtered to container "Proceedings of the Royal Society of Edinburgh: Section A Mathematics" returned 0 results for Bisi-Winkelmann, and a cambridge.org-restricted web search found no landing page. Volume, pages, and article DOI do not yet exist anywhere I could fetch.
- **Companion paper, arXiv:2411.15896**: title "Invariants and Automorphisms for slice regular functions"; authors Cinzia Bisi, Joerg Winkelmann; v1 only (Sun, 24 Nov 2024 16:11:29 UTC); arXiv DOI 10.48550/arXiv.2411.15896; abs-page journal reference verbatim: "Journal of Noncommutative Geometry, (2025)".
- **Journal record of the companion: VERIFIED.** DOI 10.4171/JNCG/615 resolves (via https://doi.org/10.4171/jncg/615, 302) to https://ems.press/doi/10.4171/jncg/615, EMS Press landing page. Citation line as shown there: "Cinzia Bisi, Jörg Winkelmann, Invariants and automorphisms for slice regular functions. J. Noncommut. Geom. 20 (2026), no. 1, pp. 325–359". Dates on the landing page: submitted 6 February 2024, accepted 9 January 2025, published 11 February 2025. License CC-BY-4.0. Crossref concurs: Journal of Noncommutative Geometry, vol. 20, issue 1, pages 325-359, published 2025-02-11, publisher "European Mathematical Society - EMS - Publishing House GmbH". (Note the abs-page journal-ref year "(2025)" vs the EMS citation-line volume year "20 (2026)": the article went online 11 Feb 2025 inside volume 20, dated 2026.)
- R11 note: the companion satisfies R11 as J. Noncommut. Geom. 20 (2026), no. 1, 325–359, DOI 10.4171/JNCG/615. The primary (octonionic) paper does NOT yet have a resolvable journal record — accepted per its arXiv journal-ref, but venue record (volume/pages/DOI) unverifiable as of 2026-07-02; the master bibitem currently cites it arXiv-only, which R11 forbids in the final bibliography. See GAPS.

## Pinpointed statements (VERBATIM)
All quotes below are transcribed from the arXiv-native LaTeXML HTML of **v2** (the accepted version), https://arxiv.org/html/2411.16762v2, generated 12 Jun 2026; mathematics is transcribed from the MathML `alttext` attributes, i.e. the authors' LaTeX. Element ids are from that HTML. Statement-number differences against v1 are recorded under FLAGS.

### Section 3.2 heading (element id `S3.SS2`)
> 3.2. (Axially) symmetric domains

### Lemma 3.3 (axially-symmetric-domain characterizations; §3.2, element id `S3.Thmlemma3`)
> **Lemma 3.3.** Let $\Omega$ be an open subset of the algebra ${\mathbb{O}}$ of octonions. Let ${\mathbb{S}}_{{\mathbb{O}}}=\{q\in{\mathbb{O}}:q^{2}=-1\}$ . Then the following are equivalent:
> (i) There exists an open subset $D\subset{\mathbb{C}}$ such that $\forall x,y\in{\mathbb{R}}:\forall J\in{\mathbb{S}}_{{\mathbb{O}}}:\ x+yi\in D\quad\iff\quad x+yJ\in\Omega$
> (ii) $\forall J,K\in{\mathbb{S}}_{{\mathbb{O}}}:\forall x,y\in{\mathbb{R}}:x+yJ\in\Omega\ \iff\ x+yK\in\Omega$
> (iii) There is a subset $M\subset{\mathbb{R}}\times{\mathbb{R}}^{+}_{0}$ such that $\Omega=\{q\in{\mathbb{O}}:(\operatorname{{Tr}}(q),\operatorname{{N}}(q))\in M\}$
> (iv) $\Omega$ is invariant under the action of $\mathop{{\rm Aut}}({\mathbb{O}})$ .
> (v) $\Omega$ is invariant under the action of $O(W)$ , the group of orthogonal transformations of $W=\{q\in{\mathbb{O}}:\operatorname{{Tr}}(q)=0\}$ acting naturally on $W$ and acting trivially on ${\mathbb{R}}$ .

(Proof present in the paper, not quoted here; it derives (iii)⟺(iv) and (iv)⟺(v) from Corollary 9.5 and Proposition 9.1.)

### Definition 3.4 (symmetric / axially symmetric; §3.2, element id `S3.Thmlemma4`)
> **Definition 3.4.** (i) A domain $D$ in ${\mathbb{C}}$ is called symmetric if $z\in D\iff\bar{z}\in D.$
> (ii) A domain $\Omega$ in ${\mathbb{O}}$ is called axially symmetric if it satisfies one (hence all) of the properties of Lemma 3.3 .

Sentence immediately following, closing §3.2:
> In the situation of Lemma 3.3 $(i)$ we write $\Omega_{D}=\Omega$ , since $D$ and $\Omega$ are in one-to-one-correspondence.

### Section 3.7 heading and lead-in (element id `S3.SS7`)
> 3.7. Slice preserving functions
> There is a special class of slice (regular) functions which is called “slice preserving”.

### Proposition 3.8 (slice-preserving characterizations; §3.7, element id `S3.Thmlemma8`; = v1's Proposition 3.9)
> **Proposition 3.8.** Let $D\subset{\mathbb{C}}$ be a symmetric domain with associated axially symmetric domain $\Omega_{D}$ . Let $f:\Omega_{D}\to{\mathbb{O}}$ be a slice regular function with stem function $F:D\to{{\mathbb{O}}_{\mathbb{C}}}$ . Then the following are equivalent:
> (i) $f=f^{c}$ ,
> (ii) $F=F^{c}$ ,
> (iii) $F(D)\subset{\mathbb{R}}{\otimes}_{\mathbb{R}}{\mathbb{C}}\subset{\mathbb{O}}{\otimes}_{\mathbb{R}}{\mathbb{C}}={{\mathbb{O}}_{\mathbb{C}}}$ .
> (iv) $f(D\cap{\mathbb{C}}_{I})\subset{\mathbb{C}}_{I}$ for all $I\in{\mathbb{S}}_{{\mathbb{O}}}=\{q\in{\mathbb{O}}:q^{2}=-1\}$ (with ${\mathbb{C}}_{I}={\mathbb{R}}+I{\mathbb{R}}$ ).

### Definition 3.9 (slice preserving; §3.7, element id `S3.Thmlemma9`; = v1's Definition 3.10)
> **Definition 3.9.** If one (hence all) of these properties are fulfilled, $f$ is called “slice preserving”.

Proof of Proposition 3.8 (printed after Definition 3.9) and the closing sentence of §3.7:
> Proof. These equivalences are well known. $(iv)\iff(iii)$ follows from representation formula. $(i)\iff(ii)\iff(iii)$ by construction of $(\ )^{c}$ . ∎
> A slice regular function $f$ which is given by a convergent power series $f(q)=\sum_{k=0}^{+\infty}q^{k}a_{k}$ is slice preserving if and only if all the coefficients $a_{k}$ are real numbers.

### Section 14 heading and lead-in (element id `S14`)
> 14. Vanishing orders
> Here we introduce the notion of “central divisors”. As a preparation for this, we first discuss divisors for vector valued function.

### Definition 14.1 (divisor of a vector-valued map; §14.1 "General maps", element id `S14.Thmlemma1`)
> **Definition 14.1.** Let $F:X\to V={\mathbb{C}}^{n}$ be a holomorphic map from a Riemann surface $X$ to a complex vector space $V={\mathbb{C}}^{n}$ . Assume $F\not\equiv 0$ . The divisor of $F$ is the divisor corresponding to the pull back of the ideal sheaf of the origin, i.e., for $F=(F_{1},\ldots,F_{n})$ , $F_{i}:X\to{\mathbb{C}}$ we have $div(F)=\sum_{p\in X}m_{p}\{p\}$ where $m_{p}$ denotes the minimum of the multiplicities $mult_{p}(F_{i})$ .

### Section 14.2 lead-in (element id `S14.SS2`)
> 14.2. Central divisors
> In [ BW21a ] , Definition 3.1, we introduced the notion of a slice divisor . Here we will need a different notion of divisors. Namely, we need a notion of divisor which measures where a given stem function assumes a value in the center $C_{\mathbb{C}}$ of ${{\mathbb{O}}_{\mathbb{C}}}$ . This we call “ central divisor” .

### Definition 14.4 (central divisor; §14.2, element id `S14.Thmlemma4`)
> **Definition 14.4.** Let ${{\mathbb{O}}_{\mathbb{C}}}={\mathbb{O}}{\otimes}_{R}{\mathbb{C}}$ be the complexification of the octonions with center $C_{{\mathbb{C}}}={\mathbb{R}}{\otimes}_{R}{\mathbb{C}}\simeq{\mathbb{C}}$ . $D\subset{\mathbb{C}}$ a domain, $F:D\to{{\mathbb{O}}_{\mathbb{C}}}$ a holomorphic map. Assume $F(D)\not\subset C_{{\mathbb{C}}}$ . The central divisor $\mathop{cdiv}(F)$ is defined as the divisor (in the sense of Definition 14.1 ) of the map from $D$ to ${{\mathbb{O}}_{\mathbb{C}}}/C_{{\mathbb{C}}}$ .

Text immediately following (still §14.2, containing display (14.1)):
> Let $W$ denote the space of imaginary octonions, i.e., $W=\{q\in{\mathbb{O}}:\operatorname{{Tr}}(q)=0\}$ Then ${{\mathbb{O}}_{\mathbb{C}}}=C_{{\mathbb{C}}}\oplus\left({W{\otimes}_{\mathbb{R}}{\mathbb{C}}}\right)$ and we can decompose $F:D\to{{\mathbb{O}}_{\mathbb{C}}}$ as
> (14.1) $F=(F^{\prime},F^{\prime\prime}):D\to C_{{\mathbb{C}}}\times({W{\otimes}_{\mathbb{R}}{\mathbb{C}}})$
> and the central divisor $\mathop{cdiv}(F)$ equals $\sum_{p\in D}n_{p}\{p\}$ where $n_{p}$ denotes the vanishing order of $F^{\prime\prime}$ at $p$ .

### Caveat and Example 14.6 (non-functoriality of cdiv; §14.2, element id `S14.Thmlemma6`)
> Caveat: These central divisors do not satisfy the usual functoriality:
> **Example 14.6.** Let $F(z)=1+i{\otimes}z,\quad H(z)=1+j{\otimes}(1+z)$ Then $\mathop{cdiv}(F)=1\cdot\{0\}$ and $\mathop{cdiv}(H)=1\cdot\{-1\}$ , but $\mathop{cdiv}(FH)=\mathop{cdiv}(1+i{\otimes}z+j{\otimes}(z+1)+k{\otimes}(z^{2}+z)$ is empty. Thus $\mathop{cdiv}(FH)\neq\mathop{cdiv}(F)+\mathop{cdiv}(H).$ (This is an example for ${\mathbb{H}}$ , first presented in [ BW26 ] . But of course, ${\mathbb{H}}$ is a subalgebra of ${\mathbb{O}}$ , so it is an example for the octonions as well.)

(Transcription note: the unbalanced parenthesis in "$\mathop{cdiv}(1+i{\otimes}z+j{\otimes}(z+1)+k{\otimes}(z^{2}+z)$" is literally what the alttext/LaTeX says — the closing parenthesis of $\mathop{cdiv}(\ldots)$ is missing in the source.)

### Section 14.3, complete (central divisor for slice functions; element id `S14.SS3`)
> 14.3. Central divisor for slice functions
> Let $f$ be a not slice-preserving slice regular function with associated stem function $F$ . Then we may simply define $\mathop{cdiv}(f)$ as $\mathop{cdiv}(f)\stackrel{{\scriptstyle def}}{{=}}\mathop{cdiv}(F)$ Note that for a slice regular function $f$ on an axially symmetric domain $\Omega_{D}$ its central divisor $\mathop{cdiv}(f)$ is a divisor on $D$ (and not on $\Omega_{D}$ ).

### The I-independent lift (the stem-function square; §1 Introduction, paragraph element id `S1.p8`, diagram element id `S1.Ex3`)
> Let us denote the elements of ${{\mathbb{O}}_{\mathbb{C}}}$ as $a+\iota b$ where $a,b\in{\mathbb{O}}$ and $\iota$ is to be considered as the imaginary unit of $\mathbb{C}$ distinguished by the $i$ that appears in the usual basis for ${\mathbb{O}}$ . For any slice regular function $f:{\mathbb{O}}\to{\mathbb{O}}$ , and for any $I\in{\mathbb{S}}_{\mathbb{O}}$ , (with ${\mathbb{S}}_{\mathbb{O}}=\{x\in{\mathbb{O}}:x^{2}=-1\}$ ) the restriction $f\colon\mathbb{C}_{I}\to{\mathbb{O}}$ can be lifted through the map $\phi_{I}\colon{\mathbb{O}}_{\mathbb{C}}\to{\mathbb{O}}$ , $\phi_{I}(a+\iota b):=a+Ib$ to a map ${\mathbb{C}}\cong{\mathbb{C}}_{I}\to{{\mathbb{O}}_{\mathbb{C}}}$ and it turns out that the lift does not depend on $I.$ In other words, there exists a holomorphic function $F\colon\mathbb{C}\to{{\mathbb{O}}_{\mathbb{C}}}$ which makes the following diagram commutative for all $I\in{\mathbb{S}}_{{\mathbb{O}}}.$

The diagram (element id `S1.Ex3`) is a tikz picture rendered as SVG; it has no single alttext. Its four node labels (each its own MathML element, alttext verbatim, in source order): `{\mathbb{C}}`, `{{{\mathbb{O}}_{\mathbb{C}}}}`, `{{\mathbb{O}}}`, `{{\mathbb{O}}}`; its four arrow labels: `\scriptstyle{F}`, `\scriptstyle{\phi_{I}}`, `\scriptstyle{\phi_{I}}`, `\scriptstyle{f}`. From the SVG geometry (commentary, not quote): it is a square with ${\mathbb{C}}$ top-left, ${\mathbb{O}}_{\mathbb{C}}$ top-right, ${\mathbb{O}}$ bottom-left, ${\mathbb{O}}$ bottom-right; the top horizontal arrow (labelled $F$) points right, the two vertical arrows (each labelled $\phi_{I}$) point down, the bottom horizontal arrow (labelled $f$) points right. Commutativity of this square is the identity $\phi_{I}\circ F=f\circ\phi_{I}$ on ${\mathbb{C}}$.

Sentence immediately following the diagram (same paragraph):
> Conversely if a function $f:{\mathbb{O}}\to{\mathbb{O}}$ admits such a lift, it is slice regular.

## Provenance
- Fetched from:
  - https://arxiv.org/abs/2411.16762 (abs page, fetched twice 2026-07-02: once via WebFetch summary, once via curl for the verbatim metadata fields — dateline, comments, journal-ref, submission history quoted above)
  - https://arxiv.org/html/2411.16762v2 (arXiv-native LaTeXML HTML of v2, "Generated on Fri Jun 12 14:47:32 2026 by LaTeXML (version 0.8.8)"; downloaded 2026-07-02; ALL quotes above are from this file, math from MathML alttext; element ids as cited)
  - https://ar5iv.labs.arxiv.org/html/2411.16762 (ar5iv rendering, "Generated on Thu Dec 5 14:50:11 2024" — i.e. it renders v1, NOT v2; downloaded 2026-07-02 and used only for the v1-vs-v2 comparison recorded under FLAGS)
  - https://arxiv.org/pdf/2411.16762v2 (v2 PDF, 16 pages, downloaded 2026-07-02; not text-extracted — no PDF text tooling available in this environment; not used for quotes)
  - https://arxiv.org/abs/2411.15896 (companion abs page: title, authors, v1-only history, journal-ref "Journal of Noncommutative Geometry, (2025)"; fetched 2026-07-02)
  - https://doi.org/10.4171/jncg/615 -> https://ems.press/doi/10.4171/jncg/615 (EMS Press landing page for the companion: citation line "J. Noncommut. Geom. 20 (2026), no. 1, pp. 325–359", submitted/accepted/published dates; fetched 2026-07-02)
  - https://api.crossref.org/works?query.bibliographic=... (Crossref REST API, 2026-07-02: confirms the companion record — JNCG vol. 20, issue 1, pp. 325-359, published 2025-02-11, DOI 10.4171/jncg/615, EMS publisher; returns NO record for the octonionic paper in Proceedings of the Royal Society of Edinburgh Section A)
  - Web search restricted to cambridge.org for the octonionic paper's landing page: no hit (2026-07-02).
- Fetch quality: full HTML text of both arXiv versions of the primary paper (v2 used for quotes, v1 for comparison); metadata-level for both abs pages and the EMS landing page; the journal-typeset texts (JNCG for the companion, PRSE-A for the primary) NOT fetched.
- Version note: the quotes are from arXiv v2, which the abs-page comments field declares to be the accepted version ("Accepted version. All referees' comments included in this version"). Statement numbering in the eventual PRSE-A typeset version is unverified.

## GAPS (author to supply)
- Journal record of the primary paper (arXiv:2411.16762) for the R11 bibliography: the arXiv journal-ref says "Proceedings Royal Society Edinbourgh - Section A - Mathematics (2026)" (sic — "Edinbourgh" as printed), but no volume, page range, article DOI, or publisher landing page is resolvable as of 2026-07-02 (Crossref: 0 results in that container; no cambridge.org landing page found). Needed: the final PRSE-A citation (volume/pages/DOI) once registered — until then this entry cannot be made journal-only.
- The journal-typeset text of either paper: not fetched (JNCG article is CC-BY on ems.press but only the landing page was fetched; PRSE-A version does not exist publicly yet). Whether the printed statement numbers (Lemma 3.3, Definition 3.4, Proposition 3.8, Definition 3.9, Definitions 14.1/14.4) survive the journal typesetting is unverified; all locations above are relative to arXiv v2.
- The companion paper (arXiv:2411.15896 = J. Noncommut. Geom. 20 (2026), 325-359) was verified for metadata only; its (quaternionic/Clifford) counterparts of the pinned statements were not transcribed — the pin targets the octonionic paper.

## FLAGS
- **The lift identity as printed vs as pinned.** The master bibitem says the source "Supplies the $I$-independent lift $\phi_I\circ F=A\circ\phi_I$ (the slice projection)". The paper never prints the composite equation "$\phi_{I}\circ F=\ldots\circ\phi_{I}$" inline, and never uses the symbol $A$ for the function or the name "slice projection" for $\phi_I$ (in §1 it says $f$ "can be lifted through the map $\phi_{I}\colon{\mathbb{O}}_{\mathbb{C}}\to{\mathbb{O}}$"). What is actually printed (§1, `S1.p8`/`S1.Ex3`, quoted in full above) is: the prose "…the restriction $f\colon\mathbb{C}_{I}\to{\mathbb{O}}$ can be lifted through the map $\phi_{I}\colon{\mathbb{O}}_{\mathbb{C}}\to{\mathbb{O}}$ , $\phi_{I}(a+\iota b):=a+Ib$ … and it turns out that the lift does not depend on $I.$" plus the commutative square with arrows $F$, $\phi_{I}$, $\phi_{I}$, $f$, whose commutativity reads $\phi_{I}\circ F=f\circ\phi_{I}$. Content matches under $A\leftrightarrow f$; the printed form is a diagram with $f$, not an inline equation with $A$. Not resolved here.
- **v1 vs v2 statement numbering in §3.7.** The ar5iv rendering (= v1) numbers the slice-preserving statements Proposition 3.9 and Definition 3.10; v2 (accepted version, quoted above) numbers them Proposition 3.8 and Definition 3.9 (v1's Proposition 3.6 in §3.3 was dropped, shifting subsequent §3 numbers down by one; §3.2's Lemma 3.3/Definition 3.4 are unchanged). Any pointer to "Prop 3.9"/"Def 3.10" is v1-relative and breaks against v2.
- **v1 vs v2 wording in §14.** v1's Definition 14.4 begins "Let ${{\mathbb{O}}_{\mathbb{C}}}$ be a ${\mathbb{C}}$ -algebra, $C_{{\mathbb{C}}}$ a central subalgebra."; v2's begins "Let ${{\mathbb{O}}_{\mathbb{C}}}={\mathbb{O}}{\otimes}_{R}{\mathbb{C}}$ be the complexification of the octonions with center $C_{{\mathbb{C}}}={\mathbb{R}}{\otimes}_{R}{\mathbb{C}}\simeq{\mathbb{C}}$ ." (statement number 14.4 unchanged). v1's §14.3 opens "Let $f$ be a slice function with associated stem function $F$ ."; v2 opens "Let $f$ be a not slice-preserving slice regular function with associated stem function $F$ ." In Example 14.6 the internal citation changed from "[ BW23 ]" (v1) to "[ BW26 ]" (v2).
- **Master bibitem currency.** The master bibitem cites the primary as "arXiv:2411.16762 (2024)" with no journal; the abs page now (2026-07-02) shows v2 marked "Accepted version" with journal-ref "Proceedings Royal Society Edinbourgh - Section A - Mathematics (2026)". The bibitem's claim that the companion arXiv:2411.15896 is "in J.~Noncommutative Geometry (EMS)" is VERIFIED (J. Noncommut. Geom. 20 (2026), no. 1, pp. 325–359, DOI 10.4171/JNCG/615). The pin's section numbers §3.2/§3.7/§14 match the paper in both arXiv versions — no discrepancy at section granularity.
