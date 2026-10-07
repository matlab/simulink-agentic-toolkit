# Code Generation Configuration Parameter Constraints

SLCI (Simulink Code Inspector) verifies equivalence between a Simulink model and its
generated C code. Every configuration parameter constraint exists to ensure that the
generated code is deterministic, traceable back to the model, and free of constructs
that break SLCI's model-to-code mapping.

---

## Code Generation: General

### 1. System target file (SystemTargetFile) — FATAL

**Required:** `ert.tlc` or an ERT-derived target

**Why:** SLCI's code inspection framework is designed around the Embedded Coder (ERT) code structure: a single-file, production-quality layout with `model_step()`, `model_initialize()`, and well-defined data structures. The GRT target generates a different calling interface and additional wrapper code that SLCI cannot map back to model elements.

**Fix:**
```matlab
set_param(model, 'SystemTargetFile', 'ert.tlc');
```

---

### 2. TLCOptions — Nonfatal

**Required:** `''` or `-aMaxStackVariableSize=inf`

**Why:** When `MaxStackVariableSize` is finite, the code generator may place large temporary arrays into persistent (static) memory instead of stack variables. This creates additional global variables that have no corresponding model element, breaking SLCI's traceability.

**Fix:**
```matlab
set_param(model, 'TLCOptions', '');
% or
set_param(model, 'TLCOptions', '-aMaxStackVariableSize=inf');
```

---

## Code Generation: Optimization

### 3. Pack Boolean data into bitfields (BooleansAsBitfields) — Nonfatal

**Required:** `off`

**Why:** When Booleans are packed into bitfields, individual signals no longer map to distinct addressable variables. SLCI traces each Boolean signal to a named variable in the code. Bitfield packing merges multiple signals into a single word, making one-to-one traceability impossible.

**Fix:**
```matlab
set_param(model, 'BooleansAsBitfields', 'off');
```

---

### 4. Default parameter behavior (DefaultParameterBehavior) — Nonfatal

**Required:** `Inlined` (for referenced models)

**Why:** When parameters are tunable (not inlined), the code generator creates a parameter data structure populated at runtime. SLCI needs to verify that constant values in the model appear as literal constants in the generated code. Tunable parameters introduce an indirection layer preventing SLCI from confirming parameter values match the model.

**Fix:**
```matlab
set_param(model, 'DefaultParameterBehavior', 'Inlined');
```

---

### 5. Loop unrolling threshold (RollThreshold) — Nonfatal

**Required:** Must not result in partially unrolled loops

**Why:** SLCI can verify both fully unrolled code and fully rolled loops. However, partially unrolled loops -- where some iterations are unrolled and others are in a loop -- create a hybrid structure that SLCI cannot map to any single model pattern. The threshold must ensure every vector operation is either completely unrolled or completely rolled.

**Fix:**
```matlab
set_param(model, 'RollThreshold', '5');  % Adjust to avoid partial unrolling
```

---

### 6. Pass reusable subsystem outputs as (PassReuseOutputArgsAs) — Nonfatal

**Required:** `Structure reference` (if referenced model has root outports with non-auto storage class)

**Why:** When outputs are passed as individual pointer arguments, the code generator may reorder or merge arguments in ways that obscure the mapping from model outports to function parameters. Using a structure reference preserves a clear, named correspondence between each model outport and a struct field.

**Fix:**
```matlab
set_param(model, 'PassReuseOutputArgsAs', 'Structure reference');
```

---

### 7. Use bitsets for storing state configuration (StateBitsets) — Nonfatal

**Required:** `off`

### 8. Use bitsets for storing Boolean data (DataBitsets) — Nonfatal

**Required:** `off`

**Why:** Similar to `BooleansAsBitfields`, packing state configuration or Boolean data into bitsets merges multiple distinct model elements into a single machine word. SLCI must trace each Stateflow state variable and each Boolean signal individually. Bitset packing destroys this one-to-one mapping.

**Fix:**
```matlab
set_param(model, 'StateBitsets', 'off');
set_param(model, 'DataBitsets', 'off');
```

---

### 9. Optimize using the specified minimum and maximum values (UseSpecifiedMinMax) — Nonfatal

**Required:** `off`

**Why:** When min/max optimization is enabled, the code generator uses signal range information to eliminate code branches it deems unreachable. SLCI verifies that every block's semantics are fully represented in code. If the optimizer removes saturation logic based on range assumptions, the generated code no longer structurally matches the model.

**Fix:**
```matlab
set_param(model, 'UseSpecifiedMinMax', 'off');
```

