# Block Support Constraints: Signal Routing

Blocks in this category route, multiplex, demultiplex, switch, and merge signals including buses, goto/from tags, and signal selectors.

---

## 8. Bus Assignment — Nonfatal

**Block:** simulink/Signal Routing/Bus Assignment

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | No block-specific constraints | N/A |

---

## 9. Bus Creator — Nonfatal

**Block:** simulink/Signal Routing/Bus Creator

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | Names of signals in Bus Creator (`Inputs`) must match input signal names (`InputSignalNames`) | Nonfatal |

### Constraint Details

#### Signal names must match InputSignalNames

**Why:** SLCI traces bus element assignments by matching signal names to bus type field names. When the Bus Creator's `Inputs` property does not match the actual signal names, the code generator falls back to positional mapping (port 1 to first field, port 2 to second field). SLCI cannot verify that positional assignment is semantically correct.

**Fix:**
```matlab
set_param('model/Bus Creator', 'InheritFromInputs', 'on');
```

---

## 10. Bus Selector — Nonfatal

**Block:** simulink/Signal Routing/Bus Selector

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | No block-specific constraints | N/A |

---

## 24. Demux — Nonfatal

**Block:** simulink/Signal Routing/Demux

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | No block-specific constraints | N/A |
| Other | Output signal of a virtual Demux block must not have `Signal name must resolve to Simulink signal object` property selected | Nonfatal |

### Constraint Details

#### Output signal must not resolve to signal object

**Why:** Virtual Demux blocks do not generate code themselves — they are compiler artifacts that split vector signals. When an output signal resolves to a Simulink.Signal object, the code generator may create a named variable or apply storage class settings that introduce code with no physical block counterpart. SLCI cannot trace signal-object-induced code to a virtual block.

**Fix:**
```matlab
% Clear signal resolution on Demux output
ph = get_param('model/Demux', 'PortHandles');
set_param(ph.Outport(1), 'MustResolveToSignalObject', 'off');
```

---

## 36. From — Nonfatal

**Block:** simulink/Signal Routing/From

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | No block-specific constraints | N/A |
| Other | Output signal of a virtual From block must not have `Signal name must resolve to Simulink signal object` property selected | Nonfatal |

### Constraint Details

#### Output signal must not resolve to signal object

**Why:** Virtual From blocks are resolved at compile time and produce no code. Signal object resolution forces variable creation with storage class attributes that SLCI cannot trace to the virtual From block.

**Fix:**
```matlab
ph = get_param('model/From', 'PortHandles');
set_param(ph.Outport(1), 'MustResolveToSignalObject', 'off');
```

---

## 41. Goto — Nonfatal

**Block:** simulink/Signal Routing/Goto

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | No block-specific constraints | N/A |

---

## 42. Ground — Nonfatal

**Block:** simulink/Sources/Ground

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | No block-specific constraints | N/A |

---

## 51. Merge — Nonfatal

**Block:** simulink/Signal Routing/Merge

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Block sources must be either enabled or action subsystems, or blocks without an InitialConditions function | Nonfatal |
| Data Types and Ports | Block must not have a virtual Bus Selector block as its source | Nonfatal |
| Block Parameters | Allow unequal port widths (`AllowUnequalInputPortWidths`) must not be selected (set to `off`) | Nonfatal |
| Block Parameters | Input port offsets (`InputPortOffsets`) must be `[]` | Nonfatal |
| Block Parameters | Initial output (`InitialOutput`) must not be nonfinite or complex | Nonfatal |

### Constraint Details

#### Block sources must be either enabled or action subsystems, or blocks without an InitialConditions function

**Why:** SLCI traces each Merge block input back to its controlling execution context. The Merge block expects each input to come from a conditionally-executed subsystem (enabled or action) or from a block that does not define an InitialConditions function. Other source types produce initialization code patterns that SLCI cannot reconcile with the Merge block's conditional-write semantics.

**Fix:** Ensure each source driving a Merge block is either an enabled subsystem, an action subsystem, or a block without an InitialConditions function.

