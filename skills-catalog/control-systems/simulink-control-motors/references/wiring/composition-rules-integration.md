
# Composition Rules — Integration & Validation

> Logging, speed profiles.
> For core FOC features (FW, SMO, GainSched, FF, Position, I/f) see `composition-rules.md`.
> For infrastructure features (Protection, PWM, MultiRate, Nonlinear, Load) see `composition-rules-infrastructure.md`.
> For combining features, compatibility matrix, SI/PU see `composition-rules-combining.md`.
>
> **Implementation:** Use `model_edit` for structural changes (add_block, connect, configure).
> Use `evaluate_matlab_code` only for computation (PI gains, PU system, workspace storage, simulation).
> See `tool-routing.md` for complete tool selection guide.

---

## Feature: Logging and Validation

> Standard logging for simulation analysis, PASS/FAIL determination, and automated testing.

### CRITICAL: Include Logging in Initial Build

**Always include ToWorkspace blocks in the FIRST `model_edit` call** (layout_mode="full") when building a new model. Do NOT add logging blocks after the fact via `evaluate_matlab_code` + `add_block`/`add_line` — this violates tool-routing rules and frequently causes connection errors.

**Minimum logging set for FOC models:**
- Speed (after IIR filter) — for performance validation
- SMO theta/speed (if sensorless) — for observer convergence check

**Why this matters:** Without pre-built logging, you must re-enter `evaluate_matlab_code` to add blocks and lines, which:
1. Requires exact block path strings (fragile)
2. Cannot use blk_id references from prior model_edit calls
3. Produces less reviewable tool output

### Signal Logging vs ToWorkspace

| Method | How | Works on MCB blocks? |
|--------|-----|---------------------|
| `DataLogging` param | `set_param(blk, 'DataLogging', 'on')` | **NO** — MCB masked blocks (IIR Filter, PI Controller, SMO, PMSM) do NOT expose this param |
| ToWorkspace block | Add block + connect in model_edit | **YES** — always works |
| Signal logging on line | `set_param(line, 'DataLogging', 'on')` | Requires line handle — fragile in scripts |

**Recommendation:** Always use ToWorkspace blocks (added via model_edit). Never attempt `DataLogging` on MCB masked subsystems — it silently fails or errors.

### Adding To Workspace Blocks

```json
[
  {"op": "add_block", "type": "To Workspace", "name": "Log_Speed", "ref": "ls", "params": {"VariableName": "log_speed", "SaveFormat": "Timeseries", "SampleTime": "Ts"}},
  {"op": "add_block", "type": "To Workspace", "name": "Log_Id", "ref": "lid", "params": {"VariableName": "log_id", "SaveFormat": "Timeseries", "SampleTime": "Ts"}},
  {"op": "add_block", "type": "To Workspace", "name": "Log_Iq", "ref": "liq", "params": {"VariableName": "log_iq", "SaveFormat": "Timeseries", "SampleTime": "Ts"}},
  {"op": "add_block", "type": "To Workspace", "name": "Log_Vd", "ref": "lvd", "params": {"VariableName": "log_vd", "SaveFormat": "Timeseries", "SampleTime": "Ts"}},
  {"op": "add_block", "type": "To Workspace", "name": "Log_Vq", "ref": "lvq", "params": {"VariableName": "log_vq", "SaveFormat": "Timeseries", "SampleTime": "Ts"}},
  {"op": "add_block", "type": "To Workspace", "name": "Log_Pos", "ref": "lp", "params": {"VariableName": "log_pos", "SaveFormat": "Timeseries", "SampleTime": "Ts"}},
  {"op": "connect", "target": "IIR_Spd.y1 -> #ls.u1"},
  {"op": "connect", "target": "Park.y1 -> #lid.u1"},
  {"op": "connect", "target": "Park.y2 -> #liq.u1"},
  {"op": "connect", "target": "PI_d.y1 -> #lvd.u1"},
  {"op": "connect", "target": "PI_q.y1 -> #lvq.u1"},
  {"op": "connect", "target": "BusSel_Pos.y1 -> #lp.u1"}
]
```

### Adding Scope Blocks (Quick Visual Check)

```json
[
  {"op": "add_block", "type": "Scope", "name": "Scope_SpeedCurr", "ref": "scp", "params": {"NumInputPorts": "3"}},
  {"op": "connect", "target": "IIR_Spd.y1 -> #scp.u1"},
  {"op": "connect", "target": "Park.y1 -> #scp.u2"},
  {"op": "connect", "target": "Park.y2 -> #scp.u3"}
]
```

