---
type: Simulink Block Category
title: Hdl subsystems and control
description: Synchronous subsystems, state control, and nonlinear discontinuity blocks for HDL
tags: [subsystem, synchronous, saturation, reset, enable]
status: stable
source: mathworks_toolbox
library_root: HDL Coder
category_path: Hdl subsystems and control
block_count: 16
---

# Hdl subsystems and control

Use these blocks for hdl subsystems and control.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Commonly Used Blocks | hdlsllib/Commonly Used Blocks | R2023a+ | Use as a quick-access container for the most frequently used HDL Coder library blocks |
| Wrap To Zero | hdlsllib/Discontinuities/Wrap To Zero | R2023a+ | Use when you need a signal to reset to zero after exceeding a threshold value |
| Enabled Synchronous Subsystem | hdlsllib/HDL Subsystems/Enabled Synchronous Subsystem | R2023a+ | Use when you need a subsystem that executes synchronously only when its enable input is active |
| Resettable Synchronous Subsystem | hdlsllib/HDL Subsystems/Resettable Synchronous Subsystem | R2023a+ | Use when you need a subsystem with synchronous reset that reinitializes all internal states |
| Synchronous Subsystem | hdlsllib/HDL Subsystems/Synchronous Subsystem | R2023a+ | Use when you need to group logic into a subsystem that operates on a single clock domain |
| Ports & Subsystems | hdlsllib/Ports & Subsystems | R2023a+ | Use as a container for port and subsystem block elements in HDL designs |
| Switch | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/Switch | R2023a+ | Use when you need to select between inputs based on a control signal condition |
| Backlash | hdlsllib/Discontinuities/Backlash | R2023a+ | Use when you need to model mechanical backlash or gear play behavior in HDL |
| Coulomb & Viscous Friction | hdlsllib/Discontinuities/Coulomb & Viscous Friction | R2023a+ | Use when you need to model static and dynamic friction forces in an HDL simulation |
| Dead Zone | hdlsllib/Discontinuities/Dead Zone | R2023a+ | Use when you need to suppress signal values within a specified band around zero |
| Dead Zone Dynamic | hdlsllib/Discontinuities/Dead Zone Dynamic | R2023a+ | Use when you need a dead zone with dynamically adjustable upper and lower limits |
| Hit  Crossing | hdlsllib/Discontinuities/Hit  Crossing | R2023a+ | Use when you need to detect when a signal crosses a specified threshold value |
| Relay | hdlsllib/Discontinuities/Relay | R2023a+ | Use when you need hysteresis-based switching between two output values |
| Saturation | hdlsllib/Discontinuities/Saturation | R2023a+ | Use when you need to clamp a signal within fixed upper and lower bounds |
| Saturation Dynamic | hdlsllib/Discontinuities/Saturation Dynamic | R2023a+ | Use when you need to clamp a signal within dynamically adjustable bounds |
| State Control | hdlsllib/HDL Subsystems/State Control | R2023a+ | Use when you need to specify synchronous or combinational reset behavior for a subsystem |
