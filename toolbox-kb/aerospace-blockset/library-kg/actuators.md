---
type: Simulink Block Category
title: Actuators
description: Flight control actuators and servo dynamics (2 blocks)
tags: [toolbox-kb, aerospace-blockset, actuator, servo, deflection, rate limit, control surface]
status: stable
sources:
  - resource: matlab:aerolibactuator
source: toolbox_kb
managed_by: satk
library: Aerospace Blockset
kb_folder: aerospace-blockset
category: actuators
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:13Z" }
---

# Actuators

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Linear Second-Order Actuator | aerolibactuator/Linear Second-Order Actuator | R2023a+ | Model linear actuator dynamics as a second-order transfer function — use for control surface deflection response with natural frequency and damping |
| Nonlinear Second-Order Actuator | aerolibactuator/Nonlinear Second-Order Actuator | R2023a+ | Model actuator dynamics with rate and position limits — use when control surface deflection has saturation or rate-limiting behavior |
