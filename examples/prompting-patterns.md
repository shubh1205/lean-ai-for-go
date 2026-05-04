# Prompting Patterns: Before / After

Three real Go tasks. The "before" prompts are what most developers type. The "after" prompts produce code you'll actually want to merge. Both prompts are aimed at Cursor or Claude Code on a Go service.

---

## Example 1 — Add input validation

**Task:** A `CreateOrder` HTTP handler should reject orders with `Quantity <= 0` and return 400.

### Before (produces bloat)

> "Add validation to the CreateOrder handler."

What you'll get:
- A new `internal/validation/` package.
- A `Validator` interface with one implementation.
- An `OrderValidator` struct with rules registered in `init()`.
- Three test files, two of which mock the validator.
- A 200-line diff for what should be 4 lines.

### After (produces a clean diff)

> "In `src/handlers/order.go`, in `CreateOrder`, return `c.JSON(400, echo.Map{\"error\": \"quantity must be positive\"})` if `req.Quantity <= 0`. Add a single guard at the top of the function. No new files, no validator package, no helper. Match the style of the existing 400 returns in this file."

What you'll get:
- 4-line change in one function.
- One test case added to the existing `_test.go`.
- Done.

**The fix in the prompt:** "single guard at the top", "no new files", "match the style of the existing 400 returns in this file".

---

## Example 2 — Add a retry to a downstream call

**Task:** The order service calls a payment gateway that occasionally returns 503. Retry up to 3 times with exponential backoff.

### Before (produces architecture)

> "Make the payment gateway call resilient."

What you'll get:
- A new `pkg/resilience/` with a `Retrier` interface, `ExponentialBackoff` struct, `CircuitBreaker`, `RetryPolicy` configurable via options.
- Generic `func Do[T any](ctx context.Context, op func() (T, error), opts ...Option) (T, error)`.
- 600 lines, including tests for the retry library itself.

### After

> "In `src/clients/payment.go`, in `Charge`, wrap the existing gateway HTTP call in a retry loop: up to 3 attempts, sleep 100ms / 200ms / 400ms between attempts, only retry on 503. On non-503 errors return immediately. Inline the retry — no new package, no Retrier type. Use `time.Sleep` with the existing `ctx` for cancellation."

What you'll get:
- ~15 lines added to `Charge`.
- One unit test using a fake `http.Handler` that returns 503 twice then 200.

**The fix:** named the file and function, gave the exact retry parameters, banned the abstraction explicitly, told it where the test should live.

---

## Example 3 — Investigate a bug

**Task:** Order creation occasionally double-saves an order. Figure out why.

### Before (produces a rewrite)

> "Fix the double-save bug in CreateOrder."

What you'll get: an aggressive rewrite of `CreateOrder` with a "transaction wrapper", "idempotency key", and a new `OrderRepository` interface. The diff is 400 lines and the bug may or may not actually be fixed.

### After (produces a diagnosis)

> "There's a bug where `CreateOrder` occasionally writes the order twice. Don't write any code yet. Read `src/handlers/order.go` and `src/repository/order.go`. Tell me: (1) what the call path is from request to DB write, (2) where a retry, double-call, or transaction quirk could cause two writes, (3) what you'd need to confirm before fixing. List 2-3 candidate root causes ranked by likelihood."

What you'll get: an actual diagnosis. Then, only after agreeing on the cause, a 5-line fix.

**The fix:** "don't write any code yet" + "list candidates ranked by likelihood". Forces investigation before action.

---

## Pattern summary

Three things show up in every good prompt:

1. **A specific location** — file, function, line range.
2. **An explicit ceiling on scope** — "single guard", "inline only", "no new files", "edit in place".
3. **An anchor to existing code** — "match the style of X" or "this should look like Y".

When you skip any of these, the AI has to guess. It guesses wrong in the direction of more code, more abstraction, more "production-readiness". The prompt patterns above remove the guessing.
