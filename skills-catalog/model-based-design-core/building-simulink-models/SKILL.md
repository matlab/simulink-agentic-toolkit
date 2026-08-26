---
name: building-simulink-models
description: Builds and edits Simulink, System Composer, Stateflow, and Simscape models. Use when modifying model structure, parameters, ports, connections, or Stateflow chart internals.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.5"
---

# Building Models

Use `model_edit` for all structural changes — Simulink, System Composer, Simscape, and Stateflow chart internals

## When to Use

- Adding, connecting, deleting, or replacing blocks in a model
- Configuring block parameters, signal properties, or model settings
- Creating or editing Stateflow chart internals (states, transitions, junctions, data, events, messages, functions)
- Building System Composer architecture models
- Wiring Simscape physical connections

## When NOT to Use

- Querying parameter values → use `model_query_params`
- Resolving variable references to numeric values → use `model_resolve_params`

## Library & Policy Prerequisites — BLOCKING GATE

**Do this FIRST — evaluate the result before any other tool call.** Do not narrate the gate check to the user; proceed silently based on the result.

Call `library.settingsLookup()` to check for custom library configuration. It returns a struct with resolved absolute paths:
- `found` — whether a libraries file was located (satk-libraries.json or legacy reuse-libraries.json)
- `enabled` — whether custom libraries are configured
- `gatePass` — whether the gate is satisfied (can proceed to build)
- `kgIndexPath` — absolute path to `library-kg/index.md`
- `librariesPath` — absolute path to the libraries file
- `policyPath` — absolute path to `block-policy.json`
- `dataRoot` — absolute path to the directory containing `.satk/`

**Interpret the result:**

- **`found: false`** → no custom libraries configured. Proceed with standard Simulink blocks.
- **`gatePass: true, found: true`** → read `kgIndexPath` for block lookup, then plan and edit.
- **`gatePass: false`** → invoke `setup-custom-libraries` to populate the Knowledge Index.

Display meaningful description of each check and result instead of stating gate Pass/fail.


No model reading, planning, or editing begins until the gate passes.

## Workflow


0. **Ensure Library & Policy Prerequisites:** See BLOCKING GATE above. Do not proceed until gates pass.
1. **Library block lookup:**  List every block type you plan to use, search `.satk/library-kg/index.md` and the relevant category pages to find each of the library blocks that match.
2. **Read first:** Use `model_read` on the target scope to get block IDs and understand existing topology.
3. **Plan the data flow:** For complex edits, sketch inputs → operations → outputs, then map to blocks identified in Step 1 & 2.
4. **Edit:** Use `model_edit` with operations scoped to one subsystem level at a time.
5. **Verify:** Use `model_read` on the scope to confirm the structure matches your intent.
6. **Check connectivity:** After all edits in a scope are complete, run `model_check` to catch unconnected ports or dangling lines. Fix any `error`-severity issues.

**If `model_edit` returns `status: partial`:** Run both `model_read` and `model_check` immediately — don't wait until all edits are complete.

## Operation Chaining with `ref`

Use `ref` to name a block and `#ref` to reference it in later operations within the same call:

```json
[{"op": "add_block", "type": "Gain", "name": "MyGain", "ref": "g1"},
 {"op": "connect", "target": "blk_5.y1 -> #g1.u1"}]
```

In SF scope, `#ref` references are portless — no `.y1`/`.u1` suffixes (see `references/stateflow.md`).

The response `created` map shows `ref → blk_id` (or `ref → sf_X` in SF scope). In subsequent calls, use the returned ID — `#ref` only works within a single call.

## Guardrails

- **Never manually construct block path strings** from names shown in `model_overview` or `model_read`. Block names can contain invisible newlines and trailing whitespace that cause `hilite_system`, `open_system`, and `get_param` to fail. Instead, resolve paths from `blk_X` IDs:
  ```matlab
  % blk_42 → use the number after "blk_" as the SID
  blockPath = Simulink.ID.getFullName('<ModelName>:42');
  hilite_system(blockPath)
  open_system(blockPath)
  get_param(blockPath, 'BlockType')
  ```
