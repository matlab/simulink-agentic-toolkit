# Outport Block for Signal Extraction

The RF Outport block extracts complex baseband I/Q from the CE physical network. It is
an ideal IQ demodulator: downconverts the signal at `CarrierFreq` to baseband without
impairment.

> **Not needed for rfsystem path.** `rfs(x)` returns complex baseband directly.
> This reference applies only when using `sim()` with Simulink models.

## CarrierFreq Setting

Set `CarrierFreq` to the frequency where your signal of interest lives:
- Signal at RF (after amplification at 2.4 GHz) -> `CarrierFreq = 2.4e9`
- Signal at baseband (after mixer downconverted to DC) -> `CarrierFreq = 0` (valid!)
- Two carriers in system -> `CarrierFreq = [2.4e9, 5.8e9]` (vector -- one Outport
  senses multiple frequencies)

**DC (CarrierFreq=0) is valid** -- but at DC each individual Outport produces a
real-only signal (Q=0). The complex envelope at 0 Hz carrier decomposes into separate
I and Q channels.

## Dual-Port I/Q Extraction (DC Output)

When `rfsystem()` exports a model containing a downconverting mixer (LO = carrier ->
output at DC), the underlying Simulink model has **two** Outport blocks, both at
`CarrierFreq=0`. These are the I and Q channels.

```matlab
simOut = sim(in);   % in: Simulink.SimulationInput with a finite StopTime
yout = simOut.get('yout');
rxI = real(yout.get(1).Values.Data);  % In-phase
rxQ = real(yout.get(2).Values.Data);  % Quadrature
rxComplex = rxI + 1j*rxQ;            % Full complex baseband
```

**If you only extract one port, you lose half the signal and EVM will be ~100%.**
Always check `yout.numElements` -- if 2 output ports at DC, they are I and Q.

## SensorType

| Type | Loads Circuit? | Use Case |
|------|---------------|----------|
| `'Power'` (ZL=50) | YES (inserts matched load) | System output -- proper RF termination |
| `'Ideal voltage'` | NO (open circuit) | Mid-circuit monitoring (downstream block provides load) |
| `'Ideal current'` | NO (zero impedance) | Series current measurement |

**For output signal extraction (EVM/ACLR):** Use `Power` (ZL=50) at the final output.
RF components are specified under matched load -- gain, IP3, P1dB all assume matched
termination.

**For intermediate node monitoring:** Use `Ideal voltage` where the signal continues
to the next block. The downstream block already provides the load, so you observe the
naturally-terminated voltage without adding a parallel impedance that would disturb
the circuit.

## Output Format

### Complex Baseband (default)

Use for all equivalent-baseband analysis (EVM, ACLR, BER). Output is a complex vector
suitable for direct demodulation by 5G/LTE/WLAN Toolbox functions. When `CarrierFreq`
is a vector, the Outport extracts each carrier's envelope.

### Real Passband

Reconstructs the full time-domain signal: all carrier envelopes modulated onto their
carriers and summed. Use when:
- Downstream system is nonlinear but has no HB engine (ADC quantizer, envelope
  tracker, rectifier, Simscape Electrical components)
- You want the full combined spectrum (all carriers + harmonics together)
- Interfacing with time-domain instrument models or antenna pattern blocks

**Constraints:** Outport step size must resolve the carrier (step <= 1/(8*f_carrier)),
and `SamplesPerFrame` must be 1. Produces much more data than Complex Baseband.

**Scope this narrowly.** `Real Passband` is for a downstream model that genuinely needs the
carrier present. A Simulink block that merely *is* nonlinear -- a quantizer, a comparator, a
lookup table, an AGC detector -- operates perfectly well on the complex envelope, because
each sample it receives is already the instantaneous signal at that node. If the chain
simulates and reads correctly at `Complex Baseband`, leave it there: switching format
changes the required solver step, the data volume and the downstream signal's type, so a
working chain re-plumbed to `Real Passband` is a long detour back to the same answer.

## Output Rate Conversion (Solver Rate -> Signal Rate)

The CE solver runs at `1/StepSize` (e.g., 640 MHz for `StepSize=1/640e6`), typically
4-8x the input signal rate. Complex Baseband Outport blocks output at this rate.
Decimate back to the signal's native sample rate before demodulation or EVM measurement.

