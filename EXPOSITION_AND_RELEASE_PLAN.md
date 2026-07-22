# EXPOSITION AND RELEASE PLAN — the vision

**Jesse Michael Paul, 2026-07-21.** Author's dictation, transcribed. Executes **after 0/0**.

---

## The prose spine

Not maximally detailed — this is a **blueprint**, and readers click through to check each claim
against the Lean. Depth belongs in the declarations; the prose carries the argument's shape.

1. **Just enough groupoid and orbit–stabilizer theory** to construct the two groupoids — the
   **projective base** and the **sphere worlds**. Only what is needed; no general categorical
   survey.

2. **Build the complete A-generated disk action forward from C1–C4/W/GPV.** Display
   `eulerDiskAction A z`, its Euler multiplier, the pole/Weierstrass continuation, and the green
   hom `Moebius → (SphereWorld ⥤ SphereWorld)` used by orbit–stabilizer.

3. **The twelve vertical passes, and why they quantify.** For each fact, show its native disk
   statement and its immediate wholesale orbit–stabilizer extension before moving to the next
   fact. Then accept `sectionFunctor A : GreatCircle.Base ⥤ SphereWorld` with its objects and
   arrows together.

4. **The total object, and the round-trip picture** — why this is the right bird's-eye point of
   view, the one that **"exhausts all the maps"** of the A-section functor.

5. **A small narrative of each main categorical homotopy theorem** — 8.3.4, π₀-Grothendieck,
   and `val`. Narrative, not machinery: what each one does and why it applies here.

6. **Run the rest of the proof of Concentricity.**

## Voice

The 2018 microhistory register (*"What is Microhistory?"*, SEH 17.2 — `inbox/064-082.pdf`).
Substantial prose already written, and many examples of the voice on file. Match it; do not
smooth it toward journal-generic.

## Linking discipline

Every statement in the prose links to what certifies it: **main theorems, corollaries, classical
facts.** A sentence that names no declaration is either a gloss (marked as such) or does not
belong. The **blueprint and `Octonionic_RH_master.tex` are substantially the same document** —
keep them in step rather than maintaining two accounts.

## Continuity — what already exists

`BOARD_LECTURE_CONCENTRICITY_2026-07-17.md` is this spine already drafted in the author's voice.
The mapping:

| Prose item | Board |
|---|---|
| 1 — the groupoids, and why these groups | Board 2 (*the motion first, and the groups it forces*) |
| 2 — the complete disk action and green action mechanism | Board 3 §3.1–3.3, Board 4 §4.1–4.3 |
| 3 — the twelve vertical passes and functor acceptance | **thinnest — Board 4 needs one subsection per accepted pass** |
| 4 — total object, round trip, exhausting the maps | Boards 5–6 |
| 5 — 8.3.4, π₀-Grothendieck, `val` | Board 8 |
| 6 — run the proof | Board 8, then Board 9 for the corollaries |

Item 3 is the one to draft fresh. Everything else is revision, not composition.

## Release sequence

1. **0/0 first.** Nothing below starts before the certificate.
2. Scrub AI/process residue per the recorded inventory; new fresh-history repo under the author's
   name alone.
3. New public page for the repo.
4. **Push to Zulip.** Make sure **everyone can run `lake build`** — reproducibility is part of the
   announcement, not an afterthought. Push what was built to the Zulip community as well.
5. **The GIF: an Ent saying RELEASE THE RIVER.**
6. Show it:
   - **`ASection.concentricity`** — three Lean axioms.
   - **the RH corollary** — three Lean axioms.
   - `[propext, Classical.choice, Quot.sound]`. No `sorryAx`. Zero project axioms.
   - **That's it.**
7. > **"Let's have fun formalizing all the consequences of the Riemann Hypothesis."**

## Standing rule for this phase

**Every hedge must name a specific non-green declaration.** If a sentence says "appears to",
"purports to", "if correct", or "preliminary", the question is *which declaration is not green* —
and if none can be named, the hedge comes out. A green build with `[propext, Classical.choice,
Quot.sound]`, zero sorries, and zero project axioms **is the proof**, not evidence for it.
Hedging past that asserts something the kernel contradicts, in the author's voice.
