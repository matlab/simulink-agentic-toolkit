# Stateflow Chart Editing Rules

`model_edit` can add Stateflow Chart blocks and configure block-level parameters, but **cannot** edit chart internals. Use `evaluate_matlab_code` with the Stateflow API for states, transitions, junctions, and data.

Before editing chart internals, call `open_system('ModelName/ChartBlockName')` to navigate the view into the chart so the user can observe changes.

## Accessing the Chart Object

```matlab
ch = find(sfroot, "-isa", "Stateflow.Chart", Path="ModelName/ChartBlockName");
```

## Wiring Transitions

Unlike `model_edit` port-based connections, Stateflow transitions are wired by assigning state objects:

```matlab
t = Stateflow.Transition(chart);
t.Source = stateA;
t.Destination = stateB;
t.LabelString = '[guard]{condAction}/transAction';
```

## Key Gotchas

- **State actions are set through `LabelString`, not individual properties.** `EntryAction`, `DuringAction`, `ExitAction` are read-only. Build the full label:
  ```matlab
  s.LabelString = sprintf('MyState\nentry: x=0;\nduring: y=y+1;\nexit: cleanup();');
  ```
- **Transition labels work the same way.** `Condition`, `ConditionAction`, `TransitionAction` are read-only -- set via `LabelString` using the format `[condition]{condAction}/transAction`:
  ```matlab
  t.LabelString = '[x > threshold]{count = count + 1;}/output = true;';
  ```
- **Default transitions** have no `Source` -- set `Destination`, `DestinationOClock`, `MidPoint`, `SourceEndPoint`. `MidPoint` and `SourceEndPoint` must be inside the destination's parent bounds. If targeting a junction, ensure at least one unconditional outgoing path -- otherwise error "default transition path must terminate in a state".
- **Parallel (AND) decomposition** is set on the **parent**, not the children: `parentState.Decomposition = "PARALLEL_AND";`
- **Junction positions** use a different API than states: `j.Position.Center = [x y]; j.Position.Radius = r;` (not a 4-element vector).
- **Always set `Position`** on new states -- all default to `[0 0 90 60]` and will overlap.
- **Set `ActionLanguage`** early (`ch.ActionLanguage = "MATLAB";`) since it affects label parsing.
- **MATLAB functions (`Stateflow.EMFunction`)** use `Script` for the function body, not `LabelString`. `LabelString` only sets the signature display.

## Subcharts

Prefer subcharts (`s.IsSubchart = true`) over plain superstates when a state has 3+ substates or when cross-hierarchy transitions would be needed between superstates.

```matlab
s = Stateflow.State(ch); s.IsSubchart = true;
sChild = Stateflow.State(s);  % children created inside the subchart
```

**No cross-subchart transitions.** Never wire children of one subchart to children of another. Route transitions between subcharts at the parent scope; use condition actions to pass context, then dispatch internally via junction. To target a specific child across boundaries, use subchart entry/exit ports.

## Post-Edit Workflow

**Always run lint then autolayout after every Stateflow edit.** Unlike `model_edit`, Stateflow API edits do not trigger autolayout automatically.

1. **Lint:** `utils.sfCheckChart(ch)` (or scoped: `utils.sfCheckChart(ch, subchartState)`)
   - Returns struct array with `handle`, `name`, `details`. Empty when clean.
   - Fix innermost first; re-run after each fix to clear hierarchical false positives.
2. **Layout:** Call `applySFAutolayout` (requires R2023b+). `viewerSID` = SID of chart or subchart.

**Full layout** — recomputes all positions:
```matlab
applySFAutolayout(modelName, dictionary(string.empty, {cell.empty}), viewerSID);
```

**Incremental layout** — positions only new objects (build in stages: add a group, collect SIDs, apply, repeat):
```matlab
incMap = dictionary;
incMap(viewerSID) = {{Simulink.ID.getSID(obj1), Simulink.ID.getSID(obj2), ...}};
applySFAutolayout(modelName, incMap, viewerSID);
```

**Incremental gotchas:**
- Use `Stateflow.State(parent)` to establish hierarchy — don't rely on position containment
- Make superstates large enough for substates + labels (positions are absolute)
- Position default transition `SourceEndpoint` inside parent bounds
- Include affected superstate inner transition SIDs when adding cross-hierarchy transitions
- Resize plain superstates before adding substates (Stateflow doesn't auto-expand). Subcharts have their own coordinate space and don't need resizing
