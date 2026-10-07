# Run-Lifecycle Guardrails — Full Detail

SKILL.md carries the rules themselves, including the table of invented forms to
refuse. This file holds the *reasoning*: why each hallucinated form is wrong, why
each Ask-First gate exists, and the failure mode behind each Never.

## Invented APIs — Why Each Form Is Wrong

The run lifecycle is a small set of verbs (`slbuild`, `install`, `load`, `start`,
`stop`) on a target object, and agents routinely over-generalize it into a
deploy/run/kill API that does not exist. Every form below is a **hallucination**.
The same list appears in SKILL.md; the middle column lives only here.

| Invented form | Why it is wrong | Use instead |
|---|---|---|
| `tg.run(app)` / `tg.execute(app)` / `tg.launch(app)` | The target has no run/execute/launch verb, and `start` never takes an application — the *loaded* application is what runs | `load(tg, app)` then `start(tg)` |
| `start(tg, app, ...)` | `start` takes the target as its only positional argument; passing `app` shifts every name-value pair by one and errors | `start(tg, ...)` |
| `tg.deploy(app)` | There is no single deploy verb; upload and load are separate stages | `install(tg, app)` to upload only; `load(tg, app)` to install **and** load |
| `load(tg, app, "SkipInstall", true)` | `load` has **no** documented name-value pairs. If the app is already installed, plain `load(tg, app)` is already the no-upload path | `load(tg, app)` |
| `tg.unload()` / `tg.kill()` / `tg.terminate()` | No unload verb exists; `stop` both stops **and** unloads | `stop(tg)` |
| `pause(tg)` / `tg.pause()` / `tg.suspend()` / `tg.freeze()` | `pause` exists only on `tg.Stimulation`. The application either runs or it does not — there is no target-level pause, and pausing stimulation does not pause the application clock | `tg.Stimulation.pause(selector)`, with the caveat stated, or stop the app |
| `stop(tg, "myApp")` / `stop(tg, app)` | `stop` takes no application name — the loaded app is implied. The only documented second argument is `AutoImportFileLog` | `stop(tg)` |
| `stop(tg, false)` | The **published documentation shows this positional form, and the runtime rejects it.** Verified against R2026a: only the name-value form is accepted | `stop(tg, AutoImportFileLog=false)` |
| `start(tg, "Duration", N)` / `"Timeout"` / `"MaxRuntime"` / `"StopAfter"` | Only `StopTime` sets run duration; these are not among the 8 documented `start` parameters | `start(tg, "StopTime", N)` — see `start-options.md` |
| `start(tg, "Verbose", ...)` / `"Verbosity"` | The logging control is `LogLevel` | `start(tg, "LogLevel", "debug")` |
| `tg.getApps()` / `tg.listInstalled()` / `tg.listApplications()` | No listing method exists on the target object | `getInstalledApplications(tg)` |
| `tg.Stimulation.startAll()` / `stopAll()` | There is no `*All` variant; breadth is expressed by the `"all"` selector | `tg.Stimulation.start("all")` |
| `tg.Stimulation.swapData()` / `loadData()` / `replaceData()` / `updateData()` | The only data-replacement method is `reloadData` | `tg.Stimulation.reloadData(selector, source)` |
| `tg.Stimulation.reset()` / `clear()` / `unload()` / `restore()` / `loadDefault()` | Stimulation has no reset. The recorded defaults live **inside the `.mldatx`**, so the only way back to them is to reload the application | `load(tg, app)` again |

## Ask-First Gates — Why Each Exists

- **`slbuild` when a current `.mldatx` is loaded or running.** The build is
  destructive of the previous artifact. Rebuilding while a target computer runs
  the old app leaves the user with a running application whose source artifact no
  longer exists on the host, and the next `load` will silently swap behavior.
- **Non-default `LogLevel` (especially `debug`/`trace`).** Log volume rises
  sharply and can perturb timing on a loaded target.
- **`AutoImportFileLog=false`.** File logs stay on the target computer. With
  `FileLogMaxRuns=1`, the **next run overwrites them** through the FIFO retention
  policy, so the data is gone with no error.
