---
type: Simulink Block Category
title: Sdr radio io
description: Transmit and receive baseband IQ through USRP E3xx software-defined radio hardware (2 blocks)
tags: [toolbox-kb, communications-toolbox-support-package-for-usrp-embedded-series-radio, e3xx, receiver, transmitter, usrp, radio]
status: stable
sources:
  - resource: matlab:e3xxlib
source: toolbox_kb
managed_by: satk
library: Communications Toolbox Support Package for USRP Embedded Series Radio
kb_folder: communications-toolbox-support-package-for-usrp-embedded-series-radio
category: sdr-radio-io
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:35Z" }
---

# Sdr radio io

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| E3xx Receiver | e3xxlib/E3xx Receiver | R2023a+ | Receive baseband IQ samples from a USRP E3xx-series software-defined radio deployed on the embedded target — use as the RF capture source when running or deploying SDR receive algorithms on E3xx hardware. |
| E3xx Transmitter | e3xxlib/E3xx Transmitter | R2023a+ | Transmit baseband IQ samples through a USRP E3xx-series software-defined radio on the embedded target — use as the RF output sink when running or deploying SDR transmit algorithms on E3xx hardware. |
