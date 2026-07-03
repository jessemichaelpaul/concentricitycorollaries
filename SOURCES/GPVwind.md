# GPVwind - G. Gentili, J. Prezelj, F. Vlacci, "On a continuation of quaternionic and octonionic logarithm along curves and the winding number"

## Bibliographic record (verified live 2026-07-02)
- Journal: Journal of Mathematical Analysis and Applications, Volume 536, Issue 1, Article 128219, published-print August 2024, ISSN 0022-247X (Crossref registration record for the DOI, fetched 2026-07-02; authors per Crossref: Graziano Gentili, Jasna Prezelj, Fabio Vlacci)
- DOI: 10.1016/j.jmaa.2024.128219 (resolution observed 2026-07-02: 302 redirect to https://linkinghub.elsevier.com/retrieve/pii/S0022247X24001410; the linkinghub page shows only "Redirecting" and the ScienceDirect landing page https://www.sciencedirect.com/science/article/pii/S0022247X24001410 returned HTTP 403, so the journal record above rests on the Crossref API record for this DOI, not on a directly fetched publisher landing page)
- arXiv: 2307.14047 [math.CV], v1 only, submitted Wed 26 Jul 2023; comments "30 pages, 4 figures"; MSC classes 30B99, 32D99. The abs page lists NO "Journal-ref" line, but it does display the related DOI https://doi.org/10.1016/j.jmaa.2024.128219 (fetched 2026-07-02).
- R11 note: journal-published (record above). The master bibitem (`\bibitem{GPVwind}` in Octonionic_RH_master.tex, read 2026-07-03) now carries the journal record J. Math. Anal. Appl. 536 (2024), no. 1, Paper No. 128219, DOI 10.1016/j.jmaa.2024.128219, still followed by the parenthetical "(arXiv:2307.14047)" — that parenthetical is the remaining arXiv reference to drop for a strictly journal-only final bibliography. (An earlier revision of the master cited only "arXiv:2307.14047"; superseded.) CAVEAT: all verbatim excerpts below are from the ar5iv rendering of arXiv v1; whether the statement numbering (2.1, 4.1, 4.7, 4.20, 5.1, 5.2, 5.11, 5.13, 5.21, 5.22) and wording are unchanged in the published JMAA version is UNVERIFIED (publisher full text not fetchable, 403).

## Pinpointed statements (VERBATIM)
All excerpts below are from the ar5iv HTML rendering of arXiv:2307.14047 (v1); mathematics is transcribed from the MathML `alttext` attributes, i.e. the authors' LaTeX as embedded by ar5iv. Throughout the paper $\mathbb{K}$ stands for $\mathbb{H}$ or $\mathbb{O}$.

### Remark 2.1 (pin: the direction I(q) has no continuous extension to R)
> **Remark 2.1.** It is worthwhile noticing that the function $\mathcal{I}$ cannot be extended as a continuous function to any single point of the real axis $\mathbb{R}$ of $\mathbb{K}$. At the same time, if we set $\mathbb{S}(-\pi,\pi)=\{Iy:I\in\mathbb{S},\ y\in(-\pi,\pi)\}$, then the function
> $$\textnormal{Arg}:\mathbb{K}\setminus(-\infty,0]\to\mathbb{S}(-\pi,\pi)$$
> defined as the product
> $$\textnormal{Arg}(q):=\mathcal{I}(q)\arg_{\mathcal{I}}(q)$$
> can be extended (as the zero function) to the positive real axis $\mathbb{R}^{+}$ of $\mathbb{K}$.

(location: Section 2 "Preliminary results"; ar5iv element id `S2.Thmtheo1`.)

### Definition 4.1, lead sentence (context: the lift equation pr1 o Gamma = gamma, path version)
> **Definition 4.1.** Let $\gamma:[a,b]\rightarrow\mathbb{K}\setminus\{0\}$ be a path. Then a path $\Gamma:[a,b]\rightarrow\mathcal{E}_{\mathbb{K}}^{+}$ is a lift of $\gamma$ (to $\mathcal{E}_{\mathbb{K}}^{+}$) if ${\mathrm{pr}_{1}}\circ\Gamma=\gamma$, i.e., if the the following diagram commutes:

(location: Section 4 "Continuation of hypercomplex logarithms along paths"; ar5iv element id `S4.Thmtheo1`. The doubled "the the" is as printed in the ar5iv source (sic). The commutative-diagram display that follows is an xymatrix figure and is omitted here; the equation ${\mathrm{pr}_{1}}\circ\Gamma=\gamma$ is stated explicitly in the sentence quoted. Note the explicit composite equation for the PATH lift lives here, not in Definition 5.11.)

### Definition 4.7 (context: tame PATH = unique companion; see FLAGS on the pin's "Def 4.20/5.2" numbering)
> **Definition 4.7.** . Let $[a,b]\subset\mathbb{R}$ and let $\gamma:[a,b]\rightarrow\mathbb{K}\setminus\{0\}$ be a path.
> A path $\mathfrak{I}^{\gamma}:[a,b]\rightarrow\mathbb{S}/\{\pm\operatorname{Id}\}$ such that $\gamma(t)\in\mathbb{C}_{\mathfrak{I}^{\gamma}(t)}$ for every $t\in[a,b]$ is called a companion of the path $\gamma$.
> If a companion $\mathfrak{I}^{\gamma}$ of the path $\gamma$ exists, then $\gamma$ is called a path with a companion and the pair $(\gamma,\mathfrak{I}^{\gamma})$ is called a path with companion $\mathfrak{I}^{\gamma}$.
> If the path $\gamma$ has a unique companion $\mathfrak{I}^{\gamma}$, then both $\gamma$ and the pair $(\gamma,\mathfrak{I}^{\gamma})$ are called a tame path.

(location: Section 4; ar5iv element id `S4.Thmtheo7`. The stray period opening the body — "**Definition 4.7.** . Let" — is as printed (sic): in the ar5iv HTML the body's italic text node literally begins ". Let"; re-verified against a fresh fetch 2026-07-03.)

### Definition 4.20 (pin: tame = unique companion — the MAP version, for homotopy rectangles)
> **Definition 4.20.** Let $[a,b]\times[c,d]\subset\mathbb{R}^{2}$ and let $F:[a,b]\times[c,d]\rightarrow\mathbb{K}\setminus\{0\}$ be a continuous map.
> A continuous map $\mathfrak{I}^{F}:[a,b]\times[c,d]\rightarrow\mathbb{S}/\{\pm\operatorname{Id}\}$ such that $F(t,s)\in\mathbb{C}_{\mathfrak{I}^{F}(t,s)}$ for every $(t,s)\in[a,b]\times[c,d]$ is called a companion of the map $F$.
> If a companion $\mathfrak{I}^{F}$ of the map $F$ exists, then $F$ is called a continuous map with companion $\mathfrak{I}^{F}$, and $(F,\mathfrak{I}^{F})$ is called a continuous map with companion.
> If the map $F$ has a unique companion $\mathfrak{I}^{F}$, then it is called a tame map.

(location: Section 4; ar5iv element id `S4.Thmtheo20`.)

### Definition 5.1 (context: "obstruction set" / "obstruction parameters", the vocabulary of Cor 5.13)
> **Definition 5.1.** For a path $\gamma:[a,b]\rightarrow\mathbb{K}\setminus\{0\}$ we define the set $T:=\gamma^{-1}(\mathbb{R})$ to be the obstruction set (for the lift of $\gamma$) and its points as obstruction parameters.

(location: Section 5 "Obstructions to the existence of lifts of a path"; ar5iv element id `S5.Thmtheo1`.)

### Definition 5.2 (pin: tameness — the AT-a-parameter version: flip / bounce; see FLAGS)
> **Definition 5.2.** Let the path $\gamma(t)=x(t)+Y(t):[a,b]\rightarrow\mathbb{H}\setminus\{0\}$ be such that $T=\gamma^{-1}(\mathbb{R})=\{a\leq t_{1}<\ldots<t_{p}\leq b\}.$ Consider the limits
> (5.4) $$\lim_{t\rightarrow t_{s}^{\pm}}\frac{Y(t)}{|Y(t)|}.$$
> Let $t_{s}\in(a,b).$ Then
> 1) $\gamma$ is tame at $t_{s}$ if both limits are either equal or opposite. In particular, if these limits are opposite, then the parameter $t_{s}$ is called a flip, whereas if they are the same it is called a bounce;
> 2) $\gamma$ is semi-tame at $t_{s}$ if it is not tame at $t_{s}$ but both limits in (5.4) exist;
> 3) $\gamma$ is not tame at $t_{s}$ if at least one of the limits in (5.4) does not exist.
> If $t_{s}=a$ (resp. $t_{s}=b$) then the path is tame at $t_{s}$ from the right (left) if the right (left) limit in (5.4) exists and not tame in all other cases.
> If, in addition, the path $\gamma$ is closed, we adapt the definition of tameness at the endpoints in the natural way. In particular, $\gamma$ is semi-tame at $a\simeq b$ if it is tame at $a$ from the right and at $b$ from the left. If the limits are the same, then $a\simeq b$ is called a bounce and if they are opposite it is called a flip. In all other cases $\gamma$ is not tame at $a\simeq b.$

