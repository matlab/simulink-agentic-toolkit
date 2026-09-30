---
type: Simulink Block Category
title: Network couplers
description: Split a physical network into partitions coupled through an element, for solver decoupling or real-time simulation
tags: [network coupler, coupler]
status: stable
source: custom_library
library_root: Utilities
category_path: Network couplers
block_count: 14
---

# Network couplers

Use these blocks for network couplers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Prediction (discrete->continuous) | SimscapeNetworkCouplersLib/Fundamental Components/Prediction (discrete->continuous) | R2023a+ | Use this block prior to connecting a discrete-time network to a continuous time network. The block predicts what the input u is between sampling points by using the last calculated gradient and time elapsed since last sampling event. |
| Prediction (slow->fast) | SimscapeNetworkCouplersLib/Fundamental Components/Prediction (slow->fast) | R2023a+ | Use this block prior to connecting a discrete-time network to another discrete-time network that has a faster sampling rate. The block predicts what the input u would have been had it been sampled at the faster sampling rate. The block does this by calculating the derivative of input u. |
| Smoothing (continuous->discrete) | SimscapeNetworkCouplersLib/Fundamental Components/Smoothing (continuous->discrete) | R2023a+ | Use this block prior to connecting a continuous-time network to a fixed-step network. The block applies a first-order transfer function to smooth high frequency dynamics that cannot be tracked by the fixed-step network. Typically the smoothing time constant should be at least a factor of 10 times larger than the fixed-step size. |
| Smoothing (fast->slow) | SimscapeNetworkCouplersLib/Fundamental Components/Smoothing (fast->slow) | R2023a+ | Use this block prior to connecting a discrete-time network to another discrete-time network with a slower sampling rate. The block averages input u over the specified number of samples and passes the result to output y. |
| Network Coupler (Capacitor) | SimscapeNetworkCouplersLib/Network Coupler (Capacitor) | R2023a+ | Couple two electrical network partitions through a capacitor — use to split a large network for solver decoupling or real-time partitioning. |
| Network Coupler (Compressible Link) | SimscapeNetworkCouplersLib/Network Coupler (Compressible Link) | R2023a+ | Couple two gas/fluid network partitions through a compressible link — use to decouple large compressible-flow networks for faster or real-time solving. |
| Network Coupler (Constant Volume Chamber (IL)) | SimscapeNetworkCouplersLib/Network Coupler (Constant Volume Chamber (IL)) | R2023a+ | Couple two isothermal-liquid network partitions through a constant-volume chamber — use to decouple hydraulic networks for real-time simulation. |
| Network Coupler (Constant Volume Chamber (TL)) | SimscapeNetworkCouplersLib/Network Coupler (Constant Volume Chamber (TL)) | R2023a+ | Couple two thermal-liquid network partitions through a constant-volume chamber — use to decouple thermal-liquid networks for real-time simulation. |
| Network Coupler (Current-Voltage) | SimscapeNetworkCouplersLib/Network Coupler (Current-Voltage) | R2023a+ | Couple electrical partitions with a current-to-voltage coupling — use to split an electrical network at a controlled-source boundary. |
| Network Coupler (Flexible Shaft) | SimscapeNetworkCouplersLib/Network Coupler (Flexible Shaft) | R2023a+ | Couple two mechanical rotational partitions through a flexible shaft — use to decouple driveline networks for real-time simulation. |
| Network Coupler (Inductor) | SimscapeNetworkCouplersLib/Network Coupler (Inductor) | R2023a+ | Couple two electrical network partitions through an inductor — use to split a large electrical network for solver decoupling. |
| Network Coupler (Thermal Mass) | SimscapeNetworkCouplersLib/Network Coupler (Thermal Mass) | R2023a+ | Couple two thermal network partitions through a thermal mass — use to decouple thermal networks for real-time simulation. |
| Network Coupler (Voltage-Current) | SimscapeNetworkCouplersLib/Network Coupler (Voltage-Current) | R2023a+ | Couple electrical partitions with a voltage-to-current coupling — use to split an electrical network at a controlled-source boundary. |
| Network Coupler (Voltage-Voltage) | SimscapeNetworkCouplersLib/Network Coupler (Voltage-Voltage) | R2023a+ | Couple two electrical network partitions with a voltage-to-voltage coupling — use to split a network while preserving voltage continuity. |
