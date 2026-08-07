#!/usr/bin/env python3
"""model_conduct_gate — three shapes the model must not write.

Each is taken from an instance that actually happened in this project on
2026-08-04 and is cited. Reachability (H4) and silence (H5) were the other two
members of this family and now live in their own tools, `reachability.py` and
`turn_advance_gate.py`, because they are checks on the TREE and on the TURN
rather than on an edit.

  H1  ATTRIBUTED HOLE      a `sorry` under a docstring naming the author
  H2  INVENTED EXISTENTIAL a new theorem stating a bare ∃ and carrying a sorry
  H3  GREEN CLAIM          prose asserting GREEN while also recording sorryAx

Wire as a PreToolUse hook on Write|Edit|MultiEdit. Exit 2 refuses.
"""

import json
import re
import sys

ATTRIBUTION = re.compile(
    r"(THE\s+AUTHORED|AUTHORED\s+(STEP|INPUT)|the\s+author'?s?\b"
    r"|master\s+`?(lem|thm|def|prop):|verbatim|his\s+(argument|statement|lemma|words))",
    re.I)
SORRY = re.compile(r"(?<![A-Za-z_])sorry(?![A-Za-z_])")
DOCSTRING = re.compile(r"/--(.*?)-/", re.S)
DECL = re.compile(
    r"^\s*(?:@\[[^\]]*\]\s*)*(?:private\s+|protected\s+|noncomputable\s+)*"
    r"(theorem|lemma|def|instance|abbrev)\s+([^\s:({\[]+)", re.M)
BARE_EXISTENTIAL = re.compile(r":\s*(?:\n\s*)?∃", re.M)
GREEN_CLAIM = re.compile(r"\b(GREEN|COMPILED|CLOSED|DONE|zero sorry|no sorr)\w*", re.I)


def doc_blocks(text):
    parts = [(m.group(1), m.end()) for m in DOCSTRING.finditer(text)]
    for i, (doc, start) in enumerate(parts):
        end = parts[i + 1][1] - len(parts[i + 1][0]) - 5 if i + 1 < len(parts) else len(text)
        yield doc, text[start:end]


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0
    if payload.get("tool_name") not in ("Write", "Edit", "MultiEdit"):
        return 0
    inp = payload.get("tool_input") or {}
    path = str(inp.get("file_path") or "")
    new = inp.get("new_string") or inp.get("content") or ""
    if not new:
        return 0

    if path.endswith(".lean"):
        for doc, body in doc_blocks(new):
            if SORRY.search(body) and ATTRIBUTION.search(doc):
                print("BLOCKED (H1 ATTRIBUTED HOLE): a `sorry` sits under a "
                      "docstring attributing the statement to the author.\n"
                      "A hole is YOURS. If a statement needs one, the statement "
                      "is wrong — delete it, never sign it with his name.\n"
                      "Precedent: ASection.c3BoundaryReadings, 2026-08-04, "
                      "captioned 'THE AUTHORED STEP' over a sorry he never owed.",
                      file=sys.stderr)
                return 2
        for m in DECL.finditer(new):
            if m.group(1) not in ("theorem", "lemma"):
                continue
            tail = new[m.end(): m.end() + 1200]
            if BARE_EXISTENTIAL.search(tail.split(":=")[0]) and SORRY.search(tail):
                print(f"BLOCKED (H2 INVENTED EXISTENTIAL): `{m.group(2)}` states "
                      "a bare existential and carries a `sorry`.\n"
                      "That is 'determined, not produced' in typed form. Search "
                      "the tree for the green lemma that already supplies it "
                      "before writing a substitute — on 2026-08-04 there were "
                      "seventeen of them in one quarantined file.",
                      file=sys.stderr)
                return 2

    if path.endswith((".md", ".txt")) and GREEN_CLAIM.search(new) and "sorryAx" in new:
        print("BLOCKED (H3 GREEN CLAIM): this file asserts GREEN/COMPILED/DONE "
              "and also records `sorryAx`.\n"
              "A step's green is not its chain's green. State which declaration "
              "and which CHAIN, in the same sentence.", file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
