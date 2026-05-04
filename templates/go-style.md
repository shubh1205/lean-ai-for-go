## Formatting

- `gofmt` and `goimports` are mandatory.
- Tabs for indentation. Imports grouped: stdlib, third-party, local.

## Errors

- Return errors; do not panic in library code.
- Wrap with `%w` only when the caller benefits from unwrapping or when added context is non-obvious. Drop wraps that just say "error: %w".
- Don't wrap and log at the same site. Pick one.
- Sentinel errors only when callers need to switch on them.

## Interfaces

- Accept interfaces, return structs.
- Define interfaces at the point of consumption, not implementation.
- Don't create an interface until there are 2+ implementations. A test mock alone is not a second implementation — use a fake struct or real test dep.
- Keep interfaces small (1-3 methods).

## Structs

- Group fields by purpose, not alphabetically.
- No JSON/DB tags speculatively. Tag a field when it's actually serialized.
- Constructors only when initialization is non-trivial.

## Concurrency

- Don't add goroutines unless the prompt asks for concurrent behavior.
- Every goroutine has a clear lifetime — `context.Context` or `WaitGroup`.
- No `time.Sleep` in production code.

## Packages & imports

- Don't create new packages on your own initiative.
- Adding to an existing file is almost always correct.
- No circular imports — surface the design problem, don't bandage it.

## Naming

- Acronyms stay uppercase: `userID`, `httpClient`, `URL`.
- Receiver names short (1-3 letters), consistent across methods of a type.
- No `I` prefix on interfaces, no `Impl` suffix on structs.

## What we don't do

- No `init()` for application logic.
- No global mutable state outside `main.go`.
- No reflection unless required (and comment why).
- No `interface{}` / `any` in public APIs unless required.
- No generics on existing concrete code.
