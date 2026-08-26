---
type: Simulink Block Category
title: Valves
description: Directional, flow-control, and pressure-control valves that route, throttle, or regulate fluid flow
tags: [valve, directional, check, solenoid, throttle]
status: stable
source: mathworks_toolbox
library_root: Simscape Fluids
category_path: Valves
block_count: 65
---

# Valves

Use these blocks for valves.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| 2-Way Directional Valve (G) | SimscapeFluids_lib/Gas/Valves & Orifices/Directional Control Valves/2-Way Directional Valve (G) | R2023a+ | Use to control on-off gas flow in a single line with a two-way pneumatic valve |
| 3-Way Directional Valve (G) | SimscapeFluids_lib/Gas/Valves & Orifices/Directional Control Valves/3-Way Directional Valve (G) | R2023a+ | Use to route gas flow between three ports for supply, exhaust, or divert functions in pneumatic circuits |
| 4-Way 3-Position Directional Valve (G) | SimscapeFluids_lib/Gas/Valves & Orifices/Directional Control Valves/4-Way 3-Position Directional Valve (G) | R2023a+ | Use to control a double-acting pneumatic actuator with extend, retract, and neutral positions |
| Check Valve (G) | SimscapeFluids_lib/Gas/Valves & Orifices/Directional Control Valves/Check Valve (G) | R2023a+ | Use to allow gas flow in one direction only, preventing backflow in pneumatic circuits |
| Pilot-Operated Check Valve (G) | SimscapeFluids_lib/Gas/Valves & Orifices/Directional Control Valves/Pilot-Operated Check Valve (G) | R2023a+ | Use to block gas backflow unless a pilot pressure signal unlocks the valve for controlled reverse flow |
| Ball Valve (G) | SimscapeFluids_lib/Gas/Valves & Orifices/Flow Control Valves/Ball Valve (G) | R2023b+ | Use to model a quarter-turn ball valve for gas flow shutoff or throttling with characterized flow area |
| Gate Valve (G) | SimscapeFluids_lib/Gas/Valves & Orifices/Flow Control Valves/Gate Valve (G) | R2023a+ | Use to model a gate valve for full-bore gas shutoff with minimal flow resistance when open |
| Poppet Valve (G) | SimscapeFluids_lib/Gas/Valves & Orifices/Flow Control Valves/Poppet Valve (G) | R2023a+ | Use to model a poppet-style gas valve with conical or flat seat geometry for fast-acting flow control |
| Temperature Control Valve (G) | SimscapeFluids_lib/Gas/Valves & Orifices/Flow Control Valves/Temperature Control Valve (G) | R2023a+ | Use to regulate gas temperature by blending hot and cold streams through a thermostatic three-way valve |
| Pressure Reducing Valve (G) | SimscapeFluids_lib/Gas/Valves & Orifices/Pressure Control Valves/Pressure Reducing Valve (G) | R2023a+ | Use to maintain a constant downstream gas pressure regardless of upstream pressure variations |
| Pressure Relief Valve (G) | SimscapeFluids_lib/Gas/Valves & Orifices/Pressure Control Valves/Pressure Relief Valve (G) | R2023a+ | Use to protect a gas system from overpressure by venting flow when pressure exceeds a set threshold |
| 2-Way Directional Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Directional Control Valves/2-Way Directional Valve (IL) | R2023a+ | Use to control on-off hydraulic flow in a single line with a two-way directional valve |
| 3-Way Directional Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Directional Control Valves/3-Way Directional Valve (IL) | R2023a+ | Use to route isothermal liquid flow between three ports for supply, return, or bypass functions |
| 4-Way 2-Position Directional Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Directional Control Valves/4-Way 2-Position Directional Valve (IL) | R2023a+ | Use to control a hydraulic actuator with two discrete positions for extend and retract commands |
| 4-Way 3-Position Directional Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Directional Control Valves/4-Way 3-Position Directional Valve (IL) | R2023a+ | Use to control a double-acting hydraulic actuator with extend, retract, and center-neutral positions |
| Check Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Directional Control Valves/Check Valve (IL) | R2023a+ | Use to allow isothermal liquid flow in one direction only, preventing backflow in hydraulic circuits |
| M-Way N-Position Directional Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Directional Control Valves/M-Way N-Position Directional Valve (IL) | R2023a+ | Use to model a configurable multi-way multi-position directional valve for complex hydraulic routing schemes |
| Pilot-Operated Check Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Directional Control Valves/Pilot-Operated Check Valve (IL) | R2023a+ | Use to hold hydraulic load pressure with a check valve that can be unlocked by a pilot signal |
| Shuttle Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Directional Control Valves/Shuttle Valve (IL) | R2023a+ | Use to automatically select the higher of two hydraulic pressures and route it to the outlet port |
| Solenoid Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Directional Control Valves/Solenoid Valve (IL) | R2023a+ | Use to model an electrically actuated on-off hydraulic valve for automated directional control |
| Ball Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Flow Control Valves/Ball Valve (IL) | R2023a+ | Use to model a quarter-turn ball valve for isothermal liquid flow shutoff or modulated throttling |
| Cartridge Valve Insert (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Flow Control Valves/Cartridge Valve Insert (IL) | R2023a+ | Use to model a two-way cartridge valve insert for compact manifold-mounted hydraulic flow control |
| Gate Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Flow Control Valves/Gate Valve (IL) | R2023a+ | Use to model a gate valve for full-bore isothermal liquid shutoff with minimal restriction when fully open |
| Needle Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Flow Control Valves/Needle Valve (IL) | R2023a+ | Use to model a needle valve for precise fine-adjustment of isothermal liquid flow rate |
| Poppet Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Flow Control Valves/Poppet Valve (IL) | R2023a+ | Use to model a poppet-style valve in an isothermal liquid line for fast-acting flow regulation |
| Pressure-Compensated 3-Way Flow Control Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Flow Control Valves/Pressure-Compensated 3-Way Flow Control Valve (IL) | R2023a+ | Use to maintain constant flow to an actuator regardless of load pressure using a 3-way pressure-compensated valve |
| Pressure-Compensated Flow Control Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Flow Control Valves/Pressure-Compensated Flow Control Valve (IL) | R2023a+ | Use to maintain constant hydraulic flow rate to a load independent of pressure variations across the valve |
| Counterbalance Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Pressure Control Valves/Counterbalance Valve (IL) | R2023a+ | Use to prevent uncontrolled lowering of a hydraulic load by requiring pilot pressure before allowing return flow |
| Pressure Compensator Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Pressure Control Valves/Pressure Compensator Valve (IL) | R2023a+ | Use to maintain a constant pressure differential across a metering orifice for load-independent flow control |
| Pressure Relief Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Pressure Control Valves/Pressure Relief Valve (IL) | R2023a+ | Use to protect a hydraulic circuit from overpressure by diverting excess flow when pressure exceeds the set point |
| Pressure-Reducing 3-Way Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Pressure Control Valves/Pressure-Reducing 3-Way Valve (IL) | R2023a+ | Use to regulate downstream pressure below supply with a 3-way valve that can both supply and exhaust fluid |
| Pressure-Reducing Valve (IL) | SimscapeFluids_lib/Isothermal Liquid/Valves & Orifices/Pressure Control Valves/Pressure-Reducing Valve (IL) | R2023a+ | Use to maintain a reduced downstream hydraulic pressure regardless of higher upstream supply pressure |
| 2-Way Directional Valve (MA) | SimscapeFluids_lib/Moist Air/Valves & Orifices/Directional Control Valves/2-Way Directional Valve (MA) | R2023a+ | Use to control on-off moist air flow in a single duct path with a two-way valve |
| 3-Way Directional Valve (MA) | SimscapeFluids_lib/Moist Air/Valves & Orifices/Directional Control Valves/3-Way Directional Valve (MA) | R2023a+ | Use to route moist air between three ports for supply, exhaust, or divert functions |
| 4-Way 2-Position Directional Valve (MA) | SimscapeFluids_lib/Moist Air/Valves & Orifices/Directional Control Valves/4-Way 2-Position Directional Valve (MA) | R2023a+ | Use to control a moist air actuator with two discrete positions for bidirectional motion |
| 4-Way 3-Position Directional Valve (MA) | SimscapeFluids_lib/Moist Air/Valves & Orifices/Directional Control Valves/4-Way 3-Position Directional Valve (MA) | R2023a+ | Use to control a double-acting moist air actuator with extend, retract, and neutral positions |
| Check Valve (MA) | SimscapeFluids_lib/Moist Air/Valves & Orifices/Directional Control Valves/Check Valve (MA) | R2023a+ | Use to allow moist air flow in one direction only, preventing backflow in air distribution systems |
| Pilot-Operated Check Valve (MA) | SimscapeFluids_lib/Moist Air/Valves & Orifices/Directional Control Valves/Pilot-Operated Check Valve (MA) | R2023a+ | Use to block moist air backflow unless a pilot signal unlocks the valve for controlled reverse flow |
| Ball Valve (MA) | SimscapeFluids_lib/Moist Air/Valves & Orifices/Flow Control Valves/Ball Valve (MA) | R2025a+ | Use to model a quarter-turn ball valve for moist air shutoff or throttling applications |
| Gate Valve (MA) | SimscapeFluids_lib/Moist Air/Valves & Orifices/Flow Control Valves/Gate Valve (MA) | R2025a+ | Use to model a gate valve for full-bore moist air shutoff in duct networks |
| Poppet Valve (MA) | SimscapeFluids_lib/Moist Air/Valves & Orifices/Flow Control Valves/Poppet Valve (MA) | R2025a+ | Use to model a poppet-style valve for moist air flow control with fast actuation response |
| Temperature Control Valve (MA) | SimscapeFluids_lib/Moist Air/Valves & Orifices/Flow Control Valves/Temperature Control Valve (MA) | R2023a+ | Use to regulate moist air temperature by blending hot and cold air streams through a thermostatic valve |
| Pressure Compensator Valve (MA) | SimscapeFluids_lib/Moist Air/Valves & Orifices/Pressure Control Valves/Pressure Compensator Valve (MA) | R2023a+ | Use to maintain constant pressure differential in a moist air system for load-independent flow metering |
| Pressure Reducing Valve (MA) | SimscapeFluids_lib/Moist Air/Valves & Orifices/Pressure Control Valves/Pressure Reducing Valve (MA) | R2023a+ | Use to maintain reduced downstream pressure in a moist air system regardless of upstream supply pressure |
| Pressure Relief Valve (MA) | SimscapeFluids_lib/Moist Air/Valves & Orifices/Pressure Control Valves/Pressure Relief Valve (MA) | R2023a+ | Use to protect a moist air system from overpressure by venting flow above the set threshold |
| Flow Coefficient Parameterized Valve (TL) | SimscapeFluids_lib/Thermal Liquid/Valves & Orifices/Flow Coefficient Parameterized Valve (TL) | R2023a+ | Use to model a valve in a thermal liquid system parameterized by Cv or Kv flow coefficients from manufacturer data |
| 2-Way Directional Valve (TL) | SimscapeFluids_lib/Thermal Liquid/Valves & Orifices/Directional Control Valves/2-Way Directional Valve (TL) | R2023a+ | Use to control on-off thermal liquid flow with a two-way directional valve including thermal effects |
| 3-Way Directional Valve (TL) | SimscapeFluids_lib/Thermal Liquid/Valves & Orifices/Directional Control Valves/3-Way Directional Valve (TL) | R2023a+ | Use to route thermal liquid flow between three ports for supply, return, or bypass with temperature tracking |
| 4-Way 2-Position Directional Valve (TL) | SimscapeFluids_lib/Thermal Liquid/Valves & Orifices/Directional Control Valves/4-Way 2-Position Directional Valve (TL) | R2023a+ | Use to control a thermal liquid actuator with two discrete positions including fluid temperature effects |
| 4-Way 3-Position Directional Valve (TL) | SimscapeFluids_lib/Thermal Liquid/Valves & Orifices/Directional Control Valves/4-Way 3-Position Directional Valve (TL) | R2023a+ | Use to control a double-acting thermal liquid actuator with three positions and thermal effects |
| Check Valve (TL) | SimscapeFluids_lib/Thermal Liquid/Valves & Orifices/Directional Control Valves/Check Valve (TL) | R2023a+ | Use to allow thermal liquid flow in one direction only, preventing backflow with thermal property tracking |
| Pilot-Operated Check Valve (TL) | SimscapeFluids_lib/Thermal Liquid/Valves & Orifices/Directional Control Valves/Pilot-Operated Check Valve (TL) | R2023a+ | Use to hold thermal liquid load pressure with a pilot-unlockable check valve for load-holding applications |
| Gate Valve (TL) | SimscapeFluids_lib/Thermal Liquid/Valves & Orifices/Flow Control Valves/Gate Valve (TL) | R2023a+ | Use to model a gate valve for full-bore thermal liquid shutoff with minimal restriction when fully open |
| Poppet Valve (TL) | SimscapeFluids_lib/Thermal Liquid/Valves & Orifices/Flow Control Valves/Poppet Valve (TL) | R2023a+ | Use to model a poppet-style valve for thermal liquid flow control with fast-acting seat geometry |
| Temperature Control Valve (TL) | SimscapeFluids_lib/Thermal Liquid/Valves & Orifices/Flow Control Valves/Temperature Control Valve (TL) | R2023a+ | Use to regulate thermal liquid temperature by blending hot and cold streams through a thermostatic valve |
| Counterbalance Valve (TL) | SimscapeFluids_lib/Thermal Liquid/Valves & Orifices/Pressure Control Valves/Counterbalance Valve (TL) | R2023a+ | Use to prevent uncontrolled load lowering in a thermal liquid circuit by requiring pilot pressure for return flow |
| Pressure Compensator Valve (TL) | SimscapeFluids_lib/Thermal Liquid/Valves & Orifices/Pressure Control Valves/Pressure Compensator Valve (TL) | R2023a+ | Use to maintain constant pressure differential in a thermal liquid system for load-independent flow control |
| Pressure Reducing Valve (TL) | SimscapeFluids_lib/Thermal Liquid/Valves & Orifices/Pressure Control Valves/Pressure Reducing Valve (TL) | R2023a+ | Use to maintain a reduced downstream thermal liquid pressure regardless of upstream supply pressure |
| Pressure Relief Valve (TL) | SimscapeFluids_lib/Thermal Liquid/Valves & Orifices/Pressure Control Valves/Pressure Relief Valve (TL) | R2023a+ | Use to protect a thermal liquid circuit from overpressure by diverting flow above the set pressure limit |
| 4-Way 2-Position Directional Valve (2P) | SimscapeFluids_lib/Two-Phase Fluid/Valves & Orifices/Directional Control Valves/4-Way 2-Position Directional Valve (2P) | R2023a+ | Use to control a two-phase fluid actuator or switch refrigerant flow paths between two positions |
| 4-Way 3-Position Directional Valve (2P) | SimscapeFluids_lib/Two-Phase Fluid/Valves & Orifices/Directional Control Valves/4-Way 3-Position Directional Valve (2P) | R2023a+ | Use to control two-phase fluid flow paths with three valve positions for reversible heat pump operation |
| Check Valve (2P) | SimscapeFluids_lib/Two-Phase Fluid/Valves & Orifices/Directional Control Valves/Check Valve (2P) | R2023a+ | Use to allow two-phase fluid flow in one direction only, preventing refrigerant backflow in cycle circuits |
| Thermostatic Expansion Valve (2P) | SimscapeFluids_lib/Two-Phase Fluid/Valves & Orifices/Flow Control Valves/Thermostatic Expansion Valve (2P) | R2023a+ | Use to meter refrigerant flow into an evaporator while maintaining target superheat at the evaporator outlet |
| Pressure Relief Valve (2P) | SimscapeFluids_lib/Two-Phase Fluid/Valves & Orifices/Pressure Control Valves/Pressure Relief Valve (2P) | R2023a+ | Use to protect a two-phase fluid system from overpressure by venting refrigerant above the safety limit |
| Pressure-Reducing Valve (2P) | SimscapeFluids_lib/Two-Phase Fluid/Valves & Orifices/Pressure Control Valves/Pressure-Reducing Valve (2P) | R2023a+ | Use to reduce two-phase fluid pressure downstream for controlled expansion or pressure regulation |
