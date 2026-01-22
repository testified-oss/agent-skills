---
name: postmortem-template
description: Create blameless postmortem documents with timeline reconstruction, contributing factors analysis, action items, and prevention measures. Use after incidents are resolved to capture learnings and prevent recurrence.
version: 1.0.0
---

# Postmortem Template

## When to Use

- After resolving production incidents (SEV-1, SEV-2)
- Following significant outages or service disruptions
- When security incidents require documentation
- After near-misses that could have been serious
- When organizational learning from incidents is needed
- Creating incident retrospectives for stakeholders
- Building a knowledge base of failure patterns

## When NOT to Use

- During active incident response (use incident-triage skill instead)
- For minor bugs or issues with no production impact
- When incident is still under investigation
- For planned maintenance or expected downtime
- When immediate blame assignment is desired (violates blameless principles)

## Blameless Postmortem Principles

A blameless postmortem focuses on **systems and processes**, not individuals:

| Principle | Description |
|-----------|-------------|
| **Assume good intent** | People made the best decisions with available information |
| **Focus on systems** | Ask "what allowed this to happen?" not "who caused this?" |
| **No blame, no shame** | Create safety for honest discussion |
| **Learn, don't punish** | Goal is improvement, not discipline |
| **Multiple causes** | Incidents rarely have a single root cause |
| **Seek understanding** | "How did it make sense to do X at the time?" |

### Blameless Language Guide

| Instead of... | Use... |
|---------------|--------|
| "John caused the outage" | "The deployment process allowed an untested change" |
| "Sarah made a mistake" | "The system lacked safeguards against this action" |
| "The engineer should have known" | "The documentation/training didn't cover this scenario" |
| "Human error" | "The interface design permitted incorrect input" |
| "Carelessness" | "The process lacked verification steps" |

## Postmortem Document Template

```markdown
# Postmortem: [Incident Title]

**Incident ID:** [INC-XXXX]
**Date:** [YYYY-MM-DD]
**Author:** [Name]
**Status:** Draft | In Review | Final
**Severity:** SEV-1 | SEV-2 | SEV-3

## Executive Summary

[2-3 sentence summary: what happened, impact, how it was resolved]

**Duration:** [Start time] - [End time] ([X hours Y minutes])
**Time to Detect:** [X minutes]
**Time to Resolve:** [X hours]
**Customer Impact:** [Brief description of user-facing impact]

---

## Timeline

All times in [timezone].

| Time | Event |
|------|-------|
| HH:MM | [Triggering event or change] |
| HH:MM | [First symptoms observed] |
| HH:MM | [Alert fired / Incident reported] |
| HH:MM | [Triage began] |
| HH:MM | [Root cause identified] |
| HH:MM | [Mitigation applied] |
| HH:MM | [Service restored] |
| HH:MM | [Incident declared resolved] |

---

## Impact Assessment

### User Impact
- **Users Affected:** [Number or percentage]
- **Geographic Regions:** [Affected regions]
- **Duration of Impact:** [Time users experienced issues]

### Business Impact
- **Revenue Impact:** $[amount] (estimated)
- **SLA Status:** [Met / Breached - details]
- **Support Tickets:** [Number created]
- **Customer Escalations:** [Number and severity]

### Technical Impact
- **Services Affected:** [List of services]
- **Data Impact:** [None / Delayed / Lost - details]
- **Dependent Systems:** [Downstream effects]

---

## Contributing Factors

### Primary Factors

1. **[Factor 1 Title]**
   - **Description:** [What happened]
   - **Why it mattered:** [How it contributed to the incident]
   - **Evidence:** [Logs, metrics, observations]

2. **[Factor 2 Title]**
   - **Description:** [What happened]
   - **Why it mattered:** [How it contributed]
   - **Evidence:** [Supporting data]

### Secondary Factors

- [Factor that amplified impact or delayed resolution]
- [Process gap that allowed the primary cause]
- [Missing safeguard or detection mechanism]

### Environmental Factors

- [Timing considerations - peak traffic, maintenance window]
- [Team capacity - on-call coverage, expertise availability]
- [External dependencies - third-party status]

---

## Root Cause Analysis

### The Five Whys

1. **Why did [symptom] occur?**
   → Because [cause 1]

2. **Why did [cause 1] happen?**
   → Because [cause 2]

3. **Why did [cause 2] happen?**
   → Because [cause 3]

4. **Why did [cause 3] happen?**
   → Because [cause 4]

5. **Why did [cause 4] happen?**
   → Because [root cause]

### Root Cause Summary

[1-2 paragraph summary of the root cause(s), focusing on systemic issues rather than individual actions]

---

## What Went Well

- [Effective alert that caught the issue quickly]
- [Team coordination during incident]
- [Runbook that helped with resolution]
- [Communication that kept stakeholders informed]

## What Went Poorly

- [Detection delay or missed alerts]
- [Missing runbook or documentation]
- [Communication gaps]
- [Tool or process limitations]

## Where We Got Lucky

- [Factors that could have made this worse]
- [Near-misses during resolution]
- [Timing that reduced impact]

---

## Action Items

### Immediate (< 1 week)

| ID | Action | Owner | Due Date | Status |
|----|--------|-------|----------|--------|
| A1 | [Specific action to prevent recurrence] | [Name] | [Date] | Open |
| A2 | [Immediate mitigation measure] | [Name] | [Date] | Open |

### Short-term (< 1 month)

| ID | Action | Owner | Due Date | Status |
|----|--------|-------|----------|--------|
| A3 | [Process improvement] | [Name] | [Date] | Open |
| A4 | [Monitoring enhancement] | [Name] | [Date] | Open |

### Long-term (< 1 quarter)

| ID | Action | Owner | Due Date | Status |
|----|--------|-------|----------|--------|
| A5 | [Architectural change] | [Name] | [Date] | Open |
| A6 | [Systemic improvement] | [Name] | [Date] | Open |

---

## Prevention Measures

### Detection Improvements
- [ ] [New alert or monitoring to catch this earlier]
- [ ] [Dashboard or visibility enhancement]

### Prevention Controls
- [ ] [Automated safeguard to prevent recurrence]
- [ ] [Process gate or approval requirement]
- [ ] [Validation or testing improvement]

### Response Improvements
- [ ] [Runbook creation or update]
- [ ] [Training or knowledge sharing]
- [ ] [Tool or automation improvement]

---

## Appendix

### Supporting Data
- [Link to logs]
- [Link to metrics/dashboards]
- [Link to related incidents]

### Participants
- **Incident Commander:** [Name]
- **Investigators:** [Names]
- **Postmortem Author:** [Name]
- **Reviewers:** [Names]

### Document History
| Date | Author | Changes |
|------|--------|---------|
| [Date] | [Name] | Initial draft |
| [Date] | [Name] | Added action items |
```

