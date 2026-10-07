# `start` Named Parameters

`start(tg, ...)` accepts 8 name-value pairs (R2026a). `start` does not take an application argument — the loaded application is implied. Override only the parameters the user explicitly cares about.

This file is the field-by-field reference. The Workflow's Step 6 says "see this file" — that's what this is.

## Parameters

| Parameter                  | Type    | Default               | When to set                                                                 |
|----------------------------|---------|-----------------------|------------------------------------------------------------------------------|
| `ExportToBaseWorkspace`    | logical | `true`                | Disable for headless CI where you collect logs out-of-band.                  |
| `AutoImportFileLog`        | logical | `true`                | Disable when collecting file logs externally.                                |
| `ReloadOnStop`             | logical | `false`               | Long-running rigs that auto-recover after each run.                          |
| `LogLevel`                 | char    | `'info'`              | Choose from `'info' / 'trace' / 'debug' / 'warning' / 'error' / 'fatal'`. Use `'debug'` or `'trace'` only when debugging — log volume is high. |
| `PollingThreshold`         | int32   | `100`                 | Latency-sensitive apps; pairs with polling mode (set in `simulink-configure-real-time-model`). |
| `FileLogMaxRuns`           | int     | `1`                   | Disk-budget tuning — caps retained file-log runs on the target computer.     |
| `StopTime`                 | scalar  | model `StopTime`      | Bounded test runs.                                                           |
| `StartStimulation`         | char    | `'on'`                | `'off'` to bring the app up cold and start stimulation manually later.       |

These defaults are documented in `help slrealtime.Target.start`. To inspect the effective values on a connected target computer with an app loaded, read `tg.TargetSettings` and the application's properties via the Simulink Real-Time Explorer.

## `StartStimulation` Detail

When `StartStimulation` is `'off'` the application starts without driving any inputs. Use this when you want to:

- Bring the app up cold and inspect initial state.
- Reload stimulation data before the first run (call `Stimulation.reloadData(...)`, then `Stimulation.start(...)`).

When `StartStimulation` is `'on'` (the default), every stimulation entry recorded in the application's metadata starts immediately when the app starts.

## Worked Example

```matlab
model = "myModel";
app   = model;

slbuild(model);

tg = slrealtime;
connect(tg);
load(tg, app);

start(tg, ...
    "StopTime",         30, ...
    "StartStimulation", "off", ...
    "LogLevel",         "debug", ...
    "FileLogMaxRuns",   5);

% Bring stimulation up after start so we can swap data first
tg.Stimulation.reloadData("inputs.parquet");
tg.Stimulation.start("all");

assert(isRunning(tg, app));
```

## Common Failure Modes

| Cause                                                      | Fix                                                               |
| ---------------------------------------------------------- | ----------------------------------------------------------------- |
| `start` called before `load`                               | Call `load(tg, app)` first.                                       |
| `start` called while app already running                   | Call `stop(tg)` first, or skip the redundant `start`.             |
| App's System Target File (STF) does not match target's STF | Reconfigure model in `simulink-configure-real-time-model` and rebuild. |
| `load` called while a different app is running             | Call `stop(tg)` first.                                            |

----

Copyright 2026 The MathWorks, Inc.

----
