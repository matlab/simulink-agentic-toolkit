# Block Support Constraints: Lookup Tables and User-Defined Functions

Blocks in this category implement table-based interpolation, prelookup operations, C function calls, and S-functions.

---

## 11. C Caller — Nonfatal

**Block:** simulink/User-Defined Functions/C Caller

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input and output ports must be `double`, `single`, `int8`, `int16`, `int32`, `int64`, `uint8`, `uint16`, `uint32`, or `uint64` | Nonfatal |
| Block Parameters | No block-specific constraints | N/A |

### Constraint Details

#### Input and output ports restricted to numeric types (no boolean/string)

**Why:** The C Caller block invokes an external C function with specific argument types. Only numeric types (`double`, `single`, and integer types) have unambiguous C type mappings. Boolean and string types have platform-dependent representations that may not match the external function's expectations.

**Fix:**

Ensure the C function's prototype uses standard numeric types, and configure the C Caller block ports accordingly.

---

## 47. Interpolation Using Prelookup (n-D) — Nonfatal

**Block:** simulink/Lookup Tables/Interpolation Using Prelookup

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Block ports must not be of bus data type | Nonfatal |
| Data Types and Ports | Intermediate results (`IntermediateResultsDataTypeStr`) must be `Inherit: Inherit via internal rule`, `Inherit: Same as output`, `double`, or `single` | Nonfatal |
| Data Types and Ports | Output (`OutDataTypeStr`) must be `Inherit: Inherit via back propagation`, `Inherit: Inherit from 'Table data'`, `double`, or `single` | Nonfatal |
| Data Types and Ports | Table data (`TableDataTypeStr`) must be `Inherit: Inherit from 'Table data'`, `Inherit: Same as output`, `double`, or `single` | Nonfatal |
| Data Types and Ports | Internal Rule Priority (`InternalRulePriority`) must be `Precision` | Nonfatal |
| Data Types and Ports | Number of sub-table selection dimensions and index value (k) from Prelookup block must be `uint32` | Nonfatal |
| Data Types and Ports | Intermediate results, Table data, Output, and fraction value (f) from Prelookup must be same data type: `double` or `single` | Nonfatal |
| Data Types and Ports | Integer rounding mode (`RndMeth`) must be set to `Floor` | Nonfatal |
| Data Types and Ports | Saturate on integer overflow (`SaturateOnIntegerOverflow`) must be cleared (set to `off`) | Nonfatal |
| Data Types and Ports | Blocks must not be constant and must not connect all subtable selection inports to constant blocks | Nonfatal |
| Data Types and Ports | Blocks and their outports must not have a constant sample time | Nonfatal |
| Block Parameters | Interpolation method (`InterpMethod`) must be `Linear point-slope` | Nonfatal |
| Block Parameters | Require index and fraction as bus (`RequireIndexFractionAsBus`) must be cleared (set to `off`) | Nonfatal |
| Block Parameters | Specification (`TableSpecification`) must be set to `Explicit values` | Nonfatal |

### Constraint Details

#### InterpMethod must be `Linear point-slope`

**Why:** SLCI verifies the interpolation computation by matching the code pattern to the `Linear point-slope` formula: `y = y_k + f * (y_{k+1} - y_k)`. Other methods (Flat, Nearest, Cubic spline) produce different code patterns that SLCI's lookup table verification algorithm does not support.

**Fix:**
```matlab
set_param('model/Interpolation Using Prelookup', 'InterpMethod', 'Linear point-slope');
```

#### Block ports must not be of bus data type

**Why:** Bus data types produce struct-based accesses in the interpolation computation. SLCI's lookup table verifier expects scalar numeric accesses for index, fraction, and table data. Bus ports introduce field-level indirection that breaks the expected interpolation code pattern.

**Fix:**

Ensure all ports on the Interpolation Using Prelookup block use scalar numeric types (`double` or `single`).

#### IntermediateResultsDataTypeStr must be `Inherit: Inherit via internal rule`, `Inherit: Same as output`, `double`, or `single`

