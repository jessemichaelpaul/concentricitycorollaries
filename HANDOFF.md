# HANDOFF — current-task opener (replaces ALL earlier handoffs)

Read order: (1) `CLAUDE.md` — rules R1–R11, architecture map, pins; unchanged today, still
ground truth. (2) This file. (3) Nothing else until the task requires it. The settled list
stays settled; do not re-derive the architecture; quote the master, never paraphrase it.

## State (2026-07-02, end of thread 2)

- Working folder = repo: `~/Desktop/concentricity`. Files current: `CLAUDE.md`,
  `Octonionic_RH_master.tex` (v4 + today's deltas), `DEPENDENCY_TABULATION.md` (+ dated
  Delta section), `RECON_MATHLIB.md` (independent live-docs recon), `blueprint/`
  scaffolded, site built once (stale until one rebuild).
- **Claude Code, Step 1** (its own honest completion report): DONE — CLAUDE.md corrections
  as root commit `44ab40cc36d9`; lake project, Mathlib pinned v4.31.0, cache decompressed
  (8542 files); SOURCES/ (empty, .gitkeep); blueprint scaffolded + site built (post-report).
  PENDING — complete `.gitignore` + scaffold commit (include RECON_MATHLIB.md; commit
  message queued in-thread); `gh` installed but **not authenticated**: device-code
  walkthrough → create PRIVATE repo `concentricity` → push → hand over rebuild + serve
  commands **verified by running them**. There is no R12; rules end at R11.
- **Zulip**: account exists (real name, GitHub sign-in); timezone fix to America/New_York
  possibly pending; lurk-only. Community post: none, and none until the gate
  (zero sorries + honest `#print axioms`). Author scrapped the optional early question —
  recon answered it in-house.
- Author state: git/terminal beginner (click-level guidance, one step at a time); GitHub
  account works in browser; wants the local website loop for prose iteration, sphere
  eversion as the clarity model.

## Today's document deltas (applied to BOTH `Octonionic_RH_master.tex` AND `blueprint/src/content.tex`)

