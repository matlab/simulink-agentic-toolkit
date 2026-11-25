# RF Blockset Library Catalog

Full library paths for use in `model_edit` add_block operations. Always use full paths --
short names resolve ambiguously.

## Library Structure

| Library | Path Prefix | Contents |
|---------|-------------|----------|
| Elements | `simrfV2elements/` | Amplifier, Filter, Mixer, S-Parameters, Transmission Line |
| Sources | `simrfV2sources1/` | Continuous Wave, Sinusoid, Noise |
| Utilities | `simrfV2util1/` | Configuration, Outport, Inport, Connection Label, Spectrum Analyzer |
| Junctions | `simrfV2junction1/` | Splitter, Coupler, Circulator, Switch |
| Systems | `simrfV2systems/` | IQ Modulator, IQ Demodulator, Modulator, Demodulator, Channel |
| Testbenches | `simrfV2testbenches/` | Pre-built measurement setups |

## simrfV2elements/ (Circuit Elements)

Amplifier, Antenna, Attenuator, C, Filter, Gnd, IMT Mixer, Ideal Transformer,
L, LC Ladder, Mixer, Mutual Inductor, Phase Shift, Power Amplifier, R,
S-parameters, Signal Combiner, Three-Winding Transformer, Transmission Line,
VGA, Variable Attenuator, Variable Capacitor, Variable Inductor, Variable Phase Shift,
Variable Resistor, Z

## simrfV2sources1/ (Signal Sources)

Continuous Wave, Noise, Sinusoid

## simrfV2util1/ (Infrastructure)

Configuration, Connection Label, Connection Port, Inport, Outport, Spectrum Analyzer

## simrfV2junction1/ (Multi-port Junctions)

Circulator, Coupler, Divider, Potentiometer, SPDT, SPST, SPnT, Switch

## simrfV2systems/ (System Blocks)

Channel, Demodulator, IQ Demodulator, IQ Modulator, Modulator

## simrfV2testbenches/ (Measurement Setups)

IIP2 Testbench, IIP3 Testbench, Noise Figure Testbench, OIP2 Testbench,
OIP3 Testbench, S-Parameter Testbench, Transducer Gain Testbench

**Note:** Testbench block names contain embedded newline characters. In a `model_edit`
`add_block` type, a space works in place of the newline:
`"type":"simrfV2testbenches/Transducer Gain Testbench"`. In MATLAB code, build the path
with `sprintf('simrfV2testbenches/Transducer Gain\nTestbench')`.

## Block Names with Embedded Newlines

Several library block names wrap onto two lines, so the name holds a literal newline rather
than a space: every testbench, plus `Variable Attenuator`, `Variable Phase Shift`,
`Variable Capacitor`, `Variable Inductor`, `Variable Resistor`, `IMT Mixer` and
`Continuous Wave`.

**To ADDRESS such a block, a space works in place of the newline** -- in a `model_edit`
`add_block` type, in path-based MATLAB calls (`get_param`, `getSimulinkBlockHandle`), and as a
`find_system(...,'Name',...)` search criterion. `'simrfV2elements/Variable Attenuator'`
resolves to the same handle as the `sprintf` form, so there is no need to build a probe
model to check. (Nor can the space form ever be ambiguous: Simulink refuses to create two
blocks in one model differing only by newline-vs-space.)

**But `find_system` RETURNS the newline form**, so comparing its output against a
space-form path you wrote yourself gives a false negative:

```matlab
b = find_system('simrfV2elements', 'SearchDepth', 1, 'Type', 'Block');
any(strcmp(b, 'simrfV2elements/Variable Attenuator'))   % 0  -- looks absent, but it is there
any(contains(b, 'Variable Attenuator'))                 % 0  -- same reason
any(contains(b, 'Attenuator'))                          % 1  -- matches the half before the newline
```

When you do need to match against enumerated output, normalize first --
`strrep(b, newline, ' ')` -- or match on a single word. Printing a raw list is also
misleading unless you normalize: `fprintf('%s\n', strrep(name, newline, ' '))`.

## Common Parameter Names

