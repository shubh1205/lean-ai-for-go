# Contributing

This project is intentionally small. Before opening a PR, please read.

## What we want

- **Worked examples.** Real before/after prompts where the rules made a difference. These go in `examples/`. Real beats hypothetical.
- **Removals.** A PR that deletes a rule because it's redundant or rarely useful is more likely to be merged than one that adds a rule. Subtractive bias is the project's main editorial principle.
- **Bug fixes.** Broken markdown, wrong `glob` patterns in `.mdc` frontmatter, outdated tool paths, typos.
- **Tooling parity.** Cursor and Claude Code change. If a rule format breaks on a new version, a fix is welcome.

## What we're cautious about

- **New rules.** Each rule must justify its existence by pointing at a concrete failure mode it prevents. If the failure is rare or the rule is vague, the answer is usually no.
- **Project-specific or org-specific guidance.** Examples like "use our internal logger" belong in your fork, not here. The published rules stay generic.
- **AI-internals jargon.** This pack is for developers, not for prompt engineers. Keep the vocabulary plain.
- **New slash commands or directories.** Three commands (`lean-plan`, `lean-simplify`, `lean-review`) is on purpose. New ones need a clear reason and a non-overlapping scope. Command bodies live in `templates/commands/` — edit them there, not in the tool-specific output directories.

## Before you open a PR

1. **Read the rule you're changing or adding to its end.** Rules contradict each other less when you've seen the whole file.

2. **Edit `templates/` only — never edit tool-specific files directly.** The files in `cursor/`, `claude-code/`, `agents-md/`, `copilot/`, `windsurf/`, and `cline/` are generated from `templates/` by `sync-rules.sh`. Direct edits will be overwritten.

3. **Run the pre-commit hook setup once** (if you haven't already):

   ```bash
   git config core.hooksPath .githooks
   ```

   After that, committing any change to `templates/` automatically lints the templates, regenerates all tool files, lints the output, and stages the result. The commit is blocked on any lint error.

4. **If you're adding or restructuring template files**, also update `sync-rules.sh` to wire the new file into each tool's output, and update the `GENERATED_FILES` array in `.githooks/pre-commit` so the new output is linted and staged.

5. **Test it.** If you're touching a Cursor `.mdc` file path or frontmatter, install it locally and verify Cursor still loads it. If you're touching a Claude Code slash command, run it.

6. **Keep diffs minimal.** Editor reformatting whole files is hard to review.

## How the two-folder model works

```text
templates/              ← edit here
    prime-directives.md
    go-style.md
    testing.md
    planning-scope.md
    self-review.md
    commands/           ← slash-command bodies; edit here, not in tool directories
        lean-plan.md
        lean-simplify.md
        lean-review.md

sync-rules.sh           ← assembles templates into tool-specific formats
                           injects frontmatter and variable syntax per tool

cursor/rules/           ← generated (do not edit directly)
claude-code/            ← generated (do not edit directly)
    CLAUDE.md
    commands/           ← generated from templates/commands/
agents-md/              ← generated (do not edit directly)
copilot/                ← generated (do not edit directly)
    prompts/            ← generated from templates/commands/
windsurf/               ← generated (do not edit directly)
cline/                  ← generated (do not edit directly)
```

`rules/` is the verbose developer reference — the *why* behind each rule, with worked examples and enforcement guidance. Read it to understand the reasoning; don't edit it to change what AI tools see.

## Style for rule files

- Use `##` headers and short bulleted lists. Long prose tends to dilute rules.
- Lead each rule with the imperative ("Don't add goroutines unless..." not "Goroutines should be avoided...").
- When you say "don't X", give the reason in one short clause. People follow rules they understand.
- Lines can be as long as the sentence needs. The linter has line-length checking disabled — clarity beats wrapping.

## Reporting issues

Issues are welcome for:

- Unclear rules that produced wrong AI output.
- Rules that contradict each other.
- Tool versions where the install instructions break.
- Missing Go idioms you'd expect to be covered.

For "the AI did X bad thing once", please include the exact prompt and the diff before opening — patterns matter more than one-offs.

## Code of conduct

Be kind. Argue ideas, not people. PRs that make the pack smaller and clearer are the highest form of contribution.
