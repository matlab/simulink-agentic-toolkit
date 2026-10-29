# Variant Configuration Testing

The testing workflows mentioned in this file in context of variant configurations are only valid for MATLAB versions R2024b and beyond.

> **Before you start:** the data dictionary should not have unsaved edits. Test runs close data dictionaries with `'-discard'`, which throws them away, including changes to the VCS. If `HasUnsavedChanges` is true, follow the save-before-discard Hard Rule in SKILL.md first.

## Context: Why Test with Variant Configurations

A variant model encodes multiple designs in one model. Testing must verify that **each configuration simulates correctly** — not just the currently active one. The `sltest.testmanager` API lets you:
- Assign a variant configuration to a test case (applies to all iterations by default)
- Override the configuration per-iteration (test multiple configs in one test case)
- Auto-generate iterations for all available configurations
- Trace results back to the exact configuration and its control variable values

---

## Routing

The `testing-simulink-models` skill covers **component-level Gherkin tests** (`.feature` files + `model_test`). That approach is best for focused subsystem pass/fail verification with structured assertions.

Use **this reference** when:
- Testing full model behavior under different variant configurations
- Running configuration sweeps as test iterations
- Generating test specification and result reports with variant traceability
- Integrating variant testing into Simulink Test Manager workflows

---

## Workflow: Test Variant Configurations Programmatically

### Step 1: Create test file, suite, and case

```matlab
testFile = sltest.testmanager.TestFile("myModel_VariantTests");
testSuite = createTestSuite(testFile, 'VariantConfigTestSuite');
testCase = createTestCase(testSuite, 'simulation', 'ConfigSweepTest');

% Remove auto-created default suite
tsDel = getTestSuiteByName(testFile, 'New Test Suite 1');
remove(tsDel);
```

### Step 2: Assign model and default variant configuration

```matlab
setProperty(testCase, Model=modelName, VariantConfiguration="NonLinExterHighFid");
```

The `VariantConfiguration` property is the default for all iterations unless overridden.

### Step 3: Add iterations with specific configurations

```matlab
iter1 = sltestiteration;
iter1.setTestParam("VariantConfiguration", "LinInterExpWithNoise");
addIteration(testCase, iter1);

% Iteration 2 inherits the test case default (NonLinExterHighFid)
iter2 = sltestiteration;
addIteration(testCase, iter2);
```

### Step 4: Run and access results

```matlab
resultSet = run(testCase);

testCaseResult = getTestCaseResults(resultSet);
iterResults = getIterationResults(testCaseResult);

% Each iteration result carries the configuration used
iterResults(1).VariantConfiguration
% → struct with fields: Name, Description, ControlVariables
```

### Step 5: Generate reports

```matlab
sltest.testmanager.TestSpecReport(testCase, "testSpec.pdf", LaunchReport=true);
sltest.testmanager.report(resultSet, "testResults.pdf", IncludeTestResults=0);
```

### Step 6: Cleanup

```matlab
sltest.testmanager.clear;
clear testFile testSuite tsDel testCase iter1 iter2 resultSet testCaseResult iterResults ans
```

`sltest.testmanager.clear` destroys the test objects but not the variables that hold them. Clear those variables too, and `ans`, which `addIteration` sets to the last iteration: saving the workspace while a stale `sltestiteration` handle is in it crashes MATLAB.

---

## API Reference

### `sltest.testmanager.TestFile`

Container for test organization.

```matlab
testFile = sltest.testmanager.TestFile(filePath)
```

Key methods: `createTestSuite`, `getAllTestCases`, `getAllTestSuites`, `getTestSuiteByName`, `run`, `saveToFile`, `close`.

### `createTestSuite`

```matlab
testSuite = createTestSuite(testFile, 'SuiteName')
```

### `createTestCase`

Creates a test case within a suite. Types: `'simulation'`, `'baseline'`, `'equivalence'`.

```matlab
testCase = createTestCase(testSuite, 'simulation', 'TestName')
```

### `setProperty` (on TestCase)

Sets test case properties. Variant-relevant options:

