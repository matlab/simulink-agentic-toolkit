---
name: simulink-streaming-dsp
description: >
  Building or editing Simulink (.slx) models that stream signals in frames using
  DSP System Toolbox — audio, vibration, radar, comms. Use when the prompt names
  a Simulink block (Discrete FIR Filter, Buffer, Unbuffer, Rate Transition,
  Downsample, Upsample, Sample-Rate Converter, FIR Decimation, Time Scope,
  Spectrum Analyzer, From Multimedia File) or an action (frame-based
  processing, InputProcessing, buffering, overlap, windowing, STFT,
  short-time Fourier, decimate, downsample, upsample, resample, multirate,
  anti-aliasing, tunable filter). Prevents silent numerical errors from
  sample-vs-frame mismatch, wrong block choice, or missing anti-aliasing.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "2.0"
---

# Simulink Streaming DSP

Build streaming (frame-based) signal processing models in Simulink using
DSP System Toolbox. This skill prevents silent errors from wrong block
selection, missed parameter settings, and outdated filter architectures.

The most damaging failures here are **silent**: the model compiles, simulates,
and produces output — but the numbers are wrong, with no error or warning.
Apply the Block Selection and Frame-Based Configuration rules on every build,
even for tasks a strong model would usually get right — they are the cheap
insurance against silent corruption and they hold across models and effort levels.

## When to Use

- Building a Simulink model that processes signals in frames (not sample-at-a-time)
- Choosing source, sink, or visualization blocks for a DSP pipeline
- Adding filters to a streaming model (FIR, IIR, tunable)
- Buffering signals (scalar→frame, frame resizing, overlapping windows, unbuffering)
- Converting sample/frame rates (decimate, interpolate, fractional resample)
- Building multirate models (dual-path, different frame sizes, mixed rates)
- Working with variable-size signals (packet-based, adaptive frame sizes)
- Building a tunable/adjustable filter with runtime parameter control
- Visualizing signals or filter responses (Time Scope, Spectrum Analyzer, Filter Visualizer)
- Computing buffering latency or frame timing

## When NOT to Use

- MATLAB-only scripting (no Simulink model) — use standard MATLAB functions
- Continuous-time Simulink modeling (no discrete/DSP blocks)

## Model Construction — Use the MCP Model Tools Only (mandatory)

Build and edit every model through the MATLAB MCP model tools — `model_edit`
(add/connect/configure/delete), `model_read`, `model_check`, `model_test`.
**Never** construct or modify a model with raw MATLAB commands
(`add_block`, `add_line`, `set_param`, `delete_line`, `new_system`, …) run through
`evaluate_matlab_code`. The MCP tools handle autolayout, undo tracking, and error
recovery; the raw-command fallback is slow (block-by-block round-trips), skips
layout, and is prohibited. Use `evaluate_matlab_code` only to *run/verify* a model
(`sim`, reading logged signals, `rebuffer_delay`, filter design math) — never to
build one.

**Get the schema right the first time** — guessing field names wastes turns. The
add-block field is `type` (a full library path), and connections use `target`:

```
add_block:  {"op":"add_block", "type":"dspsrcs4/Sine Wave", "ref":"src", "name":"SineWave", "params":{"SamplesPerFrame":"256"}}
connect:    {"op":"connect", "target":"#src.y1 -> #buf.u1"}          // #ref within the same call
configure:  {"op":"configure", "target":"blk_3", "params":{"InputProcessing":"Columns as channels (frame based)"}}
```

- `type` (NOT `source`, `path`, or `block`) names the block; `ref` is your handle for chaining, and the response returns `ref → blk_id`.
- `connect` uses `target: "src.y1 -> dst.u1"` (NOT `from`/`to`); `y1` = output port 1, `u1` = input port 1. Within one call reference just-added blocks as `#ref`; across calls use the returned `blk_N` id.
- **Model-level settings** (solver, display overlays) go through a `configure` op targeting `config:<ModelName>`, not `set_param`:
  ```
  {"op":"configure", "target":"config:MyModel", "params":{"ShowLineDimensions":"on","SampleTimeColors":"on"}}
  ```

Wrong field names fail with a misleading `Unrecognized field name "type"` — that
error means the operation was missing `type`, not that the tool is broken.

## Build Workflow

Build a streaming DSP model in this order. Each step has a verification.

1. **Source** — pick the DSP source block (see Block Selection). Set `SamplesPerFrame`.
2. **Frame configuration** — confirm the signal is `[FrameSize × NumChannels]` (column-oriented). See the Frame-Based Configuration Checklist.
3. **Processing** — add filters / rate conversion / buffering. For each filter, set/inherit frame-based `InputProcessing`.
4. **Sink** — pick a DSP display/output block (Time Scope, Spectrum Analyzer — never `Scope`).
5. **Solver** — Fixed-step, Discrete (no continuous states).
6. **Verify** — turn on the model's information overlays so dimensions and rates are visible on the diagram, then confirm signal dimensions read `[N×1]`/`[N×C]`, not `[1×N]`. Confirm output against a reference where possible.

   - **Non-scalar signals** → enable signal dimensions via a `configure` op: `{"op":"configure","target":"config:<model>","params":{"ShowLineDimensions":"on"}}`. Wires then annotate their size — a `[1×N]` label flags a wrong orientation at a glance.
   - **Multirate models** (any two blocks running at different sample times) → enable sample time colors via a `configure` op: `{"op":"configure","target":"config:<model>","params":{"SampleTimeColors":"on"}}`. Each rate draws in a distinct color, so an unintended rate transition or a block stuck at the wrong rate is immediately obvious.

