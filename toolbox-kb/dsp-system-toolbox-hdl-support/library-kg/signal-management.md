---
type: Simulink Block Category
title: Signal management
description: Reshape, type conversion, and element selection
tags: [signal management, convert, data type, selector, complexity]
status: stable
source: custom_library
library_root: DSP System Toolbox HDL Support
category_path: Signal management
block_count: 6
---

# Signal management

Use these blocks for signal management.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Convert 1-D to 2-D | dsphdlsupportsigmgmt/Convert 1-D to 2-D | R2023a+ | Reshape a 1-D signal into a 2-D matrix of specified dimensions — use to form frames or images from a sample stream. |
| Data Type  Conversion | dsphdlsupportsigmgmt/Data Type  Conversion | R2023a+ | Convert a signal to a specified data type — use to set fixed-point word length and scaling for HDL-friendly arithmetic. |
| Inherit Complexity | dsphdlsupportsigmgmt/Inherit Complexity | R2023a+ | Force a signal's complexity (real/complex) to match a reference input — use to resolve complexity mismatches in a model. |
| Multiport Selector | dsphdlsupportsigmgmt/Multiport Selector | R2023a+ | Split an input into several outputs by selecting specified rows/columns — use to route subsets of a vector or matrix signal. |
| Selector | dsphdlsupportsigmgmt/Selector | R2023a+ | Select a subset of elements from a signal by index — use to extract specific channels or samples. |
| Variable Selector | dsphdlsupportsigmgmt/Variable Selector | R2023a+ | Select rows/columns from a signal using a runtime index input — use for dynamic element selection. |
