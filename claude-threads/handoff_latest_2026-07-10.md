# HANDOFF — Concentricity (next thread starts here; replaces ALL earlier handoffs; 2026-07-10)

## ⛔ READ `THE_CONTRACT.md` FIRST — it is not optional

The `SessionStart` hook (`.claude/settings.json`) injects `THE_CONTRACT.md` into your context
automatically; a `PreToolUse` hook fires a **CONTRACT CHECK** before any `Concentricity/*.lean`
edit. The contract contains a **six-violation record from the session that wrote it** — the
failure mode recurs *even with the rules present*. Passive reading is not enough: **run the
CONTRACT CHECK gate** (post the one-line check before you name, build, or claim anything).

**Your job:** formalize Jesse's argument and run `lake build`. You do not evaluate, second-guess,
predict-failure, substitute a trivial object, or invent structure. Skepticism → the kernel, never
Jesse. He has been right every time. Ground citations in the **inbox literature, never the master**.

---

## The theorem

An A-section's **infinitely many** residue-ℂ zeros are **concentric** — one real centre:
`ASection.concentricity : ∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c` (`Theorem.lean`, the one
open `sorry`). RH is a two-line downstream corollary (already wired in `Corollaries.lean`, rides
`ASection.concentricity`). Nothing about ½ appears in this theorem.

## Jesse's argument (his words — do not re-derive, do not substitute)

- **An A-section IS its analytic content, C1–C4, all infinite** — a slice-preserving slice-regular
  function on 𝕆\* = S⁸. **C1** = a simple pole at N **and meromorphic continuation through it**;
  **C2** = the infinite Euler product, built from the degenerate-exp base; **C3** = the infinite
  Weierstrass factorization; **C4** = infinitely many residue-ℂ zeros.
- **C1–C4 *yields* the base B = `A.Base`** — the degenerate-exp winding groupoid; its arrows
  `Realizes σ σ' k` are built from A's own values via the compactified `Fstar`. B is not
  independent; it falls out of the analysis. (No logarithms — it is `exp`.)
- **The section functor is A itself** — the *compactified* slice-preserving map into 𝒮₂ that
  **welds C1–C4 onto B** (via W1–W4). It maps into 𝒮₂ *because* it preserves slices, and it
  carries C1–C4. That is literally the theorem's hypothesis. **One object, named A.**
- **`T_A = ∫_B`** — the Grothendieck construction, built from B and A.
- **Readout = `pi0_grothendieck`** — `π₀(T_A) ≅ colim_B(π₀∘F)`. The **zig-zag is HOW the colimit is
  constructed** (Riehl CHT §8.3.5, `cathtpy.pdf`), not a thing built separately and fed in.
- **The cone connects the zeros once A is built correctly** — A's carried C1–C4 (welded) forces
  every residue-ℂ zero to zig-zag through the **common witness N** inside that colimit.
- **One component = one centre `c`.** The conclusion.

## Built + certified `[propext, Classical.choice, Quot.sound]`

