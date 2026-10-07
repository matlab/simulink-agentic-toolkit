# Instrument Destinations — File Log / SDI / MATLAB

`tg.Instruments` is the instrument manager attached to the target object. It owns three independent buckets — file log, Simulation Data Inspector, and MATLAB. Each bucket exposes a symmetric `addForXXX` / `getAllForXXX` / `removeForXXX` / `removeAllForXXX` API. An instrument may be in **only one bucket at a time**. The Workflow's Step 2 references this file.

## Buckets at a Glance

| Bucket   | API surface                                                                       | Data path                                              | When to use                                                                                                                                                                                               |
| -------- | --------------------------------------------------------------------------------- | ------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| File log | `addForFileLog` / `getAllForFileLog` / `removeForFileLog` / `removeAllForFileLog` | Target computer → on-target file → development computer (auto-import on `stop`) | Post-run analysis, high-rate capture, long runs, and runs where the development computer will not remain connected |
| SDI      | `addForSDI` / `getAllForSDI` / `removeForSDI` / `removeAllForSDI`                 | Target computer → network → Simulation Data Inspector           | Live operator monitoring, visual inspection                                                                                                                                                               |
| MATLAB   | `addForMATLAB` / `getAllForMATLAB` / `removeForMATLAB` / `removeAllForMATLAB`     | Target computer → network → `connectCallback` handler in MATLAB | Custom MATLAB scripts, automated reactions                                                                                                                                                                |

## Where the Data Appears

Once attached and the application runs, capture is automatic:

| Destination | Where the data appears |
|---|---|
| File log | Imported to the Simulation Data Inspector by `stop(tg)` (default `AutoImportFileLog=true`) |
| SDI | The Simulation Data Inspector (`Simulink.sdi.view`) |
| MATLAB | The registered `connectCallback` handler, per batch of samples |

For interactive control, offer the Instrument Viewer: `view(tg.Instruments)`.

## Attaching While the Application Runs

SDI and MATLAB instruments may be attached while the application runs; streaming briefly pauses for validation, then resumes. File-log instruments can also attach dynamically, but only while recording is inactive — see the File Log constraints below.

## Decision Tree

1. **Do you need the data after the run, or during?**
   - After → file log.
   - During → SDI or MATLAB.
2. **During the run: do you need the data in MATLAB code, or just visually?**
   - MATLAB code → `addForMATLAB` with a `connectCallback` handler.
   - Visual only → `addForSDI`.
3. **Do you need both during *and* after?**
   - Construct two instruments (one per bucket). They can carry the same signals — `copy(inst)` duplicates a configured instrument so you don't rebuild the signal list twice.

## File Log — `addForFileLog`

```matlab
addForFileLog(tg.Instruments, inst);
```

### Constraints

- The application may be running only when recording/logging is inactive. If recording is active, call `stopRecording(tg)`, attach, then `startRecording(tg)`; this creates a recording gap.
- If the running application contains a File Log Enable block, surface that the block controls file logging state. Attach file-log instruments only when file logging is disabled, or stop the application first.
- Once attached, the instrument is locked. Mutating its signal list errors that the instrument has been added to a target computer.
- Capture is bounded by on-target storage. Long runs and high-rate signals can pressure the file-log buffer or local disk — surface the trade-off when adding hundreds of signals or sub-millisecond decimation.

### Data Retrieval

File-log data is imported on stop:

```matlab
stop(tg);                                  % AutoImportFileLog=true is the default
stop(tg, "AutoImportFileLog", false);      % skip — read manually later
```

When `AutoImportFileLog` is `true`, the logs are imported into the Simulation Data Inspector on stop. When `false`, they remain on the target computer until you import them manually (`import(tg.FileLog)`) or the next `start` clobbers them. (Exporting log data to the base workspace is a separate option, `ExportToBaseWorkspace`.)

### Inspection

```matlab
attached = getAllForFileLog(tg.Instruments);
for i = 1:numel(attached)
    fprintf("%s\n", attached(i).Name);
end
```

### Detach

```matlab
removeForFileLog(tg.Instruments, inst);    % single instrument
removeAllForFileLog(tg.Instruments);       % every attached file-log instrument — Ask First
```

## SDI — `addForSDI`

```matlab
addForSDI(tg.Instruments, inst);
```

### Constraints

- SDI streaming is **lossy under heavy load** — the runtime drops samples to keep the stream live. Use file log for lossless capture.
- The Simulation Data Inspector must be open or available to receive data: `Simulink.sdi.view`.
- SDI is the pure-streaming path — no MATLAB observers. If the user wants MATLAB code to receive the data (via a `connectCallback` handler), the route is `addForMATLAB`, not `addForSDI`.

