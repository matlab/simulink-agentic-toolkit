# Block Support Constraints: Math Operations

Blocks in this category perform mathematical computations including arithmetic, algebraic functions, rounding, and matrix operations.

---

## 2. Abs — Nonfatal

**Block:** simulink/Math Operations/Abs

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input and output ports must have the same data type | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be set to `Zero` or `Floor` | Nonfatal |

### Constraint Details

#### Input and output ports must have the same data type

**Why:** When input and output data types differ, the code generator inserts implicit type casts around the absolute value operation. SLCI expects the Abs block to produce a direct negation-and-comparison pattern without additional conversion code. The cast has no model-level counterpart.

**Fix:**
```matlab
set_param('model/Abs', 'OutDataTypeStr', 'Inherit: Same as input');
```

#### Integer rounding mode must be `Zero` or `Floor`

**Why:** Non-standard rounding modes (Ceiling, Nearest, Convergent) produce additional conditional rounding correction code that has no corresponding model element. SLCI can only trace `Floor` (default C truncation) and `Zero` because they map to native C behavior without extra code.

**Fix:**
```matlab
set_param('model/Abs', 'RndMeth', 'Zero');
```

---

## 6. Bias — Nonfatal

**Block:** simulink/Math Operations/Bias

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input and output ports must have the same data type | Nonfatal |
| Data Types and Ports | If input is `int64`/`uint64`, Bias value must have same data type as input | Nonfatal |
| Block Parameters | Bias (`Bias`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |

### Constraint Details

#### Input and output ports must have the same data type

**Why:** When input and output types differ, the Bias block's addition produces an implicit cast that SLCI cannot trace. The block represents `y = u + bias` — a type conversion on top of that has no model counterpart.

**Fix:**
```matlab
set_param('model/Bias', 'OutDataTypeStr', 'Inherit: Same as input');
```

#### int64/uint64 Bias value must have same data type as input

**Why:** For 64-bit integer types, a type mismatch between the bias parameter and the input signal produces platform-dependent implicit promotion or truncation code. SLCI requires an exact type match for 64-bit operations to ensure deterministic, verifiable code.

**Fix:** Ensure the Bias parameter workspace variable has the same 64-bit type as the input signal (e.g., `int64(5)` for `int64` input).

#### Bias parameter must not be empty, nonfinite, or complex

**Why:** SLCI resolves block parameters at analysis time to verify that the generated code matches the model. Empty, nonfinite (Inf/NaN), or complex bias values cannot be resolved to a concrete C constant, preventing SLCI from verifying the addition operation in the generated code.

**Fix:**
```matlab
set_param('model/Bias', 'Bias', '5.0');  % Use a finite, real scalar
```

---

## 30. Dot Product — Nonfatal

**Block:** simulink/Math Operations/Dot Product

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input ports must be scalars, vectors, or single-column matrices | Nonfatal |
| Data Types and Ports | Input port data types must be `single` or `double` | Nonfatal |
| Data Types and Ports | Input and output ports must have the same data type | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be set to `Zero` or `Floor` | Nonfatal |

### Constraint Details

#### Input port data types must be `single` or `double`

**Why:** The Dot Product computes a sum of element-wise products. Integer inputs would require overflow handling and rounding in the accumulation loop, producing saturation/rounding code SLCI cannot trace. Floating-point types produce a clean multiply-accumulate pattern.

**Fix:** Ensure inputs are `single` or `double`. Use Data Type Conversion before the Dot Product if needed.

#### Input and output ports must have the same data type

**Why:** A type mismatch between inputs/output inserts implicit casts in the multiply-accumulate code that SLCI cannot attribute to the Dot Product block.

**Fix:**
```matlab
set_param('model/Dot Product', 'OutDataTypeStr', 'Inherit: Same as input');
```

#### Integer rounding mode must be `Zero` or `Floor`

**Why:** Same pattern as Gain. Non-standard rounding modes produce conditional correction code in the accumulation that SLCI cannot trace.

**Fix:**
```matlab
set_param('model/Dot Product', 'RndMeth', 'Zero');
```

#### Input ports must be scalars, vectors, or single-column matrices

**Why:** Multi-column matrix inputs produce nested loops with 2-D index arithmetic that SLCI cannot map back to the Dot Product block's single-operation semantics. With vector or single-column inputs, the code generates a flat multiply-accumulate pattern that directly corresponds to the block.

**Fix:** Reshape multi-column matrix inputs to vectors before connecting to the Dot Product block.

---

## 40. Gain — Nonfatal

**Block:** simulink/Math Operations/Gain

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input and output ports must have the same data type | Nonfatal |
| Data Types and Ports | If input is `int64`/`uint64`, Gain value must have same data type as input | Nonfatal |
| Block Parameters | Gain (`Gain`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |
| Block Parameters | Parameter data type (`ParamDataTypeStr`) must use same data type as Gain block input | Nonfatal |
| Block Parameters | Multiplication (`Multiplication`) must be `Element-wise(K.*u)`, `Matrix(K*u)`, `Matrix(u*K)`, or `Matrix(K*u)(u vector)`. Matrix modes support only `single`/`double` | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be set to `Zero` or `Floor` | Nonfatal |
| Block Parameters | Sample Time (`SampleTime`) must not be set to a constant sample time | Nonfatal |

### Constraint Details

#### Input and output ports must have the same data type

**Why:** When input and output types differ, the Gain block's multiplication produces an implicit cast. SLCI expects `y = u * K` as a single operation — a type conversion layered on top creates code with no model counterpart.

**Fix:**
```matlab
set_param('model/Gain', 'OutDataTypeStr', 'Inherit: Same as input');
```

#### int64/uint64 Gain value must have same data type as input

**Why:** For 64-bit integer types, a type mismatch between the Gain parameter and input produces platform-dependent promotion or truncation. SLCI requires exact type match for deterministic, verifiable 64-bit multiplication code.

**Fix:** Use a gain value with the same 64-bit type (e.g., `int64(3)` for `int64` input).

#### Gain parameter must not be empty, nonfinite, or complex

**Why:** SLCI resolves the Gain parameter at analysis time to verify the multiplication constant in the generated code. Empty, nonfinite, or complex values cannot be mapped to concrete C multiplication operands.

**Fix:**
```matlab
set_param('model/Gain', 'Gain', '3.0');
```

#### ParamDataTypeStr must match input data type

**Why:** When the gain parameter data type differs from the input signal type, the code generator inserts a cast on the gain constant before multiplication. SLCI expects the gain to appear as a same-type literal in the multiplication expression.

**Fix:**
```matlab
set_param('model/Gain', 'ParamDataTypeStr', 'Inherit: Same as input');
```

#### Multiplication mode constraints

**Why:** The supported modes (`Element-wise(K.*u)`, `Matrix(K*u)`, `Matrix(u*K)`, `Matrix(K*u)(u vector)`) produce predictable code patterns SLCI can verify. Matrix modes require `single`/`double` because integer matrix multiplication needs overflow handling. Unsupported modes or integer matrix multiplication produce code patterns SLCI cannot trace.

**Fix:**
```matlab
set_param('model/Gain', 'Multiplication', 'Element-wise(K.*u)');
```

#### Integer rounding mode (`RndMeth`) must be `Zero` or `Floor`

**Why:** Non-standard rounding modes (Ceiling, Nearest, Convergent) produce additional conditional rounding correction code after the multiplication. This rounding logic has no corresponding model element — the Gain block only represents "multiply by K". SLCI can trace `Zero` (default C truncation toward zero) and `Floor` because they map to native C integer division behavior without extra conditional correction code.

**Fix:**
```matlab
set_param('model/Gain', 'RndMeth', 'Zero');
```

#### Sample Time must not be constant

**Why:** When a Gain block has a constant sample time (`Inf`), the code generator treats its output as constant and may fold the computation into `model_initialize()` or eliminate it entirely. SLCI expects Gain block code to appear in `model_step()` as a multiplication operation.

**Fix:**
```matlab
set_param('model/Gain', 'SampleTime', '-1');  % inherited sample time
```

---

## 50. Math Function — Nonfatal

**Block:** simulink/Math Operations/Math Function

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input and output ports must have the same data type | Nonfatal |
| Block Parameters | Function (`Operator`) must be: `exp`, `log`, `10^u`, `log10`, `magnitude^2`, `square`, `transpose`, `pow`, `reciprocal`, `hypot`, `rem`, or `mod`. Cannot select `conj` or `hermitian` | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be set to `Zero` or `Floor` | Nonfatal |

### Constraint Details

#### Input and output ports must have the same data type

**Why:** Type mismatch between input and output inserts implicit casts around the math function call. SLCI expects a direct `func(u)` pattern without conversion code.

**Fix:**
```matlab
set_param('model/Math Function', 'OutDataTypeStr', 'Inherit: Same as input');
```

#### Function cannot be `conj` or `hermitian`

**Why:** The `conj` (complex conjugate) and `hermitian` (conjugate transpose) operators require complex number support. Since SLCI does not support complex signals (Universal Constraint 1.2), these operations cannot produce verifiable code.

**Fix:**
```matlab
set_param('model/Math Function', 'Operator', 'square');  % or another supported function
```

#### Integer rounding mode must be `Zero` or `Floor`

**Why:** Same pattern as Gain. Non-standard rounding modes produce additional conditional rounding correction code that SLCI cannot trace to the Math Function block.

**Fix:**
```matlab
set_param('model/Math Function', 'RndMeth', 'Zero');
```

---

## 52. MinMax — Nonfatal

**Block:** simulink/Math Operations/MinMax

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input and output ports must be `double`, `single`, `int8`, `uint8`, `int16`, `uint16`, `int32`, `uint32`, `int64`, or `uint64` | Nonfatal |
| Data Types and Ports | Input and output ports must have the same data type | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be set to `Zero` or `Floor` | Nonfatal |
| Block Parameters | Apply over (`CollapseMode`) must be set to `All dimensions` | Nonfatal |
| Other | If block has vector input, either: a Demux block must separate the input vector into multiple signals, OR Language standard must be set to `C89/C90 (ANSI)` | Nonfatal |

### Constraint Details

#### Input and output ports must be supported types and same data type

**Why:** MinMax performs comparison operations. Only standard numeric types produce deterministic comparison code. Type mismatches insert implicit casts around comparisons that SLCI cannot trace.

**Fix:**
```matlab
set_param('model/MinMax', 'OutDataTypeStr', 'Inherit: Same as input');
```

#### Integer rounding mode must be `Zero` or `Floor`

**Why:** Same pattern as Gain. Non-standard rounding modes produce conditional correction code SLCI cannot trace to the MinMax block.

**Fix:**
```matlab
set_param('model/MinMax', 'RndMeth', 'Zero');
```

#### Vector input requires Demux or C89/C90 Language standard

**Why:** When a MinMax block has a single vector input (reduction mode), the code generated depends on the language standard. With C99, the code generator may use `fmin`/`fmax` library functions that SLCI cannot trace. With C89/C90 or with a Demux splitting the vector into separate input ports, the code produces explicit if-else comparison patterns that SLCI can verify.

**Fix:** Either add a Demux before MinMax to create separate input ports, or set:
```matlab
set_param('model', 'TargetLangStandard', 'C89/C90 (ANSI)');
```

#### CollapseMode must be `All dimensions`

**Why:** Dimension-specific collapse produces multi-dimensional loop structures with complex index arithmetic. SLCI maps the MinMax block to a single comparison-accumulation operation. Nested loops with dimension-specific indexing cannot be traced back to the block's single-operation semantics.

**Fix:**
```matlab
set_param('model/MinMax', 'CollapseMode', 'All dimensions');
```

---

## 58. Polynomial — Nonfatal

**Block:** simulink/Math Operations/Polynomial

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input and output ports must have the same data type | Nonfatal |
| Data Types and Ports | Input port data types must be `single` or `double` | Nonfatal |
| Block Parameters | Number of coefficients for Polynomial Coefficients (`coefs`) must be greater than zero | Nonfatal |

### Constraint Details

#### Input port data types must be `single` or `double`

**Why:** Polynomial evaluation uses repeated multiplication and addition (Horner's method). Integer inputs would require overflow handling at each stage, producing saturation code SLCI cannot trace. Floating-point types produce a clean multiply-add chain.

**Fix:** Ensure the input is `single` or `double`. Use Data Type Conversion before the Polynomial block if needed.

#### Input and output ports must have the same data type

**Why:** Type mismatch inserts an implicit cast after polynomial evaluation that SLCI cannot attribute to the Polynomial block.

**Fix:**
```matlab
set_param('model/Polynomial', 'OutDataTypeStr', 'Inherit: Same as input');
```

#### Polynomial Coefficients must have at least one coefficient

**Why:** An empty coefficient array means the Polynomial block has no defined computation. SLCI cannot verify code equivalence for a block with undefined behavior — the generated code would either be optimized away or produce a zero output with no traceable computation.

**Fix:**
```matlab
set_param('model/Polynomial', 'coefs', '[1 2 3]');  % p(x) = x^2 + 2x + 3
```

---

## 61. Product — Nonfatal

**Block:** simulink/Math Operations/Product

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input and output ports must have the same data type | Nonfatal |
| Block Parameters | Number of inputs (`inputs`) must be `2`, `**`, `/*`, `*/`, `//`, or `/` when inport is matrix and Multiplication is `Matrix(*)` | Nonfatal |
| Block Parameters | If Multiplication is `Matrix(*)`, Saturate on integer overflow (`SaturateOnIntegerOverflow`) must be cleared (set to `off`) | Nonfatal |
| Block Parameters | If Multiplication is `Element-wise(.*)` and inport is vector/matrix, Number of inputs must not be `1`, `*`, or `/` | Nonfatal |
| Block Parameters | If Multiplication is `Element-wise(.*)` and inport is scalar, Number of inputs must be `1`, `*`, or `/` | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be set to `Zero` or `Floor` | Nonfatal |
| Block Parameters | Sample Time (`SampleTime`) must not be set to a constant sample time | Nonfatal |

### Constraint Details

#### Input and output ports must have the same data type

**Why:** Type mismatch inserts implicit casts around multiplication/division that SLCI cannot attribute to the Product block.

**Fix:**
```matlab
set_param('model/Product', 'OutDataTypeStr', 'Inherit: Same as input');
```

#### Number of inputs constraints for Matrix and Element-wise modes

**Why:** For `Matrix(*)` mode with matrix inputs, the `inputs` parameter must be `2`, `**`, `/*`, `*/`, `//`, or `/` — these produce predictable two-operand matrix multiply/divide patterns. For `Element-wise(.*)` with vector/matrix inputs, single-operand modes (`1`, `*`, `/`) are not allowed because they produce reduction operations with loop-based accumulation. For scalar inputs in element-wise mode, only single-operand modes are allowed since multi-port scalar multiplication is handled differently.

**Fix:**
```matlab
% For matrix multiplication
set_param('model/Product', 'Multiplication', 'Matrix(*)');
set_param('model/Product', 'Inputs', '**');

% For element-wise with vectors
set_param('model/Product', 'Multiplication', 'Element-wise(.*)');
set_param('model/Product', 'Inputs', '**');
```

#### SaturateOnIntegerOverflow must be cleared for Matrix multiplication

**Why:** Saturation guards produce overflow checking code around matrix multiply-accumulate operations that has no model-level counterpart.

**Fix:**
```matlab
set_param('model/Product', 'SaturateOnIntegerOverflow', 'off');
```

#### Integer rounding mode must be `Zero` or `Floor`

**Why:** Same pattern as Gain. Non-standard rounding modes produce rounding correction code that SLCI cannot trace to the Product block.

**Fix:**
```matlab
set_param('model/Product', 'RndMeth', 'Zero');
```

#### Sample Time must not be constant

**Why:** Constant sample time causes computation to be folded into `model_initialize()`, removing the Product operation from `model_step()`.

**Fix:**
```matlab
set_param('model/Product', 'SampleTime', '-1');
```

---

## 67. Rounding Function — Nonfatal

**Block:** simulink/Math Operations/Rounding Function

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | No block-specific constraints | N/A |

---

## 76. Sqrt — Nonfatal

**Block:** simulink/Math Operations/Sqrt

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Block inputs and outputs must have the same data type | Nonfatal |
| Data Types and Ports | Block inputs and outputs data types must be `single` or `double` | Nonfatal |
| Block Parameters | Function (`Operator`) must be `sqrt` or `signedSqrt` | Nonfatal |
| Block Parameters | Output signal type (`OutputSignalType`) must not be set to `complex` | Nonfatal |
| Block Parameters | Intermediate results (`IntermediateResultsDataTypeStr`) must be same as input, `Inherit: Inherit via internal rule`, `Inherit: Inherit from input`, or `Inherit: Inherit from output` | Nonfatal |

### Constraint Details

#### Block inputs and outputs must have the same data type

**Why:** Type mismatch around the sqrt operation inserts implicit casts that SLCI cannot attribute to the Sqrt block.

**Fix:**
```matlab
set_param('model/Sqrt', 'OutDataTypeStr', 'Inherit: Same as input');
```

#### Block inputs and outputs must be `single` or `double`

**Why:** The `sqrt()` function is a floating-point operation. Integer inputs would require conversion before calling sqrt and conversion after, producing cast code with no model counterpart. Only floating-point types produce the direct `sqrt(u)` call SLCI verifies.

**Fix:** Ensure the input signal is `single` or `double`.

#### Function must be `sqrt` or `signedSqrt`

**Why:** The `rSqrt` (reciprocal square root, `1/sqrt(u)`) operator produces a division wrapping the sqrt call. This combined operation generates code where the division has no separate model element. SLCI expects a single `sqrt()` call traceable to the block. `sqrt` and `signedSqrt` both produce direct `sqrt()` calls.

**Fix:**
```matlab
set_param('model/Sqrt', 'Operator', 'sqrt');
```

#### IntermediateResultsDataTypeStr must inherit from input/output

**Why:** Mismatched intermediate result types produce implicit casts within the sqrt computation pipeline. SLCI expects a single-type computation without internal type conversions.

**Fix:**
```matlab
set_param('model/Sqrt', 'IntermediateResultsDataTypeStr', 'Inherit: Inherit via internal rule');
```

#### OutputSignalType must not be `complex`

**Why:** Complex output from Sqrt would violate Universal Constraint 1.2 (no complex signals). Complex sqrt produces paired `.re`/`.im` assignments that SLCI cannot verify.

**Fix:**
```matlab
set_param('model/Sqrt', 'OutputSignalType', 'real');
```

---

## 84. Sum, Add, Subtract — Nonfatal

**Block:** simulink/Math Operations/Sum

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input and output ports must have the same data type | Nonfatal |
| Block Parameters | Sum over (`CollapseMode`) must be set to `All dimensions` | Nonfatal |
| Block Parameters | Accumulator data type (`AccumDataTypeStr`) must use same data type as block inputs | Nonfatal |
| Block Parameters | Sample Time (`SampleTime`) must not be set to a constant sample time | Nonfatal |
| Block Parameters | For blocks with one vector input, Saturate on integer overflow (`SaturateOnIntegerOverflow`) must be cleared (set to `off`) | Nonfatal |

### Constraint Details

#### Input and output ports must have the same data type

**Why:** Type mismatch between inputs/output inserts implicit casts around the addition that SLCI cannot attribute to the Sum block.

**Fix:**
```matlab
set_param('model/Sum', 'OutDataTypeStr', 'Inherit: Same as input');
```

#### Sample Time must not be constant

**Why:** Constant sample time folds the sum into initialization, removing it from `model_step()`.

**Fix:**
```matlab
set_param('model/Sum', 'SampleTime', '-1');
```

#### SaturateOnIntegerOverflow must be cleared for single vector input

**Why:** When a Sum block has one vector input (reduction sum), overflow saturation guards produce conditional checks that SLCI cannot trace to the Sum block.

**Fix:**
```matlab
set_param('model/Sum', 'SaturateOnIntegerOverflow', 'off');
```

#### CollapseMode must be `All dimensions`

**Why:** When collapsing over a specific dimension, the code generator produces multi-dimensional loop structures with complex indexing patterns. SLCI's verification maps the Sum block to a single accumulation operation. Dimension-specific collapse creates nested loops with index arithmetic that SLCI cannot trace back to the Sum block's single-operation semantics.

**Fix:**
```matlab
set_param('model/Sum', 'CollapseMode', 'All dimensions');
```

#### AccumDataTypeStr must match input data type

**Why:** A mismatched accumulator type forces type casts before and after the addition. These casts are code-generation artifacts with no model-level element — the Sum block shows a direct addition, but the code contains cast operations that SLCI cannot attribute to any block.

**Fix:**
```matlab
set_param('model/Sum', 'AccumDataTypeStr', 'Inherit: Same as first input');
```

---

## 92. Unary Minus — Nonfatal

**Block:** simulink/Math Operations/Unary Minus

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input port data types must be `double`, `single`, `int8`, `int16`, or `int32` | Nonfatal |
| Block Parameters | No block-specific constraints | N/A |

### Constraint Details

#### Input port data types must be `double`, `single`, `int8`, `int16`, or `int32`

**Why:** The Unary Minus block produces `-u` in generated code. Unsigned types cannot represent negative values — negating them produces undefined or wrapped behavior requiring additional overflow handling code. `int64`/`uint64` are excluded because 64-bit negation may require platform-specific handling. Only signed integers and floating-point types produce the simple `-u` pattern SLCI expects.

**Fix:** Use a signed integer or floating-point data type for the input signal. Add a Data Type Conversion block before the Unary Minus if needed.

---

## 93. Unit Conversion — Nonfatal

**Block:** simulink/Signal Attributes/Unit Conversion

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input port data types must be `double` or `single` | Nonfatal |
| Data Types and Ports | Input and output ports must have the same data type | Nonfatal |

### Constraint Details

#### Input port data types must be `double` or `single`

**Why:** Unit Conversion applies a scale-and-offset transformation (`y = a*u + b`) for unit conversion. Integer inputs would require rounding after the floating-point scale/offset computation, producing rounding code SLCI cannot trace. Only floating-point types produce the clean multiply-add pattern SLCI verifies.

**Fix:** Ensure the input signal is `double` or `single`. Use Data Type Conversion before the Unit Conversion block if needed.

#### Input and output ports must have the same data type

**Why:** When input and output types differ, an implicit cast is inserted around the unit conversion computation that SLCI cannot attribute to the Unit Conversion block.

**Fix:**
```matlab
set_param('model/Unit Conversion', 'OutDataTypeStr', 'Inherit: Same as input');
```

----

Copyright 2026 The MathWorks, Inc.

----