| Block | Key Parameters |
|-------|---------------|
| Configuration | `Tones`, `Harmonics`, `AutoFreq`, `AddNoise`, `Temperature`, `StepSize` |
| CW Source | `CWSourceType`, `MagPower`, `CarrierFreq`, `Z0`, `IVoltage` |
| Amplifier | `linear_gain`, `NF`, `IP3`, `IPType`, `Source_linear_gain` |
| Power Amplifier | `ModelType`, `CoeffMatrix`, `Rin`, `Rout` |
| RF Outport | `SensorType`, `OutputFormat`, `CarrierFreq`, `CarrierFreq_unit`, `ZL` |
| RF Inport | `CarrierFreq`, `CarrierFreq_unit` |
| IQ Mod/Demod | `GainMismatch`, `PhaseMismatch`, `Isolation`, `AddPhaseNoise` |
| IMT Mixer | `UserSpurValues`, `AddPhaseNoise` |
| S-Parameters | `File`, `SparamRepresentation`, `FitTol` |
| Filter | `FilterType`, `ResponseType`, `FilterOrder` |

## Gateway Block Enumerated Values

The RF Inport, RF Outport and Configuration blocks are the boundary between the physical
network and Simulink signals, so their dropdown parameters get set on nearly every build.
These are the exact accepted strings -- they are case- and space-sensitive, and an invalid
one fails at edit time with *"Option specified is not valid"*.

| Block / Parameter | Accepted values | Default |
|---|---|---|
| Inport `SimulinkInputSignalType` | `Ideal voltage` \| `Ideal current` \| `Power` | `Ideal voltage` |
| Outport `SensorType` | `Ideal voltage` \| `Ideal current` \| `Power` | `Ideal voltage` |
| Outport `OutputFormat` | `Complex Baseband` \| `In-phase and Quadrature Baseband` \| `Magnitude and Angle Baseband` \| `Real Passband` | `Complex Baseband` |
| `CarrierFreq_unit` (both) | `Hz` \| `kHz` \| `MHz` \| `GHz` | `Hz` |
| Configuration `SolverType` | `Auto` \| `NDF2` \| `Trapezoidal Rule` \| `Backward Euler` | `Auto` |
| Configuration `StepSize_unit` | `s` \| `ms` \| `us` \| `ns` | `s` |
| Configuration `Temperature_unit` | `C` \| `Fh` \| `K` | `K` |
| SPDT/SPST `CharType` | `Resistance` \| `Insertion loss` | `Resistance` |
| SPDT/SPST `LoadType` | `Absorptive` \| `Reflective` | `Reflective` |
| `Vthres_unit`, `Ron_unit`, `Roff_unit`, `Z0_unit` | `V`\|`mV`\|`kV` and `Ohm`\|`kOhm`\|`MOhm`\|`GOhm` | `V`, `Ohm` |

Other defaults worth knowing: Inport `ZS='0'`, Outport `ZL='Inf'`, and `AddNoise='off'` on
both gateways (the Configuration block's own `AddNoise` is the master switch).

To list a mask's options for a block not covered here, read them off the mask rather than
guessing -- a parameter query (`model_query_params` or `get_param`) returns only the current
value:

```matlab
m = Simulink.Mask.get(blk);
for k = 1:numel(m.Parameters)
    p = m.Parameters(k);
    if ~isempty(p.TypeOptions)
        fprintf('%s : %s\n', p.Name, strjoin(string(p.TypeOptions), ' | '));
    end
end
```

## Frequency Parameter Convention

Many frequency parameters have a companion `_unit` parameter:
- `CarrierFreq` + `CarrierFreq_unit` (default: GHz after rfsystem export)
- `PassFreq_lpIR` + `PassFreq_lp_unitIR`

**After rfsystem export, frequencies are in GHz.** A stored value of `2.4` with unit `GHz`
means 2.4 GHz. Do NOT set to `2.4e9` unless unit is Hz.

## CW Source Configuration

| CWSourceType | Key Params | Notes |
|---|---|---|
| Power | `MagPower` (W), `Z0` (must be > 0) | Z0 required -- 0 causes error |
| Voltage | `IVoltage` (V) | No impedance needed |

----

Copyright 2026 The MathWorks, Inc.

----
