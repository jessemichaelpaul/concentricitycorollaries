# Concentricity over the Octonions

This repository contains Jesse Michael Paul’s Lean 4 formalization of the
Concentricity Theorem for slice-preserving functions over the octonions,
together with its mathematical master document,
`Octonionic_RH_master.tex`.

The mathematical definitions, arguments, theorem statements, and exposition
are the sole work of Jesse Michael Paul. AI systems are used as interactive
proof-engineering tools under the author’s direction; they are not coauthors.

The Lean library is rooted at `Concentricity.lean`, with production sources in
`Concentricity/`. The LaTeX master is the authority for the intended
mathematics, while Lean’s kernel determines whether the formal proof terms are
accepted.

The public repository is intentionally source-centered: Lean sources and the
small amount of build and verification metadata they require,
`Octonionic_RH_master.tex`, this README, and `PROVENANCE.md`. Generated PDFs and
websites, historical plans, agent instructions, audit transcripts, and private
working material are not publication content.

`PROVENANCE.md` describes Jesse Michael Paul’s lightweight workflow for
preserving semantic fidelity while retaining freedom in proof engineering. It
is included for researchers formalizing arguments that may be unfamiliar to
the assisting model or poorly represented in its training context, especially
when the reputation of a downstream consequence can distort how an upstream
theorem is approached.
