---
type: Simulink Block Category
title: Discrete
description: Discrete-time dynamics, delays, and filters
tags: [discrete, delay, integrator, transfer function, filter, memory]
status: stable
source: custom_library
library_root: HDL Coder
category_path: Discrete
block_count: 24
---

# Discrete

Use these blocks for discrete.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Delay | hdlsllib/Commonly
Used Blocks/Delay | R2023a+ | Delay a signal by a specified number of samples — use for timing alignment or algorithmic state. |
| Delay | hdlsllib/Discrete/Delay | R2023a+ | Delay a signal by a specified number of samples — use for timing alignment or algorithmic state. |
| Discrete Transfer Fcn | hdlsllib/Discrete/Discrete Transfer Fcn | R2023a+ | Implement a discrete transfer function from numerator/denominator coefficients — use for IIR dynamics. |
| Discrete FIR Filter | hdlsllib/Discrete/Discrete FIR Filter | R2023a+ | Apply an FIR filter with given coefficients — use for linear-phase digital filtering. |
| Discrete PID Controller | hdlsllib/Discrete/Discrete PID Controller | R2023a+ | Discrete-time PID controller with anti-windup and tuning — use for closed-loop feedback control. |
| Discrete-Time Integrator | hdlsllib/Discrete/Discrete-Time Integrator | R2023a+ | Accumulate the input over discrete time with reset/limit options — use for discrete integration. |
| Enabled Delay | hdlsllib/Discrete/Enabled Delay | R2023a+ | Delay that updates only while enabled — use for gated or state-held delays. |
| Enabled Resettable Delay | hdlsllib/Discrete/Enabled Resettable Delay | R2023a+ | Delay that updates while enabled and clears on reset — use for gated delays with reset. |
| Memory | hdlsllib/Discrete/Memory | R2023a+ | Hold the input from the previous major time step — use to break algebraic loops or store one-step state. |
| Resettable Delay | hdlsllib/Discrete/Resettable Delay | R2023a+ | Delay that clears its state on a reset signal — use for restartable delays. |
| Tapped Delay | hdlsllib/Discrete/Tapped Delay | R2023a+ | Output a vector of successively delayed samples — use to form delay lines for filters. |
| Unit Delay | hdlsllib/Discrete/Unit Delay | R2023a+ | Delay a signal by one sample period — use to introduce one-step state or break algebraic loops. |
| Zero-Order Hold | hdlsllib/Discrete/Zero-Order Hold | R2023a+ | Hold each sample constant over the sample period — use to convert continuous to discrete or set a sample rate. |
| Tapped Delay Enabled Resettable Synchronous | hdlsllib/Discrete/Tapped Delay Enabled Resettable Synchronous | R2023a+ | Normally, Delay scalar signal multiple sample periods and output all delayed versions. When the enable signal is false, the block is disabled, and the state and output values do not change. When the reset signal R is true, the state and the output are always set equal to the initial condition parameter. This block exhibits hardware-friendly reset behavior. |
| Tapped Delay Enabled Synchronous | hdlsllib/Discrete/Tapped Delay Enabled Synchronous | R2023a+ | Normally, Delay scalar signal multiple sample periods and output all delayed versions. When the enable signal is false, the block is disabled, and the state and output values do not change. |
| Tapped Delay Resettable Synchronous | hdlsllib/Discrete/Tapped Delay Resettable Synchronous | R2023a+ | Normally, Delay scalar signal multiple sample periods and output all delayed versions. When the reset signal R is true, the state and the output are always set equal to the initial condition parameter. This block exhibits hardware-friendly reset behavior. |
| Unit Delay Enabled Resettable Synchronous | hdlsllib/Discrete/Unit Delay Enabled Resettable Synchronous | R2023a+ | Normally, the output is the signal u delayed by one sample period. When the enable signal is false, the block is disabled, and the state and output values do not change. The enable action only supports scalar inputs. Scalar expansion is used for the enable action when the signal u is a vector. When the reset signal R is true, the state and the output are always set equal to the initial condition parameter. This block exhibits hardware-friendly reset behavior. This reset action only supports scalar inputs. Scalar expansion is used for this reset action when the signal u is a vector. |
| Unit Delay Enabled Synchronous | hdlsllib/Discrete/Unit Delay Enabled Synchronous | R2023a+ | Normally, the output is the signal u delayed by one sample period. When the enable signal is false, the block is disabled, and the state and output values do not change. The enable action only supports scalar inputs. Scalar expansion is used for the enable action when the signal u is a vector. |
| Unit Delay Resettable Synchronous | hdlsllib/Discrete/Unit Delay Resettable Synchronous | R2023a+ | Normally, the output is the signal u delayed by one sample period. When the reset signal R is true, the state and the output are always set equal to the initial condition parameter. This block exhibits hardware-friendly reset behavior. This reset action only supports scalar inputs. Scalar expansion is used for this reset action when the signal u is a vector. |
| Discrete Transfer Fcn | hdlsllib/HDL Floating Point Operations/Discrete Transfer Fcn | R2023a+ | Implement a discrete transfer function from numerator/denominator coefficients — use for IIR dynamics. |
| Discrete FIR Filter | hdlsllib/HDL Floating Point Operations/Discrete FIR Filter | R2023a+ | Apply an FIR filter with given coefficients — use for linear-phase digital filtering. |
| Discrete PID Controller | hdlsllib/HDL Floating Point Operations/Discrete PID Controller | R2023a+ | Discrete-time PID controller with anti-windup and tuning — use for closed-loop feedback control. |
| Discrete-Time Integrator | hdlsllib/HDL Floating Point Operations/Discrete-Time Integrator | R2023a+ | Accumulate the input over discrete time with reset/limit options — use for discrete integration. |
| Repeating
Sequence
Stair | hdlsllib/Sources/Repeating
Sequence
Stair | R2023a+ | Discrete time sequence is output, then repeated. |
