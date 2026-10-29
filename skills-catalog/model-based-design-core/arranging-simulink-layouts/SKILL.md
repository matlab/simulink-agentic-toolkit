---
name: arranging-simulink-layouts
description: Arranges and tidies Simulink block diagram layouts with the model_edit layout engine. Use when the user asks to fix, clean up, tidy, straighten, or rearrange a layout, when blocks overlap or lines cross, when specific blocks need re-placing, or when grouping blocks into or expanding a subsystem.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Arranging Simulink Layouts

Re-place blocks with the SATK layout engine in `model_edit`. Move as little of the user's diagram as the request allows.

## When to Use

- "Fix / clean up / tidy / straighten / rearrange the layout", "make it readable"
- Blocks overlap, lines cross or run through blocks, a few blocks landed in odd places
- "Move these blocks", "line these up", "sort out the blocks I just added"
- Grouping blocks into a subsystem, or expanding a subsystem into its parent

## When NOT to Use

- Adding, connecting, deleting, or configuring blocks: use `building-simulink-models`. Layout already runs automatically after every `model_edit` call.
- Stateflow chart layout: the `layout` op is Simulink-only. A chart scope accepts only a full re-layout (`operations` `[]`, `layout_mode` `"full"`), which moves every element, so ask first.

## Set Expectations

- You drive an automatic layout engine. You don't place blocks pixel by pixel. Say so if the user expects hand-tuned placement.
- **Ctrl+Z is not reliable for agent edits, including layout.** Don't offer undo. Before any layout that moves many blocks, recommend that the user saves the model (or a copy) first.
- The first layout in a MATLAB session can take about 20 s while the engine starts. Later calls take 1–2 s.

## Choose the Method

Selective layout is the default. A full layout of a diagram the user has arranged by hand discards their arrangement, so ask before running one.

| Situation | Method |
|---|---|
| A few blocks are messy, overlapping, or just added | `{"op":"layout","targets":[...]}` with `layout_mode` `"incremental"` |
| The whole scope is a mess and the user agrees that everything moves | `operations` `[]` with `layout_mode` `"full"` |
| The user explicitly asks for Simulink's own tidy-up | **Format > Auto Arrange** / `Simulink.BlockDiagram.arrangeSystem`, and only on request |
| The user wants an exact placement | `configure` with `Position` through `model_edit` |

### Selective layout (default)

```text
model_edit(model, "root", '[{"op":"layout","targets":["blk_5","blk_7"]}]', "incremental")
```

- Targets must sit **directly inside** `scope`. Make one call per scope.
- The targets move and the lines touching them are rerouted. Other blocks stay put, except that blocks downstream of a target may shift to make room. Mention that in your report.
- You can combine a `layout` op with edits in the same call. A `#ref` target names a block that the call adds:
  `[{"op":"add_block","type":"Gain","ref":"g"},{"op":"connect","target":"blk_3.y1 -> #g.u1"},{"op":"layout","targets":["#g","blk_9"]}]`
- When the wiring is tangled, add the targets' immediate neighbours to `targets`.
- With `layout_mode` `"full"`, the targets are ignored and the whole scope is re-laid out.

### Full layout of a scope

```text
model_edit(model, "blk_12", "[]", "full")
```

Use it for a scope that is new or already unreadable, and only with the user's agreement. Prefer the smallest subsystem that contains the mess over `root`.

### Exact placement

```text
model_edit(model, "root", '[{"op":"configure","target":"blk_5","params":{"Position":"[300 100 340 130]"}}]', "incremental")
```

Later incremental layouts leave the block where you put it, but a full layout of the scope moves it. Use this only when the user names a position or asks for specific alignment.

## Pick the Targets

1. **The user names blocks:** find their `blk_X` IDs with `model_read` (depth `"0"`) or `model_overview` on the scope.
2. **The user points at the diagram** ("these blocks", "the ones on the left"): ask them to select the blocks in the editor, then read the selection:
   ```matlab
   sel = find_system('<scopePath>', 'SearchDepth', 1, 'Type', 'Block', 'Selected', 'on');
   ids = cellfun(@(p) ['blk_' extractAfter(Simulink.ID.getSID(p), ':')], sel, 'UniformOutput', false)
   ```
   A selection can be stale: earlier operations sometimes leave blocks selected. Read the block names back to the user and confirm before laying out.
3. **Overlaps:** compare the targets' `Position` values with `model_query_params`, or check the model in the editor.

## After Layout

- Read the `layout:` block in the response. `applied: false` comes with a `detail` that explains why. Report it; don't retry blindly.
- Run `model_check(model, scope, '["unconnected_lines"]')` to confirm that the wiring survived.
- Tell the user which blocks moved, and mention any downstream blocks that shifted.

## Restructuring Subsystems

To group blocks into a new subsystem, or expand a subsystem in place, see [references/subsystem-restructuring.md](references/subsystem-restructuring.md). Don't rebuild the content block by block with `model_edit`.

## Anti-Patterns

- `set_param(..., 'Position', ...)` block by block to "fix" a layout. Use a `layout` op, or `configure` `Position` through `model_edit`.
- `Simulink.BlockDiagram.arrangeSystem` when the user didn't ask for Auto Arrange.
- A full layout of an existing, hand-arranged diagram without asking.
- Copying blocks into a subsystem one at a time, which loses wiring and layout. Use `Simulink.BlockDiagram.createSubsystem`.
- Promising that Ctrl+Z will restore the previous layout.
