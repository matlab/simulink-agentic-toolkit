---
name: simulink-use-c-function-block
description: |
  Use when integrating legacy code, custom code, or C/C++ code into Simulink via C Function blocks.
  Configure Simulink C Function blocks programmatically using the SymbolSpec API.
  TRIGGER when the user:
  - Asks about calling or wrapping C/C++ code or libraries in Simulink
  - Wants to create, configure, or use a C Function block
  - Mentions integrating custom code, legacy code, or external C/C++ into a model
  - Asks to integrate a C++ class into a Simulink model or test bench
  - Mentions inputs/outputs/parameters for a C++ algorithm block
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# C Function Block Configuration

## When to Use

- Calling or wrapping C/C++ code or libraries in Simulink
- Creating, configuring, or using a C Function block
- Integrating custom code, legacy code, or external C/C++ into a model
- Integrating a C++ class into a Simulink model or test bench
- Configuring inputs, outputs, or parameters for a C++ algorithm in a block

## When NOT to Use

- Building general Simulink models without C/C++ integration
- MATLAB Function blocks (Embedded MATLAB) — those use MATLAB syntax, not C/C++
- Code generation workflows (Embedded Coder, Simulink Coder) — this skill is for simulation-time configuration only

## Rules

- Derive each symbol's Simulink type from the corresponding C/C++ function parameter/return type (e.g. `float` → `single`, `bool` → `boolean`, `char*`/`char[]` → `string` (R2024b+)). However, when replacing an existing block (e.g. an S-Function), use the types already on that block first — for example, what looks like `int32` from C may actually be `fixdt(1,32,3)` or another fixed-point type in the existing model.
- **MANDATORY for C++ classes:** When the user's code defines a C++ class, you MUST first attempt to declare a Persistent symbol of `Class: ClassName` and call class methods directly in the code sections (e.g. `obj.Method(args)`). If the class has an init method (not a constructor), call it in `StartCode`. Only fall back to wrapper/handler functions or opaque pointer patterns if the class approach fails to compile.
- **Prefer relative paths** for custom code files (sources, headers, libraries, search directories). Use paths relative to the model file location (e.g. `'myFunctions.h'`, `'./src/myLib.cpp'`) rather than absolute paths. This ensures portability across machines and users.

## Workflow Overview

1. **Add the C Function block** — use `model_edit` with type `"C Function"` and set `CustomCodeSettingLocation` (default: `"BlockSettings"`)
2. **Configure custom code settings** — point to headers/sources either on the block or model config (see `references/custom-code-config.md`)
3. **Set code sections** — configure `OutputCode`, `StartCode`, etc. on the block
4. **Configure symbols via SymbolSpec** — use `model_query_params` to get the SymbolSpec, then `evaluate_matlab_code` for object operations

## SymbolSpec API (Port & Symbol Specification)

The SymbolSpec object defines the block's inputs, outputs, persistent state, constants, and parameters.

### Getting the object

Query with `model_query_params`, then operate via `evaluate_matlab_code`:

```matlab
obj = get_param('myModel/MyCFunction', 'SymbolSpec');
```

### Adding, getting, deleting symbols
```matlab
symObj = obj.addSymbol('varName');       % adds with default: Input, double, size '1'
symObj = obj.getSymbol('varName');       % get one by name
allSyms = obj.Symbols;                  % get all symbols
obj.deleteSymbol('varName');
```

**Note:** `addSymbol` always creates with defaults (`double`, `Input`, size `'1'`). When re-adding a deleted symbol, explicitly set all non-default properties (Type, Scope, Size) — prior properties are not retained.

### Symbol Properties

| Property | Values | Default | Notes |
|----------|--------|---------|-------|
| `Name` | identifier string | (from addSymbol) | Variable name in code; for class types includes constructor args |
| `Scope` | `'Input'`, `'Output'`, `'InputOutput'`, `'Persistent'`, `'Constant'`, `'Parameter'` | `'Input'` | See Scope Details below |
| `Type` | `'double'`, `'single'`, `'int8'`...`'uint64'`, `'Boolean'`, `'string'`, `'Bus: BusName'`, `'Enum: EnumName'`, `'Class: ClassName'`, `'AliasTypeName'`, or fixedpoint | `'double'` | |
| `Size` | dimension string | `'1'` | e.g. `'1'`, `'3'`, `'[2,3]'`, `'size(u1)'` |
| `Label` | port label / value | same as Name | For Constant: the literal value |
| `PortNumber` | uint32 | auto-assigned | Port ordering |

