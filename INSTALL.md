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

The rule files use specific names (`prime-directives.mdc`, `go-style.mdc`, `testing.mdc`, `planning-scope.mdc`, `self-review.mdc`). If you already have files with any of those names, the copy below will overwrite them — check first and merge manually if needed.

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

If `CLAUDE.md` already exists in your project, the snippet below appends to it rather than replacing it. Your existing content is preserved.

```bash
if [ -f ./CLAUDE.md ]; then
  printf '\n\n---\n\n' >> ./CLAUDE.md
  cat ~/code/lean-ai-for-go/claude-code/CLAUDE.md >> ./CLAUDE.md
  echo "Appended to existing CLAUDE.md"
else
  cp ~/code/lean-ai-for-go/claude-code/CLAUDE.md ./CLAUDE.md
  echo "Created CLAUDE.md"
fi
mkdir -p .claude/commands
cp ~/code/lean-ai-for-go/claude-code/commands/*.md .claude/commands/
```

**Verify:** run `claude` in the project directory and try:

```text
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

If `AGENTS.md` already exists in your project, the snippet below appends to it rather than replacing it.

```bash
if [ -f ./AGENTS.md ]; then
  printf '\n\n---\n\n' >> ./AGENTS.md
  cat ~/code/lean-ai-for-go/agents-md/AGENTS.md >> ./AGENTS.md
  echo "Appended to existing AGENTS.md"
else
  cp ~/code/lean-ai-for-go/agents-md/AGENTS.md ./AGENTS.md
  echo "Created AGENTS.md"
fi
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

   ```text
   ---
   applyTo: "**/*.go"
   ---
   ```

3. **`.github/prompts/*.prompt.md`** — reusable chat prompts, invokable from the Copilot Chat input.

If `.github/copilot-instructions.md` already exists, the snippet appends to it. The per-language instruction files use specific names (`go-style.instructions.md`, `testing.instructions.md`) — if you already have files with those names, the copy will overwrite them; merge manually if needed.

```bash
mkdir -p .github/instructions .github/prompts
if [ -f .github/copilot-instructions.md ]; then
  printf '\n\n---\n\n' >> .github/copilot-instructions.md
  cat ~/code/lean-ai-for-go/copilot/copilot-instructions.md >> .github/copilot-instructions.md
  echo "Appended to existing copilot-instructions.md"
else
  cp ~/code/lean-ai-for-go/copilot/copilot-instructions.md .github/copilot-instructions.md
  echo "Created copilot-instructions.md"
fi
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

If `.windsurfrules` already exists in your project, the snippet below appends to it rather than replacing it.

```bash
if [ -f ./.windsurfrules ]; then
  printf '\n\n---\n\n' >> ./.windsurfrules
  cat ~/code/lean-ai-for-go/windsurf/.windsurfrules >> ./.windsurfrules
  echo "Appended to existing .windsurfrules"
else
  cp ~/code/lean-ai-for-go/windsurf/.windsurfrules ./.windsurfrules
  echo "Created .windsurfrules"
fi
```

**Verify:** open the project in Windsurf, ask Cascade "what rules are loaded for this project?". Should reference the prime directives.

For finer scoping (per-file-type rules), Windsurf also supports memories — add them via the Cascade UI. The single-file `.windsurfrules` is the simplest baseline.

---

## Cline

Cline reads `.clinerules` from the repo root.

If `.clinerules` already exists in your project, the snippet below appends to it rather than replacing it.

```bash
if [ -f ./.clinerules ]; then
  printf '\n\n---\n\n' >> ./.clinerules
  cat ~/code/lean-ai-for-go/cline/.clinerules >> ./.clinerules
  echo "Appended to existing .clinerules"
else
  cp ~/code/lean-ai-for-go/cline/.clinerules ./.clinerules
  echo "Created .clinerules"
fi
```

**Verify:** open the project, start a Cline task. Ask "what rules are active?". Should reference the prime directives.

Cline also supports a `.clinerules/` *directory* with multiple files. If you prefer that layout, create the directory and split `.clinerules` into multiple files (e.g. `01-prime-directives.md`, `02-go-style.md`).

---

## Other tools

If your AI tool isn't listed:

1. Check whether it supports `AGENTS.md` — many newer tools do. If yes, use the [AGENTS.md install](#openai-codex--opencode--antigravity--aider-agentsmd).
2. If it reads from a custom file or directory, copy the files from `templates/` and rename them to whatever the tool expects. The templates are plain markdown with no tool-specific formatting.
3. Open an issue or PR with the format your tool uses, and we'll add an adapter directory.

---

## Updates

The rules will evolve. To pull updates:

```bash
cd ~/code/lean-ai-for-go && git pull
```

Then re-run the install snippet for your tool. For single-file tools where you appended content, re-running will append again — remove the previous lean-ai-for-go block first, then re-run, to avoid duplicates. A clean update looks like:

```bash
# Example for CLAUDE.md — remove old block, append new one
# The separator line (---) marks where the lean-ai-for-go section starts
```

If you've added project-specific rules, keep them in *separate* files (e.g., `04-our-conventions.mdc`) so updates don't overwrite them.

---

## Customizing for your project

The rules are intentionally generic Go. To add project-specific rules, don't edit the installed files — your changes may be overwritten on the next update. Instead, add new files alongside them.

For example, in Cursor:

```text
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

For tools where the install **created** the file, delete it entirely. For tools where the install **appended** to an existing file, remove the lean-ai-for-go block (everything from the `---` separator to the end of the file, or between separators if you have content below it).

```bash
# Cursor — always a fresh copy, safe to delete
rm -rf .cursor/rules

# Claude Code — delete commands; edit or delete CLAUDE.md depending on whether you appended
rm -rf .claude/commands
# If CLAUDE.md was created by this pack: rm CLAUDE.md
# If CLAUDE.md already existed: remove the appended section manually

# AGENTS.md tools
# If AGENTS.md was created by this pack: rm AGENTS.md
# If AGENTS.md already existed: remove the appended section manually

# Copilot — delete instruction and prompt files; edit or delete copilot-instructions.md
rm -f .github/instructions/go-style.instructions.md \
      .github/instructions/testing.instructions.md \
      .github/prompts/plan.prompt.md \
      .github/prompts/simplify.prompt.md \
      .github/prompts/go-review.prompt.md
# If copilot-instructions.md was created by this pack: rm .github/copilot-instructions.md
# If copilot-instructions.md already existed: remove the appended section manually

# Windsurf
# If .windsurfrules was created by this pack: rm .windsurfrules
# If .windsurfrules already existed: remove the appended section manually

# Cline
# If .clinerules was created by this pack: rm .clinerules
# If .clinerules already existed: remove the appended section manually
```
