# Diagnostics Configuration Parameter Constraints

SLCI enforces diagnostic configuration parameters to ensure deterministic model
behavior and unambiguous model-to-code equivalence. When diagnostics are set to
warning or none, Simulink may silently accept model configurations that produce
code whose behavior cannot be verified against the model semantics.

---

## 1. Algebraic loop (AlgebraicLoopMsg) — Nonfatal

**Required:** error

**Why:** Algebraic loops require iterative solvers at simulation time. The generated code may use a Newton-Raphson solver whose convergence behavior is not guaranteed to match simulation results. SLCI cannot verify model-to-code equivalence when execution depends on solver iterations with no deterministic closed-form representation in C.

**Fix:**
```matlab
set_param('model', 'AlgebraicLoopMsg', 'error');
```

---

## 2. Behavior when a matching unit test for subsystem reference is missing (SubsystemReferenceDiagnosticForUnitTest) — Nonfatal

**Required:** error

**Why:** Subsystem references generate code in a separate compilation unit. SLCI inspects each subsystem reference independently using the unit test harness as the entry point for code inspection. Without a matching unit test, SLCI has no way to invoke the referenced subsystem's generated code in isolation and cannot perform model-to-code traceability verification.

**Fix:**
```matlab
set_param('model', 'SubsystemReferenceDiagnosticForUnitTest', 'error');
```

---

## 3. Multitask data transfer (MultiTaskRateTransMsg) — Nonfatal

**Required:** error

**Why:** In a multitasking environment, data transferred between tasks at different rates can be corrupted if one task preempts another mid-write. The generated code must include explicit rate transition buffers. If this diagnostic is not an error, Simulink may generate code without proper protection, and SLCI cannot guarantee that code execution matches single-rate simulation semantics.

**Fix:**
```matlab
set_param('model', 'MultiTaskRateTransMsg', 'error');
```

---

## 4. Multitask conditionally executed subsystem (MultiTaskCondExecSysMsg) — Nonfatal

**Required:** error

**Why:** A conditionally executed subsystem operating across multiple rates introduces non-deterministic execution ordering. The enable/trigger signal and the subsystem may execute in different tasks, causing race conditions in generated code that do not exist in single-rate simulation. SLCI requires this diagnostic as error to prevent unverifiable multitask interactions.

**Fix:**
```matlab
set_param('model', 'MultiTaskCondExecSysMsg', 'error');
```

---

## 5. Detect downcast (ParameterDowncastMsg) — Nonfatal

**Required:** error

**Why:** When a parameter value is downcast to a narrower type, silent truncation changes the effective value used in generated code. The simulation may use the full-precision value while generated code uses the truncated value. SLCI cannot prove equivalence between simulation and code when parameter values are silently modified during type conversion.

**Fix:**
```matlab
set_param('model', 'ParameterDowncastMsg', 'error');
```

---

## 6. Parameters: Detect overflow (ParameterOverflowMsg) — Nonfatal

**Required:** error

**Why:** Parameter overflow causes the stored value in generated code to differ from the intended design value. The simulation environment may handle overflow differently than the target C compiler, leading to divergent behavior. SLCI requires this diagnostic as error to ensure all parameter values are representable in their declared types.

**Fix:**
```matlab
set_param('model', 'ParameterOverflowMsg', 'error');
```

---

## 7. Signals: Wrap on overflow (IntegerOverflowMsg) — Nonfatal

**Required:** error

**Why:** Signed integer overflow is undefined behavior in C. The simulation may produce a wrapped result while generated code may exhibit arbitrary compiler-dependent behavior based on the assumption that overflow never occurs. SLCI cannot verify model-to-code equivalence when the C code contains undefined behavior.

**Fix:**
```matlab
set_param('model', 'IntegerOverflowMsg', 'error');
```

---

## 8. Saturate on overflow (IntegerSaturationMsg) — Nonfatal

**Required:** error

**Why:** When saturation is silently applied without error, the model may produce clamped outputs that mask design errors. The generated saturation code adds branches that may not be exercised during testing, and SLCI must verify that saturation behavior in code matches simulation exactly. Requiring error detection ensures the designer explicitly handles overflow conditions.

**Fix:**
```matlab
set_param('model', 'IntegerSaturationMsg', 'error');
```

---

## 9. Detect underflow (ParameterUnderflowMsg) — Nonfatal

**Required:** error

**Why:** Parameter underflow causes a negative value to be stored as a large positive value in an unsigned type, or a very small value to be rounded to zero in a fixed-point type. The generated code will use the wrapped/rounded value, which differs from the designer's intent. SLCI requires this error to ensure parameter values are within representable range for exact model-to-code correspondence.

**Fix:**
```matlab
set_param('model', 'ParameterUnderflowMsg', 'error');
```

---

## 10. Detect loss of tunability (ParameterTunabilityLossMsg) — Nonfatal

**Required:** error

**Why:** When tunability is lost, a parameter the designer expects to be modifiable at runtime is folded into code as a compile-time constant. The code structure (inlined constant vs. RAM variable) changes the verification scope. SLCI requires this diagnostic as error because the model-to-code mapping fundamentally changes when parameters are inlined.

**Fix:**
```matlab
set_param('model', 'ParameterTunabilityLossMsg', 'error');
```

---

## 11. Underspecified initialization detection (UnderspecifiedInitializationDetection) — Nonfatal

**Required:** Simplified

**Why:** The Classic initialization detection mode allows states to be initialized based on execution order, which may differ between simulation and code generation. The Simplified mode provides deterministic initialization semantics that produce identical behavior in simulation and generated code. SLCI requires Simplified mode to ensure initialization behavior is unambiguous and verifiable.

**Fix:**
```matlab
set_param('model', 'UnderspecifiedInitializationDetection', 'Simplified');
```

