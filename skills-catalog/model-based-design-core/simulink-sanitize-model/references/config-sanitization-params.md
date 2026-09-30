# Config Set Parameters — Sanitization Reference

A Simulink configuration set has ~580 parameters. Only the parameters listed here can contain customer-proprietary content. Query **only these** via `model_query_params` on the config target — never query `"all"`.

HDL Coder configuration is a separate component (`hdlcoderui.hdlcc`) accessed via `hdlget_param`, not part of the main config set. It is out of scope for this reference.

---

## Category 1: Custom Code

Inline C/C++ code, compiler/linker directives, or function handles authored by the customer. **Clear all.**

| Parameter | Description |
|---|---|
| `CustomHeaderCode` | C header code injected into generated code |
| `CustomSourceCode` | C source code injected into generated code |
| `CustomInitializer` | Code run at model init |
| `CustomTerminator` | Code run at model terminate |
| `CustomInclude` | Additional include directories |
| `CustomSource` | Additional source files |
| `CustomLibrary` | Additional libraries to link |
| `CustomDefine` | Preprocessor defines |
| `PostCodeGenCommand` | MATLAB command run after code generation |
| `CustomCommentsFcn` | Custom comment function handle |
| `CustomToolchainOptions` | Toolchain-specific build options |
| `TLCOptions` | Target Language Compiler options |
| `CustomBLASCallback` | Custom BLAS library callback |
| `CustomFFTCallback` | Custom FFT library callback |
| `CustomLAPACKCallback` | Custom LAPACK library callback |
| `CustomCodeDeterministicFunctions` | Functions marked deterministic for optimization |
| `CustomCodeFunctionArrayLayout` | Array layout overrides for custom code functions |
| `RTWCustomCompilerOptimizations` | Custom compiler optimization flags |
| `SimCustomHeaderCode` | Simulation-mode custom header |
| `SimCustomSourceCode` | Simulation-mode custom source |
| `SimCustomInitializer` | Simulation-mode custom init |
| `SimCustomTerminator` | Simulation-mode custom terminate |
| `SimCustomCompilerFlags` | Simulation compiler flags |
| `SimCustomLinkerFlags` | Simulation linker flags |
| `SimUserDefines` | Simulation preprocessor defines |
| `SimUserIncludeDirs` | Simulation include directories |
| `SimUserLibraries` | Simulation libraries |
| `SimUserSources` | Simulation source files |
| `GPUCompilerFlags` | GPU compiler flags |
| `SimGPUCompilerFlags` | Simulation-mode GPU compiler flags |

## Category 2: File Paths

Paths that may reveal internal directory structure or project layout. **Clear all.**

| Parameter | Description |
|---|---|
| `ExistingSharedCode` | Path to pre-existing shared utility code |
| `TargetPreCompLibLocation` | Precompiled library path |
| `TargetLibSuffix` | Suffix appended to generated library names |
| `ModelDependencies` | List of file dependencies |
| `EmbeddedCoderDictionary` | Path to Embedded Coder dictionary |
| `CovFilter` | Coverage filter file path |
| `PackageName` | Code generation package name |
| `ExtModeMexFile` | External mode MEX file |
| `ExtModeMexArgs` | External mode MEX arguments |
| `GPUKernelNamePrefix` | GPU kernel naming prefix |
| `GPUCustomComputeCapability` | Custom GPU compute capability string |
| `SimGPUCustomComputeCapability` | Simulation-mode GPU compute capability |
| `ObjectivePriorities` | Custom optimization objective names |

## Category 3: Hardware Target

Reveals the customer's deployment hardware. **Reset to generic.**

| Parameter | Action |
|---|---|
| `ProdHWDeviceType` | → `'Generic->32-bit Embedded Processor'` |
| `TargetHWDeviceType` | → `'Generic->32-bit Embedded Processor'` |
| `HardwareBoard` | → `'None'` |

## Category 4: Free Text

Freeform text fields that can contain proprietary descriptions. **Clear all.**

| Parameter | Description |
|---|---|
| `Description` | Config set description |
| `CustomUserTokenString` | Custom token string for code gen comments |

## Category 5: Custom Naming Patterns

Code generation symbol naming templates. Usually defaults but can be customized to match a customer coding standard. **Reset to defaults only if the value differs from the default.**

| Parameter | Default |
|---|---|
| `CustomSymbolStrBlkIO` | `rtb_$N$M` |
| `CustomSymbolStrEmxFcn` | `emx$M$N` |
| `CustomSymbolStrEmxType` | `emxArray_$M$N` |
| `CustomSymbolStrFcn` | `$R$N$M$F` |
| `CustomSymbolStrFcnArg` | `rt$I$N$M` |
| `CustomSymbolStrField` | `$N$M` |
| `CustomSymbolStrGlobalVar` | `$R$N$M` |
| `CustomSymbolStrMacro` | `$R$N$M` |
| `CustomSymbolStrTmpVar` | `$N$M` |
| `CustomSymbolStrType` | `$N$R$M_T` |
| `CustomSymbolStrUtil` | `$N$C` |
| `DefineNamingFcn` | `[]` (empty) |
| `ParamNamingFcn` | `[]` (empty) |
| `SignalNamingFcn` | `[]` (empty) |
| `ERTDataFileRootName` | `$R_data` |
| `ERTHeaderFileRootName` | `$R$E` |
| `ERTSourceFileRootName` | `$R$E` |
| `HeaderGuardPrefix` | `[]` (empty) |
| `ReservedNameArray` | `[]` (empty) |
| `SimReservedNameArray` | `[]` (empty) |

## Category 6: Preserve-if-Standard Parameters

These parameters have valid MathWorks-provided values. A non-default value is NOT necessarily proprietary. **Leave unchanged if the value is a recognized MathWorks option; reset to default only if the value appears customer-specific.**

`SystemTargetFile`, `TemplateMakefile`, `Toolchain`, `MakeCommand`, `CodeReplacementLibrary`, `DataTypeReplacement`, `Name`, `SignalLoggingName`, `DSMLoggingName`, `LoggingFileName`, `LogVarNameModifier`, `OutputSaveName`, `ReturnWorkspaceOutputsName`, `TimeSaveName`, `CovDataFileName`, `CovOutputDir`, `CovSaveName`, `CovCumulativeVarName`, `CodeExecutionProfileVariable`, `CodeStackProfileVariable`

---

The remaining ~500 config parameters (solver settings, diagnostic levels, boolean flags, numeric thresholds) are standard Simulink settings that contain no customer content. They are copied as-is into `sanitized_config` — no enumeration or sanitization needed.

----

Copyright 2026 The MathWorks, Inc.

----
