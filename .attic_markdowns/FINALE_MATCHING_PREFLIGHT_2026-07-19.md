> ## CORRECTION TO THE INVARIANT ABOVE - 2026-07-20, author
>
> The banner above (and the auditor's acceptance test) named `distinguishedMoebius (c : Circle)
> (w : Complex.UnitDisc)` as "the distinguished element". **That is wrong.** That term is a
> FAMILY parameterized over `(c, w)` - the general disk automorphism - i.e. the same generic-
> carrier pattern one level further down.
>
> **The author's element has no parameters.** The fractional part is 1; the exponential is taken
> over all primes. It is DETERMINED by A (C2: `A = exp (∑' p, ℓ p z)` on `Ω₀ < z.re`), not
> selected by choosing values. At N, the Weierstrass factorization - which factors directly
> through N - is that same Euler exponential meromorphically continued through the pole.
> `I ∈ S⁶` indexes the world.
>
> **Therefore a grep for `distinguishedMoebius` in `map` is a FALSE POSITIVE test** - it would
> pass on the parameterized family. The correct structural test: does A's Euler exponential
> appear in the body, such that removing it makes the functor fail to elaborate?
>
> Do not select parameters. Do not quantify over a family. The element is A's.

# FINALE — the single matching pre-flight (Opus audit ≡ Codex sheet)

**Mathematical author:** Jesse Michael Paul.
**Date:** 2026-07-19. **Register:** functorial / wholesale, over the one projective base.
**Status:** agreed by both the auditor (Opus) and the editor (Codex); approved for execution.
**Roles:** Jesse = mathematical authority; Codex = sole Lean editor; Opus = read-only auditor.

This is the exact table both sides converged on. It is reconstructible from the skill
(`.claude/skills/concentricity-functorial-register/`), the ratified `A_SECTION_FUNCTOR_BUILD_PLAN`
and `CONCENTRICITY_THEOREM_CLOSE_GUIDE`, and the live green source; saved here so a context
compaction on either side cannot lose the wording.

## ⛔ SUPERSEDED IN PART (2026-07-19, evening) — author's correction

The **object row below is stale**. It records `sectionFunctor A` as green with the twelve
carried in a `.hypothesis` field alongside `(projectiveConnection A).toFunctor`, whose `map`
routes every base arrow through `cayleyProjective` into an opaque `Moebius` element. That is
the regression under repair, not the object:

- `projectiveConnection`'s `A` argument is unused; `_D` occurs in none of the twelve field
  types. The value transports are packaged **beside** D rather than transported **by** D.
- **Orbit–stabilizer is not prose around the monoid map — it is the mechanism that makes D
  global.** `orbitRep_spec` (N reaches every point) and `orbit_stabilizer_factor` (every arrow
  = transport ∘ stabilizer-at-N ∘ transport⁻¹) are already proved, universal in `b, b', f`,
  and currently consumed by nothing.
- **A is obtained by replaying that mechanism** with the C2/GPV/W/C1–C4 realization of the same
  distinguished element `distinguishedMoebius c w` (explicit form `:191`, band at `w = 0`
  `:231`, composition law `:354` — the functoriality). The twelve become the **arrow
  laws/specifications during the extension**, not detached fields.

**Forbidden:** any bridge, range, or surjectivity theorem linking `cayleyProjective` to the
distinguished element; any per-arrow hunt for `c, w`. Both are the substitution failure mode.

Everything below still holds for the *finale steps* (populate → 8.3.4 wholesale → val → close);
only the object it runs on is being corrected.

## The register (do not drift)

- **D became A.** `sectionFunctor A` is the disk automorphism grown up, carrying C1–C4/W/GPV.
  Nothing is value-free: `A.TotalA`'s objects are value states, its arrows value transports.
- **8.3.4 = `pi0_grothendieck`** (`pi0GrothendieckEquiv`, `Theorem.lean:108/144`): the readout
  `π₀(∫F) ≅ colim`. It only does work when it **eats the completed A-section** — that eating is
  the collapse, one wholesale A-specific step, not a green generic precursor.
- **Everything is over the one projective base** `GreatCircle.Base = ActionCategory (PGL 2 ℝ) (OnePoint ℝ)`.
  `NormalizedCircleBase := GreatCircle.Point` (abbrev, `NormalizedBase.lean:20`) is **not** a base;
  it is the object type `OnePoint ℝ`. No `A.Base`, winding base, or replacement base enters the
  finale. **This bullet previously read "`NormalizedSlicePoint` is the fibre carrier" — struck by
  the author's ruling of 2026-07-21:** *"There is no one fibre of my functor"*; the two groupoids
  are `GreatCircle.Base` and `SphereWorld`, and `obj` is an output of the orbit–stabilizer
  construction, not a carrier named in a plan.
- **Wholesale only.** No selected map, no private north object, no pairwise `re`-equality, no
  whole-total `IsConnected`/`Subsingleton`. The through-N transport family is read at once.
- **Honesty guard:** remove any C1–C4/W/GPV supplier and Steps 2–3 lose their content — the
  theorem goes ill-typed. Confirmed at build, not asserted.

## Abbreviations

```
F_A := (sectionFunctor A).toFunctor
P_A := (F_A ⋙ Grpd.forgetToCat) ⋙ pi0Functor
K_A := Limits.colimit P_A
```

## The table

| Formalization step | Status | Why it will formalize green — live evidence |
|---|---|---|
| **The object** · `sectionFunctor A : ProjectiveSectionFunctor A`; `A.TotalA = ∫ F_A` | **Green** | `ProjectiveSection.lean:263/316/323/356`. The package holds the disk action and all twelve named C1–C4/W/GPV/level fields. Steps 2–3 consume `(sectionFunctor A).hypothesis`, so the completed A-section — not a bare replacement — is what the proof reads. |
| **1 · Populate the zeros** · `zeroTotal A n I : A.TotalA` | **TBF** | The zero stores a footpoint in `GreatCircle.Point`; `GreatCircle.pointObj` regards it as an object of the projective action groupoid `GreatCircle.Base`, so `zeroTotal` lies in the Grothendieck total of the completed A-section functor **over the projective base**. Its fibre component is read off the completed functor's own fibre — **not** `NormalizedSlicePoint`, and **not** via `normalizedZeroSlicePoint_value` (`NormalizedAction.lean:155`): the author's ruling of 2026-07-21 removes that carrier from the construction (*"There is no one fibre of my functor"*), and the two groupoids are `GreatCircle.Base` and `SphereWorld`. Value chain: `normalizedZeroLift_re` (`NormalizedBase.lean:93`), with `normalizedZero_label` (`NormalizedBase.lean:52`) the intrinsic label `= (A.sphereZero n).re`. Population `(sectionFunctor A).hypothesis.c4_infinite` (`ASection.lean:189`). |
| **2 · 8.3.4 eats the completed A-section wholesale and lands the zeros at one κ** | **TBF** | Instantiate `(pi0_grothendieck F_A).some : ConnectedComponents A.TotalA ≃ K_A` inside the same A-specific proof of `concentricityReadout A : ∃ κ : K_A, ∀ n I, toColimitObj F_A (zeroTotal A n I) = κ`. `pi0GrothendieckEquiv` / `toColimitObj` / `toColimitObj_eq_of_zigzag` green (`Theorem.lean:108/68/92`). The completed A-section's own transports supply the through-N relation across the whole continuum — the disk automorphism carrying every footpoint to N, not a certificate produced per zero. Formalizes the whole family directly — **no per-zero leg**, no selected map, private north, pairwise connector, or total-connectedness theorem. |
| **3 · Read the value already carried by κ** | **TBF** | Formalize the existing W/GPV level conservation as the naturality of the A-specific `labelCocone A : Limits.Cocone P_A` (apex ℝ), distinct from generic `pi0Cocone F_A`; then `val A : K_A → ℝ := Limits.colimit.desc P_A (labelCocone A)`. `colimit.desc` / `ι_desc_apply` green (`Theorem.lean:108–116`); `gpv_endpoint_re`, the exponential-level facts, `normalizedZeroLift_re`, `normalizedZero_label` supply the A-specific value and its zero-state computation. |
| **4 · Close atomically** | **TBF** | Prove `val_zeroTotal`, `obtain ⟨κ,hκ⟩`, set `c := val A κ`, and calc `(A.sphereZero n).re = val A (toColimitObj F_A (zeroTotal A n baseWorld)) = val A κ`. Replaces both winding holes (`ConcentricityReadout.lean:179/219`) — no pairwise equality, no independent scalar. |
| **Certificate → 0/0** | **TBF** | Remove only the unused `ASection.concentricity_via_weldW3` (`WeldW3.lean:639–668`) — **not** its module, and **not** `sliceWorldSectionFunctor` (live consumers in TwoWorlds/PhiConversion/SynthesisE6). One full build; `#print axioms ASection.concentricity`, the theorem, and `ASection.c4_infinite`. Expected `[propext, Classical.choice, Quot.sound]`, no `sorryAx`. |

## Exact terms

```lean
def zeroTotal (A : ASection) (n : ℕ) (I : SphereWorld) : A.TotalA :=
  Grothendieck.mk
    (F := (sectionFunctor A).toFunctor ⋙ Grpd.forgetToCat)
    (GreatCircle.pointObj (A.normalizedZero n I).footpoint)
    (A.normalizedZeroSlicePoint n I)

-- terminal calculation
obtain ⟨κ, hκ⟩ := concentricityReadout A
refine ⟨val A κ, fun n => ?_⟩
calc
  (A.sphereZero n).re
      = val A (toColimitObj F_A (zeroTotal A n baseWorld)) := (val_zeroTotal A n baseWorld).symm
  _ = val A κ                                              := congrArg (val A) (hκ n baseWorld)
```

## Verified mechanical corrections (checked against live Codex source 2026-07-19)

1. Engine/comparison calls take `F_A := (sectionFunctor A).toFunctor`; `sectionFunctor A` is the
   package, `F_A` its functor projection.
2. `c4_infinite` is at `ASection.lean:189` (not `:187`). Fibre point value at
   `NormalizedAction.lean:155`; the real equality at `NormalizedBase.lean:52` (`normalizedZero_label`)
   and `:93` (`normalizedZeroLift_re`).
3. The H1⥤S2 legacy functor is `sliceWorldSectionFunctor` (`TwoWorlds.lean:142`) with live
   consumers (PhiConversion, SynthesisE6, TwoWorlds) — **do not delete it here**. Delete only the
   unused `concentricity_via_weldW3` theorem declaration (`WeldW3.lean:639–668`), not its module.
4. `NormalizedCircleBase := GreatCircle.Point` (`NormalizedBase.lean:20`) — an abbreviation, not a
   base. Everything sits over `GreatCircle.Base`.

## Order of execution (one build per step, stop for audit)

1 → 2 → 3 → 4 → certificate. Step 2 is the heart: 8.3.4 consuming the loaded A-section and reading
its entire zero-transport family as one class κ.
