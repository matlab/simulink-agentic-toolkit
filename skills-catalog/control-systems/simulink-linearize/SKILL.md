---
name: simulink-linearize
description: >
  Linearize Simulink models. Use when obtaining linear time invariant or linear parameter varying models from Simulink models.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Simulink Linearization

Extract linear time invariant (LTI) or linear parameter varying (LPV) models from Simulink using `linearize` and related APIs from Simulink Control Design.

## When to Use

- Obtaining a linear model (tf, ss, zpk) from a Simulink model
- Batch linearization across operating points and parameter variations
- Building LPV models with `ssInterpolant`
- Debugging linearization results (zero gain, unexpected dynamics)
- Extracting multiple LTI systems with a single model compile

## When NOT to Use

- Frequency response estimation from simulation — use `simulink-frequency-response` for frestimate-based fallback
- No Simulink model is involved

## Workflow

The linearization pipeline has four stages. Not every task requires all stages.

```
1. Define I/O Points 2. Operating Point  →  3. Linearize  →  4. Debug  
    (root level/linio)   (findop/operspec)     (linearize)     (advisor) 
```

### Stage 1: Define Linearization I/O Points

Determine I/O points using this decision sequence. Use the first case that applies:

**Case A — IO points can be inferred from prompt or model context:**

Use the first sub-case that matches:

1. **User specifies explicit I/O signals or blocks** (e.g., "from r to y") → define `linio` points. All `linio` points must reference a block's output port. If a candidate block has no output ports (Outport, Terminator, Scope) → trace upstream to find the source block and port with `model_read`.
   ```matlab
   io = [linio(sprintf("%s/InputBlock", mdl), 1, "input"); ...
         linio(sprintf("%s/OutputBlock", mdl), 1, "output")];
   ```

2. **User targets a specific block or subsystem** (e.g., "linearize the Controller") → Use the block path as the io argument signaling linearize to perform open-loop linearization of the block

   ```matlab
   io = sprintf("%s/Controller", mdl);
   ```

3. **Model has existing linearization points** → `io = getlinio(mdl);` — use if non-empty.

4. **Root-level Inport/Outport blocks exist** → omit `linio`. The `linearize` command will linearize about the model's root-level I/Os. Use `model_read` at root scope (depth `"0"`) to confirm root-level Inport/Outport blocks exist.

**Case B — Cannot determine IO points:**

If none of the above apply → **do not guess**. Ask the user which signals to use as linearization inputs and outputs. Present the available blocks/signals from the model to help them decide.

**Block path rules:**
- Use `sprintf` for block names containing special characters (newlines, commas):
  ```matlab
  blkPath = sprintf("%s/Integrator,\nSecond-Order", mdl);
  io = linio(blkPath, 1, "output");

  sub.Name = sprintf("%s/My\nBlock",mdl);
  sub.Value = replacement_lti;

  sys = linearize(mdl, io, sub);  
  ```

### Stage 2: Operating Point

Determine where to linearize. Choose one:

| Situation | Approach |
|-----------|----------|
| Model ICs | Skip — `linearize` uses model initial conditions |
| Steady-state trim | `operspec` → configure → `findop(mdl, opSpec, findopOptions(DisplayReport="off"))` |
| Need snapshot from simulation | `linearize(mdl, tSnapshot)` |
| Batch over parameter grid | Array of `operspec` objects → `findop(mdl, specArray, params)` |
| Operating points known | Array of `operpoint` objects → configure |

For batch workflows, use `copy` to create the operating point array:

```matlab
% assign varied variable to workspace
myvar = 0;
% create base spec
opBase = operspec(mdl);
opBase.States(1).Known = true;
% define param to vary
nPts = 5;
params.Name = "myvar";
params.Value = linspace(-pi, pi, nPts);
for i = nPts:-1:1
    opArray(i) = copy(opBase);
    opArray(i).States(1).x = params.Value(i);
end
ops = findop(mdl, opArray, params, findopOptions());
```

### Stage 3: Linearize

```matlab
sys = linearize(mdl, OPTIONAL_ARGS);
```

Each input argument to linearize is optional (beside `mdl`). 
```matlab
sys = linearize(mdl, io, op, params, blocksub, opts);
```

| Argument | Required | Behavior if Provided | Behavior if Omitted |
|----------|----------|----------------------|---------------------|
| mdl      | Y        | Model to linearize   | NA                  |
| io       | N        | linearize at I/O points | Linearize at root level I/Os | 
| op       | N        | Operating points OR times to linearize | Linearize at model IC |
| params   | N        | Vary parameters for each linearization | No variation |
| blocksub | N        | User specified block linearizations | Blocks have Simulink linearization |
| opts     | N        | User specified linearizeOptions | Default options |


**Multi-rate models** default to the LCM sample time. Use the `SampleTime` option to specify linear model sample time:

```matlab
opts = linearizeOptions(SampleTime=0);
sys = linearize(mdl, io, opts);
```

**Batch linearization for LPV:**

```matlab
opts = linearizeOptions(BatchConsistency="on", StoreOffsets="system");
sysArray = linearize(mdl, io, ops, params, opts);
lpvSys = ssInterpolant(sysArray);
```

