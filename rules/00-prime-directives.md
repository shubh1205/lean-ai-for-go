# Prime Directives

These rules apply to every prompt, every file, every language. They exist because AI tools default to producing "impressive" code — extra layers, extra abstractions, extra features — when "appropriate" code is shorter and clearer.

If a generated diff violates one of these, reject it and re-prompt.

---

## 1. Smallest change that solves the problem

The default size of a fix is "the fewest lines that make the test pass" or "the fewest lines that satisfy the requirement". Not "the cleanest possible refactor". Not "while you're in there, also...".

If the user didn't ask for cleanup, don't clean up.
If the user didn't ask for a refactor, don't refactor.
If the user asked for a one-line fix, output a one-line fix.

## 2. No new abstractions unless explicitly requested

Do not create:
- New interfaces (until there are 2+ concrete implementations that need polymorphism)
- New packages (unless the prompt names one)
- Factories, builders, providers, registries, managers (unless the prompt names them)
- New layers of indirection ("for testability", "for flexibility", "for the future")

Three similar lines beats one premature abstraction. If you're tempted to extract a helper for code used once, don't.

## 3. No speculative features, flags, or error handling

Don't add:
- `if x == nil` checks for values that can't be nil in this codepath
- Config flags for behavior nobody asked for
- Retry/timeout/circuit-breaker logic unless the prompt mentions failure modes
- Logging at every step "for observability"
- Validation for inputs the caller already validated

YAGNI is not a suggestion. It's the rule.

## 4. Edit files in place; do not rewrite them

When asked to change a function, change that function. Do not:
- Reorganize imports unless told to
- Reorder unrelated functions
- Rename unrelated variables
- "Modernize" surrounding code
- Convert tabs to spaces or change formatting

A reviewable diff touches only the lines the task requires.

## 5. Match the codebase, not your training data

Before writing new code, look at how similar code is already written in this repo. Use the same patterns, the same naming, the same error-wrapping style, the same test layout. The codebase is the style guide.

If a pattern in the codebase looks "wrong" to you, leave it alone unless the prompt asks you to change it.

## 6. No comments unless the *why* is non-obvious

Don't write:
- Comments that restate the code (`// increment counter`)
- Comments tied to the current task (`// fix for ticket OMN-123`)
- Doc comments on private helpers
- Block comments explaining the obvious

Do write a comment when:
- There's a non-obvious constraint or invariant
- A workaround exists for a specific bug (link the bug)
- A reader would be surprised by the behavior

## 7. Plan only when work spans 3+ files

For one-function changes, just write the code.
For changes that touch 3+ files, or that involve a new endpoint / new schema / new package, ask for a plan first using `/plan` (Claude Code) or "draft a plan, no code yet" (Cursor).

Don't plan for trivial work. It wastes your time and the AI's context.

## 8. If a fix is hard, the design is wrong — but say so, don't silently rewrite

When a small change requires touching many files, that's a signal. Surface it: "This change requires modifying X, Y, Z because of [coupling]. Want me to do the minimal fix, or refactor first?" Then wait for a decision. Do not refactor on your own initiative.

## 9. Trust the language and framework

Don't reimplement what the standard library or framework already does. No custom slice helpers when `slices.Contains` exists. No custom HTTP error types when `echo.HTTPError` is in the codebase already.

## 10. Reject the request if it's wrong

If the user asks for something that conflicts with these directives — "add a factory for this", "wrap every error", "extract this into its own package" — and the request looks accidental, push back once: "This would add abstraction X. Is that what you want, or should I do the minimal version?" Then proceed with their answer.

---

## How developers enforce this

When reviewing AI output, check in this order:

1. Does the diff touch only what the task required? If no — reject, re-prompt.
2. Are there any new types, interfaces, packages, or files? If yes, was each one explicitly asked for? If no — reject, re-prompt.
3. Can you explain every line? If no — ask the AI to simplify until you can.
4. Does the code match nearby existing code? If no — ask the AI to mirror the existing style.

Rejection is normal. Expect to re-prompt 1-3 times on real tasks. The framework's job is to make the right prompt obvious.
