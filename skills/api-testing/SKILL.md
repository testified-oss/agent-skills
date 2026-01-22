---
name: api-testing
description: Design and review API tests including contract testing, schema validation, error handling verification, and performance considerations. Use when creating API tests, reviewing API test coverage, or designing API testing strategies.
version: 1.0.0
---

# API Testing

## When to Use

- Designing test cases for REST or GraphQL APIs
- Reviewing API test coverage for completeness
- Creating contract tests between services
- Validating API response schemas
- Testing error handling and edge cases
- Evaluating API performance characteristics
- Setting up API testing strategies for a project

## When NOT to Use

- UI/E2E testing (use appropriate UI testing tools)
- Unit testing internal functions (use unit testing practices)
- Load/stress testing at scale (use specialized tools like k6, JMeter)
- Security penetration testing (use security-focused tools)

## API Test Categories

### Test Pyramid for APIs

| Level | Focus | Tools | Speed |
|-------|-------|-------|-------|
| **Contract Tests** | API agreements between services | Pact, Prism | Fast |
| **Integration Tests** | API behavior with dependencies | Supertest, REST Assured | Medium |
| **Component Tests** | API in isolation (mocked deps) | Jest, Pytest | Fast |
| **E2E API Tests** | Full API workflow | Postman, Newman | Slow |

## Contract Testing

Ensure API providers and consumers agree on the interface.

### Consumer-Driven Contract Testing

The consumer defines expectations, and the provider verifies compliance.

#### Contract Test Structure

```markdown
## Contract: [Consumer] → [Provider]

### Interaction: [Name]

**Request:**
- Method: [HTTP Method]
- Path: [Endpoint path]
- Headers: [Required headers]
- Body: [Request body schema]

**Expected Response:**
- Status: [HTTP status code]
- Headers: [Expected headers]
- Body: [Response body schema]

**Provider States:**
- [Precondition 1]
- [Precondition 2]
```

#### Example Contract

```markdown
## Contract: Order Service → User Service

### Interaction: Get user by ID

**Request:**
- Method: GET
- Path: /api/users/123
- Headers:
  - Accept: application/json
  - Authorization: Bearer {token}

**Expected Response:**
- Status: 200
- Headers:
  - Content-Type: application/json
- Body:
  ```json
  {
    "id": 123,
    "email": "user@example.com",
    "name": "John Doe",
    "status": "active"
  }
  ```

**Provider States:**
- User with ID 123 exists
- User is in active status
```

### Contract Testing Checklist

- [ ] All consumer expectations documented
- [ ] Provider states clearly defined
- [ ] Contracts versioned with API
- [ ] Breaking changes detected before deployment
- [ ] Both sides run contract tests in CI

## Schema Validation

Verify API responses match expected structure.

### JSON Schema Validation

Define schemas for request and response validation:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["id", "email", "createdAt"],
  "properties": {
    "id": {
      "type": "integer",
      "minimum": 1
    },
    "email": {
      "type": "string",
      "format": "email"
    },
    "name": {
      "type": ["string", "null"],
      "maxLength": 100
    },
    "createdAt": {
      "type": "string",
      "format": "date-time"
    },
    "roles": {
      "type": "array",
      "items": {
        "type": "string",
        "enum": ["admin", "user", "guest"]
      }
    }
  },
  "additionalProperties": false
}
```

### Schema Validation Test Cases

| Test Case | Description | Expected Result |
|-----------|-------------|-----------------|
| Required fields present | All required fields in response | Pass |
| Required field missing | Response lacks required field | Fail validation |
| Correct data types | Fields match expected types | Pass |
| Invalid data type | String where number expected | Fail validation |
| Additional properties | Extra fields in response | Depends on schema |
| Null handling | Nullable vs non-nullable | Match schema definition |
| Array constraints | Min/max items, unique items | Validate constraints |
| String formats | Email, URI, date-time | Validate format |

### OpenAPI/Swagger Validation

```markdown
## Schema Validation Checklist

