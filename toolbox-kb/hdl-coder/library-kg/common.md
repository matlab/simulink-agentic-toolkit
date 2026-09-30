---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 30
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Output a constant value — use for fixed parameters, thresholds, or test inputs. | Constant | HDL Coder |
| Convert a signal to a specified data type — use to set integer/fixed-point type and scaling. | Data Type Conversion | HDL Coder |
| Delay a signal by a specified number of samples — use for timing alignment or algorithmic state. | Delay | HDL Coder |
| Scale a signal by a constant factor — use for unit conversion, controller gains, or applying physical constants. | Gain | HDL Coder |
| Multiply and optionally divide inputs — use for scaling, products, and element-wise multiplication. | Product | HDL Coder |
| Add or subtract inputs — use for summing signals and forming error terms. | Sum | HDL Coder |
| Pass one of two inputs based on a control condition — use for conditional signal selection. | Switch | HDL Coder |
| Delay a signal by a specified number of samples — use for timing alignment or algorithmic state. | Delay | HDL Coder |
| Apply an FIR filter with given coefficients — use for linear-phase digital filtering. | Discrete FIR Filter | HDL Coder |
| Delay a signal by one sample period — use to introduce one-step state or break algebraic loops. | Unit Delay | HDL Coder |
| Convert a signal to a specified data type — use to set integer/fixed-point type and scaling. | Data Type Conversion | HDL Coder |
| Apply an FIR filter with given coefficients — use for linear-phase digital filtering. | Discrete FIR Filter | HDL Coder |
| Scale a signal by a constant factor — use for unit conversion, controller gains, or applying physical constants. | Gain | HDL Coder |
| Multiply and optionally divide inputs — use for scaling, products, and element-wise multiplication. | Product | HDL Coder |
| Apply a logical operation (AND, OR, NOT, XOR, …) to boolean inputs — use for combining conditions. | Logical Operator | HDL Coder |
| Scale a signal by a constant factor — use for unit conversion, controller gains, or applying physical constants. | Gain | HDL Coder |
| Multiply and optionally divide inputs — use for scaling, products, and element-wise multiplication. | Product | HDL Coder |
| Add or subtract inputs — use for summing signals and forming error terms. | Sum | HDL Coder |
| Convert a signal to a specified data type — use to set integer/fixed-point type and scaling. | Data Type Conversion | HDL Coder |
| Pass one of two inputs based on a control condition — use for conditional signal selection. | Switch | HDL Coder |
| Output a constant value — use for fixed parameters, thresholds, or test inputs. | Constant | HDL Coder |
| Run custom MATLAB code as a block — use for algorithms not easily built from blocks. | MATLAB Function | HDL Coder |
| Model mechanical play/hysteresis where output lags input within a dead band — use for gear backlash effects. | Backlash | HDL Coder |
| Model friction as a Coulomb offset plus a velocity-proportional viscous term — use for mechanical friction. | Coulomb & Viscous Friction | HDL Coder |
| Output zero within a fixed dead band and offset outside it — use to model insensitivity or thresholds. | Dead Zone | HDL Coder |
| Dead zone with runtime-variable band limits — use for adjustable insensitivity thresholds. | Dead Zone Dynamic | HDL Coder |
| Detect when a signal crosses a specified value — use to flag threshold-crossing events. | Hit  Crossing | HDL Coder |
| Normally, Delay scalar signal multiple sample periods and output all delayed versions. When the enable signal is false, the block is disabled, and the state and output values do not change. When the reset signal R is true, the state and the output are always set equal to the initial condition parameter. This block exhibits hardware-friendly reset behavior. | Tapped Delay Enabled Resettable Synchronous | HDL Coder |
| Normally, Delay scalar signal multiple sample periods and output all delayed versions. When the enable signal is false, the block is disabled, and the state and output values do not change. | Tapped Delay Enabled Synchronous | HDL Coder |
| Normally, Delay scalar signal multiple sample periods and output all delayed versions. When the reset signal R is true, the state and the output are always set equal to the initial condition parameter. This block exhibits hardware-friendly reset behavior. | Tapped Delay Resettable Synchronous | HDL Coder |
