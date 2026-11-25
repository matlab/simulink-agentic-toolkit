# Build from Budget Specs

Export an rfbudget chain to Simulink for Circuit Envelope or Idealized Baseband simulation.

## Export Paths

| Need | Method | Result |
|------|--------|--------|
| Programmatic simulation (`y = rfs(x)`) | `rfsystem(b)` | System Object wrapping CE model |
| Simulink model to customize | `exportRFBlockset(b)` | Open model with full source/output chain |
| Self-contained measurement testbench | `exportTestbench(b)` | DUT + Testbench RF-to-IQ block |
| Multi-chain array | `rfsystem(b, Rx=N)` or `Tx=N` | Auto Wilkinson splitters/combiners |

**Default choice: `rfsystem`** -- simplest interface, modifiable, supports multi-chain.
Handles chains of any complexity (10+ stages routinely).

### What `rfsystem(b)` already did for you

`rfsystem(b)` returns a **complete, simulating** model. Two consequences worth knowing
before you go looking for more work:

- **The Configuration block is already set** -- `Tones` from the budget's carriers,
  `Harmonics`, and `SampleTime` defaulted to `1/(8 x SignalBandwidth)`, which writes
  through to solver `StepSize`. You do not need to compute or re-derive these. Reach for
  `configuration-block.md` only when you are deliberately changing solver behaviour
  (accuracy sweeps, interpolation filter, small-signal approximation).
- **`Gain`/`NF`/`OIP3` given in the budget are already in the exported blocks** -- they are
  specifications, not impairments, and `rfbudget` has applied them. `impairment-catalog.md`
  is for impairments the budget cannot express (phase noise, IQ imbalance, LO leakage,
  memory-polynomial PA), added deliberately one at a time. A chain whose spec is just
  gain / NF / OIP3 per stage needs nothing from it.

Verify what you got with one short `rfs(x)` and move on; re-deriving settings `rfsystem`
has already made is the most common way a straightforward build turns long.

## rfbudget Element Constructors

| Constructor | CE Block Export | Key Properties |
|-------------|---------------|----------------|
| `amplifier(...)` | simrfV2elements/Amplifier | Gain, NF, OIP3, OP1dB, Zin, Zout |
| `modulator(...)` | simrfV2systems/IQ Demodulator (or Modulator) | Gain, NF, OIP3, LO, ConverterType, Sideband |
| `mixerIMT(...)` | simrfV2elements/IMT Mixer | ReferenceInputPower, NominalOutputPower (not Gain) |
| `rfantenna(...)` | simrfV2elements/Antenna | Type, Gain (scalar or [TxGain, RxGain]) |
| `nport('file.s2p')` | simrfV2elements/S-parameters | NetworkData (from Touchstone file) |
| `rffilter(...)` | simrfV2elements/Filter | FilterType, ResponseType, FilterOrder, PassbandFrequency |
| `rfelement(...)` | Generic element | Custom Gain, NF, IP3 (no physical model) |

**Rules:**
- Elements cannot be reused -- use `clone(element)` for independent copies
- Element Name must be a valid MATLAB identifier (no spaces)
- `nport` Name is positional: `nport('file.s2p', 'MyName')`
- `rffilter`: `ResponseType` is shape (Bandpass), `FilterType` is algorithm (Butterworth)
- `mixerIMT` uses `ReferenceInputPower`/`NominalOutputPower`, not `Gain`

### Choosing the mixer element

For a **down-conversion mixer specified by gain / NF / OIP3** -- including every
direct-conversion (zero-IF) receiver -- use `modulator(Gain=, NF=, OIP3=, LO=,
ConverterType='Down')`. It exports to `simrfV2systems/IQ Demodulator`, which models
conversion gain, noise and nonlinear compression, and it is the element that works at
`OutputFrequency = 0`.

Reach for `mixerIMT` only when the task actually gives you an **intermodulation table**
(a spur matrix in dBc, or an `.s2d` file). Its interface differs in ways that cost time if
you assume it behaves like `modulator`:

