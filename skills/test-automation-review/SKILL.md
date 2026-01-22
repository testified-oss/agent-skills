---
name: test-automation-review
description: Review test automation code for quality patterns including page objects, test data management, assertion quality, flaky test detection, and maintainability. Use when reviewing test code, auditing test suites, or improving test architecture.
version: 1.0.0
---

# Test Automation Review

## When to Use

- Reviewing pull requests containing test automation code
- Auditing existing test suites for quality and maintainability
- Evaluating page object model implementations
- Identifying and fixing flaky tests
- Improving test data management strategies
- Assessing assertion quality and coverage
- Establishing test automation best practices for a team
- Refactoring legacy test code

## When NOT to Use

- Reviewing unit tests for business logic (use code-review skill)
- Designing test cases from scratch (use test-case-design skill)
- Performance or load testing setup
- Manual test case review

## Review Checklist

### Quick Reference

| Category | Key Questions |
|----------|---------------|
| **Page Objects** | Is UI logic separated from test logic? |
| **Test Data** | Is data isolated, manageable, and realistic? |
| **Assertions** | Are assertions specific, meaningful, and complete? |
| **Flakiness** | Are there race conditions, hard waits, or dependencies? |
| **Maintainability** | Is the code DRY, readable, and well-organized? |

## Page Object Patterns

Page objects encapsulate UI structure and behavior, separating what the test does from how it interacts with the UI.

### Page Object Review Checklist

- [ ] Each page/component has its own page object class
- [ ] Selectors are defined as private/protected properties
- [ ] Methods represent user actions, not implementation details
- [ ] Page objects return other page objects for navigation
- [ ] No assertions inside page objects (with rare exceptions)
- [ ] Selectors use stable attributes (data-testid, aria-label) over CSS classes
- [ ] Reusable components have their own component objects

### Page Object Patterns

#### Good Pattern: Action-Oriented Methods

```typescript
// ✅ GOOD: Methods describe user intent
class LoginPage {
  private usernameInput = '[data-testid="username"]';
  private passwordInput = '[data-testid="password"]';
  private submitButton = '[data-testid="login-submit"]';

  async login(username: string, password: string): Promise<DashboardPage> {
    await this.enterUsername(username);
    await this.enterPassword(password);
    await this.clickSubmit();
    return new DashboardPage();
  }

  private async enterUsername(username: string): Promise<void> {
    await this.page.fill(this.usernameInput, username);
  }
}
```

#### Anti-Pattern: Exposed Implementation

```typescript
// ❌ BAD: Test knows about implementation details
class LoginPage {
  public usernameInput = '#user-name-field';  // Exposed selector
  
  async typeInField(selector: string, text: string) {  // Generic method
    await this.page.type(selector, text);
  }
}

// Test using anti-pattern
test('login', async () => {
  await loginPage.typeInField(loginPage.usernameInput, 'user');  // Coupled to selectors
});
```

### Selector Strategy Review

| Priority | Selector Type | Example | Stability |
|----------|---------------|---------|-----------|
| 1 | data-testid | `[data-testid="submit-btn"]` | Most stable |
| 2 | aria-label | `[aria-label="Submit form"]` | Stable, accessible |
| 3 | Semantic HTML | `button[type="submit"]` | Moderately stable |
| 4 | ID | `#submit-button` | Stable if not generated |
| 5 | CSS class | `.btn-primary` | Unstable, avoid |
| 6 | XPath position | `//div[3]/button` | Very unstable, avoid |

### Page Object Issues to Flag

| Issue | Symptom | Recommendation |
|-------|---------|----------------|
| **God Object** | Single page object > 500 lines | Split into component objects |
| **Selector Duplication** | Same selector in multiple files | Create shared component object |
| **Leaky Abstraction** | Tests reference selectors directly | Encapsulate in page object methods |
| **Missing Wait Logic** | Implicit waits scattered in tests | Add explicit waits in page objects |
| **Assertion Creep** | Page objects contain assertions | Move assertions to test files |

## Test Data Management

Effective test data management ensures tests are reliable, independent, and maintainable.

### Test Data Review Checklist

- [ ] Tests create their own data (no shared state between tests)
- [ ] Test data is cleaned up after test completion
- [ ] Realistic data used (not just "test123" everywhere)
- [ ] Sensitive data is not hardcoded (use environment variables or fixtures)
- [ ] Data factories or builders are used for complex objects
- [ ] Database state is reset between test runs
- [ ] Test data files are version controlled
- [ ] No dependency on production data or external systems

### Data Management Patterns

#### Good Pattern: Factory/Builder for Test Data

