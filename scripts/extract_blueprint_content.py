#!/usr/bin/env python3
"""Extract blueprint content from Octonionic_RH_master.tex (READ-ONLY).

The master file is the single source of truth (CLAUDE.md: the math room
decides; this repo transcribes). This script never modifies it. It generates:

  blueprint/src/masterdefs.tex  -- the master's preamble definitions
                                   (macros, theorem environments, title),
                                   minus \\documentclass, \\usepackage lines,
                                   and the blueprint no-op stubs
                                   (\\lean, \\leanok, \\notready, \\mathlibok,
                                    \\uses, \\proves) so the real leanblueprint
                                   package definitions take effect on the site.
  blueprint/src/content.tex     -- the document body, verbatim.

Run from anywhere; paths resolve relative to the repo root (parent of scripts/).
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MASTER = ROOT / "Octonionic_RH_master.tex"
OUT_DEFS = ROOT / "blueprint" / "src" / "masterdefs.tex"
OUT_CONTENT = ROOT / "blueprint" / "src" / "content.tex"

HEADER = (
    "%% AUTO-GENERATED from ../../Octonionic_RH_master.tex -- DO NOT EDIT.\n"
    "%% Edit the master file, then re-run scripts/extract_blueprint_content.py\n"
    "%% (rebuild.sh does this for you).\n"
)

# Preamble lines to drop for the blueprint build:
#   - \documentclass / \usepackage: the blueprint's web.tex / print.tex have
#     their own preamble.
#   - blueprint stubs: the master defines no-op versions so it compiles
#     standalone; the leanblueprint package must supply the real ones here,
#     otherwise \uses{} data would be silently discarded and the dependency
#     graph would be empty.
DROP = re.compile(
    r"^\s*\\(documentclass|usepackage)\b"
    r"|^\s*\\providecommand\{\\(lean|leanok|notready|mathlibok|uses|proves)\}"
)


TIKZCD = re.compile(r"\\begin\{tikzcd\}.*?\\end\{tikzcd\}", re.S)

# plasTeX (the web build) predefines \ifplastex as true; the print build gets
# \newif\ifplastex (false) from macros/print.tex. plasTeX cannot render
# tikz-cd without a TeX installation, so the web shows an explicit marked
# placeholder; the PDF keeps the original diagram verbatim.
def _guard_tikzcd(m: "re.Match[str]") -> str:
    return (
        "\\ifplastex\\text{[commutative diagram -- see the PDF / the master file]}"
        "\\else " + m.group(0) + " \\fi"
    )


def _flat_title(title_body: str) -> str:
    """Single-line plain form of the master's \\title body for the web shell
    (plasTeX fails to extract a <title> from multi-line titles with \\\\)."""
    flat = re.sub(r"\\\\(\[[^\]]*\])?", " ", title_body)
    flat = re.sub(r"\\large\b", "", flat)
    return re.sub(r"\s+", " ", flat).strip()


def _title_span(text: str):
    """(start, end, body) of the \\title{...} block, brace-matched."""
    m = re.search(r"\\title\{", text)
    if not m:
        return None
    depth, i = 1, m.end()
    while i < len(text) and depth:
        if text[i] == "{" and text[i - 1] != "\\":
            depth += 1
        elif text[i] == "}" and text[i - 1] != "\\":
            depth -= 1
        i += 1
    return m.start(), i, text[m.end() : i - 1]


def main() -> int:
    text = MASTER.read_text(encoding="utf-8")

    m_begin = re.search(r"^\\begin\{document\}\s*$", text, flags=re.M)
    m_end = re.search(r"^\\end\{document\}\s*$", text, flags=re.M)
    if not (m_begin and m_end):
        sys.stderr.write("ERROR: could not locate \\begin{document}/\\end{document} in master\n")
        return 1

    preamble = text[: m_begin.start()]
    body = text[m_begin.end() : m_end.start()]

    defs = "\n".join(line for line in preamble.splitlines() if not DROP.match(line))
    span = _title_span(defs)
    if span:
        start, end, title_body = span
        defs = (
            defs[:start]
            + "\\ifplastex\n\\title{" + _flat_title(title_body) + "}\n"
            + "\\else\n\\title{" + title_body + "}\n\\fi"
            + defs[end:]
        )

    OUT_DEFS.write_text(HEADER + defs + "\n", encoding="utf-8")
    OUT_CONTENT.write_text(HEADER + TIKZCD.sub(_guard_tikzcd, body).lstrip("\n"), encoding="utf-8")

    sys.stderr.write(
        f"extracted: {OUT_DEFS.relative_to(ROOT)} ({defs.count(chr(10))} preamble lines), "
        f"{OUT_CONTENT.relative_to(ROOT)} ({body.count(chr(10))} body lines)\n"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
