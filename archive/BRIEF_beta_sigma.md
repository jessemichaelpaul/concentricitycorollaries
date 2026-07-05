# Lane-β pre-review brief — the σ-apparatus, and whether the ledger consumes it

**Status:** read-only. No Lean written, no builds. For the author's ruling before any
construction. HEAD `612ed3a`, ledger 2/0.

**Headline (R6 stop, author's call):** the two surviving Lean sorries do **not**, as
their statements are currently frozen, consume the σ-apparatus. Both are σ-free
transcription-class rows. Building the σ/σᶜ definition layer (GPVwind Def 5.2/5.7/
5.15–5.19) appears **unnecessary for the zero-and-zero gate**. σ lives in the master's
*prose* (the placement paragraph's citations to Cor 5.13 / 5.21), not in any frozen
Lean statement. This matches the author's standing instinct; it needs a ruling on
routing, recorded below. I am not asserting the proof closes (R8) — only reporting, at
file:line, what each frozen statement takes as input.

---

## 1. What lane β was chartered to build

The dispatch filed `winding_lift_unique` as "β-gated σ-vocabulary" and chartered a
construction of the paper's signature layer as Lean definitions over the direction
field: Def 5.2 (flip/bounce), Def 5.7 (σ), Def 5.15–5.17 (obstruction intervals, sign,
interval flip/bounce), Def 5.19 (circular signature σᶜ) — each carrying its `457d6ca`
excerpt verbatim — then the Cor 5.13 closure clause stated against them, and a
consumption map into placement.

## 2. What the two surviving statements actually are (verbatim, at file:line)

**(β survivor) `winding_lift_unique` — Toolkit.lean:301–304, FROZEN:**
```
theorem winding_lift_unique (γ : C(unitInterval, ℂ)) (hγ : ∀ t, γ t ≠ 0)
    (γ₁ γ₂ : C(unitInterval, ℂ)) (h₁ : ∀ t, Complex.exp (γ₁ t) = γ t)
    (h₂ : ∀ t, Complex.exp (γ₂ t) = γ t) (h0 : γ₁ 0 = γ₂ 0) : γ₁ = γ₂
```
No σ, no companion, no signature. This is the **slice-form** of tameness: the docstring
records the reduction — "on a single slice the companion is the slice itself … so
tameness holds by fiat and the lift is unique once its initial value is fixed." What
remains is pure covering-space uniqueness: two continuous lifts of a nonvanishing path
that agree at t=0 are equal.
- **σ-free route (verified present):** covering maps are separated maps;
  `IsSeparatedMap.eq_of_comp_eq` (`Mathlib/Topology/SeparatedMap.lean:203`) over the
  preconnected `unitInterval`, on the `Complex.isCoveringMap_exp`
  (`Mathlib/Analysis/Complex/CoveringMap.lean:40`) floor — same family as the already-
  closed `exists_log_continuation` (which used `exists_path_lifts`). Code verifies the
  exact separated-map name live.

**(γ) `ASection.transportLevel_placement` — Theorem.lean:201–203, FROZEN:**
```
theorem ASection.transportLevel_placement (A : ASection) (n m : ℕ) :
    A.transportLevel n = A.transportLevel m
```
i.e. `(A.sphereZero n).re = (A.sphereZero m).re` — all residue-ℂ sphere-zeros share one
real level. Its docstring's step map (a)–(e) names exactly what discharges each step:
- (a) "unique tame lift traverses … as a single closed loop" — Cor 5.13, whose full
  σ-apparatus is the **recorded GAP** of `winding_loop_defect`; the loop-closure content
  placement uses is the σ-free defect frame (next section).
- (b) fibre point = level log r + odd winding height — `exp_fibre_neg_real` — **PROVED**.
- (c) C2/C3 agreement — `stem_identity` — **PROVED**.
- (d) level conserved along every zigzag — `TotalObject.level_eq_of_zigzag`
  (Base.lean) — **PROVED**.
- (e) single level — the conclusion.

## 3. The σ-free routing was a deliberate, already-landed design

`winding_loop_defect` (Toolkit.lean:336, **closed** at `9e76264`) is the Cor 5.13
content stated in a σ-free "stateable frame":
```
theorem winding_loop_defect (γ : C(unitInterval, ℂ)) (hloop : γ 0 = γ 1)
    (γ' : C(unitInterval, ℂ)) (hlift : ∀ t, Complex.exp (γ' t) = γ t) :
    ∃ k : ℤ, γ' 1 - γ' 0 = (k : ℂ) * (2 * (Real.pi : ℂ) * Complex.I)
```
Along a loop, any continuation's endpoint defect is an integer multiple of 2πi — all
multiplicity in the winding direction, **none in the level**. That is precisely the
placement's load: the level is the conserved quantity (step d), the winding is band data.

This is the crux, and it is the author's own repeated point: **σ governs winding; the
level read-off does not depend on σ.** The builder correctly refused to state the *full*
Cor 5.13 biconditional ("lift exists iff σ ∈ {0,−1}") σ-free — that rendering is false
(γ = exp(2πit) lifts but never closes), so the biconditional genuinely needs σ. But
placement never consumes the biconditional; it consumes only "the lift closes into a
loop, with the defect in the winding direction," which the σ-free frame already gives.
No contradiction between the earlier refusal and this finding.

## 4. The ruling (author's, R6)

**Option A — σ-free close (recommended; matches your instinct).** Close
`winding_lift_unique` by covering-map lift uniqueness and `transportLevel_placement` by
assembling the four proved cone lemmas + `winding_loop_defect` + `winding_lift_unique`.
No σ-apparatus is built; the ledger reaches 0/0. Cost: the master's placement paragraph
cites Cor 5.13/5.21 by name, so the Lean proof discharges the *level* content of those
citations via the σ-free frame while the σ/σᶜ *values* remain a master-prose statement,
not a Lean object. Documented honestly in the placement docstring (as it already is).

**Option B — build the full σ-rendering anyway**, for a Lean statement of Cor 5.13's
biconditional and Cor 5.21's ω = |σᶜ|/2 that mirrors the paper symbol-for-symbol. This
is genuine definition-layer construction over the direction field, off placement's
critical path, and adds surface the gate does not require. Only choose this if you want
the winding *number* itself formalized, not merely the level read-off.

My read as reviewer: Option A is the faithful minimum — it renders exactly what
concentricity consumes and nothing it doesn't, which is the R3/R4 discipline (read the
zeros off the assembly; don't import machinery the theorem doesn't use). Option B is a
separate formalization goal that can stand on its own later if ζ_𝕆's winding theory is
ever wanted. But the routing of placement's step (a) is a master-citation question, so
it is yours.

---

## 5. σ-apparatus material (carried verbatim, in case Option B is chosen)

Sourced from `SOURCES/GPVwind.md` (`457d6ca`; ar5iv arXiv:2307.14047 v1; JMAA numbering
UNVERIFIED, publisher 403). Reproduced so a construction brief needs no re-fetch.

- **Def 5.2** (tame/semi-tame/not-tame at an obstruction parameter, via one-sided limits
  of Y(t)/|Y(t)|; flip = opposite limits, bounce = equal). Codomain printed ℍ∖{0} (sic).
- **Def 5.7** (σ, finite tame obstruction set): σ(γ) := Σ_{l=1}^{m} sign(γ(ξ_l))(−1)^l
  over the flips ξ_l; σ:=0 if no flips.
- **Def 5.15** (big arcs, induced subdivision, obstruction intervals [e_l, s_{l+1}]).
- **Def 5.16** (sign of an obstruction interval, ±1).
- **Def 5.17** (interval bounce/flip w.r.t. a companion 𝔍; two printed typos, sic).
- **Def 5.19** (σ(γ,𝔍) and the **circular signature** σᶜ(γ,𝔍) := Σ_{l=1}^{k}
  sign([e_l,s_{l+1}])(−1)^l for a loop; σᶜ:=0 if no flips).

**Standing FLAGS (from SOURCES/GPVwind.md, carried, not resolved):**
1. **Cor 5.21 hypothesis** — printed statement is "Let γ be a loop **and σᶜ(γ) even**.
   Then ω = |σᶜ|/2." The evenness hypothesis is part of the statement; the master's short
   gloss omits it. Any Lean rendering must carry it.
2. **Naming** — the paper's term is "**circular signature**" σᶜ (Def 5.19; "closed
   signature" in the prose before Cor 5.21). "Coherent" was a stray; master conforms to
   "circular signature" (line 578).
3. **Numbering** — tameness-as-unique-companion is Def **4.7** (paths) / Def **4.20**
   (maps); Def 5.2 is the at-a-parameter flip/bounce version. The master body already
   repoints accordingly.
4. **Carrier if Option B** — σ needs the direction field 𝔍^γ over the slice structure
   (Def 4.7 companion), a construction over `unitImaginarySphere`/`sliceEmbed`, not a
   transcription. This is the print-underdetermined choice to bring back before building:
   the flip/bounce limits (Def 5.2) require a chosen encoding of Y(t)/|Y(t)| one-sided
   limits — flagged, not to be silently defaulted.

## 6. Consumption map (what actually flows into the gate)

```
exp_fibre_neg_real (PROVED) ─┐
stem_identity      (PROVED) ─┼─► transportLevel_placement ─► concentricity (PROVED on it)
level_eq_of_zigzag (PROVED) ─┤
winding_loop_defect(PROVED, σ-free frame) ─┤
winding_lift_unique(σ-free, covering uniqueness) ─┘

σ / σᶜ apparatus (Def 5.2/5.7/5.15–5.19) ──► consumed by NONE of the above.
                                             Needed only for a Lean statement of
                                             Cor 5.13 biconditional / Cor 5.21 value
                                             (Option B), which is not a frozen row.
```
