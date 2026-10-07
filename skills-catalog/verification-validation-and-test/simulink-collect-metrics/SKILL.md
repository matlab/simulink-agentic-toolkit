---
name: simulink-collect-metrics
description: >
  Collect and assess quality metrics for Simulink models using the metric.Engine
  API. Use when evaluating model design quality (maintainability, complexity,
  architecture) or testing completeness (unit testing, SIL, PIL, coverage, pass
  rates) after edits or test runs. Covers metric discovery, collection, report
  generation, and diagnostics. Triggers on: "collect metrics", "quality metrics",
  "metric.Engine", "testing metrics", "maintainability metrics", "SIL metrics",
  "PIL metrics", "what metrics are available", "assess quality", "coverage
  metrics", "generate metric report", "diagnose metric errors".
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0.0"
---

# Collect Quality Metrics

Assess the quality and completeness of model edits and testing work using `metric.Engine`. This skill teaches the canonical workflow for discovering, collecting, and interpreting quality metrics across releases.

## When to Use

- After editing a model — assess maintainability, complexity, or design quality
- After running tests — assess coverage, pass rates, requirements traceability
- When asked to collect or check quality metrics from a MATLAB project
- When diagnosing why metrics show errors or missing data
- When generating metric reports (HTML, PDF)
- When asked what metrics are available for a project

## When NOT to Use

- No MATLAB project is open — `metric.Engine` requires an open project
- Writing or running tests — use `matlab-testing`
- Static code analysis or coding standards — use `matlab-review-code`
- Model Advisor compliance checks — use `checking-model-compliance`
- Building or editing Simulink models — use `building-simulink-models`
- Digital thread configuration (`digitalthread.settings`)
- Requirements authoring (`slreq` APIs)
- Custom metric authoring (writing new metric algorithms)
- Threshold customization

## Workflow

A project must be open before using `metric.Engine`.

### 1. Create Engine

```matlab
me = metric.Engine;
```

One instance per session is sufficient. Do not create multiple engines.

### 2. Attach Progress Monitor (Optional)

For progress visibility during `updateArtifacts`, attach a listener to the project's existing digital thread artifact service.

**Setup:** Add the skill's `scripts/` directory to MATLAB's path **before** creating the monitor:

```matlab
addpath("SKILL_DIR/scripts");
projectRoot = currentProject().RootFolder;
pm = AgentProgressMonitor(projectRoot);
```

Replace `SKILL_DIR` with the absolute path to this skill's directory on disk.

**Ordering matters:** Call `addpath` before `AgentProgressMonitor(...)`. Adding the path after creating the monitor can trigger duplicate progress events from the artifact service re-indexing.

**Script:** `scripts/AgentProgressMonitor.p` — prints `[dt  XX%] message` progress lines to stdout during artifact updates.

- **Input:** `projectRoot` (string) — the project root folder
- **Output:** `AgentProgressMonitor` handle object (clear it to stop listening)

The monitor stays active until cleared. Call `updateArtifacts(me)` normally — progress prints automatically while the monitor is in scope.

### 3. Update Artifacts

```matlab
updateArtifacts(me);
```

Call `updateArtifacts` before collecting metrics that relate to testing (`ModelUnitTesting`, `ModelUnitSILTesting`, `ModelUnitPILTesting`, `ProjectModelTesting`). It refreshes traceability data so results reflect the current project state. Skipping this step produces stale or empty results for testing metrics.

For design/maintainability metrics (`ModelMaintainability`), `updateArtifacts` is not strictly required but is harmless.

### 4. Discover Metric IDs

```matlab
ids = getAvailableMetricIds(me, App="DashboardApp", Dashboard="ModelUnitTesting");
```

**Never hardcode metric IDs.** IDs change across releases. Invalid IDs fail silently (warning + 0 results, no exception). Always discover first.

Valid `Dashboard` values: see `references/metric-groups.md` for the full list, introduction releases, and scoping rules.

To collect all installed metrics regardless of dashboard:

```matlab
allIds = getAvailableMetricIds(me);
```

### 5. Execute Collection

```matlab
execute(me, ids);
```

Runs the metric algorithms. In R2026a+, `execute` also returns results directly, but always call `getMetrics` for cross-release compatibility.

### 6. Retrieve Results

```matlab
results = getMetrics(me, ids);
```

Returns a `metric.Result` array. Each element has properties: `.Value`, `.MetricID`, `.Scope`, `.Artifacts`, `.Diagnostics`.

