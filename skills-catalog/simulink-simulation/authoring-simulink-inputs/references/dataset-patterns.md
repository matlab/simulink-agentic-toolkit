# Dataset Patterns

Advanced patterns for creating multiple datasets, handling bus signal inports, and populating function-call inports.

## Creating Multiple Datasets

Call `createInputDataset` once, then reuse the scaffold. Wrap in a function so only the output cell array lands in the workspace:

```matlab
function datasets = createThrottleSweep(mdl, stopTime, throttleValues)
    ds = createInputDataset(mdl);
    dt = 0.01;
    t = (0:dt:stopTime)';
    numScenarios = numel(throttleValues);
    datasets = cell(1, numScenarios);

    for scenario = 1:numScenarios
        dsCopy = ds;
        % populate dsCopy with scenario-specific signals
        % ...
        datasets{scenario} = dsCopy;
    end
end
```

## Bus Signal Inports

When an inport receives a bus signal, `createInputDataset` returns a **struct** with timeseries fields matching the bus definition. Detect with `isstruct(ds{k})`, then populate each field:

```matlab
origEl = ds{k};  % struct from scaffold
fields = fieldnames(origEl);

for f = 1:numel(fields)
    subEl = origEl.(fields{f});
    signalWidth = size(subEl.Data, 2);
    signalData = generateWaveform(t, ...);  % produce [N x signalWidth]
    signalData = cast(signalData, 'like', subEl.Data);

    ts = timeseries(signalData, t, 'Name', fields{f});
    ts.DataInfo.Interpolation = subEl.DataInfo.Interpolation;
    ts.DataInfo.Units = subEl.DataInfo.Units;
    origEl.(fields{f}) = ts;
end
ds{k} = origEl;
```

## Function-Call Inports

When an inport has `OutputFunctionCall = 'on'`, the scaffold returns a bare scalar `0` (not a timeseries). The data format is a **column vector of call times** — each value is a simulation time at which the function-call subsystem fires.

### Detection

From the scaffold (preferred — no additional model queries needed):

```matlab
if isnumeric(ds{k}) && isscalar(ds{k})
    % Function-call port — replace with call time vector
end
```

### Timing rules

| Rule | Detail |
|------|--------|
| Shape | Column vector (`Nx1`). Row vectors fail |
| Values | Non-negative, monotonically non-decreasing |
| Fixed-step alignment | Times must be integer multiples of the solver's fixed step size |
| Repeated values | Allowed — triggers multiple calls at the same time step |
| Empty vector | `zeros(0,1)` — no calls during simulation (valid) |

### Population pattern

Get the model's stop time, solver type, and fixed step size (if applicable) from the model parameters. Then generate call times accordingly:

- **Variable-step solver:** call times can be any non-negative values (e.g., `[0; 1; 2.5; 4.7; 8]`)
- **Fixed-step solver:** call times must be integer multiples of the fixed step size (e.g., `(0:2*fixedStep:stopTime)'` for every 2 steps)

```matlab
ds{k} = callTimes;
```

----

Copyright 2026 The MathWorks, Inc.

----
