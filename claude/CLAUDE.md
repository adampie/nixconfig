# CLAUDE.md

This file contains personal preferences and practices for Claude Code across all projects.

## Requirements Gathering
- **ALWAYS** ask clarifying questions before starting any task to ensure complete understanding
- Confirm scope, edge cases, testing requirements, and success criteria
- Identify dependencies, constraints, and potential impacts
- Verify user preferences for implementation approach and tooling choices

## General Development Preferences

### Code Style
- Prefer updating existing code over creating new code
- Always add trailing newlines to files
- Remove trailing whitespace
- Only add comments to complex code

### Security Practices
- Never commit secrets, API keys, or passwords to version control
- Use environment variables or secret management systems (1Password, HashiCorp Vault)
- Validate and sanitize all user inputs
- Implement proper error handling without exposing sensitive information
- Use secure coding standards and guidelines
- Use dependency scanning tools
- Use encryption for sensitive data processing

### Compliance & Governance
- Understand relevant compliance requirements (GDPR, SOC2, etc.)
- Maintain audit trails for compliance reporting
- Implement data retention and deletion policies

## Technology-Specific Practices

- @~/.claude/memories/cdk.md
- @~/.claude/memories/cicd.md
- @~/.claude/memories/docker.md
- @~/.claude/memories/golang.md
- @~/.claude/memories/javascript.md
- @~/.claude/memories/python.md
- @~/.claude/memories/security.md
- @~/.claude/memories/shell.md
- @~/.claude/memories/terraform.md
