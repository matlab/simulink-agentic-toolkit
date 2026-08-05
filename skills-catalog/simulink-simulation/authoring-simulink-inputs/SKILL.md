---
name: authoring-simulink-inputs
description: >
  Synthesize new waveforms from scratch for Simulink inports using
  createInputDataset. Use ONLY when the user asks to generate, create, or
  synthesize signals (step, ramp, sine, chirp, pulse, noise) to populate
  a Dataset for External Inputs or Signal Editor. Covers timeseries and
  timetable formats with correct data type, interpolation, units, and
  dimensions. Also covers function-call and trigger inport timing setup.
  Do NOT use when the user wants to load, import, or read existing data
  from files (MAT, CSV, spreadsheet) — even if that data will be used as
  model input. Do NOT use for running simulations or plotting outputs.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Author Input Signals

Create populated input signal datasets for Simulink models using `createInputDataset` as the scaffold, then populating with meaningful waveforms while preserving all signal metadata.

## When to Use

- User asks to **generate or create synthetic waveforms** (step, ramp, sine, chirp, pulse, noise, constant) for a model's inports
- User wants to **populate a Dataset** created by `createInputDataset` with meaningful signal data
- User needs signals for **Signal Editor** scenarios
- User describes desired **input signal behavior** in natural language (e.g., "ramp from 0 to 10", "sine at 5 Hz")
- User wants **timetable-based input signals** for inports
- User needs to set up **function-call timing** or configure trigger/enable inport signals
- User wants to replace **zero-filled scaffold** data with realistic waveforms

## When NOT to Use

- User wants to **simulate** the model, **run** it, or **plot outputs** — use `simulating-simulink-models` instead. This skill only creates input data; it never runs `sim()` or produces plots.
- User wants to **load, import, or read** data from existing files (CSV, MAT, spreadsheet, .mat workspace) — even if the destination is a model inport. This skill generates *new synthetic waveforms from scratch*; it does not read or convert existing recorded/measured data.

## Output

This skill produces:

1. **MATLAB code** — a local function that generates and returns the Dataset (reproducible, editable, keeps workspace clean)
2. **Dataset variable (`ds`)** — populated `Simulink.SimulationData.Dataset` in the base workspace, ready for simulation
3. **Summary** — brief description of each element: name, data type, waveform shape, and value range

To simulate with the Dataset, follow the `simulating-simulink-models` skill workflow (`SimulationInput` → `setExternalInput` → `sim`).

## Must-Follow Rules

1. **Start from `createInputDataset` — call it exactly once** — never build a Dataset from scratch. Call `createInputDataset` once per model (it triggers update diagram). For multiple datasets, clone the returned scaffold in a loop rather than calling `createInputDataset` again
2. **Preserve metadata from scaffold** — every new timeseries must copy `origEl.DataInfo.Interpolation` and `origEl.DataInfo.Units`. For timetables, copy `origEl.Properties.VariableContinuity`. Omitting these is a bug
3. **Replace elements in place** — for timeseries: `ds{k} = ts`. For timetable: `ds = ds.setElement(k, tt, origEl.Properties.Description)` — never use `addElement`
4. **Respect data types** — use `cast(data, 'like', origEl.Data)` to match any scaffold type (double, single, integer, fixed-point). For boolean inports use `true(size(t))` directly
5. **Set interpolation correctly** — continuous signals (sine, ramp, chirp) use linear; discrete signals (step, pulse, boolean, integer, noise) use zero-order hold. The scaffold's interpolation reflects the inport's `Interpolate` property — preserve it unless the signal nature demands otherwise
6. **Wrap all generation logic in a function** — the only variables left in the base workspace should be the Dataset (and `simIn`/`simOut` if simulating). All intermediate variables (`t`, `dt`, `origEl`, `ts`, `signalData`, `k`) must stay inside function scope
7. **Never destroy user data** — never call `clear`, `clearvars`, `clear all`, or `bdclose all`. The user may have existing variables, models, or figures open. Only add to the workspace, never remove from it

## Workflow

**Determine your entry point.** Do not always start at step 1. Assess what the user already has:

| User's current state | Start at |
|---------------------|----------|
| No existing Dataset or script — starting fresh | Step 1 |
| Has a Dataset variable but it's empty/scaffold (all zeros or placeholder data) | Step 2 |
| Has a Dataset with some signals populated but needs fixes (wrong shape, dtype, interpolation) | Step 2 — inspect the broken element, fix in place |
| Has a working script but wants additional scenarios or signals added | Step 2 or "Creating Multiple Datasets" |
| Has a complete Dataset but simulation fails | Diagnose the error first — often a metadata mismatch (interpolation, dtype, units) fixable in Step 2 |

A **scaffold** is the Dataset returned by `createInputDataset`. It contains one element per inport, pre-filled with correct metadata (data type, interpolation method, units, signal dimensions) but only placeholder time samples (typically 2 zero-valued rows). The workflow replaces this placeholder data with meaningful waveforms while preserving the metadata.

### 1. Create the scaffold (inside a function)

All generation code lives in a local function. The caller invokes the function and receives the populated Dataset:

```matlab
ds = buildInputs('modelName');

function ds = buildInputs(mdl)
    ds = createInputDataset(mdl);
    % — or timetable format —
    % ds = createInputDataset(mdl, 'DatasetSignalFormat', 'timetable');

    stopTime = str2double(get_param(mdl, 'StopTime'));
    dt = 0.01;
    t = (0:dt:stopTime)';

    % ... populate elements (Step 2) ...
end
```

If `createInputDataset` fails (model cannot compile), use `model_read` to inspect the model's inport blocks and ask the user for any type/dimension info that cannot be determined from the model structure.

### 2. Populate each element (inside the same function)

Replace placeholder scaffold data with meaningful signal waveforms while preserving metadata. For each element:

1. Extract the original element (`origEl = ds{k}`)
2. Generate your waveform and cast via `cast(data, 'like', origEl.Data)` — works for all types including fixed-point
3. Create the new timeseries or timetable
4. Copy `DataInfo.Interpolation` and `DataInfo.Units` from `origEl` (timeseries) or `VariableContinuity` from `origEl` (timetable)
5. Replace in place: `ds{k} = ts` (timeseries) or `ds = ds.setElement(k, tt, origEl.Properties.Description)` (timetable)

See [references/signal-patterns.md](references/signal-patterns.md) — "Dataset Assembly" sections — for the complete code patterns.


## Creating Multiple Datasets

Call `createInputDataset` once, then clone the scaffold in a loop inside a function. See [references/dataset-patterns.md](references/dataset-patterns.md) — "Creating Multiple Datasets" section — for the complete pattern.

## Bus Signal Inports

If the model has bus signal inports, see the "Bus Signal Inports" section in [references/dataset-patterns.md](references/dataset-patterns.md).

## Function-Call Inports

If the model has function-call inports, see the "Function-Call Inports" section in [references/dataset-patterns.md](references/dataset-patterns.md).

## Signal Types

See [references/signal-patterns.md](references/signal-patterns.md) for waveform generation code (sine, step, ramp, chirp, pulse, noise, constant, enum).

## Interpolation and Continuity (explicit set — use only when overriding scaffold)

| Signal nature | timeseries | timetable |
|--------------|-----------|-----------|
| Continuous (sine, ramp, chirp) | `tsdata.interpolation('linear')` | `"continuous"` |
| Discrete (step, pulse, boolean) | `tsdata.interpolation('zoh')` | `"step"` |

## Guardrails

| Mistake | Why It's Wrong | Correct Approach |
|---------|---------------|-----------------|
| Using `ones(size(t))` for boolean enable | Creates double; simulation fails with type mismatch | Use `true(size(t))` |
| Ignoring struct fields in bus scaffold | Missing or incorrectly typed bus element causes simulation error | Populate every field in the struct, preserving each field's metadata |
| Treating scaffold data rows as signal width | Scaffold `[2 1]` data means 2 time samples of a scalar, not a 2-element vector | Use `size(origEl.Data, 2)` for signal width — rows are placeholder time samples |
| Enum data fails with "turn off interpolation" | Simulink requires `Interpolate='off'` on inport blocks receiving enum data — even with zoh set on the timeseries | This is a model fix, not a data fix. Use `simIn.setBlockParameter(portPath, 'Interpolate', 'off')` before simulating |

----

Copyright 2026 The MathWorks, Inc.

----