### Standard Validation Code Template (Post-Simulation)

Analyze the last 20% of simulation data for steady-state performance.
**Use `evaluate_matlab_code` for this — it is post-processing, not model building.**

```matlab
function results = validate_foc_sim(log_speed, speed_ref, log_id, id_ref, log_iq, iq_ref, T_sim)
    % Extract last 20% for steady-state analysis
    t = log_speed.Time;
    t_ss_start = 0.8 * T_sim;
    idx_ss = t >= t_ss_start;

    speed_ss = log_speed.Data(idx_ss);
    id_ss = log_id.Data(idx_ss);
    iq_ss = log_iq.Data(idx_ss);

    % --- Speed metrics ---
    results.speed_mean = mean(speed_ss);
    results.speed_error_pct = abs(mean(speed_ss) - speed_ref) / abs(speed_ref) * 100;
    results.speed_ripple_pct = (max(speed_ss) - min(speed_ss)) / abs(speed_ref) * 100;

    % --- Current metrics ---
    results.id_mean = mean(id_ss);
    results.id_error = abs(mean(id_ss) - id_ref);
    results.iq_mean = mean(iq_ss);
    results.iq_error = abs(mean(iq_ss) - iq_ref);

    % --- Rise time (10% to 90% of final value) ---
    speed_all = log_speed.Data;
    target_10 = 0.1 * speed_ref;
    target_90 = 0.9 * speed_ref;
    idx_10 = find(speed_all >= target_10, 1, 'first');
    idx_90 = find(speed_all >= target_90, 1, 'first');
    if ~isempty(idx_10) && ~isempty(idx_90)
        results.rise_time = t(idx_90) - t(idx_10);
    else
        results.rise_time = NaN;
    end

    % --- Oscillation check (std dev in steady state) ---
    results.speed_std = std(speed_ss);
    results.oscillating = results.speed_std > 0.05 * abs(speed_ref);

    % --- PASS/FAIL criteria ---
    results.PASS_speed = results.speed_error_pct < 2.0;       % <2% SS error
    results.PASS_ripple = results.speed_ripple_pct < 10.0;    % <10% ripple
    results.PASS_stable = ~results.oscillating;                % no oscillation
    results.PASS_id = results.id_error < 0.5;                 % id tracks ref within 0.5A
    results.PASS_overall = results.PASS_speed && results.PASS_ripple && ...
                           results.PASS_stable && results.PASS_id;

    % --- Print summary ---
    fprintf('=== FOC Validation Results ===\n');
    fprintf('Speed SS error: %.2f%% [%s]\n', results.speed_error_pct, tf2str(results.PASS_speed));
    fprintf('Speed ripple:   %.2f%% [%s]\n', results.speed_ripple_pct, tf2str(results.PASS_ripple));
    fprintf('Stability:      std=%.3f [%s]\n', results.speed_std, tf2str(results.PASS_stable));
    fprintf('Id tracking:    err=%.3f A [%s]\n', results.id_error, tf2str(results.PASS_id));
    fprintf('Rise time:      %.4f s\n', results.rise_time);
    fprintf('OVERALL:        [%s]\n', tf2str(results.PASS_overall));
end

function s = tf2str(v)
    if v, s = 'PASS'; else, s = 'FAIL'; end
end
```

### Quick Inline Validation (for scripts)

**Use `evaluate_matlab_code` — this runs after simulation:**
```matlab
% After sim_out = sim(mdl, T_sim):
speed_data = sim_out.logsout.get('speed').Values.Data;
t = sim_out.logsout.get('speed').Values.Time;
ss_idx = t > 0.8*T_sim;
ss_error_pct = abs(mean(speed_data(ss_idx)) - speed_ref) / abs(speed_ref) * 100;
assert(ss_error_pct < 2.0, 'FAIL: Steady-state speed error %.2f%% exceeds 2%%', ss_error_pct);
fprintf('PASS: Speed SS error = %.2f%%\n', ss_error_pct);
```

---

## Feature: Custom Speed Profile

> Replace a simple Step reference with more sophisticated speed commands.

### Ramp (Acceleration Limiting)

Linear ramp from zero to target speed with configurable slope:

