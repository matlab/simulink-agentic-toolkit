---
type: Simulink Block Category
title: Streaming
description: Packet and stream-based data exchange (7 blocks)
tags: [toolbox-kb, simulink-desktop-real-time, packet, stream, video, raw, binary]
status: stable
sources:
  - resource: matlab:sldrtlib
source: toolbox_kb
managed_by: satk
library: Simulink Desktop Real-Time
kb_folder: simulink-desktop-real-time
category: streaming
block_count: 7
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:31Z" }
---

# Streaming

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Other Input | sldrtlib/Other Input | R2023a+ | Read vendor-specific input channels — use for accessing custom or non-standard DAQ hardware inputs |
| Other Output | sldrtlib/Other Output | R2023a+ | Write vendor-specific output channels — use for accessing custom or non-standard DAQ hardware outputs |
| Packet Input | sldrtlib/Packet Input | R2023a+ | Receive raw data packets from hardware — use for reading structured binary data from custom I/O devices in real time |
| Packet Output | sldrtlib/Packet Output | R2023a+ | Send raw data packets to hardware — use for transmitting structured binary commands to custom I/O devices in real time |
| Stream Input | sldrtlib/Stream Input | R2023a+ | Receive streaming data from hardware — use for continuous data acquisition from serial or network devices in real time |
| Stream Output | sldrtlib/Stream Output | R2023a+ | Send streaming data to hardware — use for continuous data output to serial or network devices in real time |
| Video Input | sldrtlib/Video Input | R2023a+ | Capture video frames from hardware in real time — use for real-time image acquisition from cameras or frame grabbers |