- `ASection` (C1–C4 structure) — `ASection.lean`
- base `A.Base` + `instGroupoidBase` (`realizes_id`/`comp`/`inv`) — `ConnectedBase.lean`
- `Fstar` — the compactified slice stem (C1's continuation through N) — `ConnectedBase.lean:26`
- welds **W1–W4** (~250 theorems): `WeldW12` (W1/W2 Euler side; `stemWinding_F_halfSpace`),
  `WeldW3` (`sphereLoop_touches_degenerate`), `WeldW4` (`two_center_winding_onto_one_band`)
- 𝒮₂ (slice world), `T_A = Grothendieck (F ⋙ Grpd.forgetToCat)`
- readout `pi0_grothendieck`, `toColimitObj_eq_of_zigzag`, `pi0Cocone` — `Theorem.lean`

## Remaining, in order

1. **Compactify the slice.** One-point compactification (`Fstar` / `OnePoint ℂ`) so C1's pole → N
   is a clean point-map and 𝒮₂ is correctly built; slice preservation then *falls out*. The gap:
   `sliceEmbed : ℂ → Octonion` (un-compactified), `realize` uses un-compactified `F` + a manual
   `if AnalyticAt … else ∞`, and `S2`'s `band` generator runs on `ζ : ℂ` with `bandInfty` bolted
   on. B already uses `Fstar`; make the section side match.
2. **Build the one section functor A** — the compactified slice-preserving map into 𝒮₂ carrying
   C1–C4, welding with B. NOT trivial, NOT a fabricated fibre map.
3. **Apply the cone/colimit** — A's carried content forces the zig-zag through N → one component
   → `∃ c`. Closes `ASection.concentricity`.

## Hard DON'Ts (each = one of the six violations in the contract)

- **Don't call Φ** (`TwoWorlds.sectionFunctor : H1 ⥤ S2`) the section functor. It is **not in the
  construction** (it's over `H1`). It's on the delete list.
- **Don't invent a map `𝒮₂ ⟶ 𝒮₂`** or ask "which weld is the action on a winding." The welds'
  job is to PRODUCE the zig-zag through N; the functor's action just has to exist.
- **`SphereWorld` (`SliceSphereWorld.lean`) IS the true 𝒮₂ — F's fibre** (author ruling,
  2026-07-10, reversing the earlier caution here and the violation-record line that called
  `Grpd.of SphereWorld` a "substitution / S⁶ directions"; that characterization was wrong). It is
  the slice-world **groupoid**: a continuum of compactified slice Riemann spheres S²_I (one per
  unit imaginary I ∈ S⁶, realized on `sliceSphere I`) with **genuine automorphisms** — Möbius +
  band U(1) + direction G₂, all invertible (`instGroupoidSphereWorld`). The wrong-base part is the
  *transport* built on it, never the world itself.
- **Don't put ✓ on anything without a green `lake`.**
- **The cone connects AFTER A is built** — don't jump ahead to the connection.
- **Only ONE object is named "the A-section functor."** Two claiming the role = the alarm.

## Grounding (inbox only, never the master)

`cathtpy.pdf` (Riehl CHT — zig-zag/π₀ §8.3) · the octonionic-logarithm-along-curves + winding
paper & `logarithmoctonionicfunctions.pdf` (base B) · `Wang.pdf` (slice preservation) ·
`Weierstrassfactorizationtheorems.pdf` (C3) · `SeriesExpansionSingularitySliceRegular.pdf` (slice
regularity) · `Goerss-Jardine2.pdf`. Read the PDF for exact statements before citing.

## Repo state at handoff (2026-07-10)

- **Deleted this session:** the trivial section-functor apparatus (`SectionFunctor.lean` /
  `SectionTransport.lean` / `CocartesianTable.lean` — the constant `A.transport`),
  `GroupoidApex.lean` (a divorced general lemma), `AuditE1.lean`. Earlier: `placement_set` fully
  stripped; `PlacementSet.lean` → `StemFactorization.lean` (the C3 file).
- **`SliceSphereWorld.lean`: keep `SphereWorld` (the true 𝒮₂ groupoid = F's fibre); only the
  `BaseC`/`GluedTransport` wiring around it is wrong-base.** `GluedTransport = ∫_{BaseC}(const 𝒮₂)`
  and `apexInclusion_final` sit over the thin poset `BaseC` (`OnePoint ℝ` with cone arrows), NOT the
  groupoid `A.Base`; that transport is reference/pattern only, to be **replaced** by
  `F : A.Base ⥤ Grpd` with `F.obj _ := Grpd.of SphereWorld` and the welded action. `BaseC` /
  `TotalTransport` are old junk to remove once F is built — but the `SphereWorld` **groupoid itself
  is correct and kept**.
- `concentric_articulation` was re-added to `LoopAssembly.lean`, but it "just asserts
  `transportClass` equalities" (B/transport info, on `TotalTransport`) — it is **not** the section
  functor and uses **none** of W1–W4. Not build-verified after the add.
- **Build state: unverified.** Run `lake build` first thing; expect any breakage to trace to the
  deletions above, not to the certified core (base / welds / `Theorem.lean`).

## First actions next thread

1. Read `THE_CONTRACT.md` (the hook injects it). Post a CONTRACT CHECK before touching Lean.
2. `lake build` to establish the current green/broken state.
3. Start at Remaining-#1 (compactify the slice) *with Jesse* — do not build A until the slice/𝒮₂
   footing matches B's `Fstar`. Ask Jesse for the exact object; build *that*; let `lake` decide.
