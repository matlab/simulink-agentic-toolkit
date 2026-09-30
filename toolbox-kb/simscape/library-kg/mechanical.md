---
type: Simulink Block Category
title: Mechanical
description: Mechanical-domain building blocks
tags: [mechanical]
status: stable
source: custom_library
library_root: Simscape
category_path: Mechanical
block_count: 12
---

# Mechanical

Use these blocks for mechanical.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Flow Rate Source (G) | fl_lib/Gas/Sources/Flow Rate Source (G) | R2023b+ | This block represents an ideal mechanical energy source in a gas network that can maintain a constant or controlled mass flow rate or volumetric flow rate regardless of the pressure differential. There is no flow resistance and no heat exchange with the environment. A positive value causes gas to flow from port A to port B. |
| Pressure Source (G) | fl_lib/Gas/Sources/Pressure Source (G) | R2023a+ | This block represents an ideal mechanical energy source in a gas network that can maintain a constant or controlled pressure differential regardless of the mass flow rate. There is no flow resistance and no heat exchange with the environment. The pressure differential can be optionally set by the physical signal port P. A positive pressure differential causes the pressure at port B to be greater than the pressure at port A. |
| Hydraulic Constant Mass Flow Rate Source | fl_lib/Hydraulic/Hydraulic Sources/Hydraulic Constant Mass Flow Rate Source | R2023a+ | This block represents an ideal mechanical energy source in a hydraulic network that can maintain a constant mass flow rate regardless of the pressure differential. The source does not generate any losses due to friction. A positive mass flow rate causes liquid to flow from port T to port P. |
| Hydraulic Mass Flow Rate Source | fl_lib/Hydraulic/Hydraulic Sources/Hydraulic Mass Flow Rate Source | R2023a+ | This block represents an ideal mechanical energy source in a hydraulic network that can maintain a controlled mass flow rate regardless of the pressure differential. The source does not generate any losses due to friction. The mass flow rate is set by the physical signal port M. A positive mass flow rate causes liquid to flow from port T to port P. |
| Flow Rate Source (IL) | fl_lib/Isothermal Liquid/Sources/Flow Rate Source (IL) | R2023a+ | This block represents an ideal mechanical energy source in an isothermal liquid network that can maintain a constant or controlled mass flow rate or volumetric flow rate regardless of the pressure differential. The source does not generate any losses due to friction. The mass or volume flow rate can be optionally set by physical signal port M or V, respectively. A positive value causes liquid to flow from port A to port B. |
| Pressure Source (IL) | fl_lib/Isothermal Liquid/Sources/Pressure Source (IL) | R2023a+ | This block represents an ideal mechanical energy source in an isothermal liquid network that can maintain a constant or controlled pressure differential regardless of the flow rate. The source does not generate any losses due to friction. The pressure differential can be optionally set by the physical signal port P. A positive value causes the pressure at port B to be greater than port A. |
| Flow Rate Source (MA) | fl_lib/Moist Air/Sources/Flow Rate Source (MA) | R2023a+ | This block represents an ideal mechanical energy source in a moist air network that can maintain a constant or controlled mass flow rate or volumetric flow rate regardless of the pressure differential. There is no flow resistance and no heat exchange with the environment. The mass or volumetric flow rate can be optionally set by physical signal port M [kg/s] or V [m^3/s], respectively. A positive flow rate causes moist air to flow from port A to port B. |
| Pressure Source (MA) | fl_lib/Moist Air/Sources/Pressure Source (MA) | R2023a+ | This block represents an ideal mechanical energy source in a moist air network that can maintain a constant or controlled pressure differential regardless of the mass flow rate. There is no flow resistance and no heat exchange with the environment. The pressure differential can be optionally set by physical signal port P [Pa]. A positive pressure differential causes the pressure at port B to be greater than port A. |
| Flow Rate Source (TL) | fl_lib/Thermal Liquid/Sources/Flow Rate Source (TL) | R2023a+ | This block represents an ideal mechanical energy source in a thermal liquid network that can maintain a constant or controlled mass flow rate or volumetric flow rate regardless of the pressure differential. There is no flow resistance and no heat exchange with the environment. A positive value causes liquid to flow from port A to port B. |
| Pressure Source (TL) | fl_lib/Thermal Liquid/Sources/Pressure Source (TL) | R2023a+ | This block represents an ideal mechanical energy source in a thermal liquid network that can maintain a constant or controlled pressure differential regardless of the mass flow rate. There is no flow resistance and no heat exchange with the environment. The pressure differential can be optionally set by the physical signal port P. A positive pressure differential causes the pressure at port B to be greater than port A. |
| Flow Rate Source (2P) | fl_lib/Two-Phase Fluid/Sources/Flow Rate Source (2P) | R2023a+ | This block represents an ideal mechanical energy source in a two-phase fluid network that can maintain a constant or controlled mass flow rate or volumetric flow rate regardless of the pressure differential. There is no flow resistance and no heat exchange with the environment. A positive value causes fluid to flow from port A to port B. |
| Pressure Source (2P) | fl_lib/Two-Phase Fluid/Sources/Pressure Source (2P) | R2023a+ | This block represents an ideal mechanical energy source in a two-phase fluid network that can maintain a constant or controlled pressure differential regardless of the mass flow rate. There is no flow resistance and no heat exchange with the environment. The pressure differential can be optionally set by the physical signal port P. A positive pressure differential causes the pressure at port B to be greater than port A. |