```matlab
setProperty(testCase, Model=modelName)
setProperty(testCase, VariantConfiguration="ConfigName")
setProperty(testCase, OverrideStopTime=true, StopTime=20)
setProperty(testCase, FastRestart=true)
```

| Property | Type | Description |
|----------|------|-------------|
| `Model` | char | System under test |
| `VariantConfiguration` | char/string | Default variant configuration for all iterations |
| `OverrideStopTime` / `StopTime` | logical / scalar | Override simulation stop time |
| `FastRestart` | logical | Use fast restart across iterations |
| `SimulationMode` | char | `'Normal'`, `'Accelerator'`, `'Software-in-the-Loop (SIL)'` |
| `StopOnFailure` | logical | Stop test case when an iteration fails |

### `sltestiteration` / `setTestParam`

Creates a test iteration and overrides the variant configuration (or other parameters) for that specific iteration.

```matlab
iter = sltestiteration;
iter.setTestParam("VariantConfiguration", "ConfigName");
addIteration(testCase, iter);
```

`setTestParam` also accepts: `ExternalInput`, `Baseline`, `ConfigSet`, `ParameterSet`, `Description`.

### `run`

Executes a test case, suite, or file.

```matlab
resultSet = run(testCase);     % run one test case
resultSet = run(testFile);     % run entire test file
```

Returns `sltest.testmanager.ResultSet`.

### `sltest.testmanager.ResultSet`

Top-level results container.

| Property | Description |
|----------|-------------|
| `NumPassed` | Passed iteration count |
| `NumFailed` | Failed iteration count |
| `NumTotal` | Total iterations |
| `Outcome` | `Passed` or `Failed` |
| `Duration` | Total test duration |

Methods: `getTestCaseResults`, `getTestFileResults`, `getTestSuiteResults`.

### `sltest.testmanager.TestCaseResult`

Accessed via `getTestCaseResults(resultSet)`.

| Property | Description |
|----------|-------------|
| `Outcome` | Pass/fail for the test case overall |
| `VariantConfiguration` | Struct: `Name`, `Description`, `ControlVariables` |
| `NumPassedIterations` / `NumFailedIterations` | Per-iteration counts |

Methods: `getIterationResults`, `getOutputRuns`, `getBaselineRun`.

### `sltest.testmanager.TestIterationResult`

Accessed via `getIterationResults(testCaseResult)`.

| Property | Description |
|----------|-------------|
| `Outcome` | `sltest.testmanager.TestResultOutcomes` enumeration — `Passed`, `Failed`, `Incomplete`, `Disabled`, `Untested`. Compare by name with `string(Outcome)`; the integer values (`2` is `Passed`) are not a pass/fail code |
| `VariantConfiguration` | Struct with `Name`, `Description`, `ControlVariables` |
| `ErrorMessages` | Array of error strings |
| `Duration` | Iteration run time |
| `SimulationMetaData` | `SimulationMetadata` object |

Methods: `getOutputRuns`, `getComparisonResult`, `getAssessmentResults`, `getCoverageResults`.

### Report generation

```matlab
% Test specification report (what will be tested)
sltest.testmanager.TestSpecReport(testCase, "spec.pdf", LaunchReport=true)

% Test results report (what happened)
sltest.testmanager.report(resultSet, "results.pdf", ...
    IncludeTestResults=0, ...
    IncludeSimulationSignalPlots=true, ...
    IncludeSimulationMetadata=true)
```

### Cleanup

```matlab
sltest.testmanager.clear;
clear testFile testSuite testCase iter resultSet testCaseResult iterResults ans
```

Always clear the variables that held Test Manager objects after `sltest.testmanager.clear`, including `ans`, which `addIteration` sets to the last iteration. They become stale handles, and saving the workspace with a stale `sltestiteration` in it crashes MATLAB.

---

## Variant-Specific Patterns

### Test all configurations in a VCS

