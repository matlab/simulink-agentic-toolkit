---
type: Simulink Block Category
title: Interleaving
description: Interleavers/deinterleavers that spread burst errors (4 blocks)
tags: [toolbox-kb, communications-toolbox-hdl-support, interleaving, interleaver, deinterleaver]
status: stable
sources:
  - resource: matlab:commhdlinterleave
source: toolbox_kb
managed_by: satk
library: Communications Toolbox HDL Support
kb_folder: communications-toolbox-hdl-support
category: interleaving
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:16Z" }
---

# Interleaving

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Convolutional Deinterleaver | commhdlinterleave/Convolutional Deinterleaver | R2023a+ | Restore original symbol order after convolutional interleaving — use at the receiver to undo burst-error spreading. |
| Convolutional Interleaver | commhdlinterleave/Convolutional Interleaver | R2023a+ | Permute symbols with a convolutional interleaver to spread burst errors — use at the transmitter to strengthen FEC against bursts. |
| General Multiplexed Deinterleaver | commhdlinterleave/General Multiplexed Deinterleaver | R2023a+ | Undo a general multiplexed interleaver using per-branch delays — use to restore symbol order at the receiver. |
| General Multiplexed Interleaver | commhdlinterleave/General Multiplexed Interleaver | R2023a+ | Interleave symbols across branches with configurable delays — use to protect a stream against burst errors. |
