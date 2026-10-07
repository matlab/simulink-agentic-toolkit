# Build and Load Pipeline

The path from a configured Simulink model to a running application on the target computer is a fixed sequence of five calls. Skipping or reordering them produces specific, recognizable errors. This file documents the sequence, the artifacts each step produces, and the precondition each step enforces.

```
slbuild(model)         →  <model>.mldatx in build folder
       │
       ▼
install(tg, app)       →  .mldatx uploaded to target  (use install(tg, app, 'force') to re-upload)
       │
       ▼
load(tg, app)          →  app loaded into target runtime (also installs if not already on target)
       │
       ▼
start(tg, ...)         →  application running on target
       │
       ▼
stop(tg, ...)          →  application stopped AND unloaded (isLoaded→false); currParamSet deleted; file logs imported (default)
```

## Step 1 — `slbuild(model)`

Runs the Simulink Real-Time toolchain against the loaded model and produces `<model>.mldatx` in the model's build folder. The `.mldatx` is a single-file package that contains:

- The cross-compiled real-time executable.
- Application metadata: System Target File name, base-rate sample period, root-inport list, playback-block list, parameter list, recorded stimulation data, file-log channel definitions.
- Whatever the configured SystemTargetFile chooses to ship (Speedgoat hardware drivers, etc.).

The build is destructive of any previous `.mldatx` in the build folder. If a current artifact is already loaded on a target computer, the rebuild does **not** invalidate the loaded copy — the loaded copy is a separate file under `~/.slrt/applications/` on the target computer. The next `load(tg, app)` will overwrite it.

If `slbuild` fails, classify the failure before routing. Common causes:

- Model configuration: system target file mismatch, variable-step solver, unsupported blocks for code generation.
- Installation/toolchain: incomplete Simulink Real-Time target support package, missing target compiler, missing `slrtssd.raw`, missing standard headers.
- Speedgoat package state: `speedgoat.tlc` missing usually means Speedgoat I/O Blockset is missing or not on the MATLAB path.
- Path/environment: OneDrive, network drives, UNC paths, synchronized folders, or aggressive antivirus scanning.
- Custom code/library: Windows `.dll`/`.lib` artifacts are not deployable to modern Speedgoat targets; target libraries must match the target RTOS/toolchain.

First, capture the build log and check whether a small Simulink Real-Time shipping example builds. If the example fails, focus on installation/toolchain. If the example succeeds, focus on the user's model, custom code, blocks, or path.

### Build-Failure Triage

Work through these checks before making model edits:

1. **Confirm product and support-package state.** `ver` should include Simulink Real-Time and the code generation products needed for build. For Speedgoat hardware, `speedgoat.version` should run successfully and match the target-side Speedgoat library version shown on the target monitor or in Explorer.
2. **Confirm the STF.** Speedgoat builds should use `speedgoat.tlc` in current releases. If `speedgoat.tlc` is missing or unknown, repair the Speedgoat Add-On / I/O Blockset installation or MATLAB path before editing the model.
3. **Build a shipping Simulink Real-Time example.** If a MathWorks or Speedgoat example fails with the same compiler/toolchain error, treat the issue as installation, path, antivirus, or compiler state. Do not chase user-model blocks until the example build works.
4. **Check path and file location.** Move the model and generated-code folder off OneDrive, network drives, UNC paths, synchronized folders, and directories with aggressive antivirus scanning. Long or unusual paths can also break generated-code and compiler tools.
5. **Inspect custom code and libraries.** Windows `.dll` and `.lib` files are not deployable to modern Speedgoat targets. Rebuild custom libraries for the target RTOS/toolchain and link target-side `.so` or `.a` artifacts as appropriate.
6. **Then inspect model content.** After the environment is known-good, address unsupported blocks, missing sample times, variable-step settings, code-generation errors, or hardware-driver block issues in the user's model.

## Step 2 — `install(tg, app)`

Uploads the `.mldatx` to the target computer. Resolves `app` via `which()` if a bare name is given, or treats it as a path otherwise.

`install` accepts a `'force'` flag to overwrite the target-side copy: `install(tg, app, 'force')`. Use it when:

- You want to upload an artifact for later use without loading it now.
- You rebuilt the model and want to refresh the target copy.

`load` installs the application automatically when it is not already on the target computer, so most workflows skip the explicit `install` call.

## Step 3 — `load(tg, app)`

