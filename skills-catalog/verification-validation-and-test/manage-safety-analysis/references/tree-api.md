# Safety Analysis Manager — Tree API Reference (R2026b+)

> **Version enforcement:** ALL APIs in this file require R2026b or newer. Do NOT use any tree API unless the user's MATLAB release is confirmed to be R2026b+. If the user's release is unknown or earlier than R2026b, do NOT generate code that calls these APIs.

Programmatic reference for tree-based analysis documents in Safety Analysis Manager: Fault Tree Analysis (FTA) and Attack Trees. The same `FaultTreeDocument` API is used for both workflows — the difference is in how gates and events are interpreted (failure modes vs. threat scenarios). For shared APIs (save, callbacks, flags, links, change detection), see `common-api.md`.

## Creating Fault Tree Documents

```matlab
doc = safetyAnalysisMgr.newDocument("fault-tree")                % Create new blank fault tree document
doc = safetyAnalysisMgr.newDocument(templateFile)                % Create from .mldatx template
doc = safetyAnalysisMgr.newDocument(group, templateName)         % Create from registered template
```

A new fault tree document is created with one default fault tree containing a single top-level OR gate.

## FaultTreeDocument Class (`safetyAnalysisMgr.FaultTreeDocument`)

### Properties

| Property | Access | Description |
|---|---|---|
| `FaultTrees` | Read-only | Array of `FaultTree` objects in the document |
| `Events` | Read-only | Array of all `Event` objects in the document |
| `FailureModels` | Read-only | Array of all `FailureModel` objects in the document |
| `Gates` | Read-only | Array of all `Gate` objects in the document |
| `EvalConfig` | Read-only | `EvalConfig` object controlling evaluation settings (modify properties on the object, not the property itself) |
| `FileName` | Read-only | File path (empty until first save) |
| `Description` | Read/Write | Document description |

### Methods

```matlab
ft = createFaultTree(doc)                                        % Create new fault tree (top-level OR gate by default)
ft = createFaultTree(doc, Type="and", Label="Top Event")         % Create with specified gate type and label
deleteFaultTree(doc, topGateLabel)                               % Delete fault tree by top gate label

event = createEvent(doc)                                         % Create event (unattached — must addEvent to a gate)
event = createEvent(doc, Type="basic", Label="Pump Fail")        % Create event with name-value args
deleteEvent(doc, label)                                          % Delete event by label

fm = createFailureModel(doc)                                     % Create failure model (constant by default)
fm = createFailureModel(doc, Type="rate", Label="PumpRate")      % Create with type and label
% createFailureModel Type choices: "constant" | "rate" | "mttf" | "dormant" | "time-at-risk"
% "logical" is not a valid choice — logical models are created automatically for house events
deleteFailureModel(doc, label)                                   % Delete failure model by label

event = getEvent(doc, label)                                     % Retrieve event by label
gate = getGate(doc, label)                                       % Retrieve gate by label
fm = getFailureModel(doc, label)                                 % Retrieve failure model by label

convertGateToTree(doc, gate)                                     % Convert a gate into its own fault tree
deleteSubtree(doc, gateLabel)                                    % Delete subtree rooted at gate

evaluate(doc)                                                    % Evaluate all fault trees (computes failure properties and cut sets)

exportToPDF(doc)                                                 % Export all fault trees to PDF (one page per tree, uses document name)
exportToPDF(doc, filePath)                                       % Export to specified PDF file path
```

## FaultTree Class (`safetyAnalysisMgr.FaultTree`)

### Properties

| Property | Access | Description |
|---|---|---|
| `Gates` | Read-only | Array of `Gate` objects in this tree (first element is the top-level gate) |
| `TransferGates` | Read-only | Array of `TransferGate` objects in this tree |

### Methods

```matlab
deleteSubtree(ft, gateLabel)                                     % Delete subtree rooted at gate
deleteTransferGate(ft, transferGate)                              % Delete transfer gate from tree
exportToPDF(ft)                                                  % Export this fault tree to PDF (uses top gate label as name)
exportToPDF(ft, filePath)                                        % Export to specified PDF file path
```

## Gate Class (`safetyAnalysisMgr.Gate`)

### Properties

| Property | Access | Description |
|---|---|---|
| `Type` | Read/Write | `"or"` \| `"and"` \| `"not"` \| `"xor"` \| `"voting"` |
| `Label` | Read/Write | Unique gate identifier (default: `"GATE"`, auto-increments) |
| `Description` | Read/Write | Gate description |
| `ComputeProperties` | Read/Write | `logical` — enable/disable failure property calculation for this gate |
| `Inputs` | Read-only | Heterogeneous array of `Event`, `Gate`, and `TransferGate` objects |
| `CutSets` | Read-only | Array of `CutSet` objects (populated after `evaluate`) |
| `FailureProperties` | Read-only | `FailureProperties` object (populated after `evaluate`) |
| `ImportanceMeasures` | Read-only | Array of `ImportanceMeasures` objects (populated after `evaluate`) |
| `IncomingTransfer` | Read-only | Array of `TransferGate` objects referencing this gate |

