# Statistics Viewer (statistics_viewer_run → ModelStatistics)

Reports **model complexity and structure**: continuous/discrete/eliminated
variable counts, constraints, zero-crossings, partition breakdown, and
PS/Simulink converter inventory. This is the same data shown in the Simscape
Statistics Viewer. Use it to size a model before deciding whether to enable
partitioning, or to see which blocks contribute the most variables.

`statistics_viewer_run` compiles the model and returns a
`simscape.agentic.ModelStatistics` object. Call it as
`simscape.agentic.statistics_viewer_run(...)`, then query the object with dot
syntax (`stats.summary`, `stats.variables`, …).

---

## statistics_viewer_run

Compile the model (a model update) and collect all statistics into a
`ModelStatistics` object.

```matlab
stats = simscape.agentic.statistics_viewer_run(modelName);
```

### Inputs

| Argument | Type | Description |
|----------|------|-------------|
| `modelName` | string | Model name. Loaded automatically if not already open. |

Statistics reflect the model's **current** solver configuration. This function
does not change solver settings. Partitioning statistics appear only when the
model already has the partitioning local solver enabled on its Solver
Configuration block(s) — `UseLocalSolver = 'on'` and
`LocalSolverChoice = 'NE_PARTITIONING_ADVANCER'`. That configuration is a
precondition set on the model, not by this API. Apply it with the `model_edit`
tool.

**Multi-network models:** statistics are a single model-wide aggregate summed
over all Simscape networks (there is no per-network statistics query), and the
partition table cannot attribute partitions to individual networks. For a
coherent partition total, enable the local solver on every network's Solver
Configuration block.

### Returned object — `ModelStatistics`

Read-only properties:

| Property | Meaning |
|----------|---------|
| `ModelName` | Model name (char). |

The run compiles the model; a compile failure throws (the error propagates to
the caller) rather than being reported through a status property.

The object is a value class and is fully serializable — `save()` it and query
offline.

---

## Methods

Call these on the object returned by `run`.

| Method | Returns | Use it to … |
|--------|---------|-------------|
| `summary()` | struct of headline counts (see [below](#summary-fields)) | Get the at-a-glance complexity numbers — variable counts, constraints, zero-crossings, partition/converter totals. Start here. |
| `variables()` | table `Category`, `Count`, `Description` | See the variable breakdown by category (continuous = algebraic + differential, discrete, eliminated, secondary). |
| `partitions()` | table `Partition`, `Type`, `NumEquations`, `NumVariables`, `NumModes`, `NumConfigs`, `MemoryKB` | Inspect per-partition detail. **Empty unless** the model uses the partitioning solver. Large nonlinear partitions are the usual performance bottleneck. |
| `converters()` | table `BlockPath`, `Direction`, `Unit` | Inventory the PS/Simulink converter blocks — the interface points between the physical network and the Simulink signal domain. |
| `multibody()` | table `Statistic`, `Value`, `Description` | Inspect the Simscape Multibody statistics (e.g. number of bodies, joints, constraints). **Empty unless** the model contains a Simscape Multibody network. |
| `tables(category)` | table of the individual items behind a `summary()` count (see [below](#tablescategory-categories)) | Drill from a headline count into the items that make it up — the specific variables, constraints, or zero-crossings. Answers "what makes this model so big?". Empty if the category has no items. |

### `summary()` fields

| Field | Meaning |
|-------|---------|
| `numContinuousVars` | Continuous variables after elimination. |
| `numAlgebraicVars` | Algebraic continuous variables. |
| `numDifferentialVars` | Differential (dynamic state) variables. |
| `numDiscreteVars` | Discrete variables. |
| `numEliminatedVars` | Variables removed by elimination. |
| `numSecondaryVars` | Secondary variables. |
| `numConstraints` | Constraint equations. |
| `numZeroCrossings` | Zero-crossing signals. |
| `numPartitions` | Partition count (`0` if not partitioned). |
| `totalMemoryKB` | Estimated partition memory in kB (`0` if N/A). |
| `numPSOutputs` | PS→Simulink converters. |
| `numPSInputs` | Simulink→PS converters. |

### `tables(category)` categories

`category` is one of the following names:

| Category | Items listed |
|----------|--------------|
| `"ContinuousVariables"` | Continuous variables retained after elimination. |
| `"AlgebraicVariables"` | Algebraic continuous variables. |
| `"DifferentialVariables"` | Differential (dynamic state) variables. |
| `"DiscreteVariables"` | Discrete variables. |
| `"EliminatedVariables"` | Variables removed by elimination. |
| `"SecondaryVariables"` | Secondary variables. |
| `"Constraints"` | Variables coupled by each constraint equation. |
| `"ZeroCrossings"` | Sources of each zero-crossing signal. |

The variable categories return columns `BlockPath`, `Variable`, `Description`
— one row per variable. `"Constraints"` and `"ZeroCrossings"` return a leading
`Item` column naming the constraint / signal that groups the rows, since a
single constraint or signal couples several variables:
columns `Item`, `BlockPath`, `Variable`, `Description`.

An unrecognized category name raises `simscape:agentic:UnknownCategory`.

### `partitions()` type column

`Type` is one of `"Nonlinear"`, `"Linear time-invariant"`,
`"Linear time-varying"`, `"Switched linear"`, or `"Explicit"`.

---

## Typical workflow — "how complex is this model?"

```matlab
stats = simscape.agentic.statistics_viewer_run('myModel');
s     = stats.summary;                                   % headline counts
V     = stats.variables;                                 % category breakdown
elim  = stats.tables("EliminatedVariables");             % what got eliminated
```

To inspect partitioning, the model must already have the partitioning solver
enabled on each network's Solver Configuration block (see the precondition under
[`statistics_viewer_run`](#statistics_viewer_run)). Once it is configured, run:

```matlab
stats = simscape.agentic.statistics_viewer_run('myModel');
P     = stats.partitions;                                % partition detail
```

---

## Reading the constraint count

- The constraint count in the Statistics Viewer reflects equations identified during index reduction. This includes constraints from both linear index reduction and nonlinear index reduction (Derivative Replacement or Projection). A non-zero count does not guarantee all constraints are covered — some may come from linear index reduction while the problematic nonlinear constraint remains unreduced.
- Zero constraints does not always mean index reduction failed — it can also mean the system is genuinely index-1 (no constraints to reduce). The empirical approach in the skill's Index Reduction path (compare N1 vs N2) handles both cases correctly.
- Projection adds secondary variables to the system (visible as `numSecondaryVars` in the statistics summary). This is expected: it shows Projection is active.

---

## Release compatibility

Supported on **R2023a and later**.

----

Copyright 2026 The MathWorks, Inc.

----
