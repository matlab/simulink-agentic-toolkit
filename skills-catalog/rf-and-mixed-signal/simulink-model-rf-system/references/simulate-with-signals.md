# Simulate with Real Signals

Drive validated RF models with modulated waveforms and measure system-level metrics.

## rfsystem Simulation (Preferred Path)

```matlab
rfs = rfsystem(b, ModelName='tx_model');
% rfs.SampleTime defaults to 1/(8*b.SignalBandwidth) and sets the CE solver step
% as well as the gateway rate. If you change it, keep headroom between the
% occupied bandwidth and the solver rate. See "Choosing the solver rate" below.

% Scale to target input power
targetPower_dBm = -15;
currentPower_dBm = 10*log10(mean(abs(x).^2) / 1e-3);
x_scaled = x * 10^((targetPower_dBm - currentPower_dBm)/20);

% Simulate with settling padding
y = rfs([x_scaled; zeros(200,1)]);
y = y(201:end);
release(rfs);  % REQUIRED between runs
```

**Critical:** `SampleTime` must match the rate of the vector you actually feed in. Mismatch ->
garbled output, EVM ~100%.

### Choosing the solver rate

`rfs.SampleTime` sets the I/O gateway rate AND the CE solver step together (it writes 1:1 into the
generated model's Configuration block `StepSize`), and a fresh `rfsystem(b)` defaults to
`1/(8 * b.SignalBandwidth)` -- the same 8x production rule as the Configuration block.

**Oversample the waveform; do not feed it at its native rate.** Feeding the waveform at its own
rate (no oversampling) is the one clearly wrong choice: the occupied channel then fills the
solver's entire Nyquist range, content near the band edges is attenuated, and the result is
significant in-band artifacts and an output power that reads low. Leave headroom between the
occupied bandwidth and the solver rate, or use the built-in interpolation filter (see
`references/configuration-block-tools.md`). If accuracy at the band edges is not critical, 2-4x
oversampling is usually good enough, at a fraction of the 8x default's cost.

```matlab
OSR = 4;                                  % 2-4; the 8x default is also fine
xu  = resample(x_scaled, OSR, 1);
rfs.SampleTime = 1/(OSR*Fs);              % matches the vector being fed
yu = rfs(xu); release(rfs);
y  = resample(yu, 1, OSR);                % back to signal rate before demod
```

Matching is still mandatory -- leaving the default `SampleTime` while feeding a native-rate vector
is the worst case of all, because the gateway reinterprets your samples at the solver rate and
stretches the occupied band by the rate ratio, giving apparent tilt across the band and a net loss
of gain. The rule is "`SampleTime` = rate of the vector you feed, **and** that rate oversamples the
occupied bandwidth."

Symptom of getting this wrong: a frequency response far steeper than your filters justify, band
edges collapsing.

**One cheap check is enough -- if the tone is at the band edge.** Cross-check output power against
`b.TransducerGain(end)` with a CW tone offset to ~0.45*BW (not at the carrier): agreement to a
few tenths of a dB means the solver rate is adequate. A carrier-centre tone only verifies gain and
wiring -- solver-step error is zero at 0 Hz offset and grows toward the band edge, where a sharp
filter amplifies it.

**If you still have reason to doubt it** -- the gain does not match, the chain has a sharp filter
right at the band edge, or the result must be defensible rather than merely correct -- these cost
real time, so spend it deliberately and only on the specific doubt:

- compare a measured response against the element's analytic `sparameters(element, f)`
- re-run at a higher OSR and confirm the measurement stops changing

Re-running a full sweep at several oversampling ratios multiplies the simulation cost with no
change in the answer when the gain check already passed. It is a debugging tool for a suspect
result, not a routine confirmation step.

## Staged Verification

Never jump to full-frame simulation. Verify incrementally:

### Stage 1: CW Sanity Check
```matlab
x_cw = ones(1000, 1) * 10^(-20/20);
y_cw = rfs(x_cw); release(rfs);
gain_dB = 20*log10(rms(y_cw(500:end)) / rms(x_cw));
fprintf('Gain: %.1f dB (expected: %.1f dB)\n', gain_dB, expectedGain);
```
If gain is wildly wrong -> connection or frequency mismatch.

### Stage 2: Short Burst (1000 samples)
```matlab
y_short = rfs([x_scaled(1:1000); zeros(100,1)]); release(rfs);
P_out = 10*log10(mean(abs(y_short(100:end)).^2) / 1e-3);
```

### Stage 3: Full Waveform
Only after stages 1-2 pass.

## Power Sweep

```matlab
powerLevels = -30:5:-5;
evmValues = zeros(size(powerLevels));
for i = 1:numel(powerLevels)
    x_scaled = x * 10^((powerLevels(i) - refPower)/20);
    y = rfs([x_scaled; zeros(200,1)]);
    y = y(201:end);
    release(rfs);
    evmValues(i) = measureEVM(x, y);
end
```

## Multicarrier / IMD3

```matlab
rfs.InputFrequency = [2.4e9, 2.5e9];           % 2 carriers -> N×2 input
rfs.OutputFrequency = [2.3e9, 2.4e9, 2.5e9];   % Include IMD3 freq!

x = amp * ones(N, 2);   % One column per carrier
y = rfs(x);             % N×3 output (sorted by frequency)
release(rfs);

P_out = 10*log10(mean(abs(y).^2, 1) / 1e-3);
imd3_dBc = P_out(1) - P_out(2);  % IMD3 relative to carrier
```

**Key:** `OutputFrequency` must explicitly include IMD frequencies. The CE solver
computes all mixing products, but only listed frequencies appear in output.

## Metric Extraction

### Power
```matlab
P_dBm = 10*log10(mean(abs(y).^2) / 1e-3);      % whole solver band
```

With noise ON this integrates thermal noise over the entire solver bandwidth, which is wider than
the signal, so it reads high relative to an `rfbudget` prediction. Band-limit to the occupied
bandwidth before comparing: `10*log10(bandpower(y, Fs, [-BW/2 BW/2])/1e-3)`.

### EVM
```matlab
% Manual (aligned ref and rx symbols)
evmPercent = 100 * rms(rxSymbols - refSymbols) / rms(refSymbols);

% comm.EVM (generic)
evm = comm.EVM(ReferenceSignalSource='Estimated from reference constellation');
evmValue = evm(refConstellation, rxSymbols);
```

### ACLR
```matlab
mainChBW = 20e6; adjChOffset = 20e6;
mainPower = bandpower(y, Fs, [-mainChBW/2, mainChBW/2]);
adjPower = bandpower(y, Fs, [-mainChBW/2, mainChBW/2] + adjChOffset);
aclr_dBc = 10*log10(adjPower / mainPower);
```

## Waveform Generation

### 5G NR
```matlab
cfg = nrDLCarrierConfig;
cfg.FrequencyRange = 'FR1';
cfg.ChannelBandwidth = 20;  % MHz
cfg.CellID = 1;
[waveform, info] = nrWaveformGenerator(cfg);
Fs = info.ResourceGrids.Info.SampleRate;
```

### WLAN 802.11ax
```matlab
cfg = wlanHESUConfig;
cfg.ChannelBandwidth = 'CBW20';
cfg.MCS = 7;
waveform = wlanWaveformGenerator([1;0;1;0], cfg);
Fs = wlanSampleRate(cfg);
```

### LTE
```matlab
cfg = lteTestModel('1.1', '10MHz');
[waveform, ~, info] = lteTestModelTool(cfg);
Fs = info.SamplingRate;
```

### Radar LFM
```matlab
wav = phased.LinearFMWaveform('PulseWidth', 10e-6, ...
    'SweepBandwidth', 5e6, 'SampleRate', 10e6);
waveform = wav();
Fs = wav.SampleRate;
```

## OFDM EVM Measurement

OFDM transmits data on hundreds of subcarriers, each experiencing a different complex
channel gain through any frequency-selective system. Whether scalar equalization gives
acceptable EVM depends on channel flatness.

**Levels of equalization:**

| Approach | What it does | When sufficient |
|----------|-------------|-----------------|
| Delay alignment + scalar H | Removes bulk delay, applies one gain | Flat channels -- quick sanity check |
| Per-subcarrier ZF equalization | Divides each subcarrier by channel estimate | Frequency-selective -- production |

**Delay alignment** is often sufficient to confirm the simulation is working. For many
RF chains with flat in-band response, this alone gives acceptable EVM.

**Per-subcarrier equalization roadmap** (production-quality EVM):

1. Extract complex I+Q output and decimate to signal rate
2. Align received signal to transmitted reference using cross-correlation
3. Use the standard's training symbols for channel estimation:
   - WLAN: HE-LTF via `wlanHEDemodulate(rxLTF, 'HE-LTF', cfg)`
   - 5G NR: DMRS via `nrChannelEstimate`
   - LTE: cell-specific reference signals
4. OFDM-demodulate data symbols and divide by per-subcarrier channel estimate (ZF)
5. Compare equalized symbols to known reference

This per-subcarrier approach is standard receiver processing -- the same equalization
a real receiver performs.

**Discard the startup transient before averaging EVM.** A freshly-stepped `rfsystem` has a
settling transient at the *start* of the output: the leading OFDM symbol, sometimes the next
as well, can show a very large EVM purely from chain start-up, not distortion. Averaged in,
this creates an unphysical EVM floor -- several percent in the linear region, where it should
be a small fraction of a percent -- which hides the true optimal back-off. Always drop the
leading settling symbol(s) before computing RMS EVM (and pad/drop the tail for the end
transient). Drop symbols, not a whole slot: one slot or subframe is enough for EVM, and
lengthening the waveform to discard its first half doubles the Circuit Envelope run time of
every point in a sweep. Sanity
check: at low input power (well below OP1dB) EVM should be near-zero; if the low-power floor
is several percent, you are averaging in a transient, not measuring nonlinearity.

## Simulink Path (sim() with Inport/Outport)

Use when you need explicit Configuration block control or topology changes:

```matlab
in = Simulink.SimulationInput('my_model');
in = setModelParameter(in, 'StopTime', '100e-6');  % NEVER leave default 10 s
in = setExternalInput(in, x_ts);                    % timeseries input, if the model has an Inport
simOut = sim(in);
```

### Feeding the input port — set "Interpolate data" ON

rfsystem exports set an explicit sample time on the top-level **Inport** (independent of the solver
`StepSize`). When you drive the model from the workspace (e.g. `setExternalInput` with a timeseries)
at the signal rate while the solver runs oversampled, Simulink must resample the input onto the
solver grid. Turn the Inport's **"Interpolate data" ON** (Signal Attributes tab, or
`model_edit` `configure` on the Inport with `{"Interpolate":"on"}`). If it is **OFF**, Simulink zero-order-**holds** the input —
repeating samples at scattered instants — which corrupts a band-filling signal *before* it enters
the RF chain and produces a mysterious ~50-70% EVM with no RF cause. (Alternatively supply the input
already at the solver rate.) This is separate from the Configuration block's interpolation filter.

