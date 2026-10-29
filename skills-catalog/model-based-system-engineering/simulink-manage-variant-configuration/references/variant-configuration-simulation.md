# Variant Configuration Simulation

The workflows mentioned in this file in context of variant configurations are only valid for MATLAB versions R2024a and beyond. 

> **Before you start:** the data dictionary should not have unsaved edits. These workflows end with `Simulink.data.dictionary.closeAll('-discard')`, which throws them away, including changes to the VCS. If `HasUnsavedChanges` is true, follow the save-before-discard Hard Rule in SKILL.md first.

## Context: Why Simulink.SimulationInput Exists

A Simulink model on disk represents the **canonical design**. `Simulink.SimulationInput` creates a **temporary experiment layer** on top of it — you can change parameters, variables, inputs, variant configurations, initial states, and simulation settings without touching the model itself. When the simulation ends, the model is unchanged.

This is critical for variant models because:
- A 150% model contains many designs. You want to simulate specific configurations without permanently activating them.
- You want to sweep across multiple configurations in parallel without serializing model state changes.
- You want to combine a variant configuration with parameter overrides (e.g., test a config under different noise levels or stop times) — all non-intrusively.

---

## Routing

This reference owns the variant-specific parts of simulation: building `SimulationInput` objects with `setVariantConfiguration`, sweeping configurations, and restoring `pwd` after `parsim`. Compose on top of the neighboring skills rather than duplicating them:

- `simulating-simulink-models` — foundational `SimulationInput` usage: creating inputs, `setModelParameter`, `setBlockParameter`, `setVariable`, `setExternalInput`, accessing `logsout`, and fast restart.
- `simulink-run-parallel-simulations` — parallel execution mechanics for `parsim` and `batchsim`: pool sizing, worker data provisioning, `preSimFcn` / `postSimFcn`, and `DesignStudy`.

---

## Variant Simulation Workflows

### Single configuration

```matlab
in = Simulink.SimulationInput(modelName);
in = setVariantConfiguration(in, 'NonLinExterHighFid');
out = sim(in);
```

### Multiple configurations in parallel

```matlab
configNames = {'LinInterStd', 'NonLinExterHighFid', 'SmartAIExterHighFid'};
N = numel(configNames);

in(1:N) = Simulink.SimulationInput(modelName);
in = setVariantConfiguration(in, configNames);

savedDir = pwd;
out = parsim(in, ShowProgress="on");
cd(savedDir);
Simulink.data.dictionary.closeAll('-discard');
```

`setVariantConfiguration` accepts an array of `SimulationInput` objects and a cell array of names — mapped element-wise.

### Configurations × parameters (cross-product sweep)

Combine variant sweep with parameter overrides. Use `UserString` to tag each simulation.

```matlab
configNames = {'LinInterStd', 'NonLinExterHighFid'};
stopTimes = {'5', '10', '20'};

k = 0;
for i = 1:numel(configNames)
    for j = 1:numel(stopTimes)
        k = k + 1;
        in(k) = Simulink.SimulationInput(modelName);
        in(k) = setVariantConfiguration(in(k), configNames{i});
        in(k) = in(k).setModelParameter('StopTime', stopTimes{j});
        in(k).UserString = sprintf('%s @ StopTime=%s', configNames{i}, stopTimes{j});
    end
end

savedDir = pwd;
out = parsim(in, ShowProgress="on");
cd(savedDir);
Simulink.data.dictionary.closeAll('-discard');
```

---

## API Reference

### `setVariantConfiguration`

Assigns a named variant configuration to the simulation input.

```matlab
in = setVariantConfiguration(in, configName)
in = setVariantConfiguration(inArray, configNamesCell)
```

| Argument | Type | Description |
|----------|------|-------------|
| `in` | `SimulationInput` or array | Target simulation input(s) |
| `configName` | char, string, or cell array | Configuration name(s) from the model's attached VCS |

**Introduced:** R2024a

### `getVariantConfiguration`

Retrieves the variant configuration name set on the simulation input.

```matlab
name = getVariantConfiguration(in)
names = getVariantConfiguration(inArray)
```

Returns char (single) or cell array of char (array input). **Introduced:** R2024a

### `validate`

Pre-flight check — validates the SimulationInput specification before running. Catches undefined variables, invalid parameter values, or incompatible settings early.

