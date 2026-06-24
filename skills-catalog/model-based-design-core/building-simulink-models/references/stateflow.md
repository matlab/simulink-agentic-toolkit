<!-- Copyright 2026 The MathWorks, Inc. -->

# Stateflow Chart Editing Rules

`model_edit` edits chart internals natively. Scope to a chart and use the same operations — the scope determines the domain.

## Scoping into a Chart

Use `sf_X` (from `model_read`) or a Chart's `blk_X` (auto-detects as SF scope) as the `scope` parameter.

**Two-call workflow for mixed SL + SF editing:**

```text
Call 1 (SL scope):
  model_edit(model="M", scope="root", operations=[
    {"op": "add_block", "type": "Chart", "name": "Controller", "ref": "ctrl"}
  ])
  → created: {ctrl: blk_45}

model_read(model="M", scope="blk_45", depth="0")
  → discover chart internal scope: sf_1

Call 2 (SF scope):
  model_edit(model="M", scope="sf_1", operations=[...], layout_mode="full")
```

Valid SF scopes: Chart, State, Box. All other element types (Junction, StateflowFunction, EMFunction, TruthTable, SLFunction, SimulinkBasedState, Data, Event, Message, Annotation, Transition) are not valid scopes.

## Adding Elements

Graphical elements (State, Junction, Box) and nongraphical elements (Data, Event, Message):

```json
[{"op": "add_block", "type": "State", "name": "Idle", "ref": "idle",
  "params": {"LabelString": "Idle\n en: motorCmd = 0;"}},
 {"op": "add_block", "type": "Junction", "ref": "j1"},
 {"op": "add_block", "type": "Box", "name": "Utilities", "ref": "box1"},
 {"op": "add_block", "type": "Data", "ref": "d1",
  "params": {"Name": "speed", "Scope": "Input", "DataType": "double"}},
 {"op": "add_block", "type": "Event", "ref": "e1",
  "params": {"Name": "Reset", "Scope": "Input", "Trigger": "Rising"}}]
```