```typescript
// ✅ GOOD: Factory creates consistent, customizable data
class UserFactory {
  static create(overrides: Partial<User> = {}): User {
    return {
      id: faker.datatype.uuid(),
      email: faker.internet.email(),
      name: faker.name.fullName(),
      role: 'user',
      createdAt: new Date(),
      ...overrides
    };
  }

  static createAdmin(overrides: Partial<User> = {}): User {
    return this.create({ role: 'admin', ...overrides });
  }
}

// Usage in tests
test('admin can delete user', async () => {
  const admin = UserFactory.createAdmin();
  const targetUser = UserFactory.create();
  // ...
});
```

#### Anti-Pattern: Hardcoded Test Data

```typescript
// ❌ BAD: Hardcoded, fragile test data
test('user registration', async () => {
  await registerUser({
    email: 'test@test.com',    // Will conflict with parallel tests
    password: 'password123',   // Hardcoded, may violate password rules
    name: 'Test User'          // Not representative of real data
  });
});
```

### Test Data Strategy Matrix

| Scenario | Strategy | Example |
|----------|----------|---------|
| **Simple objects** | Inline with factories | `UserFactory.create()` |
| **Complex scenarios** | Fixture files | `fixtures/checkout-scenario.json` |
| **Database state** | Seeding scripts | `npm run seed:test` |
| **API mocking** | Response fixtures | `__mocks__/api/users.json` |
| **Environment-specific** | Config files | `test.config.ts` |

### Test Data Issues to Flag

| Issue | Symptom | Recommendation |
|-------|---------|----------------|
| **Shared Mutable State** | Tests fail when run in parallel | Isolate data per test |
| **Stale Fixtures** | Fixtures don't match current schema | Add fixture validation |
| **Magic Values** | Unexplained strings/numbers in tests | Use named constants or factories |
| **Missing Cleanup** | Tests leave data behind | Implement cleanup hooks |
| **External Dependencies** | Tests call real APIs | Mock external services |

## Assertion Quality

Good assertions are specific, meaningful, and provide clear failure messages.

### Assertion Review Checklist

- [ ] Each test has at least one assertion
- [ ] Assertions verify the right thing (not just "something happened")
- [ ] Custom error messages explain what failed and why
- [ ] Assertions are specific (exact values, not just truthiness)
- [ ] Multiple related assertions are grouped logically
- [ ] Soft assertions used when checking multiple independent conditions
- [ ] No assertions in loops without clear purpose
- [ ] Negative test cases assert expected failures

### Assertion Patterns

#### Good Pattern: Specific, Meaningful Assertions

```typescript
// ✅ GOOD: Specific assertions with clear failure messages
test('user profile displays correct information', async () => {
  const user = UserFactory.create({ name: 'Jane Doe', email: 'jane@example.com' });
  await profilePage.load(user.id);

  expect(await profilePage.getName()).toBe(user.name);
  expect(await profilePage.getEmail()).toBe(user.email);
  expect(await profilePage.isVerifiedBadgeVisible()).toBe(true);
});

// With custom error messages
expect(actualBalance).toBe(expectedBalance, 
  `Expected balance ${expectedBalance} after withdrawal, got ${actualBalance}`);
```

#### Anti-Pattern: Weak Assertions

```typescript
// ❌ BAD: Vague, unhelpful assertions
test('login works', async () => {
  await loginPage.login('user', 'pass');
  
  expect(page.url()).toBeTruthy();         // Passes even on error page
  expect(await page.content()).toBeDefined(); // Always true
  expect(result).not.toBeNull();           // Doesn't verify correctness
});
```

### Assertion Quality Matrix

| Quality Level | Characteristics | Example |
|---------------|-----------------|---------|
| **Strong** | Verifies exact expected state | `expect(user.role).toBe('admin')` |
| **Moderate** | Verifies type/structure | `expect(users).toHaveLength(3)` |
| **Weak** | Only checks existence | `expect(user).toBeDefined()` |
| **Missing** | No assertion | Test with only actions |

### Assertion Anti-Patterns to Flag

| Anti-Pattern | Example | Better Alternative |
|--------------|---------|-------------------|
| **Boolean blindness** | `expect(isValid).toBe(true)` | `expect(validation.errors).toEqual([])` |
| **Snapshot overuse** | Snapshot for dynamic data | Specific property assertions |
| **Assertion roulette** | Multiple assertions, unclear which failed | One assertion per test or soft assertions |
| **Hidden assertion** | Assertion in helper function | Make assertions explicit in test |
| **Missing negative test** | Only testing happy path | Add error case assertions |

### Soft Assertions

Use soft assertions to check multiple independent conditions:

