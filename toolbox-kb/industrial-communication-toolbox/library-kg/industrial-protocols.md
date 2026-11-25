---
type: Simulink Block Category
title: Industrial protocols
description: Industrial communication protocols for automation and IoT (6 blocks)
tags: [toolbox-kb, industrial-communication-toolbox, mqtt, modbus, opcua, industrial, iot]
status: stable
sources:
  - resource: matlab:mqttlib
source: toolbox_kb
managed_by: satk
library: Industrial Communication Toolbox
kb_folder: industrial-communication-toolbox
category: industrial-protocols
block_count: 6
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:23Z" }
---

# Industrial protocols

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| MQTT Client Publish | mqttlib/MQTT Client Publish | R2025a+ | Publish messages to an MQTT broker — use for IoT telemetry, cloud data upload, or machine-to-cloud communication in industrial systems |
| MQTT Client Subscribe | mqttlib/MQTT Client Subscribe | R2025a+ | Subscribe to MQTT topics and receive messages — use for receiving cloud commands, IoT control signals, or inter-device messaging |
| Modbus Client Read | modbuslib/Modbus Client Read | R2024b+ | Read registers from a Modbus server — use for acquiring data from PLCs, sensors, or industrial equipment via Modbus TCP/RTU |
| Modbus Client Write | modbuslib/Modbus Client Write | R2024b+ | Write registers to a Modbus server — use for sending commands to PLCs, actuators, or industrial equipment via Modbus TCP/RTU |
| OPC UA Read | opcualib/OPC UA Read | R2024a+ | Read variables from an OPC UA server — use for acquiring process data from industrial automation systems using OPC Unified Architecture |
| OPC UA Write | opcualib/OPC UA Write | R2024a+ | Write variables to an OPC UA server — use for sending setpoints or commands to industrial automation systems via OPC UA |
