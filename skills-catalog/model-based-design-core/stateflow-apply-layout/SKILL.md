---
name: stateflow-apply-layout
description: >
  Use when a Stateflow diagram needs arranging — after adding states,
  transitions, or junctions through the Stateflow API has left elements
  overlapping, or when someone opens an existing chart, subchart state,
  box or function, atomic subchart, or atomic box and wants a messy diagram
  cleaned up, organized, reorganized, or tidied with no edit involved.
  Also use when a user names applySFAutolayout directly.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "2.4.0"
---

# Apply Stateflow Layout

Apply auto-layout to Stateflow subviewers using `applySFAutolayout`. Use after API edits to arrange overlapping elements, or to reorganize an existing messy diagram — no edit needs to have happened.

**Layout is repeatable, not a one-shot step.** Expect more than one call in a single task: once per subviewer when a diagram is too large for one pass, again with a different `type` or `orientation` when the first result reads poorly, and once per edit round when working incrementally. Calling it again is normal use, not a sign something failed.

## When to Use

- After adding states, transitions, or junctions via the Stateflow API (elements default to overlapping positions)
- User asks to "arrange", "layout", "auto-layout", or "clean up" any Stateflow subviewer
- User wants to reorganize a messy existing Stateflow diagram
- User asks to layout all Stateflow subviewers in a model
- User asks to layout only what they just added, or to keep the existing arrangement intact (incremental) — they will usually say "states", but this covers any new object
- User asks to layout a specific chart, subchart state, subchart box, subchart function, atomic subchart, or atomic box
- A previous layout ran but reads poorly, and the user wants a different arrangement

**"Chart" in a user's request rarely means "top-level chart only."** People say chart, diagram, or state machine for whatever is open in front of them — which may be a subchart several levels down, an atomic subchart, or a subchart box or function. Identify the actual subviewer before choosing a target; laying out the whole enclosing chart when the user meant one subchart rearranges work they did not ask you to touch.

## When NOT to Use

- Arranging Simulink **blocks** in a block diagram — that is `model_edit`'s `layout_mode`, not this skill
- Creating or editing Stateflow objects (states, transitions, junctions) — use `building-simulink-models` skill
- Querying chart structure without modification
- Re-arranging a diagram that `model_edit` just laid out for you (see below)

## Relationship to `model_edit`

`model_edit` **does** lay out Stateflow content. When Stateflow edits go through it, it calls this same layout engine automatically on the edited scope. Do not assume Stateflow layout is unhandled there, and do not immediately re-layout a diagram `model_edit` just arranged.

Its automatic pass is deliberately narrow, though. Call `applySFAutolayout` yourself when any of these apply:

| Situation | Why the automatic pass doesn't cover it |
|-----------|------------------------------------------|
| You need a non-default `type` or `orientation` | The automatic pass always uses defaults — orthogonal, top_to_bottom. There is no config passthrough |
| You need to choose which objects are treated as new | The automatic pass builds its own object list from the edits it just made; a caller cannot supply an `incMap` |
| Layout of an existing diagram with no edit | The pass is triggered by an edit — a "clean up this messy diagram" request has nothing to hook |
| Stateflow edits made through the raw Stateflow API | Nothing went through `model_edit`, so nothing triggered layout |
| The automatic pass ran but the result still overlaps or reads poorly | Re-layout explicitly, optionally with a different `type` |

If you edited through `model_edit` and the user only wanted the elements arranged, layout has already happened — say so instead of calling layout a second time.

## The Signature

```matlab
applySFAutolayout(sys, layoutStateManager, incMap, viewerSID, config)
```

Arguments 1 and 2 are **required**. Arguments 3, 4, and 5 are optional but positional — to reach a later one you must supply the earlier ones.

| # | Argument | Type | Default |
|---|----------|------|---------|
| 1 | `sys` | model handle, or model name as a **`char` array** | required |
| 2 | `layoutStateManager` | `layout.LayoutStateManager` | required |
| 3 | `incMap` | `dictionary` | `dictionary(string.empty, {cell.empty})` (full layout) |
| 4 | `viewerSID` | `string` SID, or `[]` for all subviewers | `[]` |
| 5 | `config` | `struct` | `struct()` (orthogonal, top_to_bottom) |

Sanity-check the signature before relying on it — `nargin('applySFAutolayout')` must return `5`. If it returns `4`, the installed toolkit predates this skill; the second argument is then `incMap` and there is no layout state manager.

## Workflow

Follow these steps in order.

### Precondition: the model must be loaded

`applySFAutolayout` will not open or load a model for you — it resolves `sys` to a handle and goes straight to work.

Either `load_system` or `open_system` satisfies this, but **prefer `open_system`**: layout is a visual change, and opening the model lets the user see the result.

