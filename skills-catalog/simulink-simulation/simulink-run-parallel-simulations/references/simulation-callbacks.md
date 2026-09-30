# Pre/Post Simulation Functions and Live Visualization

`preSimFcn` runs before each sim and receives/returns a `SimulationInput` — use it to derive dependent parameters (e.g., `Kd = Kp * 0.1`). Set via `in = in.setPreSimFcn(@myPreSimFcn)`.

## postSimFcn — runs after each sim, receives (SimulationOutput, SimulationInput)

Always check `ErrorMessage` first. If the user agreed to reduce results (see plan point 4), return only the needed metrics. If the user wants full output, append metrics to the `SimulationOutput` and return it.

```matlab
in = in.setPostSimFcn(@(simOut, simIn) myPostSimFcn(simOut, simIn));

function out = myPostSimFcn(simOut, simIn)
    if ~isempty(simOut.ErrorMessage)
        out = simOut; return;
    end
    % Access the metric using the mechanism identified in discovery (see "Getting Metrics Out").
    % Logged-signal case shown here; use BlockPath for root Outports.
    sig = simOut.logsout.getElement('outputSignal');
    out.peakValue = max(sig.Values.Data);
    out.steadyState = sig.Values.Data(end);
    out.paramValue = simIn.getVariable('Kp');

    % Optional: write to ValueStore for live visualization, keyed by a unique string.
    store = getCurrentValueStore;
    if ~isempty(store)
        [~, key, ~] = fileparts(tempname);   % unique key per run
        store(key) = struct('Kp', out.paramValue, 'peak', out.peakValue);
    end
end
```

Note: When `postSimFcn` returns a struct, `parsim` still returns a `SimulationOutput` array with the struct fields added as properties (e.g., `out(k).peakValue` or `[out.peakValue]`).

For a `DesignStudy`, `simIn` is passed as well. Read each run's swept values with the accessor matching how it was swept: `simIn.getVariable(name)`, `simIn.getBlockParameter(block, param)`, or `simIn.getModelParameter(param)`.

## Callbacks

Write each `postSimFcn`/`preSimFcn` as a named function in its own standalone `.m` file. Keep callbacks few. Write the `.m` files with the Write tool to produce well-formed files, rather than string concatenation in `evaluate_matlab_code`. After editing a callback file, restart the pool (`delete(gcp('nocreate'))`) before re-running so the workers load the current version.

## Live Visualization

Use ValueStore + `KeyUpdatedFcn` for live plotting. Use a single pre-allocated line object — not `plot` per callback — to avoid N graphics objects and get a connected line automatically.

**Serial fallback (no pool):** Skip ValueStore. Instead, pass the graphic object handle into `postSimFcn` via an anonymous wrapper (`in.setPostSimFcn(@(simOut, simIn) myPostSimFcn(simOut, simIn, h))`) and update `h.XData`/`h.YData` directly — same pattern as the `updatePlot` callback below, but inside `postSimFcn`.

```matlab
% Set up figure and single line object before running parsim
fig = figure; ax = axes(fig);
xlabel(ax, 'Parameter Value'); ylabel(ax, 'Metric');
title(ax, 'Live Results');
hold(ax, 'on'); grid(ax, 'on');
h = plot(ax, NaN, NaN, 'b-o', 'MarkerSize', 4);
drawnow;  % Force figure to render immediately

% Register ValueStore callback
pool = gcp;
if ~isempty(pool)
    store = pool.ValueStore;
    store.KeyUpdatedFcn = @(store, key) updatePlot(store, key, h);
end

% Run simulations (postSimFcn writes to ValueStore)
out = parsim(in);

function updatePlot(store, key, h)
    data = store(key);
    h.XData(end+1) = data.Kp;
    h.YData(end+1) = data.peak;
    drawnow nocallbacks;
end
```

----

Copyright 2026 The MathWorks, Inc.

----
