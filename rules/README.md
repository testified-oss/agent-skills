# Rules

This directory contains workspace rules that define coding standards, conventions, and workflows.

## Structure

Rules are `.mdc` files with YAML frontmatter:

```
rules/
├── conventional-commits.mdc
├── code-quality.mdc
└── pull-request-template.mdc
```

## Rule Format (.mdc)

```yaml
---
description: One-line description of what this rule enforces
alwaysApply: true
---

# Rule Name

## Purpose

Why this rule exists...

## Requirements

- MUST do X
- MUST NOT do Y
- SHOULD prefer Z

## Examples

### Good
\`\`\`typescript
// Correct approach
\`\`\`

### Bad
\`\`\`typescript
// Incorrect approach
\`\`\`
```

## Frontmatter Options

| Field | Type | Description |
|-------|------|-------------|
| `description` | string | Brief description (required) |
| `alwaysApply` | boolean | If true, always included in context |
| `globs` | string[] | File patterns to auto-attach |

## Adding a New Rule

1. Create a file: `rules/your-rule-name.mdc`
2. Add required frontmatter
3. Write rule content in markdown
4. Run `./install.sh` to deploy

## Naming Conventions

- Use lowercase with hyphens: `my-rule-name.mdc`
- Be specific: `react-component-patterns` not `react`
- Match the rule's purpose

## Best Practices

- Use directive language: MUST, SHOULD, MUST NOT
- Include both good and bad examples
- Keep rules focused on one concern
- Reference external docs when helpful
