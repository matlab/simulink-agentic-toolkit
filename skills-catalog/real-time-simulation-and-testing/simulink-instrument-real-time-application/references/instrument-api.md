# `slrealtime.Instrument` Reference

`slrealtime.Instrument` is the capture object for a Simulink Real-Time application. A Simulink Real-Time instrument defines a runtime data-collection path for application signals. An instrument carries a list of signals to acquire, optional capture options (decimation, bus element), and gets added to a target computer with an intended destination — file log, Simulation Data Inspector, or MATLAB callback. This file is the field-by-field reference for using the Instrument object. The Workflow's Steps 5–11 reference this file.

## API Signature Reference

These are the **only** forms the skill uses. If a form is not here, in `destinations.md`, or in `canvas-prep.md`, do not use it — SKILL.md's Never table lists the invented forms to refuse. Method calls accept dot-form or function-form interchangeably: `addSignal(inst, "Sig")` equals `inst.addSignal("Sig")`.

| Operation | Exact form |
|---|---|
| Test-point (survive code-gen) | `model_edit` → `configure` on `blk_X.yN -> blk_Y.uM` with `TestPoint: "on"` |
| Streaming canvas badge | `model_edit` → `configure` on the same signal with `DataLogging: "on"` |
| Verify either flag | `model_query_params` on the signal target |
| Construct (bound to `.mldatx`) | `inst = slrealtime.Instrument("model.mldatx");` |
| Bind / re-validate later | `unavail = validate(inst, "model.mldatx");` |
| Add by signal label | `addSignal(inst, "SigGen");` |
| Add multiple by label | `addSignal(inst, ["SigA", "SigB"]);` |
| Add by block path + outport index | `addSignal(inst, "model/Gain", 1);` |
| Add by block path + state name | `addSignal(inst, "model/Integrator", "x");` |
| Add with options | `addSignal(inst, "SigA", "Decimation", 5);` |
| Bulk-add — streaming-badged | `addInstrumentedSignals(inst);` |
| Bulk-add — File Log block signals | `addFileLogSignals(inst);` |
| Remove a signal | `removeSignal(inst, "SigGen");` |
| Register MATLAB-bucket handler | `connectCallback(inst, @onData);` |
| Read a signal inside the handler | `[t, d] = getCallbackDataForSignal(srcInst, evt, "SigA");` |
| Copy / persist | `inst2 = copy(inst);` / `txt = generateScript(inst);` |
| Attach / list / detach | `addForXXX` / `getAllForXXX` / `removeForXXX` / `removeAllForXXX` on `tg.Instruments`, where `XXX` is `FileLog`, `SDI`, or `MATLAB` — see `destinations.md` |
| Interactive control | `view(tg.Instruments)` opens the Instrument Viewer |

## Construction

```matlab
inst = slrealtime.Instrument(application);
```

| Argument      | Form                                              | Resolution                                                                |
|---------------|---------------------------------------------------|---------------------------------------------------------------------------|
| `application` | `'app'` / `'app.mldatx'` / `'c:\…\app.mldatx'`    | Resolves via `which()`; verifies the file exists; reads the built application |

After construction, the read-only properties `Application` and `ModelName` are populated. Signals added later are validated against the built application.

A no-argument call `inst = slrealtime.Instrument()` constructs an unbound instrument — useful when populating signals before the `.mldatx` is known. Bind later with `validate(inst, application)`.

## Public Properties

Settable:

| Property              | Type    | Default  | Purpose                                                                       |
|-----------------------|---------|----------|-------------------------------------------------------------------------------|
| `Name`                | char    | `''`     | Identifies the instrument in target listings (`getAllForFileLog`, etc.).      |
| `Enable`              | logical | `true`   | When `false`, the instrument is attached but quiescent.                       |
| `AxesTimeSpan`        | double  | `Inf`    | Live-axes time range, in seconds. `Inf` = display all data.                   |
| `AxesTimeSpanOverrun` | char    | `scroll` | `scroll` or `wrap` — behavior when the axes time exceeds `AxesTimeSpan`.      |

Read-only:

