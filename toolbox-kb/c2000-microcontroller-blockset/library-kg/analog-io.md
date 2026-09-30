---
type: Simulink Block Category
title: Analog io
description: ADC, DAC, comparator, and sigma-delta analog interfaces
tags: [adc, dac, comparator, analog, sdfm, cmpss]
status: stable
source: custom_library
library_root: C2000 Microcontroller Blockset
category_path: Analog io
block_count: 65
---

# Analog io

Use these blocks for analog io.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ADC | c2802xlib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| AnalogIO Input | c2802xlib/AnalogIO Input | R2023a+ | Read an analog input channel — use to acquire analog voltage levels. |
| AnalogIO Output | c2802xlib/AnalogIO Output | R2023a+ | Drive an analog output channel — use to produce analog voltage levels. |
| COMP | c2802xlib/COMP | R2023a+ | Configure the on-chip analog comparator — use for fast analog threshold detection such as overcurrent trip. |
| ADC | c2803xlib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| AnalogIO Input | c2803xlib/AnalogIO Input | R2023a+ | Read an analog input channel — use to acquire analog voltage levels. |
| AnalogIO Output | c2803xlib/AnalogIO Output | R2023a+ | Drive an analog output channel — use to produce analog voltage levels. |
| COMP | c2803xlib/COMP | R2023a+ | Configure the on-chip analog comparator — use for fast analog threshold detection such as overcurrent trip. |
| ADC | c280xlib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| ADC | c281xlib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| ADC | c2833xlib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| ADC | c2805xlib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| ADC | c2806xlib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| AnalogIO Input | c2806xlib/AnalogIO Input | R2023a+ | Read an analog input channel — use to acquire analog voltage levels. |
| AnalogIO Output | c2806xlib/AnalogIO Output | R2023a+ | Drive an analog output channel — use to produce analog voltage levels. |
| COMP | c2806xlib/COMP | R2023a+ | Configure the on-chip analog comparator — use for fast analog threshold detection such as overcurrent trip. |
| ADC | c280013xlib/ADC | R2023b+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| CMPSS | c280013xlib/CMPSS | R2023b+ | Configure the comparator subsystem (CMPSS) with DAC references — use for analog protection and windowed comparison. |
| ADC | c280015xlib/ADC | R2023b+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| CMPSS | c280015xlib/CMPSS | R2023b+ | Configure the comparator subsystem (CMPSS) with DAC references — use for analog protection and windowed comparison. |
| ADC | c28002xlib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| CMPSS | c28002xlib/CMPSS | R2023a+ | Configure the comparator subsystem (CMPSS) with DAC references — use for analog protection and windowed comparison. |
| ADC | c28003xlib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| CMPSS | c28003xlib/CMPSS | R2023a+ | Configure the comparator subsystem (CMPSS) with DAC references — use for analog protection and windowed comparison. |
| DAC | c28003xlib/DAC | R2023a+ | Output an analog voltage via the on-chip DAC — use to generate reference or analog output signals. |
| SDFM | c28003xlib/SDFM | R2023a+ | Configure the Sigma-Delta Filter Module — use to interface isolated sigma-delta modulators for current/voltage sensing. |
| ADC | c28004xlib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| CMPSS | c28004xlib/CMPSS | R2023a+ | Configure the comparator subsystem (CMPSS) with DAC references — use for analog protection and windowed comparison. |
| DAC | c28004xlib/DAC | R2023a+ | Output an analog voltage via the on-chip DAC — use to generate reference or analog output signals. |
| SDFM | c28004xlib/SDFM | R2023a+ | Configure the Sigma-Delta Filter Module — use to interface isolated sigma-delta modulators for current/voltage sensing. |
| ADC | c2807xlib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| CMPSS | c2807xlib/CMPSS | R2023a+ | Configure the comparator subsystem (CMPSS) with DAC references — use for analog protection and windowed comparison. |
| DAC | c2807xlib/DAC | R2023a+ | Output an analog voltage via the on-chip DAC — use to generate reference or analog output signals. |
| SDFM | c2807xlib/SDFM | R2023a+ | Configure the Sigma-Delta Filter Module — use to interface isolated sigma-delta modulators for current/voltage sensing. |
| ADC | c2837xDlib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| CMPSS | c2837xDlib/CMPSS | R2023a+ | Configure the comparator subsystem (CMPSS) with DAC references — use for analog protection and windowed comparison. |
| DAC | c2837xDlib/DAC | R2023a+ | Output an analog voltage via the on-chip DAC — use to generate reference or analog output signals. |
| SDFM | c2837xDlib/SDFM | R2023a+ | Configure the Sigma-Delta Filter Module — use to interface isolated sigma-delta modulators for current/voltage sensing. |
| ADC | c2837xSlib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| CMPSS | c2837xSlib/CMPSS | R2023a+ | Configure the comparator subsystem (CMPSS) with DAC references — use for analog protection and windowed comparison. |
| DAC | c2837xSlib/DAC | R2023a+ | Output an analog voltage via the on-chip DAC — use to generate reference or analog output signals. |
| SDFM | c2837xSlib/SDFM | R2023a+ | Configure the Sigma-Delta Filter Module — use to interface isolated sigma-delta modulators for current/voltage sensing. |
| ADC | c2838xlib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| CMPSS | c2838xlib/CMPSS | R2023a+ | Configure the comparator subsystem (CMPSS) with DAC references — use for analog protection and windowed comparison. |
| DAC | c2838xlib/DAC | R2023a+ | Output an analog voltage via the on-chip DAC — use to generate reference or analog output signals. |
| SDFM | c2838xlib/SDFM | R2023a+ | Configure the Sigma-Delta Filter Module — use to interface isolated sigma-delta modulators for current/voltage sensing. |
| ADC | f28M35x_C28x_lib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| AnalogIO Input | f28M35x_C28x_lib/AnalogIO Input | R2023a+ | Read an analog input channel — use to acquire analog voltage levels. |
| AnalogIO Output | f28M35x_C28x_lib/AnalogIO Output | R2023a+ | Drive an analog output channel — use to produce analog voltage levels. |
| COMP | f28M35x_C28x_lib/COMP | R2023a+ | Configure the on-chip analog comparator — use for fast analog threshold detection such as overcurrent trip. |
| ADC | f28M36x_C28x_lib/ADC | R2023a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| AnalogIO Input | f28M36x_C28x_lib/AnalogIO Input | R2023a+ | Read an analog input channel — use to acquire analog voltage levels. |
| AnalogIO Output | f28M36x_C28x_lib/AnalogIO Output | R2023a+ | Drive an analog output channel — use to produce analog voltage levels. |
| COMP | f28M36x_C28x_lib/COMP | R2023a+ | Configure the on-chip analog comparator — use for fast analog threshold detection such as overcurrent trip. |
| ADC | c28P55xlib/ADC | R2024b+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| CMPSS | c28P55xlib/CMPSS | R2024b+ | Configure the comparator subsystem (CMPSS) with DAC references — use for analog protection and windowed comparison. |
| DAC | c28P55xlib/DAC | R2024b+ | Output an analog voltage via the on-chip DAC — use to generate reference or analog output signals. |
| ADC | c28P65xlib/ADC | R2024a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| CMPSS | c28P65xlib/CMPSS | R2024a+ | Configure the comparator subsystem (CMPSS) with DAC references — use for analog protection and windowed comparison. |
| DAC | c28P65xlib/DAC | R2024a+ | Output an analog voltage via the on-chip DAC — use to generate reference or analog output signals. |
| SDFM | c28P65xlib/SDFM | R2024a+ | Configure the Sigma-Delta Filter Module — use to interface isolated sigma-delta modulators for current/voltage sensing. |
| ADC | c29H85xlib/ADC | R2025a+ | Read analog inputs via the on-chip ADC — use to sample sensor voltages and analog signals. |
| CMPSS | c29H85xlib/CMPSS | R2026a+ | Configure the comparator subsystem (CMPSS) with DAC references — use for analog protection and windowed comparison. |
| DAC | c29H85xlib/DAC | R2026a+ | Output an analog voltage via the on-chip DAC — use to generate reference or analog output signals. |
| SDFM | c29H85xlib/SDFM | R2026a+ | Configure the Sigma-Delta Filter Module — use to interface isolated sigma-delta modulators for current/voltage sensing. |
