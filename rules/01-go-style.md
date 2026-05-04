# Go Style

Applies to all `.go` files. These are the rules the AI must follow when generating or modifying Go code in this repo.

## Formatting

- `gofmt` and `goimports` are mandatory. Don't argue formatting.
- Tabs for indentation, as Go expects.
- Run `go vet` mentally — no shadowed variables, no unreachable code.

## Errors

- Return errors; do not panic in library code.
- Wrap with `%w` only when the caller benefits from unwrapping or when the added context is non-obvious. `fmt.Errorf("create user %s: %w", id, err)` is good. `fmt.Errorf("error: %w", err)` is noise — drop the wrap.
- Don't wrap an error and then immediately log it at the same site. Pick one.
- Sentinel errors (`var ErrNotFound = errors.New(...)`) only when callers need to switch on them.

## Interfaces

- **Accept interfaces, return structs.** Standard Go advice.
- **Define interfaces at the point of consumption, not at the point of implementation.** If only one package needs the abstraction, define it there.
- **Don't create an interface until you have 2+ implementations.** A "for testing" mock does not count as a second implementation if it has no production analogue — use a fake struct or a real test dependency instead.
- Keep interfaces small (1-3 methods is the sweet spot).

## Structs

- Group fields by purpose, not alphabetically.
- Don't add JSON/DB tags speculatively. Tag a field when it's actually serialized.
- Constructors (`NewFoo`) only when initialization is non-trivial. A struct with public fields and zero-value defaults doesn't need one.

## Concurrency

- Don't add goroutines unless the prompt asks for concurrent behavior.
- Every goroutine needs a clear lifetime — a `context.Context` it watches, or a `WaitGroup` that joins it.
- Channels are for communication, not signaling — prefer `sync.WaitGroup` / `context.Context` for coordination.
- No `time.Sleep` in production code. If you need to wait for something, use a channel, signal, or context.

## Imports & packages

- Standard library first, then third-party, then local — separated by blank lines (goimports does this).
- Don't create new packages on your own initiative. Adding code to an existing file is almost always correct; a new package needs a reason in the prompt.
- No circular imports. If you hit one, the design is wrong; surface it.

## Naming

- Exported names use `PascalCase`; unexported use `camelCase`.
- Acronyms stay uppercase: `userID`, `httpClient`, `URL`.
- Receiver names are short (1-3 letters) and consistent across all methods of a type.
- No Hungarian notation, no `I` prefix on interfaces, no `Impl` suffix on structs.

## What we don't do

- No `init()` functions for application logic. Use explicit setup in `main`.
- No global mutable state outside `main.go` and clearly-scoped framework code.
- No reflection unless there's no other way (and then comment why).
- No `interface{}` / `any` in public APIs unless required by an external interface.
- No generics unless the call site is type-required to use them. Don't generic-ify existing concrete code.
