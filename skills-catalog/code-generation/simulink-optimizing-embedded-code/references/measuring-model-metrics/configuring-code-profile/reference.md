# Configuring Code Profile

> **Release compatibility:** MATLAB R2023a and later.

Autonomous decision engine for configuring Simulink model profiling. Used by the `simulink-optimizing-embedded-code` skill at the start of Phase 2 (baseline) and Phase 4 (re-measurement) to determine the optimal profiling configuration.

## Inputs

This sub-skill expects the following context to already be established by the calling skill (simulink-optimizing-embedded-code Phase 1):

- **Hardware target**: e.g., `'Generic->32-bit x86 compatible'` or `'Texas Instruments->C2000'`
- **Board connectivity**: Whether a physical board is connected
- **Optimization goal**: maximize execution speed, minimise RAM, balance RAM/speed, MISRA C:2012 compliance, traceability, or safety precautions
- **Phase**: `'baseline'` (first run) or `'remeasure'` (subsequent runs)
- **Target functions** (if any): User-specified functions to focus on (available after Phase 2.5)

## Decision Framework

### Decision 1: codegen vs SIL vs PIL

| Condition | Decision | Rationale |
|-----------|----------|-----------|
| User only needs static code analysis (code structure, CRL replacements, code size) — no execution-time or runtime measurements needed. **NOT permitted when GOAL = speed or balance** (runtime optimization requires SIL/PIL for execution-time measurement). | **codegen** | Fastest mode; runs `slbuild` to generate code only. No profiling, no execution timing. A one-time SIL verification runs at finalization (Phase 5) to confirm numerical correctness. Use when the user says things like "just generate code", "check CRL replacements", "analyze code size", "look at the generated code", or when the goal is purely about code quality/structure/ROM/RAM-only |
| User needs execution-time measurements AND hardware is generic/desktop (e.g., `Generic->32-bit x86 compatible`, `Generic->MATLAB Host Computer`) | **SIL** | No real target; host-simulated timing is the best available |
| User needs execution-time measurements AND hardware is a real MCU/board (e.g., `Texas Instruments->C2000`, `ARM Cortex-M`, `STMicroelectronics->STM32`) AND board is connected | **PIL** | On-target timing is available and more accurate |
| User needs execution-time measurements AND hardware is a real MCU/board but board is NOT connected | **SIL** | Fall back to host simulation; inform user that PIL would give better timing if board is connected |

Record the decision as `verificationMode` = `'codegen'`, `'SIL'`, or `'PIL'`.

**Note:** When `verificationMode = 'codegen'`, Decisions 2 and 3 (report level, profiling focus) are irrelevant and ignored by `configureProfilingMode`. The codegen path just runs `slbuild(modelName)` — no profiling is configured.

### Decision 2: Coarse vs Detailed Report Level

| Condition | Decision | Rationale |
|-----------|----------|-----------|
| Phase is `'baseline'` (first run ever) | **Coarse** | Saves tokens; gives task-level overview sufficient for user to identify target functions |
| Phase is `'remeasure'` and no `targetFunctions` specified | **Coarse** | Still exploratory |
| Phase is `'remeasure'` and `targetFunctions` are specified AND all are visible in the coarse report | **Coarse** | Coarse granularity is sufficient for the targets |
| Phase is `'remeasure'` and `targetFunctions` are specified but some are NOT visible in the coarse report | **Detailed** | Need per-function granularity to see the targeted functions |
| User explicitly requests detailed | **Detailed** | User override |

Record the decision as `reportLevel` = `'coarse'` or `'detailed'`.

**What coarse vs detailed controls:**
- **Coarse**: Sets `CodeProfilingInstrumentation` to `'coarse'`. Only task-level profiling sections are instrumented. The report contains fewer function entries (typically just the step/init functions and major task entry points). Faster execution, smaller report, fewer tokens.
- **Detailed**: Sets `CodeProfilingInstrumentation` to `'detailed'`. Every generated function is individually instrumented. The report contains per-function execution time, enabling fine-grained hotspot analysis. Slower execution, larger report, more tokens.

### Decision 3: Time vs Stack Profiling Focus

This decision controls which profiling checkbox is enabled in the model configuration. These are **separate Simulink parameters that conflict — only one can be active at a time**:

- **Code execution time profiling** → `CodeExecutionProfiling` = `'on'`/`'off'` ("Measure task execution time" checkbox). When on, the `CodeProfilingInstrumentation` dropdown (`'coarse'`/`'detailed'`) controls function-level granularity, and `CodeProfilingSaveOptions` = `'AllData'` captures full data.
- **Code stack profiling** → `CodeStackProfiling` = `'on'`/`'off'` ("Measure task stack usage" checkbox). When on, stack usage per task is measured and saved to the `stackProfile` workspace variable.

WARN **These two settings are mutually exclusive.** Enabling both causes a conflict. The script enforces this by disabling one before enabling the other.

| Optimization Goal | Profiling Focus | What gets enabled |
|-------------------|-----------------|-------------------|
| Maximize execution speed / "make it faster" | **Time** | `CodeExecutionProfiling = 'on'`, `CodeStackProfiling = 'off'` |
| Minimise RAM / "reduce memory" / "reduce stack" | **Stack** | `CodeExecutionProfiling = 'off'`, `CodeStackProfiling = 'on'` |
| Balance RAM/speed / general "optimize" | **Time first** | Start with time profiling. After the user reviews time results and applies optimizations, switch to stack profiling in a later re-measure cycle to cover the other dimension. |
| MISRA C:2012 compliance | **Time** | `CodeExecutionProfiling = 'on'`, `CodeStackProfiling = 'off'`. Profiling is secondary; primary focus is rule-checking, but time profiling provides a baseline for any performance regressions from compliance changes. |
| Traceability | **Time** | `CodeExecutionProfiling = 'on'`, `CodeStackProfiling = 'off'`. Profiling is secondary; used to establish a baseline before traceability instrumentation changes. |
| Safety precautions | **Stack** | `CodeExecutionProfiling = 'off'`, `CodeStackProfiling = 'on'`. Stack analysis is critical for safety — must verify no stack overflows under worst-case paths. |

Record the decision as `profilingFocus` = `'time'` or `'stack'`.

### Decision 4: Enable CRL Report

The Code Replacement Library (CRL) report shows which target-optimized library functions (e.g., `fabsf`, `CLAsin`, IQmath intrinsics) replaced standard math/operator calls in the generated code. This is only meaningful when the model has a real hardware board configured.

| Condition | Decision | Rationale |
|-----------|----------|-----------|
| Hardware is a real MCU/board (not generic) AND board is connected | **true** | CRL replacements are active; the report reveals which functions were replaced and which were missed — useful for identifying optimization opportunities |
| Hardware is a real MCU/board but board is NOT connected | **true** | CRL is still configured via the hardware board setting; replacements happen at code generation time regardless of board connectivity |
| Hardware is generic/desktop | **false** | No target-specific CRL is active; the report would be empty or meaningless |

Record the decision as `enableCRL` = `true` or `false`.

## Prerequisite: ERT-Based Target Required for SIL/PIL

**Before calling `configureProfilingMode`**, check the model's system target file:

```matlab
stf = get_param('<model>', 'SystemTargetFile');
```

If `verificationMode` is `'SIL'` or `'PIL'` and the system target file is NOT ERT-based (i.e., it is `grt.tlc`, `rsim.tlc`, or any non-`ert` target), **STOP immediately**. Do NOT call `configureProfilingMode`. Do NOT attempt to manually reconfigure the model's target or profiling parameters.

Inform the user:

> *"This model uses `<stf>` (Generic Real-Time target), which does not support SIL/PIL simulation. SIL/PIL requires an Embedded Coder target (`ert.tlc`). You have two options:*
> 1. *Switch the system target file to `ert.tlc` in the model configuration (Code Generation pane) and re-run — this enables full execution-time profiling.*
> 2. *Continue in codegen mode instead — I can still generate code and analyze static metrics (RAM, ROM, stack, complexity), but I won't be able to measure or optimize execution time.*
>
> *Which would you prefer?"*

**ERT-based targets** include: `ert.tlc`, `ert_shrlib.tlc`, and any target whose name contains `ert` (e.g., vendor-specific ERT-derived targets like `ert_linux.tlc`). When in doubt, check if the target name contains the substring `ert`.

If `verificationMode` is `'codegen'`, this check does not apply — codegen works with any system target file.

## How to Apply Decisions

After making all four decisions and confirming the prerequisite above, run the configuration script:

```matlab
addpath(fullfile('<skill_root>', 'scripts'));
configureProfilingMode('<model>', '<verificationMode>', '<reportLevel>', '<profilingFocus>', <enableCRL>);
```

