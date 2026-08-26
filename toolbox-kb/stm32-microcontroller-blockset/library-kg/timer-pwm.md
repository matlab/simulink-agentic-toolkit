---
type: Simulink Block Category
title: Timer pwm
description: Hardware timer peripherals for timing, PWM generation, input capture, and encoder decoding
tags: [timer, PWM, encoder, capture, pulse]
status: stable
source: mathworks_toolbox
library_root: STM32 Microcontroller Blockset
category_path: Timer pwm
block_count: 61
---

# Timer pwm

Use these blocks for timer pwm.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Encoder | stm32f1xxblockslib/Encoder | R2026a+ | Read quadrature encoder signals to track rotational position and speed of a motor shaft |
| PWM Output | stm32f1xxblockslib/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| Timer | stm32f1xxblockslib/Timer | R2026a+ | Generate precise time delays or trigger periodic events using a hardware timer on the STM32 |
| Timer Capture | stm32f1xxblockslib/Timer Capture | R2026a+ | Measure the timing of external signal edges for pulse width or frequency measurement |
| Encoder | stm32f2xxblockslib/Encoder | R2026a+ | Read quadrature encoder signals to track rotational position and speed of a motor shaft |
| PWM Output | stm32f2xxblockslib/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| Timer | stm32f2xxblockslib/Timer | R2026a+ | Generate precise time delays or trigger periodic events using a hardware timer on the STM32 |
| Timer Capture | stm32f2xxblockslib/Timer Capture | R2026a+ | Measure the timing of external signal edges for pulse width or frequency measurement |
| Encoder | stm32f3xxblockslib/Encoder | R2026a+ | Read quadrature encoder signals to track rotational position and speed of a motor shaft |
| High Resolution Timer | stm32f3xxblockslib/High Resolution Timer | R2026a+ | Generate sub-nanosecond resolution PWM for advanced power conversion or motor control |
| PWM Output | stm32f3xxblockslib/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| Timer | stm32f3xxblockslib/Timer | R2026a+ | Generate precise time delays or trigger periodic events using a hardware timer on the STM32 |
| Timer Capture | stm32f3xxblockslib/Timer Capture | R2026a+ | Measure the timing of external signal edges for pulse width or frequency measurement |
| PWM Output | stm32f4xxblockslib/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| Encoder | stm32f4xxblockslib/Encoder | R2026a+ | Read quadrature encoder signals to track rotational position and speed of a motor shaft |
| Timer | stm32f4xxblockslib/Timer | R2026a+ | Generate precise time delays or trigger periodic events using a hardware timer on the STM32 |
| Timer Capture | stm32f4xxblockslib/Timer Capture | R2026a+ | Measure the timing of external signal edges for pulse width or frequency measurement |
| Encoder | stm32f7xxblockslib/Encoder | R2026a+ | Read quadrature encoder signals to track rotational position and speed of a motor shaft |
| PWM Output | stm32f7xxblockslib/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| Timer | stm32f7xxblockslib/Timer | R2026a+ | Generate precise time delays or trigger periodic events using a hardware timer on the STM32 |
| Timer Capture | stm32f7xxblockslib/Timer Capture | R2026a+ | Measure the timing of external signal edges for pulse width or frequency measurement |
| Encoder | stm32g0xxblockslib/Encoder | R2026a+ | Read quadrature encoder signals to track rotational position and speed of a motor shaft |
| PWM Output | stm32g0xxblockslib/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| Timer | stm32g0xxblockslib/Timer | R2026a+ | Generate precise time delays or trigger periodic events using a hardware timer on the STM32 |
| Timer Capture | stm32g0xxblockslib/Timer Capture | R2026a+ | Measure the timing of external signal edges for pulse width or frequency measurement |
| Encoder | stm32g4xxblockslib/Encoder | R2026a+ | Read quadrature encoder signals to track rotational position and speed of a motor shaft |
| High Resolution Timer | stm32g4xxblockslib/High Resolution Timer | R2026a+ | Generate sub-nanosecond resolution PWM for advanced power conversion or motor control |
| PWM Output | stm32g4xxblockslib/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| Timer | stm32g4xxblockslib/Timer | R2026a+ | Generate precise time delays or trigger periodic events using a hardware timer on the STM32 |
| Timer Capture | stm32g4xxblockslib/Timer Capture | R2026a+ | Measure the timing of external signal edges for pulse width or frequency measurement |
| Encoder | stm32h5xxblockslib/Encoder | R2026a+ | Read quadrature encoder signals to track rotational position and speed of a motor shaft |
| PWM Output | stm32h5xxblockslib/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| Timer | stm32h5xxblockslib/Timer | R2026a+ | Generate precise time delays or trigger periodic events using a hardware timer on the STM32 |
| Timer Capture | stm32h5xxblockslib/Timer Capture | R2026a+ | Measure the timing of external signal edges for pulse width or frequency measurement |
| Encoder | stm32h7xxblockslib/Encoder | R2026a+ | Read quadrature encoder signals to track rotational position and speed of a motor shaft |
| High Resolution Timer | stm32h7xxblockslib/High Resolution Timer | R2026a+ | Generate sub-nanosecond resolution PWM for advanced power conversion or motor control |
| PWM Output | stm32h7xxblockslib/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| Timer | stm32h7xxblockslib/Timer | R2026a+ | Generate precise time delays or trigger periodic events using a hardware timer on the STM32 |
| Timer Capture | stm32h7xxblockslib/Timer Capture | R2026a+ | Measure the timing of external signal edges for pulse width or frequency measurement |
| Encoder | stm32l4xxblockslib/Encoder | R2026a+ | Read quadrature encoder signals to track rotational position and speed of a motor shaft |
| PWM Output | stm32l4xxblockslib/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| Timer | stm32l4xxblockslib/Timer | R2026a+ | Generate precise time delays or trigger periodic events using a hardware timer on the STM32 |
| Timer Capture | stm32l4xxblockslib/Timer Capture | R2026a+ | Measure the timing of external signal edges for pulse width or frequency measurement |
| Encoder | stm32l5xxblockslib/Encoder | R2026a+ | Read quadrature encoder signals to track rotational position and speed of a motor shaft |
| PWM Output | stm32l5xxblockslib/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| Timer | stm32l5xxblockslib/Timer | R2026a+ | Generate precise time delays or trigger periodic events using a hardware timer on the STM32 |
| Timer Capture | stm32l5xxblockslib/Timer Capture | R2026a+ | Measure the timing of external signal edges for pulse width or frequency measurement |
| Encoder | stm32u5xxblockslib/Encoder | R2026a+ | Read quadrature encoder signals to track rotational position and speed of a motor shaft |
| PWM Output | stm32u5xxblockslib/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| Timer | stm32u5xxblockslib/Timer | R2026a+ | Generate precise time delays or trigger periodic events using a hardware timer on the STM32 |
| Timer Capture | stm32u5xxblockslib/Timer Capture | R2026a+ | Measure the timing of external signal edges for pulse width or frequency measurement |
| Encoder | stm32wbxxblockslib/Encoder | R2026a+ | Read quadrature encoder signals to track rotational position and speed of a motor shaft |
| PWM Output | stm32wbxxblockslib/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| Timer | stm32wbxxblockslib/Timer | R2026a+ | Generate precise time delays or trigger periodic events using a hardware timer on the STM32 |
| Timer Capture | stm32wbxxblockslib/Timer Capture | R2026a+ | Measure the timing of external signal edges for pulse width or frequency measurement |
| PWM Output | stm32f7lib/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| PWM Output | stm32f769ilib/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| PWM Output | stm32nucleodiscoboardslib/Common/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| PWM Output | stm32nucleodiscoboardslib/MBED Based Sensors/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| PWM Output | stm32nucleodiscoboardslib/STM32F7/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
| PWM Output | stm32nucleodiscoboardslib/STM32H7/PWM Output | R2026a+ | Generate a pulse-width modulated signal for motor control, LED dimming, or servo positioning |
