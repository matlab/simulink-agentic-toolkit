---
type: Simulink Block Category
title: Controllers
description: Regulators and protective derating
tags: [controllers, pi controller, derating]
status: stable
source: custom_library
library_root: Motor Control Blockset HDL Support
category_path: Controllers
block_count: 2
---

# Controllers

Use these blocks for controllers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Derating Function | mcbhdllib/Controls/Controllers/Derating Function | R2023a+ | Reduce a torque or current reference based on temperature/voltage limits — use to protect the drive under stress. |
| PI Controller | mcbhdllib/Controls/Controllers/PI Controller | R2023a+ | Discrete PI controller with anti-windup — use for current, speed, or voltage regulation loops in motor control. |