| | `modulator` | `mixerIMT` |
|---|---|---|
| Gain | `Gain=-6` | not accepted -- gain is implied by `NominalOutputPower - ReferenceInputPower` |
| `OIP3=` at construction | accepted | **rejected** -- `Invalid argument name 'OIP3'`; settable only as a property afterwards |
| Conversion direction | `ConverterType='Down'` | `Model='demod'` (only `'mod'`/`'demod'`; `ConverterType` maps onto it) |
| Zero IF in `rfbudget` | works | **errors**: "does not support input or output frequency set to 0" |

So a zero-IF chain cannot be budgeted with `mixerIMT` at all. If a task needs IMT spurs
*and* zero IF, budget the chain with `modulator`, then swap the exported block for
`simrfV2elements/IMT Mixer` and set `UserSpurValues` on it directly (see
`ce-block-parameters.md` § IMT Mixer).

## What exportRFBlockset Generates

A single `exportRFBlockset(b)` creates a complete, simulatable model with:
- **Configuration block** -- pre-configured with Tones, Harmonics from rfbudget
- **Source chain** -- Constant(-30 dBm) -> dBm-to-Linear -> Inport -> Thermal Noise
- **RF element chain** -- all elements wired in cascade
- **Output chain** -- RF Outport(s) -> Linear-to-dBm -> Display
- **Element names preserved** from rfbudget (e.g., `Name='LNA'` -> block named "LNA")

## rfsystem Usage

```matlab
rfs = rfsystem(b, ModelName='rx_model');
% Default SampleTime = 1/(8*b.SignalBandwidth). Feed a vector at THAT rate;
% only set SampleTime yourself if the new value is >= the default.
waveformSampleRate = 1/rfs.SampleTime;

% Simulate
x = 0.01 * exp(1j*2*pi*1e6*(0:499)'/waveformSampleRate);
y = rfs(x);
release(rfs);  % REQUIRED between runs
```

**Critical rules:**
- Call `release(rfs)` before ANY model operation (edit, save, close, re-simulate with changes)
- Set `SampleTime` to match the rate of the vector you feed, before the first call
- `SampleTime` sets the CE solver step as well as the I/O gateway rate -- it writes 1:1 into the
  generated model's Configuration block `StepSize`. A fresh `rfsystem(b)` defaults to
  `1/(8 * b.SignalBandwidth)` (160 MHz for a 20 MHz budget), which is the 8x solver headroom
  already applied for you.
- **Keep solver-rate headroom above the occupied bandwidth.** Resample a band-filling waveform UP
  and set `SampleTime` to match the upsampled vector. Dragging `SampleTime` down to the native
  waveform rate leaves the occupied band filling the solver's whole Nyquist range, attenuating
  band-edge content and fabricating a steep in-band response. The 8x default is safe; 2-4x is
  usually adequate and cheaper.

## Model Persistence

The rfsystem object stores a reference to the underlying Simulink model, but does NOT
embed it in .mat files.

```matlab
% After modifications -- ALWAYS save both:
save_system(rfs.ModelName);  % Saves .slx
save('workspace.mat');       % Saves rfsystem + rfbudget

% On reload: .slx must be on path, or rfsystem regenerates from rfbudget (losing mods)
```

**Always use explicit ModelName** and save .slx alongside workspace.

## Multi-Chain Arrays

```matlab
% 4-element MISO receiver (diversity combining)
rfs_rx = rfsystem(b, ModelName='rx_4chain', Rx=4);

% 16-element SIMO transmitter (beamforming)
rfs_tx = rfsystem(b_tx, ModelName='tx_16chain', Tx=16);
```

- `Rx=N` -> N input chains + Wilkinson Combiners
- `Tx=N` -> Wilkinson Divider + N output chains
- Cannot set both simultaneously
- `Rx=N` calling convention: `y = rfs(x1, x2, ..., xN)` (separate arguments, NOT a matrix)
- `Tx=N` calling convention: `[y1, ..., yN] = rfs(x)` (single input, N outputs)

