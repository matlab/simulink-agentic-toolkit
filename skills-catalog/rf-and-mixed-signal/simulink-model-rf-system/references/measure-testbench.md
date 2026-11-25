# Measure with Testbench Blocks

Systematic RF characterization using exported testbenches or standalone measurement blocks.

## Exported Testbench Workflow

```matlab
b = rfbudget([lna bpf mix], 2.4e9, -30, 20e6);
exportTestbench(b);                              % Circuit Envelope (full fidelity)
exportTestbench(b, Library='IdealizedBaseband'); % Faster, less fidelity
```

The exported model contains a DUT subsystem and RF Measurement Unit with mask controls.

**Critical: Testbench models use StopTime='inf'.** Never simulate without a finite StopTime
(`setModelParameter` on a `Simulink.SimulationInput`) or a wall-clock `TimeOut` (Option C).

### Selecting the Measurement Mode

This applies to the multi-measurement testbenches that `exportTestbench` uses (MaskType
`RF Measurement Unit`: Testbench RF to RF, IQ to RF, RF to IQ, IQ to IQ). The single-measurement
blocks in `simrfV2testbenches/` (Seven Testbench Blocks, below) have no mode to select.
Each RF Measurement Unit has two mode lists, and only one is live:
`ModeStrLong` (all modes) when `SimNoise` is on, and `ModeStrShort` (the same without the noise mode:
NF, or Noise Floor for IQ to RF) when it is off. Setting the list that isn't live does nothing, with
no error: with noise off, `ModeStrLong='Gain'` leaves an IP3 testbench measuring IP3. Turning noise
off while in the noise mode errors, because that mode isn't in `ModeStrShort`.

Select the mode on the full list with noise on, then set noise for the measurement (Rule 8 table).
This works from any starting mode, and switching noise off carries the mode over to `ModeStrShort`.
With `model_edit`, two `configure` operations in this order (testbench ID from `model_read`):

```json
[{"op":"configure","target":"<testbench id>","params":{"SimNoise":"on","ModeStrLong":"IP3"}},
 {"op":"configure","target":"<testbench id>","params":{"SimNoise":"off"}}]
```

RF to RF modes: Gain | NF | IP3 | IP2 | DC Offset. Keep `"SimNoise":"on"` in the second
operation for NF / Noise Floor. To confirm, `model_query_params` for `Mode` returns its position
in `ModeStrLong` (RF to RF: 3 = IP3).

IQ to RF adds Carrier Feedthrough and Sideband Suppression; RF to IQ adds Image Rejection Ratio. List
the options with `get_param(blk,'MaskObject').getParameter('ModeStrLong').TypeOptions`.

## Running Testbench Measurements

### Computing StopTime for Testbench Blocks

Testbench blocks need a minimum simulation duration to complete their measurement.
If StopTime is too short, the output is **all zeros** (not partial — zeros).

**S-Parameter Testbench formula:**
```
StopTime_min = (NumOfPorts + 1) * Nbins * (Intermission + 1) / Base_bw
```

| Parameter | Default | Where to find |
|-----------|---------|---------------|
| NumOfPorts | 2 | Number of RF physical ports on DUT |
| Nbins | 128 | `model_query_params` `Nbins` — frequency output points |
| Intermission | 0 | `model_query_params` `Intermission` — gap cycles between port measurements |
| Base_bw | 10e6 | `model_query_params` `Base_bw` — baseband analysis bandwidth |

Example (defaults): `(2+1) * 128 * 1 / 10e6 = 38.4e-6` → use `'40e-6'` or larger.

Note: `fft_size` does NOT affect minimum StopTime — it only controls frequency
resolution of the output S-parameters.

**Gain, IP3, IP2:** These converge fast. Use `'10e-6'`.

**NF / Noise Floor:** StopTime scales with `Base_bw` (< 1 kHz). Use `StopTime = 500/Base_bw`
(5 s at 100 Hz). Example: at 100 Hz the reading is within 0.03 dB of the rfbudget NF from 3 s on,
and `'10e-6'` returns 0. Don't go longer: a 200 s run costs a minute of wall-clock time for the same number.

To check settling, compare the logged reading at ~80% of StopTime with the final value in the
same run (`d(round(0.8*end))` vs `d(end)`): if they agree, the run is long enough. Only if they
differ, double StopTime once. Check it once, at the power you report, not at every sweep point.

### Option A: Fixed StopTime (simple)

StopTime goes on a `Simulink.SimulationInput`, so the model itself keeps `'inf'`:

