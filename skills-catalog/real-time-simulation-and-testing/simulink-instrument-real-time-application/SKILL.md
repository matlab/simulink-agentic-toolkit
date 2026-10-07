---
name: simulink-instrument-real-time-application
description: Set up signal capture for a Simulink Real-Time application using `slrealtime.Instrument`. Use when choosing which signals a real-time application captures and where the data goes — test-pointing or canvas-badging a signal before build (`TestPoint`, `DataLogging`), constructing an Instrument from an `.mldatx`, calling `addSignal`, `addInstrumentedSignals`, `addFileLogSignals`, `validate`, `connectCallback`, `copy`, or `generateScript`, attaching an instrument to `tg.Instruments` via `addForFileLog`, `addForSDI`, or `addForMATLAB`, setting up live-streaming signals, dynamic file-log workflows, or persisting an instrument as M-code. Selects and routes signals only — not for configuring, building, running, or connecting applications onto targets.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Instrumenting Simulink Real-Time Applications

Use this skill to **set up signal capture** for a Simulink Real-Time application via
`slrealtime.Instrument` — a runtime-configurable object that attaches to a target computer to
stream, visualize, or file-log data from a running application. Instruments are **dynamic**: they
are not stored in the SLX, and `generateScript(inst)` is the canonical persistence path.

> **Release compatibility:** designed and validated for MATLAB R2026a and later. The
> `addForFileLog`/`addForSDI`/`addForMATLAB` bucket API was introduced in R2026a. For earlier
> releases, use that release's documentation.

## When to Use

- Setting up signal capture for a Simulink Real-Time application via `slrealtime.Instrument`
- Test-pointing or badging signals **before build** so they survive code-gen and are picked up by
  `addInstrumentedSignals()`
- Adding signals by label, block path + port, block path + state name, or canvas badge
- Choosing a destination and attaching to the target (`addForFileLog`/`addForSDI`/`addForMATLAB`)
- Validating an instrument against an `.mldatx`, or configuring callback-driven MATLAB delivery
- Persisting an instrument as M-code, or detaching instruments from the target

## When NOT to Use

If the task crosses one of these lines, **load the named skill first**, then come back.

- Target IP, credentials, RTOS, `connect(tg)` troubleshooting, `status(tg)`, `reboot(tg)` →
  `simulink-configure-real-time-target`
- Model STF, fixed-step solver, Simulink Real-Time options → `simulink-configure-real-time-model`
  (`SLRTFileLogMaxRuns` only caps retained runs; it selects no signals)
- `slbuild`, `load(tg, app)`, `start`, `stop`, `tg.Stimulation`, `getparam`/`setparam`,
  `startRecording`/`stopRecording`, `import(tg.FileLog, app)`, `slrealtime.exportRun` →
  `simulink-run-real-time-application`. This skill picks *which* signals and *where*; it never
  starts or stops capture.
- UI binding (`connectScalar`, `connectLine`, `connectXYPlot`) — the App Designer path, not this
  skill

## Prerequisites

- MATLAB **R2026a or newer**, with Simulink Real-Time installed (`ver` lists it)
- Support package for the hardware: **Speedgoat** → Speedgoat Add-On; **Linux x86-64 devices** →
  Embedded Coder Support Package for Real-Time Linux (requires Embedded Coder)
- Model configured for Simulink Real-Time and a fresh `.mldatx` in the build folder
- A configured, reachable target computer

## API Forms

Use **only** the forms in `references/instrument-api.md` § API Signature Reference (instrument
methods, `addSignal` shapes, model-tool calls for canvas prep) and `references/destinations.md`
(bucket methods on `tg.Instruments`). Anything else is invented — the Never table in Guardrails
lists the forms agents produce most often. `addSignal` takes only two Name-Value parameters,
`Decimation` and `BusElement`; the settable properties are `Name`, `Enable`, `AxesTimeSpan`, and
`AxesTimeSpanOverrun`.

## Workflow

Steps 1–4 happen **before** `slbuild` when the canvas must change. Steps 5–11 happen after build.
The run itself is owned by `simulink-run-real-time-application`.

### 1. Identify the Signals to Capture

Decide what to log and which `addSignal` shape expresses it: signal label, block path + outport
index, or block path + state name. If the user gave a block path but no port, use `model_read` to
list the block's output ports and show them.

- **Bus leaf — Ask First.** Gate only when the user wants a leaf *inside* a bus, uses
  `BusElement`, names a Bus Selector path as a leaf source, or asks for "one element" of a bus.
  Whole-bus streaming is **not** gated. Present both remedies from `references/bus-elements.md` —
  convert the source bus to non-virtual and rebuild, or instrument the upstream leaf — and **wait
  for the user to choose**. Probing virtuality is not a substitute for asking.
