---
name: conventional-commits
description: Format git commits using Conventional Commits standard. Use when creating commits, writing commit messages, or when user asks about commit conventions.
version: 1.0.0
---

# Conventional Commits

## When to Use

- Creating git commits
- Writing commit messages
- Reviewing commit history
- Setting up commit conventions for a project

## When NOT to Use

- Projects with existing different commit conventions
- When user explicitly requests a different format

## Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Types

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation changes |
| `style` | Formatting, missing semicolons (no code change) |
| `refactor` | Code restructuring without changing behavior |
| `perf` | Performance improvements |
| `test` | Adding or updating tests |
| `chore` | Maintenance tasks, dependencies |
| `ci` | CI/CD changes |
| `build` | Build system changes |

## Requirements

1. **Always include a description** in the commit body explaining the "why"
2. **Check for GitHub issue references** - if the change relates to an issue, include it in the footer

## Examples

### Good Commit

```bash
git commit -m "$(cat <<'EOF'
feat(auth): add OAuth2 support for Google login

Users can now sign in using their Google accounts, which provides
a more seamless authentication experience and reduces password fatigue.

Closes #42
EOF
)"
```

### Bad Commit

```bash
# Missing description and issue reference
git commit -m "fix: button color"
```

## Footer Keywords

| Keyword | Effect |
|---------|--------|
| `Closes #123` | Closes the issue when merged |
| `Fixes #123` | Fixes the issue when merged |
| `Resolves #123` | Resolves the issue when merged |
| `Refs #123` | References without closing |

## Breaking Changes

For breaking changes, add `BREAKING CHANGE:` in the footer or `!` after the type:

```bash
git commit -m "$(cat <<'EOF'
feat(api)!: change response format to JSON:API

The API now returns responses in JSON:API format for better
standardization and client library support.

BREAKING CHANGE: Response structure has changed. Clients must update
their parsers to handle the new format.

Closes #78
EOF
)"
```