---

### 10. Remove code from floating-point to integer conversions that wraps out-of-range values (EfficientFloat2IntCast) — Nonfatal

**Required:** `on`

**Why:** When this setting is off, the code generator inserts range-checking branches around float-to-int conversions. These multi-branch conditional structures cannot be mapped one-to-one to the Data Type Conversion block -- SLCI expects a single C cast expression `(int32_T)x` that directly corresponds to the block.

**Fix:**
```matlab
set_param(model, 'EfficientFloat2IntCast', 'on');
```

---

### 11. Remove code from floating-point to integer conversions with saturation that maps NaN to zero (EfficientMapNaN2IntZero) — Nonfatal

**Required:** `off`

**Why:** When this option is on, the code generator removes the explicit NaN-to-zero mapping code, relying on platform-specific behavior. SLCI requires that the saturation semantics of the Data Type Conversion block (including NaN handling) are explicitly represented in code.

**Fix:**
```matlab
set_param(model, 'EfficientMapNaN2IntZero', 'off');
```

---

### 12. Remove code that protects against integer division arithmetic exceptions (NoFixptDivByZeroProtection) — Nonfatal

**Required:** `off`

**Why:** The Divide block in Simulink has defined behavior for division by zero. SLCI verifies that this protective semantics is present in the generated code. If the protection is removed, the code relies on undefined behavior that SLCI cannot verify as equivalent to the model's well-defined semantics.

**Fix:**
```matlab
set_param(model, 'NoFixptDivByZeroProtection', 'off');
```

---

### 13. AdvancedOptControl — Nonfatal

**Required:** `-SLCI`

**Why:** The `-SLCI` flag disables advanced optimizations that would merge, reorder, or eliminate computations in ways that break block-level traceability. Without this flag, the code generator may fold constants across multiple blocks, eliminate intermediate variables, or restructure expressions. SLCI needs each block's computation to appear as a distinct, identifiable operation.

**Incorrect code example (without -SLCI -- shows constant folding):**
```c
void mymodel_step(void)
{
    /* Optimizer may fold: 2.0 * 3.0 = 6.0 */
    mymodel_Y.Out1 = mymodel_U.In1 * 6.0;
}
```

**Fix:**
```matlab
set_param(model, 'AdvancedOptControl', '-SLCI');
```

---

### 14. Operator to represent Bitwise and Logical Operator blocks (BitwiseOrLogicalOp) — Nonfatal

**Required:** `Same as modeled` or `Bitwise operator`

**Why:** SLCI verifies that the C operator used in code matches the operator type specified in the model block. A Bitwise AND block must generate `&` and a Logical AND block must generate `&&`. If the code generator substitutes one operator type for another, SLCI cannot confirm that the code faithfully implements the modeled operation.

**Fix:**
```matlab
set_param(model, 'BitwiseOrLogicalOp', 'Same as modeled');
```

---

### 15. Reuse output buffers of Model blocks (ReuseModelBlockBuffer) — Nonfatal

**Required:** `off`

**Why:** When buffer reuse is enabled, the code generator may alias input and output buffers of Model blocks, causing implicit data flow relationships in the code that have no explicit signal connection in the model. SLCI requires that each signal transfer between model blocks is represented as an explicit assignment in code.

**Fix:**
```matlab
set_param(model, 'ReuseModelBlockBuffer', 'off');
```

---

## Code Generation: Comments

### 16. Include comments (GenerateComments) — FATAL

**Required:** `on`

**Why:** SLCI uses block-path comments (e.g., `/* Gain: '<Root>/Gain' */`) as anchors to locate and identify which section of code corresponds to which model block. Without these comments, SLCI has no reliable mechanism to associate code regions with their source blocks. This is fundamental to the inspection process.

**Incorrect code example (comments OFF -- shows loss of SLCI anchors):**
```c
void mymodel_step(void)
{
    mymodel_Y.Out1 = mymodel_U.In1 * 2.0;
    /* No block-path comments — SLCI cannot identify which block produced this code */
}
```

**Fix:**
```matlab
set_param(model, 'GenerateComments', 'on');
```

---

## Code Generation: Identifiers

### 17. Signal naming (SignalNamingRule) — Nonfatal

**Required:** `None`

### 18. Parameter naming (ParamNamingRule) — Nonfatal

**Required:** `None`

**Why:** SLCI's traceability engine expects identifiers to follow the code generator's default naming convention (based on block names and hierarchy). Custom naming rules can produce identifiers that SLCI cannot map back to their source model elements. Setting the rule to `None` ensures the standard, predictable naming scheme.

