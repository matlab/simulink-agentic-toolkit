# Post-Processing and Measurement (Cross-Toolbox Reference)

## License Check Pattern

```matlab
has5G   = ~isempty(ver('5g'));
hasLTE  = ~isempty(ver('lte'));
hasWLAN = ~isempty(ver('wlan'));
hasComm = ~isempty(ver('comm'));
hasSP   = ~isempty(ver('signal'));
```

---

## EVM Measurement

### 5G NR EVM (requires: 5G Toolbox)

```matlab
% Check: ~isempty(ver('5g'))
% After simulation: y = rfsystem output (complex baseband)
% Align output to reference using cross-correlation, then:
evm = comm.EVM(ReferenceSignalSource='Estimated from reference constellation', ...
    Normalization='Average constellation power');
evmRMS = evm(y_aligned);  % percent

% OR: full demodulation pipeline
[pdschIndices, ~] = nrPDSCHIndices(carrier, pdsch);
rxGrid = nrOFDMDemodulate(carrier, y_aligned);
rxSymbols = rxGrid(pdschIndices);
refSymbols = nrPDSCH(carrier, pdsch, cws);
evmRMS = rms(rxSymbols - refSymbols) / rms(refSymbols) * 100;
```

**Channel-estimate self-cancellation trap (gives a false EVM = 0).** If a frequency-selective chain
needs equalization, do NOT form the channel estimate as the full-grid ratio of received to reference,
`H = rxGrid ./ refGrid`, and then equalize with it — that divides the received signal by itself and
**trivially nulls all distortion and noise, yielding EVM ≈ 0.0000%** (a red flag, not a good result).
Estimate the channel only from **pilots / reference signals** (or by averaging `rxGrid./refGrid`
across OFDM symbols per subcarrier so noise/distortion survive), then apply that estimate to the data
symbols. A correct EVM is a small nonzero number; an exact 0 means you equalized with the answer.

### WLAN EVM (requires: WLAN Toolbox)

```matlab
% Check: ~isempty(ver('wlan'))
ind = wlanFieldIndices(cfg);

% Channel estimation from HE-LTF (known TX as reference)
txLTF = wlanHEDemodulate(txWaveform(ind.HELTF(1):ind.HELTF(2)), 'HE-LTF', cfg);
rxLTF = wlanHEDemodulate(y_aligned(ind.HELTF(1):ind.HELTF(2)), 'HE-LTF', cfg);
chanEst = rxLTF ./ txLTF;  % per-subcarrier channel estimate

% Demodulate and equalize data symbols
txData = wlanHEDemodulate(txWaveform(ind.HEData(1):ind.HEData(2)), 'HE-Data', cfg);
rxData = wlanHEDemodulate(y_aligned(ind.HEData(1):ind.HEData(2)), 'HE-Data', cfg);
rxEq = rxData ./ chanEst;  % ZF equalization

% EVM
evmRMS = 100 * rms(rxEq(:) - txData(:)) / rms(txData(:));
```

### Generic EVM (requires: Communications Toolbox)

```matlab
% Check: ~isempty(ver('comm'))
evm = comm.EVM(ReferenceSignalSource='Estimated from reference constellation', ...
    ReferenceConstellation=qammod(0:63, 64, UnitAveragePower=true), ...
    Normalization='Average constellation power');
evmRMS = evm(rxSymbols);  % percent
```

### Manual EVM (requires: nothing)

Use when no toolbox provides EVM measurement. Works for any constellation.

```matlab
% txSymbols: transmitted reference symbols (complex vector)
% rxSymbols: received symbols after equalization (same length)
% Both must be aligned in time and equalized

evmRMS = rms(rxSymbols - txSymbols) / rms(txSymbols) * 100;  % percent
```

**Equalization (ZF):** When channel estimation is not available from a standard-specific toolbox, use a simple pilot-based approach:

```matlab
% For OFDM: use known pilot subcarriers or preamble
% H_est = rxPilots ./ txPilots;          % LS channel estimate at pilots
% H_interp = interp1(pilotIdx, H_est, allIdx, 'linear');  % interpolate
% rxEq = rxSymbols ./ H_interp;          % zero-forcing equalization
```

---

## ACLR Measurement

### Using comm.ACPR (requires: Communications Toolbox)

