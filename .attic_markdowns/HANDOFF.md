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

# HANDOFF — Concentricity (next thread starts here; replaces ALL earlier handoffs; 2026-07-15)

## ⛔ READ `THE_CONTRACT.md` FIRST — it is not optional

The `SessionStart` hook injects it. Then read, in order:

1. **HANDOFF_FUNCTOR_PHASE_2026-07-15.md** — the phase brief (the author; commit
   `e10746d` in the Codex tree): the immediate scope, the six freeze items, the
   guardrail list, the completion condition.
2. **PROOF_OUTLINE_LOCKED.md** — the theorem and proof architecture of record
   (14 sections, revised 2026-07-15). Carry its **typing guard**: κ ∈ π₀(𝒯_A) and
   c ∈ ℝ are DIFFERENT TYPES, never silently identified; the final Lean carrier of the
   real-value singleton is deliberately deferred until `A.obj`'s type freezes, and must
   expose value content already transported by A — never a new function over all of
   `s.Total`.
3. **ALIGNMENT_2026-07-11.md points 20–24** — the corrected proof burden, the
   substitution guardrails, the fidelity/three-certificate protocol, the cross-audit
   protocol (every substantive proposal crossing threads carries "AUDIT REQUEST" and
   the receiver leads with the audit), and the superseded-statement record.
4. **GREEN_LEDGER.md** — tier discipline (CERTIFIED/AXIOM-GATED/SORRY-GATED); no tier
   claim outside it; regenerate via `lake env lean _ledger_audit.lean`; after ANY
   interruption, first act = rerun the audit and diff against the ledger.
5. **COROLLARY_REWIRE_PLAN.md** and **ENDGAME_RELEASE_PLAN.md** — the downstream
   translation layer (½ enters only via the functional equation, downstream) and the
   private release gates (NOTHING public without the author's explicit authorization).

## Where you are

Three-way (the author + Codex in its full repo copy at
`~/Documents/Codex/2026-07-11/hey/work/concentricity` + Fable in the Desktop tree,
which is CANONICAL). Sync files across trees every turn they change — they do not cross
by themselves. Background jobs die silently when the machine sleeps.

LOCKED and kernel-checked: the base 𝓑 = PGL(2,ℝ) ⋉ OnePoint ℝ (`GreatCircle.Base`,
ProjectiveBase.lean); the sphere world (SliceSphereWorld.lean). The generic categorical
tail (π₀-singleton from IsConnected) kernel-checked independently by BOTH assistants
(ledger row). The certified engine: `pi0_grothendieck` (Theorem.lean:144). Riehl p. 102
and Rem 8.3.5 verbatim in SOURCES/Riehl.md; the GPV §4 lift/uniqueness cluster in
SOURCES/GPVwind.md with in-repo stem analogs CERTIFIED. Nothing pushed publicly (both
trees far ahead of origin — intentional).

## The immediate task (NARROW — the phase brief governs)

Conceptual and TYPED design of `A.obj` and `A.map` — the six freeze items in the phase
brief — cross-audited and author-ratified BEFORE implementation. Then implement ONLY
the functor and its laws (`A.map_id`, `A.map_comp` from W1–W4), `lake build`,
axiom/dependency audit, save, intentional commit. No total object, no corollaries, no
statement-carrier freeze before `A.obj`.

## The failure mode (memory: feedback-substitution-guardrails; ALIGNMENT 20–23)

Three-level slippage, named by the author and Codex 2026-07-15: (1) A transports
normalized analytic values; (2) the colimit identifies what those transports generate;
(3) the singleton carries the common real value c. NEVER externalize (1) into a
preservation hypothesis; NEVER claim (3) from a value-free (2) — for the genuine A the
class IS the value-class, κ = {c} (the author's ruling 2026-07-15, PROOF_OUTLINE_LOCKED
§1); NEVER consult older
documents without the author's latest ruling (stale formulations reintroduce dead
architecture). Amplifiers to watch: the easy-to-test constancy theorem's architectural
pull; "connected" used ambiguously (it means ONLY the derived zigzag connectedness of
the constructed transport category). The author's objects are immutable; no obstacle
found in a surrogate transfers to the original; probability/prestige/consequences get
no vote. He has been right every single time.