1. **NEW `thm:connected-concentric`** ("Connected is concentric: the dictionary"), derived
   register, `\uses{def:base, lem:exp-degenerate}` — statement/proof assembled verbatim
   from existing master sentences. **Machine-verified independent of `thm:concentricity`**
   (neither node in the other's cone; the whole `\uses` graph is a DAG; no orphan refs).
   Consumer: `cor:nontrivial`.
2. **`cor:nontrivial` rewired**: `\uses{thm:concentricity, thm:connected-concentric,
   thm:zero-equivalence, thm:zero-spheres, lem:residue-spheres}`; its proof routes
   one-component→one-centre through the dictionary and **no longer cites the gloss**
   (register fix per R10).
3. **`rmk:collapse-vs-translation`** reduced to a two-sentence pointer (dictionary vs
   application; collapse supplies *one component*, dictionary reads it as *one centre*).
4. **Deleted** from the assembly paragraph of `thm:concentricity`'s proof: the opener
   "The base precedes the section:" — author's ruling: it invited a circular-proof
   misreading. The paragraph now opens at the lemma-tagged fibre fact; C2's Euler product
   does the implying in the very next sentence. **Theorem statement, `\uses`, proof
   otherwise untouched** — cone still 28 nodes.
5. Tabulation: new dictionary row, totals 54 nodes, Delta section records everything.

## Audits on record (mechanical, from v4 `\uses` annotations)

- cone(`thm:concentricity`) = 28 nodes, **all S+T buckets** (spine + slice-preserving/
  octonionic theory). **Zero Z-bucket members**: classical facts (`thm:riemann`,
  `thm:euler`, `thm:hadamard`) enter first at `cor:zeta-section`; translation theorems at
  `cor:nontrivial`/`cor:zeta-section`; `cor:rh` terminal.
- Base cluster and section apparatus (`def:R`, `def:A-section`, `def:section-map`,
  `thm:section-functor`, `thm:identity`, `prop:weierstrass`) are **disjoint below the
  theorem** — they meet first inside `thm:concentricity`. No cycles anywhere.

## Mathlib recon (full report: `RECON_MATHLIB.md`; Step 2 must cross-check per R5)

(a) octonions/Cayley–Dickson **ABSENT** (0 decls) → build CD(ℍ) in-repo per R9.
(b) zeta cluster **RICH** — incl. `riemannZeta_eulerProduct_exp_log` (literally C2's shape)
and Mathlib's formal **`RiemannHypothesis : Prop`** — `cor:rh` should target that exact
declaration. (c) Hadamard factorization + infinitude **ABSENT** (ZetaZeros = discreteness
only) — priciest floor leaf. (d) `Complex.isCoveringMap_exp` + full
liftPath/liftHomotopy/monodromy API **PRESENT** — near-free slice-wise winding floor, as
priced. (e) Weierstrass products absent as theory; convergence machinery present.
(f) `Multipliable`/`tprod` rich; **API caveat: new `SummationFilter` parameter — pin
unconditional/atTop forms in C2/C3 statements.**

## Current task

1. **Finish Step 1** in the Code tab, in this order: rebuild + serve the site NOW (author
   is waiting to read it; both source files changed today) → scaffold commit → GitHub
   device auth (author has never used git; one step at a time) → private repo → push →
   completion report with evidence + the two verified commands.
2. **Paste Step 2** into the Code tab when Step 1 is green — this exact text:

   ```
   Per CLAUDE.md Phase 2–3, but first a reconnaissance report against live
   Mathlib docs (R5), no code yet. Check and report on each: (a) octonions or a
   Cayley–Dickson construction; (b) the riemannZeta cluster — continuation,
   functional equation, Euler product; (c) Hadamard factorization and/or
   infinitude of nontrivial zeros of zeta; (d) Complex.exp as a covering map and
   the path/homotopy lifting API; (e) Weierstrass products for entire functions;
   (f) infinite products (Multipliable/tprod) suitable for C2. For each: exists /
   partial / absent, with declaration names, and the price of building it
   in-repo if absent. Cross-check your recon against RECON_MATHLIB.md already in
   this folder (an independent live-docs pass); flag any disagreement explicitly
   before building. Then build SOURCES/ from the Pins, then the statement layer
   per Phase 3 — structure ASection first — stopping at the placement step per
   the master's TODO.
   ```

   → SOURCES/ from the Pins → statement layer per Phase 3, `structure ASection` first,
   `cor:rh` stated against Mathlib's `RiemannHypothesis`, **stopping at the placement TODO**.
3. **Author's lane**: prose iteration on the served site; the placement sentence — spec is
   the red `\TODO` itself (master line ~1148). Note when writing it: the TODO's phrase
   "the conserved-level readout of Corollary cor:nontrivial" now maps to
   `thm:connected-concentric` (the dictionary node postdates the TODO's wording).

## Failure modes (all prior ones stand) + today's additions

- **Quote, never paraphrase, the assembly paragraph** — the "precedes" incident: a
  one-line paraphrase of the proof twice read as asserting the wrong logical order.
- "Concentric" stays translation-layer; the base is levels + winding; GPV's term is
  *degenerate set*. Never attach metric vocabulary to 𝓑.
- The dictionary (`thm:connected-concentric`) is logically independent of the collapse —
  independence is graph-visible; do not re-fold it into a remark or a corollary of the
  theorem.
- No prose verdicts (R8); `sorry` = unformalized never unsound; the placement sentence is
  the author's alone.
- Posting gate unchanged: **zero sorries + honest `#print axioms`** ("zero axioms" = zero
  project-added leaves; Mathlib's three foundational axioms will always print). Nothing is
  announced until ripe; Mathlib infrastructure (CD(ℍ), Hadamard theory) may be upstreamed
  quietly as self-justifying pieces that reveal no endgame.