#### Block must not have a virtual Bus Selector block as its source

**Why:** When a virtual Bus Selector feeds a Merge block, the selected bus elements produce scattered variable accesses in the generated code. SLCI expects the Merge block's input to be a single contiguous signal write, not a collection of individually selected bus elements.

**Fix:** Remove the virtual Bus Selector between the bus source and the Merge block, or convert to a non-virtual bus by defining a `Simulink.Bus` object and using a Bus Selector that outputs the full bus structure.

#### InputPortOffsets must be `[]`

**Why:** Non-empty `InputPortOffsets` enable partial writes into the merged output at specific offsets. This produces index-offset assignments in the generated code that SLCI cannot map to the Merge block's simple conditional-write semantics. With `[]`, all inputs write to the entire output without offset arithmetic.

**Fix:**
```matlab
set_param('model/Merge', 'InputPortOffsets', '[]');
```

#### InitialOutput must not be nonfinite or complex

**Why:** SLCI resolves the Merge block's `InitialOutput` at analysis time to verify the initialization assignment. Nonfinite values (`Inf`, `NaN`) require runtime special constants defined outside the model code. Complex values produce paired `.re`/`.im` assignments violating Universal Constraint 1.2.

**Fix:**
```matlab
set_param('model/Merge', 'InitialOutput', '0');
```

#### AllowUnequalInputPortWidths must not be selected

**Why:** When inputs have unequal widths, the Merge buffer is sized to the maximum input width. Smaller inputs only write a subset of the buffer, leaving stale data in the remaining elements. SLCI expects the Merge to produce a uniform conditional assignment where each path writes the entire output — partial writes break this assumption.

**Fix:**
```matlab
set_param('model/Merge', 'AllowUnequalInputPortWidths', 'off');
```

---

## 56. Mux — Nonfatal

**Block:** simulink/Signal Routing/Mux

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | No block-specific constraints | N/A |

---

## 73. Signal Conversion — Nonfatal

**Block:** simulink/Signal Attributes/Signal Conversion

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | Output (`ConversionOutput`) must be set to `Signal copy` | Nonfatal |
| Block Parameters | Exclude this block from 'Block reduction' optimization (`OverrideOpt`) must be selected (set to `on`) | Nonfatal |

### Constraint Details

#### ConversionOutput must be `Signal copy` and OverrideOpt must be `on`

**Why:** SLCI requires each non-virtual block to produce traceable code in the output. When `ConversionOutput` is not `Signal copy` or `OverrideOpt` is off, the block reduction optimization may eliminate the Signal Conversion block entirely, leaving no code to trace.

**Fix:**
```matlab
set_param('model/Signal Conversion', 'ConversionOutput', 'Signal copy');
set_param('model/Signal Conversion', 'OverrideOpt', 'on');
```

---

## 85. Switch — Nonfatal

**Block:** simulink/Signal Routing/Switch

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | First and third input ports and output port must have the same data type | Nonfatal |
| Data Types and Ports | If control signal data type is `int64`/`uint64`, Threshold value must have same data type | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be set to `Zero` or `Floor` | Nonfatal |
| Block Parameters | Allow different data input sizes (`AllowDiffInputSizes`) must not be selected (set to `off`) | Nonfatal |

### Constraint Details

#### First and third input ports and output port must have the same data type

**Why:** When data input ports (ports 1 and 3) and the output have different types, the code generator inserts implicit type casts in one or both branches. The Switch block represents signal routing, not type conversion. The casts have no model-level counterpart.

**Fix:** Ensure ports 1, 3, and output use the same data type. Use Data Type Conversion blocks before the Switch if needed.

#### int64/uint64 control signal: Threshold must have same data type

**Why:** When the control port (port 2) is `int64`/`uint64`, a type mismatch in the threshold produces platform-dependent implicit promotion in the comparison expression. SLCI requires exact type match for 64-bit comparisons to ensure deterministic, verifiable code.

