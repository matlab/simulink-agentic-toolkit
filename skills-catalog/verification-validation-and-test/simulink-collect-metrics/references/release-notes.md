# Release Compatibility

## API Availability

| API | Introduced | Notes |
|-----|-----------|-------|
| `metric.Engine` | R2020b | Core object; requires an open project |
| `getAvailableMetricIds` | R2021b | Core discovery function — always use this |
| `updateArtifacts` | R2021b | Traces project artifacts before collection |
| `execute` | R2020b | In R2026a+, returns results directly |
| `getMetrics` | R2020b | Still valid; required before R2026a |
| `generateReport` | R2021a | Requires `Dashboard` argument in R2026a+ |
| `getArtifactIssues` | R2023a | Returns diagnostic errors/warnings |
| `executeDashboardMetrics` | R2026a | Convenience method for dashboard-scoped collection |

## Breaking Changes

| Release | What Changed |
|---------|-------------|
| R2026a | `generateReport` errors without `Dashboard` argument. Several metric `.Value` properties changed from numeric to struct (e.g., `Status: 'Failed'` instead of `0`). Distribution `BinEdges` changed from numeric vectors to cell arrays. |
| R2023a | Test/coverage metric IDs consolidated — e.g., `TestCaseStatus` → `slcomp.mt.TestStatus`, four coverage IDs → `slcomp.mt.CoverageBreakdown`. |
| R2022b | `"RequirementsBasedModelUnitTesting"` dashboard argument removed. Use `"ModelUnitTesting"`. |

## Conditional Patterns

Guard `generateReport` for R2026a+ (where `Dashboard` is mandatory):

```matlab
me = metric.Engine;
execute(me, ids);
if ismethod(me, 'generateReport')
    generateReport(me, Dashboard="ModelUnitTesting");
end
```

Guard against cross-release namespace changes — never hardcode IDs:

```matlab
me = metric.Engine;
ids = getAvailableMetricIds(me, App="DashboardApp", Dashboard="ModelUnitTesting");
% ids contains release-appropriate names; pass them directly to execute
execute(me, ids);
```

----

Copyright 2026 The MathWorks, Inc.

----
