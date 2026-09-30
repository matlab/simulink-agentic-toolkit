---
type: Simulink Block Category
title: Synchronization
description: Carrier, symbol, and frame synchronization
tags: [synchronization, carrier synchronizer, symbol synchronizer, preamble]
status: stable
source: custom_library
library_root: Communications Toolbox
category_path: Synchronization
block_count: 5
---

# Synchronization

Use these blocks for synchronization.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Coarse Frequency Compensator | commrfcorlib/Coarse Frequency Compensator | R2023a+ | Estimate and remove a large carrier frequency offset — use as the first stage of carrier recovery. |
| Carrier Synchronizer | commsync2/Carrier Synchronizer | R2023a+ | Recover carrier phase and residual frequency offset — use to lock onto the carrier before symbol decisions. |
| Coarse Frequency Compensator | commsync2/Coarse Frequency Compensator | R2023a+ | Estimate and remove a large carrier frequency offset — use as the first stage of carrier recovery. |
| Preamble Detector | commsync2/Preamble Detector | R2023a+ | Detect a known preamble in a received stream and report its timing — use for frame synchronization. |
| Symbol Synchronizer | commsync2/Symbol Synchronizer | R2023a+ | Recover symbol timing and produce one sample per symbol — use for timing recovery at the receiver. |
