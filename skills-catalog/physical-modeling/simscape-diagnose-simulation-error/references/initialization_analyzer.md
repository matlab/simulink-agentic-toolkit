# Initialization Analyzer (initialization_analyzer_run → InitializationAnalysis)

Diagnoses **initialization (IC/CIC) solve failures**: which states diverge during
the Newton solve, which initial-condition targets are not reached, and which
blocks to investigate. Use this package when a Simscape model fails to
initialize, gives wrong initial values, or the solver does not converge.

`initialization_analyzer_run` records the state trajectory of every Newton
iteration and returns a `simscape.agentic.InitializationAnalysis` object. A
single run may capture several *solves* (IC, CIC, and re-solves after mode
changes); every per-solve method takes a 1-based `solveIdx` (default `1`) to
choose which one.

> **Not supported:** models with the local solver enabled, `rapid-accelerator`
> mode, or `LoadInitialState='on'`. `run` errors with an actionable message in
> these cases. For local-solver models, use `variable_viewer` instead.

The run function lives in the `simscape.agentic` namespace — call it as
`simscape.agentic.initialization_analyzer_run(...)`. It returns an object; call
its methods with dot syntax (`analysis.stateTable(...)`).

---

## initialization_analyzer_run

Simulate the model with state tracing on and collect all initialization solve
data into an `InitializationAnalysis` object.

```matlab
% TEMPLATE — not executable
analysis = simscape.agentic.initialization_analyzer_run(modelName)
analysis = simscape.agentic.initialization_analyzer_run(modelName, solverConfigPath)
analysis = simscape.agentic.initialization_analyzer_run(__, Name=Value)
```

### Inputs

| Argument | Type | Description |
|----------|------|-------------|
| `modelName` | string | Model name. Loaded automatically if not already open. |
| `solverConfigPath` | string (optional) | Path to the Solver Configuration block. Auto-detected only when the model has exactly one. A model with multiple Solver Configuration blocks (one per Simscape network) is ambiguous and errors with `initialization_analyzer:AmbiguousSolverConfig` unless a path is given — each network has its own IC solve, so you analyse one at a time. Must name a Solver Configuration block — an unknown path or a non-solver block errors with `initialization_analyzer:InvalidSolverConfig`. |

**Name-Value pairs:**

| Name | Description |
|------|-------------|
| `StartTime` | Simulation start time (default: model setting). |
| `StopTime` | Simulation stop time (default: model setting). Use `"0"` for IC-only. |
| `LogStart` / `LogStop` | Window over which the state trace is recorded (default: full interval). |
| `BufferSize` | Maximum number of stored solves (default: all). |

### Returned object — `InitializationAnalysis`

Read-only properties:

| Property | Meaning |
|----------|---------|
| `ModelName` | Model name (char). |
| `SolverConfigPath` | Resolved Solver Configuration block path. |
| `Success` | `true` if the simulation completed without error. |
| `DiagnosticMessage` | Simulation error message (empty on success). |
| `NumSolves` | Number of solves captured. |

The object is a value class and is fully serializable — `save()` it and query
offline.

---

## Methods

Call these on the object returned by `run`. Each per-solve method takes an
optional 1-based `solveIdx` (default `1`).

| Method | Returns | Use it to … |
|--------|---------|-------------|
| `solveEvents()` | table `Index`, `Name`, `Time` | List every solve captured; pick a `solveIdx`. Call this first. |
| `stateTable(solveIdx, DivergenceLimit=1e10)` | table `State`, `NominalUnit`, `Diverged`, `Priority`, `Target` | The primary at-a-glance diagnostic — the same rows the Initialization Analyzer state table shows. `Diverged` is an ordinal categorical (iteration of first divergence, or `"Did not diverge"`); rows other than `"Did not diverge"` are the problem states. |
| `suggestions(solveIdx, DivergenceLimit=1e10)` | string array (empty if no issues) | Human-readable recommendations: blocks that diverged earliest, and blocks with mandatory/optional targets not reached. |
| `targets(solveIdx)` | `[targets, priorities]` (double `[n×1]`, string `[n×1]`) | Raw target values and priorities (see [priority meanings](#priority-meanings)). A `"None"`-priority (prestart) state carries its prestart value as the target. Both outputs are empty (`[]`) for CIC and other non-IC solves. |
| `trajectories(solveIdx)` | struct: `X` (dictionary: state name → `[nIter×1]`), `names`, `units`, `blocks`, `isDifferential`, `initMode`, `index` | Full per-iteration convergence path with metadata. Deep diagnostic — use when `suggestions` is insufficient. `X{name}` returns one state's iteration history; `keys(X)` lists the state names. `initMode` is `"High"`/`"Low"`/`"None"`. |
| `divergenceInfo(solveIdx, DivergenceLimit=1e10)` | struct: `divergedArray`, `firstDivergence`, `isDiverged`, `divergedBlocks`, `earliestDivIter` | Quantitative divergence analysis behind `stateTable`'s `Diverged` column. `divergedBlocks` are the blocks that diverged **at the earliest iteration** — the prime suspects. |
| `solverEvents(solveIdx)` | struct: `switches`, `failures` (each `N×3` cell `{iterIdx, solverName, label}`) | Solver phase transitions and trouble signals (singular Jacobian, fallback to the robust Newton solver, relaxed re-solves) parsed from the logged messages. |

### Priority meanings

| Priority | Meaning |
|----------|---------|
| `High` | High-priority target the solver **must** satisfy. Unreachable high-priority targets are the usual cause of a failed IC solve. |
| `Low` | Low-priority target the solver tries to satisfy. |
| `None` | No target; the solver is free to choose the value. |

---

## Typical workflow — "my model won't initialize"

```matlab
analysis = simscape.agentic.initialization_analyzer_run('myModel', StopTime="0");
analysis.solveEvents                                    % which solves exist
T    = analysis.stateTable(1, DivergenceLimit=1e8);     % per-state diagnostic
msgs = analysis.suggestions(1);                         % apply the suggested fix
```

Drill deeper only if the suggestions are unclear:

```matlab
div  = analysis.divergenceInfo(1);                      % earliest diverging blocks
traj = analysis.trajectories(1);                        % full iteration path
```

---

## Release compatibility

Supported from **R2026a** onward. On an earlier release the backing Simscape
APIs are absent and `initialization_analyzer_run` raises
`simscape_debug:UnsupportedRelease`.

| Release | Supported |
|---------|-----------|
| R2026a and later | Yes |
| R2025b and earlier | No — `simscape_debug:UnsupportedRelease` |

----

Copyright 2026 The MathWorks, Inc.

----
