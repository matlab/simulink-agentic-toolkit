# Block Support Constraints: Discrete Blocks

Blocks in this category implement discrete-time dynamics including integration, delays, filters, transfer functions, rate limiting, and sample-time math operations.

---

## 21. Discrete-Time Integrator — Nonfatal

**Block:** simulink/Discrete/Discrete-Time Integrator

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input ports data types must be `single` or `double` for non-reset ports | Nonfatal |
| Data Types and Ports | Inports and outports must be scalars | Nonfatal |
| Data Types and Ports | Output ports data types must be `single` or `double` | Nonfatal |
| Block Parameters | Show state port (`ShowStatePort`) must not be selected (set to `off`) | Nonfatal |
| Block Parameters | Upper saturation limit (`UpperSaturationLimit`) must not be empty, non-finite, complex, or use MATLAB structures | Nonfatal |
| Block Parameters | Lower saturation limit (`LowerSaturationLimit`) must not be empty, non-finite, complex, or use MATLAB structures | Nonfatal |
| Other | Block must not be inside: Triggered Subsystem, Function-Call Subsystem, Enabled and Triggered Subsystem, If Action Subsystem, For Iterator Subsystem, For Each Subsystem, While Iterator Subsystem | Nonfatal |
| Other | If `DefaultParameterBehavior` is `Inlined`, source of Inport 2 must not be constant | Nonfatal |
| Other | Block state custom storage class must follow universal storage class rules (Unstructured/FlatStructure, supported types, Data initialization not None) | Nonfatal |
| Other | Block state must not resolve to a signal object with a non-empty `InitialValue` | Nonfatal |

### Constraint Details

#### Input ports data types must be `single` or `double` for non-reset ports

**Why:** The Discrete-Time Integrator performs accumulation (multiply-add with sample time). Integer inputs would require overflow detection, scaling, and rounding logic that SLCI cannot trace. Only floating-point types produce the simple `state += Ts * input` pattern that SLCI verifies.

**Fix:** Ensure the input signal feeding the integrator is `single` or `double`. Use a Data Type Conversion block before the integrator if needed.

#### Inports and outports must be scalars

**Why:** Vector or matrix inputs produce loop-based or unrolled element-wise accumulation patterns. SLCI verifies the integrator as a single-state accumulator. Multi-element signals create multiple state variables and parallel update code that SLCI cannot map to the single integrator block.

**Fix:** Use separate Discrete-Time Integrator blocks for each signal element, or use a Demux to split the vector before integration.

#### Output ports data types must be `single` or `double`

**Why:** Integer output would require rounding and saturation on the accumulated state, producing code patterns SLCI cannot trace to the integrator block.

**Fix:**
```matlab
set_param('model/Discrete-Time Integrator', 'OutDataTypeStr', 'double');
```

#### UpperSaturationLimit and LowerSaturationLimit must not be empty, nonfinite, or complex

**Why:** When the Discrete-Time Integrator has saturation limits, SLCI must resolve them at analysis time to verify the clamping comparisons in the generated code. Empty, nonfinite, or complex values cannot be represented as C comparison literals.

**Fix:**
```matlab
set_param('model/Discrete-Time Integrator', 'UpperSaturationLimit', '100');
set_param('model/Discrete-Time Integrator', 'LowerSaturationLimit', '-100');
```

#### If DefaultParameterBehavior is Inlined, source of Inport 2 must not be constant

**Why:** When `DefaultParameterBehavior` is `Inlined` and the gain input (Inport 2) is fed by a constant, the code generator folds the constant into the sample time multiplication. The gain value disappears from the generated code and SLCI expects the gain input to appear as a separate multiplier in the update equation so it can trace it to Inport 2.

**Fix:** Use a non-constant signal for the gain input, or remove the external gain input and use the block's built-in gain parameter.

#### Block state custom storage class must follow universal storage class rules

**Why:** The integrator's DWork state variable must use a supported storage class (Unstructured or FlatStructure with supported data types and initialization not set to `None`) so that SLCI can locate and verify the state variable in the generated code.

**Fix:** Ensure the state signal object uses a supported storage class configuration.

#### Block state must not resolve to a signal object with non-empty InitialValue

**Why:** When the block state resolves to a signal object that has a non-empty `InitialValue`, the initialization code uses the signal object's value rather than the block's configured initial condition. SLCI verifies initialization against the block's `InitialCondition` parameter, not an external signal object's property.

