# Antenna Wave Ports

Configuring InputIncWave (receive) and OutputRadWave (transmit) on the CE Antenna block.

## InputIncWave (Receive Antenna)

Accepts incident EM wave as [samples x carriers x 2] (theta, phi polarization).
The antenna converts this wave to an RF circuit signal using its pattern and
polarization response at the configured arrival direction.

- When `InputIncWave='on'`: antenna injects signal into the system using the
  incident wave and its receive pattern
- When `InputIncWave='off'`: antenna only contributes its impedance to the circuit
  (valid for impedance-only analysis but does not model actual reception)

### Source Dimension Requirement

When `InputIncWave='on'` in 'Antenna object' mode, the port expects a 3-D signal of
size [samples x carriers x 2]. The third dimension is polarization (theta, phi).

A Concatenate block must use `Mode='Multidimensional array'` with
`ConcatenateDimension=3` to produce this shape. Vector mode produces [2x1] which fails
with "Error in port widths or dimensions".

### Creating a Polarized Source (theta-only)

Without a Channel block, create a source producing [signal, zeros] for theta-only
linear polarization:

With `model_edit` (block IDs from `model_read`; pass the JSON on one line): add a Vector
Concatenate in multidimensional mode along dimension 3 and a zero Constant for phi, feed
the existing wave signal to input 1 and the zero to input 2, and connect the Concatenate
output to the antenna's wave inport. `connect` replaces the old scalar connection to that
inport.

```json
[{"op":"add_block","type":"simulink/Math Operations/Vector Concatenate","name":"WaveConcat",
  "ref":"wc","params":{"Mode":"Multidimensional array","ConcatenateDimension":"3",
  "NumInputs":"2"}},
 {"op":"add_block","type":"simulink/Sources/Constant","name":"ZeroPhi","ref":"z",
  "params":{"Value":"0"}},
 {"op":"connect","target":"<wave source id>.y1 -> #wc.u1"},
 {"op":"connect","target":"#z.y1 -> #wc.u2"},
 {"op":"connect","target":"#wc.y1 -> <RxAnt id>.u1"}]
```

### Warning: Switching from Isotropic to Antenna Object

The 'Isotropic radiator' mode tolerates a scalar source because it ignores the wave
port internally. When switching to 'Antenna object' mode, any existing scalar source
(e.g., the `dBm to Linear` block from `exportRFBlockset`) causes a dimension mismatch.
Replace with a proper [1x1x2] source as shown above.

## OutputRadWave (Transmit Antenna)

Outputs time-varying EIRP as [samples x carriers x 2].

- When `OutputRadWave='on'`: the radiated wave is a Simulink signal you can measure or
  process (the Channel block does not take it: it connects RF terminals and models its own
  antennas from `txsite`/`rxsite`)
- When `OutputRadWave='off'`: antenna only accounts for its impedance (load mismatch,
  insertion loss)

## Transmit vs Receive Parameter Configuration

`AntennaObj` is the name of a base-workspace antenna variable. The transmit antenna takes
the radiated carrier `CarrierFreqRad` and departure direction `rDep` ([az el] in deg); the
receive antenna takes the incident carrier `CarrierFreqInc` and arrival direction `rArr`.
As `model_edit` operations (pass on one line):

```json
[{"op":"configure","target":"<TxAnt id>","params":{"AntennaSource":"Antenna object",
  "AntennaObj":"patchAnt","CarrierFreqRad":"2.4","CarrierFreqRad_unit":"GHz",
  "rDep":"[45 30]","rDep_unit":"deg"}},
 {"op":"configure","target":"<RxAnt id>","params":{"AntennaSource":"Antenna object",
  "AntennaObj":"patchAnt","CarrierFreqInc":"2.4","CarrierFreqInc_unit":"GHz",
  "rArr":"[45 30]","rArr_unit":"deg"}}]
```

**Direction params are completely separate:**
- Transmitter: `CarrierFreqRad` + `rDep` (radiation/departure)
- Receiver: `CarrierFreqInc` + `rArr` (incidence/arrival)

Using the wrong pair (e.g., `CarrierFreqRad` on a receive antenna) sets the transmit
direction but leaves the receive carrier and arrival direction at defaults.

## Antenna Object Requirements

1. **Design at operating frequency:** `patchAnt = design(patchMicrostrip, 2.4e9)` --
   frequency MUST match system LO. Without correct design, S11 at operating frequency
   will be near 0 dB (total mismatch).

2. **Analyze before block usage:** After `design()`, analyze at least once:
   `sparameters(antObj, freq)`, `pattern(antObj, freq)`, or `impedance(antObj, freq)`.
   Without analysis, mask initialization fails with "Antenna object is either
   newly-created or has changed, and should be analyzed for at least one frequency."

3. **Analyze in base workspace:** Run analysis so the antenna variable retains cached
   solution data -- `evalin('base', 'sparameters(rxAntenna, 2.4e9)')` or assign back
   with `assignin('base', ...)`.

## Exporting Chains with rfantenna

`rfsystem` fails when `rfantenna` is the first or last element:
`"Invalid Simulink object name: '<ModelName>/Inport1'"`.

Use `exportRFBlockset(b)` instead -- it handles all element types and produces a valid
CE model. The resulting model lacks rfsystem's simulation wrapper but can be augmented
with time-varying sources, sinks, and scopes.

```matlab
% Chain with rfantenna -- use exportRFBlockset
ant = rfantenna(Type='Receiver', Name='RxAnt');
lna = amplifier(Name='LNA', Gain=15, NF=2, OIP3=20);
demod = modulator(Name='IQDemod', Gain=-6, NF=10, OIP3=15, ...
    LO=2.4e9, ConverterType='Down');
b = rfbudget([ant lna demod], 2.4e9, -30, 20e6);
mdl = exportRFBlockset(b);
save_system(mdl, 'my_rx');
```

----

Copyright 2026 The MathWorks, Inc.

----