For the task at hand, load the matching reference (see Task References below) once the block-level details are needed.

## Block Selection

Select blocks using this table. **Never use the generic Simulink equivalent — it
lacks frame-based processing support and silently corrupts framed signals.**

### Source Blocks

| User intent | Correct block | Library | Key parameter |
|---|---|---|---|
| Read audio/video file | **From Multimedia File** | `dspsrcs4` | `AudioFrameSize` (dialog: "Samples per audio channel") |
| Load workspace signal (framed) | **Signal From Workspace** | `dspsrcs4` | `SamplesPerFrame`, `SignalName` |
| Generate sine/cosine test signal | **Sine Wave** (DSP) | `dspsrcs4` | `SamplesPerFrame`, `Frequency` |
| Generate chirp test signal | **Chirp** (DSP) | `dspsrcs4` | `SamplesPerFrame` |
| Generate noise | **Random Source** | `dspsrcs4` | `SamplesPerFrame`, `SourceType` |

**Never use** `From Workspace` (Simulink built-in) — outputs `[1×N]` row vectors, not `[N×1]` column frames.

### Sink Blocks

| User intent | Correct block | Library |
|---|---|---|
| View time-domain waveform | **Time Scope** | `dspsnks4` |
| View frequency spectrum | **Spectrum Analyzer** | `dspsnks4` |
| View filter frequency response | **Filter Visualizer** | `dspsnks4` |
| View vector/array snapshot | **Array Plot** | `dspsnks4` |
| Write audio/video to file | **To Multimedia File** | `dspsnks4` |

**Discouraged use** `Scope` (Simulink built-in) — no frame-based support, staircase
display, no DSP measurements. This applies even when display is a secondary part
of the task ("…and show the output").

### Filter Blocks

| Need | Use | Avoid |
|---|---|---|
| FIR filtering | **`dsparch4/Discrete FIR Filter`** (frame-based default) | `simulink/Discrete/Discrete FIR Filter` (sample-based default) |
| IIR via cascaded biquads | **Second-Order Section Filter** (R2023b+) | Biquad Filter (legacy) |
| Tunable filter | two-block Design→Implementation pattern | monolithic / MATLAB Function |

The Discrete FIR Filter exists in **two libraries with the same name** — see Checklist Rule 1.

For exact library paths and parameter names of any block, see
`references/block-inventory.md` — the master lookup; load it when you need a path
for `model_edit` or need to confirm a parameter name.

## Frame-Based Configuration Checklist

These settings produce **silent wrong output** if left at defaults. The agent
typically *knows* these facts when asked directly but fails to *apply* them while
building — run this checklist on every model.

### Rule 1: Use the DSP Discrete FIR Filter, not Simulink's

| Library | InputProcessing default | Use for streaming? |
|---|---|---|
| `dsparch4/Discrete FIR Filter` (DSP System Toolbox) | "Columns as channels (frame based)" | YES |
| `simulink/Discrete/Discrete FIR Filter` (Simulink built-in) | "Elements as channels (sample based)" | NO |

If you must use any block whose `InputProcessing` defaults to sample-based, set:
```
InputProcessing = "Columns as channels (frame based)"
```
Affected blocks with sample-based defaults: `simulink/Discrete/Discrete FIR Filter`, Discrete Filter, Biquad Filter.

**Why it matters:** "Elements as channels (sample based)" treats each element in
the frame as a separate channel. A 256-sample frame becomes 256 single-sample
channels filtered independently — output is garbage, no error thrown.

**Exceptions:** Second-Order Section Filter, FIR Decimation, FIR Interpolation
default to frame-based — no action needed. And when input *is* genuinely
multichannel sample-based (e.g. `[1×8]` from 8 sensors at one instant),
"Elements as channels" is the **correct** choice — do not reflexively force
frame-based.

### Rule 2: FrameBasedProcessingString on Time Scope

After connecting a frame-based signal to Time Scope, set:
```
FrameBasedProcessingString = "Columns as channels (frame based)"
```
Same mechanism as Rule 1 — the default shows a staircase display instead of a smooth waveform.

### Rule 3: Signal Dimension Convention

DSP signals are **column vectors**: `[FrameSize × NumChannels]`.

- `[256×1]` = 256-sample frame, 1 channel — CORRECT
- `[1×256]` = 1 sample, 256 channels — WRONG for streaming DSP
- `[512×2]` = 512-sample frame, 2 channels (stereo) — CORRECT

