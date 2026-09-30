---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 8
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Write a Value Change Dump (VCD) file recording changes on the connected input signals — use to export waveforms for viewing in an HDL waveform tool. | To VCD File | HDL Verifier |
| Cosimulate an HDL component in an external simulator (Vivado, Xcelium, or VCS) with the Simulink model — Simulink inputs drive the HDL signals and HDL outputs drive the block, for verifying RTL against a reference algorithm. | HDL Cosimulation | HDL Verifier |
| Write a Value Change Dump (VCD) file recording changes on the connected input signals — use to export waveforms for viewing in an HDL waveform tool. | To VCD File | HDL Verifier |
| Cosimulate an HDL component in an external simulator (Vivado, Xcelium, or VCS) with the Simulink model — Simulink inputs drive the HDL signals and HDL outputs drive the block, for verifying RTL against a reference algorithm. | HDL Cosimulation | HDL Verifier |
| Write a Value Change Dump (VCD) file recording changes on the connected input signals — use to export waveforms for viewing in an HDL waveform tool. | To VCD File | HDL Verifier |
| Cosimulate an HDL component in an external simulator (Vivado, Xcelium, or VCS) with the Simulink model — Simulink inputs drive the HDL signals and HDL outputs drive the block, for verifying RTL against a reference algorithm. | HDL Cosimulation | HDL Verifier |
| Assert that the input signal is non-zero, erroring when it fails — becomes a native SystemVerilog assertion when generating a DPI-C component, for property checking in UVM testbenches. | Assertion | HDL Verifier |
| Unit-delay feedback (initial condition 0) from the scoreboard back to the sequence in a UVM testbench — use to close the loop in DPI-C generated verification environments. | Sequence Feedback | HDL Verifier |
