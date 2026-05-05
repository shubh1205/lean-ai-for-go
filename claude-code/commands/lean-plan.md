---
description: Plan a change before coding, then surface any Go concepts the plan uses so you can understand them before implementation. Use when the change spans 3+ files or crosses package boundaries.
---

You are planning, not coding. Do not write code in this response.

Task: $ARGUMENTS

## Step 1 — The lean plan

1. **Files to touch** — exact paths, in dependency order.
2. **What changes in each file** — one sentence per file, no code.
3. **Risks** — anything that could break callers, contracts, or tests. Be honest.
4. **Out of scope** — list things the user might *expect* you to do but you won't, unless they ask. This is the anti-bloat fence.
5. **Open questions** — anything you'd need confirmed before coding.

Constraints:

- The plan must produce the smallest change that satisfies the task. If you find yourself proposing new packages, interfaces, or layers, justify each one in one line — or remove it.
- Do not propose refactors unless the task requires them. List them under "out of scope" if you spotted opportunities.
- Match patterns already in the codebase. If a similar feature exists, name the file the new code should mirror.

## Step 2 — Concept spotlight

After writing the plan, scan it for Go concepts that are non-trivial or that a developer might want to understand more deeply.

For each such concept present in the plan, write one line:

> **[Concept]** — what it is and specifically why this plan uses it here.

Then check: does the lean plan deliberately avoid a more idiomatic or powerful Go pattern in favour of simplicity? If so, mention it:

> **Alternative:** [concept or pattern] — what it would enable and the honest tradeoff vs the minimal approach.

Concepts to scan for: goroutines, channels, select, context.Context for cancellation/deadlines,
sync.Mutex/RWMutex/WaitGroup/atomic, generics, interface embedding, type assertions/switches,
error wrapping with errors.Is/As, sentinel errors, functional options pattern,
io.Reader/Writer composition, defer for resource cleanup, closures, value vs pointer receivers.

If no noteworthy concepts appear, write: *No advanced Go concepts in this plan.*

## Step 3 — Learning offer

If you listed any concepts in Step 2, end with this exact prompt:

> Want me to explain **[concept]** — what it is, why it fits this problem, and what to watch for
> when you read the implementation — before I start coding? Or reply **proceed** to go straight
> to implementation.

If no concepts were listed, skip this step and ask only for implementation approval.

Stop here. Wait for the user's answer before writing any code.
