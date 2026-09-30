---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 16
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Create a wireless (label-based) physical connection between two ports — use to reduce clutter in large Simscape schematics. | Connection Label | Utilities |
| Measure and output internal variables of a connected Simscape component without breaking the connection — use for non-intrusive physical diagnostics. | Probe | Utilities |
| Instantiate a custom Simscape (.ssc) component in the model — use to bring a language-authored physical component into a diagram. | Simscape Component | Utilities |
| Bundle multiple physical connections into a single Simscape bus line — use to simplify multi-domain physical interfaces. | Simscape Bus | Utilities |
| Expose a physical connection port on a Simscape subsystem — use to create physical pins on a masked subsystem. | Connection Port | Utilities |
| Use this block prior to connecting a discrete-time network to a continuous time network. The block predicts what the input u is between sampling points by using the last calculated gradient and time elapsed since last sampling event. | Prediction (discrete->continuous) | Utilities |
| Use this block prior to connecting a discrete-time network to another discrete-time network that has a faster sampling rate. The block predicts what the input u would have been had it been sampled at the faster sampling rate. The block does this by calculating the derivative of input u. | Prediction (slow->fast) | Utilities |
| Use this block prior to connecting a continuous-time network to a fixed-step network. The block applies a first-order transfer function to smooth high frequency dynamics that cannot be tracked by the fixed-step network. Typically the smoothing time constant should be at least a factor of 10 times larger than the fixed-step size. | Smoothing (continuous->discrete) | Utilities |
| Use this block prior to connecting a discrete-time network to another discrete-time network with a slower sampling rate. The block averages input u over the specified number of samples and passes the result to output y. | Smoothing (fast->slow) | Utilities |
| Couple two electrical network partitions through a capacitor — use to split a large network for solver decoupling or real-time partitioning. | Network Coupler (Capacitor) | Utilities |
| Wire an array of identical Simscape components in bulk through a single connection — use to build vectorized physical networks without drawing individual lines. | Array Connection | Utilities |
| Display the frequency spectrum of a signal during simulation — use to inspect harmonic and spectral content. | Spectrum Analyzer | Utilities |
| Physical-connection variant switch that selects among alternative Simscape subnetworks — use for configurable or variant physical models. | Variant Connector | Utilities |
| Converts the input Physical Signal to a Simulink output signal. Format of Simulink output signal matches the format of Physical Signal. 'Vector format' provides an option for outputting vector Physical Signals as Simulink 1-D arrays. The unit expression in 'Output signal unit' parameter must match or be commensurate with the unit of the Physical Signal and determines the conversion from the Physical Signal to the Simulink output signal. 'Apply affine conversion' check box is only relevant for units with offset (such as temperature units). | PS-Simulink Converter | Utilities |
| Converts the Simulink input signal to a Physical Signal. The unit expression in 'Input signal unit' parameter is associated with the Simulink input signal and determines the unit assigned to the Physical Signal. 'Apply affine conversion' check box is only relevant for units with offset (such as temperature units). If the selected solver requires input derivatives, you can either provide them explicitly through additional signal ports, or turn on input filtering to calculate time derivatives. The first-order filter provides one derivative, while the second-order filter provides the first and second derivatives. For piecewise-constant signals, you can also explicitly set the input derivatives to zero. | Simulink-PS Converter | Utilities |
| Defines solver settings to use for simulation. | Solver Configuration | Utilities |