```matlab
% Check: ~isempty(ver('comm'))
acpr = comm.ACPR(SampleRate=Fs, ...
    MainChannelFrequency=0, ...          % baseband center
    MainMeasurementBandwidth=signalBW, ...
    AdjacentChannelOffset=[-signalBW, signalBW], ...
    AdjacentMeasurementBandwidth=[signalBW, signalBW]);
aclr_dBc = acpr(y_output);              % [lower, upper] in dBc
release(acpr);
```

### Manual ACLR from PSD (requires: Signal Processing Toolbox)

```matlab
% Check: ~isempty(ver('signal'))
[psd, f] = pwelch(y_output, hann(1024), 512, 1024, Fs, 'centered');
psd_dBm = 10*log10(psd) + 30;

% Define channels
mainIdx = abs(f) <= signalBW/2;
adjLowIdx = f >= -1.5*signalBW & f <= -0.5*signalBW;
adjHighIdx = f >= 0.5*signalBW & f <= 1.5*signalBW;

mainPower = trapz(f(mainIdx), psd(mainIdx));
adjLowPower = trapz(f(adjLowIdx), psd(adjLowIdx));
adjHighPower = trapz(f(adjHighIdx), psd(adjHighIdx));

aclr_lower_dBc = 10*log10(adjLowPower / mainPower);
aclr_upper_dBc = 10*log10(adjHighPower / mainPower);
```

### Manual ACLR from FFT (requires: nothing)

```matlab
N = length(y_output);
Y = fft(y_output) / N;
f = (-N/2:N/2-1) * (Fs/N);
Y = fftshift(Y);
psd = abs(Y).^2;

% Integrate over channel bands (same index logic as above)
mainIdx = abs(f) <= signalBW/2;
adjIdx = f >= 0.5*signalBW & f <= 1.5*signalBW;
aclr_dBc = 10*log10(sum(psd(adjIdx)) / sum(psd(mainIdx)));
```

---

## BER Measurement

