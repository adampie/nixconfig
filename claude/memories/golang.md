# Golang

## Project Structure
- Use standard Go project layout: `cmd/`, `internal/`, `pkg/`, `api/`
- Keep main packages in `cmd/` directory: `cmd/myapp/main.go`
- Put application-specific code in `internal/` to prevent external imports
- Use `pkg/` for reusable library code that can be imported by external projects
- Group related files in packages by functionality, not type

## Naming Conventions
- Use CamelCase for exported functions and types: `func ParseJSON()`, `type HTTPClient`
- Use camelCase for unexported functions and variables: `func parseData()`, `var httpClient`
- Package names should be lowercase, single words: `package user`, `package auth`
- Interface names should end with `-er` suffix: `type Reader interface{}`, `type Writer interface{}`

## Error Handling
- Always check errors explicitly: `if err != nil { return fmt.Errorf("failed to parse: %w", err) }`
- Wrap errors with context: `fmt.Errorf("database query failed: %w", err)`
- Use `errors.Is(err, target)` and `errors.As(err, &target)` for error comparison
- Return errors as the last return value: `func Process() (result string, err error)`

## Logging
- Use `slog` for structured logging: `slog.Info("user created", "id", userID, "email", email)`
- Avoid `fmt.Print*` for logging in production code

## Testing
- Use table-driven tests: `tests := []struct{ name, input, expected string }{}`
- Test file names should end with `_test.go`
- Use `t.Helper()` in test helper functions to improve error reporting
- Use `t.Setenv("KEY", "value")` for environment variables in tests
- Use `t.TempDir()` for creating temporary directories
- Use `testify/require` for assertions that should stop test execution

## Concurrency
- Use channels to communicate: `ch := make(chan string, 10)`
- Close channels from sender side, not receiver side
- Use `context.Context` for cancellation: `ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)`
- Use `sync.WaitGroup` to wait for goroutines: `wg.Add(1); go func() { defer wg.Done(); ... }()`
- Prefer `sync.RWMutex` for read-heavy workloads over `sync.Mutex`
- Limit concurrency for external systems: `semaphore := make(chan struct{}, maxConcurrency)`

## Performance
- Pre-allocate slices with known capacity: `users := make([]User, 0, expectedCount)`
- Use pointers for large structs in function parameters to avoid copying
- Use `strings.Builder` for concatenating multiple strings
