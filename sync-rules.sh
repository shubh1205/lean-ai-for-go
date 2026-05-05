#!/usr/bin/env bash
# sync-rules.sh — regenerate all tool-specific rule files from templates/
#
# Usage: ./sync-rules.sh
#
# Edit files in templates/ then run this script. It rebuilds:
#   cursor/rules/*.mdc
#   claude-code/CLAUDE.md
#   agents-md/AGENTS.md
#   copilot/copilot-instructions.md
#   copilot/instructions/go-style.instructions.md
#   copilot/instructions/testing.instructions.md
#   windsurf/.windsurfrules
#   cline/.clinerules

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
T="$ROOT/templates"

# bump_headings: promote ## → ### so template subsections nest under a ## section header
bump_headings() {
    sed 's/^## /### /g'
}

echo "Syncing rule files from templates/..."

# ── Cursor (.cursor/rules/*.mdc) ──────────────────────────────────────────────
# Standalone files: frontmatter + H1 title + template content (headings unchanged)

{
cat <<'EOF'
---
description: Anti-overengineering rules. Apply to every change.
alwaysApply: true
---

# Prime Directives

EOF
cat "$T/prime-directives.md"
} > "$ROOT/cursor/rules/prime-directives.mdc"

{
cat <<'EOF'
---
description: Go coding style and idioms enforced in this repo.
globs:
  - "**/*.go"
  - "**/go.mod"
  - "**/go.sum"
alwaysApply: false
---

# Go Style

EOF
cat "$T/go-style.md"
} > "$ROOT/cursor/rules/go-style.mdc"

{
cat <<'EOF'
---
description: Go testing rules. Keep tests lean and behavior-focused.
globs:
  - "**/*_test.go"
alwaysApply: false
---

# Testing

EOF
cat "$T/testing.md"
} > "$ROOT/cursor/rules/testing.mdc"

{
cat <<'EOF'
---
description: When to plan vs just write code. Apply to every task.
alwaysApply: true
---

# Planning and Scope

EOF
cat "$T/planning-scope.md"
} > "$ROOT/cursor/rules/planning-scope.mdc"

{
cat <<'EOF'
---
description: Self-review checklist before every response. Apply to every change.
alwaysApply: true
---

# Self-Review

EOF
cat "$T/self-review.md"
} > "$ROOT/cursor/rules/self-review.mdc"

echo "  ✓ cursor/rules/"

# ── Claude Code (claude-code/CLAUDE.md) ───────────────────────────────────────
# Single merged file: H2 sections, template subsections bumped to H3

{
cat <<'EOF'
# Project Conventions

This file is loaded into every Claude Code session in this repo. Follow it on every change.

## Prime directives (anti-overengineering)

EOF
cat "$T/prime-directives.md"
cat <<'EOF'

## Go style (this is a Go service)

EOF
bump_headings < "$T/go-style.md"
cat <<'EOF'

## Testing

EOF
bump_headings < "$T/testing.md"
cat <<'EOF'

## Planning and scope

EOF
cat "$T/planning-scope.md"
cat <<'EOF'

## Reviewing your own output before responding

EOF
cat "$T/self-review.md"
} > "$ROOT/claude-code/CLAUDE.md"

echo "  ✓ claude-code/CLAUDE.md"

# ── Agents.md (agents-md/AGENTS.md) ───────────────────────────────────────────
# Same structure as CLAUDE.md, different intro paragraph

{
cat <<'EOF'
# Project Conventions

This file is loaded by AGENTS.md-aware tools (OpenAI Codex, OpenCode, Aider, Google Antigravity, and others) on every session. Follow it on every change.

## Prime directives (anti-overengineering)

EOF
cat "$T/prime-directives.md"
cat <<'EOF'

## Go style (this is a Go service)

EOF
bump_headings < "$T/go-style.md"
cat <<'EOF'

## Testing

EOF
bump_headings < "$T/testing.md"
cat <<'EOF'

## Planning and scope

EOF
cat "$T/planning-scope.md"
cat <<'EOF'

## Reviewing your own output before responding

EOF
cat "$T/self-review.md"
} > "$ROOT/agents-md/AGENTS.md"

echo "  ✓ agents-md/AGENTS.md"

# ── GitHub Copilot ────────────────────────────────────────────────────────────
# Main instructions: prime directives + planning/scope + self-review + references
# Per-language files: frontmatter + H1 title + template content

{
cat <<'EOF'
# Repository Instructions for GitHub Copilot

These instructions apply to every Copilot interaction in this repository (chat, inline completions, agent mode). Follow them on every change.

## Prime directives (anti-overengineering)

EOF
cat "$T/prime-directives.md"
cat <<'EOF'

## Planning and scope

EOF
cat "$T/planning-scope.md"
cat <<'EOF'

## Reviewing your own output before responding

EOF
cat "$T/self-review.md"
cat <<'EOF'

## Language-specific guidance

- Go style rules apply when editing `*.go`, `go.mod`, or `go.sum`. See `.github/instructions/go-style.instructions.md`.
- Test rules apply when editing `*_test.go`. See `.github/instructions/testing.instructions.md`.
EOF
} > "$ROOT/copilot/copilot-instructions.md"

