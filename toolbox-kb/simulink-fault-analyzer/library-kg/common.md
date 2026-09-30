---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 4
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Marks where the original, un-faulted signal enters a fault subsystem. Use it inside fault-modeling logic to reference the healthy signal that the fault will corrupt, override, or degrade before it flows back to the model. | Fault Inport | Simulink Fault Analyzer |
| Sends the modified value out of a fault subsystem and back onto the modeled signal. Use it as the endpoint of fault-injection logic so that the faulted signal, rather than the original, drives downstream blocks during analysis. | Fault Outport | Simulink Fault Analyzer |
| Marks where the original, un-faulted signal enters a fault subsystem. Use it inside fault-modeling logic to reference the healthy signal that the fault will corrupt, override, or degrade before it flows back to the model. | Fault Inport | Simulink Fault Analyzer |
| Sends the modified value out of a fault subsystem and back onto the modeled signal. Use it as the endpoint of fault-injection logic so that the faulted signal, rather than the original, drives downstream blocks during analysis. | Fault Outport | Simulink Fault Analyzer |
