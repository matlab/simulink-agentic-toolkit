---
type: Simulink Block Category
title: Actuators
description: Motor and output blocks
tags: [motor, servo, smart, digital output]
status: stable
source: mathworks_toolbox
library_root: Simulink Coder Support Package for VEX EDR V5 Robot Brain
category_path: Actuators
block_count: 4
---

# Actuators

Use these blocks for actuators.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| DC Motor | vexv5lib/Actuators/DC Motor | R2023a+ | Drive a V5 DC motor — use for commanding legacy motor ports on V5 Robot Brain |
| Digital Output | vexv5lib/Actuators/Digital Output | R2023a+ | Set V5 digital pin — use for controlling LEDs or pneumatics on V5 3-wire ports |
| Servo Motor | vexv5lib/Actuators/Servo Motor | R2023a+ | Command V5 servo position — use for controlling angular position of servo motors on V5 |
| Smart Motor Write | vexv5lib/Actuators/Smart Motor Write | R2023a+ | Command V5 Smart Motor — use for setting velocity, position, or torque targets on V5 Smart Motors |