### Scope Details

| Scope | Description | Port? |
|-------|-------------|-------|
| `Input` | Block input port | Yes (inport) |
| `Output` | Block output port | Yes (outport) |
| `InputOutput` | Read-write pass-through (always first in port numbering) | Yes (both) |
| `Persistent` | State that persists across time steps (also used for class instances) | No |
| `Constant` | Compile-time constant (scalar only) | No |
| `Parameter` | Tunable parameter from workspace/mask | No |

### Setting Parameter values

After setting Scope to `'Parameter'`, set the value by configuring the block with the parameter name as the key.

## C++ Class Types

Class instances are declared as **Persistent** scope symbols with `Type` = `'Class: ClassName'`.

**Constructor arguments are specified in the `Name` property:**

```matlab
obj = get_param('myModel/CFunction', 'SymbolSpec');

% Default constructor (no args)
sym = obj.addSymbol('myObj');
sym.Scope = 'Persistent';
sym.Type = 'Class: MyClass';

% Constructor with arguments (args must be Parameter or Constant scope symbols)
sym = obj.addSymbol('myObj(p)');
sym.Scope = 'Persistent';
sym.Type = 'Class: MyClass';
```

**Rules for class types:**
- Class must be defined in an external header (included via custom code settings) — NOT inside code sections
- Cannot create class instances as local variables in code sections — applies when `CustomCodeSettingLocation` = `'ModelConfigurationParameters'` (always parsed), or `'BlockSettings'` with `ParseBlockCode` = `'on'`
- Constructor arguments must be **Parameter** or **Constant** scoped symbols only
- Function calls in constructor arguments are not allowed
- `new` operator is not allowed when block code is parsed
- Private/protected members cannot be accessed from code sections
- Class type does not support save/restore (SimSnapshot)

Access class methods in code sections: `y = myObj.compute(u1);`

## Size Expressions

- Scalar: `'1'`
- Vector: `'3'` or `'[3,1]'`
- Matrix: `'[2,3]'`
- Dynamic from input: `'size(u1)'`, `'size(u1,1)'`, `'size(u1) + 1'`

**Rules:**
- `size()` IS allowed in **output** dimensions (compute output size from inputs)
- `size()` is NOT allowed in **input** dimensions
- Output size CANNOT be `'-1'` (inherited) — must be explicit or use `size()` expression
- Input size CAN be `'-1'` (inherited)
- Size must evaluate to integer values
- Nested `size(size(...))` is NOT supported

## Restrictions

- `#include` directives NOT allowed inside code sections (Start/Output/Terminate) — use custom code settings
- Start/Terminate code CANNOT access Input or Output scoped symbols
- Constant scope must be scalar
- Library functions (e.g. `isalnum`) not supported inside code sections when `ParseBlockCode` = `'on'` or `CustomCodeSettingLocation` = `'ModelConfigurationParameters'` — use external calls via header. No restriction under default R2026a+ settings (`BlockSettings` + `ParseBlockCode` = `'off'`)
- When using a `Simulink.NumericType` with `DataScope` = `'Exported'` in symbols, or any `Simulink.NumericType` in code sections, its `IsAlias` property must be `true`
- When `CustomCodeSettingLocation` = `'UpdateBuildInfo'`, `GenerateCodeAsIs` is forced `'on'`
- Class definitions NOT allowed inside code sections — define in external header
- Variable-size signals are not supported

## Full Example: Block-Level Custom Code with C++ Function

```matlab
% 1. Add C Function block with block-level custom code
%    Use model_edit: add_block type "C Function", set CustomCodeSettingLocation,
%    SimCustomHeaderFile, SimCustomSourceFile, and OutputCode on the block.

% 2. Configure symbols
obj = get_param('mMyTest/C Function', 'SymbolSpec');
obj.addSymbol('u1');
obj.addSymbol('u2');
u2obj = obj.getSymbol('u2');
u2obj.Type = 'int32';
u2obj.Size = '3';
obj.addSymbol('y');
yobj = obj.getSymbol('y');
yobj.Scope = 'Output';
yobj.Size = 'size(u2)';
obj.addSymbol('state');
stateobj = obj.getSymbol('state');
stateobj.Scope = 'Persistent';
save_system('mMyTest');
close_system('mMyTest', 0);
```

See `references/examples.md` for additional patterns (model-level custom code, C++ class with constructor args).
See `references/custom-code-config.md` for detailed parameter tables and custom code location settings.

----

Copyright 2026 The MathWorks, Inc.

----
