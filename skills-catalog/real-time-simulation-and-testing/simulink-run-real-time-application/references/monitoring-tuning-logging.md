# Monitoring, Tuning, Recording, and File Logging

Use this reference when the user asks how to observe a running real-time application, change parameters without rebuilding, save/reload tuned values, collect file logs, or choose between streaming and target-side logging.

## Choose the Data Path

| User intent                           | Preferred path                            | Notes                                                                                                                                                                                                        |
| ------------------------------------- | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| One-time parameter read/write         | `getparam` / `setparam`                   | Works on tunable parameters in a loaded or running application. Values reset to build-time defaults when the app is reloaded unless saved in a parameter set.                                                |
| Save or reapply many parameter values | Parameter sets                            | Use when a test engineer or operator needs repeatable groups of tunable values between runs.                                                                                                                 |
| Time-varying input data               | `tg.Stimulation`                          | Best for root inports, Playback blocks, and scheduled parameter changes. It is not the default answer for a simple scalar tuning change.                                                                     |
| One-time signal read                  | `getsignal`                               | Good for ad hoc checks and script assertions. See `signal-access-and-streaming.md`.                                                                                                                          |
| Live host-side monitoring             | Streaming / SDI / App Designer components | Good for lower-rate visualization. Not a lossless substitute for high-rate logging. See `signal-access-and-streaming.md`.                                                                                    |
| Robust post-run signal data           | File logging                              | Target-side on-disk logging is the main path for high-rate or long-duration data, including runs where the development computer will not remain connected. |
| Separate experiment intervals         | `startRecording` / `stopRecording`        | Creates separate logs/runs, but gaps exist between stop and restart.                                                                                                                                         |

## Parameter Tuning

Use `getparam` and `setparam` for direct tuning of a loaded or running application:

```matlab
tg = slrealtime;
connect(tg);
load(tg, "myModel");

value = getparam(tg, "myModel/Gain", "Gain");
setparam(tg, "myModel/Gain", "Gain", 3.5);
```

For global parameters or variables, use the short form or the explicit empty-block-path form:

```matlab
kpShortForm = getparam(tg, "Kp");
setparam(tg, "Kp", 2.0);

kpExplicitForm = getparam(tg, "", "Kp");
setparam(tg, "", "Kp", 2.0);
```

Important limits:

- The parameter must be tunable in the generated real-time application.
- Inlined literals, expression-derived mask values, and parameters used in mask initialization can become non-tunable.
- If `getparam` / `setparam` reports "Parameter is not tunable" or "does not exist", route the model change to `simulink-configure-real-time-model` and rebuild.
- Use `setparam` for one-time tuning. Use Stimulation only when the user needs a time-varying parameter schedule.

## Parameter Sets

Use parameter sets when the user wants to save and reload groups of tuned values.

```matlab
saveParamSet(tg, "baseline");
loadParamSet(tg, "baseline");
```

`autoSaveOnStop` can preserve the values from a previous run. `setDefaultParamSet` can select a parameter set that loads by default for future runs.

```matlab
loadParamSet(tg, "autoSaveOnStop");
setDefaultParamSet(tg, "myModel", "autoSaveOnStop");
```

For editing parameter-set contents on the development computer, use `importParamSet` / `exportParamSet` and the `slrealtime.ParameterSet` workflow. For SSH control-only operators, `slrealtime loadParamSet` can load predefined parameter sets before start, but it cannot tune arbitrary individual parameters during runtime.

For signal values, use `getsignal` rather than `getparam`; see `signal-access-and-streaming.md` for block-path and model-reference path forms.

## Recording and File Logs

File logging is target-side on-disk capture. During a run, Simulink Real-Time writes signal data to log files on the target computer; completed logs are later imported or exported for post-processing. This is different from live streaming, which sends samples across the network to SDI, dashboard blocks, App Designer components, or MATLAB callbacks while the application is running.

- **File Log blocks** live on the canvas, are saved model behavior, and run every time that application runs after the model is rebuilt.
- **File-log instruments** are configured outside this skill with `slrealtime.Instrument` / `addForFileLog`; route to `simulink-instrument-real-time-application`. They are useful when the user wants to add file-log signals dynamically, including while the application is running with recording inactive, or when they want to avoid a rebuild.
- **Recording controls** (`startRecording` / `stopRecording`) define recording intervals for enabled logging data. They do not by themselves choose new signals to log.

Use recording controls when the user wants separate recording intervals:

```matlab
startRecording(tg);
stopRecording(tg);
```

Caveats:

- Each recording start creates a new log.
- There are gaps between `stopRecording` and the next `startRecording`; repeated recording intervals are not gap-free.
- A log cannot be imported while it is actively being written.
- Set `FileLogMaxRuns` high enough for the experiment plan and target disk budget.
- File logging stops when target disk free space falls below the product threshold, about 1 GB; existing logs are not overwritten.

Import completed file logs into SDI:

```matlab
tg.FileLog.import("myModel");
runIDs = Simulink.sdi.getAllRunIDs;
dataSet = slrealtime.exportRun(runIDs(end));
slrealtime.exportRun(runIDs(end), "to", "file", "fileName", "fileLog.mat");
```

If the user manually downloads logs from the target computer, copy the full application folder and use `slrealtime.fileLogImport`.

## Streaming

Streaming is useful for live host-side monitoring of data, but it can drop data or slow host-target interactions if too many high-rate signals are streamed. For high-rate or long-duration data, prefer target-side file logging and import after recording stops.

Use `getsignal` for ad hoc one-time signal reads, not continuous monitoring. Detailed path forms, model-reference access, decimation, SDI record-data behavior, and overload symptoms are in `signal-access-and-streaming.md`.

Instrument-specific setup belongs in `simulink-instrument-real-time-application`.

## Common Failure Modes

| Symptom                            | Likely cause                                                                                             | Response                                                                                                                                                                                                                                                                       |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `Parameter is not tunable`         | Parameter is optimized out, inlined, expression-derived, or mask-init-derived in generated code          | Route model tunability changes to `simulink-configure-real-time-model`; rebuild before retrying.                                                                                                                                                                                    |
| File logs missing or cannot import | Log is still being written, import path is wrong, target disk is full, or deployed-app limitations apply | Stop recording first, check retained run count and disk, then import/export with the appropriate workflow.                                                                                                                                                                     |
| Long stop time                     | Auto file-log import, export-to-base-workspace, or auto parameter-set save is expensive                  | Start with `AutoImportFileLog=false` and `ExportToBaseWorkspace=false`; consider disabling auto-save-on-stop for very large parameter sets.                                                                                                                                    |
| Live streaming drops data          | Streaming load exceeds host-target bandwidth or SDI throughput                                           | Reduce streamed signal count/rate, use decimation or slower logging sample time, check System Log Viewer for overload messages, consider `Simulink.sdi.setRecordData(false)` for live-only viewing, and use File Log for high-rate data. See `signal-access-and-streaming.md`. |

----

Copyright 2026 The MathWorks, Inc.

----
