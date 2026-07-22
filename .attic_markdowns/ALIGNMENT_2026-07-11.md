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

# THE SAME PAGE — three-party alignment, 2026-07-11

*One page for three independent checkers: the author (mathematics and register), Codex
(types and audit, in its tree), Fable (kernel and greps, in the Desktop tree). Every claim
below is either already checked by the named party or assigned to one. Nothing here is new;
this consolidates COMPARISON_INVENTORY.md (rules + rows), PLAN_theorem_of_record (statement
+ rulings), PLAN_lean_formalization (phases), MINUS_ONE_DOSSIER (the −1 registers).
If any party disagrees with a numbered point, that number is the next conversation.*

## Agreed

1. **Theorem of record** (D1–D3 resolved): the integrated ∃κ statement —
   `∃ κ, ∃ c, ∀ n I, zeroClass A n I = κ ∧ zeroCenter A n I = c` — as a plain Prop named
   `ASection.concentricity`; projections `zero_classes_common`, `zero_real_parts_common`;
   `Corollaries.lean` rewired once to the latter; prose says "their common component
   class"; the master is edited only after everything builds.

2. **The engine order**: build the complete enriched action first; derive connectivity
   second; apply the two categorical theorems third; read c := Re(ρ₀) last. Execution
   refined to Codex's nine steps (PLAN_lean_formalization §0.4).

3. **The base `B_A`**: the full compactified circle (N an object, no label on N); arrows =
   A's actual section transports (enriched `GpvTransport`); constructors W1/W2 loops and
   the C1/C3 multiplicity closures as composite material; `realizes_of_value_eq` admitted
   only if it survives the substitute-arrow audit (W-4); **no primitive `Z_n ⟶ N` arrows;
   no `center(𝔫)` label** (Rules 1–2). *Codex's audit note, recorded: the current
   `GpvTransport` excludes singular endpoints (N's identity and arrows need their own
   treatment), and the C1/C3 closure theorem is not yet an arrow of that type — both are
   Phase-1 obligations, agreed as targets.*

4. **The fibre**: **ONE sphere-world groupoid** (the author's correction — never one
   groupoid per sphere; the existing `SphereWorld` retained). Whether points enter as
   objects or as structured cargo is an explicit 0.3 decision — `NormalizedSlicePoint` is
   not promoted by default.

5. **Three interacting action layers, not one group inside another** (W-7,
   kernel-verified): G₂ *between* sphere objects, fixing 1, the reals, and N
   (`G2.smul_one`, `G2.smul_ofReal`, `G2.smul_onePoint_infty` — GREEN); Möbius
   (PSL(2,ℂ)) *within* charts — not a subgroup of G₂ (noncompact; and the band moves 1);
   U(1) inside Möbius, fixing 0 and N in every world (`bandEnd`, `bandMoebius_apply_*` —
   GREEN). Layer compatibility along G₂ legs is the green chart identity
   `G2.smul_sliceEmbed` (W-8).

6. **REVISED (Codex's disagreement + the author's axial-symmetry resolution, 2026-07-11
   evening): the section's G₂ behavior is induced canonically by equivariance — never
   extracted.** The normalized section maps every *existing* direction arrow to the SAME
   direction arrow: the commuting square `A(gq) = gA(q)` is the green
   `realize_equivariant` (Slice.lean:436, Wang Rem 2.11), with `sliceCoord_smul_invariant`
   (:425) and `realize_mem_sliceSphere` (:371). No G₂ element is extracted from a
   companion class (the SU(3)-stabilizer ambiguity never arises — the functor never
   chooses a g). The companion quotient [±I] certifies **representative independence**
   (ℂ_I = ℂ_{−I}), not arrow generation. **The section's slice restriction is NOT
   generally Möbius** (q ↦ q² acts slicewise as z ↦ z² — degree two): the section is never
   required to be a Möbius arrow; Möbius transformations are ambient chart automorphisms.
   The remaining audit determines: whether `liftPhase` yields a U(1) *path*, a *holonomy
   class*, or a *naturality witness* (an endpoint phase alone loses the winding — it is
   not the mob component of one `SphereHom`); and which specific Möbius arrows, if any,
   are genuinely induced by the section transport.

