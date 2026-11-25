# Waveform Generation (Cross-Toolbox Reference)

## License Check Pattern

Always verify toolbox availability before calling toolbox-specific functions:

```matlab
has5G   = ~isempty(ver('5g'));        % 5G Toolbox
hasLTE  = ~isempty(ver('lte'));         % LTE Toolbox
hasWLAN = ~isempty(ver('wlan'));        % WLAN Toolbox
hasPA   = ~isempty(ver('phased'));      % Phased Array Toolbox
hasComm = ~isempty(ver('comm'));        % Communications Toolbox
hasDSP  = ~isempty(ver('dsp'));        % DSP System Toolbox
hasSP   = ~isempty(ver('signal'));      % Signal Processing Toolbox
```

If the required toolbox is missing, fall back to the generic OFDM or tone generators below.

---

## 5G NR (requires: 5G Toolbox)

Generate the waveform with `nrWaveformGenerator` — **see the `nrWaveformGenerator` docs for the
exact config-object API** (`nrDLCarrierConfig` and its nested `SCSCarriers`/`BandwidthParts`/
`PDSCH` objects). The property names live on those nested objects, not on the top-level config,
and they change between releases, so consult the docs rather than guessing. The generated
`waveform` plus `info.ResourceGrids...SampleRate` is all the RF chain needs. If 5G Toolbox is
unavailable, use the generic OFDM fallback below.

**Typical sample rates:** 15.36 MHz (10 MHz BW), 30.72 MHz (20 MHz), 61.44 MHz (50 MHz), 122.88 MHz (100 MHz)

**PAPR:** ~8-10 dB for OFDM with 64-QAM. This high PAPR means PA compression occurs at lower average input power than for single-carrier signals.

## LTE (requires: LTE Toolbox)

```matlab
% Check: ~isempty(ver('lte'))
[waveform, ~, cfg] = lteTestModelTool('3.1', '10MHz');  % 10 MHz, TM3.1
sampleRate = cfg.SamplingRate;
```

**Typical sample rates:** 1.92 MHz (1.4 MHz BW), 15.36 MHz (10 MHz), 30.72 MHz (20 MHz)

## WLAN 802.11ax (requires: WLAN Toolbox)

```matlab
% Check: ~isempty(ver('wlan'))
cfg = wlanHESUConfig(ChannelBandwidth='CBW80', MCS=7, APEPLength=1000);
psdu = randi([0 1], cfg.APEPLength*8, 1);
[waveform, ~] = wlanWaveformGenerator(psdu, cfg);
sampleRate = wlanSampleRate(cfg);
```

**Typical sample rates:** 20 MHz (CBW20), 40 MHz (CBW40), 80 MHz (CBW80), 160 MHz (CBW160)

**PAPR:** ~10-12 dB for HE-SU OFDM. Higher than 5G NR due to wider subcarrier count per symbol.

## Radar LFM Chirp (requires: Phased Array Toolbox)

```matlab
% Check: ~isempty(ver('phased'))
wfm = phased.LinearFMWaveform(SampleRate=1e9, SweepBandwidth=500e6, ...
    PulseWidth=10e-6, PRF=10e3);
pulse = wfm();
sampleRate = wfm.SampleRate;

% NOTE: wfm() returns one full PRI (1/PRF seconds), not just the active pulse.
% With PRF=10 kHz the output is SampleRate/PRF = 100,000 samples, but only the
% first PulseWidth*SampleRate = 10,000 are the chirp — the rest are zeros.
% If you only need the active pulse (e.g., for PA characterization):
nActive = wfm.PulseWidth * wfm.SampleRate;
pulse = pulse(1:nActive);
```

**PAPR:** ~0 dB (constant-envelope chirp). PA compression affects phase (AM/PM) not amplitude.

**PRI output:** `wfm()` always returns `SampleRate/PRF` samples (one full PRI). The active chirp occupies only `PulseWidth × SampleRate` samples at the front; the remainder is hard zeros (inter-pulse dead time). Be aware of this when computing transfer functions or power: `H = y./x` will produce Inf/NaN in the zero region, and `mean(abs(x).^2)` over the full PRI underestimates pulse power by `10*log10(duty_cycle)` dB. If the full PRI is not needed (e.g., PA gain/phase characterization), truncate to the active portion to avoid these issues and reduce simulation time.

---

## Fallback: Generic OFDM (requires: Communications Toolbox)

Use when 5G/LTE/WLAN Toolbox is unavailable but you need a realistic OFDM signal with controlled PAPR.

```matlab
% Check: ~isempty(ver('comm'))
nFFT = 1024;                    % FFT size
nSC = 600;                      % active subcarriers (leaves guard bands)
cpLen = 72;                     % cyclic prefix length
nSymbols = 14;                  % symbols per slot
modOrder = 64;                  % 64-QAM

% Generate random QAM symbols
data = randi([0 modOrder-1], nSC, nSymbols);
qamSymbols = qammod(data, modOrder, UnitAveragePower=true);

% Map to OFDM grid (center subcarriers)
grid = zeros(nFFT, nSymbols);
grid(nFFT/2 - nSC/2 + 1 : nFFT/2 + nSC/2, :) = qamSymbols;

% IFFT + cyclic prefix
tdSignal = ifft(ifftshift(grid, 1), nFFT, 1);
cpSignal = [tdSignal(end-cpLen+1:end, :); tdSignal];
waveform = cpSignal(:);         % serialize to column vector

% Sample rate = nFFT * subcarrier spacing
subcarrierSpacing = 15e3;       % 15 kHz (LTE-like) or 30e3 (NR-like)
sampleRate = nFFT * subcarrierSpacing;
```

