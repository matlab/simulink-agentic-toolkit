# Signal Access and Streaming

Use this reference when the user wants to read signal values from a loaded or running Simulink Real-Time application, decide whether `getsignal` is enough, or choose between live streaming and target-side file logging.

## One-Time Signal Reads with `getsignal`

Use `getsignal` for ad hoc reads of a signal value from the loaded or running application:

```matlab
value = getsignal(tg, "myModel/Controller/Gain", 1);
```

Arguments:

- `tg` - Simulink Real-Time target object.
- `blockPath` - path to the block that owns the output port.
- `portIndex` - 1-based output port index.

For signals inside a referenced model, pass a cell array path. The first entry identifies the Model block instance in the top model; the second entry identifies the block path inside the referenced model:

```matlab
value = getsignal(tg, {"topModel/PlantModel", "plantModel/Sensor Out"}, 1);
```

For deeper model-reference nesting, keep the same idea: include the model-reference instance path(s), then the block path inside the referenced model. Use the exact path form exposed by the loaded application metadata or generated Explorer code.

`getsignal` is best for one-time checks and script assertions. It is **not** the right tool for high-rate live monitoring or long-duration capture.

## Finding Signal Paths

Prefer paths produced by Simulink Real-Time tooling over hand-typed guesses:

- In Simulink Real-Time Explorer, a user can select the signal and use generated MATLAB code when available; reuse the exact `blockPath` / model-reference cell array form it emits.
- In Simulink, a user can select the source block or signal line and run `gcbp` as a convenience to get a full block path, then verify it against the loaded application's signal metadata.
- For unnamed lines, identify the source block and output port index rather than relying on display labels.
- For referenced models, confirm whether the path must include the top-model Model block instance. This matters for multi-instance model references because the same referenced-model block path can appear more than once.

If `getsignal` reports that the signal cannot be found, do not guess alternate path strings indefinitely. Re-read the loaded application metadata

## Streaming vs File Logging

Choose the signal-data path by intent:

| Need                               | Use                                                   | Notes                                                             |
| ---------------------------------- | ----------------------------------------------------- | ----------------------------------------------------------------- |
| One-time value check               | `getsignal`                                           | Good for scripts and quick diagnostics.                           |
| Live host-side monitoring          | Streaming / SDI / SL Dashboard / App Designer blocks  | Primary runtime display path for lower-rate visualization; can drop data under load. |
| High-rate or long-duration capture | File Log blocks or file-log instruments               | Target-side capture is more robust; import after recording stops. |

Live streaming shares host-target bandwidth with target management, parameter tuning, and other traffic. It can also overload host-side SDI processing. Treat streaming as a live view, not a lossless recorder.

Instruments can be the mechanism behind either live streaming or file logging. Route setup of `slrealtime.Instrument`, `addForFileLog`, `addForSDI`, and `addForMATLAB` to `simulink-instrument-real-time-application`.

## Streaming Overload Symptoms

Common signs that streaming load is too high:

- Live plots lag, freeze, or show gaps.
- SDI runs miss samples or stop updating while the target computer continues running.
- Parameter tuning or target status calls become sluggish during streaming.
- The Simulink Real-Time System Log reports live-stream overload or dropped streaming data:

```matlab
slog = slrealtime.SystemLog(tg);
messages(slog)
```
- Target computer execution timing gets worse when many high-rate signals are streamed.

## Reducing Streaming Load

Reduce the data rate before adding more host-side tooling:

- Stream fewer signals.
- Stream lower-rate signals or downsampled copies.
- Use a Rate Transition block or equivalent explicit downsample path before streaming high-rate buses.
- Increase `Decimation` on instrumented streamed/logged signals. Decimation keeps one sample out of every N samples, reducing development computer traffic or file-log volume.
- For canvas-badged streaming signals, slow the logged sample time on the source outport when the signal is only needed for situational awareness:

```matlab
set_param(outport, "DataLoggingSampleTime", "0.1");  % log/stream every 0.1 s
```
- Use file logging for full-rate data and stream only a small downsampled subset for live checks.

To reduce SDI host-side recording overhead when the user only needs an oscilloscope-like live view, disable SDI data retention for the MATLAB session:

```matlab
Simulink.sdi.setRecordData(false);
```

This keeps the live view but discards the data afterward. The preference resets to recording data when MATLAB restarts; set it again in scripts that depend on this behavior.

## When to Route to Instrumentation

Route to `simulink-instrument-real-time-application` when the user needs:

- `slrealtime.Instrument`.
- `addForFileLog`, `addForSDI`, or `addForMATLAB`.
- Repeatable instrument definitions.
- File-log instruments rather than File Log blocks already present in the model.
- Signal test-pointing, streaming badges, or model changes to make signals observable.

----

Copyright 2026 The MathWorks, Inc.

----