7. **REVISED (Codex's correction): the local package, stated honestly.** Every *fixed*
   shared negative-value encounter supplies a common level `log r` and phase −1, while the
   companion class [±I] is the *variable* sphere-direction datum. `shared_ladder_
   encounters` proves *existence* of a common r per pair and scale — not a canonical one;
   different permissible r give different levels. No canonical choice and no literal
   independence is assumed before the functor exists; the audit determines how different
   encounter choices and companion representatives are related — literally equal,
   equivalent, or merely connected by actual analytic and sphere-world transports. The
   ladder is analytic support, never the categorical connection (W-6).

8. **Naturality is scoped** (never blanket): G₂-equivariance across objects; compatibility
   with the *extracted* Möbius transformations; U(1) phase behavior from the lift. U(1) is
   not central in Möbius; `bandEnd` copies auto-cohere only along pure-G₂ legs.

9. **The −1 discipline (SHARPENED per Codex)**: five typed registers (ℤ winding;
   signature; value ℂ; U(1) half-turn; direction antipode ±Id). Three green bridges,
   named by their actual Lean content: **winding–height** (`winding_height_shift`),
   **value-sign–rung-parity** (`crossing_height_odd_of_neg`/`_even_of_pos`), and
   **stem-sign–log-strip-side** (`band_side_of_sign`/`crossing_band_ledger` — comparing
   `Real.sign (γ t).im`, rung parity, and which side of a height strip the lift occupies;
   involving NO S⁶ antipode, no `Circle`, no `bandEnd`, no `Moebius`, no `SphereHom`).
   **Still to be constructed**: the bridge from the source's companion antipode to the
   octonionic direction action, and from log-strip data to the Möbius U(1) action
   (GAP-2; `liftPhase` a candidate input). GAP-1: Cor 5.13/5.21 as Lean (evenness
   hypothesis + "circular" naming attached). **The band naming collision stands flagged**
   (W-1).

11. **The action-groupoid convergence (recorded 2026-07-11 late).** Codex's design sketch
    — objects `(I, q)`, pure G₂ morphisms `g : (I,q) → (gI, gq)`, the section acting
    fibrewise `(I,q) ↦ (I, Aq)` and sending each g-arrow to itself, well-defined exactly
    because `realize_equivariant` is green — **is the translation-groupoid register the
    master prescribes from day one**: `def:two-worlds` ("The two translation groupoids,"
    𝓗₁ = G₂ ⋉ 𝕆*, Lean pin `CategoryTheory.ActionCategory`), with the equivariant section
    functor as the master's Φ (`thm:section-functor`). The audit has walked the design
    back to the author's original architecture, now justified row-by-row.
    **0.3 agenda item (the two-actions distinction):** the section application is a
    NON-INVERTIBLE endofunctor (q ↦ q²), while `F_A`'s values on base arrows are
    invertible fibre equivalences (B_A is a groupoid) — so the section-as-Φ and the
    base-arrow transports are two different structures; neither replaces the other; how
    they compose is a 0.3 design question, not an assumption.

10. **Statuses corrected and binding**: H2 (connected ⟺ π₀ singleton) is TO-LOCATE/prove
    for the corrected construction — not green; "σ = c" in the proof plan of record is
    provenance question P-1 (W-3), never a cross-register identification; N keeps three
    typed appearances (base, sphere, 𝕆*) with compatibility as the functor's job.

12. **The author's closing proposal (2026-07-11, TO-DERIVE — the triangle mechanism).**
    The Möbius arrows genuinely induced by the section transport may be the
    **multiplication maps arising from the lift through the commuting triangle** — which
    is already a *field of the enriched arrow*: `GpvTransport.lift_exp : ∀ t,
    exp (lift t) = value t` (Recovery.lean:31; GPV Defs 4.1/5.11's `pr₁∘Γ = γ(∘exp)`;
    VS Rem 5.2(a)'s `π∘E = exp`), with `winding : lift 1 − lift 0 = 2πi·k` beside it.
    Candidate, stated for derivation: along an arrow set `μ(t) := exp (lift t − lift 0)`;
    then `value t = μ(t) · value 0`, `μ(0) = 1`, and each `μ(t)` acts on every
    compactified sphere as `z ↦ μ(t)·z` — the `diag(μ,1)` Möbius family extending
    `bandGL`, fixing 0 and N in every world. `|μ|` carries the level shift; `μ/|μ|` is
    `liftPhase` **as a path** (winding retained as holonomy — loops have `μ(1) = 1` with
    path class k). Canonicity from the unique tame lift (GPV Def 4.7/4.20; `gpvPopulated`
    field (a)); closure at N from the winding rows (pole −1, the multiplicity closures,
    W4's one band). If derived, this answers the DETERMINE items on encounter relations,
    `liftPhase`'s nature, and the induced Möbius arrows — and it meets the W-1 band
    collision honestly: **the log-strip band is the additive register of the
    multiplicative μ, intertwined by the triangle.** The section application stays
    untouched (never Möbius, q² unharmed): the section enters through equivariance
    (point 6) and as the source of the value paths. Status: **proposal of record for
    0.1/0.3 — derive as lemmas, never assume.**

13. **C2 locked to the half-space (2026-07-11 late, all three parties).** The master's C2
    stands as printed: the representation, the local-normal summability, and the
    zero-freeness all on the slice right half-space Ω₀; the "everywhere" content is C1's
    meromorphic continuation of the *function*, never the product's convergence. Kernel
    verification: `ASection`'s five C2 fields all guarded by `Ω₀ < z.re` (ASection.lean);
    the pinned Mathlib's Euler theorems (`riemannZeta_eulerProduct{_hasProd,_tprod,
    ,_exp_log}`, NumberTheory/EulerProduct/DirichletLSeries.lean) all carry `1 < s.re`;
    `zetaSection : ASection` (ZetaSection.lean:429, `Ω₀ := 1`) is the worked example of the
    division — C1 fields from the continuation package (ZetaPole.lean), C2 fields from the
    exp-log form on Re > 1. Codex's consequence, banked as a per-stage check: past Ω₀ the
    identity theorem transports *equalities, rigidity, and canonical continuation data* of
    the represented function — never convergence; check at each base-construction stage,
    particularly where C2 and C3 describe the same stem.

14. **One section functor, A (Codex's withdrawal of the separate F_A notation,
    author-ratified 2026-07-11).** There is one section functor — the author's letter, A;
    the analytic `ASection` data and the categorical section functor are facets of the
    same A, never two independently chosen constructions. The **naming table** becomes a
    sweep deliverable, four columns per Codex: *mathematical object · current Lean
    declaration · status · proposed final name*. `sectionFunctor` (PhiConversion.lean),
    `functorA` (AFunctor.lean, protected object), and the old Φ prose are **candidates to
    audit, not automatically ingredients to combine**. The point-11 two-actions distinction
    (non-invertible section application vs invertible base-arrow transport values) is NOT
    dissolved by the notation change — it remains a 0.3 agenda item, now internal to A's
    design.

15. **The construction strategy (the author, 2026-07-11).** Base first. At each stage, a
    dependency-tree audit of the theorems naturally belonging to that categorical object
    (base; section functor; sphere world). A is constructed from its analytic cargo, its
    required target/action *emerging* from riding the sphere world's automorphisms
    correctly — the open design questions are answered a posteriori by the most natural
    functor, never imposed. The round trip and the Grand Canyon/rising-sea geometry stay
    visible throughout — the two categorical engines (`pi0_grothendieck`; Riehl Rem 8.3.5
    zig-zag π₀) carry the readout. The avocado — the one conserved, connected, real
    singleton — is obtained only at the end.

16. **Operating discipline and roles (ratified by all three, 2026-07-11 late).** The
    author directs when each phase begins and ends; high-level categorical thinking and
    proof concepts are discussed on both threads; plans are formalized on both threads.
    **Fable** (Desktop tree, canonical): inventories candidate results triple-verified by
    the kernel, organizes and verifies the dependency chain, keeps GREEN_LEDGER.md.
    **Codex** (its tree): builds the groupoid objects and functors, runs `lake build`,
    makes them green; independently rechecks exact types and dependencies against the
    pinned kernel. Every stage begins with an object-specific dependency audit; every
    stage ends with a full green build, axiom/sorry audit, ledger update, tree comparison,
    and an intentional commit. No old substitute is patched merely to close a goal.
    **GREEN has explicit tiers** (GREEN_LEDGER.md, regenerated by
    `lake env lean _ledger_audit.lean`): CERTIFIED (three foundational axioms only) /
    AXIOM-GATED (project axioms, named) / SORRY-GATED (type-correct and reusable locally,
    NOT theorem-certified). Each row: declaration and type, location, direct dependencies,
    build status, `#print axioms` result, transitive sorry/axiom exposure, mathematical
    register and intended object, verification date.

17. **The base groupoid ruling (the author, 2026-07-11 late; Q1–Q3 all closed).** The base
    carries the intrinsic automorphism structure of the circle. Carrier: `OnePoint ℝ`,
    unchanged. Automorphisms: the **FULL automorphism group of the circle** — PGL(2,ℝ) in
    the real chart, BOTH components; nothing in groupoid theory forces a smaller group,
    and the −1 registers are not a gate on membership (the author: "I just need
    automorphisms of OnePoint ℝ"). The Poincaré disk extends uniquely in the interior and
    supplies the dictionary between the groupoids, the geometry, and the analytic content
    of the section: through it, rotation by e^{Iθ} is a genuine automorphism of the same
    S¹ (U(1) ⊂ PSU(1,1), the identity-component disk read), expressed on the raw carrier
    by conjugation. The automorphisms are **intrinsic base arrows** — never an artificial
    insertion of connectivity; what C1–C4 and W1–W4 constrain is how the section's
    analytic value transport rides the channels. μ(t) = exp(lift t − lift 0) lives a
    priori in the analytic value-transport register — its categorical role is the
    **naturality problem** (interactions with the two base channels, the two sphere-world
    automorphism families, C1–C4, W1–W4, composition and inversion), derived as typed
    lemmas, never an a-priori codomain restriction. Master consistency: `def:base`'s
    connected great circle is the restored register — Rule 1 guards the zeros' addresses
    in 𝒯_A, not the base circle's intrinsic automorphisms (Fable's Q3 caution was aimed at
    the wrong object; withdrawn). Kernel support verified in the pin: `instGLAction :
    MulAction (GL (Fin 2) K) (OnePoint K)` (Topology/Compactification/OnePoint/
    ProjectiveLine.lean:126 — the full GL action, no determinant restriction),
    `equivProjectivization` (:84), `ActionCategory` (CategoryTheory/Action.lean:48),
    `Circle` + `homeomorphCircle'`; **no ready-made PGL in the pin** (projectivization per
    the spec's implementation note). **Spec of record: PLAN_base_stage1_2026-07-11.md
    (D1–D5, the author's eight steps).**

18. **The level correction and the frozen base (the author + Codex, 2026-07-11 close).**
    The author caught the jump: an "A-enriched base" is the total object smuggled into
    the base — **the base does not depend on A** (Fable's v1 D4 committed the same jump;
    corrected). Architecture of record: **𝓑 = PGL(2,ℝ) ⋉ OnePoint ℝ**, intrinsic only —
    the great-circle objects, the full projective automorphisms, U(1) distinguished
    through the dictionary, N an ordinary distinguished object (movable by general
    channels — `OnePoint.smul_infty_eq_ite`, no label). **A : 𝓑 ⥤ Grpd** is the indexed
    section functor — fibres built inside/from the ONE sphere-world groupoid, carrying
    the normalized analytic/sphere-world states; **𝒯_A = ∫_𝓑 A** is where the pairs live
    and where value transports RIDE the automorphic channels (combined base-channel +
    fibre morphisms); readout π₀(𝒯_A) ≅ colim_𝓑 π₀∘A; the normalized zero addresses enter
    as objects of 𝒯_A, their one class produced by C1–C4/W1–W4. **Binding typing
    distinction**: G₂ (acts on 𝕆*, fixes the real circle pointwise) is never identified
    with PGL(2,ℝ) (moves base points, including N); their interaction is functorial
    design. **Phase-1 freeze**: BasePoint := OnePoint ℝ; BaseAut := PGL(2,ℝ);
    𝓑 := ActionCategory BaseAut BasePoint; the descended faithful action; the
    Cayley/Poincaré boundary dictionary; baseRotation : Circle →* BaseAut with the
    boundary-rotation proof; full-group action rows at finite points and at N; the
    component calculation (master `def:base`: π₀(𝓑) a single point — PROVED, never
    assumed). **Then STOP**: dependency-tree inspection before typing A : 𝓑 ⥤ Grpd.
    Kernel verification of the new pins (Fable, this session): `Matrix.ProjGenLinGroup` +
    `PGL(n, R)` notation (LinearAlgebra/Matrix/GeneralLinearGroup/Projective.lean:29/:34
    — supersedes Fable's earlier "no PGL in the pin," which searched the wrong name);
    `mulActionOfGL` (:85; the pin's own worked example
    UpperHalfPlane/MoebiusAction.lean:275); `smul_infty_eq_ite` (ProjectiveLine.lean:139);
    the dictionary homeomorphism NOT in the pin (ProjectiveLine.lean:20 TODO verbatim:
    "Add the extension of this equivalence to a homeomorphism in the case `K = ℝ`") —
    in-repo construction. **Spec of record: PLAN_base_stage1_2026-07-11.md v2**; v1's
    D4/B3a/B3b enrichment relocated to the functor/total-object stages.

19. **Build authorization narrowed (the author, 2026-07-11 close — supersedes the F1–F9
    breadth of spec v2).** Phase 1 builds ONLY the base groupoid: **𝓑 = PGL(2,ℝ) ⋉
    OnePoint ℝ** — the carrier; the descended PGL action (scalars-act-trivially +
    `mulActionOfGL` — load-bearing: 𝓑 cannot be formed without it); the `ActionCategory`
    package; the kernel confirmation that it IS a groupoid (pin instance
    CategoryTheory/Action.lean:137); and its placement — the great circle inside 𝕆*
    (`OnePoint.map` register, the same construction register as `H1 := ActionCategory G2
    (OnePoint Octonion)`, G2.lean:231). **Saved (intentional commit) and STOPPED.**
    DEFERRED until the author's conceptualization of the A-section functor (𝓑 → the
    sphere world) is formalized: the dictionary (F5), the Cayley formula (F6), the
    rotation embedding (F7), the action rows (F8), the component/π₀ facts (F9 — noting
    the pin's `IsConnected (ActionCategory M X)` from pretransitivity, Action.lean:128,
    is one instance away when repointed), faithfulness of the descended action, and the
    repointing of the entire C1–C4/W1–W4/GPV ledger. **Order of record: base groupoid →
    A-functor conceptualization → repoint theorems → total object.** Look-ahead rule:
    while designing the functor's object-to-object and morphism-to-morphism analytic
    content, look ahead to the total object ONLY — no further.

20. **The proof-organization ruling and the sync protocol (2026-07-12, all three
    parties; full text INVENTORY_REPORT_functor_2026-07-12.md §8).** (a) THE REGISTER:
    the failure mode is organizing the analytic facts as a PRE-COLIMIT proof of pairwise
    zero identifications — the colimit PERFORMS the identifications (Riehl Rem 8.3.5;
    π₀(el X) ≅ colim X, checked against the inbox Riehl PDF). Corrected burden: A a
    genuine functor; fibres populated by normalized A-states (C4); fibre structure from
    the retained SphereWorld (cargo design favored); **the real coordinate as a natural
    datum** `r_b : Obj (A b) → ℝ` preserved by fibre morphisms and base transports —
    then it descends through the colimit automatically; C1–C4/W1–W4 discharge
    preservation and population, never pairwise zigzags. SAFEGUARD: the substitute
    collapse (connected base × constant connected fibre) is avoided only by the honesty
    of the population, the induced A.map, and the proved preservation. The zigzag engine
    stays the generic Lean mechanism; the correction is proof ORGANIZATION. (b) Seven
    Codex corrections adjudicated (report §8): genuine — stale ledger counts (now
    35·0·6), the two opposite-sign approaches to N (+∞ pole cone vs −∞ ladder end,
    glosses fixed), KeystoneAssembly unreachable from root (use `winding_lift_unique`
    directly), the `Fstar` pole repair (pole ↦ ∞ not yet encoded — named obligation);
    aligned/precision — the hypercomplex-reduction bridge is source guidance not a row
    (full hypercomplex setting likely unnecessary, the author), G₂ converse
    design-dependent, the A.map determination (four options, 0.3's sharpest question).
    (c) THE SYNC PROTOCOL: no tier claim outside GREEN_LEDGER.md — reports cite ledger
    rows only; after any interruption the first act is rerunning `_ledger_audit.lean`
    and diffing against the ledger; every banked edit syncs to both trees in the same
    turn. Root cause of the 2026-07-12 talking-past: an interrupted-turn's disk edits
    (report + audit fix) were visible to no thread's transcript.

21. **The substitution failure mode named cross-system; the retraction; the procedural
    guardrails (the author + Codex + Fable, 2026-07-13).** The recurring failure — across
    BOTH assistants, which proves it was never a defect in the author's exposition — has
    one shape: recognize the argument could imply RH → import the prior that such a route
    is unlikely → reinterpret unfamiliar structure as probable error → **replace the
    author's object with a familiar template** (const functors, thin bases, generic
    Set-valued diagrams, Disc(ℝ), el(V)-as-architecture, manually inserted arrows) → find
    a problem in the substitute → report it as the author's problem. This confuses
    epistemology with ontology: the improbability of a discovery PROCESS has no bearing
    on the discovered statement. Probability, prestige, and anticipated consequences get
    no vote. **RETRACTED from the project argument (2026-07-13)**: Disc(P_A) / Disc(ℝ)
    functors, el(V)/el(P_A) as project objects, any comparison functor or "bridge", and
    the V : 𝓑 ⥤ Type "value diagram" as architecture (Fable's pinned chain of 2026-07-13
    included — the same substitution). **THE FIXED ARCHITECTURE (the author's,
    unchanged)**: 𝓑 = PGL(2,ℝ) ⋉ OnePoint ℝ → the actual section functor A : 𝓑 ⥤ Grpd
    (actual SphereWorld fibres; actual C1–C4/W1–W4 transports) → 𝒯_A = ∫_𝓑 A →
    π₀(𝒯_A) ≅ colim(π₀∘A) (the certified engine; π₀∘A is the engine's own right-hand
    side, never a replacement of A) → the zero states' one real-value component class →
    ∃c. **THE GUARDRAILS (procedural, inspectable — ratified)**: (1) the author's named
    objects are immutable until the author changes them; (2) every new declaration needs
    a direct counterpart in the ratified outline (the foreign-object test at type level);
    (3) any proposed replacement must be labeled a replacement and requires
    authorization; (4) **no obstacle discovered in a surrogate transfers to the original
    object**; (5) consequence-awareness cannot alter definitions or proof obligations;
    (6) only exact source conflicts, Lean type errors, unsolved goals, and kernel results
    count as mathematical feedback; (7) the complete typed skeleton is author-ratified
    before proof implementation. **SCOPING GUARD (the author's own D1)**: the remaining
    sourcing question is stated for the ZERO STATES' common class — which hypotheses on
    the genuine A give the zero states one image class in colim(π₀∘A) — never the
    Subsingleton form D1 declined (the whole-colimit singleton stays point 10's optional
    H2, on the author's ruling only). The author's forthcoming redraft of his proof plan
    supersedes every prior chain on arrival and is transcribed as-is.

22. **The fidelity gap and the three-certificate protocol (the author + Codex, 2026-07-13;
    Fable's audit appended).** THE PRINCIPLE (the rollerblade lemma): Lean verifies the
    encoded statement; it cannot verify that the encoding IS the statement the author
    asked for. A green substitute is not partial progress — it is a failed fidelity
    check. The failure happens BEFORE the kernel, at specification translation; both
    cancelled inferences (author's P ⇏ surrogate P′; kernel result about P′ ⇏ verdict
    about P) are invalid. THE PROTOCOL — a result counts only when THREE certificates
    agree: **fidelity** (the author ratified the exact objects, morphisms, hypotheses,
    conclusion — line by line, before implementation), **dependency** (the declaration
    consumes only the intended construction and sourced results — made STRUCTURAL by
    parameterization: the theorem's own type lists everything it uses), **kernel**
    (green + the agreed axiom audit). Procedure: the complete typed BILL OF MATERIALS is
    displayed and author-ratified before coding; if a part cannot be typed, STOP at that
    exact part (an R6 question) — never attach rollerblades. **FABLE'S AUDIT OF THE
    2026-07-13 EXCHANGE (the author's request: same failure mode here?)** — the exchange
    is sound with ONE residue: the phrase "the structural singleton conclusion" (and the
    prior message's "makes colim(π₀∘A) a singleton") admits two readings, and only one is
    the theorem of record. D1 (resolved, author-ratified) is the ∃κ form — the ZERO
    STATES' image is one class — and explicitly declines `Subsingleton (π₀ 𝒯_A)`. An
    over-strong GOAL is a surrogate too: if the whole-object singleton needed extra
    hypotheses, its failure could be misreported as the argument's (guardrail #4 in goal
    form). FIX (costs nothing): the bill of materials types the conclusion as the ∃κ
    statement over the zero-address family; the word "singleton" refers only to the zero
    states' common class. Point 21's scoping guard carries into every typed line.

23. **The cross-audit protocol (the author's ruling, 2026-07-13): Codex and Fable check
    each other for the substitution failure mode.** Rationale: the failure is not
    intentional — it is the models' regularization prior (pulling unfamiliar structure
    toward familiar templates), operating below intention; it is nearly invisible in
    one's own output and far more visible in the other's (proved twice on 2026-07-13:
    Fable's V-chain caught by the author+Codex; Codex's singleton-scope drift caught by
    Fable — neither system caught its own). PROTOCOL: (a) every substantive proposal
    that crosses threads (design, outline step, typed declaration, "correction") carries
    the header "AUDIT REQUEST — check against ALIGNMENT points 20–23"; the receiving
    assistant leads its reply with the audit BEFORE any other commentary. (b) The audit
    is STRUCTURED, one screen: (i) the objects table — every named object in the
    proposal → its counterpart in the author's ratified outline → OK / FOREIGN;
    (ii) the scope check — conclusion in the D1 ∃κ form, quantifiers over structure
    never over the zero family; (iii) the species check — each obligation dischargeable
    by certified-species rows; (iv) verdict: PASS or findings, findings only in the four
    legitimate forms (source conflict, type mismatch, unsolved goal/named gap, kernel
    result). (c) MANDATORY at ratification points — every F0 bill-of-materials stub is
    cross-audited before the author's line-by-line ratification; optional on chat-level
    ideas. (d) HONEST LIMIT, recorded: both systems share training-distribution biases,
    so cross-audit is a filter, not a guarantee — correlated errors are caught by the
    remaining two gates: the typed skeleton (substitution becomes structurally visible)
    and the author's fidelity certificate, which stays the final gate. Progress
    continues through the protocol, not despite it: audits are one screen, not new
    phases.

24. **The theorem of record superseded by the author; the converged Lean-ready outline
    (2026-07-14).** The author's rulings on the two cross-audited outline attempts:
    (a) NO NEW OBJECTS — only the functor A and 𝒯_A; J_A struck; 𝒯_A itself IS the
    ℂ-residue value-transport category (never an ambient container later restricted).
    (b) THE STATEMENT OF RECORD *(per Fable's reading of the author's 2026-07-14 ruling
    — the author confirms or strikes on sight)*: the old integrated form ∃κ ∃c:ℝ ∀n,I
    (points 1/D1/D2) is RETRACTED — "that's not the right statement." New:
    `ConcentricityStatement (s) : Prop := ∃ c : ConnectedComponents s.Total, ∀ d, d = c`
    — the singleton about the right-sized object; the old D1 caution dissolves because
    the object is 𝒯_A itself; the point-20 safeguard now lives in the honesty of A's
    construction (junk fibres ⟹ IsConnected FALSE — fails safe). (c) The indexed
    interface (label rfl on zeroState n I) struck — inputs are structural; coordinates
    live only in the PROJECTION layer, which still derives the scalar corollary
    (∃c:ℝ ∀n, re = c) from population + the readout at c, feeding cor:rh unchanged
    (the payoff seam). (d) The chain of record: ASection → A : GreatCircle.Base ⥤ Grpd
    (one functor; CD(stem) the author's recorded option) → 𝒯_A := Grothendieck(A ⋙
    forget) → Nonempty (C4) + zigzags-from-transports (zigzag_isConnected :436, proved
    never assumed; not topological/base/fibres) → IsConnected 𝒯_A
    (`total_isConnected (s)`, no extra hypothesis) → constant_of_preserves_morphisms'
    (:164; F := components-mk, h := Quotient.sound ∘ Zigzag.of_hom :341) → the
    singleton; simultaneously the CERTIFIED readout π₀(𝒯_A) ≅ colim(π₀∘A) with Riehl
    p.102 as its meaning. ALL Lean names in both attempts verified against the pin/repo
    2026-07-14 (one mechanical caveat: the components constructor's exact name at
    typing time). File of record: PROOF_OUTLINE_LEAN_READY_2026-07-13.md (CONVERGED).

## The Phase 0.1 worklist (the sweep, next act — read-and-verify plus four DETERMINE items)

- Resolve the five `TO-VERIFY` inventory rows (A5, C1-location, D3-ledger, F3, F4).
- P-1: the σ = c provenance in the 2026-07-07 proof plan.
- Derive/verify W-2's lemma pair (`liftPhase` periodicity; odd-rung ⟹ −1) — as lemmas,
  never as the functor. *(The former "independence trio" item is REMOVED per Codex's
  point-7 correction.)*
- **Determine** which encounter choices are literally equal, equivalent, or merely
  connected by transport.
- **Determine** whether direction morphisms should store G₂ elements, paths, or quotient
  classes.
- **Determine** whether `liftPhase` yields an object, a path, a holonomy class, or a
  naturality witness.
- **Determine** the actual role of Möbius automorphisms relative to the non-invertible
  section action.
- Locate or prove the generic H2 lemma.
- W-4: audit `realizes_of_value_eq` against path/lift cargo.
- Complete the inventory against the import graph; confirm or grow the gap list.
- **NEW (2026-07-11 ratification)**: GREEN_LEDGER.md created; the alignment anchors, the
  zeta instance, the engines, the readout chain, and the Corollaries chain kernel-passed
  (22 CERTIFIED / 0 AXIOM-GATED / 7 SORRY-GATED; sole gate = the two ConcentricityReadout
  sorries; `riemannZeta_nontrivialZeros_infinite` verified CERTIFIED — the R9 leaf is
  proved in-repo, no longer sorried). Remaining: the pending-rows list at the ledger's end.
- **NEW**: the naming table (point 14's four columns) — audit `sectionFunctor` /
  `functorA` / Φ prose against the one functor A; rename proposal for the author's
  ratification before Phase 1.
- **NEW**: semiregular/regular — stem-level rendering reported (`meromorphic :
  MeromorphicOn F univ`, ASection.lean); the regular-vs-semiregular ruling stays the
  author's (open question 2026-07-11).
- **NEW**: the identity-theorem seam check (point 13) added to every base-construction
  stage checklist.
- **FLAGGED for the paper phase (the author + Codex, 2026-07-12)**: the **Thomason
  epilogue** — a final section/formalization epilogue stating Thomason Thm 1.2, noting
  the proof of record uses only its π₀ shadow, giving the alternative space-level proof
  outline, and inventorying the Mathlib infrastructure: PRESENT in the pin (verified —
  `nerve`/`nerveFunctor : Cat ⥤ SSet`, AlgebraicTopology/SimplicialSet/Nerve.lean:35/:72;
  full-faithfulness, realization adjunction, simplicial homotopies, simplicial π₀ with
  the coequalizer characterization, strict Grothendieck constructions — Codex's scan
  2026-07-12, correcting Fable's coarser string-grep); MISSING (the scoped middle layer):
  simplicial replacement/bar construction, the homotopy-colimit functor, the comparison
  hocolim N(F(−)) → N(∫F), Thomason's weak equivalence. A focused Mathlib-contribution
  proposal in the Zulip register — **non-load-bearing for Concentricity**; the certified
  π₀ engine remains the route of record. Winding data sits at the π₁ level of this
  picture (Codex's aerial-photograph remark) — expository placement only.

## Check assignments

- **The author**: does every numbered point transcribe his argument? Any register error
  here is cheaper now than in Lean.
- **Codex** (in `~/Documents/Codex/.../concentricity`): types and audit — especially 3, 6,
  7 (the arrow/fibre design inputs for 0.3) and the worklist's W-4.
- **Fable** (Desktop tree): kernel and greps — the sweep itself, every GREEN citation
  above re-printed, both trees kept identical.