**Fix:** Ensure the Switch threshold parameter uses the same 64-bit type as the control signal (e.g., `int64(0)` for `int64` control input).

#### Integer rounding mode must be `Zero` or `Floor`

**Why:** The Switch uses rounding when comparing the control input against the threshold. Non-standard rounding modes produce conditional correction code SLCI cannot trace. Same pattern as Gain block.

**Fix:**
```matlab
set_param('model/Switch', 'RndMeth', 'Zero');
```

#### AllowDiffInputSizes must not be selected

**Why:** Variable-size signals require runtime size tracking code (dimension variables, `memcpy` with computed sizes) that has no model-level counterpart. SLCI expects the Switch block to produce a fixed-size if/else assignment pattern. Variable-size output introduces size bookkeeping that cannot be traced to the Switch block.

**Fix:**
```matlab
set_param('model/Switch', 'AllowDiffInputSizes', 'off');
```

---

## 55. Multiport Switch — Nonfatal

**Block:** Multiport Switch (simulink/Signal Routing/Multiport Switch)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Data input and output ports must have the same data type | Nonfatal |
| Block Parameters | If data port indices are specified, there can be only one value per input | Nonfatal |
| Block Parameters | Data port signals must be contiguous | Nonfatal |
| Block Parameters | Data port signal must not be connected to a block that selects or reorders input signals | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be set to `Zero` or `Floor` | Nonfatal |
| Block Parameters | Allow different data input sizes (`AllowDiffInputSizes`) must not be selected (set to `off`) | Nonfatal |

### Constraint Details

#### Data input and output ports must have the same data type

**Why:** When data input ports and the output port have different types, the code generator inserts implicit type casts in each case branch. SLCI expects the Multiport Switch to produce direct pass-through assignments. The casts have no model-level counterpart since the block represents signal routing, not type conversion.

**Fix:**
```matlab
set_param('model/Multiport Switch', 'OutDataTypeStr', 'Inherit: Inherit via internal rule');
```

#### Integer rounding mode must be `Zero` or `Floor`

**Why:** The Multiport Switch uses rounding when converting the control input to an index. Non-standard rounding modes (e.g., Nearest) produce conditional rounding correction code that SLCI cannot trace. Same pattern as Gain S40.

**Fix:**
```matlab
set_param('model/Multiport Switch', 'RndMeth', 'Zero');
```

#### AllowDiffInputSizes must not be selected

**Why:** Different input sizes require variable-size output handling with runtime dimension tracking that has no model-level counterpart. Same pattern as Switch S85.

**Fix:**
```matlab
set_param('model/Multiport Switch', 'AllowDiffInputSizes', 'off');
```

#### If data port indices are specified, there can be only one value per input

**Why:** When multiple index values are mapped to the same data port, the code generator produces fall-through case statements. SLCI expects exactly one index value to select exactly one data port input. Fall-through cases create an ambiguous many-to-one mapping that SLCI cannot reconcile.

**Fix:**
```matlab
% Use one value per data port index
set_param('model/Multiport Switch', 'DataPortIndices', '1,2,3');
```

#### Data port signal must not be connected to a block that selects or reorders

**Why:** When a Selector or reordering block feeds into a Multiport Switch data port, the intermediate variable contains reordered data that SLCI cannot directly trace from the original source signal. SLCI expects each data port input to correspond directly to a model signal without intermediate reordering.

**Fix:** Remove the Selector or signal reordering block between the source and the Multiport Switch data port. If reordering is needed, apply it after the switch.

#### Data port signals must be contiguous

**Why:** Non-contiguous data port signals require index remapping logic in the generated code. SLCI expects a direct switch/case statement where case values map sequentially to data ports. Non-contiguous indices produce if/else chains or sparse switch statements that SLCI cannot verify against the block's port configuration.

**Fix:** Ensure data port indices are contiguous (e.g., 1, 2, 3 rather than 1, 5, 10).

----

Copyright 2026 The MathWorks, Inc.

----
