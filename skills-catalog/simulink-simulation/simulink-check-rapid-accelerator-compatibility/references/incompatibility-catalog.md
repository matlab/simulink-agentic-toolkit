# Incompatibility Catalog

All known raccel incompatibilities organized by category. Each entry includes the diagnostic error ID, severity (BLOCKER = build fails, WARNING = build continues but behavior affected), and the recommended fix.

## Category 1: Data Type Restrictions

| Error ID | Severity | Issue | Fix |
|----------|----------|-------|-----|
| `HalfRapidAccelNotSupported` | BLOCKER | Half-precision data type | Convert to single/double |
| `rapidAccelDoesNotSupportImages` | BLOCKER | Image data types | Convert to numeric arrays |
| `DynamicArrayNotSupportRapidAccel` | BLOCKER | Dynamic arrays (Inf dimension), including bus elements with `DimensionsMode='Variable'` and `Dimensions=[Inf]` | Use fixed-size signals; set finite upper bound on bus element dimensions |
| `FromwksInvalidRtpForRAccel` | BLOCKER | Non-numeric types in FromWorkspace | Change signal data type |
| `FromwksRAccelInterpolate64Bit` | BLOCKER | int64/uint64 linear interpolation | Use double or disable interpolation |
| `UnableRepresentModelDataInFi` | BLOCKER | Non-standard fixed-point word length (e.g., 81-bit) cannot be represented by `fi()` during RTP serialization | Use standard word length (8, 16, 32, or 64 bits) or floating-point |

## Category 2: S-Function Restrictions

| Error ID | Severity | Issue | Fix |
|----------|----------|-------|-----|
| `MSFBMFileExistsWithoutTLC` | BLOCKER | Level-2 MATLAB S-Function without TLC file | Read source, replace with equivalent built-in block |
| `NoRTPsInRowMajorSFcnsInRapidAccelerator` | BLOCKER | Row-major S-function with RTPs | Use column-major or inline params |
| `NoRapidAccelSimModeForRootFcnCall` | BLOCKER | Root-level function-call S-function | Restructure hierarchy |
| `rapidAccelSFcnMex` | BLOCKER | MEX API usage in S-function | Use TLC inlining |
| `rapidAccelBuildFailedCSFunctionSourceNotFound` | BLOCKER | C S-function source not found | Provide source file |
| `rapidAccelSFunctionNeedsToBeRegenerated` | BLOCKER | S-Function (Legacy Code Tool) with bus I/O has struct padding mismatch | Regenerate S-function with the Legacy Code Tool |
| `rapidAccelSFunctionBuilderNeedsToBeRegenerated` | BLOCKER | S-Function Builder block with bus I/O has struct padding mismatch | Regenerate S-function via S-Function Builder dialog |
| `RTPOnlyIfInlined` | BLOCKER | S-Function registers run-time parameters without being inlined | Add TLC file + set `SS_OPTION_USE_TLC_WITH_ACCELERATOR` in S-function |

## Category 3: Logging and Visualization

| Error ID | Severity | Issue | Fix |
|----------|----------|-------|-----|
| `DatasetRapidAccelNoSupported` | WARNING | State logging to Dataset format — build continues but state logging silently fails | Use 'Structure with time' |
| `SiglogStateflowRaccelIsNotSupported` | WARNING | Stateflow signal logging — build continues but SF logging silently disabled | Disable SF logging |
| `ToFileNameIsModelName` | BLOCKER | ToFile filename = model name — causes `rapidAccelBuildFailed` | Rename output file |

Note: Display/Scope blocks are fully functional in raccel as of R2026b. Do NOT flag them.

## Category 4: Message/SimEvents

| Error ID | Severity | Issue | Fix |
|----------|----------|-------|-----|
| `CannotRapidAccelMsgFromTop` | BLOCKER | Messages crossing model ref boundaries | Restructure message flow |
| `CannotRapidAccelExQueueRecv` | BLOCKER | Receiving messages from Inport | Use alternative I/O |

