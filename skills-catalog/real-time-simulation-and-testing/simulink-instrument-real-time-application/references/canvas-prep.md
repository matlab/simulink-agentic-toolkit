# Canvas Preparation for Instrumentation

Two model edits prepare a signal for instrumentation: **test-pointing** keeps the signal visible through code generation, and the **streaming canvas badge** makes the signal eligible for bulk-add via `addInstrumentedSignals()`. Both are signal properties, and both are set with the `model_edit` tool's `configure` operation. The Workflow's Step 3 references this file.

**Both edits must be applied before `slbuild`.** They are model edits — the code generator only sees them at build time, and once the `.mldatx` is produced, what was kept is what's available. There is no after-the-fact recovery for a signal that was optimized out: the next build is the only opportunity. Always Ask First — these are model edits.

## The Two Operations

| Operation                | Signal property                | Solves                                                                 |
|--------------------------|--------------------------------|------------------------------------------------------------------------|
| Test-point               | `TestPoint: "on"`              | Signal optimized out by code-gen; not present in file log.             |
| Streaming canvas badge   | `DataLogging: "on"`            | Signal not picked up by `addInstrumentedSignals()` bulk-add; no canvas indicator; no default SDI streaming when no explicit instrument is attached. |

## Applying the Edits

Use `model_read` (or `model_overview`) first to get the block IDs, then target the
**signal** — `srcBlock.yN -> dstBlock.uM` — with a `configure` operation:

```json
[{"op": "configure",
  "target": "blk_2.y1 -> blk_3.u1",
  "params": {"TestPoint": "on", "DataLogging": "on"}}]
```

Both flags go in a single `configure` call. `DataLoggingSampleTime` may be set the
same way to reduce logged or streamed data volume when the user only needs a slower
live view or lower-rate retained data:

```json
[{"op": "configure",
  "target": "blk_2.y1 -> blk_3.u1",
  "params": {"DataLogging": "on", "DataLoggingSampleTime": "0.1"}}]
```

Verify with `model_query_params` on the same signal target (no compile needed):

```json
{"targets": ["blk_2.y1 -> blk_3.u1"],
 "params":  ["TestPoint", "DataLogging", "DataLoggingSampleTime"]}
```

Do **not** reach for `set_param` or `Simulink.sdi.markSignalForStreaming` for this —
`model_edit` covers the connected-signal case, which is the overwhelming majority.
The one exception is below.

## The Unconnected-Outport Gap

`model_edit` addresses a signal by its **source and destination** ports. An outport
with nothing wired to it has no signal to name, and the target form
`blk_2.y1` alone is rejected:

```
EXECUTION_ERROR: The SID 'model:2.y1' near '.y1' is incorrect.
```

When the signal to be instrumented leaves a dangling outport, wire it to its real destination first and then use `configure` —
that is almost always the right move, because an unconnected signal is not going to
be captured in a built application anyway. If the port genuinely must stay
unconnected, fall back to the port-handle form:

```matlab
% Fallback ONLY for an unconnected outport, which model_edit cannot target.
ph = get_param("myModel/Gain", "PortHandles");
set_param(ph.Outport(1), "TestPoint", "on");
```

Prefer connecting the signal over using this fallback.

## When To Test-Point

Test-point survives optimization. The code generator may inline a signal that is only used internally — the value is correct in the model but does not appear in the compiled code, which means there is nothing for the instrument to record. Test-pointing forces the signal to remain visible through code-gen.

Test-point applies to instrument capture for **every** destination. Whether the user is going to use file log, SDI, or MATLAB, an optimized-out signal will not appear in the built application for the instrument to capture. The decision to test-point happens **before build** — if `validate(inst, mldatx)` later reports the signal as unavailable, the only fix is to test-point on the canvas and rebuild.

## When To Add the Streaming Badge

The streaming badge — a small dot with two arcs above the signal line — is the canvas indicator that this signal is marked for live streaming. It also makes the signal eligible for `addInstrumentedSignals(inst)`, which bulk-adds every badged signal.

Add the badge when:

- The user wants the canvas indicator to show that the signal is being streamed.
- The user wants `addInstrumentedSignals()` to pick the signal up automatically.

If the user is adding a single named signal with `addSignal(inst, "SigGen")` and does not need the indicator, the badge is not required.

When no explicit instrument is attached to the application, `DataLogging`/streaming-badged signals feed Simulink Real-Time's transient default SDI instrument at `start(tg)`. Attaching an explicit manual instrument, including an empty instrument, prevents that default path and avoids automatically representing every badged signal in SDI.

## Why Both Flags May Be Needed Together

Test-point and `DataLogging` solve different problems. A signal that is optimized out is invisible to **everything** until it is test-pointed. A signal that is present but unbadged is invisible to `addInstrumentedSignals()` (the bulk-add reads the badge). The two flags are independent, so set both when both apply — in one `configure` call, as shown above.

## Build Required After the Edit

The `configure` operation modifies the model. The flag has no effect on any previously built `.mldatx`. The model must be built (or rebuilt) for the flag to take effect — that is owned by `simulink-run-real-time-application` (`slbuild(model)`).

The full setup sequence:

1. Identify the source block and outport (`model_read` for the block IDs).
2. Confirm with the user that the model edit is acceptable.
3. Apply the `model_edit` `configure` operation on the signal.
4. Verify with `model_query_params`.
5. Save the model.
6. Build (route to `simulink-run-real-time-application`).
7. Construct the instrument against the resulting `.mldatx`.
8. Attach the instrument to `tg.Instruments`.

If a build has already happened and a signal turns out to be optimized out, the order is the same — go back to step 3 with an additional test-point, then rebuild. There is no in-place recovery on the existing `.mldatx`.

## Diagnostic Sequence — When Setting Up

Before build, read the flag state on the source signal with `model_query_params`
(`TestPoint`, `DataLogging`).

If the user expected a signal to be captured and `validate(inst, mldatx)` reports it unavailable, `TestPoint == "off"` is the likeliest cause. The fix is to flip it on, save the model, and rebuild — there is no way to add a test-point to an existing `.mldatx`. If `TestPoint == "on"` and the signal is still unavailable, the issue is usually that the signal lives in a code path the active build does not reach (disabled subsystem, conditionally compiled branch) — that is a model-correctness issue, not an instrumentation issue.

## Common Failure Modes

| Symptom                                        | Cause                                              | Fix                                                  |
|------------------------------------------------|----------------------------------------------------|------------------------------------------------------|
| `validate(inst, mldatx)` reports signal missing | Built without a test-point on the source signal    | Test-point via `model_edit` `configure`, save, rebuild, reconstruct the instrument. The current `.mldatx` cannot be repaired. |
| File-log channel is empty after the run        | Same — built without a test-point                  | Same fix; the data is already lost for that run.     |
| `addInstrumentedSignals(inst)` adds no signals  | No streaming badge on any signal at build time     | `configure` each desired signal with `DataLogging: "on"`, save, rebuild. |
| `addInstrumentedSignals(inst)` empty, but signals are wired to File Log blocks | `addInstrumentedSignals` looks for the streaming badge, not File Log block connections | Use `addFileLogSignals(inst)` instead. |
| Signal captured at first build, empty after edit | Latest build dropped the test-point (e.g., signal renamed or rerouted) | Re-check `TestPoint` on the new source signal and rebuild. |
| `configure` rejects the target with `SID ... near '.y1' is incorrect` | The outport has no destination, so there is no signal to address | Wire the outport to its destination, then `configure`. See the gap section above. |

----

Copyright 2026 The MathWorks, Inc.

----
