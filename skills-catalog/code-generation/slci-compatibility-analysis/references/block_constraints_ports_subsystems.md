# Block Support Constraints: Ports and Subsystems

Blocks in this category manage control flow, subsystem execution, model referencing, and function interfaces including action ports, iterators, triggers, enables, and subsystem configurations.

---

## 3. Action Port — Nonfatal

**Block:** Action Port (simulink/Ports & Subsystems/Action Port)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | No block-specific constraints | N/A |

---

## 31. Enable Port — Mixed Severity

**Block:** Enable Port (simulink/Ports & Subsystems/Enable Port)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Signal entering enable port of subsystem must be `boolean` | Nonfatal |
| Block Parameters | Enable Port blocks are not supported at the root level of the model | **FATAL** |
| Block Parameters | If `DefaultParameterBehavior` is `Inlined`, signal entering Enable Port of parent subsystem must not be constant | Nonfatal |

### Constraint Details

#### Enable Port blocks not supported at root level — FATAL

**Why:** A root-level Enable Port changes the model's top-level calling interface — it generates `model_enable()` and `model_disable()` functions and wraps the entire step function in a mode guard. SLCI's inspection framework assumes a standard ERT entry point (`model_step()`, `model_initialize()`) and cannot handle the additional enable/disable lifecycle functions at the root level. This is FATAL because the entire code structure becomes unverifiable.

**Fix:** Move the Enable Port into a subsystem. The root model should not be conditionally enabled.

#### Signal entering Enable Port must not be constant when DefaultParameterBehavior is Inlined

**Why:** When `DefaultParameterBehavior` is `Inlined` and the enable signal is constant, the code generator resolves the enable condition at compile time. If constantly enabled, the subsystem's code is unconditionally inlined (no enable guard). If constantly disabled, the subsystem is dead-code-eliminated entirely. In both cases, SLCI cannot find the expected enabled subsystem code pattern.

**Fix:** Ensure the signal driving the Enable Port is not constant (i.e., depends on at least one non-constant source like an Inport).

#### Signal entering enable port must be `boolean`

**Why:** Non-boolean enable signals require a comparison operation (`> 0`) or type conversion in the generated code to evaluate the enable condition. This comparison has no model-level block — SLCI expects the enable guard to be a direct boolean test. The implicit `> 0` threshold check produces code that cannot be traced to the Enable Port block alone.

**Fix:**
```matlab
% Ensure enable signal is boolean type
set_param('model/Enable Signal Source', 'OutDataTypeStr', 'boolean');
```

---

## 32. Event Listener — Nonfatal

**Block:** Event Listener (simulink/Ports & Subsystems/Event Listener)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | Event type (`EventType`) must be set to `Initialize` or `Terminate` | Nonfatal |
| Block Parameters | Enable variant condition (`Variant`) must be set to `off` | Nonfatal |

### Constraint Details

#### EventType must be `Initialize` or `Terminate`

**Why:** SLCI only supports initialization and termination event listeners because these correspond to well-defined code entry points (`model_initialize()` and `model_terminate()`). Other event types (Reset, etc.) produce event-driven code patterns with runtime dispatching that SLCI cannot statically verify.

**Fix:**
```matlab
set_param('model/Event Listener', 'EventType', 'Initialize');
```

#### Variant must be `off`

**Why:** Variant-enabled Event Listeners produce conditional compilation (`#if`) or runtime variant guards around the event handler code. SLCI's analysis expects unconditional event handler code in the initialize/terminate functions. Variant conditions introduce code paths that SLCI cannot resolve statically.

**Fix:**
```matlab
set_param('model/Event Listener', 'Variant', 'off');
```

---

## 34. For Each — Nonfatal

**Block:** For Each (simulink/Ports & Subsystems/For Each)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | Input Partition Dimension and Output Concatenation Dimension must be less than 3 | Nonfatal |
| Block Parameters | Mask parameters must not be partitioned | Nonfatal |
| Block Parameters | `NeedActiveIterationSignal` must be set to `off` | Nonfatal |
| Block Parameters | `RequestParallelExec` must be set to `on` | Nonfatal |
| Block Parameters | `StateReset` must be set to `held` | Nonfatal |
| Block Parameters | `StateType` must be set to `Separate states for each iteration` | Nonfatal |
| Block Parameters | Number of iterations to execute must be set to `-1` (default) | Nonfatal |

### Constraint Details

#### Input Partition Dimension and Output Concatenation Dimension must be less than 3

**Why:** Dimensions 3 and higher produce multi-level nested index computation to partition/concatenate N-D arrays. SLCI can only verify 1-D (vector) or 2-D (matrix) partitioning, which generates simple linear index offsets. Higher dimensions produce complex multi-dimensional indexing that SLCI cannot trace.

**Fix:** Restructure data so that the For Each subsystem partitions along dimension 1 or 2 (i.e., rows or columns of a 2-D signal).

#### Mask parameters must not be partitioned

**Why:** When mask parameters are partitioned across iterations, the code generator creates per-iteration parameter slices. This produces indexed access into parameter arrays that has no direct counterpart in the For Each block's model-level representation — SLCI expects mask parameters to be used uniformly across all iterations.

