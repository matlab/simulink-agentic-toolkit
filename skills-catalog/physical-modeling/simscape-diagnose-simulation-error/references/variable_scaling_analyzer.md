# Variable Scaling Analyzer (variable_scaling_analyzer_run → VariableScaling)

Analyzes the **numerical scaling** of continuous states over a simulation:
identifies states that are effectively zero, orders of magnitude larger than
others, or spiky — the poorly-conditioned states that can slow the solver. Also
reports the tolerance settings in effect and suggests remedies. This is the same
analysis as the Variable Scaling Analyzer GUI.

Unlike the initialization packages, `variable_scaling_analyzer_run` runs the model over its
configured time interval (not `StopTime='0'`) because scaling is judged from the
transient trajectory.

`variable_scaling_analyzer_run` compiles and simulates the model and returns a
`simscape.agentic.VariableScaling` object. Call it as
`simscape.agentic.variable_scaling_analyzer_run(...)`, then query the object with
dot syntax (`scaling.scalingTable`, `scaling.suggestions`, …).

> **Requires a Simscape network.** The model must contain at least one Simscape
> network (i.e. a Solver Configuration block). On a plain Simulink model
> `variable_scaling_analyzer_run` errors with `simscape_debug:NoSimscapeNetwork`
> rather than surfacing a raw internal parameter failure.

> **Unsupported configurations.** The analysis needs the *global* solver's
> continuous trajectory, so two configurations are rejected up front:
> - **Local solver** (`UseLocalSolver='on'` on any Solver Configuration block) —
>   errors with `variable_scaling_analyzer:LocalSolverNotSupported`. A local
>   solver discretizes the states, leaving no continuous trajectory to analyse.
> - **Rapid-accelerator** simulation mode — errors with
>   `variable_scaling_analyzer:RapidAcceleratorNotSupported`.
>
> **Simscape Multibody** models are not supported.

---

## variable_scaling_analyzer_run

Simulate the model with continuous-state logging and collect the time-series
plus tolerance settings into a `VariableScaling` object.

```matlab
% TEMPLATE — not executable
scaling = simscape.agentic.variable_scaling_analyzer_run(modelName)
scaling = simscape.agentic.variable_scaling_analyzer_run(modelName, Name=Value)
```

### Inputs

| Argument | Type | Description |
|----------|------|-------------|
| `modelName` | string | Model name. Loaded automatically if not already open. |

**Name-Value pairs:**

| Name | Description |
|------|-------------|
| `StartTime` | Override simulation start time. |
| `StopTime` | Override simulation stop time. |

### Returned object — `VariableScaling`

Read-only properties:

| Property | Meaning |
|----------|---------|
| `ModelName` | Model name. |
| `Success` | `true` if the simulation completed. |
| `DiagnosticMessage` | Simulation error message (empty on success). |
| `WarningMessage` | Simulation warning message (empty on clean run). |
| `Solver` | Compiled solver name. |
| `AbsTol` / `RelTol` | Resolved absolute / relative tolerances. |
| `IsAutoScaleAbsTol` | `true` if `AutoScaleAbsTol` is on (and not `daessc`). |
| `IsNominalEnabled` | `true` if `SimscapeNormalizeSystem` is on. |
| `NumStates` | Number of scalarized continuous states. |
| `StateNames`, `Blocks`, `NominalUnits` | Per-state metadata (string arrays). |
| `Time`, `StateData` | Time vector and `[nTime x NumStates]` data matrix. |

The object is a value class and is fully serializable — `save()` it and query
offline.

---

## Methods

Call these on the object returned by `run`.

| Method | Returns | Use it to … |
|--------|---------|-------------|
| `scalingTable()` | table (see columns below), sorted by `StdDevData` descending | Get per-state scaling statistics with a flag on the poorly-scaled states. Start here. |
| `suggestions()` | string array | Get actionable, prioritized remedies for the flagged states. |

### `scalingTable()` columns

| Column | Meaning |
|--------|---------|
| `StateName` | Full state path. |
| `NominalUnits` | `"{value, 'unit'}"` nominal value and unit. |
| `PercentTimeBelowAbsTol` | % of sim time the state was below AbsTol (high ⇒ effectively zero). |
| `MinData` / `MaxData` | Range of the state. |
| `MeanAbsData` | Time-weighted mean of `|state|`. |
| `LogMaxAbsData` | `log10(max(|state|))`. |
| `StdDevData` | Time-weighted standard deviation. |
| `IsFlagged` | `true` if any scaling heuristic tripped (see below). |

Empty when there are no continuous states, or the run has fewer than two
distinct time points (e.g. `StopTime == StartTime`).

### Flagging heuristics

A state is flagged when any of:

- **% Time Below AbsTol > 50%** — state spends most of the sim below tolerance
  (the solver effectively sees it as zero).
- **MeanAbsData > 10000 × median** — state is far larger than its peers (poor
  relative conditioning).
- **LogMaxAbsData > log10(10000 × MeanAbsData)** — large transient spikes
  relative to the mean.
- **Min and Max both within 5 × AbsTol** (only when auto-scaling is off) — state
  is only marginally above tolerance.

### `suggestions()`

Actionable, prioritized remedies based on the flagging heuristics — e.g. enable
nominal values, turn off `AutoScaleAbsTol`, or set a global nominal for a unit
where most states are flagged. Returns a single informational message when there
are no continuous states, when the model errored, or when nothing is flagged
("all states appear well-scaled"). The last line always reminds you to re-run
after making changes.

---

## Raw trajectories

The logged trajectories and their metadata are read-only properties on the
object — no accessor needed. Use `scaling.Time`, `scaling.StateData`
(`[nTime x NumStates]`), `scaling.StateNames`, `scaling.NominalUnits`, and
`scaling.Blocks` directly for custom plotting/analysis.

```matlab
idx = contains(scaling.StateNames, "Inductor");
plot(scaling.Time, scaling.StateData(:, idx));
legend(scaling.StateNames(idx));
```

---

## Typical workflow — "simulation is slow / poorly conditioned"

```matlab
scaling = simscape.agentic.variable_scaling_analyzer_run('myModel');
T       = scaling.scalingTable;              % per-state statistics
flagged = T(T.IsFlagged, :);                 % the problem states
msgs    = scaling.suggestions;               % remedies
```

Group the flagged states by unit to decide which nominal values to add, then
apply them with `nominal_values` and re-run to confirm improvement.

---

## Release compatibility

Supported from **R2023a** onward.

| Release | Supported |
|---------|-----------|
| R2023a and later | Yes |

----

Copyright 2026 The MathWorks, Inc.

----
