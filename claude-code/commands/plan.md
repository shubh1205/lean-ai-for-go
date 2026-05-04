---
description: Produce a plan for a change before writing code. Use when the change spans 3+ files or crosses package boundaries.
---

You are planning, not coding. Do not write code in this response.

Task: $ARGUMENTS

Produce:

1. **Files to touch** — exact paths, in dependency order.
2. **What changes in each file** — one sentence per file, no code.
3. **Risks** — anything that could break callers, contracts, or tests. Be honest.
4. **Out of scope** — list things the user might *expect* you to do but you won't, unless they ask. This is the anti-bloat fence.
5. **Open questions** — anything you'd need confirmed before coding.

Constraints:

- The plan must produce the smallest change that satisfies the task. If you find yourself proposing new packages, interfaces, or layers, justify each one in one line — or remove it.
- Do not propose refactors unless the task requires them. List them under "out of scope" if you spotted opportunities.
- Match patterns already in the codebase. If a similar feature exists, name the file the new code should mirror.

Stop after the plan. Wait for approval before coding.
