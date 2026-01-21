# Skills

This directory contains reusable agent skills that provide specialized capabilities to AI assistants.

## Structure

Each skill is a directory containing at minimum a `SKILL.md` file:

```
skills/
├── skill-name/
│   ├── SKILL.md           # Required: Main skill definition
│   ├── reference.md       # Optional: Detailed documentation
│   ├── examples.md        # Optional: Usage examples
│   └── references/        # Optional: Multiple reference files
│       └── topic.md
```

## SKILL.md Format

```yaml
---
name: skill-name
description: Brief description of what this skill does and when to use it
version: 1.0.0
---

# Skill Name

## When to Use

- Describe trigger conditions
- What problems this skill solves

## When NOT to Use

- Anti-patterns
- Alternative approaches

## Instructions

Core instructions for the AI agent...

## Examples

Code examples and usage patterns...
```

## Adding a New Skill

1. Create a directory: `skills/your-skill-name/`
2. Create `SKILL.md` with required frontmatter
3. Add optional reference files as needed
4. Run `./install.sh` to deploy

## Naming Conventions

- Use lowercase with hyphens: `my-skill-name`
- Be descriptive: `expo-api-routes` not `api`
- Max 64 characters

## Best Practices

- Keep `SKILL.md` under 500 lines
- Use reference files for detailed content
- Include practical, copy-pasteable examples
- Write clear "When to Use" sections for discovery
