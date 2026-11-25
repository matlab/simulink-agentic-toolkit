---
type: Simulink Block Category
title: Synchronization
description: "Carrier, symbol, and frame synchronization (5 blocks)"
tags: [toolbox-kb, communications-toolbox, synchronization, carrier synchronizer, symbol synchronizer, preamble]
status: stable
sources:
  - resource: matlab:commrfcorlib
source: toolbox_kb
managed_by: satk
library: Communications Toolbox
kb_folder: communications-toolbox
category: synchronization
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:15Z" }
---

# Synchronization

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Coarse Frequency Compensator | commrfcorlib/Coarse Frequency Compensator | R2023a+ | Estimate and remove a large carrier frequency offset — use as the first stage of carrier recovery. |
| Carrier Synchronizer | commsync2/Carrier Synchronizer | R2023a+ | Recover carrier phase and residual frequency offset — use to lock onto the carrier before symbol decisions. |
| Coarse Frequency Compensator | commsync2/Coarse Frequency Compensator | R2023a+ | Estimate and remove a large carrier frequency offset — use as the first stage of carrier recovery. |
| Preamble Detector | commsync2/Preamble Detector | R2023a+ | Detect a known preamble in a received stream and report its timing — use for frame synchronization. |
| Symbol Synchronizer | commsync2/Symbol Synchronizer | R2023a+ | Recover symbol timing and produce one sample per symbol — use for timing recovery at the receiver. |
