# Calling Convention Examples

Worked calls for every targeting and mode combination. Loaded on demand from SKILL.md; the rules behind each call (signature, `incMap` keys, editability) are in SKILL.md's Workflow.

Every example assumes `lsm = layout.LayoutStateManager.instance();` has run.

## Full layout — all subviewers (simplest)

```matlab
lsm = layout.LayoutStateManager.instance();
applySFAutolayout('myModel', lsm);
```

## Full layout — single subviewer

```matlab
chartSID = string(Simulink.ID.getSID(chart));
applySFAutolayout('myModel', lsm, dictionary, chartSID);
```

## Incremental layout — new objects only

```matlab
% Get SIDs
chartSID = Simulink.ID.getSID(chart);
newState1SID = Simulink.ID.getSID(newState1);
newState2SID = Simulink.ID.getSID(newState2);

% Build incMap: chart gets incremental, new objects listed
incMap = dictionary;
incMap(chartSID) = {{newState1SID, newState2SID}};

% Apply — newState1 and newState2 are positioned; existing elements may shift slightly
applySFAutolayout('myModel', lsm, incMap);
```

## Mixed mode — several charts in one call

`incMap` is a dictionary rather than a plain object list precisely so one call can treat different charts differently. Charts you key get incremental layout; charts you leave out get a full layout.

```matlab
incMap = dictionary;
incMap(chartASID) = {{newState1SID, newState2SID}};   % chart A: incremental
incMap(chartBSID) = {{newJunctionSID}};               % chart B: incremental

% chart C is not a key, so it gets a full layout
applySFAutolayout('myModel', lsm, incMap);
```

Omit `viewerSID` for this — it narrows the call to one subviewer, which defeats the purpose. This is the form to use when an edit round touched some charts and left others untouched but messy.

## Incremental layout — single subviewer

Key by the parent chart; target the subchart with `viewerSID`.

```matlab
chartSID    = string(Simulink.ID.getSID(subchartState.Chart));   % key
subchartSID = string(Simulink.ID.getSID(subchartState));         % target
newObjSID   = Simulink.ID.getSID(newObj);

incMap = dictionary;
incMap(chartSID) = {{newObjSID}};
applySFAutolayout('myModel', lsm, incMap, subchartSID);
```

## Layout an AtomicSubchart or AtomicBox

Pass the object's own SID. The function resolves the backend chart internally.

```matlab
% AtomicSubchart
asSID = string(Simulink.ID.getSID(atomicSubchart));
applySFAutolayout('myModel', lsm, dictionary, asSID);

% AtomicBox (same pattern)
abSID = string(Simulink.ID.getSID(atomicBox));
applySFAutolayout('myModel', lsm, dictionary, abSID);
```

For incremental layout of an AtomicSubchart or AtomicBox, key the incMap by the **backend chart**, not the object:

```matlab
backendSID = string(Simulink.ID.getSID(atomicSubchart.Subchart));  % key
asSID      = string(Simulink.ID.getSID(atomicSubchart));           % target

incMap = dictionary;
incMap(backendSID) = {{Simulink.ID.getSID(newObj)}};
applySFAutolayout('myModel', lsm, incMap, asSID);
```

AtomicSubchart and AtomicBox therefore use three different handles for three different jobs:

| Job | Handle |
|-----|--------|
| `viewerSID` (argument 4) | the object's own SID |
| `incMap` key | the backend chart — `.Subchart` |
| Editability check (Step 4) | the backend chart — `.Subchart.Locked` / `.Subchart.Iced` |

----

Copyright 2026 The MathWorks, Inc.

----
