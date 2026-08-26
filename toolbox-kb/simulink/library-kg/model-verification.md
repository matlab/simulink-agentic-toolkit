---
type: Simulink Block Category
title: Model verification
description: Runtime assertion and bounds checking blocks for verifying model behavior during simulation
tags: [assertion, bounds check, range, gradient, verification]
status: stable
source: mathworks_toolbox
library_root: Simulink
category_path: Model verification
block_count: 4
---

# Model verification

Use these blocks for model verification.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Check  Dynamic Range | simulink/Model Verification/Check  Dynamic Range | R2023a+ | min < u < max |
| Check  Static Range | simulink/Model Verification/Check  Static Range | R2023a+ | 0 <= u <= 100 |
| Check Discrete Gradient | simulink/Model Verification/Check Discrete Gradient | R2023a+ | | du / dt | < 1 |
| Assertion | simulink/Model Verification/Assertion | R2023a+ | Use when halting simulation or generating a warning if a Boolean condition evaluates to false |
