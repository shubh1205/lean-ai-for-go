# Prompting Playbook

This file is for the developer, not the AI. It's the shared vocabulary for getting good output from your AI tools.

## The four-part prompt

A good prompt has four parts. Drop any of them and quality drops.

1. **Where** — file path and function/area: `In src/handlers/order.go, in CreateOrder...`
2. **What** — the change, in plain language: `...return 400 when Quantity is zero or negative...`
3. **How small** — explicit scope: `...as a single guard at the top of the function. No new validator, no helper.`
4. **Why** (optional but useful) — context the AI can't infer: `...the upstream client doesn't validate, so handlers are the boundary.`

Skipping #3 is the #1 cause of overengineered output.

## Phrases that work

Keep these in muscle memory:

- **"The smallest change that does X."** Pin it to almost every prompt.
- **"Edit in place. Don't reorganize anything else."** Stops drive-by refactors.
- **"No new files. No new packages. No new interfaces."** Use when you know the change is local.
- **"Match the style of `path/to/similar/file.go`."** Anchors the AI to your codebase.
- **"Show me the diff first; don't write the file yet."** Useful for non-trivial changes.
- **"Plan only. No code."** Use before any change touching 3+ files.

## Phrases that backfire

Avoid:

- **"Refactor X for clarity"** — open invitation to rewrite. Be specific about what's unclear.
- **"Make it more idiomatic"** — vague; AI will introduce abstractions you didn't want.
- **"Add proper error handling"** — produces wrap-everything noise. Say *what* error case you care about.
- **"Make it production-ready"** — produces logging, metrics, retries you didn't ask for.
- **"While you're at it, also..."** — two prompts pretending to be one. Send them separately.

## When NOT to use AI

Faster to do it yourself:

- 1-3 line changes you already know.
- Renaming a variable in one file (your IDE does this).
- `gofmt` / import fixes.
- Anything where typing the prompt takes longer than typing the code.

The AI is for: new code paths, unfamiliar areas, boilerplate that fits a clear pattern, test scaffolding, and "explain what this does" reading tasks.

## Reviewing AI output: the four checks

Before accepting a diff, in order:

1. **Scope check.** Does the diff touch only what I asked? If no — reject.
2. **Abstraction check.** Any new interfaces, packages, files, or types? If yes, did I ask for each one? If no — reject.
3. **Comprehension check.** Can I explain every line without re-reading? If no — ask the AI to simplify until I can.
4. **Pattern check.** Does it look like the rest of the codebase? If no — point at a similar file and ask for a re-pass.

Three rejections are normal on a hard task. Four is a sign the prompt is wrong, not the AI.

## Pushing back when the AI overengineers

When you get a bloated diff, the fix is usually a single follow-up:

> "Roll that back. The smallest possible change is [one-line description]. Do that instead, no new types or files."

If it overengineers a second time on the same task, the task is the wrong size for one prompt — break it down.

## When to use `/plan` (Claude Code) or "draft a plan first" (Cursor)

Use it when:
- The task touches 3+ files.
- You're not sure which files are involved.
- The task crosses package boundaries.
- You're modifying a contract that has multiple callers.

Don't use it when:
- The fix is local to one function.
- You already know the answer and just want it typed out.
- The work is bounded enough that re-prompting is cheaper than planning.

A plan is a tool for alignment, not a ritual.

## Worked examples

See [`examples/prompting-patterns.md`](../examples/prompting-patterns.md) for three before/after prompts on real Go tasks.
