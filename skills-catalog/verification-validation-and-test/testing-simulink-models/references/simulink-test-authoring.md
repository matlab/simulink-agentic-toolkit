# Simulink Test Authoring (test_create / test_edit / test_read / test_run)

Programmatic Simulink Test authoring — create, edit, inspect, and execute `.mldatx` test files. Requires **Simulink Test**; the requirement-driven path additionally requires **Requirements Toolbox**.

## Setup

All four tools are package functions in the **`vnv.internal.agentic`** package in the skill's `scripts/` directory. Use `evaluate_matlab_code` with `project_path` set to the skill's `scripts/` folder so MATLAB can find them. Never use `addpath`. Call the tools fully qualified — `vnv.internal.agentic.test_create`, `vnv.internal.agentic.test_edit`, `vnv.internal.agentic.test_read`, `vnv.internal.agentic.test_run`. Shared helpers live at `vnv.internal.agentic.common.X.X` (e.g. `vnv.internal.agentic.common.requirements.readRequirements`); internal per-tool helpers at `vnv.internal.agentic.helpers.X` (not called directly).

> **Always pass `TestFile` (and any file the tools read/write) as an absolute path under the working folder — never a bare filename.** Because `project_path` is set to the skill's `scripts/` directory (above), a relative `TestFile` like `"MyTests.mldatx"` resolves *inside the skill folder*, not in your working folder, so the `.mldatx` is written to the wrong place — buried in the skill folder where the user can't find it, and unreachable by every downstream `test_edit`/`test_read`/`test_run`. Capture the working folder once (the examples below call it `wf`, e.g. `wf = "/path/to/workspace";`) and build every file path from it — `TestFile=fullfile(wf, "MyTests.mldatx")` — reusing that exact absolute path across all four tools.

> The examples below show the fully-qualified calls exactly as they must be typed. The short names (`test_create`, etc.) are used in the prose only for brevity.

## Constraints

- **TestScope** is `"unit"` (default — creates a subsystem harness on the Implement-link block) or `"model"` (no harness, full-model simulation; the Implement-link component is preserved on the test case as `TargetComponent` for traceability). Choose `"model"` when fault elements are upstream of the SUT, when assessed signals are downstream of the SUT, or when the property spans multiple subsystems.
- **TestType** is one of `"baseline"`, `"simulation"`, `"equivalence"` (lowercase enforced).
- **One input shape per `test_create` call.** The dispatcher prefers requirement (`RequirementID` + `ReqSetPath`) over component-only. Mixing is silently ignored — pick one.
- **Requirement-driven creation auto-derives** `TestName` from `Summary`, `Description` from the requirement text, and `Component` from the Implement link. Override any of these by passing them explicitly.
- **One harness per Implement-link.** When `TestScope="unit"` and a requirement maps to a block already harnessed, `test_create` widens to the harness owner rather than creating a duplicate.
- **`save_to` is read-only.** `test_read`, `test_run`, `vnv.internal.agentic.common.requirements.readRequirements` accept `save_to` for large outputs. `test_create` and `test_edit` do not — they return small confirmation YAML for inline reading.
- **Argument naming is not uniform across tools.** `test_create` uses `TestName`; `test_edit` and `test_run` use `TestCaseName`. `test_run` takes `test_file` positionally; the others pass it as `TestFile=…`.
- **`test_read` takes NO scope filters.** Its only args are positional `(test_file, save_to, max_tokens)`. Do **not** pass `SuiteName`/`TestCaseName` to it — that errors with "Too many input arguments". Unlike `test_run` (which filters by suite/case), `test_read` always returns the whole file; to inspect one case, read the file and pick it out of the returned YAML.

## Tools

Four entry points cover the full author/inspect/execute loop. Construction is split between `test_create` (creates the case + suite + file, resolves harness or model scope, links the requirement) and `test_edit` (configures everything else: stimulus stop time, sim mode, signals to log, pass/fail assessments, parameter overrides).

| Tool | Purpose |
|---|---|
| `test_create` | Build a new test case from one of three input shapes |
| `test_edit` | Configure an existing test case (sim config, params, assessments, …) |
| `test_read` | Inspect a `.mldatx` as structured YAML |
| `test_run` | Execute test cases and return results YAML |

## Entry Points (test_create)

### Component / model only

For behavioral specs, prompt-only requests, or any case without linked requirements:

```matlab
vnv.internal.agentic.test_create(Component="Model/Subsystem", TestType="simulation", TestScope="unit")
vnv.internal.agentic.test_create(ModelName="MyModel.slx",     TestType="baseline",   TestScope="model")
```

### Requirement-driven (`.slreqx`)

Reads the requirement, follows the Implement link, and harnesses the linked component automatically:

```matlab
vnv.internal.agentic.test_create( ...
    RequirementID="BAHOLD_1", ...
    ReqSetPath=fullfile(wf, "reqs.slreqx"), ...
    TestFile=fullfile(wf, "MyTests.mldatx"), ...   % absolute — wf is the working folder
    SuiteName="Unit", ...
    TestScope="unit")
```

