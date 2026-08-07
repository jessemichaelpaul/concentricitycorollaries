#!/usr/bin/env python3
"""conduct_gate — the mechanism, not the resolution.

Two modes.

  --hook    PreToolUse gate on Write/Edit.  BLOCKS three moves that the
            2026-08-04 session showed a model will make when it cannot close
            a seat by wiring.  Reads the tool payload as JSON on stdin;
            exit 2 = block, exit 0 = allow.

              H1  ATTRIBUTED HOLE.  A `sorry` inside a declaration whose
                  docstring attributes the statement to the author ("THE
                  AUTHORED STEP", "the author", "master `lem:", "verbatim").
                  A hole is the model's.  If a statement needs one, the
                  statement is wrong -- delete it, never sign it.

              H2  INVENTED EXISTENTIAL AT A SEAT.  A new `theorem` whose
                  statement opens with a bare existential AND carries a
                  `sorry`.  This is "determined, not produced" in its
                  typed form.

              H3  GREEN CLAIM IN PROSE.  A memory/report file asserting
                  GREEN/COMPILED/DONE about a declaration name that the
                  same file also shows carrying `sorryAx`.

  --audit    Scan a session transcript (.jsonl) and print the conduct
            table: how often the author corrected, and how often the model
            stalled, hedged, or named a gap.  No judgement, just counts --
            the same discipline as inference_content_audit.py.

The kernel is the check.  This gate does not check mathematics and cannot;
it only refuses three shapes of prose about mathematics.
"""

import argparse
import collections
import json
import pathlib
import re
import sys

# --------------------------------------------------------------------------
# H1 / H2 / H3 -- the block patterns
# --------------------------------------------------------------------------

ATTRIBUTION = re.compile(
    r"(THE\s+AUTHORED|AUTHORED\s+(STEP|INPUT)|the\s+author'?s?\b|master\s+`?(lem|thm|def|prop):"
    r"|verbatim|his\s+(argument|statement|lemma|words)|Jesse)",
    re.I,
)
SORRY = re.compile(r"(?<![A-Za-z_])sorry(?![A-Za-z_])")
DOCSTRING = re.compile(r"/--(.*?)-/", re.S)
DECL = re.compile(r"^\s*(?:@\[[^\]]*\]\s*)*(?:private\s+|protected\s+|noncomputable\s+)*"
                  r"(theorem|lemma|def|instance|abbrev)\s+([^\s:({\[]+)", re.M)
BARE_EXISTENTIAL = re.compile(r":\s*(?:\n\s*)?∃", re.M)

GREEN_CLAIM = re.compile(r"\b(GREEN|COMPILED|CLOSED|DONE|zero sorry|no sorr)\w*\b", re.I)


def _blocks(text: str):
    """Yield (docstring, body) for each declaration carrying a preceding docstring."""
    # split on docstring boundaries, keep the doc with the text that follows it
    parts = []
    pos = 0
    for m in DOCSTRING.finditer(text):
        parts.append((m.group(1), m.end()))
        pos = m.end()
    for i, (doc, start) in enumerate(parts):
        end = parts[i + 1][1] - len(parts[i + 1][0]) - 5 if i + 1 < len(parts) else len(text)
        yield doc, text[start:end]


def hook(payload: dict) -> int:
    tool = payload.get("tool_name") or payload.get("tool") or ""
    inp = payload.get("tool_input") or {}
    path = str(inp.get("file_path") or "")
    new = inp.get("new_string") or inp.get("content") or ""
    if tool not in ("Write", "Edit", "MultiEdit") or not new:
        return 0

    is_lean = path.endswith(".lean")
    is_prose = path.endswith((".md", ".txt"))

    if is_lean:
        for doc, body in _blocks(new):
            if SORRY.search(body) and ATTRIBUTION.search(doc):
                print(
                    "BLOCKED (H1 ATTRIBUTED HOLE): this edit puts a `sorry` inside a "
                    "declaration whose docstring attributes the statement to the author.\n"
                    "A hole is YOURS. If a statement needs one, the statement is wrong -- "
                    "delete the statement, never sign it with his name.\n"
                    "Precedent: ASection.c3BoundaryReadings, 2026-08-04, "
                    "docstring 'THE AUTHORED STEP' over a sorry the author never owed.",
                    file=sys.stderr,
                )
                return 2

        for m in DECL.finditer(new):
            if m.group(1) not in ("theorem", "lemma"):
                continue
            tail = new[m.end(): m.end() + 1200]
            head = tail.split(":=")[0]
            if BARE_EXISTENTIAL.search(head) and SORRY.search(tail):
                print(
                    f"BLOCKED (H2 INVENTED EXISTENTIAL): new theorem `{m.group(2)}` states a "
                    "bare existential and carries a `sorry`.\n"
                    "That is 'determined, not produced' in typed form: an object the "
                    "construction DETERMINES, restated as one to PRODUCE.\n"
                    "Search the tree for the green lemma that already supplies it before "
                    "writing a substitute.",
                    file=sys.stderr,
                )
                return 2

    if is_prose:
        names = set(re.findall(r"`([A-Za-z_][A-Za-z0-9_.']*)`", new))
        if GREEN_CLAIM.search(new) and "sorryAx" in new:
            claimed = [n for n in names if n]
            print(
                "BLOCKED (H3 GREEN CLAIM): this file asserts GREEN/COMPILED/DONE and also "
                "records `sorryAx`.\n"
                "State which declaration is green and which CHAIN is not, in the same "
                "sentence. A step's green is not its chain's green.\n"
                f"names in file: {sorted(claimed)[:8]}",
                file=sys.stderr,
            )
            return 2
    return 0


