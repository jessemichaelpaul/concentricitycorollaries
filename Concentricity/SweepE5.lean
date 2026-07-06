/-
Concentricity/SweepE5.lean

E5 — THE MASTER/SOURCES SWEEP FOR THE UNTRANSCRIBED CLAUSE (unimported
artifact, KeystoneAssembly/GreatCircleRoute precedent; root ledger
untouched; NO sorry anywhere in this file — every row below is PROVED).

THE SWEEP OF RECORD (2026-07-06; master Part 3 read in full,
`def:A-section` → `cor:rh`, every \uses{} arrow and citation cross-checked
against the repository; SOURCES/GPVwind.md, SOURCES/VS.md,
SOURCES/AdFslice.md, SOURCES/Wang.md, SOURCES/GPS.md read in full):

1. The master's own printed proof of `thm:concentricity` does NOT prove
   the placement — it PRINTS IT OPEN. Verbatim (placement paragraph):
   "That the degenerate fibre of the unique tame transport attached to
   the A-section — the residue-ℂ zero-spheres {q_n} of C3 — lies over a
   *single* level is the *placement*, the document's one open node, in
   its official enumeration-free set-level form"; and after
   eq:placement-set: "Granting the placement, the proof concludes."
   `rmk:two-index-roadmap` (verbatim): "The clause of (iii) either
   derives from C1–C4 or stands as a named additional property of the
   member under study; deciding which is the route's endpoint." There is
   therefore NO printed-but-untranscribed inference that closes the
   placement: the master itself marks that inference as its open node.