### Methods

```matlab
childGate = createGate(gate)                                     % Add child OR gate (default)
childGate = createGate(gate, Type="and", Label="Redundancy Lost") % Add child gate with type/label

event = createEvent(gate)                                        % Create and attach event directly to gate
event = createEvent(gate, Type="basic", Label="Sensor Fail")     % Create event with name-value args

addEvent(gate, event)                                            % Attach existing event to gate

transferGate = createTransferGate(gate)                          % Add transfer gate as input

deleteInput(gate, input)                                         % Remove an input (event, gate, or transfer gate). Gates are deleted from the document. Events are deleted only if not shared with other gates.

linksStruct = getLinks(gate)                                     % Get requirement links
flag = addFlag(gate, type, Description=..., Tag=...)             % Add flag
flags = getFlags(gate)                                           % Get flags
clearFlags(gate)                                                 % Clear flags
changes = getChanges(gate)                                       % Get detected changes
acceptAllChanges(gate)                                           % Accept changes
```

### Gate Types

| Type | Logic | Description |
|---|---|---|
| `"or"` | Union | Any child causes parent — single-point failures |
| `"and"` | Intersection | All children must occur — redundant system failure |
| `"not"` | Negation | Inverts single input probability |
| `"xor"` | Exclusive OR | Exactly one of two inputs occurs |
| `"voting"` | k-out-of-n | Specified number of inputs must occur |

## Event Class (`safetyAnalysisMgr.Event`)

### Properties

| Property | Access | Description |
|---|---|---|
| `Type` | Read/Write | `"basic"` \| `"undeveloped"` \| `"house"` |
| `Label` | Read/Write | Unique event identifier (default: `"EVENT"`, auto-increments) |
| `Description` | Read/Write | Event description |
| `FailureModel` | Read/Write | Associated `FailureModel` object |
| `FailureProperties` | Read-only | `FailureProperties` object (populated after `evaluate`) |

### Event Types

| Type | Description |
|---|---|
| `"basic"` | Standard failure event — a fundamental component failure |
| `"undeveloped"` | Placeholder for future analysis — not yet decomposed |
| `"house"` | Normally expected event (TRUE/FALSE operating condition) |

### Methods

```matlab
navigate(event)                                                  % Highlight in GUI
linksStruct = getLinks(event)                                    % Get requirement links
flag = addFlag(event, type, Description=..., Tag=...)            % Add flag
flags = getFlags(event)                                          % Get flags
clearFlags(event)                                                % Clear flags
changes = getChanges(event)                                      % Get detected changes
acceptAllChanges(event)                                          % Accept changes
```

## FailureModel Class (`safetyAnalysisMgr.FailureModel`)

### Properties

| Property | Access | Description |
|---|---|---|
| `Type` | Read/Write | `"constant"` \| `"rate"` \| `"time-at-risk"` \| `"mttf"` \| `"dormant"` \| `"logical"` |
| `Label` | Read/Write | Unique identifier (default: `"MODEL"`) |
| `Description` | Read/Write | Model description |
| `Shared` | Read/Write | `logical` — true if assigned to multiple events |
| `Parameters` | Read-only | `FailureModelParameters` object — configure via this |
| `DependentEvents` | Read-only | Array of `Event` objects using this failure model |

### Methods

```matlab
linksStruct = getLinks(fm)                                       % Get requirement links
flag = addFlag(fm, type, Description=..., Tag=...)               % Add flag
flags = getFlags(fm)                                             % Get flags
clearFlags(fm)                                                   % Clear flags
changes = getChanges(fm)                                         % Get detected changes
acceptAllChanges(fm)                                             % Accept changes
```

### Failure Model Types

| Type | Behavior | Use Case |
|---|---|---|
| `"constant"` | Fixed probability (Q) and frequency (W), independent of time | Simple known probabilities |
| `"rate"` | Exponential probability with constant failure rate, repairable | Components with known failure rate |
| `"time-at-risk"` | Exponential probability with specified exposure time | Intermittent operation |
| `"mttf"` | Calculated from mean time to failure/repair | Field data with MTTF/MTTR |
| `"dormant"` | Undetected failure revealed at fixed test intervals | Hidden failures with periodic inspection |
| `"logical"` | Binary active/inactive, no rate or frequency. Automatically created for house events — not available via `createFailureModel`. | Operating conditions, switches |

### Configuring Parameters

```matlab
fm = createFailureModel(doc, Type="rate");
params = fm.Parameters;
params.Lambda.Value = 0.02;          % set failure rate parameter
```

## TransferGate Class (`safetyAnalysisMgr.TransferGate`)

### Properties

| Property | Access | Description |
|---|---|---|
| `Gate` | Read/Write | The `Gate` object this transfer gate references |

Transfer gates enable reuse of fault tree structures by referencing existing gates within the same or different fault trees. Cannot create circular references.

