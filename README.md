# Agent Skills

A universal repository of AI agent configurations (skills, rules, and commands) with an installer that works across multiple AI-assisted IDEs.

## Supported IDEs

| IDE | Skills | Rules | Commands |
|-----|--------|-------|----------|
| **Cursor** | `~/.cursor/skills/` | `~/.cursor/rules/` | `~/.cursor/agents/` |
| **OpenCode** | Converted to agents | `AGENTS.md` | `~/.config/opencode/agents/` |
| **VSCode/Copilot** | N/A | `copilot-instructions.md` | N/A |

## Quick Install

```bash
# One-liner install (interactive)
curl -fsSL https://raw.githubusercontent.com/testified/agent-skills/main/install.sh | bash

# Or clone and run locally
git clone https://github.com/testified/agent-skills.git
cd agent-skills
./install.sh
```

## Installation Options

### Interactive Mode

Just run the script with no arguments:

```bash
./install.sh
```

You'll be prompted to:
1. Select which IDEs to install to
2. Choose symlink or copy mode
3. Select which components (skills, rules, commands)

### Non-Interactive Mode

```bash
# Install to Cursor with symlinks
./install.sh --cursor --symlink

# Install to all IDEs with copies
./install.sh --all --copy

# Install only rules to OpenCode
./install.sh --opencode --rules-only
```

### Command Line Options

| Option | Description |
|--------|-------------|
| `--cursor` | Install to Cursor |
| `--opencode` | Install to OpenCode |
| `--vscode` | Install to VSCode/Copilot |
| `--all` | Install to all detected IDEs |
| `--symlink` | Use symlinks (auto-updates from repo) |
| `--copy` | Copy files (static snapshot) |
| `--skills-only` | Only install skills |
| `--rules-only` | Only install rules |
| `--commands-only` | Only install commands |
| `--no-backup` | Skip backup of existing configs |
| `-h, --help` | Show help message |

## Symlink vs Copy Mode

### Symlink Mode (Recommended)

- Changes in this repo automatically reflect in all IDEs
- Update everywhere with `git pull`
- Single source of truth
- Requires repo to stay in place

### Copy Mode

- Static snapshot of configurations
- No dependency on repo location
- Re-run script to apply updates
- Good for distributing to others

## What's Included

### Skills

Reusable agent capabilities:

| Skill | Description |
|-------|-------------|
| `conventional-commits` | Format git commits using Conventional Commits standard |
| `code-review` | Systematic code review following best practices |
| `test-planning` | Create comprehensive test plans with scope, resources, risks, and criteria |

### Rules

Coding standards and conventions:

| Rule | Description |
|------|-------------|
| `code-quality.mdc` | Naming conventions, functions, error handling |
| `pull-request-template.mdc` | Standard PR format with summary, changes, issues |
| `quality-metrics.mdc` | Standard quality metrics with recommended thresholds |
| `ci-cd-quality-gates.mdc` | Quality gates for CI/CD pipelines including coverage, security, performance |
| `test-data-management.mdc` | Test data isolation, cleanup, sensitive data handling, environment configs |
| `test-environment-checklist.mdc` | Checklists for test environment setup, validation, and maintenance |

### Commands

Custom subagent definitions:

| Command | Description |
|---------|-------------|
| `code-reviewer.md` | Specialized code review agent |
| `regression-impact.md` | Analyzes code changes to recommend regression test scope and prioritization |

## Directory Structure

```
agent-skills/
├── README.md           # This file
├── install.sh          # Universal installer
├── skills/             # Agent skills
│   ├── conventional-commits/
│   │   └── SKILL.md
│   ├── code-review/
│   │   └── SKILL.md
│   └── test-planning/
│       └── SKILL.md
├── rules/              # Coding standards
│   ├── code-quality.mdc
│   └── pull-request-template.mdc
├── commands/           # Subagent definitions
│   └── code-reviewer.md
└── memory-bank/        # Project documentation
```

## Contributing

### Adding a Skill

1. Create a directory: `skills/your-skill-name/`
2. Add `SKILL.md` with required frontmatter:

```yaml
---
name: your-skill-name
description: Brief description for discovery
version: 1.0.0
---

# Your Skill Name

## When to Use
- Trigger conditions

## Instructions
- What the agent should do
```

3. Submit a pull request

### Adding a Rule

1. Create a file: `rules/your-rule.mdc`
2. Add required frontmatter:

```yaml
---
description: One-line description
alwaysApply: true
---

# Your Rule

Instructions...
```

3. Submit a pull request

### Adding a Command

1. Create a file: `commands/your-command.md`
2. Add required frontmatter:

```yaml
---
name: your-command
description: What this agent does
mode: subagent
model: fast
tools:
  - read
  - write
---

# Your Command

## System Prompt
Instructions for the subagent...
```

3. Submit a pull request

## Updating

### Symlink Mode

```bash
cd /path/to/agent-skills
git pull
# Changes are automatically reflected
```

### Copy Mode

```bash
cd /path/to/agent-skills
git pull
./install.sh --cursor --copy  # Re-run with same options
```

## Backups

The installer automatically creates backups at:

```
~/.agent-skills-backup/
└── 2024-01-21T10-30-00/
    ├── cursor/
    └── opencode/
```

To restore:

```bash
# Find your backup
ls ~/.agent-skills-backup/

# Copy back manually
cp -r ~/.agent-skills-backup/[timestamp]/cursor/skills/* ~/.cursor/skills/
```

## Troubleshooting

### "Cannot find skills/ or rules/ directory"

Make sure you're running the script from the repo root:

```bash
cd /path/to/agent-skills
./install.sh
```

### Skills not appearing in Cursor

1. Verify the skill was installed: `ls ~/.cursor/skills/`
2. Restart Cursor
3. Check for YAML frontmatter errors in SKILL.md

### OpenCode not reading AGENTS.md

1. Verify file exists: `cat ~/.config/opencode/AGENTS.md`
2. Restart OpenCode
3. Check file permissions

## License

MIT
