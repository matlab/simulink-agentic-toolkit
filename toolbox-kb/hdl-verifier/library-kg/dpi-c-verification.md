---
type: Simulink Block Category
title: Dpi c verification
description: SystemVerilog DPI-C / UVM testbench components
tags: [dpi-c, systemverilog, assertion, uvm, scoreboard]
status: stable
source: custom_library
library_root: HDL Verifier
category_path: Dpi c verification
block_count: 2
---

# Dpi c verification

Use these blocks for dpi c verification.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Assertion | dpiblklib/Assertion | R2023a+ | Assert that the input signal is non-zero, erroring when it fails — becomes a native SystemVerilog assertion when generating a DPI-C component, for property checking in UVM testbenches. |
| Sequence Feedback | dpiblklib/Sequence Feedback | R2023a+ | Unit-delay feedback (initial condition 0) from the scoreboard back to the sequence in a UVM testbench — use to close the loop in DPI-C generated verification environments. |
