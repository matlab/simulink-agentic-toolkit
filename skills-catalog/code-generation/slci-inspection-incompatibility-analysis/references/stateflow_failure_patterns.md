# Common Stateflow Failure Patterns

## Traceability Comments

In Stateflow-generated code, traceability comments use the format
`/* '<S1>:XX' */` where XX is the Stateflow object ID. Multiple such comments
on adjacent lines indicate a merge junction pattern — the code corresponds to
several transitions converging at a single junction. When interpreting failures
in Stateflow code, group adjacent traceability comments to identify the full
transition path before matching against constraints.

## Quick-Triage Table

Mapping generated code patterns to constraint parameters.
If a pattern matches, go directly to the referenced constraint for verification.

Always apply the 3-check verification (scope, mechanism, contradictions) before
declaring a match.

| Generated Code Pattern | Likely Root Cause | Constraint Parameter | Reference |
|------------------------|-------------------|---------------------|-----------|
| Transition action executes without condition guard | Action before condition | `SFTransitionActionBeforeConditionDiag` | diagnostics_constraints.md §22 |
| Unreachable `else` branch in state logic | Unreachable execution path | `SFUnreachableExecutionPathDiag` | diagnostics_constraints.md §20 |
| Event broadcast fans out to all parallel states | Undirected event broadcast | `SFUndirectedBroadcastEventsDiag` | diagnostics_constraints.md §21 |
| Exit/entry actions span multiple parent levels | Transition outside natural parent | `SFTransitionOutsideNaturalParentDiag` | diagnostics_constraints.md §19 |
| Input data read during chart `_initialize` function | Invalid input access in init | `SFInvalidInputDataAccessInChartInitDiag` | diagnostics_constraints.md §17 |
| No default case in state entry switch | Missing unconditional default transition | `SFNoUnconditionalDefaultTransitionDiag` | diagnostics_constraints.md §18 |
| Transition side effects repeated then overwritten | Unexpected backtracking | `SFUnexpectedBacktrackingDiag` | diagnostics_constraints.md §16 |

----

Copyright 2026 The MathWorks, Inc.

----
