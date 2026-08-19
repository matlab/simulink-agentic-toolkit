# Tool Routing Guide

> Which MCP tool to use for each task. This skill requires the Simulink Agentic Toolkit (SATK).

---

## Principle: Model-Edit-First

**Always prefer `model_edit` and other Simulink-native MCP tools** (`model_read`, `model_overview`, `model_query_params`) for ANY operation that touches model structure or block parameters. Use `evaluate_matlab_code` ONLY for the 5 operations listed below that have NO `model_edit` equivalent.

This prevents:
- Fragile `add_block`/`add_line` calls that require exact library paths
- Block name resolution failures (display name vs library path mismatches)
- Silent failures from set_param on non-existent parameters

## Tool Selection

| Task | Tool | Notes |
|------|------|-------|
| Add blocks | `model_edit` (add_block op) | Use `type` field with resolution rules below |
| Connect blocks | `model_edit` (connect op) | Port notation: `blk.y1 -> blk.u1` |
| Set block parameters | `model_edit` (configure op) | Same param names as Simulink mask |
| Set model config | `model_edit` (configure op) | Target: `config:ModelName` |
| Delete/replace blocks | `model_edit` (delete/replace_block op) | — |
| Inspect model structure | `model_read` | Use before editing existing models |
| Get model overview | `model_overview` | First step when opening unfamiliar model |
| Check parameter values | `model_query_params` | After configure, to verify |
| Resolve variable refs | `model_resolve_params` | When model_read shows `@Param(Kp)` |
| Compute PI gains, PU system | `evaluate_matlab_code` | mcb.* API calls — NO model_edit equivalent |
| Store workspace variables | `evaluate_matlab_code` | `assignin(mdlWks, ...)` — NO model_edit equivalent |
| Create new model | `evaluate_matlab_code` | `new_system(); save_system()` — NO model_edit equivalent |
| Run simulation | `evaluate_matlab_code` | `sim(mdl)` — NO model_edit equivalent |
| Post-processing / plots | `evaluate_matlab_code` | Analysis after sim — NO model_edit equivalent |

---

## Block Type Resolution Rules

The `model_edit` `add_block` operation resolves block types in this order:
1. Simulink built-in blocks (by display name)
2. Loaded library blocks (by display name)
3. Full library path (explicit)

### MCB Block Type Reference

| Block | `type` for model_edit | Notes |
|-------|----------------------|-------|
| **Resolves by name (no path needed):** | | |
| Clarke Transform | `"Clarke Transform"` | Resolves automatically via model_edit |
| Park Transform | `"Park Transform"` | Resolves automatically via model_edit |
| Inverse Park Transform | `"Inverse Park Transform"` | Resolves automatically via model_edit |
| Inverse Clarke Transform | `"Inverse Clarke Transform"` | Resolves automatically via model_edit |
| IIR Filter | `"IIR Filter"` | Resolves automatically via model_edit |
| Mechanical to Electrical Position | `"Mechanical to Electrical Position"` | Resolves automatically via model_edit |
| **Needs `mcbcontrolslib/` prefix:** | | |
| PI Controller (MCB) | `"mcbcontrolslib/PI Controller"` | Plain `"PI Controller"` gives slpidlib PID! |
| MTPA Control Reference | `"mcbcontrolslib/MTPA Control Reference"` | |
| PWM Reference Generator | `"mcbcontrolslib/PWM Reference Generator"` | |
| **Needs full path (short name is ambiguous or does not resolve):** | | |
| Average-Value Inverter | `"Average-Value Inverter"` | If ambiguous, use `model_edit` — SATK resolves from loaded libs |
| Field-Oriented Current Controller | `"mcbfoclib/Field-Oriented Current Controller"` | Short name does NOT resolve — full path required |
| PMSM FeedForward Control | `"PMSM FeedForward Control"` | Use display name; SATK resolves from loaded libs |
| Sliding Mode Observer | `"Sliding Mode Observer"` | Use display name; SATK resolves from loaded libs |
| **Plant blocks (need type name for model_edit):** | | |
| Interior PMSM | `"Interior PMSM"` | Use display name; SATK resolves from loaded libs |
| Surface Mount PMSM | `"Surface Mount PMSM"` | Use display name; SATK resolves from loaded libs |
| Induction Motor | `"Induction Motor"` | Use display name; SATK resolves from loaded libs |
| **Standard Simulink (by name):** | | |
| Constant, Sum, Gain, Mux, Demux | `"Constant"`, `"Sum"`, etc. | |
| Unit Delay | `"Unit Delay"` | |
| Bus Selector | `"Bus Selector"` | |
| Data Type Conversion | `"Data Type Conversion"` | |
| Math Function | `"Math Function"` | |
| Rate Transition | `"Rate Transition"` | |
| Bias | `"Bias"` | |
| Step | `"Step"` | Use `InitialValue`/`FinalValue` (NOT `Before`/`After`) |
| Scope | `"Scope"` | Set `NumInputPorts` if >1 signal needed (default=1) |
| To Workspace | `"To Workspace"` | Include in initial build for logging — see below |

