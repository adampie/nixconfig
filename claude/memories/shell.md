# Shell

## Script Safety
- Use `#!/usr/bin/env bash` shebang for portability
- Set strict error handling with `set -euo pipefail`
- Enable debug mode with `set -x` when troubleshooting
- Always quote variables: `"$variable"` to prevent word splitting
- Use `trap 'cleanup' EXIT` for cleanup on script exit

## Variable Handling
- Use `local variable="value"` inside functions to avoid global scope pollution
- Use parameter expansion for defaults: `${VAR:-default_value}`
- Check required parameters: `${1:?Missing required parameter}`
- Declare constants with `readonly CONFIG_FILE="/etc/config"`
- Use arrays for lists: `files=("file1.txt" "file2.txt")`

## Error Handling
- Check exit codes explicitly: `if ! command; then echo "Failed"; exit 1; fi`
- Use error handling for critical operations: `command || { echo "Error message"; exit 1; }`
- Test for required commands: `command -v jq >/dev/null || { echo "jq not found"; exit 1; }`
- Return meaningful exit codes from functions (0 for success, 1+ for errors)

## File Operations
- Check file existence: `[[ -f "$file" ]]`
- Check directory existence: `[[ -d "$dir" ]]`
- Create directories safely: `mkdir -p "$target_dir"`
- Use temporary files: `tmp=$(mktemp)` and clean up with trap
- Process files line by line: `while IFS= read -r line; do ... done < "$file"`

## Best Practices
- Use `case` statements for multiple string conditions instead of nested if/elif
- Use command substitution: `result=$(command)` instead of backticks
- Cache expensive command results: `git_branch=$(git branch --show-current)`
- Use built-in operations over external commands when possible
- Sanitize user input before using in commands
- Never log sensitive information like passwords or tokens