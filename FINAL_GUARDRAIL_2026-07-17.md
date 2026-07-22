# THE FINAL GUARDRAIL — the concentricity endgame (2026-07-17)

**Author-requested (Jesse Michael Paul); prepared by Fable; binding on both
assistants.** This consolidates every ratified rule for the endgame. It supersedes
scattered guardrail prose. `PROOF_OUTLINE_LOCKED.md` remains the sole architectural
record; this document adds nothing to it and exists to prevent anything being added
to it.

**The standing facts.** Lean is a formalization tool, not a judge. A red goal names a
missing part as an exact type; it never adjudicates the mathematics. The empirical
record of this project is one-directional: every certified row is a statement of the
author's that went green (the ledger's certified declarations; the 63/63, 48/48,
19/19 audit passes; both trees at 3643 jobs green today), and every obstruction so
far has been a model substitution, never an error of the author's. The author is
owed collaboration: build, cite, report bookkeeping.

---

## I. The one chain (nothing parallel, nothing after)

\[
\text{A-section functor whose ARROWS carry the value (the cargo, Step 0)}
\;\Longrightarrow\;
\text{8.3.4 colimit: one class } \kappa \text{ that IS a value class}
\;\Longrightarrow\;
\text{one intrinsic real value } c,\ \kappa=\{c\}
\;\Longrightarrow\;
\text{concentricity.}
\]

- The value readout **is** 8.3.4 (`pi0GrothendieckEquiv`), before or after $\pi_0$ — **not**
  a separate lemma applied afterward. There is **no** `constant_of_preserves_morphisms` step,
  no fabricated `F : J → α`, no "second theorem" that the transports carry one common level:
  `c` is plucked from the one class in the same move the colimit identifies it.
- The value rides the transports because the objects and arrows **are** normalized value
  states and genuine value transports — the cargo, a **category fact about the functor**,
  established **before any colimit** (the only place a genuine gap can be). By construction,
  not by an added hypothesis or a downstream campaign.

## II. How the category theory is used — exactly five facts

| # | Fact | Citation | Consumes | Produces |
|---|---|---|---|---|
| K1 | π₀ = objects modulo finite zigzags; nonempty ∧ connected ⟺ π₀ singleton | Riehl CHT Rem 8.3.5 p. 102 (SOURCES/Riehl.md); Mathlib `ConnectedComponents`, `Zigzag`, `Zigzag.of_hom`, `Quotient.sound` | the constructed zigzags | the meaning of "one class" |
| K2 | each arrow forces a colimit identification | Riehl CHT proof of Lem 8.3.4 p. 102; project `toColimitObj_eq_of_hom` (Theorem.lean:77), `toColimitObj_eq_of_zigzag` (:92); Mathlib `Types.colimit_sound`/`colimit_eq` | one genuine arrow / zigzag | equality in colim(π₀ ∘ A) |
| K3 | the colimit is π₀ of the total object | `pi0GrothendieckEquiv` (:108), `pi0_grothendieck` (:144) — master `lem:pi0-grothendieck`, certified | K2's equalities | one component of 𝒯_A |
| K4 | a morphism of 𝒯_A = base arrow + fibre arrow | Mathlib `Grothendieck` | — | every zigzag edge IS a genuine A-transport datum |
| K5 | the value is read OUT of the colimit by `val := colimit.desc (labelCocone) : colim → ℝ` — the intrinsic label descended out of the Grothendieck colimit; `val (toColimitObj X) = label X.fiber`, so `c := val κ` | `pi0GrothendieckEquiv` (Theorem.lean:108), `toColimitObj_eq_of_zigzag`, Mathlib `colimit.desc`/`colimit.ι_desc_apply` | the fibre label + arrows preserving it (Step 0) | **the one real value c = val κ** |