For mid-chain taps on a single chain, do not repurpose an array: add the tap with
`model_edit` and expose it with `rfs.SLOutputs` (`references/multi-port-models.md`,
Pattern D).

### Per-Element Phase Shifters (phased array)

An `Rx=N` array names its chains `LNA`, `LNA1`, ... `LNA(N-1)` at the root and merges them
through `WilkinsonCombiner1` (input port `k` per chain). To make each element's phase
**individually settable**, insert one unit-magnitude complex gain per chain. In the
**Idealized Baseband** domain the signal is complex baseband, so an ideal variable phase
shifter is simply `Gain = exp(1j*theta_k)` -- no RF phase-shifter block needed.

Store the phases in the MODEL workspace so the model is self-contained:

```matlab
mws = get_param(modelName, 'ModelWorkspace');
assignin(mws, 'psDeg', zeros(1, N));   % per-element phase (deg)
```

Then one `model_edit` call (block IDs from `model_read`; pass the JSON on one line): for
each chain `k`, add a Gain `exp(1j*pi/180*psDeg(k))`, connect the chain's last block to
it, and connect it to combiner input `uk`. `connect` replaces the existing
LNA → combiner line, so no separate `disconnect` is needed. Use the numeric combiner port
(`u1` ... `uN`); `model_read` lists them as `Inport`, `Inport1`, .... For N = 4, the first
chain:

```json
[{"op":"add_block","type":"simulink/Math Operations/Gain","name":"PhaseShifter1","ref":"p1",
  "params":{"Gain":"exp(1j*pi/180*psDeg(1))"}},
 {"op":"connect","target":"<LNA id>.y1 -> #p1.u1"},
 {"op":"connect","target":"#p1.y1 -> <WilkinsonCombiner1 id>.u1"}]
```

and the same three operations for `LNA1` → `PhaseShifter2` → `u2`, and so on, in the same
call. Check (verified, `Rx=4`, same input on every element): all phases 0 gives the
coherent sum, 6 dB above one chain; phases `[0 90 180 270]` cancel to the noise floor.

(`exp(1j*...)` complex gain is Idealized-Baseband-only; in Circuit Envelope use
`simrfV2elements/Variable Phase Shift` from the library instead.)

**Before creating:** Delete existing .slx and .s2p files to prevent modal dialogs:
```matlab
modelName = 'rx_array';
clear rfs   % releasing/clearing the old rfsystem object turns Fast Restart off
if bdIsLoaded(modelName), close_system(modelName, 0); end
if exist([modelName '.slx'], 'file'), delete([modelName '.slx']); end
delete('*.s2p');  % Wilkinson, rffilter, and other generated .s2p files
rfs = rfsystem(b, ModelName=modelName, Rx=16);
```

## Modifying Generated Models

`release(rfs)`, then edit `rfs.ModelName` with the `model_edit` tool (block IDs from
`model_read`). The next `rfs(x)` simulates the edited model; saving first is not required
(verified).

```matlab
rfs = rfsystem(b, ModelName='rx_custom');
release(rfs);
% ... model_edit calls on 'rx_custom' ...
y = rfs(x);                  % uses the modified model
save_system('rx_custom');    % keep the edits on disk
```

Keep the ORIGINAL rfs object -- do NOT create a new `rfsystem()` (regenerates from scratch).

## rfbudget as Validation Oracle

Starting from rfbudget gives a free validation reference at every cascade stage:

```matlab
b = rfbudget([lna bpf mix ifamp], 2.4e9, -30, 20e6);
% Budget properties (NOT element properties):
%   b.TransducerGain  -- cumulative gain at each stage
%   b.NF              -- cumulative noise figure
%   b.OIP3            -- cumulative output IP3
%   b.OutputPower     -- output power at each stage
```

After export, simulated results should match budget predictions. Discrepancies reveal
misconfigured impairments or frequency alignment issues.

## rfantenna Limitation

