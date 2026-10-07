# Block Support Constraints: Data Operations

Blocks in this category perform data manipulation including assignment, data store access, type conversion, initial conditions, reshaping, selection, and signal specification.

---

## 5. Assignment — Nonfatal

**Block:** simulink/Math Operations/Assignment

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Index port must be `int8`, `int16`, `int32`, `int64`, `uint8`, `uint16`, `uint32`, `uint64`, `double`, `single`, or enumerated type from `Simulink.IntEnumType` with default value 0 | Nonfatal |
| Block Parameters | No block-specific constraints | N/A |

### Constraint Details

#### Index port data type constraint

**Why:** The Assignment block uses index ports to determine which elements of the output array to assign. SLCI must resolve the index value to verify the element-wise assignment in the generated code. Only standard integer, floating-point, and supported enumeration types produce deterministic index computations that SLCI can trace.

**Fix:**
```matlab
% Ensure index signal uses supported data type
set_param('model/Index Source', 'OutDataTypeStr', 'int32');
```

---

## 15. Data Store Memory — Nonfatal

**Block:** simulink/Signal Routing/Data Store Memory

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply (note: since block has no inports/outports, port constraints do not apply to the Data Store Memory itself) | Nonfatal |
| Block Parameters | Initial value (`InitialValue`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |
| Block Parameters | Data type (`OutDataTypeStr`) must not be set to `string` | Nonfatal |
| Block Parameters | Signal type (`SignalType`) must be set to `auto` or `real` | Nonfatal |
| Block Parameters | Detect Write After Write must be set to `error` | Nonfatal |
| Block Parameters | Data Store Reference (`DatastoreReference`) must not be selected | Nonfatal |
| Other | For global data store memory, `DefaultParameterBehavior` must be set to `Inlined` | Nonfatal |
| Other | For global data store memory, `InitialValue` must not be tunable | Nonfatal |
| Other | Global data store memory blocks must not be used if shadowed by local data store memory blocks | Nonfatal |

### Constraint Details

#### InitialValue must not be empty, nonfinite, or complex

**Why:** SLCI resolves the initial value at analysis time to verify the data store initialization code in `model_initialize()`. Empty, nonfinite, or complex values cannot be mapped to concrete C initializers.

**Fix:**
```matlab
set_param('model/Data Store Memory', 'InitialValue', '0');
```

#### OutDataTypeStr must not be `string`

**Why:** String data types produce dynamically-sized character buffers with runtime length tracking. SLCI cannot verify string operations because the generated code uses string manipulation functions that have no structural model-level counterpart. Related to Universal Constraint 1.1 (unsupported data types).

**Fix:**
```matlab
set_param('model/Data Store Memory', 'OutDataTypeStr', 'double');
```

#### SignalType must be `auto` or `real`

**Why:** When `SignalType` is set to `complex`, the data store holds paired real/imaginary values. Generated code for complex data stores produces separate `.re` and `.im` field assignments that SLCI cannot map to a single data store element in the model. Related to Universal Constraint 1.2 (complex signals not supported).

**Fix:**
```matlab
set_param('model/Data Store Memory', 'SignalType', 'real');
```

#### DatastoreReference must not be selected

**Why:** When `DatastoreReference` is enabled, the data store references an externally defined variable (e.g., from a Simulink.Signal object with `ExportedGlobal` storage class). The generated code uses an `extern` declaration with no corresponding local definition or initialization. SLCI cannot verify the data store's lifecycle because the definition lives outside the generated code boundary.

**Fix:**
```matlab
set_param('model/Data Store Memory', 'DataStoreReference', 'off');
```

#### DefaultParameterBehavior must be `Inlined` for global data stores

**Why:** When `DefaultParameterBehavior` is not `Inlined`, the initial value is stored in a tunable parameter structure (`model_P`). The initialization code references `model_P.gStore_InitialValue` rather than a literal constant. SLCI expects a direct assignment with a traceable constant value, and the indirection through the parameter structure creates a code path that SLCI cannot map back to the block's `InitialValue` property.

**Fix:**
```matlab
set_param('model', 'DefaultParameterBehavior', 'Inlined');
```

#### InitialValue must not be tunable for global data stores

**Why:** If the initial value is marked as tunable (e.g., via a `Simulink.Parameter` object with `ExportedGlobal` storage class), the code generator places it in the tunable parameter structure regardless of the `DefaultParameterBehavior` setting. SLCI requires the initial value to be a compile-time constant so it can verify the initialization assignment directly.

**Fix:**
```matlab
% Make the parameter non-tunable by inlining it
p = Simulink.Parameter;
p.Value = 5.0;
p.CoderInfo.StorageClass = 'Auto';  % allows inlining
```

#### Global data store must not be shadowed by local data store

**Why:** When a local data store shadows a global one with the same name, the code generator renames the local variable (e.g., `gStore_l`) to avoid C naming conflicts. However, both data stores appear with the same name in the model. SLCI cannot determine which variable the generated code references, breaking the one-to-one mapping requirement.

**Fix:**
```matlab
% Rename the local data store
set_param('model/Subsystem A/Data Store Memory', 'DataStoreName', 'localStore');
```

#### Detect Write After Write must be `error`

**Why:** When write-after-write is not detected as an error, multiple writes to the same data store can occur in a single time step. The final value depends on execution order, which is not visible in the model diagram. SLCI cannot verify which write "wins" without execution-order analysis that goes beyond structural equivalence checking.

**Fix:**
```matlab
set_param('model/Data Store Memory', 'WriteAfterWriteMsg', 'error');
```

---

## 16. Data Store Read — Nonfatal

**Block:** simulink/Signal Routing/Data Store Read

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Output data type must not be `string` | Nonfatal |
| Block Parameters | No block-specific constraints | N/A |
| Other | Block cannot reference signal objects as synthesized local data stores | Nonfatal |
| Other | For global data store memory, `DefaultParameterBehavior` must be set to `Inlined` | Nonfatal |
| Other | For global data store memory, `InitialValue` must not be tunable | Nonfatal |
| Other | Block must not perform discontinuous selection on datastore arrays | Nonfatal |
| Other | Block must not use subscripts with brackets to perform selection on datastore arrays | Nonfatal |

### Constraint Details

#### Output data type must not be `string`

**Why:** String data types produce dynamically-sized character buffers with runtime length tracking in the generated code. SLCI cannot verify string read operations because they involve buffer management functions with no structural model-level counterpart. Related to Universal Constraint 1.1 (unsupported data types).

**Fix:** Ensure the associated Data Store Memory block uses a non-string data type.

#### Block cannot reference signal objects as synthesized local data stores

**Why:** When a signal object in the base workspace or data dictionary is used as a synthesized local data store (no explicit Data Store Memory block in the model), the generated code contains a variable definition that has no corresponding model element. SLCI requires every code variable to trace back to a visible block, making verification impossible.

**Fix:** Add an explicit Data Store Memory block to the model instead of relying on workspace signal objects as synthesized data stores.

#### For global data store memory, `DefaultParameterBehavior` must be `Inlined`

**Why:** Same as Data Store Memory section 15. When `DefaultParameterBehavior` is not `Inlined`, the global data store initialization uses a tunable parameter structure indirection that SLCI cannot trace.

**Fix:**
```matlab
set_param('model', 'DefaultParameterBehavior', 'Inlined');
```

#### For global data store memory, `InitialValue` must not be tunable

**Why:** Same as Data Store Memory section 15. Tunable initial values produce parameter structure indirection in the initialization code.

**Fix:**
```matlab
% Make the parameter non-tunable
p = Simulink.Parameter;
p.Value = 5.0;
p.CoderInfo.StorageClass = 'Auto';
```

#### Block must not perform discontinuous selection on datastore arrays

**Why:** Discontinuous selection produces index arithmetic in the generated code that SLCI cannot map to the Data Store Read block's parameter configuration. Contiguous access uses a simple sequential progression, while discontinuous access requires explicit index lists that SLCI cannot verify against the block's selection parameter.

**Fix:** Use contiguous element selection, or use separate Data Store Read blocks for non-contiguous elements.

#### Block must not use subscripts with brackets to perform selection

**Why:** Bracket subscript notation (e.g., `myStruct(2).field`) produces indexed access into structure arrays in the generated code. SLCI's data store verification cannot resolve array indexing into structures because it cannot confirm which structure element is being accessed without evaluating the index expression.

**Fix:** Avoid bracket subscript selection. Use separate Data Store Read blocks to read individual structure array elements, or restructure the data store to avoid structure arrays.

---

## 17. Data Store Write — Nonfatal

**Block:** simulink/Signal Routing/Data Store Write

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input data type must not be `string` | Nonfatal |
| Other | Block cannot reference signal objects as synthesized local data stores | Nonfatal |
| Other | For global data store memory, `DefaultParameterBehavior` must be set to `Inlined` | Nonfatal |
| Other | For global data store memory, `InitialValue` must not be tunable | Nonfatal |
| Other | Block must not perform discontinuous selection on datastore arrays | Nonfatal |
| Other | Block must not use subscripts with brackets to perform selection on datastore arrays | Nonfatal |

### Constraint Details

#### Input data type must not be `string`

**Why:** String data types produce dynamically-sized character buffers with runtime length tracking in the generated code. SLCI cannot verify string write operations because they involve buffer management functions with no structural model-level counterpart. Related to Universal Constraint 1.1 (unsupported data types).

**Fix:** Ensure the associated Data Store Memory block and the signal feeding the Data Store Write use a non-string data type.

#### Block cannot reference signal objects as synthesized local data stores

**Why:** Same as Data Store Read section 16. When a signal object is used as a synthesized local data store without an explicit Data Store Memory block, the generated code variable has no corresponding model element for SLCI to trace to.

**Fix:** Add an explicit Data Store Memory block to the model instead of relying on workspace signal objects as synthesized data stores.

#### For global data store memory, `DefaultParameterBehavior` must be `Inlined`

**Why:** Same as Data Store Memory section 15. When `DefaultParameterBehavior` is not `Inlined`, the global data store initialization uses a tunable parameter structure indirection that SLCI cannot trace.

**Fix:**
```matlab
set_param('model', 'DefaultParameterBehavior', 'Inlined');
```

#### For global data store memory, `InitialValue` must not be tunable

**Why:** Same as Data Store Memory section 15. Tunable initial values produce parameter structure indirection in the initialization code.

**Fix:**
```matlab
% Make the parameter non-tunable
p = Simulink.Parameter;
p.Value = 5.0;
p.CoderInfo.StorageClass = 'Auto';
```

#### Block must not perform discontinuous selection on datastore arrays

**Why:** Same reasoning as Data Store Read section 16. Discontinuous selection produces non-sequential index patterns in the assignment targets that SLCI cannot map to the Data Store Write block's element selection configuration.

**Fix:** Use contiguous element selection for Data Store Write operations.

#### Block must not use subscripts with brackets to perform selection

**Why:** Same as Data Store Read section 16. Bracket subscript notation produces indexed access into structure arrays that SLCI's data store verification cannot resolve without evaluating the index expression.

**Fix:** Avoid bracket subscript selection. Use separate Data Store Write blocks to write individual structure array elements, or restructure the data store to avoid structure arrays.

---

## 18. Data Type Conversion — Nonfatal

**Block:** simulink/Signal Attributes/Data Type Conversion

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | Input and output to have equal (`ConvertRealWorld`) must be `Real World Value (RWV)` | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be set to `Zero` or `Floor` | Nonfatal |
| Block Parameters | Sample Time (`SampleTime`) must not be set to a constant sample time | Nonfatal |

### Constraint Details

#### ConvertRealWorld must be `Real World Value (RWV)`

**Why:** When `ConvertRealWorld` is set to `Stored Integer (SI)`, the block reinterprets raw fixed-point storage bits without applying slope/bias scaling. This produces a raw cast that bypasses the fixed-point scaling semantics visible in the model. SLCI verifies type conversions by matching the model's data type and scaling information against the generated conversion expression, and SI mode produces a trivial cast that doesn't reflect the model's fixed-point scaling.

**Fix:**
```matlab
set_param('model/Data Type Conversion', 'ConvertRealWorld', 'Real World Value (RWV)');
```

#### Integer rounding mode must be `Zero` or `Floor`

**Why:** Non-standard rounding modes (`Nearest`, `Ceiling`, `Convergent`) produce conditional rounding correction code (if/else with +/-0.5 adjustments) after the type conversion. SLCI expects a direct cast statement traceable to the Data Type Conversion block, and the rounding conditional has no model-level counterpart.

**Fix:**
```matlab
set_param('model/Data Type Conversion', 'RndMeth', 'Zero');
```

#### Sample Time must not be constant

**Why:** When a Data Type Conversion block has a constant sample time (`inf` or a specific constant value), the code generator folds the conversion into `model_initialize()` or eliminates it entirely. SLCI expects every block to produce verifiable code in `model_step()`. A folded-away block leaves no trace in the step function for SLCI to verify.

**Fix:**
```matlab
set_param('model/Data Type Conversion', 'SampleTime', '-1');
```

---

## 19. Data Type Duplicate — Nonfatal

**Block:** simulink/Signal Attributes/Data Type Duplicate

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | No block-specific constraints | N/A |

---

## 20. Data Type Propagation — Nonfatal

**Block:** simulink/Signal Attributes/Data Type Propagation

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | No block-specific constraints | N/A |

---

## 43. IC — Nonfatal

**Block:** simulink/Signal Attributes/IC

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Block ports must not be of bus data type | Nonfatal |
| Block Parameters | Initial value (`Value`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |

### Constraint Details

#### Block ports must not be of bus data type

**Why:** When the IC block operates on bus signals, the generated initialization code must assign each field of the bus structure individually (or use `memcpy`). SLCI expects the IC block to produce a single scalar or vector assignment traceable to the block. Bus structures with nested fields produce multi-statement initialization patterns that SLCI cannot map to the single IC block element.

**Fix:** Decompose the bus into individual scalar/vector signals before the IC block, or use separate IC blocks for each bus element.

#### Initial value must not be empty, nonfinite, or complex

**Why:** SLCI resolves the initial value at analysis time to verify the IC block's initialization assignment. Empty values produce no assignment. Nonfinite values (`Inf`, `NaN`) require runtime-initialized special constants whose definitions are in support files outside the model code. Complex values produce paired `.re`/`.im` assignments violating Universal Constraint 1.2.

**Fix:**
```matlab
set_param('model/IC', 'Value', '0.0');
```

---

## 66. Reshape — Nonfatal

**Block:** simulink/Math Operations/Reshape

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Block ports must not be of bus data type | Nonfatal |
| Block Parameters | No block-specific constraints | N/A |

---

## 69. Selector — Nonfatal

**Block:** simulink/Signal Routing/Selector

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Index port must be `int8`, `int16`, `int32`, `int64`, `uint8`, `uint16`, `uint32`, `uint64`, or enumerated type from `Simulink.IntEnumType` with default value 0 | Nonfatal |
| Block Parameters | Index Option (`IndexOptionArray`) must not be set to `Starting and ending indices (port)` | Nonfatal |
| Block Parameters | If Number of input dimensions (`NumberOfDimensions`) is more than 1, index port data must not be connected to a block that selects or reorders input | Nonfatal |

### Constraint Details

#### IndexOptionArray must not be `Starting and ending indices (port)`

**Why:** Port-based start and end indices produce data-dependent loop bounds in the generated code. SLCI requires statically determinable array access patterns to verify equivalence. Runtime indices create loops whose bounds cannot be resolved at analysis time.

**Fix:**
```matlab
set_param('model/Selector', 'IndexOptionArray', {'Index vector (port)'});
```

---

## 74. Signal Specification — Mixed Severity

**Block:** simulink/Signal Attributes/Signal Specification

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | Variable-size signal (`VarSizeSig`) must be `No` | **FATAL** |
| Block Parameters | Signal type (`SignalType`) must not be `complex` | Nonfatal |

### Constraint Details

#### VarSizeSig must be `No` — FATAL

**Why:** Same as Inport section 46. Variable-size signals produce runtime dimension tracking code throughout the model. SLCI cannot statically determine array bounds, making the entire inspection impossible.

**Fix:**
```matlab
set_param('model/Signal Specification', 'VarSizeSig', 'No');
```

----

Copyright 2026 The MathWorks, Inc.

----