- [ ] Response matches OpenAPI spec
- [ ] All documented fields present
- [ ] No undocumented fields (if strict)
- [ ] Correct HTTP status codes used
- [ ] Content-Type headers match spec
- [ ] Error responses follow schema
```

## Error Handling Verification

Test API behavior under error conditions.

### HTTP Status Code Testing

| Status | Meaning | Test Scenario |
|--------|---------|---------------|
| **400** | Bad Request | Invalid JSON, missing required fields |
| **401** | Unauthorized | Missing/invalid authentication |
| **403** | Forbidden | Valid auth, insufficient permissions |
| **404** | Not Found | Resource doesn't exist |
| **405** | Method Not Allowed | Wrong HTTP method |
| **409** | Conflict | Duplicate resource, version conflict |
| **422** | Unprocessable Entity | Valid JSON, business rule violation |
| **429** | Too Many Requests | Rate limit exceeded |
| **500** | Internal Server Error | Server-side failure |
| **502** | Bad Gateway | Upstream service failure |
| **503** | Service Unavailable | Service temporarily down |
| **504** | Gateway Timeout | Upstream timeout |

### Error Response Testing Template

```markdown
### TC-ERR-[ID]: [Error Scenario]

**Endpoint:** [Method] [Path]
**Scenario:** [Description of error condition]

**Request:**
- Headers: [headers]
- Body: [request body if applicable]

**Expected Response:**
- Status: [Expected HTTP status]
- Body:
  ```json
  {
    "error": {
      "code": "[ERROR_CODE]",
      "message": "[Human-readable message]",
      "details": [Optional additional info]
    }
  }
  ```

**Verification:**
- [ ] Correct status code returned
- [ ] Error message is informative (not exposing internals)
- [ ] Error code is documented/consistent
- [ ] No sensitive data leaked in error
```

### Error Handling Test Cases

#### Authentication Errors

| Test | Input | Expected Status | Expected Error |
|------|-------|-----------------|----------------|
| No auth header | - | 401 | Missing authentication |
| Invalid token format | `Bearer invalid` | 401 | Invalid token |
| Expired token | Expired JWT | 401 | Token expired |
| Wrong credentials | Bad username/password | 401 | Invalid credentials |

#### Validation Errors

| Test | Input | Expected Status | Expected Error |
|------|-------|-----------------|----------------|
| Missing required field | `{}` | 400/422 | Field X is required |
| Invalid email format | `email: "notanemail"` | 400/422 | Invalid email format |
| Value out of range | `age: -5` | 400/422 | Age must be positive |
| String too long | `name: "a".repeat(1000)` | 400/422 | Name exceeds max length |

#### Business Logic Errors

| Test | Scenario | Expected Status | Expected Error |
|------|----------|-----------------|----------------|
| Duplicate creation | Create existing resource | 409 | Resource already exists |
| Invalid state transition | Cancel shipped order | 422 | Cannot cancel shipped order |
| Insufficient balance | Payment exceeds balance | 422 | Insufficient funds |

### Error Consistency Checklist

- [ ] All errors follow consistent format
- [ ] Error codes are documented
- [ ] Messages are user-friendly
- [ ] No stack traces in production
- [ ] No sensitive data in errors
- [ ] Appropriate status codes used
- [ ] Errors are logged server-side

## Performance Considerations

Evaluate API performance characteristics.

### Response Time Testing

| Metric | Target | Measurement |
|--------|--------|-------------|
| **P50 (Median)** | < 100ms | 50th percentile response time |
| **P95** | < 500ms | 95th percentile response time |
| **P99** | < 1000ms | 99th percentile response time |
| **Max** | < 3000ms | Maximum acceptable response time |

### Performance Test Template

```markdown
### Performance Test: [Endpoint Name]

**Endpoint:** [Method] [Path]
**Baseline:** [Expected response time]

**Test Configuration:**
- Concurrent users: [Number]
- Duration: [Time period]
- Ramp-up: [Ramp-up period]

**Acceptance Criteria:**
- P95 response time < [threshold]
- Error rate < [threshold]%
- Throughput > [requests/second]

