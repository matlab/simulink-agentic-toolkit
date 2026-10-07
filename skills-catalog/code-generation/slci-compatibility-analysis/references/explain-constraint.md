# Explaining Compatibility Constraints

When explaining a compatibility constraint, scale the depth of explanation to
the constraint's complexity and what the user asked.

## Minimum (always include)

1. **What SLCI requires** — the parameter name and its required value
2. **Why** — what breaks in structural equivalence verification
3. **Fix** — the parameter value or model change needed

## When to add code examples

Include generated code examples only when the failure mode is **non-obvious from
prose alone**. Constraints that benefit from code examples (~10-15 total):

- `AdvancedOptControl = -SLCI` — constant folding across blocks
- `MultiTaskCondExecSysMsg` — data race requires seeing two-task code
- `AutoInsertRateTranBlk` — hidden blocks producing untraceable code
- `GenerateComments` — block-path comments as SLCI's anchor mechanism
- `EfficientFloat2IntCast` — saturation branch expansion
- `ConcurrentTasks` — mutex/synchronization primitives in code
- Multi-rate enable/trigger signals crossing task boundaries

For simple config-param constraints (e.g., `TargetLang = C`, `SolverType =
Fixed-step`), the prose explanation is sufficient.

## When to add model diagrams

Include an ASCII block diagram only when the constraint involves **model topology**
(signal routing, rate boundaries, subsystem enable/trigger patterns). Omit for pure
configuration parameter constraints.

## Example: Deep explanation (non-obvious constraint)

### Multitask conditionally executed subsystem (`MultiTaskCondExecSysMsg`)

**What SLCI requires:** `MultiTaskCondExecSysMsg` must be `'error'`

**Example Model:**

```
Solver: Fixed-step, multitasking
Rate 1: 10ms (fast task)
Rate 2: 50ms (slow task)

[Sine Wave 10ms] ----> [Enabled Subsystem (10ms)] ----> Outport
                              ^
[Pulse Gen 50ms] ------------| (enable signal crosses rate boundary)
```

**Generated Code (without Rate Transition — the problem):**

```c
/* Fast task (10ms) */
void model_step0(void) {
    if (EnabledSubsystem_enabled) {       // reads enable flag — DATA RACE
        EnabledSubsystem_output();
    }
}

/* Slow task (50ms) */
void model_step1(void) {
    EnabledSubsystem_enabled = (PulseGen > 0);  // writes enable flag — no sync
}
```

**Why:** The fast task reads a flag that the slow task writes with no
synchronization. The code behavior depends on OS preemption timing, making it
non-deterministic. SLCI cannot verify model-to-code equivalence for
non-deterministic code.

**Fix:**
```matlab
set_param(mdl, 'MultiTaskCondExecSysMsg', 'error')
```
Then add a Rate Transition block before the enable signal.

## Example: Compact explanation (simple config constraint)

### Target language (`TargetLang`)

**What SLCI requires:** `TargetLang` must be `'C'`

**Why:** SLCI's verification engine parses C code only. C++ name mangling,
templates, and overloading produce constructs SLCI cannot trace to model elements.

**Fix:**
```matlab
set_param(mdl, 'TargetLang', 'C')
```

----

Copyright 2026 The MathWorks, Inc.

----
