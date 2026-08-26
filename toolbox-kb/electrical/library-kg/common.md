---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 23
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Implement a proportional-integral controller — use for current, voltage, speed, or position regulation loops in power electronics and drives | PI Controller (Discrete or Continuous) | Electrical |
| Transform three-phase abc quantities to stationary alpha-beta frame — use as the first stage in field-oriented control or space vector modulation | Clarke Transform | Electrical |
| Transform stationary alpha-beta quantities to synchronously rotating dq frame — use for decoupled torque and flux control in AC machine drives | Park Transform | Electrical |
| Implement complete field-oriented control for a PMSM — use as a ready-to-use FOC controller with speed loop, current loop, and coordinate transforms | PMSM Field-Oriented Control | Electrical |
| Generate three-phase PWM signals using carrier comparison or space vector modulation — use for standard three-phase inverter control | PWM Generator (Three-phase, Two-level) | Electrical |
| Define the electrical ground reference node — use as the zero-potential reference for every electrical circuit in the model | Electrical Reference | Electrical |
| Model a three-phase squirrel-cage induction machine — use for industrial motor drives, pump loads, or variable-frequency drive development | Induction Machine Squirrel Cage | Electrical |
| Model a three-phase permanent magnet synchronous machine — use for EV traction drives, servo motors, or high-performance variable-speed applications | PMSM | Electrical |
| Model an ideal or lossy capacitor — use for energy storage, filtering, coupling, decoupling, or any circuit requiring capacitive behavior | Capacitor | Electrical |
| Model an ideal or lossy inductor — use for filtering, energy storage, magnetic coupling, or any circuit requiring inductive behavior | Inductor | Electrical |
| Model an ideal or temperature-dependent resistor — use for any circuit element requiring resistance: loads, voltage dividers, current sensing, or damping | Resistor | Electrical |
| Model a standard three-phase two-winding transformer — use for power distribution, voltage transformation, or industrial supply modeling | Two-Winding Transformer (Three-Phase) | Electrical |
| Model a semiconductor diode with forward voltage drop and reverse recovery — use for rectifiers, freewheeling paths, voltage clamping, or protection circuits | Diode | Electrical |
| Model an N-channel IGBT with detailed switching and thermal characteristics — use for accurate loss estimation in high-power inverters, choppers, or motor drives | N-Channel IGBT | Electrical |
| Model an N-channel MOSFET with detailed characteristics — use for power converter switching devices, motor drive legs, or analog circuit design | N-Channel MOSFET | Electrical |
| Model a three-phase power converter with configurable switching devices — use for inverter, rectifier, or active front-end topologies with detailed switching | Converter (Three-Phase) | Electrical |
| Measure electrical current without inserting resistance — use for feedback control, protection, or monitoring in any circuit | Current Sensor | Electrical |
| Measure voltage across two electrical nodes without drawing current — use for monitoring, control feedback, or protection in any circuit | Voltage Sensor | Electrical |
| Model a battery with internal resistance and open-circuit voltage — use for EV powertrain, portable electronics, or energy storage system simulation | Battery | Electrical |
| Model an ideal or controlled current source — use for biasing, load representation, or signal injection in electrical circuits | Current Source | Electrical |
| Model a photovoltaic cell with irradiance and temperature dependent I-V characteristics — use for solar panel modeling, MPPT development, or PV system design | Solar Cell | Electrical |
| Model an ideal or controlled voltage source — use for power supplies, signal generators, or reference voltages in electrical circuits | Voltage Source | Electrical |
| Model a three-phase circuit breaker — use for power system protection, fault isolation, or recloser studies in transmission and distribution | Circuit Breaker (Three-Phase) | Electrical |