**Results:**
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| P50 | < 100ms | | |
| P95 | < 500ms | | |
| P99 | < 1s | | |
| Error Rate | < 1% | | |
| Throughput | > 100 rps | | |
```

### Performance Checklist

- [ ] Response time within SLA
- [ ] Pagination implemented for list endpoints
- [ ] Appropriate timeout handling
- [ ] Caching headers present (where applicable)
- [ ] Compression enabled (gzip/brotli)
- [ ] No N+1 query problems
- [ ] Database queries optimized
- [ ] Connection pooling configured

### Pagination Testing

| Test Case | Scenario | Verification |
|-----------|----------|--------------|
| Default page size | No params | Returns default limit |
| Custom page size | `?limit=50` | Returns 50 items max |
| Page navigation | `?page=2` or `?cursor=abc` | Correct offset/cursor |
| Beyond last page | Page > total pages | Empty result or 404 |
| Invalid page params | `?limit=-1` | Error or default |
| Large page size | `?limit=10000` | Capped at max allowed |

## API Test Case Template

Use this format for comprehensive API test documentation:

```markdown
### TC-API-[ID]: [Test Name]

**Category:** [Contract/Schema/Error/Performance]
**Priority:** [Critical/High/Medium/Low]
**Endpoint:** [Method] [Path]

**Preconditions:**
- [Required state/data]
- [Authentication requirements]

**Request:**
```http
[METHOD] /api/path HTTP/1.1
Host: api.example.com
Content-Type: application/json
Authorization: Bearer {token}

{
  "field": "value"
}
```

**Expected Response:**
```http
HTTP/1.1 [Status Code] [Status Text]
Content-Type: application/json

{
  "expected": "response"
}
```

**Validations:**
- [ ] Status code is [expected code]
- [ ] Response time < [threshold]
- [ ] Schema validation passes
- [ ] [Business rule validation]

**Notes:**
[Additional context or edge cases]
```

## Comprehensive Test Coverage Matrix

```markdown
## API Test Coverage: [API Name]

### Endpoints

| Endpoint | Happy Path | Auth | Validation | Errors | Performance | Contract |
|----------|------------|------|------------|--------|-------------|----------|
| GET /users | ✓ | ✓ | N/A | ✓ | ✓ | ✓ |
| POST /users | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| GET /users/:id | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| PUT /users/:id | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| DELETE /users/:id | ✓ | ✓ | N/A | ✓ | ✓ | ✓ |

### Coverage Summary

- Total Endpoints: X
- Endpoints with tests: X
- Test cases: X
- Coverage: X%
```

## Output Format

When designing API tests, provide:

```markdown
## API Test Design: [API/Feature Name]

### Overview
[Brief description of API being tested]

### Test Strategy
- Contract testing approach: [Consumer-driven/Provider-driven]
- Schema validation: [JSON Schema/OpenAPI]
- Error handling coverage: [Scope]
- Performance targets: [P95, throughput]

### Test Cases

#### Contract Tests
[List contract test cases]

#### Schema Validation Tests
[List schema validation cases]

#### Error Handling Tests
[List error scenario tests]

#### Performance Tests
[List performance test cases]

### Coverage Summary
- Endpoints covered: X/Y
- Error scenarios: X
- Contract interactions: X
- Estimated execution time: X minutes
```

## Best Practices

1. **Test in isolation first** - Mock external dependencies for faster, reliable tests
2. **Use realistic test data** - Avoid trivial test data that misses edge cases
3. **Version your contracts** - Keep contracts in sync with API versions
4. **Automate schema validation** - Generate tests from OpenAPI specs
5. **Test error paths thoroughly** - Errors are often under-tested
6. **Monitor production APIs** - Use synthetic tests for ongoing validation
7. **Document test data requirements** - Make tests reproducible
8. **Include negative tests** - Test what should NOT work
9. **Set performance baselines** - Track degradation over time
10. **Review API tests in PRs** - Treat test code as production code
