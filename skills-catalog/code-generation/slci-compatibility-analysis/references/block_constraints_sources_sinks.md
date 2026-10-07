# Block Support Constraints: Sources and Sinks

Blocks in this category provide signal sources (constants, inports) and signal sinks (outports, terminators), as well as signal property readers (Probe, Width).

---

## 14. Constant — Nonfatal

**Block:** simulink/Sources/Constant

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | Constant value (`Value`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |

### Constraint Details

#### Constant value must not be empty, nonfinite, or complex

**Why:** SLCI resolves Constant block values at analysis time to verify equivalence between the model parameter and the generated code literal or initializer. Empty values produce no code, nonfinite values (Inf/NaN) require special IEEE-754 representations that vary across compilers, and complex values violate Universal Constraint 1.2.

**Fix:**
```matlab
set_param('model/Constant', 'Value', '42.0');  % Use a finite, real value
```

---

## 46. Inport — Mixed Severity

**Block:** simulink/Sources/Inport

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Root inports in referenced models must connect to at least one nonvirtual block | Nonfatal |
| Block Parameters | Variable-size signal (`VarSizeSig`) must be set to `No` | **FATAL** |
| Block Parameters | Signal Type (`SignalType`) must not be set to `complex` | Nonfatal |
| Block Parameters | For inports in triggered subsystems, Latch input by delaying outside signal (`LatchByDelayingOutsideSignal`) must not be selected (set to `off`) | Nonfatal |
| Block Parameters | For root inport blocks that use a bus object, Output as nonvirtual bus (`BusOutputAsStruct`) must be selected (set to `on`) | **FATAL** |
| Other | In Code Mappings editor, Storage Class must be `Auto` or `Model Default` | Nonfatal |

**Note:** Shadowed inports are supported for code inspection.

### Constraint Details

#### Root inports in referenced models must connect to at least one nonvirtual block

**Why:** When a root inport in a referenced model does not connect to any nonvirtual block, the code generator may eliminate the inport's function argument entirely. SLCI expects every root inport to appear as a parameter in the model's step function interface. A missing argument breaks the interface traceability between the parent model's function call and the referenced model's step function signature.

**Fix:** Ensure the inport connects to at least one block that generates code (e.g., a Gain, Sum, or Outport).

#### SignalType must not be `complex`

**Why:** Complex signals violate Universal Constraint 1.2. Complex inports produce paired `.re`/`.im` fields in the external input structure that SLCI cannot verify.

**Fix:**
```matlab
set_param('model/In1', 'SignalType', 'real');
```

#### LatchByDelayingOutsideSignal must not be selected (triggered subsystems)

**Why:** When `LatchByDelayingOutsideSignal` is enabled, the code generator introduces a latch variable (`DWork`) that holds the previous trigger's input value. This latch mechanism has no visible block in the model. SLCI cannot trace the latch variable and its update code to any model element.

**Fix:**
```matlab
set_param('model/Triggered Subsystem/In1', 'LatchByDelayingOutsideSignal', 'off');
```

#### BusOutputAsStruct must be `on` for bus objects — FATAL

**Why:** When `BusOutputAsStruct` is off, bus signals are flattened into individual signals with generated names. SLCI cannot map these auto-generated flat variable names back to the bus object definition in the model. With struct output, the generated code mirrors the bus type hierarchy, providing a direct structural correspondence between the bus object and the C struct type.

**Fix:**
```matlab
set_param('model/In1', 'BusOutputAsStruct', 'on');
```

#### Code Mappings Storage Class must be `Auto` or `Model Default`

**Why:** Non-standard storage classes in Code Mappings (e.g., `ExportedGlobal`, `ImportedExtern`, custom classes) produce variable declarations or `extern` references that deviate from SLCI's expected interface structure. SLCI expects root inports to appear in the standard external input structure (`ExtU_model_T`). Non-standard storage classes may place inport data in separate global variables or imported symbols that SLCI cannot locate.

**Fix:** In the Code Mappings editor, set the inport's Storage Class to `Auto` or `Model Default`.

#### VarSizeSig must be `No` — FATAL

**Why:** Variable-size signals require runtime dimension tracking variables (`_Dim` fields), dynamic loop bounds, and size propagation code throughout the model. None of these have model-level counterparts. The entire code structure becomes data-dependent and unverifiable — SLCI cannot statically determine array bounds, making structural equivalence checking impossible.

**Fix:**
```matlab
set_param('model/In1', 'VarSizeSig', 'No');
```

---

## 57. Outport — Mixed Severity

**Block:** simulink/Sinks/Outport

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | Variable-size signal (`VarSizeSig`) must be set to `No` | **FATAL** |
| Block Parameters | Signal type (`SignalType`) must not be set to `complex` | Nonfatal |
| Block Parameters | Root level outport Initial output (`InitialOutput`) must be `[]` | Nonfatal |
| Block Parameters | Source of initial output value (`SourceOfInitialOutputValue`) must be set to `Dialog` | Nonfatal |
| Block Parameters | Initial output (`InitialOutput`) must not be nonfinite or complex | Nonfatal |
| Other | In Code Mappings editor, Storage Class must be `Auto` or `Model Default` | Nonfatal |

### Constraint Details

#### VarSizeSig must be `No` — FATAL

**Why:** Same as Inport. Variable-size output signals require runtime dimension tracking (`_Dim` fields) that produces untraceable code. SLCI cannot verify code with data-dependent output sizes.

**Fix:**
```matlab
set_param('model/Out1', 'VarSizeSig', 'No');
```

#### SignalType must not be `complex`

**Why:** Complex signals violate Universal Constraint 1.2. Complex outports produce paired `.re`/`.im` fields in the external output structure that SLCI cannot verify.

**Fix:**
```matlab
set_param('model/Out1', 'SignalType', 'real');
```

#### SourceOfInitialOutputValue must be `Dialog`

**Why:** When set to `Input signal default value`, the initial output comes from the driving block's default rather than the Outport's own `InitialOutput` parameter. SLCI verifies initialization by matching the code against the Outport block's dialog parameter. If the source is the input signal's default, the initialization value may come from an upstream block's configuration that SLCI cannot cross-reference during verification.

**Fix:**
```matlab
set_param('model/Out1', 'SourceOfInitialOutputValue', 'Dialog');
```

#### InitialOutput must not be nonfinite or complex

**Why:** Nonfinite values (`Inf`, `NaN`) require runtime special constants (`rtInf`, `rtNaN`) defined in support code outside the model's generated files. Complex values produce paired assignments violating Universal Constraint 1.2. In both cases, SLCI cannot verify the initialization assignment.

**Fix:**
```matlab
set_param('model/Out1', 'InitialOutput', '[]');  % or a finite real value
```

#### Code Mappings Storage Class must be `Auto` or `Model Default`

**Why:** Same as Inport. Non-standard storage classes place outport data in non-standard locations (separate global variables, imported symbols) that deviate from SLCI's expected external output structure (`ExtY_model_T`).

**Fix:** In the Code Mappings editor, set the outport's Storage Class to `Auto` or `Model Default`.

#### InitialOutput must be `[]` for root outports

**Why:** Non-empty initial output values produce assignment code in `model_initialize()` that has no corresponding block in the model (the Outport block itself does not compute values). SLCI cannot trace the initialization assignment to a specific model element.

**Fix:**
```matlab
set_param('model/Out1', 'InitialOutput', '[]');
```

---

## 60. Probe — Nonfatal

**Block:** simulink/Signal Attributes/Probe

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | Data type for sample time (`ProbeSampleTimeDataType`) must be `single` or `double` | Nonfatal |

### Constraint Details

#### ProbeSampleTimeDataType must be `single` or `double`

**Why:** The Probe block outputs signal properties (width, sample time, etc.) as constants. When the sample time output uses an integer type, type conversion code may be generated to represent the floating-point sample time value as an integer. SLCI can only trace direct constant assignments without implicit conversions.

**Fix:**
```matlab
set_param('model/Probe', 'ProbeSampleTimeDataType', 'double');
```

---

## 88. Terminator — Nonfatal

**Block:** simulink/Sinks/Terminator

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | Model block outports must not connect to terminator blocks (violated when every Model block outport connects to a terminator) | Nonfatal |

### Constraint Details

#### Model block outports must not all connect to terminators

**Why:** When all outputs of a Model block connect to Terminators, the code generator may optimize away the Model block's function call entirely (since no output is used). SLCI expects to find the Model block's step function call in the generated code. If the call is eliminated, traceability is broken.

**Fix:** Ensure at least one Model block output connects to a non-Terminator block, or remove unused Model block outputs.

---

## 98. Width — Nonfatal

**Block:** simulink/Signal Attributes/Width

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | Always use constant sample time (`AlwaysUseConstantSampleTime`) must be selected (set to `on`) | Nonfatal |

### Constraint Details

#### AlwaysUseConstantSampleTime must be `on`

**Why:** The Width block outputs a compile-time-known constant (the signal width). With constant sample time, this value is computed once in initialization, matching SLCI's expectation for constant blocks. Without it, the code generator may place the Width computation in the step function with timing that doesn't match the block's constant nature.

**Fix:**
```matlab
set_param('model/Width', 'AlwaysUseConstantSampleTime', 'on');
```

----

Copyright 2026 The MathWorks, Inc.

----
