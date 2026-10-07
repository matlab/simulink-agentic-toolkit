# Solver Configuration Parameter Constraints

SLCI verifies model-to-code equivalence by ensuring that the generated code has
deterministic, periodic execution semantics that map directly to model elements.
The Solver category contains parameters that control how Simulink advances time
and schedules tasks. Incorrect settings produce code with adaptive logic, hidden
blocks, or concurrency primitives that SLCI cannot trace back to model elements.

---

## 1. Type (SolverType) — Nonfatal

**Required:** Fixed-step

**Why:** Variable-step solvers produce adaptive step-size algorithms, error estimation logic, and solver state management code that has no corresponding element in the Simulink model diagram. SLCI requires a known, fixed execution schedule and one-to-one traceability between model elements and generated code constructs.

**Fix:**
```matlab
set_param('model_name', 'SolverType', 'Fixed-step');
```

---

## 2. Solver (Solver) — Nonfatal

**Required:** FixedStepDiscrete

**Why:** Continuous-time solvers generate numerical integration code (Runge-Kutta stages, derivative computations) that implements the solver algorithm rather than model semantics. These multi-stage solver routines have no direct model-element correspondence, breaking SLCI's traceability requirement.

**Fix:**
```matlab
set_param('model_name', 'Solver', 'FixedStepDiscrete');
```

---

## 3. Periodic sample time constraint (SampleTimeConstraint) — Nonfatal

**Required:** Unconstrained or STIndependent

**Why:** Other constraint values can force sample times to specified values, causing the generated code's rate structure to diverge from what the model diagram shows. SLCI requires that the sample-time structure visible in the model matches the rate structure in the generated code.

**Fix:**
```matlab
set_param('model_name', 'SampleTimeConstraint', 'Unconstrained');
% Or:
set_param('model_name', 'SampleTimeConstraint', 'STIndependent');
```

---

## 4. Treat each discrete rate as a separate task (EnableMultiTasking) — Nonfatal

**Required:** on (for multi-rate models)

**Why:** When disabled in a multi-rate model, all rates merge into a single step function with conditional logic that has no corresponding element in the model. SLCI requires each rate to produce a distinct, separately verifiable code function so it can cleanly associate each code segment with its corresponding model rate.

**Fix:**
```matlab
set_param('model_name', 'EnableMultiTasking', 'on');
```

---

## 5. Automatically handle rate transition for data transfer (AutoInsertRateTranBlk) — Nonfatal

**Required:** off

**Why:** When enabled, Simulink silently inserts Rate Transition blocks that do not appear in the user's model diagram. The generated code contains buffer operations corresponding to these invisible blocks, making it impossible for SLCI to map code back to visible model elements and breaking the one-to-one traceability requirement.

**Fix:**
```matlab
set_param('model_name', 'AutoInsertRateTranBlk', 'off');
```

---

## 6. Allow tasks to execute concurrently on target (ConcurrentTasks) — Nonfatal

**Required:** off

**Why:** Concurrent task execution generates synchronization primitives (mutexes, semaphores) that have no representation in the Simulink model. Additionally, concurrent execution makes task interleaving non-deterministic at runtime, and SLCI requires deterministic execution semantics to prove equivalence.

**Fix:**
```matlab
set_param('model_name', 'ConcurrentTasks', 'off');
```

----

Copyright 2026 The MathWorks, Inc.

----
