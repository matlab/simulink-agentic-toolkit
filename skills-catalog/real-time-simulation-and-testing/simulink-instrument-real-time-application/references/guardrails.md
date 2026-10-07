# Instrumentation Guardrails — Full Detail

SKILL.md carries the rules themselves, including the table of invented forms to
refuse. This file holds the *reasoning*: why each hallucinated form is wrong, why
each Ask-First gate exists, and the failure modes that motivate them.

## Invented APIs — Why Each Form Is Wrong

The instrument API is small and easy to over-generalize. Every form below is a
**hallucination** that agents produce regularly. The same list appears in
SKILL.md; the middle column is the part that lives only here.

| Invented form | Why it is wrong | Use instead |
|---|---|---|
| `inst.attach(tg, "filelog")` | There is no `attach` method; destination routing lives on `tg.Instruments` | `addForFileLog(tg.Instruments, inst)` / `addForSDI` / `addForMATLAB` |
| `inst.signals.add("Sig")` | `signals` is not a public collection | `addSignal(inst, "Sig")` |
| `inst.start()` / `inst.stop()` | Instruments have no run lifecycle; capture begins when the **application** starts, or when `startRecording` is called | `start(tg, ...)` / `startRecording(tg)` — both owned by `simulink-run-real-time-application` |
| `inst.record()` / `inst.capture()` | No such methods | Attach to a bucket; capture is automatic |
| `inst.getData()` / `inst.read()` | The MATLAB bucket is **push**, not pull | `connectCallback(inst, @onData)` + `getCallbackDataForSignal(src, evt, "Sig")` |
| `inst.save()` / `inst.export()` | Instruments have no SLX or file representation | `generateScript(inst)` + `writelines` |
| `addSignal(..., "SampleRate", N)` | Not a documented parameter | `Decimation` (integer 1–256) per signal, or `DataLoggingSampleTime` on the model |
| `addSignal(..., "Period", N)` / `"RateLimit"` | Not documented parameters | `Decimation` per signal, or `DataLoggingSampleTime` on the model |
| `set_param(blockPath, "TestPoint", "on")` | `TestPoint` is a **signal** property, not a block property; and this skill sets model parameters through the MCP model tools, not `set_param` | `model_edit` → `configure` on `blk_X.yN -> blk_Y.uM` with `TestPoint: "on"` |
| Bulk-add helpers for buses | No bus-expansion helper exists on the instrument | Add leaves individually, or see `bus-elements.md` |

**Not hallucinations, but out of scope here:** `addInstrument`, `removeInstrument`,
and `getAllInstruments` are real target functions belonging to the App Designer /
UI-connector path (`connectScalar`, `connectLine`, `connectXYPlot`). This skill uses
the `addForFileLog` / `addForSDI` / `addForMATLAB` bucket API instead. Do not mix
the two.

## Why Each Ask-First Gate Exists

### Bus-leaf capture (`BusElement`)

`BusElement` resolves only on a **non-virtual** bus. A virtual bus carries no
addressable leaves in the generated code, so the leaf does not resolve at validate
time. Both remedies change something the user owns:

- **Convert the source bus to non-virtual** — a model edit plus a rebuild.
- **Instrument the upstream leaf** before it enters the Bus Creator — a different
  signal than the one the user named.

Because both are consequential, present **both** and wait. Do not pick one. Whole-bus
streaming is *not* gated by this rule — only leaf addressing is. See
`bus-elements.md` for the `CompiledBusType` probe.

Converting the bus is also more than one parameter: `NonVirtualBus: "on"` needs an
explicit `Simulink.Bus` object as `OutDataTypeStr` alongside it, and that bus object's
element names must match the incoming signal names. See `bus-elements.md`.

### Array-of-buses index

A guessed index silently captures the wrong element. When `addSignal` throws
`BusElementRequiresDims` or `BusElementInvalidDims`, the signal **was already
added** but will not resolve — remove it before asking, or `validate` will keep
reporting it.

### Model edits (`TestPoint`, `DataLogging`)

**Gate:** get confirmation before applying either flag. Both modify the model and
require a rebuild to take effect, so the edit is not free and not reversible in the
current build — an optimized-out signal cannot be recovered after build, and the next
`slbuild` is the only opportunity. See `canvas-prep.md`.

### `removeAllForXXX`

**Gate:** get confirmation before calling one. These detach **every** instrument in
the bucket, including instruments the user did not create, so the scope is wider than
the call reads. `removeForFileLog` / `removeForSDI` / `removeForMATLAB` on a specific
instrument need no gate.

### High signal counts

**Gate:** not a confirmation gate — warn, then proceed. Hundreds of high-rate signals
are legitimate; the user just needs to know the cost before the run, not approve the
`addSignal` calls. Total signal count times sample rate drives the load, not the
instrument count. File logging pressures target CPU and SSD capacity; SDI and MATLAB
streaming pressure the network and the development computer. Offer a larger
`DataLoggingSampleTime` or a higher `Decimation` as the remedy.

### Attaching a file-log instrument to a running application

Recording must be inactive. The `stopRecording` / attach / `startRecording`
sequence creates a **gap in the recording** the user should know about up front.
An Enable File Log block in the model can hold logging active under model
control, in which case the application must be stopped first.

## Silent-Wrong-Data Traps

These produce no error and no warning. They are the highest-value things to
catch, because the user gets a populated log that is simply incorrect.

| Situation | What goes wrong | Correct approach |
|---|---|---|
| Signal inside a Conditional (Enabled / Triggered / function-call) subsystem, gating matters | Instrument logs **post-step** → redundant samples while the subsystem is disabled | **File Log block** (model edit, rebuild) |
| Signal inside a For-Iterator / While-Iterator subsystem, per-iteration values matter | Only the **last** iteration's value is logged | **File Log block** |
| `addInstrumentedSignals` on a model with File Log blocks but no streaming badges | Empty signal list, **no error** | `addFileLogSignals` |
| `addFileLogSignals` on a model with streaming badges but no File Log blocks | Empty signal list, **no error** | `addInstrumentedSignals` |
| Result of `addInstrumentedSignals` / `addFileLogSignals` assumed non-empty | They return nothing and add nothing when the model has no matching signals — no error | Count `addSignal` lines in `generateScript(inst)`; there is no public `Signals` property |
| Signal optimized away by the code generator | Nothing to record; `validate` reports it unresolved | Test-point the source signal, rebuild |
| Instrument reused after a model rebuild | Validated against the previous `.mldatx`; definitions may have shifted | Reconstruct and re-`validate` against the fresh `.mldatx` |

## Hard Limits — No Workaround

- **Complex or multiword data types** cannot be logged by name. There is no
  test-point rescue.
- Signals whose source block name consists **only of spaces** cannot be addressed.
- An instrument **locked to a target computer** cannot have its signal list or
  callbacks changed. Detach, edit, re-attach.
- One instrument lives in **exactly one** bucket. Attaching the same object to two
  buckets is not supported — detach and re-attach to change destination.

----

Copyright 2026 The MathWorks, Inc.

----
