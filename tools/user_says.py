#!/usr/bin/env python3
"""Print ONLY the author's own message text from the session transcripts.
The assistant cannot write into role=="user" records, so this is the one
channel it cannot forge."""
import json, sys, glob, os
needle = sys.argv[1]
d = os.path.expanduser("~/.claude/projects/-Users-jessepaul-Desktop-concentricity")
for f in glob.glob(os.path.join(d, "*.jsonl")):
    for line in open(f, errors="ignore"):
        try: o = json.loads(line)
        except Exception: continue
        m = o.get("message") or {}
        if m.get("role") != "user":      # <-- the whole point
            continue
        c = m.get("content")
        t = (" ".join(x.get("text","") for x in c if isinstance(x,dict))
             if isinstance(c, list) else (c if isinstance(c, str) else ""))
        if needle in t:
            print("FOUND"); sys.exit(0)
sys.exit(1)
