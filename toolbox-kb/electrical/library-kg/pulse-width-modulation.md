---
type: Simulink Block Category
title: Pulse width modulation
description: PWM generators, gate signal generators, and thyristor pulse generators
tags: [pwm, modulation, gate, carrier, thyristor]
status: stable
source: mathworks_toolbox
library_root: Electrical
category_path: Pulse width modulation
block_count: 17
---

# Pulse width modulation

Use these blocks for pulse width modulation.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| PWM Gate Signal Generator (Five-phase, Two-level) | ee_sl_lib/Pulse Width Modulation/PWM Gate Signal Generator (Five-phase, Two-level) | R2023a+ | Generate gate signals for a five-phase two-level inverter from duty cycle inputs — use for multiphase drive gate signal generation |
| PWM Gate Signal Generator (Four-phase, Two-level) | ee_sl_lib/Pulse Width Modulation/PWM Gate Signal Generator (Four-phase, Two-level) | R2023a+ | Generate gate signals for a four-phase two-level inverter from duty cycle inputs — use for four-phase drive switching |
| PWM Gate Signal Generator (Three-phase, Three-level) | ee_sl_lib/Pulse Width Modulation/PWM Gate Signal Generator (Three-phase, Three-level) | R2023a+ | Generate gate signals for a three-phase three-level converter from duty cycle inputs — use for NPC or T-type converter switching |
| PWM Gate Signal Generator (Three-phase, Two-level) | ee_sl_lib/Pulse Width Modulation/PWM Gate Signal Generator (Three-phase, Two-level) | R2023a+ | Generate gate signals for a standard three-phase two-level inverter from duty cycle inputs — use for motor drive or grid-tie inverter switching |
| PWM Generator | ee_sl_lib/Pulse Width Modulation/PWM Generator | R2023a+ | Generate a single-phase PWM signal from a modulation index input — use for single-phase converters, choppers, or general PWM waveform generation |
| PWM Generator (Five-phase, Two-level) | ee_sl_lib/Pulse Width Modulation/PWM Generator (Five-phase, Two-level) | R2023a+ | Generate five-phase PWM signals using carrier comparison — use for five-phase motor drive modulation with configurable carrier and reference |
| PWM Generator (Four-phase, Two-level) | ee_sl_lib/Pulse Width Modulation/PWM Generator (Four-phase, Two-level) | R2023a+ | Generate four-phase PWM signals using carrier comparison — use for four-phase drive modulation |
| PWM Generator (Multilevel) | ee_sl_lib/Pulse Width Modulation/PWM Generator (Multilevel) | R2023a+ | Generate PWM signals for multilevel converter topologies — use for cascaded H-bridge, flying capacitor, or other multi-level switching schemes |
| PWM Generator (Three-phase, Three-level) | ee_sl_lib/Pulse Width Modulation/PWM Generator (Three-phase, Three-level) | R2023a+ | Generate three-phase PWM signals for a three-level converter — use for NPC or T-type inverter modulation with carrier disposition or SVM |
| PWM Generator (Three-phase, Two-level) | ee_sl_lib/Pulse Width Modulation/PWM Generator (Three-phase, Two-level) | R2023a+ | Generate three-phase PWM signals using carrier comparison or space vector modulation — use for standard three-phase inverter control |
| PWM Generator (Vienna Rectifier) | ee_sl_lib/Pulse Width Modulation/PWM Generator (Vienna Rectifier) | R2023a+ | Generate PWM signals for a Vienna-type three-phase rectifier — use for unity power factor rectification with Vienna topology switching |
| PWM Timing and Waveform Generator (Five-phase, Two-level) | ee_sl_lib/Pulse Width Modulation/PWM Timing and Waveform Generator (Five-phase, Two-level) | R2023a+ | Generate timing-accurate PWM waveforms for five-phase converters — use when precise switching timing is needed for center-aligned modulation |
| PWM Timing and Waveform Generator (Four-phase, Two-level) | ee_sl_lib/Pulse Width Modulation/PWM Timing and Waveform Generator (Four-phase, Two-level) | R2023a+ | Generate timing-accurate PWM waveforms for four-phase converters — use for precise dead-time and switching-instant control |
| PWM Timing and Waveform Generator (Three-phase, Three-level) | ee_sl_lib/Pulse Width Modulation/PWM Timing and Waveform Generator (Three-phase, Three-level) | R2023a+ | Generate timing-accurate PWM waveforms for three-level converters — use for precise switching of NPC or T-type topologies |
| PWM Timing and Waveform Generator (Three-phase, Two-level) | ee_sl_lib/Pulse Width Modulation/PWM Timing and Waveform Generator (Three-phase, Two-level) | R2023a+ | Generate timing-accurate PWM waveforms for three-phase two-level inverters — use for center-aligned modulation with precise dead-time |
| Thyristor 12-Pulse Generator | ee_sl_lib/Pulse Width Modulation/Thyristor 12-Pulse Generator | R2023a+ | Generate firing pulses for a 12-pulse thyristor converter — use for HVDC converters or high-power rectifiers with two six-pulse bridges |
| Thyristor 6-Pulse Generator | ee_sl_lib/Pulse Width Modulation/Thyristor 6-Pulse Generator | R2023a+ | Generate firing pulses for a standard 6-pulse thyristor bridge — use for controlled rectifiers, DC motor drives, or industrial thyristor converters |
