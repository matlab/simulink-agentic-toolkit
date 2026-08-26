---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 4
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Read registers from a Modbus server — use for acquiring data from PLCs, sensors, or industrial equipment via Modbus TCP/RTU | Modbus Client Read | Industrial Communication Toolbox |
| Write registers to a Modbus server — use for sending commands to PLCs, actuators, or industrial equipment via Modbus TCP/RTU | Modbus Client Write | Industrial Communication Toolbox |
| Read variables from an OPC UA server — use for acquiring process data from industrial automation systems using OPC Unified Architecture | OPC UA Read | Industrial Communication Toolbox |
| Write variables to an OPC UA server — use for sending setpoints or commands to industrial automation systems via OPC UA | OPC UA Write | Industrial Communication Toolbox |
