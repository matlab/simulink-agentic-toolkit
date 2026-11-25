---
type: Simulink Block Category
title: Electrical couplers
description: Electrical network partitioning couplers (6 blocks)
tags: [toolbox-kb, network-couplers, capacitor, inductor, voltage, current, electrical]
status: stable
sources:
  - resource: matlab:SimscapeNetworkCouplersLib
source: toolbox_kb
managed_by: satk
library: Network Couplers
kb_folder: network-couplers
category: electrical-couplers
block_count: 6
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:24Z" }
---

# Electrical couplers

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Network Coupler (Capacitor) | SimscapeNetworkCouplersLib/Network Coupler (Capacitor) | R2023a+ | Couple two electrical networks via a virtual capacitor — use for partitioning large electrical circuits into separately-solved networks at a capacitive interface |
| Network Coupler (Current-Voltage) | SimscapeNetworkCouplersLib/Network Coupler (Current-Voltage) | R2023a+ | Couple electrical networks with current on one side and voltage on the other — use for interfacing current-source and voltage-source network partitions |
| Network Coupler (Inductor) | SimscapeNetworkCouplersLib/Network Coupler (Inductor) | R2023a+ | Couple two electrical networks via a virtual inductor — use for partitioning electrical circuits at an inductive interface element |
| Network Coupler (Transmission Line) | SimscapeNetworkCouplersLib/Network Coupler (Transmission Line) | R2023a+ | Couple two electrical networks via a transmission line delay — use for naturally decoupling electrical networks separated by propagation delay |
| Network Coupler (Voltage-Current) | SimscapeNetworkCouplersLib/Network Coupler (Voltage-Current) | R2023a+ | Couple electrical networks with voltage on one side and current on the other — use for interfacing voltage-source and current-source network partitions |
| Network Coupler (Voltage-Voltage) | SimscapeNetworkCouplersLib/Network Coupler (Voltage-Voltage) | R2023a+ | Couple two electrical networks via voltage-voltage interface — use for partitioning electrical circuits at a voltage-type coupling point |