- Do not call `Simulink.BlockDiagram.arrangeSystem` or use `set_param` for block positioning unless the user explicitly requests it. `model_edit` has a built-in autolayout engine that runs automatically after each call.
- Always pass `layout_mode` to `model_edit`. Use `"full"` when populating an empty scope (new model root, or a newly-created subsystem) for optimal block arrangement. Use `"incremental"` when adding blocks to a scope that already has existing blocks (preserves existing positions).
- Each `model_edit` call operates in exactly one domain (Simulink, System Composer, or Stateflow) determined by the scope. To add a Chart block and then populate it, use two calls: SL scope for the Chart block, then SF scope for internals. Use `model_read` between calls to discover the chart's `sf_X` scope ID.
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

- **Custom library blocks (from `satk-libraries.json`):** pass both `type` AND `ReferenceBlock` fields. Set `type` to the block's display name and `ReferenceBlock` to the full library path from the library KG.

- **Toolbox KB blocks (from `activeToolboxes`):** Use them exactly like custom library blocks — reference the `type` and `ReferenceBlock` fields from the toolbox category page in the library KG.

- **Built-in Simulink blocks:** Use the BlockType directly: `Gain`, `Sum`, `Constant`, `Integrator`, `SubSystem`, `Scope`
- **Library blocks (Simscape, Aerospace, DSP, Communications, etc.):** Use the display name as it appears in the Simulink Library Browser: `Voltage Source`, `Resistor`, `DC Motor`, `Solver Configuration`, `6DOF (Euler Angles)`
- **If `model_edit` returns `INVALID_TYPE`:** Fall back to the full library path from MATLAB documentation (e.g., `ee_lib/Sources/Voltage Source`)

```json
[{"op": "add_block", "type": "In", "ReferenceBlock": "customLib_Portsandsubsystems/In", "name": "Voltage", "ref": "v1"},
 {"op": "add_block", "type": "Gain", "ReferenceBlock": "customLib_Mathoperations/Gain", "name": "Kp", "ref": "g1"},
 {"op": "add_block", "type": "Add", "ReferenceBlock": "customLib_Mathoperations/Add", "name": "SumErr", "ref": "s1"},
 {"op": "add_block", "type": "Out", "ReferenceBlock": "customLib_Portsandsubsystems/Out", "name": "Output", "ref": "o1"}]
```

```json
[{"op": "add_block", "type": "Voltage Source", "name": "V1", "ref": "v1"},
 {"op": "add_block", "type": "Resistor", "name": "R1", "ref": "r1"},
 {"op": "add_block", "type": "Electrical Reference", "name": "Gnd", "ref": "gnd"},
 {"op": "add_block", "type": "Solver Configuration", "name": "Solver", "ref": "sc"}]
```

## Review Gate

After completing all edits for a scope, verify:

- No `error`-severity issues from `model_check` (unconnected ports, dangling lines)
- All `ref` names resolved to `blk_id` in the `created` map — no dangling `#ref` references in subsequent calls
- Stateflow charts pass lint (`model_check` with `checks='["stateflow_lint"]'`) before layout is applied
- If `model_edit` returned `status: partial` at any point, confirm the scope is now structurally complete via `model_read`

## Domain-Specific Rules

When working with these domains, read the corresponding reference file before editing:

- **Stateflow charts** -> `references/stateflow.md` — `model_edit` edits chart internals natively. Scope to a chart (`sf_X` or chart `blk_X`) and use the same operations: `add_block` for SF elements, portless `connect` for transitions, `configure` for properties. The reference covers SF-specific syntax, scoping, LabelString patterns, and the two-call SL+SF workflow.
- **System Composer architecture models** -> `references/system-composer.md` — Create models with `systemcomposer.createModel`, then use `model_edit`. Components use `type: "SubSystem"`, ports use Bus Element blocks. The reference covers component creation, port wiring, and behavior model generation.
- **Simscape physical models** -> `references/simscape.md` — Physical connections use bidirectional `<->` syntax. The reference covers connection semantics, port patterns, and initial target variables.

----

Copyright 2026 The MathWorks, Inc.

----
