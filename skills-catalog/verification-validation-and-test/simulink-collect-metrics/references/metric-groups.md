# Metric Groups (Dashboard Scopes)

Metrics are organized into dashboards. Use the `Dashboard` argument to scope collection:

```matlab
ids = getAvailableMetricIds(me, App="DashboardApp", Dashboard="ModelUnitTesting");
```

## Available Dashboards

| Dashboard | Introduced | Purpose |
|-----------|-----------|---------|
| `ModelUnitTesting` | R2021b | Test status, coverage, requirements traceability for a unit |
| `ModelMaintainability` | R2022b | Size, complexity, cyclomatic complexity, architecture |
| `ModelUnitSILTesting` | R2023a | SIL back-to-back test status and code coverage |
| `ModelUnitPILTesting` | R2023a | PIL back-to-back test status and code coverage |
| `ProjectModelTesting` | R2025a | Cross-project summary of testing metrics (use `executeDashboardMetrics` (R2026a+) for this dashboard) |

## Scoping Rules

- Always pass `App="DashboardApp"` — without it, the `Dashboard` argument is ignored.
- If a dashboard does not exist in the current release, `getAvailableMetricIds` throws an error. Use try-catch when targeting multiple releases.
- Calling `getAvailableMetricIds(me)` with no scope returns all installed metric IDs (superset of all dashboards plus unscoped metrics).

## Pattern: Safe Multi-Dashboard Collection

```matlab
me = metric.Engine;
dashboards = ["ModelUnitTesting", "ModelMaintainability", ...
              "ModelUnitSILTesting", "ModelUnitPILTesting"];
for d = dashboards
    try
        ids = getAvailableMetricIds(me, App="DashboardApp", Dashboard=d);
        execute(me, ids);
    catch e
        fprintf("Dashboard %s not available: %s\n", d, e.message);
    end
end
results = getMetrics(me, getAvailableMetricIds(me));
```

## Standalone Metrics (Not in Any Dashboard)

Calling `getAvailableMetricIds(me)` with no `App`/`Dashboard` arguments returns the full superset of installed metric IDs. This superset includes metrics that do not belong to any dashboard — for example, `DataSegmentEstimate`, `OperatorCount`, and model-level aggregations that appear only in project-level views.

These standalone metrics are valid targets for `execute` and `getMetrics` but do not appear in `generateReport` (which requires a `Dashboard` argument). If a user asks about a metric that is not in any dashboard listed above, use unscoped discovery to find it:

```matlab
allIds = getAvailableMetricIds(me);
% Filter or search by partial name
matches = allIds(contains(string(allIds), "DataSegment"));
```

This skill focuses on dashboard-scoped collection. For standalone metrics, discover them with the unscoped call and inspect results with the same `getMetrics` pattern.

----

Copyright 2026 The MathWorks, Inc.

----