**Fix:** Use workspace variables or Constant blocks inside the subsystem instead of partitioned mask parameters.

#### RequestParallelExec must be `on`

**Why:** When `RequestParallelExec` is `off`, the code generator may introduce iteration-order dependencies (e.g., shared temporary variables between iterations). SLCI expects each iteration to be independent, producing a simple for-loop where each iteration's code is self-contained. Parallel execution mode guarantees this independence.

**Fix:**
```matlab
set_param('model/For Each SS/For Each', 'RequestParallelExec', 'on');
```

#### StateReset must be `held`

**Why:** When `StateReset` is not `held`, state variables are reset under certain conditions (e.g., when the number of iterations changes). This reset logic generates conditional state initialization code inside the loop with no model-level block counterpart. `held` ensures states persist without reset logic.

**Fix:**
```matlab
set_param('model/For Each SS/For Each', 'StateReset', 'held');
```

#### StateType must be `Separate states for each iteration`

**Why:** With shared states, all iterations access a single scalar with no iteration index. Each iteration overwrites the previous value, producing read-modify-write dependencies where the output depends on execution order. SLCI expects each iteration to have its own state element via `model_DW.CoreSubsys[ForEach_itr]`, producing a per-iteration struct pattern traceable to the For Each block's partitioning.

**Fix:**
```matlab
set_param('model/For Each SS/For Each', 'StateType', 'Separate states for each iteration');
```

#### Number of iterations must be `-1` (default)

**Why:** When the number of iterations is explicitly set to a value other than `-1` (auto), it overrides the dimension-based iteration count. This can produce a mismatch between the signal dimensions and loop bounds, generating bounds-checking code that SLCI cannot trace. The default (`-1`) lets the iteration count match the input partition dimensions exactly.

**Fix:**
```matlab
set_param('model/For Each SS/For Each', 'SpecifiedNumIters', '-1');
```

#### NeedActiveIterationSignal must be `off`

**Why:** The active iteration signal introduces a conditional branch inside the loop body that selectively executes iterations based on an external boolean input. This conditional logic has no direct block-level mapping in the model, making it untraceable for code inspection.

**Fix:**
```matlab
set_param('model/For Each SS/For Each', 'NeedActiveIterationSignal', 'off');
```

---

## 35. For Iterator — Nonfatal

**Block:** For Iterator (simulink/Ports & Subsystems/For Iterator)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | Set next i externally (`ExternalIncrement`) must not be selected (set to `off`) | Nonfatal |
| Block Parameters | Iteration limit source (`IterationSource`) must be set to `internal` | Nonfatal |
| Block Parameters | Iteration variable data type (`IterationVariableDataType`) must be `int32`, `int16`, `int8`, `uint32`, `uint16`, or `uint8` | Nonfatal |
| Block Parameters | Subsystem must not have a tunable parameter for internal iteration limit | Nonfatal |

### Constraint Details

#### ExternalIncrement must not be selected

**Why:** External increment means the loop step value comes from a signal (another block output), making the loop iteration count data-dependent. SLCI requires bounded, deterministic loops to verify structural equivalence. With external increment, the generated code uses a `for` loop with a data-dependent step value instead of a standard `for` loop with a fixed increment. SLCI cannot statically prove loop bounds or iteration count for data-dependent iteration.

**Fix:**
```matlab
set_param('model/For Iterator SS/For Iterator', 'ExternalIncrement', 'off');
```

#### IterationSource must be `internal`

**Why:** When the iteration limit comes from an external source (input port), the loop bound is data-dependent and unknown at analysis time. The generated code clamps the limit to a safe range and uses a runtime variable as the loop bound. SLCI requires the loop count to be statically determinable (a compile-time constant) so it can verify that the loop body executes the expected number of times.

**Fix:**
```matlab
set_param('model/For Iterator SS/For Iterator', 'IterationSource', 'internal');
```

#### IterationVariableDataType must be `int32`, `int16`, `int8`, `uint32`, `uint16`, or `uint8`

**Why:** When `IterationVariableDataType` is set to `double`, the code generator introduces a redundant `(int32_T)((real_T)s1_iter)` cast in the array index expression. This cast through `real_T` has no corresponding model element, so SLCI cannot trace the array index back to the For Iterator block's iteration port. With integer types, the index is used directly without any intermediate cast.

**Fix:**
```matlab
set_param('model/For Iterator SS/For Iterator', 'IterationVariableDataType', 'int32');
```

#### Subsystem must not have a tunable parameter for internal iteration limit

**Why:** Tunable parameters are stored as runtime variables in the parameter structure. When the iteration limit is tunable, the loop bound becomes a runtime variable rather than a compile-time constant. SLCI requires statically determinable loop bounds for verification.

**Fix:** Use a non-tunable (inlined) constant for the iteration limit, or set `DefaultParameterBehavior` to `Inlined`.

---

## 37. Function-Call Generator — Nonfatal

**Block:** Function-Call Generator (simulink/Ports & Subsystems/Function-Call Generator)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Number of block destinations must be one | Nonfatal |
| Block Parameters | Number of iterations (`NumberOfIterations`) must be set to `1` | Nonfatal |
| Block Parameters | Show enable port (`ShowEnablePort`) must not be selected (set to `off`) | Nonfatal |

