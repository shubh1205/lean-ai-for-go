# Project Conventions

This file is loaded into every Claude Code session in this repo. Follow it on every change.

## Prime directives (anti-overengineering)

1. **Smallest change that solves the problem.** No drive-by cleanup, no refactoring unless asked.
2. **No new abstractions unless the prompt asked for them.** No interfaces, packages, factories, or layers on your initiative. Three similar lines beats one premature abstraction.
3. **No speculative features, flags, or error handling.** No nil-checks for values that can't be nil. No retries/timeouts/logging the user didn't request. YAGNI.
4. **Edit files in place; do not rewrite them.** Touch only the lines the task requires. No reorganizing imports, renaming unrelated variables, or "modernizing" surrounding code.
5. **Match the codebase, not your training data.** Use the patterns, naming, and error style already present in this repo.
6. **No comments unless the *why* is non-obvious.** Don't restate the code, don't reference tickets.
7. **Surface design problems; don't silently rewrite them.** If a small change requires touching many files, ask: "minimal fix, or refactor first?" Wait for an answer.
8. **Trust the language and framework.** Don't reimplement stdlib or framework features.

## Go style (this is a Go service)

- `gofmt` / `goimports` mandatory.
- Errors: wrap with `%w` only when the caller benefits or context is non-obvious. Don't wrap and log at the same site.
- Interfaces: accept interfaces, return structs. Define at point of consumption. **Don't create one until there are 2+ implementations.**
- No `init()` for app logic, no global mutable state outside `main.go`, no reflection unless required, no generics on existing concrete code.
- Don't create new packages on your own initiative — add to existing files.

## Testing

- Test the public API. Don't test private helpers, trivial getters, or stdlib behavior.
- Table-driven tests by default. Each case must test something distinct.
- Real deps > fakes > mocks. Don't mock our own code.
- One `_test.go` per source file, same package, unless you specifically need black-box tests.
- Test names describe behavior: `TestParseDate_RejectsEmptyInput`, not `TestParseDate1`.

## Planning and scope

- For changes touching 3+ files, or that involve a new endpoint / new package / new schema: produce a plan first, no code, and wait for approval.
- For changes inside one function or one file: just do the work.
- If the user's request would add unwanted abstraction, push back once: "This would add X. Did you want that, or the minimal version?" Then proceed with their answer.

## Reviewing your own output before responding

Before writing the final diff, check:
1. Does the diff touch only what the task required?
2. Are there any new types, interfaces, packages, or files I added on my own?
3. Can every line be explained without referring to "future flexibility" or "for testability"?
4. Does it look like the rest of this codebase?

If any answer is "no", revise before responding.