## Category 5: Parameter Tuning (UTD Check Off)

| Error ID | Severity | Issue | Fix |
|----------|----------|-------|-----|
| `rapidAccelCollapsedParameterComplexityMismatch` | BLOCKER | Param complexity changed between runs | Keep types consistent |
| `rapidAccelCollapsedParameterLengthMismatch` | BLOCKER | Param size changed between runs | Keep dimensions consistent |
| `CannotSetBlockParamRapidAccelUpToDateCheckOff` | BLOCKER | Block params can't be set with UTD off | Use RapidAcceleratorParameterSets |

## Category 6: Model Reference and Execution

| Error ID | Severity | Issue | Fix |
|----------|----------|-------|-----|
| `MultiInstanceForEachSubsystemMarkedAsParallel` | BLOCKER | Parallel multi-instance refs | Disable parallel or single instance |
| `OverriderWarnAccelOrRapidAccelNotSupported` | WARNING | Top model must be Normal for overrides | Change top model mode |

## Category 7: External Inputs

| Error ID | Severity | Issue | Fix |
|----------|----------|-------|-----|
| `rapidAccelUnableToLoadExtInputsBadFormat` | BLOCKER | Ext inputs must be double arrays/structs | Convert format |
| `rapidAccelDatasetExtInputInvalidNumberOfElements` | BLOCKER | Dataset elements != root inport count | Fix element count |

## Category 8: Build and Runtime

| Error ID | Severity | Issue | Fix |
|----------|----------|-------|-----|
| `rapidAccelBuildFailed` | BLOCKER | General build failure | Check compiler, source, errors |
| `rapidAccelExeNotFound` | BLOCKER | Executable missing | Rebuild target |
| `rapidAccelUnableToConnect` | BLOCKER | TCP/IP connection failure | Check ports/firewall |

## Category 9: Operating Point / Profiling / Debugging

| Error ID | Severity | Issue | Fix |
|----------|----------|-------|-----|
| `RapidAccelNotSupport` | BLOCKER | Save/load model ref operating points | Use normal mode for OP |
| `RapidAccelNotSupported` | WARNING | Simulink Profiler | Profile in normal mode |
| `CannotDebugInRapidAccelMode` | BLOCKER | Debugging unsupported | Debug in normal mode |

## Category 10: Variant Parameters

| Error ID | Severity | Issue | Fix |
|----------|----------|-------|-----|
| `VParamAccelAndRapidAccelModelWorkspace` | WARNING | Variant condition workspace writes | Set variants before build |

## Category 11: Runtime Parameter Upload

| Error ID | Severity | Issue | Fix |
|----------|----------|-------|-----|
| `RapidAcceleratorCantUploadDataPortBasedSampleTime` | BLOCKER | Port-based sample time | Use block-based sample time |
| `RapidAcceleratorCantUploadDataCSC` | BLOCKER | Custom storage class | Use standard storage |
| `RapidAcceleratorCantUploadDataVarDims` | BLOCKER | Variable-size signals | Use fixed-size |

## Category 12: File I/O

| Error ID | Severity | Issue | Fix |
|----------|----------|-------|-----|
| `SimInputCannotFindRTPFile` | BLOCKER | RTP file missing | Rebuild target |
| `RapidAcceleratorUnableToOpenModelParameterInfoFile` | BLOCKER | Parameter info file missing | Rebuild target |

## Category 13: Operating Point (SimState) Block Restrictions

These blocks/features prevent Operating Point save/restore in raccel (WARNING severity — build succeeds but OP save/restore fails):

- FromSpreadsheet blocks
- Model Reference with implicit rate transitions (multi-port)
- Variable-dimension ports
- Global Data Store Memory
- String datatypes in SimState
- Transport Delay inside ForEach subsystems
- Multi-instance export function model references
- Model references with local solvers
- S-Functions with custom SimState (DISALLOW_SIM_STATE)
- Blocks with PWORK pointers
- To File blocks

----

Copyright 2026 The MathWorks, Inc.

----
