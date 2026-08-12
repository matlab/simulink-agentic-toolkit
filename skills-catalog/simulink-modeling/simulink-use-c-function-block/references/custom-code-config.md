# Custom Code Configuration Reference

Detailed parameter tables and patterns for configuring custom code settings on C Function blocks. Load this when you need specifics on custom code location, parameter names, or codegen settings.

## Custom Code Location

The `CustomCodeSettingLocation` parameter determines where the block looks for custom code dependencies:

| Value | Meaning |
|-------|---------|
| `'ModelConfigurationParameters'` | Block uses model-level Simulation Target settings |
| `'BlockSettings'` | **(default)** Block carries its own custom code settings |
| `'UpdateBuildInfo'` | Block uses an `UpdateBuildInfo` callback for dynamic config |

### Model-Level Custom Code (when location = `'ModelConfigurationParameters'`)

Use model-level settings when custom code is shared across multiple blocks. The model can also be a Simulink library if the block instance is used in multiple models in a hierarchy or multiple instances are used in a model. Configure on the **model** (target = `config:ModelName`):

| Parameter | Purpose |
|-----------|---------|
| `SimCustomHeaderCode` | Include directives / declarations (e.g. `'#include "myHeader.h"'`) |
| `SimCustomSourceCode` | Inline source code definitions |
| `SimCustomHeaderFile` | Header file name (no `#include` prefix) |
| `SimUserSources` | Source file name(s) |
| `SimUserIncludeDirs` | Search paths for headers and source files |
| `SimTargetLang` | `'C'` or `'C++'` — language for simulation |
| `TargetLang` | `'C'` or `'C++'` — language for code generation (may differ from `SimTargetLang`) |
| `SimGenImportedTypeDefs` | `'on'`/`'off'` — generate typedefs for imported types |
| `DefaultCustomCodeDeterministicFunctions` | `'All'` — mark custom code as deterministic |

### Block-Level Custom Code (when location = `'BlockSettings'`)

Configure on the **block** — only effective when `CustomCodeSettingLocation` = `'BlockSettings'`:

| Parameter (Sim) | Parameter (Codegen) | Purpose |
|-----------------|---------------------|---------|
| `SimCustomHeaderFile` | `CustomHeaderFile` | Header file(s) |
| `SimCustomSourceFile` | `CustomSourceFile` | Source file(s) |
| `SimCustomLibraries` | `CustomLibraries` | Libraries to link |
| `SimCustomSearchDirectory` | `CustomSearchDirectory` | Search paths |
| `SimCustomDefines` | `CustomDefines` | Preprocessor defines |
| `SimCustomCompilerFlags` | `CustomCompilerFlags` | Compiler flags |
| `SimCustomLinkerFlags` | `CustomLinkerFlags` | Linker flags |

When `CodegenUsesSimCustomCode` = `'on'` (default), codegen uses the `Sim*` values.
When `'off'`, codegen uses the `Custom*` (non-Sim) parameters independently.

### Path Syntax for Custom Code Fields

- `./path` or `../path` — relative to model file location
- Enclose paths with spaces or hyphens in double quotes: `"./my folder/lib.c"`
- Use `$...$` to evaluate MATLAB workspace variables or functions in paths:
  - `./source/$CustomCodeFolder$` — expands workspace variable `CustomCodeFolder`
  - `$myPathFcn$/myFile.c` — calls `myPathFcn()` on MATLAB path to resolve the folder

### Global Variables (Complex C Types)

When global state is needed and the type is a complex C data structure not feasible or worth importing as a Simulink type, use model-level custom code to define and declare the global:

1. Set `CustomCodeSettingLocation` to `'ModelConfigurationParameters'`
2. **Define** the global in `SimCustomSourceCode`
3. **Declare** it with `extern` in `SimCustomHeaderCode`

Both definition (`SimCustomSourceCode`) and declaration (`SimCustomHeaderCode`) are required — omitting either causes linker or compilation errors.

## Code Section Parameters

| Parameter | Purpose | Restrictions |
|-----------|---------|--------------|
| `OutputCode` | Code executed each time step | Can access all symbol scopes |
| `StartCode` | Code executed at simulation start | Cannot access Input/Output symbols |
| `InitializeConditionsCode` | Code for IC; re-executes on enabled subsystem reset | Cannot access Input/Output |
| `TerminateCode` | Code executed at simulation end | Cannot access Input/Output |

## Codegen Parameters

**Codegen-specific code sections** (when `CodegenUsesSimCustomCode` = `'off'`):
- `CodegenOutputCode`, `CodegenStartCode`, `CodegenInitializeConditionsCode`, `CodegenTerminateCode`

**Codegen checkbox parameters:**
- `CodegenUsesSimCustomCode` — `'on'`(default) / `'off'` — whether codegen uses same code as sim
- `GenerateCodeAsIs` — `'on'`(default) / `'off'` — read-only when `CodegenUsesSimCustomCode`=`'on'`

