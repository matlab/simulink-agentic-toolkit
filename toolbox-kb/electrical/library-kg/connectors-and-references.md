---
type: Simulink Block Category
title: Connectors and references
description: Electrical references, busbars, connectors, and phase management
tags: [reference, ground, busbar, neutral, phase]
status: stable
source: mathworks_toolbox
library_root: Electrical
category_path: Connectors and references
block_count: 15
---

# Connectors and references

Use these blocks for connectors and references.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Array of Electrical Nodes | ee_lib/Connectors & References/Array of Electrical Nodes | R2023a+ | Create an array of electrical connection nodes — use to efficiently connect parallel circuit branches or multi-phase components with vectorized ports |
| Busbar | ee_lib/Connectors & References/Busbar | R2023a+ | Model an AC busbar as a connection point for multiple three-phase branches — use for power system substation or distribution panel modeling |
| Busbar (DC) | ee_lib/Connectors & References/Busbar (DC) | R2023a+ | Model a DC busbar as a connection point for multiple DC branches — use for DC distribution systems, battery buses, or power electronics DC links |
| Cable and Connectors | ee_lib/Connectors & References/Cable and Connectors | R2023a+ | Model a cable with distributed resistance, inductance, and connector impedances — use for wiring harness, interconnect loss, or cable routing studies |
| Delta Reference (Three-Phase) | ee_lib/Connectors & References/Delta Reference (Three-Phase) | R2023a+ | Provide a delta-connected voltage reference for three-phase systems — use to establish the voltage reference for delta-connected loads or sources |
| Electrical Reference | ee_lib/Connectors & References/Electrical Reference | R2023a+ | Define the electrical ground reference node — use as the zero-potential reference for every electrical circuit in the model |
| Floating Neutral (Three-Phase) | ee_lib/Connectors & References/Floating Neutral (Three-Phase) | R2023a+ | Create a floating neutral point for three-phase systems — use when the neutral is not connected to ground in ungrounded wye configurations |
| Floating Reference | ee_lib/Connectors & References/Floating Reference | R2023a+ | Define an isolated electrical reference — use for galvanically isolated circuit sections that do not share a common ground |
| Grounded Neutral (Three-Phase) | ee_lib/Connectors & References/Grounded Neutral (Three-Phase) | R2023a+ | Create a grounded neutral point for three-phase systems — use for solidly grounded wye configurations in power distribution |
| Neutral Port (Three-Phase) | ee_lib/Connectors & References/Neutral Port (Three-Phase) | R2023a+ | Expose the neutral connection of a three-phase component as a physical port — use to access the neutral for grounding or impedance insertion |
| Open Circuit | ee_lib/Connectors & References/Open Circuit | R2023a+ | Represent an open circuit with no current flow — use to cap unused electrical ports or explicitly model disconnected conditions |
| Open Circuit (Three-Phase) | ee_lib/Connectors & References/Open Circuit (Three-Phase) | R2023a+ | Represent a three-phase open circuit — use to cap unused three-phase ports or model open-phase fault conditions |
| PS Three-Element Demux | ee_lib/Connectors & References/PS Three-Element Demux | R2023a+ | Split a three-element physical signal into individual scalar physical signals — use to separate three-phase measurement outputs into per-phase signals |
| Phase Permute | ee_lib/Connectors & References/Phase Permute | R2023a+ | Swap the phase sequence of a three-phase connection — use to correct phase order, implement phase rotation, or test reverse-sequence effects |
| Phase Splitter | ee_lib/Connectors & References/Phase Splitter | R2023a+ | Split a composite three-phase connection into individual single-phase connections — use to access individual phases for measurement or asymmetric loads |
