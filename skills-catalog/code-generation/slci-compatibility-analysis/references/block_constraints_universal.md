# Block Support Constraints: Universal Constraints

These constraints apply to every supported Simulink block regardless of type. They cover data types, complexity, dimensionality, block naming, frame-based signals, custom storage classes, constant block outputs, and initialize/terminate events.

---

## 1. Universal Constraints (Apply to All Supported Blocks)

### 1.1 Data Type Constraint - Nonfatal

**Constraint:** Input and output ports must be of data types: `double`, `single`,
`int8`, `uint8`, `int16`, `uint16`, `int32`, `uint32`, `int64`, `uint64`,
`boolean`, `string`, or enumeration inherited from `Simulink.IntEnumType` with
default value 0.

**Additional rules:**
- If the block supports buses, ports can be buses or arrays of buses whose
  elements meet the data type constraint
- Data type `auto` is supported only when `CompiledBusType` of the port is
  `VIRTUAL_BUS`
- Data type `string` is supported only when `TargetLang` is set to `C`
- Data type `stringtype(N)` is not supported

#### Why SLCI Requires This

SLCI's equivalence checking engine maps model-level data types to C-language types in the generated code. Fixed-point types, custom floating-point types, and other unsupported types produce scaling, overflow, and rounding code that SLCI cannot trace to a single model element. The supported set corresponds exactly to C primitive types with direct, unambiguous code representations.

#### Fix

Replace fixed-point or unsupported types with supported ones (e.g., `set_param('model/Gain', 'OutDataTypeStr', 'double')`).

---

### 1.2 Complexity Constraint - Nonfatal

**Constraint:** Input and output ports must be noncomplex. Complex values are not
supported for code inspection.

#### Why SLCI Requires This

Complex signals generate paired real/imaginary code paths with interleaved operations. SLCI cannot independently verify the real and imaginary components against a single model signal.

#### Fix

Ensure signals are real (noncomplex). Split complex signals into real/imaginary parts using a Complex to Real-Imag block before the unsupported block.

---

### 1.3 Dimensionality Constraint - Nonfatal

**Constraint:** Input and output ports must be scalars, vectors, or 2-D matrices.

**Exclusions:** This constraint does not apply to Reshape, Selector, Concatenate,
Interpolation Using Prelookup (n-D), and n-D Lookup Table blocks.

#### Why SLCI Requires This

N-dimensional arrays (3-D+) produce multi-level nested loop code with complex index calculations that SLCI cannot map back to the flat signal representation visible in the model diagram.

#### Fix

Reshape N-D signals to 2-D matrices or vectors using a Reshape block before
connecting to the constrained block.

---

### 1.4 Block Naming Constraint - Nonfatal

**Constraint:** Block names must not contain `*/` or `/*`. Block names must not
end with `*`.

#### Why SLCI Requires This

These character sequences conflict with C comment delimiters (`/* */`) in the generated code's traceability comments. Block names appear in code comments for traceability; invalid sequences can corrupt the generated source or break SLCI's comment-based tracing.

#### Fix

Rename blocks to remove offending characters (e.g., `set_param('model/My*/Block', 'Name', 'My_Block')`).

---

### 1.5 Frame-Based Signal Constraint - Nonfatal

**Constraint:** Input and output ports must not use frame-based signals.

**Exclusions:** This constraint does not apply to Discrete FIR Filter blocks.

#### Why SLCI Requires This

Frame-based processing introduces buffering and batch-processing code constructs (circular buffer indices, memcpy-based frame shifts, buffer management counters) that have no corresponding model-level element. SLCI cannot trace the buffer management code back to any block in the model.

#### Fix

Change block to sample-based processing (e.g., `set_param('model/Unit Delay', 'InputProcessing', 'Elements as channels (sample based)')`).

---

### 1.6 Custom Storage Class Constraint - Nonfatal

**Constraint:** Output signal custom storage class:
- Must have Type set to `Unstructured` or `FlatStructure`
- Must have Data initialization property set to a value other than `None`
- Must be one of: `Auto`, `Model Default`, `ExportedGlobal`, `ImportedExtern`,
  `ImportedExternPointer`, `Volatile`, `ExportToFile`, `ImportFromFile`,
  `GetSet`, `Reusable`
- If Data Scope is set to `Auto`, the storage class must be `Reusable`

#### Why SLCI Requires This

SLCI must resolve the memory layout and access pattern of every signal to verify code equivalence. Unsupported storage classes produce access patterns (e.g., structured globals, custom access functions) that SLCI's analysis engine cannot interpret.

#### Fix

Set storage class to a supported value via a signal object (`sig.CoderInfo.StorageClass = 'ExportedGlobal'`) or in the Code Mappings editor (set to Auto or Model Default).

---

### 1.7 Signal Object InitialValue Constraint - Nonfatal

**Constraint:** Output port must not reference a signal object with a non-empty
`InitialValue` property.

#### Why SLCI Requires This

When an output port resolves to a signal object with a non-empty `InitialValue`, the code generator uses the signal object's value for initialization rather than the block's configured parameter. This creates a disconnect between the model block parameter and the generated initialization code -- SLCI verifies initialization against the block's dialog parameters, not an external signal object's `InitialValue` property.

#### Fix

Clear the signal object's `InitialValue` property (set it to `''`). For signal objects in data dictionaries, retrieve the entry, clear `InitialValue`, and save.

---

### 1.8 Constant Block Output Constraints - Nonfatal

**Constraint:**
- Output port must not be testpointed when the block is constant
- Output signal storage class must be set to `Auto` when the block is constant
- Blocks that are constant or have tunable parameters must not drive two or more
  multirate blocks without using explicit Rate Transition blocks

#### Why SLCI Requires This

Constant blocks fold into compile-time values in the generated code. Test points, non-Auto storage classes, and multirate fanout force the code generator to create runtime variables or rate-transition buffers for constants, producing code with no corresponding model-level behavior.

#### Fix

Remove test points from constant block outputs, set storage class to Auto, and insert Rate Transition blocks between constants and downstream blocks at different sample rates.

---

### 1.9 Initialize/Terminate Event Sample Time Constraints - Nonfatal

**Constraint:**
- Blocks with initialize event sample time (inside Initialize Function
  subsystems) are not supported, except: Inport, In Bus Element, Constant,
  Data Store Write, State Writer
- Blocks with terminate event sample time are not supported, except when inside
  a Terminate Function subsystem: State Reader, Data Store Read, Outport,
  Out Bus Element, Bus Creator, Bus Selector

#### Why SLCI Requires This

Initialize and terminate functions generate one-shot code that executes outside the periodic step function. SLCI's equivalence checking focuses on the periodic execution path; only a restricted set of blocks in these special subsystems produces code simple enough for SLCI to verify.

#### Fix

Only use the supported blocks inside Initialize Function and Terminate Function
subsystems:
- **Initialize Function:** Inport, In Bus Element, Constant, Data Store Write,
  State Writer
- **Terminate Function:** State Reader, Data Store Read, Outport, Out Bus Element,
  Bus Creator, Bus Selector

Move unsupported blocks out of these special subsystems into the main model or
periodic subsystems.

----

Copyright 2026 The MathWorks, Inc.

----
