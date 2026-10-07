---
name: simulink-run-real-time-application
description: Build, deploy, run, monitor, tune, and stop Simulink Real-Time applications. Use when the user wants to build a Simulink Real-Time model, load/start/stop an `.mldatx` on a target, set stop time or start options, drive root inports/playback/parameter stimulation, inspect installed or running apps, tune parameters with `getparam`/`setparam`, read ad hoc signal values with `getsignal`, manage parameter sets, control recording, or choose between file logging, live streaming, and file-log import. Covers `slbuild`, `install`, `load`, `start`, `stop`, `setStopTime`, `tg.Stimulation`, `startRecording`/`stopRecording`, `tg.FileLog.import`, `slrealtime.exportRun`, `getparam`/`setparam`, `getsignal`, and installed app management for Speedgoat targets and Simulink Real-Time Linux devices.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Running Simulink Real-Time Applications

Own the **run lifecycle** for Simulink Real-Time — build the model, install/load the
application on the target computer, start and stop it, set its stop time, drive root inports
and Playback blocks via `tg.Stimulation` — plus the first-pass runtime workflows around
parameter tuning, parameter sets, recording, file logs, and live streaming.

> **Release compatibility:** Designed and validated for MATLAB R2026a and later. Not
> recommended for earlier releases: APIs, system target files, and workflows differ.

## When to Use

- Building a model with `slbuild`; installing or loading an `.mldatx` (`install`, `load`)
- Starting (`start`, with or without options), stopping (`stop`), or setting stop time (`setStopTime`)
- Reading run state (`isLoaded`, `isRunning`)
- Driving root inports, Playback blocks, or parameter schedules via `tg.Stimulation`, including reloading data from a timeseries, Dataset, parquet file, or struct
- Reading or writing tunable parameters (`getparam`, `setparam`) or one-time signal values (`getsignal`) on a loaded or running application
- Saving, loading, importing, exporting, or selecting parameter sets
- Recording, importing file logs, exporting SDI runs, or choosing between file logging and live streaming
- Inspecting or removing installed applications (`getInstalledApplications`, `removeApplication`, `removeAllApplications`)

## When NOT to Use

If the task crosses one of these lines, **STOP and load the named skill first** before writing any code, then come back.

- **Model configuration** — system target file, fixed-step solver, Simulink Real-Time options → `simulink-configure-real-time-model`. Never patch model configuration here.
- **Target definitions and target ops** — IP, credentials, RTOS update, `connect(tg)` troubleshooting, `status(tg)`, `reboot(tg)`, `setStartupApp` → `simulink-configure-real-time-target`.
- **Signal capture** — `slrealtime.Instrument`, `addForFileLog`, `addForSDI`, `addForMATLAB` → `simulink-instrument-real-time-application`.
- **Model structure edits** — adding File Log blocks, logging badges, root inports, Playback blocks, or tunable variables to make signals loggable, streamable, or tunable → the Simulink model-editing workflow or `simulink-configure-real-time-model`.

## Prerequisites

- MATLAB **R2026a or newer**
- Simulink Real-Time installed (`ver` lists "Simulink Real-Time")
- A relevant support package installed for the target hardware:
  - **Speedgoat hardware** → Speedgoat Add-On
  - **Linux x86-64 devices** → Embedded Coder Support Package for Real-Time Linux (requires Embedded Coder)
- The Simulink model is configured for Simulink Real-Time (see `simulink-configure-real-time-model`)
- A target computer is configured and reachable on the network (see `simulink-configure-real-time-target`)

## Workflow

| Step | Purpose | Asks first? |
| --- | --- | --- |
| 1. Confirm preconditions | Connect to the target; verify the model's STF before the first build | No |
| 2. Build the model | `slbuild` produces the `.mldatx` | If a current artifact is in use |
| 3. Inspect target state | Read what is loaded, running, and installed | No (read-only) |
| 4. Install or load | Put the application on the target | Surface an already-loaded app |
| 5. Set stop time | Runtime stop-time override, only when needed | If non-default |
| 6. Start | Run the loaded application, with optional name-value pairs | If non-default `StopTime`/`LogLevel` |
| 7. Verify run state | Read run state back after every change | No |
| 8. Drive stimulation | Scheduled root-inport, Playback, or parameter data | No |
| 9. Reload stimulation data | Replace a stopped entry's source | No |
| 10. Monitor, tune, and log | `getparam`/`setparam`, `getsignal`, parameter sets, recording, file logs | For hardware-affecting `setparam`, `loadParamSet` |
| 11. Stop | End the run early or control file-log import | If `AutoImportFileLog=false` |
| 12. Manage installed apps | List or remove installed applications | Yes (remove) |

