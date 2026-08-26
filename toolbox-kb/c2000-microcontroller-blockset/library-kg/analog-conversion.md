---
type: Simulink Block Category
title: Analog conversion
description: ADC, DAC, comparators, and sigma-delta filter modules for analog signal acquisition and generation
tags: [adc, dac, comparator, analog, sigma-delta]
status: stable
source: mathworks_toolbox
library_root: C2000 Microcontroller Blockset
category_path: Analog conversion
block_count: 65
---

# Analog conversion

Use these blocks for analog conversion.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ADC | c2802xlib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| AnalogIO Input | c2802xlib/AnalogIO Input | R2023a+ | Read an analog I/O pin configured as input — use to acquire raw analog voltage levels from external circuits or sensor outputs on supported device pins |
| AnalogIO Output | c2802xlib/AnalogIO Output | R2023a+ | Write to an analog I/O pin configured as output — use to drive analog voltage levels for DAC-like functionality on supported device pins |
| COMP | c2802xlib/COMP | R2023a+ | Configure the on-chip analog comparator — use to generate a digital output when an input signal crosses a programmable threshold for fast overcurrent or overvoltage protection without CPU intervention |
| ADC | c2803xlib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| AnalogIO Input | c2803xlib/AnalogIO Input | R2023a+ | Read an analog I/O pin configured as input — use to acquire raw analog voltage levels from external circuits or sensor outputs on supported device pins |
| AnalogIO Output | c2803xlib/AnalogIO Output | R2023a+ | Write to an analog I/O pin configured as output — use to drive analog voltage levels for DAC-like functionality on supported device pins |
| COMP | c2803xlib/COMP | R2023a+ | Configure the on-chip analog comparator — use to generate a digital output when an input signal crosses a programmable threshold for fast overcurrent or overvoltage protection without CPU intervention |
| ADC | c2805xlib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| ADC | c2806xlib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| AnalogIO Input | c2806xlib/AnalogIO Input | R2023a+ | Read an analog I/O pin configured as input — use to acquire raw analog voltage levels from external circuits or sensor outputs on supported device pins |
| AnalogIO Output | c2806xlib/AnalogIO Output | R2023a+ | Write to an analog I/O pin configured as output — use to drive analog voltage levels for DAC-like functionality on supported device pins |
| COMP | c2806xlib/COMP | R2023a+ | Configure the on-chip analog comparator — use to generate a digital output when an input signal crosses a programmable threshold for fast overcurrent or overvoltage protection without CPU intervention |
| ADC | c280xlib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| ADC | c281xlib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| ADC | c2833xlib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| ADC | c280013xlib/ADC | R2023b+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| CMPSS | c280013xlib/CMPSS | R2023b+ | Configure the Comparator Subsystem with integrated DAC reference and digital filter — use for advanced trip-zone protection with programmable hysteresis and blanking windows in motor drive applications |
| ADC | c280015xlib/ADC | R2023b+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| CMPSS | c280015xlib/CMPSS | R2023b+ | Configure the Comparator Subsystem with integrated DAC reference and digital filter — use for advanced trip-zone protection with programmable hysteresis and blanking windows in motor drive applications |
| ADC | c28002xlib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| CMPSS | c28002xlib/CMPSS | R2023a+ | Configure the Comparator Subsystem with integrated DAC reference and digital filter — use for advanced trip-zone protection with programmable hysteresis and blanking windows in motor drive applications |
| ADC | c28003xlib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| CMPSS | c28003xlib/CMPSS | R2023a+ | Configure the Comparator Subsystem with integrated DAC reference and digital filter — use for advanced trip-zone protection with programmable hysteresis and blanking windows in motor drive applications |
| DAC | c28003xlib/DAC | R2023a+ | Configure and write to the on-chip digital-to-analog converter — use to generate analog reference voltages for comparators, bias points, or low-frequency analog control outputs |
| SDFM | c28003xlib/SDFM | R2023a+ | Configure the Sigma-Delta Filter Module to demodulate sigma-delta modulator bitstreams — use to interface with isolated sigma-delta current/voltage sensors for high-resolution measurements in motor drives |
| ADC | c28004xlib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| CMPSS | c28004xlib/CMPSS | R2023a+ | Configure the Comparator Subsystem with integrated DAC reference and digital filter — use for advanced trip-zone protection with programmable hysteresis and blanking windows in motor drive applications |
| DAC | c28004xlib/DAC | R2023a+ | Configure and write to the on-chip digital-to-analog converter — use to generate analog reference voltages for comparators, bias points, or low-frequency analog control outputs |
| SDFM | c28004xlib/SDFM | R2023a+ | Configure the Sigma-Delta Filter Module to demodulate sigma-delta modulator bitstreams — use to interface with isolated sigma-delta current/voltage sensors for high-resolution measurements in motor drives |
| ADC | c2807xlib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| CMPSS | c2807xlib/CMPSS | R2023a+ | Configure the Comparator Subsystem with integrated DAC reference and digital filter — use for advanced trip-zone protection with programmable hysteresis and blanking windows in motor drive applications |
| DAC | c2807xlib/DAC | R2023a+ | Configure and write to the on-chip digital-to-analog converter — use to generate analog reference voltages for comparators, bias points, or low-frequency analog control outputs |
| SDFM | c2807xlib/SDFM | R2023a+ | Configure the Sigma-Delta Filter Module to demodulate sigma-delta modulator bitstreams — use to interface with isolated sigma-delta current/voltage sensors for high-resolution measurements in motor drives |
| ADC | c2837xDlib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| CMPSS | c2837xDlib/CMPSS | R2023a+ | Configure the Comparator Subsystem with integrated DAC reference and digital filter — use for advanced trip-zone protection with programmable hysteresis and blanking windows in motor drive applications |
| DAC | c2837xDlib/DAC | R2023a+ | Configure and write to the on-chip digital-to-analog converter — use to generate analog reference voltages for comparators, bias points, or low-frequency analog control outputs |
| SDFM | c2837xDlib/SDFM | R2023a+ | Configure the Sigma-Delta Filter Module to demodulate sigma-delta modulator bitstreams — use to interface with isolated sigma-delta current/voltage sensors for high-resolution measurements in motor drives |
| ADC | c2837xSlib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| CMPSS | c2837xSlib/CMPSS | R2023a+ | Configure the Comparator Subsystem with integrated DAC reference and digital filter — use for advanced trip-zone protection with programmable hysteresis and blanking windows in motor drive applications |
| DAC | c2837xSlib/DAC | R2023a+ | Configure and write to the on-chip digital-to-analog converter — use to generate analog reference voltages for comparators, bias points, or low-frequency analog control outputs |
| SDFM | c2837xSlib/SDFM | R2023a+ | Configure the Sigma-Delta Filter Module to demodulate sigma-delta modulator bitstreams — use to interface with isolated sigma-delta current/voltage sensors for high-resolution measurements in motor drives |
| ADC | c2838xlib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| CMPSS | c2838xlib/CMPSS | R2023a+ | Configure the Comparator Subsystem with integrated DAC reference and digital filter — use for advanced trip-zone protection with programmable hysteresis and blanking windows in motor drive applications |
| DAC | c2838xlib/DAC | R2023a+ | Configure and write to the on-chip digital-to-analog converter — use to generate analog reference voltages for comparators, bias points, or low-frequency analog control outputs |
| SDFM | c2838xlib/SDFM | R2023a+ | Configure the Sigma-Delta Filter Module to demodulate sigma-delta modulator bitstreams — use to interface with isolated sigma-delta current/voltage sensors for high-resolution measurements in motor drives |
| ADC | f28M35x_C28x_lib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| AnalogIO Input | f28M35x_C28x_lib/AnalogIO Input | R2023a+ | Read an analog I/O pin configured as input — use to acquire raw analog voltage levels from external circuits or sensor outputs on supported device pins |
| AnalogIO Output | f28M35x_C28x_lib/AnalogIO Output | R2023a+ | Write to an analog I/O pin configured as output — use to drive analog voltage levels for DAC-like functionality on supported device pins |
| COMP | f28M35x_C28x_lib/COMP | R2023a+ | Configure the on-chip analog comparator — use to generate a digital output when an input signal crosses a programmable threshold for fast overcurrent or overvoltage protection without CPU intervention |
| ADC | f28M36x_C28x_lib/ADC | R2023a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| AnalogIO Input | f28M36x_C28x_lib/AnalogIO Input | R2023a+ | Read an analog I/O pin configured as input — use to acquire raw analog voltage levels from external circuits or sensor outputs on supported device pins |
| AnalogIO Output | f28M36x_C28x_lib/AnalogIO Output | R2023a+ | Write to an analog I/O pin configured as output — use to drive analog voltage levels for DAC-like functionality on supported device pins |
| COMP | f28M36x_C28x_lib/COMP | R2023a+ | Configure the on-chip analog comparator — use to generate a digital output when an input signal crosses a programmable threshold for fast overcurrent or overvoltage protection without CPU intervention |
| ADC | c28P55xlib/ADC | R2024b+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| CMPSS | c28P55xlib/CMPSS | R2024b+ | Configure the Comparator Subsystem with integrated DAC reference and digital filter — use for advanced trip-zone protection with programmable hysteresis and blanking windows in motor drive applications |
| DAC | c28P55xlib/DAC | R2024b+ | Configure and write to the on-chip digital-to-analog converter — use to generate analog reference voltages for comparators, bias points, or low-frequency analog control outputs |
| ADC | c28P65xlib/ADC | R2024a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| CMPSS | c28P65xlib/CMPSS | R2024a+ | Configure the Comparator Subsystem with integrated DAC reference and digital filter — use for advanced trip-zone protection with programmable hysteresis and blanking windows in motor drive applications |
| DAC | c28P65xlib/DAC | R2024a+ | Configure and write to the on-chip digital-to-analog converter — use to generate analog reference voltages for comparators, bias points, or low-frequency analog control outputs |
| SDFM | c28P65xlib/SDFM | R2024a+ | Configure the Sigma-Delta Filter Module to demodulate sigma-delta modulator bitstreams — use to interface with isolated sigma-delta current/voltage sensors for high-resolution measurements in motor drives |
| ADC | c29H85xlib/ADC | R2025a+ | Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control |
| CMPSS | c29H85xlib/CMPSS | R2026a+ | Configure the Comparator Subsystem with integrated DAC reference and digital filter — use for advanced trip-zone protection with programmable hysteresis and blanking windows in motor drive applications |
| DAC | c29H85xlib/DAC | R2026a+ | Configure and write to the on-chip digital-to-analog converter — use to generate analog reference voltages for comparators, bias points, or low-frequency analog control outputs |
| SDFM | c29H85xlib/SDFM | R2026a+ | Configure the Sigma-Delta Filter Module to demodulate sigma-delta modulator bitstreams — use to interface with isolated sigma-delta current/voltage sensors for high-resolution measurements in motor drives |
