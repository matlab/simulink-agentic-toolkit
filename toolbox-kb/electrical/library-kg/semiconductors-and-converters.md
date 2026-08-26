---
type: Simulink Block Category
title: Semiconductors and converters
description: Diodes, transistors, power converters, and switching devices
tags: [diode, mosfet, igbt, converter, rectifier]
status: stable
source: mathworks_toolbox
library_root: Electrical
category_path: Semiconductors and converters
block_count: 52
---

# Semiconductors and converters

Use these blocks for semiconductors and converters.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| SPICE-Imported MOSFET | ee_lib/Semiconductors & Converters/SPICE-Imported MOSFET | R2023a+ | Model a MOSFET imported from SPICE model data — use when manufacturer SPICE models must be used directly for accuracy validation |
| Semiconductor Switch Selector | ee_lib/Semiconductors & Converters/Semiconductor Switch Selector | R2023a+ | Configure the switch type used in converter blocks — use to globally change between ideal, IGBT, or MOSFET switches across a power electronics model |
| Current Limiter | ee_lib/Semiconductors & Converters/Current Limiter | R2023a+ | Model a current-limiting device that clamps current to a maximum value — use for protection circuits, inrush limiting, or fault current reduction |
| Diode | ee_lib/Semiconductors & Converters/Diode | R2023a+ | Model a semiconductor diode with forward voltage drop and reverse recovery — use for rectifiers, freewheeling paths, voltage clamping, or protection circuits |
| GTO | ee_lib/Semiconductors & Converters/GTO | R2023a+ | Model a gate turn-off thyristor — use for high-power converter applications, traction drives, or HVDC systems requiring turn-off capability |
| Gate Driver | ee_lib/Semiconductors & Converters/Gate Driver | R2023a+ | Model a gate driver circuit providing proper drive signals to power semiconductor switches — use for realistic IGBT or MOSFET driving with delays and levels |
| Half-Bridge (Ideal, Switching) | ee_lib/Semiconductors & Converters/Half-Bridge (Ideal, Switching) | R2023a+ | Model an ideal switching half-bridge leg — use as a building block for multi-phase converters or when ideal switch behavior is sufficient |
| Half-Bridge Driver | ee_lib/Semiconductors & Converters/Half-Bridge Driver | R2023a+ | Model a half-bridge gate driver with high-side and low-side outputs — use for driving half-bridge legs with proper dead-time and level shifting |
| IGBT (Ideal, Switching) | ee_lib/Semiconductors & Converters/IGBT (Ideal, Switching) | R2023a+ | Model an ideal IGBT with on-state voltage drop and switching transitions — use for converter topologies where conduction loss matters but detailed physics does not |
| Ideal Semiconductor Switch | ee_lib/Semiconductors & Converters/Ideal Semiconductor Switch | R2023a+ | Model a generic ideal power switch — use for topology exploration where device-specific characteristics are not yet defined |
| MOSFET (Ideal, Switching) | ee_lib/Semiconductors & Converters/MOSFET (Ideal, Switching) | R2023a+ | Model an ideal MOSFET with on-resistance and body diode — use for converter simulations where basic conduction loss is needed without detailed device physics |
| N-Channel IGBT | ee_lib/Semiconductors & Converters/N-Channel IGBT | R2023a+ | Model an N-channel IGBT with detailed switching and thermal characteristics — use for accurate loss estimation in high-power inverters, choppers, or motor drives |
| N-Channel JFET | ee_lib/Semiconductors & Converters/N-Channel JFET | R2023a+ | Model an N-channel junction FET — use for low-noise analog front-ends, current sources, or voltage-controlled resistors in signal conditioning |
| N-Channel LDMOS FET | ee_lib/Semiconductors & Converters/N-Channel LDMOS FET | R2023a+ | Model an N-channel laterally diffused MOSFET — use for RF power amplifiers, high-voltage gate drivers, or automotive smart-power ICs |
| N-Channel MOSFET | ee_lib/Semiconductors & Converters/N-Channel MOSFET | R2023a+ | Model an N-channel MOSFET with detailed characteristics — use for power converter switching devices, motor drive legs, or analog circuit design |
| NMOS Capacitor | ee_lib/Semiconductors & Converters/NMOS Capacitor | R2023a+ | Model an NMOS gate capacitance structure — use for studying charge pump behavior, gate oxide capacitance, or MOS varactor tuning |
| NPN Bipolar Transistor | ee_lib/Semiconductors & Converters/NPN Bipolar Transistor | R2023a+ | Model an NPN BJT with detailed DC and AC characteristics — use for analog amplifiers, current mirrors, switching circuits, or discrete logic |
| Optocoupler | ee_lib/Semiconductors & Converters/Optocoupler | R2023a+ | Model an optocoupler providing galvanic isolation between circuits — use for isolated feedback in power supplies, safety barriers, or isolated gate drive signals |
| P-Channel JFET | ee_lib/Semiconductors & Converters/P-Channel JFET | R2023a+ | Model a P-channel junction FET — use for complementary analog circuits, current sources, or high-impedance input stages |
| P-Channel LDMOS FET | ee_lib/Semiconductors & Converters/P-Channel LDMOS FET | R2023a+ | Model a P-channel laterally diffused MOSFET — use for complementary high-voltage drivers or P-side high-side switches |
| P-Channel MOSFET | ee_lib/Semiconductors & Converters/P-Channel MOSFET | R2023a+ | Model a P-channel MOSFET — use for high-side switches, complementary output stages, or load switches in power management |
| PMOS Capacitor | ee_lib/Semiconductors & Converters/PMOS Capacitor | R2023a+ | Model a PMOS gate capacitance structure — use for charge pump circuits, MOS varactors, or PMOS-based voltage tuning elements |
| PNP Bipolar Transistor | ee_lib/Semiconductors & Converters/PNP Bipolar Transistor | R2023a+ | Model a PNP BJT with detailed DC and AC characteristics — use for complementary amplifiers, current sources, or level-shifting circuits |
| Thyristor | ee_lib/Semiconductors & Converters/Thyristor | R2023a+ | Model a silicon-controlled rectifier with gate triggering and natural commutation — use for controlled rectifiers, AC voltage controllers, or legacy power converters |
| Thyristor (Piecewise Linear) | ee_lib/Semiconductors & Converters/Thyristor (Piecewise Linear) | R2023a+ | Model a thyristor with simplified piecewise linear characteristics — use for faster simulation of large thyristor-based systems |
| AC-DC Converter (Three-Phase) | ee_lib/Semiconductors & Converters/Converters/AC-DC Converter (Three-Phase) | R2023a+ | Model a three-phase AC-DC converter with selectable topology — use for rectifier design, DC bus supply, or power electronics front-end studies |
| Average-Value Chopper | ee_lib/Semiconductors & Converters/Converters/Average-Value Chopper | R2023a+ | Model a DC chopper using average-value representation without switching — use for fast system-level simulation of DC motor drives or battery chargers |
| Average-Value Inverter (Three-Phase) | ee_lib/Semiconductors & Converters/Converters/Average-Value Inverter (Three-Phase) | R2023a+ | Model a three-phase inverter using average-value representation — use for fast motor drive or grid-tie inverter studies without switching transients |
| Average-Value Rectifier (Three-Phase) | ee_lib/Semiconductors & Converters/Converters/Average-Value Rectifier (Three-Phase) | R2023a+ | Model a three-phase rectifier using average-value representation — use for fast simulation of AC-DC conversion without individual diode switching events |
| Average-Value Voltage Source Converter | ee_lib/Semiconductors & Converters/Converters/Average-Value Voltage Source Converter | R2023a+ | Model a voltage source converter using average-value representation — use for fast simulation of grid-connected converters or HVDC studies |
| Average-Value Voltage Source Converter (Three-Phase) | ee_lib/Semiconductors & Converters/Converters/Average-Value Voltage Source Converter (Three-Phase) | R2023a+ | Model a three-phase VSC using average-value representation — use for grid integration studies, FACTS devices, or HVDC without switching detail |
| Average-Value DC-DC Converter | ee_lib/Semiconductors & Converters/Converters/Average-Value DC-DC Converter | R2023a+ | Model a DC-DC converter using average-value representation — use for fast system-level simulation of buck, boost, or buck-boost converters without switching ripple |
| Bidirectional DC-DC Converter | ee_lib/Semiconductors & Converters/Converters/Bidirectional DC-DC Converter | R2023a+ | Model a bidirectional DC-DC converter for two-way power flow — use for battery charge/discharge systems, regenerative braking, or energy storage interfaces |
| Boost Converter | ee_lib/Semiconductors & Converters/Converters/Boost Converter | R2023a+ | Model a boost DC-DC converter stepping voltage up — use for PV MPPT converters, battery-to-bus interfaces, or voltage step-up applications |
| Buck Converter | ee_lib/Semiconductors & Converters/Converters/Buck Converter | R2023a+ | Model a buck DC-DC converter stepping voltage down — use for point-of-load regulators, LED drivers, or battery charging from higher-voltage sources |
| Buck-Boost Converter | ee_lib/Semiconductors & Converters/Converters/Buck-Boost Converter | R2023a+ | Model a buck-boost DC-DC converter with inverted output — use for applications requiring output voltage above or below input voltage |
| Converter (Three-Phase) | ee_lib/Semiconductors & Converters/Converters/Converter (Three-Phase) | R2023a+ | Model a three-phase power converter with configurable switching devices — use for inverter, rectifier, or active front-end topologies with detailed switching |
| DC-DC Converter | ee_lib/Semiconductors & Converters/Converters/DC-DC Converter | R2023a+ | Model a generic DC-DC converter with selectable topology — use for power supply design, voltage regulation, or energy conversion between DC buses |
| Eight-Pulse Gate Multiplexer | ee_lib/Semiconductors & Converters/Converters/Eight-Pulse Gate Multiplexer | R2023a+ | Combine gate signals for an eight-pulse converter configuration — use with multi-pulse rectifier topologies for harmonic reduction |
| Four-Pulse Gate Multiplexer | ee_lib/Semiconductors & Converters/Converters/Four-Pulse Gate Multiplexer | R2023a+ | Combine gate signals for a four-pulse converter — use with single-phase bridge converters or H-bridge topologies |
| Four-Quadrant Chopper | ee_lib/Semiconductors & Converters/Converters/Four-Quadrant Chopper | R2023a+ | Model a full-bridge DC chopper operating in all four torque-speed quadrants — use for bidirectional DC motor drives with regenerative braking |
| H-Bridge | ee_lib/Semiconductors & Converters/Converters/H-Bridge | R2023a+ | Model a full H-bridge with four switching devices — use for single-phase inverters, DC motor drives, or bidirectional DC-DC conversion |
| Modular Multilevel Converter (Three-Phase) | ee_lib/Semiconductors & Converters/Converters/Modular Multilevel Converter (Three-Phase) | R2023a+ | Model a complete three-phase modular multilevel converter — use for HVDC, STATCOM, or high-voltage high-power conversion with many voltage levels |
| Modular Multilevel Converter Arm | ee_lib/Semiconductors & Converters/Converters/Modular Multilevel Converter Arm | R2023a+ | Model a single arm of a modular multilevel converter — use as a subcomponent for building custom MMC topologies or studying arm balancing |
| Modular Multilevel Converter Leg | ee_lib/Semiconductors & Converters/Converters/Modular Multilevel Converter Leg | R2023a+ | Model a single leg of a modular multilevel converter — use as a subcomponent for custom MMC configurations or phase-level analysis |
| One-Quadrant Chopper | ee_lib/Semiconductors & Converters/Converters/One-Quadrant Chopper | R2023a+ | Model a single-quadrant DC chopper for unidirectional speed/voltage control — use for simple DC motor drives or resistive load power regulation |
| Rectifier (Three-Phase) | ee_lib/Semiconductors & Converters/Converters/Rectifier (Three-Phase) | R2023a+ | Model a three-phase diode bridge rectifier — use for uncontrolled AC-DC conversion, DC bus supply in motor drives, or grid rectification |
| Six-Pulse Gate Multiplexer | ee_lib/Semiconductors & Converters/Converters/Six-Pulse Gate Multiplexer | R2023a+ | Combine gate signals for a six-pulse three-phase converter — use with standard three-phase bridge rectifiers or inverters |
| Three-Level Converter (Three-Phase) | ee_lib/Semiconductors & Converters/Converters/Three-Level Converter (Three-Phase) | R2023a+ | Model a three-phase three-level NPC or T-type converter — use for medium-voltage drives, grid-tie inverters, or applications needing reduced harmonic content |
| Twelve-Pulse Gate Multiplexer | ee_lib/Semiconductors & Converters/Converters/Twelve-Pulse Gate Multiplexer | R2023a+ | Combine gate signals for a twelve-pulse converter — use for high-power rectifier systems with phase-shifting transformers for harmonic cancellation |
| Two-Pulse Gate Multiplexer | ee_lib/Semiconductors & Converters/Converters/Two-Pulse Gate Multiplexer | R2023a+ | Combine gate signals for a two-pulse half-bridge converter — use with single-leg converters or half-bridge topologies |
| Two-Quadrant Chopper | ee_lib/Semiconductors & Converters/Converters/Two-Quadrant Chopper | R2023a+ | Model a two-quadrant DC chopper for motoring and regenerative braking — use for DC motor drives that need bidirectional current flow |