**Use only the documented forms** in `references/api-reference.md` (every call this skill
makes, the `tg.Stimulation` methods, and the parameter-stimulation setup step) and
`references/start-options.md` (the `start` named parameters). Dot-form and function-form are
equivalent (`load(tg, app)` = `tg.load(app)`). `start` takes the target only — the loaded
application is what runs — and `AutoImportFileLog` on `stop` is name-value.

### 1. Confirm Preconditions

Connect to the target and confirm the model is configured for Simulink Real-Time before the
first build. Below, `tg` is the target object and `app` the `.mldatx` application name.

```matlab
model = "myModelName";
app   = model;

tg = slrealtime; % Default Target
connect(tg);
assert(isConnected(tg), "Failed to connect to %s", tg.TargetSettings.name);
```

The model must be resolvable on the MATLAB path before `slbuild`, but do not require `bdIsLoaded(model)` for every runtime operation. If the target computer is not configured, route to `simulink-configure-real-time-target`. Do not patch model or target settings here.

**Preflight before the first `slbuild` — always verify the model is configured.** A model's name or `slrt_` prefix is not evidence of it.

```matlab
% Model must target Simulink Real-Time. speedgoat.tlc | speedgoat_aarch64.tlc | slrtlinux_x64.tlc
load_system(model);
stf = get_param(model, "SystemTargetFile");
disp(stf);
```

If `stf` is not a Simulink Real-Time STF (e.g. `grt.tlc`, `ert.tlc`, or empty), STOP and load `simulink-configure-real-time-model`.

There is no host C compiler to check for — the Speedgoat Add-On ships the cross-compiler `slbuild` uses. A compiler or toolchain error from `slbuild` means model configuration or a missing support package. See `references/guardrails.md`.

### 2. Build the Model

Build the real-time application from the configured model.

```matlab
slbuild(model);
```

Produces `<model>.mldatx` in the build folder, destroying any previous one. Ask first if a current artifact is in use on a running target computer.

On failure, classify before routing: model configuration, install/toolchain, path/environment, custom code/library, or unsupported block. See `references/build-and-load-pipeline.md`.

### 3. Inspect Target State

Before any destructive op, read what is on the target computer.

```matlab
disp(isLoaded(tg, app));
disp(isRunning(tg, app));
disp(getInstalledApplications(tg));
```

If something is already running, surface that to the user before calling `load` or `start` — those calls will refuse to clobber a running app.

### 4. Install or Load the Application

`load` installs the `.mldatx` and loads it into the runtime. Use `install` for upload-only; `'force'` re-uploads an artifact the target already has.

```matlab
load(tg, app);
install(tg, app);
install(tg, app, 'force');
```

Constraints:

- The app's SystemTargetFile must match the target's — `load` fails with a clear message. Surface it and route to `simulink-configure-real-time-model`.
- If an app is **running**, `load` refuses to overwrite it; stop it first.
- If an app is **loaded but not running**, `load` stops it first. Surface this before invoking.

See `references/build-and-load-pipeline.md` for the full sequencing.

### 5. Set Stop Time When Needed

Skip this when the model/start settings already cover the intended duration. Use these only for a runtime override.

```matlab
setStopTime(tg, 30);                    % requires loaded; fires StopTimeChanged
start(tg, "StopTime", 30);              % per-run override
```

`setStopTime` validates `nonnegative scalar` and requires the app to be loaded.

### 6. Start the Application

Run the loaded application on the target computer.

```matlab
start(tg);
```

`start` takes the target only — the loaded application is implied — plus 8 optional name-value pairs. See `references/start-options.md` for the full table.

Common forms:

```matlab
start(tg, "StopTime", 30, "LogLevel", "debug");
start(tg, "StopTime", 30, "StartStimulation", "off");   % finite run, no auto-stimulation
start(tg, "FileLogMaxRuns", 5, "AutoImportFileLog", false);
```

`start` auto-connects if the target is not connected, but prefer an explicit `connect(tg)` so the user sees it happen.

**Ask First** before a non-default `LogLevel` or `AutoImportFileLog=false` — see Guardrails.

