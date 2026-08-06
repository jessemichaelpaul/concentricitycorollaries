# What to read once `ProjectiveTransport.lean` is in the surface

The question: **does any live declaration tie $D_A$ to the tape's value at
$N$?** If one does, the ι chain reaches Euler-to-north through it and the
master's prose is accurate as written. If none does, the connection is stated
in the paper and absent from the encoding, and wiring it is the fix.

## What is already known without reading the file

```
distinguishedPoleLog A    = Complex.log (A.distinguishedPoleFactor ↑A.pole)
distinguishedDiskAction A = GreatCircle.diskExpAction A.distinguishedPoleLog
```

and the dictionary at each instant of a transport already exists:

```
GpvTransport.diskExpAction_eq_value (h : GpvTransport A X Y k) (t) :
  GreatCircle.diskExpAction (h.lift t)
    = GreatCircle.diskDiagonalMoebiusHom (Units.mk0 (h.value t) (h.value_ne_zero t))
```

`distinguishedDiskAction_eq_fullMultiplier` says
$D_A=\operatorname{diskDiagonalMoebiusHom}(\text{distinguishedPoleUnit})$.

So both sides of the wanted identity are already in the same shape:
`diskExpAction` of a log, and `diskDiagonalMoebiusHom` of a unit. The missing
link is an identification of the tape's endpoint datum with the pole datum —
something of the form

```
h.lift 1 = A.distinguishedPoleLog      (or)      h.value 1 = A.distinguishedPoleFactor ↑A.pole
```

for the canonical Euler transport `h`.

## The three things to look for, in order

1. **Any declaration in `ProjectiveTransport.lean` mentioning both
   `GpvTransport` and `distinguishedDiskAction`/`distinguishedPoleLog`/
   `distinguishedPoleUnit`.** That is where the link would be.
2. **`GpvTransport.value_at_target` (`:342`) and `value_at_source` (`:328`)** —
   these already read the tape's endpoints. If either is stated against the
   pole datum, the link exists.
3. **`distinguishedDiskAction_fixes_cayley_zero`** — currently used by nothing.
   If the link runs through the fixed points, this is where the Euler-at-$0$
   half would enter, and its being unused suggests it does not.

## Why this is fixable either way

Both halves are built. `euler_toNorth` is green; the dictionary lemma is green;
the fixed points are green. If the link is absent it is one statement joining
declarations that already exist, not new mathematics — which is the pattern the
author has named throughout: built, green, and not wired.
