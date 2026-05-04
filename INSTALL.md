# Install

`lean-ai-for-go` is a directory of plain files. There is no installer, no package manager step. You copy the right files into your project, and your AI editor picks them up.

You can install for multiple tools in the same project — they don't conflict.

## TL;DR

```bash
# 1. Clone this repo somewhere local (one-time)
git clone https://github.com/your-org/lean-ai-for-go.git ~/code/lean-ai-for-go

# 2. In the project, run the snippet for your tool (see sections below)
```

Jump to your tool:
- [Cursor](#cursor)
- [Claude Code](#claude-code)
- [OpenAI Codex / OpenCode / Antigravity / Aider (AGENTS.md)](#openai-codex--opencode--antigravity--aider-agentsmd)
- [GitHub Copilot](#github-copilot)
- [Windsurf](#windsurf)
- [Cline](#cline)
- [Other tools](#other-tools)

---

## Cursor

Cursor auto-loads any file in `.cursor/rules/` on every prompt. Each `.mdc` file has YAML frontmatter that scopes it to the right files (the Go style rule only triggers on `*.go`, etc.).

```bash
mkdir -p .cursor/rules
cp -R ~/code/lean-ai-for-go/cursor/rules/. .cursor/rules/
```

**Verify:** open the project in Cursor, start a chat, and ask:

> "What rules are loaded for this project?"

The reply should mention "prime directives", and — if you have a Go file open — "Go style" and "testing".

**Cursor versions:** rules use the `.mdc` format with frontmatter (`description`, `globs`, `alwaysApply`). Supported in Cursor 0.45+. Older Cursor versions used a single `.cursorrules` file at repo root — if you're on an older version, concatenate the rule files into `.cursorrules` manually.

---

## Claude Code

Claude Code reads `CLAUDE.md` from the repo root on every session and exposes any file in `.claude/commands/` as a slash command.

```bash
cp ~/code/lean-ai-for-go/claude-code/CLAUDE.md ./CLAUDE.md
mkdir -p .claude/commands
cp ~/code/lean-ai-for-go/claude-code/commands/*.md .claude/commands/
```

**Verify:** run `claude` in the project directory and try:

```
/plan add a /healthz endpoint to main.go
```

You should see the assistant produce a plan (file list, risks, out-of-scope, open questions) instead of writing code.

**Available commands after install:**
- `/plan <task>` — produce a plan, no code, before any non-trivial change.
- `/simplify [target]` — review the most recent change (or a target) and remove unnecessary complexity.
- `/go-review [target]` — review pending Go changes against the rules; report issues, don't edit.

---

## OpenAI Codex / OpenCode / Antigravity / Aider (AGENTS.md)

These tools follow the [`AGENTS.md`](https://agents.md) standard — a single markdown file at the repo root that the agent reads on every session.

```bash
cp ~/code/lean-ai-for-go/agents-md/AGENTS.md ./AGENTS.md
```

**Verify per tool:**

- **OpenAI Codex CLI** (`codex`): start a session in the repo, ask "what conventions are loaded?". Codex echoes the AGENTS.md content.
- **OpenCode** (`opencode`): start a session and ask the same. Should reference the prime directives.
- **Google Antigravity**: open the project; the agent surfaces AGENTS.md in its context panel.
- **Aider**: AGENTS.md is auto-detected on recent versions. On older versions, run `aider --read AGENTS.md`.

**User-level (cross-project) install for Codex:** copy the same content to `~/.codex/AGENTS.md` to apply your rules to every project. The repo-level `AGENTS.md` overrides anything in the user-level file when both exist.

---

## GitHub Copilot

Copilot reads three things from `.github/`:

1. **`.github/copilot-instructions.md`** — repo-wide instructions, applied to every Copilot interaction.
2. **`.github/instructions/*.instructions.md`** — path-scoped instructions with frontmatter (similar to Cursor's `.mdc`):
   ```
   ---
   applyTo: "**/*.go"
   ---
   ```
3. **`.github/prompts/*.prompt.md`** — reusable chat prompts, invokable from the Copilot Chat input.

Install all three:

```bash
mkdir -p .github/instructions .github/prompts
cp ~/code/lean-ai-for-go/copilot/copilot-instructions.md .github/copilot-instructions.md
cp ~/code/lean-ai-for-go/copilot/instructions/*.instructions.md .github/instructions/
cp ~/code/lean-ai-for-go/copilot/prompts/*.prompt.md .github/prompts/
```

**Verify:**
- In Copilot Chat: ask "show me the loaded instructions" — it should reference the prime directives.
- In Copilot Chat: type `/plan` (or use the prompt picker). The `plan`, `simplify`, and `go-review` prompts should appear.

**Note:** path-scoped instructions and prompt files require a recent Copilot Chat version (VS Code Copilot Chat 0.20+, or the equivalent on JetBrains). The repo-wide `copilot-instructions.md` works on all versions.

---

## Windsurf

Windsurf (Codeium's IDE) reads `.windsurfrules` from the repo root.

```bash
cp ~/code/lean-ai-for-go/windsurf/.windsurfrules ./.windsurfrules
```

**Verify:** open the project in Windsurf, ask Cascade "what rules are loaded for this project?". Should reference the prime directives.

For finer scoping (per-file-type rules), Windsurf also supports memories — add them via the Cascade UI. The single-file `.windsurfrules` is the simplest baseline.

---

## Cline

Cline reads `.clinerules` from the repo root.

```bash
cp ~/code/lean-ai-for-go/cline/.clinerules ./.clinerules
```

**Verify:** open the project, start a Cline task. Ask "what rules are active?". Should reference the prime directives.

Cline also supports a `.clinerules/` *directory* with multiple files. If you prefer that layout, create the directory and split `.clinerules` into multiple files (e.g. `01-prime-directives.md`, `02-go-style.md`).

---

## Other tools

If your AI tool isn't listed:

1. Check whether it supports `AGENTS.md` — many newer tools do. If yes, use the [AGENTS.md install](#openai-codex--opencode--antigravity--aider-agentsmd).
2. If it reads from a custom file or directory, copy the contents of `rules/` (the markdown source of truth) and rename to whatever the tool expects.
3. Open an issue or PR with the format your tool uses, and we'll add an adapter directory.

---

## Updates

The rules will evolve. To pull updates:

```bash
cd ~/code/lean-ai-for-go && git pull
```

Then re-run the copy commands in any project that consumes the rules. The files are small enough that diffs are easy to review — `git diff` your project's rule files after the copy to see what changed.

If you've added project-specific rules, keep them in *separate* files (e.g., `04-our-conventions.mdc`) so updates don't overwrite them.

---

## Customizing for your project

The rules are intentionally generic Go. To add project-specific rules, don't edit the existing files — your changes will be overwritten on next sync. Instead, add new files alongside them.

For example, in Cursor:

```
.cursor/rules/
  prime-directives.mdc        # from this pack
  go-style.mdc                # from this pack
  testing.mdc                 # from this pack
  04-our-conventions.mdc      # yours — naming, internal libs, error wrapping style
  05-our-architecture.mdc     # yours — layering rules, where new code goes
```

For tools that use a single rules file (Windsurf, Cline, AGENTS.md), append a "## Project-specific conventions" section at the end of the file. Keep additions short; if a section grows past ~80 lines, it's probably trying to do too much.

---

## Per-developer overrides

If a developer wants their own additions on top of the project rules:

- **Cursor:** put them in `.cursor/rules/personal-*.mdc` and add the pattern to `.gitignore`.
- **Claude Code:** put them in `~/.claude/CLAUDE.md` (user-level memory, applies across all projects).
- **Codex:** put them in `~/.codex/AGENTS.md` (user-level, applies to every project).
- **Copilot:** GitHub account settings allow personal custom instructions in addition to repo ones.
- **Other tools:** consult your tool's docs for user-level rules; most support some form of them.

This keeps personal preferences out of the project repo while still letting them apply.

---

## Uninstall

Just delete the files written by the install snippets. Nothing else is changed; the pack writes nothing outside the listed paths.

```bash
# Cursor
rm -rf .cursor/rules

# Claude Code
rm -rf .claude/commands CLAUDE.md

# AGENTS.md tools
rm AGENTS.md

# Copilot
rm -rf .github/copilot-instructions.md .github/instructions .github/prompts

# Windsurf
rm .windsurfrules

# Cline
rm .clinerules
```