For requirement-led authoring, read the requirement first with `vnv.internal.agentic.common.requirements.readRequirements(file, RequirementIDs=ids)` to extract the behavior, acceptance criteria, and Implement link before calling `test_create`.

## Configure (test_edit)

```matlab
vnv.internal.agentic.test_edit( ...
    TestFile=fullfile(wf, "MyTests.mldatx"), ...   % same absolute path used at create time
    SuiteName="Unit", ...
    TestCaseName="case1", ...
    StopTime="5", ...
    SimulationMode="Normal", ...
    LoggedSignals=loggedStruct, ...
    Assessments=assessmentsStruct, ...
    ParameterOverrides=overridesStruct, ...
    RequirementIDs=["REQ_001","REQ_002"], ...
    ReqSetPath=fullfile(wf, "reqs.slreqx"), ...
    InputFile=fullfile(wf, "test_inputs.mat"))
```

All parameters are optional — pass only what you need to change. `RequirementIDs` + `ReqSetPath` create "Verify" traceability links from the test case to requirements in the `.slreqx` file; use this to link requirements after creation rather than at creation time. `InputFile` attaches a user-prepared `.mat` or `.xlsx` file as external input data.

`LoggedSignals` shape depends on TestScope:
- **unit-scope**: `struct('Alias', ..., 'PortIndex', ..., 'ElementPath', ...)` — refers to the SUT outport on the harness.
- **model-scope**: `struct('Alias', ..., 'BlockPath', ..., 'PortIndex', ..., 'ElementPath', ...)` — any block in the model.

For unit-scope cases, the harness model name is returned in the `test_create` output (or read it back via `test_read`) and used to discover outport indices via `model_read`.

`Assessments` and `LoggedSignals` struct schemas live in the reference files — read those before constructing the structs.

## Inspect (test_read)

```matlab
vnv.internal.agentic.test_read(fullfile(wf, "MyTests.mldatx"))
vnv.internal.agentic.test_read(fullfile(wf, "MyTests.mldatx"), save_to=fullfile(wf, "dump.yaml"))
```

Signature is positional only: `test_read(test_file, save_to, max_tokens)`. **It has no suite/case filter** — do not copy `test_run`'s `SuiteName=`/`TestCaseName=` args here (that errors "Too many input arguments"). It always returns the full file structure as YAML. To inspect one case post-create or discover harness model names, read the whole file and locate the case in the returned YAML.

**What `test_read` returns, by level:**

- **File** — path, description, enabled, tags, coverage settings, linked requirements; the list of suites; and a `summary` (suite/case counts, enabled vs disabled, counts by type, linked vs unlinked).
- **Suite** — name, description, enabled, tags, coverage, requirements; its list of test cases.
- **Test case** — name, type (`simulation`/`baseline`/`equivalence`), description, enabled, tags, coverage, requirements, `model`, `stop_time`, `sim_config` (simulation mode, fast restart, override-stop-time, save-output), `inputs` (name/file/active), `parameter_overrides` (variable/value), and `assessments` (custom criteria, verify statements, plus baseline tolerances or equivalence criteria per type). Equivalence cases expand into two `simulations`, each with its own model/stop-time/inputs/overrides.

**Not exhaustive.** `test_read` surfaces the fields listed above, not the full `.mldatx` schema. Several sections are **not** reported — including **faults**, **callbacks** (pre/post-load, pre/post-sim, cleanup), coverage-filter details, custom test-harness wiring, and iteration/test-sequence scenarios.

## Run (test_run)

```matlab
vnv.internal.agentic.test_run(fullfile(wf, "MyTests.mldatx"))                                  % entire file
vnv.internal.agentic.test_run(fullfile(wf, "MyTests.mldatx"), SuiteName="Unit")                % one suite
vnv.internal.agentic.test_run(fullfile(wf, "MyTests.mldatx"), TestCaseName="case1")            % one case
vnv.internal.agentic.test_run(fullfile(wf, "MyTests.mldatx"), save_to=fullfile(wf, "results.yaml"))      % YAML summary
vnv.internal.agentic.test_run(fullfile(wf, "MyTests.mldatx"), export_to=fullfile(wf, "results.mldatx"))  % handoff ResultSet
```

Filter scope is determined by which name args are passed: no filter → whole file; `SuiteName` only → that suite; `TestCaseName` → that single case. The exported `.mldatx` can be reloaded later via `sltest.testmanager.importResults`.

## References

- `reference/test-structure-template.md` — `.mldatx` YAML structure (suite/case nesting, fields)
- `reference/test-config-template.md` — sim config option keys
- `reference/assessment-format.md` — `Assessments` and `LoggedSignals` struct schemas (must read before constructing them)

----

Copyright 2026 The MathWorks, Inc.

----
