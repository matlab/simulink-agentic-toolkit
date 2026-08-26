---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 5
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Configure a CAN channel for communication — use for setting up baud rate, hardware interface, and bus parameters before sending or receiving | CAN Configuration | Vehicle Network Toolbox |
| Pack signal values into a CAN message frame — use for encoding physical signals into the CAN data payload using a DBC definition | CAN Pack | Vehicle Network Toolbox |
| Receive CAN messages from the bus — use for reading incoming frames from ECUs or sensors on the CAN network | CAN Receive | Vehicle Network Toolbox |
| Transmit CAN messages to the bus — use for sending frames to ECUs or actuators on the CAN network | CAN Transmit | Vehicle Network Toolbox |
| Unpack signal values from a CAN message frame — use for decoding physical signals from received CAN data using a DBC definition | CAN Unpack | Vehicle Network Toolbox |
