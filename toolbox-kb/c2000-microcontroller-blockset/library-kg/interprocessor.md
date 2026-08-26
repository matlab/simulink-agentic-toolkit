---
type: Simulink Block Category
title: Interprocessor
description: Inter-processor communication for dual-core C2000 devices
tags: [ipc, interprocess, dual-core, shared, multicore]
status: stable
source: mathworks_toolbox
library_root: C2000 Microcontroller Blockset
category_path: Interprocessor
block_count: 10
---

# Interprocessor

Use these blocks for interprocessor.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| IPC Receive | c2837xDlib/IPC Receive | R2023b+ | Receive data from another processor core via the inter-processor communication module — use in dual-core C2000 devices to read data computed by the other CPU or CLA |
| IPC Transmit | c2837xDlib/IPC Transmit | R2023b+ | Send data to another processor core via the inter-processor communication module — use in dual-core C2000 devices to share computed results with the other CPU |
| IPC Receive | c2838xlib/IPC Receive | R2023b+ | Receive data from another processor core via the inter-processor communication module — use in dual-core C2000 devices to read data computed by the other CPU or CLA |
| IPC Transmit | c2838xlib/IPC Transmit | R2023b+ | Send data to another processor core via the inter-processor communication module — use in dual-core C2000 devices to share computed results with the other CPU |
| IPC Receive | c2838x_M4_lib/IPC Receive | R2023b+ | Receive data from another processor core via the inter-processor communication module — use in dual-core C2000 devices to read data computed by the other CPU or CLA |
| IPC Transmit | c2838x_M4_lib/IPC Transmit | R2023b+ | Send data to another processor core via the inter-processor communication module — use in dual-core C2000 devices to share computed results with the other CPU |
| IPC Receive | c28P65xlib/IPC Receive | R2024a+ | Receive data from another processor core via the inter-processor communication module — use in dual-core C2000 devices to read data computed by the other CPU or CLA |
| IPC Transmit | c28P65xlib/IPC Transmit | R2024a+ | Send data to another processor core via the inter-processor communication module — use in dual-core C2000 devices to share computed results with the other CPU |
| Interprocess Data Read | c2000lib/Target Communication/Interprocess Data Read | R2023a+ | Read shared data written by another processor core — use for lightweight data exchange between CPU cores without message-based IPC overhead |
| Interprocess Data Write | c2000lib/Target Communication/Interprocess Data Write | R2023a+ | Write data to shared memory accessible by another processor core — use for lightweight data sharing between CPU cores without message-based IPC overhead |
