# Failures, Iteration, and Common Mistakes

Loaded on demand from SKILL.md: read when a call errors, returns without moving anything, or produces a result that reads poorly.

## Iterating on a Result

A first call that returns cleanly but reads badly is a normal outcome, not an error. `applySFAutolayout` is safe to call repeatedly on the same content — reach for a second call rather than reporting a poor diagram as finished.

| Situation | Next call |
|-----------|-----------|
| Result is legible but the wrong shape for the diagram (wide and flat, or a long single column) | Same scope, different `orientation` — or `type` if this is a full layout |
| A large diagram came back cramped or the engine refused it as too large | No layout call fixes this — the limit is per diagram, so re-targeting the same diagram by SID passes the same object count. Group related objects into subcharts to split one diagram into several, then re-run the all-subviewers form, which lays out each separately. That is a content edit, not a layout one: ask the user first |
| Only part of the diagram needed arranging and a full pass disturbed the rest | Re-run as incremental, listing just the objects that mattered |
| User added more objects after the last layout | Another incremental call, listing the new batch |

Two things to hold onto across iterations. The layout state manager is a singleton, so reusing `lsm` between calls is correct and cheap. And every call compounds — the diagram you are re-laying out is the one the previous call produced, not the original, so a full layout has already discarded the arrangement a previous incremental call was preserving.

Do not loop blindly. Each call should change something — scope, `type`, `orientation`, or the incremental object list. Repeating an identical call gets an identical result, and the failures in [Engine and Environment Failures](#engine-and-environment-failures) are not fixed by retrying.

## Engine and Environment Failures

These are not argument mistakes — the call was well formed and the engine or environment refused it. **Retrying the same call will not help.** Report the situation instead of looping.

| Message | Meaning | What to do |
|---------|---------|-----------|
| `Too many Stateflow objects in the diagram. Please group objects into multiple subviewers to reduce size and improve processing speed.` | One diagram holds more objects than the engine processes in a single pass | Do not retry, and do not just re-target that diagram by SID — the limit is per diagram, so it will refuse the same content again. The diagram has to be split: tell the user it needs its objects grouped into subcharts, which is a content edit for them to approve, and re-run the all-subviewers form afterwards — it lays out each new subviewer separately |
| `fail to get SF auto-layout result: error in calculating graph` | The engine ran but could not compute a result for this graph | Do not retry unchanged. Here targeting subviewers by SID one at a time *is* worth doing — not to shrink anything, but to find which subviewer the engine cannot compute, so the rest still get laid out. Report that one as uncomputable |
| `Unable to find Stateflow content for SF auto-layout.` | The model has a Stateflow machine but no valid subviewer survived filtering | Check whether every chart in the model is an invalid type (Requirements Table, Truth Table, State Transition Table, LinkChart) |
| Silent return, nothing moved | No Stateflow machine for the named model | The charts are probably in a referenced model — target that model by name (see SKILL.md Precondition) |

## Common Mistakes

| Mistake | Why It Fails | Correct Approach |
|---------|-------------|-----------------|
| Calling layout on a model that is not loaded | The function never opens or loads a model itself | `open_system(modelName)` first (preferred over `load_system` — the user can see the result) |
| Re-laying out a diagram right after editing it via `model_edit` | `model_edit` already ran Stateflow layout on the edited scope | Only call layout again for non-default config, explicit incremental control, or a visibly bad result |
| Omitting `layoutStateManager` | `MATLAB:minrhs` — "Function requires 1 more input" | Pass `layout.LayoutStateManager.instance()` as argument 2 |
| Passing `incMap` as argument 2 (pre-2.0 call) | `Argument 'layoutStateManager' must be an instance of layout.LayoutStateManager.` | `incMap` is now argument 3 |
| `"myModel"` as `sys` | Double-quoted `string` is rejected | Use `'myModel'` (char) or a model handle |
| `containers.Map` as incMap | Wrong type — must be `dictionary` | `dictionary` + assign, or omit for full layout |
| `[]` as the incMap placeholder | Not convertible to `dictionary` | Pass a bare `dictionary` |
| `incMap(sid) = {sid1, sid2}` | Wrong nesting — needs cell-in-cell | `incMap(sid) = {{sid1, sid2}}` |
| Keying `incMap` by a subchart's SID | Only chart-level keys are supported; the result is undefined even when layout appears to run | Key by the parent chart's SID; pass the subchart's SID as `viewerSID` |
| Keying `incMap` by an AtomicSubchart's own SID | The key must be a Chart; an AtomicSubchart is not one | Key by `atomicSubchart.Subchart` |
| Bare-number `viewerSID` (`"7"`) | Missing the model-name prefix | Use the full SID from `Simulink.ID.getSID` |
| Expecting `type='orthogonal'` to apply to incremental | Forced to `'hierarchical'` internally | Only set `type` for full layout |
| Passing Requirements Table SID | It is class `Stateflow.Chart` but not a valid subviewer | Filter before calling layout |
| Passing LinkChart SID | Not a valid subviewer | Skip `Stateflow.LinkChart` objects |
| No editability check | Confusing error: `'X' is locked` | Check `.Locked` and `.Iced` on the correct chart first |
| Checking parent chart for AtomicSubchart | Parent lock doesn't affect AtomicSubchart | Check `atomicSubchart.Subchart.Locked` instead |
| Reporting success without saying the model is unsaved | Layout lives in memory only; closing the model loses it silently | Report the change and that it is unsaved (SKILL.md Step 9) |
| Saving the model to "finish the job" | Closing without saving is the only undo; saving also commits unrelated in-memory edits | Leave saving to the user unless they asked |
| Full layout on a diagram that was already deliberately arranged | Discards the user's work with no undo | Prefer incremental, or ask first (SKILL.md Step 5) |
| Reporting a cramped or ugly result as done | Layout is repeatable — a second call with different scope or `type` is normal use | Iterate (see [Iterating on a Result](#iterating-on-a-result)) |
| Retrying the identical call after a poor result | Same inputs, same result | Change scope, `type`, `orientation`, or the object list |
| Laying out the enclosing chart when the user meant one subchart | "Chart" in a request often names whatever diagram is open, at any depth | Identify the actual subviewer and pass its SID as `viewerSID` |

----

Copyright 2026 The MathWorks, Inc.

----