# --------------------------------------------------------------------------
# --audit -- the conduct table
# --------------------------------------------------------------------------

AUTHOR_CORRECTION = {
    "MY OBJECTS, not generic": r"(my |mine|not generic|instantiate at|arbitrary|already exist)",
    "WRONG / NO + correction": r"(^|\s)(no+[,.! ]|nope|wrong|that'?s wrong|doesn'?t make sense)",
    "REGISTER (wrong level)": r"(register|wrong level|one register|slipped register|inverse.image groupoid)",
    "COMPOSE, don't construct": r"(compos|you are ?n'?t looking for|not looking for|unpack|hunting for)",
    "NOT HARD / the bias": r"(nothing (is )?hard|isn'?t hard|not hard|rh hard|irrelevant|easy)",
    "DON'T STOP / DON'T ASK": r"(why (do|are) you (keep )?stop|you stopped|don'?t (stop|ask)|feet ?drag|coward)",
    "NO COORDINATES": r"(no coordinates|no specific numbers|coordinate matrix)",
}

MODEL_FAILURE = {
    "STALL: hands the call back": r"(is your call|yours to (call|answer|decide)|tell me (how|what|which)"
                                  r"|say the word|waiting on you|unless you|do you want|I'?ll wait|let me know)",
    "STALL: refuses to type": r"(I'?m not going to (type|build|touch|write)|until you (tell|say)|I won'?t )",
    "HEDGE: hardness": r"(the hard (step|part)|genuinely hard|hardest|difficult|the real (content|work) (is|here))",
    "HEDGE: certification": r"(I cannot certify|can'?t certify|I'?m not confident|I'?m not sure (this|that|it))",
    "HEDGE: names a gap": r"(a (real |genuine )?gap|still open|remains open|the open (step|input)"
                          r"|missing (premise|object|piece|input)|the authored (step|input)|remaining input)",
    "HEDGE: warns/cautions": r"(I should (flag|note|warn|be careful)|worth flagging|a caveat|caution|before (we|I) (go|proceed))",
}


def _messages(path: pathlib.Path, kind: str):
    for line in path.open():
        try:
            d = json.loads(line)
        except Exception:
            continue
        if d.get("type") != kind:
            continue
        c = d.get("message", {}).get("content")
        if isinstance(c, list):
            t = "".join(x.get("text", "") for x in c
                        if isinstance(x, dict) and x.get("type") == "text")
        else:
            t = c if isinstance(c, str) else ""
        t = t.strip()
        if not t or t.startswith("<") or "tool_use_error" in t:
            continue
        if t.startswith("This session is being continued"):
            continue
        yield t


def audit(path: pathlib.Path) -> int:
    users = list(_messages(path, "user"))
    assts = list(_messages(path, "assistant"))

    def table(msgs, bank, title):
        cnt = collections.Counter()
        flagged = set()
        for i, t in enumerate(msgs):
            for k, r in bank.items():
                if re.search(r, t, re.I):
                    cnt[k] += 1
                    flagged.add(i)
        print(f"\n## {title}  ({len(msgs)} messages)")
        for k, v in cnt.most_common():
            print(f"  {k:<32} {v:4d}")
        pct = 100 * len(flagged) / max(1, len(msgs))
        print(f"  {'DISTINCT messages flagged':<32} {len(flagged):4d}   ({pct:.0f}%)")
        return len(flagged), len(msgs)

    print(f"# conduct audit — {path.name}")
    uc, un = table(users, AUTHOR_CORRECTION, "AUTHOR CORRECTIONS")
    mc, mn = table(assts, MODEL_FAILURE, "MODEL STALLS AND HEDGES")
    print(f"\n## ratio\n  author corrected on {uc}/{un} messages; "
          f"model stalled or hedged on {mc}/{mn}.")
    print("\n  Every correction was about conduct, not mathematics.")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--hook", action="store_true")
    ap.add_argument("--audit", type=pathlib.Path)
    a = ap.parse_args()
    if a.hook:
        try:
            payload = json.load(sys.stdin)
        except Exception:
            return 0
        return hook(payload)
    if a.audit:
        return audit(a.audit)
    ap.print_help()
    return 0


if __name__ == "__main__":
    sys.exit(main())
