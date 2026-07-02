---
name: simulink-single-precision-conversion
description: Converts a double-precision Simulink system or subsystem to single precision using DataTypeWorkflow.Single (Fixed-Point Designer). The single conversion replaces all user-specified double-precision data types, as well as output data types that compile to double precision, with single-precision data types. Use this skill when converting Simulink systems to single precision, reducing memory usage of a Simulink system, optimizing for embedded targets. Do NOT use for standalone MATLAB .m code single conversion. 
license: MathWorks BSD-3-Clause
metadata: 
  author: MathWorks
  version: "1.7"
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
2. **Never** call `save_system` — saving destroys the double-precision baseline and blocks meaningful re-runs. Leave the model dirty; persist only if the user explicitly asks.
3. The compatibility check runs *inside* `convertToSingle`; read its results from `report.CheckInfo` (it is not a separate call).
4. Get the user's explicit consent before converting. If the model path, subsystem, or scope is ambiguous, ask.
5. Always inspect `report.VerifyInfo.StowawayDblBlks` afterward — remaining stowaway doubles mean the conversion is incomplete.
6. Assign the report to a local variable (`report = ...;`) — don't pollute the base workspace or echo the raw struct.

---

## Report Structure

The tool runs **check → convert → verify**, populating three sub-structs on the report.

### report.CheckInfo

| Field | Description |
|-------|-------------|
| `ready` | Logical — `true` if the system can be converted |
| `err` | Error info (empty on success) |
| `IncompatibleBlks` | Blocks not supporting single precision |
| `UnsupportedBlks` | Blocks unsupported by the conversion tool (with `ErrorMsgs`) |
| `DTLockedDblBlks` | Blocks with locked double data types (do not block conversion) |
| `StowawayDblBlks` | Blocks generating double operations found during the check |
| `TLSSettings` | Models whose Target Language Standard was updated to C99 |
| `DTOSettings` | Systems whose Data Type Override was reset |
| `SolverSettings` | Models whose variable-step solver was changed to fixed-step |
| `configSettings` | Config params updated (e.g. `GenerateComments`, `ParameterPrecisionLossMsg`) |
| `memoryUse.BeforeValue` | Per-parameter memory **table**; column `RuntimeMemory` (bytes) before conversion |

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
