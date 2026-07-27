# Geometric register — one infinite A-section action

Read `CURRENT_GATE1_MEMORY.md` first. This reference expands the geometry
needed for Gate 1; it does not prescribe a Lean encoding.

## 1. C1--C4 are one infinite analytic subject

C1--C4 are all intrinsic:

- C1 continues the A-section through its real pole and the common north pole
  `N`;
- C2 presents the distinguished factor by its infinite Euler prime data;
- C3 presents the same factor by its infinite Weierstrass divisor data;
- C4 asserts the infinitude of the residue-`ℂ` zero family.

Do not separate C4 as downstream population. The action is an infinite
analytic object from the beginning.

The GPV lift, winding, real levels, Euler and Weierstrass presentations, and
the north passage are vertical readings of this same object. Exponentiation
does not create a second action; it exposes the same factor as the
distinguished diagonal Möbius element fixing `0` and `N`.

## 2. The element is already a function

The distinguished Möbius group element is simultaneously the
slice-preserving function in the A-section ring. Therefore:

- domain and codomain value states are intrinsic;
- the output at an input is inherited by evaluation;
- the Möbius, analytic, input, and output eyes may be related by naturality,
  but must not be paired as independent objects.

The Grothendieck construction does not fuse the function and group-element
natures. Their unity must already be present in the action supplied to it.

## 3. Normalized input

For a finite octonionic input `s`, the native decomposition is:

```text
s ↦ (dir s, sliceCoord s).
```

`dir s` identifies its slice sphere and `sliceCoord s` its chart coordinate.
The distinguished action exists before this decomposition; the pair tells it
where to evaluate.

At real inputs and at `N`, no unique direction is required. These points are
shared by every slice sphere, and slice preservation makes the realization
direction-blind there.

Live suppliers include:

- `A.realize`, expressed through `Octonion.dir` and
  `Octonion.sliceCoord`;
- `realize_mem_sliceSphere`;
- `sliceCoord_smul_invariant`;
- `realize_equivariant`;
- `AsectionGenerated`, whose object formula uses the normalized coordinate;
- `AsectionGenerated_eq_equivariant`.

These suppliers show that the global point-valued action is substantially
built. They do not by themselves certify the completed projective/groupoid
assembly.

## 4. SphereWorld, orbit--stabilizer, and G₂

`SphereWorld` is the groupoid of the continuum of Riemann spheres. A
`SphereHom I J` contains:

- `rot : G2`, carrying the source direction to the target;
- `mob : Moebius`, acting in the sphere chart.

Orbit--stabilizer positions the same distinguished Möbius/function element
in every projective frame and determines its object and arrow transports
together. It acts uniformly for every sphere direction.

`G₂` is still required: it provides the natural isomorphisms connecting the
different sphere objects. Thus:

```text
orbit--stabilizer = projective/Möbius functoriality, uniform in I;
G₂                = functorial transport between I and J.
```

They are simultaneous structure on one action, not sequential decorations.

An implementation may prove a formula on a slice first only if the slice
variable is arbitrary and the proof immediately supplies `G₂` naturality.
A fixed `baseWorld` cannot serve as the global object.

## 5. The sectional projection

`AsectionSlice : GreatCircle.Base ⥤ SphereWorld` records one sphere-world
projection of the projective action. Its object map may remain at a chosen
world because Möbius transformations change the chart action, not the slice
direction.

This explains the historical constant-object behavior. It does not show that
the global action is constant. The intended action contains every normalized
input, every sphere direction, and every evaluated output.

## 6. The Gate-1 criterion

The completed object must make the following load-bearing:

- C1--C4 and the full vertically integrated GPV action;
- the normalized input `s`;
- all `SphereWorld` objects and morphisms;
- orbit--stabilizer object and arrow transport;
- `G₂` naturality;
- intrinsic input and evaluated-output states;
- the terminal comparison with the compactified-octonionic round trip.

Do not infer the encoding. Audit whether the live `AsectionActionDiagram`
already has this provenance and whether its arrow map consumes the full
action rather than only a fixed frame face.
