---
type: Simulink Block Category
title: Verification
description: Assertion and bounds-checking blocks for model verification during simulation
tags: [assertion, bounds, range-check, gradient, verification]
status: stable
source: mathworks_toolbox
library_root: HDL Coder
category_path: Verification
block_count: 4
---

# Verification

Use these blocks for verification.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Assertion | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function1/Assertion | R2023a+ | Use when you need to verify that a signal meets expected conditions during simulation |
| Assertion | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function2/Assertion | R2023a+ | Use when you need to verify that a signal meets expected conditions during simulation |
| Assertion | hdlsllib/Model Verification/Assertion | R2023a+ | Use when you need to verify that a signal meets expected conditions during simulation |
| Check Discrete Gradient | hdlsllib/Model Verification/Check Discrete Gradient | R2023a+ | | du / dt | < 1 |