### Outport Signal Extraction (Simulink only)

After downconverting mixer (output at DC), model may have TWO Outport blocks (I and Q):
```matlab
simOut = sim(in);
yout = simOut.get('yout');
rxI = real(yout.get(1).Values.Data);
rxQ = real(yout.get(2).Values.Data);
rxComplex = rxI + 1j*rxQ;
```

If you only extract one port, you lose half the signal and EVM will be ~100%.
Always check `yout.numElements` -- if 2 output ports at DC, they are I and Q.

### Output Rate Conversion

CE solver runs at 1/StepSize (e.g., 640 MHz). Decimate to signal rate:
```matlab
ratio = round((1/stepSize) / signalSampleRate);
rxAtSignalRate = rxComplex(1:ratio:end);
```

## Gotchas (duplicated here for convenience)

- **SampleTime mismatch -> garbled output.** `rfs.SampleTime` MUST equal `1/(rate of the vector you
  feed)`. If they disagree, EVM will be 40-100% (nonsensical). This is the #1 simulation failure.
- **Don't lower `SampleTime` to the waveform's native rate.** `rfsystem(b)` already defaults to
  `1/(8*b.SignalBandwidth)`; that default IS the solver headroom. Overwriting it with `1/Fs` leaves
  no headroom between the occupied band and solver Nyquist, attenuating band-edge content and
  faking a steep in-band response. Resample the waveform up and set `SampleTime` to match the
  upsampled vector, then decimate the output. Cross-check against analytic `sparameters`.
- **release(rfs) between runs.** Without it, internal state accumulates and corrupts results.
  Call `release(rfs)` after EVERY `rfs(x)` call before changing anything.
- **Never leave default StopTime (10 s) on CE models.** CE at GHz carriers = billions of
  steps. Use `rfs(x)` (bounded by input length) or set StopTime on a `Simulink.SimulationInput`.
- **Mid-circuit power measurement changes topology.** An Outport with `SensorType='Power'`
  adds its ZL resistance as a shunt to ground. Use `SensorType='Ideal voltage'` (ZL is
  ignored) for non-disturbing observation. See `references/measure-power-tap.md`.
- **Zero output amplitude.** Check: Outport `CarrierFreq` must match the signal's carrier.
  If `CarrierFreq=0` (default) but signal is at 2.4 GHz, output is zero.

----

Copyright 2026 The MathWorks, Inc.

----
