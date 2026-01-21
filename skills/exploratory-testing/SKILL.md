---
name: exploratory-testing
description: Guide exploratory testing sessions including charter creation, session-based testing, heuristics application, and finding documentation. Use when planning exploratory testing, conducting test sessions, or documenting discoveries.
version: 1.0.0
---

# Exploratory Testing

## When to Use

- Planning exploratory testing sessions
- Creating test charters for focused exploration
- Applying testing heuristics to discover issues
- Documenting findings and bugs systematically
- Supplementing scripted testing with exploration
- Testing new features without detailed specifications
- Learning about a system's behavior

## When NOT to Use

- When comprehensive scripted test cases already exist and just need execution
- For regression testing that requires exact reproducibility
- When compliance requires documented test scripts upfront
- For performance or load testing (use specialized tools)

## Test Charter Creation

A charter defines the mission for an exploratory testing session.

### Charter Format

```markdown
**Charter:** [Brief mission statement]

**Target:** [Area/feature to explore]
**Resources:** [Tools, data, environments needed]
**Time Box:** [Duration, typically 60-90 minutes]

**Explore:** [What to investigate]
**With:** [What resources/techniques to use]
**To discover:** [What information to find]
```

### Charter Template (Explore-With-Discover)

```markdown
**Explore** [target area]
**With** [resources, techniques, data]
**To discover** [information, risks, behaviors]
```

### Example Charters

#### Feature Exploration

```markdown
**Charter:** Investigate user authentication flow edge cases

**Explore** the login and password reset functionality
**With** boundary values, special characters, and concurrent sessions
**To discover** security vulnerabilities and error handling gaps
```

#### Integration Exploration

```markdown
**Charter:** Test payment gateway integration resilience

**Explore** the checkout process with payment provider
**With** network interruptions, timeout scenarios, and invalid responses
**To discover** failure modes and recovery behavior
```

#### Usability Exploration

```markdown
**Charter:** Evaluate mobile responsiveness of dashboard

**Explore** the analytics dashboard on various devices
**With** different screen sizes, orientations, and touch interactions
**To discover** layout issues and usability problems
```

## Session-Based Test Management (SBTM)

Organize exploratory testing into focused, timeboxed sessions.

### Session Structure

| Phase | Duration | Activities |
|-------|----------|------------|
| **Setup** | 5-10 min | Review charter, prepare environment |
| **Exploration** | 45-60 min | Active testing, note-taking |
| **Debrief** | 10-15 min | Document findings, update notes |

### Session Sheet Template

```markdown
## Session Report

**Session ID:** ET-[YYYY-MM-DD]-[number]
**Tester:** [Name]
**Date:** [Date]
**Duration:** [Actual time spent]

### Charter
[The charter for this session]

### Areas Covered
- [Area 1 explored]
- [Area 2 explored]

### Testing Notes
[Chronological notes during testing]

### Findings
| ID | Type | Severity | Description |
|----|------|----------|-------------|
| F1 | Bug | High | [Description] |
| F2 | Question | Medium | [Description] |

### Session Metrics
- **Charter vs Opportunity:** [% on charter vs % following opportunities]
- **Test Design & Execution:** [% designing vs % executing]
- **Bug Investigation:** [% spent investigating bugs]

### Follow-up
- [ ] [Action items]
- [ ] [New charter ideas]
```

## Testing Heuristics

Mental models and mnemonics to guide exploration.

### SFDPOT (San Francisco Depot)

Quality characteristics to explore:

| Heuristic | Questions to Ask |
|-----------|------------------|
| **S**tructure | What is it made of? Components, code, files, databases? |
| **F**unction | What does it do? Features, operations, user workflows? |
| **D**ata | What data does it process? Inputs, outputs, transformations? |
| **P**latform | What does it depend on? OS, browser, hardware, network? |
| **O**perations | How will it be used? User scenarios, deployment, maintenance? |
| **T**ime | How does time affect it? Timeouts, scheduling, performance over time? |

### FEW HICCUPS

Input testing heuristics:

| Heuristic | Test Ideas |
|-----------|-----------|
| **F**ormat | Different formats (JSON, XML, CSV) |
| **E**mpty | Null, empty string, zero, blank |
| **W**hitespace | Spaces, tabs, newlines, leading/trailing |
| **H**uge | Maximum values, large files, long strings |
| **I**nvalid | Wrong types, malformed data, out of range |
| **C**orrect | Valid, expected, happy path |
| **C**hanged | Modified mid-operation, concurrent updates |
| **U**nique | Special characters, Unicode, emojis |
| **P**aired | Start/end, open/close, parent/child |
| **S**equence | Order dependencies, repetition, timing |