- **Array of buses:** prefix `BusElement` with `(N).` (1-based). If the user named the element,
  format it directly (`"(2).signal1.signal2"`); otherwise add the leaf path alone, and on
  `BusElementRequiresDims` / `BusElementInvalidDims` **remove the signal**, surface the warning,
  and ask which element. Never guess an index.
- **Cannot be logged by name:** optimized-away signals (fix: test-point, Step 3), complex or
  multiword types (hard limit), source blocks named only with spaces, and `BusElement` on a
  virtual bus. `validate` only **warns**, and `generateScript` still emits the signal — silence is
  not success.
- **Conditional and Iteration subsystems:** the instrument logs **post-step**, so it produces
  wrong data when gating or per-iteration values matter. Use a **File Log block** instead (model
  edit, rebuild — Ask First).

Details: `references/instrument-api.md`, `references/bus-elements.md`.

### 2. Decide the Destination

Each instrument attaches to **one** of three buckets:

| Destination | Use when |
|---|---|
| File log (`addForFileLog`) | Target-side capture for **post-run analysis**, high-rate or long runs, or no development computer attached |
| SDI (`addForSDI`) | **Live operator monitoring** in the Simulation Data Inspector |
| MATLAB (`addForMATLAB`) | **Custom MATLAB code** reacting to samples via a callback |

Decision tree, per-bucket constraints, and the "stream that signal" disambiguation:
`references/destinations.md`.

### 3. Prep the Signal on the Canvas — Before Build (Ask First)

Get block IDs from `model_read`, then set both signal properties in one `model_edit` `configure`
on the **signal** (`blk_X.yN -> blk_Y.uM`); verify with `model_query_params`:

- **`TestPoint: "on"`** — for any signal that *might* be optimized out and will be added by name
  or block path.
- **`DataLogging: "on"`** — for the canvas badge, `addInstrumentedSignals()` pickup, or the
  default SDI instrument.

Both are model edits: ask first, and say that a save and rebuild are needed. There is no rescuing
an optimized-out signal after build. Payload, outport-without-destination exception, and
`DataLoggingSampleTime`: `references/canvas-prep.md`.

### 4. Build the Application (route)

Building is owned by `simulink-run-real-time-application` (`slbuild(model)`). The resulting
`.mldatx` is what the instrument validates against.

### 5. Construct the Instrument

```matlab
inst = slrealtime.Instrument("myModel.mldatx");
inst.Name = "TargetInstrument";
```

Construct one when the user wants a controlled destination, a manual signal list, dynamic file
logging, MATLAB delivery, or to suppress the transient default SDI instrument that otherwise
streams `DataLogging`-badged signals at `start(tg)` (`references/destinations.md`).

### 6. Add Signals

```matlab
addSignal(inst, "SigGen");
addSignal(inst, "myModel/Gain", 1, "Decimation", 10);
addSignal(inst, "myModel/Integrator", "x");
```

`Decimation` is an **integer `1`–`256`**, default 1; anything else errors. State it explicitly when
set.

Bulk-add finds **different** things: `addInstrumentedSignals(inst)` takes streaming-badged
signals, `addFileLogSignals(inst)` takes signals wired to File Log blocks. Both return nothing and
silently add nothing on a mismatch — confirm which the model contains, and check the result by
counting `addSignal` lines in `generateScript(inst)` (`references/instrument-api.md` § Bulk-Add).

### 7. Set Capture Options

Set `Name`, `Enable`, `AxesTimeSpan`, or `AxesTimeSpanOverrun` as needed
(`references/instrument-api.md` § Public Properties). For MATLAB delivery, register the callback
now — **before** attaching:

```matlab
connectCallback(inst, @onData);

function onData(srcInst, evt)
    [t, d] = getCallbackDataForSignal(srcInst, evt, "SigGen");
end
```

### 8. Attach to `tg.Instruments`

```matlab
tg = slrealtime;
connect(tg);
addForFileLog(tg.Instruments, inst);    % or addForSDI / addForMATLAB
```

Once attached the instrument is **locked** — detach, edit, re-attach. SDI and MATLAB instruments
can attach while the application runs. A file-log instrument can too, but **only while recording
is inactive**: route `stopRecording(tg)` / attach / `startRecording(tg)` to
`simulink-run-real-time-application`, and surface the recording gap first
(`references/destinations.md`).

### 9. Hand Off to the Run Lifecycle

