---
type: Simulink Block Category
title: Heat exchangers
description: Devices that transfer thermal energy between fluid streams or between a fluid and a thermal boundary
tags: [heat exchanger, condenser, evaporator, cooling, NTU]
status: stable
source: mathworks_toolbox
library_root: Simscape Fluids
category_path: Heat exchangers
block_count: 32
---

# Heat exchangers

Use these blocks for heat exchangers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| E-NTU Heat Transfer | SimscapeFluids_lib/Heat Exchangers/Fundamental Components/E-NTU Heat Transfer | R2023a+ | Use to compute heat transfer between two fluid streams using the effectiveness-NTU method for any heat exchanger geometry |
| Heat Exchanger Interface (G) | SimscapeFluids_lib/Heat Exchangers/Fundamental Components/Heat Exchanger Interface (G) | R2023a+ | Use as a building block to connect a gas stream to a custom heat exchanger model with E-NTU or specific dissipation |
| Heat Exchanger Interface (TL) | SimscapeFluids_lib/Heat Exchangers/Fundamental Components/Heat Exchanger Interface (TL) | R2023a+ | Use as a building block to connect a thermal liquid stream to a custom heat exchanger model |
| Specific Dissipation Heat Exchanger Interface (G) | SimscapeFluids_lib/Heat Exchangers/Fundamental Components/Specific Dissipation Heat Exchanger Interface (G) | R2023a+ | Use as a building block for gas-side heat exchange with a known specific dissipation characteristic |
| Specific Dissipation Heat Exchanger Interface (TL) | SimscapeFluids_lib/Heat Exchangers/Fundamental Components/Specific Dissipation Heat Exchanger Interface (TL) | R2023a+ | Use as a building block for thermal-liquid-side heat exchange with a known specific dissipation characteristic |
| Specific Dissipation Heat Transfer | SimscapeFluids_lib/Heat Exchangers/Fundamental Components/Specific Dissipation Heat Transfer | R2023a+ | Use to model heat transfer with a parameterized specific dissipation rate for simplified exchanger characterization |
| Heat Exchanger (G) | SimscapeFluids_lib/Heat Exchangers/Gas/Heat Exchanger (G) | R2023a+ | Use to model a gas-to-wall heat exchanger for single-stream gas cooling or heating against a thermal boundary |
| Heat Exchanger (G-G) | SimscapeFluids_lib/Heat Exchangers/Gas/Heat Exchanger (G-G) | R2023a+ | Use to model heat transfer between two gas streams in a counterflow, crossflow, or parallel-flow arrangement |
| Specific Dissipation Heat Exchanger (G) | SimscapeFluids_lib/Heat Exchangers/Gas/Specific Dissipation Heat Exchanger (G) | R2023a+ | Use to model gas-to-wall heat exchange parameterized by a specific dissipation curve for simplified analysis |
| Specific Dissipation Heat Exchanger (G-G) | SimscapeFluids_lib/Heat Exchangers/Gas/Specific Dissipation Heat Exchanger (G-G) | R2023a+ | Use to model gas-to-gas heat exchange with specific dissipation parameterization for rapid system-level studies |
| System-Level Heat Exchanger (G-G) | SimscapeFluids_lib/Heat Exchangers/Gas/System-Level Heat Exchanger (G-G) | R2023a+ | Use to model gas-to-gas heat exchange at the system level with lumped effectiveness for fast simulation |
| System-Level Heat Exchanger (MA-MA) | SimscapeFluids_lib/Heat Exchangers/Moist Air/System-Level Heat Exchanger (MA-MA) | R2023a+ | Use to model moist-air-to-moist-air heat exchange at the system level for HVAC energy recovery modeling |
| Heat Exchanger (TL-TL) | SimscapeFluids_lib/Heat Exchangers/Thermal Liquid/Heat Exchanger (TL-TL) | R2023a+ | Use to model heat transfer between two thermal liquid streams such as oil-to-coolant or water-to-glycol loops |
| Heat Exchanger (TL) | SimscapeFluids_lib/Heat Exchangers/Thermal Liquid/Heat Exchanger (TL) | R2023a+ | Use to model thermal liquid heat exchange against a wall or thermal boundary for single-stream heating or cooling |
| Plate Heat Exchanger (TL-TL) | SimscapeFluids_lib/Heat Exchangers/Thermal Liquid/Plate Heat Exchanger (TL-TL) | R2023a+ | Use to model a plate-type heat exchanger between two thermal liquid streams with corrugated plate geometry |
| Specific Dissipation Heat Exchanger (TL-TL) | SimscapeFluids_lib/Heat Exchangers/Thermal Liquid/Specific Dissipation Heat Exchanger (TL-TL) | R2023a+ | Use to model thermal-liquid-to-thermal-liquid heat exchange with specific dissipation parameterization |
| Specific Dissipation Heat Exchanger (TL) | SimscapeFluids_lib/Heat Exchangers/Thermal Liquid/Specific Dissipation Heat Exchanger (TL) | R2023a+ | Use to model thermal liquid heat exchange against a boundary using specific dissipation data |
| System-Level Heat Exchanger (TL-TL) | SimscapeFluids_lib/Heat Exchangers/Thermal Liquid/System-Level Heat Exchanger (TL-TL) | R2023a+ | Use to model thermal-liquid-to-thermal-liquid heat exchange at system level with lumped effectiveness |
| Heat Exchanger (G-TL) | SimscapeFluids_lib/Heat Exchangers/Thermal Liquid - Gas/Heat Exchanger (G-TL) | R2023a+ | Use to model heat transfer between a gas stream and a thermal liquid stream such as a charge air cooler |
| Specific Dissipation Heat Exchanger (G-TL) | SimscapeFluids_lib/Heat Exchangers/Thermal Liquid - Gas/Specific Dissipation Heat Exchanger (G-TL) | R2023a+ | Use to model gas-to-thermal-liquid heat exchange with specific dissipation parameterization |
| System-Level Heat Exchanger (TL-G) | SimscapeFluids_lib/Heat Exchangers/Thermal Liquid - Gas/System-Level Heat Exchanger (TL-G) | R2023a+ | Use to model thermal-liquid-to-gas heat exchange at the system level such as a vehicle radiator |
| Cooling Tower (TL-MA) | SimscapeFluids_lib/Heat Exchangers/Thermal Liquid - Moist Air/Cooling Tower (TL-MA) | R2023a+ | Use to model an evaporative cooling tower that rejects heat from thermal liquid to moist air via evaporation |
| Heat Exchanger (TL-MA) | SimscapeFluids_lib/Heat Exchangers/Thermal Liquid - Moist Air/Heat Exchanger (TL-MA) | R2023a+ | Use to model heat transfer between a thermal liquid loop and moist air such as a fan coil unit |
| System-Level Heat Exchanger (TL-MA) | SimscapeFluids_lib/Heat Exchangers/Thermal Liquid - Moist Air/System-Level Heat Exchanger (TL-MA) | R2023a+ | Use to model thermal-liquid-to-moist-air heat exchange at the system level for building HVAC models |
| System-Level Heat Exchanger (2P-2P) | SimscapeFluids_lib/Heat Exchangers/Two-Phase Fluid/System-Level Heat Exchanger (2P-2P) | R2023a+ | Use to model two-phase-to-two-phase heat exchange at the system level for cascade refrigeration cycles |
| Condenser Evaporator (2P-G) | SimscapeFluids_lib/Heat Exchangers/Two-Phase Fluid - Gas/Condenser Evaporator (2P-G) | R2023a+ | Use to model a condenser or evaporator exchanging heat between a two-phase refrigerant and a gas stream |
| System-Level Condenser Evaporator (2P-G) | SimscapeFluids_lib/Heat Exchangers/Two-Phase Fluid - Gas/System-Level Condenser Evaporator (2P-G) | R2023a+ | Use to model a system-level condenser or evaporator between two-phase fluid and gas for rapid cycle analysis |
| Condenser Evaporator (2P-MA) | SimscapeFluids_lib/Heat Exchangers/Two-Phase Fluid - Moist Air/Condenser Evaporator (2P-MA) | R2023a+ | Use to model a condenser or evaporator exchanging heat between a two-phase refrigerant and moist air |
| System-Level Condenser Evaporator (2P-MA) | SimscapeFluids_lib/Heat Exchangers/Two-Phase Fluid - Moist Air/System-Level Condenser Evaporator (2P-MA) | R2023a+ | Use to model a system-level condenser or evaporator between two-phase fluid and moist air for HVAC systems |
| Condenser Evaporator (TL-2P) | SimscapeFluids_lib/Heat Exchangers/Two-Phase Fluid - Thermal Liquid/Condenser Evaporator (TL-2P) | R2023a+ | Use to model a condenser or evaporator exchanging heat between thermal liquid and a two-phase refrigerant |
| Plate Condenser Evaporator (TL-2P) | SimscapeFluids_lib/Heat Exchangers/Two-Phase Fluid - Thermal Liquid/Plate Condenser Evaporator (TL-2P) | R2023a+ | Use to model a plate-type condenser or evaporator between thermal liquid and two-phase refrigerant |
| System-Level Condenser Evaporator (2P-TL) | SimscapeFluids_lib/Heat Exchangers/Two-Phase Fluid - Thermal Liquid/System-Level Condenser Evaporator (2P-TL) | R2023a+ | Use to model a system-level condenser or evaporator between two-phase fluid and thermal liquid |