| Property         | Set by                    | Notes                                 |
|------------------|---------------------------|---------------------------------------|
| `Application`    | Constructor or `validate` | Full path to the `.mldatx`.           |
| `ModelName`      | Constructor or `validate` | Read from the application's metadata. |

The four settable properties above are the entire public, settable surface. You can also read/assign them functionally with `get(inst)` / `set(inst, "Name", value)`, and duplicate a fully-configured instrument (same signals, same options, fresh object) with `inst2 = copy(inst)` — handy when you want the same signal set in two buckets (attach `inst` to one, `copy(inst)` to the other), since one instrument cannot occupy two buckets at once.

## `addSignal`

```matlab
addSignal(inst, signal)
addSignal(inst, signal, port)
addSignal(inst, signal, varargin)
```

### Argument Shapes

| Form                                       | Selects                                     |
|--------------------------------------------|---------------------------------------------|
| `addSignal(inst, "SigGen")`                | Signal by signal-line label                 |
| `addSignal(inst, ["SigA", "SigB"])`        | Multiple named signals                      |
| `addSignal(inst, "model/Gain", 1)`         | Block path + outport index (1-based)        |
| `addSignal(inst, "model/Integrator", "x")` | Block path + state name                     |
| `addSignal(inst, {"a/b/c", "ref/d"})`      | Cell of breadcrumbs (model-reference path)  |

### Name-Value Parameters

The documented `addSignal` name-value parameters are:

| Name         | Type                     | Default | Purpose                                                                |
|--------------|--------------------------|---------|------------------------------------------------------------------------|
| `Decimation` | integer 1 through 256    | `1`     | Capture every Nth sample. Defaults are silent — surface to the user when set. |
| `BusElement` | char / string            | `''`    | When the source is a nonvirtual bus, name of the leaf element to capture. |

`Decimation` must be an integer from `1` through `256`. A `0`, negative, non-integer, or value greater than `256` errors with *"The value of 'Decimation' is invalid."* (`slrealtime:instrument:InvalidDecimation`). Passing an unrecognized name-value pair is rejected as *"Invalid input arguments for Instrument object."*.

### Bus Leaf Capture — `BusElement`

`BusElement` is only for capturing a leaf inside a bus and only resolves on **non-virtual** buses. Do not treat whole-bus streaming as unsupported solely because the bus is virtual. For virtual-vs-non-virtual checks and user-facing options, see `references/bus-elements.md`.

**Array of buses:** When the source signal is an array of buses, `BusElement` must be prefixed with `(x).` where `x` is the 1-based array index. For example, `"(2).signal1.signal2"` selects leaf `signal1.signal2` from the 2nd element of the array. If the user specifies the array element up front, format `BusElement` as `"(N).leafPath"` directly. If the user does not specify an index, attempt `addSignal` with the leaf path alone — the runtime will throw warning `BusElementRequiresDims` if a dimension prefix is needed, or `BusElementInvalidDims` if the supplied prefix is invalid. Handle these reactively by asking the user for the correct array index and retrying. See `references/bus-elements.md` for the full treatment.

### Signal Types That Cannot Be Logged by Name

Some signal types **cannot be logged or streamed by name** in the real-time application. `validate` reports them unresolved:

- **Bus leaf selections using `BusElement` on virtual buses** — see `references/bus-elements.md`.
- **Signals Simulink optimized away** via *Signal storage reuse* or *Block reduction*. The fix is a **test-point** on the source port during canvas preparation — the output of an optimized-away block is replaced by its input signal, so test-pointing forces it back.
- **Complex or multiword data types.** This is a **hard limit** — there is no test-point rescue. If the user needs a complex signal, split it into real/imaginary parts upstream (model edit).
- **Blocks whose name is only spaces** — Give the block an alphanumeric name, rebuild, reconnect.

Only the optimized-away case is fixable by test-pointing; the others require a model change or are not supported at all.

### Validation at Add Time

When the instrument is bound to an application, every `addSignal` call also validates the signal against the built application. A signal that cannot be resolved produces a warning of the form *"Unable to instrument 'SigGen': Unable to find signal 'SigGen' in application"* (the signal is still added so `validate` can report it).

