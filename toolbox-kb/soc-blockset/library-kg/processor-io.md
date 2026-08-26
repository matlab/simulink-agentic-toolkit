---
type: Simulink Block Category
title: Processor io
description: Processor-side read/write blocks for accessing hardware peripherals and network
tags: [read, write, TCP, UDP, register, processor]
status: stable
source: mathworks_toolbox
library_root: SoC Blockset
category_path: Processor io
block_count: 24
---

# Processor io

Use these blocks for processor io.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| UDP Read | hostiolib/UDP Read | R2023a+ | Receive UDP packets from the network for host-processor or inter-device communication |
| UDP Write | hostiolib/UDP Write | R2023a+ | Send UDP packets over the network from the processor or host |
| Reader | socmemlib/AXI4 Random Access Memory/SimVariant/Accurate/log/Reader | R2023a+ | Read data from a memory or buffer subsystem |
| Writer | socmemlib/AXI4 Random Access Memory/SimVariant/Accurate/log/Writer | R2023a+ | Write data to a memory or buffer subsystem |
| Reader | socmemlib/AXI4 Video Frame Buffer/SimVariant/Accurate/log/Reader | R2023a+ | Read data from a memory or buffer subsystem |
| Writer | socmemlib/AXI4 Video Frame Buffer/SimVariant/Accurate/log/Writer | R2023a+ | Write data to a memory or buffer subsystem |
| Reader | socmemlib/AXI4-Stream to Software/SimVariant/Accurate/log/Reader | R2023a+ | Read data from a memory or buffer subsystem |
| Writer | socmemlib/AXI4-Stream to Software/SimVariant/Accurate/log/Writer | R2023a+ | Write data to a memory or buffer subsystem |
| Reader | socmemlib/Software to AXI4-Stream/SimVariant/Accurate/log/Reader | R2023a+ | Read data from a memory or buffer subsystem |
| Writer | socmemlib/Software to AXI4-Stream/SimVariant/Accurate/log/Writer | R2023a+ | Write data to a memory or buffer subsystem |
| ADC Read | prociolib/ADC Read | R2023a+ | Read samples from the ADC peripheral in processor software |
| Audio Capture | prociolib/Audio Capture | R2023a+ | Capture audio samples from the audio input peripheral in processor software |
| Audio Playback | prociolib/Audio Playback | R2023a+ | Play audio samples through the audio output peripheral from processor software |
| PWM Write | prociolib/PWM Write | R2023a+ | Write duty cycle values to the PWM peripheral from processor software |
| Register Read | prociolib/Register Read | R2023a+ | Read a value from a memory-mapped hardware register in processor software |
| Register Write | prociolib/Register Write | R2023a+ | Write a value to a memory-mapped hardware register from processor software |
| Stream Read | prociolib/Stream Read | R2023a+ | Read streaming data from FPGA logic via DMA in processor software |
| Stream Write | prociolib/Stream Write | R2023a+ | Write streaming data to FPGA logic via DMA from processor software |
| TCP Read | prociolib/TCP Read | R2023a+ | Receive data over a TCP connection in processor software |
| TCP Write | prociolib/TCP Write | R2023a+ | Send data over a TCP connection from processor software |
| UDP Read | prociolib/UDP Read | R2023a+ | Receive UDP packets from the network for host-processor or inter-device communication |
| UDP Write | prociolib/UDP Write | R2023a+ | Send UDP packets over the network from the processor or host |
| Video Capture | prociolib/Video Capture | R2023a+ | Capture video frames from the camera peripheral in processor software |
| Video Display | prociolib/Video Display | R2023a+ | Display video frames on the output peripheral from processor software |