### Data Retrieval

Live in the Simulation Data Inspector. The runtime pushes samples to SDI as they arrive.

### Inspection / Detach

```matlab
attached = getAllForSDI(tg.Instruments);
removeForSDI(tg.Instruments, inst);
removeAllForSDI(tg.Instruments);           % Ask First
```

## MATLAB — `addForMATLAB`

```matlab
addForMATLAB(tg.Instruments, inst);
```

### Constraints

- The instrument must carry a `connectCallback(inst, fn)` registration before it is attached. Without a callback, samples arrive on the target computer but have nowhere to land in MATLAB. Register the callback **before** `addForMATLAB` — the instrument locks on attach.

### Callback Delivery

```matlab
addSignal(inst, "SigGen");
connectCallback(inst, @onData);

addForMATLAB(tg.Instruments, inst);
% ... start ...

function onData(srcInst, evt)
    [t, d] = getCallbackDataForSignal(srcInst, evt, "SigGen");
    % process t, d
end
```

The callback fires on every batch of samples delivered from the target computer.

### Inspection / Detach

```matlab
attached = getAllForMATLAB(tg.Instruments);
removeForMATLAB(tg.Instruments, inst);
removeAllForMATLAB(tg.Instruments);        % Ask First
```

## Shared Lock Semantics

Every `addForXXX` call locks the instrument:

- The instrument is locked to the target computer it was attached to.
- `addSignal`, `removeSignal`, `connectCallback`, and `removeCallback` all error while locked (MATLAB reports that the instrument has been added to a target computer).
- `inst.Enable` *can* still be toggled on a locked instrument — that is the supported way to silence an attached instrument without detaching.

Detach to mutate:

```matlab
removeForFileLog(tg.Instruments, inst);
addSignal(inst, "AnotherSig");
addForFileLog(tg.Instruments, inst);
```

## Cross-Bucket Rules

| Rule                                                       | Behavior                                                         |
|------------------------------------------------------------|------------------------------------------------------------------|
| Same instrument in two buckets                             | Not supported. Detach from one before attaching to another, or `copy(inst)` and attach the copy to the second bucket. |
| Two instruments in the same bucket, same signal            | Allowed. Both will record the signal independently.              |
| `removeAllForXXX` while another bucket has instruments     | Only the named bucket is affected.                               |

## Default SDI Instrument

When an application starts and no user instrument is attached, Simulink Real-Time creates a transient default SDI instrument from the signals marked for streaming on the Simulink canvas (those whose `DataLogging` signal property is `"on"`). The default instrument is torn down when the application stops and recreated on the next start.

This behavior is useful for quick SDI visibility, but it can slow startup or flood SDI when many signals are badged. Attaching an explicit manual instrument, including an empty instrument, prevents the default path; only the attached instruments are used.

## When the User Says "Stream That Signal"

The phrase is ambiguous between SDI and MATLAB. Default to SDI for "I want to see it live," but disambiguate before building:

- "I want to see it live" → SDI.
- "I want to log it on the target computer and read it later" → file log.
- "I want my MATLAB code to react to it" → MATLAB.
- "I want a chart in my Live Script" → MATLAB (callback writes to a `plot` handle).

## Common Failure Modes

| Error / symptom                             | Bucket   | Cause                                                                                                                                                                             | Fix                                                                                                                         |
| ------------------------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `addForFileLog` rejected                    | File log | Recording/logging is active, or a File Log Enable block is controlling file logging while the app runs | Stop recording, attach, then start recording again and surface the gap; if a File Log Enable block keeps logging active, stop the app or disable logging first. |
| File-log channel empty after the run        | File log | Instrument signal was optimized out at build time or warned as unresolved when added | Check the warning/`validate` output, test-point on the canvas, rebuild, and reconstruct the instrument. The data for the previous run is gone. See `canvas-prep.md`. |
| SDI shows nothing                           | SDI      | No instrument/default stream is attached, signals were not badged, streaming was disabled, or SDI recording/display settings are hiding the run | Verify attached SDI instruments with `getAllForSDI`, verify `DataLogging` badges or default-instrument behavior, then open SDI (`Simulink.sdi.view`) if the data path is present. |
| MATLAB callback never fires                 | MATLAB   | No callback registered before attach                                                                                                                                              | Call `connectCallback` before `addForMATLAB`.                                                                               |
| Instrument won't accept signal-list changes | Any      | Mutating signals while attached to `tg.Instruments`                                                                                                                               | Detach via `removeForXXX`, edit, re-attach.                                                                                 |

----

Copyright 2026 The MathWorks, Inc.

----
