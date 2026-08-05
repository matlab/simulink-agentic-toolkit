---
name: simulink-single-precision-conversion
description: Converts a double-precision Simulink system or subsystem to single precision using DataTypeWorkflow.Single (Fixed-Point Designer). The single conversion replaces all user-specified double-precision data types, as well as output data types that compile to double precision, with single-precision data types. Use this skill when converting Simulink systems to single precision, reducing memory usage of a Simulink system, optimizing for embedded targets. Do NOT use for standalone MATLAB .m code single conversion. 
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata: 
  author: MathWorks
  version: "1.8"
---

# Single-Precision Conversion for Simulink Models (Fixed-Point Designer)

Toolbox: **Fixed-Point Designer**
Function: `DataTypeWorkflow.Single.convertToSingle`

Converts user-specified double-precision data types — across block settings, Stateflow chart
settings, signal objects, and bus objects — to single precision. **Boolean, built-in integer
(int8, uint8, int16, …), and fixed-point types are left unchanged.**

## When to Use

- Converting a Simulink model (`.slx`) or subsystem from double-precision to single-precision
- Reducing memory footprint for embedded hardware with native single-precision support
- Batch/CI conversions, checking conversion compatibility, or verifying no stowaway doubles remain
- Summarizing the single conversion compatibility report and conversion result for the user in plain language

## When NOT to Use

- **Standalone MATLAB `.m` code** — use the `convertToSingle` function with `coder.config('single')` instead
- **Fixed-point data type optimization** — use `DataTypeWorkflow.Converter` instead
- **Approximating a function or shrinking Lookup Table blocks with LUTs** — use `simulink-optimize-lookup-tables` instead

---

## Public API

```matlab
ConversionReport = DataTypeWorkflow.Single.convertToSingle(systemToConvert)
```

- `systemToConvert` (char) — full block path of the **loaded** model or subsystem (e.g. `'myModel'` or `'myModel/Controller'`).
- `ConversionReport` (struct) — compatibility check, converted items, and verification status (see field tables below).

Worked example: `openExample("fixedpoint/ConvertSystemToSinglePrecisionExample")`

### Rules

1. Open with `open_system(modelName)`, **not** `load_system` — the user must see the diagram before/after.
2. **Never** call `save_system` on your own — saving destroys the double-precision baseline and blocks meaningful re-runs. Leave the model dirty. This holds **even when the user asks you to "make it stick," "persist it," or "do everything end-to-end"** — that is not consent to auto-save. In that case, state plainly that you will *not* save the model yourself, explain that saving overwrites the double-precision baseline, and ask the user to confirm or run `save_system` themselves. Only persist after the user explicitly confirms saving specifically (not merely a general "do it all" request).
3. The compatibility check runs *inside* `convertToSingle`; read its results from `report.CheckInfo` (it is not a separate call).
4. Get the user's explicit consent before converting. If the model path, subsystem, or scope is ambiguous, **ask — do not guess**. When the user says "my model" without naming one, ask which model; never adopt a `.slx` you happen to find in the working directory (an example or fixture file is **not** the user's intended model). Only run the conversion once the user has named the model.
5. Always inspect `report.VerifyInfo.StowawayDblBlks` afterward — remaining stowaway doubles mean the conversion is incomplete. Fix them **at the source** (retype locked-double blocks, set Stateflow data to single, or widen the SUD scope) and re-run `convertToSingle`. Do **not** recommend hand-inserting `single(...)` casts or Data Type Conversion blocks on the offending signals — that hides the double instead of eliminating it.
6. Assign the report to a local variable (`report = ...;`) — don't pollute the base workspace or echo the raw struct.

---

## Report Structure

The tool runs **check → convert → verify**, populating three sub-structs on the report.

### report.CheckInfo

