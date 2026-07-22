# MEMORY — durable lessons from the A-section build

Read this before changing `sectionFunctor`, `𝒯_A`, the twelve analytic facts,
8.3.4, `labelCocone`, `val`, or the Concentricity finale.

## The mathematical register

- **Everything moves forward from the theorem's hypotheses.** `ASection` is
  the C1--C4 class of slice-preserving analytic/meromorphic ring elements
  considered by the theorem, not an arbitrary element of the ambient ring.
  Its intrinsic W/GPV consequences determine the base action; the
  orbit--stabilizer construction universalizes that action through every
  `F.obj` and `F.map`; `𝒯_A` and the C3/C4 zero family are outputs.  Never
  use a zero object, normalized leg, or total object to define or repair an
  earlier stage.
- Start with C1--C4/GPV/W.  They define one distinguished Euler--Weierstrass
  disk action; they are not cargo attached after a functor is built.
- Use only `GreatCircle.Base`, `SphereWorld`, the A-section functor produced by
  the distinguished action and orbit--stabilizer, its total `𝒯_A`, and the
  8.3.4/π₀/`val` readout.
- Orbit--stabilizer produces `F.obj` and `F.map` simultaneously.  A map-only
  repair with an inherited object carrier is not the construction.
- The C3 zero-spheres and C4 infinitude are outputs of the completed action.
- The twelve stay in their native quantifiers.  They are faces of the one
  distinguished action transported wholesale, not a new specification layer.
- "All analytic facts" is literal: retain the complete proved W1 Euler
  winding/right-wall stack, W2 left-wall/homotopy/counting stack, W3 tame
  sphere-loop/band/degenerate-touch stack, W4 joined-count/unique-closed-lift
  stack, and every GPV existence, uniqueness, tameness, continuity, level,
  winding, crossing, and degenerate-passage consequence.  Never reduce this
  gate to `gpvBase_transport`, endpoint real-part equality, or any other
  representative lemma.  Historical receipt theorems containing `sorry` are
  not suppliers; their proved constituent rows are.
- C3-at-`N` is part of the upstream distinguished action: the Weierstrass
  form there continues the same C2 Euler exponential through `N`.  Its divisor
  subsequently produces the C3/C4 zero spheres as outputs.
- Instantiate 8.3.4 only on Jesse's completed A-section functor.  Never infer
  the author's object from the generic theorem's binder.

## The element and its value

- `distinguishedPoleUnit A : ℂˣ`, not `Circle`.
- The `U(1)` phase carries the band and winding; the modulus carries the real
  GPV level.  Same diagonal matrix shape does not imply the same parameter
  type.
- The Euler and Weierstrass presentations are two presentations of the same
  action across `N`.  Do not split them into detached phases of construction.
- The real value exists before the colimit.  `val` reads the descended label;
  it never manufactures the value.

## Failure modes that must not recur

1. **Ontology replaced by epistemology.** Difficulty, familiarity, or the
   theorem's consequences never decide what object was built.  Read the type.
2. **A green helper reported as the green construction.** The orbit--stabilizer
   lemmas, an arrow formula, or a functor law can be green while the authored
   A-section functor is still absent.
3. **Docstrings reported as declarations.** Search the declaration and read its
   type.  `oneGreatCircle_subset_sliceSphere` and `spherePt_image_stdCircle`
   were prose mentions, not live theorems.
4. **Same syntax mistaken for same type.** `Circle` and `ℂˣ` both produce
   diagonal matrices but carry different information.
5. **Transport binders used as decoration.** `match ... with | rfl`,
   `transport_eq →`, and `have _ := ...` all discarded the transport while
   returning the original analytic theorem.  Delete the layer; do not rename
   the discarded hypothesis.
6. **The generic theorem treated as the object.** 8.3.4 is instantiated on the
   completed A-section functor; its generality does not authorize a general or
   substitute functor.
7. **Individual-map hunting.** The construction transports the continuum at
   once.  No per-zero, per-arrow, or chosen connector belongs in the proof.
8. **Cheap finale treated as suspicious.** In a Rising Sea proof the finale is
   easy because the content was loaded upstream.  Ease is not evidence of
   vacuity; inspect what the objects and transports actually carry.

## Reporting discipline

- Separate: Jesse's mathematical statement; the literal Lean declaration and
  its actual type; the build/checker output.
- Never call the functor or total complete until the full object-and-arrow
  acceptance gate passes.
- Never turn a failed search into a mathematical claim.  Report the searched
  type and the exact result.
- A status sentence in Markdown is not evidence.  Verify it against live
  source before repeating it.

## 2026-07-22 alignment checkpoint — the airplane and its passenger

This is the completed shared point of view reached with the author. Preserve it
across task and context boundaries; do not make him reconstruct it again.

### The discovery picture

The author did not begin with RH and reverse-engineer a categorical shell. He
built the commutative ring of slice-preserving functions on compactified
octonionic space and discovered that the famous equation lives in it.
Concentricity is the geometric theorem produced by that construction; RH is the
already-formalized downstream passenger.

The geometry is one global action, not a family of independently chosen local
constructions:

