---
type: Simulink Block Category
title: Streaming
description: Packet and stream-based data exchange
tags: [packet, stream, video, raw, binary]
status: stable
source: mathworks_toolbox
library_root: Simulink Desktop Real-Time
category_path: Streaming
block_count: 7
---

# Streaming

Use these blocks for streaming.

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
