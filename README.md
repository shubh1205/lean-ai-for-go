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

```text
lean-ai-for-go/
├── templates/                Source of truth — edit these to change rules
│   ├── prime-directives.md        Anti-overengineering rules (condensed)
│   ├── go-style.md                Go idioms enforced
│   ├── testing.md                 Testing rules
│   ├── planning-scope.md          When to plan vs just write code
│   ├── self-review.md             Pre-response checklist for AI
│   └── commands/                  Slash-command bodies (generated into claude-code/ and copilot/)
│       ├── lean-plan.md               Plan + concept spotlight + learning offer
│       ├── lean-simplify.md           Simplify + explain what was removed and why
│       └── lean-review.md             Review + surface advanced concepts in the diff
│
├── rules/                    Verbose developer reference — the why behind each rule
│   ├── 00-prime-directives.md     Full explanation with enforcement guidance
│   ├── 01-go-style.md             Annotated Go idioms
│   ├── 02-testing.md              Testing guide with examples
│   └── 03-prompting.md            How to prompt + how to review AI output
│
├── sync-rules.sh             Regenerates all tool files from templates/
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

**Two-folder model:**

- Edit `templates/` to change what AI tools see. Run `./sync-rules.sh` (or just commit — the pre-commit hook does it automatically) and all tool-specific files are regenerated. Slash-command bodies live in `templates/commands/`; `sync-rules.sh` injects the right frontmatter and variable syntax for each tool.
- Read `rules/` to understand why a rule exists. The verbose files explain the reasoning and failure modes. They are not compiled into tool files.

## Install (one-liner, per tool)

From the root of your Go project, run:

```bash
curl -sSL https://raw.githubusercontent.com/your-org/lean-ai-for-go/main/install.sh | bash -s -- claude-code
```

Replace `claude-code` with one or more of: `cursor`, `claude-code`, `agents-md`, `copilot`, `windsurf`, `cline`. You can install several tools in one go:

```bash
curl -sSL https://raw.githubusercontent.com/your-org/lean-ai-for-go/main/install.sh | bash -s -- cursor copilot
```

Pin to a tag for reproducible installs:

```bash
curl -sSL https://raw.githubusercontent.com/your-org/lean-ai-for-go/v1/install.sh | bash -s -- --ref=v1 claude-code
```

The installer prints the `.gitignore` lines to add when it finishes — see the note below on why.

> **Add the installed files to your project's `.gitignore`.** The installed files are a local mirror of `lean-ai-for-go`, not your project's code — this repo is the source of truth, and each developer installs them in their own checkout. See [INSTALL.md → Add the imported files to `.gitignore`](INSTALL.md#add-the-imported-files-to-gitignore) for the exact entries per tool.

For air-gapped installs, manual `cp` snippets, version pinning, verification steps, and per-developer overrides, see [`INSTALL.md`](INSTALL.md).

## The six things to internalize

If you only remember six things from this pack:

1. **"Smallest change that does X"** — say this in every prompt. It's the magic phrase against bloat.
2. **No new abstractions unless the prompt asked.** No interfaces, no packages, no factories on the AI's initiative.
3. **Edit files in place. Don't rewrite them.** Reject diffs that touch unrelated code.
4. **Plan only when work spans 3+ files.** Use `/lean-plan` — it plans, then names any non-trivial Go concepts the plan uses and offers to explain them before coding starts.
5. **If you can't explain the AI's code line-by-line, don't merge it.** The AI appends a **Concept note** to every diff that uses goroutines, sync primitives, generics, or other non-obvious patterns — read it before accepting.
6. **Lean output ≠ shallow output.** The rules keep code small; the concept spotting ensures you understand what you're merging.

## Compatibility

| Tool | Status | How rules are loaded |
| --- | --- | --- |
| **Cursor** (0.45+) | ✅ Tested | `.cursor/rules/*.mdc` with `applyTo`/`globs` frontmatter |
| **Claude Code** | ✅ Tested | `CLAUDE.md` at repo root + `.claude/commands/*.md` slash commands |
| **OpenAI Codex CLI** | ✅ Supported | `AGENTS.md` at repo root |
| **OpenCode** | ✅ Supported | `AGENTS.md` at repo root |
| **Google Antigravity** | ✅ Supported | `AGENTS.md` at repo root (cross-tool standard) |
| **Aider** | ✅ Supported | `AGENTS.md` at repo root, or `aider --read AGENTS.md` |
| **GitHub Copilot** | ✅ Supported | `.github/copilot-instructions.md` + `.github/instructions/` + `.github/prompts/` |
| **Windsurf** (Codeium) | ✅ Supported | `.windsurfrules` at repo root |
| **Cline** | ✅ Supported | `.clinerules` at repo root |
| **Continue.dev / Zed / others** | 🟡 Likely works | Most tools accept `AGENTS.md` or a markdown rules file — point them at `agents-md/AGENTS.md` or `templates/` |

If your tool isn't listed and uses a different rule format, point it at `templates/` (the condensed source) or open an issue.

## What this is *not*

- **Not a plugin.** Nothing to install in any of the supported tools beyond copying files. No npm package, no marketplace entry.
- **Not language-agnostic.** The Go rules assume Go. The prime directives apply to any language; everything else is Go-specific.
- **Not a replacement for code review.** It reduces obvious AI bloat. Humans still merge.
- **Not a coverage of every rule you might want.** Add your own. See [Customizing](#customizing).

## Customizing

The rules are designed to be edited. Suggested approach:

1. **Fork or vendor.** Either fork this repo or copy the relevant tool directories directly into your codebase under a path you control.
2. **Edit `templates/` only.** Don't edit tool-specific files directly — your changes will be overwritten by the next `./sync-rules.sh` run. Add project-specific rules to `templates/` or create new template files and wire them into `sync-rules.sh`.
3. **Keep additions short.** If a template file gets longer than 100 lines, split it.

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
