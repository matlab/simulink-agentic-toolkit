---
type: Simulink Block Category
title: Sdr radio io
description: Transmit and receive baseband IQ through USRP E3xx software-defined radio hardware
tags: [e3xx, receiver, transmitter, usrp, radio]
status: stable
source: custom_library
library_root: Communications Toolbox Support Package for USRP Embedded Series Radio
category_path: Sdr radio io
block_count: 2
---

# Sdr radio io

Use these blocks for sdr radio io.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| E3xx Receiver | e3xxlib/E3xx Receiver | R2023a+ | Receive baseband IQ samples from a USRP E3xx-series software-defined radio deployed on the embedded target — use as the RF capture source when running or deploying SDR receive algorithms on E3xx hardware. |
| E3xx Transmitter | e3xxlib/E3xx Transmitter | R2023a+ | Transmit baseband IQ samples through a USRP E3xx-series software-defined radio on the embedded target — use as the RF output sink when running or deploying SDR transmit algorithms on E3xx hardware. |
