# Stiffness Analyzer (stiffness_analyzer_run)

Reports the **stiff modes** of a Simscape network at the failure time: the
fast-mode eigenvalue, the state behind it, and the block and source line that
define that state. Use it when a simulation fails with "min step size" or
"step size control" errors and the cause is not an obvious parasitic.

`stiffness_analyzer_run` seeds stiffness detection with the failure time
`tFail` and simulates the model. Seeding is essential for hanging simulations,
where the solver never accepts a step at the failure region and unseeded
detection would only sample earlier, healthy times.

> **State is restored on return.** Stiffness detection is turned off and the
> seeded times are cleared when the function returns, even if the simulation
> errors.

> **The simulation is expected to fail.** A failure at `tFail` is caught so the
> stiffness rows can still be read. The error message is returned in
> `simError` rather than thrown.

---

## stiffness_analyzer_run

Simulate the model with stiffness detection seeded at `tFail` and return the
per-time stiffness rows.

```matlab
[data, simError] = simscape.agentic.stiffness_analyzer_run(modelName, tFail);
```

### Inputs

| Argument | Type | Description |
|----------|------|-------------|
| `modelName` | string | Model name. Loaded automatically if not already open. |
| `tFail` | double | Failure time, taken from the warning or error message. |

### Outputs

| Output | Type | Description |
|--------|------|-------------|
| `data` | struct array | One row per fast mode at `tFail` (fields below). A network with differential states always returns rows, even where it isn't stiff, so interpret them only when the solver reports a warning or error at `tFail`. Empty if stiffness could not be computed (e.g., no differential equations); a warning says why. A row with `stiffness` 0 is not a stiff mode; ignore it. |
| `simError` | string | Simulation error message, or `""` if the simulation completed. |

### `data` fields

| Field | Meaning |
|-------|---------|
| `time` | Time the row was sampled at (the seeded `tFail`). |
| `stiffness` | Fast-mode eigenvalue `λ`. Large negative values indicate a stiff, stable mode. |
| `variable` | Description of the stiff state, e.g. `'Time derivative of LED_12.diode.Cjunction.vc (Capacitor voltage)'`. |
| `coefficient` | Coefficient reported for `variable` in the stiff mode. |
| `block` | Full path of the block that owns the state. This points at the source of the fast mode. |
| `location`, `line` | Simscape source file and line that define the state. |

Other fields may be present. They are not needed for the diagnosis.

---

## Typical workflow — "min step size violation near t = tFail"

```matlab
tFail = 50;                                    % from the warning message
[data, simError] = simscape.agentic.stiffness_analyzer_run('myModel', tFail);
[~, i] = min([data.stiffness]);                % stiffest mode
stiffest = data(i);
tau = 1 / abs(stiffest.stiffness);             % decay time constant
```

If `simError` is not empty, report it to the user, then continue with `data`.
See Stiffness path, Step 5 in SKILL.md to turn the rows into a fix.

---

## Release compatibility

Verified on **R2023b** and later. On a release that lacks the backing
stiffness APIs, `stiffness_analyzer_run` errors with
`simscape_debug:UnsupportedRelease`.

| Release | Supported |
|---------|-----------|
| R2023b and later | Yes |
| R2023a | Not verified |

----

Copyright 2026 The MathWorks, Inc.

----
