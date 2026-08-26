---
type: Simulink Block Category
title: Circuit elements
description: Lumped and distributed RF elements
tags: [amplifier, filter, capacitor, inductor, resistor, transmission, s-param]
status: stable
source: mathworks_toolbox
library_root: RF Blockset
category_path: Circuit elements
block_count: 30
---

# Circuit elements

Use these blocks for circuit elements.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Amplifier | simrfV2elements/Amplifier | R2023a+ | Model an RF amplifier — use for simulating gain, noise figure, and nonlinearity in receive or transmit chains |
| Antenna | simrfV2elements/Antenna | R2023a+ | Model an antenna element — use for simulating radiation pattern, gain, and impedance matching |
| Attenuator | simrfV2elements/Attenuator | R2023a+ | Model a fixed attenuator — use for simulating signal level reduction with defined loss |
| C | simrfV2elements/C | R2023a+ | Capacitor element — use for representing capacitance in RF matching networks and filters |
| Filter | simrfV2elements/Filter | R2023a+ | Model an RF filter — use for simulating bandpass, lowpass, or highpass frequency selection |
| IMT Mixer | simrfV2elements/IMT Mixer | R2023a+ | Intermodulation table mixer — use for simulating mixer with tabulated intermodulation products |
| Ideal Transformer | simrfV2elements/Ideal Transformer | R2023a+ | Model an ideal transformer — use for impedance transformation in matching networks |
| L | simrfV2elements/L | R2023a+ | Inductor element — use for representing inductance in RF matching networks and filters |
| LC Ladder | simrfV2elements/LC Ladder | R2023a+ | LC ladder network — use for implementing lumped-element filter topologies |
| Mixer | simrfV2elements/Mixer | R2023a+ | Model an RF mixer — use for simulating frequency up/down conversion with conversion gain and nonlinearity |
| Mutual Inductor | simrfV2elements/Mutual Inductor | R2023a+ | Model coupled inductors — use for simulating transformer coupling between RF coils |
| Phase Shift | simrfV2elements/Phase Shift | R2023a+ | Model a fixed phase shifter — use for adding constant phase rotation in RF signal paths |
| Power Amplifier | simrfV2elements/Power Amplifier | R2023a+ | Model a power amplifier with memory — use for simulating PA nonlinearity, AM-AM, and AM-PM distortion |
| R | simrfV2elements/R | R2023a+ | Resistor element — use for representing resistance in RF networks and terminations |
| S-parameters | simrfV2elements/S-parameters | R2023a+ | Model a component from S-parameter data — use for importing measured or simulated network parameters |
| Signal Combiner | simrfV2elements/Signal Combiner | R2023a+ | Combine multiple RF signals — use for power combining in phased arrays or multi-path architectures |
| Three-Winding Transformer | simrfV2elements/Three-Winding Transformer | R2023a+ | Three-winding RF transformer — use for power splitting or combining with isolation |
| Transmission Line | simrfV2elements/Transmission Line | R2023a+ | Model a transmission line — use for simulating delay, loss, and impedance effects in interconnects |
| VGA | simrfV2elements/VGA | R2023a+ | Variable-gain amplifier — use for simulating signal-controlled gain in AGC loops |
| Variable Attenuator | simrfV2elements/Variable Attenuator | R2023a+ | Signal-controlled attenuator — use for simulating programmable loss in RF paths |
| Variable Capacitor | simrfV2elements/Variable Capacitor | R2023a+ | Signal-controlled capacitor — use for simulating tunable matching networks or varactors |
| Variable Inductor | simrfV2elements/Variable Inductor | R2023a+ | Signal-controlled inductor — use for simulating tunable inductors in matching networks |
| Variable Phase Shift | simrfV2elements/Variable Phase Shift | R2023a+ | Signal-controlled phase shifter — use for simulating beam steering in phased arrays |
| Variable Resistor | simrfV2elements/Variable Resistor | R2023a+ | Signal-controlled resistor — use for simulating programmable attenuation or PIN diodes |
| Z | simrfV2elements/Z | R2023a+ | Impedance element — use for representing arbitrary complex impedance in RF networks |
| Gnd | simrfV2elements/Gnd | R2023a+ | RF ground reference — use for terminating unused ports with matched impedance |
| Amplifier | rfmathmodels2/Amplifier | R2023a+ | Model an RF amplifier — use for simulating gain, noise figure, and nonlinearity in receive or transmit chains |
| Filter | rfmathmodels2/Filter | R2023a+ | Model an RF filter — use for simulating bandpass, lowpass, or highpass frequency selection |
| Mixer | rfmathmodels2/Mixer | R2023a+ | Model an RF mixer — use for simulating frequency up/down conversion with conversion gain and nonlinearity |
| Power Amplifier | rfmathmodels2/Power Amplifier | R2023a+ | Model a power amplifier with memory — use for simulating PA nonlinearity, AM-AM, and AM-PM distortion |