**Fix:**
```matlab
sig = Simulink.Signal;
sig.InitialValue = '';  % clear to let block parameter take effect
```

#### ShowStatePort must not be selected

**Why:** The state port creates an additional output from the same internal state variable, producing a second assignment from the same DWork state in the generated code. SLCI's traceability expects a one-to-one mapping between the Discrete-Time Integrator block and its code. The state port output creates an ambiguous mapping that confuses SLCI's verification.

**Fix:**
```matlab
set_param('model/Discrete-Time Integrator', 'ShowStatePort', 'off');
```

#### Block must not be inside conditional subsystems

**Why:** Inside conditional subsystems (Triggered, Enabled, Function-Call, etc.), the integrator's output and update code is wrapped in trigger detection or enable guards. This conditional execution context produces zero-crossing detection code and trigger event evaluation that have no direct correspondence to the Discrete-Time Integrator block's model semantics.

**Fix:** Move the Discrete-Time Integrator outside conditional subsystems, or use a simple Unit Delay-based integration pattern inside the conditional subsystem.

---

## 23. Delay, Resettable Delay — Nonfatal

**Block:** simulink/Discrete/Delay, Resettable Delay

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input and output data type must not be `string` | Nonfatal |
| Data Types and Ports | If input is `int64`/`uint64` and `InitialConditionSource` is `Input port`, Initial condition value must have same data type as input | Nonfatal |
| Data Types and Ports | If input is `int64`/`uint64` and `DelayLengthSource` is `Input port`, `DelayLengthUpperLimit` must not be more than 1 | Nonfatal |
| Block Parameters | Input processing (`InputProcessing`) must not be set to `Columns as channels (frame based)` | Nonfatal |
| Block Parameters | Show enable port (`ShowEnablePort`) must not be selected (set to `off`) | Nonfatal |

### Constraint Details

#### Input and output data type must not be `string`

**Why:** String data types produce dynamically-sized character buffers with runtime length tracking. SLCI cannot verify string delay operations because they involve buffer management functions with no structural model-level counterpart.

**Fix:** Use a non-string data type for the signal feeding the Delay block.

#### int64/uint64 with InitialConditionSource from Input port must match types

**Why:** When the Delay block uses `int64`/`uint64` input and the initial condition comes from an input port, the IC signal must have the same type. A type mismatch produces an implicit cast in the initialization code that SLCI cannot trace.

**Fix:** Ensure the initial condition input port signal type matches the data input type.

#### int64/uint64 with DelayLengthSource from Input port: DelayLengthUpperLimit must not exceed 1

**Why:** When the delay length is dynamic (from an input port) and the data type is `int64`/`uint64`, a delay length greater than 1 requires an array of 64-bit states. The code generator produces indexed access patterns into 64-bit arrays that SLCI cannot verify.

**Fix:**
```matlab
set_param('model/Delay', 'DelayLengthUpperLimit', '1');
```

#### InputProcessing must not be `Columns as channels (frame based)`

**Why:** Frame-based processing introduces buffer management code (`memmove`, frame shift, circular buffer indices) that SLCI cannot trace to any model element.

**Fix:**
```matlab
set_param('model/Delay', 'InputProcessing', 'Elements as channels (sample based)');
```

#### ShowEnablePort must not be selected

**Why:** The enable port introduces a conditional execution path within the Delay block's generated code. The enable guard and the "hold" behavior produce an if/else structure that SLCI cannot reconcile with the Delay block's single-path model semantics. SLCI expects the Delay block to always produce a shift-and-store pattern without conditional execution.

**Fix:**
```matlab
set_param('model/Delay', 'ShowEnablePort', 'off');
```

---

## 25. Discrete Derivative — Nonfatal

**Block:** simulink/Discrete/Discrete Derivative

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input port data type must be `single` or `double` | Nonfatal |
| Data Types and Ports | Output data type (`OutDataTypeStr`) must be `single`, `double`, or `Inherit: Inherit via internal rule` | Nonfatal |
| Block Parameters | Input processing (`InputProcessing`) must be set to `Elements as channels (sample based)` | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be set to `Floor` or `Zero` | Nonfatal |

### Constraint Details

#### Input port data type must be `single` or `double`

**Why:** The Discrete Derivative computes `(u - u_prev) / Ts`. Integer inputs would require rounding after the division, producing rounding correction code SLCI cannot trace. Only floating-point types produce the clean difference-and-divide pattern SLCI verifies.