| Field | Description |
|-------|-------------|
| `ready` | Logical — `true` if the system can be converted - only read `ConvertInfo`/`VerifyInfo` when this is `true`.|
| `err` | Error info (empty on success) |
| `IncompatibleBlks` | Cell array of `DataTypeWorkflow.Single.Result` — blocks not supporting single precision (see block-name note below) |
| `UnsupportedBlks` | Cell array of `DataTypeWorkflow.Single.Result` — blocks unsupported by the conversion tool (with `ErrorMsgs`) |
| `DTLockedDblBlks` | Blocks with locked double data types (do not block conversion) |
| `StowawayDblBlks` | Blocks generating double operations found during the check |
| `TLSSettings` | Models whose Target Language Standard was updated to C99 |
| `DTOSettings` | Systems whose Data Type Override was reset |
| `SolverSettings` | Models whose variable-step solver was changed to fixed-step |
| `configSettings` | Config params updated (e.g. `GenerateComments`, `ParameterPrecisionLossMsg`) |
| `memoryUse.BeforeValue` | Per-parameter memory **table**; column `RuntimeMemory` (bytes) before conversion |

**How to extract block names from the diagnostic list.** `IncompatibleBlks`, `UnsupportedBlks`, `StowawayDblBlks`, and `DTLockedDblBlks` are **cell arrays of `DataTypeWorkflow.Single.Result` objects — not block-path strings.** Get the readable block path from each element's `ID` via `getDisplayName()`. Do **not** call `get_param`, `getfullname`, or `string()` on the elements: that errors with *"The first input to get_param must be of type 'double', 'char' or 'cell'."*:

```matlab
for k = 1:numel(report.CheckInfo.IncompatibleBlks)
    r = report.CheckInfo.IncompatibleBlks{k};
    fprintf('  %s\n', r.ID.getDisplayName());   % e.g. 'myModel/Integrator'
    if ~isempty(r.ErrorMsgs)
        fprintf('    %s\n', strjoin(string(r.ErrorMsgs), '; '));
    end
end
```

### report.ConvertInfo

Records what the converter actually did.

| Field | Description |
|-------|-------------|
| `ready` | Logical — `true` if the convert step ran cleanly |
| `err` | Error info; empty (`[]`) on success |
| `results` | Cell array of `fxptds.BlockResult` — the blocks/signals changed from `double` to `single` |

### report.VerifyInfo

| Field | Description |
|-------|-------------|
| `StowawayDblBlks` | Blocks still generating double operations after conversion |
| `memoryUse.AfterValue` | Per-parameter memory **table**; column `RuntimeMemory` (bytes) after conversion |

The check phase validates the Target Language Standard, Data Type Override, incompatible
blocks, stowaway doubles, data-type-locked doubles, and solver settings — and auto-updates
several of them. **The tool handles TLS→C99, DTO cleanup, and solver changes automatically;
you do not need to set these manually.** See [references/edge-cases.md](references/edge-cases.md)
for the full auto-update behavior, error identifiers, and edge cases:

- Model not loaded / invalid path (`Simulink:Commands:InvSimulinkObjectName`); update-diagram failures (`DataTypeWorkflow:Single:UpdateDiagramFailed`)
- Incompatible blocks (continuous blocks, MATLAB System blocks) and unsupported MATLAB Function Blocks (globals, MCOS classes, Simulink function calls)
- Auto-updates (TLS, DTO, solver, config), model-reference scope handling, idempotency, and cleanup on model close

---

## Generating the Conversion Report

After `convertToSingle` returns, summarize the result for the user in plain language — do not
dump the raw struct. Put the exact API call used at the top for traceability.

For the required output sections, empty-report fallback, reporting conventions, and the
Embedded Coder readiness-check follow-up, see [references/reporting-format.md](references/reporting-format.md).

---

## Prerequisites & Limitations

- Requires **MATLAB**, **Simulink**, and **Fixed-Point Designer**; the model must be loaded.
- The conversion engine is a **singleton** — only one conversion session can be active at a time.
- MATLAB Function Blocks with complex logic and model references may need individual review — see [references/edge-cases.md](references/edge-cases.md).

----

Copyright 2026 The MathWorks, Inc.

----
