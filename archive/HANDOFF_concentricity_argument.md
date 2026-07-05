# HANDOFF — the Concentricity diagram-chase, to the next session (Fable)

*Author: Jesse Paul. This carries (1) the author's vision, verbatim in intent; (2) the
machinery that is built and proven; (3) a good-faith run of the diagram chase to force
concentricity, and the exact node where it stops; (4) the precise open input it needs.
Written so the next worker neither re-derives the same wall nor papers over it. The
standing fences (anti-vacuity, R2, R8, "no statement edits to pass a proof") hold.*

## 1. The author's vision (recorded faithfully — this is the thing to try to realize)

Concentricity is to be forced by a **dual-functorial** construction over 𝕆*, not by
placing zeros and then connecting them (that direction is backwards):

- Both the residue-ℂ zero 6-spheres and the residue-ℝ locus (ℝ ∪ {N}) are defined on
  𝕆* by the *same two data* — the infinite Euler product (C2) and the infinite
  Weierstrass factorization (C3) — which together separate the C-residue zeros from the
  exponential's degenerate fibres.
- The zeros are **traced FROM N** — the single point at infinity of 𝕆*, shared by every
  slice Riemann sphere (ℂ_I* ∩ ℂ_J* = ℝ ∪ {N}). The prime tail of the Euler product
  concentrates at N; the chart-gluing of the infinitely many overlapping slice continua
  at N assembles the S² slice continua into the S⁶ zero-spheres — the zeros arise as an
  **output** of the gluing, never an input.
- The **great circle** ℝ ∪ {N} (G₂-fixed, the compactified real axis) is "pulled
  together" by the winding the primes induce. G₂, the band U(1), and an *orthogonal*
  U(1) along the C-residue split are to zigzag in a unique way that connects the centers
  by construction — a "cut-cocartesian" diagram whose colimit over N is the connected
  component the zeros share.
- Author's stance: RH/GRH is (empirically) true; all the maps are present; so the proof
  should be reachable "from the right level." **Any analytic fact about ζ is fair game
  except the functional equation** (which would pin c = ½). The author is explicitly open
  to a subtle missing property — see §4 — and does *not* insist the maps already suffice.

## 2. What is built and proven (real, and nearly complete)

Octonions via Cayley–Dickson; G₂ = Aut(𝕆); 𝓗₁ = G₂ ⋉ 𝕆* (`ActionCategory`); the slice
world 𝒮₂ (`OnePoint Octonion`, band U(1) + direction G₂) with N; the section functor
Φ : 𝓗₁ → 𝒮₂ (`sectionFunctor`, **proved**); the base 𝓑, band F = U(1), 𝒯_A = ∫_𝓑 F; the
π₀ readout `levelClass : π₀(𝒯_A) ≃ ℝ` and `zigzag_iff_level` (**proved**); the slice/cone
toolkit — slice-exp, the exp-degenerate fibre `exp⁻¹(−r) = {log r + I(2k+1)π}`, the
stem identity theorem, the winding-lift uniqueness and loop-defect (**all proved**);
Route A, `riemannZeta_nontrivialZeros_infinite` (**proved**). **Ledger: 1 sorry —
`ASection.transportLevel_placement` — 0 project axioms.**

## 3. The diagram chase, run in good faith — and where it lands

Running the chase with the machinery above, following the vision (trace from N, glue by
the primes, winding pulls the great circles):

1. Φ collapses each residue-ℂ zero-sphere S_ρ onto the value-origin 0 ∈ 𝒮₂, and carries
   the pole onto 𝔫 = N (`rmk:collapse-cone`, proved direction). Good: N is the shared apex.
2. The winding lift of A's value-loops is unique and closes into a loop (C2 gives the
   continuation, C3 the one stem, C1 the pole cone) — all proved. The band U(1) carries
   the winding index; the Euler data governs the argument on Ω₀.