### 7. Inspect and Present Results

**Identify components with `.Scope.Name`** — this is the model or component name each result belongs to. Do not rely on `.Artifacts` (frequently empty).

```matlab
for k = 1:numel(results)
    componentName = results(k).Scope.Name;
    v = results(k).Value;
    if ismissing(v)
        fprintf("%s: No data\n", componentName);
    elseif isstruct(v) && isfield(v, 'Failed')
        fprintf("%s: %d passed, %d failed\n", componentName, v.Passed, v.Failed);
    elseif isnumeric(v) && isscalar(v)
        fprintf("%s: %g\n", componentName, v);
    elseif isstruct(v)
        fprintf("%s: struct(%s)\n", componentName, strjoin(string(fieldnames(v)), ", "));
    end
end
```

**Group results by component** when presenting to users:

```matlab
scopeNames = arrayfun(@(r) string(r.Scope.Name), results(:));
for component = unique(scopeNames).'
    componentResults = results(scopeNames == component);
    fprintf("--- %s (%d metrics) ---\n", component, numel(componentResults));
    % ... summarize key metrics for this component
end
```

**Value shapes** vary by metric type and release. Common shapes include: scalar doubles, distribution structs, coverage breakdown structs, named count structs, and linkage ratios. Struct fields may themselves be structs or non-numeric — use `disp` or `fprintf("%g", val)` only after confirming `isnumeric`. See `references/release-notes.md` for cross-release differences.

**Value semantics:**

| Metric pattern | Value meaning | Do NOT assume |
|----------------|---------------|---------------|
| `*Complexity`, `*CyclomaticComplexity` | Unbounded positive integer (higher = more complex) | Not a percentage |
| `*HalsteadDifficulty` | Unbounded positive double (higher = harder to maintain) | Not a percentage |
| `*Distribution` | Struct with `BinCounts`/`BinEdges` (histogram). `BinEdges` may be numeric or categorical (cell array of strings). `Ratios` may be `NaN` when counts are zero. | Do not format `NaN` as a number; do not assume numeric bin edges |
| `Overall*`, `*Count`, `*Lines`, `*Blocks` | Raw integer counts | Not bounded |

Coverage metrics return structs whose fields vary by metric prefix and release. Use `fieldnames(v)` to discover the shape. Common patterns on R2026a:
- `slcomp.mt.CoverageBreakdown`: nested struct `{Execution, Decision, Condition, MCDC, OverflowSaturation}`, each with sub-fields `{Achieved, Justified, Missed, AchievedOrJustified}` (percentages 0–100)
- `UnitBoundary*CoverageBreakdown`, `Requirements*CoverageBreakdown`: flat struct `{Numerator, Denominator, Value}` where `Value` is a ratio 0–1
- `*CoverageFragment`: same shape as its `*Breakdown` counterpart on the same prefix

Do not assume a single coverage struct shape applies to all coverage metrics. Inspect with `fieldnames` before accessing fields.

**Interpreting empty results:**

| Value | Meaning | What to tell the user |
|-------|---------|----------------------|
| `[]` (empty double) | Prerequisite not met (e.g., tests not run, coverage not collected) | "No test data — run tests first" |
| `0` | Metric is applicable but the measured quantity is zero | Report as zero |
| `ismissing(v)` | Metric does not apply to this component | Omit from summary or label "N/A" |
| Struct with all-empty sub-fields (e.g., `.Achieved = []`) | Same as `[]` — prerequisite not met | "No coverage data — run tests first" |

**Summarizing large result sets:** Multi-dashboard collection can return 100+ results. Focus on headline metrics per dashboard rather than dumping all results:

| Dashboard | Headline metrics (present first) | Detail metrics (show on request) |
|-----------|----------------------------------|----------------------------------|
| `ModelMaintainability` | `slcomp.OverallCyclomaticComplexity`, `slcomp.HalsteadDifficulty`, `slcomp.OverallBlocks` | `*Distribution`, per-language breakdowns |
| `ModelUnitTesting` | `slcomp.mt.TestStatusDistribution`, `slcomp.mt.CoverageBreakdown` | `Requirements*`, `TestCase*` distributions |
| `ModelUnitSILTesting` | `slcomp.sil.TestStatusDistribution`, `slcomp.sil.CoverageBreakdown` | B2B status, model-level coverage |
| `ModelUnitPILTesting` | `slcomp.pil.TestStatusDistribution`, `slcomp.pil.CoverageBreakdown` | B2B status, model-level coverage |