### Constraint Details

#### Number of block destinations must be one

**Why:** Simulink does not allow branching a function-call signal from a Function-Call Generator to multiple destinations — this produces a model update error. Use a Function-Call Split block to explicitly split function-call signals to multiple subsystems. SLCI requires a single destination per Function-Call Generator for one-to-one traceability between the generator and its called subsystem.

**Fix:** Use one Function-Call Generator per destination, or use a Function-Call Split block to explicitly split the function call.

#### ShowEnablePort must not be selected

**Why:** An enable port on a Function-Call Generator introduces conditional execution logic — the function call is only generated when the enable is active. This adds a runtime guard around the function call that has no visible block in the model's function-call connection path. SLCI expects unconditional function-call execution.

**Fix:**
```matlab
set_param('model/Function-Call Generator', 'ShowEnablePort', 'off');
```

#### Number of iterations must be `1`

**Why:** Multiple iterations wrap the function-call subsystem's code in a loop that has no model-level counterpart at the subsystem level. SLCI traces function-call execution as a single invocation per step. The iteration loop is infrastructure code that SLCI cannot attribute to any block.

**Fix:**
```matlab
set_param('model/Function-Call Generator', 'NumberOfIterations', '1');
```

---

## 38. Function-Call Split — Nonfatal

**Block:** Function-Call Split (simulink/Ports & Subsystems/Function-Call Split)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | No block-specific constraints | N/A |

---

## 39. Function Caller — Nonfatal

**Block:** Function Caller (simulink/User-Defined Functions/Function Caller)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | No block-specific constraints | N/A |

---

## 44. If — Nonfatal

**Block:** If (simulink/Ports & Subsystems/If)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | If `DefaultParameterBehavior` is `Inlined`, source of Inport 1 must not be constant | Nonfatal |

### Constraint Details

#### Source of Inport 1 must not be constant when DefaultParameterBehavior is Inlined

**Why:** When `DefaultParameterBehavior` is `Inlined` and the If block's input is constant, the code generator evaluates the If condition at compile time and eliminates the conditional branch entirely (dead code elimination). SLCI expects to find the If block's conditional structure in the generated code. When it is folded away, SLCI cannot verify the If block's code correspondence.

**Fix:** Ensure the signal driving the If block's input port is not constant (i.e., it depends on at least one non-constant source).

---

## 45. Initialize Function — Nonfatal

**Block:** Initialize Function (simulink/Ports & Subsystems/Initialize Function)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Other | Only the following blocks are supported inside: Inport, In Bus Element, Constant, Data Store Write, State Writer | Nonfatal |
| Other | Model cannot contain both initialize function subsystems and triggered or while-iterator subsystems | Nonfatal |

### Constraint Details

#### Only specific blocks supported inside Initialize Function

**Why:** Initialize Function subsystems generate code in `model_initialize()`. SLCI verifies this function with a restricted analysis scope — only simple assignment patterns (constants to states/datastores) are verifiable. Blocks that produce complex computational code in the initialize function would create untraceable patterns.

**Fix:** Move complex computation blocks outside the Initialize Function subsystem. Only use Inport, In Bus Element, Constant, Data Store Write, and State Writer inside.

#### Model cannot contain both initialize function subsystems and triggered/while-iterator subsystems

**Why:** Initialize Function subsystems generate code in `model_initialize()`. Triggered and While Iterator subsystems generate code with execution semantics that may conflict with the initialization sequence. When both exist, the code generator may produce interleaved initialization and triggering logic that creates ambiguous execution ordering SLCI cannot verify.

**Fix:** Remove the Triggered or While Iterator subsystem, or remove the Initialize Function subsystem and use standard initial conditions instead.

---

## 53. Model — Mixed Severity

**Block:** Model (simulink/Ports & Subsystems/Model)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Values in `ParameterArgumentValues` must not be complex or nonfinite | Nonfatal |
| Data Types and Ports | Input ports must be: enumerated type from `Simulink.IntEnumType` with default value 0, or scalar bus with supported element types | Nonfatal |
| Block Parameters | Model blocks and their output ports must not be constant | Nonfatal |
| Block Parameters | For inport blocks within a triggered Model block, `LatchByDelayingOutsideSignal` must not be selected | Nonfatal |
| Block Parameters | For input ports of a Model block, Latch input for feedback signals of function-call subsystem outputs (`LatchInputForFeedbackSignals`) must not be selected | Nonfatal |
| Other | Model reference must not be in protected mode | **FATAL** |
| Other | Model blocks must not have multiple sample times | Nonfatal |
| Other | Model block must not use instance parameters of referenced models as arguments | Nonfatal |
| Other | Model block must not refer to an export-function model | Nonfatal |
| Other | `Simulink.LookupTable` object must not be passed as mask parameter to a masked referenced model | Nonfatal |
| Other | Configuration parameter `Implement root-level I/O as` of referenced models must be set to `Individual arguments` | Nonfatal |

### Constraint Details

#### ParameterArgumentValues must not be complex or nonfinite

