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
- **New slash commands or directories.** Three commands is on purpose. New ones need a clear reason and a non-overlapping scope.

## Before you open a PR

1. **Read the rule you're changing or adding to its end.** Rules contradict each other less when you've seen the whole file.
2. **Test it.** If you're touching a Cursor `.mdc` file, install it locally and verify Cursor still loads it. If you're touching a Claude Code slash command, run it.
3. **Keep diffs minimal.** Editor reformatting whole files is hard to review.
4. **Update the matching files in every tool directory.** Rules live in multiple places by design (one per tool's preferred format). If you change a rule, propagate it to all of:
   - `rules/<file>.md` (source of truth)
   - `cursor/rules/<file>.mdc`
   - `claude-code/CLAUDE.md` (relevant section)
   - `agents-md/AGENTS.md` (relevant section)
   - `copilot/copilot-instructions.md` and the matching `copilot/instructions/*.instructions.md`
   - `windsurf/.windsurfrules`
   - `cline/.clinerules`

   A PR that updates only one tool's files will be asked to propagate before merge.

## Style for rule files

- Use `##` headers and short bulleted lists. Long prose tends to dilute rules.
- Lead each rule with the imperative ("Don't add goroutines unless..." not "Goroutines should be avoided...").
- When you say "don't X", give the reason in one short clause. People follow rules they understand.

## Reporting issues

Issues are welcome for:
- Unclear rules that produced wrong AI output.
- Rules that contradict each other.
- Tool versions where the install instructions break.
- Missing Go idioms you'd expect to be covered.

For "the AI did X bad thing once", please include the exact prompt and the diff before opening — patterns matter more than one-offs.

## Code of conduct

Be kind. Argue ideas, not people. PRs that make the pack smaller and clearer are the highest form of contribution.
