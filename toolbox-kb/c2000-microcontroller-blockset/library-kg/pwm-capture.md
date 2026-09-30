---
type: Simulink Block Category
title: Pwm capture
description: PWM generation and pulse/encoder capture
tags: [pwm, epwm, ecap, eqep, capture, encoder]
status: stable
source: custom_library
library_root: C2000 Microcontroller Blockset
category_path: Pwm capture
block_count: 66
---

# Pwm capture

Use these blocks for pwm capture.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| eCAP | c2802xlib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c2802xlib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| HRCAP | c2803xlib/HRCAP | R2023b+ | Use the high-resolution capture peripheral — use for precise input pulse-timing measurement. |
| eCAP | c2803xlib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c2803xlib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c2803xlib/eQEP | R2023a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | c280xlib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c280xlib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c280xlib/eQEP | R2023a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| CAP | c281xlib/CAP | R2023a+ | Configures the Event Manager of the C281x DSP for CAP (capture). |
| PWM | c281xlib/PWM | R2023a+ | Configures the Event Manager of the C281x DSP to generate PWM waveforms. |
| eCAP | c2833xlib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c2833xlib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c2833xlib/eQEP | R2023a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | c2834xlib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c2834xlib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c2834xlib/eQEP | R2023a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | c2805xlib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c2805xlib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c2805xlib/eQEP | R2023a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| HRCAP | c2806xlib/HRCAP | R2023b+ | Use the high-resolution capture peripheral — use for precise input pulse-timing measurement. |
| eCAP | c2806xlib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c2806xlib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c2806xlib/eQEP | R2023a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | c280013xlib/eCAP | R2023b+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c280013xlib/ePWM | R2023b+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c280013xlib/eQEP | R2023b+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | c280015xlib/eCAP | R2023b+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c280015xlib/ePWM | R2023b+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c280015xlib/eQEP | R2023b+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | c28002xlib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c28002xlib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c28002xlib/eQEP | R2023a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | c28003xlib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c28003xlib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c28003xlib/eQEP | R2023a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | c28004xlib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c28004xlib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c28004xlib/eQEP | R2023a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | c2807xlib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c2807xlib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c2807xlib/eQEP | R2023a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | c2837xDlib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c2837xDlib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c2837xDlib/eQEP | R2023a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | c2837xSlib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c2837xSlib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c2837xSlib/eQEP | R2023a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | c2838xlib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c2838xlib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c2838xlib/eQEP | R2023a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | f28M35x_C28x_lib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | f28M35x_C28x_lib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | f28M35x_C28x_lib/eQEP | R2023a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | f28M36x_C28x_lib/eCAP | R2023a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | f28M36x_C28x_lib/ePWM | R2023a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | f28M36x_C28x_lib/eQEP | R2023a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | c28P55xlib/eCAP | R2024b+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c28P55xlib/ePWM | R2024b+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c28P55xlib/eQEP | R2024b+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | c28P65xlib/eCAP | R2024a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c28P65xlib/ePWM | R2024a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c28P65xlib/eQEP | R2024a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
| eCAP | c29H85xlib/eCAP | R2026a+ | Capture the timing of input pulse edges (enhanced Capture) — use to measure period, frequency, or duty cycle. |
| ePWM | c29H85xlib/ePWM | R2025a+ | Generate enhanced PWM waveforms — use to drive motor phases, power converters, and switching stages. |
| eQEP | c29H85xlib/eQEP | R2026a+ | Decode a quadrature encoder (enhanced QEP) — use to measure position and speed from an encoder. |
