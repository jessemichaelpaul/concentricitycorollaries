> ## RETIRED - PRE-REBUILD MATERIAL, NOT CURRENT (marked 2026-07-20)
>
> This file sits in a retired directory and predates the projective rebuild. It may describe
> objects, bases, functors, and file locations that no longer exist.
>
> **Known stale across this material:**
> - The `cayleyProjective` / generic-Moebius route and the `Hypothesis A (_D)` cargo-as-fields
>   pattern are **SUPERSEDED**. Cargo is not attached to the action; it IS the action. The
>   A-determined Euler/Weierstrass pole action is carried by `stabilizerPart` via orbit-stabilizer.
> - **Deleted modules:** AFunctor, TwoWorlds, PhiConversion, Recovery, ConnectedBase, InboxWire,
>   SynthesisE6, IntegrateTheorem, NormalizedCone, NormalizedNLeg, Base, TransportObject,
>   FaithfulApply, KeystoneAssembly, KeystoneFinality, RecoveryAudit. Their facts were rehomed,
>   largely into ProjectiveCargo / ProjectiveTransport.
> - **Every file:line citation here is unreliable.** Resolve names against the live tree only.
> - Any `rho`/`V_RHO`, `el(V)`, `Disc R`, per-zero `Z_n -> N` leg, generic action record, or
>   parameterized carrier appearing below is a retired substitution, not the construction.
>
> **Current and authoritative:** `PROOF_OUTLINE_LOCKED.md` and
> `BOARD_LECTURE_CONCENTRICITY_2026-07-17.md` (the author own), plus `RESUME_2026-07-20.md`
> for live state.
>
> **Do not take construction, architecture, or status from this file.**

# PLAN — re-encode `thm:concentricity` as transport connectivity (author's ruling 2026-07-05)

**Status:** proposal for the author's confirmation (words-before-commits). No Lean written.
Frozen rows NOT edited. Ledger at plan time (imported root `Concentricity.lean`):
`Theorem.lean:203` (`transportLevel_placement`) + `PlacementSet.lean:46` (`placement_set`),
one node via the proved weld `placement_set_iff`; plus `LiKernel.lean` ×3 (deprecated branch,
still imported — housekeeping item §6). 0 axioms throughout.

## 1. The ruling, and how it differs from the revoked July-4 plans

**Author, 2026-07-05 (verbatim, in-session):** "emphatically YES this was THE ENTIRE POINT
OF BUILDING ALL OF THIS MACHINERY — encode `concentricity` as pure diagram connectivity
built from the transport (connect at 𝔫 by construction): it's provable, holds for every
section." The theorem is the connectivity statement; the code had encoded the translation
corollary's language into the theorem (`transportLevel n := (sphereZero n).re`,
`assemblyComponent := levelClass.symm ∘ transportLevel` — the component *defined* through
the real coordinate).

**The record this touches.** `PLAN_transport_population.md` and `PLAN_compactified_base.md`
(both REVOKED 2026-07-04) proposed the same cone construction. The revocation mechanism,
verbatim (`HANDOFF_concentricity_argument.md` §3.5): "adjoin N as a terminal object joining
every level … collapses π₀ to a point and makes 'one component' true of *every* section —
vacuous, and it breaks `thm:connected-concentric` (one-component-iff-one-level)."

**What is different now — the re-pricing.** The revoked plans claimed the corollary chain
net-zero ("cor:nontrivial … untouched"). This plan does NOT. The accounting, displayed:

- `thm:concentricity` (re-encoded) = transport connectivity on the **populated** object.
  Proved, class-wide — *by design* (the author's ruling; the class-wide fact is stated as a
  lemma, not hidden).
- `cor:nontrivial` (one component of the **static** object ⟹ one real centre) does NOT ride
  on the re-encoded theorem. It consumes `placement_set` explicitly — the same content,
  moved one corollary downstream, not deleted.
- `cor:rh` unchanged: FE pins ½ once a common centre exists. RH remains gated by
  `placement_set`. **The open node keeps its statement and its sorry; only its address
  moves** (from inside the theorem to the translation layer). The bricks
  (`PLAN_two_index_bricks.md`) still target it.

## 2. What is NOT touched (the static spine stays green and load-bearing)

`Base.lean` (`Base = Discrete ℝ × SingleObj G2`, `level_eq_of_zigzag`, `zigzag_iff_level`,
`levelClass`), `Theorem.lean` frozen rows (`transportLevel`, `transportLevel_placement`,
`assemblyComponent`, static `concentricity`), `PlacementSet.lean`, Toolkit, TwoWorlds — all
untouched. The static object is exactly what makes "one static component = one level = one
centre" true, which is what `cor:nontrivial` needs. Deleting it was the revoked plans' move;
we keep it and re-badge docstrings only (§5).

## 3. New file: `Concentricity/TransportObject.lean` (statement shapes)

### 3a. The compactified base (construction from `PLAN_compactified_base.md`, readout re-scoped)

```lean
/-- The compactified level base: levels ℝ plus the single point at infinity N
    (`def:carrier`: every slice sphere shares the one N; ℝ ∪ {N} is one great
    circle, master line ~653). Morphisms: identities; for each finite level c
    the closing arrow `toN c : c ⟶ N` (the great circle closing through the
    pole); no arrows N ⟶ c; no arrows between distinct finite levels except
    through N. -/
def BaseC := OnePoint ℝ   -- category instance: thin, arrows = identities ∪ {c ⟶ ∞}
```

Band `F = SingleObj Circle` rides unchanged; `TotalTransport := ∫_{BaseC} F`
(Grothendieck, as before).

### 3b. Witness discipline (R9 — the arrows are earned, not free)

The closing arrow is legitimate only as the section's transport. Two packagings —
**author picks one**:

- **(i) witnesses in the homs:** `c ⟶ N` carries a `TransportWitness A c` as data
  (heavier category; the object itself is A-indexed: `TotalTransport A`).
- **(ii) witnesses as a quantified property (recommended):** `BaseC` free-shaped as in 3a;
  the theorem consumes `Populated A : ∀ c ∈ zeroLevels A, TransportWitness A c`, where

```lean
/-- The transport witness at level c: C1's pole value is 𝔫 (`c1_simple`,
    rmk:two-poles / rmk:collapse-cone), the continuation exists on Ω₀
    (`exists_log_continuation`), it is the one stem (`stem_identity`), the
    tame lift is unique (`winding_lift_unique`), and the value-loop closes
    through the pole cone (`winding_loop_defect`, GPVwind Cor 5.13). All
    five components are PROVED rows; the witness only packages them. -/
structure TransportWitness (A : ASection) (c : ℝ) : Type
```

If a witness component cannot be built from the proved stack for zero-bearing levels,
**R6-STOP with the exact goal** (the revoked plans' own guard, kept).

### 3c. The re-encoded theorem and its honesty pins (all in the same file)

```lean
/-- master `thm:concentricity` (re-encoded per the author's ruling 2026-07-05):
    the residue-ℂ zero classes of an A-section lie in a single connected
    component of the POPULATED total object — connected at 𝔫 by the section's
    own transport. Proof: the small argument — each witnessed `c ⟶ N` gives
    `Zigzag (ofLevelC c) (ofLevelC N)`; classes compose through 𝔫's class.
    Zigzag/ConnectedComponents only; no Functor.Final, no Quillen A. -/
theorem concentricity_transport (A : ASection) (hA : Populated A) (n m : ℕ) :
    transportClass A n = transportClass A m

/-- HONESTY PIN 1 (class-wide by design): any C1-bearing section is so
    connected — the 0.3/0.7 hypothetical included. This is the intended
    content ("holds for every section — the entire point"), recorded so the
    theorem is never mistaken for level separation. -/
theorem transport_universal ...

/-- HONESTY PIN 2 (no centre readout from the populated object): in
    π₀(TotalTransport) all finite levels share 𝔫's class — the populated
    object separates no levels; `cor:nontrivial` cannot and does not ride
    on it. -/
theorem transport_not_level_separating :
    ∀ c c' : ℝ, classOfLevel c = classOfLevel c'

/-- HONESTY PIN 3 (the address of the remaining content): one component of
    the STATIC object ⟺ one level ⟺ `placement_set` — the existing proved
    welds (`zigzag_iff_level`, `levelClass`, `placement_set_iff`).
    `cor:nontrivial` consumes THIS, i.e. consumes `placement_set`. -/
theorem translation_requires_placement ...
```

Pin 1 discharges the previous handoff's verification step (0.3/0.7) as a positive lemma:
the hypothetical gets one component in the populated object (intended), and its centre
statement stays exactly as open as `placement_set` (Pin 3).

## 4. Anti-shortcut guards (kept from the revoked plans, verbatim in force)

No step reads `(sphereZero n).re` inside the transport construction; no zero is fed in to
pick its component; `transportClass` is defined from the populated object and the witnesses
only. Any leak of level data into the construction is an R6 stop.

## 5. Re-badging (docstrings only, no statement edits)

- Static `concentricity` (Theorem.lean:243): docstring re-badged as the Lean carrier of
  `cor:nontrivial`'s content — one static component = one centre — OPEN at
  `placement_set`; master label `thm:concentricity` transfers to `concentricity_transport`.
- `transportLevel` / `transportLevel_placement`: re-badged as the translation-layer form of
  the node (the weld to `placement_set` already proved). Rows frozen; sorry stays.

## 6. Housekeeping (author's call)

Unimport `Concentricity.LiKernel` from the root (per the standing handoff instruction
"leave it unimported or delete it") — its 3 deprecated sorries leave the imported ledger;
file kept on disk per protocol. After this plan + housekeeping, the imported ledger is:
**one welded node (`placement_set` ≡ `transportLevel_placement`), 0 axioms** — same node,
honest address, plus a proved `concentricity_transport`.

## 7. Master folds (Lane B, only after Lean is green; R7 diffs)

thm:concentricity restated on the populated 𝒯_A; the red TODO moves from the theorem's
proof into cor:nontrivial (which gains explicit \uses{placement}); rmk:pi0-split's finality
half becomes the actual proof shape on the populated object (no longer placement-consuming
there) while Edit 4's qualifier stays true of the static readout; MASTER_DIFF_folds Edits
2–4 redrafted; supersession notes dated 2026-07-05 for: the July-4 revocation scope, Edit 3's
"no morphism is added anywhere," and the keystone-sentence framing of the 2026-07-05 09:47
HANDOFF.md. Sources for the finality reading: `inbox/cathtpy.pdf` (Riehl §8.3/§8.5),
`inbox/Goerss-Jardine2.pdf`; the Lean proof itself uses neither (Zigzag only).

## 8. Execution order

1. Author confirms §3 shapes (packaging (i)/(ii)), §5 re-badging, §6 housekeeping.
2. Lane A lands `TransportObject.lean` sorried, imports it, `lake build`; then closes
   `concentricity_transport` + pins from the proved stack, one goal at a time; R5 live
   checks (`OnePoint`, `Zigzag`, `ConnectedComponents`). Any resisting goal: R6 stop,
   exact goal, no prose.
3. Re-badge docstrings (§5); unimport LiKernel (§6); commit table + ledger report.
4. Lane B master folds (§7). 5. Bricks resume toward `placement_set`
   (`PLAN_two_index_bricks.md`), unchanged, now aimed at the translation layer.
