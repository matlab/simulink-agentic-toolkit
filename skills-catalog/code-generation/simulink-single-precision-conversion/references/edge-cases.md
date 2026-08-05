# Edge Cases and Error Handling

## Model Not Loaded or Invalid System Path

If the system path is invalid or the model is not loaded, the engine returns an error in `report.SetupInfo.err` with identifier `'Simulink:Commands:InvSimulinkObjectName'`. Always ensure:
- The model is loaded (`bdIsLoaded(modelName)` returns `true`) before calling `convertToSingle`
- The block path string exactly matches the full Simulink path (e.g., `'myModel/Controller'`)
- If the SUD is deleted or renamed between setup and execution, the engine errors gracefully at setup

## Update Diagram Failures

If the model cannot compile (update diagram fails), the check phase returns `report.CheckInfo.err` as an `MException` with identifier `'DataTypeWorkflow:Single:UpdateDiagramFailed'`. Common causes:
- Missing bus object definitions or workspace variables
- Unresolved signal dimensions or data types
- Broken block connections

When this occurs, `report.CheckInfo.ready` is `false` and the workflow halts — no conversion or verification is attempted.

## Incompatible Blocks (ready = false)

The following block types are detected as **incompatible** (cannot operate in single precision):
- Continuous blocks: `Derivative`, `Transfer Fcn`, `Sine Wave Function`
- `MATLAB System` blocks (when block capabilities are empty)
- Blocks inside subsystems, masked subsystems, linked libraries, model references, and Simulink functions within Stateflow charts

When incompatible blocks are found, `report.CheckInfo.ready` is set to `false` and conversion does not proceed. Workaround: convert a subsystem that excludes the incompatible blocks, or replace incompatible blocks with single-compatible alternatives.

## Unsupported MATLAB Function Blocks (ready = false)

MATLAB Function Blocks are flagged as **unsupported** and block conversion when they contain:
- **Global variables** — error: `Coder:FXPCONV:F2FGLOBALINMLFB_DTS`
- **User-defined MCOS classes** — error: `Coder:FXPCONV:MLFB_UnSupportedMCOS_DTS`
- **Simulink function calls** — error: `Coder:FXPCONV:MLFB_SimulinkFunctionNotSupported_DTS`
- **Persistent variables shared across multiple MATLAB Function Blocks** — error: `Coder:FXPCONV:MEPSharedMemory_MLFB_DTS`
- **System objects called from MATLAB Function Blocks** — reports the system object class name in the error

These are reported in `report.CheckInfo.UnsupportedBlks` with associated `ErrorMsgs`.

## Data-Type-Locked Double Blocks (ready = true)

Blocks with `LockScale` set to `'on'` and an explicit `double` output data type are reported in `report.CheckInfo.DTLockedDblBlks` but **do not** prevent conversion (`ready` remains `true`). These blocks retain their double type after conversion — they must be manually changed if single precision is required. Blocks with `LockScale` on but an inherited data type are **not** reported as locked.

## Stowaway Double Blocks (ready = true)

Blocks generating double-precision operations are reported in `report.CheckInfo.StowawayDblBlks`. These **do not** prevent conversion but indicate signals that remain double after the convert step. After verification, any remaining stowaway doubles indicate incomplete conversion — investigate locked data types, Stateflow chart data, or blocks outside the SUD boundary.

**Fix stowaway doubles at the source, not with hand-inserted casts.** The correct remedy is to change the offending block itself — unlock and retype `DTLockedDblBlks` to single, set Stateflow chart data to single, or widen the SUD scope so the source block is included — then **re-run `convertToSingle`** so the type propagates natively. Do **not** advise inserting `single(...)` casts or Data Type Conversion (DTC) blocks on the boundary signals to paper over the mismatch: that hides the double instead of eliminating it, breaks native single-type propagation, and leaves the underlying block still generating double operations. Manual DTC blocks are a last resort only for a genuine mixed-precision interface the user intends to keep — never as the fix for an incomplete single conversion.

If the stowaway double check itself fails (e.g., due to model compilation errors), `report.CheckInfo.err` is non-empty and `ready` is `false`.

## Target Language Standard (TLS) Auto-Update

The tool automatically updates TLS from `C89/C90 (ANSI)` to `C99 (ISO)` for the top model and all referenced models. Models using a **reference configuration set** are skipped (TLS is not modified, no error is raised). Updated models are listed in `report.CheckInfo.TLSSettings`.

## Data Type Override (DTO) Cleanup

Active DTO settings (`Off`, `Double`, `ScaledDouble`, `Single`) on models, subsystems, MATLAB Function Blocks, and Stateflow chart subsystems are automatically reset to `'UseLocalSettings'` before conversion. Updated systems are listed in `report.CheckInfo.DTOSettings`. This applies recursively into nested Stateflow charts and model references.

## Solver Settings Auto-Update

Variable-step solvers are automatically changed to fixed-step for the top model and referenced models. Models using a **reference configuration set** are skipped. After solver change, the tool sets `SolverMode` to `'MultiTasking'` and `AutoInsertRateTranBlk` to `'on'`. Updated models are listed in `report.CheckInfo.SolverSettings`.

## Configuration Settings Auto-Update

The tool also updates:
- `GenerateComments` → `'on'` (required for conversion annotations)
- `ParameterPrecisionLossMsg` → `'none'` (suppresses precision loss warnings during conversion)

Models with **disabled parameters** (e.g., read-only configuration) are skipped without error.

## Model References

- Incompatible/unsupported blocks in referenced models are detected and reported with their full path in the referenced model
- If the SUD is a subsystem that does not include referenced models containing incompatible blocks, conversion of the SUD still proceeds — the incompatible blocks are reported but don't block conversion of the selected scope
- Models in the reference hierarchy set to Accelerator-only mode are excluded from conversion scope

## Duplicate Results and Idempotency

The converter deduplicates results — each block appears only once in `report.ConvertInfo.results` even if it is encountered multiple times during traversal. Converting an already-single model produces an empty results set with no error.

## Conversion with Stowaway Introduction

Conversion itself can introduce data type mismatches (e.g., when a subsystem boundary now has single on one side and double on the other). These are **not** detected in the convert phase (`report.ConvertInfo.err` remains empty) but are caught in the verify phase as stowaway doubles.

## Cleanup on Model Close

When the model is closed, conversion results stored in the Fixed-Point Tool repository are automatically cleaned up. The internal run name `'D2S_Run_Collector_Internal_Run_Name'` is purged from `fxptds.FPTRepository`.

----

Copyright 2026 The MathWorks, Inc.

----