## EvalConfig Class (`safetyAnalysisMgr.EvalConfig`)

Controls evaluation settings for `evaluate(doc)`.

### Properties

| Property | Access | Default | Description |
|---|---|---|---|
| `Type` | Read/Write | `"exact"` | Evaluation algorithm: `"exact"` or `"rare"` |
| `MissionTime` | Read/Write | `0` | Mission duration for evaluation |
| `TimeUnit` | Read/Write | `"hours"` | `"minutes"` \| `"hours"` \| `"million-hours"` \| `"billion-hours"` |
| `OrderCutoff` | Read/Write | `0` | Max cut set order (0 = no limit) |
| `ProbabilityCutOff` | Read/Write | `0` | Min cut set probability threshold (used with `"rare"` type). Not available when `QualitativeOnly` is true. |
| `QualitativeOnly` | Read/Write | `false` | If true, skip Q and W computation (cut sets only) |
| `FaultTrees` | Read/Write | all trees | Subset of fault trees to evaluate |

## FailureProperties Class (`safetyAnalysisMgr.FailureProperties`)

Read-only results populated after `evaluate(doc)`. Accessible on `Gate` and `Event` objects.

| Property | Type | Description |
|---|---|---|
| `Q` | double (0–1) | Failure probability |
| `W` | double | Failure frequency |
| `CFI` | double | Conditional failure intensity: W / (1 - Q) |
| `Active` | logical or string | Whether the event is active (logical if evaluated, string if expression) |

## CutSet Class (`safetyAnalysisMgr.CutSet`)

Read-only results accessible via `gate.CutSets` after `evaluate(doc)`.

| Property | Type | Description |
|---|---|---|
| `Elements` | heterogeneous array | `Event` and `Gate` objects contributing to this cut set |
| `States` | logical array | Whether each element must be active (1) or inactive (0) |
| `Q` | double (0–1) | Cut set probability |
| `W` | double | Cut set frequency |

## ImportanceMeasures Class (`safetyAnalysisMgr.ImportanceMeasures`)

Read-only results accessible via `gate.ImportanceMeasures` after `evaluate(doc)`.

| Property | Type | Description |
|---|---|---|
| `Element` | `Event` | The event being measured |
| `Birnbaum` | double | System sensitivity to event's failure probability |
| `FussellVesely` | double | Likelihood event contributes to gate's cut sets |
| `Criticality` | double | Significance of event to overall system failure |

## Example: Building and Evaluating a Fault Tree

```matlab
% Create document (starts with one tree and one top-level OR gate)
doc = safetyAnalysisMgr.newDocument("fault-tree");
topGate = doc.FaultTrees(1).Gates(1);
topGate.Label = "Loss of Hydraulic Power";
topGate.Type = "or";

% Add intermediate AND gate for dual pump failure
dualPumpGate = createGate(topGate, Type="and", Label="Dual Pump Failure");
e1 = createEvent(dualPumpGate, Type="basic", Label="Primary Pump Failure");
e2 = createEvent(dualPumpGate, Type="basic", Label="Backup Pump Failure");

% Add basic event for line rupture directly under top gate
e3 = createEvent(topGate, Type="basic", Label="Hydraulic Line Rupture");

% Create and assign failure models
fm1 = createFailureModel(doc, Type="rate", Label="PumpRate");
fm1.Parameters.Lambda.Value = 1e-4;
e1.FailureModel = fm1;
e2.FailureModel = fm1;   % shared model

fm2 = createFailureModel(doc, Type="constant", Label="LineRupture");
fm2.Parameters.Q.Value = 1e-6;
fm2.Parameters.W.Value = 1e-7;
e3.FailureModel = fm2;

% Configure evaluation
doc.EvalConfig.MissionTime = 10;
doc.EvalConfig.TimeUnit = "hours";

% Evaluate
evaluate(doc);

% Inspect results
topGate.FailureProperties.Q     % top-event probability
topGate.CutSets                 % minimal cut sets
topGate.ImportanceMeasures      % importance measures per event

% Save
save(doc, "HydraulicPower_FTA.mldatx");
```

## Guardrails

- Use ASCII characters only in gate/event/failure model labels and descriptions
- Set failure models and their parameters on all basic events before calling `evaluate`
- Do not fabricate failure rates or probabilities — use placeholder values and flag them for engineering review
- Transfer gates cannot create circular references (logical loops)
- `evaluate` must be called on the `FaultTreeDocument`, not on individual `FaultTree` or `Gate` objects
- `deleteFailureModel` will error if the model is still assigned to any event — reassign or clear the event's `FailureModel` first
- `deleteInput(gate, input)` deletes gates from the document; events are deleted only if not shared with other gates
- `CutSet.Q` and `CutSet.W` are not available when `EvalConfig.QualitativeOnly` is true
- Ask the user before modifying failure model parameters in an existing tree

----

Copyright 2026 The MathWorks, Inc.

----