**Fix:** Ensure the input signal is `single` or `double`. Use a Data Type Conversion block before the Discrete Derivative if needed.

#### Output data type must be `single`, `double`, or `Inherit: Inherit via internal rule`

**Why:** Mismatched output types would require an implicit cast after the derivative computation. SLCI expects the output assignment to directly store the computation result without additional type conversion code.

**Fix:**
```matlab
set_param('model/Discrete Derivative', 'OutDataTypeStr', 'Inherit: Inherit via internal rule');
```

#### InputProcessing must be `Elements as channels (sample based)`

**Why:** Frame-based processing introduces buffer management code (memmove, circular indexing) that has no corresponding model element. SLCI expects a simple difference-and-divide pattern traceable to the Discrete Derivative block.

**Fix:**
```matlab
set_param('model/Discrete Derivative', 'InputProcessing', 'Elements as channels (sample based)');
```

#### Integer rounding mode must be `Floor` or `Zero`

**Why:** Non-standard rounding modes produce additional conditional rounding correction code after arithmetic operations that SLCI cannot trace to the Discrete Derivative block.

**Fix:**
```matlab
set_param('model/Discrete Derivative', 'RndMeth', 'Floor');
```

---

## 26. Discrete FIR Filter — Nonfatal

**Block:** simulink/Discrete/Discrete FIR Filter

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Coefficient data type: if input is `single`/`double`, `CoefDataTypeStr` must be `Inherit: Same word length as input`; if input is integer, must be same data type as input | Nonfatal |
| Data Types and Ports | Product output data type: if input is `single`/`double`, `ProductDataTypeStr` must be `Inherit: Inherit via internal rule` or `Inherit: Same as input`; if integer, must be same type or `Inherit: Same as input` | Nonfatal |
| Data Types and Ports | Accumulator data type: if input is `single`/`double`, `AccumDataTypeStr` must be `Inherit: Inherit via internal rule`, `Inherit: Same as input`, or `Inherit: Same as product output`; if integer, same rules apply | Nonfatal |
| Data Types and Ports | Output data type: if input is `single`/`double`, `OutDataTypeStr` must be `Inherit: Same as accumulator` or `Inherit: Same as input`; if integer, same type or inherit | Nonfatal |
| Block Parameters | Filter structure (`FilterStructure`) must be set to `Direct form` | Nonfatal |
| Block Parameters | Input processing (`InputProcessing`) must be set to `Columns as channels (frame based)` | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be set to `Floor` | Nonfatal |
| Block Parameters | Saturate on integer overflow (`SaturateOnIntegerOverflow`) must be cleared (set to `off`) | Nonfatal |

### Constraint Details

#### Coefficient, product, accumulator, and output data types must match input type

**Why:** The Discrete FIR Filter performs multiply-accumulate operations across its coefficient taps. If intermediate data types differ from the input, the code generator inserts type casts between each computation stage. SLCI verifies the FIR filter as a unified multiply-accumulate chain and type casts between stages break this expected pattern.

**Fix:**
```matlab
set_param('model/Discrete FIR Filter', 'CoefDataTypeStr', 'Inherit: Same word length as input');
set_param('model/Discrete FIR Filter', 'ProductDataTypeStr', 'Inherit: Inherit via internal rule');
set_param('model/Discrete FIR Filter', 'AccumDataTypeStr', 'Inherit: Inherit via internal rule');
set_param('model/Discrete FIR Filter', 'OutDataTypeStr', 'Inherit: Same as accumulator');
```

#### InputProcessing must be set to `Columns as channels (frame based)`

**Why:** Unlike most other discrete blocks which require sample-based processing, the Discrete FIR Filter requires frame-based processing. In frame mode, the filter processes a column of data as a single channel with history, producing the standard convolution pattern SLCI expects. In sample-based mode, each element is treated as an independent channel, producing parallel filter instances that SLCI cannot map to the single FIR filter block.

**Fix:**
```matlab
set_param('model/Discrete FIR Filter', 'InputProcessing', 'Columns as channels (frame based)');
```

#### Integer rounding mode must be `Floor`

**Why:** Non-Floor rounding modes produce rounding correction code in the accumulator operations that SLCI cannot trace.

**Fix:**
```matlab
set_param('model/Discrete FIR Filter', 'RndMeth', 'Floor');
```