```matlab
if ~bdIsLoaded(modelName)
    open_system(modelName);   % load_system also works, but the user cannot see the result
end
```

Two distinct failure shapes follow from getting this wrong, and only one of them is loud:

- **Model not loaded** — resolving the model handle fails before any layout runs. Loud.
- **Model loaded but no Stateflow machine found** — the all-subviewers form **returns silently, laying nothing out**. This happens when the charts live in a *referenced* model rather than the one you named (subsystem reference or model reference). Silent.
- **Machine found but no valid subviewer survives filtering** — errors with `Unable to find Stateflow content for SF auto-layout.` Loud.

Because the middle case is silent, never treat a clean return as proof that layout ran (see Step 8). If the charts live in a referenced model, name that model in `sys`.

### Step 1: Get the layout state manager

Required for every call. It is a singleton — ask for the instance, never construct one:

```matlab
lsm = layout.LayoutStateManager.instance();
```

Repeated calls return the same object, so it is safe to fetch it once per script or once per call. There is nothing to release or clean up afterwards.

If this errors with an undefined variable or class, the toolkit is not on the MATLAB path. Tell the user the MATLAB Agentic Toolkit needs to be installed and configured; do not try to work around it.

### Step 2: Identify target subviewers

Determine what to layout:
- **All subviewers in a model** — call `applySFAutolayout(modelName, lsm)` (simplest form, skips invalid types automatically)
- **Specific subviewer** — identify it and get its SID
- **Multiple specific subviewers** — call once per subviewer

**Getting the SID for a subviewer:** use the object's own SID in all cases, including AtomicSubchart and AtomicBox. `applySFAutolayout` resolves their backend charts internally.

```matlab
viewerSID = string(Simulink.ID.getSID(subviewer));
```

The SID must be model-qualified (`'myModel:1:7'`). A bare number like `"7"` is rejected with `subviewerSID must be starting with model name`.

**Finding the subviewers in a model.** When the user says "all charts" or names a subviewer you have to locate, enumerate from the model's Stateflow machine. This is the same query the all-subviewers form runs internally:

```matlab
rt = sfroot();   % NOT sfroot.find(...) — dot-indexing a function call needs the parentheses
machine = rt.find('-isa', 'Stateflow.Machine', 'Name', modelName);

candidates = machine.find('-isa', 'Stateflow.Chart', ...
    '-or', '-isa', 'Stateflow.State',    'IsSubchart', true, ...
    '-or', '-isa', 'Stateflow.Box',      'IsSubchart', true, ...
    '-or', '-isa', 'Stateflow.Function', 'IsSubchart', true);
```

An empty `machine` means the model has no Stateflow content — stop here rather than calling layout, which would return silently.

**How atomics appear in that list.** AtomicSubcharts and AtomicBoxes are *not* returned as themselves — their **backend charts** are, as `Stateflow.Chart` objects carrying the same `Name`. Layout coverage is therefore already complete: laying out `candidates` reaches atomic content, and matching on `Name` still finds it.

Run a second query only when you need the atomic **object** rather than its backend chart — to read `.Subchart.Locked` / `.Subchart.Iced` through the object, or to build the `incMap` key and `viewerSID` pair from the three-handle rule in [references/calling-convention-examples.md](references/calling-convention-examples.md):

```matlab
atomics = machine.find('-isa', 'Stateflow.AtomicSubchart', ...
    '-or', '-isa', 'Stateflow.AtomicBox');
```

If you merge the two lists, de-duplicate by SID first: an atomic and its backend chart are two handles onto the same content, so laying out both is wasted work. Then filter per Step 3. To narrow by name, add `'Name', 'Controller'` to the `find` call.

Prefer the all-subviewers form `applySFAutolayout(modelName, lsm)` when the user wants everything — it enumerates and filters internally, so there is nothing to get wrong.

### Step 3: Filter invalid subviewers (when targeting specific subviewers)

Skip these — they are NOT valid subviewers for layout:

| Type | Detection |
|------|-----------|
| Truth Table Chart | `isa(obj, 'Stateflow.TruthTableChart')` |
| State Transition Table Chart | `isa(obj, 'Stateflow.StateTransitionTableChart')` |
| Link Chart (library link) | `isa(obj, 'Stateflow.LinkChart')` |
| Requirements Table | `isRequirementsTable(chartHandle)` |

The Requirements Table has class `Stateflow.Chart` — it is indistinguishable by `isa` alone. Always check before passing a Chart SID.

Passing an invalid subviewer's SID errors with `Unable to find target subviewer, expect Stateflow Chart, Subchart State, Subchart Box or Subchart Function only.` Filtering up front avoids surfacing that to the user.

The all-subviewers form (`viewerSID` omitted) filters Requirements Tables itself, so no pre-filtering is needed there.