**Why:** Model argument values are passed as constants to the referenced model's parameterized step function. Complex values produce paired `.re`/`.im` arguments violating Universal Constraint 1.2. Nonfinite values (`Inf`/`NaN`) require special IEEE-754 constant representations that vary across compilers and cannot be statically resolved by SLCI.

**Fix:** Ensure all parameter argument values in the Model block are finite, real numeric values.

#### Input ports must be enumerated type from Simulink.IntEnumType with default 0, or scalar bus

**Why:** SLCI verifies Model block input arguments by matching port data types to function parameter types. Only enumerations derived from `Simulink.IntEnumType` with default value 0 produce deterministic integer-based argument passing. Scalar buses must contain only supported element types to ensure the generated struct argument has a verifiable layout.

**Fix:** Ensure Model block input ports use supported data types per Universal Constraint 1.1, with enumerations inheriting from `Simulink.IntEnumType` and having `DefaultValue` set to 0.

#### LatchByDelayingOutsideSignal must not be selected (triggered Model blocks)

**Why:** When enabled on inports within a triggered Model block, the latch mechanism introduces DWork variables that hold previous trigger values. These have no visible block in the model and produce untraceable state update code.

**Fix:**
```matlab
set_param('model/Model/In1', 'LatchByDelayingOutsideSignal', 'off');
```

#### Latch input for feedback signals of function-call subsystem outputs must not be selected

**Why:** Input latching for feedback signals of function-call subsystem outputs creates implicit delay elements (DWork variables) at the Model block's input ports to break algebraic loops. These latches generate state storage and update code with no model-level block counterpart that SLCI can trace.

**Fix:**
```matlab
set_param('model/Model', 'LatchInputForFeedbackSignals', 'off');
```

#### Model blocks must not have multiple sample times

**Why:** Multi-rate Model blocks generate rate-transition code and multiple step function entry points for each sample time. SLCI's traceability expects a single step function call per Model block. Multiple rate-specific calls cannot be individually mapped to the single Model block in the parent model.

**Fix:** Ensure the referenced model operates at a single sample rate, or insert explicit Rate Transition blocks in the parent model.

#### Model block must not use instance parameters of referenced models as arguments

**Why:** Instance parameters create per-instance parameter structures that are passed as arguments to the referenced model's step function. The instance parameter infrastructure (parameter struct type definition, per-instance storage) has no model-level block counterpart. SLCI expects model arguments to be simple scalar/vector constants, not instance-specific parameter structures.

**Fix:** Use standard model arguments (non-instance) or workspace parameters instead.

#### Model block must not refer to an export-function model

**Why:** Export-function models do not have a `model_step()` function. Instead, they expose individual functions triggered by function-call ports. The Model block calling convention for export-function models differs fundamentally from standard periodic models — SLCI's inspection expects the standard `step()` function call pattern.

**Fix:** Use a standard periodic referenced model, or restructure the export-function model as a function-call subsystem.

#### Simulink.LookupTable object must not be passed as mask parameter

**Why:** `Simulink.LookupTable` objects contain breakpoint and table data with their own storage class and memory section configuration. When passed as mask parameters to Model blocks, the generated code accesses table data through object-defined storage patterns that may not match SLCI's expected direct array access.

**Fix:** Define lookup table data as workspace variables or use explicit Lookup Table blocks inside the referenced model instead of passing `Simulink.LookupTable` objects through mask parameters.

#### Model reference must not be in protected mode — FATAL

**Why:** Protected model references encrypt the referenced model's content and generated code. SLCI requires full access to both the model structure and the generated source code to perform traceability verification. With a protected reference, the generated code for the submodel is opaque — SLCI cannot read, parse, or verify it, making the entire inspection impossible.

**Fix:** Use standard (non-protected) model references for code inspection.

#### Model blocks and output ports must not be constant

**Why:** When a Model block's output is constant (all paths through the referenced model produce compile-time-deterministic values), the code generator optimizes away the function call and pre-computes the output. SLCI expects to find a function call to the referenced model's step function in the parent's step code. When the call is eliminated, the Model block has no code counterpart in the step function, breaking traceability.

**Fix:** Ensure the referenced model has at least one non-constant signal path.

#### `Implement root-level I/O as` must be `Individual arguments`

**Why:** Structure-based I/O generates additional copy-in/copy-out code around the referenced model call — the parent copies signals into a structure before calling the submodel and copies results back after. These memory copies have no model-level element (no block exists for the copy operations). SLCI can only trace direct argument passing where each signal maps to a function parameter.

**Fix:**
```matlab
set_param('submodel', 'SubcomponentRootIOFormat', 'Individual arguments');
```

---

## 54. Model Info — N/A

**Block:** Model Info

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | No block-specific constraints | N/A |

---

## 75. Simulink Function — Nonfatal

**Block:** Simulink Function (simulink/User-Defined Functions/Simulink Function)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply (also applicable to Argument Inport and Argument Outport blocks defined in the Simulink Function) | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | No block-specific constraints | N/A |
| Other | Constraints also apply to Argument Inport and Argument Outport blocks | N/A |

---

## 77. State Reader — Nonfatal

