---
type: Simulink Block Category
title: Integrated circuits
description: Op-amps, logic gates, flip-flops, comparators, and IC building blocks
tags: [opamp, cmos, gate, flip-flop, comparator]
status: stable
source: mathworks_toolbox
library_root: Electrical
category_path: Integrated circuits
block_count: 21
---

# Integrated circuits

Use these blocks for integrated circuits.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Band-Limited Op-Amp | ee_lib/Integrated Circuits/Band-Limited Op-Amp | R2023a+ | Model an operational amplifier with finite bandwidth and slew rate — use for realistic analog circuit design where frequency response and slew limiting matter |
| Comparator | ee_lib/Integrated Circuits/Comparator | R2023a+ | Model a voltage comparator with hysteresis and propagation delay — use for threshold detection, zero-crossing circuits, or ADC front-ends |
| Controlled PWM Voltage | ee_lib/Integrated Circuits/Controlled PWM Voltage | R2023a+ | Generate a PWM voltage waveform controlled by a duty-cycle input — use for power converter gate drive modeling or PWM-based signal generation |
| Finite-Gain Op-Amp | ee_lib/Integrated Circuits/Finite-Gain Op-Amp | R2023a+ | Model an operational amplifier with finite DC gain and output resistance — use for studying gain error, offset effects, or non-ideal amplifier behavior |
| Fully Differential Op-Amp | ee_lib/Integrated Circuits/Fully Differential Op-Amp | R2023a+ | Model a fully differential operational amplifier with common-mode rejection — use for differential signal processing, ADC drivers, or balanced analog circuits |
| Multiplier | ee_lib/Integrated Circuits/Multiplier | R2023a+ | Model an analog multiplier IC producing the product of two voltage inputs — use for modulation, gain control, power computation, or PLL phase detection |
| Operational Transconductance Amplifier | ee_lib/Integrated Circuits/Operational Transconductance Amplifier | R2023a+ | Model an OTA converting input voltage difference to output current — use for variable-gain amplifiers, Gm-C filters, or current-mode analog circuits |
| Push-Pull Output | ee_lib/Integrated Circuits/Push-Pull Output | R2023a+ | Model a push-pull output stage with complementary transistors — use for power amplifier output modeling, gate driver outputs, or Class-B/AB stages |
| Timer | ee_lib/Integrated Circuits/Timer | R2023a+ | Model a 555-style timer IC for monostable or astable operation — use for generating time delays, oscillations, or PWM signals in analog circuits |
| Voltage-Controlled Oscillator | ee_lib/Integrated Circuits/Voltage-Controlled Oscillator | R2023a+ | Model a VCO generating frequency proportional to input voltage — use for PLL design, frequency modulation, or clock generation circuits |
| CMOS AND | ee_lib/Integrated Circuits/Logic/CMOS AND | R2023a+ | Model a CMOS AND gate with realistic switching and propagation delay — use for digital logic circuits with physical voltage levels and timing |
| CMOS Buffer | ee_lib/Integrated Circuits/Logic/CMOS Buffer | R2023a+ | Model a CMOS buffer with drive strength and propagation delay — use for signal buffering, level restoration, or fan-out management in digital circuits |
| CMOS NAND | ee_lib/Integrated Circuits/Logic/CMOS NAND | R2023a+ | Model a CMOS NAND gate with realistic switching and propagation delay — use for digital logic design with physical electrical characteristics |
| CMOS NOR | ee_lib/Integrated Circuits/Logic/CMOS NOR | R2023a+ | Model a CMOS NOR gate with realistic switching characteristics — use for digital logic circuits requiring physical voltage levels and timing |
| CMOS NOT | ee_lib/Integrated Circuits/Logic/CMOS NOT | R2023a+ | Model a CMOS inverter with realistic switching characteristics — use for digital logic circuits or as a building block for gate-level simulation |
| CMOS OR | ee_lib/Integrated Circuits/Logic/CMOS OR | R2023a+ | Model a CMOS OR gate with realistic switching and propagation delay — use for digital logic circuits with physical electrical behavior |
| CMOS XOR | ee_lib/Integrated Circuits/Logic/CMOS XOR | R2023a+ | Model a CMOS XOR gate with realistic switching characteristics — use for parity checking, phase detection, or digital logic with physical timing |
| D Flip-Flop | ee_lib/Integrated Circuits/Logic/D Flip-Flop | R2024a+ | Model a D-type flip-flop with set, reset, and clock inputs — use for sequential digital logic, registers, or synchronization circuits |
| D Latch | ee_lib/Integrated Circuits/Logic/D Latch | R2024a+ | Model a transparent D latch — use for level-sensitive data storage, sample-and-hold logic, or combinational pipeline stages |
| S-R Latch | ee_lib/Integrated Circuits/Logic/S-R Latch | R2023a+ | Model a set-reset latch — use for basic memory elements, debouncing circuits, or event capture in digital control logic |
| Schmitt Trigger | ee_lib/Integrated Circuits/Logic/Schmitt Trigger | R2023a+ | Model a Schmitt trigger with hysteresis — use for noise-immune switching, signal conditioning, or converting slow edges to clean digital transitions |
