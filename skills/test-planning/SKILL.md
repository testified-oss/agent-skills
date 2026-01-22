---
name: test-planning
description: Create comprehensive test plans including scope definition, resource allocation, risk assessment, entry/exit criteria, and test strategy documentation. Use when planning testing activities for features, releases, or projects.
version: 1.0.0
---

# Test Planning

## When to Use

- Planning testing activities for a new feature or release
- Creating formal test documentation
- Defining test scope and boundaries
- Assessing testing risks and mitigation strategies
- Establishing entry and exit criteria
- Allocating testing resources
- Documenting test strategy for stakeholders

## When NOT to Use

- Quick ad-hoc testing of small changes
- When user just wants to write a single test
- Exploratory testing sessions
- Projects with existing mature test plans that don't need revision

## Test Plan Components

### 1. Scope Definition

Define what will and will not be tested.

```markdown
## Test Scope

### In Scope
- [ ] Feature/component 1: [Description]
- [ ] Feature/component 2: [Description]
- [ ] Integration points: [List APIs, services]
- [ ] User workflows: [Critical paths]

### Out of Scope
- [ ] [Component/feature]: [Reason for exclusion]
- [ ] [Third-party system]: [Covered by vendor]

### Assumptions
- [Assumption 1]
- [Assumption 2]

### Dependencies
- [Dependency 1]: [Impact if unavailable]
- [Dependency 2]: [Impact if unavailable]
```

### 2. Test Strategy

Define the testing approach and methodology.

```markdown
## Test Strategy

### Testing Levels
| Level | Scope | Responsible | Tools |
|-------|-------|-------------|-------|
| Unit | Individual functions/methods | Developers | Jest, pytest |
| Integration | Component interactions | Dev + QA | Supertest, pytest |
| E2E | User workflows | QA | Playwright, Cypress |
| Performance | Load/stress | QA/DevOps | k6, Artillery |

### Testing Types
- **Functional Testing:** Verify features work as specified
- **Regression Testing:** Ensure existing functionality unchanged
- **Smoke Testing:** Quick validation of critical paths
- **Security Testing:** Vulnerability assessment
- **Accessibility Testing:** WCAG compliance validation
- **Compatibility Testing:** Browser/device coverage

### Test Data Strategy
- **Source:** [Production subset / Synthetic / Fixtures]
- **Management:** [How test data is created, maintained, cleaned up]
- **Sensitive Data:** [Anonymization approach]

### Environment Strategy
| Environment | Purpose | Data | Refresh Cycle |
|-------------|---------|------|---------------|
| Dev | Developer testing | Synthetic | Daily |
| QA | Formal testing | Production subset | Weekly |
| Staging | Pre-prod validation | Production mirror | Release |
```

### 3. Entry and Exit Criteria

Define when testing can begin and when it's complete.

```markdown
## Entry Criteria

Testing MAY begin when:
- [ ] Code complete and deployed to test environment
- [ ] Unit tests passing with >X% coverage
- [ ] Build is stable (no critical build failures)
- [ ] Test environment available and configured
- [ ] Test data prepared and loaded
- [ ] Required documentation available

## Exit Criteria

Testing is complete when:
- [ ] All planned test cases executed
- [ ] X% of test cases passed
- [ ] All critical/blocker defects resolved
- [ ] All major defects resolved or deferred with approval
- [ ] Regression test suite passed
- [ ] Performance benchmarks met
- [ ] Test summary report reviewed and approved
```

### 4. Risk Assessment

Identify and plan for testing risks.

```markdown
## Risk Assessment

| Risk | Probability | Impact | Mitigation | Contingency |
|------|-------------|--------|------------|-------------|
| Environment instability | Medium | High | Dedicated test env | Use staging as backup |
| Test data unavailable | Low | High | Early data prep | Use synthetic data |
| Resource unavailability | Medium | Medium | Cross-training | Prioritize critical tests |
| Scope creep | High | Medium | Change control | Buffer time in schedule |
| Third-party API failures | Low | High | Mock services | Skip dependent tests |

### Risk Levels
- **Critical:** Requires immediate escalation and mitigation
- **High:** Needs active management and tracking
- **Medium:** Monitor and address as needed
- **Low:** Accept with minimal monitoring
```

### 5. Resource Allocation

Define testing team and responsibilities.