Pattern: present one row per component with headline values, then offer detail on request.

### 8. Generate Report

When a user asks to "collect metrics" or "assess quality," prefer `generateReport` as the primary output — it produces a formatted, interactive view with proper component names and visual indicators. Use programmatic inspection (Step 7) when the user needs specific values extracted, when running in CI/headless mode, or when answering targeted questions about individual metrics.

```matlab
generateReport(me, Dashboard="ModelUnitTesting", Type="html-file", Location=pwd);
```

| Argument | Values |
|----------|--------|
| `Dashboard` | Same values as `getAvailableMetricIds` |
| `Type` | `"pdf"` (default), `"html-file"` |
| `Location` | Output file path or directory (string). If a directory, the filename is auto-generated. |
| `LaunchReport` | `true` (default) or `false` for CI |

Available from R2021a. In R2026a+, `Dashboard` is mandatory.

## Key Functions

All functions below are available from R2023a (the minimum release for this skill) unless noted otherwise.

| Function | Purpose |
|----------|---------|
| `metric.Engine` | Create engine instance (requires open project) |
| `updateArtifacts(me)` | Refresh artifact traceability index |
| `getAvailableMetricIds(me)` | Discover installed metric IDs |
| `execute(me, ids)` | Run metric collection |
| `getMetrics(me, ids)` | Retrieve collected results |
| `generateReport(me, ...)` | Generate HTML/PDF report |
| `getArtifactIssues(me)` | Return diagnostic warnings/errors |
| `getArtifactErrors(me)` | Return artifact-level errors |
| `executeDashboardMetrics(me, Dashboard=d)` | Convenience: discover + execute (no output; call `getMetrics` after). Does NOT accept `App`. Primarily for `ProjectModelTesting`. **R2026a+** |

## Patterns

### Collect Metrics for a Single Dashboard

```matlab
me = metric.Engine;
updateArtifacts(me);
ids = getAvailableMetricIds(me, App="DashboardApp", Dashboard="ModelUnitTesting");
execute(me, ids);
results = getMetrics(me, ids);
```

### Collect Across Multiple Dashboards

Use the try-catch pattern in `references/metric-groups.md` § "Pattern: Safe Multi-Dashboard Collection".

### Generate Report

```matlab
me = metric.Engine;
ids = getAvailableMetricIds(me, App="DashboardApp", Dashboard="ModelMaintainability");
execute(me, ids);
generateReport(me, Dashboard="ModelMaintainability", Type="html-file", Location=pwd);
```

Do NOT build HTML manually with `fopen`/`fprintf`. Use the built-in `generateReport`.

### Diagnose Artifact Issues

When metrics show errors or return empty results, use `getArtifactIssues` and `getArtifactErrors` to diagnose the problem — do not manually inspect project files, `.prj` internals, data dictionaries, or file paths as a workaround.

```matlab
me = metric.Engine;
issues = getArtifactIssues(me);
errors = getArtifactErrors(me);
if ~isempty(issues)
    disp(issues);
end
if ~isempty(errors)
    disp(errors);
end
```

### CI / Headless Usage

```matlab
me = metric.Engine;
updateArtifacts(me);
ids = getAvailableMetricIds(me, App="DashboardApp", Dashboard="ModelUnitTesting");
execute(me, ids);
results = getMetrics(me, ids);
generateReport(me, Dashboard="ModelUnitTesting", Type="html-file", ...
    Location="reports", LaunchReport=false);

% Detect test failures via TestStatusDistribution (R2026a+)
% On R2026a+, BinEdges is a cell array of strings: {'Failed','Passed','Disabled','Not run','Untested'}
% On older releases, BinEdges may be numeric — strcmp will return scalar false; use index-based access instead.
hasFailures = false;
for k = 1:numel(results)
    v = results(k).Value;
    if isstruct(v) && isfield(v, 'BinCounts') && isfield(v, 'BinEdges') && iscell(v.BinEdges)
        failIdx = strcmp(v.BinEdges, 'Failed');
        if any(failIdx) && v.BinCounts(failIdx) > 0
            hasFailures = true;
            break;
        end
    end
end
if hasFailures
    exit(1);
end
```

The failure-detection logic above is reference code validated against `slcomp.mt.TestStatusDistribution` on R2026a. Struct fields and bin labels may differ across releases or metric IDs — use `fieldnames(v)` to confirm the shape before accessing fields programmatically.