**Block:** State Reader (simulink/Signal Routing/State Reader)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | State owner block (`StateOwnerBlock`) must be: Delay, Unit Delay, Discrete Filter, or Outport of conditional subsystem (Enabled, Triggered, Function-Call) | Nonfatal |
| Other | State Reader block must be inside of a Terminate Function subsystem | Nonfatal |

### Constraint Details

#### StateOwnerBlock must be Delay, Unit Delay, Discrete Filter, or Outport of conditional subsystem

**Why:** SLCI can only verify state reads from blocks with well-defined state storage patterns. Delay, Unit Delay, and Discrete Filter produce standard DWork state arrays. Outports of conditional subsystems store their last output value as state. Other blocks may produce non-standard or complex state representations that SLCI cannot trace.

**Fix:** Only connect the State Reader to one of the supported state-owning blocks.

#### State Reader must be inside a Terminate Function subsystem

**Why:** State Reader blocks read the final state value of a stateful block. SLCI expects this read to occur in `model_terminate()`, which corresponds to the Terminate Function subsystem. Outside this context, State Reader would produce code in the step function with ambiguous timing relative to state updates.

**Fix:** Place the State Reader block inside a Terminate Function subsystem.

---

## 78. State Writer — Nonfatal

**Block:** State Writer (simulink/Signal Routing/State Writer)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | State owner block (`StateOwnerBlock`) must be: Delay, Unit Delay, Discrete Filter, or Discrete-Time Integrator | Nonfatal |
| Other | State Writer block must be inside of an Initialize Function subsystem | Nonfatal |

### Constraint Details

#### StateOwnerBlock must be Delay, Unit Delay, Discrete Filter, or Discrete-Time Integrator

**Why:** SLCI can only verify state writes to blocks with well-defined state storage patterns. Delay, Unit Delay, Discrete Filter, and Discrete-Time Integrator produce standard DWork state arrays with predictable initialization code. Other blocks may have non-standard state representations that SLCI cannot map to the State Writer's assignment code in `model_initialize()`.

**Fix:** Only connect the State Writer to one of the supported state-owning blocks.

#### State Writer must be inside an Initialize Function subsystem

**Why:** State Writer blocks set the initial state value of a stateful block. SLCI expects this write to occur in `model_initialize()`, which corresponds to the Initialize Function subsystem. Outside this context, State Writer would produce state assignment code with ambiguous ordering relative to step execution.

**Fix:** Place the State Writer block inside an Initialize Function subsystem.

---

## 83. Subsystems — Nonfatal

**Block:** Subsystem, Atomic Subsystem, Enabled Subsystem, Function-Call Subsystem, If Action Subsystem, Triggered Subsystem, For Each Subsystem, For Iterator Subsystem, While Iterator Subsystem, Subsystem Reference

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Variant subsystems must have the same number of ports | Nonfatal |
| Block Parameters | Subsystems must be one of: Virtual, Enabled, Function-Call, If Action, Atomic, Triggered, For Each, For Iterator, While Iterator, Initialize Function, Terminate Function | Nonfatal |
| Block Parameters | Subsystem references must be for: Virtual, Enabled, Function-Call, Atomic, or Triggered | Nonfatal |
| Block Parameters | For nonvirtual subsystems, Function packaging (`RTWSystemCode`) must be `Inline`, `Nonreusable function`, or `Reusable function` | Nonfatal |
| Block Parameters | If `RTWSystemCode` is `Nonreusable function`: `RTWFcnNameOpts` must be `User specified`; `FunctionInterfaceSpec` must be `void_void`; `FunctionWithSeparateData` must be `off`; `CodeInterfacePackaging` must be `Nonreusable function` | Nonfatal |
| Block Parameters | If `RTWSystemCode` is `Reusable function`: `CodeInterfacePackaging` must be `Nonreusable function`; `PassReuseOutputArgsAs` must be `Individual arguments`; must be single-rate atomic or function-call; if from subsystem reference, must have matching unit test signature; if not from library, `RTWFcnNameOpts` must not be `Auto` and must have unique function name | Nonfatal |
| Block Parameters | If block has variants, `VariantActivationTime` must be set to `update diagram` | Nonfatal |
| Block Parameters | Atomic subsystems must not have `MinAlgLoopOccurrences` selected (set to `off`) | Nonfatal |
| Block Parameters | For masked subsystems, mask parameters must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |
| Other | Action subsystems connected to same If or Switch Case blocks must all combine or all separate their output and code updates | Nonfatal |
| Other | Reusable subsystems must not have inports connected to blocks with constant (Inf) sample time | Nonfatal |
| Other | Reusable subsystems must not have hidden signal buffers at their inports | Nonfatal |
| Other | Nonreusable subsystems must not be inside masked reusable subsystems | Nonfatal |
| Other | `Simulink.LookupTable` object must not be passed as mask parameter to a noninline subsystem | Nonfatal |

### Constraint Details

#### Variant subsystems must have the same number of ports

**Why:** When variant subsystems have different numbers of inports/outports, the code generator must handle the port mismatch with conditional signal routing or default values for missing ports. SLCI expects a consistent interface across all variants to produce a uniform code structure that can be traced regardless of which variant is active.

**Fix:** Ensure all variant choices have the same number of input and output ports. Add unused ports with Terminator/Ground connections if needed.