### 7. Verify Run State

Confirm the application is actually running before reporting success.

```matlab
assert(isRunning(tg, app), "Application failed to start.");
```

Read state back after every change. For Stimulation runs, also check `tg.Stimulation.getStatus("all")`.

### 8. Drive Stimulation When Needed

Stimulation is optional — use it for scheduled root-inport data, Playback block data, or time-varying parameter schedules. Not for a one-time parameter change; use `setparam`.

Every `Stimulation` method requires the target connected and the application loaded. For selector forms, `reloadData` shapes, accepted sources, and parameter-entry registration, see `references/stimulation.md`.

### 9. Reload Stimulation Data When Needed

Reload only to replace the scheduled source for an inport, Playback block, or parameter schedule. The affected entry must be stopped first. For parameters, `reloadData` is also the registration step that makes the parameter stimulable.

### 10. Monitor, Tune, and Log During Runs

Choose the data path by intent: `getparam`/`setparam` for one-off tunable reads and writes; `getsignal` for one-off signal reads; parameter sets for saving or selecting groups of values between runs; Stimulation for time-varying inputs or schedules; streaming for live host-side monitoring; File Log blocks or file-log instruments for high-rate or long-duration post-run data; `startRecording`/`stopRecording` for separate recording intervals and separate imported runs.

```matlab
value = getparam(tg, "myModel/Gain", "Gain");
setparam(tg, "myModel/Gain", "Gain", 3.5);
signalValue = getsignal(tg, "myModel/OutBlock", 1);

saveParamSet(tg, "baseline");
loadParamSet(tg, "baseline");

startRecording(tg);
stopRecording(tg);
tg.FileLog.import(app);
```

See `references/monitoring-tuning-logging.md` for parameter sets, recording controls, and file-log import/export; `references/signal-access-and-streaming.md` for `getsignal`, model-reference paths, streaming overload, and decimation. Route instrument setup to `simulink-instrument-real-time-application`.

### 11. Stop the Application When Needed

Skip this when the application should run to its configured stop time. Call `stop` to stop early, end an indefinite run, or control file-log import.

```matlab
stop(tg);                              % AutoImportFileLog defaults to true
stop(tg, AutoImportFileLog=false);     % skip file-log import
```

`stop` **stops the application and unloads it** — afterwards `isLoaded(tg, app)` is `false`, so a second run needs `load(tg, app)` before `start(tg)`. It is safe to call when the app is not running. The runtime also deletes the target's `currParamSet` file. With `AutoImportFileLog=false`, logs stay on the target and `FileLogMaxRuns=1` lets the next run overwrite them.

### 12. Manage Installed Applications

List what is installed on the target computer, and remove applications only on request.

```matlab
apps = getInstalledApplications(tg);
disp(apps);

removeApplication(tg, "myApp");
removeAllApplications(tg);
```

**Ask First** — these are irreversible without a rebuild and re-install.

Constraints:

- Cannot remove a running app — stop first.
- Cannot remove the configured startup app without first calling `clearStartupApp(tg)`. That belongs to `simulink-configure-real-time-target`.

## Verification

```matlab
disp(isConnected(tg));
disp(isLoaded(tg, app));
disp(isRunning(tg, app));
disp(getInstalledApplications(tg));
disp(tg.Stimulation.getStatus("all"));
```

After a full run cycle, expect: `isConnected=true`, `isLoaded(tg, app)=true` between `load` and `stop`, `isRunning(tg, app)=true` between `start` and `stop`, and both `isRunning(tg, app)=false` **and** `isLoaded(tg, app)=false` after `stop` — `stop` unloads the application, so a subsequent run needs a fresh `load(tg, app)` first.

## Guardrails

`references/guardrails.md` carries the reasoning behind every rule below, plus the full table of invented forms with the correct replacement for each.

Always:

