---
type: procedure
triggers: [test_check, qualify_check, generate_tests, run_tests]
tags: [testing, qualification, step-3, lifecycle, unittest]
related:
  - templates/test-spec.md
  - templates/test-recipes.md
  - procedures/author-check.md
---
# Procedure: Test Model Advisor Check

Generates test classes for Model Advisor custom checks from a **guideline document** and the user's original constraint. Produces a self-contained test class (subclass of `matlab.unittest.TestCase`) with all helpers inlined as local functions, following [templates/test-recipes.md](../templates/test-recipes.md). Test models are pre-built via SATK and saved alongside the test file.

## TDD Independence Guardrail

**NEVER read or reference the check spec or check implementation.** This ensures tests verify what the guideline REQUIRES, not what the check IMPLEMENTS.

- Input is the **guideline document** and optionally the user's original prompt/constraint
- Derive test scenarios from the guideline rules only
- Expected outcomes are requirement-based: "Pass", "Fail", or "Fix"

## Steps

### 1. Analyze the Guideline and Generate Test Spec

Read the guideline document provided. Extract:

| Field | How to Find |
|-------|-------------|
| Check ID | Guideline ID (e.g., `custom_0100`) — derive from guideline or use `com.example.<shortname>` |
| Check Name | Guideline title |
| Check Type | Standard (default); "edit-time"/"real-time" -> edit-time; "configuration parameter" -> config-param |
| Has Auto-Fix | Look for explicit mention of auto-fix in guideline or user's constraint |
| Rules | The guideline's ### Rules section — each rule generates at least one Fail test case |
| Exceptions | Conditions where the check must NOT flag (-> Pass test cases) |

If information is ambiguous or missing, **use reasonable defaults and proceed** (e.g., infer a check ID from the guideline ID). Do NOT ask the user — state your assumption inline and continue.

**CRITICAL:** Do NOT read the check spec or check implementation. Derive everything from the guideline and user's original constraint only.

### 2. Present the Test Plan

Generate and present a structured test plan following the format in [templates/test-spec.md](../templates/test-spec.md). Save the test spec `.md` file using `evaluate_matlab_code` with MATLAB file I/O (passing `project_path`) — do NOT use Write/Edit tools. The template defines the header fields, test case selection rules, and expected outcome values.

### 3. Create Test Models

For each model in the plan, create and save as `.slx` in the output directory. Models are pre-built artifacts that ship alongside the test file — the test loads them by path. Do NOT defer model creation to a script the user must run separately.

### 4. Generate Self-Contained Test Class

Generate a single `.m` file using `evaluate_matlab_code` with MATLAB file I/O (fopen/fwrite/fclose), always passing `project_path` — do NOT use Write/Edit tools. Follow the skeleton and recipes in [templates/test-recipes.md](../templates/test-recipes.md). Each test method loads a pre-built model by path, calls `tc.runCheck(modelName)`, and asserts with standard `matlab.unittest` verifications. Emit only the local-function helpers the test actually calls.

See [templates/test-recipes.md](../templates/test-recipes.md) for:
- Recipe 1: `runCheck` with registration guard and R2023a-R2024a ResultDetails fallback
- Recipe 2: Portable violation detection (`isViolation` helper)
- Recipe 5: Auto-fix via interactive API

### 5. Validate (Max 3 Retries)

1. Static analysis on the generated `.m` — resolve issues
2. Run tests — confirm it runs (green if check is registered, Incomplete if not)
3. If a case fails, diagnose root cause, apply targeted fix, and re-run

**Maximum 3 retry attempts.** If still failing after 3 retries, STOP and report honestly (which pass, which fail, recommended next steps). Do NOT enter an unbounded fix loop.

Report: test file path, model files created, registration status, how to run.

**Do NOT end your turn here.** This procedure is complete — continue with the orchestrator's next action (Final Report).

## Reference Files

- [templates/test-recipes.md](../templates/test-recipes.md) — test class skeleton and recipes (portable R2023a-R2026a)
- [templates/test-spec.md](../templates/test-spec.md) — test specification format

----

Copyright 2026 The MathWorks, Inc.

----
