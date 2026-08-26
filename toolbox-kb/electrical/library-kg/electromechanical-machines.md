---
type: Simulink Block Category
title: Electromechanical machines
description: Electric motors, generators, actuators, and machine subcomponents
tags: [motor, generator, pmsm, induction, actuator]
status: stable
source: mathworks_toolbox
library_root: Electrical
category_path: Electromechanical machines
block_count: 61
---

# Electromechanical machines

Use these blocks for electromechanical machines.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Converter (Three-Phase, DQ0) | ee_lib/DQ0 Components/Converters/Converter (Three-Phase, DQ0) | R2023a+ | Model a three-phase voltage source converter in the DQ0 rotating reference frame — use for fast-executing grid-connected inverter studies without switching details |
| Hybrid Excitation PMSM (DQ0) | ee_lib/DQ0 Components/Machines/Hybrid Excitation PMSM (DQ0) | R2023a+ | Model a hybrid-excitation permanent magnet synchronous machine in DQ0 frame — use for field-weakening studies of machines with both PM and wound-field excitation |
| Dynamic Load (Three-Phase, DQ0) | ee_lib/DQ0 Components/Passive/Dynamic Load (Three-Phase, DQ0) | R2023a+ | Model a three-phase dynamic load in the DQ0 reference frame — use for power system stability studies with frequency-dependent load behavior |
| Magnetic Rotor | ee_lib/Electromechanical/Magnetic Rotor | R2023b+ | Model the magnetic rotor assembly of an electric machine — use as a subcomponent for custom machine topologies with explicit rotor field modeling |
| Motor & Drive (System Level) | ee_lib/Electromechanical/Motor & Drive (System Level) | R2023a+ | Model a motor and drive as a combined system-level block with efficiency map — use for vehicle-level or system-level studies where drive detail is not needed |
| Rotating Air Gap | ee_lib/Electromechanical/Rotating Air Gap | R2023a+ | Model the magnetic air gap of a rotating machine — use as a subcomponent for custom machine topologies with explicit reluctance network modeling |
| Simplified Generator | ee_lib/Electromechanical/Simplified Generator | R2024a+ | Model a simplified synchronous generator with voltage behind reactance — use for power system studies where detailed machine dynamics are not critical |
| Wind Turbine (Mechanical) | ee_lib/Electromechanical/Wind Turbine (Mechanical) | R2023a+ | Model wind turbine aerodynamics as a mechanical torque source — use for wind energy conversion studies providing shaft torque to a generator model |
| FEM-Parameterized Induction Machine (Squirrel Cage) | ee_lib/Electromechanical/Asynchronous/FEM-Parameterized Induction Machine (Squirrel Cage) | R2023a+ | Model a squirrel-cage induction machine using flux maps from finite-element analysis — use for high-accuracy motor simulation capturing saturation and spatial harmonics |
| FEM-Parameterized Induction Machine (Wound Rotor) | ee_lib/Electromechanical/Asynchronous/FEM-Parameterized Induction Machine (Wound Rotor) | R2023a+ | Model a wound-rotor induction machine using FEM-derived flux maps — use for high-accuracy wound-rotor motor studies with saturation effects |
| Induction Machine (Single-Phase) | ee_lib/Electromechanical/Asynchronous/Induction Machine (Single-Phase) | R2023a+ | Model a single-phase induction motor with main and auxiliary windings — use for household appliances, fans, or pump drives with capacitor-start or split-phase starting |
| Induction Machine Measurement | ee_lib/Electromechanical/Asynchronous/Induction Machine Measurement | R2023a+ | Measure electrical and mechanical quantities of an induction machine — use to extract torque, speed, power, and current measurements from induction machine blocks |
| Induction Machine Squirrel Cage | ee_lib/Electromechanical/Asynchronous/Induction Machine Squirrel Cage | R2023a+ | Model a three-phase squirrel-cage induction machine — use for industrial motor drives, pump loads, or variable-frequency drive development |
| Induction Machine Wound Rotor | ee_lib/Electromechanical/Asynchronous/Induction Machine Wound Rotor | R2023a+ | Model a three-phase wound-rotor induction machine — use for slip-ring motors with external rotor resistance, doubly-fed generators, or soft-start applications |
| Simplified Induction Motor | ee_lib/Electromechanical/Asynchronous/Simplified Induction Motor | R2023a+ | Model an induction motor with simplified torque-speed characteristic — use for system-level load studies where detailed electromagnetic transients are not needed |
| Compound Motor | ee_lib/Electromechanical/Brushed Motors/Compound Motor | R2023a+ | Model a compound-wound DC motor with series and shunt field windings — use for applications requiring both series and shunt motor characteristics |
| DC Motor | ee_lib/Electromechanical/Brushed Motors/DC Motor | R2023a+ | Model a permanent-magnet or wound-field DC motor — use for DC drive systems, servo applications, or simple motor modeling with back-EMF and armature dynamics |
| RC Servo | ee_lib/Electromechanical/Brushed Motors/RC Servo | R2023a+ | Model a hobby-style RC servo motor with PWM input — use for robotics, model aircraft control surfaces, or simple position-controlled actuator modeling |
| Shunt Motor | ee_lib/Electromechanical/Brushed Motors/Shunt Motor | R2023a+ | Model a DC shunt motor with field winding in parallel with armature — use for constant-speed DC drives or field-weakening speed control studies |
| Universal Motor | ee_lib/Electromechanical/Brushed Motors/Universal Motor | R2023a+ | Model a series-wound universal motor operating on AC or DC — use for power tool, vacuum cleaner, or appliance motor modeling |
| Machine Inertia | ee_lib/Electromechanical/Mechanical/Machine Inertia | R2023a+ | Add rotational inertia to an electromechanical machine port — use to represent flywheel mass, load inertia, or coupling inertia on a machine shaft |
| Machine Mechanical Power | ee_lib/Electromechanical/Mechanical/Machine Mechanical Power | R2023a+ | Inject or extract mechanical power at a machine shaft — use to model a mechanical load or prime mover connected to an electrical machine |
| FEM-Parameterized Linear Actuator | ee_lib/Electromechanical/Mechatronic Actuators/FEM-Parameterized Linear Actuator | R2023a+ | Model a linear electromagnetic actuator using FEM-derived force maps — use for solenoid valve, linear motor, or voice coil actuator design with accurate force profiles |
| FEM-Parameterized Rotary Actuator | ee_lib/Electromechanical/Mechatronic Actuators/FEM-Parameterized Rotary Actuator | R2023a+ | Model a limited-angle rotary actuator using FEM-derived torque maps — use for high-accuracy torque motor or rotary solenoid design |
| Generic Linear Actuator | ee_lib/Electromechanical/Mechatronic Actuators/Generic Linear Actuator | R2023a+ | Model a generic electromagnetic linear actuator with parameterized force-stroke characteristics — use for solenoid, voice coil, or linear motor system-level studies |
| Generic Rotary Actuator | ee_lib/Electromechanical/Mechatronic Actuators/Generic Rotary Actuator | R2023a+ | Model a generic electromagnetic rotary actuator with parameterized torque-angle characteristics — use for torque motor or limited-angle actuator system studies |
| Piezo Bender | ee_lib/Electromechanical/Mechatronic Actuators/Piezo Bender | R2023a+ | Model a piezoelectric bending actuator — use for micro-positioning, MEMS actuators, or energy harvesting from vibration |
| Piezo Linear Actuator | ee_lib/Electromechanical/Mechatronic Actuators/Piezo Linear Actuator | R2023a+ | Model a piezoelectric linear actuator — use for nano-positioning stages, fuel injectors, or high-precision linear displacement applications |
| Piezo Rotary Actuator | ee_lib/Electromechanical/Mechatronic Actuators/Piezo Rotary Actuator | R2023a+ | Model a piezoelectric rotary actuator — use for precision angular positioning, optical mirror steering, or ultrasonic motor modeling |
| Piezo Stack | ee_lib/Electromechanical/Mechatronic Actuators/Piezo Stack | R2023a+ | Model a piezoelectric stack actuator — use for high-force short-stroke actuation, fuel injectors, or vibration control with stacked piezo elements |
| Solenoid | ee_lib/Electromechanical/Mechatronic Actuators/Solenoid | R2023a+ | Model an electromagnetic solenoid actuator with force-stroke-current characteristics — use for valve actuators, relay coils, or electromagnetic latch design |
| BLDC | ee_lib/Electromechanical/Permanent Magnet/BLDC | R2023a+ | Model a brushless DC motor with trapezoidal back-EMF — use for BLDC drive design, commutation logic development, or drone/robotics motor simulation |
| FEM-Parameterized PMSM | ee_lib/Electromechanical/Permanent Magnet/FEM-Parameterized PMSM | R2023a+ | Model a PMSM using flux linkage maps from finite-element analysis — use for high-accuracy motor simulation including saturation, cross-coupling, and cogging torque |
| Hybrid Excitation PMSM | ee_lib/Electromechanical/Permanent Magnet/Hybrid Excitation PMSM | R2023a+ | Model a PMSM with additional wound-field excitation for extended field-weakening range — use for EV traction motors or variable-flux machine studies |
| PMLSM | ee_lib/Electromechanical/Permanent Magnet/PMLSM | R2023a+ | Model a permanent-magnet linear synchronous motor — use for linear motion systems, maglev propulsion, or precision linear stage drives |
| PMSM | ee_lib/Electromechanical/Permanent Magnet/PMSM | R2023a+ | Model a three-phase permanent magnet synchronous machine — use for EV traction drives, servo motors, or high-performance variable-speed applications |
| PMSM (Five-Phase) | ee_lib/Electromechanical/Permanent Magnet/PMSM (Five-Phase) | R2023a+ | Model a five-phase PMSM — use for fault-tolerant drives, high-torque-density applications, or multiphase machine research |
| PMSM (Four-Phase) | ee_lib/Electromechanical/Permanent Magnet/PMSM (Four-Phase) | R2023a+ | Model a four-phase PMSM — use for specialized multiphase drives or redundant motor configurations |
| PMSM (Single-Phase) | ee_lib/Electromechanical/Permanent Magnet/PMSM (Single-Phase) | R2023a+ | Model a single-phase PMSM — use for small appliance motors, fan drives, or low-cost single-phase applications |
| PMSM (Six-Phase, Symmetrical) | ee_lib/Electromechanical/Permanent Magnet/PMSM (Six-Phase, Symmetrical) | R2023a+ | Model a six-phase symmetrical PMSM with 60-degree phase displacement — use for high-power traction, marine propulsion, or fault-tolerant drives |
| Stepper Motor | ee_lib/Electromechanical/Reluctance & Stepper/Stepper Motor | R2023a+ | Model a bipolar stepper motor with detent and holding torque — use for positioning systems, CNC machines, or open-loop motion control |
| Stepper Motor Driver | ee_lib/Electromechanical/Reluctance & Stepper/Stepper Motor Driver | R2023a+ | Drive a bipolar stepper motor with step and direction inputs — use as a controller for stepper motors with microstepping and current limiting |
| Switched Reluctance Machine | ee_lib/Electromechanical/Reluctance & Stepper/Switched Reluctance Machine | R2023a+ | Model a switched reluctance machine with nonlinear inductance profiles — use for SRM drive development, traction motors, or high-speed spindle drives |
| Switched Reluctance Machine (Multi-Phase) | ee_lib/Electromechanical/Reluctance & Stepper/Switched Reluctance Machine (Multi-Phase) | R2023a+ | Model a multi-phase switched reluctance machine — use for SRM drives with more than three phases for smoother torque or fault tolerance |
| Synchronous Reluctance Machine | ee_lib/Electromechanical/Reluctance & Stepper/Synchronous Reluctance Machine | R2023a+ | Model a synchronous reluctance machine — use for high-efficiency industrial drives without permanent magnets or for reluctance torque research |
| Unipolar Stepper Motor | ee_lib/Electromechanical/Reluctance & Stepper/Unipolar Stepper Motor | R2023a+ | Model a unipolar stepper motor with center-tapped windings — use for low-cost positioning systems with simplified drive electronics |
| Unipolar Stepper Motor Driver | ee_lib/Electromechanical/Reluctance & Stepper/Unipolar Stepper Motor Driver | R2023a+ | Drive a unipolar stepper motor with step and direction inputs — use as a controller for unipolar steppers with single-transistor switching per phase |
| FEM-Parameterized Synchronous Machine | ee_lib/Electromechanical/Synchronous/FEM-Parameterized Synchronous Machine | R2023a+ | Model a synchronous machine using FEM-derived flux maps — use for high-accuracy generator or motor studies capturing magnetic saturation effects |
| Simplified Synchronous Machine | ee_lib/Electromechanical/Synchronous/Simplified Synchronous Machine | R2023a+ | Model a synchronous machine with simplified voltage-behind-reactance representation — use for large power system studies with many generators |
| Simplified Synchronous Machine Measurement | ee_lib/Electromechanical/Synchronous/Simplified Synchronous Machine Measurement | R2023a+ | Measure quantities from a Simplified Synchronous Machine — use to extract terminal voltage, current, power, and angle from simplified generator models |
| Synchronous Machine (Six-Phase) | ee_lib/Electromechanical/Synchronous/Synchronous Machine (Six-Phase) | R2023a+ | Model a six-phase synchronous machine — use for high-power generation, ship propulsion, or multiphase generator systems |
| Synchronous Machine Field Circuit | ee_lib/Electromechanical/Synchronous/Synchronous Machine Field Circuit | R2023a+ | Model the field circuit of a synchronous machine for excitation control — use to supply DC field current and study voltage regulation or exciter dynamics |
| Synchronous Machine GENQEC | ee_lib/Electromechanical/Synchronous/Synchronous Machine GENQEC | R2023a+ | Model a synchronous machine using the GENQEC data format — use for power system stability studies with generator data in GENQEC standard form |
| Synchronous Machine GENROU | ee_lib/Electromechanical/Synchronous/Synchronous Machine GENROU | R2023a+ | Model a round-rotor synchronous machine using GENROU parameters — use for power system transient stability studies of turbo-generators |
| Synchronous Machine GENTPJ | ee_lib/Electromechanical/Synchronous/Synchronous Machine GENTPJ | R2023a+ | Model a synchronous machine using GENTPJ parameters — use for advanced stability studies with saturation-dependent subtransient modeling |
| Synchronous Machine Measurement | ee_lib/Electromechanical/Synchronous/Synchronous Machine Measurement | R2023a+ | Measure electrical and mechanical quantities of a synchronous machine — use to extract power angle, field current, terminal voltage, and power from SM blocks |
| Synchronous Machine Model 1.0 | ee_lib/Electromechanical/Synchronous/Synchronous Machine Model 1.0 | R2023a+ | Model a synchronous machine with classical Model 1.0 representation — use for basic transient stability studies with minimal parameter data |
| Synchronous Machine Model 2.1 | ee_lib/Electromechanical/Synchronous/Synchronous Machine Model 2.1 | R2023a+ | Model a synchronous machine with Model 2.1 representation — use for subtransient stability studies with d-axis and q-axis damper windings |
| Synchronous Machine Round Rotor | ee_lib/Electromechanical/Synchronous/Synchronous Machine Round Rotor | R2023a+ | Model a round-rotor synchronous machine with full electromagnetic detail — use for turbo-generator simulation, excitation studies, or detailed machine analysis |
| Synchronous Machine Salient Pole | ee_lib/Electromechanical/Synchronous/Synchronous Machine Salient Pole | R2023a+ | Model a salient-pole synchronous machine with full electromagnetic detail — use for hydro-generator simulation or salient-pole motor drives |
| Vectorized Synchronous Machine GENROU | ee_lib/Electromechanical/Synchronous/Vectorized Synchronous Machines/Vectorized Synchronous Machine GENROU | R2023a+ | Model multiple GENROU synchronous machines as a vectorized array — use for large power system studies with many identical or similar generators |
