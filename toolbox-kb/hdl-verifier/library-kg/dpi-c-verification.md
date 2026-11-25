---
type: Simulink Block Category
title: Dpi c verification
description: SystemVerilog DPI-C / UVM testbench components (2 blocks)
tags: [toolbox-kb, hdl-verifier, dpi-c, systemverilog, assertion, uvm, scoreboard]
status: stable
sources:
  - resource: matlab:dpiblklib
source: toolbox_kb
managed_by: satk
library: HDL Verifier
kb_folder: hdl-verifier
category: dpi-c-verification
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:23Z" }
---

# Dpi c verification

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Assertion | dpiblklib/Assertion | R2023a+ | Assert that the input signal is non-zero, erroring when it fails — becomes a native SystemVerilog assertion when generating a DPI-C component, for property checking in UVM testbenches. |
| Sequence Feedback | dpiblklib/Sequence Feedback | R2023a+ | Unit-delay feedback (initial condition 0) from the scoreboard back to the sequence in a UVM testbench — use to close the loop in DPI-C generated verification environments. |
