# API Signature Reference

These are the **only** forms this skill uses. Do not invent variants. Dot-form and
function-form are equivalent: `load(tg, app)` = `tg.load(app)`. Two non-obvious shapes:
`start` takes the target only (the loaded application is what runs), and `AutoImportFileLog`
on `stop` is name-value. Below, `tg` is the target object and `app` the `.mldatx`
application name.

| Operation                         | Exact form example                                                          |
| --------------------------------- | --------------------------------------------------------------------------- |
| Build model                       | `slbuild(model);` (produces `<model>.mldatx`)                               |
| Install application (upload only) | `install(tg, app);` / `install(tg, app, 'force');`                          |
| Load application (install + load) | `load(tg, app);`                                                            |
| Start application                 | `start(tg);` (or with name-value pairs - see `start-options.md`)            |
| Stop application                  | `stop(tg);` / `stop(tg, AutoImportFileLog=false);`                          |
| Set stop time                     | `setStopTime(tg, 30);` (requires app loaded)                                |
| Run state predicates              | `isLoaded(tg, app);` / `isRunning(tg, app);` / `isConnected(tg);`           |
| Lifecycle rollup                  | `status(tg);` (owned by `simulink-configure-real-time-target`)              |
| Installed apps — list             | `apps = getInstalledApplications(tg);`                                      |
| Installed apps — remove one       | `removeApplication(tg, "appName");`                                         |
| Installed apps — remove all       | `removeAllApplications(tg);`                                                |
| Read block parameter value        | `value = getparam(tg, blockPath, parameterName);`                           |
| Write block parameter value       | `setparam(tg, blockPath, parameterName, value);`                            |
| Read global parameter value       | `value = getparam(tg, "Kp");` / `value = getparam(tg, "", "Kp");`           |
| Write global parameter value      | `setparam(tg, "Kp", value);` / `setparam(tg, "", "Kp", value);`             |
| Read signal value                 | `value = getsignal(tg, blockPath, portIndex);`                              |
| Save parameter set                | `saveParamSet(tg, "setName");`                                              |
| Load parameter set                | `loadParamSet(tg, "setName");`                                              |
| Start/stop recording              | `startRecording(tg);` / `stopRecording(tg);`                                |
| Import file logs                  | `tg.FileLog.import(app);`                                                   |
| Export imported SDI run           | `dataSet = slrealtime.exportRun(runID);`                                    |

## Stimulation

`tg.Stimulation` is optional and drives scheduled data for root inports, Playback blocks,
and parameter schedules. Selector forms and accepted sources are in `stimulation.md`.

| Operation                        | Exact form                                                   |
|----------------------------------|--------------------------------------------------------------|
| Start                            | `tg.Stimulation.start(arg);`                                 |
| Stop                             | `tg.Stimulation.stop(arg);`                                  |
| Pause                            | `tg.Stimulation.pause(arg);`                                 |
| Read status                      | `tg.Stimulation.getStatus(arg);`                             |
| Reload inport data (stopped)     | `tg.Stimulation.reloadData(inport, source);`                 |
| Reload Playback block (stopped)  | `tg.Stimulation.reloadData(playback, source);`               |
| Reload parameter (stopped)       | `tg.Stimulation.reloadData(blockPath, {paramName, source});` |

**Parameter stimulation has a setup step.** ROOTIO and PLAYBACK entries ship inside the
built `.mldatx`; PARAMETER entries do **not**. A parameter is stimulable only after
`reloadData(tg.Stimulation, blockPath, {paramName, source})` registers the entry at runtime.
For time-varying schedules only — use `setparam` for basic tuning.

## `start` Named Parameters

`start-options.md` holds the authorized table. Invent nothing beyond it.

----

Copyright 2026 The MathWorks, Inc.

----