```matlab
% For S-Parameter Testbench: compute from the block's Nbins and Base_bw
numPorts = 2;  % typical 2-port DUT
Nbins = str2double(get_param(sptBlk, 'Nbins'));
Base_bw = str2double(get_param(sptBlk, 'Base_bw'));
stopTime = (numPorts + 1) * Nbins / Base_bw * 1.1;  % 10% margin
in = setModelParameter(Simulink.SimulationInput(mdl), 'StopTime', num2str(stopTime));
out = sim(in);

% For Gain/IP3 testbenches: 10e-6 is sufficient. For NF: num2str(500/Base_bw)
in = setModelParameter(Simulink.SimulationInput(mdl), 'StopTime', '10e-6');
out = sim(in);
```

### Option B: Iterative Convergence (for IP3)

IP3 needs low enough power that higher-order terms don't contaminate:

```matlab
measBlk = [mdl '/Testbench RF to RF'];
ls = Simulink.Simulation.LoggingSpecification;            % log the reading; model unchanged
addSignalsToLog(ls, Simulink.SimulationData.BlockPath(measBlk), 1);

powerLevels = 0:-10:-50;
prevIP3 = NaN;
for i = 1:numel(powerLevels)
    in = Simulink.SimulationInput(mdl);
    in = setModelParameter(in, 'StopTime', '10e-6');
    in = setBlockParameter(in, measBlk, 'T_amp_dBm', num2str(powerLevels(i)));
    in.LoggingSpecification = ls;
    out = sim(in);
    ip3 = out.logsout.get(1).Values.Data(end);
    fprintf('Pin=%+d dBm: OIP3=%.2f dBm\n', powerLevels(i), ip3);
    if ~isnan(prevIP3) && abs(ip3 - prevIP3) < 0.5
        fprintf('Converged.\n');
        break;
    end
    prevIP3 = ip3;
end
```

### Option C: Wall-Clock Time Limit (last resort)

Not for Gain, NF, IP3 or S-parameters: they have a StopTime rule above, and a `TimeOut` run always
spends its full wall-clock time. Only when no StopTime estimate exists, run with StopTime `'inf'`
and a wall-clock `TimeOut`; the run stops cleanly and returns what it logged:

```matlab
measBlk = [mdl '/Testbench RF to RF'];
ls = Simulink.Simulation.LoggingSpecification;            % log the reading; model unchanged
addSignalsToLog(ls, Simulink.SimulationData.BlockPath(measBlk), 1);
in = Simulink.SimulationInput(mdl);         % StopTime can stay 'inf'
in = setModelParameter(in, 'TimeOut', 5);   % stop after 5 s of wall-clock time (numeric)
in.LoggingSpecification = ls;
out = sim(in);                              % out.SimulationMetadata.ExecutionInfo.StopEvent = 'Timeout'
v = out.logsout.get(1).Values;
fprintf('Sim time: %.2e s\n', v.Time(end));
measValue = v.Data(end);
```

## Seven Testbench Blocks

In library `simrfV2testbenches/`:

| Block | Measures | Key Config |
|-------|----------|-----------|
| Transducer Gain | System gain (dB) | Noise OFF, low power |
| Noise Figure | NF (dB) | Noise ON, BW < 1 kHz |
| OIP3 | Output 3rd intercept | Noise OFF, low power |
| IIP3 | Input 3rd intercept | Noise OFF, low power |
| OIP2 | Output 2nd intercept | Noise OFF |
| IIP2 | Input 2nd intercept | Noise OFF |
| S-Parameter | Scattering matrix | Small stimulus (linear) |

## Measurement Guidelines

| Measurement | Noise | Power | Bandwidth |
|-------------|-------|-------|-----------|
| Gain | OFF (ON usually fine) | Low (linear region) | Default OK |
| Noise Figure | **ON** (required) | -20 to -30 dBm | **< 1 kHz** |
| IP3 / IP2 | OFF (noise floor can bury the IMs) | Low (avoid higher-order) | Default OK |
| S-Parameters | N/A | Small (linear) | Default OK |

## Adding Standalone Testbench Blocks

Testbench library names contain a newline ("Transducer Gain" + newline + "Testbench");
in a `model_edit` `add_block` type, write it with a space. Connect the DUT between the
testbench's physical ports: testbench `LConn1` to the DUT input, DUT output to testbench
`RConn1`. The testbench's Simulink output `y1` carries the reading. With `model_edit`
(block IDs from `model_read`; pass the JSON on one line):

```json
[{"op":"add_block","type":"simrfV2testbenches/Transducer Gain Testbench","name":"GainTB",
  "ref":"tb","params":{"SimNoise":"off"}},
 {"op":"connect","target":"#tb.LConn1 <-> <LNA id>.LConn1"},
 {"op":"connect","target":"<PA id>.RConn1 <-> #tb.RConn1"},
 {"op":"add_block","type":"simulink/Sinks/Out1","name":"GainOut","ref":"o"},
 {"op":"connect","target":"#tb.y1 -> #o.u1"}]
```

