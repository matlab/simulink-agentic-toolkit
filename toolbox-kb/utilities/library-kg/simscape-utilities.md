---
type: Simulink Block Category
title: Simscape utilities
description: Core Simscape connection, probing, and component-authoring utilities
tags: [connection, probe, simscape component, simscape bus, variant connector, array connection, spectrum analyzer]
status: stable
source: custom_library
library_root: Utilities
category_path: Simscape utilities
block_count: 8
---

# Simscape utilities

Use these blocks for simscape utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Array Connection | nesl_utility/Array Connection | R2025a+ | Wire an array of identical Simscape components in bulk through a single connection — use to build vectorized physical networks without drawing individual lines. |
| Connection Label | nesl_utility/Connection Label | R2023a+ | Create a wireless (label-based) physical connection between two ports — use to reduce clutter in large Simscape schematics. |
| Probe | nesl_utility/Probe | R2023a+ | Measure and output internal variables of a connected Simscape component without breaking the connection — use for non-intrusive physical diagnostics. |
| Simscape Component | nesl_utility/Simscape Component | R2023a+ | Instantiate a custom Simscape (.ssc) component in the model — use to bring a language-authored physical component into a diagram. |
| Simscape Bus | nesl_utility/Simscape Bus | R2023a+ | Bundle multiple physical connections into a single Simscape bus line — use to simplify multi-domain physical interfaces. |
| Spectrum Analyzer | nesl_utility/Spectrum Analyzer | R2023a+ | Display the frequency spectrum of a signal during simulation — use to inspect harmonic and spectral content. |
| Variant Connector | nesl_utility/Variant Connector | R2023a+ | Physical-connection variant switch that selects among alternative Simscape subnetworks — use for configurable or variant physical models. |
| Connection Port | nesl_utility/Connection Port | R2023a+ | Expose a physical connection port on a Simscape subsystem — use to create physical pins on a masked subsystem. |
