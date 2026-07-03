# HANDOFF — current-task opener (replaces ALL earlier handoffs)

Read order: (1) `CLAUDE.md` — rules R1–R11, architecture map, pins (pins updated today:
VS entry now carries the journal record and points to SOURCES/VS.md; GPVwind entry carries
the JMAA record and the corrected tameness numbering). (2) This file. (3) Nothing else until
the task requires it. The settled list stays settled; quote the master, never paraphrase it.

## State (2026-07-02, end of thread 3)

* Repo `~/Desktop/concentricity` = private GitHub `jessemichaelpaul/concentricity`;
  commit-to-main only, **no PRs** (standing ruling; `/create-pr` fired twice by accident —
  always discard). Site loop: `./rebuild.sh` then Cmd+R; `leanblueprint serve` if stopped.
* **Lean: `Concentricity/Octonion.lean` COMPLETE** — CD(ℍ) construction per R9, all four
  closures committed (`61fd9f8` normSq_mul via Degen, convention checked 8/8; `bb33245`
  imaginary-sphere square; `2f3b749` alt_left; `060f7c4` alt_right). Sorry count 0, zero
  axioms, zero project leaves. No other Lean exists yet (`Basic.lean` is a stub).
* **Recon gate PASSED** (Code-tab pass cross-read against RECON_MATHLIB.md plus independent
  grep audit in the map thread). Binding resolutions: statement layer cites **pin-present
  names only** (Mathlib v4.31.0 = commit fabf563a); the deck-group block
  (liftPathQuotient etc.) is post-pin — backport priced ~300 lines, not built;
  `monodromyFunctor` IS pin-present (Topology/Homotopy/Lifting.lean:394); `windingNumber`
  absent everywhere — ~200–300 lines in-repo when needed; `SummationFilter` is in the pin —
  bare `∏'`/`Summable` already unconditional, pin those forms in C2/C3.
* **RE-RULED (2026-07-02, late): the Hadamard-infinitude fact is a SORRIED THEOREM,
  not an axiom** — author's ruling supersedes the earlier same-day axiom ruling.
  `theorem riemannZeta_nontrivialZeros_infinite : {s : ℂ | riemannZeta s = 0 ∧
  (¬∃ n : ℕ, s = -2 * (n + 1)) ∧ s ≠ 1}.Infinite := sorry` — C4-floor form, predicate
  mirrors Mathlib's `RiemannHypothesis` exclusions. Stated when the ZetaO bucket exists;
  PROVED in-repo per `PROOF_PLAN_zeta_infinitude.md` (itemized plan FIRST, author
  approves the itemization before any lemma lands; cheap route to cost explicitly:
  finitely-many-zeros ⇒ `MeromorphicOn.extract_zeros_poles` + Borel–Carathéodory +
  unconditional functional equation + Γ-growth ⇒ contradiction; standard order-1 route
  costed for comparison). Gate is now literal: **zero sorries + zero project axioms** —
  declared leaf set EMPTY. Queue the matching R9 wording diff for author approval.
  Consequence: the Titchmarsh scan is no longer load-bearing (no axiom docstring
  requires it); Titchmarsh86 remains an ordinary bibitem, provenance never load.
  If cor:zeta-section's proof demands more than infinitude, report the exact demanded
  statement before widening the theorem.