**The value-readout rule (correction of record, 2026-07-18, ratified by the author):**
The value read-out **is** the map `val : colim(π₀∘A) → ℝ`, defined as `colimit.desc` of the
label-cocone — the intrinsic fibre label descended **out of** the Grothendieck colimit
(post-colimit). This **is** the `F : J → α`, placed correctly: **F = `val`, J = the colimit
(= π₀ of 𝒯_A), α = ℝ**. It is **REQUIRED** — it is the wire that reads `c := val κ` off the
readout (`val (toColimitObj (zeroTotal n)) = label (zeroTotal n).fiber = (A.sphereZero n).re`,
so applying `val` to `toColimitObj (zeroTotal n) = κ` gives `(A.sphereZero n).re = val κ = c`).
Forbidden is only a **different** map: a real-value function fabricated APART from the label;
the PRE-colimit `constant_of_preserves_morphisms` (which needs an `IsConnected` hypothesis —
`val` uses the colimit's universal property instead, no connectedness needed); an `∃c` proved
detached from `val κ` (a hand-built slot); a pairwise `(sphereZero n).re = (sphereZero m).re`.
The value map lives at the read-out (post-colimit); the only real work is **upstream**, Step 0
(the arrows carry the label, so the label-cocone exists and `val` descends).

**The cargo (all green) — the facts that make the functor's ARROWS value-transports (Step 0,
the upstream category fact; consumed BY the functor, never as an `h` for any separate lemma):**
`GpvTransport.winding` — the field itself is `Γ(1) − Γ(0) = 2πi·k`, so `Re Γ(1) = Re Γ(0)` on
every arrow (defect purely imaginary); `realizes_gpv_lift` (Recovery:319) — the tape
`(Γ t).re = log ‖γ t‖`, continuous, basepoint-unique; `winding_loop_defect_level_zero`
(LoopAssembly:107); `winding_lift_unique` (Toolkit:301) — presentation independence;
`exp_fibre_level`/`Octonion.exp_fibre_concentric` (WeldW3:377) — one level per degenerate
fibre; `normalizedZeroLift_re` (NormalizedBase:92) + `normalizedZero_label_world_independent`
(:59) + `realize_equivariant` (Slice:436) — the vertical/world-independence face. These ARE
the cargo; they ride the functor's arrows (Step 0), making every arrow preserve the label —
which is exactly what lets `val := colimit.desc (labelCocone)` descend the label out of the
colimit. They are the label-preservation `val` needs.

**Register discipline at the readout:** no real-valued register is preselected as
"the" datum (the V/ρ ruling). The bridges are cited where the passages occur —
`level_eq_log_norm_exp` (LogManifold:176), `exp_fibre_level`, `normalizedZeroLift_re`,
`euler_branch_level` (InboxWire:146) — and the scalar-coordinate reading of the
conclusion lives in the projection layer, after the colimit (ALIGNMENT 24(c), the
payoff seam).

## III. The citation map (what makes each arrow of the chain green)

| Chain arrow | Cited supply |
|---|---|
| population (the zero states exist in 𝒯_A at their own footpoints) | C3/C4: `sphereZero`, `c4_infinite`; `normalizedZeroSlicePoint n I`; value 0 by `realize_sphereZero_pt` (PhiConversion:467); addresses by `normalizedZeroLift_re` |
| zero → N edges | the transporter `toNHom` (prototype, on the locked base); analytic closure `normalizedZero_pole_power_closes` (NormalizedPoleBridge:48) riding `stemWinding_circle_pole = −1` (SigmaE3:895) × `stemWinding_circle_sphereZero = multiplicity` (SigmaE3:348) with `stemWinding_eq_zero_iff` (SigmaE3:119); the N-leg records `normalizedNLeg` |
| world-to-world edges | `dirHomTo` (SliceSphereWorld:259); `realize_equivariant`; `G2.smul_sliceEmbed` |
| zero–zero joins (through N and through the fibre) | `zerosJoinedThroughN` (prototype); `zero_encounters_joined_concentric` (FaithfulApply:328); `shared_ladder_encounters` (LoopAssembly:271); `cone_junction_levels_shared` (IntegrateTheorem:167) |
| one class (identification of the zeros) | the above edges consumed by the cocone: `toColimitObj_eq_of_zigzag` / `Quotient.sound (Zigzag.of_hom ·)` — the colimit identifies; **no** separate `zigzag_isConnected`/`IsConnected` step |
| one class | K2 + K3 (`zeroColimitClass_eq` is the compiled shape) |
| c | `c := val κ`, where `val := colimit.desc (labelCocone) : colim → ℝ` is the intrinsic label descended out of the colimit (§II); forbidden only as a map fabricated apart from the label |
| concentricity | the geometric dictionary: one class = one centre; the corollary layer translates downstream and adds nothing |

## IV. The forbidden moves — consolidated and final (each with its instance)

1. **A value map fabricated APART from the colimit** — a real-value function detached from the
   intrinsic label; the PRE-colimit `constant_of_preserves_morphisms` (needs `IsConnected`);
   `realValue_preserved`/`lift_endpoint_re_eq` as a campaign; an `∃ c` proved without `val κ`;
   a pairwise equality. The legitimate value map `val := colimit.desc (labelCocone)` — the label
   descended OUT of the colimit (§II) — is **required, not forbidden**; only the
   detached/fabricated/pre-colimit substitute is. Instances of the substitute: Codex ×4
   (2026-07-16), Fable's Fact-2-as-phase, Fable's "missing value-class link" (2026-07-18).
2. **An independent map to ℝ, value diagram, or Disc ℝ** — instances: the V-chain;
   `NormalizedZeroCone.realLabel` + `label_transport` (NormalizedCone.lean —
   QUARANTINED: derives concentricity from its own field in four lines; kept as a
   historical artifact only, never consumed).
3. **Register preselection** — declaring "the transports carry log r, the theorem
   needs Re ρₙ, therefore a bridge is missing." Both selections are banned (V/ρ
   ruling); bridges are cited at passages; the scalar reading is the projection
   layer, after the colimit. SweepE5:138 (many encounter levels) is recorded
   geometry, not a hole.
