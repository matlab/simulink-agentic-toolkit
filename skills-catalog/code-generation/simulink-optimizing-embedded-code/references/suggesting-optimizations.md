> **Release compatibility:** MATLAB R2023a and later.

# Phase 3: Suggest Optimizations

## First Action: Refresh Model Fingerprint

Re-run `model_fingerprint` to ensure the element map is current (Phase 4 structural changes may have added/removed blocks):

```matlab
addpath(fullfile('<skill_root>', 'scripts'));
fingerprint = model_fingerprint('<model>');
```

Update `MODEL_FINGERPRINT` in state.json with the result.

## Second Action: Load Customer Preferences

Check for customer extensions (see `references/protocols/customer-extensions.md`):
1. Resolve `<PROJECT_PATH>/.custom_optimizations/optimization_preferences.yaml`.
2. Parse `skip` and `know` sections.
3. Discover and evaluate custom optimizations (run FIRST, before KG query).

## Third Action: Query the Knowledge Graph

Query the Knowledge Graph via MATLAB:

```matlab
addpath(fullfile('<skill_root>', 'scripts'));
result = ecokg_query('<goal>', <hardware_struct>, '<stage>', {<model_elements>});
disp(jsonencode(result))
```

| Argument | Source |
|----------|--------|
| `goal` | `"goal_" + state.GOAL` (e.g. `'goal_speed'`) |
| `hardware` | `state.HARDWARE` as a MATLAB struct (e.g. `struct('ProdHWDeviceType','Texas Instruments->C2000')`) |
| `stage` | `state.CURRENT_STAGE` (e.g. `'A'`, `'B'`, `'C'`, `'D'`) |
| `model_elements` | Cell array of keys from `state.MODEL_FINGERPRINT` where value is `true`, prefixed with `elem_` (e.g. `{'elem_subsystems', 'elem_matlab_functions'}`) |

### What ecokg_query returns

**Stage A** (config-set parameters):
```json
{
  "suggestions": [],
  "params": [
    {
      "id": "param_BufferReuse",
      "label": "BufferReuse",
      "attrs": {
        "parameter": "BufferReuse",
        "description": "...",
        "valid_values": ["on", "off"],
        "suggested_value": {"speed": "on", "RAM": "on", ...},
        "rationale": "...",
        "goals": ["RAM", "speed", "balance"],
        "conflicts": [{"parameter": "...", "reason": "...", "risk_id": "...", "symptom": "...", "mitigation": "..."}]
      }
    }
  ],
  "conflicts": [{"param1": "...", "param2": "...", "attrs": {"reason": "...", "risk_id": "..."}}]
}
```

Use `suggested_value[state.GOAL]` for each param to get the recommended value. Conflict entries include `symptom` and `mitigation` for safety reasoning.

**Stages B/C/D** (suggestion-driven — Pass 1 summary):
```json
{
  "suggestions": [
    {
      "id": "sug_atomic_inline",
      "label": "Atomic Subsystem Inlining",
      "opt_synopsis": "Purpose text + runtime skip conditions + required state inputs/outputs",
      "attrs": {
        "stage": "C",
        "risks": [{"label": "Stack overflow after inlining", "when": "caller stack near MaxStackSize"}]
      },
      "params": [{"id": "param_RTWSystemCode", "label": "...", "attrs": {...}}]
    }
  ],
  "params": [],
  "conflicts": [...]
}
```

For Stages B/C/D, use `opt_synopsis` to rank suggestions, evaluate runtime applicability, and `attrs.risks` to assess hazards. Then fetch the full opt_reference for selected suggestions.

## Third-B Action: Fetch Opt Reference for Selected Suggestions

After you know the valid suggestions from Pass 1, ALWAYS fetch the full execution opt_reference for each suggestion you will present to the user. 
Never explore an API before reading the KG detail — ecokg_detail exists to give you the procedure. Call it immediately after Pass 1 filtering:

```matlab
detail = ecokg_detail('<suggestion_id>');
disp(jsonencode(detail))
```

### What ecokg_detail returns (Pass 2 — full opt_reference):
```json
{
  "id": "sug_atomic_inline",
  "label": "Atomic Subsystem Inlining",
  "opt_synopsis": "...",
  "opt_reference": "Full procedure: What This Skill Does, Commands Reference, Strictly Never Do, Decision Trace, Risk Mitigations",
  "attrs": {"stage": "C", "risks": [{"label": "...", "when": "..."}]},
  "params": [{"id": "param_RTWSystemCode", "label": "...", "attrs": {...}}]
}
```

The `opt_reference` field contains the complete execution instructions including commands, constraints, decision trace patterns, and risk mitigations. Follow those instructions to generate specific recommendations for the model.

### Applying customer preferences to KG results

After receiving KG results, apply `skip` rules from customer preferences. Remove any suggestion/param whose purpose matches a skip rule. Log `SKIP EXT-03` for each.

## Fourth Action: Generate Suggestions

Generate suggestions in **batches** as a table:

| # | Category | Parameter / Change | Current Value | Suggested Value | Expected Impact | Tradeoff |
|---|----------|--------------------|---------------|-----------------|-----------------|----------|

## Stage A: Config-Set Parameters — Common Workflow

### Querying current values

Query current values in bulk using:
```matlab
cs = getActiveConfigSet('<model>');
get_param(cs, '<ParamName>')
```

### Known parameter gotchas

- **`ZeroInternalMemoryAtStartup`:** This parameter is often locked by the target/system target file and cannot be changed. Always test with `get_param` before suggesting.
- **`OptimizeReductions`:** Requires `InstructionSetExtensions` to be set to something other than `'None'`. On DSPs like C2000 that lack SIMD, this has no effect.