#### SaturateOnIntegerOverflow must be cleared

**Why:** Overflow saturation guards produce conditional checks against `MAX_int32_T`/`MIN_int32_T` that have no corresponding model element.

**Fix:**
```matlab
set_param('model/Discrete FIR Filter', 'SaturateOnIntegerOverflow', 'off');
```

#### FilterStructure must be `Direct form`

**Why:** SLCI's verification maps the FIR filter block to a specific code pattern (multiply-accumulate with state shift). Non-direct-form structures produce different computation orderings and state update patterns that SLCI cannot reconcile with the block's defined filter coefficients.

**Fix:**
```matlab
set_param('model/Discrete FIR Filter', 'FilterStructure', 'Direct form');
```

---

## 27. Discrete Filter — Nonfatal

**Block:** simulink/Discrete/Discrete Filter

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Numerator coefficient data type: if input is `single`/`double`, `NumCoeffDataTypeStr` must be `Inherit: Inherit via internal rule`; if integer, same data type as input | Nonfatal |
| Data Types and Ports | Numerator product output: if input is `single`/`double`, `NumProductDataTypeStr` must be `Inherit: Inherit via internal rule` or `Inherit: Same as input`; if integer, same or inherit | Nonfatal |
| Data Types and Ports | Numerator accumulator: if input is `single`/`double`, `NumAccumDataTypeStr` must be `Inherit: Inherit via internal rule`, `Inherit: Same as input`, or `Inherit: Same as product output`; if integer, same rules | Nonfatal |
| Data Types and Ports | Denominator coefficient data type: if input is `single`/`double`, `DenCoeffDataTypeStr` must be `Inherit: Inherit via internal rule`; if integer, same data type as input | Nonfatal |
| Data Types and Ports | Denominator product output: if input is `single`/`double`, `DenProductDataTypeStr` must be `Inherit: Inherit via internal rule` or `Inherit: Same as input`; if integer, same or inherit | Nonfatal |
| Data Types and Ports | Denominator accumulator: if input is `single`/`double`, `DenAccumDataTypeStr` must be `Inherit: Inherit via internal rule`, `Inherit: Same as input`, or `Inherit: Same as product output`; if integer, same rules | Nonfatal |
| Data Types and Ports | Output data type: if input is `single`/`double`, `OutDataTypeStr` must be `Inherit: Inherit via internal rule` or `Inherit: Same as input`; if integer, same or inherit | Nonfatal |
| Block Parameters | Filter structure (`FilterStructure`) must be set to `Direct form I` or `Direct form II` | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be set to `Floor` or `Zero` | Nonfatal |
| Block Parameters | Lock data type settings against changes by the fixed-point tools (`LockScale`) must be cleared (set to `off`) | Nonfatal |

### Constraint Details

#### Numerator/Denominator coefficient, product, accumulator, and output data types must match input

**Why:** The Discrete Filter performs multiply-accumulate operations for both numerator and denominator. If any intermediate data type differs from the input, type casts are inserted between computation stages that SLCI cannot trace to the filter block.

**Fix:**
```matlab
set_param('model/Discrete Filter', 'NumCoeffDataTypeStr', 'Inherit: Inherit via internal rule');
set_param('model/Discrete Filter', 'NumProductDataTypeStr', 'Inherit: Inherit via internal rule');
set_param('model/Discrete Filter', 'NumAccumDataTypeStr', 'Inherit: Inherit via internal rule');
set_param('model/Discrete Filter', 'DenCoeffDataTypeStr', 'Inherit: Inherit via internal rule');
set_param('model/Discrete Filter', 'DenProductDataTypeStr', 'Inherit: Inherit via internal rule');
set_param('model/Discrete Filter', 'DenAccumDataTypeStr', 'Inherit: Inherit via internal rule');
set_param('model/Discrete Filter', 'OutDataTypeStr', 'Inherit: Inherit via internal rule');
```

#### Integer rounding mode must be `Floor` or `Zero`

**Why:** Non-standard rounding modes produce rounding correction code in filter arithmetic that SLCI cannot trace.

**Fix:**
```matlab
set_param('model/Discrete Filter', 'RndMeth', 'Floor');
```

#### LockScale must be cleared

**Why:** When `LockScale` is enabled, fixed-point scaling is locked against changes by the fixed-point tools. This indicates the block may use custom fixed-point scaling which SLCI does not support. Clearing this ensures the block uses standard floating-point or integer types.