## Bulk-Add

```matlab
addInstrumentedSignals(inst);   % signals with the live-streaming badge
addFileLogSignals(inst);        % signals connected to File Log blocks
```

These two methods find **different** things:

- `addInstrumentedSignals` — finds signals carrying the streaming badge, i.e. those whose `DataLogging` signal property is `"on"` (see `canvas-prep.md`).
- `addFileLogSignals` — finds signals connected to **File Log blocks** in the model.

A common failure mode is calling the wrong one for what the model actually contains — the result is an empty signal list, not an error. Confirm which of the two the user's model is set up for.

Both **mutate `inst` in place and return nothing**. Do not assign the result — `sigs = addInstrumentedSignals(inst)` errors with "Too many output arguments". To see what a bulk add picked up, count the `addSignal` lines in `generateScript(inst)`; there is no public `Signals` property to inspect.

## Iteration and Conditional Subsystems — Logging Timing

`slrealtime.Instrument` samples signals per task step, not at the moment a block executes. This is fine for normal subsystems but produces **wrong data** in two cases:

| Subsystem type                          | Symptom with `slrealtime.Instrument`                                                  |
|-----------------------------------------|--------------------------------------------------------------------------------------|
| Conditional (Enabled / Triggered)       | Signal is logged **every task step**, not only when the subsystem executes. Results contain redundant samples (held value while disabled), and post-processing has to filter them out. |
| For-Iterator / While-Iterator           | Only the **final** iteration's value is logged per task step. Intermediate iterations are lost. |

The fix is the **File Log block** — a model-canvas block, not an instrument. Because it is wired into the model, it logs each sample at the point the block executes, so it captures the right gating in conditional subsystems and one sample per iteration in iteration subsystems. The docs note the File Log block "supports conditional block execution semantics" for exactly this reason. Trade-off: the File Log block is a model edit.

### When to recommend the File Log block over `slrealtime.Instrument`

- The same signals should be logged every time the application runs, regardless of which instruments are attached at runtime.
- The saved model itself should record that specific signals are written to target-side disk.
- The signal lives inside an Enabled or Triggered subsystem and the user wants the gating preserved.
- The signal lives inside a For-Iterator or While-Iterator subsystem and the user wants per-iteration values, not just the last iteration.

### When `slrealtime.Instrument` is correct for file-logs

- You need to add or remove signals for file logging without modifying the model
- The logging configuration is temporary or exploratory in nature
- You want to dynamically add to a deployed application to capture signals on-disk post-build

Signals connected to File Log blocks are what `addFileLogSignals` finds; they are **not** picked up by `addInstrumentedSignals` (which looks for the streaming badge). See `canvas-prep.md`.

## Removal

```matlab
removeSignal(inst, "SigGen");
removeSignal(inst, "model/Gain", 1);
removeSignal(inst, signalStruct);                    % from validate() output

removeCallback(inst, hCallback);                     % detach a connectCallback handler
```

Both methods error if the instrument is currently attached (MATLAB reports that the instrument has been added to a target computer). Detach (`removeForFileLog` / `removeForSDI` / `removeForMATLAB`) before mutating.

## Validation

```matlab
unavail = validate(inst, "myModel.mldatx");
```

Re-resolves the instrument's signals against the supplied application. Returns a fresh `slrealtime.Instrument` holding every signal that **could not** be resolved. If it comes back with no signals, everything resolved cleanly.

Pass `''` to clear the application binding.

After rebuilding the model, reconstruct the instrument against the new `.mldatx` rather than re-validating in place — the in-memory instrument was resolved against the previous build, and signal definitions may have shifted.

## Data Access

### Push (callback-style)

```matlab
connectCallback(inst, @onData);

function onData(srcInst, evt)
    [t, d] = getCallbackDataForSignal(srcInst, evt, "SigGen");
    % t is a time column, d is the data column for "SigGen"
end
```

Register `connectCallback` when routing to MATLAB (`addForMATLAB`) for per-update delivery.

