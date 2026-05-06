---
name: testing-simulink-models
description: Creates persistent Gherkin-based pass/fail tests for Simulink models and individual subsystems using model_test. Use when verifying expected behavior, writing regression tests, reproducing issues, or validating bug fixes with structured assertions. Requires Simulink Test.
license: MathWorks BSD-3-Clause
metadata:
  author: MathWorks
  version: "1.0"
---

# Simulink Gherkin Tests

Requires **Simulink Test**. If unavailable, use `simulating-simulink-models` with manual assertions.

Use this skill when you need persistent, reusable pass/fail verification of model behavior.

## When to Use

- Writing persistent pass/fail tests for a Simulink model or subsystem
- Verifying expected behavior against requirements or acceptance criteria
- Creating regression tests to catch future breakage
- Reproducing and validating bug fixes with structured assertions
- Collecting decision coverage metrics for a component

## When NOT to Use

- **Building or editing model structure** → use `building-simulink-models`
- **Running simulations for data exploration, sweeps, or custom analysis** → use `simulating-simulink-models`
- **Querying or resolving parameter values** → use `model_query_params` / `model_resolve_params`
- **Simulink Test is not installed** → use `simulating-simulink-models` with manual assertions
- **Component has no inputs or no outputs** → model_test requires at least one Inport and one Outport; use `simulating-simulink-models` instead
- **Component has physical modeling (Simscape) ports** → test a parent subsystem with signal-based I/O instead

## Workflow

1. **Understand the component:** Use `model_overview` and `model_read` on the target subsystem to identify inputs, outputs, and expected behavior.
2. **Write the `.feature` file:** Author a Gherkin test following the Syntax Reference below. Start with one scenario covering the primary nominal case.
3. **Run in draft mode:** Call `model_test` with `draft_mode='true'` for rapid iteration (~3s). Fix syntax or signal errors.
4. **Run full compilation:** Once draft passes, re-run with `draft_mode='false'` to validate against the actual compiled model (catches type/dimension mismatches).
5. **Expand coverage:** Add scenarios for edge cases, fault conditions, and boundary behavior. Use `coverage='decision'` to identify untested branches.

## Syntax Reference

Write a `.feature` file in this format, then pass it to `model_test`:

```gherkin
# --- front-matter:toml ---                # REQUIRED: exactly one, must be first in file
model = "Model.slx"                        # model filename with .slx extension
component = "Model/Subsystem"              # optional; default = model name without .slx
[inputs]                                   # alias = "portReference" for each input port
Speed = "Speed"                            # scalar port: just the port name
Torque = "'Torque (Nm)'"                   # single quotes if name contains ( ) or .
Pos = "Position(2)"                        # vector element: "PortName(N)"
Cmd = "Control.Throttle"                   # bus element: "PortName.Element"
[outputs]                                  # alias = "portReference" for each output port
Output = "Output"                          # scalar port
Force = "'Force (N)'"                      # single-quoted scalar port
Yaw = "'Rate (deg/s)'.Filtered(2)"         # single-quoted port with vectorized bus element
# --- end front-matter ---                 # markers must be exact as shown

Feature: Descriptive title                 # exactly one Feature, colon required directly after keyword
  Description text here.                   # descriptions cannot start with keywords; prefix * to escape

Scenario: Unique scenario title            # at least one Scenario, unique titles, colon required
  Description of test case.
  Given inputs                             # exactly one Given; MUST have * line for EVERY declared input
    * Speed = const(50)                    # const(<value>)
    * Torque = step(0 -> 100 @ 1s)         # step(<from> -> <to> @ <time>)  time: Ns or Nms
  When simulate for 5s in Normal mode      # EXACT syntax; duration: Ns or Nms (>0); mode: Normal|SIL
  Then baseline "ref.mat" with tolerances: absTol=0.01, relTol=0.01, timeTol=50ms
    * Output: absTol=0.001                 # per-signal tolerance override; defaults are 0
  Then outputs                             # 1-2 Then blocks allowed (baseline and/or outputs)
    * Positive: Output > 0                 # operators: == != < > <= >=  (never vs another signal)
    * Bounded: Output == [10 .. 90]        # ranges with == only: [a..b] (a..b) [a..b) (a..b]
    * Settled: Output > 80 when t > 3s     # conditional: when t <op> <time>
    * InRange: Output == (0 .. 100]        # assessment names must be unique
```

**Not supported:** `And` `But` `Rule` `Example` `@tags` `|tables|` `"""`

## Description Line Escape

```gherkin
# ❌ WRONG - starts with keyword:
  When input changes, output responds
# ✅ Rephrase:
  If input changes, output responds
# ✅ Or escape with *:
  * When input changes, output responds
```

## Best Practice

Prefer subsystem component-level tests—top level models can be large and slow to update/test, while subsystem components offer faster iteration, isolation, and clearer failure diagnosis. Use judgment based on what you're verifying.

The component under test must not contain physical modeling ports (PMIOPort / Simscape Connection Port blocks). Only components with standard Simulink Inport/Outport interfaces are supported. If the subsystem you want to test has physical ports, test a parent subsystem that wraps it with signal-based I/O instead.

If the model contains Simscape elements, set the model parameter `SimscapeLogType` to `"none"` before running tests. Simscape logging can interfere with test harness signal routing. This is a one-time model configuration, not a simulation command. Use: `set_param('ModelName', 'SimscapeLogType', 'none')`.

## Coverage

Pass `coverage='none'` (default) or `coverage='decision'` when calling `model_test`. The `coverage` parameter is required. Use `'decision'` to collect both execution and decision coverage metrics (requires Simulink Coverage toolbox). Use `'none'` when coverage is not needed.

## Draft Mode

Pass `draft_mode='true'` for rapid test iteration (~3s vs ~60s). Draft mode skips the main model compile and uses a lightweight harness. Use `'true'` by default during test development.

**Limitation:** Draft-mode harness uses double scalar for all inputs and outputs. If the model under test has non-double ports (boolean, integer, single, bus, vector), draft mode will fail with data type mismatch errors. In that case, re-run with `draft_mode='false'`.

## Directory Warning

Don't change MATLAB's working directory while a model is open. Test harness cache is directory-tied—changing it causes stale harness errors.

----

Copyright 2026 The MathWorks, Inc.

----
