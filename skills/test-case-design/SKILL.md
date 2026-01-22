---
name: test-case-design
description: Design comprehensive test cases using boundary analysis, equivalence partitioning, decision tables, and state transition testing. Use when creating test plans, designing test coverage, or when user asks about testing strategies.
version: 1.0.0
---

# Test Case Design

## When to Use

- Creating test plans or test suites
- Designing comprehensive test coverage
- Reviewing existing test coverage for gaps
- When user asks about testing strategies
- Identifying edge cases and boundary conditions
- Testing complex business logic with multiple conditions

## When NOT to Use

- Simple unit tests with obvious inputs
- When user already has specific test cases defined
- Performance or load testing (different techniques)
- Security penetration testing

## Test Design Techniques

### 1. Equivalence Partitioning

Divide inputs into groups (partitions) where all values in a partition should behave identically.

#### Process

1. Identify input parameters
2. Divide each parameter into valid and invalid partitions
3. Select one representative value from each partition
4. Create test cases covering each partition

#### Example

For a function `validateAge(age)` where valid age is 18-65:

| Partition | Range | Representative Value | Expected Result |
|-----------|-------|---------------------|-----------------|
| Invalid (too low) | < 18 | 10 | Invalid |
| Valid | 18-65 | 35 | Valid |
| Invalid (too high) | > 65 | 80 | Invalid |
| Invalid (negative) | < 0 | -5 | Invalid |
| Invalid (non-numeric) | N/A | "abc" | Invalid |

### 2. Boundary Value Analysis

Test at the edges of equivalence partitions where defects often occur.

#### Process

1. Identify boundaries of each partition
2. Test at: minimum, minimum-1, minimum+1, maximum-1, maximum, maximum+1
3. Include special values: 0, empty, null

#### Example

For `validateAge(age)` with valid range 18-65:

| Boundary | Value | Expected Result |
|----------|-------|-----------------|
| Below minimum | 17 | Invalid |
| At minimum | 18 | Valid |
| Above minimum | 19 | Valid |
| Below maximum | 64 | Valid |
| At maximum | 65 | Valid |
| Above maximum | 66 | Invalid |
| Zero | 0 | Invalid |
| Null | null | Invalid |

### 3. Decision Tables

Test combinations of conditions and their resulting actions. Essential for complex business rules.

#### Process

1. List all conditions (inputs)
2. List all possible actions (outputs)
3. Create columns for each condition combination
4. Mark which actions occur for each combination

#### Example

Shipping discount rules:
- Condition 1: Order > $100
- Condition 2: Premium member
- Condition 3: Holiday sale active

| Rule | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|------|---|---|---|---|---|---|---|---|
| **Conditions** |
| Order > $100 | Y | Y | Y | Y | N | N | N | N |
| Premium member | Y | Y | N | N | Y | Y | N | N |
| Holiday sale | Y | N | Y | N | Y | N | Y | N |
| **Actions** |
| 30% discount | X | | | | | | | |
| 20% discount | | X | X | | X | | | |
| 10% discount | | | | X | | X | X | |
| No discount | | | | | | | | X |

#### Decision Table Template

```markdown
| Rule | 1 | 2 | 3 | 4 |
|------|---|---|---|---|
| **Conditions** |
| Condition A | Y | Y | N | N |
| Condition B | Y | N | Y | N |
| **Actions** |
| Action 1 | X | | | |
| Action 2 | | X | X | |
| Action 3 | | | | X |
```

### 4. State Transition Testing

Test how a system moves between different states based on events.

#### Process

1. Identify all possible states
2. Identify events that trigger transitions
3. Create state transition diagram
4. Derive test cases to cover all transitions

#### Example

Order Status System:

```
States: [Created] -> [Confirmed] -> [Shipped] -> [Delivered]
                  \-> [Cancelled]
```

| Test | Start State | Event | Expected End State |
|------|-------------|-------|-------------------|
| TC1 | Created | confirm() | Confirmed |
| TC2 | Created | cancel() | Cancelled |
| TC3 | Confirmed | ship() | Shipped |
| TC4 | Confirmed | cancel() | Cancelled |
| TC5 | Shipped | deliver() | Delivered |
| TC6 | Shipped | cancel() | Error (cannot cancel) |
| TC7 | Delivered | cancel() | Error (cannot cancel) |
| TC8 | Cancelled | confirm() | Error (cannot confirm) |

#### State Transition Matrix

| Current State | confirm() | cancel() | ship() | deliver() |
|--------------|-----------|----------|--------|-----------|
| Created | Confirmed | Cancelled | - | - |
| Confirmed | - | Cancelled | Shipped | - |
| Shipped | - | Error | - | Delivered |
| Delivered | - | Error | - | - |
| Cancelled | Error | - | - | - |

## Test Case Template

Use this format for documenting test cases:

```markdown
### TC-[ID]: [Brief Description]

**Technique:** [Boundary/Equivalence/Decision/State]
**Priority:** [High/Medium/Low]
**Preconditions:**
- [Required state before test]

**Test Steps:**
1. [Step 1]
2. [Step 2]

**Test Data:**
- Input: [values]

**Expected Result:**
- [What should happen]

**Actual Result:**
- [Fill in during execution]

**Status:** [Pass/Fail/Blocked]
```

## Coverage Guidelines

### Minimum Coverage

| Technique | Minimum Requirement |
|-----------|-------------------|
| Equivalence Partitioning | All partitions covered |
| Boundary Analysis | All boundaries tested |
| Decision Tables | All rule combinations |
| State Transition | All transitions covered |

### Comprehensive Coverage

- **0-switch coverage**: Cover all valid single transitions
- **1-switch coverage**: Cover all valid pairs of consecutive transitions
- **Invalid transitions**: Test that invalid transitions are properly rejected

## Combining Techniques

For thorough testing, combine techniques:

1. **Start with Equivalence Partitioning** to identify input groups
2. **Apply Boundary Analysis** to partition boundaries
3. **Use Decision Tables** for complex condition combinations
4. **Add State Transition** for stateful components
5. **Review for missing edge cases**

## Output Format

When designing test cases, provide:

```markdown
## Test Design for [Feature Name]

### Analysis

**Input Parameters:**
- Parameter 1: [type, constraints]
- Parameter 2: [type, constraints]

**Equivalence Partitions:**
| Parameter | Partition | Values | Valid/Invalid |
|-----------|-----------|--------|---------------|
| ... | ... | ... | ... |

**Boundaries:**
| Parameter | Boundary | Test Values |
|-----------|----------|-------------|
| ... | ... | ... |

### Test Cases

[Use test case template for each case]

### Coverage Summary

- Total test cases: X
- Equivalence partitions covered: X/Y
- Boundaries tested: X/Y
- Decision rules covered: X/Y
- State transitions covered: X/Y
```

## Best Practices

1. **Prioritize** - Focus on high-risk areas first
2. **Be systematic** - Don't rely on intuition alone
3. **Document assumptions** - Note what's not tested and why
4. **Review with stakeholders** - Validate test coverage
5. **Automate where possible** - Parameterized tests for partitions/boundaries
6. **Maintain traceability** - Link test cases to requirements
