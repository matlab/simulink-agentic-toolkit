---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 5
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Convert a Simscape physical signal to a Simulink signal — use for passing measurement data from physical networks into standard Simulink processing | PS-Simulink Converter | Utilities |
| Convert a Simulink signal to a Simscape physical signal — use for injecting control commands or setpoints from Simulink into physical network models | Simulink-PS Converter | Utilities |
| Configure the Simscape local solver for a physical network — use at the top level of every Simscape physical network to set solver parameters | Solver Configuration | Utilities |
| Measure internal variables of a Simscape block — use for extracting physical quantities like current, voltage, or flow without breaking the physical connection | Probe | Utilities |
| Create a physical connection port on a subsystem boundary — use for exposing Simscape physical connections through subsystem interfaces | Connection Port | Utilities |