---

## 12. Multitask data store (MultiTaskDSMMsg) — Nonfatal

**Required:** error

**Why:** Data Store Memory accessed from multiple tasks without synchronization creates a race condition. The simulation executes sequentially and always sees consistent data, but multitasking generated code may read partially-written values. SLCI requires this diagnostic as error to prevent unverifiable concurrent access patterns.

**Fix:**
```matlab
set_param('model', 'MultiTaskDSMMsg', 'error');
```

---

## 13. Detect non-reused custom storage classes (RCSCRenamedMsg) — Nonfatal

**Required:** error (when your model contains a Reusable storage class)

**Why:** When a Reusable custom storage class signal is renamed instead of shared, the generated code structure does not match the designer's intent -- multiple separate variables exist where one shared variable was expected. SLCI cannot verify that model semantics (shared data) match code semantics (separate variables) when renaming occurs silently.

**Fix:**
```matlab
set_param('model', 'RCSCRenamedMsg', 'error');
```

---

## 14. Bus signal treated as vector (StrictBusMsg) — FATAL

**Required:** error

**Why:** When a bus signal is treated as a vector, structured type information (field names, heterogeneous types) is flattened into a homogeneous array. The generated code may use either a struct or array representation, creating a fundamental ambiguity in the model-to-code mapping. This is FATAL because SLCI cannot establish any valid equivalence relationship when the data representation is ambiguous.

**Fix:**
```matlab
set_param('model', 'StrictBusMsg', 'error');
```

---

## 15. Non-bus signals treated as bus signals (NonBusSignalsTreatedAsBus) — FATAL

**Required:** error

**Why:** When a non-bus (vector) signal is implicitly treated as a bus, the generated code has an irreconcilable type mismatch -- the source produces an array while the destination expects a struct. This is FATAL because the memory layout of arrays and structs may differ (padding, alignment), making it impossible for SLCI to verify that data flows correctly in generated code.

**Fix:**
```matlab
set_param('model', 'NonBusSignalsTreatedAsBus', 'error');
```

---

## 16. Unexpected backtracking (SFUnexpectedBacktrackingDiag) — Nonfatal

**Required:** error

**Why:** Unexpected backtracking causes transition actions to execute even when the overall transition does not complete. The generated code executes side effects that are then "undone" logically by taking a different path, but the side effects remain. SLCI cannot verify model-to-code equivalence when the execution path includes actions that should not have occurred according to the final state transition outcome.

**Fix:**
```matlab
set_param('model', 'SFUnexpectedBacktrackingDiag', 'error');
```

---

## 17. Invalid input data access in chart initialization (SFInvalidInputDataAccessInChartInitDiag) — Nonfatal

**Required:** error

**Why:** During chart initialization, input ports may not yet contain valid data because upstream blocks have not executed. Accessing input data during initialization reads uninitialized or stale memory in generated code, while simulation may provide default values. SLCI cannot prove equivalence when code reads potentially uninitialized values that simulation does not.

**Fix:**
```matlab
set_param('model', 'SFInvalidInputDataAccessInChartInitDiag', 'error');
```

---

## 18. No unconditional default transitions (SFNoUnconditionalDefaultTransitionDiag) — Nonfatal

**Required:** error

**Why:** Without an unconditional default transition, the chart may never enter an active state. The generated code will contain unreachable paths and undefined state configurations. SLCI requires deterministic state entry at initialization to verify that generated code's state machine behavior matches the model for all execution paths from startup.

**Fix:**
```matlab
set_param('model', 'SFNoUnconditionalDefaultTransitionDiag', 'error');
```

---

## 19. Transition outside natural parent (SFTransitionOutsideNaturalParentDiag) — Nonfatal

**Required:** error

**Why:** Transitions that cross parent state boundaries produce complex exit/entry action sequences whose ordering is difficult to predict and verify. The generated code must correctly sequence all exit actions up the hierarchy and entry actions down to the target. SLCI requires this diagnostic as error because implicit state exits make it difficult to verify that generated code correctly implements intended state transition semantics.

**Fix:**
```matlab
set_param('model', 'SFTransitionOutsideNaturalParentDiag', 'error');
```

---

## 20. Unreachable execution path (SFUnreachableExecutionPathDiag) — Nonfatal

**Required:** error

**Why:** Unreachable execution paths indicate logical errors in the state machine design. The generated code contains dead code branches that can never execute. SLCI cannot verify model-to-code equivalence for unreachable paths, and the presence of dead code suggests the model does not implement the designer's intended logic.

**Fix:**
```matlab
set_param('model', 'SFUnreachableExecutionPathDiag', 'error');
```

---

## 21. Undirected event broadcasts (SFUndirectedBroadcastEventsDiag) — Nonfatal

**Required:** error

**Why:** Undirected event broadcasts cause all states in the chart to evaluate the event, potentially triggering transitions in an order that depends on graphical layout. The resulting execution order in generated code may not match simulation if the compiler reorders evaluations. SLCI requires directed broadcasts to ensure deterministic, verifiable event handling.

**Fix:**
```matlab
set_param('model', 'SFUndirectedBroadcastEventsDiag', 'error');
```

---

## 22. Transition action specified before condition action (SFTransitionActionBeforeConditionDiag) — Nonfatal

**Required:** error

**Why:** When a transition action is specified before the condition action, it executes regardless of whether the condition evaluates to true. This produces side effects in generated code that occur even when the transition is not taken. SLCI cannot verify equivalence when actions execute unconditionally but the transition is conditional -- the model intent is ambiguous.

**Fix:**
```matlab
set_param('model', 'SFTransitionActionBeforeConditionDiag', 'error');
```

----

Copyright 2026 The MathWorks, Inc.

----
