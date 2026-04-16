---
name: simulating-simulink-models
description: Runs Simulink models programmatically for data exploration, parameter sweeps, and custom analysis using sim() with SimulationInput/SimulationOutput. Use when calling sim(), parsim, setExternalInput, setModelParameter, setVariable, or accessing logsout — any task producing simulation results for analysis (not pass/fail tests).
license: MathWorks BSD-3-Clause
metadata:
  version: "1.0"
---

# Simulating Simulink Models with the sim Command

Use this skill to generate simulation results for analysis. For persistent, reusable pass/fail behavioral testing (especially of individual subsystems), use `testing-simulink-models` instead.

## When to Use

- Running a Simulink model from a MATLAB script
- Configuring simulation parameters (StopTime, solver, etc.) programmatically
- Passing input signals to root-level Inport blocks
- Accessing logged signal data after simulation
- Running parameter sweeps or batch simulations

## When NOT to Use

- Writing declarative Gherkin-based tests → use `testing-simulink-models`
- Testing an individual subsystem or component → use `testing-simulink-models` (requires Simulink Test; auto-creates a harness, compiles only the subsystem — much faster than `sim()` which always compiles the entire model)

## Minimal working pattern

Always simulate using `Simulink.SimulationInput` and `Simulink.SimulationOutput`:

```matlab
in = Simulink.SimulationInput('MyModel');
in = in.setModelParameter('StopTime', '10');
out = sim(in);
```

## Setting parameters

Use `SimulationInput` methods to configure the simulation:

```matlab
% Model-level parameters (StopTime, SolverType, SimulationMode, etc.)
in = in.setModelParameter('StopTime', '10', 'SolverType', 'Fixed-step');

% Block parameters
in = in.setBlockParameter('MyModel/Gain', 'Gain', '5');

% MATLAB workspace variables used by the model
in = in.setVariable('Kp', 1.2);
```

## Input signals

Pass input signals through Inport blocks using a `Simulink.SimulationData.Dataset`. Elements are matched to Inport blocks **by index position** — the first element maps to the Inport with port number 1, the second to port number 2, and so on.

```matlab
dt = 0.01;
N = 1000;
t = dt*(0:N)';
u = sin(2*pi*t);

ts = timeseries(u, t);

ds = Simulink.SimulationData.Dataset;
ds{1} = ts;

in = in.setExternalInput(ds);
out = sim(in);
```

You can also use `timetable` as an input format:

```matlab
secs = seconds(t);
tt = timetable(secs, u);

ds = Simulink.SimulationData.Dataset;
ds{1} = tt;

in = in.setExternalInput(ds);
```

## Discovering logged data

First, discover what kinds of logged data the model produces using `who`, then inspect signal names within `logsout`:

```matlab
in = Simulink.SimulationInput('MyModel');
out = sim(in);

% See what logging properties exist (logsout, yout, tout, etc.)
who(out)

% List individual signal names within logsout
disp(out.logsout.getElementNames);
```

## Accessing logged data

Logged signals are available through `out.logsout`. Access them directly by name:

```matlab
% Plot a logged signal
plot(out.logsout.get('signalName').Values)

% Get time and data separately
sig = out.logsout.get('signalName').Values;
plot(sig.Time, sig.Data)
```

## Multiple simulations

When running many simulations, create an array of `Simulink.SimulationInput` objects:

```matlab
in = repmat(Simulink.SimulationInput('MyModel'),N,1);
for k = 1:N
    in(k) = Simulink.SimulationInput('MyModel');
    in(k) = in(k).setVariable('gain', gains(k));
end
out = sim(in);
```

To enable fast restart for iterative sweeps (compiles the model only once):

```matlab
out = sim(in, 'UseFastRestart', 'on');
```

## Parallel simulation (parsim)

To run multiple simulations in parallel, use `parsim` instead of looping over `sim`:

```matlab
for k = 1:N
    in(k) = Simulink.SimulationInput('MyModel');
    in(k) = in(k).setVariable('gain', gains(k));
end
out = parsim(in);
```

`parsim` also supports `'UseFastRestart','on'` for faster batch runs.

## Guardrails

- **Never** use `set_param`, `load_system`, or `open_system` to drive simulation — `SimulationInput` replaces all of these.
- **Never** wrap `SimulationOutput` access in `try-catch` or `isfield` — `sim` either returns a valid object or throws. `SimulationOutput` has no `isfield` method.
- **Never** create unnecessary intermediate variables for logged data — access directly via `out.logsout.get('name').Values`.
- **Always** use `in`/`out` as variable names for `SimulationInput`/`SimulationOutput`.
- **Always** use `setExternalInput` with a `Dataset` — don't pass comma-separated lists of variables.
