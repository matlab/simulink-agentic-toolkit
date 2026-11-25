---
type: Simulink Block Category
title: Controllers
description: Regulators and protective derating (2 blocks)
tags: [toolbox-kb, motor-control-blockset-hdl-support, controllers, pi controller, derating]
status: stable
sources:
  - resource: matlab:mcbhdllib
source: toolbox_kb
managed_by: satk
library: Motor Control Blockset HDL Support
kb_folder: motor-control-blockset-hdl-support
category: controllers
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:35Z" }
---

# Controllers

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Derating Function | mcbhdllib/Controls/Controllers/Derating Function | R2023a+ | Reduce a torque or current reference based on temperature/voltage limits — use to protect the drive under stress. |
| PI Controller | mcbhdllib/Controls/Controllers/PI Controller | R2023a+ | Discrete PI controller with anti-windup — use for current, speed, or voltage regulation loops in motor control. |
