# Signal & Filter Visualization

Load when choosing or configuring a display block — time waveform, spectrum, spectrogram, filter response, or array snapshot. Use the DSP blocks below, never the generic Simulink `Scope`.

## Which Block for Which Task

| Goal | Block | Library |
|---|---|---|
| Time-domain waveform | **Time Scope** | `dspsnks4` |
| Frequency spectrum / spectrogram | **Spectrum Analyzer** | `dspsnks4` |
| Filter magnitude/phase response | **Filter Visualizer** | `dspsnks4` |
| Vector / array snapshot (coefficients, FFT bins) | **Array Plot** | `dspsnks4` |

## Time Scope

- After connecting a frame-based signal, set `FrameBasedProcessingString = "Columns as channels (frame based)"`. Default shows a staircase/block display instead of a smooth waveform (same mechanism as the filter InputProcessing trap).
- Accepts scalar, frame, and multichannel signals; handles different frame sizes/rates on separate input ports.

## Spectrum Analyzer

- **Buffers internally.** Do NOT add an external Buffer for a scalar input — connect the scalar signal directly. SA accumulates samples for the spectral estimate on its own.
- **Multiple signals on one display:** set `NumInputPorts = 2` (or more) for before/after comparison — not a Mux into a single port.
- **Spectrogram:** set `ViewType = "Spectrogram"` for time–frequency (waterfall) display.
- **Hz axis:** set `SampleRateSource`/`SampleRate` so the frequency axis is in Hz rather than normalized.
- **FFT length** is set by `FFTLengthSource`/`FFTLength`. It governs frequency resolution (RBW) and is **independent of the signal's frame size** — a larger FFT than the frame is zero-padded; SA does not require FFT length to equal frame size.
- Accepts variable-size input natively (channel count must stay fixed).

## Filter Visualizer

- Shows the **exact analytical** magnitude/phase response from coefficients — no excitation signal needed.
- Connect the coefficient output(s) of a Filter Design block:
  - FIR: `Num → Filter Visualizer`, set `FilterType = "FIR"`.
  - IIR: `Num → Num port`, `Den → Den port`, set `FilterType = "IIR"`.
- Updates live as tunable coefficients change. Supports up to 20 filters.
- **Do NOT build workarounds** (white-noise→filter→SA, or FFT-of-coefficients→Array Plot) — these are noisy, require excitation, and are unnecessary.

See `tunable-filtering.md` for the full Design→Implementation→Visualizer wiring.

## Array Plot

- Static per-frame snapshot (no time history) — ideal for filter coefficients or FFT magnitude bins.
- Configure the x-axis via `XDataMode`/`CustomXData` (e.g. frequency axis for FFT bins).

----

Copyright 2026 The MathWorks, Inc.

----