Installs the application if it is not already on the target computer, then **loads** it into the runtime, making it ready for `start`.

```matlab
load(tg, app);
```

### System Target File (STF) Compatibility Check

`load` validates that the application's SystemTargetFile (recorded in metadata at build time) is compatible with the target's STF (selected by the installed support package). If they do not match, `load` fails with a clear message naming both STFs. Surface the message to the user and route to `simulink-configure-real-time-model` to fix the model STF, then rebuild.

### Load-While-Running

If the target computer is **running** an application, `load` refuses to overwrite it. Stop the running app first.

### Load-While-Loaded

If a different application is **loaded but not running**, `load` stops it before loading the new one. This is silent — surface the behavior to the user before invoking if the loaded app might be the wrong one to clobber.

## Step 4 — `start(tg, ...)`

Runs the loaded application. `start` does not take an application argument — the loaded application is implied. Auto-connects if the target computer is not connected (no need to call `connect(tg)` first, but a friendly explicit `connect` makes the connection step visible to the user).

Preconditions:

- App must be loaded — otherwise `start` fails saying a loaded application is required.
- App must not be running — otherwise `start` refuses to launch a second run.

See `start-options.md` for the 8 named parameters.

## Step 5 — `stop(tg, ...)`

Stops the running application. Idempotent: returns silently if the app is not loaded and not running. `AutoImportFileLog` is a name-value argument. The published doc shows positional, but the runtime rejects `stop(tg, false)` with "requires exactly 1 positional input"; only the name-value form works:

```matlab
stop(tg);                              % AutoImportFileLog = true (default)
stop(tg, AutoImportFileLog=false);     % skip file-log import
```

`stop` also **unloads the application** from the target computer: after it returns, `isLoaded(tg, app)` is `false`, so the next run cycle must call `load(tg, app)` again before `start(tg)`. After stop, the runtime deletes the `currParamSet` file on the target computer (parameter-set state from the run). With `AutoImportFileLog=true`, file logs from the run are pulled to the development computer workspace; with `false`, they remain on the target computer until the next `start` clobbers them.

## Auto-Connect in `start` and `stop`

Both `start.m` and `stop.m` call `connect(this)` if the target computer is not already connected. In practice this means a script can construct `tg = slrealtime;` and skip straight to `load`/`start` without an explicit `connect`. The skill's Workflow recommends the explicit `connect` anyway because it makes the connection step visible to the user and gives a clean failure point if the target computer is unreachable.

## Where the `.mldatx` Lives

| Location                                         | When                            |
|--------------------------------------------------|----------------------------------|
| `<model build folder>/<model>.mldatx`            | After `slbuild`                  |
| Path returned by `which("<app>")`                | What `install` and `load` resolve |
| `~/.slrt/applications/<app>/` on the target computer | After `install` or `load`        |
| Loaded into target runtime memory                | After `load`                     |

## Common Failure Modes

| Failure                                                         | Fix                                                  |
|-----------------------------------------------------------------|------------------------------------------------------|
| `slbuild` fails with code-gen errors                            | Model not configured for Simulink Real-Time — run the `simulink-configure-real-time-model` workflow. |
| `slbuild` fails for a shipping Simulink Real-Time example                     | Repair Simulink Real-Time/Speedgoat installation or toolchain state before editing the user's model. |
| `speedgoat.tlc` cannot be found                                 | Verify Speedgoat I/O Blockset installation and path. |
| Missing headers, target support files, or `slrtssd.raw`         | Verify the Simulink Real-Time target support package and post-install setup. |
| External library is `.dll` or `.lib`                            | Rebuild the library for the target RTOS/toolchain; modern Simulink Real-Time targets use target-side `.so` or `.a` libraries. |
| `load` fails on STF mismatch                                    | Reconfigure model STF in `simulink-configure-real-time-model` and rebuild. |
| `load` or file transfer fails after a successful build          | Treat as target connection, firewall, FTP/SFTP, or target filesystem issue; route to `simulink-configure-real-time-target`. |
| `load` fails because an app is already running                  | Call `stop(tg)` first.                               |
| `start` fails because no app is loaded                          | Call `load(tg, app)` first.                          |
| `start` fails because the app is already running                | Skip the redundant `start`, or `stop` then `start`.  |
| Target computer unreachable / `connect(tg)` hangs               | See `simulink-configure-real-time-target`.                      |

----

Copyright 2026 The MathWorks, Inc.

----
