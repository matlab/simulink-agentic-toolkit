---
type: Simulink Block Category
title: Spice components
description: SPICE-compatible components and dependent sources for netlist import
tags: [spice, pcccs, pvcvs, netlist, polynomial]
status: stable
source: mathworks_toolbox
library_root: Electrical
category_path: Spice components
block_count: 36
---

# Spice components

Use these blocks for spice components.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| SIMetrix Cosimulation Interface | ee_lib/Additional Components/Cosimulation/SIMetrix Cosimulation Interface | R2023a+ | Interface Simscape Electrical with SIMetrix SPICE simulator for co-simulation — use when existing SPICE netlists must run alongside Simscape models |
| Current-Controlled Switch | ee_lib/Additional Components/SPICE Passives/Current-Controlled Switch | R2023a+ | SPICE-compatible switch controlled by current through a sensing branch — use for SPICE netlist import or current-threshold switching |
| SPICE Resistor | ee_lib/Additional Components/SPICE Passives/SPICE Resistor | R2023a+ | SPICE-compatible resistor with temperature coefficient — use when importing SPICE netlists that require standard SPICE resistor semantics |
| Voltage-Controlled Switch | ee_lib/Additional Components/SPICE Passives/Voltage-Controlled Switch | R2023a+ | SPICE-compatible switch controlled by voltage across sensing nodes — use for SPICE netlist import or voltage-threshold switching |
| SPICE Diode | ee_lib/Additional Components/SPICE Semiconductors/SPICE Diode | R2023a+ | SPICE-compatible diode model with standard SPICE parameters — use for importing SPICE diode subcircuits or validating against SPICE reference simulations |
| SPICE NIGBT | ee_lib/Additional Components/SPICE Semiconductors/SPICE NIGBT | R2023a+ | SPICE-compatible N-channel IGBT model — use for importing SPICE IGBT subcircuits or cross-validating with SPICE tools |
| SPICE NJFET | ee_lib/Additional Components/SPICE Semiconductors/SPICE NJFET | R2023a+ | SPICE-compatible N-channel JFET model — use for importing SPICE JFET subcircuits or analog front-end modeling with SPICE parameters |
| SPICE NMOS | ee_lib/Additional Components/SPICE Semiconductors/SPICE NMOS | R2023a+ | SPICE-compatible N-channel MOSFET model — use for importing SPICE NMOS subcircuits or digital/analog IC modeling with SPICE parameters |
| SPICE NPN | ee_lib/Additional Components/SPICE Semiconductors/SPICE NPN | R2023a+ | SPICE-compatible NPN bipolar transistor model — use for importing SPICE BJT subcircuits or amplifier modeling with Gummel-Poon parameters |
| SPICE PJFET | ee_lib/Additional Components/SPICE Semiconductors/SPICE PJFET | R2023a+ | SPICE-compatible P-channel JFET model — use for importing SPICE PJFET subcircuits or complementary analog circuit modeling |
| SPICE PMOS | ee_lib/Additional Components/SPICE Semiconductors/SPICE PMOS | R2023a+ | SPICE-compatible P-channel MOSFET model — use for importing SPICE PMOS subcircuits or CMOS IC modeling with SPICE parameters |
| SPICE PNP | ee_lib/Additional Components/SPICE Semiconductors/SPICE PNP | R2023a+ | SPICE-compatible PNP bipolar transistor model — use for importing SPICE PNP subcircuits or complementary amplifier modeling |
| DC Current Source | ee_lib/Additional Components/SPICE Sources/DC Current Source | R2023a+ | SPICE-compatible DC current source — use in imported SPICE netlists or mixed-mode simulation requiring SPICE source semantics |
| DC Voltage Source | ee_lib/Additional Components/SPICE Sources/DC Voltage Source | R2023a+ | SPICE-compatible DC voltage source — use in imported SPICE netlists or mixed-mode simulation requiring SPICE source semantics |
| Exponential Current Source | ee_lib/Additional Components/SPICE Sources/Exponential Current Source | R2023a+ | SPICE-compatible current source with exponential waveform — use for modeling charge/discharge transients in SPICE-originated circuits |
| Exponential Voltage Source | ee_lib/Additional Components/SPICE Sources/Exponential Voltage Source | R2023a+ | SPICE-compatible voltage source with exponential waveform — use for step-response testing with exponential rise/fall in SPICE circuits |
| PCCCS | ee_lib/Additional Components/SPICE Sources/PCCCS | R2023a+ | Polynomial current-controlled current source — use for nonlinear dependent sources in analog IC modeling or SPICE behavioral circuits |
| PCCCS2 | ee_lib/Additional Components/SPICE Sources/PCCCS2 | R2023a+ | Two-input polynomial current-controlled current source — use for multi-variable nonlinear current dependencies in SPICE-style models |
| PCCVS | ee_lib/Additional Components/SPICE Sources/PCCVS | R2023a+ | Polynomial current-controlled voltage source — use for nonlinear transimpedance relationships in analog circuit modeling |
| PCCVS2 | ee_lib/Additional Components/SPICE Sources/PCCVS2 | R2023a+ | Two-input polynomial current-controlled voltage source — use for multi-variable nonlinear transimpedance in SPICE-style models |
| PVCCS | ee_lib/Additional Components/SPICE Sources/PVCCS | R2023a+ | Polynomial voltage-controlled current source — use for nonlinear transconductance in analog IC modeling or SPICE behavioral circuits |
| PVCCS2 | ee_lib/Additional Components/SPICE Sources/PVCCS2 | R2023a+ | Two-input polynomial voltage-controlled current source — use for multi-variable nonlinear transconductance in SPICE-style models |
| PVCVS | ee_lib/Additional Components/SPICE Sources/PVCVS | R2023a+ | Polynomial voltage-controlled voltage source — use for nonlinear voltage gain relationships in analog circuit modeling |
| PVCVS2 | ee_lib/Additional Components/SPICE Sources/PVCVS2 | R2023a+ | Two-input polynomial voltage-controlled voltage source — use for multi-variable nonlinear voltage dependencies in SPICE-style models |
| Piecewise Linear Current Source | ee_lib/Additional Components/SPICE Sources/Piecewise Linear Current Source | R2023a+ | Current source with piecewise linear waveform — use for arbitrary current profiles defined by time-value breakpoints |
| Piecewise Linear Voltage Source | ee_lib/Additional Components/SPICE Sources/Piecewise Linear Voltage Source | R2023a+ | Voltage source with piecewise linear waveform — use for arbitrary voltage profiles defined by time-value breakpoints |
| Pulse Current Source | ee_lib/Additional Components/SPICE Sources/Pulse Current Source | R2023a+ | Pulsed current source with configurable rise/fall and period — use for periodic current pulse trains or transient testing |
| Pulse Voltage Source | ee_lib/Additional Components/SPICE Sources/Pulse Voltage Source | R2023a+ | Pulsed voltage source with configurable rise/fall and period — use for periodic voltage pulse trains or transient testing |
| SFFM Current Source | ee_lib/Additional Components/SPICE Sources/SFFM Current Source | R2023a+ | Single-frequency FM current source — use for frequency-modulated current excitation in circuit analyses |
| SFFM Voltage Source | ee_lib/Additional Components/SPICE Sources/SFFM Voltage Source | R2023a+ | Single-frequency FM voltage source — use for frequency-modulated voltage excitation in circuit analyses |
| Sinusoidal Current Source | ee_lib/Additional Components/SPICE Sources/Sinusoidal Current Source | R2023a+ | Sinusoidal current source with SPICE-compatible parameters — use for AC current excitation in SPICE-imported circuits |
| Sinusoidal Voltage Source | ee_lib/Additional Components/SPICE Sources/Sinusoidal Voltage Source | R2023a+ | Sinusoidal voltage source with SPICE-compatible parameters — use for AC voltage excitation in SPICE-imported circuits |
| Piecewise Linear Current Source | ee_lib/Sources/Piecewise Linear Current Source | R2023a+ | Current source with piecewise linear waveform — use for arbitrary current profiles defined by time-value breakpoints |
| Piecewise Linear Voltage Source | ee_lib/Sources/Piecewise Linear Voltage Source | R2023a+ | Voltage source with piecewise linear waveform — use for arbitrary voltage profiles defined by time-value breakpoints |
| Pulse Current Source | ee_lib/Sources/Pulse Current Source | R2023a+ | Pulsed current source with configurable rise/fall and period — use for periodic current pulse trains or transient testing |
| Pulse Voltage Source | ee_lib/Sources/Pulse Voltage Source | R2023a+ | Pulsed voltage source with configurable rise/fall and period — use for periodic voltage pulse trains or transient testing |