**Step block note:** `model_edit` works for Step params when you use the correct Simulink parameter names: `InitialValue`, `FinalValue`, `Time`, `SampleTime`. The mask display names (`Before`, `After`) do NOT work. Example:
```json
{"op": "add_block", "type": "Step", "name": "SpdRef", "params": {"InitialValue": "0", "FinalValue": "speed_ref_rad", "Time": "0.1", "SampleTime": "Ts_speed"}}
```

**Scope block note:** Default Scope has 1 input port. To display multiple signals, set `NumInputPorts` in params OR use a Mux before the Scope:
```json
{"op": "add_block", "type": "Scope", "name": "Scope_Debug", "params": {"NumInputPorts": "3"}}
```

**Logging blocks — include in initial build:** Always add ToWorkspace blocks during the initial `model_edit` (layout_mode="full") call. Do NOT add them as an afterthought via `evaluate_matlab_code` / `add_block` — this violates the model-edit-first principle and is error-prone. See `composition-rules-integration.md` for the standard logging pattern.

**SATK Resolution Failures — Fallback Pattern:**

Some MCB blocks fail `model_edit` name resolution because SATK's internal library path mapping is version-dependent and may be stale. Known blocks that commonly fail:
- `Interior PMSM`, `Surface Mount PMSM`, `Induction Motor` (plant blocks)
- `Average-Value Inverter`, `BLDC Average-Value Inverter` (inverter blocks)
- `MTPA Control Reference`, `PMSM FeedForward Control` (control reference blocks)

**When `model_edit` returns "There is no block named..." error, use `evaluate_matlab_code` with dynamic resolution:**
```matlab
% Dynamic block resolution — finds block by name in mcblib, version-independent
if ~bdIsLoaded('mcblib'), load_system('mcblib'); end
blks = find_system('mcblib', 'SearchDepth', 5, 'Name', 'Interior PMSM');
refBlock = get_param(blks{1}, 'ReferenceBlock');
if isempty(refBlock), refBlock = getfullname(blks{1}); end
add_block(refBlock, [mdl '/PMSM']);
```

> **Note:** The above fallback uses raw Simulink APIs only as a last resort when model_edit cannot resolve the block name. Always try model_edit first with the display name.

**Do NOT hardcode library paths** like `mcblib/Control/Synchronous Machine/...` — these change between MATLAB releases. Always resolve dynamically.

**CRITICAL:** `"PI Controller"` resolves to `slpidlib/PID Controller` (Simulink standard). For MCB PI Controller, ALWAYS use `"mcbcontrolslib/PI Controller"`.

**STRONG RECOMMENDATION:** Prefer `"mcbcontrolslib/PI Controller"` for all FOC current and speed loops. It provides motor-control-correct defaults (discrete, Ki×Ts, clamping anti-windup). The standard `slpidlib/PID Controller` requires 8+ explicit parameters to work correctly in motor control — see `block-configurations.md` for details.

**NOTE:** `"mcbcontrolslib/PI Controller"` resolves internally to `slpidlib/PID Controller` with MCB presets applied (`UseKiTs='on'`, discrete PI mode, Forward Euler). After placement, `get_param(..., 'ReferenceBlock')` shows `slpidlib/PID Controller` — this is expected and correct. The Ki×Ts convention applies because `UseKiTs='on'` is preset. If you use `add_block('mcbcontrolslib/PI Controller', ...)` in `evaluate_matlab_code`, the presets are applied automatically. With `model_edit`, specify `"mcbcontrolslib/PI Controller"` as type — it works equivalently.

---

## Port Notation

model_edit uses `y` (output) and `u` (input) port notation:

| Port | model_edit notation | Equivalent set_param |
|------|-------------------|---------------------|
| Output port 1 | `.y1` | `/1` (outport) |
| Output port 2 | `.y2` | `/2` (outport) |
| Input port 1 | `.u1` | `/1` (inport) |
| Input port 2 | `.u2` | `/2` (inport) |

**Connection syntax:** `"source_block.y1 -> dest_block.u1"`