**Parse Block Code:**
- `ParseBlockCode` — `'on'` / `'off'`(default R2026a+) — when `'off'`, no C/C++ restrictions: supports static locals, arbitrary library calls, full namespace/class usage, and function pointers. When `'on'`, parsing is enabled and restrictions apply (no static locals, only C Math Library functions, limited namespace support)

## Row/Column-Major for External Functions

Control array layout when calling external functions:

```c
slSetRowMajor("fully::qualified::functionName");
slSetColumnMajor("fully::qualified::functionName");
```

Use fully qualified names including namespaces and class names for C++ code.

## Diagnostic Functions (R2024a+)

Call these in any code section to report run-time errors and warnings in Simulink:

| Function | Effect |
|----------|--------|
| `slError("message")` | Terminate simulation with error |
| `slWarning("message")` | Emit warning without stopping simulation |

Supports C format specifiers (`%d`, `%f`, etc.):
```c
slError("Input %f should be non-negative", x);
slWarning("Input %d should be non-zero", y);
```

## Port Ordering Rules

1. **InputOutput** symbols always appear first in port numbering
2. **Input** symbols follow after all InputOutput ports
3. **Output** symbols have separate port numbering, InputOutput first then Output

## Importing External Types (Bus from Header)

If a struct/type is defined in a C header, use `Simulink.importExternalCTypes` to import it as a Simulink Bus object:

```matlab
Simulink.importExternalCTypes('myTypes.h');
```

The imported Bus can then be used as a symbol Type in the C Function block.

### Types Under C++ Namespaces

If imported types are defined under C++ namespaces:

- **Generate a type alias header** — use `SimulinkTypeAliasHeader` argument to create a header with type aliases matching the imported type signatures, then specify it in Simulation Custom Code headers:
  ```matlab
  Simulink.importExternalCTypes('myTypes.h', 'SimulinkTypeAliasHeader', 'myTypeAliases.h');
  ```
- **Import with fully qualified names** — use `UseFullyQualifiedName` when the same type name exists under different namespaces:
  ```matlab
  Simulink.importExternalCTypes('myTypes.h', 'UseFullyQualifiedName', true);
  ```
- **Import to data dictionary** — use `DataDictionarySection` to import into a Simulink data dictionary's Architectural Data section (namespaces are automatically synchronized):
  ```matlab
  Simulink.importExternalCTypes('myTypes.h', 'DataDictionarySection', dd.getSection('Design Data'));
  ```

## Device Driver Workflow

When integrating a device driver where the target specific code should pass through to generated code exactly as written:

1. **Custom code location:** `'BlockSettings'` with `GenerateCodeAsIs` = `'on'` — block carries its own custom code and passes it verbatim to generated code
2. **Use same code:** `CodegenUsesSimCustomCode` = `'off'` — simulation and codegen use different code sections (sim may use stubs, codegen uses target specific code)
3. **Codegen code section:** Put target specific code in `CodegenOutputCode` (and optionally `CodegenStartCode`, `CodegenTerminateCode`)
4. **Imported type headers not available for simulation:** If the user does not have the driver header available on the simulation host, set `SimGenImportedTypeDefs` = `'on'` on the block — this generates typedef stubs for simulation

## Common Model Setup

When creating a model for C/C++ integration, configure the solver and target language on the model config.

## Release Compatibility

### R2024a — Block-level custom code introduced

`CustomCodeSettingLocation` = `'BlockSettings'` was introduced in R2024a. On R2023a/R2023b, the only option is `'ModelConfigurationParameters'`.

Other R2024a additions:
- Separate Simulation and Code Generation code sections (different code for sim vs codegen)
- `slError` / `slWarning` for run-time diagnostics
- `slSetRowMajor` / `slSetColumnMajor` for array layout control
- `GenerateCodeAsIs` — pass custom code to generated code without parsing

### R2026a — Full C/C++ language support (default)

With default settings (`BlockSettings` + `ParseBlockCode` = `'off'`), there are **no C/C++ language limitations** — supports static locals, arbitrary library calls, namespaces, function pointers, and full class usage.

The old restrictions (only C Math Library functions, no static locals) apply ONLY when:
1. `CustomCodeSettingLocation` = `'ModelConfigurationParameters'`, OR
2. `BlockSettings` with `ParseBlockCode` = `'on'`

Other R2026a additions:
- Simulink string types supported for Input, Output, InputOutput, and Persistent scopes

### Row/Column-Major by Custom Code Location

| Location | Simulation | Code Generation |
|----------|-----------|-----------------|
| `'ModelConfigurationParameters'` | Respects `slSetRowMajor`/`slSetColumnMajor` | Respects `slSetRowMajor`/`slSetColumnMajor` |
| `'BlockSettings'` | Row-major | Column-major |

----

Copyright 2026 The MathWorks, Inc.

----
