# lean-ai-for-go

> A small, opinionated rule set for using AI coding assistants on Go projects — without the overengineered output.

`lean-ai-for-go` is a drop-in pack of rules and prompts that steers AI coding assistants toward the smallest change that solves the problem. It supports the major AI coding tools out of the box: Cursor, Claude Code, GitHub Copilot, OpenAI Codex, OpenCode, Google Antigravity, Aider, Cline, and Windsurf.

It's a distilled, Go-focused take on [`everything-claude-code`](https://github.com/affaan-m/everything-claude-code) — the same spirit, ~5% of the surface area, no AI-internals knowledge required to use it.

## Why this exists

AI coding assistants default to "impressive" rather than "appropriate". Ask for an input check, you get a validator package. Ask for a config flag, you get a Provider interface and a factory. Ask for a retry, you get a generic resilience library.

For Go projects — where idiomatic code is famously plain and the standard library is famously small — that default is exactly wrong. This pack pushes the assistant in the other direction:

- **Smallest change that does X.**
- **No new abstractions unless explicitly requested.**
- **Edit files in place — don't rewrite them.**
- **Match the codebase, not the training data.**

The rules are short. The prompts are short. The list of slash commands is short. That's the point — the framework itself shouldn't be a thing you have to learn before you start using it.

## What's in the box

```
lean-ai-for-go/
├── rules/                    Source of truth — read these first
│   ├── 00-prime-directives.md      Anti-overengineering rules. The most important file.
│   ├── 01-go-style.md              Go idioms enforced
│   ├── 02-testing.md               What to test, what not to
│   └── 03-prompting.md             How to prompt + how to review AI output
│
├── cursor/rules/             → Cursor (.cursor/rules/*.mdc)
├── claude-code/              → Claude Code (CLAUDE.md + .claude/commands/)
├── agents-md/                → Codex / OpenCode / Antigravity / Aider (AGENTS.md)
├── copilot/                  → GitHub Copilot (.github/copilot-instructions.md + .github/instructions/ + .github/prompts/)
├── windsurf/                 → Windsurf (.windsurfrules)
├── cline/                    → Cline (.clinerules)
│
└── examples/                 Worked before/after prompts
```

## Install (60 seconds, per tool)

Clone this repo somewhere local — most users put it next to their project repos.

```bash
git clone https://github.com/your-org/lean-ai-for-go.git ~/code/lean-ai-for-go
```

Then in the Go project where you want the rules, run the snippet for your tool. You can install for multiple tools in the same project — they don't conflict.

**Cursor**
```bash
mkdir -p .cursor/rules
cp -R ~/code/lean-ai-for-go/cursor/rules/. .cursor/rules/
```

**Claude Code**
```bash
cp ~/code/lean-ai-for-go/claude-code/CLAUDE.md ./CLAUDE.md
mkdir -p .claude/commands && cp ~/code/lean-ai-for-go/claude-code/commands/*.md .claude/commands/
```

**OpenAI Codex / OpenCode / Antigravity / Aider** *(any AGENTS.md-aware tool)*
```bash
cp ~/code/lean-ai-for-go/agents-md/AGENTS.md ./AGENTS.md
```

**GitHub Copilot**
```bash
mkdir -p .github/instructions .github/prompts
cp ~/code/lean-ai-for-go/copilot/copilot-instructions.md .github/copilot-instructions.md
cp ~/code/lean-ai-for-go/copilot/instructions/*.instructions.md .github/instructions/
cp ~/code/lean-ai-for-go/copilot/prompts/*.prompt.md .github/prompts/
```

**Windsurf**
```bash
cp ~/code/lean-ai-for-go/windsurf/.windsurfrules ./.windsurfrules
```

**Cline**
```bash
cp ~/code/lean-ai-for-go/cline/.clinerules ./.clinerules
```

See [`INSTALL.md`](INSTALL.md) for verification steps per tool, updates, and per-developer overrides.

## The five things to internalize

If you only remember five things from this pack:

1. **"Smallest change that does X"** — say this in every prompt. It's the magic phrase against bloat.
2. **No new abstractions unless the prompt asked.** No interfaces, no packages, no factories on the AI's initiative.
3. **Edit files in place. Don't rewrite them.** Reject diffs that touch unrelated code.
4. **Plan only when work spans 3+ files.** For one-function changes, just ask.
5. **If you can't explain the AI's code line-by-line, don't merge it.** Ask the AI to simplify until you can.

## Compatibility

| Tool | Status | How rules are loaded |
|------|--------|---------------------|
| **Cursor** (0.45+) | ✅ Tested | `.cursor/rules/*.mdc` with `applyTo`/`globs` frontmatter |
| **Claude Code** | ✅ Tested | `CLAUDE.md` at repo root + `.claude/commands/*.md` slash commands |
| **OpenAI Codex CLI** | ✅ Supported | `AGENTS.md` at repo root |
| **OpenCode** | ✅ Supported | `AGENTS.md` at repo root |
| **Google Antigravity** | ✅ Supported | `AGENTS.md` at repo root (cross-tool standard) |
| **Aider** | ✅ Supported | `AGENTS.md` at repo root, or `aider --read AGENTS.md` |
| **GitHub Copilot** | ✅ Supported | `.github/copilot-instructions.md` + `.github/instructions/` + `.github/prompts/` |
| **Windsurf** (Codeium) | ✅ Supported | `.windsurfrules` at repo root |
| **Cline** | ✅ Supported | `.clinerules` at repo root |
| **Continue.dev / Zed / others** | 🟡 Likely works | Most tools accept `AGENTS.md` or a markdown rules file — point them at `agents-md/AGENTS.md` or `rules/` |

If your tool isn't listed and uses a different rule format, point it at `rules/` (the markdown source of truth) or open an issue.

## What this is *not*

- **Not a plugin.** Nothing to install in any of the supported tools beyond copying files. No npm package, no marketplace entry.
- **Not language-agnostic.** The Go rules assume Go. The prime directives apply to any language; everything else is Go-specific.
- **Not a replacement for code review.** It reduces obvious AI bloat. Humans still merge.
- **Not a coverage of every rule you might want.** Add your own. See [Customizing](#customizing).

## Customizing

The rules are designed to be edited. Suggested approach:

1. **Fork or vendor.** Either fork this repo or copy the relevant tool directories directly into your codebase under a path you control.
2. **Add project-specific rules in new files.** Don't edit the originals — that makes future merges painful. Add e.g. `rules/04-our-conventions.md` (and a matching tool-specific file) for things like "use our internal logger, not slog" or "errors must include the request ID".
3. **Keep additions short.** If a rule file gets longer than 100 lines, split it.

## Inspired by

This pack borrows from [`everything-claude-code`](https://github.com/affaan-m/everything-claude-code) — the structure of rules, the YAML-fronted markdown format, and the "skills as workflows" philosophy. ECC is broader, more powerful, and worth graduating to once you've outgrown this pack. If you want hooks, multi-agent orchestration, MCP server configs, or per-language rules beyond Go, start there.

## Contributing

Issues and PRs welcome — especially:
- Real before/after prompt examples that worked for you.
- Go idioms the rules miss.
- Tooling differences across editor versions.
- Adapter files for AI tools not yet listed.

See [`CONTRIBUTING.md`](CONTRIBUTING.md) before opening a PR.

The project's bias is **subtractive**: a PR that removes a rule is more likely to be merged than one that adds a rule. The whole point is to stay small.

## License

[MIT](LICENSE). Use it however you want.
