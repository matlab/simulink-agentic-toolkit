---
name: building-simulink-models
description: Builds and edits Simulink, System Composer, Stateflow, and Simscape models. Use when modifying model structure, parameters, ports, connections, or Stateflow chart internals.
license: MathWorks BSD-3-Clause
metadata:
  version: "1.0"
---

# Building Models

Use `model_edit` for Simulink, System Composer, and Simscape models (structural changes and parameter configuration). For Stateflow chart internals, use `evaluate_matlab_code` with the Stateflow API (see below).

## When to Use

- Adding, connecting, deleting, or replacing blocks in a model
- Configuring block parameters, signal properties, or model settings
- Creating or editing Stateflow chart internals (states, transitions, junctions)
- Building System Composer architecture models
- Wiring Simscape physical connections

## When NOT to Use

- Querying parameter values → use `model_query_params`
- Resolving variable references to numeric values → use `model_resolve_params`

## Workflow

1. **Read first:** Use `model_read` on the target scope to get block IDs and understand existing topology.
2. **Plan the data flow:** For complex edits, sketch inputs → operations → outputs, then map to blocks.
3. **Edit:** Use `model_edit` with operations scoped to one subsystem level at a time.
4. **Verify:** Use `model_read` on the scope to confirm the structure matches your intent.

**CRITICAL:** If `model_edit` returns `status: partial`, run `model_read` immediately to determine if corrective action is needed.

## Operation Chaining with `ref`

Use `ref` to name a block and `#ref` to reference it in later operations within the same call:

```json
[{"op": "add_block", "type": "Gain", "name": "MyGain", "ref": "g1"},
 {"op": "connect", "target": "blk_5.y1 -> #g1.u1"}]
```

The response `created` map shows `ref → blk_id`. In subsequent calls, use the `blk_id` (e.g., `blk_42`) — `#ref` only works within a single call.

## Guardrails

- Do not call `Simulink.BlockDiagram.arrangeSystem` or use `set_param` for block positioning unless the user explicitly requests it. `model_edit` has a built-in autolayout engine that runs automatically after each call.
- Use meaningfully named variables (e.g., `Kp_SpeedController`) instead of hardcoded numeric values. Define variables in model workspace or a `.m` init script.
- Don't use `evaluate_matlab_code` with `set_param`/`add_block` to bypass `model_edit` — it skips autolayout, undo tracking, and error recovery
- Use `open_system` rather than `load_system` to open models that are not already open, or when creating new models, unless the user explicitly asks otherwise or the model is a library. This ensures the user can see live edits as they happen.

## Naming Conventions

Prefer code-generation-safe names for blocks, signals, and variables:

- Use only: `a-z`, `A-Z`, `0-9`, underscore (`_`)
- Don't start with a number
- Don't use leading/trailing or consecutive underscores
- Prefer names under 32 characters (required for some code generation targets)

## Block Types

Use the block's **display name** in the `type` field. Do not construct or guess library paths.

- **Built-in Simulink blocks:** Use the BlockType directly: `Gain`, `Sum`, `Constant`, `Integrator`, `SubSystem`, `Scope`
- **Library blocks (Simscape, Aerospace, DSP, Communications, etc.):** Use the display name as it appears in the Simulink Library Browser: `Voltage Source`, `Resistor`, `DC Motor`, `Solver Configuration`, `6DOF (Euler Angles)`
- **If `model_edit` returns `INVALID_TYPE`:** Fall back to the full library path from MATLAB documentation (e.g., `ee_lib/Sources/Voltage Source`)

```json
[{"op": "add_block", "type": "Voltage Source", "name": "V1", "ref": "v1"},
 {"op": "add_block", "type": "Resistor", "name": "R1", "ref": "r1"},
 {"op": "add_block", "type": "Electrical Reference", "name": "Gnd", "ref": "gnd"},
 {"op": "add_block", "type": "Solver Configuration", "name": "Solver", "ref": "sc"}]
```

## Domain-Specific Rules

When working with these domains, read the corresponding reference file before editing:

- **Stateflow charts** -> `reference/stateflow.md` — `model_edit` can add Chart blocks but cannot edit chart internals. Use `evaluate_matlab_code` with the Stateflow API for states, transitions, junctions, and data. The reference covers API gotchas, subcharts, lint checks, and layout.
- **System Composer architecture models** -> `reference/system-composer.md` — Create models with `systemcomposer.createModel`, then use `model_edit`. Components use `type: "SubSystem"`, ports use Bus Element blocks. The reference covers component creation, port wiring, and behavior model generation.
- **Simscape physical models** -> `reference/simscape.md` — Physical connections use bidirectional `<->` syntax. The reference covers connection semantics, port patterns, and initial target variables.