Function types — `StateflowFunction`, `EMFunction`, `TruthTable` (name derived from LabelString — don't set Name directly):

```json
[{"op": "add_block", "type": "StateflowFunction", "ref": "fn1",
  "params": {"LabelString": "y = saturate(u, limit)"}},
 {"op": "add_block", "type": "EMFunction", "ref": "fn2",
  "params": {"Name": "CalcSOC",
             "Script": "function soc = CalcSOC(v, i)\n  soc = v * 0.95 - i * 0.01;\nend"}},
 {"op": "add_block", "type": "TruthTable", "ref": "tt1",
  "params": {"LabelString": "y = faultLogic(a, b)"}}]
```

Position is optional — autolayout handles placement. Name collisions are auto-suffixed (Idle -> Idle1).

## Transitions (connect / disconnect)

SF transitions use **portless** syntax — no `.y1`/`.u1` suffixes:

```json
[{"op": "connect", "target": "? -> #idle",
  "comment": "default transition (no source)"},
 {"op": "connect", "target": "#idle -> #running",
  "params": {"LabelString": "[startCmd == 1]", "ExecutionOrder": 1}},
 {"op": "connect", "target": "#running -> #idle",
  "params": {"LabelString": "[stopCmd == 1]/motorCmd = 0;", "ExecutionOrder": 1}},
 {"op": "connect", "target": "#running -> #j1",
  "params": {"LabelString": "[errorFlag]{faultCount = faultCount + 1;}", "ExecutionOrder": 2},
  "ref": "t1"}]
```

- `? -> #target` creates a default transition (no source)
- `#a -> #a` creates a self-loop (accepted, not rejected)
- `ExecutionOrder` sets evaluation priority when multiple transitions share a source (critical for junction chains)
- `ref` on `connect` returns the transition's `sf_X` ID in the created map

**Disconnect** — three targeting modes:

```json
[{"op": "disconnect", "target": "sf_50", "comment": "by transition ID"},
 {"op": "disconnect", "target": "sf_10 -> sf_11", "comment": "by endpoint pair"},
 {"op": "disconnect", "target": "? -> sf_10", "comment": "default transition"}]
```

## Post-Edit Validation

**Run `model_check` after every Stateflow edit** to catch structural issues (missing default transitions, unreachable states, conflicting transitions):

```matlab
model_check(model="M", checks='["stateflow_lint"]', scope="blk_45")
```

- `scope`: the chart's block ID (same `blk_X` used to scope into the chart)
- If an issue requires domain decisions (ambiguous guard conditions, missing data definitions), present it to the user rather than guessing.
- Fix innermost issues first; re-run after each fix to clear hierarchical false positives.

### Super Transitions

`model_edit` does not support transitions that cross subchart (`IsSubchart = true`) boundaries.

**You can use composite states instead of subcharts for cross-hierarchy transitions.** With regular composite states (`IsSubchart = false`), cross-level transitions work natively via `model_edit` — scope to the common ancestor and connect directly:

```json
[{"op": "connect", "target": "#deepState -> #topState",
  "params": {"LabelString": "[exitCondition]"}}]
```

Check with the user if they want subcharts or composite states. If subcharts are specifically required and cross-boundary transitions are needed, use `evaluate_matlab_code` with the `Stateflow.Port` API. Super transitions are multi-segment — each subchart boundary crossing requires a port pair and a separate transition segment. Always use Ports to cross boundaries:

```matlab
rt = sfroot;
chart = rt.find('-isa', 'Stateflow.Chart', 'Path', 'ModelName/ChartName');
L1 = chart.find('-isa', 'Stateflow.State', 'Name', 'Level1');  % IsSubchart=true
L2 = L1.find('-isa', 'Stateflow.State', 'Name', 'Level2');     % IsSubchart=true
innerState = L2.find('-isa', 'Stateflow.State', 'Name', 'InnerState');
topState = chart.find('-isa', 'Stateflow.State', 'Name', 'TopState');

% Segment 1: InnerState -> exit L2
exitJ_L2 = Stateflow.Port(L2, 'ExitJunction');
t1 = Stateflow.Transition(L2);
t1.Source = innerState;
t1.Destination = exitJ_L2;
t1.LabelString = '[exitCondition]';

% Segment 2: exit L2 -> exit L1
exitP_L2 = Stateflow.findMatchingPort(exitJ_L2);
exitJ_L1 = Stateflow.Port(L1, 'ExitJunction');
t2 = Stateflow.Transition(L1);
t2.Source = exitP_L2;
t2.Destination = exitJ_L1;

% Segment 3: exit L1 -> TopState
exitP_L1 = Stateflow.findMatchingPort(exitJ_L1);
t3 = Stateflow.Transition(chart);
t3.Source = exitP_L1;
t3.Destination = topState;
```


## Truth Table Configuration

`ConditionTable` and `ActionTable` are set as whole cell arrays via `model_edit`'s `configure`
**ConditionTable format** (N rows × M cols cell array):
- Rows 1..N-1: condition rows. `[Description, "Label:\ncondition_expr", "T"/"F"/"-", ...]`
- Row N: action row. `[Description, "", "action_nums", ...]` — action nums are comma-separated row indices from ActionTable (e.g., `"1,3"`)

**ActionTable format** (P rows × 2 cols cell array):
- Each row: `[Description, "Label:\naction_code"]`

Example `configure` params for a 3-condition, 4-decision truth table:

```json
{"ConditionTable": [
    ["", "C1:\nspeed > 100", "T", "T", "F", "F"],
    ["", "C2:\ntemp > 80",   "T", "F", "T", "F"],
    ["", "C3:\nfault == 1",  "-", "T", "-", "F"],
    ["", "",                  "1", "2", "3", "4"]
 ],
 "ActionTable": [
    ["", "Shutdown:\noutput = 0; alarm = 1;"],
    ["", "Degrade:\noutput = 0.5;"],
    ["", "Warn:\nalarm = 1;"],
    ["", "Normal:\noutput = 1;"]
 ]}
```

## LabelString Patterns

**State labels** — name on first line, then action keywords:

```text
StateName
en: x = 0;
du: y = y + 1;
ex: cleanup();
```

Set via: `"LabelString": "StateName\n en: x = 0;\n du: y = y + 1;\n ex: cleanup();"`

**Transition labels** — format: `event[condition]{condAction}/transAction`:

```text
[x > threshold]{count = count + 1;}/output = true;
```

**`EntryAction`, `DuringAction`, `ExitAction`, `Condition`, `ConditionAction`, `TransitionAction` are ALL READ-ONLY.** Always set `LabelString` directly.

**EMFunction** uses `Script` for the function body. `LabelString` sets only the signature display.

### Temporal Logic Operators

Use these instead of manual counters/timers

- `duration(cond)` — time (sec) a condition has been continuously true
- `after(n, sec)` / `after(n, tick)` — true after n time units in current state
- `count(cond)` — number of ticks a condition has been true
- `elapsed(sec)` — time since current state was entered
- `before(n, sec)` — true until n seconds have passed in current state
- `every(n, sec)` / `every(n, tick)` — fires periodically while in current state
- `temporalCount(cond)` — number of time steps a condition has been true

Example — transition guard using `duration` instead of a manual counter:
```text
[duration(speed > threshold) >= 5]
```

## Configuring Properties

```json
[{"op": "configure", "target": "sf_10",
  "params": {"LabelString": "Monitoring\n en: count = 0;\n du: process();"}},
 {"op": "configure", "target": "chart:MyModel",
  "params": {"ActionLanguage": "MATLAB", "Decomposition": "EXCLUSIVE_OR"}},
 {"op": "configure", "target": "sf_20",
  "params": {"Props.Type.Method": "Built-in"}}]
```

- `sf_X` targets any SF element
- `chart:ModelName` targets chart-level properties from any scope depth
- Dot-notation (`Props.Type.Method`) for nested properties
- `Decomposition` is set on the parent state/chart, not children

## Gotchas

- Set `ActionLanguage` (`"MATLAB"` or `"C"`) before adding labeled elements — changing later may break existing label syntax
- Data `Scope`: `Input`/`Output` only valid at chart level when creating Data objects. Inside states, use `Local`/`Parameter`/`Constant` (subcharts still access parent chart data)
- For `StateflowFunction`/`EMFunction`/`TruthTable`, `Name` is derived from `LabelString` — set `LabelString`, not `Name`
- Prefer subcharts (`IsSubchart = true` via configure) over plain superstates when a state has 3+ substates
- No cross-subchart transitions via `model_edit` — see "Super Transitions"
- `replace_block` not supported in SF scope — use `delete` + `add_block`, or `configure` to change junction `Type` (e.g., `"HISTORY"`)