Do not mention the internal helper functions — `isRequirementsTable` or `layout.LayoutStateManager` — in responses to users. Silently skip invalid subviewers.

**Valid subviewers:**

| Subviewer | Identification |
|-----------|---------------|
| Chart | `isa(obj, 'Stateflow.Chart')` and not a Requirements Table |
| Atomic Subchart | `isa(obj, 'Stateflow.AtomicSubchart')` |
| Atomic Box | `isa(obj, 'Stateflow.AtomicBox')` |
| Subchart State | `isa(obj, 'Stateflow.State') && obj.IsSubchart` |
| Subchart Box | `isa(obj, 'Stateflow.Box') && obj.IsSubchart` |
| Subchart Function | `isa(obj, 'Stateflow.Function') && obj.IsSubchart` |

### Step 4: Check editability

`applySFAutolayout` does **not** check this for you. A subviewer must be editable before layout can be applied. Check both conditions:
- `Locked == false` (not explicitly locked by user/developer)
- `Iced == false` (model is not running or paused)

**Which chart to check depends on the subviewer type:**

| Subviewer Type | Check |
|----------------|-------|
| `Stateflow.Chart` | `chart.Locked`, `chart.Iced` |
| `Stateflow.AtomicSubchart` | `obj.Subchart.Locked`, `obj.Subchart.Iced` |
| `Stateflow.AtomicBox` | `obj.Subchart.Locked`, `obj.Subchart.Iced` |
| Subchart State | `state.Chart.Locked`, `state.Chart.Iced` |
| Subchart Box | `box.Chart.Locked`, `box.Chart.Iced` |
| Subchart Function | `fcn.Chart.Locked`, `fcn.Chart.Iced` |

AtomicSubchart and AtomicBox have independent backend charts (accessed via `.Subchart`). Locking the parent chart does NOT block their layout.

Subchart State/Box/Function belong to the parent chart. Locking the parent chart blocks their layout.

If a subviewer is not editable, skip it and inform the user.

### Step 5: Choose mode

- **Full layout** — recomputes all positions in the subviewer. Use when arranging from scratch or reorganizing.
- **Incremental layout** — prioritizes positioning the objects you list while minimizing disruption to the existing layout. The engine may make minor adjustments to existing positions for optimization. Use when the user added something and wants the existing arrangement kept largely intact.

The listed objects are usually the ones just added, and users will usually describe them as "states" — but the list takes **any** Stateflow object: states, transitions, junctions, boxes, and functions, including objects nested inside a subchart State, Box, or Function.

**Full layout discards a hand-arranged diagram.** There is no undo through the API. If the user's existing arrangement looks deliberate, or they say anything about keeping it, prefer incremental. When in doubt on a diagram that is already tidy, ask before running a full layout.

### Step 6: Construct incMap (incremental only)

`incMap` is a `dictionary` that controls full vs. incremental behavior per subviewer.

**For full layout:** omit the argument entirely. If you need to reach `viewerSID` or `config`, pass a bare `dictionary` as a placeholder:

```matlab
applySFAutolayout(modelName, lsm, dictionary, viewerSID);
```

`[]` is **not** accepted here — it fails with `Value must be of type dictionary or be convertible to dictionary`.

**For incremental layout:**

The key is **always a Chart's SID** — never a subchart's, even when the layout target is a subchart.

```matlab
chartSID = string(Simulink.ID.getSID(chart));

incMap = dictionary;
incMap(chartSID) = {{Simulink.ID.getSID(newObj1), Simulink.ID.getSID(newObj2)}};
```

The value is a **cell containing a cell array** of SIDs for the new objects. This `{{...}}` syntax is required. List every new object belonging to that chart, including objects that live inside one of its subchart States, Boxes, or Functions.

**Which chart SID to use as the key:**

| Layout target | `incMap` key | `viewerSID` (argument 4) |
|---------------|--------------|--------------------------|
| Chart | the chart's own SID | the chart's SID |
| Subchart State / Box / Function | the **parent chart's** SID | the subchart's SID |
| AtomicSubchart / AtomicBox | the **backend `.Subchart`** SID | the object's own SID |

The key and `viewerSID` are independent: `viewerSID` selects which subviewer gets laid out, while the key is always chart-level. Keying by a subchart's SID is unsupported — do not rely on it, even if a given chart appears to lay out anyway.

**incMap logic:**
- Chart SID present as key → incremental layout for that chart (only listed objects are positioned)
- Chart SID absent → full layout for that chart
- Empty or omitted → full layout for all targeted subviewers

One dictionary can carry **several chart keys**, mixing modes in a single call — see Mixed mode in [references/calling-convention-examples.md](references/calling-convention-examples.md). That is why `incMap` is a dictionary and not a plain list of objects.

