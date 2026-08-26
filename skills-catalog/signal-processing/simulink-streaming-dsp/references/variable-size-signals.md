# Variable-Size Signals

Load when the model handles signals whose **frame size changes during simulation** — network packets, end-of-file partial frames, or adaptive-length output. The number of dimensions never changes; only the size within a dimension does.

## Support Matrix

| Block | Variable-size input? | Notes |
|---|---|---|
| Discrete FIR Filter (`dsparch4`) | YES | Requires `InputProcessing = "Columns as channels (frame based)"` |
| Second-Order Section Filter | YES | Variable-size supported |
| Spectrum Analyzer | YES (natively) | Channel count must stay fixed; frame size may vary — no Buffer needed |
| FIR Decimation | YES (single-rate frame-based mode only) | `RateOptions = "Enforce single-rate processing"` |
| `dsp.AsyncBuffer` (in MATLAB Function) | YES | The variable→fixed converter — write variable chunks, read fixed frames |
| Variable FIR Decimation / Interpolation (`dspmlti4`) | YES (with size-ratio constraint — see Trap 3) | `Specification = "Output frame length"` mode produces fixed-size output when each input frame is an integer multiple (decimation) or divisor (interpolation) of `Po`. For arbitrary size ratios use `dsp.AsyncBuffer`. |
| **Buffer / Unbuffer / Pad** | **NO** | Require a compile-time-**fixed** input frame size |

## Trap 1: Buffer does NOT accept variable-size input

The plain **Buffer** block cannot take a variable-size signal — it requires a fixed input frame size known at compile time. It is **not** a variable→fixed converter, and it does **not** "accumulate variable frames until full."

For variable-size→fixed-size accumulation, use **`dsp.AsyncBuffer`** inside a MATLAB Function block (see the conversion section below).

## Trap 2: Variable frame *size* is not a variable *rate*

A signal whose frame size changes is **variable-size**, not **variable-rate**. Frame-size changes do **not** alter the sample period, do not create a "timing conflict," and do not *require* a fixed-step solver for that reason. Variable-size signals simply require a **discrete** sample time. Do not model a size change as a rate change.

## Trap 3: Variable FIR Decimation / Interpolation only rebuffer when input and output frame sizes have an integer size ratio

The **Variable FIR Decimation** / **Variable FIR Interpolation** blocks (in `dspmlti4`) *do* accept variable-size input — the doc's Block Characteristics table lists Variable-Size Signals: yes. "Variable" refers to both tunable filter coefficients (via a numerator input port) **and** variable-size input support. Each block has two modes:

- **`Decimation factor` / `Interpolation factor`** — the rate factor is fixed, output frame size follows the input. Variable-size input → variable-size output.
- **`Output frame length`** — the output frame length `Po` is fixed; the rate factor is re-derived each frame from the input length. Variable-size input → fixed-size output, **only when each input frame length is an integer multiple (decimation) or divisor (interpolation) of `Po`**.

The trap is thinking "Variable FIR Decimation in Output-frame-length mode" is a general-purpose variable→fixed rebuffer. It is not — it can only rebuffer when the input:output frame-size ratio stays integer on every step. For genuinely arbitrary variable chunks (e.g. 240–960 samples → 256), none of 240, 480, 960 is an integer multiple of 256, so the block cannot be used; reach for **`dsp.AsyncBuffer`** instead.

## Variable-Size → Fixed-Size Conversion

Use **`dsp.AsyncBuffer`** inside a MATLAB Function block, paired with a separate anti-aliasing filter when the rate is also being reduced. The AsyncBuffer accumulates variable-length writes and emits fixed-length frames on demand:

```matlab
% inside a MATLAB Function block; buf and aa are persistent System objects
%   buf = dsp.AsyncBuffer('Capacity', maxExpectedBacklog)
%   aa  = dsp.FIRFilter('Numerator', fir1(64, 0.4))   % anti-alias LPF
y = aa(u);                       % anti-alias filter the incoming variable chunk u
write(buf, y);                   % append variable-length samples
frame = zeros(256,1); valid = false;
if buf.NumUnreadSamples >= 256
    frame = read(buf, 256);      % emit a fixed 256-sample frame
    valid = true;
end
```

`read(buf, N)` returns exactly `N` samples; hold the output (with a valid/enable flag) on warm-up steps until the buffer first fills. Anti-aliasing is a **separate** filter — AsyncBuffer only rebuffers, it does not filter.

**Do NOT** reach for Variable FIR Decimation here (see Trap 3). Even though it *does* accept variable-size input, its Output-frame-length mode requires each input frame length to be an integer multiple of `Po` — with chunks in {240..960} and `Po = 256`, that constraint fails on every step.

### Verify subsystem ports before wiring across the boundary

Before connecting the output of any subsystem you just built, call `model_read` on that subsystem and confirm its actual port count. A subsystem exposes exactly the ports its contents produce — assume nothing. Wiring to a port that does not exist (e.g. connecting to `blk.y2` when the subsystem has one output) fails at build time with `Port outN does not exist on <subsystem> (has M outport(s))`, aborts the rapid-accel target, and looks like a data-type propagation error in the log. This check is cheap and prevents the class of failure where the agent's mental model of a subsystem's interface drifts from the model it just constructed.

## Generating Variable-Size Test Signals

MATLAB Function block:
- On the output port, set `IsDynamic = true` and a max size = largest expected frame.
- Model setting: `PropagateVarSize = "During execution"`.
- Use `coder.varsize` in the function body.

Other generators: Selector block with "Starting and ending indices (port)"; conditionally executed subsystems (Switch between different-size paths).

Signal sources (From Multimedia File, Signal From Workspace, Sine Wave) always emit fixed-size frames — they cannot generate variable-size signals.

## Constraints

- Number of dimensions never changes — only the size within a dimension.
- Requires discrete sample time.
- Channel count must stay fixed even when frame size varies.
- Array-format logging unsupported — use Structure or Dataset format.

----

Copyright 2026 The MathWorks, Inc.

----
