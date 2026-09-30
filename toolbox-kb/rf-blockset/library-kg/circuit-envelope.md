---
type: Simulink Block Category
title: Circuit envelope
description: Multi-carrier circuit-envelope RF elements, sources, and utilities
tags: [circuit envelope]
status: stable
source: custom_library
library_root: RF Blockset
category_path: Circuit envelope
block_count: 51
---

# Circuit envelope

Use these blocks for circuit envelope.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Gnd | simrfV2elements/Gnd | R2023a+ | Electrical ground reference for a circuit-envelope RF network — connect to establish the 0 V node. |
| Antenna | simrfV2elements/Antenna | R2023a+ | Model antenna and antenna arrays accounting for incident power wave (RX) and radiated power wave (TX). |
| Attenuator | simrfV2elements/Attenuator | R2023a+ | Model an attenuator |
| C | simrfV2elements/C | R2023a+ | Model a linear capacitor. |
| IMT Mixer | simrfV2elements/IMT Mixer | R2023a+ | Mixer model using an Intermodulation Table (IMT) |
| Ideal Transformer | simrfV2elements/Ideal Transformer | R2023a+ | Model ideal transformer |
| L | simrfV2elements/L | R2023a+ | Model a linear inductor. |
| LC Ladder | simrfV2elements/LC Ladder | R2023a+ | Model an LC ladder filter. |
| Mutual Inductor | simrfV2elements/Mutual Inductor | R2023a+ | Model mutual inductor: |
| Phase Shift | simrfV2elements/Phase Shift | R2023a+ | Model a phase shift. |
| R | simrfV2elements/R | R2023a+ | Model a linear resistor. |
| S-parameters | simrfV2elements/S-parameters | R2023a+ | Model an RF component described by S-parameters. |
| Signal Combiner | simrfV2elements/Signal Combiner | R2023a+ | Combine two voltage signals together. |
| Three-Winding Transformer | simrfV2elements/Three-Winding Transformer | R2023a+ | Model three winding transformer. |
| Transmission Line | simrfV2elements/Transmission Line | R2023a+ | Model a transmission line. |
| VGA | simrfV2elements/VGA | R2023a+ | Model a variable-gain amplifier. The inputs: power gain (dB), IP2 (dBm), and IP3 (dBm) are Simulink signals. |
| Variable Attenuator | simrfV2elements/Variable Attenuator | R2023a+ | Model a variable attenuator |
| Variable Capacitor | simrfV2elements/Variable Capacitor | R2023a+ | Model a variable capacitor. The input, Capacitance, is a Simulink signal. |
| Variable Inductor | simrfV2elements/Variable Inductor | R2023a+ | Model a variable inductor. The input, Inductance, is a Simulink signal. |
| Variable Phase Shift | simrfV2elements/Variable Phase Shift | R2023a+ | Model a variable phase device. The input, Phase, is a Simulink signal. |
| Variable Resistor | simrfV2elements/Variable Resistor | R2023a+ | Model a variable resistor. The input, Resistance, is a Simulink signal. |
| Z | simrfV2elements/Z | R2023a+ | Model a complex impedance. |
| Circulator | simrfV2junction1/Circulator | R2023a+ | Model ideal circulators with S-parameters. |
| Coupler | simrfV2junction1/Coupler | R2023a+ | Model ideal couplers with S-parameters. |
| Divider | simrfV2junction1/Divider | R2023a+ | Model ideal dividers with S-parameters. |
| Potentiometer | simrfV2junction1/Potentiometer | R2023a+ | Models a Simulink controlled Potentiometer. |
| SPDT | simrfV2junction1/SPDT | R2023a+ | Model a Single Pole Double Throw (SPDT) switch |
| SPST | simrfV2junction1/SPST | R2023a+ | Model a Single Pole Single Throw (SPST) switch |
| SPnT | simrfV2junction1/SPnT | R2023a+ | Model an absorptive or reflective Single Pole Multiple Throw (SPnT) switch |
| Switch | simrfV2junction1/Switch | R2023a+ | Simulink controlled two terminal switch. Allowed value ranges for Ron and Roff resistances are zero to infinity. The value of Ron can be less than or greater than Roff. When Ron is less than Roff, the switch is on for Vctl>Vthres, and for Ron greater than Roff, the switch is off for Vctl>Vthres. |
| Continuous Wave | simrfV2sources1/Continuous Wave | R2023a+ | Model a continuous wave source. |
| Noise | simrfV2sources1/Noise | R2023a+ | Model a voltage or current noise source defined by the height of power spectral density. |
| Sinusoid | simrfV2sources1/Sinusoid | R2023a+ | Model a sinusoidal voltage or current source. |
| Channel | simrfV2systems/Channel | R2023b+ | Model channel accounting for effect of antennas and RF propagation in medium |
| Demodulator | simrfV2systems/Demodulator | R2023a+ | Model a Demodulator |
| IQ Demodulator | simrfV2systems/IQ Demodulator | R2023a+ | Model an IQ demodulator |
| IQ Modulator | simrfV2systems/IQ Modulator | R2023a+ | Model an IQ modulator |
| Modulator | simrfV2systems/Modulator | R2023a+ | Model a Modulator |
| IIP2 Testbench | simrfV2testbenches/IIP2 Testbench | R2023a+ | Measures the Input 2nd Intercept Point of a system. |
| IIP3 Testbench | simrfV2testbenches/IIP3 Testbench | R2023a+ | Measures the Input 3rd Intercept Point of a system. |
| Noise Figure Testbench | simrfV2testbenches/Noise Figure Testbench | R2023a+ | Measures the Noise Figure of a system. |
| OIP2 Testbench | simrfV2testbenches/OIP2 Testbench | R2023a+ | Measures the Output 2nd Intercept Point of a system. |
| OIP3 Testbench | simrfV2testbenches/OIP3 Testbench | R2023a+ | Measures the Output 3rd Intercept Point of a system. |
| S-Parameter Testbench | simrfV2testbenches/S-Parameter Testbench | R2023a+ | Measures the S-parameters of a system. |
| Transducer Gain Testbench | simrfV2testbenches/Transducer Gain Testbench | R2023a+ | Measures the Transducer Gain of a system. |
| Connection Label | simrfV2util1/Connection Label | R2023a+ | Create a wireless (label-based) connection between two points in a circuit-envelope network without drawing a wire — use to reduce clutter in large RF schematics. |
| Spectrum Analyzer | simrfV2util1/Spectrum Analyzer | R2023a+ | Display the frequency spectrum of a circuit-envelope RF signal during simulation — use to inspect power, harmonics, and spurious content. |
| Connection Port | simrfV2util1/Connection Port | R2023a+ | Expose a physical RF connection port on a circuit-envelope subsystem — use to create RF pins on a masked subsystem. |
| Configuration | simrfV2util1/Configuration | R2023a+ | Define RF Blockset Circuit Envelope system simulation settings. |
| Inport | simrfV2util1/Inport | R2023a+ | Convert Simulink signal to RF Blockset Circuit Envelope voltage or current. |
| Outport | simrfV2util1/Outport | R2023a+ | Convert RF Blockset Circuit Envelope voltage or current to Simulink signal. |