#### Subsystems must be a supported type

**Why:** SLCI supports specific subsystem execution semantics: Virtual, Enabled, Function-Call, If Action, Atomic, Triggered, For Each, For Iterator, While Iterator, Initialize Function, and Terminate Function. Other subsystem types may produce code patterns that don't match SLCI's expected execution structures.

**Fix:** Use one of the supported subsystem types listed above.

#### Subsystem references must be for supported types

**Why:** Subsystem references resolve to external subsystem files. SLCI only supports references that resolve to Virtual, Enabled, Function-Call, Atomic, or Triggered subsystems because these produce predictable code patterns that SLCI's analysis can handle.

**Fix:** Ensure the referenced subsystem file contains one of the supported types.

#### Function packaging (RTWSystemCode) must be `Inline`, `Nonreusable function`, or `Reusable function`

**Why:** Other function packaging options (e.g., `Auto`) allow the code generator to choose packaging based on optimization heuristics, producing unpredictable code structure. SLCI requires explicit control over whether the subsystem is inlined or placed in a separate function, as each produces a distinct code pattern that SLCI must know in advance to verify correctly.

**Fix:**
```matlab
set_param('model/Subsystem', 'RTWSystemCode', 'Inline');
% Or 'Nonreusable function' or 'Reusable function'
```

#### Nonreusable function: RTWFcnNameOpts must be `User specified`

**Why:** When set to `Auto`, the code generator assigns an internal name to the subsystem function. SLCI traces function calls by matching function names to subsystem blocks. Auto-generated names may not follow a predictable pattern, making traceability unreliable. `User specified` ensures a deterministic, known function name.

**Fix:**
```matlab
set_param('model/Subsystem', 'RTWFcnNameOpts', 'User specified');
set_param('model/Subsystem', 'RTWFcnName', 'mySubsystem');
```

#### Nonreusable function: FunctionInterfaceSpec must be `void_void`

**Why:** SLCI's traceability expects nonreusable subsystem functions to access model data through global structures (`model_B`, `model_U`, `model_Y`). When the function takes arguments and returns values, the calling pattern introduces local parameter passing that SLCI cannot map to the subsystem's inport/outport blocks — the ports become function arguments rather than direct structure accesses.

**Fix:**
```matlab
set_param('model/Subsystem', 'FunctionInterfaceSpec', 'void_void');
```

#### Nonreusable function: FunctionWithSeparateData must be `off`

**Why:** When enabled, the subsystem's data (block I/O, DWork) is placed in a separate data structure rather than the parent model's structures. This produces a different memory access pattern where the function accesses its own data structure instead of the global model structures. SLCI expects nonreusable functions to access data through the parent model's global structures.

**Fix:**
```matlab
set_param('model/Subsystem', 'FunctionWithSeparateData', 'off');
```

#### Nonreusable function: CodeInterfacePackaging must be `Nonreusable function`

**Why:** This parameter controls the code interface pattern. When set to a value other than `Nonreusable function`, the generated function may receive arguments or use different calling conventions. SLCI expects the void-void pattern for nonreusable functions with global data access.

**Fix:**
```matlab
set_param('model', 'CodeInterfacePackaging', 'Nonreusable function');
```

#### Reusable function: must be single-rate atomic or function-call

**Why:** Multi-rate reusable subsystems require rate-specific function instances and rate transition handling at the subsystem boundary. SLCI expects reusable functions to have a single, consistent execution rate producing one function with deterministic input/output arguments.

**Fix:** Ensure the reusable subsystem contains blocks at a single sample rate, or configure it as a function-call subsystem.

#### Reusable function: RTWFcnNameOpts must not be `Auto` and must have unique name

**Why:** SLCI identifies reusable subsystem instances by their function name. Auto-generated names are unpredictable, and non-unique names cause collision when multiple reusable instances exist. A unique, user-specified name ensures SLCI can map each function call to the correct subsystem instance.

**Fix:**
```matlab
set_param('model/Subsystem', 'RTWFcnNameOpts', 'User specified');
set_param('model/Subsystem', 'RTWFcnName', 'uniqueSubsystemName');
```

#### Reusable function: PassReuseOutputArgsAs must be `Individual arguments`

**Why:** Structure-based output passing wraps outputs in a struct type that has no model-level counterpart. SLCI traces each outport block to a specific function parameter — when outputs are packed into a struct, the individual outport-to-parameter mapping is lost behind the aggregate type.

**Fix:**
```matlab
set_param('model', 'PassReuseOutputArgsAs', 'Individual arguments');
```

#### VariantActivationTime must be `update diagram`

**Why:** When set to `code compile` or `startup`, variant selection occurs at C compile time or runtime. This produces `#if` preprocessor conditionals or runtime variant guards in the generated code. SLCI requires variant resolution at update-diagram time so that only the active variant's code is generated, producing unconditional code SLCI can verify.

**Fix:**
```matlab
set_param('model/Variant Subsystem', 'VariantActivationTime', 'update diagram');
```

#### MinAlgLoopOccurrences must not be selected for atomic subsystems