```matlab
validate(in)
```

Throws an error if validation fails. **Introduced:** R2017a

### `showContents`

Displays a human-readable summary of everything configured on the SimulationInput.

```matlab
showContents(in)
```

**Introduced:** R2020a

### `setPreSimFcn` / `setPostSimFcn`

Hooks that run before/after each simulation. Useful for per-configuration logging or post-processing.

```matlab
in = setPreSimFcn(in, @(in) fprintf('Starting: %s\n', getVariantConfiguration(in)))
in = setPostSimFcn(in, @(out) saveResults(out))
```

`setPreSimFcn` receives `SimulationInput`; `setPostSimFcn` receives `SimulationOutput`. **Introduced:** R2017a

### `setInitialState`

Specify an initial operating point. Use when studying how a variant configuration behaves from a non-default initial condition.

```matlab
in = setInitialState(in, operatingPoint)
```

Accepts `Simulink.op.ModelOperatingPoint`, `Dataset`, or struct. **Introduced:** R2017a

### `loadVariablesFromMATFile`

Load workspace variables from a MAT file into the simulation input. Useful when configurations are paired with pre-saved parameter sets.

```matlab
in = loadVariablesFromMATFile(in, 'params_config1.mat')
in = loadVariablesFromMATFile(in, 'extra_params.mat', 'Append', 'on')
```

**Introduced:** R2017a

### `applyToModel`

**Destructive** — pushes all SimulationInput settings to the actual model. The non-intrusive property is lost. Use only when you intentionally want to persist changes.

```matlab
applyToModel(in)
```

**Introduced:** R2017a

### `UserString` Property

Free-form string tag. Survives into `SimulationOutput.SimulationMetadata.UserString`. Use to label simulations in batch runs.

```matlab
in.UserString = 'NonLinExterHighFid - baseline';
```

---

## Execution

### `sim` — Single or Sequential

**Never use `sim` as a variable name.** A base workspace variable named `sim` shadows the built-in `sim()` function, causing cryptic errors like "Unable to use a value of type Simulink.SimulationInput as an index." Always use `out` (or a descriptive name like `simOut`) for simulation results.

```matlab
out = sim(in);                           % single
out = sim(inArray);                      % sequential array
out = sim(inArray, UseFastRestart="on"); % compile once, run many
```

| Name-Value | Default | Description |
|------------|---------|-------------|
| `UseFastRestart` | `"off"` | Compile once, run many |
| `StopOnError` | `"off"` | Stop remaining sims on first error |
| `ShowProgress` | `"off"` | Display progress |
| `ShowSimulationManager` | `"off"` | Open Simulation Manager UI |

### `parsim` — Parallel

**`parsim` changes MATLAB's current working directory.** After `parsim` returns, `pwd` may point to a temp/worker directory instead of the model directory. This breaks any subsequent operation that resolves files relative to the model (e.g., opening a data dictionary, reloading the Variant Manager UI). Always save and restore `pwd` around `parsim` calls:

```matlab
savedDir = pwd;
out = parsim(inArray, ShowProgress="on");
cd(savedDir);
```

After restoring `pwd`, close stale dictionary handles left by parallel workers to avoid shadowing warnings:

```matlab
Simulink.data.dictionary.closeAll('-discard');
```

| Name-Value | Default | Description |
|------------|---------|-------------|
| `ShowProgress` | `"on"` | Display progress |
| `UseFastRestart` | `"off"` | Fast restart on each worker |
| `RunInBackground` | `"off"` | Non-blocking execution |
| `TransferBaseWorkspaceVariables` | `"off"` | Send base workspace to workers |
| `SetupFcn` | — | Run once per worker before sims |
| `CleanupFcn` | — | Run once per worker after sims |
| `StopOnError` | `"off"` | Stop on first error |
| `ManageDependencies` | `"on"` | Auto-manage model dependencies |
| `ShowSimulationManager` | `"off"` | Open Simulation Manager UI |

### `batchsim` — Cluster/Cloud

Offloads to a compute cluster. Same `SimulationInput` array, different execution target.

```matlab
job = batchsim(inArray);
wait(job);
out = fetchOutputs(job);
```

