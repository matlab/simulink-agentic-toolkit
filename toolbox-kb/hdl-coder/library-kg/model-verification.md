---
type: Simulink Block Category
title: Model verification
description: Runtime assertion and range-check blocks
tags: [check, assertion, verification, bound, range]
status: stable
source: custom_library
library_root: HDL Coder
category_path: Model verification
block_count: 11
---

# Model verification

Use these blocks for model verification.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Assertion | hdlsllib/Model Verification/Assertion | R2023a+ | Check that an input is non-zero (true) during simulation and error/warn otherwise — use to verify runtime assumptions. |
| Check Discrete Gradient | hdlsllib/Model Verification/Check Discrete Gradient | R2023a+ | Assert the sample-to-sample change stays below a limit — use to verify rate/slope bounds. |
| Check  Dynamic Gap | hdlsllib/Model Verification/Check  Dynamic Gap | R2023a+ | Assert the signal stays outside a runtime lower/upper gap band — use for runtime range verification. |
| Check  Dynamic Range | hdlsllib/Model Verification/Check  Dynamic Range | R2023a+ | Assert the signal stays within runtime lower/upper bounds — use for runtime range verification. |
| Check  Static Gap | hdlsllib/Model Verification/Check  Static Gap | R2023a+ | Assert the signal stays outside a fixed gap band — use for range verification against constants. |
| Check  Static Range | hdlsllib/Model Verification/Check  Static Range | R2023a+ | Assert the signal stays within fixed lower/upper bounds — use for range verification against constants. |
| Check Dynamic  Lower Bound | hdlsllib/Model Verification/Check Dynamic  Lower Bound | R2023a+ | Assert the signal stays above a runtime lower bound — use for runtime minimum checks. |
| Check Dynamic  Upper Bound | hdlsllib/Model Verification/Check Dynamic  Upper Bound | R2023a+ | Assert the signal stays below a runtime upper bound — use for runtime maximum checks. |
| Check Input  Resolution | hdlsllib/Model Verification/Check Input  Resolution | R2023a+ | Assert the input matches a specified resolution/quantization — use to verify signal granularity. |
| Check Static  Lower Bound | hdlsllib/Model Verification/Check Static  Lower Bound | R2023a+ | Assert the signal stays above a fixed lower bound — use for constant minimum checks. |
| Check Static  Upper Bound | hdlsllib/Model Verification/Check Static  Upper Bound | R2023a+ | Assert the signal stays below a fixed upper bound — use for constant maximum checks. |
