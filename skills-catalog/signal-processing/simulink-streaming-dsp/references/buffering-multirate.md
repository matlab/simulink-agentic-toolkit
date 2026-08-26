# Buffering & Multirate Patterns

Load when building or editing a model that changes frame size (scalar→frame, frame→larger/smaller frame, overlapping windows), serializes frames back to scalar, or runs multiple rates in one model.

The agent selects Buffer/Unbuffer correctly in most cases — this reference is the timing math and pattern catalog, plus the multirate rules that are easy to get wrong.

## Core Blocks

| Block | Library | Purpose |
|---|---|---|
| Buffer | `dspbuff3/Buffer` | Scalar→frame, frame→larger frame, overlapping windows |
| Unbuffer | `dspbuff3/Unbuffer` | Frame→scalar (serialization) |
| dsp.AsyncBuffer | System object (in MATLAB Function block) | Variable-size→fixed-size buffering |

`Buffer` parameters: `N` (output frame size), `V` (overlap), `ic` (initial conditions).

## Common Patterns

**Scalar→frame for spectral analysis:**
```
[Source (SamplesPerFrame=1)] → [Buffer N=1024, V=0] → [Spectrum Analyzer]
```

**Overlapping frames for STFT:**
```
[Source (scalar)] → [Buffer N=256, V=192] → [processing]
```
Hop size = N − V = 64 samples. **Overlap alters the output sample period** (see formulas).

**Frame-to-frame rebuffering (resize frames):**
```
[Source (512/frame)] → [Buffer N=1024, V=0] → [processing]
```
Frame rate halves; sample rate unchanged. Feeding an already-framed signal into Buffer is valid.

**Unbuffer back to scalar:**
```
[processing (256/frame)] → [Unbuffer] → [DAC / scalar sink]
```

**Dual-path (low latency + high resolution):**
```
[Source (scalar)] ─┬─→ [Buffer N=64] → [Filter] → [Unbuffer] → output (low latency)
                   └─→ [Buffer N=4096, V=3072] → [Spectrum Analyzer] (high resolution)
```

## Timing Formulas

`Ts` = sample period, `Tf` = frame period, `M` = input frame size, `N` = output buffer size, `V` = overlap.

| Scenario | Output frame period | Output sample period |
|---|---|---|
| Buffer (no overlap) | `N × Ts_input` | `Ts_input` (unchanged) |
| Buffer (overlap V) | `(N − V) × Ts_input` | `(N − V) × Ts_input / N` (**changes**) |
| Unbuffer | `Ts_input / M_input` | `T_frame_input / M_input` |
| Frame rebuffer (M→N) | `N × Ts_input` | `Ts_input` (unchanged) |

**Key insight:** Overlap alters the output sample period — non-obvious and a frequent source of confusion. Zero-overlap buffering preserves the sample period.

## Latency Calculation

Use `rebuffer_delay()` — it handles tasking-mode and initial-condition edge cases that manual calculation misses.

```matlab
d = rebuffer_delay(f, n, v);          % multitasking mode (default)
d = rebuffer_delay(f, n, v, mode);    % mode: 'singletasking' or 'multitasking'
```

| Arg | Meaning |
|---|---|
| `f` | frame size of input to the Buffer/Unbuffer block |
| `n` | output buffer size (Buffer) or `1` (Unbuffer) |
| `v` | overlap value (Buffer) or `0` (Unbuffer) |
| `mode` | `'singletasking'` or `'multitasking'` (default) |

**Manual formulas** (quick reference only — `rebuffer_delay` is preferred):
- Buffer (overlap=0): latency = `n` samples
- Buffer (overlap=v): latency = `n + v` samples (e.g. `rebuffer_delay(1,1024,512) = 1536`)
- Unbuffer: `rebuffer_delay(f, 1, 0)` = `f` samples in multitasking
- FIR filter group delay (linear phase): `filterOrder / 2` samples

### What `rebuffer_delay` returns — read before trusting a number

- **Units: input-rate samples.** The returned `d` is measured in samples of the signal *entering* the block, at the input sample rate. It is **not** in output-frame counts and **not** in the (faster) output sample rate that overlap produces.
- **Meaning: it is an alignment delay, not an impulse-peak position.** `d` is how many input samples you delay the *original* signal to line it up with the rebuffered signal (the value you feed a Delay block when comparing original vs. rebuffered). It is **not** the location where an impulse fed through the chain shows its peak.
- **Do NOT try to reconcile `rebuffer_delay` against a hand-measured impulse latency.** They answer different questions. An impulse-peak measurement in the model is confounded by (a) overlap changing the downstream sample rate — see the timing table above: with `V=512, N=1024` the buffer emits every `N−V = 512` input samples, so the output runs at 2× the input rate — and (b) any filter group delay downstream, which operates at that faster output rate. Chasing the difference between the two numbers is a known time sink; report the `rebuffer_delay` value as the buffer's latency and add downstream filter group delay separately.
- **Worked example (the overlapping-Buffer→decimate case):** for a `Buffer(N=1024, V=512)` feeding a decimate-by-4 stage: `rebuffer_delay(1,1024,512) = 1536` input samples for the buffer. If the decimation FIR has group delay `g` (at the buffer's output rate), convert `g` to input-rate samples using the output sample period from the timing table before adding it — do not add raw `g`.

## Multirate Model Rules

- Solver: Fixed-step, Discrete.
- **Enable sample time colors** via a `configure` op — `{"op":"configure","target":"config:<model>","params":{"SampleTimeColors":"on"}}` (Debug → Information Overlays → Sample Time → Colors). Each rate renders in a distinct color, so an unintended rate transition, a path stuck at the wrong rate, or a mismatch at a Sum/combine block is visible on the diagram. Turn this on whenever a model runs more than one rate. (Use the MCP `model_edit` configure op, never `set_param`.)
- **No Rate Transition blocks needed between DSP blocks** — they handle multirate transitions internally.
- Use `dsp.AsyncBuffer` (inside a MATLAB Function block) when input frame size varies at runtime — the plain Buffer block requires a compile-time-fixed input size and does **not** accept variable-size input. See `variable-size-signals.md`.

----

Copyright 2026 The MathWorks, Inc.

----
