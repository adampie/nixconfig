# Python

## Dependency Management
- Use `uv` for fast dependency management: `uv add requests`
- Use `poetry` for traditional package management: `poetry add requests`

## Code Style and Quality
- Use PEP 8 style guide
- Use `black` for automatic code formatting: `black .`
- Use `ruff` for linting: `uvx ruff check .`
- Use `ty` for static type checking: `uvx ty check src/`

## Type Hints and Documentation
- Use type hints for function parameters and return values: `def process(data: list[str]) -> dict[str, int]:`
- Write docstrings for all public functions and classes using Google or NumPy style
- Include usage examples in docstrings with `>>> ` prefix
- Use `from __future__ import annotations` for forward references

## Error Handling
- Use specific exception types: `except ValueError:` instead of `except:`
- Use `try/except/else/finally` appropriately: `else` for success path, `finally` for cleanup
- Implement proper logging with `logging.getLogger(__name__)`
- Handle edge cases explicitly rather than relying on defaults

## Testing
- Use descriptive test function names: `test_user_creation_with_valid_email()`
- Parametrize tests with `@pytest.mark.parametrize("input,expected", [...])`
- Use fixtures for common test setup: `@pytest.fixture`

## Design Patterns
- Keep functions focused on single responsibilities (max 20-30 lines)
- Use appropriate data structures: `set` for uniqueness, `dict` for lookups, `list` for order
- Use dataclasses for simple data containers: `@dataclass class User:`
- Use context managers for resource management: `with open(file) as f:`