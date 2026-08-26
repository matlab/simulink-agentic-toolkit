---
type: Simulink Block Category
title: Ethercat
description: EtherCAT fieldbus communication, PDO exchange, and subdevice management
tags: [EtherCAT, PDO, SDO, fieldbus, subdevice]
status: stable
source: mathworks_toolbox
library_root: Simulink Real-Time
category_path: Ethercat
block_count: 18
---

# Ethercat

Use these blocks for ethercat.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| EtherCAT Async SDO Download | slrealtimeethercatlib/EtherCAT Async SDO Download | R2024a+ | Write parameters to an EtherCAT subdevice asynchronously via SDO protocol |
| EtherCAT Async SDO Upload | slrealtimeethercatlib/EtherCAT Async SDO Upload | R2024a+ | Read parameters from an EtherCAT subdevice asynchronously via SDO protocol |
| EtherCAT Async SSC/SoE Download | slrealtimeethercatlib/EtherCAT Async SSC/SoE Download | R2023a+ | Write parameters to a SERCOS-over-EtherCAT subdevice asynchronously |
| EtherCAT Async SSC/SoE Upload | slrealtimeethercatlib/EtherCAT Async SSC/SoE Upload | R2023a+ | Read parameters from a SERCOS-over-EtherCAT subdevice asynchronously |
| EtherCAT Get Emergency | slrealtimeethercatlib/EtherCAT Get Emergency | R2024a+ | Read emergency messages from an EtherCAT subdevice for fault diagnosis |
| EtherCAT Get Notifications | slrealtimeethercatlib/EtherCAT Get Notifications | R2024a+ | Read EtherCAT master notifications for network health monitoring |
| EtherCAT Get Scanbus Error Data | slrealtimeethercatlib/EtherCAT Get Scanbus Error Data | R2024a+ | Retrieve bus scan error information for EtherCAT network diagnostics |
| EtherCAT Get State | slrealtimeethercatlib/EtherCAT Get State | R2024a+ | Read the current state machine state of the EtherCAT master |
| EtherCAT Init | slrealtimeethercatlib/EtherCAT Init | R2024a+ | Initialize the EtherCAT master and configure network parameters at startup |
| EtherCAT PDO Receive | slrealtimeethercatlib/EtherCAT PDO Receive | R2024a+ | Receive process data objects from EtherCAT subdevices in the cyclic data exchange |
| EtherCAT PDO Transmit | slrealtimeethercatlib/EtherCAT PDO Transmit | R2024a+ | Transmit process data objects to EtherCAT subdevices in the cyclic data exchange |
| EtherCAT Set State | slrealtimeethercatlib/EtherCAT Set State | R2024a+ | Command the EtherCAT master to transition to a specified state |
| EtherCAT Sync SDO Download | slrealtimeethercatlib/EtherCAT Sync SDO Download | R2024a+ | Write parameters to an EtherCAT subdevice synchronously via SDO protocol |
| EtherCAT Sync SDO Upload | slrealtimeethercatlib/EtherCAT Sync SDO Upload | R2024a+ | Read parameters from an EtherCAT subdevice synchronously via SDO protocol |
| EtherCAT Sync SSC/SoE Download | slrealtimeethercatlib/EtherCAT Sync SSC/SoE Download | R2023a+ | Write parameters to a SERCOS-over-EtherCAT subdevice synchronously |
| EtherCAT Sync SSC/SoE Upload | slrealtimeethercatlib/EtherCAT Sync SSC/SoE Upload | R2023a+ | Read parameters from a SERCOS-over-EtherCAT subdevice synchronously |
| Get SubDevice State | slrealtimeethercatlib/Get SubDevice State | R2024a+ | Read the current state of a specific EtherCAT subdevice |
| Set SubDevice State | slrealtimeethercatlib/Set SubDevice State | R2024a+ | Command a specific EtherCAT subdevice to transition to a new state |
