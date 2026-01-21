---
name: code-review
description: Systematic code review following best practices. Use when reviewing PRs, analyzing code quality, or when user asks for code review.
version: 1.0.0
---

# Code Review

## When to Use

- Reviewing pull requests
- Analyzing code quality
- Providing feedback on code changes
- Pre-commit self-review

## When NOT to Use

- Quick syntax questions
- When user just wants code written, not reviewed

## Review Checklist

### 1. Correctness
- [ ] Does the code do what it's supposed to do?
- [ ] Are edge cases handled?
- [ ] Are there any obvious bugs?

### 2. Security
- [ ] Input validation present?
- [ ] No hardcoded secrets?
- [ ] SQL injection / XSS prevention?
- [ ] Proper authentication/authorization checks?

### 3. Performance
- [ ] No unnecessary loops or computations?
- [ ] Efficient data structures used?
- [ ] Database queries optimized?
- [ ] No memory leaks?

### 4. Readability
- [ ] Clear variable/function names?
- [ ] Adequate comments for complex logic?
- [ ] Consistent formatting?
- [ ] Functions are focused (single responsibility)?

### 5. Maintainability
- [ ] DRY (Don't Repeat Yourself)?
- [ ] Proper error handling?
- [ ] Testable code?
- [ ] No magic numbers/strings?

### 6. Testing
- [ ] Tests cover new functionality?
- [ ] Edge cases tested?
- [ ] Tests are readable and maintainable?

## Feedback Format

When providing review feedback, use this format:

```markdown
## Summary
Brief overview of the changes and overall assessment.

## Strengths
- What's done well

## Suggestions
- **[File:Line]** Description of issue and suggested fix
- **[File:Line]** Another suggestion

## Questions
- Clarifying questions if needed
```

## Severity Levels

| Level | Meaning | Action Required |
|-------|---------|-----------------|
| **Blocker** | Critical issue, must fix | Cannot merge |
| **Major** | Significant issue | Should fix before merge |
| **Minor** | Small improvement | Nice to have |
| **Nitpick** | Style/preference | Optional |

## Example Review Comment

```markdown
**[src/auth.ts:45]** Major: Password is logged in plain text

The error logging includes the user's password, which is a security risk.

Suggestion:
- Remove password from log output
- Or mask it: `password: '****'`
```

## Best Practices

1. **Be constructive** - Suggest solutions, not just problems
2. **Be specific** - Reference exact lines and files
3. **Explain why** - Help the author learn
4. **Prioritize** - Focus on important issues first
5. **Acknowledge good work** - Positive feedback matters