Use `LaunchReport=false` in CI to prevent opening a browser. Use exit codes for pipeline integration.

For structured CI/CD pipelines that orchestrate metric collection alongside code generation, testing, standards checking, and other verification tasks — with automatic pipeline configuration generation for Jenkins, GitLab, GitHub Actions, or Azure DevOps — use the "CI/CD Automation for Simulink Check" support package (`padv.builtin.task.CollectMetrics`) and a `processmodel.m` file instead. That approach is worthwhile when you need multiple built-in tasks (e.g., `RunModelStandards`, `GenerateCode`, `RunTestsPerModel`, `CollectMetrics`) orchestrated together with pipeline generation, not for one-off metric collection.

## Conventions

**Always:**
- Call `getAvailableMetricIds` before `execute` — discover IDs at runtime
- Call `updateArtifacts` before collecting testing/SIL/PIL metrics
- Inspect `.Value` type before formatting (use `isstruct`, `isnumeric`, `ismissing`)
- Use a single `metric.Engine` instance per session
- Pass `App="DashboardApp"` when scoping `getAvailableMetricIds` by dashboard

**Never:**
- Hardcode metric IDs — they change across releases and fail silently
- Use `getMetricResult` or `getMetricResults` — correct method is `getMetrics`
- Use `metric.report.Report` — correct method is `generateReport` on the engine
- Use `metric.config.getActiveConfiguration` or `reset()` — these do not exist
- Call `getAvailableMetricIds` as a static/package function — it is a method on the engine instance: `getAvailableMetricIds(me, ...)`

**Prefer:**
- `getAvailableMetricIds(me, App="DashboardApp", Dashboard=d)` over unscoped `getAvailableMetricIds(me)` when targeting a specific assessment area
- `generateReport` over manual HTML construction
- `getArtifactIssues`/`getArtifactErrors` over manual project file inspection for diagnostics

## Common Mistakes

| Mistake | Why It Fails | Correct Approach |
|---------|-------------|-----------------|
| Hardcoding metric IDs like `"TestCaseStatus"` or `"mathworks.metrics.CyclomaticComplexity"` | IDs change across releases; old IDs emit warning and return 0 results (no exception) | Call `getAvailableMetricIds(me, App="DashboardApp", Dashboard="...")` |
| `generateReport(me, ids, Type="table")` | Metric IDs are not a valid positional argument; `Type="table"` does not exist | `generateReport(me, Dashboard="...", Type="html-file")` |
| Skipping `updateArtifacts` | Testing metrics return stale/empty traceability and coverage data | Always call `updateArtifacts(me)` before testing metric collection |
| Assuming `.Value` is a scalar or enum | Many metrics return structs (distributions, coverage breakdowns, named counts) | Inspect with `isstruct(v)`, `fieldnames(v)` before formatting |
| Calling `getAvailableMetricIds` as a static/package function | Not a static function — it is a method on a `metric.Engine` instance | `getAvailableMetricIds(me)` where `me` is an engine instance |
| `executeDashboardMetrics(me, App="DashboardApp", Dashboard=d)` | `executeDashboardMetrics` does not accept `App` — only `Dashboard` | `executeDashboardMetrics(me, Dashboard=d)` — and still call `getMetrics` after (no output argument) |
| 12+ steps of manual file inspection for diagnostics | Built-in APIs exist specifically for this | Call `getArtifactIssues(me)` and `getArtifactErrors(me)` first |

## References

- `references/metric-groups.md` — valid `Dashboard` argument values, introduction releases, ID counts per release, multi-dashboard collection pattern. Consult when choosing which dashboard to scope to.
- `references/release-notes.md` — API availability timeline, breaking changes across releases, conditional code patterns for cross-release support. Consult when writing code that must work across R2023a–R2026a.
- `references/documentation-links.md` — authoritative MathWorks documentation URLs for `metric.Engine` and related APIs. Consult when the user needs links to official docs.
- **`matlab-read-documentation` skill** (from `matlab-core` in the MATLAB Agentic Toolkit) — reads MathWorks documentation pages directly. Use this skill when you are stuck: repeated errors, unexpected API behavior, or needing to verify function signatures beyond what `help` provides. Start from `https://www.mathworks.com/help/slcheck/` (Simulink Check, which covers metrics and the testing dashboard).

----

Copyright 2026 The MathWorks, Inc.

----