**Why:** When enabled, the code generator may restructure computations to minimize algebraic loop iterations, introducing additional temporary variables and reordering assignments. This optimization-driven restructuring produces code that doesn't follow the model's block execution order, preventing SLCI from tracing code back to specific blocks.

**Fix:**
```matlab
set_param('model/Subsystem', 'MinAlgLoopOccurrences', 'off');
```

#### Mask parameters must not be empty, nonfinite, complex, or use range selection/variable indexing

**Why:** SLCI resolves mask parameters at analysis time to verify parameter values in the generated code. Empty values produce no code, nonfinite values require special IEEE-754 representations, complex values violate Universal Constraint 1.2, and range/variable-indexed MATLAB structures cannot be resolved statically.

**Fix:** Set mask parameter values to finite, real numeric scalars, vectors, or matrices.

#### Action subsystems must all combine or all separate output and code updates

**Why:** When action subsystems connected to the same If or Switch Case block use different output/update combination settings, the code generator produces inconsistent code patterns across branches. SLCI expects all branches of a conditional structure to have the same code organization (either all combined or all separated) to verify the if/else or switch structure uniformly.

**Fix:** Set `SystemOutputsAndUpdates` consistently across all action subsystems connected to the same If/Switch Case block.

#### Reusable subsystems must not have inports connected to constant sample time blocks

**Why:** When a reusable subsystem's input comes from a block with constant (Inf) sample time, the code generator may fold the constant into the function body or omit the argument entirely. This produces a function signature that doesn't match SLCI's expected argument list based on the subsystem's inport count.

**Fix:** Ensure all signals entering reusable subsystem inports have periodic (non-constant) sample times. Insert a Signal Conversion block with `OverrideOpt=on` if needed.

#### Reusable subsystems must not have hidden signal buffers at inports

See also Limitation 1.16 (BufferReusableBoundary) in `code_inspection_limitations.md`.

**Why:** Hidden Signal Conversion blocks are inserted by the compiler at reusable subsystem boundaries to protect input data from being overwritten. These generate additional assignment statements that have no visible block in the model. SLCI cannot trace these assignments to any model element.

**Fix:**
```matlab
set_param(model, 'BufferReusableBoundary', 'off');
```

#### Nonreusable subsystems must not be inside masked reusable subsystems

**Why:** A nonreusable subsystem uses global data access (void-void interface). When placed inside a reusable (argument-passing) subsystem, the nonreusable function's global accesses conflict with the parent's reusable instantiation model. The code generator may produce inconsistent data access patterns that SLCI cannot resolve.

**Fix:** Change the inner subsystem to `Inline` or `Reusable function`, or change the outer subsystem to `Nonreusable function`.

#### Simulink.LookupTable object must not be passed as mask parameter to noninline subsystem

**Why:** `Simulink.LookupTable` objects produce storage-class-dependent data access code that may not match SLCI's expected array access pattern when passed through subsystem mask interfaces.

**Fix:** Define lookup table data directly inside the subsystem or use workspace variables instead.

---

## 86. Switch Case — Nonfatal

**Block:** Switch Case (simulink/Ports & Subsystems/Switch Case)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | If `DefaultParameterBehavior` is `Inlined`, source of Inport 1 must not be constant | Nonfatal |

### Constraint Details

#### Source of Inport 1 must not be constant when DefaultParameterBehavior is Inlined

**Why:** When the Switch Case input is constant and `DefaultParameterBehavior` is `Inlined`, the code generator resolves the case at compile time and eliminates the switch statement, removing the Switch Case block's code pattern from `model_step()`.

**Fix:** Ensure the signal driving the Switch Case input is not constant.

---

## 87. Terminate Function — Nonfatal

**Block:** Terminate Function (simulink/Ports & Subsystems/Terminate Function)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Other | Only the following blocks are supported inside: State Reader, Data Store Read, Outport, Out Bus Element, Bus Creator, Bus Selector | Nonfatal |
| Other | Terminate Function subsystem must not be placed inside a reusable subsystem | Nonfatal |
| Other | `DefaultParameterBehavior` must be set to `Inlined` | Nonfatal |

### Constraint Details

#### Only specific blocks supported inside Terminate Function

**Why:** Terminate Function subsystems generate code in `model_terminate()`. SLCI verifies this function with a restricted scope — only state reads and data store reads (final value capture) produce verifiable patterns. Complex computation blocks would create untraceable code in the terminate function.

**Fix:** Only use State Reader, Data Store Read, Outport, Out Bus Element, Bus Creator, and Bus Selector inside Terminate Function subsystems.

#### Terminate Function must not be inside a reusable subsystem

**Why:** Reusable subsystems generate instance-based functions with argument passing. The Terminate Function generates code in the global `model_terminate()` entry point. Placing a Terminate Function inside a reusable subsystem creates a conflict between instance-specific termination and the single global terminate function that SLCI expects.

**Fix:** Move the Terminate Function subsystem to the root level or inside a nonreusable subsystem.

#### DefaultParameterBehavior must be `Inlined`

**Why:** When `DefaultParameterBehavior` is `Tunable`, parameters referenced in the Terminate Function produce runtime variable accesses in `model_terminate()`. SLCI expects terminate function code to use only compile-time constants (inlined values) for simple, verifiable assignment patterns.