```typescript
// ✅ GOOD: Soft assertions collect all failures
test('form validation shows all errors', async ({ expect }) => {
  await formPage.submitEmpty();

  await expect.soft(formPage.getError('name')).toBe('Name is required');
  await expect.soft(formPage.getError('email')).toBe('Email is required');
  await expect.soft(formPage.getError('password')).toBe('Password is required');
  // All errors reported, even if first fails
});
```

## Flaky Test Detection

Flaky tests pass and fail intermittently without code changes, eroding confidence in the test suite.

### Flaky Test Review Checklist

- [ ] No hardcoded waits (`sleep(5000)`)
- [ ] Explicit waits for specific conditions
- [ ] No race conditions between test steps
- [ ] Tests don't depend on execution order
- [ ] Proper handling of animations and transitions
- [ ] Network requests are waited for or mocked
- [ ] No reliance on external services without mocking
- [ ] Date/time is controlled, not using `new Date()`
- [ ] Random data doesn't affect assertions
- [ ] Retry logic only for known flaky external dependencies

### Common Flakiness Patterns

#### Timing Issues

```typescript
// ❌ BAD: Hardcoded wait
await page.click('#submit');
await page.waitForTimeout(3000);  // Arbitrary wait
expect(await page.getText('#result')).toBe('Success');

// ✅ GOOD: Wait for specific condition
await page.click('#submit');
await page.waitForSelector('#result:has-text("Success")', { state: 'visible' });
expect(await page.getText('#result')).toBe('Success');
```

#### Race Conditions

```typescript
// ❌ BAD: Race condition with async operation
await page.click('#load-data');
const text = await page.getText('#data');  // May get old/empty text
expect(text).toBe('Loaded');

// ✅ GOOD: Wait for state change
await page.click('#load-data');
await page.waitForFunction(() => 
  document.querySelector('#data')?.textContent === 'Loaded'
);
expect(await page.getText('#data')).toBe('Loaded');
```

#### External Dependencies

```typescript
// ❌ BAD: Depends on external API
test('shows weather', async () => {
  await page.goto('/weather');
  expect(await page.getText('#temp')).toMatch(/\d+°/);  // External API may fail
});

// ✅ GOOD: Mock external dependencies
test('shows weather', async () => {
  await page.route('**/api/weather', route => 
    route.fulfill({ body: JSON.stringify({ temp: 72 }) })
  );
  await page.goto('/weather');
  expect(await page.getText('#temp')).toBe('72°');
});
```

### Flakiness Root Causes

| Category | Symptoms | Solutions |
|----------|----------|-----------|
| **Timing** | Random failures, passes on retry | Use explicit waits, disable animations |
| **Test Order** | Fails in CI, passes locally | Ensure test isolation, reset state |
| **Concurrency** | Fails with parallel execution | Isolate test data, use unique identifiers |
| **Environment** | Works locally, fails in CI | Control environment, use containers |
| **Resources** | Timeout errors, slow tests | Optimize selectors, mock heavy operations |
| **External Services** | Intermittent network failures | Mock external calls, use test doubles |

### Flakiness Detection Strategies

```markdown
## Flakiness Detection Checklist

1. **Static Analysis**
   - [ ] Search for `sleep`, `waitForTimeout`, hardcoded delays
   - [ ] Find tests without explicit waits after actions
   - [ ] Identify global state modifications
   - [ ] Check for `new Date()` without mocking

2. **Runtime Analysis**
   - [ ] Run tests multiple times (10+ iterations)
   - [ ] Run tests in different orders (randomize)
   - [ ] Run tests in parallel
   - [ ] Run in CI environment
   
3. **Historical Analysis**
   - [ ] Track tests that frequently need retries
   - [ ] Monitor tests with inconsistent duration
   - [ ] Review tests that fail only in specific conditions
```

## Maintainability Best Practices

Maintainable test code is readable, well-organized, and easy to update.

### Maintainability Review Checklist

- [ ] Tests have clear, descriptive names
- [ ] Test files organized by feature/module
- [ ] Common setup extracted to before hooks or fixtures
- [ ] Helper functions are reusable and well-documented
- [ ] Magic numbers/strings replaced with named constants
- [ ] Tests follow single responsibility principle
- [ ] Consistent naming conventions throughout
- [ ] Test utilities are in separate files
- [ ] Comments explain "why" not "what"
- [ ] Tests are independent and can run in isolation

### Test Organization Patterns

#### File Structure