Where:
- `verificationMode` is `'codegen'`, `'SIL'`, or `'PIL'`
- `reportLevel` is `'coarse'` or `'detailed'` (ignored for codegen)
- `profilingFocus` is `'time'`, `'stack'`, or `'both'` (ignored for codegen)
- `enableCRL` is `true` or `false`

The script handles all `set_param` calls for simulation mode, profiling instrumentation, static code metrics, etc.

After configuration, return control to the `simulink-optimizing-embedded-code` skill to run:
- **codegen:** `CodeMetricsFetcherCodegen('<model>')` — runs normal simulation (with signal logging), then `slbuild` + static metrics extraction
- **SIL:** `CodeMetricsFetcherSIL` — runs SIL simulation with profiling
- **PIL:** `CodeMetricsFetcherPIL` — runs PIL simulation with profiling

## Escalation Logic: Coarse → Detailed

After the coarse baseline run and user-directed function targeting (Phase 2.5 in simulink-optimizing-embedded-code), the agent must check whether the user's target functions are visible in the coarse report.

**Decision process:**
1. The user says: *"I want to focus on functions X, Y, Z"*
2. Check if X, Y, Z all appear in the coarse report summary (the sub-task will have listed the function names)
3. If YES → stay coarse. `reportLevel = 'coarse'` is sufficient.
4. If NO → escalate. `reportLevel = 'detailed'` is needed. Re-run with detailed mode, but the sub-task should ONLY extract data for the target functions (not the whole report).

## Output to Calling Skill

After running this sub-skill's decision logic, the agent should have four values ready:
- `verificationMode`: `'codegen'`, `'SIL'`, or `'PIL'`
- `reportLevel`: `'coarse'` or `'detailed'` (only relevant for SIL/PIL)
- `profilingFocus`: `'time'` or `'stack'` (only relevant for SIL/PIL)
- `enableCRL`: `true` or `false`

These inform:
1. Whether to use `CodeMetricsFetcherCodegen` (codegen) or `CodeMetricsFetcherSIL`/`CodeMetricsFetcherPIL` (SIL/PIL)
2. What `reportLevel` argument to pass (SIL/PIL only)
3. How to scope the analysis prompts
4. Whether to include CRL replacement analysis in the optimization report

## Risk / Alert — Known Failure Modes

| ID | Risk | Symptom | Triggered By | Mitigation |
|----|------|---------|-------------|------------|
| CP-01 | Time + Stack conflict | Build error or silent override when both profiling modes enabled | Forgetting mutual exclusivity of `CodeExecutionProfiling` and `CodeStackProfiling` | `configureProfilingMode.m` enforces this — never set both manually via `set_param` |
| CP-02 | CRL report on generic target | Empty/meaningless CRL report | `enableCRL = true` when hardware is generic | Decision 4 table already guards this — verify `ENABLE_CRL` matches hardware |
| CP-03 | Wrong verification mode carried forward | SIL used instead of PIL (or vice-versa) | State object `VERIFICATION_MODE` overridden without re-evaluating Decision 1 | Always re-read Decision 1 conditions at Phase 4 entry if hardware context changed |
| CP-04 | Detailed mode token blow-up | Report is 10×+ larger, main context overwhelmed | Escalating to `'detailed'` without scoping the sub-task to target functions only | Always scope the detailed sub-task to `targetFunctions`; never read the full detailed report |
| CP-05 | MultiThreadedLoops blocks profiling | SIL/PIL hard-fails: "Execution-time profiling for functions does not support generated parallel for-loops" | `MultiThreadedLoops='on'` while `CodeProfilingInstrumentation` is `'coarse'` or `'detailed'` (set automatically by this script during time profiling) | Before configuring time profiling, check if `MultiThreadedLoops='on'`; if so, temporarily disable it (`set_param(model,'MultiThreadedLoops','off')`) and warn the user. Re-enable after measurement. |
| CP-06 | Non-ERT target with SIL/PIL | `configureProfilingMode` fails on unsupported parameters (e.g., `TargetOS`) or agent manually reconfigures model bypassing the script | Model uses `grt.tlc` or another non-ERT target and `verificationMode` is `'SIL'` or `'PIL'` | Check `SystemTargetFile` before calling `configureProfilingMode`. If not ERT-based, STOP and inform the user — do NOT call the script or manually set parameters |


----

Copyright 2026 The MathWorks, Inc.

----