(location: Section 5; ar5iv element id `S5.Thmtheo2`. Note the codomain is printed $\mathbb{H}\setminus\{0\}$ (quaternions) in the alttext, not $\mathbb{K}\setminus\{0\}$ — as printed, not my correction. NOTE: this item is a Definition; this paper has no "Remark 5.2" — see FLAGS.)

### Definition 5.11 (pin: the loop lift, pr1 o Gamma = gamma o exp)
> **Definition 5.11.** Let $\gamma:S^{1}\rightarrow\mathbb{K}\setminus\{0\}$ be a continuous loop. Then a continuous function $\Gamma:i\mathbb{R}\rightarrow\mathcal{E}^{+}$ is a lift of $\gamma$ if the following diagram commutes:

The display is an xymatrix commutative square; its ar5iv MathML alttext fragments, in document order (the `\ignorespaces` tokens are ar5iv artifacts of the xy-pic source), are:
> $\textstyle{i\mathbb{R}\ignorespaces\ignorespaces\ignorespaces\ignorespaces\ignorespaces\ignorespaces\ignorespaces\ignorespaces}$ / $\scriptstyle{\exp}$ / $\scriptstyle{\Gamma}$ / $\textstyle{\Gamma(i\mathbb{R})\ignorespaces\ignorespaces\ignorespaces\ignorespaces\subset\mathcal{E}_{\mathbb{K}}^{+}}$ / $\scriptstyle{{\mathrm{pr}_{1}}\mathrm{}}$ / $\textstyle{S^{1}\ignorespaces\ignorespaces\ignorespaces\ignorespaces}$ / $\scriptstyle{\gamma}$ / $\textstyle{\gamma(S^{1})\subset\mathbb{K}\setminus\{0\}}$

