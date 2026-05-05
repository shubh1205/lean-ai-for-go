---
description: Review pending Go changes against this repo's style and the prime directives. Reports issues; does not edit unless asked. Surfaces any advanced Go concepts in the diff so you can appreciate what the code is doing.
---

Target: $ARGUMENTS (if empty, review the staged + unstaged Go changes via `git diff`)

Review pass, in this order. Report findings as a numbered list. Do not edit unless I ask.

## 1. Scope and bloat

- Does the diff touch only what the task required?
- Any new files, packages, or interfaces? Was each one necessary, or could the change have lived
  in an existing file?
- Any drive-by refactors, renames, or import reorganization that weren't part of the task?

## 2. Go idioms

- Errors: wrapped with useful context, or just noise? Wrapped *and* logged at the same site?
- Interfaces: defined at the point of consumption? More than one implementation?
- Constructors only when initialization is non-trivial?
- Any `init()` doing application logic, or new global mutable state?
- Any `interface{}` / `any` in public APIs that could be concrete?
- Any goroutines without a clear lifetime?

## 3. Testing

- Tests describe behavior in their names?
- Table-driven where applicable, with each case testing something distinct?
- Mocking our own code where a real or fake dep would do?
- Tests that just assert `err == nil` without testing real behavior?

## 4. Comments and noise

- Comments that restate the code, reference tickets, or doc-comment private helpers — flag them.

## 5. Match to codebase

- Does the new code follow patterns already in this repo? Name a similar file if it doesn't.

## Output

For each issue: file, line range, what's wrong, the smallest fix. No fixes applied unless I say so.

End with one of:

- ✅ Looks good — ship it.
- ⚠️ Minor — fix N issues, then ship.
- ❌ Re-prompt — the diff is doing more than the task required. Suggest a tighter prompt.

## Concept spotlight

After the verdict, scan the diff for non-trivial Go concepts. For each one:

> **[Concept]** — one sentence: what it is and why it is used in this diff.

If there is a simpler or more idiomatic alternative to any pattern in the diff, note it:

> **Alternative for [pattern]:** [alternative] — tradeoff vs what's here.

If no noteworthy concepts appear, omit this section entirely.