**Note:** `qammod` requires Communications Toolbox. For the no-toolbox fallback, see below.

## Fallback: Manual OFDM (requires: nothing)

Use when no communications toolbox is available. Generates a valid OFDM signal with realistic PAPR.

```matlab
nFFT = 512;
nSC = 300;                      % active subcarriers
cpLen = 36;
nSymbols = 14;
modOrder = 64;                  % 64-QAM

% Manual QAM constellation (unit average power)
constellation = qam_constellation(modOrder);
symbols = constellation(randi(modOrder, nSC, nSymbols));

% Map to OFDM grid
grid = zeros(nFFT, nSymbols);
scIdx = (-nSC/2 : nSC/2-1) + nFFT/2 + 1;
grid(scIdx, :) = symbols;

% IFFT + CP
tdSignal = ifft(ifftshift(grid, 1), nFFT, 1) * sqrt(nFFT);
cpSignal = [tdSignal(end-cpLen+1:end, :); tdSignal];
waveform = cpSignal(:);

sampleRate = nFFT * 30e3;       % 30 kHz SCS -> 15.36 MHz

% --- Helper: manual QAM constellation ---
function c = qam_constellation(M)
    k = sqrt(M);
    [re, im] = meshgrid(-(k-1):2:(k-1), -(k-1):2:(k-1));
    c = complex(re(:), im(:));
    c = c / rms(c);             % unit average power
end
```

## Fallback: CW/Multitone (requires: nothing)

For quick functional tests, IP3 measurements, or when modulated waveforms aren't needed:

```matlab
% Single tone
Fs = 100e6; T = 10e-6;
t = (0:1/Fs:T-1/Fs).';
waveform = exp(1j*2*pi*1e6*t);         % 1 MHz tone at baseband
sampleRate = Fs;

% Two-tone (for IMD3 measurement)
f1 = 1e6; f2 = 1.1e6;                  % 100 kHz spacing
waveform = exp(1j*2*pi*f1*t) + exp(1j*2*pi*f2*t);
waveform = waveform / rms(waveform);   % normalize to unit power
```

---

## Power Scaling

After generating any waveform, scale to desired input power (CE 1-ohm convention):

```matlab
targetPower_dBm = -20;
targetPower_W = 10^((targetPower_dBm - 30) / 10);
waveform = waveform * sqrt(targetPower_W / mean(abs(waveform).^2));
```

---

## Spectrum Viewing

### spectrumAnalyzer System Object (after rfsystem)

```matlab
sa = spectrumAnalyzer(SampleRate=Fs, ...
    Method='welch', AveragingMethod='exponential', ...
    FrequencyOffset=carrierFreq, ...    % shift baseband display to passband
    SpectrumUnits='dBm', ...
    PlotAsTwoSidedSpectrum=true, ...
    YLimits=[-80 20], ShowLegend=true, ...
    ChannelNames={'Input','Output'});
sa([x_scaled, y]);      % overlay input/output spectra
release(sa);
```

### CE Simulink Spectrum Analyzer (from RF Blockset > Circuit Envelope > Utilities)

The block in `simrfV2util1` works without a DSP System Toolbox license. Key configuration: set `Offset` to a vector of carrier frequencies so each complex baseband envelope displays at its true passband position. Supports built-in Distortion (intermod) and ACPR measurements.

## Gotchas (duplicated here for convenience)

- **SampleTime must match the rate you feed.** `rfs.SampleTime = 1/Fs` where Fs is the rate of
  the vector actually passed to `rfs(x)`. Mismatch -> garbled output, EVM ~100%.
- **...and that rate should oversample the occupied bandwidth.** `rfsystem(b)` ships
  `SampleTime = 1/(8*SignalBandwidth)` because it also sets the CE solver step. Feeding the
  waveform at its own native rate (`1/Fs`) leaves no headroom -- band-edge content is attenuated
  and output power reads low. Resample the waveform UP, set `SampleTime` to match the upsampled
  vector, decimate the output before demodulation. 2-4x is usually enough; see
  `references/simulate-with-signals.md`.
- **Scale to target input power.** Most waveform generators produce unit-power or
  arbitrary-amplitude signals. Scale: `x_scaled = x * 10^((targetPower_dBm - currentPower_dBm)/20)`.
- **Pad for settling.** Add zeros at end: `y = rfs([x_scaled; zeros(200,1)])` then
  `y = y(201:end)`. Without padding, transient response corrupts the last samples.
- **release(rfs) between runs.** Required between power sweep iterations or parameter changes.
- **OFDM signals need equalization for EVM.** A flat RF chain may give acceptable EVM with
  simple delay alignment, but frequency-selective chains need per-subcarrier equalization.

----

Copyright 2026 The MathWorks, Inc.

----
