---
type: Simulink Block Category
title: Dds
description: Blocks for Dds (2 blocks)
tags: [toolbox-kb, simulink-real-time]
status: draft
sources:
  - resource: matlab:slrealtimeddslib
source: toolbox_kb
managed_by: satk
library: Simulink Real-Time
kb_folder: simulink-real-time
category: dds
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:31Z" }
---

# Dds

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| DDS Receive | slrealtimeddslib/DDS Receive | R2024a+ | Receives a DDS message on a selected DDS topic. This block allows to attach a Simulink Data Dictionary containing DDS definitions with the model. Choose a DDS topic, DataReader, and QoS from the available options in the Data Dictionary. |
| DDS Send | slrealtimeddslib/DDS Send | R2024a+ | Sends a DDS message for a selected topic. This block allows to attach a Simulink Data Dictionary containing DDS definitions with the model. Choose a DDS topic, DataWriter, and QoS from the available options in the Data Dictionary. |