`rfsystem` fails when `rfantenna` is first or last element
(`"Invalid Simulink object name: '<ModelName>/Inport1'"`). Use `exportRFBlockset(b)`
instead -- it handles all element types and produces a valid CE model.

```matlab
ant = rfantenna(Type='Receiver', Name='RxAnt');
lna = amplifier(Name='LNA', Gain=15, NF=2, OIP3=20);
b = rfbudget([ant lna], 2.4e9, -30, 20e6);
mdl = exportRFBlockset(b);  % Works (rfsystem would fail)
save_system(mdl, 'my_rx');
```

## Multi-Path Architectures (Quadrature, Image-Reject, Diversity)

Architectures with parallel signal paths MUST be built inside the CE model using
`model_edit` -- not as external MATLAB post-processing.

**Why:** The CE Inport is mathematically a perfect IQ modulator; the CE Outport is a
perfect IQ demodulator. For most systems where the focus is on RF components (LNA, PA,
filters), this perfect abstraction is correct. Build explicit IQ mod/demod hardware
(from `simrfV2systems` library or via `model_edit` with parallel modulators) ONLY when
the user asks about image rejection quality, IQ imbalance effects, or the
modulator/demodulator architecture itself.

External math (e.g., frequency-domain sideband filtering) loses physical effects --
mismatch, phase error, spur interaction -- that are the reason for using CE.

### Image Rejection and IR/CS Filter Behavior

The exported Demodulator block (`simrfV2systems/Demodulator`) includes an IR (Image-
Reject) lowpass filter that is ON by default (`AddIRFilter: on`). This filter selects
the correct mixing sideband based on the relationship between `InputFrequency` and the
mixer LO.

**Critical insight: IR/CS filters adapt to InputFrequency.** When you change
`rfs.InputFrequency`, the system reconfigures which sideband the IR filter passes. This
means you CANNOT measure image rejection by running two separate simulations at
different InputFrequency values -- both will produce identical output because the filter
adapts each time.

**Wrong (gives 0 dB):**
```matlab
% DON'T DO THIS -- filter flips direction for each frequency
rfs.InputFrequency = 2.45e9;   y_desired = rfs(x); release(rfs);
rfs.InputFrequency = 2.446e9;  y_image   = rfs(x); release(rfs);
20*log10(rms(y_desired)/rms(y_image))  % Always ~0 dB
```

**To measure or demonstrate image rejection, use multi-carrier input** so both RF
frequencies are present as separate CE solver tones:

```matlab
% Low-IF receiver: desired at 2.45 GHz, image at 2.446 GHz, LO at 2.448 GHz
lna = amplifier(Name='LNA', Gain=15, NF=1.5, OIP3=18);
demod = modulator(Name='Demod', Gain=-6, NF=10, OIP3=15, ...
    LO=2.448e9, ConverterType='Down');
ifamp = amplifier(Name='IF_Amp', Gain=30, NF=5, OIP3=30);
b = rfbudget([lna demod ifamp], 2.45e9, -30, 20e6);
rfs = rfsystem(b, ModelName='low_if_rx');

% Set two carriers: desired + image
release(rfs);
rfs.InputFrequency = [2.45e9, 2.446e9];  % N×2 input required
rfs.SampleTime = 1/100e6;

N = 4000;
nCols = numel(rfs.InputFrequency);  % 2 columns
freqs = rfs.InputFrequency;          % sorted: [2.446e9, 2.45e9]
[~, desiredCol] = max(freqs);        % higher freq = desired
[~, imageCol]   = min(freqs);        % lower freq = image

% Feed desired carrier only -> measure output
x_des = zeros(N, nCols);
x_des(:, desiredCol) = 0.01;
y_des = rfs(x_des); release(rfs);

% Feed image carrier only -> measure output
x_img = zeros(N, nCols);
x_img(:, imageCol) = 0.01;
y_img = rfs(x_img); release(rfs);

IRR_dB = 20*log10(rms(y_des)/rms(y_img));  % Expect 40-80 dB
```

