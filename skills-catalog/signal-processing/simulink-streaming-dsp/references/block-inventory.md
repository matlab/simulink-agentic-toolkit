# DSP System Toolbox Block Inventory

Quick reference for block library paths and key parameters.
Use when you need the exact library path for `model_edit` or need to verify a parameter name.

## Source Blocks

| Block | Library path | Key parameters |
|---|---|---|
| From Multimedia File | `dspsrcs4/From Multimedia File` | `FileName`, `AudioFrameSize` (dialog: "Samples per audio channel"), `AudioOutputDataType` |
| Signal From Workspace | `dspsrcs4/Signal From Workspace` | `Signal`, `SampleTime`, `SamplesPerFrame` |
| Sine Wave (DSP) | `dspsrcs4/Sine Wave` | `Frequency`, `SampleTime`, `SamplesPerFrame`, `Amplitude` |
| Chirp (DSP) | `dspsrcs4/Chirp` | `TargetFrequency`, `TargetTime`, `SweepTime`, `SamplesPerFrame` |
| Random Source | `dspsrcs4/Random Source` | `SourceType` ("Gaussian"/"Uniform"), `SamplesPerFrame`, `SampleTime` |
| Constant (DSP) | `dspsrcs4/Constant` | `Value` |

## Sink Blocks

| Block | Library path | Key parameters |
|---|---|---|
| Time Scope | `dspsnks4/Time Scope` | `FrameBasedProcessingString`, `SampleTime`, `TimeSpanSource` |
| Spectrum Analyzer | `dspsnks4/Spectrum Analyzer` | `NumInputPorts`, `SampleRate`, `ViewType`, `FFTLengthSource` |
| Filter Visualizer | `dspsnks4/Filter Visualizer` | `NumFilters`, `FilterType` ("FIR"/"IIR"), `SampleRate`, `NumFrequencyPoints` (dialog: "Frequency Points", was "FFT Length" before R2026a) |
| Array Plot | `dspsnks4/Array Plot` | `XDataMode`, `CustomXData`, `YLimits` |
| To Multimedia File | `dspsnks4/To Multimedia File` | `FileName` (SampleRate is inherited from input — not a block parameter) |

## Filter Implementation Blocks

**WARNING:** Discrete FIR Filter exists in TWO libraries. Always use the DSP version.

| Block | Library path | Key parameters |
|---|---|---|
| Discrete FIR Filter (DSP) | `dsparch4/Discrete FIR Filter` | `Numerator`, `InputProcessing` (default: frame-based), `CoefSource` |
| Discrete FIR Filter (Simulink) | `simulink/Discrete/Discrete FIR Filter` | **DO NOT USE** — defaults to sample-based InputProcessing |
| Second-Order Section Filter | `dsparch4/Second-Order Section Filter` | `CoefficientSource` ("Dialog"/"Input ports"), `Structure`, `InputProcessing` |
| Biquad Filter (LEGACY) | `dsparch4/Biquad Filter` | Do NOT use — replaced by Second-Order Section Filter |
| Variable Bandwidth FIR Filter | `dspfdesign/Variable Bandwidth FIR Filter` | `CutoffFrequency`, `FilterOrder`, `SampleRate` |
| Variable Bandwidth IIR Filter | `dspfdesign/Variable Bandwidth IIR Filter` | `CutoffFrequency`, `FilterOrder`, `SampleRate` |

## Filter Design Blocks (R2023b+)

| Block | Library path |
|---|---|
| Lowpass FIR Filter Design | `dspfdesign/Lowpass FIR Filter Design` |
| Highpass FIR Filter Design | `dspfdesign/Highpass FIR Filter Design` |
| Bandpass FIR Filter Design | `dspfdesign/Bandpass FIR Filter Design` |
| Bandstop FIR Filter Design | `dspfdesign/Bandstop FIR Filter Design` |
| Lowpass IIR Filter Design | `dspfdesign/Lowpass IIR Filter Design` |
| Highpass IIR Filter Design | `dspfdesign/Highpass IIR Filter Design` |
| Bandpass IIR Filter Design | `dspfdesign/Bandpass IIR Filter Design` |
| Bandstop IIR Filter Design | `dspfdesign/Bandstop IIR Filter Design` |

## Buffer/Frame Management Blocks

| Block | Library path | Key parameters |
|---|---|---|
| Buffer | `dspbuff3/Buffer` | `N` (output size), `V` (overlap), `ic` (initial conditions) |
| Unbuffer | `dspbuff3/Unbuffer` | `ic` |
| Delay Line | `dspbuff3/Delay Line` | `DelayLineLength`, `ic` |

## Rate Conversion Blocks

| Block | Library path | Key parameters |
|---|---|---|
| FIR Decimation | `dspmlti4/FIR Decimation` | `DecimationFactor`, `InputProcessing`, `RateOptions` |
| FIR Interpolation | `dspmlti4/FIR Interpolation` | `InterpolationFactor`, `InputProcessing` |
| Sample-Rate Converter | `dspmlti4/Sample-Rate Converter` | `Bandwidth`, `InputSampleRate`, `OutputSampleRate` |
| Variable FIR Decimation | `dspmlti4/Variable FIR Decimation` | `Specification` (`Decimation factor` or `Output frame length`), `DecimationFactor`, `MaximumDecimationFactor`, `NumeratorSource` ("Input port" for tunable coeffs). Accepts variable-size input; in `Output frame length` mode each input frame length must be an integer **multiple** of `Po`. For arbitrary size ratios use `dsp.AsyncBuffer` — see `variable-size-signals.md` Trap 3 |
| Variable FIR Interpolation | `dspmlti4/Variable FIR Interpolation` | `Specification` (`Interpolation factor` or `Output frame length`), `InterpolationFactor`, `MaximumInterpolationFactor`, `NumeratorSource`. Accepts variable-size input; in `Output frame length` mode each input frame length must be a **divisor** of `Po`. For arbitrary size ratios use `dsp.AsyncBuffer` — see `variable-size-signals.md` Trap 3 |

## Signal Operations

| Block | Library path | Key parameters |
|---|---|---|
| Parameter Smoother | `dspsigops/Parameter Smoother` | `NumParameters`, `SmoothingMode`, `SmoothingFactor` |
| Window Function | `dspsigops/Window Function` | `WindowType`, `SamplingFlag` |

## InputProcessing Parameter Values

For blocks that have this parameter:

| Value | Meaning | When to use |
|---|---|---|
| `"Columns as channels (frame based)"` | Each column = one channel with M time samples | Frame-based DSP (most streaming models) |
| `"Elements as channels (sample based)"` | Each element = independent channel at one time instant | Multi-sensor arrays at scalar rate |
| `"Inherited"` | Inherits from upstream signal | Rarely use — be explicit |

### Blocks with InputProcessing

- `simulink/Discrete/Discrete FIR Filter` — default: **sample-based** (WRONG for streaming — DO NOT USE)
- `dsparch4/Discrete FIR Filter` — default: **frame-based** (correct — USE THIS ONE)
- Discrete Filter — default: **sample-based** (WRONG for streaming)
- Biquad Filter — default: **sample-based** (WRONG for streaming)
- FIR Decimation — default: **frame-based** (correct)
- FIR Interpolation — default: **frame-based** (correct)
- Second-Order Section Filter — default: **frame-based** (correct)

----

Copyright 2026 The MathWorks, Inc.

----
