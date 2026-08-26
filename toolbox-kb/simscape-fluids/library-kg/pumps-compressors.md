---
type: Simulink Block Category
title: Pumps compressors
description: Pumps, motors, compressors, fans, turbines, and ejectors that add or extract energy from a fluid stream
tags: [pump, compressor, turbine, fan, motor]
status: stable
source: mathworks_toolbox
library_root: Simscape Fluids
category_path: Pumps compressors
block_count: 31
---

# Pumps compressors

Use these blocks for pumps compressors.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Compressor (G) | SimscapeFluids_lib/Gas/Turbomachinery/Compressor (G) | R2023a+ | Use to model a gas compressor with performance maps for pressure ratio and efficiency as functions of speed and flow |
| Ejector (G) | SimscapeFluids_lib/Gas/Turbomachinery/Ejector (G) | R2023a+ | Use to model a gas ejector that uses a high-pressure motive stream to entrain and compress a low-pressure suction stream |
| Fan (G) | SimscapeFluids_lib/Gas/Turbomachinery/Fan (G) | R2023a+ | Use to model a fan that moves gas at low pressure ratios, typically for ventilation or cooling airflow |
| Positive-Displacement Compressor (G) | SimscapeFluids_lib/Gas/Turbomachinery/Positive-Displacement Compressor (G) | R2023a+ | Use to model a volumetric gas compressor with fixed displacement per revolution for pneumatic supply systems |
| Turbine (G) | SimscapeFluids_lib/Gas/Turbomachinery/Turbine (G) | R2023a+ | Use to model a gas turbine that extracts mechanical power from expanding gas flow using performance characteristics |
| Centrifugal Pump (IL) | SimscapeFluids_lib/Isothermal Liquid/Pumps & Motors/Centrifugal Pump (IL) | R2023a+ | Use to model a centrifugal pump providing pressure rise in an isothermal liquid system based on head-flow curves |
| Fixed-Displacement Motor (IL) | SimscapeFluids_lib/Isothermal Liquid/Pumps & Motors/Fixed-Displacement Motor (IL) | R2023a+ | Use to model a hydraulic motor with fixed displacement converting fluid power to shaft torque and speed |
| Fixed-Displacement Pump (IL) | SimscapeFluids_lib/Isothermal Liquid/Pumps & Motors/Fixed-Displacement Pump (IL) | R2023a+ | Use to model a positive-displacement hydraulic pump with fixed volumetric output per revolution |
| Jet Pump (IL) | SimscapeFluids_lib/Isothermal Liquid/Pumps & Motors/Jet Pump (IL) | R2023a+ | Use to model a jet pump that uses a high-velocity isothermal liquid jet to entrain and boost a secondary stream |
| Pressure-Compensated Pump (IL) | SimscapeFluids_lib/Isothermal Liquid/Pumps & Motors/Pressure-Compensated Pump (IL) | R2023a+ | Use to model a pump that automatically adjusts displacement to maintain a target outlet pressure |
| Variable-Displacement Motor (IL) | SimscapeFluids_lib/Isothermal Liquid/Pumps & Motors/Variable-Displacement Motor (IL) | R2023a+ | Use to model a hydraulic motor with adjustable displacement for variable-speed drive applications |
| Variable-Displacement Pump (IL) | SimscapeFluids_lib/Isothermal Liquid/Pumps & Motors/Variable-Displacement Pump (IL) | R2023a+ | Use to model a hydraulic pump with adjustable displacement for load-sensing or power-limiting control |
| Swash Plate | SimscapeFluids_lib/Isothermal Liquid/Pumps & Motors/Auxiliary Components/Swash Plate | R2023a+ | Use to model the swash plate mechanism that converts displacement command to pump or motor stroke angle |
| Valve Plate Orifice (IL) | SimscapeFluids_lib/Isothermal Liquid/Pumps & Motors/Auxiliary Components/Valve Plate Orifice (IL) | R2023a+ | Use to model the port timing orifice in a piston pump valve plate for detailed pump dynamics |
| Compressor (MA) | SimscapeFluids_lib/Moist Air/Turbomachinery/Compressor (MA) | R2024a+ | Use to model a moist air compressor with performance maps accounting for humidity effects on compression |
| Ejector (MA) | SimscapeFluids_lib/Moist Air/Turbomachinery/Ejector (MA) | R2023a+ | Use to model a moist air ejector that entrains low-pressure air using a high-pressure motive stream |
| Fan (MA) | SimscapeFluids_lib/Moist Air/Turbomachinery/Fan (MA) | R2023a+ | Use to model a fan moving moist air at low pressure rise for HVAC ventilation or process air handling |
| Positive-Displacement Compressor (MA) | SimscapeFluids_lib/Moist Air/Turbomachinery/Positive-Displacement Compressor (MA) | R2023a+ | Use to model a volumetric compressor handling moist air with fixed displacement per revolution |
| Turbine (MA) | SimscapeFluids_lib/Moist Air/Turbomachinery/Turbine (MA) | R2025a+ | Use to model a moist air turbine extracting mechanical power from expanding humid air flow |
| Centrifugal Pump (TL) | SimscapeFluids_lib/Thermal Liquid/Pumps & Motors/Centrifugal Pump (TL) | R2023a+ | Use to model a centrifugal pump in a thermal liquid system with head-flow curves and heat generation |
| Fixed-Displacement Motor (TL) | SimscapeFluids_lib/Thermal Liquid/Pumps & Motors/Fixed-Displacement Motor (TL) | R2023a+ | Use to model a hydraulic motor with fixed displacement in a thermal liquid system tracking viscous losses and heat |
| Fixed-Displacement Pump (TL) | SimscapeFluids_lib/Thermal Liquid/Pumps & Motors/Fixed-Displacement Pump (TL) | R2023a+ | Use to model a positive-displacement pump with fixed output in a thermal liquid system including thermal losses |
| Jet Pump (TL) | SimscapeFluids_lib/Thermal Liquid/Pumps & Motors/Jet Pump (TL) | R2025a+ | Use to model a jet pump in a thermal liquid system using a high-velocity jet to entrain a secondary stream |
| Variable-Displacement Motor (TL) | SimscapeFluids_lib/Thermal Liquid/Pumps & Motors/Variable-Displacement Motor (TL) | R2023a+ | Use to model a hydraulic motor with adjustable displacement in a thermal liquid network for variable-speed drives |
| Variable-Displacement Pump (TL) | SimscapeFluids_lib/Thermal Liquid/Pumps & Motors/Variable-Displacement Pump (TL) | R2023a+ | Use to model a hydraulic pump with adjustable displacement in a thermal liquid system for load-sensing control |
| Centrifugal Pump (2P) | SimscapeFluids_lib/Two-Phase Fluid/Fluid Machines/Centrifugal Pump (2P) | R2023a+ | Use to model a centrifugal pump handling two-phase fluid for refrigerant or process liquid circulation |
| Compressor (2P) | SimscapeFluids_lib/Two-Phase Fluid/Fluid Machines/Compressor (2P) | R2023a+ | Use to model a two-phase fluid compressor with performance maps for vapor compression cycle analysis |
| Fixed-Displacement Pump (2P) | SimscapeFluids_lib/Two-Phase Fluid/Fluid Machines/Fixed-Displacement Pump (2P) | R2023a+ | Use to model a positive-displacement pump for two-phase fluid circulation with fixed volumetric output |
| Positive-Displacement Compressor (2P) | SimscapeFluids_lib/Two-Phase Fluid/Fluid Machines/Positive-Displacement Compressor (2P) | R2023a+ | Use to model a volumetric compressor for two-phase refrigerant with fixed displacement per revolution |
| Turbine (2P) | SimscapeFluids_lib/Two-Phase Fluid/Fluid Machines/Turbine (2P) | R2023a+ | Use to model a turbine expanding two-phase fluid to extract mechanical work in organic Rankine or power cycles |
| Variable-Displacement Pump (2P) | SimscapeFluids_lib/Two-Phase Fluid/Fluid Machines/Variable-Displacement Pump (2P) | R2023a+ | Use to model a two-phase fluid pump with adjustable displacement for variable flow refrigerant circuits |