### Step 7: Call applySFAutolayout

```matlab
lsm = layout.LayoutStateManager.instance();

applySFAutolayout(modelName, lsm)                              % full layout, all subviewers
applySFAutolayout(modelName, lsm, incMap)                      % mixed: per-subviewer mode
applySFAutolayout(modelName, lsm, dictionary, viewerSID)       % single subviewer, full
applySFAutolayout(modelName, lsm, incMap, viewerSID)           % single subviewer, incremental
applySFAutolayout(modelName, lsm, dictionary, [], config)      % all subviewers with config
applySFAutolayout(modelName, lsm, incMap, viewerSID, config)   % single subviewer with config
```

`modelName` must be a `char` array (single quotes) or a model handle. A double-quoted `string` is rejected with `first input argument must be model handle or model name in char array`. When the model name arrives as a `string`, convert it with `char(...)`.

### Step 8: Confirm the layout actually ran

A clean return is not evidence that layout ran: the all-subviewers form returns silently when no Stateflow machine matches `sys` (see Precondition). Confirm before reporting success. Two ways, in order of cost:

**If you enumerated in Step 2, you are already covered.** A non-empty `machine` rules out the silent case — that is the only condition it hides. No diff needed.

**Otherwise, diff positions across the call.** Required when you called the all-subviewers form without enumerating first; a good idea whenever the result matters:

```matlab
machine = sfroot().find('-isa', 'Stateflow.Machine', 'Name', modelName);
targets = machine.find('-isa', 'Stateflow.State');   % any object set inside the target
before  = vertcat(targets.Position);

applySFAutolayout(modelName, lsm, dictionary, viewerSID);

after = vertcat(targets.Position);
if isequal(before, after)
    % nothing moved — do not report success
end
```

If nothing moved, re-check that the model is loaded and that `viewerSID` names a valid subviewer. Report the problem rather than claiming success.

For **incremental** layout, check that the objects you listed are no longer stacked on top of one another. Newly created Stateflow objects all share a single default rectangle, so identical positions among them means they were never placed. Existing elements may shift slightly by design, so unchanged existing positions are not themselves a failure.

### Step 9: Tell the user the model is unsaved

`applySFAutolayout` changes positions in memory. **It does not save the model.** Nothing warns the user, and nothing else in this workflow saves for them.

Say so when you report the result. It matters in both directions:

- If they are happy with the layout, it is lost when the model closes unless they save.
- If they are not, closing without saving is the **only** way back — there is no undo through the API, and a full layout has already discarded whatever arrangement was there before.

Do not save on their behalf unless they asked. Saving forecloses the second option, and it may commit unrelated in-memory changes they were not ready to write.

## Configuration

Pass a struct as the 5th argument to control layout style:

```matlab
config = struct('type', 'orthogonal', 'orientation', 'top_to_bottom');
applySFAutolayout('myModel', lsm, dictionary, viewerSID, config);
```

| Field | Values | Default |
|-------|--------|---------|
| `type` | `'orthogonal'`, `'hierarchical'` | `'orthogonal'` |
| `orientation` | `'top_to_bottom'`, `'bottom_to_top'`, `'left_to_right'`, `'right_to_left'` | `'top_to_bottom'` |

Partial config is fine — unspecified fields use defaults.

**`type` is ignored for incremental layout.** Whenever `incMap` has at least one entry, `applySFAutolayout` overwrites `config.type` with `'hierarchical'` before running, because orthogonal incremental layout treats grouped nodes as fixed and errors when an incremental node has children. `orientation` is still honored. Do not tell the user they got an orthogonal incremental layout — they did not.

## Getting SIDs

Use `Simulink.ID.getSID(handle)` for any Stateflow object:

```matlab
chartSID = Simulink.ID.getSID(chart);
stateSID = Simulink.ID.getSID(stateHandle);
```

Do NOT use `getfullname` or path strings as SIDs.

## Examples, Failures, and Iteration

A poor first result is normal — iterate by changing scope, `type`, `orientation`, or the incremental object list. Never repeat an identical call: it gives an identical result. Load these on demand:

- **[references/calling-convention-examples.md](references/calling-convention-examples.md)** — complete worked calls: full, single-subviewer, incremental, **mixed mode** (several chart keys in one `incMap`), subchart targets, and AtomicSubchart/AtomicBox with the three-handle rule. Read before writing any call that passes `incMap` or `viewerSID`.
- **[references/failures-and-iteration.md](references/failures-and-iteration.md)** — read when a call errors, returns but moved nothing, or reads poorly: which call to make next, engine refusals that retrying will not fix (`Too many Stateflow objects…`, `error in calculating graph`), and the full common-mistakes table.

----

Copyright 2026 The MathWorks, Inc.

----
