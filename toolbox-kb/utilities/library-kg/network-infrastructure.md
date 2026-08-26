---
type: Simulink Block Category
title: Network infrastructure
description: Physical network configuration and connectivity
tags: [solver, port, bus, connection, array]
status: stable
source: mathworks_toolbox
library_root: Utilities
category_path: Network infrastructure
block_count: 7
---

# Network infrastructure

Use these blocks for network infrastructure.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Solver Configuration | nesl_utility/Solver Configuration | R2023a+ | Configure the Simscape local solver for a physical network — use at the top level of every Simscape physical network to set solver parameters |
| Array Connection | nesl_utility/Array Connection | R2025a+ | Create an array of physical connections — use for modeling repeated physical elements like battery cells in series or parallel without manual wiring |
| Connection Label | nesl_utility/Connection Label | R2023a+ | Label a physical connection line — use for identifying and organizing physical signal connections in complex Simscape models |
| Simscape Component | nesl_utility/Simscape Component | R2023a+ | Instantiate a custom Simscape component from a .ssc file — use for adding user-defined physical domain components written in Simscape language |
| Simscape Bus | nesl_utility/Simscape Bus | R2023a+ | Bundle multiple physical connections into a single bus — use for simplifying wiring in models with many parallel physical connections |
| Variant Connector | nesl_utility/Variant Connector | R2023a+ | Switch between physical connection variants — use for modeling different physical configurations that can be selected at compile time |
| Connection Port | nesl_utility/Connection Port | R2023a+ | Create a physical connection port on a subsystem boundary — use for exposing Simscape physical connections through subsystem interfaces |