A `[1×N]` line means something upstream is wrong (a `From Workspace` block or a transposing MATLAB Function).

For any model with non-scalar signals, turn on `ShowLineDimensions` via a `configure` op (`{"op":"configure","target":"config:<model>","params":{"ShowLineDimensions":"on"}}`) so every wire is annotated with its size — this makes a stray `[1×N]` visible on the diagram instead of only discoverable by clicking each signal.

### Rule 4: Solver Configuration

Apply via a `configure` op targeting `config:<model>` (not `set_param`):
`{"op":"configure","target":"config:<model>","params":{"SolverType":"Fixed-step","Solver":"FixedStepDiscrete","FixedStep":"auto"}}`

- Solver type: **Fixed-step**
- Solver: **Discrete (no continuous states)** — unless mixing with continuous blocks
- Fixed-step size: `auto` (Simulink derives the base rate from block sample times)

## Task References

When the build reaches one of these task domains, load the matching reference for
block-level detail, parameters, and timing math. SKILL.md covers the cross-cutting
rules above; these cover the specifics.

| Task | Reference | Load when |
|---|---|---|
| Block / library lookup | `references/block-inventory.md` | Need the exact library path or parameter name for any DSP block referenced in the tables above |
| Buffering / multirate | `references/buffering-multirate.md` | Changing frame size, overlap windows, unbuffering, dual-path, multirate timing, buffering latency |
| Rate conversion | `references/rate-conversion.md` | Decimate / interpolate / resample; choosing FIR Decimation vs Downsample; setting `RateOptions` (single-rate vs multirate) |
| Tunable filtering | `references/tunable-filtering.md` | Building any runtime-tunable filter; the 8 Design blocks, two-block pattern, SOS vs Biquad, Parameter Smoother |
| Variable-size signals | `references/variable-size-signals.md` | Frame size changes during simulation; variable→fixed conversion; the Buffer/variable-rate traps |
| Visualization | `references/visualization.md` | Configuring Spectrum Analyzer (NumInputPorts, spectrogram), Filter Visualizer wiring, Array Plot, Time Scope frame config |

Each reference is self-contained and loaded on demand — read only the one relevant to the current step.

## Common Mistakes

| What the agent does wrong | Why it fails | Correct approach |
|---|---|---|
| Uses `From Workspace` for audio/signal input | Outputs `[1×N]` row vector, not `[N×1]` column frame | Use `From Multimedia File` or `Signal From Workspace` |
| Uses `Scope` for signal display | No frame-based processing, staircase display | Use `Time Scope` (`dspsnks4`) |
| Uses `simulink/Discrete/Discrete FIR Filter` | Sample-based default — silent wrong output | Use `dsparch4/Discrete FIR Filter` |
| Leaves InputProcessing at default on a sample-based filter block | Silent wrong output — runs but garbage | Set "Columns as channels (frame based)" or use the DSP block |
| Adds a Buffer before Spectrum Analyzer for scalar input | SA buffers internally — extra Buffer is unnecessary | Connect scalar directly to SA |
| Uses Downsample/Upsample for a rate change | No anti-aliasing/anti-imaging — aliases or images | Use FIR Decimation / FIR Interpolation (or Sample-Rate Converter) |
| Reverses `RateOptions` single-rate vs multirate semantics | Wrong output frame size or frame rate, silently | Single-rate → frame size changes; multirate → frame rate changes (see `rate-conversion.md`) |
| Builds TFE+ArrayPlot or FFT workaround for filter response | Over-engineered, noisy, needs excitation | Use Filter Visualizer (1 block, exact response) |
| Uses Biquad Filter for IIR | Legacy block, not tunable, no Design-block integration | Use Second-Order Section Filter (R2023b+) |
| Calls the two-block pattern "old" and monolithic "new" | Inverted — two-block IS the modern R2023b+ pattern | Design block → Implementation block is correct |
| Treats the plain Buffer as a variable-size→fixed converter | Buffer requires a fixed compile-time input size | Use `dsp.AsyncBuffer` (in a MATLAB Function) |
| Models a variable frame *size* as a variable *rate* | Frame-size change does not alter the sample period | Variable-size needs only a discrete sample time |
| Uses Variable FIR Decimation to convert arbitrary variable-size→fixed frames | It accepts variable-size input, but its `Output frame length` mode only rebuffers when each input frame length is an integer multiple of `Po` — fails for chunk sets like {240,480,960}→256 | Use `dsp.AsyncBuffer` (write variable chunks, read fixed frames) + a separate anti-alias filter |
| Computes buffer latency manually | Misses tasking-mode edge cases | Use `rebuffer_delay()` |
| Tries to reconcile `rebuffer_delay` against a hand-measured impulse latency | They answer different questions; overlap changes the output rate, so the numbers legitimately differ — chasing the gap is a time sink | `rebuffer_delay` returns input-rate samples and is an alignment delay, not an impulse-peak position; report it as the buffer latency and add downstream filter group delay separately (see `buffering-multirate.md`) |

----

Copyright 2026 The MathWorks, Inc.

----
