# Block Support Constraints: Logic and Bit Operations

Blocks in this category perform logical operations, bitwise operations, bit extraction, relational comparisons, and combinatorial logic.

---

## 7. Bitwise Operator — Nonfatal

**Block:** simulink/Logic and Bit Operations/Bitwise Operator

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | If `NumInputPorts` is 1 and `logicop` is AND/OR/NAND/NOR/XOR, inport data type must be scalar. If `Usebitmask` is selected, cannot specify `NumInputPorts` | Nonfatal |
| Block Parameters | No block-specific constraints | N/A |

### Constraint Details

#### Single input with logical operation must be scalar

**Why:** When a single-port Bitwise Operator with a logical operation (AND/OR/etc.) receives a vector input, it performs a reduction operation across all elements. This produces a loop-based accumulation pattern that SLCI cannot map to the block's single-operation semantics. With scalar input, the operation is a single bitwise instruction that directly corresponds to the block.

**Fix:**
Use a Demux before the Bitwise Operator to split vectors into scalars, or use multiple input ports instead of single-port reduction.

---

## 12. Combinatorial Logic — Nonfatal

**Block:** simulink/Logic and Bit Operations/Combinatorial Logic

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | No block-specific constraints | N/A |

---

## 33. Extract Bits — Nonfatal

**Block:** simulink/Logic and Bit Operations/Extract Bits

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input port data type must be `uint16`, `int16`, `uint32`, `int32`, `uint64`, `int64`, `single`, or `double` | Nonfatal |
| Block Parameters | Number of bits (`NumBits`) must be 8, 16, 32, or 64, and not more than input signal size | Nonfatal |
| Block Parameters | Output scaling mode (`outScalingMode`) must be set to `Treat bit field as an integer` | Nonfatal |
| Block Parameters | Bit indices (`bitIdxRange`) must specify a range [start end] with bit length of 8, 16, 32, or 64 | Nonfatal |

### Constraint Details

#### Input port data type must be supported integer, `single`, or `double`

**Why:** Extract Bits performs bit-level manipulation (shift and mask). Only standard integer types (`int16`, `uint16`, `int32`, `uint32`, `int64`, `uint64`) and floating-point types (`single`, `double`) produce deterministic shift/mask code patterns that SLCI can verify. Smaller types (`int8`, `uint8`) are not supported because extraction from 8-bit values would produce sub-byte fields that don't map to C types.

**Fix:**
Ensure the input signal uses a supported type (at least 16 bits wide).

#### bitIdxRange must specify a range with bit length of 8, 16, 32, or 64

**Why:** The bit range must span exactly 8, 16, 32, or 64 bits so that the extracted field maps to a standard C integer type with a simple shift. Non-standard ranges require additional masking that SLCI cannot trace to the block.

**Fix:**
```matlab
set_param('model/Extract Bits', 'bitIdxRange', '[16 31]');  % 16-bit range
```

#### NumBits must be 8, 16, 32, or 64

**Why:** SLCI maps Extract Bits to a shift operation that produces a standard C integer type. When the number of bits is 8, 16, 32, or 64, the result naturally fits a C type (`uint8_T`, `uint16_T`, etc.) with a simple shift. Non-standard bit widths require additional masking operations that SLCI cannot attribute to the block.

**Fix:**
```matlab
set_param('model/Extract Bits', 'NumBits', '16');
```

#### outScalingMode must be `Treat bit field as an integer`

**Why:** When `outScalingMode` is not set to `Treat bit field as an integer`, the output may require fixed-point scaling conversion code applied to the extracted bits. This produces multiplication by a scaling factor that has no corresponding model element. Integer treatment ensures the extracted bits are output directly as an integer value with a simple shift operation.

**Fix:**
```matlab
set_param('model/Extract Bits', 'outScalingMode', 'Treat bit field as an integer');
```

---

## 48. Logical Operator — Nonfatal

**Block:** simulink/Logic and Bit Operations/Logical Operator

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Output ports must be `boolean` or `uint8` | Nonfatal |
| Data Types and Ports | Block input ports must have the same data type | Nonfatal |
| Data Types and Ports | For `boolean` type operands, Casting modes must be set to `Nominal` | Nonfatal |
| Block Parameters | No block-specific constraints | N/A |

### Constraint Details

#### Block input ports must have the same data type

**Why:** When input ports have different data types, the code generator inserts implicit type coercion (e.g., `!= 0` comparisons) to normalize inputs to boolean before applying the logical operation. SLCI expects a direct logical operation on homogeneous operands. The coercion code has no model-level counterpart.

**Fix:**
Ensure all inputs to the Logical Operator have the same data type. Use Data Type Conversion blocks to make types consistent before the Logical Operator.

#### For boolean operands, Casting modes must be set to `Nominal`

**Why:** When casting modes are not `Nominal` for boolean-type operands, the code generator may insert range-checking or saturation logic when converting between boolean and the internal logical representation. With `Nominal` mode, boolean values are used directly as 0/1 without additional checks, producing the simple `&&`/`||` pattern SLCI expects.

**Fix:**
Set the casting mode through the model's data type override settings to use `Nominal` for boolean types.

#### Output must be `boolean` or `uint8`

**Why:** Logical operations naturally produce boolean results in C. When the output type is not `boolean` or `uint8`, the code generator inserts type cast operations that have no model-level counterpart. SLCI expects logical operations to produce boolean/uint8 results without additional conversion code.

**Fix:**
```matlab
set_param('model/Logical Operator', 'OutDataTypeStr', 'boolean');
```

---

## 64. Relational Operator — Nonfatal

**Block:** simulink/Logic and Bit Operations/Relational Operator

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Block output port data type must be enumerated type with default value 0, or `boolean` | Nonfatal |
| Data Types and Ports | Block input ports must have the same data type | Nonfatal |
| Block Parameters | Relational operator (`Operator`) must be `<=`, `==`, `>=`, `~=`, `<`, or `>` (not `isInf`, `isNaN`, or `isFinite`) | Nonfatal |

### Constraint Details

#### Output port data type must be enum with default value 0, or `boolean`

**Why:** Relational comparisons naturally produce boolean results in C. When the output type is not `boolean` or a supported enumerated type (with default 0), the code generator inserts a type cast that has no model-level counterpart. Enumerated types with default value 0 are supported because they map cleanly to the false/true semantics.

**Fix:**
```matlab
set_param('model/Relational Operator', 'OutDataTypeStr', 'boolean');
```

#### Block input ports must have the same data type

**Why:** When input types differ, the code generator implicitly promotes one operand to match the other (typically to the wider type). This implicit cast has no corresponding model element. SLCI expects a direct comparison between two operands of the same type without additional type promotion code.

**Fix:**
Ensure both inputs have the same data type. Use a Data Type Conversion block to explicitly convert one input before the comparison.

#### Operator must not be `isInf`, `isNaN`, or `isFinite`

**Why:** The `isInf`, `isNaN`, and `isFinite` operators generate calls to runtime utility functions (`rtIsNaN`, `rtIsInf`, `rtIsFinite`) that implement IEEE-754 special value detection. These utility functions contain platform-specific bit manipulation code that SLCI cannot trace to the Relational Operator block's single-comparison semantics.

**Fix:**
```matlab
set_param('model/Relational Operator', 'Operator', '>');
```

----

Copyright 2026 The MathWorks, Inc.

----