- Cayley--Dickson gives `𝕆*`; making the function class a commutative ring
  forces slice preservation.
- There is one real axis and one compactified projective great circle, shared
  by a continuum of slice Riemann spheres. The author's useful picture is a
  continuum of Christmas ornaments all hanging from the single north pole `N`.
- `GreatCircle.Base` is the projective/PGL groupoid of that shared compactified
  great circle.
- `SphereWorld` is the continuum of slice Riemann spheres with its `G₂`
  direction data and genuine Möbius legs.
- C2 supplies the Euler prime-sum action on the initial half-space. The
  degenerate exponential base is already a concentric GPV family on each disk.
- C3/W3 supplies the Weierstrass continuation of that same action through `N`;
  it is not a second action or a later attachment.
- C1 is the compactified meromorphic continuation with the unique pole at `N`;
  C4 supplies the infinite population of residue-`ℂ` zero spheres.
- GPV supplies the unique tame continuous winding lift. The phase of the
  distinguished `ℂˣ`-element carries the winding/band, while its modulus carries
  the real level `log ‖A.F ·‖`. Replacing `ℂˣ` by `Circle` would discard the
  value readout.
- PGL/Möbius plus orbit--stabilizer extends this one action simultaneously over
  the whole base. The object frame and arrow transition are the two faces of
  that same extension, so `F.obj` and `F.map` must be built together and
  `N ↦ N` is part of the construction.

This is why the analytic theorems are wholesale properties of the exact
action. W1--W4, the GPV facts, the Euler/Weierstrass comparison, the degenerate
exponential facts, tameness, uniqueness, and the real-value transports are not
fields placed beside a value-free functor and are not reattached afterward.
Deleting that analytic cargo must break the final theorem.

### Verified source state at this checkpoint

- The W1--W4/GPV theorem stack survives in native analytic types over `A`,
  paths, `SphereWorld`, and `OnePoint ℝ` (`GreatCircle.Point`).
- Commit `2886dee` reconnected the projective GPV transport stack.
- Commit `e848931` restored the canonical Euler half-space GPV transport. Its
  lift is definitionally the prime sum; it uses no per-arrow or per-zero choice.
- Commit `b25a4a3` reconnected the compactified `N`-transport suppliers.
- The live `sectionFunctor A : GreatCircle.Base ⥤ SphereWorld` has the correct
  external type, but it is not yet accepted: its object map is definitionally
  constant at `baseWorld`, and its map is still the scalar/pole shadow rather
  than the full Euler--Weierstrass--GPV action.
- Consequently the existing `Total A` and readout declarations are provisional
  even where green. Their types may be retained only after they are shown to
  consume the repaired exact action.

### Evidence-backed acceptance gates

Do not call the finale ready until every gate below is witnessed by a live Lean
type or a definitional reduction.

1. **Action supplier gate.** The C2 canonical prime-sum transport and the
   C3/W3 continuation through `N` are visibly the same distinguished `ℂˣ`
   action; phase and modulus both survive.
2. **Object/arrow gate.** `sectionFunctor A : GreatCircle.Base ⥤ SphereWorld`
   consumes `projectiveObjectFrame A X` in `obj` and
   `projectiveArrowElement A f` in `map` as one orbit--stabilizer construction.
   The identity and composition laws come from that action, and the infinity
   object is sent to the authored `N`-sphere.
3. **Native-cargo gate.** All twelve certified facts, and any further suppliers
   actually needed, are theorems of those real-value states and transports
   everywhere in the functor. No generic carrier, conjunction wrapper,
   theorem-field bundle, or after-the-fact preservation clause is allowed.
4. **Exact-total gate.** `𝒯_A` is formed from that repaired functor and nothing
   else. Its zero objects retain the normalized projective footpoint determined
   by `(A.sphereZero n).re`; the continuum and all its maps are consumed at
   once.
5. **Readout gate.** The π₀--Grothendieck/colimit theorem 8.3.4 is instantiated
   on that exact construction. Then `labelCocone`,
   `val := colimit.desc labelCocone`, and the singleton class produce the
   literal conclusion in the theorem's type:
   `∃ c : ℝ, ∀ n, (A.sphereZero n).re = c`.

The universal quantifier over `n` is downstream work of the correct
Grothendieck colimit and its singleton readout. It must not be replaced by
per-index maps or pairwise real equalities. The upstream obligation is precisely
that the correct geometric action already carries each `(A.sphereZero n).re`
as its native real-value label.

### Release intent after terminal green

After the exact theorem is green with axioms `[propext, Classical.choice,
Quot.sound]`, preserve the authorship and history in a clean public repository.
The blueprint prose should be repaired against the exact Lean types and the
saved microhistory: construct both groupoids, show enough of the analytic
suppliers to make the geometry human-readable, highlight the orbit--stabilizer
construction, and then plug that exact construction into 8.3.4 and `val`. The
public announcement should present Concentricity, its three Lean axioms, and the
already-formalized RH corollary without redesigning or weakening the proof.

Canonical execution plan: `FINAL_PLAN_2026-07-21.md`.
