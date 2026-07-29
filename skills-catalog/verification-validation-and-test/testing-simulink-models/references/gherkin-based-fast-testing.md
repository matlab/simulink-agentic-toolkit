# Gherkin-Based Testing (model_test)

Ephemeral, fast pass/fail tests using the `model_test` MCP tool. Write a `.feature` file in the custom Gherkin dialect below, then pass it to `model_test`.

## Constraints

- Component under test must have at least one Inport and one Outport
- No physical modeling ports (PMIOPort / Simscape Connection Port) — test a parent subsystem with signal-based I/O instead
- If the model contains Simscape elements, set `SimscapeLogType` to `"none"` before running: `set_param('ModelName', 'SimscapeLogType', 'none')`

## Syntax Reference

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
# WRONG - starts with keyword:
  When input changes, output responds
# Rephrase:
  If input changes, output responds
# Or escape with *:
  * When input changes, output responds
```

## Best Practice

Prefer subsystem component-level tests — top-level models can be large and slow, while subsystem components offer faster iteration, isolation, and clearer failure diagnosis.

## Draft Mode

Pass `draft_mode='true'` for rapid test iteration (~3s vs ~60s). Draft mode skips the main model compile and uses a lightweight harness. Use `'true'` by default during test development.

**Limitation:** Draft-mode harness uses double scalar for all inputs and outputs. If the model under test has non-double ports (boolean, integer, single, bus, vector), draft mode will fail with data type mismatch errors. In that case, re-run with `draft_mode='false'`.

## Coverage

Pass `coverage='none'` (default) or `coverage='decision'` when calling `model_test`. Use `'decision'` to collect both execution and decision coverage metrics (requires Simulink Coverage toolbox).

----

Copyright 2026 The MathWorks, Inc.

----
