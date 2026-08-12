---
type: template
triggers: [test_spec, test_specification, test_plan, test_cases]
tags: [template, test-spec, test-plan, TDD]
related:
  - procedures/test-check.md
  - templates/test-recipes.md
---
# Test Specification Template

**TDD Independence:** Derive test cases SOLELY from the guideline and the user's original constraint — NEVER from the check spec or implementation.

---

## Template

```markdown
# Test Specification: <check_id>

## Test Overview

| Field | Value |
|-------|-------|
| Guideline ID | <guideline_id> |
| Title | <guideline title> |
| Check ID | <fully qualified check ID> |
| Check Name | <human-readable check name> |
| Check Type | standard / edit-time / config-param |
| Auto-Fix | yes / no |

## Source Guideline

| Field | Value |
|-------|-------|
| Guideline ID | <guideline_id> |
| Title | <guideline title> |
| Guideline File | <path to guideline document> |
| Rule Summary | <one-line summary of what the rule enforces> |

## Test Cases

| ID | Description | Model | Expected Outcome |
|----|-------------|-------|-----------------|
| TC-01 | <compliant scenario — all elements satisfy the rule> | compliant_<shortname> | Pass |
| TC-02 | <violating scenario — elements breach the rule> | violating_<shortname> | Fail |
| TC-03 | <specific violation type or count scenario> | violating_<shortname> | Fail |
| TC-04 | <mixed model — compliant elements not flagged> | mixed_<shortname> | Pass |
| TC-05 | <auto-fix corrects violations> | violating_<shortname> | Fix |
```

---

## User-Facing Summary Format

When presenting the test spec at the review gate, show this compact summary (not the full document):

```
## Test Specification: <check_name>
| Field | Value |
|-------|-------|
| Guideline ID | <id> |
| Title | <guideline title> |
| Check ID | <fully qualified check ID> |
| Check Name | <human-readable check name> |
| Check Type | standard / edit-time / config-param |
| Auto-Fix | yes / no |

### Test Cases
| ID | Description | Model | Expected Outcome |
|----|-------------|-------|--------------------|
| TC-01 | <compliant scenario> | compliant_<short> | Pass |
| TC-02 | <violating scenario> | violating_<short> | Fail |
| TC-03 | <fix scenario> | violating_<short> | Fix |

Spec saved to: <path>
```

## Expected Outcome Values

| Value | Meaning |
|-------|---------|
| Pass | The check produces no violations for this scenario |
| Fail | The check produces one or more violations for this scenario |
| Fix | After applying the auto-fix action, the check produces no violations |

## Test Case Selection Rules

| Guideline Characteristic | Required Test Cases |
|--------------------------|---------------------|
| Any rule | At least 1 Pass case, at least 1 Fail case |
| Rule with multiple violation types | 1 Fail case per violation type |
| Rule with explicit exceptions | 1 Pass case for each exception |
| Guideline mentions auto-fix | At least 1 Fix case |
| Rule applies to multiple element types | Mixed model with both compliant and violating elements |

## Auto-Fix Inclusion Rule

Include Fix test cases ONLY when the guideline or user's constraint explicitly describes automated fix behavior. A recommendation for manual correction is NOT sufficient to warrant Fix tests.

## Model Naming Convention

Model names follow `<purpose>_<shortname>.slx` where shortname is derived from the guideline's short name (first meaningful word or two). Per-check folder prevents collisions.

## Example: Port-Signal Name Consistency (trial_0003)

```markdown
# Test Specification: trial_0003

## Test Overview

| Field | Value |
|-------|-------|
| Guideline ID | trial_0003 |
| Title | Port and signal name consistency |
| Check ID | trial_0003 |
| Check Name | Port and Signal Name Consistency |
| Check Type | standard |
| Auto-Fix | yes |

## Source Guideline

| Field | Value |
|-------|-------|
| Guideline ID | trial_0003 |
| Title | Port and signal name consistency |
| Guideline File | guideline_trial_0003/guideline_trial_0003.md |
| Rule Summary | Port block names shall match the names of signal lines connected to them |

## Test Cases

| ID | Description | Model | Expected Outcome |
|----|-------------|-------|-----------------|
| TC-01 | All port names match their connected signal names | compliant_portsig | Pass |
| TC-02 | Inport name does not match connected signal name | violating_portsig | Fail |
| TC-03 | Outport name does not match connected signal name | violating_portsig | Fail |
| TC-04 | Port connected to unnamed (empty) signal line | violating_portsig | Fail |
| TC-05 | Unconnected port is not flagged (exception) | mixed_portsig | Pass |
| TC-06 | Correctly named port not flagged in mixed model | mixed_portsig | Pass |
| TC-07 | Auto-fix renames signal to match port name | violating_portsig | Fix |
```

----

Copyright 2026 The MathWorks, Inc.

----
