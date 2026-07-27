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

# The A functor — certified assembly table (2026-07-10)

Every object below is **triple-certified**: green `lake build`, and kernel axioms
exactly `[propext, Classical.choice, Quot.sound]` (no `sorryAx`, no project axioms).
Nothing here consumes `ASection.concentricity` (the one open sorry).

---

## 1. The two groupoids

### B = `A.Base` — the great circle (winding groupoid), `ConnectedBase.lean`

| | |
|---|---|
| **Objects** | `{ σ : OnePoint ℝ // A.NonSingular σ }` — the non-singular points of the great circle `S¹ = ℝ ∪ {N}`; `NonSingular σ := Fstar(circleEmbed σ) ≠ ∞ ∧ ≠ 0` (off the pole and the real zeros). |
| **Morphisms** | `σ ⟶ σ' := { k : ℤ // A.Realizes σ.val σ'.val k }` — a **winding `k`** realized by an A-value-transport: `∃ γ Γ, γ ≠ 0 ∧ γ0 = Fstar σ ∧ γ1 = Fstar σ' ∧ exp Γ = γ ∧ Γ1−Γ0 = 2πik`. **This is C1–C4 through W1–W4** (built from `A.Fstar`). |
| **Groupoid** | `id = ⟨0,…⟩` (`realizes_id`), `comp = ⟨k+k',…⟩` (`realizes_comp`, windings add), `inv = ⟨−k,…⟩` (`realizes_inv`). Laws = `Subtype.ext` of ℤ-identities. |
| **Cert** | `instGroupoidBase` → `[propext, Classical.choice, Quot.sound]` |
| **π₀** | one point — B is the one connected great circle (the colimit's engine). |

### S₂ = `SphereWorld` — the slice world, `SliceSphereWorld.lean`

| | |
|---|---|
| **Objects** | `{ v : Octonion // v ∈ unitImaginarySphere }` — the slice Riemann spheres `S²_v`, **one per unit imaginary `v ∈ S⁶`** (the continuum). |
| **Morphisms** | `SphereHom I J := ⟨rot : G2, rot_eq : rot • I.val = J.val, mob : Moebius⟩` — the **direction/rotation leg** `rot` (carries `S²_I` → `S²_J`) + the **Möbius self-map** `mob`. |
| **Groupoid** | `comp = ⟨ψ.rot*φ.rot, ψ.mob*φ.mob⟩`, `inv = ⟨φ.rot⁻¹, φ.mob⁻¹⟩` (G₂ and Möbius are groups). |
| **Cert** | `instGroupoidSphereWorld` → `[propext, Classical.choice, Quot.sound]` |
| **π₀** | one point — `sphereWorld_zigzag`: G₂ transitive on S⁶ (Baez), all spheres joined. The **one N** (∞ on the great circle) is shared by every sphere and G₂-fixed. |

---

## 2. The functor **A** = `functorA : A.Base ⥤ Grpd`

A genuine value transport on **all spheres simultaneously**, fixing the one N.

| leg | action |
|---|---|
| **objects → objects** | `A.obj σ := Grpd.of SphereWorld` — every base level carries the **whole** slice world (A's normalization `s ↦ φ_{dir s}(F(sliceCoord s))` realizing the S₂ continuum). |
| **morphisms → morphisms** | `A.map (k : σ ⟶ σ') := worldRot (poleGen ^ k.val)` — the **winding `k.val`** (= W1–W4 through `A.Base`) drives a rotation of **every** sphere at once: `worldRot g` sends `v ↦ g·v` on objects and `⟨rot,mob⟩ ↦ ⟨g·rot·g⁻¹, mob⟩` on morphisms. N (∞, G₂-fixed) is carried to itself. `poleGen` = the antipodal `v ↦ −v` (`direction_path_to_neg`, the pole's odd-π turn); the exponent is A's winding. |
| **functor laws** | `map_id` from `worldRot_one` (`poleGen^0 = 1`); `map_comp` from `worldRot_comp` (`poleGen^(k+l) = poleGen^l · poleGen^k`, powers commute). |
| **the bridge** | `dirLink (I J) : I ⟶ J := dirHomTo (poleRot I.prop J.prop) …` — ℂ-lift → rotation around the pole (`exists_smul_eq`, G₂-transitivity) → G₂ `SphereHom`. The SU(3) slack is fixed by the **uniqueness of the tame lift** (`gpvPopulated`/`GpvTransportWitness`, (a)+(d)+(e)). |
| **how C1–C4 / W1–W4 enter** | C1–C4 define A ⇒ generate `A.Base` (its arrows `Realizes` = the windings) and the welds; **W1–W4 ARE the morphisms** — the value-windings that connect the base levels to the C-residue values, warping the spheres around the pole. The winding `k.val` in `A.map` is exactly that. |
| **Cert** | `functorA` → `[propext, Classical.choice, Quot.sound]` |

---

## 3. The total object **T_A** = `TotalA`

| | |
|---|---|
| **Definition** | `TotalA := Grothendieck (A.functorA ⋙ Grpd.forgetToCat)` = `∫_{A.Base} A`. |
| **Objects** | pairs `(σ, x)` — a base level `σ : A.Base` and a sphere `x : SphereWorld`. |
| **Morphisms** | pairs `(k, θ)` — a base winding `k : σ ⟶ σ'` and a fibre `SphereHom` `θ : A.map(k)(x) ⟶ x'`. |
| **Cert** | `TotalA` + its `Category` instance → `[propext, Classical.choice, Quot.sound]` |

---

## 4. The readout — hypothesis, conclusion, proof outline

**`pi0_grothendieck` (Riehl CHT §8.3.5, `Theorem.lean`)**

- **Hypothesis**: a functor `F : B ⥤ Grpd`, `B` small. (We supply `F = functorA`, `B = A.Base`.)
- **Conclusion**: `π₀(∫_B F) ≅ colim_B (π₀ ∘ F)` — components of the total object = colimit of the fibrewise components. Green, `[propext, Classical.choice, Quot.sound]`.

**Proof outline for concentricity** (to run after your check):

1. `π₀(SphereWorld) = one point` (`sphereWorld_zigzag`) ⇒ `π₀ ∘ A` is the constant one-point diagram over B.
2. B is the one connected great circle ⇒ `colim_B (const one point) = one point`.
3. So `π₀(T_A) ≅ one point` — **every object of T_A is in one component**, in particular every C-residue zero.
4. The level (real part) is conserved along the base (no cross-level morphisms except through N) ⇒ the one component pins **one real level `c`**.
5. Read off: `∃ c, ∀ n, (A.sphereZero n).re = c` — closing `ASection.concentricity`.

**Conclusion-shape check (the thing to verify):** the goal is
`∃ c : ℝ, ∀ n : ℕ, (A.sphereZero n).re = c`. The readout delivers "one component of `T_A`";
steps 4–5 are the bridge from "one component" to "one real centre `c`". **The open question to
confirm before wiring: the exact map from the zeros `A.sphereZero n` into `T_A` objects, and that
their shared component forces `(sphereZero n).re = c`** (the level = real part). That is the last
inference, and it is what we check against the machinery.
