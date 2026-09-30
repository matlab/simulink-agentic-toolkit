# Getting Metrics Out

Pick the accessor during discovery (Workflow step 2) so the `postSimFcn` is authored correctly the first time.

**Logged signal** — access by name from the model's `SignalLoggingName` variable (not always `logsout`):

```matlab
sig = simOut.logsout.getElement('signalName');   % or simOut.<SignalLoggingName>
peak = max(sig.Values.Data);
```

**Root Outport (`yout`)** — elements are usually name-less; select by `BlockPath`, never by name:

```matlab
in = in.setModelParameter('SaveOutput', 'on');    % only if currently off
in = in.setModelParameter('SaveFormat', 'Dataset');
ds  = simOut.yout;
idx = find(arrayfun(@(k) strcmp(ds{k}.BlockPath.getBlock(1), 'MyModel/Nz Pilot (g)'), 1:ds.numElements), 1);
peak = max(ds{idx}.Values.Data);                  % or ds{2} by position
```

**Signal marked loggable but logging is off** — turn it on non-destructively with a `DataLoggingOverride`; no model edit:

```matlab
si = Simulink.SimulationData.SignalLoggingInfo('MyModel/Block', portNum);
si.LoggingInfo.DataLogging = true;
mli = Simulink.SimulationData.ModelLoggingInfo('MyModel');
mli.Signals(1) = si;
mli = verifySignalAndModelPaths(mli);             % ERRORS if the signal isn't loggable in the model
in  = in.setModelParameter('DataLoggingOverride', mli);
```

`DataLoggingOverride` only selects among signals the model was authored to log. If `verifySignalAndModelPaths` errors, the signal is not in the loggable set — logging it requires a model change (enable "Log signal data" or add an Outport): surface it as a consent-required plan point, do not edit silently.

----

Copyright 2026 The MathWorks, Inc.

----
