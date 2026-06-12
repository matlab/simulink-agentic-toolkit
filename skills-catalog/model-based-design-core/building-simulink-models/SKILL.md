---
name: building-simulink-models
description: Builds and edits Simulink, System Composer, Stateflow, and Simscape models. Use when modifying model structure, parameters, ports, connections, or Stateflow chart internals.
license: MathWorks BSD-3-Clause
metadata:
  author: MathWorks
  version: "1.1"
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

**Do this FIRST and ALONE — no other tool calls in the same message.**

Check all three files in a single read: `.satk/reuse-libraries.json`, `.satk/block-policy.json`, `.satk/library-kg/index.md`.

- **All three exist → gates pass.** Read `index.md` for planning context, then proceed directly to the Workflow section.
- **`.satk/reuse-libraries.json` exists but with `confirmedNone: true` (no custom libraries) → gates pass.** Skip Gates 2 and 3 entirely — block policy and knowledge index are not needed when there are no custom Libraries.
- **Any missing → run gates sequentially and wait for user to respond for each gate:**
**Gate 1 — Library declaration:** If `.satk/reuse-libraries.json` is missing, STOP and ask the user about reusable libraries. Do not read reference files, open models, or plan blocks until they respond.
**Gate 2 — Block policy:** If `.satk/block-policy.json` is missing, STOP and ask the user about policy setup by following `reference/library-setup.md`. Do not proceed until policy is resolved.
**Gate 3 — Library knowledge index:** If `.satk/library-kg/index.md` is missing, STOP and ask the user about curating the library knowledge index by following `reference/library-setup.md`. Do not proceed until they respond.

No model reading, planning, or editing begins until all three gates pass.

## Workflow

0. **Ensure Library & Policy Prerequisites:** Read `.satk/reuse-libraries.json`, `.satk/block-policy.json`, and `.satk/library-kg/index.md`. If all three exist, proceed. If `reuse-libraries.json` has `confirmedNone: true`, skip policy and KG checks. If any are missing, run the gates in the "Library & Policy Prerequisites — BLOCKING GATE" section above sequentially — do not proceed until all gates pass. Follow `reference/library-setup.md` for gate resolution details.
1. **Library block lookup:** If `.satk/reuse-libraries.json` declares one or more libraries, list every block type you plan to use, search `.satk/library-kg/index.md` and the relevant category pages to find each of the library blocks that match.
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

In SF scope, `#ref` references are portless — no `.y1`/`.u1` suffixes (see `reference/stateflow.md`).

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

- **Customer library blocks (from `.satk/reuse-libraries.json`):** pass both `type` AND `ReferenceBlock` fields. Set `type` to the block's display name and `ReferenceBlock` to the full library path from the library KG.

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

- **Stateflow charts** -> `reference/stateflow.md` — `model_edit` edits chart internals natively. Scope to a chart (`sf_X` or chart `blk_X`) and use the same operations: `add_block` for SF elements, portless `connect` for transitions, `configure` for properties. The reference covers SF-specific syntax, scoping, LabelString patterns, and the two-call SL+SF workflow.
- **System Composer architecture models** -> `reference/system-composer.md` — Create models with `systemcomposer.createModel`, then use `model_edit`. Components use `type: "SubSystem"`, ports use Bus Element blocks. The reference covers component creation, port wiring, and behavior model generation.
- **Simscape physical models** -> `reference/simscape.md` — Physical connections use bidirectional `<->` syntax. The reference covers connection semantics, port patterns, and initial target variables.

----

Copyright 2026 The MathWorks, Inc.

----
