---
name: bug-report
description: Write clear, actionable bug reports with proper reproduction steps, expected vs actual behavior, severity classification, and environment details. Use when reporting bugs, creating issues, or documenting defects.
version: 1.0.0
---

# Bug Report

## When to Use

- Reporting bugs or defects in software
- Creating GitHub/GitLab issues for bugs
- Documenting unexpected behavior
- Helping users write better bug reports
- Triaging and classifying existing bug reports

## When NOT to Use

- Feature requests (use a feature request template instead)
- General questions or support requests
- Documentation issues (use docs template)
- When the issue is clearly user error, not a bug

## Bug Report Template

```markdown
## Summary
[One-line description of the bug]

## Environment
- **OS:** [e.g., macOS 14.2, Windows 11, Ubuntu 22.04]
- **Browser:** [e.g., Chrome 120, Firefox 121, Safari 17] (if applicable)
- **Version:** [App/library version, commit hash]
- **Device:** [e.g., iPhone 15, Desktop] (if applicable)
- **Node/Runtime:** [e.g., Node 20.10.0, Python 3.12] (if applicable)

## Steps to Reproduce
1. [First step]
2. [Second step]
3. [Third step]
4. [...]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Error Messages
```
[Paste any error messages, stack traces, or logs]
```

## Screenshots/Videos
[Attach visual evidence if applicable]

## Additional Context
[Any other relevant information]

## Possible Fix
[Optional: If you have an idea of what might be causing this]
```

## Severity Classification

| Severity | Description | Examples | Response Time |
|----------|-------------|----------|---------------|
| **Critical** | System unusable, data loss, security vulnerability | App crashes on launch, data corruption, auth bypass | Immediate |
| **High** | Major feature broken, no workaround | Cannot save files, login fails for all users | Within 24 hours |
| **Medium** | Feature impaired, workaround exists | Export fails but manual copy works, slow performance | Within 1 week |
| **Low** | Minor issue, cosmetic | Typo in UI, alignment off by 1px | As time permits |

## Priority vs Severity

- **Severity**: How bad is the impact?
- **Priority**: How urgently should we fix it?

A low-severity bug affecting many users may have high priority.
A critical bug in a rarely-used feature may have lower priority.

## Writing Good Reproduction Steps

### Bad Example

```markdown
## Steps to Reproduce
1. Try to login
2. It doesn't work
```

### Good Example

```markdown
## Steps to Reproduce
1. Navigate to https://example.com/login
2. Enter email: test@example.com
3. Enter password: (any valid password)
4. Click "Sign In" button
5. Observe the error message

**Reproduction rate:** 100% (occurs every time)
**First noticed:** 2024-01-15 after v2.3.0 release
```

## Key Elements of a Good Bug Report

### 1. Specific and Reproducible
- Exact steps anyone can follow
- Include test data if needed
- Note reproduction rate (always, sometimes, once)

### 2. Isolated
- One bug per report
- Don't combine multiple issues
- Link related bugs instead

### 3. Objective
- Describe facts, not opinions
- "Button doesn't respond" not "Button is broken"
- Include exact error messages

### 4. Complete
- All relevant environment details
- Screenshots/videos when helpful
- Related logs or console output

### 5. Searchable
- Descriptive title
- Include error codes/messages
- Use consistent terminology

## Bug Report Checklist

Before submitting, verify:

- [ ] Title clearly describes the issue
- [ ] Environment details are complete
- [ ] Steps to reproduce are detailed and numbered
- [ ] Expected vs actual behavior is clear
- [ ] Error messages are included (if any)
- [ ] Screenshots/videos attached (if helpful)
- [ ] Severity is assessed
- [ ] Checked for duplicate reports

## Example Complete Bug Report

```markdown
## Summary
Login button unresponsive after failed password attempt

## Environment
- **OS:** macOS 14.2.1
- **Browser:** Chrome 120.0.6099.129
- **Version:** v2.3.1 (commit abc123)
- **Node:** 20.10.0

## Steps to Reproduce
1. Navigate to https://app.example.com/login
2. Enter valid email: user@example.com
3. Enter incorrect password: "wrongpassword"
4. Click "Sign In" button
5. See "Invalid credentials" error (expected)
6. Correct the password and click "Sign In" again
7. Button does not respond to clicks

**Reproduction rate:** 100%
**First noticed:** 2024-01-15

## Expected Behavior
The "Sign In" button should submit the form with the corrected password.

## Actual Behavior
The "Sign In" button becomes completely unresponsive after a failed
login attempt. The page must be refreshed to attempt login again.

## Error Messages
Console shows:
```
TypeError: Cannot read property 'disabled' of null
    at handleSubmit (login.js:45)
    at HTMLButtonElement.onclick (login.js:12)
```

## Screenshots
[screenshot showing the unresponsive button state]

## Additional Context
- Issue started appearing after the v2.3.0 release
- Does not occur in Firefox or Safari
- Clearing browser cache does not fix the issue

## Possible Fix
The error suggests `buttonRef.current` might be null. The button
disable logic in `handleSubmit` may need a null check.
```

## Triaging Bug Reports

When reviewing incoming bug reports:

1. **Verify completeness** - Request missing information
2. **Attempt reproduction** - Confirm the bug exists
3. **Check for duplicates** - Link to existing issues
4. **Assess severity** - Based on impact and scope
5. **Assign priority** - Based on business needs
6. **Add labels** - Component, type, version affected
7. **Assign owner** - Route to appropriate team/person

## Common Bug Categories

| Category | Description |
|----------|-------------|
| **Functional** | Feature doesn't work as specified |
| **Performance** | Slow response, high resource usage |
| **Security** | Vulnerability, data exposure |
| **Usability** | Confusing UI, poor UX |
| **Compatibility** | Works in one env, fails in another |
| **Data** | Incorrect data, data loss |
| **Integration** | Third-party service failures |
| **Regression** | Previously working feature now broken |