Returns `Simulink.Simulation.Job`. Key options: `Pool`, `SetupFcn`, `CleanupFcn`, `TransferBaseWorkspaceVariables`, `ManageDependencies`, `StopOnError`.

---

## Results: SimulationOutput

### Checking for errors and identifying results

```matlab
for i = 1:numel(out)
    if ~isempty(out(i).ErrorMessage)
        fprintf('FAILED [%d]: %s\n', i, out(i).ErrorMessage);
    else
        fprintf('OK [%d]: %s\n', i, out(i).SimulationMetadata.UserString);
    end
end
```

### SimulationMetadata properties

| Property | Contains |
|----------|----------|
| `ModelInfo` | Model name, version, environment |
| `ExecutionInfo` | Stop event, diagnostics |
| `TimingInfo` | Compilation time, execution time |
| `UserString` | From `SimulationInput.UserString` |
| `UserData` | Custom data via `setUserData` |

---

## Variant-Specific Patterns

### Simulate all configurations in a VCS

```matlab
vcs = Simulink.VariantManager.getVariantConfigurations(modelName);
configNames = {vcs.Configurations.Name};

in(1:numel(configNames)) = Simulink.SimulationInput(modelName);
in = setVariantConfiguration(in, configNames);
for i = 1:numel(in), in(i).UserString = configNames{i}; end

savedDir = pwd;
out = parsim(in, ShowProgress="on");
cd(savedDir);
Simulink.data.dictionary.closeAll('-discard');
```

### Simulate a subset (filter by control variable value)

```matlab
vcs = Simulink.VariantManager.getVariantConfigurations(modelName);
configs = vcs.Configurations;

highFidNames = {};
for i = 1:numel(configs)
    cvs = configs(i).ControlVariables;
    for j = 1:numel(cvs)
        if strcmp(cvs(j).Name, 'FidType')
            rawVal = cvs(j).Value;
            while isa(rawVal, 'Simulink.VariantControl') || isa(rawVal, 'Simulink.Parameter')
                rawVal = rawVal.Value;
            end
            if rawVal == Fidelity.High
                highFidNames{end+1} = configs(i).Name;
            end
        end
    end
end

in(1:numel(highFidNames)) = Simulink.SimulationInput(modelName);
in = setVariantConfiguration(in, highFidNames);

savedDir = pwd;
out = parsim(in, ShowProgress="on");
cd(savedDir);
Simulink.data.dictionary.closeAll('-discard');
```

### Compare results across configurations

```matlab
figure; hold on;
for i = 1:numel(out)
    if isempty(out(i).ErrorMessage)
        sig = out(i).logsout.get('outputSignal').Values;
        plot(sig.Time, sig.Data, 'DisplayName', out(i).SimulationMetadata.UserString);
    end
end
legend; hold off;
```

---

## Signal Logging Override (Non-Intrusive)

Override which signals are logged without modifying the model, via `DataLoggingOverride` model parameter:

```matlab
mdlInfo = Simulink.SimulationData.ModelLoggingInfo(modelName);
mdlInfo.LoggingMode = 'OverrideSignals';

sigInfo = Simulink.SimulationData.SignalLoggingInfo('Model/Block', 1);
sigInfo.LoggingInfo.DataLogging = true;
sigInfo.LoggingInfo.LoggingName = 'MySignal';
mdlInfo.Signals = sigInfo;

in = Simulink.SimulationInput(modelName);
in = setVariantConfiguration(in, 'ConfigName');
in = in.setModelParameter('DataLoggingOverride', mdlInfo);
out = sim(in);
```

`SignalLoggingInfo` takes a block path and output port index (1-based). Add multiple signals by building a vector of `SignalLoggingInfo` objects.

---

## Discovery: Beyond This Reference

This reference covers variant-specific simulation workflows. The `Simulink.SimulationInput` and `Simulink.SimulationOutput` classes have additional capabilities. When the user needs something not documented here:

```matlab
% List all methods on an object
methods(Simulink.SimulationInput)
methods(Simulink.SimulationOutput)

% Get help on a specific method — pattern: help ClassName.methodName
help Simulink.SimulationInput.<methodName>
help Simulink.SimulationOutput.<methodName>

% Explore execution functions
help sim
help parsim
help batchsim
```

Use `help` to confirm exact syntax before using any method not documented in this reference.

----

Copyright 2026 The MathWorks, Inc.

----
