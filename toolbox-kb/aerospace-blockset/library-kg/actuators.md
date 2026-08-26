---
type: Simulink Block Category
title: Actuators
description: Flight control actuators and servo dynamics
tags: [actuator, servo, deflection, rate limit, control surface]
status: stable
source: mathworks_toolbox
library_root: Aerospace Blockset
category_path: Actuators
block_count: 2
---

# Actuators

Use these blocks for actuators.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Linear Second-Order Actuator | aerolibactuator/Linear Second-Order Actuator | R2023a+ | Model linear actuator dynamics as a second-order transfer function — use for control surface deflection response with natural frequency and damping |
| Nonlinear Second-Order Actuator | aerolibactuator/Nonlinear Second-Order Actuator | R2023a+ | Model actuator dynamics with rate and position limits — use when control surface deflection has saturation or rate-limiting behavior |