**Fix:**
```matlab
set_param(model, 'SignalNamingRule', 'None');
set_param(model, 'ParamNamingRule', 'None');
```

---

## Code Generation: Custom Code

### 19-22. Custom Code Settings (CustomSourceCode, CustomHeaderCode, CustomInitializer, CustomTerminator) — Nonfatal

**Required:** `''` (all must be unspecified)

**Why:** Custom code injected into generated files has no model representation. SLCI verifies that every line of executable code traces back to a model element. Custom code -- whether in headers, source files, or initialization/termination functions -- introduces unverifiable content that SLCI cannot inspect or validate.

**Fix:**
```matlab
set_param(model, 'CustomSourceCode', '');
set_param(model, 'CustomHeaderCode', '');
set_param(model, 'CustomInitializer', '');
set_param(model, 'CustomTerminator', '');
```

---

## Code Generation: Interface

### 23. Use dynamic memory allocation for model initialization (GenerateAllocFcn) — Nonfatal

**Required:** `off`

**Why:** Dynamic memory allocation (`malloc`/`free`) introduces runtime behavior that has no deterministic model equivalent. SLCI verifies static data structures whose sizes and layouts are known at compile time. Dynamically allocated structures cannot be traced to model elements because their existence depends on runtime conditions.

**Fix:**
```matlab
set_param(model, 'GenerateAllocFcn', 'off');
```

---

### 24. Code replacement library (CodeReplacementLibrary) — Nonfatal

**Required:** `None` (or use only supported CRL functions)

**Why:** Code replacement libraries substitute standard math operations with target-specific or optimized function calls. SLCI expects standard C math functions that directly correspond to model block semantics. Replaced functions may have different numerical behavior that SLCI cannot verify against the model's mathematical specification.

**Fix:**
```matlab
set_param(model, 'CodeReplacementLibrary', 'None');
```

---

### 25. Language standard (TargetLangStandard) — Nonfatal

**Required:** `C89/C90 (ANSI)` or `C99 (ISO)`

**Why:** SLCI's code analysis is built to understand constructs from C89/C90 and C99 standards. Non-standard extensions or newer language features may introduce syntax or semantics that SLCI's parser does not recognize. Restricting to these standards ensures the generated code uses only constructs SLCI can analyze.

**Fix:**
```matlab
set_param(model, 'TargetLangStandard', 'C99 (ISO)');
```

---

### 26. Shared code placement (UtilityFuncGeneration) — Nonfatal

**Required:** `Shared location`

**Why:** When utility functions are generated locally, identical helper functions may be duplicated with different names across model references. SLCI needs a single, canonical definition of each utility function to verify. Shared placement ensures one definition exists, allowing SLCI to verify it once and track its usage across all models.

**Fix:**
```matlab
set_param(model, 'UtilityFuncGeneration', 'Shared location');
```

---

### 27. Support: non-finite numbers (SupportNonFinite) — Nonfatal

**Required:** `off`

**Why:** Non-finite number support generates runtime infrastructure (rtIsNaN, rtIsInf functions and initialization code) that has no model-level counterpart. These utility functions and associated initialization add code that SLCI cannot trace to any block.

**Fix:**
```matlab
set_param(model, 'SupportNonFinite', 'off');
```

---

### 28. Support: absolute time (SupportAbsoluteTime) — Nonfatal

**Required:** `off`

**Why:** Absolute time support generates a time counter variable and associated overflow management code. This infrastructure does not correspond to any specific block in the model. SLCI requires that all generated code traces to model elements, and time-counter management code cannot be mapped to any block.

**Fix:**
```matlab
set_param(model, 'SupportAbsoluteTime', 'off');
```

---

### 29. Classic call interface (GRTInterface) — Nonfatal

**Required:** `off`

**Why:** The classic (GRT) call interface adds wrapper functions, task ID parameters, and a multi-layered calling structure that obfuscates the relationship between model blocks and generated code. SLCI requires the streamlined ERT interface where each model function directly contains the block computations.

**Fix:**
```matlab
set_param(model, 'GRTInterface', 'off');
```

---

### 30. Single output/update function (CombineOutputUpdateFcns) — Nonfatal

**Required:** `on`

**Why:** SLCI expects all block computations (both output calculation and state update) to appear in a single function. When output and update are split into separate functions, a single block's behavior spans two functions, making it harder for SLCI to verify the complete semantics of stateful blocks.

