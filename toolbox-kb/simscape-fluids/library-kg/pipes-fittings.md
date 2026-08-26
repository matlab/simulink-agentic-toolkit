---
type: Simulink Block Category
title: Pipes fittings
description: Pipe segments, bends, junctions, and fittings that convey fluid between components
tags: [pipe, elbow, junction, fitting, duct]
status: stable
source: mathworks_toolbox
library_root: Simscape Fluids
category_path: Pipes fittings
block_count: 24
---

# Pipes fittings

Use these blocks for pipes fittings.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Elbow (G) | SimscapeFluids_lib/Gas/Pipes & Fittings/Elbow (G) | R2023a+ | Use to model pressure loss in a gas pipe elbow fitting where the flow changes direction at a sharp angle |
| Pipe Bend (G) | SimscapeFluids_lib/Gas/Pipes & Fittings/Pipe Bend (G) | R2023a+ | Use to model pressure loss in a smooth gas pipe bend with a defined radius of curvature |
| Area Change (IL) | SimscapeFluids_lib/Isothermal Liquid/Pipes & Fittings/Area Change (IL) | R2023a+ | Use to model a sudden or gradual cross-section change in an isothermal liquid pipe causing pressure loss |
| Cross-Junction (IL) | SimscapeFluids_lib/Isothermal Liquid/Pipes & Fittings/Cross-Junction (IL) | R2023a+ | Use to model a four-way pipe junction in an isothermal liquid network with mixing and splitting flow |
| Elbow (IL) | SimscapeFluids_lib/Isothermal Liquid/Pipes & Fittings/Elbow (IL) | R2023a+ | Use to model pressure loss at a pipe elbow in an isothermal liquid line |
| Partially Filled Pipe (IL) | SimscapeFluids_lib/Isothermal Liquid/Pipes & Fittings/Partially Filled Pipe (IL) | R2023a+ | Use to model an isothermal liquid pipe that may not be completely filled, accounting for gravity-driven flow |
| Pipe (IL) | SimscapeFluids_lib/Isothermal Liquid/Pipes & Fittings/Pipe (IL) | R2023a+ | Use to model a straight segment of isothermal liquid pipe with distributed friction and fluid inertia |
| Pipe Bend (IL) | SimscapeFluids_lib/Isothermal Liquid/Pipes & Fittings/Pipe Bend (IL) | R2023a+ | Use to model a smooth pipe bend in an isothermal liquid line with curvature-dependent pressure loss |
| T-Junction (IL) | SimscapeFluids_lib/Isothermal Liquid/Pipes & Fittings/T-Junction (IL) | R2023a+ | Use to model a three-way T-junction in an isothermal liquid pipe network for flow splitting or merging |
| Y-Junction (IL) | SimscapeFluids_lib/Isothermal Liquid/Pipes & Fittings/Y-Junction (IL) | R2023a+ | Use to model a Y-shaped pipe junction in an isothermal liquid network with angled branch connections |
| Cross-Junction (MA) | SimscapeFluids_lib/Moist Air/Pipes & Fittings/Cross-Junction (MA) | R2024b+ | Use to model a four-way duct junction in a moist air network for splitting or merging airflows |
| Elbow (MA) | SimscapeFluids_lib/Moist Air/Pipes & Fittings/Elbow (MA) | R2023a+ | Use to model pressure loss at a duct elbow in a moist air system where flow changes direction |
| Pipe Bend (MA) | SimscapeFluids_lib/Moist Air/Pipes & Fittings/Pipe Bend (MA) | R2023a+ | Use to model pressure loss in a smooth moist air duct bend with defined curvature radius |
| T-Junction (MA) | SimscapeFluids_lib/Moist Air/Pipes & Fittings/T-Junction (MA) | R2024b+ | Use to model a T-junction in a moist air duct network for airflow splitting or merging |
| Y-Junction (MA) | SimscapeFluids_lib/Moist Air/Pipes & Fittings/Y-Junction (MA) | R2024b+ | Use to model a Y-junction in a moist air duct network with angled branch connections |
| Area Change (TL) | SimscapeFluids_lib/Thermal Liquid/Pipes & Fittings/Area Change (TL) | R2026a+ | Use to model a cross-section change in a thermal liquid pipe causing pressure loss with thermal effects |
| Cross-Junction (TL) | SimscapeFluids_lib/Thermal Liquid/Pipes & Fittings/Cross-Junction (TL) | R2023a+ | Use to model a four-way pipe junction in a thermal liquid network with mixing and splitting |
| Elbow (TL) | SimscapeFluids_lib/Thermal Liquid/Pipes & Fittings/Elbow (TL) | R2023a+ | Use to model pressure loss at a pipe elbow in a thermal liquid line with heat exchange to surroundings |
| Partially Filled Pipe (TL) | SimscapeFluids_lib/Thermal Liquid/Pipes & Fittings/Partially Filled Pipe (TL) | R2023a+ | Use to model a thermal liquid pipe that may not be fully filled, for gravity-driven or open-channel scenarios |
| Pipe (TL) | SimscapeFluids_lib/Thermal Liquid/Pipes & Fittings/Pipe (TL) | R2023a+ | Use to model a straight thermal liquid pipe segment with friction, inertia, and wall heat transfer |
| Pipe Bend (TL) | SimscapeFluids_lib/Thermal Liquid/Pipes & Fittings/Pipe Bend (TL) | R2023a+ | Use to model a smooth pipe bend in a thermal liquid line with curvature and thermal loss effects |
| T-Junction (TL) | SimscapeFluids_lib/Thermal Liquid/Pipes & Fittings/T-Junction (TL) | R2023a+ | Use to model a T-junction in a thermal liquid pipe network for flow splitting or merging with mixing |
| Y-Junction (TL) | SimscapeFluids_lib/Thermal Liquid/Pipes & Fittings/Y-Junction (TL) | R2023a+ | Use to model a Y-junction in a thermal liquid pipe network with angled branches and thermal mixing |
| 3-Zone Pipe (2P) | SimscapeFluids_lib/Two-Phase Fluid/Pipes & Fittings/3-Zone Pipe (2P) | R2023a+ | Use to model a two-phase fluid pipe with subcooled, two-phase, and superheated zones for condenser and evaporator tubes |