```markdown
## Resource Allocation

### Team Roles
| Role | Name | Responsibilities | Allocation |
|------|------|------------------|------------|
| Test Lead | [Name] | Strategy, reporting, coordination | 100% |
| QA Engineer | [Name] | Test execution, automation | 100% |
| Developer | [Name] | Unit tests, bug fixes | 25% |
| DevOps | [Name] | Environment, CI/CD | 10% |

### Skills Required
- [ ] [Skill 1]: [Available/Training needed]
- [ ] [Skill 2]: [Available/Training needed]

### Tools and Infrastructure
| Tool | Purpose | License | Status |
|------|---------|---------|--------|
| [Tool 1] | Test automation | Enterprise | Available |
| [Tool 2] | Test management | SaaS | Needed |
```

### 6. Test Deliverables

Define what documentation will be produced.

```markdown
## Test Deliverables

| Deliverable | Owner | Due Date | Status |
|-------------|-------|----------|--------|
| Test Plan | Test Lead | [Date] | In Progress |
| Test Cases | QA Team | [Date] | Not Started |
| Test Data | QA Team | [Date] | Not Started |
| Automation Scripts | QA Engineer | [Date] | Not Started |
| Test Summary Report | Test Lead | [Date] | Not Started |
| Defect Report | QA Team | [Date] | Not Started |
```

### 7. Defect Management

Define how defects are tracked and resolved.

```markdown
## Defect Management

### Severity Levels
| Severity | Definition | Response Time | Resolution Time |
|----------|------------|---------------|-----------------|
| Critical | System down, data loss | 1 hour | 4 hours |
| High | Major feature broken | 4 hours | 24 hours |
| Medium | Feature degraded | 24 hours | 72 hours |
| Low | Minor issue | 48 hours | Next release |

### Defect Workflow
1. **New:** Defect reported with reproduction steps
2. **Triaged:** Severity and priority assigned
3. **Assigned:** Developer assigned for fix
4. **In Progress:** Fix being developed
5. **Fixed:** Fix complete, ready for verification
6. **Verified:** QA confirmed fix works
7. **Closed:** Defect resolved

### Defect Report Template
```text
Title: [Brief description]
Severity: [Critical/High/Medium/Low]
Priority: [P1/P2/P3/P4]
Environment: [Where it was found]
Steps to Reproduce:
  1. [Step 1]
  2. [Step 2]
Expected Result: [What should happen]
Actual Result: [What actually happened]
Attachments: [Screenshots, logs]
```
```

## Test Plan Template

Use this template when creating a new test plan:

```markdown
# Test Plan: [Project/Feature Name]

**Version:** 1.0
**Author:** [Name]
**Date:** [Date]
**Status:** Draft | In Review | Approved

## 1. Introduction

### 1.1 Purpose
[Why this test plan exists]

### 1.2 Scope
[What is being tested and what is not]

### 1.3 References
- [Requirement document]
- [Design document]
- [Related test plans]

## 2. Test Strategy

### 2.1 Testing Levels
[Unit, Integration, E2E, etc.]

### 2.2 Testing Types
[Functional, Performance, Security, etc.]

### 2.3 Test Environment
[Environment details]

### 2.4 Test Data
[Data strategy]

## 3. Entry and Exit Criteria

### 3.1 Entry Criteria
[When testing can begin]

### 3.2 Exit Criteria
[When testing is complete]

## 4. Test Schedule

| Phase | Start Date | End Date | Milestone |
|-------|------------|----------|-----------|
| Test Planning | [Date] | [Date] | Plan approved |
| Test Design | [Date] | [Date] | Cases ready |
| Test Execution | [Date] | [Date] | Tests complete |
| Test Closure | [Date] | [Date] | Report delivered |

## 5. Resource Allocation

[Team, tools, infrastructure]

## 6. Risk Assessment

[Risks and mitigations]

## 7. Deliverables

[What will be produced]

## 8. Approvals

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Test Lead | | | |
| Project Manager | | | |
| Product Owner | | | |
```

## Best Practices

1. **Start early** - Begin test planning during requirements phase
2. **Be specific** - Vague criteria lead to ambiguous outcomes
3. **Prioritize ruthlessly** - Focus on high-risk, high-value areas
4. **Communicate risks** - Escalate blockers early
5. **Review and iterate** - Test plans are living documents
6. **Track metrics** - Measure progress against criteria
7. **Document decisions** - Record why things were included/excluded

## Anti-Patterns to Avoid

- Creating test plans that are never updated
- Setting unrealistic entry/exit criteria
- Ignoring risk assessment until problems occur
- Not allocating sufficient time for test planning
- Treating test plans as bureaucratic paperwork
- Failing to involve stakeholders in planning