**Why:** Intermediate results in the interpolation computation (products, differences) must use floating-point arithmetic. Other data types introduce type conversion code between computation steps that SLCI cannot map to the interpolation formula.

**Fix:**
```matlab
set_param('model/Interpolation Using Prelookup', 'IntermediateResultsDataTypeStr', 'Inherit: Same as output');
```

#### OutDataTypeStr must be `Inherit: Inherit via back propagation`, `Inherit: Inherit from 'Table data'`, `double`, or `single`

**Why:** SLCI verifies the interpolation output assignment. Only floating-point output types produce a direct assignment from the interpolation formula. Other types require cast/conversion code that breaks the expected pattern.

**Fix:**
```matlab
set_param('model/Interpolation Using Prelookup', 'OutDataTypeStr', 'Inherit: Inherit from ''Table data''');
```

#### TableDataTypeStr must be `Inherit: Inherit from 'Table data'`, `Inherit: Same as output`, `double`, or `single`

**Why:** Table data must be floating-point to match the linear interpolation formula. Fixed-point or integer table data introduces scaling operations in the interpolation computation that SLCI cannot verify.

**Fix:**
```matlab
set_param('model/Interpolation Using Prelookup', 'TableDataTypeStr', 'Inherit: Same as output');
```

#### InternalRulePriority must be `Precision`

**Why:** When set to `Speed`, the code generator may use optimized but structurally different interpolation code (e.g., combined multiply-add operations or reordered computations). SLCI requires the `Precision` priority to ensure the generated code follows the standard point-slope formula pattern.

**Fix:**
```matlab
set_param('model/Interpolation Using Prelookup', 'InternalRulePriority', 'Precision');
```

#### Index value (k) from Prelookup must be `uint32`

**Why:** SLCI's lookup table verifier expects array indices to be `uint32`. This matches the standard code generation pattern for array subscript operations. Other index types produce type conversion code between the Prelookup output and the interpolation index access.

**Fix:**

Ensure the Prelookup block's `IndexDataTypeStr` is set to `uint32`.

#### Intermediate results, Table data, Output, and fraction must be same data type (`double` or `single`)

**Why:** Mixed floating-point types within the interpolation computation produce implicit type promotion or demotion casts. SLCI verifies the interpolation formula as a single uniform-type expression. Mixed types introduce cast operations that break the expected continuous computation pattern.

**Fix:**
```matlab
set_param('model/Interpolation Using Prelookup', 'IntermediateResultsDataTypeStr', 'double');
set_param('model/Interpolation Using Prelookup', 'TableDataTypeStr', 'Inherit: Same as output');
set_param('model/Interpolation Using Prelookup', 'OutDataTypeStr', 'double');
```

#### RndMeth must be `Floor`

**Why:** Same pattern as Prelookup S59. Non-`Floor` rounding modes produce conditional correction code in index computation that SLCI cannot trace.

**Fix:**
```matlab
set_param('model/Interpolation Using Prelookup', 'RndMeth', 'Floor');
```

#### SaturateOnIntegerOverflow must be cleared

**Why:** Same pattern as Dead Zone S22. Overflow guards produce conditional code with no model-level counterpart.

**Fix:**
```matlab
set_param('model/Interpolation Using Prelookup', 'SaturateOnIntegerOverflow', 'off');
```

#### Block must not be constant and must not connect all subtable selection inports to constants

**Why:** When the block or all its subtable selection inputs are constant, the code generator folds the interpolation computation at compile time, producing a single constant assignment instead of the interpolation code pattern. SLCI requires runtime interpolation code to verify.

**Fix:**

Ensure at least one subtable selection input comes from a non-constant source.

#### Block and outports must not have constant sample time

**Why:** Constant sample time causes the code generator to evaluate the block once during initialization and fold the result. The interpolation code is placed in `model_initialize()` or eliminated entirely, rather than appearing in `model_step()` where SLCI expects to find and verify it.

**Fix:**

Ensure the block's sample time is inherited or explicitly set to a periodic value, not `Inf` (constant).

#### RequireIndexFractionAsBus must be cleared