**Fix:**
```matlab
set_param(model, 'CombineOutputUpdateFcns', 'on');
```

---

### 31. Terminate function required (IncludeMdlTerminateFcn) — Nonfatal

**Required:** `off`

**Why:** A terminate function typically contains cleanup code that has no model-level representation. Since SLCI requires all code to map to model elements, generating an empty or unnecessary terminate function adds unverifiable code. Models used with SLCI should not require termination actions.

**Fix:**
```matlab
set_param(model, 'IncludeMdlTerminateFcn', 'off');
```

---

### 32. Remove error status field in real-time model data structure (SuppressErrorStatus) — Nonfatal

**Required:** `on`

**Why:** The error status field and its associated checking code provide runtime error reporting that has no corresponding model element. SLCI cannot trace error-status checks or assignments to any block. Suppressing this field eliminates unverifiable code from the generated output.

**Fix:**
```matlab
set_param(model, 'SuppressErrorStatus', 'on');
```

---

### 33. Combine signal/state structures (CombineSignalStateStructs) — Nonfatal

**Required:** `off`

**Why:** SLCI distinguishes between block states (DW structure) and intermediate signals (B structure) during verification. Combining them into one structure removes the semantic distinction, making it harder for SLCI to identify whether a struct field represents a block's persistent state or a transient computation result.

**Fix:**
```matlab
set_param(model, 'CombineSignalStateStructs', 'off');
```

---

### 34. Array layout (ArrayLayout) — Nonfatal

**Required:** `Column-major`

**Why:** Simulink and MATLAB use column-major array storage. SLCI's verification logic assumes column-major layout when mapping matrix elements from model to code. If the code uses row-major layout, array indices are transposed and SLCI cannot correctly match matrix element accesses to their corresponding model signal elements.

**Fix:**
```matlab
set_param(model, 'ArrayLayout', 'Column-major');
```

---

### 35. MAT-file logging (MatFileLogging) — Nonfatal

**Required:** `off`

**Why:** MAT-file logging generates data recording code and buffer management that has no model equivalent. This instrumentation code cannot be traced to any block and adds variables, buffers, and function calls that pollute the generated source with unverifiable content.

**Fix:**
```matlab
set_param(model, 'MatFileLogging', 'off');
```

---

### 36. Support: variable-size signals (SupportVariableSizeSignals) — FATAL

**Required:** `off`

**Why:** Variable-size signals require runtime size-tracking variables and conditional logic to manage changing dimensions. SLCI's verification assumes fixed-size signals where array dimensions are known at compile time. Runtime size management introduces code that cannot be statically verified against the model.

**Fix:**
```matlab
set_param(model, 'SupportVariableSizeSignals', 'off');
```

---

### 37-40. Generate C API (RTWCAPIParams, RTWCAPISignals, RTWCAPIStates, RTWCAPIRootIO) — Nonfatal

**Required:** `off` (all)

**Why:** The C API generates metadata tables and accessor infrastructure that expose internal model data to external tools at runtime. These tables, registration functions, and data structures have no model-level counterpart. They represent instrumentation rather than computation and cannot be verified by SLCI.

**Fix:**
```matlab
set_param(model, 'RTWCAPIParams', 'off');
set_param(model, 'RTWCAPISignals', 'off');
set_param(model, 'RTWCAPIStates', 'off');
set_param(model, 'RTWCAPIRootIO', 'off');
```

---

### 41. External mode (ExtMode) — Nonfatal

**Required:** `off`

**Why:** External mode generates communication infrastructure (packet handling, data upload/download, synchronization) for connecting a running target to Simulink. This communication code has no model representation and introduces function calls, buffers, and protocol handling that SLCI cannot trace to model elements.

**Fix:**
```matlab
set_param(model, 'ExtMode', 'off');
```

---

### 42. Existing shared code (ExistingSharedCode) — Nonfatal

**Required:** `''`

**Why:** When existing shared code is specified, the build process uses pre-existing source files not generated from the current code generation session. SLCI cannot verify code that was not produced from the model, as there is no guarantee it matches the model's computational semantics. All shared utilities must be generated fresh.

**Fix:**
```matlab
set_param(model, 'ExistingSharedCode', '');
```

---

## Code Generation: Verification

### 43. Create block (CreateSILPILBlock) — Nonfatal

**Required:** `None`

**Why:** SIL/PIL block creation generates additional test harness code and communication wrappers for running generated code back in the Simulink environment. This harness code is not part of the production algorithm and cannot be traced to model blocks. SLCI inspects only production-intent code.