**Why multi-carrier works:** The CE solver tracks each carrier as a separate frequency
envelope. The mixer and IR filter operate on the actual RF signals at their true
frequencies, naturally rejecting the image sideband.

**Why single-carrier ±f baseband does NOT work:** The IR filter is a lowpass that
rejects the RF+LO sum frequency (~4.9 GHz), not a polyphase filter that distinguishes
±IF at baseband. Setting `InputFrequency = LO` and feeding `exp(±j*2π*IF*t)` gives
0 dB -- both tones pass the lowpass identically.

## Simulation Duration Control

**Always prefer `y = rfs(x)` over `sim(model)`** -- simulation length equals input
vector length, naturally bounded.

CE simulation cost scales with `StopTime x carrier_frequency x harmonics` -- even 1 ms
at 2.4 GHz can take minutes. For quick verification, 2000-4000 samples is sufficient
(20-40 us at 100 MHz Fs).

If you must use `sim()` directly, **always set StopTime explicitly** on a `Simulink.SimulationInput`:
`out = sim(setModelParameter(Simulink.SimulationInput(model), 'StopTime', '1e-6'))` -- never leave
the default 10 s.

A stuck simulation (> 60 s with no output) almost always means StopTime is too long.

## Avoiding Modal Dialogs

Modal dialogs block execution with no recovery:
- Before `new_system`: `release(rfs)` (or `clear rfs`) for any old rfsystem object of that
  model, then `if bdIsLoaded('m'); close_system('m',0); end; if exist('m.slx','file'); delete('m.slx'); end`
  -- a model still initialized in Fast Restart throws "Cannot close ... initialized in Fast
  Restart"; releasing or clearing its rfsystem object turns Fast Restart off. If no object is
  left, use `model_edit` `configure` on target `config:<model>` with `{"FastRestart":"off"}`.
- Before `rfsystem` or `exportRFBlockset`: `delete('*.s2p')` -- rffilter and Wilkinson
  elements generate .s2p files that trigger "already exists" dialogs on re-creation
- Use `close_system(model, 0)` (not `bdclose`) -- the `0` skips save prompts
- Use unique model names or delete existing `.slx` files before creating

## ACPR / Spectral Regrowth Measurement

To observe ACPR degradation from PA nonlinearity:
- Test signal must be bandlimited to the main channel
- Input power must be swept from well below IIP3 up to near IIP3
  (where IIP3 = OIP3 - Gain for the PA element)
- Only power levels approaching IIP3 produce visible spectral regrowth

## Gotchas (duplicated here for convenience)

- **Configuration block must be wired.** Wire `Config.LConn1 <-> anyNetworkNode`. Without
  this: "Each physical network must be connected to exactly one Solver Configuration block."
- **Use full library paths.** `simrfV2elements/Amplifier`, not `"Amplifier"`. Short names
  resolve to the wrong block (76% confidence match -> wrong block type).
- **Port names in model_edit.** Use `LConn1`, `RConn1` (actual port names), not model_read
  aliases like `y1`, `l1`. Wrong names -> `PORT_NOT_FOUND` error.
- **CW Source Power mode needs Z0.** Set `Z0` to `"50"` (not 0). Zero impedance ->
  "Expected Resistance in CW source to be positive."
- **RF Outport needs a Simulink Outport.** The RF Outport converts to Simulink domain, but
  you still need a regular Outport block connected to `rfout.y1` to get data to workspace.
- **Forgetting release(rfs) before model ops.** Fast Restart lock blocks `close_system`,
  `model_edit`, `save_system`. Always call `release(rfs)` before ANY model operation.
- **Saving workspace without saving .slx.** Model modifications lost on reload. Always
  `save_system(rfs.ModelName)` and keep .slx alongside .mat.
- **Mid-circuit power measurement.** If adding observation points to verify the chain,
  use `SensorType='Ideal voltage'` with `ZL='Inf'`. A Power sensor adds 50 Ohm shunt
  that changes gain/impedance of the entire downstream chain.

----

Copyright 2026 The MathWorks, Inc.

----
