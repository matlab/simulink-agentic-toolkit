---
type: Simulink Block Category
title: Isothermal liquid
description: Isothermal liquid thermal-fluid elements (constant-temperature liquid)
tags: [isothermal liquid]
status: stable
source: custom_library
library_root: Simscape
category_path: Isothermal liquid
block_count: 12
---

# Isothermal liquid

Use these blocks for isothermal liquid.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Cap (IL) | fl_lib/Isothermal Liquid/Elements/Cap (IL) | R2025a+ | This block represents a terminus in an isothermal liquid network. There is no mass flow through the cap. This block can optionally be used to assign a beginning value and priority to the pressure of the connected node. |
| Constant Volume Chamber (IL) | fl_lib/Isothermal Liquid/Elements/Constant Volume Chamber (IL) | R2023a+ | This block models mass storage in an isothermal liquid network. The chamber contains a constant volume of liquid. Pressure varies dynamically based on the net mass accumulation in the volume. |
| Flow Resistance (IL) | fl_lib/Isothermal Liquid/Elements/Flow Resistance (IL) | R2023a+ | This block represents a generic pressure loss in an isothermal liquid network. The drop in pressure is proportional to the square of the mass flow rate. The proportionality constant is calculated from the specified nominal condition. |
| Infinite Flow Resistance (IL) | fl_lib/Isothermal Liquid/Elements/Infinite Flow Resistance (IL) | R2023a+ | This block represents a break in an isothermal liquid network. There is no mass flow through the break. However, the liquid properties, specified by the Isothermal Liquid Properties (IL) block connected to the circuit, are the same on both sides of the break. This block can optionally be used to assign a beginning value and priority to the difference in pressure of port A relative to port B. |
| Laminar Leakage (IL) | fl_lib/Isothermal Liquid/Elements/Laminar Leakage (IL) | R2023a+ | This block models the laminar flow in an isothermal liquid network. The flow rate is calculated from the Hagen-Poiseuille equation. |
| Local Restriction (IL) | fl_lib/Isothermal Liquid/Elements/Local Restriction (IL) | R2023a+ | This block models the pressure loss due to a flow area restriction such as a valve or an orifice in an isothermal liquid network. The restriction area can be optionally set by the physical signal input port AR. The input is limited by the minimum and maximum restriction area. |
| Pipe (IL) | fl_lib/Isothermal Liquid/Elements/Pipe (IL) | R2023a+ | This block models pipe flow dynamics in an isothermal liquid network due to viscous friction losses. You can optionally include the effects of dynamic compressibility and fluid inertia. The pipe contains a constant volume of liquid. Selecting Enable dynamic compressibility causes pressure to vary dynamically based on the net mass accumulation in the volume. Selecting Enable fluid inertia causes the liquid to resist acceleration. |
| Reservoir (IL) | fl_lib/Isothermal Liquid/Elements/Reservoir (IL) | R2023a+ | This block sets a boundary condition in an isothermal liquid network. The volume of liquid inside the reservoir is assumed infinite. Therefore, the flow is assumed quasi-steady. Liquid leaves and enters the reservoir at the reservoir pressure. The reservoir pressure can be optionally set by the physical signal port P. |
| Flow Rate Sensor (IL) | fl_lib/Isothermal Liquid/Sensors/Flow Rate Sensor (IL) | R2023a+ | This block measures mass or volumetric flow rate in an isothermal liquid network. There is no change in pressure across the sensor. The physical signal ports M and V report the mass flow rate and the volumetric flow rate, respectively, through the sensor. The positive flow direction is from port A to port B. |
| Liquid Properties Sensor (IL) | fl_lib/Isothermal Liquid/Sensors/Liquid Properties Sensor (IL) | R2023a+ | This block measures fluid properties in an isothermal liquid network. There is no mass flow through the sensor. The physical signal ports ρ, β, θ, μ, and ν report the mixture density, isothermal bulk modulus, molar fraction of air that is entrained (nondissolved), dynamic viscosity, and kinematic viscosity, respectively, measured at port A. |
| Pressure Sensor (IL) | fl_lib/Isothermal Liquid/Sensors/Pressure Sensor (IL) | R2023a+ | This block measures pressure in an isothermal liquid network. There is no mass flow through the sensor. The physical signal ports P, Pa and Pg report the pressure difference across the sensor, the absolute pressure at port A, and the gauge pressure at port A, respectively. The pressure difference measurement is positive when the pressure at port A is greater than the pressure at port B. |
| Isothermal Liquid Properties (IL) | fl_lib/Isothermal Liquid/Utilities/Isothermal Liquid Properties (IL) | R2023a+ | This block provides isothermal liquid properties to the connected isothermal liquid network. The default liquid is water. Use the <b>Isothermal liquid properties</b> button in the <b>Plots</b> section to visualize isothermal liquid properties as a function of pressure for the connected isothermal liquid network. |
