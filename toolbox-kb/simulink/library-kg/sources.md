---
type: Simulink Block Category
title: Sources
description: Signal generators, clocks, and constant sources
tags: [source, constant, sine, pulse, clock, random, step, from file]
status: stable
source: custom_library
library_root: Simulink
category_path: Sources
block_count: 29
---

# Sources

Use these blocks for sources.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Constant | simulink/Commonly
Used Blocks/Constant | R2023a+ | Output a constant value — use for fixed parameters, thresholds, or test inputs. |
| Ground | simulink/Commonly
Used Blocks/Ground | R2023a+ | Terminate an unconnected input with a zero value — use to ground unused inputs cleanly. |
| Continuous Pulse Generator | simulink/Quick Insert/Sources/Continuous Pulse Generator | R2023a+ | Generate a periodic pulse train in continuous time — use as a continuous-time pulse stimulus. |
| Discrete Pulse Generator | simulink/Quick Insert/Sources/Discrete Pulse Generator | R2023a+ | Generate a periodic pulse train at a sample rate — use as a discrete pulse stimulus. |
| Eulers Number | simulink/Quick Insert/Sources/Eulers Number | R2023a+ | Output the constant e (Euler's number) — use as a math constant source. |
| Inf | simulink/Quick Insert/Sources/Inf | R2023a+ | Output positive infinity — use as an unbounded limit constant. |
| NaN | simulink/Quick Insert/Sources/NaN | R2023a+ | Output NaN (not-a-number) — use to represent an undefined/invalid constant. |
| Negative Inf | simulink/Quick Insert/Sources/Negative Inf | R2023a+ | Output negative infinity — use as an unbounded lower-limit constant. |
| One | simulink/Quick Insert/Sources/One | R2023a+ | Output the constant 1 — use as a unit constant source. |
| Pi | simulink/Quick Insert/Sources/Pi | R2023a+ | Output the constant pi — use as a math constant source. |
| Sawtooth Generator | simulink/Quick Insert/Sources/Sawtooth Generator | R2023a+ | Generate a sawtooth waveform — use as a ramp/sweep stimulus. |
| Square Wave Generator | simulink/Quick Insert/Sources/Square Wave Generator | R2023a+ | Generate a square waveform — use as a square-wave stimulus. |
| Zero | simulink/Quick Insert/Sources/Zero | R2023a+ | Output the constant 0 — use as a zero constant source. |
| Clock | simulink/Sources/Clock | R2023a+ | Output the current continuous simulation time — use to drive time-dependent behavior. |
| Constant | simulink/Sources/Constant | R2023a+ | Output a constant value — use for fixed parameters, thresholds, or test inputs. |
| Digital Clock | simulink/Sources/Digital Clock | R2023a+ | Output the simulation time sampled at a fixed rate — use as a discrete time source. |
| Enumerated
Constant | simulink/Sources/Enumerated
Constant | R2023a+ | Output a constant enumerated value — use to emit a fixed enum literal. |
| From
Workspace | simulink/Sources/From
Workspace | R2023a+ | Read time-series data from a workspace variable as a source — use to replay recorded/base-workspace data. |
| From File | simulink/Sources/From File | R2023a+ | Read time-series data from a MAT-file as a source — use to replay logged data from disk. |
| From Spreadsheet | simulink/Sources/From Spreadsheet | R2023a+ | Read signal data from a spreadsheet file as a source — use to feed tabular data into a model. |
| Ground | simulink/Sources/Ground | R2023a+ | Terminate an unconnected input with a zero value — use to ground unused inputs cleanly. |
| Playback | simulink/Sources/Playback | R2023a+ | Play back recorded data (e.g., from the Simulation Data Inspector) as a source — use to replay captured signals. |
| Pulse
Generator | simulink/Sources/Pulse
Generator | R2023a+ | Generate a periodic pulse train — use as a clock, trigger, or on/off stimulus. |
| Random
Number | simulink/Sources/Random
Number | R2023a+ | Generate normally-distributed random numbers — use as Gaussian noise or a random stimulus. |
| Signal
Generator | simulink/Sources/Signal
Generator | R2023a+ | Generate a selectable waveform (sine, square, sawtooth, random) — use as an adjustable test stimulus. |
| Sine Wave | simulink/Sources/Sine Wave | R2023a+ | Generate a sine waveform with set amplitude, frequency, and phase — use as a periodic test stimulus. |
| Step | simulink/Sources/Step | R2023a+ | Generate a step change at a specified time — use to test step response. |
| Uniform Random
Number | simulink/Sources/Uniform Random
Number | R2023a+ | Generate uniformly-distributed random numbers — use as uniform noise or a random stimulus. |
| Waveform
Generator | simulink/Sources/Waveform
Generator | R2023a+ | Generate arbitrary waveforms from equations/keywords — use for flexible custom test signals. |
