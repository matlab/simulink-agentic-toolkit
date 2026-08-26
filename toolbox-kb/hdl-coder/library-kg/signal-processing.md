---
type: Simulink Block Category
title: Signal processing
description: Filters, serializers, lookup tables, and DSP operations for signal processing in HDL
tags: [FIR, lookup-table, serializer, CORDIC, DSP]
status: stable
source: mathworks_toolbox
library_root: HDL Coder
category_path: Signal processing
block_count: 11
---

# Signal processing

Use these blocks for signal processing.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Deserializer1D | hdlsllib/HDL Operations/Deserializer1D | R2023a+ | Use when you need to convert a serial data stream back into parallel vector form in HDL |
| Serializer1D | hdlsllib/HDL Operations/Serializer1D | R2023a+ | Use when you need to convert parallel vector data into a serial stream for HDL processing |
| Cosine HDL Optimized | hdlsllib/Lookup Tables/Cosine HDL Optimized | R2023a+ | Use when you need a lookup-table-based cosine optimized for HDL area and speed |
| 1-D Lookup Table | hdlsllib/Lookup Tables/1-D Lookup Table | R2023a+ | Use when you need one-dimensional nonlinear function approximation via table lookup in HDL |
| 2-D Lookup Table | hdlsllib/Lookup Tables/2-D Lookup Table | R2023a+ | Use when you need two-dimensional nonlinear function approximation via table lookup in HDL |
| Direct Lookup Table (n-D) | hdlsllib/Lookup Tables/Direct Lookup Table (n-D) | R2023a+ | Use when you need direct index-based table access without interpolation for n-dimensional data |
| Prelookup | hdlsllib/Lookup Tables/Prelookup | R2023a+ | Use when you need to compute table indices and fractions separately from interpolation |
| Sine HDL Optimized | hdlsllib/Lookup Tables/Sine HDL Optimized | R2023a+ | Use when you need a lookup-table-based sine optimized for HDL area and speed |
| n-D Lookup Table | hdlsllib/Lookup Tables/n-D Lookup Table | R2023a+ | Use when you need multi-dimensional interpolation table lookup for HDL code generation |
| PWM | hdlsllib/RCP and HIL/PWM | R2024b+ | Use when you need to generate a pulse-width modulated output signal in HDL |
| Sparse Matrix-Vector Product | hdlsllib/RCP and HIL/Sparse Matrix-Vector Product | R2023a+ | Use when you need efficient matrix-vector multiplication exploiting sparsity patterns in HDL |
