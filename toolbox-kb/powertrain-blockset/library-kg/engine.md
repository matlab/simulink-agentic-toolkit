---
type: Simulink Block Category
title: Engine
description: ICE engine models and controllers
tags: [engine, ci, si, mapped, compressor, turbine, flow]
status: stable
source: mathworks_toolbox
library_root: Powertrain Blockset
category_path: Engine
block_count: 15
---

# Engine

Use these blocks for engine.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Boost Drive Shaft | autolibboost/Boost Drive Shaft | R2023a+ | Model turbocharger drive shaft — use for connecting compressor and turbine with inertia and friction |
| Compressor | autolibboost/Compressor | R2023a+ | Model turbocharger compressor — use for simulating boost pressure generation from exhaust energy |
| Turbine | autolibboost/Turbine | R2023a+ | Model turbocharger turbine — use for simulating exhaust energy extraction to drive the compressor |
| CI Core Engine | autolibcoreeng/CI Core Engine | R2023a+ | Model compression-ignition engine core — use for detailed diesel engine combustion and torque simulation |
| SI Core Engine | autolibcoreeng/SI Core Engine | R2023a+ | Model spark-ignition engine core — use for detailed gasoline engine combustion and torque simulation |
| Mapped Core Engine | autolibcoreeng/Mapped Core Engine | R2023a+ | Model engine using mapped data — use for fast lookup-based engine torque and fuel simulation |
| Control Volume System | autolibfundflw/Control Volume System | R2023a+ | Model a gas control volume — use for simulating intake/exhaust manifold pressure and temperature dynamics |
| Flow Boundary | autolibfundflw/Flow Boundary | R2023a+ | Define a flow boundary condition — use for specifying ambient pressure and temperature at system boundaries |
| Flow Restriction | autolibfundflw/Flow Restriction | R2023a+ | Model a gas flow restriction — use for simulating throttle valves and orifices in intake/exhaust paths |
| Heat Exchanger | autolibfundflw/Heat Exchanger | R2023a+ | Model a heat exchanger — use for simulating intercooler or radiator thermal performance |
| CI Controller | autolibengctrlr/CI Controller | R2023a+ | Diesel engine controller — use for fuel injection timing and quantity control in CI engines |
| SI Controller | autolibengctrlr/SI Controller | R2023a+ | Gasoline engine controller — use for throttle, spark, and fuel control in SI engines |
| Mapped CI Engine | autolibenginesystems/Mapped CI Engine | R2023a+ | Complete mapped diesel engine system — use for fast simulation of diesel powertrain with controller |
| Mapped SI Engine | autolibenginesystems/Mapped SI Engine | R2023a+ | Complete mapped gasoline engine system — use for fast simulation of gasoline powertrain with controller |
| Simple Engine | autolibenginesystems/Simple Engine | R2023a+ | Simplified engine model — use for vehicle-level studies where detailed combustion is unnecessary |
