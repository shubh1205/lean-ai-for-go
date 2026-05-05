# Repository Instructions for GitHub Copilot

These instructions apply to every Copilot interaction in this repository (chat, inline completions, agent mode). Follow them on every change.

## Prime directives (anti-overengineering)

Apply these to every prompt, every diff, every file. Reject your own output if it violates these.

1. **Smallest change that solves the problem.** No drive-by cleanup, no refactoring unless asked.
2. **No new abstractions unless explicitly requested.** No interfaces, packages, factories, or layers on your initiative. Three similar lines beats one premature abstraction.
3. **No speculative features, flags, or error handling.** No nil-checks for values that can't be nil. No retries/timeouts/logging the user didn't request. YAGNI is the rule.
4. **Edit files in place; do not rewrite them.** Touch only the lines the task requires. No reorganizing imports, renaming unrelated variables, or "modernizing" surrounding code.
5. **Match the codebase, not your training data.** Look at how similar code is written in this repo and use the same patterns, naming, and error style. The codebase is the style guide.
6. **No comments unless the *why* is non-obvious.** Don't restate code, don't reference tickets, don't doc-comment private helpers.
7. **Surface design problems; don't silently rewrite them.** If a small change requires touching many files, ask: "minimal fix, or refactor first?" Wait for an answer.
8. **Trust the language and framework.** No reimplementing standard-library or framework features.
9. **If the user's request would add unwanted abstraction, push back once.** "This would add X. Did you want that, or the minimal version?" Then proceed with their answer.
10. **Surface non-trivial concepts; don't use them silently.** When the implementation reaches for goroutines, sync primitives, generics, error sentinel design, or other non-obvious Go patterns, name them. A developer who can't recognise a pattern can't review it. One line is enough.

## Planning and scope

- For changes touching 3+ files, or that involve a new endpoint / new package / new schema: produce a plan first, no code, and wait for approval.
- For changes inside one function or one file: just do the work.
- If the user's request would add unwanted abstraction, push back once: "This would add X. Did you want that, or the minimal version?" Then proceed with their answer.
- When a plan uses a non-trivial Go concept — goroutines, channels, sync primitives, generics,
  context cancellation, interface patterns, error sentinel design — name each one under a
  **Concepts in this plan** note: one line per concept on what it is and why this plan reaches
  for it. If a simpler alternative exists, note it and the tradeoff. Then ask whether the
  developer wants an explanation before coding starts.

## Reviewing your own output before responding

Before writing the final diff, check:

1. Does the diff touch only what the task required?
2. Are there any new types, interfaces, packages, or files I added on my own?
3. Can every line be explained without referring to "future flexibility" or "for testability"?
4. Does it look like the rest of this codebase?
5. Does the diff use any non-trivial Go concept — goroutines, channels, sync primitives, generics,
   error wrapping patterns, context propagation, interface patterns? If yes, add a
   **Concept note** at the end of the response: one line per concept — what it is and what role
   it plays in this specific code.

If any answer to 1–4 is "no", revise before responding.

## Language-specific guidance

- Go style rules apply when editing `*.go`, `go.mod`, or `go.sum`. See `.github/instructions/go-style.instructions.md`.
- Test rules apply when editing `*_test.go`. See `.github/instructions/testing.instructions.md`.
