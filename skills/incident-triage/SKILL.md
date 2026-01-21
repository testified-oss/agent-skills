---
name: incident-triage
description: Triage production incidents with severity assessment, root cause hypothesis, impact analysis, and escalation recommendations. Use when analyzing outages, errors, or production issues.
version: 1.0.0
---

# Incident Triage

## When to Use

- Responding to production incidents or outages
- Analyzing error spikes or anomalies
- Assessing severity of reported issues
- Determining root cause hypotheses
- Evaluating customer/business impact
- Deciding on escalation paths
- Post-incident analysis and review

## When NOT to Use

- Development environment issues (use debugging skills instead)
- Feature requests or enhancements
- Non-urgent bug reports with no production impact
- When incident is already resolved and documented

## Triage Process

Follow this systematic approach for every incident:

### 1. Initial Assessment (First 5 minutes)

```markdown
## Incident Summary
- **Reported At:** [timestamp]
- **Reported By:** [source/person]
- **Initial Symptom:** [what was observed]
- **Affected System:** [service/component name]
```

### 2. Severity Assessment

Classify the incident using this severity matrix:

| Severity | Impact | Examples | Response Time |
|----------|--------|----------|---------------|
| **SEV-1 (Critical)** | Complete outage, data loss, security breach | Service down for all users, data corruption, unauthorized access | Immediate (< 15 min) |
| **SEV-2 (High)** | Major feature broken, significant user impact | Payment processing failing, login broken for subset | < 30 minutes |
| **SEV-3 (Medium)** | Degraded performance, workaround exists | Slow response times, intermittent errors | < 2 hours |
| **SEV-4 (Low)** | Minor issue, minimal user impact | UI glitch, non-critical feature affected | < 24 hours |

#### Severity Decision Factors

- **User Impact:** How many users affected? Which user segments?
- **Revenue Impact:** Is money being lost? How much per hour?
- **Data Risk:** Is data integrity or security at risk?
- **Reputation:** Is this publicly visible? Media/social attention?
- **Contractual:** Are SLAs being violated?

### 3. Impact Analysis

Document the blast radius:

```markdown
## Impact Analysis

### Affected Components
- [ ] Frontend/UI
- [ ] API/Backend
- [ ] Database
- [ ] Third-party integrations
- [ ] Infrastructure

### User Impact
- **Users Affected:** [number/percentage]
- **Regions Affected:** [list regions]
- **Customer Tiers:** [enterprise/pro/free]

### Business Impact
- **Revenue at Risk:** $[amount]/hour
- **SLA Status:** [within/breaching]
- **Reputational Risk:** [low/medium/high]
```

### 4. Root Cause Hypothesis

Generate hypotheses based on available data:

```markdown
## Root Cause Hypotheses

### Hypothesis 1: [Most Likely]
- **Theory:** [description]
- **Supporting Evidence:** [what points to this]
- **Contradicting Evidence:** [what doesn't fit]
- **Confidence:** [high/medium/low]
- **Investigation Steps:**
  1. [step 1]
  2. [step 2]

### Hypothesis 2: [Alternative]
- **Theory:** [description]
- **Supporting Evidence:** [evidence]
- **Confidence:** [level]
```

#### Common Root Cause Categories

| Category | Indicators | First Steps |
|----------|------------|-------------|
| **Deployment** | Recent deploy, gradual rollout issues | Check deploy logs, rollback |
| **Capacity** | High CPU/memory, request timeouts | Scale up, check autoscaling |
| **Dependency** | External service errors, timeout patterns | Check status pages, circuit breakers |
| **Data** | Query errors, migration issues | Check DB logs, recent migrations |
| **Configuration** | Feature flag changes, config updates | Review recent config changes |
| **Network** | DNS issues, connectivity problems | Check network status, DNS resolution |
| **Security** | Auth failures, rate limiting | Review auth logs, check for attacks |

### 5. Escalation Recommendations

```markdown
## Escalation Path

### Immediate Notifications
- [ ] On-call engineer: [name/team]
- [ ] Team lead: [name]
- [ ] Stakeholders: [list]

### Escalation Triggers
- If not resolved in [X] minutes → Escalate to [team/person]
- If data integrity confirmed → Escalate to [security/data team]
- If customer-facing SLA breach → Notify [customer success]

### Communication Plan
- **Internal:** [Slack channel, frequency]
- **External:** [Status page update needed? Customer comms?]
```

## Escalation Matrix

| Severity | Primary | Backup | Management | Customer Comms |
|----------|---------|--------|------------|----------------|
| SEV-1 | On-call + Team Lead | Director | VP within 30 min | Immediate |
| SEV-2 | On-call | Team Lead | Director if > 1hr | If > 30 min |
| SEV-3 | On-call | N/A | Daily standup | If requested |
| SEV-4 | Ticket owner | On-call | N/A | N/A |

## Triage Report Template

Use this template for documenting the triage:

```markdown
# Incident Triage Report

## Summary
- **Incident ID:** [INC-XXXX]
- **Severity:** [SEV-1/2/3/4]
- **Status:** [investigating/identified/monitoring/resolved]
- **Started:** [timestamp]
- **Duration:** [ongoing/X hours]

## What Happened
[Brief description of the incident]

## Impact
- **Users Affected:** [count/percentage]
- **Services Affected:** [list]
- **Business Impact:** [description]

## Root Cause
- **Confirmed/Suspected:** [status]
- **Category:** [deployment/capacity/dependency/etc.]
- **Description:** [detailed explanation]

## Timeline
| Time | Event |
|------|-------|
| HH:MM | Incident detected |
| HH:MM | Triage started |
| HH:MM | Root cause identified |
| HH:MM | Mitigation applied |

## Actions Taken
1. [Action 1]
2. [Action 2]

## Escalations
- [Who was notified and when]

## Next Steps
- [ ] [Immediate action]
- [ ] [Follow-up action]
- [ ] [Post-incident review scheduled]
```

## Quick Triage Checklist

For rapid assessment, work through this checklist:

- [ ] **Verify the incident** - Is this real? Can you reproduce?
- [ ] **Check for recent changes** - Deploys in last 24h? Config changes?
- [ ] **Check monitoring** - What do metrics/logs show?
- [ ] **Assess severity** - Use the severity matrix above
- [ ] **Identify affected scope** - Users, regions, services
- [ ] **Form hypothesis** - Most likely cause based on evidence
- [ ] **Determine escalation** - Who needs to know? Who can help?
- [ ] **Start communication** - Update status page/Slack as needed
- [ ] **Document everything** - Timeline, actions, decisions

## Best Practices

1. **Stay calm** - Panic spreads and impairs judgment
2. **Communicate early** - Silence creates anxiety; updates build trust
3. **Don't assume** - Verify before acting on hunches
4. **Document as you go** - Memory is unreliable under stress
5. **Timebox investigations** - Set checkpoints to reassess approach
6. **Know when to escalate** - Pride shouldn't delay resolution
7. **Preserve evidence** - Don't destroy logs/state needed for RCA
8. **One incident commander** - Clear ownership prevents confusion