### Validation Workflow (Stage A specific)

After the user confirms a config-set parameter batch, run `validate_params.m` to mechanically validate the confirmed suggestions before applying:

```matlab
addpath(fullfile('<skill_root>', 'scripts'));
results = validate_params('<model>', {'Param1','Param2',...}, {'val1','val2',...});
```

This validates in two phases:
1. **Trial-apply** each param individually on a config set copy to check if Simulink accepts the value. Any param that throws an error is marked invalid immediately.
2. **Apply all individually-valid params together** on a fresh config set copy to catch cross-parameter conflicts. Any param that fails in this combined pass is marked invalid with a `Cross-conflict` error.

The script prints a summary showing pass/fail for each param. **If any params fail validation**, report back which ones failed and why. Apply only the valid ones (with user acknowledgment). Do NOT silently drop failed params.

## Stage Roster & Exhaustion Obligation

The orchestrator MUST attempt every stage in order before invoking Phase 5.

| Stage | What KG returns | Typical levers |
|-------|-----------------|----------------|
| **A** | `params` list (direct) | Build-config & code-gen options |
| **B** | `suggestions` (precision reduction) | Data-type changes (double to single) |
| **C** | `suggestions` (structural) | Subsystem, signal, function, lookup, data-store refactors |
| **D** | `suggestions` (architectural) | Codegen architecture, SIMD, flash-to-RAM |

### Exhaustion rule

A stage is **exhausted** when:
1. The user explicitly declines remaining options, OR
2. No untried options remain.

A batch rejection does NOT exhaust individual candidates within the batch. Only when the user opts to move on do unevaluated candidates become deferred levers.

### Within-stage candidate iteration

When a candidate is rejected by the Gate:
1. Present regression analysis.
2. Re-prompt with remaining options.
3. Let the user choose next attempt.

## Global Rules

- **Present first, apply only after confirmation.**
- **Model-aware safety:** Before suggesting any change, reason about whether it could break code generation or produce incorrect behavior.
- Always explain *why* each change helps.
- Flag suggestions that could change numerical behavior.
- Progress through stages A -> B -> C -> D.

**MANDATORY TRANSITION after user confirms a batch — Do NOT apply changes in the suggestion phase.** Once the user confirms: **(a) append the decision trace** to `<project_path>/.eco_diagnostics/eco_decision_trace.md` (one entry per SO-0x risk — see "Decision Trace Logging" below), **(b) update the token usage report** in `<project_path>/.eco_diagnostics/eco_optimization_report.md` (include Stage, KG query count, suggestions emitted), **(c)** construct the state object with `CURRENT_STAGE` and `DEFERRED_LEVERS` updated, and **(d)** proceed to Phase 4 with `NEXT_ACTION: "Phase 4 Apply — Stage <X> batch"`. **Refuse to transition if either diagnostic file has not been appended (OR-05/OR-06).**

## Risk / Alert — Known Failure Modes

| ID | Risk | Symptom | Triggered By | Mitigation |
|----|------|---------|-------------|------------|
| SA-01 | `RTWCompilerOptimization` vs `BuildConfiguration` conflict | Duplicate compiler flags break the build on embedded targets | Setting both `RTWCompilerOptimization = 'on'` and `BuildConfiguration = 'Faster Runs'` | Only change `BuildConfiguration`; leave `RTWCompilerOptimization` at default |
| SA-02 | `ZeroInternalMemoryAtStartup` locked | `set_param` throws error | Parameter locked by target/system target file | Always `get_param` to check writability before suggesting |
| SA-03 | `OptimizeReductions` no-op | Parameter accepted but no effect on generated code | Target lacks SIMD support (e.g., TI C2000) | Check `InstructionSetExtensions` before suggesting; skip if `'None'` |
| SA-04 | Cross-parameter conflict | `validate_params` reports failure in combined phase | Two individually valid params conflict when applied together | Split conflicting params into separate batches and re-validate |
| SA-05 | Stale parameters | Parameter names or valid values changed in newer MATLAB release | Using the skill with a MATLAB release newer than R2025a | Verify parameter names with `get_param` at runtime |
| SO-01 | Suggestion breaks build | `slbuild` fails after applying | Incompatible param or block change | Run `validate_params` (Stage A); checkpoint before apply (Stages B-D) |
| SO-02 | Numerical behavior change | Model output differs | Data-type or algorithm changes | Flag with warning; verify with SIL/PIL re-measure |
| SO-04 | Stage ordering violation | High-risk changes before low-risk | Jumping stages | Progress A -> B -> C -> D |
| SO-05 | Changes applied in suggest phase | No clean re-measure | Applying in Phase 3 | Enforce mandatory transition to Phase 4 before applying |

## Decision Trace Logging

Append to `<project_path>/.eco_diagnostics/eco_decision_trace.md`:

| When | Log entry |
|------|-----------|
| After KG query | `KG_QUERY: Stage <X>, goal=<goal>, hw=<hw>, elements=[<list>]. Returned <N> params/suggestions.` (via ecokg_query) |
| After customer preferences | `OK EXT-01` or `INFO EXT-01` |
| After skip gate | `SKIP EXT-03: <item> suppressed` |
| Before suggestion table | `OK SO-03: Model-aware reasoning performed` |
| Stage A validation | `OK SO-01: validate_params passed` or `WARN SO-01: <param> failed` |
| Stage advancement | `OK SO-04: Stage <X> exhausted` |
| At transition | `OK SO-05: No changes applied in suggest phase` |


----

Copyright 2026 The MathWorks, Inc.

----