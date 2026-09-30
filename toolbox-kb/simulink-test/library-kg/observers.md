---
type: Simulink Block Category
title: Observers
description: Non-intrusive monitoring and verification of a system under test through a separate observer model.
tags: [observer, monitor, verify, signal-access, non-intrusive]
status: stable
source: custom_library
library_root: Simulink Test
category_path: Observers
block_count: 2
---

# Observers

Use these blocks for observers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Observer | sltestlib/Observer | R2023a+ | Reference a separate observer model to monitor and verify signals inside a system under test without editing the design — use when you want verification logic kept isolated from the model under test and reusable across harnesses. |
| ObserverPort | sltestlib/ObserverPort | R2023a+ | Tap a signal from the system under test by its path and bring it into an observer for assessment — use inside an observer to pick exactly which internal signals to watch without adding ports to the design model. |
