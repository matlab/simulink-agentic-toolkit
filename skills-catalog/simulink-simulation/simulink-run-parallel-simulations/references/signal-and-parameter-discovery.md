# Discovering Model Structure

Read-only inspection to resolve signal names and parameter type before writing any sweep code. No simulations.

## Discovering Logged Signal Names

Find signal names without simulating using `ModelLoggingInfo` (ensure the model is loaded first):

```matlab
logInfo = Simulink.SimulationData.ModelLoggingInfo.createFromModel('MyModel');
for i = 1:numel(logInfo.Signals)
    sig = logInfo.Signals(i);
    ph = get_param(sig.BlockPath.getBlock(1), 'PortHandles');
    lh = get_param(ph.Outport(sig.OutputPortIndex), 'Line');
    lineName = get_param(lh, 'Name');
    % The Dataset element name that getElement keys on is the custom logging
    % name when one is set (NameMode==1), otherwise the line name. Resolve it
    % here — do not pass the line name to getElement blindly.
    if sig.LoggingInfo.NameMode == 1 && ~isempty(sig.LoggingInfo.LoggingName)
        elementName = sig.LoggingInfo.LoggingName;
    else
        elementName = lineName;
    end
    fprintf('  %d: elementName="%s" (line="%s"), Block="%s", Port=%d\n', ...
        i, elementName, lineName, sig.BlockPath.getBlock(1), sig.OutputPortIndex);
end
```

Alternative: use `model_read` + `model_query_params` with `DataLogging` on specific connections.

Only reference confirmed signal names in `postSimFcn` — never guess. Use the resolved `elementName` (the custom logging name when `NameMode==1`, else the line name) with `getElement` — a signal logged under a custom name will not match its line name. When the resolved name is empty, access it by `BlockPath` and `OutputPortIndex` instead.

## Discovering Parameter Type

Check in this order — stop once you identify where the parameter lives; do not look up which blocks consume it.

```matlab
% 1. Base workspace
exist('Mu', 'var')

% 2. Model workspace
mdlWks = get_param('MyModel', 'ModelWorkspace');
mdlWks.hasVariable('Mu')

% 3. Data dictionary
ddName = get_param('MyModel', 'DataDictionary');
if ~isempty(ddName)
    dd = Simulink.data.dictionary.open(ddName);
    dDataSectObj = getSection(dd, 'Design Data');
    entryObj = find(dDataSectObj, 'Name', 'Mu');
end
```

- Base workspace → `setVariable('Mu', value)`
- Model workspace → `setVariable('Mu', value, 'Workspace', 'MyModel')`
- Data dictionary → `setVariable('Mu', value, 'Workspace', 'MyModel')`
- Block parameter → `setBlockParameter('MyModel/Block', 'Param', value)`

If ambiguous (e.g., variable AND block with same name), ask the user.

----

Copyright 2026 The MathWorks, Inc.

----