**Multi-fan-out:** One output to multiple inputs requires separate connect ops:
```json
{"op": "connect", "target": "MechToElec.y1 -> Park.u3"},
{"op": "connect", "target": "MechToElec.y1 -> InvPark.u3"}
```

**Using refs in same call:**
```json
[
  {"op": "add_block", "type": "Constant", "name": "TL", "ref": "tl", "params": {"Value": "0"}},
  {"op": "connect", "target": "#tl.y1 -> blk_7.u1"}
]
```
Use `#ref` for blocks added in the same call. Use `blk_N` IDs from prior `model_edit` or `model_read` results.

---

## Workflow Pattern

### Building a New Model
```
1. evaluate_matlab_code → new_system(mdl); save_system(mdl);
2. model_edit (layout_mode: "full") → add all blocks + connections + configure
3. evaluate_matlab_code → compute params (mcb.calcFOCGains with SpdLoopFactor=0.05, etc.)
4. evaluate_matlab_code → assignin to model workspace
5. model_edit (configure) → set block params to workspace variable names
6. evaluate_matlab_code → sim(mdl)
7. model_read → verify structure
```

### Modifying an Existing Model
```
1. model_overview (detail: "full") → understand structure
2. model_read (depth: "0") → get block IDs and connections
3. model_edit (layout_mode: "incremental") → add/modify/connect
4. model_query_params → verify changes
5. evaluate_matlab_code → sim(mdl)
```

---

## Configure Operation — Parameter Format

Parameters in `model_edit` configure use the same names as Simulink's `set_param`. All values are strings:

```json
{"op": "configure", "target": "blk_5", "params": {
    "ControllerParametersSource": "internal",
    "P": "Kp_id",
    "I": "Ki_id * Ts",
    "SampleTime": "Ts"
}}
```

For model-level config:
```json
{"op": "configure", "target": "config:MyModel", "params": {
    "Solver": "FixedStepDiscrete",
    "FixedStep": "Ts",
    "StopTime": "0.1"
}}
```

---

## What Stays in evaluate_matlab_code (ONLY These 5 Tasks)

These operations have **no model_edit equivalent** — they are the ONLY valid uses of `evaluate_matlab_code`. Everything else (adding blocks, connecting, configuring parameters, setting solver) MUST use `model_edit`.

```matlab
% 1. Model creation (one-time setup)
new_system(mdl); save_system(mdl);

% 2. Parameter computation (mcb.* APIs, arithmetic)
PI_params = mcb.calcFOCGains(pmsm, Ts, Ts_speed);
PU_System = mcb.getPUSystemParameters(pmsm, inverter);
smo_params = mcb.computeSMOParameters(pmsm, Ts, PU_System);

% 3. Workspace storage (assignin has no model_edit equivalent)
mdlWks = get_param(mdl, 'ModelWorkspace');
assignin(mdlWks, 'pmsm', pmsm);
assignin(mdlWks, 'Ts', Ts);

% 4. Simulation
simout = sim(mdl);

% 5. Post-processing and analysis
plot(simout.tout, simout.yout);
```

### Simulation Output Management (Token Efficiency)

**First simulation** (after sanity checks pass): Run `sim(mdl)` normally — read the full output to catch warnings, errors, and validate the model compiles cleanly.

**Subsequent iterations** (model already runs successfully): Use `evalc` to suppress verbose Simulink console output (precision warnings, compilation messages) and analyze only via logged data:

```matlab
% Silent simulation — suppresses all console output
[~, simOut] = evalc("sim(mdl, 'StopTime', '0.5')");

% Analyze from logged data only (ToWorkspace blocks or signal logging)
speed = simOut.speedLog.Data;
time = simOut.speedLog.Time;
```

**Additionally, suppress known benign warnings before first sim:**
```matlab
set_param(mdl, 'ParameterPrecisionLossMsg', 'none');  % Single→double precision loss (MCB plant blocks)
```

**Rationale:** MCB discrete plant blocks emit verbose precision-loss warnings on every simulation. These are informational (not errors) and consume significant tokens when read by an AI agent. After the first successful run confirms no real issues, silencing them via `evalc` keeps iterations efficient.

---

**NEVER use evaluate_matlab_code for:**
- `add_block()` / `add_line()` — use `model_edit` add_block/connect ops
- `set_param(blk, ...)` for block parameters — use `model_edit` configure op
- `set_param(mdl, 'Solver', ...)` — use `model_edit` configure with `config:mdl` target
- `delete_block()` / `delete_line()` — use `model_edit` delete op

----
Copyright 2026 The MathWorks, Inc.
----
