---
type: Simulink Block Category
title: Network
description: Network communication and IoT connectivity (3 blocks)
tags: [toolbox-kb, embedded-coder-support-package-for-beaglebone-black-hardware, udp, thingspeak, network, iot, send]
status: stable
sources:
  - resource: matlab:beaglebonelib
source: toolbox_kb
managed_by: satk
library: Embedded Coder Support Package for BeagleBone Black Hardware
kb_folder: embedded-coder-support-package-for-beaglebone-black-hardware
category: network
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:20Z" }
---

# Network

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ThingSpeak Write | beaglebonelib/ThingSpeak Write | R2023a+ | Upload data to ThingSpeak IoT platform — use for cloud logging of sensor data or remote monitoring from the BeagleBone Black |
| UDP Receive | beaglebonelib/UDP Receive | R2023a+ | Receive UDP packets on BeagleBone Black — use for real-time data reception from other devices on the network |
| UDP Send | beaglebonelib/UDP Send | R2023a+ | Send UDP packets from BeagleBone Black — use for transmitting sensor data or status to other devices on the network |