### CRUD Operations

For data-centric testing:

| Operation | Test Considerations |
|-----------|-------------------|
| **C**reate | Valid/invalid creation, duplicates, required fields |
| **R**ead | Exists/not exists, permissions, filtering |
| **U**pdate | Partial updates, concurrent edits, validation |
| **D**elete | Cascade effects, soft vs hard delete, recovery |

### Goldilocks Heuristic

Test with values that are:

- **Too small** - Minimum, zero, negative, empty
- **Just right** - Typical, expected values
- **Too large** - Maximum, overflow, boundary+1

### FAILURE Heuristic

Look for failures in:

| Area | Examples |
|------|----------|
| **F**unctionality | Features not working as expected |
| **A**ccessibility | Usability issues, screen reader problems |
| **I**nternationalization | Language, locale, character encoding |
| **L**ocalization | Date formats, currencies, translations |
| **U**sability | Confusing UI, poor error messages |
| **R**eliability | Crashes, data loss, inconsistent behavior |
| **E**fficiency | Slow performance, resource consumption |

### Touring Heuristics

Explore the application like a tourist:

| Tour | Focus |
|------|-------|
| **Guidebook Tour** | Follow the documentation/help |
| **Money Tour** | Test the features customers pay for |
| **Landmark Tour** | Navigate between major features |
| **Intellectual Tour** | Test the most complex features |
| **FedEx Tour** | Follow data through the system |
| **Garbage Collector Tour** | Find the least-used features |
| **Bad Neighborhood Tour** | Focus on historically buggy areas |
| **Antisocial Tour** | Do the opposite of intended use |
| **Obsessive-Compulsive Tour** | Repeat actions, enter same data twice |

## Finding Documentation

### Finding Classification

| Type | Description |
|------|-------------|
| **Bug** | Defect that needs fixing |
| **Question** | Needs clarification from stakeholders |
| **Observation** | Interesting behavior, may or may not be a problem |
| **Enhancement** | Improvement suggestion |
| **Risk** | Potential problem area needing attention |

### Bug Report Template

```markdown
## Bug Report

**ID:** BUG-[number]
**Title:** [Short descriptive title]
**Severity:** [Critical/High/Medium/Low]
**Found During:** Session [ET-YYYY-MM-DD-number]

### Summary
[One paragraph description]

### Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Expected Result
[What should happen]

### Actual Result
[What actually happened]

### Environment
- OS: [Operating system]
- Browser: [Browser and version]
- App Version: [Version number]

### Evidence
- Screenshots: [Links]
- Logs: [Relevant log entries]
- Video: [Link if applicable]

### Notes
[Additional context, workarounds, related issues]
```

### Severity Guidelines

| Level | Criteria | Examples |
|-------|----------|----------|
| **Critical** | System unusable, data loss, security breach | Crash, data corruption, auth bypass |
| **High** | Major feature broken, no workaround | Cannot complete core workflow |
| **Medium** | Feature impaired, workaround exists | Minor functionality issues |
| **Low** | Cosmetic, minor inconvenience | Typos, alignment issues |

## Session Debrief Questions

After each session, answer:

1. **What did you test?** - Summarize areas covered
2. **What did you find?** - List bugs, questions, observations
3. **What didn't you test?** - Identify gaps and risks
4. **What puzzled you?** - Note confusion or uncertainty
5. **What would you do next?** - Suggest follow-up sessions

## Output Format

When facilitating exploratory testing, provide:

```markdown
## Exploratory Testing Plan

### Context
[What we're testing and why]

### Charters

#### Charter 1: [Title]
**Explore** [target]
**With** [resources]
**To discover** [information]

**Suggested Heuristics:** [SFDPOT, FEW HICCUPS, etc.]
**Time Box:** [Duration]

### Recommended Approach
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Session Sheet
[Template for documenting the session]

### Heuristics Reference
[Relevant heuristics for this exploration]
```

## Best Practices

1. **Stay focused but flexible** - Follow the charter, but investigate interesting findings
2. **Take detailed notes** - Document everything during the session
3. **Use varied heuristics** - Combine multiple approaches for better coverage
4. **Debrief immediately** - Document findings while memory is fresh
5. **Share knowledge** - Pair with others, share interesting discoveries
6. **Track coverage** - Note what was and wasn't tested
7. **Timebox strictly** - Respect session boundaries, create new charters for tangents
8. **Balance charter vs opportunity** - Aim for 80% charter, 20% opportunities