**Fix:**
```matlab
set_param('model/Discrete Filter', 'LockScale', 'off');
```

#### FilterStructure must be `Direct form I` or `Direct form II`

**Why:** SLCI maps the Discrete Filter block to specific code patterns corresponding to Direct form I or II implementations. Transposed structures produce different state variable usage and computation orders that do not match SLCI's expected code template for filter blocks.

**Fix:**
```matlab
set_param('model/Discrete Filter', 'FilterStructure', 'Direct form I');
```

---

## 28. Discrete Transfer Fcn — Nonfatal

**Block:** simulink/Discrete/Discrete Transfer Fcn

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | State (`StateDataTypeStr`) data type must match input data type | Nonfatal |
| Data Types and Ports | Numerator coefficient: if input is `single`/`double`, `NumCoefDataTypeStr` must be `Inherit: Inherit via internal rule`; if integer, same data type | Nonfatal |
| Data Types and Ports | Numerator product output: if input is `single`/`double`, `NumProductDataTypeStr` must be `Inherit: Inherit via internal rule` or `Inherit: Same as input`; if integer, same or inherit | Nonfatal |
| Data Types and Ports | Numerator accumulator: if input is `single`/`double`, `NumAccumDataTypeStr` must be `Inherit: Inherit via internal rule`, `Inherit: Same as input`, or `Inherit: Same as product output`; if integer, same rules | Nonfatal |
| Data Types and Ports | Denominator coefficient: if input is `single`/`double`, `DenCoefDataTypeStr` must be `Inherit: Inherit via internal rule`; if integer, same data type | Nonfatal |
| Data Types and Ports | Denominator product output: if input is `single`/`double`, `DenProductDataTypeStr` must be `Inherit: Inherit via internal rule` or `Inherit: Same as input`; if integer, same or inherit | Nonfatal |
| Data Types and Ports | Denominator accumulator: if input is `single`/`double`, `DenAccumDataTypeStr` must be `Inherit: Inherit via internal rule`, `Inherit: Same as input`, or `Inherit: Same as product output`; if integer, same rules | Nonfatal |
| Data Types and Ports | Output: if input is `single`/`double`, `OutDataTypeStr` must be `Inherit: Inherit via internal rule` or `Inherit: Same as input`; if integer, same or inherit | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be set to `Floor` | Nonfatal |
| Block Parameters | Lock data type settings (`LockScale`) must be cleared (set to `off`) | Nonfatal |
| Block Parameters | Saturate on integer overflow (`SaturateOnIntegerOverflow`) must be cleared (set to `off`) | Nonfatal |

### Constraint Details

#### State data type must match input data type

**Why:** The Discrete Transfer Fcn's internal state holds intermediate filter values. If the state type differs from the input, the code generator inserts type casts when reading/writing state variables. SLCI expects direct assignments between input, state, and output without intermediate casts.

**Fix:**
```matlab
set_param('model/Discrete Transfer Fcn', 'StateDataTypeStr', 'Inherit: Same as input');
```

#### Numerator/Denominator coefficient, product, accumulator, and output data types must match input

**Why:** Mismatched intermediate types produce type casts between computation stages that SLCI cannot trace to the transfer function block.

**Fix:**
```matlab
set_param('model/Discrete Transfer Fcn', 'NumCoefDataTypeStr', 'Inherit: Inherit via internal rule');
set_param('model/Discrete Transfer Fcn', 'NumProductDataTypeStr', 'Inherit: Inherit via internal rule');
set_param('model/Discrete Transfer Fcn', 'NumAccumDataTypeStr', 'Inherit: Inherit via internal rule');
set_param('model/Discrete Transfer Fcn', 'DenCoefDataTypeStr', 'Inherit: Inherit via internal rule');
set_param('model/Discrete Transfer Fcn', 'DenProductDataTypeStr', 'Inherit: Inherit via internal rule');
set_param('model/Discrete Transfer Fcn', 'DenAccumDataTypeStr', 'Inherit: Inherit via internal rule');
set_param('model/Discrete Transfer Fcn', 'OutDataTypeStr', 'Inherit: Inherit via internal rule');
```

#### Integer rounding mode must be `Floor`

**Why:** Non-Floor rounding modes produce rounding correction code that SLCI cannot trace to the transfer function block.

**Fix:**
```matlab
set_param('model/Discrete Transfer Fcn', 'RndMeth', 'Floor');
```