**Why:** When enabled, the index and fraction inputs are received as a bus (struct), producing struct field access code for the interpolation inputs. SLCI expects separate scalar variables for index (`uint32`) and fraction (`double`/`single`).

**Fix:**
```matlab
set_param('model/Interpolation Using Prelookup', 'RequireIndexFractionAsBus', 'off');
```

#### TableSpecification must be `Explicit values`

**Why:** When set to `Lookup table object`, the table data is accessed through an object reference that may produce different code patterns depending on the object's storage class and configuration. SLCI requires explicit table values that produce direct array access code.

**Fix:**
```matlab
set_param('model/Interpolation Using Prelookup', 'TableSpecification', 'Explicit values');
```

---

## 49. 1-D Lookup Table, 2-D Lookup Table, n-D Lookup Table — Nonfatal

**Block:** simulink/Lookup Tables (n-D Lookup Table)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input and output ports must have the same data type | Nonfatal |
| Block Parameters | Breakpoints specification (`BreakpointsSpecification`) must be `Explicit values` | Nonfatal |
| Block Parameters | Interpolation method (`InterpMethod`) must be `Linear point-slope` | Nonfatal |
| Block Parameters | Extrapolation method (`ExtrapMethod`) must be `Clip` or `Linear` | Nonfatal |
| Block Parameters | Index search method (`IndexSearchMethod`) must be `Binary search` or `Linear search` | Nonfatal |
| Block Parameters | Support tunable table size (`SupportTunableTableSize`) must not be selected (set to `off`) | Nonfatal |
| Block Parameters | Table data (`Table`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |
| Block Parameters | Source (`TableSource`) must be set to `Dialog` | Nonfatal |
| Block Parameters | For `Explicit values`, Breakpoints must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |
| Block Parameters | Table data type (`TableDataTypeStr`) must use same data type as block output (or for lookup table objects with Support tunable size, limited to `double`/`single`) | Nonfatal |
| Block Parameters | Intermediate Results (`IntermediateResultsDataTypeStr`) must use same data type as block output | Nonfatal |
| Block Parameters | Blocks and their output ports must not be constant | Nonfatal |
| Block Parameters | Use one input port for all input data (`UseOneInputPortForAllInputData`) must be cleared (set to `off`) | Nonfatal |
| Block Parameters | Apply more accurate and efficient rounding when possible (`ApplyAccurateEfficientRounding`) must not be selected (set to `off`) | Nonfatal |
| Block Parameters | Breakpoints > Data Type must be the same data type as the block input | Nonfatal |

### Constraint Details

#### Input and output ports must have the same data type

**Why:** When input (breakpoint) and output (table) ports have different data types, the code generator inserts implicit type conversions in the interpolation computation. SLCI verifies the lookup table as a uniform-type computation. Type casts between index lookup and output assignment break the expected pattern.

**Fix:**

Ensure the block's input and output ports use the same floating-point type (`double` or `single`). Use Data Type Conversion blocks before/after if needed.

#### BreakpointsSpecification must be `Explicit values`

**Why:** When set to `Even spacing`, breakpoint data is not stored as an array -- instead, the code generator computes the index directly from the spacing parameters. This produces a division-based index formula instead of a search algorithm, generating a code pattern SLCI cannot verify.

**Fix:**
```matlab
set_param('model/1-D Lookup Table', 'BreakpointsSpecification', 'Explicit values');
```

#### InterpMethod must be `Linear point-slope`

**Why:** Same reasoning as Interpolation Using Prelookup S47. SLCI verifies the linear point-slope interpolation formula pattern in the generated code.

**Fix:**
```matlab
set_param('model/Lookup Table', 'InterpMethod', 'Linear point-slope');
```

#### ExtrapMethod must be `Clip` or `Linear`

**Why:** Other extrapolation methods (e.g., `Cubic spline`) produce complex polynomial evaluation code outside the breakpoint range. SLCI's lookup table verifier only supports the `Clip` (saturation at boundary) and `Linear` (extension using end-segment slope) extrapolation patterns.

**Fix:**
```matlab
set_param('model/1-D Lookup Table', 'ExtrapMethod', 'Clip');
```

#### IndexSearchMethod must be `Binary search` or `Linear search`

**Why:** SLCI recognizes specific search algorithm code patterns (binary search loop or linear search loop) and maps them to the Lookup Table block. Evenly-spaced search produces a direct index computation (division by spacing) that uses a different code pattern. SLCI's lookup table verifier only supports the Binary and Linear search patterns.

**Fix:**
```matlab
set_param('model/1-D Lookup Table', 'IndexSearchMethod', 'Binary search');
```

#### SupportTunableTableSize must not be selected

**Why:** Tunable table size introduces runtime dimension variables that control loop bounds for the search and interpolation algorithms. These dimension variables have no model-level counterpart. SLCI requires fixed table sizes known at code generation time for static verification.

**Fix:**
```matlab
set_param('model/1-D Lookup Table', 'SupportTunableTableSize', 'off');
```

#### Table data must not be empty, nonfinite, complex, or use range selection/variable indexing

**Why:** SLCI resolves table data at analysis time to verify the generated constant array initializers. Empty tables produce no code, nonfinite values (`Inf`/`NaN`) require special IEEE-754 representations, complex values violate Universal Constraint 1.2, and range/variable-indexed MATLAB structures cannot be resolved statically.

**Fix:**
```matlab
set_param('model/1-D Lookup Table', 'Table', '[0 2 4 8 16]');
```

#### TableSource must be `Dialog`

**Why:** When set to `Input port`, table data comes from an upstream signal rather than a compile-time constant. SLCI's lookup table verifier requires the table values to be known at analysis time to verify the generated array initializer matches the block configuration.

**Fix:**
```matlab
set_param('model/1-D Lookup Table', 'TableSource', 'Dialog');
```

#### Breakpoints must not be empty, nonfinite, complex, or use range selection/variable indexing

**Why:** Same as Table data constraints. SLCI must resolve breakpoint arrays at analysis time to verify the generated breakpoint array initializers and search algorithm bounds.

**Fix:**
```matlab
set_param('model/1-D Lookup Table', 'BreakpointsForDimension1', '[0 1 2 5 10]');
```

#### TableDataTypeStr must use same data type as block output

**Why:** Type mismatch between table data storage and output produces implicit casts in the interpolation formula. SLCI verifies the interpolation as a uniform-type expression without intermediate conversions.

**Fix:**
```matlab
set_param('model/1-D Lookup Table', 'TableDataTypeStr', 'Inherit: Same as output');
```

#### IntermediateResultsDataTypeStr must use same data type as block output

**Why:** Mixed types in intermediate computations (differences, products) produce cast operations between steps of the interpolation formula. SLCI requires a uniform-type computation to verify.

**Fix:**
```matlab
set_param('model/1-D Lookup Table', 'IntermediateResultsDataTypeStr', 'Inherit: Same as output');
```

#### Block and output ports must not be constant

**Why:** Constant blocks/ports cause the code generator to fold the lookup table computation into a single constant value at compile time. No search or interpolation code is generated, so SLCI has nothing to verify against the block's table configuration.

**Fix:**

Ensure the block has a non-constant input source (not connected directly to a Constant block in a constant-folding context).

#### UseOneInputPortForAllInputData must be cleared

**Why:** When enabled, all breakpoint inputs are combined into a single vector input port. The code generator must then decompose this vector internally, producing index-based element extraction code that SLCI cannot map to individual breakpoint dimensions.

**Fix:**
```matlab
set_param('model/1-D Lookup Table', 'UseOneInputPortForAllInputData', 'off');
```

#### ApplyAccurateEfficientRounding must not be selected

**Why:** This option enables optimized rounding code that may differ from the standard floor/truncation pattern. SLCI expects standard rounding behavior in index computation. The optimized rounding produces platform-specific code patterns.

**Fix:**
```matlab
set_param('model/1-D Lookup Table', 'ApplyAccurateEfficientRounding', 'off');
```

#### Breakpoints Data Type must be same as block input

**Why:** When breakpoint data type differs from the input, the comparison operations in the search algorithm require implicit type conversions. SLCI verifies the search loop by matching input values directly against breakpoint array elements without intermediate casts.

**Fix:**
```matlab
set_param('model/1-D Lookup Table', 'BreakpointsForDimension1DataTypeStr', 'Inherit: Same as corresponding input');
```

---

## 59. Prelookup — Nonfatal

**Block:** simulink/Lookup Tables/Prelookup

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Block ports must not be of bus data type | Nonfatal |
| Block Parameters | Index search method (`IndexSearchMethod`) must be `Binary search` or `Linear search` | Nonfatal |
| Block Parameters | Breakpoints specification (`BreakpointsSpecification`) must be `Explicit values` | Nonfatal |
| Block Parameters | Output selection must be set to `Index and fraction` or `Index only` | Nonfatal |
| Block Parameters | Breakpoint > Data Type must be `Inherit: Same as input`, `single`, or `double` | Nonfatal |
| Block Parameters | Index > Data Type (`IndexDataTypeStr`) must be `uint32` | Nonfatal |
| Block Parameters | Fraction > Data Type (`FractionDataTypeStr`) must be `single` or `double` | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be set to `Floor` | Nonfatal |

### Constraint Details

#### Block ports must not be of bus data type

**Why:** Bus types produce struct-based accesses for the prelookup input/output. SLCI's lookup table verifier expects scalar numeric values for the input signal and scalar index/fraction outputs. Bus ports introduce struct field indirection incompatible with the expected prelookup code pattern.

**Fix:**

Ensure all Prelookup ports use scalar numeric types.

#### IndexSearchMethod must be `Binary search` or `Linear search`

**Why:** Same as n-D Lookup Table S49. SLCI recognizes specific search algorithm code patterns (binary search loop or linear scan). Other methods (evenly-spaced) produce division-based direct computation that SLCI cannot verify.

**Fix:**
```matlab
set_param('model/Prelookup', 'IndexSearchMethod', 'Binary search');
```

#### BreakpointsSpecification must be `Explicit values`

**Why:** Same as n-D Lookup Table S49. `Even spacing` eliminates the breakpoint array and computes index via division, producing a code pattern SLCI cannot verify.

**Fix:**
```matlab
set_param('model/Prelookup', 'BreakpointsSpecification', 'Explicit values');
```

#### Output selection must be `Index and fraction` or `Index only`

**Why:** Other output modes (e.g., `Fraction only`) omit the index output, producing a different code pattern where the search result is partially discarded. SLCI expects the standard Prelookup pattern that outputs at minimum the index value, matching the downstream Interpolation block's expected input.

**Fix:**
```matlab
set_param('model/Prelookup', 'OutputSelection', 'Index and fraction');
```

#### Breakpoint Data Type must be `Inherit: Same as input`, `single`, or `double`

**Why:** Breakpoint data is compared against the input signal during the search algorithm. When the breakpoint type differs from the input (other than the allowed inherit option), the comparison requires type conversions that produce additional code SLCI cannot trace.

**Fix:**
```matlab
set_param('model/Prelookup', 'BreakpointsDataTypeStr', 'Inherit: Same as input');
```

#### RndMeth must be `Floor`

**Why:** Non-`Floor` rounding modes produce conditional correction code after division or type conversion operations in the index computation. The rounding correction logic has no model-level counterpart that SLCI can trace.

**Fix:**
```matlab
set_param('model/Prelookup', 'RndMeth', 'Floor');
```

#### IndexDataTypeStr must be `uint32`

**Why:** SLCI's lookup table verifier expects index values to be `uint32` because this matches the standard code generation pattern for array indexing. Other index types would require type conversion code between the Prelookup output and the Interpolation block's index input.

**Fix:**
```matlab
set_param('model/Prelookup', 'IndexDataTypeStr', 'uint32');
```

#### FractionDataTypeStr must be `single` or `double`

**Why:** The fraction value represents a normalized position between breakpoints (0.0 to 1.0). Only floating-point types can accurately represent this fractional value. Integer fraction types would introduce scaling and rounding code that SLCI cannot trace.

**Fix:**
```matlab
set_param('model/Prelookup', 'FractionDataTypeStr', 'double');
```

---

## 70. S-Function — Nonfatal

**Block:** simulink/User-Defined Functions/S-Function

**Note:** Only S-functions created using the current release of the Legacy Code Tool are supported.

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Arguments must be scalars, or vectors of fixed dimension | Nonfatal |
| Data Types and Ports | Integrated model of an S-function SIL block must not use global variables for root input and output ports | Nonfatal |
| Block Parameters | S-function parameters (`Parameters`) must not be complex or nonfinite | Nonfatal |
| Block Parameters | S-functions must be created using Legacy Code Tool with `legacy_code('slblock_generate', def)` | Nonfatal |
| Block Parameters | Can only specify `OutputFcnSpec` (not `InitializeConditionsFcnSpec`, `StartFcnSpec`, or `TerminateFcnSpec`) | Nonfatal |
| Block Parameters | Cannot have more than one dwork | Nonfatal |

**Legacy Code Tool data constraints:**
- Data must be scalar or one-dimensional vector (not 2-D). Use `u[6]`, not `u[2][3]`
- Dimension must be explicitly set. Use `u[6]`, not `u[]`

### Constraint Details

#### Arguments must be scalars or vectors of fixed dimension

**Why:** SLCI verifies S-function code by matching the function call arguments against the block's port dimensions. Only scalar and fixed-size 1-D vector arguments produce deterministic function signatures. 2-D arrays produce pointer-to-pointer or flattened access patterns that SLCI cannot map to the Legacy Code Tool spec. Variable-size arguments introduce runtime dimension parameters with no model counterpart.

**Fix:**

In the Legacy Code Tool definition, use explicit scalar or 1-D dimensions:
```matlab
def.OutputFcnSpec = 'double y1[6] = myFcn(double u1[6])';  % not u1[2][3]
```

#### SIL block integrated model must not use global variables for root I/O

**Why:** When an S-function SIL block's integrated model uses `ExportedGlobal` or similar storage classes for root inports/outports, the generated code accesses data through global variables rather than function arguments. SLCI cannot trace the data flow between the S-function wrapper and global variable accesses.

**Fix:**

In the integrated model's Code Mappings, set all root inport/outport Storage Classes to `Auto` or `Model Default`.

#### S-function parameters must not be complex or nonfinite

**Why:** S-function parameters are passed as constants in the generated code. Complex parameters produce paired `.re`/`.im` argument passing that SLCI cannot verify. Nonfinite parameters (`Inf`/`NaN`) require special IEEE-754 constant representations that vary across compilers.

**Fix:**

Ensure all S-function parameters are finite, real numeric values.

#### Cannot have more than one dwork

**Why:** Each dwork (discrete work) vector in a Legacy Code Tool S-function generates a state variable. SLCI's S-function verifier maps a single dwork to the function's state argument. Multiple dworks produce multiple state variables and compound state update patterns that the verifier cannot trace.

**Fix:**

Consolidate state into a single dwork vector, or split the S-function into multiple single-dwork S-functions.

#### S-functions must be created using Legacy Code Tool

**Why:** Legacy Code Tool S-functions generate inline C function calls with direct argument passing that SLCI can trace. Hand-written S-functions route data through SimStruct pointers and mdl* callback functions, producing infrastructure-heavy code that SLCI cannot map to the block's defined input/output relationship.

**Fix:**
```matlab
def = legacy_code('initialize');
def.OutputFcnSpec = 'double y1 = myFcn(double u1)';
legacy_code('slblock_generate', def);
```

#### Can only specify OutputFcnSpec

**Why:** `InitializeConditionsFcnSpec`, `StartFcnSpec`, and `TerminateFcnSpec` generate code in initialization/termination functions with lifecycle management that SLCI's step-function-focused analysis cannot verify. Only `OutputFcnSpec` generates code in `model_step()` that SLCI can trace.

**Fix:**

Only define `OutputFcnSpec` in the Legacy Code Tool definition. Move initialization and termination logic outside the S-function.

----

Copyright 2026 The MathWorks, Inc.

----