**Fix:**
```matlab
set_param(model, 'DefaultParameterBehavior', 'Inlined');
```

---

## 90. Trigger Port — Mixed Severity

**Block:** Trigger Port (simulink/Ports & Subsystems/Trigger Port)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Output port data types must be `auto`, `int8`, or `double` | Nonfatal |
| Data Types and Ports | In parent subsystem, signal entering trigger port must be scalar | Nonfatal |
| Data Types and Ports | In parent subsystem, signal entering trigger port must be `boolean` when `TriggerType` is `rising`, `falling`, or `either` | Nonfatal |
| Block Parameters | Block must not be at root level of model when `TriggerType` is `rising`, `falling`, or `either` | **FATAL** |
| Block Parameters | States when enabling (`StatesWhenEnabling`) must not be set to `inherit` | Nonfatal |
| Block Parameters | If `DefaultParameterBehavior` is `Inlined`, signal entering Trigger Port of parent subsystem must not be constant | Nonfatal |
| Block Parameters | Initial trigger signal state (`InitialTriggerSignalState`) must be `compatibility (no trigger on first evaluation)` or `zero` | Nonfatal |

### Constraint Details

#### Output port data types must be `auto`, `int8`, or `double`

**Why:** The Trigger Port output carries the trigger signal value (for function-call triggers) or edge detection result. SLCI can only verify output assignments using `auto` (inherits from context), `int8` (edge direction: -1, 0, +1), or `double` (trigger value). Other types introduce type conversion code in the trigger output path that SLCI cannot trace.

**Fix:**
```matlab
set_param('model/Triggered SS/Trigger', 'OutputDataType', 'auto');
```

#### Signal entering trigger port must be scalar

**Why:** Vector trigger signals require element-wise edge detection with multiple comparisons. SLCI expects a single scalar trigger condition producing one boolean test in the generated code. Vector triggers generate loop-based or multi-condition edge detection that SLCI cannot map to the single Trigger Port block.

**Fix:** Use a scalar signal to drive the trigger port. If the trigger depends on multiple signals, combine them using logic blocks before the trigger.

#### Signal entering trigger port must be `boolean` for edge triggers

**Why:** When `TriggerType` is `rising`, `falling`, or `either`, the code generator must detect signal edges. With boolean inputs, edge detection is a simple comparison (`prev != curr`). With non-boolean inputs, the code generator inserts zero-crossing detection code (`rt_ZCFcn`) that produces threshold comparisons and interpolation logic with no model-level counterpart.

**Fix:**
```matlab
% Ensure trigger signal is boolean
set_param('model/Trigger Source', 'OutDataTypeStr', 'boolean');
```

#### Block must not be at root level — FATAL

**Why:** A root-level Trigger Port changes the model's execution semantics from periodic to event-driven. This generates a fundamentally different code structure where `model_step()` only executes on trigger events, with zero-crossing detection at the top level. SLCI's inspection framework assumes periodic execution and cannot handle event-driven root models.

**Fix:** Move the Trigger Port into a subsystem. Use a Triggered Subsystem inside the root model instead.

#### StatesWhenEnabling must not be `inherit`

**Why:** When set to `inherit`, the state reset behavior depends on the parent subsystem's configuration. This produces context-dependent initialization code that varies based on the subsystem hierarchy. SLCI requires explicit state behavior (`reset` or `held`) to produce deterministic, verifiable initialization patterns.

**Fix:**
```matlab
set_param('model/Triggered SS/Trigger', 'StatesWhenEnabling', 'held');
```

#### Signal entering Trigger Port must not be constant when DefaultParameterBehavior is Inlined

**Why:** A constant trigger signal with inlined parameters allows the code generator to resolve the trigger condition at compile time, eliminating the triggered subsystem's conditional execution pattern from the generated code.

**Fix:** Ensure the signal driving the Trigger Port is not constant.

#### InitialTriggerSignalState must be `compatibility (no trigger on first evaluation)` or `zero`

**Why:** Other initial states (e.g., `held`) produce additional initialization code that stores the trigger signal's initial state for first-step edge detection. The `compatibility` and `zero` options produce a simple zero-initialization that SLCI can verify. Other options generate state-dependent initialization logic with no simple model counterpart.

**Fix:**
```matlab
set_param('model/Triggered SS/Trigger', 'InitialTriggerSignalState', ...
    'compatibility (no trigger on first evaluation)');
```

---

## 97. While Iterator — Nonfatal

**Block:** While Iterator (simulink/Ports & Subsystems/While Iterator)

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | Maximum number of iterations (`MaxIters`) must not be set to `-1` | Nonfatal |

### Constraint Details

#### MaxIters must not be `-1`

**Why:** SLCI requires provably bounded loops for verification. When `MaxIters` is `-1` (unlimited), the generated while-loop has no compile-time-determinable upper bound. SLCI's static analysis cannot prove termination or bound the number of iterations, making it impossible to verify that the loop's execution matches the model's intended behavior. A finite `MaxIters` value provides the static bound check that SLCI needs.

**Fix:**
```matlab
set_param('model/While Iterator SS/While Iterator', 'MaxIters', '100');
```

----

Copyright 2026 The MathWorks, Inc.

----
