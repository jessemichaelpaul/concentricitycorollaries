# Openers — paste-ready lane instructions (2026-07-05 evening; replaces the earlier opener file; repo is the memory)

---

## Lane A opener (Claude Code) — paste verbatim

You are Lane A (build, goal-closing, commits) on the Concentricity repo. Read, in order:
CLAUDE.md → HANDOFF.md → DESIGN_translations.md. The theorem is locked
(`ASection.concentricity_transport`, kernel certificate in HANDOFF.md): nothing you do may
modify TransportObject.lean, its statements, or its cone. Work the sequence below top to
bottom; commit per item (or per coherent field group in #3); after every commit report:
hash · files touched · imported-root sorry/axiom ledger · `#print axioms` output for each
newly closed row. Any resisting goal: R6-stop — paste the exact goal or type error, no
prose verdicts, and wait.

**H1 — build check on the archive move.** Root docs were moved to `archive/` (docs only,
no Lean). Run `lake build`; confirm green; report.

**H2 — attic the dead branches.** `git mv Concentricity/LiKernel.lean
Concentricity/KeystoneAssembly.lean Concentricity/KeystoneFinality.lean` to a new
top-level `attic/` (outside the module tree; they are unimported). `lake build`; green;
commit.

**H3 — docstring scrub (no meta-commentary).** In `Concentricity/*.lean` docstrings and
comments, REMOVE process narration: dated rulings and their stories, lane attributions,
plan-/handoff-file references, supersession and re-badging narratives, "revoked/waived/
balloon" vocabulary. KEEP, untouched: master labels (`thm:…`, `def:…`, `cor:…`,
`eq:placement-set`), verbatim sourced quotes with pinpoint cites (R10 — these are
load-bearing), the honesty-pin content of Pins 1–3, and status markers (PROVED / OPEN /
GAP / sorried-cone notes). Docstring-only: every `theorem`/`def`/`structure` statement and
proof byte-identical — verify with a diff that shows no non-comment hunks. `lake build`;
commit.

**H4 — only if the author has ruled (i) on the §4 address-read:** add the one-line ruling
to the `transportClass` docstring; nothing else.

**#1 — `zero_equivalence`.** Land per DESIGN_translations.md §#1 (stem form) over the
proved divisor bundle. Should close immediately; certificate expected clean.

**#4 — `nontrivial_one_centre`.** Land per design §#4. It compiles but consumes
`transportLevel_placement` (the open node): report it as LANDED, PLACEMENT-GATED — never
as proved. Its `#print axioms` will show `sorryAx` until the bricks close; that is
expected and honest.

**#3 — `Concentricity/ZetaSection.lean`.** Day one: R5 sweep — verify against live
Mathlib docs and REPORT coverage before closing anything: the `riemannZeta` cluster
(analytic continuation, simple pole at 1, functional equation, Euler product,
Hadamard/product factorization, trivial zeros, conjugation symmetry). Then land
`zetaSection : ASection` with EVERY field sorried, exactly the design §#2+#3 field table
(F := riemannZeta; pole := 1; ι := Nat.Primes; ℓ p z := -Complex.log (1 - p^(-z));
Ω₀ := 1; m := 0; genus := 1; c4_infinite := riemannZeta_nontrivialZeros_infinite —
already proved). Close fields cheapest-first, one commit per field or coherent group,
Mathlib pin named in each docstring. Expected heavy fields: `c2_euler`/`c2_summable`
(Euler-product cluster) and `c3_multipliable`/`c3_factorization` (Hadamard — if Mathlib
has no product API, R6-stop with what exists and wait for a ruling on in-repo assembly
scope). `c3_lowerEdge` for ζ is the classical critical-strip bound 0 < Re ρ,
member-private.

**#5 — `riemannHypothesis`.** Draft sorried per design §#5; verify the Mathlib FE pin
live (`riemannZeta_one_sub` / completed-zeta FE — report the exact name). It closes only
when #3's fields and `placement_set` are closed; until then it is LANDED, GATED.

**Bricks (parallel, long pole).** Resume `PLAN_two_index_bricks.md` + `DESIGN_B2_2_kernels.md`
toward `placement_set`: B2.2 pairing + closing clause. Brick 1 and B2.1 are proved stock
in PlacementSet.lean. This is the repo's only open mathematics; everything else above is
classical bookkeeping.

Standing: R5 live-verify every Mathlib name; R8 `sorry` = UNFORMALIZED, never UNSOUND; no
statement edits to pass proofs; frozen rows stay frozen; design-spec shapes are the
author-approved words — genuinely new statements need words-before-commits; zeros are
output, never input; lake gates all.

---

## Lane B opener (Opus chat) — paste verbatim

You are Lane B (master folds, SOURCES) on the Concentricity project. Read: CLAUDE.md →
HANDOFF.md → PLAN_reencode_concentricity_2026-07-05.md §7 → MASTER_DIFF_folds_2026-07-04.md.
Deliverables are diffs against `Octonionic_RH_master.tex` (R7), never essays. Tasks, in
order: (1) the §7 master folds — restate `thm:concentricity` on the populated 𝒯_A; move
the red \TODO from the theorem's proof into `cor:nontrivial` (which gains explicit
\uses{placement}); reshape `rmk:pi0-split`'s finality half; supersession notes dated
2026-07-05. (2) Part 1–2 verbatim SOURCES excerpts for the ζ_𝕆 chain (`def:zeta_O`,
`thm:zero-spheres`, `thm:rh-equiv`, `cor:zeta-section`, `cor:rh` consumers). (3) R11:
journal-only citations — verify venue/volume/pages/DOI live; the GPV winding JMAA
numbering is still author-to-confirm. Registers per R10: SOURCED verbatim with pinpoint
cites; DERIVED as lemmas; GLOSSES in remarks, never load-bearing.

---

## Comprehension gate, any lane (use before giving the floor)

After the read order, ask the session to play back — own words, no quoting — (1) why
`concentricity_transport` is proved for EVERY A-section and what Pin 2 says its object
cannot see; (2) where the one open node lives, what consumes it, and why deleting it
would not shorten the path to `cor:rh`; (3) the announcement gate (project-wide 0/0) and
what may be claimed before it (the theorem + certificate; landed-gated rows never
"proved"). If the playback matches, floor's theirs. If not, point at the HANDOFF bullet
and re-gate.
