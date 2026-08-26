---
type: Simulink Block Category
title: Pwm timing
description: PWM generation, input capture, quadrature decoding, and timer peripherals for actuation and measurement
tags: [pwm, epwm, capture, ecap, eqep]
status: stable
source: mathworks_toolbox
library_root: C2000 Microcontroller Blockset
category_path: Pwm timing
block_count: 68
---

# Pwm timing

Use these blocks for pwm timing.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| eCAP | c2802xlib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c2802xlib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| HRCAP | c2803xlib/HRCAP | R2023b+ | Configure the High-Resolution Capture module for sub-nanosecond edge timestamping — use when standard capture resolution is insufficient for precision frequency or phase measurements |
| eCAP | c2803xlib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c2803xlib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c2803xlib/eQEP | R2023a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | c2805xlib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c2805xlib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c2805xlib/eQEP | R2023a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| HRCAP | c2806xlib/HRCAP | R2023b+ | Configure the High-Resolution Capture module for sub-nanosecond edge timestamping — use when standard capture resolution is insufficient for precision frequency or phase measurements |
| eCAP | c2806xlib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c2806xlib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c2806xlib/eQEP | R2023a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | c280xlib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c280xlib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c280xlib/eQEP | R2023a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| CAP | c281xlib/CAP | R2023a+ | Configure a capture input to timestamp rising/falling edges — use to measure signal timing on older C2000 devices without the enhanced capture module |
| PWM | c281xlib/PWM | R2023a+ | Configure a basic PWM output channel — use for simple duty-cycle generation when the full ePWM feature set is not required |
| QEP | c281xlib/QEP | R2023a+ | Configure the Quadrature Encoder Pulse module — use to decode rotary encoder signals for position and speed feedback on older C2000 devices |
| Timer | c281xlib/Timer | R2023a+ | Configure a CPU timer for periodic interrupt generation or elapsed time measurement — use to create fixed-rate sampling triggers independent of the ePWM system |
| eCAP | c2833xlib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c2833xlib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c2833xlib/eQEP | R2023a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | c2834xlib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c2834xlib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c2834xlib/eQEP | R2023a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | c280013xlib/eCAP | R2023b+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c280013xlib/ePWM | R2023b+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c280013xlib/eQEP | R2023b+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | c280015xlib/eCAP | R2023b+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c280015xlib/ePWM | R2023b+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c280015xlib/eQEP | R2023b+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | c28002xlib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c28002xlib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c28002xlib/eQEP | R2023a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | c28003xlib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c28003xlib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c28003xlib/eQEP | R2023a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | c28004xlib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c28004xlib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c28004xlib/eQEP | R2023a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | c2807xlib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c2807xlib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c2807xlib/eQEP | R2023a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | c2837xDlib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c2837xDlib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c2837xDlib/eQEP | R2023a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | c2837xSlib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c2837xSlib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c2837xSlib/eQEP | R2023a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | c2838xlib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c2838xlib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c2838xlib/eQEP | R2023a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | f28M35x_C28x_lib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | f28M35x_C28x_lib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | f28M35x_C28x_lib/eQEP | R2023a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | f28M36x_C28x_lib/eCAP | R2023a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | f28M36x_C28x_lib/ePWM | R2023a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | f28M36x_C28x_lib/eQEP | R2023a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | c28P55xlib/eCAP | R2024b+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c28P55xlib/ePWM | R2024b+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c28P55xlib/eQEP | R2024b+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | c28P65xlib/eCAP | R2024a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c28P65xlib/ePWM | R2024a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c28P65xlib/eQEP | R2024a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
| eCAP | c29H85xlib/eCAP | R2026a+ | Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses |
| ePWM | c29H85xlib/ePWM | R2025a+ | Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation |
| eQEP | c29H85xlib/eQEP | R2026a+ | Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control |