- **`removeApplication` / `removeAllApplications`.** Irreversible without a
  rebuild and re-install, and the artifact may be the only copy on the target.
- **`setparam` on hardware.** Changing plant or controller behavior on a running
  physical rig has safety consequences. Surface the block path, parameter name,
  and value before writing.
- **`loadParamSet` / `setDefaultParamSet`.** One call can change many tunable
  values at once, and the prior values are not captured unless the user saved a
  set first.

## Never — The Failure Mode Behind Each Rule

- **`start(tg)` before `load(tg, app)`** — `start` requires a loaded application
  and errors. This is also the trap after a `stop`: `stop` unloads, so a second
  run needs a fresh `load` (see below).
- **`start(tg)` while the app is running** — the runtime refuses a second run
  rather than restarting, so an agent that treats `start` as idempotent reports
  success on an error.
- **`load(tg, app)` while the app is running** — `load` refuses to clobber a
  running application. When the app is loaded but *not* running, `load` stops it
  first; surface that before invoking so the user is not surprised by the stop.
- **Forgetting that `stop` unloads** — after a successful `stop`,
  `isLoaded(tg, app)` returns `false`. Agents that chain `stop` → `start` for a
  second run fail. The runtime also deletes the target's `currParamSet` file on
  stop, so unsaved tuning is lost.
- **`Stimulation.reloadData` with an unchecked source** — a source whose
  datatypes or dimensions do not match the application's recorded root-inport
  metadata is rejected at best and misinterpreted at worst. Check the source
  against that metadata before the call; this is the agent's check, not a
  question for the user.
- **`Stimulation.reloadData` while that entry's stimulation is running** — the
  runtime rejects the call with "Stimulation of inports not yet stopped". This
  holds **even on a freshly loaded application** that has never been started,
  which is the counter-intuitive part: stop the entry first regardless.
- **`Stimulation.start(<parameter>)` before `reloadData` registered it** — ROOTIO
  and PLAYBACK entries ship inside the built `.mldatx`; PARAMETER entries do
  **not**. Without a registered entry the call is a **silent no-op** and
  `getStatus` returns no metadata, so nothing signals the failure.
- **Assuming an inlined literal is reachable via the `reloadData` parameter
  form** — a Signal Generator amplitude (or any block literal) that was inlined
  at code generation is not in the `.mldatx` as a tunable. No amount of runtime
  API recovers it; the model must change first.
- **Treating Stimulation as the default for parameter tuning** — Stimulation is
  for *time-varying schedules*. Reaching for it on a one-time change adds a
  registration step, a stop/reload dance, and a failure surface that `setparam`
  does not have.
- **Promising gap-free logging from repeated `startRecording`/`stopRecording`** —
  each stop/start boundary creates a gap and a separate imported run. A user told
  the capture is continuous will silently analyze discontinuous data.
- **Editing `.mldatx` contents by hand** — it is a build artifact with internal
  consistency between the generated code, signal definitions, and stimulation
  metadata. Rebuild instead.
- **Patching model STF or solver settings here** — that is
  `simulink-configure-real-time-model`'s scope. Fixing it in passing hides a
  model-configuration problem that will recur on the next build.

## Why the Pre-`slbuild` STF Check Is Not Optional

A model's name is not evidence of its configuration. The `slrt_` prefix on the
shipped examples makes this especially tempting, and agents skip the check on any
model whose name mentions real-time. An unconfigured model either fails the build
with a toolchain-shaped error that invites the wrong fix (installing a compiler),
or builds against `grt.tlc`/`ert.tlc` and then fails at `load` with an STF
mismatch after a long build. Reading `SystemTargetFile` first costs one call.

Relatedly: **there is no host C compiler to check for.** The cross-compiler
`slbuild` uses ships with the target support software — the Speedgoat Add-On for
Speedgoat hardware, or the Simulink Real-Time support package for a Simulink
Real-Time Linux device. A compiler or toolchain error from `slbuild` means model
configuration or missing target support software — never a missing host
compiler.

----

Copyright 2026 The MathWorks, Inc.

----
