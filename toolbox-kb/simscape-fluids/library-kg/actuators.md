---
type: Simulink Block Category
title: Actuators
description: Linear and rotary fluid-power cylinders and their auxiliary components for converting pressure to mechanical force
tags: [cylinder, piston, actuator, force, stroke]
status: stable
source: mathworks_toolbox
library_root: Simscape Fluids
category_path: Actuators
block_count: 24
---

# Actuators

Use these blocks for actuators.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Air Muscle Actuator (G) | SimscapeFluids_lib/Gas/Actuators/Air Muscle Actuator (G) | R2023a+ | Use to model a pneumatic artificial muscle that contracts when pressurized, for soft robotics or compliant actuation |
| Double-Acting Actuator (G) | SimscapeFluids_lib/Gas/Actuators/Double-Acting Actuator (G) | R2023a+ | Use to model a pneumatic cylinder driven by gas pressure on both sides of the piston for bidirectional force generation |
| Single-Acting Actuator (G) | SimscapeFluids_lib/Gas/Actuators/Single-Acting Actuator (G) | R2023a+ | Use to model a pneumatic cylinder with gas pressure on one side and spring return for simple extend-retract motion |
| Double-Acting Actuator (G-IL) | SimscapeFluids_lib/Isothermal Liquid/Actuators/Double-Acting Actuator (G-IL) | R2023a+ | Use to model a hydraulic cylinder with gas on one side and isothermal liquid on the other for mixed-domain actuation |
| Double-Acting Actuator (IL) | SimscapeFluids_lib/Isothermal Liquid/Actuators/Double-Acting Actuator (IL) | R2023a+ | Use to model a double-acting hydraulic cylinder driven by isothermal liquid pressure on both piston sides |
| Double-Acting Actuator (IL-PB) | SimscapeFluids_lib/Isothermal Liquid/Actuators/Double-Acting Actuator (IL-PB) | R2023a+ | Use to model a double-acting hydraulic cylinder in a position-based isothermal liquid network |
| Double-Acting Rotary Actuator (IL) | SimscapeFluids_lib/Isothermal Liquid/Actuators/Double-Acting Rotary Actuator (IL) | R2023a+ | Use to model a hydraulic rotary actuator that converts fluid pressure to bidirectional shaft torque |
| Rotating Single-Acting Actuator (IL) | SimscapeFluids_lib/Isothermal Liquid/Actuators/Rotating Single-Acting Actuator (IL) | R2023a+ | Use to model a single-acting hydraulic actuator mounted on a rotating structure with centrifugal effects |
| Single-Acting Actuator (IL) | SimscapeFluids_lib/Isothermal Liquid/Actuators/Single-Acting Actuator (IL) | R2023a+ | Use to model a single-acting hydraulic cylinder with spring or gravity return in isothermal liquid systems |
| Single-Acting Actuator (IL-PB) | SimscapeFluids_lib/Isothermal Liquid/Actuators/Single-Acting Actuator (IL-PB) | R2023a+ | Use to model a single-acting hydraulic cylinder in a position-based isothermal liquid network |
| Single-Acting Rotary Actuator (IL) | SimscapeFluids_lib/Isothermal Liquid/Actuators/Single-Acting Rotary Actuator (IL) | R2023a+ | Use to model a single-acting hydraulic rotary actuator with spring return for limited angular motion |
| Cylinder Cushion (IL) | SimscapeFluids_lib/Isothermal Liquid/Actuators/Auxiliary Components/Cylinder Cushion (IL) | R2023a+ | Use to model end-of-stroke cushioning in a hydraulic cylinder that decelerates the piston before impact |
| Cylinder Cushion (IL-PB) | SimscapeFluids_lib/Isothermal Liquid/Actuators/Auxiliary Components/Cylinder Cushion (IL-PB) | R2023a+ | Use to model end-of-stroke cushioning in a position-based hydraulic cylinder network |
| Cylinder Friction (IL) | SimscapeFluids_lib/Isothermal Liquid/Actuators/Auxiliary Components/Cylinder Friction (IL) | R2023a+ | Use to model seal and piston friction in a hydraulic cylinder for accurate force and efficiency calculations |
| Cylinder Friction (IL-PB) | SimscapeFluids_lib/Isothermal Liquid/Actuators/Auxiliary Components/Cylinder Friction (IL-PB) | R2023a+ | Use to model seal friction in a position-based hydraulic cylinder for efficiency analysis |
| Rotating Channel (IL) | SimscapeFluids_lib/Isothermal Liquid/Actuators/Auxiliary Components/Rotating Channel (IL) | R2023a+ | Use to model a fluid passage in a rotating body where centrifugal effects influence the pressure distribution |
| Rotating Cylinder Force (IL) | SimscapeFluids_lib/Isothermal Liquid/Actuators/Auxiliary Components/Rotating Cylinder Force (IL) | R2023a+ | Use to model the centrifugal force on fluid in a rotating hydraulic cylinder for rotating machinery applications |
| Double-Acting Actuator (MA) | SimscapeFluids_lib/Moist Air/Actuators/Double-Acting Actuator (MA) | R2023a+ | Use to model a double-acting pneumatic cylinder operating in a moist air network with humidity tracking |
| Single-Acting Actuator (MA) | SimscapeFluids_lib/Moist Air/Actuators/Single-Acting Actuator (MA) | R2023a+ | Use to model a single-acting pneumatic cylinder in a moist air system with spring return |
| Double-Acting Actuator (TL) | SimscapeFluids_lib/Thermal Liquid/Actuators/Double-Acting Actuator (TL) | R2023a+ | Use to model a double-acting hydraulic cylinder in a thermal liquid network with temperature-dependent fluid properties |
| Double-Acting Actuator (TL-G) | SimscapeFluids_lib/Thermal Liquid/Actuators/Double-Acting Actuator (TL-G) | R2023a+ | Use to model a hydraulic cylinder with thermal liquid on one side and gas on the other for mixed-domain actuation with thermal effects |
| Single-Acting Actuator (TL) | SimscapeFluids_lib/Thermal Liquid/Actuators/Single-Acting Actuator (TL) | R2023a+ | Use to model a single-acting hydraulic cylinder in a thermal liquid system with temperature tracking |
| Cylinder Cushion (TL) | SimscapeFluids_lib/Thermal Liquid/Actuators/Auxiliary Components/Cylinder Cushion (TL) | R2023a+ | Use to model end-of-stroke cushioning in a thermal liquid hydraulic cylinder for deceleration control |
| Cylinder Friction (TL) | SimscapeFluids_lib/Thermal Liquid/Actuators/Auxiliary Components/Cylinder Friction (TL) | R2023a+ | Use to model seal and piston friction in a thermal liquid hydraulic cylinder including thermal dissipation |
