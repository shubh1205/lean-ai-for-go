# Testing

Applies to `*_test.go` files. The AI's default test output is bloated — too many cases, too much setup, mocks for things that don't need mocking. These rules cut it down.

## What to test

- Public API behavior. The contract a caller depends on.
- Edge cases that have actually caused bugs (or that the prompt called out).
- Error paths that callers will actually handle.

## What NOT to test

- Private helpers. Test them indirectly through the public function that uses them.
- Trivial getters, setters, or pass-through methods.
- Standard library behavior. If `json.Marshal` works, don't test that it works.
- Code paths that "could happen" but have no real-world trigger.

## Test layout

- One `_test.go` file per source file, in the same package (`package foo`, not `package foo_test`) unless you need to test only the exported surface.
- Table-driven tests by default:

```go
func TestParseDate(t *testing.T) {
    tests := []struct {
        name    string
        in      string
        want    time.Time
        wantErr bool
    }{
        {"iso", "2026-04-29", mustTime("2026-04-29"), false},
        {"empty", "", time.Time{}, true},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := ParseDate(tt.in)
            if (err != nil) != tt.wantErr {
                t.Fatalf("err = %v, wantErr %v", err, tt.wantErr)
            }
            if got != tt.want {
                t.Errorf("got %v, want %v", got, tt.want)
            }
        })
    }
}
```

- Don't add a test case unless it tests something distinct. Three cases that all exercise the same path are two cases too many.

## Mocks vs fakes vs real dependencies

- **Real dependencies first.** If a test can hit a real DB / real HTTP server / real filesystem cheaply, do that. Tests that exercise real code catch real bugs.
- **Fakes second.** If real is too slow or flaky, write a small in-memory fake (a struct that satisfies the interface). Fakes are usually 20-50 lines.
- **Mocks last.** Generated or hand-written mocks (testify, gomock) are a code smell unless the dependency is genuinely external (a third-party SDK, a payment gateway). Don't mock your own code.

## Coverage

- Aim for coverage on code that has consequences. A handler that takes money matters. A logging helper does not.
- 80% is a healthy ceiling, not a floor to chase. Don't write low-value tests to hit a number.
- `go test -cover` is fine; coverage tooling beyond that is rarely worth the complexity.

## What the AI should never produce

- Tests that just call the function and check `err == nil`. That's not a test, that's a smoke check disguised as one.
- Tests that mock every dependency and assert on the mock calls. You're testing the mock, not the code.
- Setup helpers used in one test. Inline the setup.
- Test names like `TestFoo1`, `TestFooSuccess`, `TestFooHappyPath`. Use names that describe the behavior: `TestParseDate_RejectsEmptyInput`.
