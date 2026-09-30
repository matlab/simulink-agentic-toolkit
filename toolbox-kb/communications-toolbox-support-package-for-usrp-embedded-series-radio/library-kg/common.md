---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 3
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Receive baseband IQ samples from a USRP E3xx-series software-defined radio deployed on the embedded target — use as the RF capture source when running or deploying SDR receive algorithms on E3xx hardware. | E3xx Receiver | Communications Toolbox Support Package for USRP Embedded Series Radio |
| Transmit baseband IQ samples through a USRP E3xx-series software-defined radio on the embedded target — use as the RF output sink when running or deploying SDR transmit algorithms on E3xx hardware. | E3xx Transmitter | Communications Toolbox Support Package for USRP Embedded Series Radio |
| Informational block that links to the shipped USRP Embedded Series Radio example models — not part of a production design. | Info1 | Communications Toolbox Support Package for USRP Embedded Series Radio |