`load(tg, app)` and `start(tg, ...)` belong to `simulink-run-real-time-application`. Capture is
automatic while the application runs; tell the user where the data lands
(`references/destinations.md` § Where the Data Appears).

### 10. Persist the Instrument as an M-Script

```matlab
txt = generateScript(inst);
writelines(txt, "createMyInstrument.m");
```

The script is bound to **this build**: after a model rebuild, reconstruct and re-`validate` the
instrument against the fresh `.mldatx`. To keep only SDI streaming choices with the model,
`DataLogging` badges are the saved-model alternative.

### 11. Tear Down

```matlab
removeForFileLog(tg.Instruments, inst);   % one instrument
removeAllForFileLog(tg.Instruments);      % every instrument in the bucket — Ask First
```

## Verification

```matlab
unavail = validate(inst, "myModel.mldatx");
disp(getAllForFileLog(tg.Instruments));   % or getAllForSDI / getAllForMATLAB
```

`validate` returns a fresh instrument holding the signals that **could not** be resolved. Empty
means everything resolved; anything listed is missing from the build — usually a missing
test-point.

## Guardrails

`references/guardrails.md` carries the reasoning behind each rule, the silent-wrong-data traps,
and the hard limits.

**Always:**

- Tell the user the instrument's **workspace variable name and where it was created** (e.g.
  "created in the base workspace as `inst`").
- Apply `TestPoint` and canvas badges **before** `slbuild`.
- Run `validate(inst, mldatx)` before attaching and surface unresolved signals.
- Pick **one** destination per instrument.
- Save constructed instruments with `generateScript()`.
- State `Decimation` explicitly when set — the default of 1 is otherwise silent.
- Reconstruct and re-`validate` the instrument after any model rebuild.

**Ask first:**

- **Bus-leaf capture** — any `BusElement` use, "log one element of this bus", or a Bus Selector
  path naming a leaf. Present **both** remedies and wait. Whole-bus streaming is not gated.
- Setting `TestPoint` or `DataLogging` on a signal — model edits needing a rebuild.
- `removeAllForFileLog` / `removeAllForSDI` / `removeAllForMATLAB` — affects every attached
  instrument, not just the user's.
- Hundreds of high-rate signals — warn about target CPU/SSD for file logging, network and
  development-computer load for streaming.
- Reconfiguring an attached instrument — it is locked; detach first.
- Attaching a file-log instrument to a running application — surface the recording gap.

**Never invent** function names, properties, Name-Value parameters, or destination methods. Every
left-hand form below is a hallucination agents produce regularly — refuse it and use the
right-hand column.

| Never | Use instead |
|---|---|
| `inst.attach(tg, "filelog")` | `addForFileLog(tg.Instruments, inst)` / `addForSDI` / `addForMATLAB` |
| `inst.signals.add("Sig")` | `addSignal(inst, "Sig")` |
| `inst.start()` / `inst.stop()` | Capture begins with the **application** (`start(tg, ...)`) or with `startRecording` |
| `inst.record()` / `inst.capture()` | Attach to a bucket; capture is automatic |
| `inst.getData()` / `inst.read()` | `connectCallback(inst, @onData)` + `getCallbackDataForSignal` |
| `inst.save()` / `inst.export()` | `generateScript(inst)` + `writelines` |
| `addSignal(..., "SampleRate"/"Period"/"RateLimit", N)` | `Decimation` (integer 1–256), or `DataLoggingSampleTime` on the model |
| `set_param(..., "TestPoint"/"DataLogging", "on")` | `model_edit` → `configure` on the signal `blk_X.yN -> blk_Y.uM` |
| `Simulink.sdi.markSignalForStreaming(port, "on")` | `model_edit` → `configure` with `DataLogging: "on"` |
| Bus-expansion or bulk-add helpers for buses | Add leaves individually — see `references/bus-elements.md` |

`addInstrument` / `removeInstrument` / `getAllInstruments` are **real** target functions, but they
belong to the App Designer / UI-connector path. This skill uses the bucket API. Do not mix the two.

**Also never:**

- Try to rescue an optimized-out signal after build — test-point and rebuild instead.
- Use `BusElement` or capture a bus leaf without the Ask-First gate above.
- Guess an array index for an array-of-buses signal.
- Use `slrealtime.Instrument` for a signal inside a Conditional or Iteration subsystem when gating
  or per-iteration values matter — use a **File Log block**.
- Modify a locked instrument's signal list, or attach one instrument to two buckets.
- Conflate `addInstrumentedSignals()` with `addFileLogSignals()`.
- Embed instrument logic in the SLX — use `generateScript()`.

----

Copyright 2026 The MathWorks, Inc.

----
