# Tunable Filtering Architecture (R2023b+)

## Filter Design Blocks (8 blocks)

All in library: `DSP System Toolbox / Filtering / Filter Sources`

| Block name | Filter type | Output ports | Tunable input ports |
|---|---|---|---|
| Lowpass FIR Filter Design | FIR lowpass | Num | N, Fcut |
| Highpass FIR Filter Design | FIR highpass | Num | N, Fcut |
| Bandpass FIR Filter Design | FIR bandpass | Num | N, Fc1, Fc2 |
| Bandstop FIR Filter Design | FIR bandstop | Num | N, Fc1, Fc2 |
| Lowpass IIR Filter Design | IIR lowpass | Num, Den | Fcut |
| Highpass IIR Filter Design | IIR highpass | Num, Den | Fcut |
| Bandpass IIR Filter Design | IIR bandpass | Num, Den | Fc1, Fc2 |
| Bandstop IIR Filter Design | IIR bandstop | Num, Den | Fc1, Fc2 |

### Enabling Tunable Input Ports

Each port is enabled by a checkbox on the block dialog:
- "Specify filter order from input port" → creates **N** port (FIR only)
- "Specify cutoff frequency from input port" → creates **Fcut** port (lowpass/highpass)
- "Specify lower/upper cutoff frequency from input port" → creates **Fc1**, **Fc2** ports (bandpass/bandstop)

### Key Parameters

| Parameter | Default | Notes |
|---|---|---|
| Filter order | 100 | Must be even (FIR); filter length = order + 1 |
| Filter maximum order | 100 | Output Num vector is always length Nmax+1 (zero-padded if actual order < max) |
| Cutoff frequency | 0.5 | Normalized to [0, 1] where 1 = Fs/2 |
| Window function | Hann | Options: Hann, Hamming, Blackman, Blackman-Harris, Chebyshev, Kaiser |
| Sample time | -1 | Inherited; set explicitly if needed |

### Output Format

- **FIR Design blocks:** Num output is a row vector of length Nmax+1
- **IIR Design blocks:** Num output is P×3 matrix (P = number of second-order sections), Den output is P×3 or P×2 matrix

## Implementation Blocks

### FIR: Discrete FIR Filter (DSP)

Library: **`dsparch4/Discrete FIR Filter`** (NOT `simulink/Discrete/Discrete FIR Filter`)

Connection: Design block Num output → Discrete FIR Filter "Coefficients" input (enable "Specify coefficients from input port").

The DSP version defaults InputProcessing to "Columns as channels (frame based)" — no manual override needed. The Simulink version defaults to sample-based and silently produces wrong output.

### IIR: Second-Order Section Filter (R2023b+)

Library: `DSP System Toolbox / Filtering / Filter Implementations`

Connection: Design block Num → SOS Filter "Num" input, Design block Den → SOS Filter "Den" input (set `Coefficient source = "Input ports"`).

Key properties:
- Filter structure: Direct form II transposed (default, recommended)
- InputProcessing: defaults to "Columns as channels (frame based)" — no action needed
- Supports variable-size input signals
- Optionally specify scale values via "g" port

**Do NOT use Biquad Filter** — it is a legacy block being replaced by Second-Order Section Filter.

## Filter Visualizer Connection

Library: `dspsnks4 / Filter Visualizer`

### FIR Filter Visualization

```
[FIR Filter Design] → Num → [Filter Visualizer]
```

Set Filter Visualizer: `Filter Type = "FIR"`, connect Num only.

### IIR Filter Visualization

```
[IIR Filter Design] → Num → [Filter Visualizer (Num port)]
                    → Den → [Filter Visualizer (Den port)]
```

Set Filter Visualizer: `Filter Type = "IIR"`, `Num Filters = 1`.

### Display Options

- Magnitude response (dB, linear, or squared)
- Phase response
- Both on separate axes (click "Magnitude Phase" button)
- Sample rate: set to match your system Fs for Hz display
- Up to 20 filters simultaneously

## Parameter Smoother

Library: `DSP System Toolbox / Signal Operations`
Block: **Parameter Smoother**
System object: `dsp.ParameterSmoother` (R2024a)

### Purpose

Prevents audio clicks/artifacts when filter parameters change abruptly during simulation.
Applies exponential smoothing: `g[n] = α·g[n-1] + (1-α)·t[n]`

### Connection Pattern

```
[Constant/Slider] → [Parameter Smoother] → Fcut port → [Filter Design block]
```

### Key Parameters

| Parameter | Default | Notes |
|---|---|---|
| Number of parameters | 1 | Set to match number of tunable parameters |
| Smoothing mode | "Smoothing factor" | Or "Smoothing time" |
| Smoothing factor (α) | 0.6 | Range [0, 1). Higher = slower, smoother transition |
| Smoothing time (τ) | 10 s | When mode = "Smoothing time" |

### Behavior

- α = 0: no smoothing (instant change)
- α → 1: very gradual transition (many filter redesigns during transition)
- One time constant τ: parameter reaches ~63% of target value

### Alternative: Built-in Smoothing on Design Blocks (R2024a)

Filter Design blocks have a checkbox: **"Smooth tuned filter parameters"** with a smoothing factor field. This applies smoothing to the coefficient output directly, without needing a separate Parameter Smoother block. Use this when:
- You only need smoothing on the coefficient output (not the raw parameter)
- You want fewer blocks in the model

Use standalone Parameter Smoother when:
- You need to smooth parameters feeding into blocks other than Filter Design
- You need independent smoothing factors per parameter
- You want the smoothing factor itself to be tunable from an input port

## Decision Tree: Which Pattern to Use

```
Need runtime-tunable cutoff/bandwidth?
├── YES: Need IIR (shorter filter / tighter transition)?
│   ├── YES: IIR Filter Design → Second-Order Section Filter
│   └── NO: Need advanced control (filter order, window type)?
│       ├── YES: FIR Filter Design → Discrete FIR Filter
│       └── NO: Variable Bandwidth FIR Filter (simpler, self-contained)
└── NO: Static filter (coefficients don't change)?
    ├── YES: Discrete FIR Filter with workspace coefficients
    │         (set Numerator = fir1(...) in dialog or mask init)
    └── Need frequency response visualization?
        ├── YES: Use two-block pattern anyway (Filter Visualizer connects to Design block)
        └── NO: Discrete FIR Filter or dspfdesign/Lowpass Filter (monolithic)
```

## Complete Model Example (Tunable Lowpass FIR)

```
[From Multimedia File] ─────────────────────────────── → [Spectrum Analyzer port 1 (input)]
         │
         └──→ [Discrete FIR Filter] ──→ [Time Scope]
                     ↑ Num                    ↓
              [Lowpass FIR Filter Design] → [Filter Visualizer]
                     ↑ Fcut
              [Parameter Smoother]
                     ↑
              [Dashboard Slider]
```

**Required settings:**
- From Multimedia File: `AudioFrameSize` (dialog: "Samples per audio channel") = desired frame size
- Discrete FIR Filter: `InputProcessing = "Columns as channels (frame based)"`, "Specify coefficients from input port" = on
- Lowpass FIR Filter Design: "Specify cutoff frequency from input port" = on, set Fs-appropriate max order
- Time Scope: `FrameBasedProcessingString = "Columns as channels (frame based)"`
- Spectrum Analyzer: `NumInputPorts = 2` for before/after comparison
- Solver: Fixed-step, Discrete

----

Copyright 2026 The MathWorks, Inc.

----
