---
description: Review the most recent change (or a specified file) and remove unnecessary complexity. Does not add features.
---

Target: $ARGUMENTS (if empty, review the most recent change in the conversation)

Look for and remove:

1. **Premature abstractions** — interfaces with one implementation, factories with one product, packages with one consumer. Inline them.
2. **Unused parameters and return values.** Drop them.
3. **Speculative error handling** — wrapping errors with "error: %w", nil-checks for values that can't be nil, validation already done by the caller. Remove.
4. **Drive-by additions** — comments, logging, metrics, or struct fields the original task didn't require. Remove.
5. **Redundant indirection** — helper functions used once that obscure the logic. Inline.
6. **Style mismatches** — code that doesn't match the rest of this repo's style. Match the existing patterns.

Constraints:

- Do not add features.
- Do not change observable behavior.
- Do not rename anything that other files reference, unless you also update those references.
- If you can't simplify safely, say so and stop. Don't invent simplifications.

Output a diff. Then list, in one line each, what you removed and why.
