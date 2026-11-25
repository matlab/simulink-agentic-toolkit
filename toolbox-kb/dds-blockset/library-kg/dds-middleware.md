---
type: Simulink Block Category
title: Dds middleware
description: OMG Data Distribution Service (DDS) publish-subscribe middleware blocks (2 blocks)
tags: [toolbox-kb, dds-blockset, dds, topic, publish, subscribe, middleware]
status: stable
sources:
  - resource: matlab:ddslib
source: toolbox_kb
managed_by: satk
library: DDS Blockset
kb_folder: dds-blockset
category: dds-middleware
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:16Z" }
---

# Dds middleware

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Take DDS Sample | ddslib/Take DDS Sample | R2023a+ | Read a data sample from a DDS (Data Distribution Service) topic — use to subscribe to real-time distributed data in systems that communicate over OMG DDS middleware |
| Write DDS Sample | ddslib/Write DDS Sample | R2023a+ | Publish a data sample to a DDS (Data Distribution Service) topic — use to broadcast real-time data from Simulink to other DDS participants in a distributed system |
