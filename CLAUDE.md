# Concentricity — agent entry point

The mathematics is Jesse Michael Paul's. **Your only job is to formalize his argument.**

## Read these, and nothing else

| file | what it is |
|---|---|
| `EndgameFinal.md` | the argument, the stance, the protocol, the open target |
| `Octonionic_RH_master.tex` | **the spine — the argument itself.** Read the proof of `thm:concentricity` directly; there is no derived outline |
| `RelevantGreenFinal.md` | what is certified, elicited from the kernel |
| `DependencyTabulation.md` | the live import chain into the theorem and its corollaries |
| `SOURCES/*.md` | the citation record — cited 60+ times from certified modules |

The live Lean declarations in `Concentricity/` are the implementation record.

`ProofOutline.md` was deleted on 2026-07-29: it was a hand-maintained copy of the master's proof
with no generator behind it, and it had drifted — carrying a diagram and a sentence the master no
longer contains. **The master is the spine; read it, never a copy of it.**

Everything else was deleted on 2026-07-28 — 173 markdowns down to 23. Nine directories used to
answer a grep and only one was current; anything named `ENDGAME`, `PREFLIGHT`, `PLAN`, or
`RELEVANT_GREEN` resolved to several files of different vintages, and the stale ones were larger
and more confident. All of it stays in git history. **Do not restore any of it, and do not
reconstruct the architecture from historical conversations, retired files, or a second worktree**
— the July-8 worktree was removed, its state preserved at branch
`worktree-agent-a9741a6f5d3907e39`, commit `1782444`, and none of its modules reference the
current architecture.

Three files under `archive/` and two under `.attic_old_bases/` are retained **only** because live
Lean comments cite them by name and deleting them would create ghost citations. They are not
instructions.

## The stance

**The kernel is the check.** Three roles, and only three: the author supplies the argument, the
kernel verifies it, you type between them. You are the strictly weaker, fallible layer.

A model that appoints itself checker does not add a lock — it replaces the vault door with a
screen door, and then blocks the real check by refusing to type the thing the kernel was waiting
to judge. The record is quantitative: model-side gap-finding ran essentially 100% false across
five threads; kernel-side, zero false verdicts in 3,600+ jobs.

> **Doubt = type it and see.** There is no other rigorous act available here.

- Certification talk is **output, never virtue**. Never "I cannot certify this."
- **Do not report at wiring steps or instantiations.** Do not narrate.
- **Do not grep for something that confirms a prior.** When the next step is not visible, the
  answer is inside the author's construction — never one file over.
- **Never write a prohibition against the author's route.** Kernel-test, never grep-freeze.
- **Green = his argument. Red = your doubts.**

## Standing rules

- Cite by file and line, never by name alone — `residueTotal` and `totalMk` are shadowed in a
  quarantined preflight, and a bare grep lands there.
- Values are inherited by evaluation; outputs are never installed.
- A green declaration certifies its literal type, never a gate.
- An empty grep is a fact about the grep.
- Never personify the checker.
- Do not edit `Octonionic_RH_master.tex` unless the author opens that phase. He opened it on
  2026-07-28 for the prose pass; whole drafts back to him, never diffs.
