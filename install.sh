#!/usr/bin/env bash
# install.sh — install lean-ai-for-go rules into the current project.
#
# Usage:
#   install.sh <tool> [<tool>...]
#   install.sh --list
#   install.sh --ref=<branch-or-tag> <tool>
#
# Tools: cursor, claude-code, agents-md, copilot, windsurf, cline
#
# Environment overrides:
#   LEAN_AI_REPO  owner/repo to fetch from (default: shubh1205/lean-ai-for-go)
#   LEAN_AI_REF   branch or tag           (default: main)
#
# After install, the script prints the .gitignore lines to add to your project.

set -euo pipefail

REPO="${LEAN_AI_REPO:-shubh1205/lean-ai-for-go}"
REF="${LEAN_AI_REF:-main}"
TOOLS=()

list_tools() {
    cat <<'EOF'
Supported tools:
  cursor       → .cursor/rules/
  claude-code  → CLAUDE.md + .claude/commands/
  agents-md    → AGENTS.md (Codex, OpenCode, Antigravity, Aider)
  copilot      → .github/copilot-instructions.md + .github/instructions/ + .github/prompts/
  windsurf     → .windsurfrules
  cline        → .clinerules
EOF
}

usage() {
    cat <<'EOF'
Usage: install.sh <tool> [<tool>...]
       install.sh --list
       install.sh --ref=<branch-or-tag> <tool>

Multiple tools can be installed in one invocation.
Override the source with LEAN_AI_REPO=<owner/repo> or LEAN_AI_REF=<branch-or-tag>.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --list) list_tools; exit 0 ;;
        -h|--help) usage; exit 0 ;;
        --ref=*) REF="${1#--ref=}"; shift ;;
        --ref) REF="$2"; shift 2 ;;
        -*) echo "Unknown flag: $1" >&2; usage; exit 2 ;;
        *) TOOLS+=("$1"); shift ;;
    esac
done

if [[ ${#TOOLS[@]} -eq 0 ]]; then
    usage; exit 2
fi

for t in "${TOOLS[@]}"; do
    case "$t" in
        cursor|claude-code|agents-md|copilot|windsurf|cline) ;;
        *) echo "Unknown tool: $t (run with --list to see supported tools)" >&2; exit 2 ;;
    esac
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

URL="https://github.com/${REPO}/archive/${REF}.tar.gz"
echo "Downloading ${REPO}@${REF}..."
curl -fsSL "$URL" | tar -xz -C "$TMP"

SRC="$(find "$TMP" -maxdepth 1 -mindepth 1 -type d | head -n 1)"
[[ -d "$SRC" ]] || { echo "Failed to locate extracted source" >&2; exit 1; }

append_or_create() {
    local src="$1" dst="$2"
    if [[ -f "$dst" ]]; then
        printf '\n\n---\n\n' >> "$dst"
        cat "$src" >> "$dst"
        echo "  Appended to existing $dst"
    else
        cp "$src" "$dst"
        echo "  Created $dst"
    fi
}

GITIGNORE=()
for t in "${TOOLS[@]}"; do
    echo "→ $t"
    case "$t" in
        cursor)
            mkdir -p .cursor/rules
            cp -R "$SRC"/cursor/rules/. .cursor/rules/
            GITIGNORE+=(".cursor/rules/")
            ;;
        claude-code)
            append_or_create "$SRC/claude-code/CLAUDE.md" "./CLAUDE.md"
            mkdir -p .claude/commands
            cp "$SRC"/claude-code/commands/*.md .claude/commands/
            GITIGNORE+=("CLAUDE.md" ".claude/commands/")
            ;;
        agents-md)
            append_or_create "$SRC/agents-md/AGENTS.md" "./AGENTS.md"
            GITIGNORE+=("AGENTS.md")
            ;;
        copilot)
            mkdir -p .github/instructions .github/prompts
            append_or_create "$SRC/copilot/copilot-instructions.md" ".github/copilot-instructions.md"
            cp "$SRC"/copilot/instructions/*.instructions.md .github/instructions/
            cp "$SRC"/copilot/prompts/*.prompt.md .github/prompts/
            GITIGNORE+=(".github/copilot-instructions.md" ".github/instructions/" ".github/prompts/")
            ;;
        windsurf)
            append_or_create "$SRC/windsurf/.windsurfrules" "./.windsurfrules"
            GITIGNORE+=(".windsurfrules")
            ;;
        cline)
            append_or_create "$SRC/cline/.clinerules" "./.clinerules"
            GITIGNORE+=(".clinerules")
            ;;
    esac
done

echo
echo "Done. Add these lines to your project's .gitignore:"
echo
echo "# lean-ai-for-go — installed locally per developer; do not commit"
printf '%s\n' "${GITIGNORE[@]}"
