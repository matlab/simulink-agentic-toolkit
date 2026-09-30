---
type: Simulink Block Category
title: Sdr transceiver
description: AD936x / FMCOMMS software-defined-radio front ends
tags: [ad936x, fmcomms, receiver, transmitter, data read, data write]
status: stable
source: custom_library
library_root: SoC Blockset Support Package for AMD FPGA and SoC Devices
category_path: Sdr transceiver
block_count: 18
---

# Sdr transceiver

Use these blocks for sdr transceiver.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| AD936x Data Read | mpsoczcu102lib/AD936x Data Read | R2024b+ | Read baseband IQ samples captured from an AD936x RF transceiver on the FPGA — use to bring received radio data into the model. |
| AD936x Data Write | mpsoczcu102lib/AD936x Data Write | R2024b+ | Write baseband IQ samples to an AD936x RF transceiver for transmission — use to send radio data from the model. |
| AD936x Receiver | mpsoczcu102lib/AD936x Receiver | R2024b+ | Receive RF through an AD936x transceiver and stream baseband IQ into the model — use as an SDR receive front end. |
| AD936x Transmitter | mpsoczcu102lib/AD936x Transmitter | R2024b+ | Transmit baseband IQ through an AD936x RF transceiver — use as an SDR transmit front end. |
| AD936x Data Read | zynq7000rfsomlib/AD936x Data Read | R2024b+ | Read baseband IQ samples captured from an AD936x RF transceiver on the FPGA — use to bring received radio data into the model. |
| AD936x Data Write | zynq7000rfsomlib/AD936x Data Write | R2024b+ | Write baseband IQ samples to an AD936x RF transceiver for transmission — use to send radio data from the model. |
| AD936x Receiver | zynq7000rfsomlib/AD936x Receiver | R2024b+ | Receive RF through an AD936x transceiver and stream baseband IQ into the model — use as an SDR receive front end. |
| AD936x Transmitter | zynq7000rfsomlib/AD936x Transmitter | R2024b+ | Transmit baseband IQ through an AD936x RF transceiver — use as an SDR transmit front end. |
| AD936x Data Read | zynq7000zc706lib/AD936x Data Read | R2024b+ | Read baseband IQ samples captured from an AD936x RF transceiver on the FPGA — use to bring received radio data into the model. |
| AD936x Data Write | zynq7000zc706lib/AD936x Data Write | R2024b+ | Write baseband IQ samples to an AD936x RF transceiver for transmission — use to send radio data from the model. |
| AD936x Receiver | zynq7000zc706lib/AD936x Receiver | R2024b+ | Receive RF through an AD936x transceiver and stream baseband IQ into the model — use as an SDR receive front end. |
| AD936x Transmitter | zynq7000zc706lib/AD936x Transmitter | R2024b+ | Transmit baseband IQ through an AD936x RF transceiver — use as an SDR transmit front end. |
| FMCOMMS5 Receiver | zynq7000zc706lib/FMCOMMS5 Receiver | R2023a+ | Receive RF through the four-channel FMCOMMS5 (dual AD9361) front end — use for multi-channel/coherent SDR receive. |
| FMCOMMS5 Transmitter | zynq7000zc706lib/FMCOMMS5 Transmitter | R2023a+ | Transmit RF through the four-channel FMCOMMS5 (dual AD9361) front end — use for multi-channel SDR transmit. |
| AD936x Data Read | zynq7000zedboardlib/AD936x Data Read | R2024b+ | Read baseband IQ samples captured from an AD936x RF transceiver on the FPGA — use to bring received radio data into the model. |
| AD936x Data Write | zynq7000zedboardlib/AD936x Data Write | R2024b+ | Write baseband IQ samples to an AD936x RF transceiver for transmission — use to send radio data from the model. |
| AD936x Receiver | zynq7000zedboardlib/AD936x Receiver | R2024b+ | Receive RF through an AD936x transceiver and stream baseband IQ into the model — use as an SDR receive front end. |
| AD936x Transmitter | zynq7000zedboardlib/AD936x Transmitter | R2024b+ | Transmit baseband IQ through an AD936x RF transceiver — use as an SDR transmit front end. |
