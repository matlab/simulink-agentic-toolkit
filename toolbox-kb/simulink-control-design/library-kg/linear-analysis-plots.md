---
type: Simulink Block Category
title: Linear analysis plots
description: Real-time linear analysis visualization
tags: [bode, nichols, pole-zero, step, singular, plot]
status: stable
source: mathworks_toolbox
library_root: Simulink Control Design
category_path: Linear analysis plots
block_count: 7
---

# Linear analysis plots

Use these blocks for linear analysis plots.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Trigger-Based  Operating Point Snapshot | slctrl_utilities/Trigger-Based  Operating Point Snapshot | R2023a+ | Capture operating point on a trigger event — use for recording trim conditions during simulation for later linearization |
| Bode Plot | slctrlblks/Linear Analysis Plots/Bode Plot | R2023a+ | Display Bode magnitude and phase during simulation — use for visualizing linearized open-loop frequency response |
| Gain and Phase Margin Plot | slctrlblks/Linear Analysis Plots/Gain and Phase Margin Plot | R2023a+ | Display gain and phase margins during simulation — use for monitoring loop stability margins in real time |
| Linear Step Response Plot | slctrlblks/Linear Analysis Plots/Linear Step Response Plot | R2023a+ | Display linearized step response during simulation — use for checking closed-loop transient performance |
| Nichols Plot | slctrlblks/Linear Analysis Plots/Nichols Plot | R2023a+ | Display Nichols chart during simulation — use for visualizing open-loop gain-phase relationship |
| Pole-Zero Plot | slctrlblks/Linear Analysis Plots/Pole-Zero Plot | R2023a+ | Display pole-zero map during simulation — use for monitoring system stability and dynamics |
| Singular Value Plot | slctrlblks/Linear Analysis Plots/Singular Value Plot | R2023a+ | Display singular values during simulation — use for analyzing MIMO system gain across frequency |
