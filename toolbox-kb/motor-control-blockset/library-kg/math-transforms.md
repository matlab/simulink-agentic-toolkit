---
type: Simulink Block Category
title: Math transforms
description: Clarke/Park and multi-phase transforms, PWM math, and trig utilities used inside FOC and vector-control math paths
tags: [Clarke, Park, transform, PWM, sine, atan2, VSD]
status: stable
source: mathworks_toolbox
library_root: Motor Control Blockset
category_path: Math transforms
block_count: 12
---

# Math transforms

Use these blocks for math transforms.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| 3-Phase Sine Voltage Generator | mcblib/Controls/Math Transforms/3-Phase Sine Voltage Generator | R2023a+ | Generate a balanced three-phase sinusoidal voltage set from a magnitude and frequency command — use to drive AC motor models open-loop or synthesize test stimuli |
| 6-Phase Inverse VSD Transform | mcblib/Controls/Math Transforms/6-Phase Inverse VSD Transform | R2024b+ | Convert alpha/beta reference voltages back to six-phase (dual three-phase) output — use to drive six-phase inverters after control computations are done in the reduced frame |
| 6-Phase VSD Transform | mcblib/Controls/Math Transforms/6-Phase VSD Transform | R2024b+ | Apply the Vector Space Decomposition transform to convert six measured phase currents into two orthogonal subspaces — use for control of six-phase motors and to isolate harmonic content |
| Clarke Transform | mcblib/Controls/Math Transforms/Clarke Transform | R2023a+ | Convert three-phase stationary quantities (ia, ib, ic) into two-axis alpha/beta stationary components — use as the first math step of any FOC current or voltage transformation |
| Inverse Clarke Transform | mcblib/Controls/Math Transforms/Inverse Clarke Transform | R2023a+ | Convert alpha/beta stationary components back into three-phase voltage or current commands — use as the final math step before driving PWM in an FOC controller |
| Inverse Park Transform | mcblib/Controls/Math Transforms/Inverse Park Transform | R2023a+ | Rotate d/q axis quantities back to the stationary alpha/beta frame using the electrical angle — use to convert voltage commands from the rotor-oriented frame before PWM generation |
| PWM Phase Shift for Single Shunt FOC | mcblib/Controls/Math Transforms/PWM Phase Shift for Single Shunt FOC | R2026a+ | Offset PWM edges so that two distinct phase currents can be sampled on a single DC-bus shunt within one PWM period — use for cost-optimized drives with only one current sensor |
| PWM Reference Generator | mcblib/Controls/Math Transforms/PWM Reference Generator | R2023a+ | Generate space-vector or sine-triangle PWM duty cycles from three-phase voltage references — use to drive a three-phase inverter from an FOC or vector controller |
| Park Transform | mcblib/Controls/Math Transforms/Park Transform | R2023a+ | Rotate alpha/beta stationary quantities into the d/q rotor-oriented frame using the electrical angle — use to move currents and voltages into the rotating frame for FOC math |
| Phase Current Extractor for Single Shunt FOC | mcblib/Controls/Math Transforms/Phase Current Extractor for Single Shunt FOC | R2026a+ | Reconstruct two phase currents from single-shunt DC-bus samples using PWM state timing — use to enable FOC on drives with only one current sensor |
| SinCos Embedded Optimized | mcblib/Controls/Math Transforms/SinCos Embedded Optimized | R2024b+ | Compute sine and cosine of an electrical angle using a lookup-based implementation optimized for fixed-point/embedded targets — use inside Park/inverse-Park math on resource-constrained MCUs |
| atan2 | mcblib/Controls/Math Transforms/atan2 | R2023a+ | Compute the four-quadrant arctangent using an embedded-optimized implementation — use to recover electrical angles from alpha/beta components on fixed-point targets |
