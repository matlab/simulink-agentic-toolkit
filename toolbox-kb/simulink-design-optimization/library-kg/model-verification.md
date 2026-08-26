---
type: Simulink Block Category
title: Model verification
description: Automated signal verification and bounds checking
tags: [check, verify, bounds, reference, step]
status: stable
source: mathworks_toolbox
library_root: Simulink Design Optimization
category_path: Model verification
block_count: 6
---

# Model verification

Use these blocks for model verification.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Check Against Reference | sdolib/Model Verification/Check Against Reference | R2023a+ | Verify that a signal tracks a reference within tolerance — use for automated pass/fail testing against golden reference data during optimization or verification |
| Check Custom Bounds | sdolib/Model Verification/Check Custom Bounds | R2023a+ | Verify that a signal stays within user-defined upper and lower bounds — use for automated envelope testing during parameter optimization or design verification |
| Check Step Response  Characteristics | sdolib/Model Verification/Check Step Response  Characteristics | R2023a+ | Verify step response meets rise time, settling time, and overshoot specs — use for automated performance validation of control system transient response |
| Check Against Reference | sdolib/Signal Constraints/Check Against Reference | R2023a+ | Verify that a signal tracks a reference within tolerance — use for automated pass/fail testing against golden reference data during optimization or verification |
| Check Custom Bounds | sdolib/Signal Constraints/Check Custom Bounds | R2023a+ | Verify that a signal stays within user-defined upper and lower bounds — use for automated envelope testing during parameter optimization or design verification |
| Check Step Response  Characteristics | sdolib/Signal Constraints/Check Step Response  Characteristics | R2023a+ | Verify step response meets rise time, settling time, and overshoot specs — use for automated performance validation of control system transient response |