(location: Section 5; ar5iv element id `S5.Thmtheo11`. Commentary, not citation: the square has vertices $i\mathbb{R}$, $\Gamma(i\mathbb{R})\subset\mathcal{E}_{\mathbb{K}}^{+}$, $S^{1}$, $\gamma(S^{1})\subset\mathbb{K}\setminus\{0\}$, with arrows $\Gamma$, $\exp$, ${\mathrm{pr}_{1}}$, $\gamma$; its commutativity is the pin's ${\mathrm{pr}_{1}}\circ\Gamma=\gamma\circ\exp$. That composite equation is not printed as a displayed formula inside Definition 5.11 itself; the analogous explicit equation for path lifts, ${\mathrm{pr}_{1}}\circ\Gamma=\gamma$, is printed in Definition 4.1, quoted above.)

### Corollary 5.13 (pin: lift of a loop exists iff signature in {0,-1} between consecutive non-tame obstruction parameters; then a loop)
> **Corollary 5.13.** Let $\gamma:[a,b]\rightarrow\mathbb{K}\setminus\{0\}$ be a continuous loop with $\gamma^{-1}(\mathbb{R})$ nonempty and assume it is not tame at least at one of the obstruction parameters. Let $a=\xi_{1}<\ldots<\xi_{m}=b\simeq a$ are all the obstruction parameters where $\gamma$ is not tame and assume, moreover, that $\gamma(\xi_{k})>0.$ Then a lift of $\gamma$ in $\mathcal{E}^{+}_{\mathbb{K}}$ exists if and only if $\sigma(\gamma|_{[\xi_{l},\xi_{l+1}]})\in\{0,-1\}$ for each $l=1,\ldots,m-1.$ If it exists, the lift is a loop.

(location: Section 5; ar5iv element id `S5.Thmtheo13`. The grammatical anomaly "Let ... are all the obstruction parameters" is as printed (sic) — verified against the raw HTML text nodes. Commentary, not citation: the statement quantifies over the intervals $[\xi_{l},\xi_{l+1}]$ between consecutive non-tame obstruction parameters; the pin's phrase "obstruction interval" is not the paper's wording here — the paper's defined terms are "obstruction set" and "obstruction parameters" (Definition 5.1 above). [Top-up note 2026-07-03: "obstruction intervals" IS a defined term of the paper — Definition 5.15, transcribed in the signature top-up below — but it is not the wording used in the statement of Cor 5.13 itself.])

### Corollary 5.21 (pin: winding = |sigma^c|/2)
> **Corollary 5.21.** Let $\gamma$ be a loop and $\sigma^{c}(\gamma)$ even. Then $\omega(\gamma,{\mathfrak{I}})=|\sigma^{c}(\gamma,{\mathfrak{I}})|/2.$

(location: Section 5; ar5iv element id `S5.Thmtheo21`. Note the printed hypothesis "$\sigma^{c}(\gamma)$ even", which the pin's short gloss omits.)

### Corollary 5.22 (context: the "old 5.22 cite" that the pin says Cor 5.13 supersedes)
> **Corollary 5.22.** Let $\gamma:[a,b]\rightarrow\mathbb{K}\setminus\{0\}$ be a loop with the induced subdivision $a\leq s_{1}<e_{1}\leq s_{2}<e_{2}<\ldots<s_{m}<e_{m}\leq b.$
> Let $1\leq j_{1}<\ldots<j_{k}\leq m$ be the indices for which $\gamma,$ restricted to the neighbourhoods of the intervals $J_{j_{l}}:=[e_{j_{l}},s_{j_{l+1}}]\subset(0,\infty),$ does not have a companion and assume $\gamma$ has a companion on a neighbourhood of the closure of $[a,b]\setminus\cup_{l=1}^{k}J_{j_{l}}.$ Then a lift of $\gamma$ in $\mathcal{E}_{\mathbb{K}}^{+}$ exists if and only if $\sigma(\gamma|_{[s_{j_{l}+1},e_{j_{l+1}}]})\in\{0,-1\}$ for each $l=1,\ldots,m-1.$ If it exists, the lift is a loop.

(location: Section 5; ar5iv element id `S5.Thmtheo22`, the last numbered statement of Section 5.)

### Signature definitions (top-up 2026-07-03)
All excerpts in this subsection were fetched fresh on 2026-07-03 (ar5iv HTML re-downloaded via curl, 3,078,715 bytes; mathematics from MathML `alttext`). They close the GAPS item on the signature $\sigma$ and the coherent signature $\sigma^{c}$: $\sigma$ is Definition 5.7 (finite tame obstruction set) and $\sigma^{c}$ is carried by Definition 5.19 (general case, with respect to a companion), which the paper names the **circular signature** — see FLAGS item 4 on the naming. Definitions 5.15–5.17 and Remark 5.18 are transcribed for self-containedness (Definition 5.19 consumes their vocabulary: induced subdivision, obstruction intervals, sign of an obstruction interval, flip/bounce with respect to a companion).

Lead-in prose immediately before Definition 5.7 (context, ar5iv paragraph id `S5.p10`):
> The proofs of Propositions 5.5 and 5.6 show that once the lift near the initial point is chosen, only the flips are relevant for the determination of the lift near the endpoint; bounces can be discarded. This enables us to calculate the change of argument and the winding number out of local data at the intersections of $\gamma$ with the real axis. To determine the change of the argument we introduce a notion of signature.

#### Definition 5.7 (pin: the signature σ — finite tame obstruction set)
> **Definition 5.7.** Let $\gamma:[a,b]\rightarrow\mathbb{K}\setminus\{0\}$ be a given path with $\gamma^{-1}(\mathbb{R})=\{a\leq t_{1}<\ldots<t_{p}\leq b\}$, with points of $\gamma^{-1}(\mathbb{R})\cap(a,b)$ all tame. Let $a<\xi_{1}<\ldots<\xi_{m}<b$ be those parameters in $\gamma^{-1}(\mathbb{R})$ which are flips. The signature $\sigma(\gamma)$ is defined by
> $$\sigma(\gamma):=\sum_{l=1}^{m}\mathrm{sign}(\gamma(\xi_{l}))(-1)^{l}.$$
> If there are no flips, then we define $\sigma(\gamma):=0.$

(location: Section 5; ar5iv element id `S5.Thmtheo7`. "Flip" here is per Definition 5.2, transcribed above.)

#### Proposition 5.8 (context: what the signature computes — the lift's argument shift)
> **Proposition 5.8.** Let $\gamma:[a,b]\rightarrow\mathbb{K}\setminus\{0\}$ be a tame path with $\gamma^{-1}(\mathbb{R})=\{a_{1}\leq t_{1}<\ldots<t_{p}\leq b\}$ with all the parameters $\gamma^{-1}(\mathbb{R})\cap(a,b)$ tame. Assume that a lift $\Gamma$ of $\gamma|_{[a,t_{1}]}$ in $\mathcal{E}_{\mathbb{K}}^{+}$ exists and equals $\Gamma(t)=(\gamma(t),\textnormal{Arg}_{k_{0}}^{\gamma}(t))\in\mathcal{E}^{+}_{\mathbb{K}},t\in[a,t_{1}]$ for some $k_{0}\in\mathbb{Z}$. Then the lift of $\gamma|_{[t_{p},b)}$ is given by $(\gamma(t),\textnormal{Arg}^{\gamma}_{k_{0}+(-1)^{k_{0}}\sigma(\gamma)}(t)),t\in[t_{p},b).$

(location: Section 5; ar5iv element id `S5.Thmtheo8`. The subscript "$a_{1}$" in "$\{a_{1}\leq t_{1}<\ldots$" is as printed in the alttext (sic) — the parallel formula in Definition 5.7 has plain $a$.)

#### Remark 5.9 (transcribed because the pin's guess list named it; it does NOT carry σ or σᶜ)
> **Remark 5.9.** If $\gamma(b)\in\mathbb{R}$, then a lift of $\gamma$ on $[a,b)$ can be extended continuously to $b$ if and only if $b$ is tame from the left.

(location: Section 5; ar5iv element id `S5.Thmtheo9`.)

Bridge prose introducing the general case (context, ar5iv paragraph id `S5.p21`):
> In the sequel we explain how to extend the notion of signature to paths with infinite obstruction set. Since $\gamma([a,b])$ is compact, there are only finitely many connected components of $\gamma([a,b])\setminus\mathbb{R}$ with endpoints of opposite sign.

#### Definition 5.15 (big arcs, induced subdivision, obstruction intervals)
> **Definition 5.15.** Let $L_{1},\ldots,L_{m}$ be all the connected components of $\gamma([a,b])\setminus\mathbb{R},$ $L_{l}(t)=\gamma(t),t\in(s_{l},e_{l})\subset[a,b]$ satisfying $\gamma(s_{l})\gamma(e_{l})<0$ and $a\leq s_{l}<e_{l}\leq s_{l+1}<e_{m}\leq b$, $l=1,\ldots,m$. We call the components the big arcs and the subdivision $a\leq s_{l}<e_{l}\leq s_{l+1}<e_{m}\leq b$, $l=1,\ldots,m$ the induced subdivision. The intervals $[e_{l},s_{l+1}]$ are called obstruction intervals. If $\gamma$ is closed, then we identify $a$ and $b,$ $e_{0}:=e_{m},s_{m+1}:=s_{1}$ and define also $[e_{0},s_{1}]$ as the obstruction interval.

(location: Section 5; ar5iv element id `S5.Thmtheo15`. The subdivision string "$a\leq s_{l}<e_{l}\leq s_{l+1}<e_{m}\leq b$" — with $e_{m}$, not $e_{l+1}$, as its last interior term — is as printed in the alttext, both times it occurs (sic). This is where the paper defines the term "obstruction intervals" used in the CLAUDE.md pin.)

#### Definition 5.16 (sign of an obstruction interval)
> **Definition 5.16.** If $\gamma([e_{l},s_{l+1}])\cap(-\infty,0)=\varnothing,$ then $\mathrm{sign}([e_{l},s_{l+1}])=1$; otherwise, if $\gamma([e_{l},s_{l+1}])\cap(0,\infty)=\varnothing,$ then $\mathrm{sign}([e_{l},s_{l+1}])=-1.$

(location: Section 5; ar5iv element id `S5.Thmtheo16`.)

#### Definition 5.17 (bounce / flip of an obstruction interval, with respect to a companion)
> **Definition 5.17.** Let $\gamma:[a,b]\rightarrow\mathbb{K}\setminus\{0\}$ be a path with companion $\mathfrak{I}$ with lifts $\pm\mathcal{I}.$ Let $a\leq s_{1}<e_{1}\leq s_{2}<e_{2}<\ldots\leq s_{m}<e_{m}\leq b$ be the induced subdivision and $L_{l}$ the big arcs with limits $I_{l}^{e}$ and $I_{l}^{s},l=1,\ldots,m$.
> The interval $[e_{l},s_{l+1}],1\leq l\leq m-1,$ is a bounce with respect to $\mathfrak{I}$ if $\mathcal{I}$ (or $-\mathcal{I}$) satisfies $\mathcal{I}(e_{l})=\pm I_{j}^{e},\mathcal{I}(s_{l+1})=\pm I_{l+1}^{s}$ and a a flip with respect to $\mathfrak{I}$ if $\mathcal{I}$ (or $-\mathcal{I}$) satisfies $\mathcal{I}(e_{l})=\pm I_{l}^{e},\mathcal{I}(s_{l+1})=\mp I_{l+1}^{s}.$

(location: Section 5; ar5iv element id `S5.Thmtheo17`. Two anomalies as printed (sic), verified against the raw HTML text nodes and alttext: the doubled article "and a a flip" (the text nodes read "and a" + newline + "a flip with respect to"), and the subscript $I_{j}^{e}$ in the bounce clause — $j$, where the flip clause has $I_{l}^{e}$.)

#### Remark 5.18 (context: interval tameness degenerates to point tameness)
> **Remark 5.18.** If $\gamma$ has a companion and $\gamma([e_{l},s_{l+1}])\cap\mathbb{R}$ contains an open set then $\gamma$ always has a companion that makes it a bounce and a companion that makes it a flip. If the interval $[e_{l},s_{l+1}]$ reduces to a point, then the definition of tameness for intervals coincides with the definition of tameness for points.

(location: Section 5; ar5iv element id `S5.Thmtheo18`.)

#### Definition 5.19 (pin: σ(γ,ℑ) with respect to a companion, and the CIRCULAR signature σᶜ(γ,ℑ) — the σᶜ of Cor 5.21)
> **Definition 5.19.** Let $\gamma:[a,b]\rightarrow\mathbb{K}\setminus\{0\}$ be a path with the induced subdivision $a\leq s_{1}<e_{1}\leq s_{2}<e_{2}<\ldots\leq s_{m}<e_{m}\leq b$ and a companion $\mathfrak{I}.$ Let $1\leq j_{1}<\ldots<j_{k}\leq m$ be the indices for which the intervals $[e_{j_{i}},s_{j_{i}+1}]$ are flips. The signature $\sigma(\gamma,{\mathfrak{I}})$ with respect to the companion $\mathfrak{I}$ is defined as
> $$\sigma(\gamma,{\mathfrak{I}}):=\sum_{l=1,j_{k}\neq m}^{k}\mathrm{sign}([e_{j_{l}},s_{j_{l}+1}])(-1)^{l}.$$
> If $\gamma$ is a loop, then we define the circular signature with respect to ${\mathfrak{I}}$ to be
> $$\sigma^{c}(\gamma,{\mathfrak{I}}):=\sum_{l=1}^{k}\mathrm{sign}([e_{l},s_{l+1}]))(-1)^{l}.$$
> If there are no flips, then we define $\sigma(\gamma,{\mathfrak{I}}):=0,\sigma^{c}(\gamma,{\mathfrak{I}}):=0.$

(location: Section 5; ar5iv element id `S5.Thmtheo19`. Three typographical anomalies as printed in the alttext (sic): the flip-index subscript $[e_{j_{i}},s_{j_{i}+1}]$ uses $i$ where the surrounding text enumerates $j_{1}<\ldots<j_{k}$ by $l$; the lower summation limit of $\sigma(\gamma,\mathfrak{I})$ is printed "$l=1,j_{k}\neq m$"; and the $\sigma^{c}$ formula carries a doubled closing bracket "$])$)" — i.e. $\mathrm{sign}([e_{l},s_{l+1}]))$ — and sums over $[e_{l},s_{l+1}]$ with plain $l$, not $[e_{j_{l}},s_{j_{l}+1}]$. Transcribed exactly; no correction applied.)

Prose immediately before Corollary 5.21 (context, ar5iv paragraph id `S5.p26` — the paper's other name for σᶜ):
> To define the winding number for a closed curve we have to take into account also the last interval $I_{m}$ and hence consider the closed signature.

## Provenance
- Fetched from:
  - https://ar5iv.labs.arxiv.org/html/2307.14047 (full HTML, 3.08 MB, downloaded via curl 2026-07-02 into the session scratchpad as `gpvwind_ar5iv.html`; statements extracted from element ids `S2.Thmtheo1`, `S4.Thmtheo1`, `S4.Thmtheo7`, `S4.Thmtheo20`, `S5.Thmtheo1`, `S5.Thmtheo2`, `S5.Thmtheo11`, `S5.Thmtheo13`, `S5.Thmtheo21`, `S5.Thmtheo22`, plus paragraph `S3.p4` for the FLAGS quote; mathematics from MathML `alttext`)
  - https://arxiv.org/abs/2307.14047 (abstract page: title, authors Graziano Gentili, Jasna Prezelj, Fabio Vlacci, v1 submitted Wed 26 Jul 2023 (only version), math.CV, MSC 30B99 32D99, comments "30 pages, 4 figures", no Journal-ref line, related DOI 10.1016/j.jmaa.2024.128219 displayed; fetched 2026-07-02)
  - https://api.crossref.org/works/10.1016/j.jmaa.2024.128219 (Crossref record: container-title "Journal of Mathematical Analysis and Applications", volume 536, issue 1, page/article-number 128219, published-print 2024-08, ISSN 0022-247X, authors Gentili/Prezelj/Vlacci; fetched 2026-07-02)
  - https://doi.org/10.1016/j.jmaa.2024.128219 (302 redirect to https://linkinghub.elsevier.com/retrieve/pii/S0022247X24001410 observed 2026-07-02; linkinghub renders only "Redirecting"; https://www.sciencedirect.com/science/article/pii/S0022247X24001410 returned HTTP 403 — publisher landing page NOT fetched)
  - https://ar5iv.labs.arxiv.org/html/2307.14047 re-fetched 2026-07-03 (full HTML, 3,078,715 bytes, downloaded via curl into the session scratchpad as `gpvwind_ar5iv.html`) for the signature top-up: excerpts extracted from element ids `S5.Thmtheo7`, `S5.Thmtheo8`, `S5.Thmtheo9`, `S5.Thmtheo15`, `S5.Thmtheo16`, `S5.Thmtheo17`, `S5.Thmtheo18`, `S5.Thmtheo19`, plus context paragraphs `S5.p10`, `S5.p21`, `S5.p26`; `S5.Thmtheo21` (Cor 5.21) re-extracted from this fresh fetch and found character-identical to the 2026-07-02 transcription above, even-hypothesis included; mathematics from MathML `alttext`
- Fetch quality: full text of arXiv v1 via ar5iv (statement inventory of every numbered environment enumerated programmatically: Section 5 contains Definitions 5.1, 5.2, 5.7, 5.15, 5.16, 5.17, 5.19; Remarks 5.3, 5.4, 5.9, 5.12, 5.18; Propositions 5.5, 5.6, 5.8, 5.14, 5.20; Corollaries 5.10, 5.13, 5.21, 5.22 — no Remark 5.2 exists). Journal metadata from Crossref only; published JMAA full text not fetched.

## GAPS (author to supply)
- The published JMAA version (J. Math. Anal. Appl. 536 (2024), no. 1, Paper No. 128219) is paywalled (ScienceDirect 403): whether its statement numbering and wording match arXiv v1 (the source of every excerpt above) is unverified.
- CLOSED 2026-07-03: ~~The definitions of the signature $\sigma$ and coherent signature $\sigma^{c}$ consumed by Cor 5.13 / Cor 5.21 (Definition 5.7 and neighbours, per the paper's numbering) were not transcribed here~~ — now transcribed under "### Signature definitions (top-up 2026-07-03)": $\sigma$ is Definition 5.7 (finite tame obstruction set; flip vocabulary from Definition 5.2); $\sigma(\gamma,\mathfrak{I})$ and $\sigma^{c}(\gamma,\mathfrak{I})$ are Definition 5.19 (general case), resting on Definitions 5.15 (obstruction intervals), 5.16 (sign), 5.17 (interval flip/bounce) and Remark 5.18, all transcribed. The paper's printed name for $\sigma^{c}$ is "circular signature" (Def 5.19; "closed signature" in the prose before Cor 5.21) — NOT "coherent signature"; see FLAGS item 4.

## FLAGS
1. Attribution of "Rem. 5.2(a)/(b)" — master bibitem vs this paper's contents. STATUS 2026-07-03: the bibitem text quoted below is from an EARLIER revision of Octonionic_RH_master.tex and is NO LONGER in the master as read 2026-07-03 — see verifier note at the end of this item. The earlier master bibitem for GPVwind read (verbatim then):
   > Cor.~5.21: winding $=|\sigma^c|/2$; Rem.~5.2(b), verbatim: $\exp$ ``has a non-empty degenerate set consisting of spheres''; Rem.~5.2(a): $\pi\circ E=\exp$
   Findings in THIS paper (arXiv:2307.14047, ar5iv full text): (a) there is NO "Remark 5.2"; item 5.2 is **Definition 5.2** (transcribed above — tameness at obstruction parameters, flip/bounce), and Section 5's remarks are 5.3, 5.4, 5.9, 5.12, 5.18; (b) the string "degenerate" occurs ZERO times in the entire ar5iv text; (c) the commuting-triangle equality appears in this paper unnumbered, in Section 3 prose (paragraph after Proposition 3.2, ar5iv paragraph id `S3.p4`), verbatim:
   > Note that if ${\mathrm{pr}_{1}}:\mathbb{K}\times{\rm Im}(\mathbb{K})\to\mathbb{K}$ denotes the projection on the first factor, then by definition the following equality holds ${\mathrm{pr}_{1}}\circ E(q)=\exp(q)$ for all $q\in\mathbb{K}$.
   — i.e. with ${\mathrm{pr}_{1}}$, not $\pi$, and not as a remark. The CLAUDE.md pin instead attributes "Rem 5.2(a)/(b)" (the $\pi\circ E=\exp$ triangle and the degenerate-set sentence) to the OTHER paper, GPV/VS "Slice conformality..." (GPV_pdf.pdf / arXiv:2107.07892). Not resolved here — the master bibitem's "Rem.~5.2(a)/(b)" clauses appear to belong to that other source; author to reconcile.
   [Verifier note 2026-07-03: reconciled in the current master. `\bibitem{GPVwind}` (Octonionic_RH_master.tex, read 2026-07-03) now carries the journal record and cites Rem.~2.1, Def.~4.7 (Def.~4.20 for maps; Def.~5.2: tame/semi-tame at an obstruction parameter), Def.~5.11, Cor.~5.13, Cor.~5.21 — no Rem.~5.2 clause. The "Rem.~5.2(a)"/"Rem.~5.2(b)" citations in the master body now point at `\cite{VS}` (the "Slice conformality" paper), e.g. the commuting-triangle and degenerate-set sentences around master lines 470-472.]
2. Numbering of "tame = unique companion" — pin vs paper. The CLAUDE.md pin reads (verbatim): "Def 4.20/5.2 (tame = unique companion)". In the paper: **Definition 4.20** does define tame via unique companion, but for continuous MAPS on rectangles; the unique-companion definition for PATHS is **Definition 4.7** (both transcribed above); **Definition 5.2** never mentions companions — it defines tame / semi-tame / not tame AT an obstruction parameter via the one-sided limits of $Y(t)/|Y(t)|$ (flip/bounce). Not resolved here — which numbers the master should cite for the tameness package is the author's call.
3. Cor 5.21 hypothesis omitted in the pin. Pin (verbatim): "Cor 5.21 (winding = |sigma^c|/2)". Paper (verbatim, above): "Let $\gamma$ be a loop and $\sigma^{c}(\gamma)$ even. Then $\omega(\gamma,{\mathfrak{I}})=|\sigma^{c}(\gamma,{\mathfrak{I}})|/2.$" — the evenness hypothesis on $\sigma^{c}(\gamma)$ is part of the printed statement. [Re-verified 2026-07-03 against the fresh ar5iv fetch (`S5.Thmtheo21`): transcription character-identical, even-hypothesis present. The FLAG stands.]
4. Naming of $\sigma^{c}$: "coherent signature" is not the paper's term. The task pins and working vocabulary call $\sigma^{c}$ the "coherent signature"; in the paper (arXiv v1 via ar5iv, full-text check 2026-07-03) the printed name is "circular signature with respect to $\mathfrak{I}$" (Definition 5.19, transcribed above), and the prose immediately before Cor 5.21 (paragraph `S5.p26`) calls it "the closed signature". The string "coherent" occurs exactly once in the whole text, in Section 4 prose ("...seems to exclude the possibility of defining coherently a winding number for the loop $\gamma$", the Moebius-strip sentence) — never as a name for $\sigma^{c}$. Author to choose the repo's vocabulary; the paper's is "circular".