* **SOURCES/**: `Thomason79.md` committed (GAP: original printed Thm 1.2 — Cambridge
  paywall; author has UNCG access; the nLab file is the WRONG Thomason paper — homotopy
  limit problem, not the 1979 hocolim paper). Untracked, awaiting author review: `AdF.md`,
  `AdFslice.md`, `BisiWinkelmann.md`, `GJ.md`, `GPVwind.md`, `Quillen73.md`, `Riehl.md`,
  `VS.md`. Map thread pre-reviewed and endorsed: VS.md (version-of-record, zero gaps),
  GPVwind.md (see FLAGS), Thomason79.md. Still missing vs Pins: Wang, Baez, Titchmarsh
  GAP-stub, classical Riemann/Euler/Hadamard-bearing references as needed.
* **Rem 5.2 attribution RESOLVED empirically**: the quotes live in VS alone (Math. Z.
  302(2), printed p. 988 — SOURCES/VS.md); the winding paper contains NO Remark 5.2 and
  never prints "degenerate" (SOURCES/GPVwind.md FLAGS, full environment inventory).
  Master's GPVwind bibitem corrected accordingly (Rem 5.2 clauses struck; tameness
  numbering fixed: paths Def 4.7, maps Def 4.20, at-parameter Def 5.2; journal record
  added: J. Math. Anal. Appl. 536(1) (2024), Paper No. 128219). CAVEAT for the SOURCES
  pass: GPVwind excerpts are arXiv v1; JMAA-version numbering unverified (publisher 403)
  — author to confirm via library.
* **Master edits today (author-approved, applied via map thread, in tree)**:
  thm:log-manifold cite now lists true environment types (Prop 5.1, Rem 5.2, Def 5.3,
  Prop 5.4, Def 5.5); lem:exp-degenerate gained the closing acknowledgment sentence
  (VS Preface p. 972 prints the fibre formula as unproved motivation; slice-form
  derivation stays load-bearing); GPVwind bibitem corrected. CLAUDE.md pin updates
  match. Blueprint regenerates from the master on rebuild — one rebuild pending.
* CI: stock Lean Action runs on push (nibbles free minutes; disable offered, declined
  for now). Octonion build receipt: olean at 20:46 preceding commit 20:47 — formal
  build-tail-with-commit discipline reaffirmed below.

## Current task (updated 2026-07-03, map thread; author's rulings of today inline)

**Goal: blueprint site postable to Zulip ASAP.** Sorries visible in a posted blueprint
are normal — it announces a live project; the zero-and-zero gate is the endgame claim,
not the announcement. **The placement sentence LANDED 2026-07-03** (author's "land it",
wording via map thread, sourced register, all tags in the proof's orbit) — the master now
has ZERO TODOs. Critical path to the post: statement layer + rebuild + author's site read.

1. **LANES OPEN (author's go, 2026-07-03).** Statement layer per Phase 3, citing
   pin-present names only, leaves as axioms with verbatim SOURCES/ docstrings, sorries
   per R8: 𝓡 via the stem functor over Mathlib's Hol(ℂ) → `structure ASection` (C2
   stated as `cexp (∑' p, ℓ p)`, unconditional forms pinned) → G₂ := AlgAut(𝕆) →
   𝓗₁ = G₂ ⋉ 𝕆* (ActionCategory) → 𝒮₂ → Φ → 𝓑 (levels, static) → F (band U(1)) →
   𝒯_A = ∫_𝓑 F (CategoryTheory.Grothendieck) → the π₀ lemma (ConnectedComponents) →
   theorem statement → **STOP at the red placement `\TODO`** — the sentence is the
   author's alone. Second lane: zeta-infinitude per `PROOF_PLAN_zeta_infinitude.md` —
   **Route A APPROVED** (map-thread cross-read against pin fabf563a: every PRESENT row
   verified at file:line; bonus find: the pin holds `NumberTheory/LSeries/ZetaZeros.lean`
   — `isDiscrete_riemannZetaZeros`, `IsCompact.inter_riemannZetaZeros_finite` — may
   shave A2/A3 bookkeeping).
2. **Commit ceremony re-ruled (author, 2026-07-03): NO per-commit approvals in the Lean
   lanes.** Pre-approved message templates: `ZetaInfinitude: close A<n> (<name>) on
   green` and `Statement: <object> lands (sorries +<n>)`. The Code tab commits
   autonomously on green — per-lemma or per-session at its discretion — and may batch
   pushes. Build tail still shown in-thread with each push (the receipts rule stands
   unchanged). Words-before-commits now applies to prose/rulebook files only (master,
   CLAUDE.md, HANDOFF, SOURCES).
3. **Applied in-tree today (author-approved, via map thread); quiet commits pending one
   go-word, proposed messages:** (a) CLAUDE.md R9 gate wording — `Author: R9 gate
   exactified — zero and zero, leaf set empty; infinitude enters as sorried theorem`;
   (b) master split — new `cor:hadamard-infinitude` under thm:hadamard, `\uses`
   re-pointed in cor:zeta-section AND thm:zero-spheres, three body cites — `Author:
   Hadamard infinitude clause gets its own label; consumer arrows re-pointed`; (c) this
   HANDOFF.md — `HANDOFF: lanes open, Route A approved, commit ceremony lifted`;
   (d) the placement sentence — `Author: the placement sentence lands (levels and
   winding through the triangle; the document's last TODO closes)`.
   Blueprint rebuild pending (the split AND the closed proof change the site).
4. **SOURCES = background lane; gates nothing.** Map-thread verification sweep against
   the author's PDF pool, zero mismatches found: VERIFIED = Wang, AdF, AdFslice,
   GPVwind, VS, Quillen73 (word-level via OCR); PARTIAL = GJ (Ch. IV unreached), Riehl
   (§8.3/§8.5 unreached); NO-PDF = Baez02, BisiWinkelmann, Thomason79 (nLab scan
   re-confirmed textless). Author approved Wang-style fetches: Baez (AMS), the BW pair +
   Sharma (arXiv), full GJ/Riehl PDFs for page-addressable checking — **fetched PDFs
   stay out of git**. GPVwind JMAA numbering: GAP-mark, Thomason precedent (author
   ruled 2026-07-03). Author review = FLAGS skim + commit words, trickled, never a gate.
5. **PIN FIX awaiting one word:** the CLAUDE.md pin `AdF 2106.04227 §1, §11 (slices;
   semiregular)` conflates two papers — 2106.04227 prints six sections and no §11; the
   §1/§11 slices-and-semiregular content is Ghiloni–Perotti–Stoppato arXiv:1606.03609
   (sitting in the author's own PDF pool). Proposed: attribute §1/§11 to GPS 1606.03609;
   keep AdF 2106.04227 for the ∗-logarithm. Grep the master's bibitems for the same
   conflation before any commit.
6. **Author's lane: the placement sentence is DONE** (landed 2026-07-03; the master has
   zero TODOs). Remaining author items: the final site read before the Zulip post.
   Resolved today: the sentence, the split (applied in-tree), JMAA (GAP-marked),
   Route A, R9. Still open, later, never gating: the finality remark's
   long-term fate (scoped prose session + graph re-audit; walks Quillen/Thomason/Sharma
   out of the bib). Thomason original: OPTIONAL per the 2026-07-02 ruling, unchanged.

## Failure modes (all prior ones stand) + today's additions

* Session resets lose chat state, never file state: on reset, read CLAUDE.md + this
  file, claim nothing you can't see (no build log in context = say so, don't assert green).
* Scope drift after resets: "queue / pending my approval" ≠ "do now". Wording approvals
  come BEFORE commits. No PRs. No installs without naming the tool and why.
* Commit-on-green means SHOW the green: build tail in-thread with the commit.
* Unresolved attributions are settled by verbatim quotes from ALL claimants
  (the Rem 5.2 method), never from memory or bibitem annotations. Author's
  standing convention (2026-07-02): every cite names the exact matching
  environment — the item that says what the gloss says — never a neighbor
  (the Def 4.7 ruling; body cite corrected accordingly).
* The sorry ledger will balloon when the statement layer lands — by design (R8).
  Sorry count is queue length, never error count. Octonion went 4→0 in one evening.
* "Concentric" stays translation vocabulary; the base is levels + winding; never attach
  metric language to 𝓑. The dictionary (`thm:connected-concentric`) stays independent of
  the collapse — graph-visible, never re-folded.
