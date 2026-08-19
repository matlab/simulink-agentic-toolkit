
# Recipe Error Recovery Protocol

> When a model build fails mid-execution, recover without starting over.
> For validation checks see `validation-checks.md`.
> For error patterns see `auto_fix/ERROR_PATTERNS.md`.
>
> **Tools:** Use `model_overview` to inspect, `model_edit` to fix structure, `evaluate_matlab_code` for params/sim.

---

## Decision Tree

```
Build errors mid-execution
│
├─ Is the .slx file created? (check with model_overview)
│  ├─ YES → Model has structure. Go to "Fix In Place" below.
│  └─ NO → Error was in workspace setup (before new_system).
│           Fix the workspace variable/parameter, re-run.
│
├─ Fix In Place:
│  ├─ 1. Run model_overview(mdl) to see what blocks exist
│  ├─ 2. Identify last successfully added block
│  ├─ 3. Fix the specific error (see table below)
│  └─ 4. Continue from failure point using model_edit
│
└─ After fixing:
   ├─ Run remaining steps via model_edit (NOT re-running full script)
   ├─ Run Post-Build Cleanup (arrangeSystem + save via evaluate_matlab_code)
   └─ Validate with short sim: sim(mdl, 'StopTime', '0.1')
```

---

## Recovery Actions by Error Type

### 1. Custom Motor Params Outside Block Limits

Use `model_query_params` to inspect, then `model_edit` to fix:
```json
{"op": "configure", "target": "MTPA", "params": {"ilimit": "pmsm.I_rated"}}
```

**Common offenders:**
- `ilimit` default is 7.1A — ALWAYS override for custom motors
- `Vdc` default may not match user's inverter voltage
- `polePairs` must match between MTPA and PMSM blocks

### 2. Block Type Not Found

Use `model_query_params` to find valid block types. For MCB library blocks, use full library path in `model_edit`:
```json
{"op": "add_block", "type": "mcbcontrolslib/PI Controller", "name": "PI_d", "ref": "pid"}
```

**Never guess internal library paths.** Use `model_query_params` to verify block types exist before adding.

### 3. Simulation Divergence

Use `evaluate_matlab_code` for solver/model-level fixes:
```matlab
set_param(mdl, 'FixedStep', num2str(Ts/2));           % Reduce step size
```

Or use `model_edit` for block-level fixes:
```json
[
  {"op": "configure", "target": "PMSM", "params": {"initialSpeed": "0"}},
  {"op": "configure", "target": "SpeedRef", "params": {"FinalValue": "speed_ref * 0.5"}}
]
```

**Simscape models**: Must use `ode14x` (implicit). Explicit solvers diverge.

### 4. Port Dimension Mismatch

Common causes:
- FOC CC expects 4-element KpKiTs vector but got scalar
- PMSM Info bus selector using wrong signal names
- Mux combining signals of wrong sizes

**Key insight**: Connection failures do NOT corrupt the model. The model is valid — it just has a missing line. Use `model_edit` connect ops to fix.

### 5. API Function Error (Wrong Field Names)

Use `evaluate_matlab_code` to inspect:
```matlab
PI_params = mcb.calcFOCGains(pmsm, Ts, Ts_speed);
disp(fieldnames(PI_params))
```

**Critical field name corrections:**

| Wrong (common mistake) | Correct | API |
|---|---|---|
| `PI_params.Kp_iq` | `PI_params.Kp_i` | mcb.calcFOCGains |
| `PI_params.Ki_iq` | `PI_params.Ki_i` | mcb.calcFOCGains |
| `pmsm.lambda_pm` | `pmsm.FluxPM` | MTPA block mask |
| `pmsm.FluxPM` | use `lambda_pm` | PMSM block mask |

### 6. Connection Failure

Use `model_read` to inspect existing connections, then `model_edit` to fix:
```json
[
  {"op": "disconnect", "target": "OldSource.y1 -> Dest.u2"},
  {"op": "connect", "target": "NewSource.y1 -> Dest.u2"}
]
```

### 7. Configure Rejected (Invalid Param Value)

Use `model_query_params` to find valid options:
```
model_query_params → shows DialogParameters with Enum values
```

**Mask param gotchas:**
- `Vdc_input_select` must be exactly `'Input port'` (case-sensitive, not `'External'`)
- `FluxPM` in MTPA uses different variable name than PMSM block's `lambda_pm`

### 8. API Call Failure (mcb.* functions)

Use `evaluate_matlab_code` to check:
```matlab
result = mcb.calcFOCGains(pmsm, Ts, Ts_speed);
disp(fieldnames(result))
```

---

## Recovery Workflow Pattern

When a build fails, follow this exact sequence:

```
1. model_overview → see what exists
2. model_read → check connections of last block
3. Identify gap (what was supposed to come next)
4. model_edit → add remaining blocks + connections
5. model_query_params → verify key params
6. evaluate_matlab_code → arrangeSystem + sim test
```

### Why This Is Better

| Approach | Pros | Cons |
|---|---|---|
| Re-run full build | Familiar | Hits same error; all-or-nothing |
| Build from scratch | Flexible | Loses partial work; wrong connections |
| **model_overview → model_edit** | **Precise, recoverable** | Requires inspecting model state |

---

## Post-Build: Placeholder Detection

After every build, use `model_overview` to detect unresolved blocks:
- Look for blocks with generic names or missing library references
- For each placeholder: use `model_edit` replace_block or delete + add_block
- Rewire connections (check port count with model_read)
- Cleanup: `evaluate_matlab_code` → `Simulink.BlockDiagram.arrangeSystem(mdl); save_system(mdl);`

---

## Anti-Patterns (What NOT to Do)

| Anti-Pattern | Why Wrong | Correct Approach |
|---|---|---|
| `bdclose all; new_system(mdl)` after error | Destroys partial model | `model_overview` → fix in place |
| Guessing library paths in model_edit | Breaks across releases | Use `model_query_params` to verify |
| Re-running entire build from start | Hits same error again | Fix error, resume from failure point |
| Building with raw evaluate_matlab_code only | Loses SATK structure tracking | Use `model_edit` for all structural work |
| Ignoring error, trying different approach | User asked for specific config | Fix the specific issue |

---

## Key Principles

1. **The .slx is always more valuable than starting over.** Even 50% built = correct wiring + proper ordering.
2. **model_edit is your primary recovery tool.** Operates directly on the model without re-running scripts.
3. **Fix one thing at a time.** Verify with `model_overview` or short sim after each fix.
4. **model_query_params before configure.** Always verify param names/enums before setting.
5. **evaluate_matlab_code for computation only.** PI gains, workspace vars, sim — never for add_block/add_line.

----
Copyright 2026 The MathWorks, Inc.
----