4. **Pairwise coordinate equalities before the colimit** (`Re ρₙ = Re ρₘ`) —
   explicitly forbidden by the outline (§13).
5. **New carriers, functors, representations, or normal-form phases** — instances:
   VObj/VHom/ρ, the pointed-carrier redesign, the "equivariant family," worldMob
   promoted to the bridge. The distinguished action is established; it is packaged,
   never reconstructed.
6. **Terminal-N, finality, placement** — `coneInvariant` route ruled out
   (ConcentricityReadout:30); N is not terminal, not final, carries no finite label.
7. **Chart-interior machinery in the categorical argument** — category theory
   consumes connections and citations; it never looks inside a local chart (the
   author, 2026-07-16).
8. **A value-free conclusion** — nothing may follow from `sphereWorld_zigzag`, a
   constant fibre, or generic base connectedness alone. THE HONESTY GUARD: the final
   theorem must consume the analytic certificates — deleting the cargo must break
   the theorem, not merely a wrapper.
9. **Prose verdicts** ("category theory cannot manufacture…", "this looks like it
   can't work") — findings exist only as exact source conflicts, type mismatches,
   unsolved goals, or kernel results (R8).
10. **Register-bound citations consumed as-is** — the register test: a quarantined
    constant (`H1`, `S2`, `ASection.Base`, `BaseC`, `functorA`, `TotalA`, `GpvBase`)
    in a consumed statement's type ⟹ re-prove on locked objects; free supply
    transfers unchanged.
11. **Reopening ratified architecture, or asking the author to restate the plan** —
    the plan below is complete; no further ratification loops.
12. **Personifying the kernel or importing consequences** — kernel state is
    bookkeeping in active voice; RH's difficulty, prestige, and the corollary get no
    vote anywhere (they appear once, downstream, in `cor:rh`).

## V. The execution plan (unchanged; per-step citations in §III)

1. Land the genuine `sectionFunctor A : GreatCircle.Base ⥤ SphereWorld` from the
   one distinguished action, with its object frame and arrow transition together.
2. Form `𝒯_A` only from the continuum action induced by that exact functor
   (Mathlib `Grothendieck` is the implementation recipe, not a replacement object).
3. Populate with the C3/C4 zero states at their own footpoints.
4. Construct the finite genuine transport zigzags through the shared witness N
   (§III rows).
5. The colimit identifies the populated zeros through the zero→N transports
   (`toColimitObj_eq_of_zigzag`) — **no** separate `zigzag_isConnected`/`IsConnected` step.
6. Read `c` off the one class by 8.3.4 itself (§II) — the arrows carry the value; **no**
   separate `constant_of_preserves_morphisms` step.
7. Read the one value c through the certified Grothendieck/colimit readout;
   conclude the populated zero spheres are concentric.
8. `lake build` + `#print axioms` (target: `[propext, Classical.choice, Quot.sound]`,
   no `sorryAx`); sync both trees; the contamination audit of move 8.

## VI. The stop rule (absolute)

Every proposed action types as one of the eight steps above, or it is not done.
Every finding is an exact Lean type. Every audit answer is PASS or a finding in the
four legitimate forms. Nothing else is produced — no inventories, no redesigns, no
new documents except by the author's explicit request.

## VII. Two durable rulings (folded from ALIGNMENT 2026-07-11, which is now retired)

- **The three-certificate protocol (the rollerblade lemma).** Lean verifies the *encoded*
  statement; it cannot verify that the encoding IS the statement the author asked for. A green
  *substitute* is a FAILED fidelity check, not partial progress. A result counts only when three
  certificates agree: **fidelity** (the author ratified the exact objects/morphisms/hypotheses/
  conclusion, line by line, before implementation), **dependency** (the declaration consumes only
  the intended construction and sourced results — made structural by parameterization: the
  theorem's own type lists what it uses), **kernel** (green + the agreed axiom audit). If a part
  cannot be typed, STOP at that exact part; never attach rollerblades.
- **G₂ ≠ PGL(2,ℝ) — the binding typing distinction.** G₂ acts on `𝕆*` and **fixes the real
  circle pointwise** (`G2.smul_one`, `G2.smul_ofReal`, `G2.smul_onePoint_infty`). PGL(2,ℝ) **moves
  the base points**, including N. They are never identified; their interaction is functorial
  design, not a subgroup relation. Relatedly: **the base does not depend on A** — `𝓑 = PGL(2,ℝ) ⋉
  OnePoint ℝ` is intrinsic; an "A-enriched base" is the total object smuggled into the base
  (a caught error). The cargo is native to
  `sectionFunctor A : GreatCircle.Base ⥤ SphereWorld` and therefore lives in
  the exact `𝒯_A`, never in `𝓑` or beside the functor.