When `StoreOffsets="system"`, offsets are embedded in each model of the array. Call `ssInterpolant(sysArray)` with no offset argument.

Define `SamplingGrid` if one is not generated from linearize (params argument is omitted).

**Multiple transfer functions (single compile) with `slLinearizer`:**

```matlab
sllin = slLinearizer(mdl);
addPoint(sllin, ["r", "y", "e", "u"]);
T = getIOTransfer(sllin, "r", "y");
S = getSensitivity(sllin, "e");
L = getLoopTransfer(sllin, "u", sign);
```

### Stage 4: Debug (Linearization Advisor)

Use when linearization returns zero gain or unexpected results.

```matlab
opts = linearizeOptions(StoreAdvisor=true);
[sys, ~, info] = linearize(mdl, io, opts);
advisorResult = advise(info.Advisor);
```

Always capture the output of `advise` — calling without an output argument launches the UI.

Inspect problematic blocks:

```matlab
problematic = find(advisorResult, linqueryHasDiagnostics());
for i = 1:numel(problematic.BlockDiagnostics)
    diag = problematic.BlockDiagnostics(i);
    fprintf('%s: %s\n', diag.BlockPath, join(string(diag.DiagnosticMessages), newline));
end
```

Common advisor findings and resolutions:

- **"linearization has zero input/output pair"** → Change operating point, or use block substitution if reasonable to do so
- **Block with hard discontinuity (PWM, relay, dead zone, non-floating point signals)** → Analytical linearization will be zero. Fall back to frequency response estimation
- Reference diagnostic message for other potential fixes

### Convert if needed

```matlab
tfSys = tf(sys);      % Transfer function
zpkSys = zpk(sys);    % Zero-pole-gain
```

### LPV Validation
For LPV models, simulate and compare against Simulink:

```matlab
[y, t] = lsim(lpvSys, u, tVec, x0, paramTrajectory);
```

## Key Functions

| Function | Purpose | Available From |
|----------|---------|----------------|
| `linearize` | Linearize Simulink model | R2006a |
| `linearizeOptions` | Configure linearization algorithm | R2006a |
| `linio` | Define linearization I/O points | R2006a |
| `getlinio` | Get I/O points defined in model | R2006a |
| `operpoint` | Create operating point with manual state values | R2006a |
| `operspec` | Create operating point specification | R2006a |
| `findop` | Trim or snapshot operating point | R2006a |
| `slLinearizer` | Batch/multi-transfer-function interface | R2013b |
| `getIOTransfer` | Closed-loop transfer function from slLinearizer | R2013b |
| `getSensitivity` | Sensitivity function from slLinearizer | R2013b |
| `getCompSensitivity` | Complementary sensitivity from slLinearizer | R2013b |
| `getLoopTransfer` | Open-loop transfer from slLinearizer | R2013b |
| `advise` | Run linearization advisor | R2017b |
| `ssInterpolant` | Build gridded LPV/LTV model | R2023a |

## Common Mistakes

| Mistake | Why It's Wrong | Correct Approach |
|---------|---------------|-----------------|
| Using `linmod`, `linmod2`, `linmodv5` or `dlinmod` | Legacy API, limited features | Use `linearize` or `slLinearizer` |
| Not using `advise` when result is zero | Leads to trial-and-error | Enable `StoreAdvisor="on"`, call `result = advise(info.Advisor)` |
| Using Outport/Terminator/Scope as `linio` point | Blocks without output ports cannot be specified as linearization I/O — errors | Trace upstream to find the source block that feeds it |
| `opSpec(i) = opSpecBase` in a loop | `operspec` is a handle class — this aliases, not copies | Use `opArray(i) = copy(opBase)` |
| Omitting `BatchConsistency` in batch | State ordering may vary across operating points | Always set `BatchConsistency="on"` |
| Calling `ssInterpolant` without offsets | LPV model requires offsets | Use `StoreOffsets="system"` |
| Calling `advise` without output arg | Launches Model Linearizer UI (hangs in non-interactive sessions) | Always use `result = advise(advisor)` |
| Repeated `linearize` calls for different I/Os | Recompiles model each time | Use `slLinearizer` for single compile |
| Manual trial-and-error for zero results | Wastes time, may not find root cause | Use advisor diagnostics — identify the problematic blocks |

## Conventions

- **Always:** Capture the output of `advise()` to prevent UI launch
- **Always:** Use `copy(opSpec)` for batch operating point arrays, not assignment
- **Always:** Set `BatchConsistency="on"` for batch linearization destined for LPV
- **Always:** Set `StoreOffsets="system"` when building LPV models with `ssInterpolant`
- **Prefer:** `slLinearizer` when extracting multiple transfer functions from one model
- **Never:** Place `linio` on blocks without output ports (Outport, Terminator, Scope) — trace upstream to find the source block
- **Never:** Use `linmod`, `linmod2`, `linmodv5` or `dlinmod` — these are legacy

----

Copyright 2026 The MathWorks, Inc.

----
