---
type: Simulink Block Category
title: Protection diagnostics
description: Host-side serial communication and protection/diagnostic utilities for embedded motor-control targets
tags: [serial, host, protection, relay, diagnostic, safety]
status: stable
source: mathworks_toolbox
library_root: Motor Control Blockset
category_path: Protection diagnostics
block_count: 4
---

# Protection diagnostics

Use these blocks for protection diagnostics.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Host Serial Receive | mcblib/Protection and Diagnostics/Host Serial Receive | R2023a+ | Receive framed serial data on the host PC from a target motor-control MCU — use to bring live measurement, telemetry, or debug data back into Simulink for monitoring |
| Host Serial Setup | mcblib/Protection and Diagnostics/Host Serial Setup | R2023a+ | Configure the host-side serial port (COM port, baud rate, parity) used to talk to a target MCU — use once at the top of a host monitoring model |
| Host Serial Transmit | mcblib/Protection and Diagnostics/Host Serial Transmit | R2023a+ | Send framed serial data from the host PC to a target motor-control MCU — use to command setpoints, gains, or test triggers from a live monitoring model |
| Protection Relay | mcblib/Protection and Diagnostics/Protection Relay | R2023a+ | Latch a fault condition (over-current, over-temperature, over-voltage) and hold the drive disabled until reset — use to implement safe shutdown of a motor-control system |