For a BER measurement the RF-Blockset-specific steps are: enable noise (Configuration `AddNoise`
`'on'` — a delivered model may have it off from a prior deterministic measurement), scale + drive
`y = rfs(x)`, and time-align the output (`finddelay`/`circshift` for the chain's bulk delay). The
demodulation itself is standard-specific — **defer it to the waveform's toolbox** and keep the
demod SIMPLE.

### LTE / 5G NR / WLAN — defer demod to the toolbox, keep it simple

Do NOT hand-build a full standard receiver. Use the toolbox's own demod + equalize, then `biterr`:

```matlab
% LTE (requires LTE Toolbox) — simplest sufficient path for an in-the-loop BER:
rxGrid = lteOFDMDemodulate(enb, y_aligned);
[hEst, nEst] = lteDLChannelEstimate(enb, rxGrid);      % channel from built-in reference signals
eqGrid = lteEqualizeMMSE(rxGrid, hEst, nEst);          % per-subcarrier equalization (frequency-selective chain)
rxSym  = eqGrid(ltePDSCHIndices(enb, enb.PDSCH, (0:enb.NDLRB-1)'));
rxBits = lteSymbolDemodulate(rxSym, modulation, 'Hard');
[~, ber] = biterr(txBits, rxBits);                     % uncoded (pre-FEC) symbol-bit BER
```

**Levels of LTE modeling fidelity** — pick the lightest that answers the question:
1. **Simplest (use this for an RF in-the-loop BER):** OFDM-demodulate → reference-signal channel
   estimate → per-subcarrier equalize → hard symbol-demod → `biterr`. Good enough to see the RF
   chain's effect on BER; a rough demod already discriminates a working vs mis-configured chain.
2. **Full receiver (only if you truly need coded/link performance):** add `lteExtractResources` to
   pair symbols with the channel estimate, `ltePDSCHDecode` + `lteDLSCHDecode` for post-FEC BER,
   PDCCH/DCI recovery, etc. This is standard LTE-Toolbox receiver work — belongs in a comms/LTE
   skill, not here. Reaching for it on a first-pass RF BER usually over-engineers the task.

The RF-simulation skill's job is the noise/drive/alignment; the standard's toolbox does the demod.

### Using biterr (requires: Communications Toolbox)

```matlab
% Check: ~isempty(ver('comm'))
% After demodulation to bits:
[numErrors, ber] = biterr(txBits, rxBits);
```

### Manual BER (requires: nothing)

```matlab
numErrors = sum(txBits ~= rxBits);
ber = numErrors / numel(txBits);
```

### Hard decision demodulation (manual, for QAM)

```matlab
% For M-QAM, hard-decision demod without Communications Toolbox:
k = sqrt(M);
re_dec = round((real(rxSymbols) * sqrt(2*(M-1)/3) + (k-1)) / 2);
im_dec = round((imag(rxSymbols) * sqrt(2*(M-1)/3) + (k-1)) / 2);
re_dec = max(0, min(k-1, re_dec));
im_dec = max(0, min(k-1, im_dec));
rxBitsI = de2bi(re_dec, log2(k), 'left-msb');
rxBitsQ = de2bi(im_dec, log2(k), 'left-msb');
rxBits = reshape([rxBitsI, rxBitsQ].', [], 1);
```

---

## Signal Extraction from CE Simulink Models

### I+Q Reconstruction

rfsystem-exported models with a downconverting mixer produce **two output ports** at `CarrierFreq=0`: I (in-phase) and Q (quadrature). Each port outputs a real-only signal. Reconstruct the full complex baseband:

```matlab
simOut = sim(in);   % in: Simulink.SimulationInput with a finite StopTime
yout = simOut.get('yout');
rxI = real(yout.get(1).Values.Data);  % In-phase channel
rxQ = real(yout.get(2).Values.Data);  % Quadrature channel
rxComplex = rxI + 1j*rxQ;            % Full complex baseband
```

**Critical:** If you only extract one port, EVM for complex-modulated signals (QAM, OFDM) will be ~100%.

### Rate Conversion (decimating solver output to the signal rate)

The CE output is uniformly sampled at the solver rate; bring it back to the signal rate before
comparison. **Prefer plain downsampling — keep every N-th sample — over filtered decimation
(`resample`/`decimate`):**

```matlab
ratio = round(solverRate / signalRate);  % e.g., 640e6/80e6 = 8
rxAtSignalRate = downsample(rxComplex, ratio);   % == rxComplex(1:ratio:end)
```

Filtered decimation (`resample`, `decimate`) applies an **anti-aliasing (AA) lowpass filter**
before dropping samples. That is only useful when there is genuine energy *above* the new Nyquist
to reject (e.g. broadband solver noise or nonlinear products with a **partial-band** signal). When
the signal **fills most of its band** (a wideband waveform occupying ~all of ±signalRate/2), the AA
filter's transition band bites into the signal's own edges and **distorts them** — inflating EVM
for a reason that has nothing to do with the RF chain. So: `downsample` for band-filling signals;
reserve `resample`/`decimate` for partial-band signals with real out-of-band content to remove.

### Extract at the solver rate — decimate in MATLAB

Terminology: the **top-level Simulink output port** (`BlockType=Outport`, e.g. `Out1`) is a
different block from the **RF Blockset Outport gateway** (`MaskType=Outport`, e.g. `Outport1`). The
gateway senses the envelope from the physical network; the top-level Simulink port carries the
signal out of the model and is where the solver-rate -> port-rate reduction happens.

An rfsystem export sets an explicit sample time on that **top-level Simulink Outport**. If it is set
below the solver rate (e.g. to the signal rate), the model reduces the rate by a **plain
sample-and-hold** — no anti-alias filter, and it effectively forces decimation **phase 0**. Phase 0
is usually NOT the phase aligned with the chain's (fractional) group delay, so EVM is badly inflated
for a non-physical reason (e.g. 45% vs ~2%) with no post-hoc fix.

**Set the top-level Simulink Outport sample time to `1/StepSize` (the solver rate)**, extract the
full-rate output, and decimate yourself in MATLAB (below) where you control the decimation phase /
fractional-delay removal. The input Inport can stay at the signal rate (with "Interpolate data" on,
see `simulate-with-signals.md`); only the output port needs raising to the solver rate.

### Time Alignment — the RF chain's group delay is usually FRACTIONAL

After decimation the output is delayed relative to the input by the chain's group delay. That delay
is generally **not an integer number of signal-rate samples** (a filter's group delay is a physical
time, e.g. 80.25 samples). An integer cross-correlation shift (`finddelay`+`circshift`) removes only
the whole-sample part; the leftover **fractional-sample** delay is a linear phase ramp across the
band that a single complex gain cannot fix, and it **dominates EVM** (e.g. 45% vs ~2%) even when the
chain is otherwise clean.

The fractional group delay IS a real, if mild (linear-phase), RF impairment — you can legitimately
leave it in when characterizing the chain, but then it swamps the EVM and tells you little. The
conventional choice is to remove it the same way you already remove the bulk integer delay: this is
exactly what a receiver's timing recovery does, so removing delay (integer + fractional) is a benign
alignment step that **keeps the frequency-selective dispersion visible**. (Contrast full
equalization, Option C, which also divides out the dispersion and thus masks the RF impairments.)
So: if you remove the whole-sample delay for EVM, remove the fractional part too. Two robust ways —
both extract the output at the **solver rate** (Outport set to `1/StepSize`), which is why you raise
the output port rate rather than let the model sample-and-hold to the signal rate:

**Option A — decimation-phase search (no reference resampling).** The `ratio` decimation phases of
the solver-rate output are copies offset by `p/ratio` of a signal-rate sample, i.e. a built-in set
of fractional shifts. Try all phases, keep the best:

```matlab
ratio = round(solverRate / signalRate);      % e.g. 8
bestEVM = inf;
for p = 0:ratio-1
    rx = ySolverRate(1+p:ratio:end);          % decimate at phase p
    d  = finddelay(x_input, rx); rx = circshift(rx, -d);   % integer align
    n  = min(numel(rx), numel(x_input));
    a  = (rx(1:n)' * x_input(1:n)) / (rx(1:n)' * rx(1:n));  % single complex gain
    e  = 100 * norm(a*rx(1:n) - x_input(1:n)) / norm(x_input(1:n));
    bestEVM = min(bestEVM, e);
end
evmPct = bestEVM;
```

**Option B — align at the solver rate, then decimate.** Estimate the delay at the fine grid and
compensate before decimating (captures integer + fractional in one step):

```matlab
xUp = interp(x_input, ratio);                 % reference at solver rate (interp is zero-delay)
d   = finddelay(xUp, ySolverRate);            % delay in SOLVER samples (e.g. 642 = 80.25 signal samp)
yA  = circshift(ySolverRate, -d);
rx  = downsample(yA, ratio);                  % now decimate cleanly
```
Note Option B upsamples the reference with `interp` (zero group delay, but its anti-alias FIR
slightly clips a near-full-band reference's edges); Option A avoids resampling the reference at all,
so prefer A for band-filling signals.

Both give the same result (they remove the same fractional delay). This removes only the chain's
**delay** — it does NOT equalize the chain's frequency response, so genuine dispersion (amplitude
ripple / group-delay variation) still shows in the EVM, which is what you want for an RF measurement.

**Option C — full per-subcarrier equalization (comms toolboxes).** For OFDM standards, demodulate
and equalize with the standard toolbox (5G/LTE/WLAN: e.g. `nrOFDMDemodulate` + channel estimate, or
`wlanHEDemodulate` + `rxEq = rxData./chanEst`). This both removes the fractional delay AND divides
out the channel's frequency response — giving the lowest EVM, but it **masks the RF dispersion** you
may be trying to measure. Use it when you want end-to-end link EVM (does the receiver recover the
data?), not when characterizing the RF chain's own impairments.


---

## Signal Quality Thresholds

| Standard | Metric | Requirement | Typical with good CE sim |
|----------|--------|-------------|------------------------|
| 5G NR 64-QAM | EVM | < 3.5% (3GPP) | 1-2% at backed-off power |
| 5G NR 256-QAM | EVM | < 2.5% (3GPP) | 0.5-1.5% |
| LTE 64-QAM | EVM | < 8% (3GPP) | 2-4% |
| WLAN 802.11ax MCS9 | EVM | < -35 dB (~1.8%) | 1-3% |
| Generic | ACLR | < -30 dBc (backed-off) | -45 to -55 dBc |
| Generic | ACLR | < -30 dBc (compressed) | -25 to -35 dBc |

----

Copyright 2026 The MathWorks, Inc.

----