## Timeline Reconstruction

Building an accurate timeline is critical. Follow this process:

### 1. Gather Data Sources

| Source | What to Look For |
|--------|------------------|
| **Monitoring/APM** | Error rates, latency changes, anomalies |
| **Log aggregation** | Error messages, exceptions, warnings |
| **Deployment tools** | Recent deploys, config changes |
| **Incident chat** | First reports, updates, decisions |
| **Alert history** | What fired, when, acknowledgments |
| **Change management** | Approved changes in timeframe |

### 2. Anchor Events

Identify key moments:

- **Trigger:** What initiated the incident?
- **Detection:** When was the issue first noticed?
- **Escalation:** When were additional people involved?
- **Identification:** When was the cause understood?
- **Mitigation:** When was impact reduced?
- **Resolution:** When was normal service restored?

### 3. Timeline Template

```markdown
## Detailed Timeline

### Pre-Incident
- **[T-24h]** [Relevant changes or conditions]
- **[T-1h]** [Immediate precursors]

### Incident Active
- **[T+0]** [Triggering event]
- **[T+5m]** [First observable symptom]
- **[T+10m]** [Alert fired]
- **[T+15m]** [On-call acknowledged]
- **[T+30m]** [Initial hypothesis formed]
- **[T+45m]** [Root cause identified]
- **[T+60m]** [Mitigation applied]

### Post-Incident
- **[T+2h]** [Verification complete]
- **[T+24h]** [Postmortem scheduled]
```

## Contributing Factors Analysis

Identify factors at multiple levels:

### Technical Factors

```markdown
| Category | Questions | Example Findings |
|----------|-----------|------------------|
| **Code** | What code contributed? | Missing null check, race condition |
| **Config** | What configuration was involved? | Incorrect timeout, wrong endpoint |
| **Infrastructure** | What infra limitations existed? | Insufficient capacity, single point of failure |
| **Dependencies** | What external factors? | Third-party API latency, network issues |
```

