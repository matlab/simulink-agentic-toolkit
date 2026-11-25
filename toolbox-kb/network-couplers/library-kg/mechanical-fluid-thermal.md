---
type: Simulink Block Category
title: Mechanical fluid thermal
description: "Mechanical, fluid, and thermal network couplers (5 blocks)"
tags: [toolbox-kb, network-couplers, shaft, compressible, thermal, chamber, fluid]
status: stable
sources:
  - resource: matlab:SimscapeNetworkCouplersLib
source: toolbox_kb
managed_by: satk
library: Network Couplers
kb_folder: network-couplers
category: mechanical-fluid-thermal
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:24Z" }
---

# Mechanical fluid thermal

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Network Coupler (Compressible Link) | SimscapeNetworkCouplersLib/Network Coupler (Compressible Link) | R2023a+ | Couple two hydraulic networks via a compressible fluid link — use for partitioning hydraulic systems at a compliance element for co-simulation |
| Network Coupler (Constant Volume Chamber (IL)) | SimscapeNetworkCouplersLib/Network Coupler (Constant Volume Chamber (IL)) | R2023a+ | Couple isothermal liquid networks via a constant volume chamber — use for partitioning isothermal liquid circuits at a compliance element |
| Network Coupler (Constant Volume Chamber (TL)) | SimscapeNetworkCouplersLib/Network Coupler (Constant Volume Chamber (TL)) | R2023a+ | Couple two-phase liquid networks via a constant volume chamber — use for partitioning thermal-liquid circuits at a compliance element |
| Network Coupler (Flexible Shaft) | SimscapeNetworkCouplersLib/Network Coupler (Flexible Shaft) | R2023a+ | Couple two mechanical rotational networks via a flexible shaft — use for partitioning driveline models at a compliant shaft element |
| Network Coupler (Thermal Mass) | SimscapeNetworkCouplersLib/Network Coupler (Thermal Mass) | R2023a+ | Couple two thermal networks via a thermal mass — use for partitioning thermal systems at a heat capacity element |
