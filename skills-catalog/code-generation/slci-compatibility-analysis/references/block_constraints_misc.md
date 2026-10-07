# Block Support Constraints: Miscellaneous Blocks

Blocks in this category include documentation, multiport switching, bit shifting, sign detection, trigonometric functions, and array concatenation.

---

## 29. DocBlock — N/A

**Block:** DocBlock

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | No block-specific constraints | N/A |

---

## 71. Shift Arithmetic — Nonfatal

**Block:** Shift Arithmetic (simulink/Logic and Bit Operations/Shift Arithmetic)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | Diagnostic for out of range shift value (`DiagnosticForOORShift`) must be set to `Error` | Nonfatal |
| Block Parameters | Binary points to shift (`BinPtShiftNumber`) must be set to `0` | Nonfatal |
| Block Parameters | Bits to shift: Number (`BitShiftNumber`) must be within allowable range of inport data type | Nonfatal |
| Block Parameters | Check for out-of-range 'Bits to shift' in generated code (`CheckOORBitShift`) must not be selected (set to `off`) | Nonfatal |
| Block Parameters | If `DefaultParameterBehavior` is `Inlined`, `BitShiftNumberSource` is `Input port`, and `BitShiftDirection` is `Bidirectional`: source of Inport 2 must not be constant | Nonfatal |
| Other | Loop unrolling threshold (`RollThreshold`) must be greater than `BitShiftNumber` value | Nonfatal |

### Constraint Details

#### CheckOORBitShift must be `off`

**Why:** When out-of-range checking is enabled, the code generator wraps the shift operation in a conditional guard that checks if the shift amount is within the type's bit width. This guard produces code with no corresponding model element. SLCI cannot trace the bounds-checking conditional.

**Fix:**
```matlab
set_param('model/Shift Arithmetic', 'CheckOORBitShift', 'off');
```

#### DiagnosticForOORShift must be `Error`

**Why:** When this diagnostic is set to `None` or `Warning`, the model allows out-of-range shift values to pass silently at simulation time. Out-of-range shifts produce undefined behavior in C (e.g., shifting a 32-bit integer by 32 or more bits). SLCI requires this set to `Error` to guarantee the generated code is always well-defined.

**Fix:**
```matlab
set_param('model/Shift Arithmetic', 'DiagnosticForOORShift', 'Error');
```

#### BinPtShiftNumber must be `0`

**Why:** Binary point shifting is a fixed-point concept that changes the implied decimal position. SLCI does not support fixed-point types (Universal Constraint 1.1). A non-zero binary point shift would produce scaling code that SLCI cannot verify.

**Fix:**
```matlab
set_param('model/Shift Arithmetic', 'BinPtShiftNumber', '0');
```

#### BitShiftNumber must be within allowable range of inport data type

**Why:** If the shift amount exceeds the bit width of the input type (e.g., shifting a `uint16` by 17 bits), the resulting C code has undefined behavior per the C standard. SLCI cannot verify code with undefined behavior since the actual execution result is implementation-dependent.

**Fix:** Ensure the shift amount is less than the bit width of the input signal:
- `int8`/`uint8`: shift must be 0-7
- `int16`/`uint16`: shift must be 0-15
- `int32`/`uint32`: shift must be 0-31

#### Bidirectional with constant Inport 2 (when DefaultParameterBehavior is Inlined)

**Why:** When `DefaultParameterBehavior` is `Inlined` and the shift amount is constant, the code generator constant-folds the bidirectional conditional. SLCI's model analysis expects a bidirectional Shift Arithmetic block to produce direction-checking code. When constant folding removes it, the code structure no longer matches the model structure.

**Fix:** Use a non-constant signal for the shift amount input, or set the shift direction to `Left` or `Right` explicitly instead of `Bidirectional`.

#### RollThreshold must be greater than BitShiftNumber

**Why:** When the loop unrolling threshold is less than or equal to the shift operation count, the code generator rolls repeated operations into a `for` loop. SLCI expects each element-wise operation to appear as an individual statement traceable to the corresponding signal element. A rolled loop introduces index-based access that SLCI cannot map element-by-element.

**Fix:**
```matlab
% Set RollThreshold higher than the vector width
set_param('model', 'RollThreshold', '9');
```

---

## 72. Sign — Nonfatal

**Block:** Sign (simulink/Math Operations/Sign)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | No block-specific constraints | N/A |

---

## 91. Trigonometric Function — Nonfatal

**Block:** Trigonometric Function (simulink/Math Operations/Trigonometric Function)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | Function (`Operator`) must not be set to `cos + jsin` | Nonfatal |
| Block Parameters | Approximation method (`ApproximationMethod`) must be set to `None` | Nonfatal |

### Constraint Details

#### Operator must not be `cos + jsin`

**Why:** The `cos + jsin` operator produces a complex output (Euler's formula: e^(ju) = cos(u) + j*sin(u)). Complex outputs violate Universal Constraint 1.2 and would generate paired real/imaginary assignments that SLCI cannot verify.

**Fix:**
```matlab
set_param('model/Trigonometric Function', 'Operator', 'sin');  % or cos, tan, etc.
```

#### ApproximationMethod must be `None`

**Why:** Approximation methods (CORDIC, Lookup table) replace the standard math library call with iterative algorithms or table-based interpolation code. These produce complex loop structures that SLCI cannot map to the Trigonometric Function block's single-operation semantics. With `None`, the code generator uses a direct library call that SLCI can trace.

**Fix:**
```matlab
set_param('model/Trigonometric Function', 'ApproximationMethod', 'None');
```

---

## 95. Vector Concatenate, Matrix Concatenate — Nonfatal

**Block:** Vector Concatenate / Matrix Concatenate (simulink/Signal Routing)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | No block-specific constraints | Nonfatal |

----

Copyright 2026 The MathWorks, Inc.

----
