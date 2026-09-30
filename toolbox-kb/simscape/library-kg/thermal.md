---
type: Simulink Block Category
title: Thermal
description: Thermal-domain conduction, convection, and radiation elements
tags: [thermal]
status: stable
source: custom_library
library_root: Simscape
category_path: Thermal
block_count: 15
---

# Thermal

Use these blocks for thermal.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Conductive Heat Transfer | fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer | R2023a+ | This block models heat transfer in a thermal network by conduction through a layer of material. The rate of heat transfer is governed by Fourier's law and is proportional to the temperature difference, material thermal conductivity, area normal to the heat flow direction, and inversely proportional to the layer thickness. The thermal conductivity can be either variable or constant. If the thermal conductivity is variable, you can specify it either as a physical input signal at port K or as tabulated data versus temperature. If the thermal conductivity is specified using the physical signal, it remains at the Minimum thermal conductivity if the physical signal falls below this value. |
| Convective Heat Transfer | fl_lib/Thermal/Thermal Elements/Convective Heat Transfer | R2023a+ | This block models heat transfer in a thermal network by convection due to fluid motion. The rate of heat transfer is proportional to the temperature difference, heat transfer coefficient, and surface area in contact with the fluid. The heat transfer coefficient can be either constant or variable. When the heat transfer coefficient is variable, specify it using the physical input signal at port K. If the heat transfer coefficient is variable, it remains at the Minimum heat transfer coefficient if the physical signal falls below this value. |
| Infinite Thermal Resistance | fl_lib/Thermal/Thermal Elements/Infinite Thermal Resistance | R2023a+ | This block represents a break in a thermal network. There is no heat flow through the block regardless of the temperature difference. This block can also be used to set an initial value and priority for the temperature difference across port A and port B. |
| Perfect Insulator | fl_lib/Thermal/Thermal Elements/Perfect Insulator | R2023a+ | This block represents a terminus in a thermal network with no heat flow and no energy storage. Use this block as an insulation for thermal conserving ports to prevent heat exchange with the environment and to model an adiabatic process. This block can also be used to set an initial value and priority for the temperature at the connected port. |
| Radiative Heat Transfer | fl_lib/Thermal/Thermal Elements/Radiative Heat Transfer | R2023a+ | This block models heat transfer in a thermal network by radiation between two surfaces. The rate of heat transfer is governed by the Stefan-Boltzmann law and is proportional to the difference in the fourth power of temperature, radiation coefficient, and surface area. The radiation coefficient depends on the geometric configuration and surface emissivities of the interacting bodies. |
| Thermal Mass | fl_lib/Thermal/Thermal Elements/Thermal Mass | R2023a+ | This block models internal energy storage in a thermal network. The rate of temperature increase is proportional to the heat flow rate into the material and inversely proportional to the mass and specific heat of the material. The mass of the block can be constant or variable. If the mass is variable, specify the change in mass using the physical input signal at port Mdot. When using variable mass, you must also specify the temperature of incoming mass using the physical input signal at port Tin. The temperature at port Tin only affects the results if the mass is increasing. If the mass is constant or decreasing, the temperature at port Tin has no effect. |
| Thermal Reference | fl_lib/Thermal/Thermal Elements/Thermal Reference | R2023a+ | This block represents a reference point in a thermal network where the temperature is equal to absolute zero. |
| Thermal Resistance | fl_lib/Thermal/Thermal Elements/Thermal Resistance | R2023a+ | This block represents a generic resistance in a thermal network. The heat flow rate is proportional to the temperature difference and inversely proportional to the resistance. |
| Variable Thermal Resistance | fl_lib/Thermal/Thermal Elements/Variable Thermal Resistance | R2023a+ | This block represents a variable generic resistance in a thermal network. The heat flow rate is proportional to the temperature difference and inversely proportional to the resistance. The resistance is set by the physical signal port R. The resistance remains at the Minimum thermal resistance even if the physical signal falls below this value. |
| Heat Flow Rate Sensor | fl_lib/Thermal/Thermal Sensors/Heat Flow Rate Sensor | R2023a+ | This block measures heat flow rate in a thermal network. There is no change in temperature across the sensor. The physical signal port H reports the heat flow rate through the sensor. The positive flow direction is from port A to port B. |
| Temperature Sensor | fl_lib/Thermal/Thermal Sensors/Temperature Sensor | R2023a+ | This block measures temperature in a thermal network. There is no heat flow through the sensor. The physical signal port T reports the temperature difference across the sensor. The measurement is positive when the temperature at port A is greater than the temperature at port B. |
| Controlled Temperature Source | fl_lib/Thermal/Thermal Sources/Controlled Temperature Source | R2023a+ | This block represents an ideal energy source in a thermal network that can maintain a controlled temperature difference regardless of the heat flow rate. The temperature difference is set by the physical signal port S. A positive temperature difference causes the temperature at port B to be greater than the temperature at port A. |
| Controlled Heat Flow Rate Source | fl_lib/Thermal/Thermal Sources/Controlled Heat Flow Rate Source | R2023a+ | This block represents an ideal energy source in a thermal network that can maintain a controlled heat flow rate regardless of the temperature difference. The heat flow rate is set by the physical signal port S. A positive heat flow rate flows from port A to port B. |
| Heat Flow Rate Source | fl_lib/Thermal/Thermal Sources/Heat Flow Rate Source | R2023a+ | This block represents an ideal energy source in a thermal network that can maintain a constant heat flow rate regardless of the temperature difference. A positive heat flow rate flows from port A to port B. |
| Temperature Source | fl_lib/Thermal/Thermal Sources/Temperature Source | R2023a+ | This block represents an ideal energy source in a thermal network that can maintain a constant absolute temperature at the port regardless of the heat flow rate. |
