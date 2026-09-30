---
type: Simulink Block Category
title: Fault signal ports
description: Ports that route the modeled signal into and out of a fault subsystem's injection logic
tags: [fault, signal, inport, outport, subsystem]
status: stable
source: custom_library
library_root: Simulink Fault Analyzer
category_path: Fault signal ports
block_count: 4
---

# Fault signal ports

Use these blocks for fault signal ports.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Fault Inport | mwfaultblocklib/Fault Port Blocks/Fault Inport | R2023a+ | Marks where the original, un-faulted signal enters a fault subsystem. Use it inside fault-modeling logic to reference the healthy signal that the fault will corrupt, override, or degrade before it flows back to the model. |
| Fault Outport | mwfaultblocklib/Fault Port Blocks/Fault Outport | R2023a+ | Sends the modified value out of a fault subsystem and back onto the modeled signal. Use it as the endpoint of fault-injection logic so that the faulted signal, rather than the original, drives downstream blocks during analysis. |
| Fault Inport | mwfaultblocklib/Fault Subsystem/Fault Inport | R2023a+ | Marks where the original, un-faulted signal enters a fault subsystem. Use it inside fault-modeling logic to reference the healthy signal that the fault will corrupt, override, or degrade before it flows back to the model. |
| Fault Outport | mwfaultblocklib/Fault Subsystem/Fault Outport | R2023a+ | Sends the modified value out of a fault subsystem and back onto the modeled signal. Use it as the endpoint of fault-injection logic so that the faulted signal, rather than the original, drives downstream blocks during analysis. |