- Read `SystemTargetFile` before `slbuild` — never infer configuration from the model name or an `slrt_` prefix. Route to `simulink-configure-real-time-model` if it is not a Simulink Real-Time STF.
- Verify `isConnected(tg)` before any `install`, `load`, `start`, `stop`, or `Stimulation` call.
- Read `isLoaded(tg, app)` and `isRunning(tg, app)` before mutating run state.
- Let `load` validate STF compatibility; surface its error message verbatim.
- Stop the affected stimulation entry (`Stimulation.stop(selector)` or `stop("all")`) before `reloadData` — required even on a freshly loaded app.
- Check a `reloadData` source against the app's recorded root-inport metadata before the call — mismatched datatypes or dimensions are rejected at best, misinterpreted at worst.
- For **parameter** stimulation, call `reloadData` **before** `start`; that call is what registers the entry. Without it, `start` is a silent no-op. Use `setparam` for one-time tuning.
- Use `Time64[us]` (`duration`) timestamps in parquet stimulation files.
- Confirm parameters are tunable before promising `getparam`/`setparam`/parameter sets; route tunability fixes to `simulink-configure-real-time-model`.
- Classify the data need (live monitoring, post-run integrity, deployed-app access, outside-MATLAB access) before choosing streaming, recording, file logging, or routing to `simulink-instrument-real-time-application`.

Ask first:

- `slbuild` when a current `.mldatx` is loaded or running — the rebuild invalidates it.
- `start` with non-default `StopTime` or `LogLevel` — surface the value and intent.
- `stop(tg, AutoImportFileLog=false)` — logs stay on the target and the next run can overwrite them.
- `removeApplication` / `removeAllApplications` — irreversible without rebuild + re-install.
- `setparam` that changes plant/controller behavior on hardware — surface block path, parameter, value.
- `loadParamSet` / `setDefaultParamSet` — one call can change many tunable values.

Never:

- **Invent function names, named parameters, or selector forms absent from `references/api-reference.md` and the other reference files.** If a form is not shown, do not use it. The forms agents invent most often — refuse each and use the right-hand column:

  | Invented | Use instead |
  |---|---|
  | `tg.run(app)` / `tg.execute(app)` / `tg.deploy(app)` | `load(tg, app)` then `start(tg)` |
  | `start(tg, app, ...)` | `start(tg, ...)` — the loaded app is implied |
  | `load(tg, app, "SkipInstall", true)` | `load(tg, app)` — `load` has no name-value pairs |
  | `tg.unload()` / `tg.kill()` | `stop(tg)` |
  | `pause(tg)` / `tg.pause()` / `tg.suspend()` | `tg.Stimulation.pause(selector)`, or stop the app — the target has no pause |
  | `stop(tg, app)` / `stop(tg, "myApp")` | `stop(tg)` |
  | `stop(tg, false)` (shown in the published doc) | `stop(tg, AutoImportFileLog=false)` — the runtime rejects the positional form |
  | `"Duration"` / `"Timeout"` / `"MaxRuntime"` on `start` | `"StopTime"` — only the 8 documented parameters exist |
  | `tg.getApps()` / `tg.listInstalled()` | `getInstalledApplications(tg)` |
  | `tg.Stimulation.startAll()` | `tg.Stimulation.start("all")` |
  | `Stimulation.swapData/loadData/replaceData` | `Stimulation.reloadData(selector, source)` |
  | `Stimulation.reset/clear/restore` | `load(tg, app)` again — defaults live in the `.mldatx` |

The remaining Never rules — the run-state ordering traps, the Stimulation
sequencing traps, the inlined-literal trap, the recording-continuity claim, and
editing build artifacts or model settings from here — are listed with the failure
mode behind each in `references/guardrails.md`. Read that file before any
lifecycle, Stimulation, or logging call.

## Task Routing

| Task                                                          | Reference                                            |
|---------------------------------------------------------------|------------------------------------------------------|
| Every API form this skill uses, `tg.Stimulation` methods      | `references/api-reference.md`                        |
| `tg.start` named parameters and defaults                      | `references/start-options.md`                        |
| `tg.Stimulation` argument forms, stimulation types, reloadData | `references/stimulation.md`                          |
| `slbuild` → `install` → `load` → `start` lifecycle, STF check | `references/build-and-load-pipeline.md`              |
| `getparam`, `setparam`, parameter sets, recording, file logs | `references/monitoring-tuning-logging.md` |
| `getsignal`, model-reference signal paths, streaming overload, decimation | `references/signal-access-and-streaming.md` |
| Instrument-specific signal capture workflows                 | `simulink-instrument-real-time-application`      |
| Model setup (STF, solver, polling mode)                       | `simulink-configure-real-time-model`                            |
| Target object, IP, credentials, RTOS, reboot, startup app     | `simulink-configure-real-time-target`                           |

----

Copyright 2026 The MathWorks, Inc.

----
