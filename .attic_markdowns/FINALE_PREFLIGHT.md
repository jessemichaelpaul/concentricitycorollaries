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

> ## SUPERSEDED PRESCRIPTION - corrected 2026-07-20
>
> This file diagnosed the live state **correctly** (Part I: the functor is "the bare action, in
> dry dock ... no A, no cargo"). Its **remedy is superseded**.
>
> Line 55 prescribes: *"Retain them as cited theorem-fields on the arrows."* That is the exact
> pattern that produced `Hypothesis A (_D)` - a generic carrier with the analytic content
> attached as detached fields, where `_D` occurs in none of the field types. The author
> superseded it on 2026-07-19/20, together with Ruling B of A_SECTION_FUNCTOR_BUILD_PLAN.
>
> **Replacement invariant (structural):** the body of `sectionFunctor A`.map must contain the
> distinguished element and its C2 Euler / C3 Weierstrass pole action **directly**;
> orbit-stabilizer proves that same action global and functorial. Removing the
> distinguished/Euler/Weierstrass term must make **the functor itself fail to typecheck** - not
> merely remove a field from a wrapper.
>
> Euler and Weierstrass ARE the pole action. There is no generic action to insert analytic
> content into. Do not fill, rename, or re-create the wrapper.

# THE CONCENTRICITY ARGUMENT — the one document

**Author of the mathematics:** Jesse Michael Paul. Frozen draft, 2026-07-18.

> *The rising sea — the centre `c` emerges from the completed colimit as a whole, not assembled
> one molecule at a time.* (Epigraph only; swap in your opening quote. Everything below is stated
> as precise objects and morphisms.)

The complete argument, wire-ready: the two theorems, how the general functor becomes the
A-section functor (Part I), the read-out that ripens `∃c` from the colimit (Part II), every cited
theorem (Part III), and why Lean type-checks it (Part IV). Single source — build from this.

## The two theorems

```lean
/-- All populated ℂ-residue zero states share one image in the colimit:
    `toColimitObj (sectionFunctor A) (zeroTotal A n I)` is a single class κ for all n, I. -/
theorem concentricityReadout (A : ASection) :
    ∃ κ, ∀ n I, toColimitObj (sectionFunctor A) (zeroTotal A n I) = κ

/-- master `thm:concentricity`: the ℂ-residue zero 6-spheres share one real centre `c`,
    read off the class κ of `concentricityReadout` by the value map `val` (`c = val κ`). -/
theorem concentricity (A : ASection) :
    ∃ c : ℝ, ∀ n, (A.sphereZero n).re = c
```

`concentricity` is proved by **calling** `concentricityReadout` and applying the value map `val`
(Part II). `∃c` is a **read-out**, never a hand-built slot. The RH corollaries rest on
`concentricity`.

## Part I — the general functor becomes the A-section functor (the only real work)

**Start — the general functor.** The disk-automorphism (Blaschke × rotation) action, general
`F ∈ 𝓡`, C1–C4 absent — already built. In the live source it is the **bare** action, in dry dock:

```lean
toFunctor.obj := fun _ => Grpd.of <inherited carrier>                         -- NOT the author's
toFunctor.map := fun f => distinguishedStateAction (cayleyProjective f.val)   -- no A, no cargo
projectiveSectionFunctor A := (projectiveConnection A).toFunctor              -- DRY DOCK
```

`Total A` is currently built from this bare functor — the colimit chews on the general object.
Fixing that is the work, and it is **both lines**: the shortcut's `obj` carrier
(`NormalizedSlicePoint`, entered with the A-free `map`) is as much the substitute as the `map`.
Replacing `map` alone leaves the substitution one layer down.

**The A-section functor — its ARROWS are real-value transports.** Impose C1–C4; they grant the
cargo, and the cargo rides the **arrows**. Concretely, Part I must deliver:

> **⛔ SUPERSEDED — author's ruling, 2026-07-21.** Items 1–2 below are written against
> `NormalizedSlicePoint` / `NormalizedSliceHom` as the fibre. They are **not** the author's objects:
> *"There is no one fibre of my functor"*; *"NormalizedSlicePoint and NormalizedSliceHom have
> nothing to do with my orbit–stabilizer construction."* The two groupoids are `GreatCircle.Base`
> and `SphereWorld`. `obj` and `map` are **both** outputs of the orbit–stabilizer construction on
> the distinguished element — *"simultaneously well defined on the whole continuum of groupoids"* —
> so the cargo is a **property of those transports**, never a theorem-field retained on an arrow of
> an inherited carrier. Read items 1–3 as the shape of the obligation only, not as its carrier.

1. **A real label on the fibre:** the state's intrinsic real value; for a zero state,
   `label = (A.sphereZero n).re` (extending `NormalizedBase.label`, which already sets
   `label := (A.sphereZero n).re` on the zeros). The fibre type is whatever the construction
   produces, not a carrier named here.
2. **Every arrow preserves the label** — the functor's own arrows are value-transports, carrying
   the cited cargo:
   **C1–C4 / W1–W4 / all GPV consequences (−1 winding `pole_winding`, uniqueness `gpv_transport`,
   `Re`-preservation `gpv_endpoint_re`, `collapse_at_N` — everything the read-out consumes).**
   Retain them as cited theorem-fields on the arrows; retain exactly what the read-out consumes,
   no more.
3. `sectionFunctor A` := this cargo-bearing functor (replaces the dry-dock `:= toFunctor`);
   `Total A := ∫ sectionFunctor A`.

**Part I has one job that serves two consumers — and they are the same job:**
- **(a)** the colimit gives **one κ** for the zeros: `zeroToN` + `collapse_at_N` + the engine
  `toColimitObj_eq_of_zigzag`;
- **(b)** `val` is **well-defined**: every arrow preserves `label`, so the label descends.

**Honesty guard (structural):** delete the cargo → the arrows stop preserving `label` → `val`
fails to descend **and** κ fails to be one class → **both theorems break**. Load-bearing by
construction, not by a restated conjunct.

## Part II — the read-out: `val`, and `∃c` ripens

**The value map `val` — this is where `F : J → α` goes.** The label induces a cocone from `π₀∘A`
to the constant functor at ℝ (each fibre `→ ℝ` by its label; naturality = arrows preserve `Re`
= Part I). Descend it:

```lean
val (A : ASection) :
    colimit ((sectionFunctor A ⋙ Grpd.forgetToCat) ⋙ pi0Functor) → ℝ
  := colimit.desc … (labelCocone A)
-- computation rule:  val (toColimitObj (sectionFunctor A) X) = label X.fiber
```

This is the **canonical descent of the intrinsic label** — `F : J → α` placed at the read-out,
enabled by Part I. It is **not** a real-value map fabricated apart from the label and the colimit
(*that* `F` is the forbidden one). Same shape, opposite role: this one is the read-out, and
confirming this is where it goes is the whole point.

**`val` is formalized as the engine's mirror — buildable now, before Part I.** It uses exactly
the two primitives already proven-working in `pi0GrothendieckEquiv`: `colimit.desc`
(`Theorem.lean:113`) and `colimit.ι_desc_apply` (`:115`). So pin it as a **generic, A-free**
read-out lemma and build/verify it independently of Part I (as the engine is generic):

```lean
-- generic read-out: a fibre label preserved by all arrows descends out of the colimit
theorem colimitLabelReadout {B} [SmallCategory B] (F : B ⥤ Grpd)
    (label : ∀ X : Grothendieck (F ⋙ Grpd.forgetToCat), ℝ)
    (h : ∀ {X Y} (φ : X ⟶ Y), label X = label Y) :
    ∃ val : colimit ((F ⋙ Grpd.forgetToCat) ⋙ pi0Functor) → ℝ,
      ∀ X, val (toColimitObj F X) = label X
```

The proof is `colimit.desc` of the label-cocone + `colimit.ι_desc_apply` — the same shape as the
engine. **Part I then supplies the A-section `label` (= the fibre real value; on a zero,
`(A.sphereZero n).re`) and the preservation `h` (arrows carry `Re` — cargo), and applies it.**
So the read-out machinery is de-risked; the only new content is the label and its preservation,
which is Part I.

**`∃c` ripens by applying `val` to the readout equation:**

```
toColimitObj (zeroTotal A n I) = κ                        -- concentricityReadout
   ⟹  val (toColimitObj (zeroTotal A n I)) = val κ
   ⟹  (A.sphereZero n).re = c            with  c := val κ
```

because `val (toColimitObj (zeroTotal A n I)) = label (zeroTotal A n I).fiber = (A.sphereZero n).re`.
**The identification of `toColimitObj (zeroTotal A n I) = κ` with `(A.sphereZero n).re = c` is
`val` applied to the readout — canonical, through κ.** That is the ripening; `val` is the wire.

Never: a pairwise `(A.sphereZero n).re = (A.sphereZero m).re`; a real-value map fabricated apart
from `label`; an `∃c` proved without `val κ`.

## Part III — every cited theorem

| Cited | Where | Role |
|---|---|---|
| `pi0GrothendieckEquiv` | `Theorem.lean:108` | `π₀(𝒯_A) ≅ colim` — the engine (Riehl, proof of Lem 8.3.4) |
| `toColimitObj_eq_of_zigzag` / `_of_hom` | `Theorem.lean:92` / `:77` | each transport forces the identification → one κ |
| `colimit.desc` / `colimit.ι_desc_apply` | Mathlib | descends `label` to `val` (the read-out) |
| `CategoryTheory.Grothendieck` | Mathlib | `𝒯_A = ∫ A` |
| cargo on the arrows: `gpv_endpoint_re`, `collapse_at_N`, `zeroToN`, `c4_infinite`, `label` / `normalizedZeroLift_re` | `ProjectiveSection` / `NormalizedBase` | Part I: arrows preserve `Re`; norths coincide; the label tie |

## Part IV — why Lean type-checks

- **`concentricityReadout`:** `zeroToN` + `collapse_at_N` + `toColimitObj_eq_of_zigzag` → all
  zeros to one κ. Types.
- **`val`:** the label-cocone exists because every arrow preserves `label` (Part I); `colimit.desc`
  gives `val`, with `val (toColimitObj X) = label X.fiber`. Types.
- **`concentricity`:** `c := val κ`; for each `n`,
  `(A.sphereZero n).re = label (zeroTotal A n I).fiber = val (toColimitObj (zeroTotal A n I)) = val κ = c`
  (last step by `concentricityReadout`). The composite has **exactly** the goal type.
- Once Part I is done, **no supplier is missing** — every input is a green construction. Lake
  prints `[propext, Classical.choice, Quot.sound]`, no `sorry`.

**Discipline.** One `lake build` at a time. If a named supplier is genuinely absent: its exact
Lean type + STOP. The only real work is Part I (arrows carry the cargo); Part II is the read-out
`val`; the rest is the engine, already green.
