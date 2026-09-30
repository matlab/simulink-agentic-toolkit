---
type: Simulink Block Category
title: Dds
description: Blocks for dds.
status: draft
source: custom_library
library_root: Simulink Real-Time
category_path: Dds
block_count: 2
---

# Dds

Use these blocks for dds.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| DDS Receive | slrealtimeddslib/DDS Receive | R2024a+ | Receives a DDS message on a selected DDS topic. This block allows to attach a Simulink Data Dictionary containing DDS definitions with the model. Choose a DDS topic, DataReader, and QoS from the available options in the Data Dictionary. |
| DDS Send | slrealtimeddslib/DDS Send | R2024a+ | Sends a DDS message for a selected topic. This block allows to attach a Simulink Data Dictionary containing DDS definitions with the model. Choose a DDS topic, DataWriter, and QoS from the available options in the Data Dictionary. |
