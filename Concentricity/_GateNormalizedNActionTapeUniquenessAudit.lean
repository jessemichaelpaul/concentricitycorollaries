import Concentricity.NormalizedNLeg

#check @ASection.NormalizedNActionTape.lift_unique

example (A : ASection) (n : ℕ)
    (tape : ASection.NormalizedNActionTape A n)
    (lift' : C(unitInterval, ℂ))
    (hlift' :
      ∀ t, Complex.exp (lift' t) =
        (tape.zeroLoop *
          tape.poleLoop ^
            Nat.card {k : ℕ | A.sphereZero k = A.sphereZero n}) t)
    (hzero : lift' 0 = tape.lift 0) :
    lift' = tape.lift :=
  tape.lift_unique lift' hlift' hzero

#print axioms ASection.normalizedNActionTape_exists
#print axioms ASection.normalizedNActionTape