2. Printed-but-untranscribed clauses found by the sweep (ranked; none
   feeds the divisor statement — each is value-side/divisor-free and
   holds verbatim for the 0.3/0.7 litmus section):
   (a) GPVwind σ-apparatus — Defs 5.1, 5.2, 5.7, 5.15, 5.16, 5.17, 5.19,
       Prop 5.8, Cor 5.13 (full iff), Cor 5.21 (with its printed evenness
       hypothesis). Recorded GAP (Toolkit.lean `winding_loop_defect`
       docstring); E3's active lane (SigmaE3), not duplicated here. Shape:
       direction-field data of arbitrary value-loops — divisor-free.
   (b) VS thm:log-manifold environment — Prop 5.1 (E, the manifold),
       Def 5.3 (L = log|q| + p), Prop 5.4 (L = E⁻¹, diffeo), Def 5.5
       (branches). Only docstring mentions in the repo; the LEVEL
       component of Def 5.3 is transcribable and IS transcribed below
       (rows 1–2): it is the value→level register conversion the
       placement paragraph consumes ("the level log r = log|−r|",
       lem:exp-degenerate). Divisor-free.
   (c) AdFslice Thm 3.2 (h^s = μ iff μ ≥ 0 on Ω∩ℝ and even real-zero
       orders) — no Lean row; sign/symmetry data on the real line only
       (AuditE1's field audit: "never level data"). Divisor-blind.
   (d) Wang Rem 2.11 full text (commutativity/associativity of the
       regular product for slice-preserving factors) — carried
       structurally by the stem-functor definition of 𝓡 (StemRing);
       no separate row needed.
   (e) GPS §11 semiregular equivalence in `def:A-section` ("equivalently,
       a slice-preserving semiregular function") — definitional gloss on
       the class carrier, no inference rides on it.
   (f) `rmk:pi0-split` finality proof (Quillen Thm A, precofibred
       corollary) — the master deliberately leaves it unformalized
       ("expository and not used here"); it CONSUMES the placement.

3. What the proved rows below add: the exact register geometry of the
   printed sentence "the residue-ℂ zero-spheres {q_n} of C3 are exactly
   this degenerate fibre" (assembly paragraph). Rows 1–2 transcribe VS
   Def 5.3's level readout — along ANY log-continuation the level tape is
   log‖value‖, always, everywhere (the value register determines the
   level totally). Rows 3–4 prove that near ONE enumerated zero-sphere
   the encounters realize levels unbounded below and never a unique
   level — so the value-side register assigns NO canonical level to a
   zero-sphere. Together: the "single level" of the placement cannot be
   read from the value side at all; it is irreducibly the DOMAIN-side
   statement Re(sphereZero n) = Re(sphereZero m) = eq:placement-set,
   exactly the welded open node. The recorded failure mode (Draft I
   receipt, LoopAssembly.lean) is hereby a THEOREM, not a prose verdict.

`sorry` marks UNFORMALIZED, never UNSOUND (R8); this file carries none.
-/
import Concentricity.LoopAssembly

noncomputable section

open Filter

/-! ## §A — VS Def 5.3, the level readout of L, transcribed (slice form) -/

/-- **VS Def 5.3, the level component of the E⁺-logarithm, total form**
(SOURCES/VS.md, verbatim: "L(q, p) := log|q| + p" — the level coordinate
of the E⁺-logarithm is the log-modulus of the value, for EVERY point of
the logarithm manifold, not only over the degenerate values). Slice form,
DERIVED (R10): the real part of any logarithm w of a value reads
log‖value‖. Pins: `Complex.norm_exp`
(Mathlib/Analysis/Complex/Trigonometric.lean:995), `Real.log_exp`
(Mathlib/Analysis/SpecialFunctions/Log/Basic.lean:74). This is the
register conversion VALUE MODULUS → LEVEL that `lem:exp-degenerate`
instantiates at −r ("the single real level log r = log|−r|"). -/
theorem sweepE5_level_readout (w : ℂ) :
    Real.log ‖Complex.exp w‖ = w.re := by
  rw [Complex.norm_exp, Real.log_exp]

/-- **The tame lift's level tape** (master, placement paragraph: "the
unique tame lift traverses the logarithm manifold"; VS Def 5.3 read along
the traverse): at EVERY instant the lift's level is the log-modulus of
the value under it. DERIVED (R10), over the vocabulary of
`exists_log_continuation`/`winding_lift_unique` (Toolkit.lean). The level
tape is a function of the VALUE PATH alone — the domain point whose value
it is never enters. -/
theorem sweepE5_lift_level_tape (γ γ' : C(unitInterval, ℂ))
    (hlift : ∀ t, Complex.exp (γ' t) = γ t) (t : unitInterval) :
    (γ' t).re = Real.log ‖γ t‖ := by
  rw [← hlift t, Complex.norm_exp, Real.log_exp]

/-! ## §B — the register wedge at one zero-sphere (the sweep's finding as
theorems; consumes the PROVED `neg_reals_swept_near_sphereZero`) -/

namespace ASection

/-- **The encounter levels at ONE zero-sphere are unbounded below**
(PROVED): within any ε of an enumerated zero, degenerate encounters
realize value-side levels log r below every bound. Fed by the open-mapping
row `neg_reals_swept_near_sphereZero` (LoopAssembly.lean, PROVED). Pin:
`Real.log_lt_iff_lt_exp`
(Mathlib/Analysis/SpecialFunctions/Log/Basic.lean:162).

Register note (R10, DERIVED): the value-side ladder levels met near one
zero-sphere form no single level — they run to −∞ as the encounter value
−r → 0. The placement's "single level" is therefore not a value-side
datum of the encounters. -/
theorem sweepE5_encounter_levels_unbounded_below (A : ASection) (n : ℕ) :
    ∀ ε > 0, ∀ M : ℝ, ∃ r : ℝ, 0 < r ∧ Real.log r < M ∧
      ∃ z : ℂ, dist z (A.sphereZero n) < ε ∧ A.F z = -(r : ℂ) := by
  intro ε hε M
  obtain ⟨η, hη, h⟩ := A.neg_reals_swept_near_sphereZero n ε hε
  have hexp : 0 < Real.exp M := Real.exp_pos M
  have hr0 : 0 < min (η / 2) (Real.exp M / 2) :=
    lt_min (by linarith) (by linarith)
  have hrη : min (η / 2) (Real.exp M / 2) < η :=
    lt_of_le_of_lt (min_le_left _ _) (by linarith)
  have hrM : Real.log (min (η / 2) (Real.exp M / 2)) < M := by
    rw [Real.log_lt_iff_lt_exp hr0]
    calc min (η / 2) (Real.exp M / 2) ≤ Real.exp M / 2 := min_le_right _ _
      _ < Real.exp M := by linarith
  obtain ⟨z, hz, hzv⟩ := h _ hr0 hrη
  exact ⟨_, hr0, hrM, z, hz, hzv⟩

/-- **No canonical value-side level at one zero-sphere** (PROVED): within
any ε of ONE enumerated zero the encounters realize (at least) two
DISTINCT values −r₁ ≠ −r₂, hence — by the proved fibre reading
`exp_fibre_level` (`lem:exp-degenerate`) — degenerate-fibre data at two
DISTINCT base levels log r₁ ≠ log r₂.

Register note (R10, DERIVED): this is the recorded Draft-I failure mode
as a theorem. The value-side apparatus (the ladders, the levels log r,
the winding heights — everything GPVwind/VS print) attaches a whole RAY
of levels to each zero-sphere, identically for every C1-bearing section
(litmus-consistent: a 0.3/0.7 divisor produces the same rays). The
placement's single level lives in the DOMAIN register Re(sphereZero ·)
alone; the identification of the two registers is eq:placement-set
itself — the master's one open node, with no printed proof to
transcribe (master, proof of thm:concentricity: "Granting the placement,
the proof concludes"). -/
theorem sweepE5_encounter_level_not_unique (A : ASection) (n : ℕ) :
    ∀ ε > 0, ∃ r₁ r₂ : ℝ, 0 < r₁ ∧ 0 < r₂ ∧ r₁ ≠ r₂ ∧
      (∃ z : ℂ, dist z (A.sphereZero n) < ε ∧ A.F z = -(r₁ : ℂ)) ∧
      (∃ z : ℂ, dist z (A.sphereZero n) < ε ∧ A.F z = -(r₂ : ℂ)) := by
  intro ε hε
  obtain ⟨η, hη, h⟩ := A.neg_reals_swept_near_sphereZero n ε hε
  exact ⟨η / 2, η / 4, by linarith, by linarith, by linarith,
    h _ (by linarith) (by linarith), h _ (by linarith) (by linarith)⟩

end ASection