```
tests/
├── e2e/
│   ├── auth/
│   │   ├── login.spec.ts
│   │   ├── logout.spec.ts
│   │   └── password-reset.spec.ts
│   └── checkout/
│       ├── cart.spec.ts
│       └── payment.spec.ts
├── fixtures/
│   ├── users.json
│   └── products.json
├── pages/
│   ├── LoginPage.ts
│   ├── DashboardPage.ts
│   └── components/
│       ├── HeaderComponent.ts
│       └── ModalComponent.ts
├── utils/
│   ├── factories/
│   │   └── UserFactory.ts
│   ├── helpers/
│   │   └── apiHelpers.ts
│   └── constants.ts
└── playwright.config.ts
```

#### Test Naming Conventions

```typescript
// ✅ GOOD: Descriptive names following pattern
describe('User Authentication', () => {
  describe('Login', () => {
    it('should successfully login with valid credentials', async () => {});
    it('should display error message for invalid password', async () => {});
    it('should lock account after 5 failed attempts', async () => {});
  });
});

// ❌ BAD: Vague or implementation-focused names
describe('Login', () => {
  it('test1', async () => {});
  it('clicks submit button', async () => {});  // Describes action, not outcome
  it('works', async () => {});
});
```

### DRY Principles in Tests

#### Good Pattern: Reusable Setup

```typescript
// ✅ GOOD: Shared setup with customization
class TestContext {
  static async withAuthenticatedUser(
    options: { role?: string } = {}
  ): Promise<{ user: User; page: Page }> {
    const user = await UserFactory.create(options);
    const page = await browser.newPage();
    await loginAs(page, user);
    return { user, page };
  }
}

test('admin can view all users', async () => {
  const { page } = await TestContext.withAuthenticatedUser({ role: 'admin' });
  // ...
});
```

#### Anti-Pattern: Copy-Paste Tests

```typescript
// ❌ BAD: Duplicated setup in every test
test('test 1', async () => {
  await page.goto('/login');
  await page.fill('#email', 'admin@test.com');
  await page.fill('#password', 'password');
  await page.click('#submit');
  await page.waitForNavigation();
  // actual test...
});

test('test 2', async () => {
  await page.goto('/login');
  await page.fill('#email', 'admin@test.com');  // Same setup copied
  await page.fill('#password', 'password');
  await page.click('#submit');
  await page.waitForNavigation();
  // actual test...
});
```

### Maintainability Issues to Flag

| Issue | Symptom | Recommendation |
|-------|---------|----------------|
| **Long Tests** | > 50 lines per test | Split into focused tests |
| **Deep Nesting** | > 3 levels of describe/context | Flatten or split files |
| **Shared Mutable State** | Variables modified across tests | Use fresh data per test |
| **Complex Setup** | > 10 lines of arrange code | Extract to fixtures/helpers |
| **Commented Tests** | Tests marked skip without reason | Delete or document why |
| **Inconsistent Style** | Mixed async patterns, naming | Establish and enforce conventions |

## Review Feedback Format

When reviewing test automation code, use this format:

```markdown
## Test Automation Review: [PR/File Name]

### Summary
[Brief assessment of overall test quality]

### Scores

| Category | Score | Notes |
|----------|-------|-------|
| Page Objects | ⭐⭐⭐☆☆ | [Brief note] |
| Test Data | ⭐⭐⭐⭐☆ | [Brief note] |
| Assertions | ⭐⭐⭐⭐⭐ | [Brief note] |
| Flakiness Risk | ⭐⭐☆☆☆ | [Brief note] |
| Maintainability | ⭐⭐⭐☆☆ | [Brief note] |

### Critical Issues
- **[File:Line]** [Severity] - [Description and fix]

### Recommendations
1. [Prioritized improvement suggestion]
2. [Another suggestion]

### Strengths
- [What's done well]
```

## Severity Levels

| Level | Meaning | Examples |
|-------|---------|----------|
| **Blocker** | Test unreliable or harmful | Flaky test, data leak, broken isolation |
| **Major** | Significant quality issue | Missing assertions, poor abstraction |
| **Minor** | Improvement opportunity | Naming, organization, minor duplication |
| **Nitpick** | Style preference | Formatting, comment wording |

## Best Practices

1. **Prioritize stability** - A reliable simple test beats a flaky comprehensive test
2. **Review selectors first** - Selector strategy is the foundation of UI test reliability
3. **Check test isolation** - Every test should pass when run alone or with others
4. **Verify assertions are meaningful** - Tests that can't fail provide no value
5. **Look for hidden dependencies** - Execution order, shared state, external services
6. **Consider maintenance burden** - Ask "who will update this when the UI changes?"
7. **Balance coverage and speed** - Fast tests that run often beat slow tests that don't
8. **Encourage consistent patterns** - Team alignment reduces cognitive load
9. **Document non-obvious decisions** - Explain workarounds for known issues
10. **Review test code like production code** - Apply same quality standards
