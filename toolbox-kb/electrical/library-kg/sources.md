---
type: Simulink Block Category
title: Sources
description: Voltage and current sources, batteries, fuel cells, and supply rails
tags: [source, battery, solar, fuel, supply]
status: stable
source: mathworks_toolbox
library_root: Electrical
category_path: Sources
block_count: 16
---

# Sources

Use these blocks for sources.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Battery | ee_lib/Sources/Battery | R2023a+ | Model a battery with internal resistance and open-circuit voltage — use for EV powertrain, portable electronics, or energy storage system simulation |
| Battery (Table-Based) | ee_lib/Sources/Battery (Table-Based) | R2023a+ | Model a battery with SOC-dependent characteristics from lookup tables — use for accurate battery behavior over full charge/discharge cycles |
| Controlled Current Source (Three-Phase) | ee_lib/Sources/Controlled Current Source (Three-Phase) | R2023a+ | Inject three-phase currents controlled by external signals — use for current-source loads, harmonic injection, or custom power source modeling |
| Controlled Voltage Source (Three-Phase) | ee_lib/Sources/Controlled Voltage Source (Three-Phase) | R2023a+ | Generate three-phase voltages controlled by external signals — use for grid emulation, programmable sources, or custom voltage generation |
| Current Source (Three-Phase) | ee_lib/Sources/Current Source (Three-Phase) | R2023a+ | Model a three-phase ideal current source — use for representing current-source loads or injecting test currents into power systems |
| Current Source | ee_lib/Sources/Current Source | R2023a+ | Model an ideal or controlled current source — use for biasing, load representation, or signal injection in electrical circuits |
| Electrolyzer | ee_lib/Sources/Electrolyzer | R2023a+ | Model an electrolyzer converting electrical energy to hydrogen — use for green hydrogen production studies or power-to-gas system modeling |
| Fuel Cell | ee_lib/Sources/Fuel Cell | R2023a+ | Model a fuel cell generating electricity from hydrogen — use for fuel cell vehicle powertrains, backup power, or distributed generation studies |
| Load Flow Source | ee_lib/Sources/Load Flow Source | R2023a+ | Model a source for power flow initialization in power systems — use to set initial conditions for generators or infinite buses in load flow studies |
| Negative Supply Rail | ee_lib/Sources/Negative Supply Rail | R2023a+ | Provide a negative DC voltage reference — use for bipolar power supply rails in op-amp circuits or symmetric analog systems |
| Positive Supply Rail | ee_lib/Sources/Positive Supply Rail | R2023a+ | Provide a positive DC voltage reference — use for power supply rails in analog circuits, digital logic, or reference voltages |
| Programmable Voltage Source | ee_lib/Sources/Programmable Voltage Source | R2023a+ | Generate voltage waveforms defined by time-value sequences — use for arbitrary test signals, fault injection, or playback of recorded voltage profiles |
| Programmable Voltage Source (Three-Phase) | ee_lib/Sources/Programmable Voltage Source (Three-Phase) | R2023a+ | Generate three-phase voltage waveforms with programmable amplitude, frequency, and phase — use for grid emulation, voltage sag testing, or power quality studies |
| Solar Cell | ee_lib/Sources/Solar Cell | R2023a+ | Model a photovoltaic cell with irradiance and temperature dependent I-V characteristics — use for solar panel modeling, MPPT development, or PV system design |
| Voltage Source (Three-Phase) | ee_lib/Sources/Voltage Source (Three-Phase) | R2023a+ | Model an ideal three-phase voltage source — use for representing the utility grid, infinite bus, or balanced supply in power system models |
| Voltage Source | ee_lib/Sources/Voltage Source | R2023a+ | Model an ideal or controlled voltage source — use for power supplies, signal generators, or reference voltages in electrical circuits |