```json
[
  {"op": "add_block", "type": "Ramp", "name": "Speed_Ramp", "ref": "rmp", "params": {"Slope": "accel_rate"}},
  {"op": "add_block", "type": "Saturation", "name": "Sat_SpdRef", "ref": "sat", "params": {"UpperLimit": "speed_ref", "LowerLimit": "-speed_ref"}},
  {"op": "connect", "target": "#rmp.y1 -> #sat.u1"},
  {"op": "connect", "target": "#sat.y1 -> Sum_Speed.u1"}
]
```

Alternative using Rate Limiter on a Step:
```json
[
  {"op": "add_block", "type": "Step", "name": "Speed_Step", "ref": "stp", "params": {"FinalValue": "speed_ref", "Time": "0", "InitialValue": "0", "SampleTime": "Ts"}},
  {"op": "add_block", "type": "Rate Limiter", "name": "Accel_Limit", "ref": "rl", "params": {"RisingSlewLimit": "max_accel", "FallingSlewLimit": "-max_accel"}},
  {"op": "connect", "target": "#stp.y1 -> #rl.u1"},
  {"op": "connect", "target": "#rl.y1 -> Sum_Speed.u1"}
]
```
**Note:** Rate Limiter has NO `SampleTime` param — it inherits sample time. Use `SampleTimeMode` if needed.

### S-Curve (Jerk-Limited)

Two cascaded Rate Limiters produce an S-curve (trapezoidal acceleration):

```json
[
  {"op": "add_block", "type": "Step", "name": "Speed_Step", "ref": "stp", "params": {"FinalValue": "speed_ref", "Time": "0", "InitialValue": "0", "SampleTime": "Ts"}},
  {"op": "add_block", "type": "Rate Limiter", "name": "Jerk_Limit", "ref": "jl", "params": {"RisingSlewLimit": "max_jerk", "FallingSlewLimit": "-max_jerk"}},
  {"op": "add_block", "type": "Rate Limiter", "name": "Accel_Limit", "ref": "al", "params": {"RisingSlewLimit": "max_accel", "FallingSlewLimit": "-max_accel"}},
  {"op": "connect", "target": "#stp.y1 -> #jl.u1"},
  {"op": "connect", "target": "#jl.y1 -> #al.u1"},
  {"op": "connect", "target": "#al.y1 -> Sum_Speed.u1"}
]
```

### Multi-Step (From Workspace with Timeseries)

Arbitrary speed profile defined in workspace.
**Use `evaluate_matlab_code` for timeseries creation, then `model_edit` for block:**

```matlab
% evaluate_matlab_code — create timeseries in workspace:
t_profile = [0, 0.2, 0.5, 0.8, 1.0, 1.5, 2.0];
w_profile = [0, 0,   100, 100, 50,  50,  0  ];  % rad/s
speed_profile = timeseries(w_profile(:), t_profile(:));
mdlWks = get_param(mdl, 'ModelWorkspace');
assignin(mdlWks, 'speed_profile', speed_profile);
```

```json
[
  {"op": "add_block", "type": "From Workspace", "name": "Speed_Profile", "ref": "fws", "params": {"VariableName": "speed_profile", "Interpolate": "on", "OutputAfterFinalValue": "Holding final value"}},
  {"op": "connect", "target": "#fws.y1 -> Sum_Speed.u1"}
]
```

### Repeating Pattern (for Test/Validation)

Periodic speed reference for endurance or thermal testing:

```json
[
  {"op": "add_block", "type": "Repeating Sequence Stair", "name": "Repeat_Spd", "ref": "rss", "params": {
      "OutValues": "[0, speed_ref, speed_ref, -speed_ref, -speed_ref, 0]",
      "tsamp": "Ts"}},
  {"op": "connect", "target": "#rss.y1 -> Sum_Speed.u1"}
]
```
**Note:** Repeating Sequence Stair uses `tsamp` (not `SampleTime`), and `OutValues` only (no `TimeValues` — steps occur every `tsamp`).

Alternative — Repeating Sequence Interpolated (has both `OutValues` and `TimeValues`):
```json
[
  {"op": "add_block", "type": "Repeating Sequence Interpolated", "name": "Repeat_Interp", "ref": "rsi", "params": {
      "OutValues": "[0, speed_ref, speed_ref, 0]",
      "TimeValues": "[0, 0.2, 0.8, 1.0]",
      "tsamp": "Ts"}}
]
```

---

> For combining features, compatibility matrix, and SI/PU see `composition-rules-combining.md`.

----
Copyright 2026 The MathWorks, Inc.
----