#### LockScale must be cleared

**Why:** Locked scaling indicates potential fixed-point usage. SLCI does not support fixed-point types. Clearing ensures standard types are used.

**Fix:**
```matlab
set_param('model/Discrete Transfer Fcn', 'LockScale', 'off');
```

#### SaturateOnIntegerOverflow must be cleared

**Why:** Overflow saturation guards produce conditional checks that have no corresponding model element in the Discrete Transfer Fcn block.

**Fix:**
```matlab
set_param('model/Discrete Transfer Fcn', 'SaturateOnIntegerOverflow', 'off');
```

---

## 62. Rate Limiter — Nonfatal

**Block:** simulink/Discrete/Rate Limiter

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | Sample time mode (`SampleTimeMode`) must be set to `inherited` | Nonfatal |

### Constraint Details

#### SampleTimeMode must be `inherited`

**Why:** When sample time mode is `specified`, the Rate Limiter computes elapsed time from the timing engine, stores previous time values, and uses time-scaled rate limits. This timing infrastructure code has no model-level counterpart. With `inherited` mode, the rate limits are applied directly per step without time computation.

**Fix:**
```matlab
set_param('model/Rate Limiter', 'SampleTimeMode', 'inherited');
```

---

## 63. Rate Transition — Nonfatal

**Block:** simulink/Signal Attributes/Rate Transition

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | Ensure data integrity during data transfer (`Integrity`) must be selected (set to `on`) | Nonfatal |
| Block Parameters | Ensure deterministic data transfer (`Deterministic`) must be selected (set to `on`) | Nonfatal |
| Block Parameters | Initial conditions (`X0`) must be zero, non-zero scalar, or use same data structure as output data type | Nonfatal |
| Block Parameters | Initial conditions (`X0`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |

### Constraint Details

#### Initial conditions (X0) must be zero, non-zero scalar, or same structure as output

**Why:** The Rate Transition buffer is initialized in `model_initialize()`. SLCI verifies this initialization by matching the assignment against the block's `X0` parameter. If `X0` uses a structure that doesn't match the output data type, the code generator produces field-by-field initialization or `memcpy` patterns that SLCI cannot reconcile with the block's parameter.

**Fix:**
```matlab
set_param('model/Rate Transition', 'X0', '0');
```

#### Initial conditions (X0) must not be empty, nonfinite, complex, or use MATLAB structures

**Why:** SLCI must resolve the initial value at analysis time to verify the initialization code. Empty, nonfinite (`Inf`, `NaN`), or complex values cannot be mapped to concrete C initializers that SLCI can trace.

**Fix:**
```matlab
set_param('model/Rate Transition', 'X0', '0');
```

#### Integrity and Deterministic must be selected

**Why:** Without integrity and determinism guarantees, the Rate Transition block may use direct memory access without double-buffering or synchronization. SLCI's verification expects the deterministic double-buffer pattern with rate interaction guards. When these are disabled, the generated code uses unprotected shared variables whose behavior depends on execution timing, making static equivalence checking impossible.

**Fix:**
```matlab
set_param('model/Rate Transition', 'Integrity', 'on');
set_param('model/Rate Transition', 'Deterministic', 'on');
```

---

## 94. Unit Delay — Nonfatal

**Block:** simulink/Discrete/Unit Delay

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input and output data type must not be `string` | Nonfatal |
| Data Types and Ports | Block state custom storage class must follow universal storage class rules (Unstructured/FlatStructure, supported types, Data initialization not None) | Nonfatal |
| Data Types and Ports | Block state must not resolve to a signal object with a non-empty `InitialValue` | Nonfatal |
| Data Types and Ports | If input is `int64`/`uint64`, Initial condition (`InitialCondition`) must have same data type as input | Nonfatal |
| Block Parameters | Initial conditions (`X0`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |
| Block Parameters | Input Processing (`InputProcessing`) must not be set to `Columns as channels (frame based)` | Nonfatal |
| Other | Block must not be used for rate transition | Nonfatal |

### Constraint Details

#### Input and output data type must not be `string`

**Why:** String data types produce dynamically-sized character buffers with runtime length tracking. SLCI cannot verify string delay operations.

**Fix:** Use a non-string data type for the signal feeding the Unit Delay.

#### Block state custom storage class must follow universal storage class rules

**Why:** The Unit Delay's DWork state variable must use a supported storage class (Unstructured or FlatStructure with supported types, Data initialization not `None`). Unsupported storage classes produce variable declarations or access patterns that SLCI cannot locate or verify in the generated code.

**Fix:** Use `Auto` storage class or a supported custom storage class for the state.

#### Block state must not resolve to a signal object with non-empty InitialValue

**Why:** When the state resolves to a signal object with its own `InitialValue`, the initialization code uses the signal object's value rather than the block's `X0` parameter. SLCI verifies initialization against the block parameter.

**Fix:**
```matlab
sig = Simulink.Signal;
sig.InitialValue = '';  % clear to let block X0 take effect
```

#### int64/uint64 Initial Condition must match input data type

**Why:** When the input is `int64`/`uint64`, the initial condition must be the same type. A type mismatch produces an implicit cast in the initialization code that may involve platform-dependent behavior SLCI cannot verify deterministically.

**Fix:** Ensure `X0` uses the same 64-bit type as the input signal.

#### Initial conditions (X0) must not be empty, nonfinite, complex, or use MATLAB structures

**Why:** SLCI resolves the initial condition at analysis time to verify the state initialization code in `model_initialize()`. Empty, nonfinite, or complex values cannot be mapped to concrete C initializers.

**Fix:**
```matlab
set_param('model/Unit Delay', 'X0', '0');
```

#### InputProcessing must not be `Columns as channels (frame based)`

**Why:** Frame-based processing treats the input vector as a time-series frame (multiple samples per channel). This causes the code generator to produce frame buffering logic (`memmove`, circular buffer indices, frame shift operations) that has no corresponding block in the model.

**Fix:**
```matlab
set_param('model/Unit Delay', 'InputProcessing', 'Elements as channels (sample based)');
```

#### Block must not be used for rate transition

**Why:** When a Unit Delay bridges two different sample rates, the code generator inserts rate interaction guards and potentially double-buffering logic to ensure data integrity across rates. These timing guards are runtime infrastructure that has no model-level counterpart and SLCI cannot map rate interaction conditionals to the Unit Delay block's defined behavior.

**Fix:**
```matlab
% Replace Unit Delay used for rate transition with Rate Transition block
add_block('simulink/Signal Attributes/Rate Transition', 'model/Rate Transition');
```

---

## 96. Weighted Sample Time Math — Nonfatal

**Block:** simulink/Discrete/Weighted Sample Time Math

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | Operation (`TsampMathOp`) cannot be `*` | Nonfatal |
| Block Parameters | Operation (`TsampMathOp`) cannot be `/` if input data type is not `single` or `double` | Nonfatal |
| Block Parameters | Output data type: if input is `single`, `OutDataTypeStr` must be `single` or `Inherit: Inherit via internal rule`; if `double`, must be `double` or inherit; if integer, must be same type | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be `Zero` or `Floor` | Nonfatal |

### Constraint Details

#### TsampMathOp cannot be `*`

**Why:** The multiplication operation (`*`) produces code where the sample time appears as a tunable parameter reference rather than a numeric literal. SLCI verifies code by matching numeric constants in the generated code against the block's configured sample time value. A parameter reference cannot be statically resolved during inspection.

**Fix:**
```matlab
set_param('model/Weighted Sample Time Math', 'TsampMathOp', '1/Ts');
```

#### TsampMathOp cannot be `/` if input data type is not `single` or `double`

**Why:** Division of integer types by the sample time produces a floating-point result that must be cast back to integer, requiring rounding. This produces implicit type conversion and rounding correction code that SLCI cannot trace to the Weighted Sample Time Math block.

**Fix:** For integer inputs, use a different operation (e.g., `1/Ts` or `Ts*u`) or convert the input to `double` before the block.

#### Output data type must match input type

**Why:** Mismatched output types produce implicit casts after the sample-time arithmetic. SLCI expects the output assignment to directly store the computation result. Type casts introduce code that cannot be traced to the block.

**Fix:**
```matlab
set_param('model/Weighted Sample Time Math', 'OutDataTypeStr', 'Inherit: Inherit via internal rule');
```

#### Integer rounding mode must be `Zero` or `Floor`

**Why:** Non-standard rounding modes produce conditional rounding correction code after the sample-time math operation.

**Fix:**
```matlab
set_param('model/Weighted Sample Time Math', 'RndMeth', 'Zero');
```

----

Copyright 2026 The MathWorks, Inc.

----