{
cat <<'EOF'
---
applyTo: "**/*.go,**/go.mod,**/go.sum"
---

# Go Style

EOF
cat "$T/go-style.md"
} > "$ROOT/copilot/instructions/go-style.instructions.md"

{
cat <<'EOF'
---
applyTo: "**/*_test.go"
---

# Testing

EOF
cat "$T/testing.md"
} > "$ROOT/copilot/instructions/testing.instructions.md"

echo "  ✓ copilot/"

# ── Windsurf (.windsurfrules) ──────────────────────────────────────────────────

{
cat <<'EOF'
# Project Rules — Windsurf

These rules apply to every interaction in this repository. Follow them on every change.

## Prime directives (anti-overengineering)

EOF
cat "$T/prime-directives.md"
cat <<'EOF'

## Go style

EOF
bump_headings < "$T/go-style.md"
cat <<'EOF'

## Testing

EOF
bump_headings < "$T/testing.md"
cat <<'EOF'

## Planning and scope

EOF
cat "$T/planning-scope.md"
cat <<'EOF'

## Self-review before responding

EOF
cat "$T/self-review.md"
} > "$ROOT/windsurf/.windsurfrules"

echo "  ✓ windsurf/.windsurfrules"

# ── Cline (.clinerules) ────────────────────────────────────────────────────────

{
cat <<'EOF'
# Project Rules — Cline

These rules apply to every interaction in this repository. Follow them on every change.

## Prime directives (anti-overengineering)

EOF
cat "$T/prime-directives.md"
cat <<'EOF'

## Go style

EOF
bump_headings < "$T/go-style.md"
cat <<'EOF'

## Testing

EOF
bump_headings < "$T/testing.md"
cat <<'EOF'

## Planning and scope

EOF
cat "$T/planning-scope.md"
cat <<'EOF'

## Self-review before responding

EOF
cat "$T/self-review.md"
} > "$ROOT/cline/.clinerules"

echo "  ✓ cline/.clinerules"

# ── Claude Code commands (claude-code/commands/) ──────────────────────────────
# Frontmatter is injected here; template body uses $ARGUMENTS as the arg placeholder.

{
cat <<'EOF'
---
description: Plan a change before coding, then surface any Go concepts the plan uses so you can understand them before implementation. Use when the change spans 3+ files or crosses package boundaries.
---

EOF
cat "$T/commands/lean-plan.md"
} > "$ROOT/claude-code/commands/lean-plan.md"

{
cat <<'EOF'
---
description: Review the most recent change (or a specified file) and remove unnecessary complexity. Surfaces removed patterns with a brief explanation so you understand why simpler wins here. Does not add features.
---

EOF
cat "$T/commands/lean-simplify.md"
} > "$ROOT/claude-code/commands/lean-simplify.md"

{
cat <<'EOF'
---
description: Review pending Go changes against this repo's style and the prime directives. Reports issues; does not edit unless asked. Surfaces any advanced Go concepts in the diff so you can appreciate what the code is doing.
---

EOF
cat "$T/commands/lean-review.md"
} > "$ROOT/claude-code/commands/lean-review.md"

echo "  ✓ claude-code/commands/"

# ── Copilot prompts (copilot/prompts/) ────────────────────────────────────────
# Same template body; mode:agent frontmatter added, $ARGUMENTS replaced with
# ${input:<name>:<hint>} per-command syntax for the Copilot prompt picker.

{
cat <<'EOF'
---
mode: agent
description: Plan a change before coding, then surface any Go concepts the plan uses so you can understand them before implementation. Use when the change spans 3+ files or crosses package boundaries.
---

EOF
sed 's/\$ARGUMENTS/${input:task:Describe the change}/g' "$T/commands/lean-plan.md"
} > "$ROOT/copilot/prompts/lean-plan.prompt.md"

{
cat <<'EOF'
---
mode: agent
description: Review the most recent change and remove unnecessary complexity. Surfaces removed patterns with a brief explanation so you understand why simpler wins here. Does not add features.
---

EOF
sed 's|\$ARGUMENTS|${input:target:File or area to simplify (leave empty for most recent change)}|g' \
    "$T/commands/lean-simplify.md"
} > "$ROOT/copilot/prompts/lean-simplify.prompt.md"

{
cat <<'EOF'
---
mode: agent
description: Review pending Go changes against repo style and the prime directives. Reports issues; does not edit. Surfaces advanced concepts in the diff so you can appreciate what the code is doing.
---

EOF
sed 's|\$ARGUMENTS|${input:target:File or diff to review (leave empty for staged + unstaged changes)}|g' \
    "$T/commands/lean-review.md"
} > "$ROOT/copilot/prompts/lean-review.prompt.md"

echo "  ✓ copilot/prompts/"
echo ""
echo "Done. All tool rule files are up to date."