```matlab
vcs = Simulink.VariantManager.getVariantConfigurations(modelName);
configNames = {vcs.Configurations.Name};

testFile = sltest.testmanager.TestFile("AllConfigsTest");
testSuite = createTestSuite(testFile, 'AllConfigs');
testCase = createTestCase(testSuite, 'simulation', 'SweepAllConfigs');
setProperty(testCase, Model=modelName);

for i = 1:numel(configNames)
    iter = sltestiteration;
    iter.setTestParam("VariantConfiguration", configNames{i});
    addIteration(testCase, iter);
end

resultSet = run(testCase);
sltest.testmanager.clear;
clear testFile testSuite testCase iter resultSet ans
```

### Check pass/fail per configuration

```matlab
testCaseResult = getTestCaseResults(resultSet);
iterResults = getIterationResults(testCaseResult);

for i = 1:numel(iterResults)
    configName = iterResults(i).VariantConfiguration.Name;
    fprintf('%s: %s\n', configName, string(iterResults(i).Outcome));
end
```

### Baseline regression across configurations

Create a baseline test case where each iteration captures/compares against a config-specific baseline:

```matlab
testCase = createTestCase(testSuite, 'baseline', 'BaselineRegression');
setProperty(testCase, Model=modelName);

% First run: capture baselines
iter = sltestiteration;
iter.setTestParam("VariantConfiguration", "LinInterStd");
addIteration(testCase, iter);

% After first run, use captureBaselineCriteria to store reference data
% Subsequent runs compare against stored baselines
```

### Fast restart for iteration sweeps

Enable fast restart to compile the model only once across all iterations:

```matlab
setProperty(testCase, FastRestart=true);
```

---

## Composable Capabilities

These capabilities can be combined with variant configuration test cases. Use `help` to get exact syntax before using.

| Capability | Entry Point | Description |
|---|---|---|
| Signal logging (non-intrusive) | `addLoggedSignalSet`, `addLoggedSignal` | Log specific block outputs without modifying the model |
| Signal plots in report | `IncludeSimulationSignalPlots=true` on `sltest.testmanager.report` | Embed time-series plots in PDF report |
| Coverage collection | `getCoverageSettings(testCase)` | Collect model/decision/condition coverage per iteration |
| Custom criteria | `addAssessment(testCase)` | Attach verify/assert statements for pass/fail |
| Equivalence testing | `createTestCase(suite, 'equivalence', ...)` | Compare two simulations against each other |
| Baseline capture | `captureBaselineCriteria(testCase)` | Capture golden reference for regression |
| Comparison plots in report | `IncludeComparisonSignalPlots=true` on `sltest.testmanager.report` | Embed baseline/equivalence diff plots |
| External inputs | `addInput(testCase)` | Override model inputs from file or workspace |
| Parameter sets | `addParameterSet(testCase)` | Override model parameters per test case |
| Simulation metadata in report | `IncludeSimulationMetadata=true` on `sltest.testmanager.report` | Include timing, solver, config info |

**Pattern:** `setProperty(testCase, OverrideModelOutputSettings=true, SignalLogging=true, SaveOutput=true)` enables logging override. All overrides are non-intrusive — the model is unchanged after the test.

---

## Discovery: Beyond This Reference

This reference covers variant-specific test workflows. The `sltest.testmanager` namespace is extensive (assessments, coverage, signal comparison, harnesses, custom criteria, etc.). When the user needs capabilities not documented here:

```matlab
% Explore the full namespace
help sltest.testmanager

% List all methods on any object — pattern: methods(obj)
methods(testCase)
methods(iterResult)

% Get help on a specific method — pattern: help ClassName.methodName
help sltest.testmanager.TestCase.<methodName>
help sltest.testmanager.TestIterationResult.<methodName>
```

Use `help` to confirm exact syntax before using any method not documented in this reference.

---

## Limitations

- Variant configuration testing via `sltest.testmanager` is **not supported** for multiple-release testing or real-time testing.
- Requires **Variant Manager for Simulink** support package (for configuration creation).
- Requires **Simulink Test** (for `sltest.testmanager` APIs).
- `VariantConfiguration` property on test cases: **R2024a+**.
- Iteration-level `VariantConfiguration` override: **R2024b+**.

----

Copyright 2026 The MathWorks, Inc.

----
