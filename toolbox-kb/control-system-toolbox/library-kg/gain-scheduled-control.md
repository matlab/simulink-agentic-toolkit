---
type: Simulink Block Category
title: Gain scheduled control
description: PID controllers with runtime-adjustable gains for gain scheduling and adaptive tuning.
tags: [pid, gain-scheduling, controller, 2dof, tuning]
status: stable
source: custom_library
library_root: Control System Toolbox
category_path: Gain scheduled control
block_count: 4
---

# Gain scheduled control

Use these blocks for gain scheduled control.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Discrete Varying 2DOF PID | cstblocks/Linear Parameter Varying/Discrete Varying 2DOF PID | R2023a+ | Two-degree-of-freedom PID with runtime gain inputs at a discrete rate. Use for gain-scheduled control needing separate reference and feedback weighting on an embedded fixed-step platform. |
| Discrete Varying PID | cstblocks/Linear Parameter Varying/Discrete Varying PID | R2023a+ | PID controller with gains fed in as signals, running at a discrete sample rate. Use for gain scheduling or adaptive PID tuning in fixed-step embedded designs. |
| Varying 2DOF PID | cstblocks/Linear Parameter Varying/Varying 2DOF PID | R2023a+ | Continuous two-degree-of-freedom PID with time-varying gain inputs. Use for gain-scheduled control that weights setpoint tracking and disturbance rejection independently. |
| Varying PID Controller | cstblocks/Linear Parameter Varying/Varying PID Controller | R2023a+ | Continuous PID whose P, I, and D gains are supplied as signals. Use for gain-scheduled or online-tuned single-loop control in continuous-time simulation. |