The callback fires on every batch of samples delivered from the target computer. This is the MATLAB-bucket delivery path this skill uses.

## Persistence — `generateScript`

```matlab
txt = generateScript(inst);
writelines(txt, "createMyInstrument.m");
```

Returns (as a cell array of lines) the M-code that recreates the instrument — construction, every `addSignal`, and every connection. This is the canonical persistence path for an instrument across sessions; instruments are not stored in the SLX.

The generated script begins with a `%% Create the Instrument` section marker.

## Example — Single Signal to File Log Instrument


```matlab
objTarg = slrealtime;
connect(objTarg);

model = "slrt_ex_osc";
openExample(model);
% Model configuration (system target file, solver) is owned by
% simulink-configure-real-time-model; build is owned by
% simulink-run-real-time-application. Assume both are already done.
slbuild(model);

mldatxname = "slrt_ex_osc.mldatx";
objTargInst = slrealtime.Instrument(mldatxname);
objTargInst.Name = "TargetInstrument";
addSignal(objTargInst, "SigGen");

addForFileLog(objTarg.Instruments, objTargInst);
```

## Example — Bulk-Add Badged Signals to SDI

```matlab
inst = slrealtime.Instrument("myModel.mldatx");
inst.Name = "BadgedToSDI";
addInstrumentedSignals(inst);

addForSDI(tg.Instruments, inst);
```

## Example — Callback Delivery to MATLAB

```matlab
inst = slrealtime.Instrument("myModel.mldatx");
inst.Name = "MatlabStream";
addSignal(inst, "SigA");
addSignal(inst, "SigB", "Decimation", 5);
connectCallback(inst, @onData);       % register before attaching

addForMATLAB(tg.Instruments, inst);
% ... start the application (see simulink-run-real-time-application) ...

function onData(srcInst, evt)
    [tA, dA] = getCallbackDataForSignal(srcInst, evt, "SigA");
    plot(tA, dA);
    drawnow limitrate;
end
```

The callback fires per batch of samples the target computer delivers. Register it **before** `addForMATLAB` — the instrument locks on attach, and `connectCallback` errors on a locked instrument.

## Common Failure Modes

| Error / symptom                                                                    | Cause                                                                                        | Fix                                                                                                                                                                    |
| ---------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "Unable to modify Instrument that has been added to a target computer"             | Mutating signals while attached to `tg.Instruments`                                          | Detach (`removeForXXX`), edit, re-attach.                                                                                                                              |
| "Unable to instrument 'Sig': Unable to find signal 'Sig' in application" (warning) | Signal not in the built application — built without a test-point                             | Test-point on the source port, rebuild, reconstruct the instrument. The existing `.mldatx` cannot be repaired. See `canvas-prep.md`.                                   |
| "The value of 'Decimation' is invalid."                                            | `Decimation` is outside the integer range `1` through `256`                                  | Pass an integer from `1` through `256`.                                                                                                                                |
| "Invalid input arguments for Instrument object"                                    | Unrecognized name-value parameter (only `Decimation`, `BusElement` are documented)           | Check the name against the parameter table above.                                                                                                                      |
| Empty signal list after `addInstrumentedSignals`                                   | Model has no streaming-badged signals (its signals are connected to File Log blocks instead) | Use `addFileLogSignals`, or badge signals on the canvas and rebuild.                                                                                                   |
| `validate` returns unresolved signals                                              | The named signals are not in the built `.mldatx`                                             | Test-point/badge on the canvas and rebuild — there is no in-place repair.                                                                                              |
| `validate` unresolved, but the signal *is* test-pointed                            | Signal is a complex/multiword type, a virtual-bus `BusElement` leaf, or its source block is unnamed | Read the warning text returned by `validate`; these cases are not fixed by test-pointing. See "Signal Types That Cannot Be Logged by Name" and `references/bus-elements.md`. |
| Captured data is from the wrong build                                              | `.mldatx` was rebuilt after the instrument was constructed                                   | Reconstruct the instrument against the new `.mldatx`.                                                                                                                  |

----

Copyright 2026 The MathWorks, Inc.

----
