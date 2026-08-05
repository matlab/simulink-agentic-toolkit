---
name: testing-simulink-models
description: Tests Simulink models using either ephemeral Gherkin-based tests (model_test) for quick validation or persistent tests (Simulink Test API) authored from requirements or behavioral specs. Requires Simulink Test.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "2.0"
---

# Testing Simulink Models

Requires **Simulink Test** and **R2023a or later**. The requirement-driven entry point also requires **Requirements Toolbox**. The coverage workflow also requires **Simulink Coverage**. If Simulink Test is unavailable, use `simulating-simulink-models` with manual assertions.

## When to Use

- Writing pass/fail tests for a Simulink model or subsystem
- Verifying expected behavior against requirements or acceptance criteria
- Creating regression tests to catch future breakage
- Reproducing and validating bug fixes with structured assertions
- Collecting decision coverage metrics
- Authoring persistent tests from linked requirements or a behavioral spec

## When NOT to Use

- **Building or editing model structure** → use `building-simulink-models`
- **Running simulations for data exploration, sweeps, or custom analysis** → use `simulating-simulink-models`
- **Querying or resolving parameter values** → use `model_query_params` / `model_resolve_params`
- **Creating or editing requirements** → use `generate-requirement-drafts`
- **Injecting faults onto model signals without test authoring** → use `inject-faults`
- **FMEA, FHA, FTA, or other safety analysis documents** → use `manage-safety-analysis`
- **Simulink Test is not installed** → fall back to `simulating-simulink-models` with manual assertions

## Testing Approaches

This skill provides two testing approaches. Choose based on task context:

| | Gherkin (`model_test`) | Simulink Test API (`test_create` family) |
|---|---|---|
| Persistence | Ephemeral — harness discarded after session | Persistent — .mldatx files remain in project |
| Speed | ~3s (draft mode) | ~60s (full Simulink Test infrastructure) |
| Traceability | None | Full requirement linking via `.slreqx` |
| Use case | Bug fixes, quick validation, agentic loop | Certification, systematic testing, formal V&V; also takes behavioral specs |
| Approval needed | No | Yes — engineer reviews test plan before execution |
| Coverage | `coverage` parameter (`'none'` or `'decision'`) | Via `test_run` options |
| Toolbox | Simulink Test | Simulink Test (+ Requirements Toolbox for requirement path) |

→ For Gherkin testing, read `references/gherkin-based-fast-testing.md`
→ For Simulink Test API authoring (requirements / behavioral spec), read `references/simulink-test-authoring.md`

## Workflow — Gherkin (Quick Validation)

1. **Understand the component:** Use `model_overview` and `model_read` on the target subsystem to identify inputs, outputs, and expected behavior.
2. **Write the `.feature` file:** Author a Gherkin test following the syntax in `references/gherkin-based-fast-testing.md`. Start with one scenario covering the primary nominal case.
3. **Cap StopTime before running:** Check the model's StopTime with `model_query_params`. If it is `inf` (or unset/`auto`), you MUST pass a finite stop time to `model_test` — an infinite sim never returns and hangs MATLAB. Pick a finite value that lets the behavior settle (2–30s for a step response).
4. **Run in draft mode:** Call `model_test` with `draft_mode='true'` for rapid iteration (~3s). Fix syntax or signal errors.
5. **Run full compilation:** Once draft passes, re-run with `draft_mode='false'` to validate against the actual compiled model (catches type/dimension mismatches).
6. **Expand coverage:** Add scenarios for edge cases, fault conditions, and boundary behavior. Use `coverage='decision'` to identify untested branches.

## Workflow — Simulink Test API (Persistent)

1. **Understand the component:** Use `model_overview` and `model_read` on the target subsystem to identify inputs, outputs, and expected behavior.
2. **Propose test plan → wait for approval:** Present what to test, at what scope, and why. Do not call `test_create` until the engineer approves.
3. **Create test cases:** Call `test_create` with the appropriate entry point — component/model only or requirement-driven (`RequirementID` + `ReqSetPath`). Pass `TestFile` as an **absolute path** under the working folder (never a bare filename — it would land in the skill's `scripts/` dir, since that is the `project_path`). See `references/simulink-test-authoring.md` for call shapes.
4. **Propose test configuration → wait for approval:** Present stop time, sim config, signal logging, assessments, and parameter overrides for each test case. Do not call `test_edit` until the engineer approves. **Always set a finite `StopTime` via `test_edit`** — if the model's StopTime is `inf` (or unset), the test run never returns and hangs MATLAB. Choose a finite value that lets the behavior settle (2–30s for a step response).
5. **Run and report:** Call `test_run`, present pass/fail summary with assessment detail. Engineer decides next steps.

## Guardrails

### Always

- Inspect model (`model_overview` / `model_read`) before writing tests — otherwise you write tests against wrong I/O
- Report failures with assessment names, conditions, and signal summaries — users can't diagnose without detail
- **Never run a sim or test with StopTime=`inf`.** Check StopTime before any `model_test`/`test_run`; if it is `inf` or unset, override it with a finite value first. An infinite sim never returns and hangs the MATLAB session (and, in a shared session, every subsequent task).

### Never

- Guess pass/fail criteria — ask the user if unclear
- Change MATLAB working directory while a model is open — breaks harness cache

## References

- `references/gherkin-based-fast-testing.md` — Gherkin syntax, draft mode, coverage, Simscape constraints
- `references/simulink-test-authoring.md` — API manual: setup, constraints, test_create entry shapes, edit/read/run signatures
- `references/assessment-format.md` — LoggedSignals and Assessments struct formats
- `references/test-structure-template.md` — Test structure proposal template (requirement-driven path)
- `references/test-config-template.md` — Test configuration proposal template (requirement-driven path)

----

Copyright 2026 The MathWorks, Inc.

----