(Verified: LNA 15 dB + PA 10 dB reads 25.000 dB.)

After adding:
- Set `StopTime` finite (defaults to `inf`)
- Disable noise for gain/IP3
- Set measurement frequency to match DUT
- Enable signal logging on outport for programmatic access

## S-Parameter Testbench Notes

- **`Fin` must be at DUT passband center** — not just within the S2P data range.
  If the DUT contains a bandpass filter loaded from S2P data, read the file with
  `sparameters('file.s2p')` and find the frequency where |S21| peaks. Set `Fin` to
  that frequency. Setting `Fin` outside the passband (even if the S2P file covers
  that range) produces garbage (S21 ≈ -80 dB from extrapolation/attenuation).
- **Increase `Nbins` (FFT length) for narrowband/dispersive DUTs.** The measurement
  window duration is `Nbins/Base_bw`. A dispersive DUT (narrowband filter) has a long
  impulse response — if it extends beyond the measurement window, the S-parameters are
  truncated and inaccurate. Increase `Nbins` until the measurement captures the full
  impulse response. Note: `fft_size` is an internal parameter (`= Nbins * OS`) — set
  `Nbins` instead. Increasing `Nbins` also increases required StopTime (see formula
  above). Rule of thumb: if S21 looks smeared or attenuated, double `Nbins` until it
  stabilizes.
- Keep stimulus in linear region for nonlinear DUTs
- Results export via: `rfwrite(SParamObjOut, 'file.s2p')` (variable `SParamObjOut`
  appears in base workspace after simulation)

## Validating rfbudget Against Testbench

```matlab
% Budget gives analytical predictions
rfbudget_gain = b.TransducerGain(end);
rfbudget_nf = b.NF(end);
rfbudget_oip3 = b.OIP3(end);

% Testbench gives circuit simulation results
% Differences are normal: testbench models saturation and multi-tone interactions
% Reduce power closer to small-signal regime to converge toward budget values
```

## IQ Transmitter Testbench Extras

Additional measurements beyond the seven standard blocks:
- **Carrier Feedthrough** -- use dBmV input, disable noise, reduce BW < 1 kHz
- **Sideband Suppression** -- disable noise, reduce input power. In this mode the input
  choice (`IQMeasureStr`) is hidden and has no effect: the testbench drives I and Q in
  quadrature itself, and `InjectionTypeStr` selects the desired sideband. Match it to the
  DUT: `'Low-side'` when the LO is below `Fout` (`Fout` = LO + `Fin`, image at
  `Fout - 2*Fin`), `'High-side'` when the LO is above `Fout` (`Fout` = LO − `Fin`). With
  the wrong side it compares two tones that are not the desired/image pair, and the
  reading is meaningless (often deceptively good).
- Input options for the other modes (`IQMeasureStr`): `'I and Q (Q = -1j * I)'`,
  `'I and Q (Q = 1j * I)'`, `'I only (Q = 0)'`, `'Q only (I = 0)'`. These modes (Gain,
  IP3, …) need I and Q driven in quadrature with the sign that puts the tone on the
  desired sideband — `Q = -1j * I` when `Fout` = LO + `Fin`. Example (LO below `Fout`,
  rfbudget gain 24 dB): `Q = -1j * I` → 24.0 dB; I only or Q only → 18.0 dB (the tone
  splits over both sidebands); `Q = 1j * I` → the image, no output. IP3 shifts the same way.
- Read the result: log the testbench output port and take `Data(end)` (`LoggingSpecification`, as in Programmatic Testbench Configuration below).

## IQ Receiver Testbench Extras

Additional measurements:
- **DC Offset** -- disable noise, use dBmV, reduce BW < 1 kHz
- **Image Rejection Ratio** -- disable noise, reduce BW < 1 kHz, choose LO side
- Response branch selection: I only, Q only, or both

| Measurement | Noise | Power | Bandwidth |
|-------------|-------|-------|-----------|
| DC Offset | OFF | dBmV voltage mode | **< 1 kHz** |
| Image Rejection | OFF | Default | **< 1 kHz** |
| Carrier Feedthrough | OFF | dBmV voltage mode | **< 1 kHz** |
| Sideband Suppression | OFF | Low | Default OK |

## Programmatic Testbench Configuration

```matlab
% exportTestbench creates a new (untitled) model and returns its name
mdl = exportTestbench(b);

% Find the measurement unit
measBlk = find_system(mdl, 'MaskType', 'RF Measurement Unit');
```