**Where the rate transition happens:** the solver->signal-rate reduction is governed by the
**top-level Simulink output port** (`BlockType=Outport`, e.g. `Out1`) — NOT this RF Blockset Outport
gateway (`MaskType=Outport`), which has no SampleTime and only senses the envelope. How you set that
top-level port's rate matters (a plain sample-and-hold there forces decimation phase 0 and inflates
EVM); keep it at the solver rate and decimate in MATLAB instead. See `post-processing.md`
("Extract at the solver rate — decimate in MATLAB").

### Simple Integer Downsampling

Take every N-th sample where N = solverRate/signalRate:

```matlab
ratio = round((1/stepSize) / signalSampleRate);  % e.g., 640e6/80e6 = 8
rxAtSignalRate = rxComplex(1:ratio:end);
```

This works cleanly when the signal is bandlimited within +/-signalRate/2. The CE
oversampling factor (4x or 8x) exists for numerical integration accuracy, so signal
energy is confined well below the solver Nyquist -- no anti-alias filter needed.

### Filtered Decimation

`resample` or `decimate` applies an anti-alias FIR before downsampling. Rejects solver
artifacts near Nyquist edges but introduces passband ripple and group delay.

Use filtered decimation when:
- Low oversampling factor (2x) where numerical noise may encroach on signal band
- Solver artifacts above signal band are a concern

For communications EVM measurement, the added delay must be accounted for in signal
alignment.

## Block Parameter Units

After `rfsystem`/`rfbudget` export, frequency parameters use **GHz** (not Hz).
A stored value of `5.8` with `CarrierFreq_unit = 'GHz'` means 5.8 GHz -- do NOT set
to `5.8e9` (that would mean 5.8x10^9 GHz).

Inport/Outport `CarrierFreq` is already correct after export -- do not modify unless
changing to a different carrier. If you must change any frequency parameter:
1. Check its `_unit` companion (`model_query_params` for `<param>_unit`)
2. Set value in the specified unit (`model_edit` `configure`)

## Signal Normalization

`NormalizeCarrierPower` (default `'on'`): Signals entering/leaving the RF domain are
normalized to RMS power (multiplied by sqrt(2) entering, divided by sqrt(2) leaving).
At DC carriers (`CarrierFreq = 0`) there is no normalization.

**3 dB discrepancy:** I and Q ports inside RF domain receive DC (peak power), but RF
output carries RMS power. This sqrt(2) asymmetry can cause apparent 3 dB errors.

## SamplesPerFrame

Default 1, max 1024. For interfacing with Communications Toolbox frame-based blocks.
The CE solver itself does not significantly accelerate with frames.

## Gotchas (duplicated here for convenience)

- **CarrierFreq=0 (default) senses DC only.** If your signal is at 2.4 GHz and Outport
  CarrierFreq is 0, output will be zero. Set CarrierFreq to match signal carrier.
- **Dual I/Q ports at DC.** When mixer downconverts to DC, model has TWO Outports (I and Q).
  Extracting only one gives EVM ~100%. Check `yout.numElements`.
- **SensorType='Power' adds load.** A Power sensor mid-circuit inserts ZL as a shunt
  resistor to ground. 50 Ohm tap on 50 Ohm node = 6 dB gain drop. Use 'Ideal voltage'
  with ZL='Inf' for non-disturbing observation.
- **`_unit` companions after export.** After rfsystem export, frequencies default to GHz.
  `CarrierFreq = '5.8'` with `CarrierFreq_unit = 'GHz'` means 5.8 GHz. Do NOT set to
  `'5.8e9'` (that would be 5.8x10^9 GHz).
- **Decimation needed before demod.** CE solver output is at `1/StepSize` (e.g., 640 MHz),
  not at signal rate. Always decimate: `rxAtSignalRate = rx(1:ratio:end)`.
- **NormalizeCarrierPower sqrt(2).** RF domain uses RMS normalization. If comparing to a
  reference generated in Simulink's signal domain, account for the sqrt(2) factor.

----

Copyright 2026 The MathWorks, Inc.

----