**Fix:**
```matlab
set_param(model, 'CreateSILPILBlock', 'None');
```

---

### 44. Measure function execution times (CodeProfilingInstrumentation) — Nonfatal

**Required:** `off`

**Why:** Profiling instrumentation inserts timing measurement calls at function entry/exit points. These calls have no model counterpart and pollute the generated code with statements that SLCI cannot verify. SLCI requires that all executable statements correspond to model computations.

**Fix:**
```matlab
set_param(model, 'CodeProfilingInstrumentation', 'off');
```

---

## Code Generation: Code Style

### 45. Preserve condition expression in if statement (PreserveIfCondition) — Nonfatal

**Required:** `on`

**Why:** SLCI verifies that conditional expressions in the code match the condition structure in the model. When the code generator is allowed to split, merge, or reorder conditions, the generated if-statement structure no longer corresponds to the model's branching logic. Preserving conditions ensures a direct structural mapping.

**Fix:**
```matlab
set_param(model, 'PreserveIfCondition', 'on');
```

---

### 46. Suppress generation of default cases for Stateflow switch statements if unreachable (SuppressUnreachableDefaultCases) — Nonfatal

**Required:** `off`

**Why:** SLCI expects every switch statement generated from a Stateflow chart to include a default case. The default case provides a complete structural representation of the state machine's branching logic. Removing it changes the control flow structure, making it impossible for SLCI to verify that all possible state transitions are represented.

**Fix:**
```matlab
set_param(model, 'SuppressUnreachableDefaultCases', 'off');
```

---

### 47. Casting modes (CastingMode) — Nonfatal

**Required:** `Nominal` or `Standards`

**Why:** SLCI's expression analysis expects type casts to follow either the nominal pattern (casts only where semantically necessary) or the standards-compliant pattern. Other casting modes insert redundant or unusual casts that change the expression structure SLCI must verify, potentially causing false mismatches.

**Fix:**
```matlab
set_param(model, 'CastingMode', 'Nominal');
```

---

## Code Generation: Templates

### 48. Generate an example main program (GenerateSampleERTMain) — Nonfatal

**Required:** `on` (for models with multiple discrete rates)

**Why:** For multirate models, the generated sample main program contains the rate scheduling logic that determines how step functions for different rates are invoked. SLCI needs to verify that the rate interaction pattern matches the model's sample time configuration. Without the generated main, this scheduling logic is absent from the inspectable code.

**Fix:**
```matlab
set_param(model, 'GenerateSampleERTMain', 'on');
```

---

## Code Generation: Code Placement

### 49. Rate Transition block code (RateTransitionBlockCode) — Nonfatal

**Required:** `Inline`

**Why:** When Rate Transition code is generated as a separate utility function, the block's behavior is abstracted away from its usage context. SLCI traces each Rate Transition block to inline code at its point of use, verifying the buffer read/write pattern directly. A function call obscures this pattern and prevents unique identification.

**Fix:**
```matlab
set_param(model, 'RateTransitionBlockCode', 'Inline');
```

---

### 50. Header files (ERTHeaderFileRootName) — FATAL

**Required:** Must not contain the `$U` token

**Why:** The `$U` token in header file names allows user-defined customization of generated file names. SLCI relies on deterministic, predictable file naming conventions to locate and parse generated header files. If file names contain user-defined tokens, SLCI cannot reliably find the type definitions and function declarations it needs.

**Fix:**
```matlab
cs = getActiveConfigSet(model);
set_param(cs, 'ERTHeaderFileRootName', '$R');  % Use model name only
```

---

## Summary

All Code Generation constraints serve one or more of these SLCI verification principles:

| Principle | Constraints |
|-----------|-------------|
| **One-to-one traceability** (each block maps to identifiable code) | 1, 3, 7, 8, 13, 14, 16, 17, 18, 45, 46, 49 |
| **No unverifiable code** (no code without a model source) | 2, 19-22, 23, 27, 28, 31, 32, 35, 37-41, 42, 43, 44 |
| **Deterministic structure** (code structure is predictable) | 4, 5, 6, 15, 25, 26, 29, 30, 33, 34, 47, 48, 50 |
| **Correct semantics** (code behavior matches model behavior) | 9, 10, 11, 12, 24, 36 |

FATAL constraints (1, 16, 36, 50) will halt SLCI inspection entirely, as they represent
conditions where verification is fundamentally impossible.


----

Copyright 2026 The MathWorks, Inc.

----