Configure it for IP3 with `model_edit` (§ Selecting the Measurement Mode; ID from `model_read`):

```json
[{"op":"configure","target":"<testbench id>","params":{"SimNoise":"on","ModeStrLong":"IP3"}},
 {"op":"configure","target":"<testbench id>","params":{"SimNoise":"off","T_amp_dBm":"-20",
  "Base_bw":"10e6"}}]
```

Then log the reading and run:

```matlab
ls = Simulink.Simulation.LoggingSpecification;
addSignalsToLog(ls, Simulink.SimulationData.BlockPath(measBlk{1}), 1);
in = setModelParameter(Simulink.SimulationInput(mdl), 'StopTime', '10e-6');
in.LoggingSpecification = ls;
out = sim(in);
d = out.logsout.get(1).Values.Data;   % OIP3 in dBm; d(end) vs d(round(0.8*end)) checks settling
```

## Common Parameters (All Blocks)

| Parameter | Default | Notes |
|-----------|---------|-------|
| Input power amplitude | -30 dBm | Range: -90 to +60 dBm |
| Input frequency | 2.1 GHz | Must exceed baseband BW |
| Output frequency | 2.1 GHz | Must exceed baseband BW |
| Baseband bandwidth | 10 MHz | Must be > 0 |
| Source resistance | 50 Ohm | Positive finite scalar |
| Load resistance | 50 Ohm | Positive finite scalar |
| Use internal Configuration | on | Manages solver settings |
| Simulate noise | on | Toggle for accuracy |
| Show Response spectrum | off | Requires DSP System Toolbox |

## Library Block Paths

All require `sprintf` for embedded newline:
- `sprintf('simrfV2testbenches/Transducer Gain\nTestbench')`
- `sprintf('simrfV2testbenches/Noise Figure\nTestbench')`
- `sprintf('simrfV2testbenches/OIP3\nTestbench')`
- `sprintf('simrfV2testbenches/IIP3\nTestbench')`
- `sprintf('simrfV2testbenches/OIP2\nTestbench')`
- `sprintf('simrfV2testbenches/IIP2\nTestbench')`
- `sprintf('simrfV2testbenches/S-Parameter\nTestbench')`

## Power Averaging for Random Signals

When the system carries random signals, instantaneous power fluctuates:

**Option A: DSP System Toolbox `powermeter`** (requires license)
```matlab
pm = powermeter('Impedance', 50, 'FrequencyResolution', 1e3);
```

**Option B: RF Blockset example power meter** (no extra license) -- see
`openExample('simrf/CommunicationsSystemWithEmbeddedRfReceiverExample')`,
block `simrfV2_comms_rf_example/Power`. Copy that subsystem into your model.

## Library Comparison

| Library | Fidelity | Speed | Available Measurements |
|---------|----------|-------|----------------------|
| Circuit Envelope | Full RF: saturation, harmonics | Slower | Gain, NF, IP2/IP3, S-params |
| IdealizedBaseband | Perfect matching, flat | Faster | Gain, intercept points, noise |

**Limitation:** IdealizedBaseband cannot contain `rfelement` objects.

## Gotchas (duplicated here for convenience)

- **Testbench StopTime defaults to 'inf'.** Both `exportTestbench` models AND manually-placed
  testbench blocks use infinite StopTime. Never simulate without setting it finite on a
  `Simulink.SimulationInput` first: `setModelParameter(in, 'StopTime', '10e-6')`.
- **Power sensor mid-circuit changes topology.** An Outport with `SensorType='Power'` adds
  ZL resistance as a shunt to ground. A 50 Ohm tap on a 50 Ohm node halves the load
  impedance (~6 dB gain drop). Use `SensorType='Ideal voltage'` (ZL is ignored) for
  non-disturbing observation at intermediate nodes.
- **NF measurement requires noise ON.** The Configuration block's `AddNoise` is a master
  switch. If 'off', NF measurement returns NaN or unstable values.
- **IP3 needs low input power.** Higher-order terms (5th, 7th) contaminate the 3rd-order
  extrapolation at high power. Sweep power downward until the measurement stabilizes
  (see convergence workflow above).
- **S-Parameter Fin must be at passband center.** Setting Fin outside the DUT passband
  (even within S2P data range) produces garbage results (S21 ~ -80 dB).
- **release(rfs) before testbench modifications.** If using rfsystem, call `release(rfs)`
  before any `model_edit` on the underlying model.
- **CarrierFreq alignment.** The testbench's input/output frequencies, the DUT's carrier,
  and any Outport `CarrierFreq` must all agree. Mismatch -> zero or wrong readings.

----

Copyright 2026 The MathWorks, Inc.

----
