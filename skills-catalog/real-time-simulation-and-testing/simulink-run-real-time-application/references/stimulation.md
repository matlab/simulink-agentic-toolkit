# `tg.Stimulation` Reference

`tg.Stimulation` is the stimulation controller attached to the target object. It drives scheduled data for a running real-time application: root inports, Playback blocks, and time-varying parameter schedules.

This file covers the documented method surface, the argument forms each method accepts, and the `reloadData` rules. The Workflow's Steps 8–9 reference this file.

Stimulation is optional. Many run workflows only need `load`, `start`, `getparam` / `setparam`, recording, and `stop`. Use stimulation when the user needs input data or parameter values to change according to a time sequence during the run. For a one-time scalar parameter change, use `setparam`, not parameter stimulation.

## Documented Methods

| Method               | Purpose                                                            |
|----------------------|--------------------------------------------------------------------|
| `start(arg)`         | Start stimulation for the selected entries                         |
| `stop(arg)`          | Stop stimulation for the selected entries                          |
| `pause(arg)`         | Pause stimulation; resume with `start(arg)`                        |
| `getStatus(arg)`     | Read status (running / stopped / paused) for the selected entries  |
| `reloadData(...)`    | Replace the data backing one or more stimulation entries           |

Every method requires the target computer to be connected and an application to be loaded.

## Stimulation Types

The runtime distinguishes three kinds of stimulation entries:

- **ROOTIO** — root inports of the loaded application. An entry exists for every root inport in the built model and ships baked into the `.mldatx`. `start("In1")` / `start([1])` / `start("all")` work on a freshly loaded app with no extra setup.
- **PLAYBACK** — Playback blocks inside the model. Selected by full block path. Like inports, entries are baked into the `.mldatx` at build time.
- **PARAMETER** — scheduled data for tunable block or workspace parameters. **Entries do not exist by default.** A parameter is stimulable only after `reloadData(tg.Stimulation, blockPath, {parameterName, loadSource})` is called at runtime on a loaded application. `reloadData` supplies the time-varying data and registers the entry.

  Calling `start`, `stop`, `pause`, or `getStatus` against a parameter that has no entry returns no metadata and does nothing useful — no parameter-stimulation table was generated. Parameter stimulation **requires `reloadData` first** before `start` will drive anything. This is separate from basic `setparam`, which writes a value immediately and does not require a stimulation entry.

The selector argument forms below cover all three. The empty selector (`""`) targets every registered parameter entry — which is the empty set if none have been added.

## Argument Forms (selectors)

| Argument                                  | Selects                                                         |
|-------------------------------------------|------------------------------------------------------------------|
| `[1 3]` (numeric array)                   | Root inport port numbers, 1-indexed (ROOTIO only)               |
| `{"In1","In2"}` (cell of strings)         | Root inport names                                                |
| `{{"top/refModel","model/Blk"}}` (cell of cells) | Model-reference / playback paths                          |
| `"all"`                                   | All inports + all playback blocks                                |
| `""` (empty string)                       | All **registered** parameter-stimulation entries (none by default — see Stimulation Types above)         |
| `"In1"` (single string)                   | Single named inport, playback block, or parameter                |
| `"model/pb1"` (single string)             | Single block path                                                |
| `"BaseParam"` (single string)             | Single parameter name                                            |

The runtime resolves the selector against the loaded application's metadata. Names not found raise a clear error before any state change.

## `reloadData(...)` Forms

`reloadData` has three documented call shapes — one per stimulation type. The shape determines whether it loads an inport, a Playback block, or a parameter:

| Form                                                                            | Loads                                  |
|---------------------------------------------------------------------------------|----------------------------------------|
| `reloadData(tg.Stimulation, inport, loadSource)`                                | ROOTIO — single root inport            |
| `reloadData(tg.Stimulation, playback, loadSource)`                              | PLAYBACK — single Playback block       |
| `reloadData(tg.Stimulation, blockPath, {parameterName, loadSource})`            | PARAMETER — single tunable parameter   |

Selectors for each form:

- `inport` — inport name (`"In1"`), port number (`1`), or block path (`"myModel/In1"`)
- `playback` — block name (`"Playback"`) or block path (`"myModel/Playback"`)
- `blockPath` — block path of the originating block of the tunable parameter; empty string (`""`) for base- or model-workspace globals; cell of strings for model-block arguments

Accepted `loadSource` types:

| Source                             | Where it's accepted                                              |
|------------------------------------|------------------------------------------------------------------|
| `timeseries` object                | Inport, Playback, or parameter                                   |
| `Simulink.SimulationData.Dataset`  | Inport, Playback (multi-port via Dataset elements)               |
| Parquet filename (string)          | Inport, Playback (R2026b+), or parameter; one file per entry     |
| Cell of `{port, timeseries}` pairs | Playback blocks with multiple ports                              |

The runtime reports "Stimulation must be stopped" if the entry is running. Always call `stop` on that entry (or `stop("all")`) before `reloadData`.

## `reloadData` Constraints

- **Stimulation of the entry must be stopped** before reload. Calling `reloadData` while that entry is stimulating is rejected by the runtime. Call `stop` on the entry (or `stop("all")`) first.
- **For parameter stimulation, the parameter must be tunable.** Inlined parameters cannot be reached — the model needs the literal exposed as a workspace variable (or the parameter set as Tunable) and rebuilt. The skill does not configure model tunability — route to `simulink-configure-real-time-model`.
- **Parquet** files must use `Time64[us]` timestamps (strictly monotonically increasing, no nulls). Column datatypes and dimensions must match the application's recorded metadata for that entry. Parameter and inport Parquet files are one-entry-per-file.
- **`timeseries` data** column type and width must match the entry's recorded metadata. Mismatches raise a clear error before any state change.

## Worked Example — Reload from Parquet

```matlab
% App is running with default stimulation; replace the inputs
disp(tg.Stimulation.getStatus("all"));

tg.Stimulation.stop("all");
tg.Stimulation.reloadData("inputs.parquet");
tg.Stimulation.start("all");

disp(tg.Stimulation.getStatus("all"));
```

## Worked Example — Drive a Subset

```matlab
% App is running; only drive root inports 1 and 3
tg.Stimulation.stop("all");
tg.Stimulation.start([1 3]);
disp(tg.Stimulation.getStatus([1 3]));
```

## Worked Example — Parameter Stimulation

Use parameter stimulation only when the value should follow scheduled data over time. A parameter cannot be driven until `reloadData` has registered the entry. The sequence is **load data first, then start**:

```matlab
% Schedule a tunable Signal Generator Frequency over time:
%   t=0 s -> 20 Hz, t=1 s -> 40 Hz, t=2 s -> 60 Hz
t = [0 1 2];
f = [20 40 60];
freqTs = timeseries(f(:), t(:));

% blockPath is the originating block; the cell pair is {parameterName, source}.
tg.Stimulation.reloadData("slrt_ex_osc/Signal Generator", {"Frequency", freqTs});

% Now the entry exists — start, observe, stop.
tg.Stimulation.start("slrt_ex_osc/Signal Generator");
disp(tg.Stimulation.getStatus("slrt_ex_osc/Signal Generator"));
```

For a base- or model-workspace global parameter, pass `""` as the `blockPath`:

```matlab
tg.Stimulation.reloadData("", {"Kp", freqTs});
tg.Stimulation.start("Kp");
```

If `start` reports no metadata, no `reloadData` call has registered the
parameter — call `reloadData` first.

----

Copyright 2026 The MathWorks, Inc.

----
