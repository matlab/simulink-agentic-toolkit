---
name: arranging-simulink-layouts
description: Arranges Simulink block diagram layout to improve readability using the model_edit layout engine. Use when the user asks to fix, clean up, tidy, straighten, or rearrange a layout, or to run Simulink's Auto Arrange, when blocks overlap or lines cross, when specific blocks need repositioning, or when grouping blocks into or expanding a subsystem.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.1"
---

# Arranging Simulink Layouts

Reposition blocks and reroute their lines with the SATK layout engine in `model_edit`. Move as little of the user's diagram as the request allows.

## When to Use

- "Fix / clean up / tidy / straighten / rearrange the layout", "make it readable"
- Blocks overlap, lines cross or run through blocks, a few blocks landed far from the blocks they connect to
- "Move these blocks", "line these up", "sort out the blocks I just added"
- Grouping blocks into a subsystem, or expanding a subsystem into its parent
- "Run Auto Arrange", "use Simulink's own arrange"

## When NOT to Use

- Adding, connecting, deleting, or configuring blocks: use `building-simulink-models`. Layout already runs automatically after every `model_edit` call.
- Stateflow chart layout: the `layout` operation is Simulink-only. A chart scope accepts only a full re-layout (`operations` `[]`, `layout_mode` `"full"`), which moves every element, so ask first.

## Set Expectations

- You drive an automatic layout engine. You don't place blocks pixel by pixel. Say so if the user expects hand-tuned placement.
- **Ctrl+Z is not reliable for agent edits, including layout.** Don't offer undo. Before any layout that moves many blocks, recommend that the user saves the model (or a copy) first.
- The first layout in a MATLAB session can take about 20 s while the engine starts. Later calls take 1–2 s.

## Choose the Method

Selective layout is the default. A full layout of a diagram the user has arranged by hand discards their arrangement, so ask before running one. Treat every existing diagram as hand-arranged, however messy it looks.

A vague request ("clean up the layout", "this looks messy") is **not** agreement to move every block. Only a user who accepts that the whole diagram will move has agreed. For a vague request, diagnose first:

1. List every pair of blocks that overlap or sit closer than 5 px, with `evaluate_matlab_code`. Touching blocks count as a problem too. Don't compare `Position` values by eye, because that misses pairs.
   ```matlab
   b = find_system('<scopePath>', 'SearchDepth', 1, 'Type', 'Block');
   b = b(~strcmp(b, '<scopePath>'));
   p = cell2mat(get_param(b, 'Position'));
   pad = 5;
   for i = 1:numel(b)
       for j = i+1:numel(b)
           if all(p(i,1:2) - pad < p(j,3:4)) && all(p(j,1:2) < p(i,3:4) + pad)
               fprintf('%s and %s overlap or are closer than %d px\n', strrep(b{i}, newline, ' '), strrep(b{j}, newline, ' '), pad);
           end
       end
   end
   ```
   Also look for lines that run through blocks, and for a block far from every block it connects to, or outside the main body of the diagram.
2. Fix those specific blocks with a selective layout, and tell the user which blocks moved.
3. If nothing concrete is wrong, or the user wants more, offer a full layout. Explain that every block will move.

| Situation | Method |
|---|---|
| A few blocks overlap, are out of line with their neighbours, or were just added, or the user points out bent lines or misalignment | `{"op":"layout","targets":[...]}` with `layout_mode` `"incremental"` |
| The whole scope is a mess and the user agrees that everything moves | `operations` `[]` with `layout_mode` `"full"` |
| The user explicitly asks for Simulink's own tidy-up | **Format > Auto Arrange** / `Simulink.BlockDiagram.arrangeSystem`, and only on request |
| The user wants an exact placement | `configure` with `Position` through `model_edit` |
| The user says every other block must stay where it is | `configure` with `Position`, sliding each target along one axis into free space |

### Selective layout (default)

```text
model_edit(model, "root", '[{"op":"layout","targets":["blk_5","blk_7"]}]', "incremental")
```

- Targets must sit **directly inside** `scope`. Make one call per scope.
- The targets move and the lines touching them are rerouted. Other blocks stay put, except that blocks downstream of a target may shift to make room. Mention that in your report. If the user said other blocks must stay put, compare their `Position` values before and after. If any shifted, put them back and place the targets with `configure` instead.
- You can combine a `layout` operation with edits in the same call. A `#ref` target names a block that the call adds:
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

Later incremental layouts leave the block where you put it, but a full layout of the scope moves it. Use this when the user names a position, asks for specific alignment, or says every other block must stay where it is. In that last case, move each target along one axis into free space, and don't move it past a block it started clear of. That keeps the user's picture of the diagram intact.

## Pick the Targets

1. **The user names blocks:** find their `blk_X` IDs with `model_read` (depth `"0"`) or `model_overview` on the scope.
2. **The user points at the diagram** ("these blocks", "the ones on the left"): ask them to select the blocks in the editor, then read the selection:
   ```matlab
   sel = find_system('<scopePath>', 'SearchDepth', 1, 'Type', 'Block', 'Selected', 'on');
   ids = cellfun(@(p) ['blk_' extractAfter(Simulink.ID.getSID(p), ':')], sel, 'UniformOutput', false)
   ```
   A selection can be stale: earlier operations sometimes leave blocks selected. Read the block names back to the user and confirm before laying out.
3. **Overlaps:** run the overlap check in [Choose the Method](#choose-the-method), step 1.

## After Layout

- Read the `layout:` block in the response. `applied: false` comes with a `detail` that explains why. Report it; don't retry blindly.
- Run `model_check(model, scope, '["unconnected_lines"]')` to confirm that the wiring survived.
- Tell the user which blocks moved, and mention any downstream blocks that shifted.

## Restructuring Subsystems

To group blocks into a new subsystem, or expand a subsystem in place, see [references/subsystem-restructuring.md](references/subsystem-restructuring.md). Don't rebuild the content block by block with `model_edit`. After either operation, run no layout. Offer a full layout of the affected scope, and run it only if the user agrees.

## Rules to Remember

- Move blocks with a `layout` operation, or with `configure` `Position` through `model_edit`, not with `set_param` block by block. `set_param` skips line rerouting and the `model_edit` pipeline.
- Use `Simulink.BlockDiagram.arrangeSystem` only when the user asks for Auto Arrange by name.
- Ask before any full layout of an existing diagram, even when the model is small, a backup exists, or the user said "clean up the whole thing".
- Group blocks with `Simulink.BlockDiagram.createSubsystem`. Copying blocks in one at a time loses wiring and layout. After grouping or expanding, offer a full layout instead of running one.
- Recommend saving before large moves. Ctrl+Z is not reliable for agent edits.

----

Copyright 2026 The MathWorks, Inc.

----