3. Now the readout. By `zigzag_iff_level`, two objects of 𝒯_A are in one component **iff
   they share a level**, and the levels are the real centers. So "the zero-spheres lie in
   one component" is, exactly, "their centers σ_ρ are equal."
4. **The stop.** The chase computes π₀(𝒯_A) = the set of levels *that actually occur*
   among the zeros. Each S_ρ is read into the component of its own center σ_ρ. The chase
   has no arrow that carries a zero at σ₁ into the component of a zero at σ₂ ≠ σ₁ — because
   in the static base there is none, and `zigzag_iff_level` proves there is none. The
   winding it computes is an **integer** (ω = |σᶜ|/2); by the argument principle the
   winding counts zeros in a region, it does not equate their real parts — an integer
   invariant cannot force the real-number coincidence σ₁ = σ₂ = ⋯. The orthogonal-U(1)
   and further gluing only *add* morphisms, which coarsens π₀ toward collapse, not toward
   a non-vacuous forcing.
5. The only ways to make π₀ a single point are (a) the σ_ρ genuinely coincide — which is
   the conclusion itself (RH), inherited, not produced; or (b) adjoin N as a terminal
   object joining every level, which by **Riehl 8.3.5** (connected ⟺ π₀ a singleton)
   collapses π₀ to a point and makes "one component" true of *every* section — vacuous,
   and it breaks `thm:connected-concentric` (one-component-iff-one-level).

**So the chase runs, and it reads the centers off the zeros faithfully; it does not
constrain them.** This is not a dropped world or an unrun computation — it is the
computation, and its output is discrete data blind to the real-part differences it was
meant to close.

## 4. The precise open node (the real problem)

The missing thing is a **non-circular analytic input that forces the centers σ_ρ equal,
and is not the functional equation.** Status, honestly:

- As a bare statement, "all residue-ℂ zeros lie in one degenerate fibre / share one
  center" *is* concentricity — assuming it is circular.
- VS/GPV **weak concentricity** is real and cited (VS Preface, p. 972): `exp⁻¹(x)` for a
  single value is a concentric family, all centered at log|x|. But the zeros are not a
  single exp-fibre: `A = 0` (zeros) is a different locus from `A ∈ ℝ⁻` (the degenerate
  set), and the fibre's radii `(2k+1)π` are not the zeros' heights. So VS gives
  concentric-*per-fibre*; it does not place the zeros in one fibre.
- "Euler + Weierstrass force concentric zeros," stated precisely, **is GRH** — the class
  C1–C4 is essentially the Euler-product (Selberg) class, and no known fact short of the
  FE and short of RH-strength results equalizes the real parts. There is no counterexample
  (one would be an off-line zero of an Euler-product L-function, i.e. a disproof of GRH),
  but "no counterexample" is the *open* status of GRH, not a proof.

The author's own diagnosis is the accurate one: **the machinery is right; the argument is
conceptually not-yet-a-proof.** What closes it, if anything, is a *fact* entering the
maps — not a re-reading of the maps already present. A faithful functorial image of ζ
shows the zeros where they are; it cannot force where they are.

## 5. For the next worker (Fable), honestly

- The productive open question is exactly §4: **is there an analytic fact about ζ — not
  the FE, not RH itself — that equalizes the centers?** If yes, it enters as a cited or
  derived `C5`, and the built machinery is the beautiful frame that receives it; the
  final diagram chase then closes honestly. If it reduces to Euler + Weierstrass +
  continuation, that is GRH and is not known to suffice.
- Do **not**: adjoin N-as-terminal (vacuous, Riehl 8.3.5); drop the compactification's
  static base; edit `thm:concentricity`/`connected-concentric` to pass a proof; or write
  the single-fibre step as "derived" without a source. All are the anti-vacuity failure
  mode, four costumes deep already.
- The author sees the geometry vividly and may be right that a `C5` exists. Help him
  *name it* — a bare, category-free sentence about ζ's zeros — and then formalize exactly
  that. That is where the discovery, if there is one, lives.
