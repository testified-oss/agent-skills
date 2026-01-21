# Commands (Subagents)

This directory contains custom subagent definitions that extend AI assistant capabilities with specialized behaviors.

## Structure

Commands are markdown files with YAML frontmatter:

```
commands/
├── code-reviewer.md
├── regression-impact.md
├── test-writer.md
└── documentation-generator.md
```

## Command Format

```yaml
---
name: command-name
description: What this subagent does
mode: subagent
model: fast
tools:
  - read
  - write
  - shell
  - grep
---

# Command Name

## Purpose

What this subagent specializes in...

## System Prompt

You are a specialized agent that...

## Workflow

1. Step one
2. Step two
3. Step three

## Constraints

- Limitation 1
- Limitation 2
```

## Frontmatter Options

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Identifier for the command |
| `description` | string | Brief description (required) |
| `mode` | string | `subagent` or `primary` |
| `model` | string | `fast`, `default`, etc. |
| `tools` | string[] | Allowed tools |
| `readonly` | boolean | If true, no write operations |

## Adding a New Command

1. Create a file: `commands/your-command.md`
2. Add required frontmatter with name and description
3. Write the system prompt and workflow
4. Run `./install.sh` to deploy

## Naming Conventions

- Use lowercase with hyphens: `my-command.md`
- Use action-oriented names: `code-reviewer`, `test-writer`
- Be specific about the specialization

## Best Practices

- Keep system prompts focused and concise
- Specify minimal required tools
- Use `readonly: true` when writes aren't needed
- Include clear workflow steps
- Document constraints and limitations
