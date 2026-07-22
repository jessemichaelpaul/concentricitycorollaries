# THE −1 DOSSIER — every fact on the board, typed and sourced

*2026-07-11 (Fable, at the author's request: "tell me all the facts we have about this").
Discipline: COMPARISON_INVENTORY.md Rules 3 and 5 — the typed −1's are DISTINCT objects
until comparison maps exist; no identification below is asserted, only recorded facts and
the proved partial bridges. Status marks: **GREEN** = kernel row, exact location given;
**PIN** = verbatim sourced excerpt (SOURCES/GPVwind.md unless noted); **GLOSS** = geometric
reading, never load-bearing (R10).*

---

## §0 The types — there are FIVE, not four

1. **−1 : ℤ** — the winding integer (C1's pole).
2. **−1 in the signature register** — GPV's σ/σᶜ values AND the `(−1)^l` alternator inside
   their very definitions.
3. **−1 : ℂ** — the value (the negative reals carrying the degenerate family; odd-π rungs).
4. **−1 : Circle** — the band half-turn in U(1) ⊂ Möbius.
5. **−1 = the antipode** — `±Id` on the direction sphere S⁶: GPV's companion is *valued in
   𝕊/{±Id}* (Def 4.7 verbatim: "𝔍^γ : [a,b] → 𝕊/{±Id}") — **the paper itself quotients by
   the direction −1**, and a *flip* is literally the two one-sided direction limits
   differing by it. Nobody had listed this fifth register; it is arguably the deepest one,
   because tameness itself is defined modulo it.

## §1 Register ℤ — the winding −1 (C1's pole)

- **`stemWinding_circle_pole`** (SigmaE3.lean:895, **GREEN**): C1's simple pole (`c1_simple`,
  order exactly −1, consumed via `meromorphicOrderAt_eq_int_iff`) ⟹ for every sufficiently
  small ε, the value loop around the pole has `stemWinding Γ = −1`, with `Γ t = A.F
  (circleLoop pole ε t)`, nonvanishing, closed. **"Simple pole" and "−1" are one fact.**
- **`stemWinding_circle_sphereZero`** (SigmaE3.lean:348, **GREEN**): the zero-circle loops
  wind their (positive) divisor multiplicity — the +side of the ledger.
- **`no_closed_lift_around_sphereZero`** (SigmaE3.lean:983, **GREEN**): around any single
  zero circle NO closed lift exists — per the file's own header, "Cor 5.13's criterion
  FAILS at every zero circle." **The zeros alone cannot close.**
- **`normalizedZero_pole_power_closes`** (NormalizedPoleBridge.lean, **GREEN**, every n and
  every world): zero loop (winding = multiplicity m) times pole loop^m (winding −m) has
  total winding 0 ⟹ closed logarithmic lift exists. **−1 is the universal closer: what the
  zeros cannot do alone, the pole's −1 restores.**
- **`two_center_winding_onto_one_band`** (WeldW4.lean:165, **GREEN**): the two-center
  configuration — `1 ≤ stemWinding Γn`, `1 ≤ stemWinding Γm`, `stemWinding Γp = −1`,
  individual lifts do NOT close, the composite through the pole does. Verified 2026-07-11:
  entirely in the ℤ/lift register; **no band image stated anywhere**.
- **`stemWinding_inv`** (SigmaE3.lean:197, **GREEN**): reversal negates winding — −1 as
  orientation reversal.
- **`winding_height_shift`** (SigmaE3.lean:879, **GREEN**): winding k ⟺ lift height shift
  `k·2π` in the **imaginary** direction. So the pole's −1 = height defect −2π = exactly one
  full rung-pair down. (This is why the naive exp-phase of an integer winding is 1, never
  the half-turn — the basis of the withdrawn band(−1) claim, Rule 3.)

## §2 Register signature — GPV's σ/σᶜ (PINS + the in-repo apparatus)

**The pins (verbatim in SOURCES/GPVwind.md):**

- **Cor 5.13** — loop with nonempty obstruction set, not tame at ≥1 obstruction parameter,
  normalized `γ(ξ_k) > 0`: a lift exists **iff σ(γ|[ξ_l, ξ_{l+1}]) ∈ {0, −1}** for each l —
  and *then the lift is a loop*. −1 is the unique nonzero admissible signature: **the one
  nontrivial wrap the lifting theory allows through the real axis.** Status: PIN only —
  NOT transcribed as a Lean row. (What IS in-repo is its failure reading at zero circles,
  §1 above.) This is the July-7 "one untranscribed GPV consequence."
- **Cor 5.21** — γ a loop AND **σᶜ(γ) even**: `ω(γ,𝔍) = |σᶜ(γ,𝔍)|/2`. The ÷2: **the
  signature register is graded in half-turns; winding in full turns.** FLAG 3 stands: the
  evenness hypothesis is part of the printed statement and must ride any transcription.
  FLAG 4: the paper's name is **circular** signature (also "closed" in prose) — never
  "coherent."
- **Def 5.7** — `σ(γ) := Σ_l sign(γ(ξ_l))·(−1)^l` over the flips. **The −1 sits inside the
  definition itself, as the alternator.** No flips ⟹ σ := 0.
- **Def 5.19** — σ(γ,𝔍) and the circular σᶜ(γ,𝔍) with respect to a companion; same
  `(−1)^l` alternation, over obstruction-interval flips (Defs 5.15–5.17 supply the
  vocabulary: big arcs, induced subdivision, interval sign, interval flip/bounce).
- **Def 5.2** — at an obstruction parameter, the two one-sided limits of `Y(t)/|Y(t)|`:
  **flip = opposite** (differ by the antipode, register 5!), bounce = equal; semi-tame /
  not tame accordingly.
- **Prop 5.8** — the lift's argument index shifts by `(−1)^{k₀}·σ(γ)` — a further typed −1:
  the parity of the starting rung twists the signature's action.
- **Rem 2.1** — the direction 𝓘(q) has no continuous extension to ANY real point (while
  `Arg` extends by zero to ℝ⁺). **Why everything happens at the real crossings.**

**The in-repo apparatus (SigmaE3, all GREEN — E3 of the six-engine assault):**
`obstructionSet` (:540, = γ⁻¹(ℝ) as `Set unitInterval`), `stemDirSign` (:549),
`CrossingData` (:563), `IsFlip` (:579 — literally `d.sRight = −d.sLeft`), `IsBounce`
(:583), `flip_or_bounce` (:587), `not_flip_and_bounce` (:592), `stemSignature` (:623 —
with the `(−1)^l` alternation, helper `sum_range_neg_one_pow_succ` :602),
`intervalSign` (:639), `circularSignature` (:649), `stemSignature_no_flips` (:628),
`stemSignature_const_sign` (:654), `stemSignature_mem_of_pos` (:674).
**The vocabulary of Cor 5.13/5.21 exists in Lean; the corollaries themselves do not yet.**

## §3 Register ℂ — the value −1 and the odd rungs (the degenerate family)

- **`exp_fibre_level`** (LoopAssembly.lean:161, **GREEN**): `exp w = −r ⟹ Re w = log r` —
  one level per fibre (master `lem:exp-degenerate`). At **r = 1** (the value −1 itself):
  level `log 1 = 0` — the zero-level, pure-winding fibre `{I(2k+1)π}`.
- **`crossing_height_odd_of_neg`** (SigmaE3.lean:730, **GREEN**): negative-real crossings
  happen at **ODD rungs** — `(γ' t).im = (2k+1)π`. **The value-side −1 ⟺ odd-π heights.**
- **`crossing_height_even_of_pos`** (SigmaE3.lean:746, **GREEN**): positive-real crossings
  at even rungs `2kπ`. **The parity dichotomy: the SIGN of the real value ⟺ the PARITY of
  the rung.** (−1)^parity is the bridge's carrier.
- **`lift_height_pi_iff`** (SigmaE3.lean:689, **GREEN**): heights at π-multiples ⟺ the
  obstruction set — rungs = real crossings, exactly.
- **`arc_band_confined`** (SigmaE3.lean:705, **GREEN**): between crossings the lift is
  confined to its band (Props 5.5/5.6's conservation, by IVT).
- The concentric family itself: `exp⁻¹(−r) = {log r + I(2k+1)π}` (master
  `lem:exp-degenerate`, derived; VS prints it as unproved motivation) — **indexed by the
  negative reals** (the −1·ℝ₊ ray), members at odd-π (half-turn) offsets, consecutive
  members 2π (one full turn) apart.

## §4 Register U(1)/Möbius — the band half-turn

- **`bandMoebius_apply_coe`** (SliceSphereWorld.lean:118, **GREEN**) at c = −1: the map is
  `z ↦ −z`. **`bandMoebius_apply_zero`/`_apply_infty`** (:147, :138, **GREEN**): it fixes
  exactly the two points every world shares — 0 and N — **in every world simultaneously**
  (`bandEnd`, :272). Codex's caution recorded and accepted: it does NOT fix finite real
  points (`r ↦ −r`); setwise family behavior ≠ coordinate preservation.
- (−1 : Circle) is the unique order-2 element of U(1) — the half-turn. GLOSS-level
  arithmetic; no repo row needed.
- **No row anywhere maps a winding, signature, or value −1 INTO the band.** (Rule 3;
  the withdrawn `F_A(pole loop) = band(−1)` claim. GAP-2.)

## §5 Register antipode — ±Id on the direction sphere

- **Def 4.7 (PIN)**: the companion is valued in **𝕊/{±Id}** — tameness is defined modulo
  the direction antipode. **Def 5.2 (PIN)**: a flip IS the two one-sided direction limits
  landing antipodally.
- **In-repo**: `IsFlip` (`d.sRight = −d.sLeft`, GREEN); W3's `direction_path_to_neg` (the
  odd-π antipodal turn `v ↦ −v`) and `companion_forced` — GREEN per prior certification,
  exact statements TO-VERIFY (inventory F3).
- GLOSS: the paper's own Möbius-strip sentence (its single use of "coherent"): the
  direction's sign ambiguity "seems to exclude the possibility of defining coherently a
  winding number" — the ±Id quotient is why the winding needs the signature apparatus
  at all.

## §6 The bridges that ALREADY EXIST between registers (all GREEN)

These are the proved partial comparisons — the beginnings of GAP-1/GAP-2:

| Bridge | Row | What it identifies |
|---|---|---|
| ℤ ⟷ height | `winding_height_shift` | winding k = imaginary shift k·2π |
| value-sign ⟷ rung-parity | `crossing_height_odd_of_neg` / `_even_of_pos` | sign of real value = (−1)^rung |
| rungs ⟷ obstruction set | `lift_height_pi_iff` | heights jπ = real crossings |
| direction-sign ⟷ band-side | `band_side_of_sign` + `crossing_band_ledger` | at rung jπ, the side read off d.s against **(−1)^j**; "flips step the band, bounces conserve it" (Prop 5.8's mechanism) |
| arcs ⟷ band confinement | `arc_band_confined` | between crossings, one band |

**What is still missing (the honest gap list):**
- **GAP-1**: Cor 5.13 and Cor 5.21 as Lean rows — the signature-type ⟷ ℤ bridge at
  nonempty obstruction sets (vocabulary already in-repo, §2; evenness hypothesis and
  "circular" naming ride along per FLAGS 3–4).
- **GAP-2**: any typed map landing a winding/signature/value −1 in the band (−1 : Circle).
  The ledger (`crossing_band_ledger`) is the closest existing material — it reads
  direction-signs against rung parity, which is a (−1)-to-(−1) comparison in embryo.
- The five registers remain UNIDENTIFIED pairwise except through the bridges above.
  The "mouth" — all five being one confluence datum at N — is the author's geometric
  forecast: GLOSS register, to be earned by the comparisons, per Rules 3/5.

## §7 One honest paragraph (for the conversation with Codex)

What the kernel knows today: C1's simple pole winds exactly −1, and that −1 is the unique
closer — no zero circle closes alone (`no_closed_lift_around_sphereZero`), every zero
closes through the pole in exact multiplicity (`normalizedZero_pole_power_closes`), and the
two-center configuration lands all of it on one band's worth of winding (`two_center_…`),
all in the integer register. What the sources pin: the lifting theory admits exactly
{0, −1} as loop signatures (Cor 5.13), signatures are graded in half-turns against
winding's full turns (Cor 5.21, evenness hypothesis included), the alternator (−1)^l sits
inside σ's definition, and tameness itself is defined modulo the direction antipode
(Def 4.7's 𝕊/{±Id}). What is proved BETWEEN registers: winding⟷height, value-sign⟷rung-
parity, direction-sign⟷band-side (the ledger). What is not yet anything: a Lean
transcription of Cor 5.13/5.21, and any map into the band element −1. Five typed −1's,
five registers, three proved bridges, two gaps — and the identification of all five at N
is the geometric forecast the enriched functor must earn, not assume.