### Process Factors

```markdown
| Category | Questions | Example Findings |
|----------|-----------|------------------|
| **Testing** | What wasn't tested? | No load testing, missing edge cases |
| **Review** | What review gaps existed? | No security review, rushed approval |
| **Deployment** | What deployment issues? | No canary, missing rollback plan |
| **Monitoring** | What wasn't monitored? | Missing alert, no dashboard |
```

### Organizational Factors

```markdown
| Category | Questions | Example Findings |
|----------|-----------|------------------|
| **Knowledge** | What wasn't known? | Undocumented dependency, tribal knowledge |
| **Communication** | What wasn't communicated? | No handoff, missed status page update |
| **Resources** | What constraints existed? | Short staffed, competing priorities |
| **Incentives** | What pressures contributed? | Deadline pressure, velocity metrics |
```

## Action Item Best Practices

### SMART Action Items

Every action item should be:

- **S**pecific: Clearly defined deliverable
- **M**easurable: Know when it's done
- **A**ssignable: Single owner
- **R**ealistic: Achievable within timeframe
- **T**ime-bound: Concrete due date

### Good vs Bad Action Items

| Bad | Good |
|-----|------|
| "Improve monitoring" | "Add alert for error rate > 1% on /api/auth" |
| "Be more careful" | "Add pre-deploy checklist to CI pipeline" |
| "Review code better" | "Require 2 approvers for changes to payment module" |
| "Fix the bug" | "Add null check in UserService.getProfile()" |
| "Document the process" | "Create runbook for database failover by [date]" |

### Action Item Categories

| Category | Purpose | Examples |
|----------|---------|----------|
| **Detect** | Find issues faster | Alerts, dashboards, health checks |
| **Prevent** | Stop issues from occurring | Validation, guards, automation |
| **Mitigate** | Reduce impact when issues occur | Circuit breakers, fallbacks, caching |
| **Respond** | Improve incident response | Runbooks, training, tooling |

## Postmortem Meeting Facilitation

### Agenda (60-90 minutes)

1. **Introduction** (5 min)
   - Set blameless tone
   - Review incident summary

2. **Timeline Review** (15 min)
   - Walk through events
   - Clarify and correct details

3. **Contributing Factors** (20 min)
   - Discuss technical factors
   - Identify process gaps
   - Note organizational factors

4. **Action Items** (20 min)
   - Brainstorm improvements
   - Assign owners
   - Set due dates

5. **What Went Well** (10 min)
   - Celebrate good responses
   - Identify practices to keep

6. **Wrap-up** (5 min)
   - Summarize key learnings
   - Confirm next steps

### Facilitation Tips

- **Start with impact, not blame:** "Let's understand what happened to our users"
- **Use "we" language:** "How can we prevent this?" not "How can you prevent this?"
- **Encourage participation:** "What do others think?" "What am I missing?"
- **Redirect blame:** "Let's focus on the system—what allowed this to happen?"
- **Timebox discussions:** Keep moving to cover all sections
- **Capture everything:** Document questions even without answers

## Output Format

When creating a postmortem, provide:

```markdown
## Postmortem Draft: [Incident Title]

### Quick Summary
- **What happened:** [Brief description]
- **Impact:** [User and business impact]
- **Duration:** [How long]
- **Root cause:** [Primary cause]

### Key Learnings
1. [Learning 1]
2. [Learning 2]
3. [Learning 3]

### Priority Action Items
1. [ ] [Most important action] - Owner: [Name] - Due: [Date]
2. [ ] [Second action] - Owner: [Name] - Due: [Date]
3. [ ] [Third action] - Owner: [Name] - Due: [Date]

### Full Document
[Complete postmortem using template above]
```

## Best Practices

1. **Write postmortems promptly** - Within 48-72 hours while memory is fresh
2. **Include diverse perspectives** - Engineers, ops, support, and affected stakeholders
3. **Focus on systemic issues** - Individual actions are symptoms of system failures
4. **Be thorough but concise** - Enough detail to learn, not so much it's unread
5. **Follow up on action items** - Review completion in team meetings
6. **Share broadly** - Publish internally to spread learnings
7. **Build a searchable archive** - Future incidents benefit from past learnings
8. **Celebrate learning** - Postmortems are opportunities, not punishments
