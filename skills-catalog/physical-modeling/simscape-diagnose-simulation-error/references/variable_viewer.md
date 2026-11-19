# Variable Viewer (variable_viewer_*)

Inspects the **initial state of every variable** after the model is compiled and
initialized: which initial conditions were satisfied, at what priority, which
variables are differential vs. eliminated, and their solved start values. This is
the same data shown in the Variable Viewer app.

Unlike `initialization_analyzer`, `variable_viewer` does not record Newton iterations — it
reports the *outcome* of the IC solve, not the path taken. It works on models
that `initialization_analyzer` cannot handle (e.g. local-solver models), so it is the fallback for
answering "which ICs were not met?".

**Scope: variables (observables), not solver states.** `variable_viewer`
reports the model's *observable variables* — the physical quantities exposed by
each block (e.g. a capacitor's voltage and charge). This set can differ from the
*solver states* that `initialization_analyzer` traces
through the Newton solve: after elimination the solver may carry a different,
usually smaller, set of quantities than the full observable list, and some
observables are algebraically derived rather than solved for directly. Expect
the variable list here to differ from the state list reported by
`initialization_analyzer` for the same model.

> **Requires a Simscape network.** The model must contain at least one Simscape
> network (i.e. a Solver Configuration block). On a plain Simulink model
> `variable_viewer_run` errors with `simscape_debug:NoSimscapeNetwork` rather
> than surfacing a raw internal state-kernel failure.

> **Unsupported configuration: rapid-accelerator.** `variable_viewer_run`
> simulates the model (`sim` with `StopTime='0'`), so it rejects
> **rapid-accelerator** simulation mode up front with
> `variable_viewer:RapidAcceleratorNotSupported` rather than building an
> expensive rapid-accelerator target. Change `SimulationMode` to `'normal'` or
> `'accelerator'`.

All functions live in the `simscape.agentic` namespace — call them as
`simscape.agentic.variable_viewer_run(...)`, etc.

---

## variable_viewer_run

Compile and initialize the model (`sim` with `StopTime='0'`, which runs the
initial-condition solve) and retrieve the initial state data for every variable.

```matlab
results = simscape.agentic.variable_viewer_run(modelName);
```

### Inputs

| Argument | Type | Description |
|----------|------|-------------|
| `modelName` | string | Model name. Loaded automatically if not already open. |

### Output — `results` struct

| Field | Meaning |
|-------|---------|
| `modelName` | Model name. |
| `data` | Struct array, one element per variable. Fields listed in the [field reference](#field-reference). |

A model that fails to compile/initialize throws (with its Simulink message);
the returned struct always holds retrieved data.

`results.data` is a plain struct array — one element per variable, every field a
scalar. Each element carries the [field reference](#field-reference) fields,
addressed by name: `BlockPath`, `Variable`, `Path`, `Eliminated`, `Priority`,
`TargetValue`, `TargetUnit`, `PrestartValue`, `PrestartUnit`, `StartValue`,
`StartUnit`, `Satisfied`, `Determined`, `Differential`, `Representation`,
`NominalSource`, `NominalValue`, `NominalUnit`. `Eliminated`, `Satisfied`,
`Determined`, and `Differential` are logical; `Priority` is a string (`"High"` /
`"Low"` / `"None"`).

> **Release-dependent fields.** Not every field is produced on every release:
> the underlying Simscape state record does not carry every field on older
> releases, so `variable_viewer_run` **omits** the fields a release cannot
> supply rather than emitting them empty or gating the tool out entirely — see
> [Release compatibility](#release-compatibility). Before reading a
> release-dependent field (`BlockPath`, `Variable`, `PrestartValue`,
> `PrestartUnit`), guard with an `isfield` check so your code works across
> releases:
>
> ```matlab
> if isfield(results.data, "BlockPath")
>     % ... use [results.data.BlockPath]
> end
> ```

### Useful table filters

For filtering, sorting, and counting, turn the struct array into a table — this
is where a table earns its keep, since row-masking and `sortrows` have no clean
struct-array equivalent:

```matlab
T = struct2table(results.data);
```

Address columns by name (`T.Satisfied`, `T(:, ["Path","Priority"])`); the column
*order* carries no meaning and may differ across releases as fields are dropped.
Each filter below is a one-liner over `T`. Row-mask with `T(mask,:)`, then
select columns by name if you want a narrower view.

```matlab
% High-priority ICs that were NOT met — the primary initialization
% diagnostic (solver could not reach the requested target). Compare
% TargetValue vs StartValue to see how far off each miss was.
conflicts = T(T.Priority == "High" & ~T.Satisfied,:);

% Low-priority ICs that were NOT met. Low targets are best-effort, so a
% miss is normal; check them only if the start values look physically
% wrong or the user expected that target to hold.
lowMisses = T(T.Priority == "Low" & ~T.Satisfied,:);

% All unsatisfied variables. Priority "None" variables have no requested
% target, so most of them show up here; that alone is not an IC problem.
U = T(~T.Satisfied,:);

% Differential (continuous) states integrated by the ODE solver
D = T(T.Differential,:);

% Eliminated variables (algebraically removed, derived from others)
E = T(T.Eliminated,:);

% Input-dependent (determined) variables
det = T(T.Determined,:);

% Narrow to a subset of columns
conflicts(:, ["Path","Priority","TargetValue","StartValue","Differential"])

% Sort by how far the solved value missed the target
T.Miss = abs(T.StartValue - T.TargetValue);
sortrows(T, "Miss", "descend")
```

### Summary counts

A quick health check — count rows on the same table. A non-zero `unmetHigh`
count is the signal that initialization did not fully succeed. A non-zero
`unsatisfied` count on its own is not: it includes the Priority "None" variables.

```matlab
total       = height(T);
differential = nnz(T.Differential);
eliminated   = nnz(T.Eliminated);
algebraic    = nnz(~T.Differential & ~T.Eliminated);
satisfied    = nnz(T.Satisfied);
unsatisfied  = nnz(~T.Satisfied);
unmetHigh    = nnz(T.Priority == "High" & ~T.Satisfied);
highPriority = nnz(T.Priority == "High");
lowPriority  = nnz(T.Priority == "Low");
noPriority   = nnz(T.Priority == "None");
determined   = nnz(T.Determined);
```

---

## Field reference

| Field | Meaning |
|-------|---------|
| **Priority** | `"High"` = must satisfy, `"Low"` = try, `"None"` = solver decides. |
| **TargetValue** | Requested initial value (`TargetUnit` gives the unit). |
| **PrestartValue** | Value before the IC solve (`PrestartUnit`). `NaN` when the model has no pre-solve value for a variable — for example when initializing from steady state (the Solver Configuration "Start simulation from steady state" option), where the steady solve *is* the start and there is no prestart phase. |
| **StartValue** | Actual solved value after the IC solve (`StartUnit`). |
| **Satisfied** | `StartValue ≈ TargetValue` within tolerance. |
| **Eliminated** | Algebraically removed; derived from other variables. |
| **Determined** | Value depends on block inputs at `t=0`. |
| **Differential** | Continuous state integrated by the ODE solver. |
| **Representation** | `"time"`, `"frequency"`, or `"partfreq"`. |
| **NominalSource** | Origin of the nominal value: `"None"`, `"Model"`, `"Block"`, `"Derived"`, or `"Fixed"`. |

---

## Release compatibility

The per-variable record has grown over releases, so `variable_viewer_run`
returns only the fields a given release can populate (dropping absent ones
rather than blanking them); below R2024b it raises
`simscape_debug:UnsupportedRelease`. Availability by release:

| Field | Available from |
|--------|----------------|
| `Path`, `Eliminated`, `Priority`, `TargetValue` / `TargetUnit`, `StartValue` / `StartUnit`, `Satisfied`, `Determined`, `Differential`, `Representation`, `NominalSource`, `NominalValue` / `NominalUnit` | R2024b |
| `PrestartValue` / `PrestartUnit` | R2026a |

`BlockPath` and `Variable` are not present on every release, so guard them with
`isfield(results.data, "...")` before use. `Path` is present on every release
and identifies the variable on its own (e.g. `"C1.i"`).

---

## Typical workflow — "which ICs weren't met?"

```matlab
results = simscape.agentic.variable_viewer_run('myModel');
T = struct2table(results.data);
conflicts = T(T.Priority == "High" & ~T.Satisfied,:);                 % high-priority targets not met
if ~isempty(conflicts)
    disp(conflicts(:, ["Path","TargetValue","StartValue"]))           % which variables, how far off
end
```

----

Copyright 2026 The MathWorks, Inc.

----
