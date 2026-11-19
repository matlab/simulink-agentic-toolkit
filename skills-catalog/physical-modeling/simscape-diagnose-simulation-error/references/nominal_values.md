# Nominal Values (nominal_values_*)

Inspect and modify a model's **nominal values** and toggle the normalization
(scaling) system. Nominal values give the solver a characteristic magnitude per
unit so that states of vastly different scale are conditioned comparably. This
package is the programmatic equivalent of editing the nominal-values table in
the model's configuration — a table-based API that avoids hand-building the
serialized `SimscapeNominalValues` string via `set_param`.

**Scope: model-level nominal values only.** These are the by-unit nominal values
stored on the model configuration (the `SimscapeNominalValues` model parameter),
not the per-block nominal values set on individual Simscape blocks. Block-level
nominal values are a separate mechanism and are not addressed by this package.

Typical pairing: use `variable_scaling_analyzer` to find poorly-scaled states, then
`nominal_values` to set nominals for the affected units and enable normalization.

> **In-memory only.** `nominal_values_set_nominal_values` and `nominal_values_set_nominal_enabled` change the
> loaded model in memory. Call `save_system` to persist. The model must be
> loaded and writable.

All functions live in the `simscape.agentic` namespace — call them as
`simscape.agentic.nominal_values_get_nominal_values(...)`, etc.

---

## nominal_values_get_nominal_values

Read the model's current nominal-value table.

```matlab
T = simscape.agentic.nominal_values_get_nominal_values(modelName);
```

### Inputs

| Argument | Type | Description |
|----------|------|-------------|
| `modelName` | string | Model name. Loaded automatically if not already open. |

### Output

Table with columns:

| Column | Meaning |
|--------|---------|
| `Value` | Nominal value expression as a string, e.g. `"1"`, `"0.001"`, `"1e-6"`. |
| `Unit` | Physical unit, e.g. `"m"`, `"A"`, `"V"`, `"K"`. |

Returns an empty (0-row) table if the model has no nominal values configured.

---

## nominal_values_is_nominal_enabled

Check whether normalization is currently on.

```matlab
tf = simscape.agentic.nominal_values_is_nominal_enabled(modelName);
```

**Output:** logical — `true` if `SimscapeNormalizeSystem` is `'on'`. Setting
nominal values has no effect on the solve until normalization is enabled.

---

## nominal_values_set_nominal_values

Replace the model's nominal-value table.

```matlab
simscape.agentic.nominal_values_set_nominal_values(modelName, T)
```

### Inputs

| Argument | Type | Description |
|----------|------|-------------|
| `modelName` | string | Model name. |
| `T` | table | Must have `Value` and `Unit` columns (string/char). An **empty table clears all** nominal values. |

Errors if `T` is missing the `Value` or `Unit` column. The table is serialized
to the `SimscapeNominalValues` model parameter for you.

```matlab
T = table(["1"; "0.001"; "1e-6"], ["m"; "A"; "V"], ...
    'VariableNames', {'Value', 'Unit'});
simscape.agentic.nominal_values_set_nominal_values('myModel', T);
```

Add to the existing set rather than replacing:

```matlab
T = simscape.agentic.nominal_values_get_nominal_values('myModel');
T = [T; table("300", "K", 'VariableNames', {'Value', 'Unit'})];
simscape.agentic.nominal_values_set_nominal_values('myModel', T);
```

Clear all nominal values:

```matlab
simscape.agentic.nominal_values_set_nominal_values('myModel', table.empty);
```

---

## nominal_values_set_nominal_enabled

Enable or disable the normalization system.

```matlab
simscape.agentic.nominal_values_set_nominal_enabled(modelName, true)    % enable
simscape.agentic.nominal_values_set_nominal_enabled(modelName, false)   % disable
```

### Inputs

| Argument | Type | Description |
|----------|------|-------------|
| `modelName` | string | Model name. |
| `enabled` | logical | `true` sets `SimscapeNormalizeSystem='on'`, `false` sets `'off'`. |

---

## Typical workflow — apply nominals for a build script

```matlab
T = table(["1"; "0.01"; "300"], ["V"; "A"; "K"], ...
    'VariableNames', {'Value', 'Unit'});
simscape.agentic.nominal_values_set_nominal_values('myModel', T);
simscape.agentic.nominal_values_set_nominal_enabled('myModel', true);
save_system('myModel');            % persist the in-memory change
```

---

## Release compatibility

Supported from **R2023a** onward.

| Release | Supported |
|---------|-----------|
| R2023a and later | Yes |

----

Copyright 2026 The MathWorks, Inc.

----
